/* 
 * Author Softever
 
    CG_COIMassAcknowledgeSchedule COIMass = new CG_COIMassAcknowledgeSchedule();
    string cronExp1 = '0 0 12 1 * ? *';  
    system.schedule('COI Mass Acknowledge', cronExp1, COIMass);
	
	Purpose : Run this batch at specific time in CG Setting COI Mass Acknowledge.
*/

global class CG_COIMassAcknowledgeBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor),
        											String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP) };
                                                        
    public List<string> TypeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIIncident),
        													String.ValueOf(CG_Enum.COIReportType.COINewEmployee)  };
                                                                
    public string query = 'select id, running_no__c, start_duration__c, end_duration__c, status__c, type_of_report__c, ownerId, user__c, GLVP_Id__c ' +
        					'from cg_reporting__c where status__c IN: statuses AND type_of_report__c IN: TypeOfReports';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<CG_Reporting__c> CGReports) {
        
        Set<Id> Supervisors = new Set<Id>();
        Set<Id> GLVPs = new Set<Id>();
        
        if(CGReports.size() > 0) {
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'COI_Mass_Acknowledge'];
            
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(String.isNotEmpty(CGReport.User__c) && String.isNotBlank(CGReport.User__c)) {
                	Supervisors.add(CGReport.User__c);
                }
                
                if(String.isNotEmpty(CGReport.GLVP_Id__c) && String.isNotBlank(CGReport.GLVP_Id__c)) {
                    GLVPs.add(CGReport.GLVP_Id__c);
                }
            }
            
            //Send email to Supervisor
            if(Supervisors.size() > 0) {
                for(string Supervisor : Supervisors) {
                    
                    integer recordCount = 0;
                    
                    for(CG_Reporting__c CGReport : CGReports) {
                        if(Supervisor == CGReport.User__c && CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                            recordCount++;
                        }
                    }
                    
                    if(recordCount > 0) {
                        Messaging.SingleEmailMessage sendEmail = CG_ReportingHandler.COIMassAcknowledgeEmail(String.ValueOf(CG_Enum.ApproverRole.Supervisor), emailTemplate, Supervisor, recordCount);
                        sendEmails.add(sendEmail);
                        
                        //Send Bell Noti to Supervisor
                        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                        BellNoti.NotificationName = 'CG_Notification';
                        BellNoti.Title = 'Please Acknowledge COI Report';
                        BellNoti.Body = 'You have ' + recordCount + ' reports to acknowledge. Please acknowledge Conflict of Interest report.';
                        BellNoti.Receivers = new Set<string>();
                        BellNoti.Receivers.add(Supervisor);
                        BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Supervisor_Mass_Acknowledge\'}}';
                        CG_NotiController.SendBellNoti(BellNoti);
                        
                        //Send Opp Noti
                        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                        OppNoti.ApproverId = Supervisor;
                        OppNoti.Subject = 'Please Acknowledge COI Report';
                        OppNoti.Description = 'You have ' + recordCount + ' reports to acknowledge. Please acknowledge Conflict of Interest report.';
                        //OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                        OppNoti.Status = 'New';
                        
                        string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Supervisor_Mass_Acknowledge';
                        
                        OppNoti.URL = URL;
                        //OppNoti.ReferenceId = CGReport.Id;
                        CG_NotiController.SendOppNoti(OppNoti);
                         
                    }                                                                              
                }
            }
            
            //Send email to GLVP
            Set<Id> GLVPIds = GLVPUsers();
            
            if(GLVPIds.size() > 0) {
                
                integer recordCount = 0;
                
                for(CG_Reporting__c CGReport : CGReports) {
                    if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                        recordCount++;
                    }
                }
                
                if(recordCount > 0) {
                    for(string GLVP : GLVPIds) {
                    
                        Messaging.SingleEmailMessage sendEmail = CG_ReportingHandler.COIMassAcknowledgeEmail(String.ValueOf(CG_Enum.ApproverRole.GLVP), emailTemplate, GLVP, recordCount);
                        sendEmails.add(sendEmail);
                                             
                        //Send Bell Noti to GLVP
                        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                        BellNoti.NotificationName = 'CG_Notification';
                        BellNoti.Title = 'Please Acknowledge COI Report';
                        BellNoti.Body = 'You have ' + recordCount + ' reports to acknowledge. Please acknowledge Conflict of Interest report.';
                        BellNoti.Receivers = new Set<string>();
                        BellNoti.Receivers.add(GLVP);
                        BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_GLVP_Mass_Acknowledge\'}}';
                        CG_NotiController.SendBellNoti(BellNoti);
                        
                        //Send Opp Noti
                        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                        OppNoti.ApproverId = GLVP;
                        OppNoti.Subject = 'Please Acknowledge COI Report';
                        OppNoti.Description = 'You have ' + recordCount + ' reports to acknowledge. Please acknowledge Conflict of Interest report.';
                        //OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                        OppNoti.Status = 'New';
                        
                        string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_GLVP_Mass_Acknowledge';
                        
                        OppNoti.URL = URL;
                        //OppNoti.ReferenceId = CGReport.Id;
                        CG_NotiController.SendOppNoti(OppNoti);
                        
                    }
                }
            }
            
            if(sendEmails.size() > 0) {
                Messaging.sendEmail(sendEmails);
            }
        }
  
    }
    
    global void finish(Database.BatchableContext BC){    
    }
    
    private static Set<Id> GLVPUsers() {
        
        Set<Id> GLVPIds = new Set<Id>();
        
        //Find from Group GLVP
        Group GLVPGroup = [select id, developername from Group where developername =: 'CG_GLVP'];
        List<GroupMember> GLVPUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GLVPGroup.Id];
        
        if(GLVPUsers.size() > 0) {
            
            for(GroupMember GLVPUser : GLVPUsers) {
                Id GLVPUserId = GLVPUser.userorgroupid;
                GLVPIds.add(GLVPUserId);
            }
            
        }
        
        return GLVPIds;
        
    }
    
}