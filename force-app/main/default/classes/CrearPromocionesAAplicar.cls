/*
* Desarrollado por: Accenture
* Autor:            Astrid Leiva & Mary Boyacá.
* Proyecto:         ETB - Celula MiPymes y Empresas
* Descripción:      Clase encargada de crear los registros de promociones a aplicar para enviar a RVC o a Charging.
* Clase de prueba:  CrearPromocionesAAplicar_tst
* Cambios (Versiones)
* -----------------------------------------------------------------------------------
* No.  Fecha       	Autor                   			Descripción
* ---- ----------- 	----------------------- 			------------------------------------------
* 1.0  03-Marzo-2022  Astrid Leiva & Mary Boyacá.   	Creación de la clase
**/
public with sharing class CrearPromocionesAAplicar {
   
    public static string TIPO_PROMOCION_ONESHOT = 'ONE SHOT';
    public static string TIPO_PROMOCION_RANGO = 'RANGO';
    public static string TIPO_PROMOCION_MAS_VELOCIDAD_DATOS = 'MAS VELOCIDAD DATOS';
    public static string ESTADO_PENDIENTE_ENVIO_PROMO = 'Pendiente Envio';
    public static string ESTADO_ENVIO_EXITOSO_PROMO = 'Envio Exitoso';

    public static String TIPOOPERACION_ADICION_SVA = 'Adición SVA';
    public static String TIPOREGISTRO_SERVICIO_ADICIONAL = 'Empaquetamiento';
    public static String NAME_SOBJECT_OC = 'OperacionComercial__c';
   

    @InvocableMethod
    public static void crearPromocionesAAplicar(List<LTE_DetalleOferta__c> listDetalleOferta){
        List<ReglaCampana__c> listaReglasPromocion  = new List<ReglaCampana__c>();
        List<PromocionAplicada__c> listPromocionesAplicadas = new List<PromocionAplicada__c>();
        List<PromocionAplicada__c> listPromoAplicadasRecursos = new List<PromocionAplicada__c>();
        LTE_DetalleOferta__c detalleOferta = new LTE_DetalleOferta__c();
        Date fechaActivacion;
        Date fechaInicioPromocion;
        Date fechaFinPromocion;
        Id productoId;
        Id componenteCampaniaId;

        detalleOferta = [SELECT Id, Name,LTE_Componente_de_la_Campana__c ,LTE_OperacionComercial__c, LTE_OperacionComercial__r.FechadeActivacion__c, 
                        LTE_OperacionComercial__r.Activo__c, LTE_OperacionComercial__r.Activo__r.NombredelProducto__c, LTE_OperacionComercial__r.Activo__r.CuentaFacturacion__c, 
                        LTE_OperacionComercial__r.Activo__r.NumeroConexion__c, LTE_Cliente__c
                        FROM LTE_DetalleOferta__c WHERE Id =: listDetalleOferta.get(0).Id LIMIT 1 ];
        
        productoId = detalleOferta.LTE_OperacionComercial__r.Activo__r.NombredelProducto__c;
        componenteCampaniaId = detalleOferta.LTE_Componente_de_la_Campana__c;
        fechaActivacion = detalleOferta.LTE_OperacionComercial__r.FechadeActivacion__c;
        
        listaReglasPromocion = [SELECT Name, Meses__c, Descuento__c, TipoCampana__c, ComponenteCampana__c, ComponenteCampana__r.Plan__c
                               FROM ReglaCampana__c WHERE ComponenteCampana__c =: componenteCampaniaId];
        
        for (ReglaCampana__c reglaCamp : listaReglasPromocion) {
            if(reglaCamp.TipoCampana__c == TIPO_PROMOCION_ONESHOT){
                Integer mesPromocion =  Integer.valueOf (reglaCamp.Meses__c);
                fechaInicioPromocion = fechaActivacion.addMonths(mesPromocion - 1);
                fechaFinPromocion = fechaInicioPromocion.addMonths(1);
                listPromocionesAplicadas.add(crearRegistroPromocionAplicada(fechaInicioPromocion, fechaFinPromocion, reglaCamp, detalleOferta));
            }
            else if(reglaCamp.TipoCampana__c == TIPO_PROMOCION_RANGO){
                String meses = reglaCamp.Meses__c;
                string caracter = meses.contains('-') ? '-': meses.contains(',') ? ',' : null;
                if(caracter != null){
                    for(String mes : meses.split(caracter)){
                        if(mes.isNumeric()){
                            fechaInicioPromocion = fechaActivacion.addMonths(Integer.valueOf(mes) - 1);
                            fechaFinPromocion = fechaInicioPromocion.addMonths(1);
                            listPromocionesAplicadas.add(crearRegistroPromocionAplicada(fechaInicioPromocion, fechaFinPromocion, reglaCamp, detalleOferta));
                        }
                    }
                }
            }
            else if(reglaCamp.TipoCampana__c == TIPO_PROMOCION_MAS_VELOCIDAD_DATOS){
                Integer cantidadMesesPromocion = Integer.valueOf (reglaCamp.Meses__c);
                fechaFinPromocion = fechaActivacion.addMonths(cantidadMesesPromocion);
                listPromocionesAplicadas.add(crearRegistroPromocionAplicada(fechaActivacion, fechaFinPromocion, reglaCamp, detalleOferta));
            }
        } 

        insert listPromocionesAplicadas; 

        listPromoAplicadasRecursos = [SELECT Id, Operacion_Comercial__c , Operacion_Comercial__r.CuentaCliente__c, Operacion_Comercial__r.Activo__c, 
                                        Operacion_Comercial__r.Activo__r.NumeroConexion__c, Operacion_Comercial__r.Activo__r.CuentaFacturacion__c,
                                        ReglaDeCampana__r.SubPlanFacturacion__c, ReglaDeCampana__r.SubPlanFacturacion__r.Name, ReglaDeCampana__r.ComponenteCampana__r.Plan__c
                                        FROM PromocionAplicada__c WHERE  Operacion_Comercial__c =: detalleOferta.LTE_OperacionComercial__c AND Tipo_Promocion__c =: TIPO_PROMOCION_MAS_VELOCIDAD_DATOS];
     
        if(!listPromoAplicadasRecursos.isEmpty()){
            procesarPromocionesAdicionRecursos(listPromoAplicadasRecursos, productoId);
        }
    }

    private static PromocionAplicada__c crearRegistroPromocionAplicada(Date fechaInicioPromocion, Date fechaFinPromocion, ReglaCampana__c reglaCamp, LTE_DetalleOferta__c objDetalle ){
        PromocionAplicada__c promocion = new PromocionAplicada__c();
        promocion.Fecha_Inicio__c =  fechaInicioPromocion;
        promocion.Fecha_Fin__c =  fechaFinPromocion;
        promocion.Descuento__c = reglaCamp.Descuento__c;
        promocion.Estado__c = reglaCamp.TipoCampana__c == TIPO_PROMOCION_MAS_VELOCIDAD_DATOS ? ESTADO_ENVIO_EXITOSO_PROMO: ESTADO_PENDIENTE_ENVIO_PROMO;
        promocion.ReglaDeCampana__c = reglaCamp.Id;
        promocion.Operacion_Comercial__c = objDetalle.LTE_OperacionComercial__c;
        return promocion;
    }

    /**
     * Metodo que procesa las promociones de recursos y crea una OC de tipo Adición SVA por cada promoción
     * y las envia a integración
     */
    private static void procesarPromocionesAdicionRecursos(List<PromocionAplicada__c> listPromociones, Id productId){
		TOPP__c TOPPAdicionSVA = new TOPP__c();
		RecordType recordTypeOC = new RecordType();
        ActivoETB__c activo = new ActivoETB__c();

		List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
		List<LTE_Servicios_adicionales__c> lstSA = new List<LTE_Servicios_adicionales__c>();
		set<Id> setIdOcs = new set<Id>();
		LTE_Servicios_adicionales__c objSADatos;
        Id recordTypeSA;

		Savepoint sp = Database.setSavepoint();
		
		TOPPAdicionSVA = [SELECT Id, Name, Tipoderegistro__c FROM TOPP__c WHERE TipodeOperacionporplan__c =: TIPOOPERACION_ADICION_SVA AND LTE_Catalogo_de_Producto__c =: productId LIMIT 1];
		recordTypeOC = [SELECT Id FROM RecordType WHERE DeveloperName =: TOPPAdicionSVA.Tipoderegistro__c AND sObjectType =: NAME_SOBJECT_OC LIMIT 1];   
        recordTypeSA = Schema.SObjectType.LTE_Servicios_adicionales__c .getRecordTypeInfosByName().get(TIPOREGISTRO_SERVICIO_ADICIONAL).getRecordTypeId();

		try{
            for(PromocionAplicada__c promocion : listPromociones){ 
                OperacionComercial__c objOC = new OperacionComercial__c();
                objOC.CuentaCliente__c = promocion.Operacion_Comercial__r.CuentaCliente__c;
                objOC.Activo__c = promocion.Operacion_Comercial__r.Activo__c;
                objOC.NumeroConexion__c = promocion.Operacion_Comercial__r.Activo__r.NumeroConexion__c;   		
                objOC.Plan__c = promocion.ReglaDeCampana__r.ComponenteCampana__r.Plan__c;
                objOC.TOPP__c = TOPPAdicionSVA.Id;
                objOC.Estado__c = 'En Curso';
                objOC.RecordTypeId = recordTypeOC.Id;
                objOC.CuentaFacturacion__c = promocion.Operacion_Comercial__r.Activo__r.CuentaFacturacion__c;
                objOC.FechaInicioReconexion__c = Date.today();
                objOC.Categoria__c = 'Bolsa Única vez';
                objOC.Detalle_del_tramite__c = 'PROMOCION RECURSOS';
                lstOC.add(objOC);
            }

			insert lstOC;

			for(OperacionComercial__c objOCAux : lstOC){	
                for(PromocionAplicada__c promocion : listPromociones){ 
                    if(objOCAux.Plan__c == promocion.ReglaDeCampana__r.ComponenteCampana__r.Plan__c ){
                        Id IdBolsa = promocion.ReglaDeCampana__r.SubPlanFacturacion__c;
                        if(IdBolsa != null){
                            objSADatos = new LTE_Servicios_adicionales__c();
                            objSADatos.Name = promocion.ReglaDeCampana__r.SubPlanFacturacion__r.Name;
                            objSADatos.LTE_Operacion_Comercial_SVA__c = objOCAux.Id;
                            objSADatos.LTE_SubPlaFacturacion__c = IdBolsa;
                            objSADatos.RecordTypeId = recordTypeSA;
                            lstSA.add(objSADatos);
                        }
                        setIdOcs.add(objOCAux.Id);
                    }
                }
			}
			
			insert lstSA;
			
	        // Parametrizar Servicios adicionales y  generar XA's
	    	LTE_CrearParametrizacionPostVenta_cls clasParam = new LTE_CrearParametrizacionPostVenta_cls();
			LTE_CrearParametrizacionPostVenta_cls.servAdicSpcGrXA wrData = clasParam.initCambioDeplan(setIdOcs,'OCSVA');
			
			// Actualizar servicios adicionales
			update wrData.servAD; 	
			
			// Insertar XA's
			insert wrData.SpgXA;
		
			envioInmediato(setIdOcs);

		} catch(Exception e){
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error General' + ': ' + e.getMessage()));
    		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getStackTraceString()));
    		Database.rollback(sp);
    		System.Debug('====================== EXCEPCION ======================');
    		System.debug( e.getMessage() + ' ' + e.getStackTraceString());
    		System.Debug('=======================================================');
    	}
    }

  
    /**
    * Metodo encargado de enviar el aprovisionamiento en-linea
    */
    private static void envioInmediato(set<id> setIdOcs){
    	LTE_AprovisionamientoTramites_bch batchA = new LTE_AprovisionamientoTramites_bch();
		batchA.idImediato = setIdOcs;
    	ID batchprocessid = Database.executeBatch(batchA, 1);
    }
}