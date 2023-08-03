/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              Fernando Sarasty
Proyecto:           Evolutivos
Descripción:        Clase diseñada para incluir en las operaciones comerciales de retiro de cupo de larga distancia, las líneas
				 	que se encuentren relacionadas al cupo.

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2018-06-20      Fernando Sarasty (FS)		               Creación de la clase.
***********************************************************************************************************************/

public class IncluirLineasAOperacionComercial_cls {
    @InvocableMethod(label='incluirLineas')
    public static void incluirLineas(List<ID> ids){
        string idRetencionServicio = ids[0];
        string idAC, idOC;
        list<OperacionComercial__c> lstOpCom = new list<OperacionComercial__c>();
        List<Linea__c> lstLineas = new List<Linea__c>();
        List<Linea__c> lstLineasUpdate = new List<Linea__c>();
        
        if(idRetencionServicio != null){
            lstOpCom  = ConsultarOperacionesComerciales(idRetencionServicio);            
            if(lstOpCom.size()>0){
                for(OperacionComercial__c oc:lstOpCom){
                    idOC = oc.Id;
                    idAC = oc.Activo__c;
                    lstLineas = consultarLineas(idAC);
                    if(lstLineas.size()>0){
                        for(Linea__c linea:lstLineas){
                            system.debug('--> IncluirLineasAOperacionComercial_cls - Linea a actualizar: '+linea+', con la OC: '+idOC);
                            Linea__c lineaUpdate = new Linea__c(Id = linea.Id);
        					lineaUpdate.Operacion_Comercial_Actual__c = idOC;
                            lstLineasUpdate.add(lineaUpdate);
                        }
                        if(!lstLineasUpdate.isEmpty())
                            update lstLineasUpdate;
                    }                    
                }
            }
        }        
    }
    
    private static List<OperacionComercial__c> consultarOperacionesComerciales(String idRetencionServicio)
    {        
        List<OperacionComercial__c> lstOpComer = new List<OperacionComercial__c>();
        String strQueryOpCom;        
        strQueryOpCom  = 'Select Id, Activo__c From OperacionComercial__c';
        strQueryOpCom += ' Where Fidelizacion__c = \''+idRetencionServicio+'\'';                
        System.debug('--> IncluirLineasAOperacionComercial_cls > consultarOperacionesComerciales: '+strQueryOpCom);
        lstOpComer = Database.query(strQueryOpCom);
        return lstOpComer;
    }
    
    private static List<Linea__c> consultarLineas(String idAC)
    {        
        List<Linea__c> lstLineas = new List<Linea__c>();
        String strQueryLineas;        
        strQueryLineas = 'Select Id From Linea__c';
        strQueryLineas += ' Where Activo__c = \''+idAC+'\'';                
        System.debug('--> IncluirLineasAOperacionComercial_cls > consultarLineas: '+strQueryLineas);
        lstLineas = Database.query(strQueryLineas);
        return lstLineas;
    }
}