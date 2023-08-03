public class getWrapData {
    
    @auraEnabled
    public static List<wrapperclass> WrapList() {
        List<wrapperclass> wrapList = new List<wrapperclass>();
        for (ProcessInstance pi: [SELECT Id, Status, TargetObjectId, TargetObject.Name, 
                                  (SELECT Id, ActorId, Actor.Name, OriginalActorId, OriginalActor.Name, StepStatus, 
                                   Comments, ProcessNode.Name, CreatedDate FROM StepsAndWorkitems WHERE StepStatus =: 'Pending') 
                                  FROM ProcessInstance WHERE Status =: 'Pending'  ORDER BY TargetObjectId] ) {
                                      
                                      for (ProcessInstanceHistory pih : pi.StepsAndWorkItems) {
                                          String obj = String.valueOf(pi.TargetObjectId.getSObjectType()).split('__')[0];
                                          if(userinfo.getUserId()==pih.OriginalActorId || userinfo.getUserId() == pih.ActorId && obj=='Knowledge'){
                                              wrapperClass pendingApprovalWrap = new wrapperClass();
                                              pendingApprovalWrap.Status = pih.StepStatus;
                                              pendingApprovalWrap.RecordName = String.valueOf(pi.TargetObject.Name);
                                              pendingApprovalWrap.RecordId = String.valueOf(pi.TargetObjectId);
                                              pendingApprovalWrap.RecordObject = String.valueOf(pi.TargetObjectId.getSObjectType()).split('__')[0];
                                              pendingApprovalWrap.AssignedToName = String.valueOf(pih.OriginalActor.Name);
                                              pendingApprovalWrap.ApproverName = pih.Actor.Name;
                                              pendingApprovalWrap.CreatedDate = String.valueOf(pih.CreatedDate);
                                              
                                              wrapList.add(pendingApprovalWrap);
                                          }
                                      }          
                                  }
        return wrapList;
    }
    
    public class wrapperClass{
        @AuraEnabled
        public String Status {get; set;}
        @AuraEnabled
        public String RecordName {get; set;}
        @AuraEnabled
        public String RecordId {get; set;}
        @AuraEnabled
        public String RecordObject {get; set;}
        @AuraEnabled
        public String AssignedToName {get; set;}
        @AuraEnabled
        public String ApproverName {get; set;}
        @AuraEnabled
        public String CreatedDate {get; set;}
    }

}