/*******************************************************************************
Desarrollado por:       Accenture
Autor:                  Luisina Platino
Proyecto:               ETB
Descripcion:            Clase que contendra todos los metodos necesarios para 
                        asegurar el proceso de las Oportunidades

Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                   Descripcion
------  ----------  --------------------    ---------------
1.0     14-06-2021  Luisina Platino (LP)    Creacion de la clase.
*******************************************************************************/

public class Opportunity_cls {
    public void sendBellNotification(Opportunity opp, Set<String> idrecipient) {

        CustomNotificationType notificationType = [
            SELECT Id, DeveloperName 
            FROM CustomNotificationType 
            WHERE DeveloperName ='Nuevo_porcentaje_Oportunidad'
        ]; 

        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        System.debug('opp '+opp);
        System.debug('idrecipient '+idrecipient);
        // Set the contents for the notification
        notification.setTitle('Oportunidad Actualizada');
        notification.setBody('La Oportunidad ' + opp.Name +' ha alcanzado el '+ opp.PDC__c);

        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(opp.Id);
        
        // Actually send the notification
        try {
            notification.send(idrecipient);
            System.debug('send');
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }

    public void Actualizar(list<Opportunity> lstInOpp){
		list<User> lstUser = new list<User>();
		set<string> stUser = new set<string>();
		map<string, User> mapUser = new map<string, User>();
		User usr;
		
		for(Opportunity o: lstInOpp){
			stUser.add(o.OwnerId);
		}		
		
		lstUser=[select id, ManagerId, Manager.ManagerId, EsGerente__c, EsDirector__c, 
				EsAsesor__c
				from User
				where id=:stUser];
		for(User u: lstUser){			
			mapUser.put(u.id, u);			
		}
		
		for(Opportunity o: lstInOpp){
			usr=mapUser.get(o.OwnerId);
			if(usr!=null && usr.EsAsesor__c){
				o.Director__c=usr.ManagerId;
				o.Gerente__c=usr.Manager.ManagerId;	
			}			
		}
	}

    public void ValidarOportunidad(list<Opportunity> lstOportunidades){
        //obtener el id del usuario que esta tratando de crear las oportunidades
        string perfilId = Userinfo.getProfileId().substring(0,15); 
        string usuarioid = Userinfo.getUserId();
        //recorrer las listas de las oportunidades para obtener las cuentas
        set<id> setAccountId = new set<id>();
        map<string,ConfPerfilesOportunidad__c> mapConfOpp = ConfPerfilesOportunidad__c.getAll();
        system.debug('map conf: '+mapConfOpp);
        system.debug('id perfil: '+perfilId);

        if(!mapConfOpp.containsKey(perfilId)){

            for(Opportunity oportunidad :lstOportunidades){
                if(oportunidad.AccountId!=null)
                    setAccountid.add(oportunidad.AccountId);
            }
            
            //buscar los registros de accountShare para las cuentas 
            map<id,Account> mapAccount = new map<id,Account>([select id ,OwnerId,Segmento__c, (select AccountId,UserOrGroupId from Shares where RowCause ='Manual' ) from Account where id in :setAccountId]);
            //se recorren las oportunidades y se verifica que el usuario creador este colaborado
            for(Opportunity Opp :lstOportunidades){
                //revisa que el usuario no sea el propietario de la cuenta
                boolean error =false;
                Id accountid = opp.AccountId;
                if(mapAccount.containsKey(accountid)){
                    //revisar qeu el usuario sea igual a el propietario de la cuenta
                    Account cuenta = mapAccount.get(accountid);
                    if(cuenta.OwnerId!=usuarioId && cuenta.Segmento__c != 'MiPymes' && userinfo.getProfileId() != Label.Agentes_de_ventas_Experiencia){
                        error=true;
                        //revisar si hay una cuenta colaborada
                        for(AccountShare share :cuenta.Shares){
                            if(share.UserOrGroupId==usuarioId){
                                error=false;
                                break;
                            }
                        }
                    }
                }
                if(error){
                    Opp.addError(label.MensajeErrorCreacionOpp);
                }
            }
        } 
    }

    public void EnviarProcesosAprovacionOpp( map<id,Opportunity> mpNuevaOpp ){

		VariablesGlobales__c vgLob = VariablesGlobales__c.getValues('LTEPerfilAnaSopLTE');

		Id lteId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
		
		for(Opportunity nuevo : mpNuevaOpp.values()){
			try{
				if(!nuevo.LTE_OportunidadBloqueada__c && nuevo.LTE_OfertaCustomizada__c && nuevo.EstadodeAprobacionDescuentos__c == null 
                && nuevo.recordTypeId==lteId && UserInfo.getProfileId()!=vgLob.valor__c){	

					Approval.ProcessSubmitRequest solicitud = new Approval.ProcessSubmitRequest();
					solicitud.setObjectId(nuevo.Id);				
					Approval.ProcessResult resultado = Approval.Process(solicitud);			
				}
			}catch(exception e){
				system.debug(e.getMessage());
				nuevo.addError(Label.LTE_MensajeErrorAprobadorLTE);
			}
		}
	}
    
    public void actualizarPromocionOC(Opportunity opp, List<OperacionComercial__c> listOC ){
        for (OperacionComercial__c OC : listOC) { 
          OC.ComponenteCampana__c = opp.ComponenteDeLaPromocion__c;
        }
        update listOC;
    }
}