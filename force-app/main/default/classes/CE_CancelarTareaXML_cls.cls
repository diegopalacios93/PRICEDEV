/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase para el armado del XML para la cancelación de una tarea de agendamiento
Clase test: CE_CancelarTareaXML_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     04/01/2022      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_CancelarTareaXML_cls {
    
    //Excepción personalizada
    public class CancelarTareaXMLException extends Exception{}
    
    /**
     * @description método para crear la estructura general del XML
     * @param parametrosActividad parámetros necesarios para la cancelación de una tarea de agendamiento
     * @return String XML asociado al Request del servicio web
     */
    public static String crearXMLCancelarTarea(CE_CancelarTarea_cls.ParametrosCancelacion parametrosCancelacion){
        //Se hace el llenado del map con la información necesaria para los valores de los parámetros del XML
        Map<String, String> taskCancellationMap = new Map<String, String>();
        taskCancellationMap.put('activityId', parametrosCancelacion.scheduleId);
        taskCancellationMap.put('XA_Status', parametrosCancelacion.estadoAgendamiento);
        taskCancellationMap.put('XA_motivo_cancelar', parametrosCancelacion.motivoCancelacion);
        taskCancellationMap.put('XA_Solucion_cancelar', parametrosCancelacion.notas);
        String correlationIdString = parametrosCancelacion.scheduleId + String.valueOf(Datetime.now().gettime()) + UserInfo.getUserId() + 'CANCELAR_AGENDA';
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
        armarParametrosCancelarTarea(xmlETA, parametrosCreacion, taskCancellationMap);
        return xmlETA.toXmlString();
    }
    
    /**
     * @description método para la adición de los parámetros de cancelación de una tarea de agendamiento al XML del 
     				Request
     * @param xmlETA DOM.Document encargado de la estructuración del XML
     * @param parametrosCreacion nodo del XML que contendrá los parámetros a ser añadidos en el método
     * @param taskCancellationMap mapa con los valores a ser asignados a los parámetros del XML
     */
    public static void armarParametrosCancelarTarea(DOM.Document xmlETA, dom.XmlNode parametrosCreacion, Map<String, String> taskCancellationMap) {
		Integer contadorParametros = 1;
        /*Se crea un nodo de atributo para el XML por cada uno de los valores obtenidos desde la metadata de los parámetros para 
        la cancelación de una tarea de agendamiento*/
        for(CE_RemedyCancelTaskParameter__mdt cancelTaskParameter : [SELECT CE_Attribute__c, CE_DataType__c, 
                                                                     CE_DefaultValue__c, CE_ObligatoryField__c, 
                                                                     MasterLabel
                                                                     FROM CE_RemedyCancelTaskParameter__mdt]){
			String nombreParametro = '';
            if (contadorParametros == 1){
                nombreParametro = 'ParametroCreacion';    
            } else {
                nombreParametro = 'ParametroCreacion' + contadorParametros;
            }
            dom.XmlNode parametroCreacion = parametrosCreacion.addChildElement(nombreParametro, Label.CE_Cre1, 'cre1');
            dom.XmlNode atributo = parametroCreacion.addChildElement('Atributo', Label.CE_Cre1, 'cre1').addTextNode(cancelTaskParameter.CE_Attribute__c);
            dom.XmlNode tipoDato = parametroCreacion.addChildElement('TipoDato', Label.CE_Cre1, 'cre1').addTextNode(cancelTaskParameter.CE_DataType__c);
			String valorPorDefecto = (cancelTaskParameter.CE_DefaultValue__c!=null) ? (cancelTaskParameter.CE_DefaultValue__c) : ('');                                                                 
            dom.XmlNode valor = parametroCreacion.addChildElement('Valor', Label.CE_Cre1, 'cre1').addTextNode((taskCancellationMap.get(cancelTaskParameter.CE_Attribute__c))!=null ? taskCancellationMap.get(cancelTaskParameter.CE_Attribute__c) : (valorPorDefecto));
            if(valor.getText() == '')
            {
                if(cancelTaskParameter.CE_ObligatoryField__c)
                {
                    throw new CancelarTareaXMLException('Información obligatoria faltante: ' + cancelTaskParameter.MasterLabel);
                }
            }
			contadorParametros++;
        }        
    }
}