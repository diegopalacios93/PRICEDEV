/*******************************************************************************
Desarrollado por:       Matías Roldán
Autor:                  Matías Roldán
Proyecto:               ETB - N-37697 - C.D. Producto E-Commerce con Aliado

Descripción:            Controlador del componente Lightning Web Component modificarAtributos encargada de modificar los valores
                                                de los SpecificationGroupXA de cada Servicio Adicional relacionado a la Operacion Comercial.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     09/11/2021  Matías Roldán   (MR)       Creación de la clase..
*******************************************************************************/ 

public with sharing class ModificarAtributos {
    
    @AuraEnabled(cacheable=true)
    //Metodo que crea un Mapa de Listas relacionadas de los Servicios Adicionales y sus SpecificationGroupXA y lo retorna al LWC modificarAtributos
    public static Map<String,List<LTE_SpecificationGroupXA__c>> getMapSVAyXA(id recordId){

        Map<String,List<LTE_SpecificationGroupXA__c>> mapSVA = new Map<String,List<LTE_SpecificationGroupXA__c>>();
        List<LTE_Servicios_adicionales__c> lstSVA = [SELECT ID, Name                  
                                                     FROM LTE_Servicios_adicionales__c WHERE LTE_OC_Tramite__c = :recordId];
        List<LTE_SpecificationGroupXA__c> lstXA = [SELECT ID, Name, LTE_Value__c, LTE_ServiciosAdicionales__c, LTE_ServiciosAdicionales__r.LTE_OC_Tramite__c
                                                   FROM LTE_SpecificationGroupXA__c WHERE LTE_ServiciosAdicionales__r.LTE_OC_Tramite__c  = :recordId];
        for(LTE_Servicios_adicionales__c sglSVA:lstSVA){
            List<LTE_SpecificationGroupXA__c> lstXAs = new List<LTE_SpecificationGroupXA__c>();
            for(LTE_SpecificationGroupXA__c sglXA:lstXA){
                if(sglXA.LTE_ServiciosAdicionales__c == sglSVA.id){
                    lstXAs.add(sglXA);
                }
            }
            mapSVA.put(sglSVA.Name,lstXAs);
        }
        
        return mapSVA;
    }
    //Metodo que recibe el mapa de listas actualizado enviado en el metodo getMapSVAyXA, inserta cada XA en una lista y posteriormente hace un update.
    @AuraEnabled(cacheable=false)
    public static void updateXA(Map<String,List<LTE_SpecificationGroupXA__c>> mapXA){
        List<LTE_SpecificationGroupXA__c> lstXA = new List<LTE_SpecificationGroupXA__c>();
        for(String sglSVA:mapXA.keySet()){
            for(LTE_SpecificationGroupXA__c sglXA:mapXA.get(sglSVA)){
                lstXA.add(sglXA);
            }
        }
        Database.update(lstXA,false);
    }
}