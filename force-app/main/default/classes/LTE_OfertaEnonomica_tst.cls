@isTest
private class LTE_OfertaEnonomica_tst {
	

	public static void CreateConfig()
    {
       List<SObject> oConfiguracionPersonalizada =LTE_DataGenerator_cls.confPersonalizadas(true);
        
        
    }

	@isTest static void test_method_one() 
	{
        construirDocumento();
		Test.startTest();
        CreateConfig();
        Pagereference vfTest = Page.LTE_OfertaEconomica_pag;
        Test.setCurrentPage(vfTest);

        Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
        
        
        LTE_NivelesDescuento__c oDescuento = new LTE_NivelesDescuento__c();
       	oDescuento.LTE_NoCuotasNivel1__c 	=	1; 
       	oDescuento.LTE_DescuentoNivel1__c 	=	50;
    	insert oDescuento;

        Reserva__c oReserva = new Reserva__c();       
        oReserva.Oportunidad__c 			= 	objOportunidad.Id;
        oReserva.LTE_CantidadPlanes__c 		=	1;
        oReserva.LTE_DescuentoEquipos__c 	= 	10;
        oReserva.LTE_Indice__c				=	0;
        oReserva.Equipo__c  				= 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id;
        oReserva.LTE_Plan__c 				= 	LTE_DataGenerator_cls.createPlanEstructurado(true).Id;
        oReserva.LTE_TipodePlan__c			=   'Principal';
        oReserva.Valor_mensual_equipo__c 	= 1000;
        insert oReserva;

        LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
        testController.continuar();
       	testController.guardarOferta();
       	oReserva.LTE_Eliminar__c = true;
       	List<Reserva__c> lstReservasBorrar = new List<Reserva__c>();
       	lstReservasBorrar.add(oReserva);
       	testController.lstOfertasBorrar = lstReservasBorrar;
       	testController.guardarOferta();

       	testController.calcularOferta();
        testController.guardarSVA();
		testController.getURLAPN();
        testController.getURLSucursales();
        testController.getURLContactos();
        testController.SeleccionMasiva();

		testController.strType = 'DtoPlan';
		testController.strNivelId = oDescuento.Id;
       	testController.strNivel = oDescuento.Name;
       	testController.intRow = 0;
        testController.svaInfo = '';
        testController.svaIndice = '';
        testController.svaTipo = '';
       	testController.actualizarTabla();

       	testController.strType = 'DtoVoz';
		testController.strNivelId = oDescuento.Id;
       	testController.strNivel = oDescuento.Name;
       	testController.intRow = 0;
       	testController.actualizarTabla();

       	testController.strType = 'DtoDato';
		testController.strNivelId = oDescuento.Id;
       	testController.strNivel = oDescuento.Name;
       	testController.intRow = 0;
       	testController.actualizarTabla();

       	testController.strType = 'BolsaVoz';
		testController.strNivelId = oDescuento.Id;
       	testController.strNivel = oDescuento.Name;
       	testController.intRow = 0;
       	testController.actualizarTabla();

       	testController.strType = 'BolsaDatos';
		testController.strNivelId = oDescuento.Id;
       	testController.strNivel = oDescuento.Name;
       	testController.intRow = 0;
       	testController.actualizarTabla();

        Test.stopTest();
	}
	
	@isTest static void test_method_two() 
	{
        construirDocumento();
		Test.startTest();
        CreateConfig();        
        Pagereference vfTest = Page.LTE_OfertaEconomica_pag;
        Test.setCurrentPage(vfTest);

        Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
        objOportunidad.LTE_Bolsa_Compartida__c = true;
        update  objOportunidad;
        List<LTE_DetalleOferta__c> lstDetalle = new List<LTE_DetalleOferta__c>();

        LTE_DetalleOferta__c oDetalleOferta = new LTE_DetalleOferta__c();
       	oDetalleOferta.LTE_Oferta_Economica__c  = 	LTE_DataGenerator_cls.CreateOfertaEconomica(true).Id;
    	oDetalleOferta.LTE_ReferenciaEquipo__c  = 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id; 	
    	oDetalleOferta.LTE_IMEI__c 				= 	'354959171428252';		  
    	oDetalleOferta.LTE_Estado__c            = 	'Pendiente';				  
    	oDetalleOferta.LTE_estadosLN__c 		= 	'';
    	insert oDetalleOferta;
    	lstDetalle.add(oDetalleOferta);  	
        
        LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
        testController.lstDetallesOferta = lstDetalle; 
        testController.validarIMEI();
        testController.continuar();
       	testController.agregarOferta();
       	testController.eliminarOferta();       	
       	testController.cerrarPagina();
        testController.validaSeleccionFlgs();
        testController.getPrepago();
        Test.stopTest();
	}

	@isTest static void test_method_three()
	{
        construirDocumento();
		Test.startTest();
        CreateConfig();
        Pagereference vfTest = Page.LTE_OfertaEconomica_pag;
        Test.setCurrentPage(vfTest);

        Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
        
        Reserva__c oReserva = new Reserva__c();       
        oReserva.Oportunidad__c 			= 	objOportunidad.Id;
        oReserva.LTE_Indice__c = 0;
        oReserva.LTE_CantidadPlanes__c 		=	1;
        oReserva.LTE_DescuentoEquipos__c 	= 	10;
        oReserva.Equipo__c  				= 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id;
        oReserva.LTE_Plan__c 				= 	LTE_DataGenerator_cls.createPlanNoEstructurado(true).Id;
        oReserva.LTE_MinutoVoz__c 			= 	LTE_DataGenerator_cls.createSubPlanVoz(true).Id;
        oReserva.LTE_DatosNavegacion__c 	= 	LTE_DataGenerator_cls.createSubPlanDatos(true).Id;
        oReserva.LTE_BolsaRecurrenteVoz__c 	= 	LTE_DataGenerator_cls.createBolsaAdiVoz(true).Id;
        oReserva.LTE_BolsaRecurrenteDatos__c= 	LTE_DataGenerator_cls.createBolsaAdiDatos(true).Id;
        oReserva.Valor_mensual_equipo__c 	= 1000;
        insert oReserva;

        LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
        testController.continuar();
       	testController.guardarOferta();
       	testController.calcularOferta();
       	testController.detalleOferta();
    	testController.guardarDetalle();
    	testController.getItems();
    	testController.ocultaColumnasPortabilidad();

    	List<String> lstIdDescuentos = new List<String>();
    	LTE_NivelesDescuento__c oDescuento = new LTE_NivelesDescuento__c(LTE_NoCuotasNivel1__c=1, LTE_DescuentoNivel1__c=50);
    	insert oDescuento;
		lstIdDescuentos.add(oDescuento.Id);
    	if(!lstIdDescuentos.isEmpty())
    	{
    		testController.borrarDescuentos(lstIdDescuentos);
    	}

        Test.stopTest();
	}

	@isTest static void test_method_four()
	{
        construirDocumento();
		Test.startTest();
        CreateConfig();    
		Pagereference vfTest = Page.LTE_OfertaEconomica_pag;
        Test.setCurrentPage(vfTest);

        Opportunity objOportunidadGanada = LTE_DataGenerator_cls.createOportunidadGanada(true);
        LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidadGanada));

        Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
        OperacionComercial__c oOperacionComercial = new OperacionComercial__c();	
	 	
		oOperacionComercial.Activo__c  		        	= LTE_DataGenerator_cls.createActivo(true).Id;
		oOperacionComercial.CuentaCliente__c           =  LTE_DataGenerator_cls.oAccount2.Id;
		oOperacionComercial.SucursalOrigen__c          =  LTE_DataGenerator_cls.createSucursal(true).Id;
		oOperacionComercial.Plan__c                    = LTE_DataGenerator_cls.createPlanes2(true).Id;
		oOperacionComercial.TOPP__c  				    = LTE_DataGenerator_cls.createTOPP(true).Id; 
		oOperacionComercial.Contacto_Administrativo__c = LTE_DataGenerator_cls.createContact(true).Id;
		oOperacionComercial.Contacto_Tecnico__c        = LTE_DataGenerator_cls.createContactoTecnico(true).Id;
		oOperacionComercial.NumerodeConvenio__c        = '987767679';//texto
		oOperacionComercial.Lineas__c                  = 'Lineas operación comercial para las clases de prueba';
		oOperacionComercial.ValorTarifaPlan__c         = 987875345;
		oOperacionComercial.Valorunicavez__c           = 345;
		oOperacionComercial.Incidencia_en_ingresos__c  = 'Prórroga';
		oOperacionComercial.Oportunidad__c			   = objOportunidad.Id;
		insert oOperacionComercial;

        LTE_OfertaEnonomica_ctr testController2 = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
        testController2.tieneOferta = true;
        testController2.getMostrarDetalleDesc();

        Reserva__c oReserva = new Reserva__c();       
        oReserva.Oportunidad__c 			= 	objOportunidad.Id;
        oReserva.LTE_CantidadPlanes__c 		=	1;
        oReserva.LTE_DescuentoEquipos__c 	= 	10;
        oReserva.Equipo__c  				= 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id;
        oReserva.LTE_MinutoVoz__c 			= 	LTE_DataGenerator_cls.createSubPlanVoz(true).Id;
        oReserva.LTE_DatosNavegacion__c 	= 	LTE_DataGenerator_cls.createSubPlanDatos(true).Id;
        oReserva.Valor_mensual_equipo__c 	= 1000;
        insert oReserva;

        LTE_DetalleOferta__c oDetalleOferta = new LTE_DetalleOferta__c();
    	oDetalleOferta.LTE_ReferenciaEquipo__c  = 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id; 	
    	oDetalleOferta.LTE_IMEI__c 				= 	'354959171428252';		  
    	oDetalleOferta.LTE_Estado__c            = 	'Pendiente';				  
    	oDetalleOferta.LTE_estadosLN__c 		= 	'';
    	oDetalleOferta.LTE_Oferta_Economica__c 	=	oReserva.Id;
    	insert oDetalleOferta;
        
        
        

		LTE_OfertaEnonomica_ctr testController3 = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));    	

		List<LTE_DetalleOferta__c> lstDetaOferta = new List<LTE_DetalleOferta__c>();

		Equipo__c oEquipo  = 	LTE_DataGenerator_cls.CreateEquipoTraido(true); 	
		for(Integer i=0; i<35; i++)
		{
			oDetalleOferta = new LTE_DetalleOferta__c();
    		oDetalleOferta.LTE_ReferenciaEquipo__c 	=	oEquipo.Id;
    		oDetalleOferta.LTE_IMEI__c 				= 	'354959171428252';		  
    		oDetalleOferta.LTE_Estado__c            = 	'Pendiente';				  
    		oDetalleOferta.LTE_estadosLN__c 		= 	'';
    		oDetalleOferta.LTE_Oferta_Economica__c 	=	oReserva.Id;
    		lstDetaOferta.add(oDetalleOferta);
		}
		insert lstDetaOferta;
		LTE_OfertaEnonomica_ctr testController4 = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
		testController4.getMostrarDetalleDesc();
		Test.stopTest();
	}
    
    @isTest static void test_method_five() 
	{
        construirDocumento();
		Test.startTest();
        CreateConfig();
        Pagereference vfTest = Page.LTE_OfertaEconomica_pag;
        Test.setCurrentPage(vfTest);

        Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
        
        Reserva__c oReserva = new Reserva__c();       
        oReserva.Oportunidad__c 			= 	objOportunidad.Id;
        oReserva.LTE_Indice__c = 0;
        oReserva.LTE_CantidadPlanes__c 		=	1;
        oReserva.LTE_DescuentoEquipos__c 	= 	10;
        oReserva.Equipo__c  				= 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id;
        oReserva.LTE_Plan__c 				= 	LTE_DataGenerator_cls.createPlanCompuesto(true, 'PLAN A LA MEDIDA CONTROL EMPRESAS').Id;
        oReserva.LTE_MinutoVoz__c 			= 	LTE_DataGenerator_cls.createSubPlanVoz(true).Id;
        oReserva.LTE_DatosNavegacion__c 	= 	LTE_DataGenerator_cls.createSubPlanDatos(true).Id;
        oReserva.LTE_BolsaRecurrenteVoz__c 	= 	LTE_DataGenerator_cls.createBolsaAdiVoz(true).Id;
        oReserva.LTE_BolsaRecurrenteDatos__c= 	LTE_DataGenerator_cls.createBolsaAdiDatos(true).Id;
        oReserva.Valor_mensual_equipo__c 	= 1000;
        insert oReserva;

        LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
        testController.continuar();
       	testController.guardarOferta();
       	testController.calcularOferta();
       	testController.detalleOferta();
    	testController.guardarDetalle();
    	testController.getItems();
    	testController.ocultaColumnasPortabilidad();

    	List<String> lstIdDescuentos = new List<String>();
    	LTE_NivelesDescuento__c oDescuento = new LTE_NivelesDescuento__c(LTE_NoCuotasNivel1__c=1, LTE_DescuentoNivel1__c=50);
    	insert oDescuento;
		lstIdDescuentos.add(oDescuento.Id);
    	if(!lstIdDescuentos.isEmpty())
    	{
    		testController.borrarDescuentos(lstIdDescuentos);
    	}

        Test.stopTest();
        
        
    }
    
    @isTest static void test_method_six() 
	{
        construirDocumento();
		Test.startTest();
        CreateConfig();
        Pagereference vfTest = Page.LTE_OfertaEconomica_pag;
        Test.setCurrentPage(vfTest);

        Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
        
        Reserva__c oReserva = new Reserva__c();       
        oReserva.Oportunidad__c 			= 	objOportunidad.Id;
        oReserva.LTE_Indice__c = 0;
        oReserva.LTE_CantidadPlanes__c 		=	1;
        oReserva.LTE_DescuentoEquipos__c 	= 	10;
        oReserva.Equipo__c  				= 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id;
        oReserva.LTE_Plan__c 				= 	LTE_DataGenerator_cls.createPlanCompuesto(true, 'PLAN A LA MEDIDA CONTROL EMPRESAS').Id;
        oReserva.LTE_MinutoVoz__c 			= 	LTE_DataGenerator_cls.createSubPlanVoz(true).Id;
        oReserva.LTE_DatosNavegacion__c 	= 	LTE_DataGenerator_cls.createSubPlanDatos(true).Id;
        oReserva.LTE_BolsaRecurrenteVoz__c 	= 	LTE_DataGenerator_cls.createBolsaAdiVoz(true).Id;
        oReserva.LTE_BolsaRecurrenteDatos__c= 	LTE_DataGenerator_cls.createBolsaAdiDatos(true).Id;
        oReserva.Valor_mensual_equipo__c 	= 1000;
        insert oReserva;

        LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
        testController.continuar();
       	testController.guardarOferta();
       	testController.calcularOferta();
       	testController.detalleOferta();
    	testController.guardarDetalle();
    	testController.getItems();
        testController.ocultaColumnasPortabilidad();
        
        testController.strNivelAPNId = '';
        testController.strInfoParamAPN = 'APN';
        testController.actualizarAPN();
        testController.strInfoParamAPN = 'CNT';
        testController.actualizarAPN();
        testController.strInfoParamAPN = 'SRL';
        testController.actualizarAPN();
        

        Test.stopTest();        
        
    }
    static void construirDocumento(){
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'search5';
        document.IsPublic = true;
        document.Name = 'search';
        document.FolderId = [SELECT Id FROM Folder where Type = 'Document' LIMIT 1].id;
        insert document; 
    }
    @isTest static void test_method_seven() {
        construirDocumento();
		Test.startTest();
        CreateConfig();
        Pagereference vfTest = Page.LTE_OfertaEconomica_pag;
        Test.setCurrentPage(vfTest);
        Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
        LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
        testController.validarConfiguracionBolsaCompartida();
        Test.stopTest();    
    }
    
    @isTest static void test_method_getMostrarComponenteCampana() {
        
		Test.startTest();
            
        CatalogoProductos__c objProducto = new CatalogoProductos__c();
        objProducto.Name = 'TELEFONIA MOVIL (LTE)';
        objProducto.Familia__c = 'LTE';
        objProducto.LineaNegocio__c = 'Redes Móviles';
        objProducto.CodigoProducto__c = '7635736';
        objProducto.Estado__c = 'Activo';
        objProducto.Descripcion__c = 'Teste';
        objProducto.AtributosEstandar__c = 'Teste';
        objProducto.Crear_Linea__c=true;
        insert objProducto;
        
        Planes__c objPlan = new Planes__c ();
        objPlan.Name = 'MOVIL ILIMIGIGAS NEGOCIOS- test';
        objPlan.NombredelProducto__c =objProducto.Id;
        objPlan.TipodePlan__c = 'Principal';
        objPlan.Tarifa__c = 96000;
        objPlan.Estado__c = 'Activo';
        objPlan.Descripcion__c = 'Plan pospago cuenta control, incluyen datos ilimitados en red 3G y 4G,  minutos ilimitados a todo destino nacional,  redes sociales definidas ilimitadas en todas las redes...';
        objPlan.CondicionesComerciales__c = 'Ilimitado Minutos Todo Destino <br>Ilimitado GB 3G/4G Navegacion <br>ilim SMS <br>Datos para redes sociales (WhatsApp, Facebook, Instagram, Twiter, Waze) ilimitados en todas las redes';
        objPlan.LTE_PlanEstructurados__c = true;
        objPlan.LTE_TipoControl__c = 'Control';
        insert objPlan;
         
        Planes__c objPlan1 = new Planes__c ();
        objPlan1.Name = 'MOVIL MIXTO 15GB-test';
        objPlan1.NombredelProducto__c = objProducto.Id;
        objPlan1.TipodePlan__c = 'Principal';
        objPlan1.Tarifa__c = 86000;
        objPlan1.Estado__c = 'Activo';
        objPlan1.Descripcion__c = 'Plan pospago cuenta control, incluyen datos ilimitados en red 3G y 4G,  minutos ilimitados a todo destino nacional,  redes sociales definidas ilimitadas en todas las redes...';
        objPlan1.CondicionesComerciales__c = 'Ilimitado Minutos Todo Destino <br>Ilimitado GB 3G/4G Navegacion <br>ilim SMS <br>Datos para redes sociales (WhatsApp, Facebook, Instagram, Twiter, Waze) ilimitados en todas las redes';
        objPlan1.LTE_PlanEstructurados__c = true;
        objPlan1.LTE_TipoControl__c = 'Control';
        insert objPlan1;
            
        //Campaign objCampania = LTE_DataGenerator_cls.createCampaign(true);
        Campaign objCampania = new Campaign();
        objCampania.Name = '100% MES 1 - CALL CENTER';
        objCampania.StartDate = Date.today();
        objCampania.EndDate = Date.today().addDays(12);
        objCampania.Status = 'Planificada';
        objCampania.Type = 'Publicidad';
          
        insert objCampania;
            
        ComponentePromocion__c objCompCampania = new ComponentePromocion__c();
        objCompCampania.Name = '100% MES 1 - CALL CENTER-MOVIL ILIMIGIGAS NEGOCIOS';
        objCompCampania.Campaign__c = objCampania.Id;
        objCompCampania.Descripcion__c = 'Descuento del 100% MES 1 y Descuento escalonado 50% MES 3-6-9-12. Solo Ventas Portadas';
        objCompCampania.Plan__c = objPlan.Id;
        objCompCampania.Producto__c = objProducto.Id;
        insert objCompCampania;

        ComponentePromocion__c objCompCampania1 = new ComponentePromocion__c();
        objCompCampania1.Name = '100% MES 2 - CALL CENTER-MOVIL ILIMIGIGAS NEGOCIOS';
        objCompCampania1.Campaign__c = objCampania.Id;
        objCompCampania1.Descripcion__c = 'Descuento del 100% MES 2 y Descuento escalonado 50% MES 3-6-9-12. Solo Ventas Portadas';
        objCompCampania1.Plan__c = objPlan1.Id;
        objCompCampania1.Producto__c = objProducto.Id;
        insert objCompCampania1;

        ReglaCampana__c objReglaCampania = new ReglaCampana__c();
        //objReglaCampania.Name = 'MOVIL ILIMIGIGAS NEGOCIOS-ONE SHOT';
        objReglaCampania.ComponenteCampana__c = objCompCampania.Id;
        objReglaCampania.TipoCampana__c = 'ONE SHOT';
        objReglaCampania.Meses__c = '1';
        objReglaCampania.Descuento__c = 100;
        insert objReglaCampania;

        SubPlanFacturacion__c subplanFact1 = new SubPlanFacturacion__c();
        subplanFact1.Name = 'Datos 15GB Promocional';
        subplanFact1.LTE_Precio__c = 0;
        subplanFact1.Estado__c ='Activo';
        subplanFact1.Codigo__c ='Datos 15 GB Promocional';
        subplanFact1.LTE_TipoSubplan__c= 'SVA-Bolsa Única vez de datos';
        subplanFact1.LTE_ServiceIndicator__c = 'false';
        subplanFact1.LTE_TypeCode__c = 'PRODUCT';
        subplanFact1.LTE_NetworkIndicator__c = 'false';
        subplanFact1.LTE_PrimaryClassificationCode__c = 'LTE SVA2 Package Class';
        insert subplanFact1;

        ReglaCampana__c objReglaCampania2 = new ReglaCampana__c();
        objReglaCampania2.ComponenteCampana__c = objCompCampania.Id;
        objReglaCampania2.TipoCampana__c = 'MAS VELOCIDAD DATOS';
        objReglaCampania2.Meses__c = '12';
        objReglaCampania2.SubPlanFacturacion__c = subplanfact1.Id;
        insert objReglaCampania2;

        ReglaCampana__c objReglaCampania3 = new ReglaCampana__c();
        objReglaCampania3.ComponenteCampana__c = objCompCampania.Id;
        objReglaCampania3.TipoCampana__c = 'RANGO';
        objReglaCampania3.Meses__c = '3-6-9-12';
        objReglaCampania3.Descuento__c = 50;
        insert objReglaCampania3;
        
        ReglaCampana__c objReglaCampania4 = new ReglaCampana__c();
        objReglaCampania4.ComponenteCampana__c = objCompCampania1.Id;
        objReglaCampania4.TipoCampana__c = 'CONVENIO';
        objReglaCampania4.Descuento__c = 50;
        insert objReglaCampania4;
            
        // Campaña SVA
        Campaign objCampania_sva = new Campaign();
        objCampania_sva.Name = 'Prueba SVA';
        objCampania_sva.StartDate = Date.today();
        objCampania_sva.EndDate = Date.today().addDays(12);
        objCampania_sva.Status = 'Planificada';
        objCampania_sva.Type = 'Publicidad';
        insert objCampania_sva;
        
        SubPlanFacturacion__c subplanFact_voz = new SubPlanFacturacion__c();
        subplanFact_voz.Name = 'SVA Voz';
        subplanFact_voz.LTE_Precio__c = 0;
        subplanFact_voz.Estado__c ='Activo';
        subplanFact_voz.Codigo__c ='SVA Voz';
        subplanFact_voz.LTE_TipoSubplan__c= 'SVA-Bolsa Recurrente de voz';
        subplanFact_voz.LTE_ServiceIndicator__c = 'false';
        subplanFact_voz.LTE_TypeCode__c = 'PRODUCT';
        subplanFact_voz.LTE_NetworkIndicator__c = 'false';
        subplanFact_voz.LTE_PrimaryClassificationCode__c = 'LTE SVA Package Class';
        insert subplanFact_voz;
            
       /* ComponentePromocion__c objCompCampania_sva_voz = new ComponentePromocion__c();
        objCompCampania_sva_voz.Name = '100% MES 1 - CALL CENTER-MOVIL ILIMIGIGAS NEGOCIOS';
        objCompCampania_sva_voz.Campaign__c = objCampania_sva.Id;
        objCompCampania_sva_voz.Descripcion__c = 'Descuento del 100% MES 1 y Descuento escalonado 50% MES 3-6-9-12. Solo Ventas Portadas';
       objCompCampania_sva_voz.SVA__c = subplanFact_voz.id;
        objCompCampania_sva_voz.Producto__c = objProducto.Id;
        insert objCompCampania_sva_voz;
        
        ReglaCampana__c objReglaCampania5 = new ReglaCampana__c();
        objReglaCampania5.ComponenteCampana__c = objCompCampania_sva_voz.Id;
        objReglaCampania5.TipoCampana__c = 'CONVENIO';
        objReglaCampania5.Descuento__c = 70;
        insert objReglaCampania5;
        
        ReglaCampana__c objReglaCampania8 = new ReglaCampana__c();
        objReglaCampania8.ComponenteCampana__c = objCompCampania_sva_voz.Id;
        objReglaCampania8.TipoCampana__c = 'RANGO';
        objReglaCampania8.Meses__c = '3-6-9-12';    
        objReglaCampania8.Descuento__c = 75;
        insert objReglaCampania8;*/
        
        SubPlanFacturacion__c subplanFact_datos = new SubPlanFacturacion__c();
        subplanFact_datos.Name = 'SVA Datos';
        subplanFact_datos.LTE_Precio__c = 0;
        subplanFact_datos.Estado__c ='Activo';
        subplanFact_datos.Codigo__c ='SVA Datos';
        subplanFact_datos.LTE_TipoSubplan__c= 'SVA-Bolsa Recurrente de datos';
        subplanFact_datos.LTE_ServiceIndicator__c = 'false';
        subplanFact_datos.LTE_TypeCode__c = 'PRODUCT';
        subplanFact_datos.LTE_NetworkIndicator__c = 'false';
        subplanFact_datos.LTE_PrimaryClassificationCode__c = 'LTE SVA Package Class';
        insert subplanFact_datos;
            
       /* ComponentePromocion__c objCompCampania_sva_datos = new ComponentePromocion__c();
        objCompCampania_sva_datos.Name = '100% MES 1 - CALL CENTER-MOVIL ILIMIGIGAS NEGOCIOS';
        objCompCampania_sva_datos.Campaign__c = objCampania_sva.Id;
        objCompCampania_sva_datos.Descripcion__c = 'Descuento del 100% MES 1 y Descuento escalonado 50% MES 3-6-9-12. Solo Ventas Portadas';
        objCompCampania_sva_datos.SVA__c = subplanFact_datos.id;
        objCompCampania_sva_datos.Producto__c = objProducto.Id;
        insert objCompCampania_sva_datos;
        
        ReglaCampana__c objReglaCampania6 = new ReglaCampana__c();
        objReglaCampania6.ComponenteCampana__c = objCompCampania_sva_datos.Id;
        objReglaCampania6.TipoCampana__c = 'CONVENIO';
        objReglaCampania6.Descuento__c = 75;
        insert objReglaCampania6;
        
        ReglaCampana__c objReglaCampania7 = new ReglaCampana__c();
        objReglaCampania7.ComponenteCampana__c = objCompCampania_sva_datos.Id;
        objReglaCampania7.TipoCampana__c = 'RANGO';
        objReglaCampania7.Meses__c = '3-6-9-12';    
        objReglaCampania7.Descuento__c = 75;
        insert objReglaCampania7;*/
            
        
 
        
        Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
        
        Reserva__c oReserva = new Reserva__c();       
        oReserva.Oportunidad__c 			= 	objOportunidad.Id;
        oReserva.LTE_Indice__c              = 0;
        oReserva.LTE_CantidadPlanes__c 		=	1;
        oReserva.Equipo__c  				= 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id;
        oReserva.LTE_Plan__c 				= 	objPlan.Id;
        insert oReserva;
        
        Reserva__c oReserva1 = new Reserva__c();       
        oReserva1.Oportunidad__c 			= 	objOportunidad.Id;
        oReserva1.LTE_Indice__c             =   1;
        oReserva1.LTE_CantidadPlanes__c 	=	1;
        oReserva1.Equipo__c  				= 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id;
        oReserva1.LTE_Plan__c 				= 	objPlan1.Id;
        
        insert oReserva1;
        
        //Opportunity objOportunidad = LTE_DataGenerator_cls.createOportunidad(true);
        //objOportunidad.LTE_Bolsa_Compartida__c = true;
        //update  objOportunidad;
        List<LTE_DetalleOferta__c> lstDetalle = new List<LTE_DetalleOferta__c>();

        LTE_DetalleOferta__c oDetalleOferta = new LTE_DetalleOferta__c();
       	oDetalleOferta.LTE_Oferta_Economica__c  = 	LTE_DataGenerator_cls.CreateOfertaEconomica(true).Id;
    	oDetalleOferta.LTE_ReferenciaEquipo__c  = 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id; 	
    	oDetalleOferta.LTE_IMEI__c 				= 	'354959171428252';		  
    	oDetalleOferta.LTE_Estado__c            = 	'Pendiente';				  
    	oDetalleOferta.LTE_estadosLN__c 		= 	'';
        oDetalleOferta.LTE_RequierePortacion__c = true; 
        oDetalleOferta.LTE_NumeroLinea__c        = '1234567890';
        oDetalleOferta.LTE_Donante__c             ='AVANTEL S.A.-00001';
        oDetalleOferta.Plan__c                   = objPlan.Id;    
    	insert oDetalleOferta;
        lstDetalle.add(oDetalleOferta);
            
        // detalle oferta SVA Voz
        LTE_DetalleOferta__c oDetalleOferta_voz = new LTE_DetalleOferta__c();
       	oDetalleOferta_voz.LTE_Oferta_Economica__c  = 	oReserva1.Id;
    	oDetalleOferta_voz.LTE_ReferenciaEquipo__c  = 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id; 	
    	oDetalleOferta_voz.LTE_IMEI__c 				= 	'354959171428252';		  
    	oDetalleOferta_voz.LTE_Estado__c            = 	'Pendiente';				  
    	oDetalleOferta_voz.LTE_estadosLN__c 		= 	'';
        oDetalleOferta_voz.LTE_RequierePortacion__c = true; 
        oDetalleOferta_voz.LTE_NumeroLinea__c        = '1234567890';
        oDetalleOferta_voz.LTE_Donante__c             ='AVANTEL S.A.-00001';
        oDetalleOferta_voz.LTE_BolsaRecurrenteVoz__c  = subplanFact_voz.Id;
        oDetalleOferta_voz.Plan__c                   = objPlan.Id;    
    	insert oDetalleOferta_voz;
         lstDetalle.add(oDetalleOferta_voz);
            
        // detalle oferta SVA Datos
        LTE_DetalleOferta__c oDetalleOferta_datos = new LTE_DetalleOferta__c();
       	oDetalleOferta_datos.LTE_Oferta_Economica__c  = 	oReserva1.Id;
    	oDetalleOferta_datos.LTE_ReferenciaEquipo__c  = 	LTE_DataGenerator_cls.CreateEquipoTraido(true).Id; 	
    	oDetalleOferta_datos.LTE_IMEI__c 				= 	'354959171428252';		  
    	oDetalleOferta_datos.LTE_Estado__c            = 	'Pendiente';				  
    	oDetalleOferta_datos.LTE_estadosLN__c 		= 	'';
        oDetalleOferta_datos.LTE_RequierePortacion__c = true; 
        oDetalleOferta_datos.LTE_NumeroLinea__c        = '1234567890';
        oDetalleOferta_datos.LTE_Donante__c             ='AVANTEL S.A.-00001';
        oDetalleOferta_datos.LTE_BolsaRecurrenteDatos__c  = subplanFact_datos.Id;
        oDetalleOferta_datos.Plan__c                   = objPlan.Id;    
    	insert oDetalleOferta_datos;
        lstDetalle.add(oDetalleOferta_datos);  	
        
        //LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
                    
        
        CreateConfig();  
        Pagereference vfTest = Page.LTE_OfertaEconomica_pag;
        Test.setCurrentPage(vfTest);
          
         LTE_OfertaEnonomica_ctr testController = new LTE_OfertaEnonomica_ctr(new Apexpages.Standardcontroller(objOportunidad));
        //testController.detalleOferta();
        testController.lstDetallesOferta = lstDetalle;
        testcontroller.generarDetalleOferta();
        testcontroller.getMostrarComponenteCampana();
      /*  
       	testcontroller.getMostrarComponenteCampanaSVAVoz();
        testcontroller.getMostrarComponenteCampanaSVADatos();
	  */
    	testController.ocultaColumnasPortabilidad();       
        testController.validarIMEI();
        testController.continuar();
        testController.guardarSVA();
        testController.guardarOferta();
        testController.validaIngresoValorMensualEquipo('NoRequerido');
        testController.marcaEliminarConsistente();
        testController.asignarSVA();
        testController.getPrepago();
        testController.agregarOferta();
        testController.eliminarOferta();
        testController.eliminarPrepago();
            	        
        
    	        
        Test.stopTest();    
    }
}