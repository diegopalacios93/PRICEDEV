public class etb_RecordDetailGeneric {

    @AuraEnabled(cacheable=true)
    public static List<etb_RecordLayoutGeneric__mdt> getMetadata(String objectApiName) {
    
        return [SELECT Id, Section__c, Object__c, Field__c, Type__c, DisplayLabel__c, Order__c, SectionOrder__c, RelationName__c,
        RecordTypeName__c, ColumnPosition__c
        FROM etb_RecordLayoutGeneric__mdt
        WHERE Object__c =: objectApiName 
        WITH SECURITY_ENFORCED Order By SectionOrder__c ASC,Order__c ASC];
    }

    @AuraEnabled(cacheable=true)
    public static String checkAccesibleField(String objectApiName, List<String> fields){
        Map<String, Boolean> accessibleFields = new Map<String, Boolean>();
        SObjectType sObjectType = Schema.getGlobalDescribe().get(objectApiName);

        for (SObjectField field : sObjectType.getDescribe().fields.getMap().values()) {
            if (field.getDescribe().isAccessible()) {
                String fildToString = String.valueOf(field);

                if(fildToString.endsWith('__c')){
                    String fieldToStringCut = fildToString.substring(0, fildToString.length() - 3);
                    String fieldToStringCutWithRelation = fieldToStringCut + '__r';

                    if (fields.contains(fildToString)) {
                        accessibleFields.put(fildToString, true);
                    } else if (fields.contains(fieldToStringCutWithRelation)){
                        accessibleFields.put(fieldToStringCutWithRelation, true);
                    }
                } else {
                    if (fields.contains(fildToString)) {
                        accessibleFields.put(fildToString, true);
                    }
                }
            }
        }

        return JSON.serializePretty(accessibleFields);
    }

    /*private static Map<String,Map<String,Object>> buildConfig(List<DtvRecordLayoutGeneric__mdt> records){
        Map<String,Map<String,Object>> result = new Map<String,Map<String,Object>>();

        for (DtvRecordLayoutGeneric__mdt mdt: records) {
            if(!result.containsKey(mdt.Section__c)) {
                Map<String,Object> fields = new Map<String,Object>();
                for(DtvRecordLayoutGeneric__mdt mdt2: records) {
                    if(mdt2.Section__c.equals(mdt.Section__c)) {
                        fields.put(mdt2.Field__c, mdt2);
                    }
                }
                result.put(mdt.Section__c,fields);
            }            
        }

        return result;
    }*/
}