/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Luis Eduardo Mogollón
Proyecto:				ETB - Integraciones SFDC RevChain
Descripción:			Tarea programada, para el Batch procesar Facturacion
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		21-02-2015	Luis Eduardo Mogollón (LEM)		Creación de la clase
*******************************************************************************/
global class Facturacion_sch implements Schedulable {
	
	global void execute(SchedulableContext sc){
		Database.executeBatch(new Facturacion_bch(),5);
	}
	
	public static string ProgramarJob() {
		string strRetorno;

            string strCronExp = Datetime.now().addMinutes(30).format('ss mm HH dd MM ? yyyy');
            strRetorno = System.schedule('Facturacion_bch' + strCronExp, strCronExp,new Facturacion_sch());

        return strRetorno;
    }

}