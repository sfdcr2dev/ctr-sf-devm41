@isTest
public without sharing class CTRFlowEmailCTRTest {

    @testSetup
    static void setup() {
        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New'
        );
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c(
            EmailPageSubject__c = 'Test',
            EmailPageMessage__c = 'Test',
            EmailPageEmailTo__c = 'testuser@test.com',
            EmailPageEmailCC__c = 'testcc@test.com',
            CTRRequestFormHeader__c = reqHeader.Id
        );
        insert reqItem;
        
        CTREmailTemplateMaster__c emailTemp = new CTREmailTemplateMaster__c(
            Subject__c = 'Subject',
            HTMLBody__c = 'Body',
            Type__c = 'Request More Document TOP'
        );
        insert emailTemp;
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Test',
            Email = 'test@test.com'
        );
        insert testContact;
    }
    
    @isTest
    public static void testSendEmail() {
        Test.startTest();
        CTRRequestFormItem__c testRecord = [SELECT Id FROM CTRRequestFormItem__c LIMIT 1];
        EmailTemplate testTemplate = [Select Id, Name from EmailTemplate LIMIT 1];
        List<String> emailToList = new List<String>{'testuser@test.com'};
        List<String> emailCCList = new List<String>{'testuser@test.com'};
        
        CTRFlowEmailCTR.FlowInputs fi = new CTRFlowEmailCTR.FlowInputs();
        fi.mRecordId = testRecord.Id;
        fi.mTemplateId = testTemplate.Id;
        fi.mEmailToList = emailToList;
        fi.mEmailCCList = emailCCList;
        
            CTRFlowEmailCTR.sendEmail(new List<CTRFlowEmailCTR.FlowInputs>{fi});
        Test.stopTest();
    }
}