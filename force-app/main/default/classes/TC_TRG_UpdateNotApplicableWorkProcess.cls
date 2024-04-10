/* Test class for Not Applicable in All Work Processes */
@isTest
public class TC_TRG_UpdateNotApplicableWorkProcess {

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
            
            insert(MDDs);
        }
    }
    
    public static TestMethod void WP10NotApplicableTrue() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
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
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
            
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            
            Subcontractor_Bidding__c WP5SubContract = new Subcontractor_Bidding__c();
            WP5SubContract.Project_Procurement_Plan__c = WP5.Id;
            insert(WP5SubContract);
            
            ITB_Standard__c WP10 = [select id, Project__c from ITB_Standard__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract__c WP10SubContract = new ITB_with_Sub_Contract__c();
            WP10SubContract.ITB_Standard__c = WP10.Id;
            WP10SubContract.Not_Applicable__c = false;
            insert(WP10SubContract);
            
            ITB_Standard_18__c WP18 = [select id, Project__c from ITB_Standard_18__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract_18__c WP18SubContract = new ITB_with_Sub_Contract_18__c();
            WP18SubContract.Name = 'Test';
            WP18SubContract.ITB_Standard__c = WP18.Id;
            WP18SubContract.BE_ITB_Subcontract_10_ID__c = WP10SubContract.Id;
            WP18SubContract.Not_Applicable__c = false;
            insert(WP18SubContract);
            
            WP10SubContract.Not_Applicable__c = true;
            WP10SubContract.BE_ITB_Subcontract_18_ID__c = WP10SubContract.Id;
            update(WP10SubContract);
        }
    }
    
    public static TestMethod void WP10NotApplicableFalse() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
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
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
                
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            
            Subcontractor_Bidding__c WP5SubContract = new Subcontractor_Bidding__c();
            WP5SubContract.Project_Procurement_Plan__c = WP5.Id;
            insert(WP5SubContract);
            
            ITB_Standard__c WP10 = [select id, Project__c from ITB_Standard__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract__c WP10SubContract = new ITB_with_Sub_Contract__c();
            WP10SubContract.ITB_Standard__c = WP10.Id;
            WP10SubContract.Not_Applicable__c = true;
            insert(WP10SubContract);
            
            ITB_Standard_18__c WP18 = [select id, Project__c from ITB_Standard_18__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract_18__c WP18SubContract = new ITB_with_Sub_Contract_18__c();
            WP18SubContract.Name = 'Test';
            WP18SubContract.ITB_Standard__c = WP18.Id;
            WP18SubContract.BE_ITB_Subcontract_10_ID__c = WP10SubContract.Id;
            WP18SubContract.Not_Applicable__c = false;
            insert(WP18SubContract);
            
            WP10SubContract.Not_Applicable__c = false;
            WP10SubContract.BE_ITB_Subcontract_18_ID__c = WP10SubContract.Id;
            update(WP10SubContract);
        }
        
    }
    
    public static TestMethod void WP18NotApplicableTrue() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
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
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
        
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            
            Subcontractor_Bidding__c WP5SubContract = new Subcontractor_Bidding__c();
            WP5SubContract.Project_Procurement_Plan__c = WP5.Id;
            insert(WP5SubContract);
            
            ITB_Standard__c WP10 = [select id, Project__c from ITB_Standard__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract__c WP10SubContract = new ITB_with_Sub_Contract__c();
            WP10SubContract.ITB_Standard__c = WP10.Id;
            WP10SubContract.Not_Applicable__c = false;
            insert(WP10SubContract);
            
            ITB_Standard_18__c WP18 = [select id, Project__c from ITB_Standard_18__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract_18__c WP18SubContract = new ITB_with_Sub_Contract_18__c();
            WP18SubContract.Name = 'Test';
            WP18SubContract.ITB_Standard__c = WP18.Id;
            WP18SubContract.BE_ITB_Subcontract_10_ID__c = WP10SubContract.Id;
            WP18SubContract.Not_Applicable__c = false;
            insert(WP18SubContract);
            
            WP10SubContract.BE_ITB_Subcontract_18_ID__c = WP18SubContract.Id;
            update(WP10SubContract);
            
            WP18SubContract.Not_Applicable__c = true;
            update(WP18SubContract);
        }
    }
    
    public static TestMethod void WP18NotApplicableFalse() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
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
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
                
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            
            Subcontractor_Bidding__c WP5SubContract = new Subcontractor_Bidding__c();
            WP5SubContract.Project_Procurement_Plan__c = WP5.Id;
            insert(WP5SubContract);
            
            ITB_Standard__c WP10 = [select id, Project__c from ITB_Standard__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract__c WP10SubContract = new ITB_with_Sub_Contract__c();
            WP10SubContract.ITB_Standard__c = WP10.Id;
            WP10SubContract.Not_Applicable__c = false;
            insert(WP10SubContract);
            
            ITB_Standard_18__c WP18 = [select id, Project__c from ITB_Standard_18__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract_18__c WP18SubContract = new ITB_with_Sub_Contract_18__c();
            WP18SubContract.Name = 'Test';
            WP18SubContract.ITB_Standard__c = WP18.Id;
            WP18SubContract.BE_ITB_Subcontract_10_ID__c = WP10SubContract.Id;
            WP18SubContract.Not_Applicable__c = true;
            insert(WP18SubContract);
            
            WP10SubContract.BE_ITB_Subcontract_18_ID__c = WP18SubContract.Id;
            update(WP10SubContract);
            
            WP18SubContract.Not_Applicable__c = false;
            update(WP18SubContract);
        }        
    }
    
    public static TestMethod void WP11NotApplicableTrue() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
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
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
                
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            
            Subcontractor_Bidding__c WP5SubContract = new Subcontractor_Bidding__c();
            WP5SubContract.Project_Procurement_Plan__c = WP5.Id;
            insert(WP5SubContract);
            
            CCE_Approval_Process__c WP11 = [select id, Project__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract__c WP11SubContract = new CCE_with_Sub_Contract__c();
            WP11SubContract.CCE_Approval_Process__c = WP11.Id;
            WP11SubContract.Not_Applicable__c = false;
            insert(WP11SubContract);
            
            CCE_Approval_Process_19__c WP19 = [select id, Project__c from CCE_Approval_Process_19__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract_19__c WP19SubContract = new CCE_with_Sub_Contract_19__c();
            WP19SubContract.Name = 'Test';
            WP19SubContract.CCE_Approval_Process__c = WP19.Id;
            WP19SubContract.BE_Sub_Contract_11_ID__c = WP11SubContract.Id;
            insert(WP19SubContract);
            
            WP11SubContract.BE_Sub_Contract_19_ID__c = WP19SubContract.Id;
            WP11SubContract.Not_Applicable__c = true;
            update(WP11SubContract);
        }
    }
    
    public static TestMethod void WP11NotApplicableFalse() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
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
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
        
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            
            Subcontractor_Bidding__c WP5SubContract = new Subcontractor_Bidding__c();
            WP5SubContract.Project_Procurement_Plan__c = WP5.Id;
            insert(WP5SubContract);
            
            CCE_Approval_Process__c WP11 = [select id, Project__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract__c WP11SubContract = new CCE_with_Sub_Contract__c();
            WP11SubContract.CCE_Approval_Process__c = WP11.Id;
            WP11SubContract.Not_Applicable__c = true;
            insert(WP11SubContract);
            
            CCE_Approval_Process_19__c WP19 = [select id, Project__c from CCE_Approval_Process_19__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract_19__c WP19SubContract = new CCE_with_Sub_Contract_19__c();
            WP19SubContract.Name = 'Test';
            WP19SubContract.CCE_Approval_Process__c = WP19.Id;
            WP19SubContract.BE_Sub_Contract_11_ID__c = WP11SubContract.Id;
            insert(WP19SubContract);
            
            WP11SubContract.BE_Sub_Contract_19_ID__c = WP19SubContract.Id;
            WP11SubContract.Not_Applicable__c = false;
            update(WP11SubContract);
        }
    }
    
    public static TestMethod void WP19NotApplicableTrue() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
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
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
        
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            
            Subcontractor_Bidding__c WP5SubContract = new Subcontractor_Bidding__c();
            WP5SubContract.Project_Procurement_Plan__c = WP5.Id;
            insert(WP5SubContract);
            
            CCE_Approval_Process__c WP11 = [select id, Project__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract__c WP11SubContract = new CCE_with_Sub_Contract__c();
            WP11SubContract.CCE_Approval_Process__c = WP11.Id;
            WP11SubContract.Not_Applicable__c = false;
            insert(WP11SubContract);
            
            CCE_Approval_Process_19__c WP19 = [select id, Project__c from CCE_Approval_Process_19__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract_19__c WP19SubContract = new CCE_with_Sub_Contract_19__c();
            WP19SubContract.Name = 'Test';
            WP19SubContract.CCE_Approval_Process__c = WP19.Id;
            WP19SubContract.BE_Sub_Contract_11_ID__c = WP11SubContract.Id;
            WP19SubContract.Not_Applicable__c = false;
            insert(WP19SubContract);
            
            WP11SubContract.BE_Sub_Contract_19_ID__c = WP19SubContract.Id;
            update(WP11SubContract);
            
            WP19SubContract.Not_Applicable__c = true;
            update(WP19SubContract);
        }
    }
    
    public static TestMethod void WP19NotApplicableFalse() {
        
        MasterDataInfo();
        
        User u = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'PM'].Id,
        UserRoleId = [select id From UserRole where Name = 'TOPPMP-AI PM'].Id,
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
            
            Project__c Proj = new Project__c();
            Proj.Name = 'Test Project';
            Proj.Project_Number__c = 'Test 001';
            Proj.Project_Manager__c = u.Id;
            insert(Proj);
        
            Project_Procurement_Plan__c WP5 = [select id, Project__c from Project_Procurement_Plan__c where Project__c =: Proj.Id];
            
            Subcontractor_Bidding__c WP5SubContract = new Subcontractor_Bidding__c();
            WP5SubContract.Project_Procurement_Plan__c = WP5.Id;
            insert(WP5SubContract);
            
            CCE_Approval_Process__c WP11 = [select id, Project__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract__c WP11SubContract = new CCE_with_Sub_Contract__c();
            WP11SubContract.CCE_Approval_Process__c = WP11.Id;
            WP11SubContract.Not_Applicable__c = false;
            insert(WP11SubContract);
            
            CCE_Approval_Process_19__c WP19 = [select id, Project__c from CCE_Approval_Process_19__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract_19__c WP19SubContract = new CCE_with_Sub_Contract_19__c();
            WP19SubContract.Name = 'Test';
            WP19SubContract.CCE_Approval_Process__c = WP19.Id;
            WP19SubContract.BE_Sub_Contract_11_ID__c = WP11SubContract.Id;
            WP19SubContract.Not_Applicable__c = true;
            insert(WP19SubContract);
            
            WP11SubContract.BE_Sub_Contract_19_ID__c = WP19SubContract.Id;
            update(WP11SubContract);
            
            WP19SubContract.Not_Applicable__c = false;
            update(WP19SubContract);
        }
    }
    
}