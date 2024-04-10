/*------------------------------------------------------------
Author      : Janejira Pattanakul.
Company     : M INTEL
Create Date : 2023-04-24
Test Class  : EMOC_RecordReportPdfTest
Visualforce page : EMOC_RecordReportPdf
Description : Print out PDF Common Workflow.
--------------------------------------------------------------
History Log :
<Change Code>      <Date>        <Authors Name>       <Desciption>
                   2023-04-24    Janejira P.          Print out PDF Common Workflow.
------------------------------------------------------------*/
public without sharing class EMOC_RecordReportPdf {
    public static E_MOC_Application__c emocApp {get; set;}

    public static List<TableApprovalHistoryPdf> tableApprovalHistory {get; set;}
    
    public class TableApprovalHistoryPdf {
        public ID Id { get;  set; }
        public String StepName { get;  set; }
        public String Approver { get;  set; }
        public String Comments { get;  set; }
        public String Status { get;  set; }
        public String CreatedDate {get; set;}
        public String ActualApprover { get;  set; }
    }
    
    public EMOC_RecordReportPdf(){
        PageReference pageRef = ApexPages.currentPage();
        String emocId = pageRef.getParameters().get('id');
       // emocId = 'a1x6D000000zAEtQAM'; // for testing
        
        emocApp = [SELECT   Id, Name, Functional_Location__r.Name, Main_Work_Center__c, Requestor_Name__r.Name, 
                            RAM_Total__c, E_MOC_Title__c, Functional_Location_Description__c, Category_Type__c, Sub_category_report__c, 
                            RAM_Total_Final__c, MOC_Type__c, CreatedDate, Change_Type__c, Start_date__c, 
                            Budget_Type__c, REQEND_Report__c, Budget_Estimate_Final__c, Budget_Estimate_Initial__c, MOC_FOCAL_POINT_NAME_Text__c,
                            Status_Common_Workflow__c, Description_of_change__c, Reason_of_change__c, Justification__c, Precaution__c 
                       FROM E_MOC_Application__c
                       WHERE id =: emocId];
        
        ApprovalHistory ();
    }
    
     public static void ApprovalHistory (){
        PageReference pageRef = ApexPages.currentPage();
        String emocId = pageRef.getParameters().get('id');
       // emocId = 'a1x6D000000zAEtQAM'; // for testing

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
}