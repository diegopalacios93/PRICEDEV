/**************************************************************************************************
Desarrollado por:   Accenture
Autor:              Johan  Olarte (JOL)
Proyecto:           ETB S.A.
Descripción:        Clase Apex para consultar los productos avanzados y basicos Mipymes 

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autor                   Descripción
-----   ----------      --------------------    ---------------------------------------------------
1.0     2021-11-23      Johan  Olarte           Creacion
1.1     2021-11-29      Lucas Cano              Desarrollo
1.2     2021-12-09      Julian Velasco          Desarrollo
1.3     2022-01-18      Julian Velasco          Modificacion, se realizo una modificacion para enviar
                                                el segmento, sin importar si sus productos son avanzados activos
***************************************************************************************************/

@RestResource(urlMapping='/CatalogoProductos__c/*')
global with sharing class DEG_GetProduct_Advanced_basic_ws {
        
    @HttpGet                      
    global static ResponseService getAdvanced(){
        Integer numeroDocumento=0;
        String documento = RestContext.request.params.get('documento');
        System.debug('numero de documento '+documento); 
        ResponseService response = new ResponseService();
        try{  
            numeroDocumento = integer.valueof(documento);
            List<CatalogoProductos__c> lstCatalogoProductos =  [SELECT id, name, Estado__c, Aliado__r.Tipodedocumento__c,Tipo_de_Producto__c FROM CatalogoProductos__c WHERE Aliado__r.AccountNumber = :documento AND Tipo_de_Producto__c='Avanzado' 
            AND Aliado__c != NULL AND Estado__c = 'Activo'];
            System.debug('lista de productos: '+lstCatalogoProductos);
            List<CatalogoProductos__c> segmento =  [SELECT Aliado__r.Segmento__c FROM CatalogoProductos__c WHERE Aliado__r.AccountNumber = :documento];
            System.debug('segmento ' + segmento);
            String segment = segmento[0].Aliado__r.Segmento__c;
            response = new ResponseService('OK', 200, lstCatalogoProductos, segment);
            return response;
            
        }
        catch (Exception ex){ return response = new ResponseService(ex.getMessage(), 500, null, null); }   
    }

    global virtual class ResponseBase{
		global Integer statusCode;
		global String message;
	}

	global class ResponseService extends ResponseBase{
		global List<CatalogoProductos__c> lstCatalogodeProd;
		global String segmento;

		global responseService(){
			this.message = '';
			this.statusCode = 0;
		}

		global responseService(String strMsn, Integer intCode, List<CatalogoProductos__c> lstCatalogodeProdp, String segment){
			this.message = strMsn;
			this.statusCode = intCode;
			this.lstCatalogodeProd = lstCatalogodeProdp;
            this.segmento = segment;
		}
	}
}