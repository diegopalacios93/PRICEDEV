/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan David uribe Ruiz
Proyecto:           LTE Fase II
Descripción:        Controlador para la Venta de Troncales SIP

Cambios (Versiones)
-----------------------------------------------------
----    ----------      -----------------------------              ---------------
1.0     2016-01-18      Juan David Uribe R. (JDUR)               Creación de la clase.
***********************************************************************************************************************/
public with sharing class LTE_TroncalesSIP_ctr {
	
	private Apexpages.Standardcontroller stdController;
	public Opportunity objOportunidad						{get; set;}
	public Reserva__c objOfertaEconomica                    {get; set;}
	public OperacionComercial__c objOC						{get; set;}
	public List<Reserva__c> lstOfertas						{get; set;}
	public Boolean blnBotonContinuar						{get; set;}
	public Boolean blnBotonCerrar							{get; set;}
    public Boolean planSeleccionadoAbierto					{get; set;}
	public Boolean planSeleccionadoTroncalSIPUnif			{get; set;}
	public Boolean requiereSva 								{get; set;}
	public Map<Integer, String> svasSeleccionados			{get; set;}
	public List<SelectOption> svasTroncalSIPUnif			{get; set;}
	public List<SelectOption> tarifasMinutosAdicionales 	{get; set;}
	public List<Integer> cantidadSVAs 						{get; set;}
	public Integer cantidadSVAsSize 						{get; set;}
	public Integer cantidadSVAsTroncalSIPUnifSize			{get; set;}    
	
	private Id subPlanTroncalSIPCanales;
	private Map<Id, Planes__c> mpPlanes;
    private Map<Id, SubPlanFacturacion__c> mpSubPlanes;
	private Map<String, Id> mpTarifasMinutosAdicionales;
    private Map<string,VariablesGlobales__c> vGlobal;
	private Map<String, Id> svasTroncalSipIdByNames;
	private Map<String, List<String>> tarifasMinutosAdicionalesElegiblesSegunPlan;
		
	/**
	* Constructor de la clase
	*/
	public LTE_TroncalesSIP_ctr(ApexPages.StandardController stdController){
		List<Opportunity> lstOportunidad;
		
		this.stdController = stdController;
		this.objOportunidad = (Opportunity)stdController.getRecord();
		this.objOfertaEconomica = new Reserva__c();
		//Se pone este valor al tipo de plan para que el filtro del subplan funcione
		this.objOfertaEconomica.LTE_TipodePlan__c = 'Troncal SIP'; 
		this.objOC = new OperacionComercial__c();
		this.vGlobal = VariablesGlobales__c.getAll();
		this.blnBotonContinuar = false;
		this.blnBotonCerrar = false;
		this.requiereSva = false;
		this.tarifasMinutosAdicionales = new List<SelectOption>();
		
		lstOfertas = [SELECT Id FROM Reserva__c WHERE Oportunidad__c = :objOportunidad.Id];
		
		lstOportunidad = new List<Opportunity>();
		lstOportunidad = [SELECT Id, AccountId, Name, RecordTypeId FROM Opportunity WHERE Id = :objOportunidad.Id];
		if(!lstOportunidad.isEmpty()){
			this.objOportunidad = lstOportunidad.get(0);
		} else{ 
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No se encontró la Oportunidad.'));
			return;
		}

		this.tarifasMinutosAdicionalesElegiblesSegunPlan = new Map<String, List<String>>();
		Set<String> nombresTarifasMinutosAdicionales = new Set<String>();
		for(Plan_Tarifa_Minuto_Adicional__mdt mdRecord : [
			SELECT Plan_Name__c, Tarifa_Minuto_Adicional_Name__c
			FROM Plan_Tarifa_Minuto_Adicional__mdt
		]) {
			if(!this.tarifasMinutosAdicionalesElegiblesSegunPlan.containsKey(mdRecord.Plan_Name__c)) {
				this.tarifasMinutosAdicionalesElegiblesSegunPlan.put(mdRecord.Plan_Name__c, new List<String>());
			}
			
			this.tarifasMinutosAdicionalesElegiblesSegunPlan.get(mdRecord.Plan_Name__c).add(mdRecord.Tarifa_minuto_adicional_Name__c);
			nombresTarifasMinutosAdicionales.add(mdRecord.Tarifa_minuto_adicional_Name__c);
		}
		
		mpPlanes = new map<Id, Planes__c>([SELECT Id,Tarifa__c,Name,LTE_PlanEstructurados__c,LTE_TipoControl__c,TipodePlan__c,Pertenece_a_Troncal_SIP_Unificada__c FROM Planes__c WHERE Estado__c = 'Activo']);
		mpSubPlanes = new map<Id, SubPlanFacturacion__c>();
		mpTarifasMinutosAdicionales = new Map<String, Id>();
		for(SubPlanFacturacion__c subplan : [
			SELECT Id, LTE_Precio__c, Name, LTE_TipoSubplan__c 
			FROM SubPlanFacturacion__c
			ORDER BY Name DESC
		]) {
			mpSubPlanes.put(subplan.Id, subplan);
			if(subplan.Name == 'Troncal SIP Canales') {
				this.subPlanTroncalSIPCanales = subplan.Id;
			}
			if(nombresTarifasMinutosAdicionales.contains(subplan.Name)) {
				mpTarifasMinutosAdicionales.put(subplan.Name, subplan.Id);
			}
		}

		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.LTE_Msj_Troncal_SIP));
	}
	
	/**
	* Metodo que valida si el plan seleccionado es de tipo Troncal SIP
	*/
	public PageReference cambioPlan(){
		Planes__c planSeleccionado = mpPlanes.get(this.objOfertaEconomica.LTE_Plan__c);
		
		if(!String.isEmpty(this.objOfertaEconomica.LTE_Plan__c)){
            this.planSeleccionadoAbierto = planSeleccionado.Name.toLowerCase().contains('abierto');
			
			if(planSeleccionado.TipodePlan__c != 'Troncal SIP') {
				Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Selelccionar_Plan_Troncal_SIP));
				this.blnBotonContinuar = false;
            } else {
                this.blnBotonContinuar = true;
                
                if(String.isEmpty(this.objOfertaEconomica.LTE_DatosNavegacion__c)
                    && !planSeleccionado.Pertenece_a_Troncal_SIP_Unificada__c
                ) {
                    this.blnBotonContinuar = false;
                }

				if(this.planSeleccionadoAbierto) {
					if(tarifasMinutosAdicionalesElegiblesSegunPlan.containsKey(planSeleccionado.Name)) {
						List<SelectOption> opciones = new List<SelectOption> {
							new SelectOption('', '')
						};

						tarifasMinutosAdicionalesElegiblesSegunPlan.get(planSeleccionado.Name).sort();

						for(String nombreTarifaMinutoAdicional : tarifasMinutosAdicionalesElegiblesSegunPlan.get(planSeleccionado.Name)) {
							if(mpTarifasMinutosAdicionales.containsKey(nombreTarifaMinutoAdicional)) {
								opciones.add(new SelectOption(mpTarifasMinutosAdicionales.get(nombreTarifaMinutoAdicional), nombreTarifaMinutoAdicional));
							}
						}

						this.tarifasMinutosAdicionales = opciones;
					}

					if(String.isEmpty(this.objOfertaEconomica.Tarifa_minuto_adicional__c)) {
						this.blnBotonContinuar = false;	
					}
                }
   
                if(planSeleccionado.Pertenece_a_Troncal_SIP_Unificada__c) {
					this.planSeleccionadoTroncalSIPUnif = true;

                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.LTE_Plan_De_Troncal_SIP_Unificada));
                    if(this.objOfertaEconomica.LTE_DatosNavegacion__c == null) {
                        this.objOfertaEconomica.LTE_DatosNavegacion__c = subPlanTroncalSIPCanales;
                    }
                }
            }
		} else{
			this.blnBotonContinuar = false;
		}
		return null;
	}

	public PageReference CambioRequiereSVA() {
		if(this.cantidadSVAs == null) {
			this.cantidadSVAs = new List<Integer> { 0 };
			this.cantidadSVAsSize = 1;
		}

		if(this.svasTroncalSipIdByNames == null
			&& this.svasTroncalSIPUnif == null
		) {
			this.svasTroncalSipIdByNames = new Map<String, Id>();
			this.svasTroncalSIPUnif = new List<SelectOption>();

			for(SubPlanFacturacion__c subplan : this.mpSubPlanes.values()) {
				String filtroBolsasRecurrentes = 'Bolsa Recurrente Troncal SIP Unif';
				String filtroBolsasNoRecurrentes = 'Bolsa No Recurrente Troncal SIP Unif';

				if(subplan.Name.contains(filtroBolsasRecurrentes) || 
					subplan.Name.contains(filtroBolsasNoRecurrentes)
				) {
					this.svasTroncalSipIdByNames.put(subplan.Name, subplan.Id);
					this.svasTroncalSIPUnif.add(new SelectOption(subplan.Name, subplan.Name));
				}
			}

			this.cantidadSVAsTroncalSIPUnifSize = this.svasTroncalSIPUnif.size();
		}

		if(this.svasSeleccionados == null) {
			this.svasSeleccionados = new Map<Integer, String> {
				0 => ''
			};
		}

		return null;
	}

	public PageReference incrementarCantidadSVAs() {
		Integer numeroSiguiente = this.cantidadSVAs[this.cantidadSVAs.size() - 1] + 1;
		this.cantidadSVAs.add(numeroSiguiente);
		this.svasSeleccionados.put(numeroSiguiente, '');
		this.cantidadSVAsSize = this.cantidadSVAs.size();
		return null;
	}
	
	public PageReference reducirCantidadSVAs() {
		Integer ultimoElemento = this.cantidadSVAs.size() - 1;
		this.cantidadSVAs.remove(ultimoElemento);
		this.svasSeleccionados.put(ultimoElemento, '');
		this.cantidadSVAsSize = this.cantidadSVAs.size();
		return null;
	}

	/**
	* Metodo encargado de generar los datos para la venta de troncales SIP.
	*/
	public PageReference continuar(){
		List<Equipo__c> lstEquipos = new List<Equipo__c>();
		List<TOPP__c> lstTOPP = new List<TOPP__c>();
		List<CatalogoProductos__c> lstCatalogoProductos = new List<CatalogoProductos__c>();
		List<RecordType> lstRecordType = new list<RecordType>();
		Equipo__c objEquipo;
		LTE_DetalleOferta__c objDetalleOferta;
		ActivoETB__c objActivoETB;
		LTE_Servicios_adicionales__c objSA;
		Viabilidad__c objViabilidad;
		Decimal dcmValorTotal = 0;
		Planes__c planSeleccionado = mpPlanes.get(this.objOfertaEconomica.LTE_Plan__c);
		
		Savepoint sp = Database.setSavepoint();
		
		if(String.isEmpty(objOfertaEconomica.LTE_Plan__c)){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Debe_Seleccionar_Plan));
			return null;
		}
	
		if(String.isEmpty(objOfertaEconomica.LTE_DatosNavegacion__c)) {
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Debe_Seleccionar_SubPlan));
			return null;
		}

		if(planSeleccionado.Pertenece_a_Troncal_SIP_Unificada__c 
			&& objOfertaEconomica.LTE_DatosNavegacion__c != subPlanTroncalSIPCanales
		) {
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Debe_Seleccionar_SubPlan_Troncal_SIP_Canales));
			return null;
		}
        
        if(this.planSeleccionadoAbierto
            && String.isEmpty(objOfertaEconomica.Tarifa_minuto_adicional__c)
        ) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Debe_Seleccionar_Tarifa_Minuto_Adicional));
            return null;
        }

		if(!this.planSeleccionadoAbierto 
			&& !String.isEmpty(objOfertaEconomica.Tarifa_minuto_adicional__c)
		) {
			objOfertaEconomica.Tarifa_minuto_adicional__c = null;
		} 

		List<LTE_Servicios_adicionales__c> svasAInsertar = new List<LTE_Servicios_adicionales__c>();
		if(requiereSva) {
			String minutosPlan = '', keyword = '';

			if(planSeleccionado.Name.contains('Control')) {
				keyword = 'Control';
			} else if(planSeleccionado.Name.contains('Abierto')) {
				keyword = 'Abierto';
			}

			minutosPlan = planSeleccionado.Name.replace('Troncal SIP Unif ' + keyword + ' ', '').replace(' Min', '');
			
			List<String> listSvasSeleccionados = svasSeleccionados.values();
			List<String> listSvasSeleccionadosClone = listSvasSeleccionados.clone();

			while(!listSvasSeleccionadosClone.isEmpty()) {
				String currentValue = listSvasSeleccionadosClone[0];

				if(currentValue.contains(minutosPlan)) {
					Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No puede un SVA con la misma cantidad de minutos que el plan seleccionado'));
					return null;
				}

				listSvasSeleccionadosClone.remove(0);
				if(listSvasSeleccionadosClone.contains(currentValue)) {
					Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No puede añadir el mismo SVA más de una vez'));
					return null;
				}
			}

			for(String currentValue : listSvasSeleccionados) {
				svasAInsertar.add(new LTE_Servicios_adicionales__c(
					Name = currentValue,
					LTE_SubPlaFacturacion__c = svasTroncalSipIdByNames.get(currentValue)
				));
			}
		}

		lstTOPP = [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE LTE_Catalogo_de_Producto__r.Name = :vGlobal.get('NombreComercialLTE').valor__c AND TipodeOperacionporplan__c = 'Venta'];
		
		System.debug('lstTOPP'+ 'Entro por aqui');
		 
		if(lstTOPP.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_TOPP_No_Encontrado));
			return null;
		}
		
		lstEquipos = [SELECT Id FROM Equipo__c WHERE name = 'Equipo Traido'];
		
		if(lstEquipos.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Equipo_No_Encontrado));
			return null;
		}
		
		lstCatalogoProductos = [SELECT Id, Name FROM CatalogoProductos__c WHERE Name = :vGlobal.get('NombreComercialLTE').valor__c];
		
		if(lstCatalogoProductos.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Catalogo_No_Encontrado));
			return null;
		}
		
		lstRecordType = [SELECT id FROM RecordType WHERE DeveloperName = :lstTOPP.get(0).Tipoderegistro__c AND sObjectType='OperacionComercial__c'];
            
        if(lstRecordType.isEmpty()){
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado));
			return null;
		}

        try{
			dcmValorTotal = mpPlanes.get(this.objOfertaEconomica.LTE_Plan__c).Tarifa__c + mpSubPlanes.get(this.objOfertaEconomica.LTE_DatosNavegacion__c).LTE_Precio__c;
			
			objOfertaEconomica.Equipo__c = lstEquipos.get(0).id;
			insert objOfertaEconomica;
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'objOfertaEconomica: ' + objOfertaEconomica.Id));
			
			objDetalleOferta = new LTE_DetalleOferta__c();
			objDetalleOferta.LTE_Oferta_Economica__c = objOfertaEconomica.Id;
			objDetalleOferta.LTE_Cliente__c = this.objOportunidad.AccountId;
			objDetalleOferta.LTE_EquipoTraido__c = true;
			objDetalleOferta.LTE_Valor_Total_Plan__c = dcmValorTotal; 
			objDetalleOferta.Plan__c = this.objOfertaEconomica.LTE_Plan__c;
            objDetalleOferta.Tarifa_minuto_adicional__c = this.objOfertaEconomica.Tarifa_minuto_adicional__c;
			objDetalleOferta.LTE_TipodePlan__c = 'Troncal SIP'; 
			objDetalleOferta.LTE_DatosNavegacion__c = this.objOfertaEconomica.LTE_DatosNavegacion__c;
			insert objDetalleOferta;
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'objDetalleOferta: ' + objDetalleOferta.Id));
			
			objActivoETB = new ActivoETB__c();
			objActivoETB.RecordTypeId = Schema.SObjectType.ActivoETB__c.getRecordTypeInfosByName().get('Servicio LTE').getRecordTypeId();
			objActivoETB.Oportunidad__c = this.objOportunidad.Id;
			objActivoETB.NombredelaCuenta__c = this.objOportunidad.AccountId;
			objActivoETB.NombredelProducto__c = lstCatalogoProductos.get(0).Id;
			objActivoETB.Plan__c = this.objOfertaEconomica.LTE_Plan__c;
			objActivoETB.LTE_DetalleOferta__c = objDetalleOferta.Id;
            //objActivoETB.Estado__c = 'Activo';
			objActivoETB.Estado__c = 'Pendiente';
			insert objActivoETB;
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'objActivoETB: ' + objActivoETB.Id));
			
			//objOC = new OperacionComercial__c();
			this.objOC.CuentaCliente__c = this.objOportunidad.AccountId;
			this.objOC.Activo__c = objActivoETB.Id;
			this.objOC.Oportunidad__c = this.objOportunidad.Id;
			this.objOC.Plan__c = this.objOfertaEconomica.LTE_Plan__c;
			this.objOC.TOPP__c = lstTOPP.get(0).Id;
			this.objOC.Estado__c = 'Pendiente';
			this.objOC.RecordTypeId = lstRecordType.get(0).Id;
			//this.objOC.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('LTETroncalesSIP').getRecordTypeId();
			this.objOC.ValorTarifaPlan__c =  dcmValorTotal; 
			insert this.objOC;
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'objOC: ' + this.objOC.Id));
			
			objDetalleOferta.LTE_OperacionComercial__c = this.objOC.Id; 
			update objDetalleOferta;
			
			objSA = new LTE_Servicios_adicionales__c();
			objSA.Name = 'Troncal';
			objSA.LTE_SubPlaFacturacion__c = this.objOfertaEconomica.LTE_DatosNavegacion__c;
			objSA.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
			insert objSA;

			if(!svasAInsertar.isEmpty()) {
				for(LTE_Servicios_adicionales__c sva : svasAInsertar) {
					sva.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
				}
				insert svasAInsertar;
			}
            // Agregar subplan de facturación de tarificación de minutos.
            if(this.objOfertaEconomica.Tarifa_minuto_adicional__c != null){
                objSA = new LTE_Servicios_adicionales__c();
                objSA.Name = 'Tarifa_Minutos_Adicional';
                objSA.LTE_SubPlaFacturacion__c = this.objOfertaEconomica.Tarifa_minuto_adicional__c;
                objSA.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
                insert objSA;
            }
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'objSA: ' + objSA.Id));
			
			/* [CG] - 26/05/2016 Se inhabilita la viabilidad
            objViabilidad = new Viabilidad__c();
			objViabilidad.OperacionComercial__c = this.objOC.Id; 
			objViabilidad.RecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByName().get(vGlobal.get('ViabilidadTroncalesSIP_LTE').valor__c).getRecordTypeId();
			objViabilidad.EstadoViabilidad__c = 'Pendiente';
			insert objViabilidad;
			*/
			//Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'objViabilidad: ' + objViabilidad.Id));
			
			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.LTE_Proceso_Exitoso));
			this.blnBotonContinuar = false;
			this.blnBotonCerrar = true;
		} catch(Exception e){
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error General' + ': ' + e.getMessage()));
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getStackTraceString()));
    		Database.rollback(sp);
    		System.Debug('====================== EXCEPCION ======================');
    		System.debug( e.getMessage() + ' ' + e.getStackTraceString());
    		System.Debug('=======================================================');
    		return null;
    	}
		
		return null;
	}
    public PageReference cerrarPagina(){        
		String url;
        url = '/'+objOportunidad.Id;        
		PageReference page = new PageReference(url);
		return page;
	} 	
}