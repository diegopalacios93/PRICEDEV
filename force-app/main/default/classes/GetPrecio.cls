@RestResource(UrlMapping='/GetPrecio/')
global with sharing class GetPrecio{
    @HttpPost
    global static GetPrecioWrapper doPost(String idPlan) {
        GetPrecioWrapper responseObj = new GetPrecioWrapper();
        LTE_Servicios_adicionales__c servicioAdicional = [SELECT Id FROM LTE_Servicios_adicionales__c WHERE Plan__c =:Idplan];
        List<Precios__c> precios =[SELECT name,RangoMenor__c,RangoMayor__c,SubClasificacion__c,ValorSubClasificacion__c,Precio__c FROM Precios__c WHERE Servicio_adicional__c=:servicioAdicional.Id];
        
        System.debug('precios--->'+precios);
        List<GetPrecioWrapper.Precio> preciosWpr = new List<GetPrecioWrapper.Precio>();
        for(Precios__c precio : precios){
            GetPrecioWrapper.Precio precioWpr = new GetPrecioWrapper.Precio();
            precioWpr.name = precio.Name;
            precioWpr.rangoMenor = precio.RangoMenor__c;
            precioWpr.rangoMayor = precio.RangoMayor__c;
            precioWpr.subClasificacion = precio.SubClasificacion__c;
            precioWpr.valorSubClasificacion = precio.ValorSubClasificacion__c;
            precioWpr.Precio = precio.Precio__c;
            preciosWpr.add(precioWpr);
        }
        responseObj.precios = preciosWpr;
        return responseObj;
    } 
}