/**************************************************************************************************
Desarrollado por: Accenture
Autores: Juan Camilo Villegas, Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase para la consulta del ID de la cola a la cual deberá ser enviada la conversación por el bot
Clase test: DEG_ConsultaDashboard_tst

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        							Descripción
1.0     03/03/2022      Juan Camilo Villegas, Raúl Andrés Gómez Ramírez         Creación
***************************************************************************************************/
public with sharing class DEG_ConsultaDashboard_cls {

    //Wrapper con la estructura de la información que se recibe desde el bot
    public class InputInfo {
        //String correspondiente al ID del chat que está procesando el bot
        @InvocableVariable(required=true)
        public String idChat;
    }
    
    //Wrapper con la estructura de la información que se enviará al bot
    public class OutputInfo {
        //String correspondiente al ID de la cola a la que el bot deberá transferir el chat
        @InvocableVariable(required=true)
        public String idCola;
        
        //Boolean con el resultado de si la operación de obtención de la cola fue exitosa o no
        @InvocableVariable(required=true)
        public Boolean consultaExitosa;
    }
    
    /**
    * @description método utilizado para la obtención de la cola para devolver al bot
    * @param inputData información recibida desde el bot con el id de la conversación del usuario
    * @return OutputInfo información a ser enviada al bot con la cola a la cual transferir al usuario
    */
    @InvocableMethod(label = 'Obtener ID Cola')
    public static List<OutputInfo> getQueue(List<InputInfo> inputData) {
        OutputInfo outputData = new OutputInfo();
        LiveChatTranscript chat = new LiveChatTranscript();
        /*Se valida si se consigue el chat asociado al Routable Id del bot y si este chat tiene asociado algún id cola
		al cual deberá ser transferido por el bot*/
        try
        {
            chat = [SELECT ID, DEG_IdCola__c FROM LiveChatTranscript 
                    WHERE ID=:inputData.get(0).idChat LIMIT 1];
        } catch (System.QueryException queryException)
        {
            outputData.consultaExitosa = false;
        }
        if(String.isBlank(chat.DEG_IdCola__c)){
            outputData.consultaExitosa = false;
        } else {
            outputData.idCola = chat.DEG_IdCola__c;
            outputData.consultaExitosa = true;
        }
        return new List<OutputInfo>{outputData};
    }
}