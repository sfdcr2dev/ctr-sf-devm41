global class OPP_AzureCreateSubGroup Implements Schedulable{
    
    global void execute(SchedulableContext sc)
    {
        OPP_AzureController.CreateSubGroup();
    }    
}