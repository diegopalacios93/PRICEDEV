/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - Tiempo y Materiales
Descripción:            metodo que hace la validacion de la creacion en Opportunity                        

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     21-07-2014  Luis E Mogollón (LEM)       Creación de la clase..
*******************************************************************************/

public  class ValidacionCreacionOportunidad_cls {

//método que valida que una oportunidad no sea creada por un usuario que no sea colaborado o propietario de la cuenta,
//la colaboracion debe ser manual para que el usuario pueda crear/modificar oportunidades para la cuenta
public void ValidarOportunidad(list<Opportunity> lstOportunidades)
{
	//obtener el id del usuario que esta tratando de crear las oportunidades
	string perfilId = Userinfo.getProfileId().substring(0,15); 
	string usuarioid = Userinfo.getUserId();
	//recorrer las listas de las oportunidades para obtener las cuentas
	set<id> setAccountId = new set<id>();
	map<string,ConfPerfilesOportunidad__c> mapConfOpp = ConfPerfilesOportunidad__c.getAll();
	system.debug('map conf: '+mapConfOpp);
	system.debug('id perfil: '+perfilId);
	if(!mapConfOpp.containsKey(perfilId))
	{
	for(Opportunity oportunidad :lstOportunidades)
	{
		if(oportunidad.AccountId!=null)
			setAccountid.add(oportunidad.AccountId);
	}
	
	//buscar los registros de accountShare para las cuentas 
	map<id,Account> mapAccount = new map<id,Account>([select id ,OwnerId,Segmento__c, (select AccountId,UserOrGroupId from Shares where RowCause ='Manual' ) from Account where id in :setAccountId]);
    Id profileId=userinfo.getProfileId();
	//se recorren las oportunidades y se verifica que el usuario creador este colaborado
	for(Opportunity Opp :lstOportunidades)
	{
		//revisa que el usuario no sea el propietario de la cuenta
		boolean error =false;
		Id accountid = opp.AccountId;
		if(mapAccount.containsKey(accountid))
		{
			//revisar qeu el usuario sea igual a el propietario de la cuenta
			Account cuenta = mapAccount.get(accountid);
			if(cuenta.OwnerId!=usuarioId && cuenta.Segmento__c != 'MiPymes' && profileId != Label.Agentes_de_ventas_Experiencia)
			{
				error=true;
				//revisar si hay una cuenta colaborada
				for(AccountShare share :cuenta.Shares)
				{
					if(share.UserOrGroupId==usuarioId)
					{
						error=false;
						break;
					}
				}
			}
		}
		if(error)
		{
			Opp.addError(label.MensajeErrorCreacionOpp);
		}
	}
	} 
}
    public void isExperiencia(list<Opportunity> lstOportunidades){
        Id profileId = userinfo.getProfileId();        
        for(Opportunity opp :lstOportunidades){            
            if(profileId == Label.Agentes_de_ventas_Experiencia)
                opp.Canal_Externo__c = 'Experiencia - Cross Selling';            
        }        
    }
}