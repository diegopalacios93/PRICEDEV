/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Luis Penaranda
Proyecto:				ETB - Integracion Formateador
DescripciOn:			Clase de prueba Envio de informacion para Generacion de Factura-Formateador
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0		10-08-2015	Luis Penaranda (LP)		Creacion de la clase
*******************************************************************************/
public  class LTE_EnviarInfoFactEquipos_cls 
{
	public String mensaeFactura = 'Señor usuario el cargo correspondiente a los equipos se facturará en la próxima factura';
	//public Decimal totalFacturaEquipos=0;
	//public Decimal totalDesceuntoFacturaEquipos=0;
	public static map<String, String> mapRespuestaFact = new map<String, String>();
	public class DatosFormateador{
		public String correlationId;
		public String clientName;
		public String clientNumber;
		public String invoiceNumber;
		public String invoiceDate;
		public String PIN1;
		public String PIN2;
		public Decimal amount;
		public Decimal IVA;
		public Decimal totalAmount;
		public String Item_description;
		public String Item_IMEI;
		public String Item_deviceCost;
		public String Item_IVA;
		public String Item_totalIVA;
		
	}
	
	public LTE_EnviarInfoFactEquipos_cls()
	{
	}

	// Generacion de Factura Formateador para Posventa  Pago Primera Factura
	public boolean enviarInfoFactEquiposPosVentaPrimeraFactura(list<LTE_DetalleOferta__c> listDetalleOfertaNew ,map<Id,LTE_DetalleOferta__c> listDetalleOfertaOld ) {


		set <String> setIdOpeCom = new set <String>();
		set <String> setIdOderta = new set <String>();
		set <String> setIdOpeComWork = new set <String>();
		set <String> setIdLegalizacionesWork = new set <String>();
		map<string,string> mapLegOpCom = new map<string,string>();
		LTE_DetalleOferta__c objOfertaOld;

		system.debug('listDetalleOfertaNew-->'+listDetalleOfertaNew);
		system.debug('listDetalleOfertaOld-->'+listDetalleOfertaOld);
		for(LTE_DetalleOferta__c objOferta : listDetalleOfertaNew)			
		{			
		  objOfertaOld = listDetalleOfertaOld.get(objOferta.id);
		  if(objOferta.LTE_IMEI__c != null && objOferta.LTE_IMEI__c != objOfertaOld.LTE_IMEI__c)	
		  	{		  
				setIdOpeComWork.add(objOferta.LTE_OperacionComercial__c);
			}
		}
		
		system.debug('setIdOpeComWork-->'+setIdOpeComWork);
		map<Id,OperacionComercial__c> mapOCWork = new map<Id,OperacionComercial__c>([Select id,Activo__c,LTE_TipoTransaccion__c,Legalizacion__c,
														Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c,LTE_ICCID__c 	
														From OperacionComercial__c 
														Where id=:setIdOpeComWork
														and Plan__r.NombredelProducto__r.Familia__c='LTE'
														and (TOPP__r.TipodeOperacionporplan__c	=	'Renovación' 
															  or TOPP__r.TipodeOperacionporplan__c	=	'Reposición')]);
		
		system.debug('mapOCWork-->'+mapOCWork);
		for(OperacionComercial__c objOpeCom : mapOCWork.values())
		{
			setIdLegalizacionesWork.add(objOpeCom.Legalizacion__c);
			mapLegOpCom.put(objOpeCom.Legalizacion__c,objOpeCom.id);
		}
		system.debug('setIdLegalizacionesWork-->'+setIdLegalizacionesWork);
		system.debug('mapLegOpCom-->'+mapLegOpCom);	
		map<Id,Legalizacion__c> mapLegalizacionWork = new map<Id,Legalizacion__c>([Select LTE_TipoPago__c,LTE_NFacturaVenta__c,Nombredelacuenta2__c,Estado__c,Portacion__c,LTE_FechaPortabilidad__c,LTE_FacturaEnviada__c	
														From Legalizacion__c 
														Where id=:setIdLegalizacionesWork]);
		
		system.debug('mapLegalizacionWork-->'+mapLegalizacionWork);													  													  
		for(Legalizacion__c objLeg : mapLegalizacionWork.values())
		{
			system.debug('objLeg-->'+objLeg);	
			String concatDescription=null;
			String concatIMEI=null;
			String concatICCID =null;
			String concatDeviceCost=null;
			String concatIva=null;
			String concatTotalIva=null;
			String cadenaDetalle = '';
			String opComid = '';
			boolean hayEquipoComprado=false;
			
			
			Decimal totalSinIva=0;
			Decimal totalIva=0;
			Decimal totalFactura=0;
            Decimal totalDesceuntoFacturaEquipos=0;
		
			Boolean senalProceso=false; // Define si el crietrio para ejecución del proceso es verdadero
			if((objLeg.LTE_TipoPago__c=='Inmediato' && objLeg.Estado__c == 'Validación de pago') || (objLeg.LTE_TipoPago__c!='Inmediato' && objLeg.Estado__c == 'No Gestionado') )
			{
				if(objLeg.LTE_FacturaEnviada__c=='No enviado' ||objLeg.LTE_FacturaEnviada__c=='Reenviar') // estados validos para enviar la factura al formateador.
				{
					if(objLeg.LTE_TipoPago__c!='No requiere pago'){
						senalProceso=true;  // Cambió uno de los campos que disparan el proceso
					}
				}
				
			}
		
			system.debug('objLeg.Estado__c-->'+objLeg.Estado__c);
			system.debug('senalProceso-->'+senalProceso);
			system.debug('objLeg.Portacion__c-->'+objLeg.Portacion__c);
			system.debug('objLeg.LTE_TipoPago__c-->'+objLeg.LTE_TipoPago__c);
			system.debug('objLeg.LTE_FechaPortabilidad__c-->'+objLeg.LTE_FechaPortabilidad__c);
			system.debug('objLeg.LTE_FacturaEnviada__c-->'+objLeg.LTE_FacturaEnviada__c);
			system.debug('objLeg.LTE_FacturaEnviada__c-->'+objLeg.LTE_FacturaEnviada__c);
		
			boolean senalCondiciones = false;
			if(	(objLeg.Portacion__c== 'Si' &&	objLeg.LTE_TipoPago__c!=null && objLeg.LTE_FechaPortabilidad__c != null) || (objLeg.Portacion__c=='No' &&	objLeg.LTE_TipoPago__c!=null)){
				senalCondiciones=true;
			}
			system.debug('senalProceso-->'+senalProceso);
			system.debug('senalCondiciones-->'+senalCondiciones);

			if(senalProceso && senalCondiciones)	 // Si Cambió uno de los campos que disparan el proceso
			{
				system.debug('entre a generar fac-->');
				LTE_DetalleOferta__c objLTE_DetalleOferta;		
				DatosFormateador objDatosFormateador = new DatosFormateador();
				Account objAccount = getCuenta(objLeg.Nombredelacuenta2__c);
				objDatosFormateador.clientName		= objAccount.Name;
				objDatosFormateador.clientNumber	= objAccount.Tipodedocumento__c + objAccount.AccountNumber;
				objDatosFormateador.invoiceNumber	= objLeg.LTE_NFacturaVenta__c; 
				objDatosFormateador.PIN1			= objLeg.LTE_NFacturaVenta__c; 
				objDatosFormateador.PIN2			= '00000000';
				
				Datetime datToday = system.now();
	   			objDatosFormateador.correlationId = objAccount.AccountNumber +'-'+ String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year()) 
	   			+ String.valueOf(datToday.hour()) + String.valueOf(datToday.minute()) + String.valueOf(datToday.second());
	   	
				//Calcular fecha final de facturacion
				DateTime fechaVtoFactura 			= obtenerFechaVtoFactura(3);						
				objDatosFormateador.invoiceDate		=  fechaVtoFactura.format('yyyy-MM-dd');
				
				opComid = mapLegOpCom.get(objLeg.id);
				list<OperacionComercial__c> listOpeComerciales;
				listOpeComerciales =  getOperacionesComercialesPosVenta(opComid);
				for(OperacionComercial__c objOpeCom:listOpeComerciales)
				{
					setIdOpeCom.add(objOpeCom.Id);		
				}		
				map<String,LTE_DetalleOferta__c> mapDetalleEquipo = getMapDetalleEquipo(setIdOpeCom);
	
				for(OperacionComercial__c objOpeCom:listOpeComerciales)
				{
					objLTE_DetalleOferta = mapDetalleEquipo.get(objOpeCom.Id);
					system.debug('objLTE_DetalleOferta.LTE_EquipoTraido__c-->'+objLTE_DetalleOferta.LTE_EquipoTraido__c);
					if(objLTE_DetalleOferta.LTE_EquipoTraido__c!=null && objLTE_DetalleOferta.LTE_EquipoTraido__c==false){	
						hayEquipoComprado=true;
						concatDescription	=	objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.Name;
						concatIMEI			=	String.valueOf(objOpeCom.IMEI_del_Equipo__c);
						concatICCID			=   String.valueOf(objOpeCom.LTE_ICCID__c);
                        //concatDeviceCost    =   String.valueOf(objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.Valor_del_Equipo__c);
						concatDeviceCost	=	String.valueOf(objLTE_DetalleOferta.LTE_ValorAntesImpuestosparaEquipo__c);
                        //concatIva           =   String.valueOf(objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_IVA__c);
						concatIva			=	String.valueOf(objLTE_DetalleOferta.LTE_IVA__c);
                        //concatTotalIva      =   String.valueOf(objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_PrecioConIVA__c);
						concatTotalIva		=	String.valueOf(objLTE_DetalleOferta.LTE_ValorDespuesImpuestoIVA__c);
						
						if(concatIMEI==null) concatIMEI='';
						if(concatICCID==null) concatICCID='';

						if( concatICCID!=''){	
							cadenaDetalle +='<inp:item>';
								cadenaDetalle +='<inp:description>NUMERO SIM CARD</inp:description>';
								cadenaDetalle +='<inp:IMEI>'+concatICCID+'</inp:IMEI>';
								cadenaDetalle +='<inp:deviceCost>0</inp:deviceCost>';
								cadenaDetalle +='<inp:IVA>0</inp:IVA>';
								cadenaDetalle +='<inp:totalIVA>0</inp:totalIVA>'; 
							cadenaDetalle +='</inp:item>';
						}
												
						cadenaDetalle +='<inp:item>';
							cadenaDetalle +='<inp:description>'+concatDescription+'</inp:description>';
							cadenaDetalle +='<inp:IMEI>'+concatIMEI+'</inp:IMEI>';
							cadenaDetalle +='<inp:deviceCost>'+concatDeviceCost+'</inp:deviceCost>';
							cadenaDetalle +='<inp:IVA>'+concatIva+'</inp:IVA>';
							cadenaDetalle +='<inp:totalIVA>'+concatTotalIva+'</inp:totalIVA>'; 
						cadenaDetalle +='</inp:item>';
													
						// acumular totales
                        //totalSinIva     +=  objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.Valor_del_Equipo__c;
						totalSinIva		+=	objLTE_DetalleOferta.LTE_ValorAntesImpuestosparaEquipo__c;
                        //totalIva        +=  objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_IVA__c;
						totalIva		+=	objLTE_DetalleOferta.LTE_IVA__c;
                        //totalFactura    +=  objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_PrecioConIVA__c;
						totalFactura	+=	objLTE_DetalleOferta.LTE_ValorDespuesImpuestoIVA__c;

                        System.debug('\n\n-=#=-\n' + 'objLTE_DetalleOferta.LTE_DescuentoEquipos__c' + ': ' + objLTE_DetalleOferta.LTE_DescuentoEquipos__c + '\n-=#=-\n');
						if(objLTE_DetalleOferta.LTE_DescuentoEquipos__c != null && objLTE_DetalleOferta.LTE_DescuentoEquipos__c != 0)
						{
                            //totalDesceuntoFacturaEquipos += (totalFactura * (objLTE_DetalleOferta.LTE_DescuentoEquipos__c / 100));
							totalDesceuntoFacturaEquipos += (objLTE_DetalleOferta.LTE_ValorAntesImpuestosparaEquipo__c * (objLTE_DetalleOferta.LTE_DescuentoEquipos__c / 100));
						}
					}
				}
	
				objDatosFormateador.amount				= totalSinIva 	- Decimal.valueOf(calcularAjusteDecena(totalSinIva)); 	//Se hace ajsute  a la decena
				objDatosFormateador.IVA					= totalIva		- Decimal.valueOf(calcularAjusteDecena(totalIva)); 		//Se hace ajsute  a la decena
				objDatosFormateador.totalAmount			= totalFactura	- Decimal.valueOf(calcularAjusteDecena(totalFactura)); 	//Se hace ajsute  a la decena
				totalDesceuntoFacturaEquipos            = totalDesceuntoFacturaEquipos   - Decimal.valueOf(calcularAjusteDecena(totalDesceuntoFacturaEquipos));     //Se hace ajsute  a la decena
                objDatosFormateador.totalAmount         -= totalDesceuntoFacturaEquipos;

				objDatosFormateador.Item_description	= concatDescription;
				objDatosFormateador.Item_IMEI			= concatIMEI;
				objDatosFormateador.Item_deviceCost		= concatDeviceCost;
				objDatosFormateador.Item_IVA			= concatIva;
				objDatosFormateador.Item_totalIVA		= concatTotalIva;
				
                System.debug('\n\n-=#=-\n' + 'totalDesceuntoFacturaEquipos' + ': ' + totalDesceuntoFacturaEquipos + '\n-=#=-\n');
				if(totalDesceuntoFacturaEquipos!=0 ){ // si hay descuento manda la linea de descuento al facturador 
					cadenaDetalle +='<inp:item>';
						cadenaDetalle +='<inp:description>Descuento</inp:description>';
						cadenaDetalle +='<inp:IMEI></inp:IMEI>';
						cadenaDetalle +='<inp:deviceCost>'+totalDesceuntoFacturaEquipos+'</inp:deviceCost>';
						cadenaDetalle +='<inp:IVA></inp:IVA>';
						cadenaDetalle +='<inp:totalIVA></inp:totalIVA>';
					cadenaDetalle +='</inp:item>';
				}
				if(hayEquipoComprado==true){
					String xmlFormateador = LTE_genXmlFormateador_cls.generaXMLFormateador(objDatosFormateador,cadenaDetalle);
                    System.debug('\n\n-=#=-\n' + 'xmlFormateador' + ': ' + xmlFormateador + '\n-=#=-\n');
					invocarServicioFormateador(xmlFormateador,objLeg.Id,totalFactura);
				}
			}
		}
		//?? Actualizar la operacion comercial de equipos con estos totales
		//?? enviar un correo al gestionador de la legalizacion en caso de fallo
		return null;
	}
		

	// Generacion de Factura Formateador para Posventa Pago Inmediato
	/*public boolean enviarInfoFactEquiposPosVentaInmediato(Legalizacion__c listLegNew,OperacionComercial__c opCom ) {


		set <String> setIdOpeCom = new set <String>();
		
		String concatDescription=null;
		String concatIMEI=null;
		String concatDeviceCost=null;
		String concatIva=null;
		String concatTotalIva=null;
		String cadenaDetalle = '';
		
		Decimal totalSinIva=0;
		Decimal totalIva=0;
		Decimal totalFactura=0;
		
		
		 
		Legalizacion__c objLeg 		= 	listLegNew;

		Boolean senalProceso=false; // Define si el crietrio para ejecución del proceso es verdadero
		if((objLeg.LTE_TipoPago__c=='Inmediato' && objLeg.Estado__c == 'Validación de pago') || (objLeg.LTE_TipoPago__c!='Inmediato' && objLeg.Estado__c == 'No Gestionado') )
		{
			if(objLeg.LTE_FacturaEnviada__c=='No enviado' ||objLeg.LTE_FacturaEnviada__c=='Reenviar') // estados validos para enviar la factura al formateador.
			{
				if(objLeg.LTE_TipoPago__c!='No requiere pago'){
					senalProceso=true;  // Cambió uno de los campos que disparan el proceso
				}
			}
			
		}
		
		system.debug('objLeg.Estado__c-->'+objLeg.Estado__c);
		system.debug('senalProceso-->'+senalProceso);
		system.debug('objLeg.Portacion__c-->'+objLeg.Portacion__c);
		system.debug('objLeg.LTE_TipoPago__c-->'+objLeg.LTE_TipoPago__c);
		system.debug('objLeg.LTE_FechaPortabilidad__c-->'+objLeg.LTE_FechaPortabilidad__c);
		system.debug('objLeg.LTE_FacturaEnviada__c-->'+objLeg.LTE_FacturaEnviada__c);
		system.debug('objLeg.LTE_FacturaEnviada__c-->'+objLeg.LTE_FacturaEnviada__c);
		
		boolean senalCondiciones = false;
		if(	(objLeg.Portacion__c== 'Si' &&	objLeg.LTE_TipoPago__c!=null && objLeg.LTE_FechaPortabilidad__c != null) || (objLeg.Portacion__c=='No' &&	objLeg.LTE_TipoPago__c!=null)){
			senalCondiciones=true;
		}
		system.debug('senalProceso-->'+senalProceso);
		system.debug('senalCondiciones-->'+senalCondiciones);

		if(senalProceso && senalCondiciones)	 // Si Cambió uno de los campos que disparan el proceso
		{
			system.debug('entre a generar fac-->');
			LTE_DetalleOferta__c objLTE_DetalleOferta;		
			DatosFormateador objDatosFormateador = new DatosFormateador();
			Account objAccount = getCuenta(objLeg.Nombredelacuenta2__c);
			objDatosFormateador.clientName		= objAccount.Name;
			objDatosFormateador.clientNumber	= objAccount.Tipodedocumento__c + objAccount.AccountNumber;
			objDatosFormateador.invoiceNumber	= objLeg.LTE_NFacturaVenta__c; //?? Campo autonumerico - buscar numero de factura, generando unc onsecutivo en un rago provisot por ETB
			objDatosFormateador.PIN1			= objLeg.LTE_NFacturaVenta__c; //?? Campo autonumerico - buscar numero de factura, generando unc onsecutivo en un rago provisot por ETB
			objDatosFormateador.PIN2			= 0;
			
			Datetime datToday = system.now();
   			objDatosFormateador.correlationId = objAccount.AccountNumber +'-'+ String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year()) 
   			+ String.valueOf(datToday.hour()) + String.valueOf(datToday.minute()) + String.valueOf(datToday.second());
   	
			//Calcular fecha final de facturacion
			DateTime fechaVtoFactura 			= obtenerFechaVtoFactura(3);						
			objDatosFormateador.invoiceDate		=  fechaVtoFactura.format('yyyy-MM-dd');
			
			
			list<OperacionComercial__c> listOpeComerciales;
			listOpeComerciales =  getOperacionesComercialesPosVenta(opCom.id);
			for(OperacionComercial__c objOpeCom:listOpeComerciales)
			{
				setIdOpeCom.add(objOpeCom.Id);		
			}		
			map<String,LTE_DetalleOferta__c> mapDetalleEquipo = getMapDetalleEquipo(setIdOpeCom);

			for(OperacionComercial__c objOpeCom:listOpeComerciales)
			{
				objLTE_DetalleOferta = mapDetalleEquipo.get(objOpeCom.Id);
				system.debug('objLTE_DetalleOferta.LTE_EquipoTraido__c-->'+objLTE_DetalleOferta.LTE_EquipoTraido__c);
				if(objLTE_DetalleOferta.LTE_EquipoTraido__c!=null && objLTE_DetalleOferta.LTE_EquipoTraido__c==false){	
					concatDescription	=	objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_Marca__c;
					concatIMEI			=	String.valueOf(objOpeCom.IMEI_del_Equipo__c);
					concatDeviceCost	=	String.valueOf(objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.Valor_del_Equipo__c);
					concatIva			=	String.valueOf(objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_IVA__c);
					concatTotalIva		=	String.valueOf(objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_PrecioConIVA__c);
					
					
					cadenaDetalle +='<inp:item>';
						cadenaDetalle +='<inp:description>'+concatDescription+'</inp:description>';
						cadenaDetalle +='<inp:IMEI>'+concatIMEI+'</inp:IMEI>';
						cadenaDetalle +='<inp:deviceCost>'+concatDeviceCost+'</inp:deviceCost>';
						cadenaDetalle +='<inp:IVA>'+concatIva+'</inp:IVA>';
						cadenaDetalle +='<inp:totalIVA>'+concatTotalIva+'</inp:totalIVA>'; 
					cadenaDetalle +='</inp:item>';
												
					// acumular totales
					totalSinIva		+=	objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.Valor_del_Equipo__c;
					totalIva		+=	objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_IVA__c;
					totalFactura	+=	objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_PrecioConIVA__c;
					if(objLTE_DetalleOferta.LTE_DescuentoEquipos__c != null && objLTE_DetalleOferta.LTE_DescuentoEquipos__c != 0)
					{
						totalDesceuntoFacturaEquipos+=totalFactura * objLTE_DetalleOferta.LTE_DescuentoEquipos__c/100 ;	
					}
				}
			}

			objDatosFormateador.amount				= totalSinIva 	- Decimal.valueOf(calcularAjusteDecena(totalSinIva)); 	//Se hace ajsute  a la decena
			objDatosFormateador.IVA					= totalIva		- Decimal.valueOf(calcularAjusteDecena(totalIva)); 		//Se hace ajsute  a la decena
			objDatosFormateador.totalAmount			= totalFactura	- Decimal.valueOf(calcularAjusteDecena(totalFactura)); 	//Se hace ajsute  a la decena
			
			objDatosFormateador.Item_description	= concatDescription;
			objDatosFormateador.Item_IMEI			= concatIMEI;
			objDatosFormateador.Item_deviceCost		= concatDeviceCost;
			objDatosFormateador.Item_IVA			= concatIva;
			objDatosFormateador.Item_totalIVA		= concatTotalIva;
			
			if(totalDesceuntoFacturaEquipos!=0 ){ // si hay descuento manda la linea de descuento al facturador 
				cadenaDetalle +='<inp:item>';
					cadenaDetalle +='<inp:description>Descuento</inp:description>';
					cadenaDetalle +='<inp:IMEI></inp:IMEI>';
					cadenaDetalle +='<inp:deviceCost>'+totalDesceuntoFacturaEquipos+'</inp:deviceCost>';
					cadenaDetalle +='<inp:IVA></inp:IVA>';
					cadenaDetalle +='<inp:totalIVA></inp:totalIVA>';
				cadenaDetalle +='</inp:item>';
			}

			String xmlFormateador = LTE_genXmlFormateador_cls.generaXMLFormateador(objDatosFormateador,cadenaDetalle);
			invocarServicioFormateador(xmlFormateador,objLeg.Id,totalFactura);
			}

		//?? Actualizar la operacion comercial de equipos con estos totales
		//?? enviar un correo al gestionador de la legalizacion en caso de fallo
		return null;
	}*/

	// Generacion de Factura Formateador para Venta
	public boolean enviarInfoFactEquipos(list<Legalizacion__c> listLegNew ,map<Id,Legalizacion__c> legOld) 
	{
        System.debug('\n\n-=#=-\n' + 'listLegNew.size()' + ': ' + listLegNew.size() + '\n-=#=-\n');
		set <String> setIdOpeCom = new set <String>();
	
		String concatDescription=null;
		String concatIMEI=null;
		String concatICCID =null;
		String concatDeviceCost=null;
		String concatIva=null;
		String concatTotalIva=null;
		String cadenaDetalle = '';
		boolean hayEquipoComprado=false;
		
		Decimal totalSinIva=0;
		Decimal totalIva=0;
		Decimal totalFactura=0;
		Decimal totalDesceuntoFacturaEquipos=0;
		
		 
		Legalizacion__c objLeg 		= 	listLegNew.get(0);
		Legalizacion__c objLegOld	=  legOld.get(objLeg.id);
		Boolean senalProceso=false; // Define si el crietrio para ejecución del proceso es verdadero
		if(((objLeg.LTE_TipoPago__c=='Inmediato' && objLeg.Estado__c == 'Validación de pago') || (objLeg.LTE_TipoPago__c!=' Inmediato' && objLeg.Estado__c == 'Gestionado'))  && 
		   (objLeg.Estado__c 				!= objLegOld.Estado__c 					|| objLeg.Portacion__c 			!= objLegOld.Portacion__c 					||  
		   objLeg.LTE_TipoPago__c 			!= objLegOld.LTE_TipoPago__c 			|| objLeg.LTE_FechaPortabilidad__c 	!= objLegOld.LTE_FechaPortabilidad__c 	||  
		   objLeg.LTE_FacturaEnviada__c 	!= objLegOld.LTE_FacturaEnviada__c))
		{
			if(objLeg.LTE_FacturaEnviada__c=='No enviado' ||objLeg.LTE_FacturaEnviada__c=='Reenviar') // estados validos para enviar la factura al formateador.
			{
				if(objLeg.LTE_TipoPago__c!='No requiere pago'){
					senalProceso=true;  // Cambió uno de los campos que disparan el proceso
				}
			}
			
		}
		
		system.debug('objLeg.Estado__c-->'+objLeg.Estado__c);
		system.debug('senalProceso-->'+senalProceso);
		system.debug('objLeg.Portacion__c-->'+objLeg.Portacion__c);
		system.debug('objLeg.LTE_TipoPago__c-->'+objLeg.LTE_TipoPago__c);
		system.debug('objLeg.LTE_FechaPortabilidad__c-->'+objLeg.LTE_FechaPortabilidad__c);
		system.debug('objLeg.LTE_FacturaEnviada__c-->'+objLeg.LTE_FacturaEnviada__c);
		system.debug('objLeg.LTE_FacturaEnviada__c-->'+objLeg.LTE_FacturaEnviada__c);
		
		boolean senalCondiciones = false;
		if(	(objLeg.Portacion__c== 'Si' &&	objLeg.LTE_TipoPago__c!=null && objLeg.LTE_FechaPortabilidad__c != null) || (objLeg.Portacion__c=='No' &&	objLeg.LTE_TipoPago__c!=null)){
			senalCondiciones=true;
		}
		system.debug('senalCondiciones-->'+senalCondiciones);
		if(senalProceso && senalCondiciones)	 // Si Cambió uno de los campos que disparan el proceso
		{
			system.debug('Entre-->'+senalCondiciones);
			LTE_DetalleOferta__c objLTE_DetalleOferta;		
			DatosFormateador objDatosFormateador = new DatosFormateador();
			Account objAccount = getCuenta(objLeg.Nombredelacuenta2__c);
			objDatosFormateador.clientName		= objAccount.Name;
			objDatosFormateador.clientNumber	= objAccount.Tipodedocumento__c + objAccount.AccountNumber;
			objDatosFormateador.invoiceNumber	= objLeg.LTE_NFacturaVenta__c; //?? Campo autonumerico - buscar numero de factura, generando unc onsecutivo en un rago provisot por ETB
			objDatosFormateador.PIN1			= objLeg.LTE_NFacturaVenta__c; //?? Campo autonumerico - buscar numero de factura, generando unc onsecutivo en un rago provisot por ETB
			objDatosFormateador.PIN2			= '00000000';
			
			Datetime datToday = system.now();
   			objDatosFormateador.correlationId = objAccount.AccountNumber +'-'+ String.valueOf(datToday.day()) + String.valueOf(datToday.month()) + String.valueOf(datToday.year()) 
   			+ String.valueOf(datToday.hour()) + String.valueOf(datToday.minute()) + String.valueOf(datToday.second());
   	
			//Calcular fecha final de facturacion
			DateTime fechaVtoFactura 			= obtenerFechaVtoFactura(3);						
			objDatosFormateador.invoiceDate		=  fechaVtoFactura.format('yyyy-MM-dd');
			
			
			list<OperacionComercial__c> listOpeComerciales;
			listOpeComerciales =  getOperacionesComerciales(objLeg);
            System.debug('\n\n-=#=-\n' + 'listOpeComerciales.size()' + ': ' + listOpeComerciales.size() + '\n-=#=-\n');
            System.debug('\n\n-=#=-\n' + 'listOpeComerciales' + ': ' + listOpeComerciales + '\n-=#=-\n');
			for(OperacionComercial__c objOpeCom:listOpeComerciales)
			{
				setIdOpeCom.add(objOpeCom.Id);		
			}		
			map<String,LTE_DetalleOferta__c> mapDetalleEquipo = getMapDetalleEquipo(setIdOpeCom);

			for(OperacionComercial__c objOpeCom:listOpeComerciales)
			{
				objLTE_DetalleOferta = mapDetalleEquipo.get(objOpeCom.Id);
				system.debug('objLTE_DetalleOferta-->'+objLTE_DetalleOferta);
				system.debug('objOpeCom.Id-->'+objOpeCom.Id);
				//system.debug('objLTE_DetalleOferta.LTE_EquipoTraido__c-->'+objLTE_DetalleOferta.LTE_EquipoTraido__c);
				if(objLTE_DetalleOferta.LTE_EquipoTraido__c!=null && objLTE_DetalleOferta.LTE_EquipoTraido__c==false){	
					hayEquipoComprado=true;
					concatDescription	=	objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.Name;
					concatIMEI			=	String.valueOf(objOpeCom.IMEI_del_Equipo__c);
					concatICCID			=   String.valueOf(objOpeCom.LTE_ICCID__c);
                    //concatDeviceCost    =   String.valueOf(objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.Valor_del_Equipo__c);
					concatDeviceCost	=	String.valueOf(objLTE_DetalleOferta.LTE_ValorAntesImpuestosparaEquipo__c);
                    //concatIva           =   String.valueOf(objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_IVA__c);
					concatIva			=	String.valueOf(objLTE_DetalleOferta.LTE_IVA__c);
                    //concatTotalIva      =   String.valueOf(objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_PrecioConIVA__c);
					concatTotalIva		=	String.valueOf(objLTE_DetalleOferta.LTE_ValorDespuesImpuestoIVA__c);

					if(concatIMEI==null) concatIMEI='';
					if(concatICCID==null) concatICCID='';					

					if( concatICCID!=''){	
							cadenaDetalle +='<inp:item>';
								cadenaDetalle +='<inp:description>NUMERO SIM CARD</inp:description>';
								cadenaDetalle +='<inp:IMEI>'+concatICCID+'</inp:IMEI>';
								cadenaDetalle +='<inp:deviceCost>0</inp:deviceCost>';
								cadenaDetalle +='<inp:IVA>0</inp:IVA>';
								cadenaDetalle +='<inp:totalIVA>0</inp:totalIVA>'; 
							cadenaDetalle +='</inp:item>';
					}
										
					cadenaDetalle +='<inp:item>';
						cadenaDetalle +='<inp:description>'+concatDescription+'</inp:description>';
						cadenaDetalle +='<inp:IMEI>'+concatIMEI+'</inp:IMEI>';
						cadenaDetalle +='<inp:deviceCost>'+concatDeviceCost+'</inp:deviceCost>';
						cadenaDetalle +='<inp:IVA>'+concatIva+'</inp:IVA>';
						cadenaDetalle +='<inp:totalIVA>'+concatTotalIva+'</inp:totalIVA>'; 
					cadenaDetalle +='</inp:item>';

																		
					// acumular totales
                    //totalSinIva     +=  objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.Valor_del_Equipo__c;
					totalSinIva		+=	objLTE_DetalleOferta.LTE_ValorAntesImpuestosparaEquipo__c;
                    //totalIva        +=  objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_IVA__c;
					totalIva		+=	objLTE_DetalleOferta.LTE_IVA__c;
                    //totalFactura    +=  objLTE_DetalleOferta.LTE_ReferenciaEquipo__r.LTE_PrecioConIVA__c;
					totalFactura	+=	objLTE_DetalleOferta.LTE_ValorDespuesImpuestoIVA__c;

                    System.debug('\n\n-=#=-\n' + 'objLTE_DetalleOferta.LTE_DescuentoEquipos__c' + ': ' + objLTE_DetalleOferta.LTE_DescuentoEquipos__c + '\n-=#=-\n');
					if(objLTE_DetalleOferta.LTE_DescuentoEquipos__c != null && objLTE_DetalleOferta.LTE_DescuentoEquipos__c != 0)
					{
                        //totalDesceuntoFacturaEquipos += (totalFactura * (objLTE_DetalleOferta.LTE_DescuentoEquipos__c / 100));
						totalDesceuntoFacturaEquipos += (objLTE_DetalleOferta.LTE_ValorAntesImpuestosparaEquipo__c * (objLTE_DetalleOferta.LTE_DescuentoEquipos__c / 100));
					}
				}
			}

			objDatosFormateador.amount				= totalSinIva 	- Decimal.valueOf(calcularAjusteDecena(totalSinIva)); 	//Se hace ajsute  a la decena
			objDatosFormateador.IVA					= totalIva		- Decimal.valueOf(calcularAjusteDecena(totalIva)); 		//Se hace ajsute  a la decena
			objDatosFormateador.totalAmount			= totalFactura	- Decimal.valueOf(calcularAjusteDecena(totalFactura)); 	//Se hace ajsute  a la decena
			totalDesceuntoFacturaEquipos            = totalDesceuntoFacturaEquipos   - Decimal.valueOf(calcularAjusteDecena(totalDesceuntoFacturaEquipos));     //Se hace ajsute  a la decena
            objDatosFormateador.totalAmount         -= totalDesceuntoFacturaEquipos;
            
			objDatosFormateador.Item_description	= concatDescription;
			objDatosFormateador.Item_IMEI			= concatIMEI;
			objDatosFormateador.Item_deviceCost		= concatDeviceCost;
			objDatosFormateador.Item_IVA			= concatIva;
			objDatosFormateador.Item_totalIVA		= concatTotalIva;
			
            System.debug('\n\n-=#=-\n' + 'totalDesceuntoFacturaEquipos' + ': ' + totalDesceuntoFacturaEquipos + '\n-=#=-\n');
			if(totalDesceuntoFacturaEquipos!=0 ){ // si hay descuento manda la linea de descuento al facturador 
				cadenaDetalle +='<inp:item>';
					cadenaDetalle +='<inp:description>Descuento</inp:description>';
					cadenaDetalle +='<inp:IMEI></inp:IMEI>';
					cadenaDetalle +='<inp:deviceCost>'+totalDesceuntoFacturaEquipos+'</inp:deviceCost>';
					cadenaDetalle +='<inp:IVA></inp:IVA>';
					cadenaDetalle +='<inp:totalIVA></inp:totalIVA>';
				cadenaDetalle +='</inp:item>';
			}
			if(hayEquipoComprado==true){
				String xmlFormateador = LTE_genXmlFormateador_cls.generaXMLFormateador(objDatosFormateador,cadenaDetalle);
                System.debug('\n\n-=#=-\n' + 'xmlFormateador' + ': ' + xmlFormateador + '\n-=#=-\n');
				invocarServicioFormateador(xmlFormateador,objLeg.Id,totalFactura);
			}
		}

		//?? Actualizar la operacion comercial de equipos con estos totales
		//?? enviar un correo al gestionador de la legalizacion en caso de fallo
		return null;
	}
	
	// Invocar el servicio para envio de infromacion al formateador
	@Future(callout=true)
	public static void invocarServicioFormateador(String strRequest, String idLegalizacion,Decimal totalFactura)
	{
		Legalizacion__c objLegalizacion = [select id,name from Legalizacion__c where id=:idLegalizacion];
		LogTransacciones__c log=new LogTransacciones__c();
		ServiciosWeb__c sw = ServiciosWeb__c.getValues('Formateador');
		String response = LibreriaUtilitariaJobs_cls.consultarServicio(strRequest, sw.Action__c, sw.EndPoint__c);
		System.debug('Response----------->' + response);
		
		Dom.Document doc = new Dom.Document();
		doc.load(response);
		Dom.XMLNode RtaWs = doc.getRootElement();		
		iterarXmlResponseFormateador(RtaWs);
		system.debug('mapRespuestaFact-->'+mapRespuestaFact);
		
		if(mapRespuestaFact.get('status')=='PASS'){
			system.debug('mapRespuestaFact.get(status)-IF->'+mapRespuestaFact.get('status'));
			objLegalizacion.LTE_FacturaEnviada__c		=	'Enviado';
			objLegalizacion.LTE_URLFacturaEquipos__c	=	mapRespuestaFact.get('fileName'); // Actualizar URL  de la factura en Atlas
			//objLegalizacion.LTE_URLFacturaEquipos__c	=	system.label.RutaFacturaLTE + mapRespuestaFact.get('fileName'); // Actualizar URL  de la factura en Atlas
			log.Estado__c								=	'Exitoso Formateador';	
		}else{
			system.debug('mapRespuestaFact.get(status)-ELSE->'+mapRespuestaFact.get('status'));
			objLegalizacion.LTE_FacturaEnviada__c		=	'Enviado con error';
			objLegalizacion.LTE_URLFacturaEquipos__c	=	'Pendiente Factura';
			log.Estado__c								=	'Fallido Formateador';						
		}
		log.Informacion_Enviada__c	=	strRequest;
		log.Informacion_Recibida__c	=	response;
		log.LTE_Legalizacion__c=idLegalizacion; 
		log.Name='Envio Info Formateador'+objLegalizacion.Name;		
		
		objLegalizacion.LTE_ValorCuentaxCobrar__c = totalFactura;	 // Actualziar la Legaliacion con el total de la factura
		update objLegalizacion;
		insert log;
	}
	
	
   public  list<OperacionComercial__c>  getOperacionesComerciales(Legalizacion__c objLegalizacion)
	{
		list<OperacionComercial__c> listOpeComerciales = [Select o.Valor_Equipos__c, o.ValorTotaloperacioncomercial__c, o.ValorEquipos2__c,
		 													o.Estado__c,o.IMEI_del_Equipo__c,o.LTE_ICCID__c 
															From OperacionComercial__c o
															where o.Estado__c='Pendiente'
															and o.TOPP__r.TipodeOperacionporplan__c!='Venta Equipos' // Exlcuir las OC de venta de equipos
															and Legalizacion__c=:objLegalizacion.id];

         return listOpeComerciales;
	
	}

   public  list<OperacionComercial__c>  getOperacionesComercialesPosVenta(String IdOpeCom)
	{
		list<OperacionComercial__c> listOpeComerciales = [Select o.Valor_Equipos__c, o.ValorTotaloperacioncomercial__c, o.ValorEquipos2__c,
		 													o.Estado__c,o.IMEI_del_Equipo__c,o.LTE_ICCID__c  
															From OperacionComercial__c o
															where id=:IdOpeCom];

         return listOpeComerciales;
	
	}




	 public  Account  getCuenta(String IdCuenta){
		Account objAccount = [Select a.Tipodedocumento__c, a.Name, a.AccountNumber From Account a where id=:IdCuenta];
		return objAccount;
	 }
	 
	 public  map<String,LTE_DetalleOferta__c>  getMapDetalleEquipo(set <String> setIdOpeCom){
	 	
	 		map<String,LTE_DetalleOferta__c> mapDetalleEquipo = new map<String,LTE_DetalleOferta__c>();
	 		
 			/*list<LTE_DetalleOferta__c> listaDetOferta = [Select l.LTE_ReferenciaEquipo__r.LTE_IVA__c, l.LTE_ReferenciaEquipo__r.Valor_del_Equipo__c,
                                                                l.LTE_ReferenciaEquipo__r.LTE_PrecioConIVA__c, l.LTE_ReferenciaEquipo__r.LTE_Marca__c,
                                                                l.LTE_ReferenciaEquipo__r.Name,
                                                                l.LTE_ReferenciaEquipo__c,l.LTE_OperacionComercial__c,LTE_DescuentoEquipos__c,LTE_EquipoTraido__c
                                                                From LTE_DetalleOferta__c l
                                                          where l.LTE_OperacionComercial__c in:setIdOpeCom];*/

            list<LTE_DetalleOferta__c> listaDetOferta = [Select l.LTE_IVA__c,
                                                                l.LTE_ValorAntesImpuestosparaEquipo__c,
 																l.LTE_ValorDespuesImpuestoIVA__c,
                                                                l.LTE_ReferenciaEquipo__r.LTE_Marca__c,
 																l.LTE_ReferenciaEquipo__r.Name,
 																l.LTE_ReferenciaEquipo__c,
                                                                l.LTE_OperacionComercial__c,
                                                                LTE_DescuentoEquipos__c,
                                                                LTE_EquipoTraido__c
 														   From LTE_DetalleOferta__c l
 														  where l.LTE_OperacionComercial__c in:setIdOpeCom];

 			if(listaDetOferta.size()>0){
 				for(LTE_DetalleOferta__c objDetOferta:listaDetOferta){
 					mapDetalleEquipo.put(objDetOferta.LTE_OperacionComercial__c,objDetOferta);
 				}
 			}
 			return mapDetalleEquipo;
	 }
	 
	public String calcularAjusteDecena( Decimal totalAmount ) 
	{ 
	    if ( totalAmount == null ) {

	    }
	    Decimal oneDecimalValue = 1; 
    	Decimal answer = 0;
 
    	integer  	bigInteger = Integer.valueOF(totalAmount);
    	Decimal 	integerDecimal =Decimal.valueOf( bigInteger);
 
    	integer remainder = math.mod(bigInteger,10);
    	Decimal remainderDecimal = Decimal.valueOf(remainder );
 
    	Decimal decimalDifference = totalAmount - integerDecimal;
 
        Decimal toHundred =oneDecimalValue - decimalDifference ;
 
	    if ( remainder> 4 ) {
	 
	      	answer = 10 - remainderDecimal ;
	      if ( toHundred!=oneDecimalValue) {
	        	answer = answer +  toHundred - oneDecimalValue ;
	      }
	    } else {
	 
	      answer = remainderDecimal;
	      if ( toHundred != oneDecimalValue ) {
	        answer = answer - toHundred+oneDecimalValue;
	      }
	      answer = answer * -1;
	    }
 
    return String.valueoF(answer);
	} 
	public static DateTime obtenerFechaVtoFactura(Integer cantDias)
 	{
	 	long milisegundosPorHora=3600000;
	 	long horasPorDia=8;
	    BusinessHours objBH =   [select id   from BusinessHours  where Name = :'Horario ETB' ];
	    long milisegundos = cantDias * horasPorDia * milisegundosPorHora;
	    DateTime fechaVtoFactura = BusinessHours.add(objBH.id, system.today(), milisegundos);
	   	return fechaVtoFactura;
 	}
 	
		
	public static void iterarXmlResponseFormateador(dom.XMLNode dataXml)
	{			
		List<dom.XMLNode> lstXmlValues = dataXml.getChildElements();
		if(lstXmlValues.size()>0)
		{
			for( dom.XMLNode dxm : lstXmlValues)
			{
				if(dataXml.getName()=='Service' || dataXml.getName()=='OutputGetInvoiceFormat')
				{
					system.debug('ENCONTRO FAULTS-------->');
					iterarXmlDatosService(dxm);
				}

				iterarXmlResponseFormateador(dxm);
			}
		}

	}	
			
	public static void iterarXmlDatosService(dom.XMLNode dxm)
	{
		if(dxm.getName()=='status')
		{
			mapRespuestaFact.put('status',dxm.getText());
			system.debug('ENCONTRO status-------->' + mapRespuestaFact);
		}
		
		if(dxm.getName()=='responseDate')
		{
			mapRespuestaFact.put('responseDate',dxm.getText());
			system.debug('ENCONTRO responseDate-------->' + mapRespuestaFact);
		}
		
		if(dxm.getName()=='mimeType')
		{
			mapRespuestaFact.put('mimeType',dxm.getText());
			system.debug('ENCONTRO mimeType-------->' + mapRespuestaFact);
		}
		
		if(dxm.getName()=='fileName')
		{
			mapRespuestaFact.put('fileName',dxm.getText());
			system.debug('ENCONTRO fileName-------->' + mapRespuestaFact);
		}
		
	}
}