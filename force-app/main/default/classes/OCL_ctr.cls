/**********************************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Jorge Grimaldos
Proyecto:			ETB Evolutivos
Descripci�n:		Clase controladora del nuevo desarrollo de manejo de Legalizaciones

Cambios (Versiones)
-------------------------------------
No.		Fecha			Autor						Descripci�n
----	----------		--------------------		---------------
1.0		2014-06-11		Jorge Grimaldos (JG)		Creaci�n de la clase.

**********************************************************************************************************************/
public class OCL_ctr {
		
	//	Wrapper para las Operaciones Comerciales
	
	public class wrpOc {
		public Boolean check {get; set;}
		public OperacionComercial__c oC {get; set;}
		public wrpOc(OperacionComercial__c o) {
			oC = o;
			check = false;
		}
	}

	//	Wrapper para las Oportunidades

	public class wrpOpp {
		public Boolean check {get; set;}
		public Id id {get; set;}
		public String name {get; set;}
		public List<wrpOc> lstOC {get; set;}
		public wrpOpp(Opportunity o) {
			id = o.Id;
			name = o.Name;
			lstOC = new List<wrpOC>();
		}
	}

	//	Definici�n de Etiquetas

	private string strLabelNoIdContratoActual = Label.OCL_ctr_NoIdContratoActual;
	private string strEstadoViableViabilidad = Label.OCL_ctr_EstadoViableViabilidad;
	private string strLabelNoOCAdquiridas =  Label.OpComLegalizar_NoHayOP;
	private string strLabelNoContratoActual = Label.OCL_ctr_NoContratoActual;

	//	Definici�n de variables

	private Id idContrato;
	private Contract ctcActual;
	private boolean blnRenderBotonCrear;
	private List<OperacionComercial__c> lstOCInteres = new List<OperacionComercial__c>();
	private Map<String, List<OperacionComercial__c>> mapFictOpps = new Map<String, List<OperacionComercial__c>>();
	private Map<String, Set<String>> mapCamposObligatorios = new Map<String, Set<String>>();
	private map<string,Schema.SObjectField> mapCamposOC = new map<string,Schema.SObjectField>();
	private Set<String> setCamposObligatoriosOC = new Set<String>();
	private Set<String> setCamposQuery = new Set<String>{'id', 'Name', 'RecordType.Name', 'Oportunidad__r.Name', 'Plan__r.Name','TOPP__r.Name', 'TOPP__r.AplicaPreventa__c',' Activo__r.NombredelProducto__c', 'CreatedDate', 'LastModifiedDate', 'Activo__r.Plan__r.NombredelProducto__r.Name', 'TOPP__r.TipodeOperacionporplan__c','Activo__r.Id','CreatedById','Cantidad_de_Veces_ARPU__c','RecordTypeId','Activo_Relacionado__c','Demo__c','LTE_EstadoAprobacion__c','Requiere_sistema_autonomo__c','Activo__r.Destinacion__c','Activo__r.Cobertura__c','Activo__r.Name'};
	public string titulo {
		get {
			return Label.OpComLegalizar_Titulo;
		}
	}
	public string subtitulo {
		get {
			if (ctcActual != null)
				return 'Contrato ' + ctcActual.ContractNumber;
			else
				return null;
		}
	}
	public boolean RenderBotonCrear{
		get {
			return blnRenderBotonCrear;
		}
	}	
	public List<wrpOpp> lstWrOpp {get; set;}
	public Boolean blnCheckSeleccionarTodo {get; set;}
    Integer intOcsDemo;
    Integer intOcsNoDemo;
    String ocsDemoSinAprobar;
	
	//	Constructor

	public OCL_ctr(){
		//Obtenci�n de par�metro de entrada
		blnRenderBotonCrear = false;
		try {
			idContrato = ApexPages.currentPage().getParameters().get('id');
			if (idContrato == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strLabelNoIdContratoActual ));
				return;
			}
		} catch (Exception e) {
			ApexPages.addMessages(e);
			return;        		
		}
		//	Adquisici�n de datos del Contrato
		if (idContrato != null) {
			List<Contract> lstContratos = [
			Select id, AccountId, ContractNumber From Contract Where id =:idContrato Limit 1
			];
			if (!lstContratos.isEmpty())
				ctcActual = lstContratos[0];
		}
		if (ctcActual == null)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strLabelNoContratoActual));
			return;
		} else {
		//	Adquisici�n de Operaciones Comerciales de Inter�s
			List<OperacionComercial__c> lstOC = ObtenerOperacionesComerciales();
			if (lstOC.isEmpty()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strLabelNoOCAdquiridas));
				return;
			}
			lstOCInteres = lstOC;
		}
		blnRenderBotonCrear = true;
	}
	
	//	Funci�n para Obtener las Operaciones Comerciales de Inter�s
	
	private List<OperacionComercial__c> ObtenerOperacionesComerciales() {
		VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE'); //-SAO
		VariablesGlobales__c vGlobalAPN = VariablesGlobales__c.getValues('NombreComercialAPN'); //-SAO
		List<OperacionComercial__c> lstRetorno = new List<OperacionComercial__c>();
		//	Consulta de las Operaciones Comerciales en BD
		List<OperacionComercial__c> lstQuery = [
		Select 
		id, Name, Oportunidad__r.Name, Oportunidad__r.Viabilidad_Adicional__c, Plan__r.Name,TOPP__r.Name, TOPP__r.AplicaPreventa__c, Activo__r.NombredelProducto__c, Operacion_Comercial_Relacionada__c,Operacion_Comercial_Relacionada__r.Plan__r.Viabilidad_Paquete__c,
		CreatedDate, LastModifiedDate, Demo__c, Requiere_sistema_autonomo__c,Activo__r.Destinacion__c,Activo__r.Cobertura__c,Activo__r.Name,(
			Select id From Viabilidades__r Where Respuestadeviabilidad__c =: strEstadoViableViabilidad
			)
		From OperacionComercial__c 
		Where 
		(
			Oportunidad__r.AccountId=: ctcActual.AccountId 
			Or 
			CuentaCliente__c =: ctcActual.AccountId)
		And 
		Plan__r.NombredelProducto__r.Name != : vGlobal.Valor__c
		And 
		Plan__r.NombredelProducto__r.Name != : vGlobalAPN.Valor__c
		And
		Legalizacion__c = null
		And
		(Estado__c='En Curso' Or Estado__c='Pendiente') //Estado__c = 'Activa'   //LEM 14-07-2014 se modifica para que muestre solo operaciones en curso y pendientes
		Order By Oportunidad__r.Name
		];
        // Validar viabilidad en paquetes
        Map<Id,List<OperacionComercial__c>> mpIdPaquete = new Map<Id,List<OperacionComercial__c>>();
        
		//	Filtrado de OC que no requieran Viabilidad o que tengan Viabilidades en estado Viable
		if (!lstQuery.isEmpty()) {
			for(OperacionComercial__c oc : lstQuery) {
				if((oc.TOPP__r.AplicaPreventa__c && oc.Viabilidades__r!=null && oc.Viabilidades__r.size()>0)
					|| (!oc.TOPP__r.AplicaPreventa__c) || (oc.Oportunidad__r.Viabilidad_Adicional__c == 'No requiere')){
					lstRetorno.add(oc);
                    }else if(oc.Operacion_Comercial_Relacionada__c!=null){
                        if(oc.Operacion_Comercial_Relacionada__r.Plan__r.Viabilidad_Paquete__c=='Solo el producto principal'){
                            if(!mpIdPaquete.containskey(oc.Operacion_Comercial_Relacionada__c)){
                                mpIdPaquete.put(oc.Operacion_Comercial_Relacionada__c, new List<OperacionComercial__c>());
                            }
                            mpIdPaquete.get(oc.Operacion_Comercial_Relacionada__c).add(oc);
                        }
                    }
			}
		}
        
        //Consulta orden principal en el paquete
        
        if(!mpIdPaquete.isEmpty()){
            List<OperacionComercial__c> lstQueryPaquete = [
                Select 
                id, Name, Oportunidad__r.Name, Oportunidad__r.Viabilidad_Adicional__c, Plan__r.Name,TOPP__r.Name, TOPP__r.AplicaPreventa__c, Activo__r.NombredelProducto__c, Operacion_Comercial_Relacionada__c,Operacion_Comercial_Relacionada__r.Plan__r.Viabilidad_Paquete__c,
                CreatedDate, LastModifiedDate, (
                    Select id From Viabilidades__r Where Respuestadeviabilidad__c =: strEstadoViableViabilidad
                )
                From OperacionComercial__c 
                Where 
                Id IN :mpIdPaquete.keyset() AND 
                Plan__r.NombredelProducto__r.Name != : vGlobal.Valor__c AND
                Plan__r.NombredelProducto__r.Name != : vGlobalAPN.Valor__c AND
                Legalizacion__c = null AND
                (Estado__c='En Curso' Or Estado__c='Pendiente')
                ORDER BY Oportunidad__r.Name
            ];
            
        
            //	Filtrado de OC que no requieran Viabilidad o que tengan Viabilidades en estado Viable
            if (!lstQueryPaquete.isEmpty()) {
                for(OperacionComercial__c oc : lstQueryPaquete) {
                    if((oc.TOPP__r.AplicaPreventa__c && oc.Viabilidades__r!=null && oc.Viabilidades__r.size()>0)
                       || (!oc.TOPP__r.AplicaPreventa__c) || (oc.Oportunidad__r.Viabilidad_Adicional__c == 'No requiere')){
                           lstRetorno.addAll(mpIdPaquete.get(oc.Id));
                       }
                }
            }
        }
		return lstRetorno;
	}

	//	Funci�n para procesar las Operaciones Comerciales de Inter�s hacia el wrapper

	private List<wrpOpp> ProcesarOportunidades() {
		List<wrpOpp> lstOpp = new List<wrpOpp>();
		for (String strLlave : mapFictOpps.keySet()) {
			Opportunity o = new Opportunity();
			List<wrpOc> lstOC = new List<wrpOc>();
			for (OperacionComercial__c oc : mapFictOpps.get(strLlave)) {
				if (o.id == null) {
					o.id = oc.Oportunidad__c;
					o.Name = oc.Oportunidad__r.Name;
					if (o.id == null)
						o.Name = 'Sin Oportunidad';
				}
				wrpOc wOC = new wrpOc(oc);
				lstOC.add(wOC);
			}
			wrpOpp opp = new wrpOpp(o);
			opp.lstOC = lstOC;
			lstOpp.add(opp);
		}
		return lstOpp;
	}

	//	Funci�n para segregar las Operaciones Comerciales seleccionadas

	private List<OperacionComercial__c> ExtraerOperacionesSeleccionadas(List<wrpOpp> lstWrOpp) {
		List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
		List<Id> lstIdOC = new List<Id>();
		for (wrpOpp o : lstWrOpp) {
			for (wrpOc oC : o.lstOC) {
				if (oC.check)
					lstIdOC.add(oC.oC.Id);
			}
		}
		lstOC = Database.query(ConstruirQueryObligatorios());
		return lstOC;
	}

	//	Funci�n para cargar los campos obligatorios de las Operaciones Comerciales

	private void CargarConfiguracionObligatorios() {
		if (mapCamposObligatorios.isEmpty()) {
			for (Campos_Obligatorios_OC__c c : Campos_Obligatorios_OC__c.getAll().values()){
				if (c.Obligatorio__c) {
					if (!mapCamposObligatorios.containsKey(c.Tipo_de_registro__c))
						mapCamposObligatorios.put(c.Tipo_de_registro__c,new set<string>{c.Nombre_API__c});
					mapCamposObligatorios.get(c.Tipo_de_registro__c).add(c.Nombre_API__c);
				}
			}
		}
		for (Set<String> setCampos : mapCamposObligatorios.values())
			setCamposObligatoriosOC.addAll(setCampos);
	}

	//	Funci�n para construir el query que incluye todos los campos obligatorios

	private String ConstruirQueryObligatorios() {
		CargarConfiguracionObligatorios();
		mapObjetoOC();
		String strRetorno;
		strRetorno = 'Select ' + String.join(new List<String>(setCamposQuery), ',');
		if (!setCamposObligatoriosOC.isEmpty())
			strRetorno = strRetorno + ',' + String.join(new List<String>(setCamposObligatoriosOC), ',');
		strRetorno = strRetorno + ' From OperacionComercial__c Where Id in :lstIdOC And Legalizacion__c = null';
		return strRetorno;
	}	
	//	Funci�n para Validad que las OC hayan sido modificadas

	private boolean ValidarOperacionModificada(OperacionComercial__c oc) {
		boolean blnRetorno = false;
		if (oc != null) {    //LEM 03-12-2014 se quita la validacion que la fecha de creacion sea diferente a la modificacion
			if (oc.CreatedDate != null && oc.LastModifiedDate != null /*&& oc.CreatedDate != oc.LastModifiedDate*/) {
				blnRetorno = ValidarOperacionDiligenciada(oc);
			}
		}
		return blnRetorno;
	}
	
	//	Funci�n para Validar que las operaciones comerciales hayan sido diligenciadas a nivel de formato
	
	private boolean ValidarOperacionDiligenciada(OperacionComercial__c oc) {
		boolean blnRetorno=true;
		if (mapCamposObligatorios.get(oc.RecordType.Name) != null && !mapCamposObligatorios.get(oc.RecordType.Name).isEmpty()) {
			blnRetorno = true;
			for (String s : mapCamposObligatorios.get(oc.RecordType.Name)) {
				
    			if (oc.get(s) == null) {
    				system.debug('mapCamposOC get s :'+mapCamposOC.get(s)+'  '+s);
    				system.debug('Valor del campo: '+oc.get(s));
    				blnRetorno = false;
    				break;
    			}
			}
		}
		return blnRetorno;
	}
	
	// Funci�n que devuelve los campos que est�n vacios para la oportunidad comercial
		private string ValidarCamposOperacion(OperacionComercial__c oc) {
		string camposVacios='';
		if (mapCamposObligatorios.get(oc.RecordType.Name) != null && !mapCamposObligatorios.get(oc.RecordType.Name).isEmpty()) {
			for (String s : mapCamposObligatorios.get(oc.RecordType.Name)) {
				system.debug('ssssss '+s);
				system.debug('mapCamposOC get s :'+mapCamposOC.get(s));
				system.debug('Valor del campo: '+oc.get(s));
    			if (oc.get(s) == null) {
    				if(mapCamposOC.containsKey(s))
    				{
    					 Schema.DescribeFieldResult descrip = mapCamposOC.get(s).getDescribe();
    					camposVacios+=' '+descrip.getLabel()+',';
    				}
    				
    			}
			}
			//quitar la coma final
			if(camposVacios!='')
				camposVacios=camposVacios.substring(0,camposVacios.length()-1);
		}
		return camposVacios;
	}

	private void mapObjetoOC()
	{
		mapCamposOC = Schema.SObjectType.OperacionComercial__c.fields.getMap();
		
	}
	//	Funci�n para generar el contenido de la Visualforce
	
	public pageReference Main() {
		if (ApexPages.hasMessages(ApexPages.Severity.FATAL) || ApexPages.hasMessages(ApexPages.Severity.ERROR))
			return null;
		for(OperacionComercial__c oC : lstOCInteres) {
			String strLlaveMapa = '' + oC.Oportunidad__c;
			if (!mapFictOpps.containsKey(strLlaveMapa))
				mapFictOpps.put(strLlaveMapa, new List<OperacionComercial__c>());
			mapFictOpps.get(strLlaveMapa).add(oC);
		}
		lstWrOpp = ProcesarOportunidades(); 
		return null;
	}

	//	Funci�n para crear la legalizaci�n a partir de las Operaciones Comerciales seleccionadas

	public pageReference CrearLegalizacion() {
        intOcsDemo 	  = 0;
    	intOcsNoDemo  = 0;
        ocsDemoSinAprobar = '';
		//	Obtenci�n de las OC seleccionadas en la VF
		string strResultValidacionARPU;        
		List<OperacionComercial__c> lstOC = ExtraerOperacionesSeleccionadas(lstWrOpp);
		System.Savepoint svReferencia;
		List<OperacionComercial__c> lstOCIncompletas = new List<OperacionComercial__c>();        
        List<string> 				lstOCErrorARPU	 = new List<string>();
        Map<String,Id>				mpCreatedByIdARPU = new Map<String,Id>();
        Map<String,String>			mpRecordTypeNAmeARPU = new Map<String,String>();
        set<string>					setOCsSinEnlaceSDWAN = new set<string>();
        set<string>					setOCsErrorIPV6		 = new set<string>();
        set<string>					setOCsErrorABB		 = new set<string>();
        //Boolean bNotificarContrato = false;
        
		//	Validaci�n de llenado de las Operaciones Comerciales Seleccionadas
		for (OperacionComercial__c oc : lstOC) {
			if (!ValidarOperacionModificada(oc))
			{
				system.debug('OC :'+oc);
				lstOCIncompletas.add(oc);
			}
            //strResultValidacionARPU = validarCampoARPUenOCs(oc);
            mpCreatedByIdARPU.put(oc.Name,oc.CreatedById);
            mpRecordTypeNAmeARPU.put(oc.Name,Schema.getGlobalDescribe().get('OperacionComercial__c').getDescribe().getRecordTypeInfosById().get(oc.RecordTypeId).getName());
            //if(strResultValidacionARPU != null)
            //    lstOCErrorARPU.add(strResultValidacionARPU);
                
            //verificar si la legalización a crear incluye OCs Demo
            if(oc.Demo__c){
                intOcsDemo ++;
                if(oc.LTE_EstadoAprobacion__c != 'Aprobado')
                    ocsDemoSinAprobar = ocsDemoSinAprobar+' '+oc.Name;
            }else
                intOcsNoDemo ++;
            
            //verificar si la legalización a crear incluye OCs Demo y se encuentra aprobada
            //if(oc.Plan__r.Notificacion_Contrato__c = true)
            //    bNotificarContrato = true;
            
            // Lógica validación campo Internet dedicado IPV6
            if(Schema.getGlobalDescribe().get('OperacionComercial__c').getDescribe().getRecordTypeInfosById().get(oc.RecordTypeId).getName() == 'Venta_Int_Dedidado_Empresarial_IPV6' && oc.Requiere_sistema_autonomo__c == null){
                setOCsErrorIPV6.add('La operación comercial: '+oc.Name+', requiere que se ingrese un valor en el campo: "Requiere Sistema Autónomo"');
            }            
            // Lógica validación numeración ABB 
            if(Schema.getGlobalDescribe().get('OperacionComercial__c').getDescribe().getRecordTypeInfosById().get(oc.RecordTypeId).getName() == 'Numeración Abreviada' && (oc.Activo__r.Destinacion__c == null || oc.Activo__r.Cobertura__c == null)){
                setOCsErrorABB.add(Label.Mensaje_Validacion_Numeracion_ABB.replace('%numeroOC%',oc.Name).replace('%numeroActivo%',oc.Activo__r.Name));
            }
		}
        //Logica SD-WAN
        setOCsSinEnlaceSDWAN = validarOCsRelacionadasSDWAN(lstOC);
        
        //Logica ARPU
        Set<Id> stPermissionARPU = new Set<Id>();
        Set<String> stLVARPU = new Set<String>();
        
        if(!mpCreatedByIdARPU.isEmpty() && !mpRecordTypeNAmeARPU.isEmpty()){
            List<PermissionSetAssignment> ListPermissionARPU = new List<PermissionSetAssignment>
                ([SELECT Id,AssigneeId FROM PermissionSetAssignment
                  WHERE PermissionSetId IN (SELECT Id FROM PermissionSet WHERE Label = 'Usuarios escritura requerida campo ARPU') AND
                  AssigneeId in :mpCreatedByIdARPU.values()]);
            for(PermissionSetAssignment sglPermissionARPU:ListPermissionARPU){
                stPermissionARPU.add(sglPermissionARPU.AssigneeId);
            }
            
            List<Tipos_de_registro_para_campo_ARPU__mdt	> lstLV = [SELECT Id, MasterLabel FROM Tipos_de_registro_para_campo_ARPU__mdt WHERE MasterLabel =:mpRecordTypeNAmeARPU.values()];
            for(Tipos_de_registro_para_campo_ARPU__mdt sglLV:lstLV){
                stLVARPU.add(sglLV.MasterLabel);
            }
            
        }
        
        for (OperacionComercial__c oc : lstOC) {
            if(!stPermissionARPU.isEmpty()&&!stLVARPU.isEmpty()){
                String strTipoRegistroOC = Schema.getGlobalDescribe().get('OperacionComercial__c').getDescribe().getRecordTypeInfosById().get(oc.RecordTypeId).getName();
                if(stPermissionARPU.contains(oc.CreatedById) && stLVARPU.contains(strTipoRegistroOC)){
                    if(string.isBlank(oc.Cantidad_de_Veces_ARPU__c))
                        lstOCErrorARPU.add(Label.Mensaje_Error_Campo_ARPU.replace('%numeroOC',oc.Name).replace('%tipoRegistro',strTipoRegistroOC));
                }
            }
        }
        //Termina Logica ARPU
        
		if (lstOCIncompletas.size() > 0) {
			String strMensajeIncompletas = '';
			for (OperacionComercial__c oc : lstOCIncompletas) {
				string faltantes = ValidarCamposOperacion(oc);
				strMensajeIncompletas = strMensajeIncompletas + '<li>' + oc.Name + ', Campos Faltantes: '+faltantes+ '</li>\n';
			}
			strMensajeIncompletas = Label.Operaciones_Comerciales_Incompletas.replace('%1',strMensajeIncompletas);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMensajeIncompletas));
		} else {
            if(setOCsSinEnlaceSDWAN.size() > 0){                
                for(string oc : setOCsSinEnlaceSDWAN){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.SDWAN_Msj_Validacion_OC_NoExiste.replace('%1',oc)));
                }
            }
            else if(lstOCErrorARPU.size() > 0){
                for(string strError : lstOCErrorARPU){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strError));                                        
                }
            }else if(intOcsDemo > 0 && intOcsNoDemo > 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DEMOS_Mensaje_validacion_Legalizacion));
            }else if(intOcsDemo > 0 && ocsDemoSinAprobar != '')
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DEMOS_Mensaje_validacion_aprobacion.replace('%ocs%',ocsDemoSinAprobar)));
            }else if(setOCsErrorIPV6.size() > 0){
                for(string strError : setOCsErrorIPV6){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strError));                                        
                }                
            }else if(setOCsErrorABB.size() > 0){
                for(string strError : setOCsErrorABB){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strError));                                        
                }
            }else
            {
                //	Creaci�n de Legalizaci�n y asociaci�n de sus respectivas operaciones comerciales
            	try {
                    svReferencia = Database.setSavepoint();
                    LibreriaUtilitaria_cls.GenerarExcepcionTest();
                    Legalizacion__c legNueva = new Legalizacion__c(Contrato__c = idContrato,Nombredelacuenta2__c = [Select AccountId From Contract Where ID =: idContrato Limit 1].AccountId);
                    Id RecordId = Schema.SObjectType.Legalizacion__c.getRecordTypeInfosByName().get('Legalización').getRecordTypeId();
                    legNueva.recordTypeId=RecordId;
                    if(intOcsDemo > 0)
                        legNueva.Legalizacion_servicios_Demo__c = true;
                    insert(legNueva);
                    for (OperacionComercial__c oc : lstOC) {
                        oc.Legalizacion__c = legNueva.Id;                        
                    }
                    update(lstOC);                    
                    
                    /*if(bNotificarContrato){
                        Contract sglContract = new Contract(Id = idContrato, Notificacion_Cierre__c = 'Larga Distancia');
                        update sglContract;
                    }*/
                    
                    return (new PageReference('/' + legNueva.Id));
                    //return (new PageReference('/apex/ConsultaCun_pag?id='+insLegal.Id));	<--	CUN de H�ctor.
                } catch(Exception e) {                    
                    ApexPages.addMessages(e);
                    Database.rollback(svReferencia);
                    return null;
                }
            }			
		}
		return null;
	}
    public set<string> validarOCsRelacionadasSDWAN(List<OperacionComercial__c> lstOC){         
        List<String> 				lstProductos	  = Label.SDWAN_Productos_relacionados.split(',');  
        set<string>					setOCsSinEnlace   = new set<string>();
        Map<string,OperacionComercial__c> mpOCSDWAN = new Map<string,OperacionComercial__c>();
        //set<string>					setNameOCSDWAN	  = new set<string>();
        //set<Id>						setIdACSDWAN	  = new set<Id>();
        //List<OperacionComercial__c> lstOCSDWAN		  = new List<OperacionComercial__c>();
        
        for (OperacionComercial__c objOC : lstOC) {
            if(objOC.Activo__r.Plan__r.NombredelProducto__r.Name == Label.SDWAN_Nombre_Producto && objOC.TOPP__r.TipodeOperacionporplan__c == 'Venta'){
			    //setNameOCSDWAN.add(objOC.Name);
                //lstOCSDWAN.add(objOC);
                //setIdACSDWAN.add(objOC.Activo__r.Id);
                mpOCSDWAN.put(objOC.Name, objOC);
            }
        }        
        if(mpOCSDWAN.size() > 0){            
            Boolean existeOcEnlace = false;
            List<ActivoETB__c> lstActivoSDWAN = new List<ActivoETB__c>();
            List<OperacionComercial__c> lstOCEnlaces =
            [
                SELECT Id, Activo__r.Id, Operacion_Comercial_Relacionada__c, Operacion_Comercial_Relacionada__r.Name
                FROM  OperacionComercial__c 
                WHERE Operacion_Comercial_Relacionada__r.Name IN: mpOCSDWAN.keyset() 
                AND Activo__r.Plan__r.NombredelProducto__r.Name IN: lstProductos
            ];
            for(string NameOcSDWAN : mpOCSDWAN.keyset()){
                existeOcEnlace = false;
                for(OperacionComercial__c ojOcEnlace : lstOCEnlaces){
                    if(NameOcSDWAN == ojOcEnlace.Operacion_Comercial_Relacionada__r.Name){
                    	existeOcEnlace = true;
                        ActivoETB__c objActivo = new ActivoETB__c(Id=ojOcEnlace.Activo__r.Id);
                        objActivo.Activo_Relacionado_SD_WAN__c = mpOCSDWAN.get(NameOcSDWAN).Activo__r.Id;
                        lstActivoSDWAN.Add(objActivo);
                        break;
                    }                    
                }
                if(mpOCSDWAN.get(NameOcSDWAN).Activo_Relacionado__c != null){
                    existeOcEnlace = true;
                    ActivoETB__c objActivo = new ActivoETB__c(Id=mpOCSDWAN.get(NameOcSDWAN).Activo_Relacionado__c);
                    objActivo.Activo_Relacionado_SD_WAN__c = mpOCSDWAN.get(NameOcSDWAN).Activo__r.Id;
                    lstActivoSDWAN.Add(objActivo);
                }
                if(!existeOcEnlace)
                   setOCsSinEnlace.add(NameOcSDWAN);                   
            }
            
            if(lstActivoSDWAN.size()>0)
                update lstActivoSDWAN;
        }             
        return setOCsSinEnlace;
    }
    public string validarCampoARPUenOCs(OperacionComercial__c objOCAux){         
        string result = null;
      	if(!Test.isRunningTest()){
            List<PermissionSetAssignment> ListPermission = new List<PermissionSetAssignment>
            ([SELECT Id FROM PermissionSetAssignment
              WHERE PermissionSetId IN (SELECT Id FROM PermissionSet WHERE Label = 'Usuarios escritura requerida campo ARPU') AND
              AssigneeId =: objOCAux.CreatedById]);
            
               if(ListPermission.size() > 0){
                string NombreTipoRegistroOC = Schema.getGlobalDescribe().get('OperacionComercial__c').getDescribe().getRecordTypeInfosById().get(objOCAux.RecordTypeId).getName();            
                List<Tipos_de_registro_para_campo_ARPU__mdt	> lstLV = [SELECT Id, MasterLabel FROM Tipos_de_registro_para_campo_ARPU__mdt WHERE MasterLabel =:NombreTipoRegistroOC];
                if(lstLV.size() > 0){
                    if(string.isBlank(objOCAux.Cantidad_de_Veces_ARPU__c))
                        result = Label.Mensaje_Error_Campo_ARPU.replace('%numeroOC',objOCAux.Name).replace('%tipoRegistro',NombreTipoRegistroOC);
                }            
            }        
        }
        return result;
    }
}