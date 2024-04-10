global class OPP_AzureMemberUpdateMainGroup Implements Schedulable{
    
    global void execute(SchedulableContext sc)
    {
        OPP_AzureController.UpdateMemberMainGroup();
    }    
}