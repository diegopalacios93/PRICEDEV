/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              Fernando Sarasty
Proyecto:           ETB Portafolio Superior
Descripción:        Clase que permite procesar y generar los servicios y las operaciones comerciales, de los servicios empaquetados
                    relacionados a un plan que se está vendiendo a través de una oportunidad.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2018-05-23      Fernando Sarasty (FS)       Creación de la clase.
***********************************************************************************************************************/

public class PS_ProcesarServiciosEmpaquetados_cls{
    // declaración de variables        
    
    public static void procesar(String idPlanOrigen, String idOP, String OwnerIdOP, String strIdAccount, String IdServicionPpal, String IdOCPrincipal){
        String idServicio, idTipoRegistro;
        List<LTE_Servicios_adicionales__c> lstServiciosAdicionales;
        lstServiciosAdicionales = obtenerServiciosAdicionales(idPlanOrigen);
        if (!lstServiciosAdicionales.isEmpty()) {
            for(LTE_Servicios_adicionales__c servAdic : lstServiciosAdicionales){   
                idTipoRegistro = BuscarTipoRegistro(servAdic.Tipo_Operacion_por_Plan__r.Tipoderegistro__c);
                System.debug('--> Tipo de registro del TOPP: '+servAdic.Tipo_Operacion_por_Plan__r.Tipoderegistro__c+', es el siguiente: '+idTipoRegistro);
                idServicio = crearServicio(idOP, OwnerIdOP, strIdAccount, servAdic.Tipo_Operacion_por_Plan__r.Plan__r.NombredelProducto__r.Id, servAdic.Tipo_Operacion_por_Plan__r.Plan__r.Id, IdServicionPpal);
                if(idServicio!=null)
                    crearOC(idServicio, servAdic.Tipo_Operacion_por_Plan__r.Plan__r.Id, servAdic.Tipo_Operacion_por_Plan__r.Id, idOP, Label.SelProdCat_EstPendienteOC,idTipoRegistro, IdServicionPpal, IdOCPrincipal);
            }
        }
    }
    
    public static List<LTE_Servicios_adicionales__c> obtenerServiciosAdicionales(String idPlanOrigen){ 
        List<LTE_Servicios_adicionales__c> lstServiciosAdicionalesAux;
        lstServiciosAdicionalesAux = [SELECT Plan__c, Tipo_Operacion_por_Plan__r.Plan__r.NombredelProducto__r.Id, 
                                             Tipo_Operacion_por_Plan__r.Plan__r.Id, Tipo_Operacion_por_Plan__r.Tipoderegistro__c,
                                             Tipo_Operacion_por_Plan__r.Id
                                      FROM LTE_Servicios_adicionales__c
                                      WHERE Plan__c =: idPlanOrigen]; 
        System.debug('--> Servicios Adicionales del plan: '+idPlanOrigen+', Son los siguientes: '+lstServiciosAdicionalesAux);
        return lstServiciosAdicionalesAux;
    }
    
    public Static String crearServicio(String idOP, String OwnerIdOP, String strIdAccount, String idProduct, String idPlan, String IdServicionPpal){
        try{            
            ActivoETB__c newActivoETB = new ActivoETB__c();
            newActivoETB.NombredelProducto__c=idProduct;
            newActivoETB.Oportunidad__c=idOP;
            newActivoETB.OwnerId=OwnerIdOP;
            newActivoETB.NombredelaCuenta__c=strIdAccount;
            newActivoETB.Plan__c = idPlan;
            newActivoETB.Activo_Relacionado__c = IdServicionPpal;
            insert newActivoETB;
            System.debug('-->Id ActivoETB: '+newActivoETB.Id);
            return newActivoETB.Id;
        }catch(exception e){                            
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );                                
            return null;
        }
    }
    
    public Static String crearOC(String idServicio, String idPlan, String strInOperacion, String idOP, String strPendiente, String IdtipoRegistro, String IdServicionPpal, String IdOCPrincipal){
        try{          
            OperacionComercial__c newOpeCom = new OperacionComercial__c();
            newOpeCom.Activo__c=idServicio;
            newOpeCom.Plan__c=idPlan;
            newOpeCom.TOPP__c=strInOperacion;
            newOpeCom.Estado__c=strPendiente;
            newOpeCom.Oportunidad__c=idOP;
            newOpeCom.Servicio_ETB_Relacionado_Principal__c = IdServicionPpal;
            newOpeCom.OC_Principal_Empaquetamiento__c = IdOCPrincipal;
            newOpeCom.Operacion_Comercial_Relacionada__c = IdOCPrincipal;
            if(IdtipoRegistro != null)
                newOpeCom.RecordTypeId=IdtipoRegistro;
            insert newOpeCom;
            System.debug('-->Id OperacionComercial: '+newOpeCom.Id);
            return newOpeCom.Id;
        }catch(exception e){                            
            System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );                                
            return null;
        }
    }
    
    public static string BuscarTipoRegistro(String tipoRegistroTOPP){        
        list<RecordType> lstRT = new list<RecordType>();                
        if(tipoRegistroTOPP!=null){
            lstRT = [select id
                        from RecordType
                        where DeveloperName=:tipoRegistroTOPP
                        and sObjectType='OperacionComercial__c'];
                        
            if(lstRT.size()>0){                
                return lstRT[0].id;                
            }
        }   
        return null;
    } 
}