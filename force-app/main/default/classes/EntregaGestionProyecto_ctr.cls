/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - CRM etapa 1
Descripción:            Controlador de la página EntregaGestionProyecto_pag encargada de guardar masivamente
                        el campo de envío gerente proyecto ó envío soporte ventas desde la Legalización.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     19-09-2013  Andrés Cubillos (AAC)       Creación de la clase..
*******************************************************************************/
public with sharing class EntregaGestionProyecto_ctr {
    public map<string,string> mapParameters;
    public string strIdLegalizacion;    
    public Legalizacion__c insLeg;
    public string strNombreLeg {get;set;}
    private string strPageMessage {get;set;}
    
    private string strEstadoGestionado;   
    private string strConfirmacion;    
    private string strEnvio;
    private string strTitulo;
    private string strErrorNoGestionado;
    
    public boolean blnBtnEnviar{get;set;}
    public list<OperacionComercial__c> lstOP;
    
    public EntregaGestionProyecto_ctr(){
        
    }
    
    public void CargarLabels(){
    	strConfirmacion=	Label.EntregaGestionProy_Confirma;
    	strEnvio=			Label.EntregaGestionProy_Envio;
    	strTitulo=			Label.EntregaGestionProy_Titulo;	
    	strEstadoGestionado=Label.EntregaGestionProy_EstGestionado;
    	strErrorNoGestionado=Label.EntregaGestionProy_NoGestionado;
    }
    
    public void Iniciar(){
        
        //leer el parámetro de la página        
        mapParameters = new map<string,string>();
        mapParameters=ApexPages.currentPage().getParameters();
        strIdLegalizacion = mapParameters.get('id');    
        blnBtnEnviar=true;                
        CargarLabels();
        
        system.debug('DEBUG=>strIdLegalizacion='+strIdLegalizacion);
    }
    
    public pageReference AnalizaAccion(){
        string strRta='';
        string strRta2='';
        Iniciar();
        
        if(strIdLegalizacion!=null && strIdLegalizacion!=''){            
                        
            strRta2=VerificarEnvioGerenteP();
            if(strRta2!=''){
                //Hubo al menos una operación comercial que ya había sido enviada al Gerente
            }
        }
        
        return null;
    }

    public string VerificarEnvioGerenteP(){
        string strRta='';
        insLeg=null;
        lstOP= new list<OperacionComercial__c>();     
                
        lstOP= [select Name, id, EnvGteProy__c, EnvSopVen__c, Legalizacion__r.id,Legalizacion__r.Name, TOPP__r.AplicaGerenteProyecto__c,
        		Activo__r.NombredelProducto__r.Name 
         	from OperacionComercial__c
         	where Legalizacion__c= :strIdLegalizacion
         	and Legalizacion__r.Estado__c=:strEstadoGestionado
         	];       
                
        if(lstOP.size()>0){
            strNombreLeg='Legalización: '+lstOP[0].Legalizacion__r.Name;  
            for(OperacionComercial__c c: lstOP){
				if(!c.TOPP__r.AplicaGerenteProyecto__c && c.EnvSopVen__c!=null){
					strRta='\r\nLa Operación Comercial '+c.Name+' ya fue enviada en la fecha: '+c.EnvSopVen__c.format('MM/dd/yyyy HH:mm aaa','GMT-05:00');
					 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strRta));
				}               
                if(c.TOPP__r.AplicaGerenteProyecto__c && c.EnvGteProy__c!=null){
                    strRta='\r\nLa Operación Comercial '+c.Name+' ya fue enviada en la fecha: '+c.EnvGteProy__c.format('MM/dd/yyyy HH:mm aaa','GMT-05:00');
                	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strRta));
                }
            }
            if(strRta!=''){
                blnBtnEnviar=false;
            }       
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, strConfirmacion));
            }   
        }
        else{
        	blnBtnEnviar=false;
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strErrorNoGestionado));
        } 
        system.debug('DEBUG=>strRta='+strRta);
        
        return strRta;
    }
    
    public pageReference Enviar(){
        System.Savepoint svP;
        String strError='';
        Database.SaveResult[] dbResult;
        Datetime Dt1;
        Dt1=System.now();        
        
        try{
        	svP=Database.setSavepoint();	
        	
        	for(OperacionComercial__c c: lstOP){
	           if(!c.TOPP__r.AplicaGerenteProyecto__c && c.EnvSopVen__c==null){
	           		c.EnvSopVen__c=Dt1;
	           }
	           else if(c.TOPP__r.AplicaGerenteProyecto__c && c.EnvGteProy__c==null){
					c.EnvGteProy__c=Dt1;
	           }    
	        }
	        
        	update lstOP;
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, strEnvio +' Fecha/Hora: '+Dt1.format('MM/dd/yyyy HH:mm aaa','GMT-05:00')));
        }
        catch(exception e){
        	Database.rollback(svP);
        	blnBtnEnviar=false;
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        
        return null;
    }
    
    public pageReference Cancelar(){
        PageReference p=null;
        if(strIdLegalizacion!=null){
           p = new PageReference('/'+strIdLegalizacion);
        }
        return p;
    }


}