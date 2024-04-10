@isTest
public with sharing class CTRRequestFormItemControllerTest {
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }

	@TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Name = 'R2 Solutions Co.,Ltd.';
        insert acc;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name ='R2 Solutions. Co.,Ltd.';
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        reqItem.Customer__c = acc.Id;
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.Email__c = 'testmockemail@gmail.com';
        reqItem.EmailPageAttachment__c = 'Screen Shot 2024-01-18 at 9.34.00 PM.png,Screen Shot 2024-01-18 at 9.34.00 PM.png';
        insert reqItem;
        
        CTRShippingCountry__c shipping = new CTRShippingCountry__c();
        shipping.CTRRequestFormItem__c = reqItem.id;
        //shipping.ShippingCountry__c = 'TH - Thailand'; 
        shipping.ShippingCountry__c = 'TH';
        insert shipping;
        
        shipping = new CTRShippingCountry__c();
        shipping.CTRRequestFormItem__c = reqItem.id;
        //shipping.ShippingCountry__c = 'US - United State';
        shipping.ShippingCountry__c = 'US ';
        insert shipping;


        ContentVersion testContent1 = new ContentVersion(
            Title = 'Screen Shot 2024-01-18 at 9.34.00 PM.png', 
            PathOnClient = 'Screen Shot 2024-01-18 at 9.34.00 PM.png', 
            VersionData = Blob.valueOf('Test content for file 1'),
            IsMajorVersion = true
        );
        insert testContent1;

        ContentDocument testDocument1 = [SELECT Id FROM ContentDocument WHERE Id IN (SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContent1.Id) LIMIT 1];
        
        ContentDocumentLink link1 = new ContentDocumentLink(
            ContentDocumentId = testDocument1.Id, 
            LinkedEntityId = reqItem.Id, 
            ShareType = 'I', 
            Visibility = 'AllUsers'
        );
        insert link1;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        /*CTRBuProfile__mdt mdt = new CTRBuProfile__mdt();
        mdt.MasterLabel = 'System Administrator';
        mdt.BusinessUnit__c = 'TOP';
        mdt.ReassignTask_Section_Name__c ='FALB Reassign Task';
        mdt.VPSectionName__c ='CMVP/SA09';
        mdt.Edit_Button_Name__c ='Evaluate Credit';
        mdt.Section_Credit_Condition__c ='Excel Summary';
        insert mdt;*/
        
    }
    
    @IsTest 
    public static void getRequestItemRecordTypeTest(){
        Test.startTest();
        	CTRRequestFormItemController.getRequestItemRecordType();
        Test.stopTest();
    }
    
    @IsTest 
    public static void getRequestFormItemTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRRequestFormItemController.getRequestFormItem(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void getBUInfoTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRRequestFormItemController.getBUInfo(record.Id);
        Test.stopTest();
    }

	@IsTest 
    public static void getUserInfomationTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRRequestFormItemController.getUserInfomation(record.Id);
        Test.stopTest();
    }    
    
    @IsTest 
    public static void getShippingCountryTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRRequestFormItemController.getShippingCountry(record.Id);
        Test.stopTest();
    }
    
    @IsTest 
    public static void deleteAttachmentsTest(){
        CTRRequestFormItem__c record =[SELECT Id FROM CTRRequestFormItem__c WHERE Email__c = 'testmockemail@gmail.com'];
        Test.startTest();
        	CTRRequestFormItemController.deleteAttachments(record.Id,'EmailPageAttachement__c');
            CTRRequestFormItemController.deleteAttachments(record.Id,'CustomerAttachment__c');
            CTRRequestFormItemController.deleteAttachments(record.Id,'CommitteeAttachment__c');
            CTRRequestFormItemController.deleteAttachments(record.Id,'SummarizeReportAttachment__c');
        Test.stopTest();
    }
    
    
    
}