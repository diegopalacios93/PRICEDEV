@isTest
public class GetPrecio_tst {
    @testSetup 
    static void setup() {

        objPruebas_tst obj =new objPruebas_tst();
        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Name='Convenio de cupo';
        Catalogo.CodigoProducto__c='Conveniodecupo001';

        
        planes__c plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        plan.Name='Plan Larga Distancia '+Catalogo.Name;
        plan.IdUnico__c='PlanLargaDistancia';
        insert plan;
        LTE_Servicios_adicionales__c sa = new LTE_Servicios_adicionales__c();
        sa.Name = 'Servicio adicional test';
        sa.Plan__c = plan.Id;
        insert sa;

        Precios__c precio = new Precios__c();
        precio.Servicio_adicional__c = sa.Id;
        precio.RangoMenor__c = 1;
        precio.RangoMayor__c = 5;
        precio.Precio__c = 20000;
        insert precio;

    }

    @isTest
    static void testSuccess(){
        Planes__c plan = [SELECT Id FROM Planes__c LIMIT 1];
        Test.startTest(); 
        	GetPrecio.doPost(String.valueOf(plan.Id));
        Test.stopTest();
    }
    
}