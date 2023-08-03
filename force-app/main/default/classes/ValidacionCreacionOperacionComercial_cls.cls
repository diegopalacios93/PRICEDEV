/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Luis Eduardo Mogollón
Proyecto:               ETB - Tiempo y Materiales
Descripción:            metodo que hace la validacion de la creacion en Operación comercial                        

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     14-08-2014  Luis E Mogollón (LEM)       Creación de la clase..
*******************************************************************************/

public class ValidacionCreacionOperacionComercial_cls {

//método que valida que una operacion comercial no sea creada por un usuario que no sea colaborado o propietario de la cuenta,
//la colaboracion debe ser manual para que el usuario pueda crear/modificar oportunidades para la cuenta
public void ValidarOperacionComercial(list<OperacionComercial__c> lstOC)
{
	//obtener el id del usuario que esta tratando de crear las oportunidades
	string perfilId = Userinfo.getProfileId().substring(0,15); 
	string usuarioid = Userinfo.getUserId();
	//recorrer las listas de las oportunidades para obtener las cuentas
	set<id> setAccountId = new set<id>();
	// se utilizan los mismos perfiles de la oportunidad
	
	for(OperacionComercial__c oc :lstOC)
	{
		if(oc.CuentaCliente__c!=null)
			setAccountid.add(oc.CuentaCliente__c);
	}
	
	//buscar los registros de accountShare para las cuentas 
	map<id,Account> mapAccount = new map<id,Account>([select id ,OwnerId from Account where id in :setAccountId]);
	//se recorren las oportunidades y se verifica que el usuario creador este colaborado
	for(OperacionComercial__c oc :lstOC)
	{
		//revisa que el usuario no sea el propietario de la cuenta
		/*boolean error =false;
		Id accountid = oc.CuentaCliente__c;
		if(mapAccount.containsKey(accountid))
		{
			//revisar qeu el usuario sea igual a el propietario de la cuenta
			Account cuenta = mapAccount.get(accountid);
			if(cuenta.OwnerId!=usuarioId)
			{
				error=true;
				//revisar si hay una cuenta colaborada
				
			}
		}
		if(error)
		{
			OC.addError(label.MensajeErrorCreacionOperacion_Comercial);
		}*/
		Id accountid = oc.CuentaCliente__c;
		if(mapAccount.containsKey(accountid))
		{
			//revisar qeu el usuario sea igual a el propietario de la cuenta
			Account cuenta = mapAccount.get(accountid);
			oc.OwnerId = cuenta.OwnerId;
		}
	}
	
}


public void planAnterior(list<OperacionComercial__c> lstOC)
{
	//recoger todos los activos y crear un mapa
	set<string> idActivos = new set<string>();
	set<string> idTOPP = new set<string>();
	for(OperacionComercial__c oc :lstOC)
	{
		if(oc.Activo__c!=null)
			idActivos.add(oc.Activo__c);
			if(oc.TOPP__c!=null)
				idTOPP.add(oc.TOPP__c);
	}
	map<string,ActivoETB__c> mapActivos = new map<string,ActivoETB__c>([select id,Plan__c,Plan__r.Name from ActivoETB__c where id in :idActivos]);
	
	map<string,TOPP__c> mapTOPP = new map<string,TOPP__c>([Select TipodeOperacionporplan__c,id,Name From TOPP__c  where id in :idTOPP]);
	
	//validar que si la operacion por plan 
	for(OperacionComercial__c oc :lstOC)
	{
		if(oc.Estado__c=='Pendiente')
		{
			if(mapTOPP.containsKey(oc.TOPP__c))
			{
				TOPP__c top = mapTOPP.get(oc.TOPP__c);
				if(top.TipodeOperacionporplan__c=='Cambio de Plan')
				{
					//trae el activo 
					if(mapActivos.containsKey(oc.Activo__c))
					{
						if(oc.planAnterior__c != null && !oc.planAnterior__c.Contains('||')){// JDUR 2016/01/15
							ActivoETB__c activo = mapActivos.get(oc.Activo__c);
							oc.planAnterior__c = activo.Plan__r.Name;
						}
					}
				}
			}
		}
	}
}
public void planAnteriorBandaAncha(list<OperacionComercial__c> lstOC)
{
	set<string> idActivos = new set<string>();
	set<string> idTOPP = new set<string>();
	
	for(OperacionComercial__c oc :lstOC)
	{
		if(oc.Activo__c!=null)
			idActivos.add(oc.Activo__c);
			if(oc.TOPP__c!=null)
				idTOPP.add(oc.TOPP__c);

	}
	
	map<string,ActivoETB__c> mapActivos = new map<string,ActivoETB__c>([select id,Plan__c,Plan__r.Name,AnchoBanda__c,AnchoBanda__r.Name from ActivoETB__c where id in :idActivos]);
	
	map<string,TOPP__c> mapTOPP = new map<string,TOPP__c>([Select TipodeOperacionporplan__c,id,Name From TOPP__c  where id in :idTOPP]);
	
	
	
	for(OperacionComercial__c oc :lstOC)
	{
		if(oc.Estado__c=='Pendiente')
		{
			if(mapTOPP.containsKey(oc.TOPP__c))
			{
				TOPP__c top = mapTOPP.get(oc.TOPP__c);
				if(top.TipodeOperacionporplan__c=='Cambio de Plan')
				{
					//trae el activo 
					if(mapActivos.containsKey(oc.Activo__c))
					{
						ActivoETB__c activo = mapActivos.get(oc.Activo__c);
						oc.AnchoBandaAnt__c = activo.AnchoBanda__r.Name;
					}
				}
			}
		}
	}
	
}
}