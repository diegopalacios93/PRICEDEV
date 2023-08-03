@isTest
private class IntegracionCollections_tst {
    public static LTE_TramitesSuspenda__c tramiteSuspenda;
    
    static testMethod void WS_Test1_ActualizarServicios(){
        GeneraData_cls.generarData();
		CuentaFacturacion__c cf = [Select Name From CuentaFacturacion__c LIMIT 1];
        
        tramiteSuspenda = new LTE_TramitesSuspenda__c();
        tramiteSuspenda.Name = 'Suspensión, Pago';
        tramiteSuspenda.LTE_Estado__c = 'Suspendido';
        tramiteSuspenda.LTE_Causal__c = 'Pago';
        insert tramiteSuspenda;
        
        tramiteSuspenda = new LTE_TramitesSuspenda__c();
        tramiteSuspenda.Name = 'Suspensión';
        tramiteSuspenda.LTE_Estado__c = 'Suspendido';
        tramiteSuspenda.LTE_Causal__c = 'Pago';
        insert tramiteSuspenda;
        
        Test.startTest();
        list<IntegracionCollections_ws.MsgKeys> Keys = new list<IntegracionCollections_ws.MsgKeys>();
        IntegracionCollections_ws.MsgKeys sglKey = new IntegracionCollections_ws.MsgKeys();        
        sglKey.NumeroDeCuenta=cf.Name;
        Keys.add(sglKey.clone());
        
        IntegracionCollections_ws.msgCuentasFact lstCuentasFact = new IntegracionCollections_ws.msgCuentasFact();
        lstCuentasFact.Keys = Keys;
        
        IntegracionCollections_ws.MsgEntrada mensajeEntrada = new IntegracionCollections_ws.MsgEntrada();        
        mensajeEntrada.lstCuentasFact = lstCuentasFact;
        mensajeEntrada.accion = '';        
        IntegracionCollections_ws.WSActualizarServicios(mensajeEntrada);
        
        mensajeEntrada.accion = 'Default';        
        IntegracionCollections_ws.WSActualizarServicios(mensajeEntrada);
        
        mensajeEntrada.accion = 'Suspensión';        
        IntegracionCollections_ws.WSActualizarServicios(mensajeEntrada); 
        
        mensajeEntrada.accion = 'Suspensión, Pago';        
        IntegracionCollections_ws.WSActualizarServicios(mensajeEntrada);        
              
        list<IntegracionCollections_ws.MsgKeys> Keys2 = new list<IntegracionCollections_ws.MsgKeys>();
        IntegracionCollections_ws.MsgKeys sglKey2 = new IntegracionCollections_ws.MsgKeys();        
        sglKey2.NumeroDeCuenta='';                
        Keys2.add(sglKey2.clone());
		
        IntegracionCollections_ws.msgCuentasFact lstCuentasFact2 = new IntegracionCollections_ws.msgCuentasFact();                    
        lstCuentasFact2.Keys = Keys2;
        mensajeEntrada.lstCuentasFact = lstCuentasFact2;
        mensajeEntrada.accion = 'Suspensión, Pago';        
        IntegracionCollections_ws.WSActualizarServicios(mensajeEntrada);
        
        Test.stopTest();
    }    
}