@istest
public class Acta_liquidacion_proveedor_tst {
    public static Contact                   objContact;
    public static Account                   objAccount;
    public static Poblacion__c                objPoblacion;
    public static Contract                  objContract;
    public static Acta_de_liquidaci_n__c            objActaLiquidacion;
    public static Adiciones_y_prorrogas_contratos__c      objAdicionProrroga;
    public static Conciliaciones_de_contrato__c             objConciliacionContrato;
    public static Aprobacion_de_garantias_del_contrato__c   objGarantia;
    
    static testMethod void TestActaLiquidacion() { 
        generarPoblacion();
        generarCuenta();  
        generarContacto();
    generarContrato(); 
        generarAdicionProrroga();
        generarConciliacionContrato();
        generarActaDeLiquidacion();
        generarGarantia();
        ApexPages.currentPage().getParameters().put('id', objActaLiquidacion.Id);
        Acta_liquidacion_proveedor_PDF_ctr cls = new Acta_liquidacion_proveedor_PDF_ctr(new Apexpages.StandardController(objActaLiquidacion));        
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
        objContract.Fecha_de_inicio__c =   System.today();
        objContract.Fecha_de_terminacion__c =   System.today();
        objContract.Tiempo_de_liquidacion__c = 3;
        objContract.Status = 'Ejecución';
        objContract.Valor_sin_IVA__c = 20000000;
        objContract.porcentaje_IVA__c = '19';
        objContract.Valor_adiciones__c = 1000000;
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
    public static Id generarActaDeLiquidacion(){
        objActaLiquidacion = new Acta_de_liquidaci_n__c();
        objActaLiquidacion.Fecha_de_aprobaci_n_de_garant_as__c= system.today();
        objActaLiquidacion.Fecha_de_liquidaci_n__c = system.today()+30;
        objActaLiquidacion.Fecha_de_validaci_n_financiera__c = system.today()+60;
        objActaLiquidacion.Subscripcion_de_acuerdos__c = true;
        objActaLiquidacion.Cargo_del_representante_legal__c = 'Gerente general';
        objActaLiquidacion.nombre_del_representate_legal__c = 'Don nombre';  
        objActaLiquidacion.Contrato_relacionado__c = objContract.Id;
      insert objActaLiquidacion;
        return objActaLiquidacion.Id;        
    }
    public static Id generarAdicionProrroga(){
        objAdicionProrroga = new  Adiciones_y_prorrogas_contratos__c();
        objAdicionProrroga.Valor_antes_de_IVA__c = 500000;
        objAdicionProrroga.Porcentaje_IVA__c = '19';
        objAdicionProrroga.Fecha_de_inicio__c = system.today();
        objAdicionProrroga.Fecha_de_fin__c = system.today()+30;
        objAdicionProrroga.Prorroga_o_adicion__c = 'Adición';
        objAdicionProrroga.Objeto__c = 'esto es un test'; 
        objAdicionProrroga.Contrato_relacionado__c = objContract.Id;
        insert objAdicionProrroga;
        return objAdicionProrroga.Id;
    }
  public static Id generarConciliacionContrato(){
      
      objConciliacionContrato = new Conciliaciones_de_contrato__c();
      objConciliacionContrato.Valor_sin_IVA__c = 1000000;
      objConciliacionContrato.Porcentaje_IVA__c = '19';
      objConciliacionContrato.Descripcion__c = 'Bienes';
      objConciliacionContrato.Numero_de_acta__c = '12345';
      objConciliacionContrato.Fecha_del_acta__c = system.today();
      objConciliacionContrato.Facturado__c = 'si';
      objConciliacionContrato.Contrato_relacionado__c = objContract.Id;
      insert objConciliacionContrato;
      return objConciliacionContrato.Id;
    }
    public static Id generarGarantia(){
        objGarantia = new Aprobacion_de_garantias_del_contrato__c();
        objGarantia.Amparo__c = 'Cumplimiento';
        objGarantia.Aseguradora__c = 'Aseguradora test';
        objGarantia.Valor_Asegurado__c = 1000000;
        objGarantia.N_mero_de_P_liza__c = 123456;
        objGarantia.Contrato__c = objContract.Id;
        objGarantia.Vigencia__c = system.today()+30;
        insert objGarantia;
        return objGarantia.Id;
    }
}