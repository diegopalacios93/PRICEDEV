/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andrés Cubillos
Proyecto:               ETB - CRM etapa 1
Descripción:            Controlador de la página EnvioViabilidades_pag encargada de seleccionar
						los activos para solicitar la viabilidad a Preventa

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     25-09-2013  Andrés Cubillos (AAC)       Creación de la clase..
1.1     28-11-2013  Daniel Guana    (DGUANA)    Modificación de evolutivos.
1.2     31-01-2014  Jorge Grimaldos (JG)        Ajuste requerimiento 2 paquete 20 de Enero: Validar que los campos
obligatorios de la OC se encuentren diligenciados
1.3     06-02-2014  Jorge Grimaldos (JG)        Ajustes Pruebas UAT Paquete 20-01-2013
1.4     12-03-2014  Jorge Grimaldos (JG)        Soporte Viabilidades repetidas por múltiples pestañas
1.5     25-03-2014  Jorge Grimaldos (JG)        Garantía Operación Comercial Estado Declinada
1.6     23-04-2018  Fernando Sarasty (FS)       Se realiza invocación de la clase 'PS_IntegracionSalidaGestor_cls' para integrar la viabilidad
con la aplicación 'gestor'.
*******************************************************************************/
public with sharing class EnvioViabilidades_ctr {
    public Id idObjeto;
    public string strMjsErrorValidaciones;
    list<Viabilidad__c> lstViab;
    
    public string strNombreOpp{get;set;}
    public list<wrpResultados> lstResult {get;set;}
    public boolean blnValidaSel{get;set;}
    public boolean blnLista{get;set;}
    public boolean blnLista1{get;set;}
    public boolean blnLista2{get;set;}
    public wrpResultados insWrp;
    
    public EnvioViabilidades_ctr(){
    }
    
    public pageReference AnalizaAccion(){
        strMjsErrorValidaciones = '';
        list<OperacionComercial__c> lstOpCom = new list<OperacionComercial__c>();
        if(ApexPages.currentPage().getParameters().containskey('id')){
            idObjeto=ApexPages.currentPage().getParameters().get('id');
            blnLista=false;
            
            String sCamposPrincipal = '';
            String strQueryOpCom = '';
            String strCampoRequiereVIA = '';
            String producto = VariablesGlobales__c.getValues('NombreComercialLTE').valor__c;
            
            Map<String,Object> mpListaValores = PS_IntegrationHelper_ctr.ObtenerListaValores('Homologacion_Gestor__mdt','');
            String sEstadosVIA = PS_IntegrationHelper_ctr.MapListValuesToString(mpListaValores,'ESTADOS_VIA_REENVIO_VIA','Valor_API__c');
            String sEstadosOC = PS_IntegrationHelper_ctr.MapListValuesToString(mpListaValores,'ESTADOS_OC_ENVIO_VIA','Valor_API__c');
            String sRespuestaVIA = PS_IntegrationHelper_ctr.MapListValuesToString(mpListaValores,'RESPUESTA_VIA_REENVIO_VIA','Valor_API__c');
            Boolean blnEnvioIntegracion = PS_IntegracionSalidaGestor_cls.validarUsuarioLV(userinfo.getUserId(),(List<Map<String,String>>)mpListaValores.get('PER_MARCAROC_ANTIGUA'),'Valor_API__c');
            System.Debug('Paso antes del if de OC');
            if(idObjeto.getSObjectType().getDescribe().getName()=='OperacionComercial__c'){
                System.Debug('entro al if de OC');
                strCampoRequiereVIA = 'Oportunidad__r.Viabilidad_Adicional__c';
                sCamposPrincipal = 'Id,Name,Oportunidad__r.Viabilidad_Adicional__c, Demo__c,CuentaCliente__r.Segmento__c ';
                strQueryOpCom = 'WHERE Id = \''+String.valueOf(idObjeto)+'\'' ;
                strQueryOpCom += ' AND ((TOPP__r.AplicaPreventa__c=true AND Plan__r.NombredelProducto__r.Name != \''+producto+'\') OR (TOPP__r.AplicaPreventa__c=true AND Plan__r.NombredelProducto__r.Name = \''+producto+'\' AND (Plan__r.TipodePlan__c = \'Troncal SIP\' OR (Plan__r.TipodePlan__c = \'Principal\' AND Plan__r.Plan_Troncales_Sip_Movil__c = true))))';
                strQueryOpCom += ' AND Estado__c IN ('+sEstadosOC+') ';
                strQueryOpCom += ' AND ((TOPP__r.TipodeOperacionporplan__c = \'Prorroga\' AND CreatedDate < 2020-06-01T00:00:00Z) OR TOPP__r.TipodeOperacionporplan__c != \'Prorroga\') ';
                strQueryOpCom += ' AND (Operacion_Comercial_Relacionada__c = null OR Operacion_Comercial_Relacionada__r.Plan__r.Viabilidad_Paquete__c != \'Solo el producto principal\' OR (Operacion_Comercial_Relacionada__c != null AND TOPP__r.TipodeOperacionporplan__c != \'Venta\'))';
                strQueryOpCom += ' AND (Activo_Relacionado__c = null OR Activo_Relacionado__r.Plan__r.Viabilidad_Paquete__c != \'Solo el producto principal\' )';
                strQueryOpCom += ' AND Id NOT IN (SELECT OperacionComercial__c FROM Viabilidad__c WHERE OperacionComercial__c = \''+String.valueOf(idObjeto)+'\' AND ((Respuestadeviabilidad__c NOT IN ('+sRespuestaVIA+') OR EstadoViabilidad__c NOT IN ('+sEstadosVIA+')) AND (EstadoViabilidad__c != \''+Label.EnvioVia_EstPend+'\' OR Fecha_Envio_Integracion_Gestor__c != null OR NumerodeCambioFactibilidad__c != null)))';
            }else if(idObjeto.getSObjectType().getDescribe().getName()=='Opportunity'){
                strCampoRequiereVIA = 'Viabilidad_Adicional__c';
                sCamposPrincipal = 'Id,Name,Viabilidad_Adicional__c';
                
                strQueryOpCom = 'WHERE Oportunidad__c = \''+String.valueOf(idObjeto)+'\'' ;
                strQueryOpCom += ' AND ((TOPP__r.AplicaPreventa__c=true AND Plan__r.NombredelProducto__r.Name != \''+producto+'\') OR (TOPP__r.AplicaPreventa__c=true AND Plan__r.NombredelProducto__r.Name = \''+producto+'\' AND (Plan__r.TipodePlan__c = \'Troncal SIP\' OR (Plan__r.TipodePlan__c = \'Principal\' AND Plan__r.Plan_Troncales_Sip_Movil__c = true))))';
                //strQueryOpCom += ' AND (TOPP__r.AplicaPreventa__c=true)';// OR (Plan__r.NombredelProducto__r.Name = \''+producto+'\' AND (Plan__r.TipodePlan__c = \'Troncal SIP\' OR (Plan__r.TipodePlan__c = \'Principal\' AND Plan__r.Plan_Troncales_Sip_Movil__c = true))))';
                strQueryOpCom += ' AND Estado__c IN ('+sEstadosOC+') ';
                strQueryOpCom += ' AND ((TOPP__r.TipodeOperacionporplan__c = \'Prorroga\' AND CreatedDate < 2020-06-01T00:00:00Z) OR TOPP__r.TipodeOperacionporplan__c != \'Prorroga\') ';
                strQueryOpCom += ' AND (Operacion_Comercial_Relacionada__c = null OR Operacion_Comercial_Relacionada__r.Plan__r.Viabilidad_Paquete__c != \'Solo el producto principal\' OR (Operacion_Comercial_Relacionada__c != null AND TOPP__r.TipodeOperacionporplan__c != \'Venta\'))';
                strQueryOpCom += ' AND (Activo_Relacionado__c = null OR Activo_Relacionado__r.Plan__r.Viabilidad_Paquete__c != \'Solo el producto principal\' )';
                strQueryOpCom += ' AND Id NOT IN (SELECT OperacionComercial__c FROM Viabilidad__c WHERE OperacionComercial__r.Oportunidad__c = \''+String.valueOf(idObjeto)+'\' AND (Respuestadeviabilidad__c NOT IN ('+sRespuestaVIA+') OR EstadoViabilidad__c NOT IN ('+sEstadosVIA+')))';
                strQueryOpCom += ' ORDER BY Name';
            }else{
                strMjsErrorValidaciones = 'Los parametros suministrados para cargar la pagina son invalidos';
            }
            system.debug('STR!!'+strQueryOpCom);
            if(String.isEmpty(strMjsErrorValidaciones)){
                String strQueryPrincipal = 'SELECT '+sCamposPrincipal+' FROM '+idObjeto.getSObjectType().getDescribe().getName()+' WHERE Id = \''+String.valueOf(idObjeto)+'\'';
                List<SObject> lstObjetoPrincipal = Database.query(strQueryPrincipal);
                system.debug('strQueryPrincipal '+strQueryPrincipal); 
                system.debug(lstObjetoPrincipal);
                if(!lstObjetoPrincipal.isEmpty()){
                    strNombreOpp=String.valueOf(lstObjetoPrincipal[0].get('Name'));
                    String svarRequiereVIA = LibreriaUtilitaria_cls.recorreCampos(lstObjetoPrincipal[0], strCampoRequiereVIA);
                    if(svarRequiereVIA=='null' || svarRequiereVIA =='Si requiere' || String.isEmpty(svarRequiereVIA)){
                        strQueryOpCom = 'SELECT Id,Name,Activo__r.NombredelProducto__c,Plan__c,TOPP__c,TOPP__r.TipodeOperacionporplan__c,SucursalDestino__c,Integrar_con_gestor__c,Demo__c, CuentaCliente__r.Owner.Name, CuentaCliente__r.Segmento__c, Oportunidad__c, Canal_Externo__c, Asesor_Canal_Externo__c,  (SELECT Id,Name FROM Viabilidades__r WHERE EstadoViabilidad__c = \''+Label.EnvioVia_EstPend+'\' AND Fecha_Envio_Integracion_Gestor__c = null AND NumerodeCambioFactibilidad__c = null ORDER BY CreatedDate DESC LIMIT 1) '+'FROM OperacionComercial__c '+strQueryOpCom;//,
                        system.debug('strQueryOpCom '+strQueryOpCom);
                        lstOpCom = Database.query(strQueryOpCom);
                        system.debug(lstOpCom);
                        if(lstOpCom.size()>0){
                            lstResult = new list<wrpResultados>();
                            for(OperacionComercial__c o:lstOpCom){
                                insWrp = new wrpResultados();
                                insWrp.OpCome=o;
                                insWrp.blnIntegrar=o.Integrar_con_gestor__c;
                                if(idObjeto.getSObjectType().getDescribe().getName()=='OperacionComercial__c'){
                                    if(!o.Viabilidades__r.isEmpty()){
                                        insWrp.ViaCome = o.Viabilidades__r[0];
                                        insWrp.blnMarcarIntegracion = blnEnvioIntegracion;
                                    }
                                }
                                lstResult.add(insWrp);
                            }

                             // N-1171-1.3 HU Asesor obligatorio en las Oportunidades de Mipymes
                            // Se extraen de la lista de OC disponibles para envío de aprovisionamiento a las que no tengan oportunidad, y si la oportunidad
                            // pertenecen a las bolsas COMERCIAL_ AT, COMERCIAL_ EM, COMERCIAL _M  que no tengan ni asesor canal externo, ni 
                            //canal externo. Miguel R. Gómez miguel.rafael.gomez@accenture.com 16/02/2022
                            system.debug(' antes del for lstResult'+lstResult.size());
                            for(Integer j = 0; j < lstResult.size(); j++){
                                if(lstResult.get(j).OpCome.CuentaCliente__r.Segmento__c == 'MiPymes' && 
                                (((lstResult.get(j).OpCome.CuentaCliente__r.Owner.Name == 'COMERCIAL_ AT' || lstResult.get(j).OpCome.CuentaCliente__r.Owner.Name == 'COMERCIAL_ EM' || lstResult.get(j).OpCome.CuentaCliente__r.Owner.Name == 'COMERCIAL _M' ) 
                                && (lstResult.get(j).OpCome.Canal_Externo__c == NULL || lstResult.get(j).OpCome.Asesor_Canal_Externo__c == NULL  ))))
                                {
                                    lstResult.remove(j);
                                    j--;
                                }
                            }
                            system.debug(' despues del for lstResult '+lstResult.size());
                            if(lstResult.size()==0){
                                strMjsErrorValidaciones = 'No hay operaciones comerciales que cumplan la condicion de envio. Recuerde que si la cuenta del cliente es del segmento MiPymes, ';
                                strMjsErrorValidaciones += 'y si la cuenta del cliente pertenece a una de las siguientes bolsas: COMERCIAL_ AT, COMERCIAL_ EM, o COMERCIAL _M, ';
                                strMjsErrorValidaciones += 'es requerido que diligencie los campos ASESOR CANAL EXTERNO y CANAL EXTERNO. Favor Revisar';
                            }
                            else{
                                blnLista=true;
                            }
                        }else{
                            strMjsErrorValidaciones = Label.EnvioVia_NoHayOP;
                        }
                    }else{
                        strMjsErrorValidaciones = 'La Viabilidad consultiva no requiere mas Vias';
                    }
                }else{
                    strMjsErrorValidaciones = 'No se encuentra el registro o no se poseen permisos para acceder al objeto '+String.valueOf(idObjeto);
                }
            }
        }else{
            strMjsErrorValidaciones = 'No se suministraron los parametros necesarios para cargar la pagina';
        }
        if(String.isNotEmpty(strMjsErrorValidaciones)){
            blnLista=false;
            blnLista1 = false;
            blnLista2 = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strMjsErrorValidaciones));
        }else{
            blnLista=true;
            blnLista1 = true;
            blnLista2 = false;
            if(lstOpCom[0].Integrar_con_gestor__c == false)                    
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioVia_Integracion_Deshabilitada));                    
            else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioVia_Confirmacion));
        }
        return null;
    }
    
    public pageReference Cancelar(){
        PageReference p = null;
        if(idObjeto != null){
            p = new PageReference('/'+idObjeto);
        }
        return p;
    }
    
    public class wrpResultados{
        public OperacionComercial__c OpCome {get;set;}
        public Viabilidad__c ViaCome {get;set;}
        public boolean blnSel {get;set;}
        public boolean blnIntegrar {get;set;}
        public boolean blnMarcarIntegracion {get;set;}
        public wrpResultados(){
            OpCome = new OperacionComercial__c();
            blnSel=false;
            blnIntegrar = false;
            blnMarcarIntegracion = false;
        }
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
    
    public pageReference Crear()
    {
        System.debug('**Crear');
        strMjsErrorValidaciones = '';
        lstViab = new list<Viabilidad__c>();
        list<Viabilidad__c> lstViabtemp = new list<Viabilidad__c>();
        ValidaSel();
        
        if(!blnValidaSel){
            strMjsErrorValidaciones = Label.EnvioVia_DebeSelec;
        }
        else{
            Map<Id,OperacionComercial__c> mpOCSeleccionadas = new Map<Id,OperacionComercial__c>();
            Map<Id,Viabilidad__c> mpVIArelacionada = new Map<Id,Viabilidad__c>();
            List<OperacionComercial__c> lstOCMarcadas = new List<OperacionComercial__c>();
            
            for(wrpResultados w: lstResult){
                if(w.blnSel){
                    if(w.blnMarcarIntegracion && w.blnIntegrar && !w.OpCome.Integrar_con_gestor__c){
                        lstOCMarcadas.add(new OperacionComercial__c(Id=w.OpCome.Id,Integrar_con_gestor__c = true));
                    }
                    mpOCSeleccionadas.put(w.OpCome.Id,w.OpCome);
                    if(w.ViaCome!=null)
                        mpVIArelacionada.put(w.OpCome.Id,w.ViaCome);
                }
            }
            System.debug(mpOCSeleccionadas);
            if(!mpOCSeleccionadas.isEmpty()){
                System.debug('**not empty');
                PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
                Map<Id,Map<String,Object>> mapDatos = pscls.GenerarDatamapOrdenes(mpOCSeleccionadas.keyset(),PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA);
                for(Id sglRecordId:mapDatos.keyset()){
                    List<Map<String,String>> lstErrores = pscls.ValidarCondicionesCamposObligatorios(mapDatos.get(sglRecordId),'Envio_VIA_PS');
                    if(!lstErrores.isEmpty()){
                        String strMensajeIncompletas = '';
                        for(Map<String,String> sglError:lstErrores){
                            system.debug(mapDatos.get(sglRecordId).get('Name')+' - '+sglError.get('Condicion__c')+' - '+sglError.get('Nivel_Error__c'));
                            if(sglError.get('Condicion__c')=='true' && sglError.get('Nivel_Error__c')=='Error'){
                                strMensajeIncompletas += '<li>' + mapDatos.get(sglRecordId).get('Name') +': '+ sglError.get('Mensaje__c') + '('+ sglError.get('MasterLabel') + ')</li>\n';
                            }
                        }
                        system.debug(strMensajeIncompletas);
                        System.debug('**strMensajeIncompletas');
                        if(String.isNotEmpty(strMensajeIncompletas))
                            strMjsErrorValidaciones = Label.Operaciones_Comerciales_Incompletas.replace('%1',strMensajeIncompletas);
                    }
                    if(String.isEmpty(strMjsErrorValidaciones)){
                        System.debug('**strMjsErrorValidaciones');
                        system.debug(mpVIArelacionada);
                        if(!mpVIArelacionada.containskey(sglRecordId)){
                            Viabilidad__c insVia = new Viabilidad__c();
                            if( String.valueOf(mapDatos.get(sglRecordId).get('activo__r.Familia__c')) == 'ENLACES DE VOZ' && String.valueOf(mapDatos.get(sglRecordId).get('TOPP__r.TipodeOperacionporplan__c')) == 'Venta'){
                                insVia.RecordTypeid = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Enlaces_de_Voz').getRecordTypeId();
                            }else
                                insVia.RecordTypeid = Schema.SObjectType.Viabilidad__c.getRecordTypeInfosByDeveloperName().get('Viabilidad_Especifica').getRecordTypeId();
                            
                            if(String.valueOf(mapDatos.get(sglRecordId).get('Plan__r.NombredelProducto__r.Productivizacion__c')) == 'true'){
                                insVia.Aliado__c = String.valueOf(mapDatos.get(sglRecordId).get('Plan__r.NombredelProducto__r.Aliado__c'));
                                insVia.Tipo_de_Aliado__c = Label.Productivizacion1;
                            }
                            insVia.OperacionComercial__c=sglRecordId;
                            insVia.EstadoViabilidad__c=Label.EnvioVia_EstPend;//SR-Modificación de estado En Proceso a Pendiente INI8524
                            insVia.APN__c = String.valueOf(mapDatos.get(sglRecordId).get('APN__c'));
                            lstViab.add(insVia);
                        }else{
                            lstViabtemp.add(mpVIArelacionada.get(sglRecordId));
                        }
                    }
                }
                Savepoint sp = Database.setSavepoint();
                try{
                    if(!lstOCMarcadas.isEmpty()){
                        BanderasEjecucion.setEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                        update lstOCMarcadas;
                        BanderasEjecucion.unsetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                    }
                    if(!lstViab.isEmpty()){
                        insert lstViab;
                    }
                    if(!lstViabtemp.isEmpty())
                        lstViab.addAll(lstViabtemp);
                }catch(Exception e){
                    Database.rollback(sp);
                    system.debug(e.getStackTraceString());
                    strMjsErrorValidaciones = e.getMessage();
                }
            }else{
                strMjsErrorValidaciones = Label.EnvioVia_DebeSelec;
            }
        }
        System.debug(strMjsErrorValidaciones);
        blnLista1 = false;
        blnLista2 = true;
        return null;
    }
    
    public pageReference GenerarIntegracion()
    {
        System.debug('GenerarIntegracion');
        Set<Id> lstId = new Set<Id>();
        Map<Id,Map<String,Object>> mapDatos = new Map<Id,Map<String,Object>>();
        PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
        System.debug(strMjsErrorValidaciones);
        if(String.isEmpty(strMjsErrorValidaciones)){
             System.debug('***Entró porque no hay errores');
            if(lstViab!=null){
                if(!lstViab.isEmpty()){
                    for(Viabilidad__c sglVia:lstViab){
                        lstId.add(sglVia.Id);
                    }
                    mapDatos = pscls.GenerarDatamapOrdenes(lstId,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA);
                }
                System.debug(lstViab);
                if(lstViab.size()==1){
                    System.debug('***Entró Lista = 1');
                    for(Id idTempDatos:mapDatos.keyset()){
                        Map<String,Object> mapTempDatos = mapDatos.get(idTempDatos);
                    //for(Map<String,Object> mapTempDatos:mapDatos.values()){
                        Map<String,Object> mpViabilidadOrigen = (Map<String,Object>)mapTempDatos.get('ViabilidadOrigen');
                        System.debug('***Integrar_con_gestor__c '+String.valueOf(mapTempDatos.get('Integrar_con_gestor__c')));
                        if(String.valueOf(mapTempDatos.get('Integrar_con_gestor__c'))=='true'){
                            Map<Id,String> mpResultado = pscls.IntegracionGestor(mapDatos,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA);
                            if(mpResultado.containskey(idTempDatos)){
                                if(String.isEmpty(mpResultado.get(idTempDatos))){
                                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,((Label.Mensaje_ok_integracion_Gestor.replace('%nro_oc%',String.valueOf(mapTempDatos.get('Name')))).replace('%Identificador%','Envio Exitoso')).replace('%nombrevia%',String.valueOf(mpViabilidadOrigen.get('Name')))));
                                }else{
                                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,mpResultado.get(idTempDatos)));
                                }
                            }else{
                                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Error no controlado'));
                            }
                            system.debug(mpResultado);
                        }else{
                            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,((Label.Mensaje_ok_creacion_VIA_sin_integ.replace('%nro_oc%',String.valueOf(mapTempDatos.get('Name')))))));
                        }
                    }
                }else{
                     System.debug('***Entró Lista > 1');
                    Set<Id> lstIdMasivo = new Set<Id>();
                    for(Id idTempDatos:mapDatos.keyset()){
                        Map<String,Object> mapTempDatos = mapDatos.get(idTempDatos);
                        Map<String,Object> mpViabilidadOrigen = (Map<String,Object>)mapTempDatos.get('ViabilidadOrigen');
                        if(String.valueOf(mapTempDatos.get('Integrar_con_gestor__c'))=='true'){
                            lstIdMasivo.add(String.valueOf(mpViabilidadOrigen.get('Id')));
                        }
                    }
                    BatchGenerico_bch bch = new BatchGenerico_bch();
                     System.debug('***lstIdMasivo '+lstIdMasivo);
                    bch.idImediato = lstIdMasivo;
                    bch.Operacion = PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.VIA_ESPECIFICA;
                    ID batchprocessid = Database.executeBatch(bch,1);
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,'Se ha lanzado el proceso masivo'));
                }
            }
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMjsErrorValidaciones));
        }
        blnLista1 = false;
        blnLista2 = true;
        
        return null;
    }
}