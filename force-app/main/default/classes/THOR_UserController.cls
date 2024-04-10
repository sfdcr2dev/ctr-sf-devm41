public with sharing class THOR_UserController {

    @AuraEnabled(cacheable=true)  
    public static String getRoleName() {  
        User user = [SELECT Id, Name, UserRole.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1]; 
        String role = user.UserRole.Name; 
        //system.debug('role : ' + role);
        return role.replace('Working Team', 'Team Lead');  
    }

    @AuraEnabled(cacheable=true)  
    public static List<sObject> findRecords(String searchKey) {  
        string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';
        User user = [SELECT Id, Name, UserRole.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1]; 
        String role = user.UserRole.Name;  
        String isAPU = role.substring(9,12);
        String query = '';
        if(isAPU == 'APU') {
            String apu = role.substring(13,14);
            Boolean teamM = role.contains('-M');
            Boolean teamI = role.contains('-I');
            Boolean teamE = role.contains('-E');
            if(teamM) {
                String teamLeadM =  '\'' + 'TOP THOR APU-' + apu + ' Team Lead-ENM' + apu + '-M' + '%\'';
                String coOrdinatorM =  '\'' + 'TOP THOR APU-' + apu + ' Co-Ordinator-ENM' + apu + '-M' + '%\'';
                query = 'SELECT Id, Name FROM User WHERE Name LIKE ' + searchText + 
                            ' AND ( Role_Approve_process__c LIKE ' + teamLeadM +
                            ' OR Role_Approve_process__c LIKE ' + coOrdinatorM + ' )' + 
                            ' LIMIT 25';  
            } 
            else if(teamI) {
                String teamLeadI =  '\'' + 'TOP THOR APU-' + apu + ' Team Lead-ENM' + apu + '-I' + '%\'';
                String coOrdinatorI =  '\'' + 'TOP THOR APU-' + apu + ' Co-Ordinator-ENM' + apu + '-I' + '%\'';
                query = 'SELECT Id, Name FROM User WHERE Name LIKE ' + searchText + 
                            ' AND ( Role_Approve_process__c LIKE ' + teamLeadI +
                            ' OR Role_Approve_process__c LIKE ' + coOrdinatorI + ' )' + 
                            ' LIMIT 25';
            }
            else {
                String teamLeadE =  '\'' + 'TOP THOR APU-' + apu + ' Team Lead-ENM' + apu + '-E' + '%\'';
                String coOrdinatorE =  '\'' + 'TOP THOR APU-' + apu + ' Co-Ordinator-ENM' + apu + '-E' + '%\'';
                query = 'SELECT Id, Name FROM User WHERE Name LIKE ' + searchText + 
                            ' AND ( Role_Approve_process__c LIKE ' + teamLeadE +
                            ' OR Role_Approve_process__c LIKE ' + coOrdinatorE + ' )' + 
                            ' LIMIT 25';
            }  
        }
        else {
            String discipline = role.substring(9,13);
            String department = role.substring(role.indexOf('-'), role.length());
            String teamLead = '\'' + 'TOP THOR ' + discipline + ' Team Lead' + department + '%\'';
            String coOrdinator = '\'' + 'TOP THOR ' + discipline + ' Co-Ordinator' + department + '%\'';
            query = 'SELECT Id, Name FROM User WHERE Name LIKE ' + searchText + 
                    ' AND ( Role_Approve_process__c LIKE ' + teamLead +
                    ' OR Role_Approve_process__c LIKE ' + coOrdinator + ' )' + 
                    ' LIMIT 25';
        }
        
        return Database.query(query);  
    }

    @AuraEnabled
    public static Boolean isSubmited(String stepId){
        Boolean isSubmit = false;
        List<ProcessInstance> approvalSteps = [
            SELECT
                Id,
                Status,
                CreatedDate,
                CompletedDate,
                TargetObjectId,
                SubmittedBy.Name,
                (
                    SELECT
                        Id,
                        StepStatus,
                        Actor.Id,
                        OriginalActor.Name,
                        ElapsedTimeInDays,
                        ElapsedTimeInMinutes,
                        CreatedDate,
                        ProcessNodeId,
                        ProcessNode.Name,
                        Comments
                    FROM StepsAndWorkitems
                    ORDER BY CreatedDate DESC
                )
            FROM ProcessInstance
            WHERE TargetObjectId = :stepId
            ORDER BY CreatedDate DESC, Status DESC
        ];
        if(approvalSteps.size() > 0) {
            User user = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
            for (ProcessInstance approvalStep : approvalSteps) {
                for (ProcessInstanceHistory pi : approvalStep.StepsAndWorkitems) {
                    String status = pi.StepStatus == 'Rejected' ? 'Revision' : pi.StepStatus;
                    if (pi.Actor.Id == user.Id && status == 'Started') {
                        isSubmit = true;
                    }
                }
            }
        }
        else {
            EQCC_Step__c eqcc_step = [SELECT Id, Form_Code__c, Step_Number__c, Header_Sheet__r.Sheet__r.Group__c, Owner.Name FROM EQCC_Step__c WHERE Id = :stepId];
            Set<Id> groupId = new Set<Id>();
            Set<String> newSheetCodes = new Set<String>();
            User user = [SELECT Id, UserRoleId FROM User WHERE Id =: UserInfo.getUserId()];
            List<Group> groups = [Select Id, Name, DeveloperName From Group where RelatedId =: user.UserRoleId];
            for(Group g : groups) {
                groupId.add(g.Id);
            }
            List<GroupMember> groupMembers = [Select Id, Group.Name, Group.DeveloperName, Group.Type, UserOrGroupId From GroupMember
                                            WHERE Group.Name =: eqcc_step.Form_Code__c AND UserOrGroupId IN: groupId];
            if(groupMembers.size() > 0) {
                isSubmit = true;
            }
        }
        
        return isSubmit;
    }
}