@isTest
public with sharing class WAP_SafetyPermitExcelController_Test {

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
            
        System.runAs(testUser) {
            
            Safety_Permit__c SP = new Safety_Permit__c();
            SP.Name = 'Test';
            SP.Work_Detail__c = 'Test';
            SP.Plant_Section__c = 'AAA';
            SP.Permit_to_Work_Date__c = date.today();
            SP.Expired_Date_1__c = date.today().addDays(1);
            SP.Expired_Date_2__c = date.today().addDays(2);
            SP.Expired_Date_3__c = date.today().addDays(3);
            SP.Extended_From_Date_1__c = date.today().addDays(1);
            SP.Extended_From_Date_2__c = date.today().addDays(2);
            SP.Extended_From_Date_3__c = date.today().addDays(3);
            insert(SP);
            
            PageReference ExcelExportVFPage = Page.WAP_SafetyPermitReport_Excel;
			Test.setCurrentPage(ExcelExportVFPage);
            
            WAP_SafetyPermitReportExcelController WAPExcelExport = new WAP_SafetyPermitReportExcelController();
            
            ApexPages.currentPage().getParameters().put('year', '2022');
            ApexPages.currentPage().getParameters().put('area', 'AAA');
            ApexPages.currentPage().getParameters().put('startDate', '2022-11-01');
            ApexPages.currentPage().getParameters().put('endDate', '2022-11-30');
            WAPExcelExport.OnloadExcel();

        }
                    
        Test.stopTest();
        
    }
    
}