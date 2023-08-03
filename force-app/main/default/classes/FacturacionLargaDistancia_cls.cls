/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  luis Eduardo Mogollon
Proyecto:               Integracion SFDC - RevChain Larga Distancia
Descripci?n:            clase que contiene los metodos para realizar la facturacion 
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion 
------  ----------  --------------------        ---------------
1.0     19-05-2015  Luis E Mogollon (LEM)       Creacion de la clase..
1.1     23-10-2015  Manuel Medina (MM)          Se modifica el metodo crearCuentaRevChain() 
1.2     23-06-2016  Carlos Gonzalez (CG)       	Adaptación Linea Vs Parametro.
*******************************************************************************/
            /*
            list<OperacionComercial__c> lstOC = [Select id,CuentaFacturacion__c,CuentaFacturacion__r.Name, planLD__c from OperacionComercial__c where id = 'a08f00000036C3l'];

ConstruccionCanonico_cls objCanonico = new ConstruccionCanonico_cls();
objCanonico.CrearFacturacion(lstOC);
            
            */
            
public class FacturacionLargaDistancia_cls {
    
    
  private map<string,string> valores = new map<string,string>();
  private map<string,string> mapCuentasFact = new map<string,string>();
  private string strNombreCtaTemp = ''; 
  private string strIdCtaTemp = '';
  private string strResultCode = '';
  private string strResultDescription = '';
  private String strCodCuentaFacturacion ='';
  private list<LogTransacciones__c> lstLogTransaccion = new list<LogTransacciones__c>();
  private list<CuentaFacturacion__c> lstCuentasFacturacionUpdate = new list<CuentaFacturacion__c>();
  private list<OperacionComercial__c> lstOperacionesComercialesUpdate = new list<OperacionComercial__c>();
  private PlanLD__c planMundo;
  /* BEGIN - Manuel Medina - Definicion de las lineas que seran actualizadas - 26102015 */
  //private List<Linea__c> lstLineasUpdate = new List<Linea__c>();
  private Map<String, Linea__c> mapLineasXId = new Map<String, Linea__c>();
  /* END - Manuel Medina - Definicion de las lineas que seran actualizadas - 26102015 */

  map<string,list<OperacionComercial__c>> mapOC = new map<string,list<OperacionComercial__c>>();
  map<string,PlanLD__c> mapPlanesFacturacion = new map<string,PlanLD__c>();
  map<string,Account> mapcuentas = new map<string,Account>();    
  private Map<String,String> mapLineasVSParam = new Map<String,String>(); // [CG] Almacena la relación Activo-Linea con Parametro
  
  //[FS, Jerarquia de cuentas 2020-04-02]:	Declaraciones para integración de WS de jerarquía de cuentas
  private map<string,string> 			mapRtaRMCA_MDM				= new map<string,string>();    
  private list<CuentaFacturacion__c> 	lstCtasFactUpdRtaRMCA_MDM 	= new list<CuentaFacturacion__c>();
  private String strResultCodeMDM									= '';  
  private String strResultDescriptionMDM 							= '';  
  //FIN [FS, Jerarquia de cuentas 2020-04-02]
   
//Metodo que retorma toda la informacion de las operaciones comerciales relacioandas con el proceso de larga distancia.
    
public map<string,list<OperacionComercial__c>> OperacionesComerciales(set<string> idsOC)
{
    //llama los datos de la cuenta dentro del activo,y planes
    map<string,list<OperacionComercial__c>> listOC = new map<string,list<OperacionComercial__c>>();
    set<string> cuentas = new set<String>();

    //[AG: 2016-02-15:  se quitó el campo “o.CuentaFacturacion__r.LTE_DireccionFacturacion__c”]
    //[AG: 2016-06-08: se incluye el campo "o.Activo__r.ExternalServiceID__c" en el query para enviarlo en los tramites de Retiro y Cambio de plan]
    
    //[FS, Jerarquia de cuentas 2020-04-02]: Se incluyen campos adicionales para jerarquía:
    for(OperacionComercial__c OC :[Select o.CuentaFacturacion__r.CreatedBy.Username, o.CuentaFacturacion__r.TipoFactura__c, o.TOPP__r.TipodeOperacionPorPlan__c,o.CuentaCliente__c,o.FechadeActivacion__c, o.Activo__r.Plan_Larga_Distancia_Anterior__c, o.CuentaFacturacion__r.Fin_de_consumo__c,o.CuentaCliente__r.Name,o.CuentaCliente__r.AccountNumber,o.CuentaFacturacion__c, o.CuentaFacturacion__r.Id, o.CuentaFacturacion__r.Name, o.CuentaFacturacion__r.Cliente__c, o.CuentaFacturacion__r.LTE_CuentaFacturacionPadre__c, o.CuentaFacturacion__r.Facturable__c, o.CuentaFacturacion__r.LTE_MetodoEnvio__c, o.CuentaFacturacion__r.LTE_CicloFacturacion__c, o.CuentaFacturacion__r.LTE_Email__c, o.CuentaFacturacion__r.LTE_DireccionAlterna__c, o.CuentaFacturacion__r.LTE_DepartamentoFacturacion__c, o.CuentaFacturacion__r.Ciudad__c, o.CuentaFacturacion__r.LTE_DepartamentoAlterno__c, o.CuentaFacturacion__r.TaxPlan__c, o.CuentaFacturacion__r.LTE_CiudadAlterna__c, o.CuentaFacturacion__r.LTE_NombreCuentaFacturacion__c, o.CuentaFacturacion__r.Nombre__c, o.CuentaFacturacion__r.LTE_CuentaFacturacionLTE__c, o.CuentaFacturacion__r.CodCicloFac__c, o.CuentaFacturacion__r.Cliente__r.Name, o.CuentaFacturacion__r.Cliente__r.Tipodedocumento__c, o.CuentaFacturacion__r.Cliente__r.Phone, o.CuentaFacturacion__r.Cliente__r.AccountNumber, o.CuentaFacturacion__r.Fue_creada_en_revchain__c, o.CuentaFacturacion__r.LTE_PendienteModificacion__c, o.CuentaFacturacion__r.LTE_CuentaFacturacionPadre__r.Name, o.CuentaFacturacion__r.LTE_CuentaFacturacionPadre__r.Fue_creada_en_revchain__c,o.NumerodeConvenio__c,o.PlanLD__c,o.plan__r.NombredelProducto__r.Name, o.CuentaCliente__r.Ciudad__c,Valor_Equipos__c,Valor_unica_Vez_Aliado__c, CuentaFacturacion__r.Ciudad__r.Name, CuentaFacturacion__r.Ciudad__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c, o.Activo__r.Name, o.CuentaCliente__r.Segmento__c, CuentaCliente__r.Ciudad__r.Name, o.CuentaCliente__r.Direccion__c, o.CuentaCliente__r.Ciudad__r.CodigoDane__c, o.CuentaCliente__r.Ciudad__r.Indicativo__c, o.CuentaCliente__r.Tipodedocumento__c, o.Oportunidad__r.CreatedDate, o.CuentaCliente__r.Phone, o.Activo__r.NombredelProducto__r.PremisasFacturacion__c, o.Activo__r.NombredelProducto__r.CodigoFacturacion__c, o.Legalizacion__r.Contrato__r.Forma_de_Pago__c, o.CuentaCliente__r.SubSegmento__c, o.Legalizacion__r.Contrato__r.PlazoPago__c, o.CuentaFacturacion__r.DirCorresp__c, o.moneda__c, o.Activo__r.ExternalServiceID__c, (Select Id, IsDeleted, CancelarDescuento__c, Name, Linea_ETB__c, Operacion_Comercial_Anterior__c, Cuenta_suscriptora__c, Cuenta_Facturacion__c, ActivoLargaDistancia__c, Empresa_perteneciente__c, Plan__c, Operacion_Comercial_Actual__c, Tipo__c, Activo__c, Plan_Anterior__c, Activo_Larga_Distancia_Anterior__c, Plan_convenio__c, Plan_convenio_anterior__c, planLD__c, CorrelationId__c, Ciclo__c, planLD_anterior__c, CrearLSP__c, TrasladarActivo__c, OperacionComercialTramite__c, CuentaFacturacionAnterior__c, ExternalID__c, CancelarCupo__c From Operacion_Comercial_Actual__r) From OperacionComercial__c o where o.id in :idsOC])    
    {
        cuentas.add(OC.cuentaCliente__c);
        //determinar el producto cupo, convenio de voz red inteligente
        if(OC.plan__r.NombredelProducto__r.Name==label.ProductoCupo)
        {
            if(listOC.containsKey('cupo'))
            {
                list<OperacionComercial__c> lista = listOC.get('cupo');
                lista.add(OC);
                listOC.put('cupo',lista);
            }
            else
            {
                list<OperacionComercial__c> lista = new list<OperacionComercial__c>();
                lista.add(OC);
                listOC.put('cupo',lista);
                
            }
        }
        
        else if(OC.plan__r.NombredelProducto__r.Name==label.ProductoVoz)
        {
            if(listOC.containsKey('voz'))
            {
                list<OperacionComercial__c> lista = listOC.get('voz');
                lista.add(OC);
                listOC.put('voz',lista);
            }
            else
            {
                list<OperacionComercial__c> lista = new list<OperacionComercial__c>();
                lista.add(OC);
                listOC.put('voz',lista);
                
            }
        }
        
        
    
    }
    //llena el mapa de los planes
    
    return listOC;
}

//metodo que retorna los planes de facturacion para cada uno de los planes de las OC involucradas en el proceso
public map<string,PlanLD__c> mapFacturacion(set<string> idPlanesSFDC)
{
    map<string,PlanLD__c> mapPlanes = new map<string,PlanLD__c>();
    for(PlanLD__c plan :[Select p.Servicio__c, p.Producto__c,p.Name, p.PlanFacturacion__c, (select Name,Tipo__c,ProductoLD__c From Sub_Planes_Facturaci_n__r) From PlanLD__c p where id in :idPlanesSFDC ])
    {
        mapplanes.put(plan.id,plan);
    }
    return mapPlanes;
}

public map<string,Account> MapCuentas(set<String> cuentas)
{
    return new map<string,Account>([SELECT AccountNumber,Actividad_Economica__c,Ciudad__c,Name,Phone,RazonSocial__c,Segmento__c,SubSegmento__c,Tipodedocumento__c FROM Account  where id in :cuentas]);
}


public map<string,list<ParametroFacturacion__c>> MapSubPlanesFac (set<string> idsubPlanesFac)
{
    //devuelve los subplanes y parametros
    map<string,list<ParametroFacturacion__c>> mapSubPlanesFac = new map<string,list<ParametroFacturacion__c>>();
    list<SubPlanFacturacion__c> lstSubplanes = [Select p.id,(Select Name, Objeto__c, Campo__c,Comillas__c,Obligatorio__c From Parametros_de_Facturacion__r) From SubPlanFacturacion__c p where id in :idsubPlanesFac ];
    for(SubPlanFacturacion__c subplan : lstSubplanes)
    {
        list<ParametroFacturacion__c> lstParam = new list<ParametroFacturacion__c>();
        for(ParametroFacturacion__c param : subplan.Parametros_de_Facturacion__r)
        {
            lstParam.add(param);
        }
        mapSubPlanesFac.put(subplan.id,lstParam);
    }
    return mapSubPlanesFac;
}
    
//Metodo que realizar? la validaci?n de los productos para realizar la facturaci?n.
//ConstruccionCanonico_cls Canonico = new ConstruccionCanonico_cls();

public boolean validacionFacturacion(OperacionComercial__c OC)
{
    boolean valido=false;
    // la operacion comercial debe tener diligenciado el valor de
    if(OC.PlanLD__c!=null)
    {
        valido=true;
    }
    return valido;
}   

//metodo que realiza el armado de la facturacion organiza por tipo
public void FacturacionLargaDistancia(list<OperacionComercial__c> listOC)
{
    //trae las operaciones comerciales
    set<string> idOC = new set<string>();
    set<string> idplanes = new set<string>();
    set<string> idcuentas = new set<string>();
    
    map<string,list<string>> mapCanonicos = new map<string,list<string>>();
    
    for(OperacionComercial__c OC :listOC)
    {
        idOC.add(OC.id);
        if(OC.planLD__c != null)
        	idplanes.add(OC.planLD__c);
        if(OC.Activo__r.Plan_Larga_Distancia_Anterior__c != null)
        	idplanes.add(OC.Activo__r.Plan_Larga_Distancia_Anterior__c);
        idcuentas.add(OC.cuentaCliente__c);
        
    }
    
    // se llama el plan mundo que se coloca dentro de los planes.
    planMundo = planMundo();
    idplanes.add(planMundo.id);
    //Crea y llena los maps
    mapOC = OperacionesComerciales(idOC);
    mapPlanesFacturacion = mapFacturacion(idplanes);
    mapcuentas = MapCuentas(idCuentas);
    
    
    //LLena set con id de subplan para luego obtener map de parametros
    set<String> idSubPlanes = new set<String>();
     
    for(PlanLd__c planLd : mapPlanesFacturacion.values()){
        for(SubPlanFacturacion__c subPlan :planLd.Sub_Planes_Facturaci_n__r){
           idSubPlanes.add(subPlan.id);
        }
    }
    
    map<string,list<ParametroFacturacion__c>> subPlanesFac = MapSubPlanesFac(idSubPlanes);
    
    
    
    if(mapOC.containskey('cupo'))
    {
        for(OperacionComercial__c OC :mapOC.get('cupo'))
        {
            // comenzar a ejecutar por cada tramite. llama el método validaciontramite
                
            validaciontramite( OC, 'cupo',mapPlanesFacturacion,mapcuentas,subPlanesFac);

        }
    }
    if(mapOC.containskey('voz'))
    {
        for(OperacionComercial__c OC :mapOC.get('voz'))
        {
            // comenzar a ejecutar por cada tramite. llama el método validaciontramite  
            validaciontramite( OC, 'voz',mapPlanesFacturacion,mapcuentas,subPlanesFac);
        }
    }

    
    if(lstCuentasFacturacionUpdate!=null && lstCuentasFacturacionUpdate.Size()>0){
       update lstCuentasFacturacionUpdate;
    }    
    //[FS, Jerarquia de cuentas 2020-04-02]: Actualización de lista de cuenta de facturación con información de la integración con RMCA y MDM 	
    if(lstCtasFactUpdRtaRMCA_MDM.size()>0)
        update lstCtasFactUpdRtaRMCA_MDM;  
    
    if(lstOperacionesComercialesUpdate!=null && lstOperacionesComercialesUpdate.Size()>0){
       update lstOperacionesComercialesUpdate;
    }
    
    if(lstLogTransaccion!=null && lstLogTransaccion.Size()>0){
       insert lstLogTransaccion;
    }

	// [CG] Obtiene el parametro del Activo-Linea
	getMapeoLineaVSParametro();
    
    /* BEGIN - Manuel Medina - Actualizacion de las lineas teniendo en cuenta la respuesta de RevChain - 26102015 */
    if( mapLineasXId != null && !mapLineasXId.isEmpty() ){
        /* BEGIN - Manuel Medina - Prueba actualizacion lineas - 10112015 */
        try{
            update obtenerLineasServicio();
        }catch( Exception e ){
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
            update mapLineasXId.values();
        }
        /* END - Manuel Medina - Prueba actualizacion lineas - 10112015 */
    }
    /* END - Manuel Medina - Actualizacion de las lineas teniendo en cuenta la respuesta de RevChain - 26102015 */
    
    
}

/**
* @Method:      obtenerLineasServicio
* @param:       N/A
* @Description: Obtener las lineas del servicio para ser actualizadas.
* @author       Manuel Medina - 06112015
*/
public List<Linea__c> obtenerLineasServicio(){
    
    Set<String> setIdServicios                  = new Set<String>();
    
    for( String strKey : mapOC.keySet() ){
        for( OperacionComercial__c objOperacionComercial : mapOC.get( strKey ) ){
            setIdServicios.add( objOperacionComercial.Activo__c );
        }
    }
    
    List<Linea__c> lstLineasExistentes              = new List<Linea__c>();
    lstLineasExistentes                             = [SELECT Id, IsDeleted, CancelarDescuento__c, 
                                                            Name, Linea_ETB__c, Operacion_Comercial_Anterior__c, 
                                                            Cuenta_suscriptora__c, Cuenta_Facturacion__c, ActivoLargaDistancia__c, 
                                                            Empresa_perteneciente__c, Plan__c, Operacion_Comercial_Actual__c, 
                                                            Tipo__c, Activo__c, Plan_Anterior__c, 
                                                            Activo_Larga_Distancia_Anterior__c, Plan_convenio__c, Plan_convenio_anterior__c, 
                                                            planLD__c, CorrelationId__c, Ciclo__c, 
                                                            planLD_anterior__c, CrearLSP__c, TrasladarActivo__c, 
                                                            OperacionComercialTramite__c, CuentaFacturacionAnterior__c, ExternalID__c, 
                                                            CancelarCupo__c 
                                                        FROM Linea__c
                                                        WHERE Activo__c IN: setIdServicios
                                                    ];
    
    List<Linea__c> lstLineas                        = new List<Linea__c>();
    Map<String, Linea__c> mapLineaXNumeroLinea      = new Map<String, Linea__c>();
    for( Linea__c rowLineaExistente : lstLineasExistentes ){
        mapLineaXNumeroLinea.put( rowLineaExistente.Name, rowLineaExistente );
    }
    
    for( Linea__c rowLineaXId : mapLineasXId.values() ){
        if( mapLineaXNumeroLinea.containsKey( rowLineaXId.Name ) ){
            Linea__c objLinea                       = new Linea__c();
            objLinea                                = mapLineaXNumeroLinea.get( rowLineaXId.Name );
            objLinea.ExitosoRevChain__c             = rowLineaXId.ExitosoRevChain__c;
            objLinea.ActivaServicioLD__c            = rowLineaXId.ActivaServicioLD__c;
            objLinea.Cuenta_Facturacion__c          = rowLineaXId.Cuenta_Facturacion__c;
            objLinea.Plan__c                        = rowLineaXId.Plan__c;
            objLinea.Plan_Anterior__c               = rowLineaXId.Plan_Anterior__c;
            objLinea.Plan_convenio__c               = rowLineaXId.Plan_convenio__c;
            objLinea.Plan_convenio_anterior__c      = rowLineaXId.Plan_convenio_anterior__c;
            objLinea.Cuenta_Facturacion__c          = rowLineaXId.Cuenta_Facturacion__c;
            objLinea.CuentaFacturacionAnterior__c   = rowLineaXId.CuentaFacturacionAnterior__c;
            objLinea.Operacion_Comercial_Anterior__c= rowLineaXId.Operacion_Comercial_Anterior__c;
            objLinea.ExternalID__c                  = rowLineaXId.ExternalID__c;
            lstLineas.add( objLinea );
        }
    }
    
    return lstLineas;
}

/**
* @Method:      getMapeoLineaVSParametro
* @param:       N/A
* @Description: Obtener el parametro respectivo de cada linea.
* @author       Carlos Gonzalez - 24-06-2016
*/
public List<Linea__c> getMapeoLineaVSParametro(){
	// [CG] Obtiene el parametro del Activo-Linea
    List<Linea__c> lstLineas = new List<Linea__c>();
    Set<String> setIdServicios = new Set<String>();
    Set<String> setIdPlanesLD = new Set<String>();
    mapLineasVSParam = new Map<String,String>();
    
    for( String strKey : mapOC.keySet() ){
        for( OperacionComercial__c objOperacionComercial : mapOC.get( strKey ) ){
            setIdServicios.add( objOperacionComercial.Activo__c );
        }
    }
    
    List<Linea__c> lstLineasExistentes              = new List<Linea__c>();
    lstLineasExistentes                             = [SELECT Id, Name, Operacion_Comercial_Actual__r.PlanLD__c                                                            
                                                        FROM Linea__c
                                                        WHERE Activo__c IN: setIdServicios
                                                    ];
    
    for( Linea__c rowLineaXId : lstLineasExistentes )
    {
    	setIdPlanesLD.add(rowLineaXId.Operacion_Comercial_Actual__r.PlanLD__c);
    }

	List<SubPlanFacturacion__c> lstSubPlanFacturacion = [SELECT PlanLD__c, Name, Tipo__c  FROM SubPlanFacturacion__c WHERE PlanLD__c IN: setIdPlanesLD];
	
	for(SubPlanFacturacion__c objSPF : lstSubPlanFacturacion)
	{
		String strKey = objSPF.Tipo__c; // EL Tipo puede ser '01800' o 'A y A'		
		strKey = strKey + objSPF.PlanLD__c;
		mapLineasVSParam.put(strKey,objSPF.Name);
	}
    
    System.debug('Entro a getMapeoLineaVSParametro='+lstLineasExistentes.size() );
    for( Linea__c rowLineaXId : lstLineasExistentes ){
        Linea__c objLinea = rowLineaXId;      
        String strKey = rowLineaXId.Name;
        if(strKey.startsWith('800') || strKey.startsWith('1800') || strKey.startsWith('01800') )
        {
        	strKey = '01800' + rowLineaXId.Operacion_Comercial_Actual__r.PlanLD__c; 
        }
        else
        {
        	strKey = 'A y A' + rowLineaXId.Operacion_Comercial_Actual__r.PlanLD__c; 
        }
        
        objLinea.SubPlanFacturacion__c = ( mapLineasVSParam.containsKey(strKey) ? mapLineasVSParam.get(strKey) : ''  );
        
        lstLineas.add( objLinea );
    }
    if(lstLineas.size() > 0)
    {
    	update lstLineas;
    }
    return lstLineas;
}


//metodo que ayuda a hacer la validacion para determinar el tramite y ejecutarlo.
public list<string> validaciontramite(OperacionComercial__c OC,string producto,map<string,PlanLD__c> mapFacturacion,map<string,Account> mapCuentas, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
{
    System.debug('\n\n Facturacion LD Valida tramite :: '+OC);
    
    //dependiendo del tipo de operacion por plan debe llamar el tramite
    TramitesLargaDistancia_cls tramite = new TramitesLargaDistancia_cls();
    list<string> canonicostemp = new list<string>();
    
    if(producto=='cupo')
    {
        if(OC.TOPP__r.TipodeOperacionporPLan__c=='Venta') // se debe invocar la creacion de la cuenta.
        {
            System.debug('\n\n Facturacion LD - Operacion:  VENTA CUPO');
            
            //Campos requeridos por el tramite
            if(OC.PlanLD__c==null){
                OC.EnvioFacturacion__c=false;
                OC.Estado__c='Pendiente Informacion Facturacion';
                lstOperacionesComercialesUpdate.add(OC);
                return canonicostemp;
            }
            //validar sobre la OC si la cuenta facturacion existe en revchain, si no llamr enviarCuentaRevchain(CuentaFacturacion__c objCta,String padreHIja) de la calse LTE_SincronizacionCtasFact_Revchain_cls
            
            if(!oc.CuentaFacturacion__r.Fue_creada_en_revchain__c){
                
                //Llama servicio para crear cuenta en RevChain
                crearCuentaRevChain(oc, mapCuentas.get(OC.CuentaCliente__c));
                
            }else{
              strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            }
            
            
            //Se consulta la cuenta facturacion para saber si tiene asociado cupo
            System.debug('\n\n Facturacion LD código RevChain cuenta Facturacíon '+strCodCuentaFacturacion);
            ServiciosWeb__c sw;
            sw = ServiciosWeb__c.getValues('LDConsultaAccountId');
            Map<string,string> mapResponse=new Map<string,string>();
            mapResponse.put('correlationID',GeneracionCorrelationID('CTFC',1));
            mapResponse.put('NumerosConsulta',strCodCuentaFacturacion);   
            
            Boolean blnCuentaFactYaTieneCupo = false;
            try{
                //consumo del WS expuesto por RevChain para la consulta de Lineas/cuentas
                String response='';
                String request=LargaDistanciaXML_cls.ConexionCuenta(mapResponse);
                System.debug('\n\n-request Consulta cuenta- ->'+request); 
                response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
                System.debug('\n\n-response Consulta cuenta- ->'+response);
                tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
                mapResponse.putAll(proReq.getMap(response));    
                String respuesta = mapResponse.get('return');
                
                ObjLinea_cls objRespuestaJson = ObjLinea_cls.parse(respuesta);
                System.debug('\n\n respuesta JSON Consulta cuenta->'+objRespuestaJson);
                
                if(String.isBlank(objRespuestaJson.service_particulars[0].rate_plan_name_cupo)){
                   blnCuentaFactYaTieneCupo = false;
                }else{
                   blnCuentaFactYaTieneCupo = true;
                }
            
            }
            catch(Exception e){
                System.debug('\n\n-Error en consulta de cuenta revChain'+e.getMessage()+'\n'+e.getStackTraceString());
            }           
            
            canonicostemp=tramite.VentaCupo(OC,mapfacturacion.get(OC.PlanLD__c),mapCuentas.get(OC.CuentaCliente__c), blnCuentaFactYaTieneCupo, strCodCuentaFacturacion, mapSubPlanesfac);
            
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null' && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }

                 
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
            
        }
        else if(OC.TOPP__r.TipodeOperacionporPLan__c=='Retiro')
        {
            System.debug('\n\n Facturacion LD - Operacion:  RETIRO CUPO');
            
            strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            
            canonicostemp=tramite.retiroCupo(OC,planMundo,mapCuentas.get(OC.CuentaCliente__c), strCodCuentaFacturacion, mapSubPlanesfac);
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
            
        }
        else if(OC.TOPP__r.TipodeOperacionporPLan__c=='Cambio de Plan')
        {
            System.debug('\n\n Facturacion LD - Operacion:  CAMBIO PLAN CUPO');
            
            //Campos requeridos por el tramite
            if(OC.PlanLD__c==null || OC.Activo__r.Plan_Larga_Distancia_Anterior__c == null){
                OC.EnvioFacturacion__c=false;
                OC.Estado__c='Pendiente Informacion Facturacion';
                lstOperacionesComercialesUpdate.add(OC);
                return canonicostemp;
            }
            
            strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            
            canonicostemp=tramite.cambioplanCupo(OC,mapfacturacion.get(OC.PlanLD__c), mapfacturacion.get(OC.Activo__r.Plan_Larga_Distancia_Anterior__c) ,mapCuentas.get(OC.CuentaCliente__c), strCodCuentaFacturacion, mapSubPlanesfac);
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
        }
        else if(OC.TOPP__r.TipodeOperacionporPLan__c=='Exclusión Lineas de LD')
        {
            System.debug('\n\n Facturacion LD - Operacion:  EXCLUSION LINEAS CUPO');
            
            strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            
            canonicostemp=tramite.RetiroLineasCupo(OC,planMundo,mapCuentas.get(OC.CuentaCliente__c), strCodCuentaFacturacion, mapSubPlanesfac);
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
        }
        else if(OC.TOPP__r.TipodeOperacionporPLan__c=='Adición Lineas de LD')
        {
            System.debug('\n\n Facturacion LD - Operacion:  ADICION LINEAS CUPO');
            
            //Campos requeridos por el tramite
            if(OC.PlanLD__c==null){
                OC.EnvioFacturacion__c=false;
                OC.Estado__c='Pendiente Informacion Facturacion';
                lstOperacionesComercialesUpdate.add(OC);
                return canonicostemp;
            }
            
            strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            
            canonicostemp=tramite.AdicionLineasCupo(OC,mapfacturacion.get(OC.PlanLD__c),mapCuentas.get(OC.CuentaCliente__c), strCodCuentaFacturacion, mapSubPlanesfac);
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
        }
            
    }
    else if (producto=='voz')
    {
        if(OC.TOPP__r.TipodeOperacionporPLan__c=='Venta') // se debe invocar la creacion de la cuenta.
        {
            
            //Campos requeridos por el tramite
            if(OC.PlanLD__c==null){
                OC.EnvioFacturacion__c=false;
                OC.Estado__c='Pendiente Informacion Facturacion';
                lstOperacionesComercialesUpdate.add(OC);
                return canonicostemp;
            }
            
            /* BEGIN - Manuel Medina - Implementacion de la creacion de una cuenta de facturacion - 03112015 */
            if(!oc.CuentaFacturacion__r.Fue_creada_en_revchain__c){
                
                //Llama servicio para crear cuenta en RevChain
                crearCuentaRevChain(oc, mapCuentas.get(OC.CuentaCliente__c));
                
            }else{
                strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            }
            
            //strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            /* END - Manuel Medina - Implementacion de la creacion de una cuenta de facturacion - 03112015 */
            
            ServiciosWeb__c sw;
            sw = ServiciosWeb__c.getValues('LDConsultaAccountId');
            Map<string,string> mapResponse=new Map<string,string>();  
            
                     
            canonicostemp=tramite.VentaConvenio(OC,mapfacturacion.get(OC.PlanLD__c),mapCuentas.get(OC.CuentaCliente__c), strCodCuentaFacturacion, mapSubPlanesfac);
            
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
        }
        else if(OC.TOPP__r.TipodeOperacionporPLan__c=='Retiro')
        {
            
            strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            
            canonicostemp=tramite.retiroConvenio(OC,planMundo,mapCuentas.get(OC.CuentaCliente__c), strCodCuentaFacturacion, mapSubPlanesfac);
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
            
        }
        else if(OC.TOPP__r.TipodeOperacionporPLan__c=='Cambio de Plan')
        {
            
            //Campos requeridos por el tramite
            if(OC.PlanLD__c==null){
                OC.EnvioFacturacion__c=false;
                OC.Estado__c='Pendiente Informacion Facturacion';
                lstOperacionesComercialesUpdate.add(OC);
                return canonicostemp;
            }
            
            strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            
            canonicostemp=tramite.cambioplanconvenio(OC,mapfacturacion.get(OC.PlanLD__c),mapCuentas.get(OC.CuentaCliente__c), strCodCuentaFacturacion, mapSubPlanesfac);
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
        }
        else if(OC.TOPP__r.TipodeOperacionporPLan__c=='Exclusión Lineas de LD')
        {
            strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            
            canonicostemp=tramite.RetiroLineasConvenio(OC,planMundo,mapCuentas.get(OC.CuentaCliente__c), strCodCuentaFacturacion, mapSubPlanesfac);
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
        }
        else if(OC.TOPP__r.TipodeOperacionporPLan__c=='Adición Lineas de LD')
        {
            
            //Campos requeridos por el tramite
            if(OC.PlanLD__c==null){
                OC.EnvioFacturacion__c=false;
                OC.Estado__c='Pendiente Informacion Facturacion';
                lstOperacionesComercialesUpdate.add(OC);
                return canonicostemp;
            }
            
            strCodCuentaFacturacion = oc.CuentaFacturacion__r.Name;
            
            //se usa venta porque son las mismas operaciones para el convenio.
            canonicostemp=tramite.AdicionLineasConvenio(OC,mapfacturacion.get(OC.PlanLD__c),mapCuentas.get(OC.CuentaCliente__c), strCodCuentaFacturacion, mapSubPlanesfac);
            for(String strCanonico : canonicostemp){
                if(string.isNotBlank(strCanonico)){
                    
                    String tipoOperacion=strCanonico.substringBefore('@**Separator**@');
                    String trama=strCanonico.substringAfter('@**Separator**@');
                    
                    if(String.isNotBlank(trama) && trama != 'null'){
                         if(!llamadoServicioWebLargaDistancia(trama, OC, tipoOperacion)){
                             OC.Estado__c='No Exitoso Facturacion';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                             break;
                         }else{
                             OC.Estado__c='Facturado';
                             OC.EnvioFacturacion__c=false;
                             OC.FechaFacturacion__c=system.now();
                         
                         }
                    }
                }
            }
            
            lstOperacionesComercialesUpdate.add(OC);
        }
        
    }
    return canonicostemp;
}



public boolean llamadoServicioWebLargaDistancia(string cadena, OperacionComercial__c OC, string nombreOperacion)
{
    boolean result = true;
    system.debug('\n\n request WS Larga Distancia: '+ cadena);
    map<string,string>mapRespuestas = new map<string,string>();
    ServiciosWeb__c sw = ServiciosWeb__c.getValues('RevChain');
    tibcoXml_cls tXml=new tibcoXml_cls();

    string response=LibreriaUtilitariaJobs_cls.consultarServicio(cadena,sw.Action__c,sw.EndPoint__c);
    system.debug('\n\n response WS Larga Distancia: '+ response);
    
        
    try{
        Dom.Document doc = new Dom.Document();
                doc.load(response);
                mapRespuestas =recuperarRespuestaXML(doc);
    }
    catch(system.Exception e)
    {
        system.debug('Error');
        generarLogFacturacionLD( OC.id,cadena, response, 'Fallida',  nombreOperacion);
        return false;
    }
    system.debug('\n\n map response WS Larga Distancia: '+ mapRespuestas);
    
    
    if(mapRespuestas.values().Size()==0){
       result = false;
    }else{
        for(String strResultado : mapRespuestas.values()){
           if(strResultado != 'SUCCESS' && strResultado != 'PASS'){
               result = false;
           }
        }
        
        /* BEGIN - Manuel Medina - Modificacion de las lineas a ser actualizadas teniendo en cuenta la respuesta de RevChain - 26102015 */
        for( Linea__C linea : OC.Operacion_Comercial_Actual__r ){
            if( mapRespuestas.containsKey( linea.ExternalID__c )
                && mapRespuestas.get( linea.ExternalID__c ).equalsIgnoreCase( 'SUCCESS' ) )
            {
                linea.ExitosoRevChain__c = true;
                
                if(OC.TOPP__r.TipodeOperacionporPLan__c=='Exclusión Lineas de LD'){
                    linea.ActivaServicioLD__c = false;
                }else{
                    linea.ActivaServicioLD__c = true;
                }
                
                mapLineasXId.put( linea.Id, linea );
                
            }else if( mapRespuestas.containsKey( linea.ExternalID__c )
                && mapRespuestas.get( linea.ExternalID__c ).equalsIgnoreCase( 'FAIL' ) )
            {
                linea.ExitosoRevChain__c = false;
                
                mapLineasXId.put( linea.Id, linea );
            }
            /* BEGIN - Manuel Medina - Validacion para lineas LSP no existentes en RevChain - 18112015 */
            else if( mapRespuestas.containsKey( linea.CorrelationId__c )
                && mapRespuestas.get( linea.CorrelationId__c ).equalsIgnoreCase( 'SUCCESS' ) )
            {
                linea.ExitosoRevChain__c = true;
                
                if(OC.TOPP__r.TipodeOperacionporPLan__c=='Exclusión Lineas de LD'){
                    linea.ActivaServicioLD__c = false;
                }else{
                    linea.ActivaServicioLD__c = true;
                }
                
                mapLineasXId.put( linea.Id, linea );
                
            }else if( mapRespuestas.containsKey( linea.CorrelationId__c )
                && mapRespuestas.get( linea.CorrelationId__c ).equalsIgnoreCase( 'FAIL' ) )
            {
                linea.ExitosoRevChain__c = false;
                
                mapLineasXId.put( linea.Id, linea );
            }
            /* END - Manuel Medina - Validacion para lineas LSP no existentes en RevChain - 18112015 */
        }
        /* END - Manuel Medina - Modificacion de las lineas a ser actualizadas teniendo en cuenta la respuesta de RevChain - 26102015 */
        
    }
    
    if(result){
        generarLogFacturacionLD( OC.id,cadena, response, 'Exitoso',  nombreOperacion);
    }else{
        generarLogFacturacionLD( OC.id,cadena, response, 'Fallida',  nombreOperacion);
    }
    
    return result;
}

public map<string,string> recuperarRespuestaXML(Dom.Document doc)
{
    /*StaticResource sr = [
                select Body
                from StaticResource
                where Name = 'respuestatransfer'
                ];
    
    Dom.Document doc = new Dom.Document();
        doc.load(sr.Body.toString());//Here xmlstring data is from the above XML shown above
        */
//Retrieve the root element for this document.
Dom.XMLNode env= doc.getRootElement();
//system.debug('****'+env);
//list<Dom.XmlNode> Body=env.getChildren();
system.debug(env.getNamespace());
string namespace = env.getNamespace();
//system.debug('&&&&'+Body);
//mapa que almacena todas las respuestas en strings: estado PASS o FAIL
//respuesta Revchain
map<string,string> mapRespuestas= new map<string,string>();
 Dom.XMLNode Body=env.getChildElement('Body',namespace);
 Dom.XMLNode ResponseRevChain;
for(Dom.XmlNode nodo : Body.getChildren())
{
    system.debug('nombre: '+nodo.getName());
    if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSResponseSFRevchain'))
        ResponseRevChain=nodo;
}
Dom.XMLNode CanonicalMessage;
Dom.XMLNode WSResponseHeader;
//agarro la respuesta y el canonico
for(Dom.XmlNode nodo : ResponseRevChain.getChildren())
{
    system.debug('nombre: '+nodo.getName());
    if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('CanonicalMessage'))
        CanonicalMessage=nodo;
    else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSResponseHeader'))
        WSResponseHeader=nodo;
}
//system.debug('Canonico::'+CanonicalMessage.getNameSpace());

system.debug('WSHeaderResponse'+WSResponseHeader.getNameSpace());
Dom.XMLNode Service = WSResponseHeader.getChildElement('Service',WSResponseHeader.getNameSpace());
system.debug(service);
//Obtener del servicio status y fecha
Dom.XMLNode Status = service.getChildElement('status',Service.getNameSpace());
//system.debug(Status.GetText());
//recorrer el response y obtener la respuesta
mapRespuestas.put('Estado',Status.GetText());
//recorrer el canonico y buscar respuesta revchain, numeros de cuenta de facturacion
Dom.XMLNode OrderFulfilment = CanonicalMessage.getChildElement('OrderFulfilment',CanonicalMessage.getNameSpace());
//Dom.XMLNode Salesorderline;
list<Dom.XMLNode> Salesorderline = new list<Dom.XMLNode>();
for(Dom.XmlNode nodo : OrderFulfilment.getChildren())
{
    //system.debug('nombre: '+nodo.getName());
    if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('SalesOrderLine'))
        Salesorderline.add(nodo);
    
}

//girar sobre cada uno de los salesorderline
for(Dom.XmlNode nodo : salesorderline)
{
    //encontrar los nodos altkey
    for(Dom.XmlNode altkey : nodo.getChildren())
    {
    
    if(altkey.getName()!=null && altkey.getName().equalsIgnoreCase('AltKey'))
        //girar sobre el mismo altkey
        {
            Dom.XmlNode name;
            Dom.XmlNode valor;
            Dom.XmlNode IdExt;
        for(Dom.XmlNode nodokey : altkey.getChildren())
        {
            
            
            if(nodokey.getName()!=null && nodokey.getName().equalsIgnoreCase('AltKeyName'))
            {
                name=nodokey;
            }
            else if(nodokey.getName()!=null && nodokey.getName().equalsIgnoreCase('AltKeyValue'))
            {
                valor=nodokey;
            }
            else if(nodokey.getName()!=null && nodokey.getName().equalsIgnoreCase('Id'))
            {
                IdExt=nodokey;
            }
            
            
        }
        
        if(name.getText().equalsIgnoreCase('RESULT REVCHAIN'))
        {
            system.debug('valor resultado: '+valor.getText());
            maprespuestas.put(idExt.getText(),valor.getText());
        }
        }
    
    }
    
}


//enviar como texto el nodo customerBill para crear la cuenta de facturaci?n
//mapRespuestas.put('cuentaFac',CustomerBill.toXmlString());
return mapRespuestas;
}
 public void generarLogFacturacionLD(string idOC,string request,string response, string estado, string nombre){
        
        // [CG] Se restringe el maximo de las tramas del request y el response que se almacenara en los logs
        LogTransacciones__c lt =new LogTransacciones__c(CorrelationId__c=idOC,LTE_Operacion_Comercial__c=idOc,
        Informacion_Enviada__c= ( request.length() > 100000 ? request.SubString(0,100000) : request ),
        Informacion_Recibida__c=( response.length() > 100000 ? response.SubString(0,100000) : response ),
        Estado__c=estado,Name=nombre);
        
        lstLogTransaccion.add(lt);
    }
  /**
    *   @Method: crearCuentaRevChain.
    *   @param oc: Operacion comercial      
    *   @description: Se encarga de armar trama y hacer llamado para crear cuenta facturación en revcahin 
    */
public void crearCuentaRevChain(OperacionComercial__c oc, Account cuenta){
    
    
    //Se crea wrapper con todos los datos para crear la cuenta facturación
    JerarquiaCtasLD objJerarquiaCtas = new JerarquiaCtasLD();
    
    objJerarquiaCtas.strCorrelationId = GeneracionCorrelationID('CFAC',1); 
    objJerarquiaCtas.strMarketType = label.LD_PersonaJuridica;
    objJerarquiaCtas.strGeoCode1 = oc.CuentaFacturacion__r.Ciudad__r.CodigoDane__c;
    objJerarquiaCtas.strGeoCode2 = label.LD_GeoCode2;
    objJerarquiaCtas.strOrderType = label.LD_Venta;      
    objJerarquiaCtas.strNumCta = oc.CuentaFacturacion__r.Id; //[FS, Jerarquia de cuentas 2020-04-02]:Se incluye map para establecer identificador de la cuenta
    
    objJerarquiaCtas.strCurrCode = label.LD_COP;
    objJerarquiaCtas.strInvDay = label.LD_InvDay;

    ConstruccionCanonico_cls objObtenerCicloFacturacion = new ConstruccionCanonico_cls();
    objJerarquiaCtas.strConvInd = objObtenerCicloFacturacion.CalculoCodigoFacturacion(oc,cuenta);
    
    objJerarquiaCtas.strPaymentPrd = oc.Legalizacion__r.Contrato__r.PlazoPago__c;//plazo pago contrato
    objJerarquiaCtas.strBillParent = (oc.CuentaFacturacion__r.LTE_CuentaFacturacionPadre__r.Name == null?'':oc.CuentaFacturacion__r.LTE_CuentaFacturacionPadre__r.Name);
    objJerarquiaCtas.strBillable = oc.CuentaFacturacion__r.Facturable__c == true ? 'Y' : 'N';
    objJerarquiaCtas.strDoctype = oc.CuentaFacturacion__r.Cliente__r.Tipodedocumento__c;
    /* BEGIN - Manuel Medina - Ajuste de los parametros de fecha en la apertura de cuenta de facturacion en RevChain - 23102015 */
    objJerarquiaCtas.strMonth = system.now().format('MM');//'2';
    objJerarquiaCtas.strDay = system.now().format('dd');//'1';
    objJerarquiaCtas.strYear = system.now().format('yyyy');//'3';
    /* END - Manuel Medina - Ajuste de los parametros de fecha en la apertura de cuenta de facturacion en RevChain - 23102015 */
    objJerarquiaCtas.strSubscriberName = oc.CuentaFacturacion__r.Cliente__r.Name;
    //objJerarquiaCtas.strBillBillingName = oc.CuentaFacturacion__r.Nombre__c;
    objJerarquiaCtas.strBillBillingName = oc.CuentaFacturacion__r.LTE_NombreCuentaFacturacion__c; //[FS, Jerarquia de cuentas 2020-04-02]: Se modifica el origen, para obtener el nombre de la cuenta
    objJerarquiaCtas.strPhoneNumber = oc.CuentaFacturacion__r.Cliente__r.Phone;
    objJerarquiaCtas.strContactEmail = oc.CuentaFacturacion__r.LTE_Email__c != null ? oc.CuentaFacturacion__r.LTE_Email__c : objJerarquiaCtas.strContactEmail;
    objJerarquiaCtas.strNumDocument = oc.CuentaFacturacion__r.Cliente__r.AccountNumber;
    objJerarquiaCtas.strLineOne = oc.CuentaFacturacion__r.DirCorresp__c != null ? oc.CuentaFacturacion__r.DirCorresp__c : objJerarquiaCtas.strLineOne;
    objJerarquiaCtas.strCityName =  oc.CuentaFacturacion__r.Ciudad__r.Name;
    objJerarquiaCtas.strStateCode = recortarDane(oc.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c);
    objJerarquiaCtas.strDaneCode = objJerarquiaCtas.strGeoCode1;    
    objJerarquiaCtas.strInvoiceDelivery = 'Postal Service';
    objJerarquiaCtas.strSegmento			= oc.CuentaCliente__r.Segmento__c;
    objJerarquiaCtas.strSubSegmento		= oc.CuentaCliente__r.SubSegmento__c;
    objJerarquiaCtas.strInvoiceType			= oc.CuentaFacturacion__r.TipoFactura__c;
    objJerarquiaCtas.strDepartamento		= oc.CuentaFacturacion__r.LTE_DepartamentoFacturacion__c;
    objJerarquiaCtas.strIdCtaRevchain	= oc.CuentaFacturacion__r.Name;
    objJerarquiaCtas.strCreatorUser		= oc.CuentaFacturacion__r.CreatedBy.Username;
    
    //String strRequest = CrearXMLJerarquiaCuentaFact(objJerarquiaCtas);
	//[FS, Jerarquia de cuentas 2020-04-02]: Se modifica el método para obtener el xml del servicio.	
    String strRequest = ConstruirXMLCtasFact_cls.CrearXMLCreacionCuentaFact_SystemsAccounts(objJerarquiaCtas);
    
    invocarServicioCrearCuentaFact(strRequest, oc.CuentaFacturacion__c);

}


  /**
    *   @Method: CrearXMLJerarquiaCuentaFact
    *   @param objJerarquiaCtas: objeto que contiene la información requerida para la creación de una cuenta de facturación padre y sus hijas si las tiene.      
    *   @return String: XML de request.
    *   @description: Se encarga de crear el string que contiene el XML para la creación de cuentas de facturación. 
    */
  public static String CrearXMLJerarquiaCuentaFact(JerarquiaCtasLD objJerarquiaCtas)
  { 
    //Se llena el XML con la información que contiene el objeto objJerarquiaCtas.
    String strXml =  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/SiebelSvrs/CreacionCuentaRequest/OUT/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/NPlay/integration/SiebelSrvs/CreacionCuenta/Request/v1.0">'
            +'   <soapenv:Header/>'
            +'   <soapenv:Body>'
            +'      <ns:CreacionCuentaRequest>'
            +'         <v1:WSRequestHeader>'
            +'            <v1:System correlationID="' + objJerarquiaCtas.strCorrelationId + '" processingServer=""></v1:System>'
            +'            <v1:Property name="" value=""></v1:Property>'
            +'         </v1:WSRequestHeader>'
            +'         <v11:CreacionCuentaInput>'
            +'            <v11:EXT_MARKET_TYP>' + objJerarquiaCtas.strMarketType + '</v11:EXT_MARKET_TYP>'
            +'            <v11:GEO_CODE1>' + objJerarquiaCtas.strGeoCode1 + '000</v11:GEO_CODE1>'
            +'            <v11:GEO_CODE2>' + objJerarquiaCtas.strGeoCode2 + '</v11:GEO_CODE2>'
            +'            <v11:GEO_CODE3></v11:GEO_CODE3>'
            +'            <v11:ORDER_TYPE>' + objJerarquiaCtas.strOrderType + '</v11:ORDER_TYPE>'
            +'            <v11:CT_NUM>' + objJerarquiaCtas.strNumCta + '</v11:CT_NUM>'
            +'            <v11:FD></v11:FD>'
            +'            <v11:CURR_CODE>' + objJerarquiaCtas.strCurrCode + '</v11:CURR_CODE>'
            +'            <v11:INV_DAY>' + objJerarquiaCtas.strInvDay + '</v11:INV_DAY>'
            +'            <v11:CONV_IND>' + objJerarquiaCtas.strConvInd + '</v11:CONV_IND>'
            +'            <v11:SUB_ID></v11:SUB_ID>'
            +'            <v11:PAYMENT_PRD>' + objJerarquiaCtas.strPaymentPrd + '</v11:PAYMENT_PRD>'
            +'            <v11:BILL_PRNT_SUB_ID>' + objJerarquiaCtas.strBillParent + '</v11:BILL_PRNT_SUB_ID>'
            +'            <v11:BILLABLE>' + objJerarquiaCtas.strBillable + '</v11:BILLABLE>'
            +'            <v11:DocType>' + objJerarquiaCtas.strDoctype + '</v11:DocType>'
            +'            <v11:start_date>'
            +'               <v11:month>' + objJerarquiaCtas.strMonth + '</v11:month>'
            +'               <v11:day>' + objJerarquiaCtas.strDay +  '</v11:day>'
            +'               <v11:year>'  + objJerarquiaCtas.strYear +'</v11:year>'
            +'            </v11:start_date>'
            +'            <v11:Customer>'
            +'               <v11:first_name></v11:first_name>'
            +'               <v11:second_name></v11:second_name>'
            +'               <v11:surname></v11:surname>'
            +'               <v11:last_name></v11:last_name>'
            +'               <v11:second_surname></v11:second_surname>'
            +'               <v11:subscriber_name>' + objJerarquiaCtas.strSubscriberName + '</v11:subscriber_name>'
            +'               <v11:BillBillingName>' + objJerarquiaCtas.strBillBillingName + '</v11:BillBillingName>'
            +'               <v11:ContactInfo>'
            +'                  <v11:PhoneNumber>' + objJerarquiaCtas.strPhoneNumber + '</v11:PhoneNumber>'
            +'                  <v11:ContactEmailAdd>' + objJerarquiaCtas.strContactEmail + '</v11:ContactEmailAdd>'
            +'                  <v11:DocumentNo>' + objJerarquiaCtas.strNumDocument + '</v11:DocumentNo>'
            +'               </v11:ContactInfo>'
            +'            </v11:Customer>'
            +'            <v11:Billing_address>'
            +'               <v11:LineOne>' + objJerarquiaCtas.strLineOne + '</v11:LineOne>'
            +'               <v11:CityName>' + objJerarquiaCtas.strCityName + '.</v11:CityName>'
            +'               <v11:StateCode>' + objJerarquiaCtas.strStateCode + '</v11:StateCode>'
            +'               <v11:postcode></v11:postcode>'
            +'               <v11:DaneCode>' + objJerarquiaCtas.strDaneCode + '</v11:DaneCode>'
            +'            </v11:Billing_address>'
            +'            <v11:invoice_delivery_name>' + objJerarquiaCtas.strInvoiceDelivery + '</v11:invoice_delivery_name>'
            +'            <v11:OrderSubType>' + objJerarquiaCtas.strOrderSubType + '</v11:OrderSubType>'
            +'            <v11:InvoiceMethod>' + objJerarquiaCtas.strInvoiceMethod + '</v11:InvoiceMethod>';

    // si el objeto objJerarquiaCtas contiene cuentas de facturación hijas en la lista se procede a crear el XML para dichas cuentas hijas.
    if(!objJerarquiaCtas.lstDatosCtasHijas.isEmpty())
    {
      //for(JerarquiaCtasLD objCtaFact : objJerarquiaCtas.lstDatosCtasHijas)
        //strXml += CrearCuentaFactHija(objCtaFact);
    }
                            
    strXml +='         </v11:CreacionCuentaInput>'
        +'      </ns:CreacionCuentaRequest>'
        +'   </soapenv:Body>'
        +'</soapenv:Envelope>';
    system.debug('REQUEST------------>' + strXml);
    return strXml;

  }
  
  
  /**
    *   @Method: invocarServicioCrearCuentaFact.
    *   @param strRequest: trama de creacion de cuentas 
    *   @param idCuentaFact: id sfdc de la cuenta facturacion para actualizar
    *   @description: método que invoca el servicio de creación de cuenta facturacion en revChain
  **/
  public void invocarServicioCrearCuentaFact(String strRequest, String idCuentaFact)
  {
        //Obtiene la informacion del servicio web almacenado en la configuración personalizada ServiciosWeb__c.        
        //ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionCuentasFact');
        //[FS, Jerarquia de cuentas 2020-04-02]: Se modifica los datos de conexión del servicio
         ServiciosWeb__c sw = ServiciosWeb__c.getValues('CreacionJerarquiaCuentasFact');
        System.debug('\n\n Request creacion cuenta revChain-----------> ' + strRequest);
        //Consume el servicio y almacena el response.
        String strResponse;
        if(!Test.isRunningTest())
        	strResponse = LibreriaUtilitariaJobs_cls.consultarServicio(strRequest, sw.Action__c, sw.EndPoint__c);
      	else
            strResponse = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:CreateSystemsAccountsOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/CreateSystemsAccountsOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Salesforce</ns1:name><ns1:correlationID>a05m00000084zu1AAA303202011271</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2020-03-30T11:26:06.437-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns1:CreateSystemsAccountsOutput xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/CreateSystemsAccountsMsgs"><ns2:ResponseData xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/ResponseData"><ns2:CreateBillingAccountResponse><ns2:Code>S</ns2:Code><ns2:Description>operation is successful</ns2:Description><ns3:response xmlns:ns3="InvokeEJBURevChainOutResponse" system="RevChain" operation="S" result="S"><ns3:faults><ns3:subscriber_id>15052846725</ns3:subscriber_id><ns3:account_id>a05m00000084zu1AAA</ns3:account_id><ns3:plan_impuestos><ns3:type_name>PLAN DE IMPUESTOS ETB LOCAL</ns3:type_name><ns3:tax_plan_vendor/></ns3:plan_impuestos><ns3:ciclo_facturacion>18</ns3:ciclo_facturacion><ns3:fault_detail error_description="operation is successful" error_code="0"/></ns3:faults></ns3:response></ns2:CreateBillingAccountResponse><ns2:CreateRMCAAccountResponse><ns2:Code>SUCCESS</ns2:Code><ns2:Description>SUCCESS</ns2:Description></ns2:CreateRMCAAccountResponse><ns2:CreateMDMAccountResponse><ns2:Code>1</ns2:Code><ns2:Description>Operacion Exitosa</ns2:Description></ns2:CreateMDMAccountResponse></ns2:ResponseData></ns1:CreateSystemsAccountsOutput></ns0:CreateSystemsAccountsOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';
      
        System.debug('\n\n Response creacion cuenta revChain-----------> ' + strResponse);
        
        getMapXMLResponseFact(strRequest, strResponse, idCuentaFact);
  }
  
  /**
    *   @Method: recortarDane.
    *   @param strCod: Codigo dane a recortar.      
    *   @return String: codigo dane recortado.
    *   @description: Se encarga de recortar el codigo dane cuendo es necesario para el servicio web. 
    */
  public String recortarDane(String strCod)
  {
    String strCodigo='';
    if(strCod!=null){
      if(strCod.length()==5)
      {
        strCodigo=strCod.substring(0,2);
      }
      else if(strCod.length()==4)
      {
        strCodigo=strCod.substring(0,1);
      }
    }
    return strCodigo;
  }
  
  
    /**
    *   @Method: getMapXMLResponseFact
    *   @param strResponse: XML respuesta del servicio web.
    *   @description: Se encarga de convertir la respuesta del servicio web en dom. 
    */
  public void getMapXMLResponseFact(String strRequest, String strResponse, String idCuentaFact)
  {    
    Dom.Document doc = new Dom.Document();
    doc.load(strResponse);
    Dom.XMLNode WS = doc.getRootElement();        
    iterarXmlResponseFact(WS, idCuentaFact);
    iterarXmlResponseRMCA_MDM(WS);
    crearLogtransaccionCtaFac(strRequest, strResponse, idCuentaFact);
      
    if(mapRtaRMCA_MDM.size() > 0)            
			actualizarRtaRMCA_MDM(mapRtaRMCA_MDM);
  }
  
  /**
    *   @Method: iterarXmlResponseFact
    *   @param dataXml: XML respuesta del servicio web convertido en dom.
    *   @description: Se encarga de iterar el XML encontrando etiquetas necesarias. 
    */
  public void iterarXmlResponseFact(dom.XMLNode dataXml, String idCuentaFact)
  {      
    List<dom.XMLNode> lstXmlValues = dataXml.getChildElements();
    if(lstXmlValues.size()>0)
    {
      for( dom.XMLNode dxm : lstXmlValues)
      {
        if(dataXml.getName()=='faults')
        {
          system.debug('ENCONTRO FAULTS-------->'+dxm);
          iterarXmlDatosCtaPadre(dxm, idCuentaFact);          
        }
        if(dataXml.getName()=='h_faults')
        {
          system.debug('ENCONTRO H_FAULTS-------->'+dxm);
          //iterarXmlDatosCtaHija(dxm, idCuentaFact);
        }

        iterarXmlResponseFact(dxm, idCuentaFact);
      }
    }
    else
    {
      System.debug('\nMap valores'+dataXml.getName()+''+dataXml.getText());
      valores.put(dataXml.getName(),dataXml.getText());    
    }
  }
	
  public void iterarXmlResponseRMCA_MDM(dom.XMLNode dataXml)
  {	 
      String strIdCuentaFacturacion;		
      List<dom.XMLNode> lstXmlValues = dataXml.getChildElements();        
      if(lstXmlValues.size()>0){
          for( dom.XMLNode dxm : lstXmlValues){                                
              if(dataXml.getName()=='faults'){                    
                  if(dxm.getName()=='account_id'){
                      if(strIdCuentaFacturacion == null  && dxm.getText() != null)                        
                          strIdCuentaFacturacion = dxm.getText();
                      mapRtaRMCA_MDM.put('account_id',strIdCuentaFacturacion);
                  }
              }
              if(dataXml.getName()=='CreateRMCAAccountResponse')
              {                    
                  List<dom.XMLNode> lstXmlRespuestaRMCA = dataXml.getChildElements();
                  if(lstXmlRespuestaRMCA.size()>0)
                  {                        
                      for( dom.XMLNode dxmRespuestaRMCA : lstXmlRespuestaRMCA)
                      {
                          if(dxmRespuestaRMCA.getName()=='Code')
                          {                                
                              if(dxmRespuestaRMCA.getText() != ''){
                                  mapRtaRMCA_MDM.put('Code_RMCA',dxmRespuestaRMCA.getText());
                                  system.debug('JerarquiaCF: ENCONTRO CODE_RMCA-------->' + mapRtaRMCA_MDM);   
                              }                                
                          }
                          if(dxmRespuestaRMCA.getName()=='Description')
                          {
                              if(dxmRespuestaRMCA.getText() != ''){
                                  mapRtaRMCA_MDM.put('Description_RMCA',dxmRespuestaRMCA.getText());
                                  system.debug('JerarquiaCF: ENCONTRO DESCRIPTION_RMCA-------->' + mapRtaRMCA_MDM);
                              }
                          }
                      }
                  }
              }                
              if(dataXml.getName()=='CreateMDMAccountResponse')
              {                    
                  List<dom.XMLNode> lstXmlRespuestaMDM = dataXml.getChildElements();
                  if(lstXmlRespuestaMDM.size()>0)
                  {
                      for( dom.XMLNode dxmRespuestaMDM : lstXmlRespuestaMDM)
                      {
                          if(dxmRespuestaMDM.getName()=='Code')
                          {
                              mapRtaRMCA_MDM.put('Code_MDM',dxmRespuestaMDM.getText());
                              system.debug('JerarquiaCF: ENCONTRO CODE_MDM-------->' + mapRtaRMCA_MDM);
                          }
                          if(dxmRespuestaMDM.getName()=='Description')
                          {
                              mapRtaRMCA_MDM.put('Description_MDM',dxmRespuestaMDM.getText());
                              system.debug('JerarquiaCF: ENCONTRO DESCRIPTION_MDM-------->' + mapRtaRMCA_MDM);
                          }
                      }
                  }                    
              }                
              iterarXmlResponseRMCA_MDM(dxm);
          }
      }      
  }  
    
  /**
    *   @Method: iterarXmlDatosCtaPadre
    *   @param dxm: XML desglosado.
    *   @description: Se encarga de iterar el XML encontrando etiquetas con información de respuesta del padre util 
    */    
  public void iterarXmlDatosCtaPadre(dom.XMLNode dxm, String idCuentaFact)
  {
    if(dxm.getName()=='subscriber_id')
    {
      mapCuentasFact.put('subscriber_id',dxm.getText());      
      strNombreCtaTemp = dxm.getText();
      strCodCuentaFacturacion = dxm.getText();
      system.debug('ENCONTRO SUBSCRIBER-------->' + mapCuentasFact);
    }
    if(dxm.getName()=='account_id')
    {
      mapCuentasFact.put('account_id',dxm.getText());
      strIdCtaTemp = dxm.getText();
      system.debug('ENCONTRO CUENTA-------->' + mapCuentasFact);
    }
    if(dxm.getName()=='plan_impuestos')
    {
      List<dom.XMLNode> lstXmlPlanImpuestos = dxm.getChildElements();
      if(lstXmlPlanImpuestos.size()>0)
      {
        for( dom.XMLNode dxmPlanImpuestos : lstXmlPlanImpuestos)
        {
          if(dxmPlanImpuestos.getName()=='type_name')
          {
            mapCuentasFact.put('type_name',dxmPlanImpuestos.getText());
            system.debug('ENCONTRO TAXPLAN-------->' + mapCuentasFact);            
          }
        }
      }
    }
    if(dxm.getName()=='ciclo_facturacion')
    {
      mapCuentasFact.put('ciclo_facturacion',dxm.getText());
      system.debug('ENCONTRO CICLO-------->' + mapCuentasFact);      
    }
    if(dxm.getName()=='fault_detail')
    {
      strResultCode      = dxm.getAttributeValue('error_code','');  
      strResultDescription  = dxm.getAttributeValue('error_description','');
      actualizarCtasFact(mapCuentasFact, idCuentaFact);     
    }  
  }

  /**
    *   @Method: iterarXmlDatosCtaHija
    *   @param dxm: XML desglosado.
    *   @description: Se encarga de iterar el XML encontrando etiquetas con información de respuesta de las ctas hijas util 
    */  
  public void iterarXmlDatosCtaHija(dom.XMLNode dxm, String idCuentaFact)
  {
    if(dxm.getName()=='h_subscriber_id')
    {
      mapCuentasFact.put('subscriber_id',dxm.getText());
      strNombreCtaTemp = dxm.getText();
      strCodCuentaFacturacion = dxm.getText();
      system.debug('ENCONTRO SUBSCRIBER-------->' + mapCuentasFact);
    }
    if(dxm.getName()=='h_account_id')
    {
      mapCuentasFact.put('account_id',dxm.getText());
      strIdCtaTemp = dxm.getText();      
      system.debug('ENCONTRO CUENTA-------->' + mapCuentasFact);
    }
    if(dxm.getName()=='h_plan_impuestos')
    {
      List<dom.XMLNode> lstXmlPlanImpuestos = dxm.getChildElements();
      if(lstXmlPlanImpuestos.size()>0)
      {
        for( dom.XMLNode dxmPlanImpuestos : lstXmlPlanImpuestos)
        {
          if(dxmPlanImpuestos.getName()=='h_type_name')
          {
            mapCuentasFact.put('type_name',dxmPlanImpuestos.getText());
            system.debug('ENCONTRO TAXPLAN-------->' + mapCuentasFact);
          }
        }
      }    
    }
    if(dxm.getName()=='h_ciclo_facturacion')
    {
      mapCuentasFact.put('ciclo_facturacion',dxm.getText());
      system.debug('ENCONTRO CICLO-------->' + mapCuentasFact);      
    }
    if(dxm.getName()=='h_fault_detail')
    {
      strResultCode      = dxm.getAttributeValue('h_error_code','');  
      strResultDescription  = dxm.getAttributeValue('h_error_description','');
      actualizarCtasFact(mapCuentasFact, idCuentaFact);
    }
  }

  /**
    *   @Method: actualizarCtasFact
    *   @param mapCuentas: contiene las etiquetas y la informacíón relevante de las respuesta del servicio web.
    *   @description: Se encarga de hacer las actualizaciones pertinentes a las ctas de facturación una vez el servicio web ha dado su respuesta y se ha obtenido la información.
    */  
  public void actualizarCtasFact(map<string,string> mapCuentasFact, String idCuentaFact)
  {
      
      
    system.debug('STATUS Y RESULTADO------>' +  valores.get('status') + strResultDescription );
    //Si la creación de la cuenta de facturación fue exitosa.
    if(valores.get('status')=='PASS' && strResultDescription == 'operation is successful')
    {
          String strIdCtaFact = mapCuentasFact.get('account_id');
          system.debug('ID ACT' + strIdCtaFact);
          String idCuenta ='';
          idCuenta =  mapCuentasFact.get('account_id');
          CuentaFacturacion__c objCtaFactUpdate     = new CuentaFacturacion__c(id=idCuentaFact);
          //objCtaFactUpdate.Id             = mapCuentasFact.get('account_id');
          objCtaFactUpdate.Name             = mapCuentasFact.get('subscriber_id');
          objCtaFactUpdate.CodCicloFac__c        = mapCuentasFact.get('ciclo_facturacion');
          objCtaFactUpdate.TaxPlan__c          = mapCuentasFact.get('type_name');
          objCtaFactUpdate.Fue_creada_en_revchain__c  = true; 
          mapCuentasFact.clear();     
          lstCuentasFacturacionUpdate.add(objCtaFactUpdate);      
    }
  }
  //[FS, Jerarquia de cuentas 2020-04-02]:	Se incluye método para actualizar información de RMCA y MDM generada por el servicio
  public void actualizarRtaRMCA_MDM(map<string,string> mapCuentas)
  {
      String strIdCtaFact;                  
      if( mapCuentas.size() > 0 ){                          
          if(mapCuentas.get('account_id') != null){ 
              Boolean cuentaFacturable = false;
              List<CuentaFacturacion__c> lstCtaFact = new List<CuentaFacturacion__c>([Select Facturable__c From CuentaFacturacion__c Where id=:mapCuentas.get('account_id')]);
              if(lstCtaFact.size() > 0)
                  cuentaFacturable = lstCtaFact[0].Facturable__c;
              
              CuentaFacturacion__c objCtaFactUpdate = new CuentaFacturacion__c(id=mapCuentas.get('account_id'));
              
              if(mapCuentas.get('Code_RMCA') == 'SUCCESS' && mapCuentas.get('Description_RMCA') == 'SUCCESS' && cuentaFacturable)
                  objCtaFactUpdate.Fue_creada_en_RMCA__c = true;
              
              if(mapCuentas.get('Code_MDM') == '1' && mapCuentas.get('Description_MDM') == 'Operacion Exitosa')
                  objCtaFactUpdate.Fue_creada_en_MDM__c = true;	
                            
              objCtaFactUpdate.Fecha_Creacion_cuenta_Revchain__c = string.valueof(system.now());
              objCtaFactUpdate.Estado__c = 'Activo';
              mapCuentas.clear();
              lstCtasFactUpdRtaRMCA_MDM.add(objCtaFactUpdate);  
          }                              
      }     
  }
  //FIN [FS, Jerarquia de cuentas 2020-04-02]
  /**
    *   @Method: crearLogtransaccionCtaFac
    *   @description: Se encarga de crear el log de transacción del consumo del servisio web.
    */  
  public void crearLogtransaccionCtaFac(String strRequest, String strResponse, String idCuentaFact)
  {
    LogTransacciones__c objLog = new LogTransacciones__c();
    if(valores.get('status') == 'PASS' && strResultDescription == 'operation is successful')
      objLog.Estado__c = 'Exitoso';
    else
      objLog.Estado__c = 'Fallido';

    system.debug('strIdCtaTemp-->' + strIdCtaTemp);
    system.debug('strResultCode-->' + strResultCode);
    objLog.Informacion_Enviada__c     = strRequest;
    objLog.Informacion_Recibida__c     = strResponse;
    objLog.LTE_CuentaFacturacionLTE__c  = idCuentaFact;
    objLog.Name             = 'Creación cuenta en Revchain - RMCA - MDM ' + strNombreCtaTemp;
    objLog.CodigoRespuesta__c       = strResultCode;

    strResultCode      = '';  
    strResultDescription  = '';
    strNombreCtaTemp    = '';
    strIdCtaTemp      = '';
    lstLogTransaccion.add(objLog);    
    
    
  }



    //metodo que genera el codigo correlation ID para que sea asignado a cada mensaja canonico
    public string GeneracionCorrelationID(string Operacion,integer paso)
    {
        Integer numeroRandom = Math.round(Math.random()*1000);
        string retorno = operacion.substring(0,3).toUppercase()+'-'+paso+numeroRandom;
        return retorno;
    }
    

public PlanLD__c planMundo()
{
    return [Select p.Servicio__c, p.Producto__c,p.Name, p.PlanFacturacion__c, (select Name,Tipo__c,ProductoLD__c From Sub_Planes_Facturaci_n__r) From PlanLD__c p where name='Plan Mundo' ];
}

 //Clase que contiene la información requerida para la creación de una cuenta de facturación padre y sus hijas si las tiene. 
  public class JerarquiaCtasLD
  {
    public String strCorrelationId;
    public String strMarketType;
    public String strGeoCode1;
    public String strGeoCode2;
    public String strOrderType;  
    public String strNumCta;
    public String strCurrCode;
    public String strInvDay;
    public String strConvInd;
    public String strBillParent;
    public String strBillable;
    public String strDoctype;
    public String strMonth;
    public String strDay;
    public String strYear;
    public String strSubscriberName;
    public String strBillBillingName;
    public String strPhoneNumber;
    public String strContactEmail;
    public String strNumDocument;
    public String strLineOne;
    public String strCityName;
    public String strStateCode;
    public String strDaneCode;
    public String strInvoiceDelivery;
    public String strOrderSubType;
    public String strInvoiceMethod;
    public String strPaymentPrd;
    //[FS, Jerarquia de cuentas 2020-04-02]:Se incluyen los siguientes atributos para el nuevo servicio de jerarquía de cuentas
    public String strSegmento;
    public String strSubSegmento;
    public String strInvoiceType;
    public String strDepartamento;
    public String strIdCtaRevchain;
    public String strCreatorUser;    
   // FIN [FS, Jerarquia de cuentas 2020-04-02]
    public list<JerarquiaCtasLD> lstDatosCtasHijas;
    
    public JerarquiaCtasLD(){
        this.strCorrelationId = '';
        this.strMarketType = '';
        this.strGeoCode1 = '';
        this.strGeoCode2 = '';
        this.strOrderType = '';  
        this.strNumCta = '';
        this.strCurrCode = '';
        this.strInvDay = '';
        this.strConvInd = '';
        this.strBillParent = '';
        this.strBillable = '';
        this.strDoctype = '';
        this.strMonth = '';
        this.strDay = '';
        this.strYear = '';
        this.strSubscriberName = '';
        this.strBillBillingName = '';
        this.strPhoneNumber = '';
        this.strContactEmail = '';
        this.strNumDocument = '';
        this.strLineOne = '';
        this.strCityName = '';
        this.strStateCode = '';
        this.strDaneCode = '';
        this.strInvoiceDelivery = '';
        this.strOrderSubType = '';
        this.strInvoiceMethod = '';
        this.strPaymentPrd = '';
        //[FS, Jerarquia de cuentas 2020-04-02]:Se incluyen los siguientes atributos para el nuevo servicio de jerarquía de cuentas
        this.strSubSegmento = '';
    	this.strInvoiceType = '';
    	this.strDepartamento = '';
    	this.strIdCtaRevchain = '';
    	this.strCreatorUser = ''; 
        //FIN [FS, Jerarquia de cuentas 2020-04-02]
        this.lstDatosCtasHijas = new list<JerarquiaCtasLD>();
    }
  }
}