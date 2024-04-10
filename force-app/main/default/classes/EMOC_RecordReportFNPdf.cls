/*------------------------------------------------------------
Author      : Janejira Pattanakul.
Company     : M INTEL
Create Date : 2023-04-24
Test Class  : EMOC_RecordReportPdfTest
Visualforce page : EMOC_RecordReportFNPdf
Description : Print out PDF Common Workflow.
--------------------------------------------------------------
History Log :
<Change Code>      <Date>        <Authors Name>       <Desciption>
                   2023-04-24    Janejira P.          Print out PDF Common Workflow.
------------------------------------------------------------*/
public without sharing class EMOC_RecordReportFNPdf {
    public static E_MOC_Application__c emocApp {get; set;}

    public static List<TableApprovalHistoryPdf> tableApprovalHistory {get; set;}
    public static List<PotentialCon> PotentialConsequenceList {get; set;}
    public static List<Mitigation> MitigationPrecautionList {get; set;}
    
    public class TableApprovalHistoryPdf {
        public ID Id { get;  set; }
        public String StepName { get;  set; }
        public String Approver { get;  set; }
        public String Comments { get;  set; }
        public String Status { get;  set; }
        public String CreatedDate {get; set;}
        public String ActualApprover { get;  set; }
    }
    public class PotentialCon {
        public String Topic { get;  set; }
        public String Other { get;  set; }
    }
    public class Mitigation {
        public String Topic { get;  set; }
        public String Other { get;  set; }
    }
    
    public EMOC_RecordReportFNPdf(){
        PageReference pageRef = ApexPages.currentPage();
        String emocId = pageRef.getParameters().get('id');
        //String emocId = 'a1x6D000000956JQAQ'; // for testing
        
        emocApp = [SELECT   Id, Name, FN_Category_Type__c,Functional_Location__r.Name,Functional_Location_Description__c,Main_Work_Center__c,
                            Requestor_Name__r.Name,CreatedDate,Notification_Number__c,Start_date__c,End_date__c,
                            RAM_Total__c,RAM_Total_Final__c,Status_Functional_Override__c,Notification_Status__c,
                            Reason_of_Work__c, Potential_Risk_c__c,Other__c,Potential_Consequence_c__c, Mitigation_Precaution_1__c
                       FROM E_MOC_Application__c
                       WHERE id =: emocId];
        
        ApprovalHistory();
        PotentialConsequence();
        MitigationPrecaution();
    }
    
    public static void ApprovalHistory (){
        PageReference pageRef = ApexPages.currentPage();
        String emocId = pageRef.getParameters().get('id');
        //String emocId = 'a1x6D000000956JQAQ'; // for testing

        tableApprovalHistory = new List<TableApprovalHistoryPdf>();
         
        List<Map<String, String>> valuesList = new List<Map<String, String>>(); 
        List<ProcessInstanceWorkitem> piWork = [Select Id,CreatedDate, OriginalActor.Name, Actor.Name, ProcessInstance.ProcessDefinition.Name, ProcessInstance.status, ProcessInstance.TargetObjectId 
                                                from ProcessInstanceWorkitem  where ProcessInstance.TargetObjectId = :emocId  ORDER BY createdDate DESC, Id DESC ];
        if (piWork.size() > 0) {
            E_MOC_Application__c[] emocApp 		= [SELECT Id, Status_Common_Workflow__c,Status_Functional_Override__c ,Step__c,CreatedById  FROM E_MOC_Application__c WHERE Id = :piWork[0].ProcessInstance.TargetObjectId Limit 1];
            E_MOC_Hold_History__c[] emocHold 	= [SELECT Id, E_MOC_Application__c  FROM E_MOC_Hold_History__c 
                                                    WHERE   E_MOC_Application__c = :emocApp[0].Id
                                                    AND Step__c 	= :emocApp[0].Step__c 
                                                    AND CreatedById = :emocApp[0].CreatedById
                                                    AND (Status__c 	= :emocApp[0].Status_Common_Workflow__c
                                                         OR Status__c 	= :emocApp[0].Status_Functional_Override__c)
                                                    Limit 1];
 
            for( ProcessInstanceWorkitem listVal : piWork){
                TableApprovalHistoryPdf appHis = new TableApprovalHistoryPdf();
                appHis.Id = listVal.Id;
                appHis.StepName = listVal.ProcessInstance.ProcessDefinition.Name;
                appHis.Approver = listVal.OriginalActor.Name;
                appHis.Comments = '';
                if (emocHold.size() > 0) {
                    appHis.Status = 'Hold';
                } else {
                    appHis.Status = listVal.ProcessInstance.status;
                }
                DateTime CreatedDate = listVal.CreatedDate;
                String myDate = CreatedDate.format('dd/MM/YYYY HH:mm');
                appHis.CreatedDate = myDate;
                appHis.ActualApprover = listVal.Actor.Name;
                tableApprovalHistory.add(appHis);   
            }
         }
        
         List<ProcessInstanceStep> piStep = [SELECT Id, StepNodeId, OriginalActor.Name, Actor.Name, Comments, StepStatus, CreatedDate, ProcessInstance.TargetObjectId 
                                            FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId = :emocId AND Comments != 'submit!' ORDER BY createdDate DESC, Id DESC ];
        
         if (piStep.size() > 0) {
            E_MOC_Application__c[] emocAppSt = [SELECT Id, Status_Common_Workflow__c, Status_Functional_Override__c ,Step__c, CreatedById  FROM E_MOC_Application__c WHERE Id = :piStep[0].ProcessInstance.TargetObjectId Limit 1];
            
            E_MOC_Hold_History__c[] emocHoldSt = [SELECT Id, E_MOC_Application__c  FROM E_MOC_Hold_History__c 
                                                  WHERE   E_MOC_Application__c = :emocAppSt[0].Id
                                                  AND Step__c 	  = :emocAppSt[0].Step__c 
                                                  AND CreatedById = :emocAppSt[0].CreatedById
                                                  AND (Status__c  = :emocAppSt[0].Status_Common_Workflow__c
                                                       OR Status__c = :emocAppSt[0].Status_Functional_Override__c)
                                                  Limit 1];
            
            for( ProcessInstanceStep listVal : piStep){
                TableApprovalHistoryPdf appHis = new TableApprovalHistoryPdf();
                appHis.Id = listVal.Id;
                
                ProcessNode[] Pn = [SELECT Id, Description, DeveloperName, Name FROM ProcessNode where Id = :listVal.StepNodeId limit 1 ];
                
                if (Pn.size() > 0) {
                     appHis.StepName = Pn[0].Name;
                } else {
                     appHis.StepName = 'Approval Request Submitted';
                }
        
                appHis.Approver = listVal.OriginalActor.Name;
                appHis.Comments = listVal.Comments;
                
                if (listVal.StepStatus == 'Removed') {
                    appHis.Status = 'Send back';
                } else if (listVal.StepStatus == 'Started') {
                    appHis.Status = 'Submitted';
                } else if (listVal.StepStatus == 'NoResponse') {
                    appHis.Status = 'N/A';
                } else {
                    if (emocHoldSt.size() > 0) {
                        appHis.Status = 'Hold';
                    } else {
                        appHis.Status = listVal.StepStatus;
                    }
                }

                DateTime CreatedDate = listVal.CreatedDate;
                String myDate = CreatedDate.format('dd/MM/YYYY HH:mm');
                appHis.CreatedDate = myDate;
                appHis.ActualApprover = listVal.Actor.Name;
				tableApprovalHistory.add(appHis);   
            }
        }
    }
    
    public static void PotentialConsequence() {
        PageReference pageRef = ApexPages.currentPage();
        String emocId = pageRef.getParameters().get('id');
        //String emocId = 'a1x6D000000956JQAQ'; // for testing
        List<E_MOC_Prelim_Risk__c> PrelimRiskList = [SELECT Id, E_MOC_Application__c, Topic__c, Comment__c, Type__c
                                                     FROM E_MOC_Prelim_Risk__c
                                                     WHERE E_MOC_Application__c = :emocId 
                                                     AND Type__c = 'Potential Consequence' ];
        PotentialConsequenceList = new List<PotentialCon>();
        
        FOR (E_MOC_Prelim_Risk__c potentialCon:PrelimRiskList) {
            PotentialCon po = new PotentialCon();
            po.Topic = potentialCon.Topic__c;
            po.Other = potentialCon.Comment__c;
            PotentialConsequenceList.add(po);
        }
    }
    
    public static void MitigationPrecaution() {
        PageReference pageRef = ApexPages.currentPage();
        String emocId = pageRef.getParameters().get('id');
        //String emocId = 'a1x6D000000956JQAQ'; // for testing
        List<E_MOC_Prelim_Risk__c> PrelimRiskList = [SELECT Id, E_MOC_Application__c, Topic__c, Comment__c, Type__c
                                                     FROM E_MOC_Prelim_Risk__c
                                                     WHERE E_MOC_Application__c = :emocId
                                                     AND Type__c = 'Mitigation/Precaution'];
        List<Map<String, Object>> mitigationPreReturn = new List<Map<String, Object>>();
        MitigationPrecautionList = new List<Mitigation>();
        
        FOR (E_MOC_Prelim_Risk__c mitigationPre:PrelimRiskList) {
            Mitigation mi = new Mitigation();
            mi.Topic = mitigationPre.Topic__c;
            mi.Other = mitigationPre.Comment__c;
            MitigationPrecautionList.add(mi);
        }
    }
}