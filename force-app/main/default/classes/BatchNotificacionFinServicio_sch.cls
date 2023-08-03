/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 03-09-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/

global class BatchNotificacionFinServicio_sch implements Schedulable {

    global void execute(SchedulableContext sc) {

        Database.executeBatch(new BatchNotificacionFinServicio_bch(), 100);

    }

    public static String ProgramarJob()
    {
        String strRetorno;
        String strCronExp = '0 0 10 1/1 * ? *';
        strRetorno = System.schedule('BatchNotificacionFinServicio_bch'+strCronExp, strCronExp, new BatchNotificacionFinServicio_sch());

        return strRetorno;
    }
}