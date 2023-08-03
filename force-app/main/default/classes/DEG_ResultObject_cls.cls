public without sharing class DEG_ResultObject_cls {
	public Integer status;
    public String message;
    public String id;
    private Object mresult;
    public Object result { get {return this.mresult; }}
    public Map<String,Object> mapObject;
    
    public DEG_ResultObject_cls(Integer status, String message, Object obj){
        this.status = status;
        this.message = message;
        this.mresult = obj;   

       	Map<String, Object> keys = getAttributeNames(obj);        
        this.id = keys.get('Id') != null ? keys.get('Id').toString() : null;     
    }
    
    public DEG_ResultObject_cls(Integer status, String message, List<Object> objs){
        this.status = status;
        this.message = message;
        this.mresult = objs;   
        List<String> ids = new List<String>();
        for(Object obj : objs){
            Map<String, Object> keys = getAttributeNames(obj);
            String currentid = keys.get('Id') != null ? keys.get('Id').toString() : null;
            ids.add(currentid);       	
        }
        
        this.id = JSON.serialize(ids);
    }
    
    public DEG_ResultObject_cls(Integer status, String message, String json){
        this.status = status;
        this.message = message;
        this.mresult = json;
        String datamessage = '';
        if(isJson(json)) {
            Object obj = (Object) System.JSON.deserializeUntyped(json);
            Map<String, Object> keys = getAttributeNames(obj);
            datamessage = keys.get('data') != null ? keys.get('data').toString() : null;
        }else{ datamessage = json; }
        
        Map<String, Object> vJson = new Map<String, Object>{ 'response' => datamessage };
         
        this.mapObject = vJson;
    }
    
    public DEG_ResultObject_cls(Integer status, String message){
        this.status = status;
        this.message = message;
        this.mresult = null;             	  
    }
    
    public static Map<String, Object> getAttributeNames(Object toReflect)
    {
        return (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(toReflect));
    }
 
    public Override String toString(){
        
        Map<String,String> resultString = new Map<String,String>();
        resultString.put('status', String.valueOf(this.status));
        resultString.put('message', this.message);
        
        if(this.id != null){
            resultString.put('id', this.id );
        } 
        
        return JSON.serialize(resultString);
    }
    
    public Map<String, Object> getMapresult( ){
        Map<String, Object> resultObject = new Map<String, Object>();
        resultObject.put('status', this.status);
        resultObject.put('message', this.message);
        resultObject.put('result', this.mapObject);
        return resultObject;
    }

    public Boolean isJson(String str) {
        try {
            System.JSON.deserializeUntyped(str);
        } catch (Exception e) {
            return false;
        }
        return true;
    }
}