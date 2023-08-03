/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que obtendra la lógica para recibir la fecha confirmada por El Corte Ingles para la portabilidad(1007)

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-10      Walter Rodríguez (WR)		        Creación de la clase.
***********************************************************************************************************************/
public class LTE_ConfirmacionFechaPortabilidad_cls
{
	public static String strIdentificadorLegali;
	public static String strFechaConfimada;
	public static Date datFechaConfirmada;
	public static list<LTE_Lote__c> lstLote = new list<LTE_Lote__c>();
	public static list<Legalizacion__c> lstLegalizacion = new list<Legalizacion__c>();
	public static list<OperacionComercial__c> lstOC = new list<OperacionComercial__c>();
	
	public static LTE_PortabilidadEntrante_ws.LTE_Response fechaConfirmada( LTE_PortabilidadEntrante_ws.PortabilidadMsg objReq )
	{
		LTE_PortabilidadEntrante_ws.LTE_Response objResp;
		system.debug('objReq.CabeceraMensaje.Identificador --> ' + objReq.CabeceraMensaje.Identificador);
		strIdentificadorLegali = objReq.CabeceraMensaje.Identificador;
		strFechaConfimada = objReq.CuerpoMensaje.FechaVentanaConfirmada;
		//datFechaConfirmada = Date.parse(strFechaConfimada);
		datFechaConfirmada = LTE_FechaMaxVentanaCambio_cls.correccion(strFechaConfimada);
		lstLote = [select Id, LTE_FechaVentanaConfirmada__c, LTE_Identificador__c from LTE_Lote__c where Id =: strIdentificadorLegali];
        if(!lstLote.isEmpty()){
            lstLegalizacion = [select Id, LTE_FechaPortabilidad__c from Legalizacion__c where id =: lstLote[0].LTE_Identificador__c];
            lstOC = [select FechadeActivacion__c, Id from OperacionComercial__c where Legalizacion__c =: lstLegalizacion[0].Id and Portacion__c = true];
            if(!lstLote.isEmpty())
            {
                lstLote[0].LTE_FechaVentanaConfirmada__c = datFechaConfirmada;
                update lstLote;
                if(!lstLegalizacion.isEmpty())
                {
                    lstLegalizacion[0].LTE_FechaPortabilidad__c = datFechaConfirmada;
                    update lstLegalizacion;
                    if(!lstOC.isEmpty())
                    {
                        list<OperacionComercial__c> lstOCActualizadas = new list<OperacionComercial__c>();
                        for(OperacionComercial__c oc : lstOC)
                        {
                            oc.FechadeActivacion__c = datFechaConfirmada;
                            lstOCActualizadas.add(oc);
                        }
                        update lstOCActualizadas;
                        return new LTE_PortabilidadEntrante_ws.LTE_Response('OK, Fue actualizado el Lote, la Legalización y las OC fueron actualizados');
                    }
                }
            }
            else
                return new LTE_PortabilidadEntrante_ws.LTE_Response('Fail, No existe el Lote');
            
        }else{
            list < Lineas_OC__c > lstLineaOC = new list < Lineas_OC__c > ();
            lstLineaOC = [SELECT Id FROM Lineas_OC__c WHERE Id = :strIdentificadorLegali];
            
            for(Lineas_OC__c loc : lstLineaOC)
            {
                loc.LTE_FechaPortabilidad__c = datFechaConfirmada;
            }
            if(!lstLineaOC.isEmpty()){
                update lstLineaOC;
                return new LTE_PortabilidadEntrante_ws.LTE_Response('OK, Se ha actualizado el registro.');
            }
            return new LTE_PortabilidadEntrante_ws.LTE_Response('Fail, No se ha encontrado el registro');
        }
		return null;
	}
}