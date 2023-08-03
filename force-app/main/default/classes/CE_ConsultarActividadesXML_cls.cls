/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase para el armado del XML para la consulta de actividades de seguimiento asociadas a una
tarea de agendamiento en Remedy
Clase test: CE_ConsultarActividadesXML_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     07/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_ConsultarActividadesXML_cls {
    
    //Excepción personalizada
    public class ConsultarActividadesXMLException extends Exception{}
    
    /**
     * @description método para crear la estructura general del XML
     * @param idTarea id de la tarea de agendamiento en Remedy
     * @return String XML asociado al Request del servicio web
     */
    public static String crearXMLConsultaActividades(String idTarea){
        //Se hace el llenado del map con la información necesaria para los valores de los parámetros del XML
        Map<String, String> getActivityMap = new Map<String, String>();
        getActivityMap.put('TaskID', idTarea);
        String correlationIdString = idTarea + String.valueOf(Datetime.now().gettime()) + UserInfo.getUserId() + 'CONSULTA_ACTIVIDAD';
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
        armarParametrosConsultaActividades(xmlETA, parametrosCreacion, getActivityMap);
        return xmlETA.toXmlString();
    }
    
    /**
     * @description método para la adición de los parámetros de consulta de actividades de seguimiento al XML del 
     * 				Request
     * @param xmlETA DOM.Document encargado de la estructuración del XML
     * @param parametrosCreacion nodo del XML que contendrá los parámetros a ser añadidos en el método
     * @param getActivityMap mapa con los valores a ser asignados a los parámetros del XML
     */
    public static void armarParametrosConsultaActividades(DOM.Document xmlETA, dom.XmlNode parametrosCreacion, Map<String, String> getActivityMap) {
		Integer contadorParametros = 1;
        /*Se crea un nodo de atributo para el XML por cada uno de los valores obtenidos desde la metadata de los 
		parámetros para la consulta de las actividades de seguimiento*/
        for(CE_RemedyGetActivityParameter__mdt getActivityParameter : [SELECT CE_Attribute__c, CE_DataType__c, CE_DefaultValue__c, 
                                                               CE_ObligatoryField__c, MasterLabel
                                                               FROM CE_RemedyGetActivityParameter__mdt]){ 
			String nombreParametro = '';
            if (contadorParametros == 1){
                nombreParametro = 'ParametroCreacion';    
            } else {
                nombreParametro = 'ParametroCreacion' + contadorParametros;
            }
            dom.XmlNode parametroCreacion = parametrosCreacion.addChildElement(nombreParametro, Label.CE_Cre1, 'cre1');
            dom.XmlNode atributo = parametroCreacion.addChildElement('Atributo', Label.CE_Cre1, 'cre1').addTextNode(getActivityParameter.CE_Attribute__c);
            dom.XmlNode tipoDato = parametroCreacion.addChildElement('TipoDato', Label.CE_Cre1, 'cre1').addTextNode(getActivityParameter.CE_DataType__c);
			String valorPorDefecto = (getActivityParameter.CE_DefaultValue__c!=null) ? (getActivityParameter.CE_DefaultValue__c) : ('');                                                                 
            dom.XmlNode valor = parametroCreacion.addChildElement('Valor', Label.CE_Cre1, 'cre1').addTextNode((getActivityMap.get(getActivityParameter.CE_Attribute__c))!=null ? getActivityMap.get(getActivityParameter.CE_Attribute__c) : (valorPorDefecto));
            if(valor.getText() == '')
            {
                if(getActivityParameter.CE_ObligatoryField__c)
                {
                    throw new ConsultarActividadesXMLException('Información obligatoria faltante: ' + getActivityParameter.MasterLabel);
                }
            }
			contadorParametros++;
        }        
    }
}