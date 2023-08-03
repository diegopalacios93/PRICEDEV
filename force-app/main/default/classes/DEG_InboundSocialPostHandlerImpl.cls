global virtual class DEG_InboundSocialPostHandlerImpl implements Social.InboundSocialPostHandler {

    final static Integer SUBJECT_MAX_LENGTH = Case.Subject.getDescribe().getLength();
    
   
    global Social.InboundSocialPostResult handleInboundSocialPost(SocialPost post, SocialPersona persona, Map<String, Object> rawData) {
        
        System.debug('Post1' + post);
        System.debug('persona1' + persona);
        System.debug('rawData1' + rawData);
        
        Social.InboundSocialPostResult result = new Social.InboundSocialPostResult();
        
         System.debug('InboundSocialPostResult1' + result);
        
        result.setSuccess(true);
       
        createCase(post, persona, rawData);
        
              
        return result;
    }
    
    private Case createCase(SocialPost post, SocialPersona persona, Map<String, Object> rawData) {
        
     //    String Categoria = getTagCategoria(post);
      //   String SubCategoria = getTagSubCategoria(post);
        
    //    List<RecordType> TipoRegistro = new List<RecordType>();
        
    /*    TipoRegistro= [SELECT ID, DeveloperName
                      FROM  RecordType WHERE DeveloperName = 'DEG_CasosMasivo' LIMIT 1] ;
        System.debug('RecordType: ' +TipoRegistro);*/

       Object assignedTo = rawData.get('assignedTo');
       String correo = String.valueOf(assignedTo);
        Case newCase = new Case();
        
        
            if (post != null && post.Provider != null) {
                newCase.Origin = post.Provider;
                newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('DEG_CasosMasivo').getRecordTypeId(); //TipoRegistro[0].Id;//'012290000009bAoAAI';  
                newCase.DEG_Nombre__c = post.Handle;
                newCase.Sistema__c = 'Social Studio';
                newCase.status = 'Resuelto';
                newCase.Subject = post.Name;
                newCase.Description = post.Content;
                newCase.SolucionSistemaLegado__c = post.PostTags;
                newCase.DEG_Agente_Social__c = correo.substringAfter('name=').substringBefore('}');
                newCase.DEG_Categoria__c = post.PostTags.split('-')[0];
                newCase.DEG_Sub_Categoria__c = post.PostTags.substringAfter('-').substringBefore(',');    
                                
                
            System.debug('Categoria ' +post.PostTags.split('-')[0]);
            System.debug('SubCategoria ' +post.PostTags.substringAfter('-').substringBefore(','));
               
          }
        
        insert newCase;
        return newCase;
    }
    
   /* global String getTagSubCategoria(SocialPost post) {
        String postTags = post.PostTags;
        string SubCategoria = ',';
        string SubCategoria1 = '-';
        if (postTags.contains(',')) {
          string  SubCategoria1 = postTags.substringAfterLast('-');
            SubCategoria1 = SubCategoria;
            SubCategoria = postTags.substringBeforeLast(',');
                
        }
       // SubCategoria = SubCategoria1;
        return SubCategoria;
    }
    
    
    
    
    global String getTagCategoria(SocialPost post) {
        String postTags = post.PostTags;
        string Categoria = '-';
        if (postTags.contains('-')) {
            Categoria = postTags.substringBeforeLast('-');
           
        }
       // Categoria = Categoria;
        return Categoria;
    }*/
    

 /*   global String getPersonaFirstName(SocialPersona persona) {
        String name = getPersonaName(persona);      
        String firstName = '';
        if (name.contains(' ')) {
            firstName = name.substringBeforeLast(' ');
        }
        firstName = firstName.abbreviate(40);
        return firstName;
    }*/
    
 /*   global String getPersonaLastName(SocialPersona persona) {   
        String name = getPersonaName(persona);   
        String lastName = name;
       if (name.contains(' ')){    
            lastName = name.substringAfterLast(' ');
        }
        lastName = lastName.abbreviate(80);
        return lastName;
    }*/
    
/*    private String getPersonaName(SocialPersona persona) {
        String name = persona.Name.trim();
        if (String.isNotBlank(persona.RealName)) {
            name = persona.RealName.trim();
        }
        return name;
    }*/
    
   
}