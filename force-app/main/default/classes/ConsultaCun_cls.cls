/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Jorge Grimaldos
Proyecto:               ETB - Integración CUN
Descripción:            Clase encargada de soportar el servicio Web de consulta CUN.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     04-03-2013  Jorge Grimaldos (JG)       Creación de la clase.
*******************************************************************************/
global class ConsultaCun_cls {
	//	Definicion de códigos de retorno y mensajes
	static Map<String, Estados_Respuestas_Webservice__c> mapMensajes = Estados_Respuestas_Webservice__c.getAll();
	//	Definición de la solicitud
	global class WebRequest {
		webservice String Telefono;
		webservice String CUN;
		webservice String Documento;
	}
	//	Definición de la respuesta
	global class WebResponse{
		webservice Integer Codigo;
		webservice String Mensaje;
		webservice List<EstadoCun> EstadoCun;
		//	Constructor de la respuesta, para evitar los Nil
		global WebResponse() {
			Codigo = ConsultaCunAux_cls.ESTADO_OK;
			EstadoCun = new List<EstadoCun>();
		}
	}
	//	Definición de EstadoCun
	global class EstadoCun{
		webservice Integer id;
		webservice String CUN;
		webservice String Nombre;
		webservice String Telefono;
		webservice String Documento;
		webservice String Cliente;
		webservice String DireccionFacturacion;
		webservice Datetime FechaIngreso;
		webservice Datetime FechaRespuesta;
		webservice String Tipo;
		webservice String Tipologia;
		webservice String CausalEstado;
		//	Constructor de Estado Cun, para evitar los Nil
		global EstadoCun() {
			id = -1;
			CUN = '';
			Nombre = '';
			Telefono = '';
			Documento = '';
			Cliente = '';
			DireccionFacturacion = '';
			FechaIngreso = Date.Today();
			FechaRespuesta = Date.Today();
			Tipo = '';
			Tipologia = '';
			CausalEstado  = '';
		}
	}
	//	Servicio Web de Consulta
	static webservice WebResponse ConsultarEstadoCun(WebRequest consulta) {
		WebResponse respuesta = new WebResponse();
		Integer intCodigo;
		//	Validación de Data entrante
		try {
			//	Función para poder controlar Excepciones en la clase de pruebas
			LibreriaUtilitaria_cls.GenerarExcepcionTest();
			intCodigo = ConsultaCunAux_cls.ValidarEntrante(consulta);
			//	Procesamiento de data
			if (intCodigo == ConsultaCunAux_cls.ESTADO_OK) {
				//	Creación de strings de Queries
				string strQueryCasos = ConsultaCunAux_cls.CrearQueryCaso(consulta);
				string strQueryLegalizaciones = ConsultaCunAux_cls.CrearQueryLegalizacion(consulta);
				//	Variables de binding
				String strCUN = consulta.CUN;
				String strDocumento = consulta.Documento;
				String strTelefono = consulta.Telefono;
				//	Consultas de legalizaciones y casos
				List<Case> lstCasos = new List<Case>();
				lstCasos = Database.query(strQueryCasos);
				List<Legalizacion__c> lstLegalizaciones = new List<Legalizacion__c>();
				lstLegalizaciones = Database.query(strQueryLegalizaciones);
				//	Creación de Estados CUN 
				List<EstadoCun> EstadosCun = new List<EstadoCun>();
				Integer intIndice = 1;
				//	Conversión de casos a Estados CUN
				if (!lstCasos.isEmpty()) {
					for (Case c : lstCasos) {
						EstadoCun e = ConsultaCunAux_cls.ConvertirCasoEstadoCUN(c, intIndice, consulta);
						EstadosCun.add(e);
						intIndice++;
					}
				}
				//	Conversión de legalizaciones a Estados CUN
				if (!lstLegalizaciones.isEmpty()) {
					for (Legalizacion__c l : lstLegalizaciones) {
						EstadoCun e = ConsultaCunAux_cls.ConvertirLegalizacionEstadoCUN(l, intIndice, consulta);
						EstadosCun.add(e);
						intIndice++;
					}
				}
				//	Asignación de Estados CUN a Respuesta
				if (EstadosCun.isEmpty()) {
					intCodigo = ConsultaCunAux_cls.ESTADO_NO_ENCONTRADO;
				} else {
					respuesta.EstadoCun = EstadosCun;
				}
			}
		//	Error interno
		} catch (Exception e) {
			respuesta = ConsultaCunAux_cls.ManejarErrorInterno(e);
		}
		//	Creación de respuesta
		if (respuesta.Codigo != ConsultaCunAux_cls.ESTADO_ERROR_INTERNO) {
			respuesta.Codigo = intCodigo;
			respuesta.Mensaje = mapMensajes.get(String.valueOf(respuesta.Codigo)).Mensaje__c;
		}
		return respuesta;
	}
	//	Servicio Dummy para Test
	static webservice WebResponse ConsultarEstadoCunDummy(WebRequest consulta) {
		//	Método de prueba de conectividad, únicamente para que el sistema CUN Center pueda realizar pruebas
		WebResponse respuesta = new WebResponse();
		respuesta.Codigo = ConsultaCunAux_cls.ESTADO_OK;
		respuesta.Mensaje = mapMensajes.get(String.valueOf(respuesta.Codigo)).Mensaje__c;
		List<EstadoCun> EstadosCun = new List<EstadoCun>();
		for (integer i = 0; i<3; i++) {
			EstadoCun e = new EstadoCun();
			e.id = i + 1;
			e.CUN = consulta.CUN;
			e.Nombre = 'Prueba ' + String.valueOf(i);
			e.Telefono = consulta.Telefono; 
			e.Documento = consulta.Documento;
			e.Cliente = 'Cliente';
			e.DireccionFacturacion = 'Dirección Facturación Cliente';
			e.FechaIngreso = Datetime.now();
			e.FechaRespuesta = Datetime.now();
			e.Tipo = 'TIPO';
			e.Tipologia = 'TIPOLOGIA';
			e.CausalEstado  = 'Resuelto';
			EstadosCun.add(e);            
		}
		respuesta.EstadoCun = EstadosCun;
		return respuesta;
	}
}