@isTest
public class ODM_HomeCtrlTest {

    @TestSetup
    static void makeData(){
        insert new Notification__c(
			Name = '00000001',
            Notification_Number__c = '00000001',
			Description__c = 'Test Notification',
			Requested_Date__c = Date.today(),
			Required_Start__c = Date.today()
		);
    }

    @isTest
    public static void testGetUser() {
        Test.startTest();

        String userId = UserInfo.getUserId();
        User myUser = (User) ODM_HomeCtrl.getUser();

        System.assertEquals(userId, myUser.Id);

        Test.stopTest();
    }

    @isTest
    public static void testGetNotificationList() {
		Test.startTest();

		Object objNotis = ODM_HomeCtrl.getNotificationList(
			new Map<String, String>{
				'Notification_Number__c' => '00000001'
			}, 0, 20, true
		);

        System.debug(JSON.serialize(objNotis));

        Map<String, Object> wrapper = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objNotis));

        System.assertEquals(1, Integer.valueOf(wrapper.get('count')));
        
		Test.stopTest();
    }
     @isTest
    public static void testGetWcList() {
		Test.startTest();

		Object objNotis = ODM_HomeCtrl.getWcList(
			new Map<String, String>{
				'Functional_Location__c' => '00000001'
			}, 0, 20, true
		);

        System.debug(JSON.serialize(objNotis));

        Map<String, Object> wrapper = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objNotis));

        System.assertEquals(0, Integer.valueOf(wrapper.get('count')));
        
		Test.stopTest();
    }

    @isTest
    public static void getWcVerificationList() {
		Test.startTest();

		Object objNotis = ODM_HomeCtrl.getWcVerificationList(
			new Map<String, String>{
				'Functional_Location__c' => '00000001'
			}, 0, 20, true
		);

        System.debug(JSON.serialize(objNotis));

        Map<String, Object> wrapper = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(objNotis));

        System.assertEquals(0, Integer.valueOf(wrapper.get('count')));
        
		Test.stopTest();
    }
}