public class AsignacionLinea_ctr {
    
    public id idCuenta;
    public id topp;
    public id oc;
    public string lineas{get;set;}
    public boolean errorApex{get;set;}
    private map<string,Id> conf=new map<string,Id>();
    public Topp__c tipoOperacion{get;set;}
    public OperacionComercial__c operacionC{get;set;}   

    public AsignacionLinea_ctr(){

        errorApex=true;
        
        idCuenta=ApexPages.currentPage().getParameters().get('id');
        topp=ApexPages.currentPage().getParameters().get('topp');
        oc=ApexPages.currentPage().getParameters().get('newid');
        
        tipoOperacion=planToop(topp);
        Account cliente =cliente(idCuenta);
        operacionC=operacionComercial(oc);

        if(tipoOperacion.id==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El Tipo Operación por Plan No es Valido'));
            errorApex=false;
        }

        if(cliente.EstadoRestriccionVenta__c==true || cliente.id==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'El Cliente No es valido'));
            errorApex=false;
        }

        if(operacionC.id==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No existe Operacion Comercial'));
            errorApex=false;
        }
    }

    public String getConf(){

        Map<String,String> conf=new Map<String,String>();
        conf.put('cuenta',idCuenta);
        conf.put('topp',topp);
        conf.put('oc',oc);

        //Para venta cuenta facturacion OC para adicion del activo
        String factura=(tipoOperacion.TipodeOperacionporplan__c=='Venta'?operacionC.CuentaFacturacion__r.Name:operacionC.Activo__r.CuentaFacturacion__r.Name);

        conf.put('CuentaFacturacion',factura);



        return JSON.serialize(conf);


    }
    
    @RemoteAction
    public static string buscarLineas(string lineasBusqueda,string conf){
        //List<String>datosCT=LibreriaUtilitaria_cls.getListStringFromJson(clienteTopp);
        String lineasBusquedaSinDuplicados;
        System.debug('@@-conf->'+conf);             
        Map<string,string> configuracion =(Map<string,string>)JSON.deserialize(conf, Map<string,string>.class);
        System.debug('@@-Map configuracion->'+configuracion);
        OperacionComercial__c opc=operacionComercial((id)configuracion.get('oc'));

        String factura=(opc.topp__r.TipodeOperacionporplan__c=='Venta'?opc.CuentaFacturacion__r.Name:opc.Activo__r.CuentaFacturacion__r.Name);
        

        map<String,Linea__c> lasLineas=new map<String,Linea__c>();
        lineasBusqueda=lineasBusqueda.deleteWhitespace();
        System.debug('@@-lineasBusqueda->'+lineasBusqueda);
        
        //[FSARASTY, 18052018], se consulta método para excluir las líneas duplicadas en la consulta.
        lineasBusquedaSinDuplicados = excluirLineasDuplicadas(lineasBusqueda, configuracion.get('oc'));
        System.debug('@@-lineasBusquedaSinDuplicados->'+lineasBusquedaSinDuplicados);
        String respuesta = AsignacionLinea_ctr.obtenerLineasWS(lineasBusquedaSinDuplicados);
        System.debug('@@-respuesta->'+respuesta); 
        
        //- SAO - usar la respuesta del WS response (resultado) para mostrar los datos de respuesta en la tabla
        ObjLinea_cls lineaJsonWS = new ObjLinea_cls();
        //eliminar comillas (") que se entregaron de mas en el Json del WS y generaban problemas y deserializar el Json
        if(respuesta!=null)
        {
            respuesta=respuesta.replace('"[', '[');
            respuesta=respuesta.replace(']"', ']');
            respuesta=respuesta.replace('\'', '"');
            system.debug(respuesta);
            lineaJsonWS = ObjLinea_cls.parse(respuesta);
            
            System.debug('@@-lineaJsonWS ->'+lineaJsonWS);
            System.debug('@@-lineaJsonWS.get(numero_tramite)->'+lineaJsonWS.numero_tramite);
            System.debug('@@-lineaJsonWS.get(service_particulars)->'+lineaJsonWS.service_particulars);
        }

        //Mapa cuya llave es le numero de conexion y el valor el objLinea con los valores entregados por el WS
        Map<String, ObjLinea_cls.cls_service_particulars> mapServiceParticular = new Map<String, ObjLinea_cls.cls_service_particulars>();   
        Map<String, List<ObjLinea_cls.cls_service_particulars>> mapListaSP = new Map<String, List<ObjLinea_cls.cls_service_particulars>>();
        List<ObjLinea_cls.cls_service_particulars> lstServiceParticular    = new List<ObjLinea_cls.cls_service_particulars>();
        for(ObjLinea_cls.cls_service_particulars  itemServiceParticular : lineaJsonWS.service_particulars) {
            System.debug('@@-itemServiceParticular-connection_number'+itemServiceParticular.connection_number);
            mapServiceParticular.put(itemServiceParticular.connection_number, itemServiceParticular);
            lstServiceParticular.add(itemServiceParticular);            
        }    
        if(lineasBusquedaSinDuplicados != '')
        	mapListaSP.put('correcto', lstServiceParticular);
        else
            mapListaSP.put('LineasYaExisten', lstServiceParticular);
        
        System.debug('@@-mapServiceParticular ->'+mapServiceParticular);
        System.debug('@@-mapListaSP ->'+mapListaSP);

        //Recorrer el mapa para obtener los valores de los item deseados    
        /*                      
        for(String strConnectionNumber: mapServiceParticular.keyset()){
            System.debug('@@-strConnectionNumber ->'+strConnectionNumber);
            System.debug('@@-mapServiceParticular.get(strConnectionNumber).subscriber_id ->'+mapServiceParticular.get(strConnectionNumber).subscriber_id);                             
        }
        */      


        //consulta anterior con la crea una lista de lineas con base a al informacion que existe en SF
        List<string> lineasABuscar=new List<String>(new set<String>(lineasBusquedaSinDuplicados.split(',')));
        System.debug('@@-lineasABuscar->'+lineasABuscar);

        List<Linea__c> Lineas=obtenerLineas(lineasABuscar);
        System.debug('@@-Lineas->'+Lineas);

    /*
        for(Linea__c l:Lineas){
            lasLineas.put(l.Codigo_de_linea__c,l);
        }

        List<lineaJson> conErroresLineasJson=new List<lineaJson>();

        List<lineaJson> lineasJson=new List<lineaJson>();

        integer i=0;
        for(string s:lineasABuscar){
            if(lasLineas.containsKey(s)){
                
                system.debug('aqui'+(lasLineas.get(s).Activo__r.CuentaFacturacion__r.Name !=factura)+'\n'+(lasLineas.get(s).Activo__c!=null)+'\n'+(opc.TOPP__r.TipodeOperacionporplan__c =='Convenio de cupo')+opc.TOPP__r.Plan__r.NombredelProducto__r.Name); 

                //Cupo
                if(opc.TOPP__r.Plan__r.NombredelProducto__r.Name =='Convenio de cupo' && lasLineas.get(s).Activo__r.CuentaFacturacion__r.Name !=factura && lasLineas.get(s).Activo__c!=null){
                    
                    conErroresLineasJson.add(new lineaJson(lasLineas.get(s),true,'form'+i,'Para un Convenio de cupo el servicio relacionado debe pertenecer a la misma cuenta de facturacion del cupo'));
                }
                else if(lasLineas.get(s).ActivoLargaDistancia__c==null){
                    lineasJson.add(new lineaJson(lasLineas.get(s),true,'form'+i,''));
                    system.debug(lasLineas.get(s).Cuenta_suscriptora__c);
                }
                else{
                    conErroresLineasJson.add(new lineaJson(lasLineas.get(s),true,'form'+i,'La linea contiene un plan asignado o en curso'));
                }

            
            }else{
                //solo se crea si es Numerico y tiene mas de 8 numeros y menos de 10
                if(s.isNumeric() && s.length()>7 && s.length()<11 ){
                    lineasJson.add(new lineaJson(new Linea__c(Codigo_de_linea__c=s,Name=s),false,'form'+i,''));
                }else{
                    conErroresLineasJson.add(new lineaJson(new Linea__c(Codigo_de_linea__c=s,Name=s),false,'form'+i,'El valor debe ser numerico con minimo 8 y maximo 10 numeros'));
                }
            }
        }

        Map<string,List<lineaJson>> validos=New Map<string,List<lineaJson>>();
        validos.put('correcto',lineasJson);
        validos.put('conErrores',conErroresLineasJson);

        return JSON.serialize(validos);
    */
    return JSON.serialize(mapListaSP);
    }

    public static List<Linea__c> obtenerLineas(List<String>lineasABuscar){

        return new List<Linea__c>([select Activo__r.Name,id,Linea_ETB__c,Name,Cuenta_suscriptora__r.name,Cuenta_suscriptora__c,Tipo__c,Activo__c,Activo__r.CuentaFacturacion__r.Name,Activo__r.NombredelaCuenta__c,ActivoLargaDistancia__r.Name,ActivoLargaDistancia__r.Estado__c from Linea__c where Codigo_de_linea__c IN :lineasABuscar]);

    }

    //-SAO- consulta a las lineas por medio del web service con RevChain        
    public static String obtenerLineasWS(String lineasABuscar) {
        String response='';
        String strCadena='';        
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('LDConsultaConexionNumber');     
        Map<string,string> mapResponse=new Map<string,string>();
        String CorrelationId =  GeneracionCorrelationID('CNX',1);
        
        mapResponse.put('correlationID',CorrelationId);
        mapResponse.put('NumerosConsulta',lineasABuscar);    
        
        
        system.debug('\n\n REQUEST  --- '+LargaDistanciaXML_cls.ConexionNumber(mapResponse));
        system.debug('\n\n ENDPOINT --- '+sw.EndPoint__c);
        system.debug('\n\n ACTION   --- '+sw.Action__c);   
        try{            
            //consumo del WS expuesto por RevChain para la consulta de Lineas
            String request=LargaDistanciaXML_cls.ConexionNumber(mapResponse);
             if(!Test.isRunningTest()){
                 response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
             }else{
                response='<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:WSConexionNumbereResponse xmlns:ns0="http://www.etb.com.co/LTE/WS/SisExt/ConnectionNumber/OUT/1.0"><ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0"><ns1:System>TIBCO</ns1:System><ns1:Service><ns1:status>PASS</ns1:status></ns1:Service></ns1:WSResponseHeader><ns2:ConexionNumberResponse xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns2="http://WSSalesForceLD.etb.com/LD" xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><return xmlns="">{"service_particulars":[{"connection_number":"12609876","service_id":"6409537","feat_nm_ld":"","external_service_id":"14143040","error_code":"E0006","subscriber_id":"2419002","bill_run_State":"I","rate_plan_name":"","fd":"","lsp_name":"E.T.B.","billing_entity_id":"33","rate_plan_name_cupo":"","billable_parent_id":"2419002","error_description":"La cuenta validada, no tiene asociados los productos esperados","parent_id":""},{"connection_number":"12456754","service_id":"14700118","feat_nm_ld":"","external_service_id":"50443536","error_code":"E0006","subscriber_id":"9044641","bill_run_State":"I","rate_plan_name":"","fd":"","lsp_name":"E.T.B.","billing_entity_id":"35","rate_plan_name_cupo":"","billable_parent_id":"9044641","error_description":"La cuenta validada, no tiene asociados los productos esperados","parent_id":""}],"numero_tramite":24}</return></ns2:ConexionNumberResponse></ns0:WSConexionNumbereResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>';
             }
            
            System.debug('@@-response->'+response);
            tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
            mapResponse.putAll(proReq.getMap(response));    
            String respuesta = mapResponse.get('return');
            //retorna la repuesta del WS (return)
            return respuesta;

        }catch(Exception e){            
            return e.getMessage();
        }

    }

    public static TOPP__c planToop(id t){

        Set<string>planes=new Set<string>{'Convenio de voz','Convenio de cupo'};
        Set<string>operaciones=new Set<string>{'Venta','Adición Lineas de LD'};


        List<TOPP__c> tipoDeOperacion = new List<TOPP__c>([Select id,name,TipodeOperacionporplan__c ,Plan__c from TOPP__c 
            where Plan__r.NombredelProducto__r.Name IN :planes and TipodeOperacionporplan__c IN :operaciones and Id=:t]);

        return (tipoDeOperacion.isEmpty()? new TOPP__c():tipoDeOperacion[0]);

    }

    public static OperacionComercial__c operacionComercial(id t){
        
        /* BEGIN - Manuel Medina - Se incluye el campo Activo__c para obtener el servicio asociado a la operacion comercial - 26102015 */
        List<OperacionComercial__c> oc = new List<OperacionComercial__c>([Select TOPP__r.Plan__r.NombredelProducto__r.Name,id,name,Topp__c,Topp__r.TipodeOperacionporplan__c,CuentaCliente__c,CuentaFacturacion__r.Name,Activo__c,Activo__r.CuentaFacturacion__r.Name from OperacionComercial__c 
            where Id=:t]);
        /* END - Manuel Medina - Se incluye el campo Activo__c para obtener el servicio asociado a la operacion comercial - 26102015 */

        return (oc.isEmpty()? new OperacionComercial__c():oc[0]);

    }


    public static Account cliente(id c){

        List<Account> clientes = new List<Account>([Select id,name,EstadoRestriccionVenta__c from Account 
            where Id=:c]);

        return (clientes.isEmpty()? new Account():clientes[0]);

    }

    public string getComponentes(){

        Map<string,list<string>>comp=new Map<string,list<string>>();
        
        comp.put('Tipo__c',LibreriaUtilitaria_cls.getPicklistValues(new Linea__c(),'Tipo__c'));
        comp.put('Linea_ETB__c',LibreriaUtilitaria_cls.getPicklistValues(new Linea__c(),'Linea_ETB__c'));


        comp.put('clienteTopp',new list<string>{idCuenta,topp});



        return JSON.serialize(comp);
    }

    @RemoteAction
    public static string guardarLineas(string lineasParaGuardar,string conf){

        System.debug('@@-lineasParaGuardar->'+lineasParaGuardar);
        System.debug('@@-conf->'+conf);
        List<lineaJson> data =(List<lineaJson>)JSON.deserialize(lineasParaGuardar, List<lineaJson>.class);
        System.debug('@@-data->'+data);
        //conf=conf.Replace('{','{"').Replace('}','"}').replaceAll(', ','","').replaceAll('=','":"');
        //system.debug(conf);
        Map<string,string> configuracion =(Map<string,string>)JSON.deserialize(conf, Map<string,string>.class);
        //.Replace('{','"').Replace('{','"').replaceAll(', ','","').replaceAll('=','","'));                     
    
        //Convierto el string json a list<string>;
        //List<String>datosCT=LibreriaUtilitaria_cls.getListStringFromJson(clienteTopp);
        System.debug('@@-configuracion->'+configuracion);
        System.debug('@@-configuracion.get(cuenta)->'+configuracion.get('cuenta'));
        System.debug('@@-planToop((Id)configuracion.get(topp))->'+planToop((Id)configuracion.get('topp')));
        System.debug('@@-operacionComercial((Id)configuracion.get(oc))->'+operacionComercial((Id)configuracion.get('oc')));
        
        Account clienteR =cliente((Id)configuracion.get('cuenta'));
        Topp__c tipoOperacionR=planToop((Id)configuracion.get('topp'));
        OperacionComercial__c operacionR=operacionComercial((Id)configuracion.get('oc'));
        

        list<Linea__c>paraActualizar=new list<Linea__c>();

        boolean hayError=(clienteR.id==null || tipoOperacionR.id==null)?true:false;
        System.debug('@@-hayError->'+hayError);
        list<string> creados=new list<string>();
        
        /* BEGIN - Manuel Medina - Control para enlaces de voz - 21102015 */
        Map<String, Linea__c> mapEnlacesExistenteXSubscriberIdExternalServiceId = new Map<String, Linea__c>();  
        /* END - Manuel Medina - Control para enlaces de voz - 21102015 */

        /* BEGIN - Manuel Medina - Validacion para determinar si el TOPP es diferente de vacio o nulo - 19112015 */
        Boolean blnTOPPIsBlank      = String.isNotBlank( planToop( (Id) configuracion.get('topp') ).TipodeOperacionporplan__c );
        /* END - Manuel Medina - Validacion para determinar si el TOPP es diferente de vacio o nulo - 19112015 */

        for(lineaJson j:data){
            if(hayError){
                j.status='El cliente o el tipo de operacion por plan no son validos';
            }

            
            Linea__c objLineaJson = new Linea__c();
            objLineaJson.Name = j.connection_number;
            objLineaJson.Cuenta_suscriptora__c = configuracion.get('cuenta');
            objLineaJson.CuentaFacturacionAnterior__c = j.subscriber_id;
            objLineaJson.Operacion_Comercial_Actual__c = configuracion.get('oc');
            objLineaJson.ExternalID__c = j.external_service_id;
            
            /* BEGIN - Manuel Medina - Se relaciona el servicio al a linea y se valida si la linea quedara activa en el servicio LD - 26102015 */
            if( !operacionR.Topp__r.TipodeOperacionporplan__c.equals( 'Exclusión Lineas de LD' ) ){
                objLineaJson.Activo__c = operacionR.Activo__c;
                //objLineaJson.ActivaServicioLD__c = true;
            }
            /* END - Manuel Medina - Se relaciona el servicio al a linea y se valida si la linea quedara activa en el servicio LD - 26102015 */
            
            if(String.isNotBlank(j.lsp_name) && j.lsp_name.contains('E.T.B')){
                objLineaJson.Linea_ETB__c = 'Si';
            }
            else{ 
                objLineaJson.Linea_ETB__c = 'No';
            }
            
            /* BEGIN - Manuel Medina - Activar CancelarCupo__c en lineas LSP para la TOPP igual a Retiro de Lineas de LD - 09112015 */
            if( operacionR.Topp__r.TipodeOperacionporplan__c.equals( 'Exclusión Lineas de LD' ) && objLineaJson.Linea_ETB__c.equals( 'No' ) ){
                objLineaJson.CancelarCupo__c = true;
            }
            /* END - Manuel Medina - Activar CancelarCupo__c en lineas LSP para la TOPP igual a Retiro de Lineas de LD - 09112015 */
            
            
            objLineaJson.Plan_convenio_anterior__c = j.rate_plan_name;
            
            //j.Linea.Operacion_Comercial_Actual__c=operacionR.Id;
            //j.Linea.Plan__c=tipoOperacionR.Plan__c;
            //creados.add(j.Linea.Name);
            
            
            //Validaciones para los diferentes operaciones de Larga Distancia.
            
            /* BEGIN - Manuel Medina - Se remueve el llamado del metodo planToop() para evitar SOQL-LimitException debido a que siempre se consulta el mismo Id del TOPP - 19112015 */
            //if(planToop((Id)configuracion.get('topp')).TipodeOperacionporplan__c !=''){
            if( blnTOPPIsBlank ){
                
                if(String.isNotBlank(j.lsp_name) && !j.lsp_name.contains('E.T.B')){
                    objLineaJson.CrearLSP__c = true;
                }
                
                if(String.isNotBlank(j.rate_plan_name_cupo)){
                    objLineaJson.CancelarCupo__c = true;
                }
                if(String.isNotBlank(j.feat_nm_ld)){
                    objLineaJson.CancelarDescuento__c = true;
                }
            }
            /* END - Manuel Medina - Se remueve el llamado del metodo planToop() para evitar SOQL-LimitException debido a que siempre se consulta el mismo Id del TOPP - 19112015 */

            /* BEGIN - Manuel Medina - Control para enlaces de voz - 21102015 */
            if( objLineaJson.Linea_ETB__c.equals( 'Si' ) && !mapEnlacesExistenteXSubscriberIdExternalServiceId.containsKey( objLineaJson.CuentaFacturacionAnterior__c + objLineaJson.ExternalID__c ) ){
                paraActualizar.add(objLineaJson);
                mapEnlacesExistenteXSubscriberIdExternalServiceId.put( objLineaJson.CuentaFacturacionAnterior__c + objLineaJson.ExternalID__c, objLineaJson );
                
            }else if( objLineaJson.Linea_ETB__c.equals( 'No' ) ){
                paraActualizar.add(objLineaJson);
            }
            /* END - Manuel Medina - Control para enlaces de voz - 21102015 */
        }

        Database.SaveResult[] results = Database.insert(paraActualizar,false);

        respuestalineaJson rj=new respuestalineaJson();

        integer it=0;
        boolean hasError=false;



      for (Database.SaveResult r : results) {
         if (r.isSuccess()) {
            if(rj.lineas.get('correcto')==null){
                rj.lineas.put('correcto',new List<lineaJson>());
            }
            rj.lineas.get('correcto').add(new lineaJson(paraActualizar[it],true,'form'+it,'correcto'));

            //System.debug('\nUpsert succeeded.');
            //System.debug((r.isCreated() ? 'Insert' : 'Update')
            //      + ' was performed.');
            //System.debug('Account ID: ' + r.getId());
         } else {
            hasError=true;
            if(rj.lineas.get('conErrores')==null){
                rj.lineas.put('conErrores',new List<lineaJson>());
            }
            rj.lineas.get('conErrores').add(new lineaJson(paraActualizar[it],true,'form'+it,r.getErrors()[0].getMessage()));
            System.debug('The Upsert failed because: conErrores'
                  + r.getErrors()[0].getMessage());
         }
         it++;
      }

        rj.datos.put('hasError','False');
        rj.datos.put('Redirect',configuracion.get('oc'));

        if(hasError){
            rj.datos.put('hasError','True');
        }

        system.debug('\n'+JSON.serialize(rj)+'\n'+JSON.serialize(rj).unescapeJava()+'\n'+JSON.serialize(rj).unescapeEcmaScript());


//RestContext.response.addHeader('Content-Type', 'application/json');
        return JSON.serialize(rj);
    }

    /*
    public static Map<String,Linea__c> lineasExistentes(list<string> l){

        Map<String,Linea__c> existe=new Map<String,Linea__c>();
        
        for(Linea__c linea:obtenerLineas(l)){
            existe.put(linea.name,linea);
        }

        return existe;

    }*/

    /*
    public static list<lineaJson> validacion(List<lineaJson> recibidos,Map<String,Linea__c> existentes,Account clientev,Topp__c toppv){




        return recibidos;
    }
    */


    //metodo que genera el codigo correlation ID para que sea asignado a cada mensaja canonico
    public static string GeneracionCorrelationID(string Operacion,integer paso)
    {
        Integer numeroRandom = Math.round(Math.random()*1000);
        string retorno = operacion.substring(0,3).toUppercase()+'-'+paso+numeroRandom;
        return retorno;
    }
    
    public class respuestalineaJson{
        public Map<string,List<lineaJson>> lineas=New Map<string,List<lineaJson>>();
        public Map<string,string> datos=New Map<string,string>();
    }

    
    public class lineaJson{
        public Linea__c Linea;
        public boolean existe;
        public String nameF;
        public boolean error;
        public String status;
        public String lsp='';
        public String tipo='';

        public String connection_number;    
        public String subscriber_id;    
        public String billing_entity_id;
        public String parent_id;    
        public String billable_parent_id;
        public String bill_run_State;   
        public String lsp_name; 
        public String service_id;   
        public String external_service_id;
        public String rate_plan_name;
        public String rate_plan_name_cupo;
        public String error_code;
        public String error_description;
        public String fd;
        public String feat_nm_ld;
        
        public lineaJson(Linea__c Linea,Boolean existe,String nameF,String status){
            this.Linea=Linea;
            this.existe=existe;
            this.nameF=nameF;
            this.status=status;
            this.error=false;
        }
    }
    
    //-SAO Metodo para generar el log del consumo del WS
    static void generarLog(id idCuenta,string request,string response, string estado, string nombre){  
        System.debug('@@-idCuenta->'+idCuenta);      
        LogTransacciones__c log = new LogTransacciones__c(Account__c=idCuenta,Informacion_Enviada__c=request,Informacion_Recibida__c=response,Estado__c=estado,Name=nombre);        
        insert log;    
    }
    
    private static String excluirLineasDuplicadas(String lineas, String IdOc){
        List<String> lstLineasBusqueda;
        Set<String> myset = new Set<String>();
        List<String> result = new List<String>();
        List<String> listLineasProcesadas = new List<String>();
        List<Linea__c> LineasExistentes = new List<Linea__c>();
        string lineasAconsultar = '';
        Integer aux = 0;
        Boolean existRecord = false;
        // Excluir valores repetidos, ingresados por el usuario
        LineasExistentes = [select Name from Linea__c where Operacion_Comercial_Actual__c =:IdOc];
        lstLineasBusqueda = lineas.split(',');
        myset.addAll(lstLineasBusqueda);
        result.addAll(myset);
        
        // Excluir lineas que ya se encuentren relacionadas a la OC
        while (aux < result.size()){            
            existRecord = false;
            for(Linea__c auxLinea: LineasExistentes){
                if(result.get(aux) == String.valueOf(auxLinea.Name))
                    existRecord = true;                   
            }                
            if(!existRecord)
                listLineasProcesadas.add(result.get(aux));
            
            aux++;
        }        
        if(listLineasProcesadas.size()>0)
        	lineasAconsultar = string.join(listLineasProcesadas,',');            
        
        System.debug('@@-lineasAconsultar-> '+lineasAconsultar);        
        return lineasAconsultar;
    }
}