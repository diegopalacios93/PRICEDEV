/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase batch para la definición de los segmentos de los usuarios según las colas a las que estén asignados
Clase test: DEG_PoblarSegmentosColas_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     16/03/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
public class DEG_PoblarSegmentosColas_bch implements Database.Batchable<sObject>, Database.Stateful {
    
    /*Mapa que tiene como claves los ids de los usuarios y como valor un texto que representa todos los segmentos de los
    que hacen parte*/
    Map<ID, String> mapaSegmentos;
    //Listas de String con los respectivos developer name de las colas pertenecientes a los segmentos
    List<String> colasMasivos;
    List<String> colasMipymes;
    List<String> colasVentas;
    List<String> colasFacebook;
    List<String> colasEmpresas;
    
    /**
     * @description método para consultar las colas del sistema con los respectivos usuarios que hacen parte de ellas
     * @param bc contexto del batch
     * @return Database.QueryLocator colas del sistema con los respectivos usuarios que hacen parte de ellas
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        mapaSegmentos = new Map<ID, String>();
        colasMasivos = new List<String>();
    	colasMipymes = new List<String>();
        colasVentas = new List<String>();
        colasFacebook = new List<String>();
    	colasEmpresas = new List<String>();
        //Se hace el llenado de los listados con base a la información de la metadata de cada uno de los segmentos
        List<DEG_ColasSegmentoMasivos__mdt> segmentoMasivos = [SELECT DEG_NombreCola__c 
                                                               FROM DEG_ColasSegmentoMasivos__mdt];
        for(DEG_ColasSegmentoMasivos__mdt segmentoMasivo : segmentoMasivos) {
            colasMasivos.add(segmentoMasivo.DEG_NombreCola__c);
        }
        List<DEG_ColasSegmentoMipymes__mdt> segmentoMipymes = [SELECT DEG_NombreCola__c 
                                                               FROM DEG_ColasSegmentoMipymes__mdt];
        for(DEG_ColasSegmentoMipymes__mdt segmentoMypyme : segmentoMipymes) {
            colasMipymes.add(segmentoMypyme.DEG_NombreCola__c);
        }
        List<DEG_ColasSegmentoVentas__mdt> segmentoVentas = [SELECT DEG_NombreCola__c 
                                                             FROM DEG_ColasSegmentoVentas__mdt];
        for(DEG_ColasSegmentoVentas__mdt segmentoVenta : segmentoVentas) {
            colasVentas.add(segmentoVenta.DEG_NombreCola__c);
        }
        List<DEG_ColasSegmentoFacebook__mdt> segmentoFacebook = [SELECT DEG_NombreCola__c 
                                                                 FROM DEG_ColasSegmentoFacebook__mdt];
        for(DEG_ColasSegmentoFacebook__mdt segmentoFB : segmentoFacebook) {
            colasFacebook.add(segmentoFB.DEG_NombreCola__c);
        }
        List<DEG_ColasSegmentoEmpresas__mdt> segmentoEmpresas = [SELECT DEG_NombreCola__c 
                                                                 FROM DEG_ColasSegmentoEmpresas__mdt];
        for(DEG_ColasSegmentoEmpresas__mdt segmentoEmpresa : segmentoEmpresas) {
            colasEmpresas.add(segmentoEmpresa.DEG_NombreCola__c);
        }
        //Se valida si la ejecución es de un test para evitar excepciones en la ejecución de pruebas
        if(Test.isRunningTest()) {
            return Database.getQueryLocator([SELECT Id, GroupId, group.DeveloperName, UserOrGroupId 
                                             FROM GroupMember 
                                             WHERE group.Type = 'queue' order by UserOrGroupId
                                             LIMIT 200]);
        } else {
            return Database.getQueryLocator([SELECT Id, GroupId, group.DeveloperName, UserOrGroupId 
                                             FROM GroupMember 
                                             WHERE group.Type = 'queue' order by UserOrGroupId]);
        }
    }
    
    /**
     * @description método para defenir los segmentos a los que pertenece cada uno de los usuarios según las colas que
     * 				tienen asignadas
     * @param bc contexto del batch
     * @param agentes colas del sistema con los respectivos usuarios que hacen parte de ellas
     */
    public void execute(Database.BatchableContext bc, List<GroupMember> agentes){
        /*Se recorre cada una de los registros para ir completando la información de los segmentos a los que pertenecen
        cada uno de los usuarios*/
        for(GroupMember agente : agentes) {
            //Se valida si para el usuario actual ya hay información previamente definida en el mapa de segmentos
            String segmento = String.isBlank(mapaSegmentos.get(agente.UserOrGroupId)) ? '' : mapaSegmentos.get(agente.UserOrGroupId);
            //Se complementa la información del usuario en el mapa de segmentos según la cola actual
            if(colasMasivos.contains(agente.group.DeveloperName)) {
                if(!segmento.contains('Masivos')){
                    segmento = segmento + 'Masivos;';
                }
            }
            if(colasVentas.contains(agente.group.DeveloperName)) {
                if(!segmento.contains('Ventas')){
                    segmento = segmento + 'Ventas;';
                }
            }
            if(colasEmpresas.contains(agente.group.DeveloperName)) {
                if(!segmento.contains('Empresas')){
                    segmento = segmento + 'Empresas;';
                }
            }
            if(colasMipymes.contains(agente.group.DeveloperName)) {
                if(!segmento.contains('Mipymes')){
                    segmento = segmento + 'Mipymes;';
                }
            }
            if(colasFacebook.contains(agente.group.DeveloperName)) {
                if(!segmento.contains('Facebook')){
                    segmento = segmento + 'Facebook;';
                }
            }
            //Se actualiza el mapa de segmentos con la nueva información del segmento obtenida
            mapaSegmentos.put(agente.UserOrGroupId, segmento);
        }
    }
    
    /**
     * @description método para hacer la invocación del batch encargado de actualizar la información de los usuarios
     * 				con base a la información obtenida en el mapa de segmentos
     * @param bc contexto del batch 
     */
    public void finish(Database.BatchableContext bc){
        //Se realiza la invocación del batch helper para actualizar los usuarios trabajados previamente
        DEG_PoblarSegmentosColasHelper_bch poblarSegmentos = new DEG_PoblarSegmentosColasHelper_bch(mapaSegmentos);
		Id batchId = Database.executeBatch(poblarSegmentos);
    }
}