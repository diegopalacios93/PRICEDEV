@isTest
public class GenerarActasInformesAnexo_tst {           
	
    public static Poblacion__c  pob;
    public static Contract 		contr;
    public static Contract 		contr2;
    public static Contact 		con;
    public static Account 		acc;
    public static Adiciones_y_prorrogas_contratos__c adicionContrato;
    public static Observacion_contrato__c observacionContrato;
    public static Actas_de_contrato__c objActaDeContrato;
    public static Conciliaciones_de_contrato__c objConciliacion;
    
    static testMethod void TestSemaforoPDF() {   
        generarPoblacion();
        generarCuenta();  
        generarContacto();
		generarContrato();     
        Semaforo_PDF_ctr cls = new Semaforo_PDF_ctr(new Apexpages.Standardcontroller(contr));  
        cls.generarInforme();
        cls.procesarURLFile(3);
        cls.procesarURLFile(4);
        cls.formatearCampoMoneda(null);
        cls.objContrato = contr;
        cls.urlLogoETB = '1234';
        cls.procesarFecha(System.today(),'DD');
        cls.procesarFecha(System.today(),'MM');
        cls.procesarFecha(System.today(),'AAAA');
        cls.consultarUltimoHechoRelevante(con.Id);
        cls.cerrarPagina();
    }
    
    static testMethod void TestSeleccionarActa() {   
        generarPoblacion();
        generarCuenta();  
        generarContacto();
		generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();        
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        SeleccionActa_ctr cls = new SeleccionActa_ctr(new Apexpages.Standardcontroller(objActaDeContrato)); 
        cls.nuevoIVA = 'No';
        cls.generarActa();        
        
        contr.Param_Anexo_IVA__c = '16';
        update contr;
        SeleccionActa_ctr cls2 = new SeleccionActa_ctr(new Apexpages.Standardcontroller(objActaDeContrato)); 
        
        contr.Param_Anexo_IVA__c = '19';
        contr.Param_Anexo_Retefuente__c = null;
        update contr;
        SeleccionActa_ctr cls3 = new SeleccionActa_ctr(new Apexpages.Standardcontroller(objActaDeContrato)); 
        
        contr.Param_Anexo_Retefuente__c = 1;
        contr.Param_Anexo_Reteica__c = null;
        update contr;
        SeleccionActa_ctr cls4 = new SeleccionActa_ctr(new Apexpages.Standardcontroller(objActaDeContrato));
        
        contr.Param_Anexo_IVA__c = null;        
        update contr;
        SeleccionActa_ctr cls5 = new SeleccionActa_ctr(new Apexpages.Standardcontroller(objActaDeContrato)); 
        cls5.nuevoIVA = 'No';
        cls5.generarActa();
        
        objActaDeContrato.Param_Anexo_IVA__c = 19;
        update objActaDeContrato;
        SeleccionActa_ctr cls6 = new SeleccionActa_ctr(new Apexpages.Standardcontroller(objActaDeContrato)); 
        cls6.nuevoIVA = 'Empty';
        cls6.generarActa();
        
        objActaDeContrato.Param_Anexo_IVA__c = null;
        update objActaDeContrato;
        SeleccionActa_ctr cls7 = new SeleccionActa_ctr(new Apexpages.Standardcontroller(objActaDeContrato)); 
        cls7.nuevoIVA = 'Si';
        cls7.generarActa();        
        cls7.cerrarPagina();
    }
    
    static testMethod void TestGenerarActaConciliacionPDF_1() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
    static testMethod void TestGenerarActaConciliacionPDF_2() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();   
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(1);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
    static testMethod void TestGenerarActaConciliacionPDF_3() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(2);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
   static testMethod void TestGenerarActaConciliacionPDF_4() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(3);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
     static testMethod void TestGenerarActaConciliacionPDF_5() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(4);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
     static testMethod void TestGenerarActaConciliacionPDF_6() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();  
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(5);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
    static testMethod void TestGenerarActaConciliacionPDF_7() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato(); 
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(6);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
    static testMethod void TestGenerarActaConciliacionPDF_8() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();    
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(7);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
    static testMethod void TestGenerarActaConciliacionPDF_9() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();   
        objActaDeContrato.Fecha_de_acta__c = System.today()-32;
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
    static testMethod void TestGenerarActaConciliacionPDF_10() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato(); 
        objActaDeContrato.Fecha_de_acta__c = System.today()-64;
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id',objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
    static testMethod void TestGenerarActaConciliacionPDF_11() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();    
        objActaDeContrato.Fecha_de_acta__c = System.today()-96;
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }
    
    static testMethod void TestGenerarActaConciliacionPDF_12() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();    
        objActaDeContrato.Fecha_de_acta__c = System.today()-128;
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_PDF_ctr cls = new acta_conciliacion_PDF_ctr(new Apexpages.StandardController(objActaDeContrato));        
    }    
    
    static testMethod void TestGenerarInformeSupervision() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        generarConciliaciones();
        ApexPages.currentPage().getParameters().put('id', contr.Id);        
        Informe_de_supervision_PDF_ctr cls = new Informe_de_supervision_PDF_ctr(new Apexpages.Standardcontroller(contr));                
        delete objConciliacion;
    }
    
    static testMethod void TestGenerarActaCostoAdminitrativo() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_costo_administrativo_PDF_ctr cls = new acta_costo_administrativo_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarActaConciliacionConOperadores() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_con_operadores_PDF_ctr cls = new acta_conciliacion_con_operadores_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarActaConciliacionConOperadores_1() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(1);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_con_operadores_PDF_ctr cls = new acta_conciliacion_con_operadores_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarActaConciliacionConOperadores_2() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(2);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_con_operadores_PDF_ctr cls = new acta_conciliacion_con_operadores_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarActaConciliacionConOperadores_3() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(3);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_con_operadores_PDF_ctr cls = new acta_conciliacion_con_operadores_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarActaConciliacionConOperadores_4() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(4);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_con_operadores_PDF_ctr cls = new acta_conciliacion_con_operadores_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarActaConciliacionConOperadores_5() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(5);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_con_operadores_PDF_ctr cls = new acta_conciliacion_con_operadores_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarActaConciliacionConOperadores_6() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(6);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_con_operadores_PDF_ctr cls = new acta_conciliacion_con_operadores_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarActaConciliacionConOperadores_7() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(7);
        update objActaDeContrato;
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        acta_conciliacion_con_operadores_PDF_ctr cls = new acta_conciliacion_con_operadores_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarActaConciliacionConAliados() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato(); 
        generarActaDeContrato();
        ApexPages.currentPage().getParameters().put('id', objActaDeContrato.Id);
        Acta_de_conciliacion_con_aliados_PDF_ctr cls = new Acta_de_conciliacion_con_aliados_PDF_ctr(new Apexpages.Standardcontroller(contr));
    }
    
    static testMethod void TestGenerarSemaforo() {
        generarPoblacion();
        generarCuenta();
        generarContacto();        
        generarContrato(); 
        generarContrato2(); 
        generarAdicionContrato();
        GenerarCSV_SemaforoContrato_ctr cls = new GenerarCSV_SemaforoContrato_ctr();
        cls.exportToExcel();
        Delete adicionContrato;
    }

    public static Id generarContrato(){
        contr = new Contract();
        contr.AccountId = acc.Id;
        contr.Contacto__c = con.Id;
        contr.Anexo__c = 'ACEPTACION DE OFERTA AL CONTRATO PARA LA PRESTACION DE LOS SERVICIOS DE TELECOMUNICACIONES';
        contr.Fecha_de_suscripcion__c = System.today();
        contr.Fecha_de_inicio__c =   System.today();
        contr.Fecha_de_terminacion__c =   System.today();
        contr.Tiempo_de_liquidacion__c = 3;
        contr.Status = 'Ejecución';
        contr.Valor_sin_IVA__c = 20000000;
        contr.porcentaje_IVA__c = '19';
        contr.Valor_adiciones__c = 1000000;
        contr.Numero_de_adiciones__c = 2;
        contr.Ejecutado__c = 200000;
        contr.Valor_ejecutado_calculado_escritura__c = 200000;
        contr.Facturado__c = 100000;
        contr.Conciliado__c = 300000;
        contr.Valor_mes__c = 50000;
        contr.Valor_fijo_o_variable__c = 'Fijo';
        contr.StartDate = System.today();     
		contr.Param_Anexo_IVA__c = '19';
        contr.Param_Anexo_Reteica__c = 0.00966;
        contr.Param_Anexo_Retefuente__c = 4;		
        insert contr;    
        return contr.Id;
  	}
    
    public static Id generarContrato2(){
        contr2 = new Contract();
        contr2.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Anexo Colaborador').getRecordTypeId();        
        contr2.AccountId = acc.Id;
        contr2.Contacto__c = con.Id;
        contr2.Anexo__c = 'TEST CONTRACT 2';
        contr2.Fecha_de_suscripcion__c = System.today();
        contr2.Fecha_de_inicio__c =   System.today();
        contr2.Fecha_de_terminacion__c =   System.today();
        contr2.Tiempo_de_liquidacion__c = 3;
        contr2.Status = 'Ejecución';
        contr2.Valor_sin_IVA__c = 20000000;
        contr2.porcentaje_IVA__c = '19';
        contr2.Valor_adiciones__c = 1000000;
        contr2.Numero_de_adiciones__c = 2;
        contr2.Ejecutado__c = 200000;
        contr2.Valor_ejecutado_variable__c = 200000;
        contr2.Facturado__c = 100000;
        contr2.Conciliado__c = 300000;
        contr2.Valor_mes__c = 50000;
        contr2.Valor_fijo_o_variable__c = 'Fijo';
        contr2.StartDate = System.today();       
        contr2.Param_Anexo_IVA__c = '19';
        contr2.Param_Anexo_Reteica__c = 0.00966;
        insert contr2;    
        return contr2.Id;
  	}
    
    public static Id generarContacto(){  
        con = new Contact(IsTEST__c = true);
        con.LastName = 'contactoconconconcontest';
        con.AccountId = acc.Id;
        con.Phone = '00000000';
        insert con;    
        return con.Id;
  	}
    
    public static Id generarCuenta(){
        acc = new Account();
        acc.Name = 'cuentacuentacuenta123';
        acc.Ciudad__c = pob.Id;
        acc.Type = 'Prospecto';
        acc.AccountNumber='240324';
        acc.Segmento__c='Empresas';
        acc.SubSegmento__c='Grandes';
        acc.Tipodedocumento__c='NIT';
        acc.Estado_Cuenta__c='Activo';
        acc.Phone='3133698521';
        insert acc;    
        return acc.Id;
    }
    
    public static Id generarPoblacion(){
        pob = new Poblacion__c();
        pob.CodigoDane__c = '1100001';
        pob.EsMunicipio__c = true;
        pob.name = 'testland';
        pob.Tipo_de_instalacion__c = 'Bogotá';
        insert pob;        
        return pob.Id;
    }
    public static Id generarAdicionContrato(){
        adicionContrato = new Adiciones_y_prorrogas_contratos__c();
        adicionContrato.Acuerdo_No__c = '1';
        adicionContrato.Porcentaje_IVA__c = '19';
        adicionContrato.Valor_antes_de_IVA__c = 100000;
        adicionContrato.Prorroga_o_adicion__c = 'Adición';
        adicionContrato.Objeto__c = '#1';
        adicionContrato.Contrato_relacionado__c = contr.Id;        
        insert adicionContrato;
        return adicionContrato.Id;
  	}
	public static Id generarObservacionContrato(){
        observacionContrato = new Observacion_contrato__c();    
        observacionContrato.Descripcion__c = 'Descripción';
        observacionContrato.Contrato_relacionado__c = contr.Id;
        insert observacionContrato;    
        return observacionContrato.Id;
    }
    
    public static Id generarActaDeContrato(){
        objActaDeContrato = new Actas_de_contrato__c();     
        objActaDeContrato.Acta_No__c = '1234';
        objActaDeContrato.Participacion__c = 1000000;
        objActaDeContrato.Codigo_ETB__c = '1234';
        objActaDeContrato.Codigo_acreedor_deudor__c = '1234';
        objActaDeContrato.Representante_del_aliado__c = 'Usuario';
        objActaDeContrato.Contrato_relacionado__c = contr.Id;
        objActaDeContrato.Fecha_de_acta__c = System.today().addMonths(10);
        objActaDeContrato.Periodo_a_conciliar_Desde__c = System.today().addMonths(2);
        objActaDeContrato.Periodo_a_conciliar_Hasta__c = System.today().addMonths(3);
        objActaDeContrato.Fecha_de_acta_costo_administrativo__c = System.today().addMonths(4);
        objActaDeContrato.Dia_de_transferencia__c = '30';    
        objActaDeContrato.Mes_de_consumo__c = 'Enero';
        objActaDeContrato.Param_Anexo_IVA__c = 19;
        objActaDeContrato.Param_Anexo_Reteica__c = 0.00966;
        objActaDeContrato.Param_Anexo_Retefuente__c = 4;
        objActaDeContrato.Descripcion__c = 'Servicios';
        objActaDeContrato.Facturado__c = 'SI';
        insert objActaDeContrato;
        return objActaDeContrato.Id;
     }
    
    public static Id generarConciliaciones(){
        objConciliacion = new Conciliaciones_de_contrato__c();
        objConciliacion.Valor_sin_IVA__c = 1000000;
        objConciliacion.Porcentaje_IVA__c = '19';
        objConciliacion.Descripcion__c = 'Servicios';
        objConciliacion.Fecha_del_acta__c = System.today();
        objConciliacion.Facturado__c = 'SI';
        objConciliacion.Contrato_relacionado__c = contr.Id;
        insert objConciliacion;
        return objConciliacion.Id;
    }        
}