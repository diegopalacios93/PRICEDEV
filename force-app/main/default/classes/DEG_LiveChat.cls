/**
 * @description       : 
 * @author            : Harlinsson Chavarro (HCH)
 * @group             : 
 * @last modified on  : 03-19-2021
 * @last modified by  : Pablo Arrieta
 * Modifications Log 
 * Ver   Date         Author                      Modification
 * 1.0   03-02-2021   Harlinsson Chavarro (HCH)   Initial Version
**/
global without sharing  class DEG_LiveChat {


    @AuraEnabled
    global static WrapperLinksClass  getHyperLinksDetail(String currentIdDeployment) {
        WrapperLinksClass wrapLink = new WrapperLinksClass();
        Map<String, DEG_ConfigGenerales__mdt> mapEd = DEG_ConfigGenerales__mdt.getAll();
        String enlace = mapEd.get('DEG_ConfigGeneral').DEG_Condiciones__c;
        System.debug('enlace' + enlace);

//       SC_Live_Chat_HyperLinks__c scLiveChatGetHyperlink;
        List<LiveChatDeployment> lCDList = [
                SELECT  Id,
                        DeveloperName
                FROM    LiveChatDeployment
               WHERE   Id = :Id.valueOf(currentIdDeployment)
                LIMIT   1
        ];
        String lCD = (!lCDList.isEmpty() ? lCDList[0].DeveloperName : '');
        system.debug('currentIdDeployment' + currentIdDeployment);
        system.debug('lCD' + lCD);
        // if (String.isNotBlank(lCD)) {
//            scLiveChatGetHyperlink = SC_Live_Chat_HyperLinks__c.getValues(lCD);
        // }
        //scLiveChatGetHyperlink = SC_Live_Chat_HyperLinks__c.getValues('Product_GTL_Glucerna');
        

        wrapLink.linkTermConditions = enlace;
        /*
            (scLiveChatGetHyperlink != null ? scLiveChatGetHyperlink.Link_Privacy_Policy__c : '')
       );
        system.debug('linkTermConditions' + wrapLink.linkTermConditions);
        system.debug('linkPrivacyPolicy' + wrapLink.linkPrivacyPolicy);
        //return currentIdDeployment;
        //*/
        return wrapLink;

    }

    @AuraEnabled
    public static List<WprPicklist> getPicklistsValue(String objectAPIName){

        List<WprPicklist> fieldPickList = new List<WprPicklist>();
        Schema.DescribeFieldResult fieldResult = Contact.DEG_Tipo_de_Documento__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            WprPicklist value = new WprPicklist(pickListVal.getLabel(), pickListVal.getValue());
            fieldPickList.add(value);
        }     
        return fieldPickList;
    }

    global class WprPicklist {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public String value {get;set;}

        public WprPicklist(string label, string value) {
            this.label = label;
            this.value = value;
        }
    }

    global class WrapperLinksClass {
        @AuraEnabled
        public String linkTermConditions;
        public WrapperLinksClass() {
            this.linkTermConditions = '';
        }
    }
}