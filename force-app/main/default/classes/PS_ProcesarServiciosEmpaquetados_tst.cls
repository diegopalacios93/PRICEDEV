@isTest
public class PS_ProcesarServiciosEmpaquetados_tst {
    static testMethod void PS_ProcesarServiciosEmpaquetadosTest(){
        GeneraData_cls.generarData();        
        PS_ProcesarServiciosEmpaquetados_cls.procesar(GeneraData_cls.objPlan4.Id, GeneraData_cls.opp.Id, Userinfo.getUserId(), GeneraData_cls.acc.Id, GeneraData_cls.objServicio2.Id, GeneraData_cls.oc.Id);
    }
}