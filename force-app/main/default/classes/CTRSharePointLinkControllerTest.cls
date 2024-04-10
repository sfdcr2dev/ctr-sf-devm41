@isTest
private class CTRSharePointLinkControllerTest {
    
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }

    @isTest
    static void testGetFolderPath() {
        
        Test.startTest();
        
        List<CTRSharePointFolder__mdt> resultFolderList = CTRSharePointLinkController.getFolderPath('CTR', 'Account','');
        
        Test.stopTest();
    }

    @isTest
    static void testGetSharepointPath(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c(
            Status__c = 'New',
            CompanyNameENF__c = 'Test',
            FirstName__c = 'firstName',
            LastName__c = 'lastName'
        );
        insert reqHeader;

        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType = 'CTRRequestFormItem__c' AND DeveloperName = 'CustomerExtend' limit 1];
        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        reqItem.Name = 'Test Item';
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.RecordTypeId = rt.Id;
        insert reqItem;

        Lead lrec = new Lead();
        lrec.firstname='Test';
        lrec.LastName = 'lastnameTest';
        lrec.Company = 'Testcompany';
        lrec.EmailPageAttachment__c = 'T006-P3.png';
        lrec.EmailPageEmailTo__c = 'test@test.com,test2@test.com';
        lrec.EmailPageEmailCC__c = 'test3@test.com';
        lrec.EmailPageMessage__c = '<p>Request for Approval of New Lead TX Registration: Test Test</p>';
        lrec.EmailPageSubject__c = 'Test Subject';
        lrec.RegisteredasCustomer__c = true;
        lrec.RegisteredasSupplier__c = true;
        insert lrec;

        C360Integration__c c360Integration = new C360Integration__c(
            SharePoint_TenantName__c = 'testTenant',
            SharePoint_SiteName__c = 'testSite',
            SharePoint_Document_Folder__c = 'testFolder',
            SharePointMainFolderDuringCreate__c = 'AccountDev'
        );
        insert c360Integration;

        Test.startTest();
        
        List<String> results1 = CTRSharePointLinkController.getSharepointPath(testAccount.Id,'Others');
        List<String> results2 = CTRSharePointLinkController.getSharepointPath(lrec.Id,'Others');
        List<String> results3 = CTRSharePointLinkController.getSharepointPath(reqItem.Id,'Others');
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetLink() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        C360Integration__c c360Integration = new C360Integration__c(
            SharePoint_TenantName__c = 'testTenant',
            SharePoint_SiteName__c = 'testSite',
            SharePoint_Document_Folder__c = 'testFolder',
            SharePointMainFolderDuringCreate__c = 'AccountDev'
        );
        insert c360Integration;

        Test.startTest();
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        List<CTRSharePointLinkController.wrapperPath> resultLinks = CTRSharePointLinkController.getLink('CTR', testAccount.Id);
        

        CTRRequestFormHeader__c reqHeader = new CTRRequestFormHeader__c();
        reqHeader.Name = 'Test Header';
        insert reqHeader;

        CTRRequestFormItem__c reqItem = new CTRRequestFormItem__c();
        reqItem.Name = 'Test Item';
        reqItem.CTRRequestFormHeader__c = reqHeader.Id;
        reqItem.RecordTypeId = Schema.SObjectType.CTRRequestFormItem__c.getRecordTypeInfosByDeveloperName().get('CustomerInitial').getRecordTypeId();
        reqItem.SalesOrganization__c = '1100';
        insert reqItem;

        resultLinks = CTRSharePointLinkController.getLink('CTR', reqItem.Id);

        Lead lrec = new Lead();
        lrec.firstname='Test';
        lrec.LastName = 'lastnameTest';
        lrec.Company = 'Testcompany';
        lrec.EmailPageAttachment__c = 'T006-P3.png';
        lrec.EmailPageEmailTo__c = 'test@test.com,test2@test.com';
        lrec.EmailPageEmailCC__c = 'test3@test.com';
        lrec.EmailPageMessage__c = '<p>Request for Approval of New Lead TX Registration: Test Test</p>';
        lrec.EmailPageSubject__c = 'Test Subject';
        lrec.RegisteredasCustomer__c = true;
        lrec.RegisteredasSupplier__c = true;
        insert lrec;

        resultLinks = CTRSharePointLinkController.getLink('CTR', lrec.Id);
        Test.stopTest();
    }
}