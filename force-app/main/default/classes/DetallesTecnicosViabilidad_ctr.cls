/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Jorge Grimaldos
Proyecto:				ETB - CRM Evolutivos
Descripción:			Controlador de la página DetallesTecnicosViabilidad_pag, 
						muestra el detalle técnico del activo en la página de 
						detalles de la Viabilidad

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		16-01-2014	Jorge Grimaldos (JG)		Creación de la clase
*******************************************************************************/

public with sharing class DetallesTecnicosViabilidad_ctr
{
	
	private id idViabilidad;
	private List<Viabilidad__c> lstObjViabilidades;
	private List<OperacionComercial__c> lstObjOperaciones;
	private List<ActivoETB__c> lstObjActivo = new List<ActivoETB__c>();

	// Constructor
	public DetallesTecnicosViabilidad_ctr(ApexPages.StandardController ctrViabilidad)
	{
		//	Obtención del id del registro de viabilidad entrante
		idViabilidad = ((Viabilidad__c)ctrViabilidad.getRecord()).id;
		if (idViabilidad != null)
		{
			//	Obtención del id de la operación comercial 
			lstObjViabilidades = [
			select Id, OperacionComercial__c 
			from Viabilidad__c 
			where Id = :idViabilidad 
			limit 1];
			if (lstObjViabilidades.size() != 0)
			{
				//	Obtención del id del activo 
				lstObjOperaciones = [
				select Id, Activo__c 
				from OperacionComercial__c 
				where Id = :lstObjViabilidades[0].OperacionComercial__c 
				limit 1];
				if (lstObjOperaciones.size() != 0)
				{
					//	Obtención de la data técnica del activo
					lstObjActivo = [
					select SucursalOrigen__r.Name, SucursalDestino__r.Name, NumeroConexion__c, 
					IDservicio__c, AnchoBanda__r.Name, ProveedorUM__c, MedioUM__c, CodigoUniversal__c, 
					Equipo__c, Id, Name FROM ActivoETB__c Where Id =: lstObjOperaciones[0].Activo__c LIMIT 1];
				}
			}
		}
	}

	//	Getter del activo para la VF
	public ActivoETB__c getActivo()
	{
		if (lstObjActivo.size() != 0)
		{
			return lstObjActivo[0];
		}
		else
		{
			return null;
		}
	}
	
	//	getter del booleano de control de render de la sección técnica
	public Boolean getExistenDetalles()
	{
		return lstObjActivo.size() != 0;
	}
}