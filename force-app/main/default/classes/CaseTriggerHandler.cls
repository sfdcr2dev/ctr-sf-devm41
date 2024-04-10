public with sharing class CaseTriggerHandler implements ITriggerHandler {
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    public void beforeInsert(List<SObject> newItems) {
        CaseTriggerHandler.OPP_stampPISUerRequester(newItems);
        CaseTriggerHandler.OPP_stampCreaterEmail(newItems);
        
    }
    public void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {	
        CaseTriggerHandler.OPP_stampPISUerRequester(newItems.values());	
        CaseTriggerHandler.OPP_stampCountFiles((Map<Id, Case>)newItems, (Map<Id, Case>)oldItems);
    }
    public void beforeDelete(Map<Id, SObject> oldItems) {
    }
    
    public void afterInsert(Map<Id, SObject> newItems) {
        // CaseTriggerHandler.OPP_PushNotification(newItems.values());
        
    }
    
    public void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        //CaseTriggerHandler.OPP_PushNotification((Map<Id, Case>)newItems);
        //CaseTriggerHandler.OPP_PushNotification(newItems.values());
        CheckStatus((Map<Id, Case>)newItems, (Map<Id, Case>)oldItems);
    }
    
    public void afterDelete(Map<Id, SObject> oldItems) {
    }
    public void afterUndelete(Map<Id, SObject> oldItems) {
    }
    
    
    public static Map<Id /* UserId */, PISUsers__c> pisUsersMap {
        get {
            if (pisUsersMap == null) {
                pisUsersMap = new Map<Id, PISUsers__c>();
                for (PISUsers__c pisUser : [SELECT 
                                            User__c, ReportToUser__c, SectHeadUpUser__c,LEVEL__c,
                                            COMPANYCODE__c, CONTRACT__c, DEPARTMENT__c, EMAIL__c, 
                                            EMPLOYEEID__c, ENFIRSTNAME__c, FUNCTION__c, HOLDERPOSITION__c, 
                                            Name, OBJTHFULLNAME__c, ORGID__c, PERSAREA__c, REFERENCEID__c, 
                                            ReportToEmail__c, ReportToName__c, ReportToPOS__c, 
                                            SectHeadUpEmail__c, SectHeadUpID__c, SectHeadUpName__c, SectHeadUpPosID__c, SECTIONS__c,
                                            User_Type__c  
                                            FROM PISUsers__c 
                                            Where Active__c = True
                                            AND MAINPOSITION__c = True
                                           ]) {
                                                pisUsersMap.put(pisUser.User__c, pisUser);
                                            }
            }
            return pisUsersMap;
        }
        set;
    }
    
    public static Map<String /* POSID */, PISUsers__c> pisUserPOSMap {
        get {
            if (pisUserPOSMap == null) {
                pisUserPOSMap = new Map<String, PISUsers__c>();
                for (PISUsers__c pisUser : [SELECT User__c, POSID__c, ReportToUser__c
                                            FROM PISUsers__c 
                                            Where Active__c = True
                                           ]) {
                                               pisUserPOSMap.put(pisUser.POSID__c, pisUser);
                                           }
            }
            return pisUserPOSMap;
        }
        set;
    }
    
    public static final PISUsers__c userDGVP {
        get{
            if (userDGVP == null) {
                userDGVp = [SELECT User__c FROM PISUsers__c WHERE HOLDERPOSITION__c = '60001740' Limit 1 ];
            }
            return userDGVp;
        }
        set;
    }
    
    public static Map<String, OPP_Application__c> oppAppMap {
        get {
            if(oppAppMap == null) {
                oppAppMap = new Map<String, OPP_Application__c>();
                for (OPP_Application__c app : [SELECT Id, Name FROM OPP_Application__c WHERE Notification__c = true]) {
                    if(app.Name != null) {
                        oppAppMap.put(app.Name?.replace(' ', '_'), app);
                    }
                }
            }
            return oppAppMap;
        }
        set;
    }
    
    public static Map<Id, User> usersMap {
        get {
            if (usersMap == null) {
                usersMap = new Map<Id, User>([
                    SELECT Id, Email, Name, Username, UserType 
                    FROM User 
                    WHERE UserType = 'Standard' AND IsActive = true
                ]);
            }
            return usersMap;
        }
        set;
    }
    
    public static Map<String, List<GroupMember>> queueMap {
        get {
            if (queueMap == null) {
                
                queueMap = new Map<String, List<GroupMember>>();
                for (GroupMember gMember : [SELECT Group.DeveloperName, UserOrGroupId From GroupMember]) {
                    if(!queueMap.containsKey(gMember.Group.DeveloperName)){
                        queueMap.put(gMember.Group.DeveloperName, new List<GroupMember>());
                    }
                    queueMap.get(gMember.Group.DeveloperName).add(gMember);
                }
            }
            return queueMap;
        }
        set;
    }
    
    private static Map<String, DG_Service_Approvers_Setting__mdt> DGServiceApprovers_Setting {
        get{
            if(DGServiceApprovers_Setting == null) {
                DGServiceApprovers_Setting = new Map<String, DG_Service_Approvers_Setting__mdt>();
                for (DG_Service_Approvers_Setting__mdt approver : [SELECT DeveloperName, Requester_Manager__c, Requester_VP__c, DGVP__c FROM DG_Service_Approvers_Setting__mdt]) {
                    DGServiceApprovers_Setting.put(approver.DeveloperName, approver);
                }
            }
            return DGServiceApprovers_Setting;
        }
        set;
    }
    
    private static Map<String, DG_Service_Approval_Process__mdt> DGServiceProcess_Setting {
        get{
            if(DGServiceProcess_Setting == null) {
                DGServiceProcess_Setting = new Map<String, DG_Service_Approval_Process__mdt>();
                for (DG_Service_Approval_Process__mdt approver : [SELECT DeveloperName , Label, Case_Record_Type__c, Case_Status__c, Approver_Type__c, Queue__c, User__c  FROM DG_Service_Approval_Process__mdt]) {
                    DGServiceProcess_Setting.put(approver.Case_Record_Type__c + approver.Case_Status__c, approver);
                }
            }
            return DGServiceProcess_Setting;
        }
        set;
    }
    
    public static void OPP_stampPISUerRequester(List<Case> newCase) {
        Map<ID, Schema.RecordTypeInfo> caseRecordTypeInfoIdMap = Case.SObjectType.getDescribe().getRecordTypeInfosById();
        //List<PISUsers__c> userDGVP = [SELECT User__c FROM PISUsers__c WHERE HOLDERPOSITION__c = '60001740' Limit 1 ];
        // Find get Requester manager and Requester VP
        // change report to --> SectHeadUpUser__c
        for (Case c : newCase) {
            c.Requester_Type__c = pisUsersMap.get(c.Requester__c)?.User_Type__c;
            String recordTypeDeveloperName = caseRecordTypeInfoIdMap.get(c.RecordTypeId)?.getDeveloperName();
            // Using requester Id (User) for get user managerId (User)
            c.Requester_Manager__c = DGServiceApprovers_Setting.get(recordTypeDeveloperName)?.Requester_Manager__c == true && usersMap.containsKey(c.Requester__c) 
                //? pisUsersMap.get(c.Requester__c)?.SectHeadUpUser__c  
                ? pisUserPOSMap.get(pisUsersMap.get(c.Requester__c)?.ReportToPOS__c)?.User__c
                : null; 
            // Using user manager Id (User) for VPuserId (User)
            if(c.Requester_Type__c == 'Section Head'){
                c.Requester_VP__c = DGServiceApprovers_Setting.get(recordTypeDeveloperName)?.Requester_VP__c == true  && usersMap.containsKey(c.Requester__c) 
                ? pisUsersMap.get(c.Requester__c)?.SectHeadUpUser__c  
                : null;
            }else{
            c.Requester_VP__c = DGServiceApprovers_Setting.get(recordTypeDeveloperName)?.Requester_VP__c == true  && usersMap.containsKey(c.Requester_Manager__c) 
                //? pisUsersMap.get(c.Requester_Manager__c)?.SectHeadUpUser__c  
                ? pisUserPOSMap.get(pisUsersMap.get(c.Requester__c)?.ReportToPOS__c)?.ReportToUser__c
                : null;
            }
            // Using DGVP for PISUser (User)
            System.debug('Check DGVP>>'+DGServiceApprovers_Setting.get(recordTypeDeveloperName)?.DGVP__c);
            System.debug('DGVP Name>>'+userDGVP.User__c);
            c.DGVP__c = DGServiceApprovers_Setting.get(recordTypeDeveloperName)?.DGVP__c == true && usersMap.containsKey(userDGVP?.User__c) 
                ? userDGVP?.User__c
                : null;
        }
        
    }
    
    public static void OPP_stampCreaterEmail(List<Case> newCase) {
        for (Case c : newCase) {
            System.debug('Requesteremail>>'+c.Requester__r.Email);
            if(c.Creator_Email__c == null){
            	c.Creator_Email__c = usersMap.get(c.Requester__c)?.Email;
            }
        }
    }
    
    public static void OPP_PushNotification(List<Case> newCase) {
        // Map<Id, Case> mapCase = new Map<Id, Case>(newCase);
        // System.debug(mapCase.keySet());
        // Map<Id, ProcessInstanceHistory> mapProcessStep = new Map<Id, ProcessInstanceHistory>();
        // for (Case c : [SELECT Id, (SELECT Id, ProcessNode.name, StepStatus FROM ProcessSteps ORDER BY CreatedDate DESC) FROM Case WHERE Id IN :mapCase.keySet()]) {
        //     System.debug(c.ProcessSteps);
        //     if(c.ProcessSteps.size() > 0 ) {
        //         mapProcessStep.put(c.Id,c.ProcessSteps.get(0));
        //     }
        // }
        
        
        //List<OPP_Notification__c> updateNoti = new List<OPP_Notification__c>();
        //List<OPP_Notification__c> updateNoti = [SELECT Id, Status__c, ReferenceID__c FROM OPP_Notification__c WHERE ReferenceID__c IN :newCase.Id AND Status__c = 'New' ];
        
        List<OPP_Notification__c> insertNoti = new List<OPP_Notification__c>();
        Map<ID, Schema.RecordTypeInfo> caseRecordTypeInfoIdMap = Case.SObjectType.getDescribe().getRecordTypeInfosById();
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        CustomNotificationType type = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'OPP_Push_Notification'];
        for(Case c : newCase) {
            String recordTypeDeveloperName = caseRecordTypeInfoIdMap.get(c.RecordTypeId)?.getDeveloperName();            
            // System.debug('mtd >>' + DGServiceProcess_Setting.get(recordTypeDeveloperName + c.Status));
            // System.debug('mtd User__c >>' + DGServiceProcess_Setting.get(recordTypeDeveloperName + c.Status)?.User__c);
            System.debug('mtd Approver_Type__c>>' + DGServiceProcess_Setting.get(recordTypeDeveloperName + c.Status)?.Approver_Type__c);
            System.debug('mtd recordTypeDeveloperName + Status>>' + recordTypeDeveloperName + c.Status);
            if (DGServiceProcess_Setting.get(recordTypeDeveloperName + c.Status)?.Approver_Type__c == 'User') {
                insertNoti.add(new OPP_Notification__c(
                    Application__c = oppAppMap.get('DG_Service')?.Id,
                    Event__c = 'Action',
                    Subject__c = String.format('CaseNumber #{0} : {1}', new List<String>{ c.CaseNumber, c.Objective__c }),
                    Status__c = 'New',
                    URL__c = String.format('{0}/{1}', new List<Object>{
                        URL.getSalesforceBaseUrl().toExternalForm(),
                        c.Id
                    }),
                    Requester__c = usersMap.get(c.Requester__c)?.Name,
                    User__c = (Id) c.get(DGServiceProcess_Setting.get(recordTypeDeveloperName + c.Status)?.User__c),
                    ReferenceID__c = c.Id
                ));
            } else if (DGServiceProcess_Setting.get(recordTypeDeveloperName + c.Status)?.Approver_Type__c == 'Queue') {
                List<GroupMember> UserAppover = queueMap.get(DGServiceProcess_Setting.get(recordTypeDeveloperName + c.Status)?.Queue__c);
                for(GroupMember user : UserAppover){
                    insertNoti.add(new OPP_Notification__c(
                        Application__c = oppAppMap.get('DG_Service')?.Id,
                        Event__c = 'Action',
                        Subject__c = String.format('CaseNumber #{0} : {1}', new List<String>{ c.CaseNumber, c.Objective__c }),
                        Status__c = 'New',
                        URL__c = String.format('{0}/{1}', new List<Object>{
                            URL.getSalesforceBaseUrl().toExternalForm(),
                            c.Id
                        }),
                        Requester__c = usersMap.get(c.Requester__c)?.Name,
                        User__c = user.UserOrGroupId,
                        ReferenceID__c = c.Id
                    ));
                    String title = usersMap.get(c.Requester__c)?.Name + ' is requesting approval for case';
                    String body = String.format('Case Number #{0} : {1}', new List<String>{ c.CaseNumber, c.Objective__c });
                    notification.setTitle(title);
                    notification.setBody(body);
                    notification.setSenderId(Userinfo.getUserId());
                    notification.setNotificationTypeId(type.id);
                    notification.setTargetId(c.Id); 
                    /*Map<String, Object> pageRef = new Map<String, Object>{
                        'type' => 'standard__component',
                            'attributes' => new Map<String, Object> {
                                    }
                    };
                        notification.setTargetPageRef(JSON.serialize(pageRef));*/
                    try {
                        notification.send(new Set<String> {user.UserOrGroupId});
                    }catch (Exception e) {
                        System.debug('Problem sending notification: ' + e.getMessage());
                        System.debug(e.getStackTraceString());
                    }
                }
            }
        }
        insert insertNoti;
    }
    
    public static void OPP_UpdateNotification(List<Case> newCase){
        Map<Id ,Case> mapCase = new Map<Id ,Case>(newCase);
        List<OPP_Notification__c> updateNoti = [SELECT Id, Status__c, ReferenceID__c FROM OPP_Notification__c WHERE ReferenceID__c IN :mapCase.keySet() AND Status__c = 'New' ];
        for (OPP_Notification__c noti : updateNoti) {
            noti.Status__c = 'Done';
        }
        Update updateNoti;
    }
    
    public static void CheckStatus(Map<Id, Case> newCase, Map<Id, Case> oldCase) {
        List<Case> updateCase = new List<Case>();
        for(Case c : newCase.values()){
            System.debug('New Status: ' + newCase.get(c.Id).Status);
            System.debug('Old Status: ' + oldCase.get(c.Id).Status);
            if(newCase.get(c.Id).Status != oldCase.get(c.Id).Status){
                updateCase.add(c);
            }
        }
        CaseTriggerHandler.OPP_UpdateNotification(updateCase);
        CaseTriggerHandler.OPP_PushNotification(updateCase);
    }
    
    public static void OPP_stampCountFiles(Map<Id, Case> newCase, Map<Id, Case> oldCase) {
        
        for (Case c : [SELECT Id, Status, User_Type__c, Count_Attachment__c, RecordType.DeveloperName, (SELECT Id, ContentDocument.Title FROM ContentDocumentLinks) 
                       FROM Case 
                       WHERE Id IN :newCase.keySet() AND RecordType.DeveloperName = 'Authorization_SAP_Account'
                      ]) 
        {
            newCase.get(c.Id).Count_Attachment__c = c.ContentDocumentLinks.size();
            
            if(oldCase.get(c.Id).Status == 'Waiting for Auth Focal Point Approval'
                && (newCase.get(c.Id).Count_Attachment__c <= oldCase.get(c.Id).Count_Attachment__c)) {
                    // if(newCase.get(c.Id).Count_Attachment__c == 0 && c.User_Type__c == 'Employee') {    
                        
                    // } else if (c.User_Type__c != 'Employee') {

                    // }
                    newCase.get(c.Id).addError(String.format('{0}', new List<String>{
                        System.Label.DG_Service_Authorization_SAP_Account_Attachment
                    }), true);
               }
        }
        
    }
}