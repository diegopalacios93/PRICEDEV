/***********************************************************************************************************************
Desarrollado por:	Avanxo Colombia
Autor:				Luis Eduardo Mogoll?n
Proyecto:			ETB Evolutivos
Descripci?n:		Controlador Pagina Reserva Red inteligente

Cambios (Versiones)
-------------------------------------
No.		Fecha			Autor						Descripci?n
----	----------		--------------------		---------------
1.0		2014-10-23		Luis Eduardo Mogollon (LEM)	Creaci?n de la clase.
***********************************************************************************************************************/

public class ReservaNumero_ctr {
	
	public string numerobus {get;set;}
	public string idOC {get;set;}
	public string numerogen {get;set;}
	public boolean enableReserva {get;set;}
	public list<WrapperNumero> numerosReserva {get;set;}
	public boolean procesoReserva {get;set;}
	public ReservaNumero_ctr()
	{
		procesoReserva=false;
		enableReserva=true;
		idOC= ApexPages.currentPage().getParameters().get('idOC');
		//buscar si la OC tiene numeros reservados si los tiene no permite reservar ningun numero
		list<Numero__c> numeros = [select id from Numero__c where OperacionComercial__c =:idOC and bloqueado__c=true];
		if(numeros.size()>0)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'La operacion comercial ya tiene numeros reservados relacionados'));
			numerosReserva = new list<WrapperNumero>();
		}
		else
		{
			procesoReserva=true;
		}
		
	}
	public PageReference buscarNumero()
	{
		system.debug('numerobus:: '+numerobus);
		if(numerobus!=null && numerobus!='')
		{
			string sql= 'select id,name,bloqueado__c,operacionComercial__c from Numero__c where Bloqueado__c=false and name like \'%'+numerobus+'%\'';
			list<Numero__c> numeros = Database.query(sql);
			if(numeros.size()==0)
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'El numero no existe o ya esta Reservado'));
			}
			else
			{
				enableReserva=false;
				numerosReserva= new list<WrapperNumero>();
				
				for(Numero__c num : numeros)
		{
			numerosReserva.add(new WrapperNumero(num));
		}
			}
		}
		return null;
	}
public pageReference generarNumeros()
{
	//llama el valor de la configuracion 
	VariablesGlobales__c variables = VariablesGlobales__c.getValues('NumeroReservas');
	integer numero = integer.valueOf(variables.valor__c);
	integer numeroRes = 0;
	try
	{
		numeroRes = integer.valueOf(numerogen);
	}
	catch(system.Exception e)
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'El valor Ingresado no es un numero'));
	}
	//consulta los numeros de la base de datos
	if(numeroRes<=numero)
	{
		numerosReserva= new list<WrapperNumero>();
		string consulta = 'select id,name,Bloqueado__c,OperacionComercial__c,Activo__c from Numero__c where bloqueado__c=false  limit '+numeroRes;
		list<Numero__c> numeros = Database.query(consulta);
		enablereserva=false;
		for(Numero__c num : numeros)
		{
			numerosReserva.add(new WrapperNumero(num));
		}
		
	}
	else
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'El valor Ingresado es mayor al permitido de generaci?n de numeros,digite un numero inferior '));
	}
	return null;
}

public list<WrapperNumero> getNumerosReserva()
{
	return numerosReserva;

}
public pageReference Reservar()
{
	//se actualizan los numeros con los valores de la OC y se bloquean
	list<Numero__c> numerosAct = new list<Numero__c>();
	if(idOC!=null && idOC!='')
	{
		for(WrapperNumero num :numerosReserva)
		{
			if(num.tomado)
			{
			num.numero.OperacionComercial__c=idOC;
			num.numero.bloqueado__c=true;
			num.numero.Estado__c='Reservado';
			numerosAct.add(num.numero);
			}
		}
	}
	update numerosAct;
	PageReference page = new PageReference('/'+idOC);
	page.setRedirect(true);
	return page;
}

public class wrapperNumero
{
	public Boolean tomado {get;set;}
	public Numero__c numero {get;set;}
	public wrapperNumero(Numero__c num)
	{
		tomado=false;
		numero=num;
	}
}
}