@isTest
public class C360_ScheduleNotificationTest {
    @testSetup
    public static void setupdate()
    {
        contact con = new contact();
        con.Email = 'a@a.com';
        con.LastName = 'test';
        	insert con;
    }
    
    @IsTest
    public static void testschedule() {
        Test.StartTest();
        
        C360_ScheduleNotificationBG sh1 = new C360_ScheduleNotificationBG();
        String sch01 = '0 0 23 * * ?'; system.schedule('Test Territory Check 1', sch01, sh1); 
        
        C360_ScheduleNotificationContract sh2 = new C360_ScheduleNotificationContract();
        String sch02 = '0 0 23 * * ?'; system.schedule('Test Territory Check 2', sch02, sh2); 
        
        C360_ScheduleNotificationExciseQuota sh3 = new C360_ScheduleNotificationExciseQuota();
        String sch03 = '0 0 23 * * ?'; system.schedule('Test Territory Check 3', sch03, sh3); 
        
        C360_ScheduleNotificationOutstanding sh4 = new C360_ScheduleNotificationOutstanding();
        String sch04 = '0 0 23 * * ?'; system.schedule('Test Territory Check 4', sch04, sh4); 
        
        Test.stopTest(); }
    
}