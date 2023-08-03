/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Jorge Grimaldos
Proyecto:           ETB Evolutivos
Descripción:        Librería de funciones útiles de manera transversal
Notas:              Se debe tratar de NO utilizar los métodos de esta clase en implementaciones de Batch o Schedulers si
                    se pretend extender, ya que al ser programado un Batch que utilice esta clase queda bloqueada por
                    caja.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2014-03-17      Jorge Grimaldos (JG)        Creación de la clase.
1.1     2014-04-08      Hector Bayona   (HB)        Metodo consultarServicio.
1.2     2016-07-07      Manuel Cortes   (MC)        Metodo normalizarString.
***********************************************************************************************************************/

public with sharing class LibreriaUtilitaria_cls {

    static public Boolean ErrorExcepcionTest = false;   //  Variable controladora del lanzado de Excepciones en Test

    //  Clase para poder simular el disparo de Excepciones en Test, se puede crear una por cada tipo de Excepción de interés
    static public Exception GenerarExcepcionTest() {
        System.debug('ErrorExcepcionTest:' + ErrorExcepcionTest);
        try {
            if (ErrorExcepcionTest) {
                Integer i;
                Integer j;
                i = j*2;
            }
        }
        catch (Exception e){
            throw e;
        }
        return null;
    }
    
    //Programar Jobs
    /*public static string ProgramarJob(string strEtiqueta, Integer minutos, string strClase) {
        string strRetorno;
        Type typeClase = Type.forName(strClase);
        if (typeClase != null) {
            string strCronExp = Datetime.now().addMinutes(minutos).format('ss mm HH dd MM ? yyyy');
            strRetorno = System.schedule(strEtiqueta + ' ' + strCronExp, strCronExp, (Schedulable)typeClase.newInstance());
        }
        return strRetorno;
    }*/
    
    //Metodo encargado de consultar soap via Http
    public static string consultarServicio(string xml,string metodo,string endpoint){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('SOAPAction',metodo);
        req.setHeader('Accept-Encoding','gzip,deflate');
        req.setHeader('Content-Type','text/xml;charset=UTF-8');
        req.setHeader('User-Agent','Jakarta Commons-HttpClient/3.1');
        req.setTimeout(60000);
        req.setBody(xml);
 
        req.setEndpoint(endpoint);
 
        string bodyRes = '';
        
        HttpResponse res;

        try {
            	res = h.send(req);
            	bodyRes = res.getBody();
                system.debug(bodyRes);
                if(res.getStatusCode()>=400){
                    bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>Error: '+res.getStatusCode()+'</NomError>';
                }
            }
            catch(System.CalloutException e) {
            bodyRes= '<?xml version="1.0" encoding="UTF-8"?><NomError>'+e.getMessage()+'</NomError>';
            }
        
        return bodyRes;
 
       }
    //Qitamos tildes y ñ
    public static string quitarCaracteresEsp(string strFieldValue){
        
        strFieldValue=strFieldValue.toLowerCase();
        
        strFieldValue = strFieldValue.replaceAll('[\\xe0-\\xe6]','a');
        strFieldValue = strFieldValue.replaceAll('[\\xe8-\\xeb]','e');
        strFieldValue = strFieldValue.replaceAll('[\\xec-\\xef]','i');
        strFieldValue = strFieldValue.replaceAll('[\\xf2-\\xf6]','o');
        strFieldValue = strFieldValue.replaceAll('[\\xf9-\\xfc]','u');
        strFieldValue = strFieldValue.replace('ñ', 'n');
        return strFieldValue;
    }
    
    //Realiza una invocacion por Objeto
    static public map<String,Schema.DescribeSObjectResult> desObj=new map<String,Schema.DescribeSObjectResult>();
    
    //Realiza una invocacion por Objeto
    public static Schema.DescribeSObjectResult descrObj(string obj){
    	
    	if(desObj.get(obj)==null){
    		desObj.put(obj,Schema.getGlobalDescribe().get(obj).getDescribe());    		    	
    	}    	    	
    
    	return desObj.get(obj);
    }
    
    //Clona un objeto del mismo tipo ó uno con campos iguales
    public static sobject clonar(Sobject original,string origNomApi,Sobject clon,string clonNomApi,boolean AceptaNull,map<string,string> homologar){
    	
    	Schema.DescribeSObjectResult origS = descrObj(origNomApi);
    	Schema.DescribeSObjectResult clonS = descrObj(clonNomApi);
    	
    	
    	Map<String, Schema.SObjectField> fieldMapClon = clonS.fields.getmap();
    	Map<String, Schema.SObjectField> fieldMapOrig = origS.fields.getmap();
    	map<string,Schema.sObjectField> campos=new map<string,Schema.sObjectField>();
    	
    	//Schema.DescribeFieldResult f = Schema.sObjectType.Account.fields.Name;
    	//f.getSObjectField()

		for(string  campo : fieldMapClon.keySet()){
			Schema.DescribeFieldResult fd = fieldMapClon.get(campo).getDescribe();
			if(fd.isCreateable() && fd.isCustom() && fieldMapOrig.get(campo)!=null && !campo.containsIgnoreCase('Id')){
				campos.put(campo,fieldMapOrig.get(campo));
			}
		}
		
		for(string h:homologar.keySet()){
			campos.put(h,fieldMapClon.get(h));					
		}


		
		for(string c:campos.keySet()){
			if(homologar.get(c)==null &&(original.get(c)!=null || AceptaNull)){
			//Si existe el campo relacionado homologa el api
			object objx=(object)original.get(c);
			clon.put(fieldMapClon.get(c), original.get(c));
			}
			
			if(homologar.get(c)!=null){
				clon.put(fieldMapClon.get(c), original.get(homologar.get(c)));			
			}
			
		}
		return clon;
    }
    
    //Retorna una consulta con base al tipo de objeto.    
    public static string getQuery(string obj, string putWhere,boolean todos){
    	
    	Schema.DescribeSObjectResult origS = Schema.getGlobalDescribe().get(obj).getDescribe();
    	Map<String, Schema.SObjectField> fieldMapOrig = origS.fields.getmap();
    	string dataFields='';
    	
    	//Schema.DescribeFieldResult f = Schema.sObjectType.Account.fields.Name;
    	//f.getSObjectField()

		for(string  campo : fieldMapOrig.keySet()){
			Schema.DescribeFieldResult fd = fieldMapOrig.get(campo).getDescribe();
			if(((fd.isCreateable() && fd.isCustom()) || todos)){
				dataFields+=campo+',';
			}
		}
		dataFields=dataFields.removeEnd(',');
		
		string consulta='Select '+dataFields+' From '+obj+' '+putWhere;
		
		system.debug(consulta);

		
		return consulta;
    
    }
    
    public static OperacionComercial__c clonarOc(sObject g){
    	
    	map<string,string> homologar=new map<string,string>();
    	homologar.put('CuentaCliente__c','NombredelaCuenta__c');
    	homologar.put('Activo__c','Id');
    
		sobject oc=new OperacionComercial__c();
		oc=LibreriaUtilitaria_cls.clonar(g,'ActivoETB__c',oc,'OperacionComercial__c',false,homologar);
		system.debug(oc);
		return (OperacionComercial__c)oc;    
    }
    
	public static list<string> getPicklistValues(SObject obj, String fld)
    {
      list<string> options = new list<string>();
      // Get the object type of the SObject.
      Schema.sObjectType objType = obj.getSObjectType(); 
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      // Get a map of fields for the SObject
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      // Get the list of picklist values for this field.
      list<Schema.PicklistEntry> values =
         fieldMap.get(fld).getDescribe().getPickListValues();
      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a : values)
      { 
         options.add(a.getLabel()); 
      }
      return options;
    }
    
    public static string urlFlujos(Map<String,String> datos, String url){

        for(String s:datos.keySet()){
            String variable='{#'+s+'#}';
            String valor='{#'+s+'Value#}';
            system.debug(variable+' '+datos.get(s));
            url=url.replace(variable,s);
            url=url.replace(valor,datos.get(s));
        }

        return 'saveURL='+EncodingUtil.urlEncode(url, 'UTF-8');
    }
    
    public static string recorreCampos(sobject obj,string campo)
	{
		string valor='';
		list<string>info=campo.split('\\x2E');
		sobject dataInfo;
		Integer i=1;
		
		system.debug('obj-->'+obj);
		
		for(string s :info){
			system.debug('campo: '+s);
			if(info.size()!=i){
				system.debug(s);
                obj=obj.getSObject(s);
                if(obj==null){break;}

			}else{
                string v=(obj.get(s)!=null?String.valueOf(obj.get(s)):'');
				valor=String.valueOf(obj.get(s));			
			}
			i++;
		}

		return valor;
	}
    
    public static String formatCurrency(Decimal i) {
    	if (i == null) return '0';
    	i = Decimal.valueOf(Math.roundToLong(i * 100)) / 100;
    	String s = (i.setScale(2) + (i >= 0 ? 0.001 : -0.001)).format();
    	return s.substring(0, s.length() - 1).removeEnd('.00').removeEnd(',00'); 
	}
	
	public class tramiteLTE{
		
		public string OrderType='';
		public string OrderSubtype='';
		public string ServiceActionCode='';
		public string SubOrderType='';
				
		public tramiteLTE(OperacionComercial__c oc){
		
		}
		
		public string siguienteEstado(boolean error){
		
		return '';
		}
	
	}
	
	public static string formatosFechasAprob(integer codigo,DateTime fecha){
		
		string fechaFormateada='';
		if(codigo==1){
		fechaFormateada=fecha.format('yyyy-MM-dd\'T\'HH:mm:ss\'-05:00\'');
		}
		
		return fechaFormateada;
	}
	
	
	
	/****************************************************
	*Metodo encargado de quitarle los caracteres especiales a un string
	****************************************************/
	public static string normalizarString(String input){
		try{
			String specialChars = Label.Caracteres_Especiales; // '°|!|"|#|$|%|/|(|)|=|?|¡|¬|¿|@|¨|*|‘|’|‚|“|”|‹|›|<|>|‾|+|~|[|]|{|}|`|,|;|:|¨|^|\\|´';
		    String original = Label.Caracteres_Especiales_a_Reemplazar; // '&áàäâéèëêíìïîóòöôúùüûñÁÀÄÂÉÈËÊÍÌÏÎÓÒÖÔÚÙÜÛÑçÇ';
		    String ascii = Label.Caracteres_Especiales_a_Reemplazar_Por; // 'YaaaaeeeeiiiioooouuuunAAAAEEEEIIIIOOOOUUUUNcC';
		    String inputTmp = input;
		
			String[] specialCharsArray = specialChars.split('|');
		    for(integer i=0; i< specialCharsArray.size(); i++){
		    	inputTmp = inputTmp.replace(specialCharsArray[i], '');
		    }
		
		    for (Integer i=1; i<original.length(); i++){
		        inputTmp = inputTmp.replace(original.substring(i-1,i), ascii.substring(i-1,i));
		    }
		    
		    return inputTmp;
		}catch(Exception e){
			System.debug('Ocurrio un error normalizando el String ' + e.getStackTraceString());
			return input;
		}
	        
	}

}