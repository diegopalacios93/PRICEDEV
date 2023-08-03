/***************************************************************************************************************************
*** Desarrollado por:       Avanxo Colombia                                                                              ***
*** Autor:                  Andrés Oliva (AO)                                                                            ***
*** Proyecto:               ETB - LTE                                                                                    ***
*** Descripcion:            Clase de prueba d ela clase LTE_GenerarCSV                                               ***
***                          
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***    
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***             No.     Fecha           Autor                   Descripción                                              ***    
***            -----    ----------      --------------------    ---------------                                          ***
*** @version    1.0     2015-09-16      Andrés Oliva (AO)      Class created                                             ***
***************************************************************************************************************************/
@isTest

private class LTE_GenerarOC_tst
{
	public static  OperacionComercial__c oOperacionComercial;	
	public static  Opportunity           oOportunidad;
  public static  List<SObject>         oConfiguraciones;
  public static  LTE_DetalleOferta__c  oDetalleOferta;
  public static  Reserva__c             oReserva;
  public static  SubPlanFacturacion__c  oPlanFacturacion;
  public static  SubPlanFacturacion__c  oPlanFacturacionDatos;
 

	 public static void CreateData()
    {
        Pagereference vfTest        = Page.LTE_GenerarOC_pag;
        Test.setCurrentPage(vfTest);           
      
        oOportunidad                               = LTE_DataGenerator_cls.createOportunidad(true);           
        oConfiguraciones                           = LTE_DataGenerator_cls.confPersonalizadas(true);  
        oReserva                                   = LTE_DataGenerator_cls.CreateOfertaEconomica(false);
        oPlanFacturacion                           = LTE_DataGenerator_cls.createSubPlanVoz(true);
        oPlanFacturacionDatos                      = LTE_DataGenerator_cls.createSubPlanDatos(true);
        oReserva.Oportunidad__c                    = oOportunidad.Id;
        oReserva.LTE_Plan__c 					   = LTE_DataGenerator_cls.createPlanCompuesto(true, 'PLAN A LA MEDIDA CONTROL EMPRESAS').Id;
        oReserva.LTE_DatosNavegacion__c      = oPlanFacturacionDatos.id;
        oReserva.LTE_MinutoVoz__c            = oPlanFacturacion.id;
        insert oReserva;
        oDetalleOferta                             = LTE_DataGenerator_cls.createDetalleOfertaListasNegras(true);  
        oDetalleOferta.LTE_Estado__c               ='Diferente a Declino '; 
        oDetalleOferta.Plan__c      			= oReserva.LTE_Plan__c;
        oDetalleOferta.LTE_DatosNavegacion__c      = oPlanFacturacionDatos.id;
        oDetalleOferta.LTE_MinutoVoz__c            = oPlanFacturacion.id;
        oDetalleOferta.LTE_BolsaRecurrenteVoz__c   = oPlanFacturacion.id;
        oDetalleOferta.LTE_BolsaRecurrenteDatos__c = oPlanFacturacion.id;
 
        update oDetalleOferta;

        System.debug('\nDetalle oferta de prueba:\n'+ oDetalleOferta+ '\n Oportunidad:\n'+ oOportunidad + '\nOferta economica:\n'+oReserva);                     

        oOportunidad.LTE_OportunidadBloqueada__c = true;
        Update oOportunidad;

    }

     public static testMethod void test_method_one() 
    {
           CreateData();   
           
           Test.startTest();                                   
                LTE_GenerarOC_ctr oGenerarOC = new LTE_GenerarOC_ctr( new Apexpages.Standardcontroller(oOportunidad));  
                oGenerarOC.crearOCs();
                oGenerarOC.crearServicioAdicional();
                oGenerarOC.mostrarMensaje();
                oGenerarOC.crearServicioAdicional();
     			oGenerarOC.CrearOCDesdeActivo();
        		oGenerarOC.cerrarPagina();
           Test.stopTest();
    }

	public static testMethod void test_method_two() 
    {
        CreateData();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialAPN';
        vGlobal.Valor__c = 'APN CORPORATIVO';
        insert vGlobal;
        
		APN__c objAPN = new APN__c();
		objAPN.Charguing_Characteristics__c = '100';
		objAPN.Cuenta_Cliente__c = oOportunidad.AccountId;
		objAPN.Estado__c = 'Disponible';
		objAPN.Servicio__c = 'DATOS';
		objAPN.APN__c = 'empresas.etb.net.co';
		objAPN.Identificador_APN__c = '4';
		insert objAPN;

		CatalogoProductos__c objProducto2 = new CatalogoProductos__c();
		objProducto2.Name = 'APN CORPORATIVO';
		objProducto2.Familia__c = 'LTE';
		objProducto2.LineaNegocio__c = 'Redes Móviles';
		objProducto2.CodigoProducto__c = '222222';
		objProducto2.Estado__c = 'Activo';
		objProducto2.Descripcion__c = 'APN Moviles Test';
		objProducto2.AtributosEstandar__c = 'APN Moviles Teste';
		insert objProducto2;
        
		Planes__c objPlan2 = new Planes__c ();
		objPlan2.Name = 'APN PARA SERVICIOS DE DATOS';
		objPlan2.NombredelProducto__c = objProducto2.Id;
		objPlan2.TipodePlan__c = 'Principal';
		objPlan2.Tarifa__c = 0;
		objPlan2.Estado__c = 'Activo';
		objPlan2.Descripcion__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
		objPlan2.CondicionesComerciales__c = 'La tarifa es todo destino Móviles y Fijos Nacionales. Tarifa para consumo de la recarga. Tarificación por segundo';
		objPlan2.LTE_PlanEstructurados__c = false;
		insert objPlan2;
        
		ActivoETB__c objServicio2 = new ActivoETB__c();
		objServicio2.Oportunidad__c = oOportunidad.Id;
        objServicio2.NombredelaCuenta__c = oOportunidad.AccountId;
        objServicio2.Plan__c = objPlan2.Id;
        objServicio2.Estado__c = 'Activo';
		objServicio2.APN__c = objAPN.Id;
		objServicio2.Tipo_de_APN__c = 'Datos';
        objServicio2.Fecha_Activacion__c = system.now();
        insert objServicio2;
        
        TOPP__c objTOPP2 = new TOPP__c();
        objTOPP2.Name = 'Venta- APN PARA SERVICIOS DE DATOS';
        objTOPP2.TipodeOperacionporplan__c = 'Gestion APN/IP';
        objTOPP2.Tipoderegistro__c = 'VentaAPN';
        objTOPP2.AplicaPreventa__c=true;
        objTOPP2.DisponibleVentainicial__c = true;
        objTOPP2.Facturable__c = false;
		objTOPP2.Plan__c = objPlan2.Id;
        insert objTOPP2;

        oOportunidad.Servicio_APN_Relacionado__c = objServicio2.Id;
        update oOportunidad;
        
        Test.startTest();                                   
        LTE_GenerarOC_ctr oGenerarOC = new LTE_GenerarOC_ctr( new Apexpages.Standardcontroller(oOportunidad));  
        oGenerarOC.crearOCs();
        oGenerarOC.crearServicioAdicional();
        oGenerarOC.mostrarMensaje();
        oGenerarOC.crearServicioAdicional();
        oGenerarOC.CrearOCDesdeActivo();
        Test.stopTest();
    }
}