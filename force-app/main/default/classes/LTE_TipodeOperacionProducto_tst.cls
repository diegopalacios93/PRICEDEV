@isTest
private class LTE_TipodeOperacionProducto_tst {

    static testMethod void myUnitTest() {
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeInsert');
        BanderasEjecucion.setEjecucion('OperacionComercialisBeforeUpdate');
        BanderasEjecucion.setEjecucion('OperacionComercialisAfterUpdate');

        LTE_Aprovisionamiento_tst.variablesTest.put('oc.Estado__c','Equipo entregado');
        LTE_Aprovisionamiento_tst.variablesTest.put('esAprovisionamiento','si');

        LTE_Aprovisionamiento_tst.crearData();
        
        LTE_TipodeOperacionProducto.Reconexion toppR=new LTE_TipodeOperacionProducto.Reconexion();
        toppR.sa=(list<LTE_Servicios_adicionales__c>)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_Servicios_adicionales');
        toppR.detOferta=(LTE_DetalleOferta__c)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_DetalleOferta')[0];
        toppR.saActivo=toppR.sa;
        toppR.procesar();
        
        LTE_TipodeOperacionProducto.Renovacion toppRen=new LTE_TipodeOperacionProducto.Renovacion();
        toppRen.sa=(list<LTE_Servicios_adicionales__c>)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_Servicios_adicionales');
        toppRen.detOferta=(LTE_DetalleOferta__c)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_DetalleOferta')[0];
        toppRen.oc=(OperacionComercial__c)LTE_Aprovisionamiento_tst.variablesObj.get('OperacionComercial')[0];
        toppRen.oc.LTE_TipoTransaccion__c='Equipo más SIM';
        toppRen.saActivo=toppRen.sa;
        toppRen.procesar();
        
        LTE_TipodeOperacionProducto.Reposicion toppRep=new LTE_TipodeOperacionProducto.Reposicion();
        toppRep.sa=(list<LTE_Servicios_adicionales__c>)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_Servicios_adicionales');
        toppRep.detOferta=(LTE_DetalleOferta__c)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_DetalleOferta')[0];
        toppRep.oc=(OperacionComercial__c)LTE_Aprovisionamiento_tst.variablesObj.get('OperacionComercial')[0];
        toppRep.oc.LTE_TipoTransaccion__c='Equipo más SIM';
        toppRep.saActivo=toppRen.sa;
        toppRep.procesar();
        
        LTE_TipodeOperacionProducto.Suspension toppSus=new LTE_TipodeOperacionProducto.Suspension();
        toppSus.sa=(list<LTE_Servicios_adicionales__c>)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_Servicios_adicionales');
        toppSus.detOferta=(LTE_DetalleOferta__c)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_DetalleOferta')[0];
        toppSus.oc=(OperacionComercial__c)LTE_Aprovisionamiento_tst.variablesObj.get('OperacionComercial')[0];
        toppSus.oc.LTE_TipoTransaccion__c='Equipo más SIM';
        toppSus.saActivo=toppRen.sa;
        toppSus.procesar();
        
        
	    LTE_TipodeOperacionProducto.Retiro toppRet=new LTE_TipodeOperacionProducto.Retiro();
        toppRet.sa=(list<LTE_Servicios_adicionales__c>)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_Servicios_adicionales');
        toppRet.detOferta=(LTE_DetalleOferta__c)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_DetalleOferta')[0];
        toppRet.oc=(OperacionComercial__c)LTE_Aprovisionamiento_tst.variablesObj.get('OperacionComercial')[0];
        toppRet.oc.LTE_TipoTransaccion__c='Equipo más SIM';
        toppRet.saActivo=toppRet.sa;
        toppRet.procesar();
        
       	LTE_TipodeOperacionProducto.Venta toppVen=new LTE_TipodeOperacionProducto.Venta();
        toppVen.sa=(list<LTE_Servicios_adicionales__c>)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_Servicios_adicionales');
        toppVen.detOferta=(LTE_DetalleOferta__c)LTE_Aprovisionamiento_tst.variablesObj.get('LTE_DetalleOferta')[0];
        toppVen.oc=(OperacionComercial__c)LTE_Aprovisionamiento_tst.variablesObj.get('OperacionComercial')[0];
        toppVen.oc.LTE_TipoTransaccion__c='Equipo más SIM';
        toppVen.saActivo=toppVen.sa;
        toppVen.procesar();
        
        LTE_Tramites_cls.Step step =new LTE_Tramites_cls.Step();
        step.procesar();
         
        
    }
}