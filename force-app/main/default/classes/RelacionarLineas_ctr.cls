/*******************************************************************************
Desarrollado por:       ETB
Autor:                  John Guevara
Proyecto:               ETB - Gestor portafolio superior.
Descripción:            Controlador de la página RelacionarLineas_pag encargada de seleccionar
                        las lineas en las operaciones comercial de productos de voz.

Cambios (Versiones)
-------------------------------------
No.       Fecha                 Autor                 Descripción
------  ----------      --------------------        ---------------
1.0     21-09-2020      John Guevara (JOHNGUE2)       Creación de la clase
*******************************************************************************/
public class RelacionarLineas_ctr {
    public Id idObjeto;
    public Id idActivo;
    public String strMjsErrorValidaciones;
    public string sTipoOperacion;
    public string sSubTipoOperacion;
    
    public String strNumeros {get;set;}
    public String strOcName {get;set;}
    public boolean blnBuscarLineas {get;set;}
    public boolean blnPanelLineas {get;set;}
    public boolean blnBotonGuardar {get;set;}
    
    public boolean blnValidaSel{get;set;}
    public list<wrpResultados> lstResult {get;set;}
    
    Integer numeroRegistros;
    public Boolean blnAllChecked								{get; set;}
    public Boolean blnHayDatos			 						{get;set;}
    public Boolean blnmostrarPrimero							{get;set;}
    public Boolean blnmostrarUltimo			 					{get;set;}
    
    public pageReference AnalizaAccion(){
        strMjsErrorValidaciones = '';
        sTipoOperacion = '';
    	sSubTipoOperacion = '';
        strNumeros = '';
        blnBuscarLineas = false;
        blnPanelLineas = false;
        blnBotonGuardar = false;
        lstResult = new list<wrpResultados>();
        String producto = VariablesGlobales__c.getValues('NombreComercialLTE').valor__c;
        
        List<Homologacion_Gestor__mdt> lstHG = [SELECT Id,Valor_API__c,Valor_Usuario__c FROM Homologacion_Gestor__mdt WHERE Tipo_Lista__c = 'SUBTRAMITENUMERACION'];
        Map<String,String> mpHG = new Map<String,String>();
        for(Homologacion_Gestor__mdt sglHG:lstHG){
            mpHG.put(sglHG.Valor_Usuario__c,sglHG.Valor_API__c);
        }
        
        if(ApexPages.currentPage().getParameters().containskey('id')){
            idObjeto=ApexPages.currentPage().getParameters().get('id');
            List<OperacionComercial__c> lstOCPrincipal = [SELECT Id,Name,Activo__c,Estado__c,EstadoAprovisionamiento__c,Detalle_del_tramite__c,TOPP__r.TipodeOperacionporplan__c,topp__r.Requiere_Numeracion__c,Plan__r.NombredelProducto__r.Name,Plan__r.TipodePlan__c,Plan__r.Plan_Troncales_Sip_Movil__c,(SELECT Id, Linea__c,Accion__c,Portado_con_Cedula__c,LTE_Donante__c,LTE_Tipo_de_Servicio__c,Contacto_Relacionado__c FROM Lineas_OC__r) FROM OperacionComercial__c WHERE Id = :idObjeto];
            if(!lstOCPrincipal.isEmpty()){
                OperacionComercial__c sglOC = lstOCPrincipal[0];
                idActivo = sglOC.Activo__c;
                sTipoOperacion = sglOC.TOPP__r.TipodeOperacionporplan__c;
                sSubTipoOperacion = sglOC.Detalle_del_tramite__c;
                strOcName = lstOCPrincipal[0].Name;
                system.debug(sglOC.topp__r.Requiere_Numeracion__c);
                system.debug(sglOC.Detalle_del_tramite__c);
                system.debug(mpHG);
                system.debug(sglOC.Estado__c);
                if(sglOC.Plan__r.NombredelProducto__r.Name == producto && sglOC.Plan__r.TipodePlan__c == 'Troncal SIP'){
                    if(sglOC.topp__r.Requiere_Numeracion__c == true && (String.isEmpty(sglOC.Detalle_del_tramite__c) || mpHG.containskey(sglOC.Detalle_del_tramite__c))){
                        if(sglOC.Estado__c=='Pendiente'||sglOC.Estado__c=='En Curso'){
                            if(String.isEmpty(sglOC.EstadoAprovisionamiento__c)){
                                if(sglOC.Lineas_OC__r.size()>0){
                                    Map<Id,Lineas_OC__c> lstLineaOCId = new Map<Id,Lineas_OC__c>();
                                    for(Lineas_OC__c sglLineaOC:sglOC.Lineas_OC__r){
                                        if(!lstLineaOCId.containskey(sglLineaOC.Linea__c))
                                            lstLineaOCId.put(sglLineaOC.Linea__c,sglLineaOC);
                                    }
                                    system.debug(lstLineaOCId);
                                    List<Linea__c> lstLineasTemp = [SELECt Id,Name,Codigo_de_linea__c,Contacto_Relacionado__c,Tipo_servicio__c,Tipo__c,Linea_ETB__c FROM Linea__c WHERE Id IN :lstLineaOCId.keyset()];
                                    for(Linea__c sglLinea:lstLineasTemp){
                                        sglLinea.Contacto_Relacionado__c = lstLineaOCId.get(sglLinea.Id).Contacto_Relacionado__c;
                                        wrpResultados insWrp = new wrpResultados();
                                        insWrp.OpComeLinea=sglLinea;
                                        insWrp.idOpComeLinea = lstLineaOCId.get(sglLinea.Id).Id;
                                        insWrp.blnSel = true;
                                        insWrp.sAccion = lstLineaOCId.get(sglLinea.Id).Accion__c;
                                        if(sglLinea.Linea_ETB__c=='Portada Movil'){
                                            insWrp.strTipoServicio = lstLineaOCId.get(sglLinea.Id).LTE_Tipo_de_Servicio__c;
                                            insWrp.strOperador = lstLineaOCId.get(sglLinea.Id).LTE_Donante__c;
                                            insWrp.blnPorCedLTE = lstLineaOCId.get(sglLinea.Id).Portado_con_Cedula__c;
                                        }
                                        lstResult.add(insWrp);
                                    }
                                }
                                blnBuscarLineas = true;
                                if(!lstResult.isEmpty()){
                                    blnPanelLineas = true;
                                    blnBotonGuardar = true;
                                }
                            }else{
                                strMjsErrorValidaciones = 'La operación comercial no se encuentra en un estado de integración válido "'+sglOC.EstadoAprovisionamiento__c+'"';
                            }
                        }else{
                            strMjsErrorValidaciones = 'La operación comercial no se encuentra en un estado válido "'+sglOC.Estado__c+'"';
                        }
                    }else{
                        strMjsErrorValidaciones = 'El tipo de operación de la operación comercial no permite relacionar lineas';
                    }
                }else{
                    strMjsErrorValidaciones = 'El producto relacionado a la operación comercial no permite modificación en las lineas';
                }
            }
			else{
				strMjsErrorValidaciones = 'No se encuentra el registro o no se poseen permisos para acceder al objeto '+String.valueOf(idObjeto);
			}
        }
		else{
            strMjsErrorValidaciones = 'No se suministraron los parametros necesarios para cargar la página';
        }
        if(String.isNotEmpty(strMjsErrorValidaciones)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strMjsErrorValidaciones));
        }
        return null;
    }
    
    public pageReference BuscarLineas(){
        strMjsErrorValidaciones = '';
        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        this.numeroRegistros = Integer.ValueOf(vGlobal.get('CambioPlanRegxPag').valor__c);
        blnmostrarPrimero = false;
        blnmostrarUltimo = false;
        Map<String,String> mpEnlace = new Map<String,String>();
        
        try{
            if(!String.isEmpty(strNumeros)){
                strNumeros = strNumeros.endsWith(';')?strNumeros:strNumeros+';';
                Boolean bEsValido = Pattern.matches('(?:[0-9]{8,10}[-]?(?:[0-9]{8,10})?[\\;])+', strNumeros);
                system.debug(bEsValido);
                if(bEsValido){
                    
                    //Si el patron es valido se procesa la cadena para sacar la numeracion
                    pattern pttnCadena = pattern.compile('(?:[0-9]{8,10}[-]?(?:[0-9]{8,10})?[\\;])+');
                    matcher mtchCadena = pttnCadena.matcher(strNumeros);
                    
                    while(mtchCadena.find() && String.isEmpty(strMjsErrorValidaciones))
                    {
                        String sglCadena = mtchCadena.group(0);
                        system.debug(mtchCadena);
                        system.debug(sglCadena);
                        Map<String,String> mpNumerostemp = IntegracionGestor_cls.RangoNumeracion(sglCadena,'');
                        for(String sglNumerotemp:mpNumerostemp.keyset()){
                            if(sglNumerotemp!='ErrorMessage'){
                                if(!mpEnlace.containskey(sglNumerotemp))
                                    mpEnlace.put(sglNumerotemp,'');
                                else
                                    strMjsErrorValidaciones = 'El numero '+sglNumerotemp+' se encuentra duplicado.';
                            }else{
                                strMjsErrorValidaciones = mpNumerostemp.get(sglNumerotemp);
                            }
                        }
                    }
                    system.debug(mpEnlace);
                    system.debug(strMjsErrorValidaciones);
                    if(String.isEmpty(strMjsErrorValidaciones)){
                        List<Linea__c> lstLineasEx = [SELECT Id,Name,Codigo_de_linea__c FROM Linea__c WHERE Codigo_de_linea__c IN :mpEnlace.keyset()];
                        Map<String,Linea__c> mpLineasEx = new Map<String,Linea__c>();
                        for(Linea__c sglLineasEx:lstLineasEx){
                            mpLineasEx.put(sglLineasEx.Codigo_de_linea__c,sglLineasEx);
                        }
                        List<Linea__c> lstLineasNew = new List<Linea__c>();
                        for(String sgllinea:mpEnlace.keyset()){
                            if(!mpLineasEx.containskey(sgllinea)){
                                Linea__c linea = new Linea__c();
                                linea.Name = sgllinea;
                                linea.Codigo_de_linea__c = sgllinea;
                                lstLineasNew.add(Linea);
                            }
                        }
                        if(!lstLineasNew.isEmpty())
                            insert lstLineasNew;
                        
                        Set<String> lstLineasAsocOC = new Set<String>();
                        for(wrpResultados sglWrp:lstResult){
                            lstLineasAsocOC.add(sglWrp.OpComeLinea.Codigo_de_linea__c);
                        }
                        
                        List<Linea__c> lstLineasTotal = [SELECT Id,Name,Contacto_Relacionado__c,Codigo_de_linea__c,Linea_ETB__c,Tipo__c,Tipo_servicio__c,(SELECT Id,Operacion_Comercial__c FROM Lineas_OC__r WHERE Estado__c != 'Declinada' AND Estado__c != 'Facturada' AND Estado__c != 'Activa' AND Operacion_Comercial__c != :idObjeto), (SELECT Id,Activo__c FROM Lineas_AC__r WHERE Estado__c != 'Inactiva') FROM Linea__c WHERE Codigo_de_linea__c IN :mpEnlace.keyset()];
                        for(Linea__c sglLineasTotal:lstLineasTotal){
                            if(!lstLineasAsocOC.contains(sglLineasTotal.Codigo_de_linea__c)){
                                system.debug(sglLineasTotal.Lineas_OC__r.size());
                                system.debug(sglLineasTotal.Lineas_AC__r.size());
                                if(sglLineasTotal.Lineas_OC__r.size()==0){
                                    wrpResultados insWrp = new wrpResultados();
                                    insWrp.OpComeLinea=sglLineasTotal;
                                    if(sglLineasTotal.Lineas_AC__r.size()==0){
                                        insWrp.sAccion = 'Adicionar';
                                        lstResult.add(insWrp);
                                    }else if(sglLineasTotal.Lineas_AC__r.size()==1){
                                        if(sglLineasTotal.Lineas_AC__r[0].Activo__c == idActivo){
                                            insWrp.sAccion = 'Retirar';
                                            insWrp.strTipoLinea = 'Móvil ETB';
                                            insWrp.strTipoServicio = '';
                                            insWrp.strOperador = '';
                                            lstResult.add(insWrp);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else{
                    strMjsErrorValidaciones='El rango de numeracion no es valido';
                }
            }else{
                strMjsErrorValidaciones='Se debe ingresar al menos un número para realizar la búsqueda';
            }
            if(!String.isEmpty(strMjsErrorValidaciones)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strMjsErrorValidaciones));
            }else if(lstResult.isEmpty())
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No hay operaciones comerciales que cumplan con las condiciones'));
            else{
                blnPanelLineas    = true;
                blnBotonGuardar   = true;
            }
        }catch(Exception e){
            system.debug(e.getMessage() + ' - '+ e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'La numeración no se pudo procesar'));
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
        public Linea__c OpComeLinea {get;set;}
        public boolean blnSel {get;set;}
        public Id idOpComeLinea {get;set;}
        public boolean blnPorCedLTE {get;set;}
        public boolean blnEna {get;set;}
        public string sAccion {get;set;}
        public string strTipoLinea {get;set;}
        public List<Selectoption> getlstTipoLinea(){
            List<Selectoption> options 	= new list<Selectoption>();
            options.add(new Selectoption('',''));
            options.add(new Selectoption('Portada Movil','Portada Movil'));
            options.add(new Selectoption('Móvil ETB','Movil ETB'));
            return options;
        }
        public string strOperador {get;set;}
        public List<Selectoption> getlstOperador(){
            List<Selectoption> options 	= new list<Selectoption>();
            if(!String.isEmpty(strTipoLinea)){
                if(strTipoLinea=='Portada Movil'){
                    Schema.DescribeFieldResult fieldResult = OperacionComercial__c.LTE_Donante__c.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    for( Schema.PicklistEntry sglple : ple)
                    {
                        options.add(new SelectOption(sglple.getLabel(), sglple.getValue()));
                    }
                }else{
                    options.add(new Selectoption('ETB','ETB'));
                }
            }
            return options;
        }
        public string strTipoServicio {get;set;}
        public List<Selectoption> getlstTipoServicio(){
            List<Selectoption> options 	= new list<Selectoption>();
            if(!String.isEmpty(strTipoLinea)){
                if(strTipoLinea=='Portada Movil'){
                    options.add(new Selectoption('Prepago','Prepago'));
                    options.add(new Selectoption('Pospago','Pospago'));
                }else{
                    options.add(new Selectoption('ETB','ETB'));
                }
            }
            return options;
        }
        public wrpResultados(){
			OpComeLinea = new Linea__c();
			blnSel=false;
            blnPorCedLTE=false;
            strTipoLinea = 'Portada Movil';
        }
    }
    
    public pageReference guardar(){
        PageReference p=null;
        strMjsErrorValidaciones = '';
        List<Lineas_OC__c> lstLineasOC = new List<Lineas_OC__c>();
        List<Linea__c> lstLineas = new List<Linea__c>();
        
        if(idObjeto!=null){
            for(wrpResultados sglResult: lstResult){
                if(sglResult.blnSel==true || (sglResult.idOpComeLinea!=null)){
                    Lineas_OC__c sglLineaOC = new Lineas_OC__c();
                    if(sglResult.idOpComeLinea!=null){
                        sglLineaOC.Id=sglResult.idOpComeLinea;
                    }else{
                        sglLineaOC.Operacion_Comercial__c = idObjeto;
                        sglLineaOC.Linea__c = sglResult.OpComeLinea.Id;
                    }
                    sglLineaOC.Tipo_relacion__c = 'Producto Ppal Voz';
                    sglLineaOC.Accion__c = sglResult.sAccion;
                    sglLineaOC.Estado__c = (sglResult.idOpComeLinea!=null && sglResult.blnSel==false)?'Declinada':'Pendiente';
                    sglLineaOC.LTE_Tipo_de_Servicio__c = sglResult.strTipoServicio;
                    sglLineaOC.Tipo_Linea__c = sglResult.strTipoLinea;
                    sglLineaOC.LTE_Donante__c = sglResult.strOperador;
                    sglLineaOC.Portado_con_Cedula__c = sglResult.blnPorCedLTE;
                    sglLineaOC.Contacto_Relacionado__c = sglResult.OpComeLinea.Contacto_Relacionado__c;
                    lstLineasOC.add(sglLineaOC);
                    system.debug(sglResult);
                    if(!String.isEmpty(sglResult.strTipoLinea)){
                        if(!String.isEmpty(sglResult.strTipoServicio) && ((sglResult.strTipoLinea=='Portada Movil' && !String.isEmpty(sglResult.strOperador)||sglResult.strTipoLinea=='Móvil ETB'))){
                            Linea__c sglLinea = new Linea__c(Id=sglResult.OpComeLinea.Id,Tipo_servicio__c=sglResult.strTipoServicio,Linea_ETB__c=sglResult.strTipoLinea,Tipo__c=sglResult.strOperador);
                            lstLineas.add(sglLinea);
                        }else{
                            strMjsErrorValidaciones = (String.isNotEmpty(strMjsErrorValidaciones)?strMjsErrorValidaciones+'<br/>':'')+'Falta informacion obligatoria para la linea: '+sglResult.OpComeLinea.Codigo_de_linea__c;
                        }
                    }else{
                        strMjsErrorValidaciones = (String.isNotEmpty(strMjsErrorValidaciones)?strMjsErrorValidaciones+'<br/>':'')+'Falta definir el tipo para la linea: '+sglResult.OpComeLinea.Codigo_de_linea__c;
                    }
                    if((sTipoOperacion == 'Venta' || sSubTipoOperacion == 'Activacion Rotacion Numerica' || sSubTipoOperacion == 'Adicion Numeros Rotacion') && sglResult.sAccion == 'Eliminar')
                        strMjsErrorValidaciones = (String.isNotEmpty(strMjsErrorValidaciones)?strMjsErrorValidaciones+'<br/>':'')+'El tramite no admite la accion para esta linea: '+sglResult.OpComeLinea.Codigo_de_linea__c;
                    if((sTipoOperacion == 'Retiro' || sSubTipoOperacion == 'Desactivacion Rotacion Numerica' || sSubTipoOperacion == 'Disminucion Numeros Rotacion') && sglResult.sAccion == 'Adicionar')
                        strMjsErrorValidaciones = (String.isNotEmpty(strMjsErrorValidaciones)?strMjsErrorValidaciones+'<br/>':'')+'El tramite no admite la accion para esta linea: '+sglResult.OpComeLinea.Codigo_de_linea__c;
                }
            }
        }else{
            strMjsErrorValidaciones = 'parametros de página no válidos';
        }
        if(String.isEmpty(strMjsErrorValidaciones)){
            if(!lstLineasOC.isEmpty())
                upsert lstLineasOC;
            if(!lstLineas.isEmpty())
                update lstLineas;
            p = new PageReference('/'+idObjeto);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strMjsErrorValidaciones));
        }
        return p;
    }

}