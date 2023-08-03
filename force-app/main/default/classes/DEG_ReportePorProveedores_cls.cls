/**
 * @description       : Clase para llenar el objeto perzonalizado DE_reporte_por_proveedor__c
 * @author            : j.martinez.mercado
 * @group             : Digital Engagement Accenture
 * @last modified on  : 05-05-2022
 * @last modified by  : j.martinez.mercado@accenture.com
**/
public with sharing class DEG_ReportePorProveedores_cls {

    public class DataCase{
        public DateTime createdDate;
        public String caseNumber;
        public String status;
        public String origin;
        public Id ownerId;
    }
    public class DataReporte{
        public Id reporteId;
        public String statusCase;
    }
    public class DataIndicadores{
        public Map<Id,Decimal> ASAs;
        public Map<Id,Decimal> AHTs;
    }
    public class Indicadores{
        public Decimal ASA; // Tiempo promedio que el agente demora en contestar
        public Decimal AHT; // Tiempo promedio de duracion de la conversacion
        public Decimal NA;  // Nivel de Atencion ((resueltos)/(recibidos-abandonados))
    }

    public static void setRecordsInReportePorProveedor(){
        //Lista a guardar
        List<DE_reporte_por_proveedor__c> reportesXproveedor = new List<DE_reporte_por_proveedor__c>();
        //Segmentos
        Set<String> segmentos = new Set<String>{'Masivo', 'MiPymes'};
        //Ids y estados de los casos en los reportes
        Map<String, DataReporte> caseIdsFromReport = new Map<String, DataReporte>();
        for(DE_reporte_por_proveedor__c customReport : (Test.isRunningTest() ? [SELECT Id, CaseId__c, Estado_del_Caso__c FROM DE_reporte_por_proveedor__c WHERE Fecha_del_Caso__c >= LAST_N_DAYS: 10 ORDER BY Fecha_del_Caso__c] : [SELECT Id, CaseId__c, Estado_del_Caso__c FROM DE_reporte_por_proveedor__c WHERE Fecha_del_Caso__c >= TODAY ORDER BY Fecha_del_Caso__c])){
            DataReporte tmpData = new DataReporte();
            tmpData.reporteId = customReport.Id;
            tmpData.statusCase = customReport.Estado_del_Caso__c;
            caseIdsFromReport.put(customReport.CaseId__c, tmpData);
        }
        Integer sizeOfList = 0;
        //Supervisores
        Map<Id,String> supervisores = new Map<Id, String>();
        List<OmniSupervisorConfigUser> supervisor = [SELECT UserId, User.Name
                                                     FROM OmniSupervisorConfigUser 
                                                     WHERE OmniSupervisorConfigId IN 
                                                            (SELECT Id 
                                                            FROM OmniSupervisorConfig 
                                                            WHERE DeveloperName LIKE 'DEG_SupervisorEtbProveedor%')];
        sizeOfList = supervisor.size();
        for (Integer i = 0; i < sizeOfList; i++) {
            supervisores.put(supervisor[i].UserId, supervisor[i].User.Name);
        }
        //Agentes
        Map<Id, String> agentes = new Map<Id, String>();
        List<User> agente = [SELECT Id, Name 
                             FROM User 
                             WHERE Id NOT IN: supervisores.keySet() AND 
                             Id IN (SELECT UserOrGroupId 
                                    FROM GroupMember 
                                    WHERE Group.DeveloperName LIKE 'DEG_Proveedor%')];
        sizeOfList = agente.size();
        for (Integer i = 0; i < sizeOfList; i++) {
            agentes.put(agente[i].Id, agente[i].Name);
        }
        //Grupos
        Map<Id, String> usuariosGrupo = new Map<Id, String>();
        Map<Id, String> supervisoresGrupo = new Map<Id, String>();
        Map<Id, String> agentesGrupo = new Map<Id, String>();
        Map<Id, String> usuariosIdGrupo = new Map<Id, String>();
        Map<String, Map<Id, String>> pASs = new Map<String, Map<Id, String>>(); //(NombreProveedor:{IdAgente:NombreSupervisor})
        List<GroupMember> grupo = [SELECT UserOrGroupId, Group.Name, Group.DeveloperName 
                                   FROM GroupMember 
                                   WHERE Group.DeveloperName LIKE 'DEG_Proveedor%'];
        sizeOfList = grupo.size();
        for (Integer i = 0; i < sizeOfList; i++) {
            usuariosGrupo.put(grupo[i].UserOrGroupId, grupo[i].Group.Name);
            usuariosIdGrupo.put(grupo[i].UserOrGroupId, grupo[i].Group.DeveloperName);
            if (supervisores.containsKey(grupo[i].UserOrGroupId)) {
                supervisoresGrupo.put(grupo[i].UserOrGroupId, grupo[i].Group.Name);
            }
            else {
                agentesGrupo.put(grupo[i].UserOrGroupId, grupo[i].Group.Name);
            }
        }
        //Casos
        Map<Id, DataCase> casosAgente = new Map<Id, DataCase>();
        //Casos Abandonados
        Map<Id,Integer> casosAbandonados = new Map<Id,Integer>();
        //Casos Recibidos
        Map<Id,Integer> casosRecibidos = new Map<Id,Integer>();
        //Casos Resueltos
        Map<Id,Integer> casosResueltos = new Map<Id,Integer>();
        List<Case> caso = Test.isRunningTest() ? [SELECT CreatedDate, OwnerId, CaseNumber, Status, Origin 
                                                    FROM Case 
                                                    WHERE OwnerId IN: agentes.keySet() AND CreatedDate >= LAST_N_DAYS: 10]
        : [SELECT CreatedDate, OwnerId, CaseNumber, Status, Origin 
                           FROM Case 
                           WHERE OwnerId IN: agentes.keySet() AND DEG_Segmento__c IN: segmentos AND CreatedDate >= TODAY]; 
        sizeOfList = caso.size();
        System.debug('Total casos: ' + sizeOfList);
        for (Integer i = 0; i < sizeOfList; i++) {
            Id tmpUserId = caso[i].OwnerId;
            if(!casosRecibidos.containsKey(tmpUserId)){
                casosRecibidos.put(tmpUserId, 1);
            }else{
                casosRecibidos.put(tmpUserId, casosRecibidos.get(tmpUserId)+1);
            }
            DataCase tmpCase = new DataCase();
            tmpCase.createdDate = caso[i].CreatedDate;
            tmpCase.caseNumber = caso[i].CaseNumber;
            tmpCase.status = caso[i].Status;
            tmpCase.origin = caso[i].Origin;
            tmpCase.ownerId = tmpUserId;
            casosAgente.put(caso[i].Id, tmpCase);
            switch on caso[i].Status {
                when 'Resuelto','Resuelto Automatico'{
                    if(!casosResueltos.containsKey(tmpUserId)){
                        casosResueltos.put(tmpUserId, 1);
                    }else{
                        casosResueltos.put(tmpUserId, casosResueltos.get(tmpUserId)+1);
                    }
                }
                when 'Abandono'{
                    if(!casosAbandonados.containsKey(tmpUserId)){
                        casosAbandonados.put(tmpUserId, 1);
                    }else{
                        casosAbandonados.put(tmpUserId, casosAbandonados.get(tmpUserId)+1);
                    }
                }
            }
        }
        //MessagingSessions
        List<MessagingSession> msList = Test.isRunningTest() ? [SELECT OwnerId, Name, CaseId 
                                                                FROM MessagingSession 
                                                                WHERE OwnerId IN: agentes.keySet() AND CreatedDate >= LAST_N_DAYS: 10]
        :[SELECT OwnerId, Name, CaseId 
            FROM MessagingSession 
            WHERE OwnerId IN: agentes.keySet() AND Case.DEG_Segmento__c IN: segmentos AND CreatedDate >= TODAY];
        //Indicadores MessagingSessions
        Map<Id, Indicadores> msIndicadores = new Map<Id, Indicadores>();
        Map<Id,DataIndicadores> tiemposMessRespAgente = new Map<Id,DataIndicadores>();
        Set<Id> idsMessaging = new Set<Id>();
        for (MessagingSession session : msList) {
            idsMessaging.add(session.Id);
        }
        for (AgentWork work : [SELECT UserId, HandleTime, SpeedToAnswer, WorkItemId  FROM AgentWork WHERE WorkItemId IN: idsMessaging]) {
            try {
                if(!tiemposMessRespAgente.containsKey(work.UserId) && agentes.containsKey(work.UserId)){
                    DataIndicadores tmpIndicadores = new DataIndicadores();
                    Map<Id,Decimal> tmpTimeResp = new Map<Id,Decimal>();
                    Map<Id,Decimal> tmpTimeHand = new Map<Id,Decimal>();
                    tmpTimeResp.put(work.WorkItemId, work.SpeedToAnswer);
                    tmpTimeHand.put(work.WorkItemId, work.HandleTime);
                    tmpIndicadores.ASAs = tmpTimeResp;
                    tmpIndicadores.AHTs = tmpTimeHand;
                    tiemposMessRespAgente.put(work.UserId, tmpIndicadores);
                }
                else if(tiemposMessRespAgente.containsKey(work.UserId) && agentes.containsKey(work.UserId)){
                    DataIndicadores tmpIndicadores = new DataIndicadores();
                    Map<Id,Decimal> tmpTimeResp = new Map<Id,Decimal>();
                    Map<Id,Decimal> tmpTimeHand = new Map<Id,Decimal>();
                    tmpTimeResp.put(work.WorkItemId, work.SpeedToAnswer);
                    tmpTimeHand.put(work.WorkItemId, work.HandleTime);
                    tmpTimeResp.putAll(tiemposMessRespAgente.get(work.UserId).ASAs);
                    tmpTimeHand.putAll(tiemposMessRespAgente.get(work.UserId).AHTs);
                    tmpIndicadores.ASAs = tmpTimeResp;
                    tmpIndicadores.AHTs = tmpTimeHand;
                    tiemposMessRespAgente.put(work.UserId, tmpIndicadores);
                }
            } catch (Exception e) {
                System.debug('Error en indicadores Mess: ' + e);
                continue;
            }
        }
        Map<Id, Decimal> agenteMSASA = new Map<Id, Decimal>();
        Map<Id, Decimal> agenteMSAHT = new Map<Id, Decimal>();
        for (Id agenteId : tiemposMessRespAgente.keySet()) {
            try{
                Decimal tmpNumASA = 0;
                Decimal tmpNumAHT = 0;
                    for (Decimal tiempo : tiemposMessRespAgente.get(agenteId).ASAs.values()) {
                        tmpNumASA += tiempo;
                    }
                    for (Decimal tiempo : tiemposMessRespAgente.get(agenteId).AHTs.values()) {
                        tmpNumAHT += tiempo;
                    }
                agenteMSASA.put(agenteId, (Decimal) tmpNumASA/tiemposMessRespAgente.get(agenteId).ASAs.values().size());
                agenteMSAHT.put(agenteId, (Decimal) tmpNumAHT/tiemposMessRespAgente.get(agenteId).AHTs.values().size());
            }
            catch(Exception e){
                System.debug('Error en Tiempos Mess: '+e);
                continue;
            }
        }
        sizeOfList = msList.size();
        for (Integer i = 0; i < sizeOfList; i++) {
            Indicadores indicador = new Indicadores();
            Id tmpOwnerId = (Id) msList[i].get('OwnerId');
            if(agenteMSASA.containsKey(tmpOwnerId)){
                indicador.ASA = agenteMSASA.get(tmpOwnerId);
            }else{
                indicador.ASA = 0;
            }
            if(agenteMSASA.containsKey(tmpOwnerId)){
                indicador.AHT = agenteMSAHT.get(tmpOwnerId);
            }else{
                indicador.AHT = 0;
            }
            if(casosAbandonados.containsKey(tmpOwnerId) && casosRecibidos.containsKey(tmpOwnerId) && casosResueltos.containsKey(tmpOwnerId)){
                indicador.NA = (Decimal) (casosResueltos.get(tmpOwnerId))/(casosRecibidos.get(tmpOwnerId)-casosAbandonados.get(tmpOwnerId));
            }
            else if(!casosAbandonados.containsKey(tmpOwnerId) && (casosRecibidos.containsKey(tmpOwnerId) && casosResueltos.containsKey(tmpOwnerId))){
                indicador.NA = (Decimal) (casosResueltos.get(tmpOwnerId))/(casosRecibidos.get(tmpOwnerId));
            }
            else{
                indicador.NA = 0;
            }
            msIndicadores.put(tmpOwnerId, indicador);
        }
        //LiveChatTranscript
        List<LiveChatTranscript> lctList = Test.isRunningTest() ? [SELECT OwnerId, Name, CaseId
        FROM LiveChatTranscript 
        WHERE OwnerId IN: agentes.keySet() AND CreatedDate >= LAST_N_DAYS: 10]
        :[SELECT OwnerId, Name, CaseId
          FROM LiveChatTranscript 
          WHERE OwnerId IN: agentes.keySet() AND Case.DEG_Segmento__c IN: segmentos AND CreatedDate >= TODAY];
        //Indicadores LiveChatTranscripts
        Map<Id, Indicadores> lctIndicadores = new Map<Id, Indicadores>();
        Map<Id,DataIndicadores> tiemposLiveRespAgente = new Map<Id,DataIndicadores>();
        Set<Id> idsLive = new Set<Id>();
        for (LiveChatTranscript session : lctList) {
            idsLive.add(session.Id);
        }
        for (AgentWork work : [SELECT UserId, HandleTime, SpeedToAnswer, WorkItemId  FROM AgentWork WHERE WorkItemId IN: idsLive]) {
            try {
                if(!tiemposLiveRespAgente.containsKey(work.UserId) && agentes.containsKey(work.UserId)){
                    DataIndicadores tmpIndicadores = new DataIndicadores();
                    Map<Id,Decimal> tmpTimeResp = new Map<Id,Decimal>();
                    Map<Id,Decimal> tmpTimeHand = new Map<Id,Decimal>();
                    tmpTimeResp.put(work.WorkItemId, work.SpeedToAnswer);
                    tmpTimeHand.put(work.WorkItemId, work.HandleTime);
                    tmpIndicadores.ASAs = tmpTimeResp;
                    tmpIndicadores.AHTs = tmpTimeHand;
                    tiemposLiveRespAgente.put(work.UserId, tmpIndicadores);
                }
                else if (tiemposLiveRespAgente.containsKey(work.UserId) && agentes.containsKey(work.UserId)){
                    DataIndicadores tmpIndicadores = new DataIndicadores();
                    Map<Id,Decimal> tmpTimeResp = new Map<Id,Decimal>();
                    Map<Id,Decimal> tmpTimeHand = new Map<Id,Decimal>();
                    tmpTimeResp.put(work.WorkItemId, work.SpeedToAnswer);
                    tmpTimeHand.put(work.WorkItemId, work.HandleTime);
                    tmpTimeResp.putAll(tiemposLiveRespAgente.get(work.UserId).ASAs);
                    tmpTimeHand.putAll(tiemposLiveRespAgente.get(work.UserId).AHTs);
                    tmpIndicadores.ASAs = tmpTimeResp;
                    tmpIndicadores.AHTs = tmpTimeHand;
                    tiemposLiveRespAgente.put(work.UserId, tmpIndicadores);
                }
            } catch (Exception e) {
                System.debug('Error en Indicadores Live: '+e);
                continue;
            }

        }
        Map<Id, Decimal> agenteLTASA = new Map<Id, Decimal>();
        Map<Id, Decimal> agenteLTAHT = new Map<Id, Decimal>();
        for (Id agenteId : tiemposLiveRespAgente.keySet()) {
            try{
                Decimal tmpNumASA = 0;
                Decimal tmpNumAHT = 0;
                    for (Decimal tiempo : tiemposLiveRespAgente.get(agenteId).ASAs.values()) {
                        tmpNumASA += tiempo;
                    }
                    for (Decimal tiempo : tiemposLiveRespAgente.get(agenteId).AHTs.values()) {
                        tmpNumAHT += tiempo;
                    }
                agenteLTASA.put(agenteId, (Decimal) tmpNumASA/tiemposLiveRespAgente.get(agenteId).ASAs.values().size());
                agenteLTAHT.put(agenteId, (Decimal) tmpNumAHT/tiemposLiveRespAgente.get(agenteId).AHTs.values().size());
            }
            catch(Exception e){
                System.debug('Error en Tiempos live: ' + e);
                continue;
            }
        }
        sizeOfList = lctList.size();
        for (Integer i = 0; i < sizeOfList; i++) {
            Indicadores indicador = new Indicadores();
            Id tmpOwnerId = (Id) lctList[i].get('OwnerId');
            if(agenteLTASA.containsKey(tmpOwnerId)){
                indicador.ASA = (Decimal) agenteLTASA.get(tmpOwnerId);
            }else{
                indicador.ASA = 0;
            }
            if(agenteLTAHT.containsKey(tmpOwnerId)){
                indicador.AHT = (Decimal) agenteLTAHT.get(tmpOwnerId);
            }else{
                indicador.AHT = 0;
            }
            if(casosAbandonados.containsKey(tmpOwnerId) && casosRecibidos.containsKey(tmpOwnerId) && casosResueltos.containsKey(tmpOwnerId)){
                indicador.NA = (Decimal) (casosResueltos.get(tmpOwnerId))/(casosRecibidos.get(tmpOwnerId)-casosAbandonados.get(tmpOwnerId));
            }
            else if(!casosAbandonados.containsKey(tmpOwnerId) && (casosRecibidos.containsKey(tmpOwnerId) && casosResueltos.containsKey(tmpOwnerId))){
                indicador.NA = (Decimal) (casosResueltos.get(tmpOwnerId))/(casosRecibidos.get(tmpOwnerId));
            }
            else{
                indicador.NA = 0;
            }
            lctIndicadores.put(tmpOwnerId, indicador);
        }
     
        //Llenado de datos
        sizeOfList = msList.size();
        for (Integer i = 0; i < sizeOfList; i++) {
            try{
                Id tmpOwnerId = msList[i].OwnerId;
                Id tmpMSId = msList[i].Id;
                DataCase tmpData = casosAgente.get(msList[i].CaseId);
                DE_reporte_por_proveedor__c tmpReport = new DE_reporte_por_proveedor__c();
                tmpReport.AHT_Promedio__c = msIndicadores.get(tmpOwnerId).AHT;
                tmpReport.ASA__c = msIndicadores.get(tmpOwnerId).ASA;
                tmpReport.Canal_de_Atencion__c = tmpData.origin;
                tmpReport.CaseId__c = msList[i].CaseId;
                tmpReport.Fecha_del_Caso__c = tmpData.createdDate;
                tmpReport.Estado_del_Caso__c = tmpData.Status;
                tmpReport.Nivel_de_Atencion__c = (Decimal) msIndicadores.get(tmpOwnerId).NA*100.00;
                if(tiemposMessRespAgente.get(tmpOwnerId).ASAs.containsKey(tmpMSId)){
                    tmpReport.Nivel_de_Servicio__c = tiemposMessRespAgente.get(tmpOwnerId).ASAs.get(tmpMSId);
                }else{
                    tmpReport.Nivel_de_Servicio__c = 0;
                }
                tmpReport.Nombre_del_Agente__c = agentes.get(tmpOwnerId);
                tmpReport.Nombre_del_Proveedor__c = usuariosGrupo.get(tmpOwnerId);
                tmpReport.Id_Proveedor__c = usuariosIdGrupo.get(tmpOwnerId);
                tmpReport.Numero_del_Caso__c = tmpData.caseNumber;
                if(casosAbandonados.containsKey(tmpOwnerId) && casosRecibidos.containsKey(tmpOwnerId)){
                    tmpReport.Porcentaje_de_Abandono__c	= (decimal) casosAbandonados.get(tmpOwnerId)*100.00 / casosRecibidos.get(tmpOwnerId);
                }else{
                    tmpReport.Porcentaje_de_Abandono__c = 0;
                }
                reportesXproveedor.add(tmpReport);
            }catch(Exception e){
                System.debug('Error en Message for: ' + e);
                continue;
            }
        }
        sizeOfList = lctList.size();
        for (Integer i = 0; i < sizeOfList; i++) {
            try{
                Id tmpOwnerId = lctList[i].OwnerId;
                Id tmpLTId = lctList[i].Id;
                DataCase tmpData = casosAgente.get(lctList[i].CaseId);
                DE_reporte_por_proveedor__c tmpReport = new DE_reporte_por_proveedor__c();
                tmpReport.AHT_Promedio__c = lctIndicadores.get(tmpOwnerId).AHT;
                tmpReport.ASA__c = lctIndicadores.get(tmpOwnerId).ASA;
                tmpReport.Canal_de_Atencion__c = tmpData.origin;
                tmpReport.CaseId__c = lctList[i].CaseId;
                tmpReport.Fecha_del_Caso__c = tmpData.createdDate;
                tmpReport.Estado_del_Caso__c = tmpData.Status;
                tmpReport.Nivel_de_Atencion__c = (Decimal) lctIndicadores.get(tmpOwnerId).NA*100.00;
                if(tiemposLiveRespAgente.get(tmpOwnerId).ASAs.containsKey(tmpLTId)){
                    tmpReport.Nivel_de_Servicio__c = tiemposLiveRespAgente.get(tmpOwnerId).ASAs.get(tmpLTId);
                }else{
                    tmpReport.Nivel_de_Servicio__c = 0;
                }
                tmpReport.Nombre_del_Agente__c = agentes.get(tmpOwnerId);
                tmpReport.Nombre_del_Proveedor__c = usuariosGrupo.get(tmpOwnerId);
                tmpReport.Id_Proveedor__c = usuariosIdGrupo.get(tmpOwnerId);
                tmpReport.Numero_del_Caso__c = tmpData.caseNumber;
                if(casosAbandonados.containsKey(tmpOwnerId) && casosRecibidos.containsKey(tmpOwnerId)){
                    tmpReport.Porcentaje_de_Abandono__c	= (decimal) casosAbandonados.get(tmpOwnerId)*100.00 / casosRecibidos.get(tmpOwnerId);
                }else{
                    tmpReport.Porcentaje_de_Abandono__c = 0;
                }
                reportesXproveedor.add(tmpReport);
            }catch(Exception e){
                System.debug('Error en live for: ' + e);
                continue;
            }
        }

        System.debug('Total reportes: ' + reportesXproveedor.size());
        List<DE_reporte_por_proveedor__c> newReports = new List<DE_reporte_por_proveedor__c>();
        List<DE_reporte_por_proveedor__c> updatedReports = new List<DE_reporte_por_proveedor__c>();
        for(DE_reporte_por_proveedor__c reporte : reportesXproveedor){
            if(!caseIdsFromReport.containsKey(reporte.CaseId__c)){
                newReports.add(reporte);
            }
            else if(caseIdsFromReport.containsKey(reporte.CaseId__c) && caseIdsFromReport.get(reporte.CaseId__c).statusCase != reporte.Estado_del_Caso__c){
                Id tmpReportId = caseIdsFromReport.get(reporte.CaseId__c).reporteId;
                DE_reporte_por_proveedor__c tmpReporte = reporte;
                tmpReporte.Id = tmpReportId;
                updatedReports.add(tmpReporte);
            }
        }
        Integer totalRegistros = newReports.size()+updatedReports.size();
        if(newReports.size() > 0){
            insert newReports;
            System.debug('Total insertados: '+ newReports.size());
        }
        if(updatedReports.size() > 0){
            update updatedReports;
            System.debug('Total actualizados: '+ updatedReports.size());
        }
        System.debug('Total registros agregados: '+ totalRegistros);
        
    }
}