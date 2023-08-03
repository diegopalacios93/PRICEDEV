/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 02-23-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
public class OperacionComercial_ctr {
    
    public String fechaAsignacionIngeniero {get;set;}
	public OperacionComercial__c opComercial {get; set;}

    public OperacionComercial_ctr(Apexpages.Standardcontroller controller)
	{
		//ctr = controller;
		opComercial = new OperacionComercial__c ();	
		
		opComercial = (OperacionComercial__c)controller.getRecord();
        System.Debug('opComercial '+opComercial);
		List<LTE_Servicios_adicionales__c> servAdicional = [SELECT Id, Name, LTE_OC_Tramite__c, (Select Id, Name,  LTE_Value__c FROM SpecificationGroupXA__r WHERE Name = 'Fecha Asignación Ingeniero')
                                                     FROM LTE_Servicios_adicionales__c
                                                     WHERE LTE_OC_Tramite__c  =: opComercial.Id ];
		
        if(!servAdicional.isEmpty())
        {
            System.Debug('servAdicional '+servAdicional);
            for(LTE_Servicios_adicionales__c sa : servAdicional)
            {   System.Debug('sa '+sa);
              
                if(String.isEmpty(fechaAsignacionIngeniero) && !sa.SpecificationGroupXA__r.isEmpty() && !String.isEmpty(sa.SpecificationGroupXA__r[0].LTE_Value__c))
                {
                    fechaAsignacionIngeniero = sa.SpecificationGroupXA__r[0].LTE_Value__c;
                }
                System.Debug('fechaAsignacionIngeniero '+fechaAsignacionIngeniero);
            }
            	
        }       
	
	}
}