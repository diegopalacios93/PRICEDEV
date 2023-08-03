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
public with sharing class ConsultaCunAux_cls {
	//	Constantes de códigos de error
	public final static Integer ESTADO_OK = 200;
	public final static Integer ESTADO_MAL_DATO = 400;
	public final static Integer ESTADO_MAL_NO_DATA = 401;
	public final static Integer ESTADO_NO_ENCONTRADO = 404;
	public final static Integer ESTADO_ERROR_INTERNO = 500;
	
	//	Validación de Data entrante
	public static Integer ValidarEntrante(ConsultaCun_cls.WebRequest consulta) {
		Boolean blnError = false;
		Integer intCodigo = ESTADO_OK;
		// Error: No hay datos de entrada
		if ( String.isEmpty(consulta.Telefono) && String.isEmpty(consulta.CUN) && String.isEmpty(consulta.Documento) ) {
			blnError = true;
			intCodigo = ESTADO_MAL_NO_DATA;
			System.debug('intCodigo:' + intCodigo);
		}
		//	Error: Datos inválidos
		if ( !blnError && (
			(String.isNotEmpty(consulta.CUN) && !consulta.CUN.isNumeric() && String.isNotEmpty(consulta.CUN)) ||
			(String.isNotEmpty(consulta.Documento) && !consulta.Documento.isNumeric() && String.isNotEmpty(consulta.Documento)) ||
			(String.isNotEmpty(consulta.Telefono) && !consulta.Telefono.isNumeric() && String.isNotEmpty(consulta.Telefono))
			)
		) {
			blnError = true;
			intCodigo = ESTADO_MAL_DATO;
		}
		return intCodigo;
	}
	
	//	Creación de Query para Casos
	public static String CrearQueryCaso(ConsultaCun_cls.WebRequest consulta) {
		string strQuery = 'Select Id, CaseNumber, Account.Name, Account.AccountNumber, Account.ParentId, Account.Parent.AccountNumber, Account.Direccion__c, Account.Parent.Direccion__c, CodigouniconumericoCUN__c, CreatedDate, ClosedDate, TipoCaso__c, Tipologia__c, Causal_Estado__c From Case Where ';
		//Determinación de parámetros
		if (String.isNotEmpty(consulta.CUN)) {
			strQuery += 'CodigouniconumericoCUN__c =:strCUN and '; 
		}
		if (String.isNotEmpty(consulta.Documento)) {
			strQuery += '( Account.AccountNumber =:strDocumento or Account.Parent.AccountNumber =:strDocumento) and CodigouniconumericoCUN__c != null and '; 
		}
		if (String.isNotEmpty(consulta.Telefono)) {
			strQuery += 'Id != null and Id in (Select Caso__c from OperacionComercial__c Where Activo__r.NumeroConexion__c =:strTelefono ) and CodigouniconumericoCUN__c != null '; 
		}
		strQuery = strQuery.removeEnd(' and ');
		System.debug('Query XML:' + strQuery);
		return strQuery;
	}

	//	Conversión de caso a EstadoCun
	public static ConsultaCun_cls.EstadoCun ConvertirCasoEstadoCUN(Case c, Integer intIndice, ConsultaCun_cls.WebRequest consulta) {
		ConsultaCun_cls.EstadoCun e = new ConsultaCun_cls.EstadoCun();
		e.id = intIndice;
		e.CUN = c.CodigouniconumericoCUN__c;
		e.Nombre = 'Caso ' + c.CaseNumber;
		e.Telefono = consulta.Telefono;
		e.Documento = (!String.isBlank(consulta.Documento)? consulta.Documento : (c.Account.Parent == null ? c.Account.AccountNumber : c.Account.Parent.AccountNumber) );
		e.Cliente = c.Account.Name;
		e.DireccionFacturacion = (c.Account.Parent == null ? c.Account.Direccion__c : c.Account.Parent.Direccion__c);
		e.FechaIngreso = c.CreatedDate;
		e.FechaRespuesta = c.ClosedDate;
		e.Tipo = c.TipoCaso__c;
		e.Tipologia = c.Tipologia__c;
		e.CausalEstado = c.Causal_Estado__c;
		return e;
	}

	//	Creación de Query para Legalizaciones
	public static String CrearQueryLegalizacion(ConsultaCun_cls.WebRequest consulta) {
		string strQuery = 'Select Id, Name, Contrato__r.Account.Name, Contrato__r.Account.AccountNumber, Contrato__r.Account.ParentId, Contrato__r.Account.Parent.AccountNumber, Contrato__r.Account.Direccion__c, Contrato__r.Account.Parent.Direccion__c, CodigouniconumericoCUN__c, CreatedDate, LastModifiedDate, Causal_Estado__c From Legalizacion__c Where ';
		//Determinación de parámetros
		if (String.isNotEmpty(consulta.CUN)) {
			strQuery += 'CodigouniconumericoCUN__c =:strCUN and '; 
		}
		if (String.isNotEmpty(consulta.Documento)) {
			strQuery += '( Contrato__r.Account.AccountNumber =:strDocumento or Contrato__r.Account.Parent.AccountNumber =:strDocumento) and CodigouniconumericoCUN__c != null and '; 
		}
		if (String.isNotEmpty(consulta.Telefono)) {
			strQuery += 'Id != null and Id in (Select Legalizacion__c from OperacionComercial__c Where Activo__r.NumeroConexion__c =:strTelefono ) and CodigouniconumericoCUN__c != null '; 
		}
		strQuery = strQuery.removeEnd(' and ');
		System.debug('Query XML:' + strQuery);
		return strQuery;
	}

	//	Conversión de Legalización a EstadoCun
	public static ConsultaCun_cls.EstadoCun ConvertirLegalizacionEstadoCUN(Legalizacion__c l, Integer intIndice, ConsultaCun_cls.WebRequest consulta) {
		ConsultaCun_cls.EstadoCun e = new ConsultaCun_cls.EstadoCun();
		e.id = intIndice;
		e.CUN = l.CodigouniconumericoCUN__c;
		e.Nombre = l.Name;
		e.Telefono = consulta.Telefono;
		e.Documento = (!String.isBlank(consulta.Documento)? consulta.Documento : (l.Contrato__r.Account.Parent == null ? l.Contrato__r.Account.AccountNumber : l.Contrato__r.Account.Parent.AccountNumber));
		e.Cliente = l.Contrato__r.Account.Name;
		e.DireccionFacturacion = (l.Contrato__r.Account.Parent == null ? l.Contrato__r.Account.Direccion__c : l.Contrato__r.Account.Parent.Direccion__c);
		e.FechaIngreso = l.CreatedDate;
		e.FechaRespuesta = l.LastModifiedDate;
		e.Tipo = 'Venta';
		e.Tipologia = 'Venta';
		e.CausalEstado = l.Causal_Estado__c;
		return e;
	}

	//	Manejo de Errores Internos
	public static ConsultaCun_cls.WebResponse ManejarErrorInterno( Exception e) {
		ConsultaCun_cls.WebResponse respuesta = new ConsultaCun_cls.WebResponse();
		respuesta.Codigo = ESTADO_ERROR_INTERNO;
		respuesta.Mensaje = Estados_Respuestas_Webservice__c.getAll().get(String.valueOf(respuesta.Codigo)).Mensaje__c +':' + e.getMessage();
		return respuesta;
	}
}