global class ProcesosMasivos_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
	
    private String strParameter;

    public ProcesosMasivos_bch(String strParam) {
        strParameter = strParam;
    }
	global Database.Querylocator start(Database.Batchablecontext bc){
        string CurrentDate     = string.valueOf(Date.today());
        string estadoDefault   = 'Pendiente';
        string 	query  = 'SELECT Id, Name, Identificar_Activo__c, Estado__c,Activo__c,Activo__r.Plan__c,Activo__r.CuentaFacturacion__c, Proceso_Masivo__r.Id, ';
				query += 'Activo__r.NumeroConexion__c,Activo__r.NombredelaCuenta__c,Proceso_Masivo__r.Fecha_inicio_suspension__c,Proceso_Masivo__r.Fecha_inicio_reconexion__c,';
                query += 'Proceso_Masivo__r.Name, Proceso_Masivo__r.Proceso_a_ejecutar__c, Proceso_Masivo__r.Cuenta_cliente__c,Proceso_Masivo__r.Caso__c, ';
        		query += 'Proceso_Masivo__r.Cantidad_Registros_a_Proceso__c, ';
        		query += 'Proceso_Masivo__r.Fecha_de_inicio__c, Proceso_Masivo__r.Estado_del_proceso__c, Proceso_Masivo__r.Descripcion_del_estado__c ';
				query += 'FROM Registro_Proceso_Masivo__c ';
        		query += 'WHERE Proceso_Masivo__r.Fecha_de_inicio__c <=' + CurrentDate+'';
				query += 'AND Estado__c =\'' + estadoDefault + '\'';
				query += 'AND Proceso_Masivo__C =\'' + strParameter + '\'';
      
        System.debug('query--->'+query);
        return Database.getQueryLocator(query);
    }   
 	global void execute(Database.BatchableContext bc, List<Registro_Proceso_Masivo__c> scope){
        ProcesosMasivos_cls.procesarSolicitud(scope);
	}
    global void finish(Database.BatchableContext bc){
        ProcesosMasivos_cls.resumenProcesoMasivo();
		system.debug('!!!EXITO');
	}
}