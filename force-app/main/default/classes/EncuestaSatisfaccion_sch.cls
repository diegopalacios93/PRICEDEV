global with sharing class EncuestaSatisfaccion_sch implements Schedulable {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new EncuestaSatisfaccion_bch(),100);
    }

    /*	
	public static string ProgramarJob() {
		string strRetorno;
            string strCronExp = Datetime.now().addMinutes(30).format('ss mm HH dd MM ? yyyy');
            strRetorno = System.schedule('Encuesta Satisfacción' + strCronExp, strCronExp,new EncuestaSatisfaccion_sch());
        return strRetorno;
    }*/

}