/**
* @description       : Generated by wsdl2apex SOAP WS
* @author            : Nolvis Sanchez
* @group             :
* @last modified on  : 17-01-2022
* @last modified by  : Nolvis Sanchez
* Modifications Log
* Ver   Date         Author                        Modification
* 1.0   
**/

public class DEG_BacklandingService {
public class ActualizaLeads_element {
public String usuario;
public String contrasena;
public String numeroCelular;
public String idTabla;
public String tipif1;
public String tipif2;
public String tipif3;
public String fechaTipif;
public String horaTipif;
private String[] usuario_type_info = new String[]{'usuario','http://tempuri.org/',null,'0','1','false'};
private String[] contrasena_type_info = new String[]{'contraseña','http://tempuri.org/',null,'0','1','false'};
private String[] numeroCelular_type_info = new String[]{'numeroCelular','http://tempuri.org/',null,'0','1','false'};
private String[] idTabla_type_info = new String[]{'idTabla','http://tempuri.org/',null,'0','1','false'};
private String[] tipif1_type_info = new String[]{'tipif1','http://tempuri.org/',null,'0','1','false'};
private String[] tipif2_type_info = new String[]{'tipif2','http://tempuri.org/',null,'0','1','false'};
private String[] tipif3_type_info = new String[]{'tipif3','http://tempuri.org/',null,'0','1','false'};
private String[] fechaTipif_type_info = new String[]{'fechaTipif','http://tempuri.org/',null,'0','1','false'};
private String[] horaTipif_type_info = new String[]{'horaTipif','http://tempuri.org/',null,'0','1','false'};
private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
private String[] field_order_type_info = new String[]{'usuario','contrasena','numeroCelular','idTabla','tipif1','tipif2','tipif3','fechaTipif','horaTipif'};
}
public class ActualizaLeadsResponse_element {
public String ActualizaLeadsResult;
private String[] ActualizaLeadsResult_type_info = new String[]{'ActualizaLeadsResult','http://tempuri.org/',null,'0','1','false'};
private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
private String[] field_order_type_info = new String[]{'ActualizaLeadsResult'};
}

public class HomeSoap {

ServiciosWeb__c servicioWeb = [SELECT id, name,usuario__c,contrasena__c, endPoint__c,  action__c 
                               FROM ServiciosWeb__c 
                               WHERE name = 'ActualizaLeads'
                               LIMIT 1];
public String endpoint_x = servicioWeb.endPoint__c;
public Map<String,String> inputHttpHeaders_x;
public Map<String,String> outputHttpHeaders_x;
public String clientCertName_x;
public String clientCert_x;
public String clientCertPasswd_x;
public Integer timeout_x;
private String[] ns_map_type_info = new String[]{'http://tempuri.org/', 'DEG_BacklandingService'};
public String ActualizaLeads(String numeroCelular,String idTabla,String tipif1,String tipif2,String tipif3,String fechaTipif,String horaTipif) {  
DEG_BacklandingService.ActualizaLeads_element request_x = new DEG_BacklandingService.ActualizaLeads_element(); 
request_x.usuario = servicioWeb.Usuario__c;
request_x.contrasena = servicioWeb.contrasena__c;
request_x.numeroCelular = numeroCelular;
request_x.idTabla = idTabla;
request_x.tipif1 = tipif1;
request_x.tipif2 = tipif2;
request_x.tipif3 = tipif3;
request_x.fechaTipif = fechaTipif;
request_x.horaTipif = horaTipif; 
DEG_BacklandingService.ActualizaLeadsResponse_element response_x;
Map<String, DEG_BacklandingService.ActualizaLeadsResponse_element> response_map_x = new Map<String, DEG_BacklandingService.ActualizaLeadsResponse_element>(); 
response_map_x.put('response_x', response_x);
WebServiceCallout.invoke(
    this,
    request_x,
    response_map_x,
    new String[]{endpoint_x,
        servicioWeb.action__c,
    'http://tempuri.org/',
    'ActualizaLeads',
    'http://tempuri.org/',
    'ActualizaLeadsResponse',
    'DEG_BacklandingService.ActualizaLeadsResponse_element'}
);
response_x = response_map_x.get('response_x');           
System.debug('request_x'+ request_x);
return response_x.ActualizaLeadsResult;
}
}
}