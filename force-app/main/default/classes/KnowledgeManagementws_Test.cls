@isTest(seeAllData=false)
public class KnowledgeManagementws_Test {
	@isTest
    Public static void test1(){
        Knowledge__kav kav = New knowledge__kav();
        kav.Question__c = '¿Pregunta de prueba??';
        kav.Answer__c = 'Respuesta pruebaa';
        kav.Title = 'Titulo de pruebaa';
        kav.Subtitulo__c='Subtitulo pruebaa';
        kav.UrlName='Titulo-de-pruebaa';
        kav.ValidationStatus='Nuevo';
        kav.IsVisibleInCsp=true;
        kav.IsVisibleInPrm=true;
        insert kav;
        
        Knowledge__DataCategorySelection dcs = New Knowledge__DataCategorySelection();
        dcs.DataCategoryGroupName = 'Todas_las_Categorias';
        dcs.DataCategoryName='Empresas';
        dcs.ParentId = kav.id;
        insert dcs;
        test.startTest();
        String year  = string.valueof(system.today().year());
        String Month = system.today().month()<10?'0'+system.today().month():string.valueof(system.today().month());
        String Day   = system.today().day()<10?'0'+system.today().day():string.valueof(system.today().day());
        String JSONMsg = '{"Status" : "draft","Nombre" : "Titulo de pruebaa","Categoria" : "Empresas__c","Fecha" : "'+year+'"-"'+month+'"-"'+day+'"}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/v1/WebServiceKnowledge/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response = res;
        
        KnowledgeManagement_ws.doPostMethod('draft','Titulo de pruebaa','Empresas__c', year+'-'+month+'-'+day);
        test.stopTest();
    }
    @isTest
    Public static void test2(){
        Knowledge__kav kav = New knowledge__kav();
        kav.Question__c = '¿Pregunta de prueba??';
        kav.Answer__c = 'Respuesta pruebaa';
        kav.Title = 'Titulo de pruebaa';
        kav.Subtitulo__c='Subtitulo pruebaa';
        kav.UrlName='Titulo-de-pruebaa';
        kav.ValidationStatus='Nuevo';
        kav.IsVisibleInCsp=true;
        kav.IsVisibleInPrm=true;
        insert kav;
        
        Knowledge__DataCategorySelection dcs = New Knowledge__DataCategorySelection();
        dcs.DataCategoryGroupName = 'Todas_las_Categorias';
        dcs.DataCategoryName='Empresas';
        dcs.ParentId = kav.id;
        insert dcs;
        test.startTest();
        String JSONMsg = '{"Status" : "","Nombre":"Titulo de pruebaa","Categoria":"","Fecha":""}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/v1/WebServiceKnowledge/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response = res;
        
        KnowledgeManagement_ws.doPostMethod('','Titulo de pruebaa','', '');
        test.stopTest();
    }
    @isTest
    Public static void test3(){
        Knowledge__kav kav = New knowledge__kav();
        kav.Question__c = '¿Pregunta de prueba??';
        kav.Answer__c = 'Respuesta pruebaa';
        kav.Title = 'Titulo de pruebaa';
        kav.Subtitulo__c='Subtitulo pruebaa';
        kav.UrlName='Titulo-de-pruebaa';
        kav.ValidationStatus='Nuevo';
        kav.IsVisibleInCsp=true;
        kav.IsVisibleInPrm=true;
        insert kav;
        
        Knowledge__DataCategorySelection dcs = New Knowledge__DataCategorySelection();
        dcs.DataCategoryGroupName = 'Todas_las_Categorias';
        dcs.DataCategoryName='Empresas';
        dcs.ParentId = kav.id;
        insert dcs;
        test.startTest();
        String year  = string.valueof(system.today().year());
        String Month = system.today().month()<10?'0'+system.today().month():string.valueof(system.today().month());
        String Day   = system.today().day()<10?'0'+system.today().day():string.valueof(system.today().day());
        String JSONMsg = '{"Status" : "","Nombre" : "","Categoria" : "","Fecha" : "'+year+'"-"'+month+'"-"'+day+'"}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/v1/WebServiceKnowledge/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response = res;
        
        KnowledgeManagement_ws.doPostMethod('','','', year+'-'+month+'-'+day);
        test.stopTest();
    }
    @isTest
    Public static void test4(){
        Knowledge__kav kav = New knowledge__kav();
        kav.Question__c = '¿Pregunta de prueba??';
        kav.Answer__c = 'Respuesta pruebaa';
        kav.Title = 'Titulo de pruebaa';
        kav.Subtitulo__c='Subtitulo pruebaa';
        kav.UrlName='Titulo-de-pruebaa';
        kav.ValidationStatus='Nuevo';
        kav.IsVisibleInCsp=true;
        kav.IsVisibleInPrm=true;
        insert kav;
        
        Knowledge__DataCategorySelection dcs = New Knowledge__DataCategorySelection();
        dcs.DataCategoryGroupName = 'Todas_las_Categorias';
        dcs.DataCategoryName='Empresas';
        dcs.ParentId = kav.id;
        insert dcs;
        test.startTest();
        String JSONMsg = '{"Status" : "","Nombre":"","Categoria":"Empresas__c","Fecha":""}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/v1/WebServiceKnowledge/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response = res;
        
        KnowledgeManagement_ws.doPostMethod('','','Empresas__c', '');        
        test.stopTest();
    }
    @isTest
    Public static void test5(){
        Knowledge__kav kav = New knowledge__kav();
        kav.Question__c = '¿Pregunta de prueba??';
        kav.Answer__c = 'Respuesta pruebaa';
        kav.Title = 'Titulo de pruebaa';
        kav.Subtitulo__c='Subtitulo pruebaa';
        kav.UrlName='Titulo-de-pruebaa';
        kav.ValidationStatus='Nuevo';
        kav.IsVisibleInCsp=true;
        kav.IsVisibleInPrm=true;
        insert kav;
        
        Knowledge__DataCategorySelection dcs = New Knowledge__DataCategorySelection();
        dcs.DataCategoryGroupName = 'Todas_las_Categorias';
        dcs.DataCategoryName='Empresas';
        dcs.ParentId = kav.id;
        insert dcs;
        test.startTest();
        String JSONMsg = '{"Status" : "","Nombre":"","Categoria":"","Fecha":""}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/v1/WebServiceKnowledge/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSONMsg);
        RestContext.request = req;
        RestContext.response = res;

        KnowledgeManagement_ws.doPostMethod('','','', '');   
        test.stopTest();
    }
}