/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 02-28-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
@isTest(SeeAllData=true)
public class OperacionComercialCtr_Test {   

    
    static testMethod void OC_CTR() 
	{
		List<LTE_SpecificationGroupXA__c> xa = [Select Id, Name,  LTE_Value__c, LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Id 
                                                FROM LTE_SpecificationGroupXA__c WHERE Name =: 'Fecha Asignación Ingeniero'
                                                AND LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Id <> NULL LIMIT 1];
        
        
        List<LTE_Servicios_adicionales__c> sa;
        List<OperacionComercial__c> oc;

        System.Debug('xa '+xa);

        if (!xa.isEmpty())
        {       
            oc  = [Select Id, Name FROM OperacionComercial__c WHERE Id = : xa[0].LTE_ServiciosAdicionales__r.LTE_OC_Tramite__r.Id ];
        }
        else
        {
            sa = [Select Id, Name , LTE_OC_Tramite__r.Id FROM LTE_Servicios_adicionales__c WHERE LTE_OC_Tramite__r.Id <> NULL LIMIT 1];
            oc  = [Select Id, Name FROM OperacionComercial__c WHERE Id = : sa[0].LTE_OC_Tramite__r.Id ];
        }
		// //LTE_Lote__c objLote = [select Id, LTE_Legalizacion__c from LTE_Lote__c limit 1];
		// LTE_Lote__c objLote = new LTE_Lote__c( LTE_Legalizacion__c = objLegalizacion.Id);
		// objLote.LTE_Legalizacion__c = objLegalizacion.Id;
		// insert objLote;
		
		Apexpages.Standardcontroller stdController = new Apexpages.Standardcontroller( oc[0] );
		OperacionComercial_ctr controller = new OperacionComercial_ctr( stdController );
		// controller.OperacionComercial_ctr();
	}
}