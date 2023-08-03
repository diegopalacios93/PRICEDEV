/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              Fernando Sarasty
Proyecto:           ETB Portafolio Superior
Descripción:        Clase que genera las integraciones de viabilidad, aprovisionamiento y actualización de servicio 
                    con la aplicación Gestor..

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2018-04-18      Fernando Sarasty (FS)       Creación de la clase.
***********************************************************************************************************************/

public without sharing class PS_IntegracionSalidaGestor_cls{
   
    public static Map<Integer, String> integracionViabilidad(String idObj, String nameObj, String fuente, OperacionComercial__c objOCAux, List<Attachment> lstAttachmentsInput, List<ParametroIntegracion__c> lstParametrosIntegracionInput){
        Map<string,string> values = new map<string,string>();
        Map<Integer, String> resultadoIntegracion = new Map<Integer, String>();        
        String xml;             
        if(fuente == 'OperacionComercial')
        {            
            OperacionComercial__c objoc;            
            if(objOCAux == null)
            	objoc = obtenerDatosOperacionComercial(idObj);            
            else                
                objoc = objOCAux;
            
            xml = generarXMLViabilidad(objoc, nameObj, lstAttachmentsInput, lstParametrosIntegracionInput); 
            System.Debug('--> PS_IntegracionSalidaGestor_cls > Request consulta viabilidad/aprovisionamiento: '+xml);																																																																				
        }
        if(fuente == 'Oportunidad')
        {            
           Opportunity objOp; 
           objOp = obtenerDatosOportunidad(idObj);
           System.Debug('--> PS_IntegracionSalidaGestor_cls > Datos de Oportunidad: '+objOp);
           xml = generarXMLViabilidadOportunidad(objOp, nameObj);
           System.Debug('--> PS_IntegracionSalidaGestor_cls > Request consulta viabilidad/aprovisionamiento: '+xml);
        }        
        System.Debug('--> PS_IntegracionSalidaGestor_cls > Request consulta viabilidad/aprovisionamiento: '+xml);        
        
        //integrar
        resultadoIntegracion = GenerarIntegracion(xml,'Viabilidad');        
        System.Debug('--> PS_IntegracionSalidaGestor_cls > respuesta integracion con gestor: '+resultadoIntegracion);
        return resultadoIntegracion;
    }
    
    public static Map<Integer, String> integracionAprovisionamiento(String idObj, String nameObj, OperacionComercial__c objOCAux, List<Attachment> lstAttachmentsInput, List<ParametroIntegracion__c> lstParametrosIntegracionInput, String NombreVia){                
        Map<string,string> values = new map<string,string>();
        Map<Integer, String> resultadoIntegracion = new Map<Integer, String>();
        String xml;
        OperacionComercial__c objoc;
        if(objOCAux == null)
            objoc = obtenerDatosOperacionComercial(idObj);
        else
            objoc = objOCAux;
        
	    xml = generarXMLAprovisionamiento(objoc, nameObj, lstAttachmentsInput, lstParametrosIntegracionInput, NombreVia);
        
        System.Debug('--> PS_IntegracionSalidaGestor_cls > Request consulta viabilidad/aprovisionamiento: '+xml);
        //integrar
        resultadoIntegracion = GenerarIntegracion(xml, 'Aprovisionamiento');
        System.Debug('--> PS_IntegracionSalidaGestor_cls > respuesta integracion con gestor: '+resultadoIntegracion);
        return resultadoIntegracion;
    }
    
    public static Map<Integer, String> integracionActualizacionServicio(String idObj, String IDServicio){
        Map<Integer, String> resultadoIntegracion = new Map<Integer, String>();
        String xml;
        OperacionComercial__c objoc;
        objoc = obtenerDatosOperacionComercial(idObj);
        xml = generarXMLActualizarServicio(objoc, IDServicio);
        System.Debug('--> PS_IntegracionSalidaGestor_cls > Request integracionActualizacionServicio: '+xml);
        if(xml != null && xml != ''){
            //integrar
            resultadoIntegracion = GenerarIntegracion(xml,'ActualizarServicio');
        }else{
            resultadoIntegracion.put(1, '1');
            resultadoIntegracion.put(2, 'Sin parametros de integracion.');
            resultadoIntegracion.put(3, 'Sin parametros de integracion.');
            resultadoIntegracion.put(4, 'Sin parametros de integracion.');
        }
        return resultadoIntegracion;
    }
   
    public static OperacionComercial__c obtenerDatosOperacionComercial(String idOC) {
        OperacionComercial__c objOc;
        objOc = [Select
                 Activo__r.Name,
                 Activo__c,
                 Activo__r.Estado__c,
                 Activo__r.ExternalServiceID__c,
                 Activo__r.IDservicio__c,
                 Activo__r.NombredelProducto__r.Name,
                 Activo__r.NombredelProducto__r.NEMONICO__c,
                 Activo__r.Plan__r.Name,
                 Activo__r.Plan__r.TipodePlan__c,
                 AliadoColaborador__r.Name,
                 AnchoBanda__r.Name,
                 Caso__r.CaseNumber,
                 Caso__r.id,
                 Contacto_Tecnico__r.Email,
                 Contacto_Tecnico__r.Name,
                 Contacto_Tecnico__r.Phone,
                 Contacto_Tecnico__r.MobilePhone,
                 Contacto_Administrativo__r.Email,
                 Contacto_Administrativo__r.Name,
                 Contacto_Administrativo__r.Phone,
                 Contacto_Administrativo__r.MobilePhone,
                 CuentaCliente__r.AccountNumber,
                 CuentaCliente__r.Name,
                 CuentaCliente__r.Administrador_Experiencia_al_Cliente__c,
                 CuentaCliente__r.Owner.Name,
                 CuentaCliente__r.Owner.Email,
                 CuentaCliente__r.Owner.MobilePhone,
                 CuentaCliente__r.Owner.Phone,
                 CuentaCliente__r.ValordeCliente__c,
                 CuentaCliente__r.Segmento__c,
                 CuentaCliente__r.Owner.DireccionVentasAsesor__c,
                 CuentaFacturacion__r.Name,
                 Legalizacion__r.Contrato__r.EndDate,
                 Legalizacion__r.Contrato__r.StartDate,
                 Legalizacion__r.Contrato__r.ContractNumber,
                 Legalizacion__r.Contrato__r.Renovacion_Automatica__c,
                 Opcion_Aprovisionamiento__r.IdOpcion__c,
                 Oportunidad__r.ANS__c,
                 Oportunidad__r.Consecutivooportunidades__c,
                 Oportunidad__r.RecordTypeId,
                 Oportunidad__r.RecordType.Name,
                 Oportunidad__r.RecordType.DeveloperName,
                 Oportunidad__r.Name,
                 Oportunidad__r.id,
                 Oportunidad__r.Tipo_de_Oportunidad__c,
                 Oportunidad__r.Viabilidad_Adicional__c,
                 Plan__r.NombredelProducto__r.CodigoProducto__c,
                 Plan__r.NombredelProducto__r.Name,
                 Plan__r.NombredelProducto__r.NEMONICO__c,
                 Plan__r.TipodePlan__c,
                 SucursalOrigen__r.Ciudad__r.Name,
                 SucursalOrigen__r.Ciudad__r.ciudad_departamento__c,
                 SucursalOrigen__r.Ciudad__r.Departamento__c,
                 SucursalOrigen__r.Name,
                 SucursalOrigen__r.Ciudad__r.Tipo_de_instalacion__c,
                 SucursalOrigen__r.Direccion__c,
                 TOPP__r.ANS_Factibilidad__c,
                 TOPP__r.ANS__c,
                 TOPP__r.TipodeOperacionporplan__c,
                 Comentarios__c,
                 Duracion_Dias__c,
                 Duracion_Meses__c,
                 id,
                 MedioUM__c,
                 Name,
                 NumeroConexion__c,
                 ProveedorUM__c,
                 Tipo_Capa_de_Conectividad__c,
                 RangosDisponibilidad__c,
                 Servicios_Adicionales_P_Superior__c,
                 Tipologia_Preventa__c,
                 TOPP__c,
                 Detalle_del_tramite__c,
                 Viabilidad_Relacionada__c,
                 Viabilidad_Relacionada__r.Name
                 From OperacionComercial__c
                 Where id=:idOC LIMIT 1];
        system.debug(objOc.Plan__r.TipodePlan__c);
        return objOc;
    }
    
    public static Opportunity obtenerDatosOportunidad(String idOP) {
        Opportunity objOp;
        objOp = [Select
                 ANS__c,
                 Account.Name,
                 Account.Administrador_Experiencia_al_Cliente__c,
                 Account.Owner.Name,
                 Account.Owner.Email,
                 Account.Owner.MobilePhone,
                 Account.Owner.Phone,
                 Account.ValordeCliente__c,
                 Account.AccountNumber,
                 Account.Segmento__c,
                 Contacto__r.Email,
                 Contacto__r.Name,
                 Contacto__r.Phone,
                 Contacto__r.MobilePhone,
                 Plan__r.Tipo_Operaci_n_por_Plan__r.Id,
                 Plan__r.Tipo_Operaci_n_por_Plan__c,
                 Plan__r.Id,
                 Consecutivooportunidades__c,
                 Description,
                 Descripci_n_VIA_Consultiva__c,
                 RecordTypeId,
                 RecordType.Name,
                 Linea_de_Negocio_Principal__c,
                 Duracion_Dias__c,
                 Duracion_Meses__c,
                 Tipo_de_Operacion__c,
                 Tipo_de_Oportunidad__c,
                 Name,
                 Type,
                 id
                 From Opportunity
                 Where id=:idOP];
        return objOp;
    }
    
    public static string generarXMLViabilidad(OperacionComercial__c OperacionComercial, String NumeroVia, List<Attachment> lstAttachmentsInput, List<ParametroIntegracion__c> lstParametrosIntegracionInput)
    {
        Integer diasANS;
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        PS_IntegrationHelper_ctr hlpInteg= new PS_IntegrationHelper_ctr();
        
        if(OperacionComercial.Oportunidad__r.ANS__c != null)
            diasANS = (integer.valueof(OperacionComercial.Oportunidad__r.ANS__c))*1440;
        else if(OperacionComercial.TOPP__r.ANS_Factibilidad__c != null)
            diasANS = (integer.valueof(OperacionComercial.TOPP__r.ANS_Factibilidad__c))*1440;
        else
            diasANS = 0;
            
        String  xmlAux;
        String  xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tier="http://schemas.datacontract.org/2004/07/Tier.Common" xmlns:ws="http://schemas.datacontract.org/2004/07/WS.Gestor.RequestContracts" xmlns:ws1="http://schemas.datacontract.org/2004/07/WS.Gestor.DataContracts" xmlns:sys="http://schemas.datacontract.org/2004/07/System.Collections.Generic" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">';
                xml+= '<soapenv:Header/>';
                xml+= '<soapenv:Body>';
                    xml+='<tem:CrearSolicitud>		';
                xml+='<tem:WSRequestHeader>';
                xml+='<tier:property>';
                xml+='<tier:Scheme_Services.Property>';
                xml+='<tier:name></tier:name>';
                xml+='<tier:value></tier:value>';
                xml+='</tier:Scheme_Services.Property>';
                xml+='</tier:property>';
                xml+='<tier:system>';
                xml+='<tier:correlationId>'+OperacionComercial.Id+'</tier:correlationId>';
                xml+='<tier:name></tier:name>';
                xml+='<tier:processingServer></tier:processingServer>';
                xml+='</tier:system>';
                xml+='</tem:WSRequestHeader>';
                xml+='<tem:WSRequestBody>';
                xml+='<ws:AsesorComercial>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.Name)?'':OperacionComercial.CuentaCliente__r.Owner.Name)+'</ws:AsesorComercial>';
                xml+='<ws:CiudadInstalacion>'+(String.isBlank(OperacionComercial.SucursalOrigen__r.Ciudad__r.ciudad_departamento__c)?'':OperacionComercial.SucursalOrigen__r.Ciudad__r.ciudad_departamento__c)+'</ws:CiudadInstalacion>';
                xml+=' <ws:ClienteValor>'+(String.isBlank(OperacionComercial.CuentaCliente__r.ValordeCliente__c)?'':OperacionComercial.CuentaCliente__r.ValordeCliente__c)+'</ws:ClienteValor>';
                xml+='<ws:CodigoProducto>'+(String.isBlank(OperacionComercial.Plan__r.NombredelProducto__r.CodigoProducto__c)?'':OperacionComercial.Plan__r.NombredelProducto__r.CodigoProducto__c)+'</ws:CodigoProducto>';
                xml+='<ws:Comentarios>'+(String.isBlank(OperacionComercial.Comentarios__c)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.Comentarios__c))+'</ws:Comentarios>';
                xml+='<ws:Contactos>';
                if(OperacionComercial.Contacto_Tecnico__r.Name != null){
                    xml+='<ws1:Contacto>';
                    xml+='<ws1:Apellidos></ws1:Apellidos>';
                    xml+='<ws1:CorreoElectronico>'+(String.isBlank(OperacionComercial.Contacto_Tecnico__r.Email)?'':OperacionComercial.Contacto_Tecnico__r.Email)+'</ws1:CorreoElectronico>';
                    xml+='<ws1:Nombres>'+(String.isBlank(OperacionComercial.Contacto_Tecnico__r.Name)?'':OperacionComercial.Contacto_Tecnico__r.Name)+'</ws1:Nombres>';
                    xml+='<ws1:Telefono>'+(String.isBlank(OperacionComercial.Contacto_Tecnico__r.Phone)?'':OperacionComercial.Contacto_Tecnico__r.Phone)+'</ws1:Telefono>';
                    xml+='<ws1:TelefonoMovil>'+(String.isBlank(OperacionComercial.Contacto_Tecnico__r.MobilePhone)?'':OperacionComercial.Contacto_Tecnico__r.MobilePhone)+'</ws1:TelefonoMovil>';
                    xml+='<ws1:Tipo>Contacto Tecnico</ws1:Tipo>';
                    xml+='</ws1:Contacto>';
                }
                if(OperacionComercial.Contacto_Administrativo__r.Name != null){
                    xml+='<ws1:Contacto>';
                    xml+='<ws1:Apellidos></ws1:Apellidos>';
                    xml+='<ws1:CorreoElectronico>'+(String.isBlank(OperacionComercial.Contacto_Administrativo__r.Email)?'':OperacionComercial.Contacto_Administrativo__r.Email)+'</ws1:CorreoElectronico>';
                    xml+='<ws1:Nombres>'+(String.isBlank(OperacionComercial.Contacto_Administrativo__r.Name)?'':OperacionComercial.Contacto_Administrativo__r.Name)+'</ws1:Nombres>';
                    xml+='<ws1:Telefono>'+(String.isBlank(OperacionComercial.Contacto_Administrativo__r.Phone)?'':OperacionComercial.Contacto_Administrativo__r.Phone)+'</ws1:Telefono>';
                    xml+='<ws1:TelefonoMovil>'+(String.isBlank(OperacionComercial.Contacto_Administrativo__r.MobilePhone)?'':OperacionComercial.Contacto_Administrativo__r.MobilePhone)+'</ws1:TelefonoMovil>';
                    xml+='<ws1:Tipo>Contacto Administrativo</ws1:Tipo>';
                    xml+='</ws1:Contacto>';
                }
                if(OperacionComercial.CuentaCliente__r.Owner.Name != null){
                    xml+='<ws1:Contacto>';
                    xml+='<ws1:Apellidos></ws1:Apellidos>';
                    xml+='<ws1:CorreoElectronico>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.Email)?'':OperacionComercial.CuentaCliente__r.Owner.Email)+'</ws1:CorreoElectronico>';
                    xml+='<ws1:Nombres>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.Name)?'':OperacionComercial.CuentaCliente__r.Owner.Name)+'</ws1:Nombres>';
                    xml+='<ws1:Telefono>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.Phone)?'':OperacionComercial.CuentaCliente__r.Owner.Phone)+'</ws1:Telefono>';
                    xml+='<ws1:TelefonoMovil>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.MobilePhone)?'':OperacionComercial.CuentaCliente__r.Owner.MobilePhone)+'</ws1:TelefonoMovil>';
                    xml+='<ws1:Tipo>Asesor Comercial</ws1:Tipo>';
                    xml+='</ws1:Contacto>';
                }
                xml+='</ws:Contactos>';
                xml+='<ws:CuentaCliente>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.CuentaCliente__r.Name))+'</ws:CuentaCliente>';
                xml+='<ws:DatosViabilidad>';
                xml+='<ws1:DatosAdicionalesViabilidad>';
                xmlAux = obtenerParametrosIntegracion(OperacionComercial.TOPP__c, OperacionComercial.Id, 'DatosAdicionalesViabilidad', 'Viabilidad','', lstParametrosIntegracionInput);
                if(xmlAux != null && xmlAux != ''){
                    xml+= xmlAux;
                }
                xml+='</ws1:DatosAdicionalesViabilidad>';
                xml+='</ws:DatosViabilidad>';
                xml+='<ws:DireccionPrincipal>'+(String.isBlank(OperacionComercial.SucursalOrigen__r.Direccion__c)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.SucursalOrigen__r.Direccion__c))+'</ws:DireccionPrincipal>';
                xml+='<ws:DuracionServicioDias>'+OperacionComercial.Duracion_Dias__c+'</ws:DuracionServicioDias>';
                xml+='<ws:DuracionServicioMeses>'+OperacionComercial.Duracion_Meses__c+'</ws:DuracionServicioMeses>';
                xml+='<ws:EjecutivoExperiencia>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Administrador_Experiencia_al_Cliente__c)?'':OperacionComercial.CuentaCliente__r.Administrador_Experiencia_al_Cliente__c)+'</ws:EjecutivoExperiencia>';
                xml+='<ws:IdViabilidad>'+NumeroVia+'</ws:IdViabilidad>';
                xml+='<ws:IndicadorAgrupacion>'+(OperacionComercial.Oportunidad__r.Consecutivooportunidades__c != null?OperacionComercial.Oportunidad__r.Consecutivooportunidades__c:OperacionComercial.Caso__r.CaseNumber)+'</ws:IndicadorAgrupacion>';
                xml+='<ws:Nit>'+(String.isBlank(OperacionComercial.CuentaCliente__r.AccountNumber)?'':OperacionComercial.CuentaCliente__r.AccountNumber)+'</ws:Nit>';
                xml+='<ws:NombreOperacionComercial>'+(String.isBlank(OperacionComercial.Name)?'':OperacionComercial.Name)+'</ws:NombreOperacionComercial>';
                xml+='<ws:NombreOportunidad>'+(String.isBlank(OperacionComercial.Oportunidad__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.Oportunidad__r.Name))+'</ws:NombreOportunidad>';
                xml+='<ws:NombreProducto>'+(String.isBlank(OperacionComercial.Plan__r.NombredelProducto__r.Name)?'':((OperacionComercial.Plan__r.NombredelProducto__r.Name==vGlobal.Valor__c && OperacionComercial.Plan__r.TipodePlan__c=='Troncal SIP')?'Troncales SIP - Móvil':OperacionComercial.Plan__r.NombredelProducto__r.Name))+'</ws:NombreProducto>';
                xml+='<ws:NumeroCaso>'+(String.isBlank(OperacionComercial.Caso__r.CaseNumber)?'':OperacionComercial.Caso__r.CaseNumber)+'</ws:NumeroCaso>';
                xml+='<ws:NumeroOportunidad>'+(String.isBlank(OperacionComercial.Oportunidad__r.Consecutivooportunidades__c)?'':OperacionComercial.Oportunidad__r.Consecutivooportunidades__c)+'</ws:NumeroOportunidad>';
                xml+='<ws:Segmento>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.DireccionVentasAsesor__c)?'':OperacionComercial.CuentaCliente__r.Owner.DireccionVentasAsesor__c)+'</ws:Segmento>';
                xml+='<ws:ServiciosAdicionales>';
                if(OperacionComercial.Servicios_Adicionales_P_Superior__c != null)
                    xml+='<arr:string>'+OperacionComercial.Servicios_Adicionales_P_Superior__c+'</arr:string>';
                xml+='</ws:ServiciosAdicionales>';
                xml+='<ws:SucursalInstalcion>'+(String.isBlank(OperacionComercial.SucursalOrigen__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.SucursalOrigen__r.Name))+'</ws:SucursalInstalcion>';
                xml+='<ws:TiempoAns>'+diasANS+'</ws:TiempoAns>';
                xml+='<ws:TipoInstalacion>'+(String.isBlank(OperacionComercial.SucursalOrigen__r.Ciudad__r.Tipo_de_instalacion__c)?'':OperacionComercial.SucursalOrigen__r.Ciudad__r.Tipo_de_instalacion__c)+'</ws:TipoInstalacion>';
                xml+='<ws:TipoOperacionPlan>'+(String.isBlank(OperacionComercial.TOPP__r.TipodeOperacionporplan__c)?'':OperacionComercial.TOPP__r.TipodeOperacionporplan__c)+'</ws:TipoOperacionPlan>';
                xml+='<ws:TipoOportunidad>'+(String.isBlank(OperacionComercial.Oportunidad__r.RecordType.DeveloperName)?'Sin Oportunidad':OperacionComercial.Oportunidad__r.RecordType.DeveloperName)+'</ws:TipoOportunidad>';
                xml+='<ws:TipoSolicitud>Viabilidad</ws:TipoSolicitud>';
                xml+='<ws:TipologiaVenta>'+(String.isBlank(OperacionComercial.Tipologia_Preventa__c)?'':OperacionComercial.Tipologia_Preventa__c)+'</ws:TipologiaVenta>';
                xml+='<ws:UrlsRecursosSalesforce>';
                xmlAux = obtenerArchivosAjuntos(OperacionComercial.Oportunidad__r.Id, OperacionComercial.Caso__r.Id, lstAttachmentsInput);
                if(xmlAux != null && xmlAux != '')
                    xml+= xmlAux;
                xml+='</ws:UrlsRecursosSalesforce>';
                xml+='<ws:UsuarioCreacionSalesForce>'+UserInfo.getUserName()+'</ws:UsuarioCreacionSalesForce>';
                xml+='<ws:ViabilidadRelacionada>'+(String.isBlank(OperacionComercial.Viabilidad_Relacionada__r.Name)? '' : OperacionComercial.Viabilidad_Relacionada__r.Name)+'</ws:ViabilidadRelacionada>';
                //--- final ---
                xml+='</tem:WSRequestBody>';
                xml+='</tem:CrearSolicitud>';
                xml+='</soapenv:Body>';
                xml+='</soapenv:Envelope>';
                
        return xml;
    }
    
    public static string generarXMLViabilidadOportunidad(Opportunity Oportunidad, String NumeroVia){
        String  xmlAux;
        Integer diasANS;
        if(Oportunidad.ANS__c != null)
            diasANS = (integer.valueof(Oportunidad.ANS__c))*1440;
        else
            diasANS = 0;
        
        PS_IntegrationHelper_ctr hlpInteg= new PS_IntegrationHelper_ctr();
        
        String  xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tier="http://schemas.datacontract.org/2004/07/Tier.Common" xmlns:ws="http://schemas.datacontract.org/2004/07/WS.Gestor.RequestContracts" xmlns:ws1="http://schemas.datacontract.org/2004/07/WS.Gestor.DataContracts" xmlns:sys="http://schemas.datacontract.org/2004/07/System.Collections.Generic" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">';
                xml+= '<soapenv:Header/>';
                xml+= '<soapenv:Body>';
                xml+='<tem:CrearSolicitud>';
                xml+='<tem:WSRequestHeader>';
                xml+='<tier:property>';
                xml+='<tier:Scheme_Services.Property>';
                xml+='<tier:name></tier:name>';
                xml+='<tier:value></tier:value>';
                xml+='</tier:Scheme_Services.Property>';
                xml+='</tier:property>';
                xml+='<tier:system>';
                xml+='<tier:correlationId>'+Oportunidad.Id+'</tier:correlationId>';
                xml+='<tier:name></tier:name>';
                xml+='<tier:processingServer></tier:processingServer>';
                xml+='</tier:system>';
                xml+='</tem:WSRequestHeader>';
                xml+='<tem:WSRequestBody>';
                xml+='<ws:AsesorComercial>'+(String.isBlank(Oportunidad.Account.Owner.Name)?'':Oportunidad.Account.Owner.Name)+'</ws:AsesorComercial>';
                xml+='<ws:CiudadInstalacion></ws:CiudadInstalacion>';
                xml+=' <ws:ClienteValor>'+(String.isBlank(Oportunidad.Account.ValordeCliente__c)?'':Oportunidad.Account.ValordeCliente__c)+'</ws:ClienteValor>';
                xml+='<ws:CodigoProducto>'+(String.isBlank(Oportunidad.Linea_de_Negocio_Principal__c)?'':Oportunidad.Linea_de_Negocio_Principal__c)+'</ws:CodigoProducto>';
                xml+='<ws:Comentarios>'+(String.isBlank(Oportunidad.Descripci_n_VIA_Consultiva__c)?'':hlpInteg.ReplaceUTF8Character(Oportunidad.Descripci_n_VIA_Consultiva__c))+'</ws:Comentarios>';
                xml+='<ws:Contactos>';
                xml+='<ws1:Contacto>';
                xml+='<ws1:Apellidos></ws1:Apellidos>';
                xml+='<ws1:CorreoElectronico>'+(String.isBlank(Oportunidad.Contacto__r.Email)?'':Oportunidad.Contacto__r.Email)+'</ws1:CorreoElectronico>';
                xml+='<ws1:Nombres>'+(String.isBlank(Oportunidad.Contacto__r.Name)?'':Oportunidad.Contacto__r.Name)+'</ws1:Nombres>';
                xml+='<ws1:Telefono>'+(String.isBlank(Oportunidad.Contacto__r.Phone)?'':Oportunidad.Contacto__r.Phone)+'</ws1:Telefono>';
                xml+='<ws1:TelefonoMovil>'+(String.isBlank(Oportunidad.Contacto__r.MobilePhone)?'':Oportunidad.Contacto__r.MobilePhone)+'</ws1:TelefonoMovil>';
                xml+='<ws1:Tipo></ws1:Tipo>';
                xml+='</ws1:Contacto>';
                if(Oportunidad.Account.Owner.Name != null){
                    xml+='<ws1:Contacto>';
                    xml+='<ws1:Apellidos></ws1:Apellidos>';
                    xml+='<ws1:CorreoElectronico>'+(String.isBlank(Oportunidad.Account.Owner.Email)?'':Oportunidad.Account.Owner.Email)+'</ws1:CorreoElectronico>';
                    xml+='<ws1:Nombres>'+(String.isBlank(Oportunidad.Account.Owner.Name)?'':Oportunidad.Account.Owner.Name)+'</ws1:Nombres>';
                    xml+='<ws1:Telefono>'+(String.isBlank(Oportunidad.Account.Owner.Phone)?'':Oportunidad.Account.Owner.Phone)+'</ws1:Telefono>';
                    xml+='<ws1:TelefonoMovil>'+(String.isBlank(Oportunidad.Account.Owner.MobilePhone)?'':Oportunidad.Account.Owner.MobilePhone)+'</ws1:TelefonoMovil>';
                    xml+='<ws1:Tipo>Asesor Comercial</ws1:Tipo>';
                    xml+='</ws1:Contacto>';
                }
                xml+='</ws:Contactos>';
                xml+='<ws:CuentaCliente>'+(String.isBlank(Oportunidad.Account.Name)?'':hlpInteg.ReplaceUTF8Character(Oportunidad.Account.Name))+'</ws:CuentaCliente>';
                xml+='<ws:DatosViabilidad>';
                xml+='<ws1:DatosAdicionalesViabilidad>';
                xmlAux = obtenerParametrosIntegracion(Oportunidad.Plan__r.Tipo_Operaci_n_por_Plan__c, Oportunidad.Id, 'DatosAdicionalesViabilidad', 'Viabilidad','', null);
                if(xmlAux != null && xmlAux != ''){
                    xml+= xmlAux;
                }
                xml+='</ws1:DatosAdicionalesViabilidad>';
                xml+='</ws:DatosViabilidad>';
                xml+='<ws:DireccionPrincipal></ws:DireccionPrincipal>';
                xml+='<ws:DuracionServicioDias>'+Oportunidad.Duracion_Dias__c+'</ws:DuracionServicioDias>';
                xml+='<ws:DuracionServicioMeses>'+Oportunidad.Duracion_Meses__c+'</ws:DuracionServicioMeses>';
                xml+='<ws:EjecutivoExperiencia>'+(String.isBlank(Oportunidad.Account.Administrador_Experiencia_al_Cliente__c)?'':Oportunidad.Account.Administrador_Experiencia_al_Cliente__c)+'</ws:EjecutivoExperiencia>';
                xml+='<ws:IdViabilidad>'+NumeroVia+'</ws:IdViabilidad>';
                xml+='<ws:IndicadorAgrupacion>'+(String.isBlank(Oportunidad.Consecutivooportunidades__c)?'':Oportunidad.Consecutivooportunidades__c)+'</ws:IndicadorAgrupacion>';
                xml+='<ws:Nit>'+(String.isBlank(Oportunidad.Account.AccountNumber)?'':Oportunidad.Account.AccountNumber)+'</ws:Nit>';
                xml+='<ws:NombreOperacionComercial></ws:NombreOperacionComercial>';
                xml+='<ws:NombreOportunidad>'+(String.isBlank(Oportunidad.Name)?'':hlpInteg.ReplaceUTF8Character(Oportunidad.Name))+'</ws:NombreOportunidad>';
                xml+='<ws:NombreProducto>'+(String.isBlank(Oportunidad.Linea_de_Negocio_Principal__c)?'':Oportunidad.Linea_de_Negocio_Principal__c)+'</ws:NombreProducto>';
                xml+='<ws:NumeroCaso></ws:NumeroCaso>';
                xml+='<ws:NumeroOportunidad>'+(String.isBlank(Oportunidad.Consecutivooportunidades__c)?'':Oportunidad.Consecutivooportunidades__c)+'</ws:NumeroOportunidad>';
                xml+='<ws:Segmento>'+(String.isBlank(Oportunidad.Account.Segmento__c)?'':Oportunidad.Account.Segmento__c)+'</ws:Segmento>';
                xml+='<ws:ServiciosAdicionales>';
                xml+='</ws:ServiciosAdicionales>';
                xml+='<ws:SucursalInstalcion></ws:SucursalInstalcion>';
                xml+='<ws:TiempoAns>21600</ws:TiempoAns>';
                xml+='<ws:TipoInstalacion></ws:TipoInstalacion>';
                xml+='<ws:TipoOperacionPlan>'+(String.isBlank(Oportunidad.Tipo_de_Operacion__c)?'':Oportunidad.Tipo_de_Operacion__c)+'</ws:TipoOperacionPlan>';
                xml+='<ws:TipoOportunidad>'+(String.isBlank(Oportunidad.Tipo_de_Oportunidad__c)?'Sin Oportunidad':Oportunidad.Tipo_de_Oportunidad__c)+'</ws:TipoOportunidad>';
                xml+='<ws:TipoSolicitud>Viabilidad</ws:TipoSolicitud>';
                xml+='<ws:TipologiaVenta>Viabilidad Consultiva</ws:TipologiaVenta>';
                xml+='<ws:UrlsRecursosSalesforce>';
        		xmlAux = obtenerArchivosAjuntos(Oportunidad.Id, null, null);
                if(xmlAux != null && xmlAux != '')
                    xml+= xmlAux;
                xml+='</ws:UrlsRecursosSalesforce>';
                xml+='<ws:UsuarioCreacionSalesForce>'+UserInfo.getUserName()+'</ws:UsuarioCreacionSalesForce>';
                xml+='<ws:ViabilidadRelacionada></ws:ViabilidadRelacionada>';
                //--- final ---
                xml+='</tem:WSRequestBody>';
                xml+='</tem:CrearSolicitud>';
                xml+='</soapenv:Body>';
                xml+='</soapenv:Envelope>';
        return xml;
    }
    
    public static string generarXMLAprovisionamiento(OperacionComercial__c OperacionComercial, String NumeroVia, List<Attachment> lstAttachmentsInput, List<ParametroIntegracion__c> lstParametrosIntegracionInput, String nombreVia)
    {
        Integer diasANS;
        VariablesGlobales__c vGlobal = VariablesGlobales__c.getValues('NombreComercialLTE');
        PS_IntegrationHelper_ctr hlpInteg= new PS_IntegrationHelper_ctr();
        
        if(OperacionComercial.Oportunidad__r.ANS__c != null)
            diasANS = (integer.valueof(OperacionComercial.Oportunidad__r.ANS__c))*1440;
        else if(OperacionComercial.TOPP__r.ANS__c != null)
            diasANS = (integer.valueof(OperacionComercial.TOPP__r.ANS__c))*1440;
        else
            diasANS = 0;
        String  xmlAux;
        String  xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tier="http://schemas.datacontract.org/2004/07/Tier.Common" xmlns:ws="http://schemas.datacontract.org/2004/07/WS.Gestor.RequestContracts" xmlns:ws1="http://schemas.datacontract.org/2004/07/WS.Gestor.DataContracts" xmlns:sys="http://schemas.datacontract.org/2004/07/System.Collections.Generic" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">';
                xml+= '<soapenv:Header/>';
                xml+= '<soapenv:Body>';
                xml+='<tem:CrearSolicitud>';
                xml+='<tem:WSRequestHeader>';
                xml+='<tier:property>';
                xml+='<tier:Scheme_Services.Property>';
                xml+='<tier:name></tier:name>';
                xml+='<tier:value></tier:value>';
                xml+='</tier:Scheme_Services.Property>';
                xml+='</tier:property>';
                xml+='<tier:system>';
                xml+='<tier:correlationId>'+OperacionComercial.Id+'</tier:correlationId>';
                xml+='<tier:name></tier:name>';
                xml+='<tier:processingServer></tier:processingServer>';
                xml+='</tier:system>';
                xml+='</tem:WSRequestHeader>';
                xml+='<tem:WSRequestBody>';
                xml+='<ws:AsesorComercial>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.Name)?'':OperacionComercial.CuentaCliente__r.Owner.Name)+'</ws:AsesorComercial>';
                xml+='<ws:CiudadInstalacion>'+(String.isBlank(OperacionComercial.SucursalOrigen__r.Ciudad__r.ciudad_departamento__c)?'':OperacionComercial.SucursalOrigen__r.Ciudad__r.ciudad_departamento__c)+'</ws:CiudadInstalacion>';
                xml+=' <ws:ClienteValor>'+(String.isBlank(OperacionComercial.CuentaCliente__r.ValordeCliente__c)?'':OperacionComercial.CuentaCliente__r.ValordeCliente__c)+'</ws:ClienteValor>';
                xml+='<ws:CodigoProducto>'+(String.isBlank(OperacionComercial.Plan__r.NombredelProducto__r.CodigoProducto__c)?'':OperacionComercial.Plan__r.NombredelProducto__r.CodigoProducto__c)+'</ws:CodigoProducto>';
                xml+='<ws:Comentarios>'+(String.isBlank(OperacionComercial.Comentarios__c)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.Comentarios__c))+'</ws:Comentarios>';
                xml+='<ws:Contactos>';
                if(OperacionComercial.Contacto_Tecnico__r.Name != null){
                    xml+='<ws1:Contacto>';
                    xml+='<ws1:Apellidos></ws1:Apellidos>';
                    xml+='<ws1:CorreoElectronico>'+(String.isBlank(OperacionComercial.Contacto_Tecnico__r.Email)?'':OperacionComercial.Contacto_Tecnico__r.Email)+'</ws1:CorreoElectronico>';
                    xml+='<ws1:Nombres>'+(String.isBlank(OperacionComercial.Contacto_Tecnico__r.Name)?'':OperacionComercial.Contacto_Tecnico__r.Name)+'</ws1:Nombres>';
                    xml+='<ws1:Telefono>'+(String.isBlank(OperacionComercial.Contacto_Tecnico__r.Phone)?'':OperacionComercial.Contacto_Tecnico__r.Phone)+'</ws1:Telefono>';
                    xml+='<ws1:TelefonoMovil>'+(String.isBlank(OperacionComercial.Contacto_Tecnico__r.MobilePhone)?'':OperacionComercial.Contacto_Tecnico__r.MobilePhone)+'</ws1:TelefonoMovil>';
                    xml+='<ws1:Tipo>Contacto Tecnico</ws1:Tipo>';
                    xml+='</ws1:Contacto>';
                }
                if(OperacionComercial.Contacto_Administrativo__r.Name != null){
                    xml+='<ws1:Contacto>';
                    xml+='<ws1:Apellidos></ws1:Apellidos>';
                    xml+='<ws1:CorreoElectronico>'+(String.isBlank(OperacionComercial.Contacto_Administrativo__r.Email)?'':OperacionComercial.Contacto_Administrativo__r.Email)+'</ws1:CorreoElectronico>';
                    xml+='<ws1:Nombres>'+(String.isBlank(OperacionComercial.Contacto_Administrativo__r.Name)?'':OperacionComercial.Contacto_Administrativo__r.Name)+'</ws1:Nombres>';
                    xml+='<ws1:Telefono>'+(String.isBlank(OperacionComercial.Contacto_Administrativo__r.Phone)?'':OperacionComercial.Contacto_Administrativo__r.Phone)+'</ws1:Telefono>';
                    xml+='<ws1:TelefonoMovil>'+(String.isBlank(OperacionComercial.Contacto_Administrativo__r.MobilePhone)?'':OperacionComercial.Contacto_Administrativo__r.MobilePhone)+'</ws1:TelefonoMovil>';
                    xml+='<ws1:Tipo>Contacto Administrativo</ws1:Tipo>';
                    xml+='</ws1:Contacto>';
                }  
        		if(OperacionComercial.CuentaCliente__r.Owner.Name != null){
                    xml+='<ws1:Contacto>';
                    xml+='<ws1:Apellidos></ws1:Apellidos>';
                    xml+='<ws1:CorreoElectronico>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.Email)?'':OperacionComercial.CuentaCliente__r.Owner.Email)+'</ws1:CorreoElectronico>';
                    xml+='<ws1:Nombres>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.Name)?'':OperacionComercial.CuentaCliente__r.Owner.Name)+'</ws1:Nombres>';
                    xml+='<ws1:Telefono>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.Phone)?'':OperacionComercial.CuentaCliente__r.Owner.Phone)+'</ws1:Telefono>';
                    xml+='<ws1:TelefonoMovil>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.MobilePhone)?'':OperacionComercial.CuentaCliente__r.Owner.MobilePhone)+'</ws1:TelefonoMovil>';
                    xml+='<ws1:Tipo>Asesor Comercial</ws1:Tipo>';
                    xml+='</ws1:Contacto>';
                }
                xml+='</ws:Contactos>';	
                xml+='<ws:CuentaCliente>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.CuentaCliente__r.Name))+'</ws:CuentaCliente>';
                                xml+='<ws:DatosAprovisionamiento>';
                xml+='<ws1:Comentarios>'+(String.isBlank(OperacionComercial.Comentarios__c)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.Comentarios__c))+'</ws1:Comentarios>';
                xml+='<ws1:DatosAdicionalesAprovisionamiento>';
                xmlAux = obtenerParametrosIntegracion(OperacionComercial.TOPP__c, OperacionComercial.Id, 'DatosAdicionalesAprovisionamiento', 'Aprovisionamiento','', lstParametrosIntegracionInput);
                if(xmlAux != null && xmlAux != ''){
                    xml+= xmlAux;
                }
                xml+='</ws1:DatosAdicionalesAprovisionamiento>';
                if(OperacionComercial.Legalizacion__r.Contrato__r.EndDate != null)
                    xml+='<ws1:FechaFinContrato>'+FormatearFecha(OperacionComercial.Legalizacion__r.Contrato__r.EndDate)+'</ws1:FechaFinContrato>';
                if(OperacionComercial.Legalizacion__r.Contrato__r.StartDate != null)
                    xml+='<ws1:FechaInicioContrato>'+FormatearFecha(OperacionComercial.Legalizacion__r.Contrato__r.StartDate)+'</ws1:FechaInicioContrato>';             
                xml+='<ws1:IdAprovisionamiento>'+(String.isBlank(OperacionComercial.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.Name))+'</ws1:IdAprovisionamiento>';
                xml+='<ws1:NumeroContrato>'+(String.isBlank(OperacionComercial.Legalizacion__r.Contrato__r.ContractNumber)?'':OperacionComercial.Legalizacion__r.Contrato__r.ContractNumber)+'</ws1:NumeroContrato>';
                xml+='<ws1:OpcionViabilidad>'+(String.isBlank(OperacionComercial.Opcion_Aprovisionamiento__r.IdOpcion__c)?'':OperacionComercial.Opcion_Aprovisionamiento__r.IdOpcion__c)+'</ws1:OpcionViabilidad>';
                xml+='<ws1:RenovacionAutomatica>'+OperacionComercial.Legalizacion__r.Contrato__r.Renovacion_Automatica__c+'</ws1:RenovacionAutomatica>';
                xml+='<ws1:Servicio>';
                xml+='<ws1:AliadoColaborador>'+(String.isBlank(OperacionComercial.AliadoColaborador__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.AliadoColaborador__r.Name))+'</ws1:AliadoColaborador>';
                xml+='<ws1:AnchoBanda>'+(String.isBlank(OperacionComercial.AnchoBanda__r.Name)?'':OperacionComercial.AnchoBanda__r.Name)+'</ws1:AnchoBanda>';
                xml+='<ws1:Ciudad>'+(String.isBlank(OperacionComercial.SucursalOrigen__r.Ciudad__r.ciudad_departamento__c)?'':OperacionComercial.SucursalOrigen__r.Ciudad__r.ciudad_departamento__c)+'</ws1:Ciudad>';
                xml+='<ws1:CuentaCliente>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.CuentaCliente__r.Name))+'</ws1:CuentaCliente>';
                xml+='<ws1:CuentaFacturacion>'+(String.isBlank(OperacionComercial.CuentaFacturacion__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.CuentaFacturacion__r.Name))+'</ws1:CuentaFacturacion>';
                xml+='<ws1:DatosAdicionalesServicio>';
                xml+='</ws1:DatosAdicionalesServicio>';
                xml+='<ws1:DisponibilidadServicio>'+(String.isBlank(OperacionComercial.RangosDisponibilidad__c)?'':OperacionComercial.RangosDisponibilidad__c)+'</ws1:DisponibilidadServicio>';
                xml+='<ws1:Estado>'+(String.isBlank(OperacionComercial.Activo__r.Estado__c)?'':OperacionComercial.Activo__r.Estado__c)+'</ws1:Estado>';
                xml+='<ws1:ExternalServiceID>'+(String.isBlank(OperacionComercial.Activo__r.ExternalServiceID__c)?'':OperacionComercial.Activo__r.ExternalServiceID__c)+'</ws1:ExternalServiceID>';
                xml+='<ws1:IdServicio>'+(String.isBlank(OperacionComercial.Activo__r.IDservicio__c)?'':OperacionComercial.Activo__r.IDservicio__c)+'</ws1:IdServicio>';
                xml+='<ws1:MedioUltimaMilla>'+(String.isBlank(OperacionComercial.MedioUM__c)?'':OperacionComercial.MedioUM__c)+'</ws1:MedioUltimaMilla>';
                xml+='<ws1:NIT>'+(String.isBlank(OperacionComercial.CuentaCliente__r.AccountNumber)?'':OperacionComercial.CuentaCliente__r.AccountNumber)+'</ws1:NIT>';
        		String sNemonico = String.isBlank(OperacionComercial.Activo__r.NombredelProducto__r.NEMONICO__c)?'':OperacionComercial.Activo__r.NombredelProducto__r.NEMONICO__c;
        		if(OperacionComercial.Activo__r.NombredelProducto__r.Name == 'Conectividad Avanzada IP' && OperacionComercial.Tipo_Capa_de_Conectividad__c == 'Capa 2'){
            		sNemonico = 'CAV20';
        		}
        		if(OperacionComercial.Activo__r.NombredelProducto__r.Name == 'Conectividad Avanzada IP' && OperacionComercial.Tipo_Capa_de_Conectividad__c == 'Capa 3'){
            		sNemonico = 'CAV30';
        		}
                xml+='<ws1:Nemonico>'+sNemonico+'</ws1:Nemonico>';
                xml+='<ws1:NombreProducto>'+(String.isBlank(OperacionComercial.Activo__r.NombredelProducto__r.Name)?'':((OperacionComercial.Activo__r.NombredelProducto__r.Name==vGlobal.Valor__c && OperacionComercial.Activo__r.Plan__r.TipodePlan__c=='Troncal SIP')?'Troncales SIP - Móvil':OperacionComercial.Activo__r.NombredelProducto__r.Name))+'</ws1:NombreProducto>';
                //xml+='<ws1:NombreProducto>'+(String.isBlank(OperacionComercial.Activo__r.NombredelProducto__r.Name)?'':OperacionComercial.Activo__r.NombredelProducto__r.Name)+'</ws1:NombreProducto>';
                xml+='<ws1:Numeroconexion>'+(String.isBlank(OperacionComercial.NumeroConexion__c)?'':OperacionComercial.NumeroConexion__c)+'</ws1:Numeroconexion>';
                xml+='<ws1:Plan>'+(String.isBlank(OperacionComercial.Activo__r.Plan__r.Name)?'':OperacionComercial.Activo__r.Plan__r.Name)+'</ws1:Plan>';
                xml+='<ws1:ProveedorUltimaMilla>'+(String.isBlank(OperacionComercial.ProveedorUM__c)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.ProveedorUM__c))+'</ws1:ProveedorUltimaMilla>';
                xml+='<ws1:ServicioETB>'+(String.isBlank(OperacionComercial.Activo__r.Name)?'':OperacionComercial.Activo__r.Name)+'</ws1:ServicioETB>';
                xml+='<ws1:Sucursal>'+(String.isBlank(OperacionComercial.SucursalOrigen__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.SucursalOrigen__r.Name))+'</ws1:Sucursal>';
                xml+='</ws1:Servicio>';
       			xml+='<ws1:ViabilidadOrigen></ws1:ViabilidadOrigen>';
                //xml+='<ws1:ViabilidadOrigen>'+consultarViabilidad(OperacionComercial.id)+'</ws1:ViabilidadOrigen>';
                /*
                if(nombreVia != null)
                	xml+='<ws1:ViabilidadOrigen>'+nombreVia+'</ws1:ViabilidadOrigen>';
        		else
                	xml+='<ws1:ViabilidadOrigen>'+(String.isBlank(consultarViabilidad(OperacionComercial.id))?'':consultarViabilidad(OperacionComercial.id))+'</ws1:ViabilidadOrigen>';
				*/
                xml+='</ws:DatosAprovisionamiento>';      
                xml+='<ws:DireccionPrincipal>'+(String.isBlank(OperacionComercial.SucursalOrigen__r.Direccion__c)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.SucursalOrigen__r.Direccion__c))+'</ws:DireccionPrincipal>';
                xml+='<ws:DuracionServicioDias>'+OperacionComercial.Duracion_Dias__c+'</ws:DuracionServicioDias>';
                xml+='<ws:DuracionServicioMeses>'+OperacionComercial.Duracion_Meses__c+'</ws:DuracionServicioMeses>';
                xml+='<ws:EjecutivoExperiencia>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Administrador_Experiencia_al_Cliente__c)?'':OperacionComercial.CuentaCliente__r.Administrador_Experiencia_al_Cliente__c)+'</ws:EjecutivoExperiencia>';
                xml+='<ws:IdViabilidad></ws:IdViabilidad>';
                xml+='<ws:IndicadorAgrupacion>'+(OperacionComercial.Oportunidad__r.Consecutivooportunidades__c != null?OperacionComercial.Oportunidad__r.Consecutivooportunidades__c:OperacionComercial.Caso__r.CaseNumber)+'</ws:IndicadorAgrupacion>';
                xml+='<ws:Nit>'+(String.isBlank(OperacionComercial.CuentaCliente__r.AccountNumber)?'':OperacionComercial.CuentaCliente__r.AccountNumber)+'</ws:Nit>';
                xml+='<ws:NombreOperacionComercial>'+(String.isBlank(OperacionComercial.Name)?'':OperacionComercial.Name)+'</ws:NombreOperacionComercial>';
                xml+='<ws:NombreOportunidad>'+(String.isBlank(OperacionComercial.Oportunidad__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.Oportunidad__r.Name))+'</ws:NombreOportunidad>';
                xml+='<ws:NombreProducto>'+(String.isBlank(OperacionComercial.Plan__r.NombredelProducto__r.Name)?'':((OperacionComercial.Plan__r.NombredelProducto__r.Name==vGlobal.Valor__c && OperacionComercial.Plan__r.TipodePlan__c=='Troncal SIP')?'Troncales SIP - Móvil':OperacionComercial.Plan__r.NombredelProducto__r.Name))+'</ws:NombreProducto>';
                //xml+='<ws:NombreProducto>'+(String.isBlank(OperacionComercial.Plan__r.NombredelProducto__r.Name)?'':OperacionComercial.Plan__r.NombredelProducto__r.Name)+'</ws:NombreProducto>';
                xml+='<ws:NumeroCaso>'+(String.isBlank(OperacionComercial.Caso__r.CaseNumber)?'':OperacionComercial.Caso__r.CaseNumber)+'</ws:NumeroCaso>';
                xml+='<ws:NumeroOportunidad>'+(String.isBlank(OperacionComercial.Oportunidad__r.Consecutivooportunidades__c)?'':OperacionComercial.Oportunidad__r.Consecutivooportunidades__c)+'</ws:NumeroOportunidad>';
                xml+='<ws:Segmento>'+(String.isBlank(OperacionComercial.CuentaCliente__r.Owner.DireccionVentasAsesor__c)?'':OperacionComercial.CuentaCliente__r.Owner.DireccionVentasAsesor__c)+'</ws:Segmento>';
                xml+='<ws:ServiciosAdicionales>';
                if(OperacionComercial.Servicios_Adicionales_P_Superior__c != null)
                    xml+='<arr:string>'+OperacionComercial.Servicios_Adicionales_P_Superior__c+'</arr:string>';
                xml+='</ws:ServiciosAdicionales>';
                xml+='<ws:SucursalInstalcion>'+(String.isBlank(OperacionComercial.SucursalOrigen__r.Name)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.SucursalOrigen__r.Name))+'</ws:SucursalInstalcion>';
                xml+='<ws:TiempoAns>'+diasANS+'</ws:TiempoAns>';
                xml+='<ws:TipoInstalacion>'+(String.isBlank(OperacionComercial.Detalle_del_tramite__c)?'':hlpInteg.ReplaceUTF8Character(OperacionComercial.Detalle_del_tramite__c))+'</ws:TipoInstalacion>';
                xml+='<ws:TipoOperacionPlan>'+(String.isBlank(OperacionComercial.TOPP__r.TipodeOperacionporplan__c)?'':OperacionComercial.TOPP__r.TipodeOperacionporplan__c)+'</ws:TipoOperacionPlan>';
                if(OperacionComercial.Oportunidad__c!=null){
                    if(OperacionComercial.Oportunidad__r.RecordType.DeveloperName=='Licitaciones'){
                        xml+='<ws:TipoOportunidad>'+(String.isBlank(OperacionComercial.Oportunidad__r.Tipo_de_Oportunidad__c)?'Sin Oportunidad':OperacionComercial.Oportunidad__r.Tipo_de_Oportunidad__c)+'</ws:TipoOportunidad>';
                    }else{
                        xml+='<ws:TipoOportunidad>'+(String.isBlank(OperacionComercial.Oportunidad__r.RecordType.DeveloperName)?'Sin Oportunidad':OperacionComercial.Oportunidad__r.RecordType.DeveloperName)+'</ws:TipoOportunidad>';
                    }
                }else{
                    xml+='<ws:TipoOportunidad>'+(String.isBlank(OperacionComercial.Oportunidad__r.RecordType.DeveloperName)?'Sin Oportunidad':OperacionComercial.Oportunidad__r.RecordType.DeveloperName)+'</ws:TipoOportunidad>';
                }   
                xml+='<ws:TipoSolicitud>Aprovisionamiento</ws:TipoSolicitud>';
                xml+='<ws:TipologiaVenta>'+(String.isBlank(OperacionComercial.Tipologia_Preventa__c)?'':OperacionComercial.Tipologia_Preventa__c)+'</ws:TipologiaVenta>';
                xml+='<ws:UrlsRecursosSalesforce>';
                xmlAux = obtenerArchivosAjuntos(OperacionComercial.Oportunidad__r.Id, OperacionComercial.Caso__r.Id, lstAttachmentsInput);
                if(xmlAux != null && xmlAux != '')
                    xml+= xmlAux;
                xml+='</ws:UrlsRecursosSalesforce>';
                xml+='<ws:UsuarioCreacionSalesForce>'+UserInfo.getUserName()+'</ws:UsuarioCreacionSalesForce>';
                xml+='<ws:ViabilidadRelacionada></ws:ViabilidadRelacionada>';
                //--- final ---
                xml+='</tem:WSRequestBody>';
                xml+='</tem:CrearSolicitud>';
                xml+='</soapenv:Body>';
                xml+='</soapenv:Envelope>';
                
        return xml;
    }
    
    public static string generarXMLActualizarServicio(OperacionComercial__c OperacionComercial, String IDServicio){
        String  xmlAux;
        String  xml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:tier="http://schemas.datacontract.org/2004/07/Tier.Common" xmlns:ws="http://schemas.datacontract.org/2004/07/WS.Gestor.RequestContracts" xmlns:ws1="http://schemas.datacontract.org/2004/07/WS.Gestor.DataContracts" xmlns:sys="http://schemas.datacontract.org/2004/07/System.Collections.Generic">';
                xml+= '<soapenv:Header/>';
                xml+= '<soapenv:Body>';
                xml+= '<tem:ActualizarServicioCliente>';
                xml+= '<tem:WSRequestHeader>';
                xml+= '<tier:property>';
                xml+= '<tier:Scheme_Services.Property>';
                xml+= '<tier:name></tier:name>';
                xml+= '<tier:value></tier:value>';
                xml+= '</tier:Scheme_Services.Property>';
                xml+= '</tier:property>';
                xml+= '<tier:system>';
                xml+= '<tier:correlationId>'+IDServicio+'_'+OperacionComercial.Id+'</tier:correlationId>';
                xml+= '<tier:name></tier:name>';
                xml+= '<tier:processingServer></tier:processingServer>';
                xml+= '</tier:system>';
                xml+= '</tem:WSRequestHeader>';
                xml+= '<tem:WSRequestBody>';
                xml+= '<ws:DatosServicioCliente>';
                xmlAux = obtenerParametrosIntegracion(OperacionComercial.TOPP__c, OperacionComercial.Id, 'DatosAdicionalesServicio', 'Actualizar_Servicio',IDServicio, null);
                if(xmlAux != null && xmlAux != '')
                    xml+= xmlAux;
                xml+= '</ws:DatosServicioCliente>';
                xml+= '</tem:WSRequestBody>';
                xml+= '</tem:ActualizarServicioCliente>';
                xml+= '</soapenv:Body>';
                xml+= '</soapenv:Envelope>';
        
        if(xmlAux == null || xmlAux == '')
            return '';
        else
            return xml;
    }
    
    public static string FormatearFecha(DateTime fecha){
    //    DateTime dts = DateTime.now();
        String formattedDt = fecha.format('yyyy-MM-dd\'T\'hh:mm:ss\'-05:00\'');
        return formattedDt;
    }
    
    public static string obtenerParametrosIntegracion(String idTopp, String idReg, String region, String tipoIntegracion, String IDServicio, List<ParametroIntegracion__c> lstParametrosIntegracionInput)
    {
        //Definición de variables
        List<ParametroIntegracion__c> lstParametrosIntegracion = new List<ParametroIntegracion__c>();
        PS_IntegrationHelper_ctr hlpInteg= new PS_IntegrationHelper_ctr();
        list<String> lstRelacionObjeto;
        ParametroIntegracion__c objParamIntegAux;
        String[] strRelacionObjeto;
        SObject valorCampoParametro, auxObjChild;
        Boolean flagIdServicio = false, flagDatosAdicionalesServicio = false;
        Integer CantidadParam = 0, contadorCiclo=0, CantParamActServ=0, CantParamActServAux=0, ComparaString, CantParamEstatico=0, CantParamEstaticoAux=0;
        String campoQuery, sql, relacionObjeto, campoDestino, nombreEtiqueta, FieldValue, valorPorDefecto, regionEtiqueta, xmlParametros= '', fields= '', objetoBase;
        //Consulta al objeto de parámetros de integración
        
        if(tipoIntegracion != 'Actualizar_Servicio'){
            if(lstParametrosIntegracionInput == null){
                lstParametrosIntegracion = [Select Name, Objeto_base__c, Campo__c, Objeto_destino__c, Campo_destino__c, Valor_por_defecto__c, Region_de_la_etiqueta__c
                                                From ParametroIntegracion__c
                                                Where Tipo_Operacion_por_Plan__c=:idTopp and Region_de_la_etiqueta__c=:region and Activo__c = true
                                                and TipoIntegracion__c=: tipoIntegracion
                                                Order By Name ASC];
            }else if(lstParametrosIntegracionInput.Size() > 0)
                 lstParametrosIntegracion = lstParametrosIntegracionInput;
            
        }else{
            lstParametrosIntegracion = [Select Name, Objeto_base__c, Campo__c, Objeto_destino__c, Campo_destino__c, Valor_por_defecto__c, Region_de_la_etiqueta__c, Region_Name__c
                                        From ParametroIntegracion__c
                                        Where Tipo_Operacion_por_Plan__c=:idTopp and  Activo__c = true and TipoIntegracion__c=: tipoIntegracion
                                        Order By Region_Name__c ASC];
            
            CantParamActServ =  [SELECT count() FROM ParametroIntegracion__c 
                                WHERE Tipo_Operacion_por_Plan__c =:idTopp and Region_de_la_etiqueta__c =: region and Activo__c = true];
            CantParamEstatico = [SELECT count() FROM ParametroIntegracion__c 
                                WHERE Tipo_Operacion_por_Plan__c =:idTopp and Region_de_la_etiqueta__c =: 'Estatico' and Activo__c = true];
        } 
        System.debug('--> obtenerParametrosIntegracion TOPP: '+idTopp+' > lstParametrosIntegracion: '+lstParametrosIntegracion);
    
        //Procesar parámetros de integración
        if(!lstParametrosIntegracion.isEmpty()){
            try{
                for(ParametroIntegracion__c objParamInteg: lstParametrosIntegracion){
                    objetoBase = objParamInteg.Objeto_base__c;
                    if(objParamInteg.Objeto_destino__c != null)
                        campoQuery = objParamInteg.Objeto_destino__c+'.'+objParamInteg.Campo_destino__c;
                    else
                        campoQuery = objParamInteg.Campo__c;
                    
                    if(CantidadParam == 0)
                        fields = campoQuery;
                    else
                        fields += ', '+campoQuery;
                    CantidadParam++;
                }
                
                if(fields != null && fields != ''){
                    sql  = 'Select '+fields+' From '+objetoBase+' where Id=';
                    sql += '\''+idReg+'\' Limit 1';
                    System.Debug('obtenerParametrosIntegracion > sql: '+sql);
                    valorCampoParametro = Database.query(sql);
                                        
                    for(ParametroIntegracion__c objParamInteg: lstParametrosIntegracion){
                        FieldValue 		= null;
                        relacionObjeto  = objParamInteg.Objeto_destino__c;
                        campoDestino    = objParamInteg.Campo_destino__c;
                        nombreEtiqueta  = objParamInteg.Name;
                        valorPorDefecto = objParamInteg.Valor_por_defecto__c;
                        regionEtiqueta  = objParamInteg.Region_de_la_etiqueta__c;
                        auxObjChild     = null;
                        contadorCiclo   = 0;
                        
                        if(relacionObjeto != null)
                        	campoQuery = relacionObjeto+'.'+campoDestino;
                        else
                            campoQuery = objParamInteg.Campo__c;
                        
                        if(valorPorDefecto != null)
                            FieldValue = valorPorDefecto;
                        else{
                            try{
                                if(relacionObjeto == null)
                                    FieldValue = String.valueOf(valorCampoParametro.get(campoQuery));
                                else
                                {
                                    strRelacionObjeto = relacionObjeto.split('\\.');
                                    lstRelacionObjeto = new list<String>(strRelacionObjeto);
                                    system.debug(lstRelacionObjeto);
                                    for(String rel : lstRelacionObjeto){
                                        if(contadorCiclo == 0)
                                            auxObjChild = valorCampoParametro.getSObject(rel.trim());
                                        else
                                            auxObjChild = auxObjChild.getSObject(rel.trim());
                                        contadorCiclo++;
                                    }
                                    system.debug(auxObjChild);
                                    if(auxObjChild!=null){
                                        if(auxObjChild.get(campoDestino.trim()) != null)
                                            FieldValue = String.valueOf(auxObjChild.get(campoDestino.trim()));
                                    }
                                }
                            }catch(Exception e){
                                System.debug('EXCEPTION: No fue posible obtener el valor de un campo dinamico: '+ e.getMessage() + ' ' + e.getStackTraceString());
                            }
                        }
                        //Genenerar XML para parámetros dinámicos
                        if(regionEtiqueta != 'Estatico'){
                            CantParamActServAux++;
                            if(FieldValue != null){
                                if(tipoIntegracion == 'Actualizar_Servicio' && flagDatosAdicionalesServicio == false){
                                    xmlParametros+='<ws1:'+region+'>';
                                    flagDatosAdicionalesServicio = true;
                                }
                                xmlParametros+='<sys:KeyValuePairOfstringstring>';
                                xmlParametros += '<sys:key>'+nombreEtiqueta+'</sys:key>';
                                xmlParametros += '<sys:value>'+hlpInteg.ReplaceUTF8Character(FieldValue)+'</sys:value>';
                                xmlParametros+='</sys:KeyValuePairOfstringstring>';
                            }
                            if(CantParamActServAux == CantParamActServ){
                                xmlParametros+='</ws1:'+region+'>';
                                if(CantParamEstatico == CantParamEstaticoAux && flagIdServicio == false){
                                    xmlParametros += '<ws1:IdServicio>'+IDServicio+'</ws1:IdServicio>';
                                    flagIdServicio = true;
                                }
                            }
                        }
                        //Genenerar XML para parámetros estáticos
                        if(regionEtiqueta == 'Estatico' && tipoIntegracion == 'Actualizar_Servicio'){
                            CantParamEstaticoAux++;
                            if(FieldValue != null){
                                ComparaString = 'IdServicio'.compareTo(nombreEtiqueta);
                                if(ComparaString < 0 && flagIdServicio == false){
                                    xmlParametros += '<ws1:IdServicio>'+IDServicio+'</ws1:IdServicio>';
                                    flagIdServicio = true;
                                }
                                xmlParametros += '<ws1:'+nombreEtiqueta+'>'+FieldValue+'</ws1:'+nombreEtiqueta+'>';
                            }
                            if(CantParamEstatico == CantParamEstaticoAux && flagIdServicio == false){
                                xmlParametros += '<ws1:IdServicio>'+IDServicio+'</ws1:IdServicio>';
                                flagIdServicio = true;
                            }
                        }
                    }
                }
            }catch(Exception e){
                System.Debug('====================== EXCEPTION ======================');
                System.debug( e.getMessage() + ' ' + e.getStackTraceString());
                System.Debug('=======================================================');
            }
        }
        system.debug('--> obtenerParametrosIntegracion del TOPP: '+idTopp+' > XML con parámetros de integración: '+xmlParametros);
        return xmlParametros;
    }
        
    public static Map<Integer,string> GenerarIntegracion(String xml, String Action){
        
        Map<Integer,string> valuesResponse = new map<Integer,string>();
        Map<string,string> values = new map<string,string>();
        string response = '';
        
        //Obtener Endpoint
        ServiciosWeb__c sw;
        if(Action == 'ActualizarServicio')
            sw = ServiciosWeb__c.getValues('GestorSolicitudesActualizarServicio');
        else
            sw = ServiciosWeb__c.getValues('GestorSolicitudes');
        
        //Llamar Servicio
        if(!Test.isRunningTest()){
            //integrar
            response=LibreriaUtilitariaJobs_cls.consultarServicio(xml,sw.Action__c,sw.EndPoint__c);
        }else
            response='<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body><CrearSolicitudResponse xmlns="http://tempuri.org/"><CrearSolicitudResult xmlns:a="http://schemas.datacontract.org/2004/07/Tier.Common" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><a:WSResponseBody><a:OperationResult>1</a:OperationResult><a:OperationResultDesc>Se ha guardado el registro exitosamente.</a:OperationResultDesc></a:WSResponseBody><a:WSResponseHeader><a:property><a:Scheme_Services.Property><a:name/><a:value/></a:Scheme_Services.Property></a:property><a:service><a:responseDate>6/18/2018 4:05:39 PM</a:responseDate><a:status>OK</a:status><a:statusDetail>Procesamiento exitoso</a:statusDetail></a:service><a:system><a:correlationId>a09m0000003OQylAAG</a:correlationId><a:name/><a:processingServer/></a:system></a:WSResponseHeader></CrearSolicitudResult></CrearSolicitudResponse></s:Body></s:Envelope>';
        
        system.debug('--> GenerarIntegracion > Response integración gestor: '+ response);
        // obtener respuesta
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        values = proReq.getMap(response);
        
        // generar map
        valuesResponse.put(1,values.get('OperationResult'));
        valuesResponse.put(2,values.get('OperationResultDesc'));
        valuesResponse.put(3,xml);
        valuesResponse.put(4,response);
        
        return valuesResponse;
    }
    
    public static string obtenerArchivosAjuntos(String idOportunidad, String idCaso, List<Attachment> lstAttachmentsInput)
    {
        List<Attachment> lstAttachments = new List<Attachment>();
        String xmlAttachments= null;
                
        if(idOportunidad == null)
            idOportunidad = '';
        if(idCaso == null)
            idCaso = '';
		
        if(lstAttachmentsInput == null){
            lstAttachments = [Select Id, Name
                              From Attachment
                              Where (ParentId =:idOportunidad OR ParentId =: idCaso) and IsPrivate =: false];
        }else if(lstAttachmentsInput.Size() > 0)
            lstAttachments = lstAttachmentsInput;
                        
        System.debug('--> obtenerArchivosAjuntos > Lista de archivos adjuntos: '+lstAttachments);
        
        for(Attachment objAttachment: lstAttachments){
            if(xmlAttachments == null)
                xmlAttachments = '<sys:KeyValuePairOfstringstring>';
            else
                xmlAttachments += '<sys:KeyValuePairOfstringstring>';
            
            xmlAttachments += '<sys:key>'+objAttachment.Name+'</sys:key>';
            xmlAttachments += '<sys:value>https://'+System.URL.getSalesforceBaseURL().getHost()+'/servlet/servlet.FileDownload?file='+objAttachment.Id+'</sys:value>';
            xmlAttachments += '</sys:KeyValuePairOfstringstring>';
        }
        System.debug('--> obtenerArchivosAjuntos > XML de archivos adjuntos: '+xmlAttachments);
        
        return xmlAttachments;
    }
    
    public static string consultarViabilidad(String idOC)
    {
        Viabilidad__c[] objVia;
        OperacionComercial__c[] objOC;
        String sql, nombreVia = '';
        objVia = [SELECT Name FROM Viabilidad__c WHERE Respuestadeviabilidad__c = 'Viable' AND OperacionComercial__c =: idOC ORDER BY CreatedDate DESC NULLS FIRST LIMIT 1];
        if(objVia.size() > 0)
            nombreVia = objVia[0].Name;
        else{
            objOC = [SELECT Viabilidad_Relacionada__r.Name FROM OperacionComercial__c WHERE Id =: IdOC LIMIT 1];
            if(objOC.size() > 0)
                nombreVia = objOC[0].Viabilidad_Relacionada__r.Name;
        }
        return nombreVia;
    }
    
    public enum TipoOperacionOrdenGestor {VIA_CONSULTIVA, VIA_ESPECIFICA, APROVISIONAMIENTO, ACTUALIZAR_SERVICO, FACT_GENERAL, FACT_LINEAS, FACT_CONFIRMACION, FACT_PROMO, FACT_CORREO, RETENCION, NIP, NIP_LINEAS, PORTACION, PORTACION_LINEAS,
        APROVISIONAMIENTO_ALIADO}
    
    /*-------------------------  ------------------*/
    public Map<Id,Map<String,Object>> GenerarDatamapOrdenes(Set<Id> lstObjectId,TipoOperacionOrdenGestor Operacion){
        Map<Id,Map<String,Object>> mapHierarchy = new Map<Id,Map<String,Object>>();
        list<Viabilidad__c> lstViabIntegrar = [SELECT Id,Name, EstadoViabilidad__c,OperacionComercial__c,OperacionComercial__r.Id, OperacionComercial__r.Name, OperacionComercial__r.Oportunidad__c, OperacionComercial__r.TOPP__c,OperacionComercial__r.SucursalOrigen__c,OperacionComercial__r.Caso__c,OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c,Oportunidad__c,
                                               Oportunidad__r.Tipo_de_Oportunidad__c,Oportunidad__r.Plan__r.Tipo_Operaci_n_por_Plan__c,Oportunidad__r.Plan__c
							 FROM Viabilidad__c WHERE Id IN :lstObjectId];
        Set<Id> lstParentId = new Set<Id>();
        Set<Id> lstToppId = new Set<Id>();
        Set<Id> lstServAccId = new Set<Id>();
        Set<String> lstParamDefId = new Set<String>();
        Set<Id> lstIntegrarId = new Set<Id>();
        String sRegion = '';
        String sTipoIntegracion='';
        String sObjetoBase='';
        String sMensaje = '';
        String sTipoProceso = '';
        
        Map<Id,Id> mpRelacionParam = new Map<Id,Id>();
        Map<Id,Id> mpRelacionServDir = new Map<Id,Id>();
        Map<Id,String> mpRelacionParamDefault = new Map<Id,String>();
        Map<Id,Id> mpRelacionAtt = new Map<Id,Id>();
        Map<Id,Map<String,String>> mpRelacionViabilidad = new Map<Id,Map<String,String>>();
        
        if(Operacion == TipoOperacionOrdenGestor.VIA_CONSULTIVA){
            sObjetoBase='Opportunity';
            sMensaje = 'Campos Oportunidad Gestor PS';
            sRegion = 'DatosAdicionalesViabilidad';
            sTipoIntegracion='Viabilidad';
            sTipoProceso= 'Envio_VIAConsultiva_PS';
        }else if(Operacion == TipoOperacionOrdenGestor.VIA_ESPECIFICA){
            sObjetoBase='OperacionComercial__c';
            sMensaje = 'Campos Ordenes Gestor PS';
            sRegion = 'DatosAdicionalesViabilidad';
            sTipoIntegracion='Viabilidad';
            sTipoProceso= 'Envio_VIAEspecifica_PS';
        }else if(Operacion == TipoOperacionOrdenGestor.APROVISIONAMIENTO){
            sObjetoBase='OperacionComercial__c';
            sMensaje = 'Campos Ordenes Gestor PS';
            sRegion = 'DatosAdicionalesAprovisionamiento';
            sTipoIntegracion='Aprovisionamiento';
            sTipoProceso= 'Envio_Aprovisionamiento_PS';
        }else if(Operacion == TipoOperacionOrdenGestor.APROVISIONAMIENTO_ALIADO){
            sObjetoBase='OperacionComercial__c';
            sMensaje = 'Campos Ordenes Gestor PS';
            sRegion = 'DatosAdicionalesAprovisionamiento';
            sTipoIntegracion='Aprovisionamiento';
            sTipoProceso= 'Envio_Aprovisionamiento_PS';
        }else if(Operacion == TipoOperacionOrdenGestor.ACTUALIZAR_SERVICO){
            sObjetoBase='OperacionComercial__c';
            sMensaje = 'Campos Ordenes Gestor PS';
            sTipoIntegracion='Actualizar_Servicio';
            sTipoProceso= 'Envio_ActualizarServicio_PS';
        }
        
        if(!lstViabIntegrar.isEmpty()){
            for(Viabilidad__c sglVia : lstViabIntegrar){
                Map<String,String> mpViabilidadInicial = new Map<String,String>();
                if(sglVia.OperacionComercial__c != null){
                    lstIntegrarId.add(sglVia.OperacionComercial__c);
                    mpViabilidadInicial.put('Id',sglVia.Id);
                    mpViabilidadInicial.put('Name',sglVia.Name);
                    mpViabilidadInicial.put('Estado__c',sglVia.EstadoViabilidad__c);
                    mpRelacionViabilidad.put(sglVia.OperacionComercial__c,mpViabilidadInicial);
                    
                    if(sglVia.OperacionComercial__r.Oportunidad__c!=null){
                        lstParentId.add(sglVia.OperacionComercial__r.Oportunidad__c);
                        mpRelacionAtt.put(sglVia.OperacionComercial__c,sglVia.OperacionComercial__r.Oportunidad__c);
                    }else{
                        lstParentId.add(sglVia.OperacionComercial__c);
                        mpRelacionAtt.put(sglVia.OperacionComercial__c,sglVia.OperacionComercial__c);
                    }
                    
                    if(sglVia.OperacionComercial__r.TOPP__c != null){
                        lstToppId.add(sglVia.OperacionComercial__r.TOPP__c);
                        lstServAccId.add(sglVia.OperacionComercial__r.SucursalOrigen__c);
                        lstParamDefId.add(sglVia.OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c);
                        mpRelacionParam.put(sglVia.OperacionComercial__c,sglVia.OperacionComercial__r.TOPP__c);
                        mpRelacionServDir.put(sglVia.OperacionComercial__c,sglVia.OperacionComercial__r.SucursalOrigen__c);
                        mpRelacionParamDefault.put(sglVia.OperacionComercial__c,sglVia.OperacionComercial__r.TOPP__r.TipodeOperacionporplan__c);
                    }
                    
                    if(sglVia.OperacionComercial__r.SucursalOrigen__c != null){
                        lstServAccId.add(sglVia.OperacionComercial__r.SucursalOrigen__c);
                        mpRelacionServDir.put(sglVia.OperacionComercial__c,sglVia.OperacionComercial__r.SucursalOrigen__c);
                    }
                }
                else if(sglVia.Oportunidad__c != null){
                    
                    lstIntegrarId.add(sglVia.Oportunidad__c);
                    lstParentId.add(sglVia.Oportunidad__c);
                    mpViabilidadInicial.put('Id',sglVia.Id);
                    mpViabilidadInicial.put('Name',sglVia.Name);
                    mpViabilidadInicial.put('Estado__c',sglVia.EstadoViabilidad__c);
                    mpRelacionViabilidad.put(sglVia.Oportunidad__c,mpViabilidadInicial);
                    mpRelacionAtt.put(sglVia.Oportunidad__c,sglVia.Oportunidad__c);
                    lstParamDefId.add(sglVia.Oportunidad__r.Tipo_de_Oportunidad__c);
                    mpRelacionParamDefault.put(sglVia.Oportunidad__c,sglVia.Oportunidad__r.Tipo_de_Oportunidad__c);
                    if(sglVia.Oportunidad__r.Plan__c != null){
                        if(sglVia.Oportunidad__r.Plan__r.Tipo_Operaci_n_por_Plan__c != null){
                            lstToppId.add(sglVia.Oportunidad__r.Plan__r.Tipo_Operaci_n_por_Plan__c);
                            mpRelacionParam.put(sglVia.Oportunidad__c,sglVia.Oportunidad__r.Plan__r.Tipo_Operaci_n_por_Plan__c);
                        }
                    }
                }
            }
        }
        else{
            List<OperacionComercial__c> lstOCIntegrar = [SELECT Id,Name,TOPP__c,Caso__c,SucursalOrigen__c,Oportunidad__c,TOPP__r.TipodeOperacionporplan__c,Legalizacion__c,Plan__r.Requiere_Adjunto__c FROM OperacionComercial__c WHERE Id IN :lstObjectId];
            for(OperacionComercial__c sglOC : lstOCIntegrar){
                lstIntegrarId.add(sglOC.Id);
                if(sglOC.Oportunidad__c!=null){
                    lstParentId.add(sglOC.Oportunidad__c);
                    mpRelacionAtt.put(sglOC.Id,sglOC.Oportunidad__c);
                }
                if(sglOC.Caso__c!=null){
                    lstParentId.add(sglOC.Id);
                    mpRelacionAtt.put(sglOC.Id,sglOC.Id);
                }
                if(sglOC.TOPP__c != null){
                    lstToppId.add(sglOC.TOPP__c);
                    lstParamDefId.add(sglOC.TOPP__r.TipodeOperacionporplan__c);
                    mpRelacionParam.put(sglOC.Id,sglOC.TOPP__c);
                    mpRelacionParamDefault.put(sglOC.Id,sglOC.TOPP__r.TipodeOperacionporplan__c);
                }
                if(sglOC.SucursalOrigen__c != null){
                    lstServAccId.add(sglOC.SucursalOrigen__c);
                    mpRelacionServDir.put(sglOC.Id,sglOC.SucursalOrigen__c);
                }
                if(sglOC.Legalizacion__c!=null && sglOC.Plan__r.Requiere_Adjunto__c){
                    lstParentId.add(sglOC.Legalizacion__c);
                    mpRelacionAtt.put(sglOC.Id,sglOC.Legalizacion__c);
                }
            }
        }
	
        List<Attachment> lstAttachments = new List<Attachment>();
        if(!lstParentId.isEmpty()){
            lstAttachments = [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId IN: lstParentId and IsPrivate =: false];
        }
	
        Map<Id,Map<String,String>> mpAttachInteg = new Map<Id,Map<String,String>>();
        for(Attachment sglAttachment : lstAttachments){
            if(!mpAttachInteg.containskey(sglAttachment.ParentId)){
                mpAttachInteg.put(sglAttachment.ParentId,new Map<String,String>());
            }
            mpAttachInteg.get(sglAttachment.ParentId).put(sglAttachment.Name,'https://'+System.URL.getSalesforceBaseURL().getHost()+'/servlet/servlet.FileDownload?file='+sglAttachment.Id);
        }
	
        List<ContentDocumentLink> lstFiles = new List<ContentDocumentLink >();
        if(!lstParentId.isEmpty()){
            lstFiles = [SELECT ContentDocument.FileExtension,ContentDocument.Title ,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: lstParentId];
        }
        for(ContentDocumentLink sglFile : lstFiles){
            if(!mpAttachInteg.containskey(sglFile.LinkedEntityId)){
                mpAttachInteg.put(sglFile.LinkedEntityId,new Map<String,String>());
            }
            mpAttachInteg.get(sglFile.LinkedEntityId).put(sglFile.ContentDocument.Title+(String.isNotEmpty(sglFile.ContentDocument.FileExtension)?'.'+sglFile.ContentDocument.FileExtension:''),'https://'+System.URL.getSalesforceBaseURL().getHost()+'/servlet/servlet.FileDownload?file='+sglFile.ContentDocumentId);
        }
	
        List<Lineas_OC__c> lstlineaOC = new List<Lineas_OC__c>();
        if(!lstParentId.isEmpty()){
            lstlineaOC = [SELECT Id, Name, Operacion_Comercial__c, Linea__r.Codigo_de_linea__c, Linea__r.Linea_ETB__c,Linea__r.Tipo__c,Linea__r.Tipo_servicio__c,Accion__c,Estado__c,Tipo_relacion__c FROM Lineas_OC__c WHERE Operacion_Comercial__c IN: lstIntegrarId];
        }
	
        Map<Id,Map<String,Lineas_OC__c>> mpLineasInteg = new Map<Id,Map<String,Lineas_OC__c>>();
        for(Lineas_OC__c sgllineaOC : lstlineaOC){
            if(!mpLineasInteg.containskey(sgllineaOC.Operacion_Comercial__c)){
                mpLineasInteg.put(sgllineaOC.Operacion_Comercial__c,new Map<String,Lineas_OC__c>());
            }
            mpLineasInteg.get(sgllineaOC.Operacion_Comercial__c).put(sgllineaOC.Name,sgllineaOC);
        }
	
        List<LTE_SpecificationGroupXA__c> lstAtributosXA = new List<LTE_SpecificationGroupXA__c>();
        if(!lstParentId.isEmpty()){
            lstAtributosXA = [SELECT Id,Name,LTE_Value__c,LTE_ActionCode__c, LTE_ServiciosAdicionales__c, LTE_ServiciosAdicionales__r.Name,LTE_ServiciosAdicionales__r.LTE_OC_Tramite__c FROM LTE_SpecificationGroupXA__c WHERE LTE_ServiciosAdicionales__r.LTE_OC_Tramite__c IN: lstIntegrarId];
        }
	
        Map<Id,Map<String,LTE_SpecificationGroupXA__c>> mpAtributosXAInteg = new Map<Id,Map<String,LTE_SpecificationGroupXA__c>>();
        for(LTE_SpecificationGroupXA__c sglAtributosXA : lstAtributosXA){
            if(!mpAtributosXAInteg.containskey(sglAtributosXA.LTE_ServiciosAdicionales__r.LTE_OC_Tramite__c)){
                mpAtributosXAInteg.put(sglAtributosXA.LTE_ServiciosAdicionales__r.LTE_OC_Tramite__c,new Map<String,LTE_SpecificationGroupXA__c>());
            }
            mpAtributosXAInteg.get(sglAtributosXA.LTE_ServiciosAdicionales__r.LTE_OC_Tramite__c).put(sglAtributosXA.Name,sglAtributosXA);
        }
	
        Map<Id,ParametroIntegracion__c> lstParamInteg = new Map<Id,ParametroIntegracion__c>();
        if(!lstToppId.isEmpty()){
            lstParamInteg = new Map<Id, ParametroIntegracion__c>([SELECT Id,Name, Objeto_base__c, Campo__c, Objeto_destino__c, Campo_destino__c, Valor_por_defecto__c, Region_de_la_etiqueta__c, Tipo_Operacion_por_Plan__c
                             FROM ParametroIntegracion__c
                             WHERE Tipo_Operacion_por_Plan__c IN :lstToppId AND Activo__c =: true
							 AND Objeto_base__c = :sObjetoBase AND TipoIntegracion__c = :sTipoIntegracion
                             ORDER BY Name ASC]);
        }

        Set<String> lstCampoParam = new Set<String>();
        Map<String,List<Map<String,String>>> mpParamIntegDinamico = new Map<String,List<Map<String,String>>>();
	
        for(ParametroIntegracion__c sglParamInteg : lstParamInteg.values()){
            String sCampo = '';
            if(String.isNotEmpty(sglParamInteg.Objeto_destino__c) && String.isNotEmpty(sglParamInteg.Campo_destino__c)){
                sCampo = sglParamInteg.Objeto_destino__c.trim()+'.'+sglParamInteg.Campo_destino__c.trim();
            }else{
                sCampo = sglParamInteg.Campo__c.trim();
            }
            
            if(sCampo != ''){
                lstCampoParam.add(sCampo);
                if(!mpParamIntegDinamico.containskey(sglParamInteg.Tipo_Operacion_por_Plan__c)){
                    mpParamIntegDinamico.put(sglParamInteg.Tipo_Operacion_por_Plan__c,new List<Map<String,String>>());
                }
                Map<String,String> tmpMapParamInteg = new Map<String,String>();
                tmpMapParamInteg.put('Campo',sCampo);
                tmpMapParamInteg.put('Valor_Defecto',String.isNotEmpty(sglParamInteg.Valor_por_defecto__c)?'1'+sglParamInteg.Valor_por_defecto__c.trim():'');
                tmpMapParamInteg.put('Region_Etiqueta',String.isNotEmpty(sglParamInteg.Region_de_la_etiqueta__c)?sglParamInteg.Region_de_la_etiqueta__c.trim():'');
                tmpMapParamInteg.put('Etiqueta',String.isNotEmpty(sglParamInteg.Name)?sglParamInteg.Name.trim():'');
                mpParamIntegDinamico.get(sglParamInteg.Tipo_Operacion_por_Plan__c).add(tmpMapParamInteg);
            }
        }
        
        Map<Id,Campo_Dinamico__mdt> mpCampoDinamdt = new Map<Id,Campo_Dinamico__mdt>();
        if(!lstParamDefId.isEmpty()){
            mpCampoDinamdt = new Map<Id, Campo_Dinamico__mdt>([SELECT Id,Valor_Usuario__c, Valor_API__c, Valor_por_defecto__c, Agrupador__c,Tipo_Lista__c
                             FROM Campo_Dinamico__mdt
                             WHERE Proceso_Negocio__c = :sTipoProceso AND Tipo_Lista__c IN :lstParamDefId
                             ORDER BY Valor_Usuario__c ASC]);
        }
        
        for(Campo_Dinamico__mdt sglCampoDinamdt : mpCampoDinamdt.values()){
            if(sglCampoDinamdt.Valor_API__c != ''){
                lstCampoParam.add(sglCampoDinamdt.Valor_API__c.trim());
                if(!mpParamIntegDinamico.containskey(sglCampoDinamdt.Tipo_Lista__c)){
                    mpParamIntegDinamico.put(sglCampoDinamdt.Tipo_Lista__c,new List<Map<String,String>>());
                }
                Map<String,String> tmpMapParamInteg = new Map<String,String>();
                tmpMapParamInteg.put('Campo',sglCampoDinamdt.Valor_API__c.trim());
                tmpMapParamInteg.put('Valor_Defecto',String.isNotEmpty(sglCampoDinamdt.Valor_por_defecto__c)?sglCampoDinamdt.Valor_por_defecto__c.trim():'');
                tmpMapParamInteg.put('Region_Etiqueta',String.isNotEmpty(sglCampoDinamdt.Agrupador__c)?sglCampoDinamdt.Agrupador__c.trim():'');
                tmpMapParamInteg.put('Etiqueta',String.isNotEmpty(sglCampoDinamdt.Valor_Usuario__c)?sglCampoDinamdt.Valor_Usuario__c.trim():'');
                mpParamIntegDinamico.get(sglCampoDinamdt.Tipo_Lista__c).add(tmpMapParamInteg);
            }
        }
        
        Map<Id,List<Map<String,String>>> mpServRelacionadoAcc = new Map<Id,List<Map<String,String>>>();
        
        //lstServAccId
        Map<Id,Account> mpServRelacionadoDir = new Map<Id,Account>();
        system.debug(lstServAccId);
        if(!lstServAccId.isEmpty()){
            mpServRelacionadoDir = new Map<Id, Account>([SELECT Id,Name,
                                                         (SELECT Id,Name,Estado__c,NombredelProducto__r.Name FROM Activos_ETB1__r WHERE Estado__c IN ('Activo','Suspendido') ORDER BY Fecha_Activacion__c ASC),
                                                         (SELECT Id,Name,Estado__c,Activo__r.Name,Plan__r.NombredelProducto__r.Name FROM Operaciones_Comerciales__r WHERE TOPP__r.TipodeOperacionporplan__c = 'Venta' AND Estado__c IN ('Pendiente','En Curso') AND EstadoAprovisionamiento__c = 'En Aprovisionamiento' ORDER BY CreatedDate ASC) 
                                                         FROM Account WHERE Id = :lstServAccId]);
        }
        for(Account sglServRelAcc:mpServRelacionadoDir.values()){
            List<Map<String,String>> lstServRelaTmp = new List<Map<String,String>>();
            for(ActivoETB__c sglServRel:sglServRelAcc.Activos_ETB1__r){
                Map<String,String> mpParServRelAcc = new Map<String,String>();
                mpParServRelAcc.put('numero_solicitud',sglServRel.Name);
                mpParServRelAcc.put('producto',sglServRel.NombredelProducto__r.Name);
                mpParServRelAcc.put('tipo_solicitud','SERVICIO');
                mpParServRelAcc.put('descripcion','');
                lstServRelaTmp.add(mpParServRelAcc);
            }
            for(OperacionComercial__c sglOCRel:sglServRelAcc.Operaciones_Comerciales__r){
                Map<String,String> mpParServRelAcc = new Map<String,String>();
                mpParServRelAcc.put('numero_solicitud',sglOCRel.Name);
                mpParServRelAcc.put('producto',sglOCRel.Plan__r.NombredelProducto__r.Name);
                mpParServRelAcc.put('tipo_solicitud','APROVISIONAMIENTO');
                mpParServRelAcc.put('descripcion','');
                lstServRelaTmp.add(mpParServRelAcc);
            }
            mpServRelacionadoAcc.put(sglServRelAcc.Id,lstServRelaTmp);
            system.debug(mpServRelacionadoAcc);
        }

        Mensaje_Integracion__c lstMensajes = [SELECT Id,Mensaje__c FROM Mensaje_Integracion__c WHERE Name =:sMensaje];
        String sFields = lstMensajes.Mensaje__c;
        for(String sglfieldname:sFields.split(',')){
            lstCampoParam.add(sglfieldname.trim());
        }
        //lstCampoParam.addAll(sFields.split(','));
	
        String joinedString = String.join(new List<String>(lstCampoParam), ',');
        String sql = 'SELECT '+joinedString+' FROM '+ sObjetoBase+' WHERE Id IN :lstIntegrarId';
        List<SObject> lstObjetos = Database.query(sql);
        
        List<Viabilidad__c> lstViabilidadRelacionada = new List<Viabilidad__c>();
        Map<Id,String> mpViabilidadRelacionada = new Map<Id,String>();
        if(Operacion == TipoOperacionOrdenGestor.APROVISIONAMIENTO){
            lstViabilidadRelacionada = [SELECT Id,OperacionComercial__c,Name FROM Viabilidad__c WHERE OperacionComercial__c IN :lstIntegrarId AND Respuestadeviabilidad__c = 'Viable' ORDER BY OperacionComercial__c, CreatedDate DESC];
            for(Viabilidad__c sglViabilidad:lstViabilidadRelacionada){
                if(!mpViabilidadRelacionada.containskey(sglViabilidad.OperacionComercial__c))
                    mpViabilidadRelacionada.put(sglViabilidad.OperacionComercial__c,sglViabilidad.Name);
            }
        }
        
        Map<Id,Map<String,Object>> mpPrimaryObject = PS_IntegrationHelper_ctr.PopulateMap(sObjetoBase, lstCampoParam, lstObjetos, 'yyyy-MM-dd\'T\'HH:mm:ssXXX');
        
        for(SObject sglObjeto:lstObjetos){
            Integer diasANS = 0;
            Integer anchoDeBanda = 0;
            
            String strIdRelacionServDir = mpRelacionServDir.containskey(sglObjeto.Id)?String.valueOf(mpRelacionServDir.get(sglObjeto.Id)):'';
            String strIdRelacionParam = mpRelacionParam.containskey(sglObjeto.Id)?String.valueOf(mpRelacionParam.get(sglObjeto.Id)):'';
            String strIdRelacionAtt = mpRelacionAtt.containskey(sglObjeto.Id)?String.valueOf(mpRelacionAtt.get(sglObjeto.Id)):'';
            Map<String,Object> tmpMapHierarchy = new Map<String,Object>();
            
            if(mpPrimaryObject.containskey(sglObjeto.Id))
                tmpMapHierarchy = mpPrimaryObject.get(sglObjeto.Id); 
            
            if(Operacion == TipoOperacionOrdenGestor.VIA_CONSULTIVA){
                tmpMapHierarchy.put('ViabilidadOrigen',mpRelacionViabilidad.get(sglObjeto.Id));
            }
            else if(Operacion == TipoOperacionOrdenGestor.VIA_ESPECIFICA){
                tmpMapHierarchy.put('ViabilidadOrigen',mpRelacionViabilidad.get(sglObjeto.Id));
                System.debug(tmpMapHierarchy.get('ViabilidadOrigen'));
                if(String.isnotEmpty(String.valueOf(tmpMapHierarchy.get('Oportunidad__r.ANS__c'))))
                    diasANS = (String.valueOf(tmpMapHierarchy.get('Oportunidad__r.ANS__c'))).isNumeric()?(integer.valueof(tmpMapHierarchy.get('Oportunidad__r.ANS__c')))*1440:0;
                else if(String.isnotEmpty(String.valueOf(tmpMapHierarchy.get('TOPP__r.ANS_Factibilidad__c'))))
                    diasANS = (String.valueOf(tmpMapHierarchy.get('TOPP__r.ANS_Factibilidad__c'))).isNumeric()?(integer.valueof(tmpMapHierarchy.get('TOPP__r.ANS_Factibilidad__c')))*1440:0;
                else
                    diasANS = 0;
                if(String.isnotEmpty(String.valueOf(tmpMapHierarchy.get('AnchoBanda__r.Numero__c')))){
                    anchoDeBanda = (String.valueOf(tmpMapHierarchy.get('AnchoBanda__r.Numero__c'))).isNumeric()?(integer.valueof(tmpMapHierarchy.get('AnchoBanda__r.Numero__c'))):0;
                }
                tmpMapHierarchy.put('AnchoDeBandaAutomatico',(anchoDeBanda <= 300 && anchoDeBanda > 0));
                //tmpMapHierarchy.put('IdViabilidad',mpRelacionViabilidad.get(sglObjeto.Id).get('Id'));
                
            }
            else if(Operacion == TipoOperacionOrdenGestor.APROVISIONAMIENTO){
                if(String.isnotEmpty(String.valueOf(tmpMapHierarchy.get('Oportunidad__r.ANS__c'))))
                    diasANS = (String.valueOf(tmpMapHierarchy.get('Oportunidad__r.ANS__c'))).isNumeric()?(integer.valueof(tmpMapHierarchy.get('Oportunidad__r.ANS__c')))*1440:0;
                else if(String.isnotEmpty(String.valueOf(tmpMapHierarchy.get('TOPP__r.ANS__c'))))
                    diasANS = (String.valueOf(tmpMapHierarchy.get('TOPP__r.ANS__c'))).isNumeric()?(integer.valueof(tmpMapHierarchy.get('TOPP__r.ANS__c')))*1440:0;
                else
                    diasANS = 0;
            }
            else if(Operacion == TipoOperacionOrdenGestor.ACTUALIZAR_SERVICO){
            }
            tmpMapHierarchy.put('UserName',UserInfo.getUserName());
            tmpMapHierarchy.put('ANS',String.valueOf(diasANS));
            tmpMapHierarchy.put('NombreVia',mpViabilidadRelacionada.containskey(sglObjeto.Id)?mpViabilidadRelacionada.get(sglObjeto.Id):'');
            
            List<Map<String,Object>> lstMapHierarchy_Params = new List<Map<String,Object>>();
            system.debug(strIdRelacionParam);
            if(String.isNotEmpty(strIdRelacionParam)){
                if(!mpParamIntegDinamico.containskey(strIdRelacionParam)){
                    strIdRelacionParam = mpRelacionParamDefault.containskey(sglObjeto.Id)?String.valueOf(mpRelacionParamDefault.get(sglObjeto.Id)):'';
                    if(!mpParamIntegDinamico.containskey(strIdRelacionParam)){
                        strIdRelacionParam = '';
                    }
                }
            }
            else{
                strIdRelacionParam = mpRelacionParamDefault.containskey(sglObjeto.Id)?String.valueOf(mpRelacionParamDefault.get(sglObjeto.Id)):'';
                system.debug(strIdRelacionParam);
                if(!mpParamIntegDinamico.containskey(strIdRelacionParam)){
                    strIdRelacionParam = '';
                }
            }
            if(String.isNotEmpty(strIdRelacionParam)){
                if(mpParamIntegDinamico.containskey(strIdRelacionParam)){
                    Map<String,Object> tmpMapHierarchy_ParamAgrupador = new Map<String,Object>();
                    
                    for(Map<String,String> mpTempParamInteg:mpParamIntegDinamico.get(strIdRelacionParam)){
                        
                        Object svalor = LibreriaUtilitaria_cls.recorreCampos(sglObjeto, mpTempParamInteg.get('Campo'));
                        if(svalor==null){
                            svalor = mpTempParamInteg.get('Valor_Defecto');
                        }
                        if(!tmpMapHierarchy_ParamAgrupador.containskey(mpTempParamInteg.get('Region_Etiqueta'))){
                            tmpMapHierarchy_ParamAgrupador.put(mpTempParamInteg.get('Region_Etiqueta'),new List<Map<String,Object>>());
                        }
                        Map<String,Object> tmpMapHierarchy_Param = new Map<String,Object>();
                        tmpMapHierarchy_Param.put('Campo__c',mpTempParamInteg.get('Etiqueta'));
                        tmpMapHierarchy_Param.put('Valor__c',svalor);
                        ((List<Map<String,Object>>)tmpMapHierarchy_ParamAgrupador.get(mpTempParamInteg.get('Region_Etiqueta'))).add(tmpMapHierarchy_Param);
                    }
                    
                    for(String stempRegion :tmpMapHierarchy_ParamAgrupador.keyset()){
                        Map<String,Object> tmpMapHierarchy_RegionAgrupador = new Map<String,Object>();
                        tmpMapHierarchy_RegionAgrupador.put('Region',stempRegion);
                        tmpMapHierarchy_RegionAgrupador.put('Parametros',tmpMapHierarchy_ParamAgrupador.get(stempRegion));
                        lstMapHierarchy_Params.add(tmpMapHierarchy_RegionAgrupador);
                    }
                }
            }
            
            tmpMapHierarchy.put('ParametrosDinamicos',lstMapHierarchy_Params);
            
            List<Map<String,Object>> lstMapHierarchy_Attach = new List<Map<String,Object>>();
            if(String.isNotEmpty(strIdRelacionAtt)){
                if(mpAttachInteg.containskey(strIdRelacionAtt)){
                    Map<String,String> tmpMapAttach = mpAttachInteg.get(strIdRelacionAtt);
                    for(String sglAttach:tmpMapAttach.keySet()){
                        Map<String,Object> tmpMapHierarchy_Attach = new Map<String,Object>();
                        tmpMapHierarchy_Attach.put('Name',sglAttach);
                        tmpMapHierarchy_Attach.put('URL',tmpMapAttach.get(sglAttach));
                        lstMapHierarchy_Attach.add(tmpMapHierarchy_Attach);
                    }
                }
            }
            tmpMapHierarchy.put('Adjuntos',lstMapHierarchy_Attach);
            
            List<Map<String,Object>> lstMapHierarchy_RelServ = new List<Map<String,Object>>();
            if(String.isNotEmpty(strIdRelacionServDir)){
                if(mpServRelacionadoAcc.containskey(strIdRelacionServDir)){
                    String b_gpon = 'true'; //Solo usado en gpon-- se debe migrar a gestor esta funcionalidad
					for(Map<String,String> tmpMapServRel:mpServRelacionadoAcc.get(strIdRelacionServDir)){
						if(tmpMapServRel.get('numero_solicitud')!=tmpMapHierarchy.get('Name') && tmpMapServRel.get('numero_solicitud')!=tmpMapHierarchy.get('Activo__r.Name')){
                            Map<String,Object> tmpMapHierarchy_ServRel = new Map<String,Object>();
                            tmpMapHierarchy_ServRel.put('es_principal',tmpMapServRel.get('producto').contains('GPON')?b_gpon:'false');
                            tmpMapHierarchy_ServRel.put('numero_solicitud',tmpMapServRel.get('numero_solicitud'));
                            tmpMapHierarchy_ServRel.put('tipo_solicitud',tmpMapServRel.get('tipo_solicitud'));
                            tmpMapHierarchy_ServRel.put('descripcion',tmpMapServRel.get('descripcion'));
                            tmpMapHierarchy_ServRel.put('producto',tmpMapServRel.get('producto'));
                            lstMapHierarchy_RelServ.add(tmpMapHierarchy_ServRel);
							
							if(tmpMapServRel.get('producto').contains('GPON'))
								b_gpon = 'false';
						}
                    }
                }
            }
            tmpMapHierarchy.put('ServiciosRelacionados',lstMapHierarchy_RelServ);
            
            Map<String,Object> mpCantidadTipoLineas = new Map<String,Object>();
            Integer scantidadlineas = 0;
            List<Map<String,Object>> lstMapHierarchy_linea = new List<Map<String,Object>>();
            if(mpLineasInteg.containskey(sglObjeto.Id)){
                Map<String,Object> tmpMapLinea = mpLineasInteg.get(sglObjeto.Id);
                for(String sglLinea:tmpMapLinea.keySet()){
                    Lineas_OC__c sgltmpLinea = (Lineas_OC__c)tmpMapLinea.get(sglLinea);
                    Map<String,Object> tmpMapHierarchy_Linea = new Map<String,Object>();
                    tmpMapHierarchy_Linea.put('Linea__r.Codigo_de_linea__c',sgltmpLinea.Linea__r.Codigo_de_linea__c);
                    tmpMapHierarchy_Linea.put('Linea__r.Linea_ETB__c',sgltmpLinea.Linea__r.Linea_ETB__c);
                    tmpMapHierarchy_Linea.put('Linea__r.Tipo__c',sgltmpLinea.Linea__r.Tipo__c);
                    tmpMapHierarchy_Linea.put('Linea__r.Tipo_servicio__c',sgltmpLinea.Linea__r.Tipo_servicio__c);
                    tmpMapHierarchy_Linea.put('Accion__c',sgltmpLinea.Accion__c);
                    tmpMapHierarchy_Linea.put('Estado__c',sgltmpLinea.Estado__c);
                    tmpMapHierarchy_Linea.put('Tipo_servicio__c',sgltmpLinea.Tipo_relacion__c);
                    lstMapHierarchy_linea.add(tmpMapHierarchy_Linea);
                    if(!mpCantidadTipoLineas.containskey(sgltmpLinea.Linea__r.Linea_ETB__c))
                        mpCantidadTipoLineas.put(sgltmpLinea.Linea__r.Linea_ETB__c,0);
                    mpCantidadTipoLineas.put(sgltmpLinea.Linea__r.Linea_ETB__c,Integer.valueOf(mpCantidadTipoLineas.get(sgltmpLinea.Linea__r.Linea_ETB__c))+1);
                    scantidadlineas++;
                }
            }
            tmpMapHierarchy.put('Lineas',lstMapHierarchy_linea);
            
            Integer lineasAdicionales = 0;
            if(tmpMapHierarchy.containskey('Cantidad_lineas__c'))
                lineasAdicionales = (String.valueOf(tmpMapHierarchy.get('Cantidad_lineas__c'))).isNumeric()?(integer.valueof(tmpMapHierarchy.get('Cantidad_lineas__c'))):0;
            mpCantidadTipoLineas.put('Adicionales',String.valueOf(lineasAdicionales));
            tmpMapHierarchy.put('LineasTotalesRotacion',String.valueOf(scantidadlineas+lineasAdicionales));
            
            List<Map<String,Object>> lstCantidadTipoLineas = new List<Map<String,Object>>();
            for(String sgltmpCantidadTipoLineas:mpCantidadTipoLineas.keyset()){
                Map<String,Object> mpTmpCantidadTipoLineas = new Map<String,Object>();
                mpTmpCantidadTipoLineas.put('Tipo',sgltmpCantidadTipoLineas);
                mpTmpCantidadTipoLineas.put('Cantidad',String.valueOf(mpCantidadTipoLineas.get(sgltmpCantidadTipoLineas)));
                lstCantidadTipoLineas.add(mpTmpCantidadTipoLineas);
            }
            
            tmpMapHierarchy.put('LineasCantidades',lstCantidadTipoLineas);
            
            List<Map<String,Object>> lstMapHierarchy_XA = new List<Map<String,Object>>();
            if(mpAtributosXAInteg.containskey(sglObjeto.Id)){
                Map<String,Object> tmpMapXA = mpAtributosXAInteg.get(sglObjeto.Id);
                for(String sglXA:tmpMapXA.keySet()){
                    LTE_SpecificationGroupXA__c sgltmpXA = (LTE_SpecificationGroupXA__c)tmpMapXA.get(sglXA);
                    Map<String,Object> tmpMapHierarchy_XA = new Map<String,Object>();
                    tmpMapHierarchy_XA.put('Name',sgltmpXA.Name);
                    tmpMapHierarchy_XA.put('LTE_Value__c',sgltmpXA.LTE_Value__c);
                    tmpMapHierarchy_XA.put('LTE_ActionCode__c',sgltmpXA.LTE_ActionCode__c);
                    tmpMapHierarchy_XA.put('LTE_ServiciosAdicionales__r.Name',sgltmpXA.LTE_ServiciosAdicionales__r.Name);
                    lstMapHierarchy_XA.add(tmpMapHierarchy_XA);
                }
            }
            tmpMapHierarchy.put('ParametrosXA',lstMapHierarchy_XA);
            
            
            mapHierarchy.put(sglObjeto.Id,tmpMapHierarchy);
        }
        return mapHierarchy;
    }
    
    public Map<Id,String> IntegracionGestor(Map<Id,Map<String,Object>> mapDatos, TipoOperacionOrdenGestor Operacion){
        Map<string,string> values = new map<string,string>();
        string response = '';
        string srequest = '';
        ServiciosWeb__c sw;
        String sTipoMensaje = '';
        String sErrorIntegracionGenerico = '';
        String sErrorIntegracionDetallado = '';
        String sLogName = '';
        String strObjName = '';
        List<LogTransacciones__c> lstLogTransacciones = new List<LogTransacciones__c>();
        Dom.Document docMessageTemplate = new Dom.Document();
        Dom.Document docServices;
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        Map<Id,String> mpResultado = new Map<Id,String>();
        List<SObject> lstOp = new List<SObject>();
        Map<String,String> mpCamposRelacionLog = new Map<String,String>();
        PS_IntegrationHelper_ctr clsHelper = new PS_IntegrationHelper_ctr();
        
        if(Operacion == TipoOperacionOrdenGestor.VIA_CONSULTIVA){
            sw = ServiciosWeb__c.getValues('GestorSolicitudes');
            sTipoMensaje = 'Gestor_ViabilidadConsultiva_PS';
            sErrorIntegracionGenerico = Label.Mensaje_error_OP_integracion_Gestor;
            sErrorIntegracionDetallado = Label.Mensaje_error_integ_OP_Gestor_no_disponible;
            mpCamposRelacionLog.put('NumeroViabilidad__c','{@ViabilidadOrigen/Id}');
            mpCamposRelacionLog.put('Account__c','{@Account.Id}');
            sLogName = 'GestorSolicitudes';
            strObjName = '{@ViabilidadOrigen/Name}';
        }
        else if(Operacion == TipoOperacionOrdenGestor.VIA_ESPECIFICA){
            sw = ServiciosWeb__c.getValues('GestorSolicitudes');
            sTipoMensaje = 'Gestor_ViabilidadEspecifica_PS';
            sErrorIntegracionGenerico = Label.Mensaje_error_integracion_Gestor;
            sErrorIntegracionDetallado = Label.Mensaje_error_integracion_Gestor_no_disponible;
            mpCamposRelacionLog.put('NumeroViabilidad__c','{@ViabilidadOrigen/Id}');
            mpCamposRelacionLog.put('LTE_Operacion_Comercial__c','{@Id}');
            sLogName = 'GestorSolicitudes';
            strObjName = '{@ViabilidadOrigen/Name}';
        }
        else if(Operacion == TipoOperacionOrdenGestor.APROVISIONAMIENTO){
            sw = ServiciosWeb__c.getValues('GestorSolicitudes');
            sTipoMensaje = 'Gestor_Aprovisionamiento_PS';
            sErrorIntegracionGenerico = Label.Mensaje_error_integracion_Gestor_apvs;
            sErrorIntegracionDetallado = Label.Mensaje_error_integracion_Gestor_no_disponible_apvs;
            mpCamposRelacionLog.put('LTE_Operacion_Comercial__c','{@Id}');
            sLogName = 'GestorSolicitudesAprovisionamiento';
            strObjName = '{@Name}';
        }
        else if(Operacion == TipoOperacionOrdenGestor.ACTUALIZAR_SERVICO){
            sw = ServiciosWeb__c.getValues('GestorSolicitudesActualizarServicio');
            sTipoMensaje = 'Remedy_CrearIncidente_PS';
        }
        else if(Operacion == TipoOperacionOrdenGestor.APROVISIONAMIENTO_ALIADO){
            sw = ServiciosWeb__c.getValues('OrchAliado');
            sTipoMensaje = 'Aliado_Aprovisionamiento_PS';
            sErrorIntegracionGenerico = Label.Mensaje_error_integracion_Gestor_apvs;
            sErrorIntegracionDetallado = Label.Mensaje_error_integracion_Gestor_no_disponible_apvs;
            mpCamposRelacionLog.put('LTE_Operacion_Comercial__c','{@Id}');
            sLogName = 'GestorSolicitudesAprovisionamiento';
            strObjName = '{@Name}';
        }
        
        if(String.isNotEmpty(sTipoMensaje)){
            Map<String,String> mapMensajesIntegracion = new Map<String,String>();
            List<Mensaje_Integracion__c> lstMensajes = [SELECT Id,Name,Mensaje__c FROM Mensaje_Integracion__c WHERE Name = :sTipoMensaje];
            for(Mensaje_Integracion__c sglMensaje:lstMensajes){
                mapMensajesIntegracion.put(sglMensaje.Name, sglMensaje.Mensaje__c);
            }
            if(mapMensajesIntegracion.containskey(sTipoMensaje) && sTipoMensaje != 'Aliado_Aprovisionamiento_PS'){
                docMessageTemplate.load(mapMensajesIntegracion.get(sTipoMensaje));
                boolean errorAPVS;
                for(Id sglRecord:mapDatos.keyset()){
                    errorAPVS = false;
                    Map<String,Object> tmpmapDatos = (Map<String,Object>)mapDatos.get(sglRecord);
                    System.debug(tmpmapDatos.get('ViabilidadOrigen'));
                    docServices = clsHelper.PopulateXML(docMessageTemplate, mapDatos.get(sglRecord));
                    if(false){
                        DOM.Document df = clsHelper.MaptoXML(mapDatos.get(sglRecord));
                        response = String.valueOf(df.toXmlString());
                        mpResultado.put(sglRecord,'');
                    }else{
                        response=LibreriaUtilitariaJobs_cls.consultarServicio(docServices.toXmlString(),sw.Action__c,sw.EndPoint__c);
                        try{
                            // obtener respuesta
                            values = proReq.getMap(response);
                            // generar map
                            if(String.isNotEmpty(values.get('NomError'))){
                                mpResultado.put(sglRecord,(sErrorIntegracionGenerico.replace('%nro_oc%', clsHelper.EvaluateValue(strObjName,tmpmapDatos))).replace('%msj_error%',values.get('NomError')));
                                errorAPVS = true;
                            }else if(values.get('OperationResult') == null || values.get('OperationResult')==''){
                                mpResultado.put(sglRecord,sErrorIntegracionDetallado.replace('%nro_oc%', clsHelper.EvaluateValue(strObjName,tmpmapDatos)));
                                errorAPVS = true;
                            }else if(values.get('OperationResult') != '1'){
                                mpResultado.put(sglRecord,(sErrorIntegracionGenerico.replace('%nro_oc%', clsHelper.EvaluateValue(strObjName,tmpmapDatos))).replace('%msj_error%',values.get('OperationResultDesc')));
                                errorAPVS = true;
                            }else{
                                mpResultado.put(sglRecord,'');
                                if(Operacion == TipoOperacionOrdenGestor.VIA_ESPECIFICA || Operacion == TipoOperacionOrdenGestor.VIA_CONSULTIVA){
                                    SObject sglObj = new Viabilidad__c(Id=clsHelper.EvaluateValue('{@ViabilidadOrigen/Id}',tmpmapDatos));
                                    sglObj.put('Fecha_Envio_Integracion_Gestor__c',DateTime.now());
                                    lstOp.add(sglObj);
                                } else if(Operacion == TipoOperacionOrdenGestor.APROVISIONAMIENTO){
                                    system.debug(sglRecord);
                                    SObject sglObj = new OperacionComercial__c(Id=sglRecord);
                                    sglObj.put('EstadoAprovisionamiento__c','En Aprovisionamiento');
                                    sglObj.put('Fecha_Envio_Integracion_Gestor__c',DateTime.now());
                                    sglObj.put('Flag_Update_APVS_Integ__c',true);
                                    lstOp.add(sglObj);
                                }
                            }
                            if(errorAPVS && Operacion == TipoOperacionOrdenGestor.APROVISIONAMIENTO){
                                SObject sglObj = new OperacionComercial__c(Id=sglRecord);
                                sglObj.put('EstadoAprovisionamiento__c','');
                                lstOp.add(sglObj);
                            }
                        }catch(exception e){
                            system.debug(e.getStackTraceString());
                            mpResultado.put(sglRecord,e.getMessage());
                        }
                    }
                    LogTransacciones__c logServicio = new LogTransacciones__c();
                    //logServicio.put(sCampoRelacionLog,sglRecord);
                    if(!mpCamposRelacionLog.isEmpty()){
                        for(String sglRelacionLog:mpCamposRelacionLog.keyset()){
                            if(mpCamposRelacionLog.containskey(sglRelacionLog)){
                                system.debug(mpCamposRelacionLog.get(sglRelacionLog));
                                String sValorDin = clsHelper.EvaluateValue(mpCamposRelacionLog.get(sglRelacionLog),tmpmapDatos);
                                system.debug(mpCamposRelacionLog.get(sglRelacionLog)+' - '+sValorDin);
                                if(String.isNotEmpty(sValorDin)){
                                    logServicio.put(sglRelacionLog,sValorDin);
                                }
                            }
                        }
                    }
                    logServicio.Name = sLogName + ' - '+clsHelper.EvaluateValue(strObjName,tmpmapDatos);
                    logServicio.Informacion_Enviada__c = String.valueOf(docServices.toXmlString());
                    logServicio.Informacion_Recibida__c = response;
                    logServicio.Estado__c = String.isEmpty(mpResultado.get(sglRecord))?'Realizado':'Fallido';
                    lstLogTransacciones.add(logServicio);
                }
                system.debug(lstOp);
                if(!lstLogTransacciones.isEmpty())
                    insert lstLogTransacciones;
                if(!lstOp.isEmpty()){
                    BanderasEjecucion.SetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                    update lstOp;
                }
            }
            else if(mapMensajesIntegracion.containskey(sTipoMensaje) && sTipoMensaje == 'Aliado_Aprovisionamiento_PS'){
                for(Id sglRecord:mapDatos.keyset()){
                    Map<String,Object> tmpmapDatos = (Map<String,Object>)mapDatos.get(sglRecord);
                    mpResultado.put(sglRecord,'');
                    DateTime dt = system.now();
                    String sformatedDt = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                    String sParametros = '[\n';
                    if(tmpmapDatos.containskey('ParametrosXA')){
                        List<Map<String,Object>> lstTmpXA = (List<Map<String,Object>>)tmpmapDatos.get('ParametrosXA');
                        integer i = 0;
                        for(Map<String,Object> sglTmpXA:lstTmpXA){
                            i++;
                            sParametros += '{\n';
                            sParametros += '"Nombre":"'+sglTmpXA.get('Name')+'",\n';
                            sParametros += '"Valor":"'+sglTmpXA.get('LTE_Value__c')+'",\n';
                            sParametros += '"CodigoAccion":"'+sglTmpXA.get('LTE_ActionCode__c')+'",\n';
                            sParametros += '"Grupo":"'+sglTmpXA.get('LTE_ServiciosAdicionales__r.Name')+'",\n';
                            sParametros += '"Tipo":"Nuevo"\n';
                            sParametros += (i<lstTmpXA.Size())?'},\n':'}\n';
                        }
                    }
                    sParametros += ']';
                    
                    Http h = new Http();
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint(sw.EndPoint__c);
                    req.setMethod('POST');
                    req.setHeader( 'Content-Type', 'application/json' );
                    srequest = '{\n'+
                        '"NumeroOrden":"'+String.ValueOf(tmpmapDatos.get('Name'))+'",\n'+
                        '"FechaComprometida":"' + sformatedDt + '",\n'+
                        '"Tipo":"'+String.ValueOf(tmpmapDatos.get('TOPP__r.TipodeOperacionporplan__c'))+'",\n'+
                        '"Subtipo":"",\n'+
                        '"Prioridad":"Baja",\n'+
                        '"Estado":"Pendiente",\n'+
                        '"Etapa":"APV",\n'+
                        '"Comentarios":"'+String.ValueOf(tmpmapDatos.get('Comentarios__c'))+'",\n'+
                        '"SistemaOrigen":"Salesforce",\n'+
                        '"Cliente":{\n'+
                        '"TipoDocumento":"'+String.ValueOf(tmpmapDatos.get('CuentaCliente__r.Tipodedocumento__c'))+'",\n'+
                        '"NumeroDocumento":"'+String.ValueOf(tmpmapDatos.get('CuentaCliente__r.AccountNumber'))+'",\n'+
                        '"Nombre":"'+String.ValueOf(tmpmapDatos.get('CuentaCliente__r.Name'))+'",\n'+
                        '"Direccion":"'+String.ValueOf(tmpmapDatos.get('CuentaCliente__r.Direccion__c'))+'",\n'+
                        '"UEN":"'+String.ValueOf(tmpmapDatos.get('CuentaCliente__r.UEN__c'))+'",\n'+
                        '"Segmento":"'+String.ValueOf(tmpmapDatos.get('CuentaCliente__r.Segmento__c'))+'",\n'+
                        '"SegmentoUEN":"'+String.ValueOf(tmpmapDatos.get('CuentaCliente__r.SubSegmento__c'))+'",\n'+
                        '"Categoria":"'+String.ValueOf(tmpmapDatos.get('CuentaCliente__r.Esquema_de_Atencion__c'))+'",\n'+
                        '"ActividadEconomica":"'+String.ValueOf(tmpmapDatos.get('CuentaCliente__r.Actividad_Economica__c'))+'"\n'+
                        '},\n'+
                        '"OrdenItems":[\n{\n'+
                        '"NumeroItem":"'+String.ValueOf(tmpmapDatos.get('Name'))+'",\n'+
                        '"Cantidad":"1",\n'+
                        '"CodigoAccion":"'+(String.ValueOf(tmpmapDatos.get('TOPP__r.TipodeOperacionporplan__c'))=='Venta'?'ADD':'')+'",\n'+
                        '"IdServicio":"'+String.ValueOf(tmpmapDatos.get('Activo__r.IDservicio__c'))+'",\n'+
                        '"NumeroItemPadre":"",\n'+
                        '"NumeroItemRaiz":"",\n'+
                        '"Estado":"Pendiente",\n'+
                        '"Producto":{\n'+
                        '"CodigoProducto":"' + String.ValueOf(tmpmapDatos.get('TOPP__r.Plan__r.Codigo_Plan__c')) + '",\n'+
                        '"ClaseProducto":"eCommerce ViveTech Class"\n'+
                        '},\n'+
                        '"CuentaFacturacion":{\n'+
                        '"CodigoCuentaFacturacion":"' + String.ValueOf(tmpmapDatos.get('TOPP__r.Plan__r.Codigo_Plan__c')) + '"\n'+
                        '},\n'+
                        '"CuentaServicio":{\n'+
                        '"CodigoCuentaServicio":"' + String.ValueOf(tmpmapDatos.get('TOPP__r.Plan__r.Codigo_Plan__c')) + '"\n'+
                        '},\n'+
                        '"Comentarios":"'+String.ValueOf(tmpmapDatos.get('Comentarios__c'))+'",\n'+
                        '"AplicaEtapa":true,\n'+
                        '"Parametros":'+sParametros+',\n'+
                        '"Contactos":[\n{\n'+
                        	'"CodigoContacto":"'+String.ValueOf(tmpmapDatos.get('Contacto_Tecnico__c'))+'",\n'+
                        	'"Nombres":"'+String.ValueOf(tmpmapDatos.get('Contacto_Tecnico__r.FirstName'))+'",\n'+
                        	'"Apellidos":"'+String.ValueOf(tmpmapDatos.get('Contacto_Tecnico__r.LastName'))+'",\n'+
                        	'"CorreoElectronico":"'+String.ValueOf(tmpmapDatos.get('Contacto_Tecnico__r.Email'))+'",\n'+
                        	'"Telefono":"'+String.ValueOf(tmpmapDatos.get('Contacto_Tecnico__r.Phone'))+'",\n'+
                        	'"TelefonoMovil":"'+String.ValueOf(tmpmapDatos.get('Contacto_Tecnico__r.MobilePhone'))+'",\n'+
                        	'"Direccion":"'+String.ValueOf(tmpmapDatos.get('Contacto_Tecnico__r.Direccion__c'))+'",\n'+
                        	'"AutorizaDatos":"'+String.ValueOf(tmpmapDatos.get('Contacto_Tecnico__r.Autoriza_Tratamiento_de_Datos_Personales__c'))+'",\n'+
                        	'"Tipo":"Contacto Tecnico"\n'+
                        '}\n]\n'+
                        '}\n]\n'+
                        '}';
                    
                    req.setBody(srequest);
                    try{
                        HttpResponse res = h.send(req);
                        response = res.getBody();
                        system.debug('res.getStatusCode()');
                        system.debug(res.getStatusCode());
                        if(Operacion == TipoOperacionOrdenGestor.APROVISIONAMIENTO_ALIADO){
                            if(res.getStatusCode()<400){
                                system.debug(sglRecord);
                                SObject sglObj = new OperacionComercial__c(Id=sglRecord);
                                sglObj.put('Estado__c','Enviado Aprovisionamiento');
                                sglObj.put('EstadoAprovisionamiento__c','En Aprovisionamiento');
                                sglObj.put('Fecha_Envio_Integracion_Gestor__c',DateTime.now());
                                sglObj.put('Flag_Update_APVS_Integ__c',true);
                                lstOp.add(sglObj);
                            }else{
                                mpResultado.put(sglRecord,response);
                            }
                        }
                    }catch(Exception e){
                        response = e.getMessage();
                        mpResultado.put(sglRecord,response);
                    }
                    
                    LogTransacciones__c logServicio = new LogTransacciones__c();
                    //logServicio.put(sCampoRelacionLog,sglRecord);
                    if(!mpCamposRelacionLog.isEmpty()){
                        for(String sglRelacionLog:mpCamposRelacionLog.keyset()){
                            if(mpCamposRelacionLog.containskey(sglRelacionLog)){
                                system.debug(mpCamposRelacionLog.get(sglRelacionLog));
                                String sValorDin = clsHelper.EvaluateValue(mpCamposRelacionLog.get(sglRelacionLog),tmpmapDatos);
                                system.debug(mpCamposRelacionLog.get(sglRelacionLog)+' - '+sValorDin);
                                if(String.isNotEmpty(sValorDin)){
                                    logServicio.put(sglRelacionLog,sValorDin);
                                }
                            }
                        }
                    }
                    logServicio.Name = sLogName + ' - '+clsHelper.EvaluateValue(strObjName,tmpmapDatos);
                    logServicio.Informacion_Enviada__c = srequest;
                    logServicio.Informacion_Recibida__c = response;
                    logServicio.Estado__c = String.isEmpty(mpResultado.get(sglRecord))?'Realizado':'Fallido';
                    lstLogTransacciones.add(logServicio);
                }
                if(!lstLogTransacciones.isEmpty())
                    insert lstLogTransacciones;
                if(!lstOp.isEmpty()){
                    BanderasEjecucion.SetEjecucion('LTE_DetalleOferta_tgr_actualizarCamposOC');
                    update lstOp;
                }
            }
        }
        return mpResultado;
    }
    
    public List<Map<String,String>> ValidarCondicionesCamposObligatorios(Map<String,Object> mapaDatos,String strProcesoNegocio){
        List<Map<String,String>> lstCondiciones = new List<Map<String,String>>();
        List<Condicion_Dinamica__mdt> lstCondicionDinamica = [SELECT Id,MasterLabel,Condicion__c,Mensaje__c,Nivel_Error__c FROM Condicion_Dinamica__mdt WHERE Proceso_Negocio__c = :strProcesoNegocio];
        PS_IntegrationHelper_ctr clsIntHelper = new PS_IntegrationHelper_ctr();
        for(Condicion_Dinamica__mdt sglCondicionDinamica:lstCondicionDinamica){
            String strEvalValue = '';
            try{
                strEvalValue = clsIntHelper.EvaluateValue(sglCondicionDinamica.Condicion__c,mapaDatos);
            }catch(exception e){
                strEvalValue = 'false';
                system.debug(e.getMessage());
            }
            Map<String,String> mpCondicion = new Map<String,String>();
            mpCondicion.put('MasterLabel',sglCondicionDinamica.MasterLabel);
            mpCondicion.put('Condicion__c',strEvalValue);
            mpCondicion.put('Mensaje__c',sglCondicionDinamica.Mensaje__c);
            mpCondicion.put('Nivel_Error__c',sglCondicionDinamica.Nivel_Error__c);
            lstCondiciones.add(mpCondicion);
        }
        return lstCondiciones;
    }
    
    public static Boolean validarUsuarioLV(id idUsuario,List<Map<String,String>> lstPerfiles,String Campo){
        List<user> lstUser = [SELECT Id, Name, userName, Profile.Name, UserRole.name FROM user WHERE Id = :idUsuario];
        if(lstPerfiles!=null){
            for(Map<String,String> sglMap:lstPerfiles){
                if(sglMap.get(Campo)==lstUser[0].userName || sglMap.get(Campo)==lstUser[0].Profile.Name){
                    return true;
                }
            }
        }
        return false;
    }
}