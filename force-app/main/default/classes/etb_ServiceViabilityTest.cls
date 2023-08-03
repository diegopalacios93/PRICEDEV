@isTest
public class etb_ServiceViabilityTest {

    private static string body = '{"opportunityId":"00678000002LXTMAA4","tipoSolicitud":"Viabilidad","listadeProduct":[{"Operacion":"Actualizar","QuoteLineItemId":"0QL78000000H16IGAS","productCode":"PR_Navegacion_segura_Avanzada","parentId":null,"ServiceAccId":"00178000009UxCAAA0","listaConfiguraciones":[{"Quantity":9,"parametros":[{"valor":"Público","atributo":"ATT_Inspección_direccionamientoIP"},{"valor":7,"atributo":"ATT_Porcentaje_crecimiento_12_meses"},{"valor":false,"atributo":"ATT_Se_requiereTráfico_Cifrado"},{"valor":0,"atributo":"ATT_TiempoContratoDias"},{"valor":12,"atributo":"ATT_TiempoContratoMeses"},{"valor":5,"atributo":"ATT_Número_de_usuarios_sede"},{"valor":"Sí Acepta","atributo":"ATT_Clausula_de_Terminacion_Anticipada"},{"valor":"Hasta 50 Mbps","atributo":"ATT_Ancho_Banda"}]},{"Quantity":9,"parametros":[{"valor":"Público","atributo":"ATT_Inspección_direccionamientoIP"},{"valor":7,"atributo":"ATT_Porcentaje_crecimiento_12_meses"},{"valor":false,"atributo":"ATT_Se_requiereTráfico_Cifrado"},{"valor":0,"atributo":"ATT_TiempoContratoDias"},{"valor":12,"atributo":"ATT_TiempoContratoMeses"},{"valor":5,"atributo":"ATT_Número_de_usuarios_sede"},{"valor":"Sí Acepta","atributo":"ATT_Clausula_de_Terminacion_Anticipada"},{"valor":"Hasta 50 Mbps","atributo":"ATT_Ancho_Banda"}]}]},{"Operacion":"Crear","QuoteLineItemId":"Gestor-0000001","productCode":"PR_ROUTER_CISCO_SERIE_ISR1000","parentId":"0QL78000000H16IGAS","ServiceAccId":"00178000009UxCAAA0","listaConfiguraciones":[{"Quantity":4,"parametros":[{"valor":"ROUTERS_CISCO","atributo":"ATT_Tipo_de_equipo"},{"valor":"C1101-4P","atributo":"Modelo de Equipo"},{"valor":true,"atributo":"ATT_Comodato"},{"valor":false,"atributo":"ATT_Es_Propietario"},{"valor":12,"atributo":"ATT_TiempoContratoMeses"},{"valor":"Nuevo UM Propia","atributo":"ATT_Tipo_de_contrato"},{"valor":"Router","atributo":"ATT_Unidad_de_equipo"}]}]},{"Operacion":"Actualizar","QuoteLineItemId":"0QL3K000000d28AWAQ","productCode":"PR_HERRAMIENTA_DE_MONITOREO_ENTUITY","parentId":"0QL78000000H16IGAS","ServiceAccId":"00178000009UxCAAA0","listaConfiguraciones":[{"Quantity":2,"parametros":[{"valor":12,"atributo":"ATT_TiempoContratoMeses"},{"valor":"Sí Acepta","atributo":"ATT_Clausula_de_Terminacion_Anticipada"}]}]}],"listaViabilidad":[{"viabilidad":"VIA-226507","estadoGestor":"estadoG1","estadoViabilidad":"Cerrada","faseGestor":"faseG1","fechaFinalEstado":"2022-05-25","ingeniero":"eee","respuestadeviabilidad":"Viable","respuestaGestor":"respuestaG1","tipodeViabilidad":"Por cobertura"},{"viabilidad":"VIA-226508","estadoGestor":"Por Asignar","estadoViabilidad":"En proceso","faseGestor":"Inicial","fechaFinalEstado":null,"ingeniero":null,"respuestadeviabilidad":null,"respuestaGestor":"respuestaG2","tipodeViabilidad":"Por cobertura"}]}';
    private static Map<String, Object> jsonBody2 = (Map<String, Object>)JSON.deserializeUntyped(body);


    @TestSetup
    static void makeData(){
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
            //ventaUnificadaOpp.Linea_de_Negocio_Principal__c = 'ventaUnificadaOpp';
            ventaUnificadaOpp.ForecastCategoryName = 'Negociacion';
            ventaUnificadaOpp.Tipo_de_Operacion__c = 'Venta';
            ventaUnificadaOpp.Valor_unica_vez_ETB__c= 200000.0;
            ventaUnificadaOpp.Name = 'Opportunity Venta Unificada';
            ventaUnificadaOpp.OwnerId = Userinfo.getUserId();
            ventaUnificadaOpp.PDC__c = '80% - Probabilidad de Éxito';
            ventaUnificadaOpp.StageName = 'En Estudio';
            ventaUnificadaOpp.Duracion_Dias__c = 10;
            ventaUnificadaOpp.AccountId = accountBusiness.Id;
            ventaUnificadaOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Venta_Unificada').getRecordTypeId();
        insert ventaUnificadaOpp;
        
        Viabilidad__c viabilidadSF1 = new Viabilidad__c(
            Estado_Gestor__c = 'Por Asignar',
            Oportunidad__c = ventaUnificadaOpp.Id,
            EstadoViabilidad__c = 'Pendiente',
            Fase_Gestor__c = 'Inicial',
            Fecha_Final_Estado__c = System.today(),
            Ing_Factibilidad__c = 'Ingeniero',
            Respuestadeviabilidad__c = 'Viable',
            Respuesta_Gestor__c = 'OK',
            Tipo_de_Viabilidad__c = 'Por cobertura',
            RecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Especifica').getRecordTypeId(),
            ViabilidadNoViable__c = false,
            Crear_VIA_de_Lineas_LTE__c = false,
            Control_Respuestas__c = false);
        insert viabilidadSF1;

        Viabilidad__c viabilidadSF2 = new Viabilidad__c(
            Estado_Gestor__c = 'Por Asignar',
            Oportunidad__c = ventaUnificadaOpp.Id,
            EstadoViabilidad__c = 'Pendiente',
            Fase_Gestor__c = 'Inicial',
            Fecha_Final_Estado__c = System.today(),
            Ing_Factibilidad__c = 'Ingeniero',
            Respuestadeviabilidad__c = 'Viable',
            Respuesta_Gestor__c = 'OK',
            Tipo_de_Viabilidad__c = 'Por cobertura',
            RecordTypeId = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Especifica').getRecordTypeId(),
            ViabilidadNoViable__c = false,
            Crear_VIA_de_Lineas_LTE__c = false,
            Control_Respuestas__c = false);
        insert viabilidadSF2;
    }
    
    @isTest
    private static void ServiceQuoteTest() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = 'https://yourInstance.salesforce.com/services/apexrest/Cases/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(body);
        RestContext.request = request;
        RestContext.response = response;
        Test.startTest();
        etb_ServiceViability.ServiceQuote();
        Test.stopTest();
        System.assertEquals(true,String.isNotBlank(String.valueof(response.statusCode)));
        System.assertEquals(200,response.statusCode);

    }

}