/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Manuel Alejandro Cortes Perez
Proyecto:           LTE Evolutivos
Descripción:        Tarea programada, para el Batch procesar la consulta de IMEI que esten en curso

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     21-07-2016  Manuel Cortes (MC)        Creación de la clase.
***********************************************************************************************************************/
global class ConsultaIMEI_sch implements Schedulable {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new ConsultaIMEI_bch(),10);
    }
    
    /**********************************************************
    * Metodo encargado de programar el batch 5 minutos despues
    **********************************************************/
    public static void programarJob() {
    	
    		Integer minutos = GestionBatch_cls.getTime(ConsultaIMEI_bch.class, 120);
            String strCronExp = Datetime.now().addMinutes(minutos).format('ss mm HH dd MM ? yyyy');
            System.schedule( (Math.random() * 5) +'ConsultaIMEI_bch_' + strCronExp, strCronExp, new ConsultaIMEI_sch());
            
	}
    
}