/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que obtendra la lógica  para realizar el envío de la solicitud de portabilidad (1001)

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-07-30      Walter Rodríguez (WR)       Creación de la clase.
2.0     2017-05-30      Miguel Sánchez (MS)         Agregar Operaciones de NIP sobre Botón en OC
***********************************************************************************************************************/
global class LTE_SolicitudPortabilidad_cls {
    public static string strIdentificador;
    public static string strObservaciones;
    public static string strVentanaAmpl;
    public static string strNombreRazonSocial;
    public static string strDireccionAbonado;
    public static string strIdentificacion;
    public static string strDonante;
    public static string strTipoUsuario;
    public static string strTipoServicio;
    public static string strSolTercero;
    public static string strNIP;
    public static string strDocID;
    public static string strTypeDocID;
    public static string strDocAT;
    public static string strTypeDocAT;
    public static string strDocCC;
    public static string strTypeDocCC;
    public static string strResp;
    public static decimal decNRN;
    public static boolean blnSolTercero = false;
    public static list < string > lstNumerosPortar = new list < string > ();
    public static list < string > lstDocumentos = new list < string > ();
    public static list < Attachment > lstAtt = new list < Attachment > ();
    public static list < LTE_Lote__c > lstLote = new list < LTE_Lote__c > ();
    public static list < LTE_DetalleLote__c > lstDetalleLote = new list < LTE_DetalleLote__c > ();
    public static map < string, string > mapValues = new map < string, string > ();
    public static map < string, Attachment > mapValuesDoc = new map < string, Attachment > ();
    public static map < string, OperacionComercial__c > mapLineaOc = new map < string, OperacionComercial__c > ();
    public static OperacionComercial__c ocUpdate {
        get;
        set;
    }

    webservice static String reenvioSolicitudNIP(String idObjeto) {
        String strResultado = '';
        String strRespuesta = '';
        String strOperadorDonante = '';
        String strNumeroConexion = '';
        String strDonante = '';
        String strCorrelation = '';
        String strCreated = '';
        Decimal intReintento = 0;
        SObject objPrincipal;
        
        list < LogTransacciones__c > listLogServicio = new list < LogTransacciones__c > ();
        LogTransacciones__c logServicio = new LogTransacciones__c();
        
        list < OperacionComercial__c > lstOC = new list < OperacionComercial__c > ();
        list < Lineas_OC__c > lstLineaOC = new list < Lineas_OC__c > ();
        
        lstOC = [SELECT Id, NumeroConexion__c, LTE_Donante__c, LTE_SolicitadoPorTercero__c, NIP__c, CreatedDate, Reintento_NIP__c
                 FROM OperacionComercial__c
                 WHERE Id =: idObjeto
                 AND Portacion__c =: true
                 AND Estado__c =: 'Pendiente'
                ];
        
        for (OperacionComercial__c oc: lstOC) {
            strOperadorDonante = oc.LTE_Donante__c;
            strNumeroConexion = oc.NumeroConexion__c;
            strCorrelation = oc.Id;
            intReintento = oc.Reintento_NIP__c;
            strCreated = String.valueOf(oc.CreatedDate);
        }
        if (lstOC.isEmpty()) {
            lstLineaOC = [SELECT Id,Linea__r.Codigo_de_linea__c,Linea__r.Tipo__c,Reintento_NIP__c,CreatedDate FROM Lineas_OC__c WHERE Id =: idObjeto AND Estado__c =: 'Pendiente'];
            
            for (Lineas_OC__c sglLineaOc: lstLineaOC) {
                strOperadorDonante = sglLineaOc.Linea__r.Tipo__c;
                strNumeroConexion = sglLineaOc.Linea__r.Codigo_de_linea__c;
                strCorrelation = sglLineaOc.Id;
                intReintento = sglLineaOc.Reintento_NIP__c;
                strCreated = String.valueOf(sglLineaOc.CreatedDate);
            }
        }
        
        if (String.isNotEmpty(strCorrelation)) {
            if (!lstOC.isEmpty())
                objPrincipal = lstOC[0];
            else
                objPrincipal = lstLineaOC[0];
            if (intReintento < 1000) {
                
                
                list < String > lstDonante = strOperadorDonante.split('-');
                strDonante = lstDonante[1];
                
                mapValues.put('correlationID', strCorrelation);
                mapValues.put('numeroConexion', strNumeroConexion);
                mapValues.put('operadorDonante', strDonante);
                mapValues.put('fechaCreacion', strCreated);
                
                string strReq = LTE_GenXmlPortabilidadEntrante_cls.generarXmlSolicitudNIP(mapValues, 'R');
                strReq = strReq.replace('>null<', '><');
                
                ServiciosWeb__c sw = ServiciosWeb__c.getValues('PortabilidadReenvioNIP');
                if (!Test.isRunningTest()) {
                    strRespuesta = LibreriaUtilitaria_cls.consultarServicio(strReq, sw.Action__c, sw.EndPoint__c);
                } else
                    strRespuesta = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:WSResponseReenvioNIP xmlns:ns0="http://www.etb.com.co/LTE/WS/webserviceportability/ReenvioNIP/OUT/1.0"><ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0"><ns1:System>Salesforce</ns1:System><ns1:Service><ns1:status>PASS</ns1:status></ns1:Service><ns1:Property/></ns1:WSResponseHeader><ns1:Respuesta xmlns:ns1="http://www.etb.com.co/LTE/portability/v1.0"><ns1:IdIntegracion/><ns1:ErrorCode>0</ns1:ErrorCode><ns1:ErrorMessage/></ns1:Respuesta></ns0:WSResponseReenvioNIP></SOAP-ENV:Body></SOAP-ENV:Envelope>';
                
                tibcoXml_cls.xmlMapConsulta objReq = new tibcoXml_cls.xmlMapConsulta();
                set < string > datac = objReq.getMap(strRespuesta);
                strResultado = objReq.valores.get('ErrorCode');
                
                if (strResultado == '0') logServicio.Estado__c = 'Exitoso';
                else logServicio.Estado__c = 'Conexión Fallida';
                logServicio.Informacion_Enviada__c = strReq;
                logServicio.Informacion_Recibida__c = strRespuesta;
                if (lstOC.size() > 0)
                    logServicio.LTE_Operacion_Comercial__c = strCorrelation;
                else
                    logServicio.Linea_OC__c = strCorrelation;
                logServicio.CodigoRespuesta__c = UserInfo.getSessionId();
                logServicio.Name = 'Reenvio NIP' + ' ' + strNumeroConexion;
                
                listLogServicio.add(logServicio);
                insert listLogServicio;
                
                if (strResultado == '0') {
                    strResultado = 'Solicitud Reenvio NIP Enviada Correctamente!!!';
                    intReintento = intReintento + 1;
                    objPrincipal.put('Reintento_NIP__c',intReintento);
                    update objPrincipal;
                } else {
                    strResultado = 'Falla al Enviar Reenvio NIP - ' + strResultado;
                }
            } else {
                strResultado = 'Maxima Solicitud de Reintentos de NIP Ejecutado';
            }
            
        } else {
            strResultado = 'El Id suministrado no permite Operaciones de NIP';
        }
        
        return strResultado;
    }
    
    webservice static String solicitudNIP(String idObjeto) {
        
        String strResultado = '';
        String strRespuesta = '';
        String strOperadorDonante = '';
        String strNumeroConexion = '';
        String strDonante = '';
        String strCorrelation = '';
        String strCreated = '';
        DateTime currentTime = System.now();
        DateTime fechaNIP = currentTime.addDays(-11);
        SObject objPrincipal;
        
        list < LogTransacciones__c > listLogServicio = new list < LogTransacciones__c > ();
        LogTransacciones__c logServicio = new LogTransacciones__c();
        
        list < OperacionComercial__c > lstOC = new list < OperacionComercial__c > ();
        list < Lineas_OC__c > lstLineaOC = new list < Lineas_OC__c > ();
        
        lstOC = [SELECT Id, NumeroConexion__c, LTE_Donante__c, LTE_SolicitadoPorTercero__c, NIP__c, CreatedDate, Reintento_NIP__c, Fecha_Vigencia_NIP__c
                 FROM OperacionComercial__c
                 WHERE Id =: idObjeto
                 AND Portacion__c =: true
                 AND Estado__c =: 'Pendiente'
                ];
        
        for (OperacionComercial__c oc: lstOC) {
            strOperadorDonante = oc.LTE_Donante__c;
            strNumeroConexion = oc.NumeroConexion__c;
            strCorrelation = oc.Id;
            strCreated = String.valueOf(oc.CreatedDate);
            if (oc.Fecha_Vigencia_NIP__c != null) {
                fechaNIP = oc.Fecha_Vigencia_NIP__c;
            }
        }
        
        if (lstOC.isEmpty()) {
            lstLineaOC = [SELECT Id,Linea__r.Codigo_de_linea__c,Linea__r.Tipo__c,Fecha_Vigencia_NIP__c,CreatedDate FROM Lineas_OC__c WHERE Id =: idObjeto];
            
            for (Lineas_OC__c sglLineaOc: lstLineaOC) {
                strOperadorDonante = sglLineaOc.Linea__r.Tipo__c;
                strNumeroConexion = sglLineaOc.Linea__r.Codigo_de_linea__c;
                strCorrelation =sglLineaOc.Id;
                strCreated = String.valueOf(sglLineaOc.CreatedDate);
                if (sglLineaOc.Fecha_Vigencia_NIP__c != null) {
                    fechaNIP = sglLineaOc.Fecha_Vigencia_NIP__c;
                }
            }
        }
        
        if (fechaNIP.addDays(10) > currentTime) {
            strResultado = 'La Fecha de Envío NIP es Menor a 10 Días.';
        } else {
            if (String.isNotEmpty(strCorrelation)) {
                if (!lstOC.isEmpty())
                    objPrincipal = lstOC[0];
                else
                    objPrincipal = lstLineaOC[0];
                
                
                list < String > lstDonante = strOperadorDonante.split('-');
                strDonante = lstDonante[1];
                
                mapValues.put('correlationID', strCorrelation);
                mapValues.put('numeroConexion', strNumeroConexion);
                mapValues.put('operadorDonante', strDonante);
                mapValues.put('fechaCreacion', strCreated);
                
                string strReq = LTE_GenXmlPortabilidadEntrante_cls.generarXmlSolicitudNIP(mapValues, 'E');
                strReq = strReq.replace('>null<', '><');
                
                ServiciosWeb__c sw = ServiciosWeb__c.getValues('PortabilidadGenerarNIP');
                if (!Test.isRunningTest()) {
                    strRespuesta = LibreriaUtilitaria_cls.consultarServicio(strReq, sw.Action__c, sw.EndPoint__c);
                } else
                    strRespuesta = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:WSResponseGeneracionNIP xmlns:ns0="http://www.etb.com.co/LTE/WS/webserviceportability/GeneracionNIP/OUT/1.0"><ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0"><ns1:System>Salesforce</ns1:System><ns1:Service><ns1:status>PASS</ns1:status></ns1:Service><ns1:Property/></ns1:WSResponseHeader><ns1:Respuesta xmlns:ns1="http://www.etb.com.co/LTE/portability/v1.0"><ns1:IdIntegracion>a09c0000007qMFoAAM</ns1:IdIntegracion><ns1:ErrorCode>0</ns1:ErrorCode><ns1:ErrorMessage/></ns1:Respuesta></ns0:WSResponseGeneracionNIP></SOAP-ENV:Body></SOAP-ENV:Envelope>';
                tibcoXml_cls.xmlMapConsulta objReq = new tibcoXml_cls.xmlMapConsulta();
                set < string > datac = objReq.getMap(strRespuesta);
                strResultado = objReq.valores.get('ErrorCode');
                
                if (strResultado == '0') logServicio.Estado__c = 'Exitoso';
                else logServicio.Estado__c = 'Conexión Fallida';
                logServicio.Informacion_Enviada__c = strReq;
                logServicio.Informacion_Recibida__c = strRespuesta;
                if (lstOC.size() > 0)
                    logServicio.LTE_Operacion_Comercial__c = strCorrelation;
                else
                    logServicio.Linea_OC__c = strCorrelation;
                logServicio.CodigoRespuesta__c = UserInfo.getSessionId();
                logServicio.Name = 'Generacion NIP' + ' ' + strNumeroConexion;
                
                listLogServicio.add(logServicio);
                insert listLogServicio;
                
                if (strResultado == '0') {
                    strResultado = 'Solicitud de NIP Enviada Correctamente!!!';
                    objPrincipal.put('Fecha_Vigencia_NIP__c',System.now());
                    update objPrincipal;
                } else {
                    strResultado = 'Falla al Enviar Solicitud de NIP - ' + strResultado;
                }
            } else {
                strResultado = 'El Id suministrado no permite Operaciones de NIP';
            }
        }
        
        return String.valueOf(strResultado);
    }

    public static String solicitudPortabilidadCedula(String idOperacionComercial, Date datFechaPortabilidad) {
        list < LogTransacciones__c > listLogServicio = new list < LogTransacciones__c > ();
        return null;
    }
    public static list < responseLotes > solicitudPortabilidadLinea(String idObjeto, Date datFechaPortabilidad){
        list < LogTransacciones__c > listLogServicio = new list < LogTransacciones__c > ();
        list < responseLotes > lstResponse = new list < responseLotes > ();
        list < Lineas_OC__c > lstLineasOC = new list < Lineas_OC__c > ();
        lstLineasOC = [SELECT Id, Linea__r.Name, Linea__r.Codigo_de_linea__c,LTE_SolicitadoPorTercero__c,
                       LTE_Observaciones__c,NIP__c,LTE_Donante__c,LTE_Tipo_de_Servicio__c,
                       Operacion_Comercial__r.Activo__r.Usuario_Integracion__c,
                       Operacion_Comercial__r.Activo__r.NombredelaCuenta__r.Direccion__c,
                       Operacion_Comercial__r.Activo__r.Numero_de_Identificacion_Integracion__c,
                       Operacion_Comercial__r.Activo__r.Tipo_de_Identificacion_integracion__c,
                       LTE_DocumentoCC__c, LTE_DocumentoAT__c, LTE_DocumentoID__c,
                       Portado_con_Cedula__c
                       FROM Lineas_OC__c WHERE Accion__c = 'Adicionar' AND Linea__r.Linea_ETB__c = 'Portada Movil'
                       AND (Estado__c = 'Pendiente' OR Estado__c = 'Portacion Rechazada')
                       AND (Id = :idObjeto OR Operacion_Comercial__c = :idObjeto)];
        for(Lineas_OC__c sglLineasOC:lstLineasOC){
            strIdentificador = sglLineasOC.Id;
            
            if (sglLineasOC.LTE_SolicitadoPorTercero__c){
                strSolTercero = '1';
                blnSolTercero = true;
            }else
                strSolTercero = '0';
            
            lstNumerosPortar.add(sglLineasOC.Linea__r.Name);
            Boolean portabilidadCedula = sglLineasOC.Portado_con_Cedula__c;

            system.debug('blnSolTercero desp del for --> ' + blnSolTercero);
            if (blnSolTercero && (strDocID == '' || strDocAT == '')) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La cuenta no tiene ningun documento asociado para ser solicitado por tercero'));
                return null;
            }
            if (!blnSolTercero && strDocCC == '' && !portabilidadCedula) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La cuenta no tiene ningun documento asociado para no ser solicitado por tercero'));
                return null;
            }
            if (portabilidadCedula && sglLineasOC.NIP__c == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La OC no Posee NIP por lo que No Puede Ser Solicitada la Portabilidad'));
                return null;
            }
            
            mapValues.put('strIdentificador', sglLineasOC.Id);
            mapValues.put('strObservaciones', sglLineasOC.LTE_Observaciones__c);
            mapValues.put('strVentanaAmpl', '1');
            mapValues.put('strNombreRazonSocial', sglLineasOC.Operacion_Comercial__r.Activo__r.Usuario_Integracion__c);
            mapValues.put('strDireccionAbonado', sglLineasOC.Operacion_Comercial__r.Activo__r.NombredelaCuenta__r.Direccion__c);
            mapValues.put('strIdentificacion', sglLineasOC.Operacion_Comercial__r.Activo__r.Numero_de_Identificacion_Integracion__c);
            mapValues.put('strDonante', sglLineasOC.LTE_Donante__c!=null?sglLineasOC.LTE_Donante__c.split('-')[1]:'');
            mapValues.put('strTipoUsuario', sglLineasOC.Operacion_Comercial__r.Activo__r.Tipo_de_Identificacion_integracion__c);
            mapValues.put('strTipoServicio', sglLineasOC.LTE_Tipo_de_Servicio__c == 'Prepago'?'1':'2');
            mapValues.put('strSolTercero', strSolTercero);
            mapValues.put('strNIP', sglLineasOC.NIP__c);
            mapValues.put('decNRN', string.valueOf(176));
            mapValues.put('DocumentoID', sglLineasOC.LTE_DocumentoID__c != null?sglLineasOC.LTE_DocumentoID__c:'');
            mapValues.put('strTypeDocID', sglLineasOC.LTE_DocumentoID__c != null?sglLineasOC.LTE_DocumentoID__c.split('\\x2E')[1]:'');
            mapValues.put('DocumentoAT', sglLineasOC.LTE_DocumentoAT__c != null?sglLineasOC.LTE_DocumentoAT__c:'');
            mapValues.put('strTypeDocAT', sglLineasOC.LTE_DocumentoAT__c != null?sglLineasOC.LTE_DocumentoAT__c.split('\\x2E')[1]:'');
            mapValues.put('DocumentoCC', sglLineasOC.LTE_DocumentoCC__c != null?sglLineasOC.LTE_DocumentoCC__c:'');
            mapValues.put('strTypeDocCC', sglLineasOC.LTE_DocumentoCC__c != null?sglLineasOC.LTE_DocumentoCC__c.split('\\x2E')[1]:'');
            
            string strReq = LTE_GenXmlPortabilidadEntrante_cls.generarXmlSolicitudPortabilidad(mapValues, lstNumerosPortar);
            
            system.debug('XML --> ' + strReq);
            
            strReq = strReq.replace('>null<', '><');
            strResp = enviaPortabilidad(strReq);
            system.debug('strResp desp  --> ' + strResp);
            LogTransacciones__c logServicio = new LogTransacciones__c();
            if (strResp == 'ack')
                logServicio.Estado__c = 'Exitoso';
            else
                logServicio.Estado__c = 'Conexión Fallida';
            logServicio.Informacion_Enviada__c = strReq.abbreviate(99999);
            logServicio.Informacion_Recibida__c = strResp;
            logServicio.Linea_OC__c = sglLineasOC.Id;
            logServicio.Name = 'Log Portabilidad Entrante ' + ' ' + sglLineasOC.Linea__r.Name;
            
            responseLotes objresponseLotes = new responseLotes();
            objresponseLotes.strRespuesta = strResp;
            objresponseLotes.strIdLegalizacion = sglLineasOC.Id;
            objresponseLotes.objLog = logServicio;
            
            lstResponse.add(objresponseLotes);
            
            system.debug('strResp --> ' + strResp);
            listLogServicio.add(logServicio);
            
            lstNumerosPortar.clear();
        }

        insert listLogServicio;

        return lstResponse;
    }
    
    public static list < responseLotes > solicitudPortabilidad(String idLegalizacion, Date datFechaPortabilidad) {
        list < LogTransacciones__c > listLogServicio = new list < LogTransacciones__c > ();
        list < responseLotes > lstResponse = new list < responseLotes > ();
        system.debug('llego a llamar WS');
        system.debug('idLegalizacion --> ' + idLegalizacion);
        system.debug('datFechaPortabilidad --> ' + datFechaPortabilidad);
        list < OperacionComercial__c > lstOC = new list < OperacionComercial__c > ();
        lstOC = [SELECT Id, NumeroConexion__c, Portacion__c, Activo__r.NombredelaCuenta__r.Id, Activo__r.NombredelaCuenta__r.Name, Activo__r.NombredelaCuenta__r.Direccion__c,
            Activo__r.NombredelaCuenta__r.AccountNumber, LTE_Donante__c, LTE_SolicitadoPorTercero__c, NIP__c, Activo__r.Numero_de_Identificacion_Integracion__c, Activo__r.Tipo_de_Identificacion_integracion__c, Activo__r.Usuario_Integracion__c, Causal_de_Devolucion__c, Estado__c, LTE_Tipo_de_Servicio__c
            FROM OperacionComercial__c
            WHERE Legalizacion__c =: idLegalizacion
            AND Portacion__c =: true
            AND Estado__c =: 'Pendiente'
        ];

        Legalizacion__c legData = [select LTE_DocumentoAT__c, LTE_DocumentoCC__c, LTE_DocumentoID__c, Portado_con_Cedula_c__c from Legalizacion__c where id =: idLegalizacion];

        for (OperacionComercial__c oc1: lstOC) {
            mapLineaOc.put(oc1.NumeroConexion__c, oc1);
        }

        if (!lstOC.isEmpty()) {
            lstAtt = [SELECT ContentType, Id, Name, ParentId, Body
                FROM Attachment
                WHERE ParentId =: lstOC[0].Activo__r.NombredelaCuenta__r.Id
            ];

            if (!lstAtt.isEmpty()) {
                for (Attachment doc: lstAtt) {
                    mapValuesDoc.put(doc.Name, doc);
                }
            }

            lstLote = [Select l.Id, l.Name, l.LTE_Observaciones__c, (Select LTE_NumeroLinea__c, LTE_Lote__c, LTE_ActivoETB__c From Detalle_de_Lote__r)
                From LTE_Lote__c l
                where LTE_Legalizacion__c =: idLegalizacion
            ];
            for (LTE_Lote__c lote: lstLote) {
                system.debug(lstLote.size() + ' ' + lote.Name);
                for (LTE_DetalleLote__c detLote: lote.Detalle_de_Lote__r) {
                    system.debug('mapLineaOc --> ' + mapLineaOc);
                    system.debug('lote.Detalle_de_Lote__r --> ' + lote.Detalle_de_Lote__r);
                    if (mapLineaOc.containsKey(detLote.LTE_NumeroLinea__c)) {
                        OperacionComercial__c oc = mapLineaOc.get(detLote.LTE_NumeroLinea__c);
                        system.debug('oc --> ' + oc);
                        strIdentificador = idLegalizacion;
                        strObservaciones = lote.LTE_Observaciones__c;
                        strVentanaAmpl = '1';
                        strNombreRazonSocial = oc.Activo__r.Usuario_Integracion__c;
                        strDireccionAbonado = oc.Activo__r.NombredelaCuenta__r.Direccion__c;
                        strIdentificacion = oc.Activo__r.Numero_de_Identificacion_Integracion__c;
                        strNIP = oc.NIP__c;
                        system.debug('oc.LTE_Donante__c --> ' + oc.LTE_Donante__c);
                        String strDonanteAbr = oc.LTE_Donante__c;
                        system.debug('strDonanteAbr --> ' + strDonanteAbr);
                        list < String > lstDonante = strDonanteAbr.split('-');
                        system.debug('lstDonante[0] --> ' + lstDonante[0]);
                        system.debug('lstDonante[1] --> ' + lstDonante[1]);
                        strDonante = lstDonante[1];
                        system.debug(oc);
                        system.debug('decTipoUsuario --> ' + oc.Activo__r.Tipo_de_Identificacion_integracion__c);
                        strTipoUsuario = oc.Activo__r.Tipo_de_Identificacion_integracion__c;
                        system.debug('oc.LTE_Tipo_de_Servicio__c --> ' + oc.LTE_Tipo_de_Servicio__c);
                        if (oc.LTE_Tipo_de_Servicio__c == 'Prepago')
                            strTipoServicio = '1';
                        else
                            strTipoServicio = '2';
                        system.debug('strTipoServicio --> ' + strTipoServicio);
                        //strNIP = '';
                        if (oc.LTE_SolicitadoPorTercero__c)
                            strSolTercero = '1';
                        else
                            strSolTercero = '0';
                        decNRN = 176;
                        strDocID = '';
                        strDocAT = '';
                        strDocCC = '';
                        string strNumero = '';

                        strNumero = oc.NumeroConexion__c;
                        lstNumerosPortar.add(strNumero);

                        List < LTE_DocPortabilidadEntrante__c > lstConfiguracion = LTE_DocPortabilidadEntrante__c.getall().values();
                        for (LTE_DocPortabilidadEntrante__c objConfig: lstConfiguracion) {
                            if (oc.LTE_SolicitadoPorTercero__c) {
                                lstDocumentos.add(objConfig.Name + '.pdf');
                                lstDocumentos.add(objConfig.Name + '.jpg');
                            } else {
                                if (objConfig.LTE_No_Tercero__c) {
                                    lstDocumentos.add(objConfig.Name + '.pdf');
                                    lstDocumentos.add(objConfig.Name + '.jpg');
                                }
                            }
                        }
                        for (String docConf: lstDocumentos) {
                            for (Attachment doc: mapValuesDoc.values()) {
                                if (mapValuesDoc.get(doc.Name) != null)
                                    lstAtt.add(doc);
                            }
                        }
                        system.debug('blnSolTercero antes --> ' + blnSolTercero);
                        //Valida si alguna OC es solicitada por tercero
                        if (oc.LTE_SolicitadoPorTercero__c)
                            blnSolTercero = true;
                        system.debug('blnSolTercero desp --> ' + blnSolTercero);
                    }
                    //}

                    strDocID = '';
                    strDocAT = '';
                    strDocCC = '';
                    list < string > lstTypeDoc1 = new list < string > ();


                    //LTE_DocumentoAT__c,LTE_DocumentoCC__c,LTE_DocumentoID__c from Legalizacion__c where id=:idLegalizacion];
                    list < string > Exten = new list < string > ();

                    if (legData.LTE_DocumentoCC__c != null) {
                        Exten = legData.LTE_DocumentoCC__c.split('\\x2E');
                        strTypeDocCC = Exten[1];
                        strDocCC = legData.LTE_DocumentoCC__c;

                    }
                    if (legData.LTE_DocumentoAT__c != null) {
                        Exten = legData.LTE_DocumentoAT__c.split('\\x2E');
                        strTypeDocAT = Exten[1];
                        strDocAT = legData.LTE_DocumentoAT__c;
                    }
                    if (legData.LTE_DocumentoID__c != null) {
                        Exten = legData.LTE_DocumentoCC__c.split('\\x2E');
                        strTypeDocID = Exten[1];
                        strDocID = legData.LTE_DocumentoID__c;
                    }
                    
                    Boolean portabilidadCedula = legData.Portado_con_Cedula_c__c;

                    system.debug('blnSolTercero desp del for --> ' + blnSolTercero);
                    if (blnSolTercero && (strDocID == '' || strDocAT == '')) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La cuenta no tiene ningun documento asociado para ser solicitado por tercero'));
                        return null;
                    }
                    if (!blnSolTercero && strDocCC == '' && !portabilidadCedula) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La cuenta no tiene ningun documento asociado para no ser solicitado por tercero'));
                        return null;
                    }
                    if (portabilidadCedula && lstOC[0].NIP__c == '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La OC no Posee NIP por lo que No Puede Ser Solicitada la Portabilidad'));
                        return null;
                    }
                    system.debug('Esta aca');

                    if (!lstLote.isEmpty()) {
                        mapValues.put('strIdentificador', lote.Id);
                        mapValues.put('strObservaciones', strObservaciones);
                        mapValues.put('strVentanaAmpl', '1');
                        mapValues.put('strNombreRazonSocial', strNombreRazonSocial);
                        mapValues.put('strDireccionAbonado', strDireccionAbonado);
                        mapValues.put('strIdentificacion', strIdentificacion);
                        mapValues.put('strDonante', strDonante);
                        mapValues.put('strTipoUsuario', strTipoUsuario);
                        mapValues.put('strTipoServicio', strTipoServicio);
                        mapValues.put('strSolTercero', strSolTercero);
                        mapValues.put('strNIP', strNIP);
                        mapValues.put('decNRN', string.valueOf(176));
                        mapValues.put('DocumentoID', strDocID);
                        mapValues.put('strTypeDocID', strTypeDocID);
                        mapValues.put('DocumentoAT', strDocAT);
                        mapValues.put('strTypeDocAT', strTypeDocAT);
                        mapValues.put('DocumentoCC', strDocCC);
                        mapValues.put('strTypeDocCC', strTypeDocCC);
                    } else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La Legalización no tiene ningún lote asociado'));
                    }
                    // ESTE}
                }
                
                                    system.debug('mapValues --> ' + mapValues);
                    string strReq = LTE_GenXmlPortabilidadEntrante_cls.generarXmlSolicitudPortabilidad(mapValues, lstNumerosPortar);

                    system.debug('XML --> ' + strReq);


                    strReq = strReq.replace('>null<', '><');
                    strResp = enviaPortabilidad(strReq);
                    system.debug('strResp desp  --> ' + strResp);
                    LogTransacciones__c logServicio = new LogTransacciones__c();
                    if (strResp == 'ack')
                        logServicio.Estado__c = 'Exitoso';
                    else
                        logServicio.Estado__c = 'Conexión Fallida';
                    logServicio.Informacion_Enviada__c = strReq.abbreviate(99999);
                    logServicio.Informacion_Recibida__c = strResp;
                    logServicio.LTE_Lote__c = lote.Id;
                    logServicio.LTE_Legalizacion__c = strIdentificador;
                    logServicio.Name = 'Log Portabilidad Entrante ' + ' ' + lote.Name;

                    responseLotes objresponseLotes = new responseLotes();
                    objresponseLotes.strRespuesta = strResp;
                    objresponseLotes.strIdLegalizacion = idLegalizacion;
                    objresponseLotes.objLog = logServicio;

                    lstResponse.add(objresponseLotes);

                    system.debug('strResp --> ' + strResp);
                    listLogServicio.add(logServicio);

                lstNumerosPortar.clear();
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La Legalización no tiene operaciones comerciales disponibles para realizar portación'));
        }

        insert listLogServicio;

        return lstResponse;
    }

    public static String enviaPortabilidad(String strRequ) {
        String strResultado = '';
        String strRespuesta = '';
        if (!Test.isRunningTest()) {
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('Portabilidad');
            strRespuesta = LibreriaUtilitaria_cls.consultarServicio(strRequ, sw.Action__c, sw.EndPoint__c);
            system.debug('strRespuesta --> ' + strRespuesta);
            tibcoXml_cls.xmlMapConsulta objReq = new tibcoXml_cls.xmlMapConsulta();
            set < string > datac = objReq.getMap(strRespuesta);
            strResultado = objReq.valores.get('Respuesta');
        } else
            strResultado = 'ack';
        return strResultado;
    }

    public class responseLotes {
        public string strRespuesta;
        public string strIdLegalizacion;
        public LogTransacciones__c objLog;
    }
}