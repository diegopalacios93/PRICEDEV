/**
* Avanxo Colombia
* @author 			Guido Vargas href=<gvargas@avanxo.com>
* Project:			ETB
* Description:		Realiza un batch del objeto CuentaFacturacion__c.
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		2016-08-22		Guido Vargas (GV)		Definicion inicial de la clase.
*************************************************************************************************************/
global class BatchDireccionesCuentasFacturacion_bch implements Database.Batchable<SObject>,Database.AllowsCallouts{
    
    global Database.Querylocator start(Database.Batchablecontext bc) {
        String query = 'SELECT Id, DirCorresp__c, AVX_EstadoDireccion__c FROM CuentaFacturacion__c WHERE AVX_EstadoDireccion__c = \'Pendiente\' LIMIT 10';
        System.debug('\n\n-=#=-\n' + 'query' + ': ' + query + '\n-=#=-\n');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<CuentaFacturacion__c> scope) {
        list<ConsultarBatch> c          = new list<ConsultarBatch>();
        ServiciosWeb__c sw              = ServiciosWeb__c.getValues('NormalizacionDireccion');
        list<LogTransacciones__c> lLog  = new list<LogTransacciones__c>();
        
        for(CuentaFacturacion__c a : scope) {
            c.add(new ConsultarBatch(a, sw));
        }
        
        for(ConsultarBatch l : c) {
            lLog.add(l.lt);
        }
        
        insert lLog;
        update scope;
    }

    global void finish(Database.BatchableContext bc) {
        BatchDireccionesCuentasFacturacion_sch.scheduleJobExecution();
        System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'BatchDireccionesSucursales_bch - FINISH!' + '   <<<<<<<<<<\n-=#=-\n');
    }
    
    global class ConsultarBatch {
        public CuentaFacturacion__c obj;
        public ServiciosWeb__c paraServ;
        public LogTransacciones__c lt;
        private string request              = '';
        private string response             = '';
        private map<string,string> values   = new map<string,string>();
        private string error                = 'Exitoso';

        public ConsultarBatch(CuentaFacturacion__c obj,ServiciosWeb__c paraServ) {
            this.obj        = obj;
            this.paraServ   = paraServ;
            
            crearXml();
            consultar();
            procesar();
            generarLog();
        }
        
       
        private void crearXml() {
            values.put('direccion', obj.DirCorresp__c);
            values.put( 'correlationID', obtenerCorrelationId() );
            request = tibcoXml_cls.normalizacionDireccion(values);
            System.debug('\n\n-=#=-\n' + 'request' + ': ' + request + '\n-=#=-\n');
        }
        
        private void consultar() {
            response = LibreriaUtilitariaJobs_cls.consultarServicio(request, paraServ.Action__c,paraServ.EndPoint__c);
            System.debug('\n\n-=#=-\n' + 'response' + ': ' + response + '\n-=#=-\n');
        }
        
        private void procesar() {
            tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
            values.putAll(proReq.getMap(response));

            String strAddressFieldname = 'direccionNormalizada';
            
            System.debug('\n\n-=#=-\n' + 'values.get(\'' + strAddressFieldname + '\')' + ': ' + values.get(strAddressFieldname) + '\n-=#=-\n');
            System.debug('\n\n-=#=-\n' + 'values.get(\'error\')' + ': ' + values.get('error') + '\n-=#=-\n');

            if(values.get('error') == 'true') {
                if(values.get(strAddressFieldname).contains('*')) {
                    obj.AVX_EstadoDireccion__c = 'Con Errores';
                } else {
                    obj.AVX_EstadoDireccion__c = 'No Normalizada';
                }
            } else {
                System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'Validado' + '   <<<<<<<<<<\n-=#=-\n');
                
                string direccion = values.get(strAddressFieldname);            
                obj.DirCorresp__c          = direccion;
                obj.AVX_EstadoDireccion__c = 'Validado';
            }
        }
        
        public void generarLog() {
            lt = new LogTransacciones__c(
                    LTE_CuentaFacturacionLTE__c = obj.id,
                    Informacion_Enviada__c      = request,
                    Informacion_Recibida__c     = response,
                    Estado__c                   = obj.AVX_EstadoDireccion__c,
                    Name                        = 'Estandarizar direcciones',
                    CodigoRespuesta__c          = error
                 );
        }
        
        /**
		* @Method:		obtenerCorrelationId
		* @param:		NA
		* @Description:	Obtener id de correlacion para las transacciones.
		* @author		Manuel Medina - 05092016
		*/
	    private String obtenerCorrelationId(){
	    	
	    	Datetime dttFechaHoraActual	= System.now();
	    	Integer intNumeroRandom = Math.round( Math.random() * ( 1000 + dttFechaHoraActual.second() ) );
	    	String strCorrelationId = dttFechaHoraActual.format( 'ddMMyyyyHHmmssSSS' ) + String.valueOf( intNumeroRandom );
	    	
	    	return strCorrelationId;
	    }
    }
}