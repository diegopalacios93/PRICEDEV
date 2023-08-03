/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Luis Penaranda
Proyecto:               ETB - LTE Fase 1
Descripci?n:            Batch para procesar las operaciones comerciales LTE que se deben enviar a facturacion
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0     23-01-2015  Luis Penaranda(LRP)         Creacion de la clase 
1.1     26-11-2015  Luis Penaranda (LRP)        Adición de lógica para Cambio de Plan
1.2     02-02-2016  Andrés Garrido (AG)         Adición de lógica para Cambio de Número
*******************************************************************************/
global class LTE_Facturacion_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {
    
    global boolean limitQ=false;
    global integer limiteTotal=30;
    global boolean esVIP=false;
    global set<id>idImediato=new set<id>();
    
    global Database.Querylocator start(Database.Batchablecontext bc)
    {
        normalizarEstados();
        Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
        string producto=vGlobal.get('NombreComercialLTE').valor__c;
        
        
        String query = 'Select id,TOPP__c,TOPP__r.Name,Activo__c,FechaInicioReconexion__c,CuentaCliente__c,Legalizacion__r.LTE_CuentaFacturacion__r.LTE_CicloFacturacion__c,LTE_TipoTransaccion__c,EnviadaFacturacionEquipo__c,Legalizacion__r.Estado__c,Legalizacion__r.Cuotas__c,TOPP__r.TipodeOperacionporplan__c,IMEI_del_Equipo__c,Plan__r.LTE_MetodoDePago__c, TipoSuspension__c,NumeroCanales__c,Valorunicavez__c,Valor__c,Tarifa_mensual_Bolsa_de_Moviles__c,Tarifa_mensual_Troncales_SIP__c,Plan__r.Name';    
         query +=' From OperacionComercial__c '; 
         query +=' Where TOPP__r.LTE_Catalogo_de_Producto__r.Name=\''+producto+'\' and  (Plan__r.NombredelProducto__r.Name=\''+producto+'\'  or Plan__r.NombredelProducto__r.Name=\'EQUIPO LTE\')';
         //query +=' and Tipo_linea_bolsa_compartida__c != \'Hija\' ';               
         query +=' and  (FechadeActivacion__c != null or TOPP__r.TipodeOperacionporplan__c = \'Adición SVA\' or TOPP__r.TipodeOperacionporplan__c = \'Retiro SVA\'  or TOPP__r.TipodeOperacionporplan__c = \'Cambio Número\' or ( TOPP__r.TipodeOperacionporplan__c = \'Cambio de Plan\' and FechaInicioReconexion__c != null) or ((TOPP__r.TipodeOperacionporplan__c = \'Suspensión\' or TOPP__r.TipodeOperacionporplan__c = \'Reconexión\') and TipoSuspension__c=\'Voluntaria\') ) and TOPP__c != null and (';
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Venta\' and Estado__c=\'Activa\' and Legalizacion__r.Estado__c=\'Gestionado\')    or';  // PVTA LRPA - 26-11-2015
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Venta Equipos\' and Estado__c=\'Activa\' and Legalizacion__r.Estado__c=\'Gestionado\' and Legalizacion__r.Cuotas__c !=0 and EnviadaFacturacionEquipo__c=false) or'; //AG 2016-02-10 Condición para que tome las ventas de equipo con cuotas diferente de 0
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Retiro\' and Estado__c=\'Inactivo\') or';
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Cambio de Plan\' and Estado__c=\'Activa\') or';         
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Modificación Servicio\' and Estado__c=\'Activa\' and Valorunicavez__c > 0) or';         
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Modificación Estándar\' and Estado__c=\'Activa\' and Valorunicavez__c > 0 and Detalle_del_tramite__c = \'Traslado Interno\') or';         
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Cambio Número\' and Estado__c=\'Activa\') or'; //AG 2016-02-03 Condición para que tome el cambio de numero
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Suspensión\' and TipoSuspension__c=\'Voluntaria\' and Estado__c=\'Suspendido\') or'; //AG 2016-02-03 Condición para que tome la suspensión voluntaria
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Reconexión\' and TipoSuspension__c=\'Voluntaria\' and Estado__c=\'Activa\') or'; //AG 2016-02-03 Condición para que tome la suspensión voluntaria
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Adición SVA\' and (categoria__c=\'Bolsa Recurrente\' or categoria__c=\'Seguro de terminales\') and (Estado__c=\'Activa\' or Estado__c=\'Pendiente Facturacion\') ) or'; //AG 2016-02-19 Condición para que tome Adición de SVA
         query +=' (TOPP__r.TipodeOperacionporplan__c = \'Retiro SVA\' and (categoria__c=\'Bolsa Recurrente\' or categoria__c=\'Seguro de terminales\') and (Estado__c=\'Activa\' or Estado__c=\'Pendiente Facturacion\') ) or'; //AG 2016-02-19 Condición para que tome Retiro de SVA
         query +=' ((TOPP__r.TipodeOperacionporplan__c = \'Renovación\'  or TOPP__r.TipodeOperacionporplan__c = \'Reposición\') and LTE_TipoPago__c != \'Inmediato\' and ((LTE_TipoTransaccion__c =  \'Equipo más SIM\' and  Estado__c=\'Activa\' ) or (LTE_TipoTransaccion__c =  \'Equipo\' and Estado__c=\'Equipo entregado\'))))';

        
        if(esVIP){
            query+=' AND LTE_AplicaOnline__c=true ';
        }
        
        if(!idImediato.isEmpty()){
            query+=' AND id IN :idImediato ';   
        }
                  
        if(limitQ){
            query+=' Limit '+limiteTotal+' ';       
        }        
        system.debug('\nConsultaBatchFacturación: '+query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope)
    {        
		//llamar todas las operaciones comerciales que tengan el check habilitado.
		EjecucionIntegracion__c integra =EjecucionIntegracion__c.getValues('Facturacion');
        if(integra!=null && integra.Ejecucion__c==true)
		{
            LTE_ConstruccionCanonico_cls canonico = new LTE_ConstruccionCanonico_cls();
            canonico.CrearFacturacion(scope);
        }
    }
    global void finish(Database.BatchableContext bc){
        system.debug('!!!EXITO');
    }
    
    public void normalizarEstados(){
        set<String> idsServicios = new set<String>();
        set<String> idsOCs = new set<String>();
        set<String> idsSA = new set<String>();
        list<LTE_Servicios_adicionales__c> lstAllSA = new list<LTE_Servicios_adicionales__c>();
        list<LTE_Servicios_adicionales__c> lstAllSAOC = new list<LTE_Servicios_adicionales__c>();
        list<LTE_SpecificationGroupXA__c> lstAllSG = new list<LTE_SpecificationGroupXA__c>();
        
        
        
        list<OperacionComercial__c> lstOCs = [
            Select  Id, Activo__c, Topp__r.TipodeOperacionporplan__c, 
            Name,TipoSuspension__c,Plan__r.LTE_TipoControl__c,
            Activo__r.LTE_Fecha_Ultima_Suspension__c,Activo__r.LTE_Fecha_Ultima_Reconexion__c,
            Activo__r.Fecha_Activacion__c,Activo__r.LTE_Fecha_Inicial_Contrato__c,Activo__r.LTE_Fecha_Final_Contrato__c,Activo__r.LTE_Fecha_Alta_inicial__c,
            Activo__r.LTE_Dias_suspendidos__c,Activo__r.LTE_Numero_veces_suspendido__c
            From    OperacionComercial__c
            Where   (
                        (TOPP__r.TipodeOperacionporplan__c = 'Adición SVA' Or TOPP__r.TipodeOperacionporplan__c = 'Retiro SVA') And 
                        Categoria__c = 'Seguro de terminales' And 
                        Estado__c = 'Pendiente Facturacion'
                    )
            		Or (TOPP__r.TipodeOperacionporplan__c = 'Modificación Servicio' and Estado__c='Activa' and Valorunicavez__c > 0)
            		Or (TOPP__r.TipodeOperacionporplan__c = 'Modificación Estándar' and Estado__c='Activa' and Valorunicavez__c > 0 and Detalle_del_tramite__c = 'Traslado Interno') //FSARASTY 2020-09-02
                    //Or (TOPP__r.TipodeOperacionporplan__c = 'Reposición' And LTE_TipoTransaccion__c = 'Equipo' And LTE_TipoPago__c = 'Primera factura')   
        ];
        
        system.debug('\nLista de OCs===>'+lstOCs);
        
        for(OperacionComercial__c oc :lstOCs){
            idsServicios.add(oc.Activo__c);
            idsOCs.add(oc.Id);
        }
		        
        map<String, map<String,LTE_Servicios_adicionales__c>> mapSAxOC = new map<String, map<String,LTE_Servicios_adicionales__c>>();
        map<String, map<String,LTE_Servicios_adicionales__c>> mapSAxOC1 = new map<String, map<String,LTE_Servicios_adicionales__c>>();
        
        //Obtengo los servicios adicionales relacionados con las operaciones comerciales
        list<LTE_Servicios_adicionales__c> lstSAOC = [
            Select  Id, LTE_ServicioETB__c, LTE_ServiceActionCode__c, Name, LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c,
                    LTE_ServicioETB__r.Plan__r.Name, LTE_DetalleOfertaEReservadoRegContable__c, LTE_Operacion_Comercial_SVA__c, 
                    LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c, LTE_OC_Tramite__c,
                    (Select Id, Name, LTE_ActionCode__c, LTE_ParametroFacturacion__c, LTE_Value__c From SpecificationGroupXA__r) 
            From    LTE_Servicios_adicionales__c
            Where   (LTE_Operacion_Comercial_SVA__c IN :idsOCs OR LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c IN :idsOCs) 
                    and  LTE_ServiceActionCode__c!='ELIMINADO'
        ];
        
        system.debug('\nLista SA OC===>'+lstSAOC);
        //Armo un mapa con los servicios adicionales de cada operacion comercial
        for(LTE_Servicios_adicionales__c sa : lstSAOC){
            idsSA.add(sa.Id);
            //Lista para obtener los servicios adicionales de la OC
            map<String,LTE_Servicios_adicionales__c> lstSAAux;
            //Camino 1
            if(sa.LTE_Operacion_Comercial_SVA__c != null){
                if(mapSAxOC1.containsKey(sa.LTE_Operacion_Comercial_SVA__c))
                    lstSAAux = mapSAxOC1.get(sa.LTE_Operacion_Comercial_SVA__c);
                else
                    lstSAAux = new map<String,LTE_Servicios_adicionales__c>();
                    
                lstSAAux.put(sa.Id,sa);
                mapSAxOC1.put(sa.LTE_Operacion_Comercial_SVA__c, lstSAAux);
            }
            //Camino 2
            if(sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c != null){
                if(mapSAxOC1.containsKey(sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c))
                    lstSAAux = mapSAxOC1.get(sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c);
                else
                    lstSAAux = new map<String,LTE_Servicios_adicionales__c>();
                lstSAAux.put(sa.Id,sa);
                mapSAxOC1.put(sa.LTE_DetalleOfertaEReservadoRegContable__r.LTE_OperacionComercial__c, lstSAAux);
            }
        }
        
        
        //Obtengo los servicios adicionales relacionados con el Servicio
        list<LTE_Servicios_adicionales__c> lstSA = [
            Select  Id, LTE_ServicioETB__c, LTE_ServiceActionCode__c, Name, LTE_SubPlaFacturacion__r.LTE_TipoSubplan__c,
                    LTE_ServicioETB__r.Plan__r.Name, LTE_DetalleOfertaEReservadoRegContable__c, LTE_OC_Tramite__c,
                    (Select Id, Name, LTE_ActionCode__c, LTE_ParametroFacturacion__c, LTE_Value__c From SpecificationGroupXA__r) 
            From    LTE_Servicios_adicionales__c
            Where   LTE_ServicioETB__c IN :idsServicios and  LTE_ServiceActionCode__c!='ELIMINADO' and Id NOT IN :idsSA
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
        
        
        for(OperacionComercial__c oc :lstOCs){
            String c ='LTE_TipodeOperacionProductoOnComplete.'+LibreriaUtilitaria_cls.quitarCaracteresEsp(oc.Topp__r.TipodeOperacionporplan__c.deleteWhitespace());
            Type t = Type.forName(c);
            if(t!=null){                
                LTE_Tramites_cls.Step paso =(LTE_Tramites_cls.Step) t.newInstance();
                paso.oc = oc;
                System.debug('\nmapSAxOC1.get(oc.Id)===>'+mapSAxOC1.get(oc.Id));
                if(mapSAxOC1.containsKey(oc.Id))
                    paso.sa = mapSAxOC1.get(oc.Id).values();
                System.debug('\nmapSAxOC.get(oc.Activo__c)===>'+mapSAxOC.get(oc.Activo__c));
                if(mapSAxOC.containsKey(oc.Activo__c))
                    paso.saActivo = mapSAxOC.get(oc.Activo__c).values();
                paso.procesar();
                //actionCode=paso.accion;
                
                if(paso.saActivo != null)
                    lstAllSA.addAll(paso.saActivo);
                if(paso.sa != null) 
                    lstAllSAOC.addAll(paso.sa);
                if(paso.SpecGroupXAList != null)
                    lstAllSG.addAll(paso.SpecGroupXAList);
            }
                                
        }
        
        //Actualizo la lista de servicios adiconales
        if(!lstAllSA.isEmpty()){
            System.debug('\nActualizar Servicios Adicionales');
            update lstAllSA;
        }
        
        //Actualizo la lista de servicios adiconales
        if(!lstAllSAOC.isEmpty()){
            System.debug('\nActualizar Servicios Adicionales');
            update lstAllSAOC;
        }
            
        //Actualizo la lista de Specification Group
        if(!lstAllSG.isEmpty()){
            System.debug('\nActualizar Specification XA');
            update lstAllSG;
        }       
    }

}