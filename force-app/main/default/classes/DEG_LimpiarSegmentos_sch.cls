/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase Schedulable para la invocación del batch para la limpieza de los segmentos de los usuarios
Clase test: DEG_LimpiarSegmentosSch_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     05/04/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
public class DEG_LimpiarSegmentos_sch implements Schedulable {

    public void execute(SchedulableContext ctx) {
        /*Invocación de batch para limpiar el campo de segmento de los usuarios que no tienen asociada una configuración
		de supervisor ni una cola*/
        DEG_LimpiarSegmentos_bch limpiarSegmentos = new DEG_LimpiarSegmentos_bch();
		Id batchLimpiar = Database.executeBatch(limpiarSegmentos);
    }
}