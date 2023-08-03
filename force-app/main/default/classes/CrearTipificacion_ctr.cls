/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - CRM etapa 1
Descripción:            Controlador de la página CrearTipificacion_pag encargada de seleccionar
						la correcta tipificación para iniciar el caso.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     07-10-2013  Andrés Cubillos (AAC)       Creación de la clase..
1.1		17-12-2013	Jorge Grimaldos (JG)		Ajuste Evolutivo
*******************************************************************************/
public with sharing class CrearTipificacion_ctr {
	public map<string,string> mapParameters;
	
	public Case CaseInfo{get;set;}
	public boolean reqCUN{get;set;}
    public boolean enbCUN{get;set;}
	public map<string, List<SelectOption>>niveles{get;set;}
    
	public MatrizTipificacion__c insMT;
	
	private string strIdCuenta;
	private string strRetUrl;
	private string strIdCasoPadre;
	private string TipoRegistroSubCasos;
	
	public ApexPages.StandardController controller;
	public List<SelectOption> lstProceso {get;set;}
	public List<SelectOption> lstAgrupacion {get;set;}
	public List<SelectOption> lstTipologia {get;set;}
	public List<SelectOption> lstTipoCaso {get;set;}
	
	public string strInTipo {get;set;}
	public string strInProceso {get;set;}
	public string strInAgrupacion {get;set;}
	public string strInTipologia {get;set;}
    public string strInTipoCatalogo {get;set;}
	public string idInTipoSegmento {get;set;}
    
	public string nivel01 {get;set;}
	public string nivel02 {get;set;}
	public string nivel03 {get;set;}
	public string nivel04 {get;set;}
	public string nivel05 {get;set;}
	public string nivel06 {get;set;}

	public map<string,string> varSelect=new map<string,string>();
    public map<String,String> mpMatrizTipo = new map<String,String>();
	
	public string strTitle {get;set;}
	public string strSubTitle {get;set;}
	public string strDescripcion {get;set;}
	public string strSistemaLegado {get;set;}
    public string strCategoria {get;set;}
    public string strCatalogo {get;set;}
	public Datetime dtInicio {get;set;}

    public boolean esTipificado{get;set;}
	
	private string stErrorMT;
	
    private string strMatrizTip_Activo;
    
	public CrearTipificacion_ctr(ApexPages.StandardController controller){
		reqCUN=false;
		CargarLabels();
		this.controller=controller;
        strInTipoCatalogo='';
		
		id idCase = ApexPages.currentPage().getParameters().get('newid');
		CaseInfo=[Select id, CodigouniconumericoCUN__c,Accountid,Account.Segmento__c,Recordtype.Name,TipoCaso__c, Origin,FechaTipificacion__c,
                  LTE_Servicio__c,LTE_Servicio__r.NombredelProducto__c,LTE_Servicio__r.NombredelProducto__r.Catalogo__c,
                  Fechaderadicacion__c, FechaInicioAfectacion__c
                  from Case where id=:idCase];
        system.debug(CaseInfo.FechaTipificacion__c+'__'+CaseInfo.CodigouniconumericoCUN__c);
        
        if(CaseInfo.FechaTipificacion__c!=null || CaseInfo.CodigouniconumericoCUN__c!=null){
            esTipificado=true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'El caso ya fue tipificado'));
        }else{
            esTipificado=false;
        }
        if(CaseInfo.LTE_Servicio__c!=null){
            if(CaseInfo.LTE_Servicio__r.NombredelProducto__c!=null){
                if(String.isNotEmpty(CaseInfo.LTE_Servicio__r.NombredelProducto__r.Catalogo__c)){
                    if(mpMatrizTipo.containsKey(CaseInfo.LTE_Servicio__r.NombredelProducto__r.Catalogo__c)){
                        strInTipoCatalogo = mpMatrizTipo.get(CaseInfo.LTE_Servicio__r.NombredelProducto__r.Catalogo__c);
                    }
                }
            }
        }

		strInTipo=CaseInfo.Recordtype.Name;
		niveles=new map<string, List<SelectOption>>();
        
        idInTipoSegmento = Schema.SObjectType.MatrizTipificacion__c.getRecordTypeInfosByDeveloperName().get('Matriz_de_Tipificaci_n').getRecordTypeId();
        if(CaseInfo.AccountId != null){
            if(CaseInfo.Account.Segmento__c == 'MiPymes')
            {
                idInTipoSegmento = Schema.SObjectType.MatrizTipificacion__c.getRecordTypeInfosByDeveloperName().get('Tipificacion_Apertura_MiPymes').getRecordTypeId();
            }
        }
		if(strInTipo=='SOPORTE TECNICO'){
            dtInicio = CaseInfo.FechaInicioAfectacion__c;
            if(string.isNotEmpty(strInTipoCatalogo)){
                if(Schema.SObjectType.MatrizTipificacion__c.getRecordTypeInfosByDeveloperName().containskey(strInTipoCatalogo))
                    idInTipoSegmento = Schema.SObjectType.MatrizTipificacion__c.getRecordTypeInfosByDeveloperName().get(strInTipoCatalogo).getRecordTypeId();
            }
			Refresco0();
		}else if(strInTipo=='CASO PQR'){
            dtInicio = CaseInfo.Fechaderadicacion__c;
			Nivel01();
		}
	}
	
	public void CargarLabels(){
		strMaTrizTip_Activo=Label.MatrizTip_Activo;
		strTitle=Label.MatrizTip_Title;
		strSubTitle=Label.MatrizTip_SubTitle;
		stErrorMT=Label.MatrizTip_ErrorMT;
		
        List<Homologacion_Remedy__mdt> lstMatrizTipo = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt WHERE Tipo_Lista__c = 'MATRIZ_APERTURA_CATALOGO'];
        mpMatrizTipo = new map<String,String>();
        for(Homologacion_Remedy__mdt sglMatrizTipo:lstMatrizTipo){
            if(!mpMatrizTipo.containsKey(sglMatrizTipo.Valor_Usuario__c)){
                mpMatrizTipo.put(sglMatrizTipo.Valor_Usuario__c,sglMatrizTipo.Valor_API__c);
            }
        }
		//---configuración personalizada
		VariablesGlobales__c varGlb = VariablesGlobales__c.getValues('TipoRegistroSubCasos');
		if(varGlb!=null){
			TipoRegistroSubCasos=varGlb.Valor__c;
		}
	}
	/*
	private void Iniciar(){
		TipoRegistroSubCasos=null;
		insMT=null;
		
		mapParameters = new map<string,string>();
		mapParameters=ApexPages.currentPage().getParameters();
				
		strIdCuenta=mapParameters.get('def_account_id');
		strRetUrl=mapParameters.get('retURL');
		strIdCasoPadre=mapParameters.get('def_parent_id');
	   
		if(strRetUrl==null){
			strRetUrl='/';
		}
	}
	*/
	public void CargarTipoCaso(){
        lstTipoCaso = new List<SelectOption>();
		string strEt, strVal;
		AggregateResult[] gRes;
		
		gRes = [select TipoCaso__c t
				from  MatrizTipificacion__c
				where Estado__c=:strMaTrizTip_Activo
				and Agrupacion__c != null
				and Agrupacion__c != ''
				and Proceso__c !=null
				and Proceso__c !=''
				and Tipologia__c !=null
				and Tipologia__c !=''
				and TipoCaso__c!=null
				and TipoCaso__c!=''
                and RecordTypeId = :idInTipoSegmento
				group by TipoCaso__c
				];
		
        for(AggregateResult a: gRes){
            strEt=(string)a.get('t');
            if(strEt!=null){
                strEt=strEt.toUpperCase();
            }
            strVal=(string)a.get('t');
            
            lstTipoCaso.add(new SelectOption(strVal, strEt));
        }
		lstTipoCaso.sort();
	}

	public void CargarAgrupacion(){
		string strVal;
		string strEt;
		lstAgrupacion = new List<SelectOption>();
		AggregateResult[] gRes;
		
		System.debug('strMaTrizTip_Activo:' + strMaTrizTip_Activo + ';strInTipo:' + strInTipo + ';idInTipoSegmento:' + idInTipoSegmento);

		string q ='select Agrupacion__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
				+'and TipoCaso__c = :strInTipo '
				+'and Agrupacion__c != null '
				+'and Agrupacion__c != \'\' '
                +'and RecordTypeId = :idInTipoSegmento '
				+'group by Agrupacion__c';
        lstAgrupacion = getMatrizValue(q, 'Agrupacion__c', '');
		lstAgrupacion.sort();
	}

	public void CargarProceso(){
		string strVal;
		string strEt;
		lstProceso = new List<SelectOption>();
		AggregateResult[] gRes;

		System.debug('strMaTrizTip_Activo:' + strMaTrizTip_Activo + ';strInAgrupacion:' + strInAgrupacion);

		string q ='select Proceso__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
				+'and TipoCaso__c = :strInTipo '
				+'and Agrupacion__c = :strInAgrupacion '
				+'and Proceso__c !=null '
				+'and Proceso__c != \'\' '
                +'and RecordTypeId = :idInTipoSegmento '
				+'group by Proceso__c';
        lstProceso = getMatrizValue(q, 'Proceso__c', '');
		lstProceso.sort();
	}
	
	
	public void CargarTipologia(){
		string strVal;
		string strEt;
		lstTipologia = new List<SelectOption>();
		AggregateResult[] gRes;
		
		system.debug('==>CargarAgrupacion():strInProceso='+strInProceso);
		system.debug('==>CargarAgrupacion():strInAgrupacion='+strInAgrupacion);

		string q ='select Tipologia__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
				+'and TipoCaso__c = :strInTipo '
				+'and Agrupacion__c = :strInAgrupacion '
            	+'and Proceso__c=:strInProceso '
                +'and RecordTypeId = :idInTipoSegmento '
				+'group by Tipologia__c';
        lstTipologia = getMatrizValue(q, 'Tipologia__c', '');
		lstTipologia.sort();
	}
	
	public void CargarDescripcion(){
		list<MatrizTipificacion__c> lstMT = new list<MatrizTipificacion__c>();
        strInTipologia = String.isEmpty(strInTipologia)?'':strInTipologia;
		/*string q ='select Id, TipoCaso__c, Descripcion__c,Requiere_CUN__c,CUN_Opcional__c,LTE_SistemaLegado__c,Categoria__c,Catalogo__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
				+'and TipoCaso__c = :strInTipo '
				+'and Agrupacion__c = :strInAgrupacion '
            	+'and Proceso__c=:strInProceso '
				+'and Tipologia__c = :strInTipologia '
                +'and RecordTypeId = :idInTipoSegmento '
				+'LIMIT 1';*/
		lstMT = [select id, Horas_de_negocio__c, Limite_de_horas__c, TipoCaso__c, Descripcion__c,Requiere_CUN__c,CUN_Opcional__c,LTE_SistemaLegado__c,Categoria__c,Catalogo__c
				from MatrizTipificacion__c
				where Estado__c=:strMaTrizTip_Activo
				and TipoCaso__c = :strInTipo
				and Proceso__c=:strInProceso
				and Agrupacion__c=:strInAgrupacion
				and Tipologia__c=:strInTipologia
                and RecordTypeId = :idInTipoSegmento
				limit 1];
        
        if(lstMT.size()>0){
            insMT=lstMT[0];
            reqCUN=lstMT[0].Requiere_CUN__c;
            enbCUN=lstMT[0].CUN_Opcional__c;
            strSistemaLegado=lstMT[0].LTE_SistemaLegado__c;
            strCategoria = lstMT[0].Categoria__c;
            strCatalogo =  lstMT[0].Catalogo__c;
            strDescripcion=insMT.Descripcion__c;
        }else{
            insMT=null;
            reqCUN=false;
            enbCUN=false;
            strSistemaLegado='';
            strDescripcion='';
            strCategoria = '';
            strCatalogo = '';
        }
	}
	
    public pageReference AnalizaAccion(){
        return null;
    }
	
	public void Refresco0(){		
		if(strInTipo!=null && strInTipo!=''){
			CargarAgrupacion();
			strInAgrupacion=lstAgrupacion[0].getValue();
			Refresco1();
        }else{
            strInTipo='';
            strInAgrupacion='';
            strInProceso='';
            strInTipologia='';
            CargarDescripcion();
        }
	}
	
	public void Refresco1(){		
		if(strInAgrupacion!=null && strInAgrupacion!=''){
			CargarProceso();
			strInProceso=lstProceso[0].getValue();
			Refresco2();
		}else{
            strInAgrupacion='';
            strInProceso='';
            strInTipologia='';
            CargarDescripcion();
        }
	}
	
	public void Refresco2(){
		if(strInProceso!=null && strInProceso!=''){
			CargarTipologia();
			strInTipologia=lstTipologia[0].getValue();	
			Refresco3();
		}else{
            strInProceso='';
            strInTipologia='';
            CargarDescripcion();
        }
	}
	
	public void Refresco3(){
        CargarDescripcion();
	}
    
	public PageReference Guardar(){
		PageReference p=null;
		System.Savepoint svP;
		
        if(insMT!=null){
            try{
                svP=Database.setSavepoint();
                //creación del caso
                system.debug(CaseInfo);
                CaseInfo.Proceso__c=strInProceso;
                CaseInfo.Agrupacion__c=strInAgrupacion;
                CaseInfo.Tipologia__c=strInTipologia;
                CaseInfo.TipoCaso__c=insMT.TipoCaso__c;
                //CaseInfo.AccountId=strIdCuenta;
                CaseInfo.Nivel_1__c = nivel01;
                CaseInfo.Nivel_2__c = nivel02;
                CaseInfo.Nivel_3__c =nivel03;
                CaseInfo.Causal__c = nivel04;
                CaseInfo.FechaTipificacion__c=Datetime.Now();
                CaseInfo.No_requiere_cun__c=!reqCUN;
                CaseInfo.LTE_SistemaLegado__c=strSistemaLegado;
                CaseInfo.Categoria_legado__c = strCategoria;
                CaseInfo.Catalogo__c = strCatalogo;
                CaseInfo.Matriz_de_Tipificacion__c = insMT.Id;
                if(insMT.Horas_de_negocio__c != null && insMT.Limite_de_horas__c != null){
                    Long tmsHora = (Long)(3600000 * insMT.Limite_de_horas__c);
                    BusinessHours bh = [SELECT Id, Name FROM BusinessHours WHERE Id = :insMT.Horas_de_negocio__c];
                    Datetime dtFin = BusinessHours.add(bh.Id, dtInicio, tmsHora);
                    CaseInfo.Limite_de_horas__c = insMT.Limite_de_horas__c;
                    CaseInfo.Fecha_limite__c = dtFin;
                }
                update CaseInfo;
                
                if(CaseInfo.Origin!='Proactivos' && CaseInfo.Origin!='Herramientas de monitoreo' && CaseInfo.Origin!='Centro de gestión' && reqCUN){
                    p=new PageReference('/apex/ConsultaCun_pag?id='+CaseInfo.id);
                }else{
                    p=new PageReference('/'+CaseInfo.id);
                }
                
            }
            catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                Database.rollback(svP);
                return null;
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, stErrorMT));
        }
        
        return p;
	}

	public PageReference Cancelar(){
		PageReference p=null;
		p = new PageReference(String.isEmpty(strRetUrl)?'/':strRetUrl);
		return p;
	}
    
	public List<SelectOption> getMatrizValue(string q, string value, string inicial){
        List<SelectOption> lstOption = new List<SelectOption>();
		system.debug(strMaTrizTip_Activo+'\n'+strInTipo+'\n'+nivel01+'\n'+nivel02+'\n'+nivel03+'\n'+niveles.get('Nivel01'));
		system.debug(q);

        AggregateResult[] opt=Database.query(q);
        system.debug(value);
        system.debug(opt);
		for(AggregateResult a: opt){
			string strEt=(string)a.get(value);
            strEt=String.isEmpty(strEt)?'':strEt;
			if(strEt!=null){
				lstOption.add(new SelectOption(strEt.toUpperCase(), strEt));
			}
		}

		if(!lstOption.isEmpty()){
            if(String.isNotEmpty(inicial)){
                varSelect.put(inicial,lstOption[0].getValue());
                system.debug(varSelect);
            }
		}
		return lstOption;
	}

	public void Nivel01(){
		string q ='select Nivel_1__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c != null '
				+'and Nivel_2__c !=null '
				+'and Nivel_3__c !=null '
				+'and Tipologia__c !=null '
                +'and Causal__c !=null '
                +'and RecordTypeId = :idInTipoSegmento '
				+'group by Nivel_1__c';

        if(niveles.get('Nivel01')!=null){
            niveles.get('Nivel01').clear();
        }

		niveles.put('Nivel01',getMatrizValue(q,'Nivel_1__c','nivel01'));
		nivel01=varSelect.get('nivel01');
		system.debug(nivel01);
		Nivel02();
	}

	public void Nivel02(){
		string q ='select Nivel_2__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c = :nivel01 '
				+'and Nivel_2__c !=null '
				+'and Nivel_3__c !=null '
				+'and Tipologia__c !=null '
                +'and Causal__c !=null '
                +'and RecordTypeId = :idInTipoSegmento '
				+'group by Nivel_2__c';

        if(niveles.get('Nivel02')!=null){
            niveles.get('Nivel02').clear();
        }

		niveles.put('Nivel02',getMatrizValue(q,'Nivel_2__c','nivel02'));
		nivel02=varSelect.get('nivel02');
		Nivel03();
	}
    
	public void Nivel03(){
			string q ='select Nivel_3__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c = :nivel01 '
				+'and Nivel_2__c = :nivel02 '
				+'and Nivel_3__c !=null '
				+'and Tipologia__c !=null '
                +'and Causal__c !=null '
                +'and RecordTypeId = :idInTipoSegmento '
				+'group by Nivel_3__c';

        if(niveles.get('Nivel03')!=null){
            niveles.get('Nivel03').clear();
        }

		niveles.put('Nivel03',getMatrizValue(q,'Nivel_3__c','nivel03'));
		nivel03=varSelect.get('nivel03');
		Nivel04();
	}

	public void Nivel04(){
			string q ='select Tipologia__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c = :nivel01 '
				+'and Nivel_2__c = :nivel02 '
				+'and Nivel_3__c =:nivel03 '
				+'and Tipologia__c !=null '
                +'and Causal__c !=null '
                +'and RecordTypeId = :idInTipoSegmento '
				+'group by Tipologia__c';

		if(niveles.get('Nivel04')!=null){
			niveles.get('Nivel04').clear();
        }

		niveles.put('Nivel04',getMatrizValue(q,'Tipologia__c','strInTipologia'));
		strInTipologia=varSelect.get('strInTipologia');
		Nivel05();
	}
    
    public void Nivel05(){
			string q ='select Causal__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c = :nivel01 '
				+'and Nivel_2__c = :nivel02 '
				+'and Nivel_3__c =:nivel03 '
				+'and Tipologia__c =:strInTipologia '
                +'and Causal__c !=null '
                +'and RecordTypeId = :idInTipoSegmento '
				+'group by Causal__c';

		if(niveles.get('Nivel05')!=null){
			niveles.get('Nivel05').clear();
        }

		niveles.put('Nivel05',getMatrizValue(q,'Causal__c','nivel04'));
		nivel04=varSelect.get('nivel04');
		Nivel06();
	}
	
	public void Nivel06(){
		list<MatrizTipificacion__c> lstMT = new list<MatrizTipificacion__c>([select id, Horas_de_negocio__c, Limite_de_horas__c, TipoCaso__c, Descripcion__c,Requiere_CUN__c,LTE_SistemaLegado__c
				from MatrizTipificacion__c
				where Estado__c=:strMaTrizTip_Activo
				and TipoCaso__c = :strInTipo
				and Nivel_1__c = :nivel01 
				and Nivel_2__c = :nivel02
				and Nivel_3__c =:nivel03
				and Tipologia__c=:strInTipologia
                and Causal__c=:nivel04
                and RecordTypeId = :idInTipoSegmento
                limit 1]);
        
        if(!lstMT.isEmpty()){
            reqCUN=lstMT[0].Requiere_CUN__c;
            strDescripcion=lstMT[0].Descripcion__c;
            strSistemaLegado=lstMT[0].LTE_SistemaLegado__c;
            insMT=lstMT[0];
        }
	}
}