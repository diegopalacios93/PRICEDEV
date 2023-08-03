/*******************************************************************************
Desarrollado por:       ETB
Autor:                  John Guevara
Proyecto:               Portafolio Superior Fase II
Descripción:            Controlador de la página CrearTipificacionCierre_pag encargada de seleccionar
						la correcta tipificación para el cierre del caso.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     24-11-2019  John Guevara (JG)       	Creación de la clase..
*******************************************************************************/
public with sharing class CrearTipificacionCierre_ctr {
	public ApexPages.StandardController controller;
    public Case CaseInfo{get;set;}
    
    public string strInTipoCatalogo {get;set;}
	public string strInTipo {get;set;}
	public string strDescripcion {get;set;}
    public boolean esTipificado{get;set;}
    private string strMatrizTip_Activo;
    private string strGrupo;
    private boolean validFechaFin {get;set;}
    
    public map<String,String> mpMatrizTipo = new map<String,String>();
	
	public string nivel01 {get;set;}
	public string nivel02 {get;set;}
	public string nivel03 {get;set;}
	public string nivel04 {get;set;}
	public string nivel05 {get;set;}
	public string nivel06 {get;set;}
    
	public List<SelectOption> lstNivel01 {get;set;}
	public List<SelectOption> lstNivel02 {get;set;}
	public List<SelectOption> lstNivel03 {get;set;}
	public List<SelectOption> lstNivel04 {get;set;}
	public List<SelectOption> lstNivel05 {get;set;}
    
    public String strEstado{get;set;}
	public List<SelectOption> lstEstado {get;set;}
    public String strCodigoCierre{get;set;}
	public List<SelectOption> lstCodigoCierre {get;set;}
    public String strResponsable{get;set;}
    public String strSubResponsable{get;set;}
	public List<SelectOption> lstResponsable {get;set;}
	public List<SelectOption> lstSubResponsable {get;set;}
    
    private Map<String,Object> sglDataMap;

    public CrearTipificacionCierre_ctr(ApexPages.StandardController controller){
		this.controller=controller;
        strInTipoCatalogo='';
        strGrupo='';
        validFechaFin=false;
        CargarLabels();
        esTipificado=true;
        
		id idCase = ApexPages.currentPage().getParameters().get('newid');
        
        Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name ='Campos Caso Remedy PS'];
        String sParamFields = lstMensajes.Mensaje__c;
        String selectParametersQuery = 'SELECT ' + sParamFields + ' FROM Case where Id =:idCase';
        list<Case> lstCaso = Database.query(selectParametersQuery);
        CaseInfo = lstCaso[0];
        
        lstCodigoCierre = new List<SelectOption>();
        List<RemedyListaSimple__c> lstRemedy = [SELECT Id,Etiqueta__c,Valor__c FROM RemedyListaSimple__c WHERE Tipo__c = 'CODIGO CIERRE' AND Activo__c = true];
        if(!lstRemedy.isEmpty()){
            for(RemedyListaSimple__c sglRemedy:lstRemedy){
                lstCodigoCierre.add(new SelectOption(sglRemedy.Etiqueta__c, sglRemedy.Valor__c));
            }
        }
        strCodigoCierre = CaseInfo.Codigo_Cierre__c;
        
        lstEstado = new List<SelectOption>();
        lstEstado.add(new SelectOption('Cerrado', 'Cerrado'));
        lstEstado.add(new SelectOption('Para Confirmar','Para Confirmar'));
        strEstado = CaseInfo.Status;
        if(strEstado!='Cerrado' && strEstado!='Para Confirmar'){
            lstEstado.add(new SelectOption(strEstado,strEstado));
        }
        
		/*CaseInfo=[Select id, CodigouniconumericoCUN__c,Accountid,Recordtype.Name,TipoCaso__c, Origin,FechaTipificacion__c,Plan__c,Plan__r.NombredelProducto__c,Plan__r.NombredelProducto__r.Name,Plan__r.NombredelProducto__r.Catalogo__c,Plan__r.NombredelProducto__r.Linea_Negocio_Aseguramiento__c,Plan__r.Plan_Troncales_Sip_Movil__c,
                  LTE_Servicio__c,LTE_Servicio__r.NombredelProducto__c,LTE_Servicio__r.NombredelProducto__r.Name,LTE_Servicio__r.NombredelProducto__r.Catalogo__c,LTE_Servicio__r.NombredelProducto__r.Linea_Negocio_Aseguramiento__c,LTE_Servicio__r.Plan__r.TipodePlan__c,LTE_Servicio__r.Plan__r.Plan_Troncales_Sip_Movil__c,
                  Id_Sistema_Legado__c from Case where id=:idCase];*/
        strInTipo=CaseInfo.Recordtype.Name;
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        
        if(CaseInfo.Recordtype.Name!='SOPORTE TECNICO'){
            esTipificado=true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'El tipo de caso debe ser Soporte Tecnico para poder realizar la tipificacion'));
        }else{
            if(CaseInfo.LTE_Servicio__c!=null){
                if(CaseInfo.LTE_Servicio__r.NombredelProducto__c!=null){
                    if(String.isNotEmpty(CaseInfo.LTE_Servicio__r.NombredelProducto__r.Catalogo__c)){
                        if(mpMatrizTipo.containsKey(CaseInfo.LTE_Servicio__r.NombredelProducto__r.Catalogo__c)){
                            strInTipoCatalogo = mpMatrizTipo.get(CaseInfo.LTE_Servicio__r.NombredelProducto__r.Catalogo__c);
                            esTipificado=false;
                        }
                    }
                    if(CaseInfo.LTE_Servicio__r.NombredelProducto__r.Name==vGlobal.Valor__c && (CaseInfo.LTE_Servicio__r.Plan__r.TipodePlan__c == 'Troncal SIP' || (CaseInfo.LTE_Servicio__r.Plan__r.TipodePlan__c == 'Principal' && CaseInfo.LTE_Servicio__r.Plan__r.Plan_Troncales_Sip_Movil__c == true))){
                        strInTipoCatalogo = 'Portafolio Superior';
                        esTipificado=false;
                    }
                    if(String.isNotEmpty(CaseInfo.LTE_Servicio__r.NombredelProducto__r.Linea_Negocio_Aseguramiento__c)){
                        strGrupo = CaseInfo.LTE_Servicio__r.NombredelProducto__r.Linea_Negocio_Aseguramiento__c;
                    }
                }
            }
            else if(CaseInfo.Plan__c!=null){
                if(CaseInfo.Plan__r.NombredelProducto__c!=null){
                    if(String.isNotEmpty(CaseInfo.Plan__r.NombredelProducto__r.Catalogo__c)){
                        if(mpMatrizTipo.containsKey(CaseInfo.Plan__r.NombredelProducto__r.Catalogo__c)){
                            strInTipoCatalogo = mpMatrizTipo.get(CaseInfo.Plan__r.NombredelProducto__r.Catalogo__c);
                            esTipificado=false;
                        }
                    }
                    if(CaseInfo.Plan__r.NombredelProducto__r.Name==vGlobal.Valor__c && (CaseInfo.Plan__r.TipodePlan__c == 'Troncal SIP' || (CaseInfo.Plan__r.TipodePlan__c == 'Principal' && CaseInfo.Plan__r.Plan_Troncales_Sip_Movil__c == true))){
                        strInTipoCatalogo = 'Portafolio Superior';
                        esTipificado=false;
                    }
                    if(String.isNotEmpty(CaseInfo.Plan__r.NombredelProducto__r.Linea_Negocio_Aseguramiento__c)){
                        strGrupo = CaseInfo.Plan__r.NombredelProducto__r.Linea_Negocio_Aseguramiento__c;
                    }
                }
            }
            if(esTipificado){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Debido al servicio asociado al caso no se puede definir la tipologia del cierre'));
            }else{
                Nivel01();
                
                lstResponsable = new List<SelectOption>();
                lstSubResponsable = new List<SelectOption>();
                lstResponsable.add(new SelectOption('',''));
                strResponsable = String.isEmpty(CaseInfo.Responsable_Legado__c)?'':CaseInfo.Responsable_Legado__c;
                strSubResponsable = String.isEmpty(CaseInfo.SubResponsable_Legado__c)?'':CaseInfo.SubResponsable_Legado__c;
                List<LV_Remedy__mdt> lstlvResponsable = [SELECT Id,Valor_Usuario__c,Valor_API__c FROM LV_Remedy__mdt WHERE Tipo_Lista__c = 'RESPONSABLE'];
                if(!lstlvResponsable.isEmpty()){
                    for(LV_Remedy__mdt sgllvResponsable:lstlvResponsable){
                        lstResponsable.add(new SelectOption(sgllvResponsable.Valor_API__c,sgllvResponsable.Valor_Usuario__c));
                    }
                }
                CargarSubResponsable();
                
                BusinessLogic_Caso_ctr sc = new BusinessLogic_Caso_ctr();
                Map<Id,Map<String,Object>> mapDatos = sc.GenerarDatamapCaso(lstCaso,'Homologacion_Remedy__mdt');
                sglDataMap = mapDatos.get(CaseInfo.Id);
            }
        }
    }

    public void CargarSubResponsable(){
        lstSubResponsable = new List<SelectOption>();
        system.debug('CargarSubResponsable - '+strResponsable);
        if(String.isNotEmpty(strResponsable)){
            List<LV_Remedy__mdt> lstlvSubResponsable = [SELECT Id,Valor_Usuario__c,Valor_API__c FROM LV_Remedy__mdt WHERE Tipo_Lista__c = 'SUBRESPONSABLE' AND Tipo_Lista_Padre__c = 'RESPONSABLE' AND Valor_API_Padre__c = :strResponsable];
            system.debug(lstlvSubResponsable);
            if(!lstlvSubResponsable.isEmpty()){
                for(LV_Remedy__mdt sgllvSubResponsable:lstlvSubResponsable){
                    lstSubResponsable.add(new SelectOption(sgllvSubResponsable.Valor_API__c,sgllvSubResponsable.Valor_Usuario__c));
                }
                if(String.isEmpty(strSubResponsable))
                    strSubResponsable=lstlvSubResponsable[0].Valor_API__c;
                system.debug(lstSubResponsable);
            }else{
                if(String.isEmpty(strSubResponsable))
                    strSubResponsable='';
                lstSubResponsable.add(new SelectOption(strSubResponsable,strSubResponsable));
            }
        }else{
            lstSubResponsable.add(new SelectOption('',''));
            strSubResponsable='';
        }
    }
    
	public void CargarLabels(){
		strMaTrizTip_Activo=Label.MatrizTip_Activo;
        List<Homologacion_Remedy__mdt> lstMatrizTipo = [SELECT Id,Tipo_Lista__c,Valor_API__c,Valor_Usuario__c FROM Homologacion_Remedy__mdt WHERE Tipo_Lista__c = 'MATRIZ_CIERRE_CATALOGO'];
        mpMatrizTipo = new map<String,String>();
        for(Homologacion_Remedy__mdt sglMatrizTipo:lstMatrizTipo){
            if(!mpMatrizTipo.containsKey(sglMatrizTipo.Valor_Usuario__c)){
                mpMatrizTipo.put(sglMatrizTipo.Valor_Usuario__c,sglMatrizTipo.Valor_API__c);
            }
        }
	}

	public void Nivel01(){
        lstNivel01 = new List<SelectOption>();
		string q ='select Nivel_1__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
            	+ (String.isNotEmpty(strGrupo)?'and Categoria__c = :strGrupo ':'')
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c != null '
				+'and Nivel_1__c != \'\' '
            	+ (string.isNotEmpty(strInTipoCatalogo)?'and RecordType.DeveloperName = :strInTipoCatalogo ':'')
				+'group by Nivel_1__c';

        lstNivel01 = getMatrizValue(q, 'Nivel_1__c');
        if(String.isNotEmpty(CaseInfo.CategoriaResolucionN1__c)){
            nivel01 = CaseInfo.CategoriaResolucionN1__c;
        }else if(!lstNivel01.isEmpty()){
            nivel01 = lstNivel01[0].getValue();
        }else{
            nivel01 = '';
        }
		system.debug(nivel01);
		Nivel02();
	}

	public void Nivel02(){
        lstNivel02 = new List<SelectOption>();
		string q ='select Nivel_2__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
            	+ (String.isNotEmpty(strGrupo)?'and Categoria__c = :strGrupo ':'')
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c = :nivel01 '
				+'and Nivel_2__c != null '
				+'and Nivel_2__c != \'\' '
            	+ (string.isNotEmpty(strInTipoCatalogo)?'and RecordType.DeveloperName = :strInTipoCatalogo ':'')
				+'group by Nivel_2__c';

        lstNivel02 = getMatrizValue(q, 'Nivel_2__c');
		if(String.isNotEmpty(CaseInfo.CategoriaResolucionN2__c)){
            nivel02 = CaseInfo.CategoriaResolucionN2__c;
        }else if(!lstNivel02.isEmpty()){
            nivel02 = lstNivel02[0].getValue();
        }else{
            nivel02 = '';
        }
		system.debug(nivel02);
		Nivel03();
	}

	public void Nivel03(){
        lstNivel03 = new List<SelectOption>();
		string q ='select Nivel_3__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
            	+ (String.isNotEmpty(strGrupo)?'and Categoria__c = :strGrupo ':'')
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c = :nivel01 '
				+'and Nivel_2__c = :nivel02 '
				+'and Nivel_3__c != null '
				+'and Nivel_3__c != \'\' '
            	+ (string.isNotEmpty(strInTipoCatalogo)?'and RecordType.DeveloperName = :strInTipoCatalogo ':'')
				+'group by Nivel_3__c';

        lstNivel03 = getMatrizValue(q, 'Nivel_3__c');
		if(String.isNotEmpty(CaseInfo.CategoriaResolucionN3__c)){
            nivel03 = CaseInfo.CategoriaResolucionN3__c;
        }else if(!lstNivel03.isEmpty()){
            nivel03 = lstNivel03[0].getValue();
        }else{
            nivel03 = '';
        }
		system.debug(nivel03);
		Nivel04();
	}

	public void Nivel04(){
        lstNivel04 = new List<SelectOption>();
		string q ='select Nivel_4__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
            	+ (String.isNotEmpty(strGrupo)?'and Categoria__c = :strGrupo ':'')
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c = :nivel01 '
				+'and Nivel_2__c = :nivel02 '
				+'and Nivel_3__c = :nivel03 '
				+'and Nivel_4__c != null '
				+'and Nivel_4__c != \'\' '
            	+ (string.isNotEmpty(strInTipoCatalogo)?'and RecordType.DeveloperName = :strInTipoCatalogo ':'')
				+'group by Nivel_4__c';

        lstNivel04 = getMatrizValue(q, 'Nivel_4__c');
		if(String.isNotEmpty(CaseInfo.CategoriaResolucionN4__c)){
            nivel04 = CaseInfo.CategoriaResolucionN4__c;
        }else if(!lstNivel04.isEmpty()){
            nivel04 = lstNivel04[0].getValue();
        }else{
            nivel04 = '';
        }
		system.debug(nivel04);
		Nivel05();
	}

	public void Nivel05(){
        lstNivel05 = new List<SelectOption>();
		string q ='select Nivel_5__c '
				+'from  MatrizTipificacion__c '
				+'where Estado__c=:strMaTrizTip_Activo '
            	+ (String.isNotEmpty(strGrupo)?'and Categoria__c = :strGrupo ':'')
				+'and TipoCaso__c = :strInTipo '
				+'and Nivel_1__c = :nivel01 '
				+'and Nivel_2__c = :nivel02 '
				+'and Nivel_3__c = :nivel03 '
				+'and Nivel_4__c = :nivel04 '
				+'and Nivel_5__c != null '
				+'and Nivel_5__c != \'\' '
            	+ (string.isNotEmpty(strInTipoCatalogo)?'and RecordType.DeveloperName = :strInTipoCatalogo ':'')
				+'group by Nivel_5__c';

        lstNivel05 = getMatrizValue(q, 'Nivel_5__c');
		if(String.isNotEmpty(CaseInfo.CategoriaResolucionN5__c)){
            nivel05 = CaseInfo.CategoriaResolucionN5__c;
        }else if(!lstNivel05.isEmpty()){
            nivel05 = lstNivel05[0].getValue();
        }else{
            nivel05 = '';
        }
		system.debug(nivel05);
		Nivel06();
	}
	
	public void Nivel06(){
		list<MatrizTipificacion__c> lstMT = new list<MatrizTipificacion__c>([select id, Descripcion__c
				from MatrizTipificacion__c
				where Estado__c=:strMaTrizTip_Activo
				and TipoCaso__c = :strInTipo
				and Nivel_1__c = :nivel01
				and Nivel_2__c = :nivel02
				and Nivel_3__c = :nivel03
				and Nivel_4__c = :nivel04
				and Nivel_5__c = :nivel05
                limit 1]);
        
        if(!lstMT.isEmpty()){
            strDescripcion=lstMT[0].Descripcion__c;
        }else{
            strDescripcion='';
        }
	}
    
	public List<SelectOption> getMatrizValue(string q, string value){
        List<SelectOption> lstOption = new List<SelectOption>();
        AggregateResult[] opt=Database.query(q);
		for(AggregateResult a: opt){
			string strEt=(string)a.get(value);
            strEt=String.isEmpty(strEt)?'':strEt;
			if(strEt!=null){
				lstOption.add(new SelectOption(strEt.toUpperCase(), strEt));
			}
		}
		lstOption.sort();
		return lstOption;
	}
    
    public void Guardar(){
		PageReference p=null;
        String strErrMessage = '';
        
        if(CaseInfo.Pertinencia_Horas__c==null){
            strErrMessage = 'El campo "'+ Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get('Pertinencia_Horas__c').getDescribe().getLabel()  +'" es obligatorio';
        } else if(CaseInfo.Pertinencia_Minutos__c==null){
            strErrMessage = 'El campo "'+ Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get('Pertinencia_Minutos__c').getDescribe().getLabel()  +'" es obligatorio';
        } else if(CaseInfo.Pertinencia_Segundos__c==null){
            strErrMessage = 'El campo "'+ Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get('Pertinencia_Segundos__c').getDescribe().getLabel()  +'" es obligatorio';
        }else if(CaseInfo.SolucionSistemaLegado__c==null){
            strErrMessage = 'El campo "'+ Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get('SolucionSistemaLegado__c').getDescribe().getLabel()  +'" es obligatorio';
        }else if(CaseInfo.DescripcionSolucion__c==null){
            strErrMessage = 'El campo "'+ Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get('DescripcionSolucion__c').getDescribe().getLabel()  +'" es obligatorio';
        }else if(CaseInfo.Arearesponsable__c==null){
            strErrMessage = 'El campo "'+ Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get('Arearesponsable__c').getDescribe().getLabel()  +'" es obligatorio';
        }else if(validFechaFin==false){//debe ser el ultimo if
            validFechaFin=true;
            strErrMessage = 'Por favor asegurar el valor del campo "'+ Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap().get('FechaFinAfectacion__c').getDescribe().getLabel()  +'". Si es correcto por favor presionar el boton guardar';
        }
        
        if(String.isEmpty(strErrMessage)){
            //System.Savepoint svP;
            try{
                BusinessLogic_Caso_ctr sc = new BusinessLogic_Caso_ctr();
                Map<Id,Map<String,Object>> mapDatos = new Map<Id,Map<String,Object>>();
                String strEstadoRemedy = (strEstado=='Cerrado'?'CERRADO':(strEstado=='Para Confirmar'?'POR CONFIRMAR':''));
                system.debug(strEstado);
                sglDataMap.put('Causal_Estado__c',strEstado);
                sglDataMap.put('CategoriaResolucionN1__c',nivel01);
                sglDataMap.put('CategoriaResolucionN2__c',nivel02);
                sglDataMap.put('CategoriaResolucionN3__c',nivel03);
                sglDataMap.put('CategoriaResolucionN4__c',nivel04);
                sglDataMap.put('CategoriaResolucionN5__c',nivel05);
                sglDataMap.put('strCodigoCierre',strCodigoCierre);
                sglDataMap.put('strResponsable',strResponsable);
                sglDataMap.put('strSubResponsable',strSubResponsable);
                sglDataMap.put('Pertinencia_Horas__c',String.valueof(CaseInfo.Pertinencia_Horas__c));
                sglDataMap.put('Pertinencia_Minutos__c',String.valueof(CaseInfo.Pertinencia_Minutos__c));
                sglDataMap.put('Pertinencia_Segundos__c',String.valueof(CaseInfo.Pertinencia_Segundos__c));
                sglDataMap.put('strFechaFinAfectacion',CaseInfo.FechaFinAfectacion__c!=null?CaseInfo.FechaFinAfectacion__c.format('yyyy-MM-dd\'T\'HH:mm:ssXXX','America/Bogota'):'');
                sglDataMap.put('SolucionSistemaLegado__c',CaseInfo.SolucionSistemaLegado__c);
                system.debug(sglDataMap);
                mapDatos.put(CaseInfo.Id,sglDataMap);
                if(CaseInfo.Id_Sistema_Legado__c != null && (CaseInfo.Categoria_legado__c== 'Incidente' || CaseInfo.Categoria_legado__c== 'Evento'))
                    strErrMessage = sc.ActualizaRemedy(CaseInfo, mapDatos);
                if(String.isEmpty(strErrMessage)){
                    //svP=Database.setSavepoint();
                    CaseInfo.CategoriaResolucionN1__c = nivel01;
                    CaseInfo.CategoriaResolucionN2__c = nivel02;
                    CaseInfo.CategoriaResolucionN3__c = nivel03;
                    CaseInfo.CategoriaResolucionN4__c = nivel04;
                    CaseInfo.CategoriaResolucionN5__c = nivel05;
                    CaseInfo.Responsable_Legado__c = strResponsable;
                    CaseInfo.SubResponsable_Legado__c = strSubResponsable;
                    CaseInfo.EstadoSistemaLegado__c = strEstadoRemedy;
                    CaseInfo.Codigo_Cierre__c = strCodigoCierre;
                    if(strEstado=='Cerrado'){
                        CaseInfo.status = strEstado;
                    }else if(strEstado=='Para Confirmar'){
                        CaseInfo.Causal_Estado__c = strEstado;
                    }
                    
                    update CaseInfo;
                    esTipificado=false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Tipificacion guardada correctamente'));
                    //p=new PageReference('/'+CaseInfo.id);
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,strErrMessage));
                }
            }
            catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()+' '+e.getStackTraceString()));
                //Database.rollback(svP);
                //return null;
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(validFechaFin==false?ApexPages.Severity.ERROR:ApexPages.Severity.WARNING,strErrMessage));
        }
        //return p;
    }
    
    public pageReference Cancelar(){
        PageReference p=null;
        if(CaseInfo!=null){
           p = new PageReference('/'+CaseInfo.id);
        }
        return p;
    }
}