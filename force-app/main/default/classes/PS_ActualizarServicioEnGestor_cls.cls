/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              Fernando Sarasty
Proyecto:           Evolutivos
Descripción:        

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0                       Fernando Sarasty (FS)		               Creación de la clase.
***********************************************************************************************************************/

public class PS_ActualizarServicioEnGestor_cls {    
    @Future(callout=true)    
    public static void ActualizarServicioEnGestor(String nombreOC, String IDServicio){   
        Map<Integer, String> respuestaIntegracion = new Map<Integer, String>();
        String idOC = consultarDatosOC(nombreOC);
        LogTransacciones__c lt;   
        system.debug('ActualizarServicioEnGestor > Parametros de entrada: '+nombreOC+'-'+IDServicio);
        respuestaIntegracion = PS_IntegracionSalidaGestor_cls.integracionActualizacionServicio(idOC, IDServicio);  
        if(respuestaIntegracion.get(1) != '-1'){
        	lt =new LogTransacciones__c(CorrelationId__c=idOC,LTE_Operacion_Comercial__c=idOC,Informacion_Enviada__c= respuestaIntegracion.get(3),Informacion_Recibida__c=respuestaIntegracion.get(4),Name='ActualizacionServicioEnGestor - '+nombreOC);
        	insert lt;            
        }
    }  
    public static string consultarDatosOC(String nombreOC){
        List<OperacionComercial__c> OC = [SELECT Id FROM OperacionComercial__c where name =: nombreOC];
        return OC[0].Id;            
    }
}