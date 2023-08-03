public with sharing class deg_downloadData_ctr {

    @AuraEnabled(cacheable=true)
   public static List<sobject> getData( list<string> listid,string objName,string fields,boolean whitwhe) {
      
       String query='' ;
       system.debug('query---'+query);
       System.debug(listid);
       System.debug(fields);
       if ( objName != null && objName != '' &&  fields != null && fields != ''&& whitwhe) {
           /*String key = '%' ;
           System.debug(fields);
           query+= ' SELECT ';
           query+=fields;
           query +=' from ';*/
           query +=objName;
           query += ' AND id IN :listid';
       }
       if (!whitwhe) {
        query=objName;
       }
       System.debug(query);
       return Database.query( query );
   }
}