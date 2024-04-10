public class CTRRefreshHerokuTokenScheduled implements Schedulable 
{
    public void execute(SchedulableContext sc) 
    {
        CTRRefreshHerokuTokenBatch mRefreshToken = new CTRRefreshHerokuTokenBatch(); 
        Database.executeBatch(mRefreshToken);
    }
}