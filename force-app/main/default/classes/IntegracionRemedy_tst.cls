/***********************************************************************************************************************
Desarrollado por:   ETB
Autor:              John Guevara 
Proyecto:           ETB Portafolio Superior fase II
Descripción:        Clase de prueba para las clases: IntegracionRemedy_ws

Cambios (Versiones)
-------------------------------------
No.     Fecha           Autor                       Descripción
----    ----------      --------------------        ---------------
1.0     2019-12-01      John Guevara (JG)		    Creación de la clase.
***********************************************************************************************************************/

@isTest
private class IntegracionRemedy_tst {

    static testMethod void WSInsertarObjetoTest() 
    {
		GeneraData_cls.generarData();
        Test.startTest();
        list<IntegracionRemedy_ws.MsgKeys> Keys = new list<IntegracionRemedy_ws.MsgKeys>();
        IntegracionRemedy_ws.MsgKeys sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Id_Sistema_Legado__c';
        sglkey.Valor='Remedy001';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='NumeroDocumento';
        sglkey.Valor='240324';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='ID_Servicio';
        sglkey.Valor='CAIP000001';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN1__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN2__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN3__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN4__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN5__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='SolucionSistemaLegado__c';
        sglkey.Valor='Remedy';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Pertinencia_Horas__c';
        sglkey.Valor='0';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Pertinencia_Minutos__c';
        sglkey.Valor='0';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Pertinencia_Segundos__c';
        sglkey.Valor='0';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Codigo_Cierre__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='EstadoSistemaLegado__c';
        sglkey.Valor='POR CONFIRMAR';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Responsable_Legado__c';
        sglkey.Valor='ETB';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='SubResponsable_Legado__c';
        sglkey.Valor='INFRAESTRUCTURA';
        Keys.add(sglKey.clone());
        IntegracionRemedy_ws.msgParameters lstParametros = new IntegracionRemedy_ws.msgParameters();
        lstParametros.Keys = Keys;
        
        list<IntegracionRemedy_ws.MsgKeys> RKeys = new list<IntegracionRemedy_ws.MsgKeys>();
        IntegracionRemedy_ws.MsgKeys sglRKey = new IntegracionRemedy_ws.MsgKeys();
        sglRKey.Campo='CommentBody';
        sglRKey.Valor='Texto Nota Relacionada';
        RKeys.add(sglRKey);
        
        list<IntegracionRemedy_ws.MsgKeys> RKeysTask = new list<IntegracionRemedy_ws.MsgKeys>();
        IntegracionRemedy_ws.MsgKeys sglRKeyTask = new IntegracionRemedy_ws.MsgKeys();
        sglRKeyTask.Campo='Subject';
        sglRKeyTask.Valor='Texto Nota Relacionada';
        RKeysTask.add(sglRKeyTask);
        
        IntegracionRemedy_ws.msgParameters lstRParametros = new IntegracionRemedy_ws.msgParameters();
        lstRParametros.Keys = RKeys;
        
        IntegracionRemedy_ws.msgParameters lstRParametrosTask = new IntegracionRemedy_ws.msgParameters();
        lstRParametrosTask.Keys = RKeysTask;
        
        IntegracionRemedy_ws.ObjetoHijoRelacionado sglRObjeto = new IntegracionRemedy_ws.ObjetoHijoRelacionado();
        sglRObjeto.NombreRelacion='CaseComments';
        sglRObjeto.lstParametros = lstRParametros;
        
        IntegracionRemedy_ws.ObjetoHijoRelacionado sglRObjetoTask = new IntegracionRemedy_ws.ObjetoHijoRelacionado();
        sglRObjetoTask.NombreRelacion='Tasks';
        sglRObjetoTask.lstParametros = lstRParametrosTask;
        List<IntegracionRemedy_ws.ObjetoHijoRelacionado> ObjetosHijosRelacionados = new List<IntegracionRemedy_ws.ObjetoHijoRelacionado>();
        ObjetosHijosRelacionados.add(sglRObjeto);
        ObjetosHijosRelacionados.add(sglRObjetoTask);
        IntegracionRemedy_ws.msgObjetosHijosRelacionados lstObjetosHijosRelacionados = new IntegracionRemedy_ws.msgObjetosHijosRelacionados();
        lstObjetosHijosRelacionados.ObjetosHijosRelacionados = ObjetosHijosRelacionados;
        
        IntegracionRemedy_ws.MsgEntrada mensajeEntrada = new IntegracionRemedy_ws.MsgEntrada();
        //mensajeEntrada.Id = GeneraData_cls.caso2.Id;
        mensajeEntrada.NombreObjeto = 'Case';
        mensajeEntrada.lstParametros = lstParametros;
        mensajeEntrada.lstObjetosHijosRelacionados = lstObjetosHijosRelacionados;
        IntegracionRemedy_ws.WSActualizarObjeto(mensajeEntrada);
        
        Test.stopTest();
    }

    static testMethod void WSActualizarObjetoTest() 
    {
		GeneraData_cls.generarData();
        Test.startTest();
        list<IntegracionRemedy_ws.MsgKeys> Keys = new list<IntegracionRemedy_ws.MsgKeys>();
        IntegracionRemedy_ws.MsgKeys sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Id_Sistema_Legado__c';
        sglkey.Valor='Remedy001';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='NumeroDocumento';
        sglkey.Valor='240324';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='ID_Servicio';
        sglkey.Valor='CAIP000001';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN1__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN2__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN3__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN4__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='CategoriaResolucionN5__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='SolucionSistemaLegado__c';
        sglkey.Valor='Remedy';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Pertinencia_Horas__c';
        sglkey.Valor='0';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Pertinencia_Minutos__c';
        sglkey.Valor='0';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Pertinencia_Segundos__c';
        sglkey.Valor='0';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Codigo_Cierre__c';
        sglkey.Valor='CATRES01';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='EstadoSistemaLegado__c';
        sglkey.Valor='POR CONFIRMAR';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Responsable_Legado__c';
        sglkey.Valor='ETB';
        Keys.add(sglKey.clone());
        
        sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='SubResponsable_Legado__c';
        sglkey.Valor='INFRAESTRUCTURA';
        Keys.add(sglKey.clone());
        IntegracionRemedy_ws.msgParameters lstParametros = new IntegracionRemedy_ws.msgParameters();
        lstParametros.Keys = Keys;
        
        list<IntegracionRemedy_ws.MsgKeys> RKeys = new list<IntegracionRemedy_ws.MsgKeys>();
        IntegracionRemedy_ws.MsgKeys sglRKey = new IntegracionRemedy_ws.MsgKeys();
        sglRKey.Campo='CommentBody';
        sglRKey.Valor='Texto Nota Relacionada';
        RKeys.add(sglRKey);
        
        list<IntegracionRemedy_ws.MsgKeys> RKeysTask = new list<IntegracionRemedy_ws.MsgKeys>();
        IntegracionRemedy_ws.MsgKeys sglRKeyTask = new IntegracionRemedy_ws.MsgKeys();
        sglRKeyTask.Campo='Subject';
        sglRKeyTask.Valor='Texto Nota Relacionada';
        RKeysTask.add(sglRKeyTask);
        
        IntegracionRemedy_ws.msgParameters lstRParametros = new IntegracionRemedy_ws.msgParameters();
        lstRParametros.Keys = RKeys;
        
        IntegracionRemedy_ws.msgParameters lstRParametrosTask = new IntegracionRemedy_ws.msgParameters();
        lstRParametrosTask.Keys = RKeysTask;
        
        IntegracionRemedy_ws.ObjetoHijoRelacionado sglRObjeto = new IntegracionRemedy_ws.ObjetoHijoRelacionado();
        sglRObjeto.NombreRelacion='CaseComments';
        sglRObjeto.lstParametros = lstRParametros;
        
        IntegracionRemedy_ws.ObjetoHijoRelacionado sglRObjetoTask = new IntegracionRemedy_ws.ObjetoHijoRelacionado();
        sglRObjetoTask.NombreRelacion='Tasks';
        sglRObjetoTask.lstParametros = lstRParametrosTask;
        List<IntegracionRemedy_ws.ObjetoHijoRelacionado> ObjetosHijosRelacionados = new List<IntegracionRemedy_ws.ObjetoHijoRelacionado>();
        ObjetosHijosRelacionados.add(sglRObjeto);
        ObjetosHijosRelacionados.add(sglRObjetoTask);
        IntegracionRemedy_ws.msgObjetosHijosRelacionados lstObjetosHijosRelacionados = new IntegracionRemedy_ws.msgObjetosHijosRelacionados();
        lstObjetosHijosRelacionados.ObjetosHijosRelacionados = ObjetosHijosRelacionados;
        
        IntegracionRemedy_ws.MsgEntrada mensajeEntrada = new IntegracionRemedy_ws.MsgEntrada();
        mensajeEntrada.Id = GeneraData_cls.caso2.Id;
        mensajeEntrada.NombreObjeto = 'Case';
        mensajeEntrada.lstParametros = lstParametros;
        mensajeEntrada.lstObjetosHijosRelacionados = lstObjetosHijosRelacionados;
        IntegracionRemedy_ws.WSActualizarObjeto(mensajeEntrada);
        
        Test.stopTest();
    }
    
    static testMethod void WsConsultaListaTest() 
    {
		GeneraData_cls.generarData();
        
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos_WsConsultaLista_Case',Mensaje__c='Id,CaseNumber,LTE_Servicio__r.Name'));
        insert vg;
        
        Test.startTest();
        list<IntegracionRemedy_ws.MsgKeys> Keys = new list<IntegracionRemedy_ws.MsgKeys>();
        IntegracionRemedy_ws.MsgKeys sglKey = new IntegracionRemedy_ws.MsgKeys();
        sglKey.Campo='Condicion';
        sglkey.Valor='Id = \''+String.valueOf(GeneraData_cls.caso2.Id)+'\'';
        Keys.add(sglKey);
        
        IntegracionRemedy_ws.msgParameters lstParametros = new IntegracionRemedy_ws.msgParameters();
        lstParametros.Keys = Keys;
        
        IntegracionRemedy_ws.MsgEntrada mensajeEntrada = new IntegracionRemedy_ws.MsgEntrada();
        mensajeEntrada.NombreObjeto = 'Case';
        mensajeEntrada.lstParametros = lstParametros;
        IntegracionRemedy_ws.WsConsultaLista(mensajeEntrada);
        
        Test.stopTest();
    }
    
    static testMethod void WsConsultaDetalleTest() 
    {
		GeneraData_cls.generarData();
        
        list<sobject> vg=new list<sobject>();
        vg.add(new Mensaje_Integracion__c(Name='Campos_WsConsultaDetalle_Case',Mensaje__c='Id,CaseNumber,LTE_Servicio__r.Name'));
        vg.add(new Mensaje_Integracion__c(Name='Case_CaseComments',Mensaje__c='Id,CommentBody'));
        vg.add(new CaseComment(CommentBody ='Nota Texto',ParentId =GeneraData_cls.caso2.Id));
        insert vg;
        
        Test.startTest();
        
        IntegracionRemedy_ws.ObjetoHijoRelacionado sglRObjeto = new IntegracionRemedy_ws.ObjetoHijoRelacionado();
        sglRObjeto.NombreRelacion='CaseComments';
        List<IntegracionRemedy_ws.ObjetoHijoRelacionado> ObjetosHijosRelacionados = new List<IntegracionRemedy_ws.ObjetoHijoRelacionado>();
        ObjetosHijosRelacionados.add(sglRObjeto);
        IntegracionRemedy_ws.msgObjetosHijosRelacionados lstObjetosHijosRelacionados = new IntegracionRemedy_ws.msgObjetosHijosRelacionados();
        lstObjetosHijosRelacionados.ObjetosHijosRelacionados = ObjetosHijosRelacionados;
        
        IntegracionRemedy_ws.MsgEntrada mensajeEntrada = new IntegracionRemedy_ws.MsgEntrada();
        mensajeEntrada.Id = GeneraData_cls.caso2.Id;
        mensajeEntrada.NombreObjeto = 'Case';
        mensajeEntrada.lstObjetosHijosRelacionados = lstObjetosHijosRelacionados;
        IntegracionRemedy_ws.WsConsultaDetalle(mensajeEntrada);
        
        Test.stopTest();
    }
    
    static testMethod void CreacionCasotgr() 
    {
		GeneraData_cls.generarData();
        Case oCaso = GeneraData_cls.caso2;
        oCaso.Plan__c = null;
        update oCaso;
        Test.startTest();
        oCaso.Plan__c = GeneraData_cls.objPlan3.Id;
        update oCaso;
        Test.stopTest();
    }
}