/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Raul Mora
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que consulta el lote y el detalle de lote relaciondos al identificador consultado por el servicio
					y crea la operacion comercial relacionada al detalle de lote.

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-05      Raul Mora (RM)		        Creación de la clase.
2.0     2015-09-11      Walter Rodríguez M (WRM)	Ajuste.
***********************************************************************************************************************/
public class LTE_FechaVentanaSalienteConfirmada_cls 
{
	public static list<LTE_Lote__c> lstLote = new list<LTE_Lote__c>();
	/*
	* @Metodo: 		procesarFechaVentanaConfirmada
	* @Parametros:	String, Date
	* @Descripcion:	Metodo encargado de procesar la fecha de ventana confirmada.
	*/
	public static void procesarFechaVentanaConfirmada( String strIdentificadorLote, String strFechaConfirmada )
	{
		system.debug('strIdentificadorLote --> ' + strIdentificadorLote);
		system.debug('strFechaConfirmada --> ' + strFechaConfirmada);
		if( String.isNotEmpty( strIdentificadorLote ) )
		{
			lstLote = [ Select Id, LTE_FechaVentanaCambio__c,
											( Select Id, 
												LTE_NumeroLinea__c, 
												LTE_AdjuntoRechazo1__c, 
												LTE_AdjuntoRechazo2__c,
												LTE_AdjuntoRechazo3__c,
												LTE_AdjuntoRechazo4__c,
												LTE_CodigosRechazo__c,
												LTE_ActivoETB__c, // WRM
												LTE_ActivoETB__r.NombredelaCuenta__c, // WRM
												LTE_ActivoETB__r.CuentaFacturacion__c, // WRM
												LTE_ActivoETB__r.Plan__c // WRM
												From Detalle_de_Lote__r )
										From LTE_Lote__c Where LTE_Identificador__c =: strIdentificadorLote Limit 1 ];
			system.debug('lstLote --> ' + lstLote);
			//Se verifica que la consulta devuelva información
			if( !lstLote.isEmpty() )
			{
				//Se procede a crear la Operacion Comercial por linea 
				List<OperacionComercial__c> lstOpCom = new List<OperacionComercial__c>();
				List<TOPP__c> objToop = new List<TOPP__c>();
				List<RecordType> objRecTyp = new List<RecordType>();
				//Se verifica que el lote encontrado tenga detalles de lote
				if( !lstLote.get(0).Detalle_de_Lote__r.isEmpty() )
				{
					//Se obtiene el catalogo de producto TELEFONIA MOVIL (LTE)
					List<CatalogoProductos__c> objCataProd = [ Select Id 
														 From CatalogoProductos__c 
														 Where Name =: System.Label.LTE Limit 1 ];
					if( !objCataProd.isEmpty() )
					{
						//Se consulta el objeto Tipo de operación por plan para obtener el tipo de registro que se asignara a la operacion comercial.
						objToop = [ Select Id, Tipoderegistro__c 
									From TOPP__c 
									Where TipodeOperacionporplan__c =: System.Label.LTE_Retiro 
									And LTE_Catalogo_de_Producto__c =: objCataProd.get(0).Id Limit 1 ];
					}
					//Se verifica que exista un registro de toop
					if( !objToop.isEmpty() )
					{
						//Se consulta el tipo de registro
						objRecTyp = [ Select Id 
									  From RecordType 
									  Where DeveloperName =: objToop.get(0).Tipoderegistro__c
									  And SobjectType = 'OperacionComercial__c' ];
					}
					
					OperacionComercial__c objOpCom;
					for( LTE_DetalleLote__c objDetLot : lstLote.get(0).Detalle_de_Lote__r )
					{
						objOpCom = new OperacionComercial__c();
						objOpCom.Portacion__c = true;
						objOpCom.LTE_CausalCancelacion__c = System.Label.LTE_PortabilidadSaliente;
						objOpCom.NumeroConexion__c = objDetLot.LTE_NumeroLinea__c;
						if( !objRecTyp.isEmpty() )
						{
							objOpCom.RecordTypeId = objRecTyp.get(0).Id;
							objOpCom.TOPP__c = objToop[0].Id;//WRM
						}
						objOpCom.FechaRetiro__c = LTE_FechaMaxVentanaCambio_cls.correccion( strFechaConfirmada ); // '05/08/2015' mes dia año
						objOpCom.CuentaCliente__c = objDetLot.LTE_ActivoETB__r.NombredelaCuenta__c; //WRM
						objOpCom.Activo__c = objDetLot.LTE_ActivoETB__c;//WRM
						objOpCom.Plan__c = objDetLot.LTE_ActivoETB__r.Plan__c; //WRM
						objOpCom.CuentaFacturacion__c = objDetLot.LTE_ActivoETB__r.CuentaFacturacion__c; //WRM
						objOpCom.Estado__c = 'Pendiente';//WRM
						lstOpCom.add( objOpCom );
					}
					if( !lstOpCom.isEmpty() )
					{
						insert lstOpCom;
						system.debug('lstOpCom --> ' + lstOpCom);
						actualizaLote(strFechaConfirmada); //WRM
					}
				}
				
			}
		}
	}
	
	/*
	* @Metodo: 				actualizaLote
	* @Descripcion:			Metodo encargado de actualizar el lote con la fecha en la que se va a realizar la portabilidad saliente.
	* @Autor:				Walter Rodríguez (WR)
	* @Fecha de creación:	11/09/2015
	*/
	public static void actualizaLote(String strFechaConfirmadaLote)
	{
		lstLote[0].LTE_FechaVentanaCambio__c = LTE_FechaMaxVentanaCambio_cls.correccion( strFechaConfirmadaLote );
		update lstLote;
	}
}