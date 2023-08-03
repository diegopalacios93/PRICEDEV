/**
 * @description       : 
 * @author            : j.martinez.mercado
 * @group             : 
 * @last modified on  : 04-07-2022
 * @last modified by  : j.martinez.mercado
**/
global class DEG_LlenarReportePorProveedor_cls  implements Schedulable{
    global static void execute(SchedulableContext SC){ 
        DEG_ReportePorProveedores_cls.setRecordsInReportePorProveedor();
    }
}