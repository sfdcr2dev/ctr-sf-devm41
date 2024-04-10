@isTest
public class CTRLeadHandlerTest 
{
    
    // @isTest
    // public static void getCTRNewsConditionIfTest() {

    //     Test.startTest();
    //     Lead master = new Lead(
    //         Company='Account1',
    //         LastName = 'Account1',
    //         RegisteredasCustomer__c = true,
    //         RegisteredasSupplier__c = true);
    //     insert master;
        
    //     // Create duplicate accounts
    //     Lead[] duplicates = new Lead[]{
    //     // Duplicate account 
    //     new Lead(
    //         Company='Account1',
    //         LastName = 'Account1',
    //         RegisteredasCustomer__c = true,
    //         RegisteredasSupplier__c = true),
    //     // Second duplicate account
    //     new Lead(
    //         Company='Account1',
    //         LastName = 'Account1',
    //         RegisteredasCustomer__c = true,
    //         RegisteredasSupplier__c = true)
    //     };
    //     // insert duplicates;
        
    //     // Merge accounts into master
    //     Database.MergeResult[] results = Database.merge(master, duplicates, false);


    //     CTRLeadHandler.CreateDupLead(duplicates);
    //     Test.stopTest();
    // }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testCreateDupLead() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Test data setup
        Lead masterLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            RegisteredasCustomer__c = true,
            RegisteredasSupplier__c = true
        );
        insert masterLead;

        Lead childLead = new Lead(
            FirstName = 'Child',
            LastName = 'Lead',
            Company = 'Child Company',
            RegisteredasCustomer__c = true,
            RegisteredasSupplier__c = true
        );

        Test.startTest();
        CTRLeadHandler.CreateDupLead(new List<Lead>{ childLead });
        Test.stopTest();

    }

    @isTest
    static void testNewsAfterUpdate() {
        // Test data setup
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            CallOutNews__c = false,
            RegisteredasCustomer__c = true,
            RegisteredasSupplier__c = true
        );
        insert testLead;

        testLead.CallOutNews__c = true;
        update testLead;
    }

}