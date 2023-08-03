/**********************************************************************************************
Desarrollado por:       Accenture
Autor:                  Luisina Platino
Proyecto:               ETB
Descripción:            Clase encargada de procesos relacionados con la integracion de los APN

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     07-05-2021  Luisina Platino				Creación de la clase. Es testeada por dos clases: LTE_AprovisionamientoAPNDatos_tst y LTE_AprovisionamientoAPN_tst
***********************************************************************************************/
global class LTE_AprovisionamientoAPN_cls {
    
    
    global class consultaServ{
        
        public OperacionComercial__c oc;
        public ActivoETB__c ac;
        public IP__c objIP;
        public string response;
        public string request;
        public LogTransacciones__c log=new LogTransacciones__c();
        public String msj;
            
        public consultaServ(OperacionComercial__c oc, String smsj){
            this.oc=oc;
            this.msj = smsj;
            this.request=GenerarMensaje().replace('>null<', '><');
            Consultar();
            if(msj == 'Exitoso'){
                LiberacionIPs();
                ActualizacionAPN();
            }
        }
		
        //Consume el servicio web
        public void Consultar(){
            
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('AprovisionarAPN');
            map<string,string> values=new map<string,string>();
            
            response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
            tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
            values=proReq.getMap(response);
            
            if(values.get('status')=='PASS' && values.get('Code_Result')=='1'){
                oc.Estado_APN__c=msj;
                if(oc.Caso__c != null && msj == 'Exitoso'){
                	oc.Estado__c = 'Activa';
                }
                log.Estado__c='Enviado Aprovisionamiento';
            }else{
                oc.Estado_APN__c='Fallido' + (msj == 'Exitoso'?'':' Datos');
                log.Estado__c='Fallido Aprovisionamiento';
            }
            
            log.Informacion_Enviada__c=request.abbreviate(99999);
            log.Informacion_Recibida__c=response.abbreviate(99999);
            log.LTE_Operacion_Comercial__c=oc.id;
            log.Name='Aprovisionamiento APN ' + (msj == 'Exitoso'?'':'Datos ') +oc.Name ;
            if(values.get('message_result')!=null){
                log.CodigoRespuesta__c=values.get('message_result').abbreviate(250);
            }
		}
		
        //Genera el Mensaje
        public String GenerarMensaje(){
            Map<string,LTE_APN__c> vGlobalAPN = LTE_APN__c.getAll();
            system.debug('GenerarMensaje');
            String sFormulaAPN = Oc.Tipo_Operacion_APN__c == 'Retiro'?vGlobalAPN.get(Oc.Tipo_Operacion_APN__c).valor__c:vGlobalAPN.get(Oc.Tipo_Operacion_APN__c+' '+Oc.APN__r.Servicio__c).valor__c;
            String sDireccionamiento = '';
            if(Oc.POOL_de_APN__c != null){
            	sDireccionamiento = vGlobalAPN.get('Homo-'+Oc.POOL_de_APN__r.Direccionamiento__c).valor__c;
            }
            System.debug('msj : '+msj);
            String sCharge = Oc.APN__c != null?Oc.APN__r.Charguing_Characteristics__c:vGlobalAPN.get('DefaultCharge').valor__c;
            string xml = '<?xml version="1.0" encoding="UTF-8" ?>'
                         + '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsin="http://www.etb.com.co/LTE/LTEServiceManagement/WsInputProvisioningApn" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:inp="http://www.etb.com.co/LTE/LTEServiceManagement/InputProvisioningApn">'
                         + '<soapenv:Header/>'
                         + '<soapenv:Body>'
							 + '<wsin:WsInputProvisioningApn>'
								 + '<v1:WSRequestHeader>'
									 + '<v1:System correlationID="' + obtenerCorrelationId() + '" processingServer="Salesforce">Salesforce</v1:System>'
									 + '<v1:Property name="" value=""></v1:Property>'
								 + '</v1:WSRequestHeader>'
								 + '<inp:InputProvisioningApn>'
									 + '<inp:Name>'
                                        + '<inp:serviceValues>'
                                                + '<inp:serviceValue>'
                                                + '<inp:name>ISDN</inp:name>'
                                                + '<inp:value>57' + Oc.NumeroConexion__c + '</inp:value>'
                                                + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                            + '</inp:serviceValue>'
                                            + '<inp:serviceValue>'
                                                + '<inp:name>PROV</inp:name>';

                                                if(msj == 'Exitoso'){
                                                    xml+='<inp:value>MODPDPCNTX</inp:value>';
                                                }else{
                                                    xml+='<inp:value>ADDPDPCNTX</inp:value>';
                                                }

                                            xml+='<inp:type>OPTIONAL_SCALAR</inp:type>'
                                            + '</inp:serviceValue>'
                                            + '<inp:serviceValue>'
                                                + '<inp:name>CNTXID</inp:name>';

                                                if(msj == 'Exitoso'){
                                                    xml+='<inp:value>1</inp:value>';
                                                }else{
                                                    xml+='<inp:value>2</inp:value>';
                                                }

                                            xml+='<inp:type>OPTIONAL_SCALAR</inp:type>'
                                            + '</inp:serviceValue>'
                                            + '<inp:serviceValue>'
                                                + '<inp:name>APN_TYPE</inp:name>'
                                                + '<inp:value>BOTH</inp:value>'
                                                + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                            + '</inp:serviceValue>'
                                            + '<inp:serviceValue>'
                                                + '<inp:name>APNTPLID</inp:name>'
                                                + '<inp:value>'+ sFormulaAPN +'</inp:value>' //FORMULA APN y EN APN DATOS 2
                                                + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                            + '</inp:serviceValue>'
                                            + '<inp:serviceValue>'
                                                + '<inp:name>PDPTYPE</inp:name>'
                                                + '<inp:value>IPV4</inp:value>'
                                                + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                            + '</inp:serviceValue>'
                                            + '<inp:serviceValue>'
                                                + '<inp:name>ADDIND</inp:name>'
                                                + '<inp:value>'+ sDireccionamiento +'</inp:value>' //DYNAMIC
                                                + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                            + '</inp:serviceValue>';

                                        if(msj == 'Exitoso'){
                                            xml += '<inp:serviceValue>'
                                                        + '<inp:name>PDPADD</inp:name>'
                                                        + '<inp:value>'+ Oc.IP__r.Name +'</inp:value>'
                                                        + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                                    + '</inp:serviceValue>';
                                            }

                                            xml+= '<inp:serviceValue>'
                                                + '<inp:name>CHARGE</inp:name>'
                                                + '<inp:value>' + sCharge + '</inp:value>'
                                                + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                            + '</inp:serviceValue>';

                                        if(msj != 'Exitoso'){
                                            xml += '<inp:serviceValue>'
                                                    + '<inp:name>QOSTPLID</inp:name>'
                                                    + '<inp:value>3</inp:value>'
                                                    + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                                + '</inp:serviceValue>'
                                                + '<inp:serviceValue>'
                                                    + '<inp:name>EPS_QOSTPLID</inp:name>'
                                                    + '<inp:value>6</inp:value>'
                                                    + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                                + '</inp:serviceValue>'
                                                + '<inp:serviceValue>'
                                                    + '<inp:name>VPLMN</inp:name>'
                                                    + '<inp:value>TRUE</inp:value>'
                                                    + '<inp:type>OPTIONAL_SCALAR</inp:type>'
                                                + '</inp:serviceValue>';
                                            }
                                    xml += '</inp:serviceValues>'
									 + '</inp:Name>'
								 + '</inp:InputProvisioningApn>'
							 + '</wsin:WsInputProvisioningApn>'
                         + '</soapenv:Body>'
                         + '</soapenv:Envelope>';
            return xml;
		}
        
	    private String obtenerCorrelationId(){
	    	
	    	Datetime dttFechaHoraActual	= System.now();
	    	Integer intNumeroRandom = Math.round( Math.random() * ( 1000 + dttFechaHoraActual.second() ) );
	    	String strCorrelationId = dttFechaHoraActual.format( 'ddMMyyyyHHmmssSSS' ) + String.valueOf( intNumeroRandom );
	    	
	    	return strCorrelationId;
	    }
		
        //Consume el servicio web
        public void LiberacionIPs(){
			if(Oc.Estado__c == 'Activa' && oc.Estado_APN__c=='Exitoso' && Oc.Activo__r.IP__c != null && Oc.IP__c != Oc.Activo__r.IP__c){
                objIP = Oc.Activo__r.IP__r;
            	objIP.Estado__c = 'Disponible';
			}
        }
		
        //Consume el servicio web
        public void ActualizacionAPN(){
			if(Oc.Estado__c == 'Activa' && oc.Estado_APN__c=='Exitoso'){
                ac = Oc.Activo__r;
                ac.APN__c = Oc.APN__c;
                ac.POOL_de_APN__c = Oc.POOL_de_APN__c;
                ac.IP__c = Oc.IP__c;
                ac.Pool_de_APN_Autopista__c = Oc.Pool_de_APN_Autopista__c;
                ac.Pool_de_APN_Chico__c = Oc.Pool_de_APN_Chico__c;
                ac.Tipo_de_APN__c = Oc.Tipo_de_APN__c;
                ac.Tipo_de_Plan_APN__c = Oc.Tipo_de_Plan_APN__c;
			}
        }
	}
}