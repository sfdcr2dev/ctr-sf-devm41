@isTest
public class ODM_FileUploadActionControllerTest {
	@testSetup
    static void makeData() {
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
    }
    
    @isTest
    static void testRenameContentDocument() {
        ContentDocument existingDocument = getDocument();

        Test.startTest();
        ODM_FileUploadActionController.updateFiles(existingDocument.Id, 'New File name');
        Test.stopTest();

        ContentDocument updatedDocument = getDocument();

        System.assertEquals('New File name', updatedDocument.Title, 'File Name should have been updated');
    }
    
    @isTest
    static void testContentDocumentWithNoTitle() {
        ContentDocument existingDocument = getDocument();

        Test.startTest();
        try {
            THOR_FileUploadActionController.updateFiles(existingDocument.Id, '');
            System.assert(false, 'Exception should have been thrown');
        } catch (Exception ex) {
            System.assertEquals(
                ex.getTypeName(),
                'System.AuraHandledException',
                'An exception should have prevented the file to be renamed to an empty Title'
            );
        }
        Test.stopTest();

        ContentDocument updatedDocument = getDocument();

        System.assertEquals(existingDocument.Title, updatedDocument.Title, 'File Name should not have been updated');
    }
    
    @isTest
    static void testHasWriteAccess() {
        Boolean hasWritePermission = false;
        Test.startTest();
        hasWritePermission = ODM_FileUploadActionController.hasWriteAccess(getDocument().Id);
        Test.stopTest();
        
        System.assert(hasWritePermission, 'User should be able to upload Files');
    }
    
    @isTest
    static void testSaveFile() {
       
        EQCC_Step__c eqccStep = new EQCC_Step__c(
        	Name = 'Test',
            Form_Code__c = 'Test',
            Step_Number__c = 1
        );
        insert eqccStep;
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true,
            FirstPublishLocationId = eqccStep.Id
        );
        insert contentVersionInsert;
        Test.startTest();
        ODM_FileUploadActionController.saveFile(eqccStep.Id, 'Before Name File', 'Base 64', 'Before');
        Test.stopTest();
    }
    
    @isTest
    static void testReleatedFiles() {
       
        EQCC_Step__c eqccStep = new EQCC_Step__c(
        	Name = 'Test',
            Form_Code__c = 'Test',
            Step_Number__c = 1
        );
        insert eqccStep;
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true,
            FirstPublishLocationId = eqccStep.Id
        );
        insert contentVersionInsert;
        Test.startTest();
        ODM_FileUploadActionController.releatedFiles(eqccStep.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteContentDocument() {
        ContentDocument existingDocument = getDocument();
        Test.startTest();
        ODM_FileUploadActionController.deleteContentDocument(getDocument().Id);
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteFiles() {
       
        EQCC_Step__c eqccStep = new EQCC_Step__c(
        	Name = 'Test',
            Form_Code__c = 'Test',
            Step_Number__c = 1
        );
        insert eqccStep;
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true,
            FirstPublishLocationId = eqccStep.Id
        );
        insert contentVersionInsert;
        Test.startTest();
        ODM_FileUploadActionController.DeleteFiles(eqccStep.Id);
        Test.stopTest();
    }
    
    private static ContentDocument getDocument() {
        return [SELECT Id, Title FROM ContentDocument LIMIT 1];
    }
}