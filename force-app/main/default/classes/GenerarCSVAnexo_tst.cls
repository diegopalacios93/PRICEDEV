@isTest
public class GenerarCSVAnexo_tst { 
    
    public static Poblacion__c  pob;
    public static Contract 		contr;
    public static Contact 		con;
    public static Account 		acc;
    public static Adiciones_y_prorrogas_contratos__c adicionContrato;
    public static Observacion_contrato__c observacionContrato;
    
    
    static testMethod void TestGenerarCSVProrrogaAnexoColaborador() {
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato();
        generarAdicionContrato();
        generarObservacionContrato();
        GenerarCSVAnexo_Observacion cls = new GenerarCSVAnexo_Observacion();    
        cls.ContractId = contr.Id;
        cls.exportToExcel();        
    }
        
    static testMethod void TestGenerarCSVAdicionAnexoColaborador() {                
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato();
        GenerarCSVAnexo_prorroga cls = new GenerarCSVAnexo_prorroga();    
        cls.ContractId = contr.Id;
        cls.AdicProId  = adicionContrato.Id;
        cls.source = 'All';
        cls.exportToExcel();
        cls.source = 'Single';
        cls.getIdRegistro();
        cls.exportToExcel();
    }
    
    static testMethod void TestGenerarCSVAnexoColaborador() { 
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato();       
        GenerarCSVAnexoColaborador cls = new GenerarCSVAnexoColaborador();    
        cls.ContractId = contr.Id;        
        cls.exportToExcel();
    }
    
    static testMethod void TestSeleccionarExportacionDatos() { 
        generarPoblacion();
        generarCuenta();
        generarContacto();
        generarContrato(); 
        generarAdicionContrato();
		Contract objContract = new Contract();        
        SeleccionarExportacionDatos_ctr cls = new SeleccionarExportacionDatos_ctr(new Apexpages.Standardcontroller(objContract));        
        cls.tipoExportacion = 'Contrato';
        cls.generarInforme();
        cls.tipoExportacion = 'Adiciones_Prorrogas';
        cls.generarInforme();
        cls.tipoExportacion = 'Observaciones';
        cls.generarInforme();
        cls.cerrarPagina();
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
}