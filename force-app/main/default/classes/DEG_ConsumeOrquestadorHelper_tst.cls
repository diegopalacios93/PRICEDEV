@istest
public class DEG_ConsumeOrquestadorHelper_tst {

    @TestSetup
	static void makeData(){
        LiveChatButton liveChatButton = [SELECT Id, DeveloperName
										 FROM LiveChatButton
										 WHERE DeveloperName = 'DEG_ETBServicioClienteMasivo'
										 LIMIT 1];

		LiveChatVisitor liveChatVisitor = new LiveChatVisitor();
		insert liveChatVisitor;

		LiveChatTranscript chat = new LiveChatTranscript(LiveChatVisitorId = liveChatVisitor.Id , LiveChatButtonId = liveChatButton.Id);
		insert chat;
		Cache.Org.put('tokenWatson','TOKENRESPONSE');
    }
    
    @isTest
    static void testCancel() {
        DEG_ConsumeOrquestadorHelper_cls.wrpAnalize objAnalize = new DEG_ConsumeOrquestadorHelper_cls.wrpAnalize();
        DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage = new DEG_WrapperJSONBot_cls.responseMessage();
        String rptBody = '{"data":{"messages":[{"response_type":"text","text":"pregunta 2"},{"time":1500,"typing":true,"response_type":"pause"},{"response_type":"text","text":"((botones seleccion:respuesta 0;respuesta 1;respuesta 2;respuesta 3;respuesta 4;)){card:true} "},{"response_type":"event","closeIframe":true}],"watson_session_id":"7aea4ffc-9558-415f-a7f3-effd6cfe39cc","client_session_id":"Etb 5702f0000006XKRAA2"},"meta":{"success":true,"status":200,"message":"Successful execution"}}';
    	bodyRptaMessage = DEG_ConsumeOrquestadorAsync_ws.getDeserializeBody(rptbody,bodyRptaMessage);
        Test.startTest();
        objAnalize = DEG_ConsumeOrquestadorHelper_cls.manageDeserealizeBody(bodyRptaMessage, '',  '', '');
        Test.stopTest();
    }   
    @isTest
    static void testmethod2() {
        DEG_ConsumeOrquestadorHelper_cls.wrpAnalize objAnalize = new DEG_ConsumeOrquestadorHelper_cls.wrpAnalize();
        DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage = new DEG_WrapperJSONBot_cls.responseMessage();
        String rptBody = '{"data":{"messages":[{"response_type":"text","text":"Iniciaré con la revisión de tu servicio 👨‍🔧"},{"response_type":"text","text":"Perfecto!!  iniciaré con la validación de tu servicio👨‍🔧👩‍🔧"},{"time":2000,"typing":true,"response_type":"pause"},{"response_type":"text","text":"Esto puede tardar unos minutos ⏱, te pido me des un momento para realizar las validaciones\ncorrespondientes y poder continuar con nuestra conversación."},{"time":2000,"typing":true,"response_type":"pause"},{"time":7000,"typing":true,"response_type":"pause"},{"response_type":"text","text":"PasoAgente_Falla_en_ServicioWeb_validateaccess"},{"response_type":"event","id":"asesor","url":"https://asistencia.webv2.allus.com.co/WebAPI802/ChatETB/AdvancedChat/HtmlChatPanel.jsp?origen=Chat&idBot=Etb 5702f0000006XQFAA2&nombre=sinlisim leon&tipo=CC&documento=99103409&correo=fredy.gonzalez@tivit.com.qa&asunto=HogaresMoviles&uen=Hogares y MiPymes&fasep=Identificación necesidad&estado=Activo&motivoc=Consulta Agenda&segmento=fijo&tecnologia=FTTH&PhoneNumber=3057000430&motivopsa=PasoAgente_Falla_en_ServicioWeb_validateaccess"}],"watson_session_id":"6592a0d3-34a4-4df2-9067-94487d2d38b0","client_session_id":"Etb 5702f0000006XQFAA2"},"meta":{"success":true,"status":200,"message":"Successful execution"}}';
    	bodyRptaMessage = DEG_ConsumeOrquestadorAsync_ws.getDeserializeBody(rptbody,bodyRptaMessage);
        Test.startTest();
        objAnalize = DEG_ConsumeOrquestadorHelper_cls.manageDeserealizeBody(bodyRptaMessage, '',  '', '');
        Test.stopTest();
    }  
    @isTest
    static void testmethod3() {
        DEG_ConsumeOrquestadorHelper_cls.wrpAnalize objAnalize = new DEG_ConsumeOrquestadorHelper_cls.wrpAnalize();
        DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage = new DEG_WrapperJSONBot_cls.responseMessage();
        String rptBody = '{"data":{"messages":[{"response_type":"text","text":"La dirección del nuevo predio es:'+ 
            'KR 8 12B 83 OF 308 &#124;&#124; ¿Es correcta?((botones seleccion: Confirmar dirección; Modificar dirección)){card:true}"},{"response_type":"event","closeIframe":true}],"watson_session_id":"e15a919b-d2f5-4ae5-98bd-a15ba2e333f6","client_session_id":"Etb 5702f0000006XYnAAM"},"meta":{"success":true,"status":200,"message":"Successful execution"}}';
    	bodyRptaMessage = DEG_ConsumeOrquestadorAsync_ws.getDeserializeBody(rptbody,bodyRptaMessage);
        Test.startTest();
        objAnalize = DEG_ConsumeOrquestadorHelper_cls.manageDeserealizeBody(bodyRptaMessage, '',  '', '');
        Test.stopTest();
    } 
    
    @isTest
    static void testmethod4() {
        DEG_ConsumeOrquestadorHelper_cls.wrpAnalize objAnalize = new DEG_ConsumeOrquestadorHelper_cls.wrpAnalize();
        DEG_WrapperJSONBot_cls.responseMessage bodyRptaMessage = new DEG_WrapperJSONBot_cls.responseMessage();
        String rptBody = '{"data":{"messages":[{"response_type":"text","text":"pregunta 2"},{"time":1500,"typing":true,"response_type":"pause"},{"response_type":"text","text":"((botones seleccion:respuesta 0;respuesta 1;respuesta 2;respuesta 3;respuesta 4;)){card:true} "},{"response_type":"event","closeIframe":true},{"response_type":"text","sintaxisFueradeHorario":"FueradeHorario"}],"watson_session_id":"7aea4ffc-9558-415f-a7f3-effd6cfe39cc","client_session_id":"Etb 5702f0000006XKRAA2"},"meta":{"success":true,"status":200,"message":"Successful execution"}}';
    	bodyRptaMessage = DEG_ConsumeOrquestadorAsync_ws.getDeserializeBody(rptbody,bodyRptaMessage);
        Test.startTest();
        objAnalize = DEG_ConsumeOrquestadorHelper_cls.manageDeserealizeBody(bodyRptaMessage, '',  '', '');
        Test.stopTest();
    }

    @isTest
    static void testImg(){
        String url= 'https://etb-bot.us-south.cf.appdomain.cloud/etb/api/de/message-request';
        String sTexto ='https//:www.google.com/Screenshot.jpg';
        DEG_ConsumeOrquestadorHelper_cls.WrpImage img = new DEG_ConsumeOrquestadorHelper_cls.WrpImage(sTexto,url);
        DEG_ConsumeOrquestadorHelper_cls.WrpImage img2 = new DEG_ConsumeOrquestadorHelper_cls.WrpImage();
        Test.startTest();

        Test.stopTest();
    }


    @isTest
    static void wrpBtn(){
        DEG_ConsumeOrquestadorHelper_cls.WrapBoton btn = new DEG_ConsumeOrquestadorHelper_cls.WrapBoton();
        Test.startTest();

        Test.stopTest();
    }

    @isTest
    static void testWrpBtnEnlace(){
        String url= 'https://etb-bot.us-south.cf.appdomain.cloud/etb/api/de/message-request';
        String sTexto ='https://test-etb-page.web.app/appLuz2.html';
        DEG_ConsumeOrquestadorHelper_cls.WrpBtnEnlace enlc = new DEG_ConsumeOrquestadorHelper_cls.WrpBtnEnlace(sTexto,url);
        DEG_ConsumeOrquestadorHelper_cls.WrpBtnEnlace enlc2 = new DEG_ConsumeOrquestadorHelper_cls.WrpBtnEnlace();
        Test.startTest();

        Test.stopTest();
    }

    @isTest
    static void testWrapVideo(){
        String url= 'https://etb-bot.us-south.cf.appdomain.cloud/etb/api/de/message-request';
        String sTexto ='https//:www.google.com/testVideo.mp4';
        DEG_ConsumeOrquestadorHelper_cls.WrapVideo vid = new DEG_ConsumeOrquestadorHelper_cls.WrapVideo(sTexto,url);
        DEG_ConsumeOrquestadorHelper_cls.WrapVideo vid2 = new DEG_ConsumeOrquestadorHelper_cls.WrapVideo();
        Test.startTest();

        Test.stopTest();

    }

    @isTest
    static void testWrapMensaje(){
        String sOrden='99';
        String idEvent='null';
        DEG_ConsumeOrquestadorHelper_cls.WrapMensaje vid = new DEG_ConsumeOrquestadorHelper_cls.WrapMensaje(sOrden,idEvent);
        Test.startTest();
        
        Test.stopTest();
    }

    @isTest
    static void testWrapMensajeCalendar(){
        String sOrden='101';
        String idEvent='null';
        String days = 'null';
        List<String> datesLst = new List<String>();
        DEG_ConsumeOrquestadorHelper_cls.WrapMensaje msj = new DEG_ConsumeOrquestadorHelper_cls.WrapMensaje(sOrden, idEvent, days, datesLst);
        Test.startTest();
        
        Test.stopTest();
    }


    @isTest
    static void testMsj1(){
        String sOrden = '99';
        List<String> lMensaje = new List<String>();
        String sTipo = 'video';
        DEG_ConsumeOrquestadorHelper_cls.WrapMensaje msj = new DEG_ConsumeOrquestadorHelper_cls.WrapMensaje(sOrden,lMensaje,sTipo);
        Test.startTest();
        
        Test.stopTest();
    }

    @isTest
    static void testMsj2(){
        String sOrden = '99';
        List<String> lMensaje = new List<String>{'image','video','text'};
        String sTipo = 'btnLink';
        DEG_ConsumeOrquestadorHelper_cls.WrapMensaje msj = new DEG_ConsumeOrquestadorHelper_cls.WrapMensaje(sOrden,lMensaje,sTipo);
        Test.startTest();  
        
        Test.stopTest();
    }

    
    @isTest
    static void testMsj3(){
        String sOrden = '99';
        List<String> lMensaje = new List<String>();
        String sTipo = 'image';
        DEG_ConsumeOrquestadorHelper_cls.WrapMensaje msj = new DEG_ConsumeOrquestadorHelper_cls.WrapMensaje(sOrden,lMensaje,sTipo);
        Test.startTest();
        
        Test.stopTest();
    }

    @isTest
    static void testGetSplitText(){
        String charStart='etb';
        String CharEnd =' ';
        String text='etb_exponer ';
        Integer pos=0;
        String remove='_';
        Test.startTest(); 
        List<String> splitText = DEG_ConsumeOrquestadorHelper_cls.getSplitText(charStart,CharEnd,text,pos,remove); 
        Test.stopTest();
    }
//----------------------------------------------------------------------------------------------*/
    @isTest
    static void testgetImage(){
        String sText='":":,"sintaxisImage":"sintaxisImage":,"sintaxisCardTrue":"sintaxisCardTrue":,"))":"))":,"text":"((botones seleccion:respuesta 0;respuesta 1;respuesta 2;respuesta 3;respuesta 4;))';
        List<String> lMensaje = new List<String>{'image','video','text'};
        String sintaxisImage = 'sintaxisImage';
        String sintaxisCardTrue = 'sintaxisCardTrue';
        Integer cont = 1;
        String sOrden='99';
        String sTipo='msn';            
        Test.startTest();   
        List<DEG_ConsumeOrquestadorHelper_cls.WrapMensaje> listWrapMensaje = DEG_ConsumeOrquestadorHelper_cls.getImage(sText,new List<DEG_ConsumeOrquestadorHelper_cls.WrapMensaje>(),sintaxisImage,sintaxisCardTrue,cont);
        Test.stopTest();
        System.assertNotEquals(0, listWrapMensaje.size());
        
    }

    @isTest
    static void testgetBtnEnlace(){
        String sText='"((,boton enlace:True","url:"www.youtube.com":"sintaxisCardTrue","))":"))","text":"((botones seleccion:respuesta 0,respuesta 1,respuesta 2,respuesta 3,respuesta 4,))';
        List<String> lMensaje = new List<String>{'image','video','text'};
        String sintaxisBtnEnlace = 'sintaxisBtnEnlace';
        String sintaxisCardTrue = 'sintaxisCardTrue';
        Integer cont = 3;
        String sOrden='99';
        String sTipo='btnLink';        
        DEG_ConsumeOrquestadorHelper_cls.WrapMensaje messageLst= new DEG_ConsumeOrquestadorHelper_cls.WrapMensaje(sOrden,lMensaje,sTipo);
        DEG_ConsumeOrquestadorHelper_cls.WrapMensaje messageLst1= new DEG_ConsumeOrquestadorHelper_cls.WrapMensaje(sOrden,lMensaje,sTipo);
        DEG_ConsumeOrquestadorHelper_cls.WrapMensaje messageLst2= new DEG_ConsumeOrquestadorHelper_cls.WrapMensaje(sOrden,lMensaje,sTipo);
        Test.startTest();
        List<DEG_ConsumeOrquestadorHelper_cls.WrapMensaje> listWrapMensaje = DEG_ConsumeOrquestadorHelper_cls.getBtnEnlace(sText,new List<DEG_ConsumeOrquestadorHelper_cls.WrapMensaje>{messageLst,messageLst1,messageLst2},sintaxisBtnEnlace,sintaxisCardTrue, cont);
        Test.stopTest();
        System.assertNotEquals(0, listWrapMensaje.size());
    }

    @isTest
    static void testgetsintaxisVideo(){
        String sText='":":,"sintaxisVideo":"sintaxisVideo","sintaxisCardTrue":"sintaxisCardTrue":,"))"))":,"text":"((botones seleccion:respuesta 0;respuesta 1;respuesta 2;respuesta 3;respuesta 4;))';
        List<String> lMensaje = new List<String>{'image','video','text'};
        String sintaxisVideo = 'sintaxisVideo';
        String sintaxisCardTrue = 'sintaxisCardTrue';
        Integer cont = 0;
        String sOrden='99';
        String sTipo='msn';  
        Test.startTest();   
       	List<DEG_ConsumeOrquestadorHelper_cls.WrapMensaje> listWrapMensaje= DEG_ConsumeOrquestadorHelper_cls.getVideo(sText,new List<DEG_ConsumeOrquestadorHelper_cls.WrapMensaje>(),sintaxisVideo,sintaxisCardTrue, cont);
        Test.stopTest();
		System.assertNotEquals(0, listWrapMensaje.size());
    }

    private static List<DEG_ConsumeOrquestadorAsync_ws.Input> botConfiguration(){
		List<DEG_ConsumeOrquestadorAsync_ws.Input> orquestInLst = new List<DEG_ConsumeOrquestadorAsync_ws.Input>();
		orquestInLst.add(new DEG_ConsumeOrquestadorAsync_ws.Input());
        orquestInLst[0].sessionId = '';
		orquestInLst[0].textClient = '';
		orquestInLst[0].conversationId = [SELECT ID FROM LiveChatTranscript LIMIT 1].Id;
		orquestInLst[0].canalBot = 'Web';
		return orquestInLst;
	} 

    @isTest
    static void testInfoGen1(){
        String segmento='Masivo';
        String celular = '6012903300';
        String tecnologia = 'FTTH';
        DEG_ConsumeOrquestadorHelper_cls.InfoGeneral inGeneral = new DEG_ConsumeOrquestadorHelper_cls.InfoGeneral(segmento,tecnologia);
        Test.startTest();
        inGeneral.Segmento=segmento;
        inGeneral.Telefono=celular;
        inGeneral.Tecnologia=tecnologia;
        DEG_ConsumeOrquestadorHelper_cls.General gen = new DEG_ConsumeOrquestadorHelper_cls.General();
        gen.InfoGeneral = inGeneral;
        Test.stopTest();
    }
    
	@istest
	static void testInfoGeneral(){
		DEG_ConsumeOrquestadorAsyncWhatsApp_mck mock = new DEG_ConsumeOrquestadorAsyncWhatsApp_mck('infogeneral');
		
		List<DEG_ConsumeOrquestadorAsync_ws.Input> orquestInLst = botConfiguration();
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, mock);
		DEG_ConsumeOrquestadorAsync_ws.makeGetCallout(orquestInLst);
		Test.stopTest();	
	}

    
}