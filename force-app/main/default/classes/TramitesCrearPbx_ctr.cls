/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB - Tramites PBX
Descripci�n:            Clase encargada de soportar los Tramites PBX.

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     18-10-2014  Hector Bayona (HB)       Creacion de la clase.
*******************************************************************************/
public with sharing class TramitesCrearPbx_ctr {

    public Opportunity opt{get;private set;}
    public ActivoETB__c serv{get;set;}
    public integer numeroServicios{get;set;}
    public OperacionComercial__c oc{get;set;}
    
    public boolean opcionN{get;set;} 
    
    public infoLupas iLupas{get;set;}
    public list<OperacionComercial__c>ocs{get;set;}
	public boolean cr{
		get{
			return noHayServicios();
			}
		}

    public TramitesCrearPbx_ctr(ApexPages.StandardController stdController){
    	ocs=new list<OperacionComercial__c>();
    	iLupas=new infoLupas();
    	opcionN=true;
        
                opt=new Opportunity();
                opt = (Opportunity)stdController.getRecord();
                opt = [select id,Account.name,AccountId,Name from Opportunity where id=:opt.id];

                ActivoETB__c serv= new ActivoETB__c();
                serv.Oportunidad__c =opt.id;
                serv.NombredelaCuenta__c =opt.AccountId;

                oc=new OperacionComercial__c();
                oc.CuentaCliente__c=opt.AccountId;
                oc.Oportunidad__c=opt.id;
                
    }
    public pagereference getSeleccion(){
    	system.debug(opcionN);
    	iLupas.sucursalOrg='';
    	iLupas.sucursalOrgId='';
    	
    
    return null;
    }
    
    
    public string getContactoInfo(){
		
		return 	'/apex/Filtro?id=003&c='+Filtro_cls.codificar(' Where AccountId =\''+opt.AccountId+'\' And Estado__c=\'Activo\'')+'&f='+filtro_cls.codificar(',Name');
	}
	
    public string getSucursalInfo(){
		
		return 	'/apex/Filtro?id=001&c='+Filtro_cls.codificar(' Where Cuenta__c =\''+opt.AccountId+'\' And RecordType.Name=\'Sucursales\'')+'&f='+filtro_cls.codificar(',Name');
	}
	
    public string getArranqueInfo(){
		
		return 	'/apex/Filtro?id=a07&c='+Filtro_cls.codificar(' Where NombredelaCuenta__c =\''+opt.AccountId+'\' And Tipodeprogramacion__c=\'Arranque\' And Estado__c=\'Activo\'')+'&f='+filtro_cls.codificar(',Name,NumeroConexion__c');
	}
    
    public void crearActivos(){
    	
    	ocs.clear();
    	
    	for(Integer i=0;i <numeroServicios;i++){
    		OperacionComercial__c o=new OperacionComercial__c();
    		ocs.add(o);
    	}
    	
    	system.debug(iLupas);
    	    
    }
    
    public Pagereference guardar(){
    	
    	list<relacion> rOcAc=new list<relacion>();
    	set<id> planes=new set<id>();
    	list<ActivoETB__c> acList=new list<ActivoETB__c>();
    	list<OperacionComercial__c>ocList=new list<OperacionComercial__c>();
        ActivoETB__c esArranqueAC;
        
        id cuentaFac=null;

		//Venta solo troncales
		ActivoETB__c act=new ActivoETB__c();    	
    	system.debug(opcionN+' '+iLupas.sucursalOrg);
    	if(!opcionN){
    		act=obtenerServicio();
    		cuentaFac=act.CuentaFacturacion__c;
    		iLupas.sucursalOrgId=act.SucursalOrigen__c;
    		esArranqueAC=act;
    	}


    	//'Venta','Programación PBX'
    	
    	
    	for(OperacionComercial__c ocNew:ocs){
    		ocNew.Contacto_Administrativo__c=iLupas.contactoAdmId;
    		ocNew.Contacto_Tecnico__c=iLupas.contactoTecId;
    		ocNew.SucursalOrigen__c=iLupas.sucursalOrgId;
            ocNew.Estado__c= 'Pendiente';
    		planes.add(ocNew.Plan__c);
    		ocNew.CuentaFacturacion__c=cuentaFac;
    		relacion rel=new relacion();
    		
            rel.oc=ocNew;
    		rel.oc.CuentaCliente__c=opt.AccountId;
    		rel.oc.Oportunidad__c=opt.id;
    		rel.oc.CuentaFacturacion__c=cuentaFac;
    		
    		rel.ac=clonar(ocNew);
            rel.ac.Estado__c= 'Pendiente';
    		rel.ac.NombredelaCuenta__c=opt.AccountId;
            rel.ac.Oportunidad__c=opt.id;
            rel.ac.CuentaFacturacion__c=cuentaFac;
            
            if(rel.ac.Tipodeprogramacion__c=='Arranque'){
            	esArranqueAC=rel.ac;
            }
            
            
    		
    		acList.add(rel.ac);
    		rOcAc.add(rel);
    	}
    	map<string,TOPP__c> topp = obtenerTopp(new set<string>{'Venta','Programación PBX'},planes);
    	Map<String,Schema.RecordTypeInfo> formatos = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName();
        
        for(ActivoETB__c ac:acList){
        	system.debug('Venta'+ac.Plan__c);
           	ac.NombredelProducto__c=topp.get('Venta'+ac.Plan__c).Plan__r.NombredelProducto__c;
        }
        
    	Savepoint sp = Database.setSavepoint();
    	try{
	    	insert acList;
	    	for(relacion relIns:rOcAc){
	    		relIns.oc.TOPP__c=topp.get('Venta'+relIns.oc.Plan__c).id;
	    		relIns.oc.RecordTypeId=formatos.get(topp.get('Venta'+relIns.oc.Plan__c).Tipoderegistro__c).getRecordTypeId();
	    		relIns.oc.Activo__c=relIns.ac.id;
                
                OperacionComercial__c prog2=relIns.oc.clone(false,false,false,false);
	    		
	    		OperacionComercial__c prog=relIns.oc.clone(false,false,false,false);
	    		prog.TOPP__c=topp.get('Programación PBX'+relIns.oc.Plan__c).id;
	    		prog.RecordTypeId=formatos.get(topp.get('Programación PBX'+relIns.oc.Plan__c).Tipoderegistro__c).getRecordTypeId();
                if(prog.Activo__c!=esArranqueAC.id){
                	prog.Activo_Relacionado__c=esArranqueAC.id;
                }
                relIns.ocProg=prog;
	    		
	    		ocList.add(prog2);
	    		ocList.add(prog);
                system.debug('Salio');	    	
	    	}
	    	insert ocList;
    	
    	}catch (exception e){
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error:'+e.getMessage()));
            return null;
    	}
        
        PageReference p = new PageReference('/'+opt.id);
        p.setRedirect(true);
        return p;
    	
    
    }
    public ActivoETB__c obtenerServicio(){
    	
    	ActivoETB__c act=[select id, CuentaFacturacion__c,SucursalOrigen__c from ActivoETB__c where id=:iLupas.arranqueId];
    	
    	return act;
    
    }
    
    
    public boolean NoHayServicios(){
    
    return !ocs.isEmpty();
    }
    
    
    public class infoLupas{
    	
    	public string contactoAdm{get;set;}
    	public string contactoAdmId{get;set;}   
    	public string contactoTec{get;set;}
    	public string contactoTecId{get;set;}
    	public string sucursalDes{get;set;}
    	public string sucursalDesId{get;set;}  
    	public string sucursalOrg{get;set;}
    	public string sucursalOrgId{get;set;}  
    	public string arranque{get;set;}
    	public string arranqueId{get;set;}  

    }
    
    public class relacion{
    	public OperacionComercial__c oc{get;set;}
        public OperacionComercial__c ocProg{get;set;}
    	public ActivoETB__c ac {get;set;}    
    }
    
 	public map<string,TOPP__c> obtenerTopp(set<string> TipodeOperacionporplan, set<id> plan){
        
        transient map<string,TOPP__c> toopMap=new map<string,TOPP__c>();
        
        list<TOPP__c>topp=new list<TOPP__c>([select id,Name, Plan__c,Plan__r.NombredelProducto__c, TipodeOperacionporplan__c,Tipoderegistro__c                             
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
    
    public ActivoETB__c clonar(sObject g){
        
        map<string,string> homologar=new map<string,string>();
    
                sobject ac=new ActivoETB__c();
                ac=LibreriaUtilitaria_cls.clonar(g,'OperacionComercial__c',ac,'ActivoETB__c',false,homologar);
                return (ActivoETB__c)ac;    
    }
    
    
    
    

}