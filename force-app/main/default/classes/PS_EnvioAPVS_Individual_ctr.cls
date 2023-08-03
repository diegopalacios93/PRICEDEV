/*******************************************************************************
Desarrollado por:       ETB
Autor:                  Fernando Sarasty
Proyecto:               ETB - Gestor portafolio superior.
Descripción:            Controlador de la página EnvioAPVS_Individual_pag encargada de cargar
                        la operacion comercial para enviar a aprovisionar.

Cambios (Versiones)
-------------------------------------
No.       Fecha                 Autor                 Descripción
------  ----------      --------------------        ---------------
1.0     09-05-2018      Fernando Sarasty (FS)       Creación de la clase
*******************************************************************************/

public class PS_EnvioAPVS_Individual_ctr {
    
    // declaración de variables    
    public  string  id, strNoHayOP, estadoOC;
    private string  strDebeSelec, strConfirmacionEnvio;    
    public  string  NameOC									{get;set;}     
    public  boolean blnLista								{get;set;}        
    public  boolean blnLista2								{get;set;}    
    public  boolean blnPendVia								{get;set;}
    
    
    // declaración de Map's
    public map<string,string> mapParameters;
    
    // declaración de listas    
    public list<OperacionComercial__c> lstOpCom = new list<OperacionComercial__c>();    
    
    // ----------------------------------  Funciones --------------------------------------------------------------------
       
    public void Iniciar(){        
        //Inicializar variables
        blnLista    = true;        
        blnLista2   = false;
        blnPendVia	= false;
        strNoHayOP  = Label.EnvioAPVS_NoHayOP;
        strDebeSelec= Label.EnvioVia_DebeSelec;
        strDebeSelec= Label.EnvioVia_DebeSelec;
        strConfirmacionEnvio = Label.EnvioAPVS_ConfirmacionOC;
        
        //leer parámetros de la página EnvioAPVS_pag        
        mapParameters = new map<string,string>();
        mapParameters=ApexPages.currentPage().getParameters();
        id = mapParameters.get('id');  
        NameOC = mapParameters.get('nombre');
        estadoOC = mapParameters.get('status');        
    } 
    
    public pageReference AnalizaAccion(){        
        Iniciar();         
        if(estadoOC == 'En Curso' || estadoOC == 'Pendiente'){
            if(obtenerEstadoLegalizacion(id) == Null || obtenerEstadoLegalizacion(id) == 'Gestionado')
            {
                if(id != null && id != '')
                {
                    lstOpCom = ConsultarOperacionComercial(id);            
                    if(lstOpCom.size()<1){
                        blnLista  = false;
                        blnLista2 = true;
                        if(blnPendVia)
                        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EnvioAPVS_Pendiente_VIA));
                        else
                        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strNoHayOP));                
                    }else{
                        if(lstOpCom[0].Integrar_con_gestor__c)
                        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, strConfirmacionEnvio));
                        else{
                            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'La OC no tiene la marca de Envio a Gestor por lo cual se debe trabajar por el procedimiento y sistema previo a la integracion'));
                            blnLista  = false;
                            blnLista2 = true;
                        }
                    }
                }
            }else{
                blnLista  = false;
                blnLista2 = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.Mensaje_error_legalizacion_no_gestionada));                
            }
        }else{
            blnLista  = false;
            blnLista2 = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.Mensaje_error_OC_no_pendiente_en_curso));
        }                
        return null;        
    }
   
    public pageReference GenerarIntegracion(){
        //Map<Integer, String> respuestaIntegracion = new Map<Integer, String>();        
        //String MensajeInteg, ResultadoInteg, tempResult, nombreOC, idOC;
        //LogTransacciones__c lt;
                
        try{
            Set<Id> idRegistros = new Set<Id>();
            for(OperacionComercial__c sglOp:lstOpCom){
                idRegistros.add(sglOp.Id);
            }
            
            PS_IntegracionSalidaGestor_cls pscls = new PS_IntegracionSalidaGestor_cls();
            Map<Id,Map<String,Object>> mapDatos = pscls.GenerarDatamapOrdenes(idRegistros,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO);
            Map<Id,String> mpResultado = pscls.IntegracionGestor(mapDatos,PS_IntegracionSalidaGestor_cls.TipoOperacionOrdenGestor.APROVISIONAMIENTO);
            String sResultado = '';
            if(!mpResultado.isEmpty()){
                for(OperacionComercial__c sglOp:lstOpCom){
                    if(sglOP.Integrar_con_gestor__c){
                    sResultado = mpResultado.containskey(sglOp.Id)?mpResultado.get(sglOp.Id):'No Procesado';
                    if(String.isNotEmpty(sResultado)){
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,sResultado));
                    }else{
                        String nombreOC = sglOp.Name;
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,((Label.Mensaje_ok_integracion_Gestor_apvs.replace('%nro_oc%',nombreOC)).replace('%Identificador%','Se ha guardado el registro exitosamente.')).replace('%nombrevia%',nombreOC)));
                    }
                    }else{
                        sResultado = 'La OC no tiene la marca de Envio a Gestor por lo cual se debe trabajar por el procedimiento y sistema previo a la integracion';
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,sResultado));
                    }
                }
            }else{
                sResultado = 'No procesado';
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,sResultado));
            }
            /*
            for(OperacionComercial__c objOComercial: lstOpCom){
                
                nombreOC = objOComercial.Name;
                idOC     = objOComercial.Id;
                respuestaIntegracion = PS_IntegracionSalidaGestor_cls.integracionAprovisionamiento(idOC, nombreOC, null, null, null, null);
                //registrar log de transacciones
                lt =new LogTransacciones__c(CorrelationId__c=idOC,LTE_Operacion_Comercial__c=idOC,Informacion_Enviada__c= respuestaIntegracion.get(3),Informacion_Recibida__c=respuestaIntegracion.get(4),Name='GestorSolicitudesAprovisionamiento - '+nombreOC);                       
                insert lt;
                
                ResultadoInteg       = respuestaIntegracion.get(1);
                MensajeInteg         = respuestaIntegracion.get(2);
                System.debug('--> PS_EnvioAPVS_Individual_ctr > GenerarIntegracion > respuestaIntegracion '+respuestaIntegracion);
                
                if(ResultadoInteg == null || ResultadoInteg == '')
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,Label.Mensaje_error_integracion_Gestor_no_disponible_apvs.replace('%nro_oc%', nombreOC)));
                else if(ResultadoInteg != '1')                    
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,(Label.Mensaje_error_integracion_Gestor_apvs.replace('%nro_oc%', nombreOC)).replace('%msj_error%',MensajeInteg)));               
                else{                    
                    objOComercial.EstadoAprovisionamiento__c = 'En Aprovisionamiento';
                    objOComercial.Fecha_Envio_Integracion_Gestor__c = DateTime.now();
                    Update  objOComercial;
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM,((Label.Mensaje_ok_integracion_Gestor_apvs.replace('%nro_oc%',nombreOC)).replace('%Identificador%',MensajeInteg)).replace('%nombrevia%',nombreOC)));
                }                            
            }            
			*/
            blnLista = false;
            blnLista2 = true;
            
        }catch(Exception e){
            system.debug(e.getMessage());
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,e.getMessage()));
        }
        return null;
    }
    
    private List<OperacionComercial__c> ConsultarOperacionComercial(String IdOC)
    {        
        String strQueryOpCom, strRequiereViaAdicional;
        List<OperacionComercial__c> lstOpComer    = new List<OperacionComercial__c>();        
        Viabilidad__c[] objVia;
        OperacionComercial__c[] objOC;
        objOC  = [SELECT Oportunidad__r.Viabilidad_Adicional__c, TOPP__r.AplicaGerenteProyecto__c, TOPP__r.AplicaPreventa__c FROM OperacionComercial__c WHERE Id =: IdOC LIMIT 1];
        objVia = [SELECT Name FROM Viabilidad__c WHERE EstadoViabilidad__c = 'Cerrada' AND Respuestadeviabilidad__c = 'Viable' AND OperacionComercial__c =: IdOC ORDER BY CreatedDate DESC NULLS FIRST LIMIT 1];
        
        if(objOC[0].TOPP__r.AplicaGerenteProyecto__c == true){
            strQueryOpCom  = 'Select Id, Name, Integrar_con_gestor__c,Activo__r.NombredelProducto__c, Plan__c, TOPP__c, SucursalDestino__c From OperacionComercial__c';
            strQueryOpCom += ' Where Id = \''+IdOC+'\' AND';
            //strQueryOpCom += ' Integrar_con_gestor__c = TRUE AND';
            strQueryOpCom += ' (Estado__c = \'En Curso\' OR Estado__c = \'Pendiente\') AND';
            strQueryOpCom += ' EstadoAprovisionamiento__c <> \'En Aprovisionamiento\' AND (Legalizacion__r.Estado__c = \'Gestionado\' OR Caso__c <> null OR (Caso__c = null AND Detalle_del_tramite__c IN (\'Por Pago\',\'ACTUALIZACIONSERVICIO\')))';
        }else{
            if(objOC[0].TOPP__r.AplicaPreventa__c == true){
                if(objVia.size() > 0 || objOC[0].Oportunidad__r.Viabilidad_Adicional__c == 'No requiere'){                    
                    strQueryOpCom  = 'Select Id, Integrar_con_gestor__c,Name, Activo__r.NombredelProducto__c, Plan__c, TOPP__c, SucursalDestino__c From OperacionComercial__c';
                    strQueryOpCom += ' Where Id = \''+IdOC+'\' AND';
                    strQueryOpCom += ' (Estado__c = \'En Curso\' OR Estado__c = \'Pendiente\') AND';
                    strQueryOpCom += ' EstadoAprovisionamiento__c <> \'En Aprovisionamiento\'';
            	}
                else
                    blnPendVia = true;              
            }else{
                strQueryOpCom  = 'Select Id, Name, Integrar_con_gestor__c,Activo__r.NombredelProducto__c, Plan__c, TOPP__c, SucursalDestino__c From OperacionComercial__c';
                strQueryOpCom += ' Where Id = \''+IdOC+'\' AND';
                strQueryOpCom += ' (Estado__c = \'En Curso\' OR Estado__c = \'Pendiente\') AND';
                strQueryOpCom += ' EstadoAprovisionamiento__c <> \'En Aprovisionamiento\' AND Caso__c <> null';          
            }
        }        
        System.debug('--> consultarOperacionesComerciales > strQueryOpCom: '+strQueryOpCom);
        
        if(strQueryOpCom != null)
        	lstOpComer = Database.query(strQueryOpCom);
        
        return lstOpComer;
    } 
    
    public pageReference Cancelar(){
        PageReference p=null;
        if(id!=null){
           p = new PageReference('/'+id);
        }
        return p;
    }
    
    private string obtenerEstadoLegalizacion(String IdOC){
        OperacionComercial__c[] objOC;
        try{
            objOC  = [SELECT Legalizacion__r.Estado__c FROM OperacionComercial__c WHERE Id =: IdOC LIMIT 1];
            return objOC[0].Legalizacion__r.Estado__c;
        
        }catch(exception e){
            return null;
        }        
    }
}