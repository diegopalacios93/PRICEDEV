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
public with sharing class LTE_Tramites_cls {
	
	public virtual class Step{
		
		public list<LTE_Servicios_adicionales__c> sa;
		public list<LTE_Servicios_adicionales__c> saActivo;
		public LTE_DetalleOferta__c detOferta;
		public OperacionComercial__c oc;
		public ActivoETB__c ac;
		public Map<string,map<id,SObject>> objetosAdicionales;
		public String accion;
		public set<string> noEnviar=new set<string>();
		public set<string> eliminar=new set<string>();
		public list<LTE_SpecificationGroupXA__c> SpecGroupXAList=new list<LTE_SpecificationGroupXA__c>();
		public map<string,string> modificarValor=new map<string,string>(); 
		public map<string,string> modificarValorDO=new map<string,string>(); 


		public virtual void procesar(){}

		public void actualizarSgXa(LTE_Servicios_adicionales__c saC,string act){
            
            list<LTE_SpecificationGroupXA__c> sgXA=saC.SpecificationGroupXA__r;
            
            for(LTE_SpecificationGroupXA__c sg :sgXA){
                sg.LTE_ActionCode__c=act;
                if(modificarValor.get(sg.Name)!=null){
                	system.debug('=============== ' + sg.Name + ':' + modificarValor.get(sg.Name));
                    sg.LTE_Value__c=modificarValor.get(sg.Name);
                }
                SpecGroupXAList.add(sg);
            }
        }
        
        public void actualizarSgXaDO(LTE_Servicios_adicionales__c saC,string act){
            
            list<LTE_SpecificationGroupXA__c> sgXA=saC.SpecificationGroupXA__r;
            
            for(LTE_SpecificationGroupXA__c sg :sgXA){
                sg.LTE_ActionCode__c=act;
                if(modificarValorDO.get(sg.Name)!=null){
                    sg.LTE_Value__c=modificarValorDO.get(sg.Name);
                }
                SpecGroupXAList.add(sg);
            }
        }

        public void init(){
        	noEnviar.add('RVC');
            noEnviar.add('NUMERO TELEFONICO');
            noEnviar.add('DEFAULT USO VOZ');
            noEnviar.add('DEFAULT USO DATOS');
            noEnviar.add('DEFAULT USO SMS');
            noEnviar.add('DEFAULT USO OTROS');
            noEnviar.add('FINANCIAMIENTO');	

        }
		

	}
}