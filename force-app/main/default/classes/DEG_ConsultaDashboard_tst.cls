/**************************************************************************************************
Desarrollado por: Accenture
Autores: Juan Camilo Villegas, Raúl Andrés Gómez Ramírez
Proyecto: ETB Digital Engagement
Descripción: Clase test para las clase DEG_ConsultaDashboard_cls

Cambios (Versiones)
---------------------------------------------------------------------------------------------------
No.     Fecha           Autores                        						 Descripción
1.0     03/03/2022      Juan Camilo Villegas, Raúl Andrés Gómez Ramírez      Creación
***************************************************************************************************/
@isTest
private class DEG_ConsultaDashboard_tst {
    
    /**
     * @description inserción de registros de prueba para los métodos test
     */
    @testSetup 
    static void setup() 
    {
        Id idCola = [SELECT ID FROM GROUP WHERE Type='Queue' AND DeveloperName='DEG_SoporteTecnicoChat'].id;
        LiveChatButton boton = [SELECT Id FROM LiveChatButton WHERE DeveloperName ='DEG_ETBAppMobile' LIMIT 1];
        LiveChatVisitor visitante = new LiveChatVisitor();
        insert visitante;
        LiveChatTranscript transcripcion = new LiveChatTranscript();
        transcripcion.LiveChatVisitorId = visitante.id;
        transcripcion.LiveChatButtonId = boton.Id;
        transcripcion.DEG_IdCola__c = idCola;
        insert transcripcion;
    }
    
	/**
     * @description prueba de obtención de la cola exitosamente
     */
    @isTest 
    static void getQueueSuccessfulTest() 
    {
        Test.startTest();
        LiveChatTranscript chat = [SELECT ID FROM LiveChatTranscript LIMIT 1];
        DEG_ConsultaDashboard_cls.InputInfo inputData = new DEG_ConsultaDashboard_cls.InputInfo();
        inputData.idChat = chat.Id;
        List<DEG_ConsultaDashboard_cls.OutputInfo> outputData = new List<DEG_ConsultaDashboard_cls.OutputInfo>();
        try{
            outputData = DEG_ConsultaDashboard_cls.getQueue(new List<DEG_ConsultaDashboard_cls.InputInfo>{inputData});
        } catch (Exception exc) {
            System.debug(exc);
        }
        System.assert(outputData.get(0).consultaExitosa);
        Test.stopTest();
    }
    
    /**
     * @description prueba de obtención de la cola fallida
     */
    @isTest 
    static void getQueueSOQLExceptionTest() 
    {
        Test.startTest();
        LiveChatTranscript chat = [SELECT ID FROM LiveChatTranscript LIMIT 1];
        DEG_ConsultaDashboard_cls.InputInfo inputData = new DEG_ConsultaDashboard_cls.InputInfo();
        inputData.idChat = chat.Id;
        delete chat;
        List<DEG_ConsultaDashboard_cls.OutputInfo> outputData = new List<DEG_ConsultaDashboard_cls.OutputInfo>();
        try{
            outputData = DEG_ConsultaDashboard_cls.getQueue(new List<DEG_ConsultaDashboard_cls.InputInfo>{inputData});
        } catch (Exception exc) {
            System.debug(exc);
        }
        System.assert(!outputData.get(0).consultaExitosa);
        Test.stopTest();
    }
}