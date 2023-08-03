/**************************************************************************************************
Desarrollado por: Accenture
Autores: Raúl Andrés Gómez Ramírez 
Proyecto: ETB DE Experiencia        
Descripción: Clase para la creación de las actividades de seguimiento asociadas a una tarea de agendamiento en Remedy
Clase test: CE_GestionActividadesRemedy_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     28/12/2021      Raúl Andrés Gómez Ramírez   
***************************************************************************************************/
public with sharing class CE_GestionActividadesRemedy_cls {
    
    //Nombre de la configuración del servicio web
    public static final String SERVICE_NAME ='Remedy_CreateScheduleOP_PS';
    
    //Excepción personalizada
    public class GestionActividadesRemedyException extends Exception{}
    
    //Parámetros necesarios para la creación de una actividad de seguimiento en Remedy
    public class ParametrosActividad{
        //Id tarea asociada al agendamiento
        @InvocableVariable
        public String taskId;
        
        //Id del caso asociado al agendamiento
        @InvocableVariable
        public String caseId;
        
        //Estado de la tarea de agendamiento asociada a la actividad de seguimiento
        @InvocableVariable
        public String estadoActividad;
        
        //Subestado de la tarea de agendamiento asociada a la actividad de seguimiento
        @InvocableVariable
        public String subEstado;
        
        //Resumen de la actividad de seguimiento
        @InvocableVariable
        public String resumen;
        
        //Usuario en Salesforce que realiza la creación de la actividad de seguimiento
        @InvocableVariable
        public String usuario;
    }
    
    //Valores de respuesta para la creación de una actividad de seguimiento en Remedy
    public class ResultadoActividad{
        //Confirmación de éxito del servicio web
        @InvocableVariable
        public Boolean operacionExitosa;
        
        //Mensaje de resultado del servicio web
        @InvocableVariable
        public String mensajeOperacion;
    }
    
    /**
    * @description método utilizado para la creación de una actividad de seguimiento asociada a una tarea
    			   de agendamiento
    * @param parametrosActividad parámetros asociados a la actividad de seguimiento a ser creada en Remedy
    * @return List<ResultadoActividad> mensaje resultante de la integración
    */
    @InvocableMethod(label='Crear Actividad' description='Crea una actividad de seguimiento en Remedy.' category='Agenda')
    public static List<ResultadoActividad> crearActividadRemedy(List<ParametrosActividad> parametrosActividad){
        ResultadoActividad resultadoActividad = new ResultadoActividad();
        resultadoActividad.operacionExitosa = false;
        if(String.isBlank(parametrosActividad[0].taskId))
        {
            resultadoActividad.mensajeOperacion = 'No es posible realizar la creación de la actividad de seguimiento por no contar con un Id Tarea asociado';
            return new List<ResultadoActividad>{resultadoActividad};
        }
        Map<String, String> newActivityResult = new Map<String, String>();
        ServiciosWeb__c objServiciosWeb = new ServiciosWeb__c();
        try
        {
            //Se obtiene la configuración del servicio web
            objServiciosWeb  = [SELECT Id, Name, Action__c, EndPoint__c FROM ServiciosWeb__c  WHERE Name =: SERVICE_NAME LIMIT 1];
        } catch (System.QueryException queryException)
        {
            resultadoActividad.mensajeOperacion = 'No hay configuración asociada para el servicio web';
            return new List<ResultadoActividad>{resultadoActividad};
        }
        string requestXML = '';
        string response = '';
        try{
            //Se realiza la generación del XML para el Request
        	requestXML = CE_GestionActividadesXML_cls.crearXMLCrearActividad(parametrosActividad[0]);
        	//Se realiza el llamado al servicio web usando el XML del Request previamente obtenido y la configuración del servicio web
        	response = CE_UtilityWS_cls.consultarServicio(requestXML, objServiciosWeb.Action__c, objServiciosWeb.EndPoint__c , parametrosActividad[0].caseId); 
        }catch(Exception exc){
            resultadoActividad.mensajeOperacion = exc.getMessage();
            return new List<ResultadoActividad>{resultadoActividad};
        }
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        //Se obtiene la información de cada uno de los nodos del Response en forma de un Map<String, String>
        newActivityResult.putAll(proReq.getMap(response));
        if(!newActivityResult.get('Codigo').startsWithIgnoreCase('F')){
            resultadoActividad.operacionExitosa = true;
            resultadoActividad.mensajeOperacion = Label.CE_ActividadCreadaExitosa;
            return new List<ResultadoActividad>{resultadoActividad};
        }else{
            resultadoActividad.mensajeOperacion = newActivityResult.get('DetalleEstado');
            return new List<ResultadoActividad>{resultadoActividad};
        }
    }
}