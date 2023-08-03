/*******************************************************************************
Desarrollado por:       SQDM
Autor:                  John Guevara
Proyecto:               ETB - CRM Proyecto LTE
Descripción:            Clase encargada de procesos relacionados con los APN

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     16-09-2016  John Guevara				Creación de la clase
*******************************************************************************/
global class ProcesosAPN_cls {

    public static void PoolCambioAPN(Map <Id,POOL_APN__c> lstIdPool){
        //Actualiza el campo APN de la IP con base en el campo APN del Pool
        //
        system.debug('llamado al metodo ProcesosAPN_cls.PoolCambioAPN');
        if(lstIdPool.size()>0){
			List<IP__c> lstIP = [SELECT Id, APN__c, POOL_de_APN__c FROM IP__c WHERE POOL_de_APN__c = :lstIdPool.keySet()];
            for(IP__c sglIP:lstIP){
                sglIP.APN__c = lstIdPool.get(sglIP.POOL_de_APN__c).APN__c;
            }
            if(lstIP.size()>0)
            	update lstIP;
        }
    }

    public static void APNCantidadIP(List <IP__c> lstIP){
        //Calcula la cantidad de IPs asignadas a un APN
        //Se asume que las IPs son modificadas en el estado o al momento de asociarse a un APN
        system.debug('llamado al metodo ProcesosAPN_cls.APNCantidadIP');
        Integer nDisponible = 0;
        if(lstIP.size()>0){
            List<Id> lstAPNId = new List<Id>();
            for(IP__c sglIP:lstIP){
                lstAPNId.add(sglIP.APN__c);
            }
            List<APN__c> lstAPN =[SELECT Id, (SELECT Id, Estado__c FROM IPS__r) FROM APN__c WHERE Id = :lstAPNId];
            for(APN__c sglAPN:lstAPN){
                nDisponible = 0;
                for(IP__c assocIP:sglAPN.IPS__r){
                    if(assocIP.Estado__c == 'Disponible')
                        nDisponible++;
                }
                sglAPN.IP_Totales__c = sglAPN.IPS__r.size();
                sglAPN.IP_Disponibles__c = nDisponible;
            }
            
            if(lstAPN.size()>0)
            	update lstAPN;
        }
    }
    
    public static void SVA_APN(List <OperacionComercial__c> lstOCAPN){
        system.debug('llamado al metodo ProcesosAPN_cls.SVA_APN');
        if(lstOCAPN.size()>0){
            List<Id> lstObj = new List<Id>();
            List<Id> lstObjCase = new List<Id>();
            List<LTE_Servicios_adicionales__c> lstSVA = new List<LTE_Servicios_adicionales__c>();
            List<SubPlanFacturacion__c> subPlanes = new List<SubPlanFacturacion__c>();
            
            for(OperacionComercial__c sglAPN:lstOCAPN){
                if(String.isNotBlank(sglAPN.Tipo_de_APN__c) && String.isNotBlank(sglAPN.Oportunidad__c))
                	lstObj.add(sglAPN.Oportunidad__c);
                if(String.isNotBlank(sglAPN.Tipo_de_APN__c) && String.isNotBlank(sglAPN.Caso__c))
                	lstObjCase.add(sglAPN.Caso__c);
            }
            if(!lstObj.isEmpty() || !lstObjCase.isEmpty()){
                subPlanes = [SELECT Id, Name FROM SubPlanFacturacion__c WHERE Codigo__c LIKE 'SVA APN%'];
            }
            if(!lstObj.isEmpty()){
                for(LTE_DetalleOferta__c sglDO:[SELECT Id, (Select Id FROM LTE_Servicios_adicionales__r WHERE NAME LIKE 'SVA APN%') FROM LTE_DetalleOferta__c WHERE LTE_OperacionComercial__r.Tipo_de_APN__c = '' AND LTE_OperacionComercial__r.Oportunidad__c = :lstObj]){
                    if(sglDO.LTE_Servicios_adicionales__r.size()==0){
                        for(SubPlanFacturacion__c sglSbPlan:subPlanes){
                            LTE_Servicios_adicionales__c newSVA = new LTE_Servicios_adicionales__c();
                            newSVA.Name = sglSbPlan.Name;
                            newSVA.LTE_DetalleOfertaEReservadoRegContable__c = sglDO.Id;
                            newSVA.LTE_ServiceActionCode__c = 'ADD';
                            newSVA.LTE_SubPlaFacturacion__c = sglSbPlan.Id;
                            lstSVA.add(newSVA);
                    	}
                    }
                }
            }

            if(!lstObjCase.isEmpty()){
                for(OperacionComercial__c sglDOCase:[SELECT Id, (Select Id FROM Servicios_adicionales1__r WHERE NAME LIKE 'SVA APN%') FROM OperacionComercial__c WHERE Tipo_de_APN__c = '' AND Caso__c = :lstObjCase]){
                    if(sglDOCase.Servicios_adicionales1__r.size()==0){
                        for(SubPlanFacturacion__c sglSbPlan:subPlanes){
                            LTE_Servicios_adicionales__c newSVA = new LTE_Servicios_adicionales__c();
                            newSVA.Name = sglSbPlan.Name;
                            newSVA.LTE_OC_Tramite__c = sglDOCase.Id;
                            newSVA.LTE_ServiceActionCode__c = 'ADD';
                            newSVA.LTE_SubPlaFacturacion__c = sglSbPlan.Id;
                            lstSVA.add(newSVA);
                    	}
                    }
                }
            }
            if(!lstSVA.isEmpty())
                insert lstSVA;
        }
    }
    
    //lstOCAPN = <Id Operacion Comercial, Id APN>
    public static String OCAsociaIPPool(Map <Id, Id> lstOCAPN){
        system.debug('llamado al metodo ProcesosAPN_cls.OCAsociaIPPool');
        //Mapas de Oportunidades
		String sreturn = '';
        Map <Id, Id> lstOCAPNPool = new Map <Id, Id>();
		Map <Id, Id> lstOCAPNIP = new Map <Id, Id>();
        Map <Id, OperacionComercial__c> lstOCAPNDetails = new Map <Id, OperacionComercial__c>();
        for(OperacionComercial__c sglOC:[SELECT Id, Tipo_de_APN__c,Tipo_de_Plan_APN__c, APN__c, Oportunidad__c, Caso__c, Plan__r.NombredelProducto__r.Name FROM OperacionComercial__c WHERE Id = :lstOCAPN.keyset()]){
            if(sglOC.Tipo_de_APN__c == 'Datos'){
                if(String.isNotBlank(sglOC.Oportunidad__c)){
                    lstOCAPNIP.put(sglOC.Oportunidad__c, lstOCAPN.get(sglOC.Id));
                    lstOCAPNDetails.put(sglOC.Oportunidad__c, sglOC);
                }
                if(String.isNotBlank(sglOC.Caso__c)){
                    lstOCAPNIP.put(sglOC.Caso__c, lstOCAPN.get(sglOC.Id));
                    lstOCAPNDetails.put(sglOC.Caso__c, sglOC);
                }
            }
            if(sglOC.Tipo_de_APN__c == 'Internet'){
                if(String.isNotBlank(sglOC.Oportunidad__c)){
                    lstOCAPNPool.put(sglOC.Oportunidad__c, lstOCAPN.get(sglOC.Id));
                    lstOCAPNDetails.put(sglOC.Oportunidad__c, sglOC);
                }
                if(String.isNotBlank(sglOC.Caso__c)){
                    lstOCAPNPool.put(sglOC.Caso__c, lstOCAPN.get(sglOC.Id));
                    lstOCAPNDetails.put(sglOC.Caso__c, sglOC);
                }
            }
        }
        if(!lstOCAPNIP.isEmpty())
        	sreturn = OCAsociaIP(lstOCAPNIP,lstOCAPNDetails);
        if(!lstOCAPNPool.isEmpty() && String.isBlank(sreturn))
        	sreturn = OCAsociaPool(lstOCAPNPool,lstOCAPNDetails);
        return sreturn;
    }
    
    //lstOCAPN = <Id Oportunidad, Id APN>
    public static String OCAsociaIP(Map <Id, Id> lstOCAPN, Map <Id, OperacionComercial__c> lstOCAPNDetails){
        //Asigna las IPs a los OC de linea asociados al OC de APN
        //
		system.debug('Ingreso a la clase ProcesosAPN_cls.OCAsociaIP');
        
        Map<string,LTE_APN__c> vGlobalAPN = LTE_APN__c.getAll();
         Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        String strTiposAPN = vGlobalAPN.get('TiposAPN').valor__c;
        String strProductoLTE = vGlobal.get('NombreComercialLTE').valor__c;
        Set<String> lstTiposAPN = new Set<String>(strTiposAPN.split(','));
        list<OperacionComercial__c> lstOCAsocAPN = new list<OperacionComercial__c>();
        Set<Id> lstAPNVia = new Set<Id>();
        
		String sreturn = '';
        List<IP__c> lstIPs = [SELECT Id, Estado__c, APN__c, POOL_de_APN__c FROM IP__c WHERE Estado__c = 'Disponible' AND APN__c = :lstOCAPN.values()];
		List<OperacionComercial__c> lstOCR = [
            SELECT Id, Oportunidad__c, Caso__c, IP__c, POOL_de_APN__c, APN__c, Tipo_de_APN__c, Tipo_de_Plan_APN__c, Tipo_Operacion_APN__c, Plan__r.NombredelProducto__r.Name,
            (SELECT Id FROM Viabilidades__r WHERE Respuestadeviabilidad__c!=:Label.EnvioVia_RtaNoViab or EstadoViabilidad__c!=:Label.EnvioVia_EstCerrado)
            FROM OperacionComercial__c 
            WHERE Oportunidad__c = :lstOCAPN.keySet() OR Caso__c = :lstOCAPN.keySet()];
		// Incluir condicion que evalua si se pueden asociar o no
		// 
		system.debug(lstIPs);
        system.debug(lstOCR);
        Integer iciclo = 0;
        for(OperacionComercial__c sglOCR:lstOCR)
        {
            iciclo = 0;
            while (iciclo < lstIPs.size() && sglOCR.APN__c == null){
                if(sglOCR.Plan__r.NombredelProducto__r.Name ==strProductoLTE && sglOCR.IP__c==null && lstIPs.get(iciclo).Estado__c != 'Ocupado' && (lstOCAPN.get(sglOCR.Oportunidad__c) == lstIPs.get(iciclo).APN__c || lstOCAPN.get(sglOCR.Caso__c) == lstIPs.get(iciclo).APN__c)){
                    lstIPs.get(iciclo).Estado__c = 'Ocupado';
                    sglOCR.IP__c = lstIPs.get(iciclo).Id;
                    sglOCR.POOL_de_APN__c = lstIPs.get(iciclo).POOL_de_APN__c;
                    sglOCR.APN__c = lstIPs.get(iciclo).APN__c;
                    if(sglOCR.Oportunidad__c!=null){
                        sglOCR.Tipo_Operacion_APN__c = 'Adicion';
                        sglOCR.Tipo_de_APN__c = lstOCAPNDetails.get(sglOCR.Oportunidad__c).Tipo_de_APN__c;
                        sglOCR.Tipo_de_Plan_APN__c = lstOCAPNDetails.get(sglOCR.Oportunidad__c).Tipo_de_Plan_APN__c;
                    }else{
                        sglOCR.Tipo_de_APN__c = lstOCAPNDetails.get(sglOCR.Caso__c).Tipo_de_APN__c;
                        sglOCR.Tipo_de_Plan_APN__c = lstOCAPNDetails.get(sglOCR.Caso__c).Tipo_de_Plan_APN__c;
                    }
                    //system.debug(lstOCAPNDetails.get(sglOCR.Oportunidad__c).Tipo_de_APN__c);
                    //system.debug(lstOCAPNDetails.get(sglOCR.Oportunidad__c).Tipo_de_Plan_APN__c);
                }
                if(sglOCR.Plan__r.NombredelProducto__r.Name !=strProductoLTE && (lstOCAPN.get(sglOCR.Oportunidad__c) == lstIPs.get(iciclo).APN__c || lstOCAPN.get(sglOCR.Caso__c) == lstIPs.get(iciclo).APN__c)){
                    sglOCR.APN__c = lstIPs.get(iciclo).APN__c;
                }
                iciclo++;
            }
            if(sglOCR.APN__c==null)
                sreturn = Label.ReglaAPN001;
            if(sglOCR.Plan__r.NombredelProducto__r.Name !=strProductoLTE && lstTiposAPN.contains(sglOCR.Tipo_de_Plan_APN__c) && sglOCR.Oportunidad__c != null) 
               lstAPNVia.add(sglOCR.Oportunidad__c);
        }
        
        for(OperacionComercial__c sglOCRVia:lstOCR)
        {
            if(sglOCRVia.Oportunidad__c != null){
            	if(lstAPNVia.contains(sglOCRVia.Oportunidad__c))
            		lstOCAsocAPN.add(sglOCRVia);
            }
        }
        if(String.isBlank(sreturn)){
        	BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
            update lstIPs;
            update lstOCR;
        	BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
            //OCViaLineas(lstOCAsocAPN);
        }
        return sreturn;
    }

	//lstOCAPN = <Id Oportunidad, Id APN>
	public static String OCAsociaPool(Map <Id, Id> lstOCAPN, Map <Id, OperacionComercial__c> lstOCAPNDetails){
        //Asigna los Pool a los OC de linea asociados al OC de APN
        //
		system.debug('Ingreso a la clase ProcesosAPN_cls.OCAsociaPool');
        
        Map<string,LTE_APN__c> vGlobalAPN = LTE_APN__c.getAll();
         Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        String strTiposAPN = vGlobalAPN.get('TiposAPN').valor__c;
        String strProductoLTE = vGlobal.get('NombreComercialLTE').valor__c;
        Set<String> lstTiposAPN = new Set<String>(strTiposAPN.split(','));
        list<OperacionComercial__c> lstOCAsocAPN = new list<OperacionComercial__c>();
        Set<Id> lstAPNVia = new Set<Id>();
		
        String sreturn = '';
		List<POOL_APN__c> lstPools = [SELECT Id, APN__c, Producto__c FROM POOL_APN__c WHERE APN__c = :lstOCAPN.values()];
		List<OperacionComercial__c> lstOCR = [
            SELECT Id, Oportunidad__c, Caso__c, Pool_de_APN_Chico__c, Pool_de_APN_Autopista__c, APN__c, Tipo_de_APN__c, Tipo_de_Plan_APN__c, Tipo_Operacion_APN__c, Plan__r.NombredelProducto__r.Name,
            (SELECT Id FROM Viabilidades__r WHERE Respuestadeviabilidad__c!=:Label.EnvioVia_RtaNoViab or EstadoViabilidad__c!=:Label.EnvioVia_EstCerrado)
            FROM OperacionComercial__c 
            WHERE Oportunidad__c = :lstOCAPN.keySet() OR Caso__c = :lstOCAPN.keySet()];
		// Incluir condicion que evalua si se pueden asociar o no
		Integer keepciclo = 0;
        Integer iciclo = 0;
        for(OperacionComercial__c sglOCR:lstOCR)
        {
            iciclo = 0;
            keepciclo = 0;
            while (iciclo < lstPools.size() && keepciclo<2){
                if(sglOCR.Plan__r.NombredelProducto__r.Name ==strProductoLTE && sglOCR.Pool_de_APN_Chico__c==null && lstPools.get(iciclo).Producto__c=='INTERNET CHICO' && (lstOCAPN.get(sglOCR.Oportunidad__c) == lstPools.get(iciclo).APN__c || lstOCAPN.get(sglOCR.Caso__c) == lstPools.get(iciclo).APN__c)){
                    sglOCR.Pool_de_APN_Chico__c = lstPools.get(iciclo).Id;
                    sglOCR.APN__c = lstPools.get(iciclo).APN__c;
                    if(sglOCR.Oportunidad__c!=null){
                        sglOCR.Tipo_Operacion_APN__c = 'Adicion';
                        sglOCR.Tipo_de_APN__c = lstOCAPNDetails.get(sglOCR.Oportunidad__c).Tipo_de_APN__c;
                        sglOCR.Tipo_de_Plan_APN__c = lstOCAPNDetails.get(sglOCR.Oportunidad__c).Tipo_de_Plan_APN__c;
                    }else{
                        sglOCR.Tipo_de_APN__c = lstOCAPNDetails.get(sglOCR.Caso__c).Tipo_de_APN__c;
                        sglOCR.Tipo_de_Plan_APN__c = lstOCAPNDetails.get(sglOCR.Caso__c).Tipo_de_Plan_APN__c;
                    }
                    keepciclo++;
                }else if(sglOCR.Plan__r.NombredelProducto__r.Name ==strProductoLTE && sglOCR.Pool_de_APN_Autopista__c==null && lstPools.get(iciclo).Producto__c=='INTERNET AUTOPISTA' && (lstOCAPN.get(sglOCR.Oportunidad__c) == lstPools.get(iciclo).APN__c || lstOCAPN.get(sglOCR.Caso__c) == lstPools.get(iciclo).APN__c)){
                    sglOCR.Pool_de_APN_Autopista__c = lstPools.get(iciclo).Id;
                    sglOCR.APN__c = lstPools.get(iciclo).APN__c;
                    if(sglOCR.Oportunidad__c!=null)
                        sglOCR.Tipo_Operacion_APN__c = 'Adicion';
                    keepciclo++;
                }else if(sglOCR.Plan__r.NombredelProducto__r.Name !=strProductoLTE && (lstOCAPN.get(sglOCR.Oportunidad__c) == lstPools.get(iciclo).APN__c || lstOCAPN.get(sglOCR.Caso__c) == lstPools.get(iciclo).APN__c)){
                    sglOCR.APN__c = lstPools.get(iciclo).APN__c;
                    if(lstTiposAPN.contains(sglOCR.Tipo_de_Plan_APN__c) && sglOCR.Oportunidad__c != null)
                        lstAPNVia.add(sglOCR.Oportunidad__c);
                    keepciclo=2;
                }else if(sglOCR.Plan__r.NombredelProducto__r.Name ==strProductoLTE && sglOCR.Pool_de_APN_Autopista__c!=null && sglOCR.Pool_de_APN_Chico__c!=null){
                    keepciclo=2;
                }
                iciclo++;
            }
            //if(sglOCR.APN__c==null)
            //    sreturn = Label.ReglaAPN002;
		}
        
        for(OperacionComercial__c sglOCRVia:lstOCR)
        {
            //Tener en cuenta que solo funciona para oportunidades
            if(sglOCRVia.Oportunidad__c != null){
                if(lstAPNVia.contains(sglOCRVia.Oportunidad__c))
                    lstOCAsocAPN.add(sglOCRVia);
            }
        }
        if(String.isBlank(sreturn)){
        	BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
            update lstOCR;
        	BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
            //OCViaLineas(lstOCAsocAPN);
        }
        return sreturn;
    }
    
    //lstOCAPN = <Id Oportunidad/Id Caso/Id OC>
	public static void OCDesasociaAPN(Set <Id> lstOCAPN, Schema.sObjectType sTypeGeneric, Map <Id,SObject> NewObject){
        //Elimina la relacion entre los pools y los OC de linea asociados al OC de APN
        //
		system.debug('Ingreso a la clase ProcesosAPN_cls.OCDesasociaAPNAC');
		
        List<SObject> lstOCR;
        List<SObject> lstOCRtoUpdate;
        SObject RegistroActual;
        String IdRegistro;
        List<IP__c> lstIPs = new List<IP__c>();
		IP__c sglIP = new IP__c();
        APN__c sAPN = new APN__c();
        List<APN__c> lstAPN = new List<APN__c>();
        POOL_APN__c poolAPN = new POOL_APN__c();
        List<POOL_APN__c> lstPoolAPN = new List<POOL_APN__c>();
        
        if(sTypeGeneric == Schema.OperacionComercial__c.getSObjectType()){
        	lstOCR = [SELECT Id, Estado__c, Oportunidad__c, IP__c, IP__r.Estado__c, POOL_de_APN__c, POOL_de_APN__r.Estado__c, APN__c, APN__r.Cuenta_Cliente__c, Tipo_de_APN__c, Pool_de_APN_Autopista__c, Pool_de_APN_Chico__c FROM OperacionComercial__c WHERE Oportunidad__c = :lstOCAPN OR Caso__c = :lstOCAPN OR Id = :lstOCAPN];
        	lstOCRtoUpdate = new List<OperacionComercial__c>();
        }
        else if(sTypeGeneric == Schema.ActivoETB__c.getSObjectType()){
        	lstOCR = [SELECT Id, Estado__c, Oportunidad__c, IP__c, IP__r.Estado__c, POOL_de_APN__c, POOL_de_APN__r.Estado__c, APN__c, APN__r.Cuenta_Cliente__c, Tipo_de_APN__c, Pool_de_APN_Autopista__c, Pool_de_APN_Chico__c FROM ActivoETB__c WHERE Oportunidad__c = :lstOCAPN OR Id = :lstOCAPN];
        	lstOCRtoUpdate = new List<ActivoETB__c>();
        }
		else
            return;
        
		for(SObject sglOCR:lstOCR){
            if(sglOCR.get('APN__c') != null){
                sAPN = (APN__c)sglOCR.getSObject('APN__r');
                sAPN.Cuenta_Cliente__c = null;
                sAPN.APN_Cliente_Virtual__c = null;
                sAPN.IP_Pool_Destino__c = null;
                sAPN.IP_Totales__c = 0;
                sAPN.IP_Disponibles__c = 0;
				lstAPN.add(sAPN);
			}
            IdRegistro = String.valueOf(sglOCR.get('Id'));
            if(NewObject.containsKey(IdRegistro)){
                RegistroActual = NewObject.get(IdRegistro);
                RegistroActual.put('IP__c', null);
                RegistroActual.put('POOL_de_APN__c', null);
                RegistroActual.put('APN__c', null);
                RegistroActual.put('Pool_de_APN_Autopista__c', null);
                RegistroActual.put('Pool_de_APN_Chico__c', null);
            }else{
                if(sglOCR.get('Estado__c') != 'Declinada' && sTypeGeneric == Schema.OperacionComercial__c.getSObjectType()){
                    sglOCR.put('Estado__c','Declinada');
                }
                sglOCR.put('IP__c', null);
                sglOCR.put('POOL_de_APN__c', null);
                sglOCR.put('APN__c', null);
                sglOCR.put('Pool_de_APN_Autopista__c', null);
                sglOCR.put('Pool_de_APN_Chico__c', null);
                lstOCRtoUpdate.add(sglOCR);
            }
        }
        
        lstIPs = [SELECT id FROM IP__c WHERE APN__c IN :lstAPN];
        for(IP__c ip : lstIPs){
            ip.Estado__c = 'Disponible';
            ip.APN__c = null;
        }
        lstPoolAPN = [SELECT id FROM POOL_APN__c WHERE APN__c IN :lstAPN];
        for(POOL_APN__c sPoolAPN : lstPoolAPN){
            sPoolAPN.Estado__c = 'Disponible';
            sPoolAPN.APN__c = null;
            sPoolAPN.Cuenta_Cliente__c = null;
            sPoolAPN.Cambio_de_Aprovisionamiento__c = null;
        }
        
        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
		if(!lstIPs.isEmpty())
			update lstIPs;
        if(!lstAPN.isEmpty()){
            Set<APN__c> setAPN = new Set<APN__c>();
            setAPN.addAll(lstAPN);
            lstAPN.clear();
            lstAPN.addAll(setAPN);
            update lstAPN;
        }
        if(!lstPoolAPN.isEmpty()){
            Set<POOL_APN__c> setPoolAPN = new Set<POOL_APN__c>();
            setPoolAPN.addAll(lstPoolAPN);
            lstPoolAPN.clear();
            lstPoolAPN.addAll(setPoolAPN);
            update lstPoolAPN;
        }
		if(!lstOCRtoUpdate.isEmpty())
			update lstOCRtoUpdate;
        BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
	}
    
    /*
    //lstOCAPN = <Id Oportunidad/Id Caso/Id OC>
	public static void OCViaLineas(List <OperacionComercial__c> lstOCAPN){
        list<Viabilidad__c> lstViab = new list<Viabilidad__c>();
        Viabilidad__c insVia;
        
        if(lstOCAPN.isEmpty())
            return;
        
        RecordType objRT = [select id, developername from RecordType where Developername='LTE' and SObjectType = 'Viabilidad__c'];
        for(OperacionComercial__c sglOpCom:lstOCAPN){
            if(sglOpCom.Viabilidades__r.isEmpty()){
                insVia = new Viabilidad__c();
                insVia.RecordTypeid = objRT.id;
                insVia.OperacionComercial__c = sglOpCom.id;
                insVia.EstadoViabilidad__c=Label.EnvioVia_EstPend;
                lstViab.add(insVia);
            }
        }
        insert lstViab;
    }
	*/
    
    webservice static String ActualizarEstadosOC(String varId){
        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        String productoLTE = vGlobal.get('NombreComercialLTE').valor__c;
        String sEstado = vGlobal.get('EstadoActualizaOC').valor__c;
        List<OperacionComercial__c> lstOc = new List<OperacionComercial__c>();
        
        if(String.isNotBlank(varId))
        	lstOc = [SELECT Id FROM OperacionComercial__c WHERE (caso__c = :varId OR Legalizacion__c = :varId) 
                     and Plan__r.NombredelProducto__r.Name = :productoLTE
                     and (Estado__c = 'Pendiente' or Estado__c = 'En curso')];
        
        for(OperacionComercial__c sglOC:lstOc){
            sglOC.Estado__c = sEstado;
        }
        
        if(!lstOC.isEmpty()){
            BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
            update lstOC;
            BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
        }
        return String.valueOf(lstOC.size()) + ' registros actualizados';
    }
    
    webservice static String MarcarActualizaAPN(String varId){
        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        String productoLTE = vGlobal.get('NombreComercialLTE').valor__c;
        List<OperacionComercial__c> lstOc = new List<OperacionComercial__c>();
        
        if(String.isNotBlank(varId))
        	lstOc = [SELECT Id, Aplica_APN__c FROM OperacionComercial__c WHERE (Oportunidad__c = :varId OR Caso__c = :varId) and Plan__r.NombredelProducto__r.Name = :productoLTE];
        
        for(OperacionComercial__c sglOC:lstOc){
            sglOC.Aplica_APN__c = true;
        }
        
        if(!lstOC.isEmpty())
            update lstOC;
        return String.valueOf(lstOC.size()) + ' registros actualizados';
    }

}