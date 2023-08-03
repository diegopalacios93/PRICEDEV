global class ObtenerTokenWrapper {

    public WSRequestHeader WSRequestHeader;
    public WSRequestBody WSRequestBody;

    global class WSRequestHeader{
        public System1 System1 {get;set;}
        public Property Property {get;set;}
    }

    global class Property{
        public String name {get;set;}
        public String value {get;set;}
    }

    global class System1{
        public String name {get;set;}
        public String correlationID {get;set;}
        public String processingServer {get;set;}
    }

    global class Audit{
        public String Canal {get;set;}
        public string Id_Device {get;set;}
        public string SO {get;set;}
        public string IP_Address {get;set;}
        public String IP_Latitude {get;set;}
        public String IP_Longitude {get;set;}
        public String WhatsApp_Phone_Number {get;set;}
        public String Facebook_User {get;set;}
        public String Twitter_User {get;set;}
    }

    global class WSRequestBody{
        public String Password {get;set;}
        public String Username {get;set;}
        public Audit Audit {get;set;} 
    }
}