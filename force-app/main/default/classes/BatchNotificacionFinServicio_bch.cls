/**
 * @description       : Batch para l anotificación de la fecha final de los servicios a los asesores comerciales (Owner de la cuenta cliente)
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 03-09-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/

global class BatchNotificacionFinServicio_bch implements Database.Batchable<SObject>,Database.AllowsCallouts{

    global Database.Querylocator start(Database.Batchablecontext bc)
	{
		Date fecha = System.TODAY().addDays(15);
		System.debug('**fecha '+fecha);
		Datetime sdt = datetime.newInstance(fecha.year(), fecha.month(),fecha.day());
		String fecha15dias = sdt.format('yyyy-MM-dd');
		fecha = System.TODAY().addDays(30);
		sdt = datetime.newInstance(fecha.year(), fecha.month(),fecha.day());
		String fecha30dias = sdt.format('yyyy-MM-dd');
		String query = 'SELECT Id, CuentaCliente__r.Name, CuentaCliente__r.Owner.Name, CuentaCliente__r.Owner.email, Activo__r.Name, Activo__r.FechaInicioContrato__c,  Activo__r.FechaFinalContrato__c,  Activo__r.RenovacionAutomatica__c FROM OperacionComercial__c '+
					   'WHERE (Activo__r.FechaFinalContrato__c  = '+ fecha15dias +' OR Activo__r.FechaFinalContrato__c  = '+ fecha30dias +')';
		system.debug('**query: '+query);
		return Database.getQueryLocator(query);
	}
    
	global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){
		system.debug('**scope: '+scope);
		//se construye la lista definitiva
		Map<String,List<OperacionComercial__c>> ocs = new Map<String,List<OperacionComercial__c>>();
		
		//Consulta el servicio
		for(OperacionComercial__c oc: scope){
			
				if (ocs.containsKey(oc.CuentaCliente__r.Owner.email))
				{
					//ocs.get(oc.CuentaCliente__r.Owner.email).add(oc);
					Boolean noExiste = true;
                    for(OperacionComercial__c ocAux:ocs.get(oc.CuentaCliente__r.Owner.email))
                    {
                        if (ocAux.Activo__r.Name == oc.Activo__r.Name)
                        {
                            noExiste = false;
                            break;
                        }
                    }
                    
                    if(noExiste)
                    {
                       ocs.get(oc.CuentaCliente__r.Owner.email).add(oc);
                    }
				}
				
				else
				{
					List<OperacionComercial__c> ocAux = new List<OperacionComercial__c>();
					ocAux.add(oc);
					ocs.put(oc.CuentaCliente__r.Owner.email,ocAux);
				}
		}

		enviarCorreo(ocs);

	}
	
	global void finish(Database.BatchableContext bc){
		
		BatchNotificacionFinServicio_sch.ProgramarJob();
		system.debug('**!!!EXITO');
	}
		
	
	
	public void enviarCorreo(Map<String,List<OperacionComercial__c>> mapaEnvio){

	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    //Messaging.reserveSingleEmailCapacity(mapaEnvio.size());
	System.debug('***mapaEnvio '+mapaEnvio);
	for (String email : mapaEnvio.keySet())
		{
			Messaging.singleEmailMessage mail = new Messaging.singleEmailMessage();
			// mail.ToAddresses = new string[]{'mgpoligrafia@gmail.com'};//email
			system.debug('**email: ' + email);  
			// mail.setToAddresses(new string[]{email});//
			// mail.setSubject('Servicios próximos a finalizar');				
			// mail.setHtmlBody(getTableEmailBody(mapaEnvio.get(email)));
			// mail.setReplyTo('no-responder@etb.com.co');
			// mail.setSenderDisplayName('ETB');			
            
            String[] toAddresses = new String[] {email};
            
            // Assign the addresses for the To and CC lists to the mail object.
            System.debug('**toAddresses '+toAddresses);
            mail.setToAddresses(toAddresses);
            
            // Specify the address used when the recipients reply to the email. 
            mail.setReplyTo('no-responder@etb.com.co');
            
            // Specify the name used as the display name.
            mail.setSenderDisplayName('ETB');
            
            // Specify the subject line for your email address.
            mail.setSubject('Servicios próximos a finalizar');
            
            mail.setBccSender(false);
            mail.setUseSignature(false);
            
            mail.setHtmlBody(getTableEmailBody(mapaEnvio.get(email)));
            System.debug('*** '+getTableEmailBody(mapaEnvio.get(email)));
            // Send the email you have created.
            System.debug('*** ' + mail);
			System.debug('***mail.getToAddresses ' + mail.getToAddresses());
            System.debug('***getSubject() ' + mail.getSubject());
			mails.add(mail);
		}

		system.debug('mails: ' + mails);  
		Messaging.sendEmail(mails);
		//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mails[0] });
	}

	public String getTableEmailBody(List<OperacionComercial__c> myList){			
		
	//open table..
		String htmlBody = '<table border="1" style="border-collapse: collapse"><caption>Request Summary Data</caption>';
			htmlBody+= '<tr><th> Cliente </th><th> Servicio </th><th> Fecha Vencimiento </th><th> Renovación Automática </th> <th> Acción Requerida </th></tr>';
			
		//iterate over list and output columns/data into table rows...
		for(OperacionComercial__c l : myList){
			
			String cuentaCliente = l.CuentaCliente__r.Name; if(l.CuentaCliente__r.Name == null){cuentaCliente = '';}
			String servicio = l.Activo__r.Name; if(l.Activo__r.Name == null){servicio = '';}
			String fechaVencimiento = String.ValueOf(l.Activo__r.FechaFinalContrato__c); if(l.Activo__r.FechaFinalContrato__c == null){fechaVencimiento = '';}
			String renovacionAutomatica = l.Activo__r.RenovacionAutomatica__c?'SI':'NO';
			String accion = l.Activo__r.RenovacionAutomatica__c?'N/A':'Es necesario renovar el servicio.';
				
			
			htmlBody += '<tr><td>' + cuentaCliente + '</td><td>' + servicio + '</td><td>' + fechaVencimiento + '</td><td>' + renovacionAutomatica + '</td><td>' + accion + '</td></tr>';
			
		}
		
			//close table...
		htmlBody += '</table>';
		
		system.debug('**Email Body: ' + htmlBody);   
		
		return htmlBody;
		
	}

}