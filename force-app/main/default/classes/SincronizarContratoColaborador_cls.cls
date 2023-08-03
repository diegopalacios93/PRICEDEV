public class SincronizarContratoColaborador_cls {
       
    public void sincronizarConciliacionActaDePago(Map<id,Actas_de_contrato__c> objMap, string accion){
        Conciliaciones_de_contrato__c objConciliacion;
        string strIva;
        
        if(accion == 'Insert'){               
            objConciliacion = new Conciliaciones_de_contrato__c();
            for(Id ids:objMap.keySet()){                
                if(objMap.get(ids).Contrato_relacionado__c != null && objMap.get(ids).Acta_No__c != null &&
                   objMap.get(ids).Participacion__c != null && objMap.get(ids).Descripcion__c != null &&
                   objMap.get(ids).Fecha_de_acta__c != null && objMap.get(ids).Facturado__c != null &&
                   objMap.get(ids).Id != null){
                       strIva = (String.valueOf(objMap.get(ids).Param_Anexo_IVA__c)==null?consultarIVAContrato(objMap.get(ids).Contrato_relacionado__c):String.valueOf(objMap.get(ids).Param_Anexo_IVA__c));                                                  
                       
                       objConciliacion.Contrato_relacionado__c		= objMap.get(ids).Contrato_relacionado__c;
                       objConciliacion.Numero_de_acta__c 	 		= objMap.get(ids).Acta_No__c;
                       objConciliacion.Valor_sin_IVA__c 	 		= objMap.get(ids).Participacion__c;
                       objConciliacion.Porcentaje_IVA__c	 		= strIva;
                       objConciliacion.Descripcion__c				= objMap.get(ids).Descripcion__c;
                       objConciliacion.Fecha_del_acta__c			= objMap.get(ids).Fecha_de_acta__c;
                       objConciliacion.Facturado__c					= objMap.get(ids).Facturado__c;
                       objConciliacion.Id_Informe_de_Acta__c		= objMap.get(ids).Id; 
                       objConciliacion.Origen_del_acta__c			= 'Informes de actas';
                }                             
        	}
            if(objConciliacion.Id_Informe_de_Acta__c != null)
                insert objConciliacion;
        }
        if(accion == 'Update'){             
            List<Conciliaciones_de_contrato__c> lstConciliacion = new List<Conciliaciones_de_contrato__c>();                        
            for(Id ids:objMap.keySet()){
                lstConciliacion = [Select Id From Conciliaciones_de_contrato__c Where Id_Informe_de_Acta__c =:objMap.get(ids).Id];                
                if(lstConciliacion.size() > 0){                           
                    if(objMap.get(ids).Contrato_relacionado__c != null && objMap.get(ids).Acta_No__c != null &&
                       objMap.get(ids).Participacion__c != null && objMap.get(ids).Descripcion__c != null &&
                       objMap.get(ids).Fecha_de_acta__c != null && objMap.get(ids).Facturado__c != null &&
                       objMap.get(ids).Id != null){
                           strIva = (String.valueOf(objMap.get(ids).Param_Anexo_IVA__c)==null?consultarIVAContrato(objMap.get(ids).Contrato_relacionado__c):String.valueOf(objMap.get(ids).Param_Anexo_IVA__c));                           
                           objConciliacion = new Conciliaciones_de_contrato__c(Id=lstConciliacion[0].Id);                            
                           objConciliacion.Numero_de_acta__c 	 		= objMap.get(ids).Acta_No__c;
                           objConciliacion.Valor_sin_IVA__c 	 		= objMap.get(ids).Participacion__c;  
                           objConciliacion.Porcentaje_IVA__c	 		= strIva;
                           objConciliacion.Descripcion__c				= objMap.get(ids).Descripcion__c;
                           objConciliacion.Fecha_del_acta__c			= objMap.get(ids).Fecha_de_acta__c;
                           objConciliacion.Facturado__c					= objMap.get(ids).Facturado__c;                          
                           update objConciliacion;                                                  		
                    }
                }                         
            }
        }
        if(accion == 'Delete'){
            List<Conciliaciones_de_contrato__c> lstConciliacion = new List<Conciliaciones_de_contrato__c>();                        
            for(Id ids:objMap.keySet()){
                lstConciliacion = [Select Id From Conciliaciones_de_contrato__c Where Id_Informe_de_Acta__c =:objMap.get(ids).Id];                
                if(lstConciliacion.size() > 0){
                    objConciliacion = new Conciliaciones_de_contrato__c(Id=lstConciliacion[0].Id);
                    delete objConciliacion;	
                }
            }
        } 		       
    }
    public string consultarIVAContrato(String idContrato){
        List<Contract> lstContract = new List<Contract>([Select Param_Anexo_IVA__c From Contract Where Id=:idContrato]);        
        return lstContract[0].Param_Anexo_IVA__c;
    }
    public void sincronizarConciliacionActaDePago(Map<id,Actas_de_proveedor__c> objMap, string accion){
      	decimal sumatoriaValorTotal = 0;
        decimal sumatoriaValorTotalConDtos = 0;
        decimal descuentoANS = 0;
        decimal TRM = 0;
        string strIva, pagaderoEnDolares, Moneda;     
        Conciliaciones_de_contrato__c objConciliacion;  
        List<Bienes_y_servicios_Acta_de_proveedor__c> ListBienesYServicios = new List<Bienes_y_servicios_Acta_de_proveedor__c>();         
        
        if(accion == 'Insert'){               
            objConciliacion = new Conciliaciones_de_contrato__c();
            for(Id ids:objMap.keySet()){                
                if(objMap.get(ids).Contrato_relacionado__c != null && objMap.get(ids).Acta_No__c != null &&
                   objMap.get(ids).Descripcion__c != null && objMap.get(ids).Fecha_de_acta__c != null && 
                   objMap.get(ids).Facturado__c != null && objMap.get(ids).Id != null){                   
                       ListBienesYServicios =  [Select Descripcion__c, Valor_unitario_del_contrato__c, Cantidad__c, Valor_total__c, Acta_de_proveedor__r.Descuento_ANS__c, Acta_de_proveedor__r.Moneda__c,
                                                Acta_de_proveedor__r.Pagadero_en_dolares__c, Acta_de_proveedor__r.TRM__c
                                                From Bienes_y_servicios_Acta_de_proveedor__c
                                                Where Acta_de_proveedor__c =: objMap.get(ids).Id];
                                               
                        // Calcular valor total del acta
                        for(Bienes_y_servicios_Acta_de_proveedor__c objAux : ListBienesYServicios){
                            sumatoriaValorTotal = sumatoriaValorTotal + (objAux.Valor_total__c==null?0:objAux.Valor_total__c);
                            descuentoANS = (objAux.Acta_de_proveedor__r.Descuento_ANS__c== null?0:objAux.Acta_de_proveedor__r.Descuento_ANS__c);
                            moneda = objAux.Acta_de_proveedor__r.Moneda__c;
                            pagaderoEnDolares = objAux.Acta_de_proveedor__r.Pagadero_en_dolares__c;
                            TRM = objAux.Acta_de_proveedor__r.TRM__c;
                        } 
                        if(moneda == 'Dólares' && pagaderoEnDolares == 'No')
            				sumatoriaValorTotal = (sumatoriaValorTotal *TRM).setScale(2);
                       
                        sumatoriaValorTotalConDtos = sumatoriaValorTotal - descuentoANS;                       
                        strIva = (String.valueOf(objMap.get(ids).IVA__c)==null?consultarIVAContrato(objMap.get(ids).Contrato_relacionado__c):String.valueOf(objMap.get(ids).IVA__c));                                                  
                       
                        objConciliacion.Contrato_relacionado__c		= objMap.get(ids).Contrato_relacionado__c;
                        objConciliacion.Numero_de_acta__c 	 		= objMap.get(ids).Acta_No__c;
                        objConciliacion.Valor_sin_IVA__c 	 		= sumatoriaValorTotalConDtos;
                        objConciliacion.Porcentaje_IVA__c	 		= strIva;
                        objConciliacion.Descripcion__c				= objMap.get(ids).Descripcion__c;
                        objConciliacion.Fecha_del_acta__c			= objMap.get(ids).Fecha_de_acta__c;
                        objConciliacion.Facturado__c				= objMap.get(ids).Facturado__c;
                        objConciliacion.Id_Informe_de_Acta__c		= objMap.get(ids).Id; 
                        objConciliacion.Origen_del_acta__c			= 'acta de proveedor';
                }                             
        	}
            if(objConciliacion.Id_Informe_de_Acta__c != null)
                insert objConciliacion;
        }
        if(accion == 'Update'){             
            List<Conciliaciones_de_contrato__c> lstConciliacion = new List<Conciliaciones_de_contrato__c>();                        
            for(Id ids:objMap.keySet()){
                lstConciliacion = [Select Id From Conciliaciones_de_contrato__c Where Id_Informe_de_Acta__c =:objMap.get(ids).Id];                
                if(lstConciliacion.size() > 0){                           
                    if(objMap.get(ids).Contrato_relacionado__c != null && objMap.get(ids).Acta_No__c != null &&
                       objMap.get(ids).Descripcion__c != null && objMap.get(ids).Fecha_de_acta__c != null && 
                       objMap.get(ids).Facturado__c != null && objMap.get(ids).Id != null){                           
                       
                           ListBienesYServicios =  [Select Descripcion__c, Valor_unitario_del_contrato__c, Cantidad__c, Valor_total__c, Acta_de_proveedor__r.Descuento_ANS__c, Acta_de_proveedor__r.Moneda__c,
                                                	Acta_de_proveedor__r.Pagadero_en_dolares__c, Acta_de_proveedor__r.TRM__c
                                                    From Bienes_y_servicios_Acta_de_proveedor__c
                                                    Where Acta_de_proveedor__c =: objMap.get(ids).Id];
                                                   
                           // Calcular valor total del acta
                           for(Bienes_y_servicios_Acta_de_proveedor__c objAux : ListBienesYServicios){
                               sumatoriaValorTotal = sumatoriaValorTotal + (objAux.Valor_total__c==null?0:objAux.Valor_total__c);
                               descuentoANS = (objAux.Acta_de_proveedor__r.Descuento_ANS__c== null?0:objAux.Acta_de_proveedor__r.Descuento_ANS__c);
                               moneda = objAux.Acta_de_proveedor__r.Moneda__c;
                               pagaderoEnDolares = objAux.Acta_de_proveedor__r.Pagadero_en_dolares__c;
                               TRM = objAux.Acta_de_proveedor__r.TRM__c;
                           }
                           if(moneda == 'Dólares' && pagaderoEnDolares == 'No')
            				sumatoriaValorTotal = (sumatoriaValorTotal *TRM).setScale(2);
                           
                           sumatoriaValorTotalConDtos = sumatoriaValorTotal - descuentoANS;
                           strIva = (String.valueOf(objMap.get(ids).IVA__c)==null?consultarIVAContrato(objMap.get(ids).Contrato_relacionado__c):String.valueOf(objMap.get(ids).IVA__c));                           
                           
                           objConciliacion = new Conciliaciones_de_contrato__c(Id=lstConciliacion[0].Id);                            
                           objConciliacion.Numero_de_acta__c 	 		= objMap.get(ids).Acta_No__c;
                           objConciliacion.Valor_sin_IVA__c 	 		= sumatoriaValorTotalConDtos;  
                           objConciliacion.Porcentaje_IVA__c	 		= strIva;
                           objConciliacion.Descripcion__c				= objMap.get(ids).Descripcion__c;
                           objConciliacion.Fecha_del_acta__c			= objMap.get(ids).Fecha_de_acta__c;
                           objConciliacion.Facturado__c					= objMap.get(ids).Facturado__c;                          
                           update objConciliacion;                                                  		
                    }
                }                         
            }
        }
        if(accion == 'Delete'){
            List<Conciliaciones_de_contrato__c> lstConciliacion = new List<Conciliaciones_de_contrato__c>();                        
            for(Id ids:objMap.keySet()){
                lstConciliacion = [Select Id From Conciliaciones_de_contrato__c Where Id_Informe_de_Acta__c =:objMap.get(ids).Id];                
                if(lstConciliacion.size() > 0){
                    objConciliacion = new Conciliaciones_de_contrato__c(Id=lstConciliacion[0].Id);
                    delete objConciliacion;	
                }
            }
        } 
    }
    
    public void sincronizarActaProveedor(Map<id,Bienes_y_servicios_Acta_de_proveedor__c> objMap){		
        
        //decimal sumatoriaValorTotal = 0;        
        Actas_de_proveedor__c objActaProveedor;
        String IdActaProveedor;
        List<Bienes_y_servicios_Acta_de_proveedor__c> ListBienesYServicios = new List<Bienes_y_servicios_Acta_de_proveedor__c>();
        for(Id ids:objMap.keySet()){
            IdActaProveedor = objMap.get(ids).Acta_de_proveedor__c;
                 
        } 
        if(IdActaProveedor != null){
        	objActaProveedor = new Actas_de_proveedor__c(Id=IdActaProveedor);            
        	update objActaProveedor;
        }
    }
    
    public void SincronizaFechaContrato(Map<id,Adiciones_y_prorrogas_contratos__c> mapAdicionProrroga, string fuente){                
        
            list<Id> lstIdContracto = new list<Id>();
        	Map<Id,date> mapFechaAdicionProrroga = new Map<Id,date>();
        
        	if(fuente == 'Upsert'){
        		for(Id ids:mapAdicionProrroga.keySet()){                    
        			lstIdContracto.add(mapAdicionProrroga.get(ids).Contrato_relacionado__c );
            		mapFechaAdicionProrroga.put(mapAdicionProrroga.get(ids).Contrato_relacionado__c, mapAdicionProrroga.get(ids).Fecha_de_fin__c);                    
            	}
        	}else{
            	for(Id ids:mapAdicionProrroga.keySet()){                    
        			lstIdContracto.add(mapAdicionProrroga.get(ids).Contrato_relacionado__c  );                        
            	}
        	}
            
            if (lstIdContracto.size()>0){
        		List <Contract> lstContrato =  [SELECT Id, Fecha_de_terminacion__c FROM Contract WHERE Id IN :lstIdContracto];
       
        		if (fuente =='Delete'){
            		for(Adiciones_y_prorrogas_contratos__c adicionPorrroga : [SELECT Id,Contrato_relacionado__c, Fecha_de_fin__c FROM Adiciones_y_prorrogas_contratos__c WHERE Contrato_relacionado__c IN :lstIdContracto  order by Fecha_de_fin__c desc LIMIT  1]){
                		mapFechaAdicionProrroga.put(adicionPorrroga.Contrato_relacionado__c, adicionPorrroga.Fecha_de_fin__c );
            		}
        		}
        
        		if(lstContrato.size()>0){
            		for (Contract contrato:lstContrato){
            			if (mapFechaAdicionProrroga.get(contrato.id) != null){
							contrato.Fecha_de_terminacion__c = mapFechaAdicionProrroga.get(contrato.id);
            			}else{
              	 			contrato.Fecha_de_terminacion__c = mapFechaAdicionProrroga.get(contrato.id);
              	 			contrato.Fecha_maxima_de_liquidacion__c = null; 
            			}
        			}
        		}
        		update lstContrato;
           }    
    }     
}