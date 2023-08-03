/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez 
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que obtendra todos los metodos necesarios para la integración con Tibco para realizar la portabilidad entrante.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-07-30      Walter Rodríguez (WR)       Creación de la clase.
***********************************************************************************************************************/
global class LTE_PortabilidadEntrante_ws
{
    webservice static LTE_Response WSRequestSolicitudSincronizacionABD(PortabilidadMsg PortabilidadMsg)
    {
        GenerarLog(PortabilidadMsg);
        if(PortabilidadMsg.CabeceraMensaje.TipoDeMensaje == '1004')
            return LTE_RespuestaSolPortacionDonante_cls.respuestaPortacionDonante(PortabilidadMsg);
        if(PortabilidadMsg.CabeceraMensaje.TipoDeMensaje == '0002')
            return LTE_RespuestaSolPortacionDonante_cls.respuestaSolicitudReeNIP(PortabilidadMsg);
        if(PortabilidadMsg.CabeceraMensaje.TipoDeMensaje == '0004')
            return LTE_RespuestaSolPortacionDonante_cls.respuestaSolicitudReeNIP(PortabilidadMsg);
        if(PortabilidadMsg.CabeceraMensaje.TipoDeMensaje == '1005')
            return LTE_FechaMaxVentanaCambio_cls.fechaMaxVentanaCambio(PortabilidadMsg);
        if(PortabilidadMsg.CabeceraMensaje.TipoDeMensaje == '1007')
            return LTE_ConfirmacionFechaPortabilidad_cls.fechaConfirmada(PortabilidadMsg);
        if(PortabilidadMsg.CabeceraMensaje.TipoDeMensaje == '9998')
            return LTE_CreaTareaXError_cls.crearTareaXMensajedeError(PortabilidadMsg);
        if(PortabilidadMsg.CabeceraMensaje.TipoDeMensaje == '9999')
            return LTE_CreaTareaXError_cls.crearTareaError(PortabilidadMsg);
        return null;
    }
    
    global class PortabilidadMsg
    {
        webservice CabeceraMensaje CabeceraMensaje;
        webservice CuerpoMensaje CuerpoMensaje;
    }
    
    global class CabeceraMensaje
    {
        webservice String Identificador;
        webservice String Observaciones;
        webservice String TipoDeMensaje;
    }
    
    global class CuerpoMensaje
    {
        //mensaje 1004
        webservice RespuestaSolicitudPortacionDonante RespuestaSolicitudPortacionDonante;
        //mensaje 1005
        webservice String FechaMaxVentanaCambio;
        //mensaje 1007
        webservice String FechaVentanaConfirmada;
        //mensaje 9998
        webservice TipoErrorDetectadoABD TipoErrorDetectadoABD;
        //mensaje 9999
        webservice TipoRechazoPortacion NumeracionesRechazadas;
    }
    
    global class RespuestaSolicitudPortacionDonante
    {
        webservice String RespuestaABD;
        webservice ListaNumeracionRechazada ListaNumeracionRechazada;
    }
    
    global class ListaNumeracionRechazada
    {
        webservice List<NumeracionRechazada> NumeracionRechazada;
    }
    
    global class NumeracionRechazada
    {
        webservice String Numero;
        webservice String DocumentoFC;
        webservice String DocumentoDC;
        webservice String DocumentoFR;
        webservice String DocumentoUO;
        webservice List<CodigosRechazo> CodigosRechazo;
    }
    
    global class CodigosRechazo
    {
        webservice String CodigoRechazo;
    }
    
    global class TipoErrorDetectadoABD
    {
        webservice list<TipoListaCodigosRechazo> CodigosRechazo;
        webservice TipoIdentificadorMensaje IdentificadorMensajeErroneo;
    }
    
    global class TipoRechazoPortacion
    {
        webservice list<TipoListaNumeracionRechazadaABD> NumeracionesRechazadas;
    }
    
    global class TipoListaNumeracionRechazadaABD
    {
        webservice list<TipoNumeracionRechazadaABD> NumeracionRechazada;
    }
    
    global class TipoNumeracionRechazadaABD
    {
        webservice TipoNumero Numero;
        webservice list<TipoListaCodigosRechazo> CodigosRechazo;
    }
    
    global class TipoListaCodigosRechazo
    {
        webservice TipoCodigoCausa CodigoRechazo;
    }
    
    global class TipoCodigoCausa
    {
        webservice String TipoCodigoCausa;
    }
    
    global class TipoNumero
    {
        webservice String TipoNumero;
    }
    
    global class TipoIdentificadorMensaje
    {
        webservice String IdentificadorMensajeErroneo;
    }
    
    global class LTE_Response
    {
        webservice String strStatus;
        
        global LTE_Response(String strStatus)
        {
            this.strStatus = strStatus;
        }
    }
    
    public static void GenerarLog(PortabilidadMsg PortabilidadMsg){
        if(PortabilidadMsg.CabeceraMensaje.Identificador != null && PortabilidadMsg.CabeceraMensaje.Identificador.startsWith(LTE_Lote__c.sobjecttype.getDescribe().getKeyPrefix()))
        {
            LogTransacciones__c logServicio = new LogTransacciones__c();
            logServicio.Informacion_Recibida__c = String.valueOf(PortabilidadMsg);
            logServicio.LTE_Lote__c = PortabilidadMsg.CabeceraMensaje.Identificador;
            logServicio.Name = 'Log Portabilidad Entrante ' + ' ' + PortabilidadMsg.CabeceraMensaje.Identificador;
            insert logServicio;
        }
        else if(PortabilidadMsg.CabeceraMensaje.Identificador != null && PortabilidadMsg.CabeceraMensaje.Identificador.startsWith(OperacionComercial__c.sobjecttype.getDescribe().getKeyPrefix()))
        {
            LogTransacciones__c logServicio = new LogTransacciones__c();
            logServicio.Informacion_Recibida__c = String.valueOf(PortabilidadMsg);
            logServicio.LTE_Operacion_Comercial__c = PortabilidadMsg.CabeceraMensaje.Identificador;
            logServicio.Name = 'Log Portabilidad Entrante ' + ' ' + PortabilidadMsg.CabeceraMensaje.Identificador;
            insert logServicio;
        }
        else if(PortabilidadMsg.CabeceraMensaje.Identificador != null && PortabilidadMsg.CabeceraMensaje.Identificador.startsWith(Lineas_OC__c.sobjecttype.getDescribe().getKeyPrefix()))
        {
            LogTransacciones__c logServicio = new LogTransacciones__c();
            logServicio.Informacion_Recibida__c = String.valueOf(PortabilidadMsg);
            logServicio.Linea_OC__c = PortabilidadMsg.CabeceraMensaje.Identificador;
            logServicio.Name = 'Log Portabilidad Entrante ' + ' ' + PortabilidadMsg.CabeceraMensaje.Identificador;
            insert logServicio;
        }
    }
}