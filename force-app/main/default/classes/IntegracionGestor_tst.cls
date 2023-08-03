/***********************************************************************************************************************
Desarrollado por:   ETB
Proyecto:           PORTAFOLIO SUPERIOR
Descripción:        Clase de prueba para la implementación que expone los servicios y los métodos de integración con el Gestor

Cambios (Versiones)
-------------------------------------------------------------------
No.     Fecha        Autor                    Descripción
----    ----------   ----------------------   ---------------
1.0     2018-04-15   Samuel Rodríguez (ETB)   Creación de la clase.
***********************************************************************************************************************/
@isTest
public class IntegracionGestor_tst {
    
    public static Map<string,string> variablesTest=new Map<string,string>();
    public static Map<string,list<sobject>> variablesObj=new Map<string,list<sobject>>();
    public static boolean conf=false;
    public static Map<string,string> valoreGlobalesTest =new Map<string,string>();
    
    /* static testMethod void IniciarDatosTest() {
crearData();
}*/
    
     @testSetup static void crearData()
    // public static void crearData()
     {
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
        topp.TipodeOperacionporplan__c='Cambio de Suscriptor Nuevo';
        insert topp;
        
        ActivoETB__c oActivo = new ActivoETB__c();
        oActivo.NombredelaCuenta__c = cliente.Id;
        insert oActivo;
        
        Numero__c num = new Numero__c();
        num.Name = '12321';
        num.Tipo_Numero_Abreviado__c = 'ABB';
        insert num;
        
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
        oOperacionComercial.RecordTypeId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Numeración Abreviada').getRecordTypeId();
        oOperacionComercial.Numero_Abreviado__c = num.Id;
        insert oOperacionComercial;
        
        OperacionComercial__c oOperacionComercial1 = new OperacionComercial__c();
        oOperacionComercial1.Planes_Convenio_Cupo__c='27000';
        oOperacionComercial1.Valorunicavez__c=0.0;
        oOperacionComercial1.Tarifa__c=0.0;
        oOperacionComercial1.Margen_Soluciones_TI__c=0.0;
        oOperacionComercial1.Duracion_Meses__c=10.0;
        oOperacionComercial1.Duracion_Dias__c=2.0;
        oOperacionComercial1.EnvSopVen__c=Datetime.now();
        oOperacionComercial1.FechadeActivacion__c=Date.today();
        oOperacionComercial1.Fecha_Final_Estado__c=Date.today();
        oOperacionComercial1.EnvGteProy__c=Datetime.now();
        oOperacionComercial1.ValorTarifaPlan__c=95492.24;
        oOperacionComercial1.Estado__c='Activa';
        oOperacionComercial1.Destinatario_Notificacion_Cambio_Estados__c='hbayona@avanxo.com';
        oOperacionComercial1.Incidencia_en_ingresos__c='Incremento';
        oOperacionComercial1.TipodeInternetSeguridadenlaNube__c='Internet +';
        oOperacionComercial1.Categoria__c='LDN';
        oOperacionComercial1.EnvioFacturacion__c=true;
        oOperacionComercial1.Tipo_de_Conectividad__c='Remoto';
        oOperacionComercial1.moneda__c=valoreGlobalesTest.get('OCmoneda__c');
        //oOperacionComercial.RangosDisponibilidad__c='xx';
        oOperacionComercial1.CuentaCliente__c = cliente.Id;
        oOperacionComercial1.TOPP__c = topp.Id;
        oOperacionComercial1.Activo__c = oActivo.Id;
        insert oOperacionComercial1;
        
        oOperacionComercial.Operacion_Comercial_Relacionada__c = oOperacionComercial1.Id;
        update oOperacionComercial;
        
        List<OperacionComercial__c> OC1 = [SELECT Id, name FROM OperacionComercial__c];
        System.debug(':crearData: OC1:' + OC1);
        
        Account clientePrincipal = new Account();
        clientePrincipal.Name ='SERGIO ALFONSO GUTIÉRREZ - ALIADO';
        clientePrincipal.RazonSocial__c='ETB ALIADO';
        clientePrincipal.Tipodedocumento__c= 'NIT';
        clientePrincipal.AccountNumber = '823698523';
        clientePrincipal.Phone = '12345678';
        clientePrincipal.Direccion__c='CRA 7 No. 20 37';
        clientePrincipal.Description='Description';
        clientePrincipal.Estado_Cuenta__c='Activo';
        clientePrincipal.Segmento__c='Empresas';
        clientePrincipal.SubSegmento__c='sub seg';
        clientePrincipal.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Principal').getRecordTypeId();
        insert clientePrincipal;
        
        /*Opportunity oportunidad = new Opportunity();
        oportunidad.AccountId = clientePrincipal.Id;
        oportunidad.Name = 'op Name';
        oportunidad.StageName = 'Presentada';
        oportunidad.CloseDate = System.Today().AddDays(-10);
        insert oportunidad;*/
        
        Viabilidad__c via = new Viabilidad__c();
        via.OperacionComercial__C = OC1[0].Id;
       // via.Oportunidad__c = oportunidad.Id;
        insert via;
        List<Viabilidad__c> via1 = [SELECT Id, name FROM Viabilidad__c];
        System.debug(':crearData: via1:' + via1);
        
        Opcion_Aprovisionamiento__c opcionAprovisionamiento = new Opcion_Aprovisionamiento__c();
        opcionAprovisionamiento.NumeroViabilidad__c = via1[0].Id;
        opcionAprovisionamiento.Operaci_n_Comercial__c = OC1[0].Id;
        opcionAprovisionamiento.IdOpcion__c = 'OPC001';
        opcionAprovisionamiento.Observaciones__c = 'Observaciones Opción';
        opcionAprovisionamiento.DetallesOpcion__c = 'Obra_Civil__c;valorparametro1;1|AliadoColaborador__c;valorparametroop2;1|Adquisiciondedominio__c;valorparametroop3;2|Adquisiciondedominio__c;valorparametroop3;3|';
        opcionAprovisionamiento.ConfiguracionServicio__c ='elementoitem1;referenciaitem1;2;descripcionitem1|elementoitem2;referenciaitem2;2;descripcionitem2|';
        insert opcionAprovisionamiento;
        
        List<Opcion_Aprovisionamiento__c> opc1 = [SELECT Id, name, NumeroViabilidad__c, Operaci_n_Comercial__c, IdOpcion__c,Observaciones__c  FROM Opcion_Aprovisionamiento__c];
        System.debug(':crearData: opc1:' + opc1);
        
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
    
    static testMethod void WSRespuestaViabilidadTest() {
        
        //crearData();
        List<Viabilidad__c> via2 = [SELECT Id, name FROM Viabilidad__c];
        List<Account> acc = [SELECT Id, name FROM Account WHERE NAME = 'SERGIO ALFONSO GUTIÉRREZ - ALIADO'];
        System.debug('Esta es la viabilidad WSRespuestaViabilidadTest:' + via2);
        System.debug('Esta es la acc WSRespuestaViabilidadTest:' + acc);
        
        Test.startTest();
        // Transaccion
        IntegracionGestor_ws.Parametro parametro = new IntegracionGestor_ws.Parametro();
        parametro.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametro.valor = 'CiscoViptela';
        IntegracionGestor_ws.DetalleTransaccion detalleTransaccion = new IntegracionGestor_ws.DetalleTransaccion();
        detalleTransaccion.parametro.add(parametro);
        IntegracionGestor_ws.Transaccion transaccion = new IntegracionGestor_ws.Transaccion();
        transaccion.detalleTransaccion = detalleTransaccion;
        transaccion.fechaProcesamiento ='16/05/2018';
        transaccion.idTransaccion='ResVia001';
        transaccion.nombreSistema='Gestor';
        transaccion.tipoTransaccion='RespuestaViabilidad';
        
        //
        IntegracionGestor_ws.DetallesViabilidad detallesViabilidad = new IntegracionGestor_ws.DetallesViabilidad();
        detallesViabilidad.parametro.add(parametro);
        IntegracionGestor_ws.Item item = new IntegracionGestor_ws.Item();
        item.cantidad ='3';
        item.descripcion ='descripcionitem1';
        item.elemento ='elementoitem1';
        item.referencia='referenciaitem1';
        IntegracionGestor_ws.ConfiguracionServicio configuracionServicio = new IntegracionGestor_ws.ConfiguracionServicio();
        configuracionServicio.item.add(item);
        IntegracionGestor_ws.ParametroOp parametroOp = new IntegracionGestor_ws.ParametroOp();
        parametroOp.fila ='1';
        parametroOP.nombre='Obra_Civil__c';
        parametroOp.valor='valorparametro1';
        IntegracionGestor_ws.ParametroOp parametroOp2 = new IntegracionGestor_ws.ParametroOp();
        parametroOp2.fila ='2';
        parametroOP2.nombre='AliadoColaborador__c';
        parametroOp2.valor=acc[0].Name;
        IntegracionGestor_ws.DetalleOpcion detalleOpcion = new IntegracionGestor_ws.DetalleOpcion();
        detalleOpcion.parametroOp.add(parametroOp);
        detalleOpcion.parametroOp.add(parametroOp2);
        IntegracionGestor_ws.Opcion opcion = new IntegracionGestor_ws.Opcion();
        opcion.configuracionServicio = configuracionServicio;
        opcion.detalleOpcion = detalleOpcion;
        opcion.idOpcion='OPC01';
        opcion.observaciones='Observaciones de la opción 1';
        IntegracionGestor_ws.OpcionesViabilidad opcionesViabilidad = new  IntegracionGestor_ws.OpcionesViabilidad();
        opcionesViabilidad.opcion.add(opcion);
        
        IntegracionGestor_ws.URLs URLs = new IntegracionGestor_ws.URLs();
        IntegracionGestor_ws.Parametro parametroURL = new IntegracionGestor_ws.Parametro();
        parametroURL.nombre = 'Archivo diseño';
        parametroURL.valor = 'http://104.40.50.130:86/Portafolio_Superior/Base/DescargarAdjuntoSalesForce?idA=5aeb34b0929c50302028dda4&idS=OC-654184&tS=Viabilidad&t=c0b962882f8e4095b0f11e1f8ec07e06';
        URLs.parametro.add(parametroURL);
        IntegracionGestor_ws.RespuestaViabilidad respuestaViabilidad = new IntegracionGestor_ws.RespuestaViabilidad();
        respuestaViabilidad.aliado=acc[0].Name;//'ALIADO PRUEBA';
        respuestaViabilidad.causal='';
        respuestaViabilidad.detallesViabilidad = detallesViabilidad;
        respuestaViabilidad.estadoViabilidad='Estado viabilidad';
        respuestaViabilidad.grupoAsignacion='Grupo Asignado';
        respuestaViabilidad.numeroViabilidad=via2[0].Name;//'VIA-128074';
        respuestaViabilidad.opcionesViabilidad = opcionesViabilidad;
        respuestaViabilidad.responsable='Responsable';
        respuestaViabilidad.respuesta='Respuesta';
        respuestaViabilidad.respuestaViabilidad='Viable';
        respuestaViabilidad.tipoAliado='Colaborador';
        respuestaViabilidad.tipoViabilidad='Por Cobertura';
        respuestaViabilidad.URLs = URLs;      
        respuestaViabilidad.causal=via2[0].name;
        
        
        IntegracionGestor_ws.MsgEntradaResVia msgEntradaResVia = new  IntegracionGestor_ws.MsgEntradaResVia();
        msgEntradaResVia.respuestaViabilidad = respuestaViabilidad;
        msgEntradaResVia.transaccion = transaccion;
        
        IntegracionGestor_ws.WSRespuestaViabilidad(msgEntradaResVia);
        /*IntegracionGestor_cls.RespuestaViabilidadImp(msgEntradaResVia);*/
       
        System.debug('msgEntradaResVia WSRespuestaViabilidadTest :' + msgEntradaResVia);
      
         //msgEntradaResVia.respuestaViabilidad = respuestaViabilidad;
        // IntegracionGestor_cls.RespuestaViabilidadImp(msgEntradaResVia);
          List<Viabilidad__c> via3 = [SELECT Id, name FROM Viabilidad__c];
        System.debug('Esta es la viabilidad via3 WSRespuestaViabilidadTest:' + via3);
        
        
        List<Opcion_Aprovisionamiento__c> listaOPC = [SELECT id, IdOpcion__c, ConfiguracionServicio__c, DetallesOpcion__c, Observaciones__c, Seleccion__c FROM Opcion_Aprovisionamiento__c];
        System.debug('Esta es la listaOPC WSRespuestaViabilidadTest: ' + listaOPC);
        
        IntegracionGestor_ws.OpcionesViabilidad opcionesViabilidad1 = new IntegracionGestor_ws.OpcionesViabilidad();
        opcionesViabilidad1 = IntegracionGestor_cls.ObtenerOpcionesViaclass(listaOPC);
        System.debug('Esta es la opcionesViabilidad1 WSRespuestaViabilidadTest:' + opcionesViabilidad1);
        IntegracionGestor_ws.Opcion opc = new IntegracionGestor_ws.Opcion();
         IntegracionGestor_cls.ActualizarViabilidadResVia(via3[0], msgEntradaResVia);
        
        
        //Opcion = IntegracionGestor_cls.ObtenerOpcionclass(listaOPC[0]);
          
        Test.stopTest();
    }
    
    static testMethod void WSActualizarGrupoPropietarioTest() {
        
       // crearData();
        List<Viabilidad__c> via2 = [SELECT Id, name FROM Viabilidad__c];
        System.debug('Esta es la viabilidad:' + via2);
        List<OperacionComercial__c> OC2 = [SELECT Id, name FROM OperacionComercial__c];
        System.debug('Esta es la OC2:' + OC2);
        
        Test.startTest();
        // Transaccion
        IntegracionGestor_ws.Parametro parametro = new IntegracionGestor_ws.Parametro();
        parametro.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametro.valor = 'CiscoViptela';
        IntegracionGestor_ws.DetalleTransaccion detalleTransaccion = new IntegracionGestor_ws.DetalleTransaccion();
        detalleTransaccion.parametro.add(parametro);
        IntegracionGestor_ws.Transaccion transaccion = new IntegracionGestor_ws.Transaccion();
        transaccion.detalleTransaccion = detalleTransaccion;
        transaccion.fechaProcesamiento ='16/05/2018';
        transaccion.idTransaccion='ActGPro001';
        transaccion.nombreSistema='Gestor';
        transaccion.tipoTransaccion='ActualizarGrupoPropietario';
        
        //actualizarGrupoPropietario
        
        IntegracionGestor_ws.Parametro parametrogp = new IntegracionGestor_ws.Parametro();
        parametrogp.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametrogp.valor = 'CiscoViptela';
        
        IntegracionGestor_ws.DetallesActualizarGrupoPropietario detallesActualizarGrupoPropietario = new IntegracionGestor_ws.DetallesActualizarGrupoPropietario();
        detallesActualizarGrupoPropietario.parametro.add(parametrogp);
        
        IntegracionGestor_ws.ActualizarGrupoPropietario actualizarGrupoPropietario = new IntegracionGestor_ws.ActualizarGrupoPropietario();
        actualizarGrupoPropietario.detallesActualizarGrupoPropietario = detallesActualizarGrupoPropietario;
        actualizarGrupoPropietario.grupoAsignacion = 'Grupo Asignado';
        actualizarGrupoPropietario.numeroOC = OC2[0].Name;//'OC-654170';
        actualizarGrupoPropietario.numeroViabilidad = via2[0].Name;//'VIA-128074';
        actualizarGrupoPropietario.responsable = 'SERGIO ALFONSO GUTIÉRREZ';
        actualizarGrupoPropietario.tipoSolicitud = 'Aprovisionamiento';
        
        
        IntegracionGestor_ws.MsgEntradaActGrupoPropietario msgEntradaActGrupoPropietario = new IntegracionGestor_ws.MsgEntradaActGrupoPropietario();
        msgEntradaActGrupoPropietario.actualizarGrupoPropietario = actualizarGrupoPropietario;
        msgEntradaActGrupoPropietario.transaccion = transaccion;
        
        IntegracionGestor_ws.WSActualizarGrupoPropietario(msgEntradaActGrupoPropietario);
        Test.stopTest();
    }
    
    static testMethod void WSActualizarGrupoPropietarioTest1() {
        
        //crearData();
        List<Viabilidad__c> via2 = [SELECT Id, name FROM Viabilidad__c];
        System.debug('Esta es la viabilidad:' + via2);
        List<OperacionComercial__c> OC2 = [SELECT Id, name FROM OperacionComercial__c];
        System.debug('Esta es la OC2:' + OC2);
        
        Test.startTest();
        // Transaccion
        IntegracionGestor_ws.Parametro parametro = new IntegracionGestor_ws.Parametro();
        parametro.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametro.valor = 'CiscoViptela';
        IntegracionGestor_ws.DetalleTransaccion detalleTransaccion = new IntegracionGestor_ws.DetalleTransaccion();
        detalleTransaccion.parametro.add(parametro);
        IntegracionGestor_ws.Transaccion transaccion = new IntegracionGestor_ws.Transaccion();
        transaccion.detalleTransaccion = detalleTransaccion;
        transaccion.fechaProcesamiento ='16/05/2018';
        transaccion.idTransaccion='ActGPro001';
        transaccion.nombreSistema='Gestor';
        transaccion.tipoTransaccion='ActualizarGrupoPropietario';
        
        //actualizarGrupoPropietario
        
        IntegracionGestor_ws.Parametro parametrogp = new IntegracionGestor_ws.Parametro();
        parametrogp.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametrogp.valor = 'CiscoViptela';
        
        IntegracionGestor_ws.DetallesActualizarGrupoPropietario detallesActualizarGrupoPropietario = new IntegracionGestor_ws.DetallesActualizarGrupoPropietario();
        detallesActualizarGrupoPropietario.parametro.add(parametrogp);
        
        IntegracionGestor_ws.ActualizarGrupoPropietario actualizarGrupoPropietario = new IntegracionGestor_ws.ActualizarGrupoPropietario();
        actualizarGrupoPropietario.detallesActualizarGrupoPropietario = detallesActualizarGrupoPropietario;
        actualizarGrupoPropietario.grupoAsignacion = 'Grupo Asignado';
        actualizarGrupoPropietario.numeroOC = OC2[0].Name;//'OC-654170';
        actualizarGrupoPropietario.numeroViabilidad = via2[0].Name;//'VIA-128074';
        actualizarGrupoPropietario.responsable = 'SERGIO ALFONSO GUTIÉRREZ';
        actualizarGrupoPropietario.tipoSolicitud = 'Viabilidad';
        
        
        IntegracionGestor_ws.MsgEntradaActGrupoPropietario msgEntradaActGrupoPropietario = new IntegracionGestor_ws.MsgEntradaActGrupoPropietario();
        msgEntradaActGrupoPropietario.actualizarGrupoPropietario = actualizarGrupoPropietario;
        msgEntradaActGrupoPropietario.transaccion = transaccion;
        
        IntegracionGestor_ws.WSActualizarGrupoPropietario(msgEntradaActGrupoPropietario);
        Test.stopTest();
    }
    
    static testMethod void WSActualizarGrupoPropietarioTest1NOK() {
        
        //crearData();
        List<Viabilidad__c> via2 = [SELECT Id, name FROM Viabilidad__c];
        System.debug('Esta es la viabilidad:' + via2);
        List<OperacionComercial__c> OC2 = [SELECT Id, name FROM OperacionComercial__c];
        System.debug('Esta es la OC2:' + OC2);
        
        Test.startTest();
        // Transaccion
        IntegracionGestor_ws.Parametro parametro = new IntegracionGestor_ws.Parametro();
        parametro.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametro.valor = 'CiscoViptela';
        IntegracionGestor_ws.DetalleTransaccion detalleTransaccion = new IntegracionGestor_ws.DetalleTransaccion();
        detalleTransaccion.parametro.add(parametro);
        IntegracionGestor_ws.Transaccion transaccion = new IntegracionGestor_ws.Transaccion();
        transaccion.detalleTransaccion = detalleTransaccion;
        transaccion.fechaProcesamiento ='16/05/2018';
        transaccion.idTransaccion='ActGPro001';
        transaccion.nombreSistema='Gestor';
        transaccion.tipoTransaccion='ActualizarGrupoPropietario';
        
        //actualizarGrupoPropietario
        
        IntegracionGestor_ws.Parametro parametrogp = new IntegracionGestor_ws.Parametro();
        parametrogp.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametrogp.valor = 'CiscoViptela';
        
        IntegracionGestor_ws.DetallesActualizarGrupoPropietario detallesActualizarGrupoPropietario = new IntegracionGestor_ws.DetallesActualizarGrupoPropietario();
        detallesActualizarGrupoPropietario.parametro.add(parametrogp);
        
        IntegracionGestor_ws.ActualizarGrupoPropietario actualizarGrupoPropietario = new IntegracionGestor_ws.ActualizarGrupoPropietario();
        actualizarGrupoPropietario.detallesActualizarGrupoPropietario = detallesActualizarGrupoPropietario;
        actualizarGrupoPropietario.grupoAsignacion = 'Grupo Asignado';
        actualizarGrupoPropietario.numeroOC = OC2[0].Name;//'OC-654170';
        actualizarGrupoPropietario.numeroViabilidad = via2[0].Name;//'VIA-128074';
        actualizarGrupoPropietario.responsable = 'SERGIO ALFONSO GUTIÉRREZ';
        actualizarGrupoPropietario.tipoSolicitud = 'Viabilidad Negocio';
        
        
        IntegracionGestor_ws.MsgEntradaActGrupoPropietario msgEntradaActGrupoPropietario = new IntegracionGestor_ws.MsgEntradaActGrupoPropietario();
        msgEntradaActGrupoPropietario.actualizarGrupoPropietario = actualizarGrupoPropietario;
        msgEntradaActGrupoPropietario.transaccion = transaccion;
        
        IntegracionGestor_ws.WSActualizarGrupoPropietario(msgEntradaActGrupoPropietario);
        Test.stopTest();
    }
    
    static testMethod void WSIniciarFacturacionTest() {
        
        //crearData();
        
        Linea__c sglLinea = new Linea__c(Name='32902699',Codigo_de_linea__c='32902699',Linea_ETB__c='ETB Movil');
        insert sglLinea;
        List<OperacionComercial__c> OC2 = [SELECT Id, name FROM OperacionComercial__c];
        System.debug('Esta es la OC2:' + OC2);
        Lineas_OC__c sglLineaOC = new Lineas_OC__c(Operacion_Comercial__c = OC2[0].Id,Linea__c=sglLinea.Id,Accion__c='Adicionar');
        insert sglLineaOC;
        
        Test.startTest();
        // Transaccion
        IntegracionGestor_ws.Parametro parametro = new IntegracionGestor_ws.Parametro();
        parametro.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametro.valor = 'CiscoViptela';
        IntegracionGestor_ws.DetalleTransaccion detalleTransaccion = new IntegracionGestor_ws.DetalleTransaccion();
        detalleTransaccion.parametro.add(parametro);
        IntegracionGestor_ws.Transaccion transaccion = new IntegracionGestor_ws.Transaccion();
        transaccion.detalleTransaccion = detalleTransaccion;
        transaccion.fechaProcesamiento ='16/05/2018';
        transaccion.idTransaccion='Inifac001';
        transaccion.nombreSistema='Gestor';
        transaccion.tipoTransaccion='IniciarFacturacion';
        
        //inicioFacturacion
        IntegracionGestor_ws.Parametro parametroif = new IntegracionGestor_ws.Parametro();
        parametroif.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametroif.valor = 'CiscoViptela';  
        IntegracionGestor_ws.Parametro parametroif2 = new IntegracionGestor_ws.Parametro();
        parametroif2.nombre = 'RANGO NUMERACION';
        parametroif2.valor = 'ADD:32902650-32902660;32902662;32902664-32902699;';    
        
        IntegracionGestor_ws.DetallesInicioFacturacion detallesInicioFacturacion = new IntegracionGestor_ws.DetallesInicioFacturacion();
        detallesInicioFacturacion.parametro.add(parametroif);
        detallesInicioFacturacion.parametro.add(parametroif2);
        
        IntegracionGestor_ws.InicioFacturacion inicioFacturacion = new IntegracionGestor_ws.InicioFacturacion();
        inicioFacturacion.detallesInicioFacturacion = detallesInicioFacturacion;
        inicioFacturacion.estado = 'Activa';
        inicioFacturacion.fechaInicioFacturacion = '27/09/2020';
        inicioFacturacion.grupoAsignacion = 'Grupo Asignado';
        inicioFacturacion.IDServicio = 'IDS000001';
        inicioFacturacion.numeroOC = OC2[0].Name;//'OC-654170';
        inicioFacturacion.responsable = 'SERGIO ALFONSO GUTIÉRREZ';
        
        IntegracionGestor_ws.MsgEntradaInicioFacturacion msgEntradaInicioFacturacion = new IntegracionGestor_ws.MsgEntradaInicioFacturacion();
        msgEntradaInicioFacturacion.inicioFacturacion = inicioFacturacion;
        msgEntradaInicioFacturacion.transaccion = transaccion;
        
        IntegracionGestor_ws.WSIniciarFacturacion(MsgEntradaInicioFacturacion);
        Test.stopTest();
    }
    
    static testMethod void WSSincronizarLineaTest() {
        
        //crearData();
        List<OperacionComercial__c> OC2 = [SELECT Id, name FROM OperacionComercial__c];
        
        Test.startTest();
        IntegracionGestor_ws.Transaccion transaccion = new IntegracionGestor_ws.Transaccion();
        transaccion.detalleTransaccion = new IntegracionGestor_ws.DetalleTransaccion();
        transaccion.fechaProcesamiento ='16/05/2018';
        transaccion.idTransaccion='Inifac001';
        transaccion.nombreSistema='Gestor';
        transaccion.tipoTransaccion='IniciarFacturacion';
        
        IntegracionGestor_ws.Linea sglLinea = new IntegracionGestor_ws.Linea();
        sglLinea.Accion = 'Adicion';
        sglLinea.Estado = 'Ocupada';
        sglLinea.Numero = '3057000482';
        sglLinea.ExternalId = '3057000482';
        sglLinea.TipoLinea = 'ETB';
        
        List<IntegracionGestor_ws.Linea> lstLineas = new List<IntegracionGestor_ws.Linea>();
        lstLineas.add(sglLinea);
        
        IntegracionGestor_ws.Lineas objLineas = new IntegracionGestor_ws.Lineas();
        objLineas.linea = lstLineas;
        
        IntegracionGestor_ws.SincronizacionLineas objSincLinea = new IntegracionGestor_ws.SincronizacionLineas();
        objSincLinea.numeroOC = OC2[0].Name;
        objSincLinea.lineas = objLineas;
        
        IntegracionGestor_ws.MsgEntradaSincronizacionLineas entSincronizacionLinea = new IntegracionGestor_ws.MsgEntradaSincronizacionLineas();
        entSincronizacionLinea.transaccion = transaccion;
        entSincronizacionLinea.sincronizacionLinea = objSincLinea;
        
        IntegracionGestor_ws.WSSincronizarLinea(entSincronizacionLinea);
        Test.stopTest();
    }
    
    static testMethod void WSActualizarEstadoOCTest() {
        
       // crearData();
        List<Viabilidad__c> via2 = [SELECT Id, name FROM Viabilidad__c];
        System.debug('Esta es la viabilidad:' + via2);
        List<OperacionComercial__c> OC2 = [SELECT Id, name FROM OperacionComercial__c];
        System.debug('Esta es la OC2:' + OC2);
        
        
        Test.startTest();
        // Transaccion
        IntegracionGestor_ws.Parametro parametro = new IntegracionGestor_ws.Parametro();
        parametro.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametro.valor = 'CiscoViptela';
        IntegracionGestor_ws.DetalleTransaccion detalleTransaccion = new IntegracionGestor_ws.DetalleTransaccion();
        detalleTransaccion.parametro.add(parametro);
        IntegracionGestor_ws.Parametro parametro1 = new IntegracionGestor_ws.Parametro();
        parametro1.nombre = 'IMEIS';
        parametro1.valor = '1236549876546532';       
        detalleTransaccion.parametro.add(parametro1);
        IntegracionGestor_ws.Transaccion transaccion = new IntegracionGestor_ws.Transaccion();
        transaccion.detalleTransaccion = detalleTransaccion;
        transaccion.fechaProcesamiento ='16/05/2018';
        transaccion.idTransaccion='ActEst001';
        transaccion.nombreSistema='Gestor';
        transaccion.tipoTransaccion='Actualizar Estado';
        
        //actualizarEstado
        
        IntegracionGestor_ws.Parametro parametrogp = new IntegracionGestor_ws.Parametro();
        parametrogp.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametrogp.valor = 'CiscoViptela';
        
        //JACERO 26072018 Campos dinámicos
        IntegracionGestor_ws.Parametro parametrogpD = new IntegracionGestor_ws.Parametro();
        parametrogpD.nombre = 'Comentarios';
        parametrogpD.valor = 'Test comments';
        
        IntegracionGestor_ws.DetallesActualizarEstado detallesActualizarEstado = new IntegracionGestor_ws.DetallesActualizarEstado();
        detallesActualizarEstado.parametro.add(parametrogp);
        detallesActualizarEstado.parametro.add(parametrogpD);
        
        IntegracionGestor_ws.ActualizarEstado actualizarEstado = new IntegracionGestor_ws.ActualizarEstado();
        actualizarEstado.detallesActualizarEstado = detallesActualizarEstado;
        actualizarEstado.estado = 'Estado Gestor';
        actualizarEstado.numeroOC = OC2[0].Name;//'OC-654170';
        actualizarEstado.numeroViabilidad = via2[0].Name;//'VIA-128074';
        actualizarEstado.fase = 'Fase Gestor';
        actualizarEstado.tipoSolicitud = 'Aprovisionamiento';
        
        
        IntegracionGestor_ws.MsgEntradaActualizarEstado msgEntradaActualizarEstado = new IntegracionGestor_ws.MsgEntradaActualizarEstado();
        msgEntradaActualizarEstado.ActualizarEstado = actualizarEstado;
        msgEntradaActualizarEstado.transaccion = transaccion;
        
        IntegracionGestor_ws.WSActualizarEstado(msgEntradaActualizarEstado);
        
       
        Test.stopTest();
    }
    
    static testMethod void WSActualizarEstadoViaTest() {
        
       // crearData();
        List<Viabilidad__c> via2 = [SELECT Id, name FROM Viabilidad__c];
        System.debug('Esta es la viabilidad:' + via2);
        List<OperacionComercial__c> OC2 = [SELECT Id, name FROM OperacionComercial__c];
        System.debug('Esta es la OC2:' + OC2);
        
        Test.startTest();
        // Transaccion
        IntegracionGestor_ws.Parametro parametro = new IntegracionGestor_ws.Parametro();
        parametro.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametro.valor = 'CiscoViptela';
        IntegracionGestor_ws.DetalleTransaccion detalleTransaccion = new IntegracionGestor_ws.DetalleTransaccion();
        detalleTransaccion.parametro.add(parametro);
        IntegracionGestor_ws.Transaccion transaccion = new IntegracionGestor_ws.Transaccion();
        transaccion.detalleTransaccion = detalleTransaccion;
        transaccion.fechaProcesamiento ='16/05/2018';
        transaccion.idTransaccion='ActEst001';
        transaccion.nombreSistema='Gestor';
        transaccion.tipoTransaccion='Actualizar Estado';
        
        //actualizarEstado
        
        IntegracionGestor_ws.Parametro parametrogp = new IntegracionGestor_ws.Parametro();
        parametrogp.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametrogp.valor = 'CiscoViptela';
        
        IntegracionGestor_ws.DetallesActualizarEstado detallesActualizarEstado = new IntegracionGestor_ws.DetallesActualizarEstado();
        detallesActualizarEstado.parametro.add(parametrogp);
        
        IntegracionGestor_ws.ActualizarEstado actualizarEstado = new IntegracionGestor_ws.ActualizarEstado();
        actualizarEstado.detallesActualizarEstado = detallesActualizarEstado;
        actualizarEstado.estado = 'Estado Gestor';
        actualizarEstado.numeroOC = OC2[0].Name;//'OC-654170';
        actualizarEstado.numeroViabilidad = via2[0].Name;//'VIA-128074';
        actualizarEstado.fase = 'Fase Gestor';
        actualizarEstado.tipoSolicitud = 'Viabilidad';
        
        IntegracionGestor_ws.ActualizarEstado actualizarEstado1 = new IntegracionGestor_ws.ActualizarEstado();
        actualizarEstado1.detallesActualizarEstado = detallesActualizarEstado;
        actualizarEstado1.estado = 'Estado Gestor';
        actualizarEstado1.numeroOC = OC2[0].Name;//'OC-654170';
        actualizarEstado1.numeroViabilidad = via2[0].Name;//'VIA-128074';
        actualizarEstado1.fase = 'Fase Gestor';
        actualizarEstado1.tipoSolicitud = 'Aprovisionamiento';
        actualizarEstado1.imeis = 'cmVmMSwxMjM0DQpyZWYyLDU2NzgNCnJlZjMsOTAxMg==';
        
        
        IntegracionGestor_ws.MsgEntradaActualizarEstado msgEntradaActualizarEstado = new IntegracionGestor_ws.MsgEntradaActualizarEstado();
        msgEntradaActualizarEstado.ActualizarEstado = actualizarEstado;
        msgEntradaActualizarEstado.transaccion = transaccion;
        
        IntegracionGestor_ws.WSActualizarEstado(msgEntradaActualizarEstado);
        msgEntradaActualizarEstado.ActualizarEstado = actualizarEstado1;
        IntegracionGestor_ws.WSActualizarEstado(msgEntradaActualizarEstado);
        Test.stopTest();
    }
    
    static testMethod void ObtenerCamposURLTest() {
        String URL = 'http://104.40.50.130:86/Portafolio_Superior/Base/DescargarAdjuntoSalesForce?idA=5aeb34b0929c50302028dda4&idS=OC-654184&tS=Viabilidad&t=c0b962882f8e4095b0f11e1f8ec07e06';
        String accion = 'accion';
        string idA = 'idA';
        string idS = 'idS';
        string tS = 'tS';
        string t = 't';
        IntegracionGestor_cls.ObtenerCamposURL(URL, accion);
        IntegracionGestor_cls.ObtenerCamposURL(URL, idA);
        IntegracionGestor_cls.ObtenerCamposURL(URL, idS);
        IntegracionGestor_cls.ObtenerCamposURL(URL, tS);
        IntegracionGestor_cls.ObtenerCamposURL(URL, t);   
    }
    
    static testMethod void listaURLsTest() {
        
       // crearData();
        List<Viabilidad__c> via2 = [SELECT Id, name FROM Viabilidad__c];
        System.debug('Esta es la viabilidad listaURLsTest:' + via2);
        
        //
        IntegracionGestor_ws.URLs URLs = new IntegracionGestor_ws.URLs();
        IntegracionGestor_ws.Parametro parametroURL = new IntegracionGestor_ws.Parametro();
        parametroURL.nombre = 'Archivo diseño';
        parametroURL.valor = 'http://104.40.50.130:86/Portafolio_Superior/Base/DescargarAdjuntoSalesForce?idA=5aeb34b0929c50302028dda4&idS=OC-654184&tS=Viabilidad&t=c0b962882f8e4095b0f11e1f8ec07e06';
        URLs.parametro.add(parametroURL);
         IntegracionGestor_ws.Parametro parametroURL2 = new IntegracionGestor_ws.Parametro();
        parametroURL2.nombre = 'Archivo diseñohttp://104.40.50.130:86/Portafolio_Superior/Base/DescargarAdjuntoSalesForce?idA=5aeb34b0929c50302028dda4&idS=OC-654184&tS=Viabilidad&t=c0b962882f8e4095b0f11e1f8ec07e06';
        parametroURL2.valor = 'http://104.40.50.130:86/Portafolio_Superior/Base/DescargarAdjuntoSalesForce?idA=5aeb34b0929c50302028dda4&idS=OC-654184&tS=Viabilidad&t=c0b962882f8e4095b0f11e1f8ec07e06';
        URLs.parametro.add(parametroURL2);
        IntegracionGestor_cls.InsertarURLs(via2[0].Id, URLs);
    }
    
    static testMethod void OpcionesViabilidadTest() {
        
       // crearData();
        List<Viabilidad__c> via2 = [SELECT Id, name FROM Viabilidad__c];
        System.debug('Esta es la viabilidad RespuestaViabilidadTest:' + via2);
        
        List<Opcion_Aprovisionamiento__c> listaOPC = [SELECT id, IdOpcion__c, ConfiguracionServicio__c, DetallesOpcion__c, Observaciones__c, Seleccion__c FROM Opcion_Aprovisionamiento__c];
        System.debug('Esta es la listaOPC RespuestaViabilidadTest: ' + listaOPC);
        
        Test.startTest();
        
        IntegracionGestor_ws.OpcionesViabilidad opcionesViabilidad1 = new IntegracionGestor_ws.OpcionesViabilidad();
        opcionesViabilidad1 = IntegracionGestor_cls.ObtenerOpcionesViaclass(listaOPC);
        System.debug('Esta es la opcionesViabilidad1 RespuestaViabilidadTest:' + opcionesViabilidad1);
        
        IntegracionGestor_ws.Opcion opcionViabilidad = new IntegracionGestor_ws.Opcion();
        opcionViabilidad = IntegracionGestor_cls.ObtenerOpcionclass(listaOPC[0]);
        System.debug('Esta es la opcionViabilidad RespuestaViabilidadTest:' + opcionViabilidad);
        Test.stopTest();
    }
    
     static testMethod void WSCambioFechaAgenda() {
        
       // crearData();

        List<Account> cuenta = [SELECT Id, Name, Segmento__c FROM Account WHERE AccountNumber = '823698522'];

        if(!cuenta.isEmpty())
        {
            cuenta[0].Segmento__c = 'MiPymes';
        }

        update cuenta;
      
        List<OperacionComercial__c> OC2 = [SELECT Id, name FROM OperacionComercial__c];
        System.debug('Esta es la OC2:' + OC2);
        
        
        IntegracionGestor_ws.Parametro parametro = new IntegracionGestor_ws.Parametro();
        parametro.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametro.valor = 'CiscoViptela';
        IntegracionGestor_ws.DetalleTransaccion detalleTransaccion = new IntegracionGestor_ws.DetalleTransaccion();
        detalleTransaccion.parametro.add(parametro);
        IntegracionGestor_ws.Transaccion transaccion = new IntegracionGestor_ws.Transaccion();
        transaccion.detalleTransaccion = detalleTransaccion;
        transaccion.fechaProcesamiento ='16/05/2018';
        transaccion.idTransaccion='Inifac001';
        transaccion.nombreSistema='Gestor';
        transaccion.tipoTransaccion='IniciarFacturacion';
        
        //inicioFacturacion
        IntegracionGestor_ws.Parametro parametroif = new IntegracionGestor_ws.Parametro();
        parametroif.nombre = 'TECNOLOGIA SERVICIO SDWAN';
        parametroif.valor = 'CiscoViptela';  
        IntegracionGestor_ws.Parametro parametroif2 = new IntegracionGestor_ws.Parametro();
        parametroif2.nombre = 'RANGO NUMERACION';
        parametroif2.valor = 'ADD:32902650-32902660;32902662;32902664-32902699;';    
        
        IntegracionGestor_ws.DetallesInicioFacturacion detallesInicioFacturacion = new IntegracionGestor_ws.DetallesInicioFacturacion();
        detallesInicioFacturacion.parametro.add(parametroif);
        detallesInicioFacturacion.parametro.add(parametroif2);
        
        IntegracionGestor_ws.InicioFacturacion inicioFacturacion = new IntegracionGestor_ws.InicioFacturacion();
        inicioFacturacion.detallesInicioFacturacion = detallesInicioFacturacion;
        inicioFacturacion.estado = 'Activa';
        inicioFacturacion.fechaInicioFacturacion = '05/09/2022';
        inicioFacturacion.grupoAsignacion = 'Grupo Asignado';
        inicioFacturacion.IDServicio = 'IDS000001';
        inicioFacturacion.numeroOC = OC2[0].Name;
        inicioFacturacion.responsable = 'SERGIO ALFONSO GUTIÉRREZ';
        
        IntegracionGestor_ws.MsgEntradaInicioFacturacion msgEntradaInicioFacturacion = new IntegracionGestor_ws.MsgEntradaInicioFacturacion();
        msgEntradaInicioFacturacion.inicioFacturacion = inicioFacturacion;
        msgEntradaInicioFacturacion.transaccion = transaccion;
        
       
        Test.startTest();
        IntegracionGestor_ws.WSCambioFechaAgenda(MsgEntradaInicioFacturacion);
        inicioFacturacion.fechaInicioFacturacion = '';
        IntegracionGestor_ws.WSCambioFechaAgenda(MsgEntradaInicioFacturacion);
        inicioFacturacion.numeroOC = 'OC2[0].Name';// Se le asigna ese valor para que no encuentre OC y aumente la cobertura
        IntegracionGestor_ws.WSCambioFechaAgenda(MsgEntradaInicioFacturacion);
        Test.stopTest();
    }
    
}