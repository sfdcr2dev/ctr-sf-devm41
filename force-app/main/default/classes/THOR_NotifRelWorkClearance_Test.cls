@isTest
public class THOR_NotifRelWorkClearance_Test {
    @TestSetup
    static void makeData(){
        THOR_MakeMockData.makeMockData();
    }

    /**
     * @given Notifications Id
     * @when Notification has related Work Clearance
     * @then return related Work Clearances
     */
    @isTest
    public static void testGetRelatedObjects(){
        Work_Clearance__c mockWorkClearance = getMockWorkClearance();
        Notification__c mockNotification = getMockNotification();
        Test.startTest();
            //Map<Id, THOR_RelatedWorkClearanceDTO> actual = THOR_NotificationRelatedWorkClearanceCtr.getRelatedObjects(mockNotification.Id);
            Work_Clearance__c result = THOR_NotificationRelatedWorkClearanceCtr.getWorkClearance(
            	mockNotification.Id
        	);
        Test.stopTest();

        /*System.assertEquals(
            mockWorkClearance.Id,
            actual.get(mockWorkClearance.Id).workClearanceId,
            'Work Clearance Related to Notification should match the mock Work Clearance'
        );*/
    }

    /**
     * @given Notifications Id
     * @when Notification has related Work Clearance
     * @then return related Work Clearances
     */
    @isTest
    public static void testGetRelatedObjectsException(){
        Work_Clearance__c mockWorkClearance = getMockWorkClearance();
        try{
            Work_Clearance__c result = THOR_NotificationRelatedWorkClearanceCtr.getWorkClearance(
            	mockWorkClearance.Id
        	);
        }catch(Exception e){
            System.assertEquals(
                'System.AuraHandledException',
                e.getTypeName(),
                'Aura Exception should be thrown when user access is restricted or bad query'
            );
        }
    }

    private static Work_Clearance__c getMockWorkClearance(){
        return [SELECT Id FROM Work_Clearance__c WHERE Name='Test Work Clearance' LIMIT 1];
    }

    private static Notification__c getMockNotification(){
        return [SELECT Id FROM Notification__c WHERE Name='Test Notification'];
    }
}