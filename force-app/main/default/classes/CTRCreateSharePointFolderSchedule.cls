public class CTRCreateSharePointFolderSchedule implements Schedulable 
{
    public void execute(SchedulableContext sc) 
    {
        CTRCreateSharePointFolderBatch createFolderBatch = new CTRCreateSharePointFolderBatch(); 
        Database.executeBatch(createFolderBatch,80);
    }
}