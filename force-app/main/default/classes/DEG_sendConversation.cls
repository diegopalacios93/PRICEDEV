/*
* Desarrollado por: Accenture
* Autor:            Diego Alejandro Rico F
* Proyecto:         ETB - DEG
* Descripción:      Clase encargada de hacer el envío del correo con copia de la mensajería de la conversación.
* Clase de prueba:  DEG_sendConversation_tst
* Cambios (Versiones)
* -----------------------------------------------------------------------------------
* No.  Fecha       	Autor                   			Descripción
* ---- ----------- 	----------------------- 			------------------------------------------
* 1.0  10-Dic-2021  	Diego Alejandro Rico F. (DARF)   	Creación de la clase
**/
public with sharing class DEG_sendConversation {
    public static string strFileName=system.Label.DEG_ConversationCopyFileName;
    public static string strBodyEmail=system.Label.DEG_BodyMailCopyOfConversation;
    public static id idCaseEmailBackup;
    
    @InvocableMethod
    public static void SendMsj(list<id> idCOnversation) {
        WrapperData objwpDm= new WrapperData();
        WrapperData objwp= new WrapperData();
        List<LiveChatTranscript> lstLct = new List<LiveChatTranscript>();
        List<MessagingSession> lstMs = new List<MessagingSession>();
        idCaseEmailBackup=getCaseEmailBackup();
        objwpDm=GetMessagingSession(idCOnversation);
        objwp=getInfoObj(objwpDm.lstMs,objwpDm.lstLct);
        sendEmail(objwp);
    }
    
    /***********************************
Metodo : sendEmail
Autor: Diego Alejandro Rico(DARF)
Descripción: Método encargado de iterar el wrapper y solicitar el envio de correos.
params: Objwp: wrapper encargado de recopilar toda la información necesaria para le envió de mensajes 
return: void
*************************************/
    public static void sendEmail(WrapperData objwp){
        list<case> lstcase= new list<case>(); 
        datetime myDateTime = datetime.now();
        if(objwp.lstLct!=null){
        }
        else if(objwp.lstMs!=null){
            for(id idmsj :objwp.msgMap.keyset()){
                case objcase = new case(id=objwp.msgMap.get(idmsj).caseid,DEG_timeSentConversationCopy__c=myDateTime);
                lstcase.add(objcase);
                string emailoMsj= objwp.msgMap.get(idmsj).DEG_EmailCliente__c;
                string bodyMsj= objwp.msgMap.get(idmsj).DEG_Body__c;
                string idcaseMsj=  objwp.msgMap.get(idmsj).CaseId!=null?objwp.msgMap.get(idmsj).CaseId:idCaseEmailBackup;
                sendTemplate(strFileName,emailoMsj,strBodyEmail,bodyMsj,idcaseMsj);
            }
        }
        update lstcase;
    }
    
    
    
    /***********************************
Metodo : getInfoObj
Autor: Diego Alejandro Rico(DARF)
Descripción: Método encargado de consultar y crear la infromacion necesaria según el tipo de mensajería para el envío del correo.
params: idConversation: lista de id para el envío crear el Wrapper con la información para enviar los correos 
return: WrapperData
*************************************/
    public static WrapperData getInfoObj(List<MessagingSession> lstMs, List<LiveChatTranscript> lstLct){
        string name;
        string objName;
        WrapperData objwp= new WrapperData();
        List<ConversationEntry> lstCe = new List<ConversationEntry> ();
        Map<Id, MessagingSession> msgMap = new Map<Id, MessagingSession>();
        if(lstMs!=NUll&&lstMs.size()>0){
            for (MessagingSession msj :lstMs)    
            {
                if(msj.MessagingEndUser.MessageType=='WhatsApp'){
                    msj.DEG_Body__c = '';
                    msgMap.put(msj.Id, msj);
                }
            }
            lstCe=[SELECT ConversationId,CreatedDate,ActorName, Message  FROM ConversationEntry
                   WHERE ConversationId IN :msgMap.keySet()
                   ORDER BY CreatedDate ASC];
            for (ConversationEntry conversMsj :lstCe){                                     
                if (msgMap.containsKey(conversMsj.ConversationId)){
                    if (conversMsj.Message != ' ' && conversMsj.Message != null && conversMsj.Message != 'null'){
                        string actor=conversMsj.actorname.contains('whatsapp:+5')?'Tu':'ETB';
                        msgMap.get(conversMsj.ConversationId).DEG_Body__c = msgMap.get(conversMsj.ConversationId).DEG_Body__c + ' <br> <br>' +conversMsj.CreatedDate+' | '+actor+' :<br>'+ conversMsj.Message;
                    }
                }
            }
            objwp.lstCe=lstCe;
            objwp.lstMs=lstMs;
            objwp.msgMap=msgMap;
        }
        else if(lstLct!=NUll&&lstLct.size()>0){
            
            objwp.lstCe=lstCe;
            
        }
        return objwp;
    } 
    
    
    /***********************************
Metodo : getCaseEmailBackup
Autor: Diego Alejandro Rico(DARF)
Descripción: Método encargado de consultar o crear el caso de backup necesario para enviar el correo, si la conversación no tiene asociado un caso.  
params:  
return: id : id del caso de backup.
*************************************/
    public static id getCaseEmailBackup(){
        id idcase;
        string strSubjectCase=system.Label.DEG_CaseSubjectSentConversationCopy;
        case lstCase =[SELECT id FROM case WHERE subject =:strSubjectCase limit 1];
        if(lstCase.id!=null){
            return lstCase.id;
        }
        else{
            id idAccount =[SELECT id FROM account WHERE name =:system.label.DEG_NombreCuentaOutbound].id;
            case objcase= new case(AccountId=idAccount,Subject=strSubjectCase);
            insert objcase;
            return objcase.id;
        }
    }
    
    
    /***********************************
Metodo : attachementBuilder
Autor: Diego Alejandro Rico(DARF)
Descripción: Método encargado de crear el parámetro que representa el archivo que se adjunta al correo.
params: fileName: nombre del archivo que se adjunta, emailHtml: body del archivo adjunto
return: Messaging.EmailFileAttachment :archivo para adjuntar al correo
*************************************/
    public static Messaging.EmailFileAttachment attachementBuilder(string fileName,string emailHtml)
    {
        system.debug('attachementBuilder');
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName(fileName);
        attach.setInline(true);
        String body=emailHtml;
        attach.Body = Blob.toPDF(body);
        return attach;
    }
    
    
    /***********************************
Metodo : sendTemplate
Autor: Diego Alejandro Rico(DARF)
Descripción: Método encargado de enviar el correo y adjuntar el archivo con copia de la conversación.
params: nameFileString:nombre del archivo adjunto, contactoEmail: email al que se dirige el correo, 
        message: cuerpo del correo, attachBody: cuerpo del archivo adjunto, idWhat:caso relacionado al correo.
return: void
*************************************/
    public static void sendTemplate (string nameFile,String contactoEmail,String message,string attachBody,id idWhat){
        system.debug('sendTemplate 1 ContactoEmail:'+ContactoEmail);
        List<String> EmailIds = new List<String>();
        EmailIds.add(ContactoEmail);    
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1=attachementBuilder('copia de conversación.pdf',attachBody);
        system.debug('sendTemplate 5');
        email.setSubject( 'ETB- conversación' + String.valueOf(DateTime.now()));
        //email.setTargetObjectId(IdWhat);
        email.setWhatId(IdWhat);
        email.setToAddresses(EmailIds);
        email.setPlainTextBody(message);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        if(!Test.isRunningTest())Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});       
    }  

    
    /***********************************
Metodo : GetMessagingSession
Autor: Diego Alejandro Rico(DARF)
Descripción: Método encargado de consultar las conversaciones.
params: idCase:
return: WrapperData
*************************************/
    public static WrapperData GetMessagingSession(list<id> idCase){
        WrapperData objWrapper =new WrapperData();
        List<MessagingSession> lstMs=[SELECT Id,DEG_NombreCliente__c,DEG_Body__c,DEG_EmailCliente__c,CaseId,MessagingEndUser.MessageType 
                                        FROM MessagingSession WHERE CaseId =:idCase[0]];
        system.debug(lstMs);                                
        List<LiveChatTranscript>lstLct=[SELECT Id, Name, CreatedDate, LastModifiedDate, Body, CaseId, AccountId, LiveChatDeploymentId, LiveChatButtonId, SkillId
                                        FROM LiveChatTranscript  WHERE CaseId  =:idCase[0]
                                        ORDER BY CreatedDate ASC];
                                        system.debug(lstLct);                                
        if(lstLct!=null&&lstLct.size()>0){
            objWrapper.lstLct=lstLct;
        }
        else if(lstMs!=null&&lstMs.size()>0){
            objWrapper.lstMs=lstMs;
        }

        return objWrapper;
    } 
    
    
    public class WrapperData{
        public string nameObj {get;set;}
        public List<LiveChatTranscript> lstLct {get;set;}
        public List<MessagingSession> lstMs {get;set;}
        public List<ConversationEntry> lstCe {get;set;}
        public Map<Id, MessagingSession> msgMap {get;set;}
    }
}