/**
 * @description       : 
 * @author            : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
 * @group             : 
 * @last modified on  : 03-04-2022
 * @last modified by  : Miguel R. Gómez  miguel.rafael.gomez@accenture.com
**/
@isTest
private class Contratos_tst {
	static testMethod void myUnitTest() {
        
        Map<String,sObject> objx=objPruebas_tst.general();
        contract cotr=(Contract)objx.get('cotr').clone(false,false,false,false);
        cotr.Contrato_Relacionado__c=objx.get('cotr').id;
        cotr.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Anexo Colaborador').getRecordTypeId();
        cotr.Valor_fijo_o_variable__c = 'Fijo';
        cotr.StartDate = system.today();
        cotr.Valor_total_comprometido_conIVA_escritur__c = 1000000;
        cotr.Valor_total_comprometido__c = 500000;
        cotr.Valor_ejecutado_calculado_escritura__c = 200000;
        cotr.Facturado__c = 100000;
        cotr.Porcentaje_IVA__c = '19';
        cotr.ContractTerm = 1;         
        insert cotr;
        
        list<ReglasDesarrollos__c> listareglas = new list<ReglasDesarrollos__c>();
         ReglasDesarrollos__c reglas = new ReglasDesarrollos__c();
        reglas.Name='Legalizacion1';
        reglas.Activo__c=true;
        ReglasDesarrollos__c reglas1 = new ReglasDesarrollos__c();
        reglas1.Name='Legalizacion2';
        reglas1.Activo__c=true;
        ReglasDesarrollos__c reglas2 = new ReglasDesarrollos__c();
        reglas2.Name='Contratos1';
        reglas2.Activo__c=true;
        listareglas.add(reglas);
        listareglas.add(reglas1);
        listareglas.add(reglas2);
        insert listareglas;
        contratos_cls.recalcularContratosPadres(new set<id>{cotr.id});
        //   cotr.Status='Vigente';        
        //
        Adiciones_y_prorrogas_contratos__c adiCont = new Adiciones_y_prorrogas_contratos__c();
        adiCont.Valor_antes_de_IVA__c = 1000000;
        adiCont.Porcentaje_IVA__c = '19';
        adiCont.Contrato_relacionado__c = cotr.Id;
        adiCont.Prorroga_o_adicion__c = 'Adición';
        adiCont.Objeto__c = 'test';
        adiCont.Fecha_de_inicio__c = system.today();
        adiCont.Fecha_de_fin__c = system.today()+1;
        insert adiCont;
        //
        Conciliaciones_de_contrato__c concCont = new Conciliaciones_de_contrato__c();
        concCont.Numero_de_acta__c = '1';
        concCont.Valor_sin_IVA__c = 1000000;
        concCont.Porcentaje_IVA__c = '19';
        concCont.Contrato_relacionado__c = cotr.Id;
        concCont.Descripcion__c = 'Bienes';
        concCont.Fecha_del_acta__c = system.today();
        concCont.Facturado__c = 'SI';
        insert concCont;


        Legalizacion__c leg= new Legalizacion__c();
        leg.Contrato__c=cotr.id;
        insert leg;

        User u;       
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       // Insert account as current user
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name IN ('Standard User','Usuario estándar') LIMIT 1];
           
            u = new User(alias = 'jsmith', email='mgpoligrafia@gmail.com', 
                emailencodingkey='UTF-8', lastname='Smith', 
                languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, 
                timezonesidkey='America/Los_Angeles', 
                username='uniqueUserName@uniquw.com.co');
            insert u;          
        }

        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='Numeracion10Digitos',Valor__c='Falso'));
       /* vg.add(new Perfiles_Reglas_OC__c(Name='Escenario01',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario02',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario03',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario04',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario05',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario06',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario07',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        */vg.add(new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'));
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
        cliente.Segmento__c='MiPymes';
        cliente.SubSegmento__c='Pequeña';
        cliente.Owner = u;
        insert cliente;
        
        CatalogoProductos__c cat = new CatalogoProductos__c();
        cat.Name = 'Cobro revertido automatico';    
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
        topp.TipodeOperacionporplan__c = 'Venta' ;
        insert topp;
        
        ActivoETB__c oActivo = new ActivoETB__c();
        oActivo.NombredelaCuenta__c = cliente.Id;
        oActivo.NumeroConexion__c = '1';
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
        // oOperacionComercial.moneda__c=valoreGlobalesTest.get('OCmoneda__c');
        //oOperacionComercial.RangosDisponibilidad__c='xx';
        oOperacionComercial.CuentaCliente__c = cliente.Id;
        oOperacionComercial.TOPP__c = topp.Id;
        oOperacionComercial.Activo__c = oActivo.Id;
        //oOperacionComercial.Activo_Relacionado__c = oActivoRelacionado.Id;
        oOperacionComercial.Estado__c = 'Facturado';
        oOperacionComercial.Fecha_Estado_Facturado__c = Date.Today().addMonths(-1);  
        oOperacionComercial.Enrutamientos__c = '4';
        oOperacionComercial.Plan__c = plan.Id;
        oOperacionComercial.Valorunicavez__c = 1;
        oOperacionComercial.Legalizacion__c = leg.Id;
        insert oOperacionComercial;

        // List<OperacionComercial__c> OC1 = [SELECT Id, name FROM OperacionComercial__c];
        // System.debug(':crearData: OC1:' + OC1);
        
        Viabilidad__c via = new Viabilidad__c();
        via.OperacionComercial__C = oOperacionComercial.Id;
        via.Respuestadeviabilidad__c = 'Viable' ;
        insert via;


        //
        contratos_cls contractClass = new contratos_cls();
        Map<Id,Contract> mapContract = new Map<Id,Contract>();
        mapContract.put(cotr.Id, cotr);       
        contractClass.validarCamposContratoActivo(mapContract,mapContract);
        contractClass.ValidacionPerfil('ValidacionesContrato'); 
        contractClass.promediarMeses(1);
        //
                try{
                
                System.Debug('antes update');
                cotr.ContractTerm = 15; 
                cotr.Renovacion_Automatica__c = false;
                update cotr;               
                System.Debug('2 pasó segundo update');
                }
                catch(system.Exception e)
                {    
                        System.Debug('entró Excepción Upadte'+ e);    	
                }
	}
    
    static testMethod void myUnitTest2() {
        
        Map<String,sObject> objx=objPruebas_tst.general();
        contract cotr=(Contract)objx.get('cotr').clone(false,false,false,false);
        cotr.Contrato_Relacionado__c=objx.get('cotr').id;
        cotr.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Anexo Colaborador').getRecordTypeId();
        cotr.Valor_fijo_o_variable__c = 'Fijo';
        cotr.StartDate = system.today();
        cotr.Valor_total_comprometido_conIVA_escritur__c = 1000000;
        cotr.Valor_total_comprometido__c = 500000;
        cotr.Valor_ejecutado_calculado_escritura__c = 200000;
        cotr.Facturado__c = 100000;
        cotr.Porcentaje_IVA__c = '19';
        cotr.ContractTerm = 1;         
        insert cotr;
        
        list<ReglasDesarrollos__c> listareglas = new list<ReglasDesarrollos__c>();
         ReglasDesarrollos__c reglas = new ReglasDesarrollos__c();
        reglas.Name='Legalizacion1';
        reglas.Activo__c=true;
        ReglasDesarrollos__c reglas1 = new ReglasDesarrollos__c();
        reglas1.Name='Legalizacion2';
        reglas1.Activo__c=true;
        ReglasDesarrollos__c reglas2 = new ReglasDesarrollos__c();
        reglas2.Name='Contratos1';
        reglas2.Activo__c=true;
        listareglas.add(reglas);
        listareglas.add(reglas1);
        listareglas.add(reglas2);
        insert listareglas;
        contratos_cls.recalcularContratosPadres(new set<id>{cotr.id});
        //   cotr.Status='Vigente';        
        //
        Adiciones_y_prorrogas_contratos__c adiCont = new Adiciones_y_prorrogas_contratos__c();
        adiCont.Valor_antes_de_IVA__c = 1000000;
        adiCont.Porcentaje_IVA__c = '19';
        adiCont.Contrato_relacionado__c = cotr.Id;
        adiCont.Prorroga_o_adicion__c = 'Adición';
        adiCont.Objeto__c = 'test';
        adiCont.Fecha_de_inicio__c = system.today();
        adiCont.Fecha_de_fin__c = system.today()+1;
        insert adiCont;
        //
        Conciliaciones_de_contrato__c concCont = new Conciliaciones_de_contrato__c();
        concCont.Numero_de_acta__c = '1';
        concCont.Valor_sin_IVA__c = 1000000;
        concCont.Porcentaje_IVA__c = '19';
        concCont.Contrato_relacionado__c = cotr.Id;
        concCont.Descripcion__c = 'Bienes';
        concCont.Fecha_del_acta__c = system.today();
        concCont.Facturado__c = 'SI';
        insert concCont;


        Legalizacion__c leg= new Legalizacion__c();
        leg.Contrato__c=cotr.id;
        insert leg;

        User u;       
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       // Insert account as current user
        System.runAs (thisUser) {
            Profile p = [SELECT Id FROM Profile WHERE Name IN ('Standard User','Usuario estándar') LIMIT 1];
           
            u = new User(alias = 'jsmith', email='mgpoligrafia@gmail.com', 
                emailencodingkey='UTF-8', lastname='Smith', 
                languagelocalekey='en_US', 
                localesidkey='en_US', profileid = p.Id, 
                timezonesidkey='America/Los_Angeles', 
                username='uniqueUserName@uniquw.com.co');
            insert u;          
        }

        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='Numeracion10Digitos',Valor__c='Falso'));
       /* vg.add(new Perfiles_Reglas_OC__c(Name='Escenario01',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario02',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario03',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario04',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario05',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario06',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario07',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        vg.add(new Perfiles_Reglas_OC__c(Name='Escenario08',Perfiles__c = '00e400000014GBIAA2',Detalles__c = 'en estado activa o declinada',Desactivar__c=true));
        */vg.add(new LTE_APN__c(Name = 'TiposAPN', Valor__c = 'APN Datos UM Principal (Sede Fija)', Tipo__c = 'Variable'));
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
        cliente.Segmento__c='MiPymes';
        cliente.SubSegmento__c='Pequeña';
        cliente.Owner = u;
        insert cliente;
        
        CatalogoProductos__c cat = new CatalogoProductos__c();
        cat.Name = 'Cobro revertido automatico';    
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
        topp.TipodeOperacionporplan__c = 'Venta' ;
        insert topp;
        
        ActivoETB__c oActivo = new ActivoETB__c();
        oActivo.NombredelaCuenta__c = cliente.Id;
        oActivo.NumeroConexion__c = '1';
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
        // oOperacionComercial.moneda__c=valoreGlobalesTest.get('OCmoneda__c');
        //oOperacionComercial.RangosDisponibilidad__c='xx';
        oOperacionComercial.CuentaCliente__c = cliente.Id;
        oOperacionComercial.TOPP__c = topp.Id;
        oOperacionComercial.Activo__c = oActivo.Id;
        //oOperacionComercial.Activo_Relacionado__c = oActivoRelacionado.Id;
        oOperacionComercial.Estado__c = 'Facturado';
        oOperacionComercial.Fecha_Estado_Facturado__c = Date.Today().addMonths(-1);  
        oOperacionComercial.Enrutamientos__c = '4';
        oOperacionComercial.Plan__c = plan.Id;
        oOperacionComercial.Valorunicavez__c = 1;
        oOperacionComercial.Legalizacion__c = leg.Id;
        insert oOperacionComercial;

        // List<OperacionComercial__c> OC1 = [SELECT Id, name FROM OperacionComercial__c];
        // System.debug(':crearData: OC1:' + OC1);
        
        Viabilidad__c via = new Viabilidad__c();
        via.OperacionComercial__C = oOperacionComercial.Id;
        via.Respuestadeviabilidad__c = 'Viable' ;
        insert via;


        //
        contratos_cls contractClass = new contratos_cls();
        Map<Id,Contract> mapContract = new Map<Id,Contract>();
        mapContract.put(cotr.Id, cotr);       
        contractClass.validarCamposContratoActivo(mapContract,mapContract);
        contractClass.ValidacionPerfil('ValidacionesContrato'); 
        contractClass.promediarMeses(1);
        //
                try{
                
                System.Debug('antes update');
                cotr.ContractTerm = 15; 
                cotr.Renovacion_Automatica__c = true;
                update cotr;
                System.Debug('2 pasó segundo update');
                }
                catch(system.Exception e)
                {    
                        System.Debug('entró Excepción Upadte'+ e);    	
                }
	}
}