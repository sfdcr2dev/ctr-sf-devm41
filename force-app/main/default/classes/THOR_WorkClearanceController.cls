public class THOR_WorkClearanceController {
    //testt

    @AuraEnabled
    public static Boolean hasWriteAccess(String workclearanceId){
        return getUserRecordEditAccess(workclearanceId);
    }
     @AuraEnabled
    public static Boolean canApproveOrReject(String workclearanceId){
        String userId = UserInfo.getUserId();
        String userProfileId = UserInfo.getProfileId();
        List<PISUsers__c> pisusers = [ SELECT Id FROM PISUSers__c WHERE FUNCTION__c = 'EVPM' AND LEVEL__c != 'Junior' AND User__c = :userId ];

        Profile userProfile = [ SELECT PermissionsModifyAllData FROM Profile WHERE Id = :userProfileId LIMIT 1] ;

        List<String> allGroupIDs = new List<String>();
        List<GroupMember> gmList = [SELECT Id, group.id, group.name, group.type FROM GroupMember WHERE (UserOrGroupId = :UserInfo.getUserId() AND group.name = 'QMOS STAFF') OR (UserOrGroupId = :UserInfo.getUserId() AND group.name = 'QMOS PROJECT') ];
        for (GroupMember gm : gmList){
            allGroupIDs.add(gm.group.id);
        }
        
// return (pisusers.size() > 0) || userProfile.PermissionsModifyAllData ;
// return (allGroupIDs.size() > 0) || userProfile.PermissionsModifyAllData ;
        return (gmList.size() == 0) && ( (pisusers.size() > 0) || userProfile.PermissionsModifyAllData ) ;


    }

    @AuraEnabled
    public static Boolean getUserRecordEditAccess(String recordId){
      return [SELECT Id, UserRecordAccess.HasEditAccess FROM Work_Clearance__c WHERE Id = :recordId]?.UserRecordAccess.HasEditAccess;
    }

    public static String datetimeGmtString(String datetimeFormat, Boolean lasted) {
        return String.format('{0}T{1}.000+0700', new List<String>{ datetimeFormat, lasted ? '00:00:00':'23:59:59' });
    }

    @AuraEnabled
    public static String checkAbleVerify(String workclearanceId){
        // Boolean isVerified = false;
        String finalColor = 'gray'; //default
        try {
            //List<Work_Clearance__c> currentWC = [SELECT Id, Name, Work_Clearance_Status__c,Authorized_Signature__c,Authorized_Indicator__c,Authorized_Signatory__c FROM Work_Clearance__c WHERE Id =: workclearanceId LIMIT 1];
            List<Work_Clearance__c> currentWC = [SELECT Id, Name, Work_Clearance_Status__c,Authorized_Signature_UI__c,Authorized_Indicator__c,Authorized_Signatory_UI__c FROM Work_Clearance__c WHERE Id =: workclearanceId LIMIT 1];
            if (!currentWC.isEmpty()){
                // finalColor = currentWC[0].Work_Clearance_Status__c == 'In Progress' && (currentWC[0].Authorized_Signature__c != null || currentWC[0].Authorized_Indicator__c != null) && currentWC[0].Authorized_Signatory__c != null  ? 'yellow' : 'gray';
                finalColor = currentWC[0].Work_Clearance_Status__c == 'In Progress' && currentWC[0].Authorized_Signature_UI__c != null && currentWC[0].Authorized_Signatory_UI__c != null  ? 'yellow' : 'gray';
            }

            PTW_Header__c PTWHeader = [ SELECT Id, Name, Key__c, FormName__c, Work_Clearance__c, User__c, Version__c, Status__c FROM PTW_Header__c WHERE FormName__c = 'Verification' AND Work_Clearance__c = :workclearanceId ORDER BY CreatedDate];
                if (PTWHeader.Status__c == 'Agree'){
                    finalColor = 'green';
                }else if (PTWHeader.Status__c == 'Disagree'){
                    finalColor = 'red';
                }
        } catch (Exception e) {
            e.getMessage();
            e.getLineNumber();
          }
 
          return finalColor;

    }
    
    @AuraEnabled
    public static String checkInspectionStatus(String workclearanceId){
        String status = '';
        List<PTW_Header__c> ptwHeaders = [ SELECT Id, Status__c FROM PTW_Header__c WHERE FormName__c = 'Inspection' AND Work_Clearance__c = :workclearanceId ORDER BY CreatedDate DESC ];
        if (ptwHeaders.size() > 0) {
            status = ptwHeaders[0].Status__c;
        }

        List<Work_Clearance__c> workClearces = [ SELECT Verification_Status__c, Authorized_Signature_UI__c, Authorized_Indicator__c, Authorized_Signatory_UI__c, Work_Clearance_Status__c FROM Work_Clearance__c WHERE Id = :workclearanceId ];
        if (String.isEmpty(status) && workClearces.size() > 0 && workClearces[0].Verification_Status__c == 'Agree') {
            status = 'Draft';
        }
        if (String.isEmpty(status) && workClearces[0].Work_Clearance_Status__c == 'In Progress' && workClearces[0].Authorized_Signature_UI__c != null && workClearces[0].Authorized_Signatory_UI__c != null) {
            status = 'Draft';
        }

        return status;
    }
    
    @AuraEnabled
    public static Boolean checkAgreeDisagree(String workClearanceId){
        Boolean isAllAgree = true;
        try {
            PTW_Header__c PTWHeader = [ SELECT Id, Name, Key__c, FormName__c, Work_Clearance__c, User__c, Version__c, Status__c FROM PTW_Header__c WHERE FormName__c = 'Verification' AND Work_Clearance__c = :workClearanceId ORDER BY CreatedDate];
        String headerId = PTWHeader.Id;
        List<PTW_Answer__c> answerList =  [SELECT Id, Name, PTW_Header__c, Question__c, Question_Text__c, Answer__c, Key__c FROM PTW_Answer__c WHERE PTW_Header__c =: headerId];
            //List<Object> anserList = ODM_PermitToWorkVerification.getFormAnswers(workClearanceId);
            for(PTW_Answer__c answer : answerList){
                if (answer.Answer__c == 'Disagree'){
                    isAllAgree = false;
                    break;
                }
            }
            for (PTW_Answer__c answer : answerList){
                if (answer.Question_Text__c == 'Status'){
					answer.Answer__c = isAllAgree ? 'Agree' : 'Disagree';
                }
            }
            update answerList;
			PTWHeader.Status__c = isAllAgree ? 'Agree' : 'Disagree';
            update PTWHeader;
            for (PTW_Answer__c answer : answerList){
            }
          
        } catch (Exception e) {
        }
        return isAllAgree;
    }
    
    @AuraEnabled
    public static Boolean checkAbleInspec(String workclearanceId){
        Boolean isVerified = false;
        List<Work_Clearance__c> currentWC = [SELECT Id, Name, Work_Clearance_Status__c,Authorized_Signature__c,Authorized_Indicator__c FROM Work_Clearance__c WHERE Id =: workclearanceId LIMIT 1];
        if (!currentWC.isEmpty()){
			isVerified = currentWC[0].Work_Clearance_Status__c == 'In Progress'&& (currentWC[0].Authorized_Signature__c != null || currentWC[0].Authorized_Indicator__c != null) ? true : false;
        }

        return isVerified;
    }

//    private static String conditionQuery(
//        String apiField,
//        String operator,
//        String val
//    ) {
//        if(operator.equalsIgnoreCase('LIKE')) {
//            val = String.valueOf(val).replace('*', '%');
//            if(!val.contains('%')) val = '%' + val + '%';
//        }
//
//        return String.format(
//            '{0} {1} {2}',
//            new List<String>{ apiField, operator, '\'' + val + '\'' }
//        );
//    }

    public class WorkClearanceWrapper {

        @AuraEnabled
        public Work_Clearance__c WorkClearance { get; set; }

        @AuraEnabled
        public List<THOR_Work_Clearance_Historical__c> WorkClearanceHistorical { get; set; }

    }

    @AuraEnabled
    public static Master_Map__c getAreaDescriptionByCode(String areaCode) {
        List<Master_Map__c> area = [ SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant Section' AND (Name = :areaCode OR Code__c = :areaCode) ];
        return (area.size() > 0) ? area[0] : null;
    }

    @AuraEnabled
    public static List<WorkClearanceWrapper> getRelatedWorkClearancesByOrder(String orderIdentifier) {
        List<Work_Clearance__c> workClearances = [ SELECT Id, Name, Work_Clearance__c, Functional_Location__c, Description__c, toLabel(Priority__c), Priority_Map__c, Main_Work_Center__r.Name, Requester__c, Notification__r.Name, Area__c, Maintenance_Unit__c, Problem__c, Work_Detail__c, Thaioil_Supervisor_Indicator__c, Telephone_No__c, Applicant_or_Bearer__c, Telephone_No_2__c, Bearer1__c, Bearer2__c, Bearer3__c, Can_go_wrong1__c, Can_go_wrong2__c, Can_go_wrong3__c, Can_go_wrong4__c, Cause1__c, Cause2__c, Cause3__c, Cause4__c, Prevent1__c, Prevent2__c, Prevent3__c, Prevent4__c, Authorized_Signature__c, Check_Date__c, Check_Time__c, Extend_No__c, Extend_Time_To__c, Close_Applicant_or_Bearer__c, Extend_Applicant_or_Bearer__c, Extend_Authorized_Sign__c, Close_Authorized_Sign_off__c, Sign_off_Flag__c, Applicant_or_Bearer_Telephone__c, TOP_Supervisor_Telephone__c, Authorized_Signatory__c, Extend_Time_Flag__c, Authorized_Indicator__c, Work_Clearance_Historical__c, Latitude__c, Longitude__c FROM Work_Clearance__c WHERE Order__c = :orderIdentifier ORDER BY CreatedDate DESC ];

        List<String> workClearanceNumbers = new List<String>();
        for (Work_Clearance__c wc : workClearances) {
            workClearanceNumbers.add(wc.Name);
        }
        List<THOR_Work_Clearance_Historical__c> history = [ SELECT Id, Name, Work_Clearance__c, FunctionalLocation__c, Functional_Location__c, Description__c, toLabel(Priority__c), Priority_Map__c, Main_Work_Center__r.Name, Requester__c, Notification__r.Name, Area__c, Maintenance_Unit__c, Problem__c, Work_Detail__c, Thaioil_Supervisor_Indicator__c, Applicant_or_Bearer__c, Bearer1__c, Bearer2__c, Bearer3__c, Can_go_wrong1__c, Can_go_wrong2__c, Can_go_wrong3__c, Can_go_wrong4__c, Cause1__c, Cause2__c, Cause3__c, Cause4__c, Prevent1__c, Prevent2__c, Prevent3__c, Prevent4__c, Authorized_Signature__c, Check_Date__c, Check_Time__c, Extend_Time_To__c, Extend_No__c, Close_Applicant_or_Bearer__c, Extend_Applicant_or_Bearer__c, Extend_Authorized_Sign__c, Close_Authorized_Sign_off__c, Sign_off_Flag__c, Applicant_or_Bearer_Telephone__c, TOP_Supervisor_Telephone__c, Authorized_Signatory__c, Extend_Time_Flag__c, Authorized_Indicator__c FROM THOR_Work_Clearance_Historical__c WHERE Work_Clearance__c IN :workClearanceNumbers ORDER BY Extend_No__c DESC ];

        List<WorkClearanceWrapper> wrappers = new List<WorkClearanceWrapper>();
        for (Work_Clearance__c wc : workClearances) {
            WorKClearanceWrapper wrapper = new WorkClearanceWrapper();
            List<THOR_Work_Clearance_Historical__c> wchs = new List<THOR_Work_Clearance_Historical__c>();
            for (THOR_Work_Clearance_Historical__c wch : history) {
                if (wc.Name.equalsIgnoreCase(wch.Work_Clearance__c) && !wc.Work_Clearance_Historical__c.equals(wch.Id) ) {
                    wchs.add(wch);
                }
            }
            wrapper.WorkClearance = wc;
            wrapper.WorkClearanceHistorical = wchs;
            wrappers.add(wrapper);
        }

        return wrappers;
    }

    @AuraEnabled
    public static List<WorkClearanceWrapper> getRelatedWorkClearancesByNotification(String notificationIdentifier) {
        List<Work_Clearance__c> workClearances = [ SELECT Id, Name, Work_Clearance__c, Functional_Location__c, Description__c, toLabel(Priority__c), Priority_Map__c, Main_Work_Center__r.Name, Requester__c, Notification__r.Name, Area__c, Maintenance_Unit__c, Problem__c, Work_Detail__c, Thaioil_Supervisor_Indicator__c, Telephone_No__c, Applicant_or_Bearer__c, Telephone_No_2__c, Bearer1__c, Bearer2__c, Bearer3__c, Can_go_wrong1__c, Can_go_wrong2__c, Can_go_wrong3__c, Can_go_wrong4__c, Cause1__c, Cause2__c, Cause3__c, Cause4__c, Prevent1__c, Prevent2__c, Prevent3__c, Prevent4__c, Authorized_Signature__c, Check_Date__c, Check_Time__c, Extend_No__c, Extend_Time_To__c, Close_Applicant_or_Bearer__c, Extend_Applicant_or_Bearer__c, Extend_Authorized_Sign__c, Close_Authorized_Sign_off__c, Sign_off_Flag__c, Applicant_or_Bearer_Telephone__c, TOP_Supervisor_Telephone__c, Authorized_Signatory__c, Extend_Time_Flag__c, Authorized_Indicator__c, Work_Clearance_Historical__c, Latitude__c, Longitude__c FROM Work_Clearance__c WHERE Notification__c = :notificationIdentifier ORDER BY CreatedDate DESC ];

        List<String> workClearanceNumbers = new List<String>();
        for (Work_Clearance__c wc : workClearances) {
            workClearanceNumbers.add(wc.Name);
        }

        List<THOR_Work_Clearance_Historical__c> history = [ SELECT Id, Name, Work_Clearance__c, FunctionalLocation__c, Functional_Location__c, Description__c, toLabel(Priority__c), Priority_Map__c, Main_Work_Center__r.Name, Requester__c, Notification__r.Name, Area__c, Maintenance_Unit__c, Problem__c, Work_Detail__c, Thaioil_Supervisor_Indicator__c, Applicant_or_Bearer__c, Bearer1__c, Bearer2__c, Bearer3__c, Can_go_wrong1__c, Can_go_wrong2__c, Can_go_wrong3__c, Can_go_wrong4__c, Cause1__c, Cause2__c, Cause3__c, Cause4__c, Prevent1__c, Prevent2__c, Prevent3__c, Prevent4__c, Authorized_Signature__c, Check_Date__c, Check_Time__c, Extend_Time_To__c, Extend_No__c, Close_Applicant_or_Bearer__c, Extend_Applicant_or_Bearer__c, Extend_Authorized_Sign__c, Close_Authorized_Sign_off__c, Sign_off_Flag__c, Applicant_or_Bearer_Telephone__c, TOP_Supervisor_Telephone__c, Authorized_Signatory__c, Extend_Time_Flag__c, Authorized_Indicator__c FROM THOR_Work_Clearance_Historical__c WHERE Work_Clearance__c IN :workClearanceNumbers ORDER BY CreatedDate DESC ];

        List<WorkClearanceWrapper> wrappers = new List<WorkClearanceWrapper>();
        for (Work_Clearance__c wc : workClearances) {
            WorKClearanceWrapper wrapper = new WorkClearanceWrapper();
            List<THOR_Work_Clearance_Historical__c> wchs = new List<THOR_Work_Clearance_Historical__c>();
            for (THOR_Work_Clearance_Historical__c wch : history) {
                if (wc.Name.equalsIgnoreCase(wch.Work_Clearance__c) && !wc.Work_Clearance_Historical__c.equals(wch.Id) ) {
                    wchs.add(wch);
                }
            }
            wrapper.WorkClearance = wc;
            wrapper.WorkClearanceHistorical = wchs;
            wrappers.add(wrapper);
        }

        return wrappers;
    }

    @AuraEnabled
    public static Object getWorkClearanceById(String workclearanceIdentifier) {
        String recIdPrefix = String.valueOf(workclearanceIdentifier).substring(0,3);
        String prefixWorkClearanceHistorical = Schema.SObjectType.THOR_Work_Clearance_Historical__c.getKeyPrefix();

        if (prefixWorkClearanceHistorical != null && prefixWorkClearanceHistorical.equals(recIdPrefix)) {
            List<THOR_Work_Clearance_Historical__c> workClearanceHistoricals = [ SELECT Id, Name, Extend_No__c, Work_Clearance__c, Functional_Location__c, Description__c, Work_Clearance_Description__c, toLabel(Priority__c), Main_Work_Center__r.Name, Requester__c, Notification__r.Name, Order__r.Name, Area__c, Maintenance_Unit__c, Problem__c, Work_Detail__c, Thaioil_Supervisor_Indicator__c, Applicant_or_Bearer__c, Bearer1__c, Bearer2__c, Bearer3__c, Can_go_wrong1__c, Can_go_wrong2__c, Can_go_wrong3__c, Can_go_wrong4__c, Can_go_wrong5__c, Can_go_wrong6__c, Cause1__c, Cause2__c, Cause3__c, Cause4__c, Cause5__c, Cause6__c, Prevent1__c, Prevent2__c, Prevent3__c, Prevent4__c, Prevent5__c, Prevent6__c, Authorized_Signature__c, Check_Date__c, Check_Time__c, Extend_Time_To__c, Close_Applicant_or_Bearer__c, Extend_Applicant_or_Bearer__c, Extend_Authorized_Sign__c, Close_Authorized_Sign_off__c, Sign_off_Flag__c, Applicant_or_Bearer_Telephone__c, TOP_Supervisor_Telephone__c, Authorized_Signatory__c, Extend_Time_Flag__c, Authorized_Indicator__c, Safety_Permit1__c, Safety_Permit2__c, Safety_Permit3__c, User_Status__c, Integration_Status__c, System_Status__c FROM THOR_Work_Clearance_Historical__c WHERE Id = :workclearanceIdentifier ORDER BY CreatedDate DESC ];

            if (workClearanceHistoricals.size() > 0) {
                return workClearanceHistoricals[0];
            }
        }

        List<Work_Clearance__c> workClearances = [ SELECT Id, Name, Extend_No__c, Work_Clearance__c, Functional_Location__c, FunctionalLocation__r.Name, Description__c, Work_Clearance_Description__c, toLabel(Priority__c), toLabel(High_Risk_Work__c), Main_Work_Center__r.Name, Requester__c, Requester_UI__r.ENFIRSTNAME__c, Requester_UI__r.ENLASTNAME__c, Notification__r.Name, Order__r.Name, Area__c, Maintenance_Unit__c, Problem__c, Work_Detail__c, Thaioil_Supervisor_Indicator__c, Thaioil_Supervisor_Indicator_UI__r.ENFIRSTNAME__c, Thaioil_Supervisor_Indicator_UI__r.ENLASTNAME__c, Telephone_No__c, Applicant_or_Bearer__c, Applicant_or_Bearer_UI__r.Description__c, Telephone_No_2__c, Bearer1__c, Bearer1_UI__r.Description__c, Bearer2__c, Bearer2_UI__r.Description__c, Bearer3__c, Bearer3_UI__r.Description__c, Bearer4__c, Bearer4_UI__r.Description__c, Can_go_wrong1__c, Can_go_wrong2__c, Can_go_wrong3__c, Can_go_wrong4__c, Can_go_wrong5__c, Can_go_wrong6__c, Cause1__c, Cause2__c, Cause3__c, Cause4__c, Cause5__c, Cause6__c, Prevent1__c, Prevent2__c, Prevent3__c, Prevent4__c, Prevent5__c, Prevent6__c, Authorized_Signature__c, Authorized_Signature_UI__r.ENFIRSTNAME__c, Authorized_Signature_UI__r.ENLASTNAME__c, Check_Date__c, Check_Time__c, Extend_Time_To__c, Extend_Time_To_UI__c, Extend_Date__c, Extend_Time__c, Close_Applicant_or_Bearer__c, Close_Applicant_or_Bearer_UI__r.ENFIRSTNAME__c, Close_Applicant_or_Bearer_UI__r.ENLASTNAME__c, Extend_Applicant_or_Bearer__c, Extend_Applicant_or_Bearer_UI__r.ENFIRSTNAME__c, Extend_Applicant_or_Bearer_UI__r.ENLASTNAME__c, Extend_Authorized_Sign__c, Extend_Authorized_Sign_UI__r.ENFIRSTNAME__c, Extend_Authorized_Sign_UI__r.ENLASTNAME__c, Close_Authorized_Sign_off__c, Close_Authorized_Sign_off_UI__r.ENFIRSTNAME__c, Close_Authorized_Sign_off_UI__r.ENLASTNAME__c, Sign_off_Flag__c, Applicant_or_Bearer_Telephone__c, TOP_Supervisor_Telephone__c, Authorized_Signatory__c, Authorized_Signatory_UI__r.ENFIRSTNAME__c, Authorized_Signatory_UI__r.ENLASTNAME__c, Extend_Time_Flag__c, Authorized_Indicator__c, Authorized_Indicator_UI__r.ENFIRSTNAME__c, Authorized_Indicator_UI__r.ENLASTNAME__c, Safety_Permit1__c, Safety_Permit1_UI__r.Name, Safety_Permit2__c, Safety_Permit2_UI__r.Name, Safety_Permit3__c, Safety_Permit3_UI__r.Name, User_Status__c, Integration_Status__c, System_Status__c, Work_Clearance_Status__c, Latitude__c, Longitude__c FROM Work_Clearance__c WHERE Id = :workclearanceIdentifier ORDER BY CreatedDate DESC ];


        return (workClearances.size() > 0) ? workClearances[0] : null;
    }
    @AuraEnabled
    public static Object getWCByIdAfterClickSavePinMap(String workclearanceIdentifier, String latitude, String longitude) {
        String recIdPrefix = String.valueOf(workclearanceIdentifier).substring(0,3);
        String prefixWorkClearanceHistorical = Schema.SObjectType.THOR_Work_Clearance_Historical__c.getKeyPrefix();

        List<Work_Clearance__c> workClearances = [ SELECT Id, Latitude__c, Longitude__c FROM Work_Clearance__c WHERE Id = :workclearanceIdentifier ORDER BY CreatedDate DESC ]; 
        for (Work_Clearance__c wc : workClearances) {
            wc.Latitude__c = latitude;
            wc.Longitude__c = longitude;
        }
//update workClearances;
        Database.SaveResult [] workClearances_cr = Database.update(workClearances, false);

        return (workClearances.size() > 0) ? workClearances[0] : null;
    }

    @AuraEnabled
    public static Functional_Location__c getFunctionalLocationDetailById(Id functionalLocationId) {
        List<Functional_Location__c> functionalLocations = [ SELECT Id, Name, Description__c, Planning_Plant__c, Planning_Plant__r.Name, PlantSection__c, MainWorkCenter__c, MainWorkCenter__r.Name, Latitude__c, Longitude__c FROM Functional_Location__c WHERE Id = :functionalLocationId ];

        return (functionalLocations.size() > 0) ? functionalLocations[0] : null;
    }

    @AuraEnabled
    public static Notification__c getNotificationDetailById(Id notificationId) {
        List<Notification__c> notifications = [ SELECT Id, Name, Notification_Number__c, Functional_Location__c, Functional_Location__r.Name, Functional_Location__r.PlantSection__c, Functional_Location__r.Description__c, Priority__c, Requester__c, Requester_PISUser__r.Name, Plant_Section__c, Planning_Plant__r.Name, Functional_Location__r.Planning_Plant__r.Name, Main_Work_Center__c, Main_Work_Center__r.Name, Main_Work_Center_Text__c, Description__c FROM Notification__c WHERE Id = :notificationId ];

        return (notifications.size() > 0) ? notifications[0] : null;
    }

    @AuraEnabled
    public static Order__c getOrderDetailById(Id orderId) {
        List<Order__c> orders = [ SELECT Id, Name, Order_Number__c, Functional_Location__c, Functional_Location__r.Name, Functional_Location__r.PlantSection__c, Functional_Location__r.Description__c, Priority__c, Requester__c, Requester_PISUser__r.Name, Plant_Section__c, Planning_Plant__r.Name, Functional_Location__r.Planning_Plant__r.Name, Main_Work_Center__c, Main_Work_Center__r.Name, Main_Work_Center_Text__c, Description__c FROM Order__c WHERE Id = :orderId ];

        return (orders.size() > 0) ? orders[0] : null;
    }

//    private static List<String> parseWorkClearanceFilterObject(Map<String, Object> filter)
//    {
//        List<String> filterMapping = new List<String>();
//        if (filter.containsKey('Clearance_Number__c')) filter.put('Name', filter.remove('Clearance_Number__c'));
//        if (filter.containsKey('Work_Clearance_Status__c')) filter.put('System_Status__c', filter.remove('Work_Clearance_Status__c'));
//        if (filter.containsKey('Functional_Location__c')) filter.put('Functional_Location__c', filter.remove('Functional_Location__c'));
//
//        if (filter.containsKey('Create_Date_From__c')) filterMapping.add('CreatedDate >= ' + datetimeGmtString(String.valueOf(filter.get('Create_Date_From__c')), false));
//        if (filter.containsKey('Create_Date_To__c')) filterMapping.add('CreatedDate <= ' + datetimeGmtString(String.valueOf(filter.get('Create_Date_To__c')), true));
//
//        if (filter.containsKey('Notification_Number__c')) filter.put('Notification__r.Notification_Number__c', filter.remove('Notification_Number__c'));
//        if (filter.containsKey('Notification_Type__c')) filter.put('Notification__r.Type__c', filter.remove('Notification_Type__c'));
//        if (filter.containsKey('Order_Number__c')) filter.put('Order__r.Order_Number__c', filter.remove('Order_Number__c'));
//        if (filter.containsKey('Order_Type__c')) filter.put('Order__r.Order_Type__c', filter.remove('Order_Type__c'));
//        if (filter.containsKey('Priority__c')) filter.put('Priority__c', filter.remove('Priority__c'));
//
//        Map<String, Schema.SObjectField> sObjectField = Schema.getGlobalDescribe()
//            .get('Work_Clearance__c'.toLowerCase())
//            .getDescribe()
//            .fields
//            .getMap();
//        for (String f : filter.keySet()) {
//            if (!sObjectField.containsKey(f) && !f.contains('__r')) {
//                filter.remove(f);
//            }
//        }
//
//        for (String apiField : filter.keySet()) {
//            Object value = filter.get(apiField);
//
//            if(sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.BOOLEAN) {
//                filterMapping.add(String.format('{0} {1} {2}', new List<Object>{ apiField, '=' , (Boolean)value }));
//            }
//            else if(sObjectField.get(apiField)?.getDescribe()?.getType() === Schema.DisplayType.REFERENCE) {
//                filterMapping.add(conditionQuery(apiField, '=', String.valueOf(value)));
//            }
//            else {
//                filterMapping.add(conditionQuery(apiField, 'LIKE', String.valueOf(value)));
//            }
//        }
//
//        if (filter.containsKey('Requester__c')){
//            String Requester =  String.valueOf(filter.remove('Requester__c')); // Employee Id or Fullname
//
//            Requester = Requester.replace('*', '%');
//            if (!Requester.contains('%')) {
//                Requester = '%' + Requester + '%';
//            }
//
//            List<String> users = new List<String>();
//            for (User u : [SELECT Id, Name, Employee_Id__c FROM User WHERE Employee_Id__c LIKE :Requester LIMIT 10]) {
//                users.add('\'' + u.Name + '\'');
//            }
//
//            if (users.size() > 0) {
//                filterMapping.add(String.format('({0} OR Requester__c IN ({1}))', new List<String>{
//                    conditionQuery('Requester__c', 'LIKE', Requester), String.join(users, ',')
//                }));
//            } else {
//                filterMapping.add(String.format('({0})', new List<String>{
//                    conditionQuery('Requester__c', 'LIKE', Requester)
//                }));
//            }
//        }
//
//        return filterMapping;
//    }

    @AuraEnabled
    public static List<Work_Clearance__c> getWithoutNotiAndOrderWorkClearancesByFilter(Map<String, Object> filter, Integer offset, Integer rowlimit) {
//        try {
//            List<String> filterMapping = parseWorkClearanceFilterObject(filter);
//
//            String query = String.format(
//                'SELECT {0} FROM Work_Clearance__c {1} {2} ORDER BY Name DESC {3} {4}',
//                new List<String>{
//                    String.join( // fields
//                        new List<String>{
//                            'Id',
//                            'Name',
//                            'Description__c',
//                            'Priority__c',
//                            'Functional_Location__c',
//                            'Main_Work_Center__r.Name'
//                        },
//                        ','
//                    ),
//                    String.format('WHERE {0} AND ({1})', new List<String>{
//                        conditionQuery('System_Status__c', '=', 'CRTE'),
//                        String.join(new List<String>{
//                            'Notification__c = null',
//                            'Order__c = null'
//                        }, ' AND ')
//                    }),
//                    filterMapping.size() > 0 // condition (optional)
//                        ? String.format(
//                                'AND {0}',
//                                new List<Object>{ String.join(filterMapping, ' AND ') }
//                            )
//                        : '',
//                    String.format('LIMIT {0}', new List<String>{ String.valueOf(rowlimit) }),
//                    String.format('OFFSET {0}', new List<String>{ String.valueOf(offset) })
//                }
//            );
//            System.debug(query);
//            return Database.query(query);
//        } catch (Exception e) {
//            System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
//            System.debug(System.LoggingLevel.ERROR, e.getMessage());
//            throw new AuraHandledException(e.getMessage());
//        }
        return THOR_NotificationListPagingCtrl.getWithoutNotiAndOrderWorkClearancesByFilter(filter, offset, rowlimit);
    }

    @AuraEnabled
    public static List<Work_Clearance__c> getInProgressWorkClearancesByFilter(Map<String, Object> filter, Integer offset, Integer rowlimit) {
        return THOR_NotificationListPagingCtrl.getInProgressWorkClearancesByFilter(filter, offset, rowlimit);
    }

    @AuraEnabled
    public static Integer getCountWithoutNotiAndOrderWorkClearancesByFilter(
        Map<String, Object> filter
    ) {
//        try {
//            List<String> filterMapping = parseWorkClearanceFilterObject(filter);
//
//            String query = String.format(
//                'SELECT {0} FROM Work_Clearance__c {1} {2}',
//                new List<String>{
//                    String.join( // fields
//                        new List<String>{
//                            'COUNT()'
//                        },
//                        ','
//                    ),
//                    String.format('WHERE {0} AND ({1})', new List<String>{
//                        conditionQuery('System_Status__c', '=', 'CRTE'),
//                        String.join(new List<String>{
//                            'Notification__c = null',
//                            'Order__c = null'
//                        }, ' AND ')
//                    }),
//                    filterMapping.size() > 0 // condition (optional)
//                        ? String.format(
//                                'AND {0}',
//                                new List<Object>{ String.join(filterMapping, ' AND ') }
//                            )
//                        : ''
//                }
//            );
//            System.debug(query);
//            return Database.countQuery(query);
//        } catch (Exception e) {
//            System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
//            System.debug(System.LoggingLevel.ERROR, e.getMessage());
//            throw new AuraHandledException(e.getMessage());
//        }
        return THOR_NotificationListPagingCtrl.getCountWithoutNotiAndOrderWorkClearancesByFilter(filter);
    }

    @AuraEnabled
    public static Integer getCountInProgressWorkClearancesByFilter(
        Map<String, Object> filter
    ) {
//        try {
//            List<String> filterMapping = parseWorkClearanceFilterObject(filter);
//
//            String query = String.format(
//                'SELECT {0} FROM Work_Clearance__c {1} {2}',
//                new List<String>{
//                    String.join( // fields
//                        new List<String>{
//                            'COUNT()'
//                        },
//                        ','
//                    ),
//                    String.format('WHERE {0} AND ({1})', new List<String>{
//                        conditionQuery('System_Status__c', '=', 'CRTE'),
//                        String.join(new List<String>{
//                            'Notification__c != null',
//                            'Order__c != null'
//                        }, ' OR ')
//                    }),
//                    filterMapping.size() > 0 // condition (optional)
//                        ? String.format(
//                                'AND {0}',
//                                new List<Object>{ String.join(filterMapping, ' AND ') }
//                            )
//                        : ''
//                }
//            );
//            System.debug(query);
//            return Database.countQuery(query);
//        } catch (Exception e) {
//            System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
//            System.debug(System.LoggingLevel.ERROR, e.getMessage());
//            throw new AuraHandledException(e.getMessage());
//        }
        return THOR_NotificationListPagingCtrl.getCountInProgressWorkClearancesByFilter(filter);
    }

    private static String queryLike(String fieldName, String searchText) {
        return THOR_NotificationListPagingCtrl.conditionQuery(fieldName, 'LIKE', searchText);
    }

    @AuraEnabled
    public static List<sObject> getPISRequester(String searchText) {
        List<String> recentlyPISUserIds = new List<String>();
        if (String.isEmpty(searchText)) {
            for (RecentlyViewed variable : [SELECT Id, Name FROM RecentlyViewed WHERE Type = 'PISUsers__c' ORDER BY LastViewedDate DESC]) {
                recentlyPISUserIds.add(String.format('{0}', new List<String>{ '\'' + variable.Id + '\'' }));
            }
        }

        String query = String.format( 'SELECT Id, Name, ENFIRSTNAME__c, ENLASTNAME__c, THFIRSTNAME__c, THLASTNAME__c, EMPLOYEEID__c, DEPARTMENT__c, User__c FROM PISUsers__c WHERE {0} ORDER BY EMPLOYEEID__c LIMIT 7', new List<String>{ String.isNotEmpty(searchText) ? String.join( new List<String>{ queryLike('Name', searchText), queryLike('THFIRSTNAME__c', searchText), queryLike('THLASTNAME__c', searchText), queryLike('ENFIRSTNAME__c', searchText), queryLike('ENLASTNAME__c', searchText), queryLike('DEPARTMENT__c', searchText), queryLike('EMPLOYEEID__c', searchText) }, ' OR ' ) : String.format('Id IN ({0})', new List<String>{ String.join(recentlyPISUserIds, ',') }) } );
        try {
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<sObject> getApplicantOrBearer(String searchText) {
        List<String> recentlyBearerIds = new List<String>();
        if (String.isEmpty(searchText)) {
            for (RecentlyViewed variable : [SELECT Id, Name FROM RecentlyViewed WHERE Type = 'THOR_Applicant_Bearer__c' ORDER BY LastViewedDate DESC]) {
                recentlyBearerIds.add(String.format('{0}', new List<String>{ '\'' + variable.Id + '\'' }));
            }
        }

        String query = String.format( 'SELECT Id, Name, Code__c FROM THOR_Applicant_Bearer__c WHERE {0} ORDER BY Name LIMIT 7', new List<String>{ String.isNotEmpty(searchText) ? String.join( new List<String>{ queryLike('Name', searchText), queryLike('Code__c', searchText) }, ' OR ' ) : String.format('Id IN ({0})', new List<String>{ String.join(recentlyBearerIds, ',') }) } );
        try {
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }



    @AuraEnabled
    public static List<sObject> getSafetyPermit(String searchText) {
        List<String> recentlyBearerIds = new List<String>();
        if (String.isEmpty(searchText)) {
            for (RecentlyViewed variable : [SELECT Id, Name FROM RecentlyViewed WHERE Type = 'Safety_Permit__c' ORDER BY LastViewedDate DESC]) {
                recentlyBearerIds.add(String.format('{0}', new List<String>{ '\'' + variable.Id + '\'' }));
            }
        }

        String query = String.format( 'SELECT Id, Name FROM Safety_Permit__c WHERE {0} ORDER BY Name LIMIT 7', new List<String>{ String.isNotEmpty(searchText) ? String.join( new List<String>{ queryLike('Name', searchText) }, ' OR ' ) : String.format('Id IN ({0})', new List<String>{ String.join(recentlyBearerIds, ',') }) } );
        try {
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, PISUsers__c> getPISUsers(List<String> hostOrHomeIdList) {
        List<String> idList = new List<String>();
        for (String hostOrHomeId : hostOrHomeIdList) {
            idList.add(hostOrHomeId?.trim().leftPad(8, '0'));
        }

        List<PISUsers__c> pisusers = [ SELECT Id, Name, EMPLOYEEID__c, HOST_ID__c, HOME_ID__c, ENFIRSTNAME__c, ENLASTNAME__c FROM PISUsers__c WHERE HOST_ID__c IN :idList OR HOME_ID__c IN :idList ];
        Map<String, PISUsers__c> mapPisUsers = new Map<String, PISUsers__c>();
        if (pisusers.size() > 0) {
            for (PISUsers__c pisuser : pisusers) {
                if (String.isNotBlank(pisuser.HOST_ID__c)) {
                    mapPisUsers.put(pisuser.HOST_ID__c, pisuser);
                }
                if (String.isNotBlank(pisuser.HOME_ID__c)) {
                    mapPisUsers.put(pisuser.HOME_ID__c, pisuser);
                }
            }
            return mapPisUsers;
        }
        return null;
    }
    
    @AuraEnabled
    public static Map<String, PISUsers__c> getPISUserList(List<String> pisuserIds) {
        List<PISUsers__c> pisusers = [ SELECT Id, Name, EMPLOYEEID__c, HOST_ID__c, HOME_ID__c, ENFIRSTNAME__c, ENLASTNAME__c FROM PISUsers__c WHERE Id IN :pisuserIds ];
        Map<String, PISUsers__c> mapPisUsers = new Map<String, PISUsers__c>();
        if (pisusers.size() > 0) {
            for (PISUsers__c pisuser : pisusers) {
                mapPisUsers.put(pisuser.Id, pisuser);
            }
            return mapPisUsers;
        }
        return null;
    }

    @AuraEnabled
    public static PISUsers__c getCurrentPISUser() {
        List<PISUsers__c> pisusers = [ SELECT Id, Name, ENFIRSTNAME__c, ENLASTNAME__c FROM PISUsers__c WHERE User__c = :UserInfo.getUserId() ];
        if (pisusers.size() > 0) {
            return pisusers[0];
        }
        return null;
    }

    //@AuraEnabled
    //public static Map<String, Master_Map__c> getAreas() {
    //    Map<String, Master_Map__c> masters = new Map<String, Master_Map__c>();
    //    for (Master_Map__c master : [
    //        SELECT
    //            Id,
    //            Name,
    //            Description__c
    //        FROM Master_Map__c
    //        WHERE Type__c = 'Plant Section'
    //    ]) {
    //        masters.put(master.Name, master);
    //    }
    //    return masters;
    //}
    
    @AuraEnabled
    public static List<Master_Map__c> getAreas() {
        return [ SELECT Id, Name, Description__c FROM Master_Map__c WHERE Type__c = 'Plant Section' ];
    }

    @AuraEnabled
    public static Map<String, THOR_Applicant_Bearer__c> getApplicantOrBearerList(List<String> bearerIds) {
        List<THOR_Applicant_Bearer__c> bearers = [ SELECT Id, Name, Description__c FROM THOR_Applicant_Bearer__c WHERE Id IN :bearerIds ];
        Map<String, THOR_Applicant_Bearer__c> mapBearers = new Map<String, THOR_Applicant_Bearer__c>();
        if (bearers.size() > 0) {
            for (THOR_Applicant_Bearer__c bearer : bearers) {
                mapBearers.put(bearer.Id, bearer);
            }
            return mapBearers;
        }
        return null;
    }

    @AuraEnabled
    public static String getUserName() {
        return UserInfo.getUserName();
    }
}