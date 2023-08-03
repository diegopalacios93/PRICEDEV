/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Carlos Gonzalez
Proyecto:           LTE Evolutivos
Descripción:        Tarea programada, para el Batch procesar el desbloqueo de IMEI que esten en curso

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     15-07-2016  Carlos Gonzalez (CG)        Creación de la clase.
***********************************************************************************************************************/
global class DesbloqueoIMEI_sch implements Schedulable {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new DesbloqueoIMEI_bch(),1);
    }
    
    public static string ProgramarJob() {
        string strRetorno;

            string strCronExp = Datetime.now().addMinutes(30).format('ss mm HH dd MM ? yyyy');
            strRetorno = System.schedule('DesbloqueoIMEI_bch' + strCronExp, strCronExp,new DesbloqueoIMEI_sch());

        return strRetorno;
    }

}