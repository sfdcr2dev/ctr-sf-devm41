/**
 * @author Oktana
 * @description test class for THOR_FileUploadActionController
 */
@isTest
public class THOR_FileUploadActionController_Test {
    @testSetup
    static void makeData() {
        // https://vijayasankarn.wordpress.com/2018/02/19/salesforce-apex-writing-unit-test-for-contentdocument/
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
    }

    /**
     * @given an existing Content Document and a service to rename Content Documents
     * @when service is invoked with a Title
     * @then the existing Content Document is renamed to the new Title
     */
    @isTest
    static void testRenameContentDocument() {
        ContentDocument existingDocument = getDocument();

        Test.startTest();
        THOR_FileUploadActionController.updateFiles(existingDocument.Id, 'New File name');
        Test.stopTest();

        ContentDocument updatedDocument = getDocument();

        System.assertEquals('New File name', updatedDocument.Title, 'File Name should have been updated');
    }

    /**
     * @given an existing Content Document and a service to rename Content Documents
     * @when service is invoked with an empty Title
     * @then the existing Content Document is not renamed and an exception is thrown
     */
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
    
    /**
     * @given a User with write permissions over File
     * @then User can upload Files
     */
    @isTest
    static void testHasWriteAccess() {
        Boolean hasWritePermission = false;
        Test.startTest();
        hasWritePermission = THOR_FileUploadActionController.hasWriteAccess(getDocument().Id);
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
        THOR_FileUploadActionController.saveFile(eqccStep.Id, 'Before Name File', 'Base 64', 'Before');
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
        THOR_FileUploadActionController.releatedFiles(eqccStep.Id);
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteContentDocument() {
        ContentDocument existingDocument = getDocument();
        Test.startTest();
        THOR_FileUploadActionController.deleteContentDocument(getDocument().Id);
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
        THOR_FileUploadActionController.DeleteFiles(eqccStep.Id);
        Test.stopTest();
    }

    private static ContentDocument getDocument() {
        return [SELECT Id, Title FROM ContentDocument LIMIT 1];
    }
}