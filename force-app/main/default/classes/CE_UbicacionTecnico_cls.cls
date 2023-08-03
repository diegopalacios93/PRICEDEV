/**************************************************************************************************
Desarrollado por: Accenture
Autores: Luis Oviedo 
Proyecto: ETB DE Experiencia        
Descripción: Clase para el envío de información de agenda obtenida de flujos guiados para hacer uso de un
servicio web que nos devuelve la ubicación real del técnico.
Clase test: CE_UbicacionTecnico_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                                         Descripción
1.0     xx/xx/xxxx      Luis Oviedo   
***************************************************************************************************/
public with sharing class CE_UbicacionTecnico_cls {

    //Excepción personalizada
    public class UbicacionTecnicoException extends Exception{}


    public class ParametrosEntrada{
        //Id de la agenda (numero de orden)
        @InvocableVariable
        public String IdIncidente;

        //Id del caso asociado al agendamiento
        @InvocableVariable
        public String caseId;
        
        //EndPoint asociado al servicio web
        @InvocableVariable
        public String endPointWS;
        
        //Action asociado al servicio web
        @InvocableVariable
        public String actionWS;
    }
    
    //Valores de respuesta 
    public class ParametrosRespuesta{
        //Confirmación de éxito del servicio web
        @InvocableVariable
        public String URL;

        //Confirmación de éxito del servicio web
        @InvocableVariable
        public Boolean operacionExitosa;

        //Mensaje de resultado del servicio web
        @InvocableVariable
        public String mensajeOperacion;
    }
    
    @InvocableMethod(label='Consultar Ubicacion Tecnico' description='Retorna la URL que contiene la ubicacion del tecnico.' category='Agenda')
    public static List<ParametrosRespuesta> consultarUbicacionTecnico(List<ParametrosEntrada> ParametrosEntrada){
        ParametrosRespuesta parametrosRespuesta = new ParametrosRespuesta();
        parametrosRespuesta.operacionExitosa = false;
        Map<String, String> result = new Map<String, String>();
        string requestXML = '';
        String response = '';

        try{
            
            //Se realiza la generación del XML para el Request
        	requestXML = CE_UbicacionTecnicoXML_cls.crearXMLUbicacionTecnico(ParametrosEntrada[0].IdIncidente);
            //Se realiza el llamado al servicio web usando el XML del Request previamente obtenido y la configuración del servicio web
        	response = CE_UtilityWS_cls.consultarServicio(requestXML, ParametrosEntrada[0].actionWS, ParametrosEntrada[0].endPointWS , ParametrosEntrada[0].caseId);
            
            system.debug('RQ '+requestXML);
            system.debug('RP '+response);
        }catch(Exception exc){
            parametrosRespuesta.mensajeOperacion = exc.getMessage();
            return new List<ParametrosRespuesta>{parametrosRespuesta};
        }
        tibcoXml_cls.xmlMap proReq = new tibcoXml_cls.xmlMap();
        //Se obtiene la información de cada uno de los nodos del Response en forma de un Map<String, String>
        result.putAll(proReq.getMap(response));
        if(!result.get('Codigo').startsWithIgnoreCase('F')){
            if(result.get('SoportesIngreso') == null){
                ParametrosRespuesta.mensajeOperacion = Label.CE_Sin_URL;
                ParametrosRespuesta.operacionExitosa = false;
                return new List<ParametrosRespuesta>{parametrosRespuesta};
            }else{
                //Se asigna la información obtenida en el response a los atributos del resultado del cierre
                ParametrosRespuesta.URL = result.get('SoportesIngreso').remove('"');
                ParametrosRespuesta.mensajeOperacion = result.get('DetalleEstado');
                ParametrosRespuesta.operacionExitosa = true;
                return new List<ParametrosRespuesta>{parametrosRespuesta};
            }
        }
        else{
            ParametrosRespuesta.mensajeOperacion = result.get('DetalleEstado');
            return new List<ParametrosRespuesta>{parametrosRespuesta};
        }
    }  
}