/* 
    ESS_ProbationReminderBatchable ProbationAdminReminder = new ESS_ProbationReminderBatchable();
    string cronExp1 = '0 0 12 1 * ? *';
    system.schedule('ESS - Probation reminder for section head / department head', cronExp1, ProbationAdminReminder);
	
	Run on every day
	For Test '0 0 8 * * ? *'
*/
global class ESS_ProbationReminderController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    private static string orgId = UserInfo.getOrganizationId();
    public date todayDate = system.Date.today();
    public List<string> statuses = new List<string> { ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name(), 
        											ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name(), 
        											ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name(),
        											ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name() };
    
    public string query = 'select id, document_no__c, status__c, employee_id__c, employee_name_en__c, section_head_id__c, department_head_id__c, ' +
        					'section_head_reminder__c, department_head_reminder__c, Reassign_Section_Head_Reminder__c, Reassign_Department_Head_Reminder__c, Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, createddate, section_head_approve_date__c ' +
        					'from ESS_Probationary__c where status__c IN :statuses';
         
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ESS_Probationary__c> Probations) {
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND User__c != null];
            
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                if(PISUser.MAINPOSITION__c) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }    
        } 
        
        if(Probations.size() > 0) {
            
            List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
            
            for(ESS_Probationary__c Probation : Probations) {
                if(Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name() &&
                   string.isNotBlank(Probation.Section_Head_Reminder__c)) {
                       List<string> reminders = (List<string>)JSON.deserialize(Probation.Section_Head_Reminder__c, List<string>.class);
                       if(reminders.size() > 0) {
                           for(integer i=0; i<reminders.size(); i++) {
                               date reminderDate = Date.ValueOf(reminders[i]);
                               if(reminderDate == todayDate) {
                                   Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ProbationSendToSectionHeadWhenCreated(Probation, mapPISUsers);
                                   sendEmails.add(sendEmail);
                               }
                    	}
                	}
                }
                else if(Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name() &&
                   string.isNotBlank(Probation.Department_Head_Reminder__c)) {
                       List<string> reminders = (List<string>)JSON.deserialize(Probation.Department_Head_Reminder__c, List<string>.class);
                        if(reminders.size() > 0) {
                            for(integer i=0; i<reminders.size(); i++) {
                                date reminderDate = Date.ValueOf(reminders[i]);
                                if(reminderDate == todayDate) {
                                    Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ProbationSendToDepartmentHeadWhenSectionHeadSubmitted(Probation, mapPISUsers);
                                	sendEmails.add(sendEmail);
                                }
                            }
                        }
                   }
                else if(Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name() &&
                   string.isNotBlank(Probation.Reassign_Section_Head_Reminder__c)) {
                       List<string> reminders = (List<string>)JSON.deserialize(Probation.Reassign_Section_Head_Reminder__c, List<string>.class);
                       if(reminders.size() > 0) {
                           for(integer i=0; i<reminders.size(); i++) {
                               date reminderDate = Date.ValueOf(reminders[i]);
                               if(reminderDate == todayDate) {
                                   Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ProbationSendToReAssignUserWhenReAssigned(Probation, mapPISUsers);
                                   sendEmails.add(sendEmail);
                               }
                    	}
                	}
                }
                else if(Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name() &&
                   string.isNotBlank(Probation.Reassign_Department_Head_Reminder__c)) {
                       List<string> reminders = (List<string>)JSON.deserialize(Probation.Reassign_Department_Head_Reminder__c, List<string>.class);
                        if(reminders.size() > 0) {
                            for(integer i=0; i<reminders.size(); i++) {
                                date reminderDate = Date.ValueOf(reminders[i]);
                                if(reminderDate == todayDate) {
                                    Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ProbationSendToReAssignUserWhenReAssigned(Probation, mapPISUsers);
                                	sendEmails.add(sendEmail);
                                }
                            }
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
    
}