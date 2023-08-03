/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase Schedulable para la invocación de los batch para la población de los segmentos de los usuarios
Clase test: DEG_PoblarSegmentos_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     15/03/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
public class DEG_PoblarSegmentos_sch implements Schedulable {
    public void execute(SchedulableContext ctx) {
        /*Invocación de batch para diligenciar los segmentos de los usuarios según las configuraciones de supervisores
        que tienen asignadas*/
        DEG_PoblarSegmentosSupervisores_bch poblarSegmentosSupervisor = new DEG_PoblarSegmentosSupervisores_bch();
		Id batchSupervisor = Database.executeBatch(poblarSegmentosSupervisor);
        //Invocación de batch para diligenciar los segmentos de los usuarios según las colas que tengan asignadas
        DEG_PoblarSegmentosColas_bch poblarSegmentosColas = new DEG_PoblarSegmentosColas_bch();
		Id batchCola = Database.executeBatch(poblarSegmentosColas);
    }
}