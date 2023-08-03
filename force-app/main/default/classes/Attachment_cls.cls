/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Evita la eliminacion de adjuntos segun las reglas de cada objeto
Descripción:			clase que Evita la eliminacion de adjuntos
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripción
------  ----------  --------------------        ---------------
1.0		15-04-2015	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/
public with sharing class Attachment_cls {
    
	public virtual class validate
	{
		public virtual void objValidate(set<Id> ids,map<Id,Attachment> newMap){}
	}
    
    Public static void procesar(map<Id,Attachment> oldMap,map<Id,Attachment> newMap){
        
        map<string,set<Id>> objId=new map<string,set<Id>>();
        map<Id,Attachment> mapParent=new map<Id,Attachment>();
        
        //Agrupamos el ID polimorfico por objeto
        for(Id ida:oldMap.keySet()){
            string objString=String.valueOf(oldMap.get(ida).ParentId.getSObjectType()).remove('_');
            system.debug(objString);

            mapParent.put(oldMap.get(ida).ParentId,oldMap.get(ida));


            if(objId.get(objString)==null){
                objId.put(objString,new set<Id>());                
            }
            objId.get(objString).add(oldMap.get(ida).ParentId);
            
        }
        system.debug(objId);
        
        for(string objName:objId.keySet()){
            //Instanciamos Dinamicamente
            string cl='Attachment_cls.'+objName+'Validar';
            Type t = Type.forName(cl);
            //Validamos la existencia de la clase
            if(t!=null){
                Attachment_cls.validate clase =(Attachment_cls.validate) t.newInstance();
                system.debug(objId.get(objName));
                clase.objValidate(objId.get(objName),mapParent);
            }
            
        }

        /*
        Type t = Type.forName(c);
        if(t!=null){
            Attachment_cls.validate paso =(Attachment_cls.validate) t.newInstance();
        }
*/
    }

/*
    public class OperacionComercialcValidar extends Attachment_cls.validate{

        public override void objValidate(set<Id> ids,map<Id,Attachment> mapParent){

            system.debug('OperacionComercialcValidar');
            List<OperacionComercial__c> objs=new List<OperacionComercial__c>([select id,estado__c from OperacionComercial__c where id In :ids]);


            for(OperacionComercial__c o:objs){
                
            }


        }
    }
*/

    public class OpportunityValidar extends Attachment_cls.validate{

        public override void objValidate(set<Id> ids,map<Id,Attachment> mapParent){
        	
        	set<String> stage=new set<String>{'Cerrada ganada','Cerrada perdida'};

            system.debug('OperacionComercialcValidar');
            List<Opportunity> objs=new List<Opportunity>([select id,StageName from Opportunity where id In :ids and  StageName IN :stage]);
            
			Perfiles_Acciones__c myCS1 = Perfiles_Acciones__c.getValues('Adjuntos');
			set<string> perfiles=new set<string>(myCS1.Usuarios__c.split(','));
            system.debug(objs);
            for(Opportunity o:objs){
            	
            	if(!perfiles.contains(UserInfo.getProfileId())){
            		mapParent.get(o.id).addError('No se pueden eliminar los adjuntos por favor Contacte a Soporte ventas');            	
            	}
            }


        }
    }
    public class LegalizacioncValidar extends Attachment_cls.validate{

        public override void objValidate(set<Id> ids,map<Id,Attachment> mapParent){

            set<String> stage=new set<String>{'Gestionado'};

            List<Legalizacion__c> objs=new List<Legalizacion__c>([select id,estado__c from Legalizacion__c where id In :ids and Estado__c IN :stage]);

			Perfiles_Acciones__c myCS1 = Perfiles_Acciones__c.getValues('Adjuntos');
			set<string> perfiles=new set<string>(myCS1.Usuarios__c.split(','));
            system.debug(objs+'<<<');
            for(Legalizacion__c o:objs){
            	if(!perfiles.contains(UserInfo.getProfileId())){
            		mapParent.get(o.id).addError('No se pueden eliminar los adjuntos por favor Contacte a Soporte ventas');            	
            	}
            
            }

        }
    }

/*

Attachment at=[SELECT Body,BodyLength,ContentType,CreatedById,CreatedDate,Description,Id,IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId,SystemModstamp FROM Attachment limit 1];

	public static void dontDelete(list<Attachment> Attach){

		Perfiles_Acciones__c myCS1 = Perfiles_Acciones__c.getValues('borrarAdjuntos');
		set<string> perfiles=new set<string>(myCS1.Usuarios__c.split(','));


		for (Attachment a: Attach){
            
            if(a.ParentId!=null){
            	
            	if(!perfiles.contains(UserInfo.getProfileId())){
            		a.addError('No se pueden eliminar los adjuntos por favor Contacte al administrador');
            		}
            	}
        }


	}
/*
	public static void dontChange(Map<Id,Attachment> attachOld,Map<Id,Attachment> attachNew){

		Perfiles_Acciones__c myCS1 = Perfiles_Acciones__c.getValues('borrarAdjuntos');
		set<string> perfiles=new set<string>(myCS1.Usuarios__c.split(','));

		for (string a: attachOld.keySet()){
            if(!perfiles.contains(UserInfo.getProfileId()) && attachOld.get(a).body!=attachNew.get(a).body){
                attachOld.get(a).addError('No se pueden modificar los adjuntos por favor Contacte al administrador');
            }
        }


	}
*/



}