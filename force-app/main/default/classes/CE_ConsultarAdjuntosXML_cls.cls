/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase para el armado del XML para la consulta de archivos adjuntos asociados a una
actividad de seguimiento en Remedy
Clase test: CE_ConsultarAdjuntosXML_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     18/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_ConsultarAdjuntosXML_cls {

    //Excepción personalizada
    public class ConsultarAdjuntosXMLException extends Exception{}
    
    /**
     * @description método para crear la estructura general del XML
     * @param idActividad id de la actividad de seguimiento en Remedy
     * @return String XML asociado al Request del servicio web
     */
    public static String crearXMLConsultaAdjuntos(String idActividad){
        //Se hace el llenado del map con la información necesaria para los valores de los parámetros del XML
        Map<String, String> getAttachmentMap = new Map<String, String>();
        getAttachmentMap.put('ActivityID', idActividad);
        String correlationIdString = idActividad + String.valueOf(Datetime.now().gettime()) + UserInfo.getUserId() + 'CONSULTA_ADJUNTO';
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
        armarParametrosConsultaAdjuntos(xmlETA, parametrosCreacion, getAttachmentMap);
        return xmlETA.toXmlString();
    }
    
    /**
     * @description método para la adición de los parámetros de consulta de archivos adjuntos al XML del 
     *              Request
     * @param xmlETA DOM.Document encargado de la estructuración del XML
     * @param parametrosCreacion nodo del XML que contendrá los parámetros a ser añadidos en el método
     * @param getAttachmentMap mapa con los valores a ser asignados a los parámetros del XML
     */
    public static void armarParametrosConsultaAdjuntos(DOM.Document xmlETA, dom.XmlNode parametrosCreacion, Map<String, String> getAttachmentMap) {
        Integer contadorParametros = 1;
        /*Se crea un nodo de atributo para el XML por cada uno de los valores obtenidos desde la metadata de los 
        parámetros para la consulta de los archivos adjuntos*/
        for(CE_RemedyGetAttachmentParameter__mdt getAttachmentParameter : [SELECT CE_Attribute__c, CE_DataType__c, CE_DefaultValue__c, 
                                                               CE_ObligatoryField__c, MasterLabel
                                                               FROM CE_RemedyGetAttachmentParameter__mdt]){ 
            String nombreParametro = '';
            if (contadorParametros == 1){
                nombreParametro = 'ParametroCreacion';    
            } else {
                nombreParametro = 'ParametroCreacion' + contadorParametros;
            }
            dom.XmlNode parametroCreacion = parametrosCreacion.addChildElement(nombreParametro, Label.CE_Cre1, 'cre1');
            dom.XmlNode atributo = parametroCreacion.addChildElement('Atributo', Label.CE_Cre1, 'cre1').addTextNode(getAttachmentParameter.CE_Attribute__c);
            dom.XmlNode tipoDato = parametroCreacion.addChildElement('TipoDato', Label.CE_Cre1, 'cre1').addTextNode(getAttachmentParameter.CE_DataType__c);
            String valorPorDefecto = (getAttachmentParameter.CE_DefaultValue__c!=null) ? (getAttachmentParameter.CE_DefaultValue__c) : ('');                                                                 
            dom.XmlNode valor = parametroCreacion.addChildElement('Valor', Label.CE_Cre1, 'cre1').addTextNode((getAttachmentMap.get(getAttachmentParameter.CE_Attribute__c))!=null ? getAttachmentMap.get(getAttachmentParameter.CE_Attribute__c) : (valorPorDefecto));
            if(valor.getText() == '')
            {
                if(getAttachmentParameter.CE_ObligatoryField__c)
                {
                    throw new ConsultarAdjuntosXMLException('Información obligatoria faltante: ' + getAttachmentParameter.MasterLabel);
                }
            }
            contadorParametros++;
        }        
    }
}