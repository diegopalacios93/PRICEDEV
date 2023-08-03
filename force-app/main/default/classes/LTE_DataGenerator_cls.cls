/*********************************************************************************************************
Developed by:		Avanxo
Author:				Andrés Oliva
Project's name:		ETB LTE
Description:		Create test's data for test's classes

Changes (Versions)
----------------------------------------------------------------------------------------------------------
	No.		Date			Author					    	Description
----------  -------------	---------------------------- 	----------------------------------------------
	1.0		16-06-2015		Andrés Oliva			    	Class creation.
	1.1		16-09-2015		Juan Gabriel Duarte P. (JGD)	Objetos adicionales para la Oferta Economica	
*********************************************************************************************************/
@isTest
public class LTE_DataGenerator_cls
{

    public static OperacionComercial__c oOperacionComercial {get;set;}
    public static Account oAccount  {get;set;}
    public static Account oAccount2 {get;set;}
    public static Reserva__c oReserva3 {get;set;}

    public static List<SObject>  confPersonalizadas(boolean doInsert)
    {
       List<SObject> inConf=new List<SObject>();
       inConf.add(new VariablesGlobales__c(Name='DiasDeclinacionOC',Valor__c='2'));
       inConf.add(new VariablesGlobales__c(Name='EstadoDeclinadoOC',Valor__c='Declinada'));
       inConf.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
       inConf.add(new VariablesGlobales__c(Name='NombreComercialAPN',Valor__c='APN CORPORATIVO'));
       inConf.add(new VariablesGlobales__c(Name='DetalleOfertaRegxPag',Valor__c='100'));
       inConf.add(new VariablesGlobales__c(Name='ToppRenovacion',Valor__c='Renovación'));
       inConf.add(new VariablesGlobales__c(Name='ToppReposicion',Valor__c='Reposición'));
       inConf.add(new VariablesGlobales__c(Name='LTEPerfilAnaSopLTE',Valor__c='00e330000014IxyAAE'));
       inConf.add(new VariablesGlobales__c(Name='ToppVentas',Valor__c='Venta'));
       inConf.add(new ServiciosWeb__c(Name='Remedy',EndPoint__c='http://201.245.171.239:7052/Service/BillingCorporate/Endpoint',Action__c='/Service/BillingCorporate.serviceagent//CreateIncident'));
       inConf.add(new VariablesGlobales__c(Name='EquipoTraidoLTE',Valor__c= CreateEquipoTraido(true).Id));
       inConf.add(new LTE_Planes_Compuestos__c(Name='PLAN A LA MEDIDA CONTROL EMPRESAS',MinutosVoz__c='BOLSA DE VOZ 1000 MIN', DatosNavegacion__c= 'BOLSA DE DATOS 5GB'));

       if( doInsert )
       insert inConf;  
       return inConf;    
    }
    public static list<ServiciosWeb__c>  confServicioWeb(boolean doInsert)
    {
    	list<ServiciosWeb__c> inConf = new list<ServiciosWeb__c>();
        inConf.add(new ServiciosWeb__c(Name='Remedy',EndPoint__c='http://201.245.171.239:7052/Service/BillingCorporate/Endpoint',Action__c='/Service/BillingCorporate.serviceagent//CreateIncident'));
       
       if( doInsert )
       insert inConf;  
       return inConf;
    }

     public static Opportunity createOportunity(boolean doInsert)
    {
    	Opportunity oOportunidad = new Opportunity();
    	
    	oOportunidad.Name         				=   'Oportunidad test';       
    	oOportunidad.Account      				=   createAccount(true);       
    	oOportunidad.StageName    				=   'Análisis de necesidades';
    	oOportunidad.ForecastCategoryName       =   'Negociacion';		      
    	oOportunidad.CloseDate                  =   System.today();                 
    	oOportunidad.Valor_Recurrente_Aliado__c =   39999999;				 
    	oOportunidad.Valor_unica_vez_ETB__c     =   5000000;				

       if( doInsert )
       insert oOportunidad;  
       return oOportunidad;

    }

    public static LTE_DetalleOferta__c createDetalleOfertaListasNegras( boolean doInsert )
    {
    	LTE_DetalleOferta__c oDetalleOferta = new LTE_DetalleOferta__c();

    	oDetalleOferta.LTE_Oferta_Economica__c  = oReserva3.Id;
    	oDetalleOferta.LTE_ReferenciaEquipo__c  = CreateEquipoTraido(true).Id; 	
    	oDetalleOferta.LTE_IMEI__c 				= '354959171428252';		  
    	oDetalleOferta.LTE_Estado__c            = 'Pendiente';				  
    	oDetalleOferta.LTE_estadosLN__c 		= '';	

    	
    	if( doInsert )
	    insert oDetalleOferta;
	    system.debug('\nOferta economica: \n'+ oDetalleOferta.LTE_Oferta_Economica__c );
		
		return oDetalleOferta;

    }

    public static Reserva__c CreateOfertaEconomica(boolean doInsert)
    {
    	oReserva3 = new Reserva__c();       
        oReserva3.Equipo__c      = CreateEquipoTraido(true).Id;
        oReserva3.Valor_mensual_equipo__c = 1000;
		//oReserva3.Oportunidad__c = createOportunidad(TRUE).Id;
       // oReserva3.LTE_Plan__c    = createPlanes(true).Id;


    	if( doInsert )
	    insert oReserva3;
		
		return oReserva3;

    }

    public static Equipo__c CreateEquipoTraido(boolean doInsert)
    {
       Equipo__c  oEquipo = new Equipo__c();
       oEquipo.Name                ='Equipo traido';  //Nombre comercial producto
       oEquipo.Valor_del_Equipo__c = 2000000;                    //Valor del Equipo
       oEquipo.Cantidad_Equipos__c = 3000;                       //Cantidad Equipos    = 
       oEquipo.LTE_PrecioConIVA__c = 2160000;
       oEquipo.LTE_Activo__c       = true; // JDUR 2016-01-12
       if( doInsert )
	    insert oEquipo;		
		return oEquipo;

    }

    public static Case createCase( boolean doInsert )
	{
        Case oCase = new Case();
      
          oCase.Plan__c 							 = createPlanes(true).Id;
          oCase.Contact 							 = createContact(true);
          oCase.Account 							 = createAccount(true);          
          oCase.Fechaderadicacion__c 				 = System.Today();
          oCase.Operadores__c						 = 'Operadores';
          oCase.Origin 								 = 'Correo Electrónico';
          oCase.Status 								 = 'Abierto';
          oCase.Causal_Estado__c					 = 'Confirmado';
          oCase.Subject 							 = 'Asunto: clases de prueba';	
          oCase.Description							 = 'Caso creado para la simulación del servicio Remedu';       
          oCase.CodigouniconumericoCUN__c			 = '4347150000968178';
          oCase.Nivel_1__c							 = 'LTE';
          oCase.Nivel_2__c							 = 'PROBLEMA DE COBERTURA';
          oCase.Nivel_3__c							 = 'SIN COBERTURA 4G';
          oCase.Agrupacion__c                        = 'LTE';
          oCase.LTE_Garantia__c			             = 'SOPORTE TECNICO';
          oCase.Proceso__c  						 = 'PROBLEMA DE COBERTURA';
          oCase.Tipologia__c 						 = 'SIN COBERTURA 4G';
      

		if( doInsert )
	    insert oCase;
		
		return oCase;

    }

	public static OperacionComercial__c createOperacionComercial( boolean doInsert )
	{
		 oOperacionComercial = new OperacionComercial__c();	
	 	
		 oOperacionComercial.Contacto_Administrativo__c = createContact(true).Id;
		 oOperacionComercial.Contacto_Tecnico__c        = createContactoTecnico(true).Id;
		 oOperacionComercial.Activo__c  		        = createActivo(true).Id;
		 oOperacionComercial.Plan__c                    = createPlanes2(true).Id;
		 oOperacionComercial.TOPP__c  				    = createTOPP(true).Id; 
		 oOperacionComercial.NumerodeConvenio__c        = '987767679';//texto
		 oOperacionComercial.Lineas__c                  = 'Lineas operación comercial para las clases de prueba';
		 oOperacionComercial.ValorTarifaPlan__c         = 987875345;
		 oOperacionComercial.Valorunicavez__c           = 345;
		 oOperacionComercial.Incidencia_en_ingresos__c  = 'Prórroga';
		 oOperacionComercial.CuentaCliente__c           =  oAccount2.Id;
		 oOperacionComercial.SucursalOrigen__c          =  createSucursal(true).Id;
		 oOPeracionComercial.Causal_de_Devolucion__c = 'prueba';
		 oOPeracionComercial.NumeroConexion__c = '3057000501';
		 oOPeracionComercial.LTE_Donante__c = 'AVANTEL S.A.-00001';
		 oOPeracionComercial.Portacion__c = true; 
		 system.debug('\n OPERACION COMERCIAL :\n'+oOperacionComercial);
				
		if( doInsert )
	    insert oOperacionComercial;
		
		return oOperacionComercial;
	}

	public static Contact createContact( boolean doInsert )
	{
		Contact oContact = new Contact();

        oContact.LastName     			   = 'Ramos';
        if(oAccount2==null)
            oContact.Account   				   = createAccount(true);
        else
            oContact.AccountId   		   = createAccount(true).Id;
        oContact.Ciudad__c 				   = createPoblacion(true).Id;
        oContact.NumerodeIdentificacion__c = '987354132765';
        oContact.Tipodedocumento__c        = 'Pasaporte';
        oContact.Cargo__c  				   = 'Analista';
        oContact.Area__c 				   = 'Dpto. Financiero';
        oContact.Direccion__c			   = 'KR 98B 76 F45';
        oContact.Phone           		   = '98876765';
        oContact.MobilePhone 			   = '3098268393';
        oContact.Email					   = 'test@test.com';
        oContact.Estado__c  			   = 'Activo';
        oContact.Rol__c 				   = 'Decisor';
        oContact.Genero__c  			   = 'Femenino';

        if( doInsert )
			insert oContact;
		
		return oContact;

		
	}
	public static Contact createContactoTecnico( boolean doInsert )
	{
		Contact oContact = new Contact();

        oContact.LastName     			   = 'Gutierrez';
        if(oAccount2==null)
        	oContact.Account   				   = createAccount(true);
        else
            oContact.AccountId   		   = createAccount(true).Id;
        oContact.Ciudad__c 				   = createPoblacion(true).Id;
        oContact.NumerodeIdentificacion__c = '987354132567';
        oContact.Tipodedocumento__c        = 'Pasaporte';
        oContact.Cargo__c  				   = 'Tecnico';
        oContact.Area__c 				   = 'Dpto. Financiero';
        oContact.Direccion__c			   = 'KR 98B 76 F45';
        oContact.Phone           		   = '98876765';
        oContact.MobilePhone 			   = '3096768393';
        oContact.Email					   = 'tecnico@test.com';
        oContact.Estado__c  			   = 'Activo';
        oContact.Rol__c 				   = 'Decisor';
        oContact.Genero__c  			   = 'Masculino';

        if( doInsert )
			insert oContact;
		
		return oContact;

		
	}

		public static Contact createContactoEntrega( boolean doInsert )
	{
		Contact oContact = new Contact();

        oContact.LastName     			   = 'Lopez';
        if(oAccount2==null)
        oContact.Account   				   = createAccount(true);
        else
            oContact.AccountId   		   = createAccount(true).Id;
        oContact.Ciudad__c 				   = createPoblacion(true).Id;
        oContact.NumerodeIdentificacion__c = '9873541325567';
        oContact.Tipodedocumento__c        = 'Pasaporte';
        oContact.Cargo__c  				   = 'Tecnico';
        oContact.Area__c 				   = 'Dpto. Financiero';
        oContact.Direccion__c			   = 'KR 98B 76 F45';
        oContact.Phone           		   = '98876765';
        oContact.MobilePhone 			   = '3096768393';
        oContact.Email					   = 'tecnico@test.com';
        oContact.Estado__c  			   = 'Activo';
        oContact.Rol__c 				   = 'Decisor';
        oContact.Genero__c  			   = 'Masculino';

        if( doInsert )
			insert oContact;
		
		return oContact;

		
	}


		public static Account createAccount( boolean doInsert )
	{
		//RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Cliente Principal' Limit 1];
		   oAccount2 = new Account();
				
            oAccount2.Name   			= 'Cuenta Clases de Prueba';
            oAccount2.Estado_Cuenta__c   = 'Activo';
            oAccount2.AccountSource      = 'Anillo';
            oAccount2.Direccion__c		= 'KR 64 CL89.76';
            oAccount2.Ciudad__c          = createPoblacion(true).Id;
            oAccount2.Phone              = '39087474';
            oAccount2.Description  		= 'Cuenta utilizada para las clases de prueba';
            oAccount2.Segmento__c        = 'Empresas';
            oAccount2.SubSegmento__c     = 'Grandes';
            oAccount2.TipodeAtencion__c  = 'Primaria';
            oAccount2.Tipodedocumento__c = 'NIT';
            oAccount2.AccountNumber      = '8998989898';
        	oAccount2.RecordTypeId 		 = Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Principal').getRecordTypeId();

		
		if( doInsert )
			insert oAccount2;
		return oAccount2;
	}

	/*
    RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Sucursales' Limit 1];
And now use this value further while creating the Account Record.
 
Account acc = new Account(Name='Test' , recordTypeId=rt.id);
	*/


	public static Account createSucursal( boolean doInsert )
	{
		 
		    oAccount = new Account();
		    oAccount.Cuenta__c          = oAccount2.Id;
            oAccount.Name   			= 'Sucursal Clases de Prueba';           
            oAccount.Direccion__c		= 'KR 64 CL89.76';
            oAccount.Ciudad__c          = createPoblacion(true).Id;
            oAccount.Phone              = '39087474';
            oAccount.Description  		= 'Cuenta utilizada para las clases de prueba';
            oAccount.LTE_ContactoEntrega__c = createContactoEntrega(true).Id;
        	oAccount.RecordTypeId 		 = Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('Sucursales').getRecordTypeId();
            system.debug('\nSUCURSAL INSTALACION:\n'+oAccount);

		
		if( doInsert )
			insert oAccount;
		
		return oAccount;
	}
	

	public static Poblacion__c createPoblacion( boolean doInsert )
	{ 
		Poblacion__c oPoblacion = new Poblacion__c(); 
        
        oPoblacion.Name 		  = 'Bogotá';
        oPoblacion.EsMunicipio__c = true;

		if( doInsert )
			insert oPoblacion;
		
		return oPoblacion;

	}

    public static TOPP__c createTOPP( boolean doInsert )
	{
		TOPP__c oTOPP = new TOPP__c();

		oTOPP.Name                      = 'Tipo de operación de prueba';
		oTOPP.TipodeOperacionporplan__c = 'Ampliación';
		oTOPP.ANS_Factibilidad__c       = '87'; 
		oTOPP.ANS__c                    = 58; 
		oTOPP.Plan__c                   = createPlanes(true).Id;
		
		if( doInsert )
			insert oTOPP;
		
		return oTOPP;

	}

    public static ActivoETB__c createActivo( boolean doInsert )
	{
		ActivoETB__c oActivo = new ActivoETB__c();
        if(oAccount2!=null)
            oActivo.NombredelaCuenta__c = oAccount2.Id;
		if( doInsert )
			insert oActivo;
		
		return oActivo;

	}

	public static Planes__c createPlanes( boolean doInsert )
	{
		 Planes__c oPlanes = new Planes__c();
		
		 oPlanes.Name                 	   = 'PLAN DE DATOS CONTROL 5GB';		
		 oPlanes.NombredelProducto__c 	   =  createProductos2(true).Id; 
		 oPlanes.TipodePlan__c        	   = 'Principal';  // lista (Principal,Adicionales)
		 oPlanes.Tarifa__c           	   = 50000;      //Divisa 
		 oPlanes.Estado__c           	   = 'Antivo';         //lista (Antivo,Inactivo)
		 oPlanes.Descripcion__c      	   =  'Texto';
		 oPlanes.CondicionesComerciales__c ='Condiciones Comerciales';
		
		
		if( doInsert )
			insert oPlanes;
		
		return oPlanes;
	}
	public static Planes__c createPlanes2( boolean doInsert )
	{
		 Planes__c oPlanes = new Planes__c();
		
		 oPlanes.Name                 = 'PLAN DE DATOS CONTROL 6 GB';		
		 oPlanes.NombredelProducto__c =   createProductos(true).Id; 
		 oPlanes.TipodePlan__c        ='Adicionales';  // lista (Principal,Adicionales)
		 oPlanes.Tarifa__c            = 50000;      //Divisa 
		 oPlanes.Estado__c            =  'Antivo';         //lista (Antivo,Inactivo)
		 oPlanes.Descripcion__c       =   'Texto';
		 oPlanes.CondicionesComerciales__c ='Condiciones Comerciales';
		
		
		if( doInsert )
			insert oPlanes;
		
		return oPlanes;
	}

    public static CatalogoProductos__c createProductos( boolean doInsert )
	{
		CatalogoProductos__c oCataloProd = new CatalogoProductos__c();
		
		oCataloProd.Name              = 'Samsung Galaxy';
		oCataloProd.Familia__c        = 'Conectividad IP';
		oCataloProd.LineaNegocio__c   = 'Datos';
		oCataloProd.CodigoProducto__c = 'Q2QQ3Q343R4W4R';
		oCataloProd.Estado__c         = 'Activo';
		oCataloProd.Descripcion__c    = 'Descripción de prueba';
		oCataloProd.AtributosEstandar__c = 'Atributos estandart de test';
	   
		
		if( doInsert )
			insert oCataloProd;
		
		return oCataloProd;
	}
	public static CatalogoProductos__c createProductos2( boolean doInsert )
	{
		CatalogoProductos__c oCataloProd = new CatalogoProductos__c();
		
		oCataloProd.Name              = 'TELEFONIA MOVIL (LTE)';
		oCataloProd.Familia__c        = 'Conectividad IP';
		oCataloProd.LineaNegocio__c   = 'Datos';
		oCataloProd.CodigoProducto__c = 'Q2QQ3Q343RUYTT';
		oCataloProd.Estado__c         = 'Activo';
		oCataloProd.Descripcion__c    = 'Descripción de prueba';
		oCataloProd.AtributosEstandar__c = 'Atributos estandart de test';
	   
		
		if( doInsert )
			insert oCataloProd;
		
		return oCataloProd;
	}

	//(JGD) 16/09/2015

	public static Opportunity createOportunidad( boolean doInsert )
	{
		//Obtiene los tipos de registros correspondientes al objeto OC
    	Schema.DescribeSObjectResult R = Opportunity.SObjectType.getDescribe();
    	List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
    	String strOportunidadLTE = '';
    	for(Schema.RecordTypeInfo objRT:RT)
    	{
        	if(objRT.getName().equals('LTE'))
        	{
            	System.debug('RecordTypeId LTE-> '+objRT.getRecordTypeId() );
            	strOportunidadLTE = objRT.getRecordTypeId();
        	}
    	}
        
		Opportunity oOportunidad 	= new Opportunity();
		oOportunidad.recordTypeId			= 	strOportunidadLTE;
		oOportunidad.Name           		= 	'Prueba Oportunidad';
		oOportunidad.AccountId   			= 	createAccount(true).Id;
		oOportunidad.StageName      		= 	'Análisis de necesidades';
		oOportunidad.ForecastCategoryName	= 	'En Construcción';
		oOportunidad.CloseDate 				=	System.today()+15;
		oOportunidad.Amount 				=	0;
		oOportunidad.Valor_unica_vez_ETB__c =	0;
		//Datos adicionales
		oOportunidad.LTE_NumeroLinea__c 	= 	1;
        oOportunidad.LTE_RequiereDescuentos__c = true;
        oOportunidad.LTE_PagoAnticipado__c 	= 	true;
        oOportunidad.EstadodeAprobacionDescuentos__c = 'Aprobado';
        oOportunidad.Requiere_Pago_Mensualizado_Equipo__c = true;
        oOportunidad.Numero_de_cuotas__c = 10;
	
		if( doInsert )
			insert oOportunidad;
		
		return oOportunidad;
	}

	public static Opportunity createOportunidadGanada( boolean doInsert )
	{
		//Obtiene los tipos de registros correspondientes al objeto OC
    	Schema.DescribeSObjectResult R = Opportunity.SObjectType.getDescribe();
    	List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
    	String strOportunidadLTE = '';
    	for(Schema.RecordTypeInfo objRT:RT)
    	{
        	if(objRT.getName().equals('LTE'))
        	{
            	System.debug('RecordTypeId LTE-> '+objRT.getRecordTypeId() );
            	strOportunidadLTE = objRT.getRecordTypeId();
        	}
    	}

		Opportunity oOportunidad 	= new Opportunity();
		
		oOportunidad.recordTypeId				= 	strOportunidadLTE;
		oOportunidad.Name           				= 	'Prueba Oportunidad';
		oOportunidad.AccountId   						= 	createAccount(true).Id;
		oOportunidad.StageName      				= 	'Cerrada ganada';
		oOportunidad.ForecastCategoryName			= 	'En Construcción';
		oOportunidad.CloseDate 						=	System.today()+15;
		oOportunidad.Amount 						=	0;
		oOportunidad.Valor_unica_vez_ETB__c 		=	0;
		oOportunidad.LTE_OportunidadBloqueada__c 	= true;
		if( doInsert )
			insert oOportunidad;
		
		return oOportunidad;
	}

	public static Reserva__c CreateOferta(boolean doInsert)
    {
    	Reserva__c oReserva = new Reserva__c();

        oReserva.Oportunidad__c 			= 	createOportunidad(true).Id;
        oReserva.LTE_CantidadPlanes__c 		= 	1;
        oReserva.Equipo__c  				= 	CreateEquipoTraido(true).Id;
        oReserva.LTE_Plan__c 				= 	createPlanes(true).Id;
        oReserva.Valor_mensual_equipo__c = 1000;

    	if( doInsert )
	    insert oReserva;
		
		return oReserva;
    }

    public static Planes__c createPlanEstructurado( boolean doInsert )
	{
		 Planes__c oPlanes = new Planes__c();
		
		 oPlanes.Name                 	   = 'PLAN A LA MEDIDA CONTROL EMPRESAS';		
		 oPlanes.NombredelProducto__c 	   =  createProductos2(true).Id; 
		 oPlanes.TipodePlan__c        	   = 'Principal';  // lista (Principal,Adicionales)
		 oPlanes.Tarifa__c           	   = 50000;      //Divisa 
		 oPlanes.Estado__c           	   = 'Activo';         //lista (Activo,Inactivo)
		 oPlanes.Descripcion__c      	   =  'Texto';
		 oPlanes.CondicionesComerciales__c ='Condiciones Comerciales';
		 oPlanes.LTE_PlanEstructurados__c  = true;
		
		if( doInsert )
			insert oPlanes;
		
		return oPlanes;
	}
    
    
        public static Planes__c createPlanCompuesto( boolean doInsert, String strName )
	{
		 Planes__c oPlanes = new Planes__c();
		
		 oPlanes.Name                 	   = strName;		
		 oPlanes.NombredelProducto__c 	   =  createProductos2(true).Id; 
		 oPlanes.TipodePlan__c        	   = 'Principal';  // lista (Principal,Adicionales)
		 oPlanes.Tarifa__c           	   = 50000;      //Divisa 
		 oPlanes.Estado__c           	   = 'Activo';         //lista (Activo,Inactivo)
		 oPlanes.Descripcion__c      	   = 'Texto';
		 oPlanes.CondicionesComerciales__c ='Condiciones Comerciales';
		 oPlanes.LTE_Es_Plan_Compuesto__c  = true;
		 oPlanes.LTE_PlanEstructurados__c  = false;
        
		if( doInsert )
			insert oPlanes;
		
		return oPlanes;
	}

	public static Planes__c createPlanNoEstructurado( boolean doInsert )
	{
		 Planes__c oPlanes = new Planes__c();
		
		 oPlanes.Name                 	   = 'PLAN A LA MEDIDA CONTROL EMPRESAS';		
		 oPlanes.NombredelProducto__c 	   =  createProductos2(true).Id; 
		 oPlanes.TipodePlan__c        	   = 'Principal';  // lista (Principal,Adicionales)
		 oPlanes.Tarifa__c           	   = 50000;      //Divisa 
		 oPlanes.Estado__c           	   = 'Activo';         //lista (Activo,Inactivo)
		 oPlanes.Descripcion__c      	   =  'Texto';
		 oPlanes.CondicionesComerciales__c ='Condiciones Comerciales';
		 oPlanes.LTE_PlanEstructurados__c  = false;
		
		if( doInsert )
			insert oPlanes;
		
		return oPlanes;
	}

	public static SubPlanFacturacion__c createSubPlanVoz( boolean doInsert )
	{
        
		 SubPlanFacturacion__c oSubPlanRelacionado = new SubPlanFacturacion__c();
		 oSubPlanRelacionado.Name                 	   	= 	'BOLSA DE VOZ 1000 MIN2';		
		 oSubPlanRelacionado.LTE_TipoSubplan__c 	   	=  	'Bolsa de Voz a la medida'; 
		 oSubPlanRelacionado.LTE_Precio__c 			=	55000;
		 oSubPlanRelacionado.Codigo__c 				=	'6542';
            insert oSubPlanRelacionado;
        
		 SubPlanFacturacion__c oSubPlan = new SubPlanFacturacion__c();
		 oSubPlan.Name                 	   	= 	'BOLSA DE VOZ 1000 MIN';		
		 oSubPlan.LTE_TipoSubplan__c 	   	=  	'Bolsa de Voz a la medida'; 
		 oSubPlan.LTE_Precio__c 			=	55000;
		 oSubPlan.Codigo__c 				=	'654';
        oSubPlan.Aplica_SVA_Voz_Relacionados__c = true;
		osubPlan.SVA_Voz_Relacionados__c = oSubPlanRelacionado.Id;
        
        if( doInsert ){
			insert oSubPlan;
        }
		return oSubPlan;
	}

	public static SubPlanFacturacion__c createSubPlanDatos( boolean doInsert )
	{
		 SubPlanFacturacion__c oSubPlan = new SubPlanFacturacion__c();
		
		 oSubPlan.Name                 	   	= 	'BOLSA DE DATOS 5GB';		
		 oSubPlan.LTE_TipoSubplan__c 	   	=  	'Bolsa de Datos a la medida'; 
		 oSubPlan.LTE_Precio__c 			=	47000;
		 oSubPlan.Codigo__c 				=	'32232';
		
		if( doInsert )
			insert oSubPlan;
		
		return oSubPlan;
	}

	public static SubPlanFacturacion__c createBolsaAdiDatos( boolean doInsert )
	{
		 SubPlanFacturacion__c oSubPlan = new SubPlanFacturacion__c();
		
		 oSubPlan.Name                 	   	= 	'BOLSA ADIC DE DATOS 10GB';		
		 oSubPlan.LTE_TipoSubplan__c 	   	=  	'Bolsas adicionales recurrentes Datos'; 
		 oSubPlan.LTE_Precio__c 			=	85000;
		 oSubPlan.Codigo__c 				=	'5645654';
		
		if( doInsert )
			insert oSubPlan;
		
		return oSubPlan;
	}

	public static SubPlanFacturacion__c createBolsaAdiVoz( boolean doInsert )
	{
		 SubPlanFacturacion__c oSubPlan = new SubPlanFacturacion__c();
		
		 oSubPlan.Name                 	   	= 	'BOLSA ADIC DE VOZ 1000 MIN';		
		 oSubPlan.LTE_TipoSubplan__c 	   	=  	'Bolsas adicionales recurrentes Voz'; 
		 oSubPlan.LTE_Precio__c 			=	55000;
		 oSubPlan.Codigo__c 				=	'656';
		
		if( doInsert )
			insert oSubPlan;
		
		return oSubPlan;
	}
	//FIN (JGD)
}