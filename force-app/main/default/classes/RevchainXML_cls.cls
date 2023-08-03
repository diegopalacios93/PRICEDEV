/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Integraci?n RevChain
Descripci?n:			Clase de prueba para el Can?nico de RevChain
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0		24-11-2014	Hector Bayona (HB)		Creacion de la clase
2.0     25-11-2014  Luis E Mogollon (LEM)   Ajustes Canonico RevChain
3.0 	05-09-2017  Mauricio Farias Arias (MF) ajuste linea 310 para el mapeo en el mensaje de tibco el campo direccion y no el AC
*******************************************************************************/
public with sharing class RevchainXML_cls {
	
	
	public static string Customer(OperacionComercial__c OC){
			string ciudad= OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
		string direccion=OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
		string codigodane=OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
		string indicativo=oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
		string tipodoc=OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
		string tipoHomo=HomologacionCampos__c.getValues(tipodoc).Valor__c;
		if(tipoHomo==null)
			{tipoHomo='';}
		string numero=OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
		string tele=OC.CuentaCliente__r.Phone!=null?OC.CuentaCliente__r.Phone:'';
		//validar si tipo de identificacion NIT = JURIDICO sino PERSONA NATURAL
		string tipo ='';
		if(OC.CuentaCliente__r.Segmento__c!=null){
			
			HomologacionSegmentos2__c homologacion =HomologacionSegmentos2__c.getValues(OC.CuentaCliente__r.Segmento__c);
			if(homologacion!=null)
			{
				tipo=homologacion.segmento__c;
			}
		}
		if(tipo==null || tipo=='')
			tipo=HomologacionSegmentos__c.getValues('Defecto').Segmento__c;
		string xml='';
		xml='<Customer>'
			+'<FirstName>'+normalizarString(OC.CuentaCliente__r.Name)+'</FirstName>'
			+'<Surname></Surname>'
			+'<FullName>'+normalizarString(OC.CuentaCliente__r.Name)+'</FullName>'
			+'<ContactInfo>'
			+'	<FirstName/>'
			+'	<LastName/>'
			+'	<PhoneNumber>'+tele+'</PhoneNumber>'
			+'	<ContactAddress>'
			+'		<LineOne></LineOne>'
			+'		<CityName>'+normalizarString(ciudad)+'</CityName>'
			+'		<StateName></StateName>'
			+'		<CountryCode/>'
			+'		<CountryName></CountryName>'
			+'		<GisID></GisID>'
			+'		<Latitude></Latitude>'
			+'		<Longitude></Longitude>'
			+'		<CityCode></CityCode>'
			+'		<StateCode></StateCode>'
			+'		<PurposeCode></PurposeCode>'
			/*+'		<Technology>'
			+'			<Type></Type>'
			+'			<CoverageType></CoverageType>'
			+'			<CoverageIndicator></CoverageIndicator>'
			+'			<CoverageName></CoverageName>'
			+'			<Zone></Zone>'
			+'		</Technology>'*/
			+'		<DaneCode>'+codigodane+'</DaneCode>'
			+'		<Postcode></Postcode>'
			+'		<GeoGroup></GeoGroup>'
			+'	</ContactAddress>'
			+'</ContactInfo>'
			+'<MarketType>'+tipo+'</MarketType>'
			+'<DocumentType>'+tipoHomo+'</DocumentType>'
			+'<DocumentNo>'+numero+'</DocumentNo>'
			+'</Customer>';
			
		return xml;
	}
	
	
	public static string customerBill(OperacionComercial__c OC)
	{
		string ciudad= OC.CuentaFacturacion__r.Ciudad__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Name:'';
		string direccion=OC.CuentaFacturacion__r.DirCorresp__c!=null?OC.CuentaFacturacion__r.DirCorresp__c:'';
		string codigodane=OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
		
		string moneda ='';
		                if(OC.moneda__c=='Dolares')
                    moneda='USD';
                else if(OC.moneda__c=='Pesos')
                	moneda='COP';
                else
                	moneda='COP';
		string fac = (OC.CuentaFacturacion__r.Name!=null && OC.CuentaFacturacion__r.Fue_creada_en_revchain__c)?OC.CuentaFacturacion__r.Name:'';
		
		
		string ciclo = OC.CuentaFacturacion__r.CodCicloFac__c!=null?OC.CuentaFacturacion__r.CodCicloFac__c:'0';
		string statecod=recortarDane(codigodane);
		string xml='';
		string condicion='';
		if(OC.Legalizacion__r.Contrato__r.Forma_de_Pago__c!=null && OC.Legalizacion__r.Contrato__r.Forma_de_Pago__c.equals('Si'))
		{
			condicion='1';
		}
		else
		{
			condicion='0';
		}
		xml+='<CustomerBill>';
                xml+='<BillNo>'+OC.Activo__r.Name+'</BillNo>';
                xml+='<SuscriberId>'+fac+'</SuscriberId>';
                xml+='<InvoicingCycle>' + ciclo + '</InvoicingCycle>';  
                if(fac!=null && fac!='')
                {
                              
                xml+='<TaxPlan>PLAN DE IMPUESTOS ETB LOCAL</TaxPlan>';
                }
                xml+='<Billable>true</Billable>';
                xml+='<BillBillingName>'+normalizarString(OC.CuentaCliente__r.Name)+'</BillBillingName>';
                xml+='<CustomerBillSpec>';
                    xml+='<DeliveryMethod>Postal Service</DeliveryMethod>';
                xml+='</CustomerBillSpec>';
                xml+='<BillAmount>';
                //validacion de moneda
                	xml+='<CurrencyCode>'+moneda+'</CurrencyCode>';
                xml+='</BillAmount>';
                xml+='<BillingAddress>';
                    xml+='<LineOne>'+direccion+'</LineOne>';
                    xml+='<CityName>'+normalizarString(ciudad)+'</CityName>';
                   xml+='<StateName>'+normalizarString(ciudad)+'</StateName>';
                    xml+='<CountryCode>57</CountryCode>';
                    xml+='<CountryName></CountryName>';
                    xml+='<GisID></GisID>';
                    xml+='<Latitude></Latitude>';
                    xml+='<Longitude></Longitude>';
                    xml+='<CityCode></CityCode>';
                    xml+='<StateCode>'+statecod+'</StateCode>';
                    xml+='<PurposeCode></PurposeCode>';
                    /*xml+='<Technology>';
                        xml+='<Type>FIBRA</Type>';
                        xml+='<CoverageType>CO01</CoverageType>';
                        xml+='<CoverageIndicator>true</CoverageIndicator>';
                        xml+='<CoverageName>CO01</CoverageName>';
                       xml+=' <Zone>CHICO</Zone>';*/
                    //xml+='</Technology>';
                    xml+='<DaneCode>'+codigodane+'</DaneCode>';
                    xml+='<Postcode></Postcode>';
                    xml+='<GeoGroup>'+codigodane+'</GeoGroup>';
                xml+='</BillingAddress>';
                xml+='<InvoiceMethod>';
                    xml+='<Method>Cuentas Residenciales</Method>';
                    xml+='<Delivery>Postal Service</Delivery>';
                    xml+='<ContactEmailAdd/>';
                    xml+='<BillingParentId/>';
                xml+='</InvoiceMethod>';
            xml+='</CustomerBill>';
         return xml;
	}
	public static string recortarDane(string cod)
	{
		string codigo='';
		if(cod.length()==5)
		{
			codigo=cod.substring(0,2);
		}
		else if(cod.length()==4)
		{
			codigo=cod.substring(0,1);
		}
		return codigo;
	}
	public static string sender()
	{
		string xml='';
		xml+='<Sender>';
			xml+='<ID>SFDC</ID>';
			xml+='<Description>SFDC</Description>';
			xml+='<IPAddress>SFDC</IPAddress>';
			xml+='<SenderMessageID>SFDC</SenderMessageID>';
			xml+='<TransactionCode>SFDC</TransactionCode>';
			xml+='<CallingServiceName>SFDC</CallingServiceName>';
			xml+='<ApplicationID>SFDC</ApplicationID>';
			xml+='<ApplicationVersion>SFDC</ApplicationVersion>';
			xml+='<ContactName>SFDC</ContactName>';
			xml+='<ContactEmail>SFDC</ContactEmail>';
			xml+='<ContactPhoneNumber></ContactPhoneNumber>';
		xml+='</Sender>';
		return xml;
	}
	
	public static string Identification(OperacionComercial__c oc)
	{
		string xml='';
		xml+='<Identification>';
                xml+='<ID>'+oc.Activo__r.Name+'</ID>';
                xml+='<BusinessComponentID>'+oc.Activo__r.Name+'</BusinessComponentID>';
                xml+='<ApplicationObjectKeyID>'+oc.Activo__r.Name+'</ApplicationObjectKeyID>';
                xml+='<RevisionNumber>1</RevisionNumber>';
           xml+=' </Identification>';
           return xml;
	}
	
	public static string SalesOrder(OperacionComercial__c OC)
	{
		string tipo = '';
		DateTime dt;
		Time myTime = Time.newInstance(0, 0, 0, 0);
		dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
		DateTime fechacrea;
		if(OC.CuentaFacturacion__r.Fue_creada_en_revchain__c==true)
			fechacrea = dt;
		else
		 fechacrea = OC.Oportunidad__r.CreatedDate;
		DateTime dts = DateTime.now();
    	String formattedDt = dts.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
		string fechaCreacion='';
		if(fechacrea!=null)
		 	fechaCreacion= fechacrea.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
		else
			fechaCreacion =formattedDt;
			
		/*if(OC.TOPP__r.TipodeOperacionporplan__c.equals('Retiro'))
		{
			tipo='Cancelacion';
		}
		else if(OC.TOPP__r.TipodeOperacionporplan__c.equals('Retiro'))
		else
		{
			tipo=OC.TOPP__r.TipodeOperacionporplan__c;
		}*/
		HomologacionTOPPFacturacion__c homologacionTOPP = HomologacionTOPPFacturacion__c.getValues(OC.TOPP__r.TipodeOperacionporplan__c);
		if(homologacionTOPP!=null)
		{
			tipo=homologacionTOPP.valor__c;
		}
		//DateTime dt = DateTime.now();
    	//String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
    	if(OC.TOPP__r.TipodeOperacionporplan__c.equals('Retiro') &&  dt< OC.CuentaFacturacion__r.Fin_de_consumo__c)
		{
			system.debug('OC.CuentaFacturacion__r.Fin_de_consumo__c=='+OC.CuentaFacturacion__r.Fin_de_consumo__c);
			DateTime fechaFin=DateTime.newInstance(OC.CuentaFacturacion__r.Fin_de_consumo__c,mytime);
			fechaCreacion = fechaFin.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
			system.debug('fechaCreacion='+fechaCreacion);
		}



    	
		string xml='';
		 xml+='<SalesOrder>';
               xml+=' <OrderDateTime>'+fechaCreacion+'</OrderDateTime>';
                xml+='<DeliveryDateTime>'+fechaCreacion+'</DeliveryDateTime>';
                xml+='<TypeCode>'+tipo+'</TypeCode>';
                xml+='<FulfilmentPriorityCode>Medium</FulfilmentPriorityCode>';
                xml+='<FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>';
                xml+='<StatusCode>En Facturacion</StatusCode>';
           xml+=' </SalesOrder>';
		return xml;
	}
	public static string BusinessReference(OperacionComercial__c OC)
	{
		string xml='';
		xml+='<BusinessReference>';
                xml+='<Id>'+oc.Activo__r.Name+'</Id>';
                xml+='<ComponentId>'+oc.Activo__r.Name+'</ComponentId>';
                xml+='<ApplicationObjectKeyId>'+oc.Activo__r.Name+'</ApplicationObjectKeyId>';
            xml+='</BusinessReference>';
            return xml;
	}
	
	public static string CustomerPartyAccount(OperacionComercial__c OC)
	{
		string tipo ='';
		if(OC.CuentaCliente__r.Segmento__c!=null){
			
			HomologacionSegmentos__c homologacion =HomologacionSegmentos__c.getValues(OC.CuentaCliente__r.Segmento__c);
			if(homologacion!=null)
			{
				tipo=homologacion.segmento__c;
			}
		}
		if(tipo==null || tipo=='')
			tipo=HomologacionSegmentos__c.getValues('Defecto').Segmento__c;
		string ciudad= OC.CuentaFacturacion__r.Ciudad__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Name:'';
		string direccion=OC.CuentaFacturacion__r.DirCorresp__c!=null?OC.CuentaFacturacion__r.DirCorresp__c:'';
        string codigodane=OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
		string indicativo=oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
		string tipodoc=OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
			HomologacionCampos__c homologacion = HomologacionCampos__c.getValues(tipodoc);
			string tipoHomo='';
			if(homologacion!=null)
				 tipoHomo=homologacion.Valor__c;
		if(tipoHomo==null)
			{tipoHomo='';}
		string numero=OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
		string xml='';
		 xml+='<CustomerPartyAccount>';
                xml+='<Identification>';
                   xml+=' <ID>'+oc.Activo__r.Name+'</ID>';
                    xml+='<BusinessComponentID>'+oc.Activo__r.Name+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+oc.Activo__r.Name+'</ApplicationObjectKeyID>';
               xml+=' </Identification>';
                xml+='<Name>'+normalizarString(oc.cuentaCliente__r.Name)+'</Name>';
                xml+='<Address>';
                   xml+=' <Identification>';
                        xml+='<ID>'+oc.Activo__r.Name+'</ID>';
                        xml+='<BusinessComponentID>'+oc.Activo__r.Name+'</BusinessComponentID>';
                       xml+=' <ApplicationObjectKeyID>'+oc.Activo__r.Name+'</ApplicationObjectKeyID>';
                   xml+=' </Identification>';
                    xml+='<LineOne>'+direccion+'</LineOne>';
                    xml+='<CityName>'+normalizarString(ciudad)+'</CityName>';
                    xml+='<StateName>'+normalizarString(ciudad)+'</StateName>';
                    xml+='<CountryCode>'+indicativo+'</CountryCode>';
                    xml+='<CountryName></CountryName>';
                    xml+='<GisID></GisID>';
                    xml+='<Latitude></Latitude>';
                    xml+='<Longitude></Longitude>';
                    xml+='<CityCode>'+codigodane+'</CityCode>';
                    xml+='<StateCode></StateCode>';
                    xml+='<PurposeCode></PurposeCode>';
                   // xml+='<Technology>';
                     //  xml+=' <Type>FIBRA</Type>';
                       // xml+='<CoverageType>CO01</CoverageType>';
                       // xml+='<CoverageIndicator>true</CoverageIndicator>';
                       // xml+='<CoverageName>CO01</CoverageName>';
                       // xml+='<Zone>CHICO</Zone>';
                    //xml+='</Technology>';
                xml+='</Address>';
                xml+='<ContactPerson>';
                    xml+='<FirstName/>';
                   xml+=' <FamilyName/>';
                    xml+='<CompleteNumber/>';
               xml+=' </ContactPerson>';
                xml+='<TypeCode>'+tipo+'</TypeCode>';
                xml+='<Custom>';
                    xml+='<DocumentType>'+tipoHomo+'</DocumentType>';
                    xml+='<DocumentNumber>'+numero+'</DocumentNumber>';
                xml+='</Custom>';
           xml+=' </CustomerPartyAccount>';
            return xml;
	}
public static string salesOrderAgent()
{
	string xml='';
	xml+='<SalesOrderAgent>';
                  xml+='<Identification>';
                     xml+='<ID>?</ID>';
                     xml+='<BusinessComponentID>?</BusinessComponentID>';
                     xml+='<ApplicationObjectKeyID>?</ApplicationObjectKeyID>';
                 xml+=' </Identification>';
                  xml+='<Name>?</Name>';
                  xml+='<SalesChannel>?</SalesChannel>';
               xml+='</SalesOrderAgent>';
    return xml;
}

public static string Custom(OperacionComercial__c OC)
{
	string xml='';
		string tipo = '';
		if(OC.TOPP__r.TipodeOperacionporplan__c.equalsIgnoreCase('Retiro'))
		{
			tipo='Cancelacion';
		}
		else
		{
			tipo=OC.TOPP__r.TipodeOperacionporplan__c;
		}
	 xml+='<Custom>';
                 xml+=' <OrderSubType>'+tipo+'</OrderSubType>';
                  xml+='<SignedDocumentIndicator>true</SignedDocumentIndicator>';
               xml+='</Custom>';
	return xml;
}


public static string PartyIdentification(OperacionComercial__c OC)
{
	string xml='';
	 xml+='<PartyIdentification>';
                  xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                  xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                  xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
               xml+='</PartyIdentification>';
               return xml;
}
//se debe alimentar de los planes del plan homologado de REVCHAIN
public static string SalesOrderLine(OperacionComercial__c OC,PlanFacturacion__c plan)
{
		string ciudad= OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
		string direccion=OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
		string codigodane=OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
		string indicativo=oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
		string tipodoc=OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
		string numero=OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
		string tele=OC.CuentaCliente__r.Phone!=null?OC.CuentaCliente__r.Phone:'';
		Time myTime = Time.newInstance(0, 0, 0, 0);
		Datetime dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
    	String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
    	String formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
	string xml='';
	
		string tipo = '';
		if(OC.TOPP__r.TipodeOperacionporplan__c.equals('Retiro'))
		{
			tipo='DELETE';
		}
		else
		{
			tipo='ADD';
		}
	 xml+='<SalesOrderLine>';
                xml+='<Identification>';
                    xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                    xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                xml+='</Identification>';
                xml+='<OrderQuantity>1</OrderQuantity>';
               
                xml+='<ServiceActionCode>'+tipo+'</ServiceActionCode>';
                xml+='<FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>';
                xml+='<ParentSalesOrderLineIdentification>';
                    xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                    xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                xml+='</ParentSalesOrderLineIdentification>';
                xml+='<RootParentSalesOrderLineIdentification>';
                   xml+=' <ID>'+OC.Activo__r.Name+'</ID>';
                    xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                xml+='</RootParentSalesOrderLineIdentification>';
                xml+='<StatusCode>Orden Cumplida</StatusCode>';
                xml+='<ServiceAddress>';
                    xml+='<Identification>';
                       xml+=' <ID>'+OC.Activo__r.Name+'</ID>';
                        xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                       xml+=' <ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                    xml+='</Identification>';
                    xml+='<LineOne>'+OC.Activo__r.Name+'</LineOne>';
                    xml+='<CityName>'+normalizarString(ciudad)+'</CityName>';
                    xml+='<StateName>'+normalizarString(ciudad)+'</StateName>';
                    xml+='<CountryCode/>';
                    xml+='<CountryName>Colombia</CountryName>';
                    xml+='<GisID/>';
                    xml+='<Latitude/>';
                    xml+='<Longitude/>';
                    xml+='<CityCode>'+codigodane+'</CityCode>';
                   xml+=' <StateCode/>';
                    xml+='<PurposeCode/>';
                    /*xml+='<Technology>';
                        xml+='<Type>FIBRA</Type>';
                        xml+='<CoverageType>CO01</CoverageType>';
                       xml+=' <CoverageIndicator>true</CoverageIndicator>';
                       xml+=' <CoverageName>CO01</CoverageName>';
                       xml+=' <Zone>CHICO</Zone>';
                    xml+='</Technology>';*/
                xml+='</ServiceAddress>';
                xml+='<ItemReference>';
                   xml+=' <ItemIdentification>';
                        xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                        xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                       xml+=' <ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                   xml+=' </ItemIdentification>';
                    xml+='<Name>'+plan.CatalogoProductosFacturacion__r.Servicio__c+'</Name>';
                    xml+='<ServiceIndicator>false</ServiceIndicator>';
                    xml+='<TypeCode>'+plan.CatalogoProductosFacturacion__r.Servicio__c+'</TypeCode>';
                    xml+='<NetworkIndicator>false</NetworkIndicator>';
                    xml+='<PrimaryClassificationCode>no ip</PrimaryClassificationCode>';
                    
                    //LEM validar si es numero de conexion o id de servicio
	string connectionnumber='';
	ConfFamiliasproductos__c confproducto = ConfFamiliasproductos__c.getValues(OC.plan__r.NombredelProducto__r.Familia__c);
	if(confproducto!=null)
	{
		connectionnumber=(string)OC.get(confproducto.campo__c);
	}
			connectionnumber=OC.Activo__r.ExternalServiceId__c;
                    xml+='<ExternalServiceId>'+connectionnumber+'</ExternalServiceId>';
                xml+='</ItemReference>';
                xml+='<SalesOrderSchedule>';
                    xml+='<RequestedDeliveryDate>'+formattedDt+'</RequestedDeliveryDate>';
                    xml+='<ExpectedDeliveryDate>'+formattedDt+'</ExpectedDeliveryDate>';
                    xml+='<ShipTo>';
                        xml+='<GisID/>';
                        xml+='<Latitude/>';
                        xml+='<Longitude/>';
                        xml+='<CityCode/>';
                        xml+='<StateCode/>';
                        xml+='<PurposeCode/>';
                       xml+=' <Reference/>';
                        /*xml+='<Technology>';
                            xml+='<Type/>';
                            xml+='<CoverageType/>';
                            xml+='<CoverageIndicator>false</CoverageIndicator>';
                            xml+='<CoverageName/>';
                            xml+='<Zone/>';
                       xml+=' </Technology>';*/
                    xml+='</ShipTo>';
               xml+='</SalesOrderSchedule>';
                xml+='<OwnerPartyReference>';
                   xml+=' <ID>'+OC.Activo__r.Name+'</ID>';
                   xml+=' <BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                xml+='</OwnerPartyReference>';
                xml+='<ScheduleOrderIndicator>true</ScheduleOrderIndicator>';
                //xml+='<StartDateTime>'+fechacreacion+'</StartDateTime>';
                /* xml+='<Custom>';
                     xml+='<PartNumber>A</PartNumber>';
                     xml+='<AssetIntegrationID>'+OC.Activo__r.Name+'</AssetIntegrationID>';
                 xml+='</Custom>';*/
               
            
	return xml;
}


public static string SalesOrderLineSolTI(OperacionComercial__c OC,string servicio)
{
		string ciudad= OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
		string direccion=OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
		string codigodane=OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
		string indicativo=oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
		string tipodoc=OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
		string numero=OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
		string tele=OC.CuentaCliente__r.Phone!=null?OC.CuentaCliente__r.Phone:'';
	DateTime dt = DateTime.now();
    	String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
    	String formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
	string xml='';
	
		string tipo = '';
		if(OC.TOPP__r.TipodeOperacionporplan__c.equals('Retiro'))
		{
			tipo='DELETE';
		}
		else
		{
			tipo='ADD';
		}
	 xml+='<SalesOrderLine>';
                xml+='<Identification>';
                    xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                    xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                xml+='</Identification>';
                xml+='<OrderQuantity>1</OrderQuantity>';
               
                xml+='<ServiceActionCode>'+tipo+'</ServiceActionCode>';
                xml+='<FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>';
                xml+='<ParentSalesOrderLineIdentification>';
                    xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                    xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                xml+='</ParentSalesOrderLineIdentification>';
                xml+='<RootParentSalesOrderLineIdentification>';
                   xml+=' <ID>'+OC.Activo__r.Name+'</ID>';
                    xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                xml+='</RootParentSalesOrderLineIdentification>';
                xml+='<StatusCode>Orden Cumplida</StatusCode>';
                xml+='<ServiceAddress>';
                    xml+='<Identification>';
                       xml+=' <ID>'+OC.Activo__r.Name+'</ID>';
                        xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                       xml+=' <ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                    xml+='</Identification>';
                    xml+='<LineOne>'+OC.Activo__r.Name+'</LineOne>';
                    xml+='<CityName>'+normalizarString(ciudad)+'</CityName>';
                    xml+='<StateName>'+normalizarString(ciudad)+'</StateName>';
                    xml+='<CountryCode/>';
                    xml+='<CountryName>Colombia</CountryName>';
                    xml+='<GisID/>';
                    xml+='<Latitude/>';
                    xml+='<Longitude/>';
                    xml+='<CityCode>'+codigodane+'</CityCode>';
                   xml+=' <StateCode/>';
                    xml+='<PurposeCode/>';
                    /*xml+='<Technology>';
                        xml+='<Type>FIBRA</Type>';
                        xml+='<CoverageType>CO01</CoverageType>';
                       xml+=' <CoverageIndicator>true</CoverageIndicator>';
                       xml+=' <CoverageName>CO01</CoverageName>';
                       xml+=' <Zone>CHICO</Zone>';
                    xml+='</Technology>';*/
                xml+='</ServiceAddress>';
                xml+='<ItemReference>';
                   xml+=' <ItemIdentification>';
                        xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                        xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                       xml+=' <ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                   xml+=' </ItemIdentification>';
                    xml+='<Name>'+OC.Plan__r.NombrePlanSolucionTI__c+'</Name>';
                    xml+='<ServiceIndicator>false</ServiceIndicator>';
                    xml+='<TypeCode>'+OC.Plan__r.NombrePlanSolucionTI__c+'</TypeCode>';
                    xml+='<NetworkIndicator>false</NetworkIndicator>';
                    xml+='<PrimaryClassificationCode>no ip</PrimaryClassificationCode>';
                    xml+='<ExternalServiceId>'+OC.Activo__r.ExternalServiceID__c+'</ExternalServiceId>';
                xml+='</ItemReference>';
                xml+='<SalesOrderSchedule>';
                    xml+='<RequestedDeliveryDate>'+formattedDt+'</RequestedDeliveryDate>';
                    xml+='<ExpectedDeliveryDate>'+formattedDt+'</ExpectedDeliveryDate>';
                    xml+='<ShipTo>';
                        xml+='<GisID/>';
                        xml+='<Latitude/>';
                        xml+='<Longitude/>';
                        xml+='<CityCode/>';
                        xml+='<StateCode/>';
                        xml+='<PurposeCode/>';
                       xml+=' <Reference/>';
                        /*xml+='<Technology>';
                            xml+='<Type/>';
                            xml+='<CoverageType/>';
                            xml+='<CoverageIndicator>false</CoverageIndicator>';
                            xml+='<CoverageName/>';
                            xml+='<Zone/>';
                       xml+=' </Technology>';*/
                    xml+='</ShipTo>';
               xml+='</SalesOrderSchedule>';
                xml+='<OwnerPartyReference>';
                   xml+=' <ID>'+OC.Activo__r.Name+'</ID>';
                   xml+=' <BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                xml+='</OwnerPartyReference>';
                xml+='<ScheduleOrderIndicator>true</ScheduleOrderIndicator>';
                //xml+='<StartDateTime>'+fechacreacion+'</StartDateTime>';
                /* xml+='<Custom>';
                     xml+='<PartNumber>A</PartNumber>';
                     xml+='<AssetIntegrationID>'+OC.Activo__r.Name+'</AssetIntegrationID>';
                 xml+='</Custom>';*/
               
            
	return xml;
}


public static string SupplementaryInfo(OperacionComercial__c OC,string plan,string producto)
{
	DateTime dt = DateTime.now();
	Time myTime = Time.newInstance(0, 0, 0, 0);
	dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
    	String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
    	String formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
    	if(OC.TOPP__r.TipodeOperacionporplan__c.equals('Retiro') &&  dt< OC.CuentaFacturacion__r.Fin_de_consumo__c)
		{
			system.debug('OC.CuentaFacturacion__r.Fin_de_consumo__c=='+OC.CuentaFacturacion__r.Fin_de_consumo__c);
			DateTime fechaFin=DateTime.newInstance(OC.CuentaFacturacion__r.Fin_de_consumo__c,mytime);
			formattedDt2 = fechaFin.format('MM/dd/yyyy hh:mm:ss');
			system.debug('formattedDt2='+formattedDt2);
		}
    	
	string xml='';
	xml+='<SupplementaryInfo>';
                    xml+='<Identification>';
                        xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                        xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                    xml+='</Identification>';
                    xml+='<OrderQuantity>1</OrderQuantity>';
                    xml+='<ServiceActionCode>ADD</ServiceActionCode>';
                    xml+='<FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>';
                    xml+='<ParentSalesOrderLineIdentification>';
                        xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                        xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                    xml+='</ParentSalesOrderLineIdentification>';
                    xml+='<RootParentSalesOrderLineIdentification>';
                        xml+='<ID>'+OC.Activo__r.Name+'</ID>';
                        xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                    xml+='</RootParentSalesOrderLineIdentification>';
                    xml+='<StatusCode>'+OC.Activo__r.Name+'</StatusCode>';
                    xml+='<ServiceAddress/>';
                    xml+='<ItemReference>';
                        xml+='<ItemIdentification>';
                            xml+='<ID>1-JWPK</ID>';
                            xml+='<BusinessComponentID>'+OC.Activo__r.Name+'</BusinessComponentID>';
                            xml+='<ApplicationObjectKeyID>'+OC.Activo__r.Name+'</ApplicationObjectKeyID>';
                        xml+='</ItemIdentification>';
                        xml+='<Name>'+producto+'</Name>';
                        xml+='<ServiceIndicator>true</ServiceIndicator>';
                        xml+='<TypeCode>'+producto+'</TypeCode>';
                        xml+='<NetworkIndicator>false</NetworkIndicator>';
                        xml+='<PrimaryClassificationCode>no ip</PrimaryClassificationCode>';
                        xml+='<ExternalServiceId>'+OC.Activo__r.Name+'</ExternalServiceId>';
                    xml+='</ItemReference>';
                    xml+='<SalesOrderSchedule>';
                        xml+='<RequestedDeliveryDate>'+formattedDt+'</RequestedDeliveryDate>';
                        xml+='<ExpectedDeliveryDate>'+formattedDt+'</ExpectedDeliveryDate>';
                       xml+=' <ShipTo/>';
                    xml+='</SalesOrderSchedule>';
                   xml+=' <OwnerPartyReference>';
                        xml+='<ID>A</ID>';
                       xml+=' <BusinessComponentID>A</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>A</ApplicationObjectKeyID>';
                    xml+='</OwnerPartyReference>';
                    xml+='<ScheduleOrderIndicator>true</ScheduleOrderIndicator>';
                    xml+='<OrderSubType/>';
                   xml+=' <SignedDocumentsIndicator/>';
                    xml+='<StartDateTime>'+formattedDt2+'</StartDateTime>';
                    
             
                //xml+='</SupplementaryInfo>';
	return xml;
}
public static string parameter(string nombre, string valor)
{
	System.debug('@@-parameter-nombre>'+nombre+'valor'+valor);
	string xml='';
	xml+='<Parameter>';
                        xml+='<Name>'+nombre+'</Name>';
                        xml+='<Value>'+valor+'</Value>';
                    xml+='</Parameter>';
                    return xml;
	
}
public static string rateplan(string plan)
{
	string xml='';
	      xml+=' <RatePlan>';
                       xml+=' <Name>\"'+plan+'\"</Name>';
                   xml+=' </RatePlan>';
         return xml;
}
public static string Discounts(string nombre,string nompar,double valor,string descrip,double validez)
{
	string xml='';
	      xml+='<Discount>';
                        xml+='<Feature>';
                           xml+=' <TypeName>'+nombre+'</TypeName>';
                           xml+=' <Parameter>';
                               xml+=' <Name>'+nompar+'</Name>';
                                xml+='<Value>'+valor+'</Value>';
                                xml+='<Description>'+descrip+'</Description>';
                                xml+='<Validity>'+validez+'</Validity>';
                            xml+='</Parameter>';
                        xml+='</Feature>';
                    xml+='</Discount>';
                xml+='</Discounts>';
	return xml;
}

public static string connection(OperacionComercial__c OC,PlanFacturacion__c plan)
{
	DateTime dt;
	Time myTime = Time.newInstance(0, 0, 0, 0);
	dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
    	String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
    	String formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
	string xml='';

    if(OC.TOPP__r.TipodeOperacionporplan__c.equals('Retiro') &&  dt< OC.CuentaFacturacion__r.Fin_de_consumo__c)
	{
		system.debug('OC.CuentaFacturacion__r.Fin_de_consumo__c=='+OC.CuentaFacturacion__r.Fin_de_consumo__c);
		DateTime fechaFin=DateTime.newInstance(OC.CuentaFacturacion__r.Fin_de_consumo__c,mytime);
		formattedDt2 = fechaFin.format('MM/dd/yyyy hh:mm:ss');
		system.debug('formattedDt2='+formattedDt2);
	}
	
	//LEM validar si es numero de conexion o id de servicio
	string connectionnumber='';
	ConfFamiliasproductos__c confproducto = ConfFamiliasproductos__c.getValues(OC.plan__r.NombredelProducto__r.Familia__c);
	if(confproducto!=null)
	{
		connectionnumber=(string)OC.get(confproducto.campo__c);
	}

	xml+='<StartDateTime>'+formattedDt2+'</StartDateTime>';
	  xml+=' <Connection>';
                     xml+='<ConnectionTypeName>'+plan.CatalogoProductosFacturacion__r.ConnectionID__c+'</ConnectionTypeName>';
                     xml+='<ConnectionNumberTypeName>'+plan.CatalogoProductosFacturacion__r.ConnectionTypeID__c+'</ConnectionNumberTypeName>';
                     xml+='<ConnectionNumber>'+connectionnumber+'</ConnectionNumber>';
                    // xml+='<StartDateTime>'+formattedDt2+'</StartDateTime>';
                  xml+='</Connection>';
	return xml;
}

public static string connectionSolTI(OperacionComercial__c OC,string cat,string tipocon)
{
	DateTime dt;
	Time myTime = Time.newInstance(0, 0, 0, 0);
	dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
    	String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
    	String formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
	string xml='';

    if(OC.TOPP__r.TipodeOperacionporplan__c.equals('Retiro') &&  dt< OC.CuentaFacturacion__r.Fin_de_consumo__c)
	{
		system.debug('OC.CuentaFacturacion__r.Fin_de_consumo__c=='+OC.CuentaFacturacion__r.Fin_de_consumo__c);
		DateTime fechaFin=DateTime.newInstance(OC.CuentaFacturacion__r.Fin_de_consumo__c,mytime);
		formattedDt2 = fechaFin.format('MM/dd/yyyy hh:mm:ss');
		system.debug('formattedDt2='+formattedDt2);
	}

	xml+='<StartDateTime>'+formattedDt2+'</StartDateTime>';
	  xml+=' <Connection>';
                     xml+='<ConnectionTypeName>'+cat+'</ConnectionTypeName>';
                     xml+='<ConnectionNumberTypeName>'+tipocon+'</ConnectionNumberTypeName>';
                     xml+='<ConnectionNumber>'+OC.IDservicio__c+'</ConnectionNumber>';
                    // xml+='<StartDateTime>'+formattedDt2+'</StartDateTime>';
                  xml+='</Connection>';
	return xml;
}

public static string Discounts()
{
	string xml='';
		xml+='<Discounts>';
	      xml+='<Discount>';
                        xml+='<Feature>';
                           xml+=' <TypeName></TypeName>';
                           xml+=' <Parameter>';
                               xml+=' <Name></Name>';
                                xml+='<Value></Value>';
                                xml+='<Description></Description>';
                                xml+='<Validity></Validity>';
                            xml+='</Parameter>';
                        xml+='</Feature>';
                    xml+='</Discount>';
                xml+='</Discounts>';
	return xml;
}
public static string SpecificationGroupXA(string XAID,string ParentID,string idspec,string ActionCode,string nombre,string valor)
{
	string xml='';
	   xml+='<SpecificationGroupXA>';
                    xml+='<XAID>'+XAID+'</XAID>';
                    xml+='<ParentID>'+ParentID+'</ParentID>';
                   xml+=' <ID>'+IDspec+'</ID>';
                    xml+='<ActionCode>'+ActionCode+'</ActionCode>';
                    xml+='<Name>'+nombre+'</Name>';
                    xml+='<Value>'+valor+'</Value>';
               xml+=' </SpecificationGroupXA>';
	return xml;
}
public static string AltKey(string nombre,string valor)
{
    string xml='';
    
    //Recorta nombre de la cuenta cliente a 40 caracteres si su longitud es mayor
    if(nombre.equalsIgnoreCase('ETBLN') && valor.length()>40){
       valor = valor.SubString(0,40);
       valor = normalizarString(valor);
    }
    
    xml+='<AltKey>';
                    xml+='<AltKeyName>'+nombre+'</AltKeyName>';
                    xml+='<AltKeyValue>\''+valor+'\'</AltKeyValue>';
                xml+='</AltKey>';
    return xml;
}

public static string SpecificationGroupXA()
{
	string xml='';
	   xml+='<SpecificationGroupXA>';
                    xml+='<XAID></XAID>';
                    xml+='<ParentID></ParentID>';
                   xml+=' <ID></ID>';
                    xml+='<ActionCode></ActionCode>';
                    xml+='<Name></Name>';
                    xml+='<Value></Value>';
               xml+=' </SpecificationGroupXA>';
	return xml;
}
public static string AltKey()
{
	string xml='';
	xml+='<AltKey>';
                    xml+='<AltKeyName></AltKeyName>';
                    xml+='<AltKeyValue></AltKeyValue>';
                xml+='</AltKey>';
	return xml;
}

public static string AltKey(string segmento,string subsegmento,OperacionComercial__c OC,string valor)
{
		string ciudad= OC.CuentaFacturacion__r.Ciudad__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Name:'';
		string direccion=OC.CuentaFacturacion__r.DirCorresp__c!=null?OC.CuentaFacturacion__r.DirCorresp__c:'';
		string codigodane=OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
		//string ciudad= OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
		//string direccion=OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
		//string codigodane=OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
		string indicativo=oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
		string tipodoc=OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
		string numero=OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
		string tele=OC.CuentaCliente__r.Phone!=null?OC.CuentaCliente__r.Phone:'';
		string seg=segmento!=null?segmento:'';
		string subseg=subsegmento!=null?subsegmento:'';
		string dirRecortada='';
		if(direccion.length()>=58)
			dirRecortada=direccion.SubString(0,58);
		else 
			dirRecortada=direccion;
		
        //Recorta nombre de cuenta cliente a 40 caracteres si su longitud es mayor
        String nombreCuentaCliente = OC.CuentaCliente__r.Name;
        
        if(nombreCuentaCliente.length()>40){
            nombreCuentaCliente = nombreCuentaCliente.SubString(0,40);
            normalizarString(nombreCuentaCliente);
        }
        
	string xml='';
	xml+='<AltKey>';
                    xml+='<AltKeyName>USO</AltKeyName>';
                    xml+='<AltKeyValue>\'Corp\'</AltKeyValue>';
                xml+='</AltKey>';
                	
	xml+='<AltKey>';
                    xml+='<AltKeyName>Segmento</AltKeyName>';
                    xml+='<AltKeyValue>'+seg+'</AltKeyValue>';
                xml+='</AltKey>';
                	
	xml+='<AltKey>';
                    xml+='<AltKeyName>Subsegmento</AltKeyName>';
                    xml+='<AltKeyValue>'+subseg+'</AltKeyValue>';
                xml+='</AltKey>';
				xml+='<AltKey>';
                    xml+='<AltKeyName>SysOrg</AltKeyName>';
                    xml+='<AltKeyValue>SF</AltKeyValue>';
               xml+=' </AltKey>';
				xml+='<AltKey>';                
				xml+='<AltKeyName>BACON</AltKeyName> ';               
				xml+='<AltKeyValue>Colombia</AltKeyValue>';            
			xml+='</AltKey> ';           
			xml+='<AltKey> ';               
				xml+='<AltKeyName>BACYT</AltKeyName>  ';              
				xml+='<AltKeyValue>'+normalizarString(ciudad)+'</AltKeyValue>';            
			xml+='</AltKey> ';           
			xml+='<AltKey> ';              
				xml+='<AltKeyName>BAAID</AltKeyName> ';               
				xml+='<AltKeyValue>'+OC.Activo__r.Name+'</AltKeyValue>  ';          
			xml+='</AltKey> ';           
			xml+='<AltKey> ';               
				xml+='<AltKeyName>BAADD</AltKeyName>  ';              
				xml+='<AltKeyValue>'+dirRecortada+'</AltKeyValue>';          
			xml+='</AltKey>';      
			xml+='<AltKey>';                
				xml+='<AltKeyName>PHONE</AltKeyName>';                
				xml+='<AltKeyValue>'+tele+'</AltKeyValue>';           
			xml+='</AltKey>';           
			xml+='<AltKey>';                
				xml+='<AltKeyName>BAUSO</AltKeyName>';               
				xml+='<AltKeyValue></AltKeyValue>';            
			xml+='</AltKey>';            
			xml+='<AltKey>';                
				xml+='<AltKeyName>ETBFN</AltKeyName>';                
				xml+='<AltKeyValue></AltKeyValue>';            
			xml+='</AltKey>';            
			xml+='<AltKey>';                
				xml+='<AltKeyName>ETBLN</AltKeyName>';                
				xml+='<AltKeyValue>'+normalizarString(nombreCuentaCliente)+'</AltKeyValue>';            
			xml+='</AltKey>';
			//alt keys sobre ciclo de facturacion
			string plazo=OC.Legalizacion__r.Contrato__r.PlazoPago__c!=null?OC.Legalizacion__r.Contrato__r.PlazoPago__c:'';
			
				xml+='<AltKey>';                
				xml+='<AltKeyName>payment_prd</AltKeyName>';                
				xml+='<AltKeyValue>'+plazo+'</AltKeyValue>';            
			xml+='</AltKey>'; 
			xml+='<AltKey>';                
				xml+='<AltKeyName>conv_id</AltKeyName>';                
				xml+='<AltKeyValue>'+valor+'</AltKeyValue>';            
			xml+='</AltKey>';          
	return xml;
}
public static string Custom2(OperacionComercial__c OC)
{
	string xml='';
		xml+='<Custom>';
				xml+='<PartNumber>A</PartNumber>';
				xml+='<AssetIntegrationID>'+OC.Activo__r.Name+'</AssetIntegrationID>';
			xml+='</Custom>';
			return xml;   
}
public static string Billing()
{
	string xml='';
	xml+='<Billing>';
                     
                     xml+='<BillKey></BillKey>';
                     xml+='<ArrayIPs></ArrayIPs>';
                     xml+='<Permanence></Permanence>';
                     xml+='<Quota></Quota>';
                     xml+='<FlowConfiguration></FlowConfiguration>';
                  xml+='</Billing>';
                  return xml;
}

public static string normalizarString(String input){
    
	String specialChars = '°|!|"|#|$|%|/|(|)|=|?|¡|¬|¿|@|¨|*|‘|’|‚|“|”|‹|›|<|>|‾|+|~|[|]|{|}|`|,|;|:|¨|^|\\';
	String original = '&áàäâéèëêíìïîóòöôúùüûñÁÀÄÂÉÈËÊÍÌÏÎÓÒÖÔÚÙÜÛÑçÇ';
	String ascii = 'YaaaaeeeeiiiioooouuuunAAAAEEEEIIIIOOOOUUUUNcC';

    for(integer i=0; i<specialChars.split('|').size(); i++)

    input = input.replace(specialChars.split('|')[i], '');

    String output = input;

    for (Integer i=1; i<original.length(); i++) 
    {
        output = output.replace(original.substring(i-1,i), ascii.substring(i-1,i));
    }
    
    return output;
}
}