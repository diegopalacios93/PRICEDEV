public with sharing class LTE_CrearParametrizacionPostVenta_cls {
	
	list<LTE_SpecificationGroupXA__c> spGrXA=new list<LTE_SpecificationGroupXA__c>();

	public servAdicSpcGrXA initCambioDeplan(set<Id> sadIds, string obj){
		
		//map<String,list<LTE_DetalleOferta__c>> planesDetOf=new map<String,list<LTE_DetalleOferta__c>>();
		set<id> planes=new set<id>();
		set<id> svas=new set<id>();
		
		list<LTE_Servicios_adicionales__c> servAdici=obtenerServiciosAdicionales(sadIds,obj);
		system.debug(servAdici);
		
		for(LTE_Servicios_adicionales__c sAdc:servAdici){
			if(sAdc.LTE_PlanFacturacion__c!=null){
				system.debug('PlaFacturacion');
				planes.add(sAdc.LTE_PlanFacturacion__c);			
			}
			
			if(sAdc.LTE_SubPlaFacturacion__c!=null){
				system.debug('SubPlaFacturacion');
				svas.add(sAdc.LTE_SubPlaFacturacion__c);			
			}
		}
		
		map<Id, PlanFacturacion__c> planesParaServAd=new map<Id, PlanFacturacion__c>();
		map<Id, SubPlanFacturacion__c> subPlanesParaServAd=new map<Id, SubPlanFacturacion__c>();
		
		if(!planes.isEmpty()){
			planesParaServAd=obtieneParametroPlan(planes);		
		}
		
		system.debug(svas.size());
		if(!svas.isEmpty()){
			subPlanesParaServAd=obtieneParametroSubplan(svas);		
		}
		
		for(LTE_Servicios_adicionales__c sAdc:servAdici){
			if(planesParaServAd.get(sAdc.LTE_PlanFacturacion__c)!=null){
				planes.add(sAdc.LTE_PlanFacturacion__c);
				ParamServaAdc(sAdc,planesParaServAd.get(sAdc.LTE_PlanFacturacion__c));			               
			}
			
			if(subPlanesParaServAd.get(sAdc.LTE_SubPlaFacturacion__c)!=null){
				svas.add(sAdc.LTE_SubPlaFacturacion__c);
				ParamServaAdc(sAdc,subPlanesParaServAd.get(sAdc.LTE_SubPlaFacturacion__c));		
			}
		}
		//update servAdici;
		//insert spGrXA;

		servAdicSpcGrXA servAdicSpcGrXA=new servAdicSpcGrXA();
		servAdicSpcGrXA.SpgXA=spGrXA;
		servAdicSpcGrXA.servAD=servAdici;
		
		
		return servAdicSpcGrXA;

	}
	
	public void ParamServaAdc(LTE_Servicios_adicionales__c servAd,SubPlanFacturacion__c plan) {
		system.debug('Sub Plan');
		servAd.Name = plan.Name;
		servAd.LTE_ItemIdentification__c = plan.Id;
		servAd.LTE_NetworkIndicator__c = plan.LTE_NetworkIndicator__c;
		servAd.LTE_ServiceIndicator__c = plan.LTE_ServiceIndicator__c;
		servAd.LTE_PrimaryClassificationCode__c = plan.LTE_PrimaryClassificationCode__c;
		servAd.LTE_TypeCode__c = plan.LTE_TypeCode__c;
		servAd.LTE_SubPlaFacturacion__c=plan.Id;
		
		list<ParametroFacturacion__c> paramFac=plan.Parametros_de_Facturacion__r;
		if(!paramFac.isEmpty()){
			construirSpecXA(servAd,paramFac);
		}
	}
	
	public void ParamServaAdc(LTE_Servicios_adicionales__c servAd,PlanFacturacion__c plan) {
		servAd.Name = plan.Name;
		servAd.LTE_ItemIdentification__c = plan.Id;
		servAd.LTE_NetworkIndicator__c = plan.LTE_NetworkIndicator__c;
		servAd.LTE_ServiceIndicator__c = plan.LTE_ServiceIndicator__c;
		servAd.LTE_PrimaryClassificationCode__c = plan.LTE_PrimaryClassificationCode__c;
		servAd.LTE_TypeCode__c = plan.LTE_TypeCode__c;
		servAd.LTE_PlanFacturacion__c=plan.Id;
		system.debug(servAd);
		
		list<ParametroFacturacion__c> paramFac=plan.Parametros_de_Facturacion__r;
		if(!paramFac.isEmpty()){
			construirSpecXA(servAd,paramFac);
		}
	}
	
	public void construirSpecXA(LTE_Servicios_adicionales__c servAd,list<ParametroFacturacion__c> paramFac){
		String camposSVA = '';
		for(ParametroFacturacion__c p:paramFac){
			LTE_SpecificationGroupXA__c SpecXA = new LTE_SpecificationGroupXA__c();
			SpecXA.Name = p.Name;
			SpecXA.LTE_ParametroFacturacion__c = p.Id;
			SpecXA.LTE_ServiciosAdicionales__c = servAd.Id;
			
			if (p.LTE_ValorDefecto__c != null) {
				SpecXA.LTE_Value__c = p.LTE_ValorDefecto__c;
			}else if(p.Objeto__c != null && p.Campo__c != null){
                if(p.Objeto__c == 'LTE_DetalleOferta__c'){
                    camposSVA = p.Campo__c;
                    camposSVA = camposSVA.replace('LTE_OperacionComercial__r', 'LTE_OC_Tramite__r');
					SpecXA.LTE_Value__c = LibreriaUtilitaria_cls.recorreCampos((sObject)servAd,camposSVA);	
                }else{
				SpecXA.LTE_Value__c = LibreriaUtilitaria_cls.recorreCampos((sObject)servAd,p.Campo__c);	
                }
			}
            if(p.Name == 'RVC DESCUENTO INICIAL' && servAd.LTE_NivelDescuento__r.LTE_DescuentoNivel1__c!=NULL)
               SpecXA.LTE_Value__c =  String.valueOf(servAd.LTE_NivelDescuento__r.LTE_DescuentoNivel1__c);
            
            if(p.Name == 'RVC DESCUENTO DOS' && servAd.LTE_NivelDescuento__r.LTE_DescuentoNivel2__c!=NULL)
               SpecXA.LTE_Value__c =  String.valueOf(servAd.LTE_NivelDescuento__r.LTE_DescuentoNivel2__c);
            
            if(p.Name == 'RVC DESCUENTO TRES' && servAd.LTE_NivelDescuento__r.LTE_DescuentoNivel3__c!=NULL)
               SpecXA.LTE_Value__c =  String.valueOf(servAd.LTE_NivelDescuento__r.LTE_DescuentoNivel3__c);
            
            if(p.Name == 'RVC DURACION' && servAd.LTE_NivelDescuento__r.LTE_NoCuotasNivel1__c!=NULL)
               SpecXA.LTE_Value__c =  String.valueOf(servAd.LTE_NivelDescuento__r.LTE_NoCuotasNivel1__c);
            
            if(p.Name == 'RVC DURACION DOS' && servAd.LTE_NivelDescuento__r.LTE_NoCuotasNivel2__c!=NULL)
               SpecXA.LTE_Value__c =  String.valueOf(servAd.LTE_NivelDescuento__r.LTE_NoCuotasNivel2__c);
            
			spGrXA.add(SpecXA);
		}
		
		system.debug(spGrXA.size());
		//spGrXA servAd.Parametros_de_Facturacion__r	
	}
	
	
	public map<Id, PlanFacturacion__c> obtieneParametroPlan(set<Id> planesOc){        
		system.debug(planesOc);
		//Obtiene parametro plan estructurado y parametros.
		map<Id, PlanFacturacion__c>planFact = new map<Id, PlanFacturacion__c>([select Plan__c, CatalogoProductosFacturacion__c,
		        id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
		        (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c,Objeto__c from Parametros_de_Facturacion__r)
		        from PlanFacturacion__c where (id IN :planesOc)]);
		system.debug(planFact);
		return planFact;
	
	
	}
	
	public map<Id, SubPlanFacturacion__c> obtieneParametroSubplan(Set<Id> subPlanesOc){
		//Obtiene parametro sub plan estructurado y parametros.
		map<Id, SubPlanFacturacion__c>subPlanFact = new map<Id, SubPlanFacturacion__c>([select PlanFacturacion__c, PlanFacturacion__r.Name,
		        id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
		        (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c,Objeto__c from Parametros_de_Facturacion__r)
		        from SubPlanFacturacion__c where Id IN :subPlanesOc]);
		
		system.debug(subPlanFact.size()); 
		return subPlanFact;

	}
	
	public list<LTE_Servicios_adicionales__c> obtenerServiciosAdicionales(set<Id> detOfIds, string obj){
		
		string option='';
		
		if(obj=='OC'){
			option=' LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c IN :detOfIds ';
		}else if(obj=='OCSVA'){
			option=' LTE_Operacion_Comercial_SVA__c IN :detOfIds';
		}
		else{
			option=' id IN :detOfIds ';		
		}
		
		
		string query ='SELECT Id,LTE_CatalogoProducto__c,LTE_DetalleOfertaEReservadoRegContable__c,LTE_Estado__c,LTE_ItemIdentification__c,LTE_NetworkIndicator__c,LTE_ParentId__c,LTE_PlanFacturacion__c,LTE_PrimaryClassificationCode__c,LTE_ServiceActionCode__c,LTE_ServiceIndicator__c,LTE_ServicioETB__c,LTE_SubPlaFacturacion__c,LTE_TypeCode__c,Name,'
		+' LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Direccion__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Name,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Padre__r.Name,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.CodigoDane__c,'
		+' LTE_NivelDescuento__r.LTE_DescuentoNivel1__c,'
		+' LTE_NivelDescuento__r.LTE_DescuentoNivel2__c,'
		+' LTE_NivelDescuento__r.LTE_DescuentoNivel3__c,'
		+' LTE_NivelDescuento__r.LTE_NoCuotasNivel1__c,'
		+' LTE_NivelDescuento__r.LTE_NoCuotasNivel2__c,'
		+' LTE_NivelDescuento__r.LTE_NoCuotasNivel3__c,'
        +' LTE_OC_Tramite__r.NumeroCanales__c,'
        +' LTE_OC_Tramite__r.Tarifa_mensual_Bolsa_de_Moviles__c,'
		+' LTE_OC_Tramite__r.Tarifa_mensual_Troncales_SIP__c,'
        +' LTE_OC_Tramite__r.Valor__c,'
        +' LTE_OC_Tramite__r.Vigencia_Nivel_3__c,'
        +' LTE_OC_Tramite__r.Vigencia_Nivel_2__c,'
        +' LTE_OC_Tramite__r.Vigencia_Nivel_1__c,'
        +' LTE_OC_Tramite__r.Descuento_Nivel_3__c,'
        +' LTE_OC_Tramite__r.Descuento_Nivel_1__c,'
        +' LTE_OC_Tramite__r.Descuento_Nivel_2__c,'
        +' LTE_NivelDescuento__r.LTE_Nombre__c'
		+' FROM LTE_Servicios_adicionales__c'
		+' Where '+option+' and (LTE_ServiceActionCode__c!=\'DELETE\' and LTE_ServiceActionCode__c!=\'ELIMINADO\')';
		
		list<LTE_Servicios_adicionales__c> sAdicionales=Database.query(query);
		system.debug(sAdicionales.size());
		
		return sAdicionales;
	
	}
	
	public class servAdicSpcGrXA{
		public list<LTE_SpecificationGroupXA__c> SpgXA= new list<LTE_SpecificationGroupXA__c>();
		public list<LTE_Servicios_adicionales__c> servAD= new list<LTE_Servicios_adicionales__c>();
	}
	
	
	
	
}