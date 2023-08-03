/******************************************************************************* 
Desarrollado por:		Avanxo Colombia
Autor:					Andrés Garrido
Proyecto:				ETB - Integracion Suspenda
Descripcion:			Clase que arma el XML para Suspeda
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     18-01-2016  Andrés Garrido (AG)        Creacion de la clase
****************************************************************************/
global class LTE_ConsultaSuspenda_bch implements Database.Batchable<SObject>,Database.AllowsCallouts,Database.Stateful {
	public String strSoql;
	
	global set<String> setIdsOCsSuspenda;
	global map<String, list<LTE_Servicios_adicionales__c>> mapSAxOC;
	
	public LTE_ConsultaSuspenda_bch(){
		Date fecha = Date.today().addDays(1);
		String strMes = '0'+fecha.month();
		strMes = strMes.subString(strMes.length()-2, strMes.length());
		String strDia = '0'+fecha.day();
		strDia = strDia.subString(strDia.length()-2, strDia.length());
		setIdsOCsSuspenda = new set<String>();
		mapSAxOC = new map<String, list<LTE_Servicios_adicionales__c>>();
		
		String strFecha = fecha.year() + '-' + strMes + '-' + strDia;
		strSoql = 	'Select Id, Estado__c, Activo__c, Activo__r.NumeroConexion__c, Activo__r.NombredelaCuenta__r.Tipodedocumento__c, Comentarios__c, FechaInicioReconexion__c, ';
		strSoql += 	'Activo__r.NombredelaCuenta__r.AccountNumber, Activo__r.Fecha_Activacion__c, TipoSuspension__c, TOPP__r.TipodeOperacionporplan__c, LTE_URLFallos__c ';
		strSoql += 	'From OperacionComercial__c ';
		strSoql += 	'Where Estado__c=\'En Curso\' And (TOPP__r.TipodeOperacionporplan__c=\'Suspensión\' Or TOPP__r.TipodeOperacionporplan__c=\'Reconexión\') ';
		strSoql += 	'And TipoSuspension__c=\'Voluntaria\' ';
		strSoql += 	'And FechaInicioReconexion__c = '+strFecha;
		
		System.debug('@@@QueryBatchSuspenda===>'+strSoql);
	}
	
	global Database.Querylocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(strSoql);
	}
	
	global void execute(Database.BatchableContext BC, list<sObject> scope){
		list<OperacionComercial__c> lstOCs = (list<OperacionComercial__c>)scope;
		map<String, OperacionComercial__c> mapOC = new map<String,OperacionComercial__c>();
		set<String> idsServicios = new set<String>();
		
		set<String> setIdsOCs = new set<String>();
		
		for(OperacionComercial__c oc :lstOCs){
			String tipoTramite = oc.TOPP__r.TipodeOperacionporplan__c+', '+oc.TipoSuspension__c;
			mapOC.put((tipoTramite+'-'+oc.Activo__r.NumeroConexion__c),oc);
			idsServicios.add(oc.Activo__c);
			setIdsOCs.add(oc.Id);
		}
		
		//Obtengo los servicios adicionales relacionados con las operaciones comerciales
		//map<String, list<LTE_Servicios_adicionales__c>> mapSAxOC = new map<String, list<LTE_Servicios_adicionales__c>>();
		//map<String, list<LTE_SpecificationGroupXA__c>> mapSGxOC = new map<String, list<LTE_SpecificationGroupXA__c>>();
		
		list<LTE_Servicios_adicionales__c> lstSA = [
			Select 	Id, LTE_ServicioETB__c, LTE_ServiceActionCode__c, Name, LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c,
					LTE_ServicioETB__r.Plan__r.Name, LTE_DetalleOfertaEReservadoRegContable__c,
					(Select Id, Name, LTE_ActionCode__c, LTE_ParametroFacturacion__c, LTE_Value__c From SpecificationGroupXA__r) 
			From	LTE_Servicios_adicionales__c
			Where	LTE_ServicioETB__c IN :idsServicios
		];
		
		//Armo un mapa con los servicios adicionales de cada operacion comercial
		for(LTE_Servicios_adicionales__c sa : lstSA){
			//Lista para obtener los servicios adicionales de la OC
			list<LTE_Servicios_adicionales__c> lstSAAux;
			if(mapSAxOC.containsKey(sa.LTE_ServicioETB__c))
				lstSAAux = mapSAxOC.get(sa.LTE_ServicioETB__c);
			else
				lstSAAux = new list<LTE_Servicios_adicionales__c>();
				
			lstSAAux.add(sa);
			mapSAxOC.put(sa.LTE_ServicioETB__c, lstSAAux);
			
			//Lista para obtener los Specification Grouop de la OC
			/*list<LTE_SpecificationGroupXA__c> lstSGAux;
			if(mapSGxOC.containsKey(sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c))
				lstSGAux = mapSGxOC.get(sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c);
			else
				lstSGAux = new list<LTE_SpecificationGroupXA__c>();
			
			if(sa.SpecificationGroupXA__r != null && !sa.SpecificationGroupXA__r.isEmpty())
				lstSGAux.addAll(sa.SpecificationGroupXA__r);
				
			mapSGxOC.put(sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c, lstSGAux);*/
				
		}
			
		LTE_OperacionesSFDCSuspenda_cls cls = new LTE_OperacionesSFDCSuspenda_cls();
			
		//Invoco servicio web de suspensión
		map<String, LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda> mapRta = new map<String,LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda>();
		mapRta = cls.consultarSuspensionSevicios(null, '', true, setIdsOCs);
		
		System.debug('@@@RTA Servicio Suspenda===>'+mapRta);
		/*list<OperacionComercial__c> lstOCToSuspenda = new list<OperacionComercial__c>();
		
		
		list<LTE_Servicios_adicionales__c> lstAllSA = new list<LTE_Servicios_adicionales__c>();
		list<LTE_SpecificationGroupXA__c> lstAllSG = new list<LTE_SpecificationGroupXA__c>();
		
		set<String> setIdsOCsSuspenda = new set<String>();*/
		
		list<OperacionComercial__c> lstOCToDecline = new list<OperacionComercial__c>();
		//Proceso la respuesta de suspenda para la consulta
		for(OperacionComercial__c oc :lstOCs){
			String result = null;
			String tipoTramite = oc.TOPP__r.TipodeOperacionporplan__c+', '+oc.TipoSuspension__c;
			LTE_ConsultaSuspenda__c tram = LTE_ConsultaSuspenda__c.getAll().get(tipoTramite);
			system.debug('tram --> ' + tram);
			String strTramite = tram.Valor__c;
			system.debug('strTramite --> ' + strTramite);
			String llave = strTramite+'-'+oc.Activo__r.NumeroConexion__c;
			System.debug('\n@@@@@@Llave===>'+llave);
			result = oc.LTE_URLFallos__c == null ? '' : oc.LTE_URLFallos__c;
			if(mapRta.containsKey(llave)){
				system.debug('Entro al If');
				LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda res = mapRta.get(llave);
				oc.LTE_URLFallos__c = 'CONSULTA SUSPENDA - (Código Respuesta: '+res.CodigoRespuesta+') ' + res.DescripcionRespuesta;                
				if(res.CodigoFlujo == '1'){
					system.debug('Entro al 1');
					//Notificar a plataforma
				}
				else if(res.CodigoFlujo == '2'){
					system.debug('Entro al 2');
					System.debug('\n@@@@@@setIdsOCsSuspendaExecute Antes ===>'+setIdsOCsSuspenda);
					setIdsOCsSuspenda.add(oc.Id);
					System.debug('\n@@@@@@setIdsOCsSuspendaExecute Después ===>'+setIdsOCsSuspenda);
				}
                else if(res.CodigoFlujo == '4'){
					system.debug('Entro al 4');
					System.debug('\n@@@@@@setIdsOCsSuspendaExecute Antes ===>'+setIdsOCsSuspenda);
					setIdsOCsSuspenda.add(oc.Id);
					System.debug('\n@@@@@@setIdsOCsSuspendaExecute Después ===>'+setIdsOCsSuspenda);
				}
                else if(res.CodigoFlujo == '5'){
					system.debug('Entro al 5');
					System.debug('\n@@@@@@setIdsOCsSuspendaExecute Antes ===>'+setIdsOCsSuspenda);
					setIdsOCsSuspenda.add(oc.Id);
					System.debug('\n@@@@@@setIdsOCsSuspendaExecute Después ===>'+setIdsOCsSuspenda);
				}
				else if(res.CodigoFlujo == '3'){
					system.debug('Entro al 3');
					oc.Estado__c = 'Declinada';
					oc.Comentarios__c = res.lstTramites!=null?(res.lstTramites+''):'';
					lstOCToDecline.add(oc);
				}              
                else if(res.CodigoFlujo == '0'){
					system.debug('Entro al 0');
					oc.Estado__c = 'Declinada';
					oc.Comentarios__c = res.lstTramites!=null?(res.lstTramites+''):'';
					lstOCToDecline.add(oc);
				}              
				else
				{
					oc.Estado__c = 'Declinada';
					lstOCToDecline.add(oc);
				}				
			}
			else
			{
				result += '\nCONSULTA SUSPENDA - ' + Label.LTE_SuspendaSinRespuesta + ' \n';
				oc.LTE_URLFallos__c = result;
			}
		}
		//Actualizo las OC's con el código y la descripción de la respuesta del servicio.
		update lstOCs;
		System.debug('\n@@@@@@setIdsOCsSuspendaExecute===>'+setIdsOCsSuspenda);
		/*if(!setIdsOCsSuspenda.isEmpty()){
			mapRta = cls.registrarSuspensionSevicios(setIdsOCsSuspenda);
			
			//Proceso la respuesta de suspenda para el registro
			for(OperacionComercial__c oc :lstOCs){
				//String tipoTramite = (oc.TipoSuspension__c=='Voluntaria'&&oc.TOPP__r.TipodeOperacionporplan__c=='Suspensión')?'Suspensión, Voluntaria':((oc.TipoSuspension__c=='Voluntaria'&&oc.TOPP__r.TipodeOperacionporplan__c=='Reconexión')?'Reconexión, Voluntaria':'');
				//String llave = tipoTramite+'-'+oc.Activo__r.NumeroConexion__c;
				String llave = oc.Id;
				if(mapRta.containsKey(llave)){
					LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda res = mapRta.get(llave);
					if(res.CodigoRespuesta == '2'){
						string c ='LTE_TipodeOperacionProductoOnComplete.'+LibreriaUtilitaria_cls.quitarCaracteresEsp(oc.Topp__r.TipodeOperacionporplan__c.deleteWhitespace());
	
			            Type t = Type.forName(c);
			            if(t!=null){
			                LTE_Tramites_cls.Step paso =(LTE_Tramites_cls.Step) t.newInstance();
			                paso.oc = oc;
			                //paso.sa=sa;
			                paso.saActivo = mapSAxOC.get(oc.Activo__c);
			                paso.procesar();
			                //actionCode=paso.accion;
			                
			                lstAllSA.addAll(paso.saActivo);
			                lstAllSG.addAll(paso.SpecGroupXAList);
			            }
			            
			            oc.Estado__c = 'Activa';
						lstOCToSuspenda.add(oc);
					}
				}
				
			}
		}
		
		//Actualizo las OC's que se registraon es Suspenda
		if(!lstOCToSuspenda.isEmpty())
			update lstOCToSuspenda;
			
		*/
		
		//Actualizo las OC's declinadas
		/*if(!lstOCToDecline.isEmpty())
			update lstOCToDecline;
		
		//Actualizo la lista de servicios adiconales
		if(!lstAllSA.isEmpty())
			update lstAllSA;
			
		//Actualizo la lista de Specification Group
		if(!lstAllSG.isEmpty())
			update lstAllSG;	*/
		
	}
	
	global void finish(Database.BatchableContext BC){
		
		list<OperacionComercial__c> lstOCToSuspenda = new list<OperacionComercial__c>();
		list<OperacionComercial__c> lstOCToDecline = new list<OperacionComercial__c>();
		list<LTE_Servicios_adicionales__c> lstAllSA = new list<LTE_Servicios_adicionales__c>();
		list<LTE_SpecificationGroupXA__c> lstAllSG = new list<LTE_SpecificationGroupXA__c>();
		LTE_TramitesSuspenda__c tram;
		String tramiteSuspenda;
		System.debug('\n@@@@@@setIdsOCsSuspendaFinish===>'+setIdsOCsSuspenda);
		
		list<OperacionComercial__c> lstOCs = [
			Select 	Id, Estado__c, Activo__c, Activo__r.NumeroConexion__c, Activo__r.NombredelaCuenta__r.Tipodedocumento__c, Activo__r.LTE_Causal__c, Activo__r.Estado__c,
					Comentarios__c, FechaInicioReconexion__c, Activo__r.NombredelaCuenta__r.AccountNumber, Activo__r.Fecha_Activacion__c, TipoSuspension__c, TOPP__r.TipodeOperacionporplan__c, LTE_URLFallos__c
			From 	OperacionComercial__c
			Where	Id IN :setIdsOCsSuspenda
		];
		
		
		if(!setIdsOCsSuspenda.isEmpty()){
			LTE_OperacionesSFDCSuspenda_cls cls = new LTE_OperacionesSFDCSuspenda_cls();
			map<String, LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda> mapRta = cls.registrarSuspensionSevicios(setIdsOCsSuspenda);
			
			//Proceso la respuesta de suspenda para el registro
			for(OperacionComercial__c oc :lstOCs){
				//String tipoTramite = (oc.TipoSuspension__c=='Voluntaria'&&oc.TOPP__r.TipodeOperacionporplan__c=='Suspensión')?'Suspensión, Voluntaria':((oc.TipoSuspension__c=='Voluntaria'&&oc.TOPP__r.TipodeOperacionporplan__c=='Reconexión')?'Reconexión, Voluntaria':'');
				//String llave = tipoTramite+'-'+oc.Activo__r.NumeroConexion__c;
				String llave = oc.Id;
				String result = null;
				tramiteSuspenda = oc.TOPP__r.TipodeOperacionporplan__c + ', ' + oc.TipoSuspension__c;
				System.debug('tramiteSuspenda: ' + tramiteSuspenda);
				tram = LTE_TramitesSuspenda__c.getAll().get(tramiteSuspenda);
				result = oc.LTE_URLFallos__c == null ? '' : oc.LTE_URLFallos__c;                 
                   system.debug('FSE FALLOS:'+oc.LTE_URLFallos__c);
				if(mapRta.containsKey(llave)){
					LTE_OperacionesSFDCSuspenda_cls.wrpRespuestaSuspenda res = mapRta.get(llave);
					if(oc.LTE_URLFallos__c != null)
					{
						oc.LTE_URLFallos__c += ' REGISTRO SUSPENDA - (Código Respuesta: '+res.CodigoRespuesta+') ' + res.DescripcionRespuesta;
						if(oc.TOPP__r.TipodeOperacionporplan__c.contains(System.Label.LTE_Suspension))
						{
							oc.Activo__r.LTE_Causal__c = tram.LTE_Causal__c;
							oc.Activo__r.Estado__c = tram.LTE_EstadoServicio__c; 
						}
					}
					else
					{
						oc.LTE_URLFallos__c = ' REGISTRO SUSPENDA - (Código Respuesta: '+res.CodigoRespuesta+') ' + res.DescripcionRespuesta;
						if(oc.TOPP__r.TipodeOperacionporplan__c.contains(System.Label.LTE_Suspension))
						{
							oc.Activo__r.LTE_Causal__c = tram.LTE_Causal__c;
							oc.Activo__r.Estado__c = tram.LTE_EstadoServicio__c; 
						}
					}
					if(res.CodigoRespuesta == '1'){
						string c ='LTE_TipodeOperacionProductoOnComplete.'+LibreriaUtilitaria_cls.quitarCaracteresEsp(oc.Topp__r.TipodeOperacionporplan__c.deleteWhitespace());
	
			            Type t = Type.forName(c);
			            if(t!=null){
			                LTE_Tramites_cls.Step paso =(LTE_Tramites_cls.Step) t.newInstance();
			                paso.oc = oc;
			                //paso.sa=sa;
			                paso.saActivo = mapSAxOC.get(oc.Activo__c);
                            if(!Test.isRunningTest()){
			                	paso.procesar();
			                	//actionCode=paso.accion;
			                
			                	lstAllSA.addAll(paso.saActivo);
			                	lstAllSG.addAll(paso.SpecGroupXAList);
                            }
			            }
			            
			            oc.Estado__c = 'Activa';
						lstOCToSuspenda.add(oc);
					}
					else
					{
						oc.Estado__c = 'Declinada';
						lstOCToSuspenda.add(oc);
					}
				}
				else
				{
					result += '\nCONSULTA SUSPENDA - ' + Label.LTE_SuspendaSinRespuesta + ' \n';
					oc.LTE_URLFallos__c = result;
				}
			}
		}
		
		//Actualizo las OC's con el código y la descripción de la respuesta del servicio.
		update lstOCs;
		
		//Actualizo las OC's que se registraon es Suspenda
		if(!lstOCToSuspenda.isEmpty())
			update lstOCToSuspenda;
	
		
		//Actualizo la lista de servicios adiconales
		if(!lstAllSA.isEmpty())
			update lstAllSA;
			
		//Actualizo la lista de Specification Group
		if(!lstAllSG.isEmpty())
			update lstAllSG;
		
	}

}