@isTest
public class CG_COI_Reporting_API_Test {

    public static testMethod void GetCGCOIReportingAPITest() {
        
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
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            CGReporting.COI_Disclosure__c = 'Yes';
            insert(CGReporting);
            
            CGReports.add(CGReporting);
            
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
            
            
            //string COIReportDetailDTOJSON = '{ "COIReportDetailDTO" : { "id" : "123", "disclosureReport":{"value":"Yes","key":"Yes","enumName":"Yes"} }}';
            string startDateJSON = '{ "startDate" : "2021-12-31T17:00:00.000Z" }';
            string endDateJSON = '{ "endDate" : "2022-08-01T17:00:00.000Z"}';
            string filterJSON = '{ "filter" : { "reportType" : "COINewEmployee" } }';

            string GetCOIReportDetailJSON = GetCOIReportDetailJSON();
            string GetSortByParamJSON = GetSortByParamJSON();
            string GetPageParamJSON = GetPageParamJSON();
            
            CG_COI_Reporting_API CGCOIReportingAPI = new CG_COI_Reporting_API();
			CG_COI_Reporting_API.GetIncidentReportCount();
			CG_COI_Reporting_API.GetIncidentReports(GetSortByParamJSON, GetPageParamJSON);
            CG_COI_Reporting_API.GetNewEmployeeReport();
            CG_COI_Reporting_API.GetAnnualReport();
            CG_COI_Reporting_API.GetReportDetail(CGReporting.Id);
            CG_COI_Reporting_API.SaveAsDraftReport(GetCOIReportDetailJSON);
            CG_COI_Reporting_API.SubmitReport(GetCOIReportDetailJSON);
            CG_COI_Reporting_API.GetReportWorkflow(CGReporting.Id);
            //CG_COI_Reporting_API.GetCOIHistoryCount(startDateJSON , endDateJSON);
            //CG_COI_Reporting_API.GetCOIHistoryList(startDateJSON, endDateJSON, sortByParamJSON, pageParamJSON);
            CG_COI_Reporting_API.GetCOIMassAcknowledgeCount();
            CG_COI_Reporting_API.GetCOIMassAcknowledgeList('Yes', GetSortByParamJSON, GetPageParamJSON);
            CG_COI_Reporting_API.ApproveReport(GetCOIReportDetailJSON);
            CG_COI_Reporting_API.RejectReport(GetCOIReportDetailJSON);
            CG_COI_Reporting_API.MassApproveReports(CGReporting.Id);
            CG_COI_Reporting_API.MassRejectReports(CGReporting.Id, '');
            CG_COI_Reporting_API.GetAdminCOIReportListCount(testUser.name, testUser.Employee_Id__c, null, 'EVPC', 'EVPO', 'SCSE', 'ABCD');
            CG_COI_Reporting_API.GetAdminCOIReportList(testUser.name, testUser.Employee_Id__c, null, 'EVPC', 'EVPO', 'SCSE', 'ABCD', GetSortByParamJSON, GetPageParamJSON);
            CG_COI_Reporting_API.AdminResendReport(CGReporting.Id);
            CG_COI_Reporting_API.AdminCancelReport(CGReporting.Id);
            CG_COI_Reporting_API.GetReportCOISummaryCount(filterJSON);
            CG_COI_Reporting_API.ExportAllExcel(filterJSON);
            CG_COI_Reporting_API.ExportTableExcel(filterJSON);
            CG_COI_Reporting_API.GetReportCOIAnswerChart(filterJSON);
            CG_COI_Reporting_API.GetReportCOITypeRadialChart(filterJSON);
            //CG_COI_Reporting_API.GetReportCOIStatusSeriesChart(filterJSON, 'Company');
            //CG_COI_Reporting_API.GetReportCOIInfoList(filterJSON, sortByParamJSON, pageParamJSON);
            //CG_COI_Reporting_API.GetReportCOIStatistics(filterJSON);
            CG_COI_Reporting_API.CGGlobal_GetCompanies();
            CG_COI_Reporting_API.CGGlobal_GetFunctions('test');
            CG_COI_Reporting_API.CGGlobal_GetDepartments('test');
            CG_COI_Reporting_API.CGGlobal_GetSections('test');
            CG_COI_Reporting_API.CGGlobal_GetUnits('test');
            
            
            CG_COI_Reporting_API.DeleteIncidentReport(CGReporting.Id);
        }
                    
        Test.stopTest();
        
    }
    
    /* public static testMethod void GetTest() {
        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestUri = '/services/apexrest/CG_COI_Reporting_API/doPost/SaveAsDraftReport';       
        req.httpMethod = 'POST';
        string postData = '{\"report\" : \"{ \\\"id\\\" : null, ' +
            				'\\\"disclosureReport\\\":{\\\"value\\\":\\\"Yes\\\",\\\"key\\\":\\\"Yes\\\",\\\"enumName\\\":\\\"Yes\\\"} }\"}';
        
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;
        
        CG_COI_Reporting_API.doPost(postData);
        
        Test.stopTest();
        
    } */
    
    public static string GetCOIReportDetailJSON() {
        
        CG_DTO.COIReportDetailDTO COIReportDetailDTO = new CG_DTO.COIReportDetailDTO();
        COIReportDetailDTO.reportType = new CG_Global.EnumValue('COIReportType');
        COIReportDetailDTO.reportType.key = CG_Enum.COIReportType.COINewEmployee.name();
        COIReportDetailDTO.reportType.value = 'New Employee';
        COIReportDetailDTO.reportNumber = 'COI-2022-01-0011';
        COIReportDetailDTO.supervisorName = 'Gilbert Gottfried';
        COIReportDetailDTO.status = new CG_Global.EnumValue('ReportStatus');
        COIReportDetailDTO.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
        COIReportDetailDTO.status.value = 'Waiting for Submit';
        COIReportDetailDTO.startDuration = system.today();
        COIReportDetailDTO.endDuration = system.today();
        COIReportDetailDTO.submittedDate = null;
        CG_DTO.WorkflowDTO workflow = new CG_DTO.WorkflowDTO();
        workflow.createdDate = system.today();
        workflow.approvers = new List<CG_DTO.WorkflowApproverDTO>();
        CG_DTO.WorkflowApproverDTO approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.Employee.name();
        approver.role.value = CG_Enum.ApproverRole.Employee.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingForSubmit.name();
        approver.status.value = 'Waiting for Submit';
        approver.isCurrent = true;
        workflow.approvers.add(approver);
        approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.Supervisor.name();
        approver.role.value = CG_Enum.ApproverRole.Supervisor.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingSupervisor.name();
        approver.status.value = 'Waiting Supervisor';
        workflow.approvers.add(approver);
        approver = new CG_DTO.WorkflowApproverDTO();
        approver.role = new CG_Global.EnumValue('ApproverRole');
        approver.role.key = CG_Enum.ApproverRole.GLVP.name();
        approver.role.value = CG_Enum.ApproverRole.GLVP.name();
        approver.status = new CG_Global.EnumValue('ApproverStatus');
        approver.status.key = CG_Enum.ApproverStatus.WaitingGLVP.name();
        approver.status.value = 'Waiting GLVP';
        workflow.approvers.add(approver);
        COIReportDetailDTO.currentWorkflow = workflow;
        COIReportDetailDTO.agree = true;
        COIReportDetailDTO.disclosureReport = new CG_Global.EnumValue('COIDisclosure');
        COIReportDetailDTO.disclosureReport.key = CG_Enum.COIDisclosure.Yes.name();
        COIReportDetailDTO.disclosureReport.value = CG_Enum.COIDisclosure.Yes.name();
        List<CG_DTO.CompanyDTO> companies = CG_Global.GetCompanies();
        COIReportDetailDTO.transactionCompany = companies[0];
        COIReportDetailDTO.transactionByMe = false;
        COIReportDetailDTO.transactionByOther = true;
        COIReportDetailDTO.transactionByOtherName = 'Noppol Pilukruangdet';
        COIReportDetailDTO.transactionByOtherRelation = true;
        COIReportDetailDTO.transactionByOtherRelationName = 'Wannarat Kanmud';
        COIReportDetailDTO.transactionByOtherRelationship = 'Wifu';
        COIReportDetailDTO.coiDetail = 'Lorem ipsum dolor sit amet, consectetur';
        COIReportDetailDTO.coiAction = 'Action Lorem ipsum dolor sit amet, consectetur';
        COIReportDetailDTO.reportedByTH = 'นพพล พิลึกเรืองเดช';
        COIReportDetailDTO.reportedByEN = 'Noppol Pilukruangdet';
        COIReportDetailDTO.reportedByPositionTH = 'Developer';
        COIReportDetailDTO.reportedByPositionEN = 'นักพัฒนา';
        COIReportDetailDTO.reportedByCompanyTH = 'ซอฟต์เอฟเวอร์';
        COIReportDetailDTO.reportedByCompanyEN = 'Softever';
        COIReportDetailDTO.reportedDate = system.today();
        COIReportDetailDTO.canEdit = true;
        COIReportDetailDTO.canSubmit = true;
        
        return JSON.serialize(COIReportDetailDTO);
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