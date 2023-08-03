@isTest
private class DEG_LiveChat_tst {

    @isTest
    static void testGetHyperLinksDetail() {
        List<LiveChatDeployment> lCDList = [
                SELECT  Id,
                        DeveloperName
                FROM    LiveChatDeployment
                LIMIT   1
        ];

        Test.startTest();
        DEG_LiveChat.WrapperLinksClass Wrapperls = DEG_LiveChat.getHyperLinksDetail(Id.valueOf(lCDList[0].id));
        Test.stopTest();

        System.assert(Wrapperls.linkTermConditions != null);
    }

    @isTest
    static void testGetPicklistsValue() {

        Test.startTest();
        DEG_LiveChat.WprPicklist[] fieldPickList = DEG_LiveChat.getPicklistsValue('test');
        Test.stopTest();

        System.assert(fieldPickList != null);
    }
    
}