/* 
    ESS_RetirementEmployeeReminderBatchable RetirementReminder = new ESS_RetirementEmployeeReminderBatchable();
    string cronExp1 = '0 0 12 1 * ? *';
    system.schedule('ESS - Retirment employee email reminder', cronExp1, RetirementReminder);
	
	Run every day
	For Test '0 59 23 31 07 ? *'
*/
global class ESS_RetirementEmployeeReminderController implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public date todayDate = system.Date.today();
    public List<string> statuses = new List<string>{ ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name(),
        											ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name(),
        											ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()};
    public string query = 'select id, status__c, First_Reminder__c, Other_Reminder__c, OwnerId, CreatedDate, Document_No__c, ' +
        					'Employee_Name__c, Employee_ID__c, Section_Head_Reminder__c, Department_Head_Reminder__c, Section_Head_Id__c, Department_Head_Id__c, Submitted_Date__c from ESS_Retirement__c ' + 
        					'where status__c IN: statuses';
         
	global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }    
    
    global void execute(Database.BatchableContext BC, List<ESS_Retirement__c> Retirements) {
        if(Retirements.size() > 0){
            for(ESS_Retirement__c Retirement : Retirements) {
                
                //Reminder for Employee
                if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name() &&
                  	Retirement.First_Reminder__c != null) {
                        
                        if(Retirement.First_Reminder__c == todayDate) {
                            ESS_NotiAndEmailController.RetirementSendToEmployeeWhenCreate(Retirement);
                        }
                        else if(string.isNotEmpty(Retirement.Other_Reminder__c)) {
                            List<string> reminders = (List<string>)JSON.deserialize(Retirement.Other_Reminder__c, List<string>.class);
                            if(reminders.size() > 0) {
                                for(integer i=0; i<reminders.size(); i++) {
                                    date reminderDate = Date.ValueOf(reminders[i]);
                                    if(reminderDate == todayDate) {
                                        ESS_NotiAndEmailController.RetirementSendToEmployeeWhenCreate(Retirement);
                                    }
                                }
                            }
                        }
                }
                //Reminder for Section Head
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name() &&
                  	string.isNotBlank(Retirement.Section_Head_Reminder__c)) {
                    List<string> reminders = (List<string>)JSON.deserialize(Retirement.Section_Head_Reminder__c, List<string>.class);
                        if(reminders.size() > 0) {
                            for(integer i=0; i<reminders.size(); i++) {
                                date reminderDate = Date.ValueOf(reminders[i]);
                                if(reminderDate == todayDate) {
                                    ESS_NotiAndEmailController.RetirementSendToSectionHead(Retirement);
                                }
                            }
                        }
                }
                //Reminder for Department Head
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name() &&
                  	string.isNotBlank(Retirement.Department_Head_Reminder__c)) {
                    List<string> reminders = (List<string>)JSON.deserialize(Retirement.Department_Head_Reminder__c, List<string>.class);
                        if(reminders.size() > 0) {
                            for(integer i=0; i<reminders.size(); i++) {
                                date reminderDate = Date.ValueOf(reminders[i]);
                                if(reminderDate == todayDate) {
                                    ESS_NotiAndEmailController.RetirementSendToDepartmentHead(Retirement);
                                }
                            }
                        }
                }
                
            }       
        }
    }
    
    global void finish(Database.BatchableContext BC){    
    }
    
}