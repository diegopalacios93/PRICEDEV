/*******************************************************************************
Desarrollado por:       ETB
Autor:                  John Guevara
Proyecto:               ETB - Gestor portafolio superior.
Descripción:            Controlador de la página EnvioFacturacion_pag encargada de seleccionar
                        las operaciones comercial para enviar a facturar.

Cambios (Versiones)
-------------------------------------
No.       Fecha                 Autor                 Descripción
------  ----------      --------------------        ---------------
1.0     21-09-2018      John Guevara (JOHNGUE2)       Creación de la clase
*******************************************************************************/
public class PS_EnvioFacturacion_ctr {
    public Id idObjeto;
    public String strMjsErrorValidaciones;
    
    public string ObjectName{get;set;} 
    public boolean blnValidaSel{get;set;}
    public boolean blnLista{get;set;}
    public boolean blnLista2{get;set;}
	
    public list<wrpResultados> lstResult {get;set;}
    
    public pageReference AnalizaAccion(){
        strMjsErrorValidaciones = '';
        ObjectName = '';
		blnLista  = false;
		blnLista2 = true;
        list<OperacionComercial__c> lstOpCom = new list<OperacionComercial__c>();
		lstResult = new list<wrpResultados>();
        Map<String,Object> mpListaValores = PS_IntegrationHelper_ctr.ObtenerListaValores('Homologacion_Gestor__mdt','');
        
        if(ApexPages.currentPage().getParameters().containskey('id')){
			idObjeto=ApexPages.currentPage().getParameters().get('id');
			
			String sCamposPrincipal = 'Id,Name';
			String producto = VariablesGlobales__c.getValues('NombreComercialLTE').valor__c;
			String strQueryOpCom = '';
            
            Boolean blnEnvioIntegracion = PS_IntegracionSalidaGestor_cls.validarUsuarioLV(userinfo.getUserId(),(List<Map<String,String>>)mpListaValores.get('PER_ENVIOFACT_MANUAL'),'Valor_API__c');
			
            if(blnEnvioIntegracion){
                strQueryOpCom += 'Id = \''+String.valueOf(idObjeto)+'\'';
                
                String strQueryPrincipal = 'SELECT '+sCamposPrincipal+' FROM '+idObjeto.getSObjectType().getDescribe().getName()+' WHERE ' + strQueryOpCom;
                List<SObject> lstObjetoPrincipal = Database.query(strQueryPrincipal);
                if(!lstObjetoPrincipal.isEmpty()){
                    ObjectName = String.ValueOf(lstObjetoPrincipal[0].get('Name'));	
                    sCamposPrincipal = 'Id,Name,Activo__r.NombredelProducto__c,Plan__c,TOPP__c,SucursalDestino__c,Integrar_con_gestor__c,Oportunidad__c,Oportunidad__r.Viabilidad_Adicional__c,TOPP__r.AplicaPreventa__c,TOPP__r.Name,Operacion_Comercial_Relacionada__c,Operacion_Comercial_Relacionada__r.Plan__r.Viabilidad_Paquete__c,(SELECT Id,Name FROM Viabilidades__r WHERE EstadoViabilidad__c = \'Cerrada\' AND Respuestadeviabilidad__c = \'Viable\' ORDER BY CreatedDate DESC LIMIT 1)';
                    strQueryOpCom = '';
                    strQueryOpCom += '(Estado__c = \'Inactivo\' OR Estado__c = \'Activa\' OR Estado__c = \'Pendiente Facturacion\' OR Estado__c = \'No Exitoso Facturacion\') AND ';
                    strQueryOpCom += '(Id = \''+lstObjetoPrincipal[0].Id+'\' OR Legalizacion__c = \''+lstObjetoPrincipal[0].Id+'\') AND ';
                    strQueryOpCom += 'fechadeActivacion__c != null AND EnvioFacturacion__c=true AND ';
                    strQueryOpCom += 'CuentaCliente__r.SubSegmento__c != \'Carrier y Operadores\' AND ';
                    strQueryOpCom += 'topp__r.AplicaFacturacion__c=true AND ';
                    strQueryOpCom += '(Legalizacion__r.Estado__c = \'Gestionado\' OR Caso__c <> null)';
                    system.debug(strQueryOpCom);
                    
                    strQueryOpCom = 'SELECT ' + sCamposPrincipal + ' FROM OperacionComercial__c WHERE ' + strQueryOpCom;
                    lstOpCom = Database.query(strQueryOpCom);
                    system.debug('lstOpCom'+lstOpCom.size());
                    // Validar viabilidad en paquetes
                    Map<String,List<OperacionComercial__c>> mpIdPaquete = new Map<String,List<OperacionComercial__c>>();
                    
                    if(lstOpCom.size()>0){
                        for(OperacionComercial__c o:lstOpCom){
                            wrpResultados insWrp = new wrpResultados();
                            insWrp.OpCome=o;
                            lstResult.add(insWrp);
                        }
                        if(lstResult.isEmpty())
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioFacturacion_NoHayOP));
                        else{
                            blnLista    = true;
                            blnLista2   = false;
                        }
                    }
                    else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioFacturacion_NoHayOP));
                    }
                }
                else{
                    strMjsErrorValidaciones = 'No se encuentra el registro o no se poseen permisos para acceder al objeto '+String.valueOf(idObjeto);
                }
            }
            else{
                strMjsErrorValidaciones = 'No posee permisos para realizar el envio a facturacion';
            }
		}
		else{
            strMjsErrorValidaciones = 'No se suministraron los parametros necesarios para cargar la pagina';
        }
        if(String.isNotEmpty(strMjsErrorValidaciones))
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strMjsErrorValidaciones));
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
   
    public pageReference GenerarIntegracion(){
		list<OperacionComercial__c> lstOpCom = new list<OperacionComercial__c>();
		try{
			ValidaSel();
			if(!blnValidaSel){
				Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, Label.EnvioFacturacion_DebeSelec));
			}
			else{
				Set<Id> lstId = new Set<Id>();
				for(wrpResultados w: lstResult){
                    if(w.blnSel){
						lstId.add(w.OpCome.Id);
						lstOpCom.add(w.OpCome);
					}
				}
                system.debug(lstId);
                if(String.isEmpty(strMjsErrorValidaciones)){
                    if(!lstId.isEmpty()){
                        if(lstId.size()>1){
                            /*
                            BatchGenerico_bch bch = new BatchGenerico_bch();
                            bch.idImediato = lstId;
                            bch.Operacion = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO;
                            ID batchprocessid = Database.executeBatch(bch,1);
                            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,'Se ha lanzado el proceso masivo'));
							*/
                        }
                        else{
                            BatchGenerico_bch bch = new BatchGenerico_bch();
                            bch.idImediato = lstId;
                            bch.Operacion = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.FACT_GENERAL;
                            ID batchprocessid = Database.executeBatch(bch,1);
                            /*Map<Id,OperacionComercial__c> sOC = new Map<Id,OperacionComercial__c> ([Select Id,Name,FechadeActivacion__c,CuentaFacturacion__r.Name,Activo__r.ExternalServiceID__c,Plan__r.Name,TOPP__c,TOPP__r.Name,Activo__c,FechaInicioReconexion__c,CuentaCliente__c,
                                   Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c,LTE_TipoTransaccion__c,NumeroArranqueAnterior__c,NumeroArranqueNuevo__c,ValorObraCivil__c,EnviadaFacturacionEquipo__c,
                                   Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c,
                                   Plan__r.LTE_MetodoDePago__c,TipoSuspension__c,Activo__r.CuentaFacturacion__r.Name, CuentaFacturacion__r.LTE_NombreCuentaFacturacion__c, 
                                   CuentaFacturacion__r.DirCorresp__c, CuentaFacturacion__r.Ciudad__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Padre__r.CodigoDane__c, CuentaFacturacion__r.Ciudad__r.Name, 
                                   CuentaFacturacion__r.LTE_Email__c, CuentaFacturacion__r.MedioFacturacion__c,Detalle_del_tramite__c
                                   FROM OperacionComercial__c WHERE Id IN :lstId]);
                            PS_TOPP_Billing_cls sd = new PS_TOPP_Billing_cls();
                            Map<Id,Map<String,Object>> mapDatos = sd.LoadMap(sOC.keyset());
                            sd.TOPPDispatcher(mapDatos);*/
                            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,'Se ha enviado la orden a facturación.'));
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
            system.debug(e.getMessage());
            system.debug(e.getStackTraceString());
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,e.getMessage()));
        }
		blnLista = false;
		blnLista2 = true;
        return null;
	}
}