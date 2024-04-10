/* 
    WP00ScheduledBatchable WP00SC = new WP00ScheduledBatchable();
    string cronExp1 = '0 0 8 1 * ? *';
    system.schedule('Work Process 00', cronExp1, WP00SC);
*/

global class Step00NotificationController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public string status = 'Ongoing';
    
    public String query = 'select id, Work_Process_Status__c, Project__c, Project__r.Name, Project__r.Project_Manager__c, Project__r.Status__c from Project_Risk_Assessment__c where (Project__r.Status__c =: status)';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Project_Risk_Assessment__c> WP00s) {
        
        Integer WP00Size = WP00s.size();
        
        if (WP00Size > 0) {
            
            for(Project_Risk_Assessment__c WP00 : WP00s) {
                
                if(WP00.Project__r.Project_Manager__c != null) {
                    Id typeId = [SELECT Id, DeveloperName FROM CUstomNotificationType WHERE DeveloperName = 'Send_Noti_for_Risk_Assessment_Information'].Id;
                
                        Http h = new Http();
                        HttpRequest req = new HttpRequest();
                        req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                            + '/services/data/v49.0/actions/standard/customNotificationAction');
                        req.setMethod('POST');
                        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                        req.setHeader('Content-Type', 'application/json');
                        CustomNotificationActionInput input = new CustomNotificationActionInput();
                        input.customNotifTypeId = typeId;
                        input.recipientIds = new List<String>{WP00.Project__r.Project_Manager__c};
                        input.title = WP00.Project__r.Name;
                        input.body = 'Please update Risk Assessment Information.';
                        input.targetId = WP00.ID;
                        CustomNotificationAction action = new CustomNotificationAction();
                        action.inputs = new List<CustomNotificationActionInput>{input};
                        req.setBody(JSON.serialize(action));
                    
                        if(Test.isRunningTest()){
                            System.debug('No callout was made.');
                        }
                        else{
                            HttpResponse res = h.send(req);
                            System.debug(res.getBody());
                        }
                }
                
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){    
    }
    
    public class CustomNotificationAction
    {
        public List<CustomNotificationActionInput> inputs { get; set; }
    }

    public class CustomNotificationActionInput
    {
        public String customNotifTypeId { get; set; }
        public List<String> recipientIds { get; set; }
        public String title { get; set; }
        public String body { get; set; }
        public String targetId { get; set; }
    }
}