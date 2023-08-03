@IsTest
public class Acta_certificado_aliado_liqui_tst {
    public static Contact                                   objContact;
    public static Account                                   objAccount;
    public static Poblacion__c                              objPoblacion;
    public static Contract                                  objContract;
    public static Acta_de_Certificado__c                    objActaCertificado;
    public static Adiciones_y_prorrogas_contratos__c        objAdicionesYProrrogas; 

    @IsTest
    static void  TestActaCertificado() { 
        generarPoblacion();
        generarCuenta();  
        generarContacto();
        generarContrato(); 
        generarActaCertificado();
        ApexPages.currentPage().getParameters().put('id', objActaCertificado.Id);
        Acta_certificado_aliado_liqui_PDF_ctr cls = new Acta_certificado_aliado_liqui_PDF_ctr(new Apexpages.StandardController(objActaCertificado));
        cls.toTitleCase('abc');
        cls.formatearCampoNumero(2112);
    }

    @IsTest
    static void testActaCertificadoSenior(){
        
        generarPoblacion();
        generarCuenta();  
        generarContacto();
        generarContrato(); 
        generarActaCertificado();
        generarAdicionesYProrrogas();

        Contract ctr = [SELECT Fecha_de_suscripcion__c, Fecha_de_inicio__c, Fecha_de_terminacion__c, Facturado__c, Valor_sin_IVA__c FROM Contract LIMIT 1];

        ctr.Fecha_de_suscripcion__c = date.newInstance(2021, 6, 15);
        ctr.Fecha_de_inicio__c = date.newInstance(2021, 7, 6);
        ctr.Fecha_de_terminacion__c = date.newInstance(2021, 11, 20);
        ctr.Facturado__c = 500;
        ctr.Valor_sin_IVA__c = 2530000;
        update ctr;

        Acta_de_Certificado__c act = [SELECT Tratamiento__c, Fecha_de_liquidacion__c FROM Acta_de_Certificado__c LIMIT 1];
        act.Tratamiento__c = 'Señor';
        act.Fecha_de_liquidacion__c = date.newInstance(2021, 12, 23);
        update act;

        ApexPages.currentPage().getParameters().put('id', objActaCertificado.Id);
        Acta_certificado_aliado_liqui_PDF_ctr cls = new Acta_certificado_aliado_liqui_PDF_ctr(new Apexpages.StandardController(objActaCertificado)); 
        cls.toTitleCase('abc');
        cls.formatearCampoNumero(123);
    }

    public static Id generarContacto(){  
        objContact = new Contact(IsTEST__c = true);
        objContact.LastName = 'contactoconconconcontest';
        objContact.AccountId = objAccount.Id;
        objContact.Phone = '00000000';
        insert objContact;    
        return objContact.Id;
    }
    
    public static Id generarCuenta(){
        objAccount = new Account();
        objAccount.Name = 'cuentacuentacuenta123';
        objAccount.Ciudad__c = objPoblacion.Id;
        objAccount.Type = 'Prospecto';
        objAccount.AccountNumber='240324';
        objAccount.Segmento__c='Empresas';
        objAccount.SubSegmento__c='Grandes';
        objAccount.Tipodedocumento__c='NIT';
        objAccount.Estado_Cuenta__c='Activo';
        objAccount.Phone='3133698521';
        insert objAccount;    
        return objAccount.Id;
    }
    
    public static Id generarPoblacion(){
        objPoblacion = new Poblacion__c();
        objPoblacion.CodigoDane__c = '1100001';
        objPoblacion.EsMunicipio__c = true;
        objPoblacion.name = 'Bogotá';
        objPoblacion.Tipo_de_instalacion__c = 'Bogotá';
        insert objPoblacion;
        return objPoblacion.Id;
    }
    
    public static Id generarContrato(){
        objContract = new Contract();
        objContract.AccountId = objAccount.Id;
        objContract.Contacto__c = objContact.Id;
        objContract.Anexo__c = 'ACEPTACION DE OFERTA AL objContractATO PARA LA PRESTACION DE LOS SERVICIOS DE TELECOMUNICACIONES';
        objContract.Fecha_de_suscripcion__c = System.today();
        objContract.Fecha_de_inicio__c =    date.newInstance(2021, 1, 15);
        objContract.Fecha_de_terminacion__c =   System.today();
        objContract.Tiempo_de_liquidacion__c = 3;
        objContract.Status = 'Liquidación';
        objContract.Valor_sin_IVA__c = 20000000;
        objContract.porcentaje_IVA__c = '19';
        objContract.Valor_adiciones__c = 1134520;
        objContract.Valor_adiciones_sin_iva__c = 1000000;
        objContract.Numero_de_adiciones__c = 2;
        objContract.Ejecutado__c = 200000;
        objContract.Valor_ejecutado_calculado_escritura__c = 200000;
        objContract.Facturado__c = 100000;
        objContract.Conciliado__c = 300000;
        objContract.Valor_mes__c = 50000;
        objContract.Valor_fijo_o_variable__c = 'Fijo';
        objContract.StartDate = System.today();     
        objContract.Param_Anexo_IVA__c = '19';
        objContract.Param_Anexo_Reteica__c = 0.00966;
        objContract.Param_Anexo_Retefuente__c = 4;      
        insert objContract;    
        return objContract.Id;
    }
    
    public static Id generarAdicionesYProrrogas(){
        objAdicionesYProrrogas = new Adiciones_y_prorrogas_contratos__c();
        objAdicionesYProrrogas.Valor_antes_de_IVA__c = 12345;
        objAdicionesYProrrogas.Porcentaje_IVA__c = '6';
        objAdicionesYProrrogas.Prorroga_o_adicion__c = 'Adición';
        objAdicionesYProrrogas.Objeto__c ='IVA';
        objAdicionesYProrrogas.Fecha_de_fin__c = date.today().addMonths(1);
        objAdicionesYProrrogas.Fecha_de_inicio__c = date.today();
        objAdicionesYProrrogas.Contrato_relacionado__c =  objContract.Id;
        insert objAdicionesYProrrogas;
        return objAdicionesYProrrogas.id; 
        
    }
    
    public static Id generarActaCertificado(){
        objActaCertificado = new Acta_de_Certificado__c();
        objActaCertificado.CSG__c= 9876;
        objActaCertificado.Tratamiento__c = 'Señora';
        objActaCertificado.Nombre_del_representante_del_aliado__c = 'NombreTest';
        objActaCertificado.Apellido_del_representante_del_aliado__c = 'ApellidoTest';
        objActaCertificado.Cargo_del_representante_del_aliado__c = 'Gerente General';
        objActaCertificado.Area_del_representante_del_aliado__c = 'VentasTest';  
        objActaCertificado.Facultado_1__c = 'NombreTest ApellidoTest1';
        objActaCertificado.Facultado_2__c = 'NombreTest ApellidoTest2';
        objActaCertificado.Vicepresidencia_Facultado_1__c = 'Vicepresidencia1';
        objActaCertificado.Vicepresidencia_Facultado_2__c = 'Vicepresidencia2';
        objActaCertificado.Fecha_de_liquidacion__c = date.today();
        objActaCertificado.Contrato_relacionado__c = objContract.Id;
        insert objActaCertificado;
        return objActaCertificado.Id;        
    }
}