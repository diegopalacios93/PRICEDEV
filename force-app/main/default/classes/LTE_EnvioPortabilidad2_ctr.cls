public with sharing class LTE_EnvioPortabilidad2_ctr {
	
	private final Apexpages.Standardcontroller ctr;
	public Decimal dcDiasTranscurridos; 
	public Date datFechaPortabilidad {get;set;}
	public string strId {get;set;}
	public Legalizacion__c leg {get; set;}
	public Boolean blnHabilitar {get; set;}
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
	
	public LTE_EnvioPortabilidad2_ctr(Apexpages.Standardcontroller controller)
	{
		//ctr = controller;
		leg = new Legalizacion__c();
		dcDiasTranscurridos = 0.0; 
		//this.strId = controller.getId();
		leg = (Legalizacion__c)controller.getRecord();
		strRespuesta = '';
		blnHabilitar = false;
	}
	
	public pageReference enviarPortabilidad()
	{
		list<LTE_SolicitudPortabilidad_cls.responseLotes> lstResponse = new list<LTE_SolicitudPortabilidad_cls.responseLotes>();
		system.debug('esta aca');
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

	}
}