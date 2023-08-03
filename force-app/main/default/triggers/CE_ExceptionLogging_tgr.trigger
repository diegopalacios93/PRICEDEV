/**************************************************************************************************
Desarrollado por: Accenture
Autores: Brisleydi Calderón, Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase trigger para procesar los logs generados por transacciones de integración
Clase test: CE_ConstruirCanonicoScheduleRemedy_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     02/12/2021      Brisleydi Calderón, Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
trigger CE_ExceptionLogging_tgr on CE_ExceptionLogging__e (after insert) {
    List<LogTransacciones__c> logTransacciones = new List<LogTransacciones__c>();
    //Se asocia cada uno de los platform events a un registro del objeto LogTransacciones__c
    for(CE_ExceptionLogging__e logException : Trigger.new){
        LogTransacciones__c logTransaccion = new LogTransacciones__c();
        logTransaccion.Name = logException.CE_Name__c;
        logTransaccion.Caso__c = logException.CE_Case__c; 
        logTransaccion.Informacion_Enviada__c = logException.CE_Request__c; 
        logTransaccion.Informacion_Recibida__c = logException.CE_Response__c;
        logTransaccion.Estado__c = logException.CE_Status__c;
        logTransaccion.CodigoRespuesta__c = logException.CE_StatusCode__c;
        logTransacciones.add(logTransaccion);
    }
    //Se realiza la inserción de los logs de transacciones asignados previamente
    if(logTransacciones.size()>0){
        Database.insert(logTransacciones, False);
    }
}