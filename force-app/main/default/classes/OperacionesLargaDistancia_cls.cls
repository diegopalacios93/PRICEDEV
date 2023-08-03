/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  luis Eduardo Mogollon
Proyecto:               Integracion SFDC - RevChain Larga Distancia
Descripci?n:            clase que contiene los metodos para realizar la facturacion 
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0     26-08-2015  Luis E Mogollon (LEM)       Creacion de la clase..
1.1		20-06-2018	Fernando Sarasty (FS)		Se incluyen condicionales en el método "cambiodeplanlinea", para asignar la 
												cuenta de facturación actual a la OC, cuando es retiro de convenio de cupo
*******************************************************************************/

public class OperacionesLargaDistancia_cls {
    
    /**
    *   @Method: creacionCupo
    *   @description: Se encarga de crear el convenio de cupo en RevChain
    **/  
    public string creacioncupo(OperacionComercial__c OC,PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
    {
        //string codigo = GeneracionCorrelationID('VCUP',1);
        //[AG: 2016-06-08 se comenta la linea anterior y se cambia por la siguiente, esto para enviar como correlationId el ID de la OC]
        string codigo = OC.Id;
        //se crea el objeto para la generacion del cupo: 
        ParametrosCanonico params = GenerarParametros('ADD','Modificacion Servicios',plan.Servicio__c,plan.Producto__c,plan.PlanFacturacion__c,codigo,OC.Activo__r.Name,'ADD','','','','','','',false,false,null);
        
        return armarcanonico(OC,cuenta,params,new List<ParametrosCanonico>{params}, 'Modificacion Servicios', strCuentaFacturacion);
    }
    
    

    /**
    *   @Method: cambiodeplanlinea
    *   @description: Se encarga de cambiar de plan cada linea que se quiere asociar al cupo
    **/  
    public string cambiodeplanlinea(OperacionComercial__c OC,PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac) //viaja con la cancelacion del cupo de la cuenta si lo tiene
    {
        //string codigo = GeneracionCorrelationID('CPL',1);
        //[AG: 2016-06-08 se comenta la linea anterior y se cambia por la siguiente, esto para enviar como correlationId el ID de la OC]
        string codigo = OC.Id;
        String TOOP, NombrePlan;
        List<ParametrosCanonico> lstParams = new List<ParametrosCanonico>();
        TOOP = OC.TOPP__r.TipodeOperacionporplan__c;
        NombrePlan = OC.Plan__r.NombredelProducto__r.Name;
         
        map<String, SubPlanFacturacion__c> mapSubPlanesFacturacion = new map<String, SubPlanFacturacion__c>(); 
        String planLineaLD = '';
        String productoLineaLD = '';
        for(SubPlanFacturacion__c subPlan :plan.Sub_Planes_Facturaci_n__r){
            mapSubPlanesFacturacion.put(subPlan.Tipo__c, subPlan);
        }
        
        for(Linea__c linea :OC.Operacion_Comercial_Actual__r){            
            if(!linea.CrearLSP__c){                
                /* BEGIN - Manuel Medina - Validacion para nombre del servicio para Linea 018000 - 05112015 */
                String strServicio = '';
                String strExternal = '';
                String strCtaFacturacion = '';
                Boolean blnCancelarCupo = false;
                
                list<ParametroFacturacion__c> lstParametrosFacturacion = new list<ParametroFacturacion__c>(); 
                if(linea.Name.startsWith('18000')){
                    
                    planLineaLD =  mapSubPlanesFacturacion.containsKey('01800')?mapSubPlanesFacturacion.get('01800').name:'';
                    productoLineaLD = mapSubPlanesFacturacion.containsKey('01800')?mapSubPlanesFacturacion.get('01800').ProductoLD__c:'';
                    String idSubPlanFact = mapSubPlanesFacturacion.containsKey('01800')?String.valueOf(mapSubPlanesFacturacion.get('01800').Id):'';
                    
                    lstParametrosFacturacion = mapSubPlanesfac.containskey(idSubPlanFact)?mapSubPlanesfac.get(idSubPlanFact):null;
                    strServicio = 'Linea 018000';
                    strExternal = linea.ExternalID__c;                    
                    if(TOOP == 'Retiro' && NombrePlan == 'Convenio de cupo') //[FSARASTY, 20/06/2018]: Condicional para asignar la cuenta de facturación actual a la OC, cuando es retiro de convenio de cupo
                        strCtaFacturacion = strCuentaFacturacion;               
                    else
                        strCtaFacturacion = linea.CuentaFacturacionAnterior__c;
                    
                    blnCancelarCupo = false;
                    
                }else{
                    
                    planLineaLD =  mapSubPlanesFacturacion.containsKey('A y A')?mapSubPlanesFacturacion.get('A y A').name:'';
                    productoLineaLD = mapSubPlanesFacturacion.containsKey('A y A')?mapSubPlanesFacturacion.get('A y A').ProductoLD__c:'';
                    String idSubPlanFact = mapSubPlanesFacturacion.containsKey('A y A')?String.valueOf(mapSubPlanesFacturacion.get('A y A').Id):'';
                    
                    lstParametrosFacturacion = mapSubPlanesfac.containskey(idSubPlanFact)?mapSubPlanesfac.get(idSubPlanFact):null;
                    system.debug('\n\n JORGE PARAMETROS '+lstParametrosFacturacion);                    
                    strServicio = plan.Servicio__c;
                    strExternal = linea.ExternalID__c;
                    if(TOOP == 'Retiro' && NombrePlan == 'Convenio de cupo') //[FSARASTY, 20/06/2018]: Condicional para asignar la cuenta de facturación actual a la OC, cuando es retiro de convenio de cupo
                        strCtaFacturacion = strCuentaFacturacion;
                    else
                    	strCtaFacturacion = linea.CuentaFacturacionAnterior__c;
                    
                    blnCancelarCupo = linea.CancelarCupo__c;
                }
            
                //ParametrosCanonico params = GenerarParametros('Update','Modificacion Servicios',plan.Servicio__c,productoLineaLD,planLineaLD,codigo,linea.ExternalID__c,'Update','VoIP Service Class','CLASE DEFAULT RVCHAIN AUTOMATICOS Y ASISTIDOS','',linea.name,linea.CuentaFacturacionAnterior__c,linea.Plan_convenio_anterior__c,linea.CancelarCupo__c,linea.CancelarDescuento__c,lstParametrosFacturacion);
                ParametrosCanonico params = GenerarParametros('Update','Modificacion Servicios',strServicio,productoLineaLD,planLineaLD,codigo,strExternal,'Update','VoIP Service Class','CLASE DEFAULT RVCHAIN AUTOMATICOS Y ASISTIDOS','',linea.name,strCtaFacturacion,linea.Plan_convenio_anterior__c,blnCancelarCupo,linea.CancelarDescuento__c,lstParametrosFacturacion);
                lstParams.add(params);
                
                /* END - Manuel Medina - Validacion para nombre del servicio para Linea 018000 - 05112015 */
                
            }
        }
        
        if(lstParams.Size()>0){
            return armarcanonico(OC,cuenta,lstParams[0],lstParams, 'Modificacion Servicios', strCuentaFacturacion);
        }else{
            return null;
        }
        
    }

    /**
    *   @Method: TransferenciadeServicios
    *   @description: Se encarga de transeferir los servicios al cupo
    **/
    public string TransferenciadeServicios(OperacionComercial__c OC,PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
    {
        
        //Consultar todas las lineas de la OC que esten marcadas para traslado.
        //string codigo = GeneracionCorrelationID('TSER',1);
        //[AG: 2016-06-08 se comenta la linea anterior y se cambia por la siguiente, esto para enviar como correlationId el ID de la OC]
        string codigo = OC.Id;
        
        List<ParametrosCanonico> lstParams = new List<ParametrosCanonico>();
        
        for(Linea__c linea :OC.Operacion_Comercial_Actual__r){
            
            if(!linea.CrearLSP__c && strCuentaFacturacion!=linea.CuentaFacturacionAnterior__c){
                ParametrosCanonico params = GenerarParametros('','Service Transfer',plan.Servicio__c,plan.Producto__c,plan.PlanFacturacion__c,codigo,linea.ExternalID__c,'Update','','','',linea.name,linea.CuentaFacturacionAnterior__c,linea.Plan_convenio_anterior__c,false,false,null);
                lstParams.add(params);
            }
        }
        
        if(lstParams.Size()>0){
            return armarcanonico(OC,cuenta,lstParams[0],lstParams, 'Service Transfer', strCuentaFacturacion);
        }else{
            return null;
        }
        
    }
    
    
    /**
    *   @Method: VentadeServiciosLSP
    *   @description: Se encarga de vender los servicios LSP para las lineas de otros operadores.
    **/
    public string VentadeServiciosLSP(OperacionComercial__c OC,PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)  //viaja con el 
    {  

        //string codigo = GeneracionCorrelationID('VLSP',1);
        //[AG: 2016-06-08 se comenta la linea anterior y se cambia por la siguiente, esto para enviar como correlationId el ID de la OC]
        string codigo = OC.Id;
        
        List<ParametrosCanonico> lstParams = new List<ParametrosCanonico>();
        
        map<String, SubPlanFacturacion__c> mapSubPlanesFacturacion = new map<String, SubPlanFacturacion__c>(); 
        String planLineaLD = '';
        String productoLineaLD = '';
        String Servicio = '';
        for(SubPlanFacturacion__c subPlan :plan.Sub_Planes_Facturaci_n__r){
            mapSubPlanesFacturacion.put(subPlan.Tipo__c, subPlan);
        }
        
        for(Linea__c linea :OC.Operacion_Comercial_Actual__r){
            
            if(linea.CrearLSP__c){
                
                list<ParametroFacturacion__c> lstParametrosFacturacion = new list<ParametroFacturacion__c>(); 
                
                planLineaLD =  mapSubPlanesFacturacion.containsKey('A y A')?mapSubPlanesFacturacion.get('A y A').name:'';
                productoLineaLD = mapSubPlanesFacturacion.containsKey('A y A')?mapSubPlanesFacturacion.get('A y A').ProductoLD__c:'';
                Servicio = 'Linea Telefonica';
                String idSubPlanFact = mapSubPlanesFacturacion.containsKey('A y A')?String.valueOf(mapSubPlanesFacturacion.get('A y A').Id):'';
                
                
                lstParametrosFacturacion = mapSubPlanesfac.containskey(idSubPlanFact)?mapSubPlanesfac.get(idSubPlanFact):null;
                
                /* BEGIN - Manuel Medina - Validacion para enviar el ExternalID cuanto una LSP ya ha sido vendida en RevChain - 03112015 */
                if( String.isNotEmpty( linea.ExternalID__c ) && linea.ExternalID__c.startsWithIgnoreCase( 'ACL' ) ){
                    ParametrosCanonico params = GenerarParametros('Add','Venta Larga Distancia Otro Operador Batch',Servicio,productoLineaLD,planLineaLD,codigo,linea.ExternalID__c,'Add','VoIP Service Class','CLASE DEFAULT RVCHAIN AUTOMATICOS Y ASISTIDOS','',linea.name,linea.CuentaFacturacionAnterior__c,linea.Plan_convenio_anterior__c,false,false,lstParametrosFacturacion);
                    lstParams.add(params);
                    
                }else{
                    ParametrosCanonico params = GenerarParametros('Add','Venta Larga Distancia Otro Operador Batch',Servicio,productoLineaLD,planLineaLD,codigo,linea.CorrelationId__c,'Add','VoIP Service Class','CLASE DEFAULT RVCHAIN AUTOMATICOS Y ASISTIDOS','',linea.name,linea.CuentaFacturacionAnterior__c,linea.Plan_convenio_anterior__c,false,false,lstParametrosFacturacion);
                    lstParams.add(params);
                }
                /* END - Manuel Medina - Validacion para enviar el ExternalID cuanto una LSP ya ha sido vendida en RevChain - 03112015 */
            }
                
        }
        if(lstParams.Size()>0){
            return armarcanonicoLSP(OC,cuenta,lstParams[0],lstParams, 'Venta Larga Distancia Otro Operador Batch', strCuentaFacturacion);
        }else{
            return null;
        }
        
    }


    /**
    *   @Method: VentadeServiciosLSPVoz
    *   @description: Se encarga de vender los servicios LSP para las lineas de otros operadores.
    **/
    public List<string> VentadeServiciosLSPVoz(OperacionComercial__c OC,PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)  //viaja con el 
    {  

        //string codigo = GeneracionCorrelationID('VLSP',1);
        //[AG: 2016-06-08 se comenta la linea anterior y se cambia por la siguiente, esto para enviar como correlationId el ID de la OC]
        string codigo = OC.Id;
        
        List<String> lstCanonicosVentaLSPVoz = new List<String>();
        
        List<ParametrosCanonico> lstParams = new List<ParametrosCanonico>();
        
        map<String, SubPlanFacturacion__c> mapSubPlanesFacturacion = new map<String, SubPlanFacturacion__c>(); 
        String planLineaLD = '';
        String productoLineaLD = '';
        String Servicio = '';
        for(SubPlanFacturacion__c subPlan :plan.Sub_Planes_Facturaci_n__r){
            mapSubPlanesFacturacion.put(subPlan.Tipo__c, subPlan);
        }
        
        for(Linea__c linea :OC.Operacion_Comercial_Actual__r){
            
            if(linea.CrearLSP__c){
                
                list<ParametroFacturacion__c> lstParametrosFacturacion = new list<ParametroFacturacion__c>(); 
                
                planLineaLD =  mapSubPlanesFacturacion.containsKey('A y A')?mapSubPlanesFacturacion.get('A y A').name:'';
                productoLineaLD = mapSubPlanesFacturacion.containsKey('A y A')?mapSubPlanesFacturacion.get('A y A').ProductoLD__c:'';
                Servicio = 'Linea Telefonica';
                String idSubPlanFact = mapSubPlanesFacturacion.containsKey('A y A')?String.valueof(mapSubPlanesFacturacion.get('A y A').Id):'';
                
                
                lstParametrosFacturacion = mapSubPlanesfac.containskey(idSubPlanFact)?mapSubPlanesfac.get(idSubPlanFact):null;
                
                /* BEGIN - Manuel Medina - Validacion para enviar el ExternalID cuanto una LSP ya ha sido vendida en RevChain - 03112015 */
                if( String.isNotEmpty( linea.ExternalID__c ) && linea.ExternalID__c.startsWithIgnoreCase( 'ACL' ) ){
                    ParametrosCanonico params = GenerarParametros('Add','Venta Larga Distancia Otro Operador Batch',Servicio,productoLineaLD,planLineaLD,codigo,linea.ExternalID__c,'Add','VoIP Service Class','CLASE DEFAULT RVCHAIN AUTOMATICOS Y ASISTIDOS','',linea.name,linea.CuentaFacturacionAnterior__c,linea.Plan_convenio_anterior__c,false,false,lstParametrosFacturacion);
                    lstParams.add(params);
                    
                }else{
                    ParametrosCanonico params = GenerarParametros('Add','Venta Larga Distancia Otro Operador Batch',Servicio,productoLineaLD,planLineaLD,codigo,linea.CorrelationId__c,'Add','VoIP Service Class','CLASE DEFAULT RVCHAIN AUTOMATICOS Y ASISTIDOS','',linea.name,linea.CuentaFacturacionAnterior__c,linea.Plan_convenio_anterior__c,false,false,lstParametrosFacturacion);
                    lstParams.add(params);
                }
                /* END - Manuel Medina - Validacion para enviar el ExternalID cuanto una LSP ya ha sido vendida en RevChain - 03112015 */
                
                if(String.isBlank(linea.CuentaFacturacionAnterior__c)){
                    lstCanonicosVentaLSPVoz.add(armarcanonicoLSP(OC,cuenta,lstParams[0],lstParams, 'Venta Larga Distancia Otro Operador Batch', strCuentaFacturacion));
                }else{
                    lstCanonicosVentaLSPVoz.add(armarcanonicoLSP(OC,cuenta,lstParams[0],lstParams, 'Venta Larga Distancia Otro Operador Batch', linea.CuentaFacturacionAnterior__c));
                }
                
                lstParams = new List<ParametrosCanonico>();
            }
                
        }
        return lstCanonicosVentaLSPVoz;

        
    }
    
    
    public list<string> cancelarLSP(OperacionComercial__c OC,PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac) //viaja con la cancelacion del cupo de la cuenta si lo tiene
    {
        //string codigo = GeneracionCorrelationID('CLSP',1);
        //[AG: 2016-06-08 se comenta la linea anterior y se cambia por la siguiente, esto para enviar como correlationId el ID de la OC]
        string codigo = OC.Id;
        List<String> lstCanonicosCancelarLSP = new List<String>();
        
        map<String, SubPlanFacturacion__c> mapSubPlanesFacturacion = new map<String, SubPlanFacturacion__c>(); 
        String planLineaLD = '';
        String productoLineaLD = '';
        String Servicio = '';
        for(SubPlanFacturacion__c subPlan :plan.Sub_Planes_Facturaci_n__r){
            mapSubPlanesFacturacion.put(subPlan.Tipo__c, subPlan);
        }
        
        for(Linea__c linea :OC.Operacion_Comercial_Actual__r){
            
            if(linea.CrearLSP__c && linea.CancelarCupo__c){
                
                List<ParametrosCanonico> lstParams = new List<ParametrosCanonico>();
                list<ParametroFacturacion__c> lstParametrosFacturacion = new list<ParametroFacturacion__c>(); 
                
                planLineaLD =  mapSubPlanesFacturacion.containsKey('A y A')?mapSubPlanesFacturacion.get('A y A').name:'';
                productoLineaLD = mapSubPlanesFacturacion.containsKey('A y A')?mapSubPlanesFacturacion.get('A y A').ProductoLD__c:'';
                Servicio = 'Linea Telefonica';
                String idSubPlanFact = mapSubPlanesFacturacion.containsKey('A y A')?String.valueof(mapSubPlanesFacturacion.get('A y A').Id):'';
                
                
                lstParametrosFacturacion = mapSubPlanesfac.containskey(idSubPlanFact)?mapSubPlanesfac.get(idSubPlanFact):null;
                
                /* BEGIN - Manuel Medina - Validacion para generar la cancelacion de lineas en Cambio de Plan o Retiro - 30102015 */
                if( !OC.TOPP__r.TipodeOperacionporPLan__c.equals( 'Cambio de Plan' ) && !OC.TOPP__r.TipodeOperacionporPLan__c.equals( 'Retiro' ) ){
                    ParametrosCanonico params = GenerarParametros('Delete','Modificacion Servicios',Servicio,productoLineaLD,planLineaLD,codigo,linea.ExternalID__c,'Delete','VoIP Service Class','CLASE DEFAULT RVCHAIN AUTOMATICOS Y ASISTIDOS','',linea.name,linea.CuentaFacturacionAnterior__c,linea.Plan_convenio_anterior__c,false,linea.CancelarDescuento__c,lstParametrosFacturacion);
                    lstParams.add(params);
                    
                }else{
                    ParametrosCanonico params = GenerarParametros('Delete','Modificacion Servicios',Servicio,productoLineaLD,planLineaLD,codigo,linea.CorrelationId__c,'Delete','VoIP Service Class','CLASE DEFAULT RVCHAIN AUTOMATICOS Y ASISTIDOS','',linea.name,linea.CuentaFacturacionAnterior__c,linea.Plan_convenio_anterior__c,false,linea.CancelarDescuento__c,lstParametrosFacturacion);
                    lstParams.add(params);
                }
                /* END - Manuel Medina - Validacion para generar la cancelacion de lineas en Cambio de Plan o Retiro - 30102015 */
                
                lstCanonicosCancelarLSP.add(armarcanonico(OC,cuenta,lstParams[0],lstParams, 'Modificacion Servicios', linea.CuentaFacturacionAnterior__c));
            }
                
        }

        return lstCanonicosCancelarLSP;
    }
    
    /**
    *   @Method: cancelarCupo
    *   @description: Se encarga de cancelar el cupo a las lineas que estaban a asociadas a algun cupo y se van a asociar a uno nuevo
    **/  
    public string cancelarCupo(OperacionComercial__c OC,PlanLD__c plan,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
    {
        //string codigo = GeneracionCorrelationID('CCUP',1);
     	//[AG: 2016-06-08 se comenta la linea anterior y se cambia por la siguiente, esto para enviar como correlationId el ID de la OC]
     	string codigo = OC.Id;   
        //ParametrosCanonico params = GenerarParametros('Delete','Modificacion Servicios',plan.Servicio__c,plan.Producto__c,plan.PlanFacturacion__c,codigo,OC.Activo__r.Name,'Delete','','','','','','',false,false,null);
        //[AG: 2016-06-08: se comenta la linea anterior y se reeplaza por la siguiente, para cambiar el campo "OC.Activo__r.Name" por "OC.Activo__r.ExternalServiceID__c"]
        ParametrosCanonico params = GenerarParametros('Delete','Modificacion Servicios',plan.Servicio__c,plan.Producto__c,plan.PlanFacturacion__c,codigo,OC.Activo__r.ExternalServiceID__c,'Delete','','','','','','',false,false,null);
        
        return armarcanonico(OC,cuenta,params,new List<ParametrosCanonico>{params}, 'Modificacion Servicios', strCuentaFacturacion);
        
        

        return null;
    }
    
    
    /**
    *   @Method: cancelarCupoLinea
    *   @description: Se encarga de cancelar el cupo a las lineas que estaban a asociadas a algun cupo y se van a asociar a uno nuevo
    **/  
    public string cambioPlanCupo(OperacionComercial__c OC,PlanLD__c plan,PlanLD__c planAnterior,Account cuenta, String strCuentaFacturacion, map<string,list<ParametroFacturacion__c>> mapSubPlanesfac)
    {
    	//string codigo = GeneracionCorrelationID('CPCUP',1);
    	//[AG: 2016-06-08 se comenta la linea anterior y se cambia por la siguiente, esto para enviar como correlationId el ID de la OC]
        string codigo = OC.Id;
        
        
        /* BEGIN - Manuel Medina - Cambio de las acciones Delete y ADD por Update - 28102015 */
        //ParametrosCanonico paramsCancelar = GenerarParametros('Delete','Modificacion Servicios',planAnterior.Servicio__c,planAnterior.Producto__c,planAnterior.PlanFacturacion__c,codigo,OC.Activo__r.Name,'Delete','','','','','','',false,false,null);
        //ParametrosCanonico paramsCrear = GenerarParametros('ADD','Modificacion Servicios',plan.Servicio__c,plan.Producto__c,plan.PlanFacturacion__c,codigo,OC.Activo__r.Name,'ADD','','','','','','',false,false,null);
        //ParametrosCanonico paramsActualizar = GenerarParametros('Update','Modificacion Servicios',plan.Servicio__c,plan.Producto__c,plan.PlanFacturacion__c,codigo,OC.Activo__r.Name,'Update','','','','','',planAnterior.PlanFacturacion__c,false,false,null);
        //[AG: 2016-06-08: se comenta la linea anterior y se reeplaza por la siguiente, para cambiar el campo "OC.Activo__r.Name" por "OC.Activo__r.ExternalServiceID__c"]        
        ParametrosCanonico paramsActualizar = GenerarParametros('Update','Modificacion Servicios',plan.Servicio__c,plan.Producto__c,plan.PlanFacturacion__c,codigo,OC.Activo__r.ExternalServiceID__c,'Update','','','','','',planAnterior.PlanFacturacion__c,false,false,null);
        
        List<ParametrosCanonico> lstParametrosCanonico = new List<ParametrosCanonico>();
        //lstParametrosCanonico.add(paramsCancelar);
        //lstParametrosCanonico.add(paramsCrear);
        lstParametrosCanonico.add(paramsActualizar);
        /* END - Manuel Medina - Cambio de las acciones Delete y ADD por Update - 28102015 */
        
        return armarcanonico(OC,cuenta,lstParametrosCanonico[0],lstParametrosCanonico, 'Modificacion Servicios', strCuentaFacturacion);
    }

    
    //metodo que genera el codigo correlation ID para que sea asignado a cada mensaja canonico
    public string GeneracionCorrelationID(string Operacion,integer paso)
    {
        Integer numeroRandom = Math.round(Math.random()*1000);
        string retorno = operacion.substring(0,3).toUppercase()+'-'+paso+numeroRandom;
        return retorno;
    }
    
    public ParametrosCanonico GenerarParametros(string ac,string oS,string ser,string pro,string pl,string cod,string ext,string tip,string clas,string clasSupInfo,string con,string num,string cuen, string planAnt, boolean deleteFeature, boolean deleteFeatureDescuento, list<ParametroFacturacion__c> params)
    {
        if(params==null)
        {
            params=new list<ParametroFacturacion__c>();
        }
        
        return new ParametrosCanonico(ac,os,ser,pro,pl,cod,ext,tip,clas,clasSupInfo,con,num,cuen,planAnt,deleteFeature,deleteFeatureDescuento,params);
    }
    
    
    
    

/**Métodos para crear trama canonica de Larga distancia**/

//metodo que arma el mensaje canonico, este mensaje es generico y se usa para los cupos y para los convenios de voz.
public string ArmarCanonico(OperacionComercial__c OC,Account cuenta,ParametrosCanonico param,list<ParametrosCanonico> params, String orderSubType, String strCodCuentaFacturacion)
{
    
    
    string xml='';
    
    //comenzar a armar las etiquetas iniciales
    xml+='';
    xml+='<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns=\"http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0\" xmlns:v1=\"http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0\" xmlns:v11=\"http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0\">';
    xml+='<soapenv:Header/>';
    xml+='<soapenv:Body>';
    xml+='<ns:WSRequestSFRevChain>';
    xml+=' <v1:WSRequestHeader>';
    xml+='<v1:System correlationID=\"'+param.codigo+'\" processingServer="?">?</v1:System>';
    xml+='<v1:Property name="?" value="?">?</v1:Property>';
    xml+='</v1:WSRequestHeader>';
    xml+='<v11:CanonicalMessage>';
    xml+='<v11:OrderFulfilment>';
            //sender
            xml+=RevchainLD_cls.sender();
            //Identification
            xml+=RevchainLD_cls.Identification(param.codigo);
            //SalesOrder
            xml+=RevchainLD_cls.SalesOrder(OC);
            //BusinessReference
            xml+=RevchainLD_cls.BusinessReference(param.codigo);
            //CustomerPartyAcount
            xml+=RevchainLD_cls.CustomerPartyAccount(OC,param.codigo);
            //Custom
            xml+=RevchainLD_cls.CustomLD(orderSubType);
            //SalesOrderLine 1 por cada producto
            xml+=RevchainLD_cls.PartyIdentification(param.codigo);
            //validar que el producto no sea de Solucion TI
            //list<ParametroFacturacion__c> listParametros=new list<ParametroFacturacion__c>();
            //ya que pueden ser varios procesos mas que todo al asignacion de lineas, traslados etc se hace flujo, si es una operacion unica vendra un solo item
            for(ParametrosCanonico para : params)
            {
                        xml+=SalesOrderLine(OC,para.plan,para.producto,Cuenta,para.codigo,para.external,para.tipo,param.clase,param.claseSupplementaryInfo,para.servicio,para.connectiontype,para.numconexion,para.cuentafacant,para.planAnt,para.deleteFeature, para.deleteFeatureDescuento,para.parametros); //lista parametros
            }
                        //saltarse el for ya eligio un plan
                
     xml+='<ProvisioningResponse>Y</ProvisioningResponse>';
     xml+='</v11:OrderFulfilment>';       
     xml+='<v11:BillingProcess>';
     //customer
     xml+=RevchainLD_cls.Customer(OC);
     //customerBill
     xml+=RevchainLD_cls.CustomerBill(OC,param.codigo, strCodCuentaFacturacion);
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



//armado del salesOrderLine para largaDistancia.

public string SalesOrderLine(OperacionComercial__c OC,string plan,string producto,Account Cuenta,string codigo, string external,string tipo, string clase, string claseSupInfo, string servicio,string connectiontype,string numConexion,string cuentaFacAnterior, string planAnt, boolean deleteFeature, boolean deleteFeatureDescuento, list<ParametroFacturacion__c> parametros)
{
    //es un string
    string xml='';
    //colocar dentro de la etiqueta SalesOrdenLine
    xml+=RevchainLD_cls.SalesOrderLineLD(OC,codigo,external,tipo,clase,servicio);
    //hacer un ciclo por cada itemReference : producto
    /* BEGIN - Manuel Medina - Construccion SupplementaryInfo para Delete y Add en operacion de Cambio de Plan para un unico SalesOrderLine - 28102015 */
    if( parametros.isEmpty() && OC.TOPP__r.TipodeOperacionporPLan__c.equals( 'Cambio de Plan' ) ){
        System.debug( '\n\n\n@@--> INSIDE Cambio de Plan Validation' );
        xml+=RevchainLD_cls.SupplementaryInfoLD( OC, 'Valor Unico - Asignacion de Cupo', external, codigo, claseSupInfo, 'Delete' );
        
        for(ParametroFacturacion__c parametro : parametros)
        {
            xml+=parametro(parametro,OC);
        }
        
        xml+=RevchainLD_cls.rateplan(planAnt);
        xml+='</SupplementaryInfo>';
        
        xml+=RevchainLD_cls.SupplementaryInfoLD( OC, 'Valor Unico - Asignacion de Cupo', external, codigo, claseSupInfo, 'Add' );
        
        for(ParametroFacturacion__c parametro : parametros)
        {
            xml+=parametro(parametro,OC);
        }
        
        xml+=RevchainLD_cls.rateplan(plan);
        xml+='</SupplementaryInfo>';
        
    }else{
        //por el plan armar un supplementaryInfo
        xml+=RevchainLD_cls.SupplementaryInfoLD(OC,producto,external,codigo,claseSupInfo,tipo);
        
        //a?adir los parametros validar que debe ser un plan automaticos y asistidos o 1800
        for(ParametroFacturacion__c parametro : parametros)
        {
            xml+=parametro(parametro,OC);
        }
        
        //se debe colocar aca el rateplan
        //string planname=nombreplan(OC,planfac);
        xml+=RevchainLD_cls.rateplan(plan);
        xml+='</SupplementaryInfo>';
    }
    /* END - Manuel Medina - Construccion SupplementaryInfo para Delete y Add en operacion de Cambio de Plan para un unico SalesOrderLine - 28102015 */
    
    //Se agrega supplementaryinfo con información para eliminar linea del cupo anterior, esto solo se ejecuta cuando la linea estaba asociada a un cupo.
    if(deleteFeature){
        xml+=RevchainLD_cls.SupplementaryInfoLD(OC,'Valor Unico - Asignacion de Cupo',external,codigo,'','Delete');
        
        for(ParametroFacturacion__c parametro : parametros)
        {
            xml+=parametro(parametro,OC);
        }
        //se debe colocar aca el rateplan
        //string planname=nombreplan(OC,planfac);
        xml+=RevchainLD_cls.rateplan(plan);
        xml+='</SupplementaryInfo>';
        
    }
    
    //Se agrega supplementaryinfo con información para eliminar linea del cupo anterior, esto solo se ejecuta cuando la linea estaba asociada a un cupo.
    if(deleteFeatureDescuento){
        xml+=RevchainLD_cls.SupplementaryInfoLD(OC,'Descuento Parametro LD',external,codigo,'','Delete');
        
        for(ParametroFacturacion__c parametro : parametros)
        {
            xml+=parametro(parametro,OC);
        }
        //se debe colocar aca el rateplan
        //string planname=nombreplan(OC,planfac);
        xml+=RevchainLD_cls.rateplan(plan);
        xml+='</SupplementaryInfo>';
        
    }
    //validar los subplanes
    
    //a?adir connection
    xml+=RevchainLD_cls.ConnectionLD(OC,connectiontype,numconexion);
    //agregar discounts
    xml+=RevchainLD_cls.Discounts();
    //agregar specificationgroupXA
    xml+=RevchainLD_cls.specificationgroupXA();
    //agregar Altkeys
    xml+=RevchainLD_cls.Custom2(codigo);
    xml+=RevchainLD_cls.Billing();
    //xml+=RevchainLD_cls.AltKey();
    ConstruccionCanonico_cls canco= new ConstruccionCanonico_cls();
    string valorciclo = canco.CalculoCodigoFacturacion(OC,Cuenta);
    xml+=RevchainLD_cls.AltKeyLD(OC.CuentaCliente__r.Segmento__c,OC.CuentaCliente__r.SubSegmento__c,OC,valorciclo,cuentaFacAnterior,codigo);
    xml+='</SalesOrderLine>';
    return xml;
}


//metodo que arma el mensaje canonico, este mensaje es generico y se usa para los cupos y para los convenios de voz.
public string ArmarCanonicoLSP(OperacionComercial__c OC,Account cuenta,ParametrosCanonico param,list<ParametrosCanonico> params, String orderSubType, String strCodCuentaFacturacion)
{
    
    
    string xml='';
    
    //comenzar a armar las etiquetas iniciales
    xml+='';
    xml+='<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns=\"http://www.etb.com.co/LTE/WS/ETB.LTE.WS.SalesForce/WSRequestSalesForceIN/1.0\" xmlns:v1=\"http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0\" xmlns:v11=\"http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0\">';
    xml+='<soapenv:Header/>';
    xml+='<soapenv:Body>';
    xml+='<ns:WSRequestSFRevChain>';
    xml+=' <v1:WSRequestHeader>';
    xml+='<v1:System correlationID=\"'+param.codigo+'\" processingServer="?">?</v1:System>';
    xml+='<v1:Property name="?" value="?">?</v1:Property>';
    xml+='</v1:WSRequestHeader>';
    xml+='<v11:CanonicalMessage>';
    xml+='<v11:OrderFulfilment>';
            //sender
            xml+=RevchainLD_cls.sender();
            //Identification
            xml+=RevchainLD_cls.Identification(param.codigo);
            //SalesOrder
            xml+=RevchainLD_cls.SalesOrderLSP(OC);
            //BusinessReference
            xml+=RevchainLD_cls.BusinessReference(param.codigo);
            //CustomerPartyAcount
            xml+=RevchainLD_cls.CustomerPartyAccount(OC,param.codigo);
            //Custom
            xml+=RevchainLD_cls.CustomLD(orderSubType);
            //SalesOrderLine 1 por cada producto
            xml+=RevchainLD_cls.PartyIdentification(param.codigo);
            //validar que el producto no sea de Solucion TI
            //list<ParametroFacturacion__c> listParametros=new list<ParametroFacturacion__c>();
            //ya que pueden ser varios procesos mas que todo al asignacion de lineas, traslados etc se hace flujo, si es una operacion unica vendra un solo item
            for(ParametrosCanonico para : params)
            {
                        xml+=SalesOrderLineLSP(OC,para.plan,para.producto,Cuenta,para.codigo,para.external,para.tipo,param.clase,param.claseSupplementaryInfo,para.servicio,para.connectiontype,para.numconexion,para.cuentafacant,para.parametros); //lista parametros
            }
                        //saltarse el for ya eligio un plan
                
     xml+='<ProvisioningResponse>Y</ProvisioningResponse>';
     xml+='</v11:OrderFulfilment>';       
     xml+='<v11:BillingProcess>';
     //customer
     xml+=RevchainLD_cls.Customer(OC);
     //customerBill
     xml+=RevchainLD_cls.CustomerBill(OC,param.codigo, strCodCuentaFacturacion);
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


public string SalesOrderLineLSP(OperacionComercial__c OC,string plan,string producto,Account Cuenta,string codigo, string external,string tipo, string clase, string claseSupInfo, string servicio,string connectiontype,string numConexion,string cuentaFacAnterior, list<ParametroFacturacion__c> parametros)
{
    //es un string
    string xml='';
    //colocar dentro de la etiqueta SalesOrdenLine
    xml+=RevchainLD_cls.SalesOrderLineLD(OC,codigo,external,tipo,clase,servicio);
    //hacer un ciclo por cada itemReference : producto
    //por el plan armar un supplementaryInfo
    xml+=RevchainLD_cls.SupplementaryInfoLD(OC,'Otros',external,codigo,claseSupInfo,tipo);

    //Para el feature de otros no se envia parametros
    //string planname=nombreplan(OC,planfac);
    xml+=RevchainLD_cls.rateplan('Otros- Chain');
    xml+='</SupplementaryInfo>';

    xml+=RevchainLD_cls.SupplementaryInfoLD(OC,producto,external,codigo,claseSupInfo,tipo);
    
    
    //a?adir los parametros validar que debe ser un plan automaticos y asistidos o 1800
    for(ParametroFacturacion__c parametro : parametros)
    {
        xml+=parametro(parametro,OC);
    }
    //se debe colocar aca el rateplan
    //string planname=nombreplan(OC,planfac);
    xml+=RevchainLD_cls.rateplan(plan);
    xml+='</SupplementaryInfo>';
    
    //a?adir connection
    xml+=RevchainLD_cls.ConnectionLD(OC,connectiontype,numconexion);
    //agregar discounts
    xml+=RevchainLD_cls.Discounts();
    //agregar specificationgroupXA
    xml+=RevchainLD_cls.specificationgroupXA();
    //agregar Altkeys
    xml+=RevchainLD_cls.Custom2(codigo);
    xml+=RevchainLD_cls.Billing();
    //xml+=RevchainLD_cls.AltKey();
    ConstruccionCanonico_cls canco= new ConstruccionCanonico_cls();
    string valorciclo = canco.CalculoCodigoFacturacion(OC,Cuenta);
    xml+=RevchainLD_cls.AltKeyLD(OC.CuentaCliente__r.Segmento__c,OC.CuentaCliente__r.SubSegmento__c,OC,valorciclo,cuentaFacAnterior,codigo);
    xml+='</SalesOrderLine>';
    return xml;
}



public String parametro(ParametroFacturacion__c param,OperacionComercial__c OC)
{
    //valida el nombre del campo y lo obtiene y llena el valor para el parametro, en el objeto se debe configurar el campo partiendo desde la operacion comercial
    string parametro = '';
    
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
        parametro= RevchainLD_cls.Parameter(param.Name,valor);
    }
     else
     {
        parametro= RevchainLD_cls.Parameter(param.Name,'');
     }
    }
    else
    {
        parametro= RevchainLD_cls.Parameter(param.Name,'');
    }
    return parametro;
}


// esta clase sirve para agrupar los valores y no enviar muchos objeto sino uno solo consolidando todo como uno y elaborarlo desde la reunion de objetos antes de pasar al canonico.
public class ParametrosCanonico{
    
    public string actioncode;
    public string orderSubtype;
    public string servicio;
    public string producto;
    public string plan;
    public string codigo;
    public string external;
    public string tipo;
    public string clase;
    public string claseSupplementaryInfo;
    public string numconexion;
    public string connectiontype;
    public string cuentafacant;
    public string planAnt;
    public boolean deleteFeature;
    public boolean deleteFeatureDescuento;
    public list<ParametroFacturacion__c> parametros;
    
    
    public ParametrosCanonico(string ac,string oS,string ser,string pro,string pl,string cod,string ext,string tip,string clas,string clasSupInfo,string con,string num,string cuen, string planAnterior, boolean deleteFeat, boolean deleteFeatDesc,list<ParametroFacturacion__c> params)
    {
        actioncode=ac;
        orderSubtype=os;
        servicio=ser;
        producto=pro;
        plan=pl;
        codigo=cod;
        external=ext;
        parametros=params;
        tipo=tip;
        clase=clas;
        claseSupplementaryInfo = clasSupInfo;
        numconexion=num;
        connectiontype=con;
        cuentafacant=cuen;
        deleteFeature=deleteFeat;
        deleteFeatureDescuento=deleteFeatDesc;
        planAnt=planAnterior;
    }

}
    

}