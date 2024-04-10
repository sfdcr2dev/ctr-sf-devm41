@IsTest
public with sharing class ODM_WCInspectFileAttachmentTest {

	@TestSetup
	static void makeData(){
		ContentVersion contentVersionInsert = new ContentVersion(
			Title = 'Test',
			PathOnClient = 'Test.jpg',
			VersionData = Blob.valueOf('Test Content Data'),
			IsMajorVersion = true
		);
		insert contentVersionInsert;

		Id recordTypeId = Schema.SObjectType.PTW_Header__c
			.getRecordTypeInfosByName()
			.get('Inspection')
			.getRecordTypeId();

		Work_Clearance__c wc = new Work_Clearance__c(
			Name = '9012341234',
			Integration_Status__c = 'Success',
			System_Status__c = 'PREP',
			User_Status__c = 'WCCL',
			Area__c = 'P1',
			Work_Detail__c = 'Test',
			Safety_Permit1__c = 'Test',
			Safety_Permit2__c = 'Test',
			Safety_Permit3__c = 'Test',
			High_risk_work__c = '1'
		);
		insert wc;

		PTW_Question_Master__c ptwMaster = new PTW_Question_Master__c(
			FormName__c = 'Inspection',
			Version__c = '1',
			Question__c = '1',
			Section__c = '1',
			Order_Question__c = 1,
			Answer_type__c = 'Text',
			Value__c = 'Area ของ Work Clearance',
			Description__c = 'Test',
			IsActive_Report__c = true
		);
		insert ptwMaster;

		PTW_Header__c ptwHeader = new PTW_Header__c(
			FormName__c = 'Inspection',
			Version__c = '1',
			Key__c = 'Key',
			Work_Clearance__c = wc.id,
			Status__c = 'ดำเนินการได้',
			RecordTypeId = recordTypeId

		);
		insert ptwHeader;

		insert new PTW_Answer__c(
			PTW_Header__c = ptwHeader.id,
			Key__c = 'Key',
			Question_Text__c = 'Area'
		);

		ContentVersion content = [
			SELECT Id, ContentDocumentId
			FROM ContentVersion
			WHERE Id = :contentVersionInsert.Id
		];

		ContentDocumentLink docLink = new ContentDocumentLink();
		docLink.LinkedEntityId = ptwHeader.Id;
		docLink.ContentDocumentId = content.ContentDocumentId;
		insert docLink;
	}

	@isTest
	static void testGetRelatedObjects(){
		PTW_Header__c ptwHeader = [
			SELECT Id
			FROM PTW_Header__c
			WHERE RecordType.Name = 'Inspection'
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		Test.startTest();
		ODM_WCVerificationDTO dto = ODM_WCInspectFileAttachmentCtrl.getRelatedObjects(ptwHeader.Id);
		Test.stopTest();
	}

	@isTest
	static void testDeleteFiles() {
		List<ContentDocument> documents = [SELECT Id FROM ContentDocument];

		Test.startTest();
		ODM_WCInspectFileAttachmentCtrl.deleteFile(documents[0].Id);
		Test.stopTest();
	}
}