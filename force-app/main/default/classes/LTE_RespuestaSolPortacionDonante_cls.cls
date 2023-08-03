/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que obtendra la lógica para recibir la respuesta del Corte Ingles sobre la solicitud de portabilidad(1004)

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-03      Walter Rodríguez (WR)		        Creación de la clase.
***********************************************************************************************************************/
public class LTE_RespuestaSolPortacionDonante_cls 
{
	public static String strIdentificador;
	public static String strRespuestaABD;
    public static String strTipoMensaje;
    public static String strRechazoABD;
	public static list<LTE_PortabilidadEntrante_ws.NumeracionRechazada> lstNumRechazados = new list<LTE_PortabilidadEntrante_ws.NumeracionRechazada>();
	public static list<String> lstNumerosRechazados = new list<String>();
    
    public static LTE_PortabilidadEntrante_ws.LTE_Response respuestaSolicitudReeNIP ( LTE_PortabilidadEntrante_ws.PortabilidadMsg objReq)
    {
        LTE_PortabilidadEntrante_ws.LTE_Response objResp;
        strIdentificador = objReq.CabeceraMensaje.Identificador;
        strRespuestaABD = objReq.CuerpoMensaje.RespuestaSolicitudPortacionDonante.RespuestaABD;
        strTipoMensaje = objReq.CabeceraMensaje.TipoDeMensaje;
        if (strRespuestaABD == '0') {
            strRechazoABD = objReq.CuerpoMensaje.RespuestaSolicitudPortacionDonante.ListaNumeracionRechazada.NumeracionRechazada[0].CodigosRechazo[0].CodigoRechazo;
        }
        Id idRegistro = strIdentificador;
        
        String sql = 'SELECT Id FROM '+idRegistro.getsobjecttype()+' WHERE Id = :idRegistro';
        List<SObject> lstRegistros = Database.query(sql);
        
        if (strRespuestaABD == '1' && strTipoMensaje == '0002') {
            for(SObject sglRegistro:lstRegistros){
                sglRegistro.put('NIP_Solicitado__c',true);
                sglRegistro.put('Causal_de_Devolucion__c','Envío NIP:Exitoso');
            }
            update lstRegistros;
            //OperacionComercial__c oc = [ select Id from OperacionComercial__c where Id =: strIdentificador ];
            //oc.NIP_Solicitado__c = true;
            //oc.Causal_de_Devolucion__c = 'Envío NIP:Exitoso';
            //update oc;
        }
        if (strRespuestaABD == '0' && strTipoMensaje == '0002') {
            for(SObject sglRegistro:lstRegistros){
                sglRegistro.put('NIP_Solicitado__c',false);
                sglRegistro.put('Fecha_Vigencia_NIP__c',null);
                sglRegistro.put('Causal_de_Devolucion__c','Envío NIP:' + strRechazoABD);
            }
            update lstRegistros;
            //OperacionComercial__c oc = [ select Id from OperacionComercial__c where Id =: strIdentificador ];
            //oc.NIP_Solicitado__c = false;
            //oc.Fecha_Vigencia_NIP__c = null;
            //oc.Causal_de_Devolucion__c = 'Envío NIP:' + strRechazoABD;
            //update oc;
        }
        if (strRespuestaABD == '1' && strTipoMensaje == '0004') {
            for(SObject sglRegistro:lstRegistros){
                sglRegistro.put('Causal_de_Devolucion__c','Reenvío NIP:Exitoso');
            }
            update lstRegistros;
            //OperacionComercial__c oc = [ select Id from OperacionComercial__c where Id =: strIdentificador ];
            //oc.Causal_de_Devolucion__c = 'Reenvío NIP:Exitoso';
            //update oc;
        }
        if (strRespuestaABD == '0' && strTipoMensaje == '0004') {
            for(SObject sglRegistro:lstRegistros){
                sglRegistro.put('Causal_de_Devolucion__c','Reenvío NIP:' + strRechazoABD);
            }
            update lstRegistros;
            //OperacionComercial__c oc = [ select Id from OperacionComercial__c where Id =: strIdentificador ];
            //oc.Causal_de_Devolucion__c = 'Reenvío NIP:' +  strRechazoABD;
            //update oc;
        }
        return null;
    }
	
	public static LTE_PortabilidadEntrante_ws.LTE_Response respuestaPortacionDonante( LTE_PortabilidadEntrante_ws.PortabilidadMsg objReq )
	{
		system.debug('Entro');
		LTE_PortabilidadEntrante_ws.LTE_Response objResp;
		system.debug('objReq.CabeceraMensaje.Identificador --> ' + objReq.CabeceraMensaje.Identificador);
		strIdentificador = objReq.CabeceraMensaje.Identificador;
		system.debug('objReq.CuerpoMensaje.RespuestaSolicitudPortacionDonante.RespuestaABD --> ' + objReq.CuerpoMensaje.RespuestaSolicitudPortacionDonante.RespuestaABD);
		strRespuestaABD = objReq.CuerpoMensaje.RespuestaSolicitudPortacionDonante.RespuestaABD;
		if(strRespuestaABD == '1')
		{
			system.debug('Entro al 1');
			return new LTE_PortabilidadEntrante_ws.LTE_Response('OK, Todos los números fueron aceptados');
		}
		else
		{
			system.debug('Entro al 0');
			for(LTE_PortabilidadEntrante_ws.NumeracionRechazada numerosRechazados : objReq.CuerpoMensaje.RespuestaSolicitudPortacionDonante.ListaNumeracionRechazada.NumeracionRechazada)
			{
				lstNumRechazados.add(numerosRechazados);
			}
			system.debug('lstNumRechazados --> ' + lstNumRechazados);
			obtenerNumeros(lstNumRechazados);
		}
		
		return null;
	}
	
	public static void obtenerNumeros(list<LTE_PortabilidadEntrante_ws.NumeracionRechazada> lstNumeRechazados)
	{
		for(LTE_PortabilidadEntrante_ws.NumeracionRechazada numeroFallo : lstNumeRechazados)
		{
			lstNumerosRechazados.add(string.valueOf(numeroFallo.Numero));
		}
		
		system.debug('lstNumerosRechazados --> ' + lstNumerosRechazados);
		if(!lstNumerosRechazados.isEmpty())
		{
            list<OperacionComercial__c> lstOC = [Select Id, Causal_de_Devolucion__c, Estado__c, NumeroConexion__c, LTE_Url_documentos_rechazo__c from OperacionComercial__c where NumeroConexion__c IN : lstNumerosRechazados];
			
            if(!lstOC.isEmpty()){
                map<string, OperacionComercial__c> mapNumDocumento = new map<string, OperacionComercial__c>();
                for(OperacionComercial__c objOC : lstOC)
                {
                    mapNumDocumento.put(objOC.NumeroConexion__c ,objOC);
                }
                
                OperacionComercial__c objOperacionCcial = new OperacionComercial__c();
                for(LTE_PortabilidadEntrante_ws.NumeracionRechazada numRecibidos : lstNumeRechazados)
                {
                    objOperacionCcial = mapNumDocumento.get(string.valueOf(numRecibidos.Numero));
                    objOperacionCcial.Estado__c = 'Declinada';
                    objOperacionCcial.LTE_Url_documentos_rechazo__c = numRecibidos.DocumentoFC + '\n' + numRecibidos.DocumentoDC + '\n' + numRecibidos.DocumentoFR + '\n' + numRecibidos.DocumentoUO;
                    objOperacionCcial.Causal_de_Devolucion__c = 'Error de Portabilidad';
                }
                update mapNumDocumento.values();
            }else{
                list<Lineas_OC__c> lstlineasOC = [Select Id,Linea__r.Name from Lineas_OC__c where Linea__r.Name IN : lstNumerosRechazados];
                if(!lstlineasOC.isEmpty()){
                    map<string, Lineas_OC__c> mapNumDocumento = new map<string, Lineas_OC__c>();
                    for(Lineas_OC__c objLineaOC : lstlineasOC)
                    {
                        mapNumDocumento.put(objLineaOC.Linea__r.Name ,objLineaOC);
                    }
                
                    Lineas_OC__c sglLineaOC = new Lineas_OC__c();
                    for(LTE_PortabilidadEntrante_ws.NumeracionRechazada numRecibidos : lstNumeRechazados)
                    {
                        sglLineaOC = mapNumDocumento.get(string.valueOf(numRecibidos.Numero));
                        sglLineaOC.Estado__c = 'Declinada';
                        sglLineaOC.LTE_Url_documentos_rechazo__c = numRecibidos.DocumentoFC + '\n' + numRecibidos.DocumentoDC + '\n' + numRecibidos.DocumentoFR + '\n' + numRecibidos.DocumentoUO;
                        sglLineaOC.Causal_de_Devolucion__c = 'Error de Portabilidad';
                    }
                    update mapNumDocumento.values();
                }
            }
		}
		//llamar metodo para consultar lote y sacar el id de la legalización para traer todos los datos de la OC, armar 
		//un lote nuevo, armar un XML nuevo y lanzar de nuevo la portabilidad.
		if(strIdentificador.startsWith(LTE_Lote__c.sobjecttype.getDescribe().getKeyPrefix()))
            nuevoLlamadoWS(strIdentificador);
	}
	
	@future(callout=true)
	public static void nuevoLlamadoWS(String strIdentificadorLote)
	{
		list<LTE_Lote__c> lstLote = [select LTE_Legalizacion__c, LTE_FechaVentanaCambio__c, LTE_FechaMaxVentanaCambio__c from LTE_Lote__c where Id =: strIdentificadorLote];
		
		if(!lstLote.isEmpty())
		{
			system.debug('va a llamar a la portabilidad nuevamente');
			system.debug('lstLote[0].LTE_Legalizacion__c --> ' + lstLote[0].LTE_Legalizacion__c);
			system.debug('lstLote[0].LTE_FechaMaxVentanaCambio__c --> ' + lstLote[0].LTE_FechaVentanaCambio__c);
			LTE_SolicitudPortabilidad_cls.solicitudPortabilidad(lstLote[0].LTE_Legalizacion__c, lstLote[0].LTE_FechaMaxVentanaCambio__c);
		}
	}
}