/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Grupo 7 Checklist
Descripción:			Test Checklist para la aprobacion de la Legalización.
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		06-11-2014	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/
@isTest
private class CheckList_tst {
	
	static testMethod void CheckList() {
		
        objPruebas_tst obj =new objPruebas_tst();
        
    	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
    	
    	Account cliente=obj.ObjAccount();
    	cliente.RecordTypeId =devRecordTypeId;
    	System.debug(devRecordTypeId);
    	insert cliente;
    	
    	Contract contrato=obj.objContrato();
    	contrato.Accountid =cliente.Id;
    	insert contrato;
    	
    	Legalizacion__c leg=obj.objLeg();
    	leg.Contrato__c=contrato.id;
    	insert leg;
    	
    	Checklist__c chck=obj.objChecklist();
    	chck.NO_Legalizacion__c=leg.id;
    	insert chck;
    	
    	test.startTest();
    	PageReference pageRef0 = Page.CheckListPdf;
    	Test.setCurrentPage(pageRef0);
        ApexPages.currentPage().getParameters().put('id', leg.id);
        CheckList_ctr ch =new CheckList_ctr();
        ch.getCheckLeg();

        
    	test.stopTest();
		
		
	}

}