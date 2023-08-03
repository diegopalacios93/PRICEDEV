/**************************************************************************************************
Desarrollado por: Accenture
Autores: Luisina Platino
Proyecto: ETB MiPymes y Empresas        
Descripción: Clase que prueba el batch EnvioPromocionesAFacturador_bch y su scheduler
 
Cambios (Versiones)
-------------------------------------
No.     Fecha           Autores                Descripción
1.0     11/03/2022      Luisina Platino (LP)   Creacion de la clase
***************************************************************************************************/
@isTest
public with sharing class EnvioPromocionesAFacturador_tst {
    
    @TestSetup
    static void makeData(){
        
        Account acc = new Account();
        acc.Name = 'cuentacuentacuenta123';
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        acc.Type = 'Prospecto';
        acc.AccountNumber='240324';
        acc.Segmento__c='MiPymes'; 
        acc.SubSegmento__c='Grandes';
        acc.Tipodedocumento__c='NIT';
        acc.Estado_Cuenta__c='Activo';
        acc.Phone='3054658978';
        insert acc;

        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        objDepto.Tipo_de_instalacion__c = 'Bogotá';
        insert objDepto;

        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        objMunicipio.Tipo_de_instalacion__c = 'Bogotá';
        insert objMunicipio;

        Contact objContact = new Contact(IsTEST__c = true);
        objContact.FirstName = 'Andres';
        objContact.LastName = 'Lopez';
        objContact.AccountId = acc.Id;
        objContact.Tipodedocumento__c = 'Cédula de ciudadanía';
        objContact.NumerodeIdentificacion__c = '345678904';
        objContact.Estado__c = 'Activo';
        objContact.Cargo__c = 'Ingeniero';
        objContact.Area__c = 'Dpto. Financiero';
        objContact.Rol__c = 'Administrativo';
        objContact.LTE_RolLTE__c = 'Total-';
        objContact.Genero__c = 'Masculino';
        objContact.Direccion__c = 'Calle 12 # 34 - 53';
        objContact.Phone = '32432432';
        objContact.MobilePhone = '3105667655';
        objContact.Email = 'scampos@avanxo.com';
        objContact.Ciudad__c = objMunicipio.Id;
        insert objContact;

        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = acc.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        objCtaFact.LTE_DireccionFacturacion__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;

        Opportunity opp = new Opportunity();
        opp.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Oferta Comercial').getRecordTypeId();
        opp.Name = 'Test';
        opp.AccountId = acc.Id;
        opp.StageName = 'Propuesta de valor';
        opp.PDC__c = '80% - Probabilidad de Éxito';
        opp.Tipo_de_Operacion__c = 'Venta';
        opp.Amount = 100000;
        opp.ForecastCategoryName = 'En Construcción';
        opp.Valor_unica_vez_ETB__c = 12000;
        opp.CloseDate = Date.today()+5;
        insert opp;

        Equipo__c tEq = new Equipo__c();
        tEq.Name = 'SAMSUNG Galaxy Test'; 
        tEq.LTE_PartNumber__c = 'ETB-Test';
        tEq.Tipo__c = 'Equipo';
        tEq.Valor_del_Equipo__c = 100;
        tEq.LTE_Activo__c = True;
        insert tEq;

        Reserva__c objReserva = new Reserva__c();
        objReserva.Equipo__c = tEq.Id;
        insert objReserva;

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
        objPlan.Name = 'MOVIL ILIMIGIGAS NEGOCIOS';
        objPlan.NombredelProducto__c = objProducto.Id;
        objPlan.TipodePlan__c = 'Principal';
        objPlan.Tarifa__c = 96000;
        objPlan.Estado__c = 'Activo';
        objPlan.Descripcion__c = 'Plan pospago cuenta control, incluyen datos ilimitados en red 3G y 4G,  minutos ilimitados a todo destino nacional,  redes sociales definidas ilimitadas en todas las redes...';
        objPlan.CondicionesComerciales__c = 'Ilimitado Minutos Todo Destino <br>Ilimitado GB 3G/4G Navegacion <br>ilim SMS <br>Datos para redes sociales (WhatsApp, Facebook, Instagram, Twiter, Waze) ilimitados en todas las redes';
        objPlan.LTE_PlanEstructurados__c = true;
        objPlan.LTE_TipoControl__c = 'Control';
        insert objPlan;

        ActivoETB__c objServicio = new ActivoETB__c();
        objServicio.Oportunidad__c = opp.Id;
        objServicio.NombredelaCuenta__c = acc.Id;
        objServicio.Plan__c = objPlan.Id;
        objServicio.Estado__c = 'Activo';
        objServicio.IMEI_del_Equipo__c = '980684862113805';
        objServicio.LTE_ICCID__c = '8957187113000000506';
        objServicio.NumeroConexion__c = '3057000501';
        objServicio.Fecha_Activacion__c = system.now();
        insert objServicio;

        TOPP__c objTOPP = new TOPP__c();
        objTOPP.Name = 'Venta- TELEFONIA MOVIL (LTE)';
        objTOPP.TipodeOperacionporplan__c = 'Venta';
        objTOPP.Tipoderegistro__c = 'Venta_LTE';
        objTOPP.AplicaPreventa__c=true;
        objTOPP.DisponibleVentainicial__c = true;
        objTOPP.Facturable__c = true;
        objTOPP.LTE_Catalogo_de_Producto__c = objProducto.Id;
        insert objTOPP;

        OperacionComercial__c objOpComercial = new OperacionComercial__c();
        objOpComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta LTE').getRecordTypeId();
        objOpComercial.CuentaCliente__c = acc.Id;
        objOpComercial.Activo__c = objServicio.Id;
        objOpComercial.Plan__c = objPlan.Id;
        objOpComercial.TOPP__c = objTOPP.Id;
        objOpComercial.Oportunidad__c = opp.Id;
        objOpComercial.CuentaFacturacion__c = objCtaFact.Id;
        objOpComercial.Estado__c = 'En Curso';
        objOpComercial.NumeroConexion__c = '305700050';
        objOpComercial.FechadeActivacion__c = system.today();
        //objOpComercial.Legalizacion__c = objLegalizacion.Id;
        insert objOpComercial;

        LTE_Servicios_adicionales__c sa = new LTE_Servicios_adicionales__c();
        sa.Name = 'Servicio adicional test';
        sa.Plan__c = objPlan.Id;
        insert sa;
        
        Campaign objCampania = new Campaign();
        objCampania.Name = '100% MES 1 - CALL CENTER';
        objCampania.StartDate = Date.newInstance(2022, 6, 12);
        objCampania.EndDate = Date.newInstance(2022, 10, 20);
        objCampania.Status = 'Planificada';
        objCampania.Type = 'Publicidad';
        objCampania.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Administracion_de_Promociones').getRecordTypeId();
    	insert objCampania;

        ComponentePromocion__c objCompCampania = new ComponentePromocion__c();
        objCompCampania.Name = '100% MES 1 - CALL CENTER-MOVIL ILIMIGIGAS NEGOCIOS';
        objCompCampania.Campaign__c = objCampania.Id;
        objCompCampania.Descripcion__c = 'Descuento del 100% MES 1 y Descuento escalonado 50% MES 3-6-9-12. Solo Ventas Portadas';
        objCompCampania.Plan__c = objPlan.Id;
        objCompCampania.Producto__c = objProducto.Id;
        //objCompCampania.SVA__c = ;
        //objCompCampania.TecnologIaALaQueaplicaLaPromocion__c = ;
        insert objCompCampania;

        ReglaCampana__c objReglaCampania = new ReglaCampana__c();
        objReglaCampania.Name = 'MOVIL ILIMIGIGAS NEGOCIOS-ONE SHOT';
        objReglaCampania.ComponenteCampana__c = objCompCampania.Id;
        objReglaCampania.TipoCampana__c = 'ONE SHOT';
        objReglaCampania.Meses__c = '1';
        objReglaCampania.Descuento__c = 100;
        insert objReglaCampania;

        PlanFacturacion__c planFacturacion = new PlanFacturacion__c();
        planFacturacion.Name = 'PlanFacturacion';
        planFacturacion.Plan__c = objPlan.id;
        insert planFacturacion;

        ParametroFacturacion__c paramFact6 = new ParametroFacturacion__c();
        paramFact6.Name = 'RVC FEAT';
        paramFact6.PlanFacturacion__c = planFacturacion.id;
        paramFact6.LTE_ValorDefecto__c = 'Cargo Fijo LTE';
        insert paramFact6;

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

        LTE_DetalleOferta__c detalleOferta = new LTE_DetalleOferta__c();
        detalleOferta.LTE_OperacionComercial__c = objOpComercial.Id;
        detalleOferta.LTE_Oferta_Economica__c = objReserva.Id;
        detalleOferta.LTE_Cliente__c = acc.Id;
        detalleOferta.LTE_Componente_de_la_Campana__c = objCompCampania.Id;
        detalleOferta.Plan__c = objPlan.Id;
        insert detalleOferta;

        PromocionAplicada__c promoAplicada = new PromocionAplicada__c();
        promoAplicada.Estado__c = 'Pendiente Envio';
        promoAplicada.Fecha_Inicio__c = Date.newInstance(2022, 6, 17);
        promoAplicada.Fecha_Fin__c = Date.newInstance(2022, 7, 17);
        promoAplicada.Operacion_Comercial__c = objOpComercial.Id;
        promoAplicada.ReglaDeCampana__c = objReglaCampania.Id;
        promoAplicada.Descuento__c = objReglaCampania.Descuento__c;
        insert promoAplicada;

        ServiciosWeb__c servicio = new ServiciosWeb__c(Name='InvocacionServiceProvisioning',Action__c='/action',EndPoint__c='https://salesforce.com');
        insert servicio;

        AprovisionamientoOnline__c aprovOnline = new AprovisionamientoOnline__c( Name='EnvioPromocionesFacturador', LTE_Noche__c = 3);
        insert aprovOnline;
    }

   @IsTest
    static void testEnvioPromocionesAFacturador(){

        Test.setMock(HttpCalloutMock.class, new EnvioPromocionesAFacturador_tst.MockHttpResponseFacturador());
        Test.startTest();
            string strCronExp = Datetime.now().addMinutes(10).format('ss mm HH dd MM ? yyyy');
            String jobId = System.schedule('EnvioPromocionesAFacturador_bch' + System.now(), strCronExp, new EnvioPromocionesAFacturador_sch());
        Test.stopTest();
    }


    public class MockHttpResponseFacturador implements HttpCalloutMock {

        CuentaFacturacion__c subscriber = [SELECT Id FROM CuentaFacturacion__c LIMIT 1];
        ActivoETB__c external_service_id = [SELECT ExternalServiceID__c FROM ActivoETB__c LIMIT 1];
        Date active_date = Date.today();
        PromocionAplicada__c promo = [SELECT Name, Descuento__c, Fecha_Inicio__c, Fecha_Fin__c FROM PromocionAplicada__c LIMIT 1];

	    // Implement this interface method
	    public HTTPResponse respond(HTTPRequest req) {	        
	        // Create a fake response
	        string response = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="www.etb.com.co/ETB.MDM.EnterpriseCatalog/CommonSchemas/Revchain/ServiceProvisioning">'
            +'   <soapenv:Header/>'
            +'   <soapenv:Body>'
            +'      <ser:services>'
            +'         <ser:service_particulars>'
            +'            <ser:SuscriberId>'+subscriber.Id+'</ser:SuscriberId>'
            +'            <ser:services>'            
            +'              <ser:finder>'
            +'                <ser:external_service_id>'+external_service_id.ExternalServiceID__c+'</ser:external_service_id>'
            +'                <ser:active_date>'
            +'                  <ser:month>'+active_date.month()+'</ser:month>'
            +'                  <ser:day>'+active_date.day()+'</ser:day>'
            +'                  <ser:year>'+active_date.year()+'</ser:year>'
            +'                </ser:active_date>'
            +'            </ser:finder>'
            +'            <ser:feature>'
            +'              <ser:finder>'
            +'                 <ser:active_date>'
            +'                   <ser:month>'+active_date.month()+'</ser:month>'
            +'                   <ser:day>'+active_date.day()+'</ser:day>'
            +'                   <ser:year>'+active_date.year()+'</ser:year>'
            +'                 </ser:active_date>'
            +'              </ser:finder>'
            +'            <ser:feature_type_name>'+promo.Name+'</ser:feature_type_name>'
            +'            <ser:parameter action>modify</ser:parameter action>'
            +'               <ser:parameter_type_name>Descuento DS</ser:parameter_type_name>'
            +'               <ser:parameter_value>'+promo.Descuento__c+'</ser:parameter_value>'
            +'               <ser:start_date>'
            +'                   <ser:month>'+promo.Fecha_Inicio__c.month()+'</ser:month>'
            +'                   <ser:day>'+promo.Fecha_Inicio__c.day()+'</ser:day>'
            +'                   <ser:year>'+promo.Fecha_Inicio__c.year()+'</ser:year>'
            +'               </ser:start_date>'
            +'               <ser:end_date>'
            +'                   <ser:month>'+promo.Fecha_Fin__c.month()+'</ser:month>'
            +'                   <ser:day>'+promo.Fecha_Fin__c.day()+'</ser:day>'
            +'                   <ser:year>'+promo.Fecha_Fin__c.year()+'</ser:year>'
            +'               </ser:end_date>'
            +'               </ser:parameter>'
            +'            </ser:feature>'
            +'         </cre:services>'
            +'         </ser:service_particulars>'
            +'      </ser:services>'
            +'   </soapenv:Body>'
            +'</soapenv:Envelope>';
	        
	        HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml;charset=UTF-8');
	        res.setBody(response);
	        res.setStatusCode(200);
	        return res;
	    }
	}
}