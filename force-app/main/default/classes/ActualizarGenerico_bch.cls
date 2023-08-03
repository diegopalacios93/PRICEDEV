/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Hector Bayona
Proyecto:				ETB - Batch para la actualizacion de campos que no pueden ser accedidos por permisos
Descripción:			Batch Para procesar los CUN que estan pendientes de ser generados
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci�n
------  ----------  --------------------        ---------------
1.0		30-10-2014	Hector Bayona (HB)		Creación de la clase
*******************************************************************************/
global with sharing class ActualizarGenerico_bch  implements Database.Batchable<SObject>{
	
	global Database.Querylocator start(Database.Batchablecontext bc)
	{
		String query = LibreriaUtilitaria_cls.getQuery('Generico__c',' where NO_Estado__c=\'Pendiente\' ',false);

		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext bc, List<Generico__c> scope){
		
		list<sobject> sobjList=new list<sobject>();
		map<id,Generico__c> borrar=new map<Id,Generico__c>();
		list<Generico__c> actualizar=new list<Generico__c>();
		
		for(Generico__c g:scope){
			string typeObj=string.valueof(Id.valueOf(g.NO_Ids__c).getSObjectType());
			sobject x1=Id.valueOf(g.NO_Ids__c).getSObjectType().newSObject(g.NO_Ids__c);
			x1=LibreriaUtilitaria_cls.clonar(g,'Generico__c',x1,typeObj,false,new map<string,string>());
			x1.Id=g.NO_Ids__c;
			sobjList.add(x1);
			borrar.put(x1.id,g);
		}
		
		//update sobjList.values();
		Database.SaveResult[] dr=Database.update(sobjList,false);
		
		for(integer i=0;i<dr.size();i++){
			if(!dr[i].isSuccess()){
				borrar.get(sobjList[i].id).NO_Errores__c=String.valueOf(dr[i].getErrors());
				borrar.get(sobjList[i].id).NO_Estado__c='Error';
				borrar.remove(sobjList[i].id);
				actualizar.add(borrar.get(sobjList[i].id));			
			}
		}
		
		//Borrra registros actualizados correctamente;
		delete borrar.values();
		//Actualiza los registro que no se pudieron actualizar.
		update actualizar;
		
	
	}
	
	global void finish(Database.BatchableContext bc){
		
		ActualizarGenerico_sch.ProgramarJob();
		system.debug('!!!EXITO');
	}

}