/**
 * @description       : Wrapper para capturar información de las respuesta del orquestador
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-24-2022
 * @last modified by  : j.martinez.mercado@accenture.com
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   01-14-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   04-26-2022   Alejandro Peña T                     Add enviroment attribute
**/
public class DEG_WrapperJSONBot_cls {
    public DEG_WrapperJSONBot_cls() {}

  
    //fot attribute of context in Json

    public class context {
      
    }
    //New Arquictecture Login
    public class rptaLogin {
        public responseLogin[] data {get;set;} 
        public meta responseCodes {get;set;}     
    }
    public class responseLogin {
        public String user {get;set;}
        public String token {get;set;}
        public String expiration {get;set;}     
    }
    //New Arquictecture SessionId
    public class responseSessionId {
        public rptaSessionId data {get;set;} 
        public responseMeta  meta {get;set;}     
    }
    public class rptaSessionId {
        public String session_id {get;set;}
        public String session_date {get;set;}
        public String session_expires {get;set;}     
        public String session_status {get;set;}     
    }
    public class responseMeta {
        public String success {get;set;}
        public String status {get;set;}
        public String message {get;set;}
    }
    
    //Para la respuesta de las conversaciones
     public class responseMessage {
        public respMessage data {get;set;} 
        public meta meta {get;set;}     
    }
    public class respMessage {
        public rptaMessage[] messages {get;set;}     
    }
    public class rptaMessage {
        public String response_type {get;set;}
        public String text {get;set;}
        public calendarDays[] dias_permitidos {get;set;}
        public String typing {get;set;}
        public String id {get;set;}
        public String url {get;set;}
        public String dias {get;set;}
       // public Integer tiempo {get;set;}
        public Boolean closeIframe {get;set;}
    }

    //for saving calendar days event iframe
    public class calendarDays {
        public String fecha;
    }
    //Wrapper Class para la metadata de Watson
    public class meta {
        public String success {get;set;}
        public String status {get;set;}
        public String message {get;set;}
    }

    // Enviroment attribute in Json
    public class enviroment{
        public String case_number {get;set;}
        // public String agente {get; set;}
        // public String canal {get;set;}
        // public String motivo_contacto {get;set;}
        // public String numero_whatsapp {get;set;}
        // public String tipo_documento {get;set;}
        // public String numero_documento {get;set;}
    }

}