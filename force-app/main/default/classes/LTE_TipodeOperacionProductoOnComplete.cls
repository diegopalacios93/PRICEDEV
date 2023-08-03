public with sharing class LTE_TipodeOperacionProductoOnComplete {
    
    public class CambiodePlan extends LTE_Tramites_cls.Step 
    {
        private set<string> actualizan=new set<string>();
        //private map<string,string> modificarValor=new map<string,string>();
        
        public CambiodePlan(){
            init();
            actualizan.add('TELEFONIA MOVIL (LTE)');
            eliminar.add('PLAN PAGO POR USO PREPAGO');
        }
        
        
        public override void procesar()
        {            
            modificarValor.put('METODO DE PAGO',oc.Plan__r.LTE_MetodoDePago__c);           
            //Plan Nuevo 
            accion='ADD';
            for(integer i=0;i<sa.size();i++){
                sa[i].LTE_ServiceActionCode__c=accion;
                sa[i].LTE_ServicioETB__c=oc.Activo__c;
                if(sa[i]!=null){
                    list<LTE_SpecificationGroupXA__c> sgXA=sa[i].SpecificationGroupXA__r;
                    sa[i].LTE_ServiceActionCode__c=accion;
                    actualizarSgXa(sa[i],sa[i].LTE_ServiceActionCode__c);
                    //newSa.add(sa[i]);                    
                }
                
            }
            //Analisis Plan anterior
            string accionGlobal='NONE';
            for(integer i=0;i<saActivo.size();i++){
                string accionPuntual=accionGlobal;
                system.debug(saActivo[i].Name+' '+saActivo[i].LTE_ServicioETB__r.Plan__r.Name);
                //AG 2016-08-01 Se adiciona la condición para evaluar las bolsas de voz a la medida
                //[FSARASTY, 25/01/2019]: Se incluye consulta de nombre de plan de facturación, para asegurar que el código de acción
                //del servicio adicional del plan anterior, sea actualizado a "DELETE"
                if(saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c=='Bolsa de Datos a la medida' || saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c=='Bolsa de Voz a la medida' || saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c=='SVA-Bolsa Recurrente de datos' || saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c=='SVA-Bolsa Recurrente de datos Automatica' || saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c=='Troncal SIP' || saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c=='Planes Obsoletos' || saActivo[i].Name==saActivo[i].LTE_ServicioETB__r.Plan__r.Name){
                    accionPuntual='DELETE';
                }
                
                if(actualizan.contains(saActivo[i].Name)){
                    accionPuntual='UPDATE'; 
                }
                
                if(eliminar.contains(saActivo[i].Name)){
                    accionPuntual='ELIMINADO';
                }
                if(saActivo[i]!=null){
                    saActivo[i].LTE_ServiceActionCode__c=accionPuntual;
                    actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                    //newSa.add(saActivo[i]);
                }                
            }
        }        
        //[FSARASTY: Consulta del nombre del plan de facturación]
        public String obtenerNombreCuentaFact(Id IdPlan)
        {
            List<PlanFacturacion__c> lstPlanFact = new List<PlanFacturacion__c>();
            if(IdPlan != null)
            {            
                lstPlanFact = [SELECT Name FROM PlanFacturacion__c WHERE Plan__c =:IdPlan LIMIT 1];
                if(!lstPlanFact.isEmpty()){
                   system.debug(':: Nombre plan de facturación: '+lstPlanFact[0].Name);
                   return lstPlanFact[0].Name;
                }else return null;
            }else return null;        
        }
    }
    
    public class Suspension extends LTE_Tramites_cls.Step 
    {
        //private map<string,string> modificarValor=new map<string,string>();
        private map<string,string> modificarCampo=new map<string,string>();
        
        public Suspension(){
            init();
        }
        
        public override void procesar()
        {
            
            //EL SEGURO EN SALESFORCE SE VE COMO UN SVA, TIBCO LO CONVIERTE EN UN SERVICIO EN REVACHAIN
            //NINGUNA SUSPENSION DEBE TOCAR EL SEGURO
            set<string> noTocar=new set<string>();
            noTocar.add('SVA-Seguro de terminales');
            
            if(oc.TipoSuspension__c=='Voluntaria'){
                voluntaria();           
            }       
            
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='SUSPEND';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='NONE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else if(noTocar.contains(saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c)){
                        saActivo[i].LTE_ServiceActionCode__c='NONE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else{
                        saActivo[i].LTE_ServiceActionCode__c=accion;
                        if(saActivo[i]!=null){
                            saActivo[i].LTE_ServiceActionCode__c=accion;
                            actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                            newSa.add(saActivo[i]); 
                        }                           
                    }
                }
            }
            
            saActivo=newSa;
            
        }
        
                /*public void voluntaria(){
            system.debug(ac);
            system.debug(ac.LTE_Fecha_Alta_inicial__c); 
            if(ac.LTE_Fecha_Alta_inicial__c==null){             
                ac.LTE_Fecha_Alta_inicial__c=date.valueOf(ac.Fecha_Activacion__c);
            }
            
            integer mes=ac.LTE_Fecha_Alta_inicial__c.month();
            integer dia=ac.LTE_Fecha_Alta_inicial__c.day();
            integer ano=ac.LTE_Fecha_Alta_inicial__c.year();
            
            Date cicloActualInicio=Date.newInstance(date.today().year(), mes, dia);
            Date cicloActualFin=cicloActualInicio.addYears(1);
            system.debug(cicloActualInicio +' '+cicloActualFin);
            
            
            if(cicloActualInicio<date.today()){
                ac.LTE_Fecha_Inicial_Contrato__c=cicloActualInicio;     
            }else if(cicloActualInicio.addYears(-1) >=ac.LTE_Fecha_Alta_inicial__c){
                ac.LTE_Fecha_Inicial_Contrato__c=cicloActualInicio.addYears(-1);
                ac.LTE_Numero_veces_suspendido__c=0;
                ac.LTE_Dias_suspendidos__c=0;
            }else{
                ac.LTE_Fecha_Inicial_Contrato__c=ac.LTE_Fecha_Alta_inicial__c;
                ac.LTE_Numero_veces_suspendido__c=0;            
            }
            ac.LTE_Fecha_Final_Contrato__c=ac.LTE_Fecha_Inicial_Contrato__c.addYears(1);
            ac.LTE_Fecha_Ultima_Suspension__c=date.today();
            ac.LTE_Numero_veces_suspendido__c++;
        }*/
        
        public void voluntaria(){
            System.debug('=== voluntaria ===');
            Date cicloInicial;
            Date cicloFinal;
            Date hoy = Date.today();
            Integer mes;
            Integer dia;
            Integer anio;
            Boolean isFirstTime = false; //Primera vez que se hace una suspensión
            Boolean isOnCurrent; //Indica si la suspensión esta dentro de el periodo válido
            
            if(ac.LTE_Fecha_Alta_inicial__c == null){               
                ac.LTE_Fecha_Alta_inicial__c = Date.valueOf(ac.Fecha_Activacion__c);
            }
            
          //  if(!Test.isRunningTest()){
                dia = ac.LTE_Fecha_Alta_inicial__c.day();
                mes = ac.LTE_Fecha_Alta_inicial__c.month();
                anio = ac.LTE_Fecha_Alta_inicial__c.year();
       //     }
            //Se calcula el ciclo inicial y el cilo final
            cicloInicial = Date.newInstance(hoy.year(), mes, dia);
            cicloFinal = cicloInicial.addYears(1);
            
            ac.LTE_Numero_veces_suspendido__c = (ac.LTE_Numero_veces_suspendido__c ==null)?0:ac.LTE_Numero_veces_suspendido__c;
            ac.LTE_Dias_suspendidos__c = (ac.LTE_Dias_suspendidos__c ==null)?0:ac.LTE_Dias_suspendidos__c;
            
            if(ac.LTE_Fecha_Inicial_Contrato__c == null){   
                isFirstTime = true;
            }
            
            if(isFirstTime){
                if(hoy < cicloInicial){
                    System.debug('Hoy: ' + hoy.format());
                    System.debug('CicloInicial: ' + cicloInicial.format());
                    cicloInicial = cicloInicial.addYears(-1);
                }
                System.debug('Es la primera vez que se realiza una suspensión');
                ac.LTE_Fecha_Inicial_Contrato__c = cicloInicial;
            }else{
                if(ac.LTE_Fecha_Inicial_Contrato__c <= hoy && hoy <= ac.LTE_Fecha_Final_Contrato__c){
                    System.debug('Hoy esta entre las dos fechas');
                }else{
                    System.debug('Hoy NO esta entre las dos fechas');
                    ac.LTE_Fecha_Inicial_Contrato__c = cicloInicial;
                    ac.LTE_Numero_veces_suspendido__c=0;
                    ac.LTE_Dias_suspendidos__c=0;
                }
            }
            
            ac.LTE_Fecha_Final_Contrato__c = ac.LTE_Fecha_Inicial_Contrato__c.addYears(1).addDays(-1);
            ac.LTE_Fecha_Ultima_Suspension__c = hoy;
            ac.LTE_Numero_veces_suspendido__c++;   
        }
        
        
        
    }
    
    public class Reconexion extends LTE_Tramites_cls.Step 
    {
        
        
        public Reconexion(){
            init();
        }
        
        public override void procesar()
        {
            list<Integer> remover=new list<Integer>();
            
            if(oc.TipoSuspension__c=='Voluntaria'){
                voluntaria();           
            }
            
            //EL SEGURO EN SALESFORCE SE VE COMO UN SVA, TIBCO LO CONVIERTE EN UN SERVICIO EN REVACHAIN
            //NINGUNA SUSPENSION DEBE TOCAR EL SEGURO
            set<string> noTocar=new set<string>();
            noTocar.add('SVA-Seguro de terminales');
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='RESUME';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='NONE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]); 
                    }else if(noTocar.contains(saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c)){
                        saActivo[i].LTE_ServiceActionCode__c='NONE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else{
                        newSa.add(saActivo[i]);
                        saActivo[i].LTE_ServiceActionCode__c=accion;
                        if(saActivo[i]!=null){
                            list<LTE_SpecificationGroupXA__c> sgXA=saActivo[i].SpecificationGroupXA__r;
                            for(LTE_SpecificationGroupXA__c sg :sgXA){
                                sg.LTE_ActionCode__c=accion;
                            }
                            
                        }
                    }
                }
            }
            
            saActivo=newSa;
            
            
            
        }
        public void voluntaria(){
            ac.LTE_Fecha_Ultima_Reconexion__c=date.today();
            if(!Test.isRunningTest()){
         	   ac.LTE_Dias_suspendidos__c=Decimal.valueOf(ac.LTE_Fecha_Ultima_Suspension__c.daysBetween(ac.LTE_Fecha_Ultima_Reconexion__c));
            }
        }
        
        
    }
    
    public class CambioNumero extends LTE_Tramites_cls.Step 
    {
        private set<string> actualizan=new set<string>();
        
        
        
        public CambioNumero(){
            init();
        }
        
        public override void procesar()
        {
            modificarValor.put('Numero',oc.NumeroConexion__c);
            modificarValor.put('NumeroAnterior',oc.Activo__r.NumeroConexion__c);
            modificarValor.put('CAMBIO DE NUMERO?','YES');
            modificarValor.put('Numero Anterior LTE',oc.Activo__r.NumeroConexion__c);
            actualizan.add('NUMERO TELEFONICO LTE');
            actualizan.add('TELEFONIA MOVIL (LTE)');
            
            
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='ADD';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='NONE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]); 
                    }else if(actualizan.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='UPDATE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);                 
                    }else{
                        newSa.add(saActivo[i]);
                        saActivo[i].LTE_ServiceActionCode__c=accion;
                        if(saActivo[i]!=null){
                            actualizarSgXa(saActivo[i],accion);
                        }
                    }
                }
            }
            
            saActivo=newSa;
            
            
        }
        
        
        
    }
    
    public class adicionsva extends LTE_Tramites_cls.Step 
    {
        private set<string> actualizan=new set<string>();
        //private map<string,string> modificarValor=new map<string,string>();
        
        public adicionsva(){
            init();
        }
        
        
        public override void procesar()
        {
            //list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            set<string> eliminarMismoTipo=new set<string>();
            set<string> eliminarMismoInmediato=new set<string>();
            set<string> eliminarNoFact=new set<string>();
            
            actualizan.add('TELEFONIA MOVIL (LTE)');
            
            eliminarMismoInmediato.add('SVA-Bolsa Única vez de datos');
            eliminarMismoInmediato.add('SVA-Bolsa Única vez de voz');
            
            accion='ADD';
            system.debug(sa);
            if(sa!=null){
                for(integer i=0;i<sa.size();i++){
                    sa[i].LTE_ServicioETB__c=oc.Activo__c;
                    
                    system.debug(sa[i].Id+' '+sa[i].LTE_ServicioETB__c+' '+oc.Activo__c);
                    sa[i].LTE_ServicioETB__c=oc.Activo__c;
                    
                    system.debug(eliminarMismoInmediato+' '+sa[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c+' '+eliminarMismoInmediato.contains(sa[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c));
                    if(eliminarMismoInmediato.contains(sa[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c)){
                        sa[i].LTE_ServiceActionCode__c='ELIMINADO';
                        actualizarSgXa(sa[i],sa[i].LTE_ServiceActionCode__c);
                    }
                    else{
                        sa[i].LTE_ServiceActionCode__c=accion;
                        actualizarSgXa(sa[i],sa[i].LTE_ServiceActionCode__c);                   
                    }
                    if(!Test.isRunningTest()){
                        if(sa[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c.startsWith('SVA-')){
                            eliminarMismoTipo.add(sa[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c);
                        }
                    }
                    
                    //saActivo.add(sa[i]);
                    system.debug(sa[i].LTE_ServicioETB__c);
                    
                }
            }
            

            
            
            accion='NONE';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='NONE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        //newSa.add(saActivo[i]);
                    }else if(actualizan.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='UPDATE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        //newSa.add(saActivo[i]);
                    }else if(eliminarMismoTipo.contains(saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c)){
                        saActivo[i].LTE_ServiceActionCode__c='DELETE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        //newSa.add(saActivo[i]);
                    }else{
                        //newSa.add(saActivo[i]);
                        saActivo[i].LTE_ServiceActionCode__c=accion;
                        if(saActivo[i]!=null){
                            actualizarSgXa(saActivo[i],accion);
                        }
                    }
                    

                }
            }
            
            //saActivo=newSa;
        }
        
        
    }
    
    public class retirosva extends LTE_Tramites_cls.Step 
    {
        private set<string> actualizan=new set<string>();
        private set<string> facturado=new set<string>();
        //private map<string,string> modificarValor=new map<string,string>();
        
        public retirosva(){
            actualizan.add('TELEFONIA MOVIL (LTE)');
            init();
            
            facturado.add('Bolsa Única vez');
            facturado.add('Roaming');  
        }
        
        
        public override void procesar()
        {
            set<string> eliminarMismoTipo=new set<string>();
            
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='NONE';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    /*if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i]=null;
                    }else*/ if(actualizan.contains(saActivo[i].Name)){
                        system.debug('UPDATE');
                        saActivo[i].LTE_ServiceActionCode__c='UPDATE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else if(saActivo[i].LTE_OC_Tramite__c==oc.id){
                        if(facturado.contains(oc.categoria__c)){
                            saActivo[i].LTE_ServiceActionCode__c='ELIMINADO';
                        } else{
                            saActivo[i].LTE_ServiceActionCode__c='DELETE';
                        }
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else{
                        newSa.add(saActivo[i]);
                        saActivo[i].LTE_ServiceActionCode__c=accion;
                        if(saActivo[i]!=null){
                            actualizarSgXa(saActivo[i],accion);
                        }
                    }
                }
            }            
            saActivo=newSa;
        }
    }
    
	public class Reposicion extends LTE_Tramites_cls.Step 
    {
        //private map<string,string> modificarValor=new map<string,string>();
        private set<string> actualizan=new set<string>();
        
        
        public Reposicion(){
            
            init();
        }
        
        public override void procesar()
        {
            modificarValor.put('CAMBIO SIMCARD','VERDADERO');
            modificarValor.put('ICCID',oc.LTE_ICCID__c);
            modificarValor.put('IMSI',oc.LTE_IMSI__c);
            modificarValor.put('PIN',oc.LTE_PIN__c);
            modificarValor.put('PUK',oc.LTE_PUK__c);
            //JACERO 09082018 INI9685 
            modificarValor.put('SDP',oc.SDP__c);
            actualizan.add('NUMERO SIM CARD');
            eliminar.add('EQUIPO PROPIEDAD CLIENTE');
            
            //eliminar.add('SVA-Seguro de terminales');
            
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='NONE';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i]=null;
                    }/*else if(eliminar.contains(saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c) && oc.LTE_TipoTransaccion__c!='SIM'){
                        saActivo[i].LTE_ServiceActionCode__c='DELETE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }*/else if(actualizan.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='UPDATE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);       
                        newSa.add(saActivo[i]);         
                    }else if(eliminar.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='DELETE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else{
                        if(saActivo[i]!=null){
                            saActivo[i].LTE_ServiceActionCode__c=accion;
                            actualizarSgXa(saActivo[i],accion);
                            newSa.add(saActivo[i]);
                        }
                    }
                }
            }
            
            saActivo=newSa;
            
            
            list<LTE_Servicios_adicionales__c> newSaDO=new list<LTE_Servicios_adicionales__c>();
            set<string> actualizanSA_DO=new set<string>();
            
            actualizanSA_DO.add('TELEFONIA MOVIL (LTE)');
            
            if(oc.LTE_TipoTransaccion__c=='Equipo más SIM' || oc.LTE_TipoTransaccion__c=='Equipo'){
                //actualizanSA_DO.add('EQUIPO PROPIEDAD CLIENTE');
                if(oc.IMEI_del_Equipo__c!=null){
                    modificarValorDO.put('IMEI',oc.IMEI_del_Equipo__c);
                }
                
                if(oc.LTE_ReferenciaEquipo__c != null){
                    modificarValorDO.put('MODELO',oc.LTE_ReferenciaEquipo__r.Name);
                    modificarValorDO.put('MARCA',oc.LTE_ReferenciaEquipo__r.LTE_Marca__c);
                } else{
                    system.debug('======================================================');
                    system.debug('======== oc.LTE_ReferenciaEquipo__c esta NULO ========');
                    system.debug('======================================================');
                }
            }
            
            if(sa!=null){
                for(integer i=0;i<sa.size();i++){
                    if(actualizanSA_DO.contains(sa[i].Name)){
                        sa[i].LTE_ServiceActionCode__c='UPDATE';
                    }
                    actualizarSgXaDO(sa[i],sa[i].LTE_ServiceActionCode__c);
                    newSaDO.add(sa[i]);
                }
            }
            
            if(!newSaDO.isEmpty()){
                sa = newSaDO;
            }
            
        }
        
        
    }
    
    public class Renovacion extends LTE_Tramites_cls.Step 
    {
        //private map<string,string> modificarValor=new map<string,string>();
        private set<string> actualizan=new set<string>();
        
        
        public Renovacion(){
            init();
        }
        
        public override void procesar()
        {
            modificarValor.put('CAMBIO SIMCARD','VERDADERO');
            modificarValor.put('ICCID',oc.LTE_ICCID__c);
            modificarValor.put('IMSI',oc.LTE_IMSI__c);
            modificarValor.put('PIN',oc.LTE_PIN__c);
            modificarValor.put('PUK',oc.LTE_PUK__c);
            //JACERO 09082018 INI9685
            modificarValor.put('SDP',oc.SDP__c);
            actualizan.add('NUMERO SIM CARD');
            eliminar.add('EQUIPO PROPIEDAD CLIENTE');
            
            //eliminar.add('SVA-Seguro de terminales');
            
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='NONE';
            iF(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i]=null;
                    }/*else if(eliminar.contains(saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c)  && oc.LTE_TipoTransaccion__c!='SIM'){
                        saActivo[i].LTE_ServiceActionCode__c='DELETE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }*/else if(actualizan.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='UPDATE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);                   
                        newSa.add(saActivo[i]); 
                    }else if(eliminar.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='DELETE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else{
                        if(saActivo[i]!=null){
                            saActivo[i].LTE_ServiceActionCode__c=accion;
                            actualizarSgXa(saActivo[i],accion);
                            newSa.add(saActivo[i]);
                        }
                    }
                }
            }
            
            saActivo=newSa;
            
            list<LTE_Servicios_adicionales__c> newSaDO=new list<LTE_Servicios_adicionales__c>();
            set<string> actualizanSA_DO=new set<string>();
            
            actualizanSA_DO.add('TELEFONIA MOVIL (LTE)');
            
            if(oc.LTE_TipoTransaccion__c=='Equipo más SIM' || oc.LTE_TipoTransaccion__c=='Equipo'){
                //actualizanSA_DO.add('EQUIPO PROPIEDAD CLIENTE');
                if(oc.IMEI_del_Equipo__c!=null){
                    modificarValorDO.put('IMEI',oc.IMEI_del_Equipo__c);
                }
                
                if(oc.LTE_ReferenciaEquipo__c != null){
                    modificarValorDO.put('MODELO',oc.LTE_ReferenciaEquipo__r.Name);
                    modificarValorDO.put('MARCA',oc.LTE_ReferenciaEquipo__r.LTE_Marca__c);
                } else{
                    system.debug('======================================================');
                    system.debug('======== oc.LTE_ReferenciaEquipo__c esta NULO ========');
                    system.debug('======================================================');
                }
            }
            
            if(sa!=null){
                for(integer i=0;i<sa.size();i++){
                    if(actualizanSA_DO.contains(sa[i].Name)){
                        sa[i].LTE_ServiceActionCode__c='UPDATE';
                    }
                    actualizarSgXaDO(sa[i],sa[i].LTE_ServiceActionCode__c);
                    newSaDO.add(sa[i]);
                }
            }
            
            if(!newSaDO.isEmpty()){
                sa = newSaDO;
            }            
        }        
    }
    
    public class ModificacionServicio extends LTE_Tramites_cls.Step 
    {
        private map<string,string> modificarCampo=new map<string,string>();
        
        public ModificacionServicio(){
            init();
        }
        
        public override void procesar()
        {
            //INICIALMENTE SOLO APLICA PARA TSIP LTE Y LOS ATRIBUTOS VAN EN NONE
            //POSTERIORMENTE SE IDENTFICA SI SE ACTUALIZA UN VALOR UNICO O UNO RECURRENTE
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='NONE';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='NONE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else{
                        saActivo[i].LTE_ServiceActionCode__c=accion;
                        if(saActivo[i]!=null){
                            saActivo[i].LTE_ServiceActionCode__c=accion;
                            actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                            newSa.add(saActivo[i]); 
                        }                           
                    }
                }
            }
            saActivo=newSa;
        }
    }
    
    public class ModificacionEstandar extends LTE_Tramites_cls.Step 
    {
        private map<string,string> modificarCampo=new map<string,string>();
        
        public ModificacionEstandar(){
            init();
        }
        
        public override void procesar()
        {           
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='NONE';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i].LTE_ServiceActionCode__c='NONE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else{
                        saActivo[i].LTE_ServiceActionCode__c=accion;
                        if(saActivo[i]!=null){
                            saActivo[i].LTE_ServiceActionCode__c=accion;
                            actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                            newSa.add(saActivo[i]); 
                        }                           
                    }
                }
            }
            saActivo=newSa;
        }
    }
}