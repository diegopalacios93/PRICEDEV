/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Luis Eduardo Mogoll?n
Proyecto:               ETB - Integracion RevChain
Descripcion:            Clase que arma el Canonico de RevChain
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
2.0     25-11-2014  Luis E Mogollon (LEM)   Ajustes Canonico RevChain
2.1     02-05-2016  Carlos Gonzalez (CG)    Ajustes Canonico RevChain
2.2     20-05-2016  Carlos Gonzalez (CG)    Ajustes validación OC con Caso sin Legalización
2.3     31-05-2016  Carlos Gonzalez (CG)    Adaptación Configuración Personalizada HomologaSegmentoNombre__c y HomologaSubSegmentoNombre__c
2.4     15-02-2018  Fernando Sarasty(FS)    Se incluye excepción en la línea 788 para que el producto "Marcación numeración abreviada" se pueda ejecutar en el flujo de portafolio superior.
2.5     01-09-2018  Mauricio Farias(MF)    se incluyen en la integracion los campos UnidaddeMedida__c y AnchobandaGPON__c para el manejo de los planes Gpon 
*******************************************************************************/

public  class ConstruccionCanonico_cls {

public set<id> planes;

public string SalesOrderLine(OperacionComercial__c OC,PlanFacturacion__c planFac,Account Cuenta)
{
    //es un string
    string xml='';
    //colocar dentro de la etiqueta SalesOrdenLine
    xml+=RevChainXML_cls.SalesOrderLine(OC,planFac);
    //hacer un ciclo por cada itemReference : producto
    //por el plan armar un supplementaryInfo
    xml+=RevChainXML_cls.SupplementaryInfo(OC,planFac.Name,planFac.CatalogoProductosFacturacion__r.Name);
    //a?adir los parametros
    for(ParametroFacturacion__c parametro : planFac.Parametros_de_Facturacion__r)
    {
        xml+=parametro(parametro,OC);
    }
    //se debe colocar aca el rateplan
    string planname=nombreplan(OC,planfac);
    xml+=RevChainXML_cls.rateplan(planname);
    xml+='</SupplementaryInfo>';
    //validar los subplanes
    set<string> idsubplanes = new set<string>();
    for(SubPlanFacturacion__c subplan :planFac.SubPlanesFacturacion__r )
    {
        idsubplanes.add(subplan.id);
    }
    map<string,list<ParametroFacturacion__c>> mapParam= parametrosSubPlanes(idsubplanes);
    for(SubPlanFacturacion__c subplan2 :planFac.SubPlanesFacturacion__r)
    {
        //validar que la OC tenga la informacion que es obligatoria para este plan
        string campo=subplan2.CampoDependiente__c;
        string valor=subplan2.valordependiente__c;
        //si la OC tiene valores en el campo debe crear el registro
        if(campo!=null && OC.get(campo)!=null)
        {
        //validar que si el valor es !=null entonces el valor del campo debe corresponder al valor.
        if(valor!=null)
        {
            if(string.valueof(OC.get(campo))==valor)
            {
                //armar los suplementaryInfo
                    xml+=RevChainXML_cls.SupplementaryInfo(OC,subplan2.Name,subplan2.CatalogoProductosFacturacion__r.Name);
                    if(mapParam.containsKey(subplan2.id))
                        {
                            for(ParametroFacturacion__c parametro : mapParam.get(subplan2.id))
                            {
                                xml+=parametro(parametro,OC);
                                
                            }
                            
                        }
                    string nombreplan = nombreplan(OC,subplan2);
                    xml+=RevChainXML_cls.rateplan(nombreplan);
                    xml+='</SupplementaryInfo>';
                
                
            }
            
        }
        else{
                xml+=RevChainXML_cls.SupplementaryInfo(OC,subplan2.Name,subplan2.CatalogoProductosFacturacion__r.Name);
                if(mapParam.containsKey(subplan2.id))
                {
                for(ParametroFacturacion__c parametro : mapParam.get(subplan2.id))
                {
                xml+=parametro(parametro,OC);
                
                }
            
        }
        string nombreplan = nombreplan(OC,subplan2);
        xml+=RevChainXML_cls.rateplan(nombreplan);
        xml+='</SupplementaryInfo>';
        }
        }
    }    
    if(OC.Plan__r.NombredelProducto__r.Name != Label.SDWAN_Nombre_Producto && OC.Plan__r.NombredelProducto__r.Name != Label.BkpOffice365_Nombre_Producto){
    	//a?adir connection
    	xml+=RevChainXML_cls.Connection(OC,planFac);
    }
    //agregar discounts
    xml+=RevChainXML_cls.Discounts();
    //agregar specificationgroupXA
    xml+=RevChainXML_cls.specificationgroupXA();
    //agregar Altkeys
    xml+=RevChainXML_cls.Custom2(OC);
    xml+=RevChainXML_cls.Billing();
    //xml+=RevChainXML_cls.AltKey();
    string valorciclo = CalculoCodigoFacturacion(OC,Cuenta);
    // [CG] - 31/05/2016 - Homologación de los nombres de los segmentos y subsegmentos
    String strSegmentoH1 = OC.CuentaCliente__r.Segmento__c;
    String strSegmentoH2 = OC.CuentaCliente__r.SubSegmento__c;
    strSegmentoH1 = ( HomologaSegmentoNombre__c.getValues(strSegmentoH1) != null ? HomologaSegmentoNombre__c.getValues(strSegmentoH1).Segmento__c : strSegmentoH1 );
    strSegmentoH2 = ( HomologaSubSegmentoNombre__c.getValues(strSegmentoH2) != null ? HomologaSubSegmentoNombre__c.getValues(strSegmentoH2).SubSegmento__c : strSegmentoH2 );
    xml+=RevChainXML_cls.AltKey(strSegmentoH1,strSegmentoH2,OC,valorciclo);    
    //xml+=RevChainXML_cls.AltKey(OC.CuentaCliente__r.Segmento__c,OC.CuentaCliente__r.SubSegmento__c,OC,valorciclo);
    xml+='</SalesOrderLine>';
    return xml;
}


public string salesOrderLineSolTI(OperacionComercial__c OC,FacturacionSolucionesTI_cls.SolucionTI Solucion,Account Cuenta,List<FacturacionSolucionesTI_cls.SolucionTI> lstSolucionesTI)
{
System.debug('@@-Solucion->'+Solucion);
System.debug('@@-lstSolucionesTI->'+lstSolucionesTI);
string xml='';
    //colocar dentro de la etiqueta SalesOrdenLine
    //todos tienen el mismo servicio.
    xml+=RevChainXML_cls.SalesOrderLineSolTI(OC,Solucion.Servicio);
    //hacer un ciclo por cada itemReference : producto
    //por el plan armar un supplementaryInfo

    //Se agrega supplementaryinfo con la informacion cuando el tipo de facturacion es recurrente y no recurrente
    if(OC.TipoFacturacion__c == Label.CobroUnicoRecurrente){

        xml+=RevChainXML_cls.SupplementaryInfo(OC,lstSolucionesTI[0].plan,lstSolucionesTI[0].producto);
        
        for(ParametroFacturacion__c parametro : lstSolucionesTI[0].lista)
        {
            xml+=parametro(parametro,OC);
        }
        //se debe colocar aca el rateplan
        xml+=RevChainXML_cls.rateplan(lstSolucionesTI[0].plan);
        xml+='</SupplementaryInfo>';

        system.debug('SolTI Cond:'+OC.TipoFacturacion__c+' : '+OC.TipoVenta__c+' : '+OC.ValorUnicaVez__c+' : '+OC.ValorTarifaPlan__c);
        //Agregar el otro producto
        xml+=RevChainXML_cls.SupplementaryInfo(OC,lstSolucionesTI[1].plan,lstSolucionesTI[1].producto);
        
        for(ParametroFacturacion__c parametro : lstSolucionesTI[1].lista)
        {
            xml+=parametro(parametro,OC);
        }
        //se debe colocar aca el rateplan
        xml+=RevChainXML_cls.rateplan(lstSolucionesTI[1].plan);
        xml+='</SupplementaryInfo>';
        
    }else{
        xml+=RevChainXML_cls.SupplementaryInfo(OC,solucion.plan,solucion.producto);
        //a?adir los parametros
        for(ParametroFacturacion__c parametro : solucion.lista)
        {
            xml+=parametro(parametro,OC);
        }
        //se debe colocar aca el rateplan
        xml+=RevChainXML_cls.rateplan(solucion.plan);
        xml+='</SupplementaryInfo>';        
    }

    //a?adir connection
    //lamar la conf Personalizada de los codigos para soluciones Ti
    CodigosConexionProductos__c codigos = CodigosConexionProductos__c.getValues('Soluciones TI');
    
    xml+=RevChainXML_cls.ConnectionSolTI(OC,codigos.idconexion__c,codigos.idtipoconexion__c);
    //agregar discounts
    xml+=RevChainXML_cls.Discounts();
    //agregar specificationgroupXA
    xml+=RevChainXML_cls.specificationgroupXA();
    //agregar Altkeys
    xml+=RevChainXML_cls.Custom2(OC);
    xml+=RevChainXML_cls.Billing();
    //xml+=RevChainXML_cls.AltKey();
    string valorciclo = CalculoCodigoFacturacion(OC,Cuenta);
    // [CG] - 31/05/2016 - Homologación de los nombres de los segmentos y subsegmentos
    String strSegmentoH1 = OC.CuentaCliente__r.Segmento__c;
    String strSegmentoH2 = OC.CuentaCliente__r.SubSegmento__c;
    strSegmentoH1 = ( HomologaSegmentoNombre__c.getValues(strSegmentoH1) != null ? HomologaSegmentoNombre__c.getValues(strSegmentoH1).Segmento__c : strSegmentoH1 );
    strSegmentoH2 = ( HomologaSubSegmentoNombre__c.getValues(strSegmentoH2) != null ? HomologaSubSegmentoNombre__c.getValues(strSegmentoH2).SubSegmento__c : strSegmentoH2 );
    xml+=RevChainXML_cls.AltKey(strSegmentoH1,strSegmentoH2,OC,valorciclo);
    //xml+=RevChainXML_cls.AltKey(OC.CuentaCliente__r.Segmento__c,OC.CuentaCliente__r.SubSegmento__c,OC,valorciclo);
    xml+='</SalesOrderLine>';
    return xml;
}
// metodo que devuelve el nombre del plan si aplica moneda extranjera
public string nombreplan(OperacionComercial__c OC,PlanFacturacion__c planfac)
{
    //valida que si el plan es de compensacion devuelva es el valor del campo de la OC
    string nombreplan='';
    if(planfac.Name.contains('Compensacion'))
    {
        if(OC.CompensacionDatos__r.Name!=null)
        nombreplan=OC.CompensacionDatos__r.Name;    
    }
    else{
        string moneda = OC.moneda__c;
        if(moneda=='Dolares')
        {
            nombreplan = planfac.Name+' USD';
        }
        else
        {
            nombreplan=planfac.Name;
        }
    }
    return nombreplan;
}

public string nombreplan(OperacionComercial__c OC,SubPlanFacturacion__c planfac)
{
    //valida que si el plan es de compensacion devuelva es el valor del campo de la OC
    string nombreplan='';
    if(planfac.Name.contains('Compensacion'))
    {
        if(OC.CompensacionDatos__r.Name!=null)
        nombreplan=OC.CompensacionDatos__r.Name;    
    }
    else{
        string moneda = OC.moneda__c;
        if(moneda=='Dolares')
        {
            nombreplan = planfac.Name+' USD';
        }
        else
        {
            nombreplan=planfac.Name;
        }
    }
    return nombreplan;
}

//metodo que hace las validaciones agarra el plan y los subplanes y valida que los campos obligatorios tengan valor sino devuelve el null

public map<string,boolean> validacionOC(list<OperacionComercial__c> listOC,map<string,list<PlanFacturacion__c>> mapPlanesFac,map<string,list<ParametroFacturacion__c>> mapParametrosSubPlanes)
{
    map<string,boolean> mapResultados = new map<string,boolean>();
    //se recorren todas las OC
    for(OperacionComercial__c OC :listOC)
    {
        //tomar el plan
        boolean bien=false;
        list<PlanFacturacion__c> planes = mapPlanesFac.get(OC.plan__c);
        //si el plan es !=null valida los parametros
        if(planes!=null && planes.size()>0)
        {
            for(PlanFacturacion__c plan1 :planes)
            {
                boolean validacion = validarCampoDependiente(OC,plan1);
                if(validacion){
                        for(ParametroFacturacion__c parametro :plan1.Parametros_de_Facturacion__r)
                        {
                            System.debug('@@-Parametro::'+parametro);
                            if(parametro.Obligatorio__c==true)
                            {
                                //debe buscar que tenga valor el campo en la OC
                                if(parametro.Campo__c!=null)
                                        {string valor =LibreriaUtilitaria_cls.recorreCampos(OC,parametro.Campo__c);
                                            if(valor==null)
                                            {                                                
                                                bien=true;
                                            }
                                        }
                            }
                            //recorre los subplanes
                            for(SubPlanFacturacion__c subplan :plan1.SubPlanesFacturacion__r)
                            {
                                for(ParametroFacturacion__c param :mapParametrosSubPlanes.get(subplan.id))
                                {
                                    if(param.Obligatorio__c==true)
                            {
                                    //buscar el valor si no tiene el valor de bien debe ser true
                                    if(param.Campo__c!=null)
                                        {string valor =LibreriaUtilitaria_cls.recorreCampos(OC,param.Campo__c);
                                            if(valor==null)
                                            {	                                                
                                                bien=true;
                                            }
                                        }
                                }
                                }
                            }
                        }
                }
            }
        }
        //a?ade a la lista 
        mapResultados.put(OC.id,bien);
    }
    
    return mapResultados;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------

public map<string,list<ParametroFacturacion__c>> parametrosSubPlanes(set<string> idsub)
{
    map<string,list<ParametroFacturacion__c>> mapaParametros = new map<string,list<ParametroFacturacion__c>>();
    for(ParametroFacturacion__c param :[Select p.SubPlanFacturacion__c,p.CatalogoProductosFacturacion__c,p.CatalogoProductosFacturacion__r.Name,p.CatalogoProductosFacturacion__r.Servicio__c, p.Objeto__c, p.Name, p.Campo__c,p.Comillas__c,p.Obligatorio__c,p.Financiador__c From ParametroFacturacion__c p where p.SubPlanFacturacion__c in :idsub ] )
    {
        if(mapaParametros.containsKey(param.SubPlanFacturacion__c))
        {
            list<ParametroFacturacion__c> listPar = mapaParametros.get(param.SubPlanFacturacion__c);
            listPar.add(param);
            mapaParametros.put(param.SubPlanFacturacion__c,listPar);
        }
        else{
            list<ParametroFacturacion__c> listPar = new list<ParametroFacturacion__c>();
            listPar.add(param);
            mapaParametros.put(param.SubPlanFacturacion__c,listPar);
        }
    }
    return mapaParametros;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public String parametro(ParametroFacturacion__c param,OperacionComercial__c OC)
{
    //valida el nombre del campo y lo obtiene y llena el valor para el parametro, en el objeto se debe configurar el campo partiendo desde la operacion comercial
    string parametro = '';
    System.debug('@@-param->'+param);
    System.debug('@@-param-OC->'+OC);
    if(Param.Campo__c!=null)
    {string valor =LibreriaUtilitaria_cls.recorreCampos(OC,Param.Campo__c);
        //valida que si el parametro es financiado, valida el valor en la OC
        if(Param.Financiador__c && OC.Financiador__c)
        {
            valor='0';
        }
    if(valor!=null)
    {
        //string valor=splitParametro(param.Campo__c,OC);
        if(param.Comillas__c)
            valor='\''+valor+'\'';
        parametro= RevChainXML_cls.Parameter(param.Name,valor);
    }
     else
     {
        parametro= RevChainXML_cls.Parameter(param.Name,'');
     }
    }
    else
    {
        parametro= RevChainXML_cls.Parameter(param.Name,'');
    }
    return parametro;
}
 
//metodo que arma el canonico con cada uno de las partes del canonico

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public void CrearFacturacion(list<OperacionComercial__c> lstOC)
{
    string xml='';  
    System.debug('@@-@@-lstOC - CrearFacturacion:: '+lstOC);    
    set<string> idOC = new set<string>();
    //-SAO- Creacion de Mapas para el control de las cuentas de facturacion creadas en salesforce y actualizadas segun la cuenta de facturacion creada en RevChain
    Map<String, List<OperacionComercial__c>> mapControlCuentasFacturacion = new Map<String, List<OperacionComercial__c>>();
    Map<String, String> mapCuentaFactAntiguaNueva                         = new Map<String, String>();
    Set<String> cuentasFacturacionSalesforce                              = new Set<String>();
    Set<String> setOCsConCuentasFacturacionSF                             = new Set<String>();
    Map<String, String> mapIdOC_CuentaFacturacion                         = new Map<String,String>();

    for(OperacionComercial__c opc : lstOC)
    {
        //-SAO - armar un Set con las cuentas de facturacion de Salesforce y un mapa con la Cuenta de Facturacion como llave y el valor la lista de OCs         
        if(opc.CuentaFacturacion__r.Name != Null && opc.CuentaFacturacion__r.Name.contains('Fact')) {                           
            System.debug('@@-@@-opc-> '+opc);
            //lista Auxiliar de OCs
            List<OperacionComercial__c> lstAuxOCs;
            
            if(mapControlCuentasFacturacion.containsKey(opc.CuentaFacturacion__r.Name))
                lstAuxOCs = mapControlCuentasFacturacion.get(opc.CuentaFacturacion__r.Name);
            else
                lstAuxOCs = new List<OperacionComercial__c>();

            lstAuxOCs.add(opc);
            mapControlCuentasFacturacion.put(opc.CuentaFacturacion__r.Name, lstAuxOCs);     
            //llenar un set con las cuentas de facturacion de Salesforce (Fact-00000XXX)    
            cuentasFacturacionSalesforce.add(opc.CuentaFacturacion__r.Name);
            //llenar Mapa con los cuya llave es la OC y el valor la Cuenta de Facturacion de Salesforce
            mapIdOC_CuentaFacturacion.put(opc.Id, opc.CuentaFacturacion__r.Name);
            setOCsConCuentasFacturacionSF.add(opc.Id);
        }
        //Set con todos los IDs de la lista de OCs a enviar a facturacion
        idOC.add(opc.id);
    }       
    System.debug('@@-@@-opc.CuentaFacturacion__r.Name-> '+cuentasFacturacionSalesforce);
    System.debug('@@-@@-mapControlCuentasFacturacion-> '+mapControlCuentasFacturacion);

    Set<String> setNOconstruirCanonico = new Set<String>();
    for(String strCuenFactu_SF: mapControlCuentasFacturacion.keySet()) {
        List<OperacionComercial__c> lstOC_CF = mapControlCuentasFacturacion.get(strCuenFactu_SF);       
        if(lstOC_CF.size() >= 2){
            for(Integer i=1; i<lstOC_CF.size(); i++){
                setNOconstruirCanonico.add(lstOC_CF[i].Id);
            }       
        }
    }
    System.debug('@@-@@-setNOconstruirCanonico-> '+setNOconstruirCanonico);


    map<string,OperacionComercial__c> listOCtotal = OperacionesComerciales(idOC);
    map<string,OperacionComercial__c> listOCs = new map<string,OperacionComercial__c>();
    map<string,OperacionComercial__c> listOCLD = new map<string,OperacionComercial__c>();
    //se deben separar en dos listas y enviar hacia facturación de larga distancia
    
    for(OperacionComercial__c oc :listOCtotal.values())
    {
        if(OC.plan__r.NombredelProducto__r.Familia__c=='LARGA DISTANCIA')
        {
            listOCLD.put(oc.id,oc);
        }
        else
        {
            listOCs.put(oc.id,oc);
        }
    }




    
    //obtener la informacion de los planes
    set<string> planesId = new set<string>();
    set<string> CuentasId = new set<string>();
    set<string> PlanSolTIId = new set<string>();
    System.debug('@@-OCS:: '+listOCs);
    list<string> familiaproductos = label.ProductosEspeciales.split(',');
    set<string> familias = new set<string>();
    familias.addAll(familiaproductos);
    
    for(OperacionComercial__c oc :listOCs.values())
    {
        planesId.add(oc.Plan__c);
        cuentasId.add(oc.CuentaCliente__c);
        if(familias.contains(OC.plan__r.NombredelProducto__r.Familia__c))
            {
                PlanSolTIID.add(OC.Plan__c);
            }
    }
    //traer el mapa de informacion de planes
    System.debug('@@-planes id:: '+planesId);
    map<string,list<PlanFacturacion__c>> planesFacturacion = mapFacturacion(planesId);
    map<string,Planes__c> planesSFDC = mapPlanesSFDC(planesid);
    map<string,list<PlanSolucionTI__c>> planesSolucionTI = mapPLanesSolTI(planSolTIID);
    System.debug('@@-planesSolucionTI ;;;'+planesSolucionTI );
    //traer las cuentas 
    map<string,Account> mapCuentas = CuentasconActivos(cuentasId);
    //mapa que guarda operacion comercial y canonico
    map<string,string> mapCanonicos = new map<string,string>(); 
    //mapa para guardar el activo con el Random asignado --//--SAO
    map<string,string> mapAC_Random = new map<string,string>();
    //recorrer las operaciones comerciales
    
    for(OperacionComercial__c oc :lstOC)
    {
        //por cada una buscar la correspondencia en el id 
        System.debug('@@-OC ID::::'+oc.id);
        if(listOCs.containsKey(oc.id))
        {
            OperacionComercial__c OpCom = listOCs.get(oc.id);
            Account cuenta=null;
            if(mapCuentas.containsKey(OpCom.CuentaCliente__c)){
                 cuenta = mapCuentas.get(OpCom.CuentaCliente__c);}
                
            list<PlanFacturacion__c> plan = planesFacturacion.get(OpCom.Plan__c);            
            Planes__c plansfcd = planesSFDC.get(OpCom.plan__c);
            //--SAO         
            Integer numeroRandom = Math.round(Math.random()*100);
            String AC_Random = (listOCs.get(oc.id).Activo__r.Name);//+'-'+numeroRandom;
            //--
            list<PlanSolucionTI__c> planSolucionTI = planesSolucionTI.get(OpCom.Plan__c);
            System.debug('@@-planes sol ti::::'+planSolucionTI);
            string canonico = ArmarCanonico(OpCom,plan,cuenta,planSolucionTI,plansfcd,AC_Random);
            system.debug(canonico);
            mapCanonicos.put(oc.id,canonico);
            mapAC_Random.put(oc.id,AC_Random);
            
        }
    }
    
    //por cada canonico hacer el llamado del servicio
    ServiciosWeb__c sw = ServiciosWeb__c.getValues('RevChain');
    tibcoXml_cls tXml=new tibcoXml_cls();
    list<LogTransacciones__c> logs = new list<LogTransacciones__c>();
    //mapa que ayuda a indentificar cuenta de facturacion y ciclo asignado.
    map<string,string> ciclos = new map<string,string>();
    //mapa que identifica numero de cuenta y objeto cuenta de facturacion para posterior insercion y relacionamiento con la OC
    map<string,CuentaFacturacion__c> mapcuentasFac = new map<string,CuentaFacturacion__c>();
    map<string,CuentaFacturacion__c> mapcuentasFacIns = new map<string,CuentaFacturacion__c>();
    //mapa que identifica la OC con cual numero de OC.
    map<string,string> mapOCFac = new map<string,string>();
    map<string,OperacionComercial__c> mapFacOC = new map<string,OperacionComercial__c>(); 
    map<string,OperacionComercial__c> mapActOC = new map<string,OperacionComercial__c>(); 
    map<string,string> OCcontratos = new map<string,string>();
    List<CuentaFacturacion__c>fallidasConCuentas=new List<CuentaFacturacion__c>();
    Set<String>setFallidasConCuentas=new Set<String>();
    Map<String, CuentaFacturacion__c> mapFallidasAct = new Map<String, CuentaFacturacion__c>();
    
    
    for(string ocId :mapCanonicos.keySet())
    {
        //obtiene la OC y valida que el tipo de operacion por plan sea facturable
        System.debug('@@-ocId-mapCanonicos->'+ocId);
        OperacionComercial__c OCtopp = listOCs.get(ocId);
        if(OCtopp.TOPP__r.Facturable__c && !setNOconstruirCanonico.contains(ocId))
        {
        string request= mapCanonicos.get(ocId);
        System.debug('@@-llamar servicio');
        string response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
        System.debug('@@-llamar servicio2');
        string estado='';       
        string resultadoRevChain='';
            system.debug(response);
            //tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
            try{
                Dom.Document doc = new Dom.Document();
                doc.load(response);
                map<string,string>mapRespuestas =recuperarRespuestaXML(doc);
            //revisar si el estado es bien y no hay error en RevChain
            System.debug('@@-mapa respuestas:: '+mapRespuestas);
            if(mapRespuestas.get('Estado').equals('PASS') && mapRespuestas.get('RespuestaRevChain').equals('Y'))
            {
                //guardar el Id para dejar Activa la Operacion Comercial
                OperacionComercial__c OC = listOCs.get(ocId);
                OC.Estado__c='Facturado';
                //OC.fechadeActivacion__c=system.today();
                OC.EnvioFacturacion__c=false;
                OC.FechaFacturacion__c=system.now();
                mapActOC.put(OC.id,OC);
                //revisar la cuenta de facturacion
                string cuentaFac = mapRespuestas.get('CuentaFacturacion');
                //arma el mapa de las cuentas
                string ciclo = mapRespuestas.get('ciclo');
                ciclos.put(cuentaFac,ciclo);
                mapcuentasFac.put(cuentaFac,null);
                mapOCFac.put(OC.id,cuentaFac);
                mapFacOC.put(cuentaFac,OC);
                OCContratos.put(OC.id,OC.Legalizacion__r.Contrato__c);

                
                
            }
            else if(mapRespuestas.get('Estado').equals('FAIL') || mapRespuestas.get('RespuestaRevChain').equals('N'))
            {
                //dejar el activo En Facturacion
                OperacionComercial__c OC = listOCs.get(ocId);
                OC.Estado__c='No Exitoso Facturacion';
                OC.EnvioFacturacion__c=false;
                OC.FechaFacturacion__c=system.now();
                mapActOC.put(OC.id,OC);
                
                system.debug(OC.CuentaFacturacion__c +' '+mapRespuestas.get('CuentaFacturacion'));
                
                if(OC.CuentaFacturacion__c!=null && mapRespuestas.get('CuentaFacturacion')!=null ){
                    string cuentaFac = mapRespuestas.get('CuentaFacturacion');
                    OC.CuentaFacturacion__r.Name=mapRespuestas.get('CuentaFacturacion');
                    OC.CuentaFacturacion__r.IdUnico__c=mapRespuestas.get('CuentaFacturacion');
                    OC.CuentaFacturacion__r.Fue_creada_en_revchain__c=true;
                    // OC.CuentaFacturacion__r.CodCicloFac__c=mapRespuestas.get('ciclo'); [CG] 02/05/2016 - No se modifica el ciclo si hubo fallo en la integración 
                    setFallidasConCuentas.add(OC.CuentaFacturacion__r.Id);
                    mapFallidasAct.put(OC.CuentaFacturacion__r.Id, OC.CuentaFacturacion__r);
                    //fallidasConCuentas.add(OC.CuentaFacturacion__r);
                    
                }

                

                
            }




            }
            catch(system.Exception e)
            {
                System.debug('@@-fallo:: '+e.getMessage());
                OperacionComercial__c OC = listOCs.get(ocId);
                OC.Estado__c='No Exitoso Facturacion';
                OC.EnvioFacturacion__c=false;
                mapActOC.put(OC.id,OC);
            }
            
            logs.add(generarLog(ocId,request,response,estado,resultadoRevChain,mapAC_Random.get(ocId)));
        }
    }
    //Actualiza cuando el servicio responde como fallido pero crea la cuenta
    if(!setFallidasConCuentas.isEmpty()){
        for(String idCuentaFallida: setFallidasConCuentas) {
            fallidasConCuentas.add(mapFallidasAct.get(idCuentaFallida));
        }       
    }
    update fallidasConCuentas;

    //llamar facturaciónlargadistancia
    System.debug('@@-Facturacion LD');
    if(listOCLD.values().size()>0)
    {
    System.debug('@@-Facturacion LD OC:: '+listOCLD.values());
    FacturacionLargaDistancia_cls facld = new FacturacionLargaDistancia_cls();
    facld.FacturacionLargaDistancia(listOCLD.values());
    }   
    
    //buscar las cuentas de facturacion existentes y rellenar el mapa
    for(CuentaFacturacion__c cuentFac :[select id,Name from CuentaFacturacion__c where Name in :mapCuentasFac.keySet() ])
    {
        mapCuentasFac.put(cuentFac.Name,cuentFac);
    }
    //validar cada una de las cuentas si tiene o no y generar la cuenta
    for(string cuentaFac :mapcuentasFac.keySet())
    {
        if(mapCuentasFac.get(cuentaFac)==null)
        {
            //crear la cuenta de facturacion relacionada
            CuentaFacturacion__c cuentaFacNew =armarCuentaFacturacion(cuentaFac,ciclos.get(cuentaFac),mapFacOC.get(cuentaFac));
            //a?adir al mapa de insercion
            mapcuentasFacIns.put(cuentaFac,cuentaFacNew);
        }
    }
    
    //se insertan los valores de las nuevas cuentas
    map<id,Contract> mapUpdContratos = new map<id,Contract>();
    if(mapcuentasFacIns.values().size()>0)
    {
        Database.Update(mapcuentasFacIns.values(),false);
        //Database.Upsert(mapcuentasFacIns.values(),Schema.CuentaFacturacion__c.IdUnico__c,false);
        //se debe validar cada cuenta de facturacion si la OC tiene contrato sino debe asociarse al contrato de lo contrario solo con la cuenta y la OC.
        //sacar los contratos de las que se van a 
        map<string,Contract> mapContratos = Contratos(OCContratos.values());
        //una vez teniendo los contratos comenzar a recorrer las operaciones comerciales y validar si tienen valor
        //recorrer las OC
        
        for(string OCid :mapOCFac.keySet())
        {
            //extrae la OC del mapa
            OperacionComercial__c OCC = listOCs.get(OCid);
            //trae la cuenta de facturacion
            CuentaFacturacion__c cuentaFac = mapCuentasFacIns.get(mapOCFac.get(OCid));
            //traer el contrato
            Contract contrato=mapContratos.get(OCContratos.get(OCid));
            //comenzar a validar si el contrato no tiene cuenta de facturacion
            if(cuentaFac!=null)
                    {
                        
            if(contrato!=null && contrato.CuentaFacturacion__c==null)
            {
                //asigna la cuenta de facturacion al contrato.
                
                        contrato.CuentaFacturacion__c=cuentaFac.id;
                        //a?adir a lista para actualizar los contratos
                        mapUpdContratos.put(contrato.id,contrato);
            } 
            if(OCC!=null && OCC.CuentaFacturacion__c==null)
                    {
                        OCC.CuentaFacturacion__c=cuentaFac.id;
                        mapActOC.put(OCC.id,OCC);
                    }
        }
    }
    }
    if(mapUpdContratos.values().size()>0)
    {
        Database.Update(mapUpdContratos.values(),false);
    }
    if(mapActOC.values().size()>0)
    {
        Database.Update(mapActOC.values(),false);
    }
    if(logs.size()>0)
        insert logs;
}


public map<string,Contract> Contratos(list<string> idOC)
{
    //volver un mapa los contratos con las OC
    map<string,Contract> mapContratos = new map<string,Contract>([select id,Name,CuentaFacturacion__r.Name,CuentaFacturacion__c from Contract where id in :idOC]);
    return mapContratos; 
}

/*
* metodo que es invocado desde el batch para realizar la facturacion.
*/
public void llamadoFacturacion(map<id,OperacionComercial__c> OCnews ,map<id,OperacionComercial__c> OCold)
{
    set<string> ACid = new set<string>();
    set<string> TOPPid = new set<string>();
    map<string,string> OCAC = new map<string,string>();
    //llama las operaciones comerciales
    set<string> idOC = new set<string>();
    for(string opc : OCnews.KeySet())
    {
        idOC.add(opc);
    }
    map<string,OperacionComercial__c> listOCs = OperacionesComerciales(idOC);
    map<string,OperacionComercial__c> listLegOCs = OCLegalizaciones(idOC);
    
    //obtener la informacion de los planes
    set<string> planesId = new set<string>();
    set<string> PlanSolTIId = new set<string>();
    System.debug('@@-OCS:: '+listOCs);
    list<string> familiaproductos = label.ProductosEspeciales.split(',');
    set<string> familias = new set<string>();
    familias.addAll(familiaproductos);
    for(OperacionComercial__c oc :listOCs.values())
    {
        planesId.add(oc.Plan__c);
        if(familias.contains(OC.plan__r.NombredelProducto__r.Familia__c))
            {
                PlanSolTIID.add(OC.Plan__c);
            }
    }
    //traer el mapa de informacion de planes
    System.debug('@@-planes id:: '+planesId);
    map<string,list<PlanFacturacion__c>> planesFacturacion = mapFacturacion(planesId);
    map<string,list<PlanSolucionTI__c>> planesSolucionTI = mapPLanesSolTI(planSolTIID);
    //llama el mapa de validacion de las OC que tengan los datos obligatorios para los campos
    set<string> idsubplanes = new set<string>();
    for(list<PlanFacturacion__c> plan : planesFacturacion.values() )
    {
        for(PlanFacturacion__c plan2 :plan)
        {
        for(SubPlanFacturacion__c subplan : plan2.SubPlanesFacturacion__r)
        {
            idSubplanes.add(subplan.id);
        }
        }
    }
    map<string,list<ParametroFacturacion__c>> mapplanesFacturacion = mapplanesFacturacion(idsubplanes);
    map<string,boolean> mapValidacionOC = validacionOC(listOCs.values(),planesFacturacion,mapplanesFacturacion);
    //recorre las operaciones comerciales y evalua que debe pasar al estado "Envio Facturacion" y debe tener legalizacion
    
    for(string OC : OCnews.keySet())
    {       
        
        //se cambia del estado a la diligenciacion de la fecha de activacion
        //if((OCnews.get(OC).Estado__c=='Activa' && OCold.get(OC).Estado__c!='Activa') || (OCnews.get(OC).Estado__c=='Pendiente Facturacion' && OCold.get(OC).Estado__c=='Pendiente Informacion Facturacion')   )
        //if((OCnews.get(OC).FechadeActivacion__c!=null && OCold.get(OC).FechadeActivacion__c==null) || (OCnews.get(OC).Estado__c=='Pendiente Facturacion' && OCold.get(OC).Estado__c=='Pendiente Informacion Facturacion')   )     
//if( ( (OCnews.get(OC).FechadeActivacion__c!=null && OCold.get(OC).FechadeActivacion__c==null) || (OCnews.get(OC).Estado__c=='Pendiente Facturacion' && OCold.get(OC).Estado__c=='Pendiente Informacion Facturacion') ) ) 
        //LEM -03-09-2015   se vuelve a colocar la validacion que sea por estado dado que hay OC que traen diligenciada la fecha de activación
        if( ( (OCnews.get(OC).Estado__c=='Activa' && OCold.get(OC).Estado__c!='Activa') || (OCnews.get(OC).Estado__c=='Pendiente Facturacion' && OCold.get(OC).Estado__c=='Pendiente Informacion Facturacion') ) ) 
        {
            System.debug('@@-validacion OK');
            OperacionComercial__c OpCom =OCnews.get(OC);
            Acid.add(OpCom.Activo__c);
            TOPPid.add(OpCom.TOPP__c);
            OCAC.put(OpCom.id,OpCom.Activo__c);
        }
        /*else
        {
            OperacionComercial__c OpCom =OCnews.get(OC);
                OpCom.EnvioFacturacion__c=false;
                OpCom.Estado__c='Pendiente Informacion Facturacion';
        }*/
    //validar que las   
        
    }
    System.debug('@@-tener en cuenta: '+OCAC.values().size());
    map<string,ActivoETB__c> mapActivos = new map<string,ActivoETB__c>([Select id,IDServicio__c,NumeroConexion__c from ActivoETB__c where id in :Acid]);
    map<string,TOPP__c> mapTOPP = new map<string,TOPP__c>([Select id,facturable__c,aplicaGerenteProyecto__c,TipodeOperacionporPlan__c from TOPP__c where id in :TOPPid]);

        for(string OC : OCAC.KeySet())
        {
            OperacionComercial__c OpCom =OCnews.get(OC);
            OperacionComercial__c OpCom1 =listOCs.get(OC);
            OperacionComercial__c OpComLeg = listLegOCs.get(OC);
            System.debug('@@-11');
            System.debug('@@-OpCom.TOPP__c'+OpCom.TOPP__c);
            System.debug('@@-mapTOPP.containsKey(OpCom.TOPP__c)'+mapTOPP.containsKey(OpCom.TOPP__c));
            //validacion si es facturable
            if(mapTOPP.containsKey(OpCom.TOPP__c) && mapTOPP.get(OpCom.TOPP__c).Facturable__c==true)
            {
                System.debug('@@-Ingreso Linea 760');               
                //validacion de campo obligatorio por producto o familia
                TOPP__c top = mapTOPP.get(OpCom.TOPP__c);
                string campo='';
                ConfFamiliasproductos__c confproducto = ConfFamiliasproductos__c.getValues(Opcom1.plan__r.NombredelProducto__r.Familia__c);
                                
                if(confproducto!=null)
                {
                	campo= confproducto.campo__c;                
                }                  
                
                if(OpCom1.plan__r.Nombredelproducto__r.Familia__c=='LTE' && OpCom1.Plan__r.Name != System.Label.Plan_Numeracion_Abreviada && OpCom1.Plan__r.Name != 'Plan Numeral Abreviado OnDemand 200') //FSARASTY, 15/02/2018: Se incluye excepción para marcación abreviada.
                {
                    system.debug('nada');                      
                }
                // se almacenan 
                else if(OCnews.get(OC).CuentaFacturacion__c!=null &&  listOCs.get(OC).CuentaFacturacion__r.Tipo_Facturacion__c == 'Cuenta de Cobro'){ //-SAO - Validar Pendiente Facturacion Cuenta de cobro
                    OpCom.EnvioFacturacion__c=false;
                    OpCom.Estado__c='Pendiente Facturacion Cuenta de Cobro';
                }
                else if(listOCs.get(OC).CuentaCliente__r.SubSegmento__c == Label.CarrierYOperadores
                        || listOCs.get(OC).CuentaCliente__r.SubSegmento__c == Label.CarrierYOperadores2
                        || listOCs.get(OC).CuentaCliente__r.SubSegmento__c == Label.CarrierYOperadores4){ //-SAO - Carries y otros operadores
                    OpCom.EnvioFacturacion__c=false;
                    OpCom.Estado__c=Label.PendienteCarries;
                }
                 //if(mapActivos.Containskey(OCAC.get(OC)) && mapActivos.get(OCAC.get(OC)).get(campo)!=null && (OpComLeg.Legalizacion__r.Estado__c=='Gestionado' || OpComLeg.TOPP__r.TipodeOperacionporplan__c=='Retiro') && OCnews.get(OC).CuentaFacturacion__c!=null )
                else if(CondicionesGenerales(campo,OpCom1,top,OpComleg))
                {
                    System.debug('@@-12');
                    System.debug('@@-@@-CuentaFacturacion__r.Tipo_Facturacion__c->'+listOCs.get(OC).CuentaFacturacion__r.Tipo_Facturacion__c);
                    System.debug('@@-@@-OpCom1->'+OpCom1);
                    List<PlanSolucionTI__c> resultado2;
                    if(familias.contains(OpCom1.plan__r.NombredelProducto__r.Familia__c))
                    {
                    
                        System.debug('@@-13');
                        //valida que sea la informaci?n:
                        facturacionSolucionesTI_cls Fac = new facturacionSolucionesTI_cls();                        
                        string cod=OpCom.Plan__c;
                        list<PlanSolucionTI__c> plansolucion = planesSolucionTI.get(cod);
                        PlanSolucionTI__c resultado=fac.validarPlanSeleccionado(OpCom1,plansolucion);
                        if(OpCom1.plan__r.NombredelProducto__r.Familia__c == 'SOPORTE REMOTO Y HERRAMIENTAS'
                           || OpCom1.plan__r.NombredelProducto__r.Familia__c == 'SOLUCIONES TI'
                           || OpCom1.plan__r.NombredelProducto__r.Familia__c == 'SOLUCION DE NETWORKING'
                           || OpCom1.plan__r.NombredelProducto__r.Familia__c == 'SAAS TERCERO'){
                            resultado2=fac.validarPlanSeleccionadoSoluTI(OpCom1,plansolucion);                  
                            System.debug('@@-resultado2::> '+resultado2);
                        }
                        System.debug('@@-resultado:: '+resultado);
                        if(resultado!=null)
                        {
                            System.debug('@@-14');
                            OpCom.EnvioFacturacion__c=true;
                            OpCom.Estado__c='Pendiente Facturacion';
                            OpCom.FechaPendienteFacturacion__c=system.now();
                            OpCom.PlanSolucionTI__c=resultado.id;
                        }
                        else if(resultado2!=null && !resultado2.isEmpty()){
                            System.debug('@@-14.2');
                            OpCom.EnvioFacturacion__c=true;
                            OpCom.Estado__c='Pendiente Facturacion';
                            OpCom.FechaPendienteFacturacion__c=system.now();
                            if(resultado2[0].id != Null)
                                OpCom.PlanSolucionTI__c=resultado2[0].id;                           
                        }
                        else{
                            System.debug('@@-Ingreso Retiro else');
                            OpCom.EnvioFacturacion__c=false;
                            OpCom.Estado__c='Pendiente Informacion Facturacion';
                        }
                        
                    }

                    //validaciones de larga distancia
                    /*else if(OpCom1.plan__r.NombredelProducto__r.Familia__c=='LARGA DISTANCIA')
                    {
                        FacturacionLargaDistancia_cls facld = new FacturacionLargaDistancia_cls();
                        if(facld.validacionFacturacion(OpComLeg))
                        {
                            OpCom.EnvioFacturacion__c=true;
                            OpCom.Estado__c='Pendiente Facturacion';
                            OpCom.FechaPendienteFacturacion__c=system.now();
                        }
                        else
                        {
                                system.debug('16');
                                OpCom.EnvioFacturacion__c=false;
                                OpCom.Estado__c='Pendiente Informacion Facturacion';
                        }
                        
                    }*/
                    else{
                        
                        if(top.TipodeOperacionporPlan__c=='Retiro')
                        {
                            //si lleg? hasta este punto debe tener lo minimo para el retiro
                            System.debug('@@-Ingreso a Retiros->');
                            OpCom.EnvioFacturacion__c=true;
                            OpCom.Estado__c='Pendiente Facturacion';
                            OpCom.FechaPendienteFacturacion__c=system.now();
                        }
                        else
                        {
                            if(mapValidacionOC.get(OC)!=null && !mapValidacionOC.get(OC))
                            {
                                System.debug('@@-15');
                            OpCom.EnvioFacturacion__c=true;
                            OpCom.Estado__c='Pendiente Facturacion';
                            OpCom.FechaPendienteFacturacion__c=system.now();
                            }
                            
                            else
                            {                                
                                System.debug('@@-16');
                                OpCom.EnvioFacturacion__c=false;
                                OpCom.Estado__c='Pendiente Informacion Facturacion';
                            }
                        }
                    }
                }               
                /*else if(OCnews.get(OC).CuentaFacturacion__c!=null && ( listOCs.get(OC).CausalRetiro__c == 'Por Falta de Pago' || listOCs.get(OC).CausalRetiro__c == 'Por Ente de Control y Vigilancia' )){ //-SAO - Validar Pendiente Facturacion Retiros
                    OpCom.EnvioFacturacion__c=true;
                    OpCom.Estado__c='Pendiente Facturacion';
                }*/
                else{
                        //OperacionComercial__c OpCom =OCnews.get(OC);
                        System.debug('@@-17');
                        OpCom.EnvioFacturacion__c=false;
                        OpCom.Estado__c='Pendiente Informacion Facturacion';
                }
            }
        }
        
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 public LogTransacciones__c generarLog(string idOC,string request,string response, string estado, string CodigoRespuesta, string AC_Random){
        
        LogTransacciones__c lt =new LogTransacciones__c(CorrelationId__c=idOC,Informacion_Enviada__c=request,Informacion_Recibida__c=response,Estado__c=estado,Name='Canonico RevChain',CodigoRespuesta__c=CodigoRespuesta,AC_CorrelationID_Random__c=AC_Random,LTE_Operacion_Comercial__c=idOC);
        
        return lt;
    
    
    }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public string ArmarCanonico(OperacionComercial__c OC,list<PlanFacturacion__c> PlanFac,Account cuenta,list<PlanSolucionTI__c> planesSolTI,Planes__c plan, string AC_Random)
{
    
    string xml='';
    
    //comenzar a armar las etiquetas iniciales
    xml+='';
    xml+='<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns=\"http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0\" xmlns:v1=\"http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0\" xmlns:v11=\"http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0\">';
    xml+='<soapenv:Header/>';
    xml+='<soapenv:Body>';
    xml+='<ns:WSRequestSFRevChain>';
    xml+=' <v1:WSRequestHeader>';
    xml+='<v1:System correlationID=\"'+AC_Random+'\" processingServer="?">?</v1:System>';
    xml+='<v1:Property name="?" value="?">?</v1:Property>';
    xml+='</v1:WSRequestHeader>';
    xml+='<v11:CanonicalMessage>';
    xml+='<v11:OrderFulfilment>';
            //sender
            xml+=RevchainXML_cls.sender();
            //Identification
            xml+=RevchainXML_cls.Identification(OC);
            //SalesOrder
            xml+=RevchainXML_cls.SalesOrder(OC);
            //BusinessReference
            xml+=RevchainXML_cls.BusinessReference(OC);
            //CustomerPartyAcount
            xml+=RevChainXML_cls.CustomerPartyAccount(OC);
            //Custom
            xml+=RevChainXML_cls.Custom(OC);
            //SalesOrderLine 1 por cada producto
            xml+=RevChainXML_cls.PartyIdentification(OC);
            //validar que el producto no sea de Solucion TI
            System.debug('@@-Familia del producto:: '+OC.plan__r.NombredelProducto__r.Familia__c);
            list<string> familiaproductos = label.ProductosEspeciales.split(',');
            set<string> familias = new set<string>();
            familias.addAll(familiaproductos);
            if(familias.contains(OC.plan__r.NombredelProducto__r.Familia__c))
            {
                System.debug('@@- plan llamdo - Solu TI::> '+plan);
                System.debug('@@- PlanesSolTI - Solu TI::> '+PlanesSolTI);
                FacturacionSolucionesTI_cls factSolTI = new FacturacionSolucionesTI_cls();
                FacturacionSolucionesTI_cls.SolucionTI listaTI =factSolTI.datosCanonicoSolTI(OC,plan,PlanesSolTI);
                System.debug('@@- listaTI - Solu TI::> '+listaTI);
                List<FacturacionSolucionesTI_cls.SolucionTI> lstSolucionesTI = factSolTI.datosCanonicoSolTIcobroRCyNRC(OC,plan,PlanesSolTI);
                System.debug('@@- lstSolucionesTI - Solu TI::> '+lstSolucionesTI);
                if(OC.tipoFacturacion__c==Label.CobroUnicoRecurrente)
                    xml+=SalesOrderLineSolTI(OC,lstSolucionesTI[0],Cuenta,lstSolucionesTI);
                else
                    xml+=SalesOrderLineSolTI(OC,listaTI,Cuenta,null);
            }
            else{
                // Se valida si la OC contiene uno de los planes SD-WAN con un cobro no recurrente (Valorunicavez__c)
                if((OC.Plan__r.NombredelProducto__r.Name == Label.SDWAN_Nombre_Producto || OC.Plan__r.NombredelProducto__r.Name == Label.BkpOffice365_Nombre_Producto) && OC.Valorunicavez__c > 0){
                    for(PlanFacturacion__c planfactu : PlanFac)
                    {                    
                        if(validarCampoDependiente(OC,planfactu))
                        {                            
                            if(planfactu.Name == Label.SDWAN_Nombre_Plan_NoRecurrente){                         
                             	xml+=SalesOrderLine(OC,PlanFactu,Cuenta);
                            	//saltarse el for ya eligio un plan
                            	break;   
                            } 
                            if(planfactu.Name == Label.BkpOffice365_Nombre_Plan_NoRecurrente){                         
                             	xml+=SalesOrderLine(OC,PlanFactu,Cuenta);
                            	//saltarse el for ya eligio un plan
                            	break;   
                            }                           
                        }
                    }
                }else{
                    //se debe recorrer la lista de los planes relacionados                  
                    for(PlanFacturacion__c planfactu : PlanFac)
                    {                    
                        if(validarCampoDependiente(OC,planfactu))
                        {                           
                            xml+=SalesOrderLine(OC,PlanFactu,Cuenta);
                            //saltarse el for ya eligio un plan
                            break;
                        } //llamar el metodo
                    }
                }
            }
     xml+='<ProvisioningResponse>Y</ProvisioningResponse>';
     xml+='</v11:OrderFulfilment>';       
     xml+='<v11:BillingProcess>';
     //customer
     xml+=RevChainXML_cls.Customer(OC);
     //customerBill
     xml+=RevChainXML_cls.CustomerBill(OC);
     xml+='<Tax>';
     xml+='<TaxAmount>0</TaxAmount>';
     xml+='</Tax>';
     xml+='</v11:BillingProcess>';
     xml+='</v11:CanonicalMessage>';
     xml+='</ns:WSRequestSFRevChain>';
     xml+='</soapenv:Body>';
     xml+='</soapenv:Envelope>';
    return xml;
}

public boolean validarCampoDependiente(OperacionComercial__c OC, PlanFacturacion__c plan)
{
    boolean valido=true;
    string campo=plan.CampoDependiente__c;
    string valorE=plan.ValorDependiente__c;
    string resultado;
    if(campo!=null)
    {
        valido=false;
    resultado=LibreriaUtilitaria_cls.recorreCampos(OC,campo);
    if(resultado!=null)
    {
        valido=true;
        if(valorE!=null)
        {
            if(valorE==resultado)
            {
                valido=true;
            }
            else
            {
                valido=false;
            }
        }
    }
    }
    return valido;
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public map<string,OperacionComercial__c> OperacionesComerciales(set<string> idsOC)
{
    //llama los datos de la cuenta dentro del activo,y planes
    map<string,OperacionComercial__c> listOC =new map<string,OperacionComercial__c>([
        Select SucursalOrigen__r.Ciudad__r.CodigoDane__c,o.Caso__c, o.Capacidad_Almacenamiento__c, o.Valor_Capacidad_Almacenamiento__c,Numero_Abreviado__c, Numero_Abreviado_Formula__c, 
        o.PlanLD__c, o.IDservicio__c,o.numeroConexion__c,o.ValorEquipos2__c,o.Activo__r.Plan_Larga_Distancia_Anterior__c,o.FechaFacturacion__c,o.FechaPendienteFacturacion__c,
        o.ValorObraCivil__c,o.ValorCargoInstalacion__c,o.Financiador__c,o.TipoFacturacion__c,o.TipoVenta__c,o.PlanSolucionTI__c,o.AliadoColaborador__c,
        o.Plan__r.NombrePlanSolucionTI__c,o.plan__r.Name,o.plan__r.NombredelProducto__c,o.Plan__r.NombredelProducto__r.Familia__c,
        o.Plan__r.NombredelProducto__r.LineaNegocio__c,o.DescuentoPorc__c,o.UnidaddeMedida__c,o.AnchobandaGPON__c,o.CompensacionDatos__r.Name,
        o.CuentaFacturacion__r.Tipo_Facturacion__c,o.CuentaFacturacion__r.Ciudad__r.Name,o.CuentaFacturacion__r.Ciudad__r.Indicativo__c,
        o.CuentaFacturacion__r.Ciudad__r.CodigoDane__c,o.CuentaFacturacion__r.DirCorresp__c,o.CuentaFacturacion__r.Fin_de_consumo__c,o.Oportunidad__r.CreatedDate,
        o.Moneda__c,o.Tipo_de_Conectividad__c,o.RangosDisponibilidad__c,Identificaci_n_del_Valor_NO_Recurente__c,o.CuentaCliente__c,
        o.Legalizacion__r.Contrato__r.Forma_de_Pago__c,o.fechadeActivacion__c,o.id,o.Capacidad__c,o.Valor_Recurrente_Aliado__c,
        o.CuentaFacturacion__c,o.CuentaFacturacion__r.Name,o.CuentaFacturacion__r.Fue_creada_en_revchain__c,o.CuentaFacturacion__r.CodCicloFac__c,
        o.Legalizacion__r.Contrato__c,o.Legalizacion__r.Contrato__r.PlazoPago__c, o.Legalizacion__r.Contrato__r.CuentaFacturacion__r.Name,
        o.Legalizacion__r.Contrato__r.SpecialTerms,o.Plan__c,o.TOPP__r.TipodeOperacionporplan__c,o.TOPP__r.Facturable__c,
        o.Valorunicavez__c, o.ValorTarifaPlan__c, o.Tarifa__c, o.Activo__r.Valorunicavez__c,o.Activo__r.IDservicio__c, 
        o.Activo__r.ValorTarifaPlan__c,o.Activo__r.AnchoBanda__r.Name,o.Activo__r.AnchoBanda__r.Numero__c,o.Activo__r.AnchoBanda__r.Unidaddemedida__c,o.Activo__r.MedioUM__c,
        o.Activo__r.Equipo__c, o.Activo__r.SucursalOrigen__c,o.Activo__r.SucursalOrigen__r.Ciudad__r.Name,o.Activo__r.SucursalOrigen__r.Ciudad__r.CodigoDane__c,
        o.Activo__r.ExternalServiceID__c,o.Activo__r.SucursalOrigen__r.Direccion__c, o.Activo__r.SucursalDestino__c,o.Activo__r.SucursalDestino__r.Direccion__c,
        o.Activo__r.SucursalDestino__r.Ciudad__r.Name,o.Activo__r.SucursalDestino__r.Ciudad__r.CodigoDane__c, o.Activo__r.Plan__c,
        o.Activo__r.NombredelProducto__r.CodigoFacturacion__c,o.Activo__r.NombredelProducto__r.PremisasFacturacion__c,o.Activo__r.CuentaFacturacion__r.Name ,
        o.Activo__r.NumeroConexion__c,o.Activo__r.Nombredelcliente__c, o.Activo__r.NombredelaCuenta__c, o.Activo__r.NombredelProducto__c, 
        o.Activo__r.Name, o.Activo__r.LIneadeNegocio__c, o.Activo__r.Familia__c, o.Activo__c,o.CuentaCliente__r.Ciudad__r.Name,o.CuentaCliente__r.Ciudad__r.Indicativo__c,
        o.CuentaCliente__r.Ciudad__r.CodigoDane__c,o.CuentaCliente__r.AccountNumber,o.CuentaCliente__r.Tipodedocumento__c, o.CuentaCliente__r.SubSegmento__c, 
        o.CuentaCliente__r.Segmento__c, o.CuentaCliente__r.RazonSocial__c, o.CuentaCliente__r.Phone, o.CuentaCliente__r.Name, o.CuentaCliente__r.Direccion__c, 
        o.CuentaCliente__r.DigitodeVerificacion__c, o.CuentaCliente__r.Ciudad__c,o.CausalRetiro__c,Valor_Equipos__c,Valor_unica_Vez_Aliado__c,
        (Select Aliado__c, Tipo_de_Aliado__c From Viabilidades__r where    Respuestadeviabilidad__c='Viable'),
        Plan__r.NombredelProducto__r.Name,o.Fidelizacion__c, o.Fidelizacion__r.Fidelizacion__r.Origen_de_la_Retencion__c 
        From OperacionComercial__c o where o.id in :idsOC]);
    //llena el mapa de los planes
    return listOC;
}

public map<string,Account> cuentasconActivos (set<string> idcuentas)
{
    return new map<string,Account>([select id,(Select Id, NombredelProducto__r.CodigoFacturacion__c,NombredelProducto__r.PremisasFacturacion__c,NombredelProducto__r.Familia__c, Oportunidad__c, Nombredelcliente__c, Familia__c, LIneadeNegocio__c From Activos_ETB__r where estado__c in('Activo')) from Account where id in :idCuentas]);
}

public map<string,OperacionComercial__c> OCLegalizaciones(set<string> idsOC)
{
    map<string,OperacionComercial__c> listOC =new map<string,OperacionComercial__c>([Select /*o.PLanLD__c,*/O.Activo__r.ExternalServiceID__c,o.Legalizacion__r.CreatedDate,o.legalizacion__c,o.numeroConexion__c,o.Legalizacion__r.Estado__c,o.ValorEquipos2__c,o.FechaFacturacion__c,o.FechaPendienteFacturacion__c,TOPP__r.TipodeOperacionporplan__c From OperacionComercial__c o where o.id in :idsOC]);
    //llena el mapa de los planes
    return listOC;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------
public map<string,list<PlanFacturacion__c>> mapFacturacion(set<string> idPlanesSFDC)
{
    //devuelve el plan de facturacion junto con los subplanes y parametros
    map<string,list<PlanFacturacion__c>> mapPlanes = new map<string,list<PlanFacturacion__c>>();
    list<PlanFacturacion__c> lstplanes = [Select p.CampoDependiente__c,p.ValorDependiente__c,p.Name,p.Plan__c, p.PlanFacturacion__c, p.CatalogoProductosFacturacion__c,p.CatalogoProductosFacturacion__r.Name,p.CatalogoProductosFacturacion__r.ConnectionTypeID__c,p.CatalogoProductosFacturacion__r.ConnectionID__c,p.CatalogoProductosFacturacion__r.Servicio__c, (Select Name, PlanFacturacion__c,CatalogoProductosFacturacion__r.Name,CatalogoProductosFacturacion__r.Servicio__c,CatalogoProductosFacturacion__c,CampoDependiente__c,ValorDependiente__c From SubPlanesFacturacion__r), (Select Name, Objeto__c, Campo__c,Comillas__c,Obligatorio__c,Financiador__c From Parametros_de_Facturacion__r) From PlanFacturacion__c p
                                          where plan__c in :idPlanesSFDC AND (Tipo_agrupador__c=null OR Tipo_agrupador__c='Facturacion'  OR Tipo_agrupador__c='') ];
    for(PlanFacturacion__c plan : lstplanes)
    {
        if(mapPlanes.containsKey(plan.Plan__c))
        {
            list<PlanFacturacion__c> listaPLan = mapPlanes.get(plan.Plan__c);
            listaPLan.add(plan);
            mapPlanes.Put(plan.Plan__c,listaPLan);
        }
        else
        {
            list<PlanFacturacion__c> lista = new list<PlanFacturacion__c>();
            lista.add(plan);
            mapPlanes.Put(plan.Plan__c,lista);
        }
        
        
    }    
    return mapPlanes;
}


public map<string,list<PlanSolucionTI__c>> mapPlanesSolTI(set<string> Planes)
{
    map<string,list<PlanSolucionTI__c>> mapplanes = new map<string,list<PlanSolucionTI__c>>();
    list<PlanSolucionTI__c> planess = [Select p.Reventa__c, p.Recurrente__c, p.Producto__c, p.Productivizacion__c, p.Plan__c, p.Name, p.Id, p.Aliado__c,AliadoRel__c, (Select Name, Objeto__c, Campo__c, PlanFacturacion__c, Comillas__c, Obligatorio__c, Financiador__c, PlanSolucionTI__c From ParametrosFacturacion__r) From PlanSolucionTI__c p where p.PLan__c in :planes ];
    System.debug('@@-entra : '+planess.size());
    for(PlanSolucionTI__c plan :planess)
    {
        if(mapplanes.containsKey(plan.Plan__c))
        {
            list<PlanSolucionTI__c> lista = mapplanes.get(plan.Plan__c);
            lista.add(plan);
            mapplanes.put(plan.Plan__c,lista);
        }
        else
        {
            list<PlanSolucionTI__c> lista = new list<PlanSolucionTI__c>();
            lista.add(plan);
            mapplanes.put(plan.Plan__c,lista);
            
        }
    }
    return mapplanes;
}


public map<string,Planes__c> mapPlanesSFDC(set<string> Planes)
{
    map<string,Planes__c> mapplanes = new map<string,Planes__c>([Select p.TipodePlan__c, p.NombrePlanSolucionTI__c, p.Name, p.Id, p.Estado__c, p.Espromocion__c From Planes__c p where p.Id in :planes ]);
    return mapplanes;
}



public map<string,list<ParametroFacturacion__c>> mapplanesFacturacion (set<string> idPlanes)
{
    //devuelve el plan de facturacion junto con los subplanes y parametros
    map<string,list<ParametroFacturacion__c>> mapPlanes = new map<string,list<ParametroFacturacion__c>>();
    list<SubPlanFacturacion__c> lstplanes = [Select p.id,(Select Name, Objeto__c, Campo__c,Comillas__c,Obligatorio__c From Parametros_de_Facturacion__r) From SubPlanFacturacion__c p where id in :idPlanes ];
    for(SubPlanFacturacion__c plan : lstplanes)
    {
        list<ParametroFacturacion__c> lstParam = new list<ParametroFacturacion__c>();
        for(ParametroFacturacion__c param : plan.Parametros_de_Facturacion__r)
        {
            lstParam.add(param);
        }
        mapPlanes.put(plan.id,lstParam);
    }
    return mapPlanes;
}

//metodo que arma la respuesta dependiendo del response
public map<string,string> recuperarRespuestaXML(Dom.Document doc)
{
    //Dom.Document doc = new Dom.Document();
//doc.load(respuestaXML);//Here xmlstring data is from the above XML shown above
//Retrieve the root element for this document.
Dom.XMLNode env= doc.getRootElement();
//System.debug('@@-****'+env);
//list<Dom.XmlNode> Body=env.getChildren();
system.debug(env.getNamespace());
string namespace = env.getNamespace();
//System.debug('@@-&&&&'+Body);
//mapa que almacena todas las respuestas en strings: estado PASS o FAIL
//respuesta Revchain
map<string,string> mapRespuestas= new map<string,string>();
 Dom.XMLNode Body=env.getChildElement('Body',namespace);
 Dom.XMLNode ResponseRevChain;
for(Dom.XmlNode nodo : Body.getChildren())
{
    System.debug('@@-nombre: '+nodo.getName());
    if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSResponseSFRevchain'))
        ResponseRevChain=nodo;
}
Dom.XMLNode CanonicalMessage;
Dom.XMLNode WSResponseHeader;
//agarro la respuesta y el canonico
for(Dom.XmlNode nodo : ResponseRevChain.getChildren())
{
    System.debug('@@-nombre: '+nodo.getName());
    if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('CanonicalMessage'))
        CanonicalMessage=nodo;
    else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('WSResponseHeader'))
        WSResponseHeader=nodo;
}
System.debug('@@-Canonico::'+CanonicalMessage.getNameSpace());

System.debug('@@-WSHeaderResponse'+WSResponseHeader.getNameSpace());
Dom.XMLNode Service = WSResponseHeader.getChildElement('Service',WSResponseHeader.getNameSpace());
system.debug(service);
//Obtener del servicio status y fecha
Dom.XMLNode Status = service.getChildElement('status',Service.getNameSpace());
system.debug(Status.GetText());
//recorrer el response y obtener la respuesta
mapRespuestas.put('Estado',Status.GetText());
//recorrer el canonico y buscar respuesta revchain, numeros de cuenta de facturacion
Dom.XMLNode OrderFulfilment = CanonicalMessage.getChildElement('OrderFulfilment',CanonicalMessage.getNameSpace());
Dom.XMLNode Sender;
for(Dom.XmlNode nodo : OrderFulfilment.getChildren())
{
    System.debug('@@-nombre: '+nodo.getName());
    if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('Sender'))
        Sender=nodo;
    
}

System.debug('@@-sentder '+Sender);
/*Dom.XMLNode Description = Sender.getChildElement('Description',Sender.getNameSpace());
    if(Description!=null)
    {
        mapRespuestas.put('RespuestaRevChain',Description.getText());
    }*/
Dom.XMLNode BillingProcess;
for(Dom.XmlNode nodo : CanonicalMessage.getChildren())
{
    System.debug('@@-nombre: '+nodo.getName());
    if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('BillingProcess'))
        BillingProcess=nodo;
    
}
Dom.XMLNode BillingResponse;
Dom.XMLNode CustomerBill;
for(Dom.XmlNode nodo : BillingProcess.getChildren())
{
    System.debug('@@-nombre: '+nodo.getName());
    if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('BillingResponse'))
        BillingResponse=nodo;
    else if(nodo.getName()!=null && nodo.getName().equalsIgnoreCase('CustomerBill'))
        CustomerBill=nodo;
    
}
System.debug('@@-respuesta servicio:: '+BillingResponse);
if(BillingResponse!=null)
{
    mapRespuestas.put('RespuestaRevChain',BillingResponse.getText());
}
//extraer del CustomerBill los valores de la cuenta de facturacion
Dom.XMLNode SuscriberId = CustomerBill.getChildElement('SuscriberId',CustomerBill.getNameSpace());
if(SuscriberId!=null)
{
    mapRespuestas.put('CuentaFacturacion',SuscriberId.getText());
}
Dom.XMLNode InvoicingCycle = CustomerBill.getChildElement('InvoicingCycle',CustomerBill.getNameSpace());
if(InvoicingCycle!=null)
{
    mapRespuestas.put('ciclo',InvoicingCycle.getText());
}
//enviar como texto el nodo customerBill para crear la cuenta de facturaci?n
//mapRespuestas.put('cuentaFac',CustomerBill.toXmlString());
return mapRespuestas;
}

public CuentaFacturacion__c armarCuentaFacturacion(string codFac,String ciclo,OperacionComercial__c OC)
{
    CuentaFacturacion__c cfac = new CuentaFacturacion__c();
    //sacar el nombre
    cfac.Cliente__c=OC.CuentaCliente__c;
    cfac.Estado__c='Activo';
    cfac.Facturable__c=true;
    cfac.Name=codFac;
    cfac.CodCicloFac__c=ciclo;
    cfac.IdUnico__c=codFac;
    cfac.Fue_creada_en_revchain__c=true;
    cfac.id=OC.CuentaFacturacion__c;


//colocar los valores siguientes dentro de la cuenta.

    return cfac;
} 


//------------------------------------------------------------------------------------------------------------------------
//metodo que devuelve los valores de los codigos para el ciclo de facturacion
public string CalculoCodigoFacturacion(OperacionComercial__c OC, Account cuenta)
{
    string codigo='';
    //validar el codigo desde el plan
    if(OC.Activo__r.NombredelProducto__r.PremisasFacturacion__c==null)
    {
        //asignar el valor del plan
        codigo=OC.Activo__r.NombredelProducto__r.CodigoFacturacion__c;
    }
    else{
        //convertir las premisas en set
        list<string> productos = OC.Activo__r.NombredelProducto__r.PremisasFacturacion__c.split(',');
        //la cuenta debe traer la consulta realizada y validar el plan y el producto.
        System.debug('@@-premisas : '+productos);
        set<string> SetProd = new set<string>();
        SetProd.addAll(productos);
        for(ActivoETB__c activo :cuenta.Activos_ETB__r)
        {
            //validar que el producto
            if(SetProd.contains(activo.NombredelProducto__r.Familia__c))
            {
                //validar que el producto no sea banda 
                codigo=activo.NombreDelProducto__r.CodigoFacturacion__c;
            } 
        }
        if(codigo=='')
        {
            codigo=OC.Activo__r.NombredelProducto__r.CodigoFacturacion__c;
        }
    }
    if(codigo==null)
    {
        codigo='';
    }
    
    // se hace la validacion si no es facturacion especial no se sustituye por 8
    if(OC.Legalizacion__r.Contrato__r.Forma_de_Pago__c=='Si')
    {
        codigo='8';
    }
    return codigo;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// metodo que hace la validacion de las condiciones generales para las OC que deben viajar a facturacion.
// metodo que hace la validacion de las condiciones generales para las OC que deben viajar a facturacion.
public boolean CondicionesGenerales(string campo,OperacionComercial__c oc,TOPP__c topp,OperacionComercial__c leg)
{
    //18-08-2015 LEM se va a ultizar el campo External_Service_id del activo para el valor enviando a Revchain, se valida que este diligenciado
    boolean retorno =false;
    DateTime datFechaInicio = DateTime.newInstance(2015, 06, 09, 00, 00, 00);
    //valida el tipo de Operacion por plan
    list<string> topventa =Label.ToppVenta.split(',');
    set<string> tops= new set<string>();
    tops.addAll(topventa);
    if(topp.TipodeOperacionporPlan__c=='Venta' || topp.TipodeOperacionporPlan__c=='Venta' || topp.TipodeOperacionporPlan__c=='Venta' )  
    {
        // debe tener: cuenta de facturacion, legalizacion en estado gestionado
        //if(OC.get(campo)!=null && OC.Cuentafacturacion__c!=null && leg.Legalizacion__c!=null && leg.Legalizacion__r.Estado__c=='Gestionado' && leg.Legalizacion__r.CreatedDate >= datFechaInicio )
        //if(OC.Activo__r.ExternalServiceID__c!=null && OC.Cuentafacturacion__c!=null && leg.Legalizacion__c!=null && leg.Legalizacion__r.Estado__c=='Gestionado' && leg.Legalizacion__r.CreatedDate >= datFechaInicio )
        //- SAO - se agrega condicion que a nivel del contrato deba tener el campo plazo de pago        
        if(OC.Activo__r.ExternalServiceID__c!=null && OC.Cuentafacturacion__c!=null 
        && 
            ( OC.Legalizacion__r.Contrato__r.PlazoPago__c != null && leg.Legalizacion__c!=null && leg.Legalizacion__r.Estado__c=='Gestionado' && leg.Legalizacion__r.CreatedDate >= datFechaInicio
            || OC.Caso__c != null ) // 20/05/2016 - [CG] PM3963 - Se adapta las validaciones para que admita OC sin Legalización pero con Caso 
        )
        {
            retorno=true;
        }
    }
    else if(topp.TipodeOperacionporPlan__c=='Retiro')
    {	        
        System.debug('@@-Ingreso CondicionesGenerales Retiro');
        //debe tener si tiene apliga gerente debe tener legalizacion a menos que la causal de retiro sea 'Por Falta de Pago' o 'Por Ente de Control y Vigilancia' sino solo debe tener numero de conexion       
        if(topp.AplicaGerenteProyecto__c && OC.CausalRetiro__c != 'Por Falta de Pago' && OC.CausalRetiro__c != 'Por Ente de Control y Vigilancia')
        {            
            //if(OC.get(campo)!=null && OC.Cuentafacturacion__c!=null && leg.Legalizacion__c!=null &&leg.Legalizacion__r.Estado__c=='Gestionado' && leg.Legalizacion__r.CreatedDate >= datFechaInicio)
            if(OC.Activo__r.ExternalServiceID__c!=null && OC.Cuentafacturacion__c!=null && OC.CuentaFacturacion__r.Fin_de_consumo__c!=null 
            && 
            ( leg.Legalizacion__c!=null && leg.Legalizacion__r.Estado__c=='Gestionado' && leg.Legalizacion__r.CreatedDate >= datFechaInicio
             || OC.Caso__c != null
             || (OC.Fidelizacion__c != null && OC.Fidelizacion__r.Fidelizacion__r.Origen_de_la_Retencion__c == 'Proactivo')
            ) // 20/05/2016 - [CG] PM3963 - Se adapta las validaciones para que admita OC sin Legalización pero con Caso 
               // 23/02/2022 - [JG] Se adapta para soportar OC con retenciones proactivas
            )            
            {
                retorno=true;
            }
        }
        else
        {
            if(OC.Activo__r.ExternalServiceID__c!=null && OC.Cuentafacturacion__c!=null && OC.CuentaFacturacion__r.Fin_de_consumo__c!=null)
            {
                retorno=true;
            }
        }
    }
    //para los demas tramites
    else {
        //if(OC.Activo__r.ExternalServiceID__c!=null && OC.Cuentafacturacion__c!=null)
        if(OC.Activo__r.ExternalServiceID__c!=null && OC.Cuentafacturacion__c!=null 
        && 
            ( OC.Legalizacion__r.Contrato__r.PlazoPago__c != null
            || OC.Caso__c != null ) // 20/05/2016 - [CG] PM3963 - Se adapta las validaciones para que admita OC sin Legalización pero con Caso 
        )
        {
            retorno=true;
        }
    }
    System.debug('@@-retorno->'+retorno); 
    return retorno;
}

}