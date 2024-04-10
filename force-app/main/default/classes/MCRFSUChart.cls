/* Class for MCRSFU Chart VF Page */
public with sharing class MCRFSUChart {

    public Id ProjectId {get;set;}
    
    public integer WaitingMCCount {get;set;}
    public integer MCCount {get;set;}
    public integer RFSUCount {get;set;}
    public boolean isDataAvailable {get;set;}

    public MCRFSUChart(ApexPages.StandardController controller) {

        WaitingMCCount = 0;
        MCCount = 0;
        RFSUCount = 0;
        isDataAvailable = false;
        MC_RSFU__c CurrentMCRFSU = (MC_RSFU__c)controller.getRecord();
       
        MC_RSFU__c MCRFSU = [select id, Project__c from MC_RSFU__c where Id =: CurrentMCRFSU.Id];
        
        if(MCRFSU != null) {
        
            ProjectId = MCRFSU.Project__c;
            //Handover Details
            HandoverDetails(ProjectId);
        }
        else {
            isDataAvailable = false;
            WaitingMCCount = 0;
            MCCount = 0;
            RFSUCount = 0;
        }

    }
    
    public void HandoverDetails(Id ProjectId) {
        
        Punch_List_Management_System__c WP27 = [select id, Project__c from Punch_List_Management_System__c where Project__c =: ProjectId];
        
        if(WP27 != null) {
            
            List<Handover__c> Handovers = [select id, Punch_List_Management_System__c, MC_P__c, MC__c, RSFU_P__c, RSFU__c from Handover__c where Punch_List_Management_System__c =: WP27.Id];
            
            if(Handovers.size() > 0) {
            
                isDataAvailable = true;
                for(Handover__c Handover : Handovers) {
                    
                    if(Handover.MC__c == null && Handover.RSFU__c == null) {
                        WaitingMCCount = WaitingMCCount + 1;
                    }
                    else if(Handover.MC__c != null && Handover.RSFU__c == null) {
                        MCCount = MCCount + 1;
                    }
                    else if(Handover.RSFU__c != null) {
                        RFSUCount = RFSUCount + 1;
                    }
                    
                }
                
            }
            else {
                isDataAvailable = false;
            }
            
        }
        
    }

}