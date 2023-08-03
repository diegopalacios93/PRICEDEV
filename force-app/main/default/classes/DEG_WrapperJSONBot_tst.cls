@isTest
private class DEG_WrapperJSONBot_tst {

    @isTest
    static void TestMeta() {
        
        DEG_WrapperJSONBot_cls.meta meta = new DEG_WrapperJSONBot_cls.meta();

        Test.startTest();
        meta.success = 'TSuccess';
        meta.status = 'TStatus';
        meta.message = 'TMessage';
        Test.stopTest();
        
    }

    @isTest
    static void TestCalendarDays() {
        
        DEG_WrapperJSONBot_cls.calendarDays calendarDays = new DEG_WrapperJSONBot_cls.calendarDays();

        Test.startTest();
        calendarDays.fecha = 'TFecha';
        Test.stopTest();
        
    }

    @isTest
    static void TestRptaMessage() {
        
        DEG_WrapperJSONBot_cls.calendarDays[] calendarDays = new DEG_WrapperJSONBot_cls.calendarDays[]{};
        DEG_WrapperJSONBot_cls.rptaMessage rptaMessage = new DEG_WrapperJSONBot_cls.rptaMessage();

        Test.startTest();
        rptaMessage.response_type = 'TResponseType';
        rptaMessage.text = 'TText';
        rptaMessage.dias_permitidos = calendarDays;
        rptaMessage.typing = 'TTyping';
        rptaMessage.id = 'TId';
        rptaMessage.url = 'TUrl';
        rptaMessage.dias = 'TDias';
        Test.stopTest();
        
    }

    @isTest
    static void TestRespMessage() {
        
        DEG_WrapperJSONBot_cls.calendarDays[] calendarDays = new DEG_WrapperJSONBot_cls.calendarDays[]{};
        DEG_WrapperJSONBot_cls.rptaMessage rptaMessage = new DEG_WrapperJSONBot_cls.rptaMessage();
        DEG_WrapperJSONBot_cls.rptaMessage[] lstRptaMessage = new DEG_WrapperJSONBot_cls.rptaMessage[]{};
        DEG_WrapperJSONBot_cls.respMessage respMessage = new DEG_WrapperJSONBot_cls.respMessage();

        rptaMessage.response_type = 'TResponseType';
        rptaMessage.text = 'TText';
        rptaMessage.dias_permitidos = calendarDays;
        rptaMessage.typing = 'TTyping';
        rptaMessage.id = 'TId';
        rptaMessage.url = 'TUrl';
        rptaMessage.dias = 'TDias';

        lstRptaMessage.add(rptaMessage);
        
        Test.startTest();
        respMessage.messages = lstRptaMessage;
        Test.stopTest();
        
    }

    @isTest
    static void TestResponseMessage() {
        
        DEG_WrapperJSONBot_cls.calendarDays[] calendarDays = new DEG_WrapperJSONBot_cls.calendarDays[]{};
        DEG_WrapperJSONBot_cls.rptaMessage rptaMessage = new DEG_WrapperJSONBot_cls.rptaMessage();
        DEG_WrapperJSONBot_cls.rptaMessage[] lstRptaMessage = new DEG_WrapperJSONBot_cls.rptaMessage[]{};
        DEG_WrapperJSONBot_cls.respMessage respMessage = new DEG_WrapperJSONBot_cls.respMessage();
        DEG_WrapperJSONBot_cls.responseMessage responseMessage = new DEG_WrapperJSONBot_cls.responseMessage();
        DEG_WrapperJSONBot_cls.meta meta = new DEG_WrapperJSONBot_cls.meta();

        meta.success = 'TSuccess';
        meta.status = 'TStatus';
        meta.message = 'TMessage';

        rptaMessage.response_type = 'TResponseType';
        rptaMessage.text = 'TText';
        rptaMessage.dias_permitidos = calendarDays;
        rptaMessage.typing = 'TTyping';
        rptaMessage.id = 'TId';
        rptaMessage.url = 'TUrl';
        rptaMessage.dias = 'TDias';

        lstRptaMessage.add(rptaMessage);
        
        respMessage.messages = lstRptaMessage;

        Test.startTest();
        responseMessage.data = respMessage;
        responseMessage.meta = meta;
        Test.stopTest();
        
    }

    @isTest
    static void TestResponseMeta() {
        
        DEG_WrapperJSONBot_cls.responseMeta responseMeta = new DEG_WrapperJSONBot_cls.responseMeta();

        Test.startTest();
        responseMeta.success = 'TSuccess';
        responseMeta.status = 'TStatus';
        responseMeta.message = 'TMessage';
        Test.stopTest();
        
    }

    @isTest
    static void TestRptaSessionId() {
        
        DEG_WrapperJSONBot_cls.rptaSessionId rptaSessionId = new DEG_WrapperJSONBot_cls.rptaSessionId();

        Test.startTest();
        rptaSessionId.session_id = 'TSession_id';
        rptaSessionId.session_date = 'TSession_date';
        rptaSessionId.session_expires = 'TSession_expires';
        rptaSessionId.session_status = 'TSession_status';
        Test.stopTest();
        
    }

    @isTest
    static void TestResponseSessionId() {
        
        DEG_WrapperJSONBot_cls.responseSessionId responseSessionId = new DEG_WrapperJSONBot_cls.responseSessionId();
        DEG_WrapperJSONBot_cls.rptaSessionId rptaSessionId = new DEG_WrapperJSONBot_cls.rptaSessionId();
        DEG_WrapperJSONBot_cls.responseMeta responseMeta = new DEG_WrapperJSONBot_cls.responseMeta();

        responseMeta.success = 'TSuccess';
        responseMeta.status = 'TStatus';
        responseMeta.message = 'TMessage';

        rptaSessionId.session_id = 'TSession_id';
        rptaSessionId.session_date = 'TSession_date';
        rptaSessionId.session_expires = 'TSession_expires';
        rptaSessionId.session_status = 'TSession_status';

        Test.startTest();
        responseSessionId.data = rptaSessionId;
        responseSessionId.meta = responseMeta;
        Test.stopTest();
        
    }

    @isTest
    static void TestResponseLogin() {
        
        DEG_WrapperJSONBot_cls.responseLogin responseLogin = new DEG_WrapperJSONBot_cls.responseLogin();

        Test.startTest();
        responseLogin.user = 'TUser';
        responseLogin.token = 'TToken';
        responseLogin.expiration = 'TExpiration';
        Test.stopTest();
        
    }

    @isTest
    static void TestRptaLogin() {
        
        DEG_WrapperJSONBot_cls.responseLogin responseLogin = new DEG_WrapperJSONBot_cls.responseLogin();
        DEG_WrapperJSONBot_cls.responseLogin[] lstResponseLogin = new DEG_WrapperJSONBot_cls.responseLogin[]{};
        DEG_WrapperJSONBot_cls.rptaLogin rptaLogin = new DEG_WrapperJSONBot_cls.rptaLogin();
        DEG_WrapperJSONBot_cls.meta meta = new DEG_WrapperJSONBot_cls.meta();

        meta.success = 'TSuccess';
        meta.status = 'TStatus';
        meta.message = 'TMessage';

        responseLogin.user = 'TUser';
        responseLogin.token = 'TToken';
        responseLogin.expiration = 'TExpiration';

        lstResponseLogin.add(responseLogin);

        Test.startTest();
        rptaLogin.data = lstResponseLogin;
        rptaLogin.responseCodes= meta;
        Test.stopTest();
        
    }

}