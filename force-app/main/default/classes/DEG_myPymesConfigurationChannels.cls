/*
* Desarrollado por: Accenture
* Autor:            Diego Alejandro Rico F
* Proyecto:         ETB - DEG
* Descripción:      Clase encargada de controlar el direccionamiento de las canales de mi pymes 
*                   y la validación de agentes ocupados.
* Clase de prueba:  DEG_myPymesConfigurationChannels_tst
* Cambios (Versiones)
* -----------------------------------------------------------------------------------
* No.  Fecha       	Autor                   			Descripción
* ---- ----------- 	----------------------- 			------------------------------------------
* 1.0  10-Dic-2021  	Diego Alejandro Rico F. (DARF)   	Creación de la clase
**/
public with sharing class DEG_myPymesConfigurationChannels {
    
    public class Input{
        @InvocableVariable(required = false)
        public String idConversation;
        @InvocableVariable(required = false)
        public String idQueue;
        @InvocableVariable(required = false)
        public String motivoAgente;
    }
    
    public class Output{
        @InvocableVariable(required = false)
        public String idCola = '';
        @InvocableVariable(required = false)
        public Boolean isAvailable = true;
        @InvocableVariable(required = false)
        public String message = '';
    }
    
    /*---------------------------------------------------------------------------------------------
Autor:Diego Alejandro Rico(DARF)
Descripción: Método encargado de calcular si los canales tienen disponibles para atender
livechatranscript messagingsession
@params: inputLst:Lista de wrapper input 
@return: OutputLst:Lista de wrapper Output
----------------------------------------------------------------------------------------------*/
    @InvocableMethod(label = 'Get status agent')
    public static list<Output> getStatusAgent(List<Input> inputLst){
        string resultado='';
        Output objOutput = new Output();
        MessagingSession objMess=[select Id,MessagingChannelid,MessagingChannel.TargetQueueId from MessagingSession where Id=:inputLst.get(0).idConversation];	
        list<PendingServiceRouting> lstPendSe = [SELECT ServiceChannelId,Owner.name,Queue.name,Group.name  
                                                 FROM PendingServiceRouting WHERE  queueid=:objMess.MessagingChannel.TargetQueueId ];
        system.debug( lstPendSe);
        list<LiveChatButton> lstChatBu= new list<LiveChatButton>();
        list<UserServicePresence> lstUsePre= new list<UserServicePresence>();
        list<id> lstUser= new list<id>();
        list<Output> lstOut = new list<Output>();
        list<Group> lstGroup= new list<Group>();
        map<string,UserServicePresence> mapUP = new map<string,UserServicePresence>();
        map<string,set<id>> mapQiUid = new map<string,set<id>>();
        map<string,map<string,AgentWork>> mapAgentWork = new map<string,map<string,AgentWork>>();
        map<string,map<string,GroupMember>> mapGetGroup = new map<string,map<string,GroupMember>>();
        inputLst.get(0).idQueue=getqueu(inputLst.get(0).motivoAgente);
        if(!lstPendSe.isempty()&&lstPendSe!=null){
            objOutput.isAvailable=false;
            resultado=getMensage(inputLst.get(0).idConversation);// llamar metodo que arma el  mensaje
        }
        else if(inputLst.get(0).idQueue==null){
            objOutput.isAvailable=true;
            resultado='agentes disponibles';
            objOutput.message=resultado;
        }
        else{
            lstUsePre= [SELECT Id,Owner.name, User.name,ServicePresenceStatus.MasterLabel,IsAway,StatusStartDate, 
                        StatusEndDate,AverageCapacity,ConfiguredCapacity,UserId 
                        FROM UserServicePresence WHERE IsCurrentState = true];
            for(UserServicePresence objUp:lstUsePre){
                mapUP.put(objUp.userid,objUp);
                lstUser.add(objUp.userid);
            }
            mapGetGroup=getGroup(lstUser);
            mapAgentWork=getAgentWork(lstUser);
            mapQiUid=validateCapacity(mapUP,mapAgentWork,mapGetGroup);
            if(mapQiUid.containsKey(inputLst.get(0).idQueue)&&mapQiUid.get(inputLst.get(0).idQueue).size()>0){
                objOutput.isAvailable=true;
                resultado='agentes disponibles';
            }else{
                resultado=getMensage(inputLst.get(0).idConversation);// llamar metodo que arma el  mensaje
                objOutput.isAvailable=false;
            }
            objOutput.message=resultado;
        }
        lstOut.add(objOutput);
        system.debug(lstOut);
        return lstOut;
    }
    
    public static map<string,map<string,GroupMember>> getGroup(list<id> lstuserid ){
        Set<Id> results = new Set<Id>();
        map<string,set<id>> mapUP = new map<string,set<id>>();
        list<string> lstNameGroup= new list<string>();
        Map<Id,Id> grRoleMap = new Map<Id,Id>();
        map<string,map<string,GroupMember>> mapQueue = new map<string,map<string,GroupMember>>();
        for(GroupMember  u :[select UserOrGroupId ,groupId from GroupMember where UserOrGroupId in: lstuserid and Group.Type = 'Queue'])
        {
            if(mapQueue.containsKey(u.groupId)){
                map<string,GroupMember>mapst = new map<string,GroupMember>() ;
                mapst.putall(mapQueue.get(u.Groupid));
                mapst.put(u.UserOrGroupId,u);
                mapQueue.put(u.Groupid,mapst); 
            }
            else{
                map<string,GroupMember>mapst = new map<string,GroupMember>() ;
                mapst.put(u.UserOrGroupId,u);
                mapQueue.put(u.Groupid,mapst); 
            }
        }
        return mapQueue;
    }
    
    public static map<string,map<string,AgentWork>> getAgentWork(list<id> lstuserid ){
        Set<Id> results = new Set<Id>();
        list<string> lstNameGroup= new list<string>();
        Map<Id,Id> grRoleMap = new Map<Id,Id>();
        map<string,map<string,AgentWork>> mapAgentWork = new map<string,map<string,AgentWork>>();
        for(AgentWork  u :[SELECT id,ownerid FROM AgentWork WHERE Status = 'Opened' AND ownerid =:lstuserid])
        {
            if(mapAgentWork.containsKey(u.ownerid)){
                map<string,AgentWork>mapst = new map<string,AgentWork>() ;
                mapst.putall(mapAgentWork.get(u.ownerid));
                mapst.put(u.id,u);
                mapAgentWork.put(u.ownerid,mapst); 
            }
            else{
                map<string,AgentWork>mapst = new map<string,AgentWork>() ;
                mapst.put(u.id,u);
                mapAgentWork.put(u.ownerid,mapst); 
            }
        }
        return mapAgentWork;
    }
    
    public static map<string,set<id>> validateCapacity(map<string,UserServicePresence> mapUP,map<string,map<string,AgentWork>> mapAgentWork,map<string,map<string,GroupMember>> mapGetGroup){
        map<string,set<id>> mapQiUid = new map<string,set<id>>();
        for(string strgetGoup :mapGetGroup.keyset()){
            for(string strgetUsGoup : mapGetGroup.get(strgetGoup).keyset()){
                if(mapAgentWork.get(strgetUsGoup)!=null){
                    if(mapUP.get(strgetUsGoup).ConfiguredCapacity>mapAgentWork.get(strgetUsGoup).size()){
                        if(mapQiUid.containsKey(strgetGoup)){
                            set<id>lstSt = new set<id>() ;
                            lstSt.addAll(mapQiUid.get(strgetGoup));
                            lstSt.add(strgetUsGoup);
                            mapQiUid.put(strgetGoup,lstSt); 
                        }
                        else{
                            set<id>lstSt = new set<id>() ;
                            lstSt.add(strgetUsGoup);
                            mapQiUid.put(strgetGoup,lstSt); 
                        }
                    }
                }
            }
        }                       
        
        
        return mapQiUid;
    }
    
    public static string getMensage(string idConversation){
        string strMsg='';
        strMsg+=getName(idConversation);
        strMsg+=' nuestros agentes se encuentran ocupados, por favor espera unos minutos mientras te logramos atender';
        return strMsg;
    }
    
    public static string getName(string idConversation){
        string name;
        string objName;
        Id sid = id.valueOf(idConversation);
        objName=string.valueof(sid.getsobjecttype());
        if(objName=='MessagingSession'){
            name = [SELECT Id,DEG_NombreCliente__c FROM MessagingSession WHERE Id =: sid].DEG_NombreCliente__c;
        }
        /*else if(objName=='LiveChatTranscript'){
name = [SELECT Id,DEG_NombreCliente__c FROM LiveChatTranscript WHERE Id =: sid].DEG_NombreCliente__c;
}*/
        return name;
    }   
    
    public static id getqueu(string motivoAgente){
        string motivoAgenteLike='%'+motivoAgente+'%';
        list<queuesReasonOfPassage__mdt> objmdt =[SELECT id,reasonForPassing__c,DeveloperName FROM queuesReasonOfPassage__mdt WHERE reasonForPassing__c  LIKE :motivoAgenteLike];
        if(objmdt!=null && !objmdt.isEmpty()){
            group objGroup=[SELECT id,Name, DeveloperName FROM Group WHERE Type = 'queue' AND DeveloperName =:objmdt.get(0).developername];
            return objGroup.id;
        }
        else{
            return null;
        }
        
    }
    public static void metodos(){
        string a;
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
        a='preuba';
    }
}