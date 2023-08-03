public with sharing class LTE_DetalleOferta_cls {
	
	public static void actualizarOC(map<Id,LTE_DetalleOferta__c> oldMap,map<Id,LTE_DetalleOferta__c> newMap){
		
		//Si desencadena la legalizacion se omite
		if(BanderasEjecucion.ValidarEjecucion('DesenCadenaLegalizacion')){
			return;
		}
		
		
		map<string,string> campos=new map<string,string>();
		campos.put('LTE_IMEI__c','IMEI_del_Equipo__c');
		campos.put('LTE_ICCID__c','LTE_ICCID__c');
		campos.put('LTE_NumeroLinea__c','NumeroConexion__c');
		campos.put('LTE_EquipoTraido__c','LTE_EquipoTraido__c');
		campos.put('LTE_SolicitadoPorTercero__c','LTE_SolicitadoPorTercero__c');
		campos.put('LTE_Valor_Total_Plan__c','ValorTarifaPlan__c');
		campos.put('LTE_ValorDespuesImpuestoIVA__c','Valorunicavez__c');
		campos.put('LTE_ReferenciaEquipo__c','LTE_ReferenciaEquipo__c');
        campos.put('Portado_con_Cedula__c','Portado_con_Cedula__c');
		
		
		map<Id,OperacionComercial__c> oclmap=new map<Id,OperacionComercial__c>();
		
		for(Id idMap:oldMap.keySet()){


 			if(!LTE_LibreriaUtilitaria_cls.checkImei(newMap.get(idMap).LTE_IMEI__c)){
				
				newMap.get(idMap).addError(Label.LTE_ValidarIMEI.replace('##validarIMEI##',newMap.get(idMap).LTE_IMEI__c));
			
			}
			
			OperacionComercial__c oc =new OperacionComercial__c();
			oc.id=newMap.get(idMap).LTE_OperacionComercial__c;
			for(string c:campos.keySet()){
				if(newMap.get(idMap).LTE_Estado_Detalle_Oferta__c != 'Declinado'){
					string ocField=campos.get(c);
					system.debug(c+' '+idMap+' '+newMap.get(idMap).get(c)+' '+oldMap.get(idMap).get(c) +' '+ newMap.get(idMap).get(c));
					//Valida cambios de los valores
					if(newMap.get(idMap).get(c)!=null
					&& newMap.get(idMap).LTE_OperacionComercial__c!=null){
						system.debug(ocField);
						oc.put(ocField,newMap.get(idMap).get(c));
						oclmap.put(oc.id,oc);	
					}
				}
			}
		
		}
		update oclmap.values();
	}


	 public static void  cambioEstadoListasNegras(List<LTE_DetalleOferta__c> oldDetalleOferta, map<Id,LTE_DetalleOferta__c> mapNewDetalleOferta  )
	  {
	  	

	  	for (LTE_DetalleOferta__c objOld : oldDetalleOferta)
	  	{
	  			if(mapNewDetalleOferta.containsKey(objOld.Id))
	  			{
	  				LTE_DetalleOferta__c objDetalleNew = mapNewDetalleOferta.get(objOld.Id);
	  				if(objDetalleNew.LTE_estadosLN__c  != objOld.LTE_estadosLN__c && objDetalleNew.LTE_estadosLN__c != null)
	  				{
	  					if(objDetalleNew.LTE_estadosLN__c == '0' || objDetalleNew.LTE_estadosLN__c == '1')
	  					{
	  						objDetalleNew.LTE_Estado__c = 'No reportado';
	  					}//INI10026-Se adiciona la validación LTE_estadosLN__c = 3 a Reportado
	  					else if(objDetalleNew.LTE_estadosLN__c == '2' || objDetalleNew.LTE_estadosLN__c == '3')
	  					{
	                    objDetalleNew.LTE_Estado__c = 'Reportado';
	  					}
	  					
  					}
  					else if(objDetalleNew.LTE_IMEI__c  != objOld.LTE_IMEI__c && (objOld.LTE_Estado__c=='No reportado'|| objOld.LTE_Estado__c=='Reportado' ||objOld.LTE_Estado__c=='Pendiente'))
	  				{
	  					objDetalleNew.LTE_estadosLN__c = '';
	  					objDetalleNew.LTE_Estado__c = 'Pendiente';
	  						  					
  					}
  					else if(objDetalleNew.LTE_Estado__c =='Pendiente')
	  				{
	  					objDetalleNew.LTE_estadosLN__c = '';	  						  					
  					}
	  			}

	  	}
	  }
	  
	  /*********************************************************************************
	  * Metodo encargado de actualizar los campos de la OC replicando los campos del
	  * detalle de la oferta 
	  *********************************************************************************/
	  public static void actualizarCamposOC(Map<Id,LTE_DetalleOferta__c> mapOld, Map<Id,LTE_DetalleOferta__c> mapNew){
		
		Set<Id> setIdOc = new Set<Id>();
		
		for(LTE_DetalleOferta__c objDetalle : mapNew.values()){
			if(objDetalle.LTE_OperacionComercial__c != null){
				setIdOc.add(objDetalle.LTE_OperacionComercial__c);
			}
		}
		
		Map<Id, OperacionComercial__c> mapOC = new Map<Id, OperacionComercial__c>([SELECT Id, LTE_Estado_c_del__c FROM OperacionComercial__c WHERE Id in :setIdOc]);
		
		for(LTE_DetalleOferta__c objDetOfer : mapNew.values()){
			if(objDetOfer.LTE_OperacionComercial__c != null){
				mapOC.get(objDetOfer.LTE_OperacionComercial__c).LTE_Estado_c_del__c = objDetOfer.LTE_Estado__c;
			}
			
		}
		
		update mapOC.values();
	  
	  }
		
	  public static void actualizarIMEISCuentaFacturacion(List<LTE_DetalleOferta__c> lstDetalles){
		  Map<Id,CuentaFacturacion__c> cfs = new Map<Id,CuentaFacturacion__c>();
			for (LTE_DetalleOferta__c detalle : lstDetalles) {
				CuentaFacturacion__c cf = new CuentaFacturacion__c();
				Id idCF = detalle.LTE_OperacionComercial__r.CuentaFacturacion__c;
				System.debug('mapa--->'+ cfs);
				if(!cfs.containsKey(idCF)){
					cf.Id =idCF;
					if(detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.IMEISCF__c != null){
						if(!detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.IMEISCF__c.contains(detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name)){
							if(detalle.LTE_ReferenciaEquipo__c != null){
								cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name+' '+ detalle.LTE_ReferenciaEquipo__r.Name + ' '+ detalle.LTE_IMEI__c;
							}else{
								cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name+' '+ detalle.ReferenciaEquipoAliado__c + ' '+ detalle.LTE_IMEI__c;

							}
						}else{
							if(detalle.LTE_ReferenciaEquipo__c != null){
								cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.IMEISCF__c +'#'+detalle.LTE_ReferenciaEquipo__r.Name + ' '+ detalle.LTE_IMEI__c;
							}else{
								cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.IMEISCF__c +'#'+detalle.ReferenciaEquipoAliado__c + ' '+ detalle.LTE_IMEI__c;

							}
						}
					}else{
						if(detalle.LTE_ReferenciaEquipo__c != null){
							cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name+' '+ detalle.LTE_ReferenciaEquipo__r.Name + ' '+ detalle.LTE_IMEI__c;
						}else{
							cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name+' '+ detalle.ReferenciaEquipoAliado__c + ' '+ detalle.LTE_IMEI__c;

						}
					}
					
				}else{
					cf = cfs.get(idCF);
					if(cf.IMEISCF__c != null){
						if(!cf.IMEISCF__c.contains(detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name)){
							if(detalle.LTE_ReferenciaEquipo__c != null){
								cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name+' '+ detalle.LTE_ReferenciaEquipo__r.Name + ' '+ detalle.LTE_IMEI__c;
							}else{
								cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name+' '+ detalle.ReferenciaEquipoAliado__c + ' '+ detalle.LTE_IMEI__c;
							}	
						}else{
							if(detalle.LTE_ReferenciaEquipo__c != null){
								cf.IMEISCF__c = cf.IMEISCF__c +'#'+detalle.LTE_ReferenciaEquipo__r.Name + ' '+ detalle.LTE_IMEI__c;
							}else{
								cf.IMEISCF__c = cf.IMEISCF__c +'#'+detalle.ReferenciaEquipoAliado__c + ' '+ detalle.LTE_IMEI__c;
							}
						}
					}else{
						if(detalle.LTE_ReferenciaEquipo__c != null){
							cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name+' '+ detalle.LTE_ReferenciaEquipo__r.Name + ' '+ detalle.LTE_IMEI__c;
						}else{
							cf.IMEISCF__c = detalle.LTE_OperacionComercial__r.CuentaFacturacion__r.Name+' '+ detalle.ReferenciaEquipoAliado__c + ' '+ detalle.LTE_IMEI__c;
						}		
					}
				}
                cf.ContieneIMEI__c = true;
				cfs.put(idCF,cf);
			}
			actualizarCFs(cfs);
	  }
	
	public static void actualizarCFs(Map<Id,CuentaFacturacion__c> cfs){
		if(!cfs.isEmpty()){
			update cfs.values();
		}
	}
}