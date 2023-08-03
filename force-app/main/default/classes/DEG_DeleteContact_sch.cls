/*************************************************************************************/
/* Desarrollado por: Accenture 
/* Autor:            Diego Alejandro Rico
/* Proyecto:         ETB - DE
/* Descripción:      
/* Clase de prueba DEG_DeleteContact_tst
/* Cambios (Versiones) 
/* ----------------------------------------------------------------------------------- 
/* No.  Fecha       Autor                   Descripción 
/* ---- ----------- ----------------------- ------------------------------------------
/* 1.0  05-10-2021  Diego Rico (DARF)     Creacion de la clase 
/*************************************************************************************/ 
global class DEG_DeleteContact_sch implements Schedulable {
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
			Database.executeBatch(new DEG_DeleteContact_bch());            
        }
    }
    public static string ProgramarJob() {
        string strRetorno;
        Date myDate = Date.today();
        myDate = myDate.addDays(1);
        Time myTime = Time.newInstance(23,50, 0, 0);
        String strCronExp = DateTime.newInstance(myDate, myTime).format('ss mm HH dd MM ? yyyy');
        strRetorno = System.schedule('DEG_DeleteContact_bch'+datetime.now()+ strCronExp, strCronExp,new DEG_DeleteContact_sch());        
        return strRetorno;
    }   
}