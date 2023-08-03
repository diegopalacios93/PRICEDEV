/****************************************************************************************************
    Autor:          edwin.bohorquez@globant.com
    Project:        Vlocity - ETB
    Description:    Clase de prueba para Clase que extrae los valores y setearlos en las variables de precio de la clase ETB_SetPricingVariablesCls 

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         9-11-2022         Adrian Bohorquez            Creación de Clase
*****************************************************************************************************/
@isTest(SeeAllData=false)
public with sharing class ETB_SetPricingVariablesCls_tst {

    private static String namespace = 'vlocity_cmt__';
    public static vlocity_cmt__CalculationMatrixVersion__c version;
    public static vlocity_cmt__CalculationMatrix__c parent;
    public static List<vlocity_cmt__CalculationMatrixRow__c> lineItems;
    private static Id orderId;
    private static boolean flag;
   
       @TestSetup
   
           static void makeData(){
                   CreateDataTest.createData();
           }

         @isTest
         private static void invokeMethodTest(){
             String methodName = 'calculateExecutedAmount';
             Map<String, Object>inputMap = new Map<String, Object>();
             Map<String, Object>outMap = new Map<String, Object>(); 
             Map<String, Object>options = new Map<String, Object>();
             String jsinInputData = '';
    
             ETB_SetPricingVariablesCls setPricing = new ETB_SetPricingVariablesCls();
             Test.startTest();
             setPricing.invokeMethod(methodName,inputMap,outMap,options);
             Test.stopTest();
         }

    static private testmethod void calculateTest(){
        //caso:actualiza valores
       Map<String, Object> input = new Map<String, Object>();
       Map<String, Object> output = new Map<String, Object>();
       Map<String, Object> options = new Map<String,Object>();
       String jsinInputData = '';
       String glPricing = '{"Comisiones_por_venta_y_facturacion":{"SoloLectura":false,"Valor":1.0},"Impuestos_regionales_adicionales":{"SoloLectura":false,"Valor":0},"Polizas_y_publicacion":{"SoloLectura":false,"Valor":1.0},"Publicidad":{"SoloLectura":false,"Valor":1.0},"Mintic":{"SoloLectura":false,"Valor":1.0},"ICA_avisos_y_tableros":{"SoloLectura":false,"Valor":1.0},"Contribucion_CRC":{"SoloLectura":false,"Valor":1.0},"4x1000":{"SoloLectura":false,"Valor":1.0},"Provision_de_cartera":{"SoloLectura":false,"Valor":1.0},"ValorTIO":{"SoloLectura":false,"Valor":1.5309},"Capacidad_GB":{"SoloLectura":false,"Valor":40000.0000},"LUN":{"SoloLectura":false,"Valor":400000.0000},"Colocacion":{"SoloLectura":false,"Valor":80000.0000},"CostoInstalacion":{"SoloLectura":false,"Valor":200000.00},"Instalacion":{"SoloLectura":false,"Valor":18371.3108},"CostoAlmacenamiento":{"SoloLectura":true,"Valor":538371.3108},"TarifaPisoMensual":{"SoloLectura":true,"Valor":650210.0000},"TarifaListaMensualSinIVA":{"SoloLectura":true,"Valor":812800.0000},"TarifaListaMensualConIVA":{"SoloLectura":true,"Valor":967232.000000}}'; 
       list<Object> currentQuote = New list<Object>(); 
       List<QuoteLineItem> QLIList = [SELECT Id,vlocity_cmt__LineNumber__c,vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem limit 1]; 
      
       QLIList[0].ETB_GL_JsonPricing__c = glPricing; 
       update  QLIList;
       
        
       jsinInputData = '{\"CantidaddeUsuarios\":null,\"ImpuestosAdicionales\":0.0,\"CostoColaborador\":null,\"Tipodecontrato\":null,\"TiempodeContratoenMeses\":12,\"ID\":\"'+QLIList[0].Id +'\",\"LineNumber\":\"'+QLIList[0].vlocity_cmt__LineNumber__c+'\",\"Quantity\":1.00,\"SourceProductCode\":\"PR_AlmacenamientoExternoLocal\",\"SourceProductName\":\"AlmacenamientoExternoLocal\"}';
       Map<String,Object> jsoninput = (Map<String,Object>)JSON.deserializeUntyped(jsinInputData);
       currentQuote.add(jsoninput);
       input.put('inputData',currentQuote); 
        
       Test.startTest();
       ETB_SetPricingVariablesCls.calculate(input,output,options);   
       Test.stopTest();
    }
   
   }