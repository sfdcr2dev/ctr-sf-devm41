@isTest
public class CG_Reporting_History_API_Test {

    public static testMethod void GetCGReportHistoryAPITest() {
        
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
            LocaleSidKey = 'en_US',
            Employee_Id__c = '0000001'
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
            
            CGReports.add(CGReporting);
            
            string COIReportDetailDTOJSON = '{ "COIReportDetailDTO" : { "id" : "123" } }';
            string startDateJSON = ' "2021-12-31T17:00:00.000Z" ';
            string endDateJSON = ' "2022-08-01T17:00:00.000Z" ';
            string sortByParamJSON = '{ "SortByParam" : { "sortBy" : "reportNumber", "ascending" : false } }';
            string pageParamJSON = '{ "PageParam" : { "pageSize" : 1, "pageNo" : 1 } }';
            string filterJSON = '{ "filter" : { "reportType" : "COINewEmployee" } }';
            
			CG_Reporting_History_API.GetCOIHistoryCount(startDateJSON, endDateJSON);
            CG_Reporting_History_API.GetCOIHistoryList(startDateJSON, endDateJSON, sortByParamJSON, pageParamJSON);
            CG_Reporting_History_API.GetCGHistoryCount(startDateJSON, endDateJSON);
            CG_Reporting_History_API.GetCGHistoryList(startDateJSON, endDateJSON, sortByParamJSON, pageParamJSON);
            CG_Reporting_History_API.GetCGReportWorkflow(CGReporting.Id);
            CG_Reporting_History_API.GetGiftHistoryCount(startDateJSON, endDateJSON);
            CG_Reporting_History_API.GetGiftHistoryList(startDateJSON, endDateJSON, sortByParamJSON, pageParamJSON);
            CG_Reporting_History_API.GetGiftReportWorkflow(CGReporting.Id);
            
        }
                    
        Test.stopTest();
        
    }
    
}