@isTest
public class C360_AccountControllerTest {
    @TestSetup
    static void setup() {
        Id accRecordTypeId = [select id from RecordType where DeveloperName = 'SoldTo'].Id;
        
        List<Account> accList = new List<Account>();
        Account a1 = new Account(AccountNumber__c='302', Name='A', RecordTypeId = accRecordTypeId);
        accList.add(a1);
        Account a2 = new Account(AccountNumber__c='1', Name='A2' , RecordTypeId = accRecordTypeId);
        accList.add(a2);
        
        insert accList;
    }
    
    @isTest
    static void test_getAccountLocation() 
    {
        Test.startTest();
        
        Id a = [select id from Account where AccountNumber__c = '302'].Id;
        C360_AccountController.getAccountLocation(a);
        Test.stopTest();
        
    }
    
}