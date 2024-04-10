/* Test class for ImportExportCSVFile Class */
@isTest
public class TC_ImportExportCSVFile {

    public static String[] csvFileLines;
    public static Blob csvFileBody;
    
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
        
    public static testMethod void ImportCSVFile() {
        
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
        
            Punch_List_Management_System__c WP27 = [select id, Project__c, Project__r.Project_Number__c, Project__r.Name from Punch_List_Management_System__c where Project__c =: Proj.Id];
            
            PageReference pageRef = Page.ADDashboard;
            pageRef.getParameters().put('WP27Id',WP27.Id);        
            Test.setCurrentPage(PageRef);
            
            string uploadHandover = 'Project No,Item,Sub System Numbering,Contractor,P ID,Tag and Datasheet,SAP Data,Operating Manual,Spare Parts List,Concerned Equipment Installation,Punch A Complete,Red Mark,Test Pack,Piping Reinstatement,E and I Work Election,MC P,MC,Punch B,Loop Testing,Function Testing,MCC,As Built,P&ID,PSSR,HOC,RSFU P,RSFU,As Built,COD,Punch C\n';
            string firstRowData = 'Test 001,123,Test,Test,Test,10,10,10,10,10,10,10,10,10,10,2020-09-08,,10,10,10,10,10,2020-09-08,10,2020-09-08,2020-09-08,20,2020-09-08,10';
            
            string csv = uploadHandover + firstRowData;
            
            test.startTest();
            
            csvFileBody = Blob.valueOf(csv);
            string csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            
            ApexPages.StandardController sc = new ApexPages.StandardController(WP27);                         
            ImportExportCSVFile ImportExport = new ImportExportCSVFile(sc); 
            ImportExport.currentWPId = WP27.Id;
            ImportExport.FileContent = csvFileBody;
            ImportExport.ClearExistingHandover(WP27.Id);
            ImportExport.getuploadedHandovers();
            ImportExport.ReadFile();
            ImportExport.ConfirmUpload();
            
            test.stopTest();
        }
    }
    
    public static testMethod void ExportCSVFile() {
        
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
        
            Punch_List_Management_System__c WP27 = [select id, Project__c, Project__r.Project_Number__c, Project__r.Name from Punch_List_Management_System__c where Project__c =: Proj.Id];
            
            PageReference pageRef = Page.ADDashboard;
            pageRef.getParameters().put('WP27Id',WP27.Id);        
            Test.setCurrentPage(PageRef);
            
            string uploadHandover = 'Project No,Item,Sub System Numbering,Contractor,P ID,Tag and Datasheet,SAP Data,Operating Manual,Spare Parts List,Concerned Equipment Installation,Punch A Complete,Red Mark,Test Pack,Piping Reinstatement,E and I Work Election,MC P,MC,Punch B,Loop Testing,Function Testing,MCC,As Built,P&ID,PSSR,HOC,RSFU P,RSFU,As Built,COD,Punch C\n';
            string firstRowData = 'Test 001,123,Test,Test,Test,10,10,10,10,10,10,10,10,10,10,2020-09-08,,10,10,10,10,10,2020-09-08,10,2020-09-08,2020-09-08,20,2020-09-08,10';
            
            string csv = uploadHandover + firstRowData;
            
            test.startTest();
            
            csvFileBody = Blob.valueOf(csv);
            string csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            
            ApexPages.StandardController sc = new ApexPages.StandardController(WP27);                         
            ImportExportCSVFile ImportExport = new ImportExportCSVFile(); 
            ImportExport.currentWPId = WP27.Id;
            ImportExport.FileContent = csvFileBody;
            ImportExport.ClearExistingHandover(WP27.Id);
            ImportExport.getuploadedHandovers();
            ImportExport.ReadFile();
            ImportExport.CancelUpload();
            
            test.stopTest();
        }
    }
    
    public static testMethod void ImportCSVFileDiffProjectNo() {
        
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
        
            Punch_List_Management_System__c WP27 = [select id, Project__c, Project__r.Project_Number__c, Project__r.Name from Punch_List_Management_System__c where Project__c =: Proj.Id];
            
            PageReference pageRef = Page.ADDashboard;
            pageRef.getParameters().put('WP27Id',WP27.Id);        
            Test.setCurrentPage(PageRef);
            
            string uploadHandover = 'Project No,Item,Sub System Numbering,Contractor,P ID,Tag and Datasheet,SAP Data,Operating Manual,Spare Parts List,Concerned Equipment Installation,Punch A Complete,Red Mark,Test Pack,Piping Reinstatement,E and I Work Election,MC P,MC,Punch B,Loop Testing,Function Testing,MCC,As Built,P&ID,PSSR,HOC,RSFU P,RSFU,As Built,COD,Punch C\n';
            string firstRowData = 'Test 001,123,Test,Test,Test,10,10,10,10,10,10,10,10,10,10,2020-09-08,,10,10,10,10,10,2020-09-08,10,2020-09-08,2020-09-08,20,2020-09-08,10\n';
            string secondRowData = 'Test 002,123,Test,Test,Test,10,10,10,10,10,10,10,10,10,10,2020-09-08,,10,10,10,10,10,2020-09-08,10,2020-09-08,2020-09-08,20,2020-09-08,10';
    
            string csv = uploadHandover + firstRowData + secondRowData;
            
            test.startTest();
            
            csvFileBody = Blob.valueOf(csv);
            string csvAsString = csvFileBody.toString();
            csvFileLines = csvAsString.split('\n');
            
            ApexPages.StandardController sc = new ApexPages.StandardController(WP27);                         
            ImportExportCSVFile ImportExport = new ImportExportCSVFile(sc); 
            ImportExport.currentWPId = WP27.Id;
            ImportExport.FileContent = csvFileBody;
            ImportExport.ClearExistingHandover(WP27.Id);
            ImportExport.getuploadedHandovers();
            ImportExport.ReadFile();
            //ImportExport.ConfirmUpload();
            
            test.stopTest();
        }
    }
    
}