/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ReservaNumero_tst {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Numero__c num = new Numero__c();
        num.Name='1234322234';
        insert num;
        
        objPruebas_tst.confPersonalizadas();
		Map<String,sObject> objx=objPruebas_tst.general();
		
        ReservaNumero_ctr ResNum = new ReservaNumero_ctr();
        PageReference pageRef = Page.ReservaNumero;
        Test.setCurrentPage(pageRef);
        OperacionComercial__c OC=(OperacionComercial__c)objx.get('oc');      
       	ApexPages.currentPage().getParameters().put('idOC',OC.id );
       	ResNum.numerobus='1234322234';
       	ResNum.buscarNumero();
       	resNum.generarNumeros();
       	for(ReservaNumero_ctr.wrapperNumero numero :resNum.numerosReserva)
       	{
       		numero.tomado=true;
       	} 
       	resNum.reservar();
       	
    }
}