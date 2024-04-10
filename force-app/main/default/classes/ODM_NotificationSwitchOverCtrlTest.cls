@isTest
public class ODM_NotificationSwitchOverCtrlTest {

    @TestSetup
    static void makeData(){
        insert new Notification__c(
			Name = '00000001',
            Notification_Number__c = '00000001',
			Description__c = 'SWITCH OVER - Test Notification',
			Requested_Date__c = Date.today(),
			Required_Start__c = Date.today()
		);
    }
    
    @isTest
    public static void testGetNotificationList() {
		Test.startTest();

		Object objNotis = ODM_NotificationSwtchOverCtrl.getNotificationList(
			new Map<String, String>{
				'Type' => 'OP',
				'Notification_Number__c' => '00000001',
				'Notification_Status__c' => 'New;In Progress',
				'Requested_Date__c' => '2022-06-19',
				'Create_Date_From__c' => '2022-06-19',
				'Create_Date_To__c' => '2022-06-19',
				'Requester__c' => '12341234',
				'Breakdown__c' => 'false',
				'Test__c' => 'Test'
			}, 0, 20, true
		);

        Map<String, Object> wrapper = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objNotis));

        System.assertEquals(0, Integer.valueOf(wrapper.get('count')));
        
		Test.stopTest();
    }
}