global class LTE_AprovisionamientoBolsaCompartida_sch implements Schedulable 
{  
  	global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
			Database.executeBatch(new LTE_AprovisionamientoBolsaCompartida_bch(),1);
        }
  	}    
    public static string ProgramarJob() {
        string strRetorno;        
        string strCronExp = Datetime.now().addMinutes(180).format('ss mm HH dd MM ? yyyy');        
        strRetorno = System.schedule('LTE_AprovisionamientoBolsaCompartida_bch' + strCronExp, strCronExp,new LTE_AprovisionamientoBolsaCompartida_sch());        
        return strRetorno;
  	}
}