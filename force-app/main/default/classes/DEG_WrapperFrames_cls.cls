/**
* @description       : 
* @author            : Pablo Arrieta
* @group             : 
* @last modified on  : 07-01-2021
* @last modified by  : Pablo Arrieta
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   03-18-2021   Pablo Arrieta   Initial Version
* 2.0   03-19-2021   Felipe Saavedra Addition attributes Wrapper Response & Request for get Segmento_UEN,UEN, Category
**/
public class DEG_WrapperFrames_cls {
    /**
     * @description: DEG_ResponseFrames_ws
	*/
    public class wrapRequestFrame{
       public data data {get;set;}
       public String accion {get;set;}
       public String idConversacion {get;set;}
       public String palabraClave {get;set;}
       public String botId {get;set;}
       public String idMessaging {get;set;}
    }
    /**
     * @description: DEG_ResponseFrames_ws
	*/
    public class data{
        
    }
    
    public class wrapResponseToken {
        public WSResponseHeader WSResponseHeader {get;set;}
        public WSResponseBody WSResponseBody {get;set;}
    }
    
    public class WSResponseHeader {
        public Systema Systema;
        public Service Service;
        public List<Property> lProperty;
        public List<Property> Property;
    }
    
    public class WSResponseBody{
        public String Address {get;set;}
        public List<Addresses> Addresses {get;set;}
        public String Birthday {get;set;} 
        public String Business {get;set;}
        public String Category {get;set;}
        public String City {get;set;}
        public String City_DANE {get;set;}
        public String City_Mongo {get;set;}
        public String Civil_Status {get;set;}
        public List<Contacts> dataContacts {get;set;}
        public List<Contacts> Contacts {get;set;}
        public String Company_Short_Name {get;set;}
        public String Customer_Type {get;set;}
        public String Customer_Tipo {get;set;}
        public String Datacredit_Authorization {get;set;}
        public String Departament {get;set;}
        public String Departament_DANE {get;set;}
        public String Departament_Mongo {get;set;}
        public String District {get;set;}
        public DocumentIssuance Document_Issuance {get;set;}
        public String Document_Number {get;set;}
        public String Document_Type {get;set;}
        public String Document_Tipo {get;set;}
        public String Email {get;set;}
        public Habeas_Data dataHabeas {get;set;}
        public Habeas_Data Habeas_Data {get;set;}
        public String Landline {get;set;}
        public String Location {get;set;}
        public String Mobile_Phone {get;set;}
        public String Name {get;set;}
        public String Names {get;set;}
        public Score_FTTx dataScore {get;set;}
        public Score_FTTx Score_FTTx {get;set;}
        public ScoreLTE Score_LTE {get;set;}
        public String Second_Surname {get;set;}
        public String Segment {get;set;}
        public String Segment_UEN {get;set;}
        public List<Services> dataServices {get;set;}
        public List<Services> Services {get;set;}
        public String State {get;set;}
        public String Surname {get;set;}
        public String UEN {get;set;}
        public Boolean Validation_Code {get;set;}
        public String Value {get;set;}
        
        public string MinutesExpire {get;set;}
        public string SecurityToken {get;set;}
    }

    public class DocumentIssuance {
        public string City {get;set;}
        public string City_Dane {get;set;}
        public string Fecha {get;set;}
        public string Departament {get;set;}
        public string Departament_DANE {get;set;}
    }

    public class ScoreLTE {
        public string Fecha {get;set;}
        public string Score {get;set;}
    }
    
    public class wrapRequestToken {
        public WSRequestHeader WSRequestHeader {get;set;}
        public WSRequestBody WSRequestBody {get;set;}
    }
    
    public class WSRequestHeader {
        public Systema Systema; // Systema --> System
        public List<Property> lProperty;
    }
    
    public class Systema {
        public string name {get;set;}
        public string correlationID {get;set;}
        public string processingServer {get;set;}
    }
    
    public class Service{
        public String status;
        public String responseDate;
        public String responseFecha;
        public String processingServer;
        public List<StatusDetail> statusDetail;
    }
    
    public class Property{}
    
    public class WSRequestBody{
        public string Mail {get;set;}
        public string Username {get;set;}
        public string Password {get;set;}
        public string Type {get;set;}
        public Audit Audit {get;set;}
        public String Document_Type {get;set;}
        public String Document_Number {get;set;}    
        
    }
    
    public class StatusDetail{
        public String errorCode{get;set;}
        public String errorDetailCode{get;set;}
        public String errorMessage{get;set;}
    }
    
    public class Audit{
        public string Canal {get;set;}
        public string Id_Device {get;set;}
        public string SO {get;set;}
        public string IP_Address {get;set;}
        public string IP_Latitude {get;set;}
        public string IP_Longitude {get;set;}
        public string WhatsApp_Phone_Number {get;set;}
        public string Facebook_User {get;set;}
        public string Twitter_User {get;set;}
    }
    
    public class Addresses{
        public String Address {get;set;}
        public String Address_Type {get;set;}
        public String Address_Tipo {get;set;}
        public String Departament {get;set;}
        public Integer Id_wpr {get;set;}   //Id_wpr --> Id
        public String Name {get;set;}
        public Boolean Selected {get;set;}
        public String State {get;set;}
        public String Town {get;set;}        
    }
    
    public class Contacts{
        public String Address {get;set;} 
        public Boolean Authorized {get;set;} 
        public String Document_Number {get;set;} 
        public String Document_Type {get;set;} 
        public String Document_Tipo {get;set;} 
        public Habeas_Data dataHabeas {get;set;} 
        public Habeas_Data Habeas_Data {get;set;} 
        public String Name {get;set;} 
        public String Second_Surname {get;set;} 
        public String Surname {get;set;} 
        public String Email {get;set;} 
        
    }
    
    public class Habeas_Data{
        public String Canal {get;set;} 
        public String Decision {get;set;} 
        public String Decision_Date {get;set;} 
        public String Decision_Fecha {get;set;} 
        public String Id_PQR {get;set;} 
        public String Id_wpr_PQR {get;set;} 
    }
    
    public class Score_FTTx{
        
        public String Fecha {get;set;} // Fecha --> Date
        public Integer Score {get;set;}     
    }
    
    public class Services{
        public String BillingAccount {get;set;} 
        public String Line_Type {get;set;} 
        public String Line_Tipo {get;set;} 
        public String Phone {get;set;} 
        public String Principal_State {get;set;} 
        public String Product {get;set;} 
        public String Technology {get;set;}
        public String Tipo {get;set;} // Tipo --> Type    
    }    
    public class RequestEmpresasLogin{
        public String user {get;set;} 
        public String password {get;set;} 
        public String idConversacion {get;set;} 
    }    
     
}