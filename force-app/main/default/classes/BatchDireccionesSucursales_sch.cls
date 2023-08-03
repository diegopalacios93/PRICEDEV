/**
**************************************************************************************************************
* @company          Avanxo Colombia
* @author           Antonio Torres href=<atorres@avanxo.com>
* @project          ETB
* @name             BatchDireccionesSucursales_sch
* @description      Class to schedule the execution of the batch BatchDireccionesSucursales_bch
* @dependencies     Class BatchDireccionesSucursales_bch
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------------
* @version   1.0   2016-08-19   Antonio Torres (AT)           Creation of the class.
**************************************************************************************************************
**/

global class BatchDireccionesSucursales_sch implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchDireccionesSucursales_bch(), 10);
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
                String strJobId = System.schedule('BatchDireccionesSucursales_bch ' + dtmCron.format('dd-MM-yyyy HH:mm'), dtmCron.format('ss mm HH dd MM ? yyyy'), new BatchDireccionesSucursales_sch());
                System.debug('\n\n-=#=-\n' + 'strJobId' + ': ' + strJobId + '\n-=#=-\n');
            }
        }
    }
}