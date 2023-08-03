/*******************************************************************************
Desarrollado por:       Avanxo Colombia
Autor:                  Andr?s Cubillos
Proyecto:               ETB - CRM etapa 1
Descripci?n:            Clase encargada de la actualizaci?n de los campos del activo desde la operaci?n comercial

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripci?n
------  ----------  --------------------        ---------------
1.0     21-10-2013  Andr?s Cubillos (AAC)       Creaci?n de la clase..
1.1     11-05-2016  Carlos Gonzalez (CG)        Ajuste Plan Anterior.
1.2     11-07-2016  Carlos Gonzalez (CG)        Contingencia - Actualiza el perido de cosnumo de la Cta de Facturación.
1.3		27-09-2016	John Guevara (SQDM)			Se agregan campos del APN de LTE y se crea la clase que permite crear OCs desde un activo
1.4		20-02-2017  Fernando Sarasty (FS)		Se agrega el campo "Numero Abreviado".
1.5		22-11-2018  Samuel Rodriguez (SR)		INI12306-SR-Actualiación de datos OC-AC para GPON.
1.6		17-06-2020  Samuel Rodriguez (SR)		INI10786-SR-Actualizar TOPP Cambio Cuenta de Facturacion solo estado Facturado.
*******************************************************************************/
public class ActualizarCamposActivo_cls {
    
    private list<string> lstCamposActualizar;
    private list<string> lstCamposActualizarOC;
    private string strEstadoEsActivo='';
    private string strEstadoPendienteFac='';
    private string strEstadoFacturado='';
    
    public ActualizarCamposActivo_cls(){        
        
        lstCamposActualizar = new list<string>();
        lstCamposActualizar.add('SucursalOrigen__c');
        lstCamposActualizar.add('SucursalDestino__c');
        lstCamposActualizar.add('IDservicio__c');
        lstCamposActualizar.add('NumeroConexion__c');       
        lstCamposActualizar.add('NumerodePedido__c');
        lstCamposActualizar.add('AnchoBanda__c');
        lstCamposActualizar.add('ProveedorUM__c');
        lstCamposActualizar.add('MedioUM__c');
        lstCamposActualizar.add('RangosDisponibilidad__c');
        lstCamposActualizar.add('Tipo_Capa_de_Conectividad__c');
        lstCamposActualizar.add('Plan__c');
        lstCamposActualizar.add('Equipo__c');
        lstCamposActualizar.add('AliadoColaborador__c');
        lstCamposActualizar.add('CuentaFacturacion__c');
        lstCamposActualizar.add('Lineas__c');
        lstCamposActualizar.add('Tipodeprogramacion__c');
        lstCamposActualizar.add('Activo_Relacionado__c');
        lstCamposActualizar.add('Contrato__c');
        lstCamposActualizar.add('IMEI_del_Equipo__c');
        lstCamposActualizar.add('LTE_ICCID__c');
        lstCamposActualizar.add('Portacion__c');
        lstCamposActualizar.add('PlanAnterior__c');
        lstCamposActualizar.add('LTE_ReferenciaEquipo__c');  
        lstCamposActualizar.add('IP__c');
        lstCamposActualizar.add('POOL_de_APN__c');
        lstCamposActualizar.add('APN__c');
        lstCamposActualizar.add('Pool_de_APN_Chico__c');
        lstCamposActualizar.add('Pool_de_APN_Autopista__c');
        lstCamposActualizar.add('Tipo_de_APN__c');
        lstCamposActualizar.add('Tipo_de_Plan_APN__c');
        lstCamposActualizar.add('PlanLD__c');
        lstCamposActualizar.add('NumeroCanales__c');
        lstCamposActualizar.add('Numero_Abreviado__c');
        lstCamposActualizar.add('Colombia_Compra_Eficiente__c');//INI12306-SR-Actualización de datos OC-AC para GPON
        lstCamposActualizar.add('Tipo_Plan_Gpon__c');			//INI12306-SR
        lstCamposActualizar.add('Ancho_de_Banda_GPON__c');		//INI12306-SR
        lstCamposActualizar.add('Unidad_de_Medida__c');			//INI12306-SR
        lstCamposActualizar.add('BO365_Administracion_restauracion__c');//INI12306-SR        
        lstCamposActualizar.add('Tipo_Numero_Abreviado__c');
        lstCamposActualizar.add('Numero_Abreviado__c');
        lstCamposActualizar.add('Cabecera__c');
        lstCamposActualizar.add('Operador__c');        
        
        //lstCamposActualizar.add('Tecnologia_servicio__c');        
        //Tipodeprogramacion__c
        
        strEstadoEsActivo='Activa';//
        strEstadoPendienteFac='Pendiente Facturacion';
                
        
        lstCamposActualizarOC = new list<string>();
        lstCamposActualizarOC.add('IDservicio__c');
        lstCamposActualizarOC.add('NumeroConexion__c');
        lstCamposActualizarOC.add('Plan__c');
        lstCamposActualizarOC.add('Equipo__c');
        lstCamposActualizarOC.add('CuentaFacturacion__c');
        lstCamposActualizarOC.add('Lineas__c');
        lstCamposActualizarOC.add('Tipodeprogramacion__c');
        lstCamposActualizarOC.add('Contrato__c');
        lstCamposActualizarOC.add('Tipo_de_APN__c');
        lstCamposActualizarOC.add('APN__c');
        lstCamposActualizarOC.add('Tipo_de_Plan_APN__c');        
        lstCamposActualizarOC.add('Numero_Abreviado__c');  
        lstCamposActualizarOC.add('Colombia_Compra_Eficiente__c');	//INI12306-SR-Actualización de datos OC-AC para GPON
        lstCamposActualizarOC.add('Tipo_Plan_Gpon__c');				//INI12306-SR
        lstCamposActualizarOC.add('Ancho_de_Banda_GPON__c');		//INI12306-SR
        lstCamposActualizarOC.add('Unidad_de_Medida__c');			//INI12306-SR
        lstCamposActualizarOC.add('BO365_Administracion_restauracion__c');//INI12306-SR        
    }
    
    
    public void Actualizar(OperacionComercial__c inOC){    
        
        string strCampoOC;
        ActivoETB__c act = new ActivoETB__c();
        TOPP__c TOPPCCF = BuscarTipoOperacion(inOC.TOPP__c);
        if(((inOC.Estado__c==strEstadoEsActivo || inOC.Estado__c==strEstadoPendienteFac) && (TOPPCCF.TipodeOperacionporplan__c!='Cambio Cuenta de Facturacion' && TOPPCCF.TipodeOperacionporplan__c!='Conversión Demo a Venta'))){//Cambio 1.6
            act=BuscarActivo(inOC);         
            if(act!=null){
                system.debug('activo: '+act);
                system.debug('Inoc: '+inOC);
                //antes de actualizar guarda el nombre del plan en un string
                string plan = act.Plan__r.Name; 
                string anchobanda= act.AnchoBanda__r.Name;  
                
                TOPP__c TOPP = BuscarTipoOperacion(inOC.TOPP__c); // 11/05/2016 - [CG] Ajuste Plan Anterio LD
                if(act.LIneadeNegocio__c=='LARGA DISTANCIA' && TOPP.TipodeOperacionporplan__c=='Cambio de Plan' && inOC.PlanLD__c!=null)  
                {                           
                    if(act.PlanLD__c != inOC.PlanLD__c)
                    {                
                        act.Plan_Larga_Distancia_Anterior__c = act.PlanLD__c;
                        act.PlanLD__c = inOC.PlanLD__c;
                    }
                } 
                
                if(act.NombredelProducto__r.Name == Label.SDWAN_Nombre_Producto){
                    if(inOC.Tecnologia_servicio_SDWAN__c != null)
                        act.Tecnologia_servicio__c = String.valueOf(inOC.Tecnologia_servicio_SDWAN__c);
                }                    
                //[FSARASTY, 2020/05/01]: Bolsas compartidas - Actualización de campos
                if(TOPP.Tipoderegistro__c == 'Venta_LTE' && (act.Tipo_linea_bolsa_compartida__c == 'Padre' || act.Tipo_linea_bolsa_compartida__c == 'Hija')){
                    act.LTE_Fecha_Alta_inicial__c=date.today();
                }
                if(TOPP.TipodeOperacionporplan__c == 'Adición bolsa compartida')
                    act.Tipo_linea_bolsa_compartida__c = 'Hija';
                    
                if(TOPP.TipodeOperacionporplan__c == 'Reducción bolsa compartida'){
                    act.Tipo_linea_bolsa_compartida__c = '';
                    act.Activo_Relacionado__c		   = null;                    
                }
                //FIN [FSARASTY, 2020/05/01]: Bolsas compartidas
                
                for(string s: lstCamposActualizar){

                    if(s=='Tipodeprogramacion__c' && inOC.get(s)=='Arranque'){
                        act.put('Activo_Relacionado__c','');
                    }
                    strCampoOC=convertirAString(inOC,s);
                    if(strCampoOC != null && strCampoOC!='' && strCampoOC!='null'){
                        //LEM 20-08-2014 valida que si la linea de negocio del activo es local y la operacion comercial es cambio de
                        //plan debe ser guardado el plan anterior
                        //trae el TOPP anterior
                        //TOPP__c TOPP = BuscarTipoOperacion(inOC.TOPP__c);
                        system.debug('topp: +'+TOPP);
                        if(act.LIneadeNegocio__c=='LOCAL' && TOPP.TipodeOperacionporplan__c=='Cambio de Plan' && s=='Plan__c' )
                        {
                            //asigna el nombre del plan anterior
                            act.PlanAnterior__c=plan;                            
                            act.put(s,inOC.get(s)); 
                        }
                        else if((act.LIneadeNegocio__c=='INTERNET'||act.LIneadeNegocio__c=='DATOS') && TOPP.TipodeOperacionporplan__c=='Cambio de Plan' && s=='AnchoBanda__c' )
                        {
                            act.AnchoBandaAnt__c=anchobanda;                            
                            act.put(s,inOC.get(s)); 
                        }                         
                        else{
                            act.put(s,inOC.get(s));
                        }                      
                    }   
                }                
                update act;         
            }   
        }
        // Actualización de campos relacionados con la venta de Demos y conversión Demos a venta
        if(inOC.Demo__c){
            act=BuscarActivo(inOC);         
            if(act!=null){
                act.Demo__c = true;
                if(inOC.Fecha_Finalizaci_n_Demo__c != null)
                	act.Fecha_Finalizaci_n_Demo__c = inOC.Fecha_Finalizaci_n_Demo__c;
                update act;
            }
        }
        if((TOPPCCF.TipodeOperacionporplan__c=='Conversión Demo a Venta' && inOC.Estado__c=='Facturado') || (TOPPCCF.TipodeOperacionporplan__c=='Conversión Demo a Venta' && TOPPCCF.Facturable__c == false && ((inOC.Estado__c==strEstadoEsActivo || inOC.Estado__c==strEstadoPendienteFac)))){
            act=BuscarActivo(inOC);         
            if(act!=null){
                act.Plan__c = inOC.Plan__c;
                act.Demo__c = false;
                act.CuentaFacturacion__c = inOC.CuentaFacturacion__c;
                act.Fecha_Finalizaci_n_Demo__c = null;
                update act;
            }
        }
    }

	/*
    *@Description: Método que actualiza la cuenta de facturación relacionada a la OC. [CG] - 11/07/2016
    */
	public void actualizarCtaFacturacion(OperacionComercial__c inOC)
	{
		Id retiroId = Schema.SObjectType.OperacionComercial__c.getRecordTypeInfosByName().get('Retiros').getRecordTypeId();
		OperacionComercial__c objOC = [SELECT Estado__c, FechaRetiro__c, RecordTypeId, CuentaFacturacion__c, TOPP__r.Name FROM OperacionComercial__c WHERE Id =: inOC.Id];
		List<CuentaFacturacion__c> lstCuentaFacturacion = [SELECT PeriodoConsumo__c,Fin_de_consumo__c FROM CuentaFacturacion__c WHERE Id =: objOC.CuentaFacturacion__c];
		
		if(objOC.Estado__c==strEstadoEsActivo || objOC.Estado__c==strEstadoPendienteFac){
			if(lstCuentaFacturacion != null)
			{
				if(lstCuentaFacturacion.size() > 0)
				{
					String strTOPP = objOC.TOPP__r.Name;
					CuentaFacturacion__c objCuentaFacturacion = lstCuentaFacturacion[0];		
					// Actualización Cta Facturación para retiros NO LTE
					if(objOC.RecordTypeId == retiroId && !strTOPP.contains('LTE') )
					{
						if (objOC.FechaRetiro__c != null && (String.isEmpty(objCuentaFacturacion.PeriodoConsumo__c) || objOC.FechaRetiro__c > objCuentaFacturacion.Fin_de_consumo__c))
						{
						    Integer month = objOC.FechaRetiro__c.month();
						    Integer year = objOC.FechaRetiro__c.year();
						    month = ( month == 1 ? 12 : month - 1); // Menos un mes
						    year =  ( month == 12 ? year - 1 : year ); // Si cambio de año el mes						    
						    objCuentaFacturacion.PeriodoConsumo__c = year + (month < 10 ? '0' : '' ) + month ;			    			      
						}
					}				
					update objCuentaFacturacion;									
				}
			}			
		}		
	}
    
    private ActivoETB__c BuscarActivo(OperacionComercial__c inOC){
        list<ActivoETB__c> lstAc = new list<ActivoETB__c>();
        ActivoETB__c actOut=null;
        
        lstAc=[select id,LIneadeNegocio__c,plan__r.Name,plan__c,PlanAnterior__c,AnchoBanda__c,AnchoBanda__r.Name, PlanLD__c, Tecnologia_servicio__c,
                NombredelProducto__r.Name, Tipo_linea_bolsa_compartida__c, Demo__c
                from ActivoETB__c
                where id=:inOC.Activo__c
                ];
        if(lstAc.size()>0){
            actOut=lstAc[0];
        }       
        return actOut;
    }
    
        private TOPP__c BuscarTipoOperacion(String idTOP){
        list<TOPP__c> lstTopp = new list<TOPP__c>();
        TOPP__c toppOut=null;
        system.debug(idTOP);
        lstTopp=[select id,Name,TipodeOperacionporplan__c,Tipoderegistro__c, Facturable__c
                from TOPP__c
                where id=:idTOP
                ];
        if(lstTopp.size()>0){
            ToppOut=lstTopp[0];
        }       
        return ToppOut;
    }
    
    private string convertirAString(SObject inOC, string fieldName){
        string strOut=null;
        if(inOC!=null){
            if(inOC.get(fieldName)!=null ){                 
                strOut=string.valueOf(inOC.get(fieldName));
            }
        }
        return strOut;
    }
    
	private string GetStringQuery(list<string> lstObject){
        string strOut='';
        for(string sglString:lstObject){
            strOut+=sglString+', ';
        }
        if(strOut!=''){
            strOut = strOut.substring(0, strOut.length()-2);
        }
        return strOut;
    }
	
    public List<OperacionComercial__c> CrearOCDesdeActivo(List<Id> IdActivos){
        system.debug('Ingreso al metodo ActualizarCamposActivo_cls.CrearOCDesdeActivo');
        string strCampoOC;
        String sQuery;
        List<ActivoETB__c> lstActivos;
        List<OperacionComercial__c> lstOC = new List<OperacionComercial__c>();
        OperacionComercial__c newOC;
        if(IdActivos.size()>0){
            sQuery ='SELECT ' + GetStringQuery(lstCamposActualizarOC) + ' from ActivoETB__c WHERE Id= :IdActivos';
            lstActivos = Database.query(sQuery);
            for(ActivoETB__c sglActivo:lstActivos){
                newOC = new OperacionComercial__c();
                for(string s: lstCamposActualizarOC){
                    strCampoOC=convertirAString(sglActivo,s);
                    newOC.put(s,sglActivo.get(s));
                }
                newOC.Activo__c = sglActivo.Id;
                lstOC.add(newOC);
            }
        }
        return lstOC;
    }    

}