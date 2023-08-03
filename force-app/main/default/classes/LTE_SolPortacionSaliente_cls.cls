/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Raul Mora
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que contiene la logica del servicio expuesto LTE_PortabilidadSaliente_ws.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-03      Raul Mora (RM)		        Creación de la clase.
***********************************************************************************************************************/
public class LTE_SolPortacionSaliente_cls 
{
	/*
	* @Metodo: 		procesarPortabilidadSaliente
	* @Parametros:	LTE_PortabilidadSaliente_ws.PortabilidadMsg
	* @Descripcion:	Metodo encargado de procesar la portabilidad.
	*/
	public static void procesarPortabilidadSaliente( LTE_PortabilidadSaliente_ws.PortabilidadMsg objPortMsg )
	{
		system.debug('entro');
		//Ejecutar metodo que crea lote y detalle de lote.
		LTE_Lote__c objLot = crearLote( objPortMsg );
		system.debug('objLot --> ' + objLot.Id);
		//Ejecutar metodo que crea la tarea.
		crearTarea( objLot );
	}
	
	/*
	* @Metodo: 		crearLote
	* @Parametros:	LTE_PortabilidadSaliente_ws.PortabilidadMsg
	* @Descripcion:	Metodo encargado de crear el lote con el detalle de lote correspondiente a los numeros de linea enviados.
	*/
	public static LTE_Lote__c crearLote( LTE_PortabilidadSaliente_ws.PortabilidadMsg objPortMsg )
	{
		//Lote a crear
		LTE_Lote__c objLote = new LTE_Lote__c();
		//Se verifica que el servicio haya incluido el identificador
		if( String.isNotEmpty( objPortMsg.CabeceraMensaje.Identificador ) )
		{
			//Se diligencian los campos obtenidos del servicio
			objLote.LTE_Identificador__c = objPortMsg.CabeceraMensaje.Identificador;
			objLote.LTE_Observaciones__c = objPortMsg.CabeceraMensaje.Observaciones;
			objLote.LTE_NombreRazonSocialAbonado__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.NombreRazonSocialAbonado;
			objLote.LTE_DireccionAbonado__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.DireccionAbonado;
			objLote.LTE_Identificacion_Abonado__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.IdentificacionAbonado;
			objLote.LTE_Receptor__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.Receptor;
			objLote.LTE_TipoUsuario__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.TipoUsuario;
			objLote.LTE_TipoServicio__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.TipoServicio;
			//objLote.LTE_NIP__c = Double.valueOf( objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.NIP ); //No va. WRM
			objLote.LTE_SolicitudTerceros__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.SolicitudTerceros;
			objLote.LTE_NRN__c = Double.valueOf( objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.NRN );
			objLote.LTE_DocumentoID__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.DocumentoID;
			objLote.LTE_DocumentoAT__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.DocumentoAT;
			objLote.LTE_DocumentoCC__c = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.DocumentoCC;
			objLote.LTE_FlagVentanaAmpliada__c = true;
			
			try
			{
				insert objLote;
			}catch( exception e ){
				system.debug('\n\n --------- Error insert LTE_Lote__c clase LTE_SolPortacionSaliente_cls --------- \n'+e.getmessage());
			}
			//Asignamos a una lista los numeros obtenidos por el servicio.
			List<LTE_PortabilidadSaliente_ws.NumeracionProcesar> lstNumeros = objPortMsg.CuerpoMensaje.RespuestaSolicitudPortacionDonante.ListaNumeracion.NumeracionProcesar;
			//Se verifica que la lista de numeros no venga vacia
			if( !lstNumeros.isEmpty() )
			{
				//Map para almacenar los numeros con los registros de Servicio ETB relacionados
				map<String,String> mpNumerosServicio = new map<String,String>();
				//Se recorre la lista de numeros para almacenarlos en el mapa en el caso que la fuente sea Salesforce
				for( LTE_PortabilidadSaliente_ws.NumeracionProcesar objNumPro: lstNumeros )
				{
					//if( objNumPro.Fuente == System.Label.LTE_Salesforce ) //WRM
					//{
						mpNumerosServicio.put( objNumPro.Numero, '' );
					//}
				}
				//Se consultan los servicios ETB relacionados a los numeros.
				List<ActivoETB__c> lstActETB = [ Select Id, NumeroConexion__c From ActivoETB__c Where NumeroConexion__c In: mpNumerosServicio.keySet() ];
				mpNumerosServicio.clear();
				if( !lstActETB.isEmpty() )
				{
					for( ActivoETB__c objAct : lstActETB )
					{
						mpNumerosServicio.put( objAct.NumeroConexion__c, objAct.Id );
					}
				}
				//Lista detalle lote a crear
				List<LTE_DetalleLote__c> lstDetalleLote = new List<LTE_DetalleLote__c>();
				//Se consulta el nombre del lote creado
				LTE_Lote__c objLoteCreado = [ Select Id, Name From LTE_Lote__c Where Id =: objLote.Id ];
				//Objeto detalle lote a crear
				LTE_DetalleLote__c objDetalleLote;
				for( LTE_PortabilidadSaliente_ws.NumeracionProcesar objNumPro: lstNumeros )
				{
					objDetalleLote = new LTE_DetalleLote__c();
					objDetalleLote.LTE_Lote__c = objLoteCreado.Id;
					objDetalleLote.LTE_NumeroLinea__c = objNumPro.Numero;
					objDetalleLote.Name = objLoteCreado.Name + ' ' + objNumPro.Numero;
					objDetalleLote.LTE_Fuente__c = objNumPro.Fuente;
					objDetalleLote.LTE_ActivoETB__c = mpNumerosServicio.containsKey( objNumPro.Numero ) ? mpNumerosServicio.get( objNumPro.Numero ) : null ;
					lstDetalleLote.add( objDetalleLote );
				}
				
				try
				{
					insert lstDetalleLote;
				}catch( exception e ){
					system.debug('\n\n --------- Error insert LTE_DetalleLote__c clase LTE_SolPortacionSaliente_cls --------- \n'+e.getmessage());
				}
			}
		}
		
		return objLote;
	}
	
	/*
	* @Metodo: 		crearTarea
	* @Parametros:	LTE_Lote__c
	* @Descripcion:	Metodo encargado de crear la tarea para que el representante revise el lote creado.
	*/
	public static void crearTarea( LTE_Lote__c objLo )
	{
		//Se verifica que el lote no este nulo
		if( objLo != null )
		{
			//Variables para capturar el id de propietario y el asunto de la tarea
			String strIdProp = '';
			String strAunto = '';
			//Se consulta la configuracion personalizada para obtener el propietario y asunto de la tarea
			LTE_PortabilidadSalienteTarea__c confPerParamTarea = LTE_PortabilidadSalienteTarea__c.getOrgDefaults();
			//Se verifica que la configuracion personalizada tenga valores
			if( confPerParamTarea != null )
			{
				strIdProp = confPerParamTarea.LTE_IdPropietario__c;
				strAunto = confPerParamTarea.LTE_Asunto__c;
			}
			Task objTarea = new Task();
			objTarea.WhatId = objLo.Id;
			objTarea.Subject = strAunto;
			objTarea.OwnerId = strIdProp;
			//Envia notificiación. WRM
			Database.DMLOptions dmlo = new Database.DMLOptions();
			dmlo.EmailHeader.triggerUserEmail = true;
			database.insert (objTarea, dmlo);
			//insert objTarea;
		}
		 
	}
}