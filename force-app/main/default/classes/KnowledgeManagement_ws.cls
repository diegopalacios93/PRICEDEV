@RestResource(urlMapping='/v1/WebServiceKnowledge/')
global class KnowledgeManagement_ws {
    @httpPost
    global static List<Knowledge__kav> doPostMethod(String Status, String Nombre, String Categoria, String Fecha){
        system.debug('Status:'+Status);
        system.debug('Nombre:'+Nombre);
        system.debug('Categoria:'+Categoria);
        system.debug('Fecha:'+Fecha);
        List<Knowledge__kav> kav = New List<Knowledge__kav>();
        
        String QueryBase = 'SELECT Id, KnowledgeArticleId, OwnerId, IsDeleted, ValidationStatus, PublishStatus, VersionNumber, IsLatestVersion, IsVisibleInApp, IsVisibleInPkb, IsVisibleInCsp, IsVisibleInPrm, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Language, Title, UrlName, ArchivedDate, ArchivedById, Summary, ArticleNumber, FirstPublishedDate, LastPublishedDate, ArticleArchivedById, ArticleArchivedDate, ArticleCaseAttachCount, ArticleCreatedById, ArticleCreatedDate, ArticleMasterLanguage, ArticleTotalViewCount, SourceId, RecordTypeId, AssignedToId, AssignedById, AssignmentDate, AssignmentDueDate, AssignmentNote, MigratedToFromArticleVersion, Answer__c, Question__c, Owner_Name__c, Subtitulo__c FROM Knowledge__kav ';
        String WhereQuery;
        
        if(!String.isBlank(Status) && String.isBlank(WhereQuery)){
            WhereQuery = 'Where PublishStatus=\''+Status+'\'';
        } else if(!String.isBlank(Status) && !String.isBlank(WhereQuery)){
            WhereQuery += ' and PublishStatus=\''+Status+'\''; 
        }
        
        if(!String.isBlank(Nombre) && String.isBlank(WhereQuery)){
            WhereQuery = 'Where Title LIKE \'%'+Nombre+'%\'';
        } else if(!String.isBlank(Nombre) && !String.isBlank(WhereQuery)){
            WhereQuery += ' and Title LIKE \'%'+Nombre+'%\'';
        }
        //2021-06-15
        if(!String.isBlank(Fecha) && String.isBlank(WhereQuery)){
            WhereQuery = 'Where CreatedDate>='+Fecha+'T00:00:00Z and CreatedDate<='+Fecha+'T23:59:59Z';
        } else if(!String.isBlank(Fecha) && !String.isBlank(WhereQuery)){
            WhereQuery += ' and CreatedDate>='+Fecha+'T00:00:00Z and CreatedDate<='+Fecha+'T23:59:59Z';
        }
        
        if(!String.isBlank(Categoria) && String.isBlank(WhereQuery)){
            WhereQuery = 'Where PublishStatus=\'online\' WITH DATA CATEGORY Todas_las_Categorias__c AT '+Categoria;
        } else if(!String.isBlank(Categoria) && !String.isBlank(WhereQuery)){
            WhereQuery += ' WITH DATA CATEGORY Todas_las_Categorias__c AT '+Categoria;
        }
        
        system.debug('WhereQuery:'+WhereQuery);
        String FullQuery;
        if(!String.isBlank(WhereQuery)){
            FullQuery = QueryBase + WhereQuery;
        }else{
            FullQuery = QueryBase;
        }
        kav = Database.query(FullQuery);
        system.debug('kav:'+kav);
        
        return kav;
    }
}