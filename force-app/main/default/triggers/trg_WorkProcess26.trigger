/* Trigger for Work Process 26 */
trigger trg_WorkProcess26 on System_Test_Pack_Identification__c (before update, after update) {

    if(Trigger.IsBefore && Trigger.IsUpdate) {
    
        CPEM_AllWorkProcessForTriggerController.UpdateActualStartDateWP1FromOtherWP(Trigger.Old[0].SME__c, Trigger.New[0].SME__c, Trigger.New[0].Project__c , Trigger.New[0].IsWaitingForPreviousStep__c);
        CPEM_AllWorkProcessForTriggerController.UpdateWorkProcess26Status(Trigger.Old[0].SME__c, Trigger.New[0].SME__c, Trigger.New[0].Project__c, Trigger.New[0]);
        
    }
    
    if(Trigger.IsAfter && Trigger.IsUpdate) {
        
        string submitStatusNew = trigger.new[0].Submit_Status__c;
        string submitStatusOld = trigger.old[0].Submit_Status__c;
        
        //Send OPP Notification
        Id approveUserId = trigger.new[0].SME__c;
        Id requesterId = trigger.new[0].OwnerId;
        Id rtId = trigger.new[0].RecordTypeId;
        boolean waitingForApprove = trigger.new[0].Waiting_For_Approve__c;
        
        string rtName = [select id, name from RecordType where Id =: rtId].Name;
        Project__c Project = [select id, name, project_manager__c from Project__c where Id =: trigger.new[0].Project__c];
        string projectName = Project.Name;
        Id projectManagerId = Project.Project_Manager__c;
        Master_Data_Detail__c WP = [select id, name, Work_Process_No__c from Master_Data_Detail__c where Work_Process_No__c =: 26];

        if(rtName == 'Step 26 : Before Submit' && waitingForApprove) {
            CPEM_AllWorkProcessForTriggerController.SendOPPNotification(trigger.new[0].Id, projectName, WP.Name, approveUserId, requesterId);
        }
        else if(rtName == 'Step 26 : After Submit') {
            CPEM_AllWorkProcessForTriggerController.UpdateOPPNotification(trigger.new[0].Id);
        }

        //Send Email
        if(submitStatusNew == 'Pending') {
            //Send Email to SME
            CPEM_SendEmailController.SendEmailToSME(trigger.new[0].Id, approveUserId, requesterId, projectManagerId, projectName, WP.Work_Process_No__c, WP.name);
        }
        else if(submitStatusOld == 'Pending' && submitStatusNew == 'Approved') {
            //Send Email to Requester if Approved
            CPEM_SendEmailController.SendApprovedEmailToRequester(trigger.new[0].Id, approveUserId, requesterId, projectManagerId, projectName, WP.Work_Process_No__c, WP.name);
        }
        else if(submitStatusOld == 'Pending' && submitStatusNew == 'Rejected') {
            //Send Email to Requester if Rejeced
            CPEM_SendEmailController.SendRejectedEmailToRequester(trigger.new[0].Id, approveUserId, requesterId, projectManagerId, projectName, WP.Work_Process_No__c, WP.name);
        }
                
        CPEM_AllWorkProcessForTriggerController.SendMailToAssignUser(Trigger.Old[0].Assigned_User__c, Trigger.New[0].Assigned_User__c, Trigger.New[0].Id, Integer.valueOf(Trigger.New[0].No__c), WP.Name);
        
    }
}