public with sharing class PlanLargaDistanciaConveniodeVoz {


	public class VentaActiva extends OperacionPorPlan_cls.Step 
	{
		public override void procesar(set<Id> paraProcesar)
		{
			
			map<id,SObject> lineas= objetosAdicionales.get('linea__c');

			for(Id soId:lineas.keySet()){
				SObject soLinea=lineas.get(soId);
				Id ocRel= (Id)soLinea.get('Operacion_Comercial_Actual__c');
				//soLinea.put('Operacion_Comercial_Anterior__c',soLinea.get('ActivoLargaDistancia__c'));
				soLinea.put('ActivoLargaDistancia__c',ocNew.get(ocRel).Activo__c);
                //Asigna el convenio de cupo
                system.debug(ocNew.get(ocRel).Planes_Convenio_Voz__c);
                if(soLinea.get('Activo__c')!=null){
                    ActivoETB__c ac= new ActivoETB__c(Id=(ID)soLinea.get('Activo__c'),Plan_Larga_Distancia__c=ocNew.get(ocRel).Planes_Convenio_Voz__c);
                    objetosAdicionales.get('ServiciosActualizar').put(ac.id,ac);
                }
			}
	
		}
	}

	public class AdicionLineasdeLDActiva extends OperacionPorPlan_cls.Step 
	{
		public override void procesar(set<Id> paraProcesar)
		{
			
			map<id,SObject> lineas= objetosAdicionales.get('linea__c');

			for(Id soId:lineas.keySet()){
				SObject soLinea=lineas.get(soId);
				Id ocRel= (Id)soLinea.get('Operacion_Comercial_Actual__c');
				//soLinea.put('Operacion_Comercial_Anterior__c',soLinea.get('ActivoLargaDistancia__c'));
				soLinea.put('ActivoLargaDistancia__c',ocNew.get(ocRel).Activo__c);
                //Asigna el convenio de cupo
                system.debug(ocNew.get(ocRel).Planes_Convenio_Voz__c);
                if(soLinea.get('Activo__c')!=null){
                    ActivoETB__c ac= new ActivoETB__c(Id=(ID)soLinea.get('Activo__c'),Plan_Larga_Distancia__c=ocNew.get(ocRel).Planes_Convenio_Voz__c);
                    objetosAdicionales.get('ServiciosActualizar').put(ac.id,ac);
                }
			}
	
		}
	}

	public class RetiroActiva extends OperacionPorPlan_cls.Step 
	{
		public override void procesar(set<Id> paraProcesar)
		{
			
			map<id,SObject> lineas= objetosAdicionales.get('linea__c');

			for(Id soId:lineas.keySet()){
				SObject soLinea=lineas.get(soId);
				Id ocRel= (Id)soLinea.get('Operacion_Comercial_Actual__c');
				soLinea.put('Activo_Larga_Distancia_Anterior__c',soLinea.get('ActivoLargaDistancia__c'));
				soLinea.put('ActivoLargaDistancia__c',null);

				
				//Restaura el servicio a plan mundo
				system.debug(soLinea);
				if(soLinea.get('Activo__c')!=null){
					ActivoETB__c ac= new ActivoETB__c(Id=(ID)soLinea.get('Activo__c'),Plan_Larga_Distancia__c='Plan Mundo Automatico - Asistido');
					objetosAdicionales.get('ServiciosActualizar').put(ac.id,ac);
				}
			}
	
		}
	}


	public class RetiroLineasdeLDActiva extends OperacionPorPlan_cls.Step 
	{
		public override void procesar(set<Id> paraProcesar)
		{
			
			map<id,SObject> lineas= objetosAdicionales.get('linea__c');

			for(Id soId:lineas.keySet()){
				SObject soLinea=lineas.get(soId);
				Id ocRel= (Id)soLinea.get('Operacion_Comercial_Actual__c');
				soLinea.put('Activo_Larga_Distancia_Anterior__c',soLinea.get('ActivoLargaDistancia__c'));
				soLinea.put('ActivoLargaDistancia__c',null);

				
				//Restaura el servicio a plan mundo
				system.debug(soLinea);
				if(soLinea.get('Activo__c')!=null){
					ActivoETB__c ac= new ActivoETB__c(Id=(ID)soLinea.get('Activo__c'),Plan_Larga_Distancia__c='Plan Mundo Automatico - Asistido');
					objetosAdicionales.get('ServiciosActualizar').put(ac.id,ac);
				}

			}
		}
	}

    public class CambiodePlanActiva extends OperacionPorPlan_cls.Step 
    {
        public override void procesar(set<Id> paraProcesar)
        {
            
            map<id,SObject> lineas= objetosAdicionales.get('linea__c');

            for(Id soId:lineas.keySet()){
                SObject soLinea=lineas.get(soId);
                Id ocRel= (Id)soLinea.get('Operacion_Comercial_Actual__c');

                soLinea.put('Plan_convenio_anterior__c',soLinea.get('Plan_convenio__c')+'');
                system.debug(ocNew.get(ocRel).Planes_Convenio_Voz__c);
                soLinea.put('Plan_convenio__c',ocNew.get(ocRel).Planes_Convenio_Voz__c);
                
                //Asigna el convenio de cupo
                system.debug(soLinea);
                if(soLinea.get('Activo__c')!=null){
                    ActivoETB__c ac= new ActivoETB__c(Id=(ID)soLinea.get('Activo__c'),Plan_Larga_Distancia__c=ocNew.get(ocRel).Planes_Convenio_Voz__c);
                    objetosAdicionales.get('ServiciosActualizar').put(ac.id,ac);
                }
            }   
        }
    }


}