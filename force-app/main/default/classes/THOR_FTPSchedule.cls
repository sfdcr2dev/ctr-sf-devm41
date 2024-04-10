global class THOR_FTPSchedule implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        THOR_FTPCallIntegration b = new THOR_FTPCallIntegration();
        Id batchId = Database.executeBatch(b, 500);
    }
}