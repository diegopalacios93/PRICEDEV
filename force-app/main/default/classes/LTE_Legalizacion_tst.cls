/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez 
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase de prueba para las clases: LTE_Legalizacion_ctr

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-31      Walter Rodríguez (WR)    Creación de la clase.
***********************************************************************************************************************/
@isTest(SeeAllData=false)
private class LTE_Legalizacion_tst 
{
  static testMethod void myUnitTest() 
  {
    Account objAccount = new Account();
    objAccount.Name = 'Test Name';
      objAccount.RazonSocial__c = 'Test razon social';
      objAccount.Tipodedocumento__c = 'NIT';
      objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';   
      insert objAccount;

      Poblacion__c objDepto = new Poblacion__c();
      objDepto.Name = 'BOGOTA D.C.';
      objDepto.CodigoDane__c = '11000';
      objDepto.EsDepartamento__c = true;
      insert objDepto;
      
    Poblacion__c objMunicipio = new Poblacion__c();
      objMunicipio.Name = 'BOGOTA D.C.';
      objMunicipio.CodigoDane__c = '11001';
      objMunicipio.EsMunicipio__c = true;
      objMunicipio.Padre__c = objDepto.Id;
      insert objMunicipio;
      
      CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
      objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
    objCtaFact.Cliente__c = objAccount.Id;
      objCtaFact.Facturable__c = true;
      objCtaFact.LTE_MetodoEnvio__c = 'Email';
      objCtaFact.LTE_CicloFacturacion__c = '5';
      objCtaFact.LTE_Email__c = 'test@test.com';
      //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
      objCtaFact.DirCorresp__c = 'Direccion test';
      objCtaFact.Ciudad__c = objMunicipio.Id;
      objCtaFact.LTE_CuentaFacturacionLTE__c = true;
      objCtaFact.Fue_creada_en_revchain__c = true;
      objCtaFact.DirCorresp__c = 'Test DirCorresp';
      insert objCtaFact;
      
      Contract objContrato = new Contract();
      objContrato.Name = 'Test name contrato';
      objContrato.AccountId = objAccount.Id;
      objContrato.Status = 'Borrador';
      insert objContrato;
            
    Legalizacion__c  objLegalizacion = new Legalizacion__c();
      objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
      objLegalizacion.Contrato__c = objContrato.Id;
      objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
      objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
      objLegalizacion.LTE_FechaGestion__c = system.today();
      objLegalizacion.Estado__c = 'Validación de pago';
      objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.LTE_TipoPago__c = 'Inmediato';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';   
        objLegalizacion.LTE_NumeroCuentaConsignacion__c =1;
        objLegalizacion.LTE_FechaPago__c = system.today();
        objLegalizacion.LTE_NumeroAprobacionPago__c ='1';
        objLegalizacion.Cuotas__c =1;  
      insert objLegalizacion;
 
       CatalogoProductos__c objProducto = new CatalogoProductos__c();
      objProducto.Name = 'TELEFONIA MOVIL (LTE)';
      objProducto.Familia__c = 'LTE';
      objProducto.LineaNegocio__c = 'Redes Móviles';
      objProducto.CodigoProducto__c = '7635736';
      objProducto.Estado__c = 'Activo';
      objProducto.Descripcion__c = 'Teste';
      objProducto.AtributosEstandar__c = 'Teste';
      insert objProducto;
      system.debug('objProducto-1->'+objProducto);

      TOPP__c objTOPP = new TOPP__c();
      objTOPP.Name = 'Renovación- TELEFONIA MOVIL (LTE)';
      objTOPP.TipodeOperacionporplan__c = 'Renovación';
      objTOPP.Tipoderegistro__c = 'Reposicion_LTE';
      objTOPP.Facturable__c = true;
      objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
      insert objTOPP;

      Equipo__c objEquipo = new Equipo__c();
      objEquipo.Name = 'Ascend G6 Negro';
      objEquipo.LTE_PartNumber__c = '129456789987654';
      objEquipo.LTE_Marca__c = 'Huawei';
      objEquipo.LTE_Color__c = 'Negro';
      objEquipo.Valor_del_Equipo__c = 395689;
      objEquipo.LTE_IVA__c = 63310;
      objEquipo.LTE_PrecioConIVA__c = 459000;
      objEquipo.LTE_Activo__c=true; // JDUR 2016-01-12
      insert objEquipo;

      Planes__c objPlan = new Planes__c ();
      objPlan.Name = 'PLAN NEGOCIOS POSPAGO M';
      objPlan.NombredelProducto__c = objProducto.Id;
      objPlan.TipodePlan__c = 'Principal';
      objPlan.Tarifa__c = 96000;
      objPlan.Estado__c = 'Activo';
      objPlan.Descripcion__c = 'La tarifa es todo destino Moviles y Fijos Nacionales ';
      objPlan.CondicionesComerciales__c = 'Tarificacion por segundo';
      objPlan.LTE_PlanEstructurados__c = true;
      insert objPlan;

      Opportunity objOportunidad = new Opportunity();
      objOportunidad.Name = 'Test name';
      objOportunidad.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
      objOportunidad.AccountId = objAccount.Id;
      objOportunidad.StageName = 'Análisis de necesidades';
      objOportunidad.CloseDate = system.today();
      objOportunidad.Amount = 1000;
      objOportunidad.Valor_unica_vez_ETB__c = 150;
      objOportunidad.LTE_Scoring__c = 9000000;
      objOportunidad.LTE_FechaConsultaDatacredito__c = system.today();
      objOportunidad.LTE_NumeroLinea__c = 2;
      insert objOportunidad;
      
      Reserva__c objOferta = new Reserva__c();
      objOferta.Oportunidad__c = objOportunidad.Id;
      objOferta.Estado__c = 'Pendiente';
      objOferta.Equipo__c = objEquipo.Id;
      objOferta.LTE_Plan__c = objPlan.Id;
      insert  objOferta;

      ActivoETB__c objServicio = new ActivoETB__c();
      objServicio.Oportunidad__c = objOportunidad.Id;
        objServicio.NombredelaCuenta__c = objAccount.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        insert objServicio;

        OperacionComercial__c objOpComercial = new OperacionComercial__c();
      objOpComercial.CuentaCliente__c = objAccount.Id;
      objOpComercial.Activo__c = objServicio.Id;
      objOpComercial.Plan__c = objPlan.Id;
      objOpComercial.TOPP__c = objTOPP.Id;
      objOpComercial.Oportunidad__c = objOportunidad.Id;
      objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
      objOpComercial.Estado__c = 'Pendiente';
      objOpComercial.NumeroConexion__c = '3057000501';
      objOpComercial.FechadeActivacion__c = system.today();
      objOpComercial.Legalizacion__c = objLegalizacion.Id;
      insert objOpComercial;
           
    OperacionComercial__c oc = [select Legalizacion__c, LTE_TipoPago__c from OperacionComercial__c where Legalizacion__c!= null limit 1];
    System.PageReference p = Apexpages.currentPage();
    p.getParameters().put( 'strId', oc.Id ); 
    Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller( oc );
    LTE_Legalizacion_ctr controller = new LTE_Legalizacion_ctr();
    controller.objLegalizacion.LTE_NumeroCuentaConsignacion__c =1;
        controller.objLegalizacion.LTE_FechaPago__c = system.today();
        controller.objLegalizacion.LTE_NumeroAprobacionPago__c ='1';
        controller.objLegalizacion.Cuotas__c =1;  
    controller.guardar();
    controller.poblarCampos();
  }
}