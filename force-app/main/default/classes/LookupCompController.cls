public class LookupCompController {
	@AuraEnabled(cacheable=true)
    public static String search(String objectAPIName, String searchText, List<String> whereClause, List<String> extrafields) {
        objectAPIName = String.escapeSingleQuotes(objectAPIName);
        searchText = String.escapeSingleQuotes(searchText);
        
        String searchQuery = 'FIND \'' + searchText + '*\' IN ALL FIELDS RETURNING ' + objectAPIName + '(Id,Name' ;
        
        if(!extrafields.isEmpty()) {
            searchQuery = searchQuery + ',' + String.join(extrafields, ',') ;
        }
        
        if(!whereClause.isEmpty()) {
            searchQuery = searchQuery + ' WHERE ' ;
            searchQuery = searchQuery + String.join(whereClause, 'AND') ;
        }
        
        searchQuery = searchQuery + ' LIMIT 10 ) ';
        System.debug('\n\n-=#=-\n' + 'searchQuery' + ': ' + searchQuery + '\n-=#=-\n');
        
        return JSON.serializePretty(search.query(searchQuery)) ;
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecentlyViewed(String objectAPIName,List<String> selectedIds,String searchText,String field, List<String> whereClause, List<String> extrafields) {
        String searchQuery = 'SELECT Id';
        
        if(!extrafields.isEmpty()) {
            searchQuery = searchQuery + ',' + String.join(extrafields, ',') ;
        }
        
        searchQuery = searchQuery + ' FROM ' + objectAPIName;
        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
        searchQuery = searchQuery + ' WHERE  (' + field + ' LIKE ' + searchText;
        if(objectAPIName == 'PricebookEntry'){
            searchQuery = searchQuery + ' OR ProductCode LIKE ' + searchText+')';
        }else {
            searchQuery = searchQuery + ')';
        }
        if(!whereClause.isEmpty()) {
            searchQuery = searchQuery + ' AND ';
            searchQuery = searchQuery + String.join(whereClause, ' AND ') ;
        }
        if(!selectedIds.isEmpty() && selectedIds != null){
            searchQuery = searchQuery + ' AND id NOT IN '+ '(\''+String.join(selectedIds,'\',\'')+'\')';
        }
        System.debug('\n\n-=#=-\n' + 'searchQuery' + ': ' + searchQuery + '\n-=#=-\n');
        
        List<SObject> objectList;
        try {
            objectList = Database.query(searchQuery);
        } catch(Exception objException) {
            System.debug('\n\n-=#=-\n' + 'getRecentlyViewed - objException.getMessage()' + ': ' + objException.getMessage() + '\n-=#=-\n');
            objectList =  new List<SObject>();
        }
        
        return objectList;
    }
}