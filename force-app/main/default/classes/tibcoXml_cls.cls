public with sharing class tibcoXml_cls {

	/*/
	* Description: Consulta de IMEI
	*/
    public static String reqConsultaBDO_XML(map<string,string> values)
    {
    	String xmlReq = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/WebServiceConsultas/ConsultaBDO/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:inp="http://www.etb.com.co/LTE/WS/WebServiceConsultas/ConsultaBDO/Input">';    	
		xmlReq += '  <soapenv:Header/>';
		xmlReq += '   <soapenv:Body>';
		xmlReq += '      <ns:WSRequestConsultaBDO>';
		xmlReq += '         <v1:WSRequestHeader>';
		xmlReq += '            <v1:System correlationID="'+values.get('correlationID')+'" processingServer="?">?</v1:System>';
		//xmlReq += '            <v1:Property name="?" value="?">1</v1:Property>';
		xmlReq += '         </v1:WSRequestHeader>';
		xmlReq += '         <inp:RequestBDO>';
		xmlReq += '            <inp:sUsuarioETB>' + values.get('userName') + '</inp:sUsuarioETB>';
        xmlReq += '            <inp:sIMEI>'+ values.get('strIMEI') +'</inp:sIMEI>';
		xmlReq += '            <inp:sTipoDocumento>' + values.get('strTipoDoc') + '</inp:sTipoDocumento>';
		xmlReq += '            <inp:sNumDocumento>' + values.get('strDoc') + '</inp:sNumDocumento>';
		xmlReq += '         </inp:RequestBDO>';
		xmlReq += '      </ns:WSRequestConsultaBDO>';
		xmlReq += '   </soapenv:Body>';
		xmlReq += '</soapenv:Envelope>';

    	return xmlReq;
    }

	/*/
	* Description: Desbloqueo de IMEI
	*/
    public static String reqCancelaRegistroNegativo_XML(map<string,string> values)
    {
    	String xmlReq = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/DeviceManagement/ListasNegras/CancelRegistroNegativo/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:lis="http://www.etb.com.co/LTE/WS/WebServiceConsultas/Consultas/ListasNegras/">';
        xmlReq += '   <soapenv:Header/>';
        xmlReq += '   <soapenv:Body>';
        xmlReq += '      <ns:WSCancelRegistroNegativo>';
        xmlReq += '         <v1:WSRequestHeader>';
        xmlReq += '            <v1:System correlationID="'+values.get('correlationID')+'" processingServer="">1</v1:System>';
        //xmlReq += '            <!--Zero or more repetitions:-->';
        //xmlReq += '            <v1:Property name="?" value="?">1</v1:Property>';
        xmlReq += '         </v1:WSRequestHeader>';
        xmlReq += '         <lis:RegistroPositivo>';
        xmlReq += '            <lis:sUsuarioETB>'+ values.get('userName') +'</lis:sUsuarioETB>';
        xmlReq += '            <lis:sIMEI>' + values.get('strIMEI') + '</lis:sIMEI>';
        xmlReq += '            <lis:sMSISDN>1</lis:sMSISDN>';
        xmlReq += '            <lis:sNombrePropietario>1</lis:sNombrePropietario>';
        xmlReq += '            <lis:sDireccionPropietario>1</lis:sDireccionPropietario>';
        xmlReq += '            <lis:iTipoUsuarioPropietario>1</lis:iTipoUsuarioPropietario>';
        xmlReq += '            <lis:sTipoDocPropietario>' + values.get('strTipoDoc') + '</lis:sTipoDocPropietario>';
        xmlReq += '            <lis:sDocPropietario>' + values.get('strDoc') + '</lis:sDocPropietario>';
        xmlReq += '            <lis:sTelContactoPropietario>1</lis:sTelContactoPropietario>';
        xmlReq += '            <lis:sNombreContacto>1</lis:sNombreContacto>';
        xmlReq += '            <lis:sDireccionContacto>1</lis:sDireccionContacto>';
        xmlReq += '            <lis:iTipoUsuarioAutorizado>1</lis:iTipoUsuarioAutorizado>';
        xmlReq += '            <lis:sTipoDoAutorizado>1</lis:sTipoDoAutorizado>';
        xmlReq += '            <lis:sDocAutorizado>1</lis:sDocAutorizado>';
        xmlReq += '            <lis:sTelContactoAutorizado>1</lis:sTelContactoAutorizado>';
        xmlReq += '         </lis:RegistroPositivo>';
        xmlReq += '      </ns:WSCancelRegistroNegativo>';
        xmlReq += '   </soapenv:Body>';
        xmlReq += '</soapenv:Envelope>';  
        
    	return xmlReq;
    }	


	public static string AnularCun(map<string,string> values){


		string xml='';
			xml='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/SisExt/WSRequestAnularCUN/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/NPlay/integration/SisExt/AnularCun/request/v1.0">'
			    +'<soapenv:Header/>'
			    +'<soapenv:Body>'
			    +'  <ns:WSRequestAnularCUN>'
			    +'     <v1:WSRequestHeader>'
			    +'        <v1:System correlationID="'+values.get('correlationID')+'" processingServer=""></v1:System>'
			    +'        <v1:Property name="" value=""></v1:Property>'
			    +'     </v1:WSRequestHeader>'
			    +'     <v11:AnularCUNRequest>'
			    +'        <v11:NumCUN>'+values.get('NumCun')+'</v11:NumCUN>'
			    +'        <v11:FechaIncidente>'+values.get('FechaIncidente')+'</v11:FechaIncidente>'
			    +'        <v11:Tipologia>'+values.get('Tipologia')+'</v11:Tipologia>'
			    +'        <v11:TipoIdentificacion></v11:TipoIdentificacion>'
			    +'        <v11:Identificacion></v11:Identificacion>'
			    +'        <v11:FechaReporte>'+values.get('FechaIncidente')+'</v11:FechaReporte>'
			    +'        <v11:UsuCreador>'+values.get('UsuCreador')+'</v11:UsuCreador>'
			    +'        <v11:TipoIdentificacionCI>'+values.get('TipoIdentificacionCI')+'</v11:TipoIdentificacionCI>'
			    +'        <v11:IdentificacionCI>'+values.get('IdentificacionCI')+'</v11:IdentificacionCI>'
			    +'        <v11:NumConexion>0</v11:NumConexion>'
			    +'        <v11:Sistema>salesforce</v11:Sistema>'
			    +'        <v11:NumOrden>'+values.get('NumOrden')+'</v11:NumOrden>'
			    +'        <v11:FechaPQR>'+values.get('FechaPQR')+'</v11:FechaPQR>'
			    +'        <v11:Ususario>SALESFORCE</v11:Ususario>'
			    +'        <v11:Contrasena>s4l4c0m2014</v11:Contrasena>'
			    +'     </v11:AnularCUNRequest>'
			    +'  </ns:WSRequestAnularCUN>'
			    +'</soapenv:Body>'
			    +'</soapenv:Envelope>';


		system.debug(xml);
		return xml;	
	}

	public static string HistorialCUN(map<string,string> values){
		string xml='';
			xml='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/SisExt/WSHistorialCUN/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:his="http://www.etb.com.co/NPlay/ConsultaCUN/RequestCUN/v1.0/HistorialCUNInput.xsd">'
			+'   <soapenv:Header/>'
			+'   <soapenv:Body>'
			+'      <ns:WSHistorialCUNRequest>'
			+'         <v1:WSRequestHeader>'
			+'            <v1:System correlationID="'+values.get('correlationID')+'" processingServer=""></v1:System>'
			+'            <!--Zero or more repetitions:-->'
			+'            <v1:Property name="" value=""></v1:Property>'
			+'         </v1:WSRequestHeader>'
			+'         <his:HistorialCUNInput>'
			+'            <!--Optional:-->'
			+'            <his:NumCun></his:NumCun>' //+values.get('NumCun')+
			+'            <!--Optional:-->'
			+'            <his:Identificacion>'+values.get('Identificacion')+'</his:Identificacion>'
			+'            <!--Optional:-->'
			+'            <his:NumConexion></his:NumConexion>'
			+'            <!--Optional:-->'
			+'            <his:TipoIdentificacion>'+values.get('TipoIdentificacion')+'</his:TipoIdentificacion>'
			+'         </his:HistorialCUNInput>'
			+'      </ns:WSHistorialCUNRequest>'
			+'   </soapenv:Body>'
			+'</soapenv:Envelope>';


		system.debug(xml);
		return xml;	
	}
	
	public static string AsignarCUN(map<string,string> values){
	
		string xml='';
		xml='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/SisExt/AsignarCun/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:asig="http://www.etb.com.co/NPlay/ConsultaCUN/RequestCUN/v1.0/AsignaInputCUN.xsd">'
			+'   <soapenv:Header/>'
			+'   <soapenv:Body>'
			+'      <ns:WSAsignarInputCUN>'
			+'         <v1:WSRequestHeader>'
			+'            <v1:System correlationID="'+values.get('correlationID')+'" processingServer=""></v1:System>'
			+'            <!--Zero or more repetitions:-->'
			+'            <v1:Property name="" value=""></v1:Property>'
			+'         </v1:WSRequestHeader>'
			+'         <asig:inputAsignaCUN>'
			+'            <asig:TipoPQR>'+values.get('TipoPQR')+'</asig:TipoPQR>'
			+'            <!--Optional:-->'
			+'            <asig:FechaPQR>'+values.get('FechaPQR')+'</asig:FechaPQR>'
			+'            <asig:NumOrden>'+values.get('NumOrden')+'</asig:NumOrden>'
			+'            <asig:TipoIdentificacion>'+values.get('TipoIdentificacion')+'</asig:TipoIdentificacion>'
			+'            <asig:Identificacion>'+values.get('Identificacion')+'</asig:Identificacion>'
			+'            <asig:NumConexion>'+values.get('NumConexion')+'</asig:NumConexion>'
			+'            <!--Optional:-->'
			+'            <asig:Sistema>SALESFORCE</asig:Sistema>'
			+'         </asig:inputAsignaCUN>'
			+'      </ns:WSAsignarInputCUN>'
			+'   </soapenv:Body>'
			+'</soapenv:Envelope>';
		
		system.debug(xml);
		return xml;	
	}
	
	public static string ConsultarRastroCun(map<string,string> values){
	
		string xml='';
		xml='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/SisExt/ConsultarRastroCun/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/NPlay/integration/SisExt/RastroCun/request/v1.0">'
			+'   <soapenv:Header/>'
			+'   <soapenv:Body>'
			+'      <ns:WSRequestConsultarRastroCun>'
			+'         <v1:WSRequestHeader>'
			+'            <v1:System correlationID="'+values.get('correlationID')+'" processingServer=""></v1:System>'
			+'         </v1:WSRequestHeader>'
			+'         <v11:RequestRastroCun>'
			+'            <v11:NumCun>'+values.get('NumCun')+'</v11:NumCun>'
			+'            <v11:TipoPQR>'+values.get('TipoPQR')+'</v11:TipoPQR>'
			+'            <v11:FechaPQR>'+values.get('FechaPQR')+'</v11:FechaPQR>'
			+'            <v11:Sistema>SALESFORCE</v11:Sistema>'
			+'            <v11:NumOrden>'+values.get('NumOrden')+'</v11:NumOrden>'
			+'            <v11:TipoIdentificacion>'+values.get('TipoIdentificacion')+'</v11:TipoIdentificacion>'
			+'            <v11:Identificacion>'+values.get('Identificacion')+'</v11:Identificacion>'
			+'            <v11:NumConexion>'+values.get('NumConexion')+'</v11:NumConexion>'
			+'         </v11:RequestRastroCun>'
			+'      </ns:WSRequestConsultarRastroCun>'
			+'   </soapenv:Body>'
			+'</soapenv:Envelope>';
		
		system.debug(xml);
		return xml;	
	}
	
	public static string ConsultaScoring(map<string,string> values)
	{
		string xml='';
		xml+='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/LTE/WS/WebServiceConsultas/Scoring/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:ges="http://www.etb.com.co/GestionClientes">'
		+'   <soapenv:Header/>'
		+'   <soapenv:Body>'
		+'      <ns:WSRequestScoring>'
		+'         <v1:WSRequestHeader>'
		+'            <v1:System correlationID="'+values.get('correlationID')+'" processingServer=""></v1:System>'
		+'            <!--Zero or more repetitions:-->'
		+'            <v1:Property name="" value=""></v1:Property>'
		+'         </v1:WSRequestHeader>'
		+'         <ges:GestionClientes>'
		+'            <head>'
		+'               <Interfaz></Interfaz>'
		+'               <Destino></Destino>'
		+'            </head>'
		+'            <body>'
		+'               <Cliente>'
		+'                  <ges:TipoDocumento>'+values.get('TipoDocumento')+'</ges:TipoDocumento>'
		+'                  <ges:NumeroDocumento>'+values.get('NumeroDocumento')+'</ges:NumeroDocumento>'
		+'				  <ges:Nombres></ges:Nombres>'
		+'                  <ges:PrimerApellido></ges:PrimerApellido>'
		+'              </Cliente>'
		+'            </body>'
		+'         </ges:GestionClientes>'
		+'      </ns:WSRequestScoring>'
		+'   </soapenv:Body>'
		+'</soapenv:Envelope>';
		return xml;
	}
	
	public static string normalizacionDireccion1(map<string,string> values)
	{
		string xml='';
		xml+='<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:inp="http://InputMessageNamespace">'
		+'   <soapenv:Header/>'
		+'   <soapenv:Body>'
		+'   	<inp:ConsultaNormalizacionEmpresaOperation soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
		+'   		<direccion xsi:type="xsd:string">'+values.get('direccion')+'</direccion>'
		+'   	</inp:ConsultaNormalizacionEmpresaOperation>'
		+'   </soapenv:Body>'
		+'   </soapenv:Envelope>';
		return xml;
	}
	
    public static string normalizacionDireccion(map<string,string> values)
	{
		string xml='';
		xml+='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.etb.com.co/NPlay/SisExt/WS/WSRequestConsultaNormalizacionEmpresa/IN/1.0" xmlns:v1="http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0" xmlns:v11="http://www.etb.com.co/NPlay/integration/SisExt/NorGeoCov/ConsultaNormalizacionEmpresa/request/v1.0">'
		+'   <soapenv:Header/>'
		+'   <soapenv:Body>'
		+'   	<ns:WSRequestConsultaNormalizacionEmpresa>'
        +'		 <v1:WSRequestHeader>'
        +'    		<v1:System correlationID= "'+values.get('correlationID')+'" processingServer="?">?</v1:System>'
        +' 		</v1:WSRequestHeader>'
        +' 		<v11:ConsultaNormalizacionEmpresaRequest>'
        +'    		<v11:direccion>'+values.get('direccion')+'</v11:direccion>'
        +' 		</v11:ConsultaNormalizacionEmpresaRequest>'
        +'  	</ns:WSRequestConsultaNormalizacionEmpresa>'
		+'   </soapenv:Body>'
		+'   </soapenv:Envelope>';
		return xml;
	}
    
	public static string ConsultaValidacion(map<string,string> values)
	{
		string xml='';
		xml+='<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ns=\"http://www.etb.com.co/LTE/WS/WebServiceConsultas/ConsultaEvidenteValidacion/IN/1.0\" xmlns:v1=\"http://www.etb.com.co/LTE/commons/WSRequestHeader/v1.0\" xmlns:dat=\"http://www.etb.com.co/LTE/WS/WebServiceConsultas/Consultas/DatosValidacion\">';
xml+='   <soapenv:Header/>';
xml+='   <soapenv:Body>';
xml+='      <ns:WSRequestConsultaEvidenteValidacion>';
xml+='         <v1:WSRequestHeader>';
xml+='            <v1:System correlationID="?" processingServer="?">?</v1:System>';
xml+='            <!--Zero or more repetitions:-->';
xml+='            <v1:Property name="?" value="?">?</v1:Property>';
xml+='         </v1:WSRequestHeader>';
xml+='         <dat:DatosValidacion>';
xml+='            <dat:Identificacion>';
xml+='               <dat:numero>'+values.get('numeroDocumento')+'</dat:numero>';
xml+='               <dat:tipo>'+values.get('tipoDocumento')+'</dat:tipo>';
xml+='            </dat:Identificacion>';
xml+='            <dat:PrimerApellido></dat:PrimerApellido>';
xml+='            <!--Optional:-->';
xml+='            <dat:SegundoApellido></dat:SegundoApellido>';
xml+='            <dat:Nombres></dat:Nombres>';
xml+='            <dat:FechaExpedicion>';
xml+='               <dat:timestamp></dat:timestamp>';
xml+='            </dat:FechaExpedicion>';
xml+='         </dat:DatosValidacion>';
xml+='      </ns:WSRequestConsultaEvidenteValidacion>';
xml+='   </soapenv:Body>';
xml+='</soapenv:Envelope>';
		return xml;
	}
	//Retorna un mapeo de xml (No usar cuando existan etiquetas repetidas)
	public class xmlMap{
		
		private map<string,string> valores=new map<string,string>();
		
		public map<string,string> getMap( String strX ){
		
			Dom.Document doc = new Dom.Document();
			system.debug(strX);
			doc.load(strX);
			Dom.XMLNode WS = doc.getRootElement();
			
			iterarXml(WS);
			
			
			return valores;
		}
		
		public void iterarXml(dom.XMLNode dataXml){
			
			List<dom.XMLNode> lsxmlValues = dataXml.getChildElements();
			if(lsxmlValues.size()>0){
				
				for( dom.XMLNode dxm : lsxmlValues){
					iterarXml(dxm);
				}
			}else{
				System.debug('\nMap valores'+dataXml.getName()+''+dataXml.getText());
				valores.put(dataXml.getName(),dataXml.getText());		
			}
		}
	
	}

	public class xmlMapConsulta{
		
		public map<string,string> valores=new map<string,string>();
		public set<string> dataC=new set<string>();
		
		public set<string> getMap( String strX ){
		
			Dom.Document doc = new Dom.Document();
			system.debug(strX);
			doc.load(strX);
			Dom.XMLNode WS = doc.getRootElement();
			
			iterarXml(WS);
			
			
			return dataC;
		}
		
		public void iterarXml(dom.XMLNode dataXml){
			
			List<dom.XMLNode> lsxmlValues = dataXml.getChildElements();
			if(lsxmlValues.size()>0){
				
				for( dom.XMLNode dxm : lsxmlValues){
					iterarXml(dxm);
				}
			}else{
				System.debug('\nMap valores'+dataXml.getName()+''+dataXml.getText());
				valores.put(dataXml.getName(),dataXml.getText());
				if(dataXml.getName()=='NumCun'){
					dataC.add(dataXml.getText());

				}		
			}
		}
	
	}
	
	

}