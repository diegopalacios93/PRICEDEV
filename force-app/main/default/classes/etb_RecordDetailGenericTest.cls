/*---------------------------------------------------------------------------------------------------------------
--- Company: LabsXD
--- Author: 
--- Description: Clase test para EtbRecordDetailGeneric
--- CreateDate:  12/10/2021
--- Update for: -
--- UpdateDate: - 
--- Update Description: -
---------------------------------------------------------------------------------------------------------------*/
@isTest
public with sharing class etb_RecordDetailGenericTest {
   
    @isTest
    static void getMetadata(){
        Test.startTest();
        List<etb_RecordLayoutGeneric__mdt> resp =  etb_RecordDetailGeneric.getMetadata('Order');
        Test.stopTest();
        System.assertNotEquals(0, resp.size());

    }

    @isTest
    static void getMetadataEmpty(){
        Test.startTest();
        List<etb_RecordLayoutGeneric__mdt> resp = etb_RecordDetailGeneric.getMetadata('TestGetMetadataEmpty');
        Test.stopTest();
        System.assertEquals(0, resp.size());

    }
    
    @isTest
    static void checkAccesibleFieldTest(){
        List<String> fieldList = new List<String>();
        fieldList.add('vlocity_cmt__Jurisdiction2__c');
        Test.startTest();
        String resp = etb_RecordDetailGeneric.checkAccesibleField('Account',fieldList);
        Test.stopTest();
      //  System.assertEquals(0, resp.size());
        
    }
    
    
}