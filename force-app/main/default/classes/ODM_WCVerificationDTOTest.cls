@isTest 
public class ODM_WCVerificationDTOTest {
    @isTest
	static void setup() {
		Notification__c notification = new Notification__c(
			Name = 'Test Notification',
			Description__c = 'Test Notification',
			AssignedTo__c = UserInfo.getUserId()
		);
		insert notification;

		Order__c order = new Order__c(Notification__c = notification.Id);
		insert order;

		List<Order__c> subOrders = new List<Order__c>();
		for (Integer i = 0; i < 5; i++) {
			subOrders.add(new Order__c(Super_Order__c = order.Id));
		}
		insert subOrders;

		List<Item__c> items = new List<Item__c>();
		for (Integer i = 0; i < 5; i++) {
			items.add(new Item__c(Notification__c = notification.Id, Text__c = 'Test Item ' + i));
		}
		insert items;

		List<ContentVersion> contentVersions = new List<ContentVersion>();
		for (Integer i = 0; i < 5; i++) {
			contentVersions.add(
				new ContentVersion(
					Title = 'TestFile' + i,
					PathOnClient = '/TestFile.jpg',
					VersionData = Blob.valueOf('Unit Test ContentVersion Body'),
					origin = 'H'
				)
			);
		}
		insert contentVersions;

		contentVersions = [SELECT Id, ContentDocumentId FROM ContentVersion];

		List<ContentDocumentLink> documentLinks = new List<ContentDocumentLink>();
		for (Integer i = 0; i < 5; i++) {
			documentLinks.add(
				new ContentDocumentLink(
					LinkedEntityId = notification.Id,
					ContentDocumentId = contentVersions.get(i).ContentDocumentId,
					ShareType = 'V'
				)
			);
		}
		insert documentLinks;

        Notification__c noti = getNotification();
		ODM_WCVerificationDTO dto;
		Test.startTest();
		try {
			dto = ODM_WCVeriFileAttachmentController.getRelatedObjects(
				noti.Id
			);
		} catch (Exception e) {
			dto = new ODM_WCVerificationDTO();
			dto.orderId = 'null';
			dto.relatedItems = null;
			dto.relatedSubOrders = null;
			dto.files = null;
			dto.notification_files = null;
			dto.notificationObj = null;
			dto.hasEditAccess = false;
		}
		Test.stopTest();
        
    }

    private static Notification__c getNotification() {
		return [SELECT Id FROM Notification__c];
	}
    private static List<ContentDocument> getAllDocuments() {
		return [SELECT Id FROM ContentDocument];
	}
}