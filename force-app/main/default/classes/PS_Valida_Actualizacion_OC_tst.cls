@isTest
public class PS_Valida_Actualizacion_OC_tst {
    public static Boolean doNotRunTrigger = false;
	static testMethod void ValidaActualizacionOC() {
        doNotRunTrigger = true;
        // Generar datos de test
        GeneraData_cls.generarData();
        VariablesGlobales__c vGlobal = new VariablesGlobales__c();
        vGlobal.Name = 'NombreComercialLTE';
        vGlobal.Valor__c = 'TELEFONIA MOVIL (LTE)';   
        Insert vGlobal;
        test.startTest();
        //
        PS_Valida_Actualizacion_OC_cls cls = new PS_Valida_Actualizacion_OC_cls();
        cls.validaActualizacionOC(GeneraData_cls.oc2,GeneraData_cls.oc3,'Viabilidad','OperacionComercial__c');
        cls.ActualizaOCRelacionadas(GeneraData_cls.oc3,GeneraData_cls.oc2);
        cls.obtenerPerfilUsuario();
        test.stopTest();
    }
}