@isTest
public class C360_CustomerNoBranchTest {
	 @TestSetup
    static void setup() {
        Id accRecordTypeId = [select id from RecordType where DeveloperName = 'SoldTo'].Id;
        Id shipRecordTypeId = [select id from RecordType where DeveloperName = 'ShipTo'].Id;
        
        List<Account> accList = new List<Account>();
        Account a1 = new Account(AccountNumber__c='302', Name='A', RecordTypeId = accRecordTypeId);
        accList.add(a1);
        Account a2 = new Account(AccountNumber__c='1', Name='A2' , RecordTypeId = shipRecordTypeId );
        accList.add(a2);
        Account b2 = new Account(AccountNumber__c='2', Name='b2' , RecordTypeId = shipRecordTypeId );
        accList.add(b2);
        insert accList;
        
         List<C360_Relationship__c> RelaList = new List<C360_Relationship__c>();
         List<Account> accountList=[Select Id from Account  order by id asc];
            for(Account actItem :accountList){
                C360_Relationship__c r1 = new C360_Relationship__c();
                   r1.Account__c = actItem.id ;
                   r1.ReverseAccount__c = actItem.id ;
                  RelaList.add(r1);
            }
      
 		insert RelaList;
    }
    
    @isTest
    static void test_getAccountLocation() 
    {
        Test.startTest();
        
        Id a = [select id from Account where AccountNumber__c = '302'].Id;
        C360_CustomerNoBranch.AccountList();
        Test.stopTest();
        
    }
    
     @isTest
    static void testC360_ScheduleCustomerNoBranch() 
    {
        Test.startTest();
        String jobId = System.schedule('C360_ScheduleCustomerNoBranch',
                                       '0 30 4 * * ?', 
                                       new C360_ScheduleCustomerNoBranch());
        Test.stopTest();
    }
}