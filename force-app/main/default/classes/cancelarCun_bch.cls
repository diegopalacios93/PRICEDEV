global class cancelarCun_bch implements Database.Batchable<SObject>,Database.AllowsCallouts{

    global Database.Querylocator start(Database.Batchablecontext bc)
    {
        string p='Pendiente';
        String query = 'SELECT id,name,intentos__c,idS__c,TipoIdentificacionCI__c,IdentificacionCI__c,CreatedDate,NumOrden__c,FechaPQR__c,NumCun__c,Tipologia__c,UsuCreador__r.name, UsuCreador__r.CedulaCiudadania__c FROM cancelarCun__c WHERE Estado_Envio__c = :p';
        system.debug('\nConsultaBatch: '+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<cancelarCun__c> scope){

        ServiciosWeb__c sww = ServiciosWeb__c.getValues('CodigoCun');
        list<cancelarC> lstCancelarCun=new list<cancelarC>();
        list<cancelarCun__c> lstInfoCancelarCun=new list<cancelarCun__c>();

        for(cancelarCun__c c:scope){
            lstCancelarCun.add(new cancelarC(c,sww));
        }

        for(cancelarC c :lstCancelarCun){
            c.AnularCun();
            lstInfoCancelarCun.add(c.c);
        }

        Database.SaveResult[] dr=Database.update(lstInfoCancelarCun,true);
        
    
    
    }
    
    global void finish(Database.BatchableContext bc){
    	cancelarCun_sch.ProgramarJob();
		system.debug('!!!EXITO');
    
    }
    
    public class cancelarC{
        
        public cancelarCun__c c;
        public map<string,string> mCancelar=new map<string,string>();
        public string response;
        public ServiciosWeb__c sw;

        public cancelarC(cancelarCun__c c,ServiciosWeb__c sw){
            this.c=c;
            this.sw=sw;
        }

        public string createXml(){

            map<String,ValoresIntegracionTiposDocumento__c> mapValoresTipoDoc = ValoresIntegracionTiposDocumento__c.getAll();
            
            mCancelar.put('TipoIdentificacionCI',mapValoresTipoDoc.get(c.TipoIdentificacionCI__c).Valor__c);
            mCancelar.put('IdentificacionCI',c.IdentificacionCI__c);

            mCancelar.put('NumCun',c.NumCun__c);
            mCancelar.put('FechaIncidente',c.CreatedDate.format('dd/MM/yyyy HH:mm:ss'));
            mCancelar.put('Tipologia',c.Tipologia__c);
            mCancelar.put('UsuCreador',c.UsuCreador__r.CedulaCiudadania__c);
            mCancelar.put('UsuCreador',c.UsuCreador__r.name);
            mCancelar.put('NumOrden',c.NumOrden__c);
            mCancelar.put('FechaPQR',c.FechaPQR__c.format('MM/dd/yyyy HH:mm:ss'));
            mCancelar.put('NumOrden',c.NumOrden__c);
            mCancelar.put('correlationID',c.idS__c);
            

            return tibcoXml_cls.AnularCun(mCancelar);

        }

        public void AnularCun(){

            try{
                
                c.response__c=LibreriaUtilitariaJobs_cls.consultarServicio(createXml(),'/Service/SisExt.serviceagent/Endpoint/AnularCUN',sw.EndPoint__c);
                tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
                map<string,string> datac =proReq.getMap(c.response__c);

                if(datac.get('Codigo')=='5013'){
                    c.Estado_Envio__c='Exitoso';
                }

            }catch(exception e){
                c.response__c=e.getMessage();
            }
            c.intentos__c++;

        }

    }

}