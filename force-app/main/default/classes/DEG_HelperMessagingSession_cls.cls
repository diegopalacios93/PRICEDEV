/**
 * @description       :
 * @author            : Sebastian Urrutia (SUF)
 * @group             :
 * @last modified on  : 12-04-2021
 * @last modified by  : j.martinez.mercado
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   05-25-2021   Sebastian Urrutia (SUF)   Initial Version
 * 1.1   01-03-2022   Johan Andres Olarte (jal)  Ajustes a los valores con etiquetas personalizadas,
 *                                               se asocia la apertura de casos del canal de facebook HU 
 *                                               Redes Sociales.
 **/

public without sharing class DEG_HelperMessagingSession_cls {

    public void setOwner(Map<Id,MessagingSession> mapChats){

        Case caso = new Case();
        List<Case> lstCase = new List<Case>();
        Map<Id,Id> mapCasesChat = new Map<Id,Id>();

        for(MessagingSession lct : mapChats.values())
        {
            mapCasesChat.put(lct.CaseId, lct.Id);
        }

        for(Case cs : [
            SELECT Id, OwnerId, Status, DEG_GestionadoPor__c
            FROM Case
            WHERE Id IN: mapCasesChat.keySet()
        ]) {
            cs.OwnerId = mapChats.get(mapCasesChat.get(cs.Id)).OwnerId;
            if (cs.DEG_GestionadoPor__c == 'Bot') {
                cs.Status = 'Abierto';
                cs.DEG_GestionadoPor__c = 'Agente';
            }

            lstCase.add(cs);
        }

        if(lstCase.size() > 0) update lstCase;

    }

    public void createCases(List<MessagingSession> lstChats, Map<Id, MessagingSession> mapNewChats){
        Id masivoRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId();
        Id empresaRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CASO_PQR').getRecordTypeId();
        Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();
        
        
        User usr = [SELECT Id, username, profileId FROM User WHERE username LIKE 'autoproc%' LIMIT 1];

        Map<Id,Id> mapIdId = new Map<Id,Id>();
		Map<Id,MessagingChannel> mapIdmChannel = new Map<Id,MessagingChannel>();
        Set<Id> setIdLiveButton = new Set<Id>();
        Map<Id,Case> mapChatCase = new Map<Id,Case>();

        for(MessagingSession lct : lstChats){
            setIdLiveButton.add(lct.MessagingChannelId);
		}
        
        List<MessagingChannel> lstMessagingChannelMasivo   = [SELECT Id FROM MessagingChannel WHERE DeveloperName =: Label.DEG_MsgChannelNameMasivos LIMIT 1];
        List<MessagingChannel> lstMessagingChannelNegocios = [SELECT Id FROM MessagingChannel WHERE DeveloperName =: Label.DEG_MsgChannelNameNegocio LIMIT 1];
        List<MessagingChannel> lstMessagingChannelEmpresas = [SELECT Id FROM MessagingChannel WHERE DeveloperName =: Label.DEG_MsgChannelNameEmpresas LIMIT 1];
        List<MessagingChannel> lstMessagingChannelVentas   = [SELECT Id FROM MessagingChannel WHERE DeveloperName =: Label.DEG_MsgChannelNameVentas LIMIT 1];
        List<MessagingChannel> lstMessagingChannelFacebook = [SELECT Id FROM MessagingChannel WHERE DeveloperName =: Label.DEG_MsgChannelNameFacebook LIMIT 1];
        
        List<Case> lstCase = new List<Case>();
        Map<Id, MessagingSession> msMap = new Map<Id, MessagingSession>(); 
	//Modificacion del origen para canal Hogares y MiPymes	 'Canal WhatsApp'
        for(MessagingSession lct : lstChats){
            if(lct.MessagingChannelId != lstMessagingChannelVentas[0].Id){
			    Case cs = new Case();
                if( lct.MessagingChannelId == lstMessagingChannelMasivo[0].Id ){
                    cs.RecordTypeId = masivoRTId;
                    cs.Origin = Label.DEG_Origen_Hogares;
                    cs.DEG_Segmento__c = label.DEG_Segmento_Masivo;
                } else if( lct.MessagingChannelId == lstMessagingChannelEmpresas[0].Id ){
                    cs.RecordTypeId = empresaRTId;
                    cs.Origin = Label.DEG_Origen_Empresas;
                } else if( lct.MessagingChannelId == lstMessagingChannelNegocios[0].Id ){
                    cs.RecordTypeId = masivoRTId;
                    cs.Origin = Label.DEG_Origen_Mypimes;
                    cs.DEG_Segmento__c = Label.DEG_Segmento_MiPymes;
                } else if( lct.MessagingChannelId == lstMessagingChannelFacebook[0].Id ){
                cs.RecordTypeId = masivoRTId;
                cs.Origin = Label.DEG_Origen_Facebook;
                } 

                cs.OwnerId = lct.OwnerId;
                cs.Status = 'Resuelto';

                if(!mapChatCase.containsKey(lct.Id)){
                    mapChatCase.put(lct.Id, cs);
                }
                else {
                    mapChatCase.remove(lct.Id);
                    mapChatCase.put(lct.Id, cs);
                }
			    lstCase.add(cs);
                }
            else
            {
                msMap.put(lct.MessagingEndUserId,lct);
            }
		}
        if(msMap.size()>0)
        {
            List<MessagingEndUser> msgEndUser = [SELECT Id, DEG_Caso__c, ContactId, Contact.CreatedDate, 
                                                 Contact.DEG_groupReinjection__c, MessagingPlatformKey, 
                                                 Contact.DEG_NombrePlantilla__c, Contact.DEG_Supervisor__c,
                                                 Contact.DEG_FuenteEnvio__c
                                                 FROM MessagingEndUser WHERE Id =: msMap.keyset()];
            Map<String, MessagingEndUser> mapaUsuarios = new Map<String, MessagingEndUser>();
            Set<String> nombreColas = new Set<String>();
            //Se diferencia entre los MessagingEndUser que son de ventas general vs los de ventas reinyección
            for(MessagingEndUser usuario : msgEndUser) {
                if(usuario.ContactId != null && usuario.Contact.DEG_groupReinjection__c != null){
                    String cellNumber = usuario.MessagingPlatformKey.substringAfter('+57');
                    mapaUsuarios.put(cellNumber, usuario);
                    nombreColas.add(usuario.Contact.DEG_groupReinjection__c);
                }else{
                    MessagingSession mensajeOriginal = msMap.get(usuario.Id);
                	mensajeOriginal.CaseId = usuario.DEG_Caso__c;
                }
            }
            //Lógica para tratar MessagingEndUser asociados a canal de ventas por reinyecciones
            if(mapaUsuarios.size()>0) {
                List<Group> colaReinjection = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName IN :nombreColas];
                Map<String, Id> mapaColas = new Map<String, Id>();
                for(Group grupo : colaReinjection){
                    mapaColas.put(grupo.DeveloperName, grupo.Id);
                }
                //Se traen los casos asociados a los números de celular de los MessagingEndUsers
                List<Case> casos = [SELECT Id, DEG_Celular__c, DEG_IdCola__c, Status, 
                                    DEG_Cliente_Genera_Interaccion_WhatsApp__c 
                                    FROM Case WHERE DEG_Celular__c  IN : mapaUsuarios.keySet() AND 
                                    RecordTypeId =: ventasRTId AND Status NOT IN ('Resuelto', 'Resuelto Automatico')];    
                Map<String, Case> mapaCasos = new Map<String, Case>();
                //Se crea un mapa de casos para saber si existen casos asociados a un determinado número de celular
                for(Case caso : casos){
                    mapaCasos.put(caso.DEG_Celular__c, caso);
                }
                List<Case> casosUpsert = new List<Case>();
                //Se valida si ya hay un caso asociado para el número del usuario para crear o actualizar el caso
                for(MessagingEndUser usuario : mapaUsuarios.values()){
                    MessagingSession mensajeOriginal = msMap.get(usuario.Id);
                    String cellNumber = usuario.MessagingPlatformKey.substringAfter('+57');
                    //Se llenan los campos necesarios para los informes
                    mensajeOriginal.DEG_TelefonoCliente__c = cellNumber;
                    mensajeOriginal.DEG_FechaCreacionLead__c = Date.newinstance(usuario.Contact.Createddate.year(), usuario.Contact.Createddate.month(), usuario.Contact.Createddate.day());
                    mensajeOriginal.DEG_HoraCreacionLead__c = usuario.Contact.createddate.time();
                    mensajeOriginal.DEG_Supervisor__c = usuario.Contact.DEG_Supervisor__c;
                    mensajeOriginal.DEG_NombrePlantilla__c = usuario.Contact.DEG_NombrePlantilla__c;
                    mensajeOriginal.DEG_FuenteEnvio__c = usuario.Contact.DEG_FuenteEnvio__c;
                    mensajeOriginal.DEG_EsReinyeccion__c = true;
                    String nombreCola = usuario.Contact.DEG_groupReinjection__c;
                    if(nombreCola=='DEG_Ventasreinyecion1'){
                        mensajeOriginal.shippingSource__c='proveedor 1';
                    } else {
                        mensajeOriginal.shippingSource__c='proveedor 2';
                    }
                    Case caso = mapaCasos.get(cellNumber);
                    if(caso==null){
                        Case objCase = new Case();
                        objCase.RecordTypeId = ventasRTId;
                        objCase.DEG_Celular__c = cellNumber;
                        objCase.OwnerId = mapaColas.get(usuario.Contact.DEG_groupReinjection__c);
                        objCase.Status = 'Contactar Prospecto';
                        objCase.Origin = 'Canal WhatsApp Ventas';
                        casosUpsert.add(objCase);                        
                    }
                    else {
                        caso.OwnerId = mapaColas.get(usuario.Contact.DEG_groupReinjection__c);
                        caso.Status = 'En proceso';
                        mensajeOriginal.CaseId = caso.Id;
                        casosUpsert.add(caso);
                    }
                }
                //Se hace un upsert para crear o actualizar los casos previamente tratados
                if(casosUpsert.size()>0){
                    Set<Id> idCasosSet = new Set<Id>();
                    List<Database.UpsertResult> resultados = database.upsert(casosUpsert);
                    for(Database.UpsertResult resultado : resultados){
                        if(resultado.isCreated()){
                            idCasosSet.add(resultado.getId());
                        }
                    }
                    //Se asignan los casos creados a las respectivas conversaciones a las que pertenecen
                    List<Case> casosFinales = [SELECT Id, DEG_Celular__c FROM Case WHERE id IN : idCasosSet];
                    for(Case caso :casosFinales){
                        MessagingEndUser usuario = mapaUsuarios.get(caso.DEG_Celular__c);
                        MessagingSession mensajeOriginal = msMap.get(usuario.Id);
                        mensajeOriginal.CaseId = caso.Id;
                    }
                }
            }
        }
        try{
            if(!lstCase.isEmpty()){
                Insert lstCase;
                for(MessagingSession lct : lstChats){
                    lct.CaseId = mapChatCase.get(lct.Id).Id;
                }
            }
        }
		catch(Exception e){
            System.debug('##Exception' + e);
        }
		if(!lstCase.isEmpty()) {
            for(Integer i = 0 ; i < lstChats.size() ; i ++){
				lstChats[i].CaseId = lstCase[i].Id;
			}
        } 
    }

    public void updateCases(Map<Id, MessagingSession> mapChats, Map<Id,Id> mapCasesChat){

        List<Case> lstCase = new List<Case>();
        Map<Id,MessagingChannel> mapIdmChannel = new Map<Id,MessagingChannel>();
        Map<Id,Id> mapIdId = new Map<Id,Id>();

        List<MessagingChannel> lstMessagingChannelEmpresas = [SELECT Id FROM MessagingChannel WHERE DeveloperName =: Label.DEG_MsgChannelNameEmpresas LIMIT 1];
        
        // Get the object type of the SObject.
        Schema.sObjectType objType = Case.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get('DEG_TipodeDocumento__c').getDescribe().getPickListValues();
        list<String> lstSort = new list<String>();
        // Add these values to the sort list.
        for (Schema.PicklistEntry a : values){
           lstSort.add( a.getValue() );
        }

        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';

        for(Case cs : [
            SELECT Id, OwnerId, DEG_Apellido__c, DEG_Nombre__c, DEG_TipodeDocumento__c, DEG_NumerodeIdentificacion__c, DEG_Celular__c, SuppliedEmail, AccountId
            FROM Case
            WHERE Id IN: mapCasesChat.keySet()
        ])
        {
            cs.DEG_Apellido__c = mapChats.get(mapCasesChat.get(cs.Id)).DEG_ApellidoCliente__c;
			cs.DEG_Nombre__c = mapChats.get(mapCasesChat.get(cs.Id)).DEG_NombreCliente__c;
			cs.DEG_TipodeDocumento__c = lstSort.contains(mapChats.get(mapCasesChat.get(cs.Id)).DEG_TipoDocCliente__c) ? mapChats.get(mapCasesChat.get(cs.Id)).DEG_TipoDocCliente__c : null;
			cs.DEG_NumerodeIdentificacion__c = mapChats.get(mapCasesChat.get(cs.Id)).DEG_NumeroDocCliente__c;
			cs.DEG_Celular__c = mapChats.get(mapCasesChat.get(cs.Id)).DEG_TelefonoCliente__c;
            if (mapChats.get(mapCasesChat.get(cs.Id)).DEG_EmailCliente__c != null && mapChats.get(mapCasesChat.get(cs.Id)).DEG_EmailCliente__c != '') {
            	Pattern MyPattern = Pattern.compile(emailRegex);
				Matcher MyMatcher = MyPattern.matcher(mapChats.get(mapCasesChat.get(cs.Id)).DEG_EmailCliente__c);
                if (MyMatcher.matches()) {
                    cs.SuppliedEmail = mapChats.get(mapCasesChat.get(cs.Id)).DEG_EmailCliente__c;
            	}
            }

            if(
                mapChats.get(mapCasesChat.get(cs.Id)).DEG_NumeroDocCliente__c != null
                && mapChats.get(mapCasesChat.get(cs.Id)).DEG_NumeroDocCliente__c != ''
                && mapChats.get(mapCasesChat.get(cs.Id)).DEG_TipoDocCliente__c != null
                && mapChats.get(mapCasesChat.get(cs.Id)).DEG_TipoDocCliente__c != ''
                && mapChats.get(mapCasesChat.get(cs.Id)).MessagingChannelId == lstMessagingChannelEmpresas[0].Id
                && cs.AccountId == null
                ){
                List<Account> accs = [
                    SELECT Id, AccountNumber, Tipodedocumento__c
                    FROM Account
                    WHERE AccountNumber =: mapChats.get(mapCasesChat.get(cs.Id)).DEG_NumeroDocCliente__c
                    AND Tipodedocumento__c =: mapChats.get(mapCasesChat.get(cs.Id)).DEG_TipoDocCliente__c
                    LIMIT 1];
                if(accs.size() > 0){
                    cs.AccountId = accs[0].Id;
                }
            }

            lstCase.add(cs);
        }

        if(lstCase.size() > 0) update lstCase;

    }

}