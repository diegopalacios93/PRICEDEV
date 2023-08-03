/***********************************************************************************************************************
Desarrollado por:   Avanxo Colombia
Autor:              Walter Rodríguez 
Proyecto:           ETB LTE CORPORATIVO FASE I
Descripción:        Clase que permitira crear una legalización desde la operación comercial, por medio de un botón. 

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2015-08-14      Walter Rodríguez (WR)		Creación de la clase.
***********************************************************************************************************************/
public class LTE_Legalizacion_ctr 
{
	public Legalizacion__c objLegalizacion {get; set;}
	public String strId {get; set;}
	public String strTipoPago {get; set;}
	public String strValorCuentaXCobrar {get; set;}
	public Boolean blnOcultaBoton {get; set;}
	public ApexPages.Standardcontroller controller {get;set;}
	public list<OperacionComercial__c> lstOC = new list<OperacionComercial__c>();
	
	public LTE_Legalizacion_ctr() 
	{
		blnOcultaBoton = true;
		objLegalizacion = new Legalizacion__c();
		strId = ApexPages.currentPage().getParameters().get('strId');
		system.debug('strId --> ' + strId);
		lstOC = [select   CuentaCliente__c, TOPP__c, TOPP__r.TipodeOperacionporplan__c, LTE_TipoTransaccion__c,Legalizacion__c, LTE_TipoPago__c from OperacionComercial__c where id =: strId];
		system.debug('lstOC --> ' + lstOC);
	}
	
	public PageReference guardar()
	{
		system.debug('objLegalizacion --> ' + objLegalizacion);
		Schema.DescribeSObjectResult R = Legalizacion__c.SObjectType.getDescribe();
		List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
		for(Schema.RecordTypeInfo objRT : RT)
		{
			if(objRT.getName().equals('Legalización Reno Repo'))
				objLegalizacion.RecordTypeId = objRT.getRecordTypeId();
		}
		
		Boolean blnValidado = validarDatosObligatorios(objLegalizacion);
		if(blnValidado)
		{
			try
			{
				objLegalizacion.Estado__c = 'Gestionado'; // al grabar el detalle de ventas, la legalizacion debe pasar a estado Gestionado
				upsert objLegalizacion;
				system.debug('objLegalizacion insertada --> ' + objLegalizacion);
				lstOC[0].Legalizacion__c = objLegalizacion.id;
				lstOC[0].Estado__c = 'Equipo Facturado';
				lstOC[0].fechadeActivacion__c = Date.today();
				update lstOC;
				
				system.debug('lstOC[0].TOPP__r.TipodeOperacionporplan__c--> ' + lstOC[0].TOPP__r.TipodeOperacionporplan__c);
				// Generar Servicios Adicionales y XAs cuando la operacion comercial es Repo o Reno, tiene equipo y este es financiado
				if( (lstOC[0].TOPP__r.TipodeOperacionporplan__c == 'Renovación' || lstOC[0].TOPP__r.TipodeOperacionporplan__c == 'Reposición') 
				&& lstOC[0].LTE_TipoTransaccion__c.Contains( System.Label.LTE_Equipo ) )
				{
					map<Id,OperacionComercial__c> ocRepoReno=new map<Id,OperacionComercial__c>([select id,Name,Plan__c,Legalizacion__c,Activo__c from OperacionComercial__c where Id=:lstOC[0].id]);
					LTE_GeneraServAdicVentaEquipos.obtenerEstructuradoPosventa(lstOC[0]);
				}
				
				Apexpages.addMessage(new ApexPages.Message( ApexPages.Severity.Confirm,'Se creo la Legalización y se actualizo la Operación comercial'));
				blnOcultaBoton = false;
			}
			catch( System.DmlException e )
			{
				ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, e.getmessage() ) );
				return null;
			}
		}
		else
		{
			ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Faltan campos obligatorios para poder guardar.' ) );
			return null;
		}
		
		return null;
	}
	
	public Boolean validarDatosObligatorios(Legalizacion__c objLegalizacion)
	{
		if(objLegalizacion.LTE_NumeroCuentaConsignacion__c != null && objLegalizacion.LTE_FechaPago__c != null && objLegalizacion.LTE_NumeroAprobacionPago__c != '' && objLegalizacion.Cuotas__c != null)
			return true;
		else
			return false;
	}
	
	public PageReference poblarCampos()
	{
		if(!strId.equals(''))
		{
			List<OperacionComercial__c> lstOC = [select Legalizacion__c, LTE_TipoPago__c, CuentaCliente__c, TOPP__c, TOPP__r.TipodeOperacionporplan__c, LTE_TipoTransaccion__c
												 from OperacionComercial__c where id =: strId];
			system.debug('lstOC --> ' + lstOC);
			if(!lstOC.isEmpty())
			{
				strTipoPago = lstOC[0].LTE_TipoPago__c;
				system.debug('strTipoPago --> ' + strTipoPago);
				List<Legalizacion__c> lstLegal = [SELECT Name,LTE_ValorCuentaxCobrar__c,LTE_TipoPago__c,LTE_FechaPago__c,
									LTE_NumeroAprobacionPago__c, LTE_NumeroCuentaConsignacion__c, Cuotas__c 
									FROM Legalizacion__c WHERE Id =: lstOC[0].Legalizacion__c];
				
				if(!lstLegal.isEmpty())
				{
					objLegalizacion = lstLegal.get(0);
					strValorCuentaXCobrar = string.valueOf(lstLegal[0].LTE_ValorCuentaxCobrar__c);
				}
			}
			
			/*objLegalizacion.LTE_TipoPago__c = lstOC[0].LTE_TipoPago__c;
			objLegalizacion.LTE_FacturaEnviada__c = 'No enviado';
			objLegalizacion.Portacion__c = 'No';
			objLegalizacion.Nombredelacuenta2__c = lstOC[0].CuentaCliente__c;
			
			if(objLegalizacion.LTE_TipoPago__c=='Inmediato'){  //  Si el tipo de pago es Inmediato, poner la legalizacion en estado Validación de pago
				objLegalizacion.Estado__c = 'Validación de pago';
			}else{												//  Si el tipo de pago es NO Inmediato, poner la legalizacion en estado No Gestionado
				objLegalizacion.Estado__c = 'No Gestionado';
			}
			
			//Se genera el num de factura para la legalización.
			LTE_RangoFactura__c Rango = LTE_RangoFactura__c.getValues('FactEquiposLTE');
			system.debug('Rango-->'+Rango);
			LTE_ConsecutivoFacturaEquipos__c conFac = new LTE_ConsecutivoFacturaEquipos__c();
			insert conFac;
			LTE_ConsecutivoFacturaEquipos__c  objConfac =[SELECT Consecutivo_Factura_Equipo__c FROM LTE_ConsecutivoFacturaEquipos__c where id=:conFac.Id];
			system.debug('objConfac-->'+objConfac);	
			objLegalizacion.LTE_NFacturaVenta__c = String.ValueOF(integer.ValueOF(Rango.Inicio_Rango__c)+integer.ValueOF(objConfac.Consecutivo_Factura_Equipo__c));
			system.debug('objLegalizacion.LTE_NFacturaVenta__c-->'+objLegalizacion.LTE_NFacturaVenta__c);
			
			upsert objLegalizacion;
			system.debug('objLegalizacion insertada en el load --> ' + objLegalizacion);
			
			lstOC[0].Legalizacion__c = objLegalizacion.id;
			update lstOC;
			
			LTE_EnviarInfoFactEquipos_cls enviarFactEquipos = new LTE_EnviarInfoFactEquipos_cls();
			if( (lstOC[0].TOPP__r.TipodeOperacionporplan__c == 'Renovación' || lstOC[0].TOPP__r.TipodeOperacionporplan__c == 'Reposición') && lstOC[0].LTE_TipoTransaccion__c.Contains( System.Label.LTE_Equipo ))
				enviarFactEquipos.enviarInfoFactEquiposPosVenta( objLegalizacion, lstOC[0] );
				*/
		}
		return null;
	}
}