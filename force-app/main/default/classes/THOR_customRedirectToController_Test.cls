/**
 * @author Oktana
 * @description test class for THOR_customRedirectToController
 */
@isTest
public class THOR_customRedirectToController_Test {
    @testSetup
    static void makeData() {
        THOR_MakeMockData.makeMockData();
    }

    /**
     * @given Record Id, Object Name, Field we want
     * @when used as filed output
     * @then return the related fields
     */
    @isTest
    public static void testGetRelatedRecord() {
        Notification__c mockNotification = getMockNotification();
        Order__c mockOrder = getMockOrder();
        Work_Clearance__c mockWorkClearance = getMockWorkClearance();

        Test.startTest();
        List<sObject> actual = THOR_customRedirectToController.getRelatedRecord(
            mockNotification.Id,
            'Notification__c',
            'Order__r.Name'
        );
        List<sObject> actualWorkClearance = THOR_customRedirectToController.getRelatedRecord(
            mockOrder.Id,
            'Order__c',
            'Work_Clearance__r.Name'
        );
        Test.stopTest();

        System.assertEquals(
            mockOrder.Id,
            actual.get(0).get('Order__c'),
            'Should return the Order related to the Notification'
        );
        System.assertEquals(
            'Test Work Clearance',
            actualWorkClearance.get(0).get('Name'),
            'returned sObject should contain the Name and Id of the mock Work Clearance'
        );
    }

    /**
     * @given Sequiental Number and ContentDocumentLink
     * @when calling new DocumentWrapper
     * @then set class properties in construct
     */
    @isTest
    public static void testGetRelatedRecordException() {
        Notification__c mockNotification = getMockNotification();
        try {
            List<sObject> actual = THOR_customRedirectToController.getRelatedRecord(
                mockNotification.Id,
                'Bogus__c',
                'BogusRelated__r.Name'
            );
        } catch (Exception ex) {
            System.assertEquals(
                'System.AuraHandledException',
                ex.getTypeName(),
                'Aura Exception should be thrown with bad query'
            );
        }
    }

    /**
     * @given id of record that has the attachemnt
     * @when getting the attachemnt id for the record that has attached file
     * @then return the attachment id
     */
    @isTest
    public static void testGetAttachmentId() {
        Notification__c mockNotification = getMockNotification();
        ContentDocument mockAttachment = getMockAttachment();

        Test.startTest();
        List<ContentDocumentLink> actual = THOR_customRedirectToController.getAttachmentId(
            Id.valueOf(mockNotification.Id)
        );
        Test.stopTest();

        System.assertEquals(
            mockAttachment.Id,
            actual[0].ContentDocumentId,
            'Id of ContentDocument should match the ContentDocumentId of ConentDocumentLink'
        );
    }

    private static Notification__c getMockNotification() {
        return [SELECT Id FROM Notification__c WHERE Name = 'Test Notification' LIMIT 1];
    }

    private static Order__c getMockOrder() {
        return [SELECT Id FROM Order__c WHERE Name = 'Test Order' LIMIT 1];
    }

    private static ContentDocument getMockAttachment() {
        return [SELECT Id FROM ContentDocument WHERE Title = 'Penguins'];
    }

    private static Work_Clearance__c getMockWorkClearance() {
        return [SELECT Id, Name FROM Work_Clearance__c WHERE Name = 'Test Work Clearance' LIMIT 1];
    }
}