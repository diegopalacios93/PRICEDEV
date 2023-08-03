/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Jorge Ramos
Proyecto:               ETB - Integraciones SFDC RevChain
Descripción:            Tarea programada, para el Batch procesar Facturacion de Larga Distancia
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     14-01-2016  Jorge Ramos (JR)     Creación de la clase
*******************************************************************************/
global class FacturacionLD_sch implements Schedulable {
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new FacturacionLD_bch(),1);
    }
    
    public static string ProgramarJob() {
        string strRetorno;

            string strCronExp = Datetime.now().addMinutes(30).format('ss mm HH dd MM ? yyyy');
            strRetorno = System.schedule('FacturacionLD_bch' + strCronExp, strCronExp,new FacturacionLD_sch());

        return strRetorno;
    }

}