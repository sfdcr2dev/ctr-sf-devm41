@istest
public class THOR_FTPScheduleTest 
{
    
    static testmethod void testTHOR_FTPSchedule() 
    {
        Test.startTest();
        
        // Schedule the test job
        
        String jobId = System.schedule('THOR_FTPSchedule',
                                       '0 0 0 3 9 ? 2022', 
                                       new THOR_FTPSchedule());
        
        system.assert(jobId != '');
        
        Test.stopTest();
        
    }
}