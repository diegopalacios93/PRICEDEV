/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Integracion RevChain
Descripci?n:            Clase de prueba para el Can?nico de RevChain
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     03-09-2015  Luis E Mogollon            Creacion de la clase
*******************************************************************************/

public  class RevChainLD_cls {
    
    
    //enviar la OC con la informacion de la cuenta, obligatoria.
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
            +'  <FirstName/>'
            +'  <LastName/>'
            +'  <PhoneNumber>'+tele+'</PhoneNumber>'
            +'  <ContactAddress>'
            +'      <LineOne></LineOne>'
            +'      <CityName>'+normalizarString(ciudad)+'</CityName>'
            +'      <StateName></StateName>'
            +'      <CountryCode/>'
            +'      <CountryName></CountryName>'
            +'      <GisID></GisID>'
            +'      <Latitude></Latitude>'
            +'      <Longitude></Longitude>'
            +'      <CityCode></CityCode>'
            +'      <StateCode></StateCode>'
            +'      <PurposeCode></PurposeCode>'
            /*+'        <Technology>'
            +'          <Type></Type>'
            +'          <CoverageType></CoverageType>'
            +'          <CoverageIndicator></CoverageIndicator>'
            +'          <CoverageName></CoverageName>'
            +'          <Zone></Zone>'
            +'      </Technology>'*/
            +'      <DaneCode>'+codigodane+'</DaneCode>'
            +'      <Postcode></Postcode>'
            +'      <GeoGroup></GeoGroup>'
            +'  </ContactAddress>'
            +'</ContactInfo>'
            +'<MarketType>'+tipo+'</MarketType>'
            +'<DocumentType>'+tipoHomo+'</DocumentType>'
            +'<DocumentNo>'+numero+'</DocumentNo>'
            +'</Customer>';
            
        return xml;
    }
    
    
    public static string customerBill(OperacionComercial__c OC,string codigo, string fac)
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
        //string fac = (OC.CuentaFacturacion__r.Name!=null && OC.CuentaFacturacion__r.Fue_creada_en_revchain__c)?OC.CuentaFacturacion__r.Name:'';
        
        
        string ciclo = OC.CuentaFacturacion__r.CodCicloFac__c!=null?OC.CuentaFacturacion__r.CodCicloFac__c:'';
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
                xml+='<BillNo>'+codigo+'</BillNo>';
                xml+='<SuscriberId>'+fac+'</SuscriberId>';
                xml+='<InvoicingCycle>0</InvoicingCycle>';  
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
    
    public static string Identification(string codigo)
    {
        string xml='';
        xml+='<Identification>';
                xml+='<ID>'+codigo+'</ID>';
                xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
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
            //fechaCreacion= fechacrea.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
            fechaCreacion =formattedDt;
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
    
    public static string SalesOrderLSP(OperacionComercial__c OC)
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
        DateTime dts = DateTime.now().addDays(1);
        String formattedDt = dts.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        string fechaCreacion='';
        if(fechacrea!=null)
            //fechaCreacion= fechacrea.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
            fechaCreacion =formattedDt;
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
    
    
    public static string BusinessReference(string codigo)
    {
        string xml='';
        xml+='<BusinessReference>';
                xml+='<Id>'+codigo+'</Id>';
                xml+='<ComponentId>'+codigo+'</ComponentId>';
                xml+='<ApplicationObjectKeyId>'+codigo+'</ApplicationObjectKeyId>';
            xml+='</BusinessReference>';
            return xml;
    }
    
    public static string CustomerPartyAccount(OperacionComercial__c OC,string codigo)
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
        string ciudad= OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
        string direccion=OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
        string codigodane=OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
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
                   xml+=' <ID>'+codigo+'</ID>';
                    xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
               xml+=' </Identification>';
                xml+='<Name>'+normalizarString(oc.cuentaCliente__r.Name)+'</Name>';
                xml+='<Address>';
                   xml+=' <Identification>';
                        xml+='<ID>'+codigo+'</ID>';
                        xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                       xml+=' <ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                   xml+=' </Identification>';
                    xml+='<LineOne>'+codigo+'</LineOne>';
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



public static string CustomLD(String strOrderSubType)
{
    string xml='';
        /*TramitesLargaDistancia__c tramites = TramitesLargaDistancia__c.getValues(OC.TOPP__r.TipodeOperacionporplan__c);
        string tipo='';
        if(tramites!=null )
        {
            tipo=tramites.OrderSubType__c;
        }*/
     xml+='<Custom>';
                 xml+=' <OrderSubType>'+strOrderSubType+'</OrderSubType>';
                  xml+='<SignedDocumentIndicator>true</SignedDocumentIndicator>';
               xml+='</Custom>';
    return xml;
}


public static string PartyIdentification(string Codigo)
{
    string xml='';
     xml+='<PartyIdentification>';
                  xml+='<ID>'+codigo+'</ID>';
                  xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                  xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
               xml+='</PartyIdentification>';
               return xml;
}
//se debe alimentar de los planes del plan homologado de REVCHAIN


public static string SalesOrderLineLD(OperacionComercial__c OC,string codigo,string external,string tipo,string clase,string servicio)
{
        string ciudad= OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
        string direccion=OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
        string codigodane=OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
        string indicativo=oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
        string tipodoc=OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
        string numero=OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
        string tele=OC.CuentaCliente__r.Phone!=null?OC.CuentaCliente__r.Phone:'';
        Time myTime = Time.newInstance(0, 0, 0, 0);
        //Datetime dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
        Datetime dt=System.now();
        String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        String formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
    string xml='';
    
    
     xml+='<SalesOrderLine>';
                xml+='<Identification>';
                    xml+='<ID>'+codigo+'</ID>';
                    xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                xml+='</Identification>';
                xml+='<OrderQuantity>1</OrderQuantity>';
               
                xml+='<ServiceActionCode>'+tipo+'</ServiceActionCode>';
                xml+='<FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>';
                xml+='<ParentSalesOrderLineIdentification>';
                    xml+='<ID>'+codigo+'</ID>';
                    xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                xml+='</ParentSalesOrderLineIdentification>';
                xml+='<RootParentSalesOrderLineIdentification>';
                   xml+=' <ID>'+codigo+'</ID>';
                    xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                xml+='</RootParentSalesOrderLineIdentification>';
                xml+='<StatusCode>Orden Cumplida</StatusCode>';
                xml+='<ServiceAddress>';
                    xml+='<Identification>';
                       xml+=' <ID>'+codigo+'</ID>';
                        xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                       xml+=' <ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                    xml+='</Identification>';
                    xml+='<LineOne>'+codigo+'</LineOne>';
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
                        xml+='<ID>'+codigo+'</ID>';
                        xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                       xml+=' <ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                   xml+=' </ItemIdentification>';
                    xml+='<Name>'+Servicio+'</Name>';
                    xml+='<ServiceIndicator>false</ServiceIndicator>';
                    xml+='<TypeCode>'+Servicio+'</TypeCode>';
                    xml+='<NetworkIndicator>false</NetworkIndicator>';
                    if(clase==null || clase=='')
                    {
                        clase='no ip';
                    }
                    xml+='<PrimaryClassificationCode>'+clase+'</PrimaryClassificationCode>';
                    
                    //LEM validar si es numero de conexion o id de servicio

                    xml+='<ExternalServiceId>'+external+'</ExternalServiceId>';
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
                   xml+=' <ID>'+codigo+'</ID>';
                   xml+=' <BusinessComponentID>'+codigo+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                xml+='</OwnerPartyReference>';
                xml+='<ScheduleOrderIndicator>true</ScheduleOrderIndicator>';
                //xml+='<StartDateTime>'+fechacreacion+'</StartDateTime>';
                /* xml+='<Custom>';
                     xml+='<PartNumber>A</PartNumber>';
                     xml+='<AssetIntegrationID>'+codigo+'</AssetIntegrationID>';
                 xml+='</Custom>';*/
               
            
    return xml;
}


public static string SupplementaryInfoLD(OperacionComercial__c OC,string producto,string external,string codigo,string clase,string tipo)
{
    DateTime dt = DateTime.now();
    Time myTime = Time.newInstance(0, 0, 0, 0);
    //dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
        String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        String formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
        if(OC.TOPP__r.TipodeOperacionporplan__c.equals('Retiro') &&  dt< OC.CuentaFacturacion__r.Fin_de_consumo__c)
        {
            system.debug('OC.CuentaFacturacion__r.Fin_de_consumo__c=='+OC.CuentaFacturacion__r.Fin_de_consumo__c);
            DateTime fechaFin=DateTime.newInstance(OC.CuentaFacturacion__r.Fin_de_consumo__c,mytime);
            formattedDt2 = fechaFin.format('MM/dd/yyyy hh:mm:ss');
            system.debug('formattedDt2='+formattedDt2);
        }
        
        /* BEGIN - Manuel Medina - Validacion de fechas para TOPP Cambio de Plan - 27102015 */
        /*if( OC.TOPP__r.TipodeOperacionporplan__c.equals( 'Cambio de Plan' ) && tipo.equalsIgnoreCase( 'Delete' ) ){
            
        }
        /* END - Manuel Medina - Validacion de fechas para TOPP Cambio de Plan - 27102015 */
        
    string xml='';
    xml+='<SupplementaryInfo>';
                    xml+='<Identification>';
                        xml+='<ID>'+codigo+'</ID>';
                        xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                    xml+='</Identification>';
                    xml+='<OrderQuantity>1</OrderQuantity>';
                    xml+='<ServiceActionCode>'+tipo+'</ServiceActionCode>';
                    xml+='<FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>';
                    xml+='<ParentSalesOrderLineIdentification>';
                        xml+='<ID>'+codigo+'</ID>';
                        xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                    xml+='</ParentSalesOrderLineIdentification>';
                    xml+='<RootParentSalesOrderLineIdentification>';
                        xml+='<ID>'+codigo+'</ID>';
                        xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                    xml+='</RootParentSalesOrderLineIdentification>';
                    xml+='<StatusCode>'+codigo+'</StatusCode>';
                    xml+='<ServiceAddress/>';
                    xml+='<ItemReference>';
                        xml+='<ItemIdentification>';
                            xml+='<ID>1-JWPK</ID>';
                            xml+='<BusinessComponentID>'+codigo+'</BusinessComponentID>';
                            xml+='<ApplicationObjectKeyID>'+codigo+'</ApplicationObjectKeyID>';
                        xml+='</ItemIdentification>';
                        xml+='<Name>'+producto+'</Name>';
                        xml+='<ServiceIndicator>true</ServiceIndicator>';
                        xml+='<TypeCode>'+producto+'</TypeCode>';
                        xml+='<NetworkIndicator>false</NetworkIndicator>';
                          if(clase==null || clase=='')
                    {
                        clase='no ip';
                    }
                        xml+='<PrimaryClassificationCode>'+clase+'</PrimaryClassificationCode>';
                        xml+='<ExternalServiceId>'+external+'</ExternalServiceId>';
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
                        xml+=' <Name>\''+plan+'\'</Name>';
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



public static string connectionLD(OperacionComercial__c OC,String connectionType,string numeroconexion)
{
    DateTime dt = system.now();
    Time myTime = Time.newInstance(0, 0, 0, 0);
    //dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
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


    xml+='<StartDateTime>'+formattedDt2+'</StartDateTime>';
      xml+=' <Connection>';
                     xml+='<ConnectionTypeName>'+connectionType+'</ConnectionTypeName>';
                     xml+='<ConnectionNumberTypeName>'+connectionType+'</ConnectionNumberTypeName>';
                     xml+='<ConnectionNumber>'+numeroconexion+'</ConnectionNumber>';
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



public static string AltKeyLD(string segmento,string subsegmento,OperacionComercial__c OC,string valor,string Cuentafac,string codigo)
{
        string ciudad= OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
        string direccion=OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
        string codigodane=OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
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
                xml+='<AltKeyValue>'+codigo+'</AltKeyValue>  ';          
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
            xml+='<AltKey>';
                            xml+='<AltKeyName>Subscriber Id Actual</AltKeyName>';                
                xml+='<AltKeyValue>'+cuentafac+'</AltKeyValue>';            
            xml+='</AltKey>';           
    return xml;
}
public static string Custom2(string codigo)
{
    string xml='';
        xml+='<Custom>';
                xml+='<PartNumber>A</PartNumber>';
                xml+='<AssetIntegrationID>'+codigo+'</AssetIntegrationID>';
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