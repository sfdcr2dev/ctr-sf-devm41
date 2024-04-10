@isTest
public without sharing class CTRFlowEmailGetAttachmentTest {

    @isTest
    public static void testGetAttachmentToSendEmail(){
        Id accRecordTypeId = [select id from RecordType where DeveloperName = 'SoldTo'].Id;
        Account a1 = new Account(AccountNumber__c='302', Name='A', RecordTypeId = accRecordTypeId);
        insert a1;
        
        Blob b = Blob.valueOf('Test Data');
    	
    	Attachment attachment = new Attachment();
    	attachment.ParentId = a1.Id;
    	attachment.Name = 'Test Attachment for Parent';
    	attachment.Body = b;
    	
    	insert(attachment);

        List<CTRFlowEmailGetAttachment.FlowInputGetAttachment> flowInputList = new List<CTRFlowEmailGetAttachment.FlowInputGetAttachment>();
        CTRFlowEmailGetAttachment.FlowInputGetAttachment flowInput = new CTRFlowEmailGetAttachment.FlowInputGetAttachment();
        flowInput.mCustomerId = a1.Id;
        flowInput.mFileName = new List<String>{'Test Attachment for Parent'};
        flowInputList.add(flowInput);

        Test.startTest();
        List<CTRFlowEmailGetAttachment.ResultsGetAttachment> results =  CTRFlowEmailGetAttachment.getAttachmentToSendEmail(flowInputList);
        Test.stopTest();
    }
}