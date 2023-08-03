/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase batch para limpiar el campo de segmento de los usuarios que no tienen asociada una configuración
			 de supervisor ni una cola
Clase test: DEG_LimpiarSegmentosBch_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     05/04/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
public class DEG_LimpiarSegmentos_bch implements Database.Batchable<sObject>, Database.Stateful{
    
    /**
    * @description método para consultar los usuarios sin configuraciones de supervisores ni colas
    * @param bc contexto del batch
    * @return Database.QueryLocator usuarios sin configuraciones de supervisores ni colas
    */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date fechaActual = Date.today();
        if(Test.isRunningTest()) {
            return Database.getQueryLocator([SELECT Id, DEG_SegmentoUsuario__c FROM User
                                             LIMIT 200]);
        } else {
            return Database.getQueryLocator([SELECT Id, DEG_SegmentoUsuario__c FROM User
                                             WHERE DEG_UltimaModificacionSegmento__c!=:fechaActual AND 
                                             DEG_SegmentoUsuario__c!=NULL AND DEG_SegmentoUsuario__c!='']);
        }
    }
    
    /**
    * @description método para limpiar el campo de segmento de los usuarios consultados
    * @param bc contexto del batch
    * @param usuarios usuarios sin configuraciones de supervisores ni colas
    */
    public void execute(Database.BatchableContext bc, List<User> usuarios){
        List<User> usuariosSegmentos = new List<User>();
        //Se limpia el campo de segmento
        for(User usuario : usuarios) {
            usuario.DEG_SegmentoUsuario__c = '';
            usuariosSegmentos.add(usuario);
        }
        Database.update(usuariosSegmentos, false);
    }
    
    /**
    * @description método finish del batch
    * @param bc contexto del batch 
    */
    public void finish(Database.BatchableContext bc){
        System.debug('Finish');
    }
}