/**
 * @description       : 
 * @author            : j.martinez.mercado
 * @group             : 
 * @last modified on  : 05-05-2022
 * @last modified by  : j.martinez.mercado@accenture.com
**/
@IsTest(SeeAllData=true)
public with sharing class DEG_LlenarReporteProveedor_tst {
    @IsTest
    public static void testLlenarReporte() {
        System.runAs(new User(Id = UserInfo.getUserId())) {
            DE_reporte_por_proveedor__c tmpReport = new DE_reporte_por_proveedor__c();
            tmpReport.AHT_Promedio__c = 0;
            tmpReport.ASA__c = 0;
            tmpReport.Canal_de_Atencion__c = 'Chat';
            tmpReport.CaseId__c = '5002900000CqM8KAAV';
            tmpReport.Fecha_del_Caso__c = DateTime.now();
            tmpReport.Estado_del_Caso__c = 'Resuelto';
            tmpReport.Nivel_de_Atencion__c = 0;
            tmpReport.Nivel_de_Servicio__c = 0;
            tmpReport.Nombre_del_Agente__c = 'deer';
            tmpReport.Nombre_del_Proveedor__c = 'Proveedor 1';
            tmpReport.Numero_del_Caso__c = '01832153';
            tmpReport.Porcentaje_de_Abandono__c = 0;
            insert tmpReport;

            List<User> tstUsers = DE_DataFactoryReports.getUsers(21);
            List<Group> tstGroups = [SELECT Id FROM Group WHERE DeveloperName LIKE 'DEG_Proveedor%'];
            try{
                List<GroupMember> tstMembers = DE_DataFactoryReports.getGroupMembers(tstUsers, tstGroups);
                System.debug('Miembros Grupo: '+ tstMembers);
            }catch(Exception e){
                System.debug('ERRoR: ' + e);
            }
            List<Case> tstCasesMs = new List<Case>();
            List<Case> tstCasesLct = new List<Case>();
            tstCasesMs = DE_DataFactoryReports.getCases(tstUsers);
            tstCasesLct = DE_DataFactoryReports.getCases(tstUsers);
            DE_DataFactoryReports.generateData(tstUsers);
            AgentWork aw = new AgentWork();
            System.debug('ServiceChannels: '+[select Id from ServiceChannel limit 10]);
            for (ServiceChannel sc : [select Id from ServiceChannel limit 10]){
                try {
                    aw.ServiceChannelId = sc.Id;
                    insert aw;
                    break;
                }catch(Exception e) {
                    System.debug(LoggingLevel.INFO, 'Error: '+e);
                    System.debug(LoggingLevel.INFO, 'Service channel with id '+sc.Id+' is invalid');
                }
            }
            System.debug('Chat Transcripts: ' + [SELECT Id FROM LiveChatTranscript LIMIT 10]);
        	Test.startTest();
            	DEG_LlenarReportePorProveedor_cls.execute(null);
        	Test.stopTest();
        }
    }
}