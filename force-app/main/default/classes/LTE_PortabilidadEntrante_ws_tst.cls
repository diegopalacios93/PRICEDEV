/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez 
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase de prueba para las clases: LTE_PortabilidadEntrante_ws, LTE_RespuestaSolPortacionDonante_cls, LTE_FechaMaxVentanaCambio_cls, LTE_ConfirmacionFechaPortabilidad_cls y LTE_CreaTareaXError_cls

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-27      Walter Rodríguez (WR)    Creación de la clase.
***********************************************************************************************************************/

@isTest(SeeAllData=false)
private class LTE_PortabilidadEntrante_ws_tst
{
    static testMethod void myUnitTest() 
    {    
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        OperacionComercial__c oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        CatalogoProductos__c Catalogo = new CatalogoProductos__c();
        Catalogo.Name='Linea Telefonica';
        Catalogo.Estado__c='Activo';
        Catalogo.Descripcion__c='La Linea Telefonica le permite a su empresa estar conectado ilimitadamente';
        Catalogo.AtributosEstandar__c='1. Si la linea es para configurar un PBX';
        Catalogo.EsMigrado__c=true;
        Catalogo.CodigoProducto__c='LineaTelefonica001';
        Catalogo.Familia__c='VOZ';
        Catalogo.LineaNegocio__c='LOCAL';
        insert Catalogo;
        
        planes__c objPlan = new planes__c(Name='Plan Basico Linea Telefonica',
                                          Descripcion__c='La telefonia fija permite a su empresa estar conectado a la Red Publica de una forma segura y con calidad',
                                          FechaInicio__c=Date.today().addMonths(-24),
                                          Tarifa__c=14710.0,
                                          CondicionesComerciales__c='1. Es de caracter obligatorio solicitar siempre al cliente los numeros de contacto (Fijo o Celular)',
                                          Esmigrado__c=true,
                                          Estado__c='Activo',
                                          Espromocion__c=false,
                                          ANSFactibilidad__c=1.0,
                                          ANSAprovisionamiento__c=5.0,
                                          ANSAseguramiento__c=1.0,
                                          NombredelProducto__c = Catalogo.id,
                                          TipodePlan__c='Principal',
                                          PlanesAdicionalesporPlanPpal__c='Plan Obras Civiles Linea Telefonica;Plan Suplementario Llamada en Espera;',
                                          IdUnico__c='PlanBasicoLineaTelefonica001',
                                          InformacionPlanesAdicionales__c='Plan Obras Civiles Linea Telefonica;Plan Suplementario Llamada en Espera;'
                                         );
        
        insert objPlan;
        
        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = objPlan.Id;
        insert objCompensacion;
        
        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        insert objLegalizacion;
        
        
        LTE_Lote__c objLote = new LTE_Lote__c();
        objLote.LTE_Observaciones__c = 'Prueba';
        objLote.LTE_Identificador__c = '12345678';
        objLote.LTE_FechaVentanaCambio__c = System.today();
        objLote.LTE_Legalizacion__c=objLegalizacion.id;
        insert objLote;
        
        String strIdLote = String.valueOf(objLote.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '1234567';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '1004';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
    }
    
    static testMethod void myUnitTest_Linea() 
    {    
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        OperacionComercial__c oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        CatalogoProductos__c Catalogo = new CatalogoProductos__c();
        Catalogo.Name='Linea Telefonica';
        Catalogo.Estado__c='Activo';
        Catalogo.Descripcion__c='La Linea Telefonica le permite a su empresa estar conectado ilimitadamente';
        Catalogo.AtributosEstandar__c='1. Si la linea es para configurar un PBX';
        Catalogo.EsMigrado__c=true;
        Catalogo.CodigoProducto__c='LineaTelefonica001';
        Catalogo.Familia__c='VOZ';
        Catalogo.LineaNegocio__c='LOCAL';
        insert Catalogo;
        
        planes__c objPlan = new planes__c(Name='Plan Basico Linea Telefonica',
                                          Descripcion__c='La telefonia fija permite a su empresa estar conectado a la Red Publica de una forma segura y con calidad',
                                          FechaInicio__c=Date.today().addMonths(-24),
                                          Tarifa__c=14710.0,
                                          CondicionesComerciales__c='1. Es de caracter obligatorio solicitar siempre al cliente los numeros de contacto (Fijo o Celular)',
                                          Esmigrado__c=true,
                                          Estado__c='Activo',
                                          Espromocion__c=false,
                                          ANSFactibilidad__c=1.0,
                                          ANSAprovisionamiento__c=5.0,
                                          ANSAseguramiento__c=1.0,
                                          NombredelProducto__c = Catalogo.id,
                                          TipodePlan__c='Principal',
                                          PlanesAdicionalesporPlanPpal__c='Plan Obras Civiles Linea Telefonica;Plan Suplementario Llamada en Espera;',
                                          IdUnico__c='PlanBasicoLineaTelefonica001',
                                          InformacionPlanesAdicionales__c='Plan Obras Civiles Linea Telefonica;Plan Suplementario Llamada en Espera;'
                                         );
        
        insert objPlan;
        
        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = objPlan.Id;
        insert objCompensacion;
        
        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        insert objLegalizacion;
        
        Linea__c objLinea = new Linea__c();
        objLinea.Name = '13795636';
        objLinea.Linea_ETB__c = 'Portada Movil';
        insert objLinea;
        
        Lineas_OC__c objLineaOC = new Lineas_OC__c();
        objLineaOC.Operacion_Comercial__c = oOPeracionComercial.Id;
        objLineaOC.Linea__c = objLinea.Id;
        objLineaOC.Accion__c = 'Adicionar';
        objLineaOC.Estado__c = 'Pendiente';
        insert objLineaOC;
        
        String strIdLote = String.valueOf(objLineaOC.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '13795636';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = objLinea.Name;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '1004';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
    }
    
    static testMethod void myUnitTest2()
    {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        OperacionComercial__c oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
        LTE_Lote__c objLote = new LTE_Lote__c();
        objLote.LTE_Observaciones__c = 'Prueba';
        objLote.LTE_Identificador__c = '12345678';
        objLote.LTE_FechaVentanaCambio__c = System.today();
        insert objLote;
        
        String strIdLote = String.valueOf(objLote.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '1234567';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '1005';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
    }
    
    static testMethod void myUnitTest3()
    {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        CatalogoProductos__c Catalogo = new CatalogoProductos__c();
        Catalogo.Name              = 'TELEFONIA MOVIL (LTE)';
        Catalogo.Familia__c        = 'Conectividad IP';
        Catalogo.LineaNegocio__c   = 'Datos';
        Catalogo.CodigoProducto__c = 'Q2QQ3Q343RUYTT';
        Catalogo.Estado__c         = 'Activo';
        Catalogo.Descripcion__c    = 'Descripción de prueba';
        Catalogo.AtributosEstandar__c = 'Atributos estandart de test';
        insert Catalogo;
        
        
        Planes__c oPlanes = new Planes__c();
        oPlanes.Name                 	   = 'PLAN A LA MEDIDA CONTROL EMPRESAS';		
        oPlanes.NombredelProducto__c 	   =  Catalogo.Id; 
        oPlanes.TipodePlan__c        	   = 'Principal';  // lista (Principal,Adicionales)
        oPlanes.Tarifa__c           	   = 50000;      //Divisa 
        oPlanes.Estado__c           	   = 'Activo';         //lista (Activo,Inactivo)
        oPlanes.Descripcion__c      	   =  'Texto';
        oPlanes.CondicionesComerciales__c ='Condiciones Comerciales';
        oPlanes.LTE_PlanEstructurados__c  = true;
        insert oPlanes;
        
        TOPP__c oTOPP = new TOPP__c();
        oTOPP.Name                      = 'Tipo de operación de prueba';
        oTOPP.TipodeOperacionporplan__c = 'Venta';
        oTOPP.ANS_Factibilidad__c       = '87'; 
        oTOPP.ANS__c                    = 58; 
        oTOPP.Plan__c                   = oPlanes.Id;
        insert oTOPP;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '16589586';
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        insert objDepto;
        
        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.AnalistaSoporteVentas__c = getUser().Id;
        insert objLegalizacion;
        
        ActivoETB__c objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = objAccount.Id;
        insert objServicio;
        OperacionComercial__c oOPeracionComercial = new OperacionComercial__c();
        oOPeracionComercial.CuentaCliente__c = objAccount.Id;
        oOPeracionComercial.Portacion__c = true;
        oOPeracionComercial.Plan__c                    = oPlanes.Id;
        oOPeracionComercial.TOPP__c  				    = oTOPP.Id; 
        oOPeracionComercial.CuentaFacturacion__c = objCtaFact.Id;
        oOPeracionComercial.Estado__c = 'Pendiente';
        oOPeracionComercial.NumeroConexion__c = '3057000501';
        oOPeracionComercial.FechadeActivacion__c = system.today();
        oOPeracionComercial.Legalizacion__c = objLegalizacion.Id;
        oOPeracionComercial.Activo__c = objServicio.Id;
        oOPeracionComercial.LTE_Donante__c='Código Operador virtual ETB-10007';
        oOPeracionComercial.LTE_Tipo_de_Servicio__c = 'Pospago';
        oOPeracionComercial.LTE_SolicitadoPorTercero__c = true;
        insert oOPeracionComercial;
        
        TOPP__c oTOPPr = new TOPP__c();
        oTOPPr.Name                      = 'Tipo de operación de prueba';
        oTOPPr.TipodeOperacionporplan__c = System.Label.LTE_Retiro;
        oTOPPr.ANS_Factibilidad__c       = '87'; 
        oTOPPr.ANS__c                    = 58; 
        oTOPPr.Plan__c                   = oOPeracionComercial.Plan__c;
        oTOPPr.LTE_Catalogo_de_Producto__c = Catalogo.Id; 
        oTOPPr.Tipoderegistro__c         = 'Retiros';
        insert oTOPPr;
        
        LTE_Lote__c objLote = new LTE_Lote__c();
        objLote.LTE_Observaciones__c = 'Prueba';
        objLote.LTE_Identificador__c = '12345678';
        objLote.LTE_FechaVentanaCambio__c = System.today();
        objLote.LTE_Identificador__c = objLegalizacion.Id;
        insert objLote;
        
        LTE_DetalleLote__c objDetalleLote = new LTE_DetalleLote__c();
        objDetalleLote.LTE_NumeroLinea__c = '3057000501';
        objDetalleLote.LTE_Lote__c = objLote.Id;
        objDetalleLote.LTE_ActivoETB__c = objServicio.Id;
        insert objDetalleLote;
        
        String strIdLote = String.valueOf(objLote.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '1234567';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '1007';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
        LTE_FechaVentanaSalienteConfirmada_cls.procesarFechaVentanaConfirmada(objLote.LTE_Identificador__c, '08/08/2015' );
    }
    
    static testMethod void myUnitTest3_Linea()
    {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        CatalogoProductos__c Catalogo = new CatalogoProductos__c();
        Catalogo.Name              = 'TELEFONIA MOVIL (LTE)';
        Catalogo.Familia__c        = 'Conectividad IP';
        Catalogo.LineaNegocio__c   = 'Datos';
        Catalogo.CodigoProducto__c = 'Q2QQ3Q343RUYTT';
        Catalogo.Estado__c         = 'Activo';
        Catalogo.Descripcion__c    = 'Descripción de prueba';
        Catalogo.AtributosEstandar__c = 'Atributos estandart de test';
        insert Catalogo;
        
        
        Planes__c oPlanes = new Planes__c();
        oPlanes.Name                 	   = 'PLAN A LA MEDIDA CONTROL EMPRESAS';		
        oPlanes.NombredelProducto__c 	   =  Catalogo.Id; 
        oPlanes.TipodePlan__c        	   = 'Principal';  // lista (Principal,Adicionales)
        oPlanes.Tarifa__c           	   = 50000;      //Divisa 
        oPlanes.Estado__c           	   = 'Activo';         //lista (Activo,Inactivo)
        oPlanes.Descripcion__c      	   =  'Texto';
        oPlanes.CondicionesComerciales__c ='Condiciones Comerciales';
        oPlanes.LTE_PlanEstructurados__c  = true;
        insert oPlanes;
        
        TOPP__c oTOPP = new TOPP__c();
        oTOPP.Name                      = 'Tipo de operación de prueba';
        oTOPP.TipodeOperacionporplan__c = 'Venta';
        oTOPP.ANS_Factibilidad__c       = '87'; 
        oTOPP.ANS__c                    = 58; 
        oTOPP.Plan__c                   = oPlanes.Id;
        insert oTOPP;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '16589586';
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        insert objDepto;
        
        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.AnalistaSoporteVentas__c = getUser().Id;
        insert objLegalizacion;
        
        ActivoETB__c objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = objAccount.Id;
        insert objServicio;
        OperacionComercial__c oOPeracionComercial = new OperacionComercial__c();
        oOPeracionComercial.CuentaCliente__c = objAccount.Id;
        oOPeracionComercial.Portacion__c = true;
        oOPeracionComercial.Plan__c                    = oPlanes.Id;
        oOPeracionComercial.TOPP__c  				    = oTOPP.Id; 
        oOPeracionComercial.CuentaFacturacion__c = objCtaFact.Id;
        oOPeracionComercial.Estado__c = 'Pendiente';
        oOPeracionComercial.NumeroConexion__c = '3057000501';
        oOPeracionComercial.FechadeActivacion__c = system.today();
        oOPeracionComercial.Legalizacion__c = objLegalizacion.Id;
        oOPeracionComercial.Activo__c = objServicio.Id;
        oOPeracionComercial.LTE_Donante__c='Código Operador virtual ETB-10007';
        oOPeracionComercial.LTE_Tipo_de_Servicio__c = 'Pospago';
        oOPeracionComercial.LTE_SolicitadoPorTercero__c = true;
        insert oOPeracionComercial;
        
        TOPP__c oTOPPr = new TOPP__c();
        oTOPPr.Name                      = 'Tipo de operación de prueba';
        oTOPPr.TipodeOperacionporplan__c = System.Label.LTE_Retiro;
        oTOPPr.ANS_Factibilidad__c       = '87'; 
        oTOPPr.ANS__c                    = 58; 
        oTOPPr.Plan__c                   = oOPeracionComercial.Plan__c;
        oTOPPr.LTE_Catalogo_de_Producto__c = Catalogo.Id; 
        oTOPPr.Tipoderegistro__c         = 'Retiros';
        insert oTOPPr;
        
        Linea__c objLinea = new Linea__c();
        objLinea.Name = '13795636';
        objLinea.Linea_ETB__c = 'Portada Movil';
        insert objLinea;
        
        Lineas_OC__c objLineaOC = new Lineas_OC__c();
        objLineaOC.Operacion_Comercial__c = oOPeracionComercial.Id;
        objLineaOC.Linea__c = objLinea.Id;
        objLineaOC.Accion__c = 'Adicionar';
        objLineaOC.Estado__c = 'Pendiente';
        insert objLineaOC;
        
        String strIdLote = String.valueOf(objLineaOC.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '13795636';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '1007';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
        //LTE_FechaVentanaSalienteConfirmada_cls.procesarFechaVentanaConfirmada(objLote.LTE_Identificador__c, '08/08/2015' );
    }
    
    static testMethod void myUnitTest4()
    {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '16589586';
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto2 = new Poblacion__c();
        objDepto2.Name = 'BOGOTA D.C.';
        objDepto2.CodigoDane__c = '22000';
        objDepto2.EsDepartamento__c = true;
        insert objDepto2;
        
        Poblacion__c objMunicipio2 = new Poblacion__c();
        objMunicipio2.Name = 'BOGOTA D.C.';
        objMunicipio2.CodigoDane__c = '22002';
        objMunicipio2.EsMunicipio__c = true;
        objMunicipio2.Padre__c = objDepto2.Id;
        insert objMunicipio2;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio2.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.AnalistaSoporteVentas__c = getUser().Id;
        insert objLegalizacion;
        
        OperacionComercial__c oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
        
        LTE_Lote__c objLote = new LTE_Lote__c();
        objLote.LTE_Observaciones__c = 'Prueba';
        objLote.LTE_Identificador__c = objLegalizacion.Id;
        objLote.LTE_FechaVentanaCambio__c = System.today();
        insert objLote;
        
        String strIdLote = String.valueOf(objLote.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '1234567';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '9998';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
        
    }
    
    static testMethod void myUnitTest4_Linea()
    {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '16589586';
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto2 = new Poblacion__c();
        objDepto2.Name = 'BOGOTA D.C.';
        objDepto2.CodigoDane__c = '22000';
        objDepto2.EsDepartamento__c = true;
        insert objDepto2;
        
        Poblacion__c objMunicipio2 = new Poblacion__c();
        objMunicipio2.Name = 'BOGOTA D.C.';
        objMunicipio2.CodigoDane__c = '22002';
        objMunicipio2.EsMunicipio__c = true;
        objMunicipio2.Padre__c = objDepto2.Id;
        insert objMunicipio2;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio2.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.AnalistaSoporteVentas__c = getUser().Id;
        insert objLegalizacion;
        
        OperacionComercial__c oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
        
        Linea__c objLinea = new Linea__c();
        objLinea.Name = '13795636';
        objLinea.Linea_ETB__c = 'Portada Movil';
        insert objLinea;
        
        Lineas_OC__c objLineaOC = new Lineas_OC__c();
        objLineaOC.Operacion_Comercial__c = oOPeracionComercial.Id;
        objLineaOC.Linea__c = objLinea.Id;
        objLineaOC.Accion__c = 'Adicionar';
        objLineaOC.Estado__c = 'Pendiente';
        insert objLineaOC;
        
        String strIdLote = String.valueOf(objLineaOC.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '1234567';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '9998';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
        
    }
    
    static testMethod void myUnitTest5()
    {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '16589586';
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto3 = new Poblacion__c();
        objDepto3.Name = 'ANTIOQUIA';
        objDepto3.CodigoDane__c = '1200';
        objDepto3.EsDepartamento__c = true;
        insert objDepto3;
        
        Poblacion__c objMunicipio3 = new Poblacion__c();
        objMunicipio3.Name = 'MEDELLIN';
        objMunicipio3.CodigoDane__c = '11002';
        objMunicipio3.EsMunicipio__c = true;
        objMunicipio3.Padre__c = objDepto3.Id;
        insert objMunicipio3;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio3.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.AnalistaSoporteVentas__c = getUser().Id;
        insert objLegalizacion;
        
        OperacionComercial__c oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
        LTE_Lote__c objLote = new LTE_Lote__c();
        objLote.LTE_Observaciones__c = 'Prueba';
        objLote.LTE_Identificador__c = '12345678';
        objLote.LTE_FechaVentanaCambio__c = System.today();    
        objLote.LTE_Identificador__c = objLegalizacion.Id;
        insert objLote;
        
        String strIdLote = String.valueOf(objLote.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '1234567';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '9999';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
    }
    
    static testMethod void myUnitTest5_Linea()
    {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '16589586';
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto3 = new Poblacion__c();
        objDepto3.Name = 'ANTIOQUIA';
        objDepto3.CodigoDane__c = '1200';
        objDepto3.EsDepartamento__c = true;
        insert objDepto3;
        
        Poblacion__c objMunicipio3 = new Poblacion__c();
        objMunicipio3.Name = 'MEDELLIN';
        objMunicipio3.CodigoDane__c = '11002';
        objMunicipio3.EsMunicipio__c = true;
        objMunicipio3.Padre__c = objDepto3.Id;
        insert objMunicipio3;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.Ciudad__c = objMunicipio3.Id;
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        objLegalizacion.AnalistaSoporteVentas__c = getUser().Id;
        insert objLegalizacion;
        
        OperacionComercial__c oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
        
        Linea__c objLinea = new Linea__c();
        objLinea.Name = '13795636';
        objLinea.Linea_ETB__c = 'Portada Movil';
        insert objLinea;
        
        Lineas_OC__c objLineaOC = new Lineas_OC__c();
        objLineaOC.Operacion_Comercial__c = oOPeracionComercial.Id;
        objLineaOC.Linea__c = objLinea.Id;
        objLineaOC.Accion__c = 'Adicionar';
        objLineaOC.Estado__c = 'Pendiente';
        insert objLineaOC;
        
        String strIdLote = String.valueOf(objLineaOC.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '1234567';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '9999';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
    }
    
    static testMethod void myUnitTest6()
    {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '16589586';
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto4 = new Poblacion__c();
        objDepto4.Name = 'ANTIOQUIA';
        objDepto4.CodigoDane__c = '1200';
        objDepto4.EsDepartamento__c = true;
        insert objDepto4;
        
        Poblacion__c objMunicipio4 = new Poblacion__c();
        objMunicipio4.Name = 'MEDELLIN';
        objMunicipio4.CodigoDane__c = '11002';
        objMunicipio4.EsMunicipio__c = true;
        objMunicipio4.Padre__c = objDepto4.Id;
        insert objMunicipio4;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';      
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.Ciudad__c = objMunicipio4.Id;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        insert objLegalizacion;
        
        OperacionComercial__c oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
        
        LTE_Lote__c objLote = new LTE_Lote__c();
        objLote.LTE_Observaciones__c = 'Prueba';
        objLote.LTE_Identificador__c = objLegalizacion.Id;
        objLote.LTE_FechaVentanaCambio__c = System.today();
        insert objLote;
        
        String strIdLote = String.valueOf(objLote.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '1234567';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '9998';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
        
    }
    
    static testMethod void myUnitTest7()
    {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        CatalogoProductos__c Catalogo = new CatalogoProductos__c();
        Catalogo.Name              = 'TELEFONIA MOVIL (LTE)';
        Catalogo.Familia__c        = 'Conectividad IP';
        Catalogo.LineaNegocio__c   = 'Datos';
        Catalogo.CodigoProducto__c = 'Q2QQ3Q343RUYTT';
        Catalogo.Estado__c         = 'Activo';
        Catalogo.Descripcion__c    = 'Descripción de prueba';
        Catalogo.AtributosEstandar__c = 'Atributos estandart de test';
        insert Catalogo;
        
        Planes__c oPlanes = new Planes__c();
        oPlanes.Name                 	   = 'PLAN A LA MEDIDA CONTROL EMPRESAS';		
        oPlanes.NombredelProducto__c 	   =  Catalogo.Id; 
        oPlanes.TipodePlan__c        	   = 'Principal';  // lista (Principal,Adicionales)
        oPlanes.Tarifa__c           	   = 50000;      //Divisa 
        oPlanes.Estado__c           	   = 'Activo';         //lista (Activo,Inactivo)
        oPlanes.Descripcion__c      	   =  'Texto';
        oPlanes.CondicionesComerciales__c ='Condiciones Comerciales';
        oPlanes.LTE_PlanEstructurados__c  = true;
        insert oPlanes;
        
        TOPP__c oTOPP = new TOPP__c();
        oTOPP.Name                      = 'Tipo de operación de prueba';
        oTOPP.TipodeOperacionporplan__c = 'Venta';
        oTOPP.ANS_Factibilidad__c       = '87'; 
        oTOPP.ANS__c                    = 58; 
        oTOPP.Plan__c                   = oPlanes.Id;
        insert oTOPP;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.RazonSocial__c = 'Test razon social';
        objAccount.Tipodedocumento__c = 'NIT';
        objAccount.Estado_Cuenta__c = 'Activo';
        objAccount.AccountNumber = '1029837456'; 
        objAccount.Segmento__c = 'Gobierno Distrital';
        objAccount.SubSegmento__c = 'Mediana';
        objAccount.Phone = '16589586';
        insert objAccount;
        
        Contract objContrato = new Contract();
        objContrato.Name = 'Test name contrato';
        objContrato.AccountId = objAccount.Id;
        objContrato.Status = 'Borrador';
        insert objContrato;
        
        Poblacion__c objDepto5 = new Poblacion__c();
        objDepto5.Name = 'ANTIOQUIA';
        objDepto5.CodigoDane__c = '19200';
        objDepto5.EsDepartamento__c = true;
        insert objDepto5;
        
        Poblacion__c objMunicipio5 = new Poblacion__c();
        objMunicipio5.Name = 'MEDELLIN';
        objMunicipio5.CodigoDane__c = '14502';
        objMunicipio5.EsMunicipio__c = true;
        objMunicipio5.Padre__c = objDepto5.Id;
        insert objMunicipio5;
        
        CuentaFacturacion__c objCtaFact = new CuentaFacturacion__c();
        objCtaFact.LTE_NombreCuentaFacturacion__c = 'Cta fact test';
        objCtaFact.Cliente__c = objAccount.Id;
        objCtaFact.Facturable__c = true;
        objCtaFact.LTE_MetodoEnvio__c = 'Email';
        objCtaFact.LTE_CicloFacturacion__c = '5';
        objCtaFact.LTE_Email__c = 'test@test.com';
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
        objCtaFact.DirCorresp__c = 'Direccion test';
        objCtaFact.LTE_CuentaFacturacionLTE__c = true;
        objCtaFact.Fue_creada_en_revchain__c = true;
        objCtaFact.Ciudad__c = objMunicipio5.Id;
        objCtaFact.DirCorresp__c = 'Test DirCorresp';
        insert objCtaFact;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        objLegalizacion.Nombredelacuenta2__c = objAccount.Id;
        objLegalizacion.Contrato__c = objContrato.Id;
        objLegalizacion.LTE_ValorCuentaxCobrar__c = 459000;
        objLegalizacion.LTE_CuentaFacturacion__c = objCtaFact.Id;
        objLegalizacion.LTE_FechaGestion__c = system.today();
        objLegalizacion.Estado__c = 'Gestionado';
        objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
        objLegalizacion.Cuotas__c = 2;
        insert objLegalizacion;
        
        ActivoETB__c objServicio = new ActivoETB__c();
        objServicio.NombredelaCuenta__c = objAccount.Id;
        insert objServicio;

        OperacionComercial__c oOPeracionComercial = new OperacionComercial__c();
        oOPeracionComercial.CuentaCliente__c = objAccount.Id;
        oOPeracionComercial.Portacion__c = true;
        oOPeracionComercial.Plan__c                    = oPlanes.Id;
        oOPeracionComercial.TOPP__c  				    = oTOPP.Id; 
        oOPeracionComercial.CuentaFacturacion__c = objCtaFact.Id;
        oOPeracionComercial.Estado__c = 'Pendiente';
        oOPeracionComercial.NumeroConexion__c = '3057000501';
        oOPeracionComercial.FechadeActivacion__c = system.today();
        oOPeracionComercial.Legalizacion__c = objLegalizacion.Id;
        oOPeracionComercial.Activo__c = objServicio.Id;
        oOPeracionComercial.LTE_Donante__c='Código Operador virtual ETB-10007';
        oOPeracionComercial.LTE_Tipo_de_Servicio__c = 'Pospago';
        oOPeracionComercial.LTE_SolicitadoPorTercero__c = true;
        insert oOPeracionComercial;
        
        LTE_Lote__c objLote = new LTE_Lote__c();
        objLote.LTE_Observaciones__c = 'Prueba';
        objLote.LTE_Identificador__c = '12345678';
        objLote.LTE_FechaVentanaCambio__c = System.today();    
        objLote.LTE_Identificador__c = objLegalizacion.Id;
        insert objLote;
        
        TOPP__c oTOPPr = new TOPP__c();
        oTOPPr.Name                      = 'Tipo de operación de prueba';
        oTOPPr.TipodeOperacionporplan__c = System.Label.LTE_Retiro;
        oTOPPr.ANS_Factibilidad__c       = '87'; 
        oTOPPr.ANS__c                    = 58; 
        oTOPPr.Plan__c                   = oOPeracionComercial.Plan__c;
        oTOPPr.LTE_Catalogo_de_Producto__c = Catalogo.Id; 
        oTOPPr.Tipoderegistro__c         = 'Retiros';
        insert oTOPPr;
        
        String strIdLote = String.valueOf(objLote.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '1234567';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = 'ack Test';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = strIdLote;
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '9999';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
    }
    
    
    static testMethod void myUnitTest9() 
    {    
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');
        OperacionComercial__c oOPeracionComercial = LTE_DataGenerator_cls.createOperacionComercial(true);
        
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';
        insert vGlobal;
        
        CatalogoProductos__c Catalogo = new CatalogoProductos__c();
        Catalogo.Name='Linea Telefonica';
        Catalogo.Estado__c='Activo';
        Catalogo.Descripcion__c='La Linea Telefonica le permite a su empresa estar conectado ilimitadamente';
        Catalogo.AtributosEstandar__c='1. Si la linea es para configurar un PBX';
        Catalogo.EsMigrado__c=true;
        Catalogo.CodigoProducto__c='LineaTelefonica001';
        Catalogo.Familia__c='VOZ';
        Catalogo.LineaNegocio__c='LOCAL';
        insert Catalogo;
        
        planes__c objPlan = new planes__c(Name='Plan Basico Linea Telefonica',
                                          Descripcion__c='La telefonia fija permite a su empresa estar conectado a la Red Publica de una forma segura y con calidad',
                                          FechaInicio__c=Date.today().addMonths(-24),
                                          Tarifa__c=14710.0,
                                          CondicionesComerciales__c='1. Es de caracter obligatorio solicitar siempre al cliente los numeros de contacto (Fijo o Celular)',
                                          Esmigrado__c=true,
                                          Estado__c='Activo',
                                          Espromocion__c=false,
                                          ANSFactibilidad__c=1.0,
                                          ANSAprovisionamiento__c=5.0,
                                          ANSAseguramiento__c=1.0,
                                          NombredelProducto__c = Catalogo.id,
                                          TipodePlan__c='Principal',
                                          PlanesAdicionalesporPlanPpal__c='Plan Obras Civiles Linea Telefonica;Plan Suplementario Llamada en Espera;',
                                          IdUnico__c='PlanBasicoLineaTelefonica001',
                                          InformacionPlanesAdicionales__c='Plan Obras Civiles Linea Telefonica;Plan Suplementario Llamada en Espera;'
                                         );
        
        insert objPlan;
        
        CompensacionDatos__c objCompensacion = new CompensacionDatos__c();
        objCompensacion.Name = 'Compensacion CAIP,ID,RAS,VPN,Seguridad 99.70';
        objCompensacion.Plan__c = objPlan.Id;
        insert objCompensacion;
        
        AsignarCompensacion__c confAsignarCompensacion = new AsignarCompensacion__c();
        confAsignarCompensacion.Name = 'testplannplanaplan';
        confAsignarCompensacion.NombrePlan__c = 'testplannplanaplan';
        confAsignarCompensacion.IdCompensacion__c = objCompensacion.Id;
        insert confAsignarCompensacion;
        
        Legalizacion__c objLegalizacion = new Legalizacion__c();
        insert objLegalizacion;
        
        LTE_Lote__c objLote = new LTE_Lote__c();
        objLote.LTE_Observaciones__c = 'Prueba';
        objLote.LTE_Identificador__c = '3057000501';
        objLote.LTE_FechaVentanaCambio__c = System.today();
        objLote.LTE_Legalizacion__c=objLegalizacion.id;
        insert objLote;
        
        String strIdLote = String.valueOf(objLote.Id);
        
        LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje objIdentificadormensaje = new LTE_PortabilidadEntrante_ws.TipoIdentificadorMensaje();
        objIdentificadormensaje.IdentificadorMensajeErroneo = 'Identificador Test';
        
        LTE_PortabilidadEntrante_ws.TipoNumero objTipoNumero = new LTE_PortabilidadEntrante_ws.TipoNumero();
        objTipoNumero.TipoNumero = '3057000501';
        
        LTE_PortabilidadEntrante_ws.TipoCodigoCausa objTipoCausa = new LTE_PortabilidadEntrante_ws.TipoCodigoCausa();
        objTipoCausa.TipoCodigoCausa = 'Tipo Causa Test';
        
        LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo objTipoListaCodRechazo = new LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo();
        objTipoListaCodRechazo.CodigoRechazo = objTipoCausa;
        
        LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD objTipoNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD();
        objTipoNumRechazadaABD.Numero = objTipoNumero;
        objTipoNumRechazadaABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD objTipoListaNumRechazadaABD = new LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD();
        objTipoListaNumRechazadaABD.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD>{objTipoNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoRechazoPortacion objTipoRechazoPortacion = new LTE_PortabilidadEntrante_ws.TipoRechazoPortacion();
        objTipoRechazoPortacion.NumeracionesRechazadas = new list<LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD>{objTipoListaNumRechazadaABD};
            
            LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD objTipoErrorDetectadoABD = new LTE_PortabilidadEntrante_ws.TipoErrorDetectadoABD();
        objTipoErrorDetectadoABD.IdentificadorMensajeErroneo = objIdentificadormensaje;
        objTipoErrorDetectadoABD.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo>{objTipoListaCodRechazo};
            
            LTE_PortabilidadEntrante_ws.CodigosRechazo objCodigosRechazo = new LTE_PortabilidadEntrante_ws.CodigosRechazo();
        objCodigosRechazo.CodigoRechazo = 'Codigo Rechazo Test';
        
        LTE_PortabilidadEntrante_ws.NumeracionRechazada objNumeracionRechazada = new LTE_PortabilidadEntrante_ws.NumeracionRechazada();
        objNumeracionRechazada.DocumentoDC = 'DocumentoDC Test';
        objNumeracionRechazada.DocumentoFC = 'DocumentoFC Test';
        objNumeracionRechazada.DocumentoFR = 'DocumentoFR Test';
        objNumeracionRechazada.DocumentoUO = 'DocumentoDUO Test';
        objNumeracionRechazada.Numero = oOPeracionComercial.NumeroConexion__c;
        objNumeracionRechazada.CodigosRechazo = new list<LTE_PortabilidadEntrante_ws.CodigosRechazo>{objCodigosRechazo};
            
            LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada objListNumRechazada = new LTE_PortabilidadEntrante_ws.ListaNumeracionRechazada();
        objListNumRechazada.NumeracionRechazada = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>{objNumeracionRechazada};
            
            LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante objRespuestaSolPortacion = new LTE_PortabilidadEntrante_ws.RespuestaSolicitudPortacionDonante();
        objRespuestaSolPortacion.RespuestaABD = '0';
        objRespuestaSolPortacion.ListaNumeracionRechazada = objListNumRechazada;
        
        LTE_PortabilidadEntrante_ws.CuerpoMensaje objCuerpoMensaje = new LTE_PortabilidadEntrante_ws.CuerpoMensaje();
        objCuerpoMensaje.FechaMaxVentanaCambio = '08/08/2015';
        objCuerpoMensaje.FechaVentanaConfirmada = '08/08/2015';
        objCuerpoMensaje.NumeracionesRechazadas = objTipoRechazoPortacion;
        objCuerpoMensaje.RespuestaSolicitudPortacionDonante = objRespuestaSolPortacion;
        objCuerpoMensaje.TipoErrorDetectadoABD = objTipoErrorDetectadoABD;
        
        LTE_PortabilidadEntrante_ws.CabeceraMensaje objCabeceraMensaje = new LTE_PortabilidadEntrante_ws.CabeceraMensaje();
        objCabeceraMensaje.Identificador = String.valueOf(oOPeracionComercial.Id);
        objCabeceraMensaje.Observaciones = 'Observaciones Prueba';
        objCabeceraMensaje.TipoDeMensaje = '0002';
        
        LTE_PortabilidadEntrante_ws.PortabilidadMsg objPortabilidadMsg = new LTE_PortabilidadEntrante_ws.PortabilidadMsg();
        objPortabilidadMsg.CabeceraMensaje = objCabeceraMensaje;
        objPortabilidadMsg.CuerpoMensaje = objCuerpoMensaje;
        
        LTE_PortabilidadEntrante_ws.LTE_Response objResponse = LTE_PortabilidadEntrante_ws.WSRequestSolicitudSincronizacionABD(objPortabilidadMsg);
    }
    
    public static User getUser() 
    {
        
        Profile p = [SELECT Id,Name FROM Profile WHERE Name = 'Soporte a Ventas'];   
        
        String testemail = 'puser000@etb.com.testclass';
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles', 
                           alias='cspu', lastname='lastname');
        
        Database.insert(pu);
        
        return pu;
    }
}