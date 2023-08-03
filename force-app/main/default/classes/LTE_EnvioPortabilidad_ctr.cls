/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase con la lógica para que el usuario seleccione la fecha deseada para realizar la portabilidad y se realice el envío

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-07-29      Walter Rodríguez (WR)		Creación de la clase.
***********************************************************************************************************************/
public class LTE_EnvioPortabilidad_ctr 
{
	private final Apexpages.Standardcontroller ctr;
	public Decimal dcDiasTranscurridos; 
	public Date datFechaPortabilidad {get;set;}
	public string strId {get;set;}
	public Legalizacion__c leg {get; set;}
	public Boolean blnHabilitar {get; set;}
	public Boolean mostrarEstado {get; set;}
	public static list<LTE_Lote__c> lstLote = new list<LTE_Lote__c>();
	public static BusinessHours objBH
	{
		get
		{
			if(objBH == null)
			{
				objBH =
				[
					select id, Name, MondayStartTime, MondayEndTime, TuesdayStartTime, TuesdayEndTime, 
							WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, 
							FridayStartTime, FridayEndTime, SaturdayStartTime, SaturdayEndTime
					from BusinessHours
					where Name = :'Horario ETB'
				];
			}
			return objBH;
		}
		set;
	}
	public string strRespuesta;
	
	public LTE_EnvioPortabilidad_ctr(Apexpages.Standardcontroller controller)
	{
		//ctr = controller;
		leg = new Legalizacion__c();
		datFechaPortabilidad = date.valueOf(leg.Fecha1radevolucion__c);
		dcDiasTranscurridos = 0.0; 
		//this.strId = controller.getId();
		
		leg = (Legalizacion__c)controller.getRecord();
		leg = [Select id, Estado__c from Legalizacion__c where id=:leg.id];
		
		system.debug(leg.Estado__c);
		
		strRespuesta = '';
		blnHabilitar = false;
		
		mostrarEstado=true;
		if(leg.Estado__c=='Pendiente por portabilidad' || leg.Estado__c=='Gestionado'){
			mostrarEstado=false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No se puede reenviar si se encuentra en estado '+leg.Estado__c));		
	}
	}
	
	public pageReference enviarPortabilidad()
	{
		list<LTE_SolicitudPortabilidad_cls.responseLotes> lstResponse = new list<LTE_SolicitudPortabilidad_cls.responseLotes>();
		system.debug('esta aca');
		system.debug(datFechaPortabilidad);
		if(datFechaPortabilidad != null)
		{
			long milisegundos = BusinessHours.diff(objBH.id, system.today(), datFechaPortabilidad);
			dcDiasTranscurridos = diasTranscurridos(milisegundos);
			system.debug('dcDiasTranscurridos --> ' + dcDiasTranscurridos);
			system.debug('datFechaPortabilidad --> ' + datFechaPortabilidad);
			integer diasPort=integer.valueOf(VariablesGlobales__c.getValues('PortabilidadDias').Valor__c);
			Date datFechaMinima = system.today().addDays(diasPort);
			system.debug('datFechaMinima --> ' + datFechaMinima);
			Date datFechaMaxima = system.today().addDays(30);
			system.debug('datFechaMaxima --> ' + datFechaMaxima);
		
			if(dcDiasTranscurridos > diasPort && dcDiasTranscurridos < 30)
			{ 
				system.debug('esta en el if');
				lstLote = [select Id, LTE_FechaVentanaCambio__c, LTE_Observaciones__c from LTE_Lote__c where LTE_Legalizacion__c =: leg.Id];
				if(!lstLote.isEmpty())
				{
					// Coloca la fecha seleccionada por el usuario para la portabilidad en el Lote.
					//lstLote[0].LTE_FechaVentanaCambio__c = datFechaPortabilidad;
					//update lstLote;
					//Llamar clase con la logica para el servicio(leg.Id, leg.Fecha1radevolucion__c);
					system.debug('leg.Id --> ' + leg.Id);
					if(!Test.isRunningTest())
					{
						lstResponse = LTE_SolicitudPortabilidad_cls.solicitudPortabilidad(leg.Id, datFechaPortabilidad);
						system.debug('lstResponse no Test --> ' + lstResponse);
					}
					else
					{
						LTE_SolicitudPortabilidad_cls.responseLotes objResp = new LTE_SolicitudPortabilidad_cls.responseLotes();
						objResp.strRespuesta = 'ack';
						objResp.objLog =  new LogTransacciones__c() ;
						Legalizacion__c  leg = new  Legalizacion__c();
						objResp.strIdLegalizacion =  leg.id ;
						lstResponse.add(objResp);
					}
					
					if(lstResponse != null)
					{
						for(LTE_SolicitudPortabilidad_cls.responseLotes strRespuesta : lstResponse)
						{
							if(strRespuesta.strRespuesta == 'ack')
							{
								actulizarLote(strRespuesta.strIdLegalizacion, datFechaPortabilidad, strRespuesta.objLog);
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Se realizo el envío a Portabilidad, por favor regrese.'));
								blnHabilitar = true;
							}
							else
							{
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Fallo el envío a la Portabilidad, el mensaje de error es: ' + strRespuesta.strRespuesta + ', por favor regrese y contacte al administrador del sistema.'));
								blnHabilitar = true;
							}
						}
					}
				}
				else
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No existe un Lote creado para esta Legallización, por favor regrese y valide los datos.'));
					blnHabilitar = true;
				}
			}
			else
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La fecha seleccionada no debe ser menor a 3 días ni mayor a 30 días habiles'));
				blnHabilitar = false;
				system.debug('esta en el else');
			}
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Debe seleccionar una fecha para poder continuar.'));
			blnHabilitar = false;
		}
		return null;
	}
	
	public pageReference regresar()
	{
		Pagereference pr = new Pagereference( '/' + leg.Id );
		pr.setRedirect(true);
		return pr;
	}
	
	public static Decimal diasTranscurridos(long milisegundos)
	{
		System.debug('milisegundos --> ' + milisegundos);
		Double segundos = milisegundos / 1000;
		System.debug('segundos --> ' + segundos);
		Double minutos = segundos / 60;
		System.debug('minutos --> ' + minutos);
		Decimal horas = minutos / 60;
		System.debug('horas --> ' + horas);
		Decimal dias = horas / 10;
		System.debug('dias --> ' + dias);
		return dias;
	}
	
	public static void actulizarLote(String strIdentificadorLote, Date datFePortabilidad, LogTransacciones__c objLog)
	{
		System.debug('strIdentificadorLote --> ' + strIdentificadorLote);
		list<LTE_Lote__c> lstLot = [select Id, LTE_FechaVentanaCambio__c, LTE_Observaciones__c from LTE_Lote__c where LTE_Legalizacion__c =: strIdentificadorLote];
		for(LTE_Lote__c objLote : lstLot)
		{
			objLote.LTE_FechaVentanaCambio__c = datFePortabilidad;	
		}
		update lstLot;
		
		upsert objLog;
		
		if(!Test.isRunningTest())
		{
			list<Legalizacion__c> lstLegalizacion = [select Estado__c from Legalizacion__c where Id =: strIdentificadorLote];
			lstLegalizacion[0].Estado__c = 'Pendiente por portabilidad';
			update lstLegalizacion;
		}
	}
}