/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Raul Mora
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que obtendra todos los metodos necesarios para la integración con Tibco para realizar la portabilidad.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-03      Raul Mora (RM)		        Creación de la clase.
1.1     2015-08-05      Raul Mora (RM)		        Inclusión metodo para servicio de fecha ventana saliente confirmada.
***********************************************************************************************************************/
global class LTE_PortabilidadSaliente_ws 
{
	/*
	* @Metodo: 		WSRequestPortabilidadSaliente
	* @Parametros:	PortabilidadMsg
	* @Descripcion:	Metodo que sera cosumido para crear la solicitud de portabilidad.
	*/
	webservice static void WSRequestPortabilidadSaliente( PortabilidadMsg PortabilidadMsg )
	{
		LTE_SolPortacionSaliente_cls.procesarPortabilidadSaliente( PortabilidadMsg );
	}
	
	/*
	* @Metodo: 		WSRequestFechaVentanaSalienteConfirmada
	* @Parametros:	PortabilidadMsg
	* @Descripcion:	Metodo que sera consumido.
	*/
	webservice static void WSRequestFechaVentanaSalienteConfirmada( PortabilidadMsg PortabilidadMsg )
	{
		system.debug('PortabilidadMsg.CabeceraMensaje.Identificador --> ' + PortabilidadMsg.CabeceraMensaje.Identificador);
		system.debug('PortabilidadMsg.CuerpoMensaje.FechaVentanaConfirmada --> ' + PortabilidadMsg.CuerpoMensaje.FechaVentanaConfirmada);
		LTE_FechaVentanaSalienteConfirmada_cls.procesarFechaVentanaConfirmada( PortabilidadMsg.CabeceraMensaje.Identificador, PortabilidadMsg.CuerpoMensaje.FechaVentanaConfirmada );
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
	}
	
	global class CuerpoMensaje
	{
		//Mensaje 1002
		webservice RespuestaSolicitudPortacionDonante RespuestaSolicitudPortacionDonante;
		//mensaje 1005
		webservice String FechaMaxVentanaCambio;
		//Mensaje 1007
		webservice String FechaVentanaConfirmada;
		//mensaje 9999
		webservice TipoRechazoPortacion NumeracionesRechazadas;
		//mensaje 9998
		webservice TipoErrorDetectadoABD TipoErrorDetectadoABD;
		
	}
	
	global class ProgramacionPortacion
	{
		webservice Date FechaVentanaConfirmada;
	}
	
	global class RespuestaSolicitudPortacionDonante
	{
		webservice String NombreRazonSocialAbonado;
		webservice String DireccionAbonado;
		webservice String IdentificacionAbonado;
		webservice String Receptor;
		webservice String TipoUsuario;
		webservice String TipoServicio;
		webservice String NIP;
		webservice String SolicitudTerceros;
		webservice ListaNumeracion ListaNumeracion;
		webservice String NRN;
		webservice String DocumentoID;
		webservice String DocumentoAT;
		webservice String DocumentoCC;
	}
	
	global class ListaNumeracion
	{
		webservice List<NumeracionProcesar> NumeracionProcesar;
		
	}
	
	global class NumeracionProcesar
	{
		webservice String Numero;
		webservice String Fuente;
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
	
	global class TipoNumero
	{
		webservice String TipoNumero;
	}
	
	global class TipoListaCodigosRechazo
	{
		webservice TipoCodigoCausa CodigoRechazo;
	}
	
	global class TipoCodigoCausa
	{
		webservice String TipoCodigoCausa;
	}
	
	global class TipoErrorDetectadoABD
	{
		webservice list<TipoListaCodigosRechazo> CodigosRechazo;
		webservice TipoIdentificadorMensaje IdentificadorMensajeErroneo;
	}
	
	global class TipoIdentificadorMensaje
	{
		webservice String IdentificadorMensajeErroneo;
	}
	
}