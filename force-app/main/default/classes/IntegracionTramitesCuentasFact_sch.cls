global class IntegracionTramitesCuentasFact_sch implements Schedulable{
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
			Database.executeBatch(new IntegracionTramitesCuentasFact_bch(),1);
        }
  	}     
    public static string ProgramarJob() {
        string strRetorno;        
        string strCronExp = Datetime.now().addMinutes(30).format('ss mm HH dd MM ? yyyy');        
        strRetorno = System.schedule('IntegracionTramitesCuentasFact_bch' + strCronExp, strCronExp,new IntegracionTramitesCuentasFact_sch());        
        return strRetorno;
  	}
}