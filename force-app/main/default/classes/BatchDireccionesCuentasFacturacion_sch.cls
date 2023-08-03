/**
* Avanxo Colombia
* @author 			Guido Vargas href=<gvargas@avanxo.com>
* Project:			ETB
* Description:		Clase que porgrama la ejecucion del batch BatchDireccionesCuentasFacturacion_bch
*
* Changes (Version)
* -------------------------------------
*			No.		Date			Author					Description
*			-----	----------		--------------------	---------------
* @version	1.0		2016-08-22		Guido Vargas (GV)		Definicion inicial de la clase.
*************************************************************************************************************/
global class BatchDireccionesCuentasFacturacion_sch implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchDireccionesCuentasFacturacion_bch(), 10);
    }
    
    /**
    * @method       scheduleJobExecution
    * @description  Method that schedule the execution of the batch.
    * @author       Antonio Torres - 2016-08-19
    */
    public static void scheduleJobExecution() {
        EjecucionIntegracion__c cfgEjecucionIntegracion = EjecucionIntegracion__c.getValues('Direcciones');

        if(cfgEjecucionIntegracion != null && cfgEjecucionIntegracion.Ejecucion__c == true) {
            Tiempo_Ejecucion_Batch__c cfgTiempoEjecucionBatch = Tiempo_Ejecucion_Batch__c.getValues('BatchDireccionesSucursales_bch');
            
            if(cfgTiempoEjecucionBatch != null && cfgTiempoEjecucionBatch.Tiempo_Ejecucion__c > 0) {
                Datetime dtmCron = Datetime.now().addMinutes(Integer.valueof(cfgTiempoEjecucionBatch.Tiempo_Ejecucion__c));
                String strJobId = System.schedule('BatchDireccionesCuentasFacturacion_bch ' + dtmCron.format('dd-MM-yyyy HH:mm'), dtmCron.format('ss mm HH dd MM ? yyyy'), new BatchDireccionesCuentasFacturacion_sch());
                System.debug('\n\n-=#=-\n' + 'strJobId' + ': ' + strJobId + '\n-=#=-\n');
            }
        }
    }
}