public class envio_cls {
    
    public static void enviar(){
        //envio_cls.enviar();
        list<Cola_CUN__c> cs =new list<Cola_CUN__c>([SELECT Contacto__r.Email,Cliente__c,Cod_Error_Cun__c,Contacto__c,Envio_Correo__c,esRastrocun__c,Estado_Envio__c,FechaPQR__c,Id,Identificacion__c,Id_Registro__c,Intentos__c,Mensaje_DML__c,Name,Nombre_Contacto__c,NumCun__c,NumOrden__c,Objeto__c,Razon_Social__c,Remitente__c,response__c,TipoIdentificacion__c,TipoPQR__c,Reenviar_Correo__c FROM Cola_CUN__c WHERE Reenviar_Correo__c=true limit 9]);
        
        for(Cola_CUN__c colMail:cs){
        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setSenderDisplayName(colMail.Remitente__c);
			mail.setReplyTo(colMail.Remitente__c);
            mail.setInReplyTo(colMail.Remitente__c);
            mail.setReferences(colMail.Remitente__c);
			mail.setTargetObjectId(colMail.Contacto__c);
			mail.setTemplateId('00X40000001qu46EAA');
            					//00X40000001qu46EAA
            					//00Xf0000000DxXz pruebas
            
			mail.setWhatId(colMail.id);
			mail.setToAddresses(new String[]{colMail.Contacto__r.Email});
			//mail.setSubject('ETB le informa acerca de su caso '+colMail.NumCun__c +'(Número CUN)');
            mail.setBccAddresses(new list<string>{'hector_bayona@hotmail.com','constanza.rodriguezf@etb.com.co'});//'luz.romeroc@etb.com.co' 
			//mail.saveAsActivity = true;

			try{
				Messaging.SendEmailResult[] repuesta=Messaging.sendEmail(new Messaging.singleemailMessage[] {mail});
					if(repuesta[0].isSuccess()){
						colMail.Envio_Correo__c='Envio Exitoso';
                        colMail.Reenviar_Correo__c=false;
					}else{
						colMail.Envio_Correo__c='Envio Fallido';
                        colMail.Reenviar_Correo__c=true;
					}
				}
			catch(exception e){
				colMail.Envio_Correo__c=e.getMessage();
                colMail.Reenviar_Correo__c=true;

			}
        
    }
    update cs;
    }
    

}