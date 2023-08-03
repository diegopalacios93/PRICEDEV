/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Luis Rafael Peñaranda
Proyecto:           ETB LTE CORPORATIVO FASE II -POSVENTA
Descripción:        Clase para el envio del proceso de aprobacion del caso

Cambios (Versiones)
-----------------------------------------------------
No.     Fecha           Autor                                      Descripción
----    ----------      -----------------------------              ---------------
1.0     2015-12-07      Luis Rafale Peñaranda. (LRP)               Creación de la clase.
***********************************************************************************************************************/

public with sharing class LTE_AprobacionCasos_cls {
	
	public boolean EnviarProcesoAprovacionOpp( Case parCaso )
	{

		VariablesGlobales__c vgLob = VariablesGlobales__c.getValues('LTEPerfilAnaSopLTE');
		User objUser = getInfoUser();
		Id lteId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
		
		try{
			if( parCaso.Aprobaciones__c=='Oferta Realizada' && UserInfo.getProfileId()!=vgLob.valor__c)
			{			
				if(objUser.aprobador_lte__c!= null){
					Approval.ProcessSubmitRequest solicitud = new Approval.ProcessSubmitRequest();
					solicitud.setObjectId(parCaso.Id);				
					Approval.ProcessResult resultado = Approval.Process(solicitud);					
				}else{
					return false;					
				}	
		
			}
		}catch(exception e){
			system.debug(e.getMessage());
			// Mostrar error??
		
		}
		return true;
	}
	
	/*
	* @Metodo: 				validarDiasCalendario
	* @Descripcion:			Metodo encargado de calcular la fecha de corte para cada OC relacionada al caso
	* @Autor:				Luis Peñaranda (LRP)
	* @Fecha de creación:	07/12/2015
	*/
	public map<String, date>  calcularFechaCorteOpCom(list<OperacionComercial__c> listOC)
	{
		Integer intCicloFacturacion;
		Date fechaHoy = system.today();
		Date fechaCorteFinal;
		Date fechaCorteInicial;
		map<String, date> mapOCXFechaCorte = new map<String, date>();
		String tipoCambioPlan;
		
		map<String,String> mapPlanesXTipoControl = getPlanes();
		
		for(OperacionComercial__c objOC:listOC)
		{
			tipoCambioPlan = identificarTipoCambioPlan(mapPlanesXTipoControl,objOC.Activo__r.PlanReferenciaAnterior__c, objOC.Plan__r.Name  );
			
			if(tipoCambioPlan=='PrePos' || tipoCambioPlan=='PosPos'){			
				intCicloFacturacion = Integer.valueOf(objOC.CuentaFacturacion__r.LTE_CicloFacturacion__c);
				if(intCicloFacturacion != null)
				{
					fechaCorteFinal=null;
					
					// Fecha de corte incial
					Integer aniocorteInicial 	= 	fechaHoy.year();
					Integer mesCorteInicial 	= 	fechaHoy.month();
					Integer diaCorteInicial 	= 	intCicloFacturacion;				
					fechaCorteInicial 			= 	Date.newInstance(aniocorteInicial, mesCorteInicial, diaCorteInicial);
					system.debug('aniocorteInicial --> ' + aniocorteInicial);
					system.debug('mesCorteInicial --> ' + mesCorteInicial);
					system.debug('diaCorteInicial --> ' + diaCorteInicial);
					system.debug('fechaCorteInicial --> ' + fechaCorteInicial);
					system.debug('fechaHoy --> ' + fechaHoy);
					
					if(fechaHoy  < fechaCorteInicial){
						fechaCorteFinal= fechaCorteInicial;
					}else{
						fechaCorteFinal = fechaCorteInicial.addMonths(1);
					}
				}else{
					fechaCorteFinal=null;
				}
			}else{
				fechaCorteFinal=fechaHoy.addDays(1);
			}
			system.debug('objOC.id --> ' + objOC.id);
			system.debug('fechaCorteFinal --> ' + fechaCorteFinal);
			mapOCXFechaCorte.put(objOC.id,fechaCorteFinal);
		}
		return mapOCXFechaCorte;
	}
	
	// Identificar si el cambio de plan es paso desde Pre a Post y demas opciones
	// Posible salida: PrePos/PosPos/PosPre. // PVTA LRPA - 26-11-2015
	public static String identificarTipoCambioPlan(map<String,String> mapPlanesXTipoControl,String nombrePlanAnterior, String nombreNuevoPlan  ){
		
		system.debug('## nombrePlanAnterior-Entra->'+nombrePlanAnterior);
		system.debug('## nombreNuevoPlan-Entra->'+nombreNuevoPlan);
		string cadenaSalida='PosPos';
		string tipoControlPlanAnterior 	= 	mapPlanesXTipoControl.get(nombrePlanAnterior);
		string tipoControlPlanNuevo 	= 	mapPlanesXTipoControl.get(nombreNuevoPlan); 
		
		system.debug('## tipoControlPlanAnterior-Entra->'+tipoControlPlanAnterior);
		system.debug('## tipoControlPlanNuevo-Entra->'+tipoControlPlanNuevo); 
		
		if(tipoControlPlanAnterior=='Prepago'){
			if(tipoControlPlanNuevo=='Prepago'){
				cadenaSalida='PrePre';	
			}else{
				cadenaSalida='PrePos';
			}
		}else{
			if(tipoControlPlanNuevo=='Prepago'){
				cadenaSalida='PosPre';	
			}else{
				cadenaSalida='PosPos';
			}
		}
		
		system.debug('## cadenaSalida-Entra->'+cadenaSalida);
		return cadenaSalida;
	}

	// Posible salida: PrePos/PosPos/PosPre. // PVTA LRPA - 26-11-2015
	public static map<String,String> getPlanes(){
		
		map<String,String> mapPlanesXTipoControl = new map<String,String>();
		list <Planes__c> planAnterior = [SELECT Name,LTE_TipoControl__c FROM Planes__c ];
		for(Planes__c objPlan:planAnterior){
			mapPlanesXTipoControl.put(objPlan.Name,objPlan.LTE_TipoControl__c);
		}
		
		return mapPlanesXTipoControl;
	}
	
	// Obtener info del usuasrio
	public static User getInfoUser(){		
 		list<User> lstUser = [select aprobador_lte__c from user where id =:userInfo.getUserId() ];
		return lstUser.get(0);
	}
}