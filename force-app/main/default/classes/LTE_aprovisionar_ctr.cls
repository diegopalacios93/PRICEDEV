public with sharing class LTE_aprovisionar_ctr {
	
	public string opcion{get;set;}
	public Integer total{get;set;}
	public List<SelectOption> options{get;set;}
	public Map<string,AprovisionamientoOnline__c> apr{get;set;}
	public boolean mostrar{get;set;}
	
	public LTE_aprovisionar_ctr(){
		
		apr = AprovisionamientoOnline__c.getall();
		options = new List<SelectOption>();
		total = Integer.valueOf(VariablesGlobales__c.getValues('aprovisionamientoOnline').Valor__c);
		system.debug(total);
		mostrar=true;
		getItems();
	}
	
	public PageReference ejecutar(){
		
		if(opcion=='Disponibilidad M6'){
			disponibilidadM6();
			apr.get(opcion).FechaEjecucion__c=Date.today();
		}
		
		if(opcion=='Aprovisionamiento'){
			aprovisionamiento();
			apr.get(opcion).FechaEjecucion__c=Date.today();		
		}

		if(opcion=='Facturacion'){
			Facturacion();
			apr.get(opcion).FechaEjecucion__c=Date.today();		
		}
		
		if(opcion=='Aprovisionamiento Tramites'){
			AprovisionamientoTramites();
			apr.get(opcion).FechaEjecucion__c=Date.today();
		}
		
		if(opcion=='AprovisionamientoAPN'){
			aprovisionamientoAPN();
			apr.get(opcion).FechaEjecucion__c=Date.today();		
		}

		if(opcion=='AprovisionamientoAPNDatos'){
			aprovisionamientoAPNDatos();
			apr.get(opcion).FechaEjecucion__c=Date.today();		
		}
        
        if(opcion=='AprovTramiteBolsaCompartida'){
			aprovisionamientoBolsaCompartida();
			apr.get(opcion).FechaEjecucion__c=Date.today();		
		}

		if(opcion=='EnvioPromocionesFacturador'){
			EnvioPromocionesFacturador();
			apr.get(opcion).FechaEjecucion__c=Date.today();		
		}
		
		List<SelectOption> o=new List<SelectOption>();
		

		for(SelectOption opt:options){
			system.debug(opt.getValue()+'-'+opcion);
			if(opt.getValue()!=opcion){
				o.add(opt);		
			}
	
		}

		options.clear();
		options=o;
		upsert apr.values();
		
		return null;
			
	}
	
	public void disponibilidadM6(){
		LTE_AvailabilitQueryOrder_bch batchA = new LTE_AvailabilitQueryOrder_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=total;
		batchA.esVIP=true;
		ID batchprocessid = Database.executeBatch(batchA, 1);
		

	}
	
	public void aprovisionamiento(){
		
		LTE_Aprovisionamiento_bch batchA = new LTE_Aprovisionamiento_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=total;
		batchA.esVIP=true;
		ID batchprocessid = Database.executeBatch(batchA, 1);
		
		
	}

	public void Facturacion(){

		LTE_CuentasFacturacion_bch facttbtch = new LTE_CuentasFacturacion_bch();
		facttbtch.limitQ = true;
		facttbtch.limiteTotal=total;
		facttbtch.esVIP=true;
		ID batchprocessid = Database.executeBatch(facttbtch,10);
		system.debug('==>batchprocessid:'+batchprocessid);

	}	
	
	public void AprovisionamientoTramites(){

		LTE_AprovisionamientoTramites_bch batchA = new LTE_AprovisionamientoTramites_bch();
		batchA.limitQ = false;
		batchA.limiteTotal=total;
		batchA.esVIP=true;
		ID batchprocessid = Database.executeBatch(batchA,1);

		
	}
	
	public void aprovisionamientoAPN(){
		
		LTE_AprovisionamientoAPN_bch batchA = new LTE_AprovisionamientoAPN_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=total;
		batchA.esVIP=true;
		ID batchprocessid = Database.executeBatch(batchA, 1);
		
	}

	public void aprovisionamientoAPNDatos(){
		
		LTE_AprovisionamientoAPNDatos_bch batchA = new LTE_AprovisionamientoAPNDatos_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=total;
		batchA.esVIP=true;
		ID batchprocessid = Database.executeBatch(batchA, 1);
		
	}
    
    public void aprovisionamientoBolsaCompartida(){		
		LTE_AprovisionamientoBolsaCompartida_bch batchA = new LTE_AprovisionamientoBolsaCompartida_bch();
		batchA.limitQ = true;
		batchA.limiteTotal=total;
		batchA.esVIP=true;
		ID batchprocessid = Database.executeBatch(batchA, 1);		
	}
	
	public void EnvioPromocionesFacturador(){
		EnvioPromocionesAFacturador_bch batchPromo = new EnvioPromocionesAFacturador_bch();
		batchPromo.limitQ = true;
		batchPromo.limiteTotal=total;
		ID batchprocessid = Database.executeBatch(batchPromo, 1);	
	}

	
	public void getItems() {
		
		for(string a:apr.keySet()){
			
			if(apr.get(a).FechaEjecucion__c!=Date.today() || true){
				options.add(new SelectOption(a,a));
			}
		
		}
		
		if(options.size()==0){
			mostrar=false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se puede ejecutar el proceso de aprovisionamiento por hoy'));
		}

 	 	
  	}
	
	
	
}