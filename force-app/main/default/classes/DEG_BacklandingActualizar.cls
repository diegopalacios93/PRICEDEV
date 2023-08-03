/**
* @description       : 
* @author            : Nolvis Sanchez
* @group             :
* @last modified on  : 17-01-2022
* @last modified by  : Nolvis Sanchez
* Modifications Log
* Ver   Date         Author                        Modification
* 1.0   
**/
public class DEG_BacklandingActualizar {

//public static String actualizaCaso(String numeroCelular,String idTabla){  
public static String actualizaCaso(Id IdCase){ 

List<case>  lstCaso = [SELECT id,DEG_Celular__c,DEG_IDdeBacklanding__c,DEG_Nivel1__c,DEG_Nivel2__c,DEG_Nivel3__c,DEG_FechaRegistroLead__c,DEG_HoraRegistroLead__c
            FROM Case
            WHERE id=:IdCase
            LIMIT 1];
// Crear Fecha y hora actual según formato del WS                 

DateTime now = DateTime.now();       
String fecha = now.format('dd-MM-yyyy');           
Integer hora = now.hour(), minutos = now.minute(), segundos = now.second();

DEG_BacklandingService.HomeSoap cs = new DEG_BacklandingService.HomeSoap();
String request = cs.ActualizaLeads(                              
                            lstCaso[0].DEG_Celular__c, 
                            lstCaso[0].DEG_IDdeBacklanding__c,
                            lstCaso[0].DEG_Nivel1__c,
                            lstCaso[0].DEG_Nivel2__c,
                            lstCaso[0].DEG_Nivel3__c,
                            fecha,
                            (hora+':'+minutos+':'+segundos));     

                                                        
return request;
}

@future(callout=true)
public static void inicializarMetodo (Id IdCase){
DEG_BacklandingActualizar.actualizaCaso(IdCase);
}
}