/* Test class for Master Data Detail update SME */
@isTest
public class TC_TRG_UpdateSMEFromMasterData {

    public static void MasterDataInfo() {
        //Master Data
        User SMEUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'SME'].Id,
            UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI AD&SME'].Id,
            LastName = 'last',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(SMEUser);
        
        System.runAs(SMEUser) {
            Master_Data__c MD = new Master_Data__c();
            MD.Name = 'SME and Guideline';
            insert(MD);
            
            List<Master_Data_Detail__c> MDDs = new List<Master_Data_Detail__c>();
            
            Master_Data_Detail__c MDD1 = new Master_Data_Detail__c();
            MDD1.Work_Process_No__c = 0;
            MDD1.Group__c = 10;
            MDD1.Name = 'Project Risk Assessment';
            MDD1.Work_Process_Group__c = '10';
            MDD1.Master_Data__c = MD.Id;
            MDD1.SME__c = SMEUser.Id;
            MDDs.add(MDD1);
            
            Master_Data_Detail__c MDD2 = new Master_Data_Detail__c();
            MDD2.Work_Process_No__c = 1;
            MDD2.Group__c = 1;
            MDD2.Name = 'Project Charter';
            MDD2.Work_Process_Group__c = '1';
            MDD2.Master_Data__c = MD.Id;
            MDD2.SME__c = SMEUser.Id;
            MDDs.add(MDD2);
            
            insert(MDDs);
        }
    }
    
    public static testMethod void UpdateSMEFromMasterData() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'SME'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI AD&SME'].Id,
        LastName = 'last',
        Email = 'test@thaioilgroup.com',
        Username = 'test@thaioilgroup.com' + System.currentTimeMillis(),
        CompanyName = 'Thaioil',
        Alias = 'test',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US'
    	);
        insert(u);
        
        System.runAs(u) {
            Master_Data__c MD = [select id, name from Master_Data__c where Name = 'SME and Guideline'];
        
            Master_Data_Detail__c MDDetail = [select id, Master_Data__c, SME__c from Master_Data_Detail__c where Master_Data__c =: MD.Id AND Work_Process_No__c = 1];
            MDDetail.SME__c = u.Id;
            update(MDDetail);
        }
    }
    
}