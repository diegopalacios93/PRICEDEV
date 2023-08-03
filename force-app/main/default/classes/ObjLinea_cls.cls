/************************************************************************************
Desarrollado por:        Avanxo Colombia
Autor:                   Sergio Ortiz
Proyecto:                ETB
Descripción:             Clase con la logica para la creacion objetos con la respuesta
                         del Json entregado por el Web Service
                         
Cambios (Versiones)
-------------------------------------
No.        Fecha        Autor                         Descripción
------  ----------  --------------------            ---------------
1.0     22-09-2015   Sergio Ortiz                   Creación de la clase.
**************************************************************************************/
public with sharing class ObjLinea_cls {

    public List<cls_service_particulars> service_particulars;
    public Integer numero_tramite;
    
    //Metodo para crear objetos con los datos de la respuesta del Json
    public class cls_service_particulars {
        public String connection_number;    
        public String subscriber_id;    
        public String billing_entity_id;
        public String parent_id;    
        public String billable_parent_id;
        public String bill_run_State;   
        public String lsp_name; 
        public String service_id;   
        public String external_service_id;
        public String rate_plan_name;
        public String rate_plan_name_cupo;
        public String error_code;
        public String error_description;
        public String fd;
        public String feat_nm_ld;
        
    }

    //Metodo para deserializar el Json    
    public static ObjLinea_cls parse(String json){
        return (ObjLinea_cls) System.JSON.deserialize(json, ObjLinea_cls.class);
    }
}