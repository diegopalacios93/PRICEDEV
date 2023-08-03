/****************************************************************************************************
    Autor:          jf.rosales@globant.com
    Project:        Vlocity - ETB
    Description:    

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                     Descripción
    ------      ----------        ------------------        --------------------
    1.0         20-11-2022        Juan Francisco Rosales    Creación de la clase      
*****************************************************************************************************/
@isTest
public class ETB_CalculoPrecioQbl_tst {
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
    private static void ETB_CalculoPrecioQblTest(){
       Map<String, Object> input = new Map<String, Object>();
       Map<String, Object> output = new Map<String, Object>();
       Map<String, Object> options = new Map<String,Object>();
       
       String jsinInputData = '';
       String glPricing = '{"Comisiones_por_venta_y_facturacion":{"SoloLectura":false,"Valor":1.0},"Impuestos_regionales_adicionales":{"SoloLectura":false,"Valor":0},"Polizas_y_publicacion":{"SoloLectura":false,"Valor":1.0},"Publicidad":{"SoloLectura":false,"Valor":1.0},"Mintic":{"SoloLectura":false,"Valor":1.0},"ICA_avisos_y_tableros":{"SoloLectura":false,"Valor":1.0},"Contribucion_CRC":{"SoloLectura":false,"Valor":1.0},"4x1000":{"SoloLectura":false,"Valor":1.0},"Provision_de_cartera":{"SoloLectura":false,"Valor":1.0},"ValorTIO":{"SoloLectura":false,"Valor":1.5309},"Capacidad_GB":{"SoloLectura":false,"Valor":40000.0000},"LUN":{"SoloLectura":false,"Valor":400000.0000},"Colocacion":{"SoloLectura":false,"Valor":80000.0000},"CostoInstalacion":{"SoloLectura":false,"Valor":200000.00},"Instalacion":{"SoloLectura":false,"Valor":18371.3108},"CostoAlmacenamiento":{"SoloLectura":true,"Valor":538371.3108},"TarifaPisoMensual":{"SoloLectura":true,"Valor":650210.0000},"TarifaListaMensualSinIVA":{"SoloLectura":true,"Valor":812800.0000},"TarifaListaMensualConIVA":{"SoloLectura":true,"Valor":967232.000000}}'; 
       list<Object> currentQuote = New list<Object>(); 
       List<QuoteLineItem> QLIList = [SELECT Id,QuoteId,vlocity_cmt__LineNumber__c,vlocity_cmt__AttributeSelectedValues__c FROM QuoteLineItem limit 1]; 
      
       QLIList[0].ETB_GL_JsonPricing__c = glPricing; 
       update  QLIList;

       Test.startTest();
       Id quoteId = (Id) QLIList[0].QuoteId;
        /* 
       Integer largoArreglo = QLIList.size(); 
       Integer contador = 1;
       Boolean ultimoElemento = false;
       
       Decimal porcentajeAsignacion = 100;
       for(QuoteLineItem partidaPresupuesto :QLIList ) {
            ultimoElemento = contador==largoArreglo;               
            System.enqueueJob(new ETB_CalculoPrecioPartidaPresupuestoQbl(partidaPresupuesto,porcentajeAsignacion,ultimoElemento));  
            contador+=1;                
        } 
       */
        System.enqueueJob(new ETB_CalculoPrecioQbl(quoteId));
       Test.stopTest();
    } 
}