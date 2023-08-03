/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andres Cubillos
Proyecto:               ETB - CRM etapa 1
Descripcion:            Disparador sobre el objeto OperacionComercial__c
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     16-10-2013  Andres Cubillos (AAC)       Creacion del disparador.
1.1     18-10-2013  Daniel Guana (DGUANA)       Se agrega restriccion para que solo haya una opp comercial principal activa
1.2     27-01-2014  Jorge Grimaldos (JG)        Se agregan los desarrollos relacionados con los requerimientos del paquete 20-01-2014
1.3     08-05-2014  Jorge Grimaldos (JG)        Se agregaron los desarrollos para la matriz de homologacion de la contingencia SIEBEL
1.4     20-08-2014  Luis Eduardo Mogollon       Se agrega banderas para ejecucion de trigger.
1.5     17-09-2014  Hector Bayona (HB)          Correo Encuesta de satisfaccion.
1.6     14-08-2015  Juan Gabriel Duarte P.      Actualiza la fecha de declinacion y los detalles de oferta asociados
1.7     05-02-2016  Juan David Uribe Ruiz       Actualiza la fecha de venta de un equipo.
1.8     10-07-2018  Fernando Sarasty (FS)       Se incluye invocación a la clase PS_Valida_Actualizacion_OC, para validar si los campos 
                                                dinámicos del TOPP definidos en la integración entre SalesForce y Gestor, pueden ser actualizados.
1.9     01-07-2020  Samuel Rodriguez (SR)       Se ajusta para OCs de Cambio Cuenta de Facturacion en estado Facturado 
******************************************************************************/
trigger OperacionComercial_tgr on OperacionComercial__c (after insert, after update, before insert, 
before update){
    System.debug('ENTRO AL TRIGGER!!!!');
    Boolean seDebeEjecutar = true;  
    seDebeEjecutar = !BanderasEjecucion.ValidarEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
    //Valida si se debe ejecutar ya que hay varios procesos en los cuales no se requiere
    //ejecutar el trigger
    if(seDebeEjecutar){
        OperacionComercial_cls ocClass=new OperacionComercial_cls();
        ActualizarOportunidad_cls AO = new ActualizarOportunidad_cls();
        PS_Valida_Actualizacion_OC_cls PSValidaActServ = new PS_Valida_Actualizacion_OC_cls();
        ActualizarCompensacionesXPlan_cls  clsActualizarCompensacion = new ActualizarCompensacionesXPlan_cls(); //SAO  
        ValidacionCreacionOperacionComercial_cls valOC = new ValidacionCreacionOperacionComercial_cls();
        //ValidacionesNumeroRedInteligente val = new ValidacionesNumeroRedInteligente();
        if(trigger.new.size()==1){
            
            if(trigger.isAfter && trigger.isUpdate){
                //Cambio Suscriptor
                /*
                if(trigger.new[0].Estado__c == 'Activa' && trigger.new[0].TOPP__r.TipodeOperacionporplan__c == 'Cambio de Suscriptor'){
                    ActivoETB__c objAct = [select id from ActivoETB__c where id=:trigger.new[0].Activo__c];
                    objAct.Estado__c = 'Inactivo';
                    update objAct;                
                }else if(trigger.new[0].Estado__c == 'Activa' &&  trigger.new[0].TOPP__r.TipodeOperacionporplan__c == 'Cambio de Suscriptor Nuevo'){
                        ActivoETB__c objAct = [select id from ActivoETB__c where id=:trigger.new[0].Activo__c];
                        objAct.Estado__c = 'Activo';
                        update objAct;
                }       */
                //DGUANA                
                if(trigger.old[0].Tecnologia_servicio_SDWAN__c != trigger.new[0].Tecnologia_servicio_SDWAN__c){}
                else          
                    AO.validarViabilidad(trigger.new[0]);
                //FIN DGUANA
                //FSARASTY
                PSValidaActServ.validaActualizacionOC(trigger.new[0],trigger.old[0],'Viabilidad','OperacionComercial__c');                
                //PSValidaActServ.ActualizaOCRelacionadas(trigger.new[0],trigger.old[0]);
                //[FSARASTY, 2020/05/01]: Bolsas compartidas - Actualizar estado OCs Hijas:
                LTE_ProcesosBolsasCompartidas_cls BolsasCompClass = new LTE_ProcesosBolsasCompartidas_cls();
                BolsasCompClass.actualizaOCsBolsasCOmpartidas(trigger.new[0],trigger.old[0]);
                //FIN FSARASTY
            } 
            else if(trigger.isBefore){
                LlenarCamposOC_cls llc = new LlenarCamposOC_cls();
                llc.LlenarCuenta(trigger.new);
                //-----------------
                if(trigger.isUpdate){                    
                    ActualizarCamposActivo_cls ac = new ActualizarCamposActivo_cls();
                    ac.Actualizar(trigger.new[0]);
                    clsActualizarCompensacion.ActualizarCompensacionesXPlan(trigger.new);
                }
            }
        }
        if (trigger.isBefore) {
            CalculoValoresMonetarios_cls CalculoValoresMonetarios = new CalculoValoresMonetarios_cls();
            CalculoValoresMonetarios.CalcularValoresMonetarios(trigger.newMap, trigger.oldMap, trigger.isUpdate);
            if (trigger.isUpdate && !BanderasEjecucion.ValidarEjecucion('OperacionComercialisBeforeUpdate')) {
                AutomatizacionEstadosActivosETB_cls AutomatizacionEstadosActivosETB = new AutomatizacionEstadosActivosETB_cls();
                AutomatizacionEstadosActivosETB.ActualizarActivos(trigger.newMap, trigger.oldMap);
                ObtencionNombreCuentaCorreo_cls.ObtenerNombreCuentaOC(trigger.newMap, trigger.oldMap);
                //ContingenciaIntegracionSIEBEL_cls.DeterminarHomologacion(trigger.newMap, trigger.oldMap);
                ocClass.validarGestionFinanciera(trigger.newMap,trigger.oldMap);
                ocClass.validacionesExperienciaCliente(trigger.newMap);
                ConstruccionCanonico_cls fac = new ConstruccionCanonico_cls();                
                fac.llamadoFacturacion(trigger.newMap,trigger.oldMap);
                //JDUR Actuaizar fecha de entrega de un equipo vendido
                LTE_ActualizarEquipoTraido_cls actualizarEquipoTraido = new LTE_ActualizarEquipoTraido_cls();
                actualizarEquipoTraido.actualizarEquipoEntregado(trigger.newMap, trigger.oldMap);
            }
            if(trigger.isUpdate){
                //ocClass.clonarOCACT(Trigger.oldMap, Trigger.newMap);
                Set <Id> lstOCAPNDeclinacion = new Set <Id>();
                List<Numero__c> lstNumeroAbreviadoDeclinacion = new List<Numero__c>();
                Set<Id> lstTOPP = new Set<Id>();
                Map<Id,TOPP__c> mapTOPP = new Map<Id,TOPP__c>();
                list<ActivoETB__c> lstActivoCuentaFact = new List<ActivoETB__c>();//1.9
                //Map<Id,TOPP__c> mapTOPPCuentaFact = new Map<Id,TOPP__c>();//1.9
                List<ActivoETB__c> lstActivoCanDecli = new List<ActivoETB__c>();
                Map<String,List<Map<String,String>>> mpListaValores = new Map<String,List<Map<String,String>>>();
                mpListaValores = PS_IntegrationHelper_ctr.ObtenerListaValores('Nube_Publica__mdt','');
                for(OperacionComercial__c sglOC:trigger.new){
                    if(sglOC.TOPP__c!=null){
                        //if(sglOC.TOPP__c != Trigger.oldMap.get(sglOC.Id).TOPP__c){
                            lstTOPP.add(sglOC.TOPP__c);
                        //}
                        //mapTOPPCuentaFact = new Map<Id,TOPP__c>([SELECT Id, TipodeOperacionporplan__c FROM TOPP__c WHERE Id=:sglOC.TOPP__c]);//1.9
                        //if(mapTOPPCuentaFact.get(sglOC.TOPP__c).TipodeOperacionporplan__c =='Cambio Cuenta de Facturacion'){
                        //    lstTOPP.add(sglOC.TOPP__c);
                        //}
                    }
                }
                if(!lstTOPP.isEmpty()){
                    mapTOPP = new Map<Id,TOPP__c>([SELECT Id, Aplica_Tipologia_Preventa__c, TipodeOperacionporplan__c FROM TOPP__c WHERE Id IN :lstTOPP]);
                }
                for(OperacionComercial__c sglOC:trigger.new){
                    if(sglOC.Estado__c=='Declinada' && sglOC.Estado__c != Trigger.oldMap.get(sglOC.Id).Estado__c && String.isNotBlank(sglOC.APN__c)){
                        lstOCAPNDeclinacion.add( (String.isNotBlank(sglOC.Tipo_de_APN__c))?sglOC.Oportunidad__c:sglOC.Id );
                    }
                    if(sglOC.Estado__c=='Declinada' && sglOC.Estado__c != Trigger.oldMap.get(sglOC.Id).Estado__c && sglOC.Libero_Numero_Abreviado__c == false){
                        if(sglOC.Numero_Abreviado__c!=null){
                            Numero__c sglNumero = new Numero__c(Id=sglOC.Numero_Abreviado__c,Cuenta__c = null,Estado__c = 'Disponible',OperacionComercial__c = null);
                            lstNumeroAbreviadoDeclinacion.add(sglNumero);
                            sglOC.Libero_Numero_Abreviado__c = true;
                        }
                       /* if(sglOC.Numero_Abreviado_segunda_opcion__c!=null){
                            Numero__c sglNumero = new Numero__c(Id=sglOC.Numero_Abreviado_segunda_opcion__c,Cuenta__c = null,Estado__c = 'Disponible',OperacionComercial__c = null);
                            lstNumeroAbreviadoDeclinacion.add(sglNumero);
                            sglOC.Libero_Numero_Abreviado__c = true;                  
                        }*/
                    }
                    if(sglOC.Estado__c=='Declinada' && sglOC.Estado__c != Trigger.oldMap.get(sglOC.Id).Estado__c && sglOC.Fidelizacion__c != null){
                        ActivoETB__c slgActivo = new ActivoETB__c(id=sglOC.Activo__c,Retencion_Servicio__c=null);
                        lstActivoCanDecli.add(slgActivo);
                    }
                    //if(sglOC.Estado__c=='Facturado' && sglOC.Estado__c != Trigger.oldMap.get(sglOC.Id).Estado__c)
                        //sglOC.Usuario_Revisado_Facturacion__c = system.UserInfo.getUserId();
                    if(sglOC.TOPP__c!=null && !mapTOPP.isEmpty()){
                        if(mapTOPP.containskey(sglOC.TOPP__c)){
                            if(sglOC.CreatedDate>Datetime.newInstance(2017, 8, 14) && mapTOPP.get(sglOC.TOPP__c).Aplica_Tipologia_Preventa__c && sglOC.TOPP__c != Trigger.oldMap.get(sglOC.Id).TOPP__c){
                                sglOC.Aplica_Tipologia_Preventa__c = true;
                            }
                            if(sglOC.Estado__c=='Facturado' && sglOC.Estado__c != Trigger.oldMap.get(sglOC.Id).Estado__c && mapTOPP.get(sglOC.TOPP__c).TipodeOperacionporplan__c =='Cambio Cuenta de Facturacion'){//1.9
                                //sglOC.Aplica_Tipologia_Preventa__c = true;
                                ActivoETB__c sglActivo = new ActivoETB__c(Id=SglOC.Activo__c,CuentaFacturacion__c = sglOC.CuentaFacturacion__c);
                                lstActivoCuentaFact.add(sglActivo);
                            }
                        }
                    }
                    //SAO asignar el campo tipo facturacion segun la validacion en el valor recurrente y valor unico al modificarsen
                    if (sglOC.ValorTarifaPlan__c != 0 && sglOC.Valorunicavez__c != 0) 
                        sglOC.TipoFacturacion__c = Label.CobroUnicoRecurrente;
                    else if (sglOC.ValorTarifaPlan__c == 0 && sglOC.Valorunicavez__c != Trigger.oldMap.get(sglOC.Id).Valorunicavez__c) 
                        sglOC.TipoFacturacion__c = Label.CobroUnico;
                    else if(sglOC.ValorTarifaPlan__c != Trigger.oldMap.get(sglOC.Id).ValorTarifaPlan__c && sglOC.Valorunicavez__c == 0)
                        sglOC.TipoFacturacion__c = Label.CobroRecurrente;
                    //Implementación de la matriz de homologación para la integración con SIEBEL -- Clase ContingenciaIntegracionSIEBEL
                    if (sglOC.Estado_SIEBEL__c != null && sglOC.Estado_SIEBEL__c != Trigger.oldMap.get(sglOC.id).Estado_SIEBEL__c) {
                        //  Estado SIEBEL: Cancelado
                        if ( sglOC.Estado_SIEBEL__c == 'Cancelado') {
                            sglOC.EstadoAprovisionamiento__c = 'Cerrado';
                            sglOC.Estado__c = 'Declinada';
                            sglOC.FechadeActivacion__c = Trigger.oldMap.get(sglOC.id).FechadeActivacion__c;
                            sglOC.NumeroConexion__c = Trigger.oldMap.get(sglOC.id).NumeroConexion__c;
                        }
                        //  Estado SIEBEL: Completo
                        else if (sglOC.Estado_SIEBEL__c == 'Completo') {
                            sglOC.EstadoAprovisionamiento__c = 'Cerrado';
                            sglOC.Estado__c = 'Activa';
                        }
                        //  Estado diferente a los especificados en la matriz de homologación
                        else {
                            sglOC.Estado_SIEBEL__c = Trigger.oldMap.get(sglOC.id).Estado_SIEBEL__c;
                            sglOC.FechadeActivacion__c = Trigger.oldMap.get(sglOC.id).FechadeActivacion__c;
                        }
                    }                    
                    if(sglOC.RecordTypeId == Schema.Sobjecttype.OperacionComercial__c.getRecordTypeInfosByName().get('Venta_NubePublica').getRecordTypeId() &&
                       sglOC.TipodeServicioMS__c == 'Nube Pública AWS CCE' && sglOC.Estado__c=='Pendiente'){
                           sglOC.Identificacion_Colombia_Compra_Eficiente__c = '';
                           ocClass.actualizarCodigoCCE(Trigger.newMap, mpListaValores);
                       }
                }
                if(!lstOCAPNDeclinacion.isEmpty())
                    ProcesosAPN_cls.OCDesasociaAPN(lstOCAPNDeclinacion, Schema.OperacionComercial__c.getSObjectType(), trigger.NewMap);
                if(!lstNumeroAbreviadoDeclinacion.isEmpty())
                    update lstNumeroAbreviadoDeclinacion;
                if(!lstActivoCuentaFact.isEmpty())//1.9
                    update lstActivoCuentaFact;
                if(!lstActivoCanDecli.isEmpty())
                    update lstActivoCanDecli;
				
				// Astrid Leiva
                 // No permite modificar los campos de Valor recurrente Aliado y Valor recurrente ETB para Venta de Negocio Seguro
                /*Id idOCRecordTypeVenta = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta').getRecordTypeId();
                List<Planes__c> Plan_Negocio_Seguro = new List<Planes__c>([SELECT id FROM Planes__c WHERE NombredelProducto__r.Name ='Negocio Seguro']);
                Set<Id> setIdcuentas = new Set<Id>();              
                for(OperacionComercial__c sglOC : trigger.new)
                {
                    if(sglOC.RecordTypeId == idOCRecordTypeVenta && sglOC.Plan__c == Plan_Negocio_Seguro[0].id )
                    {
                        if (trigger.oldMap.get(sglOC.Id).ValorTarifaPlan__c!= 0 && trigger.oldMap.get(sglOC.Id).Valor_Recurrente_Aliado__c != 0){
                            Double valor_anterioir_ETB = trigger.oldMap.get(sglOC.Id).ValorTarifaPlan__c;
                            Double valor_anterioir_Aliado = trigger.oldMap.get(sglOC.Id).Valor_Recurrente_Aliado__c;
                            
                            if(sglOC.ValorTarifaPlan__c != valor_anterioir_ETB ){
                                sglOC.ValorTarifaPlan__c.addError('No Puede modificar el Valor recurrente ETB');
                            }
                            if(sglOC.Valor_Recurrente_Aliado__c != valor_anterioir_Aliado ){
                                sglOC.Valor_Recurrente_Aliado__c.addError('No Puede modificar el Valor recurrente Aliado');
                            }
                        }

                        setIdcuentas.add(sglOC.CuentaCliente__c);
                                                
                    }
                    
                    
                }

                // Seleccionar la OC Relacionada para Negocio Seguro y Servicio principal
                Set<String> setProductosPrincipales = new Set<String>{'Internet Dedicado',
                'Internet + Empresarial',
                'Conectividad Avanzada IP',
                'Internet Corporativo Gpon',
                'Conectividad Corporativa Gpon'};

                List<OperacionComercial__c> listOCServicioPrincipal = new List<OperacionComercial__c>([SELECT id FROM OperacionComercial__c WHERE Plan__r.NombredelProducto__r.Name IN: setProductosPrincipales  AND CuentaCliente__c IN: setIdcuentas AND Estado__c != 'Pendiente' AND Estado__c != 'En Curso' AND Estado__c != 'Declinada']);
                List<OperacionComercial__c> listOCServicioPrincipal2 = new List<OperacionComercial__c>([SELECT id FROM OperacionComercial__c WHERE Plan__r.NombredelProducto__r.Name IN: setProductosPrincipales  AND CuentaCliente__c IN: setIdcuentas AND Legalizacion__r.Estado__c = 'Gestionado']);
				System.debug('setIdcuentas -> '+ setIdcuentas);
                Set<Id> Id_lOCSP = new Set<Id>();

                for(OperacionComercial__c m :listOCServicioPrincipal){ 
                    Id_lOCSP.add(m.Id); 
                } 
                for(OperacionComercial__c m :listOCServicioPrincipal2){ 
                    Id_lOCSP.add(m.Id); 
                } 

                for(OperacionComercial__c sglOC : trigger.new)
                {
                    if(sglOC.RecordTypeId == idOCRecordTypeVenta && sglOC.Plan__c == Plan_Negocio_Seguro[0].id )
                    {
                        Id valor_anterioir_OC_Relacionada = trigger.oldMap.get(sglOC.Id).Operacion_Comercial_Relacionada__c;
                        system.debug('valor_anterioir_OC_Relacionada -> ' + valor_anterioir_OC_Relacionada);
                        system.debug('sglOC.Operacion_Comercial_Relacionada__c -> ' + sglOC.Operacion_Comercial_Relacionada__c);
                        if(sglOC.Operacion_Comercial_Relacionada__c == valor_anterioir_OC_Relacionada && sglOC.Operacion_Comercial_Relacionada__c != null ){
                            if(!Id_lOCSP.contains(sglOC.Operacion_Comercial_Relacionada__c) ){
                           		 sglOC.Operacion_Comercial_Relacionada__c.addError('No se puede asociar debido 1) La Operacion comercial relacioanda no pertenece a alguno de estos productos Internet Dedicado, Internet + Empresarial, Conectividad Avanzada IP, Internet Corporativo Gpon, Conectividad Corporativa Gpon. 2) La Operacion Comercial Relacionada no pertenece al misma Cuenta Cliente.');
                        	} 
                        } 
                           
                    }
                }    */          
                
                 //Fin  Astrid Leiva
	
            }
            if(trigger.isInsert){
                //if(!BanderasEjecucion.ValidarEjecucion('OperacionComercialisBeforeInsert')){
                    //valOC.ValidarOperacionComercial(trigger.new);
                    //valOC.planAnterior(trigger.new);
                    //valOC.planAnteriorBandaAncha(trigger.new);
                //}

                Set<Id> lstTopp = new Set<Id>();
                Set<Id> lstPlan = new Set<Id>();
                set<id> lstAccountId = new set<id>();
                set<string> lstActivos = new set<string>();
                Set<Id> lstOpp = new Set<Id>(); 
                Map<Id,TOPP__c> mapTopp = new Map<Id,TOPP__c>();
                Map<Id,Planes__c> mapPlan = new Map<Id,Planes__c>();
                Map<Id,ActivoETB__c> mapActivos = new Map<Id,ActivoETB__c>();
                Map<Id,Account> mapAccount = new Map<Id,Account>();
                Map<Id,Opportunity> mapOpp = new Map<Id,Opportunity>();
                Map<String,List<Map<String,String>>> mpListaValores = new Map<String,List<Map<String,String>>>();
                mpListaValores = PS_IntegrationHelper_ctr.ObtenerListaValores('Nube_Publica__mdt','');
                for(OperacionComercial__c sglOC:trigger.new){
                    if(sglOC.TOPP__c!=null){
                        lstTopp.add(sglOC.TOPP__c);
                    }
                    if(sglOC.Plan__c!=null){
                        lstPlan.add(sglOC.Plan__c);
                    }
                    if(sglOC.Activo__c!=null){
                        lstActivos.add(sglOC.Activo__c);
                    }
                    if(sglOC.CuentaCliente__c!=null)
                        lstAccountId.add(sglOC.CuentaCliente__c);
                        if(sglOC.Oportunidad__c != null)
                        lstOpp.add(sglOC.Oportunidad__c);    
                }
                if(!lstTopp.isEmpty()){
                    mapTopp = new Map<Id,TOPP__c>([SELECT Id, Name, Plan__c, Plan__r.NombredelProducto__r.Name,Plan__r.NombredelProducto__r.Catalogo__c,LTE_Catalogo_de_Producto__c,LTE_Catalogo_de_Producto__r.Name,LTE_Catalogo_de_Producto__r.Catalogo__c, Plan__r.Name,Plan__r.Tipo_de_Servicio__c, TipodeOperacionporplan__c FROM TOPP__c WHERE Id IN :lstTopp]);
                }
                if(!lstPlan.isEmpty()){
                    mapPlan = new Map<Id,Planes__c>([SELECT Id, Name, NombredelProducto__r.Name, NombredelProducto__r.Catalogo__c,TipodePlan__c FROM Planes__c WHERE Id IN :lstPlan]);
                }
                if(!lstActivos.isEmpty()){
                    mapActivos = new Map<Id,ActivoETB__c>([SELECT Id,Plan__c,Plan__r.Name,AnchoBanda__c, AnchoBanda__r.Name,NombredelProducto__r.Name, Activo_Relacionado__r.NombredelProducto__r.Name, Activo_Relacionado__r.Estado__c FROM ActivoETB__c WHERE Id IN :lstActivos]);
                }
                if(!lstAccountId.isEmpty()){
                    mapAccount = new Map<Id,Account>([select id ,OwnerId,Segmento__c from Account WHERE Id IN :lstAccountId]);
                }
                if(!lstOpp.isEmpty()){
                    mapOpp = new Map<Id,Opportunity>([select id,ComponenteDeLaPromocion__c from Opportunity WHERE Id IN :lstOpp]);
                }
                for(OperacionComercial__c sglOC:trigger.new){
                    //if(sglOC.Estado__c=='Facturado'/* && sglOC.Estado__c != Trigger.oldMap.get(sglOC.Id).Estado__c*/)
                        //sglOC.Usuario_Revisado_Facturacion__c = system.UserInfo.getUserId();
                    if(sglOC.TOPP__c!=null){
                        if(mapTopp.containskey(sglOC.TOPP__c)){
                            if(!String.isEmpty(mapTopp.get(sglOC.TOPP__c).Plan__r.Tipo_de_Servicio__c)){
                                sglOC.TipodeServicioMS__c = 'Negocio-'+mapTopp.get(sglOC.TOPP__c).Plan__r.Tipo_de_Servicio__c;
                            }
                            if(mapTopp.get(sglOC.TOPP__c).Plan__r.Name == 'Plan Colocación Desborde' && String.isEmpty(sglOC.Operador_Desborde__c))
                                sglOC.Operador_Desborde__c = 'oData';
                            String sCatalogo = '';
                            if(mapTopp.get(sglOC.TOPP__c).Plan__c!=null){
                                sCatalogo = mapTopp.get(sglOC.TOPP__c).Plan__r.NombredelProducto__r.Catalogo__c;
                            }else{
                                if(mapTopp.get(sglOC.TOPP__c).LTE_Catalogo_de_Producto__c!=null){
                                    sCatalogo = mapTopp.get(sglOC.TOPP__c).LTE_Catalogo_de_Producto__r.Catalogo__c;
                                }
                            }
                            sglOC.Integrar_con_gestor__c = String.isEmpty(sCatalogo)?false:(sCatalogo=='Portafolio Superior');
                            if(sglOC.Estado__c=='Pendiente' && mapTopp.get(sglOC.TOPP__c).TipodeOperacionporplan__c=='Cambio de Plan' && sglOC.Activo__c!=null){
                                if(mapActivos.containsKey(sglOC.Activo__c))
                                {
                                    sglOC.planAnterior__c = mapActivos.get(sglOC.Activo__c).Plan__c==null?'':mapActivos.get(sglOC.Activo__c).Plan__r.Name;
                                    sglOC.AnchoBandaAnt__c = mapActivos.get(sglOC.Activo__c).AnchoBanda__c==null?'':mapActivos.get(sglOC.Activo__c).AnchoBanda__r.Name;
                                }
                            }
                        }
                    }
                    //Esta asignacion se debe hacer despues de la validacion del topp
                    if(sglOC.Plan__c!=null){
                        if(mapPlan.containskey(sglOC.Plan__c)){
                                if(mapPlan.get(sglOC.Plan__c).NombredelProducto__c!=null){
                                    if(mapPlan.get(sglOC.Plan__c).NombredelProducto__r.Catalogo__c == 'Aliado' || (mapPlan.get(sglOC.Plan__c).NombredelProducto__r.Name=='TELEFONIA MOVIL (LTE)' && (mapPlan.get(sglOC.Plan__c).TipodePlan__c=='Troncal SIP' || mapPlan.get(sglOC.Plan__c).Name=='Troncal SIP Móvil Alterna'))){
                                        sglOC.Integrar_con_gestor__c = true;
                                    }
                                    //actualizar campo de control para la lista de selección del campo ARPU.                                    
                                    List<String> pickListValuesList = new List<String>();
                                    Schema.DescribeFieldResult fieldResult = OperacionComercial__c.Nombre_del_plan__c.getDescribe();
                                    List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
                                    for( Schema.PicklistEntry pickListVal : picklistValues){                                        
                                        if(mapPlan.get(sglOC.Plan__c).Name == pickListVal.getLabel())
                                            sglOC.Nombre_del_plan__c = mapPlan.get(sglOC.Plan__c).Name;   
                                    }                                   
                                }
                        }                        
                    }
                    if(sglOC.CuentaCliente__c!=null){
                        if(mapAccount.containskey(sglOC.CuentaCliente__c)){
                            //Propietario de la OC debe ser el propietario de la cuenta
                            //No aplica para segmento MiPymes
                            if(mapAccount.get(sglOC.CuentaCliente__c).Segmento__c != 'MiPymes')
                                sglOC.OwnerId = mapAccount.get(sglOC.CuentaCliente__c).OwnerId;
                        }
                    }
                    // Se agrega la promoción que tiene la oportunidad a la operación comercial
                    // Mary Y. Boyacá may.yuliana.boyaca@accenture.com 01/17/2021
                    if(sglOC.Oportunidad__c != null && mapOpp.get(sglOC.Oportunidad__c) != null ){
                        sgloc.ComponenteCampana__c = mapOpp.get(sglOC.Oportunidad__c).ComponenteDeLaPromocion__c;
                    }
                    if(sglOC.ValorTarifaPlan__c != 0 && sglOC.Valorunicavez__c == 0)
                        sglOC.TipoFacturacion__c = Label.CobroRecurrente;
                    else if (sglOC.ValorTarifaPlan__c == 0 && sglOC.Valorunicavez__c != 0) 
                        sglOC.TipoFacturacion__c = Label.CobroUnico; 
                    else if (sglOC.ValorTarifaPlan__c != 0 && sglOC.Valorunicavez__c != 0) 
                        sglOC.TipoFacturacion__c = Label.CobroUnicoRecurrente;
                    /*
                    if(sglOC.RecordTypeId == Schema.Sobjecttype.OperacionComercial__c.getRecordTypeInfosByName().get('Venta_NubePublica').getRecordTypeId() &&
                        sglOC.TipodeServicioMS__c == 'Nube Pública AWS CCE'){
                        sglOC.Identificacion_Colombia_Compra_Eficiente__c = '';
                        ocClass.actualizarCodigoCCE(Trigger.newMap, mpListaValores);
                    }    */           
                }
				
                //Se bloquea la posibilidad de crear una Operación Comercial del tipo Retiro
                //sobre ciertos Productos que cuenten con un Negocio Seguro activo

                Set<String> setProductosNegocioSeguro = new Set<String>{'Internet Dedicado',
                                                                        'Internet + Empresarial',
                                                                        'Conectividad Avanzada IP',
                                                                        'Internet Corporativo Gpon',
                                                                        'Conectividad Corporativa Gpon'};

                Id idOCRecordTypeRetiros = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByDeveloperName().get('Retiros').getRecordTypeId();
                
                List<Messaging.Email> lstEmailsMasivo = new List<Messaging.Email>();
                OrgWideEmailAddress emailNoResponder = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = 'no-responder@etb.com.co'];
				String emailUsuario = UserInfo.getUserEmail();
                String URLBase = URL.getOrgDomainUrl().toExternalForm();
                System.debug('Email del Usuario que intenta crear la OC: ' + emailUsuario);
                System.debug('Email del Remitente No Responder: ' + emailNoResponder.Address);
                
				for(OperacionComercial__c sglOC : trigger.new){
                    if(sglOC.Activo__c!=null){

                        //Se identifica el Activo relacionado a la OC
                        ActivoETB__c activoOC = mapActivos.get(sglOC.Activo__c);

                        System.debug(sglOC.RecordTypeId);
                        System.debug(activoOC.NombredelProducto__r.name);
                        System.debug(activoOC.Activo_Relacionado__r.NombredelProducto__r.name);
                        System.debug(activoOC.Activo_Relacionado__r.Estado__c);
                        
                    	if(sglOC.RecordTypeId == idOCRecordTypeRetiros && setProductosNegocioSeguro.contains(activoOC.NombredelProducto__r.name) &&
                           activoOC.Activo_Relacionado__r.NombredelProducto__r.name == 'Negocio Seguro' && activoOC.Activo_Relacionado__r.Estado__c == 'Activo'){
                            System.debug('Ingresó al condicional de Negocio Seguro');
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
							email.setOrgWideEmailAddressId(emailNoResponder.Id);
                            String[] emailPara = new String[] {emailUsuario};
                            email.setToAddresses(emailPara);
                            email.setSubject('No es posible crear la Operación Comercial solicitada');
                            
                            email.setHtmlBody('<p>Estimado/a,</p>'+
                                              '<p>No se pudo crear la Operación Comercial del tipo Retiro debido a que el Producto principal ' + activoOC.NombredelProducto__r.name + ' cuenta con un Producto Negocio Seguro relacionado y activo.</p>'+
                                              '<p>Puede corroborar esta información ingresando al Activo del producto principal haciendo <a href='+URLBase+'/lightning/r/ActivoETB__c/'+activoOC.Id+'/view>click aquí.</a></p>'+
                                              '<p>Desde ya, muchas gracias.</p>');
                            
                            lstEmailsMasivo.add(email);
                            sglOC.addError('El producto principal ' + activoOC.NombredelProducto__r.name + ' aún cuenta con un Negocio Seguro activo');
                        }
                    }
                }

                if(lstEmailsMasivo.size() > 0){
                    List<Messaging.SendEmailResult> envioEmailsMasivoResultado = Messaging.sendEmail(lstEmailsMasivo);
                    System.debug(envioEmailsMasivoResultado);
                }
            }
        }
        if (trigger.isAfter) {
            //ActualizarCamposActivo_cls ac = new ActualizarCamposActivo_cls(); //[CG] - Nuevo 12/07/2016
            //  Bloque de ejecución After Insert
            if (trigger.isInsert) {
                //ocClass.marcarsolucionTI(trigger.new);
                ProcesosAPN_cls.SVA_APN(trigger.new);
                //if(!Test.isRunningTest())
                //  ac.actualizarCtaFacturacion(trigger.new[0]); //[CG] - Nuevo 12/07/2016
                Set<Id> lstTOPP = new Set<Id>();
                Map<Id,TOPP__c> mapTOPP = new Map<Id,TOPP__c>();
                Set<Id> lstPlan = new Set<Id>();
                Map<Id,Planes__c> mapPlan = new Map<Id,Planes__c>();
                for(OperacionComercial__c sglOC:trigger.new){
                    if(sglOC.TOPP__c!=null){
                        lstTOPP.add(sglOC.TOPP__c);
                    }
                }
                System.Debug('lstTOPP '+lstTOPP);
                if(!lstTOPP.isEmpty()){
                    mapTOPP = new Map<Id,TOPP__c>([SELECT Id,Plan__c, Plan__r.NombreDelProducto__r.Familia__c,Plan__r.NombreDelProducto__r.Name,TipodeOperacionporplan__c, Aplica_Tipologia_Preventa__c, (SELECT Id, Name,LTE_SubPlaFacturacion__c FROM Servicios_adicionales__r) FROM TOPP__c WHERE Id IN :lstTOPP]);
                }
                if(!mapTOPP.values().isEmpty()){
                    for(TOPP__c topp:mapTOPP.values()){
                        lstPlan.add(topp.Plan__c);
                    }
                }
                if(!lstPlan.isEmpty()){
                    mapPlan = new Map<Id,Planes__c>([SELECT Id,NombreDelProducto__r.Familia__c,NombreDelProducto__r.Name FROM Planes__c WHERE Id IN :lstPlan ]);
                }
                list<ActivoETB__c> lstActivoPortacion = new List<ActivoETB__c>();
                Map<Id,Fidelizacion_Servicio__c> mapRetencion = new Map<Id,Fidelizacion_Servicio__c>();
                List<LTE_Servicios_adicionales__c> lstServicioAdicional = new List<LTE_Servicios_adicionales__c>();
                Map<Id, Opportunity> listOpp = new Map<Id, Opportunity>();
                //miguel.rafael.gomez@accenture.com. Cambio para el enrutamiento de cobro revertido. 27/01/22
                List <OperacionComercial__c> lstOCEnrutamientos = new List <OperacionComercial__c>(); 
                for(OperacionComercial__c sglOC:trigger.new){
                    if(sglOC.Portado_con_Cedula__c==true && sglOC.Contacto_Relacionado__c!=null){
                        ActivoETB__c sglActivo = new ActivoETB__c(Id=SglOC.Activo__c,LTE_Contacto_relacionado__c = sglOC.Contacto_Relacionado__c);
                        lstActivoPortacion.add(sglActivo);
                    }
                    if(sglOC.Fidelizacion__c!=null && sglOC.RecordTypeId == Schema.Sobjecttype.OperacionComercial__c.getRecordTypeInfosByName().get('Retiros').getRecordTypeId()){
                        if(!mapRetencion.containsKey(sglOC.Fidelizacion__c)){
                            Fidelizacion_Servicio__c sglRetencion = new Fidelizacion_Servicio__c(Id=sglOC.Fidelizacion__c,No_Generar_Oc_de_Retiro__c = true);
                            mapRetencion.put(sglOC.Fidelizacion__c,sglRetencion);
                        }
                    }
                    if(sglOC.TOPP__c!=null){
                        if(mapTOPP.containskey(sglOC.TOPP__c)){
                            if(mapTOPP.get(sglOC.TOPP__c).Servicios_adicionales__r.size()>0){
                                for(LTE_Servicios_adicionales__c sglRelatedSVA:mapTOPP.get(sglOC.TOPP__c).Servicios_adicionales__r){
                                    LTE_Servicios_adicionales__c objAdicional = new LTE_Servicios_adicionales__c();
                                    objAdicional.Name = sglRelatedSVA.Name;
                                    objAdicional.LTE_SubPlaFacturacion__c = sglRelatedSVA.LTE_SubPlaFacturacion__c;
                                    objAdicional.LTE_Operacion_Comercial_SVA__c = sglOC.Id;
                                    objAdicional.LTE_ServicioETB__c = sglOC.Activo__c;
                                    lstServicioAdicional.add(objAdicional);
                                }
                            }
                            //si la operacion comercial que se crea es de soluciones TI, debe marcar la oportunidad como "tiene solucion TI"
                            if(mapTOPP.get(sglOC.TOPP__c).Plan__r.NombreDelProducto__r.Familia__c=='SOLUCIONES TI'){
                                if(sglOC.Oportunidad__c!=null && sglOC.Oportunidad__r.TieneServicioSolucionTI__c == false){
                                    Opportunity op = new Opportunity(Id = sglOC.Oportunidad__c);
                                    op.TieneServicioSolucionTI__c=true;
                                    listOpp.put(sglOC.Oportunidad__c, op);
                                }
                            }
                        }
                        //miguel.rafael.gomez@accenture.com. CAmbio para el enrutamiento de cobro revertido. 27/01/22
                    System.debug('Oc-->'+sglOC);
                    System.debug('Mapppa-->'+mapTOPP.get(sglOC.TOPP__C));
                    System.debug('Mapppa2-->'+mapPlan.get(mapTOPP.get(sglOC.TOPP__C).Plan__c));
                    if(sglOC.Enrutamientos__c!=null && mapTOPP.get(sglOC.TOPP__C).TipodeOperacionporplan__c == 'Venta'  
                       && mapPlan.get(mapTOPP.get(sglOC.TOPP__C).Plan__c).NombreDelProducto__r.Name == 'Cobro revertido automatico')
                        {
                            lstOCEnrutamientos.Add(sglOC);
                        }
                    }
                }
                if(!lstActivoPortacion.isEmpty())
                    update lstActivoPortacion;
                if(!mapRetencion.isEmpty())
                    update mapRetencion.values();
                if(!lstServicioAdicional.isEmpty())
                    insert lstServicioAdicional;
                if(!listOpp.isEmpty())
                    update listOpp.values();
                // Se agrega el metodo para la historia de la actualización del servicio relacionado, dependiendo del enrutamiento
                // Miguel R. Gómez miguel.rafael.gomez@accenture.com 27/12/2021
                if(OperacionComercialHandler_cls.isFirstTime && !lstOCEnrutamientos.isEmpty())    
                {
                    System.debug('Entró al if');
                    OperacionComercialHandler_cls.ActualizarServicioEnrutamiento(lstOCEnrutamientos, Trigger.Old);
                }
            }
            if (trigger.isUpdate)
            {
                ocClass.obtenerCamposOC(trigger.newMap.keySet());
                Map<Id,OperacionComercial__c> actualOC = ocClass.ocMap;
                ocClass.actualizarSASpecificationGroupXAActivoRepoReno(Trigger.oldMap, Trigger.newMap);
                //if(!Test.isRunningTest()){
                //  ac.actualizarCtaFacturacion(trigger.new[0]); //[CG] - Nuevo 12/07/2016
                //}
                //if(!Test.isRunningTest()){
                    //Se actualiza los LTE_SpecificationGroupXA__c
                //}
                //AO.ActualizarOportunidad(trigger.newmap);
                List <OperacionComercial__c> lstOCAPN = new List <OperacionComercial__c>();
                List<Numero__c> lstNumeroAbreviado = new List<Numero__c>();
                List<Numero__c> lstNumeroAbreviadoAsginado = new List<Numero__c>();
                List<Legalizacion__c> lstLegalizacionPortada = new List<Legalizacion__c>();
                list<ActivoETB__c> lstActivoPortacion = new List<ActivoETB__c>();
                Map<Id,List <OperacionComercial__c>> mapOCAutomatica = new Map<Id,List <OperacionComercial__c>>();
                List <OperacionComercial__c> lstOCTroncalSIP = new List <OperacionComercial__c>();
                List <OperacionComercial__c> lstOCEnrutamientos = new List <OperacionComercial__c>();
                List<Id> lstIdNumeroAnterior = new  List<Id>();
                for(OperacionComercial__c sglOC:trigger.new){
                    if(String.isNotBlank(sglOC.Tipo_de_APN__c) && sglOC.Tipo_de_APN__c != Trigger.oldMap.get(sglOC.Id).Tipo_de_APN__c){
                        lstOCAPN.add(sglOC);
                    }
                    if(sglOC.TOPP__c!=null && sglOC.Estado__c!='Declinada'){
                        //List<Id> lstIdNumeroAnterior = new  List<Id>();
                        if(sglOC.Numero_Abreviado__c!=Trigger.oldMap.get(sglOC.Id).Numero_Abreviado__c && sglOC.Numero_Abreviado__c!=null){
                            Numero__c sglNumero = new Numero__c(Id=sglOC.Numero_Abreviado__c,Cuenta__c = sglOC.CuentaCliente__c,Estado__c = 'Reservado',OperacionComercial__c = sglOC.Id);
                            lstNumeroAbreviado.add(sglNumero);
                            if(Trigger.oldMap.get(sglOc.Id).Numero_Abreviado__c != NULL){
                                lstIdNumeroAnterior.add(Trigger.oldMap.get(sglOc.Id).Numero_Abreviado__c);
                            }
                        }
                        /*if(sglOC.Numero_Abreviado_segunda_opcion__c!=Trigger.oldMap.get(sglOC.Id).Numero_Abreviado_segunda_opcion__c && sglOC.Numero_Abreviado_segunda_opcion__c!=null){
                            Numero__c sglNumero = new Numero__c(Id=sglOC.Numero_Abreviado_segunda_opcion__c,Cuenta__c = sglOC.CuentaCliente__c,Estado__c = 'Reservado',OperacionComercial__c = sglOC.Id);
                            lstNumeroAbreviado.add(sglNumero);
                            if(Trigger.oldMap.get(sglOc.Id).Numero_Abreviado_segunda_opcion__c != NULL){
                                lstIdNumeroAnterior.add(Trigger.oldMap.get(sglOc.Id).Numero_Abreviado_segunda_opcion__c);
                            }
                        }*/
                        /*if(lstIdNumeroAnterior != NULL){
                        List<Numero__c>lstOldNumero = [SELECT Id,Estado__c,OperacionComercial__c,Cuenta__c FROM Numero__c WHERE Id= :lstIdNumeroAnterior AND Estado__c ='Reservado' ];
                        if(lstOldNumero !=NULL){
                            for(Numero__c numero :lstOldNumero){
                                numero.Cuenta__c=null;
                                numero.OperacionComercial__c=null;
                                numero.Estado__c='Disponible';
                                lstNumeroAbreviado.add(numero);
                                }
                            }
                        } */
                    }
                    if(sglOC.Legalizacion__c!=null && sglOC.Portado_con_Cedula__c==true && sglOC.Portado_con_Cedula__c!=Trigger.oldMap.get(sglOC.Id).Portado_con_Cedula__c){
                        Legalizacion__c sglLegalizacion = new Legalizacion__c(Id=sglOC.Legalizacion__c,Portado_con_Cedula_c__c=true);
                        lstLegalizacionPortada.add(sglLegalizacion);
                    }
                    if(sglOC.Portado_con_Cedula__c==true && sglOC.Contacto_Relacionado__c!=null && (sglOC.Portado_con_Cedula__c!=Trigger.oldMap.get(sglOC.Id).Portado_con_Cedula__c || sglOC.Contacto_Relacionado__c!=Trigger.oldMap.get(sglOC.Id).Contacto_Relacionado__c)){
                        ActivoETB__c sglActivo = new ActivoETB__c(Id=SglOC.Activo__c,LTE_Contacto_relacionado__c = sglOC.Contacto_Relacionado__c);
                        lstActivoPortacion.add(sglActivo);
                    }
                    if(sglOC.TOPP__c!=null){
                        system.debug(sglOC.Estado__c+actualOC.get(sglOC.Id).TOPP__r.Name);
                        if(sglOC.Estado__c=='Facturado' && actualOC.get(sglOC.Id).TOPP__r.Operacion_Relacionada__c !=null && sglOC.Estado__c!=Trigger.oldMap.get(sglOC.Id).Estado__c ){
                            if(mapOCAutomatica.containskey(actualOC.get(sglOC.Id).TOPP__r.Operacion_Relacionada__c)){
                                mapOCAutomatica.get(actualOC.get(sglOC.Id).TOPP__r.Operacion_Relacionada__c).add(sglOC);
                            }else{
                                mapOCAutomatica.put(actualOC.get(sglOC.Id).TOPP__r.Operacion_Relacionada__c, new List<OperacionComercial__c>{sglOC});
                            }
                        }
                        if(actualOC.get(sglOC.Id).TOPP__r.Name=='Cambio de Plan- TELEFONIA MOVIL (LTE)' && 
                           actualOC.get(sglOC.Id).Plan__r.TipodePlan__c=='Troncal SIP' &&
                           (sglOC.Tarifa_mensual_Bolsa_de_Moviles__c!=Trigger.oldMap.get(sglOC.Id).Tarifa_mensual_Bolsa_de_Moviles__c || 
                            sglOC.Tarifa_mensual_Troncales_SIP__c!=Trigger.oldMap.get(sglOC.Id).Tarifa_mensual_Troncales_SIP__c || 
                            sglOC.NumeroCanales__c!=Trigger.oldMap.get(sglOC.Id).NumeroCanales__c || 
                            sglOC.Valor__c!=Trigger.oldMap.get(sglOC.Id).Valor__c
                           )
                          ){
                            lstOCTroncalSIP.add(sglOC);
                        }
                        //miguel.rafael.gomez@accenture.com. CAmbio para el enrutamiento de cobro revertido. 27/01/22
                        if(sglOC.Enrutamientos__c!=null && sglOC.Enrutamientos__c!=Trigger.oldMap.get(sglOC.Id).Enrutamientos__c &&
                        actualOC.get(sglOC.Id).TOPP__r.TipodeOperacionporplan__c == 'Venta'  && actualOC.get(sglOC.Id).Plan__r.NombredelProducto__r.Name == 'Cobro revertido automatico')
                        {
                            lstOCEnrutamientos.Add(sglOC);
                        }
                    }
                    if(sglOC.Legalizacion__c!=null && sglOC.Numero_Abreviado__c!=null &&(sglOC.Numero_Abreviado__c!=Trigger.oldMap.get(sglOC.Id).Numero_Abreviado__c || sglOC.Legalizacion__c!=Trigger.oldMap.get(sglOC.Id).Legalizacion__c)){
                        if(sglOC.Numero_Abreviado__r.Estado__c=='Reservado'){
                            Numero__c sglNumero = new Numero__c(Id=sglOC.Numero_Abreviado__c,Estado__c = 'Asignado');
                            lstNumeroAbreviadoAsginado.add(sglNumero);
                        }
                    }
                }
                // Se sacá la sentencia SOQL del for para evitar que alcance el limite de 100 sentencias. 
                // Miguel R. Gómez miguel.rafael.gomez@accenture.com 24/01/2022
                if(lstIdNumeroAnterior != NULL){
                    List<Numero__c>lstOldNumero = [SELECT Id,Estado__c,OperacionComercial__c,Cuenta__c FROM Numero__c WHERE Id= :lstIdNumeroAnterior AND Estado__c ='Reservado' ];
                if(lstOldNumero !=NULL){
                    for(Numero__c numero :lstOldNumero){
                        numero.Cuenta__c=null;
                        numero.OperacionComercial__c=null;
                        numero.Estado__c='Disponible';
                        lstNumeroAbreviado.add(numero);
                        }
                    }
                }
                if(!lstOCAPN.isEmpty())
                    ProcesosAPN_cls.SVA_APN(lstOCAPN);
                if(!mapOCAutomatica.isEmpty())
                    ocClass.CreacionOC(mapOCAutomatica,'Pendiente');
                if(!lstNumeroAbreviado.isEmpty())
                    update lstNumeroAbreviado;
                if(!lstNumeroAbreviadoAsginado.isEmpty())
                    update lstNumeroAbreviadoAsginado;
                if(!lstLegalizacionPortada.isEmpty())
                    update lstLegalizacionPortada;
                if(!lstActivoPortacion.isEmpty())
                    update lstActivoPortacion;
                if(!lstOCTroncalSIP.isEmpty()){
                    /*Se debe calcular automaticamente, esta es una solucion temporal*/
                    List<LTE_SpecificationGroupXA__c> lstXATroncalSIP = [SELECT Id, Name, Servicio_adicional1__c, LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c FROM LTE_SpecificationGroupXA__c WHERE LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c IN :trigger.newMap.keySet() AND Name IN ('RVC PARM Cargo LTE ETB','RVC PARM Cargo EMP ETB','RVC PARM CargoDS','RVC PARM Index DS')];
                    for(LTE_SpecificationGroupXA__c sglTroncalSIP:lstXATroncalSIP){
                        if(sglTroncalSIP.Name == 'RVC PARM Cargo LTE ETB')
                            sglTroncalSIP.LTE_Value__c=String.valueOf(Trigger.newMap.get(sglTroncalSIP.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c).Tarifa_mensual_Bolsa_de_Moviles__c);
                        if(sglTroncalSIP.Name == 'RVC PARM Cargo EMP ETB')
                            sglTroncalSIP.LTE_Value__c=String.valueOf(Trigger.newMap.get(sglTroncalSIP.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c).Tarifa_mensual_Troncales_SIP__c);
                        if(sglTroncalSIP.Name == 'RVC PARM CargoDS' && sglTroncalSIP.Servicio_adicional1__c=='Troncal SIP Canales')
                            sglTroncalSIP.LTE_Value__c=String.valueOf(Trigger.newMap.get(sglTroncalSIP.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c).Valor__c);
                        if(sglTroncalSIP.Name == 'RVC PARM Index DS' && sglTroncalSIP.Servicio_adicional1__c=='Troncal SIP Canales')
                            sglTroncalSIP.LTE_Value__c=String.valueOf(Trigger.newMap.get(sglTroncalSIP.LTE_ServiciosAdicionales__r.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c).NumeroCanales__c);
                    }
                    update lstXATroncalSIP;
                }
                // Se agrega el metodo para la historia de la actualización del servicio relacionado, dependiendo del enrutamiento
                // Miguel R. Gómez miguel.rafael.gomez@accenture.com 27/12/2021
                if(OperacionComercialHandler_cls.isFirstTime && !lstOCEnrutamientos.isEmpty())    
                {
                    System.debug('Entró al if');
                    OperacionComercialHandler_cls.ActualizarServicioEnrutamiento(lstOCEnrutamientos, Trigger.Old);
                }
                OperacionComercialHandler_cls.ActualizarVigenciaActivo(Trigger.New);
				
				// Astrid Leiva
                // Relacionamiento del Activo de Negocio seguro con el del Activo Principal cuando las OC estan en estado Facturado
                /*Id idOCRecordTypeVenta = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Venta').getRecordTypeId();
                List<Planes__c> PlanNegocioSeguro = new List<Planes__c>([SELECT id FROM Planes__c WHERE NombredelProducto__r.Name ='Negocio Seguro' Limit 1]);
                list<ActivoETB__c> listActivos = new List<ActivoETB__c>();
                Set<Id> listoc_rela = new Set<Id>();                
                
                for(OperacionComercial__c lisOC : trigger.new){                  
                    if(lisOC.RecordTypeId == idOCRecordTypeVenta && lisOC.Plan__c == PlanNegocioSeguro[0].id && lisOC.Estado__c == 'Facturado')
                    {                        
                        if(lisOC.Operacion_Comercial_Relacionada__c!= null){
                            listoc_rela.add(Id.valueof(lisOC.Operacion_Comercial_Relacionada__c));
                            system.debug('listoc_rela --> '+ listoc_rela);
                        }
                    }
                }
                List<OperacionComercial__c> OC_relacianda = new List<OperacionComercial__c>([SELECT id, Estado__c, Activo__c from OperacionComercial__c where id IN :listoc_rela]);
                system.debug('colors --> '+ OC_relacianda);
                for(OperacionComercial__c lisOC : trigger.new){
                OperacionComercialHandler_cls.ActualizarVigenciaActivo(Trigger.New);
                  
                    if(lisOC.RecordTypeId == idOCRecordTypeVenta && lisOC.Plan__c == PlanNegocioSeguro[0].id && lisOC.Estado__c == 'Facturado')
                    {
                        ActivoETB__c sglActivo = new ActivoETB__c (Id=lisOC.Activo__c);
                        
                        /*if(lisOC.NumerodePedido__c != null){                            
                            sglActivo.NumeroDeOrdenSuma__c = lisOC.NumerodePedido__c;  
                            system.debug('entro al if de enumero de pedido');                          
                        }*/
                        
                        /*if(lisOC.Operacion_Comercial_Relacionada__c == OC_relacianda[0].id && OC_relacianda[0].Estado__c == 'Facturado'){
                            sglActivo.Activo_Relacionado__c = OC_relacianda[0].Activo__c;
                        }
                        listActivos.add(sglActivo);
                    }
                }
                update listActivos;*/
                // Fin Astrid Leiva
				
			}
            //  Bloque de ejecución After Update
            if (trigger.isUpdate && !BanderasEjecucion.ValidarEjecucion('OperacionComercialisAfterUpdate') ) {
                ocClass.identificarCambios(trigger.newMap, trigger.oldMap);
                ocClass.ValidacionesOC(trigger.newMap, trigger.oldMap);
                //HBAYONA Laristestga Distancia()
                ocClass.procesarPlanes(trigger.newMap, trigger.oldMap);
                //LMOGOLLON RED INTELIGENTE Liberacion de numeros
                //if(!Test.isRunningTest())
                //  val.LiberarReservas(trigger.newMap,trigger.oldMap);
                //ocClass.BorrarPlanillaContingencia(trigger.new);
            }
            //  Bloque de ejecución After Delete
            if (trigger.isDelete) {
            }
            //  Bloque de ejecución After Undelete
            if (trigger.isUndelete) {
            }
        }
    }
}