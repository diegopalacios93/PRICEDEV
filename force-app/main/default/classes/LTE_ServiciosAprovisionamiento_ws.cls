global class LTE_ServiciosAprovisionamiento_ws {
    
    
    global class LineItem{
        webservice string EstadoLineItem;
        webservice string IdLineItem;       
    }
    
    global class EstadosOrden{
        webservice string OrderId;
        webservice string EstadoOrden;
        webservice string Comentarios;
        webservice list<LineItem> LineItems;
    }
    
    global class ResponseEstadoOrden{
        webservice string EstadoOrden;
        webservice string OrderType;
        webservice string OrderSubtype;
        webservice string connectionNumber;
        webservice string Roaming;
        webservice string AccionRoaming;
    }
    
    
    static webservice string ActualizacionEstadoOrden(EstadosOrden EO){
        
        system.debug(EO);
        list<OperacionComercial__c> ocList=new list<OperacionComercial__c>([select
                                                                            id,NumeroConexion__c,categoria__c, Name,Activo__c,TipoSuspension__c, TOPP__r.TipodeOperacionporplan__c,Plan__r.LTE_TipoControl__c,
                                                                            LTE_ICCID__c, LTE_IMSI__c, LTE_PIN__c, LTE_PUK__c, SDP__c,IMEI_del_Equipo__c, LTE_TipoTransaccion__c,
                                                                            Activo__r.LTE_Fecha_Ultima_Suspension__c,Activo__r.LTE_Fecha_Ultima_Reconexion__c,Activo__r.NumeroConexion__c,Plan__r.LTE_MetodoDePago__c,
                                                                            Activo__r.Fecha_Activacion__c,Activo__r.LTE_Fecha_Inicial_Contrato__c,Activo__r.LTE_Fecha_Final_Contrato__c,Activo__r.LTE_Fecha_Alta_inicial__c,
                                                                            Activo__r.LTE_Dias_suspendidos__c,Activo__r.LTE_Numero_veces_suspendido__c,Plan__r.TipodePlan__c, LTE_ReferenciaEquipo__c, LTE_ReferenciaEquipo__r.Name, LTE_ReferenciaEquipo__r.LTE_Marca__c 
                                                                            from OperacionComercial__c where Id=:EO.OrderId
                                                                           ]);
        
        OperacionComercial__c oc=ocList[0];

        system.debug(ocList[0].NumeroConexion__c);
        system.debug(ocList[0].Id);
        oc.EstadoAprovisionamiento__c=EO.EstadoOrden;
        
        
        
        string unfallido='';
        
        list<Sobject>lit=new list<Sobject>();
        
        if(EO.LineItems!=null){
            for(LineItem li:EO.LineItems){
                string objeto='';
                try{
                    Id ids=li.IdLineItem;
                    if(li.EstadoLineItem=='PROVISION FAILED' && oc.EstadoAprovisionamiento__c!='FAILED'){
                        oc.EstadoAprovisionamiento__c=li.EstadoLineItem;                    
                    }
                    
                    objeto=String.valueOf(ids.getSObjectType());
                }catch(exception e){
                }           
                if(li.EstadoLineItem!=null && li.IdLineItem!=null && objeto=='LTE_Servicios_adicionales__c'){
                    LTE_Servicios_adicionales__c sa=new LTE_Servicios_adicionales__c(Id=li.IdLineItem,LTE_Estado__c=li.EstadoLineItem);
                    lit.add(sa);
                }   
            }
        }
        
        ActivoETB__c ac = oc.Activo__r;
        
        /* Prepara la logica para actualizar servicios adicionales*/
        tramite tramite=new tramite();
        tramite.OcId=oc.id; 
        tramite.AcId=oc.Activo__c;
        tramite.oc=oc;
        tramite.ac=ac;
        tramite.tramite=oc.TOPP__r.TipodeOperacionporplan__c;
        
        
        if(oc.EstadoAprovisionamiento__c=='COMPLETE'){
            
            if(oc.TOPP__r.TipodeOperacionporplan__c=='Venta'){
                oc.Estado__c='Activa';
                oc.FechadeActivacion__c=date.today();
                ac.LTE_Fecha_Alta_inicial__c=date.today();
                system.debug(ac.LTE_Fecha_Alta_inicial__c);                
                list<LTE_Servicios_adicionales__c> servAd=new list<LTE_Servicios_adicionales__c>([select id,LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Activo__c from LTE_Servicios_adicionales__c where 
                                                                                                  LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c=:oc.id
                                                                                                 ]);
                
                for(LTE_Servicios_adicionales__c sa:servAd){
                    sa.LTE_ServicioETB__c=sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Activo__c;
                }
                
                update servAd;
                
                enviarCorreo(oc);
                
                system.debug('\n=======================================================\n'
                    +'oc.TOPP__r.TipodeOperacionporplan__c = ' + oc.TOPP__r.TipodeOperacionporplan__c + '\n'
                    +'oc.Plan__r.TipodePlan__c = ' + oc.Plan__r.TipodePlan__c + '\n'
                    +'=======================================================\n');
                if(oc.Plan__r.TipodePlan__c == 'Troncal SIP'){
                    try{
                        set<id> setIdOcs = new set<id>();
                        setIdOcs.add(oc.Id);
                        system.debug('\n--------------------------------------------------\n'
		                    +'Va a llamar las cuentas de facturacion con '+oc.Id+'\n'
		                    +'--------------------------------------------------\n');
                        LTE_CuentasFacturacion_bch batchA = new LTE_CuentasFacturacion_bch();
                        batchA.idImediato = setIdOcs;
                        ID batchprocessid = Database.executeBatch(batchA, 1);
                    }catch(exception e){
                        LogTransacciones__c logSIP=new LogTransacciones__c();
                        logSIP.LTE_Operacion_Comercial__c=oc.id;
                        logSIP.Name='Error enviando a Facturacion (Inmediato) '+oc.Name;
                        logSIP.Error_Apex__c=e.getLineNumber()+' '+e.getMessage();
                        insert logSIP;
                    }
                }
                
            }
            
            if(oc.TOPP__r.TipodeOperacionporplan__c=='Suspensión'){
                actualizarServAdicionales(tramite);
                oc.FechadeActivacion__c=date.today();
                //oc.Estado__c='Suspendido';
                //ac.Estado__c='Suspendido';
                
                LTE_CreacionOperacionesComerciales_ctr.registrarSuspenda(new set<String>{oc.Id},'1');
            }
            
            if(oc.TOPP__r.TipodeOperacionporplan__c=='Reconexión'){
                actualizarServAdicionales(tramite);
                //oc.Estado__c='Activa';
                //ac.Estado__c='Activo';
                oc.FechadeActivacion__c=date.today();
                
                LTE_CreacionOperacionesComerciales_ctr.registrarSuspenda(new set<String>{oc.Id},'1');
            }
            
            if(oc.TOPP__r.TipodeOperacionporplan__c=='Retiro'){
                
                list<LTE_Servicios_adicionales__c> servAd=new list<LTE_Servicios_adicionales__c>([select id,LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__r.Activo__c from LTE_Servicios_adicionales__c where 
                                                                                                  LTE_ServicioETB__c=:oc.activo__c and LTE_ServiceActionCode__c!='DELETE'  and LTE_ServiceActionCode__c!='ELIMINADO'
                                                                                                 ]);
                
                for(LTE_Servicios_adicionales__c sa:servAd){
                    sa.LTE_ServiceActionCode__c='DELETE';
                }
                
                update servAd;
                
                
                oc.Estado__c='Inactivo';
                ac.Estado__c='Inactivo';
                oc.FechadeActivacion__c=date.today();
            }
            
            if((oc.TOPP__r.TipodeOperacionporplan__c=='Reposición' || oc.TOPP__r.TipodeOperacionporplan__c=='Renovación')){
                actualizarServAdicionales(tramite);
                oc.Estado__c='Activa';
                //ac.Estado__c='Activo'; [05/05/2016] Evolutivo: Una OC de Reposición o Renovación no deben afectar el estado del AC
                oc.FechadeActivacion__c=date.today();
            }
            
            if(oc.TOPP__r.TipodeOperacionporplan__c=='Cambio de Plan'){
                actualizarServAdicionales(tramite);
                oc.Estado__c='Activa';
                ac.LTE_DetalleOferta__c=tramite.NuevoDeatalleOF;
                oc.FechadeActivacion__c=date.today();
            }
            
            set<string> toppLTE=new set<string>{'Retiro SVA','Adición SVA','Cambio Número'};
            
            if(toppLTE.contains(oc.TOPP__r.TipodeOperacionporplan__c)){
                actualizarServAdicionales(tramite);
                oc.Estado__c='Activa';
                oc.FechadeActivacion__c=date.today();
            }

            
        }
        
        string respuesta='0';
        LogTransacciones__c log=new LogTransacciones__c();
        try{
            log.Name='ActualizacionEstadoOrden';
            log.Informacion_Recibida__c=string.valueOf(EO).abbreviate(99999);
            if(EO.OrderId!=null){
                log.LTE_Operacion_Comercial__c=EO.OrderId;
                if(EO.Comentarios!=null){
                    log.CodigoRespuesta__c=EO.Comentarios.abbreviate(254);
                }
                log.Estado__c=EO.EstadoOrden;
            }
        	BanderasEjecucion.setEjecucion('ValidarPerfilesReglasOC');
            system.debug(oc);
            update lit;
            update ac;
            update oc;
            system.debug(ac);
            actualizarFacturado(oc);
            
        }catch(Exception e){
            log.Name='ActualizacionEstadoOrden Error';
            log.LTE_Operacion_Comercial__c=EO.OrderId;
            log.Estado__c+=' Error Actualizar Salesforce';
            log.Error_Apex__c=e.getMessage();
            respuesta='1';            
        }
        insert log;
        
        
        return respuesta;
    }
    
    static webservice ResponseEstadoOrden ConsultaEstadoOrden(string OC){
        
        list<OperacionComercial__c>  ocInfo=new list<OperacionComercial__c>([select Id,Estado__c,NumeroConexion__c,EstadoAprovisionamiento__c,TOPP__r.TipodeOperacionporplan__c,Portacion__c from OperacionComercial__c where id=:OC]); 
        
        ResponseEstadoOrden respEO=new ResponseEstadoOrden();        
        if(!ocInfo.isEmpty()){
            respEO.EstadoOrden=ocInfo[0].EstadoAprovisionamiento__c;
            respEO.OrderType='Venta LTE';
            respEO.OrderSubtype='Venta LTE';
            respEO.connectionNumber=ocInfo[0].NumeroConexion__c;
        }
        
        
        
        return respEO;
        
    }
    /**
** Obtiene los servicios adicionales del AC
**/
    public static void actualizarServAdicionales(tramite tramite){
        
        //map<String,String> MapServAd = new map<String,String>();
        
        string c ='LTE_TipodeOperacionProductoOnComplete.'+LibreriaUtilitaria_cls.quitarCaracteresEsp(tramite.tramite.deleteWhitespace());
        system.debug(c);
        Type t = Type.forName(c);
        if(t!=null){
            LTE_Tramites_cls.Step paso =(LTE_Tramites_cls.Step) t.newInstance();
            paso.oc=tramite.oc;
            paso.ac=tramite.ac;
            
            system.debug(paso.oc.NumeroConexion__c);

            paso.sa=obtenerServAd(tramite.OcId,'OC');
            
            //
            if(!paso.sa.isEmpty()){
                tramite.NuevoDeatalleOF=paso.sa[0].LTE_DetalleOfertaEReservadoRegContable__c;
            }
            
            
            // Ajsute para que no se duplique el Serv. Adic de Plan Nuevo LRPA 
            // --------------------------------------------------------------------
            //for(LTE_Servicios_adicionales__c sad:paso.sa){
               //MapServAd.put(sad.id,sad.id);      
            //}
            
            //list<LTE_Servicios_adicionales__c> lstServAddW = obtenerServAd(tramite.AcId ,'AC');
            paso.saActivo  = obtenerServAd(tramite.AcId ,'AC');
            /*
            for(LTE_Servicios_adicionales__c sad:lstServAddW){
                if(!MapServAd.containsKey(sad.id)){
                    paso.saActivo.add(sad);
                }
            }
            */
            paso.procesar();

            list<LTE_Servicios_adicionales__c> actual=new list<LTE_Servicios_adicionales__c>();
            actual.addall(paso.sa);          
            actual.addall(paso.saActivo);
            
            // --------------------------------------------------------------------------
            

            
            list<LTE_Servicios_adicionales__c> actualizar=new list<LTE_Servicios_adicionales__c>();
            //actualizar.addAll(paso.sa);
            //actualizar.addAll(paso.saActivo);
            //update actualizar;
            update actual;
            
            update paso.SpecGroupXAList;
            for(LTE_Servicios_adicionales__c sz:actualizar){
                system.debug(sz.LTE_ServiceActionCode__c+' '+sz.Name);
            }
            
        }
        
        
        
    }
    
    public static list<LTE_Servicios_adicionales__c> obtenerServAd(Id idO, string opcion){
        
        string query='SELECT Id,LTE_ServiceActionCode__c,LTE_OC_Tramite__c,Name,LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c,LTE_ServicioETB__r.Plan__r.Name,LTE_DetalleOfertaEReservadoRegContable__c,'+
            ' (select id,Name,LTE_ActionCode__c from SpecificationGroupXA__r) '+
            ' FROM LTE_Servicios_adicionales__c ';
        
        if(opcion=='OC'){
            query+=' Where ( LTE_Operacion_Comercial_SVA__c = :idO OR LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c = :idO) and LTE_ServiceActionCode__c!=\'DELETE\' and LTE_ServiceActionCode__c!=\'ELIMINADO\'';
        }else if(opcion=='AC'){
            query+=' Where LTE_ServicioETB__c = :idO and LTE_ServiceActionCode__c!=\'DELETE\' and LTE_ServiceActionCode__c!=\'ELIMINADO\'';
        }else{
            query+=' limit 1 ';     
        }
        system.debug(query);
        
        list<LTE_Servicios_adicionales__c> servAdList = Database.query(query);
        
        return servAdList;
        
    }
    
    private class tramite{
        public string tramite;
        public Id OcId;
        public Id AcId;
        public Id NuevoDeatalleOF;
        public OperacionComercial__c oc;
        public ActivoETB__c ac;     
        
    }
    
    /*  este metodo se realiza para actualizar la oc cuando es prepago,
cuando se activa la oc suben varios valores al servicio por eso es,
necesaria una doble actualizacion
*/
    public static void actualizarFacturado(OperacionComercial__c oc){
        //oc.EstadoAprovisionamiento__c=='COMPLETE' && oc.TOPP__r.TipodeOperacionporplan__c=='Venta' && oc.Plan__r.LTE_TipoControl__c=='Prepago'
        set<string> facturado=new set<string>();
        facturado.add('Bolsa Única vez');
        facturado.add('Roaming');        
        
        if(facturado.contains(oc.categoria__c)){
            oc.Estado__c='Facturado';
            update oc;
        }
        
    }
    
    public static void enviarCorreo(OperacionComercial__c oc){
        Map<string,VariablesGlobales__c> vGlobal;
        try{
            if(oc.Plan__r.TipodePlan__c == 'Troncal SIP'){
                vGlobal = VariablesGlobales__c.getAll();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSenderDisplayName(vGlobal.get('CorreoSIP_Remitente').valor__c);//el id del usuario No Responder de evolutivos en la configuracion personalizada Variables Globales
                mail.setReplyTo(vGlobal.get('CorreoSIP_Remitente').valor__c);//el id del usuario No Responder de evolutivos en la configuracion personalizada Variables Globales
                mail.setReferences(vGlobal.get('CorreoSIP_Remitente').valor__c);//el id del usuario No Responder de evolutivos en la configuracion personalizada Variables Globales
                mail.setTargetObjectId(vGlobal.get('CorreoSIP_Contacto').valor__c);//Id de la cuenta configurada en al configuracion personalizada Variables Globales
                mail.setTemplateId(vGlobal.get('CorreoSIP_Template').valor__c);//Id del template que se pone en la configuracion personallizada de Variables Globales
                mail.setWhatId(oc.id);
                mail.setSaveAsActivity(false);
                
                Messaging.SendEmailResult[] repuesta=Messaging.sendEmail(new Messaging.singleemailMessage[] {mail});
            }
        } catch(Exception e){
                System.Debug('====================== EXCEPCION ======================');
                System.Debug('ERROR ENVIANDO CORREO DE VENTA SIP TRUNCKING');
                System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                System.Debug('=======================================================');
                LogTransacciones__c log = new LogTransacciones__c();
                log.Name = 'Error enviando correo Venta SIP Truncking';
                log.LTE_Operacion_Comercial__c = oc.Id;
                log.Estado__c = 'Error enviando correo';
                log.Error_Apex__c = e.getMessage();
                insert log; 
            }
    }
    
   
}