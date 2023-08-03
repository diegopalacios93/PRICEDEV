/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Manuel Cortes
Proyecto:           LTE Evolutivos
Descripción:        Batch para procesar los detalle de oferta con y validar los IMEI.

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     19-07-2016  Manuel Cortes (MC)        Creación de la clase.
***********************************************************************************************************************/
global class ConsultaIMEI_bch implements Database.Batchable<SObject>,Database.AllowsCallouts{
	
    global Database.Querylocator start(Database.Batchablecontext bc){
    	System.debug('=== start ConsultaIMEI_bch ===');
        //Id gestionId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get(Label.LTE_Titulo_Gestion_IMEI).getRecordTypeId();
		
	    String query = 'SELECT '+
	    'LTE_IMEI__c ' +
	    '' +
	    '' +
	    '' +
	    '' +
	    'FROM LTE_DetalleOferta__c '+
	    'WHERE LTE_Estado__c = \'Pendiente\' ' +
	    'AND LTE_IMEI__c != null '
	    //+ 'AND Id = \'a15c0000000oscxAAA\''
	    ;
	    

        System.debug('Query: '+query);
        return Database.getQueryLocator(query);    
    }

    global void execute(Database.BatchableContext bc, List<LTE_DetalleOferta__c> scope){
        System.debug('=== execute ConsultaIMEI_bch ===');
        Map<String, String> mapp = null;
        Map<String, String> mapResponse = null;
        List<LogTransacciones__c> lstLogTransacciones = new List<LogTransacciones__c>();
        LogTransacciones__c logTmp = null;
        for(LTE_DetalleOferta__c detalleOferta : scope){
        	logTmp =  new LogTransacciones__c();
        	mapp = new Map<String, String>();
			mapp.put('userName', UserInfo.getUserName());
			mapp.put('strIMEI', detalleOferta.LTE_IMEI__c);
			mapp.put('correlationID',getCorrelationID('DE'));
			//mapp.put('strTipoDoc','CC');
			//mapp.put('strDoc','12123');
			
			//Se consulta el imei
			mapResponse = LTE_GestionIMEI_cls.consultarIMEI(mapp);
        	System.debug('Respuesta ' + mapResponse);
        	if(mapResponse.containsKey('ERROR')){
        		if(mapResponse.get('ERROR') == 'false'){
        			detalleOferta.LTE_Estado__c = Label.LTE_IMEI_No_Reportado;
        		}else{
        			detalleOferta.LTE_Estado__c = Label.LTE_IMEI_Reportado;
        		}
        	}else{
        		
        	}
        	
        	logTmp.LTE_Detalle_Oferta__c = detalleOferta.Id;
        	logTmp.CodigoRespuesta__c = mapResponse.get('CODIGO_RESPUESTA');
        	logTmp.Estado__c = detalleOferta.LTE_Estado__c;
        	logTmp.Informacion_Enviada__c = mapResponse.get('XML_REQUEST');
        	logTmp.Informacion_Recibida__c = mapResponse.get('XML_RESPONSE');
        	lstLogTransacciones.add(logTmp);
        }
        System.debug('Se va actulizar: ' + scope);
    	update scope;
    	insert lstLogTransacciones;
    }
    
    global void finish(Database.BatchableContext bc){        
        System.debug('=== finish ConsultaIMEI_bch === ' + bc );
        AsyncApexJob batchJob = [SELECT Id, ApexClassId, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:bc.getJobId()];
        Integer jobs = [Select COUNT() FROM AsyncApexJob WHERE ApexClassId = :batchJob.ApexClassId AND JobType = 'BatchApex' AND ( Status = 'Queued' OR Status = 'Processing' OR Status = 'Preparing' )];
        if(jobs == 0){
        	ConsultaIMEI_sch.programarJob();
        }else{
        	System.debug('Se debe esperar porque hay ('+jobs+') jobs encolados.');
        }
    } 
    
     /**************************************************
    * Método encargado para generar un id único de identificacion
    **************************************************/
    private static String getCorrelationID(String strPrefix){
		return (strPrefix.toUppercase()+EncodingUtil.ConvertTohex(Crypto.GenerateAESKey(128))).SubString(0,18);
    }   

}