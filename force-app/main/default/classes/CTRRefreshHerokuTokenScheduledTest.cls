@isTest
public class CTRRefreshHerokuTokenScheduledTest {
    
    @isTest
    static void testScheduledJob() {
        Test.startTest();
        String jobId = System.schedule('Test Job', '0 0 0 * * ?', new CTRRefreshHerokuTokenScheduled());
        Test.stopTest();
        
        System.assertNotEquals(null, jobId, 'Job should have been scheduled');
    }
}