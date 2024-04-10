public class OPP_AzureBatchSync implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful  {
    
    private String query = 'SELECT InformationBody, Id FROM CollaborationGroup' + (Test.isRunningTest() ?  ' LIMIT 1' : ''); //where InformationBody != null
    public Database.QueryLocator start(Database.BatchableContext BC) {
        // List<String> groupId = new List<Id>();
        // List<CollaborationGroup> allGroup = [SELECT InformationBody, Id FROM CollaborationGroup];
        // System.debug(allGroup);
        // for(CollaborationGroup record : allGroup){
        //     if(record.InformationBody != null) groupId.add(record.Id);
        // }
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug(scope);
        System.debug('Site>>' + scope.size());
        List<String> groupId = new List<Id>();
        // List<CollaborationGroup> allGroup = [SELECT InformationBody, Id FROM CollaborationGroup];
        for(CollaborationGroup record : (List<CollaborationGroup>)scope){
            if(record.InformationBody != null) groupId.add(record.Id);
        }
        OPP_AzureController.CreateMemberGroup(groupId);
    }
    
    public void finish(Database.BatchableContext BC){}
}