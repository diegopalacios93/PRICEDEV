global  with sharing class CambioSuscriptor_ctr implements ObjectPaginatorListener {
	
	public String idCuenta {get;set;}
	Public List<wrpActivos> wActivos  {get;set;}
	Public List<wrpActivos> wActivosTodos  {get;set;}
	public Opportunity opt{get;private set;}
	public Account objCuenta {get;set;}
	public boolean showCFac {get;set;}
	public String strUrl  {get;set;}
	public String cuenta {get;set;}
	public boolean blncheckedAll {get;set;}
	public OperacionComercial__c objOperacion {get;set;}
	public list<ActivoETB__c> lstActivoAnterior {get;set;}
	public infoLupas iLupas{get;set;}
    public String idImgLupa	{get; set;} 
	global ObjectPaginator paginator {get;private set;}
	public CambioSuscriptor_ctr ( ){
        Document objeDoc = new Document();
        objeDoc = [Select Id from Document where Name = 'search' limit 1];
        idImgLupa = objeDoc.Id;
		showCFac = false;
		wActivos = new List<wrpActivos>();
		wActivosTodos = new List<wrpActivos>();
		iLupas=new infoLupas();
		objOperacion = new OperacionComercial__c();	
		idCuenta = ApexPages.currentPage().getParameters().get('idCuenta');
		if(idCuenta != null){
			objCuenta = [select id, name,AccountNumber from Account where id=:idCuenta];			
			iniciar();
			
		}
	}
	public string getContactoInfo(){
		
		return 	'/apex/Filtro?id=003&c='+Filtro_cls.codificar(' Where AccountId =\''+objCuenta.Id+'\' And Estado__c=\'Activo\'')+'&f='+filtro_cls.codificar(',Name');
	}
	public string getCuentaInfo(){
		
		return 	'/apex/Filtro?id=001&c='+Filtro_cls.codificar(' Where RecordType.Name=\'Cliente Principal\'')+'&f='+filtro_cls.codificar(',Name');
	}
	public string getCuentaFacturacionInfo(){
	
		strUrl  = 	'/apex/Filtro?id='+getObjectKeyPrefix('CuentaFacturacion__c')+'&c='+Filtro_cls.codificar((iLupas.cuentaClienteId != null ? ' Where Estado__c =\'Activo\' and Cliente__c = \''+iLupas.cuentaClienteId +'\' ': ' Where Estado__c =\'----\''))+'&f='+filtro_cls.codificar(',Name');
		return strUrl;
	}
    
    public static String getObjectKeyPrefix(String objName){
        schema.sObjectType sObjType = Schema.getGlobalDescribe().get(objName);
        return (sObjType.getDescribe().getKeyPrefix());
    }
    
	public pageReference habilitarCuentaFact(){
		showCFac = true;
		return null;
	}
	public pageReference getSeleccion(){
		showCFac = true;
		return null;
	}
	public void checkAll(){
		for (wrpActivos tmp : wActivosTodos){
				tmp.blnChecked = blncheckedAll;
			}
			
		
	}
	 global void handlePageChange(List<Object> newPage){
                wActivos.clear();
                if(newPage != null){
                        for(Object acct : newPage){
                                wActivos.add((wrpActivos)acct);
                        }
                }
        } 
		public pageReference cambiarSuscriptor(){
			
			map<string,Schema.RecordTypeInfo> formatos = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName();
			//.get('Sucursales').getRecordTypeId();
			
			if( iLupas.contactoAdm == ''){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'El campo Contacto Administrativo es requerido'));
				return null;
			}
			
			if( iLupas.contactoTec == ''){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'El campo Contacto Técnico es requerido'));
				return null;
			}
			if( iLupas.cuentaCliente == ''){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'El campo Cuenta Cliente es requerido'));
				return null;
			}
			/*
			if( iLupas.cuentaFacturacion == ''){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'El campo Cuenta Facturación es requerido'));
				return null;
			}
			*/
			//npi = ' iLupas.contactoAdmId = '+iLupas.contactoAdmId+ ', iLupas.contactoTecId='+iLupas.contactoTecId+',iLupas.cuentaClienteId='+iLupas.cuentaClienteId+', iLupas.cuentaFacturacionId='+ iLupas.cuentaFacturacionId;
			
			boolean hasRecords = false;
			
			//Map<String,TOPP__c> mapTopp1 = new Map<String,TOPP__c>();
			//Map<String,TOPP__c> mapTopp2 = new Map<String,TOPP__c>();
			
			Map<String,OperacionComercial__c> mapOC1 = new Map<String,OperacionComercial__c>();
			Map<String,OperacionComercial__c> mapOC2 = new Map<String,OperacionComercial__c>();
			String strWhereSOrigen = '';
			String strWhereSDestino = '';
			Map<String,ActivoETB__c> mapNuevoActivo = new Map<String,ActivoETB__c>();
			set<Id> productosId=new set<Id>();
			
			list<relacionOC> reOc=new list<relacionOC>();
			
			for (wrpActivos tmp : wActivosTodos){
				if( tmp.blnChecked ){
					//Sucursales
					hasRecords = true;
					if( tmp.activo.SucursalOrigen__c != null)
						strWhereSOrigen += '\''+tmp.activo.SucursalOrigen__c+'\',';
					if( tmp.activo.SucursalDestino__c != null)
						strWhereSDestino += '\''+tmp.activo.SucursalDestino__c+'\',';
					
					// Crear Servicio ETB Nuevo
					ActivoETB__c objActivo = new ActivoETB__c();
					objActivo.NombredelProducto__c = tmp.activo.NombredelProducto__c;
					objActivo.NombredelaCuenta__c = ilupas.cuentaClienteId;
					objActivo.SucursalOrigen__c = tmp.activo.SucursalOrigen__c;
					objActivo.SucursalDestino__c = tmp.activo.SucursalDestino__c;
					objActivo.Plan__c = tmp.activo.Plan__c;
					objActivo.IDservicio__c=tmp.activo.IDservicio__c;
					objActivo.AnchoBanda__c=tmp.activo.AnchoBanda__c;
					objActivo.NumeroConexion__c=tmp.activo.NumeroConexion__c;
                    objActivo.Tipo_Numero_Abreviado__c=tmp.activo.Tipo_Numero_Abreviado__c;
                    objActivo.Numero_Abreviado__c=tmp.activo.Numero_Abreviado__c;
                    objActivo.Cabecera__c=tmp.activo.Cabecera__c;
                    objActivo.Cobertura__c=tmp.activo.Cobertura__c;
                    objActivo.Operador__c=tmp.activo.Operador__c;
                    objActivo.Destinacion__c=tmp.activo.Destinacion__c;
					
					if(ilupas.cuentaFacturacionId!='' && ilupas.cuentaFacturacionId!=null){
					objActivo.CuentaFacturacion__c = ilupas.cuentaFacturacionId;
					}
					mapNuevoActivo.put(tmp.activo.ID , objActivo );
					productosId.add(tmp.activo.NombredelProducto__c);
					
					/*
					// Crear TOPP 1
					TOPP__c objTopp1 = new TOPP__c();
					objTopp1.TipodeOperacionporplan__c = 'Cambio de Suscriptor';
					objTopp1.Plan__c = tmp.activo.Plan__c;
					objTopp1.Tipoderegistro__c = 'C2';
					//mapTopp1.put(tmp.activo.ID,objTopp1);
					*/
					
					
					// Crear Operaci?n Comercial 1 Cambio de Suscriptor 
					OperacionComercial__c objOp1 = new OperacionComercial__c();
					objOp1.Activo__c = tmp.activo.ID;
					objOp1.CuentaCliente__c = tmp.activo.NombredelaCuenta__c;
					objOp1.SucursalOrigen__c =   tmp.activo.SucursalOrigen__c;
					objOp1.SucursalDestino__c =   tmp.activo.SucursalDestino__c;
					objop1.Plan__c = tmp.activo.Plan__c;
					objOp1.Estado__c='Pendiente';
					objOp1.Contacto_Administrativo__c=iLupas.contactoAdmId;
					objOp1.Contacto_Tecnico__c=iLupas.contactoTecId;
					objOp1.IDServicio__c=tmp.activo.IDservicio__c;
					objOp1.NumeroConexion__c=tmp.activo.NumeroConexion__c;
                    objOp1.Tipo_Numero_Abreviado__c=tmp.activo.Tipo_Numero_Abreviado__c;
                    objOp1.Numero_Abreviado__c=tmp.activo.Numero_Abreviado__c;
                    objOp1.Cabecera__c=tmp.activo.Cabecera__c;                    
                    objOp1.Operador__c=tmp.activo.Operador__c;                    
					//onjOp1.TOPP__c =  ???
					mapOC1.put( tmp.activo.ID, objOp1);
					
					
					
					
					// Crear TOPP 2
					
					/*
					TOPP__c objTopp2 = new TOPP__c();
					objTopp2.TipodeOperacionporplan__c = 'Cambio de Suscriptor Nuevo';
					objTopp2.Plan__c = tmp.activo.Plan__c;
					objTopp2.Tipoderegistro__c = 'C2';
					mapTopp2.put(tmp.activo.ID,objTopp2);
					*/
					
					// Crear Operaci?n Comercial 2 Cambio de Suscriptor 
					OperacionComercial__c objOp2 = new OperacionComercial__c();
					objOp2.Activo__c = tmp.activo.ID;
					objOp2.CuentaCliente__c = ilupas.cuentaClienteId;			
					objOp2.SucursalOrigen__c = tmp.activo.SucursalOrigen__c;
					objOp2.SucursalDestino__c = tmp.activo.SucursalDestino__c;
					objOp2.Plan__c = tmp.activo.Plan__c;
					objOp2.Estado__c='Pendiente';
					objOp2.Operacion_Comercial_Relacionada__c=objop1.Id;
					objOp2.IDServicio__c=tmp.activo.IDservicio__c;
					objOp2.NumeroConexion__c=tmp.activo.NumeroConexion__c;
                    objOp2.Tipo_Numero_Abreviado__c=tmp.activo.Tipo_Numero_Abreviado__c;
                    objOp2.Numero_Abreviado__c=tmp.activo.Numero_Abreviado__c;
                    objOp2.Cabecera__c=tmp.activo.Cabecera__c;                    
                    objOp2.Operador__c=tmp.activo.Operador__c; 
					mapOC2.put( tmp.activo.ID, objOp2);
					
					reOc.add(new relacionOC(objOp1,objOp2));
				}
			}
			if ( !hasRecords ){
				
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Seleccione al menos un servicio'));
				return null;
			}
			system.debug(productosId);
			map<string,Topp__c> elMapaTopp = topps(productosId);
			integer hasError=0;

			Savepoint sp = Database.setSavepoint();
						
			try{

				Map<String,Account> mapSucOri= new Map<String,Account>();
				Map<String,Account> mapSucDest = new Map<String,Account>();
				system.debug('\n\n strWhereSOrigen==>'+strWhereSOrigen);
				String soql;
				List<Account> lstAcc;
				if( strWhereSOrigen != '' ){
					strWhereSOrigen = strWhereSOrigen.substring( 0, strWhereSOrigen.length()-1);
					soql = getCreatableFieldsSOQL('Account',' ID in ('+strWhereSOrigen+')');
					
					system.debug('\n\n soqlOrigen==>'+soql);
					
					lstAcc = Database.query(soql);
					system.debug('\n\n lstAccOrigen==>'+lstAcc);
					 	for( Account tmp : lstAcc)		{
							Account suc1 = tmp.clone(false, true);
							suc1.Cuenta__c = iLupas.cuentaClienteId;		
							suc1.Cuenta_Principal__c = 	iLupas.cuentaClienteId;
							mapSucOri.put( tmp.Id, suc1 );	
							
						}
						//system.debug('\n\n mapSucOri==>'+mapSucOri);
						insert mapSucOri.values();
						system.debug('\n\n mapSucOri==>'+mapSucOri);
				 }
					
					system.debug('\n\n strWhereSDestino==>'+strWhereSDestino);
				if( strWhereSDestino != ''){
					strWhereSDestino = strWhereSDestino.substring(0,strWhereSDestino.length()-1);
					soql = getCreatableFieldsSOQL('Account',' id in ('+strWhereSDestino+')');
					system.debug('\n\n soqlDEstino==>'+soql);
					lstAcc = Database.query(soql);
					system.debug('\n\n lstAccDestino==>'+lstAcc);
					for( Account tmp : lstAcc)		{
						Account suc2 = tmp.clone(false, true);
						suc2.Cuenta__c = iLupas.cuentaClienteId;		
						suc2.Cuenta_Principal__c = 	iLupas.cuentaClienteId;	
						mapSucDest.put( tmp.Id, suc2 );	
						
					}
					system.debug('\n\n mapSucDest==>'+mapSucDest);
					insert mapSucDest.values();
				
				}
				
				
				system.debug('\n\n mapNuevoActivo==>'+mapNuevoActivo.values());
				for( ActivoETB__c tmp : mapNuevoActivo.values()){
						
					if( tmp.SucursalOrigen__c != null )
						tmp.SucursalOrigen__c = mapSucOri.get( tmp.SucursalOrigen__c ).id;
					if( tmp.SucursalDestino__c != null )
						tmp.SucursalDestino__c = mapSucDest.get( tmp.SucursalDestino__c ).id;
						
				}
				system.debug('\n\n mapNuevoActivo==>'+mapNuevoActivo);
				
				insert mapNuevoActivo.values();
				
				//insert mapTopp1.values();
				//system.debug('\n\n mapTopp1==>'+mapTopp1);
				
				for ( OperacionComercial__c tmp : mapOC1.values() ){
					//AQUIIIIIIIIIIII
					system.debug(tmp.Activo__c);
					system.debug(mapNuevoActivo.get(tmp.Activo__c).NombredelProducto__c);
					system.debug(elMapaTopp.get(mapNuevoActivo.get(tmp.Activo__c).NombredelProducto__c+'Cambio de Suscriptor'));
					if(elMapaTopp.get(tmp.Plan__c+'Cambio de Suscriptor')==null && elMapaTopp.get(mapNuevoActivo.get(tmp.Activo__c).NombredelProducto__c+'Cambio de Suscriptor')==null){
						hasError++;
						ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No existe Tipo Operación por Plan: Cambio de Suscriptor para el plan '+tmp.Plan__c));
					}else{
                        Topp__c sglTopp = elMapaTopp.get(tmp.Plan__c+'Cambio de Suscriptor')==null?elMapaTopp.get(mapNuevoActivo.get(tmp.Activo__c).NombredelProducto__c+'Cambio de Suscriptor'):elMapaTopp.get(tmp.Plan__c+'Cambio de Suscriptor');
                        tmp.TOPP__c = sglTopp.id;
                        system.debug(sglTopp);
                        tmp.RecordTypeId=formatos.get(sglTopp.Tipoderegistro__c).getRecordTypeId();
						//tmp.TOPP__c = elMapaTopp.get(tmp.Plan__c+'Cambio de Suscriptor').id; //mapTopp1.get( tmp.Activo__c ).Id;
						//system.debug(elMapaTopp.get(tmp.Plan__c+'Cambio de Suscriptor'));
						//tmp.RecordTypeId=formatos.get(elMapaTopp.get(tmp.Plan__c+'Cambio de Suscriptor').Tipoderegistro__c).getRecordTypeId();					
					}		
					
					//tmp.Operacion_Comercial_Relacionada__c = mapOC2.get( tmp.Activo__c ).id;
				}
				insert mapOC1.values();

				
				system.debug('\n\n for in mapOC2.values()');
				
					
				for ( OperacionComercial__c tmp_oc : mapOC2.values() ){
					
					//AQUIIIIIIIIIIIIIIIII
					//ID idToop = mapTopp2.get( tmp_oc.Activo__c ).id;
						
						if(elMapaTopp.get(tmp_oc.Plan__c+'Cambio de Suscriptor Nuevo')==null && elMapaTopp.get(mapNuevoActivo.get(tmp_oc.Activo__c).NombredelProducto__c+'Cambio de Suscriptor Nuevo')==null){
							hasError++;
							ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No existe Tipo Operación por Plan: Cambio de Suscriptor Nuevo para el plan '+tmp_oc.Plan__c));
						}else{
                            Topp__c sglToppNuevo = elMapaTopp.get(tmp_oc.Plan__c+'Cambio de Suscriptor Nuevo')==null?elMapaTopp.get(mapNuevoActivo.get(tmp_oc.Activo__c).NombredelProducto__c+'Cambio de Suscriptor Nuevo'):elMapaTopp.get(tmp_oc.Plan__c+'Cambio de Suscriptor Nuevo');
                            tmp_oc.Activo__c = mapNuevoActivo.get( tmp_oc.Activo__c ).id;
                            system.debug('\n\n 1     '+tmp_oc.Activo__c);
							tmp_oc.TOPP__c = sglToppNuevo.id;
							system.debug(sglToppNuevo);
							tmp_oc.RecordTypeId=formatos.get(sglToppNuevo.Tipoderegistro__c).getRecordTypeId();
						}
						
						
						
						system.debug('\n\n 2   '+tmp_oc.TOPP__c);
						if( tmp_oc.SucursalOrigen__c != null )
							tmp_oc.SucursalOrigen__c = mapSucOri.get( tmp_oc.SucursalOrigen__c ).id;
						if( tmp_oc.SucursalDestino__c != null )
							tmp_oc.SucursalDestino__c = mapSucDest.get( tmp_oc.SucursalDestino__c ).id;					

				}
				system.debug('\n\n mapOC2.values()==>'+mapOC2.values());
				insert mapOC2.values();
				
				list<OperacionComercial__c> actualizarRel=new list<OperacionComercial__c>();
				for(relacionOC relacion :reOc){
					relacion.oper01.Operacion_Comercial_Relacionada__c=relacion.oper02.Id;
					actualizarRel.add(relacion.oper01);
					relacion.oper02.Operacion_Comercial_Relacionada__c=relacion.oper01.Id;
					actualizarRel.add(relacion.oper02);
					
				}
				update actualizarRel;
				
				if(hasError!=0){
					Database.rollback(sp);
					return null;
				}else{
					PageReference p = new PageReference('/'+objCuenta.id);
			        p.setRedirect(true);
			        return p;
				}
			}
			catch(Exception ex){
				Database.rollback(sp);
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()+ex.getStackTraceString()));
				return null;
			}
		}
		// Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
	    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
	         
	        String selects = '';
	         
	        if (whereClause == null || whereClause == ''){ return null; }
	         
	        // Get a map of field name and field token
	        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
	        list<string> selectFields = new list<string>();
	         
	        if (fMap != null){
	            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
	                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
	                if (fd.isCreateable()){ // field is creatable
	                    selectFields.add(fd.getName());
	                }
	            }
	        }
	         
	        if (!selectFields.isEmpty()){
	            for (string s:selectFields){
	                selects += s + ',';
	            }
	            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
	             
	        }
	         
	        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
	         
	    }
		public pagereference iniciar()
		{
		  //configuracion personalizada para excluir servicios LTE	
		  VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE'); //-SAO
		  //lista de todos los registros de la pagina
		  List<ActivoETB__c> lstActivos = [SELECT 
		  					Id,NombredelaCuenta__r.Name, Name,NombredelProducto__r.Name,Oportunidad__r.name ,
		  					SucursalOrigen__c,SucursalDestino__c,NumeroConexion__c,AnchoBanda__c,Plan__c,NombredelProducto__c,NombredelaCuenta__c,IDservicio__c,
							Destinacion__c,Cobertura__c,Numero_Abreviado__c,Operador__c,Cabecera__c,Tipo_Numero_Abreviado__c                                           
		  					FROM ActivoETB__c 
		  					WHERE NombredelaCuenta__c =:idCuenta
		  					//AND Plan__r.NombredelProducto__r.Name != : vGlobal.Valor__c
		  					AND Estado__c = 'Activo'];
		  	for(ActivoETB__c tmp : lstActivos){
		  		wActivosTodos.add(new wrpActivos(tmp,false));
		  	}
		 //RegistrosTodos= ObtenerRegistros(Aliado,sucursalesBus);
		   paginator = new ObjectPaginator(15,this);
		   paginator.setRecords(wActivosTodos);
		   return null;
		}
		public class infoLupas{
    	
	    	public string contactoAdm{get;set;}
	    	public string contactoAdmId{get;set;}   
	    	public string contactoTec{get;set;}
	    	public string contactoTecId{get;set;} 
	    	public string cuentaCliente{get;set;}
	    	public string cuentaClienteId{get;set;} 
	    	public string cuentaFacturacion{get;set;}
	    	public string cuentaFacturacionId{get;set;}  

   		}
		public class wrpActivos{
    
		    public ActivoETB__c activo {get;set;}
		    public boolean blnChecked {get;set;}
		    //recorrer todo produccion:
		    public wrpActivos(ActivoETB__c act, Boolean bln)
		    {
		        activo=act;
		        blnChecked=bln;
		        
		    }
		
		}
		public map<string,Topp__c> topps(set<Id> pro){
			//configuracion personalizada para excluir servicios LTE	
			VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE'); //-SAO
			
			map<string,Topp__c> mapas=new map<string,Topp__c>(); 
			
			list<Topp__c> t =new list<Topp__c>([select name,id, TipodeOperacionporplan__c,Plan__c,Plan__r.NombredelProducto__c,Plan__r.NombredelProducto__r.Name,Tipoderegistro__c,LTE_Catalogo_de_Producto__c,LTE_Catalogo_de_Producto__r.Name 
                                                from Topp__c 
                                                where (Plan__r.NombredelProducto__c IN :pro OR LTE_Catalogo_de_Producto__c IN :pro)
                                                And TipodeOperacionporplan__c IN ('Cambio de Suscriptor','Cambio de Suscriptor Nuevo') 
                                                //and Plan__r.NombredelProducto__r.Name != : vGlobal.Valor__c
                                               ]);
			
			for(Topp__c tt:t){
                if(tt.Plan__c != null)
                    mapas.put(tt.Plan__c+''+tt.TipodeOperacionporplan__c,tt);
                else
                    mapas.put(tt.LTE_Catalogo_de_Producto__c+''+tt.TipodeOperacionporplan__c,tt);
			}
			
			return mapas;
		
		
		}
		
		public class relacionOC{
			
			public OperacionComercial__c oper01 ;
			public OperacionComercial__c oper02 ;
			
			public relacionOC(OperacionComercial__c oper01,OperacionComercial__c oper02){
				this.oper01=oper01;
				this.oper02=oper02;
			}
		
		
		
		}
    
    public PageReference cerrarPagina(){        
		String url;
        url = '/'+idCuenta;        
		PageReference page = new PageReference(url);
		return page;
	}	

}