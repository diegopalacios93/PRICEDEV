public class ActualizarCuentaFactEnFacturador_cls {
	public  string 	NameCF				 {get;set;}        
    public  boolean enableUpdateName	 {get;set;}
    public  boolean enableUpdateDefault	 {get;set;}   
    public 	map<string,string>   		 mapParameters;
    public 	List<String>		 		 lstIdCuentaFacturacion;    
    public  List<CuentaFacturacion__c>	 lstCuentasFacturacion;    
    public  poblacion__c				 objPoblacion;   
    public	LogTransacciones__c 		 objLog 	= new LogTransacciones__c();
    public  string  accion;				
    public  string 	ObjectId;
    public 	string	jsonStringCF;    
    
    
    public pageReference AnalizarAccion(){
        enableUpdateName 		= false;
        enableUpdateDefault		= true;
        mapParameters = new map<string,string>();
        mapParameters=ApexPages.currentPage().getParameters();
        ObjectId = mapParameters.get('ObjectId');
        accion 	 = mapParameters.get('Accion');  
        consultarCuentaFacturacion();           
        if(accion == 'ActualizarNombre'){
           Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,(label.Msj_ConfirmarActualizacionNombreCF))); 
           enableUpdateName 	= true;
           enableUpdateDefault 	= false;
        }
        if(accion == 'ActualizarDatos'){            
            if(lstCuentasFacturacion[0].Facturable__c)
            	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,(label.Msj_ConfirmarActualizacionDatosCF))); 
            else
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,(label.Msj_ConfirmarActualizacionDatosCFHija))); 
                        
            enableUpdateName 		= true;
           	enableUpdateDefault 	= false;
        }        
        return null;            
    }
    public pageReference GenerarIntegracion(){        
        String resultValidaciones;
        map<string,string>  mapRtaSync	= new map<string,string>();
        mapParameters = new map<string,string>();        
        mapParameters=ApexPages.currentPage().getParameters();
        
        if(accion == 'ActualizarDatos'){            
            resultValidaciones = validaciones();
            if(resultValidaciones != null)
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,(label.Msj_ErrorIntegracionFacturador.replace('%error%',resultValidaciones))));    
            else{                                  
                consultarPoblacion();                
                ConstruccionCanonicoCtasFact_cls canonico = new ConstruccionCanonicoCtasFact_cls();
				mapRtaSync = canonico.orquestarIntegracion(lstCuentasFacturacion,accion); 
                
                if(mapRtaSync.get('Code') == '0')
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,(label.Msj_ActualizacionCFOk)));                                                            	
                else
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,(label.Msj_ErrorIntegracionFacturador.replace('%error%',mapRtaSync.get('Description')))));     
			}
            enableUpdateName 		= false;
           	enableUpdateDefault 	= true;
        }     
        if(accion == 'ActualizarNombre'){ 
            consultarCuentasDeFacturacion();
            resultValidaciones = validaciones();
            if(resultValidaciones != null){
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,(label.Msj_ErrorIntegracionFacturador.replace('%error%',resultValidaciones))));
            	enableUpdateName 		= false;
           		enableUpdateDefault 	= true;
            }else{
            	enableUpdateName 		= false;
           		enableUpdateDefault 	= true;
                setFlagActualizarCuentasFact(true);
                
                CuentasFacturacion_bch facttbtch = new CuentasFacturacion_bch();               
                ID batchprocessid = Database.executeBatch(facttbtch,10);
                system.debug('==>batchprocessid UpdateCuentasFacturacion:'+batchprocessid);      
                
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,(label.Msj_confirmacionIntegracionActualizacion)));
            }
        }
        return null;     
    }
    public string validaciones(){
        String strMensajeValidacion = null;        
        
        if(accion == 'ActualizarDatos'){
            for(CuentaFacturacion__c objCuentaFact : lstCuentasFacturacion){
                if(!objCuentaFact.Fue_creada_en_revchain__c)
                    strMensajeValidacion = ' '+label.Msj_confirmacionCreacionCtaFact;
                
                if(objCuentaFact.Facturable__c == false && objCuentaFact.LTE_CuentaFacturacionPadre__c == null)
                    strMensajeValidacion += ' '+label.Msj_CuentaFactPadreEnBlanco;
                            
                if(objCuentaFact.Facturable__c == true && objCuentaFact.LTE_CuentaFacturacionPadre__c != null)
                    strMensajeValidacion += ' '+label.Msj_NoAsignarCuentaFactPadre;
                    
                if(objCuentaFact.LTE_CuentaFacturacionLTE__c == true && objCuentaFact.LTE_CicloFacturacion__c == null)
                    strMensajeValidacion += ' '+label.Msj_EscribirCicloFactLTE;
                
                if(objCuentaFact.LTE_CuentaFacturacionLTE__c == false && objCuentaFact.LTE_CicloFacturacion__c != null)
                    strMensajeValidacion += ' '+label.Msj_NoEscribirCicloFactLTE;
                    
                if(objCuentaFact.DirCorresp__c == null || objCuentaFact.DirCorresp__c == '')
                    strMensajeValidacion += ' '+label.Msj_DireccionEnBlanco;
                
                if((objCuentaFact.LTE_Email__c != null && objCuentaFact.Confirmacion_Email__c != null) && (objCuentaFact.LTE_Email__c != objCuentaFact.Confirmacion_Email__c))
                    strMensajeValidacion += ' '+label.Msj_CoincidirEmailyConfirmacion;
            }
        } 
        if(accion == 'ActualizarNombre'){ 
            if(lstCuentasFacturacion.size() < 1)
                strMensajeValidacion = label.Msj_noExisteCF;
        }
        return strMensajeValidacion;
    }
    
    public void consultarCuentaFacturacion(){
        lstCuentasFacturacion = [SELECT
                                 Id, LTE_NombreCuentaFacturacion__c, Cliente__r.Name, Ciudad__r.Padre__r.CodigoDane__c, LTE_Email__c, DirCorresp__c, 
                                 Ciudad__r.Name, Ciudad__r.CodigoDane__c, LTE_DepartamentoFacturacion__c, LTE_MetodoEnvio__c, Name, Fue_creada_en_revchain__c,
								 Facturable__c, LTE_CuentaFacturacionPadre__c, LTE_CuentaFacturacionLTE__c, LTE_CicloFacturacion__c, Confirmacion_Email__c
                        		 FROM CuentaFacturacion__c 
                        		 WHERE Id =: ObjectId];
    }
    
    public void consultarCuentasDeFacturacion(){
    	lstCuentasFacturacion = new List<CuentaFacturacion__c>();
        if(ObjectId != null){
        	lstCuentasFacturacion = [Select Id, Name From CuentaFacturacion__c Where Cliente__r.Id =:ObjectId AND
                                     Fue_creada_en_revchain__c = TRUE];
        }
    }
    
    public pageReference Cancelar(){
        PageReference p=null;
        if(ObjectId!=null){
           p = new PageReference('/'+ObjectId);
        }
        return p;
    }    
    public void consultarPoblacion(){
        objPoblacion = [Select Id, Name, CodigoDane__c, Padre__r.CodigoDane__c, Tipo_Ciudad__c, Indicativo__c
                        From Poblacion__c where Id IN (Select Ciudad__c from CuentaFacturacion__c Where Id =:ObjectId)];
    } 
    public void setFlagActualizarCuentasFact(Boolean setAction){
        Account objAccount;
        objAccount = [Select Id, Actualizar_nombres_cuentas_facturacion__c FROM Account Where Id =:ObjectId];
        if(objAccount.Id != NULL){
            objAccount.Actualizar_nombres_cuentas_facturacion__c = setAction;                
            update objAccount;
        }
    }
}