@isTest
public with sharing class CTRLeadTriggerHandlerTest {
    
    private class MockHttpResponse implements HttpCalloutMock {
         public HTTPResponse respond(HTTPRequest req) {
             HttpResponse res = new HttpResponse();
             res.setStatusCode(200);
             res.setBody('{"status":"success"}');
             return res;
         }
    }
    
    @isTest
    public static void testCTRLeadTriggerHandler(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        Test.startTest();
        Id TOPLeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('TOP').getRecordTypeId();
        Lead testLead1 = new Lead(
            Company = 'Test Company',
            TaxNumber__c = '01234567890220',
            FormerNameofCompany__c = 'Former Name',
            Email = 'test@example.com',
            RegisteredasCustomer__c  = true,
            RegisteredasSupplier__c  = true,
            RecordTypeId = TOPLeadRecordTypeId,
            InterestedProductTypeAsCustomerTOP__c = 'Crude', 
            InterestedProductTypeAsSupplierTOP__c = 'B100/Ethanol',
            InterestedProductTypeAsCustomerTX__c = 'Lube', 
            InterestedProductTypeAsSupplierTX__c = 'LAB',
            FirstName = 'Test',
            LastName = 'Test'
        );

        insert testLead1;

        testLead1.Company = 'Test Edit';
        update testLead1;

        delete testLead1;
        Test.stopTest();
    }
}