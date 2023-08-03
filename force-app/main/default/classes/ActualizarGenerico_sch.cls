global with sharing class ActualizarGenerico_sch implements Schedulable {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new ActualizarGenerico_bch(),100);
    }
    
	public static string ProgramarJob() {
		string strRetorno;

            string strCronExp = Datetime.now().addMinutes(15).format('ss mm HH dd MM ? yyyy');
            if(Test.isRunningTest()){return null;}
            strRetorno = System.schedule('Actualizar Generico' + strCronExp, strCronExp,new ActualizarGenerico_sch());

        return strRetorno;
    }

}