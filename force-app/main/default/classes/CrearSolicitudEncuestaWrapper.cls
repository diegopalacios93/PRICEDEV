global class CrearSolicitudEncuestaWrapper {
    
    public WSRequestHeader WSRequestHeader;
    public WSRequestBody WSRequestBody;

    global class WSRequestHeader{
        public System1 System1 {get;set;}
    }

    global class System1 {
        public String name {get;set;}
        public String correlationID {get;set;}
    }

    global class Audit{
        public String Canal {get;set;}
    }

    global class WSRequestBody{
        public String Document_Number {get;set;}
        public String Document_Type {get;set;}
        public String Id {get;set;}
        public String Email_Notify {get;set;}
        public String Name {get;set;}
        public String Phone_Notify {get;set;}
        public String Type_Notify {get;set;}
        public Audit Audit {get;set;}
    }
}