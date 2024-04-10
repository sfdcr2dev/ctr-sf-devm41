public class EMOC_ApprovalHistoryFnOvrController {
	@AuraEnabled
    public static List<Map<String, String>> getOpportunityApprovalHistory(String recordId) {
        List<Map<String, String>> valuesList = new List<Map<String, String>>(); 
        List<ProcessInstanceWorkitem> piWork = [Select Id,CreatedDate,OriginalActorId, OriginalActor.Name, ActorId, Actor.Name, ProcessInstanceId, ProcessInstance.ProcessDefinition.Name, ProcessInstance.status, ProcessInstance.TargetObjectId 
                                                from ProcessInstanceWorkitem  where ProcessInstance.TargetObjectId = :recordId  ORDER BY createdDate DESC, Id DESC ];
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
                Map<String, String > listValues2= new Map<String, String>(); 
                listValues2.put('Id', listVal.Id);
                listValues2.put('StepPath', URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/' + listVal.Id + '/view');
                listValues2.put('StepName', listVal.ProcessInstance.ProcessDefinition.Name);  
                listValues2.put('OriginalActorId', listVal.OriginalActor.Name);
                listValues2.put('OriginalPath', URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/User/' + listVal.OriginalActorId + '/view');
                listValues2.put('Comments','');
                if (emocHold.size() > 0) {
                    listValues2.put('StepStatus', 'Hold');
                } else {
                    if (listVal.ProcessInstance.status == 'Pending' && (emocApp[0].Status_Functional_Override__c == 'Implementation#2' || emocApp[0].Status_Functional_Override__c == 'Return to normal condition' || emocApp[0].Status_Functional_Override__c == 'Close out')) {
                        listValues2.put('StepStatus', 'N/A');
                    } else {
                    	listValues2.put('StepStatus', listVal.ProcessInstance.status);
                    }
                }
                DateTime CreatedDate = listVal.CreatedDate;
                String myDate = CreatedDate.format('dd/MM/YYYY HH:mm');
                listValues2.put('CreatedDate', myDate);
                listValues2.put('ActorId', listVal.Actor.Name);
                listValues2.put('ActorPath', URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/User/' + listVal.ActorId + '/view');
                valuesList.add(listValues2);
            }
         }
        
         List<ProcessInstanceStep> piStep = [SELECT Id, StepNodeId, OriginalActorId, OriginalActor.Name, ActorId, Actor.Name, Comments, StepStatus, CreatedDate, ProcessInstance.TargetObjectId 
                                            FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId = :recordId AND Comments != 'submit!' ORDER BY createdDate DESC, Id DESC ];
        
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
                    
                Map<String, String > listValues= new Map<String, String>(); 
    
                listValues.put('Id', listVal.Id);
                listValues.put('StepPath', URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/' + listVal.Id + '/view');
                
                ProcessNode[] Pn = [SELECT Id, Description, DeveloperName, Name FROM ProcessNode where Id = :listVal.StepNodeId limit 1 ];
                if (Pn.size() > 0) {
                    listValues.put('StepName', Pn[0].Name);
                } else {
                    listValues.put('StepName', 'Approval Request Submitted');
                }
                listValues.put('OriginalActorId', listVal.OriginalActor.Name);
                listValues.put('OriginalPath', URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/User/' + listVal.OriginalActorId + '/view');
                listValues.put('Comments',listVal.Comments );
                    
                if (listVal.StepStatus == 'Removed') {
                    listValues.put('StepStatus', 'Send back');
                } else if (listVal.StepStatus == 'Started') {
                    listValues.put('StepStatus', 'Submitted');
                } else if (listVal.StepStatus == 'NoResponse') {
                    listValues.put('StepStatus', 'N/A');
                } else if (listVal.StepStatus == 'Pending' && (emocAppSt[0].Status_Functional_Override__c == 'Implementation#2' || emocAppSt[0].Status_Functional_Override__c == 'Return to normal condition' || emocAppSt[0].Status_Functional_Override__c == 'Close out')) {
                    listValues.put('StepStatus', 'N/A');
                } else {
                    if (emocHoldSt.size() > 0) {
                        listValues.put('StepStatus', 'Hold');
                    } else {
                        listValues.put('StepStatus', listVal.StepStatus);
                    }
                }
                DateTime CreatedDate = listVal.CreatedDate;
                String myDate = CreatedDate.format('dd/MM/YYYY HH:mm');
                
                listValues.put('CreatedDate', myDate);
                listValues.put('ActorId', listVal.Actor.Name);
                listValues.put('ActorPath', URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/User/' + listVal.ActorId + '/view'); 
                valuesList.add(listValues);
            }
        }
        
        return valuesList;
    }
}