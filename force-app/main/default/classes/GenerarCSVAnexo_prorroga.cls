public class GenerarCSVAnexo_prorroga {
	public String contractId  		{get; set;}
    public String AdicProId	  		{get; set;}
    public String source	  		{get; set;}
    public String fileName	  		{get; set;}
    public List<wrapper> lstwrapper {get; set;}        
    
    public class wrapper{
        public string Name				 						{get; set;}
        public string Acuerdo_No_c		 						{get; set;}
        public string Prorroga_o_adicion_c	 					{get; set;}
        public string Fecha_de_inicio_c 						{get; set;}
        public string Objeto_c 									{get; set;}
        public string Fecha_de_fin_c 							{get; set;}
        public string Valor_antes_de_IVA_c 						{get; set;}
        public string Contrato_relacionado_c 					{get; set;}
        public string Porcentaje_IVA_c	 						{get; set;}
        public string IVA_c 									{get; set;}
        public string Valor_total_c 							{get; set;}
        public string Valor_sin_IVA_en_dolares_c				{get; set;}
        public string Valor_total_incluido_IVA_en_dolares_c		{get; set;}
        public string IVA_en_dolares_c	 						{get; set;}
    }	
            
	public GenerarCSVAnexo_prorroga() {
        source	   = ApexPages.currentPage().getParameters().get('source');
        lstwrapper = new List<wrapper>(); 
        if(source == 'Single'){
			AdicProId  	   = ApexPages.currentPage().getParameters().get('id');	
            fileName       = 'application/vnd.ms-excel#'+getIdRegistro()+'.xls';              
        }else{            
            contractId 	   = ApexPages.currentPage().getParameters().get('ContractId');	             
            fileName       = 'application/vnd.ms-excel#Adiciones_Prorrogas_DelAnexo_ID_'+getIdRegistro()+'.xls';              
        }                
	}
    
    public void exportToExcel(){                   
        string queryString;
        if(source == 'Single'){        
        	queryString 	   =  'Select '
                				 +'Name, Acuerdo_No__c, Prorroga_o_adicion__c, Fecha_de_inicio__c, Objeto__c, Fecha_de_fin__c, Valor_antes_de_IVA__c, '
 			                     +'Contrato_relacionado__c, Porcentaje_IVA__c, IVA__c, Valor_total__c, Valor_sin_IVA_en_dolares__c, Valor_total_incluido_IVA_en_dolares__c, IVA_en_dolares__c '
                				 +'FROM Adiciones_y_prorrogas_contratos__c '
                    			 +'WHERE Id =\''+AdicProId+'\'';                           
        }else{
            queryString 	   =  'Select '
                				 +'Name, Acuerdo_No__c, Prorroga_o_adicion__c, Fecha_de_inicio__c, Objeto__c, Fecha_de_fin__c, Valor_antes_de_IVA__c, '
 			                     +'Contrato_relacionado__c, Porcentaje_IVA__c, IVA__c, Valor_total__c, Valor_sin_IVA_en_dolares__c, Valor_total_incluido_IVA_en_dolares__c, IVA_en_dolares__c '
                				 +'FROM Adiciones_y_prorrogas_contratos__c '
                    			 +'WHERE Contrato_relacionado__c =\''+contractId+'\'';       
        }        
        
        List<Adiciones_y_prorrogas_contratos__c> lstAux = DataBase.Query(queryString);        
        if(lstAux.size()>0){            
            for(Adiciones_y_prorrogas_contratos__c aux :lstAux){                
                wrapper w 								= new wrapper();                
                w.Name									= aux.Name;
                w.Acuerdo_No_c							= aux.Acuerdo_No__c;
                w.Prorroga_o_adicion_c					= aux.Prorroga_o_adicion__c;
                w.Fecha_de_inicio_c						= string.valueof(aux.Fecha_de_inicio__c);
                w.Objeto_c								= aux.Objeto__c;
                w.Fecha_de_fin_c						= string.valueof(aux.Fecha_de_fin__c);
                w.Valor_antes_de_IVA_c					= string.valueof(aux.Valor_antes_de_IVA__c);
                w.Contrato_relacionado_c				= aux.Contrato_relacionado__c;
                w.Porcentaje_IVA_c						= aux.Porcentaje_IVA__c;
                w.IVA_c									= string.valueof(aux.IVA__c);
                w.Valor_total_c							= string.valueof(aux.Valor_total__c);
                w.Valor_sin_IVA_en_dolares_c			= string.valueof(aux.Valor_sin_IVA_en_dolares__c);
                w.Valor_total_incluido_IVA_en_dolares_c	= string.valueof(aux.Valor_total_incluido_IVA_en_dolares__c);
                w.IVA_en_dolares_c						= string.valueof(aux.IVA_en_dolares__c);
                lstwrapper.add(w); 
            }            
        }
    } 
    public string getIdRegistro(){
        
        if(source == 'Single'){
            Adiciones_y_prorrogas_contratos__c[] auxAdicionProrroga;
            try{
                auxAdicionProrroga = [Select Name from Adiciones_y_prorrogas_contratos__c where Id =:AdicProId LIMIT 1];
                return auxAdicionProrroga[0].Name;
            }catch(exception e){
                return null;
            }             
        }else{
            Contract[] auxObjContrato;
            try{
                auxObjContrato = [Select ID_Registro__c from Contract where Id =:contractId LIMIT 1];
                return auxObjContrato[0].ID_Registro__c;
            }catch(exception e){
                return null;
            } 
        }
    }        
}