/*******************************************************************************
Desarrollado por:       ETB
Autor:                  Fernando Sarasty
Proyecto:               ETB - Gestor portafolio superior.
Descripción:            Controlador de la página EnvioAPVS_pag encargada de seleccionar
                        las operaciones comercial para enviar a aprovisionar.

Cambios (Versiones)
-------------------------------------
No.       Fecha                 Autor                 Descripción
------  ----------      --------------------        ---------------
1.0     09-05-2018      Fernando Sarasty (FS)       Creación de la clase
*******************************************************************************/
public class PS_EnvioAPVS_ctr {
    public Id idObjeto;
    public String strMjsErrorValidaciones;
    
    public string ObjectName{get;set;} 
    public boolean blnValidaSel{get;set;}
    public boolean blnLista{get;set;}
    public boolean blnLista2{get;set;}
    public boolean blnEsNip{get;set;}
    // public boolean blnPadreSeleccionado{get;set;}
	
    public list<wrpResultados> lstResult {get;set;}
    public list<ActivoDTO> lstActivos {get;set;}
    public List<ActivoETB__c> activosNIP {get;set;}
    
    public pageReference AnalizaAccion(){
        strMjsErrorValidaciones = '';
        ObjectName = '';
		blnLista  = false;
		blnLista2 = true;
        blnEsNip = false;
        // blnPadreSeleccionado = false;
        list<OperacionComercial__c> lstOpCom = new list<OperacionComercial__c>();
        //list<OperacionComercial__c> lstOpComNS = new list<OperacionComercial__c>(); // -Astrid
        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        String productoLTE = vGlobal.get('NombreComercialLTE').valor__c;
        Map<string,LTE_APN__c> vGlobalAPN = LTE_APN__c.getAll();
        String strTiposAPN = vGlobalAPN.get('TiposAPN').valor__c;
        Set<String> lstTiposAPN = new Set<String>(strTiposAPN.split(','));
		lstResult = new list<wrpResultados>();
        if(ApexPages.currentPage().getParameters().containskey('id')){
			idObjeto=ApexPages.currentPage().getParameters().get('id');
			
			String sCamposPrincipal = 'Id,Name';
			String producto = VariablesGlobales__c.getValues('NombreComercialLTE').valor__c;
			String strQueryOpCom = '';
			
			strQueryOpCom += 'Id = \''+String.valueOf(idObjeto)+'\'';
			
			String strQueryPrincipal = 'SELECT '+sCamposPrincipal+' FROM '+idObjeto.getSObjectType().getDescribe().getName()+' WHERE ' + strQueryOpCom;
			List<SObject> lstObjetoPrincipal = Database.query(strQueryPrincipal);
			if(!lstObjetoPrincipal.isEmpty()){
                ObjectName = String.ValueOf(lstObjetoPrincipal[0].get('Name'));	
				sCamposPrincipal = 'Id,Name,APN__c,Activo__r.Id, Activo__r.Oportunidad__r.Id, Activo__r.NombredelProducto__c,EstadoAprovisionamiento__c,Plan__c,Plan__r.NombredelProducto__r.Name,Plan__r.NombredelProducto__r.Catalogo__c,TOPP__c,SucursalDestino__c,Integrar_con_gestor__c,Oportunidad__c,Oportunidad__r.Viabilidad_Adicional__c,Oportunidad__r.Id,Viabilidad_Relacionada__r.Causal__c,Viabilidad_Relacionada__r.EstadoViabilidad__c,Viabilidad_Relacionada__r.Respuestadeviabilidad__c,TOPP__r.AplicaPreventa__c,TOPP__r.Name,Operacion_Comercial_Relacionada__c,Operacion_Comercial_Relacionada__r.Plan__r.Viabilidad_Paquete__c,RecordType.Name, Contacto_Administrativo__c, Contacto_Tecnico__c, CuentaCliente__r.Segmento__c,TOPP__r.Nombre_del_Producto__c, TOPP__r.TipodeOperacionporplan__c, Valorunicavez__c,Valor_Recurrente_ETB_Anterior__c, ValorTarifaPlan__c, (SELECT Id,Name FROM Viabilidades__r WHERE EstadoViabilidad__c = \'Cerrada\' AND (Respuestadeviabilidad__c = \'Viable\' OR Respuestadeviabilidad__c = \'VIABLE CONSULTIVA\') ORDER BY CreatedDate DESC LIMIT 1)';
                strQueryOpCom = '';
				strQueryOpCom += '(Estado__c = \'En Curso\' OR Estado__c = \'Pendiente\' OR Estado__c = \'Devuelto\' OR Estado__c = \'Pendiente Activacion Bolsa\') AND ';
				strQueryOpCom += '(Id = \''+lstObjetoPrincipal[0].Id+'\' OR Legalizacion__c = \''+lstObjetoPrincipal[0].Id+'\') AND ';
                strQueryOpCom += idObjeto.getSObjectType().getDescribe().getName()!='OperacionComercial__c'?'Integrar_con_gestor__c = TRUE AND ':'';
				strQueryOpCom += 'TOPP__r.AplicaGerenteProyecto__c = true AND (EstadoAprovisionamiento__c <> \'En Aprovisionamiento\' AND EstadoAprovisionamiento__c <> \'Preparando integración con gestor\') AND ';				
                strQueryOpCom += '(Legalizacion__r.Estado__c = \'Gestionado\' OR ';
                strQueryOpCom += '(Operacion_Comercial_Relacionada__r.Legalizacion__r.Estado__c = \'Gestionado\' AND topp__r.TipodeOperacionporplan__c = \'Cambio de Suscriptor Nuevo\') ';
                strQueryOpCom += 'OR Caso__c <> null ';
                strQueryOpCom += 'OR Fidelizacion__c <> null ';
                strQueryOpCom += 'OR Detalle_del_tramite__c IN (\'Por Pago\',\'ACTUALIZACIONSERVICIO\') ';
                strQueryOpCom += 'OR (Plan__r.NombredelProducto__r.Name = \''+productoLTE+'\' AND APN__c != null AND Tipo_de_Plan_APN__c IN :lstTiposAPN) ';
                strQueryOpCom += 'OR Plan__r.NombredelProducto__r.NEMONICO__c = \'ARINF\')';
                
				
                
				strQueryOpCom = 'SELECT ' + sCamposPrincipal + ' FROM OperacionComercial__c WHERE ' + strQueryOpCom;
                system.debug(strQueryOpCom);
				lstOpCom = Database.query(strQueryOpCom);
                system.debug('lstOpCom'+lstOpCom.size());
                // Validar viabilidad en paquetes
                Map<String,List<OperacionComercial__c>> mpIdPaquete = new Map<String,List<OperacionComercial__c>>();
                String[] nips = Label.Productos_NIP.split(',');
				
                // HU- Negocio Seguro (Querey para que accesa auna oc de este tipo de porducto)
                // Astrid Leiva
                 /*sCamposPrincipal = 'Id,Name,APN__c,Activo__r.NombredelProducto__c,EstadoAprovisionamiento__c,Plan__c,Plan__r.NombredelProducto__r.Name,Plan__r.NombredelProducto__r.Catalogo__c,TOPP__c,SucursalDestino__c,Integrar_con_gestor__c,Oportunidad__c,Oportunidad__r.Viabilidad_Adicional__c,Viabilidad_Relacionada__r.Causal__c,Viabilidad_Relacionada__r.EstadoViabilidad__c,Viabilidad_Relacionada__r.Respuestadeviabilidad__c,TOPP__r.AplicaPreventa__c,TOPP__r.Name,Operacion_Comercial_Relacionada__c,Operacion_Comercial_Relacionada__r.Plan__r.Viabilidad_Paquete__c,RecordType.Name, Contacto_Administrativo__c, Contacto_Tecnico__c, CuentaCliente__r.Segmento__c';
                 
                 strQueryOpCom = '';
                 strQueryOpCom += '(Estado__c = \'En Curso\' OR Estado__c = \'Pendiente\' OR Estado__c = \'Devuelto\' OR Estado__c = \'Pendiente Activacion Bolsa\') AND ';
                 strQueryOpCom += '(Id = \''+lstObjetoPrincipal[0].Id+'\' OR Legalizacion__c = \''+lstObjetoPrincipal[0].Id+'\') AND ';
                 strQueryOpCom += '(Legalizacion__r.Estado__c = \'Gestionado\' OR ';
                 strQueryOpCom += '(Operacion_Comercial_Relacionada__r.Legalizacion__r.Estado__c = \'Gestionado\' AND topp__r.TipodeOperacionporplan__c = \'Cambio de Suscriptor Nuevo\') ';
                 strQueryOpCom += 'OR Caso__c <> null ';
                 strQueryOpCom += 'OR Fidelizacion__c <> null ';
                 strQueryOpCom += 'OR Detalle_del_tramite__c IN (\'Por Pago\',\'ACTUALIZACIONSERVICIO\') ';
                 strQueryOpCom += 'OR (Plan__r.NombredelProducto__r.Name = \'Negocio Seguro\' AND APN__c != null AND Tipo_de_Plan_APN__c IN :lstTiposAPN) ';
                 strQueryOpCom += 'OR Plan__r.NombredelProducto__r.NEMONICO__c = \'ARINF\')';
                 strQueryOpCom = 'SELECT ' + 'Operacion_Comercial_Relacionada__r.Estado__c, ' + sCamposPrincipal + ' FROM OperacionComercial__c WHERE ' + strQueryOpCom;
                 system.debug('strQueryOpCom -> '+strQueryOpCom);
                 lstOpComNS = Database.query(strQueryOpCom);
                 system.debug('lstOpComNS -> '+lstOpComNS.size());
                 system.debug('lstOpComNS -> '+lstOpComNS);*/
                 // Fin Astrid
                
                if(lstOpCom.size()>0){
                    //Se crea un mapa para almacenar las oportunidades y el activo al que pertenece la OC, para consultar los servicios asociados en caso de que sea NIP
                    Map<String,String> idOportunidadNips = new Map<String,String>();
					for(OperacionComercial__c o:lstOpCom){
                        System.debug('OpComercial '+ o.TOPP__r.Nombre_del_Producto__c);
                        System.debug('nips '+ nips);
                        // N-1171-1.5.  HU HU Trámites Empaquetados NIP
                        // Se agregan a una lista los Id´s de las OC's cuyo producto perteneza a NIP o sus empaquetados.
                        // Miguel R. Gómez miguel.rafael.gomez@accenture.com 11/04/2022
                        if(nips.contains( o.TOPP__r.Nombre_del_Producto__c))
                        {
                            System.debug('Entró al nip contais ');
                            idOportunidadNips.put(o.Activo__r.Oportunidad__r.Id,o.Activo__r.Id );
                            System.debug('idOportunidadNips '+idOportunidadNips);
                        }
                          // Finaliza cambio N-1171-1.5.  HU HU Trámites Empaquetados NIP
						wrpResultados insWrp = new wrpResultados();
						Boolean bHabilitar = false;
						if(o.TOPP__r.AplicaPreventa__c == true){
                            if(o.Plan__r.NombredelProducto__r.Name == 'TELEFONIA MOVIL (LTE)' && o.APN__c != null){
                                o.Integrar_con_gestor__c = true;
                                bHabilitar = true;
                            }
                            else if(o.Oportunidad__c != null){
								if(o.Viabilidad_Relacionada__c!=null){
                                    if(o.Viabilidad_Relacionada__r.Causal__c == 'No requiere' && o.Viabilidad_Relacionada__r.Respuestadeviabilidad__c == 'VIABLE CONSULTIVA' && o.Viabilidad_Relacionada__r.EstadoViabilidad__c == 'Cerrada')
                                        bHabilitar = true;
                                }
                                else if(o.Oportunidad__r.Viabilidad_Adicional__c == 'No requiere'){
									bHabilitar = true;
								}
								else{
									bHabilitar = !o.Viabilidades__r.isEmpty();
								}
							}else{
								bHabilitar = !o.Viabilidades__r.isEmpty();
							}
						}
						else{
							bHabilitar = true;
						}
						if(bHabilitar){
							insWrp.OpCome=o;
							lstResult.add(insWrp);
                           
                        }else if(o.Operacion_Comercial_Relacionada__c!=null){
                            if(o.Operacion_Comercial_Relacionada__r.Plan__r.Viabilidad_Paquete__c=='Solo el producto principal'){
                                if(!mpIdPaquete.containskey(o.Operacion_Comercial_Relacionada__c)){
                                    mpIdPaquete.put(o.Operacion_Comercial_Relacionada__c, new List<OperacionComercial__c>());
                                }
                                mpIdPaquete.get(o.Operacion_Comercial_Relacionada__c).add(o);
                            }
                        }
					}
                    
                     // N-1171-1.5.  HU HU Trámites Empaquetados NIP
                     // Se agregan a una lista los Id´s de las OC's cuyo producto perteneza a NIP o sus empaquetados.
                     // Miguel R. Gómez miguel.rafael.gomez@accenture.com 11/04/2022
                    if(!idOportunidadNips.isEmpty()){
                        System.debug('Entró al if de Oportunidades');
                        activosNIP = [SELECT Id, Name, NombredelProducto__c, NombredelProducto__r.Name, Plan__c FROM ActivoETB__c WHERE Oportunidad__c IN :idOportunidadNips.keySet() AND Id NOT IN:idOportunidadNips.values() AND NombredelProducto__r.Name IN :nips ];

                        if(!activosNIP.isEmpty())
                        {
                            blnEsNip = true;
                            lstActivos = new List<ActivoDTO>();
                            for(ActivoETB__c act : activosNIP)
                            {
                                ActivoDTO actAux = new ActivoDTO();
                                actAux.Activo=act;
                                lstActivos.add(actAux);
                            }
                            System.debug('blnEsNip '+ blnEsNip);
                        }
                    }
                    // Finaliza cambio N-1171-1.5.  HU HU Trámites Empaquetados NIP
                    
                    if(!mpIdPaquete.isEmpty()){
                        String strQueryOpComPaquete = '';
                        String joinedString = String.join(new List<String>(mpIdPaquete.keyset()), '\',\'');
                        strQueryOpComPaquete += '(Estado__c = \'En Curso\' OR Estado__c = \'Pendiente\' OR Estado__c = \'Devuelto\') AND ';
                        strQueryOpComPaquete += '(Id IN (\''+joinedString+'\')) AND ';
                        strQueryOpComPaquete += idObjeto.getSObjectType().getDescribe().getName()!='OperacionComercial__c'?'Integrar_con_gestor__c = TRUE AND ':'';
                        strQueryOpComPaquete += 'TOPP__r.AplicaGerenteProyecto__c = true AND EstadoAprovisionamiento__c <> \'En Aprovisionamiento\' AND ';
                        strQueryOpComPaquete += '(Legalizacion__r.Estado__c = \'Gestionado\' OR (Operacion_Comercial_Relacionada__r.Legalizacion__r.Estado__c = \'Gestionado\' AND topp__r.TipodeOperacionporplan__c = \'Cambio de Suscriptor Nuevo\') OR Caso__c <> null OR Detalle_del_tramite__c IN (\'Por Pago\',\'ACTUALIZACIONSERVICIO\') )';

                        strQueryOpComPaquete = 'SELECT ' + sCamposPrincipal + ' FROM OperacionComercial__c WHERE ' + strQueryOpComPaquete;
                        list<OperacionComercial__c> lstOpComPaquete = new list<OperacionComercial__c>();
                        System.Debug('strQueryOpComPaquete '+ strQueryOpComPaquete);
                        lstOpComPaquete = Database.query(strQueryOpComPaquete);
                        
                        if(lstOpComPaquete.size()>0){
                            for(OperacionComercial__c o:lstOpComPaquete){
                                Boolean bHabilitar = false;
                                if(o.TOPP__r.AplicaPreventa__c == true){
                                    if(o.Oportunidad__c != null){
                                        if(o.Oportunidad__r.Viabilidad_Adicional__c == 'No requiere'){
                                            bHabilitar = true;                                            
                                        }else if(o.Viabilidad_Relacionada__c!=null){
                                            if(o.Viabilidad_Relacionada__r.Causal__c == 'No requiere' && o.Viabilidad_Relacionada__r.Respuestadeviabilidad__c == 'VIABLE CONSULTIVA' && o.Viabilidad_Relacionada__r.EstadoViabilidad__c == 'Cerrada')
                                                bHabilitar = true;
                                        }
                                        else{
                                            bHabilitar = !o.Viabilidades__r.isEmpty();
                                        }
                                    }else{
                                        bHabilitar = !o.Viabilidades__r.isEmpty();
                                    }
                                }
                                else{
                                    bHabilitar = true;
                                }
                                if(bHabilitar){
                                    for(OperacionComercial__c sglOCPaq:mpIdPaquete.get(o.Id)){
                                        wrpResultados insWrp = new wrpResultados();
                                        insWrp.OpCome=sglOCPaq;
                                        lstResult.add(insWrp);
                                    }
                                }
                            }
                            
                            
                        }
                    }

                    // N-1171-1.2.  HU Contacto obligatorio en los Retiros
                    // Se extraen de la lista de OC disponibles para envío de aprovisionamiento a las que sean de tipo retiro y que no tengan
                    // ni contacto administrativo, ni contaco técnico asociados. Miguel R. Gómez miguel.rafael.gomez@accenture.com 09/02/2022
                    
                    for(Integer j = 0; j < lstResult.size(); j++){
                        if(lstResult.get(j).OpCome.RecordType.Name == 'Retiros' && lstResult.get(j).OpCome.Contacto_Administrativo__c == NULL 
                        && lstResult.get(j).OpCome.Contacto_Tecnico__c == NULL  && lstResult.get(j).OpCome.CuentaCliente__r.Segmento__c == 'MiPymes' )
                        {
                            lstResult.remove(j);
                             j--;
                        }
                     }
                     
					if(lstResult.isEmpty())
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioAPVS_NoHayOP));
					else{
						blnLista    = true;
						blnLista2   = false;
					}
				}
				// HU Negicio Seguro (Validacion de que no aprovisione si la Oc relacioanda esta como minimo Aprovisionada )
                //Astrid Leiva
                /*else if(lstOpComNS.size()>0){
                    Set<String> setEstadosOc = new Set<String>{'Activo', 'Pendiente Facturacion','Facturado', 'No Exitoso Facturacion',
                    'Pendiente Informacion Facturacion', 'Pendiente Facturacion Cuenta de Cobro'};
                    for(OperacionComercial__c o:lstOpComNS){
                        if(!setEstadosOc.contains(o.Operacion_Comercial_Relacionada__r.Estado__c) || o.Operacion_Comercial_Relacionada__c == null){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioAPVS_NoHayOP));
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioAPVS_NoHayOPNS));
                        }
                    }
                }*/
                // Fin Astrid
				else{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioAPVS_NoHayOP));
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioAPVS_NoHayOPNS));
				}
			}
			else{
				strMjsErrorValidaciones = 'No se encuentra el registro o no se poseen permisos para acceder al objeto '+String.valueOf(idObjeto);
			}
		}
		else{
            strMjsErrorValidaciones = 'No se suministraron los parametros necesarios para cargar la pagina';
        }
        return null;
    }
    
    public pageReference SelTodos(){
        for(wrpResultados w: lstResult){
            w.blnSel=true;
        }
        return null;
    }
    
    public pageReference SelNada(){
        for(wrpResultados w: lstResult){
            w.blnSel=false;
        }
        return null;
    }
    
    public void ValidaSel(){
        blnValidaSel=false;
        for(wrpResultados w: lstResult){
            if(w.blnSel){
                blnValidaSel=true;
                break;
            }
        }
    }
    
    public pageReference Cancelar(){
        PageReference p=null;
        if(idObjeto!=null){
           p = new PageReference('/'+idObjeto);
        }
        return p;
    }
    
    public class wrpResultados{
        public OperacionComercial__c OpCome {get;set;}
        public boolean blnSel {get;set;}
        public wrpResultados(){
			OpCome = new OperacionComercial__c();
			blnSel=false;
        }
    }

    public class ActivoDTO{
        public ActivoETB__c activo {get;set;}
        public boolean blnSel {get;set;}
        public boolean blnClonado {get;set;}
        public ActivoDTO(){
			Activo = new ActivoETB__c();
			blnSel=true;
            blnClonado=false;
        }
    }
   



    /**
    * @description Metodo que clonas las OC de las NIP a las que se le va a hacer el trámite
    * @author Miguel R. Gómez  miguel.rafael.gomez@accenture.com | 04-13-2022 
    * @param operacionComercial 
    * @return List<Id> 
    **/
    public List<OperacionComercial__c> ClonarOCsNIP(OperacionComercial__c oc){
        Boolean blnExistetipoTOPP=false;
        List<TOPP__c> topp;
        List<Id> listaReturn = new List<Id>();
        List<OperacionComercial__c> ocsCLonadas = new List<OperacionComercial__c>();
        System.debug('***linea 306');
         if(lstActivos!= null && lstActivos.Size()>0 )
        { 
            System.debug('**Entró al if Activos');
        	for(ActivoDTO a: lstActivos){
            System.debug('**Entró al for Activos');
            	if(a.blnSel && !a.blnClonado){
               		if (!blnExistetipoTOPP)
               		{
                    	topp = [SELECT id, Name FROM TOPP__c WHERE TipodeOperacionporplan__c =: oc.TOPP__r.TipodeOperacionporplan__c 
                            AND Plan__c=: a.activo.Plan__c LIMIT 1 ];
                            blnExistetipoTOPP=true;
               		}
               		OperacionComercial__c ocClon = oc.clone(false, false, false, false);
               		if (!topp.isEmpty())
               		{
                   	 ocClon.TOPP__c = topp[0].Id;
               		}
               		ocClon.Activo__c = a.activo.Id;
               		ocClon.Plan__c = a.activo.Plan__c;
               		ocClon.Valorunicavez__c = oc.Valorunicavez__c;
               		ocClon.Valor_Recurrente_ETB_Anterior__c = oc.Valor_Recurrente_ETB_Anterior__c;
               		ocClon.ValorTarifaPlan__c = oc.ValorTarifaPlan__c;

               		ocsCLonadas.add(ocClon);
               		a.blnClonado = true;
            	}
        	}
        }
		System.debug('***linea 329');
        if(!ocsClonadas.IsEmpty())
        {
        	insert ocsCLonadas;
        }

        // for(OperacionComercial__c ocCL: ocsCLonadas)
        // {
        //     listaReturn.Add(ocCL.Id);
        // }
		
        return ocsCLonadas;
    }

    public pageReference GenerarIntegracion(){
        System.debug('Entró a GenerarIntegracion');
		list<OperacionComercial__c> lstOpCom = new list<OperacionComercial__c>();
		try{
			ValidaSel();
			if(!blnValidaSel){
				Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, Label.EnvioVia_DebeSelec));
			}
			else{
				Set<Id> lstId = new Set<Id>();
                Set<Id> lstIdAliados = new Set<Id>();
                System.debug('lstResult!!!! '+lstResult[0]);
				for(wrpResultados w: lstResult){
                    // System.debug('OpCome.Nombre_del_Producto__c '+OpCome.TOPP__r.Nombre_del_Producto__c);
                    if(w.blnSel && w.OpCome.Integrar_con_gestor__c == false){
                        strMjsErrorValidaciones = 'La OC no tiene la marca de Envio a Gestor por lo cual se debe trabajar por el procedimiento y sistema previo a la integracion';
                    }
					else if(w.blnSel){
                        if(w.OpCome.Plan__r.NombredelProducto__r.Catalogo__c == 'Aliado')
                        lstIdAliados.add(w.OpCome.Id);
                    else
                        lstId.add(w.OpCome.Id);
					lstOpCom.add(w.OpCome);
                    lstOpCom.addAll(ClonarOCsNIP(w.OpCome));
					}
				}

                for(OperacionComercial__c opc: lstOpCom)
                {
                    System.debug('*** opc '+opc);
                    if(!lstId.contains(opc.Id))
                    {
                        lstId.add(opc.Id);
                    }
                }
                
                // Debes validar que se haya seleccionado la OC principal y si hay algún servicio seleccionado de la lista, hacer la clonación de la OC, y cambiando los otros parametros y
                // y dejarla en con el estado  EstadoAprovisionamiento__c = 'Preparando integración con gestor';
                if(String.isEmpty(strMjsErrorValidaciones)){
                    System.debug('llstId.size() '+lstId.size());
                    if(!lstId.isEmpty() || !lstIdAliados.isEmpty()||Test.isRunningTest()){
                        if(lstId.size()>1){
                            List<OperacionComercial__c> preparandoOC = new List<OperacionComercial__c>();
                            for(id opId:lstId){
                                System.debug('Antes de la creación de la OC');
                                OperacionComercial__c sglOp = new OperacionComercial__c(Id=opId);
                                System.debug('After creación de la OC');
                                sglOp.EstadoAprovisionamiento__c = 'Preparando integración con gestor';
                                preparandoOC.add(sglOp); 
                            }
                            BanderasEjecucion.SetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                            update preparandoOC;
                            BanderasEjecucion.unSetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');                           
                            BatchGenerico_bch bch = new BatchGenerico_bch();
                            bch.idImediato = lstId;
                            bch.Operacion = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO;
                             if(!Test.isRunningTest())
                            {
                                ID batchprocessid = Database.executeBatch(bch,1);
                            }
                            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,'Se ha lanzado el proceso masivo'));
                        }
                        else if(!lstId.isEmpty()){
                            PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
                            Map<Id,Map<String,Object>> mapDatos = pscls.GenerarDatamapOrdenes(lstId,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO);
                            Map<Id,String> mpResultado = pscls.IntegracionGestor(mapDatos,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO);
                            String sResultado = '';
                            if(!mpResultado.isEmpty()){
                                for(OperacionComercial__c sglOp:lstOpCom){
                                    sResultado = mpResultado.containskey(sglOp.Id)?mpResultado.get(sglOp.Id):'No Procesado';
                                    if(String.isNotEmpty(sResultado)){
                                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,sResultado));
                                    }else{
                                        String nombreOC = sglOp.Name;
                                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,((Label.Mensaje_ok_integracion_Gestor_apvs.replace('%nro_oc%',nombreOC)).replace('%Identificador%','Se ha guardado el registro exitosamente.')).replace('%nombrevia%',nombreOC)));
                                    }
                                }
                            }else{
                                sResultado = 'No procesado';
                                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,sResultado));
                            }
                        }
                        if(lstIdAliados.size()>1){
                        }else if(!lstIdAliados.isEmpty()||Test.isRunningTest()){
                            PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
                            Map<Id,Map<String,Object>> mapDatos = pscls.GenerarDatamapOrdenes(lstIdAliados,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO_ALIADO);
                            Map<Id,String> mpResultado = pscls.IntegracionGestor(mapDatos,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO_ALIADO);
                            String sResultado = '';
                            if(!mpResultado.isEmpty()){
                                for(OperacionComercial__c sglOp:lstOpCom){
                                    sResultado = mpResultado.containskey(sglOp.Id)?mpResultado.get(sglOp.Id):'No Procesado';
                                    if(String.isNotEmpty(sResultado)){
                                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,sResultado));
                                    }else{
                                        String nombreOC = sglOp.Name;
                                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,((Label.Mensaje_ok_integracion_Gestor_apvs.replace('%nro_oc%',nombreOC)).replace('%Identificador%','Se ha guardado el registro exitosamente.')).replace('%nombrevia%',nombreOC)));
                                    }
                                }
                            }else{
                                sResultado = 'No procesado';
                                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,sResultado));
                            }
                        }
                    }
                    else{
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'No se encontraron ordenes para el envio'));
                    }
                }
                else{
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,strMjsErrorValidaciones));
                }
			}
		}catch(Exception e){
            system.debug('Entró al exception');
            system.debug(e.getMessage());
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,e.getMessage()));
        }
		blnLista = false;
        blnEsNip = false;
		blnLista2 = true;
        return null;
	}
}