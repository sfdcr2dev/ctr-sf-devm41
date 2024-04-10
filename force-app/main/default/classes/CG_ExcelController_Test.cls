@isTest
public with sharing class CG_ExcelController_Test {

    public static testMethod void GetExportAllTest() {
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com.icr',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        Test.startTest();  
            
        Group approverGroup = [select id from Group where Name = 'CG : Admin'];
        
        GroupMember member = new GroupMember();
        member.UserOrGroupId = testUser.Id;
        member.GroupId = approverGroup.Id;
        insert(member);
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            insert(CGReporting);
            
            PageReference ExcelExportVFPage = Page.CG_Report_Excel;
			Test.setCurrentPage(ExcelExportVFPage);
            
            CG_ExcelController CGExcelExport = new CG_ExcelController();
            
            ApexPages.currentPage().getParameters().put('exportAll', 'true');
            ApexPages.currentPage().getParameters().put('startDate', '2022-01-01');
            ApexPages.currentPage().getParameters().put('endDate', '2022-12-31');
            ApexPages.currentPage().getParameters().put('typeOfReport', 'all');
            CGExcelExport.OnloadExcel();

        }
                    
        Test.stopTest();
        
    }
    
    public static testMethod void GetExportCOIAllTest() {
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com.icr',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        Test.startTest();  
            
        Group approverGroup = [select id from Group where Name = 'CG : Admin'];
        
        GroupMember member = new GroupMember();
        member.UserOrGroupId = testUser.Id;
        member.GroupId = approverGroup.Id;
        insert(member);
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ApproverStatus.Submitted);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Owner_Function__c = 'ABCD';
            insert(CGReporting);
            
            PageReference ExcelExportVFPage = Page.CG_Report_Excel;
			Test.setCurrentPage(ExcelExportVFPage);
            
            CG_ExcelController CGExcelExport = new CG_ExcelController();
            
            ApexPages.currentPage().getParameters().put('exportAll', 'true');
            ApexPages.currentPage().getParameters().put('reportName', 'COI');
            ApexPages.currentPage().getParameters().put('startDate', '2022-01-01');
            ApexPages.currentPage().getParameters().put('endDate', '2022-12-31');
            ApexPages.currentPage().getParameters().put('typeOfReport', 'all');
            CGExcelExport.OnloadExcel();
            
			CG_ExcelController.CGGlobal_GetCompanies();
            CG_ExcelController.CGGlobal_GetFunctions(null);
            CG_ExcelController.CGGlobal_GetDepartments(null);
            CG_ExcelController.CGGlobal_GetSections(null);
            CG_ExcelController.CGGlobal_GetUnits(null);
        }
                    
        Test.stopTest();
        
    }
    
    public static testMethod void GetCOIExportDataTest() {
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com.icr',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        Test.startTest();  
            
        Group approverGroup = [select id from Group where Name = 'CG : Admin'];
        
        GroupMember member = new GroupMember();
        member.UserOrGroupId = testUser.Id;
        member.GroupId = approverGroup.Id;
        //insert(member);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'Junior';
        thaninthon.FUNCTION__c = 'EVPC';
        thaninthon.ORGID__c = '00000818';
        thaninthon.POSID__c = '00000544';
        thaninthon.ENFIRSTNAME__c = 'Test';
        thaninthon.ENLASTNAME__c = 'Test';
        thaninthon.HOLDERPOSITION__c = '00000544';
        thaninthon.EMAIL__c = 'test@thaioilgroup.com';
        thaninthon.User__c = testUser.Id;
        thaninthon.ReportToPOS__c = '00001365';
        thaninthon.ReportToID__c = '00000598';
        thaninthon.ReportToEmail__c = 'test@thaioilgroup.com';
        thaninthon.ReportToUser__c = testUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        insert(thaninthon);
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            CGReporting.COI_Disclosure__c = 'Yes';
            insert(CGReporting);
            
            PageReference ExcelExportVFPage = Page.CG_Report_Excel;
			Test.setCurrentPage(ExcelExportVFPage);
            
            CG_ExcelController CGExcelExport = new CG_ExcelController();
            
            ApexPages.currentPage().getParameters().put('exportAll', 'false');
            ApexPages.currentPage().getParameters().put('reportName', 'COI');
            ApexPages.currentPage().getParameters().put('startDate', '2022-01-01');
            ApexPages.currentPage().getParameters().put('endDate', '2022-12-31');
            ApexPages.currentPage().getParameters().put('typeOfReport', 'all');
            ApexPages.currentPage().getParameters().put('status', 'Success');
            ApexPages.currentPage().getParameters().put('coiAnswer', 'Yes');
            ApexPages.currentPage().getParameters().put('company', 'TOP');
            ApexPages.currentPage().getParameters().put('function', 'EVPC');
            ApexPages.currentPage().getParameters().put('department', 'EVPO');
            ApexPages.currentPage().getParameters().put('section', 'SCSE');
            ApexPages.currentPage().getParameters().put('unit', 'ABCD');
            CGExcelExport.OnloadExcel();
            
			CG_ExcelController.CGGlobal_GetCompanies();
            CG_ExcelController.CGGlobal_GetFunctions(null);
            CG_ExcelController.CGGlobal_GetDepartments(null);
            CG_ExcelController.CGGlobal_GetSections(null);
            CG_ExcelController.CGGlobal_GetUnits(null);
        }
                    
        Test.stopTest();
        
    }
    
    public static testMethod void GetCOIStatisticDataTest() {
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com.icr',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        Test.startTest();  
            
        Group approverGroup = [select id from Group where Name = 'CG : Admin'];
        
        GroupMember member = new GroupMember();
        member.UserOrGroupId = testUser.Id;
        member.GroupId = approverGroup.Id;
        //insert(member);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'Junior';
        thaninthon.FUNCTION__c = 'EVPC';
        thaninthon.ORGID__c = '00000818';
        thaninthon.POSID__c = '00000544';
        thaninthon.ENFIRSTNAME__c = 'Test';
        thaninthon.ENLASTNAME__c = 'Test';
        thaninthon.HOLDERPOSITION__c = '00000544';
        thaninthon.EMAIL__c = 'test@thaioilgroup.com';
        thaninthon.User__c = testUser.Id;
        thaninthon.ReportToPOS__c = '00001365';
        thaninthon.ReportToID__c = '00000598';
        thaninthon.ReportToEmail__c = 'test@thaioilgroup.com';
        thaninthon.ReportToUser__c = testUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        insert(thaninthon);
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            CGReporting.COI_Disclosure__c = 'Yes';
            insert(CGReporting);
            
            PageReference ExcelExportVFPage = Page.CG_Report_Excel;
			Test.setCurrentPage(ExcelExportVFPage);
            
            CG_ExcelController CGExcelExport = new CG_ExcelController();
            
            ApexPages.currentPage().getParameters().put('exportAll', 'false');
            ApexPages.currentPage().getParameters().put('reportName', 'COI');
            ApexPages.currentPage().getParameters().put('startDate', '2022-01-01');
            ApexPages.currentPage().getParameters().put('endDate', '2022-12-31');
            ApexPages.currentPage().getParameters().put('typeOfReport', 'all');
            ApexPages.currentPage().getParameters().put('status', 'Submitted');
            ApexPages.currentPage().getParameters().put('coiAnswer', 'Yes');
            ApexPages.currentPage().getParameters().put('company', 'TOP');
            ApexPages.currentPage().getParameters().put('function', 'EVPC');
            ApexPages.currentPage().getParameters().put('department', 'EVPO');
            ApexPages.currentPage().getParameters().put('section', 'SCSE');
            ApexPages.currentPage().getParameters().put('unit', 'ABCD');
            CGExcelExport.OnloadExcel();
            
			CG_ExcelController.CGGlobal_GetCompanies();
            CG_ExcelController.CGGlobal_GetFunctions(null);
            CG_ExcelController.CGGlobal_GetDepartments(null);
            CG_ExcelController.CGGlobal_GetSections(null);
            CG_ExcelController.CGGlobal_GetUnits(null);
        }
                    
        Test.stopTest();
        
    }
    
}