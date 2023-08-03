/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Integraciones Clientes CUN
Descripción:            Batch Para procesar los CUN que estan pendientes de ser generados
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     11-03-2014  Hector Bayona (HB)      Creación de la clase
2.0     19-08-2016  Antonio Torres (AT)     Method "procesar" modified to adjust response evaluation, due to an ETB request.
                                            Batch scheduled using BatchDireccionesSucursales_sch class.
*******************************************************************************/
global class BatchDireccionesSucursales_bch implements Database.Batchable<SObject>,Database.AllowsCallouts{
    
    global Database.Querylocator start(Database.Batchablecontext bc) {
        String query = 'SELECT Id, direccion__c, ciudad__r.Name FROM Account WHERE Estado_Direccion__c = \'Pendiente\' And Recordtype.Name = \'Sucursales\' LIMIT 10';
        System.debug('\n\n-=#=-\n' + 'query' + ': ' + query + '\n-=#=-\n');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        list<ConsultarBatch> c          = new list<ConsultarBatch>();
        ServiciosWeb__c sw              = ServiciosWeb__c.getValues('NormalizacionDireccion');
        list<LogTransacciones__c> lLog  = new list<LogTransacciones__c>();
        
        for(account a : scope) {
            c.add(new ConsultarBatch(a, sw));
        }
        
        for(ConsultarBatch l : c) {
            lLog.add(l.lt);
        }
        
        insert lLog;
        update scope;
    }

    global void finish(Database.BatchableContext bc) {
        BatchDireccionesSucursales_sch.scheduleJobExecution();
        System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'BatchDireccionesSucursales_bch - FINISH!' + '   <<<<<<<<<<\n-=#=-\n');
    }
    
    global class ConsultarBatch {
        public Account obj;
        public ServiciosWeb__c paraServ;
        public LogTransacciones__c lt;
        private string request              = '';
        private string response             = '';
        private map<string,string> values   = new map<string,string>();
        private string error                = 'Exitoso';

        public ConsultarBatch(Account obj,ServiciosWeb__c paraServ) {
            this.obj        = obj;
            this.paraServ   = paraServ;
            
            crearXml();
            consultar();
            procesar();
            generarLog();
        }
        
       
        private void crearXml() {
            values.put('direccion', obj.Direccion__c);
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

            /*if(values.get('direccionNormalizada') == null) {
                System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'Conexión Fallida' + '   <<<<<<<<<<\n-=#=-\n');

                obj.Estado_Direccion__c = 'Conexion Fallida';
                return;
            }

            if(values.get(strAddressFieldname).length() < 48 || values.get(strAddressFieldname).contains('*')) {
                System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'Con Errores' + '   <<<<<<<<<<\n-=#=-\n');

                error = values.get(strAddressFieldname);
                obj.Estado_Direccion__c = 'Con Errores';
                return;
            }*/

            if(values.get('error') == 'true') {
                if(values.get(strAddressFieldname).contains('*')) {
                    obj.Estado_Direccion__c = 'Con Errores';
                } else {
                    obj.Estado_Direccion__c = 'No Normalizada';
                }
            } else {
                System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'Validado' + '   <<<<<<<<<<\n-=#=-\n');
                
                //string direccion = values.get(strAddressFieldname).substring(47);
                string direccion = values.get(strAddressFieldname);
            
                obj.Direccion__c        = direccion;
                obj.Name                = 'Sucursal ' + obj.ciudad__r.Name + ' ' + direccion;
                obj.Estado_Direccion__c = 'Validado';
            }
        }
        
        public void generarLog() {
            lt = new LogTransacciones__c(
                    Account__c              = obj.id,
                    Informacion_Enviada__c  = request,
                    Informacion_Recibida__c = response,
                    Estado__c               = obj.Estado_Direccion__c,
                    Name                    = 'Estandarizar direcciones',
                    CodigoRespuesta__c      = error
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