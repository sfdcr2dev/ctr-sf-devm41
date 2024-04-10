public class THOR_NotificationRelatedWcCreationCtrl {

    /*
    public class WorkClearanceWrapper {

        @AuraEnabled
        public Work_Clearance__c WorkClearance { get; set; }

        @AuraEnabled
        public List<THOR_Work_Clearance_Historical__c> WorkClearanceHistorical { get; set; }

    }

    @AuraEnabled
    public static Notification__c getNotificationDetailById(Id notificationId) {
        Notification__c notiDetail = [
            SELECT
                Id,
                Notification_Number__c,
                Functional_Location__c,
                Functional_Location__r.Name,
                Functional_Location__r.PlantSection__c,
                Priority__c,
                Requester__c,
                Requester_PISUser__r.Name,
                Planning_Plant__r.Name,
                Functional_Location__r.Planning_Plant__r.Name,
                Plant_Section__c,
                Main_Work_Center__c,
                Main_Work_Center__r.Name,
                Main_Work_Center_Text__c,
                Description__c
            FROM Notification__c
            WHERE Id = :notificationId
            LIMIT 1
        ];

        System.debug('notiDetail='+ notiDetail);
        return notiDetail;
    }

    @AuraEnabled
    public static Order__c getOrderDetailById(Id orderId) {

        Order__c odDetail = [
                SELECT
                    Id,
                    Order_Number__c,
                    Functional_Location__c,
                    Functional_Location__r.Name,
                    Functional_Location__r.PlantSection__c,
                    Priority__c,
                    Requester__c,
                    Plant_Section__c,
                    Main_Work_Center__c,
                    Main_Work_Center__r.Name,
                    Main_Work_Center_Text__c,
                    Description__c


                FROM Order__c
                WHERE Id = :orderId
                LIMIT 1
            ];

            System.debug('odDetail='+ odDetail);
            return odDetail;

    }

    @AuraEnabled
    public static Work_Clearance__c getRelatedWorkClearances(String notificationIdentifier) {
            Work_Clearance__c workClearances = [
                SELECT
                    Id,
                    Name,
                    Work_Clearance__c,
                    Functional_Location__c,
                    Description__c,
                    Priority__c,
                    Main_Work_Center__r.Name,
                    Requester__c,
                    Notification__r.Name,
                    Area__c,
                    Maintenance_Unit__c,
                    Problem__c,
                    Work_Detail__c,
                    Thaioil_Supervisor_Indicator__c,
                    Telephone_No__c,
                    Applicant_or_Bearer__c,
                    Telephone_No_2__c,
                    Bearer1__c,
                    Bearer2__c,
                    Bearer3__c,
                    Can_go_wrong1__c,
                    Can_go_wrong2__c,
                    Can_go_wrong3__c,
                    Can_go_wrong4__c,
                    Cause1__c,
                    Cause2__c,
                    Cause3__c,
                    Cause4__c,
                    Prevent1__c,
                    Prevent2__c,
                    Prevent3__c,
                    Prevent4__c,
                    Authorized_Signature__c,
                    Check_Date__c,
                    Check_Time__c,
                    Extend_Time_To__c,
                    Close_Applicant_or_Bearer__c,
                    Extend_Applicant_or_Bearer__c,
                    Extend_Authorized_Sign__c,
                    Close_Authorized_Sign_off__c,
                    Sign_off_Flag__c,
                    Applicant_or_Bearer_Telephone__c,
                    TOP_Supervisor_Telephone__c,
                    Authorized_Signatory__c,
                    Extend_Time_Flag__c,
                    Authorized_Indicator__c
                FROM Work_Clearance__c
                WHERE Notification__c = :notificationIdentifier
                ORDER BY CreatedDate DESC LIMIT 1
            ];
            return workClearances;

    }
    

    @AuraEnabled
    public static List<WorkClearanceWrapper> getRelatedWorkClearances(String notificationIdentifier) {
        List<Work_Clearance__c> workClearances = [
            SELECT
                Id,
                Name,
                Work_Clearance__c,
                Functional_Location__c,
                Description__c,
                Priority__c,
                Main_Work_Center__r.Name,
                Requester__c,
                Notification__r.Name,
                Area__c,
                Maintenance_Unit__c,
                Problem__c,
                Work_Detail__c,
                Thaioil_Supervisor_Indicator__c,
                Telephone_No__c,
                Applicant_or_Bearer__c,
                Telephone_No_2__c,
                Bearer1__c,
                Bearer2__c,
                Bearer3__c,
                Can_go_wrong1__c,
                Can_go_wrong2__c,
                Can_go_wrong3__c,
                Can_go_wrong4__c,
                Cause1__c,
                Cause2__c,
                Cause3__c,
                Cause4__c,
                Prevent1__c,
                Prevent2__c,
                Prevent3__c,
                Prevent4__c,
                Authorized_Signature__c,
                Check_Date__c,
                Check_Time__c,
                Extend_Time_To__c,
                Close_Applicant_or_Bearer__c,
                Extend_Applicant_or_Bearer__c,
                Extend_Authorized_Sign__c,
                Close_Authorized_Sign_off__c,
                Sign_off_Flag__c,
                Applicant_or_Bearer_Telephone__c,
                TOP_Supervisor_Telephone__c,
                Authorized_Signatory__c,
                Extend_Time_Flag__c,
                Authorized_Indicator__c,
                Work_Clearance_Historical__c
            FROM Work_Clearance__c
            WHERE Notification__c = :notificationIdentifier
            ORDER BY CreatedDate DESC
        ];

        List<String> workClearanceNumbers = new List<String>();
        for (Work_Clearance__c wc : workClearances) {
            workClearanceNumbers.add(wc.Name);
        }

        List<THOR_Work_Clearance_Historical__c> history = [
            SELECT
                Id,
                Name,
                Work_Clearance__c,
                FunctionalLocation__c,
                Description__c,
                Priority__c,
                Main_Work_Center__r.Name,
                Requester__c,
                Notification__r.Name,
                Area__c,
                Maintenance_Unit__c,
                Problem__c,
                Work_Detail__c,
                Thaioil_Supervisor_Indicator__c,
                //Telephone_No__c,
                Applicant_or_Bearer__c,
                //Telephone_No_2__c,
                Bearer1__c,
                Bearer2__c,
                Bearer3__c,
                Can_go_wrong1__c,
                Can_go_wrong2__c,
                Can_go_wrong3__c,
                Can_go_wrong4__c,
                Cause1__c,
                Cause2__c,
                Cause3__c,
                Cause4__c,
                Prevent1__c,
                Prevent2__c,
                Prevent3__c,
                Prevent4__c,
                Authorized_Signature__c,
                Check_Date__c,
                Check_Time__c,
                Extend_Time_To__c,
                Close_Applicant_or_Bearer__c,
                Extend_Applicant_or_Bearer__c,
                Extend_Authorized_Sign__c,
                Close_Authorized_Sign_off__c,
                Sign_off_Flag__c,
                Applicant_or_Bearer_Telephone__c,
                TOP_Supervisor_Telephone__c,
                Authorized_Signatory__c,
                Extend_Time_Flag__c,
                Authorized_Indicator__c
            FROM THOR_Work_Clearance_Historical__c
            WHERE Work_Clearance__c IN :workClearanceNumbers
            ORDER BY CreatedDate DESC
        ];

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
    */

    @AuraEnabled
    public static Object getFunctionLocationDetail(Id funcLocationId) {
        return THOR_WorkClearanceController.getFunctionalLocationDetailById(funcLocationId);
    }

    @AuraEnabled
    public static Notification__c getNotificationDetailById(Id notificationId) {
        return THOR_WorkClearanceController.getNotificationDetailById(notificationId);
    }

    @AuraEnabled
    public static List<THOR_WorkClearanceController.WorkClearanceWrapper> getRelatedWorkClearances(String notificationIdentifier) {
        return THOR_WorkClearanceController.getRelatedWorkClearancesByNotification(notificationIdentifier);
    }

    @AuraEnabled
    public static List<sObject> getPISRequester(String searchText) {
        return THOR_WorkClearanceController.getPISRequester(searchText);
    }

    @AuraEnabled
    public static List<sObject> getApplicantOrBearer(String searchText) {
        return THOR_WorkClearanceController.getApplicantOrBearer(searchText);
    }

    @AuraEnabled
    public static List<sObject> getSafetyPermit(String searchText) {
        return THOR_WorkClearanceController.getSafetyPermit(searchText);
    }

    @AuraEnabled
    public static Boolean hasWriteAccess(String recordId) {
        return THOR_NotificationRelatedEQCCController.hasWriteAccess(recordId);
    }
    
    @AuraEnabled
    public static List<Master_Map__c> getAreas() {
        return THOR_WorkClearanceController.getAreas();
    }
}