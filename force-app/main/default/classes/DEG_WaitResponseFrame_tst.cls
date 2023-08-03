/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 06-25-2021
 * @last modified by  : Harlinsson Chavarro (HCH)
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   06-25-2021   Harlinsson Chavarro (HCH)   Initial Version
**/

@isTest
public class DEG_WaitResponseFrame_tst {
    @isTest
	static void testWaitResponse(){
        DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo WhatsAppInfo = new DEG_ConsumeOrquestadorDBWhatsApp_cls.WhatsAppInfo();
        DEG_WaitResponseFrame_cls.Input entrada= new DEG_WaitResponseFrame_cls.Input();
        List<DEG_WaitResponseFrame_cls.Input> entradas= new List<DEG_WaitResponseFrame_cls.Input>();
        entrada.whatsAppInfo = JSON.serialize(WhatsAppInfo);
        entradas.add(entrada);
        List<DEG_WaitResponseFrame_cls.Output> salidas= new List<DEG_WaitResponseFrame_cls.Output>();
        Test.startTest();
        salidas = DEG_WaitResponseFrame_cls.doWaiting(entradas);
		Test.stopTest();
    }
}