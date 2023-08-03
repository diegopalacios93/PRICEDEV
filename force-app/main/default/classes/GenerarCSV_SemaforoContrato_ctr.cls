public class GenerarCSV_SemaforoContrato_ctr {    
	
    public String fileName	  	 		{get; set;}    
    public String id					{get; set;} 
    public String pageUrlExport			{get; set;}
    public List<wrapper> lstwrapper 	{get; set;}        
    public list<Observacion_contrato__c> lstHechoRelevante = new list<Observacion_contrato__c>();    
    public list<Contract> lstContrato = new list<Contract>();
    
    public class wrapper{        
        public string Anexo 			{get; set;}
        public string Aliado	 		{get; set;}
        public string Cliente			{get; set;}        
        public string FechaInicio		{get; set;}
        public string FechaFin			{get; set;}
        public string ValirSinIva		{get; set;}
        public string ValorTotal		{get; set;}
        public string IVA				{get; set;}
        public string Ejecutado			{get; set;}
        public string Saldo				{get; set;}
        public string Facturado			{get; set;}
        public string Conciliado		{get; set;}
        public string ValorMes			{get; set;}
        public string ValorDeuda		{get; set;}
        public string MesesMora			{get; set;}
        public string Estado			{get; set;}
        public string Objeto			{get; set;}
        public string FechaSuscrip		{get; set;}
        public string SupervisorAd		{get; set;}
        public string TipoContrato		{get; set;}
        public string ValorAdicion		{get; set;}
        public string HechoRel			{get; set;}
        public string Escalamiento		{get; set;}
        public string CtaRevchain		{get; set;}        
        public string valorContrato		{get; set;}
        public string valorAdiciones	{get; set;}
        public string sumaContratoAdici	{get; set;}
        public string valorEjecutado	{get; set;}
        public string FacturadoExpCli	{get; set;}
        public string FacturadoConcil	{get; set;}
        public string SaldoCalc			{get; set;}
    }
        
	public GenerarCSV_SemaforoContrato_ctr() {	        
        map<string,string> mapParameters = new map<string,string>();        
        mapParameters = ApexPages.currentPage().getParameters();         
        id = mapParameters.get('id');
        pageUrlExport = '/apex/GenerarCSV_SemaforoContrato_pag?Id='+id;
        fileName   = 'application/vnd.ms-excel#Semaforo_Contratos.xls';
        lstwrapper = new List<wrapper>();
    }
    public void exportToExcel(){  
        Id UserId = UserInfo.getUserId();
        string queryString;
        consultarHechosRelevantes();
        List<GroupMember> lstGrupo = New List<GroupMember>(
                          [Select GroupId,Id,SystemModstamp,UserOrGroupId From GroupMember
                           Where
                           GroupId In (Select Id From Group Where DeveloperName = 'Administradores_Contrato_Colaborador') AND
                           UserOrGroupId =: UserId]);   
        
        if(lstGrupo.size() > 0){
             queryString =  'SELECT Id, Anexo__c, Aliado__r.Name, Account.Name, Fecha_de_inicio__c, Fecha_de_terminacion__c, '
                             +'Valor_sin_IVA__c, Valor_total__c, IVA_Contrato_Colaborador__c, Ejecutado__c, Valor_ejecutado_calculado_escritura__c, Valor_ejecutado_calculado__c, Saldo__c, '
                             +'Facturado__c, Conciliado__c, Valor_mes__c, Valor_de_la_deuda__c, Valor_de_la_deuda_calculado_escritura__c, Meses_en_mora__c, Meses_en_mora_calculado_escritura__c, '
                             +'Status, Objeto__c, Fecha_de_suscripcion__c, Supervisor_Administrativo__r.Name, Tipo_de_contrato__c, '
                             +'Valor_adiciones__c, Escalamiento__c, Cuenta_revchain__c, Saldo_calculado_escritura__c, Valor_adiciones_sin_iva__c, Facturado_Exp_Cliente__c '
                             +'FROM Contract  WHERE RecordType.Name = \'Anexo Colaborador\' AND '
                 			 +'(Status = \'Ejecución\' OR Status = \'Liquidación\' OR Status = \'Liquidado\') '
                             +'ORDER BY Meses_en_mora_calculado_escritura__c DESC NULLS LAST';
        }else{
            queryString =  'SELECT Id, Anexo__c, Aliado__r.Name, Account.Name, Fecha_de_inicio__c, Fecha_de_terminacion__c, '
                            +'Valor_sin_IVA__c, Valor_total__c, IVA_Contrato_Colaborador__c, Ejecutado__c, Valor_ejecutado_calculado_escritura__c, Valor_ejecutado_calculado__c, Saldo__c, '
                            +'Facturado__c, Conciliado__c, Valor_mes__c, Valor_de_la_deuda__c, Valor_de_la_deuda_calculado_escritura__c, Meses_en_mora__c, Meses_en_mora_calculado_escritura__c, '
                            +'Status, Objeto__c, Fecha_de_suscripcion__c, Supervisor_Administrativo__r.Name, Tipo_de_contrato__c, '
                            +'Valor_adiciones__c, Escalamiento__c, Cuenta_revchain__c, Saldo_calculado_escritura__c, Valor_adiciones_sin_iva__c, Facturado_Exp_Cliente__c '
                            +'FROM Contract  WHERE RecordType.Name = \'Anexo Colaborador\' AND '
                			+'(Status = \'Ejecución\' OR Status = \'Liquidación\' OR Status = \'Liquidado\') AND '
                            +'Supervisor_Administrativo__c = \''+UserId+'\' '            
                            +'ORDER BY Meses_en_mora_calculado_escritura__c DESC NULLS LAST';
        }        
        List<Contract> lstContract = DataBase.Query(queryString);
        if(lstContract.size()>0){            
            for(Contract contract_aux :lstContract){
                wrapper w 			= new wrapper();            
                w.Anexo				= contract_aux.Anexo__c;
                w.Aliado			= contract_aux.Aliado__r.Name;
                w.Cliente			= contract_aux.Account.Name;
                w.FechaInicio		= string.valueof(contract_aux.Fecha_de_inicio__c);
                w.FechaFin			= string.valueof(contract_aux.Fecha_de_terminacion__c);
                w.ValirSinIva		= string.valueof(contract_aux.Valor_sin_IVA__c);
                w.ValorTotal		= string.valueof(contract_aux.Valor_total__c);
                w.IVA				= string.valueof(contract_aux.IVA_Contrato_Colaborador__c);
                w.Ejecutado			= string.valueof(contract_aux.Valor_ejecutado_calculado_escritura__c);
                w.Saldo				= string.valueof(contract_aux.Saldo_calculado_escritura__c);
                w.Facturado			= string.valueof(contract_aux.Facturado__c);
                w.Conciliado		= string.valueof(contract_aux.Conciliado__c);
                w.ValorMes			= string.valueof(contract_aux.Valor_mes__c);
                w.ValorDeuda		= string.valueof(contract_aux.Valor_de_la_deuda_calculado_escritura__c);
                w.MesesMora			= string.valueof(contract_aux.Meses_en_mora_calculado_escritura__c);
                w.CtaRevchain		= string.valueof(contract_aux.Cuenta_revchain__c);
                w.Estado			= contract_aux.Status;
                w.Objeto			= contract_aux.Objeto__c;
                w.FechaSuscrip		= string.valueof(contract_aux.Fecha_de_suscripcion__c);
                w.SupervisorAd		= contract_aux.Supervisor_Administrativo__r.Name;
                w.TipoContrato		= contract_aux.Tipo_de_contrato__c;
                w.ValorAdicion		= string.valueof(contract_aux.Valor_adiciones__c);
                w.Escalamiento		= contract_aux.Escalamiento__c;
                w.HechoRel			= consultarUltimoHechoRelevante(contract_aux.Id);
                W.valorContrato		= string.valueof((contract_aux.Valor_sin_IVA__c==null?0:contract_aux.Valor_sin_IVA__c));
                W.valorAdiciones	= string.valueof((contract_aux.Valor_adiciones_sin_iva__c==null?0:contract_aux.Valor_adiciones_sin_iva__c));
                W.sumaContratoAdici	= string.valueof((contract_aux.Valor_sin_IVA__c==null?0:contract_aux.Valor_sin_IVA__c) + (contract_aux.Valor_adiciones_sin_iva__c==null?0:contract_aux.Valor_adiciones_sin_iva__c));
                W.valorEjecutado	= string.valueof((contract_aux.Valor_ejecutado_calculado_escritura__c==null?0:contract_aux.Valor_ejecutado_calculado_escritura__c));
                W.FacturadoExpCli	= string.valueof((contract_aux.Facturado_Exp_Cliente__c==null?0:contract_aux.Facturado_Exp_Cliente__c));
                W.FacturadoConcil	= string.valueof((contract_aux.Facturado__c==null?0:contract_aux.Facturado__c));
                W.SaldoCalc			= string.valueof((contract_aux.Valor_sin_IVA__c==null?0:contract_aux.Valor_sin_IVA__c) + (contract_aux.Valor_adiciones_sin_iva__c==null?0:contract_aux.Valor_adiciones_sin_iva__c)-(contract_aux.Facturado__c==null?0:contract_aux.Facturado__c));
                lstwrapper.add(w); 
            }            
        }     	
    }
    public void consultarHechosRelevantes(){
        lstHechoRelevante = [SELECT Descripcion__c,Contrato_relacionado__c                             
                             FROM Observacion_contrato__c 
                             ORDER BY Contrato_relacionado__c, createdDate DESC];  
    }
    public string consultarUltimoHechoRelevante(String idContrato){  
        string ultimoHechoRelevante = '';
               
        for(Observacion_contrato__c objHechoRelevante : lstHechoRelevante){
            if(objHechoRelevante.Contrato_relacionado__c == idContrato){
                ultimoHechoRelevante = String.isBlank(objHechoRelevante.Descripcion__c)?'':objHechoRelevante.Descripcion__c;
                break;
            }
        }
        return ultimoHechoRelevante;
    } 
    public PageReference regresar(){        
		String url;
        url = '/apex/Semaforo_PDF_pag?id='+id;        
		PageReference page = new PageReference(url);
		return page;
	}
}