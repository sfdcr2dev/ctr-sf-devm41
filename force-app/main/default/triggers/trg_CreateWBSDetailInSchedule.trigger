/* Trigger to create WBS Detail in Schedule from WP6 Detail (WBS CSB Detaill) */
trigger trg_CreateWBSDetailInSchedule on WBS_CBS_Detail__c  (after insert, after update) {

	/* public Id ProjectId {get;set;}
    public Id WP6Id {get;set;}
    public Id WP7Id {get;set;}
    public string BaseUrl {get;set;}
    
    if(Trigger.IsAfter && Trigger.IsInsert) {
        
        BaseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        for(WBS_CBS_Detail__c WBSDetail : Trigger.New) {
            
            WP6Id = WBSDetail.WBS_and_CBS__c;
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Id =: WP6Id];
            
            ProjectId =  WP6.Project__c;
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: ProjectId];
            
            Schedule_WBS__c SWBS = new Schedule_WBS__c ();
            SWBS.Schedule__c = WP7.Id;  
            SWBS.BE_WBS_Detail_ID__c = WBSDetail.Id;
            SWBS.WBS_CBS_Name__c = WBSDetail.WBS_CBS__c ;
            insert(SWBS);
            
        }
        
    }
    
    if(Trigger.IsAfter && Trigger.IsUpdate) {
        
        BaseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        for(WBS_CBS_Detail__c WBSDetail : Trigger.New) {
            
            WP6Id = WBSDetail.WBS_and_CBS__c;
            
            WBS_CBS__c WP6 = [select id, Project__c from WBS_CBS__c where Id =: WP6Id];
            
            ProjectId =  WP6.Project__c;
            
            Schedule__c WP7 = [select id, Project__c from Schedule__c where Project__c =: ProjectId];
            
            Schedule_WBS__c SWBS = [select id, WBS_CBS_Name__c, BE_WBS_Detail_ID__c from Schedule_WBS__c where BE_WBS_Detail_ID__c =: WBSDetail.Id];
            SWBS.WBS_CBS_Name__c = WBSDetail.WBS_CBS__c ;
            update(SWBS);
            
        }
        
    } */
    
}