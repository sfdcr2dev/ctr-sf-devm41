@isTest
public class CTRAccountHandlerTest {
    @TestSetup
    public static void setup(){
        Id accRecordTypeId = [select id from RecordType where DeveloperName = 'SoldTo'].Id;

        Account acc = new Account(AccountNumber__c='1', Name='A2', RecordTypeId = accRecordTypeId);
        //insert acc;
    }

    private class MyMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            res.setBody('{"example": "response"}');
            return res;
        }
    }
    @isTest
    public static void testCreateFolderSharePointAfterCreate(){

        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMock());
        Id accRecordTypeId = [select id from RecordType where DeveloperName = 'SoldTo'].Id;

        Account acc = new Account(AccountNumber__c='1', Name='A2', RecordTypeId = accRecordTypeId);
        insert acc;
        Test.stopTest();
    }
/*
    @isTest
    public static void testCreateFolderSharePointAfterCreate(){

        List<Account> accList = [SELECT ID,SFCode__c FROM Account];
        Test.setMock(HttpCalloutMock.class, new MyMock());
        
        Test.startTest();
        CTRAccountHandler.CreateFolderSharePointAfterCreate(accList);
        Test.stopTest();
    }

    @isTest
    public static void testUpdateAndDelete(){

        List<Account> accList = [SELECT ID,SFCode__c FROM Account];
        Test.setMock(HttpCalloutMock.class, new MyMock());
        
        Test.startTest();
        Account acc = accList[0];
        acc.name = 'A3';
        update acc;

        CTRAccountHandler.CreateFolderSharePointAfterCreate(accList);

        delete acc;
        Test.stopTest();
    }*/
}