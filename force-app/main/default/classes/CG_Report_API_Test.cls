@isTest
public class CG_Report_API_Test {

    public static testMethod void GetCGReportAPITest() {
        
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
        thaninthon.DEPARTMENT__c = 'EVPO';
        thaninthon.SECTIONS__c = 'SCSE';
        thaninthon.UNITS__c = 'ABCD';
        insert(thaninthon);
        
        Test.startTest();  
            
        System.runAs(testUser) {
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
            CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'COI-2022-01-0001';
            CGReporting.User__c = testUser.Id;
            CGReporting.OwnerId = testUser.Id;
            CGReporting.Start_Duration__c = date.today().addDays(-1);
            CGReporting.End_Duration__c = date.today().addDays(1);
            CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIIncident);
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":null}}';
            CGReporting.COI_Detail__c = 'Test Detail';
            CGReporting.COI_Action__c = 'Test Action';
            CGReporting.COI_Disclosure__c = 'Yes';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            insert(CGReporting);
            CGReports.add(CGReporting);
            
            string GetSortByParamJSON = GetSortByParamJSON();
            string GetPageParamJSON = GetPageParamJSON();
            
            string CGManualReportDetailDTOJSON = '{ "CGManualReportDetailDTO" : { "id" : "123" } }';
            string startDateJSON = '{ "startDate" : "2021-12-31T17:00:00.000Z" }';
            string endDateJSON = '{ "endDate" : "2022-08-01T17:00:00.000Z"}';
            string sortByParamJSON = '{ "SortByParam" : { "sortBy" : "reportNumber", "ascending" : false } }';
            string pageParamJSON = '{ "PageParam" : { "pageSize" : 1, "pageNo" : 1 } }';
            string filterJSON = '{ "filter" : { "reportType" : "COINewEmployee", "startDate" : "2022-01-01T17:00:00.000Z", "endDate" : "2022-12-31T17:00:00.000Z" } }';
            
            CG_COI_Reporting.ReportCOISearchCriteria ReportCOISearchCriteria = new CG_COI_Reporting.ReportCOISearchCriteria();
            ReportCOISearchCriteria.startDate = DateTime.now().addDays(-3);
            ReportCOISearchCriteria.endDate = DateTime.now().addDays(3);
            ReportCOISearchCriteria.reportType = String.ValueOf(CG_Enum.COIReportType.COIIncident);
            ReportCOISearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            ReportCOISearchCriteria.coiAnswer = 'Yes';
            ReportCOISearchCriteria.function = 'EVPC';
            ReportCOISearchCriteria.department = 'EVPO';
            ReportCOISearchCriteria.section = 'SCSE';
            ReportCOISearchCriteria.unit = 'ABCD';
            
			CG_Report_API.GetReportCOISummaryCount(JSON.serialize(ReportCOISearchCriteria));
            CG_Report_API.ExportCOIAllExcel(JSON.serialize(ReportCOISearchCriteria));
            CG_Report_API.ExportCOITableExcel(JSON.serialize(ReportCOISearchCriteria));
            CG_Report_API.GetReportCOIAnswerChart(JSON.serialize(ReportCOISearchCriteria));
            CG_Report_API.GetReportCOITypeRadialChart(JSON.serialize(ReportCOISearchCriteria));
            CG_Report_API.GetReportCOIStatusSeriesChart(JSON.serialize(ReportCOISearchCriteria), 'Company');
            CG_Report_API.GetReportCOIInfoList(JSON.serialize(ReportCOISearchCriteria), GetSortByParamJSON, GetPageParamJSON);
            CG_Report_API.GetReportCOIStatistics(JSON.serialize(ReportCOISearchCriteria));
            
            //CG
            CG_Manual_Reporting.ReportCGSearchCriteria ReportCGSearchCriteria = new CG_Manual_Reporting.ReportCGSearchCriteria();
            ReportCGSearchCriteria.startDate = DateTime.now().addDays(-3);
            ReportCGSearchCriteria.endDate = DateTime.now().addDays(3);
            ReportCGSearchCriteria.reportType = 'CGNewEmployee';
            ReportCGSearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            ReportCGSearchCriteria.function = 'EVPC';
            ReportCGSearchCriteria.department = 'EVPO';
            ReportCGSearchCriteria.section = 'SCSE';
            ReportCGSearchCriteria.unit = 'ABCD';
            
            CG_Report_API.GetReportCGSummaryCount(JSON.serialize(ReportCGSearchCriteria));
            CG_Report_API.ExportCGAllExcel(JSON.serialize(ReportCGSearchCriteria));
            CG_Report_API.ExportCGTableExcel(JSON.serialize(ReportCGSearchCriteria));
            CG_Report_API.GetReportCGTypeRadialChart(JSON.serialize(ReportCGSearchCriteria));
            CG_Report_API.GetReportCGStatusSeriesChart(JSON.serialize(ReportCGSearchCriteria), 'Company');
            CG_Report_API.GetReportCGInfoList(JSON.serialize(ReportCGSearchCriteria), GetSortByParamJSON, GetPageParamJSON);
            CG_Report_API.GetReportCGStatistics(JSON.serialize(ReportCGSearchCriteria));
            
            //Gift
            CG_Gift_Reporting.ReportGiftSearchCriteria ReportGiftSearchCriteria = new CG_Gift_Reporting.ReportGiftSearchCriteria();
            ReportGiftSearchCriteria.startDate = DateTime.now().addDays(-3);
            ReportGiftSearchCriteria.endDate = DateTime.now().addDays(3);
            ReportGiftSearchCriteria.status = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
            ReportGiftSearchCriteria.function = 'EVPC';
            ReportGiftSearchCriteria.department = 'EVPO';
            ReportGiftSearchCriteria.section = 'SCSE';
           
            CG_Report_API.GetReportGiftSummaryCount(JSON.serialize(ReportGiftSearchCriteria));
            CG_Report_API.ExportGiftAllExcel(JSON.serialize(ReportGiftSearchCriteria));
            CG_Report_API.ExportGiftTableExcel(JSON.serialize(ReportGiftSearchCriteria));
            CG_Report_API.GetReportGiftStatusChart(JSON.serialize(ReportGiftSearchCriteria));
            CG_Report_API.GetReportGiftStatusSeriesChart(JSON.serialize(ReportGiftSearchCriteria), 'Company');
            CG_Report_API.GetReportGiftInfoList(JSON.serialize(ReportGiftSearchCriteria), GetSortByParamJSON, GetPageParamJSON);
            CG_Report_API.GetReportGiftStatistics(JSON.serialize(ReportGiftSearchCriteria));
            
            CG_Report_API.CGGlobal_GetCompanies();
            CG_Report_API.CGGlobal_GetFunctions('test');
            CG_Report_API.CGGlobal_GetDepartments('test');
            CG_Report_API.CGGlobal_GetSections('test');
            CG_Report_API.CGGlobal_GetUnits('test');
            
            
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