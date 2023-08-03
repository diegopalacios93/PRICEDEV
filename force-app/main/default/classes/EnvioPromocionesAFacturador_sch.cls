/**************************************************************************************************
Desarrollado por: Accenture
Autores: Luisina Platino
Proyecto: ETB MiPymes y Empresas        
Descripción: Construcción del Scheduler para la integración hacia facturador (Promociones, descuentos) Salesforce-Tibco --> Tibco-Rechain 
Clase test: ConstruirXMLScheduleFacturador_tst
 
Cambios (Versiones)
-------------------------------------
No.     Fecha           Autores                Descripción
1.0     11/03/2022      Luisina Platino (LP)   Creacion de la clase
***************************************************************************************************/
public class EnvioPromocionesAFacturador_sch implements Schedulable {

 	public void execute(SchedulableContext sc){
        Map<string,AprovisionamientoOnline__c> apr = AprovisionamientoOnline__c.getall();
				
		EnvioPromocionesAFacturador_bch batchEnvioPromo = new EnvioPromocionesAFacturador_bch();
		batchEnvioPromo.limitQ = true;
		batchEnvioPromo.limiteTotal=(Integer)apr.get('EnvioPromocionesFacturador').LTE_Noche__c;
		ID batchprocessid = Database.executeBatch(batchEnvioPromo, 1);
    }
}