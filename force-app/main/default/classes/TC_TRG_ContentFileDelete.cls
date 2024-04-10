/* Test Class for Content File Delete */
@isTest
public class TC_TRG_ContentFileDelete {

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
    
    public static testMethod void ContentFileUploadWP10() {
        
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
            insert(WP10SubContract);
            
            ITB_Standard_18__c WP18 = [select id, Project__c from ITB_Standard_18__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract_18__c WP18SubContract = new ITB_with_Sub_Contract_18__c();
            WP18SubContract.Name = 'Test';
            WP18SubContract.ITB_Standard__c = WP18.Id;
            WP18SubContract.BE_ITB_Subcontract_10_ID__c = WP10SubContract.Id;
            insert(WP18SubContract);
            
            WP10SubContract.BE_ITB_Subcontract_18_ID__c = WP18SubContract.Id;
            update(WP10SubContract);
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'WP10',
                PathOnClient = 'WP10.pdf',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            integer documentSize = documents.size() - 1;
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = WP10SubContract.id;
            cdl.ContentDocumentId = documents[documentSize].Id;
            cdl.shareType = 'V';
            insert cdl;        
            
            ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id =: cdl.ContentDocumentId];
            delete(document);
        }
        
    }
    
    public static testMethod void ContentFileUploadWP18() {
        
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
            insert(WP10SubContract);
            
            ITB_Standard_18__c WP18 = [select id, Project__c from ITB_Standard_18__c where Project__c =: Proj.Id];
            
            ITB_with_Sub_Contract_18__c WP18SubContract = new ITB_with_Sub_Contract_18__c();
            WP18SubContract.Name = 'Test';
            WP18SubContract.ITB_Standard__c = WP18.Id;
            WP18SubContract.BE_ITB_Subcontract_10_ID__c = WP10SubContract.Id;
            insert(WP18SubContract);
            
            WP10SubContract.BE_ITB_Subcontract_18_ID__c = WP18SubContract.Id;
            update(WP10SubContract);
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'WP18',
                PathOnClient = 'WP18.pdf',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            integer documentSize = documents.size() - 1;
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = WP18SubContract.id;
            cdl.ContentDocumentId = documents[documentSize].Id;
            cdl.shareType = 'V';
            insert cdl;        
            
            ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id =: cdl.ContentDocumentId];
            delete(document);
        }
    }
    
    public static testMethod void ContentFileUploadWP11() {
        
        
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
            insert(WP11SubContract);
            
            CCE_Approval_Process_19__c WP19 = [select id, Project__c from CCE_Approval_Process_19__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract_19__c WP19SubContract = new CCE_with_Sub_Contract_19__c();
            WP19SubContract.Name = 'Test';
            WP19SubContract.CCE_Approval_Process__c = WP19.Id;
            WP19SubContract.BE_Sub_Contract_11_ID__c = WP11SubContract.Id;
            insert(WP19SubContract);
            
            WP11SubContract.BE_Sub_Contract_19_ID__c = WP19SubContract.Id;
            update(WP11SubContract);
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'WP11',
                PathOnClient = 'WP11.pdf',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            integer documentSize = documents.size() - 1;
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = WP11SubContract.id;
            cdl.ContentDocumentId = documents[documentSize].Id;
            cdl.shareType = 'V';
            insert cdl; 
            
            ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id =: cdl.ContentDocumentId];
            delete(document);
        }
    }
    
    public static testMethod void ContentFileUploadWP19() {
        
        
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
            insert(WP11SubContract);
            
            CCE_Approval_Process_19__c WP19 = [select id, Project__c from CCE_Approval_Process_19__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract_19__c WP19SubContract = new CCE_with_Sub_Contract_19__c();
            WP19SubContract.Name = 'Test';
            WP19SubContract.CCE_Approval_Process__c = WP19.Id;
            WP19SubContract.BE_Sub_Contract_11_ID__c = WP11SubContract.Id;
            insert(WP19SubContract);
            
            WP11SubContract.BE_Sub_Contract_19_ID__c = WP19SubContract.Id;
            update(WP11SubContract);
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'WP19',
                PathOnClient = 'WP19.pdf',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            integer documentSize = documents.size() - 1;
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = WP19SubContract.id;
            cdl.ContentDocumentId = documents[documentSize].Id;
            cdl.shareType = 'V';
            insert cdl;        
            
            ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id =: cdl.ContentDocumentId];
            delete(document);
        }
    }
    
    public static testMethod void ContentFileUploadWP16() {
        
        
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
            
            Cost_Estimate__c WP16 = [select id, Project__c from Cost_Estimate__c where Project__c =: Proj.Id];
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'WP16',
                PathOnClient = 'WP16.pdf',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            integer documentSize = documents.size() - 1;
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = WP16.id;
            cdl.ContentDocumentId = documents[documentSize].Id;
            cdl.shareType = 'V';
            insert cdl;        
            
            ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id =: cdl.ContentDocumentId];
            delete(document);
        }
    }
    
    public static testMethod void ContentFileUploadWP21() {
        
        
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
            
            Equipment_Plan__c Eq = new Equipment_Plan__c();
            Eq.Project_Procurement_Plan__c = WP5.Id;
            Eq.Name = 'Test Equipment';
            Eq.Discipline__c = 'Instrument';
            insert(Eq);
            
            CCE_Approval_Process__c WP11 = [select id, Project__c from CCE_Approval_Process__c where Project__c =: Proj.Id];
            
            CCE_with_Sub_Contract__c WP11SubContract = new CCE_with_Sub_Contract__c();
            WP11SubContract.CCE_Approval_Process__c = WP11.Id;
            insert(WP11SubContract);
            
            Vendor_Data_Management__c WP21 = [select id, Project__c from Vendor_Data_Management__c where Project__c =: Proj.Id];
            
            Vendor_Data_Management_with_Equipment__c WP21Equipment = new Vendor_Data_Management_with_Equipment__c();
            WP21Equipment.Name = 'Test';
            WP21Equipment.Vendor_Data_Management__c = WP21.Id;
            insert(WP21Equipment);
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'WP21',
                PathOnClient = 'WP21.pdf',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            integer documentSize = documents.size() - 1;
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = WP21Equipment.id;
            cdl.ContentDocumentId = documents[documentSize].Id;
            cdl.shareType = 'V';
            insert cdl;        
            
            ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id =: cdl.ContentDocumentId];
            delete(document);
        }
    }
    
    public static testMethod void ContentFileUploadWP17Model() {
        
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
                
            Engineering_Data_Book_and_3D_Model__c WP17 = [select id, Project__c from Engineering_Data_Book_and_3D_Model__c where Project__c =: Proj.Id];
            
            Model_3D__c Model3D = new Model_3D__c();
            Model3D.Engineering_Data_Book_and_3D_Model__c = WP17.Id;
            insert(Model3D);
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'Model',
                PathOnClient = 'Model.pdf',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
            
            integer documentSize = documents.size() - 1;
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = Model3D.id;
            cdl.ContentDocumentId = documents[documentSize].Id;
            cdl.shareType = 'V';
            insert cdl;        
            
            ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument where Id =: cdl.ContentDocumentId];
            delete(document);
        }
    }
    
}