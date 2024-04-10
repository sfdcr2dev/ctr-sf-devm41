/* 
 * Author Softever
*/

public with sharing class CG_SettingHandler {
    
    public void CheckSettingCreation(List<CG_Setting__c> CGSettings, List<CG_Setting__c> OldCGSettings) {
        
        DateTime todayDT = datetime.now();
        
        CG_Setting__c OldCGSetting = new CG_Setting__c();
        
        if(OldCGSettings != null) {
        	OldCGSetting = OldCGSettings[0];
        }
        
        CG_Setting__c CGSetting = CGSettings[0];
        
        /* if(todayDT > CGSetting.Start_Date__c) {
            CGSettings[0].addError('ไม่สามารถ Save CG Setting นี้ได้เนื่องจากสร้าง Setting หลังจากวันปัจจุบัน');
        } */
        
        if(!string.isBlank(CGSetting.Duration_JSON__c) && OldCGSetting.Duration_JSON__c != null) {
            List<CG_DTO.DurationDTO> DurationDTOs = (List<CG_DTO.DurationDTO>)JSON.deserialize(OldCGSetting.Duration_JSON__c, List<CG_DTO.DurationDTO>.class);
            
            DateTime startDate = CG_ReportingHandler.ConvertToCurrentTimeZoneDateTime(CGSetting.Start_Date__c);
            
            if(DurationDTOs.size() > 0) {
                
                for(CG_DTO.DurationDTO existDuration : DurationDTOs) {
                    
        			System.debug(startDate);
        			System.debug(existDuration.startDate);
                    if(startDate >= existDuration.startDate && startDate <= existDuration.endDate) {
                        CGSettings[0].addError('ไม่สามารถ Save CG Setting นี้ได้เนื่องจากมีการสร้าง Setting ใน Duration ที่กำหนดก่อนหน้านี้แล้ว');
                    }
                }
            }
        }
        
    }
    
    public void CreateAndDeleteJobSchedule(List<CG_Setting__c> CGSettings) {
        
        CG_Setting__c CGSetting = CGSettings[0];
        
        Datetime todayDT = system.Datetime.now();
        
        System.debug(todayDT);
        System.debug(CGSetting.Start_Date__c);
        
        if(todayDT < CGSetting.Start_Date__c) {
            
            String userLocale = UserInfo.getLocale();
            integer currentYear = 0;
            
            boolean isThaiLocale = userLocale.contains('th');
            if(isThaiLocale && todayDT.year() > 2500) {
                currentYear = todayDT.year() - 543;
            }
            else {
                currentYear = todayDT.year();
            }
            
            integer dd = CGSetting.Start_Date__c.day();
            integer mm = CGSetting.Start_Date__c.month();
            integer year = currentYear;
            integer hour = CGSetting.Start_Date__c.hour();
            integer minute = CGSetting.Start_Date__c.minute();
            
            string finalExpression = '0 ' + String.ValueOf(minute) + ' ' + String.ValueOf(hour) + ' ' + String.ValueOf(dd) + ' ' + String.ValueOf(mm) + ' ? ' + String.ValueOf(year);
                
            if(CGSetting.Type_Formula__c == 'CGManual') {
                
                List<CronTrigger> Jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger where CronJobDetail.Name = 'CG Setting - CG Manual Batch'];
                if(Jobs.size() > 0) {
                	System.abortJob(jobs[0].Id);
                }
                
                CG_CGManualSchedule CGManual = new CG_CGManualSchedule();
                string cronExp1 = finalExpression;
                system.schedule('CG Setting - CG Manual Batch', cronExp1, CGManual);
                
            }
            else if(CGSetting.Type_Formula__c == 'Annual') {
                
                List<CronTrigger> Jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger where CronJobDetail.Name = 'CG Setting - Annual Batch'];
                if(Jobs.size() > 0) {
                	System.abortJob(jobs[0].Id);
                }
                
                CG_ResendAnnualSchedule ResendAnnual = new CG_ResendAnnualSchedule();
                string cronExp1 = finalExpression;
                system.schedule('CG Setting - Annual Batch', cronExp1, ResendAnnual);
                
            }
        
        }
        
    }
}