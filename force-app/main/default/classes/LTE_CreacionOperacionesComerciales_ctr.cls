/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Raul Mora
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase controladora que realiza la creacion de la operacion comercial con diferentes parametros dependiendo
                    de el tipo de operacion seleccionada.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-10      Raul Mora (RM)              Creación de la clase.
2.0     2015-08-20      Walter Rodríguez (WR)       Ajustes.
3.0     2015-09-02      Carlos Rodriguez [CR]       Ajustes.
4.0     2016-01-28      Andrés Garrido [AG]         Ajustes para incluir el llamado al servicio web de suspenda para las suspensiones y reconexiones.
5.0     2016-04-11      Carlos Gonzalez (CG)        Adaptación para reportar a listas negras por suspensión - Perdida.
6.0     2017-04-12      Mauricio Farias (MF)        inclusion en la clase de los metodos para la captura y envio de los campos ciudad, direccion en el porceso de suspension robo.
7.0		2018-04-16		Fernando Sarasty (FSARASTY)	Acotar el código DANE depto a 2 dígitos para el xml "Request Hurto Celulares".
8.0		2018-12-20		Fernando Sarasty (FSARASTY - INI14818)		INI14818, Se modifica formulario e integración de reporte de hurto.
***********************************************************************************************************************/
public class LTE_CreacionOperacionesComerciales_ctr 
{
    public list<LTE_OperacionesSFDCSuspenda_cls.wrpHistoriaTramite> lstTramites     {get; set;} //AG
    
    public List<SelectOption> lstOperaciones {get;set;}
    public List<SelectOption> lstTipoSuspension {get;set;}
    public List<SelectOption> lstRegLstNegra {get;set;}
    public List<SelectOption> lstTipoRenovRepo {get;set;}
    public List<SelectOption> lstSucursales {get;set;} //WRM
    public List<SelectOption> lstTipoPago {get;set;} //WRM
    public List<SelectOption> lstTipoBaja {get;set;} //WRM
    
    public map<String,TOPP__c> mpTopp;
    
    public LTE_DetalleOferta__c objDetOferta {get;set;}
    public ActivoETB__c objServicio;
    public OperacionComercial__c objOpCom {get;set;}
    
    public LTE_Servicios_adicionales__c SVASeguro;
    public list<OperacionComercial__c> lstOCsVuelo {get;set;}
    
    public String strIdOperacion {get;set;}
    public String strIdServicio {get;set;}
    public String strNombreOp {get;set;}
    public String strNombreSeccion {get;set;}
    public String strTipoSuspension {get;set;}
    public String strRegLstNegra {get;set;}
    public String strImei {get;set;}
    public String strTipoRenovRepo {get;set;}
    public String strSucursales {get;set;} //WRM
    public String strTipoPago {get;set;} //WRM
    public String strTipoPagoSim {get;set;} //WRM
    public String strTipoBaja {get;set;} //WRM
    public String strIdCasoRobo {get;set;} //JR
    public String strNombreSeguro {get;set;} //AG
    public String strIdCiudad {get;set;} //MF
    public String strIdDepartamento {get;set;} //FSARASTY - INI14818
    public String strEmail {get;set;} //FSARASTY - INI14818
    public String strIdDireccion {get;set;} //MF    
    
    public Boolean blnRetiro {get;set;}
    public Boolean blnSuspension {get;set;}
    public Boolean blnReconex {get;set;}
    public Boolean blnRenovaRepo {get;set;}
    public Boolean blnSeccionPrincipal {get;set;}
    public Boolean blnMostrarIMEI {get;set;}
    public Boolean blnShowMessages {get;set;}
    public Boolean blnMostrarEquipo {get;set;}
    public Boolean blnPrimerCargaEquipo;
    public Boolean blnHabilitarCampo {get;set;} //WRM
    public Boolean blnOcultaBoton {get;set;} //WRM
    public Boolean blnOcultaBotonVolver {get;set;} //WRM
    public Boolean blnHistorico {get; set;} //AG
    public Boolean blnOCVuelo {get; set;} //AG
    public Boolean blnMostrarSeguro {get; set;} //AG
    public Boolean blnHabilitarTipoPago {get; set;} //AG
    public Boolean blnPreguntarReporteHurto {get; set;} //FSARASTY - INI14818
    public Boolean blnConfirmReporteHurto {get; set;} //FSARASTY - INI14818
    public Boolean blnFormularioPrincipal {get; set;} //FSARASTY - INI14818
    public Boolean blnUtilizacionArmas {get; set;} //FSARASTY - INI14818
    
    public Decimal dcPorcentajeDescuento {get;set;}
    public Decimal decPrecioEquipoIVA {get;set;} //WRM
    public Decimal dcPorcentajeDescuentoFijo {get;set;} //WRM
    
    public Date datFechaRetiro {get;set;} //WRM
    
    public static BusinessHours objBH //WRM
    {
        get
        {
            if(objBH == null)
            {
                objBH =
                [
                    select id, Name, MondayStartTime, MondayEndTime, TuesdayStartTime, TuesdayEndTime, 
                            WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, 
                            FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime
                    from BusinessHours
                    where Name = :'Horario ETB'
                ];
            }
            return objBH;
        }
        set;
    }
    
    /**
    Begin: Inclusión campos para operaciones comerciales de suspensión por robo
    Jorge Ramos
    **/
    public String strEmpleoViolencia {get;set;}
    public List<SelectOption> lstEmpleoViolencia
    {
        get{
            
            List<SelectOption> options = new List<SelectOption>();
            
            Schema.DescribeFieldResult fieldResult = OperacionComercial__c.LTE_EmpleoViolencia__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
           for( Schema.PicklistEntry f : ple)
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return options;
        
        }
        set;
    }
    
    public String strUtilizacionArmas {get;set;}
    public List<SelectOption> lstUtilizacionArmas
    {
        get{
            
            List<SelectOption> options = new List<SelectOption>();
            
            Schema.DescribeFieldResult fieldResult = OperacionComercial__c.LTE_UtilizacionArmas__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
           for( Schema.PicklistEntry f : ple)
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return options;
        
        }
        set;
    }

    public String strVictimaMenorEdad {get;set;}
    public List<SelectOption> lstVictimaMenorEdad
    {
        get{
            
            List<SelectOption> options = new List<SelectOption>();
            
            Schema.DescribeFieldResult fieldResult = OperacionComercial__c.LTE_VictimaMenorEdad__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
           for( Schema.PicklistEntry f : ple)
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }       
           return options;
        
        }
        set;
    }   
    
    public boolean blnAutorizacionReporteHurto {get;set;}
    /**
    End: Inclusión campos para operaciones comerciales de suspensión por robo
    Jorge Ramos
    **/
    
    public LTE_CreacionOperacionesComerciales_ctr()
    {
        strIdServicio = ApexPages.currentPage().getParameters().get( 'id' );
        inicializaVariables();
        cargarOperaciones();
        objOpCom = new OperacionComercial__c();
    }
    
    /*
    * @Metodo:      inicializaVariables
    * @Descripcion: Metodo encargado de inicializar la variables requeridas en la carga de la pagina.
    */
    public void inicializaVariables()
    {
        lstOperaciones = new List<SelectOption>();
        lstTipoSuspension = new List<SelectOption>();
        lstRegLstNegra = new List<SelectOption>();
        lstTipoRenovRepo = new List<SelectOption>();
        lstSucursales = new List<SelectOption>(); //WRM
        lstTipoPago = new List<SelectOption>(); //WRM
        lstTipoBaja = new List<SelectOption>(); //WRM
        mpTopp = new map<String,TOPP__c>();
        objDetOferta = new LTE_DetalleOferta__c();
        dcPorcentajeDescuento = 0;
        decPrecioEquipoIVA = 0; //WRM
        dcPorcentajeDescuentoFijo = 100; //WRM
        blnRetiro = false;
        blnSuspension = false;
        blnSeccionPrincipal = false;
        blnReconex = false;
        blnRenovaRepo = false;
        blnMostrarIMEI = false;
        blnShowMessages = false;
        blnMostrarEquipo = false;
        blnPrimerCargaEquipo = true;
        blnHabilitarCampo = false; //WRM
        blnUtilizacionArmas = false; //FSARASTY - INI14818
        blnOcultaBoton = true; //WRM
        blnOcultaBotonVolver = true; //WRM
        datFechaRetiro = system.today(); //WRM
        
        blnHistorico = false; //AG
        blnOCVuelo = false; //AG
        blnMostrarSeguro = false; //AG
        blnHabilitarTipoPago = false; //AG
        lstTramites = new list<LTE_OperacionesSFDCSuspenda_cls.wrpHistoriaTramite>();
        lstOCsVuelo = new list<OperacionComercial__c>();
        blnFormularioPrincipal = true; //FSARASTY - INI14818
    }
    
    /*
    * @Metodo:      cargarOperaciones
    * @Descripcion: Metodo encargado de consultar las operaciones que se mostraran al cargar la pagina.
    */
    public void cargarOperaciones()
    {
        objServicio = consultarServicio(); //[FSARASTY, 2020/05/01]: Bolsas compartidas
        List<TOPP__c> lstTopp = new List<TOPP__c>();
        //Se obtiene el catalogo de producto TELEFONIA MOVIL (LTE)
        List<CatalogoProductos__c> lstCataProd = [ Select Id 
                                                   From CatalogoProductos__c 
                                                   Where Name =: System.Label.LTE Limit 1 ];
        
        if( !lstCataProd.isEmpty() )
        {
            //Se consultan los Tipos Operaciones por Plan relacionados al producto TELEFONIA MOVIL (LTE) y Disponible Venta inicial falso 
            lstTopp = [ Select Id, Name, Tipoderegistro__c, TipodeOperacionporplan__c
                        From TOPP__c
                        Where LTE_Catalogo_de_Producto__c =: lstCataProd.get(0).Id
                        And DisponibleVentainicial__c = false And LTE_Parte_servicio__c = true];//and LTE_Parte_caso__c=false
            
            if( !lstTopp.isEmpty() )
            {
                for( TOPP__c objTopp : lstTopp )
                {
                    //[FSARASTY, 2020/05/01]: Bolsas compartidas - Incluir filtro para servicios de bolsas compartidas.
                    if(objServicio.Tipo_linea_bolsa_compartida__c != 'Hija')
                    {                    
                        mpTopp.put( objTopp.Id, objTopp );
                        lstOperaciones.add( new SelectOption( objTopp.Id, objTopp.Name) );
                    }
                }
                if(lstOperaciones.size() > 0)
                	cargarSecciones();
            }            
        }
    }
    
    /*
    * @Metodo:      cargarSecciones
    * @Descripcion: Metodo encargado de verificar la opcion seleccionada y en base a esta mostrar las diferentes secciones.
    */
    public Pagereference cargarSecciones()
    {
        //Inicializa los booleanos utilizados para mostrar las diferentes secciones
        limpiarSecciones();
        //Se obtiene el primer valor de la lista de seleccion tipo de operacion por plan siendo la primera vez que se carga la pagina, de lo contrario se obtiene el seleccionado.
        if( String.isEmpty( strIdOperacion ) )
        {
            strNombreOp = lstOperaciones.get(0).getLabel();
        } 
        else
        {
            strNombreOp = mpTopp.get( strIdOperacion ).Name;
        }
        system.debug('\n\n .-.-. strNombreOp '+strNombreOp);
        
        //Se consulta y se trae el IMEI del servicio desde donde se invoca la creación de la OC. WRM
        objServicio = consultarServicio();
        strImei = objServicio.IMEI_del_Equipo__c;
        
        //Se verifica si el tipo de operacion seleccionado es de suspension.
        if( strNombreOp.contains( System.Label.LTE_Suspension ) )
        {
            lstTipoSuspension = new List<SelectOption>();
            lstRegLstNegra = new List<SelectOption>();
            List<String> lstTiposSusp = System.Label.LTE_TiposSuspension.split(';');
            for( String strTpSp : lstTiposSusp )
            {
                lstTipoSuspension.add( new SelectOption( strTpSp, strTpSp ) );
            }
            system.debug('lstTipoSuspension --> ' + lstTipoSuspension);
            
            lstRegLstNegra.add( new SelectOption( 'Si', 'Si' ) );
            lstRegLstNegra.add( new SelectOption( 'No', 'No' ) );
            mostrarImei();
            strNombreSeccion = System.Label.LTE_Suspension;            
            if(strTipoSuspension=='Robo'){
                limpiarSecciones();                
                mostrarMensajeNotificacionSuspension();	
              	blnConfirmReporteHurto = true;              
            }else
            	blnSuspension =  mostrarSeccion();                            
            
            habilitarListaNegra();
        }
        //Se verifica si el tipo de operacion seleccionado es de retiro.
        if( strNombreOp.contains( System.Label.LTE_Retiro ) )
        {
            strNombreSeccion = System.Label.LTE_Retiro;
            //Se cargan los tipo de pago guardados en la etiqueta. WRM
            List<String> lstTipodeBaja = System.Label.LTE_TipoBaja.split(';');
            system.debug('lstTipodeBaja --> ' + lstTipodeBaja);
            lstTipoBaja = new List<SelectOption>(); //AG
            for(String strTipoBaja : lstTipodeBaja)
            {
                lstTipoBaja.add( new SelectOption( strTipoBaja, strTipoBaja ) );
            }
            blnRetiro = mostrarSeccion();
        }
        //Se verifica si el tipo de operacion seleccionado es de reconexion.
        if( strNombreOp.contains( System.Label.LTE_Reconexion ) )
        {
            /*******Se incluye sección para la reconexión [AG:2016-01-29]*******/
            lstTipoSuspension = new List<SelectOption>();
            List<String> lstTiposSusp = System.Label.LTE_TiposSuspension.split(';');
            for( String strTpSp : lstTiposSusp )
            {
                lstTipoSuspension.add( new SelectOption( strTpSp, strTpSp ) );
            }
            /**********************************************************************/
            strNombreSeccion = System.Label.LTE_Reconexion;
            blnReconex = mostrarSeccion();
        }
        //Se verifica si el tipo de operacion seleccionado es de renovacion o reposicion.
        if( strNombreOp.contains( System.Label.LTE_Renovacion ) || strNombreOp.contains( System.Label.LTE_Reposicion ) )
        {
            //Se obtienen las sucursales asociadas a la cuenta del servicio. WRM
            list<Account> lstAcc = [select Id, Name from Account where Cuenta__c =: objServicio.NombredelaCuenta__c LIMIT 800];
            lstSucursales = new List<SelectOption>(); //WRM
            for(Account acc : lstAcc){
                lstSucursales.add( new SelectOption( acc.Id, acc.Name ) );
            }
            //Se cargan los tipo de pago guardados en la etiqueta. WRM
            lstTipoPago = new List<SelectOption>();
            List<String> lstTipodePago = System.Label.LTE_TipoPago.split(';');
            system.debug('lstTipodePago --> ' + lstTipodePago);
            for(String strTipoPago : lstTipodePago)
            {
                lstTipoPago.add(new SelectOption( strTipoPago, strTipoPago ) );
            }
            //Se obtienen los valores de la lista de selección del campo tipo transaccion del objeto operacion comercial
            lstTipoRenovRepo = obtenerTipoTransaccion();
            if( blnPrimerCargaEquipo )
            {
                strTipoRenovRepo = lstTipoRenovRepo.get(0).getLabel();
            }
            system.debug('esta en el metodo');
            mostrarEquipo();
            
            strNombreSeccion = System.Label.LTE_Renovacion+'/'+System.Label.LTE_Reposicion;
            
            blnRenovaRepo = mostrarSeccion();
            blnPrimerCargaEquipo = false;
        }
        tramitesEnVuelo();
        
        return null;
    }
    
    /*
    * @Metodo:      obtenerTipoTransaccion
    * @Descripcion: Metodo encargado de consultar el campo tipo de transaccion y obtener los valores de la lista de seleccion.
    */
    public List<SelectOption> obtenerTipoTransaccion()
    {
        List<SelectOption> lstOptions = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = OperacionComercial__c.LTE_TipoTransaccion__c.getDescribe();
        List<Schema.PicklistEntry> lstPickLst = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry objPLE : lstPickLst)
        {
            lstOptions.add(new SelectOption( objPLE.getLabel(), objPLE.getValue() ) );
        }       
        return lstOptions;
    }
    
    /*
    * @Metodo:      crearOfertaDetalle
    * @Descripcion: Metodo encargado de crear la oferta y detalle oferta.
    */
    public void crearOfertaDetalle()
    {
        //Registro de oferta
        Reserva__c objOferta = new Reserva__c();
        //Se verifica que se haya seleccionado un equipo en la pagina.
        if( objDetOferta.LTE_ReferenciaEquipo__c != null )
        {
            objOferta.Equipo__c = objDetOferta.LTE_ReferenciaEquipo__c;
            objOferta.LTE_EsPosventa__c=true;
        }
        objOferta.LTE_Plan__c = objServicio.Plan__c;
        //Se verifica si se especifico un valor para el porcentaje de descuento mayor a 0.
        if( dcPorcentajeDescuento > 0 ){
            objOferta.LTE_DescuentoEquipos__c = dcPorcentajeDescuento;
        }
        insert objOferta;
        //Registro de detalle oferta.
        LTE_DetalleOferta__c objDetOfe = new LTE_DetalleOferta__c();
        objDetOfe.LTE_Oferta_Economica__c = objOferta.Id;
        objDetOfe.LTE_OperacionComercial__c = objOpCom.Id;
        objDetOfe.Plan__c = objServicio.Plan__c;
        objDetOfe.LTE_DescuentoEquipos__c = dcPorcentajeDescuento;
        system.debug('strSucursales --> ' + strSucursales);
        objDetOfe.LTE_Sucursal__c = strSucursales; //WRM
        objDetOfe.LTE_Estado_Detalle_Oferta__c = 'Reservado';
        objDetOfe.LTE_Cliente__c = objOpCom.CuentaCliente__c;
        //Se verifica que se haya seleccionado un equipo en la pagina.
        if( objDetOferta.LTE_ReferenciaEquipo__c != null )
        {
            objDetOfe.LTE_ReferenciaEquipo__c = objDetOferta.LTE_ReferenciaEquipo__c;
        }
        
        insert objDetOfe;
    }
    
    /*
    * @Metodo:      mostrarImei
    * @Descripcion: Metodo encargado de verificar un campo en la pagina y mostrar o no el campo IMEI.
    */
    public Pagereference mostrarImei()
    {
        if( strRegLstNegra == 'No' )
        {
            blnMostrarIMEI = false;
        }
        else
        {
            blnMostrarIMEI = true;
        }
        
        return null;
    }
    
    /*
    * @Metodo:      mostrarEquipo
    * @Descripcion: Metodo encargado de verificar un campo en la pagina y mostrar o no el campo Equipo.
    */
    public Pagereference mostrarEquipo()
    {
        system.debug('\n\n .-.-. strTipoRenovRepo '+strTipoRenovRepo);
        system.debug('strTipoRenovRepo --> ' + strTipoRenovRepo);
        system.debug('System.Label.LTE_Equipo --> ' + System.Label.LTE_Equipo);
        if( strTipoRenovRepo.Contains( System.Label.LTE_Equipo ) )
        {
            system.debug('Entro al if');
            blnMostrarEquipo = true;
            blnHabilitarTipoPago = false;
            //AG 2016-02-05 Se incluye validación para mostrar el seguro
            system.debug('\n@@@objServicio.Servicios_adicionales__r==>'+objServicio.Servicios_adicionales__r);
            if(objServicio.Servicios_adicionales__r != null && !objServicio.Servicios_adicionales__r.isEmpty()){
                blnMostrarSeguro = true;
                strNombreSeguro = objServicio.Servicios_adicionales__r[0].Name;
                SVASeguro = objServicio.Servicios_adicionales__r[0];
                
                if(strNombreOp.contains( System.Label.LTE_Reposicion )){
                    strTipoPago = 'Inmediato';
                    blnHabilitarTipoPago = true;        
                }
            }
                
        }
        else
        {
            system.debug('Entro al else');
            blnMostrarEquipo = false;
        }
        //blnMostrarEquipo = true;
        return null;
    }
    
    /*
    * @Metodo:      mostrarSeccion
    * @Retorna:     Boolean
    * @Descripcion: Metodo encargado de setear las variables booleanas para que se despliegue la requerida.
    */
    public Boolean mostrarSeccion()
    {
        blnRetiro = false;
        blnSuspension = false;
        blnReconex = false;
        blnRenovaRepo = false;
        blnSeccionPrincipal = true;
        
        return true;
    }
    
    /*
    * @Metodo:      limpiarSecciones
    * @Descripcion: Metodo encargado de setear las variables booleanas en falso.
    */
    public void limpiarSecciones()
    {
        blnShowMessages = false;
        blnSeccionPrincipal = false;
    }
    
    /*
    * @Metodo:      guardarOperacionComercial
    * @Descripcion: Metodo encargado de verificar la opcion seleccionada y en base a esta mostrar las diferentes secciones.
    */
    public Pagereference guardarOperacionComercial()
    {
        String strValidacionCampos = '';
        strIdCasoRobo = objOpCom.Caso__c; //MF
        strIdCiudad=objOpCom.Ciudad__c; //MF
        strIdDireccion=objOpCom.NuevaDireccionReparto__c; //MF
        strIdDepartamento=objOpCom.Departamento_del_Evento__c; //FSARASTY - INI14818
        strEmail=objOpCom.E_mail__c; //FSARASTY - INI14818        
        system.debug('strTipoPago -I-> ' + strTipoPago);
        system.debug('strSucursales 1 --> ' + strSucursales);
        PageReference pagRef = null;
        //Se invoca metodo para obtener el registro del servicio
        objServicio = consultarServicio();
        system.debug('objServicio.Estado__c --> ' + objServicio.Estado__c);
        //Verifica que tipo de operacion es seleccionada para diligeciar los diferentes campos.
        if( strNombreOp.contains( System.Label.LTE_Suspension ) )
        {            
            //Se verifica si seleccionaro el valor Si en lista negra y si no diligenciaron ningun valor en el IMEI para desplegar mensaje de error
            if( String.isEmpty( strImei ) && strRegLstNegra == 'Si' )
            {
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, System.Label.LTE_DiligencieIMEI ) );
                blnShowMessages = true;
                return null;
            }           
            
            // FSARASTY - INI14818 Validar campo Departamento cuando se realiza una suspensión por robo
            if(strTipoSuspension=='Robo' && String.isBlank(strIdDepartamento)){
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'El campo "Departamento del Evento" es obligatorio' ) );
                blnShowMessages = true;                
                return null;
            }
            // FSARASTY - INI14818 Validar campo Ciudad cuando se realiza una suspensión por robo
            if(strTipoSuspension=='Robo' && String.isBlank(strIdCiudad)){
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'El campo "Ciudad del Evento" es obligatorio' ) );
                blnShowMessages = true;
                return null;
            }
            // FSARASTY - INI14818 Validar campo Direccion cuando se realiza una suspensión por robo
            if(strTipoSuspension=='Robo' && String.isBlank(strIdDireccion)){
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'El campo "Dirección del Evento" es obligatorio' ) );
                blnShowMessages = true;
                return null;
            }
            // FSARASTY - INI14818 Validar campo Utilización de Armas cuando se realiza una suspensión por robo               
            if(strTipoSuspension=='Robo' && String.valueOf(strEmpleoViolencia) == 'Si' && String.valueOf(strUtilizacionArmas) == 'Seleccionar'){
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Seleccione una opción en el campo "Utilización de Armas"' ));
                blnShowMessages = true;
                return null;
            }
            //Se verifica que se relacione el caso cuando sea una suspensión por robo
            if(strTipoSuspension=='Robo' && String.isBlank(strIdCasoRobo)){
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'El campo caso es obligatorio' ) );
                blnShowMessages = true;
                return null;
            }
            //Se diligecian los campos necesarios para la creacion de la Operacion Comercial
            objOpCom = new OperacionComercial__c();
            objOpCom.Activo__c = objServicio.Id;
            objOpCom.NumeroConexion__c=objServicio.NumeroConexion__c;
            objOpCom.Plan__c = objServicio.Plan__c;
            objOpCom.TOPP__c = strIdOperacion;
            objOpCom.CuentaCliente__c = objServicio.NombredelaCuenta__c;
            objOpCom.TipoSuspension__c = strTipoSuspension;
            objOpCom.Registro_en_lista_negra_robo_o_perdida__c = strRegLstNegra;
            objOpCom.Estado__c = 'En Curso'; //[CR] Cambio de pendiente a en curso 02/09/2015
            objOpCom.CuentaFacturacion__c = objServicio.CuentaFacturacion__c; //WRM
            objOpCom.FechaInicioReconexion__c = system.today(); //[CR] Se adiciona la información de este campo.
            
            if(strTipoSuspension=='Robo'){                
                objOpCom.Caso__c = strIdCasoRobo;
                objOpCom.LTE_EmpleoViolencia__c = strEmpleoViolencia;                
                objOpCom.LTE_VictimaMenorEdad__c = strVictimaMenorEdad;
                objOpCom.LTE_AutorizacionReporteHurto__c = blnAutorizacionReporteHurto;
                objOpCom.Ciudad__c = strIdCiudad; //MF
                objOpCom.NuevaDireccionReparto__c = strIdDireccion; //MF
                objOpCom.Departamento_del_Evento__c = strIdDepartamento; //FSARASTY - INI14818
                objOpCom.E_mail__c = strEmail; //FSARASTY - INI14818
                objOpCom.LTE_AutorizacionReporteHurto__c = true; //FSARASTY - INI14818
                objOpCom.Registro_en_lista_negra_robo_o_perdida__c = 'Si'; //FSARASTY - INI14818
                if(String.valueOf(strEmpleoViolencia) == 'No') //FSARASTY - INI14818
                    objOpCom.LTE_UtilizacionArmas__c = 'Otras'; //FSARASTY - INI14818
                else
                    objOpCom.LTE_UtilizacionArmas__c = strUtilizacionArmas;
            }
            
             if(strTipoSuspension=='Perdida'){ // MF
                objOpCom.Caso__c = strIdCasoRobo; // MF
                objOpCom.Ciudad__c = strIdCiudad; //MF
                objOpCom.NuevaDireccionReparto__c = strIdDireccion; //MF
                objOpCom.Departamento_del_Evento__c = strIdDepartamento; //FSARASTY - INI14818
                objOpCom.E_mail__c = strEmail; //FSARASTY - INI14818
            }
        }
        //Verifica que tipo de operacion es seleccionada para diligeciar los diferentes campos.
        //[CR] Se retira de esta validación el caso de reconexión
        if( strNombreOp.contains( System.Label.LTE_Retiro ) )
        {
            objOpCom = new OperacionComercial__c();
            objOpCom.Activo__c = objServicio.Id;
            objOpCom.NumeroConexion__c=objServicio.NumeroConexion__c;
            objOpCom.Plan__c = objServicio.Plan__c;
            objOpCom.TOPP__c = strIdOperacion;
            objOpCom.CuentaCliente__c = objServicio.NombredelaCuenta__c;
            objOpCom.Estado__c = System.Label.LTE_Pendiente;
            objOpCom.FechaRetiro__c = datFechaRetiro;
            objOpCom.LTE_TipoBaja__c = strTipoBaja;
            objOpCom.CuentaFacturacion__c = objServicio.CuentaFacturacion__c; //WRM
        }
        //[CR]Verifica que tipo de operacion es seleccionada para diligeciar los diferentes campos.
        //[CR]Se agrega la validación independiente para el caso de reconexión para cambiarle el estado a en curso y agregale el campo FechaInicioReconexion__c
        if( strNombreOp.contains( System.Label.LTE_Reconexion ) )
        {
            //Se valida que el esta del servicio sea Suspendido para continuar con la reconexión. WRM 
            if(strNombreOp.contains( System.Label.LTE_Reconexion ) && objServicio.Estado__c != 'Suspendido')
            {
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'El servicio debe estar en Suspendido para poder realizar la reconexión del mismo.' ) );
                blnShowMessages = true;
                return null;
            }
            objOpCom = new OperacionComercial__c();
            objOpCom.Activo__c = objServicio.Id;
            objOpCom.NumeroConexion__c=objServicio.NumeroConexion__c;
            objOpCom.Plan__c = objServicio.Plan__c;
            objOpCom.TOPP__c = strIdOperacion;
            objOpCom.CuentaCliente__c = objServicio.NombredelaCuenta__c;
            objOpCom.Estado__c = 'En Curso';
            objOpCom.FechaRetiro__c = datFechaRetiro;
            objOpCom.LTE_TipoBaja__c = strTipoBaja;
            objOpCom.CuentaFacturacion__c = objServicio.CuentaFacturacion__c; //WRM
            objOpCom.FechaInicioReconexion__c = system.today();
            objOpCom.TipoSuspension__c = strTipoSuspension; //AG
        }
        //Fin [CR]
        //Verifica que tipo de operacion es seleccionada para diligeciar los diferentes campos.
        if( strNombreOp.contains( System.Label.LTE_Renovacion ) || strNombreOp.contains( System.Label.LTE_Reposicion ) )
        {
            //Se valida que el estado del servicio no sea Suspendido.
            //if(objServicio.Estado__c != 'Suspendido')
            //{
                if( objDetOferta.LTE_ReferenciaEquipo__c == null && strTipoRenovRepo.Contains( System.Label.LTE_Equipo ) )
                {
                    ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, System.Label.LTE_SeleccionarEquipo ) );
                    return null;
                }
                if( dcPorcentajeDescuento > 100 )
                {
                    ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, System.Label.LTE_PorcentajeNoMayor ) );
                    return null;
                }
                if( !strTipoRenovRepo.Contains( System.Label.LTE_Equipo ) )
                {
                    Equipo__c objEq = [ Select Id, LTE_PrecioConIVA__c
                                        From Equipo__c
                                        Where Name =: System.Label.LTE_EquipoTraido ];
                                    
                    objDetOferta.LTE_ReferenciaEquipo__c = objEq.Id;
                }
                objOpCom = new OperacionComercial__c();
                objOpCom.Activo__c = objServicio.Id;
                objOpCom.NumeroConexion__c=objServicio.NumeroConexion__c;
                objOpCom.Plan__c = objServicio.Plan__c;
                objOpCom.TOPP__c = strIdOperacion;
                objOpCom.CuentaCliente__c = objServicio.NombredelaCuenta__c;
                objOpCom.LTE_TipoTransaccion__c = strTipoRenovRepo;
                //objOpCom.FechadeActivacion__c = Date.today();
                
                if(strTipoPago == 'Inmediato'){
                    if(objOpCom.LTE_TipoTransaccion__c.contains(System.Label.LTE_Equipo)){
                        objOpCom.Estado__c = 'Validación de pago';
                    }else{
                        objOpCom.Estado__c = 'En Curso';
                    }
                }else{
                        objOpCom.Estado__c = 'En Curso';                    
                }
                
                
                objOpCom.EnviadaFacturacionEquipo__c=false; //LRPA  setear este campo para la facturacion de equipo financiado
                system.debug('strTipoPago --> ' + strTipoPago);
                if( strTipoRenovRepo.Contains( System.Label.LTE_Equipo ) )
                    objOpCom.LTE_TipoPago__c = strTipoPago;
                else
                    objOpCom.LTE_TipoPago__c = strTipoPagoSim;
                system.debug('objOpCom.LTE_TipoPago__c -2-> ' + objOpCom.LTE_TipoPago__c);
                if( dcPorcentajeDescuento > 0 )
                {
                    objOpCom.LTE_DescuentoSobreRepoReno__c = dcPorcentajeDescuento;             
                }
                objOpCom.LTE_TipoTransaccion__c = strTipoRenovRepo;
                objOpCom.CuentaFacturacion__c = objServicio.CuentaFacturacion__c; //WRM
            //}
            //else
            //{
                //ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR,'No se puede crear OC de Renovación o Reposición si el estado del servicio es Suspendido' ) );
                //return null;
            //}
        }
        //Confirma que el campo tipo de registro del registro de TOPP  no este vacio para prodecer a buscar el tipo de registro relacionado y asignarselo a la Operacion Comercial
        if( String.isNotEmpty( mpTopp.get( strIdOperacion ).Tipoderegistro__c ) )
        {
            objOpCom.RecordTypeId = consultarTipoRegistro();
        }
        
        try
        {            
            /*Llamado al servicio web de Suspenda, [AG:2016-01-26]*/
            
            if( strNombreOp.contains(System.Label.LTE_Suspension) || strNombreOp.contains(System.Label.LTE_Reconexion) ){                
                //verificar campos requeridos antes de generar integraciones
                if(strNombreOp.contains( System.Label.LTE_Suspension ) && strTipoSuspension=='Robo'){                    
                    strValidacionCampos = validarCamposRequeridosIntegracionVMR(objOpCom);
                    if(strValidacionCampos != ''){
                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR,strValidacionCampos));
                        return null;   
                    }                    
                }                
                String res = consultarSuspenda();
                    system.debug('suspenda@@@@@@@@'+res);        
                if(res=='1'){
                    insert objOpCom;
                    aprovisionarInmediato(objOpCom.id); 
                }
                else if(res=='2'){
                    insert objOpCom;
                    registrarSuspenda(new set<String>{objOpCom.Id},'2');
                }
                else if(res=='3' || res==''|| res=='0'){
                    if(lstTramites != null && !lstTramites.isEmpty())
                        blnHistorico = true;
                    else
                        blnHistorico = false;
                    return null;
                }                
                if(strNombreOp.contains( System.Label.LTE_Suspension ) && (strTipoSuspension=='Robo' || (strTipoSuspension=='Perdida' && strRegLstNegra=='Si') ) ){ // Se habilita la integración para Suspención por Perdida [CG:2016-04-11]                                        
                    envioReporteHurto(objOpCom.id);
                }
            }
            else{            
                insert objOpCom;
                system.debug('objOpCom.LTE_TipoPago__c-3->' + objOpCom.LTE_TipoPago__c);
                aprovisionarInmediato(objOpCom.id); 
                system.debug('objOpCom.LTE_TipoPago__c -4-> ' + objOpCom.LTE_TipoPago__c);
            }
        }
        catch( System.DmlException e )
        {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, e.getmessage() ) );
            return null;
        }            
        //Si fue una operacion de reposicion o renocacion se evalua si ingresaron una cantidad para el descuento para asignar la Operacion Comercial a un proceso de aprobacion 
        //y tambien crea la oferta y el detalle.
        if( strNombreOp.contains( System.Label.LTE_Renovacion ) || strNombreOp.contains( System.Label.LTE_Reposicion ) ) 
        {
            
            
            try
            {
                system.debug('strSucursales 2 --> ' + strSucursales);
                crearOfertaDetalle();
                if( strNombreOp.contains( System.Label.LTE_Renovacion ) || strNombreOp.contains( System.Label.LTE_Reposicion ) ){
                    if(objOpCom.LTE_TipoTransaccion__c.contains(System.Label.LTE_Equipo)){
                        crearLegalizacionYGenerarFactEquipos(objOpCom);
                        if(strTipoPago != 'Inmediato'){ // si no es inmediato, debe generar la información para facturacion
                            map<Id,OperacionComercial__c> ocRepoReno=new map<Id,OperacionComercial__c>([select id,Name,Plan__c,Legalizacion__c,Activo__c from OperacionComercial__c where Id=:objOpCom.id]);
                            LTE_GeneraServAdicVentaEquipos.obtenerEstructuradoPosventa(objOpCom);
                        }
                    }
                }
                //[AG 2016-02-17]: Logica para evaluar si existe un seguro y crear el SVA de retiro
                if(SVASeguro != null && (strNombreOp.contains( System.Label.LTE_Renovacion )  || strNombreOp.contains( System.Label.LTE_Reposicion ))){
                    TOPP__c toppSVARetiro = [Select Id From TOPP__c Where TipodeOperacionporplan__c = 'Retiro SVA'][0];
                    RecordType rt = [Select Id From RecordType Where DeveloperName = 'CambioPlan_LTE'][0]; 
                    
                    OperacionComercial__c svaRetiro = objOpCom.clone(false,false,false,false);
                    svaRetiro.TOPP__c = toppSVARetiro.Id;                   
                    svaRetiro.RecordTypeId = rt.Id;
                    svaRetiro.Categoria__c = 'Seguro de terminales';
                    svaRetiro.FechaInicioReconexion__c = objOpCom.FechaInicioReconexion__c==null?Date.today():objOpCom.FechaInicioReconexion__c;
                    insert svaRetiro;
                    
                    SVASeguro.LTE_OC_Tramite__c = svaRetiro.Id;
                    update SVASeguro;
                }
            }
            catch( System.DmlException e )
            {
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, e.getmessage() ) );
                return null;
            }
            if( dcPorcentajeDescuento > 0 )
            {
                incluyeDescuento( objOpCom.Id );
            }              
            
        }
        
        // si se realizo una operación de suspensión se debe actualizar el servicio colocandolo en un estado de suspendido. WRM
        //if( strNombreOp.contains( System.Label.LTE_Suspension ) )
        //{
        //  objServicio.Estado__c = 'Suspendido';
        //  try
        //  {
        //      update objServicio;
        //  }
        //  catch( System.DmlException e )
        //  {
        //      ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, e.getmessage() ) );
        //      return null;
        //  }
        //}
        //Redirecciona a la Operacion Comercial creada.
        System.debug('revision@@@@@'+ objOpCom.Id);
        pagRef = new PageReference( '/' + objOpCom.Id );
        
        return pagRef;
    }
    
    /*
    * @Metodo:      volverAccion
    * @Descripcion: Metodo encargado de redireccionar al servicio ETB.
    */
    public Pagereference volverAccion()
    {
        PageReference pagRef = new PageReference( '/' + strIdServicio );
        
        return pagRef;
    }
        
    
    
    /*
    * @Metodo:      incluyeDescuento
    * @Descripcion: Metodo encargado de crear el proceso de aprobacion al incluirse un descuento en la Operacion Comercial.
    */
    public void incluyeDescuento( String strOCId )
    {
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments( System.Label.LTE_ComentarioProcesoAprobOC );
        req1.setObjectId( strOCId );
        if( !Test.isRunningTest() )
        {
            // Envia el proceso de aprobacion para la Operacion Comercial
            Approval.ProcessResult result = Approval.process( req1 );
        }
            
    }
    
    /*
    * @Metodo:      consultarTipoRegistro
    * @Descripcion: Metodo encargado de buscar el tipo de registro con base al campo tipo de registro del tipo de operacion por plan seleccionado.
    */
    public String consultarTipoRegistro()
    {
        RecordType objRecTyp = [ Select Id 
                                 From RecordType 
                                 Where DeveloperName =: mpTopp.get( strIdOperacion ).Tipoderegistro__c 
                                 And SobjectType = 'OperacionComercial__c' ];
        
        return objRecTyp.Id;
    }
    
    /*
    * @Metodo:      consultarServicio
    * @Retorna:     ActivoETB__c
    * @Descripcion: Metodo encargado de consultar el servicio con el id capturado por parametros.
    */
    public ActivoETB__c consultarServicio()
    {
        //Se consulta el registro del servicio correspondiente al id obtenido por parametros
        ActivoETB__c objServ = [ Select Id, NombredelaCuenta__c, Plan__c, IMEI_del_Equipo__c, Estado__c, CuentaFacturacion__c,NumeroConexion__c,Tipo_linea_bolsa_compartida__c,
                                    (SELECT Id, Name FROM Servicios_adicionales__r WHERE LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c ='SVA-Seguro de terminales'), //AG 2016-02-05 
                                    (   SELECT  Name,Estado__c,TOPP__r.TipodeOperacionporplan__c, Categoria__c  
                                        FROM    Operaciones_Comerciales__r 
                                        WHERE   Estado__c IN ('En Curso','Pendiente','Equipo entregado', 'Enviado Aprovisionamiento')
                                    )           
                                 From ActivoETB__c
                                 Where Id =: strIdServicio ];
        
        return objServ;
    } 
    
    /*
    * @Metodo:              habilitarListaNegra
    * @Descripcion:         Metodo encargado de verificar el campo Tipo de Suspensión para habilitar o no el regitro de lista negra.
    * @Autor:               Walter Rodríguez (WR)
    * @Fecha de creación:   20/08/2015
    */
    public Pagereference habilitarListaNegra()
    {
        if( strTipoSuspension == 'Robo' )
        {
            blnHabilitarCampo = true;
            strRegLstNegra = 'Si';
            if(String.valueOf(strEmpleoViolencia) == 'No') //FSARASTY - INI14818
            	blnUtilizacionArmas = false;
            else
                blnUtilizacionArmas = true;
            
            blnMostrarIMEI = true;
        }
        else{
            blnHabilitarCampo = false;
            blnUtilizacionArmas = false;
        }
        return null;
    }
    
    public void mostrarMensajeNotificacionSuspension()
    {        
        blnFormularioPrincipal 		= false;
        blnPreguntarReporteHurto	= true;
        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,Label.Mensaje_confirmacion_Suspension));
    }
    
    public void confirmarMensajeNotificacionSuspension()
    {
        blnFormularioPrincipal 		= true;
        blnPreguntarReporteHurto	= false;
        objOpCom.LTE_AutorizacionReporteHurto__c = true;
        blnSuspension =  mostrarSeccion();
    }
    
    /*
    * @Metodo:              obtenerCicloFacturacion
    * @Descripcion:         Metodo encargado de obtener el ciclo de facturación de la cuenta de facturación ascociada al servicio.
    * @Autor:               Walter Rodríguez (WR)
    * @Fecha de creación:   20/08/2015
    */
    public Integer obtenerCicloFacturacion()
    {
        Integer intCicloFact = 0;
        if(objServicio.CuentaFacturacion__c != null)
        {
            CuentaFacturacion__c cuentaFacturacion = [select LTE_CicloFacturacion__c from CuentaFacturacion__c where Id =: objServicio.CuentaFacturacion__c];
        
            if(cuentaFacturacion != null)
                intCicloFact = Integer.valueOf(cuentaFacturacion.LTE_CicloFacturacion__c);
            else
            {
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'La factura no tiene ciclo de facturación.' ) );
                return null;
            }
                
            return intCicloFact;
        }
        else
        {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'El Servicio no tiene cuenta de facturación asociada.' ) );
            return null;
        }
        return null;
    }
    
    /*
    * @Metodo:              validarDiasCalendario
    * @Descripcion:         Metodo encargado de decir si al fecha seleccionada para el retiro es valida o no de acuerdo a la fecha de corte de facturación.
    * @Autor:               Walter Rodríguez (WR)
    * @Fecha de creación:   20/08/2015
    */
    public Pagereference validarDiasCalendario()
    {
        Integer intCicloFacturacion = obtenerCicloFacturacion();
        if(intCicloFacturacion != null)
        {
            datFechaRetiro = datFechaRetiro==null?System.today():datFechaRetiro;
            Integer intMes = datFechaRetiro.month();
            Integer intMesActual = system.today().month();
            Integer intDifMes = intMes - intMesActual;
            
            system.debug('intMes --> ' + intMes);
            system.debug('intMesActual --> ' + intMesActual);
            system.debug('intDifMes --> ' + intDifMes);
            
            System.debug('datFechaRetiro- -> '+datFechaRetiro);
            system.debug('Fecha límite --> '+System.today().addDays(30));
            
            if(intDifMes >= 0)
            {
                if((datFechaRetiro != null && datFechaRetiro >= system.today()))
                {
                    if(datFechaRetiro > System.today().addDays(30))
                    {
                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'La fecha de retiro no puede ser mayor a 30 días') );
                        blnOcultaBoton = false;
                        return null;
                    }
                    
                    Integer intDiaRetiro = datFechaRetiro.day();
                                        
                    Date datCicloFac = Date.newInstance(system.today().year(), system.today().month(), intCicloFacturacion);
                    system.debug('datCicloFac --> ' + datCicloFac);
                    Date datCicloMes = datCicloFac.addMonths(intDifMes);
                    long lngMilisegundos = BusinessHours.diff(objBH.id, datFechaRetiro, datCicloMes);
                    Decimal dcDiasTranscurridos = diasTranscurridos(lngMilisegundos);
                    system.debug('dcDiasTranscurridos --> ' + dcDiasTranscurridos);
                    
                    /*long milisegundos = BusinessHours.diff(objBH.id, datFechaRetiro, datCicloFac);
                    Decimal dcDiasTranscurridos = diasTranscurridos(milisegundos);
                    system.debug('dcDiasTranscurridos --> ' + dcDiasTranscurridos);*/
                    
                    //if(intDiaRetiro == intCicloFacturacion - 1 || intDiaRetiro == intCicloFacturacion - 2 || intDiaRetiro == intCicloFacturacion - 3)
                    if(dcDiasTranscurridos == 0 || dcDiasTranscurridos == 1 || dcDiasTranscurridos == 2 || dcDiasTranscurridos == 3)
                    {
                        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'La fecha de retiro solo puede ser hasta 3 días antes de la fecha de corte de la cuenta de facturación la cual es: ' + ' ' + intCicloFacturacion ) );
                        blnOcultaBoton = false;
                        return null;
                    }
                    else
                        blnOcultaBoton = true;
                }
                else
                {
                    ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Debe seleccionar una fecha mayor a hoy para poder continuar.' ) );
                    blnOcultaBoton = true;
                }
            }
            else
            {
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'La fecha de retiro no puede ser en un periodo anterior al actual' ) );
                blnOcultaBoton = false;
                return null;
            }
        }
        else
        {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'El servicio no tiene cuenta de facturación asociada.' ) );
            blnOcultaBoton = true;
        }
        return null;
    }
    
    /*
    * @Metodo:              obtenerValorEquipo
    * @Descripcion:         Metodo encargado de traer el valor del equipo con IVA
    * @Autor:               Walter Rodríguez (WR)
    * @Fecha de creación:   21/08/2015
    */
    public Pagereference obtenerValorEquipo()
    {
        if( objDetOferta.LTE_ReferenciaEquipo__c != null )
        {
            Equipo__c equipo = [select LTE_PrecioConIVA__c from Equipo__c where Id = : objDetOferta.LTE_ReferenciaEquipo__c];
            decPrecioEquipoIVA = equipo.LTE_PrecioConIVA__c;
        }
            
        return null;
    }
    
    /*
    * @Metodo:              validaEstado
    * @Descripcion:         Metodo encargado de validar el estado del servicio para la creación de la OC.
    * @Autor:               Walter Rodríguez (WR)
    * @Fecha de creación:   24/08/2015
    */
    public PageReference validaEstado()
    {
        //Se consulta y se trae el Estado del servicio desde donde se invoca la creación de la OC. WRM        
        objServicio = consultarServicio();
        if( objServicio.Estado__c == 'Pendiente' )
        {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'El estado del Servicio debe ser diferente de Pendiente para poder crear una OC' ) );
            blnOcultaBotonVolver = false;
        }
        else
        {
            inicializaVariables();
            cargarOperaciones();
        }
        return null;
    }
    
    /*
    * @Metodo:              validaEstado
    * @Descripcion:         Metodo encargado devolver los dias habilies transcurridos.
    * @Autor:               Walter Rodríguez (WR)
    * @Fecha de creación:   01/09/2015
    */
    public static Decimal diasTranscurridos(long milisegundos)
    {
        System.debug('milisegundos --> ' + milisegundos);
        Double segundos = milisegundos / 1000;
        System.debug('segundos --> ' + segundos);
        Double minutos = segundos / 60;
        System.debug('minutos --> ' + minutos);
        Decimal horas = minutos / 60;
        System.debug('horas --> ' + horas);
        Decimal dias = horas / 10;
        System.debug('dias --> ' + dias);
        return dias;
    }
    
    public boolean crearLegalizacionYGenerarFactEquipos(OperacionComercial__c OC){
        
        Id lteId = Schema.SObjectType.Legalizacion__c.getRecordTypeInfosByName().get('Legalización Reno Repo').getRecordTypeId();
        
            legalizacion__c objLegalizacion = new legalizacion__c();
            objLegalizacion.LTE_TipoPago__c = OC.LTE_TipoPago__c;
            objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
            objLegalizacion.Portacion__c = 'No';
            objLegalizacion.Nombredelacuenta2__c = OC.CuentaCliente__c;
            objLegalizacion.recordTypeId=lteId;
            
            if(objLegalizacion.LTE_TipoPago__c=='Inmediato'){  //  Si el tipo de pago es Inmediato, poner la legalizacion en estado Validación de pago
                objLegalizacion.Estado__c = 'Validación de pago';
            }else if(objLegalizacion.LTE_TipoPago__c=='Primera factura') {                                              //  Si el tipo de pago es NO Inmediato, poner la legalizacion en estado No Gestionado
                objLegalizacion.Cuotas__c=1;
                objLegalizacion.Estado__c = 'No Gestionado';
            }
            
            //Se genera el num de factura para la legalización.
            LTE_RangoFactura__c Rango = LTE_RangoFactura__c.getValues('FactEquiposLTE');
            system.debug('Rango-->'+Rango);
            LTE_ConsecutivoFacturaEquipos__c conFac = new LTE_ConsecutivoFacturaEquipos__c();
            insert conFac;
            LTE_ConsecutivoFacturaEquipos__c  objConfac =[SELECT Consecutivo_Factura_Equipo__c FROM LTE_ConsecutivoFacturaEquipos__c where id=:conFac.Id];
            system.debug('objConfac-->'+objConfac); 
            objLegalizacion.LTE_NFacturaVenta__c = String.ValueOF(Rango.Inicio_Rango__c+integer.ValueOF(objConfac.Consecutivo_Factura_Equipo__c));
            system.debug('objLegalizacion.LTE_NFacturaVenta__c-->'+objLegalizacion.LTE_NFacturaVenta__c);
            
            upsert objLegalizacion;
            system.debug('objLegalizacion insertada en el load --> ' + objLegalizacion);
            
            OC.Legalizacion__c = objLegalizacion.id;
            update OC;
            
            LTE_EnviarInfoFactEquipos_cls enviarFactEquipos = new LTE_EnviarInfoFactEquipos_cls();
            system.debug('OC.LTE_TipoTransaccion__c--> ' + OC.LTE_TipoTransaccion__c);
            /*if( OC.LTE_TipoTransaccion__c.Contains( System.Label.LTE_Equipo ) && objLegalizacion.LTE_TipoPago__c=='Inmediato'){
                system.debug('Voy a generar Factura --> ' + OC);
                enviarFactEquipos.enviarInfoFactEquiposPosVentaInmediato( objLegalizacion, OC );
            }*/
    return null;        
    }
    
    public void aprovisionarInmediato(Id idOC)
    {
        if( !strNombreOp.contains( System.Label.LTE_Suspension ) && !strNombreOp.contains( System.Label.LTE_Reconexion )){
            return;     
        }
        LTE_AprovisionamientoTramites_bch batchA = new LTE_AprovisionamientoTramites_bch();
        batchA.idImediato=new set<id>{idOC};
        
        if( !Test.isRunningTest() )
        {
            ID batchprocessid = Database.executeBatch(batchA, 1);   
        }
    }
    
    @future(callout=true)
    public static void envioReporteHurto(String idOperacionComercial){
        String CodDaneDepto; //FS 16-04-2018        
        String numTelContacto = '';
        List<String> splitNumTel;        
        // Se adiciona el campo TipoSuspension__c a la consulta de la OC [CG:2016-04-11]
        list<OperacionComercial__c> lstOperacionComercial = [Select id,
                                                                   Name,
                                                                   createdBy.Name, 
                                                                   Activo__r.IMEI_del_Equipo__c, 
                                                                   Caso__r.Contact.Name,
                                                                   Caso__r.Contact.Tipodedocumento__c,
                                                                   Caso__r.Contact.NumerodeIdentificacion__c,
                                                                   Caso__r.Contact.Direccion__c,
                                                                   Caso__r.Contact.Phone,
                                                                   Caso__r.Contact.Ciudad__c,
                                                                   Caso__r.Contact.Ciudad__r.name,
                                                                   Caso__r.Contact.Ciudad__r.CodigoDane__c,
                                                                   Caso__r.Contact.Ciudad__r.Padre__c,
                                                                   Caso__r.Contact.Ciudad__r.Padre__r.name,
                                                                   Caso__r.Contact.Ciudad__r.Padre__r.CodigoDane__c,
                                                                   LTE_EmpleoViolencia__c,
                                                                   LTE_UtilizacionArmas__c,
                                                                   LTE_VictimaMenorEdad__c,
                                                                   Caso__r.Contact.Email,
                                                                   LTE_AutorizacionReporteHurto__c,
                                                                   NuevaDireccionReparto__c,
                                                                   Ciudad__r.Name,
                                                                   Ciudad__r.CodigoDane__c,
                                                                   Ciudad__r.Padre__c,
                                                                   Ciudad__r.Padre__r.CodigoDane__c, 
                                                                   TipoSuspension__c,
                                                             	   Departamento_del_Evento__r.Name,
                                                             	   Departamento_del_Evento__r.CodigoDane__c,
                                                             	   E_mail__c
                                                            From OperacionComercial__c 
                                                            Where id =: idOperacionComercial];
        if(lstOperacionComercial != null && lstOperacionComercial.Size() > 0){   // FS-16-04-2018         
            if(lstOperacionComercial[0].Departamento_del_Evento__r.CodigoDane__c != null)
            	CodDaneDepto = (lstOperacionComercial[0].Departamento_del_Evento__r.CodigoDane__c).substring(0,2);                            
            else
                CodDaneDepto = '';
            
            map<String,ValoresIntegracionHurtoCelulares__c> mapValoresIntegracion = ValoresIntegracionHurtoCelulares__c.getAll();
                        
            if(lstOperacionComercial[0].Caso__r.Contact.Phone != '' && lstOperacionComercial[0].Caso__r.Contact.Phone != null){
                splitNumTel = lstOperacionComercial[0].Caso__r.Contact.Phone.split(' ');            
                numTelContacto = splitNumTel[0];
            }
            	
            String xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/DeviceManagement/ListasNegras/RegistroNegativo/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:lis="http://www.etb.com.co/LTE/WS/WebServiceConsultas/Consultas/ListasNegras/"><soapenv:Header/><soapenv:Body><ns:WSRegistroNegativo><v1:WSRequestHeader>';
            xml+='<v1:System correlationID=\"RHT-'+lstOperacionComercial[0].Name+'\" processingServer="?">?</v1:System>';
            xml+='<v1:Property name="?" value="?">?</v1:Property>';
            xml+='</v1:WSRequestHeader>';
            xml+='<lis:RegistroNegativo>';
            xml+='<lis:sUsuarioETB>'+lstOperacionComercial[0].createdBy.Name+'</lis:sUsuarioETB>';
            xml+='<lis:sIMEI>'+lstOperacionComercial[0].Activo__r.IMEI_del_Equipo__c+'</lis:sIMEI>';
            xml+='<lis:sNombreReporta>'+lstOperacionComercial[0].Caso__r.Contact.Name+'</lis:sNombreReporta>';
           
            xml+='<lis:sTipoDocReporta>'+(lstOperacionComercial[0].Caso__r.Contact.Tipodedocumento__c != null && mapValoresIntegracion.containskey(lstOperacionComercial[0].Caso__r.Contact.Tipodedocumento__c) ? mapValoresIntegracion.get(lstOperacionComercial[0].Caso__r.Contact.Tipodedocumento__c).valor__c : '')+'</lis:sTipoDocReporta>';
           
            xml+='<lis:sDocReporta>'+lstOperacionComercial[0].Caso__r.Contact.NumerodeIdentificacion__c+'</lis:sDocReporta>';
            xml+='<lis:sDireccionReporta>'+lstOperacionComercial[0].NuevaDireccionReparto__c+'</lis:sDireccionReporta>';
            xml+='<lis:sTelContactoReporte>'+numTelContacto+'</lis:sTelContactoReporte>';
            xml+='<lis:sDepartamentoReporta>'+CodDaneDepto+'</lis:sDepartamentoReporta>';
            xml+='<lis:sCiudadReporta>'+( lstOperacionComercial[0].Ciudad__r.CodigoDane__c != null ? lstOperacionComercial[0].Ciudad__r.CodigoDane__c : '' )+'</lis:sCiudadReporta>';
           
            /*xml+='<lis:iTipoReporte>'+(lstOperacionComercial[0].Caso__r.Contact.Tipodedocumento__c != null && mapValoresIntegracion.containskey(lstOperacionComercial[0].Caso__r.Contact.Tipodedocumento__c) ? 
                                       (mapValoresIntegracion.get(lstOperacionComercial[0].Caso__r.Contact.Tipodedocumento__c).valor__c == 'NIT' ? '2' : '1')
                                       : '')+'</lis:iTipoReporte>';*/
            if(lstOperacionComercial[0].TipoSuspension__c =='Perdida') // Los parametros por defecto para suspención por perdida. Se pueden parametrizar en la configuracion personalizada ValoresIntegracionHurtoCelulares__c [CG:2016-04-11]
            {
                xml+='<lis:iTipoReporte>'+ ( mapValoresIntegracion.containskey('Perdida-EmpleoViolencia') ? mapValoresIntegracion.get('Perdida-EmpleoViolencia').valor__c : '2' ) + '</lis:iTipoReporte>';
            }
            else
            {
                xml+='<lis:iTipoReporte>'+ ( mapValoresIntegracion.containskey('Perdida-EmpleoViolencia') ? mapValoresIntegracion.get('Perdida-EmpleoViolencia').valor__c : '1' ) + '</lis:iTipoReporte>';
            }

            xml+='<lis:iOrigenReporte>1</lis:iOrigenReporte>';
            xml+='<lis:sDireccionEvento>'+lstOperacionComercial[0].NuevaDireccionReparto__c+'</lis:sDireccionEvento>';
            
            if(lstOperacionComercial[0].TipoSuspension__c =='Perdida') // Los parametros por defecto para suspención por perdida. Se pueden parametrizar en la configuracion personalizada ValoresIntegracionHurtoCelulares__c [CG:2016-04-11]
            {
                xml+='<lis:iEmpleoViolencia>'      + ( mapValoresIntegracion.containskey('Perdida-EmpleoViolencia')      ? mapValoresIntegracion.get('Perdida-EmpleoViolencia').valor__c      : '0' ) + '</lis:iEmpleoViolencia>';
                xml+='<lis:iTipoUtilizacionArmas>' + ( mapValoresIntegracion.containskey('Perdida-TipoUtilizacionArmas') ? mapValoresIntegracion.get('Perdida-TipoUtilizacionArmas').valor__c : '0' ) + '</lis:iTipoUtilizacionArmas>';
                xml+='<lis:iTipoVictimaMenorEdad>' + ( mapValoresIntegracion.containskey('Perdida-TipoVictimaMenorEdad') ? mapValoresIntegracion.get('Perdida-TipoVictimaMenorEdad').valor__c : '0' ) + '</lis:iTipoVictimaMenorEdad>';
                xml+='<lis:sCorreoElectronico>'    + ( mapValoresIntegracion.containskey('Perdida-CorreoElectronico')    ? mapValoresIntegracion.get('Perdida-CorreoElectronico').valor__c    : '' )  + '</lis:sCorreoElectronico>';
                xml+='<lis:iAutorizaEnvioReporta>' + ( mapValoresIntegracion.containskey('Perdida-AutorizaEnvioReporta') ? mapValoresIntegracion.get('Perdida-AutorizaEnvioReporta').valor__c : '0' ) + '</lis:iAutorizaEnvioReporta>';                
            }
            else
            {
                xml+='<lis:iEmpleoViolencia>'+(lstOperacionComercial[0].LTE_EmpleoViolencia__c != null && mapValoresIntegracion.containsKey(lstOperacionComercial[0].LTE_EmpleoViolencia__c) ? mapValoresIntegracion.get(lstOperacionComercial[0].LTE_EmpleoViolencia__c).valor__c : '')+'</lis:iEmpleoViolencia>';
                xml+='<lis:iTipoUtilizacionArmas>'+(lstOperacionComercial[0].LTE_UtilizacionArmas__c != null && mapValoresIntegracion.containsKey(lstOperacionComercial[0].LTE_UtilizacionArmas__c) ? mapValoresIntegracion.get(lstOperacionComercial[0].LTE_UtilizacionArmas__c).valor__c : '')+'</lis:iTipoUtilizacionArmas>';
                xml+='<lis:iTipoVictimaMenorEdad>'+(lstOperacionComercial[0].LTE_VictimaMenorEdad__c != null && mapValoresIntegracion.containsKey(lstOperacionComercial[0].LTE_VictimaMenorEdad__c) ? mapValoresIntegracion.get(lstOperacionComercial[0].LTE_VictimaMenorEdad__c).valor__c : '')+'</lis:iTipoVictimaMenorEdad>';
                xml+='<lis:sCorreoElectronico>'+lstOperacionComercial[0].Caso__r.Contact.Email+'</lis:sCorreoElectronico>';
                xml+='<lis:iAutorizaEnvioReporta>'+(lstOperacionComercial[0].LTE_AutorizacionReporteHurto__c ? '1' : '0')+'</lis:iAutorizaEnvioReporta>';
            }

            xml+='</lis:RegistroNegativo>';
            xml+='</ns:WSRegistroNegativo>';
            xml+='</soapenv:Body>';
            xml+='</soapenv:Envelope>';
            
            system.debug('\n\n Request Hurto Celulares: ' + xml);
            
            //Obtener Endpoint
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('RegistroHurtoTerminales');
            string response = '';
            //Llamar Servicio
            if(!Test.isRunningTest()){
               response=LibreriaUtilitariaJobs_cls.consultarServicio(xml,sw.Action__c,sw.EndPoint__c);
            }
            system.debug('\n\n Response Hurto Terminales: '+ response);
            
            //Registrar log
            LogTransacciones__c lt =new LogTransacciones__c(CorrelationId__c=lstOperacionComercial[0].Id,LTE_Operacion_Comercial__c=lstOperacionComercial[0].Id,Informacion_Enviada__c=xml,Informacion_Recibida__c=response,Estado__c='',Name='Registro Hurto Terminales - '+lstOperacionComercial[0].Name);
            
            insert lt;
        
        }
    }

    /*[AG:2016-03-17] Metodo validar si el servicio tiene tramites en vuelo*/    
    public void tramitesEnVuelo(){
        if(strNombreOp.contains( System.Label.LTE_Suspension ) || strNombreOp.contains( System.Label.LTE_Reconexion )){
            if(objServicio.Operaciones_Comerciales__r != null && !objServicio.Operaciones_Comerciales__r.isEmpty()){
                lstOCsVuelo = objServicio.Operaciones_Comerciales__r;
                blnOCVuelo = true;
            }
            else{
                blnOCVuelo = false;
            }
        }
        else
            blnOCVuelo = false;
    }
    
    /*[AG:2016-01-27] Metodo para invocar el servicio web de suspenda, devuelve la respuesta del servicio*/
    public String consultarSuspenda(){
        LTE_OperacionesSFDCSuspenda_cls cls = new LTE_OperacionesSFDCSuspenda_cls();
        map<String, LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda> mapRta = new map<String,LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda>();
        String tipoTramite = mpTopp.get(strIdOperacion).TipodeOperacionporplan__c+', '+strTipoSuspension;
        LTE_ConsultaSuspenda__c tram = LTE_ConsultaSuspenda__c.getAll().get(tipoTramite);
        String strTramite = tram!=null?tram.Valor__c:'NA';
        mapRta = cls.consultarSuspensionSevicios(new set<String>{objServicio.Id}, tipoTramite, true, null);
        String llave = strTramite+'-'+objServicio.NumeroConexion__c;
        System.debug('\nllave===> ' + llave);
        
        LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda res = mapRta.get(llave);
        System.debug('\nRespuesta Consulta ===> ' + res);
        if(res == null){
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.WARNING, Label.LTE_SuspendaSinRespuesta ) );
            return '';
        }
        else{            
            String result = objOpCom.LTE_URLFallos__c == null ? '' : objOpCom.LTE_URLFallos__c;
            result += 'CONSULTA SUSPENDA - (Código Flujo: '+res.CodigoFlujo+') - ' + res.DescripcionRespuesta +'. \n';
            objOpCom.LTE_URLFallos__c = result;
            if(res.CodigoFlujo == '3' || res.CodigoFlujo==''|| res.CodigoFlujo=='0'){
                ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.WARNING, result ) );
                lstTramites = res.lstTramites;
            }
            return res.CodigoFlujo;
        }
        
    }
    
    
    
    /*[AG:2016-01-27] Metodo para invocar el servicio web de suspenda, devuelve la respuesta del servicio*/
    /*[MC:2016-03-28] Se sobrecarga el metodo para que pueda recibir la causal*/
    @future(callout=true)
    public static void registrarSuspenda(Set<String> setOCId, String codigoFlujoConsulta){
        System.debug('=== registrarSuspenda ===');
        LTE_TramitesSuspenda__c tram;
        String tramiteSuspenda;
        LTE_OperacionesSFDCSuspenda_cls cls = new LTE_OperacionesSFDCSuspenda_cls();
        List<OperacionComercial__c> lstOCToUpdate = new List<OperacionComercial__c>();
        List<ActivoETB__c> lstServiciosToUpdate = new List<ActivoETB__c>();
        map<String, LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda> mapRta = new map<String,LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda>();
        mapRta = cls.registrarSuspensionSevicios(setOCId);
        
        Map<Id, OperacionComercial__c> mapOCs = new Map<Id, OperacionComercial__c>([
            SELECT Id, Estado__c, LTE_URLFallos__c ,Activo__r.LTE_Causal__c, Activo__r.LTE_Numero_veces_suspendido__c,
            TOPP__r.TipodeOperacionporplan__c, TipoSuspension__c, Activo__r.Estado__c
            FROM OperacionComercial__c 
            WHERE Id in :setOCId]);
        
        String result = null;
        OperacionComercial__c ocTmp = null;
        LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda wrpTmp = null;
        
        for(String keyMap : mapRta.keyset() ){
            wrpTmp = mapRta.get(keyMap);
            ocTmp = mapOCs.get(Id.valueOf(keyMap));
            if(ocTmp != null){
                tramiteSuspenda = ocTmp.TOPP__r.TipodeOperacionporplan__c + ', ' +  ocTmp.TipoSuspension__c;
                
                System.debug('tramiteSuspenda: ' + tramiteSuspenda);
                tram = LTE_TramitesSuspenda__c.getAll().get(tramiteSuspenda);
                
                result = ocTmp.LTE_URLFallos__c == null ? '' : ocTmp.LTE_URLFallos__c;
                //Si la respuesta del servicio viene nula, ocurrio un error con Suspenda
                if(wrpTmp == null){
                    result += '\nREGISTRO SUSPENDA - ' + Label.LTE_SuspendaSinRespuesta + ' \n';
                    ocTmp.LTE_URLFallos__c = result;
                }
                else{
                    result += '\nREGISTRO SUSPENDA - (Código Respuesta: '+wrpTmp.CodigoRespuesta+') ' + wrpTmp.DescripcionRespuesta + ' \n';
                    ocTmp.LTE_URLFallos__c = result;
                    if(wrpTmp.CodigoRespuesta=='1'){
                        if(ocTmp.TOPP__r.TipodeOperacionporplan__c.contains(System.Label.LTE_Suspension)){
                            ocTmp.Activo__r.LTE_Numero_veces_suspendido__c = (ocTmp.Activo__r.LTE_Numero_veces_suspendido__c==null)?0:ocTmp.Activo__r.LTE_Numero_veces_suspendido__c;
                            ocTmp.Activo__r.LTE_Numero_veces_suspendido__c = ocTmp.Activo__r.LTE_Numero_veces_suspendido__c++;
                        }
                        if(tram != null){
                            System.debug('\ncodigoFlujoConsulta: ' + codigoFlujoConsulta);
                            System.debug('\nocTmp.Activo__r.Estado__c: ' + ocTmp.Activo__r.Estado__c);
                            if(
                                (codigoFlujoConsulta != '2' && ocTmp.TOPP__r.TipodeOperacionporplan__c.contains(System.Label.LTE_Reconexion)) ||  
                                (ocTmp.TOPP__r.TipodeOperacionporplan__c.contains(System.Label.LTE_Suspension))
                            ){
                                System.debug('\nEntro actualizar activo: ' + tramiteSuspenda);
                                ocTmp.Activo__r.Estado__c = tram.LTE_EstadoServicio__c;     
                                if(ocTmp.Activo__r.LTE_Causal__c != 'Voluntaria')
                                    ocTmp.Activo__r.LTE_Causal__c = tram.LTE_Causal__c;
                                lstServiciosToUpdate.add(ocTmp.Activo__r);                   
                            }
                            ocTmp.Estado__c = tram.LTE_Estado__c;
                        } 
        
                        
                    }else if(wrpTmp.CodigoRespuesta=='-1' || wrpTmp.CodigoRespuesta=='-2' || wrpTmp.CodigoRespuesta=='-3' || wrpTmp.CodigoRespuesta=='-4' || wrpTmp.CodigoRespuesta=='-5'){
                        ocTmp.Estado__c = 'Declinada';
                    }
                }
                lstOCToUpdate.add(ocTmp);
            }
        }
        
        update lstOCToUpdate;
        update lstServiciosToUpdate;
    }
    public string validarCamposRequeridosIntegracionVMR(OperacionComercial__c objOC){
        string strValidacion = '';        
        map<String,ValoresIntegracionHurtoCelulares__c> mapValoresIntegracion = ValoresIntegracionHurtoCelulares__c.getAll();        
        
        if(objOC.LTE_EmpleoViolencia__c == null){
            strValidacion = Label.Mensaje_error_creacion_oc_suspension.replace('%campo%','Empleo de Violencia');
        }else{
            if(!mapValoresIntegracion.containsKey(objOC.LTE_EmpleoViolencia__c))
                strValidacion = Label.Mensaje_error_creacion_oc_suspension_2.replace('%campo%','Empleo de Violencia');            
        }
        
        if(objOC.LTE_EmpleoViolencia__c == 'Si'){
        	if(objOC.LTE_UtilizacionArmas__c == null){
                strValidacion = Label.Mensaje_error_creacion_oc_suspension.replace('%campo%','Utilización de Armas');
            }else{
                if(!mapValoresIntegracion.containsKey(objOC.LTE_UtilizacionArmas__c))
                    strValidacion = Label.Mensaje_error_creacion_oc_suspension_2.replace('%campo%','Utilización de Armas');            
            }           
        }
        
        if(objOC.LTE_VictimaMenorEdad__c == null){
            strValidacion = Label.Mensaje_error_creacion_oc_suspension.replace('%campo%','Victima menor de edad');
        }else{
            if(!mapValoresIntegracion.containsKey(objOC.LTE_VictimaMenorEdad__c))
                strValidacion = Label.Mensaje_error_creacion_oc_suspension_2.replace('%campo%','Victima menor de edad');            
        }           
        Return strValidacion;
    }
}