/*******************************************************************************
Develope by:            Avanxo Colombia
Author:                 Carlos A. Rodriguez B. 
Project:                ETB-LTE   
Description:            VisualForce encargada de la creación y edición de cuentas de facturación.                          
Sprint                  1
Release                 1

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                           Descripción
------  ----------  --------------------            ---------------
1.0     31/07/2015  Carlos A. Rodriguez B.          Class creation.
2.0     12/01/2016  Alvaro Sevilla Durango          Adicion de validacion para el campo confirmacion Email
*******************************************************************************/
public class LTE_CreacionCuentaFacturacion_ctr 
{
    public CuentaFacturacion__c objCuentaFact {set;get;}
    public String strNombreCuenta {set;get;}
    public String strNombreCuentaFactPadre {set;get;}
    public String strMetodoEnvioSelec {set;get;}
    public String strCicloFactSelec {set;get;}
    public String strDptoFactSelec {set;get;}
    public String strDptoAltSelec {set;get;}
    public Boolean blnHabilitar {set;get;}
    public boolean blnDisplayPopup {get; set;}
    
    /* BEGIN - Manuel Medina - Variables para almacenar resultado de la integracion de direcciones - 05092016 */
    public String strResponse;
    public String strRequest;
    public String strError;
    /* END - Manuel Medina - Variables para almacenar resultado de la integracion de direcciones - 05092016 */

    public list<SelectOption> lstOpcionesMetodoEnvio
    {
        get 
        {
            list<SelectOption> lstMetEnvio = new list<SelectOption>();
            Schema.DescribeFieldResult fieldResult = CuentaFacturacion__c.LTE_MetodoEnvio__c.getDescribe();
            list<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
            lstMetEnvio.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstMetEnvio.add(new SelectOption(entry.getValue(), entry.getLabel()));
            return lstMetEnvio;
        }
        set;
    }

    /*
    *@Description: Cierra el popup
    */
    public Pagereference closePopup() {        
        blnDisplayPopup = false; 
        return null;   
    }     
    
    /*
    *@Description: Muestra el popup
    */
    public Pagereference showPopup() {                 
        blnDisplayPopup = true;  
        return null;  
    }  
    
    public list<SelectOption> lstOpcionesCicloFact
    {
        get 
        {
            list<SelectOption> lstCiclos = new list<SelectOption>();
            Schema.DescribeFieldResult fieldResult = CuentaFacturacion__c.LTE_CicloFacturacion__c.getDescribe();
            list<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
            lstCiclos.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstCiclos.add(new SelectOption(entry.getValue(), entry.getLabel()));
            return lstCiclos;
        }
        set;
    }

    public list<SelectOption> lstOpcionesMetodoReclam
    {
        get 
        {
            list<SelectOption> lstMetodos = new list<SelectOption>();
            Schema.DescribeFieldResult fieldResult = CuentaFacturacion__c.LTE_MetodosReclamacion__c.getDescribe();
            list<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
            lstMetodos.add(new SelectOption('', label.LTE_OpcionListaNinguno));
            for(Schema.PicklistEntry entry : picklistEntries)
                lstMetodos.add(new SelectOption(entry.getValue(), entry.getLabel()));
            return lstMetodos;
        }
        set;
    }

    /**
    *   @Method:  LTE_CreacionCuentaFacturacion_ctr
    *   @param  
    *   @return
    *   @description: Constructor encargado de cargar datos si es la modificación de una cuenta de facturación. 
    */ 
    public LTE_CreacionCuentaFacturacion_ctr(ApexPages.StandardController controller) 
    {
        objCuentaFact = new CuentaFacturacion__c();        
    }

    public PageReference redirectPage()
    {
        PageReference returnPage;
        String strIdCtaFact = ApexPages.currentPage().getParameters().get('Id');
        //Si la url contiene el id de una cuenta de facturación se carga la información en la Visualforce.
        if (ApexPages.currentPage().getParameters().get('Id') != null)
        {
        	//[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
            list<CuentaFacturacion__c> lstCuentaFact = [SELECT  Id, Name, Cliente__c, LTE_CuentaFacturacionPadre__c, Facturable__c, LTE_MetodoEnvio__c,
                                                                LTE_CicloFacturacion__c, LTE_Email__c, DirCorresp__c, LTE_DireccionAlterna__c, 
                                                                LTE_DepartamentoFacturacion__c, Ciudad__c, LTE_DepartamentoAlterno__c, Fue_creada_en_revchain__c,
                                                                LTE_CiudadAlterna__c, LTE_NombreCuentaFacturacion__c, Cliente__r.Name, LTE_CuentaFacturacionLTE__c,
                                                                LTE_CuentaFacturacionPadre__r.Name
                                                        FROM    CuentaFacturacion__c 
                                                        WHERE   Id =: ApexPages.currentPage().getParameters().get('Id')];            
            
            if (!lstCuentaFact.isEmpty())
            {
                CuentaFacturacion__c objCuentaFactTemp = lstCuentaFact.get(0);
                if(objCuentaFactTemp.LTE_CuentaFacturacionLTE__c == TRUE)
                {
                    blnHabilitar                                = true;
                    objCuentaFact.Name                          = objCuentaFactTemp.Name;
                    objCuentaFact.LTE_NombreCuentaFacturacion__c= objCuentaFactTemp.LTE_NombreCuentaFacturacion__c;
                    objCuentaFact.Cliente__c                    = objCuentaFactTemp.Cliente__c;
                    strNombreCuenta                             = objCuentaFactTemp.Cliente__r.Name;
                    strNombreCuentaFactPadre                    = objCuentaFactTemp.LTE_CuentaFacturacionPadre__r.Name;
                    objCuentaFact.LTE_CuentaFacturacionPadre__c = objCuentaFactTemp.LTE_CuentaFacturacionPadre__c;
                    objCuentaFact.Facturable__c                 = objCuentaFactTemp.Facturable__c;
                    strMetodoEnvioSelec                         = objCuentaFactTemp.LTE_MetodoEnvio__c;
                    strCicloFactSelec                           = objCuentaFactTemp.LTE_CicloFacturacion__c;
                    objCuentaFact.LTE_Email__c                  = objCuentaFactTemp.LTE_Email__c;
                    //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]
                    objCuentaFact.DirCorresp__c					= objCuentaFactTemp.DirCorresp__c;
                    objCuentaFact.LTE_DireccionAlterna__c       = objCuentaFactTemp.LTE_DireccionAlterna__c;
                    objCuentaFact.Ciudad__c                     = objCuentaFactTemp.Ciudad__c;
                    objCuentaFact.LTE_CiudadAlterna__c          = objCuentaFactTemp.LTE_CiudadAlterna__c;
                    strDptoFactSelec                            = objCuentaFactTemp.LTE_DepartamentoFacturacion__c;
                    strDptoAltSelec                             = objCuentaFactTemp.LTE_DepartamentoAlterno__c;
                }
                else
                {
                    returnPage = new PageReference('/' + strIdCtaFact + '/e?nooverride=1&saveURL=/' + strIdCtaFact);
                    returnPage.setRedirect(true);                
                }  
            }                      
        }
        return returnPage;
    }
    /**
    *   @Method: guardar
    *   @param       
    *   @return Pagereference: redirecciona a la cuenta de facturación creada o editada.
    *   @description: Se encarga de mapear la información de la visualforce con los campos del objeto cuentafacturacion.
    */ 
    
    public PageReference guardar()
    {        
        PageReference returnPage;
        objCuentaFact.LTE_CuentaFacturacionLTE__c       = TRUE;
        objCuentaFact.LTE_MetodoEnvio__c                = strMetodoEnvioSelec;
        objCuentaFact.LTE_CicloFacturacion__c           = strCicloFactSelec;
        objCuentaFact.Tipo_de_cuenta__c		            = (objCuentaFact.Facturable__c?'Padre':'Hija');
        
        /* BEGIN - Manuel Medina - Asignacion de estado por defecto para validar direccion - 23082016 */
        //objCuentaFact.DirCorresp__c						= this.objCuentaFact.DirCorresp__c;
        objCuentaFact.AVX_EstadoDireccion__c			= 'Pendiente';
        /* END - Manuel Medina - Asignacion de estado por defecto para validar direccion - 23082016 */

        //si la URL tiene id como parametro, se actualizará dicho registro.
        if ( ApexPages.currentPage().getParameters().get('Id') != null)
        {
            //se llama el metodo validarCampos para validar la obligatoriedad de la información.
            if(validarCampos(objCuentaFact))
            {
                objCuentaFact.Id = ApexPages.currentPage().getParameters().get('Id');

                list<CuentaFacturacion__c> lstCuentaFact = [SELECT  Id, Name, Fue_creada_en_revchain__c
                                                            FROM    CuentaFacturacion__c 
                                                            WHERE   Id =: ApexPages.currentPage().getParameters().get('Id')];            
            
                if (!lstCuentaFact.isEmpty())
                {
                    CuentaFacturacion__c objCuentaFactTemp = lstCuentaFact.get(0);
                    if(objCuentaFactTemp.Fue_creada_en_revchain__c == true)
                    {
                        objCuentaFact.LTE_PendienteModificacion__c = true;
                    }
                }                
                
                update objCuentaFact;
                returnPage = new PageReference('/' + objCuentaFact.Id);
                returnPage.setRedirect(true);
            }
        }
        //De lo contrario la información será insertada
        else
        {
            //se llama el metodo validarCampos para validar la obligatoriedad de la información.
            if(validarCampos(objCuentaFact))
            {
            	/* BEGIN - Manuel Medina - Asignacion de la cuenta creada y validacion de la direccion - 05092016 */
	            consultarDireccion();
	            insert objCuentaFact;
	            generarLogDirecciones();
	            /* END - Manuel Medina - Asignacion de la cuenta creada y validacion de la direccion - 05092016 */
            	
                //insert objCuentaFact;
                returnPage = new PageReference('/' + objCuentaFact.Id);
                returnPage.setRedirect(true);
            }         
        }
        return returnPage;
    }

    /**
    *   @Method: validarCampos
    *   @param objCuentaFact: objeto de cuenta de facturacióin que se validará.      
    *   @return Boolean: Indica true cuando todas las excepciones son superadas.
    *   @description: Se encarga de validar la informacipon reuqerida para que sea ingresada por el usuario. 
    */
    public static Boolean validarCampos(CuentaFacturacion__c objCuentaFact)
    {        
        String strMsjError = label.LTE_ErrorDiligenciarCampo;
        
        
        if(objCuentaFact.LTE_NombreCuentaFacturacion__c.length()==0)
        {
            strMsjError = strMsjError.replace('ABCD', Label.LTE_NombreCuentaFacturacion);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMsjError));
            return false;            
        }
        if (objCuentaFact.Cliente__c == null)
        {
            strMsjError = strMsjError.replace('ABCD', Label.LTE_Cliente);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMsjError));
            return false;
        }
        if (objCuentaFact.LTE_CuentaFacturacionPadre__c == null && objCuentaFact.Facturable__c == false)
        {
            //strMsjError = strMsjError.replace('ABCD', Label.LTE_CuentaFacturacionPadre);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.LTEMenCtaFactPadre));
            return false;
        }
        if (objCuentaFact.LTE_MetodoEnvio__c == null && objCuentaFact.Facturable__c == true)
        {
            strMsjError = strMsjError.replace('ABCD', Label.LTE_Metodoenvio);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMsjError));
            return false;
        }
        if (objCuentaFact.LTE_CicloFacturacion__c == null)
        {
            strMsjError = strMsjError.replace('ABCD',Label.LTE_Ciclofacturacion);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMsjError));
            return false;
        }
        if (objCuentaFact.LTE_Email__c.length()==0 && objCuentaFact.Facturable__c == true)
        {
            strMsjError = strMsjError.replace('ABCD',Label.LTE_Email);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMsjError));
            return false;
        }
        if (objCuentaFact.LTE_Email__c.length()!=0)
        {
            if (!validarEmail(objCuentaFact.LTE_Email__c)) 
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email no valido'));
                return false;
            }
        }      
        //[AG:2016-02-15 Se cambio el campo LTE_DireccionFacturacion__c por DirCorresp__c]             
        //if (objCuentaFact.DirCorresp__c == null)
        if( String.isBlank( objCuentaFact.DirCorresp__c ) )
        {
            strMsjError = strMsjError.replace('ABCD', Label.LTE_DireccionFacturacion);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMsjError));
            return false;
        }
        if (objCuentaFact.Ciudad__c == null)
        {
            strMsjError = strMsjError.replace('ABCD', Label.LTE_CiudadFacturacion);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMsjError));
            return false;
        }
        if (objCuentaFact.LTE_DireccionAlterna__c == null && objCuentaFact.LTE_CiudadAlterna__c != null)
        {
            strMsjError = strMsjError.replace('ABCD', Label.LTE_DireccionAlterna);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMsjError));
            return false;
        }
        if (objCuentaFact.LTE_CiudadAlterna__c == null && objCuentaFact.LTE_DireccionAlterna__c != null)
        {
            strMsjError = strMsjError.replace('ABCD', Label.LTE_CiudadAlterna);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, strMsjError));
            return false;
        }
        if((objCuentaFact.LTE_Email__c != null && objCuentaFact.Confirmacion_Email__c != null) && (objCuentaFact.LTE_Email__c != objCuentaFact.Confirmacion_Email__c))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.Menconfir_Email_Cuenta_Facturacion));
            return false;
            
        }
        return true;
    }

    /**
    *   @Method: validarEmail
    *   @param strEmail: email que se validará.      
    *   @return Boolean: indica si el email tiene o no un formato valido.
    *   @description: Se encarga de validar que el email ingresado por el usuario tenga un formato valido. 
    */
    public static Boolean validarEmail(String strEmail) 
    {
        String strEmailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern MyPattern = Pattern.compile(strEmailRegex);
        Matcher MyMatcher = MyPattern.matcher(strEmail);

        if (!MyMatcher.matches())
            return FALSE;
        else 
            return TRUE;
    }
    
    /**
	* @Method: 		consultarDireccion
	* @param: 		NA
	* @Description: Envia la direccion al normalizador y al finalizar el guardado de la cuenta de facturacion; adicional se registra el log de la transaccion.
	* @author 		Manuel Medina - 05092016
	*/
	public void consultarDireccion() {
		EjecucionIntegracion__c integra = EjecucionIntegracion__c.getValues('Direcciones');
		Boolean hasError	= false;
	
		/*if(integra!=null && integra.Ejecucion__c==false) {
			//return redireccion();
		} else {*/
			tibcoXml_cls tXml=new tibcoXml_cls();
			map<string,string> values=new map<string,string>();
			ServiciosWeb__c sw = ServiciosWeb__c.getValues('NormalizacionDireccion');
			values.put('direccion',objCuentaFact.DirCorresp__c);
			values.put( 'correlationID', obtenerCorrelationId() );
			string request=tibcoXml_cls.normalizacionDireccion(values);
			system.debug('entrada:'+request);
			string response = '';
			if( !Test.isRunningTest() ){
				response=LibreriaUtilitariaJobs_cls.consultarServicio(request,sw.Action__c,sw.EndPoint__c);
			}else{
				response='<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><ns0:WSResponceConsultaNormalizacionEmpresa xmlns:ns0="http://www.etb.com.co/NPlay/SisExt/WS/WSResponceConsultaNormalizacionEmpresa/IN/1.0"><ns1:WSResponseHeader xmlns:ns1="http://www.etb.com.co/LTE/commons/WSResponseHeader/v1.0"><ns1:System correlationID="null" processingServer="?">TIBCO</ns1:System><ns1:Service><ns1:status>PASS</ns1:status><ns1:responseDate>2016-08-26T12:26:30.191-05:00</ns1:responseDate></ns1:Service></ns1:WSResponseHeader><ns1:ConsultaNormalizacionEmpresaReponce xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms" xmlns:ns0="http://www.etb.com.co/NPlay/framework/BusAnyMessage/v1.0" xmlns:ns1="http://www.etb.com.co/NPlay/integration/SisExt/NorGeoCov/ConsultaNormalizacionEmpresa/responce/v1.0"><ns1:direccionNormalizada>AC 26 40 20</ns1:direccionNormalizada><ns1:error>false</ns1:error></ns1:ConsultaNormalizacionEmpresaReponce></ns0:WSResponceConsultaNormalizacionEmpresa></SOAP-ENV:Body></SOAP-ENV:Envelope>';
			}
			
			system.debug(response);
	
			tibcoXml_cls.xmlMap proReq=new tibcoXml_cls.xmlMap();
	
			values.putAll(proReq.getMap(response));
	
			String direccion = values.get('direccionNormalizada');
	
			if(values.get('error') == 'true') {
				hasError = true;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'La direccion ingresada presenta errores por favor valide e intente de nuevo: ' + direccion));
	
				if(direccion.contains('*')) {
					objCuentaFact.AVX_EstadoDireccion__c = 'Con Errores';
				} else {
					objCuentaFact.AVX_EstadoDireccion__c = 'No Normalizada';
				}
			} else {
				System.debug('\n\n-=#=-\n>>>>>>>>>>   ' + 'Validado' + '   <<<<<<<<<<\n-=#=-\n');
	
				hasError                    = false;
				//objCuentaFact.AVX_EstadoDireccion__c  = 'Validado';
				//objCuentaFact.DirCorresp__c         = direccion;
			}
	
			strRequest						= request;
			strResponse						= response;
			strError						= '';
	
			/*return redireccion();
		}*/
	}
	
	/**
	* @Method:		generarLogDirecciones
	* @param:		NA
	* @Description:	Crea regirstro de log para las transacciones de estandarizacion de direcciones
	* @author		Manuel Medina - 05092016
	*/
	public void generarLogDirecciones(){
        LogTransacciones__c objLog		= new LogTransacciones__c(
							                LTE_CuentaFacturacionLTE__c = objCuentaFact.id,
							                Informacion_Enviada__c  = strRequest,
							                Informacion_Recibida__c = strResponse,
							                Estado__c               = objCuentaFact.AVX_EstadoDireccion__c,
							                Name                    = 'Estandarizar direcciones',
							                CodigoRespuesta__c      = strError
							             );
		
		insert objLog;
    }
    
    /**
	* @Method:		obtenerCorrelationId
	* @param:		NA
	* @Description:	Obtener id de correlacion para las transacciones.
	* @author		Manuel Medina - 05092016
	*/
    public String obtenerCorrelationId(){
    	
    	Datetime dttFechaHoraActual	= System.now();
    	Integer intNumeroRandom = Math.round( Math.random() * ( 1000 + dttFechaHoraActual.second() ) );
    	String strCorrelationId = dttFechaHoraActual.format( 'ddMMyyyyHHmmssSSS' ) + String.valueOf( intNumeroRandom );
    	
    	return strCorrelationId;
    }
}