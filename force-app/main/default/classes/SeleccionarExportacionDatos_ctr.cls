public class SeleccionarExportacionDatos_ctr {
	private Apexpages.Standardcontroller stdController;
    public Contract objContract 	 	{get; set;}
    public String tipoExportacion		{get; set;}    
    public String idRecord;
    public List<SelectOption> items		{get; set;}
          
    public SeleccionarExportacionDatos_ctr(ApexPages.StandardController controller){        
        idRecord = ApexPages.currentPage().getParameters().get('id');
        this.items = new List<SelectOption>();         
        items.add(new SelectOption('Contrato','Contrato actual'));
        items.add(new SelectOption('Adiciones_Prorrogas','Adiciones/Prorrogas del contrato'));
        items.add(new SelectOption('Observaciones','Observaciones del contrato'));		           
    }    
    
    public PageReference generarInforme(){        
		String url;
        if(tipoExportacion == 'Contrato')
        	url = '/apex/GenerarCSV_IframeAnexoColaborador_pag?id='+idRecord;        
        
        if(tipoExportacion == 'Adiciones_Prorrogas')
        	url = '/apex/GenerarCSV_IframeAnexo_Prorroga_pag?id='+idRecord+'&source="All"';        
        
        if(tipoExportacion == 'Observaciones')            
        	url = '/apex/GenerarCSV_IframeAnexo_Observacion_pag?id='+idRecord;     
        
		PageReference prVenta = new PageReference(url);
		return prVenta;
	} 
    public PageReference cerrarPagina(){        
		String url;
        url = '/'+idRecord;
		PageReference page = new PageReference(url);
		return page;
	} 
}