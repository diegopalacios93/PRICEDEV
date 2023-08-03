@isTest
public class LTE_ServiciosAprovisionamiento_ws_tst {
    
    public static Map<string,string> variablesTest=new Map<string,string>();
    public static Map<string,list<sobject>> variablesObj=new Map<string,list<sobject>>();
    public static boolean conf=false;
    
    //Cambio de plan
    static testMethod void Suspension()
    {
        crearData('Suspensión');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
    }
    
    //ModificacionServicio
    static testMethod void ModificacionServicio()
    {
        crearData('Modificación Servicio');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        list<OperacionComercial__c> lstOCs = [
            Select  Id, Activo__c, Topp__r.TipodeOperacionporplan__c, 
            Name,TipoSuspension__c,Plan__r.LTE_TipoControl__c,
            Activo__r.LTE_Fecha_Ultima_Suspension__c,Activo__r.LTE_Fecha_Ultima_Reconexion__c,
            Activo__r.Fecha_Activacion__c,Activo__r.LTE_Fecha_Inicial_Contrato__c,Activo__r.LTE_Fecha_Final_Contrato__c,Activo__r.LTE_Fecha_Alta_inicial__c,
            Activo__r.LTE_Dias_suspendidos__c,Activo__r.LTE_Numero_veces_suspendido__c
            From    OperacionComercial__c
            Where   Id = :oc.Id
        ];
        map<String, map<String,LTE_Servicios_adicionales__c>> mapSAxOC = new map<String, map<String,LTE_Servicios_adicionales__c>>();
        map<String, map<String,LTE_Servicios_adicionales__c>> mapSAxOC1 = new map<String, map<String,LTE_Servicios_adicionales__c>>();
        
        //Obtengo los servicios adicionales relacionados con el Servicio
        list<LTE_Servicios_adicionales__c> lstSA = [
            Select  Id, LTE_ServicioETB__c, LTE_ServiceActionCode__c, Name, LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c,
                    LTE_ServicioETB__r.Plan__r.Name, LTE_DetalleOfertaEReservadoRegContable__c, LTE_OC_Tramite__c,
                    (Select Id, Name, LTE_ActionCode__c, LTE_ParametroFacturacion__c, LTE_Value__c From SpecificationGroupXA__r) 
            From    LTE_Servicios_adicionales__c
            Where   LTE_ServicioETB__c = :oc.Activo__c and  LTE_ServiceActionCode__c!='ELIMINADO'
        ];
        
        system.debug('\nLista SA Servicio===>'+lstSA);
        
        //Armo un mapa con los servicios adicionales de cada servicio
        for(LTE_Servicios_adicionales__c sa : lstSA){
            //Lista para obtener los servicios adicionales de la OC
            map<String,LTE_Servicios_adicionales__c> lstSAAux;
            if(mapSAxOC.containsKey(sa.LTE_ServicioETB__c))
                lstSAAux = mapSAxOC.get(sa.LTE_ServicioETB__c);
            else
                lstSAAux = new map<String, LTE_Servicios_adicionales__c>();
                
            lstSAAux.put(sa.Id, sa);
            mapSAxOC.put(sa.LTE_ServicioETB__c, lstSAAux);
        }
        
        String c ='LTE_TipodeOperacionProductoOnComplete.'+LibreriaUtilitaria_cls.quitarCaracteresEsp(lstOCs[0].Topp__r.TipodeOperacionporplan__c.deleteWhitespace());
            Type t = Type.forName(c);
            if(t!=null){
                LTE_Tramites_cls.Step paso =(LTE_Tramites_cls.Step) t.newInstance();
                paso.oc = lstOCs[0];
                /*if(mapSAxOC1.containsKey(oc.Id))
                    paso.sa = mapSAxOC1.get(oc.Id).values();*/
                if(mapSAxOC.containsKey(oc.Activo__c))
                    paso.saActivo = mapSAxOC.get(oc.Activo__c).values();
                paso.procesar();
            }
    }
    
    //ModificacionEstandar
    static testMethod void ModificacionEstandar()
    {
        crearData('Modificación Estándar');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        list<OperacionComercial__c> lstOCs = [
            Select  Id, Activo__c, Topp__r.TipodeOperacionporplan__c, 
            Name,TipoSuspension__c,Plan__r.LTE_TipoControl__c,
            Activo__r.LTE_Fecha_Ultima_Suspension__c,Activo__r.LTE_Fecha_Ultima_Reconexion__c,
            Activo__r.Fecha_Activacion__c,Activo__r.LTE_Fecha_Inicial_Contrato__c,Activo__r.LTE_Fecha_Final_Contrato__c,Activo__r.LTE_Fecha_Alta_inicial__c,
            Activo__r.LTE_Dias_suspendidos__c,Activo__r.LTE_Numero_veces_suspendido__c
            From    OperacionComercial__c
            Where   Id = :oc.Id
        ];
        map<String, map<String,LTE_Servicios_adicionales__c>> mapSAxOC = new map<String, map<String,LTE_Servicios_adicionales__c>>();
        map<String, map<String,LTE_Servicios_adicionales__c>> mapSAxOC1 = new map<String, map<String,LTE_Servicios_adicionales__c>>();
        
        //Obtengo los servicios adicionales relacionados con el Servicio
        list<LTE_Servicios_adicionales__c> lstSA = [
            Select  Id, LTE_ServicioETB__c, LTE_ServiceActionCode__c, Name, LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c,
                    LTE_ServicioETB__r.Plan__r.Name, LTE_DetalleOfertaEReservadoRegContable__c, LTE_OC_Tramite__c,
                    (Select Id, Name, LTE_ActionCode__c, LTE_ParametroFacturacion__c, LTE_Value__c From SpecificationGroupXA__r) 
            From    LTE_Servicios_adicionales__c
            Where   LTE_ServicioETB__c = :oc.Activo__c and  LTE_ServiceActionCode__c!='ELIMINADO'
        ];
        
        system.debug('\nLista SA Servicio===>'+lstSA);
        
        //Armo un mapa con los servicios adicionales de cada servicio
        for(LTE_Servicios_adicionales__c sa : lstSA){
            //Lista para obtener los servicios adicionales de la OC
            map<String,LTE_Servicios_adicionales__c> lstSAAux;
            if(mapSAxOC.containsKey(sa.LTE_ServicioETB__c))
                lstSAAux = mapSAxOC.get(sa.LTE_ServicioETB__c);
            else
                lstSAAux = new map<String, LTE_Servicios_adicionales__c>();
                
            lstSAAux.put(sa.Id, sa);
            mapSAxOC.put(sa.LTE_ServicioETB__c, lstSAAux);
        }
        
        String c ='LTE_TipodeOperacionProductoOnComplete.'+LibreriaUtilitaria_cls.quitarCaracteresEsp(lstOCs[0].Topp__r.TipodeOperacionporplan__c.deleteWhitespace());
            Type t = Type.forName(c);
            if(t!=null){
                LTE_Tramites_cls.Step paso =(LTE_Tramites_cls.Step) t.newInstance();
                paso.oc = lstOCs[0];
                /*if(mapSAxOC1.containsKey(oc.Id))
                    paso.sa = mapSAxOC1.get(oc.Id).values();*/
                if(mapSAxOC.containsKey(oc.Activo__c))
                    paso.saActivo = mapSAxOC.get(oc.Activo__c).values();
                paso.procesar();
            }		    
    }
    
    //Cambio de plan
    static testMethod void CambioDePlan()
    {
        crearData('Cambio de Plan');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
    }
    
    static testMethod void Venta()
    {
        crearData('Venta');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
    }
    
    
    static testMethod void Retiro()
    {
        crearData('Retiro');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
        LTE_ServiciosAprovisionamiento_ws.actualizarFacturado(oc);
    }
    
    static testMethod void AdicionSVA()
    {
        crearData('Adición SVA');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
        LTE_ServiciosAprovisionamiento_ws.actualizarFacturado(oc);
    } 
    
    static testMethod void Renovacion()
    {
        crearData('Renovación');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
        LTE_ServiciosAprovisionamiento_ws.actualizarFacturado(oc);
    }  
    
    static testMethod void RetiroSVA()
    {
        crearData('Retiro SVA'); 
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
        LTE_ServiciosAprovisionamiento_ws.actualizarFacturado(oc);
    } 
    
    static testMethod void CambioNumero()
    {
        crearData('Cambio Número'); 
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
        LTE_ServiciosAprovisionamiento_ws.actualizarFacturado(oc);
    }
    
    public static void crearData(string tramite){
        crearConfiguracion();
        variablesObj.put('Account',new list<sobject>());
        
        objPruebas_tst obj=new objPruebas_tst();
        
        Account cliente =obj.objAccount();
        insert cliente;
        variablesObj.get('Account').add(cliente);
        
        Opportunity opt=obj.objOpt();
        opt.AccountId=cliente.id;
        insert opt;
        
        Id devRecordSId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sucursales').getRecordTypeId();
        Account sucursal=obj.ObjAccount();
        sucursal.RecordTypeId =devRecordSId;
        sucursal.Cuenta__c=cliente.id;
        insert sucursal;
        
        Id devRecordOpt = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('LTE').getRecordTypeId();
        Opportunity oportunidad=obj.objOpt();
        oportunidad.accountId=cliente.Id;
        oportunidad.RecordTypeId=devRecordOpt;
        insert oportunidad;
        
        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Name='TELEFONIA MOVIL (LTE)';
        Catalogo.Familia__c='LTE';
        insert Catalogo;
        
        CatalogoProductosFacturacion__c objCatalogoProdFact=objPruebas_tst.objCatalogoProductosFacturacion();
        objCatalogoProdFact.Name=Catalogo.Name;
        objCatalogoProdFact.CatalogoProductos__c=Catalogo.Id;
        insert objCatalogoProdFact;
        
        planes__c Plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        plan.LTE_PlanEstructurados__c=false;
        //plan.TipodePlan__c = 'Troncal SIP';
        insert plan;
        
        list<PlanFacturacion__c>PlanFactLst=new list<PlanFacturacion__c>();
        
        PlanFacturacion__c objPlanFacturacion=objPruebas_tst.objPlanFacturacion();
        objPlanFacturacion.name='PLAN NEGOCIOS CONTROL S';
        objPlanFacturacion.CatalogoProductosFacturacion__c=objCatalogoProdFact.Id;
        objPlanFacturacion.Plan__c=plan.id;
        PlanFactLst.add(objPlanFacturacion);
        
        PlanFacturacion__c objPlanFactDeft=objPruebas_tst.objPlanFacturacion();
        objPlanFactDeft.Name='DEFAULT FACTURACION LTE';
        objPlanFactDeft.CatalogoProductosFacturacion__c=objCatalogoProdFact.Id;
        PlanFactLst.add(objPlanFactDeft);
        insert PlanFactLst;
        
        SubPlanFacturacion__c subPlan =objPruebas_tst.objSubPlanFacturacion();
        subPlan.Name='NUMERO SIM CARD';
        subPlan.PlanFacturacion__c=objPlanFactDeft.id;
        subPlan.codigo__c=subPlan.Name;
        insert subPlan;
        
        SubPlanFacturacion__c subPlanb =objPruebas_tst.objSubPlanFacturacion();
        subPlanb.Name='BOLSA ADIC DE DATOS 5GB';
        subPlanb.PlanFacturacion__c=objPlanFactDeft.id;
        subPlanb.codigo__c=subPlanb.Name;
        subPlanb.LTE_TipoSubplan__c='Bolsa de Datos a la medida';
        insert subPlanb;
        
        system.debug('por aca'+objPlanFacturacion.Id);
        
        list<ParametroFacturacion__c> paraMetros=new list<ParametroFacturacion__c>();
        paraMetros.add(new ParametroFacturacion__c (Name='RVC PLN',LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',CatalogoProductosFacturacion__c=objCatalogoProdFact.Id));
        paraMetros.add(new ParametroFacturacion__c (Campo__c='IMEI_del_Equipo__c',Name='IMEI',Objeto__c='OperacionComercial__c',PlanFacturacion__c=objPlanFacturacion.Id));
        paraMetros.add(new ParametroFacturacion__c (Campo__c='LTE_EsPortabilidad__c',Name='EsPortabilidad',Objeto__c='LTE_DetalleOferta__c',PlanFacturacion__c=objPlanFactDeft.Id));
        paraMetros.add(new ParametroFacturacion__c (LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',Name='',SubPlanFacturacion__c=subPlan.Id));
        paraMetros.add(new ParametroFacturacion__c (LTE_ValorDefecto__c='Uso No Pre-tarificado LTE',Name='',SubPlanFacturacion__c=subPlanb.Id));
        insert paraMetros;
        
        TOPP__c topp= obj.objTopp();
        topp.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp.Facturable__c=true;
        topp.TipodeOperacionporplan__c=tramite;
        insert topp;
        
        Equipo__c equipo=new Equipo__c(
            Descripcion__c='Info',
            LTE_Categoria__c='alta',LTE_Color__c='Morado',LTE_Gama__c='D',LTE_IVA__c=20,LTE_Marca__c='Lokia',
            LTE_MemoriaInternaROM_GB__c='1TB',LTE_ModeloComercial__c='Lok',LTE_OEM__c='Oem',
            LTE_PartNumber__c='38383838383',LTE_PrecioConIVA__c=1222,Name='LOKia',Tipo__c='ssss',
            Valor_del_Equipo__c=20,LTE_Activo__c=true
        );
        insert equipo;
        
        Reserva__c reserva=new Reserva__c(
            Equipo__c=equipo.Id,Estado__c='Pendiente',LTE_Plan__c=plan.Id,Oportunidad__c=oportunidad.Id,
            LTE_DatosNavegacion__c=subPlanb.id
        );
        insert reserva;
        
        ActivoETB__c servicio =obj.objServicio();
        servicio.NombredelaCuenta__c=cliente.Id;
        servicio.SucursalDestino__c=sucursal.id;
        servicio.SucursalOrigen__c=sucursal.id;
        servicio.Plan__c=plan.id;
        servicio.NombredelProducto__c=Catalogo.Id;
        servicio.Oportunidad__c=opt.id;
        servicio.Tipodeprogramacion__c='Troncal';
        servicio.LTE_Fecha_Alta_inicial__c = date.parse('27/05/2018');//Se ajusta clase de prueba para qued funcione en produción. En QA es '05/27/2018' 
        
        insert servicio;
        variablesObj.put('ActivoETB',new list<ActivoETB__c>());
        variablesObj.get('ActivoETB').add(servicio);
        
        Poblacion__c objDepto = new Poblacion__c();
        objDepto.Name = 'BOGOTA D.C.';
        objDepto.CodigoDane__c = '11000';
        objDepto.EsDepartamento__c = true;
        insert objDepto;
        
        Poblacion__c objMunicipio = new Poblacion__c();
        objMunicipio.Name = 'BOGOTA D.C.';
        objMunicipio.CodigoDane__c = '11001';
        objMunicipio.EsMunicipio__c = true;
        objMunicipio.Padre__c = objDepto.Id;
        insert objMunicipio;
        
        CuentaFacturacion__c objCuentaFacturacion=obj.objCuentaFacturacion();
        objCuentaFacturacion.Cliente__c=cliente.id;
        objCuentaFacturacion.Ciudad__c = objMunicipio.Id;
        objCuentaFacturacion.DirCorresp__c = 'Test DirCorresp';
        insert objCuentaFacturacion;
        
        Contract contrato=obj.objContrato();
        contrato.Accountid =cliente.Id;
        insert contrato;
        
        Legalizacion__c leg=obj.objLeg();
        leg.Contrato__c=contrato.id;
        leg.estado__c='Gestionado';
        insert leg;
        
        OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Activo__c=servicio.id;
        oc.Plan__c=plan.id;
        oc.SucursalDestino__c=sucursal.id;
        oc.SucursalOrigen__c=sucursal.id;
        oc.Oportunidad__c=opt.id;
        oc.IDServicio__c='CAV1024234';
        oc.TOPP__c=topp.id;
        oc.Legalizacion__c=leg.id;
        oc.CuentaFacturacion__c=objCuentaFacturacion.id;
        oc.Estado__c=variablesTest.get('oc.Estado__c');
        oc.LTE_ICCID__c='490816320198746';
        oc.LTE_AplicaOnline__c=true;
        oc.LTE_IMSI__c='23244';
        oc.LTE_PIN__c='34343';
        oc.LTE_PUK__c='33434';
        oc.TipoSuspension__c = 'Voluntaria';
        oc.RangosDisponibilidad__c = '99,6';
        insert oc;
        variablesObj.put('OperacionComercial',new list<OperacionComercial__c>());
        variablesObj.get('OperacionComercial').add(oc);
        
        LTE_DetalleOferta__c detOf=new LTE_DetalleOferta__c(
            LTE_Oferta_Economica__c=reserva.Id,
            LTE_OperacionComercial__c=oc.id,
            LTE_ReferenciaEquipo__c=equipo.id,
            Plan__c=plan.id,
            LTE_DatosNavegacion__c=subPlanb.Id);
        insert detOf;
        variablesObj.put('LTE_DetalleOferta',new list<LTE_DetalleOferta__c>());
        variablesObj.get('LTE_DetalleOferta').add(detOf);
        
        detOf.LTE_IMEI__c='490816320198746';
        detOf.LTE_ICCID__c='490816320198746';
        update detOf;
        
        
        LTE_Servicios_adicionales__c saAd=new LTE_Servicios_adicionales__c();
        saAd.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
        saAd.LTE_Estado__c='ADD';
        saAd.LTE_ItemIdentification__c=Catalogo.Id;
        saAd.LTE_SubPlaFacturacion__c=subPlanb.Id;
        
        LTE_Servicios_adicionales__c saAdp=new LTE_Servicios_adicionales__c();
        saAdp.LTE_DetalleOfertaEReservadoRegContable__c=detOf.id;
        saAdp.LTE_Estado__c='ADD';
        saAdp.LTE_ItemIdentification__c=Catalogo.Id;
        saAdp.LTE_PlanFacturacion__c=PlanFactLst[0].Id;
        
        
        LTE_Servicios_adicionales__c saAd2=new LTE_Servicios_adicionales__c();
        saAd2.LTE_Estado__c='ADD';
        saAd2.LTE_ItemIdentification__c=Catalogo.Id;
        saAd2.LTE_ServicioETB__c=servicio.id;
        
        insert new list<LTE_Servicios_adicionales__c>{saAd,saAdp,saAd2};
            variablesObj.put('Servicios_adicionales',new list<LTE_Servicios_adicionales__c>());
        variablesObj.get('Servicios_adicionales').add(saAd);
        
        
        list<LTE_SpecificationGroupXA__c> spGX=new list<LTE_SpecificationGroupXA__c>();
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[0].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[1].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[2].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[3].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
        spGX.add(new LTE_SpecificationGroupXA__c(Name=paraMetros[4].Name,LTE_ParametroFacturacion__c=paraMetros[0].Id,LTE_ServiciosAdicionales__c=saAd2.Id));
        
        insert spGX;
        
        variablesObj.put('LTE_SpecificationGroupXA',new list<LTE_SpecificationGroupXA__c>());
        variablesObj.get('LTE_SpecificationGroupXA').addAll((list<sobject>)spGX);
        
        
    }
    
    public static void crearConfiguracion(){
        List<sObject> ls = Test.loadData(Perfiles_Reglas_OC__c.sObjectType, 'TestPerfilesReglasOC');
        
        list<sobject> vg=new list<sobject>();
        vg.add(new VariablesGlobales__c(Name='NombreDefaultaFacturacionLTE',Valor__c='DEFAULT FACTURACION LTE'));
        vg.add(new VariablesGlobales__c(Name='NombreComercialLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='NombreFacturacionLTE',Valor__c='TELEFONIA MOVIL (LTE)'));
        vg.add(new VariablesGlobales__c(Name='NombrePlanDefectorLTE',Valor__c='DEFAULT FACTURACION LTE'));
        vg.add(new VariablesGlobales__c(Name='aprovisionamientoOnline',Valor__c='3'));
        vg.add(new ServiciosWeb__c(Name='DisponibilidadM6',Action__c='/action',EndPoint__c='https://salesforce.com/x'));
        vg.add(new ServiciosWeb__c(Name='Aprovisionar',Action__c='/action',EndPoint__c='https://salesforce.com'));
        vg.add(new Perfiles_Acciones__c(Name='PerfilesCambioEstadosLTE',Usuarios__c=UserInfo.getProfileId()));
        vg.add(new Perfiles_Acciones__c(Name='DataCreditoScore',Usuarios__c=Userinfo.getProfileId()));
        vg.add(new Perfiles_Acciones__c(Name='Adjuntos',Usuarios__c=Userinfo.getProfileId()));
        vg.add(new HomologacionCampos__c(Valor__c='NIT',Name='AprovNIT'));
        vg.add(new AprovisionamientoOnline__c(Name='Disponibilidad M6',LTE_Noche__c=30));
        vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento',LTE_Noche__c=30));
        vg.add(new AprovisionamientoOnline__c(Name='Aprovisionamiento Tramites',LTE_Noche__c=3));
        vg.add(new AprovisionamientoOnline__c(Name='Facturacion',LTE_Noche__c=3));
        
        insert vg;
        
    }
    
    static testMethod void Reconexion()
    {
        crearData('Reconexión');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
        LTE_ServiciosAprovisionamiento_ws.actualizarFacturado(oc);
        
    }
    
    
    static testMethod void Reposicion()
    {
        crearData('Reposición');
        OperacionComercial__c oc=(OperacionComercial__c)variablesObj.get('OperacionComercial')[0];
        LTE_ServiciosAprovisionamiento_ws.EstadosOrden EO=new LTE_ServiciosAprovisionamiento_ws.EstadosOrden();
        EO.OrderId=oc.id;
        EO.EstadoOrden='COMPLETE';
        EO.Comentarios='COMPLETE';
        LTE_Servicios_adicionales__c sa= (LTE_Servicios_adicionales__c)variablesObj.get('Servicios_adicionales')[0];
        List<LTE_ServiciosAprovisionamiento_ws.LineItem> li=new List<LTE_ServiciosAprovisionamiento_ws.LineItem>();
        li.add(new LTE_ServiciosAprovisionamiento_ws.LineItem());
        li[0].IdLineItem=sa.id;
        EO.LineItems=li;
        LTE_ServiciosAprovisionamiento_ws.ActualizacionEstadoOrden(EO);
        LTE_ServiciosAprovisionamiento_ws.ConsultaEstadoOrden(EO.OrderId);
        LTE_ServiciosAprovisionamiento_ws.actualizarFacturado(oc);
        
    }
    
    
    static testMethod void enviarCorreoTroncalSIP()
    {
        variablesObj.put('Account',new list<sobject>());
        objPruebas_tst obj=new objPruebas_tst();
        Account cliente =obj.objAccount();
        insert cliente;
        variablesObj.get('Account').add(cliente);
        CatalogoProductos__c Catalogo =obj.objCatalogo();
        Catalogo.Name='TELEFONIA MOVIL (LTE)';
        Catalogo.Familia__c='LTE';
        insert Catalogo;
        
        CatalogoProductosFacturacion__c objCatalogoProdFact=objPruebas_tst.objCatalogoProductosFacturacion();
        objCatalogoProdFact.Name=Catalogo.Name;
        objCatalogoProdFact.CatalogoProductos__c=Catalogo.Id;
        insert objCatalogoProdFact;
        
        planes__c Plan =obj.objPlan();
        plan.NombredelProducto__c=Catalogo.id;
        plan.LTE_PlanEstructurados__c=false;
        plan.TipodePlan__c = 'Troncal SIP';
        insert plan;
        
        TOPP__c topp= obj.objTopp();
        topp.LTE_Catalogo_de_Producto__c=Catalogo.id;
        topp.Facturable__c=true;
        topp.TipodeOperacionporplan__c='Venta';
        insert topp;
        
        OperacionComercial__c oc =obj.objOc();
        oc.CuentaCliente__c=cliente.id;
        oc.Plan__c=plan.id;
        oc.TOPP__c=topp.id;
        oc.Estado__c=variablesTest.get('oc.Estado__c');
        oc.LTE_ICCID__c='490816320198746';
        oc.LTE_AplicaOnline__c=true;
        oc.LTE_IMSI__c='23244';
        oc.LTE_PIN__c='34343';
        oc.LTE_PUK__c='33434';
        insert oc;
        
        list<OperacionComercial__c> ocList=new list<OperacionComercial__c>([select id,NumeroConexion__c,categoria__c, Name,Activo__c,TipoSuspension__c, TOPP__r.TipodeOperacionporplan__c,Plan__r.LTE_TipoControl__c,
                                                                            LTE_ICCID__c, LTE_IMSI__c, LTE_PIN__c, LTE_PUK__c, SDP__c,IMEI_del_Equipo__c, LTE_TipoTransaccion__c,
                                                                            Activo__r.LTE_Fecha_Ultima_Suspension__c,Activo__r.LTE_Fecha_Ultima_Reconexion__c,Activo__r.NumeroConexion__c,Plan__r.LTE_MetodoDePago__c,
                                                                            Activo__r.Fecha_Activacion__c,Activo__r.LTE_Fecha_Inicial_Contrato__c,Activo__r.LTE_Fecha_Final_Contrato__c,Activo__r.LTE_Fecha_Alta_inicial__c,
                                                                            Activo__r.LTE_Dias_suspendidos__c,Activo__r.LTE_Numero_veces_suspendido__c,Plan__r.TipodePlan__c, LTE_ReferenciaEquipo__c, LTE_ReferenciaEquipo__r.Name, LTE_ReferenciaEquipo__r.LTE_Marca__c 
                                                                            from OperacionComercial__c where Id =: oc.Id]);
        OperacionComercial__c oc1= new OperacionComercial__c();
        oc1=ocList[0];
        LTE_ServiciosAprovisionamiento_ws.enviarCorreo(oc1);
        
    }
    
}