public with sharing class LTE_GeneraServAdicVentaEquipos {

	public static string DeliveryDateTime(integer codigo, OperacionComercial__c oc, tramiteLTE tr) {

		return LibreriaUtilitaria_cls.formatosFechasAprob(1, oc.CreatedDate);
	}

	public static list<LTE_DetalleOferta__c> obtenerDetalleOferta(set<Id> idOcs) {

		list<LTE_DetalleOferta__c> detalleOf = new list<LTE_DetalleOferta__c>([select id, name,
		        (Select id, LTE_CatalogoProducto__c, LTE_PlanFacturacion__c, LTE_SubPlaFacturacion__c, LTE_DetalleOfertaEReservadoRegContable__c from LTE_Servicios_adicionales__r)
		        from LTE_DetalleOferta__c where LTE_OperacionComercial__c In :idOcs]);

		return detalleOf;

	}

	public static LTE_DetalleOferta__c ConsultaDetalleOferta(String idOperacionComercial)
	{
		    system.debug('idOperacionComercial-->'+idOperacionComercial);
		    
			
			list<LTE_DetalleOferta__c> lstDetOferta = [Select l.Plan__c, l.Name, l.LTE_ValorAntesImpuestosparaServicio__c, l.LTE_ValorAntesImpuestosparaEquipo__c, l.LTE_TipoTransaccion__c,
			l.LTE_Texto__c, l.LTE_Sucursal__c, l.LTE_SolicitadoPorTercero__c, l.LTE_Sociedad__c, l.LTE_SVA_s__c, l.LTE_RequierePortacion__c, l.LTE_ReferenciaEquipo__c, 
			l.LTE_OperacionComercial__c, l.LTE_Oferta_Economica__c, l.LTE_MinutoVoz__c, l.LTE_IMEI__c, l.LTE_ICCID__c, l.LTE_Estado__c,l.LTEValorEquipoDescuento__c, 
			l.LTE_EquipoTraido__c, l.LTE_Donante__c, l.LTE_DescuentoVoz__c, l.LTE_DescuentoSobreBolsaRecurrenteVoz__c, l.LTE_DescuentoSobreBolsaRecurrenteDatos__c,
			LTE_ReferenciaEquipo__r.LTE_ModeloComercial__c,LTE_ReferenciaEquipo__r.LTE_PartNumber__c,LTE_ReferenciaEquipo__r.LTE_Marca__c, 
			l.LTE_DescuentoPlan__c, l.LTE_DescuentoEquipos__c, l.LTE_DescuentoDatos__c, l.LTE_DatosNavegacion__c, l.LTE_CantidadEquipoOrdenar__c, l.LTE_BolsaRecurrenteVoz__c,
			l.LTE_BolsaRecurrenteDatos__c, l.Id, l.CreatedDate, (Select Id, Name, CreatedDate, LTE_CatalogoProducto__c, LTE_PlanFacturacion__c, LTE_SubPlaFacturacion__c, 
			LTE_Estado__c,  LTE_ServicioETB__c, LTE_ServiceIndicator__c, LTE_TypeCode__c, LTE_NetworkIndicator__c,
			LTE_PrimaryClassificationCode__c, LTE_ItemIdentification__c, LTE_ParentId__c, LTE_ServiceActionCode__c, LTE_NivelDescuento__c 
			From LTE_Servicios_adicionales__r) 
			From LTE_DetalleOferta__c l
			Where l.LTE_OperacionComercial__c =:idOperacionComercial];
			
			
		return lstDetOferta[0];
	}

	public static void obtenerEstructuradoPosventa(OperacionComercial__c OC) {
		String idServicio;
		String idOpeComx = OC.id;
		set<id> planesOc = new set<id>();
		//for (Id i : ocsMap.keySet()) {
		
		// debe usarse el plan de pagos para la factuarcion de equipos
		list<Planes__c> lstPlanPago = [select id from Planes__c where name='PLAN DE PAGOS'];
		planesOc.add(lstPlanPago[0].id);
		
		idServicio = OC.Activo__c;
		//}
		LTE_DetalleOferta__c objDetOferta = ConsultaDetalleOferta(idOpeComx); 
		system.debug('objDetOferta-->'+objDetOferta);
		system.debug('planesOc-->'+planesOc);

		/*map<Id, LTE_DetalleOferta__c> detaOfSubpl = new map<Id, LTE_DetalleOferta__c>([select id, Name, Plan__c,
		        (select Id, Name, LTE_SubPlaFacturacion__c from LTE_Servicios_adicionales__r)
		        from LTE_DetalleOferta__c
		        where LTE_OperacionComercial__c IN : ocsMap.keySet()]);		
		system.debug('detaOfSubpl-->'+detaOfSubpl);*/
		
		Map<string, VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
		string producto = vGlobal.get('NombreFacturacionLTE').valor__c;

		//Obtiene Producto facturacion y parametros.
		map<Id, CatalogoProductosFacturacion__c>CatProd = new map<Id, CatalogoProductosFacturacion__c>([select
		        id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
		        (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from ParametrosFacturacion__r)
		        from CatalogoProductosFacturacion__c where Name = :producto
		                                                                                               ]);
		system.debug('CatProd-->'+CatProd);
		
		//Obtiene parametro plan estructurado y parametros.
		map<Id, PlanFacturacion__c>planFact = new map<Id, PlanFacturacion__c>([select Plan__c, CatalogoProductosFacturacion__c,
		        id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
		        (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from Parametros_de_Facturacion__r)
		        from PlanFacturacion__c where (Plan__c IN :planesOc)]);
		
		system.debug('planFact-->'+planFact);
		
		//Obtiene parametro sub plan estructurado y parametros.
		map<Id, SubPlanFacturacion__c>subPlanFact = new map<Id, SubPlanFacturacion__c>([select PlanFacturacion__c, PlanFacturacion__r.Name,
		        id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
		        (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from Parametros_de_Facturacion__r)
		        from SubPlanFacturacion__c where PlanFacturacion__c IN :planFact.keySet() OR PlanFacturacion__r.Name = :vGlobal.get('NombreDefaultaFacturacionLTE').valor__c
		                                                                               ]);
		system.debug('planFact-->'+planFact);

		//Homologacion plan facturacion vs plan comercial
		map<Id, Id> planComFact = new map<Id, Id>();
		//Homologacion plan facturacion vs catalogo
		map<Id, Id> planCatFact = new map<Id, Id>();

		map<Id, SalesOrderLineObj> catalogo = new map<Id, SalesOrderLineObj>();
		map<Id, SalesOrderLineObj> plan = new map<Id, SalesOrderLineObj>();
		map<Id, map<Id, SalesOrderLineObj>> subPlan = new map<Id, map<Id, SalesOrderLineObj>>();

		map<String, map<Id, SalesOrderLineObj>> subPlanDef = new map<String, map<Id, SalesOrderLineObj>>();
		
		system.debug('Antes entrarentro-->'+CatProd.keySet());
		for (Id i : CatProd.keySet()) {
			system.debug('entro-->'+CatProd.keySet());
			catalogo.put(i, crearSalesOrderLineObjProducto(CatProd.get(i)));
		}
		system.debug('catalogo-->'+catalogo);
		
		for (Id i : planFact.keySet()) {
			plan.put(i, crearSalesOrderLineObjPlan(planFact.get(i)));
			//para LTE debe existir una relacion 1-1
			system.debug(planFact.get(i).Plan__c + ' ' + i);
			planComFact.put(planFact.get(i).Plan__c, i);
			planCatFact.put(planFact.get(i).Plan__c, planFact.get(i).CatalogoProductosFacturacion__c);
		}
		system.debug('planComFact-->'+planComFact);
		system.debug('planCatFact-->'+planCatFact);
		
		subPlanDef.put(vGlobal.get('NombreDefaultaFacturacionLTE').valor__c, new map<Id, SalesOrderLineObj>());
		for (Id i : subPlanFact.keySet()) {
			if (subPlan.get(subPlanFact.get(i).PlanFacturacion__c) == null) {
				subPlan.put(subPlanFact.get(i).PlanFacturacion__c, new map<Id, SalesOrderLineObj>());
			}

			subPlan.get(subPlanFact.get(i).PlanFacturacion__c).put(i, crearSalesOrderLineObjSubPlan(subPlanFact.get(i)));

		}
		system.debug('subPlan-->'+subPlan);

		map<Id, LTE_Servicios_adicionales__c> serAdMap = new map<Id, LTE_Servicios_adicionales__c>();
		list<LTE_Servicios_adicionales__c>serAdNew = new list<LTE_Servicios_adicionales__c>();
		list<SalesOrderLineObj> soLst = new list<SalesOrderLineObj>();

		/******************/
		//Obtiene los servicios adicionales para la creacion del plan No Estructurado

			//system.debug(sId + ' ' + i); //a0m5600000004i7AAA
			//SalesOrderLineObj sObj = plan.get(sId).clone();
			SalesOrderLineObj sObj = plan.values().get(0).clone();
			sObj.servAd.LTE_DetalleOfertaEReservadoRegContable__c = objDetOferta.id;
			soLst.add(sObj);

			//system.debug('catalogo.get(cId)-->'+catalogo.get(cId));
			for (Id j : catalogo.keySet()) {
				system.debug('catalogo-->'+catalogo);
				SalesOrderLineObj sObjCat = catalogo.get(j);
				sObjCat.servAd.LTE_DetalleOfertaEReservadoRegContable__c = objDetOferta.id;
				soLst.add(sObjCat);
			}
			system.debug('subPlan.keySet()-->'+subPlan.keySet());
			for (Id ii : subPlan.keySet()) {
				system.debug('ii-->'+ii);
				for (Id Iy : subPlan.get(ii).keySet()) {
					system.debug('subPlan.get(ii).get(Iy)-->'+subPlan.get(ii).get(Iy));
					SalesOrderLineObj suObj = subPlan.get(ii).get(Iy);
					suObj.servAd.LTE_DetalleOfertaEReservadoRegContable__c = objDetOferta.id;
					if(suObj.servAd.Name=='PLAN DE PAGOS'|| suObj.servAd.Name=='EQUIPO PROPIEDAD CLIENTE')
					soLst.add(suObj);

				}
			}
		//}


		for (SalesOrderLineObj sObjNew : soLst) {
			serAdNew.add(sObjNew.servAd);
		}
		system.debug('Insert-->'+serAdNew);
		insert serAdNew;
		/******************/

		/******************/
		list<LTE_SpecificationGroupXA__c> datos = new list<LTE_SpecificationGroupXA__c>();
		for (SalesOrderLineObj sObjNew : soLst) {
			datos.addAll(sObjNew.asignarId());
		}

		insert datos;
		/******************/



		/*
		//Obtenemos parametros del plan y los
		map<Id,PlanFacturacion__c> planFac=new map<Id,PlanFacturacion__c>([select id,name,
		LTE_NetworkIndicator__c,LTE_PrimaryClassificationCode__c,LTE_ServiceIndicator__c
		from PlanFacturacion__c where Id IN :planesOc or Name='DEFAULT FACTURACION LTE']);
		*/



		//map<Id,Parametros_de_Facturacion__c> paramEstruc=new map<Id,Parametros_de_Facturacion__c>([select id,name,Campo__c,Comillas__c,LTE_ValorDefecto__c,LTE_Funcion__c from Parametros_de_Facturacion__c]);

		obtenerNoEstructurado(serAdMap);

	}
	
	public static void obtenerEstructurado(map<id, OperacionComercial__c> ocsMap) {
		String idServicio;
		set<id> planesOc = new set<id>();
		for (Id i : ocsMap.keySet()) {
			planesOc.add(ocsMap.get(i).Plan__c);
			idServicio = ocsMap.get(i).Activo__c;
		}
		system.debug('planesOc-->'+planesOc);

		/*map<Id, LTE_DetalleOferta__c> detaOfSubpl = new map<Id, LTE_DetalleOferta__c>([select id, Name, Plan__c,
		        (select Id, Name, LTE_SubPlaFacturacion__c from LTE_Servicios_adicionales__r)
		        from LTE_DetalleOferta__c
		        where LTE_OperacionComercial__c IN : ocsMap.keySet()]);		
		system.debug('detaOfSubpl-->'+detaOfSubpl);*/
		
		Map<string, VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
		string producto = vGlobal.get('NombreFacturacionLTE').valor__c;

		//Obtiene Producto facturacion y parametros.
		map<Id, CatalogoProductosFacturacion__c>CatProd = new map<Id, CatalogoProductosFacturacion__c>([select
		        id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
		        (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from ParametrosFacturacion__r)
		        from CatalogoProductosFacturacion__c where Name = :producto
		                                                                                               ]);
		system.debug('CatProd-->'+CatProd);
		
		//Obtiene parametro plan estructurado y parametros.
		map<Id, PlanFacturacion__c>planFact = new map<Id, PlanFacturacion__c>([select Plan__c, CatalogoProductosFacturacion__c,
		        id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
		        (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from Parametros_de_Facturacion__r)
		        from PlanFacturacion__c where (Plan__c IN :planesOc)]);
		
		system.debug('planFact-->'+planFact);
		
		//Obtiene parametro sub plan estructurado y parametros.
		map<Id, SubPlanFacturacion__c>subPlanFact = new map<Id, SubPlanFacturacion__c>([select PlanFacturacion__c, PlanFacturacion__r.Name,
		        id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
		        (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from Parametros_de_Facturacion__r)
		        from SubPlanFacturacion__c where PlanFacturacion__c IN :planFact.keySet() OR PlanFacturacion__r.Name = :vGlobal.get('NombreDefaultaFacturacionLTE').valor__c
		                                                                               ]);
		system.debug('planFact-->'+planFact);

		//Homologacion plan facturacion vs plan comercial
		map<Id, Id> planComFact = new map<Id, Id>();
		//Homologacion plan facturacion vs catalogo
		map<Id, Id> planCatFact = new map<Id, Id>();

		map<Id, SalesOrderLineObj> catalogo = new map<Id, SalesOrderLineObj>();
		map<Id, SalesOrderLineObj> plan = new map<Id, SalesOrderLineObj>();
		map<Id, map<Id, SalesOrderLineObj>> subPlan = new map<Id, map<Id, SalesOrderLineObj>>();

		map<String, map<Id, SalesOrderLineObj>> subPlanDef = new map<String, map<Id, SalesOrderLineObj>>();
		
		system.debug('Antes entrarentro-->'+CatProd.keySet());
		for (Id i : CatProd.keySet()) {
			system.debug('entro-->'+CatProd.keySet());
			catalogo.put(i, crearSalesOrderLineObjProducto(CatProd.get(i)));
		}
		system.debug('catalogo-->'+catalogo);
		
		for (Id i : planFact.keySet()) {
			plan.put(i, crearSalesOrderLineObjPlan(planFact.get(i)));
			//para LTE debe existir una relacion 1-1
			system.debug(planFact.get(i).Plan__c + ' ' + i);
			planComFact.put(planFact.get(i).Plan__c, i);
			planCatFact.put(planFact.get(i).Plan__c, planFact.get(i).CatalogoProductosFacturacion__c);
		}
		system.debug('planComFact-->'+planComFact);
		system.debug('planCatFact-->'+planCatFact);
		
		subPlanDef.put(vGlobal.get('NombreDefaultaFacturacionLTE').valor__c, new map<Id, SalesOrderLineObj>());
		for (Id i : subPlanFact.keySet()) {
			if (subPlan.get(subPlanFact.get(i).PlanFacturacion__c) == null) {
				subPlan.put(subPlanFact.get(i).PlanFacturacion__c, new map<Id, SalesOrderLineObj>());
			}

			subPlan.get(subPlanFact.get(i).PlanFacturacion__c).put(i, crearSalesOrderLineObjSubPlan(subPlanFact.get(i)));

		}
		system.debug('subPlan-->'+subPlan);

		map<Id, LTE_Servicios_adicionales__c> serAdMap = new map<Id, LTE_Servicios_adicionales__c>();
		list<LTE_Servicios_adicionales__c>serAdNew = new list<LTE_Servicios_adicionales__c>();
		list<SalesOrderLineObj> soLst = new list<SalesOrderLineObj>();

		/******************/
		//Obtiene los servicios adicionales para la creacion del plan No Estructurado
		/*for (Id i : detaOfSubpl.keySet()) {
			
			for (LTE_Servicios_adicionales__c serAd : detaOfSubpl.get(i).LTE_Servicios_adicionales__r) {
				serAdMap.put(serAd.id, serAd);
			}
			//crea nuevo servicio adicional
			system.debug(detaOfSubpl.get(i).Plan__c);

			system.debug('detaOfSubpl.get(i)-->'+detaOfSubpl.get(i));

			Id sId = planComFact.get(detaOfSubpl.get(i).Plan__c);
			Id cId = planCatFact.get(detaOfSubpl.get(i).Plan__c);*/

			//system.debug(sId + ' ' + i); //a0m5600000004i7AAA
			//SalesOrderLineObj sObj = plan.get(sId).clone();
			SalesOrderLineObj sObj = plan.values().get(0).clone();
			sObj.servAd.LTE_ServicioETB__c = idServicio;
			soLst.add(sObj);

			//system.debug('catalogo.get(cId)-->'+catalogo.get(cId));
			for (Id j : catalogo.keySet()) {
				system.debug('catalogo-->'+catalogo);
				SalesOrderLineObj sObjCat = catalogo.get(j);
				sObjCat.servAd.LTE_ServicioETB__c = idServicio;
				soLst.add(sObjCat);
			}
			system.debug('subPlan.keySet()-->'+subPlan.keySet());
			for (Id ii : subPlan.keySet()) {
				system.debug('ii-->'+ii);
				for (Id Iy : subPlan.get(ii).keySet()) {
					system.debug('subPlan.get(ii).get(Iy)-->'+subPlan.get(ii).get(Iy));
					SalesOrderLineObj suObj = subPlan.get(ii).get(Iy);
					suObj.servAd.LTE_ServicioETB__c = idServicio;
					if(suObj.servAd.Name=='PLAN DE PAGOS'|| suObj.servAd.Name=='EQUIPO PROPIEDAD CLIENTE')
					soLst.add(suObj);

				}
			}
		//}


		for (SalesOrderLineObj sObjNew : soLst) {
			serAdNew.add(sObjNew.servAd);
		}
		system.debug('Insert-->'+serAdNew);
		insert serAdNew;
		/******************/

		/******************/
		list<LTE_SpecificationGroupXA__c> datos = new list<LTE_SpecificationGroupXA__c>();
		for (SalesOrderLineObj sObjNew : soLst) {
			datos.addAll(sObjNew.asignarId());
		}

		insert datos;
		/******************/



		/*
		//Obtenemos parametros del plan y los
		map<Id,PlanFacturacion__c> planFac=new map<Id,PlanFacturacion__c>([select id,name,
		LTE_NetworkIndicator__c,LTE_PrimaryClassificationCode__c,LTE_ServiceIndicator__c
		from PlanFacturacion__c where Id IN :planesOc or Name='DEFAULT FACTURACION LTE']);
		*/



		//map<Id,Parametros_de_Facturacion__c> paramEstruc=new map<Id,Parametros_de_Facturacion__c>([select id,name,Campo__c,Comillas__c,LTE_ValorDefecto__c,LTE_Funcion__c from Parametros_de_Facturacion__c]);

		obtenerNoEstructurado(serAdMap);

	}

	public static SalesOrderLineObj crearSalesOrderLineObjProducto(CatalogoProductosFacturacion__c cp) {
		system.debug('crearSalesOrderLineObjProducto-->'+cp);
		SalesOrderLineObj salesObj = new SalesOrderLineObj();

		salesObj.servAd = new LTE_Servicios_adicionales__c();
		salesObj.servAd.Name = cp.Name;
		salesObj.servAd.LTE_ItemIdentification__c = cp.Id;
		salesObj.servAd.LTE_NetworkIndicator__c = cp.LTE_NetworkIndicator__c;
		salesObj.servAd.LTE_ServiceIndicator__c = cp.LTE_ServiceIndicator__c;
		salesObj.servAd.LTE_PrimaryClassificationCode__c = cp.LTE_PrimaryClassificationCode__c;
		salesObj.servAd.LTE_TypeCode__c = cp.LTE_TypeCode__c;

		list<ParametroFacturacion__c>par = cp.ParametrosFacturacion__r;

		for (ParametroFacturacion__c p : par) {
			salesObj.sXA.add(construirSpecXA(p));
		}
		system.debug('salesObj-->'+salesObj);
		return salesObj;
	}

	public static SalesOrderLineObj crearSalesOrderLineObjPlan(PlanFacturacion__c cp) {
		SalesOrderLineObj salesObj = new SalesOrderLineObj();

		salesObj.servAd = new LTE_Servicios_adicionales__c();
		salesObj.servAd.Name = cp.Name;
		salesObj.servAd.LTE_ItemIdentification__c = cp.Id;
		salesObj.servAd.LTE_NetworkIndicator__c = cp.LTE_NetworkIndicator__c;
		salesObj.servAd.LTE_ServiceIndicator__c = cp.LTE_ServiceIndicator__c;
		salesObj.servAd.LTE_PrimaryClassificationCode__c = cp.LTE_PrimaryClassificationCode__c;
		salesObj.servAd.LTE_TypeCode__c = cp.LTE_TypeCode__c;

		list<ParametroFacturacion__c>par = cp.Parametros_de_Facturacion__r;

		for (ParametroFacturacion__c p : par) {
			salesObj.sXA.add(construirSpecXA(p));
		}
		return salesObj;
	}

	public static SalesOrderLineObj crearSalesOrderLineObjSubPlan(SubPlanFacturacion__c cp) {
		SalesOrderLineObj salesObj = new SalesOrderLineObj();

		salesObj.servAd = new LTE_Servicios_adicionales__c();
		salesObj.servAd.Name = cp.Name;
		salesObj.servAd.LTE_ItemIdentification__c = cp.Id;
		salesObj.servAd.LTE_NetworkIndicator__c = cp.LTE_NetworkIndicator__c;
		salesObj.servAd.LTE_ServiceIndicator__c = cp.LTE_ServiceIndicator__c;
		salesObj.servAd.LTE_PrimaryClassificationCode__c = cp.LTE_PrimaryClassificationCode__c;
		salesObj.servAd.LTE_TypeCode__c = cp.LTE_TypeCode__c;

		list<ParametroFacturacion__c>par = cp.Parametros_de_Facturacion__r;

		for (ParametroFacturacion__c p : par) {
			salesObj.sXA.add(construirSpecXA(p));
		}
		return salesObj;
	}



	public static void obtenerNoEstructurado(map<Id, LTE_Servicios_adicionales__c> detaOfSubpl) {

		set<id> ids = new set<id>();

		//Obtiene todos los Id de los Subplanes de los Servicios_adicionales
		for (Id idSubp : detaOfSubpl.keySet()) {
			ids.add(detaOfSubpl.get(idSubp).LTE_SubPlaFacturacion__c);
		}


		//Obtiene la informacion para construir los datos del ItemIdentification y SpecificationGroupXA
		map<Id, SubPlanFacturacion__c> subFact = new map<Id, SubPlanFacturacion__c>([select id, name,
		        LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
		        (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from Parametros_de_Facturacion__r)
		        from SubPlanFacturacion__c where Id IN : Ids]);

		//Parametros agrupados por subplan
		map<Id, list<ParametroFacturacion__c>> paramOrd = new map<Id, list<ParametroFacturacion__c>>();
		for (id i : subFact.keyset()) {
			paramOrd.put(subFact.get(i).Id, subFact.get(i).Parametros_de_Facturacion__r);
		}

		system.debug(paramOrd);

		//Parametros Generico crea una instancia de un LTE_SpecificationGroupXA__c esta sera duplicada para cada servicio adicional
		Map<Id, list<LTE_SpecificationGroupXA__c>> lstSpecXA = new Map<Id, list<LTE_SpecificationGroupXA__c>>();

		//crea los datos del ItemIdentification y los LTE_SpecificationGroupXA__c
		for (Id idSubp : detaOfSubpl.keySet()) {
			system.debug(detaOfSubpl.get(idSubp));
			system.debug(subFact);

			LTE_Servicios_adicionales__c detOf = detaOfSubpl.get(idSubp);
			detOf.LTE_NetworkIndicator__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).LTE_NetworkIndicator__c;
			detOf.LTE_ServiceIndicator__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).LTE_ServiceIndicator__c;
			detOf.LTE_PrimaryClassificationCode__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).LTE_PrimaryClassificationCode__c;
			detOf.LTE_TypeCode__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).LTE_TypeCode__c;
			detOf.LTE_ItemIdentification__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).id;

			list<ParametroFacturacion__c> parametros = paramOrd.get(detOf.LTE_SubPlaFacturacion__c);

			if (parametros != null) {
				for (ParametroFacturacion__c p : parametros) {
					system.debug('Ingreso');
					if (lstSpecXA.get(idSubp) == null) {
						lstSpecXA.put(idSubp, new list<LTE_SpecificationGroupXA__c>());
					}
					lstSpecXA.get(idSubp).add(construirSpecXA(p));
				}
			}

			system.debug(lstSpecXA);

			list<LTE_SpecificationGroupXA__c> finalSpeXG = new list<LTE_SpecificationGroupXA__c>();

			for (Id idSub : detaOfSubpl.keySet()) {
				//obtiene la instancia generica y crea el SpecificationGroupXA
				list<LTE_SpecificationGroupXA__c>lstSpgXa = lstSpecXA.get(idSubp);
				system.debug(lstSpgXa);


				for (LTE_SpecificationGroupXA__c sGXA : lstSpgXa) {
					finalSpeXG.add(new LTE_SpecificationGroupXA__c(
					                   Name = sGXA.Name,
					                   LTE_ServiciosAdicionales__c = idSubp,
					                   LTE_Value__c = sGXA.LTE_Value__c,
					                   LTE_ActionCode__c = 'ADD',
					                   LTE_ParametroFacturacion__c=sGXA.id
					               ));
				}

			}
			list<Sobject> upsertObj = new list<Sobject>();
			insert finalSpeXG;
			update detaOfSubpl.values();

		}
	}

	//Contiene la logica para el manejo de parametros
	public static LTE_SpecificationGroupXA__c construirSpecXA(ParametroFacturacion__c p) {
		LTE_SpecificationGroupXA__c SpecXA = new LTE_SpecificationGroupXA__c();
		SpecXA.Name = p.Name;
		SpecXA.LTE_ParametroFacturacion__c = p.Id;

		if (p.LTE_ValorDefecto__c != null) {
			SpecXA.LTE_Value__c = p.LTE_ValorDefecto__c;
		}
		return SpecXA;

	}


	public class SalesOrderLineObj {

		public LTE_Servicios_adicionales__c servAd = new LTE_Servicios_adicionales__c();
		public list<LTE_SpecificationGroupXA__c> sXA = new list<LTE_SpecificationGroupXA__c>();

		public list<LTE_SpecificationGroupXA__c> asignarId() {
			for (LTE_SpecificationGroupXA__c sx : sXA) {
				sx.LTE_ServiciosAdicionales__c = servAd.Id;
			}
			return sXA;
		}
	}

	public static void obtenerServAd(Map<Id, OperacionComercial__c> ocMap) {

		list<LTE_Servicios_adicionales__c> sAdicionales = new list<LTE_Servicios_adicionales__c>([SELECT Id, LTE_CatalogoProducto__c, LTE_DetalleOfertaEReservadoRegContable__c, LTE_Estado__c, LTE_ItemIdentification__c, LTE_NetworkIndicator__c, LTE_ParentId__c, LTE_PlanFacturacion__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_ServicioETB__c, LTE_SubPlaFacturacion__c, LTE_TypeCode__c, Name,
		        (select id, Name, LTE_Value__c from SpecificationGroupXA__r)
		        FROM LTE_Servicios_adicionales__c
		        Where LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c = :ocMap.keySet()
		                                                                                         ]);

		//return serAMap;

	}



	public class tramiteLTE {

		public string OrderType = '';
		public string OrderSubtype = '';
		public string ServiceActionCode = '';
		public string SubOrderType = '';

		public tramiteLTE(OperacionComercial__c oc) {

			if (oc.TOPP__r.TipodeOperacionporplan__c == 'Venta') {
				OrderType = 'Venta LTE';
				ServiceActionCode = 'ADD';
				OrderSubtype = 'Venta LTE';
				if (oc.Portacion__c) {
					OrderSubtype = 'Venta LTE NCP';
				}


			}



		}

		public string siguienteEstado(boolean error) {

			return '';
		}

	}





}