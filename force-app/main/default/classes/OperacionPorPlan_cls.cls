/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Hector Bayona
Proyecto:               ETB
Descripcion:            Clase para el manejo de operaciones

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     29-12-2014  Hector Bayona (HB)			Clase padre para el proceso de operaciones por plan;   
*******************************************************************************/

public class OperacionPorPlan_cls{


	public virtual class Step{

		public Map<id,OperacionComercial__c>camposAdicionales;
		public Map<Id,OperacionComercial__c> ocNew;
		public Map<Id,OperacionComercial__c> ocOld;
		public Map<string,map<id,SObject>> objetosAdicionales;
		public String accion;

		/*
		public Step creatarInstancia(String className)
		{
	        Type t = Type.forName(className);
	        if(t==null){return null;}
	        return (Step) t.newInstance();
		}*/

		// Step children override with unique procesar
		public virtual void procesar(set<Id> paraProcesar)
		{}



	}
}