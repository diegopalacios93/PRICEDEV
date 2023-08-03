/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Tramites PBX
Descripción:            Clase encargada de soportar los Tramites PBX.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0     10-10-2014  Hector Bayona (HB)       Creación de la clase.
*******************************************************************************/
public with sharing class Tramites_ctr {
        
        public ActivoETB__c servicio{get;set;}
        public Integer servS{get;set;}
        public map<id,ActivoETB__c> cambios {get;set;}
        public list<wrapper> w{get;set;}
        public list<ActivoETB__c> tron{get;set;}
        public transient sobject actualizar;
        public string visible{get;private set;}
        public set<id>planes=new set<id>();
        public string ocr{get;set;}
        public string esArranque{get;set;}
        public boolean sonTodos{get;set;}
        Transient set <string>NumeroS;
        Transient set <string>NumeroSBandaAncha=new set <string>();
        
        
    public Tramites_ctr(ApexPages.StandardController stdController) {
                
                ocr = ApexPages.currentPage().getParameters().get('oc');
                servicio=new ActivoETB__c();
                servS=0;
                servicio = (ActivoETB__c)stdController.getRecord();
                servicio = [select Plan__r.Name,id,Tipodeprogramacion__c,SucursalDestino__c,CuentaFacturacion__c,NombredelaCuenta__c,NombredelaCuenta__r.EstadoRestriccionVenta__c,estado__c,NombredelProducto__r.name,Familia__c,LIneadeNegocio__c from ActivoETB__c where id=:servicio.id];

                //serv.Plan__r.Name.containsIgnoreCase('Ilimitado');
                
                //Arranque
        
    }

    public pageReference cambiarArranque(){

        transient map<id,string> servicioOperacion=new map<id,string>();
        
        for(wrapper wca:w){
            servicioOperacion.put(wca.serv.id,'Cambio de Arranque');
        }

        transient list<OperacionComercial__c> ocLst=operaciones(servicioOperacion);

        for(OperacionComercial__c oc:ocLst){
            if(oc.Activo__c!=esArranque){
                oc.Activo_Relacionado__c=esArranque;
                oc.Tipodeprogramacion__c='Troncal';
            }else{
                oc.Tipodeprogramacion__c='Arranque';
                oc.Activo_Relacionado__c=null;
            }
            planes.add(oc.Plan__c);
        }
        
        try{
            insert ocLst;
            PageReference p =new PageReference('/'+esArranque);
            p.setRedirect(true);
            return p;
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:'+e.getMessage()));
            return null;
        }

        PageReference p =new PageReference('/'+servicio.id);
        p.setRedirect(true);
        
        return p;
    }
    
    public pageReference crearArranque(){
        
        if(servicio.NombredelaCuenta__r.EstadoRestriccionVenta__c){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'El cliente tiene presenta Restricción Venta'));                    
        }else if(servicio.Tipodeprogramacion__c=='Arranque' && servicio.estado__c=='Activo'){
                return new PageReference('/apex/tramitesPBX_pag?id='+servicio.id);      
        }else if(servicio.estado__c=='Activo' && servicio.NombredelProducto__r.name=='Linea Telefónica' && servicio.Familia__c=='VOZ' && servicio.LIneadeNegocio__c=='LOCAL' && servicio.Tipodeprogramacion__c!='Troncal' && servicio.CuentaFacturacion__c!=null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Desea Convertir este servicio en un arranque'));
                visible='creaArranque';
        }
        else if(servicio.estado__c=='Inactivo' && servicio.Tipodeprogramacion__c=='Arranque'){
        	return new PageReference('/apex/TramitesPbxReconexion?id='+servicio.id);     
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error: El servicio no cuenta con los parametros necesarios para ser un Arranque'));
        }
        
        return null;    
    }
    public pageReference getArranque(){

        system.debug(servicio.id);
        String query = LibreriaUtilitaria_cls.getQuery('ActivoETB__c','where id = \''+servicio.id+'\'',false);
        list<sObject> sobjList = Database.query(query);           
        OperacionComercial__c oc=clonar(sobjList[0]);
        Map<String,Schema.RecordTypeInfo> formatos = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName();

                
                map<string,TOPP__c> toopMap=obtenerTopp(new set<string>{'Programación PBX'},new set<id>{oc.Plan__c});
                
                if(toopMap.get('Programación PBX'+oc.Plan__c)==null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No se encontro un Tipo de Operación por plan valido'));                    
                        return null;
                }
                
                oc.TOPP__c=toopMap.get('Programación PBX'+oc.Plan__c).id;
                oc.RecordTypeId=formatos.get(toopMap.get('Programación PBX'+oc.Plan__c).Tipoderegistro__c).getRecordTypeId();
                
                
                oc.Estado__c='Pendiente';
                oc.Tipodeprogramacion__c='Arranque';
                servicio.Tipodeprogramacion__c='Arranque';
                
        Savepoint sp = Database.setSavepoint();
        try{
        system.debug(oc);
        		update servicio;
                insert oc;
        }catch(exception e){
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:'+ e.getMessage()));
        }
        PageReference p =new PageReference('/apex/tramitesPBX_pag?id='+servicio.id+'&oc='+oc.id);
        p.setRedirect(true);
        
        return p;
    }
    
    public void pbxSuspender(){
        
         w =new list<wrapper>();
        
        for(ActivoETB__c s:getServicios('Activo')){
                w.add(new wrapper(false,s));
                planes.add(s.Plan__c);
        }
    }
    
    public void pbxReconexion(){
        
         w =new list<wrapper>();
        
        for(ActivoETB__c s:getServicios('Inactivo')){
                w.add(new wrapper(false,s));
                planes.add(s.Plan__c);
        }
    }
    
    public void pbxRetiro(){
        
         w =new list<wrapper>();
        
        for(ActivoETB__c s:getServicios('Activo')){
                w.add(new wrapper(false,s));
                planes.add(s.Plan__c);
        }
    }
    
    public void pbxCuentaFacturacion(){
        
         w =new list<wrapper>();
        
        for(ActivoETB__c s:getServicios('Activo')){
                w.add(new wrapper(false,s));
                planes.add(s.Plan__c);
        }
    }
    
    public pageReference setCuentaFacturacion(){
        
        transient map<id,string> servicioOperacion=new map<id,string>();

        for(wrapper sw:w){
        	servicioOperacion.put(sw.serv.id,'Cambio Datos Cliente o Cuenta');
        }

        try{
            transient list<OperacionComercial__c> ocLst=operaciones(servicioOperacion);
            for(OperacionComercial__c ocuenta:ocLst){
            	ocuenta.CuentaFacturacion__c=servicio.CuentaFacturacion__c;           
            }            
            
            insert ocLst;
            PageReference p =new PageReference('/'+servicio.id);
            p.setRedirect(true);
            return p;
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:'+ e.getMessage()));
            return null;

        }
        
        

        PageReference p =new PageReference('/'+servicio.id);
        p.setRedirect(true);

        return p;
    }
    
	public pageReference setReconexion(){
        
        transient map<id,string> servicioOperacion=new map<id,string>();

        for(wrapper sw:w){
        	servicioOperacion.put(sw.serv.id,'Reconexión');
        }

        try{
            transient list<OperacionComercial__c> ocLst=operaciones(servicioOperacion);
            for(OperacionComercial__c ocuenta:ocLst){
            	ocuenta.CuentaFacturacion__c=servicio.CuentaFacturacion__c;           
            }            
            
            insert ocLst;
            PageReference p =new PageReference('/'+servicio.id );
            p.setRedirect(true);
            return p;
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:'+ e.getMessage()));
            return null;

        }


        PageReference p =new PageReference('/'+servicio.id);
        p.setRedirect(true);

        return p;
    }


    public pageReference setSuspender(){
        
        transient map<id,string> servicioOperacion=new map<id,string>();
        planes=new set<id>();

        for(wrapper sw:w){
            if(sw.opcion==true || sonTodos){
                system.debug(sw.serv.name);
                servicioOperacion.put(sw.serv.id,'Suspensión');
                planes.add(sw.serv.Plan__c);
                if(sw.serv.Tipodeprogramacion__c=='Arranque'){
                    esArranque=sw.serv.id;
                }
            }
        }

        try{
            transient list<OperacionComercial__c> ocLst=operaciones(servicioOperacion);
            insert ocLst;
            PageReference p =new PageReference('/'+esArranque);
            p.setRedirect(true);
            return p;
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:'+ e.getMessage()));

        }

        return null;
    }




    public pageReference setRetiro(){
        
        transient map<id,string> servicioOperacion=new map<id,string>();
        planes=new set<id>();

        for(wrapper sw:w){
            if(sw.opcion==true || sonTodos){
                system.debug(sw.serv.name);
                servicioOperacion.put(sw.serv.id,'Retiro');
                planes.add(sw.serv.Plan__c);
                if(sw.serv.Tipodeprogramacion__c=='Arranque'){
                    esArranque=sw.serv.id;
                }
            }
        }

        try{
            transient list<OperacionComercial__c> ocLst=operaciones(servicioOperacion);
            insert ocLst;
            PageReference p =new PageReference('/'+esArranque);
            p.setRedirect(true);
            return p;
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:'+ e.getMessage()));

        }

        return null;
    }

    //Crea OC segun el topp
    public list<OperacionComercial__c> operaciones(map<id,string> servicioOperacion){

        transient Set<String> setS = new Set<String>();
        setS.addAll(servicioOperacion.values());
        transient map<string,TOPP__c> toopMap=obtenerTopp(setS,planes);

        transient set<id>act=servicioOperacion.keySet();

        transient String query = LibreriaUtilitaria_cls.getQuery('ActivoETB__c','where id IN :act',true);
        transient list<sObject> sobjList = Database.query(query);
        transient list<OperacionComercial__c> ocLst=new list<OperacionComercial__c>();
        
        transient Map<String,Schema.RecordTypeInfo> formatos = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName();
        
 
        for(sObject so:sobjList){
                transient OperacionComercial__c oc=clonar(so);
                system.debug('plan:'+oc.Plan__c+' operacion:'+servicioOperacion.get(oc.Activo__c));
                system.debug(toopMap.get(servicioOperacion.get(oc.Activo__c)+oc.Plan__c));
                oc.TOPP__c=toopMap.get(servicioOperacion.get(oc.Activo__c)+oc.Plan__c).id;
                oc.RecordTypeId=formatos.get(toopMap.get(servicioOperacion.get(oc.Activo__c)+oc.Plan__c).Tipoderegistro__c).getRecordTypeId();
                oc.Estado__c='Pendiente';
                oc.Tipodeprogramacion__c='Basica';
                oc.Activo_Relacionado__c=Null;
                ocLst.add(oc);
        }
        return ocLst;



    }

   
    public list<ActivoETB__c> getServicios(string estado){
        
        list<ActivoETB__c>t=new list<ActivoETB__c>([select Tipodeprogramacion__c,estado__c,Plan__c,name,id,Activo_Relacionado__c,Activo_Relacionado__r.Name,Plan__r.Name from ActivoETB__c where
        estado__c=:estado and NombredelProducto__r.name='Linea Telefónica' and Familia__c='VOZ' and LIneadeNegocio__c='LOCAL' and
        SucursalDestino__c=:servicio.SucursalDestino__c and
        CuentaFacturacion__c=:servicio.CuentaFacturacion__c and
        NombredelaCuenta__c=:servicio.NombredelaCuenta__c and
        CuentaFacturacion__c!=null and
        (Activo_Relacionado__c=:servicio.id or
        id=:servicio.id) ORDER BY Activo_Relacionado__c ASC NULLS FIRST]);
        
        return t;
    }
    
    
    
    
    

    
    public string getLabelEstado(){
        string labelS=(servicio.estado__c=='Activo'?'Inactivados':'Activados');
        
        return labelS;
    }
    
   
    public void inicio(){
        getTroncales();    
    }
    
    public string getVista(){
        string v='';
        
        if(servicio.Tipodeprogramacion__c=='Arranque'){
                v='PBX';        
        }
        
                return v;
    
    }
    
    public void inicioPBX(){
        
        getAsignarWraper();   
    
    }
    
    public void getTroncales(){
        
        /*
        list<ActivoETB__c> t=new list<ActivoETB__c>([select name,id from ActivoETB__c where
        estado__c='Activo' and NombredelProducto__r='Linea Telefonica' and Familia__c='Familia__c']);
        */
        tron=new list<ActivoETB__c>([select name,id,Activo_Relacionado__c,Activo_Relacionado__r.Name,Plan__c from ActivoETB__c where
        Activo_Relacionado__c=:servicio.id]);
        
        servS=tron.size();
        
    }
    
    public list<ActivoETB__c> getAsignarTrocales(){
        
        system.debug(servicio.CuentaFacturacion__c+' '+servicio.NombredelaCuenta__c+' '+servicio.NombredelaCuenta__c);
        
        list<ActivoETB__c>t=new list<ActivoETB__c>([select Tipodeprogramacion__c ,estado__c,Plan__c,Plan__r.Name,name,id,Activo_Relacionado__c,Activo_Relacionado__r.Name from ActivoETB__c where
        estado__c='Activo' and NombredelProducto__r.name='Linea Telefónica' and Familia__c='VOZ' and LIneadeNegocio__c='LOCAL' and
        SucursalDestino__c=:servicio.SucursalDestino__c and
        CuentaFacturacion__c=:servicio.CuentaFacturacion__c and
        NombredelaCuenta__c=:servicio.NombredelaCuenta__c and
        CuentaFacturacion__c!=null and
        Tipodeprogramacion__c!='Arranque' and
        (Activo_Relacionado__c=:servicio.id Or Activo_Relacionado__c=null) and
        id!=:servicio.id ORDER BY Activo_Relacionado__c ASC NULLS LAST]);
    
    
        return t; 
    }
    
    public PageReference asignarQuitarTroncales(){
        
        map<id,string>tramitesMap=new map<id,string>();
        cambios=new map<id,ActivoETB__c>();
        
        for(wrapper wv:w){
                //quita troncal
                if(wv.opcion==false && wv.serv.Activo_Relacionado__c==servicio.id){
                        tramitesMap.put(wv.serv.id,'quitaTroncal');
                        cambios.put(wv.serv.id,wv.serv);
                }
                //agrega troncal
                if(wv.opcion==true && wv.serv.Activo_Relacionado__c==null){
                        system.debug('agrega troncal'+wv.serv.name);
                        tramitesMap.put(wv.serv.id,'agregaTroncal');
                        cambios.put(wv.serv.id,wv.serv);
                }
                /*NO aplica el cambio es masivo
                //cambio troncal
                if(wv.opcion==true && wv.serv.Activo_Relacionado__c!=null && wv.serv.Activo_Relacionado__c!=servicio.id){
                        tramitesMap.put(wv.serv.id,'cambioTroncal');
                        cambios.put(wv.serv.id,wv.serv);
                }
                */
        }
        if(GenerarOc(tramitesMap)){
            PageReference p =new PageReference('/'+servicio.id);
            p.setRedirect(true);
            return p;
        }

        return null;
    
    }
    
    public boolean GenerarOc(map<id,string> tramitesMap){
        
        transient set<id>ids=tramitesMap.keySet();
        transient String query = LibreriaUtilitaria_cls.getQuery('ActivoETB__c','where id IN :ids',false);
        transient list<sObject> sobjList = Database.query(query);
        transient boolean bien=false;

        
        transient list<OperacionComercial__c> ocLst=new list<OperacionComercial__c>();
        
   		map<string,TOPP__c> toopMap=obtenerTopp(new set<string>{'Programación PBX','Desprogramación PBX'},planes);
        Map<String,Schema.RecordTypeInfo> formatos = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName();
        list<OperacionComercial__c> paraActivar=new list<OperacionComercial__c>();
 
        for(sObject so:sobjList){
                transient OperacionComercial__c oc=clonar(so);
                
                if(tramitesMap.get(oc.Activo__c)=='quitaTroncal'){
    		            oc.TOPP__c=toopMap.get('Desprogramación PBX'+oc.Plan__c).id;
	        	        oc.RecordTypeId=formatos.get(toopMap.get('Desprogramación PBX'+oc.Plan__c).Tipoderegistro__c).getRecordTypeId();
                        oc.Estado__c='Pendiente';
                        oc.Tipodeprogramacion__c='Basica';
                        oc.Activo_Relacionado__c=Null;
                        paraActivar.add(oc);
                        //cambios.get(oc.Activo__c).Activo_Relacionado__c=null;
                }else if(tramitesMap.get(oc.Activo__c)=='agregaTroncal'){
                        oc.TOPP__c=toopMap.get('Programación PBX'+oc.Plan__c).id;
                        oc.RecordTypeId=formatos.get(toopMap.get('Programación PBX'+oc.Plan__c).Tipoderegistro__c).getRecordTypeId();
                        oc.Estado__c='Pendiente';
                        oc.Tipodeprogramacion__c='Troncal';
                        oc.Activo_Relacionado__c=servicio.id;
                        //cambios.get(oc.Activo__c).Activo_Relacionado__c=servicio.id;
                        oc.Operacion_Comercial_Relacionada__c=ocr;
                }
                /*
                else if(tramitesMap.get(oc.Activo__c)=='cambioTroncal'){
                        oc.TOPP__c=mcs.get('PBXArranqueCambio').Valor__c;
                        oc.RecordTypeId=mcs.get('PBXArranqueCambio').Valor02__c;
                        oc.Estado__c='Pendiente';
                        cambios.get(oc.Activo__c).Activo_Relacionado__c=servicio.id;
                }*/
                system.debug('\n\n\n'+servicio.id);
                ocLst.add(oc);
        }
        
        Savepoint sp = Database.setSavepoint();
        try{
        system.debug(ocLst);    
                insert ocLst;
                bien=true;
                
                for(OperacionComercial__c oca: paraActivar){
                	oca.Estado__c='Activa';
                }
                update paraActivar;
                
                
        }catch(exception e){
                Database.rollback(sp);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:'+ e.getMessage()));
        }


        return bien;      
        
    
    
    }
    
 
    public OperacionComercial__c clonar(sObject g){
        
        map<string,string> homologar=new map<string,string>();
        homologar.put('CuentaCliente__c','NombredelaCuenta__c');
        homologar.put('Activo__c','Id');
    
                sobject oc=new OperacionComercial__c();
                oc=LibreriaUtilitaria_cls.clonar(g,'ActivoETB__c',oc,'OperacionComercial__c',false,homologar);
                system.debug(oc);
                return (OperacionComercial__c)oc;    
    }
    
    
    
    
    public void getAsignarWraper(){
    
        w =new list<wrapper>();
        
        for(ActivoETB__c s:getAsignarTrocales()){
                Boolean opcion=(s.Activo_Relacionado__c==servicio.id?true:false);
                w.add(new wrapper(opcion,s));
                planes.add(s.Plan__c);
        }
        
    }
    
    public class wrapper{
        
        public boolean opcion{get;set;}
        public ActivoETB__c serv{get;set;}
        public boolean ilimitado{get;set;}

        public wrapper(boolean opcion,ActivoETB__c serv){
                
            this.opcion=opcion;
            this.serv=serv;
            this.ilimitado=this.serv.Plan__r.Name.containsIgnoreCase('Ilimitado');
        
        }

        public string getIlimitadoS(){

            return (ilimitado?'Ilimitado':'');
        }
        
    }
    
    public map<string,TOPP__c> obtenerTopp(set<string> TipodeOperacionporplan, set<id> plan){
        
        transient map<string,TOPP__c> toopMap=new map<string,TOPP__c>();

        system.debug(TipodeOperacionporplan+' '+plan);
        
        list<TOPP__c>topp=new list<TOPP__c>([select id,Name, Plan__c, TipodeOperacionporplan__c,Tipoderegistro__c                             
                    from TOPP__c
                    where
                    TipodeOperacionporplan__c LIKE :TipodeOperacionporplan
                    and Plan__c IN :plan
                    and Plan__r.Estado__c='Activo'
                    and Plan__r.NombredelProducto__r.Name ='Linea Telefónica'
                    and Plan__r.NombredelProducto__r.Familia__c='VOZ'
                    and Plan__r.NombredelProducto__r.LineaNegocio__c='LOCAL'
                    order by Name]);
         for(TOPP__c t:topp){
                toopMap.put(t.TipodeOperacionporplan__c+t.Plan__c,t);                    
         }
         
         return toopMap;
    }

    public pageReference linkSuspender(){
        PageReference p =new PageReference('/apex/TramitesPBXSuspender?id='+servicio.id);
        p.setRedirect(true);

        return p;
    }

    public pageReference linkRetiro(){
        PageReference p =new PageReference('/apex/TramitesPBXRetiro?id='+servicio.id);//TramitesPBXCambioArranque
        p.setRedirect(true);

        return p;
    }
    //TramitesPBXCuentaFacturacion
    
    public pageReference linkCambioArranque(){
        PageReference p =new PageReference('/apex/TramitesPBXCambioArranque?id='+servicio.id);//
        p.setRedirect(true);

        return p; 
    }

    public pageReference linkCuentaFacturacion(){
        PageReference p =new PageReference('/apex/TramitesPBXCuentaFacturacion?id='+servicio.id);//
        p.setRedirect(true);

        return p; 
    }
    
    public set<string> tienenBandaAncha(set <string> numConexion){
    	transient set<string> bandaAncha =new set<string>();
    	
    	transient list<ActivoETB__c> tienen=new list<ActivoETB__c>([select NumeroConexion__c from ActivoETB__c where
    	NumeroConexion__c IN :numConexion and Estado__c='Activo' and NombredelProducto__r.name ='Banda Ancha']);
    	
    	for(ActivoETB__c t:tienen){
    		bandaAncha.add(t.NumeroConexion__c);
    	}
    	
    	
    	return bandaAncha;
    
    }
    
    
    

}