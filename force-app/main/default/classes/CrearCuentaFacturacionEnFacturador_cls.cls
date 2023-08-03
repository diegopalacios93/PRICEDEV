public class CrearCuentaFacturacionEnFacturador_cls {
	public  string 	NameCF		{get;set;}        
    public  string 	ObjectId;
    public 	string	jsonStringCF;
    public 	map<string,string>   mapParameters;
    public 	List<String>		 lstIdCuentaFacturacion;    
    public  CuentaFacturacion__c objCuentaFact;
    public  set<String> 		 setIdCtaFacturacion	= new set<String>();
    
    
    public pageReference GenerarIntegracion(){
        String resultValidaciones;
        mapParameters = new map<string,string>();
        mapParameters=ApexPages.currentPage().getParameters();
        ObjectId = mapParameters.get('ObjectId');
        consultarCuentaFacturacion();
        resultValidaciones = validaciones();
        if(resultValidaciones != null)
        	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,(label.Msj_ErrorIntegracionFacturador.replace('%error%',resultValidaciones))));    
        else{              			
            lstIdCuentaFacturacion = new list<string>();
            lstIdCuentaFacturacion.add(ObjectId);
            setIdCtaFacturacion.add(lstIdCuentaFacturacion[0]);
            SincronizacionCtasFact_Revchain_cls objCtasFac = new SincronizacionCtasFact_Revchain_cls();
            objCtasFac.CrearCuentasFacturacion(setIdCtaFacturacion);
            
                                  
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,(label.Msj_SolicitudEnviadaAlFacturador)));                    	
        }
        return null;            
    }
    public string validaciones(){
        String strMensajeValidacion = null;
        
        
        if(objCuentaFact.Fue_creada_en_revchain__c)
            strMensajeValidacion = label.Msj_CuentaFactExisteEnFact;
        
        if(objCuentaFact.Facturable__c == false && objCuentaFact.LTE_CuentaFacturacionPadre__c == null)
            strMensajeValidacion = label.Msj_CuentaFactPadreEnBlanco;
        	        
        if(objCuentaFact.Facturable__c == true && objCuentaFact.LTE_CuentaFacturacionPadre__c != null)
        	strMensajeValidacion = label.Msj_NoAsignarCuentaFactPadre;
			
        if(objCuentaFact.LTE_CuentaFacturacionLTE__c == true && objCuentaFact.LTE_CicloFacturacion__c == null)
        	strMensajeValidacion = label.Msj_EscribirCicloFactLTE;
		
        if(objCuentaFact.LTE_CuentaFacturacionLTE__c == false && objCuentaFact.LTE_CicloFacturacion__c != null)
        	strMensajeValidacion = label.Msj_NoEscribirCicloFactLTE;
            
        if(objCuentaFact.DirCorresp__c == null || objCuentaFact.DirCorresp__c == '')
            strMensajeValidacion = label.Msj_DireccionEnBlanco;
		
        if((objCuentaFact.LTE_Email__c != null && objCuentaFact.Confirmacion_Email__c != null) && (objCuentaFact.LTE_Email__c != objCuentaFact.Confirmacion_Email__c))
        	strMensajeValidacion = label.Msj_CoincidirEmailyConfirmacion;
		
        return strMensajeValidacion;
    }
    
    public void consultarCuentaFacturacion(){
        objCuentaFact = [SELECT Tipo_de_cuenta__c, LTE_CuentaFacturacionPadre__c, LTE_CuentaFacturacionLTE__c, LTE_CicloFacturacion__c, 
                     	 DirCorresp__c, LTE_Email__c, Confirmacion_Email__c, Facturable__c, Fue_creada_en_revchain__c
                      	 FROM CuentaFacturacion__c
                      	 WHERE Id =:ObjectId];
    }
    
    public pageReference Cancelar(){
        PageReference p=null;
        if(ObjectId!=null){
           p = new PageReference('/'+ObjectId);
        }
        return p;
    }    
}