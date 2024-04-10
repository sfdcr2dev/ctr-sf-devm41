@isTest
public class C360_ScheduleFinancialInfoTest {
    
    @IsTest
    public static void testschedule() {
        Test.StartTest();
        
        C360_ScheduleFinancialInfo2000 sh1 = new C360_ScheduleFinancialInfo2000();
        String sch01 = '0 0 23 * * ?'; system.schedule('Test Territory Check 1', sch01, sh1); 
        
        C360_ScheduleFinancialInfoNot2000 sh2 = new C360_ScheduleFinancialInfoNot2000();
        String sch02 = '0 0 23 * * ?'; system.schedule('Test Territory Check 2', sch02, sh2); 
        
        Test.stopTest(); }
    
}