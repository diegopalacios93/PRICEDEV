/*******************************************************************************
Desarrollado por:       ETB
Autor:                  John Guevara
Proyecto:               Portafolio Superior II
Descripcion:            Clase auxiliar para el manejo de integraciones

Cambios (Versiones)
-------------------------------------
No.     Fecha       Autor                       Descripcion
------  ----------  --------------------        ---------------
1.0     2019-07-16  John Guevara (JG)			Clase auxiliar para crear XML a partir de un texto   
*******************************************************************************/
public class PS_IntegrationHelper_ctr {
        
    public DOM.Document MaptoXML(Map<String,Object> mapHierarchy){
        DOM.Document docServices = new DOM.Document();
        dom.XmlNode servicesNode = docServices.createRootElement('Mapper', null, null);
        iteratorMaptoXML(servicesNode, mapHierarchy);
        return docServices;
    }

    public void iteratorMaptoXML(Dom.XMLNode xnode, Map<String,Object> MapVariables){
        for(String i:MapVariables.keyset()){
            if(MapVariables.get(i) instanceof String){
                dom.XmlNode sglNode= xnode.addChildElement(i, null, null);
                sglNode.addTextNode((String)MapVariables.get(i));
            }else if(MapVariables.get(i) instanceof Map<String,Object>){
                dom.XmlNode sglNode= xnode.addChildElement(i, null, null);
                iteratorMaptoXML(sglNode,(Map<String,Object>)MapVariables.get(i));
            }else if(MapVariables.get(i) instanceof List<Map<String,Object>>){
                dom.XmlNode sglNode= xnode.addChildElement(i, null, null);
                for(Map<String,Object> sglMap:(List<Map<String,Object>>)MapVariables.get(i)){
                    dom.XmlNode sglNodeChild= sglNode.addChildElement(i+'_Item', null, null);
                    iteratorMaptoXML(sglNodeChild,sglMap);
                }
            }
        }
    }
        
    public DOM.Document PopulateXML(Dom.Document doc, Map<String,Object> MapVariables){
        DOM.Document docServices = new DOM.Document();
        Dom.XMLNode xnode = doc.getRootElement();
        dom.XmlNode servicesNode = docServices.createRootElement(xnode.getName(), xnode.getNamespace(), xnode.getPrefixFor(xnode.getNamespace()));
        iteratorPopulateXML(xnode,MapVariables,servicesNode);
        return docServices;
    }
        
    public void iteratorPopulateXML(Dom.XMLNode xnode, Map<String,Object> MapVariables, Dom.XMLNode newNode){
        for(Dom.XMLNode child: xnode.getChildElements()){
            if(child.getName()=='xMapConditional'){
                String sCondition = child.getAttribute('Condition',null);
                system.debug(sCondition);
                if(EvaluateValue(sCondition, MapVariables)=='true'){
                    iteratorPopulateXML(child,MapVariables,newNode);
                }
            }else if(child.getName()=='xMapIterator'){
                String sPahtIterator = child.getAttribute('IteratorVariable',null);
                List<String> lstIteratorPath = sPahtIterator.split('\\/');
                List<Map<String,Object>> lstMapIterator = (List<Map<String,Object>>)GetMapelement(MapVariables, lstIteratorPath.clone());
                for(Map<String,Object> sglIterator:lstMapIterator){
                    Map<String,Object> tmpMapVariables = MapVariables.Clone();
                    tmpMapVariables=SetMapelement(tmpMapVariables, lstIteratorPath.clone(), sglIterator.clone());
                    iteratorPopulateXML(child,tmpMapVariables,newNode);
                }
            }else{
                dom.XmlNode sglNode= newNode.addChildElement(child.getName(), child.getNamespace(), (child.getNamespace()!=null?child.getPrefixFor(child.getNamespace()):null));
                if(child.getAttributeCount()>0){
                    for(integer i=0; i< child.getAttributeCount() ;i++) {
                        sglNode.setAttribute(child.getAttributeKeyAt(i), EvaluateValue(child.getAttributeValue(child.getAttributeKeyAt(i), child.getAttributeKeyNsAt(i)),MapVariables));
                    }
                }
                if(child.getChildElements().Size()>0){
                    iteratorPopulateXML(child,MapVariables,sglNode);
                }else{
                    sglNode.addTextNode(EvaluateValue(child.getText(),MapVariables));
                }
            }
        }
    }
        
    public Object GetMapelement(Map<String,Object> MapVariables, List<String> spath){
        String actualpath = '';
        if(spath.size()>0){
            actualpath = spath.get(0);
            system.debug(actualpath);
            if(spath.size()==2){
                system.debug(spath.get(1));
            }
            if(spath.get(0).contains('[')){
                Pattern p = Pattern.compile('\\[([0-9]+)\\]');
                Matcher pm = p.matcher( actualpath );
                Boolean pmVal = pm.find();
                system.debug(actualpath);
                if( pmVal ){
                    String tempPath = actualpath.replace(pm.group(0), '');
                    Integer iPos = Integer.valueOf(pm.group(1));
                    system.debug(actualpath);
                    system.debug(MapVariables.get(tempPath));
                    List<Map<String,Object>> lstTemp = new List<Map<String,Object>>();
                    try{
                        lstTemp = (List<Map<String,Object>>)MapVariables.get(tempPath);
                    }catch(exception e){
                        system.debug('error '+actualpath);
                        system.debug(MapVariables.get(tempPath));
                        throw e;
                    }
                    system.debug(actualpath);
                    system.debug(iPos);
                    system.debug(lstTemp);
                    if(iPos<lstTemp.size()){
                        spath.remove(0);
                        system.debug(spath);
                        return GetMapelement(lstTemp[iPos] , spath);
                    }
                }else{
                    String sOperator = '';
                    if(actualpath.contains('==')){
                        sOperator='==';
                    }else if(actualpath.contains('!=')){
                        sOperator='!=';
                    }
                    if(String.isNotEmpty(sOperator)){
                        Pattern pCond = Pattern.compile('\\[([a-zA-Z0-9áéíóú\\-\\_\\ \\=\\.\\\']+)\\]');
                        Matcher pmCond = pCond.matcher( actualpath );
                        system.debug(actualpath);
                        if( pmCond.find() ){
                            String tempPath = actualpath.replace(pmCond.group(0), '');
                            String sCond = pmCond.group(1);
                            List<String> arrCond = sCond.split(sOperator);
                            if(MapVariables.containskey(tempPath)){
                                List<Map<String,Object>> lstTemp = (List<Map<String,Object>>)MapVariables.get(tempPath);
                                system.debug(arrCond.size());
                                system.debug(lstTemp);
                                if(arrCond.size()==2){
                                    for(Map<String,Object> tmpMap:lstTemp){
                                        if(tmpMap.containskey(arrCond[0].trim())){
                                            String fstCond ='\''+tmpMap.get(arrCond[0].trim()).toString()+'\'';
                                            system.debug(fstCond+'-'+arrCond[1].trim()+'-'+sOperator);
                                            if(sOperator.equals('==') && fstCond.equals(arrCond[1].trim())){
                                                spath.remove(0);
                                                return GetMapelement(tmpMap , spath);
                                            }else 
                                                if(sOperator.equals('!=') && !fstCond.equals(arrCond[1].trim())){
                                                    spath.remove(0);
                                                    return GetMapelement(tmpMap , spath);
                                                }
                                        }
                                    }
                                }
                            }else{
                                return 'null';
                            }
                        }
                    }
                }
            }else{
                system.debug(actualpath);
                system.debug(MapVariables);
                if(MapVariables.containskey(actualpath)){
                    
                    if(spath.size()==1){
                        return (Object)MapVariables.get(spath.get(0));
                    }else{
                        spath.remove(0);
                        try{
                        object tmpObjRet = GetMapelement((Map<String,Object>)MapVariables.get(actualpath) , spath);
                        return tmpObjRet;
                        }catch(Exception e){
                            system.debug(e.getMessage());
                            return 'null';
                        }
                    }
                    
                }else{
                    return 'null';
                }
            }
        }
        return 'null';
    }
        
    public Map<String,Object> SetMapelement(Map<String,Object> MapVariables, List<String> spath, Object objValue){
        String actualpath = '';
        if(spath.size()>0){
            if(MapVariables.containskey(spath.get(0))){
                system.debug(spath.size());
                system.debug(spath.get(0));
                system.debug(MapVariables);
                system.debug(objValue);
                if(spath.size()==1){
                    
                    Map<String,Object> tmpMap = MapVariables.clone();
                    tmpMap.put(spath.get(0), objValue);
                    system.debug(MapVariables);
                    return tmpMap;
                }else{
                    actualpath=spath.get(0);
                    spath.remove(0);
                    Map<String,Object> tmpret = SetMapelement((Map<String,Object>)MapVariables.get(actualpath), spath, objValue);
                    Map<String,Object> tmpMap = MapVariables.clone();
                    tmpMap.put(actualpath, tmpret);
                    return tmpMap;
                }
            }else{
                return null;
            }
        }
        return null;
    }
        
    public String EvaluateValue(String elemValue, Map<String,Object> MapVariables){
        Map<String,String> mapArguments = new Map<String,String>();
        Integer i = 0;
        system.debug('elemValue: '+elemValue);
        
        while(elemValue.contains('{@')){
            Pattern pVar = Pattern.compile('\\{\\@([a-zA-Z0-9áéíóú_.\\-\\/\\_\\[\\]\\=\\!\\ \\\']*)\\}');
            Matcher pmVar = pVar.matcher( elemValue );
            if( pmVar.find() ){
                List<String> arrmatch = pmVar.group(1).split('\\/');
                system.debug(arrmatch);
                String sConstant = '{$Constant_'+String.ValueOf(i)+'}';
                mapArguments.put(sConstant, GetMapelement(MapVariables,arrmatch).toString());
                elemValue=elemValue.replace(pmVar.group(0), sConstant);
                i++;
            }else{
                break;
            }
        }
        system.debug('elemValue: '+elemValue);
        
        while(elemValue.contains('\'')){
            Pattern pText = Pattern.compile('\\\'([^\\\']*)\\\'');
            Matcher pmText = pText.matcher( elemValue );
            if( pmText.find() ){
                String sConstant = '{$Constant_'+String.ValueOf(i)+'}';
                mapArguments.put(sConstant,pmText.group(1));
                elemValue=elemValue.replace(pmText.group(0), sConstant);
                i++;
            }else{
                break;
            }
        }
        system.debug('elemValue: '+elemValue);
        while(elemValue.contains('(')){
            Pattern pFunc = Pattern.compile('([a-zA-Z0-9_]*)\\(([^\\)\\(]+)\\)');
            Matcher pmFunc = pFunc.matcher( elemValue );
            if( pmFunc.find() ){
                system.debug('Funcion: '+pmFunc.group(1));
                system.debug('Params: '+pmFunc.group(2));
                List<String> arrmatch = pmFunc.group(2).split('\\,');
                Map<Integer,String> mapParams = new Map<Integer,String>();
                Integer pos = 0;
                for(String sglMatch:arrmatch){
                    sglMatch = sglMatch.trim();
                    while(sglMatch.contains('{$')){
                        Pattern pVar = Pattern.compile('\\{\\$Constant_([0-9]+)\\}');
                        Matcher pmVar = pVar.matcher( sglMatch );
                        if( pmVar.find() ){
                            sglMatch=sglMatch.replace(pmVar.group(0), mapArguments.get(pmVar.group(0)));
                        }else{
                            break;
                        }
                    }
                    mapParams.put(pos,sglMatch);
                    pos++;
                }
                String sConstant = '{$Constant_'+String.ValueOf(i)+'}';
                system.debug('Funcion: '+pmFunc.group(1));
                system.debug(mapParams);
                String sret = mapDynamicFunction(mapParams, pmFunc.group(1), MapVariables);
                mapArguments.put(sConstant,sret);
                elemValue=elemValue.replace(pmFunc.group(0), sConstant);
                system.debug(elemValue);
                i++;
            }else{
                break;
            }
        }
        
        system.debug('elemValue: '+elemValue);
        while(elemValue.contains('{$')){
            Pattern pVar = Pattern.compile('\\{\\$Constant_([0-9]+)\\}');
            Matcher pmVar = pVar.matcher( elemValue );
            if( pmVar.find() ){
                elemValue=elemValue.replace(pmVar.group(0), mapArguments.get(pmVar.group(0)));
            }else{
                break;
            }
        }
        system.debug('elemValue: '+elemValue);
        return elemValue;
    }
        
    public String mapDynamicFunction(Map<Integer,String> mapParams, String sFunctionName, Map<String,Object> MapVariables){
        system.debug('mapDynamicFunction: '+sFunctionName);
        switch on sFunctionName {
            when 'AND' {
                Boolean result = true;
                for(String sglVar:mapParams.values()){
                    result = result && conditionSymbols(sglVar);
                }
                return String.valueOf(result);
            }
            when 'OR' {
                Boolean result = false;
                for(String sglVar:mapParams.values()){
                    result = result || conditionSymbols(sglVar);
                }
                return String.valueOf(result);
            }
            when 'NOT' {
                Boolean result = true;
                if(mapParams.size()==1){
                    result = !conditionSymbols(mapParams.get(0));
                    return String.valueOf(result);
                }
            }
            when 'IF' {
                system.debug(mapParams.size());
                if(mapParams.size()==3){
                    if(conditionSymbols(mapParams.get(0))){
                        system.debug(mapParams.get(0));
                        system.debug(mapParams.get(1));
                        return mapParams.get(1);
                    }else{
                        system.debug(mapParams.get(0));
                        system.debug(mapParams.get(2));
                        return mapParams.get(2);
                    }
                }
            }
            when 'TRANSLATE' {
                system.debug(mapParams.size());
                if(mapParams.size()==2){
                    String sSearch = '{@Homologacion/'+mapParams.get(0)+'[Valor_Usuario__c==\''+mapParams.get(1)+'\']/Valor_API__c}';
                    system.debug('TRANSLATE 0:'+mapParams.get(0)+' 1:'+mapParams.get(1)+' sSearch:'+sSearch);
                    String stranslate = EvaluateValue(sSearch, MapVariables);
                    system.debug('TRANSLATE '+stranslate + ' 0:'+mapParams.get(0)+' 1:'+mapParams.get(1)+' sSearch:'+sSearch);
                    return stranslate;
                }
            }
            when 'SUBSTRING' {
                system.debug(mapParams.size());
                if(mapParams.size()==3){
                    if(!string.isEmpty(mapParams.get(0).trim())){
                        if(mapParams.get(0).trim().length()>(Integer.valueof(mapParams.get(1).trim())+1) && mapParams.get(0).trim().length()>(Integer.valueof(mapParams.get(2).trim())) && Integer.valueof(mapParams.get(1).trim())<Integer.valueof(mapParams.get(2).trim())){
                            return mapParams.get(0).trim().substring(Integer.valueof(mapParams.get(1).trim()),Integer.valueof(mapParams.get(2).trim()));
                        }
                    }
                    return string.isEmpty(mapParams.get(0))?'':mapParams.get(0);
                    /*
                    String sSearch = '{@Homologacion/'+mapParams.get(0)+'[Valor_Usuario__c==\''+mapParams.get(1)+'\']/Valor_API__c}';
                    
                    String stranslate = EvaluateValue(sSearch, MapVariables);
                    system.debug('SUBSTRING '+stranslate + ' 0:'+mapParams.get(0)+' 1:'+mapParams.get(1)+' sSearch:'+sSearch);
                    return stranslate;
					*/
                }
            }
            when 'REPLACEUTF8' {
                if(mapParams.size()==1){
                    return ReplaceUTF8Character(mapParams.get(0));
                }
            }
            when '' {
                Boolean result = true;
                for(String sglVar:mapParams.values()){
                    result = result && conditionSymbols(sglVar);
                }
                return String.valueOf(result);
            }
        }
        return '';
    }
        
    public Boolean conditionSymbols(String sExpr){
        sExpr = sExpr.trim();
        if(sExpr.equals('true')){
            return true;
        }else if (sExpr.equals('false')){
            return false;
        }else if(sExpr.contains('==')){
            List<String> variables = sExpr.split('\\=\\=');
            if(variables.size()==0)
                variables.add('');
            if(variables.size()==1)
                variables.add('');
            system.debug(variables[0].trim()+'-'+Variables[1].trim());
            if(variables.size()==2){
                return variables[0].trim().equals(Variables[1].trim());
            }
        }else if(sExpr.contains('!=')){
            system.debug(sExpr);
            List<String> variables = sExpr.split('\\!\\='); sExpr.split('\\!\\=');
            if(variables.size()==0)
                variables.add('');
            if(variables.size()==1)
                variables.add('');
            system.debug(variables);
            system.debug(sExpr+' '+variables[0].trim()+' '+variables[1].trim()+' '+String.valueof(variables.size()));
            if(variables.size()==2){
                system.debug(!variables[0].trim().equals(Variables[1].trim()));
                return !variables[0].trim().equals(Variables[1].trim());
            }
        }
        return false;
    }
    
    public String ReplaceUTF8Character(String sInput){
        String sOutput = sInput;
        if(String.isNotEmpty(sInput)){
            sOutput = sOutput.replaceAll('\\&(?!amp;)', '&amp;');
            sOutput = sOutput.replaceAll('\\"', '&quot;');
            sOutput = sOutput.replaceAll('\\\'', '&#39;');
            sOutput = sOutput.replaceAll('\\<', '&lt;');
            sOutput = sOutput.replaceAll('\\>', '&gt;');
            //sOutput = sOutput.replaceAll('\\Á', '&Aacute;');
            //sOutput = sOutput.replaceAll('\\É', '&Eacute;');
            //sOutput = sOutput.replaceAll('\\Í', '&Iacute;');
            //sOutput = sOutput.replaceAll('\\Ó', '&Oacute;');
            //sOutput = sOutput.replaceAll('\\Ú', '&Uacute;');
            //sOutput = sOutput.replaceAll('\\á', '&aacute;');
            //sOutput = sOutput.replaceAll('\\é', '&eacute;');
            //sOutput = sOutput.replaceAll('\\í', '&iacute;');
            //sOutput = sOutput.replaceAll('\\ó', '&oacute;');
            //sOutput = sOutput.replaceAll('\\ú', '&uacute;');
        }
        return sOutput;
    }
    
    public static Map<Id,Map<String,Object>> PopulateMap(String SObjectType,Set<string> setFields,List<SObject> lstRecords,String sDateformat)
	{
        sDateformat=String.isEmpty(sDateformat)?'yyyy-MM-dd\'T\'HH:mm:ssXXX':sDateformat;
        Map<Id,Map<String,Object>> mapHierarchy = new Map<Id,Map<String,Object>>();
        Map<String,Map<String, Schema.SObjectField>> mpObjectField = new Map<String,Map<String, Schema.SObjectField>>();
        Map<String, Schema.SObjectField> oObjectType = Schema.getGlobalDescribe().get(SObjectType).getDescribe().fields.getMap();
        mpObjectField.put(SObjectType,oObjectType);
        
        for(sobject obj:lstRecords){
            Map<String,Object> tmpMapHierarchy = new Map<String,Object>();
            
            for(String sglfield:setFields){
                list<string> info=sglfield.trim().split('\\x2E');
                Integer i=1;
                sobject objTemp = obj;
                
                for(string s :info){
                    s=s.trim();
                    if(info.size()!=i){
                        objTemp=objTemp.getSObject(s);
                        if(objTemp==null){
                            tmpMapHierarchy.put(sglfield.trim(),'');
                            break;
                        }else{
                            if(!mpObjectField.containskey(objTemp.getSObjectType().getDescribe().getLocalName())){
                                mpObjectField.put(objTemp.getSObjectType().getDescribe().getLocalName(), objTemp.getSObjectType().getDescribe().fields.getMap());
                            }
                        }
                        
                    }else{
                        if(mpObjectField.containskey(objTemp.getSObjectType().getDescribe().getLocalName())){
                            Map<String, Schema.SObjectField> oRecordFields = mpObjectField.get(objTemp.getSObjectType().getDescribe().getLocalName());
                            if(oRecordFields.containskey(s)){
                                if(oRecordFields.get(s).getDescribe().getSOAPType() == Schema.SOAPType.DATE || oRecordFields.get(s).getDescribe().getSOAPType()==Schema.SOAPType.DATETIME){
                                    Datetime dtFecha = (Datetime)objTemp.get(s);
                                    Map<String,Object> mapDate = new Map<String,Object>();
                                    mapDate.put('fulldate', dtFecha!=null?String.valueOf(dtFecha):'');
                                    mapDate.put('formatdate', dtFecha!=null?dtFecha.format(sDateformat,'America/Bogota'):'');
                                    mapDate.put('day', dtFecha!=null?String.valueOf(dtFecha.day()).leftpad(2,'0'):'');
                                    mapDate.put('month', dtFecha!=null?String.valueOf(dtFecha.month()).leftpad(2,'0'):'');
                                    mapDate.put('year', dtFecha!=null?String.valueOf(dtFecha.year()):'');
                                    tmpMapHierarchy.put(sglfield.trim(),mapDate);
                                }else{
                                    tmpMapHierarchy.put(sglfield.trim(), objTemp.get(s)==null?'':String.valueOf(objTemp.get(s)));
                                }
                            }else{
                                tmpMapHierarchy.put(sglfield.trim(),'');
                            }
                        }else{
                            tmpMapHierarchy.put(sglfield.trim(),'');
                        }			
                    }
                    i++;
                }
            }
            mapHierarchy.put(obj.Id,tmpMapHierarchy);
        }

		return mapHierarchy;
	}
    
    public static String MapListValuesToString(Map<String,Object> mpListaValores, String TipoLista, String Campo){
        Set<String> lstValues = new Set<String>();
        if(mpListaValores!=null){
            if(mpListaValores.containskey(TipoLista)){
                if(mpListaValores.get(TipoLista)!=null){
                    for(Map<String,String> mpCampos:(List<Map<String,String>>)mpListaValores.get(TipoLista)){
                        lstValues.add(mpCampos.containskey(Campo)?'\''+mpCampos.get(Campo)+'\'':'');
                    }
                }
            }
        }
        String joinedString = String.join(new List<String>(lstValues), ',');
        return joinedString;
    }
    
    public static Map<String,List<Map<String,String>>> ObtenerListaValores(String ObjLista,String Condicion){
        Map<String,List<Map<String,String>>> mpListaValores = new Map<String,List<Map<String,String>>>();
        if(Schema.getGlobalDescribe().containskey(ObjLista)){
            Set<String> lstCamposConsultar = new Set<String>();
        	Map<String,Schema.SObjectField> mpCampos = Schema.getGlobalDescribe().get(ObjLista).getDescribe().fields.getMap();
            for(Schema.SObjectField sglCampo:mpCampos.values()){
                DescribeFieldResult sglCampoDesc = sglCampo.getDescribe();
                if(sglCampoDesc.isCustom() || sglCampoDesc.getLocalName()=='MasterLabel' || sglCampoDesc.getLocalName()=='Tipo_Lista__c'){
                    lstCamposConsultar.add(sglCampoDesc.getLocalName());
                }
            }
            if(lstCamposConsultar.contains('MasterLabel') && lstCamposConsultar.contains('Tipo_Lista__c')){
                String joinedString = String.join(new List<String>(lstCamposConsultar), ',');
                String sql = 'SELECT '+joinedString+' FROM '+ ObjLista+(String.isEmpty(Condicion)?'':' WHERE '+Condicion);
                List<SObject> lstObjetos = Database.query(sql);
                for(SObject slgObjeto:lstObjetos){
                    if(!mpListaValores.containskey(String.valueOf(slgObjeto.get('Tipo_Lista__c'))))
                        mpListaValores.put(String.valueOf(slgObjeto.get('Tipo_Lista__c')),new List<Map<String,String>>());
                    Map<String,String> mpRegistro = new Map<String,String>();
                    for(String sglCampoConsultar:lstCamposConsultar){
                        mpRegistro.put(sglCampoConsultar,String.valueOf(slgObjeto.get(sglCampoConsultar)));
                    }
                    mpListaValores.get(String.valueOf(slgObjeto.get('Tipo_Lista__c'))).add(mpRegistro);
                }
            }
        }
        return mpListaValores;
    }
    
    public static Decimal obtenerHoras(BusinessHours bhToUse, Datetime startDate, Datetime endDate){
        Decimal horas;
        //Making sure BH record exists
        if(bhToUse != NULL){
            //For BH method we assign (BH record id, start time field, end time field)
            decimal result = BusinessHours.diff(bhToUse.Id, startDate, endDate );
            //Result from the method is divided by 60*60*100 (milliseconds to be then converted into hours)
            Decimal resultingHours = result/(60*60*1000);
            //Populating result & setting number of decimals
            horas = resultingHours.setScale(2);
        } 
        return horas;
    }   
    
}