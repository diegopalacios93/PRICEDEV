/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez 
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que obtendra los metodos necesarios para recibir los mensajes de error del Corte Ingles y generar 
					tareas al Analista de Soporte de la Legalización 

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-10      Walter Rodríguez (WR)		Creación de la clase.
***********************************************************************************************************************/
public class LTE_CreaTareaXError_cls 
{
	public static String strIdentificadorLote;
	public static String strObservaciones;
	public static String strIdentificadorMensajeErroneo;
	public static String strNumero;
	public static String strCodigoError;
	public static list<Legalizacion__c> lstLegalizacion = new list<Legalizacion__c>();
	public static list<LTE_Lote__c> lstLote = new list<LTE_Lote__c>();
	
	public static LTE_PortabilidadEntrante_ws.LTE_Response crearTareaXMensajedeError( LTE_PortabilidadEntrante_ws.PortabilidadMsg objReq )
	{
		LTE_PortabilidadEntrante_ws.LTE_Response objResp;
		system.debug('objReq.CabeceraMensaje.Identificador --> ' + objReq.CabeceraMensaje.Identificador);
		strIdentificadorLote = objReq.CabeceraMensaje.Identificador;
		strObservaciones = objReq.CabeceraMensaje.Observaciones;
		strIdentificadorMensajeErroneo = objReq.CuerpoMensaje.TipoErrorDetectadoABD.IdentificadorMensajeErroneo.IdentificadorMensajeErroneo;
		lstLote = [select LTE_Identificador__c from LTE_Lote__c where Id =: strIdentificadorLote];
		system.debug('lstLote --> ' + lstLote);
        if(!lstLote.isEmpty()){
            list<OperacionComercial__c> lstOC = [Select Id, Causal_de_Devolucion__c, Estado__c, NumeroConexion__c from OperacionComercial__c where Legalizacion__c =: lstLote[0].LTE_Identificador__c];
            lstLegalizacion = [select Id, AnalistaSoporteVentas__c from Legalizacion__c where Id =: lstLote[0].LTE_Identificador__c];
            
            if(!lstLegalizacion.isEmpty() && lstLegalizacion[0].AnalistaSoporteVentas__c != null)
            {
                Task objTarea = new Task();
                objTarea.WhatId = strIdentificadorLote;
                objTarea.Subject = 'Se presento el siguiente mensaje ' + strIdentificadorMensajeErroneo + 'se rechazo la legalización ' + lstLote[0].LTE_Identificador__c;
                objTarea.OwnerId = lstLegalizacion[0].AnalistaSoporteVentas__c;
                Database.DMLOptions dmlo = new Database.DMLOptions();
                dmlo.EmailHeader.triggerUserEmail = true;
                database.insert (objTarea, dmlo);
                //insert objTarea;
                for(OperacionComercial__c oc : lstOC)
                {
                    oc.Estado__c = 'Declinada';
                    oc.Causal_de_Devolucion__c = 'Error de Portabilidad';
                }
                //Bandera para evitar que se devuelva la actualización desde el detalle de la oferta.
                BanderasEjecucion.setEjecucion('DesenCadenaLegalizacion');
                update lstOC;
                return new LTE_PortabilidadEntrante_ws.LTE_Response('OK, Se a generado la tarea al analista de soporte de venta.');
            }
            else
            {
                for(OperacionComercial__c oc : lstOC)
                {
                    oc.Estado__c = 'Declinada';
                    oc.Causal_de_Devolucion__c = 'Error de Portabilidad';
                }
                //Bandera para evitar que se devuelva la actualización desde el detalle de la oferta.
                BanderasEjecucion.setEjecucion('DesenCadenaLegalizacion');
                update lstOC;
                return new LTE_PortabilidadEntrante_ws.LTE_Response('Fail, La legalización no existe o no tiene asignado un analista de soporte');
            }
        }else{
            list < Lineas_OC__c > lstLineaOC = new list < Lineas_OC__c > ();
            lstLineaOC = [SELECT Id FROM Lineas_OC__c WHERE Id = :strIdentificadorLote];
            
            for(Lineas_OC__c loc : lstLineaOC)
            {
                loc.Estado__c = 'Portacion Fallida';
                loc.Causal_de_Devolucion__c = 'Error de Portabilidad';
            }
            if(!lstLineaOC.isEmpty()){
                update lstLineaOC;
                return new LTE_PortabilidadEntrante_ws.LTE_Response('OK, Se ha actualizado el registro.');
            }
            return new LTE_PortabilidadEntrante_ws.LTE_Response('Fail, No se ha encontrado el registro');
        }
			
	}
	
	public static LTE_PortabilidadEntrante_ws.LTE_Response crearTareaError ( LTE_PortabilidadEntrante_ws.PortabilidadMsg objReq )
	{
		LTE_PortabilidadEntrante_ws.LTE_Response objResp;
		system.debug('objReq.CabeceraMensaje.Identificador --> ' + objReq.CabeceraMensaje.Identificador);
		strIdentificadorLote = objReq.CabeceraMensaje.Identificador;
		for(LTE_PortabilidadEntrante_ws.TipoListaNumeracionRechazadaABD listaNumRechazada : objReq.CuerpoMensaje.NumeracionesRechazadas.NumeracionesRechazadas)
		{
			for(LTE_PortabilidadEntrante_ws.TipoNumeracionRechazadaABD listaNumRechazadaABD : listaNumRechazada.NumeracionRechazada)
			{
				strNumero = listaNumRechazadaABD.Numero.TipoNumero;
				for(LTE_PortabilidadEntrante_ws.TipoListaCodigosRechazo listaCodRechazo : listaNumRechazadaABD.CodigosRechazo)
				{
					strCodigoError += listaCodRechazo.CodigoRechazo.TipoCodigoCausa + ' ';
				}
			}
		}
        
		lstLote = [select LTE_Identificador__c from LTE_Lote__c where Id =: strIdentificadorLote];
        if(!lstLote.isEmpty()){
            list<OperacionComercial__c> lstOC = [Select Id, Causal_de_Devolucion__c, Estado__c, NumeroConexion__c from OperacionComercial__c where Legalizacion__c =: lstLote[0].LTE_Identificador__c];
            system.debug('lstOC --> ' + lstOC);
            lstLegalizacion = [select Id, AnalistaSoporteVentas__c from Legalizacion__c where Id =: lstLote[0].LTE_Identificador__c];
            
            if(!lstLegalizacion.isEmpty() && lstLegalizacion[0].AnalistaSoporteVentas__c != null && strNumero != '' && strCodigoError != '')
            {
                Task objTarea = new Task();
                objTarea.WhatId = strIdentificadorLote;
                objTarea.Subject = 'Se presento el siguiente mensaje ' + strCodigoError + 'se rechazo la legalización ' + lstLote[0].LTE_Identificador__c;
                objTarea.OwnerId = lstLegalizacion[0].AnalistaSoporteVentas__c;
                Database.DMLOptions dmlo = new Database.DMLOptions();
                dmlo.EmailHeader.triggerUserEmail = true;
                database.insert (objTarea, dmlo);
                for(OperacionComercial__c oc : lstOC)
                {
                    oc.Estado__c = 'Declinada';
                    oc.Causal_de_Devolucion__c = 'Error de Portabilidad';
                }
                //Bandera para evitar que se devuelva la actualización desde el detalle de la oferta.
                BanderasEjecucion.setEjecucion('DesenCadenaLegalizacion');
                update lstOC;
                return new LTE_PortabilidadEntrante_ws.LTE_Response('OK, Se ha generado la tarea al analista de soporte de venta.');
            }
            else
            {
                for(OperacionComercial__c oc : lstOC)
                {
                    oc.Estado__c = 'Declinada';
                    oc.Causal_de_Devolucion__c = 'Error de Portabilidad';
                }
                //Bandera para evitar que se devuelva la actualización desde el detalle de la oferta.
                BanderasEjecucion.setEjecucion('DesenCadenaLegalizacion');
                update lstOC;
                return new LTE_PortabilidadEntrante_ws.LTE_Response('Fail, La legalización no existe o no tiene asignado un analista de soporte');
            }
        }else{
            list < Lineas_OC__c > lstLineaOC = new list < Lineas_OC__c > ();
            lstLineaOC = [SELECT Id FROM Lineas_OC__c WHERE Id = :strIdentificadorLote];
            
            for(Lineas_OC__c loc : lstLineaOC)
            {
                loc.Estado__c = 'Portacion Fallida';
                loc.Causal_de_Devolucion__c = 'Error de Portabilidad ' + strCodigoError;
            }
            if(!lstLineaOC.isEmpty()){
                update lstLineaOC;
                return new LTE_PortabilidadEntrante_ws.LTE_Response('OK, Se ha actualizado el registro.');
            }
            return new LTE_PortabilidadEntrante_ws.LTE_Response('Fail, No se ha encontrado el registro');
        }
	}
}