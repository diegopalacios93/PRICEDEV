/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Hector Bayona
Project:                ETB-LTE   
Description:            Clase contiene la logica y estructuras xml para la invocacion
                        de los servicios de disponibilidad M6 y aprovisionamiento
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     10/08/2015  Hector Bayona.                  Class creation.
1.1     11/07/2016  Manuel Cortes   (MC)            Invocacion del metodo normalizar para quitar los
                                                    caracteres especiales del nombre de la cuenta
1.2     22/08/2018  Samuel Rodriguez (SR)           Se adiciona altkeys SDP, Service Id servicio de aprovisionamiento
1.3     27/08/2018  Fernando Sarasty (FS)           Se incluye tag "ICCIDAnt" para enviar el ICCID anterior
                                                    en trámites que requieran cambio de SIM.
1.4     07/11/2018  Samuel Rodriguez (SR)           Se adiciona altkeys NOMBRES, APELLIDO1 y APELLIDO2 
*******************************************************************************/
public with sharing class LTE_Aprovisionamiento_cls {

    /**
    *   @Method: AvailabilitQueryOrder
    *   @param oc: OperacionComercial a procesar.      
    *   @return String: XML de request.
    *   @description: Metodo que crea el request para el consumo del servicio de M6. 
    */
    public static string AvailabilitQueryOrder(OperacionComercial__c oc) {

        tramiteLTE tr = new tramiteLTE(Oc);
        string addServiceId='';
        
        if(tr.OrderType=='Venta LTE'){
            addServiceId=oc.Activo__c; 
            if(Oc.Detalles_de_las_ofertas__r.size() > 0){
                if(Oc.Detalles_de_las_ofertas__r[0].NumeracionM2M__c == true){
                    tr.OrderNumCategory = 'M2M';
                } 
            }
        }else{
            addServiceId=oc.Activo__c+'-'+oc.Id;
        }        
        string xml = '<?xml version="1.0" encoding="utf-8"?>'
                     + '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ns="http://www.etb.com.co/LTE/WS/ProvisioningLTECorp/AvailabilitQueryOrder/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/ltecorp/aqo/request/v1.0">'
                     + '<soap:Body>'
                     + '<ns:WSAQOLTERequest>'
                     + '<v1:WSRequestHeader>'
                     + '<v1:System correlationID="' + oc.Id + '" processingServer="Salesforce">Salesforce</v1:System>'                   
                     + '</v1:WSRequestHeader>'
                     + '<v11:AQOLTERequest>'
                     + '<v11:OrderId>' + oc.Id + '</v11:OrderId>'
                     + '<v11:ServiceId>' + addServiceId + '</v11:ServiceId>'
                     + '<v11:AccountServiceId>' + oc.CuentaCliente__c + '</v11:AccountServiceId>'
                     + '<v11:OrderType>' + tr.OrderType + '</v11:OrderType>'
                     + '<v11:OrderSubtype>' + tr.OrderSubtype + '</v11:OrderSubtype>'
                     + '<v11:ICCID>' + (oc.LTE_ICCID__c == '' || oc.LTE_ICCID__c == null ? '00000000000000000000' : oc.LTE_ICCID__c) + '</v11:ICCID>'
                     + '<v11:IMEI>' + oc.IMEI_del_Equipo__c + '</v11:IMEI>'
                     + '<v11:Number>' + oc.NumeroConexion__c + '</v11:Number>'
                     + '<v11:ICCIDAnt>'+ oc.Activo__r.LTE_ICCID__c +'</v11:ICCIDAnt>'
                     + '<v11:NumeroPortado></v11:NumeroPortado>'
                     + '<v11:SubCategoria>'+(oc.Plan__r.TipodePlan__c == 'Troncal SIP'?(oc.Plan__r.Pertenece_a_Troncal_SIP_Unificada__c ? 'NUMERACION TRONCAL SIP FIJA' : 'NUMERACION TRONCAL SIP'):(tr.OrderNumCategory == 'M2M' || oc.TipoSeleccion__c == 'M2M' ?'NUMERACION M2M':'NUMERACION MDM'))+'</v11:SubCategoria>'
                     + '</v11:AQOLTERequest>'
                     + '</ns:WSAQOLTERequest>'
                     + '</soap:Body>'
                     + '</soap:Envelope>';      
        
        return xml.replace('>null<', '><');
    }


    /**
    *   @Method: DeliveryDateTime
    *   @param codigo: codigo que define que formato debe llevar.      
    *   @param tr: tramiteLTE clase que contiene los orderSubtype para tramites
    *   @return String: Ccadena de texto con la fecha formateada.
    *   @description: Metodo que retorna la fecha con un formato en particular.
    */
    public static string DeliveryDateTime(integer codigo, OperacionComercial__c oc, tramiteLTE tr) {
        
        String fecha='';
        if(tr.OrderSubtype=='Cambio de Plan'){ 
            Datetime dt = datetime.newInstance(oc.FechaInicioReconexion__c.year(), oc.FechaInicioReconexion__c.month(), oc.FechaInicioReconexion__c.day());
            fecha=LibreriaUtilitaria_cls.formatosFechasAprob(1, dt);
            //fecha=LibreriaUtilitaria_cls.formatosFechasAprob(1, Datetime.Now());
            system.debug('DeliveryDateTime Cambio de Plan'+fecha+' '+oc.FechaInicioReconexion__c);
        }else{
            fecha=LibreriaUtilitaria_cls.formatosFechasAprob(1, Datetime.Now());
            system.debug('DeliveryDateTime NCP');       
        }
        return fecha;
    }


    /**
    *   @Method: obtenerEstructurado
    *   @param ocsMap: Mapa que contiene la OC que deben ser parametrizadas
    *   @return String: Ccadena de texto con la fecha formateada.
    *   @description: Metodo que crea la parametrizacion del plan.
    */
    public static void obtenerEstructurado(map<id, OperacionComercial__c> ocsMap) {

        set<id> planesOc = new set<id>();
        system.debug(ocsMap.size());
        for (Id i : ocsMap.keySet()) {
            system.debug(ocsMap.get(i).TOPP__r.TipodeOperacionporplan__c);
            if(ocsMap.get(i).TOPP__r.TipodeOperacionporplan__c=='Venta' || ocsMap.get(i).TOPP__r.TipodeOperacionporplan__c=='Migracion'){
                planesOc.add(ocsMap.get(i).Plan__c);
                system.debug(ocsMap.get(i).TOPP__r.TipodeOperacionporplan__c);
            }else{
                system.debug('Remover');
                ocsMap.remove(i);       
            }
        }
        system.debug(ocsMap.size());
        
        system.debug(ocsMap);
        if(ocsMap.isEmpty()){
            return;
        }

        map<Id, LTE_DetalleOferta__c> detaOfSubpl = new map<Id, LTE_DetalleOferta__c>([select id, Name, Plan__c,LTE_DescuentoPlan__c,
                (select Id, Name, LTE_SubPlaFacturacion__c from LTE_Servicios_adicionales__r)
                from LTE_DetalleOferta__c
                where LTE_OperacionComercial__c IN : ocsMap.keySet()]);

        Map<string, VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        string producto = vGlobal.get('NombreFacturacionLTE').valor__c;

        //Obtiene Producto facturacion y parametros.
        map<Id, CatalogoProductosFacturacion__c>CatProd = new map<Id, CatalogoProductosFacturacion__c>([select
                id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
                (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from ParametrosFacturacion__r)
                from CatalogoProductosFacturacion__c where Name = :producto
                                                                                                       ]);

        //Obtiene parametro plan estructurado y parametros.
        map<Id, PlanFacturacion__c>planFact = new map<Id, PlanFacturacion__c>([select Plan__c, CatalogoProductosFacturacion__c,
                id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
                (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from Parametros_de_Facturacion__r)
                from PlanFacturacion__c where (Plan__c IN :planesOc)]);

        //Obtiene parametro sub plan estructurado y parametros.
        map<Id, SubPlanFacturacion__c>subPlanFact = new map<Id, SubPlanFacturacion__c>([select PlanFacturacion__c, PlanFacturacion__r.Name,
                id, Name, LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
                (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from Parametros_de_Facturacion__r)
                from SubPlanFacturacion__c where PlanFacturacion__c IN :planFact.keySet() OR PlanFacturacion__r.Name = :vGlobal.get('NombreDefaultaFacturacionLTE').valor__c
                                                                                       ]);


        //Homologacion plan facturacion vs plan comercial
        map<Id, Id> planComFact = new map<Id, Id>();
        //Homologacion plan facturacion vs catalogo
        map<Id, Id> planCatFact = new map<Id, Id>();

        map<Id, SalesOrderLineObj> catalogo = new map<Id, SalesOrderLineObj>();
        map<Id, SalesOrderLineObj> plan = new map<Id, SalesOrderLineObj>();
        map<Id, map<Id, SalesOrderLineObj>> subPlan = new map<Id, map<Id, SalesOrderLineObj>>();

        map<String, map<Id, SalesOrderLineObj>> subPlanDef = new map<String, map<Id, SalesOrderLineObj>>();

        for (Id i : CatProd.keySet()) {
            catalogo.put(i, crearSalesOrderLineObjProducto(CatProd.get(i)));
        }

        for (Id i : planFact.keySet()) {
            plan.put(i, crearSalesOrderLineObjPlan(planFact.get(i)));
            //para LTE debe existir una relacion 1-1
            system.debug(planFact.get(i).Plan__c + ' ' + i);
            planComFact.put(planFact.get(i).Plan__c, i);
            planCatFact.put(planFact.get(i).Plan__c, planFact.get(i).CatalogoProductosFacturacion__c);
        }

        subPlanDef.put(vGlobal.get('NombreDefaultaFacturacionLTE').valor__c, new map<Id, SalesOrderLineObj>());
        for (Id i : subPlanFact.keySet()) {
            if (subPlan.get(subPlanFact.get(i).PlanFacturacion__c) == null) {
                subPlan.put(subPlanFact.get(i).PlanFacturacion__c, new map<Id, SalesOrderLineObj>());
            }

            subPlan.get(subPlanFact.get(i).PlanFacturacion__c).put(i, crearSalesOrderLineObjSubPlan(subPlanFact.get(i)));

        }


        map<Id, LTE_Servicios_adicionales__c> serAdMap = new map<Id, LTE_Servicios_adicionales__c>();
        list<LTE_Servicios_adicionales__c>serAdNew = new list<LTE_Servicios_adicionales__c>();
        list<SalesOrderLineObj> soLst = new list<SalesOrderLineObj>();

        /******************/
        //Obtiene los servicios adicionales para la creacion del plan No Estructurado
        for (Id i : detaOfSubpl.keySet()) {
            for (LTE_Servicios_adicionales__c serAd : detaOfSubpl.get(i).LTE_Servicios_adicionales__r) {
                serAdMap.put(serAd.id, serAd);
            }
            //crea nuevo servicio adicional
            system.debug(detaOfSubpl.get(i).Plan__c);

            Id sId = planComFact.get(detaOfSubpl.get(i).Plan__c);
            Id cId = planCatFact.get(detaOfSubpl.get(i).Plan__c);

            system.debug(sId + ' ' + i);
            SalesOrderLineObj sObj = plan.get(sId).clone();
            sObj.servAd.LTE_DetalleOfertaEReservadoRegContable__c = i;
            sObj.servAd.LTE_NivelDescuento__c=detaOfSubpl.get(i).LTE_DescuentoPlan__c;
            soLst.add(sObj);

            system.debug(catalogo.get(cId));
            if (catalogo.get(cId) != null) {
                SalesOrderLineObj sObjCat = catalogo.get(cId);
                sObjCat.servAd.LTE_DetalleOfertaEReservadoRegContable__c = i;
                soLst.add(sObjCat);
            }
            for (Id ii : subPlan.keySet()) {
                for (Id Iy : subPlan.get(ii).keySet()) {

                    SalesOrderLineObj suObj = subPlan.get(ii).get(Iy);
                    suObj.servAd.LTE_DetalleOfertaEReservadoRegContable__c = i;
                    soLst.add(suObj);

                }
            }

        }


        for (SalesOrderLineObj sObjNew : soLst) {
            serAdNew.add(sObjNew.servAd);
        }
        system.debug('Insert-->'+serAdNew);
        insert serAdNew;
        /******************/

        /******************/
        list<LTE_SpecificationGroupXA__c> datos = new list<LTE_SpecificationGroupXA__c>();
        for (SalesOrderLineObj sObjNew : soLst) {
            datos.addAll(sObjNew.asignarId());
        }

        insert datos;


        obtenerNoEstructurado(serAdMap);

    }
    /**
    *   @Method: crearSalesOrderLineObjProducto
    *   @param cp: Mapa que contiene la OC que deben ser parametrizadas
    *   @return String: Ccadena de texto con la fecha formateada.
    *   @description: Metodo que crea la parametrizacion del plan.
    */
    public static SalesOrderLineObj crearSalesOrderLineObjProducto(CatalogoProductosFacturacion__c cp) {
        SalesOrderLineObj salesObj = new SalesOrderLineObj();

        salesObj.servAd = new LTE_Servicios_adicionales__c();
        salesObj.servAd.Name = cp.Name;
        salesObj.servAd.LTE_ItemIdentification__c = cp.Id;
        salesObj.servAd.LTE_NetworkIndicator__c = cp.LTE_NetworkIndicator__c;
        salesObj.servAd.LTE_ServiceIndicator__c = cp.LTE_ServiceIndicator__c;
        salesObj.servAd.LTE_PrimaryClassificationCode__c = cp.LTE_PrimaryClassificationCode__c;
        salesObj.servAd.LTE_TypeCode__c = cp.LTE_TypeCode__c;

        list<ParametroFacturacion__c>par = cp.ParametrosFacturacion__r;

        for (ParametroFacturacion__c p : par) {
            salesObj.sXA.add(construirSpecXA(p));
        }
        return salesObj;
    }

    public static SalesOrderLineObj crearSalesOrderLineObjPlan(PlanFacturacion__c cp) {
        SalesOrderLineObj salesObj = new SalesOrderLineObj();

        salesObj.servAd = new LTE_Servicios_adicionales__c();
        salesObj.servAd.Name = cp.Name;
        salesObj.servAd.LTE_ItemIdentification__c = cp.Id;
        salesObj.servAd.LTE_NetworkIndicator__c = cp.LTE_NetworkIndicator__c;
        salesObj.servAd.LTE_ServiceIndicator__c = cp.LTE_ServiceIndicator__c;
        salesObj.servAd.LTE_PrimaryClassificationCode__c = cp.LTE_PrimaryClassificationCode__c;
        salesObj.servAd.LTE_TypeCode__c = cp.LTE_TypeCode__c;

        list<ParametroFacturacion__c>par = cp.Parametros_de_Facturacion__r;

        for (ParametroFacturacion__c p : par) {
            salesObj.sXA.add(construirSpecXA(p));
        }
        return salesObj;
    }

    public static SalesOrderLineObj crearSalesOrderLineObjSubPlan(SubPlanFacturacion__c cp) {
        SalesOrderLineObj salesObj = new SalesOrderLineObj();

        salesObj.servAd = new LTE_Servicios_adicionales__c();
        salesObj.servAd.Name = cp.Name;
        salesObj.servAd.LTE_ItemIdentification__c = cp.Id;
        salesObj.servAd.LTE_NetworkIndicator__c = cp.LTE_NetworkIndicator__c;
        salesObj.servAd.LTE_ServiceIndicator__c = cp.LTE_ServiceIndicator__c;
        salesObj.servAd.LTE_PrimaryClassificationCode__c = cp.LTE_PrimaryClassificationCode__c;
        salesObj.servAd.LTE_TypeCode__c = cp.LTE_TypeCode__c;
        //salesObj.servAd.LTE_SubPlaFacturacion__c=cp.LTE_SubPlaFacturacion__c;

        list<ParametroFacturacion__c>par = cp.Parametros_de_Facturacion__r;

        for (ParametroFacturacion__c p : par) {
            salesObj.sXA.add(construirSpecXA(p));
        }
        return salesObj;
    }



    public static void obtenerNoEstructurado(map<Id, LTE_Servicios_adicionales__c> detaOfSubpl) {

        set<id> ids = new set<id>();

        //Obtiene todos los Id de los Subplanes de los Servicios_adicionales
        for (Id idSubp : detaOfSubpl.keySet()) {
            ids.add(detaOfSubpl.get(idSubp).LTE_SubPlaFacturacion__c);
        }


        //Obtiene la informacion para construir los datos del ItemIdentification y SpecificationGroupXA
        map<Id, SubPlanFacturacion__c> subFact = new map<Id, SubPlanFacturacion__c>([select id, name,
                LTE_NetworkIndicator__c, LTE_PrimaryClassificationCode__c, LTE_ServiceIndicator__c, LTE_TypeCode__c,
                (select id, name, Campo__c, Comillas__c, LTE_ValorDefecto__c, LTE_Funcion__c from Parametros_de_Facturacion__r)
                from SubPlanFacturacion__c where Id IN : Ids]);

        //Parametros agrupados por subplan
        map<Id, list<ParametroFacturacion__c>> paramOrd = new map<Id, list<ParametroFacturacion__c>>();
        for (id i : subFact.keyset()) {
            paramOrd.put(subFact.get(i).Id, subFact.get(i).Parametros_de_Facturacion__r);
        }

        system.debug(paramOrd);

        //Parametros Generico crea una instancia de un LTE_SpecificationGroupXA__c esta sera duplicada para cada servicio adicional
        Map<Id, list<LTE_SpecificationGroupXA__c>> lstSpecXA = new Map<Id, list<LTE_SpecificationGroupXA__c>>();

        //crea los datos del ItemIdentification y los LTE_SpecificationGroupXA__c
        for (Id idSubp : detaOfSubpl.keySet()) {
            system.debug(detaOfSubpl.get(idSubp));
            system.debug(idSubp);

            LTE_Servicios_adicionales__c detOf = detaOfSubpl.get(idSubp);
            detOf.Name = subFact.get(detOf.LTE_SubPlaFacturacion__c).Name;
            detOf.LTE_NetworkIndicator__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).LTE_NetworkIndicator__c;
            detOf.LTE_ServiceIndicator__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).LTE_ServiceIndicator__c;
            detOf.LTE_PrimaryClassificationCode__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).LTE_PrimaryClassificationCode__c;
            detOf.LTE_TypeCode__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).LTE_TypeCode__c;
            detOf.LTE_ItemIdentification__c = subFact.get(detOf.LTE_SubPlaFacturacion__c).id;

            list<ParametroFacturacion__c> parametros = paramOrd.get(detOf.LTE_SubPlaFacturacion__c);

            if (parametros != null) {
                for (ParametroFacturacion__c p : parametros) {
                    system.debug('Ingreso');
                    if (lstSpecXA.get(idSubp) == null) {
                        lstSpecXA.put(idSubp, new list<LTE_SpecificationGroupXA__c>());
                    }
                    lstSpecXA.get(idSubp).add(construirSpecXA(p));
                }
            }

            system.debug(lstSpecXA);

            list<LTE_SpecificationGroupXA__c> finalSpeXG = new list<LTE_SpecificationGroupXA__c>();
            map<string,LTE_SpecificationGroupXA__c> finalSpeXGMap=new map<string,LTE_SpecificationGroupXA__c>();

            for (Id idSub : detaOfSubpl.keySet()) {
                //obtiene la instancia generica y crea el SpecificationGroupXA
                list<LTE_SpecificationGroupXA__c>lstSpgXa = lstSpecXA.get(idSubp);
                system.debug(lstSpgXa);


                for (LTE_SpecificationGroupXA__c sGXA : lstSpgXa) {
                    
                    finalSpeXGMap.put(sGXA.Name+idSubp,new LTE_SpecificationGroupXA__c(
                                       Name = sGXA.Name,
                                       LTE_ServiciosAdicionales__c = idSubp,
                                       LTE_Value__c = sGXA.LTE_Value__c,
                                       LTE_ParametroFacturacion__c=sGXA.LTE_ParametroFacturacion__c
                                       ));

                }

            }
            list<Sobject> upsertObj = new list<Sobject>();
            insert finalSpeXGMap.values();
            update detaOfSubpl.values();

        }
    }

    //Contiene la logica para el manejo de parametros
    public static LTE_SpecificationGroupXA__c construirSpecXA(ParametroFacturacion__c p) {
        LTE_SpecificationGroupXA__c SpecXA = new LTE_SpecificationGroupXA__c();
        SpecXA.Name = p.Name;
        SpecXA.LTE_ParametroFacturacion__c = p.Id;
        
        system.debug(SpecXA.Name+' '+p.Id);

        if (p.LTE_ValorDefecto__c != null) {
            SpecXA.LTE_Value__c = p.LTE_ValorDefecto__c;
        }
        system.debug('AQUI:'+SpecXA);
        return SpecXA;

    }


    public class SalesOrderLineObj {

        public LTE_Servicios_adicionales__c servAd = new LTE_Servicios_adicionales__c();
        public list<LTE_SpecificationGroupXA__c> sXA = new list<LTE_SpecificationGroupXA__c>();

        public list<LTE_SpecificationGroupXA__c> asignarId() {
            for (LTE_SpecificationGroupXA__c sx : sXA) {
                sx.LTE_ServiciosAdicionales__c = servAd.Id;
            }
            return sXA;
        }
    }

    public class SalesOrdelineXML {
        public list<LTE_Servicios_adicionales__c> sa = new list<LTE_Servicios_adicionales__c>();
        public list<LTE_Servicios_adicionales__c> saActivo = new list<LTE_Servicios_adicionales__c>();

        public LTE_DetalleOferta__c dof=new LTE_DetalleOferta__c();
        public OperacionComercial__c oc = new OperacionComercial__c();
        public Map<Id,string>parentMaId;
        public list<LTE_SpecificationGroupXA__c> lstSgXa=new list<LTE_SpecificationGroupXA__c>();
        private tramiteLTE tr;
        private string actionCode;
        private boolean mapearElCampo=true;
        

        public string getBody() {

            tr = new tramiteLTE(Oc);


            HomologacionCampos__c homologacion = HomologacionCampos__c.getValues('Aprov'+Oc.CuentaCliente__r.Tipodedocumento__c);

            string SalesOrderLine = '';
            
            //LTE_Tramites_cls clase Dinamica
            string c ='LTE_TipodeOperacionProducto.'+LibreriaUtilitaria_cls.quitarCaracteresEsp(oc.Topp__r.TipodeOperacionporplan__c.deleteWhitespace());

            Type t = Type.forName(c);
            if(t!=null){
                LTE_Tramites_cls.Step paso =(LTE_Tramites_cls.Step) t.newInstance();
                paso.oc=this.oc;
                paso.sa=sa;
                paso.saActivo=saActivo;
                paso.procesar();
                actionCode=paso.accion;
                
                
                //Aplica principalmente para cambio de numero
                if(!paso.SpecGroupXAList.isEmpty()){
                    //upsert paso.SpecGroupXAList;            
                }
                sa=paso.sa;
                saActivo=paso.saActivo;
            }

            


            map<String, String> mapIdServAdic = new map<String, String>(); //LRPA 06-01-2015
            
            system.debug(oc.id);
            mapearElCampo=true;
            if (sa != null) {
                for (LTE_Servicios_adicionales__c saXA : sa) {
                    SalesOrderLine += getSalesOrderLine(saXA);
                    //mapIdServAdic.put(saXA.id,saXA.id);                       //LRPA 06-01-2015
                }
            }
            
            //Obtiene los relacionados con el servicio para tramites
            system.debug('mapIdServAdic-->'+mapIdServAdic);
            system.debug('saActivo-->'+saActivo);
            mapearElCampo=false;
            if (saActivo != null) {
                for (LTE_Servicios_adicionales__c saXA : saActivo) {
                    if(saXA!=null){
                        system.debug('saXA.id-->'+saXA.id);
                        //if(!mapIdServAdic.containskey(saXA.id)){              //LRPA 06-01-2015 No sacar dos veces el salesorderline del nuevo plan
                            SalesOrderLine += getSalesOrderLine(saXA);
                        //}
                    }
                }
            }
            
            string InvoicingCycle ='';
            
            if(oc.Plan__r.LTE_TipoControl__c=='Prepago'){
                InvoicingCycle='1';
            }
            else{
                InvoicingCycle =oc.CuentaFacturacion__r.LTE_CicloFacturacion__c;
            }
           
           ////INI9685-22/08/2018. Adición de Altkey ServiceId para envio a Tibco
           string addServiceId='';  
        
           if(tr.OrderType=='Venta LTE'){  
                addServiceId=oc.Activo__c;      
            }else{
               addServiceId=oc.Activo__c+'-'+oc.Id;
            }
            
           ////INI-08/11/2018. Adición de Altkey NOMBRES para envio a Tibco
           string NOMBRES='';  
        
           if(oc.CuentaCliente__r.Tipodedocumento__c =='Cédula de ciudadanía' || oc.CuentaCliente__r.Tipodedocumento__c =='Cedula Extranjeria'){  
                NOMBRES= oc.CuentaCliente__r.Primer_Nombre__c + ' ' + oc.CuentaCliente__r.Segundo_Nombre__c;
        
            }else{
                NOMBRES= LibreriaUtilitaria_cls.normalizarString(oc.CuentaCliente__r.Name);
            }


            string xml = '<?xml version="1.0" encoding="UTF-8" ?>'
                         + '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/ProvisioningLTECorp/Delivery/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/NPlay/canonical/CanonicalMessage/v1.0">'
                         + '<soapenv:Header/>'
                         + '<soapenv:Body>'
                         + '<ns:WSDeliveryLTERequest>'
                         + '<v1:WSRequestHeader>'
                         + '<v1:System correlationID="' + Oc.Id + '" processingServer="Salesforce">Salesforce</v1:System>'
                         + '<v1:Property name="" value=""></v1:Property>'
                         + '</v1:WSRequestHeader>'
                         + '<v11:CanonicalMessage>'
                         + '<v11:OrderFulfilment>'
                         + '<Identification>'
                         + '<ID>' + Oc.Id + '</ID>'
                         + '<BusinessComponentID>' + Oc.Id + '</BusinessComponentID>'
                         + '<ApplicationObjectKeyID>' + Oc.Id + '</ApplicationObjectKeyID>'
                         + '<RevisionNumber>1</RevisionNumber>'
                         + '</Identification>'
                         + '<SalesOrder>'
                         + '<OrderDateTime>' + LibreriaUtilitaria_cls.formatosFechasAprob(1, oc.CreatedDate) + '</OrderDateTime>'
                         + '<DeliveryDateTime>' + DeliveryDateTime(1, oc, tr) + '</DeliveryDateTime>'
                         + '<TypeCode>SALES ORDER</TypeCode>'
                         + '<FulfilmentPriorityCode>4</FulfilmentPriorityCode>'
                         + '<FulfilmentModeCode>DELIVER</FulfilmentModeCode>'
                         + '<StatusCode>OPEN</StatusCode>'
                         + '</SalesOrder>'
                         + '<BusinessReference>'
                         + '<Id>' + UserInfo.getOrganizationId() + '</Id>'
                         + '<ComponentId>' + UserInfo.getOrganizationId() + '</ComponentId>'
                         + '<ApplicationObjectKeyId>' + UserInfo.getOrganizationId() + '</ApplicationObjectKeyId>'
                         + '</BusinessReference>'
                         + '<CustomerPartyAccount>'
                         + '<Identification>'
                         + '<ID>' + oc.CuentaCliente__c + '</ID>'
                         + '<BusinessComponentID>' + oc.CuentaCliente__c + '</BusinessComponentID>'
                         + '<ApplicationObjectKeyID>' + oc.CuentaCliente__c + '</ApplicationObjectKeyID>'
                         + '</Identification>'
                         + '<Name>' + LibreriaUtilitaria_cls.normalizarString(oc.CuentaCliente__r.Name) + '</Name>'  //MC
                         + '<Address>'
                         + '<Identification>'
                         + '<ID/>'
                         + '<BusinessComponentID/>'
                         + '<ApplicationObjectKeyID/>'
                         + '</Identification>'
                         + '<LineOne>' + oc.SucursalDestino__r.Direccion__c + '</LineOne>'
                         + '<CityName>' + oc.SucursalDestino__r.Ciudad__r.Name + '</CityName>'
                         + '<StateName>' + oc.SucursalDestino__r.Ciudad__r.Padre__r.Name + '</StateName>'
                         + '<CountryCode>57</CountryCode>'
                         + '<CountryName>Colombia</CountryName>'
                         + '<GisID/>'
                         + '<Latitude/>'
                         + '<Longitude/>'
                         + '<CityCode>' + oc.SucursalDestino__r.Ciudad__r.CodigoDane__c + '</CityCode>'
                         + '<StateCode>25</StateCode>'
                         + '<PurposeCode/>'
                         + '<Reference>N/A</Reference>'
                         + '<Technology>'
                         + '<Type/>'
                         + '<CoverageType/>'
                         + '<CoverageIndicator>false</CoverageIndicator>'
                         + '<CoverageName/>'
                         + '<Zone/>'
                         + '</Technology>'
                         + '</Address>'
                         + '<ContactPerson>'
                         + '<FirstName/>'
                         + '<FamilyName/>'
                         + '<CompleteNumber/>'
                         + '</ContactPerson>'
                         + '<TypeCode>'+(oc.CuentaCliente__r.Tipodedocumento__c=='NIT'?'2':'1')+'</TypeCode>'
                         //+ '<TypeCode>BUSINESS</TypeCode>'
                         + '<Custom>'
                         + '<DocumentType>' + homologacion.Valor__c + '</DocumentType>'
                         + '<DocumentNumber>' + Oc.CuentaCliente__r.AccountNumber + '</DocumentNumber>'
                         + '</Custom>'
                         + '</CustomerPartyAccount>'
                         + '<Custom>'
                         + '<OrderSubType>' + tr.OrderSubtypeAprob + '</OrderSubType>'
                         + '<SignedDocumentIndicator>true</SignedDocumentIndicator>'
                         + '</Custom>'
                         + '<PartyIdentification>'
                         + '<ID>' + Oc.CuentaCliente__r.OwnerId + '</ID>'
                         + '<BusinessComponentID>' + Oc.CuentaCliente__r.OwnerId + '</BusinessComponentID>'
                         + '<ApplicationObjectKeyID>' + Oc.CuentaCliente__r.OwnerId + '</ApplicationObjectKeyID>'
                         + '</PartyIdentification>'
                         + SalesOrderLine
                         + '<Scheduling>'
                         + '<SubOrderType>' + tr.OrderSubtype + '</SubOrderType>'
                         + '</Scheduling>'
                         + '<AltKey>'////INI9685-21/08/2018. Adición de Altkey SDP para envio a Tibco
                         + '<AltKeyName>SDP</AltKeyName>'
                         + '<AltKeyValue>' + oc.SDP__c + '</AltKeyValue>'
                         + '</AltKey>'
                         + '<AltKey>'////INI9685-22/08/2018. Adición de Altkey ServiceId para envio a Tibco
                         + '<AltKeyName>ServiceId</AltKeyName>'
                         + '<AltKeyValue>' + addServiceId + '</AltKeyValue>'
                         + '</AltKey>'
                         + '<AltKey>'////INI-07/11/2018. Adición de Altkey NOMBRES para envio a Tibco
                         + '<AltKeyName>NOMBRES</AltKeyName>'
                         + '<AltKeyValue>' + NOMBRES + '</AltKeyValue>'
                         + '</AltKey>'
                         + '<AltKey>'////INI-07/11/2018. Adición de Altkey APELLIDO1 para envio a Tibco
                         + '<AltKeyName>APELLIDO1</AltKeyName>'
                         + '<AltKeyValue>' + oc.CuentaCliente__r.Primer_Apellido__c + '</AltKeyValue>'
                         + '</AltKey>'
                         + '<AltKey>'////INI-07/11/2018. Adición de Altkey APELLIDO2 para envio a Tibco
                         + '<AltKeyName>APELLIDO2</AltKeyName>'
                         + '<AltKeyValue>' + oc.CuentaCliente__r.Segundo_Apellido__c + '</AltKeyValue>'
                         + '</AltKey>';                                             
                        if(oc.TOPP__r.TipodeOperacionporplan__c == 'Venta'){
                            //Se incluyen AltKey cuando la línea a aprovisionar hacer parte de bolsas compartidas
                            if(oc.Tipo_linea_bolsa_compartida__c == 'Padre'){
                                xml  += '<AltKey>'
                                 +  '<AltKeyName>IsProvider</AltKeyName>'
                                 +  '<AltKeyValue>Y</AltKeyValue>'
                                 +  '</AltKey>'
                                 +  '<AltKey>'
                                 +  '<AltKeyName>ProviderNumber</AltKeyName>'
                                 +  '<AltKeyValue>57'+oc.NumeroConexion__c+'</AltKeyValue>'
                                 +  '</AltKey>';
                            }
                            if(oc.Tipo_linea_bolsa_compartida__c == 'Hija'){
                            xml  += '<AltKey>'
                                 +  '<AltKeyName>IsConsumer</AltKeyName>'
                                 +  '<AltKeyValue>Y</AltKeyValue>'
                                 +  '</AltKey>'
                                 +  '<AltKey>'
                                 +  '<AltKeyName>ProviderNumber</AltKeyName>'
                                 +  '<AltKeyValue>57'+oc.Operacion_Comercial_Relacionada__r.NumeroConexion__c+'</AltKeyValue>'
                                 +  '</AltKey>'
                                 +  '<AltKey>'
                                 +  '<AltKeyName>ConsumerNumber</AltKeyName>'
                                 +  '<AltKeyValue>57'+oc.NumeroConexion__c+'</AltKeyValue>'
                                 +  '</AltKey>';
                            }                            
                            //Fin Adición AltKey para bolsas compartidas                            
                        }
                        if(tr.ReconexionEjecutaPAM){
                           xml  += '<AltKey>'
                                +  '<AltKeyName>DeactivateActivatePAM</AltKeyName>'
                                +  '<AltKeyValue>Y</AltKeyValue>'
                                + '</AltKey>';
                         }
                   xml   += '</v11:OrderFulfilment>'
                         + '<v11:BillingProcess>'
                         + '<CustomerBill>'
                         + '<InvoicingCycle>' + InvoicingCycle + '</InvoicingCycle>'
                         + '</CustomerBill>'
                         + '</v11:BillingProcess>'
                         + '</v11:CanonicalMessage>'
                         + '</ns:WSDeliveryLTERequest>'
                         + '</soapenv:Body>'
                         + '</soapenv:Envelope>';
                         //tr.OrderSubtype

            return xml;
        }

        public SalesOrdelineXML(list<LTE_Servicios_adicionales__c> sa, OperacionComercial__c oc,LTE_DetalleOferta__c dof, Map<Id,string>parentMaId,list<LTE_Servicios_adicionales__c> saActivo) {
            this.sa = sa;
            this.oc = oc;
            this.dof = dof;
            this.parentMaId=parentMaId;
            this.saActivo=saActivo;
            
            system.debug(this.saActivo);
        }

        public string getSalesOrderLine(LTE_Servicios_adicionales__c saItem) {
            
            if(saItem==null){
                return '';          
            }

            if(parentMaId.get(oc.Id)!=saItem.Id){
                saItem.LTE_ParentId__c=parentMaId.get(oc.Id);   
            }
            Integer cantParamClass = 0;
            for (LTE_SpecificationGroupXA__c xa : saItem.SpecificationGroupXA__r) {
                if (oc.TOPP__r.TipodeOperacionporplan__c == 'Retiro' || oc.TOPP__r.TipodeOperacionporplan__c == 'Retiro SVA'){
                   if(xa.Name == 'OFFER CLASSE OCS')
                       cantParamClass ++;
                   if(xa.Name == 'OFFER CLASS OCS')
                       cantParamClass ++;    
                }
            }
            
            string xml = '<SalesOrderLine>'
                         + '<Identification>'
                         + '<ID>' + saItem.Id + '</ID>'
                         + '<BusinessComponentID>' + saItem.Id + '</BusinessComponentID>'
                         + '<ApplicationObjectKeyID>' + saItem.Id + '</ApplicationObjectKeyID>'
                         + '</Identification>'
                         + '<OrderQuantity>1</OrderQuantity>'
                         + '<ServiceActionCode>' + saItem.LTE_ServiceActionCode__c + '</ServiceActionCode>'
                         + '<FulfilmentModeCode>DO</FulfilmentModeCode>'
                         + '<ParentSalesOrderLineIdentification>'
                         + '<ID>' + saItem.LTE_ParentId__c + '</ID>'
                         + '<BusinessComponentID>' + saItem.LTE_ParentId__c + '</BusinessComponentID>' 
                         + '<ApplicationObjectKeyID>' + saItem.LTE_ParentId__c +'</ApplicationObjectKeyID>' 
                         + '</ParentSalesOrderLineIdentification>'
                         + '<RootParentSalesOrderLineIdentification>'
                         + '<ID>' + saItem.LTE_ParentId__c + '</ID>'
                         + '<BusinessComponentID>' + saItem.LTE_ParentId__c + '</BusinessComponentID>'
                         + '<ApplicationObjectKeyID>' + saItem.LTE_ParentId__c + '</ApplicationObjectKeyID>'
                         + '</RootParentSalesOrderLineIdentification>'
                         + '<StatusCode>OPEN</StatusCode>'
                         + '<ServiceAddress>'
                         + '<Identification>'
                         + '<ID>' + saItem.LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__c + '</ID>'
                         + '<BusinessComponentID>' + saItem.LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__c + '</BusinessComponentID>'
                         + '<ApplicationObjectKeyID>' + saItem.LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__c + '</ApplicationObjectKeyID>'
                         + '</Identification>'
                         + '<LineOne>' + saItem.LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Direccion__c + '</LineOne>'
                         + '<CityName>' + saItem.LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Name + '</CityName>'
                         + '<StateName>' + saItem.LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.Padre__r.Name + '</StateName>'
                         + '<CountryCode>57</CountryCode>'
                         + '<CountryName>Colombia</CountryName>'
                         + '<GisID/>'
                         + '<Latitude/>'
                         + '<Longitude/>'
                         + '<CityCode>' + saItem.LTE_DetalleOfertaEReservadoRegContable__r.LTE_Sucursal__r.Ciudad__r.CodigoDane__c + '</CityCode>'
                         + '<StateCode>25</StateCode>'
                         + '<PurposeCode/>'
                         + '<Reference/>'
                         + '<Technology>'
                         + '<Type/>'
                         + '<CoverageType>Molecula</CoverageType>'
                         + '<CoverageIndicator>false</CoverageIndicator>'
                         + '<CoverageName/>'
                         + '<Zone/>'
                         + '</Technology>'
                         + '</ServiceAddress>'
                         + '<ItemReference>'
                         + '<ItemIdentification>'
                         + '<ID>' + saItem.LTE_ItemIdentification__c + '</ID>'
                         + '<BusinessComponentID>' + saItem.LTE_ItemIdentification__c + '</BusinessComponentID>'
                         + '<ApplicationObjectKeyID>' + saItem.LTE_ItemIdentification__c + '</ApplicationObjectKeyID>'
                         + '</ItemIdentification>'
                         + '<Name>' + saItem.Name + '</Name>'
                         + '<ServiceIndicator>' + saItem.LTE_ServiceIndicator__c + '</ServiceIndicator>'
                         + '<TypeCode>' + saItem.LTE_TypeCode__c + '</TypeCode>'
                         + '<NetworkIndicator>' + saItem.LTE_NetworkIndicator__c + '</NetworkIndicator>'
                         + '<PrimaryClassificationCode>' + ((saItem.LTE_PrimaryClassificationCode__c == 'LTE SVA Package Class' && cantParamClass == 2)?'LTE SVA Recurring Package Class':saItem.LTE_PrimaryClassificationCode__c) + '</PrimaryClassificationCode>'
                         + '</ItemReference>'
                         + '<SalesOrderSchedule>'
                         + '<RequestedDeliveryDate>'+DeliveryDateTime(1, oc, tr)+'</RequestedDeliveryDate>'//LibreriaUtilitaria_cls.formatosFechasAprob(1, Datetime.Now())
                         + '<ExpectedDeliveryDate>'+DeliveryDateTime(1, oc, tr)+'</ExpectedDeliveryDate>'
                         + '<ShipTo>'
                         + '<GisID/>'
                         + '<Latitude/>'
                         + '<Longitude/>'
                         + '<CityCode/>'
                         + '<StateCode/>'
                         + '<PurposeCode/>'
                         + '<Reference/>'
                         + '<Technology>'
                         + '<Type/>'
                         + '<CoverageType/>'
                         + '<CoverageIndicator>false</CoverageIndicator>'
                         + '<CoverageName/>'
                         + '<Zone/>'
                         + '</Technology>'
                         + '</ShipTo>'
                         + '</SalesOrderSchedule>'
                         + '<OwnerPartyReference>'
                         + '<ID>' + oc.CuentaCliente__r.OwnerId + '</ID>'
                         + '<BusinessComponentID>' + oc.CuentaCliente__r.OwnerId + '</BusinessComponentID>'
                         + '<ApplicationObjectKeyID>' + oc.CuentaCliente__r.OwnerId + '</ApplicationObjectKeyID>'
                         + '</OwnerPartyReference>'
                         + '<ScheduleOrderIndicator>false</ScheduleOrderIndicator>'
                         + '<Discounts/>'
                         + getSpecificationGroupXA(saItem.SpecificationGroupXA__r,saItem)
                         + '<Custom>'
                         + '<PartNumber/>'
                         + '<AssetIntegrationID>' + oc.Activo__r.Name + '</AssetIntegrationID>'
                         + '</Custom>'
                         + '</SalesOrderLine>';

            return xml;
        }

        public string getSpecificationGroupXA(list<LTE_SpecificationGroupXA__c> itemXA,LTE_Servicios_adicionales__c saInfo) {
            
            if (itemXA.isEmpty()) {

                return  '';
            }

            string xml = '';
            system.debug(itemXA.size());
            for (LTE_SpecificationGroupXA__c xa : itemXA) {

                system.debug('SpecificationGroupXA:'+saInfo.Name+'-->'+xa.Name+' '+mapearElCampo+' '+xa.LTE_ParametroFacturacion__r.Campo__c);
                if (xa.LTE_ParametroFacturacion__r.Objeto__c != null && xa.LTE_ParametroFacturacion__r.Campo__c != null && mapearElCampo && oc.TOPP__r.TipodeOperacionporplan__c == 'Venta') {
                    xa.LTE_Value__c=mapearCampo(xa.LTE_ParametroFacturacion__r.Objeto__c,xa.LTE_ParametroFacturacion__r.Campo__c,saInfo);
                    if(String.isEmpty(xa.LTE_Value__c)&& String.isNotEmpty(xa.LTE_ParametroFacturacion__r.LTE_ValorDefecto__c)){
                        xa.LTE_Value__c = xa.LTE_ParametroFacturacion__r.LTE_ValorDefecto__c;
                    }
                }

                xml += '<SpecificationGroupXA>'
                       + '<XAID>' + xa.Id + '</XAID>'
                       + '<ParentID>' + xa.LTE_ServiciosAdicionales__c + '</ParentID>'
                       + '<ID>' + xa.Id + '</ID>'
                       + '<ActionCode>' + xa.LTE_ActionCode__c + '</ActionCode>'
                       + '<Name>' + xa.Name + '</Name>'
                       + '<Value>' + xa.LTE_Value__c + '</Value>'
                       + '</SpecificationGroupXA>';
                       
                lstSgXa.add(xa);

            }

            return xml;

        }

        public string mapearCampo(string objeto,string campo,LTE_Servicios_adicionales__c saInfo) {
            string valor = '';
            Sobject sOBJd;
            
            system.debug(saInfo.name+' '+'elObjeto:'+objeto+' elCampo:'+campo+' losValores:'+saInfo.LTE_NivelDescuento__r+'\n'+saInfo.id);
            if(campo=='LTE_NivelDescuento__r.LTE_DescuentoNivel3__c'){
                system.debug(saInfo.id+' '+saInfo.LTE_NivelDescuento__r.LTE_DescuentoNivel3__c);
            }
            
            
            if(objeto=='OperacionComercial__c'){
                sOBJd= oc;
            }else if(objeto=='LTE_DetalleOferta__c'){
                sOBJd=dof;
            }else if(objeto=='LTE_Servicios_adicionales__c'){
                sOBJd=saInfo;           
            }
            system.debug(sOBJd+' '+Campo);
            valor=LibreriaUtilitaria_cls.recorreCampos(sOBJd,Campo);

            system.debug(valor);

            return valor;
        }
        
    }


    public class tramiteLTE {

        public string OrderType = '';
        public string OrderSubtype = '';
        public string OrderSubtypeAprob = '';
        public string ServiceActionCode = '';
        public string SubOrderType = '';
        public string OrderNumCategory = '';
        public Boolean ReconexionEjecutaPAM = false;

        public tramiteLTE(OperacionComercial__c oc) {
            system.debug('Procesar Tramite');
            system.debug(oc.TOPP__r);
            system.debug('\n\n================\n'+oc.TOPP__r.TipodeOperacionporplan__c+'\n================\n\n');
            
            OrderSubtypeAprob='NORMAL';

            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Venta') {
                SubOrderType = 'Venta LTE';
                OrderType = 'Venta LTE';
                ServiceActionCode = 'ADD';
                OrderSubtype = 'Venta LTE';
                if (oc.Portacion__c) {
                    OrderSubtype = 'Venta LTE NCP';
                }
            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Suspensión') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'SUSPEND';
                if (oc.TipoSuspension__c=='Perdida') {
                    OrderSubtype = 'Suspension por Perdida';
                }
                
                if (oc.TipoSuspension__c=='Robo') {
                    OrderSubtype = 'Suspension por Robo';
                }
                
                if (oc.TipoSuspension__c=='Voluntaria') {
                    OrderSubtype = 'Suspension Voluntaria';
                }


            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Reconexión') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'RESUME';
                if (oc.TipoSuspension__c=='Voluntaria') {
                    OrderSubtype = 'Reconexion Voluntaria';                    
                    verificarEjecucionPAMenReconexion(oc);
                } else{
                    OrderSubtype = 'Reconexion por Perdida o Robo';
                }

            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Retiro') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'DELETE';
                OrderSubtype = 'Cancelacion Voluntaria';

            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Renovación') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                
                if(oc.LTE_TipoTransaccion__c=='Equipo más SIM'){
                    OrderSubtype = 'Renovacion Equipo mas SIM';
                }
                
                if(oc.LTE_TipoTransaccion__c=='SIM'){
                    OrderSubtype = 'Renovacion Sim';
                }

            }
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Reposición') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                
                if(oc.LTE_TipoTransaccion__c=='Equipo más SIM'){
                    OrderSubtype = 'Renovacion Equipo mas SIM';
                }
                
                if(oc.LTE_TipoTransaccion__c=='SIM'){
                    OrderSubtype = 'Renovacion Sim';
                }

            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio de Plan') {
                OrderType = 'Cambio de Plan';
                OrderSubtype='Cambio de Plan';
            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Cambio Número') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                OrderSubtype = 'Modificacion Cambio Numero LTE';
            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Adición SVA') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                OrderSubtype = 'Adicion SVA';
            }
            
            if (oc.TOPP__r.TipodeOperacionporplan__c == 'Retiro SVA') {
                OrderType = 'Tramites LTE';
                ServiceActionCode = 'UPDATE';
                OrderSubtype = 'Desactivacion SVA';
            }
            
            

        }
        public Boolean verificarEjecucionPAMenReconexion(OperacionComercial__c oc){
            Date sysDate            = Date.today();                     
            Integer DayNow          = SysDate.Day();   
                                   
            if(oc.CuentaFacturacion__r.LTE_CicloFacturacion__c != null){                
                Integer diaCicloFact    = integer.valueof(oc.CuentaFacturacion__r.LTE_CicloFacturacion__c);                                                         
                if(DayNow != diaCicloFact){                    
                    if(oc.Activo__r.LTE_Fecha_Ultima_Suspension__c != null){                        
                        Date fechaUltimaSusp     = oc.Activo__r.LTE_Fecha_Ultima_Suspension__c; 
                        Date fechaCicloSuspen    = Date.newInstance(fechaUltimaSusp.year(), fechaUltimaSusp.month(), diaCicloFact);                     
                        Date fechaCicloSiguiente = fechaCicloSuspen.addMonths(1);
                                                
                        if(sysDate >= fechaCicloSiguiente)
                            ReconexionEjecutaPAM = true;                        
                    }else
                        ReconexionEjecutaPAM = true;                        
                }   
            }            
            return ReconexionEjecutaPAM;
        }
    }





}