global class OPP_AzureCreateMember Implements Schedulable{
    global void execute(SchedulableContext sc)
    {
        OPP_AzureBatchSync BS = new OPP_AzureBatchSync();
        Database.executeBatch(BS,50); 
    }
}