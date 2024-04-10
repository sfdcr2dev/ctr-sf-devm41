@isTest
public class C360_EventControllerTest {
    @TestSetup
    static void setup() {
        List<Account> accList = new List<Account>();
        Account a1 = new Account(AccountNumber__c='1', Name='A');
        accList.add(a1);
        Account a2 = new Account(AccountNumber__c='2', Name='B');
        accList.add(a2);
        insert accList;
        
        List<Contact> comList = new List<Contact>();
        Contact c1 = new Contact(lastname = 'AA',Phone = '123',Account = accList[0]);
        comList.add(c1);
        insert comList;
        
        List<Event> eList = new List<Event>();
        Event e1 = new Event(Subject = 'Test Event 1', DurationInMinutes = 30, ActivityDateTime = System.Today(), WhoId = comList[0].id);
        Event e2 = new Event(Subject = 'Test Event 2', DurationInMinutes = 30, Parent__c = e1.Id, ActivityDateTime = System.Today());
        eList.add(e1);
        insert eList;
    }
    
    @isTest
    static void test_getParentId() {
        Test.startTest();
        Id e = [select id from Event where Subject = 'Test Event 1' Limit 1].Id;
        C360_EventController.getParentId(e);
        C360_EventController.getParent(e);
        Test.stopTest();
    }
    
    @isTest
    static void test_EventUpdateWhatIdBatch() {
        Test.startTest();
        Id batchJob1 = Database.executeBatch(new C360_EventUpdateWhatIdBatch(), 10);
        Test.stopTest();
    }
    
    @isTest
    static void testC360_ScheduleEventUpdateWhatId()
    {
        Test.startTest();
        String jobId = System.schedule('C360_ScheduleEventUpdateWhatId',
                                       '0 30 1 * * ?', 
                                       new C360_ScheduleEventUpdateWhatId());
        Test.stopTest();
    }
    
}