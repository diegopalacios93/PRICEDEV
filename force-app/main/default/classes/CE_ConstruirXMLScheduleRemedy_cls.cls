/**************************************************************************************************
Desarrollado por: Accenture
Autores: Brisleydi Calderón, Raúl Andrés Gómez Ramírez
Proyecto: ETB DE Experiencia        
Descripción: Clase para el armado del XML para la integración
Clase test: CE_ConstruirCanonicoScheduleRemedy_tst
 
Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     17/11/2021      Brisleydi Calderón, Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_ConstruirXMLScheduleRemedy_cls {
    
    //Excepción personalizada
    public class ConstruirXMLScheduleRemedyException extends Exception{}
    
    /**
     * @description método para crear la estructura general del XML
     * @param scheduleForm mapa con los valores obtenidos desde el formulario de agendamiento del LWC
     * @param caseID id del caso desde el cual se diligenció el formulario de agendamiento
     * @return String XML asociado al Request del servicio web
     */
    public static String crearXMLSchedule(Map<String, Object> scheduleForm, Id caseID){
        Id sopTecnicoRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SOPORTE_TECNICO').getRecordTypeId();
        Map<String, String> scheduleMap = new Map<String, String>();
        //Se hace la conversión de la información obtenida desde el LWC del agendamiento
        for(String keyForm : scheduleForm.keyset())
        {
            scheduleMap.put(keyForm, String.valueof(scheduleForm.get(keyForm)));
        }
        //Se verifica que el agendamiento esté en el intervalo de fechas válido
        if(Date.today() > Date.valueOf(scheduleMap.get('date')) || (Date.valueOf(scheduleMap.get('date')) > (Date.today() + 1000)))
        {
            throw new ConstruirXMLScheduleRemedyException('La fecha de visita debe estar entre las fechas ' + String.valueOf(Date.today())+ ' y ' + String.valueOf(Date.today() + 1000));
        }
        String horaSolicitudTexto = scheduleMap.get('date') + ' ' + scheduleMap.get('timeFormat');        
        Datetime horaSolicitud = Datetime.valueOfGmt(horaSolicitudTexto);
        Datetime now = Datetime.now();
        Integer offset = UserInfo.getTimezone().getOffset(now);
        Datetime local = now.addSeconds(offset/1000);
        //Se verifica que la franja  horaria no sea menor a la hora actual
        if(local > horaSolicitud){
            throw new ConstruirXMLScheduleRemedyException('La hora de visita debe ser superior a la hora actual');
        }
        Case caso = new Case();
        try
        {
            //Se obtiene el caso ligado al agendamiento a ser procesado
            caso = [SELECT Id, IDServicio__c,
                    	 Id_Sistema_Legado__c, 
                         RecordTypeId, 
                         Contact.Name, 
                         Contact.Tipodedocumento__c,
                         Contact.NumerodeIdentificacion__c, 
                         Contact.Ciudad__r.Name, 
                         Contact.MobilePhone, 
                         Contact.Direccion__c, 
                         Contact.Account.Name, 
                         Contact.Account.AccountNumber, 
                         Contact.Account.Phone,
                    	 Contact.Account.Direccion__c,
                         Contact.Account.Departamento__c,
                         Proceso__c, 
                         Tipologia__c, 
                         Esquema_de_Atencion__c, 
                         Subject, 
                         Description, 
                         CE_PrioriryETAFormula__c, 
                         Agrupacion__c,
                         CE_ProductCategoriesETA__c, 
                         CE_ServiceTypeETA__c,
                         Grupo_Aseguramiento__r.Nivel3__c
                         FROM Case 
                         WHERE Id=:caseID 
                         AND RecordTypeId=:sopTecnicoRTId
                         AND Id_Sistema_Legado__c != null];
        } catch (System.QueryException queryException)
        {
            throw new ConstruirXMLScheduleRemedyException('El caso asociado al agendamiento no es correcto');
        }
        //Se hace reemplazo de los caracteres que puedan generar errores en el XML
        String taskTitle = (caso.Subject!=null) ? (caso.Subject.replaceAll('&|<','y')) : ('');
        String taskDesc = (caso.Description!=null) ? (caso.Description.replaceAll('&|<','y')) : ('');
        
        //Se hace el llenado del map con la información necesaria para complementar el agendamiento
        scheduleMap.put('apptNumber',caso.Id_Sistema_Legado__c);
        scheduleMap.put('XA_Salesforce_Serviceid',caso.IDServicio__c);
        scheduleMap.put('XA_Contact_Name',caso.Contact.Name);
        scheduleMap.put('XA_ID_Type',caso.Contact.Tipodedocumento__c);
        scheduleMap.put('XA_ID',caso.Contact.NumerodeIdentificacion__c);
        scheduleMap.put('city',caso.Contact.Ciudad__r.Name);
        scheduleMap.put('XA_Contact_Phone',caso.Contact.MobilePhone);
        scheduleMap.put('XA_Reference',caso.Contact.Direccion__c);
        scheduleMap.put('XA_Cause',caso.Proceso__c);
        scheduleMap.put('XA_Symptom',caso.Tipologia__c);
        scheduleMap.put('XA_Esquema_Atencion',caso.Esquema_de_Atencion__c);
        scheduleMap.put('XA_Titulo_task',taskTitle);
        scheduleMap.put('XA_Descripcion_task',taskDesc);
        scheduleMap.put('XA_Prioridad',caso.CE_PrioriryETAFormula__c);
        scheduleMap.put('XA_Categoria',caso.Agrupacion__c);
        scheduleMap.put('XA_Product_Categories',caso.CE_ProductCategoriesETA__c);
        scheduleMap.put('XA_Tipo_Servicio_PS',caso.CE_ServiceTypeETA__c);
		scheduleMap.put('customerName',caso.Contact.Account.Name);
		scheduleMap.put('customerNumber',caso.Contact.Account.AccountNumber);
		scheduleMap.put('customerCell',caso.Contact.Account.Phone);
        scheduleMap.put('streetAddress',caso.Contact.Account.Direccion__c);
        scheduleMap.put('stateProvince',caso.Contact.Account.Departamento__c);
        scheduleMap.put('XA_Usuario_Remedy',UserInfo.getUserName());
        scheduleMap.put('XA_Grupo_creacion', caso.Grupo_Aseguramiento__r.Nivel3__c);
        //Se obtiene el correlation id
        String correlationIdString = caso.Id + String.valueOf(Datetime.now().gettime()) + UserInfo.getUserId();
		//Se realiza la generación del XML
        DOM.Document xmlETA = new DOM.Document();
        dom.XmlNode envelope = xmlETA.createRootElement('Envelope', Label.CE_SoapenvRemedy, 'soapenv');
        envelope.setNamespace('cre', Label.CE_CreRemedy);
        envelope.setNamespace('v1', Label.CE_V1Remedy);
        envelope.setNamespace('cre1', Label.CE_Cre1);
        dom.XmlNode header = envelope.addChildElement('Header', Label.CE_SoapenvRemedy, 'soapenv');
        dom.XmlNode body = envelope.addChildElement('Body', Label.CE_SoapenvRemedy, 'soapenv');
        dom.XmlNode createScheduleRemedyInput = body.addChildElement('CreateScheduleRemedyInput', Label.CE_CreRemedy, 'cre');
        dom.XmlNode wSRequestHeader2 = createScheduleRemedyInput.addChildElement('WSRequestHeader2', Label.CE_V1Remedy, 'v1');
        dom.XmlNode systemNode = wSRequestHeader2.addChildElement('System', Label.CE_V1Remedy, 'v1');
        dom.XmlNode nameNode = systemNode.addChildElement('name', Label.CE_V1Remedy, 'v1').addTextNode(Label.CE_SystemNameRemedy);
        dom.XmlNode correlationID = systemNode.addChildElement('correlationID', Label.CE_V1Remedy, 'v1').addTextNode(correlationIdString);
        dom.XmlNode processingServer = systemNode.addChildElement('processingServer', Label.CE_V1Remedy, 'v1').addTextNode(Label.CE_SystemProcServerRemedy);
        dom.XmlNode propertyNode = wSRequestHeader2.addChildElement('Property', Label.CE_V1Remedy, 'v1');
        dom.XmlNode nameNode2 = propertyNode.addChildElement('name', Label.CE_V1Remedy, 'v1').addTextNode(Label.CE_PropertyNameRemedy);
        dom.XmlNode valueNode = propertyNode.addChildElement('value', Label.CE_V1Remedy, 'v1').addTextNode(Label.CE_PropertyValueRemedy);
        dom.XmlNode requestNode = createScheduleRemedyInput.addChildElement('request', Label.CE_Cre1, 'cre1');
        dom.XmlNode creacionAgendaRemedy = requestNode.addChildElement('CreacionAgendaRemedy', Label.CE_Cre1, 'cre1');
        dom.XmlNode creacionObjeto = creacionAgendaRemedy.addChildElement('creacionObjeto', Label.CE_Cre1, 'cre1');
        dom.XmlNode parametrosCreacion = creacionObjeto.addChildElement('ParametrosCreacion', Label.CE_Cre1, 'cre1');

        armarParametrosCreacion(xmlETA, parametrosCreacion,scheduleMap);

        return xmlETA.toXmlString();
    }
    
    /**
     * @description método para la adición de los parámetros de creación del agendamiento al XML del Request
     * @param xmlETA DOM.Document encargado de la estructuración del XML
     * @param parametrosCreacion nodo del XML que contendrá los parámetros a ser añadidos en el método
     * @param scheduleMap mapa con los valores a ser asignados a los parámetros del XML
     */
    public static void armarParametrosCreacion(DOM.Document xmlETA, dom.XmlNode parametrosCreacion, Map<String, String> scheduleMap) {
        Integer contadorParametros = 1;
        /*Se crea un nodo de atributo para el XML por cada uno de los valores obtenidos desde la metadata de los parámetros para 
        el agendamiento*/
        for(CE_RemedyScheduleParameter__mdt remedyScheduleParameter : [SELECT CE_Atributo__c, CE_DataType__c, 
                                                                      CE_DefaultValue__c, CE_ObligatoryField__c, MasterLabel
                                                                      FROM CE_RemedyScheduleParameter__mdt]){   
            String nombreParametro = '';
            if (contadorParametros == 1){
                nombreParametro = 'ParametroCreacion';    
            } else {
                nombreParametro = 'ParametroCreacion' + contadorParametros;
            }
            dom.XmlNode parametroCreacion = parametrosCreacion.addChildElement(nombreParametro, Label.CE_Cre1, 'cre1');
            dom.XmlNode atributo = parametroCreacion.addChildElement('Atributo', Label.CE_Cre1, 'cre1').addTextNode(remedyScheduleParameter.CE_Atributo__c);
            dom.XmlNode tipoDato = parametroCreacion.addChildElement('TipoDato', Label.CE_Cre1, 'cre1').addTextNode(remedyScheduleParameter.CE_DataType__c);
			String valorPorDefecto = (remedyScheduleParameter.CE_DefaultValue__c!=null) ? (remedyScheduleParameter.CE_DefaultValue__c) : ('');                                                                 
            dom.XmlNode valor = parametroCreacion.addChildElement('Valor', Label.CE_Cre1, 'cre1').addTextNode((scheduleMap.get(remedyScheduleParameter.CE_Atributo__c))!=null ? scheduleMap.get(remedyScheduleParameter.CE_Atributo__c) : (valorPorDefecto));
            if(valor.getText() == '')
            {
                if(remedyScheduleParameter.CE_ObligatoryField__c)
                {
                    throw new ConstruirXMLScheduleRemedyException('Información obligatoria faltante: '+remedyScheduleParameter.MasterLabel);
                }
            }
            contadorParametros++;
        }
    }        
}