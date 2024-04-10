/**
 * @author K.B. Carte
 * @description Controller class for THOR_ActionForApproval component
 */
public with sharing class THOR_ActionForApproveController {
    /**
     * @description get's the approval processes related to the check sheet step
     * @param relatedId is the related EQCC_Step__c
     * @return returnList List<Map<String, String>> A list of maps containing the information to be shown
     */
    @AuraEnabled
    public static List<Map<String, String>> getApprovalSteps(String relatedId) {
        List<Map<String, String>> returnList = new List<Map<String, String>>();

        if (!String.isEmpty(relatedId)) {
            String sheetCode = (!String.isEmpty(relatedId)) ? getSheetCodeFromEQCCStep(relatedId) : '';
            if (ProcessInstance.SObjectType.getDescribe().isAccessible()) {
                Set<Id> stepIds = getStepsFormStepId(relatedId);
// I found this query here as the last answer
// https://developer.salesforce.com/forums/?id=906F00000008qumIAA
				List<ProcessInstance> approvalSteps = [ SELECT Id, Status, CreatedDate, CompletedDate, TargetObjectId, SubmittedBy.Name, ( SELECT Id, StepStatus, Actor.Name, OriginalActor.Name, ElapsedTimeInDays, ElapsedTimeInMinutes, CreatedDate, ProcessNodeId, ProcessNode.Name, Comments FROM StepsAndWorkitems ORDER BY CreatedDate DESC ) FROM ProcessInstance WHERE TargetObjectId IN :stepIds ORDER BY CreatedDate DESC, Status DESC ];

                Map<String, String> approverMetadataMap = new Map<String, String>();
                for (Approver__mdt approverMdt : [SELECT Id, Role__c, Queue__c FROM Approver__mdt]) {
                    approverMetadataMap.put(approverMdt.Queue__c, approverMdt.Role__c);
                }

// pending steps should be at the top
                Map<String, String> addPending = null;

// Can't query StepsAndWorkItems directly
// the query above returns the sub-query as ProcessInstanceHistory
                for (ProcessInstance approvalStep : approvalSteps) {
                    for (ProcessInstanceHistory pi : approvalStep.StepsAndWorkitems) {
                        Map<String, String> addme = new Map<String, String>();

// needed for wording, 'Reject' is bad in Thailand
// so we change it to 'Revision' instead
                        String status = pi.StepStatus == 'Rejected' ? 'Revision' : pi.StepStatus;

                        if (status == 'Pending') {
                            String assigned = approverMetadataMap.containsKey(pi.OriginalActor.Name) ? approverMetadataMap.get(pi.OriginalActor.Name) : pi.OriginalActor.Name;
                            String actualAssigned = approverMetadataMap.containsKey(pi.Actor.Name) ? approverMetadataMap.get(pi.Actor.Name) : pi.Actor.Name;
                            addPending = new Map<String, String>();
                            addPending.put('Name', pi.ProcessNode.Name);
                            addPending.put('Date', getDateFromDatetime(pi.CreatedDate));
                            addPending.put('Status', status);
                            addPending.put('ActualAssigned', actualAssigned);
                            addPending.put('Assigned', assigned);
                            addPending.put('Comment', pi.Comments);
                            addPending.put('Code', sheetCode);
                        } else if (pi.ProcessNode != null) {
                            String assigned = approverMetadataMap.containsKey(pi.OriginalActor.Name) ? approverMetadataMap.get(pi.OriginalActor.Name) : pi.OriginalActor.Name;
                            String actualAssigned = approverMetadataMap.containsKey(pi.Actor.Name) ? approverMetadataMap.get(pi.Actor.Name) : pi.Actor.Name;
                            addme.put('Name', pi.ProcessNode.Name);
                            addme.put('Date', getDateFromDatetime(pi.CreatedDate));
                            addme.put('Status', status);
                            addme.put('ActualAssigned', actualAssigned);
                            addme.put('Assigned', assigned);
                            addme.put('Comment', pi.Comments);
                            addme.put('Code', sheetCode);
                            returnList.add(addme);
                        }
                    }

                    Map<String, String> addInit = new Map<String, String>();
                    addInit.put('Name', 'Approval Request Submitted');
                    addInit.put('Date', getDateFromDatetime(approvalStep.CreatedDate));
                    addInit.put('Status', 'Submitted');
                    addInit.put('Assigned', approvalStep.SubmittedBy.Name);
                    addInit.put('ActualAssigned', approvalStep.SubmittedBy.Name);
                    addInit.put('Code', sheetCode);
                    returnList.add(addInit);
                }

                if (addPending != null) {
                    returnList.add(0, addPending);
                }
            }
        }

        return returnList;
    }

    @AuraEnabled
    public static Header_Sheet__c getRejectedHeaderSheet(Id stepId) {
        List<EQCC_Step__c> rejectedSteps = getRejectedEQCCStepById(stepId);
        if (!rejectedSteps.isEmpty()) {
            Header_Sheet__c headerSheet = getHeaderSheetFromStep(rejectedSteps[0]);

            return headerSheet;
        }
        return null;
    }
    /**
     * @description determines whether or not the current user can reassign or approve the request
     * @param relatedId is the related EQCC_Step__c
     * @return retVal Boolean Can reassign or approve/revise
     */
    @AuraEnabled
    public static Boolean canApprove(String relatedId) {
        Boolean retVal = false;

        if (ProcessInstance.SObjectType.getDescribe().isAccessible()) {
// I found this query here as the last answer
// https://developer.salesforce.com/forums/?id=906F00000008qumIAA
            List<ProcessInstance> approvalSteps = [ SELECT Id, Status, CreatedDate, CompletedDate, TargetObjectId, SubmittedBy.Name, ( SELECT Id, StepStatus, Actor.Name, Actor.Id, ElapsedTimeInDays, ElapsedTimeInMinutes, CreatedDate, ProcessNodeId, ProcessNode.Name, Comments FROM StepsAndWorkitems ) FROM ProcessInstance WHERE TargetObjectId = :relatedId AND (Status = 'Started' OR Status = 'Pending') ORDER BY CreatedDate DESC ];

            if (approvalSteps.isEmpty())
                return false;

            List<Profile> profs = [SELECT Id FROM Profile WHERE Id = :UserInfo.getProfileId() AND Name LIKE '%Admin%'];
            Set<String> roleGroups = new Set<String>();
            Set<String> groups = new Set<String>();
            for (Group g : [ SELECT Id, Name, DeveloperName, RelatedId, Type FROM Group WHERE RelatedId IN (SELECT UserRoleId FROM User WHERE Id = :UserInfo.getUserId()) AND Type = 'Role' ]) {
                roleGroups.add(g.Id);
            }
            for (GroupMember gm : [SELECT Group.Name FROM GroupMember WHERE UserOrGroupId IN :roleGroups]) {
                groups.add(gm.Group.Name);
            }
// Can't query StepsAndWorkItems directly
// the query above returns the sub-query as ProcessInstanceHistory
            for (ProcessInstanceHistory pi : approvalSteps[0].StepsAndWorkitems) {
                Map<String, String> addme = new Map<String, String>();

// needed for wording, 'Reject' is bad in Thailand
// so we change it to 'Revision' instead
                String status = pi.StepStatus == 'Rejected' ? 'Revision' : pi.StepStatus;
                if (pi.ProcessNode != null && status == 'Pending') {
                    if (pi.ActorId == UserInfo.getUserId()) {
                        retVal = true;
                    } else if (profs.size() > 0) {
                        retVal = true;
                    } else if (pi.ActorId != null) {
                        List<Group> lst = [SELECT Id, Name FROM Group WHERE (Type = 'Queue' OR Type = 'Regular') AND Id = :pi.ActorId];
                        //Group g = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Id = :pi.ActorId];
                        if (lst.size() > 0 && groups.contains(lst[0].Name)) {
                            retVal = true;
                        }
                    }
                }
            }
        }

        return retVal;
    }
    /**
     * @description reassigns the approval step to a different user
     * @param relatedId is the related EQCC_Step__c
     * @return retVal Boolean successful reassign
     */
    @AuraEnabled
    public static Boolean reassign(String relatedId, String userId) {
        Boolean retVal = false;
        if (Schema.sObjectType.ProcessInstanceStep.isAccessible()) {
            List<ProcessInstanceWorkItem> processSteps = [ SELECT Id, Actor.Name, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkItem WHERE ProcessInstance.TargetObjectId = :relatedId ]; 
            if (!processSteps.isEmpty()) {
                ProcessInstanceWorkitem myItem = processSteps[0];
                myItem.ActorId = userId;
                update myItem;

                handleReassignAlert(relatedId, userId);
                retVal = true;
            }
        }

        return retVal;
    }

    private static Id resolveStepProcess(Id stepId) {
        List<ProcessInstanceStep> processSteps = [ SELECT Id, ActorId, Comments, StepStatus, ProcessInstance.Status, ProcessInstance.TargetObjectId, CreatedDate FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId = :stepId ORDER BY CreatedDate DESC ];

        return processSteps[0].Id;
    }

    private static void handleReassignAlert(Id stepId, String receiver) {
        EQCC_Step__c step = getStepById(stepId);
        Id alertType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'THOR_Push_Notification'].Id;
        List<String> receivers = new List<String>{ receiver };
        Id processId = resolveStepProcess(stepId);
// Messaging.CustomNotification alert = CustomNotificationHelper.buildAlert(
//     alertType,
//     getStepPageRef(processId, step.Header_Sheet__r.Sheet__r.Group__c),
//     resolveReassignAlertBody(step),
//     'Checked Sheet reassigned'
// );
        sendAlert( receivers, processId, step.Form_Code__c + '[Step ' + step.Step_Number__c + '] has been submitted for your approval.', 'New Approval', step.Header_Sheet__r.Sheet__r.Group__c);
        createNotification(step, receivers);
//CustomNotificationHelper.sendAlert(alert, receivers);
    }

    private static String getStepPageRef(Id processId, String sheetGroup) {
        return '{"type": "standard__component", "attributes": {"componentName": "c__THOR_ApprovalSteps"}, "state": {"c__recordId": "' + processId + '", "c__sheetGroup": "' + sheetGroup + '"}}';
    }

    private static String resolveReassignAlertBody(EQCC_Step__c step) {
        return CustomNotificationHelper.buildFormattedMessage(
            '{0} has been assigned to you',
            new List<String>{ step.Form_Code__c }
        );
    }

    private static EQCC_Step__c getStepById(Id stepId) {
        return [SELECT Id, Header_Sheet__c, Form_Code__c, Header_Sheet__r.Sheet__r.Group__c, Owner.Name, Step_Number__c FROM EQCC_Step__c WHERE Id = :stepId LIMIT 1];
    }

    /**
     * @description approves or rejects step
     * @param stepId is the Id of the EQCC_Step we're submitting for approval
     * @param approveReject is a string to either 'Approve' or 'Reject'
     * @param comments is a string with user comments that will be added to the end of the approver comment
     * @return boolean true if the approve/reject went through okay, False if error
     */
    @AuraEnabled
    public static Boolean approveOrReject(String stepId, String approveReject, String comments) {
        return THOR_ApprovalFlowService.approveOrReject(stepId, approveReject, comments);
    }

    private static String getDateFromDatetime(Datetime mDatetime) {
        return mDatetime.format('dd/MM/yyyy HH:mm:ss', UserInfo.getTimeZone().toString());
    }

    private static String getSheetCodeFromEQCCStep(String stepId) {
        try {
            EQCC_Step__c step = [SELECT Id, Header_Sheet__c FROM EQCC_Step__c WHERE Id = :stepId];
            Header_Sheet__c headerSheet = [SELECT Id, Sheet__c FROM Header_Sheet__c WHERE Id = :step.Header_Sheet__c];
            EQCC_Checked_Sheet__c sheet = [ SELECT Id, Sheet_Code__c FROM EQCC_Checked_Sheet__c WHERE Id = :headerSheet.Sheet__c ];

            return sheet.Sheet_Code__c;
        } catch (Exception ex) {
// TODO handle exception
        }

        return '';
    }

    /**
     * @description retrieves all steps from a Header Sheet given a step Id
     * @param stepId
     **/
    private static Set<Id> getStepsFormStepId(Id stepId) {
        EQCC_Step__c step = [SELECT Id, Header_Sheet__c FROM EQCC_Step__c WHERE Id = :stepId WITH SECURITY_ENFORCED];
        Map<Id, EQCC_Step__c> steps = new Map<Id, EQCC_Step__c>([SELECT Id FROM EQCC_Step__c WHERE Header_Sheet__c = :step.Header_Sheet__c WITH SECURITY_ENFORCED]);

        return steps.keySet();
    }

    private static List<EQCC_Step__c> getRejectedEQCCStepById(Id stepId) {
        return [ SELECT Id, Header_Sheet__c FROM EQCC_Step__c WHERE Id = :stepId AND Status__c = :Constants.PROCESS.STATUS_REJECTED ];
    }

    private static Header_Sheet__c getHeaderSheetFromStep(EQCC_Step__c step) {
        return [ SELECT Id, Closed_Date__c, Status__c, Rejection_Reason__c, Rejection_Datetime__c FROM Header_Sheet__c WHERE Id = :step.Header_Sheet__c LIMIT 1 ];
    }

    private static void sendAlert(List<String> users, String processId, String body, String title, String sheetGroup) {
        Id typeId = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'THOR_Push_Notification'].Id;
        Set<String> userIds = new Set<String>();
        userIds.addAll(users);
        PageReference pageRef = new PageReference('n/My_approvals');
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setBody(body);
        notification.setTitle(title);
        //notification.setTargetPageRef('{"type": "standard__navItemPage", "attributes": { "apiName": "My_approvals"}}');
        notification.setTargetPageRef( '{"type": "standard__component", "attributes": {"componentName": "c__THOR_ApprovalSteps"}, "state": {"c__recordId": "' + processId + '", "c__sheetGroup": "' + sheetGroup + '"}}' );
        notification.setNotificationTypeId(typeId);
        try {
            notification.send(userIds);
        } catch (Exception e) {
//System.debug('Problem sending notification: ' + e.getMessage());
        }
    }

    public static void createNotification(EQCC_Step__c step, List<String> receivers) {
        ProcessInstanceStep processSteps = [ SELECT Id, ActorId, Comments, StepStatus, ProcessInstance.Status, ProcessInstance.TargetObjectId, CreatedDate FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId = :step.Id AND StepStatus = 'Reassigned' ORDER BY CreatedDate DESC ];

        List<OPP_Notification__c> notifications = [SELECT Id FROM OPP_Notification__c WHERE ReferenceID__c =: step.Id AND Status__c = 'New'];
        for(OPP_Notification__c notification : notifications) {
            notification.Status__c = 'Send back';
            update notification;
        }

        List<User> users = [SELECT Id FROM User WHERE Id IN: receivers];
        String appId = [SELECT Id FROM OPP_Application__c WHERE Name = 'THOR' LIMIT 1].Id;
        EQCC_Checked_Sheet__c checkSheet = [SELECT Id, Group__c FROM EQCC_Checked_Sheet__c WHERE Sheet_Code__c =: step.Form_Code__c LIMIT 1];
        
        THORIntegration__c ThorCustomSetting = THORIntegration__c.getInstance();
        String OrgUrl = ThorCustomSetting.OrgDomainUrl__c;
        
        List<OPP_Notification__c> getNotifications = new List<OPP_Notification__c>();
        if(users.size() > 0) {
            for(User user : users) {
                OPP_Notification__c notification = new OPP_Notification__c();
                notification.Application__c = appId;
                notification.Description__c =  processSteps.Comments;
                notification.Event__c = 'Action';
                notification.ReferenceID__c = step.Id;
                notification.Requester__c = step.Owner.Name;
                notification.Status__c = 'Reassigned';
                notification.Step__c = String.valueOf(step.Step_Number__c);
                notification.Subject__c = 'Approve has been assigned to you';
                notification.URL__c = OrgUrl + '/lightning/cmp/c__THOR_ApprovalSteps?c__recordId=' + processSteps.Id + '&c__sheetGroup=' + checkSheet.Group__c;
                notification.User__c = user.Id;
                getNotifications.add(notification);
            }
            insert getNotifications;
        }  
    }
}