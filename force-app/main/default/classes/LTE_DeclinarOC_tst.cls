/***************************************************************************************************************************
*** Desarrollado por:       Avanxo Colombia                                                                              ***
*** Autor:                  Andrés Oliva (AO)                                                                            ***
*** Proyecto:               ETB - LTE                                                                                    ***
*** Descripcion:            Clase de prueba d ela clase LTE_DeclinarOC_bch                                               ***
***                          
*** User history:                                                                                                        ***
*** Sprint:                                                                                                              ***
*** Release:                                                                                                             ***
***                                                                                                                      ***    
*** Cambios (Versiones)                                                                                                  ***
*** -------------------------------------                                                                                ***
***             No.     Fecha           Autor                   Descripción                                              ***    
***            -----    ----------      --------------------    ---------------                                          ***
*** @version    1.0     2015-06-26      Andrés Oliva (AO)      Class created                                             ***
***************************************************************************************************************************/
@isTest
private class LTE_DeclinarOC_tst
{
    public static  OperacionComercial__c oOPeracionComercial;

     public static void CreateData()
    {
       oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
       system.debug('\nDebug OperaciOn Comercial \n'+ oOPeracionComercial );
       VariablesGlobales__c vGlobal = new VariablesGlobales__c();
       vGlobal.Name = 'NombreComercialLTE';
       vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
       insert vGlobal;
       
       VariablesGlobales__c vGlobal1 = new VariablesGlobales__c();
       vGlobal1.Name = 'EstadoDeclinadoOC';
       vGlobal1.Valor__c = 'Declinada';
       insert vGlobal1;
       
       VariablesGlobales__c vGlobal2 = new VariablesGlobales__c();
       vGlobal2.Name = 'ToppRenovacion';
       vGlobal2.Valor__c = 'Renovación';
       insert vGlobal2;
       
       VariablesGlobales__c vGlobal3 = new VariablesGlobales__c();
       vGlobal3.Name = 'ToppReposicion';
       vGlobal3.Valor__c = 'Reposición';
       insert vGlobal3;
       
       VariablesGlobales__c vGlobal4 = new VariablesGlobales__c();
       vGlobal4.Name = 'ToppVentas';
       vGlobal4.Valor__c = 'Venta';
       insert vGlobal4;
       VariablesGlobales__c vGlobal5 = new VariablesGlobales__c();
       vGlobal5.Name = 'DiasDeclinacionOC';
       vGlobal5.Valor__c = '1';
       insert vGlobal5;
    }

     public static testMethod void test_method_one() 
    {
        Test.startTest();
            CreateData();           
            LTE_DeclinarOC_sch sh1 = new LTE_DeclinarOC_sch();
            String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);         
       Test.stopTest();
    }
}