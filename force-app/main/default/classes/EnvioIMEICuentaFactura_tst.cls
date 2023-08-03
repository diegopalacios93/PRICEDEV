/*******************************************************************************
Desarrollado por:       Accenture
Autor:                  Miguel R. Gómez
Proyecto:               ETB
Descripcion:            Clase de test de todos los metodos necesarios para el envio de los IMEIS de la cuentas de Factura.

Cambios (Versiones)
--------------------------------------------------------------------------------
No.     Fecha       Autor                   Descripcion
------  ----------  --------------------    ---------------
1.0     15-12-2021  Miguel R. Gómez         Creacion de la clase.
*******************************************************************************/
@isTest
public with sharing class EnvioIMEICuentaFactura_tst {
    
    public static Map<string,string> valoreGlobalesTest =new Map<string,string>(); 

    public static void crearData(){
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='Numeracion10Digitos',Valor__c='Falso'));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario01',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario02',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario03',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario04',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario05',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario06',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario07',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'));
        vg.add(new LTE_APN__c(Name = 'EstadosViaAPN', Valor__c = 'En Espera', Tipo__c = 'Variable'));
        insert vg;
        
        Account cliente = new Account();
        cliente.Name ='ETB SUCURSAL COLOMBIA'+Math.random()*100;
        cliente.RazonSocial__c='ETB SUCURSAL COLOMBIA';
        cliente.Tipodedocumento__c= 'NIT';
        cliente.AccountNumber = '823698522';
        cliente.Phone = '12345678';
        cliente.Direccion__c='CRA 7 No. 20 37';
        cliente.Description='Description';
        cliente.Estado_Cuenta__c='Activo';
        cliente.Segmento__c='Empresas';
        cliente.SubSegmento__c='sub seg';
        insert cliente;
        
         Account clienteAliado = new Account();
        clienteAliado.Name ='SERGIO ALFONSO GUTIÉRREZ - ALIADO';
        clienteAliado.RazonSocial__c='ETB ALIADO';
        clienteAliado.Tipodedocumento__c= 'NIT';
        clienteAliado.AccountNumber = '823698523';
        clienteAliado.Phone = '12345678';
        clienteAliado.Direccion__c='CRA 7 No. 20 37';
        clienteAliado.Description='Description';
        clienteAliado.Estado_Cuenta__c='Activo';
        clienteAliado.Segmento__c='Empresas';
        clienteAliado.SubSegmento__c='sub seg';
        clienteAliado.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Aliado').getRecordTypeId();
        insert clienteAliado;
        
        CatalogoProductos__c cat = new CatalogoProductos__c();
        cat.Name = 'cattesteste';
        insert cat;
        
        Planes__c plan = new Planes__c();
        plan.Name = 'testplannplanaplan';
        plan.NombredelProducto__c = cat.Id;
        plan.TipodePlan__c = 'Principal';
        plan.Estado__c = 'Activa';
        insert plan;
        
        TOPP__c topp = new TOPP__c();        
        topp.Name ='topptestestest';
        topp.Plan__c = plan.Id;
        topp.AplicaPreventa__c = true;
        topp.Tipoderegistro__c='A1';
        topp.Activo__c=true;
        topp.Requiere_Numeracion__c=true;
        topp.Actualiza_Servicio_en_Gestor__c=true;
        insert topp;
        
        ActivoETB__c oActivo = new ActivoETB__c();
        oActivo.NombredelaCuenta__c = cliente.Id;
        insert oActivo;
        
        OperacionComercial__c oOperacionComercial = new OperacionComercial__c();
        oOperacionComercial.Planes_Convenio_Cupo__c='27000';
        oOperacionComercial.Valorunicavez__c=0.0;
        oOperacionComercial.Tarifa__c=0.0;
        oOperacionComercial.Margen_Soluciones_TI__c=0.0;
        oOperacionComercial.Duracion_Meses__c=10.0;
        oOperacionComercial.Duracion_Dias__c=2.0;
        oOperacionComercial.EnvSopVen__c=Datetime.now();
        oOperacionComercial.FechadeActivacion__c=Date.today();
        oOperacionComercial.Fecha_Final_Estado__c=Date.today();
        oOperacionComercial.EnvGteProy__c=Datetime.now();
        oOperacionComercial.ValorTarifaPlan__c=95492.24;
        oOperacionComercial.Estado__c='Activa';
        oOperacionComercial.Destinatario_Notificacion_Cambio_Estados__c='hbayona@avanxo.com';
        oOperacionComercial.Incidencia_en_ingresos__c='Incremento';
        oOperacionComercial.TipodeInternetSeguridadenlaNube__c='Internet +';
        oOperacionComercial.Categoria__c='LDN';
        oOperacionComercial.EnvioFacturacion__c=true;
        oOperacionComercial.Tipo_de_Conectividad__c='Remoto';
        oOperacionComercial.moneda__c=valoreGlobalesTest.get('OCmoneda__c');
        //oOperacionComercial.RangosDisponibilidad__c='xx';
        oOperacionComercial.CuentaCliente__c = cliente.Id;
        oOperacionComercial.TOPP__c = topp.Id;
        oOperacionComercial.Activo__c = oActivo.Id;
        oOperacionComercial.Estado__c = 'Facturado';
        oOperacionComercial.Fecha_Estado_Facturado__c = Date.Today().addMonths(-1);      
        insert oOperacionComercial;
        
        List<OperacionComercial__c> OC1 = [SELECT Id, name FROM OperacionComercial__c];
        // System.debug(':crearData: OC1:' + OC1);
        
        Viabilidad__c via = new Viabilidad__c();
        via.OperacionComercial__C = OC1[0].Id;
        insert via;
        List<Viabilidad__c> via1 = [SELECT Id, name FROM Viabilidad__c];
        // System.debug(':crearData: via1:' + via1);
        
        Opcion_Aprovisionamiento__c opcionAprovisionamiento = new Opcion_Aprovisionamiento__c();
        opcionAprovisionamiento.NumeroViabilidad__c = via1[0].Id;
        opcionAprovisionamiento.Operaci_n_Comercial__c = OC1[0].Id;
        opcionAprovisionamiento.IdOpcion__c = 'OPC001';
        opcionAprovisionamiento.Observaciones__c = 'Observaciones Opción';
        opcionAprovisionamiento.DetallesOpcion__c = 'Obra_Civil__c;valorparametro1;1|AliadoColaborador__c;valorparametroop2;1|Adquisiciondedominio__c;valorparametroop3;2|Adquisiciondedominio__c;valorparametroop3;3|';
        opcionAprovisionamiento.ConfiguracionServicio__c ='elementoitem1;referenciaitem1;2;descripcionitem1|elementoitem2;referenciaitem2;2;descripcionitem2|';
        insert opcionAprovisionamiento;
        
        List<Opcion_Aprovisionamiento__c> opc1 = [SELECT Id, name, NumeroViabilidad__c, Operaci_n_Comercial__c, IdOpcion__c,Observaciones__c  FROM Opcion_Aprovisionamiento__c];
        // System.debug(':crearData: opc1:' + opc1);

        Poblacion__c poblacionTest = new Poblacion__c(); 
        poblacionTest.Name = 'poblacionTest';
        poblacionTest.EsPais__c = true;
        poblacionTest.EsMunicipio__c = true;
        poblacionTest.EsDepartamento__c = true;
        insert poblacionTest;

        CuentaFacturacion__c cuentaTest = new CuentaFacturacion__c();
        cuentaTest.Ciudad__c = poblacionTest.Id;
        cuentaTest.LTE_Email__c = 'test@test.com';
        cuentaTest.Confirmacion_Email__c = 'test@test.com';
        cuentaTest.DirCorresp__c = 'poblacionTest.Id';
        cuentaTest.ContieneIMEI__c = true;
        cuentaTest.Cliente__c =cliente.Id;
        cuentaTest.IMEISCF__c = 'Fact-00238465: ref1 1234 #ref2 5678 #ref3 9012#ref1 1234 #ref2 5678 #ref3 9012#ref1 1234 #ref2 5678 #ref3 9012#ref1 1234 #ref2 5678 #ref3 9012#ref1 1234 #ref2 5678 #ref3 9012';
        insert cuentaTest;

        oOperacionComercial.CuentaFacturacion__c= cuentaTest.Id;
        update oOperacionComercial;

    }


    @IsTest
    static void ProcesarSolicitudTst()
    {
        crearData();
        List<CuentaFacturacion__c> cuenta = [SELECT Id, IMEISCF__c FROM CuentaFacturacion__c];

        Test.startTest();

         EnvioIMEICuentaFactura_cls.ProcesarSolicitud(cuenta);

        Test.stopTest();   
    }

    @IsTest
    static void BatchTest()
    {
        crearData();       

        Test.startTest();

        EnvioIMEICuentaFactura_bch obj = new EnvioIMEICuentaFactura_bch();
        DataBase.executeBatch(obj); 

        Test.stopTest();   
    }
    @isTest 
    static void ScheduleTest() {
        Test.startTest();
          String jobId = System.schedule('EnvioIMEICuentaFactura_bch','0 0 0 * * ? *',new EnvioIMEICuentaFactura_sch());
        Test.stopTest();
    }
    
}