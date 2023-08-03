/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Servicios Saaw
Descripción:			Test Servicios Saaw
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		17-04-2015	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/

@isTest
private class ServiciosSAAW_tst {

    static testMethod void myUnitTest() {
        objPruebas_tst obj=new objPruebas_tst();
        account cliente =obj.objAccount();
        insert cliente;
        
        map<string,Schema.Recordtypeinfo> RecordT=Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        Contact contacto=obj.objContact();
        contacto.AccountId=cliente.Id;
        insert contacto;
        
        Case caso =obj.objCase();
        caso.AccountId=cliente.Id;
        caso.ContactId=contacto.id;
        caso.RecordTypeId=RecordT.get('SOPORTE TECNICO').getRecordTypeId();
        
        Case caso2 =obj.objCase();
        caso2.AccountId=cliente.Id;
        caso2.ContactId=contacto.id;
        caso2.RecordTypeId=RecordT.get('CASO PQR').getRecordTypeId();
        
        insert new list<Case>{caso,caso2};
        
        list<Case> testCasos=new list<Case>([select CaseNumber, id from Case]);
        
        
        Test.startTest();
        ServiciosSAAW servicio=new ServiciosSAAW();
        ServiciosSAAW.caso c=new ServiciosSAAW.caso();
        
        c=ServiciosSAAW.consulta_saaw('00fallo');
        c=ServiciosSAAW.consulta_saaw(testCasos[0].CaseNumber);
        c=ServiciosSAAW.consulta_saaw(testCasos[1].CaseNumber);
        
        ServiciosSAAW.infoAjuste iA=new ServiciosSAAW.infoAjuste();
        iA.valorAjustado=240311;
        iA.numeroCaso=testCasos[0].CaseNumber;
        
        ServiciosSAAW.ajuste_saaw(iA);
        
        iA.numeroCaso='00fallo';
        ServiciosSAAW.ajuste_saaw(iA);
        
        iA.numeroCaso=testCasos[1].CaseNumber;
        ServiciosSAAW.ajuste_saaw(iA);
        
        Test.stopTest();
        

    }
    
    static testMethod void ErrorExcepcionTest() {
        objPruebas_tst obj=new objPruebas_tst();
        account cliente =obj.objAccount();
        insert cliente;
        
        map<string,Schema.Recordtypeinfo> RecordT=Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        Contact contacto=obj.objContact();
        contacto.AccountId=cliente.Id;
        insert contacto;
        
        
        Case caso =obj.objCase();
        caso.AccountId=cliente.Id;
        caso.ContactId=contacto.id;
        caso.RecordTypeId=RecordT.get('CASO PQR').getRecordTypeId();
        
        insert caso;
        
        list<Case> testCasos=new list<Case>([select CaseNumber, id from Case]);
        
        
        Test.startTest();
        ServiciosSAAW servicio=new ServiciosSAAW();
        ServiciosSAAW.caso c=new ServiciosSAAW.caso();
        
        LibreriaUtilitaria_cls.ErrorExcepcionTest=true;
        
        c=ServiciosSAAW.consulta_saaw(testCasos[0].CaseNumber);

        
        ServiciosSAAW.infoAjuste iA=new ServiciosSAAW.infoAjuste();
        iA.valorAjustado=240311;
        iA.numeroCaso=testCasos[0].CaseNumber;
        
        ServiciosSAAW.ajuste_saaw(iA);
        
       
        Test.stopTest();
        

    }
    
}