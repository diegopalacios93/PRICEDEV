public with sharing class CampaignMember_cls {

	public static void CampaignMemberValidation(Map<Id,CampaignMember>oldMap,Map<Id,CampaignMember>newMap){

		set<Id> relacionar=new set<Id>();
		set<string> tareasFuturo=new set<string>();

		for(Id idC:newMap.keySet()){
			system.debug(newMap.get(idC));
			system.debug(oldMap);
			//Insert
			if(oldMap==null){
				system.debug(idC);
				relacionar.add(idC);
			}
			else if(newMap.get(idC).ContactId!=null){
				relacionar.add(idC);
				system.debug(idC);
			}
		}

		if(!relacionar.isEmpty()){
			MetodosFuturos_cls.dataFuturo df= New MetodosFuturos_cls.dataFuturo('relacionarCuenta',relacionar);
			tareasFuturo.add(JSON.serialize(df));
		}

		if(!tareasFuturo.isEmpty()){
			MetodosFuturos_cls.MetodosFuturosMiembroCampana(tareasFuturo);
		}
	}



}