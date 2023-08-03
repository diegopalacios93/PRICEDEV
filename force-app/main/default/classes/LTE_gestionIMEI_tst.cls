/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Carlos Gonzalez
Proyecto:           LTE Evolutivos
Descripción:        Test del Controlador para la Ventana de gestión de IMEI

Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     15-07-2016  Carlos Gonzalez (CG)        Creación de la clase.
***********************************************************************************************************************/
@isTest
public class LTE_gestionIMEI_tst
{
    public static Id gestionId;
    
    public static void crearData()
    {
        objPruebas_tst.confPersonalizadas();

        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');

        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        list<ReglasDesarrollos__c> listareglas = new list<ReglasDesarrollos__c>();
        ReglasDesarrollos__c reglas = new ReglasDesarrollos__c();
        reglas.Name='Legalizacion1';
        reglas.Activo__c=true;
        ReglasDesarrollos__c reglas1 = new ReglasDesarrollos__c();
        reglas1.Name='Legalizacion2';
        reglas1.Activo__c=true;
        ReglasDesarrollos__c reglas2 = new ReglasDesarrollos__c();
        reglas2.Name='Contratos1';
        reglas2.Activo__c=true;
        listareglas.add(reglas);
        listareglas.add(reglas1);
        listareglas.add(reglas2);
        insert listareglas;
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
        
        gestionId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get(Label.LTE_Titulo_Gestion_IMEI).getRecordTypeId();
        
        OperacionComercial__c objOC = new OperacionComercial__c();
        objOC.NumeroConexion__c = '3001234567';
        objOC.IMEI_del_Equipo__c =  '354589658745155';
        objOC.FechadeActivacion__c = Date.today();
        objOC.RecordTypeId = gestionId;
        objOC.Estado__c = 'En Curso';
        
        insert objOC;
        
        
        List<SObject> inConf=new List<SObject>();
        inConf.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        insert inConf;
        
    }
    
    static testMethod void TestOne() 
    {
        crearData();

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockServiciosWeb.MockHttpResponseIMEIRegistroNegativo());

        List<OperacionComercial__c> scope = [SELECT NumeroConexion__c, IMEI_del_Equipo__c, Activo__r.Name, Estado__c, Comentarios__c FROM OperacionComercial__c WHERE Estado__c = 'En Curso' AND RecordTypeId =: gestionId];
        
        LTE_gestionIMEI_ctr gestion = new LTE_gestionIMEI_ctr(scope);
        gestion.debloquearBch();
        
        Test.stopTest();
    }

}