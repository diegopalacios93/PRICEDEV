/**
* @description       :
* @author            : Harlinsson Chavarro (HCH)
* @group             :
* @last modified on  : 12-02-2021
* @last modified by  : j.martinez.mercado
* Modifications Log
* Ver   Date         Author                      Modification
* 1.0   03-06-2021   Harlinsson Chavarro (HCH)   Initial Version
* 1.1   03-29-2021   Javier Tibamoza (JATC)   Se agregó consulta al Trasncript
**/
public without sharing class DEG_HelperLiveChatTranscript_cls {
    public DEG_HelperLiveChatTranscript_cls() {
    }
    

    public void manageBody(List<LiveChatTranscript> lstChat) {
        System.debug('HELPER manageBody');
        List<String> talkingLst = new List<String>();
        for (LiveChatTranscript chat : lstChat) {
            manageJSON(chat.Body, chat, talkingLst);  
        }
    }
    
    public void manageJSON( String sBody, LiveChatTranscript chat, List<String> talkingLst ) {
        System.debug('HELPER manageJSON');
        System.debug('##sBody: ' + sBody);
        if(!chat.DEG_ManageBody__c){
            if( sBody != null ){
                String strUnEscapeCml = sBody.unescapeXml();
                List<String> lStringSplitAlignCenter = strUnEscapeCml.split('<p align="center">');
                List<String> lStringSplitBr = ( lStringSplitAlignCenter.size() > 1 ) ? lStringSplitAlignCenter[1].split('<br>') : new List<String>();
                if (lStringSplitAlignCenter.size() > 2){
                    for(Integer i = 2 ; i < lStringSplitAlignCenter.size() ; i ++){
                        lStringSplitBr.add(lStringSplitAlignCenter[i]); 
                    }
                }
                Integer posStart;
                Integer posEnd;
                String cadena;
                String cadena2;
                String aux;
                List<String> auxLst = new List<String>();
                //Recorro cada element de la conversacion entre agente y visitor
                String mensajeElm = '';
                String concatenate;
                for( String elemento : lStringSplitBr ){
                    System.debug('##elemento' + elemento);
                    if (elemento.contains('[{')) {
                        posStart = elemento.IndexOf('[{');
                        posEnd = elemento.lastIndexOf('}]');
                        cadena = elemento.substring(posStart, posEnd + 2);
                        cadena = cadena.contains(')') ? cadena.substringAfter(')') : cadena; List<DEG_ConsumeOrquestadorHelper_cls.wrapMensaje> objMensajeLst = (List<DEG_ConsumeOrquestadorHelper_cls.wrapMensaje>) JSON.deserialize(cadena, List<DEG_ConsumeOrquestadorHelper_cls.wrapMensaje>.class );
                        for( DEG_ConsumeOrquestadorHelper_cls.wrapMensaje mensaje : objMensajeLst ) {
                            //mensajeElm = (mensaje.mensaje != null && (mensaje.mensaje.trim() != '' || mensaje.mensaje.trim() != ':' )) ? mensaje.mensaje.trim() : null;
                            mensajeElm = mensaje.mensaje != null ? mensaje.mensaje.trim() : null;
                            talkingLst = addRecord( talkingLst, mensaje, mensajeElm );
                        }
                    } else {
                        List<String> lstElm = new List<String>();
                        if( elemento.contains(')') ){
                            if ( !elemento.contains('</p>') ){
                                cadena = elemento.substringAfter(')');
                                cadena2 = cadena.substringAfter(':').trim();
                                if (cadena2 != '' && cadena2 != ':' && cadena2 != null && cadena2 != 'null' && cadena2 != '</p>' ) {
                                    lstElm.add(cadena);
                                    for(String elm : lstElm){
                                        if ( elm != '' && elm != ':' && elm != null && elm != 'null' ) {
                                            talkingLst.add(elm.trim());
                                        }
                                    }
                                }    
                            } else {
                                if ( elemento.contains('<br>') ) {
                                    aux = elemento.split('</p>')[1];
                                    auxLst = aux.split('<br>');
                                    System.debug('##testing: ' + auxLst);
                                    for(String elm : auxLst){
                                        if (elm.contains(')')) {
                                            aux = elm.substringAfter(')').trim();
                                        }else{
                                            aux = elm;
                                        }
                                        if (aux.contains(':')){
                                            if ( aux.substringAfter(':').trim() != '' && aux.substringAfter(':').trim() != ':' && aux.substringAfter(':').trim() != null && aux.substringAfter(':').trim() != 'null' ) {
                                                talkingLst.add(aux);
                                            }
                                        }else{
                                            if( aux.trim() != '' && aux != null ){
                                                talkingLst.add(aux);
                                            }
                                        }                                  
                                    }
                                }
                            }
                        } else {
                            if ( !elemento.contains('</p>') ){
                                System.debug('##testingAbajo: ' + elemento);
                                aux = elemento.trim();
                                if ( aux.substringAfter(':').trim() != '' && aux.substringAfter(':').trim() != ':' && aux.substringAfter(':').trim() != null && aux.substringAfter(':').trim() != 'null' ) {
                                    talkingLst.add(aux);
                                }
                            }
                        }
                    }
                }
                Integer j = 0;
                while (j < talkingLst.size()) {
                    if( talkingLst.get(j) == null || talkingLst.get(j).contains('[]') ){
                        talkingLst.remove(j);
                    }else{
                        j++;
                    }
                }
                // system.debug('***getCpuTime()' + Limits.getCpuTime());
            }
        }
        if(chat.DEG_ManageBody__c == true){
            chat.DEG_ManageBody__c = false;
        }
        if( talkingLst.size() > 0 ) {
            chat.Body = String.join(talkingLst, ' <br> ');
        }
    }
    /**
     * @description: 
	*/
    @TestVisible
    private List<String> addRecord( List<String> talkingLst, DEG_ConsumeOrquestadorHelper_cls.wrapMensaje mensaje, String mensajeElm ){
        System.debug('HELPER addRecord');
        String concatenate = '';
        if (mensaje.esMsn == true) {
            if(mensajeElm != null ){
                talkingLst.add(mensajeElm);
            }
        }
        if (mensaje.esBtn == true) {
            concatenate = '';
            for ( DEG_ConsumeOrquestadorHelper_cls.wrapBoton btn : mensaje.lBotones ) {
                concatenate += btn.texto + ';';
            }
            talkingLst.add(concatenate);
            talkingLst.add(mensajeElm);
        }
        if (mensaje.esBtnLink == true) {
            concatenate = '';
            for( DEG_ConsumeOrquestadorHelper_cls.wrpBtnEnlace btnlink : mensaje.btnLinkLst ) {
                concatenate += btnlink.texto + ';';
            }
            talkingLst.add(concatenate);
            talkingLst.add(mensajeElm);
        }
        if (mensaje.esVideo == true) {
            concatenate = '';
            for( DEG_ConsumeOrquestadorHelper_cls.wrapVideo video : mensaje.videoLst ) {
                concatenate += video.texto + ';';
            }
            talkingLst.add(concatenate);
            talkingLst.add(mensajeElm);
        }
        if (mensaje.esImage == true) {
            concatenate = '';
            for( DEG_ConsumeOrquestadorHelper_cls.wrpImage image : mensaje.imageLst ) {
                concatenate += image.texto + ';';
            }
            talkingLst.add(concatenate);
            talkingLst.add(mensajeElm);
        }
        System.debug('HELPER addRecord - return talkingLst: ' + talkingLst);
        return talkingLst;
    }
    /**
    * @description: Método que retorna el último LiveChatTranscript por client_session_id
    * @param: String client_session_id
	*/
    public static List<LiveChatTranscript> getLiveChatTranscript(String client_session_id){
        System.debug('HELPER getLiveChatTranscript');
        List<LiveChatTranscript> lLiveChatTranscript = [
            SELECT Id, DEG_SessionIdWatson__c, DEG_ClientSessionWatsonId__c,DEG_TokenWatson__c
            FROM LiveChatTranscript
            WHERE DEG_ClientSessionWatsonId__c =: client_session_id 
        	ORDER BY CreatedDate DESC NULLS FIRST 
            LIMIT 1];
            System.debug('##lLiveChatTranscript '+lLiveChatTranscript);
            System.debug('HELPER getLiveChatTranscript - lLiveChatTranscript: ' + lLiveChatTranscript);
        if( lLiveChatTranscript.size() > 0 ){
            return lLiveChatTranscript;
        }
        return null;
    } 


    /**
    * Retorna el último MessagingSession por client_session_id
    * @param String sessionId
    * @return List<MessagingSession>
	*/
    public static List<MessagingSession> getMessagingSession(String sessionId){
        System.debug('HELPER getMessagingSession');
        List<MessagingSession> lstMessagingSession = [
            SELECT Id, DEG_SessionIdWatson__c, DEG_ClientSessionWatsonId__c,DEG_TokenWatson__c
            FROM MessagingSession
            WHERE DEG_ClientSessionWatsonId__c =: sessionId 
        	ORDER BY CreatedDate DESC NULLS FIRST 
            LIMIT 1];
        
        System.debug('HELPER getMessagingSession - lstMessagingSession: ' + lstMessagingSession);
        if(lstMessagingSession.size() > 0) {return lstMessagingSession;}
        return null;
    }
 /**
    * Cambia el ownerIde de los casos, cuando los chats son aceptados por el agente.
    * @param Map<Id,LiveChatTranscript> mapChats, Map<Id,Id> mapCasesChat
    * @return void
	*/
    public void setOwner(Map<Id,LiveChatTranscript> mapChats, Map<Id,Id> mapCasesChat){
        System.debug('HELPER setOwner');
        Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();

        List<Case> lstCase = new List<Case>();
 
        for(Case cs : [
            SELECT Id, OwnerId, Status, DEG_GestionadoPor__c,RecordTypeId
            FROM Case
            WHERE Id IN: mapCasesChat.keySet()
        ]) {
            cs.OwnerId = mapChats.get(mapCasesChat.get(cs.Id)).OwnerId;
            cs.Status = cs.RecordTypeId != ventasRTId ? 'Abierto' : cs.Status;
            cs.DEG_GestionadoPor__c = 'Agente';
            
            lstCase.add(cs);
        }
        System.debug('HELPER setOwner - lstCase: ' + lstCase);
        if(lstCase.size() > 0) update lstCase;
        
    }

    
    public void createCases(List<LiveChatTranscript> lstChats, Map<Id,LiveChatTranscript> mapNewChats){
        System.debug('HELPER createCases');
        System.debug('HELPER createCases - lstChats: ' + lstChats);
        System.debug('HELPER createCases - mapNewChats: ' + mapNewChats);
        Id masivoRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId();
        Id empresaRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CASO_PQR').getRecordTypeId();
        Id ventasRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_VENTAS').getRecordTypeId();
        User usr = [SELECT Id, username, profileId FROM User WHERE username LIKE 'autoproc%' LIMIT 1];
        List<String> buttonLst = new List<String>{
            'DEG_ETBServicioClienteEmpresas',
            'DEG_ETBServicioClienteMasivo',
            'DEG_ETB_Servicio_al_Cliente_MiPymes',
            'DEG_ETBVentasHogar',
            'DEG_ETBVentasMoviles',
            'DEG_ETBVentasNegocios',
            'DEG_ETBAppMobile'
        };
        System.debug('usr:: '+usr);
        System.debug('masivoRTId:: '+masivoRTId);
        System.debug('buttonLst:: '+buttonLst);

        Map<Id,LiveChatButton> LiveButtonsMap = new Map<Id,LiveChatButton>( [SELECT Id, DeveloperName
                                                                            FROM LiveChatButton
                                                                            WHERE DeveloperName IN :buttonLst LIMIT 7] );
        system.debug('LiveButtonsMap -----> '+LiveButtonsMap);
        List<Case> lstCase = new List<Case>();
		Case cs;
        Map<Id,Case> mapChatCase = new Map<Id,Case>();
        Map<String, LiveChatTranscript> mapaDashboard = new Map<String, LiveChatTranscript>();
        Set<String> canalesDashboard = new Set<String>();
        for(LiveChatTranscript lct : lstChats){
            if( LiveButtonsMap.get(lct.LiveChatButtonId).DeveloperName == 'DEG_ETBAppMobile' ){
                mapaDashboard.put(lct.DEG_TelefonoCliente__c, lct);
                canalesDashboard.add(lct.DEG_Channel__c);
            } else{
                system.debug('lct -----> '+lct);
                cs = new Case();
                if( LiveButtonsMap.get(lct.LiveChatButtonId).DeveloperName == 'DEG_ETB_Servicio_al_Cliente_MiPymes' ){
                    System.debug('HELPER createCases - DeveloperName DEG_ETB_Servicio_al_Cliente_MiPymes');
                    cs.RecordTypeId = masivoRTId;
                    cs.DEG_Apellido__c = lct.DEG_ApellidoCliente__c;
                    cs.DEG_Nombre__c = lct.DEG_NombreCliente__c;
                    cs.DEG_TipodeDocumento__c = lct.DEG_TipoDocCliente__c;
                    cs.DEG_NumerodeIdentificacion__c = lct.DEG_NumeroDocCliente__c;
                    cs.DEG_Celular__c = lct.DEG_TelefonoCliente__c;
                    cs.SuppliedEmail = lct.DEG_EmailCliente__c;
                    cs.Origin = 'Canal Web Chat MiPymes';
                    cs.Status = 'Resuelto';
                    cs.DEG_GestionadoPor__c = 'Bot';
                    cs.DEG_Segmento__c = label.DEG_Segmento_MiPymes;
                    lstChats[0].DEG_Channel__c = 'Masivo';
                    system.debug('cs -----> '+cs);
                }
                if( LiveButtonsMap.get(lct.LiveChatButtonId).DeveloperName == 'DEG_ETBServicioClienteMasivo' ){
                    System.debug('HELPER createCases - DeveloperName DEG_ETBServicioClienteMasivo');
                    cs.RecordTypeId = masivoRTId;
                    cs.DEG_Apellido__c = lct.DEG_ApellidoCliente__c;
                    cs.DEG_Nombre__c = lct.DEG_NombreCliente__c;
                    cs.DEG_TipodeDocumento__c = lct.DEG_TipoDocCliente__c;
                    cs.DEG_NumerodeIdentificacion__c = lct.DEG_NumeroDocCliente__c;
                    cs.DEG_Celular__c = lct.DEG_TelefonoCliente__c;
                    cs.SuppliedEmail = lct.DEG_EmailCliente__c;
                    cs.Origin = 'Canal Web Chat Hogares';
                    cs.Status = 'Resuelto';
                    cs.DEG_Segmento__c = label.DEG_Segmento_Masivo;
                    cs.DEG_GestionadoPor__c = 'Bot';
                    lstChats[0].DEG_Channel__c = 'Masivo';
                } else if(LiveButtonsMap.get(lct.LiveChatButtonId).DeveloperName == 'DEG_ETBServicioClienteEmpresas'){
                    System.debug('HELPER createCases - DeveloperName DEG_ETBServicioClienteEmpresas');
                    cs.RecordTypeId = empresaRTId;
                    cs.Origin = 'Canal Web Chat';
                    cs.Status = 'Resuelto';
                    cs.DEG_GestionadoPor__c = 'Bot';
                    lstChats[0].DEG_Channel__c = 'Empresas';
                } else if(
                    LiveButtonsMap.get(lct.LiveChatButtonId).DeveloperName == 'DEG_ETBVentasHogar' ||
                    LiveButtonsMap.get(lct.LiveChatButtonId).DeveloperName == 'DEG_ETBVentasMoviles' || 
                    LiveButtonsMap.get(lct.LiveChatButtonId).DeveloperName == 'DEG_ETBVentasNegocios'
                ) {
                    System.debug('HELPER createCases - DeveloperName DEG_ETBVentasHogar/Moviles/Negocios');
                    // String origen = 'DEG_' +lct.DEG_Cola__c	.replaceAll('\\s+', '') + 'WebChat';
                    // List<Group> cola = [SELECT Id, Name  FROM Group 
                    //             WHERE Type = 'Queue' AND DeveloperName =: origen LIMIT 1];
                    cs.RecordTypeId = ventasRTId;
                    cs.DEG_OrigendelaVenta__c = lct.DEG_OrigendelaVenta__c;
                    cs.DEG_Celular__c = lct.DEG_TelefonoCliente__c;
                    cs.DEG_IDdeBacklanding__c = lct.DEG_IDdeBacklanding__c;
                    cs.DEG_Campana__c = lct.DEG_Campana__c;
                    cs.DEG_Fuente__c = lct.DEG_Fuente__c;
                    cs.DEG_Medio__c = lct.DEG_Medio__c;
                    cs.DEG_Oferta__c = lct.DEG_Oferta__c;
                    //cs.DEG_Telefono__c = lct.DEG_Telefono__c;
                    //cs.DEG_TelefonoETB__c   = lct.DEG_Telefono_ETB__c;
                    cs.DEG_EmailCliente__c = lct.DEG_EmailCliente__c;
                    cs.DEG_FechaRegistroLead__c = lct.DEG_FechaRegistroLead__c;
                    cs.DEG_HoraRegistroLead__c = lct.DEG_HoraRegistroLead__c;
                    cs.Origin = 'Canal Web Ventas';
                    cs.Status = 'En Proceso';
                    cs.DEG_NombredelaCola__c = lct.DEG_NombredelaCola__c;
                    cs.DEG_IdCola__c = lct.DEG_IdCola__c;
                }
                cs.OwnerId = usr.Id;
                System.debug('HELPER createCases cs.OwnerId: ' + cs.OwnerId);
                System.debug('HELPER createCases cs.DEG_GestionadoPor__c: ' + cs.DEG_GestionadoPor__c);
                System.debug('HELPER createCases cs.Origin: ' + cs.Origin);
                System.debug('HELPER createCases cs.RecordTypeId: ' + cs.RecordTypeId);
                System.debug('HELPER createCases cs.DEG_OrigendelaVenta__c: ' + cs.DEG_OrigendelaVenta__c);
                System.debug('HELPER createCases cs.DEG_IDdeBacklanding__c: ' + cs.DEG_IDdeBacklanding__c);
                System.debug('HELPER createCases cs.DEG_Campana__c: ' + cs.DEG_Campana__c);
                System.debug('HELPER createCases cs.DEG_Fuente__c: ' + cs.DEG_Fuente__c);
                System.debug('HELPER createCases cs.DEG_Medio__c: ' + cs.DEG_Medio__c);
                System.debug('HELPER createCases cs.DEG_Oferta__c: ' + cs.DEG_Oferta__c);
                //System.debug('HELPER createCases cs.DEG_Oferta__c: ' + cs.DEG_Telefono__c);
                //System.debug('HELPER createCases cs.DEG_Oferta__c: ' + cs.DEG_TelefonoETB__c);
                System.debug('HELPER createCases cs.DEG_FechaRegistroLead__c: ' + cs.DEG_FechaRegistroLead__c);
                System.debug('HELPER createCases cs.DEG_HoraRegistroLead__c: ' + cs.DEG_HoraRegistroLead__c);
                System.debug('HELPER createCases cs.Origin: ' + cs.Origin);
                System.debug('HELPER createCases cs.Status: ' + cs.Status);
                System.debug('HELPER createCases cs.DEG_NombredelaCola__c: ' + cs.DEG_NombredelaCola__c);
                System.debug('HELPER createCases cs.DEG_IdCola__c: ' + cs.DEG_IdCola__c);
            }
		}
        System.debug('HELPER createCases - lstChats - Despues del FOR: ' + lstChats);
        //Inicio de lógica para live chat transcripts asociados al canal de Dashboard
        if(mapaDashboard.size()>0){
            //Se obtienen las colas a las cuáles se asignarán las conversaciones según sea el motivo paso agente
            List<Group> colas = [SELECT ID, DeveloperName FROM GROUP WHERE Type='Queue' AND 
                                    (DeveloperName='DEG_SoporteTecnicoChat' OR DeveloperName='Servicio')];
            Map<String, Id> mapaColas = new Map<String, Id>();
            for(Group grupo : colas){
                mapaColas.put(grupo.DeveloperName, grupo.Id);
            }
            //Se consultan posibles casos que estén asociados al número contenido en la conversación
            List<Case> casos = [SELECT Id, DEG_Celular__c, Status FROM Case 
                                WHERE DEG_Celular__c IN: mapaDashboard.keySet() AND RecordTypeId =: masivoRTId AND
                                Origin IN :canalesDashboard];
            //Se crea un mapa de casos para saber si existen casos asociados a un determinado número de celular
            Map<String, Case> mapaCasos = new Map<String, Case>();
            for(Case caso : casos){
                mapaCasos.put(caso.DEG_Celular__c, caso);
            }
            List<Case> casosUpsert = new List<Case>();
            for(LiveChatTranscript chat : mapaDashboard.values()){
                //Se valida a cuál cola debe pertenecer la conversación según el motivo paso agente
                if(chat.DEG_MotivoAgente__c=='soporte técnico' || chat.DEG_MotivoAgente__c=='wifi' || chat.DEG_MotivoAgente__c=='diagnóstico de red'){
                   chat.DEG_IdCola__c = mapaColas.get('DEG_SoporteTecnicoChat');
                } else{
                   chat.DEG_IdCola__c = mapaColas.get('Servicio'); 
                }
                Case caso = mapaCasos.get(chat.DEG_TelefonoCliente__c);
                /*Se valida si el número de la conversación ya tiene un caso asociado para hacer su creación o 
                actualización*/
				if(caso==null){
                    Case objCase = new Case();
                    objCase.RecordTypeId = masivoRTId;
                    objCase.DEG_Celular__c = chat.DEG_TelefonoCliente__c;
                    objCase.OwnerId = chat.DEG_IdCola__c;
                    objCase.Status = 'En Proceso';
                    objCase.DEG_Nombre__c = chat.DEG_NombreCliente__c;
            		objCase.DEG_Apellido__c = chat.DEG_ApellidoCliente__c;
                    objCase.Origin = chat.DEG_Channel__c;
            		objCase.DEG_GestionadoPor__c = 'Bot';
                    casosUpsert.add(objCase);                        
                }
                else {
                    caso.OwnerId = chat.DEG_IdCola__c;
                    caso.Status = 'En Proceso';
                    caso.DEG_GestionadoPor__c = 'Bot';
                    chat.CaseId = caso.Id;
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
                    LiveChatTranscript chat = mapaDashboard.get(caso.DEG_Celular__c);
                    chat.CaseId = caso.Id;
                }
            }
        } else{
            try{        
                Insert cs;
                lstChats[0].CaseId = cs.Id;
            }
            catch(Exception e){
                System.debug('##ERROR' + e);
                System.debug('##ERROR Line' + e.getLineNumber());
            }
        }
    }


    public void updateCases(Map<Id,LiveChatTranscript> mapChats, Map<Id,Id> mapCasesChat){
        System.debug('HELPER updateCases');
        System.debug('HELPER updateCases - mapChats' + mapChats);
        System.debug('HELPER updateCases - mapCasesChat' + mapCasesChat);

        User usr = [SELECT Id, username, profileId FROM User WHERE username LIKE 'autoproc%' LIMIT 1];

        List<Case> lstCase = new List<Case>();
        Map<String, List<Case>> mapCase = new Map<String, List<Case>>();

        for(Case cs : [
            SELECT Id, OwnerId, DEG_Apellido__c, DEG_Nombre__c, DEG_TipodeDocumento__c, DEG_NumerodeIdentificacion__c, DEG_Celular__c, SuppliedEmail,AccountId
            FROM Case
            WHERE Id IN: mapCasesChat.keySet()
        ])
        {
            cs.DEG_Apellido__c = mapChats.get(mapCasesChat.get(cs.Id)).DEG_ApellidoCliente__c;
			cs.DEG_Nombre__c = mapChats.get(mapCasesChat.get(cs.Id)).DEG_NombreCliente__c;
			cs.DEG_TipodeDocumento__c = mapChats.get(mapCasesChat.get(cs.Id)).DEG_TipoDocCliente__c;
			cs.DEG_NumerodeIdentificacion__c = mapChats.get(mapCasesChat.get(cs.Id)).DEG_NumeroDocCliente__c;
			cs.DEG_Celular__c = mapChats.get(mapCasesChat.get(cs.Id)).DEG_TelefonoCliente__c;
			cs.SuppliedEmail = mapChats.get(mapCasesChat.get(cs.Id)).DEG_EmailCliente__c;

            if(
                mapChats.get(mapCasesChat.get(cs.Id)).DEG_NumeroDocCliente__c != null
                && mapChats.get(mapCasesChat.get(cs.Id)).DEG_NumeroDocCliente__c != ''
                && mapChats.get(mapCasesChat.get(cs.Id)).DEG_TipoDocCliente__c != null
                && mapChats.get(mapCasesChat.get(cs.Id)).DEG_TipoDocCliente__c != ''
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
        System.debug('HELPER updateCases lstCase' + lstCase);
        if(lstCase.size() > 0){
            update lstCase;
        }
        
    }

    public void setStatusResuelto(List<Id> idsCases) {
        System.debug('HELPER setStatusResuelto');
        List<Case> caseLst = [SELECT Id, Status FROM Case WHERE Id IN: idsCases AND Status != 'Resuelto'];
        System.debug('HELPER setStatusResuelto caseLst: ' + caseLst);
        for(Case cs: caseLst) {
            cs.Status = 'Resuelto Automatico';
        }
        update caseLst;
    }
}