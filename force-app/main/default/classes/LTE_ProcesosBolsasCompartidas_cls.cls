/*******************************************************************************
Desarrollado por:       ETB
Autor:                  Fernando Sarasty
Proyecto:               Bolsas compartidas
Descripción:            Agrupa procesos relacionados con bolsas compartidas

Cambios (Versiones)
-------------------------------------
No.       Fecha                 Autor                 Descripción
------  ----------      --------------------        ---------------
1.0     14-05-2020      Fernando Sarasty (FS)       Creación de la clase
*******************************************************************************/
public class LTE_ProcesosBolsasCompartidas_cls {
	public void actualizaOCsBolsasCOmpartidas(OperacionComercial__c newOC, OperacionComercial__c oldOC){         
        if(oldOC.Tipo_linea_bolsa_compartida__c == 'Padre' || oldOC.Tipo_linea_bolsa_compartida__c == 'Hija')
        {             
         	List<OperacionComercial__c> listOc = new List<OperacionComercial__c>([Select Id, TOPP__r.Tipoderegistro__c, Tipo_linea_bolsa_compartida__c, Estado__c, EstadoAprovisionamiento__c,fecha_final_estado__c,
                                                                              Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Estado__c, Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Tipo_linea_bolsa_compartida__c,Operacion_Comercial_Relacionada__c
                                                                              From OperacionComercial__c 
                                                                              Where (Tipo_linea_bolsa_compartida__c = 'Padre' OR Tipo_linea_bolsa_compartida__c = 'Hija') AND Id =:oldOC.Id]);
            
            if(listOc.size() > 0){             
                if(listOc[0].TOPP__r.Tipoderegistro__c == 'Venta_LTE' && listOc[0].Tipo_linea_bolsa_compartida__c == 'Padre' && listOc[0].Estado__c == 'Facturado')
                {            
                    List<OperacionComercial__c> listOcHijas 		= new List<OperacionComercial__c>();
                    List<OperacionComercial__c> listOcHijasUpdate	= new List<OperacionComercial__c>();            
                    
                    listOcHijas = [Select Id, Name From OperacionComercial__c
                                   Where TOPP__r.Tipoderegistro__c = 'Venta_LTE' AND Tipo_linea_bolsa_compartida__c = 'Hija' AND
                                         Estado__c = 'Activa' AND EstadoAprovisionamiento__c = 'COMPLETE' AND 
                                         Operacion_Comercial_Relacionada__c=:oldOC.Id];      
                    
                    if(listOcHijas.size() > 0){
                        for(OperacionComercial__c objOC: listOcHijas){
                            objOC.Estado__c 			= listOc[0].Estado__c;
                            objOC.fecha_final_estado__c = listOc[0].fecha_final_estado__c;
                            listOcHijasUpdate.add(objOC);
                        }
                        if(listOcHijasUpdate.size() > 0 && !Test.isRunningTest())
                            update listOcHijasUpdate;
                    }
                }/*else if(listOc[0].TOPP__r.Tipoderegistro__c == 'Venta_LTE' && listOc[0].Tipo_linea_bolsa_compartida__c == 'Hija' && listOc[0].Estado__c == 'Activa' && listOc[0].EstadoAprovisionamiento__c == 'COMPLETE' && (listOc[0].Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Estado__c == 'Activo' && listOc[0].Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Tipo_linea_bolsa_compartida__c == 'Padre'))
                {                
                    OperacionComercial__c objOcUpdate   = new OperacionComercial__c(Id=oldOC.Id);
                    objOcUpdate.Estado__c 				= 'Facturado';
                    objOcUpdate.fecha_final_estado__c 	=  date.today(); 
                    Update objOcUpdate;
                    
                }*/else if(listOc[0].TOPP__r.Tipoderegistro__c == 'Adicion_bolsa_compartida' && listOc[0].Tipo_linea_bolsa_compartida__c == 'Hija' && listOc[0].Estado__c == 'Activa' && listOc[0].EstadoAprovisionamiento__c == 'COMPLETE')
                {
                    OperacionComercial__c objOcRetiroUpdate = new OperacionComercial__c(Id=listOc[0].Operacion_Comercial_Relacionada__c);
                    objOcRetiroUpdate.Estado__c = 'Inactivo';
                    update objOcRetiroUpdate; 
                }            
            } 
        }
    }
}