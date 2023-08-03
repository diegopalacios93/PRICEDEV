/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que obtendra la lógica para recibir la fecha de la ventana enviada por El Corte Ingles(1005)

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-05      Walter Rodríguez (WR)		        Creación de la clase.
***********************************************************************************************************************/
public class LTE_FechaMaxVentanaCambio_cls 
{
	public static String strIdentificadorLegali;
	public static String strFechaMaxCambio;
	public static Date datFechaMaxCambio;
	public static list<LTE_Lote__c> lstLote = new list<LTE_Lote__c>();
	
	public static LTE_PortabilidadEntrante_ws.LTE_Response fechaMaxVentanaCambio( LTE_PortabilidadEntrante_ws.PortabilidadMsg objReq )
	{
        try{
            system.debug('Entro');
            LTE_PortabilidadEntrante_ws.LTE_Response objResp;
            system.debug('objReq.CabeceraMensaje.Identificador --> ' + objReq.CabeceraMensaje.Identificador);
            strIdentificadorLegali = objReq.CabeceraMensaje.Identificador;
            strFechaMaxCambio = objReq.CuerpoMensaje.FechaMaxVentanaCambio;
            system.debug(strFechaMaxCambio);
            datFechaMaxCambio = correccion(strFechaMaxCambio);
            
            Id idRegistro = strIdentificadorLegali;
            String sql = 'SELECT Id,LTE_FechaMaxVentanaCambio__c FROM '+idRegistro.getsobjecttype()+' WHERE Id = :idRegistro';
            List<SObject> lstRegistros = Database.query(sql);
            
            if(!lstRegistros.isEmpty())
            {
                lstRegistros[0].put('LTE_FechaMaxVentanaCambio__c',datFechaMaxCambio);
                update lstRegistros;
                system.debug('Entro y va a llamar la otra');
                LTE_EnvioFechaProgramada_cls.envioFechaProgramada(strIdentificadorLegali);
                return new LTE_PortabilidadEntrante_ws.LTE_Response('OK, Fue actualizado el registro y se envío la fecha programada');
            }
            else
                return new LTE_PortabilidadEntrante_ws.LTE_Response('Fail, No existe el registro');
        }catch(exception e){
            return new LTE_PortabilidadEntrante_ws.LTE_Response(e.getMessage() + ' - ' + e.getStackTraceString());
        }
	}
	
	public static date correccion(string csvRecordData){		
		
		list<string> RFQdate = csvRecordData.trim().split('/');
		date mydate = date.valueOf(RFQdate[2] + '-' + RFQdate[0] + '-' + RFQdate[1]);
	
		return mydate;
	}
	
	
}