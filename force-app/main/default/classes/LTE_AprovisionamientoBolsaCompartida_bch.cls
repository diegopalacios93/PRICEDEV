/*******************************************************************************
Desarrollado por:       ETB
Autor:                  Fernando Sarasty
Proyecto:               Bolsas compartidas (shared account)
Descripcion:            Batch Para la venta de bolsas compartidas
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     12-05-2020  Fernando Sarasty (FS)      Creacion de la clase
*******************************************************************************/
global class LTE_AprovisionamientoBolsaCompartida_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    
    global boolean limitQ=false;
    global integer limiteTotal=30;
    global boolean esVIP=false;
    global set<id>idImediato=new set<id>();
    
    global Database.Querylocator start(Database.Batchablecontext bc)
    {       
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        
        String query = 'SELECT Plan__r.LTE_MetodoDePago__c,Plan__r.LTE_TipoControl__c,Id,Name,Activo__c,Activo__r.Name,CuentaCliente__c,CuentaCliente__r.Name,SucursalDestino__r.Direccion__c,SucursalDestino__r.Ciudad__r.Name,SucursalDestino__r.Ciudad__r.Padre__r.Name,SucursalDestino__r.Ciudad__r.CodigoDane__c, CuentaCliente__r.AccountNumber,CuentaCliente__r.OwnerId,CuentaFacturacion__r.LTE_CicloFacturacion__c,CuentaCliente__r.Tipodedocumento__c,CreatedDate,TOPP__r.TipodeOperacionporplan__c,Portacion__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,LTE_PUK__c,LTE_PUK2__c,LTE_PIN__c,LTE_PIN2__c,LTE_IMSI__c,SDP__c,Legalizacion__r.Cuotas__c,LTE_TipoTransaccion__c, Valor_APN_No_Recurrente__c, Valor_APN_Recurente__c,NumeroCanales__c,Tarifa_mensual_Bolsa_de_Moviles__c,Tarifa_mensual_Troncales_SIP__c , CuentaCliente__r.Primer_Nombre__c, CuentaCliente__r.Segundo_Nombre__c, CuentaCliente__r.Primer_Apellido__c, CuentaCliente__r.Segundo_Apellido__c, Tipo_linea_bolsa_compartida__c, Operacion_Comercial_Relacionada__r.Id, '  
        +'Operacion_Comercial_Relacionada__r.EstadoAprovisionamiento__c, Operacion_Comercial_Relacionada__r.Estado__c, Operacion_Comercial_Relacionada__r.NumeroConexion__c, FechadeActivacion__c, Activo__r.LTE_Fecha_Alta_inicial__c, '
		+'Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Estado__c, Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Tipo_linea_bolsa_compartida__c, Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.NumeroConexion__c, Activo_Relacionado__r.NumeroConexion__c '
        +'FROM OperacionComercial__c '
        +'WHERE '
        +'(Plan__r.NombredelProducto__r.Name=\''+vGlobal.Valor__c+'\' AND Tipo_linea_bolsa_compartida__c = \'Hija\') AND '
        +'(Estado__c = \'En Curso\' AND FechaInicioReconexion__c <= TODAY) AND '    
        +'((TOPP__r.TipodeOperacionporplan__c=\'Adición bolsa compartida\' AND Operacion_Comercial_Relacionada__r.Estado__c=\'Facturado\')OR TOPP__r.TipodeOperacionporplan__c=\'Reducción bolsa compartida\')';
        
        if(esVIP){ 
            query+=' AND LTE_AplicaOnline__c=true ';
        }        
        if(!idImediato.isEmpty()){ 
            query+=' AND id IN :idImediato ';   
        }        
        query+=' ORDER BY LastModifiedDate DESC ';
        
        if(limitQ){
            query+=' Limit '+limiteTotal+' ';       
        }
        system.debug('\n Bolsas compartidas - ConsultaBatch: '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){
	
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreFacturacionLTE');            
        set<Id> ocIds			= new set<Id>();
        set<Id> acIdsTramites	= new set<Id>();
        
        //llamar todas las operaciones comerciales que tengan el check habilitado.
        EjecucionIntegracion__c integra =EjecucionIntegracion__c.getValues('Aprovisionamiento');
                
        if(integra!=null && integra.Ejecucion__c==true)
        {
            // Excluir operaciones comerciales hijas, en donde la OC padre se encuentre pendiente de aprovisionamiento.
            for(OperacionComercial__c oc:scope){
                if((oc.Tipo_linea_bolsa_compartida__c == 'Padre' ||                   
                  (oc.Tipo_linea_bolsa_compartida__c == 'Hija' && (oc.Operacion_Comercial_Relacionada__r.Estado__c == 'Activa' || oc.Operacion_Comercial_Relacionada__r.Estado__c == 'Facturado') && oc.Operacion_Comercial_Relacionada__r.EstadoAprovisionamiento__c == 'COMPLETE') ||
                  (oc.Tipo_linea_bolsa_compartida__c == 'Hija' && (oc.Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Estado__c == 'Activo' && oc.Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Tipo_linea_bolsa_compartida__c == 'Padre'))) &&
                  (oc.TOPP__r.TipodeOperacionporplan__c != 'Adición bolsa compartida' && oc.TOPP__r.TipodeOperacionporplan__c != 'Reducción bolsa compartida'))
                  {
                  	ocIds.add(oc.id);
                  }
                if(oc.TOPP__r.TipodeOperacionporplan__c == 'Adición bolsa compartida' || oc.TOPP__r.TipodeOperacionporplan__c == 'Reducción bolsa compartida'){
                   acIdsTramites.add(oc.Activo__r.id);
                }
                system.debug('\n Bolsas compartidas - ocIds a integrar: '+ocIds);
                system.debug('\n Bolsas compartidas - ocIds de trámites a integrar: '+acIdsTramites);
            }
                                   
            list<LTE_Servicios_adicionales__c> 		   sAdicionales;
            map<id,list<LTE_Servicios_adicionales__c>> serVad=new map<id,list<LTE_Servicios_adicionales__c>>();
            if(ocIds.size() > 0){          
                sAdicionales = new list<LTE_Servicios_adicionales__c>([SELECT Id,LTE_CatalogoProducto__c,LTE_DetalleOfertaEReservadoRegContable__c,LTE_Estado__c,LTE_ItemIdentification__c,LTE_NetworkIndicator__c,LTE_ParentId__c,LTE_PlanFacturacion__c,LTE_PrimaryClassificationCode__c,LTE_ServiceActionCode__c,LTE_ServiceIndicator__c,LTE_ServicioETB__c,LTE_SubPlaFacturacion__c,LTE_TypeCode__c,Name,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Direccion__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Name,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Padre__r.Name,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.CodigoDane__c,
                LTE_NivelDescuento__r.LTE_DescuentoNivel1__c,
                LTE_NivelDescuento__r.LTE_DescuentoNivel2__c,
                LTE_NivelDescuento__r.LTE_DescuentoNivel3__c,
                LTE_NivelDescuento__r.LTE_Indice__c,
                LTE_NivelDescuento__r.LTE_NoCuotasNivel1__c,
                LTE_NivelDescuento__r.LTE_NoCuotasNivel2__c,
                LTE_NivelDescuento__r.LTE_NoCuotasNivel3__c,
                LTE_NivelDescuento__r.LTE_Nombre__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Descuento_Nivel_1__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Vigencia_Nivel_1__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Descuento_Nivel_2__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Vigencia_Nivel_2__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Descuento_Nivel_3__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Vigencia_Nivel_3__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Valor__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.NumeroCanales__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Tarifa_mensual_Bolsa_de_Moviles__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Tarifa_mensual_Troncales_SIP__c,                                                                                        
                (	select id,Name,LTE_Value__c,LTE_ServiciosAdicionales__c,LTE_ActionCode__c,LTE_ParametroFacturacion__r.Campo__c,LTE_ParametroFacturacion__r.Objeto__c, LTE_ParametroFacturacion__r.LTE_ValorDefecto__c
                    from SpecificationGroupXA__r
                )
                FROM LTE_Servicios_adicionales__c
                Where LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c=:ocIds and LTE_ServiceActionCode__c!='DELETE'
                ]);
                
                for(LTE_Servicios_adicionales__c sa:sAdicionales){
                    Id idOc=sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c;
                    if(serVad.get(idOc)==null){
                        serVad.put(idOc,new list<LTE_Servicios_adicionales__c>());
                    }
                    serVad.get(idOc).add(sa);
            	}
            } 
            if(acIdsTramites.size() > 0){
                sAdicionales = new list<LTE_Servicios_adicionales__c>([SELECT Id,LTE_CatalogoProducto__c,LTE_DetalleOfertaEReservadoRegContable__c,LTE_Estado__c,LTE_ItemIdentification__c,LTE_NetworkIndicator__c,LTE_ParentId__c,LTE_PlanFacturacion__c,LTE_PrimaryClassificationCode__c,LTE_ServiceActionCode__c,LTE_ServiceIndicator__c,LTE_ServicioETB__c,LTE_SubPlaFacturacion__c,LTE_TypeCode__c,Name,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Direccion__c,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Name,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Padre__r.Name,LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.CodigoDane__c,
                LTE_NivelDescuento__r.LTE_DescuentoNivel1__c,
                LTE_NivelDescuento__r.LTE_DescuentoNivel2__c,
                LTE_NivelDescuento__r.LTE_DescuentoNivel3__c,
                LTE_NivelDescuento__r.LTE_Indice__c,
                LTE_NivelDescuento__r.LTE_NoCuotasNivel1__c,
                LTE_NivelDescuento__r.LTE_NoCuotasNivel2__c,
                LTE_NivelDescuento__r.LTE_NoCuotasNivel3__c,
                LTE_NivelDescuento__r.LTE_Nombre__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Descuento_Nivel_1__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Vigencia_Nivel_1__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Descuento_Nivel_2__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Vigencia_Nivel_2__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Descuento_Nivel_3__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Vigencia_Nivel_3__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Valor__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.NumeroCanales__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Tarifa_mensual_Bolsa_de_Moviles__c,
                LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Tarifa_mensual_Troncales_SIP__c,                                                                                        
                (	select id,Name,LTE_Value__c,LTE_ServiciosAdicionales__c,LTE_ActionCode__c,LTE_ParametroFacturacion__r.Campo__c,LTE_ParametroFacturacion__r.Objeto__c, LTE_ParametroFacturacion__r.LTE_ValorDefecto__c
                    from SpecificationGroupXA__r
                )
                FROM LTE_Servicios_adicionales__c
                Where LTE_ServicioETB__c=:acIdsTramites and LTE_ServiceActionCode__c!='DELETE']);            
                
                for(LTE_Servicios_adicionales__c sa:sAdicionales){
                    Id idAc=sa.LTE_ServicioETB__c;
                    if(serVad.get(idAc)==null){
                        serVad.put(idAc,new list<LTE_Servicios_adicionales__c>());
                    }
                    serVad.get(idAc).add(sa);
            	}
            }                
            system.debug('\n Bolsas compartidas - Map servicios adicionales: ' +serVad);                        
            
            list<consultaServ> cs=new list<consultaServ>();         
            
            for(OperacionComercial__c oc:scope){
                  LTE_AprovisionamientoBolsaCompartida_cls.OrdelineBolsaCompartidaXML sX;
                  if((oc.Tipo_linea_bolsa_compartida__c == 'Padre' ||                   
                  (oc.Tipo_linea_bolsa_compartida__c == 'Hija' && (oc.Operacion_Comercial_Relacionada__r.Estado__c == 'Activa' || oc.Operacion_Comercial_Relacionada__r.Estado__c == 'Facturado') && oc.Operacion_Comercial_Relacionada__r.EstadoAprovisionamiento__c == 'COMPLETE') ||
                  (oc.Tipo_linea_bolsa_compartida__c == 'Hija' && (oc.Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Estado__c == 'Activo' && oc.Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Tipo_linea_bolsa_compartida__c == 'Padre'))) &&
                  (oc.TOPP__r.TipodeOperacionporplan__c != 'Adición bolsa compartida' && oc.TOPP__r.TipodeOperacionporplan__c != 'Reducción bolsa compartida'))                
                  {
                    sX = new LTE_AprovisionamientoBolsaCompartida_cls.OrdelineBolsaCompartidaXML(serVad.get(oc.Id),oc,oc.Tipo_linea_bolsa_compartida__c);                    
                  }
				  if(oc.TOPP__r.TipodeOperacionporplan__c == 'Adición bolsa compartida' || oc.TOPP__r.TipodeOperacionporplan__c == 'Reducción bolsa compartida')
                  {
                  	sX = new LTE_AprovisionamientoBolsaCompartida_cls.OrdelineBolsaCompartidaXML(serVad.get(oc.Activo__r.Id),oc,oc.Tipo_linea_bolsa_compartida__c);                    
                  }
                  system.debug('\n Bolsas compartidas - Request: ' +sx.getBodyBolsaCompartida());
                  cs.add(new consultaServ(oc,sX.getBodyBolsaCompartida().replace('>null<', '><')));      
            }            
            guardar(cs);
        } 
    }
    
    global void finish(Database.BatchableContext bc){         
        LTE_AprovisionamientoBolsaCompartida_sch.ProgramarJob();
    }
    
    global class consultaServ{        
        public OperacionComercial__c oc;
        public ActivoETB__c ac;
        public string response;
        public string request;
        public string tipoLinea;
        public LogTransacciones__c log=new LogTransacciones__c();
            
        public consultaServ(OperacionComercial__c oc,string request){
            this.oc=oc;
            this.request=request;            
            this.tipoLinea = oc.Tipo_linea_bolsa_compartida__c;
            consultar();
        }
        //Consume el servicio web
        public void consultar(){ 
            ServiciosWeb__c sw;
            if(tipoLinea == 'Padre')
            	sw = ServiciosWeb__c.getValues('AprovisionarProviderBolsaCompartida');
            
            if(tipoLinea == 'Hija'){
                if(oc.TOPP__r.TipodeOperacionporplan__c == 'Reducción bolsa compartida')
            		sw = ServiciosWeb__c.getValues('ReducirBolsaCompartida');
                else
                    sw = ServiciosWeb__c.getValues('AprovisionarConsumerBolsaCompartida');
            }                 
            map<string,string> values=new map<string,string>();
			if(Test.isRunningTest())            
            	response = '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns1:WSOutputCreateProvider xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/LTE/WS/LTEServiceManagement/OutputCreateProvider/OUT/1.0"><ns2:WSResponseHeader xmlns:ns2="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0"><ns2:System correlationID="a09m0000004oi3kAAA" processingServer="Salesforce">Salesforce</ns2:System><ns2:Service><ns2:status>PASS</ns2:status></ns2:Service></ns2:WSResponseHeader><ns2:OutputCreateProvider xmlns:ns2="http://www.etb.com.co/LTE/LTEServiceManagement/OutputCreateProvider"><ns2:result>OK</ns2:result><ns2:description>Se crea provider exitosamente</ns2:description></ns2:OutputCreateProvider></ns1:WSOutputCreateProvider></SOAP-ENV:Body></SOAP-ENV:Envelope>';
            else 
              	response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
            
            tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
            
            values=proReq.getMap(response);
            system.debug('\n Bolsas compartidas - Response: '+response);
                        
            if(values.get('result')=='OK'){
                oc.Estado__c='Activa';
                oc.EstadoAprovisionamiento__c = 'COMPLETE';
                oc.FechadeActivacion__c=date.today();                
                log.Estado__c='COMPLETE';
                           
                if(oc.TOPP__r.TipodeOperacionporplan__c == 'Adición bolsa compartida' || oc.TOPP__r.TipodeOperacionporplan__c == 'Reducción bolsa compartida')
                    oc.Fecha_Final_Estado__c = date.today();
                            
            }else{               
                oc.Estado__c='Fallido Aprovisionamiento';
                log.Estado__c='Fallido Aprovisionamiento';                      
            }
            log.Informacion_Enviada__c=request.abbreviate(99999);
            log.Informacion_Recibida__c=response.abbreviate(99999);
            log.LTE_Operacion_Comercial__c=oc.id;
            log.Name='Aprovisionamiento '+oc.Name;
            if(values.get('description')!=null){
                log.CodigoRespuesta__c=values.get('description').abbreviate(250);
            }            
        }        
    }
    
    global void guardar(list<consultaServ> con){
        
        List<OperacionComercial__c> ocLst	= new List<OperacionComercial__c>();
        List<LogTransacciones__c> 	logLst	= new List<LogTransacciones__c>();
                
        for(consultaServ cs: con){
            ocLst.add(cs.oc);
            logLst.add(cs.log);
        }
                
        BanderasEjecucion.setEjecucion('ValidarPerfilesReglasOC');
        Database.SaveResult[] srList;                       
        srList = Database.update(ocLst,false);        
                
        for(Integer i=0;i<srList.size();i++){
            
            if (srList[i].isSuccess()) {
            }
            else {
                for(Database.Error err : srList[i].getErrors()) {
                    logLst[i].Error_Apex__c=err.getStatusCode() + ': ' + err.getMessage();
                }
            }
        }          
        insert logLst;        
    }
}