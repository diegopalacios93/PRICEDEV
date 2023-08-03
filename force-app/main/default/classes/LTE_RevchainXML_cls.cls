/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Luis Penaranda
Proyecto:               ETB - Integracion RevChain
DescripciOn:            Clase de prueba para el Canonico de RevChain
Cambios (Versiones)
---------------------------------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------------  ---------------
1.0     03-08-2015  Luis Penaranda (LP)     	Creacion de la clase
1.1 	19/11/2015  Luis Peñaranda          	Ajuste para cambio de campo direcccion 
1.2     26-11-2015  Luis Penaranda (LRP)    	Adición de lógica para Cambio de Plan
1.3     03-02-2016  Andrés Garrido (AG)    		Adición de lógica para Cambio de Número
1.4     27-05-2016  Carlos Gonzalez (CG)    	Ajustes longitud nombres y direcciones
1.5 	08/11/2017	Mauricio Farias Arias (MF) 	se ajusta las lineas 164-166 debido  aque en la integracion de facturacion de equipos se debe enviar el dia de corte y no el ciclo
1.6 	14/11/2018	Samuel Rodríguez (SR) 		Condiciones para envió de la información de dirección de facturación desde la cuenta relacionada a la legalización para Venta Equipos
*******************************************************************************/
public with sharing class LTE_RevchainXML_cls {

  public static String estatic_tipoCambio=null;
      
    public static list<Contact> getRepresentanteLegal(set<String> lstCuentas){ 
        list<Contact> repLegal = [Select  c.Ciudad__r.Name,c.NumerodeIdentificacion__c,c.AccountId,c.Tipodedocumento__c, c.Name, 
                                  c.FirstName, c.Estado__c, c.Ciudad__c,LastName,c.Ciudad__r.padre__r.Name,c.Ciudad__r.CodigoDane__c,
                                  c.Ciudad__r.padre__r.CodigoDane__c,c.Direccion__c
                            From Contact c  //?? cuadrar este query
                            where  c.AccountId in: lstCuentas  
                            //and c.Cargo__c='Representante Legal' //?? verificar este where
                             ];
        system.debug('repLegal-->'+repLegal);
        return repLegal;
    }
            
    public static string Customer(OperacionComercial__c OC,Contact repLegal){
        
		string ciudad         = '';
        string departamento   = '';
        string direccion      = '';
        string codigodane     = '';
        String codigoDaneDpto = '';       
        /*string ciudad         =   OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
        string departamento     =   OC.CuentaCliente__r.Departamento__c!=null?OC.CuentaCliente__r.Departamento__c:'';
        string direccion        =   OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
        string codigodane       =   OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
        String codigoDaneDpto   =   OC.CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c:'';
        */
        
		if(OC.TOPP__r.TipodeOperacionporplan__c=='Venta Equipos' ){//INI14505-SR-Para venta equipo enviar datos direccion de facturación desde la Legalización 
        	ciudad           =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name:'';
        	departamento     =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name:'';
        	direccion        =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c:'';           
        	codigodane       =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
        	codigoDaneDpto   =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c:'';   
        }else{
        	ciudad           =   OC.CuentaFacturacion__r.Ciudad__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Name:'';
    	    departamento     =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name:'';	
     	   	// Se hace ajuste para cambio de campo direcccion LTE_DireccionFacturacion__c --> DirCorresp__c LRPA-19-11-2015
     	   	direccion        =   OC.CuentaFacturacion__r.DirCorresp__c!=null?OC.CuentaFacturacion__r.DirCorresp__c:'';           
    	   	codigodane       =   OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
    	   	codigoDaneDpto   =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c:'';         
        } 
          
        string indicativo       =   oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
        string tipodoc          =   OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
        string numero           =   OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
        
        HomologacionCampos__c homologacion = HomologacionCampos__c.getValues(Oc.CuentaCliente__r.Tipodedocumento__c);

        string repLegalTipodedocumento = '';
        string repLegalNumerodeIdentificacion = '';
        string replegalFirstName='';
        string replegalLastName='';
        string repLegalCiudad='';
        string repLegalDpto='';
        string repLegalcodDaneCiudad='';
        string repLegalcodDaneDpto='';
        string repLegalDirecion='';
        if(repLegal!=null){
             replegalFirstName              =   repLegal.FirstName!=null?repLegal.FirstName:'';
             replegalLastName               =   repLegal.LastName!=null?repLegal.LastName:'';   
             repLegalTipodedocumento        =   repLegal.Tipodedocumento__c;
             repLegalNumerodeIdentificacion =   repLegal.NumerodeIdentificacion__c;
             //repLegalCiudad                 =   repLegal.Ciudad__r.Name;
             //repLegalDpto                   =   repLegal.Ciudad__r.padre__r.Name;
             //repLegalcodDaneCiudad          =   repLegal.Ciudad__r.CodigoDane__c;
             //repLegalcodDaneDpto            =   repLegal.Ciudad__r.padre__r.CodigoDane__c;
             //repLegalDirecion               =   repLegal.Direccion__c;
             repLegalCiudad                 =   ciudad;
             repLegalDpto                   =   departamento;
             repLegalcodDaneCiudad          =   codigodane;
             repLegalcodDaneDpto            =   codigoDaneDpto;
             repLegalDirecion               =   direccion;
        }
                
        string xml='';

            xml+='<Customer>';
                xml+='<FirstName></FirstName>';
                xml+='<Surname></Surname>';
                xml+='<FullName>'+normalizarString(OC.CuentaCliente__r.Name)+'</FullName>';
                xml+='<ContactInfo>';
                    xml+='<FirstName>'+normalizarString(replegalFirstName)+'</FirstName>';
                    xml+='<LastName>'+normalizarString(replegalLastName)+'</LastName>';
                    xml+='<PhoneNumber/>';
                    xml+='<ContactAddress>';
                        xml+='<LineOne>'+repLegalDirecion+'</LineOne>';
                        xml+='<CityName>'+normalizarString(repLegalCiudad)+'</CityName>';
                        xml+='<StateName>'+repLegalDpto+'A</StateName>';
                        xml+='<CountryCode/>';
                        xml+='<CountryName/>';
                        xml+='<GisID/>';
                        xml+='<Latitude/>';
                        xml+='<Longitude/>';
                        xml+='<CityCode>'+repLegalcodDaneCiudad+'</CityCode>';
                        xml+='<StateCode>'+repLegalcodDaneDpto+'</StateCode>';
                        xml+='<PurposeCode/>';
                        xml+='<Technology>';
                            xml+='<Type/>';
                            xml+='<CoverageType/>';
                            xml+='<CoverageIndicator>false</CoverageIndicator>';
                            xml+='<CoverageName/>';
                            xml+='<Zone/>';
                        xml+='</Technology>';
                        xml+='<DaneCode>'+repLegalcodDaneCiudad+'</DaneCode>';
                        xml+='<Postcode>'+repLegalcodDaneDpto+'</Postcode>'; 
                        xml+='<GeoGroup></GeoGroup>';
                    xml+='</ContactAddress>';
                xml+='</ContactInfo>';
                xml+='<MarketType>JURIDICO</MarketType>';
                xml+='<DocumentType>'+homologacion.Valor__c+'</DocumentType>';
                xml+='<DocumentNo>'+numero+'</DocumentNo>';
            xml+='</Customer>';
                    

            
        return xml;
    }

    // Calcular Ciclo Facturacion RevChain
    public static String consultarDiaFacturacionRevchain(String strDiaSFDC)
    {
        String strDiaFactRevchain = '';
        list <LTE_CiclosFacturacion__c> lstCiclosFact = LTE_CiclosFacturacion__c.getall().values();
        
        for(LTE_CiclosFacturacion__c objCiclosFact : lstCiclosFact)
        {
        if(objCiclosFact.LTE_DiaCorteOCS__c == Integer.valueOf(strDiaSFDC))
            strDiaFactRevchain = String.valueOf(Integer.valueOf(objCiclosFact.LTE_CicloFacturacionRevChain__c));
        }
        
        return strDiaFactRevchain;
    }
    
    
    public static string customerBill(OperacionComercial__c OC)
    {
        string ciudadCtaFact;
        string departamentotaFact;
        string codigodaneciudadCtaFact;
        String codigoDaneDptoFact;      
        string direccionCtaFact;
        String nombrecuenta;
        String taxplan;
        String ciclo;
        Boolean facturable=false;
        string diaCorte='';
        
        Boolean senalCreadaRevchain=OC.Legalizacion__r.LTE_CuentaFacturacion__r.Fue_creada_en_revchain__c;// senal de cuenta creada en RevChain
        
        //?? CAMBIAR PARA SACAR LA CUENTA DE LA OPERACION COMERCIAL Y NO DESDE LA LEGALIZACION ************************
        
        if(OC.TOPP__r.Name==System.label.Venta_Equipos_TELEFONIA_MOVIL_LTE){ // Tipo de operacion diferente a Venta de Equipos
            system.debug('equipo');
            nombrecuenta            =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Name;
            ciclo                   =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c;
            diaCorte                =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c;            
            //ciclo                   =   consultarDiaFacturacionRevchain(diaCorte);
            taxplan                 =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.TaxPlan__c;
            facturable              =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Facturable__c;
            
             //o.Legalizacion__r.LTE_CuentaFacturacion__r.CodCicloFac__c
             
            ciudadCtaFact           =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name                      !=null? OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name:'';
            departamentotaFact      =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name             !=null? OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name:'';
            codigodaneciudadCtaFact =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c             !=null? OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
            codigoDaneDptoFact      =   recortarDane(OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c    !=null? OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c:'');
            // Se hace ajuste para cambio de campo direcccion LTE_DireccionFacturacion__c --> DirCorresp__c LRPA-19-11-2015        
            direccionCtaFact        =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c         !=null? OC.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c:'';     
            facturable              =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Facturable__c;      
        }else{
            system.debug('sinequipo');
            nombrecuenta            =   OC.CuentaFacturacion__r.Name;
            ciclo                   =   OC.CuentaFacturacion__r.CodCicloFac__c;
            diaCorte                =   OC.CuentaFacturacion__r.LTE_CicloFacturacion__c;            
            ciclo                   =   consultarDiaFacturacionRevchain(diaCorte);
            
            taxplan                 =   OC.CuentaFacturacion__r.TaxPlan__c;  
            facturable              =   OC.CuentaFacturacion__r.Facturable__c;
                
            ciudadCtaFact           =   OC.CuentaFacturacion__r.Ciudad__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Name:'';
            departamentotaFact      =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name:'';
            codigodaneciudadCtaFact =   OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
            codigoDaneDptoFact      =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c:'';  
            // Se hace ajuste para cambio de campo direcccion LTE_DireccionFacturacion__c --> DirCorresp__c LRPA-19-11-2015   
            direccionCtaFact        =   OC.CuentaFacturacion__r.DirCorresp__c!=null?OC.CuentaFacturacion__r.DirCorresp__c:'';   
            
        }
        
        
        string xml='';
        string condicion='';
        
        xml+='<CustomerBill>';
                xml+='<BillNo>'+nombrecuenta+'</BillNo>';
                xml+='<SuscriberId>'+nombrecuenta+'</SuscriberId>';
                xml+='<InvoicingCycle>'+ciclo+'</InvoicingCycle>'; //?? esta etiquetea no esta en el tag
                xml+='<TaxPlan>'+taxplan+'</TaxPlan>';
                xml+='<Billable>'+facturable+'</Billable>';               
                xml+='<BillBillingName>'+normalizarString(OC.CuentaCliente__r.Name)+'</BillBillingName>';
                xml+='<CustomerBillSpec>';
                    //xml+='<DeliveryMethod>'+OC.CuentaFacturacion__r.LTE_MetodoEnvio__c+'</DeliveryMethod>'; //??
                    xml+='<DeliveryMethod>Postal Service</DeliveryMethod>';
                xml+='</CustomerBillSpec>';
                xml+='<BillAmount>';
                    xml+='<CurrencyCode>COP</CurrencyCode>';
                xml+='</BillAmount>';
                xml+='<BillingAddress>';
                    xml+='<LineOne>'+direccionCtaFact+'</LineOne>';
                    xml+='<CityName>'+normalizarString(ciudadCtaFact)+'</CityName>';
                    xml+='<StateName>'+departamentotaFact+'</StateName>';
                    xml+='<CountryCode/>';
                    xml+='<CountryName/>';
                    xml+='<GisID/>';
                    xml+='<Latitude/>';
                    xml+='<Longitude/>';
                    xml+='<CityCode>'+codigodaneciudadCtaFact+'</CityCode>';
                    xml+='<StateCode>'+codigoDaneDptoFact+'</StateCode>';
                    xml+='<PurposeCode/>';
                    xml+='<Technology>';
                        xml+='<Type/>';
                        xml+='<CoverageType/>';
                        xml+='<CoverageIndicator>false</CoverageIndicator>';
                        xml+='<CoverageName/>';
                        xml+='<Zone/>';
                    xml+='</Technology>';
                    xml+='<DaneCode>'+codigodaneciudadCtaFact+'</DaneCode>';
                    xml+='<Postcode>'+codigodaneciudadCtaFact+'</Postcode>';
                    xml+='<GeoGroup>'+codigodaneciudadCtaFact+'</GeoGroup>';
                xml+='</BillingAddress>';
                xml+='<InvoiceMethod>';
                    xml+='<Method>Cuentas LTE Detallada</Method>';
                    //xml+='<Delivery>'+OC.CuentaFacturacion__r.Facturable__c+'</Delivery>'; //?? ajustar
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
        if(cod.length()==5){
            codigo=cod.substring(0,2);
        }
        else if(cod.length()==4){
            codigo=cod.substring(0,1);
        }
        return codigo;
    }
    
    public static string RequestHeader(OperacionComercial__c oc)
    {
        system.debug('Op. Comercial-->'+oc);
    
        Time myTime = Time.newInstance(0, 0, 0, 0); 
        Datetime dt = system.now();
        String formattedDt;
        String formattedDt2;
        if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan' || OC.TOPP__r.TipodeOperacionporplan__c=='Cambio Número' || OC.TOPP__r.TipodeOperacionporplan__c=='Adición SVA' || OC.TOPP__r.TipodeOperacionporplan__c=='Retiro SVA'){  	// Tomar Fecha efectiva Cambio Plan  PVTA LRPA - 26-11-2015)
        	dt=DateTime.newInstance(OC.FechaInicioReconexion__c,myTime); 	// Tomar Fecha efectiva Cambio Plan  PVTA LRPA - 26-11-2015)
        }
        else if(OC.TOPP__r.Name!=System.label.Venta_Equipos_TELEFONIA_MOVIL_LTE && OC.TOPP__r.TipodeOperacionporplan__c!='Cambio de Plan'){
            dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
        }
        formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
                        
        
        string xml='';
            xml+='<ns1:RequestHeader xmlns:ns1="http://www.etb.com.co/NPlay/commons/RequestHeader/v1.0">';
                xml+='<ns1:InputSystem>SALESFORCE</ns1:InputSystem>';
                xml+='<ns1:OutputSystem>OSM</ns1:OutputSystem>';
                xml+='<ns1:Operation>NPOPSFCTFACT</ns1:Operation>';
                xml+='<ns1:OrderNumber>'+OC.Id+'</ns1:OrderNumber>'; //??
                xml+='<ns1:PONumber/>';
                xml+='<ns1:CreationDateTime>'+formattedDt+'</ns1:CreationDateTime>'; 
                xml+='<ns1:AttemptNumber>1</ns1:AttemptNumber>';
                xml+='<ns1:CaseNumber></ns1:CaseNumber>';
            xml+='</ns1:RequestHeader>';        
        return xml;
    }
        
    public static string sender(OperacionComercial__c oc)
    {
        string xml='';
            xml+='<Sender>';
                xml+='<ID>A</ID>';
                xml+='<Description>A</Description>';
                xml+='<IPAddress>A</IPAddress>';
                xml+='<SenderMessageID>A</SenderMessageID>';
                xml+='<TransactionCode>A</TransactionCode>';
                xml+='<CallingServiceName>A</CallingServiceName>';
                xml+='<ApplicationID>A</ApplicationID>';
                xml+='<ApplicationVersion>A</ApplicationVersion>';
                xml+='<ContactName>A</ContactName>';
                xml+='<ContactEmail>A</ContactEmail>';
                xml+='<ContactPhoneNumber>A</ContactPhoneNumber>';
            xml+='</Sender>';       
        return xml;
    }
    
    public static string Identification(OperacionComercial__c oc) 
    {
        string xml='';
            xml+='<Identification>';
                xml+='<ID>'+oc.Id+'</ID>';
                xml+='<BusinessComponentID>'+oc.Id+'</BusinessComponentID>';
                xml+='<ApplicationObjectKeyID>'+oc.Id+'</ApplicationObjectKeyID>';
                xml+='<RevisionNumber>1</RevisionNumber>';
            xml+='</Identification>';                      
           return xml;
    }
    
    public static string SalesOrder(OperacionComercial__c OC)
    {
        String fechaActivacion;
        String fechaCreacionOpCom;

        Time myTime = Time.newInstance(0, 0, 0, 0); 
        Datetime dt = system.now();
        Datetime fcoc; 
        String formattedDt;
        String formattedDt2;
        if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan' || OC.TOPP__r.TipodeOperacionporplan__c=='Cambio Número' || OC.TOPP__r.TipodeOperacionporplan__c=='Adición SVA' || OC.TOPP__r.TipodeOperacionporplan__c=='Retiro SVA'){  // Cambio Plan   PVTA LRPA - 26-11-2015
        	dt=DateTime.newInstance(OC.FechaInicioReconexion__c,myTime);
        }
        else if(OC.TOPP__r.TipodeOperacionporplan__c!='Venta Equipos' && OC.TOPP__r.TipodeOperacionporplan__c!='Cambio de Plan' ){
            dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
            fcoc =DateTime.newInstance(OC.fechadeActivacion__c,myTime);
        }

        formattedDt         = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        formattedDt2        = dt.format('MM/dd/yyyy hh:mm:ss');
        fechaActivacion     = formattedDt;  //?? colocar fecha correcta
        fechaCreacionOpCom  = formattedDt; //?? colocar fecha correcta
                        
        tramiteLTE tr = new tramiteLTE(Oc); // calcular OrderType, OrderSubtype

        string xml='';           
            xml+='<SalesOrder>';
                xml+='<OrderDateTime>'+fechaCreacionOpCom+'</OrderDateTime>';       //2015-06-27T12:13:55-05:00 
                xml+='<DeliveryDateTime>'+fechaActivacion+'</DeliveryDateTime>';    // 2015-07-01T00:00:00-05:00 
                xml+='<TypeCode>'+tr.OrderSubtype+'</TypeCode>';                    
                xml+='<FulfilmentPriorityCode>Medium</FulfilmentPriorityCode>';
                xml+='<FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>';
                xml+='<StatusCode>En Facturación</StatusCode>';
            xml+='</SalesOrder>';                      
        return xml;
    }
    public static string BusinessReference(OperacionComercial__c OC) // Se mandaran estos valores Default
    {
        string xml='';            
            xml+='<BusinessReference>';
                xml+='<Id>0-R9NH</Id>';
                xml+='<ComponentId>0-R9NH</ComponentId>';
                xml+='<ApplicationObjectKeyId>0-R9NH</ApplicationObjectKeyId>';
            xml+='</BusinessReference>';                        
            return xml;
    }
    
    public static string CustomerPartyAccount(OperacionComercial__c OC, Contact repLegal)
    {
        String ciudad	      ='';           
        String departamento	  ='';
        String direccion      ='';
        String codigodane     ='';
        String codigoDaneDpto ='';

        /*string ciudad         =   OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
        string departamento     =   OC.CuentaCliente__r.Departamento__c!=null?OC.CuentaCliente__r.Departamento__c:'';
        string direccion        =   OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
        string codigodane       =   OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
        String codigoDaneDpto   =   OC.CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c:'';*/
               
        if(OC.TOPP__r.TipodeOperacionporplan__c=='Venta Equipos' ){//INI14505-SR-Para venta equipo enviar datos direccion de facturación desde la Legalización 
        	ciudad           =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name:'';
        	departamento     =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name:'';
        	direccion        =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c:'';           
        	codigodane       =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
        	codigoDaneDpto   =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c:'';   
        }else{
	        ciudad           =   OC.CuentaFacturacion__r.Ciudad__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Name:'';
    	    departamento     =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name:'';
        	// Se hace ajuste para cambio de campo direcccion LTE_DireccionFacturacion__c --> DirCorresp__c LRPA-19-11-2015
        	direccion        =   OC.CuentaFacturacion__r.DirCorresp__c!=null?OC.CuentaFacturacion__r.DirCorresp__c:'';           
         	codigodane       =   OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
         	codigoDaneDpto   =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c:'';         
        } 
        string indicativo       =   oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
        string tipodoc          =   OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
        string numero           =   OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
        
        string repLegalTipodedocumento = '';
        string repLegalNumerodeIdentificacion = '';
        string replegalFirstName='';
        string replegalLastName='';
        if(repLegal!=null){
             replegalFirstName              =   repLegal.FirstName!=null?repLegal.FirstName:'';
             replegalLastName               =   repLegal.LastName!=null?repLegal.LastName:'';   
             repLegalTipodedocumento        =   repLegal.Tipodedocumento__c;
             repLegalNumerodeIdentificacion =   repLegal.NumerodeIdentificacion__c;
        }
        string xml='';
           
           xml='<CustomerPartyAccount>';
                xml+='<Identification>';
                    xml+='<ID>'+oc.cuentaCliente__r.id+'</ID>';
                    xml+='<BusinessComponentID>'+oc.cuentaCliente__r.id+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+oc.cuentaCliente__r.id+'</ApplicationObjectKeyID>';
                xml+='</Identification>';
                xml+='<Name>'+normalizarString(oc.cuentaCliente__r.Name)+'</Name>';
                xml+='<Address>';
                    xml+='<Identification>';
                        xml+='<ID>'+oc.cuentaCliente__r.id+'</ID>';
                        xml+='<BusinessComponentID>'+oc.cuentaCliente__r.id+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+oc.cuentaCliente__r.id+'</ApplicationObjectKeyID>';
                    xml+='</Identification>';
                    xml+='<LineOne>'+direccion+'</LineOne>';
                    xml+='<CityName>'+normalizarString(ciudad)+'</CityName>';
                    xml+='<StateName>'+departamento+'</StateName>';
                    xml+='<CountryCode/>';
                    xml+='<CountryName/>';
                    xml+='<GisID/>';
                    xml+='<Latitude/>';
                    xml+='<Longitude/>';
                    xml+='<CityCode>'+codigodane+'</CityCode>';
                    xml+='<StateCode>'+codigoDaneDpto+'</StateCode>';
                    xml+='<PurposeCode/>';
                    xml+='<Technology>';
                        xml+='<Type/>';
                        xml+='<CoverageType/>';
                        xml+='<CoverageIndicator>false</CoverageIndicator>';
                        xml+='<CoverageName/>';
                        xml+='<Zone/>';
                    xml+='</Technology>';
                xml+='</Address>';
                xml+='<ContactPerson>'; //?? preguntar a SOL cual es el contacto que es  representante legal
                    xml+='<FirstName>'+normalizarString(replegalFirstName)+'</FirstName>';
                    xml+='<FamilyName>'+normalizarString(replegalLastName)+'</FamilyName>';
                    xml+='<CompleteNumber>'+repLegalTipodedocumento+' '+repLegalNumerodeIdentificacion+'</CompleteNumber>';
                xml+='</ContactPerson>';
                xml+='<TypeCode>JURIDICO</TypeCode>';
                xml+='<Custom>';
                    xml+='<DocumentType>'+tipodoc+'</DocumentType>'; 
                    xml+='<DocumentNumber>'+numero+'</DocumentNumber>';
                    //xml=xml+'<DocumentType>CC</DocumentType>';
                    //xml=xml+'<DocumentNumber>94537391</DocumentNumber>';
                xml+='</Custom>';
            xml+='</CustomerPartyAccount>';
 
                       
            return xml;
    }
    
public static string Custom(OperacionComercial__c OC)
{
    string xml='';
    string tipo = '';
    tramiteLTE tr = new tramiteLTE(Oc); // calcular OrderType, OrderSubtype
     xml+='<Custom>';
        xml+='<OrderSubType>'+tr.OrderSubtype+'</OrderSubType>';
        xml+='<SignedDocumentIndicator>true</SignedDocumentIndicator>';
     xml+='</Custom>';
    return xml;
}

public static string PartyIdentification(OperacionComercial__c OC)
{
    string xml='';
            xml+='<PartyIdentification>';
                xml+='<ID>1-1BW0C</ID>';
                xml+='<BusinessComponentID>1-1BW0C</BusinessComponentID>';
                xml+='<ApplicationObjectKeyID>1-1BW0C</ApplicationObjectKeyID>';
            xml+='</PartyIdentification>';
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



//se debe alimentar de los planes del plan homologado de REVCHAIN
public static string SalesOrderLine(OperacionComercial__c OC,LTE_Servicios_adicionales__c objServAdic)
{
        /*string ciudad         =   OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
        string departamento     =   OC.CuentaCliente__r.Departamento__c!=null?OC.CuentaCliente__r.Departamento__c:'';
        string direccion        =   OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
        string codigodane       =   OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
        String codigoDaneDpto   =   OC.CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c:'';
        */
        
        string ciudad           =   OC.CuentaFacturacion__r.Ciudad__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Name:'';
        string departamento     =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name:'';
        // Se hace ajuste para cambio de campo direcccion LTE_DireccionFacturacion__c --> DirCorresp__c LRPA-19-11-2015
        string direccion        =   OC.CuentaFacturacion__r.DirCorresp__c!=null?OC.CuentaFacturacion__r.DirCorresp__c:'';           
        string codigodane       =   OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
        String codigoDaneDpto   =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c:'';         
        
        string indicativo       =   oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
        string tipodoc          =   OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
        string numero           =   OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
        
        Time myTime = Time.newInstance(0, 0, 0, 0); 
        Datetime dt = system.now();
        String formattedDt;
        String formattedDt2;
        string externalServiceId = OC.Activo__r.Name;
        
        // Si el servicio es migrado, toma el id de migracion lrpa 1/10/2015 idSiebel
        if(OC.Activo__r.Esmigrado__c==true) {
            externalServiceId=OC.Activo__r.LTE_IdSiebel__c;  
        }
        
        
        string itemreferenceName = 'LTE';
        
        
        if(oc.TOPP__r.TipodeOperacionporplan__c =='Venta' || OC.TOPP__r.TipodeOperacionporplan__c=='Retiro'){ // PVTA LRPA - 26-11-2015
            dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
        }else if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan'){  		// Cambio Plan  PVTA LRPA - 26-11-2015)
        	dt=DateTime.newInstance(OC.FechaInicioReconexion__c,myTime); 		// Cambio Plan  PVTA LRPA - 26-11-2015)
        	
        	// Identificar si el cambio de plan es  PrePos/PosPos/PosPre. // Cambio Plan  PVTA LRPA - 26-11-2015)
        	//estatic_tipoCambio=identificarTipoCambioPlan(oc.Activo__r.Plan__r.LTE_TipoControl__c, oc.Activo__r.PlanReferenciaAnterior__c);
        	estatic_tipoCambio=identificarTipoCambioPlan(oc.Activo__r.Plan__r.LTE_TipoControl__c, oc.PlanAnterior__c);
        	
        	
        	
        }else if(OC.TOPP__r.TipodeOperacionporplan__c   ==  'Renovación' || OC.TOPP__r.TipodeOperacionporplan__c ==  'Reposición' || OC.TOPP__r.TipodeOperacionporplan__c=='Venta Equipos'){
            externalServiceId='FACT-'+Oc.Legalizacion__r.LTE_NFacturaVenta__c;
            itemreferenceName = 'Equipos LTE';
        }
        else if(OC.TOPP__r.TipodeOperacionporplan__c   ==  'Cambio Número' || OC.TOPP__r.TipodeOperacionporplan__c=='Adición SVA' || OC.TOPP__r.TipodeOperacionporplan__c=='Retiro SVA'){ // Validación para cambio de Número - AG 2016-02-09 
        	dt=DateTime.newInstance(OC.FechaInicioReconexion__c,myTime);
        }
        formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
                        

            string xml='';
            xml+='<SalesOrderLine>';
                xml+='<Identification>';
                    xml+='<ID>'+objServAdic.Id+'</ID>';
                    xml+='<BusinessComponentID>'+objServAdic.Id+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+objServAdic.Id+'</ApplicationObjectKeyID>';
                xml+='</Identification>';
                xml+='<OrderQuantity>1</OrderQuantity>';
                
                // calular el ActionCode
                if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan'){
                	if(estatic_tipoCambio=='PosPre'){
                		xml+='<ServiceActionCode>Delete</ServiceActionCode>';  
                	}
                	else if(estatic_tipoCambio=='PrePos'){
                		xml+='<ServiceActionCode>Add</ServiceActionCode>';
                	}
                	else{
                		xml+='<ServiceActionCode>' + objServAdic.LTE_ServiceActionCode__c + '</ServiceActionCode>';
                	}
                }else{
                	xml+='<ServiceActionCode>' + objServAdic.LTE_ServiceActionCode__c + '</ServiceActionCode>';                 	
                }
                xml+='<FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>';
                xml+='<ParentSalesOrderLineIdentification>';
                    xml+='<ID/>';
                    xml+='<BusinessComponentID/>';
                    xml+='<ApplicationObjectKeyID/>';
                xml+='</ParentSalesOrderLineIdentification>';
                xml+='<RootParentSalesOrderLineIdentification>';
                    xml+='<ID>'+objServAdic.Id+'</ID>';
                    xml+='<BusinessComponentID>'+objServAdic.Id+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+objServAdic.Id+'</ApplicationObjectKeyID>';
                xml+='</RootParentSalesOrderLineIdentification>';
                xml+='<StatusCode>Orden Cumplida</StatusCode>';
                xml+='<ServiceAddress>';
                    xml+='<Identification>';
                        xml+='<ID>'+oc.cuentaCliente__r.id+'</ID>'; //?? Confirmar este ID
                        xml+='<BusinessComponentID>'+oc.cuentaCliente__r.id+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+oc.cuentaCliente__r.id+'</ApplicationObjectKeyID>';
                    xml+='</Identification>';
                    xml+='<LineOne>'+direccion+'</LineOne>';
                    xml+='<CityName>'+normalizarString(ciudad)+'</CityName>';
                    xml+='<StateName>'+normalizarString(departamento)+'</StateName>';
                    xml+='<CountryCode/>';
                    xml+='<CountryName>Colombia</CountryName>';
                    xml+='<GisID/>';
                    xml+='<Latitude/>';
                    xml+='<Longitude/>';
                    xml+='<CityCode>'+codigodane+'</CityCode>';
                    xml+='<StateCode>'+codigoDaneDpto+'</StateCode>';
                    xml+='<PurposeCode/>';
                    xml+='<Technology>';
                        xml+='<Type/>';
                        xml+='<CoverageType/>';
                        xml+='<CoverageIndicator>false</CoverageIndicator>';
                        xml+='<CoverageName/>';
                        xml+='<Zone/>';
                    xml+='</Technology>';
                xml+='</ServiceAddress>';
                xml+='<ItemReference>';
                    xml+='<ItemIdentification>';
                        xml+='<ID>'+objServAdic.LTE_ItemIdentification__c+'</ID>';
                        xml+='<BusinessComponentID>'+objServAdic.LTE_ItemIdentification__c+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+objServAdic.LTE_ItemIdentification__c+'</ApplicationObjectKeyID>';
                    xml+='</ItemIdentification>';
                    xml+='<Name>'+itemreferenceName+'</Name>';
                    xml+='<ServiceIndicator>'+objServAdic.LTE_ServiceIndicator__c+'</ServiceIndicator>';
                    //xml+='<TypeCode>'+objServAdic.LTE_TypeCode__c+'</TypeCode>';   ??
                    xml+='<TypeCode>LTE</TypeCode>';
                    xml+='<NetworkIndicator>'+objServAdic.LTE_NetworkIndicator__c+'</NetworkIndicator>'; //??
                    //xml+='<NetworkIndicator>false</NetworkIndicator>'; //??
                    xml+='<PrimaryClassificationCode>'+objServAdic.LTE_PrimaryClassificationCode__c+'</PrimaryClassificationCode>';
                    xml+='<ExternalServiceId>'+externalServiceId+'</ExternalServiceId>';
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
                        xml+='<Reference/>';
                        xml+='<Technology>';
                            xml+='<Type/>';
                            xml+='<CoverageType/>';
                            xml+='<CoverageIndicator>false</CoverageIndicator>';
                            xml+='<CoverageName/>';
                            xml+='<Zone/>';
                        xml+='</Technology>';
                    xml+='</ShipTo>';
                xml+='</SalesOrderSchedule>';
                xml+='<OwnerPartyReference>';
                    xml+='<ID>'+objServAdic.Id+'</ID>';
                    xml+='<BusinessComponentID>'+objServAdic.Id+'</BusinessComponentID>';
                    xml+='<ApplicationObjectKeyID>'+objServAdic.Id+'</ApplicationObjectKeyID>';
                xml+='</OwnerPartyReference>';
                xml+='<ScheduleOrderIndicator>true</ScheduleOrderIndicator>';
               system.debug('xml-parcial->'+xml);
            
    return xml;
}

// Identificar si el cambio de plan es paso desde Pre a Post y demas opciones
// Posible salida: PrePos/PosPos/PosPre. // PVTA LRPA - 26-11-2015
public static String identificarTipoCambioPlan(String TipoControlNuevoPlan, String nombrePlanAnterior){
	string cadenaSalida='PosPos';
	if(nombrePlanAnterior != null && nombrePlanAnterior.Contains('||')){// JDUR 2016/01/15
		String[] nombreSeparado = nombrePlanAnterior.Split('\\|\\|');
		nombrePlanAnterior = nombreSeparado[0];
	}
	system.debug('## estatic_tipoCambio-Entra->'+estatic_tipoCambio);
	system.debug('## TipoControlNuevoPlan-Entra->'+TipoControlNuevoPlan);
	system.debug('## nombrePlanAnterior-Entra->'+nombrePlanAnterior);
	if (estatic_tipoCambio==null){
		list <Planes__c> planAnterior = [SELECT LTE_TipoControl__c FROM Planes__c WHERE Name =:nombrePlanAnterior];
		
		if(planAnterior.get(0).LTE_TipoControl__c=='Prepago'){
			cadenaSalida='PrePos';
		}else{
			if(TipoControlNuevoPlan=='Prepago'){
				cadenaSalida='PosPre';	
			}else{
				cadenaSalida='PosPos';
			}
		}
	}else{
		cadenaSalida=estatic_tipoCambio;
	}
	system.debug('## cadenaSalida-Entra->'+cadenaSalida);
	return cadenaSalida;
}
public static string SupplementaryInfo(OperacionComercial__c OC,LTE_Servicios_adicionales__c objServAdic,list<LTE_SpecificationGroupXA__c> lstXas, String IdSalesOrderLine)
{
        Time myTime = Time.newInstance(0, 0, 0, 0); 
        Datetime dt = system.now();
        String formattedDt;
        String formattedDt2;
        if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan'){  			// Tomar Fecha efectiva Cambio Plan  PVTA LRPA - 26-11-2015)
    		dt=DateTime.newInstance(OC.FechaInicioReconexion__c,myTime); 		// Tomar Fecha efectiva Cambio Plan  PVTA LRPA - 26-11-2015)
    		// Identificar si el cambio de plan es  PrePos/PosPos/PosPre. // Cambio Plan  PVTA LRPA - 26-11-2015)
    	   // estatic_tipoCambio=identificarTipoCambioPlan(oc.Activo__r.Plan__r.LTE_TipoControl__c, oc.Activo__r.PlanReferenciaAnterior__c); 	
    	     estatic_tipoCambio=identificarTipoCambioPlan(oc.Activo__r.Plan__r.LTE_TipoControl__c, oc.PlanAnterior__c);
        	    
        }
        else if( OC.TOPP__r.TipodeOperacionporplan__c=='Cambio Número' || OC.TOPP__r.TipodeOperacionporplan__c=='Adición SVA' || OC.TOPP__r.TipodeOperacionporplan__c=='Retiro SVA'){ //AG 03-02-2016 Validación para el cambio de número
        	dt=DateTime.newInstance(OC.FechaInicioReconexion__c,myTime);
        }
        else if(OC.TOPP__r.Name!=System.label.Venta_Equipos_TELEFONIA_MOVIL_LTE && OC.TOPP__r.TipodeOperacionporplan__c!='Cambio de Plan'){
            dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
        }
        
        formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
                        
        string nombreItemReference='';
        string statusCode='';   
        // Identificar si El supplementary Info tiene atributos  RVC PLN' o RVC FEAT
        Boolean senalStatusCode=false;
        for(LTE_SpecificationGroupXA__c objXas: lstXas)
        {
            if(objXas.LTE_ServiciosAdicionales__c==objServAdic.Id){
                if(objXas.Name.Contains('RVC PLN')||objXas.Name.Contains('RVC FEAT')){ 
                    if(statusCode==null){
                        statusCode+=objXas.LTE_Value__c;
                    }else{
                        statusCode+='|'+objXas.LTE_Value__c;
                    }
                }
            
	            if(objXas.Name.Contains('RVC FEAT')){
	                nombreItemReference=objXas.LTE_Value__c;
	            }
            }
            
        }
         
        statusCode+=OC.Activo__c+'|'+OC.Activo__c+'|'+senalStatusCode+statusCode; 
     
                            
        tramiteLTE tr = new tramiteLTE(Oc); // calcular OrderType, OrderSubtype
         //xml+='<TypeCode>'+tr.SubOrderType+'</TypeCode>';  

        //tr.OrderType 
        //tr.OrderSubtype
        //tr.ServiceActionCode
        //tr.SubOrderType 
        //tr.NoEnviarLiteItem = new list<string>();
        
        //INI14505-SR-Para Venta Equipo enviar external del activo
    	String ExternalServiceId='';    
 		if( OC.TOPP__r.TipodeOperacionporplan__c=='Venta Equipos'){ //INI14505-SR-Para Venta Equipo enviar external del activo
        	ExternalServiceId = OC.Activo__r.Name;
        }
    	else{
        	ExternalServiceId = objServAdic.Id;
    	}


     string xml='';
     xml+='<SupplementaryInfo>';
                    xml+='<Identification>';
                        xml+='<ID>'+objServAdic.Id+'</ID>';
                        xml+='<BusinessComponentID>'+objServAdic.Id+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+objServAdic.Id+'</ApplicationObjectKeyID>';
                    xml+='</Identification>';
                    xml+='<OrderQuantity>1</OrderQuantity>';
                    // calular el ActionCode
	                if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan'){
	                	if(estatic_tipoCambio=='PosPre'){
	                		xml+='<ServiceActionCode>Delete</ServiceActionCode>';  
	                	}
	                	else if(estatic_tipoCambio=='PrePos'){
	                		xml+='<ServiceActionCode>Add</ServiceActionCode>';
	                	}
	                	else{
	                		if(objServAdic.LTE_ServiceActionCode__c=='DELETE'){
	                			xml+='<ServiceActionCode>Delete</ServiceActionCode>';
	                		}else if(objServAdic.LTE_ServiceActionCode__c=='ADD'){
	                			xml+='<ServiceActionCode>Add</ServiceActionCode>';
	                		}else{
	                			xml+='<ServiceActionCode>' + objServAdic.LTE_ServiceActionCode__c + '</ServiceActionCode>';
	                		}
	                		
	                	}
	                	 	
	                }else{
	                	xml+='<ServiceActionCode>' + objServAdic.LTE_ServiceActionCode__c + '</ServiceActionCode>';                 	
	                }
          
                    xml+='<FulfilmentModeCode>UPDFINAL</FulfilmentModeCode>';
                    xml+='<ParentSalesOrderLineIdentification>';
                        xml+='<ID>'+IdSalesOrderLine+'</ID>';
                        xml+='<BusinessComponentID>'+IdSalesOrderLine+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+IdSalesOrderLine+'</ApplicationObjectKeyID>';
                    xml+='</ParentSalesOrderLineIdentification>';
                    xml+='<RootParentSalesOrderLineIdentification>';
                        xml+='<ID>'+IdSalesOrderLine+'</ID>';
                        xml+='<BusinessComponentID>'+IdSalesOrderLine+'</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>'+IdSalesOrderLine+'</ApplicationObjectKeyID>';
                    xml+='</RootParentSalesOrderLineIdentification>';
                    xml+='<StatusCode>'+statusCode+'</StatusCode>';
                    xml+='<ServiceAddress/>';
                    xml+='<ItemReference>';
                        xml+='<ItemIdentification>';
                            xml+='<ID>'+objServAdic.LTE_ItemIdentification__c+'</ID>';
                            xml+='<BusinessComponentID>'+objServAdic.LTE_ItemIdentification__c+'</BusinessComponentID>';
                            xml+='<ApplicationObjectKeyID>'+objServAdic.LTE_ItemIdentification__c+'</ApplicationObjectKeyID>';
                        xml+='</ItemIdentification>';
                        xml+='<Name>'+normalizarString(nombreItemReference)+'</Name>';
                        xml+='<ServiceIndicator>'+objServAdic.LTE_ServiceIndicator__c+'</ServiceIndicator>';
                       // xml+='<TypeCode>'+objServAdic.LTE_TypeCode__c+'</TypeCode>'; 
                        xml+='<TypeCode>LTE</TypeCode>';
                        xml+='<NetworkIndicator>'+objServAdic.LTE_NetworkIndicator__c+'</NetworkIndicator>';
                        xml+='<PrimaryClassificationCode>'+objServAdic.LTE_PrimaryClassificationCode__c+'</PrimaryClassificationCode>';
                        xml+='<ExternalServiceId>'+ExternalServiceId+'</ExternalServiceId>';//INI14505-SR-Para Venta Equipo enviar external del activo
                    xml+='</ItemReference>';
                    xml+='<SalesOrderSchedule>';
                        xml+='<RequestedDeliveryDate>'+formattedDt+'</RequestedDeliveryDate>';
                        xml+='<ExpectedDeliveryDate>'+formattedDt+'</ExpectedDeliveryDate>';
                        xml+='<ShipTo/>';
                    xml+='</SalesOrderSchedule>';
                    xml+='<OwnerPartyReference>';
                        xml+='<ID>A</ID>';
                        xml+='<BusinessComponentID>A</BusinessComponentID>';
                        xml+='<ApplicationObjectKeyID>A</ApplicationObjectKeyID>';
                    xml+='</OwnerPartyReference>';
                    xml+='<ScheduleOrderIndicator>true</ScheduleOrderIndicator>';
                    xml+='<OrderSubType/>';
                    xml+='<SignedDocumentsIndicator/>';
                   xml+='<StartDateTime>'+formattedDt2+'</StartDateTime>';
                              
    return xml;
}
public static string parameter(string nombre, string valor)
{
    string xml='';
    system.debug('nombre-A->'+nombre);
    system.debug('valor-A->'+valor);
    if(nombre=='Index DS'|| nombre=='Index desc') valor = '\''+valor+'\'';
    system.debug('nombre-D->'+nombre);
    system.debug('valor-D->'+valor);
    xml+='<Parameter>';
        xml+='<Name>'+nombre+'</Name>';
        xml+='<Value>'+valor+'</Value>';
    xml+='</Parameter>';
    system.debug('parameter-xml->'+xml);
    return xml;
    
}
public static string rateplan(string plan)
{
    string xml='';
    //string comilla = '\'';
          xml+=' <RatePlan>';
          system.debug('Nombre-rateplan-->'+plan);
          if(plan!=''){
                    plan=plan.replace('\'','');
                   xml+='<Name>\''+plan+'\'</Name>';  //??
          }else{
            // xml+='<Name>\'Plan Uso Otros Pre-tarificado LTE\'</Name>';  //??
          }
          xml+=' </RatePlan>';
          system.debug('xml-rateplan-->'+xml);
         return xml;
}



public static string DiscountsRetiro(list<LTE_SpecificationGroupXA__c> lstXas,LTE_Servicios_adicionales__c objSalesORderLine,ActivoETB__c objServicio)
{
    map<string,string> mapGetDuracionDescuento = new map<string,string>();
    
    for(LTE_SpecificationGroupXA__c objXa: lstXas)
    {
        mapGetDuracionDescuento.put(objXa.LTE_ServiciosAdicionales__r.Id+objXa.Name,objXa.LTE_Value__c);
    }
    
    string xml='';
    integer duracion_0=0;
    integer duracion_1=0;
    // tomar la duracion de cada descuento para luego enviarla en el sigueitne for
    for(LTE_SpecificationGroupXA__c objXa: lstXas)
    {
        if(objXa.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c ==objServicio.Id){
            if(objXa.Name.Equals('RVC DESCUENTO INICIAL') || objXa.Name.Equals('RVC DESCUENTO DOS') || objXa.Name.Equals('RVC DESCUENTO TRES')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
                
                if(objXa.Name.Equals('RVC DESCUENTO INICIAL') && mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION')!= null){
                    duracion_0=Integer.valueOf(mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION'));
                }
                if(objXa.Name.Equals('RVC DESCUENTO DOS') && mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION DOS')!=null){
                    duracion_1=Integer.valueOf(mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION DOS'));
                }

            }           
        }
        
    }
                    
    
    system.debug('duracion_0-->'+duracion_0);
    system.debug('duracion_1-->'+duracion_1);
    
    string duracion='';
    string descripcion='';
    for(LTE_SpecificationGroupXA__c objXa: lstXas)
    {
        duracion='0';
        if(objXa.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c ==objServicio.Id){
            if(objXa.Name.Equals('RVC DESCUENTO INICIAL') || objXa.Name.Equals('RVC DESCUENTO DOS') || objXa.Name.Equals('RVC DESCUENTO TRES')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
                
                if(objXa.Name.Equals('RVC DESCUENTO INICIAL')){
                    duracion=mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION');
                    descripcion='0';
                }else if(objXa.Name.Equals('RVC DESCUENTO DOS')){
                    duracion=mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION DOS');
                    descripcion=String.valueOf(duracion_0);
                }else{
                    descripcion=String.valueOf(duracion_0+duracion_1);  
                }
                xml+=discountsItem(objXa,duracion,descripcion);
            }           
        }
        
    }
        
    return xml;
}
    
public static string DiscountsAdicionSVA(list<LTE_SpecificationGroupXA__c> lstXas,LTE_Servicios_adicionales__c objSalesORderLine,OperacionComercial__c objOC)
{
    map<string,string> mapGetDuracionDescuento = new map<string,string>();
    
    for(LTE_SpecificationGroupXA__c objXa: lstXas)    
        mapGetDuracionDescuento.put(objXa.LTE_ServiciosAdicionales__r.Id+objXa.Name,objXa.LTE_Value__c);
        
    string xml='';
    integer duracion_0=0;
    integer duracion_1=0;
    
    for(LTE_SpecificationGroupXA__c objXa: lstXas)
    {
        if(objXa.LTE_ServiciosAdicionales__r.LTE_Operacion_Comercial_SVA__c ==objOC.Id){
            if(objXa.Name.Equals('RVC DESCUENTO INICIAL') || objXa.Name.Equals('RVC DESCUENTO DOS') || objXa.Name.Equals('RVC DESCUENTO TRES')){                 
                if(objXa.Name.Equals('RVC DESCUENTO INICIAL') && mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION')!= null)
                    duracion_0=Integer.valueOf(mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION'));
                
                if(objXa.Name.Equals('RVC DESCUENTO DOS') && mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION DOS')!=null)
                    duracion_1=Integer.valueOf(mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION DOS'));                
            }           
        }        
    }       
    system.debug('duracion_0-->'+duracion_0);
    system.debug('duracion_1-->'+duracion_1);
    
    string duracion='';
    string descripcion='';
    for(LTE_SpecificationGroupXA__c objXa: lstXas)
    {
        duracion='0';
        if(objXa.LTE_ServiciosAdicionales__r.LTE_Operacion_Comercial_SVA__c ==objOC.Id){
            if(objXa.Name.Equals('RVC DESCUENTO INICIAL') || objXa.Name.Equals('RVC DESCUENTO DOS') || objXa.Name.Equals('RVC DESCUENTO TRES')){                
                if(objXa.Name.Equals('RVC DESCUENTO INICIAL')){
                    duracion=mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION');
                    descripcion='0';
                }else if(objXa.Name.Equals('RVC DESCUENTO DOS')){
                    duracion=mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION DOS');
                    descripcion=String.valueOf(duracion_0);
                }else
                    descripcion=String.valueOf(duracion_0+duracion_1);  
                
                xml+=discountsItem(objXa,duracion,descripcion);
            }           
        }        
    }        
    return xml;
}

public static string Discounts(list<LTE_SpecificationGroupXA__c> lstXas,LTE_Servicios_adicionales__c objSalesORderLine,LTE_DetalleOferta__c     objDetOferta)
{
    
    map<string,integer> mapduracionXServicioAdicional = new map<string,integer>();

    map<string,string> mapGetDuracionDescuento = new map<string,string>();
    
    for(LTE_SpecificationGroupXA__c objXa: lstXas)
    {
        mapGetDuracionDescuento.put(objXa.LTE_ServiciosAdicionales__r.Id+objXa.Name,objXa.LTE_Value__c);
    }
    
    string xml='';
    string xmlDescuento_uno='';
    string xmlDescuento_dos='';
    string xmlDescuento_tres='';
    
    integer duracion_0=0;
    integer duracion_1=0;
    // tomar la duracion de cada descuento para luego enviarla en el sigueitne for
    for(LTE_SpecificationGroupXA__c objXa: lstXas)
    {
        if(objXa.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c ==objDetOferta.Id){
            if(objXa.Name.Equals('RVC DESCUENTO INICIAL') || objXa.Name.Equals('RVC DESCUENTO DOS') || objXa.Name.Equals('RVC DESCUENTO TRES')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
                
                if(objXa.Name.Equals('RVC DESCUENTO INICIAL') && mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION')!= null){
                    duracion_0=Integer.valueOf(mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION'));
                    mapduracionXServicioAdicional.put(objXa.LTE_ServiciosAdicionales__r.Id+'duracion_0',duracion_0);
                    
                }
                if(objXa.Name.Equals('RVC DESCUENTO DOS') && mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION DOS')!=null){
                    duracion_1=Integer.valueOf(mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION DOS'));
                    mapduracionXServicioAdicional.put(objXa.LTE_ServiciosAdicionales__r.Id+'duracion_1',duracion_1);
                }

            }           
        }
        
    }
                    
    
    system.debug('duracion_0-->'+duracion_0);
    system.debug('duracion_1-->'+duracion_1);
    
    string duracion='';
    string descripcion='';
    integer operando1 =0;
    integer operando2 =0;
    integer total=0;
    
    
    for(LTE_SpecificationGroupXA__c objXa: lstXas)
    {
        duracion='0';
        if(objXa.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c ==objDetOferta.Id){
            if(objXa.Name.Equals('RVC DESCUENTO INICIAL') || objXa.Name.Equals('RVC DESCUENTO DOS') || objXa.Name.Equals('RVC DESCUENTO TRES')){ // solo se tienen en cuenta los parametros de facturacion cuyo Name contema la cadena RVC PARM
                
                if(objXa.Name.Equals('RVC DESCUENTO INICIAL')){
                    duracion=mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION');
                    descripcion='0';
                }else if(objXa.Name.Equals('RVC DESCUENTO DOS')){
                    duracion=mapGetDuracionDescuento.get(objXa.LTE_ServiciosAdicionales__r.Id+'RVC DURACION DOS');
                    //descripcion=String.valueOf(duracion_0);
                    descripcion=String.valueOf(mapduracionXServicioAdicional.get(objXa.LTE_ServiciosAdicionales__r.Id+'duracion_0'));
                    if(descripcion==null) descripcion='0';
                }else{
                    //descripcion=String.valueOf(duracion_0+duracion_1);    
                    operando1=mapduracionXServicioAdicional.get(objXa.LTE_ServiciosAdicionales__r.Id+'duracion_0');
                    if(operando1!= null) total+=operando1;
                    
                    operando2=mapduracionXServicioAdicional.get(objXa.LTE_ServiciosAdicionales__r.Id+'duracion_1');
                    if(operando2!= null) total+=operando2;
                    
                    system.debug('total-->'+total);
                    descripcion=String.valueOf(total);
                    system.debug('descripcion-->'+descripcion);

                    total = 0; 
                }
                if(objXa.Name.Equals('RVC DESCUENTO INICIAL'))      xmlDescuento_uno    +=  discountsItem(objXa,duracion,descripcion);
                if(objXa.Name.Equals('RVC DESCUENTO DOS'))          xmlDescuento_dos    +=  discountsItem(objXa,duracion,descripcion);
                if(objXa.Name.Equals('RVC DESCUENTO TRES'))         xmlDescuento_tres   +=  discountsItem(objXa,duracion,descripcion);
                //xml+=discountsItem(objXa,duracion,descripcion);
            }           
        }
        
    }
    if(xmlDescuento_uno!='')    xml= xml+xmlDescuento_uno;
    if(xmlDescuento_dos!='')    xml= xml+xmlDescuento_dos;
    if(xmlDescuento_tres!='')   xml= xml+xmlDescuento_tres;

    return xml;
}
        
public static string discountsItem(LTE_SpecificationGroupXA__c objXa,string duracion,string descripcion)
{
    string valDesc = objXa.LTE_Value__c;
    if(valDesc!=null){
        valDesc=valDesc+'.0000';
    }else{
        valDesc='';
    }
    system.debug('descripcion-xy->'+descripcion);
    string xml='';
          xml+='<Discount>';
                        xml+='<Feature>';
                           xml+=' <TypeName>'+objXa.name+'|'+objXa.LTE_ServiciosAdicionales__r.Id+'</TypeName>';
                           xml+=' <Parameter>';
                               xml+=' <Name>'+objXa.Name+'</Name>';
                                xml+='<Value>'+valDesc+'</Value>';
                                xml+='<Description>'+descripcion+'</Description>';
                                xml+='<Validity>'+duracion+'</Validity>';
                            xml+='</Parameter>';
                        xml+='</Feature>';
         xml+='</Discount>';
    return xml;
}


public static string connection(OperacionComercial__c OC)
{
        Time myTime = Time.newInstance(0, 0, 0, 0); 
        Datetime dt = system.now();
        String formattedDt;
        String formattedDt2;
        if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan' || OC.TOPP__r.TipodeOperacionporplan__c=='Cambio Número' || OC.TOPP__r.TipodeOperacionporplan__c=='Adición SVA' || OC.TOPP__r.TipodeOperacionporplan__c=='Retiro SVA'){  			// Tomar Fecha efectiva Cambio Plan  PVTA LRPA - 26-11-2015)
        	dt=DateTime.newInstance(OC.FechaInicioReconexion__c,myTime); 		// Tomar Fecha efectiva Cambio Plan  PVTA LRPA - 26-11-2015)
        }
        else if(OC.TOPP__r.Name!=System.label.Venta_Equipos_TELEFONIA_MOVIL_LTE && OC.TOPP__r.TipodeOperacionporplan__c!='Cambio de Plan'){
            dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
        }  
        formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
                        
    string xml='';
    //LEM validar si es numero de conexion o id de servicio
    string connectionnumber='';
    xml+='<StartDateTime>'+formattedDt2+'</StartDateTime>';
    xml+='<Connection>';
    if(OC.TOPP__r.TipodeOperacionporplan__c !=  'Renovación' && OC.TOPP__r.TipodeOperacionporplan__c    !=  'Reposición'  ){
        xml+='<ConnectionNumber>'+OC.NumeroConexion__c+'</ConnectionNumber>'; //??
    }
    xml+='</Connection>';
                
    return xml;
}


public static string AltKey(string IdXa,string nombre,string valor)
{
	//Recorta nombre de la cuenta cliente a 40 caracteres si su longitud es mayor
    if(nombre.equalsIgnoreCase('ETBLN') && valor.length()>40){
       valor = valor.SubString(0,40);
    }
    
    string xml='';
    xml+='<AltKey>';
                    xml+='<Id>'+IdXa+'</Id>';
                    xml+='<AltKeyName>'+nombre+'</AltKeyName>';
                    xml+='<AltKeyValue>'+valor+'</AltKeyValue>';
    xml+='</AltKey>';
    return xml;
}

public static string getAllSpecificationGroupXA(OperacionComercial__c OC,LTE_DetalleOferta__c   objDetOferta,list<LTE_SpecificationGroupXA__c> lstXas,ActivoETB__c objServicio, String IdSalesOrderLine){
    string xml = '';
    system.debug('objServicio-getAllSpecificationGroupXA->'+objServicio);
    system.debug('OC.TOPP__r.Name->'+OC.TOPP__r.Name);
    if(OC.TOPP__r.TipodeOperacionporplan__c =='Venta'  ){ // Tipo de operacion diferente a Venta de Equipos
        xml=getSpecificationGroupXA( lstXas,OC,objDetOferta,objServicio, IdSalesOrderLine);
    }else if(OC.TOPP__r.TipodeOperacionporplan__c   ==  'Venta Equipos' || OC.TOPP__r.TipodeOperacionporplan__c=='Retiro'){
        xml=getSpecificationGroupXAVentaEquipos( lstXas,OC,objDetOferta,objServicio);
    }else if(OC.TOPP__r.TipodeOperacionporplan__c   ==  'Renovación' || OC.TOPP__r.TipodeOperacionporplan__c    ==  'Reposición'  ){
        xml=getSpecificationGroupXARepoReno( lstXas,OC,objDetOferta,objServicio, IdSalesOrderLine);
    }else if(OC.TOPP__r.TipodeOperacionporplan__c   ==  'Cambio de Plan' ){  // PVTA LRPA - 26-11-2015
        xml=getSpecificationGroupXAcambioPlan( lstXas,OC,objDetOferta,objServicio,IdSalesOrderLine);
    }else if(OC.TOPP__r.TipodeOperacionporplan__c   ==  'Cambio Número' ){ // AG 2016-02-09
    	xml=getSpecificationGroupXAcambioNumero( lstXas,OC,objDetOferta,objServicio);
    }else if(OC.TOPP__r.TipodeOperacionporplan__c   ==  'Suspensión' ||  OC.TOPP__r.TipodeOperacionporplan__c   ==  'Reconexión'){ // AG 2016-02-09
    	xml=getSpecificationGroupXAcambioNumero(lstXas,OC,objDetOferta,objServicio);
    }else if(OC.TOPP__r.TipodeOperacionporplan__c   ==  'Adición SVA' ||  OC.TOPP__r.TipodeOperacionporplan__c   ==  'Retiro SVA'){ // AG 2016-02-09
    	xml=getSpecificationGroupXAcambioNumero(lstXas,OC,objDetOferta,objServicio);
    }
    
    
    return  xml; 
}

public static string getSpecificationGroupXARepoReno(list<LTE_SpecificationGroupXA__c> itemXA,OperacionComercial__c OC,LTE_DetalleOferta__c     objDetOferta,ActivoETB__c objServicio, String IdSalesOrderLine) 
{

            if (itemXA.isEmpty()) {

                return  '<SpecificationGroupXA/>';
            }

            string xml = '';
            system.debug(itemXA.size());
            for (LTE_SpecificationGroupXA__c xa : itemXA) 
            {
                // solo se envian los que corresponde al SalesORderLine Padre de los SupplementaryInfo
                if(objDetOferta.id == xa.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c &&  xa.LTE_ServiciosAdicionales__c==  IdSalesOrderLine)
                {
                    //if(xa.Name !='RVC NOMBRE' && xa.Name !='RVC PLN'){
                    string valor=xa.LTE_Value__c;

                    xml += '<SpecificationGroupXA>'
                           + '<XAID>' + xa.Id + '</XAID>'
                           + '<ParentID>' + xa.LTE_ServiciosAdicionales__c + '</ParentID>'
                           + '<ID>' + xa.Id + '</ID>'
                           + '<ActionCode>' + (xa.LTE_ActionCode__c=='ADD'?'Add': xa.LTE_ActionCode__c)+ '</ActionCode>'
                           + '<Name>' + xa.Name + '</Name>'
                           + '<Value>' + xa.LTE_Value__c + '</Value>'
                           + '</SpecificationGroupXA>';
                    //}
                }
            }

            return xml;

}

// Generaa XA's de Cambio de Plan   // PVTA LRPA - 26-11-2015
public static string getSpecificationGroupXAcambioPlan(list<LTE_SpecificationGroupXA__c> itemXA, OperacionComercial__c OC, LTE_DetalleOferta__c objDetOferta, ActivoETB__c objServicio, String IdSalesOrderLine) 
{

            if (itemXA.isEmpty()) {

                return  '<SpecificationGroupXA/>';
            }

            string xml = '';
            system.debug(itemXA.size());
            for (LTE_SpecificationGroupXA__c xa : itemXA) 
            {
                if(objServicio.id == xa.LTE_ServiciosAdicionales__r.LTE_ServicioETB__c && xa.LTE_ParametroFacturacion__r.Objeto__c!='LTE_DetalleOferta__c')
                {
                    string valor=xa.LTE_Value__c;
    
                    system.debug(xa.LTE_ParametroFacturacion__r.Objeto__c+' '+xa.LTE_ParametroFacturacion__r.Campo__c);
                    if (xa.LTE_ParametroFacturacion__r.Objeto__c != null & xa.LTE_ParametroFacturacion__r.Campo__c != null) {
                        system.debug('xa-2->'+xa); 
                        system.debug('xa.LTE_ParametroFacturacion__r.Objeto__c-2->'+xa.LTE_ParametroFacturacion__r.Objeto__c);
                        if(OC.TOPP__r.TipodeOperacionporplan__c!='Cambio de Plan') {
                            valor=mapearCampo(xa.LTE_ParametroFacturacion__r.Objeto__c,xa.LTE_ParametroFacturacion__r.Campo__c, OC, objDetOferta,objServicio);
                        }
                        
                    }
                    //[AG:2016-02-19] Se incluye logica para excluir los XAs del producto principal cuando pasa de Pre a Pos
                    Boolean incluir = true;
    				String actionCodeXA = '';
    				if(estatic_tipoCambio=='PrePos'){
    					actionCodeXA = 'Add';
    					if(xa.LTE_ServiciosAdicionales__c != IdSalesOrderLine || (xa.Name=='METODO DE PAGO' && xa.LTE_Value__c=='PREPAGO'))
    						incluir = false;
    				}
    				else if(estatic_tipoCambio=='PosPre')
    					actionCodeXA = 'Delete';
    				else
    					actionCodeXA = (xa.LTE_ActionCode__c=='ADD'?'Add': xa.LTE_ActionCode__c);
        
        			if(incluir){
	                    xml += '<SpecificationGroupXA>'
	                           + '<XAID>' + xa.Id + '</XAID>'
	                           + '<ParentID>' + xa.LTE_ServiciosAdicionales__c + '</ParentID>'
	                           + '<ID>' + xa.Id + '</ID>'
	                           + '<ActionCode>' + actionCodeXA + '</ActionCode>'
	                           + '<Name>' + xa.Name + '</Name>'
	                           + '<Value>' + valor + '</Value>'
	                           + '</SpecificationGroupXA>';
        			}

                }
            }

            return xml;

}

// Generaa XA's de Cambio de Plan   // AG - 2016-02-09
public static string getSpecificationGroupXAcambioNumero(list<LTE_SpecificationGroupXA__c> itemXA,OperacionComercial__c OC,LTE_DetalleOferta__c     objDetOferta,ActivoETB__c objServicio) 
{

            if (itemXA.isEmpty()) {

                return  '<SpecificationGroupXA/>';
            }

            string xml = '';
            system.debug(itemXA.size());
            for (LTE_SpecificationGroupXA__c xa : itemXA) 
            {
                if(objServicio.id == xa.LTE_ServiciosAdicionales__r.LTE_ServicioETB__c && xa.LTE_ParametroFacturacion__r.Objeto__c!='LTE_DetalleOferta__c')
                {
                    string valor=xa.LTE_Value__c;
    
                    /*system.debug(xa.LTE_ParametroFacturacion__r.Objeto__c+' '+xa.LTE_ParametroFacturacion__r.Campo__c);
                    if (xa.LTE_ParametroFacturacion__r.Objeto__c != null & xa.LTE_ParametroFacturacion__r.Campo__c != null) {
                        system.debug('xa-2->'+xa); 
                        system.debug('xa.LTE_ParametroFacturacion__r.Objeto__c-2->'+xa.LTE_ParametroFacturacion__r.Objeto__c);
                        if(OC.TOPP__r.TipodeOperacionporplan__c!='Cambio de Plan') {
                            valor=mapearCampo(xa.LTE_ParametroFacturacion__r.Objeto__c,xa.LTE_ParametroFacturacion__r.Campo__c, OC, objDetOferta,objServicio);
                        }
                        
                    }*/
    
        
                    xml += '<SpecificationGroupXA>'
                           + '<XAID>' + xa.Id + '</XAID>'
                           + '<ParentID>' + xa.LTE_ServiciosAdicionales__c + '</ParentID>'
                           + '<ID>' + xa.Id + '</ID>'
                           + '<ActionCode>' + (xa.LTE_ActionCode__c=='ADD'?'Add': xa.LTE_ActionCode__c)+ '</ActionCode>'
                           + '<Name>' + xa.Name + '</Name>'
                           + '<Value>' + valor + '</Value>'
                           + '</SpecificationGroupXA>';

                }
            }

            return xml;

}

public static string getSpecificationGroupXAVentaEquipos(list<LTE_SpecificationGroupXA__c> itemXA,OperacionComercial__c OC,LTE_DetalleOferta__c     objDetOferta,ActivoETB__c objServicio) 
{

            if (itemXA.isEmpty()) {

                return  '<SpecificationGroupXA/>';
            }

            string xml = '';
            system.debug(itemXA.size());
            for (LTE_SpecificationGroupXA__c xa : itemXA) 
            {
                if(objServicio.id == xa.LTE_ServiciosAdicionales__r.LTE_ServicioETB__c && xa.LTE_ParametroFacturacion__r.Objeto__c!='LTE_DetalleOferta__c')
                {
                    string valor=xa.LTE_Value__c;
    
                    system.debug(xa.LTE_ParametroFacturacion__r.Objeto__c+' '+xa.LTE_ParametroFacturacion__r.Campo__c);
                    if (xa.LTE_ParametroFacturacion__r.Objeto__c != null & xa.LTE_ParametroFacturacion__r.Campo__c != null) {
                        system.debug('xa-2->'+xa); 
                        system.debug('xa.LTE_ParametroFacturacion__r.Objeto__c-2->'+xa.LTE_ParametroFacturacion__r.Objeto__c);
                        if(OC.TOPP__r.TipodeOperacionporplan__c!='Retiro') {
                            valor=mapearCampo(xa.LTE_ParametroFacturacion__r.Objeto__c,xa.LTE_ParametroFacturacion__r.Campo__c, OC, objDetOferta,objServicio);
                        }
                        
                    }
    
        
                    xml += '<SpecificationGroupXA>'
                           + '<XAID>' + xa.Id + '</XAID>'
                           + '<ParentID>' + xa.LTE_ServiciosAdicionales__c + '</ParentID>'
                           + '<ID>' + xa.Id + '</ID>'
                           + '<ActionCode>' + (xa.LTE_ActionCode__c=='ADD'?'Add': xa.LTE_ActionCode__c)+ '</ActionCode>'
                           + '<Name>' + xa.Name + '</Name>'
                           + '<Value>' + valor + '</Value>'
                           + '</SpecificationGroupXA>';

                }
            }

            return xml;

}

public static string getSpecificationGroupXA(list<LTE_SpecificationGroupXA__c> itemXA,OperacionComercial__c OC,LTE_DetalleOferta__c     objDetOferta,ActivoETB__c objServicio, String IdSalesOrderLine) 
{

            if (itemXA.isEmpty()) {

                return  '<SpecificationGroupXA/>';
            }

            string xml = '';
            system.debug(itemXA.size());
            for (LTE_SpecificationGroupXA__c xa : itemXA) 
            {
                // solo se envian los que corresponde al SalesORderLine Padre de los SupplementaryInfo
                if(objDetOferta.id == xa.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__c &&  xa.LTE_ServiciosAdicionales__c==  IdSalesOrderLine)
                {
                    //if(xa.Name !='RVC NOMBRE' && xa.Name !='RVC PLN'){
                    string valor=xa.LTE_Value__c;

                    xml += '<SpecificationGroupXA>'
                           + '<XAID>' + xa.Id + '</XAID>'
                           + '<ParentID>' + xa.LTE_ServiciosAdicionales__c + '</ParentID>'
                           + '<ID>' + xa.Id + '</ID>'
                           + '<ActionCode>' + (xa.LTE_ActionCode__c=='ADD'?'Add': xa.LTE_ActionCode__c)+ '</ActionCode>'
                           + '<Name>' + xa.Name + '</Name>'
                           + '<Value>' + xa.LTE_Value__c + '</Value>'
                           + '</SpecificationGroupXA>';
                    //}
                }
            }

            return xml;

}

public static string mapearCampo(string objeto,string campo,OperacionComercial__c oc,LTE_DetalleOferta__c   dof,ActivoETB__c objServicio) {
            string valor = '';
            Sobject sOBJd;
            
            system.debug('objeto-->'+objeto);
            if(objeto=='OperacionComercial__c'){
                sOBJd= oc;
            }else if(objeto=='LTE_DetalleOferta__c'){
                sOBJd=dof;
            }else if(objeto=='ActivoETB__c'){
                sOBJd=objServicio;
            }
            
            system.debug('objServicio-->'+objServicio);
            system.debug('sOBJd-->'+sOBJd);
            system.debug('Campo-->'+Campo);
            valor=LibreriaUtilitaria_cls.recorreCampos(sOBJd,Campo);

            system.debug(valor);

            return valor;
}

public static string AltKey(OperacionComercial__c OC,list<LTE_SpecificationGroupXA__c> lstXas, String IdSalesOrderLine,Decimal valorEquiposFinanciados,ActivoETB__c     objServicios,LTE_DetalleOferta__c objDetOferta)
{
        string ciudad         = '';
        string departamento   = '';
        string direccion      = '';
        string codigodane     = '';
        String codigoDaneDpto = ''; 
    
    	/*string ciudad         =   OC.CuentaCliente__r.Ciudad__r.Name!=null?OC.CuentaCliente__r.Ciudad__r.Name:'';
        string departamento     =   OC.CuentaCliente__r.Departamento__c!=null?OC.CuentaCliente__r.Departamento__c:'';
        string direccion        =   OC.CuentaCliente__r.Direccion__c!=null?OC.CuentaCliente__r.Direccion__c:'';
        string codigodane       =   OC.CuentaCliente__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.CodigoDane__c:'';
        String codigoDaneDpto   =   OC.CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.CuentaCliente__r.Ciudad__r.Padre__r.CodigoDane__c:'';
        */
    
    	if(OC.TOPP__r.TipodeOperacionporplan__c=='Venta Equipos' ){//INI14505-SR-Para venta equipo enviar datos direccion de facturación desde la Legalización 
        	ciudad           =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Name:'';
        	departamento     =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.Name:'';
        	direccion        =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.DirCorresp__c:'';           
        	codigodane       =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
        	codigoDaneDpto   =   OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.Legalizacion__r.LTE_CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c:'';   
        }else{
            ciudad           =   OC.CuentaFacturacion__r.Ciudad__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Name:'';
            departamento     =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.Name:'';
            // Se hace ajuste para cambio de campo direcccion LTE_DireccionFacturacion__c --> DirCorresp__c LRPA-19-11-2015
            direccion        =   OC.CuentaFacturacion__r.DirCorresp__c!=null?OC.CuentaFacturacion__r.DirCorresp__c:'';           
            codigodane       =   OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.CodigoDane__c:'';
            codigoDaneDpto   =   OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c!=null?OC.CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c:'';         
        }
        
        string indicativo       =   oc.CuentaCliente__r.Ciudad__r.Indicativo__c!=null?string.valueOf(oc.CuentaCliente__r.Ciudad__r.Indicativo__c):'';
        string tipodoc          =   OC.CuentaCliente__r.Tipodedocumento__c!=null?OC.CuentaCliente__r.Tipodedocumento__c:'';
        string numero           =   OC.CuentaCliente__r.AccountNumber!=null?OC.CuentaCliente__r.AccountNumber:'';
        string tele             =   OC.CuentaCliente__r.Phone!=null?OC.CuentaCliente__r.Phone:'';
        string diaCorte         =   OC.CuentaFacturacion__r.LTE_CicloFacturacion__c;    
        
        string strIdServicio    =   OC.Activo__r.Id;
        // Si el servicio es migrado, toma el id de migracion lrpa 1/10/2015 idSiebel
        if(OC.Activo__r.Esmigrado__c==true) {
            strIdServicio=OC.Activo__r.LTE_IdSiebel__c;  
        }
        
        
        Time myTime = Time.newInstance(0, 0, 0, 0); 
        Datetime dt = system.now();
        String formattedDt;
        String formattedDt2;
        if(OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan' || OC.TOPP__r.TipodeOperacionporplan__c=='Cambio Número' || OC.TOPP__r.TipodeOperacionporplan__c=='Adición SVA' || OC.TOPP__r.TipodeOperacionporplan__c=='Retiro SVA'){  			// Tomar Fecha efectiva Cambio Plan  PVTA LRPA - 26-11-2015)
        	dt=DateTime.newInstance(OC.FechaInicioReconexion__c,myTime); 		// Tomar Fecha efectiva Cambio Plan  PVTA LRPA - 26-11-2015)
        }
        else if(OC.TOPP__r.Name!=System.label.Venta_Equipos_TELEFONIA_MOVIL_LTE && OC.TOPP__r.TipodeOperacionporplan__c!='Cambio de Plan'){
            dt=DateTime.newInstance(OC.fechadeActivacion__c,myTime);
        }
        formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        formattedDt2 = dt.format('MM/dd/yyyy hh:mm:ss');
        
        string dirRecortada='';
        if(direccion.length()>=58)
            dirRecortada=direccion.SubString(0,58);
        else 
            dirRecortada=direccion;

        //Recorta nombre de cuenta cliente a 40 caracteres si su longitud es mayor
        String nombreCuentaCliente = OC.CuentaCliente__r.Name;
        
        if(nombreCuentaCliente.length()>40){
            nombreCuentaCliente = nombreCuentaCliente.SubString(0,40);
            normalizarString(nombreCuentaCliente); // [CG] - Se incluye ajuste de Portafolio Superior
        }
                        
        string xml='';
        system.debug('OC.TOPP__r.TipodeOperacionporplan__c-->'+OC.TOPP__r.TipodeOperacionporplan__c);
        if(	OC.TOPP__r.TipodeOperacionporplan__c =='Venta' 				|| 
        	OC.TOPP__r.TipodeOperacionporplan__c=='Retiro' 				|| 
        	OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan' 		|| 
        	OC.TOPP__r.TipodeOperacionporplan__c=='Cambio Número'		||
        	OC.TOPP__r.TipodeOperacionporplan__c=='Suspensión'			||	//[AG: 2016-02-16] AltKeys para suspensión y reconexión
        	OC.TOPP__r.TipodeOperacionporplan__c=='Reconexión'			||	//[AG: 2016-02-16] AltKeys para suspensión y reconexión
        	OC.TOPP__r.TipodeOperacionporplan__c=='Adición SVA'			||	//[AG: 2016-02-17] AltKeys para Adición y Retiro de SVA
        	OC.TOPP__r.TipodeOperacionporplan__c=='Retiro SVA'			||	//[AG: 2016-02-17] AltKeys para Adición y Retiro de SVA
            OC.TOPP__r.TipodeOperacionporplan__c=='Modificación Servicio' ||
           	OC.TOPP__r.TipodeOperacionporplan__c=='Modificación Estándar' //FSARASTY 2020-09-22
        ){ // Tipo de operacion diferente a Venta de Equipos
            xml+='<AltKey>';
                    xml+='<AltKeyName>USO</AltKeyName>';
                    xml+='<AltKeyValue></AltKeyValue>';
            xml+='</AltKey>';
                        
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
                    xml+='<AltKeyValue>'+strIdServicio+'</AltKeyValue>  ';          
            xml+='</AltKey> ';   
                    
            xml+='<AltKey> ';               
                    xml+='<AltKeyName>BAADD</AltKeyName>  ';              
                    xml+='<AltKeyValue>'+dirRecortada+'</AltKeyValue>'; // [CG] - Se incluye ajuste de Portafolio Superior         
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
                    xml+='<AltKeyValue>'+normalizarString(nombreCuentaCliente)+'</AltKeyValue>';  // [CG] - Se incluye ajuste de Portafolio Superior           
            xml+='</AltKey>';
    
            xml+='<AltKey>';                
                    xml+='<AltKeyName>ESTRATO</AltKeyName>';                
                    xml+='<AltKeyValue>'+normalizarString(OC.CuentaCliente__r.Name)+'</AltKeyValue>';            
            xml+='</AltKey>';

            xml+='<AltKey>';                
                    xml+='<AltKeyName>InvoiceDayRVC</AltKeyName>';                
                    xml+='<AltKeyValue>'+diaCorte+'</AltKeyValue>';            
            xml+='</AltKey>';
        
            // Generar alkey de Metodos de Reclamacion
            xml+='<AltKey>';                
                    xml+='<AltKeyName>SysOrg</AltKeyName>';                
                    xml+='<AltKeyValue>SF_LTE</AltKeyValue>';            
            xml+='</AltKey>';               
            // Consultar Conf. Personalizada de Homologacion de Metodo de Reclamacion
            String segmenetoSubsegmento=OC.CuentaCliente__r.Segmento__c+'-'+OC.CuentaCliente__r.SubSegmento__c;
            HomologacionMetodosReclamacion__c metRec = HomologacionMetodosReclamacion__c.getValues(segmenetoSubsegmento);               
            xml+='<AltKey>';                
                    xml+='<AltKeyName>MetodoReclamacion</AltKeyName>';

            if(metRec != null)
                    xml+='<AltKeyValue>'+metRec.MetodoReclamacion__c+'</AltKeyValue>'; 
            else
                    xml+='<AltKeyValue>'+'</AltKeyValue>';      
                            
            xml+='</AltKey>';

    // Generar los Altkeys Variables
        
            if (lstXas.isEmpty()) {

                return  xml;
            }
            
            string valor;
            system.debug(lstXas.size());
            if(OC.TOPP__r.TipodeOperacionporplan__c=='Venta') // Obtener XA si la OP Com es Venta, tomandolos del detalle de la ofereta
            {
                for (LTE_SpecificationGroupXA__c xa : lstXas) 
                {
                    
                    if(!xa.Name.Contains('RVC') &&  xa.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c==  OC.id){
                        xml+=AltKey( xa.Id,xa.Name, xa.LTE_Value__c);
                    }
                }
            }else if(	OC.TOPP__r.TipodeOperacionporplan__c=='Retiro'  || 
            			OC.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan' || 
            			OC.TOPP__r.TipodeOperacionporplan__c=='Cambio Número' ||
            			OC.TOPP__r.TipodeOperacionporplan__c=='Suspensión' ||
            			OC.TOPP__r.TipodeOperacionporplan__c=='Reconexión' ||
            			OC.TOPP__r.TipodeOperacionporplan__c=='Adición SVA' ||
            			OC.TOPP__r.TipodeOperacionporplan__c=='Retiro SVA' ||
            			OC.TOPP__r.TipodeOperacionporplan__c=='Modificación Servicio' ||
                     	OC.TOPP__r.TipodeOperacionporplan__c=='Modificación Estándar' //FSARASTY 2020-09-22
            		){ // Obtener XA si la OP Com es Retiro, tomandolos del servicio
                for (LTE_SpecificationGroupXA__c xa : lstXas) 
                {
                    //AG:2016-03-08 Se incluye validación para no enviar el metodo de pago de Prepago cuando es cambio de plan PrePos
                	Boolean incluir = true;
                    if(xa.Name.Contains('METODO DE PAGO') && xa.LTE_Value__c.Contains('PREPAGO') && estatic_tipoCambio=='PrePos')
                    	incluir = false;
                    	
                    if(!xa.Name.Contains('RVC') &&  xa.LTE_ServiciosAdicionales__r.LTE_ServicioETB__c==objServicios.id && incluir){
                        xml+=AltKey( xa.Id,xa.Name, xa.LTE_Value__c);
                    }
                }               
            }
                        
        }else if(OC.TOPP__r.TipodeOperacionporplan__c=='Venta Equipos' || OC.TOPP__r.TipodeOperacionporplan__c  ==  'Renovación' || OC.TOPP__r.TipodeOperacionporplan__c    ==  'Reposición'){ // AlTKEYs para facturacion de Equipos
            
            if(OC.TOPP__r.TipodeOperacionporplan__c=='Reposición' || OC.TOPP__r.TipodeOperacionporplan__c   ==  'Renovación'){
                valorEquiposFinanciados = objDetOferta.LTEValorEquipoDescuento__c;
            }

            xml+='<AltKey>';
                    xml+='<AltKeyName>USO</AltKeyName>';
                    xml+='<AltKeyValue></AltKeyValue>';
            xml+='</AltKey>';
                        
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
                    xml+='<AltKeyValue>'+strIdServicio+'</AltKeyValue>  ';          
            xml+='</AltKey> ';   
                    
            xml+='<AltKey> ';               
                    xml+='<AltKeyName>BAADD</AltKeyName>  ';              
                    xml+='<AltKeyValue>'+dirRecortada+'</AltKeyValue>'; // [CG] - Se incluye ajuste de Portafolio Superior          
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
                    xml+='<AltKeyValue>'+normalizarString(nombreCuentaCliente)+'</AltKeyValue>'; // [CG] - Se incluye ajuste de Portafolio Superior            
            xml+='</AltKey>';
    
            xml+='<AltKey>';                
                    xml+='<AltKeyName>ESTRATO</AltKeyName>';                
                    xml+='<AltKeyValue>'+normalizarString(OC.CuentaCliente__r.Name)+'</AltKeyValue>';            
            xml+='</AltKey>';

            xml+='<AltKey>';                
                    xml+='<AltKeyName>InvoiceDayRVC</AltKeyName>';                
                    xml+='<AltKeyValue>'+diaCorte+'</AltKeyValue>';            
            xml+='</AltKey>';
        
            // Generar alkey de Metodos de Reclamacion
            xml+='<AltKey>';                
                    xml+='<AltKeyName>SysOrg</AltKeyName>';                
                    xml+='<AltKeyValue>SF_LTE</AltKeyValue>';            
            xml+='</AltKey>';               
                        
            xml+='<AltKey>';                
                    xml+='<AltKeyName>PORCENTAJE FINANCIAMIENTO</AltKeyName>';                
                    xml+='<AltKeyValue>100.0000</AltKeyValue>';            
            xml+='</AltKey>';
            xml+='<AltKey>';                
                    xml+='<AltKeyName>IMEI</AltKeyName>';                
                    xml+='<AltKeyValue>'+OC.Legalizacion__c+'</AltKeyValue>';            
            xml+='</AltKey>';
            xml+='<AltKey>';                
                    xml+='<AltKeyName>PRECIO</AltKeyName>';                
                    xml+='<AltKeyValue>'+valorEquiposFinanciados+'</AltKeyValue>';            
            xml+='</AltKey>';   
            
            xml+='<AltKey>';                
                    xml+='<AltKeyName>InvoiceDayRVC</AltKeyName>';                
                    xml+='<AltKeyValue>'+diaCorte+'</AltKeyValue>';            
            xml+='</AltKey>';   
                    
            xml+='<AltKey>';                
                    xml+='<Id>'+OC.Legalizacion__c+'</Id>';  
                    xml+='<AltKeyName>CUOTASFNC</AltKeyName>';                
                    xml+='<AltKeyValue>'+OC.Legalizacion__r.Cuotas__c+'</AltKeyValue>';            
            xml+='</AltKey>';   

    // Generar los Altkeys Variables
        
            if (lstXas.isEmpty()) {

                return  xml;
            }
             
            string valor;
            system.debug(lstXas.size());
            if(OC.TOPP__r.TipodeOperacionporplan__c=='Venta Equipos'){
	           	// Consultar Conf. Personalizada de Homologacion de Metodo de Reclamacion
	            String segmenetoSubsegmento=OC.CuentaCliente__r.Segmento__c+'-'+OC.CuentaCliente__r.SubSegmento__c;
	            HomologacionMetodosReclamacion__c metRec = HomologacionMetodosReclamacion__c.getValues(segmenetoSubsegmento);               
	            xml+='<AltKey>';                
	                    xml+='<AltKeyName>MetodoReclamacion</AltKeyName>';

                if(metRec != null)
                    xml+='<AltKeyValue>'+metRec.MetodoReclamacion__c+'</AltKeyValue>'; 
                else
                    xml+='<AltKeyValue>'+'</AltKeyValue>'; 

	            xml+='</AltKey>';
            
                for (LTE_SpecificationGroupXA__c xa : lstXas) 
                {
                    
                    if(!xa.Name.Contains('RVC') &&  xa.LTE_ServiciosAdicionales__r.LTE_ServicioETB__c==objServicios.id){
                        xml+=AltKey( xa.Id,xa.Name, xa.LTE_Value__c);
                    }
                }
            }else{
                for (LTE_SpecificationGroupXA__c xa : lstXas) 
                {
                    
                    if(!xa.Name.Contains('RVC') &&  xa.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c==  OC.id){
                        xml+=AltKey( xa.Id,xa.Name, xa.LTE_Value__c);
                    }
                }               
            }                   
        }
        

    
    return xml;
}
public static string Custom2(OperacionComercial__c OC)
{
    string strAssetIntegrationID = OC.Activo__r.Name;
    // Si el servicio es migrado, toma el id de migracion lrpa 1/10/2015 idSiebel
    if(OC.Activo__r.Esmigrado__c==true) {
        strAssetIntegrationID=OC.Activo__r.LTE_IdSiebel__c;  
    }
        
    string xml='';
    xml+='<Custom>';
        xml+='<PartNumber>A</PartNumber>';
        xml+='<AssetIntegrationID>'+strAssetIntegrationID+'</AssetIntegrationID>';
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

    public class tramiteLTE {

        public string OrderType = '';
        public string OrderSubtype = '';
        public string ServiceActionCode = '';
        public string SubOrderType = '';
        public list<string> NoEnviarLiteItem = new list<string>();

        public tramiteLTE(OperacionComercial__c oc) {

            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Venta') {
                ServiceActionCode           =   'ADD';
                OrderType                   =   'Venta LTE';
                OrderSubtype                =   'Venta LTE';
                if (oc.Portacion__c) {
                    OrderSubtype = 'Venta LTE NCP'; 
                }

            }

            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Venta Equipos' ) {
                ServiceActionCode           =   'ADD';
                OrderType                   =   'Venta LTE';//INI14505-SR-Para venta equipo se cambia de Venta LTE Financiada a Venta LTE
                OrderSubtype                =   'Venta LTE';
            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio de Plan' ) {
                String cadena = identificarTipoCambioPlan(oc.Activo__r.Plan__r.LTE_TipoControl__c, oc.PlanAnterior__c);
                ServiceActionCode           =   'ADD';
                OrderType                   =   'Cambio de Plan';
                OrderSubtype                =   'Cambio de Plan';
                if(cadena == 'PrePos'){
                	OrderType               =   'Venta LTE';
                	OrderSubtype            =   'Venta LTE';
                }
            }

            if ( oc.TOPP__r.TipodeOperacionporplan__c   ==  'Renovación' || oc.TOPP__r.TipodeOperacionporplan__c    ==  'Reposición' ) {
                ServiceActionCode           =   'ADD';
                OrderType                   =   'Tramites LTE';
                
                if(oc.LTE_TipoTransaccion__c == 'Equipo'){
                    OrderSubtype                =   'Reposicion Equipo LTE';
                }else if(oc.LTE_TipoTransaccion__c == 'Equipo más SIM'){
                    OrderSubtype            =   'Reposicion Equipo LTE';
                    
                }
            }
            


            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Retiro') {
                ServiceActionCode           =   'DELETE';
                OrderType                   =   'Cancelación Voluntaria (Baja)';
                OrderSubtype                =   'Cancelacion Voluntaria';
                NoEnviarLiteItem = new String[]{'RVC','NUMERO TELEFONICO','DEFAULT USO VOZ','DEFAULT USO DATOS','DEFAULT USO SMS','DEFAULT USO OTROS'};
            }
            
            //AG 2016-02-03
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio Número') {
                ServiceActionCode           =   'UPDATE';
                OrderType                   =   'MODIFICACION CAMBIO NUMERO LTE';
                OrderSubtype                =   'Modificacion Cambio Numero LTE';
            }
			
			//AG 2016-02-03
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Suspensión') {
                ServiceActionCode           =   'ADD';
                OrderType                   =   'SUSPENSION VOLUNTARIA';
                OrderSubtype                =   'Suspension Voluntaria';
            }
            //AG 2016-02-03
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Reconexión') {
                ServiceActionCode           =   'ADD';
                OrderType                   =   'RECONEXION VOLUNTARIA';
                OrderSubtype                =   'Reconexion Voluntaria';
            }
            //AG 2016-02-17
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Adición SVA') {
                ServiceActionCode           =   'UPDATE';
                OrderType                   =   'ADICION SVA';
                OrderSubtype                =   'Adicion SVA';
            }
            //JG 2020-03-16 //FSARASTY 2020-09-22
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Modificación Servicio' || oc.TOPP__r.TipodeOperacionporplan__c == 'Modificación Estándar') {
                ServiceActionCode           =   'UPDATE';
                OrderType                   =   'Cambio de Plan';
                OrderSubtype                =   'Cambio de Plan';
            }
            //AG 2016-02-17
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Retiro SVA') {
                ServiceActionCode           =   'UPDATE';
                OrderType                   =   'DESACTIVACION SVA';
                OrderSubtype                =   'Desactivacion SVA';
            }

        }

        public string siguienteEstado(boolean error) {

            return '';
        }

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