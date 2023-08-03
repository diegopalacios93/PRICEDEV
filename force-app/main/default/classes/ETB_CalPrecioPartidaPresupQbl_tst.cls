/****************************************************************************************************
    Autor:          jf.rosales@globant.com
    Project:        Vlocity - ETB
    Description:    

    Información de Cambios (Versiones)
    -------------------------------------
    No.         Fecha             Autor                      Descripción
    ------      ----------        ------------------         --------------------
    1.0         20-11-2022        Juan Francisco Rosales     Creación de la clase      
*****************************************************************************************************/
@isTest
public with sharing class ETB_CalPrecioPartidaPresupQbl_tst {
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
    private static void CalPrecioPartidaPresupQblTest(){
        //caso:actualiza valores
       Map<String, Object> input = new Map<String, Object>();
       Map<String, Object> output = new Map<String, Object>();
       Map<String, Object> options = new Map<String,Object>();
       
       String jsinInputData = '';
       String glPricing = '{"Comisiones_por_venta_y_facturacion":{"SoloLectura":false,"Valor":1.0},"Impuestos_regionales_adicionales":{"SoloLectura":false,"Valor":0},"Polizas_y_publicacion":{"SoloLectura":false,"Valor":1.0},"Publicidad":{"SoloLectura":false,"Valor":1.0},"Mintic":{"SoloLectura":false,"Valor":1.0},"ICA_avisos_y_tableros":{"SoloLectura":false,"Valor":1.0},"Contribucion_CRC":{"SoloLectura":false,"Valor":1.0},"4x1000":{"SoloLectura":false,"Valor":1.0},"Provision_de_cartera":{"SoloLectura":false,"Valor":1.0},"ValorTIO":{"SoloLectura":false,"Valor":1.5309},"Capacidad_GB":{"SoloLectura":false,"Valor":40000.0000},"LUN":{"SoloLectura":false,"Valor":400000.0000},"Colocacion":{"SoloLectura":false,"Valor":80000.0000},"CostoInstalacion":{"SoloLectura":false,"Valor":200000.00},"Instalacion":{"SoloLectura":false,"Valor":18371.3108},"CostoAlmacenamiento":{"SoloLectura":true,"Valor":538371.3108},"TarifaPisoMensual":{"SoloLectura":true,"Valor":650210.0000},"TarifaListaMensualSinIVA":{"SoloLectura":true,"Valor":812800.0000},"TarifaListaMensualConIVA":{"SoloLectura":true,"Valor":967232.000000}}'; 
       String attValuesSelected = '{"ATT_SF_TipoCatalogo":"Portafolio Superior","ATT_SF_CiudadNodoOrigen":"Bogotá","ATT_SF_TipoUltimaMilla":"FIBRA ETB M1000 Bogotá","ATT_SF_AnchoBanda":"200Mbps","ATT_SF_AnchoBandaHaciaNAP":null,"ATT_SF_CategoriaEnlace":"Pto. Central","ATT_SF_CiudadNodoDestino":"Bogotá","ATT_SF_ClausulaTerminacionAnticipada":"Sí Acepta","ATT_SF_GestionUnificada":"Servicio Básico","ATT_SF_VigenciaViabilidadDias":null,"ATT_SF_TiempoContratoDias":null,"ATT_SF_TiempoContratoMeses":12,"ATT_SF_TipoContrato":"Nuevo","ATT_SF_Versionamiento_Dirección_IP":null,"ATT_SF_Comentarios":null,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Ciudad_Nodo_Origen":null,"ATT_Disponibilidad_de_Servicio":null,"ATT_Identificador_de_Servicio":null,"ATT_Nemonico":"ID","ATT_Tipo_de_Ultima_Milla":null,"ATT_Topología":null,"ATT_UM _Otro _Operador_o_ETB_Satelital":null,"ATT_Vigencia_Viabilidad_Dias":null,"ATT_Ancho_Banda":null,"ATT_Ancho_de_Banda_hacia_NAP":null,"ATT_Capa":null,"ATT_Gestión_Unificada":"Servicio Básico","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":null}';
       list<Object> currentQuote = New list<Object>(); 
       QuoteLineItem QLIList = [SELECT Id,QuoteId,vlocity_cmt__LineNumber__c,vlocity_cmt__AttributeSelectedValues__c,Product2.ProductCode FROM QuoteLineItem limit 1]; 
      
       QLIList.ETB_GL_JsonPricing__c = glPricing; 
       QLIList.vlocity_cmt__AttributeSelectedValues__c = attValuesSelected;
       update QLIList;

       Test.startTest();
       Id quoteId = (Id) QLIList.QuoteId;
       Decimal porcentajeAsignacion = 100;
       Boolean ultimoElemento = true;
       System.enqueueJob(new ETB_CalculoPrecioPartidaPresupuestoQbl(QLIList,porcentajeAsignacion,ultimoElemento));  
     
      Test.stopTest();
    } 
    
     @isTest
    private static void CalPrecioNoUltimoElemento(){
        //caso:actualiza valores
       Map<String, Object> input = new Map<String, Object>();
       Map<String, Object> output = new Map<String, Object>();
       Map<String, Object> options = new Map<String,Object>();
       
       String jsinInputData = '';
       String glPricing = '{"Comisiones_por_venta_y_facturacion":{"SoloLectura":false,"Valor":1.0},"Impuestos_regionales_adicionales":{"SoloLectura":false,"Valor":0},"Polizas_y_publicacion":{"SoloLectura":false,"Valor":1.0},"Publicidad":{"SoloLectura":false,"Valor":1.0},"Mintic":{"SoloLectura":false,"Valor":1.0},"ICA_avisos_y_tableros":{"SoloLectura":false,"Valor":1.0},"Contribucion_CRC":{"SoloLectura":false,"Valor":1.0},"4x1000":{"SoloLectura":false,"Valor":1.0},"Provision_de_cartera":{"SoloLectura":false,"Valor":1.0},"ValorTIO":{"SoloLectura":false,"Valor":1.5309},"Capacidad_GB":{"SoloLectura":false,"Valor":40000.0000},"LUN":{"SoloLectura":false,"Valor":400000.0000},"Colocacion":{"SoloLectura":false,"Valor":80000.0000},"CostoInstalacion":{"SoloLectura":false,"Valor":200000.00},"Instalacion":{"SoloLectura":false,"Valor":18371.3108},"CostoAlmacenamiento":{"SoloLectura":true,"Valor":538371.3108},"TarifaPisoMensual":{"SoloLectura":true,"Valor":650210.0000},"TarifaListaMensualSinIVA":{"SoloLectura":true,"Valor":812800.0000},"TarifaListaMensualConIVA":{"SoloLectura":true,"Valor":967232.000000}}'; 
       String attValuesSelected = '{"ATT_SF_CostosAproximadosObrasCiviles":0,"ATT_SF_MetrosTendidoFoUM":0,"ATT_SF_TipoCatalogo":"Portafolio Superior","ATT_SF_CiudadNodoOrigen":"Bogotá","ATT_SF_DisponibilidadServicio":null,"ATT_SF_Nemonico":"ID","ATT_SF_TipoUltimaMilla":"FIBRA ETB M1000 Bogotá","ATT_SF_Topologia":null,"ATT_SF_UMOtroOperadorETBSatelital":null,"ATT_SF_AnchoBanda":"200Mbps","ATT_SF_AnchoBandaHaciaNAP":null,"ATT_SF_Capa":null,"ATT_SF_CategoriaEnlace":"Pto. Central","ATT_SF_CiudadNodoDestino":"Bogotá","ATT_SF_ClausulaTerminacionAnticipada":"Sí Acepta","ATT_SF_GestionUnificada":"Servicio Básico","ATT_SF_VigenciaViabilidadDias":null,"ATT_SF_TiempoContratoDias":null,"ATT_SF_TiempoContratoMeses":12,"ATT_SF_TipoContrato":"Nuevo","ATT_SF_Versionamiento_Dirección_IP":null,"ATT_SF_Comentarios":null,"ATT_Tipo_de_catalogo":"Portafolio Superior","ATT_Ciudad_Nodo_Origen":null,"ATT_Disponibilidad_de_Servicio":null,"ATT_Identificador_de_Servicio":null,"ATT_Nemonico":"ID","ATT_Tipo_de_Ultima_Milla":null,"ATT_Topología":null,"ATT_UM _Otro _Operador_o_ETB_Satelital":null,"ATT_Vigencia_Viabilidad_Dias":null,"ATT_Ancho_Banda":null,"ATT_Ancho_de_Banda_hacia_NAP":null,"ATT_Capa":null,"ATT_Categoria_de_Enlace":null,"ATT_Ciudad_Nodo_Destino":null,"ATT_Clausula_de_Terminacion_Anticipada":null,"ATT_Gestión_Unificada":"Servicio Básico","ATT_TiempoContratoDias":null,"ATT_TiempoContratoMeses":null,"ATT_Tipo_de_contrato":null,"ATT_Versionamiento_Dirección_IP":null,"ATT_Comentarios":null';
       list<Object> currentQuote = New list<Object>(); 
       QuoteLineItem QLIList = [SELECT Id,QuoteId,vlocity_cmt__LineNumber__c,vlocity_cmt__AttributeSelectedValues__c,Product2.ProductCode FROM QuoteLineItem limit 1]; 
      
       QLIList.ETB_GL_JsonPricing__c = glPricing; 
       QLIList.vlocity_cmt__AttributeSelectedValues__c = attValuesSelected;
       update QLIList;

       Test.startTest();
       Id quoteId = (Id) QLIList.QuoteId;
       Decimal porcentajeAsignacion = 100;
       Boolean ultimoElemento = false;
       System.enqueueJob(new ETB_CalculoPrecioPartidaPresupuestoQbl(QLIList,porcentajeAsignacion,ultimoElemento));  
       Test.stopTest();
    } 
    
}