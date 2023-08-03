public class GenerarCSVAnexo_Observacion {
	
    public String ContractId  	 	{get; set;}
    public String fileName	  	 	{get; set;}    
    public List<wrapper> lstwrapper {get; set;}        
    
    public class wrapper{
        public string Nombre 		{get; set;}
        public string Descripcion 	{get; set;}
        public string FechaCreacion {get; set;}
    }
        
	public GenerarCSVAnexo_Observacion() {	
        ContractId = ApexPages.currentPage().getParameters().get('ContractId');
        fileName   = 'application/vnd.ms-excel#Observaciones_Anexo_ID_'+getIdRegistro()+'.xls';        
        lstwrapper = new List<wrapper>();       
    }
    public void exportToExcel(){        
        string queryString = 'Select Name, Descripcion__c, Fecha_creacion_observacion__c '
            				 +'FROM Observacion_contrato__c '
                		     +'WHERE Contrato_relacionado__c =\''+ContractId+'\'';
        
        List<Observacion_contrato__c> lstObservacionContrato = DataBase.Query(queryString);        
        if(lstObservacionContrato.size()>0){            
            for(Observacion_contrato__c obs_aux :lstObservacionContrato){                
                wrapper w 		= new wrapper();
                w.Nombre 		= obs_aux.Name;
                w.Descripcion 	= obs_aux.Descripcion__c;
                w.FechaCreacion = string.valueof(obs_aux.Fecha_creacion_observacion__c);
                lstwrapper.add(w); 
            }            
        }
    } 
	public string getIdRegistro(){
        Contract[] auxObjContrato;
        try{
        	auxObjContrato = [Select ID_Registro__c from Contract where Id =:contractId LIMIT 1];
        	return auxObjContrato[0].ID_Registro__c;
        }catch(exception e){
            return null;
        } 
    }
}