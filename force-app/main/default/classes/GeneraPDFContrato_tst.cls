@isTest
public class GeneraPDFContrato_tst {           
	
    public static Poblacion__c  pob;
    public static Contract 		contr;    
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
        generarAdicionContrato();
        generarActaDeContrato();
		generarConciliaciones();    
        Semaforo_PDF_ctr cls = new Semaforo_PDF_ctr(new Apexpages.Standardcontroller(contr));  
        cls.generarInforme();
        cls.procesarURLFile(3);
        cls.procesarURLFile(4);
        cls.formatearCampoMoneda(null);
        cls.objContrato = contr;
        cls.urlLogoETB = '1234';
        cls.consultarUltimoHechoRelevante(contr.Id);
        cls.procesarFecha(Date.today(), 'DD');
        cls.procesarFecha(Date.today(), 'MM');
        cls.procesarFecha(Date.today(), 'AAAA');
        cls.procesarFecha(Date.today(), '');
        adicionContrato.Acuerdo_No__c = '2';
        update adicionContrato;
        delete adicionContrato;
        objConciliacion.Porcentaje_IVA__c = '16';
        update objConciliacion;        
        objActaDeContrato.Acta_No__c = '555';
        update objActaDeContrato;
        delete objActaDeContrato;
    }    

    public static Id generarContrato(){
        contr = new Contract();
        contr.AccountId = acc.Id;
        contr.Contacto__c = con.Id;
        contr.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Anexo Colaborador').getRecordTypeId();
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
        //objActaDeContrato.Param_Anexo_IVA__c = '19';
        objActaDeContrato.Param_Anexo_Reteica__c = 0.00966;
        objActaDeContrato.Param_Anexo_Retefuente__c = 4;
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