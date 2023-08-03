@isTest(SeeAllData=false)
public class CotizacionAvanzadaTriggerServiceTest {

    //Test for CotizacionAvanzadaTrigger && CotizacionAvanzadaTriggerHandler && CotizacionAvanzadaTriggerService && CostosAvanzadosTrigger && CostosAvanzadosUpdateCart && CostosAvanzadosUpdateFormulaFields
    @testSetup 
    static void makeData() {
        ETB_BW__c bandwidth = new ETB_BW__C(BW_Mbps__c = 0.0625);
        insert bandwidth;
        Product2 prod5 = new Product2 (Name='HD TV', ProductCode = 'VLO-TV-0008');
        insert prod5;
        Product2 prod1 = new Product2 (Name='Triple Play Bundle Small', ProductCode = 'VLO-BUN-0001');
        insert prod1;
        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 testPricebook = new Pricebook2(Name = 'TestPricebook7', IsActive = true);
        insert testPricebook;
        PricebookEntry pbe11 = new PricebookEntry(Pricebook2Id = pricebookId,
                Product2Id = prod5.Id, UnitPrice = 10, vlocity_cmt__RecurringPrice__c = 5, IsActive = true);
        insert pbe11;
        Account accountBusiness = new Account();
            accountBusiness.Name = 'Account Billing';
            accountBusiness.Type = 'Business';
            accountBusiness.Phone = '12345678';
            accountBusiness.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business').getRecordTypeId();
        insert accountBusiness;
        Opportunity ventaUnificadaOpp = new Opportunity();
            ventaUnificadaOpp.CloseDate = System.today()+1;
            ventaUnificadaOpp.Amount = 200000.0;
            ventaUnificadaOpp.CausaldePerdida__c ='Otro';
            ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
            ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
            ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
            ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
            ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
            ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
            ventaUnificadaOpp.StageName = 'En Estudio';
            ventaUnificadaOpp.Duracion_Dias__c = 10;
            ventaUnificadaOpp.AccountId = accountBusiness.Id;
            //ventaUnificadaOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venta_Unificada').getRecordTypeId();
        insert ventaUnificadaOpp;
        Quote cotizacion = new Quote(
            Name = 'testQuote',
            OpportunityId = ventaUnificadaOpp.Id,
            Pricebook2Id = pricebookId
        );
        insert cotizacion;
        QuoteLineItem lineItem = new QuoteLineItem(
            QuoteId = cotizacion.Id,
            PricebookEntryId = pbe11.Id,
            Quantity = 1,
            UnitPrice = 0,
            Product2Id = prod5.Id
        );
        insert lineItem;

        ETB_CotizacionAvanzada__c cotAvanzada = new ETB_CotizacionAvanzada__c(AnchoBandaTerceros__c = '64Kbps',
                                                                            Ancho_de_Banda__c = bandwidth.Id,
                                                                            Tarifa_Piso_de_Referencia__c = 136936300,
                                                                            Calculado__c = TRUE,
                                                                            Categoria_de_Enlace__c = 'Pto. Remoto',
                                                                            CiudadDestino__c = 'Barranquilla',
                                                                            CiudadOrigen__c = 'Bogotá',
                                                                            Clausula_de_Permanencia__c = TRUE,
                                                                            Costo_de_Facturacion__c = 2000,
                                                                            Costo_de_Help_Desk__c = 20000,
                                                                            Factor_Canalizacion_Cobre__c = 0.25,
                                                                            Factor_Canalizacion_Fibra__c = 1.042,
                                                                            Factor_Categoria_Enlace__c = 1,
                                                                            Gestion_Unificada__c = 'Servicio Basico',
                                                                            Margen_BA_Terceros__c = 20,
                                                                            Margen_Comercial_Maximo__c = 5,
                                                                            Margen_Comercial_Minimo__c = 0,
                                                                            Margen_Lista_Equipos__c = 30,
                                                                            Metros_Tendidos_Fo_UM_ETB__c = 5000,
                                                                            OPEX_Comercial_Maximo__c = 8.09479584340328,
                                                                            Obras_Civiles__c = 1293871823,
                                                                            OpexComercial__c = 8,
                                                                            Opex_Instalacion__c = 5,
                                                                            SMMLV__c = 908526,
                                                                            Segmento__c = 'Empresas',
                                                                            Service_Activator__c = 39840,
                                                                            Service_Manager_IntelligenceMes__c = 10,
                                                                            Service_Manager__c = 39840,
                                                                            Servicio_Basico__c = 10000,
                                                                            Servicio_Platino__c = 10000,
                                                                            TIO_Mes__c = 1.53094704997312,
                                                                            TRM__c = 3984,
                                                                            TCM__c = 12,
                                                                            Tipo_de_Contrato__c = 'Nuevo',
                                                                            Tipo_de_Servicio__c = 'CAIP',
                                                                            IVA__c = 19,
                                                                            ValorMatrizRadio__c = 0,
                                                                            Valor_Matrix_TX_local_y_nacional_por_ciu__c = 20000,
                                                                            Valor_MatrizLocal_BW__c = 39996.25,
                                                                            Valor_Matriz_Ampliaci_n__c = 500000,
                                                                            Valor_Matriz_BW_Internet__c = 24990.62,
                                                                            Valor_Matriz_BW_NAP__c = 14995.62,
                                                                            Valor_Matriz_BW_Nacional__c = 39995.62,
                                                                            Valor_Matriz_BW_Pto_Central__c = 14995.62,
                                                                            Valor_Matriz_CFM_Terceros_TCM__c = 0,
                                                                            Valor_Matriz_Costo_de_Instalaci_n_Equipo__c = 500000,
                                                                            Valor_Matriz_Equipo_UM__c = 20000,
                                                                            Valor_Matriz_Fo_Acceso__c = 20500,
                                                                            Valor_Matriz_Limite_metros__c = 0,
                                                                            Valor_Matriz_Metros_adicionales_bienes_y__c = 0,
                                                                            Valor_Matriz_Puertos_de_Red_Metro__c = 20000,
                                                                            Valor_Matriz_Red_Carrier_Ethernet__c = 40000,
                                                                            Valor_Matriz_Red_MPLS__c = 40000,
                                                                            WACC__c = 20,
                                                                            Valor_Matriz_Desinstalacion__c = 500000,
                                                                            FO_Acceso__c = 18830644,
                                                                            Metros_Adicionales__c = 0,
                                                                            Valor_Matriz_Total_Internet__c = 0,
                                                                            Factor_PMT_doce__c = 0.0918568,
                                                                            Valor_Matriz_Obras_Civiles__c = 500000,
                                                                            Factor_PMT_Veintinueve__c = 0.0429611,
                                                                            Instalacion_y_Obras_Civiles__c = 118971581.77,
                                                                            TipoUM__c = 'COBRE ETB G.SHDSL',
                                                                            Quote_Line_Item__c = lineItem.Id,
                                                                            Cotizacion__c = cotizacion.Id
                                                                            );
        insert cotAvanzada; 
        Costos_Avanzados__c costo = new Costos_Avanzados__c(
            Quote_Line_Item__c = lineItem.Id,
            Cotizacion__c = cotizacion.Id,
            Cotizador__c = cotAvanzada.Id,
            CC_FOAcceso__c = 73189.773904,
            CC_Internet__c = 0,
            CC_MPLSRedCarrierEthernet__c = 400000,
            CC_Metros_Adicionales__c = 0,
            CC_Metros_Tendidos_FoUMETB__c = 500,
            CC_Monitoreo_Reportes__c = 10000,
            CC_OPEX_ComercialMaximo__c = 8.9479584340328,
            CC_OPEX_Comercial__c = 8,
            CC_Obras_Civiles__c = 1000000,
            CC_Opex_Instalacion__c = 5,
            CC_PuertosRedMetro__c = 20000,
            CC_Radio__c = 0,
            CC_Tipo_de_Contrato__c = 'Nuevo',
            CC_TRM__c = 3984,
            CC_TxInternet_NAP__c = 0,
            CC_Tx__c = 0,
            TipoUM__c = 'DEMARCADOR BUS INTERFAZ 10Gb Regiones',
            CC_DescuentoOfrecido__c = null,
            Tiempo_de_Contrato_en_Meses__c = 12,
            Cantidad_de_Enlaces__c = 1,
            IVA__c = 19,
            CC_Costo_de_Help_Desk__c = 20000,
            CC_Costo_de_Facturacion__c = 2000,
            CC_Service_Manager_IntelligenceMes__c = 10,
            CC_Margen_Comercial_Minimo__c = 0,
            CC_Valor_Matriz_Ampliacion__c = 15001,
            CC_Valor_Matriz_BW_Pto_Central__c = 4395,
            CC_Valor_Matriz_Desinstalacion__c = 123123,
            CC_Valor_Matriz_Costo_de_Instalacion_Equ__c = 123321,
            CC_Valor_Matriz_Obras_Civiles__c = 9999,
            CC_Instalacion_y_Obras_Civiles__c = 0,
            CC_Factor_PMT_doce__c = 0.0918568,
            CC_Factor_PMT_Veintinueve__c = 0.0429611
        );
        insert costo;
    }
    @isTest
    static private void TestCheckIfInserts() {
        List<ETB_CotizacionAvanzada__c> lPID = [SELECT Id, AnchoBandaTerceros__c, CFM_Unitario__c, Costo_Equipo_UM__c, Conexion_Unitario__c, Radio__c, Tarifa_Piso_de_Referencia__c, Calculado__c, Categoria_de_Enlace__c, 
                                                CiudadDestino__c, CiudadOrigen__c, Clausula_de_Permanencia__c, Costo_de_Facturacion__c, Costo_de_Help_Desk__c, 
                                                Factor_Canalizacion_Cobre__c, Factor_Canalizacion_Fibra__c, Factor_Categoria_Enlace__c, 
                                                Gestion_Unificada__c, Margen_BA_Terceros__c, Margen_Comercial_Maximo__c, Margen_Comercial_Minimo__c, 
                                                Margen_Lista_Equipos__c, Metros_Tendidos_Fo_UM_ETB__c, OPEX_Comercial_Maximo__c, Obras_Civiles__c, 
                                                OpexComercial__c, Opex_Instalacion__c, SMMLV__c, Segmento__c, Service_Activator__c, Service_Manager_IntelligenceMes__c, 
                                                Service_Manager__c, Servicio_Basico__c, Servicio_Platino__c, TIO_Mes__c, TRM__c, TCM__c, Tipo_de_Contrato__c, Tipo_de_Servicio__c, 
                                                IVA__c, ValorMatrizRadio__c, Valor_Matrix_TX_local_y_nacional_por_ciu__c, Valor_MatrizLocal_BW__c, Valor_Matriz_Ampliaci_n__c, Valor_Matriz_BW_Internet__c, 
                                                Valor_Matriz_BW_NAP__c, Valor_Matriz_BW_Nacional__c, Valor_Matriz_BW_Pto_Central__c, Valor_Matriz_CFM_Terceros_TCM__c,
                                                Valor_Matriz_Costo_de_Instalaci_n_Equipo__c, Valor_Matriz_Equipo_UM__c, Valor_Matriz_Fo_Acceso__c, Valor_Matriz_Limite_metros__c, 
                                                Valor_Matriz_Metros_adicionales_bienes_y__c, Valor_Matriz_Puertos_de_Red_Metro__c, Valor_Matriz_Red_Carrier_Ethernet__c, Valor_Matriz_Red_MPLS__c, 
                                                WACC__c, Valor_Matriz_Desinstalacion__c, FO_Acceso__c, Anillo_de_Acceso__c, Metros_Adicionales__c, Valor_Matriz_Total_Internet__c, Factor_PMT_doce__c,
                                                Valor_Matriz_Obras_Civiles__c, Factor_PMT_Veintinueve__c, Instalacion_y_Obras_Civiles__c, TipoUM__c, Puertos_Red_Metro__c,
                                                MPLS_y_Red_Carrier_Ethernet__c, Acceso_y_Agregacion_Unitario__c, Costo_UM_Otro_Operador_o_ETB_Satelital__c, Tx__c, Tx_Internet_o_NAP__c, Red_de_Tx__c,
                                                UM_RedAgregacion_y_Tx__c, Facturacion_HDP_ServiceManager_Intel__c, Monitoreo_Reportes__c, Costo_Enlace_OPEX_Comercial__c, Costo_Enlace_OPEX_Comercial_Maximo__c,
                                                Total_Conexi_n_OC_Unitario__c, Tarifa_Piso_Unitaria_Sin_IVA__c, Red_HDP_Reportes__c, Enlace_Local__c, Enlace_Nacional__c, Internet__c, Valor_Adicional_Total__c,
                                                Quote_Line_Item__c, Tarifa_Lista_Unitaria_sin_IVA__c, Formula_Tiempo_de_Contrato_en_Meses__c, Costo_total_Sin_IVA__c,
                                                Tarifa_Total_Sin_IVA__c, Tarifa_Unitaria_Sin_IVA__c, Tarifa_Total_con_IVA__c, Diferencia_tarifacosto_Valor_ETB__c, OPEXReventa_Colaborador__c,
                                                Margen_Neto__c, Tipo_de_Contrato_Aliado__c, Tipo_de_Cargo__c, Valor_Total_Proyecto_sin_IVA__c, Valor_Total_Proyecto_con_IVA__c, Valor_Total_sin_IVA__c, 
                                                Valor_Total_con_IVA__c, Cotizacion__c, Ancho_de_Banda__c, Tarifa_Actual_Pagada__c, Combinacion_Ciudad_Origen_Destino__c, OPEX_MAX_Impuestos_Adicionales__c
                                                FROM ETB_CotizacionAvanzada__c];
        
        
        Test.startTest();
        CotizacionAvanzadaTriggerService.updateCostosConectividad(lPID);
        Test.stopTest();
        List<Costos_Avanzados__c> costosAvanzados = [SELECT Id, CC_TRM__c, Descuento_Comercial_Maximo__c FROM Costos_Avanzados__c];
        system.assertEquals(lPID[0].TRM__c, costosAvanzados[0].CC_TRM__c);
    }    
    @isTest
    static private void TestCheckIfUpdates() {
        List<ETB_CotizacionAvanzada__c> lPID = [SELECT Id, AnchoBandaTerceros__c, CFM_Unitario__c, Costo_Equipo_UM__c, Conexion_Unitario__c, Radio__c, Tarifa_Piso_de_Referencia__c, Calculado__c, Categoria_de_Enlace__c, 
                                                CiudadDestino__c, CiudadOrigen__c, Clausula_de_Permanencia__c, Costo_de_Facturacion__c, Costo_de_Help_Desk__c, 
                                                Factor_Canalizacion_Cobre__c, Factor_Canalizacion_Fibra__c, Factor_Categoria_Enlace__c, 
                                                Gestion_Unificada__c, Margen_BA_Terceros__c, Margen_Comercial_Maximo__c, Margen_Comercial_Minimo__c, 
                                                Margen_Lista_Equipos__c, Metros_Tendidos_Fo_UM_ETB__c, OPEX_Comercial_Maximo__c, Obras_Civiles__c, 
                                                OpexComercial__c, Opex_Instalacion__c, SMMLV__c, Segmento__c, Service_Activator__c, Service_Manager_IntelligenceMes__c, 
                                                Service_Manager__c, Servicio_Basico__c, Servicio_Platino__c, TIO_Mes__c, TRM__c, TCM__c, Tipo_de_Contrato__c, Tipo_de_Servicio__c, 
                                                IVA__c, ValorMatrizRadio__c, Valor_Matrix_TX_local_y_nacional_por_ciu__c, Valor_MatrizLocal_BW__c, Valor_Matriz_Ampliaci_n__c, Valor_Matriz_BW_Internet__c, 
                                                Valor_Matriz_BW_NAP__c, Valor_Matriz_BW_Nacional__c, Valor_Matriz_BW_Pto_Central__c, Valor_Matriz_CFM_Terceros_TCM__c,
                                                Valor_Matriz_Costo_de_Instalaci_n_Equipo__c, Valor_Matriz_Equipo_UM__c, Valor_Matriz_Fo_Acceso__c, Valor_Matriz_Limite_metros__c, 
                                                Valor_Matriz_Metros_adicionales_bienes_y__c, Valor_Matriz_Puertos_de_Red_Metro__c, Valor_Matriz_Red_Carrier_Ethernet__c, Valor_Matriz_Red_MPLS__c, 
                                                WACC__c, Valor_Matriz_Desinstalacion__c, FO_Acceso__c, Anillo_de_Acceso__c, Metros_Adicionales__c, Valor_Matriz_Total_Internet__c, Factor_PMT_doce__c,
                                                Valor_Matriz_Obras_Civiles__c, Factor_PMT_Veintinueve__c, Instalacion_y_Obras_Civiles__c, TipoUM__c, Puertos_Red_Metro__c,
                                                MPLS_y_Red_Carrier_Ethernet__c, Acceso_y_Agregacion_Unitario__c, Costo_UM_Otro_Operador_o_ETB_Satelital__c, Tx__c, Tx_Internet_o_NAP__c, Red_de_Tx__c,
                                                UM_RedAgregacion_y_Tx__c, Facturacion_HDP_ServiceManager_Intel__c, Monitoreo_Reportes__c, Costo_Enlace_OPEX_Comercial__c, Costo_Enlace_OPEX_Comercial_Maximo__c,
                                                Total_Conexi_n_OC_Unitario__c, Tarifa_Piso_Unitaria_Sin_IVA__c, Red_HDP_Reportes__c, Enlace_Local__c, Enlace_Nacional__c, Internet__c, Valor_Adicional_Total__c,
                                                Quote_Line_Item__c, Tarifa_Lista_Unitaria_sin_IVA__c, Formula_Tiempo_de_Contrato_en_Meses__c, Costo_total_Sin_IVA__c,
                                                Tarifa_Total_Sin_IVA__c, Tarifa_Unitaria_Sin_IVA__c, Tarifa_Total_con_IVA__c, Diferencia_tarifacosto_Valor_ETB__c, OPEXReventa_Colaborador__c,
                                                Margen_Neto__c, Tipo_de_Contrato_Aliado__c, Tipo_de_Cargo__c, Valor_Total_Proyecto_sin_IVA__c, Valor_Total_Proyecto_con_IVA__c, Valor_Total_sin_IVA__c, 
                                                Valor_Total_con_IVA__c, Cotizacion__c, Ancho_de_Banda__c, Tarifa_Actual_Pagada__c, Combinacion_Ciudad_Origen_Destino__c, OPEX_MAX_Impuestos_Adicionales__c
                                                FROM ETB_CotizacionAvanzada__c];
        lPID[0].IVA__c = 4;
        update lPID;
        
        Test.startTest();
        CotizacionAvanzadaTriggerService.updateCostosConectividad(lPID);
        Test.stopTest();
        List<Costos_Avanzados__c> costosAvanzados = [SELECT Id, IVA__c FROM Costos_Avanzados__c];
        system.assertEquals(lPID[0].IVA__c, costosAvanzados[0].IVA__c);
    }   
    @isTest
    static private void checkIfUpdatesRecordWithModificacion() {
        List<Costos_Avanzados__c> costos = [SELECT Id, CC_Tipo_de_Contrato__c FROM Costos_Avanzados__c];
        test.startTest();
        costos[0].CC_Tipo_de_Contrato__c = 'Modificacion';
        update costos;
        test.stopTest();
        List<Costos_Avanzados__c> costosAfterInsert = [SELECT Id, CC_Tipo_de_Contrato__c, CC_Instalacion_y_Obras_Civiles__c FROM Costos_Avanzados__c];
        system.assertNotEquals(costosAfterInsert[0].CC_Instalacion_y_Obras_Civiles__c, 0);
    }
    @isTest
    static private void checkIfUpdatesRecordWithAmpliacion() {
        List<Costos_Avanzados__c> costos = [SELECT Id, CC_Tipo_de_Contrato__c FROM Costos_Avanzados__c];
        test.startTest();
        costos[0].CC_Tipo_de_Contrato__c = 'Ampliacion';
        update costos;
        test.stopTest();
        List<Costos_Avanzados__c> costosAfterInsert = [SELECT Id, CC_Tipo_de_Contrato__c FROM Costos_Avanzados__c];
        system.assertEquals(costos[0].CC_Tipo_de_Contrato__c, costosAfterInsert[0].CC_Tipo_de_Contrato__c);
    }
    @isTest
    static private void checkIfUpdatesRecordWithRenovacion() {
        List<Costos_Avanzados__c> costos = [SELECT Id, CC_Tipo_de_Contrato__c FROM Costos_Avanzados__c];
        test.startTest();
        costos[0].CC_Tipo_de_Contrato__c = 'Renovacion';
        update costos;
        test.stopTest();
        List<Costos_Avanzados__c> costosAfterInsert = [SELECT Id, CC_Tipo_de_Contrato__c FROM Costos_Avanzados__c];
        system.assertEquals(costos[0].CC_Tipo_de_Contrato__c, costosAfterInsert[0].CC_Tipo_de_Contrato__c);
    }
    @isTest
    static private void checkIfUpdatesRecordWithMatrizValueCostoDeInstalacionEquipo() {
        List<Costos_Avanzados__c> costos = [SELECT Id, TipoUM__c, CC_Valor_Matriz_Ampliacion__c, CC_Tipo_de_Contrato__c, CC_Instalacion_y_Obras_Civiles__c, CC_Factor_PMT_doce__c, 
                                            CC_Valor_Matriz_Desinstalacion__c, CC_Factor_PMT_Veintinueve__c, CC_Obras_Civiles__c, CC_Valor_Matriz_Costo_de_Instalacion_Equ__c,
                                            CC_Valor_Matriz_Obras_Civiles__c, CC_Service_Activator__c, CC_Service_Manager__c, CC_TotalConexion_OCUnitario__c FROM Costos_Avanzados__c];
        test.startTest();
        costos[0].CC_Valor_Matriz_Costo_de_Instalacion_Equ__c = 15;
        update costos;
        test.stopTest();
        List<Costos_Avanzados__c> costosAfterInsert = [SELECT Id, CC_Instalacion_y_Obras_Civiles__c FROM Costos_Avanzados__c];
        system.assertEquals(costos[0].CC_Instalacion_y_Obras_Civiles__c, costosAfterInsert[0].CC_Instalacion_y_Obras_Civiles__c);
    }
    @isTest
    static private void checkIfThrowsError() {
        List<Costos_Avanzados__c> costos = [SELECT Id, CC_Valor_Matriz_Ampliacion__c FROM Costos_Avanzados__c];
        test.startTest();
        costos[0].CC_Valor_Matriz_Ampliacion__c = 1;
        update costos;
        test.stopTest();
        List<Costos_Avanzados__c> costosAfterInsert = [SELECT Id, CC_Valor_Matriz_Ampliacion__c FROM Costos_Avanzados__c];
        system.assertEquals(costos[0].CC_Valor_Matriz_Ampliacion__c, costosAfterInsert[0].CC_Valor_Matriz_Ampliacion__c);
    }
    @isTest
    static private void checkIfUpdatesRecordWithADirectCall() {
        List<Costos_Avanzados__c> costos = [SELECT Id, TipoUM__c, CC_Valor_Matriz_Ampliacion__c, CC_Tipo_de_Contrato__c, CC_Instalacion_y_Obras_Civiles__c, CC_Factor_PMT_doce__c, 
                                            CC_Valor_Matriz_Desinstalacion__c, CC_Factor_PMT_Veintinueve__c, CC_Obras_Civiles__c, CC_Valor_Matriz_Costo_de_Instalacion_Equ__c,
                                            CC_Valor_Matriz_Obras_Civiles__c, CC_Service_Activator__c, CC_Service_Manager__c, CC_TotalConexion_OCUnitario__c FROM Costos_Avanzados__c];
        test.startTest();
        costos[0].CC_Valor_Matriz_Costo_de_Instalacion_Equ__c = 1345345345;
        update costos;
        test.stopTest();
        List<Costos_Avanzados__c> costosAfterInsert = [SELECT Id, CC_Instalacion_y_Obras_Civiles__c FROM Costos_Avanzados__c];
        system.assertEquals(costos[0].CC_Instalacion_y_Obras_Civiles__c, costosAfterInsert[0].CC_Instalacion_y_Obras_Civiles__c, 'this test needs further reviews');
    }
}