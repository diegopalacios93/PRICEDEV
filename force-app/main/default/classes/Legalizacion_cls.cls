public with sharing class Legalizacion_cls {

    public void identificarCambiosLeg(map<Id,Legalizacion__c> legNew,map<Id,Legalizacion__c> legOld){
  	
    	set<Id>cambios=new set<Id>();    	
   	
    	for(Id idoc:legNew.keySet()){
    		//si el contrato cambio
    		if(legNew.get(idoc).Contrato__c!= legOld.get(idoc).Contrato__c){
    			
                
                if(legNew.get(idoc).Contrato__c!=null){
    				cambios.add(legNew.get(idoc).Contrato__c);
    			}
    			if(legOld.get(idoc).Contrato__c!=null){
    				cambios.add(legOld.get(idoc).Contrato__c);
    			}
    		}
    	}
    	
    	if(!cambios.isEmpty()){
    		set<Id>montoSuperior=recalculoContratoLeg(cambios);
	    	for(id mS:legNew.keySet()){
	    		if(montoSuperior.contains(legNew.get(mS).Id)){
	    			//legNew.get(mS).addError('El valor de las operaciones comerciales es superior al monto del contrato');
	    		}    		    	
	    	}

    	}
    }
    
	//Al pasar la legalizacion a esrtaod gestionado, se debe cambiar el esatdo de la opercaion comercia de ventea de equipos a estado activa
	// LRPA
	public void ActualizarOperacionComercialVentaEquipos(map<id,Legalizacion__c> LegNew, map<id,Legalizacion__c> LegOld )
	{
		//recorre las legalizaciones si el contrato cambio tiene en cuenta las legalizaciones
		set<Id> idLegs = new set<id>();
		map<Id,Id> mapLegContrato=new map<Id,Id>(); 
		for(Id idLeg :legNew.keySet())
		{
			if(LegNew.get(idLeg).Estado__c!=null && LegNew.get(idLeg).Estado__c=='Gestionado' && LegOld.get(idLeg).Estado__c!='Gestionado')
			{
				idLegs.add(idLeg);
			}
		}
		system.debug('idLegs: '+idLegs);
		//buscar las operaciones comerciales relacionadas con las legalizaciones
		list<OperacionComercial__c> listOC = [select id,Contrato__c,Legalizacion__c 
												from OperacionComercial__c 
												where Legalizacion__c in :idLegs
												and TOPP__r.TipodeOperacionporplan__c='Venta Equipos'];
		//recorrer la lista y asignar los nuevos contratos
		for(OperacionComercial__c OC :listOC)
		{
			OC.Estado__c='Activa';
		}
		//actualizar operaciones comerciales
		Database.Update(listOC,false);		
	}  

//comentado para paso a produccion 04-05-2015 LEM	
	public void ActualizarOperacionesComerciales(map<id,Legalizacion__c> LegNew, map<id,Legalizacion__c> LegOld )
	{
		//recorre las legalizaciones si el contrato cambio tiene en cuenta las legalizaciones
		set<Id> idLegs = new set<id>();
		map<Id,Id> mapLegContrato=new map<Id,Id>(); 
		for(Id idLeg :legNew.keySet())
		{
			if(LegNew.get(idLeg).Estado__c!=null && LegNew.get(idLeg).Estado__c=='Gestionado' && LegOld.get(idLeg).Estado__c!='Gestionado')
			{
				idLegs.add(idLeg);
				mapLegContrato.put(idLeg,LegNew.get(idLeg).Contrato__c);
			}
		}
		system.debug('idLegs: '+idLegs);
		//buscar las operaciones comerciales relacionadas con las legalizaciones
		list<OperacionComercial__c> listOC = [select id,Contrato__c,Legalizacion__c from OperacionComercial__c where Legalizacion__c in :idLegs];
		//recorrer la lista y asignar los nuevos contratos
		for(OperacionComercial__c OC :listOC)
		{
			Id idcontrato = mapLegContrato.get(OC.Legalizacion__c);
			OC.contrato__c=idcontrato;
		}
		//actualizar operaciones comerciales
		Database.Update(listOC,false);
	}
	
	//valida que las oportunidades de las legalizaciones involucradas sean 
	public void ValidacionNegociacionCerrada(map<id,Legalizacion__c> LegNew, map<id,Legalizacion__c> LegOld)
	{
		ReglasDesarrollos__c reglas = ReglasDesarrollos__c.getValues('Legalizacion1');
    	if(reglas!=null && reglas.Activo__c==true)
    	{
		set<Id> idLegs = new set<id>();
		for(Id idLeg :legNew.keySet())
		{
			if(LegNew.get(idLeg).Estado__c!=null && LegNew.get(idLeg).Estado__c=='Gestionado' && LegOld.get(idLeg).Estado__c!='Gestionado')
			{
				idLegs.add(idLeg);
				
			}
		}
		system.debug('pruebas  '+idlegs);
		list<OperacionComercial__c> listOC = [select id,/*Contrato__c,*/Legalizacion__c,Oportunidad__r.StageName,Oportunidad__c from OperacionComercial__c where Legalizacion__c in :idLegs];
		//recorrer la lista y asignar los nuevos contratos
		for(OperacionComercial__c OC :listOC)
		{
			if(OC.Oportunidad__c!=null && OC.Oportunidad__r.StageName!=Label.EstadoOpp)
			{
				LegNew.get(OC.Legalizacion__c).addError('No se puede gestionar legalizacion cuyas oportunidades relacionadas a las operaciones comerciales no estan en la etapa "Cerrada ganada", por favor retire las operaciones comerciales o modifique las oportunidades relacionadas. ');
			}
		}
    	}
		
	}
	
	public void ValidacionOperacionComercial(map<id,Legalizacion__c> LegNew, map<id,Legalizacion__c> LegOld)
	{
		ReglasDesarrollos__c reglas = ReglasDesarrollos__c.getValues('Legalizacion2');
    	if(reglas!=null && reglas.Activo__c==true)
    	{
		set<Id> idLegs = new set<id>();
		for(Id idLeg :legNew.keySet())
		{
			if(LegNew.get(idLeg).Estado__c!=null && LegNew.get(idLeg).Estado__c=='Gestionado' && LegOld.get(idLeg).Estado__c!='Gestionado')
			{
				idLegs.add(idLeg);
				
			}
		}
		
		list<OperacionComercial__c> listOC = [select Duracion_Dias__c,Duracion_Meses__c,id,Legalizacion__c,Oportunidad__c from OperacionComercial__c where Legalizacion__c in :idLegs];
		//recorrer la lista y asignar los nuevos contratos
		for(OperacionComercial__c OC :listOC)
		{
			if(OC.Duracion_Dias__c==null || OC.Duracion_Meses__c==null)
			{
				LegNew.get(OC.Legalizacion__c).addError('No se puede gestionar legalizacion cuyas operaciones comerciales tengan vacios los campos Duracion dias y duracion meses ');
			}
		}
		
    	}
	}
	
	//valida que el perfil pueda saltarse las reglas
	public boolean validacionPerfil(string  perfil_usuario)
	{
		Perfiles_Acciones__c perOf = Perfiles_Acciones__c.getValues('ValidacionesLegalizacion');
		boolean valido=false;
		if(perOf!=null)
		{
			string per=perOf.Usuarios__c;
			for(string valor :per.split(','))
			{
				if(valor==perfil_usuario)
				{
					valido=true;
				}
			}
		}
		return valido;
	}
	
	 public set<Id> recalculoContratoLeg(set<Id> idContr){
    	
         system.debug(idContr);
         
    	set<string> sumanContrato=new set<string>{'Venta','Prorroga','Ampliaci?n'};
    	set<Id> contratosP=new set<Id>();
    	
    	set<Id>montoSuperior=new set<Id>();

    		
    	map<Id,Contract> contratos=new map<Id,Contract>();
    		
    	list<OperacionComercial__c> ocLst=new list<OperacionComercial__c>([select id,Estado__c,Monto_Ejecutado_OC__c,topp__r.TipodeOperacionporplan__c, Legalizacion__r.Contrato__c,Legalizacion__c,Legalizacion__r.Contrato__r.monto_ejecutado__c,Legalizacion__r.Contrato__r.Contrato_Relacionado__c,Legalizacion__r.Contrato__r.ValorTotaldelcontrato__c from OperacionComercial__c where Legalizacion__r.Contrato__c In :idContr]);
    		
    	for(OperacionComercial__c oc:ocLst){
    		//Asignamos el contrato y restauramos su valor
    		if(contratos.get(oc.Legalizacion__r.Contrato__c)==null){
    			contratos.put(oc.Legalizacion__r.Contrato__c,oc.Legalizacion__r.Contrato__r);
    			contratos.get(oc.Legalizacion__r.Contrato__c).monto_ejecutado__c=0;
    		}
    		//Recalculamos
    		if(sumanContrato.contains(oc.topp__r.TipodeOperacionporplan__c) && oc.Monto_Ejecutado_OC__c!=null && oc.Estado__c!='Declinada'){
    			contratos.get(oc.Legalizacion__r.Contrato__c).monto_ejecutado__c+=oc.Monto_Ejecutado_OC__c;
    		}
    		
    		if(contratos.get(oc.Legalizacion__r.Contrato__c).monto_ejecutado__c>contratos.get(oc.Legalizacion__r.Contrato__c).ValorTotaldelcontrato__c){
    			//oc.addError('El valor de las operaciones comerciales es superior al monto del contrato');
    			montoSuperior.add(oc.Legalizacion__c);
    		}
    		
    		if(oc.Legalizacion__r.Contrato__r.Contrato_Relacionado__c!=null){
    			contratosP.add(oc.Legalizacion__r.Contrato__r.Contrato_Relacionado__c);
    		}
    	}

        //Identificamos contratos que no tiene OC para restablecer montos=0
        idContr.removeAll(contratos.keySet());
        for(Id idc:idContr){
            Contract conSinOc=new Contract(id=idc,monto_ejecutado__c=0);
            contratos.put(idc,conSinOc);
        }

    	update contratos.values();
    	
    	system.debug('Padres'+contratosP);
    	//Si son hijos recalcula los padres.
    	if(!contratosP.isEmpty()){
    		system.debug('padres:'+contratosP);
    		contratos_cls.recalcularContratosPadres(contratosP);
    	}  	
    	
    	
    	return montoSuperior;
      	
    }
    
    // Clase que contiene la estructura de lote y detalle de lote para poder hacer la insercion de lotes a portar
    public class LoteDetaleLote{
    	LTE_Lote__c lote;
    	list<LTE_DetalleLote__c> listaDetalleLote;
    }
	//Crea los lotes y detalles de lote LRPA-WRM
	public static void creaLote(Legalizacion__c objLegalizacion,list<OperacionComercial__c> lstOC)
	{
		system.debug('Entra--creaLote()-legalizacion-->');
		list<LoteDetaleLote> lstLoteDetLote = new list<LoteDetaleLote>();
		list<OperacionComercial__c> lstOCLotear;
		set<String> setIdOpeComs = new set<String>();
		Integer numLote=0;
		
		// Obtener los Ids de las operaciones comerciuales a procesar
		for(OperacionComercial__c oc:lstOC){
			setIdOpeComs.add(oc.Id);
		}
		
		// Consultar en la BD las operaciones comerciales que tienen portabilidad y ordenarlas por Donante
		lstOCLotear = [select id,Activo__r.NombredelaCuenta__r.Name,Activo__r.Usuario_Integracion__c,Activo__r.NombredelaCuenta__r.Direccion__c,Activo__r.Tipo_de_Identificacion_integracion__c,Activo__r.Numero_de_Identificacion_Integracion__c,LTE_SolicitadoPorTercero__c,
								Activo__r.NombredelaCuenta__r.AccountNumber,NumeroConexion__c,Activo__c,LTE_Donante__c, LTE_Tipo_de_Servicio__c,
                       			(SELECT Id,Name,Linea__r.Tipo_servicio__c,Linea__r.Tipo__c,Linea__r.Codigo_de_linea__c FROM Lineas_OC__r WHERE Linea__r.Linea_ETB__c = 'Portada Movil')
								from OperacionComercial__c 
								where id in: setIdOpeComs
								and Portacion__c = true
								order by LTE_Donante__c, LTE_Tipo_de_Servicio__c];
		
		system.debug('lstOCLotear.size()-->'+lstOCLotear.size());
		//lote.LTE_FechaMaxVentanaCambio__c = datFechaPortabilidad;
		//insert lote;
		integer numLinea = 0;
		String donanteAnterior = '';
		String strTipoServicioAnt = '';
		list<LTE_DetalleLote__c> lstDetLote = new list<LTE_DetalleLote__c>(); 
		LTE_Lote__c lote;
		LTE_DetalleLote__c detalleLote;
        
        List<Map<String,String>> lstGruposComplete = new List<Map<String,String>>();
        
        Map<String,List<Map<String,String>>> MpGruposLineas = new Map<String,List<Map<String,String>>>();
        // recorrer la lista consultada y armar estrucutra de lotes y detalles de lote
		for(OperacionComercial__c lineas : lstOCLotear)
        {
            if(lineas.Lineas_OC__r.isEmpty()){
                if(!MpGruposLineas.containsKey(lineas.LTE_Donante__c+'_'+lineas.LTE_Tipo_de_Servicio__c)){
                    MpGruposLineas.put(lineas.LTE_Donante__c+'_'+lineas.LTE_Tipo_de_Servicio__c,new List<Map<String,String>>());
                }
                Map<String,String> mpCampos = new Map<String,String>();
                mpCampos.put('Id',lineas.id);
                mpCampos.put('LTE_Donante__c',lineas.LTE_Donante__c);
                mpCampos.put('LTE_Tipo_de_Servicio__c',lineas.LTE_Tipo_de_Servicio__c);
                mpCampos.put('Activo__r.Usuario_Integracion__c',lineas.Activo__r.Usuario_Integracion__c);
                mpCampos.put('Activo__r.NombredelaCuenta__r.Direccion__c',lineas.Activo__r.NombredelaCuenta__r.Direccion__c);
                mpCampos.put('Activo__r.Numero_de_Identificacion_Integracion__c',lineas.Activo__r.Numero_de_Identificacion_Integracion__c);
                mpCampos.put('Activo__r.Tipo_de_Identificacion_integracion__c',lineas.Activo__r.Tipo_de_Identificacion_integracion__c);
                mpCampos.put('LTE_SolicitadoPorTercero__c',String.valueOf(lineas.LTE_SolicitadoPorTercero__c));
                mpCampos.put('NumeroConexion__c',lineas.NumeroConexion__c);
                mpCampos.put('Activo__c',lineas.Activo__c);
                MpGruposLineas.get(lineas.LTE_Donante__c+'_'+lineas.LTE_Tipo_de_Servicio__c).add(mpCampos);
            }else{
                for(Lineas_OC__c sglLineaOC:lineas.Lineas_OC__r){
                    if(!MpGruposLineas.containsKey(sglLineaOC.Linea__r.Tipo__c+'_'+sglLineaOC.Linea__r.Tipo_servicio__c)){
                        MpGruposLineas.put(sglLineaOC.Linea__r.Tipo__c+'_'+sglLineaOC.Linea__r.Tipo_servicio__c,new List<Map<String,String>>());
                    }
                    Map<String,String> mpCampos = new Map<String,String>();
                    mpCampos.put('Id',sglLineaOC.id);
                    mpCampos.put('LTE_Donante__c',sglLineaOC.Linea__r.Tipo__c);
                    mpCampos.put('LTE_Tipo_de_Servicio__c',sglLineaOC.Linea__r.Tipo_servicio__c);
                    mpCampos.put('Activo__r.Usuario_Integracion__c',lineas.Activo__r.Usuario_Integracion__c);
                    mpCampos.put('Activo__r.NombredelaCuenta__r.Direccion__c',lineas.Activo__r.NombredelaCuenta__r.Direccion__c);
                    mpCampos.put('Activo__r.Numero_de_Identificacion_Integracion__c',lineas.Activo__r.Numero_de_Identificacion_Integracion__c);
                    mpCampos.put('Activo__r.Tipo_de_Identificacion_integracion__c',lineas.Activo__r.Tipo_de_Identificacion_integracion__c);
                    mpCampos.put('LTE_SolicitadoPorTercero__c',String.valueOf(lineas.LTE_SolicitadoPorTercero__c));
                    mpCampos.put('NumeroConexion__c',sglLineaOC.Linea__r.Codigo_de_linea__c);
                    mpCampos.put('Activo__c',lineas.Activo__c);
                    MpGruposLineas.get(sglLineaOC.Linea__r.Tipo__c+'_'+sglLineaOC.Linea__r.Tipo_servicio__c).add(mpCampos);
                }
            }
        }
        for(String sglGrupo:MpGruposLineas.keyset()){
            lstGruposComplete.addAll(MpGruposLineas.get(sglGrupo));
        }
		
		// recorrer la lista consultada y armar estrucutra de lotes y detalles de lote
		//for(OperacionComercial__c lineas : lstOCLotear)
        for(Map<String,String> lineas : lstGruposComplete)
		{
			system.debug('Id OC-->'+lineas.get('Id')+'Donante-->'+lineas.get('LTE_Donante__c'));
			// validar si se ha llegado al limite maximo de 10 lineas por lote o si ha cambiado el donante
			if(numLote == 0 || numLinea == 100 || donanteAnterior != lineas.get('LTE_Donante__c') || strTipoServicioAnt != lineas.get('LTE_Tipo_de_Servicio__c'))
			{
				system.debug('Entra al IF-->'+numLote+':numLinea--> ');
				// se graba un registro en la lista de lotes y detalle de lote, solo si no es el primer registro de la lista 
				if(numLote!=0)
				{  
					system.debug('Crea primer lote-en lista de lotes-->');
					LoteDetaleLote objLoteDetLote = new LoteDetaleLote();
					objLoteDetLote.lote=lote;
					objLoteDetLote.listaDetalleLote = lstDetLote;
					lstLoteDetLote.add(objLoteDetLote);
					lstDetLote = new list<LTE_DetalleLote__c>();
					system.debug('lstLoteDetLote-->'+lstLoteDetLote);
				}
				
				// se crea un lote con sus atributos
				lote = new LTE_Lote__c();
				system.debug('Crea primer lote-IDLegalizacion-->'+ objLegalizacion.Id);
				lote.LTE_Identificador__c = objLegalizacion.Id;
				lote.LTE_Observaciones__c = '';
				lote.LTE_FlagVentanaAmpliada__c = true;
				lote.LTE_NombreRazonSocialAbonado__c = lineas.get('Activo__r.Usuario_Integracion__c');
				lote.LTE_DireccionAbonado__c = lineas.get('Activo__r.NombredelaCuenta__r.Direccion__c');
				lote.LTE_Identificacion_Abonado__c = lineas.get('Activo__r.Numero_de_Identificacion_Integracion__c');
				lote.LTE_Donante__c = lineas.get('LTE_Donante__c');
				donanteAnterior = lineas.get('LTE_Donante__c');
				lote.LTE_TipoUsuario__c = lineas.get('Activo__r.Tipo_de_Identificacion_integracion__c');
				if(lineas.get('LTE_Tipo_de_Servicio__c') == 'Prepago')
					lote.LTE_TipoServicio__c = '1';
				else
					lote.LTE_TipoServicio__c = '2';
				strTipoServicioAnt = lineas.get('LTE_Tipo_de_Servicio__c');
				if(Boolean.valueof(lineas.get('LTE_SolicitadoPorTercero__c')))
					lote.LTE_SolicitudTerceros__c = '1';
				else
					lote.LTE_SolicitudTerceros__c = '0';
				lote.LTE_NRN__c = 0.0;
				lote.LTE_Legalizacion__c = objLegalizacion.Id;
				numLote+=1;			
			}
			numLinea+=1;
			system.debug('numLinea-->'+numLinea);
			
			// grabar una OC en la lista de detalle de lote
			detalleLote = new LTE_DetalleLote__c();
			detalleLote.LTE_NumeroLinea__c = lineas.get('NumeroConexion__c');
			//detalleLote.LTE_Lote__c = lote.Id;
			detalleLote.LTE_ActivoETB__c = lineas.get('Activo__c');
			detalleLote.Name = lineas.get('NumeroConexion__c');
			lstDetLote.add(detalleLote);
		}

		if(numLote != 0)
		{  
			system.debug('Crea ultimo lote-en lista de lotes-->');
			LoteDetaleLote objLoteDetLote = new LoteDetaleLote();
			objLoteDetLote.lote = lote;
			objLoteDetLote.listaDetalleLote = lstDetLote;
			lstLoteDetLote.add(objLoteDetLote);
		}
						
		// Insertar los lotes
		list<LTE_Lote__c> lotesInsertar = new list<LTE_Lote__c>();
		for(LoteDetaleLote objLoteInserta:lstLoteDetLote)
		{
			lotesInsertar.add(objLoteInserta.lote);
		}
		system.debug('Lotes a insertar-->'+lotesInsertar.size());
		insert lotesInsertar;
		
		// Insertar detalles de lote
		list<LTE_DetalleLote__c> detLotesInsertar = new list<LTE_DetalleLote__c>();
		for(LoteDetaleLote objLoteInserta : lstLoteDetLote)
		{
			system.debug('objLoteInserta.listaDetalleLote.size()-->'+objLoteInserta.listaDetalleLote.size());
			for(LTE_DetalleLote__c objDetLot : objLoteInserta.listaDetalleLote)
			{
				objDetLot.LTE_Lote__c = objLoteInserta.lote.id;
				detLotesInsertar.add(objDetLot);
			}
		}
		system.debug('detalle Lotes a insertar-->'+detLotesInsertar);
		system.debug('K detalle Lotes a insertar-->'+detLotesInsertar.size());
		insert detLotesInsertar;
	}

	/**
    *   @Method: declinarLegalizacion
    *   @param lstOld: Lista de Legalizaciones antes de la actualización (trigger.old).      
    *   @param lstNew: Lista de Legalizaciones despues de la actualización (trigger.new).    
    *   @description: Se encarga de declinar las operaciones comerciales relacionadas a una legalizacion que se esta declinando.
    *   @Autor: Carlos A. Rodriguez B. 25/08/2015.
    */
	public void declinarLegalizacion (list<Legalizacion__c> lstOld, list<Legalizacion__c> lstNew)
	{
		//se obtiene el id del tipo de registro de legalización LTE
		String strIdRecordTypeLTE = Schema.SObjectType.Legalizacion__c.getRecordTypeInfosByName().get('Legalización LTE').getRecordTypeId();
		map <String, Legalizacion__c> mapLegalizacionOld = new map <String, Legalizacion__c>();
		set <String> setIdLegalizacion = new set <String>();

		//Se crea un mapa con las legalizaciones antes de la actualización donde la llave es el id de la legalización.
		for(Legalizacion__c objLegalizacion : lstOld)
		{
			mapLegalizacionOld.put(objLegalizacion.Id, objLegalizacion);
		}

		for(Legalizacion__c objLegalizacionNew : lstNew)
		{
			// Se buscan las legalizaciones que se declinaron y que tienen tipo de registro LTE
			if(objLegalizacionNew.Estado__c == 'Declinada' && objLegalizacionNew.RecordTypeId == strIdRecordTypeLTE)
			{
				// Se busca la legalización en el mapa de legalizaciones antes de actualizar.
				if(mapLegalizacionOld.containsKey(objLegalizacionNew.Id))
				{
					//Se buscan las legalizaciones que antes de actualizar no estaban declinadas y tienen tipo de registro LTE.
					Legalizacion__c objLegalizacionOld = mapLegalizacionOld.get(objLegalizacionNew.Id);
					if(objLegalizacionOld.Estado__c != 'Declinada' && objLegalizacionOld.RecordTypeId == strIdRecordTypeLTE)
					{
						//Se almacena en un arreglo el Id de las legalizaciones que cambiaron a declinada
						setIdLegalizacion.add(objLegalizacionNew.Id);
					}
				}
			}
		}
		//Se buscan todas las operaciones comerciales asociadas al set de legalizaciones.
		system.debug('ID de Legalizaciones----->>>' + setIdLegalizacion);
		list <OperacionComercial__c> lstOpComercial = [	SELECT Id, Name, Estado__c, Legalizacion__c
														FROM OperacionComercial__c
														WHERE Legalizacion__c =: setIdLegalizacion];

		//Se les cambia el estado a las operaciones comerciales a declinada
		system.debug('LISTA DE OCS antes de actualizar--------->>' + lstOpComercial);
		for (OperacionComercial__c objOpComercial : lstOpComercial)
		{
			objOpComercial.Estado__c = 'Declinada';
		}
		//Se actualizan todas las Operaciones comerciales.
		system.debug('Lista de OCS declinadas------>>' + lstOpComercial);
		Update lstOpComercial;
	}
    /*
    public void relacionarSDWANconEnlaces(map<id,Legalizacion__c> LegNew,map<Id,Legalizacion__c> legOld){
 		set<Id> idLegs = new set<id>();
        Id idActivoSDWAN;
                
		for(Id idLeg :legNew.keySet())
		{
			if(LegNew.get(idLeg).Estado__c!=null && LegNew.get(idLeg).Estado__c=='Gestionado' && LegOld.get(idLeg).Estado__c!='Gestionado')			
				idLegs.add(idLeg);			
		}        
        if(idLegs.size() > 0){
            list<ActivoETB__c> ListActivoRel        = new list<ActivoETB__c>();            
            Map<Id,OperacionComercial__c> listOCSDWAN = new Map<Id,OperacionComercial__c>([select id, Activo__r.Id
												       from OperacionComercial__c 
												       where Legalizacion__c in :idLegs AND
                                                             Plan__r.NombredelProducto__r.Name = 'SD-WAN' AND
                                                             TOPP__r.TipodeOperacionporplan__c = 'Venta']);
            list<OperacionComercial__c> listOCRelacionadas = [select id, Activo__r.Id,Operacion_Comercial_Relacionada__c
												  				  from OperacionComercial__c 
												  				  where Operacion_Comercial_Relacionada__c =: listOCSDWAN.keyset()];
            
            for(OperacionComercial__c objOcAuxRel : listOCRelacionadas){
                ActivoETB__c objActivoRel = new ActivoETB__c(Id=objOcAuxRel.Activo__r.Id);
                objActivoRel.Activo_Relacionado_SD_WAN__c = listOCSDWAN.get(objOcAuxRel.Operacion_Comercial_Relacionada__c).Activo__r.Id;
                ListActivoRel.add(objActivoRel);
            }
            /*
            for(OperacionComercial__c objOcAux : listOCSDWAN){
                idActivoSDWAN = objOcAux.Activo__r.Id;
                list<OperacionComercial__c> listOCRelacionadas = [select id, Activo__r.Id
												  				  from OperacionComercial__c 
												  				  where Operacion_Comercial_Relacionada__c =: objOcAux.Id];
                
                for(OperacionComercial__c objOcAuxRel : listOCRelacionadas){
                   ActivoETB__c objActivoRel = new ActivoETB__c(Id=objOcAuxRel.Activo__r.Id);
                   objActivoRel.Activo_Relacionado_SD_WAN__c = idActivoSDWAN;
                   ListActivoRel.add(objActivoRel);
                }
            }
			*/
    		/*
            if(ListActivoRel.size() > 0)
                update ListActivoRel;
        }		
    }
    public void relacionarServiciosOffice365(map<id,Legalizacion__c> LegNew,map<Id,Legalizacion__c> legOld){
 		set<Id> idLegs = new set<id>();
        Id idActivoBkp365;
                
		for(Id idLeg :legNew.keySet())
		{
			if(LegNew.get(idLeg).Estado__c!=null && LegNew.get(idLeg).Estado__c=='Gestionado' && LegOld.get(idLeg).Estado__c!='Gestionado')			
				idLegs.add(idLeg);			
		}        
        if(idLegs.size() > 0){
            list<ActivoETB__c> ListActivoRel          = new list<ActivoETB__c>();            
            list<OperacionComercial__c> listOCSBkp365 = [select 
                                                         Id, Activo__r.Id, OP_comercial_relacionada_office_365__r.Id, 
                                                         Adquisicion_con_ETB_tercero__c, OP_comercial_relacionada_office_365__r.Activo__r.Id
												         from OperacionComercial__c 
												         where Legalizacion__c in :idLegs AND
                                                             Plan__r.NombredelProducto__r.Name =: Label.BkpOffice365_Nombre_Producto AND
                                                             TOPP__r.TipodeOperacionporplan__c = 'Venta'];
            
            for(OperacionComercial__c objOcAux : listOCSBkp365){
                if(objOcAux.Adquisicion_con_ETB_tercero__c == 'ETB'){
                   ActivoETB__c objActivoRel = new ActivoETB__c(Id=objOcAux.Activo__r.Id);
                   objActivoRel.Activo_Relacionado__c = objOcAux.OP_comercial_relacionada_office_365__r.Activo__r.Id;
                   ListActivoRel.add(objActivoRel);
                }                                                     
            } 
            if(ListActivoRel.size() > 0)
                update ListActivoRel;
        }		
    }
    public void actualizarEstadoOCsDemos(map<id,Legalizacion__c> LegNew,map<Id,Legalizacion__c> legOld){
        set<Id> idLegs = new set<id>();
                        
		for(Id idLeg :legNew.keySet())
		{
			if(LegNew.get(idLeg).Estado__c!=null && LegNew.get(idLeg).Estado__c=='Gestionado' && LegOld.get(idLeg).Estado__c!='Gestionado' && LegNew.get(idLeg).Legalizacion_servicios_Demo__c == true)
				idLegs.add(idLeg);			
		}        
        if(idLegs.size() > 0){
            list<OperacionComercial__c> listOCsDemo = [select Estado__c
												       from OperacionComercial__c 
												       where Legalizacion__c in :idLegs];
            
            if(listOCsDemo.size() > 0){
            	for(OperacionComercial__c objOc : listOCSDemo){
                	objOc.Estado__c = 'Activa';                 
            	}                
                update listOCSDemo;
            }
        }
    }*/
    public void procesosLegalizacionOCs(map<id,Legalizacion__c> LegNew,map<Id,Legalizacion__c> legOld){
        set<Id> idLegs = new set<id>();                        
        for(Id idLeg :legNew.keySet()){
            if((LegNew.get(idLeg).Estado__c!=null && LegNew.get(idLeg).Estado__c=='Gestionado' && LegOld.get(idLeg).Estado__c!='Gestionado'))
                idLegs.add(idLeg);			
        } 
        if(idLegs.size() > 0){
            set<Id> idsOcSDWAN     = new set<id>();
            List<OperacionComercial__c> LstOCSDWAN     		 = new List<OperacionComercial__c>();
            List<OperacionComercial__c> listOCSBkp365  		 = new List<OperacionComercial__c>();
            List<OperacionComercial__c> LstOCSDemo 			 = new List<OperacionComercial__c>();
            
            list<OperacionComercial__c> listOCsProcesar = 
                [Select id, Activo__r.Id, Activo__r.Fecha_Finalizaci_n_Demo__c, OP_comercial_relacionada_office_365__r.Id, Adquisicion_con_ETB_tercero__c, 
                 OP_comercial_relacionada_office_365__r.Activo__r.Id, Estado__c, Plan__r.NombredelProducto__r.Name,
                 TOPP__r.TipodeOperacionporplan__c, Duracion_Dias__c, FechadeActivacion__c, Name, Activo__r.Demo__c, Demo__c,
                 ValorTarifaPlan__c,Valor_Equipos__c,ValorObraCivil__c,Valorunicavez__c,Valor_Recurrente_Aliado__c,DescuentoPorc__c
                 From OperacionComercial__c
                 Where Legalizacion__c in :idLegs];
            
            for(OperacionComercial__c objOcAux : listOCsProcesar){                  
                if(objOcAux.Plan__r.NombredelProducto__r.Name == 'SD-WAN' && objOcAux.TOPP__r.TipodeOperacionporplan__c == 'Venta'){
                    idsOcSDWAN.add(objOcAux.Id);
                    LstOCSDWAN.add(objOcAux);
                }        
                if(objOcAux.Plan__r.NombredelProducto__r.Name == Label.BkpOffice365_Nombre_Producto && objOcAux.TOPP__r.TipodeOperacionporplan__c == 'Venta')
                    listOCSBkp365.add(objOcAux);
                        
                if(objOcAux.Estado__c == 'Pendiente' && ((objOcAux.TOPP__r.TipodeOperacionporplan__c == 'Conversión Demo a Venta' || objOcAux.TOPP__r.TipodeOperacionporplan__c == 'Ampliación de Tiempo Demo')||(objOcAux.Demo__c && objOcAux.TOPP__r.TipodeOperacionporplan__c == 'Venta')))    
                    LstOCSDemo.add(objOcAux);    	
                
            }
            //-------------------------------------------------------------------------------------------------------------------------
            //Proceso relacionarSDWANconEnlaces
    		if(LstOCSDWAN.size() > 0){
                list<ActivoETB__c> ListActivoRel = new list<ActivoETB__c>();  
                
                list<OperacionComercial__c> listOCRelacionadas = 
                    [select id, Activo__r.Id, Operacion_Comercial_Relacionada__r.Id
                     from OperacionComercial__c 
                     where Operacion_Comercial_Relacionada__c in: idsOcSDWAN];
                
                if(listOCRelacionadas.size() > 0){
                    for(OperacionComercial__c objOcParent : LstOCSDWAN){
                        for(OperacionComercial__c objOcAuxRel : listOCRelacionadas){
                            if(objOcParent.Id == objOcAuxRel.Operacion_Comercial_Relacionada__r.Id){
                                ActivoETB__c objActivoRel = new ActivoETB__c(Id=objOcAuxRel.Activo__r.Id);
                                objActivoRel.Activo_Relacionado_SD_WAN__c = objOcParent.Activo__r.Id;
                                ListActivoRel.add(objActivoRel);
                            }
                        }
                    }
                    if(!Test.isRunningTest()){
                    	if(ListActivoRel.size() > 0)
                            update ListActivoRel;
                    }
                }                
            }
            //-------------------------------------------------------------------------------------------------------------------------
			//Proceso relacionarServiciosOffice365
			if(listOCSBkp365.size() > 0){
                list<ActivoETB__c> ListActivoRel = new list<ActivoETB__c>();
                for(OperacionComercial__c objOcAux : listOCSBkp365){
                    if(objOcAux.Adquisicion_con_ETB_tercero__c == 'ETB'){
                       ActivoETB__c objActivoRel = new ActivoETB__c(Id=objOcAux.Activo__r.Id);
                       objActivoRel.Activo_Relacionado__c = objOcAux.OP_comercial_relacionada_office_365__r.Activo__r.Id;
                       ListActivoRel.add(objActivoRel);
                    }                                                     
            	}
                if(!Test.isRunningTest()){
                	if(ListActivoRel.size() > 0)
                		update ListActivoRel;
                }
            }
            //-------------------------------------------------------------------------------------------------------------------------
            //Proceso actualizarEstadoOCsDemos
            if(LstOCSDemo.size() > 0){               
                for(OperacionComercial__c objOc : LstOCSDemo){  
                    if(objOc.Activo__r.Demo__c && objOc.TOPP__r.TipodeOperacionporplan__c != 'Venta'){
                        if(objOc.TOPP__r.TipodeOperacionporplan__c == 'Conversión Demo a Venta' && objOc.FechadeActivacion__c == null){
                            for(Id idLeg :legNew.keySet()){
                                LegNew.get(idLeg).addError(' Para legalizar la operación comercial: '+objOc.Name+', debe ingresar una fecha en el campo: "Fecha de Activación"');
                                break;
                            }
                        }else{                                                 
                            objOc.Estado__c = 'Activa';
                            if(objOc.TOPP__r.TipodeOperacionporplan__c == 'Ampliación de Tiempo Demo')                                              
                                objOc.FechadeActivacion__c =  objOc.Activo__r.Fecha_Finalizaci_n_Demo__c;                            
                            update LstOCSDemo;                        
                        }                        
                    } 
                    if(objOc.Demo__c && objOc.TOPP__r.TipodeOperacionporplan__c == 'Venta'){
                        if(objOc.ValorTarifaPlan__c == null)
                            objOc.ValorTarifaPlan__c = 0;
                        if(objOc.Valor_Equipos__c == null)
                            objOc.Valor_Equipos__c = 0;
                        if(objOc.ValorObraCivil__c == null)
                            objOc.ValorObraCivil__c = 0;
                        if(objOc.Valorunicavez__c == null)
                            objOc.Valorunicavez__c = 0;
                        if(objOc.Valor_Recurrente_Aliado__c == null)
                            objOc.Valor_Recurrente_Aliado__c = 0;
                        if(objOc.DescuentoPorc__c == null)
                            objOc.DescuentoPorc__c = 0;
                        
                        if(!Test.isRunningTest())
                        	update LstOCSDemo;
                    }
            	}                
            }
        }
    }
}