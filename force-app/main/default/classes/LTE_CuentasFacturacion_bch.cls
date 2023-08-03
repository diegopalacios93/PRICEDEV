/*******************************************************************************
Desarrollado por:		Avanxo Colombia
Autor:					Luis Penaranda
Proyecto:				ETB - LTE Fase 1
Descripci?n:			Batch para sincronizar las cuentas de facturacion con RevChain
Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0		23-01-2015	Luis Penaranda(LRP)	        Creacion de la clase 
1.1		11-04-2018	Fernando Sarasty (FS)		Se agrega filtro, para excluir las OC de Portabilidad Saliente
*******************************************************************************/
global class LTE_CuentasFacturacion_bch implements Database.Batchable<SObject>,Database.AllowsCallouts {

	global boolean limitQ=false;
	global integer limiteTotal=30;	
	global boolean esVIP=false;
	global set<id>idImediato=new set<id>();
	
	global Database.Querylocator start(Database.Batchablecontext bc)
	{
		Map<string,VariablesGlobales__c> vGlobal = VariablesGlobales__c.getAll();
		Map<string,LTE_TramitesSuspenda__c> vTramitesSuspenda = LTE_TramitesSuspenda__c.getAll(); // (FS) 11-04-2018

		string producto=vGlobal.get('NombreComercialLTE').valor__c;
		string portabilidadSaliente=vTramitesSuspenda.get('Retiro, Portabilidad Saliente').LTE_Causal__c; // (FS) 11-04-2018
                		
		String query = 'Select id,o.CuentaFacturacion__r.LTE_CiudadAlterna__c, o.CuentaFacturacion__r.TaxPlan__c,o.Legalizacion__r.LTE_CuentaFacturacion__c,';
		 query +=' o.CuentaFacturacion__r.LTE_MetodosReclamacion__c, o.CuentaFacturacion__r.LTE_Email__c, o.CuentaFacturacion__r.LTE_CicloFacturRevchain__c,'; 
		 query +=' o.CuentaFacturacion__r.LTE_CorteFacturacion__c, o.CuentaFacturacion__r.LTE_CuentaFacturacionLTE__c, o.CuentaFacturacion__r.LTE_CicloFacturacion__c,'; 
		 query +=' o.CuentaFacturacion__r.Tipo_Facturacion__c, o.CuentaFacturacion__r.NombreContratoCxC__c, o.CuentaFacturacion__r.Cuenta_Salesforce__c,'; 
		 query +=' o.CuentaFacturacion__r.Facturable__c, o.CuentaFacturacion__r.Fecha_Creacion_cuenta_Revchain__c, o.CuentaFacturacion__r.IdUnico__c,'; 
		 query +=' o.CuentaFacturacion__r.MedioFacturacion__c, o.CuentaFacturacion__r.FechaExFac__c, o.CuentaFacturacion__r.Estado__c,'; 
		 query +=' o.CuentaFacturacion__r.DirCorresp__c, o.CuentaFacturacion__r.CodCicloFac__c, o.CuentaFacturacion__r.Cliente__c, o.CuentaFacturacion__r.Ciudad__c,'; 
		 query +=' o.CuentaFacturacion__r.CreatedDate, o.CuentaFacturacion__r.Name, o.CuentaFacturacion__c '; 
		 query +=' From OperacionComercial__c o';
	 	 query +=' Where (o.Estado__c=\'Activa\' OR o.Estado__c=\'Pendiente Facturacion\') ';
		 query +=' AND TOPP__r.LTE_Catalogo_de_Producto__r.Name=\''+producto+'\' ';
		 query +=' AND (Plan__r.NombredelProducto__r.Name=\''+producto+'\'  or Plan__r.NombredelProducto__r.Name=\'EQUIPO LTE\') ';
		 query +=' AND ((CuentaFacturacion__c != null AND CuentaFacturacion__r.Fue_creada_en_revchain__c = false) OR (Legalizacion__r.LTE_CuentaFacturacion__c != null AND Legalizacion__r.LTE_CuentaFacturacion__r.Fue_creada_en_revchain__c = false ))';
		 query +=' AND CausalRetiro__c != \''+portabilidadSaliente+'\' AND Tipo_linea_bolsa_compartida__c != \'Hija\'';

		if(esVIP){
			query+=' AND LTE_AplicaOnline__c=true ';
		}
		
		if(!idImediato.isEmpty()){
            query+=' AND id IN :idImediato ';   
        }
		
		 if(limitQ){
			query+=' Limit '+limiteTotal+' ';	 	
		} 
		
		system.debug('\nConsultaBatch: '+query);
		
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext bc, List<OperacionComercial__c> scope){        
		//llamar todas las operaciones comerciales que tengan el check habilitado.
		EjecucionIntegracion__c integra =EjecucionIntegracion__c.getValues('Facturacion');
		if(integra!=null && integra.Ejecucion__c==true)
		{		
            system.debug('SCOPE------->' + scope.size());
            LTE_SincronizacionCtasFact_Revchain_cls objCtasFac = new LTE_SincronizacionCtasFact_Revchain_cls();
            objCtasFac.CrearCuentasFacturacion(scope);
        }
	
	}
	global void finish(Database.BatchableContext bc){	
		// lanzar proceso de Facturacion
		LTE_Facturacion_bch contactbtch = new LTE_Facturacion_bch();		
		contactbtch.limitQ = true;
		if(!idImediato.isEmpty()){
			system.debug('\n--------------------------------------------------\n'
		                    +'Va a pasar idImediato al batch de facturacion con '+idImediato+'\n'
		                    +'--------------------------------------------------\n');
            contactbtch.idImediato = idImediato;   
        } 

		contactbtch.limiteTotal=limiteTotal;
		system.debug('limiteTotal--->'+limiteTotal);
		ID batchprocessid = Database.executeBatch(contactbtch,1);
		system.debug('==>batchprocessid:'+batchprocessid);
		system.debug('!!!EXITO');
	}
}