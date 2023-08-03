/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase batch para la población de los segmentos de los usuarios que tienen asignada una configuración de
			 supervisor
Clase test: DEG_PoblarSegmentosSupervisores_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        Descripción
1.0     15/03/2022      Raúl Andrés Gómez Ramírez      Creación 
***************************************************************************************************/
public class DEG_PoblarSegmentosSupervisores_bch implements Database.Batchable<sObject>, Database.Stateful  {
    
    /*Listas de String con los respectivos developer name de las configuraciones de supervisores pertenecientes a los 
	segmentos*/
    List<String> supervisoresMasivos;
    List<String> supervisoresMipymes;
    List<String> supervisoresVentas;
    List<String> supervisoresFacebook;
    List<String> supervisoresEmpresas;
    
    /**
     * @description método para consultar las configuraciones de supervisores en el sistema
     * @param bc contexto del batch
     * @return Database.QueryLocator configuraciones de supervisores en el sistema
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        supervisoresMasivos = new List<String>();
    	supervisoresMipymes = new List<String>();
        supervisoresVentas = new List<String>();
        supervisoresFacebook = new List<String>();
    	supervisoresEmpresas = new List<String>();
        //Se hace el llenado de los listados con base a la información de la metadata de cada uno de los segmentos
        List<DEG_SupervisorSegmentoMasivos__mdt> segmentoMasivos = [SELECT DEG_NombreSupervisor__c 
                                                                    FROM DEG_SupervisorSegmentoMasivos__mdt];
        for(DEG_SupervisorSegmentoMasivos__mdt segmentoMasivo : segmentoMasivos) {
            supervisoresMasivos.add(segmentoMasivo.DEG_NombreSupervisor__c);
        }
        List<DEG_SupervisorSegmentoMipymes__mdt> segmentoMipymes = [SELECT DEG_NombreSupervisor__c 
                                                                    FROM DEG_SupervisorSegmentoMipymes__mdt];
        for(DEG_SupervisorSegmentoMipymes__mdt segmentoMypyme : segmentoMipymes) {
            supervisoresMipymes.add(segmentoMypyme.DEG_NombreSupervisor__c);
        }
        List<DEG_SupervisorSegmentoVentas__mdt> segmentoVentas = [SELECT DEG_NombreSupervisor__c 
                                                                  FROM DEG_SupervisorSegmentoVentas__mdt];
        for(DEG_SupervisorSegmentoVentas__mdt segmentoVenta : segmentoVentas) {
            supervisoresVentas.add(segmentoVenta.DEG_NombreSupervisor__c);
        }
        List<DEG_SupervisorSegmentoFacebook__mdt> segmentoFacebook = [SELECT DEG_NombreSupervisor__c 
                                                                      FROM DEG_SupervisorSegmentoFacebook__mdt];
        for(DEG_SupervisorSegmentoFacebook__mdt segmentoFB : segmentoFacebook) {
            supervisoresFacebook.add(segmentoFB.DEG_NombreSupervisor__c);
        }
        List<DEG_SupervisorSegmentoEmpresas__mdt> segmentoEmpresas = [SELECT DEG_NombreSupervisor__c 
                                                                      FROM DEG_SupervisorSegmentoEmpresas__mdt];
        for(DEG_SupervisorSegmentoEmpresas__mdt segmentoEmpresa : segmentoEmpresas) {
            supervisoresEmpresas.add(segmentoEmpresa.DEG_NombreSupervisor__c);
        }
        //Se valida si la ejecución es de un test para evitar excepciones en la ejecución de pruebas
        if(Test.isRunningTest()) {
            return Database.getQueryLocator([SELECT Id, OmniSupervisorConfig.DeveloperName, UserId, 
                                             User.DEG_SegmentoUsuario__c
                                             FROM OmniSupervisorConfigUser
                                             LIMIT 200]); 
        } else{
            return Database.getQueryLocator([SELECT Id, OmniSupervisorConfig.DeveloperName, UserId, 
                                             User.DEG_SegmentoUsuario__c
                                             FROM OmniSupervisorConfigUser]);
        }
    }
    
    /**
     * @description método para asignar los segmentos a los usuarios según la configuración de supervisor que tienen
     * 				asignada
     * @param bc contexto del batch
     * @param supervisores configuraciones de supervisores en el sistema
     */
    public void execute(Database.BatchableContext bc, List<OmniSupervisorConfigUser> supervisores){
        List<User> usuarios = new List<User>();
        Date fechaActual = Date.today();
        /*Se recorre cada una de las configuraciones de supervisores en el sistema para saber qué segmento asignar al
        según el nombre de la configuración de supervisor*/
        for(OmniSupervisorConfigUser supervisor : supervisores) {
            User usuario = new User();
            usuario.Id = supervisor.UserId;
            usuario.DEG_UltimaModificacionSegmento__c = fechaActual;
            if(supervisoresMasivos.contains(supervisor.OmniSupervisorConfig.DeveloperName)) {
                usuario.DEG_SegmentoUsuario__c = 'Masivos';
            } else if(supervisoresVentas.contains(supervisor.OmniSupervisorConfig.DeveloperName)) {
                usuario.DEG_SegmentoUsuario__c = 'Ventas';
            } else if(supervisoresEmpresas.contains(supervisor.OmniSupervisorConfig.DeveloperName)) {
                usuario.DEG_SegmentoUsuario__c = 'Empresas';
            } else if(supervisoresMipymes.contains(supervisor.OmniSupervisorConfig.DeveloperName)) {
                usuario.DEG_SegmentoUsuario__c = 'Mipymes';
            } else if(supervisoresFacebook.contains(supervisor.OmniSupervisorConfig.DeveloperName)) {
                usuario.DEG_SegmentoUsuario__c = 'Facebook';
            } else {
                usuario.DEG_SegmentoUsuario__c = '';
            }
            usuarios.add(usuario);
        }
        //Se actualizan los usuarios con su respectivo segmento previamente definido
        Database.update(usuarios, false);
    }
    
    /**
     * @description método finish del batch
     * @param bc contexto del batch 
     */
    public void finish(Database.BatchableContext bc){
        System.debug('Finish');
    }
}