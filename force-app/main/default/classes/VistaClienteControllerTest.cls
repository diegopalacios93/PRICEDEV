@isTest
public class VistaClienteControllerTest {
	@testSetup 
    static void makeData() {
        Id clientePrincipalRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        
		Account acc = new Account();  
        acc.Name = 'Test Account';
        acc.RecordTypeId = clientePrincipalRTId;
        acc.Type = 'Prospecto';
        acc.AccountNumber='240324';
        acc.Segmento__c='Empresas';
        acc.SubSegmento__c='Grandes';
        acc.Tipodedocumento__c='NIT';
        acc.Estado_Cuenta__c='Activo';
        acc.Phone='3054658978';
        acc.TipodeAtencion__c = 'VIP';
        acc.Actividad_Economica__c = 'Construcción';
        acc.ValordeCliente__c = 'GOLD';
        insert acc;
        
        Account acc2 = new Account();  
        acc2.Name = 'Test Account 2';
        acc2.RecordTypeId = clientePrincipalRTId;
        acc2.Type = 'Prospecto';
        acc2.AccountNumber='422409';
        acc2.Segmento__c='Empresas';
        acc2.SubSegmento__c='Mediana';
        acc2.Tipodedocumento__c='NIT';
        acc2.Estado_Cuenta__c='Activo';
        acc2.Phone='1231231238';
        acc2.TipodeAtencion__c = 'VIP-BLINDAJE';
        acc2.Actividad_Economica__c = 'Educación';
        acc2.ValordeCliente__c = 'BRONZE';
        insert acc2;
        
        Account acc3 = new Account();  
        acc3.Name = 'Test Account 3';
        acc3.RecordTypeId = clientePrincipalRTId;
        acc3.Type = 'Prospecto';
        acc3.AccountNumber='567567557';
        acc3.Segmento__c='Empresas';
        acc3.SubSegmento__c='Grandes';
        acc3.Tipodedocumento__c='NIT';
        acc3.Estado_Cuenta__c='Activo';
        acc3.Phone='123123645';
        acc3.TipodeAtencion__c = 'VIP';
        acc3.Actividad_Economica__c = 'Educación';
        acc3.ValordeCliente__c = 'SILVER';
        insert acc3;
        
        Manejo_de_ofertas__c manejoOferta = new Manejo_de_ofertas__c();
        manejoOferta.CuentaCliente__c = acc.Id;
        manejoOferta.InformacionDisponible_Politicas__c = '';
        insert manejoOferta;
        
        Manejo_de_ofertas__c manejoOferta2 = new Manejo_de_ofertas__c();
        manejoOferta2.InformacionDisponible_Politicas__c = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
        manejoOferta2.CuentaCliente__c = acc3.Id;
        insert manejoOferta2;
	}
    @isTest
    public static void testIfThereIsAnManejoDeOfertasWithTheSameNumberOfTheAccout_UpdateTheManejoDeOferta(){
        
        Account cliente = [
            SELECT Id, AccountNumber, TipodeAtencion__c, Segmento__c, SubSegmento__c, 
            		Actividad_Economica__c, ValordeCliente__c
            FROM Account
            WHERE ValordeCliente__c = 'GOLD'
            LIMIT 1
        ];
        
        PageReference pageVistaCliente = Page.Vista_Cliente;
    	Test.setCurrentPage(pageVistaCliente);
        ApexPages.currentPage().getParameters().put('id', cliente.AccountNumber);
        
        Test.startTest();
        VistaClienteController vc=new VistaClienteController();
        vc.AceptarVC3();
        Test.stopTest();
        
        Manejo_de_ofertas__c mOferta = [
            SELECT CuentaCliente__c, Tipo_de_Antecion__c, Segmento_cliente__c, Sub_Segmento_cliente__c,
            		Actividad_Economica_cliente__c, Valor_de_Cliente__c
            FROM Manejo_de_ofertas__c
            WHERE CuentaCliente__r.AccountNumber =: cliente.AccountNumber
            LIMIT 1
        ];
        
        System.assertEquals(cliente.TipodeAtencion__c, mOferta.Tipo_de_Antecion__c, '[!] El tipo de atencion no coincide');
        System.assertEquals(cliente.Segmento__c, mOferta.Segmento_cliente__c, '[!] El segmento no coincide');
        System.assertEquals(cliente.SubSegmento__c, mOferta.Sub_Segmento_cliente__c, '[!] El sub segmento no coincide');
        System.assertEquals(cliente.Actividad_Economica__c, mOferta.Actividad_Economica_cliente__c, '[!] La actividad economica no coincide');
        System.assertEquals(cliente.ValordeCliente__c, mOferta.Valor_de_Cliente__c, '[!] El valor de cliente no coincide');
    }
    
    @isTest
    public static void testIfThereIsNoManejoDeOfertasWithTheSameNumberOfTheAccout_ShowError(){
        Account cliente = [
            SELECT Id, AccountNumber, TipodeAtencion__c, Segmento__c, SubSegmento__c, 
            		Actividad_Economica__c, ValordeCliente__c
            FROM Account
            WHERE ValordeCliente__c = 'BRONZE'
            LIMIT 1
        ];
        
        PageReference pageVistaCliente = Page.Vista_Cliente;
    	Test.setCurrentPage(pageVistaCliente);
        ApexPages.currentPage().getParameters().put('id', cliente.AccountNumber);
        
        Test.startTest();
        VistaClienteController vc=new VistaClienteController();
        vc.AceptarVC3();
        Test.stopTest();
        
        String VCError = System.Label.VCError;
        
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg: msgs){
            if (msg.getDetail().contains(VCError)){
                b = true;
            } 
        }
        System.assert(b);
    }
    
    @isTest
    static void testIfThereIsAnManejoDeOfertasWithTheSameNumberOfTheAccoutAndIsThePoliticsOne_ShowError(){
        Account cliente = [
            SELECT Id, AccountNumber, TipodeAtencion__c, Segmento__c, SubSegmento__c, 
            		Actividad_Economica__c, ValordeCliente__c
            FROM Account
            WHERE ValordeCliente__c = 'SILVER'
            LIMIT 1
        ];
        
        PageReference pageVistaCliente = Page.Vista_Cliente;
    	Test.setCurrentPage(pageVistaCliente);
        ApexPages.currentPage().getParameters().put('id', cliente.AccountNumber);
        
        Test.startTest();
        VistaClienteController vc=new VistaClienteController();
        vc.AceptarVC3();
        Test.stopTest();
        
        String VCError = System.Label.VCError;
        
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg: msgs){
            if (msg.getDetail().contains(VCError)){
                b = true;
            } 
        }
        System.assert(b);
    }
    
    @isTest
    static void testfinishLocation() {
        
        Account cliente = [
            SELECT Id, AccountNumber, TipodeAtencion__c, Segmento__c, SubSegmento__c, 
            		Actividad_Economica__c, ValordeCliente__c
            FROM Account
            WHERE ValordeCliente__c = 'GOLD'
            LIMIT 1
        ];
        
        PageReference pageVistaCliente = Page.Vista_Cliente;
    	Test.setCurrentPage(pageVistaCliente);
        ApexPages.currentPage().getParameters().put('id', cliente.AccountNumber);
        
        Test.startTest();
        VistaClienteController vc=new VistaClienteController();
        vc.VolverVC3();
        Test.stopTest();
        
        PageReference curpageRef = ApexPages.currentPage();
        
        System.assertNotEquals(null, curpageRef, '[!] La currentPage es nula');
    }
}