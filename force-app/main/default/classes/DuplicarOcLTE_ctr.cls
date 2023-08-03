public with sharing class DuplicarOcLTE_ctr {

	transient public Map<string,string> param=new Map<string,string>();
	public boolean hasError{get;set;}
	public string ocJson{get;set;}

	public DuplicarOcLTE_ctr() {

		hasError=false;

		param=ApexPages.currentPage().getParameters();
		system.debug(param);

		if(param.get('id')==null){
			hasError=true;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Oc Invalida'));
		}

		List<OperacionComercial__c> ocList=new List<OperacionComercial__c>([select
				AprobadoMercadeoLTE__c, Id, Name,TOPP__c,TOPP__r.TipodeOperacionporplan__c,Plan__r.Name,Plan__r.Requiere_Aprobacion__c,Activo__r.Name,
				Plan__c,Plan__r.NombredelProducto__c,Plan__r.NombredelProducto__r.Familia__c from OperacionComercial__c
				Where
				id=:param.get('id') and TOPP__r.TipodeOperacionporplan__c='Venta' and
				Estado__c='Pendiente' And Activo__r.Estado__c='Pendiente' and
				Plan__r.NombredelProducto__r.LineaNegocio__c='REDES MOVILES']);

		//

		system.debug(ocList);
		if(ocList.isEmpty()){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Solo Operaciones Comerciales de Venta y cuya familia del producto sean LTE son validas'));
			hasError=true;
		}else{

			if(ocList[0].Plan__r.Requiere_Aprobacion__c==true && ocList[0].AprobadoMercadeoLTE__c!=True){
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'El plan solicitado Requiere Aprobación'));
				hasError=true;
			}
			ocJson=JSON.serialize(ocList[0]);

		}

	}

	@RemoteAction
	public static string duplicarOC(string ocinfo,string mobiles){

		Map<string,string> mapJson =(Map<string,string>)JSON.deserialize(ocinfo, Map<string,string>.class);
		Map<string,VariablesGlobales__c> vg = VariablesGlobales__c.getAll();

		string queryAC =LibreriaUtilitaria_cls.getQuery('ActivoETB__c', ' where id=\''+mapJson.get('Idac')+'\' ',false);
		system.debug(queryAC);
		ActivoETB__c ac = Database.query(queryAC);

		string queryOC =LibreriaUtilitaria_cls.getQuery('OperacionComercial__c', ' where id=\''+mapJson.get('Id')+'\' ',false);
		system.debug(queryOC);
		OperacionComercial__c oc = Database.query(queryOC);

		//Integer cantidadNotificacion=Integer.valueOf(vg.get('LTENotificacion').Valor02__c);
		Integer cantidad=Integer.valueOf(mapJson.get('cantidad'));

		List<ActivoETB__c> acClon=new List<ActivoETB__c>();
		List<OperacionComercial__c> ocClon=new List<OperacionComercial__c>();

		//clona ac
		for(Integer i=0;i<cantidad;i++){
			acClon.add(ac.clone(false, false, false, false));
		}
		Savepoint sp = Database.setSavepoint();

		try{
			insert acClon;
			//clona oc y relaciona con ac
			for(Integer i=0;i<cantidad;i++){
				OperacionComercial__c ocNew =oc.clone(false, false, false, false);
				ocNew.Activo__c=acClon[i].id;
				ocClon.add(ocNew);
			}
			LibreriaUtilitaria_cls.GenerarExcepcionTest();
			insert ocClon;
		}catch(exception e){
			Database.rollback(sp);
		}

		set<Id> idOcs=new set<Id>();

		for(OperacionComercial__c ocid:ocClon){
			idOcs.add(ocid.id);
		}

		map<id,OperacionComercial__c> creadas=new map<id,OperacionComercial__c>([select id,Name,Activo__r.Name from OperacionComercial__c where id IN :idOcs]);

/*
		system.debug(vg.get('LTENotificacion').Valor__c+' '+cantidadNotificacion+' '+cantidad);
		if(vg.get('LTENotificacion').Valor__c=='SI' && cantidadNotificacion<=cantidad){
			string plantilla=Label.DuplicarOcLTE_Notificacion.replaceAll('##cantidad##',mapJson.get('cantidad'));
			for(id cr:creadas.keySet()){
				plantilla+='<p>'+creadas.get(cr).Activo__r.Name+' - '+creadas.get(cr).Name+'</p>';
			}
			enviarCorreo(plantilla,vg.get('LTECorreo').Valor__c);
		}
*/

		return JSON.serialize(creadas.values());
	}
	
	/* Se quita la funcionalidad por que se realizara por Informes
	public static void enviarCorreo(string template, string user){

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setSenderDisplayName('Notificacion LTE');
			mail.setTargetObjectId(user);
			mail.setHtmlBody(template);
			mail.setSaveAsActivity(false);
			mail.setInReplyTo('no-responder@etb.com.co');

			try{
				Messaging.SendEmailResult[] repuesta=Messaging.sendEmail(new Messaging.singleemailMessage[] {mail});
					if(repuesta[0].isSuccess()){

					}else{

					}
				}
			catch(exception e){

			}

		}
		*/
}