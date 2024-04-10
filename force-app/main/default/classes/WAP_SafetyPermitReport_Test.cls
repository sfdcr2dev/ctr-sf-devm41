@isTest
public with sharing class WAP_SafetyPermitReport_Test {

    public static testMethod void GetWapSafetyPermitReportAllFilter() {
        
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
            
            PISUsers__c thaninthon = new PISUsers__c();
            thaninthon.Active__c = true;
            thaninthon.MAINPOSITION__c = true;
            thaninthon.EMPLOYEEID__c = '08000288';
            thaninthon.Name = 'Test';
            thaninthon.LEVEL__c = 'Junior';
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

            //SortByParam
            WAP_Global.SortByParam SortByParam = new WAP_Global.SortByParam();
            SortByParam.sortBy = 'no';
            SortByParam.ascending = true;
            
            //PageParam
            WAP_Global.PageParam PageParam = new WAP_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            
            WAP_SafetyPermitReport.SearchFilter filter = new WAP_SafetyPermitReport.SearchFilter();
            filter.year = '2022';
            filter.startDate = date.today().addDays(-1);
            filter.endDate = date.today().addDays(1);
            
            WAP_SafetyPermitReport.GetSummaryPermitGraph(filter);
            WAP_SafetyPermitReport.GetSummaryPermitTableCount(filter, SortByParam, PageParam);
            WAP_SafetyPermitReport.GetSummaryPermitTable(filter, SortByParam, PageParam);
            WAP_SafetyPermitReport.ExportExcel(filter);
            WAP_SafetyPermitReport.AllAreas(filter);
            
            SortByParam = new WAP_Global.SortByParam();
            SortByParam.sortBy = 'workingArea';
            SortByParam.ascending = true;
            WAP_SafetyPermitReport.GetSummaryPermitTable(filter, SortByParam, PageParam);
            WAP_SafetyPermitReport.GetSummaryPermitTableCount(filter, SortByParam, PageParam);
            
            SortByParam = new WAP_Global.SortByParam();
            SortByParam.sortBy = 'startDate';
            SortByParam.ascending = true;
            WAP_SafetyPermitReport.GetSummaryPermitTable(filter, SortByParam, PageParam);
            WAP_SafetyPermitReport.GetSummaryPermitTableCount(filter, SortByParam, PageParam);
            
            SortByParam = new WAP_Global.SortByParam();
            SortByParam.sortBy = 'endDate';
            SortByParam.ascending = true;
            WAP_SafetyPermitReport.GetSummaryPermitTable(filter, SortByParam, PageParam);
            WAP_SafetyPermitReport.GetSummaryPermitTableCount(filter, SortByParam, PageParam);
            
            SortByParam = new WAP_Global.SortByParam();
            SortByParam.sortBy = 'firstExtendDate';
            SortByParam.ascending = true;
            WAP_SafetyPermitReport.GetSummaryPermitTable(filter, SortByParam, PageParam);
            WAP_SafetyPermitReport.GetSummaryPermitTableCount(filter, SortByParam, PageParam);
            
            SortByParam = new WAP_Global.SortByParam();
            SortByParam.sortBy = 'secondExtendDate';
            SortByParam.ascending = true;
            WAP_SafetyPermitReport.GetSummaryPermitTable(filter, SortByParam, PageParam);
            WAP_SafetyPermitReport.GetSummaryPermitTableCount(filter, SortByParam, PageParam);
            
            SortByParam = new WAP_Global.SortByParam();
            SortByParam.sortBy = 'thirdExtendDate';
            SortByParam.ascending = true;
            WAP_SafetyPermitReport.GetSummaryPermitTable(filter, SortByParam, PageParam);
            WAP_SafetyPermitReport.GetSummaryPermitTableCount(filter, SortByParam, PageParam);
        }
        
        Test.stopTest();
    }
    
}