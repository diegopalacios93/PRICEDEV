/*******************************************************************************
Desarrollado por:		ETB
Autor:					Samuel Rodríguez
Proyecto:				ETB - Jerarquia de cuentas
Descripcion:			Batch para procesar las operaciones comerciales de traslado de servicios en facturación.
Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                 Descripción
------  ----------  --------------------  ---------------
1.0		21-05-2020	Samuel Rodríguez      Creación de la clase
1.1		30-11-2020	Fernando Sarasty	  Se incluye el trámite de Conversión Demo a venta
*******************************************************************************/
global class TrasladoServiciosFacturacion_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {

    global Database.Querylocator start(Database.Batchablecontext bc){
        
        System.debug('\n@@-Entro a Database.Querylocator: ');
        string TipoOperacionPorPlan = 'Cambio Cuenta de Facturacion';
        string TipoRegistroPlanDemo = 'Conversion_Demo_a_Venta';
        string EstadoOC = 'Pendiente Facturacion';
        String CurrentDate     = string.valueOf(Date.today());
        String CurrentDateDemo = string.valueOf(Date.today()+1);
        System.debug('\n@@-CurrentDate: ' + CurrentDate);
        
        string 	query = 'SELECT id, name, TOPP__r.TipodeOperacionporplan__c,TOPP__r.name, TOPP__r.Tipoderegistro__c, CuentaCliente__r.name,';
        		query += 'Activo__r.name, Activo__r.CuentaFacturacion__r.name,Activo__r.NombredelProducto__r.name,Plan__c, Plan__r.Id, ';
        		query += 'CuentaFacturacion__r.name, Activo__r.ExternalServiceID__c, Activo__r.NumeroConexion__c,';
        		query += 'Activo__r.CuentaFacturacion__r.CodCicloFac__c,Activo__r.CuentaFacturacion__r.LTE_CuentaFacturacionLTE__c,';
        		query += 'FechadeActivacion__c, EnvioFacturacion__c, FechaFacturacion__c, ValorTarifaPlan__c, Valor_Equipos__c, ValorObraCivil__c, ';
        		query += 'Valorunicavez__c, Valor_Recurrente_Aliado__c, DescuentoPorc__c ';
                query += 'from OperacionComercial__c ';
        		query += 'WHERE ((TOPP__r.TipodeOperacionporplan__c =\'' + TipoOperacionPorPlan + '\' and EnvioFacturacion__c  = true ';
        		query += 'and FechadeActivacion__c <=' + CurrentDate+') ';
        		query += 'or (TOPP__r.Tipoderegistro__c = \'' + TipoRegistroPlanDemo + '\' and  TOPP__r.Facturable__c = true ';
        		query += 'and FechadeActivacion__c <=' + CurrentDateDemo+')) ';
        		query += 'and Estado__c =\''+ EstadoOC +'\'';         		
                if(Test.isRunningTest())
                    query +=' LIMIT 1';
		System.debug('\n@@-ConsultaTrasladoServiciosFacturacion_bch: '+ query);
        System.debug('\n@@-Salio de Database.Querylocator: ');
		return Database.getQueryLocator(query);
        
	}
	
	global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){
        System.debug('\n@@-Entro a execute');
        system.debug('\n TrasladoServiciosFacturacion_bch.scope:' + scope);
        IntegracionTramitesCuentaFacturacion_cls.TransferService(scope);        
        IntegracionCambioTarifaDemoAVenta_cls.ProcesarSolicitud(scope);        
	}
   
    global void finish(Database.BatchableContext bc){	
        TrasladoServiciosFacturacion_sch.ProgramarJob();
		system.debug('\n@@-FinBatch TrasladoServiciosFacturacion_bch');
    }
    
}