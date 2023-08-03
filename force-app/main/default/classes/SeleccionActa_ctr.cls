public class SeleccionActa_ctr {
    private Apexpages.Standardcontroller stdController;    
    public String  idRecord;
    public Decimal ivaDelActa			 {get; set;}
    public String  tipoInforme			 {get; set;}    
    public String  nuevoIVA				 {get; set;}    			
    public Actas_de_contrato__c objActa	 {get; set;} 
    public List<SelectOption> itemsActa	 {get; set;}
    public List<SelectOption> itemsIVA	 {get; set;}       
    public boolean blnActivarFormulario  {get; set;}
    public boolean blnActivarBtnCerrar	 {get; set;}
          
    public SeleccionActa_ctr(ApexPages.StandardController controller){
        blnActivarFormulario		= true;        
        blnActivarBtnCerrar			= false;
        String strMensajeValidacion = '';        
        idRecord = ApexPages.currentPage().getParameters().get('id');        
        consultarActa(idRecord);
        		
        if(objActa.Param_Anexo_IVA__c == null && objActa.Contrato_relacionado__r.Param_Anexo_IVA__c == null)
			ivaDelActa = 0;
        else if(objActa.Param_Anexo_IVA__c != null)
            ivaDelActa = objActa.Param_Anexo_IVA__c;
        else 
            ivaDelActa = decimal.valueOf(objActa.Contrato_relacionado__r.Param_Anexo_IVA__c);
        
		objActa.Param_Anexo_IVA__c = null;        
        strMensajeValidacion = validarDatosRequeridos();
        
        if(strMensajeValidacion != ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strMensajeValidacion));
        }
        else{
            this.itemsActa = new List<SelectOption>(); 
            itemsActa.add(new SelectOption('acta_conciliacion','Conciliación'));
            //itemsActa.add(new SelectOption('Acta_de_conciliacion_con_aliados','Conciliación con aliados'));            
            //itemsActa.add(new SelectOption('acta_costo_administrativo','Acta de costos administrativos y de interconexión'));
            //itemsActa.add(new SelectOption('acta_conciliacion_con_operadores','Acta de conciliación con operadores'));
            
            this.itemsIVA = new List<SelectOption>(); 
            itemsIVA.add(new SelectOption('Empty',''));
            itemsIVA.add(new SelectOption('No','No'));
            itemsIVA.add(new SelectOption('Si','Si'));            
        }
    }    
    
    public PageReference generarActa(){
        String strMensajeValidacion = validarIVA();
        if(nuevoIVA == 'No' && strMensajeValidacion != ''){            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMensajeValidacion));
            blnActivarFormulario = false;
            blnActivarBtnCerrar  = true;
            return null;
        }else if(nuevoIVA == 'Empty'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Param_Colaborador_validacion_seleccion_IVA));
            blnActivarFormulario = false;
            blnActivarBtnCerrar  = true;
            return null;
        }else if(nuevoIVA == 'Si' && objActa.Param_Anexo_IVA__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Param_Colaborador_validacion_nuevo_IVA));
            blnActivarFormulario = false;
            blnActivarBtnCerrar  = true;
            return null;            
        }else if(nuevoIVA == 'No' && objActa.Param_Anexo_IVA__c != null){  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Param_Colaborador_validacion_ingreso_nuevo_IVA));
            blnActivarFormulario = false;
            blnActivarBtnCerrar  = true;
            return null;            
        }else{            
            if(nuevoIVA == 'No')
                objActa.Param_Anexo_IVA__c = ivaDelActa;
                            
          	update objActa;
                
            String url = '/apex/'+tipoInforme+'_PDF_pag?id='+idRecord;        
            PageReference prVenta = new PageReference(url);
            prVenta.setRedirect(true);
            return prVenta;
        }		
	}
    
    public void consultarActa(String idActa){            
        objActa = Database.query('Select Param_Anexo_IVA__c, Contrato_relacionado__r.Codigo_acreedor_deudor__c, Contrato_relacionado__r.Param_Anexo_IVA__c, Contrato_relacionado__r.Param_Anexo_Retefuente__c, '
                                 +'Contrato_relacionado__r.Param_Anexo_Reteica__c,  Contrato_relacionado__r.Param_Retencion_IVA__c '
                                 +'FROM Actas_de_contrato__c where Id=:idActa limit 1');                              
    }    
    public string validarDatosRequeridos(){               
        String camposrequeridos = '', strMensajeValidacion = '';
		if(objActa.Contrato_relacionado__r.Param_Anexo_Retefuente__c == null)                     
            camposrequeridos = 'RETEFUENTE (%)';
        
        if(objActa.Contrato_relacionado__r.Param_Anexo_Reteica__c == null){
            if(camposrequeridos == '')
                camposrequeridos = 'RETEICA';
            else
                camposrequeridos += ', RETEICA';
        }   
        if(objActa.Contrato_relacionado__r.Codigo_acreedor_deudor__c == null){
            if(camposrequeridos == '')
            	camposrequeridos = ' Código acreedor/deudor';
            else
                camposrequeridos += ', Código acreedor/deudor';
        }             
        if(camposrequeridos != ''){
            blnActivarFormulario = false;        
            strMensajeValidacion = Label.Param_Colaborador_validacion_Campos_Acta.replace('%campos%',camposrequeridos);
        }
               
        return strMensajeValidacion;
	}
    public string validarIVA(){ 
        String strMensajeValidacion = '';
        if(objActa.Contrato_relacionado__r.Param_Anexo_IVA__c == null)
			strMensajeValidacion = Label.Param_Colaborador_validacion_Campos_Acta.replace('%campos%','IVA (%)');			         
        
        return strMensajeValidacion;
    }
    public PageReference cerrarPagina(){        
		String url;
        url = '/'+idRecord;
		PageReference page = new PageReference(url);
		return page;
	} 
}