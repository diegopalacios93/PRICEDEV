@isTest
public class Actas_de_proveedor_tst {
	public static Contact 									objContact;
    public static Account 									objAccount;
    public static Poblacion__c  							objPoblacion;
    public static Contract 									objContract;
    public static Actas_de_proveedor__c						objActaProveedor;
    public static Bienes_y_servicios_Acta_de_proveedor__c	objBienes_Servicios;
    
    static testMethod void TestActaProveedor() { 
        generarPoblacion();
        generarCuenta();  
        generarContacto();
		generarContrato(); 
        generarActaDeProveedor();
        generarBienYServicio();
        ApexPages.currentPage().getParameters().put('id', objActaProveedor.Id);
        Acta_de_proveedor_PDF_ctr cls = new Acta_de_proveedor_PDF_ctr(new Apexpages.StandardController(objActaProveedor));        
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
    public static Id generarActaDeProveedor(){
        objActaProveedor = new Actas_de_proveedor__c();
        objActaProveedor.Acta_No__c = '10';
        objActaProveedor.Area__c = 'Area';
        objActaProveedor.Tipo_de_servicio__c = 'Tipo de servicio';
        objActaProveedor.Tipo_de_presupuesto__c = 'OPEX';
        objActaProveedor.Fecha_de_recepcion_del_bien_o_servicio__c = 'Enero 21';
        objActaProveedor.Representante_del_aliado__c = 'Representante';
        objActaProveedor.Cargo_del_representante_del_aliado__c = 'Cargo representante';
        objActaProveedor.Tratamiento_representante_del_aliado__c = 'Señor';
        objActaProveedor.Tratamiento_representante_de_ETB__c = 'Señor';
        objActaProveedor.Mes_de_consumo__c = 'Enero';
        objActaProveedor.Anio_de_consumo__c = 2020;
        objActaProveedor.Soportes_entrega_bienes_y_servicios__c = 'NA';
        objActaProveedor.Facturado__c = 'SI';
        objActaProveedor.Descripcion__c = 'Bienes';    
        objActaProveedor.Contrato_relacionado__c = objContract.Id;
        objActaProveedor.IVA__c = 19;    
        objActaProveedor.Dias_calendario_a_pagar__c = 01;    
        objActaProveedor.Moneda__c = 'Pesos';    
        objActaProveedor.Centro_gestor__c = 'Gestor';    
        objActaProveedor.Pagadero_en_dolares__c = 'No';
        objActaProveedor.Cantidad__c = 1;
        objActaProveedor.Ciudad_expedicion_acta__c = objPoblacion.Id;
        objActaProveedor.Fecha_de_acta__c = System.today();      
        insert objActaProveedor;
        return objActaProveedor.Id;        
    }
    public static Id generarBienYServicio(){
        objBienes_Servicios = new Bienes_y_servicios_Acta_de_proveedor__c();
        objBienes_Servicios.Descripcion__c	= 'Bien y servicio 1';
 		objBienes_Servicios.Valor_unitario_del_contrato__c = 1000000;
        objBienes_Servicios.Cantidad__c = 1;        
        objBienes_Servicios.Acta_de_proveedor__c = objActaProveedor.Id;
        insert objBienes_Servicios;
        return objBienes_Servicios.Id;
    }    
}