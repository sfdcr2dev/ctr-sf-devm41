@isTest
public class CG_Gift_Reporting_API_Test {

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
            CGReporting.Running_No__c = 'GIFT-2022-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = 'GiftRegistration';
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            CGReporting.Submit_Within_Date__c = date.today();
            CGReporting.Gift_Item__c = '[{"submittedDate":"2022-10-06T00:00:00.000Z","receivedFrom":"Test","name":"Item","giftValue":10000,"giftStatus":null,"giftDonatedComment":null}]';
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            CGReporting.GLGC_Action_Date__c = date.today();
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
            
            req.requestUri = '/services/apexrest/CG_Gift_Reporting_API/doPost/AdminCancelReport';       
            req.httpMethod = 'POST';
            string postData = '{\"reportId\" : \"' + CGReporting.Id + '\"}';
            
            String JsonMsg = JSON.serialize(postData);
            req.requestBody = Blob.valueof(JsonMsg);
            RestContext.request = req; 
            RestContext.response= res;
            
            CG_Gift_Reporting_API.doPost(postData);
            
            Test.stopTest();
        }
        
    }
    
    public static testMethod void APITest() {
        
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
            
            CG_Reporting__c CGReporting = new CG_Reporting__c();
            CGReporting.Running_No__c = 'GIFT-2022-0001';
            CGReporting.OwnerId = testUser.Id;
            CGReporting.User__c = testUser.Id;
            CGReporting.Start_Duration__c = date.today();
            CGReporting.End_Duration__c = date.today();
            CGReporting.Type_of_Report__c = 'GiftRegistration';
            CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
            CGReporting.GenerateFromBatch__c = true;
            CGReporting.Status_JSON__c = '{"status":{"value":"WaitingForSubmit","key":"WaitingForSubmit","enumName":"WaitingForSubmit"},"reportId":null,"historyWorkflows":null,"currentWorkflow":{"submittedDate":null,"createdDate":"2022-07-07T00:00:00.000Z","approvers":[{"status":{"value":"Submitted","key":"Submitted","enumName":"ApproverStatus"},"role":{"value":"Employee","key":"Employee","enumName":"ApproverRole"},"isShow":null,"isCurrent":false,"comment":null,"approver":{"id":"' + testUser.Id +' ","fullName":"'+ testUser.LastName +'","email":"'+ testUser.Email +'"},"actionDate":"2022-09-20T02:58:06.993Z"}]}}';
            CGReporting.Supervisor_Approver_Status__c = 'Acknowledged';
            CGReporting.Submit_Within_Date__c = date.today();
            CGReporting.Gift_Item__c = '[{"submittedDate":"2022-10-06T00:00:00.000Z","receivedFrom":"Test","name":"Item","giftValue":10000,"giftStatus":null,"giftDonatedComment":null}]';
            CGReporting.Owner_Function__c = 'EVPC';
            CGReporting.Owner_Department__c = 'EVPO';
            CGReporting.Owner_Section__c = 'SCSE';
            CGReporting.Owner_Unit__c = 'ABCD';
            CGReporting.GLGC_Action_Date__c = date.today();
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
            
            string GetSortByParamJSON = GetSortByParamJSON();
            string GetPageParamJSON = GetPageParamJSON();
            string GetGiftReportDetailJSON = GetGiftReportDetailJSON(CGReporting);
            
			CG_Gift_Reporting_API.CheckAccessPrivilege(CGReporting.Id);
			CG_Gift_Reporting_API.GetGiftReportCount();
			CG_Gift_Reporting_API.GetGiftReports(GetSortByParamJSON, GetPageParamJSON);
			CG_Gift_Reporting_API.GetReportDetail(CGReporting.Id);
            CG_Gift_Reporting_API.SaveAsDraftReport(GetGiftReportDetailJSON);
            CG_Gift_Reporting_API.SubmitReport(GetGiftReportDetailJSON);
            CG_Gift_Reporting_API.GetReportWorkflow(CGReporting.Id);
            //CG_Gift_Reporting_API.ApproveReport(CGReporting.Id);
            //CG_Gift_Reporting_API.RejectReport(CGReporting.Id);
            CG_Gift_Reporting_API.MassApproveReports(CGReporting.Id);
            CG_Gift_Reporting_API.GetAdminGiftReportListCount(testUser.name, testUser.Employee_Id__c, null, 'EVPC', 'EVPO', 'SCSE', 'ABCD');
            CG_Gift_Reporting_API.GetAdminGiftReportList(testUser.name, testUser.Employee_Id__c, null, 'EVPC', 'EVPO', 'SCSE', 'ABCD', GetSortByParamJSON, GetPageParamJSON);
            CG_Gift_Reporting_API.AdminResendReport(CGReporting.Id);
            CG_Gift_Reporting_API.AdminCancelReport(CGReporting.Id);
        }
        
    }
    
    public static string GetGiftReportDetailJSON(CG_Reporting__c report) {
        
        CG_DTO.GiftReportDetailDTO mockupGiftDetail = new CG_DTO.GiftReportDetailDTO();
        mockupGiftDetail.id = report.Id;
        mockupGiftDetail.reportType = new CG_Global.EnumValue('GiftRegistration');
        mockupGiftDetail.reportType.key = 'GiftRegistration';
        mockupGiftDetail.reportType.value = 'Gift Registration';
        mockupGiftDetail.reportNumber = 'GIFT-2022-01-0011';
        mockupGiftDetail.supervisorName = 'Gilbert Gottfried';
        mockupGiftDetail.status = new CG_Global.EnumValue('ReportStatus');
        mockupGiftDetail.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
        mockupGiftDetail.status.value = 'Waiting for Submit';
        mockupGiftDetail.lastUpdated = system.today();
        mockupGiftDetail.submittedWithinDate = system.today();
        mockupGiftDetail.submittedDate = null;
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
        mockupGiftDetail.currentWorkflow = workflow;
        mockupGiftDetail.reportedByTH = 'นพพล พิลึกเรืองเดช';
        mockupGiftDetail.reportedByEN = 'Noppol Pilukruangdet';
        mockupGiftDetail.reportedByPositionTH = 'Developer';
        mockupGiftDetail.reportedByPositionEN = 'นักพัฒนา';
        mockupGiftDetail.reportedByCompanyTH = 'ซอฟต์เอฟเวอร์';
        mockupGiftDetail.reportedByCompanyEN = 'Softever';
        mockupGiftDetail.reportedDate = system.today();
        mockupGiftDetail.canEdit = true;
        mockupGiftDetail.canSubmit = true;
        
        List<CG_DTO.GiftItemDTO> GiftItems = new List<CG_DTO.GiftItemDTO>();
        CG_DTO.GiftItemDTO GiftItem = new CG_DTO.GiftItemDTO();
        GiftItem.name = 'Test';
        GiftItem.receivedFrom = 'Test';
        GiftItem.giftValue = 1000;
        GiftItem.submittedDate = date.today();
        GiftItem.giftStatus = new CG_Global.EnumValue('GiftStatus');
        GiftItem.giftStatus.key = CG_Enum.GiftStatus.InStock.name();
        GiftItem.giftStatus.value = 'In Stock';
		GiftItems.add(GiftItem);
        
        GiftItem = new CG_DTO.GiftItemDTO();
        GiftItem.name = 'Test';
        GiftItem.receivedFrom = 'Test';
        GiftItem.giftValue = 1000;
        GiftItem.submittedDate = date.today();
        GiftItem.giftStatus = new CG_Global.EnumValue('GiftStatus');
        GiftItem.giftStatus.key = CG_Enum.GiftStatus.Donated.name();
        GiftItem.giftStatus.value = 'Donated';
		GiftItems.add(GiftItem);
        
        mockupGiftDetail.giftItems = GiftItems;
        
        return JSON.serialize(mockupGiftDetail);
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