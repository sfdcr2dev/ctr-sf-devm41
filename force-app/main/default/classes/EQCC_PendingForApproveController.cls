/**
 * @author Oktana
 * @description controller for EQCC_PendingForApprove component
 */
public without sharing class EQCC_PendingForApproveController {
    /**
     * @description retrieves the Instance Steps for current user
     * @return List<THOR_ObjectCardDTO>
     */
    private static String conditionQuery(
		String apiField,
		String operator,
		String val
	) {
        if(operator.equalsIgnoreCase('LIKE')) {
            val = String.valueOf(val).replace('*', '%');
            if(!val.contains('%')) val = '%' + val + '%';
        }
		return String.format(
			'{0} {1} {2}',
			new List<String>{ apiField, operator, '\'' + val + '\'' }
		);
	}
    @AuraEnabled
    public static List<THOR_ObjectCardDTO> retrieveProcessInstanceStepsForApproveForUser() {
        List<ProcessInstanceStep> processSteps = new List<ProcessInstanceStep>();
        List<EQCC_Step__c> eqccSteps = new List<EQCC_Step__c>();

        //try {
            if (Schema.sObjectType.ProcessInstanceStep.isAccessible()) {
                processSteps = [
                    SELECT
                        Id,
                        ActorId,
                        Comments,
                        StepStatus,
                        ProcessInstance.Status,
                        ProcessInstance.TargetObjectId,
                        CreatedDate
                    FROM ProcessInstanceStep
                    WHERE ProcessInstance.Status = 'Pending' AND StepStatus = 'Started'
                    ORDER BY CreatedDate DESC
                ];
            }
            Set<String> eqccStepsIdSet = new Set<String>();
            for (ProcessInstanceStep processInstanceStep : processSteps) {
                eqccStepsIdSet.add(processInstanceStep.ProcessInstance.TargetObjectId);
            }
            List<String> eqccStepsIdList = filterSteps(new List<String>(eqccStepsIdSet));

            if (processSteps.size() > 0) {
                if (Schema.sObjectType.EQCC_Step__c.isAccessible()) {

                    eqccSteps = [
                        SELECT
                            Id,
                            Form_Code__c,
                            Header_Sheet__r.Sheet__r.Sheet_Code__c,
                            Header_Sheet__r.Sheet__r.Group__c,
                            Header_Sheet__r.Sheet__r.CreatedDate,
                            Header_Sheet__r.Sheet__r.LastModifiedDate,
                            Header_Sheet__r.Sheet__r.Createdby.Name,
                            Header_Sheet__r.Requester__c,
                            Header_Sheet__r.Header__r.Notification__r.Notification_Number__c,
                            Header_Sheet__r.Header__r.Notification__r.Description__c,
                            Header_Sheet__r.Header__r.Order__r.Order_Number__c,
                            Header_Sheet__r.Header__r.Order__r.Description__c,
                            Header_Sheet__r.CreatedBy.Name
                        FROM EQCC_Step__c
                        WHERE Id IN :eqccStepsIdList AND IsDeleted__c = FALSE
                    ];
                }
            }

            Map<Id, EQCC_Step__c> eqccStepsMap = new Map<Id, EQCC_Step__c>();
            Map<Id, Datetime> submittedDatesMap = new Map<Id, Datetime>();
            for (ProcessInstanceStep p : processSteps) {
                for (EQCC_Step__c eqccStep : eqccSteps) {
                    if (p.ProcessInstance.TargetObjectId == eqccStep.Id) {
                        eqccStepsMap.Put(p.Id, eqccStep);
                        submittedDatesMap.Put(p.Id, p.CreatedDate);
                        break;
                    }
                }
            }

            return THOR_DTOMapper.mapProcessInstanceStepsForApprove(eqccStepsMap, submittedDatesMap);
        //} catch (Exception e) {
            //throw new AuraHandledException('Something went wrong...');
        //}

    }
    //filter
    @AuraEnabled
    public static List<THOR_ObjectCardDTO> retrieveProcessInstanceStepsForApproveForUserFilter(Map<String,String> filterMap) {
        List<ProcessInstanceStep> processSteps = new List<ProcessInstanceStep>();
        List<EQCC_Step__c> eqccSteps = new List<EQCC_Step__c>();

        //try {
            if (Schema.sObjectType.ProcessInstanceStep.isAccessible()) {
                processSteps = [
                    SELECT
                        Id,
                        ActorId,
                        Comments,
                        StepStatus,
                        ProcessInstance.Status,
                        ProcessInstance.TargetObjectId,
                        CreatedDate
                    FROM ProcessInstanceStep
                    WHERE ProcessInstance.Status = 'Pending' AND StepStatus = 'Started'
                    ORDER BY CreatedDate DESC
                ];
            }
            Set<String> eqccStepsIdSet = new Set<String>();
            for (ProcessInstanceStep processInstanceStep : processSteps) {
                eqccStepsIdSet.add(processInstanceStep.ProcessInstance.TargetObjectId);
            }

            List<String> eqccStepsIdList = filterSteps(new List<String>(eqccStepsIdSet));

            if (processSteps.size() > 0) {
                if (Schema.sObjectType.EQCC_Step__c.isAccessible()) {

                        //if (filterMap.containsKey('Functional_Location__c')) filterMap.put('FunctionalLocation__r.Name', filterMap.remove('Functional_Location__c'));
                        //eqipment
                        //Submission Date From

                        List<String> filterCondition = new List<String>();

                        if(filterMap.containsKey('Submission_Date_From__c')) {
                            filterCondition.add('CreatedDate >= ' + THOR_NotificationListPagingCtrl.datetimeGmtString(String.valueOf(filterMap.get('Submission_Date_From__c')), false));
                        }
                        if(filterMap.containsKey('Submission_Date_To__c')) {
                            filterCondition.add('CreatedDate <= ' + THOR_NotificationListPagingCtrl.datetimeGmtString(String.valueOf(filterMap.get('Submission_Date_To__c')), true));
                        }

                        // if (filterMap.containsKey('Requester__c')) filterMap.put('Header_Sheet__r.Requester__c', filterMap.remove('Requester__c'));
                        // if (filterMap.containsKey('User__c')) filterMap.put('Header_Sheet__r.CreatedById', filterMap.remove('User__c'));
                        if (filterMap.containsKey('Notification_Number__c')) filterMap.put('Header_Sheet__r.Header__r.Notification__r.Notification_Number__c', filterMap.remove('Notification_Number__c'));
                        if (filterMap.containsKey('Order_Number__c'))  filterMap.put('Header_Sheet__r.Header__r.Order__r.Order_Number__c',filterMap.remove('Order_Number__c'));
                        //if (filterMap.containsKey('Functional_Location__c')) filterMap.put('EQCC_Header__r.Header_Sheet__r.Functional_Location__r.Name', filterMap.remove('FunctionalLocation__c'));
                        if (filterMap.containsKey('Functional_Location__c')) filterMap.put('Header_Sheet__r.Header__r.FunctionalLocation__r.Name', filterMap.remove('Functional_Location__c'));
                        if (filterMap.containsKey('Equipment__c')) filterMap.put('Header_Sheet__r.Header__r.Equipment__r.Name', filterMap.remove('Equipment__c'));
                        if (filterMap.containsKey('Check_Sheet_Code__c')) filterMap.put('Form_Code__c', filterMap.remove('Check_Sheet_Code__c'));
                        if (filterMap.containsKey('Check_Sheet_Name__c')) filterMap.put('Header_Sheet__r.Sheet__r.Form_Name__c', filterMap.remove('Check_Sheet_Name__c'));
                        if (filterMap.containsKey('Maintenance_Plant__c')) filterMap.put('Header_Sheet__r.Header__r.Maintenance_PlantText__c', filterMap.remove('Maintenance_Plant__c'));
                        if (filterMap.containsKey('Location__c')) filterMap.put('Header_Sheet__r.Header__r.LocationText__c', filterMap.remove('Location__c'));
                        if (filterMap.containsKey('Plant_Section__c')) filterMap.put('Header_Sheet__r.Header__r.Plant_SectionText__c', filterMap.remove('Plant_Section__c'));
                        if (filterMap.containsKey('Main_Work_Center__c')) filterMap.put('Header_Sheet__r.Header__r.Main_Work_CenterText__c', filterMap.remove('Main_Work_Center__c'));

                        if (filterMap.containsKey('Requester__c'))
                        {
                            String Requester =  filterMap.remove('Requester__c'); // Employee Id or Fullname
                            Boolean haveStar= Requester.contains('*');


                            Requester = String.valueOf(Requester).replace('*', '%');
                            if(!Requester.contains('%')) {
                                Requester = '%' + Requester + '%';
                            }
                            String employeeId = Requester;

                            // val = String.valueOf(val).replace('*', '%');
                            List<String> users = new List<String>();
                            for (User u : [SELECT Id, Name, Employee_Id__c FROM User WHERE Employee_Id__c LIKE :employeeId LIMIT 10]) {
                                users.add('\'' + u.Name + '\'');
                            }

                            if (users.size() > 0) {
                                filterCondition.add(String.format('({0} OR Header_Sheet__r.Requester__c IN ({1}))', new List<String>{
                                    conditionQuery('Header_Sheet__r.Requester__c', 'LIKE', Requester), String.join(users, ',')
                                }));
                            } else {
                                filterCondition.add(String.format('({0})', new List<String>{
                                    conditionQuery('Header_Sheet__r.Requester__c', 'LIKE', Requester)
                                }));
                            }


                   		}

                        filterMap.remove('Filter_type__c');
                        filterMap.remove('User__c');
                        filterMap.remove('IsActive__c');

                        // if(filterMap.containsKey('Main_Work_Center__c')) {
                        //     String val = String.valueOf(filterMap.remove('Main_Work_Center__c'))?.replace('*', '%'); // no value to be null
                        //     val = val.startsWith('%') ? val : '%' + val;
                        //     val = val.endsWith('%') ? val : val + '%';
                        //     filterCondition.add(String.format('({0} OR {1})', new List<String>{
                        //         conditionQuery('Header_Sheet__r.Header__r.Notification__r.Main_Work_Center__r.Code__c', 'LIKE', val),
                        //         conditionQuery('Header_Sheet__r.Header__r.Order__r.Main_Work_Center__r.Code__c ', 'LIKE', val)
                        //     }));
                        // }
                        // if(filterMap.containsKey('Maintenance_Plant__c')) {
                        //     String val = String.valueOf(filterMap.remove('Maintenance_Plant__c'))?.replace('*', '%'); // no value to be null
                        //     val = val.startsWith('%') ? val : '%' + val;
                        //     val = val.endsWith('%') ? val : val + '%';
                        //     filterCondition.add(String.format('({0} OR {1})', new List<String>{
                        //         conditionQuery('Header_Sheet__r.Header__r.Notification__r.mainWorkCenterPlant__r.Code__c', 'LIKE', val),
                        //         conditionQuery('Header_Sheet__r.Header__r.Order__r.mainWorkCenterPlant__r.Code__c ', 'LIKE', val)
                        //     }));
                        // }
                        // if(filterMap.containsKey('Location__c')) {
                        //     String val = String.valueOf(filterMap.remove('Location__c'))?.replace('*', '%'); // no value to be null
                        //     val = val.startsWith('%') ? val : '%' + val;
                        //     val = val.endsWith('%') ? val : val + '%';
                        //     filterCondition.add(String.format('({0} OR {1})', new List<String>{
                        //         conditionQuery('Header_Sheet__r.Header__r.Notification__r.Location__c', 'LIKE', val),
                        //         conditionQuery('Header_Sheet__r.Header__r.Order__r.Location__c ', 'LIKE', val)
                        //     }));
                        // }
                        // if(filterMap.containsKey('Plant_Section__c')) {
                        //     String val = String.valueOf(filterMap.remove('Plant_Section__c'))?.replace('*', '%'); // no value to be null
                        //     val = val.startsWith('%') ? val : '%' + val;
                        //     val = val.endsWith('%') ? val : val + '%';
                        //     filterCondition.add(String.format('({0} OR {1})', new List<String>{
                        //         conditionQuery('Header_Sheet__r.Header__r.Notification__r.Plant_Section__c', 'LIKE', val),
                        //         conditionQuery('Header_Sheet__r.Header__r.Order__r.Plant_Section__c', 'LIKE', val)
                        //     }));
                        // }


                        Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe()
                        .get('EQCC_Step__c'.toLowerCase())
                        .getDescribe()
                        .fields
                        .getMap();
                        for (String f : filterMap.keySet()) {
                            if (!sObjectField.containsKey(f) && !f.contains('__r')) {

                                filterMap.remove(f);
                            }
                        }

                        for(String keyApiName : filterMap.keySet()) {
                            Object value = filterMap.get(keyApiName);
                            if(value == null) continue;
                            System.debug('Value='+ value);
                            System.debug('keyApiName='+ keyApiName);

                            if(sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN) {
                                filterCondition.add(String.format('{0} {1} {2}', new List<Object>{ keyApiName, '=' , (Boolean)value }));
                            }
                            else if(sObjectField.get(keyApiName)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE) {
                                filterCondition.add(conditionQuery(keyApiName, '=', String.valueOf(value)));
                            }
                            else {
                                // String val = String.valueOf(value).replace('*', '%');
                                // val = val.startsWith('%') ? val : '%' + val;
                                // val = val.endsWith('%') ? val : val + '%';
                                filterCondition.add(conditionQuery(keyApiName, 'LIKE', String.valueOf(value)));
                            }
                        }

                        String query = String.format(
                        'SELECT {0} FROM EQCC_Step__c  WHERE Id IN :eqccStepsIdList AND IsDeleted__c = FALSE {1}',
                        new List<String> {
                            String.join(new List<String>{
                                'Id',
                                'Form_Code__c',
                                'Header_Sheet__r.Name',
                                // 'Header_Sheet__r.Sheet__r.Sheet_Code__c',
                                'Header_Sheet__r.Sheet__r.Group__c',
                                'Header_Sheet__r.Sheet__r.CreatedDate',
                                // 'Header_Sheet__r.Sheet__r.LastModifiedDate',
                                // 'Header_Sheet__r.Sheet__r.Createdby.Name',
                                'Header_Sheet__r.Requester__c',
                                'Header_Sheet__r.Header__r.Notification__r.Notification_Number__c',
                                'Header_Sheet__r.Header__r.Notification__r.Description__c',
                                'Header_Sheet__r.Header__r.Order__r.Order_Number__c',
                                'Header_Sheet__r.Header__r.Order__r.Description__c',
                                'Header_Sheet__r.CreatedBy.Name'
                            }, ','),
                            filterCondition.size() > 0 ? String.format('AND {0}', new List<String>{ // condition optional
                                String.join(filterCondition, ' AND ')
                            }) : ''
                        }
                    );
                    System.debug('qry' + query);
                    Integer mid = query.length() / 2; //get the middle of the String
                    List<String> fullq = new List<String>();
                    fullq.add(query.substring(0, mid));
                    fullq.add(query.substring(mid, query.length()));
                    for (String s : fullq){
                        system.debug(s);
                    }
                    eqccSteps = Database.query(query);
                    for (String key : filterMap.Keyset()){
                        System.debug('FilterMAP:='+ Key + filterMap.get(key));
                    }
                }
            }
            system.debug('eqccSteps: ' + eqccSteps);

            Map<Id, EQCC_Step__c> eqccStepsMap = new Map<Id, EQCC_Step__c>();
            Map<Id, Datetime> submittedDatesMap = new Map<Id, Datetime>();
            for (ProcessInstanceStep p : processSteps) {
                for (EQCC_Step__c eqccStep : eqccSteps) {
                    if (p.ProcessInstance.TargetObjectId == eqccStep.Id) {
                        eqccStepsMap.Put(p.Id, eqccStep);
                        submittedDatesMap.Put(p.Id, p.CreatedDate);
                        break;
                    }
                }
            }

            return THOR_DTOMapper.mapProcessInstanceStepsForApprove(eqccStepsMap, submittedDatesMap);
        //} catch (Exception e) {
            //throw new AuraHandledException('Something went wrong...');
        //}

    }

    /**
     * @description filters steps by what the user is able to approve
     * @param relatedId is the related EQCC_Step__c
     * @return retVal Boolean Can reassign or approve/revise
     */
    public static List<String> filterSteps(List<String> relatedIds) {
        List<String> filteredIds = new List<String>();

        if (ProcessInstance.SObjectType.getDescribe().isAccessible()) {
            // I found this query here as the last answer
            // https://developer.salesforce.com/forums/?id=906F00000008qumIAA
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
                            Actor.Name,
                            Actor.Id,
                            ElapsedTimeInDays,
                            ElapsedTimeInMinutes,
                            CreatedDate,
                            ProcessNodeId,
                            ProcessNode.Name,
                            Comments
                        FROM StepsAndWorkitems
                    )
                FROM ProcessInstance
                WHERE TargetObjectId IN :relatedIds AND (Status = 'Started' OR Status = 'Pending')
                ORDER BY CreatedDate DESC
            ];

            List<Profile> profs = [SELECT Id FROM Profile WHERE Id = :UserInfo.getProfileId() AND Name LIKE '%Admin%'];
            Set<String> roleGroups = new Set<String>();
            Set<String> groups = new Set<String>();
            for (Group g : [
                SELECT Id, Name, DeveloperName, RelatedId, Type
                FROM Group
                WHERE RelatedId IN (SELECT UserRoleId FROM User WHERE Id = :UserInfo.getUserId()) AND Type = 'Role'
            ]) {
                roleGroups.add(g.Id);
            }
            for (GroupMember gm : [SELECT Group.Name FROM GroupMember WHERE UserOrGroupId IN :roleGroups]) {
                groups.add(gm.Group.Name);
            }

            Set<String> actorSet = new Set<String>();
            Map<Id, String> groupMap = new Map<Id, String>();
            for (Integer i = 0; i < approvalSteps.size(); i++) {
                for (ProcessInstanceHistory pi : approvalSteps[i].StepsAndWorkitems) {
                    actorSet.add(pi.ActorId);
                }
            }
            for (Group g : [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Id IN :actorSet]) {
                groupMap.put(g.Id, g.Name);
            }
            // Can't query StepsAndWorkItems directly
            // the query above returns the sub-query as ProcessInstanceHistory
            for (Integer i = 0; i < approvalSteps.size(); i++) {
                Boolean canView = false;
                for (ProcessInstanceHistory pi : approvalSteps[i].StepsAndWorkitems) {
                    // needed for wording, 'Reject' is bad in Thailand
                    // so we change it to 'Revision' instead
                    String status = pi.StepStatus == 'Rejected' ? 'Revision' : pi.StepStatus;

                    if (pi.ProcessNode != null && status == 'Pending') {
                        if (pi.ActorId == UserInfo.getUserId()) {
                            canView = true;
                        } else if (profs.size() > 0) {
                            canView = true;
                        } else if (pi.ActorId != null) {
                            if (groups.contains(groupMap.get(pi.ActorId))) {
                                canView = true;
                            } else {
                                canView = false;
                            }
                        }
                    }
                }
                if (canView == true) {
                    filteredIds.add(approvalSteps[i].TargetObjectId);
                }
            }
        }

        return filteredIds;
    }
}