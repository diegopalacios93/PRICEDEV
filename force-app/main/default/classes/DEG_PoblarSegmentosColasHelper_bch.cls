/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase batch helper de la clase DEG_PoblarSegmentosColas_bch para la actualización de los segmentos de los
			 usuarios según la información obtenida previamente en dicho batch
Clase test: DEG_PoblarSegmentosColasHelper_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     16/03/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
public class DEG_PoblarSegmentosColasHelper_bch implements Database.Batchable<sObject>, Database.Stateful{
    
    /*Mapa que tiene como claves los ids de los usuarios y como valor un texto que representa todos los segmentos de los
    que hacen parte*/
    Map<ID, String> mapaSegmentos;
    
    /**
     * @description constructor de la clase batch
     * @param mapaSegmentos mapa obtenido en el batch anterior
     */
    public DEG_PoblarSegmentosColasHelper_bch(Map<ID, String> mapaSegmentos) {
        this.mapaSegmentos = mapaSegmentos;
    }
    
    /**
     * @description método para consultar los usuarios pertenecientes al mapa de segmentos previamente obtenido
     * @param bc contexto del batch
     * @return Database.QueryLocator usuarios pertenecientes al mapa de segmentos previamente obtenido
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, DEG_SegmentoUsuario__c FROM User
                                         WHERE ID IN : mapaSegmentos.keySet()]);
    }
    
    /**
     * @description método para actualizar la información de los usuarios con base al mapa de segmentos
     * @param bc contexto del batch
     * @param usuarios usuarios pertenecientes al mapa de segmnetos previamente obtenido
     */
    public void execute(Database.BatchableContext bc, List<User> usuarios){
        List<User> usuariosSegmentos = new List<User>();
        Date fechaActual = Date.today();
        //Se actualiza la información de los usuarios con base al mapa de segmentos
        for(User usuario : usuarios) {
            usuario.DEG_SegmentoUsuario__c = mapaSegmentos.get(usuario.Id);
            usuario.DEG_UltimaModificacionSegmento__c = fechaActual;
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