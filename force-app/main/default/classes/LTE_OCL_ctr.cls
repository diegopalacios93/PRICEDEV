/**********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Jorge Grimaldos
Proyecto:           ETB Evolutivos
Descripci?n:        Clase controladora del nuevo desarrollo de manejo de Legalizaciones

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripci?n
----    ----------      --------------------        ---------------
1.0     2015-07-30      Hector Bayona (HB)      Creacion de la clase.
1.0     2015-07-30      Luis Penaranda(LP)      Modificacion crear serv. Adicionales
1.1     2015-09-22      Juan G. Duarte(JD)      Paginacion
1.2     2017-04-02      Fernando Sarasty (FS)   Se incluye codificación para generar una OC de cambio de plan sobre un AC Principal,
                                                cuando se realiza la legalización de una OC de venta de Troncal SIP Alterna. 
                                                Se crean los siguientes métodos: creaOCCambioPlanACPrincipal, obtenerFechaCorte,
                                                obtenerPlanFacturacionId, obtenerPlanFacturacionName, obtenerSubPlanFacturacionName
**********************************************************************************************************************/
public class LTE_OCL_ctr {
    
    public Integer intRecordLimit=500;
    public integer total_size=0; //used to show user the total size of the list
    public OperacionComercial__c objOC   {get; set;} // [2017-04-02 Fernando Sarasty (FS)]
    public Reserva__c objOfertaEconomica {get; set;} // [2017-04-02 Fernando Sarasty (FS)]
    private List<PlanFacturacion__c> lstPlanFacturacion; // [2017-04-02 Fernando Sarasty (FS)]
    private List<SubPlanFacturacion__c> lstSubPlanFacturacion; // [2017-04-02 Fernando Sarasty (FS)]
    private Map<string,VariablesGlobales__c> vGlobal; // [2017-04-02 Fernando Sarasty (FS)]
    List<Opportunity> lstOportunidad = new List<Opportunity>(); // [2017-04-02 Fernando Sarasty (FS)]
    List<CuentaFacturacion__c> lstCtaFact = new List<CuentaFacturacion__c>(); // [2017-04-02 Fernando Sarasty (FS)]
    public String idImgLupa	{get; set;} 
    Integer intOcsDemo;
    Integer intnOcsNoDemo;
    String ocsDemoSinAprobar;
    
    //  Wrapper para las Operaciones Comerciales
    
    public class wrpOc {
        public Boolean check {get; set;}
        public OperacionComercial__c oC {get; set;}
        public wrpOc(OperacionComercial__c o) {
            oC = o;
            check = false;
        }
    }

    //  Wrapper para las Oportunidades

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

    //  Definici?n de Etiquetas

    private string strLabelNoIdContratoActual = Label.OCL_ctr_NoIdContratoActual;
    private string strEstadoViableViabilidad = Label.OCL_ctr_EstadoViableViabilidad;
    private string strLabelNoOCAdquiridas =  Label.OpComLegalizar_NoHayOP;
    private string strLabelNoContratoActual = Label.OCL_ctr_NoContratoActual;

    //  Definici?n de variables

    private Id idContrato;
    private Contract ctcActual;
    private boolean blnRenderBotonCrear;
    private List<OperacionComercial__c> lstOCInteres = new List<OperacionComercial__c>();
    private Map<String, List<OperacionComercial__c>> mapFictOpps = new Map<String, List<OperacionComercial__c>>();
    private Map<String, Set<String>> mapCamposObligatorios = new Map<String, Set<String>>();
    private map<string,Schema.SObjectField> mapCamposOC = new map<string,Schema.SObjectField>();
    private Set<String> setCamposObligatoriosOC = new Set<String>();            
    private Set<String> setCamposQuery = new Set<String>{'id', 'Name', 'RecordType.Name', 'Oportunidad__r.Name', 'Oportunidad__r.OC_de_Cambio_de_Plan_AC_Principal__c', 'Plan__r.Name','TOPP__r.Name', 'TOPP__r.AplicaPreventa__c',' Activo__r.NombredelProducto__c', 'CreatedDate', 'LastModifiedDate','TOPP__r.TipodeOperacionporplan__c','Portacion__c','Portado_con_Cedula__c','LTE_EquipoTraido__c','Activo__r.NombredelaCuenta__r.Id', 'Activo__r.NombredelaCuenta__r.Name', 'Activo__r.NombredelaCuenta__r.Direccion__c','Portacion__c' ,'Activo__r.NombredelaCuenta__r.AccountNumber', 'LTE_Donante__c', 'LTE_SolicitadoPorTercero__c', 'Causal_de_Devolucion__c', 'APN__c','Plan__r.NombredelProducto__r.Name', 'Servicio_ETB_Relacionado_Principal__r.NombredelaCuenta__r.Id', 'Servicio_ETB_Relacionado_Principal__r.Id', 'Servicio_ETB_Relacionado_Principal__r.NumeroConexion__c', 'Servicio_ETB_Relacionado_Principal__r.Plan__r.Id', 'Servicio_ETB_Relacionado_Principal__r.LTE_DetalleOferta__r.LTE_Valor_Total_Plan__c', 'Servicio_ETB_Relacionado_Principal__r.CuentaFacturacion__r.Id','Servicio_ETB_Relacionado_Principal__r.CuentaFacturacion__r.LTE_CicloFacturacion__c', 'Activo__r.Id','Servicio_ETB_Relacionado_Principal__r.Estado__c','Oportunidad__r.requiere_Pago_Mensualizado_Equipo__c','Oportunidad__r.Numero_de_cuotas__c',
        'LTE_ReferenciaEquipo__r.Tipo__c','Plan__r.TipodePlan__c','Tiene_rotaci_n_de_n_mero__c','Demo__c','LTE_EstadoAprobacion__c'}; //[2017-04-02 Fernando Sarasty (FS)]
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
    public string CuentaFactId{get; set;}
    public Boolean tienePort=false;
    public integer EquipoComp=0;
    public integer LineaAPN=0;
    
    //  Constructor

    public LTE_OCL_ctr(){
        Document objeDoc = new Document();
        //Obtenci?n de par?metro de entrada
        blnRenderBotonCrear = false;
        lstWrOpp = new List<wrpOpp>();
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
        //  Adquisici?n de datos del Contrato
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
        //  Adquisición de Operaciones Comerciales de Inter?s
            /*
            List<OperacionComercial__c> lstOC = ObtenerOperacionesComerciales();
            if (lstOC.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strLabelNoOCAdquiridas));
                return;
            }
            lstOCInteres = lstOC;*/
        }
        blnRenderBotonCrear = true;

        /*total_size = [select count() from OperacionComercial__c 
                        Where 
                        (
                            Oportunidad__r.AccountId=: ctcActual.AccountId 
                            Or 
                            CuentaCliente__c =: ctcActual.AccountId)
                        And
                        Legalizacion__c = null
                        And
                        Oportunidad__c!=null
                        And
                        Oportunidad__r.StageName IN ('Cerrada Ganada','Negociación Cerrada')
                        And
                        (Estado__c='Pendiente' And Plan__r.NombredelProducto__r.LineaNegocio__c='Redes Móviles')]; //set the total size in the constructor*/
		
        objeDoc = [Select Id from Document where Name = 'search' limit 1];
        idImgLupa = objeDoc.Id;
        
        setLstWrapper();
    }

    public void setLstWrapper() {
        //  Adquisición de Operaciones Comerciales de Inter?s
        //List<wrpOpp> lstW = new List<wrpOpp>();
        //List<wrpOpp> lstOpp = new List<wrpOpp>();
        Map<String, List<OperacionComercial__c>> mapFict = new Map<String, List<OperacionComercial__c>>();
                
        List<OperacionComercial__c> lstQuery = [
        Select 
        id, Name,Plan__r.TipodePlan__c,Tiene_rotaci_n_de_n_mero__c,
        Activo__r.NombredelaCuenta__r.Id, Activo__r.NombredelaCuenta__r.Name, Activo__r.NombredelaCuenta__r.Direccion__c,
        Portacion__c,Portado_con_Cedula__c,LTE_EquipoTraido__c,Activo__r.NombredelaCuenta__r.AccountNumber, LTE_Donante__c, LTE_SolicitadoPorTercero__c, 
        Causal_de_Devolucion__c, TOPP__r.TipodeOperacionporplan__c, LTE_Tipo_de_Servicio__c,
        Oportunidad__r.Name, Plan__r.Name,TOPP__r.Name, TOPP__r.AplicaPreventa__c, Activo__r.NombredelProducto__c, 
        CreatedDate, LastModifiedDate, APN__c, Plan__r.NombredelProducto__r.Name, Demo__c,(
            Select id, Respuestadeviabilidad__c, EstadoViabilidad__c From Viabilidades__r 
            ), Oportunidad__r.Requiere_Pago_Mensualizado_Equipo__c, Oportunidad__r.Numero_de_cuotas__c,
            (SELECT Id FROM Lineas_OC__r WHERE Linea__r.Linea_ETB__c = 'Portada Movil' AND Linea__r.Activo__c = null AND Accion__c = 'Adicionar' AND Estado__c = 'Pendiente')
        From OperacionComercial__c 
        Where 
        (
            Oportunidad__r.AccountId=: ctcActual.AccountId 
            Or 
            CuentaCliente__c =: ctcActual.AccountId)
        And
        Legalizacion__c = null
        And 
        ((
         Oportunidad__c != null
         And
         Oportunidad__r.StageName IN ('Cerrada Ganada','Negociación Cerrada')
         And
         Estado__c='Pendiente'
        ) OR (
         Caso__c != null
         And
         Tiene_rotaci_n_de_n_mero__c = true AND Plan__r.TipodePlan__c = 'Troncal SIP' AND Detalle_del_tramite__c IN ('Adicion Numeros Rotacion','Activacion Rotacion Numerica') AND Estado__c='En Curso'
        ))
        And
        (Plan__r.NombredelProducto__r.LineaNegocio__c='Redes Móviles')
        Order By Oportunidad__r.Name ASC NULLS FIRST, CreatedDate DESC 
        ];

        //total_size = 0; //AG 2016-04-25
        for(OperacionComercial__c oC : lstQuery) {
            /****** //AG 2016-04-25 *******/
            boolean error = true;
            if(!oC.Viabilidades__r.isEmpty()){
                for(Viabilidad__c objViabilidad : oC.Viabilidades__r){
                    if(objViabilidad.Respuestadeviabilidad__c == strEstadoViableViabilidad && (objViabilidad.EstadoViabilidad__c == 'Cerrada' || objViabilidad.EstadoViabilidad__c == 'Cerrada - Información incompleta y/o errónea')){
                        error = false;
                        break;
                    }
                }
            }
            /*****************************/
            if(!error || oC.Viabilidades__r.isEmpty()){
                total_size++;
                if(total_size <= intRecordLimit) {
                    String strLlaveMapa = '' + oC.Oportunidad__c;
                    if (!mapFict.containsKey(strLlaveMapa))
                        mapFict.put(strLlaveMapa, new List<OperacionComercial__c>());
                    mapFict.get(strLlaveMapa).add(oC);
                }
            }
        }

        lstQuery = null;

        if(total_size > intRecordLimit) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.LTE_ctr_MsjMaxLimiteLegalizacion.replace('%cantMaxima%', Label.LTE_ctr_MaxOCsLegalizacion)));
        }
        /*boolean error = true;
        for(OperacionComercial__c oC : lstQuery) {
            if(!oC.Viabilidades__r.isEmpty()){
                for(Viabilidad__c objViabilidad : oC.Viabilidades__r){
                    if(objViabilidad.Respuestadeviabilidad__c == strEstadoViableViabilidad && (objViabilidad.EstadoViabilidad__c == 'Cerrada' || objViabilidad.EstadoViabilidad__c == 'Cerrada - Información incompleta y/o errónea')){
                        error = false;
                        break;
                    }
                }
                if(error){
                    oC.addError(Label.LTE_Viabilidad_OC_No_Cumple);
                }
            }
        }*/
        for (String strLlave : mapFict.keySet()) {
            Opportunity o = new Opportunity();
            List<wrpOc> lstOC = new List<wrpOc>();
            for (OperacionComercial__c oc : mapFict.get(strLlave)) {
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
            lstWrOpp.add(opp);
        }

        //lstWrOpp = lstOpp;

        System.debug('\n\n-=#=-\n' + 'lstWrOpp' + ': ' + lstWrOpp + '\n-=#=-\n');
    }

    public List<wrpOpp> getLstWrapper() {
        return lstWrOpp;
    }

    //  Funci?n para Obtener las Operaciones Comerciales de Inter?s
    
    /*public List<OperacionComercial__c> ObtenerOperacionesComerciales() {
        List<OperacionComercial__c> lstRetorno = new List<OperacionComercial__c>();
        //  Consulta de las Operaciones Comerciales en BD
        List<OperacionComercial__c> lstQuery = [
        Select 
        id, Name,
        Activo__r.NombredelaCuenta__r.Id, Activo__r.NombredelaCuenta__r.Name, Activo__r.NombredelaCuenta__r.Direccion__c,
        Portacion__c,LTE_EquipoTraido__c,Activo__r.NombredelaCuenta__r.AccountNumber, LTE_Donante__c, LTE_SolicitadoPorTercero__c, 
        Causal_de_Devolucion__c, TOPP__r.TipodeOperacionporplan__c, LTE_Tipo_de_Servicio__c,
        Oportunidad__r.Name, Plan__r.Name,TOPP__r.Name, TOPP__r.AplicaPreventa__c, Activo__r.NombredelProducto__c, 
        CreatedDate, LastModifiedDate, (
            Select id From Viabilidades__r Where Respuestadeviabilidad__c =: strEstadoViableViabilidad
            )
        From OperacionComercial__c 
        Where 
        (
            Oportunidad__r.AccountId=: ctcActual.AccountId 
            Or 
            CuentaCliente__c =: ctcActual.AccountId)
        And
        Legalizacion__c = null
        And
        Oportunidad__c!=null
        And
        Oportunidad__r.StageName ('Cerrada Ganada','Negociación Cerrada')
        And
        (Estado__c='Pendiente' And Plan__r.NombredelProducto__r.LineaNegocio__c='Redes Móviles')
        Order By Oportunidad__r.Name ASC NULLS FIRST LIMIT :list_size OFFSET :counter
        ];
        //  Filtrado de OC que no requieran Viabilidad o que tengan Viabilidades en estado Viable
        if (!lstQuery.isEmpty()) {
            for(OperacionComercial__c oc : lstQuery) {
                if((oc.TOPP__r.AplicaPreventa__c && oc.Viabilidades__r!=null && oc.Viabilidades__r.size()>0)
                    || (!oc.TOPP__r.AplicaPreventa__c)){
                    lstRetorno.add(oc);
                }
            }
        }
        return lstRetorno;
    }*/

    //  Funcion para procesar las Operaciones Comerciales de Inter?s hacia el wrapper

    /*public List<wrpOpp> ProcesarOportunidades() {
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
    }*/

    //  Funci?n para segregar las Operaciones Comerciales seleccionadas

    private List<OperacionComercial__c> ExtraerOperacionesSeleccionadas(List<wrpOpp> lstWrOpp) {
        System.debug('\n\n-=#=-\n' + 'ExtraerOperacionesSeleccionadas - lstWrOpp.size()' + ': ' + lstWrOpp.size() + '\n-=#=-\n');
        List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
        
        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        String productoAPN = vGlobal.get('NombreComercialAPN').valor__c;
        
        tienePort=false;
        EquipoComp=0;
        LineaAPN=0;
        List<Id> lstIdOC = new List<Id>();
        for (wrpOpp o : lstWrOpp) {
            for (wrpOc oC : o.lstOC) {
                if (oC.check)
                    lstIdOC.add(oC.oC.Id);
                    if(oC.oC.Portacion__c && oC.oC.TOPP__r.TipodeOperacionporplan__c=='Venta'){
                        tienePort=true;
                    }
                
                    if(oC.oC.Plan__r.TipodePlan__c == 'Troncal SIP' && oC.oC.Lineas_OC__r.size()>0 && oC.oC.Tiene_rotaci_n_de_n_mero__c == true){
                        tienePort=true;
                    }
                    
                    if(!oC.oC.LTE_EquipoTraido__c){
                        if(productoAPN!=oC.oC.Plan__r.NombredelProducto__r.Name){
                            EquipoComp++;
                        }
                    }
                    
                    if(productoAPN==oC.oC.Plan__r.NombredelProducto__r.Name){
                        LineaAPN++;
                    }
            }
        }
        lstOC = Database.query(ConstruirQueryObligatorios());
        System.debug('\n\n-=#=-\n' + 'ExtraerOperacionesSeleccionadas - lstOC.size()' + ': ' + lstOC.size() + '\n-=#=-\n');
        system.debug(lstOC);
        return lstOC;
    }

    //  Funci?n para cargar los campos obligatorios de las Operaciones Comerciales

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

    //  Función para construir el query que incluye todos los campos obligatorios

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
    //  Función para Validad que las OC hayan sido modificadas

    public boolean ValidarOperacionModificada(OperacionComercial__c oc) {
        boolean blnRetorno = false;
        if (oc != null) {    //LEM 03-12-2014 se quita la validacion que la fecha de creacion sea diferente a la modificacion
            if (oc.CreatedDate != null && oc.LastModifiedDate != null /*&& oc.CreatedDate != oc.LastModifiedDate*/) {
                blnRetorno = ValidarOperacionDiligenciada(oc);
            }
        }
        return blnRetorno;
    }
    
    //  Funcion para Validar que las operaciones comerciales hayan sido diligenciadas a nivel de formato
    
    public boolean ValidarOperacionDiligenciada(OperacionComercial__c oc) {
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
    
    // Funci?n que devuelve los campos que est?n vacios para la oportunidad comercial
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
    //  Función para generar el contenido de la Visualforce
    
    public pageReference Main() {
        if (ApexPages.hasMessages(ApexPages.Severity.FATAL) || ApexPages.hasMessages(ApexPages.Severity.ERROR))
            return null;
        /*for(OperacionComercial__c oC : lstOCInteres) {
            String strLlaveMapa = '' + oC.Oportunidad__c;
            if (!mapFictOpps.containsKey(strLlaveMapa))
                mapFictOpps.put(strLlaveMapa, new List<OperacionComercial__c>());
            mapFictOpps.get(strLlaveMapa).add(oC);
        }
        lstWrOpp = ProcesarOportunidades();*/
        return null;
    }

    //  Función para crear la legalización a partir de las Operaciones Comerciales seleccionadas

    public pageReference CrearLegalizacion() {
        intOcsDemo 	  = 0;
    	intnOcsNoDemo = 0;
        ocsDemoSinAprobar = '';
        Map<String,String>	mpRtaValidacionCicloCta = new Map<String,String>();
        
        mpRtaValidacionCicloCta = consultarCicloFact(CuentaFactId);        
        String resultValidacionCicloCta = mpRtaValidacionCicloCta.get('validacion');
        if(resultValidacionCicloCta != ''){
          	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, resultValidacionCicloCta ));  
        }else{
            Boolean flgActualizaFinanciacion = false;
            System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'CrearLegalizacion' + '   <<<<<<<<<<\n-=#=-\n');
            System.debug('\n\n-=#=-\n' + 'CrearLegalizacion - TOTAL - lstWrOpp.size()' + ': ' + lstWrOpp.size() + '\n-=#=-\n');
            //  Obtención de las OC seleccionadas en la VF
            List<OperacionComercial__c> lstOC = ExtraerOperacionesSeleccionadas(lstWrOpp);
            System.debug('\n\n-=#=-\n' + 'CrearLegalizacion - SELECCIONADAS - lstOC.size()' + ': ' + lstOC.size() + '\n-=#=-\n');
            
            Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
            String productoAPN = vGlobal.get('NombreComercialAPN').valor__c;
            String productoNumAbrev = vGlobal.get('NumeracionAbreviada').valor__c;
            String sOferta = '';
                    
            System.Savepoint svReferencia;
            List<OperacionComercial__c> lstOCIncompletas = new List<OperacionComercial__c>();
            //  Validación de llenado de las Operaciones Comerciales Seleccionadas
            for (OperacionComercial__c oc : lstOC) {
                if (!ValidarOperacionModificada(oc))
                {
                    system.debug('OC :'+oc);
                    lstOCIncompletas.add(oc);
                }
                if(oc.Plan__r.TipodePlan__c == 'Troncal SIP'){
                    sOferta = 'Troncal SIP';
                }
                //verificar si la legalización a crear incluye OCs Demo
                if(oc.Demo__c){
                    intOcsDemo ++;
                    if(oc.LTE_EstadoAprobacion__c != 'Aprobado')
                    	ocsDemoSinAprobar = ocsDemoSinAprobar+' '+oc.Name;
                }else
                    intnOcsNoDemo ++;
            }
            if (lstOCIncompletas.size() > 0) {
                String strMensajeIncompletas = '';
                for (OperacionComercial__c oc : lstOCIncompletas) {
                    string faltantes = ValidarCamposOperacion(oc);
                    strMensajeIncompletas = strMensajeIncompletas + '<li>' + oc.Name + ', Campos Faltantes: '+faltantes+ '</li>\n';
                }
                strMensajeIncompletas = Label.Operaciones_Comerciales_Incompletas.replace('%1',strMensajeIncompletas);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMensajeIncompletas));
            } else if(intOcsDemo > 0 && intnOcsNoDemo > 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DEMOS_Mensaje_validacion_Legalizacion));
            } else if(intOcsDemo > 0 && ocsDemoSinAprobar != '')
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DEMOS_Mensaje_validacion_aprobacion.replace('%ocs%',ocsDemoSinAprobar)));
            else if(intOcsDemo > 0 && mpRtaValidacionCicloCta.get('cuentaDemo') != 'Si'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DEMOS_Mensaje_validacion_Legalizacion_LTE));
            }else if(intOcsDemo == 0 && mpRtaValidacionCicloCta.get('cuentaDemo') == 'Si'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.DEMOS_Mensaje2_validacion_Legalizacion_LTE));
            }else{
                //lstWrOpp = null;
                //  Creación de Legalización y asociación de sus respectivas operaciones comerciales
                try {
                    list<OperacionComercial__c> lotePortabilidad=new list<OperacionComercial__c>();
                    svReferencia = Database.setSavepoint();
                    LibreriaUtilitaria_cls.GenerarExcepcionTest();
                    
                    Id RecordId = Schema.SObjectType.Legalizacion__c.getRecordTypeInfosByName().get('Legalización LTE').getRecordTypeId();
                    Legalizacion__c legNueva = new Legalizacion__c(Contrato__c = idContrato,Nombredelacuenta2__c = [Select AccountId From Contract Where ID =: idContrato Limit 1].AccountId);
                    legNueva.recordTypeId=RecordId;
                    if(tienePort){
                        legNueva.Portacion__c='Si';
                    }
                    
                    legNueva.LTE_CuentaFacturacion__c=CuentaFactId;
                    Id devRecordTypeId=Schema.SObjectType.Legalizacion__c.getRecordTypeInfosByName().get('Legalización LTE').getRecordTypeId();
                    legNueva.RecordTypeId=devRecordTypeId;
        
                    // Calcular Numero de Factura
                    LTE_RangoFactura__c Rango = LTE_RangoFactura__c.getValues('FactEquiposLTE');
                    system.debug('Rango-->'+Rango);
                    LTE_ConsecutivoFacturaEquipos__c conFac = new LTE_ConsecutivoFacturaEquipos__c();
                    insert conFac;
                    LTE_ConsecutivoFacturaEquipos__c  objConfac =[SELECT Consecutivo_Factura_Equipo__c FROM LTE_ConsecutivoFacturaEquipos__c where id=:conFac.Id];
                    system.debug('objConfac-->'+objConfac); 
                    system.debug('String.ValueOF(integer.ValueOF(Rango.Inicio_Rango__c)-->'+String.ValueOF(Rango.Inicio_Rango__c)); 
                    system.debug('integer.ValueOF(objConfac.Consecutivo_Factura_Equipo__c)-->'+Decimal.ValueOF(objConfac.Consecutivo_Factura_Equipo__c));       
                    //legNueva.LTE_NFacturaVenta__c = String.ValueOF(Rango.Inicio_Rango__c)+Decimal.ValueOF(objConfac.Consecutivo_Factura_Equipo__c);
                    legNueva.LTE_NFacturaVenta__c = String.ValueOF(Rango.Inicio_Rango__c+Integer.ValueOF(objConfac.Consecutivo_Factura_Equipo__c));
                    system.debug('legNueva.LTE_NFacturaVenta__c-->'+legNueva.LTE_NFacturaVenta__c);
                    
                    if(EquipoComp!=0){
                        legNueva.TieneEquiposAdquiridosETB__c=true;         
                    }
                    
                    if(LineaAPN!=0){
                        legNueva.Aplica_APN__c=true;         
                    }
                    legNueva.Tipo_Oferta__c = sOferta;
                    
                    list<ActivoETB__c> servicio =new list<ActivoETB__c>();      //idContrato        
                    
                    if(intOcsDemo > 0)
                        legNueva.Legalizacion_servicios_Demo__c = true;
                    
                    insert(legNueva);
                    
                    Boolean crearOCVentaEquipos = false; //AG 2016-04-26 variable para validar si se debe crear la OC de venta equipos
                    
                    for (OperacionComercial__c oc : lstOC) {
                        
                        //[FSARASTY, 07/02/2019]: Validar si los equipos se deben financiar.                    
                        if(oc.Oportunidad__r.Requiere_Pago_Mensualizado_Equipo__c && oc.Oportunidad__r.Numero_de_cuotas__c > 0 && !flgActualizaFinanciacion){
                            flgActualizaFinanciacion = true;
                            legNueva.Cuotas__c = oc.Oportunidad__r.Numero_de_cuotas__c;
                            legNueva.LTE_TipoPago__c = 'Primera factura';
                            update(legNueva);
                        }                                        
                        oc.Legalizacion__c = legNueva.Id;
                        oc.CuentaFacturacion__c= CuentaFactId;
                        //Oc para la creacion del lote de portabilidad
                        system.debug('Datos portabilidad'+oc.Portacion__c+' '+oc.TOPP__r.TipodeOperacionporplan__c );
                        if(oc.Portacion__c && oc.TOPP__r.TipodeOperacionporplan__c=='Venta'){
                            lotePortabilidad.add(oc);                   
                        }
                        
                        if(oc.Plan__r.TipodePlan__c == 'Troncal SIP' && oc.Tiene_rotaci_n_de_n_mero__c == true){
                            lotePortabilidad.add(oc);
                        }
                        
                        if(oc.Activo__c!=null){
                            servicio.add(new ActivoETB__c(id=oc.Activo__c,Contrato__c=idContrato));             
                        }
                        
                        system.debug(oc.name+' '+oc.Portacion__c+' '+oc.TOPP__r.TipodeOperacionporplan__c);
                                            
                        /************ AG 2016-04-26 Validacioón para no crear la OC de Venta Equipos********/
                        if(oc.LTE_EquipoTraido__c == null || oc.LTE_EquipoTraido__c == false)
                            crearOCVentaEquipos = true;
                        if(oc.Plan__r.NombredelProducto__r.Name == productoAPN || ((oc.Plan__r.Name == System.Label.Nombre_Plan_Troncal_SIP_Alterna)) || oc.Plan__r.NombredelProducto__r.Name == productoNumAbrev || oc.LTE_ReferenciaEquipo__r.Tipo__c == 'Red' || oc.TOPP__r.TipodeOperacionporplan__c == 'Modificación Estándar')
                            crearOCVentaEquipos = false;
                        /***********************************************************************************/
    
                        /************ [2017-04-02 Fernando Sarasty (FS)] Generación de OC de cambio de PLAN sobre AC principal de una Troncal SIP********/
                        creaOCCambioPlanACPrincipal(oc);
                        /************ FIN [2017-04-02 Fernando Sarasty (FS)] Generación de OC de cambio de PLAN sobre AC principal de una Troncal SIP********/
                    }
                    update(lstOC);
                    update(servicio);
                    system.debug('lotePortabilidad-->'+lotePortabilidad);
                    if(!lotePortabilidad.isEmpty()){
                        system.debug('Invoque crear lote'+legNueva+'--->'+lstOC);
                        Legalizacion_cls.creaLote(legNueva,lstOC);
                    }
                    //AG 2016-04-26: Se incluye validación para crear la OC de Venta Equipo si hay al menos una sin equipo traido
                    if(crearOCVentaEquipos)
                        ventaEquiposLte(legNueva.Id);
                        
                    return (new PageReference('/' + legNueva.Id));
                } catch(Exception e) {
                    ApexPages.addMessages(e);
                    system.debug(e.getMessage()+' - '+e.getStackTraceString());
                    Database.rollback(svReferencia);
                    return null;
                }
            }
        }        
        return null;
    }
    
    public string getCuentaFact(){
        Schema.DescribeSObjectResult r = CuentaFacturacion__c.sObjectType.getDescribe();
        return  '/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Cliente__c =\''+ctcActual.AccountId+'\' and (Facturable__c=true or (Facturable__c=false and LTE_CuentaFacturacionPadre__r.Facturable__c=true)) and (LTE_CuentaFacturacionLTE__c=true or Cuenta_para_servicios_Demo__c = true)')+'&f='+filtro_cls.codificar(',Name,LTE_NombreCuentaFacturacion__c,Cliente__r.Name,Tipo_de_cuenta__c,LTE_CuentaFacturacionPadre__r.Name,CodCicloFac__c')+'&infoParam=CuentaFact&nom='+filtro_cls.codificar('Número de cuenta,Nombre,Cliente,Tipo de cuenta,Cuenta de facturación padre,Ciclo de facturación');
    }
    
    public void ventaEquiposLte(Id IdLeg){
        ActivoETB__c acEquipos=new ActivoETB__c(NombredelaCuenta__c=ctcActual.AccountId);
        insert acEquipos;
        

        DateTime dT = System.now();
        Date fechaActiv = date.newinstance(dT.year(), dT.month(), dT.day());

        // Obtener el plan asociado con venta de equipos
        Planes__c objPlan = [Select id,Name From Planes__c Where Name =: system.label.PLANDEPAGOS];
        
        // Obtener la operacion comercial asociada con Venta de Equipos
        TOPP__c topp = [SELECT Facturable__c,Id,LTE_Catalogo_de_Producto__c,Name FROM TOPP__c where Name=:system.label.Venta_Equipos_TELEFONIA_MOVIL_LTE];
        
        // Crear la operacion comercial}
        OperacionComercial__c ocEquipos=new OperacionComercial__c(Plan__c=objPlan.Id,Legalizacion__c=IdLeg,Activo__c=acEquipos.id,TOPP__c=topp.id,Estado__c='Pendiente',FechadeActivacion__c=fechaActiv);
        insert ocEquipos;
            
        system.debug('op-com-->'+acEquipos); 
        
        map<Id,OperacionComercial__c> oc=new map<Id,OperacionComercial__c>([select id,Name,Plan__c,Legalizacion__c,Activo__c from OperacionComercial__c where Id=:ocEquipos.id]);
        LTE_GeneraServAdicVentaEquipos.obtenerEstructurado(oc);
        
        system.debug(ocEquipos);
    }
    
    public Integer getTotal_size() {
      return total_size;
   }

   /************ [2017-04-02 Fernando Sarasty (FS)] Generación de OC de cambio de PLAN sobre AC principal de una Troncal SIP********/   
   public void creaOCCambioPlanACPrincipal(OperacionComercial__c oc)
   {         
       if(oc.Plan__r.Name == System.Label.Nombre_Plan_Troncal_SIP_Alterna)
       {           
            if(obtenerFlagOCCreadaOportunidad(oc.Oportunidad__r.id) == false && oc.Servicio_ETB_Relacionado_Principal__r.Estado__c != 'Pendiente')
            {
                List<Equipo__c> lstEquipos = new List<Equipo__c>();
                List<RecordType> lstRecordType = new list<RecordType>();
                List<TOPP__c> lstTOPP = new list<TOPP__c>();
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
                lstTOPP       = [select id from TOPP__c where Name = 'Cambio de Plan- TELEFONIA MOVIL (LTE)' and  LTE_Parte_caso__c = true];
                lstSubPlan    = [select id, Name from SubPlanFacturacion__c where name = 'Troncal SIP Canales'];
                                
                system.debug('--> Resultado consultas: '+lstEquipos+'-'+lstRecordType+'-'+lstTOPP+'-'+lstSubPlan);
                if(lstRecordType.isEmpty()){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.LTE_Tipo_Registro_Venta_LTE_No_Encontrado));
                }else{                    
                    try{
                        cicloFact = (oc.Servicio_ETB_Relacionado_Principal__r.CuentaFacturacion__r.LTE_CicloFacturacion__c == null? obtenerCicloFacturacion(CuentaFactId) : oc.Servicio_ETB_Relacionado_Principal__r.CuentaFacturacion__r.LTE_CicloFacturacion__c);
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
                                objOfertaEconomica.LTE_Plan__c = oc.Servicio_ETB_Relacionado_Principal__r.Plan__r.Id; 
                                insert objOfertaEconomica;
                                system.debug('--> Fin Creación oferta económica '+objOfertaEconomica.id);
                                
                                // Crear operación comercial de cambio de plan sobre el AC principal relacionado a la Troncal SIP Alterna
                                objOC = new OperacionComercial__c();
                                objOC.CuentaCliente__c = oc.Servicio_ETB_Relacionado_Principal__r.NombredelaCuenta__r.Id;
                                objOC.Activo__c = oc.Servicio_ETB_Relacionado_Principal__r.Id;
                                objOC.NumeroConexion__c = oc.Servicio_ETB_Relacionado_Principal__r.NumeroConexion__c;
                                objOC.Plan__c = oc.Servicio_ETB_Relacionado_Principal__r.Plan__r.Id;
                                objOC.TOPP__c = (lstTOPP.size()>0 ? lstTOPP[0].id : null);
                                objOC.PlanAnterior__c = oc.Servicio_ETB_Relacionado_Principal__r.Plan__r.Id;
                                objOC.Estado__c = 'Pendiente';                                
                                objOC.RecordTypeId = (lstRecordType.size()>0 ? lstRecordType[0].id : null);                                
                                objOC.Valor_Recurrente_ETB_Anterior__c = oc.Servicio_ETB_Relacionado_Principal__r.LTE_DetalleOferta__r.LTE_Valor_Total_Plan__c;
                                objOC.ValorTarifaPlan__c = dcmValorTotal;
                                objOC.CuentaFacturacion__c = oc.Servicio_ETB_Relacionado_Principal__r.CuentaFacturacion__r.Id;
                                objOC.FechaInicioReconexion__c = fechaCorte;
                                objOC.Legalizacion__c = oc.Legalizacion__c;                                
                                insert objOC;       
                                system.debug('--> Fin Creación operación comercial '+objOC.id);
                                
                                // Crear detalle de la oferta
                                objDetalleOferta = new LTE_DetalleOferta__c();
                                objDetalleOferta.LTE_OperacionComercial__c = objOC.Id;
                                objDetalleOferta.Plan__c = oc.Servicio_ETB_Relacionado_Principal__r.Plan__r.Id;
                                objDetalleOferta.LTE_TipodePlan__c = 'Troncal SIP';
                                objDetalleOferta.LTE_DatosNavegacion__c =  (lstSubPlan.size()>0 ? lstSubPlan[0].id : '-');
                                objDetalleOferta.LTE_Oferta_Economica__c = objOfertaEconomica.Id;
                                objDetalleOferta.LTE_Cliente__c = oc.Servicio_ETB_Relacionado_Principal__r.NombredelaCuenta__r.Id;
                                objDetalleOferta.LTE_NumeroLinea__c = oc.Servicio_ETB_Relacionado_Principal__r.NumeroConexion__c;
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
                                objSADatos.Name = (lstSubPlan.size()>0 ? lstSubPlan[0].Name : oc.Servicio_ETB_Relacionado_Principal__r.Plan__r.Id);
                                objSADatos.LTE_DetalleOfertaEReservadoRegContable__c = objDetalleOferta.Id;
                                objSADatos.LTE_SubPlaFacturacion__c = (lstSubPlan.size()>0 ? lstSubPlan[0].id : oc.Servicio_ETB_Relacionado_Principal__r.Plan__r.Id);
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
                                
                                Opportunity oportunidad = new Opportunity(Id = oc.Oportunidad__r.id);
                                oportunidad.OC_de_Cambio_de_Plan_AC_Principal__c = true;
                                update oportunidad;
                                system.debug('--> Fin actualizar flag oportunidad '+oc.Oportunidad__r.id);                            
                                
                                                                
                            } catch(Exception e){
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
            // Actualizar relación de servicios            
            ActivoETB__c servicio = new ActivoETB__c(Id = oc.Activo__r.Id);
            servicio.Activo_Relacionado__c = oc.Servicio_ETB_Relacionado_Principal__r.Id;
            update servicio;
            system.debug('--> Fin actualizar relacion de servicios. Servicio Padre: '+oc.Servicio_ETB_Relacionado_Principal__r.Id+'. Servicio hijo: '+oc.Activo__r.Id);       
        }           
   }
   /************ FIN [2017-04-02 Fernando Sarasty (FS)] Generación de OC de cambio de PLAN sobre AC principal de una Troncal SIP********/   

   /************ [2017-04-02 Fernando Sarasty (FS)] Método para obtener la fecha de corte de un ciclo de facturación ********/   
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
    /************ [2017-04-02 Fernando Sarasty (FS)] Método para obtener el Id de un plan de facturación ********/   
    public Id obtenerPlanFacturacionId(Id planId){
        lstPlanFacturacion = [SELECT Id, Name, Plan__c FROM PlanFacturacion__c WHERE Plan__c =:planId LIMIT 1];
        if(!lstPlanFacturacion.isEmpty())
            return lstPlanFacturacion[0].Id;            
        else return null;        
    }
    /************ [2017-04-02 Fernando Sarasty (FS)] Método para obtener el nombre de un plan de facturación ********/   
    public String obtenerPlanFacturacionName(Id planId, String campo){
        lstPlanFacturacion = [SELECT Id, Name, Plan__c, LTE_PrimaryClassificationCode__c FROM PlanFacturacion__c WHERE Plan__c=:planId LIMIT 1];
        if(!lstPlanFacturacion.isEmpty()){            
            if(campo == 'Name')
                return lstPlanFacturacion[0].Name;
            else
                return lstPlanFacturacion[0].LTE_PrimaryClassificationCode__c;                
        }else return null;        
    }
    /************ [2017-04-02 Fernando Sarasty (FS)] Método para obtener el nombre de un sub plan de facturación ********/   
    public String obtenerSubPlanFacturacionName(Id planId, String campo)
    {
        if(planId != null)
        {
            lstSubPlanFacturacion = [SELECT Id, Name, LTE_PrimaryClassificationCode__c FROM SubPlanFacturacion__c WHERE Id=:planId LIMIT 1];
            if(!lstSubPlanFacturacion.isEmpty()){            
                if(campo == 'Name')
                    return lstSubPlanFacturacion[0].Name;
                else
                    return lstSubPlanFacturacion[0].LTE_PrimaryClassificationCode__c;
            }else return null;
         }else return null;         
    }    
    /************  [2017-04-02 Fernando Sarasty (FS)] Método para obtener el flag "OC_de_Cambio_de_Plan_AC_Principal__c" de una oportunidad ********/   
    public Boolean obtenerFlagOCCreadaOportunidad(Id IdOportunidad)
    {
        if(IdOportunidad != null)
        {            
            lstOportunidad = [SELECT OC_de_Cambio_de_Plan_AC_Principal__c FROM Opportunity WHERE Id=:IdOportunidad LIMIT 1];
            if(!lstOportunidad.isEmpty())                            
                return lstOportunidad[0].OC_de_Cambio_de_Plan_AC_Principal__c;
           	else return null;
        }else return null;        
    }
    /************ [2017-04-02 Fernando Sarasty (FS)] Método para obtener el ciclo de facturación de una cuenta de facturación ********/       
     public String obtenerCicloFacturacion(Id IdCtaFact)
    {
        if(IdCtaFact != null)
        {            
            lstCtaFact = [SELECT LTE_CicloFacturacion__c FROM CuentaFacturacion__c WHERE Id=:IdCtaFact LIMIT 1];
            if(!lstCtaFact.isEmpty())
               return lstCtaFact[0].LTE_CicloFacturacion__c;
            else return null;            
        }else return null;        
    }
    public static Map<String,String> consultarCicloFact(string idCuenta){
        
        Map<string,string>   	  mapValuesIntegRV	 		= new map<string,string>();
        Map<String,String>		  mpRtaValidacionCicloCta   = new Map<String,String>();
        List<String> 	   		  lstCiclosFactNoDisp   	= Label.Param_Jerarquia_CF_CiclosNoFacturables.split(',');        
        tibcoXml_cls.xmlMap  	  proReq		 			= new tibcoXml_cls.xmlMap();
        ServiciosWeb__c 		  wsRV		 	        	= ServiciosWeb__c.getValues('ConsultaCicloFactRevchain');
        string	 				  requestIntegRV			= '';
		string	 				  responseIntegRV			= '';
        string	 				  strStatusInteg			= '';
        string   				  strResultInteg			= '';
        string					  strCicloFact				= '';
        string					  strResultValidacionCiclo	= '';
        string					  numCuenta					= '';
        Boolean					  cuentaDemo				= false;
        
        mpRtaValidacionCicloCta.put('cuentaDemo','');
        mpRtaValidacionCicloCta.put('validacion','');
        
        if(idCuenta != ''){            
            List<CuentaFacturacion__c> lstCtaFact = new List<CuentaFacturacion__c>([SELECT Name, Cuenta_para_servicios_Demo__c FROM CuentaFacturacion__c WHERE Id=:idCuenta]);
            if(lstCtaFact.size()>0){
                mpRtaValidacionCicloCta.put('cuentaDemo',(lstCtaFact[0].Cuenta_para_servicios_Demo__c?'Si':'No'));
                numCuenta = lstCtaFact[0].Name;
                if(!numCuenta.contains('Fact-')){            
                    requestIntegRV 	  = ConstruirXMLCtasFact_cls.CrearXMLGetAccountCycle(numCuenta,obtenerCorrelationId());
                    responseIntegRV	  = LibreriaUtilitariaJobs_cls.consultarServicio(requestIntegRV,wsRV.Action__c,wsRV.EndPoint__c);
                    //responseIntegRV = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:GetAccountCycleOUT xmlns:ns0="http://www.etb.com.co/LTE/WS/BillingCorporate/GetAccountCycleOp"><ns1:WSResponseHeader2 xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader2/v1.0"><ns1:System><ns1:name>Salesforce</ns1:name><ns1:correlationID>GETACCCIC-001</ns1:correlationID><ns1:processingServer>Tibco</ns1:processingServer></ns1:System><ns1:Service>       <ns1:status>PASS</ns1:status><ns1:responseDate>2020-03-27T08:09:35.327-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader2><ns2:GetAccountCycleOutput xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/BillingCorporate/GetAccountCycleOp" xmlns:ns2="http://www.etb.com.co/LTE/WS/BillingCorporate/GetAccountCycleMsg"><ns2:ResponseService><ns2:Operation>C</ns2:Operation><ns2:Result>S</ns2:Result><ns2:System>MdmCmpRevchain</ns2:System><ns2:portalfija_data><ns2:ciclo_cuenta><ns2:cuenta>1490890</ns2:cuenta><ns2:ciclo>55</ns2:ciclo></ns2:ciclo_cuenta><ns2:resultado>0</ns2:resultado><ns2:descError>OK</ns2:descError></ns2:portalfija_data></ns2:ResponseService></ns2:GetAccountCycleOutput></ns0:GetAccountCycleOUT></SOAP-ENV:Body></SOAP-ENV:Envelope>';
                    mapValuesIntegRV  = proReq.getMap(responseIntegRV);            
                    
                    if(mapValuesIntegRV.size() > 0){
                        strStatusInteg    = mapValuesIntegRV.get('status');
                        strResultInteg    = mapValuesIntegRV.get('Result');              
                        if(strStatusInteg == 'PASS' && strResultInteg == 'S'){
                            strCicloFact	  = mapValuesIntegRV.get('ciclo');                
                            if(lstCiclosFactNoDisp.contains(strCicloFact) && strCicloFact != 'N/A')
                                strResultValidacionCiclo = Label.Msj_ErrorCicloFactCuenta.replace('%cuenta%',numCuenta).replace('%ciclo%',strCicloFact);
                        }
                    } 
                }                
            }               
        }
        mpRtaValidacionCicloCta.put('validacion',strResultValidacionCiclo);        
        return mpRtaValidacionCicloCta;
    }
    public static String obtenerCorrelationId(){
    	
    	Datetime dttFechaHoraActual	= System.now();
    	Integer intNumeroRandom = Math.round( Math.random() * ( 1000 + dttFechaHoraActual.second() ) );
    	String strCorrelationId = dttFechaHoraActual.format( 'ddMMyyyyHHmmssSSS' ) + String.valueOf( intNumeroRandom );
    	
    	return strCorrelationId;
    }
}