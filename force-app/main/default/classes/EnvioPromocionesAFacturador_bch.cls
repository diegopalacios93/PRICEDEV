/**************************************************************************************************
Desarrollado por: Accenture
Autores: Luisina Platino
Proyecto: ETB MiPymes y Empresas        
Descripción: Construcción del Batch para la integración hacia facturador (Promociones, descuentos) Salesforce-Tibco --> Tibco-Rechain 
Clase test: ConstruirXMLScheduleFacturador_tst
 
Cambios (Versiones)
-------------------------------------
No.     Fecha           Autores                Descripción
1.0     11/03/2022      Luisina Platino (LP)   Creacion de la clase
***************************************************************************************************/
public  class EnvioPromocionesAFacturador_bch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{

    public boolean limitQ = false;
    public integer limiteTotal = 30;
    public boolean esVIP = false;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT  Name, Tipo_Promocion__c, Fecha_Inicio__c, Fecha_Fin__c, Descuento__c, Estado__c, Operacion_Comercial__c, ' +
            'Operacion_Comercial__r.FechadeActivacion__c, Operacion_Comercial__r.CuentaFacturacion__c, Operacion_Comercial__r.CuentaFacturacion__r.Name, ' +
            'Operacion_Comercial__r.Activo__r.ExternalServiceID__c, ReglaDeCampana__r.ComponenteCampana__r.Plan__c, Operacion_Comercial__r.Plan__c, ' +
            'ReglaDeCampana__r.ComponenteCampana__r.Producto__c  ' +
            'FROM PromocionAplicada__c ' +
            'WHERE Tipo_Promocion__c IN (\'RANGO\', \'ONE SHOT\') ' +
            'AND Estado__c IN (\'Pendiente Envio\', \'Error en el envio\')';
        	query += ' ORDER BY Fecha_Inicio__c ';
            if(limitQ){
                query += ' LIMIT ' + limiteTotal + ' ';       
            } 
        	
        return Database.getQueryLocator( query );
    }

    public void execute(Database.BatchableContext bc, List<PromocionAplicada__c> listapromociones){
        List<String> xmlSolicitudes = new List<String>();
        List<consultaServ> listConsultaService = new List<ConsultaServ>();
        Set<Id> idPlanesProm = new Set<Id>();
        Map<String, String> mapSfeaturePorPlan = new map<string, string>();

        for (PromocionAplicada__c prom : listapromociones) {
            idPlanesProm.add(prom.Operacion_Comercial__r.Plan__c);
        }

        List<ParametroFacturacion__c> lstParametros = [SELECT LTE_ValorDefecto__c,Name,PlanFacturacion__r.Plan__c FROM ParametroFacturacion__c WHERE PlanFacturacion__r.Plan__c IN :idPlanesProm AND Name = 'RVC FEAT'];
        for (ParametroFacturacion__c paramf : lstParametros) {
            mapSfeaturePorPlan.put(paramf.PlanFacturacion__r.Plan__c, paramf.LTE_ValorDefecto__c);
        }

        for (PromocionAplicada__c promocion : listapromociones) {
            String sFeature = mapSfeaturePorPlan.get(promocion.Operacion_Comercial__r.Plan__c);
            String xml = ConstruirXMLFacturador_cls.CrearXMLFactEnviarProm(promocion,sFeature);
            listConsultaService.add(new consultaServ(promocion, xml));
        }

        guardar(listConsultaService);
    }

    public void finish(Database.BatchableContext bc){
    }

    public class consultaServ{
        public string xmlResponse;
        public string xmlRequest = '';
        public LogTransacciones__c logObj = new LogTransacciones__c();
        public PromocionAplicada__c promocion;

        public consultaServ(PromocionAplicada__c promocion, string xmlRequest){
            this.promocion = promocion;
            this.xmlRequest = xmlRequest;
            consultar();
        }

        //Consume el servicio web
        public void consultar(){
            ServiciosWeb__c sw = ServiciosWeb__c.getValues('InvocacionServiceProvisioning');
            if(!Test.isRunningTest()){
                xmlResponse = LibreriaUtilitariaJobs_cls.consultarServicio(xmlRequest, sw.Action__c, sw.EndPoint__c);
            }else{
                xmlResponse = ConstruirXMLFacturador_cls.obtnerResponseTest();
            }

            Dom.Document docResponse = new Dom.Document();
            docResponse.load(xmlResponse);
            Dom.XMLNode serviceResponseNode = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'Service');
           
            String status = '';
            if(serviceResponseNode.getName() != 'Vacio')
                status = serviceResponseNode.getChildElement('status', serviceResponseNode.getNamespace()).getText();                       

            if (status == 'PASS'){
                Dom.XMLNode BodyResponse = PS_UtilitaryMethodsClass_cls.getNodeFromDomDocument(docResponse,'BodyResponse');
                if(BodyResponse.getName() != 'Vacio'){
                    Dom.XMLNode faults = PS_UtilitaryMethodsClass_cls.getNodeFromDomXMLNode(BodyResponse,'faults');                                
                    if(faults != null){
                        logObj.Estado__c = 'Fallido';
                        promocion.Estado__c = 'Error en el envio';  
                    }else{                            
                        logObj.Estado__c = 'Exitoso';
                        promocion.Estado__c = 'Envio Exitoso';  
                    }
                }                        
            }else{
                logObj.Estado__c = 'Fallido';
                promocion.Estado__c = 'Error en el envio';      
            }
            
            logObj.Informacion_Enviada__c = xmlRequest;
            logObj.Informacion_Recibida__c = xmlResponse;
            logObj.LTE_CuentaFacturacionLTE__c = promocion.Operacion_Comercial__r.CuentaFacturacion__c;
            logObj.LTE_Operacion_Comercial__c = promocion.Operacion_Comercial__c;
            logObj.Name = 'Envio Promoción Facturador ' + logObj.LTE_CuentaFacturacionLTE__c; 
        }
    }
    
    public void guardar(list<consultaServ> listConsultaService){
        List<PromocionAplicada__c> promoLst=new List<PromocionAplicada__c>();
        List<LogTransacciones__c> logLst=new List<LogTransacciones__c>();
        
        for(consultaServ cs: listConsultaService){
            promoLst.add(cs.promocion);
            logLst.add(cs.logObj);
        }
        
        update promoLst;
        insert logLst; 
    }

}