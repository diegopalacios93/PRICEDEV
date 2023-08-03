/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Juan Gabriel Duarte Pacheco
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase controladora para la generacion de la oferta económica

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2015-07-28      Juan Gabriel Duarte P. (JGD)               Creación de la clase.
1.1     2016-07-13      Manuel Alejandro Cortes (MC)               Se crear una configuracion personalizada para almacenar los planes a la medida
1.2     2022-04-01      Astrid Leiva & Omar Moreno                 Se añaden promociones
***********************************************************************************************************************/

public with sharing class LTE_OfertaEnonomica_ctr {

    //Definicion de variables globales
    private Apexpages.Standardcontroller stdController;
    public Opportunity objOportunidad                               {get; set;}
    public Boolean tieneOferta                                      {get; set;}
    public List<Reserva__c> lstOfertas                              {get; set;}
    public List<Reserva__c> lstOfertasBorrar                        {get; set;}
    Reserva__c objReserva                                           {get; set;}        
    public Boolean blnOCs                                           {get; set;}
    public Boolean blnDetalles                                      {get; set;}    
    public Boolean blnMostrarDetalles                               {get; set;}
    private Map<Id, Planes__c> mpValoresPlanes                      {get; set;}
    private Map<Id, SubPlanFacturacion__c> mpValoresSubPlanes       {get; set;}
    private Map<Id, Equipo__c> mpValoresEquipos                     {get; set;} // Al
    public Map<Id, List<SelectOption>> idPlanAOpciones				{get; set;} // Al
    //public Map<Id, List<SelectOption>> promocionSVAVoz              {get; set;} // AL
    //public Map<Id, List<SelectOption>> promocionSVADatos            {get; set;} // AL
    public Map<Id, List<SelectOption>> promocionSVA                 {get; set;} // AL
    //public Map<Id,Map<Id, List<SelectOption>>> mapapromocionesSVAVoz {get; set;} // AL
    //public Map<Id,Map<Id, List<SelectOption>>> mapapromocionesSVADatos {get; set;} // AL
    public List<LTE_DetalleOferta__c> lstDetallesOferta             {get; set;}
    public String strNivelId                                        {get; set;}
    public String strNivel                                          {get; set;}
    public String strType                                           {get; set;}
    Integer intIndice                                               {get; set;}
    Integer intLimiteLineas                                         {get; set;}
    public Integer intRow                                           {get; set;}
    public boolean blnOferta                                        {get; set;}
    public boolean numLineas                                        {get; set;}
    public boolean pagoMensualizado                                 {get; set;}
    public String SitePrefix (){return Site.getBaseUrl();}
    //Definicion de variables para visibilidad de botones
    public Boolean blnContinuar                                     {get; set;}    
    public Boolean blnContinuarFlags                                {get; set;}    
    public Boolean blnFlgMensualizado                               {get; set;}
    public Boolean blnPagoMensualizado                              {get; set;} 
    public Boolean blnExportarBoton                                 {get; set;}
    public Boolean blnBotonesGestion                                {get; set;} //Correspondiente a: Agregar Item, Eliminar Item y Calcular
    public Boolean blnGuardarOfertaBoton                            {get; set;}
    public Boolean blnDetalleOfertaBoton                            {get; set;}
    public Boolean blnGuardarDetalleBoton                           {get; set;}
    public VariablesGlobales__c vgLob                               {get; set;}
    private Map<string,VariablesGlobales__c> vGlobal;
    
    public LTE_APNWrapper objAPN                                    {get; set;}
    public String strNivelAPNId                                     {get; set;}
    public String strNivelAPN                                       {get; set;}
    public String strInfoParamAPN                                   {get; set;}
    //public String idImgLupa                                           {get; set;}   
    public List<SelectOption> BolsaCompartidaExistenteLst           {get; set;} //[FSARASTY, 2020/05/01]: Bolsas compartidas
    public String BolsaCompartidaExistente                          {get; set;} //[FSARASTY, 2020/05/01]: Bolsas compartidas
    public Boolean blnFlgControlesBolsaCompartida                   {get; set;} //[FSARASTY, 2020/05/01]: Bolsas compartidas

    //public Map<id, SubPlanFacturacion__c> mapa {get; set;}// Al
    public Map<id, string> nombreSVA {get; set;} // AL
    public Set<Id> setIdSVA {get; set;} // AL
    //public Set<Id> setIdSVADatos {get; set;}// AL
    public List<SelectOption> options1 ;
    public List<SelectOption> options2 ;
    public List<SelectOption> options3 ;
    public List<SelectOption> options4 ;


    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public LTE_OfertaEnonomica_ctr(ApexPages.StandardController stdController) 
    {         
        //[FSARASTY, 2020/05/01]: Bolsas compartidas
        this.BolsaCompartidaExistenteLst    = new List<SelectOption>();         
        BolsaCompartidaExistenteLst.add(new SelectOption('Seleccione','Seleccione'));        
        BolsaCompartidaExistenteLst.add(new SelectOption('Nueva','Nueva'));
        BolsaCompartidaExistenteLst.add(new SelectOption('Existente','Existente'));
        //FIN [FSARASTY, 2020/05/01]: Bolsas compartidas
        /*Document objeDoc = [Select Id from Document where Name = 'search' limit 1];
        idImgLupa = objeDoc.Id;*/
        //Se cambio por un Static Resource para su visualizacion en las Community
        
        svaOptions=getOptionsSva();
        mapSva=new map<string,map<string,svaObj>>();
        mapJson=new map<string,string>();
        numLineas=true; 
        setIdSVA = new Set<Id> ();       
        
        blnOferta=true;
        this.stdController = stdController;
        this.objOportunidad = (Opportunity)stdController.getRecord();
        blnOCs = false;
        blnDetalles = false;
        blnMostrarDetalles = false;
        objReserva = new Reserva__c();        
        lstOfertasBorrar = new List<Reserva__c>();
        mpValoresPlanes = new Map<Id, Planes__c>();
        mpValoresSubPlanes = new Map<Id, SubPlanFacturacion__c>();
        mpValoresEquipos = new Map<Id, Equipo__c>();
        lstDetallesOferta = new List<LTE_DetalleOferta__c>();
        strNivelId = '';
        strNivel = '';
        strType = '';
        intIndice = 0;
        intRow = 0;
        nombreSVA = new map<id, string> (); // astrid
        promocionSVA  = new Map<Id, List<SelectOption>>   (); // Al 
        //Variables corresponientes a los botones
        blnContinuar = false; 
        blnContinuarFlags = false;
        blnFlgMensualizado = false;
        blnFlgControlesBolsaCompartida = false;
        blnPagoMensualizado = false; 
        blnBotonesGestion = true;
        blnExportarBoton = false;
        blnGuardarOfertaBoton = false;
        blnDetalleOfertaBoton = false;
        blnGuardarDetalleBoton = false;
        this.vGlobal = VariablesGlobales__c.getAll();
 
        //Consulta informacion de la oportunidad
        objOportunidad = getOportunidad();

        if(objOportunidad.LTE_NumeroLinea__c > 0)
        {
            blnContinuar = true;    
            blnContinuarFlags = true;
        }        
        
        //Consulta informacion de la oferta
        lstOfertas = [SELECT Equipo__c,Id,LTE_CantidadEquiposAordenar__c,LTE_CantidadLineas__c,LTE_CantidadPlanes__c,LTE_Indice__c,
                            LTE_DatosNavegacion__c,LTE_DescuentoDatos__c,LTE_DescuentoEquipos__c,LTE_DescuentoPlan__c,LTE_DescuentoPlanAux__c,Descuento_SVAs_Voz_Aux__c,
                            LTE_DescuentoVozAux__c,LTE_DescuentoBolsaDatosAux__c,LTE_DescuentoBolsaVozAux__c,LTE_DescuentoDatosAux__c,LTE_DescuentoSVAAux__c,
                            /*LTE_DescuentoSobrePlan__c,*/LTE_DescuentoVoz__c,LTE_MinutoVoz__c,LTE_Plan__c,LTE_Plan__r.LTE_Es_Plan_Compuesto__c,/*LTE_ReferenciaEquipos__c,*/
                            /*LTE_ValorNetodeOferta__c,LTE_ValorNetoOferta__c,*/
                            LTE_SvaJSON__c,Oportunidad__c,LTE_Eliminar__c,LTE_DescuentoSVA__c,LTE_DescuentoSVAs_Voz__c,
                            LTE_Equipos_Pago_Anticipado__c,LTE_PlanMedida__c,
                            LTE_DescuentoSobreBolsaRecurrenteVoz__c,LTE_DescuentoSobreBolsaRecurrenteDatos__c, //,Oportunidad__r.LTE_Sucursal__c,LTE_PlanMedida__c 
                            LTE_MinutosVozConfigurado__c ,LTE_DatosNavegacionConfigurado__c, Valor_mensual_equipo__c, Tipo_linea_bolsa_compartida__c
                            FROM Reserva__c
                            WHERE Oportunidad__c =: objOportunidad.Id ORDER BY LTE_Indice__c];
        System.debug('#94 lstOfertas->'+lstOfertas);
        obtenerSVA();
        //Si no tiene oferta oculta la seccion correspondiente
        if(lstOfertas.isEmpty())
        {
            tieneOferta = false;
            lstOfertas=new list<Reserva__c>();
            objReserva.Oportunidad__c=objOportunidad.Id;
            objReserva.LTE_Indice__c = intIndice;            
            mapSva.put(objReserva.LTE_Indice__c+'',new map<string,svaObj>());
            mapJson.put(objReserva.LTE_Indice__c+'',JSON.serialize(mapSva.get(objReserva.LTE_Indice__c+'')));

            lstOfertas.add(objReserva);
            

        } else 
        {
            tieneOferta = true;
            intIndice = (Integer) lstOfertas.get(0).LTE_Indice__c;
        }

        intLimiteLineas = Integer.valueOf(vGlobal.get('DetalleOfertaRegxPag').valor__c);
        //Consulta informacion de los detalles de oferta
        lstDetallesOferta = obtenerDetalleOferta();
        //Tiene oferta pero no se han generado los detalles de oferta habilita el boton correspondiente
        if(tieneOferta && lstDetallesOferta.isEmpty())
        {
            blnDetalleOfertaBoton=true;
            blnGuardarDetalleBoton = false;
        }
        if(tieneOferta && lstDetallesOferta.isEmpty() && !objOportunidad.LTE_OportunidadBloqueada__c && objOportunidad.EstadodeAprobacionDescuentos__c != null && objOportunidad.EstadodeAprobacionDescuentos__c.equals('Re-Ofertar'))
        {
            blnDetalleOfertaBoton=false;
        }
        //La oferta es menor a 30 lineas muestra el detallen en la pagina vf
        if(!lstDetallesOferta.isEmpty() && lstDetallesOferta.size()<=intLimiteLineas)
        {
            blnMostrarDetalles = true;
            blnBotonesGestion = false;
            blnDetalles = true;
            blnDetalleOfertaBoton=false;
            blnGuardarDetalleBoton = true;
        }
        //La oferta es mayor a 30 lineas muestra el detallen en formato csv
        if(!lstDetallesOferta.isEmpty() && lstDetallesOferta.size()>intLimiteLineas)
        {
            blnExportarBoton = true;
            blnBotonesGestion = false;
            blnDetalles = true;
            blnGuardarDetalleBoton = false;
        }
        
        //Administra los botones que se muestran de manera inicial
        if(objOportunidad.LTE_OportunidadBloqueada__c)
        {
            blnBotonesGestion = false;
            blnDetalleOfertaBoton=false;
            blnGuardarDetalleBoton = false;
        }
        if(!lstDetallesOferta.isEmpty() && !objOportunidad.LTE_OportunidadBloqueada__c && objOportunidad.EstadodeAprobacionDescuentos__c != null && objOportunidad.EstadodeAprobacionDescuentos__c.equals('Aprobado'))
        {
            blnBotonesGestion = false;
            blnDetalleOfertaBoton=false;
            if( objOportunidad.LTE_NumeroLinea__c < 31)
            {
                blnGuardarDetalleBoton = true;
            }            
        }
        if(lstDetallesOferta.isEmpty() && !objOportunidad.LTE_OportunidadBloqueada__c && objOportunidad.EstadodeAprobacionDescuentos__c != null && objOportunidad.EstadodeAprobacionDescuentos__c.equals('Aprobado'))
        {
            blnBotonesGestion = false;
            blnDetalleOfertaBoton=true;
            blnGuardarDetalleBoton = false;            
        }
        if(objOportunidad.isClosed)
        {
            blnBotonesGestion = false;
            blnDetalleOfertaBoton=false;
            blnGuardarDetalleBoton = false;
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Info,Label.LTE_OportunidadCerrada));
        }
        if(!objOportunidad.Operaciones_Comerciales__r.isEmpty())
        {
            blnBotonesGestion = false;
            blnDetalleOfertaBoton=false;
            blnGuardarDetalleBoton = false;
            blnOCs = true;
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Info,Label.LTE_OportunidadOC));
        }
        
        System.debug('blnGuardarDetalleBoton-> '+blnGuardarDetalleBoton);
        vgLob = VariablesGlobales__c.getValues('LTEPerfilAnaSopLTE');
        if(UserInfo.getProfileId()==vgLob.Valor__c)
        {
            blnDetalleOfertaBoton=false;
            blnGuardarDetalleBoton = false;
        }
        this.objAPN = new LTE_APNWrapper();
        if(this.objOportunidad.Servicio_APN_Relacionado__c != null)
        {
            strNivelAPNId = this.objOportunidad.Servicio_APN_Relacionado__c;
            strNivelAPN = this.objOportunidad.Servicio_APN_Relacionado__r.Name;
            strInfoParamAPN = 'APN';
            actualizarAPN();
        }else{
            strNivelAPNId = '';
            strNivelAPN = '';
            strInfoParamAPN = '';
        }        
    }
    
    public Opportunity getOportunidad(){
    
    return [SELECT Id,AccountId,LTE_CodigoAprobacionInicial__c,LTE_CodigoAprobacion__c,EstadodeAprobacionDescuentos__c,LTE_ValorOferta__c,isClosed, 
                                                LTE_OfertaConProductoEspecial__c,LTE_OfertaCustomizada__c,LTE_NumeroLinea__c,LTE_OportunidadBloqueada__c,LTE_Valor_equipos__c,LTE_Valor_planes__c,LTE_Valor_SVA__c,
                                                LTE_PagoAnticipado__c,LTE_RequiereBolsas__c,LTE_RequiereDescuentos__c,LTE_RequiereSVAS__c,LTE_ScoringMensual__c, 
                                                Servicio_APN_Relacionado__c, Servicio_APN_Relacionado__r.Name,Requiere_Pago_Mensualizado_Equipo__c, Numero_de_cuotas__c,
                                                LTE_Bolsa_Compartida__c,
                                                Account.Aplica_Convenio__c,  // astrid
                                                (Select Id From Operaciones_Comerciales__r) 
                                                FROM Opportunity 
                                                WHERE Id =: objOportunidad.Id];
    
    }

    //Método que permite agregar un registro de oferta comercial
    Public void agregarOferta()
    {
        intIndice ++;
        Reserva__c oferta = new Reserva__c();
        oferta.Oportunidad__c = objOportunidad.Id;
        oferta.LTE_Indice__c = intIndice; 
        //[FSARASTY, 2020/05/01]: Bolsas compartidas - Se establece valores predeterminados
        if(objOportunidad.LTE_Bolsa_Compartida__c){            
            List<Equipo__c> lstEquipo = new List<Equipo__c>([SELECT Id FROM Equipo__c WHERE Name = 'Equipo Traido']);
            List<Planes__c> lstPlan   = new List<Planes__c>([SELECT Id FROM Planes__c WHERE Name = 'Bolsa datos linea hija']);
            if(lstEquipo.size() > 0 && lstPlan.size() > 0){
                oferta.Equipo__c              = lstEquipo[0].Id;
                oferta.LTE_Plan__c            = lstPlan[0].Id;
                if(intIndice == 1 && BolsaCompartidaExistente == 'Nueva')
                    oferta.LTE_CantidadPlanes__c  = objOportunidad.LTE_NumeroLinea__c - 1;
                oferta.Tipo_linea_bolsa_compartida__c = 'Hijas';
            }            
        }  
        //FIN [FSARASTY, 2020/05/01]
        mapSva.put(oferta.LTE_Indice__c+'',new map<string,svaObj>());
        mapJson.put(oferta.LTE_Indice__c+'',JSON.serialize(mapSva.get(oferta.LTE_Indice__c+'')));
        lstOfertas.add(oferta);
    }

    public void continuar()
    {
        if(objOportunidad.LTE_NumeroLinea__c > 0)
        {
            blnContinuar = true;
            blnContinuarFlags = true;
        }
        if(objOportunidad.Requiere_Pago_Mensualizado_Equipo__c)
            blnPagoMensualizado = true; 
        //[FSARASTY, 2020/05/01]: Bolsas compartidas - Se establece valores predeterminados
        if(objOportunidad.LTE_Bolsa_Compartida__c){
            if(BolsaCompartidaExistente == 'Seleccione'){
                blnContinuar = false;
                blnContinuarFlags = false;
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Param_BolsaCompartida_ValidarCondicionBolsa));                
            }else if(BolsaCompartidaExistente == 'Existente' && objOportunidad.Servicio_Bolsa_Compartida_Padre__c == null){
                blnContinuar = false;
                blnContinuarFlags = false;
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Param_BolsaCompartida_ValidarActivoPadre));
            }else if(BolsaCompartidaExistente == 'Nueva' && objOportunidad.Servicio_Bolsa_Compartida_Padre__c != null){
                blnContinuar = false;
                blnContinuarFlags = false;
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Param_BolsaCompartida_ValidarActivoPadre_Blanco));
            }else{
                blnFlgControlesBolsaCompartida = false;
                List<Equipo__c> lstEquipo = new List<Equipo__c>([SELECT Id FROM Equipo__c WHERE Name = 'Equipo Traido']);                
                if(lstEquipo.size() > 0)
                    lstOfertas[0].Equipo__c = lstEquipo[0].Id;
                if(BolsaCompartidaExistente == 'Existente' && objOportunidad.Servicio_Bolsa_Compartida_Padre__c != null){
                    List<Planes__c> lstPlan   = new List<Planes__c>([SELECT Id FROM Planes__c WHERE Name =: Label.Param_BolsaCompartida_PlanDefault]);
                    lstOfertas[0].Tipo_linea_bolsa_compartida__c = 'Hijas';
                    lstOfertas[0].LTE_CantidadPlanes__c          = objOportunidad.LTE_NumeroLinea__c;
                    lstOfertas[0].LTE_Plan__c                    = lstPlan[0].Id;
                }else{                    
                    lstOfertas[0].Tipo_linea_bolsa_compartida__c = 'Padre';
                    lstOfertas[0].LTE_CantidadPlanes__c = 1;
                    agregarOferta();
                }            
            }
        }
        //FIN [FSARASTY, 2020/05/01]: Bolsas compartidas
        blnFlgMensualizado = true;
    }        
    //Metodo que borra los registros marcados para tal fin en la pagina vf
    public PageReference eliminarOferta()
    {
        List<Reserva__c> lstOfertasAux = new List<Reserva__c>();

        for(Reserva__c objReserva:lstOfertas)
        {
            system.debug('objReserva.LTE_Eliminar__c------' + objReserva.LTE_Eliminar__c);
            if(objReserva.LTE_Eliminar__c)
            {
                lstOfertasBorrar.add(objReserva);
            }else{
                lstOfertasAux.add(objReserva);
            }
        }

        if(lstOfertas.size() > lstOfertasBorrar.size())
        {
            lstOfertas.clear();
            lstOfertas = lstOfertasAux.clone();
        }
        else
        {
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,Label.LTE_RegistroOferta));
        }
        return null;
    }

    //Metodo que permite persistir la informacion de la oferta economica
    public PageReference guardarOferta()
    {
        calcularOferta();
        
        VariablesGlobales__c equipoTraidoLTE = VariablesGlobales__c.getValues('EquipoTraidoLTE');
        Boolean blnDtoEquipoTraido = false;
        
        ocultarDescuentoPlan();
        //Si la oportunidad tiene mas de 200 líneas o requiere algun descuento se marca como oferta customizada
        /*if(objOportunidad.LTE_NumeroLinea__c > 200)
        {
            objOportunidad.LTE_OfertaCustomizada__c = true;
        } else if(objOportunidad.LTE_RequiereDescuentos__c)
        {
            Boolean blnCapturaDto = false;
            
            for(Reserva__c objReserva:lstOfertas) //Si tiene al menos capturado un descuento marca la oportunidad como oferta customizada para enviar a aprobacion descuentos
            {
                if((objReserva.Equipo__c!=equipoTraidoLTE.Valor__c && objReserva.LTE_DescuentoEquipos__c != null) || objReserva.LTE_DescuentoPlan__c != null || objReserva.LTE_DescuentoDatos__c != null
                    || objReserva.LTE_DescuentoVoz__c != null || objReserva.LTE_DescuentoSobreBolsaRecurrenteDatos__c != null || objReserva.LTE_DescuentoSobreBolsaRecurrenteVoz__c != null)
                {
                    blnCapturaDto = true;
                }
                if(objReserva.Equipo__c==equipoTraidoLTE.Valor__c && objReserva.LTE_DescuentoEquipos__c != null)//Validamos no permitir guardar un descuento asociado a un equipo traido
                {
                    blnDtoEquipoTraido = true;
                }
            }
            if(blnCapturaDto)
            {
                objOportunidad.LTE_OfertaCustomizada__c = true;
            }
        }*/
        //Valida la cantidad total de planes respecto al numero de lineas de la informacion general
        if(!cantidadConsistente())
        {
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,Label.LTE_CantidadTotalPlanes));
            return null;
        }
        if(objOportunidad.Requiere_Pago_Mensualizado_Equipo__c == true){
            if(objOportunidad.Numero_de_cuotas__c == null){
                Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,Label.LTE_CuotasMensualesPendiente));
                return null;
            }
            if(!validaIngresoValorMensualEquipo('Requerido')){
                Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,Label.LTE_ValorMensualEquipoPendiente));
                return null;
            }            
        }
        if(objOportunidad.Requiere_Pago_Mensualizado_Equipo__c == false){
            if(objOportunidad.Numero_de_cuotas__c != null){
                if(objOportunidad.Numero_de_cuotas__c > 0){
                    Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,Label.LTE_CuotasMensualesNoRequerido));
                    return null;
                }
            }
            if(validaIngresoValorMensualEquipo('NoRequerido')){
                Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,Label.LTE_ValorMensualEquipoNoRequerido));
                return null;
            }  
        }
        if(blnDtoEquipoTraido)
        {
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'No debe capturar un descuento a un Equipo Traído!'));
            return null;
        }
        //Valida que no tenga marcado para eliminar ningun regisro de oferta
        if(!marcaEliminarConsistente())
        {
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'Tiene marcado un registro por eliminar, desactivo o gestione su borrado a través del botón eliminar '));
            return null;
        }
        //Verifica el numero de equipos con pago anticipado si la marca está activa
        if(objOportunidad.LTE_PagoAnticipado__c)
        {
            for(Reserva__c objReserva:lstOfertas)
            {
                if(objReserva.LTE_Equipos_Pago_Anticipado__c != null && objReserva.LTE_CantidadPlanes__c < objReserva.LTE_Equipos_Pago_Anticipado__c)
                {
                    Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,Label.LTE_EquiposPagosAnticipados.replace('##PagoA##', ''+objReserva.LTE_Equipos_Pago_Anticipado__c).replace('##CantidadPlanes##', ''+objReserva.LTE_CantidadPlanes__c)));
                    return null;
                }
            }
        }        
        //[FSARASTY, 2020/05/01]: Bolsas compartidas - verificar si la venta es de una bolsa compartida, y consumir el método para validación la conformación
        if(objOportunidad.LTE_Bolsa_Compartida__c){
            string resultValidacionBolsa = validarConfiguracionBolsaCompartida();
            if(resultValidacionBolsa != ''){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,resultValidacionBolsa));
                return null;
            }
        }
        //FIN [FSARASTY, 2020/05/01]: Bolsas compartidas
     
        try{
            asignarSVA();
            if(!lstOfertas.isEmpty())
            {
                eliminarPrepago();
                System.debug('lstOfertas-> '+lstOfertas);
                objOportunidad.EstadodeAprobacionDescuentos__c = null;
                upsert lstOfertas;
                update objOportunidad;
                System.debug('lstOfertas ->' + lstOfertas);
           }
            if(!lstOfertasBorrar.isEmpty())
            {
                List<Reserva__c> lstOfertasBorrarPersistidas = new List<Reserva__c>();
                for(Reserva__c objReserva:lstOfertasBorrar)
                {
                    if(objReserva.Id != null)
                    {
                        lstOfertasBorrarPersistidas.add(objReserva);    
                    }
                }
                if(!lstOfertasBorrarPersistidas.isEmpty())
                {
                    delete lstOfertasBorrarPersistidas;    
                }
            }
            tieneOferta = true;
            blnDetalleOfertaBoton=true;
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Confirm,Label.LTE_OfertaGuardada));
        }catch(exception e)
        {
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'Ocurrió el siguiente error guardando la oferta: '+e.getmessage()));
        }

        objOportunidad = getOportunidad();
        system.debug(objOportunidad);

        if(objOportunidad.LTE_OportunidadBloqueada__c)
        {
            blnBotonesGestion = false;
        }else{
            blnBotonesGestion = true;
        }
        
        getMostrarDetalleDesc();
        
        return null;
    }


    //Metodo que permite validar la cantidad general de lines de la oportunidad respecto al total registrado en la oferta economica
    public Boolean cantidadConsistente()
    {
        Boolean blnEsIgual = false;
        Decimal dcmTotal = 0;
        System.debug('#329 lstOfertas-> '+lstOfertas);
        for(Reserva__c objReserva:lstOfertas)
        {
           dcmTotal += objReserva.LTE_CantidadPlanes__c;
        }
        if(dcmTotal == objOportunidad.LTE_NumeroLinea__c)
        {
            blnEsIgual = true;
        }
        return blnEsIgual;
    }
    
    public Boolean validaIngresoValorMensualEquipo(string validarSeleccion)
    {
        Boolean blnRegistrosOk;
        if(validarSeleccion == 'Requerido')
        {
            blnRegistrosOk = true;        
            for(Reserva__c objReserva:lstOfertas)
            {
               if(objReserva.Valor_mensual_equipo__c == null)
                    blnRegistrosOk = false;
            }            
        }
        if(validarSeleccion == 'NoRequerido')
        {
            blnRegistrosOk = false;        
            for(Reserva__c objReserva:lstOfertas)
            {
               if(objReserva.Valor_mensual_equipo__c != null)
                    blnRegistrosOk = true;
            }            
        }                
        return blnRegistrosOk;
    }

    //Metodo que permite validar la cantidad general de lines de la oportunidad respecto al total registrado en la oferta economica
    public Boolean marcaEliminarConsistente()
    {
        Boolean blnSatisfactorio = true;
        
        for(Reserva__c objReserva:lstOfertas)
        {
           if(objReserva.LTE_Eliminar__c)
           {
                blnSatisfactorio = false;
           }
        }
        return blnSatisfactorio;
    }

    private class Respuesta
    {
        Boolean esSatisfactorio;
        String mensaje;
    }

    //Metodo que permite calcular el valor de la oferta
    public PageReference calcularOferta()
    {     
        List<Id> lstPlanes = new List<Id>();
        List<Id> lstSubPlanes = new List<Id>();
        List<Id> lstEquipos = new List<Id>();
        Decimal dcmValorPlanes = 0;
        Decimal dcmValorSubPlanes = 0;
        Decimal dcmValorEquipos = 0;
        
        valorEquiposPagoMensual=0;
        valorEquipos=0;
        valorPlanes=0;
        valorSva=0;
        
        ocultarDescuentoPlan();        
        for(Reserva__c objReserva:lstOfertas)
        {            
            lstEquipos.add(objReserva.Equipo__c);
            lstPlanes.add(objReserva.LTE_Plan__c);
            //Es plan a la medida
            if(objReserva.LTE_MinutoVoz__c != null)
            {
                lstSubPlanes.add(objReserva.LTE_MinutoVoz__c);
            }
            if(objReserva.LTE_DatosNavegacion__c != null)
            {
                lstSubPlanes.add(objReserva.LTE_DatosNavegacion__c);    
            }

            //Tiene bolsas recurrentes
            if(objReserva.LTE_BolsaRecurrenteVoz__c!= null)
            {
                lstSubPlanes.add(objReserva.LTE_BolsaRecurrenteVoz__c);
            }
            if(objReserva.LTE_BolsaRecurrenteDatos__c!= null)
            {
                lstSubPlanes.add(objReserva.LTE_BolsaRecurrenteDatos__c);
            }                        
        }

        if(!lstEquipos.isEmpty())
        {
            poblarMapaEquipos(lstEquipos);
        }
        if(!lstPlanes.isEmpty())
        {
            poblarMapaPlanes(lstPlanes);
        }
        if(!lstSubPlanes.isEmpty())
        {
            poblarMapaSubPlanes(lstSubPlanes);
        }


        for(Reserva__c objReserva:lstOfertas)
        {
            Decimal svaOferta=0;
            for(string key :mapSva.get(objReserva.LTE_Indice__c+'').keySet()){
                svaOferta+=mapSva.get(objReserva.LTE_Indice__c+'').get(key).subPlan.LTE_Precio__c;
            }
            valorSva+=(objReserva.LTE_CantidadPlanes__c *svaOferta);



            system.debug(objReserva.LTE_CantidadPlanes__c+' '+mpValoresPlanes+' '+objReserva.LTE_Plan__c);
            //Suma el valor de los planes
            dcmValorPlanes += (objReserva.LTE_CantidadPlanes__c * mpValoresPlanes.get(objReserva.LTE_Plan__c).Tarifa__c);
            valorPlanes += (objReserva.LTE_CantidadPlanes__c * mpValoresPlanes.get(objReserva.LTE_Plan__c).Tarifa__c);
            //Suma el valor de las bolsas
            if(objReserva.LTE_MinutoVoz__c != null)
            {
                dcmValorSubPlanes += (objReserva.LTE_CantidadPlanes__c * mpValoresSubPlanes.get(objReserva.LTE_MinutoVoz__c).LTE_Precio__c);
                valorPlanes+=objReserva.LTE_CantidadPlanes__c * mpValoresSubPlanes.get(objReserva.LTE_MinutoVoz__c).LTE_Precio__c;
            }
            if(objReserva.LTE_DatosNavegacion__c != null)
            {
                dcmValorSubPlanes += (objReserva.LTE_CantidadPlanes__c * mpValoresSubPlanes.get(objReserva.LTE_DatosNavegacion__c).LTE_Precio__c);    
                valorPlanes += (objReserva.LTE_CantidadPlanes__c * mpValoresSubPlanes.get(objReserva.LTE_DatosNavegacion__c).LTE_Precio__c);
            }
            /*
            if(objReserva.LTE_BolsaRecurrenteVoz__c!= null)
            {
                dcmValorSubPlanes += (objReserva.LTE_CantidadPlanes__c * mpValoresSubPlanes.get(objReserva.LTE_BolsaRecurrenteVoz__c).LTE_Precio__c);    
            }
            if(objReserva.LTE_BolsaRecurrenteDatos__c!= null)
            {
                dcmValorSubPlanes += (objReserva.LTE_CantidadPlanes__c * mpValoresSubPlanes.get(objReserva.LTE_BolsaRecurrenteDatos__c).LTE_Precio__c);    
            }
            */  

            //Suma el valor de los equipos si No está marcado como pago anticipado
            if(objReserva.LTE_Equipos_Pago_Anticipado__c != null && objReserva.LTE_CantidadPlanes__c >= objReserva.LTE_Equipos_Pago_Anticipado__c)
            {
                dcmValorSubPlanes += ( (objReserva.LTE_CantidadPlanes__c - objReserva.LTE_Equipos_Pago_Anticipado__c) * mpValoresEquipos.get(objReserva.Equipo__c).LTE_PrecioConIVA__c);        
                valorEquipos+=( (objReserva.LTE_CantidadPlanes__c - objReserva.LTE_Equipos_Pago_Anticipado__c) * mpValoresEquipos.get(objReserva.Equipo__c).LTE_PrecioConIVA__c);

            }else if(objReserva.LTE_Equipos_Pago_Anticipado__c != null && objReserva.LTE_CantidadPlanes__c < objReserva.LTE_Equipos_Pago_Anticipado__c)
            {
                Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'La cantidad de equipos con pago anticipado: '+objReserva.LTE_Equipos_Pago_Anticipado__c +' es mayor a la cantidad planes: '+objReserva.LTE_CantidadPlanes__c));
                return null;
            }
            else
            {
                system.debug(objReserva.Equipo__c+' '+objReserva.LTE_CantidadPlanes__c+' '+mpValoresEquipos);
                dcmValorSubPlanes += (objReserva.LTE_CantidadPlanes__c * mpValoresEquipos.get(objReserva.Equipo__c).LTE_PrecioConIVA__c);
                valorEquipos+=(objReserva.LTE_CantidadPlanes__c * mpValoresEquipos.get(objReserva.Equipo__c).LTE_PrecioConIVA__c);
                //valorEquipos+=mpValoresEquipos.get(objReserva.Equipo__c).LTE_PrecioConIVA__c;

            }
            // [FSARASTY, 01/02/2019]: sumar los valores de equipos mensualizado
            if(objOportunidad.Requiere_Pago_Mensualizado_Equipo__c == true && objOportunidad.Numero_de_cuotas__c != null && objReserva.Valor_mensual_equipo__c != null)
                valorEquiposPagoMensual+=((objReserva.Valor_mensual_equipo__c * objOportunidad.Numero_de_cuotas__c)*objReserva.LTE_CantidadPlanes__c);                        
        }
        if(valorEquiposPagoMensual > 0)
            valorEquipos = valorEquiposPagoMensual;
        
        objOportunidad.LTE_ValorOferta__c = valorEquipos + valorPlanes + valorSva;
        
        objOportunidad.LTE_Valor_equipos__c=valorEquipos;
        objOportunidad.LTE_Valor_planes__c=valorPlanes;
        objOportunidad.LTE_Valor_SVA__c=valorSva;
        
        
        //objOportunidad.LTE_ValorOferta__c = dcmValorPlanes + dcmValorSubPlanes;
        return null;
    }


    public void poblarMapaPlanes(List<Id> lstIds)
    {
        mpValoresPlanes = new map<Id, Planes__c>([SELECT Id,Tarifa__c,Name,LTE_PlanEstructurados__c,LTE_TipoControl__c FROM Planes__c WHERE Estado__c = 'Activo' AND Id IN:lstIds]);
    }

    public void poblarMapaSubPlanes(List<Id> lstIds)
    {
        mpValoresSubPlanes = new map<Id, SubPlanFacturacion__c>([SELECT Id,LTE_Precio__c FROM SubPlanFacturacion__c WHERE Id IN:lstIds]);
    }

    public void poblarMapaEquipos(List<Id> lstIds)
    {
        mpValoresEquipos = new Map<Id, Equipo__c>([SELECT Id,Valor_del_Equipo__c,LTE_PrecioConIVA__c FROM Equipo__c WHERE Id IN:lstIds]);
    }

    //Metodo para generar el detalle de la oferta y presentarla en la pagaina vf
    public PageReference detalleOferta()
    {

        if( objOportunidad.LTE_NumeroLinea__c<=intLimiteLineas ) //Y demás requisitos opp bloqueada o aprobada
        {
            Boolean blnExitoso = generarDetalleOferta();
            if(blnExitoso)
            {
                /*
                if(objOportunidad.LTE_OportunidadBloqueada__c){
                    Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Confirm,Label.LTE_ProcesoAprobacionOportunidad));                
                }
                */
                
                lstDetallesOferta = obtenerDetalleOferta();
                blnMostrarDetalles = true;
                blnDetalleOfertaBoton = false;
                blnGuardarDetalleBoton = true;
                
                Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Confirm,Label.LTE_Oferta_exitosa));
                return null;
            }
        } 
        //Metodo para generar el detalle de la oferta y descargar el archivo en formato csv desde la pagina vf
        if( objOportunidad.LTE_NumeroLinea__c>intLimiteLineas ) //Y demás requisitos opp bloqueada o aprobada
        {
            Boolean blnExitoso = generarDetalleOferta();
            if(blnExitoso)
            {
                /*PageReference pr = new PageReference( '/Apex/LTE_GenerarCSV_pag?Id='+objOportunidad.Id );
                pr.setRedirect( true );
                return pr;*/
                blnMostrarDetalles = false;
                blnDetalleOfertaBoton = false;
                blnGuardarDetalleBoton = false;
                blnExportarBoton = true;
            }   
        }
        
        //getMostrarDetalleDesc();
        return null;
    }

    /*
    public PageReference exportarOfertaCSV()
    {
        PageReference pr = new PageReference( '/Apex/LTE_GenerarCSV_pag?Id='+objOportunidad.Id );
         pr.setRedirect( true );
        return pr;
    }*/   
 
    //Genera el detalle de la oferta economica   
    public Boolean generarDetalleOferta()
    {
        calcularOferta();
        Boolean blnSatisfactorio = true;
        List<LTE_DetalleOferta__c> lstDetalleOferta = new List<LTE_DetalleOferta__c>();
        //Se recorren las ofertas para obtener el valor total de la oferta economica
        VariablesGlobales__c equipoTraidoLTE = VariablesGlobales__c.getValues('EquipoTraidoLTE');
        
        if(detallesOfertaExistentes()){
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error, Label.LTE_Concurrencia_Detalle_Oferta));
            return false;
        }
        
        Set<Id> lstIdEquipo = new Set<Id>();
        for(Reserva__c objReserva:lstOfertas)
        {
            if(objOportunidad.Requiere_Pago_Mensualizado_Equipo__c == true && objOportunidad.Numero_de_cuotas__c != null && objReserva.Valor_mensual_equipo__c != null){
                if(!lstIdEquipo.contains(objReserva.Equipo__c)){
                    lstIdEquipo.add(objReserva.Equipo__c);
                }
            }
        }
        Map<ID, Equipo__c> mapEquipo = new Map<ID, Equipo__c>([select Valor_del_Equipo__c, LTE_PrecioConIVA__c from Equipo__c where id=:lstIdEquipo]);
system.debug(objReserva.LTE_CantidadPlanes__c);
        for(Reserva__c objReserva:lstOfertas)
        {
            for(Integer i=0; i<objReserva.LTE_CantidadPlanes__c; i++)
            {
                Decimal dcmValorTotalPlan = mpValoresPlanes.get(objReserva.LTE_Plan__c).Tarifa__c;              
                LTE_DetalleOferta__c objDetalleOferta = new LTE_DetalleOferta__c();
                objDetalleOferta.LTE_Cliente__c = objOportunidad.AccountId;
                objDetalleOferta.LTE_Oferta_Economica__c = objReserva.Id;
                objDetalleOferta.LTE_ReferenciaEquipo__c = objReserva.Equipo__c;
                objDetalleOferta.LTE_DatosNavegacion__c = objReserva.LTE_DatosNavegacion__c;
                objDetalleOferta.LTE_DescuentoDatos__c = objReserva.LTE_DescuentoDatos__c;
                objDetalleOferta.LTE_DescuentoEquipos__c = objReserva.LTE_DescuentoEquipos__c;
                objDetalleOferta.LTE_DescuentoPlan__c = objReserva.LTE_DescuentoPlan__c;
                objDetalleOferta.LTE_DescuentoSVAs__c = objReserva.LTE_DescuentoSVA__c;
                objDetalleOferta.LTE_DescuentoSVAs_Voz__c = objReserva.LTE_DescuentoSVAs_Voz__c;
                objDetalleOferta.LTE_DescuentoVoz__c = objReserva.LTE_DescuentoVoz__c;
                objDetalleOferta.LTE_MinutoVoz__c = objReserva.LTE_MinutoVoz__c;
                objDetalleOferta.Plan__c = objReserva.LTE_Plan__c;
                objDetalleOferta.LTE_ReferenciaEquipo__c = objReserva.Equipo__c;
                //objDetalleOferta.LTE_BolsaRecurrenteVoz__c = objReserva.LTE_BolsaRecurrenteVoz__c;
                //objDetalleOferta.LTE_BolsaRecurrenteDatos__c = objReserva.LTE_BolsaRecurrenteDatos__c;
                objDetalleOferta.LTE_DescuentoSobreBolsaRecurrenteVoz__c = objReserva.LTE_DescuentoSobreBolsaRecurrenteVoz__c;
                objDetalleOferta.LTE_DescuentoSobreBolsaRecurrenteDatos__c = objReserva.LTE_DescuentoSobreBolsaRecurrenteDatos__c;
                
                //[FSARASTY, 2020/05/01]: Bolsas compartidas - Actualizar tipo de línea
                if(objOportunidad.LTE_Bolsa_Compartida__c){                    
                    if(objReserva.Tipo_linea_bolsa_compartida__c == 'Hijas')
                        objDetalleOferta.Tipo_linea_bolsa_compartida__c = 'Hija';
                    else
                        objDetalleOferta.Tipo_linea_bolsa_compartida__c = objReserva.Tipo_linea_bolsa_compartida__c;
                }
                //FIN [FSARASTY, 2020/05/01]
                
                //si es prepago se elimina
                if(lstPlapre.get(objDetalleOferta.Plan__c)!=null){
                    objDetalleOferta.LTE_SvaJSON__c=null;
                }else{
                    objDetalleOferta.LTE_SvaJSON__c = objReserva.LTE_SvaJSON__c;
                }



                //objDetalleOferta.LTE_Sucursal__c = objReserva.Oportunidad__r.LTE_Sucursal__c;
                if(objDetalleOferta.LTE_ReferenciaEquipo__c==equipoTraidoLTE.Valor__c){
                    objDetalleOferta.LTE_EquipoTraido__c=true;
                }
                //Se calcula el valor total del plan: valor plan mas bolsas
                if(objReserva.LTE_MinutoVoz__c != null)
                {
                    dcmValorTotalPlan +=  mpValoresSubPlanes.get(objReserva.LTE_MinutoVoz__c).LTE_Precio__c;
                }
                if(objReserva.LTE_DatosNavegacion__c != null)
                {
                    dcmValorTotalPlan += mpValoresSubPlanes.get(objReserva.LTE_DatosNavegacion__c).LTE_Precio__c;    
                }
                objDetalleOferta.LTE_Valor_Total_Plan__c = dcmValorTotalPlan;
                
                //[FSARASTY, 05/02/2019]: Validar y calcular asignación de precios de equipos mensualizados.                                
                if(objOportunidad.Requiere_Pago_Mensualizado_Equipo__c == true && objOportunidad.Numero_de_cuotas__c != null && objReserva.Valor_mensual_equipo__c != null){
                    objDetalleOferta.Valor_Equipo_Mensualizado__c = true;       
                    objDetalleOferta.Numero_de_cuotas__c = objOportunidad.Numero_de_cuotas__c;
                    objDetalleOferta.LTE_ValorDespuesImpuestoIVA__c = (objReserva.Valor_mensual_equipo__c * objOportunidad.Numero_de_cuotas__c);
                    objDetalleOferta.LTEValorEquipoDescuento__c     = (objReserva.Valor_mensual_equipo__c * objOportunidad.Numero_de_cuotas__c);
                    if(mapEquipo.containsKey(objDetalleOferta.LTE_ReferenciaEquipo__c)){
                        objDetalleOferta.LTE_ValorAntesImpuestosparaEquipo__c =  calcularValorEquipoSinImpuestos(objDetalleOferta.LTE_ReferenciaEquipo__c,objDetalleOferta.LTE_ValorDespuesImpuestoIVA__c, mapEquipo.get(objDetalleOferta.LTE_ReferenciaEquipo__c));
                    }else{
                        objDetalleOferta.LTE_ValorAntesImpuestosparaEquipo__c = 0;
                    }
                }                                
                lstDetalleOferta.add(objDetalleOferta);               
            }
        }

        try{
            if(!lstDetalleOferta.isEmpty())
            {
                blnBotonesGestion = false;
                System.debug('lstDetalleOferta-> '+lstDetalleOferta);
                upsert lstDetalleOferta;
               // mostrarSVA(lstDetalleOferta); // AL
            }
        }catch(exception e)
        {
            System.debug('Ocurrió el siguiente error guardando los detalles de oferta: '+e.getmessage());
            blnSatisfactorio = false;
        }
        return blnSatisfactorio;
    }
    
    public boolean detallesOfertaExistentes(){
        Integer cantRegistros = [SELECT count() FROM LTE_DetalleOferta__c 
                                 WHERE LTE_Oferta_Economica__r.Oportunidad__c=:objOportunidad.Id];   
        
        if(cantRegistros > 0 ){
            return true;
        } else{
            return false;
        }
    }

    //Consulta los detalles de oferta a partir de la oportunidad
    List<LTE_DetalleOferta__c> obtenerDetalleOferta()
    {
        return [SELECT Id,LTE_EquipoTraido__c,LTE_IMEI__c,LTE_NumeroLinea__c, LTE_Oferta_Economica__c,Plan__r.Name,
                    LTE_MinutoVoz__r.Name, LTE_DatosNavegacion__r.Name,NumeracionM2M__c,
                    LTE_ReferenciaEquipo__c,LTE_RequierePortacion__c,Plan__c,LTE_Estado__c,LTE_Sucursal__c,LTE_Sucursal__r.Name,
                    LTE_Estado_Detalle_Oferta__c, LTE_Donante__c, LTE_SolicitadoPorTercero__c, LTE_Cliente__c, LTE_Tipo_de_Servicio__c,LTE_ContactoEntrega__c,
                    Tipo_linea_bolsa_compartida__c, LTE_Componente_de_la_Campana__c, LTE_SvaJSON__c//, Name, LTE_CampanaBolsaRecurrenteDatos__c, LTE_CampanaBolsaRecurrenteVoz__c,  // AL
                    //LTE_BolsaRecurrenteDatos__c, LTE_BolsaRecurrenteVoz__c, LTE_BolsaRecurrenteDatos__r.Name, LTE_BolsaRecurrenteVoz__r.Name // AL
                FROM LTE_DetalleOferta__c 
                WHERE LTE_Oferta_Economica__r.Oportunidad__c=:objOportunidad.Id ORDER BY Plan__c];        
    }

    //Metodo para actualizar los campos del detalle de oferta
    public PageReference guardarDetalle()
    {
        try{
            //if(validarSucursal())
            //{
            //    Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'El campo Sucursal debe ser diligenciado'));
            //    return null;
            //}
            if(validarIMEI() != '')
            {
                Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,Label.LTE_ValidarIMEI+validarIMEI()));
                return null;
            }
            if(!lstDetallesOferta.isEmpty())
            {
                System.debug('lstDetallesOferta-> '+lstDetallesOferta);
                upsert lstDetallesOferta;
                
                //lstDetallesOferta = obtenerDetalleOferta();
            }

            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Confirm,'El detalle de oferta se ha guardado satisfactoriamente!'));
        }catch(exception e)
        {
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'Ocurrió el siguiente error guardando el detalle de oferta: '+e.getmessage()));
        }



        return null;
    }

    //Metodo para validar IMEIs
    public String validarIMEI()
    {
        String strIMEIs= '';
        for(LTE_DetalleOferta__c objDetalle :lstDetallesOferta)
        {
            if(objDetalle.LTE_IMEI__c != null)
            {
                Boolean blnIsSuccess = LTE_LibreriaUtilitaria_cls.checkImei(objDetalle.LTE_IMEI__c);
                if(!blnIsSuccess)
                {
                    strIMEIs+= ' '+objDetalle.LTE_IMEI__c;
                }  
            }
        }
        return strIMEIs;
    }

    //Metodo para validar que el campo Sucursal no esta vacio
    //public Boolean validarSucursal()
    //{
    //    Boolean blnSucursalVacia = false;
    //    system.debug('LISTA DESTALLES----- ' + lstDetallesOferta);
    //    for(LTE_DetalleOferta__c objDetalle :lstDetallesOferta)
    //    {
    //        system.debug('SUCURSAL---' + objDetalle.LTE_Sucursal__c);
    //        if(objDetalle.LTE_Sucursal__c == null || objDetalle.LTE_Sucursal__c == '')
    //        {
    //            system.debug('ENTRO IF---');
    //            blnSucursalVacia = true;
    //        }
    //    }
    //    system.debug('Sucursal vacia-----' + blnSucursalVacia);
    //    return blnSucursalVacia;   
    //}

    //Metodo que actualiza los valores de los descuentos
    public PageReference actualizarTabla()
    {
        System.debug('strType-> '+strType);
        System.debug('strNivelId-> '+strNivelId);
        System.debug('strNivel-> '+strNivel);
        System.debug('intRow-> '+intRow);
        
        for(Reserva__c objReserva:lstOfertas)
        {
            if( objReserva.LTE_Indice__c == intRow )
            {
                if(strType.equals('DtoPlan') && !strNivelId.equals(''))
                {
                    objReserva.LTE_DescuentoPlan__c = strNivelId;
                    objReserva.LTE_DescuentoPlanAux__c = strNivel;  
                }
                if(strType.equals('DtoVoz') && !strNivelId.equals(''))
                {
                    objReserva.LTE_DescuentoVoz__c = strNivelId;
                    objReserva.LTE_DescuentoVozAux__c = strNivel;  
                }
                if(strType.equals('DtoDato') && !strNivelId.equals(''))
                {                    
                    objReserva.LTE_DescuentoDatos__c = strNivelId;
                    objReserva.LTE_DescuentoDatosAux__c = strNivel;  
                }
                if(strType.equals('DtoSVA') && !strNivelId.equals(''))
                {
                    objReserva.LTE_DescuentoSVA__c = strNivelId;
                    objReserva.LTE_DescuentoSVAAux__c = strNivel;  
                }
                if(strType.equals('DtoSVAVoz') && !strNivelId.equals(''))
                {
                    objReserva.LTE_DescuentoSVAs_Voz__c = strNivelId;
                    objReserva.Descuento_SVAs_Voz_Aux__c = strNivel;  
                }
                if(strType.equals('BolsaVoz') && !strNivelId.equals(''))
                {
                    objReserva.LTE_DescuentoSobreBolsaRecurrenteVoz__c = strNivelId;
                    objReserva.LTE_DescuentoBolsaVozAux__c = strNivel;  
                }
                if(strType.equals('BolsaDatos') && !strNivelId.equals(''))
                {
                    objReserva.LTE_DescuentoSobreBolsaRecurrenteDatos__c = strNivelId;
                    objReserva.LTE_DescuentoBolsaDatosAux__c = strNivel;  
                }
            }
        }
        return null;
    }
    
    public List<SelectOption> getItems() {
        list<SubPlanFacturacion__c> subPlan =new list<SubPlanFacturacion__c>([select Id,Name from SubPlanFacturacion__c where LTE_TipoSubplan__c='SVAs']);
        
        List<SelectOption> options = new List<SelectOption>();
        for(SubPlanFacturacion__c sp:subPlan){
            options.add(new SelectOption(sp.Id,sp.Name));       
        }
        
        return options;
    }
        
    public pagereference ocultaColumnasPortabilidad()
    {
        return null;
    }
    
    
    /********************************************************************
     * Obtiene todos los planes compuestos, estos planes estan en una configuracion 
     * personalizada (MC)
     *******************************************************************/ 
    private PlanCompuestoWrapper getConfiguracionPlanIlimitados(Planes__c plan){
        PlanCompuestoWrapper wrapper = null;
        List<SubPlanFacturacion__c> lstSubPlan = null;
        if(plan != null && plan.Name != null ){
            for(LTE_Planes_Compuestos__c objPla : LTE_Planes_Compuestos__c.getall().values()){
                if(plan.Name.equals(objPla.Name)){
                    wrapper = new PlanCompuestoWrapper();
                    //No hay problema que se haga el select dentro de este for ya que al primer
                    //valor que concuerde sale del método
                    lstSubPlan = [SELECT Id, Name FROM SubPlanFacturacion__c WHERE Name = :objPla.MinutosVoz__c];
                    if(lstSubPlan.size() > 0){
                        wrapper.minutosVoz = lstSubPlan[0];
                    }
                    lstSubPlan = [SELECT Id, Name FROM SubPlanFacturacion__c WHERE Name = :objPla.DatosNavegacion__c];
                    if(lstSubPlan.size() > 0){
                        wrapper.datosNavegacion = lstSubPlan[0];
                    }
                    return wrapper;
                }
            } 
        }
        
        return wrapper;
    }
    
    /*******************************************************
     * Clase Wrapper para agrupar los subplanes de un plan de factuacion
     ******************************************************/ 
    public class PlanCompuestoWrapper{
        SubPlanFacturacion__c minutosVoz;
        SubPlanFacturacion__c datosNavegacion;
    }
    
    //[CA] 07/09/2015
    public PageReference ocultarDescuentoPlan()
    {   
        //Se obtienen el listado de ID de los planes seleccionados.
        Set<Id> setIdPlanes = new Set<Id>();
        Planes__c objPlanTmp = null;
        PlanCompuestoWrapper planIlimitadwp = null; //Configuracion Personalizada
        Integer contador = 0;
        for(Reserva__c objOferta : lstOfertas){
            setIdPlanes.add(Id.valueof(objOferta.LTE_Plan__c));
        }
        
        Map<Id, Planes__c> mapPlanes = new Map<Id, Planes__c>([SELECT Id,Name , LTE_Es_Plan_Compuesto__c FROM Planes__c WHERE Id IN :setIdPlanes]); 
        
        System.debug('Map de planes: ' + mapPlanes);
        list<Planes__c> lstPlan = new list<Planes__c>();
        list<String> lstIdDescuentos = new list<String>();
        
        for(Reserva__c objOferta: lstOfertas)
        {
            objPlanTmp = mapPlanes.get(Id.valueOf(objOferta.LTE_Plan__c));
            
            system.debug('objOferta.LTE_Plan__c ---> ' + objOferta.LTE_Plan__c);
            system.debug('objPlanTmp ---> ' + objPlanTmp);
            
            //Se debe redefinir la refencia al plan ya que para los casos en los que se
            //haya consultado desde base de datos no cambia el plan cuando se selecciona
            //uno diferente desde la visualforce
            objOferta.LTE_Plan__r = objPlanTmp;
            objOferta.LTE_Plan__c = objPlanTmp.Id;
            objOferta.LTE_DatosNavegacionConfigurado__c = false;
            objOferta.LTE_MinutosVozConfigurado__c = false;
            if(objOferta.LTE_Plan__c != null && objPlanTmp.LTE_Es_Plan_Compuesto__c)
            {   
                planIlimitadwp = getConfiguracionPlanIlimitados(objPlanTmp);
                System.debug('planIlimitadwp ' + planIlimitadwp);
                if(planIlimitadwp != null){
                    
                    if(planIlimitadwp.minutosVoz != null){
                        objOferta.LTE_MinutoVoz__c = planIlimitadwp.minutosVoz.Id;
                        objOferta.LTE_MinutosVozConfigurado__c = true;
                    }
                    
                    if(planIlimitadwp.datosNavegacion != null){
                        objOferta.LTE_DatosNavegacion__c = planIlimitadwp.datosNavegacion.Id;
                        objOferta.LTE_DatosNavegacionConfigurado__c = true;
                    }
                    
                }
                
                objOferta.LTE_PlanMedida__c = true;
                system.debug('NIVEL DE DESCUENTO---->' + objOferta.LTE_DescuentoPlan__c);
                if(objOferta.LTE_DescuentoPlan__c != null)
                {
                    objOferta.LTE_DescuentoPlanAux__c = '';
                    lstIdDescuentos.add(objOferta.LTE_DescuentoPlan__c);
                    objOferta.LTE_DescuentoPlan__c = null;
                }
            }
            else
            {
                objOferta.LTE_PlanMedida__c = false;
                objOferta.LTE_MinutoVoz__c = null;
                objOferta.LTE_DatosNavegacion__c = null;
                if(objOferta.LTE_DescuentoDatos__c != null )
                {
                    objOferta.LTE_DescuentoDatosAux__c = '';
                    lstIdDescuentos.add(objOferta.LTE_DescuentoDatos__c);
                    objOferta.LTE_DescuentoDatos__c = null;
                }
                if(objOferta.LTE_DescuentoVoz__c != null)
                {
                    objOferta.LTE_DescuentoVozAux__c = '';
                    lstIdDescuentos.add(objOferta.LTE_DescuentoVoz__c);
                    objOferta.LTE_DescuentoVoz__c = null;
                }                
            }
            contador++;
            
        System.debug('objReserva.LTE_Plan__c ' + objOferta.LTE_Plan__c);
        System.debug('objReserva.LTE_Plan__r.Id ' + objOferta.LTE_Plan__r.Id);
        }
        
        System.debug('Fin del metodo');
        
        
        if(!lstIdDescuentos.isEmpty())
            borrarDescuentos(lstIdDescuentos);
        return null;
    }
    
    public void getMostrarDetalleDesc(){
        
        /*if(tieneOferta && objOportunidad.LTE_RequiereDescuentos__c==true && objOportunidad.EstadodeAprobacionDescuentos__c=='Aprobado'){
            blnDetalleOfertaBoton=true;
            blnOferta=false;
            numLineas=false;
        }*/
        if(tieneOferta && objOportunidad.LTE_OportunidadBloqueada__c==false && objOportunidad.EstadodeAprobacionDescuentos__c != null && objOportunidad.EstadodeAprobacionDescuentos__c=='Aprobado'){
            if(!lstDetallesOferta.isEmpty())
            {
                blnDetalleOfertaBoton=false;
                blnGuardarDetalleBoton = true;
            }
            else
            {
                blnDetalleOfertaBoton=true;
                blnGuardarDetalleBoton = false;
            }
        }
        if(tieneOferta && objOportunidad.LTE_OportunidadBloqueada__c){
            blnDetalleOfertaBoton=false;
            blnGuardarDetalleBoton = false;
        }

        if(UserInfo.getProfileId()==vgLob.Valor__c)
        {
            blnDetalleOfertaBoton=false;
            blnGuardarDetalleBoton = false;
        }
        
    }
    

    public void borrarDescuentos (List<String> lstIdDescuentos)
    {
        list<LTE_NivelesDescuento__c> lstDescuentosBorrar = new list<LTE_NivelesDescuento__c>();
         
        for (String strIdDescuento : lstIdDescuentos)
        {
            LTE_NivelesDescuento__c objDescuentoBorrar = new LTE_NivelesDescuento__c(Id = strIdDescuento);
            lstDescuentosBorrar.add(objDescuentoBorrar); 
        }
        system.debug('LISTA A BORRAR -------' + lstDescuentosBorrar);
        Delete lstDescuentosBorrar;
    }
    //FIN [CA]
    
    //SVA
    private class filtroClass{
        string valorDefecto='';
        string url='';    
        string tipo=''; 
    }
    
    public string getFiltros(Map<String, LTE_SVA__c> sva){
        list<filtroClass> fMap=new list<filtroClass>(); 
        Schema.DescribeSObjectResult r = SubPlanFacturacion__c.sObjectType.getDescribe();
        for(string s:sva.keySet()){
            if(sva.get(s).LTE_Disponible_venta_incial__c){
                filtroClass fc=new filtroClass();
                fc.valorDefecto=sva.get(s).LTE_Valor_Defecto__c;
                fc.url=Site.getBaseUrl()+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where LTE_TipoSubplan__c =\''+s+'\' ')+'&f='+filtro_cls.codificar(',Name,LTE_TipoSubplan__c')+'&nom='+filtro_cls.codificar('SVA,Tipo SVA')+'&infoParam=';     
                fc.tipo=s;
                fMap.add(fc);
            }
            
        }   
        return  JSON.serialize(fMap);
    }
    
    
    
    
    public list<SelectOption> getOptionsSva(){
        
        Map<String, LTE_SVA__c> sva = LTE_SVA__c.getAll();
        filtros=getFiltros(sva);
        
        
        set<string> optionsSva=new set<string>();
        list<SelectOption> optLst=new list<SelectOption>();
        
        for(string s:sva.keySet()){
            if(sva.get(s).LTE_Disponible_venta_incial__c){
                optionsSva.add(sva.get(s).name);
            }
        }
        
        list<SelectOption> options = new List<SelectOption>();
        for(string opt:optionsSva){
            optLst.add(new SelectOption(opt,opt));                  
        }
        optLst.sort();
        
        return optLst;              
    }
    
    
    
    public class svaObj{
        public SubPlanFacturacion__c subPlan{get;set;}
    }

    
    public list<SelectOption> svaOptions{get; set;}
    public map<string,map<string,svaObj>> mapSva{get; set;}
    public map<string,string> mapJson{get; set;}

    public string svaInfo{get; set;}
    public string svaIndice{get; set;}
    public string svaTipo{get; set;}
    public string filtros{get;set;}
    public Decimal valorEquipos{get;set;}
    public Decimal valorEquiposPagoMensual{get;set;} //[FSARASTY,01/02/2019]
    public Decimal valorPlanes{get;set;}
    public Decimal valorSva{get;set;}

    public pagereference guardarSVA(){
        system.debug(svaInfo);
        system.debug(svaIndice);
        
        
        list<SubPlanFacturacion__c> svaData=new list<SubPlanFacturacion__c>([Select id,LTE_TipoSubplan__c,Name,LTE_Precio__c from SubPlanFacturacion__c where id=:svaInfo limit 1]);
        if(!svaData.isEmpty()){
            
            svaObj s =new svaObj();
            s.subPlan=svaData[0];
            mapSva.get(svaIndice).put(svaData[0].LTE_TipoSubplan__c,s); 

            mapJson.put(svaIndice,JSON.serialize(mapSva.get(svaIndice)));



            system.debug(Json.serialize(svaData));      
        }
        
       

        return null;
    }
    
    public pagereference eliminarSVA(){
        
        mapSva.get(svaIndice).remove(svaTipo);

        mapJson.put(svaIndice,JSON.serialize(mapSva.get(svaIndice)));



        
        return null;
    
    }

    public void asignarSVA(){


        for(Reserva__c objReserva:lstOfertas)
        {
            system.debug('objReserva -> ' + objReserva);
            List<string> listaSVA=new List<string>();
            system.debug('mapSva -> ' + mapSva);
            if(mapSva.get(objReserva.LTE_Indice__c+'')!=null){
                map<string,svaObj> elSva=mapSva.get(objReserva.LTE_Indice__c+'');
                objReserva.LTE_SvaJSON__c=JSON.serialize(elSva);
            }

            mapJson.put(objReserva.LTE_Indice__c+'',JSON.serialize(mapSva.get(objReserva.LTE_Indice__c+'')));
            
        }

    }

    public void obtenerSVA(){

        set<string> idSVA=new set<string>();
        
        for(Reserva__c objReserva:lstOfertas) 
        {
            if(objReserva.LTE_Indice__c!=null){
                map<string,svaObj> svaMap=new map<string,svaObj>();
                if(objReserva.LTE_SvaJSON__c==null){
                    svaMap=new map<string,svaObj>();
                }else{
                    svaMap=(map<string,svaObj>)JSON.deserialize(objReserva.LTE_SvaJSON__c, map<string,svaObj>.class);
                }
                mapSva.put(objReserva.LTE_Indice__c+'',svaMap);
                
            }

            mapJson.put(objReserva.LTE_Indice__c+'',JSON.serialize(mapSva.get(objReserva.LTE_Indice__c+'')));

        }


        //mapName.put();

    }

    @RemoteAction
    public static response automaticoSVA(string sva,string idEquipo,string index){

        response r=new response();
        
        if(sva=='SVA-Seguro de terminales'){
            list<Equipo__c> equipo= new list<Equipo__c>([select LTE_SVASeguro__r.Name,LTE_SVASeguro__r.LTE_Precio__c,Name, LTE_SVASeguro__c from Equipo__c where id=:idEquipo]);

            if(!equipo.isEmpty()){
               r.obj=equipo[0];
                if(equipo[0].LTE_SVASeguro__c==null){
                    r.error=Label.LTE_Error_seguros;
                }
                r.index=index;
            }



        }

        return r;
    }

    public class response{
        string tipo='';
        string index='';
        string error='';
        sobject obj;
    }

    public string getPrepago(){

        list<id> lid=new list<id>();

        for(string p:lstPlapre.keySet()){
            lid.add(lstPlapre.get(p).id);
        }

        return JSON.serialize(lid);
    }


    public void eliminarPrepago(){

        for(Reserva__c objReserva:lstOfertas){

            if(lstPlapre.get(objReserva.LTE_Plan__c)!=null){
                objReserva.LTE_SvaJSON__c=null;
            }
       }
    }

    public map<id,Planes__c> lstPlapre{
        get{
            system.debug(lstPlapre);
            if(lstPlapre==null){
                map<id,Planes__c> lst=new map<id,Planes__c>([select id from Planes__c where LTE_MetodoDePago__c='PREPAGO']);
                lstPlapre=lst;
            }

            return lstPlapre;
        }
        set;
    }
    
    /**
    * Metodo usado para abrir la emergente de los APN.
    */
    public string getURLAPN(){
        String sProductoAPN = vGlobal.get('NombreComercialAPN').valor__c;
        Schema.DescribeSObjectResult r = ActivoETB__c.sObjectType.getDescribe();
        return  Site.getBaseUrl()+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Plan__r.NombredelProducto__r.Name = \''+sProductoAPN+'\' AND NombredelaCuenta__c = \''+this.objOportunidad.AccountId+'\' AND Estado__c = \'Activo\' ')+'&f='+filtro_cls.codificar(',Name,IDservicio__c,APN__r.APN_Cliente_Virtual__c,APN__r.Name,Tipo_de_APN__c,Tipo_de_Plan_APN__c')+'&nom='+filtro_cls.codificar('Servicio APN,Id Servicio,APN Cliente (Virtual),APN,Tipo APN,Tipo de Plan APN')+'&infoParam=APN';  
    }
    
    /**
    * Metodo usado para abrir la emergente de las Sucursales.
    */
    public string getURLSucursales(){
        Schema.DescribeSObjectResult r = Account.sObjectType.getDescribe();
        return  Site.getBaseUrl()+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where RecordType.Name = \'Sucursales\' AND Cuenta__c = \''+this.objOportunidad.AccountId+'\' ')+'&f='+filtro_cls.codificar(',Name,RecordType.Name')+'&nom='+filtro_cls.codificar('Sucursal,tt')+'&infoParam=SRL';
    }
    
    /**
    * Metodo usado para abrir la emergente de los contactos.
    */
    public string getURLContactos(){
        Schema.DescribeSObjectResult r = Contact.sObjectType.getDescribe();
        return  Site.getBaseUrl()+'/apex/Filtro?id='+r.getKeyPrefix()+'&c='+Filtro_cls.codificar(' Where Account.Id = \''+this.objOportunidad.AccountId+'\' ')+'&f='+filtro_cls.codificar(',Name,RecordType.Name')+'&nom='+filtro_cls.codificar('Contacto,tt')+'&infoParam=CNT';
    }
    
    /**
    * Clase para almacenar los APN seleccionadas
    */
    public class LTE_APNWrapper {
        public Id IdAPN             {get;set;}
        public String NameAPN       {get;set;}
        public Id IdContacto        {get;set;}
        public String NameContacto  {get;set;}
        public Id IdSucursal        {get;set;}
        public String NameSucursal  {get;set;}
    }
    
    /**
    * Metodo encargado de asignar el valor respectivo desde la emergente de APN
    */
    public PageReference actualizarAPN(){
        if(String.isBlank(strNivelAPNId)){
            strNivelAPNId = null;
        }
        if(String.isNotBlank(strInfoParamAPN) && strInfoParamAPN == 'APN'){
            this.objAPN.IdAPN = strNivelAPNId;
            this.objAPN.NameAPN = strNivelAPN;
            this.objOportunidad.Servicio_APN_Relacionado__c = strNivelAPNId;
        }
        if(String.isNotBlank(strInfoParamAPN) && strInfoParamAPN == 'CNT'){
            this.objAPN.NameContacto = strNivelAPN;
            this.objAPN.IdContacto = strNivelAPNId;
        }
        if(String.isNotBlank(strInfoParamAPN) && strInfoParamAPN == 'SRL'){
            this.objAPN.NameSucursal = strNivelAPN;
            this.objAPN.IdSucursal = strNivelAPNId;
        }
        return null;
    }

    //Metodo para actualizar los campos del detalle de oferta
    public PageReference SeleccionMasiva()
    {
        try{
            if(!lstDetallesOferta.isEmpty())
            {
                System.debug('lstDetallesOferta-> '+lstDetallesOferta);
                
                for(LTE_DetalleOferta__c objDetalle :lstDetallesOferta)
                {
                    objDetalle.LTE_Sucursal__c = this.objAPN.IdSucursal;
                    objDetalle.LTE_ContactoEntrega__c = this.objAPN.IdContacto;
                }
                update lstDetallesOferta;
            }
        }catch(exception e)
        {
            Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Error,'Ocurrió el siguiente error guardando el detalle de oferta: '+e.getmessage()));
        }
        return null;
    } 
    
    public static Decimal calcularValorEquipoSinImpuestos(String idEquipo, Decimal PrecioEquipoConIvan, Equipo__c equipo){
        
        Decimal ValorEquipo, ValorEquipoSinIva, valorIvaEquipo, ValorCalcEquipoSinIva;
        ValorEquipo             = 0;
        ValorEquipoSinIva       = 0;
        valorIvaEquipo          = 0;
        ValorCalcEquipoSinIva   = 0;
        
        ValorEquipo         = equipo.LTE_PrecioConIVA__c;
        ValorEquipoSinIva   = equipo.Valor_del_Equipo__c;
        
        if(ValorEquipoSinIva > 0 && ValorEquipo > 0 && PrecioEquipoConIvan > 0){
            valorIvaEquipo = ((ValorEquipo/ValorEquipoSinIva)*100)-100;                
            ValorCalcEquipoSinIva = ((PrecioEquipoConIvan * 100)/(100+valorIvaEquipo)).setScale(0);                
        }    
        return ValorCalcEquipoSinIva;
    }
    
    public PageReference validaSeleccionFlgs()
    { 
        if(objOportunidad.LTE_RequiereDescuentos__c || objOportunidad.LTE_PagoAnticipado__c){
            blnFlgMensualizado = true;
            objOportunidad.Requiere_Pago_Mensualizado_Equipo__c = false;
        }else
            blnFlgMensualizado = false;
        
        if(objOportunidad.Requiere_Pago_Mensualizado_Equipo__c){
            blnContinuarFlags = true;    
            objOportunidad.LTE_RequiereDescuentos__c = false;
            objOportunidad.LTE_PagoAnticipado__c = false;
        }else
            blnContinuarFlags = false;
        
        //[FSARASTY, 2020/05/01]: Bolsas compartidas
        if(objOportunidad.LTE_Bolsa_Compartida__c && !blnContinuar)
            blnFlgControlesBolsaCompartida = true;
        else
            blnFlgControlesBolsaCompartida = false;
        //FIN [FSARASTY, 2020/05/01]: Bolsas compartidas
        
        return null;
    }
    public PageReference cerrarPagina(){        
        String url;
        url = '/'+objOportunidad.Id;        
        PageReference page = new PageReference(url);
        return page;
    } 
    //[FSARASTY, 2020/05/01]: Bolsas compartidas   
    public string validarConfiguracionBolsaCompartida(){
        Set<Id> setIdPlanReserva    = new Set<Id>();
        Set<Id> setIdBolsaReserva   = new Set<Id>();
        Integer totalLineasHijas    = 0;
        Integer totalLineasPadre    = 0;
        String  resultadoValidacion = '';
        Boolean existeItemLineaHija = false;
        string errorPlan            = '';
        string errorBolsa           = '';
        //Planes__c objPlan;
        List<Planes__c>             listPlanes  = new List<Planes__c>();
        List<SubPlanFacturacion__c> listBolsas  = new List<SubPlanFacturacion__c>();
        
        // Validar cantidad de línas hijas        
        for(Reserva__c objReserva:lstOfertas){              
            /*objPlan = [SELECT Name, Plan_disponible_para_bolsa_compartida__c FROM Planes__c Where Id =: objReserva.LTE_Plan__c];
            if(!objPlan.Plan_disponible_para_bolsa_compartida__c){
                errorPlan = Label.Param_BolsaCompartida_ValidarPlan.replace('%nombrePlan%',objPlan.Name);
                break;
            }else{*/
                if(objReserva.Tipo_linea_bolsa_compartida__c == 'Hijas'){
                    existeItemLineaHija = true;
                    totalLineasHijas += integer.valueof(objReserva.LTE_CantidadPlanes__c);                                
                }
                if(objReserva.Tipo_linea_bolsa_compartida__c == 'Padre'){                
                    totalLineasPadre += integer.valueof(objReserva.LTE_CantidadPlanes__c);
                    setIdPlanReserva.add(objReserva.LTE_Plan__r.Id);
                    
                    if(objReserva.LTE_DatosNavegacion__c != null)                        
                        setIdBolsaReserva.add(objReserva.LTE_DatosNavegacion__c);
                }               
           // }             
        }        
        // validar si el plan aplica para bolsas compartidas:
        listPlanes = [SELECT Name, Plan_disponible_para_bolsa_compartida__c FROM Planes__c Where Id IN: setIdPlanReserva and Plan_disponible_para_bolsa_compartida__c = false];
        if(listPlanes.size() > 0)
           errorPlan = Label.Param_BolsaCompartida_ValidarPlan.replace('%nombrePlan%',listPlanes[0].Name);
                
        if(setIdBolsaReserva.size()>0){
            listBolsas = [Select Name, Bolsa_disponible_para_bolsa_compartida__c FROM SubPlanFacturacion__c Where Id IN:setIdBolsaReserva and Bolsa_disponible_para_bolsa_compartida__c = false];
            if(listBolsas.size()>0)
                errorBolsa = Label.Param_BolsaCompartida_ValidarBolsa.replace('%nombreBolsa%',listBolsas[0].Name);
        }
        
        if(errorPlan != ''){
            resultadoValidacion = errorPlan;
        }else if(errorBolsa != ''){            
            resultadoValidacion = errorBolsa;
        }else if(!existeItemLineaHija){ 
            resultadoValidacion = Label.Param_BolsaCompartida_ValidarItemLineasHijas;
        }else if(totalLineasHijas < integer.valueof(Label.Param_BolsaCompartida_cant_minima)){
            resultadoValidacion = Label.Param_BolsaCompartida_ValidarCantMinima.replace('%cantidad%',Label.Param_BolsaCompartida_cant_minima);
        }else if(totalLineasHijas > integer.valueof(Label.Param_BolsaCompartida_cant_maxima)){
            resultadoValidacion = Label.Param_BolsaCompartida_ValidarCantMaxima.replace('%cantidad%',Label.Param_BolsaCompartida_cant_maxima);
        } else if(totalLineasPadre <> 1 && BolsaCompartidaExistente == 'Nueva'){
            resultadoValidacion = Label.Param_BolsaCompartida_ValidarCantLineasPadre;
        }       
        return resultadoValidacion;
    }
    //FIN [FSARASTY, 2020/05/01]: Bolsas compartidas

    // Inicio Astrid y Omar -INI 876 Fase II
    //Metodo que muestra las promociones asociadas a un plan durante el porceso de venta predominando la de convenio su tiene activo el check de aplica convenio en la cuenta
    public Map<Id, List<SelectOption>> getMostrarComponenteCampana() {
        set<id> setIdPlanes = new set<id>();
        this.idPlanAOpciones = new Map<Id, List<SelectOption>>();
        
        for(Reserva__c objOferta : lstOfertas){
            setIdPlanes.add(Id.valueof(objOferta.LTE_Plan__c));   
        }
        system.debug('setIdPlanes -> ' + setIdPlanes) ;  
        system.debug('lstDetallesOferta -> ' + lstDetallesOferta.Size() + '-' + lstDetallesOferta) ;
             
        List<ReglaCampana__c> listreglas = new List<ReglaCampana__c>([Select Id, /*ComponenteCampana__r.SVA__c,*/ ComponenteCampana__c,ComponenteCampana__r.Plan__c, ComponenteCampana__r.id, ComponenteCampana__r.Name, ComponenteCampana__r.Descripcion__c,  TipoCampana__c
                                from ReglaCampana__c where ComponenteCampana__r.Plan__c IN :setIdPlanes AND ComponenteCampana__r.Campaign__r.Activo__c = true ]);
        
        if(listreglas.size()> 0){
            Boolean blconvenio = false;
            Boolean portacion = lstDetallesOferta[0].LTE_RequierePortacion__c;
            this.idPlanAOpciones = new Map<Id, List<SelectOption>>();
        
            for(LTE_DetalleOferta__c deof:lstDetallesOferta){
                options3 = new List<SelectOption>();
                options4 = new List<SelectOption>();
                options1 = new List<SelectOption>();
                options2 = new List<SelectOption>();
                
                blconvenio = false;
                for(ReglaCampana__c rc:listreglas) {
                    if( deof.Plan__c == rc.ComponenteCampana__r.Plan__c ){
                        system.debug('deof.Plan__c ->' + deof.Plan__c + ' - rc.ComponenteCampana__r.Plan__c --> ' + rc.ComponenteCampana__r.Plan__c);		
                        if(rc.TipoCampana__c == 'CONVENIO' ) {
                            blconvenio = true;
                            options1.add(new SelectOption(rc.ComponenteCampana__c, rc.ComponenteCampana__r.Name));
                        }
                        else if(rc.TipoCampana__c != 'CONVENIO'){ 
                            options2.add(new SelectOption(rc.ComponenteCampana__c, rc.ComponenteCampana__r.Name));
                        }
                    }  
                }
                
                if(options2.size()>0 && options1.size()>0 ) {
                    for ( Integer i = 0; i < options2.size(); i++) {
                        if(options2[i].getLabel() != options1[0].getLabel()){
                            options4.add(options2[i]);
                            blconvenio = false;
                        }
                    }
                    
                }
                else if (options2.size()>0 ){
                    options4 = options2; 
                }

                if( objOportunidad.Account.Aplica_Convenio__c == true  ){
                    if(options1.size()>0){
                        system.debug('entro a aplica convenio');
                        options3 = AgregarLista(options1);
                    }
                    else if (options1.size() == 0 && options4.size() != 0 && deof.LTE_RequierePortacion__c == true) {
                        options3 = AgregarLista(options4);
                    } 
                    options3.add(new SelectOption('','')); 
                     this.idPlanAOpciones.put(deof.id, options3);
                }     

                else if ( objOportunidad.Account.Aplica_Convenio__c == false  ){
                    if (deof.LTE_RequierePortacion__c == true && options4.size() != 0){
                        options3 = AgregarLista(options4);
                    }
                    options3.add(new SelectOption('','')); 
                    this.idPlanAOpciones.put(deof.id, options3);
                }  
            }
            system.debug('this.idPlanAOpciones -> ' + this.idPlanAOpciones);
            return this.idPlanAOpciones;
        }
        else{
            return null;
        }
    }
    // Fin Astrid y Omar

    // Inicio AStrid Leiva INI 876 Fase III
    //Metodo que muestra las promociones asociadas a un SVA- Datos Recurrente durante el porceso de venta predominando la de convenio su tiene activo el check de aplica convenio en la cuenta

  /* public Map<Id,Map<Id, List<SelectOption>>>  getMostrarComponenteCampanaSVADatos() {
        system.debug('--------------------------------------entro a getMostrarComponenteCampanaSVADatos --------------------------------');     
        this.promocionSVADatos = new Map<Id, List<SelectOption>>(); // mapa de sva
        mapapromocionesSVADatos = new Map<Id,Map<Id, List<SelectOption>>>(); // mapda de detalle oferta y sva
        setIdSVADatos = new set<id> (); // set id de sva de datos

        for(LTE_DetalleOferta__c objdetalle : lstDetallesOferta){
            if(objdetalle.LTE_BolsaRecurrenteDatos__c != null){
                setIdSVADatos.add(Id.valueof(objdetalle.LTE_BolsaRecurrenteDatos__c)); 
            }
        }
        system.debug('setIdSVADatos --> ' +setIdSVADatos);                                 
        List<ReglaCampana__c> listreglasSVADatos = new List<ReglaCampana__c>([Select Id, ComponenteCampana__r.SVA__c, ComponenteCampana__c,ComponenteCampana__r.Plan__c, ComponenteCampana__r.id, ComponenteCampana__r.Name, ComponenteCampana__r.Descripcion__c,  TipoCampana__c
                                from ReglaCampana__c where ComponenteCampana__r.SVA__c IN :setIdSVADatos AND ComponenteCampana__r.Campaign__r.Activo__c = true ]);
        system.debug('listreglasSVADatos -> ' + listreglasSVADatos);                        
        
        if(listreglasSVADatos.size() > 0){
            // for que recorre la lista de detall oferta
            for(LTE_DetalleOferta__c deof:lstDetallesOferta){
                // for de los id de los SVA de voz
                this.promocionSVADatos = new Map<Id, List<SelectOption>>(); // mapa de sva
                for(id idsva: setIdSVADatos) {
                    // si los id coinciden, entra a validar
                    if(deof.LTE_BolsaRecurrenteDatos__c == idsva) {
                        this.promocionSVADatos = crearmapa(deof.LTE_BolsaRecurrenteDatos__c, deof.LTE_RequierePortacion__c, listreglasSVADatos, this.promocionSVADatos );
                    }
                }
                system.debug('this.promocionSVADatos final del for de sva -> ' + this.promocionSVADatos);
                // mapa de detalle oferta con mapa de sva
                mapapromocionesSVADatos.put(deof.id,this.promocionSVADatos); 
            }
            system.debug('mapapromocionesSVADatos -> ' + mapapromocionesSVADatos);
            return mapapromocionesSVADatos;

        }
        else{
            return null;
        }       
    }*/
    

    // Inicio AStrid Leiva INI 876 Fase III
    //Metodo que muestra las promociones asociadas a un SVA- Voz Recurrente durante el porceso de venta predominando la de convenio su tiene activo el check de aplica convenio en la cuenta

    /*public Map<Id,Map<Id, List<SelectOption>>> getMostrarComponenteCampanaSVAVoz() {
        system.debug(' ---------------------------------- entroa a getMostrarComponenteCampanaSVAVoz ------------------------------------');
        this.promocionSVAVoz = new Map<Id, List<SelectOption>>(); // mapa de sva
        mapapromocionesSVAVoz = new Map<Id,Map<Id, List<SelectOption>>>(); // mapda de detalle oferta y sva
        setIdSVA = new set<id> (); // id de sva para sacar reglas de campaña

        for(LTE_DetalleOferta__c objdetalle : lstDetallesOferta){
            if(objdetalle.LTE_BolsaRecurrenteVoz__c != null){
                setIdSVA.add(objdetalle.LTE_BolsaRecurrenteVoz__c);
            }
        }
        system.debug('setIdSVAVoz --> ' +setIdSVA);                                
        
        List<ReglaCampana__c> listreglasSVA = new List<ReglaCampana__c>([Select Id, ComponenteCampana__r.SVA__c, ComponenteCampana__c,ComponenteCampana__r.Plan__c, ComponenteCampana__r.id, ComponenteCampana__r.Name, ComponenteCampana__r.Descripcion__c,  TipoCampana__c
                                from ReglaCampana__c where ComponenteCampana__r.SVA__c IN :setIdSVA AND ComponenteCampana__r.Campaign__r.Activo__c = true ]);
        
        system.debug('listreglasSVA -> ' + listreglasSVA); 
        if(listreglasSVA.size() > 0){
            // for que recorre la lista de detall oferta
            for(LTE_DetalleOferta__c deof:lstDetallesOferta){
                // for de los id de los SVA de voz
                this.promocionSVAVoz = new Map<Id, List<SelectOption>>(); // mapa de sva
                for(id idsva: setIdSVA) {
                    // si los id coinciden, entra a validar
                    if(deof.LTE_BolsaRecurrenteVoz__c == idsva) {
                        this.promocionSVAVoz = crearmapa(deof.LTE_BolsaRecurrenteVoz__c, deof.LTE_RequierePortacion__c, listreglasSVA, this.promocionSVAVoz );
                    }
                }
                system.debug('this.promocionSVAVoz final del for de sva -> ' + this.promocionSVAVoz);
                // mapa de detalle oferta con mapa de sva
                mapapromocionesSVAVoz.put(deof.id,this.promocionSVAVoz); 
            }
            system.debug('mapapromocionesSVAVoz -> ' + mapapromocionesSVAVoz);
            return mapapromocionesSVAVoz;

        }
        else{
            return null;
        }        
        
    }*/

    // Astrid Leiva
    // Metodo que crea el mapa de campañas de los SVA
    /*public Map<Id, List<SelectOption>> crearmapa(Id bolsa , Boolean portacion , List<ReglaCampana__c> lstreglas,  Map<Id, List<SelectOption>> promocionSVA ){

        
        options3 = new List<SelectOption>();
        options4 = new List<SelectOption>();
        options1 = new List<SelectOption>();
        options2 = new List<SelectOption>();
        // for que recorre la lista de reglas y las asigna

        for(ReglaCampana__c rc:lstreglas) {                      
                                    
            if( bolsa == rc.ComponenteCampana__r.SVA__c){
                system.debug('entro al of ');           
                if(rc.TipoCampana__c == 'CONVENIO' ) {
                    options1.add(new SelectOption(rc.ComponenteCampana__c, rc.ComponenteCampana__r.Name));
                }
                else if(rc.TipoCampana__c != 'CONVENIO'){ 
                    options2.add(new SelectOption(rc.ComponenteCampana__c, rc.ComponenteCampana__r.Name));
                }
            }
        }
        system.debug('options1 --> ' + options1);
        system.debug('options2 --> ' + options2);
        // if que elimina reglas repetidas y las guarda en option 4
        if(options2.size()>0 && options1.size()>0 ) {
            for ( Integer i = 0; i < options2.size(); i++) {
                if(options2[i].getLabel() != options1[0].getLabel()){
                    options4.add(options2[i]);
                }
            }
        }
        else if (options2.size()>0 ){
            options4 = options2; 
        }
        system.debug('options4 --> ' + options4);

        // Validacion del check de aplica convenio
        if( objOportunidad.Account.Aplica_Convenio__c == true  ){
            if(options1.size()>0){
                system.debug('entro a aplica convenio');
                options3 = AgregarLista(options1);
            }
            else if (options1.size() == 0 && options4.size()!= 0 && portacion == true) {
                options3 = AgregarLista(options4);
            } 
            options3.add(new SelectOption('',''));                            
            
            promocionSVA.put(bolsa, options3); 
            system.debug('this.idCompo -> ' + promocionSVA);
        }

        else if ( objOportunidad.Account.Aplica_Convenio__c == false ){
            if (portacion == true && options4.size() != 0){
                options3 = AgregarLista(options4);
            }
            options3.add(new SelectOption('',''));

            promocionSVA.put(bolsa, options3); 
            system.debug('this.idCompo -> ' + promocionSVA);
            
        }
        return  promocionSVA;
    }*/

    // omar.de.moreno.avila@accenture.com - astrid.c.leiva.amaya@accenture.com | 04-01-2022 
    //Metodo que permite agregar las promociones 
        
    public static List<SelectOption> AgregarLista( List<SelectOption> lstValidar){
        List<SelectOption> optionsReturn = new List<SelectOption>();
        optionsReturn.add(lstValidar[0]);
        for ( Integer i = 0; i < lstValidar.size(); i++)
        {
            if(i!= lstValidar.size()-1)
            {
                if (lstValidar[i].getLabel() != lstValidar[i+1].getLabel())
                    {
                        optionsReturn.add(lstValidar[i+1]); 
                    }
                }
        }
        
        return optionsReturn;
    } 

    
    //Astrid Leiva
    // Metodo que muestra el nombre del SVA 
    /*public void mostrarSVA(List<LTE_DetalleOferta__c> listDetalleOferta){
       
        mapa = new map<id, SubPlanFacturacion__c>();
        for(LTE_DetalleOferta__c ldo: listDetalleOferta){
            for (Reserva__c listReserva: lstOfertas){
                string indice = String.valueOf(listReserva.LTE_Indice__c);
                system.debug('indice --> ' + indice);
                map<string, svaObj> mapa2 = mapSva.get(indice);
                for (string key : mapa2.keySet()) {
                    mapa2.get(key);
                    mapa.put(listReserva.id, mapa2.get(key).subPlan );
                    system.debug('mapa --> '+ mapa);
                    if (ldo.LTE_Oferta_Economica__c == listReserva.id){
                        if(mapa.get(ldo.LTE_Oferta_Economica__c).LTE_TipoSubplan__c == 'SVA-Bolsa Recurrente de voz'){
                            ldo.LTE_BolsaRecurrenteVoz__c = mapa.get(ldo.LTE_Oferta_Economica__c).id;
                        }
                        if(mapa.get(ldo.LTE_Oferta_Economica__c).LTE_TipoSubplan__c == 'SVA-Bolsa Recurrente de datos'){
                            ldo.LTE_BolsaRecurrenteDatos__c = mapa.get(ldo.LTE_Oferta_Economica__c).id;
                        }
                    }
                }
               
            }
        }
        update listDetalleOferta;
     }*/
     // Fin Astrid Leiva 
}