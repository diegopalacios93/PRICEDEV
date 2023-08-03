public class LTE_GenXmlPortabilidadEntrante_cls {
    public LTE_GenXmlPortabilidadEntrante_cls(map < string, string > mapValues, list < string > lstNumerosPortar) {
        system.debug('lstNumerosPortar 1 --> ' + lstNumerosPortar);
        /*string strResponse = generarXmlSolicitudPortabilidad(mapValues, lstNumerosPortar);
        String strRespuesta = LibreriaUtilitaria_cls.consultarServicio(strResponse, '/Service/intfPortabilidadImp-service.serviceagent/intfwsPortabilidadImpEndpoint1/PortabilidadCorp','http://201.245.171.239:7050/Service/Portabilidad-service.serviceagent/PortabilidadEndpoint');
        system.debug('strRespuesta --> ' + strRespuesta);
        tibcoXml_cls.xmlMapConsulta objReq = new tibcoXml_cls.xmlMapConsulta();
        set<string> datac = objReq.getMap(strRespuesta);
        system.debug('Respuesta --> ' + objReq.valores.get('Respuesta'));*/

    }

    public static String generarXmlSolicitudNIP(map < string, string > values, String operacion) {
        string xml = '';
        string fechaCreacion = values.get('fechaCreacion');
        string ano = fechaCreacion.substring(0,4);
        String mes = fechaCreacion.substring(5, 7);
        String dia = fechaCreacion.substring(8, 10);
            
        if (operacion == 'E') {
            xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/webserviceportability/GeneracionNIP/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/LTE/portability/v1.0">' +
                '<soapenv:Header/>' +
                '<soapenv:Body>' +
                '<ns:WSRequestGeneracionNIP>' +
                '<v1:WSRequestHeader>' +
                '<v1:System correlationID="' + values.get('correlationID') + '" processingServer="Salesforce">Salesforce</v1:System>' +
                '</v1:WSRequestHeader>' +
                '<v11:GeneracionNIP>' +
                '<v11:IdIntegracion>' + values.get('correlationID') + '</v11:IdIntegracion>' +
                '<v11:FechaCreacion>' + mes + '/' + dia + '/' + ano + ' 00:00:00</v11:FechaCreacion>' +
                '<v11:CodigoOperador>00007</v11:CodigoOperador>' +
                '<v11:Operacion>00</v11:Operacion>' +
                '<v11:TipoMensaje>0001</v11:TipoMensaje>' +
                '<v11:Observaciones/>' +
                '<v11:OperadorDonante>' + values.get('operadorDonante') + '</v11:OperadorDonante>' +
                '<v11:Numeracion>' + values.get('numeroConexion') + '</v11:Numeracion>' +
                '</v11:GeneracionNIP>' +
                '</ns:WSRequestGeneracionNIP>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
        } else {}
        if (operacion == 'R') {
            xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/webserviceportability/ReenvioNIP/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/LTE/portability/v1.0">' +
                '<soapenv:Header/>' +
                '<soapenv:Body>' +
                '<ns:WSRequestReenvioNIP>' +
                '<v1:WSRequestHeader>' +
                '<v1:System correlationID="' + values.get('correlationID') + '" processingServer="Salesforce">Salesforce</v1:System>' +
                '</v1:WSRequestHeader>' +
                '<v11:ReenvioNIP>' +
                '<v11:IdIntegracion>' + values.get('correlationID') + '</v11:IdIntegracion>' +
                '<v11:FechaCreacion>' + mes + '/' + dia + '/' + ano + ' 00:00:00</v11:FechaCreacion>' +
                '<v11:CodigoOperador>00007</v11:CodigoOperador>' +
                '<v11:Operacion>00</v11:Operacion>' +
                '<v11:TipoMensaje>0003</v11:TipoMensaje>' +
                '<v11:Observaciones/>' +
                '<v11:OperadorDonante>' + values.get('operadorDonante') + '</v11:OperadorDonante>' +
                '<v11:Numeracion>' + values.get('numeroConexion') + '</v11:Numeracion>' +
                '</v11:ReenvioNIP>' +
                '</ns:WSRequestReenvioNIP>' +
                '</soapenv:Body>' +
                '</soapenv:Envelope>';
        } else {}
        xml = xml.replace('>null<', '><');
        return xml;
    }

    public static string generarXmlSolicitudPortabilidad(map < string, string > values, list < string > lstNumerosPortar) {
        system.debug('values 1 --> ' + values);
        system.debug('lstNumerosPortar 2 --> ' + lstNumerosPortar);
        system.debug('values --> ' + values.get('strTipoServicio'));
        Datetime dttFechaHoraActual	= System.now();
	    String strCorrelationId = dttFechaHoraActual.format( 'mmss' ) + '';
        string xml = '';
        xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/lte/ws/webserviceportability/corp/in/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/lte/portability/corp/v1.0">' +
            '<soapenv:Header/>' +
            '<soapenv:Body>' +
            '<ns:WSRequestPortabilidad>' +
            ' <v1:WSRequestHeader>' +
            '<v1:System correlationID="' + values.get('strIdentificador') + '_' + strCorrelationId + '" processingServer="Salesforce">Salesforce</v1:System>' +
            '<v1:Property name="" value=""></v1:Property>' +
            '</v1:WSRequestHeader>' +
            '<v11:PortabilidadMsg>' +
            '<CabeceraMensaje>' +
            '<Identificador>' + values.get('strIdentificador') + '</Identificador>' +
            '<Observaciones>' + values.get('strObservaciones') + '</Observaciones>' +
            '</CabeceraMensaje>' +
            '<CuerpoMensaje>' +
            '<SolicitudPortacion>' +
            '<NombreRazonSocialAbonado>' + ((values.get('strNombreRazonSocial').Length() > 80) ? values.get('strNombreRazonSocial').substring(0, 79) : values.get('strNombreRazonSocial')) + '</NombreRazonSocialAbonado>' +
            '<DireccionAbonado>' + values.get('strDireccionAbonado') + '</DireccionAbonado>' +
            '<IdentificacionAbonado>' + values.get('strIdentificacion') + '</IdentificacionAbonado>' +
            '<Donante>' + values.get('strDonante') + '</Donante>' +
            '<TipoUsuario>' + values.get('strTipoUsuario') + '</TipoUsuario>' +
            '<TipoServicio>' + values.get('strTipoServicio') + '</TipoServicio>' +
            (string.isEmpty(values.get('strNIP'))  ? '': '<NIP>' + values.get('strNIP') + '</NIP>') +
            '<FlagVentanaAmpliada>' + values.get('strVentanaAmpl') + '</FlagVentanaAmpliada>' +
            '<SolicitudTerceros>' + values.get('strSolTercero') + '</SolicitudTerceros>' +
            '<ListaNumeracion>' +
            generaXmlListaNumeracion(lstNumerosPortar) +
            '</ListaNumeracion>' +
            '<NRN>' + values.get('decNRN') + '</NRN>' +
            '<DocumentoID>' + values.get('DocumentoID') + '</DocumentoID>' +
            '<DocumentoID_EXT>' + values.get('strTypeDocID') + '</DocumentoID_EXT>' +
            '<DocumentoAT>' + values.get('DocumentoAT') + '</DocumentoAT>' +
            '<DocumentoAT_EXT>' + values.get('strTypeDocAT') + '</DocumentoAT_EXT>' +
            '<DocumentoCC>' + values.get('DocumentoCC') + '</DocumentoCC>' +
            '<DocumentoCC_EXT>' + values.get('strTypeDocCC') + '</DocumentoCC_EXT>' +
            '</SolicitudPortacion>' +
            '</CuerpoMensaje>' +
            '</v11:PortabilidadMsg>' +
            '</ns:WSRequestPortabilidad>' +
            '</soapenv:Body>' +
            '</soapenv:Envelope>';
        xml = xml.replace('>null<', '><');
        system.debug(xml);
        return xml;
    }

    public static string generaXmlListaNumeracion(list < string > lstNumerosPortar) {
        system.debug('entro al genera al lista');
        system.debug('lstNumerosPortar 3 --> ' + lstNumerosPortar);
        string xml = '';
        for (string numero: lstNumerosPortar) {
            xml += //'<ListaNumeracion>'
                +'<Numero>' + numero + '</Numero>';
            //+'</ListaNumeracion>';
        }
        system.debug('xml 2 --> ' + xml);
        return xml;
    }

    public static string generarXmlFechaProgramacion(String strFechaProgramacion, String strIdLote, String strObservaciones) {
        //String strFechaPortabilidad = String.valueOf(datFechaProgramacion);
        String xml = '';
        xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/lte/ws/webserviceportability/corp/in/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/lte/portability/corp/v1.0">' +
            '<soapenv:Header/>' +
            '<soapenv:Body>' +
            '<ns:WSRequestPortabilidad>' +
            ' <v1:WSRequestHeader>' +
            '<v1:System correlationID="' + strIdLote + '" processingServer="Salesforce">Salesforce</v1:System>' +
            '<v1:Property name="" value=""></v1:Property>' +
            '</v1:WSRequestHeader>' +
            '<v11:PortabilidadMsg>' +
            '<CabeceraMensaje>' +
            '<Identificador>' + strIdLote + '</Identificador>' +
            '<Observaciones>' + strObservaciones + '</Observaciones>' +
            '</CabeceraMensaje>' +
            '<CuerpoMensaje>' +
            '<ProgramacionPortacion>' +
            '<FechaVentanaCambio>' + strFechaProgramacion + '</FechaVentanaCambio>' +
            '</ProgramacionPortacion>' +
            '</CuerpoMensaje>' +
            '</v11:PortabilidadMsg>' +
            '</ns:WSRequestPortabilidad>' +
            '</soapenv:Body>' +
            '</soapenv:Envelope>';
        system.debug('xml --> ' + xml);
        return xml;
    }
}