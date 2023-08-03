public class MetodosFuturos_cls {
    
    public static integer totalCallout=50;
    
    /*
    @future (callout=true)
	public static void contactos(Set<Id> cont,list<string> data) {
        
        integer call=1;
        
        list<contact> contList =new list<contact>([select id,Direccion__c from contact where id=:cont]);
        
        list<ConsultaDirecciones_cls> llamados=new list<ConsultaDirecciones_cls>();
        ServiciosWeb__c sw = ServiciosWeb__c.getValues('NormalizacionDireccion');
        
        for(contact c:contList){
            llamados.add(new ConsultaDirecciones_cls((sobject)c,sw,'Direccion__c'));
            
            //Si el total de llamdos se cumple sale del proceso.
            if(call==totalCallout){
                break;                
            }
            call++;
        }
        
        update contList;
     
		
	}

	*/

	
    /**
        @Description: La idea de este metodo es tener solo un metdodo futuro para la cuenta
     **/	
	@future
	public static void MetodosFuturosCuenta(set<string> idTask) {

		list<dataFuturo> df= new list<dataFuturo>();

		//Construyo objeto
		for(string d:idTask){
			df.add((MetodosFuturos_cls.dataFuturo)JSON.deserializeStrict(d,MetodosFuturos_cls.dataFuturo.class));
		}

		//Proceso Objeto
		for(dataFuturo obj :df){
			if(obj.accion=='actualizarSucursales'){
				actualizarSucursales(obj.ids);
			}
		}
		
	}

	public static void actualizarSucursales(set<Id> suc){
		List<Account> sucursales=new List<Account>([Select id,Cuenta__r.OwnerId from Account Where RecordType.Name='Sucursales' And Cuenta__c IN :suc]);

		for(Account s:sucursales){
			s.OwnerId=s.Cuenta__r.OwnerId;
		}
		update sucursales;

	}

	@future
	public static void MetodosFuturosMiembroCampana(set<string> idTask) {

		system.debug(idTask);
		list<dataFuturo> df= new list<dataFuturo>();

		//Construyo objeto
		for(string d:idTask){
			df.add((MetodosFuturos_cls.dataFuturo)JSON.deserializeStrict(d,MetodosFuturos_cls.dataFuturo.class));
		}

		//Proceso Objeto
		for(dataFuturo obj :df){
			if(obj.accion=='relacionarCuenta'){
				actualizarMiembros(obj.ids);
			}
		}

	}

	public static void actualizarMiembros(set<Id> mcId){
		List<CampaignMember> m=new List<CampaignMember>([Select id,Contact.AccountId from CampaignMember Where Id IN :mcId]);

		for(CampaignMember mc:m){
            system.debug(mc.Contact.AccountId);
			mc.Cuenta_del_del__c=mc.Contact.AccountId;
		}
		update m;
	}

	public class dataFuturo{

		public string accion='';
		public set<Id> ids=new set<Id>();

		public dataFuturo(string accion, set<Id> ids){
			this.accion=accion;
			this.ids=ids;
		}

	}
    
    
}