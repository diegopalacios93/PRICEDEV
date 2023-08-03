/*******************************************************************************
Desarrollado por:		ETB
Autor:					Samuel Rodríguez
Proyecto:				ETB - Jerarquia de cuentas
Descripción:			Tarea programada, para integrar OC de Traslado de servicios en cuentas de facturación.
Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                 Descripción
------  ----------  --------------------  ---------------
1.0		21-05-2020	Samuel Rodríguez      Creación de la clase
*******************************************************************************/
global class TrasladoServiciosFacturacion_sch implements Schedulable {
    
    global void execute(SchedulableContext sc){
        if(!Test.isRunningTest()){
			Database.executeBatch(new TrasladoServiciosFacturacion_bch(),1);
        }
	}
    
    public static string ProgramarJob(){
		string strRetorno;
        string strCronExp = Datetime.now().addMinutes(180).format('ss mm HH dd MM ? yyyy');
        strRetorno = System.schedule('TrasladoServiciosFacturacion_bch' + strCronExp, strCronExp,new TrasladoServiciosFacturacion_sch());
        return strRetorno;
    }

}