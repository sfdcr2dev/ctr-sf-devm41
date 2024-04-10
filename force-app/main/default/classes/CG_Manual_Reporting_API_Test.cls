@isTest
public class CG_Manual_Reporting_API_Test {

    public static testMethod void DoPostTest() {
        
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
        thaninthon.LineManagerUser__c = testUser.Id;
        thaninthon.FUNCTION__c = 'EVPC';
        insert(thaninthon);
        
        InsertUserToGroup(testUser.Id);
        
        System.runAs(testUser) {
            
        	Test.startTest();  
        
            CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            insert(CGReporting);
            
            //Add Company
            SD_Company__c Company = new SD_Company__c();
            Company.name = 'TOP';
            Company.Company_Full_Name__c = 'TOP';
            Company.Order__c = 0;
            insert(Company);
            
            //CG Config
            CG_Config__c CGConfig = new CG_Config__c();
            CGConfig.Year__c = '2022';
            CGConfig.COI_New_User_Running_No__c = '0';
            CGConfig.COI_Incident_Running_No__c = '0';
            CGConfig.COI_Annual_Running_No__c = '0';
            CGConfig.CG_New_User_Running_No__c = '0';
            CGConfig.CG_Manual_Running_No__c = '0';
            CGConfig.CG_Annual_Running_No__c = '0';
            CGConfig.Gift_Running_No__c = '0';
            insert(CGConfig);
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            
            req.requestUri = '/services/apexrest/CG_Manual_Reporting_API/doPost/CGAcknowledgeForm';       
            req.httpMethod = 'POST';
            string postData = '{\"reportId\" : \"' + CGReporting.Id + '\"}';
            
            String JsonMsg = JSON.serialize(postData);
            req.requestBody = Blob.valueof(JsonMsg);
            RestContext.request = req; 
            RestContext.response= res;
            
            CG_Manual_Reporting_API.doPost(postData);
            
            Test.stopTest();
        }
        
    }
    
    public static testMethod void GetCGManualReportingAPITest() {
       
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
        thaninthon.LineManagerUser__c = testUser.Id;
        thaninthon.FUNCTION__c = 'EVPC';
        insert(thaninthon);
        
        InsertUserToGroup(testUser.Id);
        
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        	CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COINewEmployee);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            insert(CGReporting);
            
            CGReports.add(CGReporting);
            
            string CGManualReportDetailDTOJSON = '{ "CGManualReportDetailDTO" : { "id" : "123" } }';
            string startDateJSON = '{ "startDate" : "2021-12-31T17:00:00.000Z" }';
            string endDateJSON = '{ "endDate" : "2022-08-01T17:00:00.000Z"}';
            string sortByParamJSON = '{ "SortByParam" : { "sortBy" : "reportNumber", "ascending" : false } }';
            string pageParamJSON = '{ "PageParam" : { "pageSize" : 1, "pageNo" : 1 } }';
            string filterJSON = '{ "filter" : { "reportType" : "COINewEmployee" } }';
            
            string GetSortByParamJSON = GetSortByParamJSON();
            string GetPageParamJSON = GetPageParamJSON();
            //string GetGiftReportDetailJSON = GetGiftReportDetailJSON(CGReporting);
            
            CG_Manual_Reporting_API.CheckAccessPrivilege(CGReporting.Id);
			CG_Manual_Reporting_API.GetNewCGManualReportCount();
			//CG_Manual_Reporting_API.GetNewCGManualReports(GetSortByParamJSON, GetPageParamJSON);
            CG_Manual_Reporting_API.GetNewEmployeeReport();
            CG_Manual_Reporting_API.GetAnnualReport();
            CG_Manual_Reporting_API.GetReportDetail(CGReporting.Id);
            CG_Manual_Reporting_API.SubmitReport(CGManualReportDetailDTOJSON);
            CG_Manual_Reporting_API.GetAdminCGReportListCount(testUser.name, testUser.Employee_Id__c, null, 'EVPC', 'EVPO', 'SCSE', 'ABCD');
            CG_Manual_Reporting_API.GetAdminCGReportList(testUser.name, testUser.Employee_Id__c, null, 'EVPC', 'EVPO', 'SCSE', 'ABCD', GetSortByParamJSON, GetPageParamJSON);
            CG_Manual_Reporting_API.AdminResendReport(CGReporting.Id);
            CG_Manual_Reporting_API.AdminCancelReport(CGReporting.Id);
            //CG_Manual_Reporting_API.ManualFiles();
        }
                    
        Test.stopTest();
        
        
    }
    
    public static string GetPageParamJSON() {
        
    	CG_Global.PageParam PageParam = new CG_Global.PageParam();
        PageParam.pageSize = 1;
        PageParam.pageNo = 1;
        return JSON.serialize(PageParam);
    }
    
    public static string GetSortByParamJSON() {
        
    	CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
        SortByParam.sortBy = 'reportNumber';
        SortByParam.ascending = false;
        return JSON.serialize(SortByParam);
    }
    
    @future
    private static void InsertUserToGroup(string userId)
    {
        //CG Admin
        Group approverAdminGroup = [select id from Group where developername = 'CG_Admin'];
        GroupMember memberAdmin = new GroupMember();
        memberAdmin.UserOrGroupId = userId;
        memberAdmin.GroupId = approverAdminGroup.Id;
        insert(memberAdmin);
        
        //CG GLVP
        Group approverGLVPGroup = [select id from Group where developername = 'CG_GLVP'];
        GroupMember memberGLVP = new GroupMember();
        memberGLVP.UserOrGroupId = userId;
        memberGLVP.GroupId = approverGLVPGroup.Id;
        insert(memberGLVP);
        
        //CG GLGC
        Group approverGLGCGroup = [select id from Group where developername = 'CG_GLGC'];
        GroupMember memberGLGC = new GroupMember();
        memberGLGC.UserOrGroupId = userId;
        memberGLGC.GroupId = approverGLGCGroup.Id;
        insert(memberGLGC);
    }
    
    
}