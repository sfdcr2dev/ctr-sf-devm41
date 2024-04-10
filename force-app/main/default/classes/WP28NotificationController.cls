/* 
    WP28ScheduledBatchable WP28SC = new WP28ScheduledBatchable();
    string cronExp1 = '0 0 8 1 * ? *'; 
    system.schedule('Work Process 28', cronExp1, WP28SC);

	For Test '0 0 8 * * ? *'
*/

global class WP28NotificationController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public string status = 'Cancel';
    
    public String query = 'select id, Status__c, Name, Project_Manager__c from Project__c where (Status__c !=: status)';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Project__c > Projects) {
        
        Integer todayMonth = date.today().Month();
        
        List<Id> ProjectIds = new List<Id>();
        List<Id> WP27Ids = new List<Id>();
        
        if(Projects.size() > 0) {
            for(Project__c Proj : Projects) {
                ProjectIds.add(Proj.Id);
            }
        }
        
        List<Punch_List_Management_System__c> WP27s = [select id, Project__c, Project__r.Name, Project__r.Project_Manager__c from Punch_List_Management_System__c where Project__c IN: ProjectIds];
        
        if(WP27s.size() > 0) {
            for(Punch_List_Management_System__c WP27 : WP27s) {
                WP27Ids.add(WP27.Id);
            }
        }
        
        Integer WP27Size = WP27s.size();
        
        if (WP27Size > 0) {
            
            for(Punch_List_Management_System__c WP27 : WP27s) {
                
                integer MCCount = 0;
                integer RFSUCount = 0;
                
            	List<Handover__c> Handovers = [select id, Name, Punch_List_Management_System__c, MC_P__c, RSFU_P__c, MC__c, RSFU__c from Handover__c where (Punch_List_Management_System__c =: WP27.Id)];
                
                if(Handovers.size() > 0) {
                    
                    integer TotalRFSU = 0;
                    boolean IsAllRSFU = false;
                    
                    //Check for RSFU
                    for(Handover__c Handover : Handovers) {
                    
                        if(Handover.RSFU__c != null) {
                            TotalRFSU = TotalRFSU + 1;
                        }
                        
                    }
                    
                    if(Handovers.size() == TotalRFSU) {
                        
                        IsAllRSFU = true;
                    }
                    
                    if(!IsAllRSFU) {
                        
                        for(Handover__c Handover : Handovers) {
                            if(Handover.MC_P__c != null && Handover.MC__c == null && Handover.RSFU__c == null) {
                                if(Handover.MC_P__c != null && Handover.MC_P__c.Month() == todayMonth) {
                                    MCCount = MCCount + 1;
                                }
                                if(Handover.RSFU_P__c != null && Handover.RSFU_P__c.Month() == todayMonth) {
                                    RFSUCount = RFSUCount + 1;
                                }
                            }
                            else if(Handover.RSFU_P__c != null && Handover.RSFU__c == null && Handover.RSFU_P__c.Month() == todayMonth) {
                                RFSUCount = RFSUCount + 1;
                            }
                        }
                        
                        if(WP27.Project__r.Project_Manager__c != null) {
                            
                            Id typeId = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName = 'Send_Noti_For_MC_RFSU'].Id;
                    
                            Http h = new Http();
                            HttpRequest req = new HttpRequest();
                            req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
                                + '/services/data/v49.0/actions/standard/customNotificationAction');
                            req.setMethod('POST');
                            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                            req.setHeader('Content-Type', 'application/json');
                            CustomNotificationActionInput input = new CustomNotificationActionInput();
                            input.customNotifTypeId = typeId;
                            input.recipientIds = new List<String>{WP27.Project__r.Project_Manager__c};
                            input.title = WP27.Project__r.Name + ' : MC and RFSU system';
                            input.body = MCCount + ' systems to MC and ' +  RFSUCount + ' systems to RFSU in this month';
                            input.targetId = WP27.ID;
                            CustomNotificationAction action = new CustomNotificationAction();
                            action.inputs = new List<CustomNotificationActionInput>{input};
                            req.setBody(JSON.serialize(action));
                            
                            if(Test.isRunningTest()){
                                System.debug('No callout was made.');
                            }
                            else{
                            	HttpResponse res = h.send(req);
                            }
                            
                        }
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