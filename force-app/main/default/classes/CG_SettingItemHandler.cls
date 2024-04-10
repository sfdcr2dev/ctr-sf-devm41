/* 
 * Author Softever
*/

public with sharing class CG_SettingItemHandler {
    
    public void CreateAndDeleteJobSchedule(List<CG_Setting_Items__c> CGSettingItems) {
        
        CG_Setting_Items__c CGSettingItem = CGSettingItems[0];
        
        CG_Setting__c CGSetting = [select id, type__c, type_formula__c, start_date__c from CG_Setting__c where id =: CGSettingItem.CG_Setting__c];
        
        Datetime todayDT = system.Datetime.now();
        
        if(todayDT < CGSettingItem.Start_Date__c) {
            
            String userLocale = UserInfo.getLocale();
            integer currentYear = 0;
            
            boolean isThaiLocale = userLocale.contains('th');
            if(isThaiLocale && todayDT.year() > 2500) {
                currentYear = todayDT.year() - 543;
            }
            else {
                currentYear = todayDT.year();
            }
            
            integer dd = CGSettingItem.Start_Date__c.day();
            integer mm = CGSettingItem.Start_Date__c.month();
            integer year = currentYear;
            integer hour = CGSettingItem.Start_Date__c.hour();
            integer minute = CGSettingItem.Start_Date__c.minute();
            
            string finalExpression = '0 ' + String.ValueOf(minute) + ' ' + String.ValueOf(hour) + ' ' + String.ValueOf(dd) + ' ' + String.ValueOf(mm) + ' ? ' + String.ValueOf(year);
                
            if(CGSetting.Type_Formula__c == 'COIMassAcknowledge' || CGSetting.Type__c == 'COI Mass Acknowledge') {
                
                List<CronTrigger> Jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger where CronJobDetail.Name = 'CG Setting - COI Mass Acknowledge Batch'];
                if(Jobs.size() > 0) {
                	System.abortJob(jobs[0].Id);
                }
                
                CG_COIMassAcknowledgeSchedule COIMassAcknowledge = new CG_COIMassAcknowledgeSchedule();
                string cronExp1 = finalExpression;
                system.schedule('CG Setting - COI Mass Acknowledge Batch', cronExp1, COIMassAcknowledge);
                
            }
            else if(CGSetting.Type_Formula__c == 'ResendAnnual' || CGSetting.Type__c == 'Resend (Annual)') {
                
                List<CronTrigger> Jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger where CronJobDetail.Name = 'CG Setting - Resend Annual Batch'];
                if(Jobs.size() > 0) {
                	System.abortJob(jobs[0].Id);
                }
                
                CG_ResendAnnualSchedule ResendAnnual = new CG_ResendAnnualSchedule();
                string cronExp1 = finalExpression;
                system.schedule('CG Setting - Resend Annual Batch', cronExp1, ResendAnnual);
                
            }
        
        }
        
    }
}