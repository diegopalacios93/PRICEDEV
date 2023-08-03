public with sharing class ValidacionesNumeroRedInteligente {


//solo un numero tomado por operacion comercial
public void validacionNumero(map<Id,Numero__c> MpNew,map<Id,Numero__c> MpOld)
{
	//sacar los numeros por operacion comercial si los tiene
	set<string> idOC = new set<string>();
	for(Numero__c num : MpNew.values())
	{
		if(num.OperacionComercial__c != null && num.OperacionComercial__c != MpOld.get(num.Id).OperacionComercial__c)
			idOC.add(num.OperacionComercial__c);
	}
	map<string,Numero__c> mapNumeros = new map<string,Numero__c>();
	for(Numero__c num : [select id,Name,Estado__c,OperacionComercial__c from Numero__c where OperacionComercial__c in :idOC and Estado__c='Asignado'])
	{
		mapNumeros.put(num.OperacionComercial__c,num);
	}
	for(Numero__c numero : MpNew.values())
	{
		//si la linea esta en estado asignado y la operacion comercial ya tiene lineas asignadas y es diferente no permite
		string OCid = numero.OperacionComercial__c;
		//buscar en el mapa
		if(mapNumeros.containsKey(OCid))
		{
			numero.addError('No se puede asignar un nuevo numero a esta Operacion Comercial, ya tiene uno asignado');
		}
	}
	
}

    /* ----- Se aplican comentarios al metodo toda vez que el unico llamado que se hace en el trigger esta comentareado
//metodo que valida que cuando la operacion comercial pasa a activa libera los numeros bloqueados que no sean tomados
public void LiberarReservas(map<id,OperacionComercial__c> listOCnew,map<Id,OperacionComercial__c> listOCold)
{
	set<string> idOC = new set<string>();
	set<string> planesid = new set<string>();
	map<id,string> nombresProd = new map<id,string>();
	//sacar el producto de los planes
	for(string OC : listOCnew.keySet())
	{
		planesId.add(listOCnew.get(OC).plan__c);
	}
	
	for(Planes__c plan :[select id,NombredelProducto__r.Name from Planes__c where id in :planesid])
	{
		nombresProd.put(plan.id,plan.NombredelProducto__r.Name);
	}
	for(string OC : listOCnew.keySet())
	{
		//validar que el estado haya cambiado a activo
		if(listOCnew.get(OC).Estado__c=='Activo' && listOCold.get(OC).Estado__c=='Activo' && nombresProd.get(listOCnew.get(OC).Plan__c)!=Label.NombreProductoRedIn  )
		{
			//guardar el id de la OC 
			idOC.add(OC);
			
		}
	}
	
	//Extraer los numeros de las OC que esten bloqueados
	list<Numero__c> numeros = [select id,Bloqueado__c,Name from Numero__c where OperacionComercial__c in :idOC and Bloqueado__c=true and Estado__c!='Activo'];
	list<Numero__c> numerosAct = new list<Numero__c>();
	for(Numero__c num :numeros)
	{
		num.Bloqueado__c=false;
		num.Estado__c=null;
		num.OperacionComercial__c=null;
		numerosAct.add(num);
	}
	
	//sacar los numeros bloqueados y actualizar el activo y el plan
	list<Numero__c> numeros2 = [select id,Bloqueado__c,Name,OperacionComercial__c from Numero__c where OperacionComercial__c in :idOC and Bloqueado__c=true and Estado__c='Activo'];
	
	for(Numero__c nm :numeros2)
	{	
		nm.Plan__c=listOCnew.get(nm.OperacionComercial__c).Plan__c;
		nm.Activo__c=listOCnew.get(nm.OperacionComercial__c).Activo__c;
		numerosAct.add(nm);
	}
	Database.SaveResult[] dr=Database.update(numerosAct,false);
}
*/
}