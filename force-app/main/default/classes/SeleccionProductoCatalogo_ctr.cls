/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - CRM etapa 1
Descripción:            Controlador de la página SeleccionProductoCatalogo_pag encargada de crear un nuevo activo
                                                con base en un producto y plan.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     26-09-2013  Andrés Cubillos (AAC)       Creación de la clase..
1.1     05-11-2013  Daniel Guana    (DGUANA)    Se modifican cambios para evolutivos.
1.2     14-01-2014  Jorge Grimaldos (JG)        Agregar ajuste para limitación por prefiles de la creación múltiple
1.3     23-01-2014  Jorgr Grimaldos (JG)        Agregar ajustes Requerimiento 1 Ajustes 20-01-2014
1.4     27-01-2014  Jorge Grimaldos (JG)        Agregar compatibilidad con controlador SeleccionarActivoExistente
1.5     06-02-2014  Jorge Grimaldos (JG)        Ajustes Pruebas UAT Paquete 20-01-2013
1.6     29-12-2014  Hector Bayona   (HB)        Redireccion Planes
1.7     26-10-2015  Manuel Medina   (MM)        Se realizan ajustes para asociar las lineas a las operaciones comerciales de Retiro y Cambio de Plan.
                                                - Se modificaron los metodos CargarOperaciones() y Crear().
                                                - Se creo el metodo asociarLineas().
1.8     16-09-2016  John Guevara    (SQDM)      Se modifican los filtros de productos, familias y Linea de Negocio
                                                para diferenciar los ofrecidos en las oportunidades de LTE
1.9    27-03-2018 Fernando Sarasty (FS)         Se incluye filtro en la consulta del método "getPlanesLD", para que se consulten únicamente los planes que no tengan activo el flag "inactivo".                     
1.10   30-03-2018 Fernando Sarasty (FS)         Se cran los métodos: creaOCCambioPlanACPrincipal, obtenerFechaCorte, obtenerPlanFacturacionId, obtenerPlanFacturacionName, obtenerSubPlanFacturacionName, buscarOCCambioPlan
1.11   11-05-2018 Fernando Sarasty (FS)			Se incluye código para poblar el campo "Viabilidad relacionada" de la OC.

1.12   26-10-2021  Matías Roldán   (MR)         Se incluye una variable boolean para renderizar otra VF page. linea 49 y 165
*******************************************************************************/ 
public with sharing class SeleccionProductoCatalogo_ctr {

    public map<string,string> mapParameters;    
    public string strIdOpp;
    public string strIdAccount;
    public string strIdActivo;
    public string strIdRTSIP;
    public string strTipodeOperacionporplan = '';
    public string strTitle {get;set;}
    public string strSubTitle {get;set;}
    public Id idObjeto {get;set;} //Variable de Modificar Atributos page

    public Opportunity insOpp;
    public ActivoETB__c insAct;
    public OperacionComercial__c insOP;
    public TOPP__c insTopp;
    public boolean blnBtnCrear {get;set;} 
    public boolean blnBtnBW {get;set;}
    public boolean blnSeccionProd {get;set;}

    public boolean blnRender {get;set;} // Nueva variable de test creada.
    public boolean blnModalPlanes {get;set;}
    public boolean blnGN {get;set;} 
    public boolean blnBloqueoOportunidad {get;set;} 
    
    private string strEstadoActivo;
    private string strEstadoActivoBW;
    private string strPrincipal;
    private string strPendiente;
    private string strAgregaCorrecto;
    private string strEstadoActivoOP;
    private string strEstadoEnCursoOP;
    private string strEstadoCompletadoOP;
    private string strNombrePerfil;
    private string strNombreUsuario;
    private string strNombrePerfilExperienciaCliente;
    private string strErrorCamposObli;
    private string strBloqueoOpp;
    private string strTypeOpp;
    private Map<string,VariablesGlobales__c> vGlobal; // [2018-04-02 Fernando Sarasty (FS)]    
    
    public string strInLineaNegocio {get;set;}      
    public string strInFamilia {get;set;}
    public string strInProducto {get;set;}    
    public string strInDetalle {get;set;} // [2018-05-28 Fernando Sarasty (FS)]    
    public string strInPlan {get;set;}
    public string strInOperacion {get;set;}
    public string strInBW {get;set;}
    public string strInCantidad {get;set;}
    
    
    public CatalogoProductos__c insCata {get;set;}
    public Planes__c insPlanes  {get;set;}
    public Reserva__c objOfertaEconomica {get; set;} // [2017-04-02 Fernando Sarasty (FS)]
    public OperacionComercial__c objOC   {get; set;} // [2017-04-02 Fernando Sarasty (FS)]
    private List<PlanFacturacion__c> lstPlanFacturacion; // [2017-04-02 Fernando Sarasty (FS)]
    private List<SubPlanFacturacion__c> lstSubPlanFacturacion; // [2017-04-02 Fernando Sarasty (FS)]
    private List<OperacionComercial__c> lstOCCambioPlan; // [2017-04-02 Fernando Sarasty (FS)]
    list<ActivoETB__c> lstActETBAux = new list<ActivoETB__c>(); // [2017-04-02 Fernando Sarasty (FS)]    
    List<TOPP__c> lstTOPP = new list<TOPP__c>();  // [2017-04-02 Fernando Sarasty (FS)]    
    
    //public set<string> stPlanesSecPerm;
    /* BEGIN - Manuel Medina - Mapa para relacionar el id del TOPP con el Tipo de Operacion por plan - 26102015*/
    public Map<String, String> mapTipoOperacionPlanXTOPPId  = new Map<String, String>();
    /* END - Manuel Medina - Mapa para relacionar el id del TOPP con el Tipo de Operacion por plan - 26102015*/
    
    public List<SelectOption> lstLineaNegocio {get;set;}
    public List<SelectOption> lstFamilia {get;set;}
    public List<SelectOption> lstProducto {get;set;}
    public List<SelectOption> lstOperaciones {get;set;}
    public List<SelectOption> lstPlanes {get;set;}
    public List<SelectOption> lstBWs {get;set;}
    public List<SelectOption> lstDetalle {get;set;} // [2018-05-28 Fernando Sarasty (FS)]
    public List<SelectOption> lstCantidad {get;set;}   
    public string accountId{get;set;}
    public boolean 			  reqRelacionarOC_SDWAN = false;
    public static OperacionComercial__c newOpeCom;
    public static id strOcId {get;set;}
    public static id strProductId {get;set;}
    
    /**
    *   v1.2
    *   Creación de la variable blnEditarCantidad
    **/
    
    public boolean blnEditarCantidad {
        get{
            if (blnEditarCantidad == null) {
                List<String> lstPerfiles = new List<String>();
                for(PerfilesCantidadActivos__c p : PerfilesCantidadActivos__c.getAll().values()) {
                    lstPerfiles.add(p.Nombre_Perfil__c);                    
                }
                if ([Select Id from Profile Where Name in :lstPerfiles And Id = :System.UserInfo.getProfileId() Limit 1].size() == 0) {                    
                    blnEditarCantidad = true;
                }
                else {
                    blnEditarCantidad = false;
                }
            }
            return blnEditarCantidad;
        }
        set;
    }
    
    /**
    *   v1.4
    *   Creación de las variables idOppActExistente y blnOpcActExistente
    **/
    
    public Id idOppActExistente {
        get { return (Id)ApexPages.currentPage().getParameters().get('idOp');}
    }
    
    public Boolean blnOpcActExistente {
        get { return idOppActExistente != null;}
    }    
    
    public SeleccionProductoCatalogo_ctr(){
        esPlanLD=false;
        CargarCantidad();
    }
    
    public void CargarLabels(){
        strEstadoActivo = Label.SelProdCat_Activo;
        strPrincipal=Label.SelProdCat_Principal;
        strEstadoActivoBW=Label.SelProdCat_ActivoBW;
        strPendiente=Label.SelProdCat_EstPendienteOC;   
        strAgregaCorrecto=Label.SelProdCat_AgregaCorrecto;      
        strEstadoActivoOP='Activo';//de la operación comercial
        strEstadoEnCursoOP='En Curso'; //de la operación comercial
        strEstadoCompletadoOP='Facturado'; //de la operación comercial
        strNombrePerfilExperienciaCliente='agentes / analistas';
        strErrorCamposObli=Label.SelProdCat_CamposObl; 
        strBloqueoOpp=Label.SelProdCat_BloqueoOpp;
    }   
   
   
    private void Iniciar(){
        CargarLabels();
        BuscarNombrePerfil();
        blnGN=false;
        blnRender = false; // Nueva variable de prueba
        blnModalPlanes = false;
        mapParameters = new map<string,string>();
        mapParameters=ApexPages.currentPage().getParameters();
        
        if(mapParameters.get('GN')!=null){
            blnGN=true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, strAgregaCorrecto));
        }
        
        strIdOpp=null;
        strIdActivo=null;             
        
        lstLineaNegocio = new List<SelectOption>();
        lstFamilia = new List<SelectOption>();            
        lstProducto = new List<SelectOption>();
        insCata= new CatalogoProductos__c();
        lstOperaciones = new List<SelectOption>();
        lstPlanes = new List<SelectOption>();
        insPlanes = new Planes__c();    
        //stPlanesSecPerm = new set<string>();    
        blnBtnBW = false;    
        blnBtnCrear=false;
        blnSeccionProd=false;
        blnBloqueoOportunidad=false;
        strTitle='';
        strSubTitle='';  
        insOP=null; 
        List<Opportunity> OppRelated;
        strTypeOpp = '';
        
        if(DesdeUnaOportunidad(mapParameters.get('id'))){
            strIdOpp = mapParameters.get('id'); 
            OppRelated = [SELECT Id, RecordType.Name FROM Opportunity WHERE Id=:strIdOpp];
            strTypeOpp = OppRelated.size()>0?OppRelated[0].RecordType.Name:'';
            blnSeccionProd=true;
            strTitle=Label.SelProdCat_Titulo;
            strSubTitle='';
            
        }
        else if(DesdeUnActivo(mapParameters.get('id'))){
            strIdActivo = mapParameters.get('id');  
            blnSeccionProd=false;
            strTitle= Label.SelProdCat_Titulo2;
            strSubTitle='';
           
            
        }     
        
        System.debug('strTitle '+strTitle);
        System.debug('strSubTitle '+strSubTitle);
        
    }
    
    public void CargarCantidad(){
        lstCantidad = new List<SelectOption>();
        integer i;
        
        for(i=1;i<10;i++){      
            lstCantidad.add(new SelectOption(string.valueOf(i),string.valueOf(i)));
        }
        
        /**
        *   v1.2
        *   Incluir valores de 10 - 20 - 30 - 40 en la lista de cantidad
        **/
        
        for(i=1;i<5;i++){       
            lstCantidad.add(new SelectOption(string.valueOf(i*10),string.valueOf(i*10)));
        }        
    }
    
    public boolean DesdeUnaOportunidad(string strIdIn){
        Schema.DescribeSObjectResult r = Opportunity.sObjectType.getDescribe();
        string strUrlPrefix='';
        if(strIdIn!=null && strIdIn!=''){
            strUrlPrefix = strIdIn.substring(0,3);
            system.debug('==>DesdeUnaOportunidad:strUrlPrefix='+strUrlPrefix);  
            system.debug('==>DesdeUnaOportunidad:r.getKeyPrefix()='+r.getKeyPrefix());
            if(strUrlPrefix == r.getKeyPrefix()){
                return true;
            }
        }       
        return false;
    }
    
     public boolean DesdeUnActivo(string strIdIn){
        Schema.DescribeSObjectResult r = ActivoETB__c.sObjectType.getDescribe();
        string strUrlPrefix='';
        if(strIdIn!=null && strIdIn!=''){
            strUrlPrefix = strIdIn.substring(0,3);
            system.debug('==>DesdeUnActivo:strUrlPrefix='+strUrlPrefix);    
            system.debug('==>DesdeUnActivo:r.getKeyPrefix()='+r.getKeyPrefix());
            if(strUrlPrefix == r.getKeyPrefix()){
                return true;
            }
        }       
        return false;
    }
    
    
    
    
    public void ObtenerPlanesSecPerm(){
        list<Opportunity> lstOpp = new list<Opportunity>();
        list<ActivoETB__c> lstActETB = new list<ActivoETB__c>();
        list<OperacionComercial__c> lstOperaCom = new list<OperacionComercial__c>();
        
        //stPlanesSecPerm = new set<string>(); 
        list<string> lstPlanesSplit = new list<string>();
        
        
        if(strIdOpp!=null){     
            lstOpp = [select id, AccountId, Name, OwnerId, BloqueoRegistro__c
                        from Opportunity
                        where Id = :strIdOpp
                        ];
            if(lstOpp.size()>0){
                strIdAccount=lstOpp[0].AccountId;
                strSubTitle=lstOpp[0].Name;
                blnBloqueoOportunidad=lstOpp[0].BloqueoRegistro__c;
                insOpp=lstOpp[0];               
                                
            }
        }
        else if(strIdActivo!=null){
            lstActETB = [select id, Oportunidad__r.AccountId, Name, Oportunidad__r.OwnerId, NombredelProducto__c, NombredelProducto__r.Name, Demo__c,
                        Oportunidad__c, NombredelaCuenta__c,Retencion_Servicio__c,MedioUM__c,ProveedorUM__c,Tipodeprogramacion__c, ActivoETB__c.Activo_Relacionado__c,
                        /**
                        *   v1.5
                        *   Consulta de campos para asignación de campos obligatorios en las OC a partir de los servicios
                        **/
                        IDservicio__c, NumeroConexion__c, SucursalOrigen__c, AliadoColaborador__c,PlanLD__c,CuentaFacturacion__c, Tecnologia_servicio__c, 
                        //  Queda pendiente definir la correspondencia con Numero conexion LD y External ID
                            (Select SucursalOrigen__c, SucursalDestino__c 
                                From Operaciones_Comerciales__r 
                                where (Estado__c =:strEstadoEnCursoOP or Estado__c =:strEstadoActivoOP or Estado__c=:strEstadoCompletadoOP)
                                and Plan__r.TipodePlan__c =:strPrincipal
                                limit 1
                            ) 
                        from ActivoETB__c
                        where Id = :strIdActivo
                        ];
            if(lstActETB.size()>0){
                strIdAccount=lstActETB[0].Oportunidad__r.AccountId;
                strSubTitle=lstActETB[0].NombredelProducto__r.Name; 
                insAct=lstActETB[0];
                if(insAct.Operaciones_Comerciales__r!=null && insAct.Operaciones_Comerciales__r.size()>0){
                    insOP=insAct.Operaciones_Comerciales__r[0];
                }
                
                strInProducto = lstActETB[0].NombredelProducto__c;
                accountId=lstActETB[0].NombredelaCuenta__c;
            }
        }
        /*
        System.debug('strIdAccount:' + strIdAccount);
        System.debug('strEstadoActivo:' + strEstadoActivo);
        System.debug('strPrincipal:' + strPrincipal);
        lstOperaCom = [select id, TOPP__r.Plan__r.Name, TOPP__r.Plan__r.PlanesAdicionalesporPlanPpal__c,
                        TOPP__c, TOPP__r.Plan__c
                        from OperacionComercial__c
                        where Activo__r.Oportunidad__r.AccountId = :strIdAccount
                        and TOPP__r.Plan__r.Estado__c=:strEstadoActivo
                        and TOPP__r.Plan__r.TipodePlan__c =:strPrincipal
                        and TOPP__c !=null 
                        and TOPP__r.Plan__c!=null
                        and TOPP__r.Plan__r.PlanesAdicionalesporPlanPpal__c!=null
                        ];
       
        for(OperacionComercial__c ope: lstOperaCom){
            lstPlanesSplit = new list<string>();
                system.debug('==>DEBUG:split=');
                lstPlanesSplit = ope.TOPP__r.Plan__r.PlanesAdicionalesporPlanPpal__c.split(';');        
                system.debug('==>DEBUG:lstPlanesSplit='+lstPlanesSplit);                            
                system.debug('==>DEBUG:lstPlanesSplit.size()='+lstPlanesSplit.size());
                if(lstPlanesSplit.size()>0){
                    stPlanesSecPerm.addAll(lstPlanesSplit);
                    system.debug('==>DEBUG:stPlanesSecPerm='+stPlanesSecPerm);
                }    
        }
        */      
    }
    
   
    
    
    public pageReference AnalizaAccion(){       
        
        if(ValidarPerfilesRegla()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ReglaOC001+' 9'));
            return null;
        }
        Iniciar();      
        
        if(strIdOpp!=null && strIdOpp!=''){
            ObtenerPlanesSecPerm();
            if(blnBloqueoOportunidad){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strBloqueoOpp));
                return null;
            }
            CargarProd1();          
            if(lstLineaNegocio.size()>0){
                strInLineaNegocio=lstLineaNegocio[0].getValue();
                Refresco1();                
            }
        }
        else{
            if(strIdActivo!=null && strIdActivo!=''){
                ObtenerPlanesSecPerm();
                Refresco4();
            }
        }       
        
        return null;
    }
    
        
    public void CargarProd1(){

        lstLineaNegocio = new List<SelectOption>();
        AggregateResult[] gRes;
        Boolean boolTypeOpp = strTypeOpp=='LTE';
        //Cambiado para permitir SOQL dinamicos y poder identificar los planes a ofrecer para opps LTE
        String QueryTOPP ='select Plan__r.NombredelProducto__r.LineaNegocio__c l from TOPP__c ';
        QueryTOPP +='where Plan__r.Estado__c=\''+strEstadoActivo+'\' and Plan__r.NombredelProducto__c!=null and Activo__c = true ';
        QueryTOPP += boolTypeOpp?'and Disponible_LTE__c = true ':'';
        QueryTOPP +='group by Plan__r.NombredelProducto__r.LineaNegocio__c';        
        gRes = Database.query(QueryTOPP);        
        
         /*
          Angel Soto: Se cre? el campo Activo__c y se agreg? a la clausula WHERE el criterio necesario para que obtenga
                    ?nicamente los TOPP's con estado activo = true.
         */
     
        for(AggregateResult a: gRes){
                lstLineaNegocio.add(new SelectOption((string)a.get('l'), (string) a.get('l')));
        }
        
        lstLineaNegocio.sort();
        
        
    }
    
    public void CargarProd2(){

        lstFamilia = new List<SelectOption>();
        
        AggregateResult[] gRes;
        
        system.debug('==>DEBUG:strInLineaNegocio='+strInLineaNegocio);
        system.debug('==>DEBUG:strEstadoActivo='+strEstadoActivo);
        
        Boolean boolTypeOpp = strTypeOpp=='LTE';
        //Cambiado para permitir SOQL dinamicos y poder identificar los planes a ofrecer para opps LTE
        String QueryTOPP ='select Plan__r.NombredelProducto__r.Familia__c f from TOPP__c ';
        QueryTOPP +='where Plan__r.Estado__c=:strEstadoActivo and Plan__r.NombredelProducto__r.LineaNegocio__c =\''+strInLineaNegocio+'\' and Activo__c = true ';
        QueryTOPP += boolTypeOpp?'and Disponible_LTE__c = true ':'';
        QueryTOPP +='group by Plan__r.NombredelProducto__r.Familia__c';
        
        gRes = Database.query(QueryTOPP);
         /*
          Angel Soto: Se cre? el campo Activo__c y se agreg? a la clausula WHERE el criterio necesario para que obtenga
                    ?nicamente los TOPP's con estado activo = true.
         */
        for(AggregateResult a: gRes){
                lstFamilia.add(new SelectOption((string)a.get('f'), (string) a.get('f')));
        }
        
        lstFamilia.sort();
    }
    
    public void CargarProd3(){

        lstProducto = new List<SelectOption>();
        AggregateResult[] gRes;
        
        system.debug('==>DEBUG:strInLineaNegocio='+strInLineaNegocio);
        system.debug('==>DEBUG:strEstadoActivo='+strEstadoActivo);
        
        Boolean boolTypeOpp = strTypeOpp=='LTE';
        //Cambiado para permitir SOQL dinamicos y poder identificar los planes a ofrecer para opps LTE
        String QueryTOPP ='select Plan__r.NombredelProducto__r.id i,  Plan__r.NombredelProducto__r.Name n from TOPP__c ';
        QueryTOPP +='where Plan__r.Estado__c=\''+strEstadoActivo+'\' and Plan__r.NombredelProducto__r.LineaNegocio__c =: strInLineaNegocio ';
        QueryTOPP +='and Plan__r.NombredelProducto__r.Familia__c =:strInFamilia and Activo__c = true ';
        QueryTOPP += boolTypeOpp?'and Disponible_LTE__c = true ':'';
        QueryTOPP +='group by Plan__r.NombredelProducto__r.Name, Plan__r.NombredelProducto__r.id';
        
        gRes = Database.query(QueryTOPP);
        /*
          Angel Soto: Se cre? el campo Activo__c y se agreg? a la clausula WHERE el criterio necesario para que obtenga
                    ?nicamente los TOPP's con estado activo = true.
         */
     
        for(AggregateResult a: gRes){
                lstProducto.add(new SelectOption((string)a.get('i'), (string) a.get('n')));
        }
        
        lstProducto.sort();
    }
    
     public void CargarProd4(){

        list<CatalogoProductos__c> lstCatP = new list<CatalogoProductos__c>();
        
        system.debug('==>DEBUG:strInLineaNegocio='+strInLineaNegocio);
        system.debug('==>DEBUG:strEstadoActivo='+strEstadoActivo);           
        
        lstCatP = [select id, Name, Descripcion__c, Catalogo__c//, RequiereAgrupacionPlanes__c                           
                    from CatalogoProductos__c
                    where id=:strInProducto                                  
                    ];
     
        for(CatalogoProductos__c c: lstCatP){
            insCata=c;
        }
        
    }
    
    public void CargarPlanes(){

        lstPlanes = new List<SelectOption>();
        AggregateResult[] gRes;
        
        system.debug('==>DEBUG:strInProducto='+strInProducto);
        system.debug('==>DEBUG:strEstadoActivo='+strEstadoActivo);      
        
        gRes = [select Plan__r.id i,  Plan__r.Name n, Plan__r.TipodePlan__c tp                                  
                    from TOPP__c
                    where Plan__r.Estado__c=:strEstadoActivo
                    and Plan__r.NombredelProducto__c =: strInProducto
                    and Activo__c = true
                    and DisponibleVentainicial__c = true
                    group by Plan__r.Name, Plan__r.id, Plan__r.TipodePlan__c 
                    ];
         /*
          Angel Soto: Se cre? el campo Activo__c y se agreg? a la clausula WHERE el criterio necesario para que obtenga
                    ?nicamente los TOPP's con estado activo = true.
         */
     
        for(AggregateResult a: gRes){
            //DGUANA 5-11-2013, evolutivos: if(((string)a.get('tp'))==strPrincipal || ValidaPlanSecundario((string) a.get('n'))){
                lstPlanes.add(new SelectOption((string)a.get('i'), (string) a.get('n')));
            //}
        }
        
        lstPlanes.sort();                        
    }
    
    public void CargarPlanes2(){

        list<Planes__c> listPlanesQ = new list<Planes__c>();
        
        system.debug('==>DEBUG:strInPlan='+strInPlan);      
        
        listPlanesQ = [select id,Name,Descripcion__c, Tarifa__c, InformacionPlanesAdicionales__c,NombredelProducto__r.Name,RequiereAtributos__c                               
                    from Planes__c
                    where id=:strInPlan 
                    ];
                    
        for(Planes__c p: listPlanesQ){
            insPlanes=p;
        }                      
    }
    
    /*
    *   DGUANA 5-11-2013: Metodo para buscar planes automáticamente si se trabaja con activos.
    *   Consulta información de plan relacionado a activo, si no se encuentra consulta todas 
    *   las operaciones comerciales relacionadas y trae plan de la ultima creada
    */
     public void CargarPlanesAuto(){
        
        List<ActivoETB__c> lstAct = [select id, Plan__c,NombredelaCuenta__c from ActivoETB__c where id=:strIdActivo and Plan__c!=null];
        if(lstAct!=null && !lstAct.isEmpty()){
            
            if(strIdAccount==null){strIdAccount=lstAct.get(0).NombredelaCuenta__c;}
            strInPlan = lstAct.get(0).Plan__c;
        }else{
            List<OperacionComercial__c> lstOC = [select id,Plan__c from OperacionComercial__c where Activo__c = :strIdActivo order by createddate desc limit 1];
            if(lstOc!=null && !lstOc.isEmpty()){
                strInPlan = lstOC.get(0).Plan__c;
            }
        }
        
        
        list<Planes__c> listPlanesQ = new list<Planes__c>();
        system.debug('==>DEBUG:strInPlan='+strInPlan);      
        listPlanesQ = [select id,Name,Descripcion__c, Tarifa__c, InformacionPlanesAdicionales__c,NombredelProducto__r.Name                               
                    from Planes__c
                    where id=:strInPlan 
                    ];
                    
        
        for(Planes__c p: listPlanesQ){
            insPlanes=p;
        }                      
    }
    
    public void CargarOperaciones(){
        lstOperaciones = new List<SelectOption>();
        list<TOPP__c> lstTopp = new list<TOPP__c>();
        
        Set<String> lstTOPPHabilitados = new Set<String>();
        lstTOPPHabilitados.add('NINGUNO');
        vGlobal = VariablesGlobales__c.getAll();
        String strPerfilCollection = vGlobal.get('PerfilSusRecRet').Valor__c.toLowerCase();
        Set<String> lstPerfilCollection = new Set<String>(strPerfilCollection.split('\\,'));
        if(lstPerfilCollection.contains(strNombrePerfil)){
            lstTOPPHabilitados.add('Retiro');
            lstTOPPHabilitados.add('Suspensión');
            lstTOPPHabilitados.add('Reconexión');
        }
        /**
        *   v1.4
        *   Incluir Afectación de ingresos y filtro para las OC que entran por
        *   oportunidad a Activos Existentes
        **/
        /* BEGIN - Manuel Medina - Se incluye el campo TipodeOperacionporplan__c para alimentar el mapa mapTipoOperacionPlanXTOPPId - 26102015 */
        lstTopp = [select id,  Name, DisponibleVentainicial__c, Afecta_Ingresos__c, TipodeOperacionporplan__c
                    from TOPP__c
                    where Plan__r.Estado__c=:strEstadoActivo
                    and Plan__r.Id =:strInPlan
                    and Plan__r.NombredelProducto__c =: strInProducto
                    and (Activo__c = true OR TipodeOperacionporplan__c IN :lstTOPPHabilitados)
                    order by Name
                    ];        
        /*
         Angel Soto: Se cre? el campo Activo__c y se agreg? a la clausula WHERE el criterio necesario para que obtenga
                   ?nicamente los TOPP's con estado activo = true.
        */
        /* END - Manuel Medina - Se incluye el campo TipodeOperacionporplan__c para alimentar el mapa mapTipoOperacionPlanXTOPPId - 26102015 */
     
        for(TOPP__c t: lstTopp){
            if(blnSeccionProd && t.DisponibleVentainicial__c || (!blnSeccionProd && !t.DisponibleVentainicial__c && !blnOpcActExistente) || (blnOpcActExistente && !t.DisponibleVentainicial__c && t.Afecta_Ingresos__c)){
                
                lstOperaciones.add(new SelectOption(t.id,t.Name));
                /* BEGIN - Manuel Medina - Carga de datos en el mapa para permitir relacion - 26102015 */
                this.mapTipoOperacionPlanXTOPPId.put( t.id, t.TipodeOperacionporplan__c );
                /* END - Manuel Medina - Carga de datos en el mapa para permitir relacion - 26102015 */
            }           
        }
        
        if(lstOperaciones.size()>0){
            blnBtnCrear=true;
        }
        
    }
    
    /*
    public boolean ValidaPlanSecundario(string strIn){      
        system.debug('==>ValidaPlanSecundario:strIn='+strIn);  
        for(string s: stPlanesSecPerm){
            system.debug('==>set:'+s); 
        }
        
        if(stPlanesSecPerm.contains(strIn)){        
            return true;
        }           
        
        return false;
    }
    */
    
    public void BuscarNombrePerfil(){
		List<user> lstUser = [SELECT Id, Name, userName, Profile.Name, UserRole.name FROM user WHERE Id = :Userinfo.getUserId()];
        if(lstUser.size()>0){
			strNombrePerfil = lstUser[0].Profile.Name.toLowerCase();
			strNombreUsuario = lstUser[0].userName.toLowerCase();
        }
    }
    
    public Boolean ValidarPerfilesRegla(){
        Perfiles_Reglas_OC__c myCS1 = Perfiles_Reglas_OC__c.getValues('Escenario09');
        Boolean valor =false;
        
        if(!myCS1.Desactivar__c){
            if(String.isNotEmpty(myCS1.Perfiles__c)){
                set<string> perfil=new set<string>(myCS1.Perfiles__c.split(','));
                valor = perfil.contains(Userinfo.getProfileId()) || perfil.contains(Userinfo.getUserName());
            }
        }

        return valor;
    }  
    
    
    public void CargarAnchoBanda(){
        list<AnchodeBanda__c> lstBW = new list<AnchodeBanda__c>();
        lstBWs = new list<Selectoption>();
        blnBtnBW=false;
        
        insTopp=BuscarTopp(strInOperacion);
        
        if(insTopp!=null&& insTopp.RequiereAnchodeBanda__c){            
            blnBtnBW=true;
            lstBW= [select id, Estado__c,Name
                    from AnchodeBanda__c
                    where Estado__c=:strEstadoActivoBW
                    ];
                    
            for(AnchodeBanda__c a: lstBW){
                lstBWs.add(new SelectOption(a.id,a.Name));
            }
        }
        lstBWs.sort();      
    }
    
    public pageReference Cancelar(){        
         PageReference p=null;
        if(strIdOpp!=null){
           p = new PageReference('/'+strIdOpp);
        }
        else if(strIdActivo!=null){
            p = new PageReference('/'+strIdActivo);
        }
        return p;
    }
    
    public PageReference Guardar(){
        return Crear();
    }
    

    public PageReference GuardarNuevo(){
        PageReference p=null;
        string strTmp;
        p = Crear();
        if(p!=null){ 
            strTmp = ApexPages.currentPage().getUrl();
            if(!blnGN
              ){
                strTmp+='&GN=true';
            }
            p = new PageReference(strTmp);
            p.setRedirect(true);
        }
        
        return p;       
    }
    
    /**
    * @Method:      asociarLineas
    * @param:       String strIdOperacionComercial
    * @param:       Boolean blnEsRetiro
    * @Description: Cargar todas las lineas activas en un servicio de larga distancia para asignarlas a la operacion comercial 
    * @author       Manuel Medina - 26102015
    */
    public void asociarLineas( String strIdOperacionComercial, Boolean blnEsRetiro ){
        List<Linea__c> lstLineasServicio                = new List<Linea__c>();
        lstLineasServicio                               = [SELECT Id,
                                                                Operacion_Comercial_Actual__c,
                                                                Operacion_Comercial_Actual__r.Plan__r.NombredelProducto__r.Name,
                                                                Activo__c,
                                                                Activo__r.CuentaFacturacion__r.Name,
                                                                CancelarCupo__c,
                                                                CancelarDescuento__c,
                                                                CrearLSP__c
                                                            FROM Linea__c
                                                            WHERE Activo__c =: strIdActivo
                                                            AND ActivaServicioLD__c = true
                                                        ];
                                                    
        for( Linea__c objLinea : lstLineasServicio ){
            if(objLinea.Operacion_Comercial_Actual__c!=null){
                /* BEGIN - Manuel Medina - Validacion para asignar la Cuenta de Facturacion cuando la linea pertenece a un Convenio de Cupo - 09112015 */
                if( objLinea.Operacion_Comercial_Actual__r.Plan__r.NombredelProducto__r.Name.equals( System.Label.ProductoVoz ) && objLinea.CrearLSP__c ){
                    objLinea.CuentaFacturacionAnterior__c   = objLinea.Activo__r.CuentaFacturacion__r.Name;
                    
                }else if( objLinea.Operacion_Comercial_Actual__r.Plan__r.NombredelProducto__r.Name.equals( System.Label.ProductoCupo ) ){
                    objLinea.CuentaFacturacionAnterior__c   = objLinea.Activo__r.CuentaFacturacion__r.Name;
                }
                /* END - Manuel Medina - Validacion para asignar la Cuenta de Facturacion cuando la linea pertenece a un Convenio de Cupo - 09112015 */
            }
            objLinea.Operacion_Comercial_Actual__c      = strIdOperacionComercial;
            objLinea.CancelarCupo__c                    = objLinea.CrearLSP__c;
            objLinea.CancelarDescuento__c               = false;
        }
        
        update lstLineasServicio;
    }
    
    public pageReference Crear(){   
        
        System.Debug('Entró por este crear');
        //HB flujos
        if(strIdAccount==null){strIdAccount=accountId;}
        
        //verificar si la venta es del producto SD-WAN y si tiene la Oportunidad posee enlaces a relacionar o si la cuenta posee algún enlace instalado.        
        if(!validacionesSDWAN(strIdAccount,strInProducto,'validaciones')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,(Label.SDWAN_Msj_Validacion_Enlaces+' '+Label.SDWAN_Productos_relacionados)));            
            return null;
        }
        //verificar si la venta es del producto Negocio Seguro y si en la Oportunidad posee una relacion con un producto principal
        /*else if(!validacionesNegocioSeguro(strIdAccount,strInProducto,'validaciones')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,(Label.SDWAN_Msj_Validacion_Enlaces+' '+Label.Negocio_Seguro_Productos_relacionados)));            
            return null;
        }*/
        else{            
            Map<String,String>dataUrl=new Map<String,String>();
            dataUrl.put('topp',strInOperacion);
            dataUrl.put('id',strIdAccount);
            System.Debug('strInOperacion '+strInOperacion);
            String saveURL=obtenerUrl(dataUrl);
            Viabilidad__c via;
            //HB flujos Fin
        
            PageReference p=null; 
            ActivoETB__c newActivoETB = new ActivoETB__c();
            System.Savepoint svP;
            integer i;
            integer intCantidad=1;
            string strIdRT=null;     
            Boolean integrarConGestor = false;
            
            /**
            *   v1.3
            *   Se agrega una variable para hacer seguimiento del id de la OC
            **/
            string strIdOc = null;
            
            if(strInCantidad!=null && strInCantidad!=''){           
                intCantidad = integer.valueOf(strInCantidad);   
            }

            string strReturnOpp;
            
            if(strInOperacion!=null && strInPlan!=null){        
                try{
                    svP=Database.setSavepoint();
                    //---Llenado del Activo ETB
                    insTopp=BuscarTopp(strInOperacion);
                    if(insCata.Catalogo__c == 'Aliado'){
                        strIdRT=Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta').getRecordTypeId();
                    }else{
                        strIdRT=BuscarTipoRegistro(insTopp);
                    }
                          
                    /***********************************/
                    if(strIdOpp!=null){ 
                        //Consultar parametro de integración con gestor
                        list<Opportunity> lsOP_integ = new list<Opportunity>();
                        lsOP_integ = [select Integrar_con_gestor__c from Opportunity where id=:strIdOpp];
                        if(lsOP_integ.size()>0)
                            integrarConGestor=lsOP_integ[0].Integrar_con_gestor__c;                    
                    }               
                    /***********************************/
                    for(i=1;i<=intCantidad;i++){    

                        if(strIdOpp!=null){                 
                            if(insCata.id !=null && insOpp.id!=null){
                                newActivoETB = new ActivoETB__c();
                                newActivoETB.NombredelProducto__c=insCata.Id;
                                newActivoETB.Oportunidad__c=insOpp.Id;
                                newActivoETB.OwnerId=insOpp.OwnerId;
                                newActivoETB.NombredelaCuenta__c=strIdAccount;
                                newActivoETB.Plan__c = insPlanes.Id;
                                insert newActivoETB;
                                
                                if(newActivoETB.id!=null){
                                    newOpeCom = new OperacionComercial__c();
                                    newOpeCom.Activo__c=newActivoETB.Id;
                                    if(blnBtnBW){
                                        newOpeCom.AnchoBanda__c=strInBW;
                                    }
                                    newOpeCom.Plan__c=insPlanes.Id;
                                    
                                    system.debug('==>Crear():strInOperacion='+strInOperacion); 
                                    system.debug('==>Crear():RecordTypeId='+strIdRT);
                                    system.debug('==>Crear():strIdOpp='+strIdOpp);
                                                             
                                    newOpeCom.TOPP__c=strInOperacion;
                                    newOpeCom.Estado__c=strPendiente;                                
                                    // [AAC 2013-10-10 se elimina x cambio en el manejo de sucursales] newOpeCom.SucursalOrigen__c=strIdAccount;
                                    if(strIdRT!=null && strIdRT!=''){
                                        newOpeCom.RecordTypeId=strIdRT; 
                                    }                                       
                                    if(strNombrePerfilExperienciaCliente!=strNombrePerfil){
                                        newOpeCom.Oportunidad__c=strIdOpp;
                                    }
                                    newOpeCom.Tarifa__c=insTopp.ValorTarifaPlan__c;
                                    newOpeCom.Valorunicavez__c=insTopp.Valorunicavez__c;
                                    newOpeCom.ValorTarifaPlan__c=insPlanes.Tarifa__c;
                                    newOpeCom.planLD__c=pLD;
                                    via = consultarViabilidad(strIdOpp);
                                    if(via != null)
                                        newOpeCom.Viabilidad_Relacionada__c = via.Id;
                                      
                                    if(strInDetalle !='' && strInDetalle != null) // [29/05/2018, FSARASTY]
                                        newOpeCom.Detalle_del_tramite__c = strInDetalle;
                                    
                                    if(integrarConGestor)
                                        newOpeCom.Integrar_con_gestor__c = integrarConGestor;
                                    
                                    //Temporalmente Soluciones TI no debe ir a Gestor
                                    if(insPlanes.NombredelProducto__r.Name=='Soluciones TI'){
                                        newOpeCom.Integrar_con_gestor__c = false;
                                    }
                                    
                                    if(insPlanes.Name=='Seguridad Centralizada Básica'){
                                        newOpeCom.TipodeServicioMS__c = 'Seguridad Centralizada Básica';
                                    }    
                                    if(insPlanes.Name=='Seguridad Centralizada Avanzada'){
                                        newOpeCom.TipodeServicioMS__c = 'Seguridad Centralizada Avanzada';
                                    }
                                    if(insTopp.Tipoderegistro__c == 'Venta_Int_Dedidado_Empresarial_IPV6'){
                                        newOpeCom.Duracion_Meses__c = 12;
                                    }
                                    if(insPlanes.Name=='Seguridad en la Nube' || insPlanes.Name=='Plan Servicios de Computo' || 
                                       insPlanes.Name=='Plan Servicios de Migración' || insPlanes.Name=='Plan Servicios Profesionales'){
                                        newOpeCom.TipodeServicioMS__c = insPlanes.NombredelProducto__r.Name;
                                        newOpeCom.Tipo_de_Plan__c = insPlanes.Name;
                                    }                                  
                                    system.debug('==>Crear():newOpeCom='+newOpeCom);                                
                                    insert newOpeCom;                                   
                                   
                                    // relacionar operaciones comerciales SD-WAN
                                    validacionesSDWAN(strIdAccount,strInProducto,'relacionarOCs');
                                    /**
                                    *   v1.3
                                    *   Asignación del Id de la OC
                                    **/  
                                    strOcId = newOpeCom.Id;
                                    strIdOc = newOpeCom.Id;   
                                    System.Debug('strIdOc '+strIdOc);
                                    System.Debug('strIdOc '+strIdOc);                             
                                    PS_ProcesarServiciosEmpaquetados_cls.procesar(insPlanes.Id, strIdOpp, insOpp.OwnerId, strIdAccount, newActivoETB.Id, newOpeCom.Id);
                                }
                            }                        
                        }                    
                        else if(strIdActivo!=null){    
                            if(insTopp.TipodeOperacionporplan__c == 'Cambio de Plan' && insAct.Demo__c){                                
                                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.ERROR, Label.DEMOS_Mensaje_validacion_Cambio_de_Plan));
                                return null;
                            }
                            newOpeCom = new OperacionComercial__c();                           
                            newOpeCom.Activo__c=insAct.Id;
                            if(blnBtnBW){
                                newOpeCom.AnchoBanda__c=strInBW;
                            }
                            newOpeCom.Plan__c=insPlanes.Id;
                            newOpeCom.TOPP__c=strInOperacion;
                            newOpeCom.Estado__c=strPendiente;
                            if(insCata.Catalogo__c == 'Aliado'){
                                strIdRT=Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Tramites').getRecordTypeId();
                            }
                            newOpeCom.RecordTypeId=strIdRT;
                            if(insAct.Activo_Relacionado__c != null) // [05/04/2018, FSARASTY]
                                newOpeCom.Servicio_ETB_Relacionado_Principal__c=insAct.Activo_Relacionado__c;
                            
                            if(strInDetalle !='' && strInDetalle != null) // [29/05/2018, FSARASTY]
                                newOpeCom.Detalle_del_tramite__c = strInDetalle;
                                
                            newOpeCom.RecordTypeId=strIdRT;
                            if(pLD!=null && pLD!='')
                                newOpeCom.PlanLD__c=pLD;
                            else
                                newOpeCom.PlanLD__c=insAct.PlanLD__c;
                            if(insTopp.TipodeOperacionporplan__c != 'Conversión Demo a Venta')
                            	newOpeCom.CuentaFacturacion__c=insAct.CuentaFacturacion__c;
                            
                            if(insTopp.TipodeOperacionporplan__c == 'Ampliación de Tiempo Demo')
                                newOpeCom.Demo__c = true;
                            /**
                            *   30-01-14
                            *   Queda pendiente por definir si debe o no permanecer la asignación de oportunidad, se comenta hasta nueva orden
                            **/
                            
    //                      if(strNombrePerfilExperienciaCliente!=strNombrePerfil){
    //                          newOpeCom.Oportunidad__c=insAct.Oportunidad__c;
    //                      }
    
                            /**
                            *   v1.5
                            *   Asignación de campos obligatorios para las OC a partir de los servicios
                            **/
                            newOpeCom.IDServicio__c = insAct.IDservicio__c;
                            newOpeCom.NumeroConexion__c = insAct.NumeroConexion__c;
                            newOpeCom.SucursalOrigen__c = insAct.SucursalOrigen__c;
                            newOpeCom.Fidelizacion__c = insAct.Retencion_Servicio__c;
                            newOpeCom.MedioUM__c = insAct.MedioUM__c; 
                            newOpeCom.ProveedorUM__c = insAct.ProveedorUM__c;
                            newOpeCom.Tipodeprogramacion__c = insAct.Tipodeprogramacion__c;    
                            newOpeCom.AliadoColaborador__c = insAct.AliadoColaborador__c;
    
                            if (blnOpcActExistente) {
                                newOpeCom.Oportunidad__c=idOppActExistente;
                            }
                            
                                    
                            if(integrarConGestor)
                                newOpeCom.Integrar_con_gestor__c = integrarConGestor;
                            
                            //Temporalmente Soluciones TI no debe ir a Gestor
                            if(insPlanes.NombredelProducto__r.Name=='Soluciones TI'){
                                newOpeCom.Integrar_con_gestor__c = false;
                            }
                            
                            // se asigna la tecnologia a la OC, cuando el producto es SD-WAN
                            if(insPlanes.NombredelProducto__r.Name==Label.SDWAN_Nombre_Producto){                             
                                newOpeCom.Tecnologia_servicio_SDWAN__c = insAct.Tecnologia_servicio__c;
                            }
                            
                            newOpeCom.Tarifa__c=insTopp.ValorTarifaPlan__c;
                            newOpeCom.Valorunicavez__c=insTopp.Valorunicavez__c;
                            newOpeCom.ValorTarifaPlan__c=insPlanes.Tarifa__c;
                            
                            vGlobal = VariablesGlobales__c.getAll();
                            String strPerfilCollection = vGlobal.get('PerfilSusRecRet').Valor__c.toLowerCase();
                            Set<String> lstPerfilCollection = new Set<String>(strPerfilCollection.split('\\,'));
                            if(lstPerfilCollection.contains(strNombrePerfil)){
                                if(strTipodeOperacionporplan.equals('Suspensión')||strTipodeOperacionporplan.equals('Reconexión')){
                                    newOpeCom.Detalle_del_tramite__c = 'Por Pago';
                                    newOpeCom.Fidelizacion__c = null;
                                    newOpeCom.TipoSuspension__c='Por Pago';
                                }else if(strTipodeOperacionporplan.equals('Retiro')){
                                    newOpeCom.Detalle_del_tramite__c = 'Por Pago';
                                    newOpeCom.Fidelizacion__c = null;
                                    newOpeCom.CausalRetiro__c = 'Por Falta de Pago';
                                }
                            }
                            
                            system.debug('==>Crear():insOP='+insOP); 
                            if(insOP!=null){
                                // [AAC 2013-10-10 se elimina x cambio en el manejo de sucursales] newOpeCom.SucursalOrigen__c=insOP.SucursalOrigen__c;
                                // [AAC 2013-10-10 se elimina x cambio en el manejo de sucursales] newOpeCom.SucursalDestino__c=insOP.SucursalDestino__c;   
                            }
                            
                            String idOcRelacionada =  obtenerOCRelacionadaNIP(newOpeCom);
                            system.debug('==>Crear():idOcRelacionada='+idOcRelacionada); 
                            if(!String.isEmpty(idOcRelacionada))
                            {
                                newOpeCom.Operacion_Comercial_Relacionada__c =idOcRelacionada;
                            }
                            insert newOpeCom;
                            clonarSVA(newOpeCom.id,insAct.id);
                            /*
                            *   v1.3
                            *   Asignación del Id de la OC
                            **/
                            strOcId = newOpeCom.Id;
                            strIdOc = newOpeCom.Id;
                            
                            /* BEGIN - Manuel Medina - Validacion para asociar las lineas si es un cambio o retiro de plan */
                            if( mapTipoOperacionPlanXTOPPId.get( strInOperacion ) != null && mapTipoOperacionPlanXTOPPId.get( strInOperacion ).equals( 'Retiro' ) ){
                                asociarLineas( strIdOc, true );
                            }else if( mapTipoOperacionPlanXTOPPId.get( strInOperacion ) != null && mapTipoOperacionPlanXTOPPId.get( strInOperacion ).equals( 'Cambio de Plan' ) ){
                                asociarLineas( strIdOc, false );
                            }
                            /* END - Manuel Medina - Validacion para asociar las lineas si es un cambio o retiro de plan */
                            
                            creaOCCambioPlanACPrincipal(strIdActivo, strIdOc); //  [2017-04-02 Fernando Sarasty (FS)] Generación de OC de cambio de PLAN sobre AC principal de una Troncal SIP                                                                        
                            
                            if(verificaPostVentaNIP(strInOperacion)){
                                relacionarActivosNIPaOC(insAct.Id, strIdOc);
                            }
                        }
                    } // End For
    				
                    if(strIdOpp!=null){
                        if(intCantidad>1){
                            p = new PageReference('/'+strIdOpp+saveURL);
                        }
                        /**
                        *   v1.12
                        *   Se cambia la funcionalidad cuando el catálogo es Aliado
                        **//*
                        else if(insCata.Catalogo__c == 'Aliado'){
                            crearSVAyXA(newOpeCom.id, insPlanes.id);
                            blnRender = true;
                        */
                        /**
                         * Se agrega la funcionalidad para seleccionar varios planes 
                         * inicialmente funciona para Omnicanalidad y Telemetria
                         */
                        /*else if(insCata.RequiereAgrupacionPlanes__c == true){
                            blnModalPlanes = true;
                            strProductId = insCata.id;
                        }*/
                        else if(insPlanes.RequiereAtributos__c == true){
                            crearSVAyXA(newOpeCom.id, insPlanes.id);
                            blnRender = true;
                        }else{
                            //  p = new PageReference('/'+newActivoETB.Id);
                            /**
                            *   v1.3 -1
                            *   Se cambia la referencia a la que apunta la creación
                            **/
                            p = new Pagereference('/' + strIdOc + '/e?retURL=%2F' + strIdOpp+saveURL);
                        }
                    }   
                    else if(strIdActivo!=null){
                        if(intCantidad>1){
                            p = new PageReference('/'+insAct.Oportunidad__c);
                        }
                        else{
                            //  p = new PageReference('/'+strIdActivo);
                            /**
                            *   v1.3 -1
                            *   Se cambia la referencia a la que apunta la creación
                            **/
                            p = new Pagereference('/' + strIdOc + '/e?retURL=%2F' + strIdActivo+saveURL);
                            
                            /**
                            *   v1.4
                            *   Se agrega la referencia cuando se da una 
                            *   Oportunidad asociada a un Activo existente previamente 
                            **/
                            
                            if (blnOpcActExistente) { p = new PageReference('/' + strIdOc + '/e?retURL=%2F' + idOppActExistente+saveURL);}
                        }
                    }                
                    return p;                
                }
                catch(exception e){
                    Database.rollback(svP);
                    /* BEGIN - Manuel Medina - Debug para tener mayor visibilidad de las posibles excepciones generadas - 09112015 */
                    System.debug( '\n\n\t<<<<<<<<< ExceptionType >>>>>>>>> \n\t\t@@--> getCause > ' + e.getCause() + '\n\t\t@@--> getLineNumber > ' + e.getLineNumber() + '\n\t\t@@--> getMessage > '+ e.getMessage() + '\n\t\t@@--> getStackTraceString > '+ e.getStackTraceString() + '\n\t\t@@--> getTypeName > ' + e.getTypeName() + '\n\n' );
                    /* END - Manuel Medina - Debug para tener mayor visibilidad de las posibles excepciones generadas - 09112015 */
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                    return null;
                }
            } // End if
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strErrorCamposObli));  
            }
            System.debug('entró por else!!!!'); 
        }                
        return null;
    }
    
    public TOPP__c BuscarTopp(string idTopp){
        list<TOPP__c> lstT = new list<TOPP__c>();
        
        if(idTopp!=null && idTopp!=''){
            lstT=[select id, Name, TipodeRegistro__c, Valorunicavez__c, ValorTarifaPlan__c, RequiereAnchodeBanda__c, TipodeOperacionporplan__c
                    from TOPP__c
                    where id=:idTopp
                    ];
            if(lstT.size()>0){
                return lstT[0];
            }
        }
        
        return null;
    }
    
    public string BuscarTipoRegistro(TOPP__c inTopp){        
        list<RecordType> lstRT = new list<RecordType>();    
                
        if(inTopp!=null){
            lstRT = [select id
                        from RecordType
                        where DeveloperName=:inTopp.Tipoderegistro__c
                        and sObjectType='OperacionComercial__c'];
                        
            if(lstRT.size()>0){
                return lstRT[0].id;
            }
        }   
        return null;
    }    
    public pageReference Refresco1(){
                           
       system.debug('==>DEBUG:inicio Refresco1=0'); 
        CargarProd2(); 
        system.debug('==>DEBUG:inicio Refresco1=1'); 
        if(lstFamilia.size()>0){
            system.debug('==>DEBUG:inicio Refresco1=2'); 
            strInFamilia=lstFamilia[0].getValue();
            Refresco2();
        }    
        
        
        return null;
    }
    
    public pageReference Refresco2(){        
        CargarProd3();
        system.debug('==>DEBUG:inicio Refresco2=1'); 
        if(lstProducto.size()>0){
            system.debug('==>DEBUG:inicio Refresco2=2'); 
            strInProducto=lstProducto[0].getValue();
            Refresco3();
        }

        return null;
    }
    
    public pageReference Refresco3(){        
        CargarProd4();
        Refresco4();
        return null;
    }
    
    public pageReference Refresco4(){
        CargarPlanes();
        if(lstPlanes.size()>0){
            system.debug('==>DEBUG:inicio Refresco4=1'); 
            strInPlan=lstPlanes[0].getValue();
            Refresco5();
        }
        return null;
    }
    public pageReference Refresco5(){
       system.debug('==>DEBUG:inicio Refresco5=1'); 
        
        if(DesdeUnActivo(strIdActivo)){
            CargarPlanesAuto();
        }else{
            CargarPlanes2();
        }
        CargarOperaciones();
        if(lstOperaciones.size()>0){
            strInOperacion=lstOperaciones[0].getValue();            
            Refresco6();
        }
        return null;
    }
    
    public pageReference Refresco6(){        
        system.debug('==>DEBUG:inicio Refresco6=1');
        CargarDetallesDelTOPP();
        validarLD();       
        CargarAnchoBanda();
        return null;
    }

    private String obtenerUrl(Map<string,string> datos){
        //HB Flujos
        string saveURL='';        
        TOPP__c toppInfo=[Select Id,TipodeOperacionporplan__c,Plan__r.Name From TOPP__c Where Id=:datos.get('topp')];
        
        Map<String,Flujos_Visual_Force__c> flujos = Flujos_Visual_Force__c.getall();

        //Nombre Largo
        Map<String,Flujos_Visual_Force__c> nombreLargo=new Map<String,Flujos_Visual_Force__c>();
        for(String s:flujos.keySet()){
            nombreLargo.put(flujos.get(s).NombreLargo__c,flujos.get(s));
        }



        String llave=LibreriaUtilitaria_cls.quitarCaracteresEsp(toppInfo.Plan__r.Name+toppInfo.TipodeOperacionporplan__c).deleteWhitespace();
        system.debug('llave:'+llave);
        
        if(nombreLargo.get(llave)!=null){
            saveURL='&'+LibreriaUtilitaria_cls.urlFlujos(datos,nombreLargo.get(llave).UrlVisualforce__c);
        }


        return saveURL;

    }

    public boolean esPlanLD{get;set;}
    public string pLD{get;set;}

    private void validarLD(){

        set<String> productosLD=new set<String>(VariablesGlobales__c.getInstance('ProductoLD').Valor__c.split(','));
        set<String> planesLD=new set<String>(VariablesGlobales__c.getInstance('ProductoLD').Valor02__c.split(','));
        
        //Valida el producto y el topp;
        if(productosLD.contains(strInProducto) && validarToopLD(planesLD)){
            system.debug('MuestraPlanes');
            esPlanLD=true;
        }else{
            esPlanLD=false;
        }
    }
    private boolean validarToopLD(set<String> ventaPlanLD){

        system.debug(ventaPlanLD+' '+ventaPlanLD);
        list<TOPP__c> tLd=new list<TOPP__c>([Select id from TOPP__c where id=:strInOperacion and TipodeOperacionporplan__c IN :ventaPlanLD]);

        return (tLd.isEmpty()?false:true);
    }   

    public  List<SelectOption> getPlanesLD(){

        list<PlanLD__c> pLDs=new list<PlanLD__c>([Select Id,Name From PlanLD__c where  (ClienteRelacionado__c=null Or ClienteRelacionado__c=:strIdAccount) and Plan__c=:strInPlan and name!='Plan Mundo' and Inactivo__c != true]);
        List<SelectOption> optPlanLD=new List<SelectOption>();

        
        for(PlanLD__c opl:pLDs){
            optPlanLD.add(new SelectOption(opl.id,opl.Name));
        }        
        return optPlanLD;
    }
    /************ [2017-04-02 Fernando Sarasty (FS)] Generación de OC de cambio de PLAN sobre AC principal de una Troncal SIP********/   
    public void creaOCCambioPlanACPrincipal(string strIdActivo, string strIdOc)
    {	
        lstTOPP      = [select id from TOPP__c where Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)' and  LTE_Parte_caso__c = true];        
        lstActETBAux = [select Plan__r.Name, CuentaFacturacion__r.LTE_CicloFacturacion__c,
                        Activo_Relacionado__r.Plan__r.Id, Activo_Relacionado__r.NombredelaCuenta__r.Id,
                        Activo_Relacionado__r.Id, Activo_Relacionado__r.NumeroConexion__c, Activo_Relacionado__r.LTE_DetalleOferta__r.LTE_Valor_Total_Plan__c,
                        Activo_Relacionado__r.CuentaFacturacion__r.Id, Activo_Relacionado__r.CuentaFacturacion__r.LTE_CicloFacturacion__c
                        from ActivoETB__c
                        where Id = :strIdActivo];
        
        if(lstTOPP.size()>0){
        	if(buscarOCCambioPlan(lstTOPP[0].id, lstActETBAux[0].Activo_Relacionado__r.CuentaFacturacion__r.Id) == null)
            {            
                if(lstActETBAux[0].Plan__r.Name == System.Label.Nombre_Plan_Troncal_SIP_Alterna)
                {                
                    List<Equipo__c> lstEquipos = new List<Equipo__c>();
                    List<RecordType> lstRecordType = new list<RecordType>();            
                    List<SubPlanFacturacion__c> lstSubPlan = new list<SubPlanFacturacion__c>();   
                    LTE_DetalleOferta__c objDetalleOferta;
                    LTE_Servicios_adicionales__c objSAPlan;
                    LTE_Servicios_adicionales__c objSADatos;
                    vGlobal = VariablesGlobales__c.getAll();
                    Viabilidad__c objViabilidad;
                    Decimal dcmValorTotal = 0;
                    Integer intCicloFacturacion;
                    Date fechaCorte;
                    String cicloFact; 
                    Savepoint sp = Database.setSavepoint();  
                    lstEquipos    = [select Id from Equipo__c where name = 'Equipo Traido'];
                    lstRecordType = [select id from RecordType where Name = 'Tramites LTE'];            
                    lstSubPlan    = [select id, Name from SubPlanFacturacion__c where name = 'Troncal SIP Canales'];
                    system.debug('--> Resultado consultas: '+lstEquipos+'-'+lstRecordType+'-'+lstTOPP+'-'+lstSubPlan);                
                    if(lstRecordType.isEmpty()){
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado));
                    }else{
                        try{
                            cicloFact = lstActETBAux[0].Activo_Relacionado__r.CuentaFacturacion__r.LTE_CicloFacturacion__c;
                            intCicloFacturacion = Integer.valueOf(cicloFact);
                            System.Debug('=========> El ciclo de facturacion es: '+intCicloFacturacion);
                        } catch(Exception e){
                            intCicloFacturacion = -1;
                            System.Debug('=========> ERROR PARSEANDO CICLO DE FACTURACION: ' + e.getMessage());
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Servicio_Sin_Cuenta_Facturacion));
                        }
                        if(intCicloFacturacion == -1){
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Servicio_Sin_Cuenta_Facturacion));
                        }
                        else{
                            fechaCorte = obtenerFechaCorte(intCicloFacturacion);
                            if(fechaCorte == null){
                                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Fecha_Corte_No_Calculada));                      
                            }else{
                                try{                            
                                    // Crear una oferta económica
                                    objOfertaEconomica = new Reserva__c();
                                    objOfertaEconomica.LTE_TipodePlan__c = 'Troncal SIP'; 
                                    objOfertaEconomica.Equipo__c = (lstEquipos.size()>0 ? lstEquipos.get(0).id : 'Equipo Traido');
                                    objOfertaEconomica.LTE_EsPosventa__c = true;
                                    objOfertaEconomica.LTE_Plan__c = lstActETBAux[0].Activo_Relacionado__r.Plan__r.Id;
                                    insert objOfertaEconomica;
                                    system.debug('--> Fin Creación oferta económica '+objOfertaEconomica.id);
                                    
                                    // Crear operación comercial de cambio de plan sobre el AC principal relacionado a la Troncal SIP Alterna
                                    objOC = new OperacionComercial__c();
                                    objOC.CuentaCliente__c = lstActETBAux[0].Activo_Relacionado__r.NombredelaCuenta__r.Id;
                                    objOC.Activo__c = lstActETBAux[0].Activo_Relacionado__r.Id;
                                    objOC.NumeroConexion__c = lstActETBAux[0].Activo_Relacionado__r.NumeroConexion__c;
                                    objOC.Plan__c = lstActETBAux[0].Activo_Relacionado__r.Plan__r.Id;
                                    objOC.TOPP__c = (lstTOPP.size()>0 ? lstTOPP[0].id : null);
                                    objOC.PlanAnterior__c = lstActETBAux[0].Activo_Relacionado__r.Plan__r.Id;
                                    objOC.Estado__c = 'Pendiente';                                
                                    objOC.RecordTypeId = (lstRecordType.size()>0 ? lstRecordType[0].id : null);                                
                                    objOC.Valor_Recurrente_ETB_Anterior__c = lstActETBAux[0].Activo_Relacionado__r.LTE_DetalleOferta__r.LTE_Valor_Total_Plan__c;
                                    objOC.ValorTarifaPlan__c = dcmValorTotal;
                                    objOC.CuentaFacturacion__c = lstActETBAux[0].Activo_Relacionado__r.CuentaFacturacion__r.Id;
                                    objOC.FechaInicioReconexion__c = fechaCorte;
                                    objOC.Operacion_Comercial_Relacionada__c = strIdOc;
                                    
                                    insert objOC;       
                                    system.debug('--> Fin Creación operación comercial '+objOC.id);
                                    
                                    // Crear detalle de la oferta
                                    objDetalleOferta = new LTE_DetalleOferta__c();
                                    objDetalleOferta.LTE_OperacionComercial__c = objOC.Id;
                                    objDetalleOferta.Plan__c = lstActETBAux[0].Activo_Relacionado__r.Plan__r.Id;
                                    objDetalleOferta.LTE_TipodePlan__c = 'Troncal SIP';
                                    objDetalleOferta.LTE_DatosNavegacion__c =  (lstSubPlan.size()>0 ? lstSubPlan[0].id : null);
                                    objDetalleOferta.LTE_Oferta_Economica__c = objOfertaEconomica.Id;
                                    objDetalleOferta.LTE_Cliente__c = lstActETBAux[0].Activo_Relacionado__r.NombredelaCuenta__r.Id;
                                    objDetalleOferta.LTE_NumeroLinea__c = lstActETBAux[0].Activo_Relacionado__r.NumeroConexion__c;
                                    objDetalleOferta.LTE_EquipoTraido__c = true;
                                    objDetalleOferta.LTE_Valor_Total_Plan__c = dcmValorTotal;
                                    insert objDetalleOferta;
                                    system.debug('--> Fin Creación detalle de oferta '+objDetalleOferta.id);
                                    
                                    // Crear servicio adicional plan
                                    objSAPlan = new LTE_Servicios_adicionales__c();
                                    objSAPlan.Name = obtenerPlanFacturacionName(objDetalleOferta.Plan__c,'Name');
                                    objSAPlan.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
                                    objSAPlan.LTE_PlanFacturacion__c = obtenerPlanFacturacionId(objDetalleOferta.Plan__c);
                                    objSAPlan.LTE_NetworkIndicator__c = 'false';
                                    objSAPlan.LTE_ServiceIndicator__c = 'false';
                                    objSAPlan.LTE_TypeCode__c = 'PRODUCT';                                
                                    objSAPlan.LTE_PrimaryClassificationCode__c = obtenerPlanFacturacionName(objDetalleOferta.Plan__c,'LTE_PrimaryClassificationCode__c');
                                    insert objSAPlan;
                                    system.debug('--> Fin Creación servicio adicional del plan '+objSAPlan.id);
                                    
                                    // Crear servicio adicional datos
                                    objSADatos = new LTE_Servicios_adicionales__c();
                                    objSADatos.Name = (lstSubPlan.size()>0 ? lstSubPlan[0].Name : lstActETBAux[0].Activo_Relacionado__r.Plan__r.Id);
                                    objSADatos.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
                                    objSADatos.LTE_SubPlaFacturacion__c = (lstSubPlan.size()>0 ? lstSubPlan[0].id : lstActETBAux[0].Activo_Relacionado__r.Plan__r.Id);
                                    objSADatos.LTE_NetworkIndicator__c = 'false';
                                    objSADatos.LTE_ServiceIndicator__c = 'false';
                                    objSADatos.LTE_TypeCode__c = 'PRODUCT';   
                                    objSADatos.LTE_PrimaryClassificationCode__c = obtenerSubPlanFacturacionName(lstSubPlan[0].id,'LTE_PrimaryClassificationCode__c');
                                    insert objSADatos;  
                                    system.debug('--> Fin Creación servicio adicional de datos '+objSADatos.id);
                                    
                                    // Parametrizar Servicios adicionales y  generar XA's
                                    LTE_CrearParametrizacionPostVenta_cls clasParam = new LTE_CrearParametrizacionPostVenta_cls();
                                    set<Id> setIdOcs = new set<Id>();
                                    
                                    setIdOcs.add(objOC.Id);                                                               
                                    LTE_CrearParametrizacionPostVenta_cls.servAdicSpcGrXA wrData= clasParam.initCambioDeplan(setIdOcs,'OC');
                                    
                                    // Actualizar servicios adicionales
                                    update wrData.servAD;   
                                    
                                    // Insertar XA's
                                    insert wrData.SpgXA;  
                                    system.debug('--> Fin creación XAs '+wrData);
                                    
                                }catch(Exception e){
                                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error General' + ': ' + e.getMessage()));
                                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getStackTraceString()));
                                    Database.rollback(sp);
                                    System.Debug('====================== EXCEPCION ======================');
                                    System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                                    System.Debug('=======================================================');
                                }   
                            }
                        }
                    }   
                }        
            }
        }
    }
    
    public Date obtenerFechaCorte(Integer intCicloFacturacion){
        Date fechaCorteFinal;
        Date fechaCorteInicial;
        Date fechaHoy = system.today();
        if(intCicloFacturacion == -1){
            return null;
        } else{
            if(intCicloFacturacion != null){
                fechaCorteFinal=null;                
                // Fecha de corte incial
                Integer aniocorteInicial    =   fechaHoy.year();
                Integer mesCorteInicial     =   fechaHoy.month();
                Integer diaCorteInicial     =   intCicloFacturacion;                
                fechaCorteInicial           =   Date.newInstance(aniocorteInicial, mesCorteInicial, diaCorteInicial);
                
                if(fechaHoy  < fechaCorteInicial){
                    fechaCorteFinal= fechaCorteInicial;
                }else{
                    fechaCorteFinal = fechaCorteInicial.addMonths(1);
                }
            }else{
                fechaCorteFinal=null;
            }            
            return fechaCorteFinal;
        }
    }
    public Id obtenerPlanFacturacionId(Id planId){        
        lstPlanFacturacion = [SELECT Id, Name, Plan__c FROM PlanFacturacion__c WHERE Plan__c =: planId LIMIT 1];
        if(!lstPlanFacturacion.isEmpty())
            return lstPlanFacturacion[0].Id;                                
        else return null;        
    }
    
    public String obtenerPlanFacturacionName(Id planId, String campo){
        lstPlanFacturacion = [SELECT Id, Name, Plan__c, LTE_PrimaryClassificationCode__c FROM PlanFacturacion__c WHERE Plan__c =: planId LIMIT 1];
        if(!lstPlanFacturacion.isEmpty()){        
            if(campo == 'Name')
                return lstPlanFacturacion[0].Name;
            else
                return lstPlanFacturacion[0].LTE_PrimaryClassificationCode__c;                
        }else return null;        
    }
    public String obtenerSubPlanFacturacionName(Id planId, String campo)
    {
        if(planId != null)
        {
            lstSubPlanFacturacion = [SELECT Id, Name, LTE_PrimaryClassificationCode__c FROM SubPlanFacturacion__c WHERE Id =: planId LIMIT 1];
            if(!lstSubPlanFacturacion.isEmpty()){                                    
                if(campo == 'Name')
                    return lstSubPlanFacturacion[0].Name;
                else
                    return lstSubPlanFacturacion[0].LTE_PrimaryClassificationCode__c;                    
            }else return null;
        }else return null;
    }
    public String buscarOCCambioPlan(Id IdTOPP, Id IdCtaFact)
    {           
        if(IdTOPP != null &&  IdCtaFact != null)
        {			      
            lstOCCambioPlan = [select Id, TOPP__c, CuentaFacturacion__c from OperacionComercial__c  where Estado__c = 'Pendiente' and Operacion_Comercial_Relacionada__c != null AND TOPP__c=:IdTOPP AND CuentaFacturacion__c =: IdCtaFact LIMIT 1];
            if(!lstOCCambioPlan.isEmpty()){                                
               System.debug('--> OC de cambio de plan existente: '+lstOCCambioPlan[0].Id);
               return lstOCCambioPlan[0].Id;      
            }else return null;            
        }else return null;        
    }
    /************ FIN [2017-04-02 Fernando Sarasty (FS)] Generación de OC de cambio de PLAN sobre AC principal de una Troncal SIP********/   
    
    public static Viabilidad__c consultarViabilidad(String idOp)
    {
        try{
			Viabilidad__c ObjVia = new Viabilidad__c();
        	ObjVia = [SELECT Id FROM Viabilidad__c WHERE Oportunidad__c =: IdOp ORDER BY CreatedDate DESC NULLS FIRST LIMIT 1];        
            return ObjVia;
        }catch(exception e){
        	return null;
        }
    }
    
    public void CargarDetallesDelTOPP(){                
        list<TOPP__c> lstDetalleAux = new list<TOPP__c>();
        list<string> lstDetallesSplit = new list<string>();
        lstDetalle 		 = new list<Selectoption>();
        lstDetallesSplit = new list<string>();        
        lstDetalleAux = [ select id, Name, TipodeOperacionporplan__c, Detalle_del_tramite__c
                      	  from TOPP__c
                      	  where Id =: strInOperacion ];
        
        if(lstDetalleAux.size()>0){
            if(lstDetalleAux[0].Detalle_del_tramite__c!='' && lstDetalleAux[0].Detalle_del_tramite__c != null){
                lstDetallesSplit = lstDetalleAux[0].Detalle_del_tramite__c.split(';');
                if(lstDetallesSplit.size()>0){
                    for(String splitDetalle : lstDetallesSplit){
                        lstDetalle.add(new SelectOption(splitDetalle, splitDetalle));
                    }
                }
            }
            List<String> lstHGPerfil = new List<String>();
            system.debug('strNombrePerfil'+strNombrePerfil);
            system.debug('strNombreUsuario'+strNombreUsuario);
            lstHGPerfil.add(strNombrePerfil+'|'+lstDetalleAux[0].TipodeOperacionporplan__c);
            lstHGPerfil.add(strNombreUsuario+'|'+lstDetalleAux[0].TipodeOperacionporplan__c);
            lstHGPerfil.add('|TODOS');
            lstHGPerfil.add('|TODOS');
            system.debug(lstHGPerfil);
            List<Homologacion_Gestor__mdt> lstHG = [SELECT Id,Valor_Usuario__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = 'DETALLE_TRAMITE_PERFIL' AND Valor_API__c IN :lstHGPerfil];
            for(Homologacion_Gestor__mdt sglHG:lstHG){
                lstDetalle.add(new SelectOption(sglHG.Valor_Usuario__c, sglHG.Valor_Usuario__c));
            }
            if(!lstDetalle.isEmpty())
                lstDetalle.sort();
            
            strTipodeOperacionporplan = lstDetalleAux[0].TipodeOperacionporplan__c;
            system.debug('CargarDetallesDelTOPP ' + strTipodeOperacionporplan);
        }
    }
    public Boolean verificaPostVentaNIP(string strIdOperacion){
        list<TOPP__c> lstTOPP = new list<TOPP__c>();
        lstTOPP		   = [select Tipoderegistro__c, Plan__r.NombredelProducto__r.Name
                      	  from TOPP__c
                      	  where Id =: strIdOperacion];
        
        if(lstTOPP.size()>0){            
            if(lstTOPP[0].Tipoderegistro__c != 'Venta_NIP' && lstTOPP[0].Plan__r.NombredelProducto__r.Name == 'NIP')
                return true;
            else
                return false;
        }
        return false;
    }
    public void relacionarActivosNIPaOC(string strIdParentAsset, string strIdOCNIP){
        list<ActivoETB__c> lstParentAsset = new list<ActivoETB__c>();
        lstParentAsset = [Select Id, Operaci_n_Comercial_tramite_NIP__c FROM ActivoETB__c WHERE Activo_Relacionado__c =: strIdParentAsset];
        
        if(lstParentAsset.size()>0){
            for(ActivoETB__c Activo_Aux: lstParentAsset){
                Activo_Aux.Operaci_n_Comercial_tramite_NIP__c = strIdOCNIP;                
            }
            update lstParentAsset;
        }
    } 
    public Boolean validacionesSDWAN(string idCuentaCliente, string idProducto, string accion){
        Boolean result = true;
        List<String> lstProductos 	= Label.SDWAN_Productos_relacionados.split(',');
        
        if(accion == 'validaciones'){
            list<ActivoETB__c> 			lstActivo    	= new list<ActivoETB__c>();            
            list<CatalogoProductos__c>  lstProduct 	 	= new list<CatalogoProductos__c>();           
            
            lstProduct = [Select Id From CatalogoProductos__c Where Id=:idProducto AND Name=:Label.SDWAN_Nombre_Producto];
            if(lstProduct.size() > 0 ){
                if(strIdOpp != null){
                    lstActivo = [Select Id From ActivoETB__c 
                                 Where Plan__r.NombredelProducto__r.Name IN: lstProductos AND
                                 (NombredelaCuenta__r.Id =: idCuentaCliente) AND Oportunidad__r.Id =: strIdOpp];
                    
                    if(lstActivo.size()>0)
                        result = true;
                    else
                        result = false;
                }
                if(!result){
                    lstActivo = [Select Id From ActivoETB__c 
                                 Where Plan__r.NombredelProducto__r.Name IN: lstProductos AND
                                (Estado__c = 'Activo' AND NombredelaCuenta__r.Id =: idCuentaCliente)]; 
                    
                    if(lstActivo.size() > 0)
                        result = true;
                    else
                        result = false;
                }    
            }else         	
                result = true;          
        } 
        if(accion == 'relacionarOCs'){
            string IdOCSDWAN;
            List<OperacionComercial__c> lstOcUpdate = new List<OperacionComercial__c>();
            if(strIdOpp != null){                
                list<OperacionComercial__c>  lstOCsdWAN  = new list<OperacionComercial__c>([Select Id From OperacionComercial__c Where Oportunidad__r.Id =: strIdOpp AND Plan__r.NombredelProducto__r.Name =: Label.SDWAN_Nombre_Producto]);
                if(lstOCsdWAN.size() > 0){
                    IdOCSDWAN = lstOCsdWAN[0].Id;                    
                    if(IdOCSDWAN != ''){
                        list<OperacionComercial__c>  lstOCenlaces  = new list<OperacionComercial__c>([Select Id, Operacion_Comercial_Relacionada__c From OperacionComercial__c Where Oportunidad__r.Id =: strIdOpp AND Operacion_Comercial_Relacionada__c = NULL AND Id !=: IdOCSDWAN AND Plan__r.NombredelProducto__r.Name IN: lstProductos]);
                        if(lstOCenlaces.size() > 0){
                            for(OperacionComercial__c objOCenlaces : lstOCenlaces){                                
                                objOCenlaces.Operacion_Comercial_Relacionada__c = IdOCSDWAN;
                                lstOcUpdate.add(objOCenlaces);
                            }
                        }
                    }
                }                
            }
            if(lstOcUpdate.size() > 0)
                update lstOcUpdate;
        }
        return result;
    }
    
    
    /**
    * metodo que valida si el producto negocio seguro tiene definido un servicio principal 
    * @author omar.de.moreno.avila@accenture.com | 04-13-2022 
    * @param idCuentaCliente 
    * @param idProducto 
    * @param accion 
    * @return Boolean 
    **/
    /*public Boolean validacionesNegocioSeguro(string idCuentaCliente, string idProducto, string accion){
        Boolean result = true;
        List<String> lstProductos 	= Label.Negocio_Seguro_Productos_relacionados.split(',');
        
        if(accion == 'validaciones'){
            list<ActivoETB__c> 			lstActivo    	= new list<ActivoETB__c>();            
            list<CatalogoProductos__c>  lstProduct 	 	= new list<CatalogoProductos__c>();           
            
            lstProduct = [Select Id From CatalogoProductos__c Where Id=:idProducto AND Name=:Label.Negocio_Seguro_Nombre_Producto];
            if(lstProduct.size() > 0 ){
                if(strIdOpp != null){
                    lstActivo = [Select Id From ActivoETB__c 
                                 Where Plan__r.NombredelProducto__r.Name IN: lstProductos AND
                                 (NombredelaCuenta__r.Id =: idCuentaCliente) AND Oportunidad__r.Id =: strIdOpp];
                    
                    if(lstActivo.size()>0)
                        result = true;
                    else
                        result = false;
                }
                if(!result){
                    lstActivo = [Select Id From ActivoETB__c 
                                 Where Plan__r.NombredelProducto__r.Name IN: lstProductos AND
                                (Estado__c = 'Activo' AND NombredelaCuenta__r.Id =: idCuentaCliente)]; 
                    
                    if(lstActivo.size() > 0)
                        result = true;
                    else
                        result = false;
                }    
            }else         	
                result = true;          
        } 
        // if(accion == 'relacionarOCs'){
        //     string IdOCSDWAN;
        //     List<OperacionComercial__c> lstOcUpdate = new List<OperacionComercial__c>();
        //     if(strIdOpp != null){                
        //         list<OperacionComercial__c>  lstOCsdWAN  = new list<OperacionComercial__c>([Select Id From OperacionComercial__c Where Oportunidad__r.Id =: strIdOpp AND Plan__r.NombredelProducto__r.Name =: Label.SDWAN_Nombre_Producto]);
        //         if(lstOCsdWAN.size() > 0){
        //             IdOCSDWAN = lstOCsdWAN[0].Id;                    
        //             if(IdOCSDWAN != ''){
        //                 list<OperacionComercial__c>  lstOCenlaces  = new list<OperacionComercial__c>([Select Id, Operacion_Comercial_Relacionada__c From OperacionComercial__c Where Oportunidad__r.Id =: strIdOpp AND Operacion_Comercial_Relacionada__c = NULL AND Id !=: IdOCSDWAN AND Plan__r.NombredelProducto__r.Name IN: lstProductos]);
        //                 if(lstOCenlaces.size() > 0){
        //                     for(OperacionComercial__c objOCenlaces : lstOCenlaces){                                
        //                         objOCenlaces.Operacion_Comercial_Relacionada__c = IdOCSDWAN;
        //                         lstOcUpdate.add(objOCenlaces);
        //                     }
        //                 }
        //             }
        //         }                
        //     }
        //     if(lstOcUpdate.size() > 0)
        //         update lstOcUpdate;
        // }
        return result;
    }*/

    public void clonarSVA(id ocId, id idAct){
        System.debug(' idAct '+idAct);

        List<LTE_Servicios_adicionales__c> lstSVA = [SELECT id, Name, LTE_PlanFacturacion__c 
                                                     FROM LTE_Servicios_adicionales__c WHERE LTE_ServicioETB__c = :idAct];

        List<LTE_SpecificationGroupXA__c> lstXA = [SELECT id, Name, LTE_ServiciosAdicionales__r.Name, LTE_Value__c, LTE_ParametroFacturacion__c 
                                                   FROM LTE_SpecificationGroupXA__c WHERE LTE_ServiciosAdicionales__c IN :lstSVA];
        System.debug(' LstSVA '+lstSVA);
        if(!lstSVA.isEmpty()){
            List<LTE_SpecificationGroupXA__c> lstXAClone = new List<LTE_SpecificationGroupXA__c>();
            for(LTE_SpecificationGroupXA__c sglXA:lstXA){
                LTE_SpecificationGroupXA__c XAclone = sglXA.clone(false,false,false,false);
                XAclone.Name = sglXA.Name;
                XAclone.LTE_Value__c = sglXA.LTE_Value__c;
                XAclone.LTE_ParametroFacturacion__c = sglXA.LTE_ParametroFacturacion__c;
                lstXAClone.add(XAclone);
            }
            
            List<LTE_Servicios_adicionales__c> lstSVAclone = new List<LTE_Servicios_adicionales__c>();
            for(LTE_Servicios_adicionales__c sglSVA:lstSVA){
                LTE_Servicios_adicionales__c SVAclone = sglSVA.clone(false,false,false,false);
                SVAclone.Name = sglSVA.Name;
                SVAclone.LTE_ServicioETB__c = null;
                SVAclone.LTE_OC_Tramite__c = ocId;
                SVAclone.LTE_PlanFacturacion__c = sglSVA.LTE_PlanFacturacion__c;
                SVAclone.RecordTypeId = Schema.SObjectType.LTE_Servicios_adicionales__c.getRecordTypeInfosByName().get('Empaquetamiento').getRecordTypeId();
                lstSVAclone.add(SVAclone);
            }
            insert lstSVAclone;
            
            for(LTE_Servicios_adicionales__c sglSVA:lstSVAclone){
                for(LTE_SpecificationGroupXA__c sglXA:lstXAClone){
                    if(sglXA.LTE_ServiciosAdicionales__r.Name == sglSVA.Name){
                        sglXA.LTE_ServiciosAdicionales__c = sglSVA.id;
                    }    
                }
            }     
            insert lstXAClone;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String,List<LTE_SpecificationGroupXA__c>> getMapSVAyXA(id ocId){

        System.debug('ocId '+ocId);
        Map<String,List<LTE_SpecificationGroupXA__c>> mapSVA = new Map<String,List<LTE_SpecificationGroupXA__c>>();
        List<LTE_Servicios_adicionales__c> lstSVA = [SELECT ID, Name, LTE_PlanFacturacion__r.Tipo_agrupador__c                  
                                                     FROM LTE_Servicios_adicionales__c WHERE LTE_OC_Tramite__c = :ocId AND LTE_PlanFacturacion__r.Tipo_agrupador__c = 'Usuario'];
        List<LTE_SpecificationGroupXA__c> lstXA = [SELECT ID, Name, LTE_Value__c, LTE_ServiciosAdicionales__c, LTE_ServiciosAdicionales__r.LTE_OC_Tramite__c, LTE_ParametroFacturacion__r.Obligatorio__c,
                                                   LTE_ParametroFacturacion__r.Tipo_de_Campo__c, LTE_ParametroFacturacion__r.OpcionesPicklist__c // N-00865-HU Producto Cobro Revertido Automático en Salesforce Miguel. R Gómez 06/01/2022
                                                   FROM LTE_SpecificationGroupXA__c WHERE LTE_ServiciosAdicionales__r.LTE_OC_Tramite__c  = :ocId];
        for(LTE_Servicios_adicionales__c sglSVA:lstSVA){
            List<LTE_SpecificationGroupXA__c> lstXAs = new List<LTE_SpecificationGroupXA__c>();
            for(LTE_SpecificationGroupXA__c sglXA:lstXA){
                if(sglXA.LTE_ServiciosAdicionales__c == sglSVA.id){
                    lstXAs.add(sglXA);
                }
            }
            mapSVA.put(sglSVA.Name,lstXAs);
        }
        
        return mapSVA;
    }
    
    @AuraEnabled(cacheable=false)
    public static void updateXA(Map<String,List<LTE_SpecificationGroupXA__c>> mapXA){
        List<LTE_SpecificationGroupXA__c> lstXA = new List<LTE_SpecificationGroupXA__c>();
        for(String sglSVA:mapXA.keySet()){
            for(LTE_SpecificationGroupXA__c sglXA:mapXA.get(sglSVA)){
                lstXA.add(sglXA);
            }
        }
        Database.update(lstXA,false);
    }
    
    
    public void crearSVAyXA(id ocId, id idPlan){
        Map<id, PlanFacturacion__c> mapPlanFac = new Map<id, PlanFacturacion__c>([SELECT id, Name, Tipo_agrupador__c, (SELECT id, Name, LTE_ValorDefecto__c, PlanFacturacion__r.Name, Tipo_de_Campo__c
                                                  FROM Parametros_de_Facturacion__r) 
                                           	FROM PlanFacturacion__c WHERE Plan__c = :idPlan AND Tipo_agrupador__c = 'Usuario' ]);
        
        List<LTE_Servicios_adicionales__c> lstSVA = new List<LTE_Servicios_adicionales__c>();
        List<LTE_SpecificationGroupXA__c> lstXA = new List<LTE_SpecificationGroupXA__c>();
        
        for(PlanFacturacion__c sglPlanFac : mapPlanFac.values()){
            LTE_Servicios_adicionales__c newSVA = new LTE_Servicios_adicionales__c();
            newSVA.Name = sglPlanFac.Name;
            newSVA.Plan__c = null;
            newSVA.LTE_OC_Tramite__c = ocId;
            newSVA.RecordTypeId = Schema.SObjectType.LTE_Servicios_adicionales__c.getRecordTypeInfosByName().get('Empaquetamiento').getRecordTypeId(); 
            newSVA.LTE_PlanFacturacion__c = sglPlanFac.id;
            newSVA.LTE_ItemIdentification__c = sglPlanFac.id;
            lstSVA.add(newSVA);
            for(ParametroFacturacion__c sglParam: sglPlanFac.Parametros_de_Facturacion__r){
                LTE_SpecificationGroupXA__c newXA = new LTE_SpecificationGroupXA__c();
                newXA.Name = sglParam.Name;
                newXA.LTE_Value__c = sglParam.LTE_ValorDefecto__c;
                newXA.LTE_ParametroFacturacion__c = sglParam.id;
                newXA.ApiName__c = sglPlanFac.id;
                newXA.Tipo_de_Campo__c = sglParam.Tipo_de_Campo__c;
                lstXA.add(newXA);
            }
        }
        insert lstSVA;  
        for(LTE_Servicios_adicionales__c sglSVA:lstSVA){
            for(LTE_SpecificationGroupXA__c sglXA:lstXA){
                if(sglXA.ApiName__c == sglSVA.LTE_ItemIdentification__c){
                    sglXA.LTE_ServiciosAdicionales__c = sglSVA.id;
                    sglXA.ApiName__c = null;
                }    
            }
            sglSVA.LTE_ItemIdentification__c = null;
        } 
        update lstSVA;
        insert lstXA;
    }
    
    //Metodo nuevo para la VF page ModificarAtributos_pag
    public pageReference IniciaModificarAtributos(){
        if(ApexPages.currentPage().getParameters().containskey('id')){
            idObjeto=ApexPages.currentPage().getParameters().get('id');

        }
        return null;
    }

    /**
    * @description Se obtiene el id de la OC de venta facturada de ese activo para asignarselo 
    
    * @author Miguel R. Gómez  miguel.rafael.gomez@accenture.com | 03-25-2022 
    * @param activo 
    **/
    public String obtenerOCRelacionadaNIP(OperacionComercial__c operacionComercial)
    {
        List<TOPP__c> topp = [SELECT Id, Nombre_del_Producto__c FROM TOPP__c WHERE Id = : operacionComercial.TOPP__c LIMIT 1];

        System.debug('operacionComercial.TOPP__c + '+operacionComercial.TOPP__c);
        System.debug('operacionComercial.Activo__c + '+operacionComercial.Activo__c);
        if (!topp.isEmpty() && topp[0].Nombre_del_Producto__c == 'NIP')
        {
            List<OperacionComercial__c> oc = [SELECT Id FROM OperacionComercial__c 
                                            WHERE Activo__c =:operacionComercial.Activo__c AND Estado__c = 'Facturado'
                                            AND TOPP__r.TipodeOperacionporplan__c = 'Venta'
                                            LIMIT 1];

            return oc.isEmpty()?'':oc[0].Id;
        }
        return '';
    }
}