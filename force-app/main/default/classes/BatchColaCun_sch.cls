/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Integraciones Clientes CUN
Descripción:			Tarea programada, para el Batch procesar los CUN que estan pendientes de ser generados
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		13-03-2014	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/
global with sharing class BatchColaCun_sch implements Schedulable {
	
	global void execute(SchedulableContext sc){
		Database.executeBatch(new BatchColaCun_bch(),10);
	}
	
	public static string ProgramarJob() {
		string strRetorno;

            string strCronExp = Datetime.now().addMinutes(30).format('ss mm HH dd MM ? yyyy');
            strRetorno = System.schedule('Cola Cun' + strCronExp, strCronExp,new BatchColaCun_sch());

        return strRetorno;
    }
	

}