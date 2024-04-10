@isTest
public class ODM_REST_IN_NoficationTestclass {
	@Testsetup
    public static void setupData()
    {
        Notification__c noti = new Notification__c();
        noti.Breakdown__c = true;
        noti.isSOAP__c = true;
        noti.isIRPA__c = true;
        noti.Type__c = 'OP';
        noti.Notification_Number__c = 'Test';
        noti.Description__c = 'Test';
        // noti.Functional_Location__r.Description__c = 'OP';
        noti.Main_Work_Center_Text__c = 'ENMA-I';
        noti.Required_Start__c = System.today();
        noti.Functional_Location_Text__c = '12-PDI-138';
        

        insert noti;
     }
        @isTest
        public static void testNotification()
        {
            Date todayDate = Date.today();
            string year = String.valueOf(todayDate.year());
            string month = String.valueOf(todayDate.month());
            string day = String.valueOf(todayDate.day());
            string stringDate = day + '/' + month + '/' + year ;
            system.debug(stringDate);
            
            String jsonSTR = '{ "SAPNoti":  { "WNStartDateTime": "26/05/2022", "WNEndDateTime": "' + stringDate + '" }}';
            Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        	String SAPnotificationJSON = JSON.serialize(response_value.get('SAPNoti')) ;
            ODM_REST_IN_Nofication.NotificationInputWrapper sapo= (ODM_REST_IN_Nofication.NotificationInputWrapper)JSON.deserialize(SAPnotificationJSON, ODM_REST_IN_Nofication.NotificationInputWrapper.class);
            
            Test.startTest();
        	ODM_REST_IN_Nofication.NotiPost(sapo);
        	Test.stopTest();
        }

        @isTest
        public static void testNotificationCatch()
        {
            String jsonSTR = '{ "SAPNoti":  { "WNStartDateTime": "32/05/2022", "WNEndDateTime": "30/05/2022" }}';
            Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        	String SAPnotificationJSON = JSON.serialize(response_value.get('SAPNoti')) ;
            ODM_REST_IN_Nofication.NotificationInputWrapper sapo= (ODM_REST_IN_Nofication.NotificationInputWrapper)JSON.deserialize(SAPnotificationJSON, ODM_REST_IN_Nofication.NotificationInputWrapper.class);
            
            Test.startTest();
        	ODM_REST_IN_Nofication.NotiPost(sapo);
        	Test.stopTest();
        }
        @isTest
        public static void testNotificationFail()
        {
            String jsonSTR = '{ "SAPNoti":  { "WNStartDateTime": "", "WNEndDateTime": "" }}';
            Map<String, Object> response_value = (Map<String, Object>)JSON.deserializeUntyped(jsonSTR);        
        	String SAPnotificationJSON = JSON.serialize(response_value.get('SAPNoti')) ;
            ODM_REST_IN_Nofication.NotificationInputWrapper sapo= (ODM_REST_IN_Nofication.NotificationInputWrapper)JSON.deserialize(SAPnotificationJSON, ODM_REST_IN_Nofication.NotificationInputWrapper.class);
            
            Test.startTest();
        	ODM_REST_IN_Nofication.NotiPost(sapo);
        	Test.stopTest();
        }
}