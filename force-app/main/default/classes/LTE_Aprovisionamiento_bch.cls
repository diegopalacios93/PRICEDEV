/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Integraciones LTE Aprovisionamiento venta
Descripcion:            Batch Para la venta
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     09-08-2015  Hector Bayona (HB)      Creacion de la clase
2.0     27-04-2017  Mauricio Farias (MF)    Modificacion de la Clase inclusion de nuevos parametros INI 5059 Lienas 26, 74-81, 89 
3.0     09-08-2018  Javier Acero    (JA)    Modificacion de la Clase inclusion de parametros SDP para INI 9685 
*******************************************************************************/
global class LTE_Aprovisionamiento_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    
    global boolean limitQ=false;
    global integer limiteTotal=30;
    global boolean esVIP=false;
    global set<id>idImediato=new set<id>();
    
    global Database.Querylocator start(Database.Batchablecontext bc)
    {
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        
        String query = 'SELECT  Plan__r.LTE_MetodoDePago__c,Plan__r.LTE_TipoControl__c,Id,Name,Activo__c,Activo__r.Name,CuentaCliente__c,CuentaCliente__r.Name,SucursalDestino__r.Direccion__c,SucursalDestino__r.Ciudad__r.Name,SucursalDestino__r.Ciudad__r.Padre__r.Name,SucursalDestino__r.Ciudad__r.CodigoDane__c, CuentaCliente__r.AccountNumber,CuentaCliente__r.OwnerId,CuentaFacturacion__r.LTE_CicloFacturacion__c,CuentaCliente__r.Tipodedocumento__c,CreatedDate,TOPP__r.TipodeOperacionporplan__c,Portacion__c,LTE_ICCID__c,IMEI_del_Equipo__c,NumeroConexion__c,LTE_PUK__c,LTE_PUK2__c,LTE_PIN__c,LTE_PIN2__c,LTE_IMSI__c,SDP__c,Legalizacion__r.Cuotas__c,LTE_TipoTransaccion__c, Valor_APN_No_Recurrente__c, Valor_APN_Recurente__c,NumeroCanales__c,Tarifa_mensual_Bolsa_de_Moviles__c,Tarifa_mensual_Bolsa_de_Moviles_Calc__c,Tarifa_mensual_Troncales_SIP__c , CuentaCliente__r.Primer_Nombre__c, CuentaCliente__r.Segundo_Nombre__c, CuentaCliente__r.Primer_Apellido__c, CuentaCliente__r.Segundo_Apellido__c, Tipo_linea_bolsa_compartida__c, Operacion_Comercial_Relacionada__r.NumeroConexion__c '  
        +'FROM OperacionComercial__c '
        +'WHERE (((Estado__c = \'Exitoso M6\') AND Plan__r.NombredelProducto__r.Name=\''+vGlobal.Valor__c+'\' AND (TOPP__r.TipodeOperacionporplan__c=\'Venta\') AND (Tipo_linea_bolsa_compartida__c = \'\')) '
        +'OR '
        // Filtros para bolsas compartidas (OCs Padre y OCs Hijas):
        +'((Estado__c = \'Exitoso M6\' AND Plan__r.NombredelProducto__r.Name=\''+vGlobal.Valor__c+'\' AND TOPP__r.TipodeOperacionporplan__c=\'Venta\') AND '
        // Obtener líneas padre
        +'(Tipo_linea_bolsa_compartida__c = \'Padre\' OR '
        // obtener líneas hijas en donde su línea padre ya se encuentre aprovisionada o sea una línea padre existente.    
        +'(Tipo_linea_bolsa_compartida__c = \'Hija\' AND (Operacion_Comercial_Relacionada__r.Estado__c = \'Activa\' OR Operacion_Comercial_Relacionada__r.Estado__c = \'Facturado\' OR '
        +'(Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Estado__c = \'Activo\' AND Oportunidad__r.Servicio_Bolsa_Compartida_Padre__r.Tipo_linea_bolsa_compartida__c = \'Padre\')))'
        +')))';
        
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
        system.debug('\n ConsultaBatch: '+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){

        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreFacturacionLTE');
        Map<Id,string>parentMaId=new Map<Id,string>();
        
        set<Id> ocIds=new set<Id>();
        
        //llamar todas las operaciones comerciales que tengan el check habilitado.
        EjecucionIntegracion__c integra =EjecucionIntegracion__c.getValues('Aprovisionamiento');
        if(integra!=null && integra.Ejecucion__c==true)
        {
        
            for(OperacionComercial__c oc:scope){
                ocIds.add(oc.id);
                system.debug(oc.id);
            }
            
            list<LTE_Servicios_adicionales__c> sAdicionales=new list<LTE_Servicios_adicionales__c>([SELECT Id,LTE_CatalogoProducto__c,LTE_DetalleOfertaEReservadoRegContable__c,LTE_Estado__c,LTE_ItemIdentification__c,LTE_NetworkIndicator__c,LTE_ParentId__c,LTE_PlanFacturacion__c,LTE_PrimaryClassificationCode__c,LTE_ServiceActionCode__c,LTE_ServiceIndicator__c,LTE_ServicioETB__c,LTE_SubPlaFacturacion__c,LTE_TypeCode__c,Name,
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
            LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Tarifa_mensual_Bolsa_de_Moviles_Calc__c,
            LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Tarifa_mensual_Troncales_SIP__c,                                                                                        
    (select id,Name,LTE_Value__c,LTE_ServiciosAdicionales__c,LTE_ActionCode__c,LTE_ParametroFacturacion__r.Campo__c,LTE_ParametroFacturacion__r.Objeto__c, LTE_ParametroFacturacion__r.LTE_ValorDefecto__c
            from SpecificationGroupXA__r) 
            FROM LTE_Servicios_adicionales__c
            Where LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c=:ocIds and LTE_ServiceActionCode__c!='DELETE'
            ]);
    
            List<LTE_DetalleOferta__c> detOf =new list<LTE_DetalleOferta__c>([select
                Id,LTE_OperacionComercial__c,LTE_ReferenciaEquipo__r.LTE_Marca__c,LTE_ReferenciaEquipo__r.LTE_ModeloComercial__c,LTE_ReferenciaEquipo__r.LTE_PartNumber__c,LTE_EsPortabilidad__c,LTE_OperacionComercial__r.Descuento_Nivel_1__c,LTE_OperacionComercial__r.Vigencia_Nivel_1__c,LTE_OperacionComercial__r.Descuento_Nivel_2__c,LTE_OperacionComercial__r.Vigencia_Nivel_2__c,LTE_OperacionComercial__r.Descuento_Nivel_3__c,LTE_OperacionComercial__r.Vigencia_Nivel_3__c,LTE_OperacionComercial__r.Valor__c,LTE_OperacionComercial__r.NumeroCanales__c,LTE_OperacionComercial__r.Tarifa_mensual_Troncales_SIP__c,LTE_OperacionComercial__r.Tarifa_mensual_Bolsa_de_Moviles__c,LTE_OperacionComercial__r.Tarifa_mensual_Bolsa_de_Moviles_Calc__c
                from LTE_DetalleOferta__c where LTE_OperacionComercial__c=:ocIds]);
            map<Id,LTE_DetalleOferta__c> doMap=new map<Id,LTE_DetalleOferta__c>();
    
            for(LTE_DetalleOferta__c dof:detOf){
                doMap.put(dof.LTE_OperacionComercial__c,dof);
            }
    
    
    
            
            system.debug(sAdicionales);
            set<Id> parametros=new set<Id>(); 
            
            map<id,list<LTE_Servicios_adicionales__c>> serVad=new map<id,list<LTE_Servicios_adicionales__c>>();
            
            for(LTE_Servicios_adicionales__c sa:sAdicionales){
                Id idOc=sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c;
                if(serVad.get(idOc)==null){
                    serVad.put(idOc,new list<LTE_Servicios_adicionales__c>());
                }
                serVad.get(idOc).add(sa);
                system.debug('Name sales'+sa.Name+' - '+vGlobal.Valor__c);
                if(sa.Name==vGlobal.Valor__c){
                    parentMaId.put(idOc,sa.id);
                }
            }
            
            map<Id,String> xmlS=new map<Id,String>();
            list<consultaServ> cs=new list<consultaServ>();
            List<LTE_SpecificationGroupXA__c> lstSgXa=new list<LTE_SpecificationGroupXA__c>();
            
            for(OperacionComercial__c oc:scope){
                ocIds.add(oc.id);
                LTE_Aprovisionamiento_cls.SalesOrdelineXML sX =new LTE_Aprovisionamiento_cls.SalesOrdelineXML(serVad.get(oc.Id),oc,doMap.get(oc.Id),parentMaId,new list<LTE_Servicios_adicionales__c>());
                //system.debug(sX.getBody().replace('>null<', '><'));
                cs.add(new consultaServ(oc,sX.getBody().replace('>null<', '><')));
                lstSgXa.addAll(sx.lstSgXa);
            }
            guardar(cs,lstSgXa);
        
        }
    
    }
    
    global void finish(Database.BatchableContext bc){}
    
    global class consultaServ{
        
        public OperacionComercial__c oc;
        public string response;
        public string request;
        public LogTransacciones__c log=new LogTransacciones__c();
            
        public consultaServ(OperacionComercial__c oc,string request){
            this.oc=oc;
            this.request=request;
            consultar();
        }
        //Consume el servicio web
        public void consultar(){
            
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('Aprovisionar');
            map<string,string> values=new map<string,string>();
            
            response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
            
            tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
            
            values=proReq.getMap(response);
                        
            if(values.get('status')=='PASS' && values.get('TIBCOResponseCode')=='17'){
                oc.Estado__c='Enviado Aprovisionamiento';
                log.Estado__c='Enviado Aprovisionamiento';
            }else{
                oc.Estado__c='Fallido Aprovisionamiento';
                log.Estado__c='Fallido Aprovisionamiento';                      
            }
            log.Informacion_Enviada__c=request.abbreviate(99999);
            log.Informacion_Recibida__c=response.abbreviate(99999);
            log.LTE_Operacion_Comercial__c=oc.id;
            log.Name='Aprovisionamiento '+oc.Name;
            if(values.get('TIBCOResponseDescription')!=null){
                log.CodigoRespuesta__c=values.get('TIBCOResponseDescription').abbreviate(250);
            }
            
        }
        
    }
    
    global void guardar(list<consultaServ> con,List<LTE_SpecificationGroupXA__c> lstSgXa){
        
        List<OperacionComercial__c> ocLst=new List<OperacionComercial__c>();
        List<LogTransacciones__c> logLst=new List<LogTransacciones__c>();
        
        for(consultaServ cs: con){
            ocLst.add(cs.oc);
            logLst.add(cs.log);
        }
        
        Database.SaveResult[] srSgXA =Database.update(lstSgXa,false);
        BanderasEjecucion.setEjecucion('ValidarPerfilesReglasOC');
        Database.SaveResult[] srList =Database.update(ocLst,false);
        
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