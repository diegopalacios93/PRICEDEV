/**************************************************************************************************
Desarrollado por: Accenture
Autores: Luis Carlos Oviedo Talaigua
Proyecto: ETB DE Experiencia        
Descripción: Clase que arma el XML request para consultar la unicación del técnico ETB
Clase test: CE_UbicacionTecnicoXML_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     22/04/2022      Luis Carlos Oviedo Talaigua   
***************************************************************************************************/
public with sharing class CE_UbicacionTecnicoXML_cls {

    //Excepción personalizada
    public class UbicacionTecnicoExceptionXMLException extends Exception{}

    /**
     * @description método para crear la estructura general del XML
     * @param IdIncidente id del incidente de agendamiento en Remedy
     * @return String XML asociado al Request del servicio web
     */

    public static String crearXMLUbicacionTecnico(String IdIncidente){

        //Se hace el llenado del map con la información necesaria para los valores de los parámetros del XML
        Map<String, String> getMapValues = new Map<String, String>();
        getMapValues.put('IncidentID', IdIncidente);

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
        dom.XmlNode correlationID = systemNode.addChildElement('correlationID', Label.CE_V1Remedy, 'v1').addTextNode(IdIncidente);
        dom.XmlNode processingServer = systemNode.addChildElement('processingServer', Label.CE_V1Remedy, 'v1').addTextNode(Label.CE_SystemProcServerRemedy);
        dom.XmlNode propertyNode = wSRequestHeader2.addChildElement('Property', Label.CE_V1Remedy, 'v1');
        dom.XmlNode nameNode2 = propertyNode.addChildElement('name', Label.CE_V1Remedy, 'v1').addTextNode(Label.CE_PropertyNameRemedy);
        dom.XmlNode valueNode = propertyNode.addChildElement('value', Label.CE_V1Remedy, 'v1').addTextNode(Label.CE_PropertyValueRemedy);
        dom.XmlNode requestNode = createScheduleRemedyInput.addChildElement('request', Label.CE_Cre1, 'cre1');
        dom.XmlNode creacionAgendaRemedy = requestNode.addChildElement('CreacionAgendaRemedy', Label.CE_Cre1, 'cre1');
        dom.XmlNode creacionObjeto = creacionAgendaRemedy.addChildElement('creacionObjeto', Label.CE_Cre1, 'cre1');
        dom.XmlNode parametrosCreacion = creacionObjeto.addChildElement('ParametrosCreacion', Label.CE_Cre1, 'cre1');

        armarParametrosConsultaUbicacionTecnico(xmlETA, parametrosCreacion, getMapValues);
        return xmlETA.toXmlString();
    }

    /**
     * @description método para la adición de los parámetros de consulta de archivos adjuntos al XML del 
     * 				Request
     * @param xmlETA DOM.Document encargado de la estructuración del XML
     * @param parametrosCreacion nodo del XML que contendrá los parámetros a ser añadidos en el método
     * @param getMapValues mapa con los valores a ser asignados a los parámetros del XML
     */
    public static void armarParametrosConsultaUbicacionTecnico(DOM.Document xmlETA, dom.XmlNode parametrosCreacion, Map<String, String> getMapValues) {
        Integer contadorParametros = 1;
        /*Se crea un nodo de atributo para el XML por cada uno de los valores obtenidos desde la metadata de los 
		parámetros para la consulta de los archivos adjuntos*/
        for(CE_RemedyTechnicianLocationParameter__mdt getParameters : [SELECT CE_Attribute__c, CE_DataType__c, CE_DefaultValue__c, 
                                                               CE_ObligatoryField__c, MasterLabel FROM CE_RemedyTechnicianLocationParameter__mdt]){
            
            String nombreParametro = '';
            if (contadorParametros == 1){
                nombreParametro = 'ParametroCreacion';    
            } else {
                nombreParametro = 'ParametroCreacion' + contadorParametros;
            }

            dom.XmlNode parametroCreacion = parametrosCreacion.addChildElement(nombreParametro, Label.CE_Cre1, 'cre1');
            dom.XmlNode atributo = parametroCreacion.addChildElement('Atributo', Label.CE_Cre1, 'cre1').addTextNode(getParameters.CE_Attribute__c);
            dom.XmlNode tipoDato = parametroCreacion.addChildElement('TipoDato', Label.CE_Cre1, 'cre1').addTextNode(getParameters.CE_DataType__c);
			String valorPorDefecto = (getParameters.CE_DefaultValue__c!=null) ? (getParameters.CE_DefaultValue__c) : ('');                                                                 
            dom.XmlNode valor = parametroCreacion.addChildElement('Valor', Label.CE_Cre1, 'cre1').addTextNode((getMapValues.get(getParameters.CE_Attribute__c))!=null ? getMapValues.get(getParameters.CE_Attribute__c) : (valorPorDefecto));
            
          	if(valor.getText() == '')
            {
                if(getParameters.CE_ObligatoryField__c)
                {
                    throw new UbicacionTecnicoExceptionXMLException('Información obligatoria faltante: ' + getParameters.MasterLabel);
                }
            }
			contadorParametros++;
        }
    }
}