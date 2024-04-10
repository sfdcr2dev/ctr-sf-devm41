@isTest
public class ODM_WCVeriFileAttachmentControllerTest {
    @testSetup
    static void makeData() {
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        
		Id RecordTypeId = Schema.SObjectType.PTW_Header__c.getRecordTypeInfosByName().get('Verification').getRecordTypeId();

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
            FormName__c = 'Verification',
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
            FormName__c = 'Verification',
            Version__c = '1',
            Key__c = 'Key',
            Work_Clearance__c = wc.id,
            Status__c = 'Agree',
            RecordTypeId = RecordTypeId
            
        );
        insert ptwHeader;
        
        insert new PTW_Answer__c(
            PTW_Header__c = ptwHeader.id,
            Key__c = 'Key',
            Question_Text__c = 'Area'
        );
    }

    @isTest
    static void testGetPTWHeader(){
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
            FormName__c = 'Verification',
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
        
        Test.startTest();
        ODM_WCVeriFileAttachmentController.getPTWHeader(wc.Id);
        Test.stopTest();
    }

    @isTest
    static void testDeleteFiles() {

        List<ContentDocument> documents = [SELECT Id, Title FROM ContentDocument];
        Test.startTest();
        ODM_WCVeriFileAttachmentController.deleteFile(documents[0].Id);
        Test.stopTest();
    }

    @isTest
    static void testReleatedFiles() {
       
        List<ContentDocument> documents = [SELECT Id, Title FROM ContentDocument];
        Test.startTest();
        ODM_WCVeriFileAttachmentController.getFilesRelatedToNotification(documents[0].Id);
        Test.stopTest();
    }

    @isTest
    static void testGetRelatedObjects(){
	    PTW_Header__c n = [
				SELECT
					Id
				FROM PTW_Header__c
				WHERE RecordType.Name = 'Verification'
				WITH SECURITY_ENFORCED
				LIMIT 1
		];

        
        Test.startTest();
        ODM_WCVeriFileAttachmentController.getRelatedObjects(n.Id);
        Test.stopTest();
    }

    @isTest
    static void testGetSequentialNumber(){
        Test.startTest();

        Integer sequentialNumber = 1;
        ODM_WCVeriFileAttachmentController.getSequentialNumber(sequentialNumber);
        // System.assert(ODM_WCVeriFileAttachmentController.getSequentialNumber(1) != '', 'Not Expected Data');

        Test.stopTest();
    }
    
    @isTest
    static void testWrapDocuments(){
        
        PTW_Header__c ptwHeader = [
				SELECT
					Id
				FROM PTW_Header__c
				WHERE RecordType.Name = 'Verification'
				LIMIT 1
		];
                
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=ptwHeader.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        List<ContentDocumentLink> contentDocLinkcList = new List<ContentDocumentLink>();
        contentDocLinkcList.add(contentlink);
        
        Test.startTest();
        ODM_WCVeriFileAttachmentController.wrapDocuments(contentDocLinkcList);
        Test.stopTest();
    }
    
    @isTest
    static void testODM_WCVerificationDTO(){
        ODM_WCVerificationDTO wcVerificationWithRelatedData;
		Test.startTest();
			wcVerificationWithRelatedData = new ODM_WCVerificationDTO();
			wcVerificationWithRelatedData.orderId = null;
			wcVerificationWithRelatedData.relatedItems = null;
			wcVerificationWithRelatedData.relatedSubOrders = null;
			wcVerificationWithRelatedData.files = null;
			wcVerificationWithRelatedData.notification_files = null;
			wcVerificationWithRelatedData.notificationObj = null;
			wcVerificationWithRelatedData.hasEditAccess = false;
		Test.stopTest();
    }
    
    
}