global class OPP_AzureCreateMainGroup Implements Schedulable{
    
    global void execute(SchedulableContext sc)
    {
        OPP_AzureController.CreateMainGroup();
    }    
}