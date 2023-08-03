public class GenerarOperacionComercialRetiro {
    @InvocableMethod
    public static void generarOCRetiro(List<id> ocId) {
        OperacionComercial__c oc = [SELECT id, Tiempo_de_asignacion_de_ingeniero__c, Plan__c, Contacto_Administrativo__c,
                                    Contacto_Tecnico__c, Activo__c, SucursalOrigen__c, Tipo_de_Direccion__c
                                    FROM OperacionComercial__c WHERE id = :ocId[0]];
        OperacionComercial__c ocRetiro = new OperacionComercial__c();
        ocRetiro.RecordTypeId = [SELECT id FROM RecordType WHERE DeveloperName = 'Venta_Retiro_Ingeniero_CCE'].id;
        if(!test.isRunningTest()){
            ocRetiro.TOPP__c = [SELECT id FROM TOPP__c WHERE Name = 'Retiro- Plan Ingeniero CCE' LIMIT 1].id;
        }        
        ocRetiro.Tiempo_de_asignacion_de_ingeniero__c = oc.Tiempo_de_asignacion_de_ingeniero__c;
        ocRetiro.Plan__c = oc.Plan__c;
        ocRetiro.Contacto_Administrativo__c = oc.Contacto_Administrativo__c;
        ocRetiro.Contacto_Tecnico__c = oc.Contacto_Tecnico__c;
        ocRetiro.Estado__c = 'Pendiente';
        ocRetiro.Activo__c = oc.Activo__c;
        ocRetiro.SucursalOrigen__c = oc.SucursalOrigen__c;
        ocRetiro.Tipo_de_Direccion__c = oc.Tipo_de_Direccion__c;
        insert ocRetiro;
    }
}