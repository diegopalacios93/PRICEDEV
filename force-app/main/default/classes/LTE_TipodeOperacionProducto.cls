public class LTE_TipodeOperacionProducto {
    
    public class Venta extends LTE_Tramites_cls.Step 
    {
        public override void procesar()
        {
            accion='ADD';
            for(integer i=0;i<sa.size();i++){
                sa[i].LTE_ServiceActionCode__c=accion;
                sa[i].LTE_ServicioETB__c=oc.Activo__c;
                if(sa[i]!=null){
                    list<LTE_SpecificationGroupXA__c> sgXA=sa[i].SpecificationGroupXA__r;
                    actualizarSgXa(sa[i],sa[i].LTE_ServiceActionCode__c);
                   
                }
                
            }
            
        }
    }
    
    
    public class Reconexion extends LTE_Tramites_cls.Step 
    {       
        
        
        public Reconexion(){
            init();
        }
        
        public override void procesar()
        {
            
            
            //EL SEGURO EN SALESFORCE SE VE COMO UN SVA, TIBCO LO CONVIERTE EN UN SERVICIO EN REVACHAIN
            //NINGUNA SUSPENSION DEBE TOCAR EL SEGURO
            set<string> noTocar=new set<string>();
            noTocar.add('SVA-Seguro de terminales');
            
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='RESUME';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i]=null;
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
        
    }
    
    public class Renovacion extends LTE_Tramites_cls.Step 
    {
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
    
    
    public class Suspension extends LTE_Tramites_cls.Step 
    {
        //private map<string,string> modificarValor=new map<string,string>();
        private map<string,string> modificarCampo=new map<string,string>();
        
        public Suspension(){
            init();
        }
        
        public override void procesar()
        {
            
            modificarValor.put('REGISTRO DE EQUIPO A CLIENTE','NO');
            modificarValor.put('CAMBIO SIMCARD','VERDADERO');           
            modificarValor.put('RESGISTRO EN LISTA NEGRA ROBO O PERDIDA',(oc.Registro_en_lista_negra_robo_o_perdida__c=='Si')?'YES':'NO');
            
            //EL SEGURO EN SALESFORCE SE VE COMO UN SVA, TIBCO LO CONVIERTE EN UN SERVICIO EN REVACHAIN
            //NINGUNA SUSPENCION DEBE TOCAR EL SEGURO
            set<string> noTocar=new set<string>();
            noTocar.add('SVA-Seguro de terminales');
            
            
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='SUSPEND';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    system.debug(noEnviar.contains(saActivo[i].Name));
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i]=null;
                    }
                    else if(noTocar.contains(saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c)){
                        saActivo[i].LTE_ServiceActionCode__c='NONE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }
                    else{
                        saActivo[i].LTE_ServiceActionCode__c=accion;
                        if(saActivo[i]!=null){
                            list<LTE_SpecificationGroupXA__c> sgXA=saActivo[i].SpecificationGroupXA__r;
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
    
    public class Retiro extends LTE_Tramites_cls.Step 
    {
        public Retiro(){
            
            init();
          
        }
        
        public override void procesar()
        {
            
            
            
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='DELETE';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i]=null;
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
    }
    
    public class Reposicion extends LTE_Tramites_cls.Step 
    {
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
                        newSa.add(saActivo[i]); //AG                
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
    
    public class CambiodePlan extends LTE_Tramites_cls.Step 
    {
        private set<string> actualizan=new set<string>();
        //private map<string,string> modificarValor=new map<string,string>();
        
        public CambiodePlan(){
            actualizan.add('TELEFONIA MOVIL (LTE)');
            
        }
        
        
        public override void procesar()
        {	//25-04-2016: MC: Se adicionan variables necesarias
            Map<String, LTE_Servicios_adicionales__c> mapSa = new Map<String,LTE_Servicios_adicionales__c>();
            String strNombrePlanTmp = null;
            LTE_Servicios_adicionales__c saTmp = null;
            
            modificarValor.put('METODO DE PAGO',oc.Plan__r.LTE_MetodoDePago__c);
            
            
            for(integer i=0;i<sa.size();i++){
                //25-04-2016: MC: Se llena el map con el Id y el nombre
                mapSa.put(sa[i].Name, sa[i]);
            }
            System.debug('*** mapSa: ' + mapSa);
            
            
           
            //Analisis Plan anterior
            string accionGlobal='NONE';
            
            for(integer i=0;i<saActivo.size();i++){
                string accionPuntual=accionGlobal;
                system.debug(saActivo[i].Name+' '+saActivo[i].LTE_ServicioETB__r.Plan__r.Name);
                //AG 2016-08-01 Se adiciona la condición para evaluar las bolsas de voz a la medida
                if(saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c=='Bolsa de Datos a la medida' || saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c=='Bolsa de Voz a la medida' || saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c=='Troncal SIP' || saActivo[i].Name==saActivo[i].LTE_ServicioETB__r.Plan__r.Name){
                    accionPuntual='DELETE';
                }
                
                if(actualizan.contains(saActivo[i].Name)){
                    accionPuntual='UPDATE'; 
                }
                
                
                //25-04-2016: MC: Se recorre saActivo 
                saTmp = saActivo[i];
                strNombrePlanTmp = saTmp.LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c;
                if( (
                   strNombrePlanTmp =='Bolsa de Datos a la medida' || 
                   strNombrePlanTmp =='Bolsa de Voz a la medida'
                   ) && (
                   		mapSa.containsKey(saTmp.Name)
                   ) ){
                    System.debug('*** Se agrega a no enviar: ' + saTmp.Name);
                    accionPuntual='NONE'; 
                    noEnviar.add(saTmp.Name);
                }
                
                
                saActivo[i].LTE_ServiceActionCode__c=accionPuntual;
                if(saActivo[i]!=null){
                    actualizarSgXa(saActivo[i],accionGlobal);
                }
            }
            
            
             //Plan Nuevo 
            accion='ADD';
            for(integer i=0;i<sa.size();i++){
                
                sa[i].LTE_ServiceActionCode__c=accion;
                sa[i].LTE_ServicioETB__c=oc.Activo__c;
                
                if(noEnviar.contains(sa[i].Name)){
                    System.debug('TRUE-> noEnviar.contains '+ sa[i].Name);
                        sa[i] = null;
                }
                
                if(sa[i]!=null){
                    list<LTE_SpecificationGroupXA__c> sgXA=sa[i].SpecificationGroupXA__r;
                    for(LTE_SpecificationGroupXA__c sg :sgXA){
                        sg.LTE_ActionCode__c=accion;
                        SpecGroupXAList.add(sg);
                    }
                    
                }
                
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
            
            actualizan.add('NUMERO TELEFONICO LTE');
            actualizan.add('TELEFONIA MOVIL (LTE)');
            
            
            list<Integer> remover=new list<Integer>();
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='NONE';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i]=null;
                    }else if(actualizan.contains(saActivo[i].Name)){
                        system.debug('UPDATE');
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
            actualizan.add('TELEFONIA MOVIL (LTE)');
            
            init();
        }
        
        
        public override void procesar()
        {
            set<string> eliminarMismoTipo=new set<string>();
            
            accion='ADD';
            if(sa!=null){
                for(integer i=0;i<sa.size();i++){
                    if(sa[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c.startsWith('SVA-')){
                        eliminarMismoTipo.add(sa[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c);
                    }
                    sa[i].LTE_ServiceActionCode__c=accion;
                    sa[i].LTE_ServicioETB__c=oc.Activo__c;
                    if(sa[i]!=null){
                        list<LTE_SpecificationGroupXA__c> sgXA=sa[i].SpecificationGroupXA__r;
                        for(LTE_SpecificationGroupXA__c sg :sgXA){
                            sg.LTE_ActionCode__c=accion;
                            SpecGroupXAList.add(sg);
                        }
                        
                    }
                    
                }
            }
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='NONE';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i]=null;
                    }else if(actualizan.contains(saActivo[i].Name)){
                        system.debug('UPDATE');
                        saActivo[i].LTE_ServiceActionCode__c='UPDATE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else if(eliminarMismoTipo.contains(saActivo[i].LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c)){
                        saActivo[i].LTE_ServiceActionCode__c='DELETE';
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
    
    public class retirosva extends LTE_Tramites_cls.Step 
    {
        private set<string> actualizan=new set<string>();
        //private map<string,string> modificarValor=new map<string,string>();
        
        public retirosva(){
            actualizan.add('TELEFONIA MOVIL (LTE)');
            init();
        }
        
        
        public override void procesar()
        {
            set<string> eliminarMismoTipo=new set<string>();
            
            
            list<LTE_Servicios_adicionales__c> newSa=new list<LTE_Servicios_adicionales__c>();
            
            accion='NONE';
            if(saActivo!=null){
                for(integer i=0;i<saActivo.size();i++){
                    system.debug(saActivo[i].Name+' accion:'+accion);
                    if(noEnviar.contains(saActivo[i].Name)){
                        saActivo[i]=null;
                    }else if(actualizan.contains(saActivo[i].Name)){
                        system.debug('UPDATE');
                        saActivo[i].LTE_ServiceActionCode__c='UPDATE';
                        actualizarSgXa(saActivo[i],saActivo[i].LTE_ServiceActionCode__c);
                        newSa.add(saActivo[i]);
                    }else if(saActivo[i].LTE_OC_Tramite__c==oc.id){
                        saActivo[i].LTE_ServiceActionCode__c='DELETE';
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
}