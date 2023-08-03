/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que obtendra la lógica para enviar la fecha programada para la portabilidad(1006)

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-10      Walter Rodríguez (WR)		        Creación de la clase.
***********************************************************************************************************************/
public class LTE_EnvioFechaProgramada_cls 
{
	public static list<LTE_Lote__c> lstLote = new list<LTE_Lote__c>();
	
	public static void envioFechaProgramada(String strIdentificadorLegali)
	{
		system.debug('strIdentificadorLegali --> ' + strIdentificadorLegali);
        Id idRegistro = strIdentificadorLegali;
        String sql = 'SELECT Id,LTE_FechaVentanaCambio__c,LTE_Observaciones__c FROM '+idRegistro.getsobjecttype()+' WHERE Id = :idRegistro';
        List<SObject> lstRegistros = Database.query(sql);
        
		lstLote = [select Id, LTE_FechaVentanaCambio__c, LTE_Observaciones__c from LTE_Lote__c where Id =: strIdentificadorLegali];
		if(!lstRegistros.isEmpty())
		{
            if(lstRegistros[0].get('LTE_FechaVentanaCambio__c') != null){
                Date dtFechaVentanaCambio = Date.valueOf(lstRegistros[0].get('LTE_FechaVentanaCambio__c'));
                Datetime dtFechaPortabilidad = Datetime.newInstance(dtFechaVentanaCambio.Year(), dtFechaVentanaCambio.Month(), dtFechaVentanaCambio.Day(), 0, 0, 0);
                String strFormateado = dtFechaPortabilidad.format('yyyy-MM-dd\'T\'HH:mm:ss\'-05:00\'');
                system.debug('strFormateado --> ' + strFormateado);
                string strReq = LTE_GenXmlPortabilidadEntrante_cls.generarXmlFechaProgramacion(strFormateado, lstRegistros[0].Id, String.valueOf(lstRegistros[0].get('LTE_Observaciones__c')));
                
                enviaFechaportabilidad(strReq);
            }
		}
		//else
		//{
		//	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'La Legalización no tiene ningún lote asociado, o el Lote no tiene la fecha de programación diligenciada'));
		//}
	}
	
	@future(callout=true)
	public static void enviaFechaportabilidad(String strReq)
	{
		String strRespuesta;
		if(!Test.isRunningTest())
		{
			ServiciosWeb__c sw = ServiciosWeb__c.getValues('Portabilidad');
			//strRespuesta = LibreriaUtilitaria_cls.consultarServicio(strReq, '/Service/intfPortabilidadImp-service.serviceagent/intfwsPortabilidadImpEndpoint1/PortabilidadCorp','http://201.245.171.239:7050/Service/Portabilidad-service.serviceagent/PortabilidadEndpoint');
			strRespuesta = LibreriaUtilitaria_cls.consultarServicio(strReq, sw.Action__c, sw.EndPoint__c);
		}
		else
			strRespuesta = 'ack Test';
		system.debug('strRespuesta --> ' + strRespuesta);
	}
}