/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - CRM etapa 1
Descripción:            Controlador de la página OperacionesComercialesLegalizar_pag encargada de seleccionar
                        las operaciones comerciales a legalizar 

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     23-09-2013  Andrés Cubillos (AAC)       Creación de la clase..
1.1		26-11-2013	Daniel Guana (DGUANA)		Evolutivo asociación de cuenta (antes campo formula)
1.2		31-01-2014	Jorge Grimaldos	(JG)		Ajuste requerimiento 2 paquete 20 de Enero: Validar que los campos
												obligatorios de la OC se encuentren diligenciados
1.3		07-02-2014	Jorge Grimaldos (JG)		Ajustes Pruebas UAT Paquete 20-01-2013
*******************************************************************************/
public with sharing class OperacionesComercialesLegalizar_ctr {
        
        public map<string,string> mapParameters;
        private string strConfirmacion='¿Confirma envío legalización?';
        private string strNoHayOP='No se encontró ninguna Operación Comercial pendiente para legalizar';  
        private string strDebeSelec='Debe Seleccionar al menos una Operación Comercial';
        public string strIdContrato;
        private Contract insContract;
        public string strNombreCon {get;set;}
        public boolean blnBtnCrear {get;set;}
        public boolean blnLista {get;set;}
        public boolean blnOpSelected {get;set;}
        
        private string strFiltro1='cerrada ganada';
        private string strFiltro2='cerrada perdida';
        private string strEstadoViable='Viable';
        
        public list<wrpResultados> lstResult {get;set;}
        public boolean blnValidaSel{get;set;}
        public wrpResultados insWrp;
        
        public OperacionesComercialesLegalizar_ctr(){
                
        }
        
        public class wrpResultados{
                public OperacionComercial__c OpCome {get;set;}
                public boolean blnSel {get;set;}
                public wrpResultados(){
                        OpCome = new OperacionComercial__c();   
                        blnSel=false;           
                }
                
        }
        
        public void CargarLabels(){
    
        strConfirmacion=        Label.EntregaGestionProy_Confirma;
        strNoHayOP=             Label.OpComLegalizar_NoHayOP;   
        strDebeSelec=   label.OpComLegalizar_DebeSelec;
    }
        
    public void Iniciar(){
        
        //leer el parámetro de la página        
        mapParameters = new map<string,string>();
        mapParameters=ApexPages.currentPage().getParameters();
        strIdContrato = mapParameters.get('id');    
        blnBtnCrear=true;         
        blnLista=false;  
        blnValidaSel=false;    
        CargarLabels();
        
        system.debug('DEBUG=>strIdContrato='+strIdContrato);
    }   
    
    public pageReference AnalizaAccion(){
        list<Contract> lstContract = new list<Contract>(); 
        list<OperacionComercial__c> lstOpCom = new list<OperacionComercial__c>();
        lstOpCom = new list<OperacionComercial__c>();
        string strRta='';
        string strRta2='';
        Iniciar();
        
        if(strIdContrato!=null && strIdContrato!=''){                     
                lstContract = [select id, AccountId,ContractNumber
                                from Contract
                                where id=:strIdContrato];                                               
                                        
                if(lstContract.size()>0){
                        insContract=lstContract[0];                     
                        strNombreCon='Contrato '+insContract.ContractNumber;
                        
                        /**
                        *	1.3
                        *	Ajuste de queries para que se utilice el camino directo en vez del intermedio a traves del Servicio        	
	                    *	lstOpCom = [select id, Name, Activo__r.Oportunidad__r.Name, Plan__r.Name, TOPP__r.Name, TOPP__r.AplicaPreventa__c,Activo__r.NombredelProducto__c, CreatedDate, LastModifiedDate,
	                    *		(select id from Viabilidades__r where Respuestadeviabilidad__c= :strEstadoViable) 
	                    *		from OperacionComercial__c
	                    *		where Activo__r.Oportunidad__r.AccountId=:insContract.AjusteccountId
	                    *		and Legalizacion__c=null
	                    *		order by Activo__r.Oportunidad__r.Name
	                    *		];
	                    **/
	                    lstOpCom = [select id, Name, Oportunidad__r.Name, Plan__r.Name, TOPP__r.Name, TOPP__r.AplicaPreventa__c,Activo__r.NombredelProducto__c, CreatedDate, LastModifiedDate,
	                    	(select id from Viabilidades__r where Respuestadeviabilidad__c= :strEstadoViable) 
	                    	from OperacionComercial__c
                    		where 
                                ( Oportunidad__r.AccountId=:insContract.AccountId
                                or CuentaCliente__c =: insContract.AccountId )
                    		and Legalizacion__c=null
                    		order by Oportunidad__r.Name
                    		];
                        if(lstOpCom.size()>0){                        		
                                
                                lstResult = new list<wrpResultados>();
                                
                                for(OperacionComercial__c o:lstOpCom){
                                	//únicamente agrega las que que no aplica para preventa o las que aplica preventa y tienen una viabilidad con estado VIABLE.
                                	if((o.TOPP__r.AplicaPreventa__c && o.Viabilidades__r!=null && o.Viabilidades__r.size()>0) ||
                                	 (!o.TOPP__r.AplicaPreventa__c)){
	                                    insWrp = new wrpResultados();
	                                    insWrp.OpCome=o;
	                                    lstResult.add(insWrp);  
                                	 }
                                }
                                if(lstResult!=null && lstResult.size()>0){
                                	blnLista=true;
                                }
                        }
                        else{
                                blnBtnCrear=false;
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strNoHayOP));
                                return null;
                        }                       
                }
        }
        
        return null;
    }
    
    public pageReference Crear(){
        PageReference pr=null;
        Legalizacion__c insLegal = new Legalizacion__c();
        list<OperacionComercial__c> lstOPC = new list<OperacionComercial__c>();
        System.Savepoint svP;
        ValidaSel();
        if(!blnValidaSel){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strDebeSelec));
            return null;  
        }
        else{
        	
        	/**
        	*	v1.2
        	*	Ajuste para validar que las OC se encuentren completas
        	**/
        	
        	list<OperacionComercial__c> lstOCIncompletas = new list<OperacionComercial__c>();
        	for(wrpResultados w: lstResult){
        		if (!ValidarOperacionModificada(w.OpCome) && w.blnSel) {
        			lstOCIncompletas.add(w.OpCome);
                }
            }
        	if (lstOCIncompletas.size() > 0) {
            	String strMensajeIncompletas = '';
            	for (OperacionComercial__c oc : lstOCIncompletas) {
            		strMensajeIncompletas = strMensajeIncompletas + '<li>' + oc.Name + '</li>\n';
            	}
            	strMensajeIncompletas = Label.Operaciones_Comerciales_Incompletas.replace('%1',strMensajeIncompletas);
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMensajeIncompletas));
            } else {        	
	            try{
	                svP=Database.setSavepoint();
	                insLegal = new Legalizacion__c();
	                insLegal.Contrato__c=strIdContrato;
	                //DGUANA 26-11-2013 Adicionado para evolutivo
	                if(strIdContrato!=null && strIdContrato!=''){                     
	                	List<Contract> lstContract = [select id, AccountId from Contract where id=:strIdContrato];  
	                	insLegal.Nombredelacuenta2__c = lstContract.get(0).AccountId;
	                } 
	                //Fin DGUANA
	                
	                insert(insLegal);
	                
	                for(wrpResultados w: lstResult){
	                    if(w.blnSel){                       
	                        w.OpCome.Legalizacion__c=insLegal.Id;                       
	                        lstOPC.add(w.OpCome);
	                        
	                    }
	                }
	                update(lstOPC);
	                
	                pr=new PageReference('/'+insLegal.Id);
	                return pr;
	            }
	            catch(Exception e){
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
	                Database.rollback(svP);
	                return null;
	            }
        	}
        }
            
        
           
        
        return null;        
        
    }
    
    public pageReference MostrarError(){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strDebeSelec));
        return null;
    }
    
    public void ValidaSel(){            
        blnValidaSel=false;     
        for(wrpResultados w: lstResult){
            if(w.blnSel){
                blnValidaSel=true;
                break;
            }
        }
    }
    
    public pageReference Cancelar(){
        PageReference p=null;
        if(strIdContrato!=null){
           p = new PageReference('/'+strIdContrato);
        }
        return p;
    }
    
    public void DoNothing(){
        
       
    }
    /**
    *	v1.2
    *	Función para validar si un registro sólamente fue creado o si fue
    *	modificado, por tanto pasó por el formato de página y los campos
    *	obligatorios fueron modificados ()
    **/	
    public boolean ValidarOperacionModificada(OperacionComercial__c oc) {
    	boolean blnRetorno = false;
    	if (oc != null) {
    		if (oc.CreatedDate != null && oc.LastModifiedDate != null && oc.CreatedDate != oc.LastModifiedDate) {
    			blnRetorno = true;
    		}
    	}
    	return blnRetorno;
    }
}