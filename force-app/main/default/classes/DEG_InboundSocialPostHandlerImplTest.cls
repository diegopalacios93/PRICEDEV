@isTest
public class DEG_InboundSocialPostHandlerImplTest {
    static Map<String, Object> sampleSocialData;
    static DEG_InboundSocialPostHandlerImpl handler;

    static {
        handler = new DEG_InboundSocialPostHandlerImpl();
        sampleSocialData = getSampleSocialData('1');
	}
	
    static testMethod void verifyNewRecordCreation() {
           
            SocialPost post = getSocialPost(sampleSocialData);
            SocialPersona persona = getSocialPersona(sampleSocialData);
        
            test.startTest();
              handler.handleInboundSocialPost(post, persona, sampleSocialData);
            test.stopTest();
  }

 	static testMethod void matchSocialPersonaRecord() {
        
        List<RecordType> TipoRegistro = new List<RecordType>();
            
            tipoRegistro= [SELECT ID, DeveloperName
                          FROM  RecordType WHERE DeveloperName = 'DEG_MensajeriaHSM' LIMIT 1] ;
            
        Contact existingContact = new Contact(LastName = 'LastName');
        
        existingContact.RecordTypeId = tipoRegistro[0].id;
        
    
        insert existingContact;
        
        SocialPersona existingPersona = getSocialPersona(getSampleSocialData('2'));
        existingPersona.ParentId = existingContact.Id;
       
        insert existingPersona;
        
        SocialPost post = getSocialPost(sampleSocialData);
        SocialPersona persona = getSocialPersona(sampleSocialData);
        persona.ExternalId = existingPersona.ExternalId;
        
        test.startTest();
        handler.handleInboundSocialPost(post, persona, sampleSocialData);
        test.stopTest();
        
   
	}
    
	static testMethod void matchCaseRecord() {
     
        List<RecordType> TipoRegistro = new List<RecordType>();
            
            tipoRegistro= [SELECT ID, DeveloperName
                          FROM  RecordType WHERE DeveloperName = 'DEG_MensajeriaHSM' LIMIT 1] ;
            System.debug('RecordType: ' +TipoRegistro);
        
        Contact existingContact = new Contact(LastName = 'LastName');
        existingContact.RecordTypeId = tipoRegistro[0].id;
        
        
        insert existingContact;
        
        SocialPersona existingPersona = getSocialPersona(getSampleSocialData('2'));
        existingPersona.ParentId = existingContact.Id;
        
        insert existingPersona;
       
        Case existingCase = new Case(ContactId = existingContact.Id, Subject = 'Test Case');
        insert existingCase;
        
        SocialPost existingPost = getSocialPost(getSampleSocialData('2'));
        
            
        existingPost.ParentId = existingCase.Id;
        existingPost.WhoId = existingContact.Id;
        existingPost.PersonaId = existingPersona.Id;
        String recipient = 'scs';
        existingPost.recipient = recipient;
        
        insert existingPost;
        
        SocialPost post = getSocialPost(sampleSocialData);
        post.responseContextExternalId = existingPost.ExternalPostId;
        post.Recipient = recipient;
        
        test.startTest();
        handler.handleInboundSocialPost(post, existingPersona, sampleSocialData);
        test.stopTest();
        
    }

    
	static SocialPost getSocialPost(Map<String, Object> socialData) {
        
        SocialPost post = new SocialPost();
        
        post.Name = String.valueOf(socialData.get('source'));
        post.Content = String.valueOf(socialData.get('content'));
        post.Posted = Date.valueOf(String.valueOf(socialData.get('postDate')));
        post.PostUrl = String.valueOf(socialData.get('postUrl'));
        post.Provider = String.valueOf(socialData.get('mediaProvider'));                     
        post.MessageType = String.valueOf(socialData.get('messageType'));
        post.ExternalPostId = String.valueOf(socialData.get('externalPostId'));
        post.R6PostId = String.valueOf(socialData.get('r6PostId'));
        post.PostTags = String.valueOf(socialData.get('postTags'));
        
      return post;
	}
    
    static SocialPersona getSocialPersona(Map<String, Object> socialData) {
        
        SocialPersona persona = new SocialPersona();
        
        persona.Name = String.valueOf(socialData.get('author'));
        persona.RealName = String.valueOf(socialData.get('realName'));
        persona.Provider = String.valueOf(socialData.get('mediaProvider'));
        persona.MediaProvider = String.valueOf(socialData.get('mediaProvider'));
        persona.ExternalId = String.valueOf(socialData.get('externalUserId'));
        
        return persona;
     }
    
    static Map<String, Object> getSampleSocialData(String suffix) {
        
        Map<String, Object> socialData = new Map<String, Object>();
        
        socialData.put('r6PostId', 'R6PostId' + suffix);
        socialData.put('r6SourceId', 'R6SourceId' + suffix);
        socialData.put('postTags', 'Inválidos-Contacto de prueba de ETB,Chat');
        socialData.put('externalPostId', 'ExternalPostId' + suffix);
        socialData.put('content', 'Content' + suffix);
        socialData.put('postDate', '2021-01-01T12:12:12Z');
        socialData.put('mediaType', 'Twitter');
        socialData.put('author', 'Author');
        socialData.put('skipCreateCase', false);
        socialData.put('mediaProvider', 'TWITTER');
        socialData.put('externalUserId', 'ExternalUserId');
        socialData.put('postUrl', 'PostUrl' + suffix);
        socialData.put('messageType', 'Tweet');
        socialData.put('source', 'Source' + suffix);
        socialData.put('replyToExternalPostId', null);
        socialData.put('realName', 'Real Name');
        socialData.put('assignedTo', '{id=622012, name=mary.florio@accenture.com}');
        
        return socialData;
    }
 }