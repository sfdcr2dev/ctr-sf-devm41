/* Author Softever */
public with sharing class CG_Gift_Reporting  {
	    
    //mockup data
    private static List<CG_DTO.GiftReportListDTO> GiftListDTOs;
    private static CG_DTO.GiftReportDetailDTO GiftDetail;
    private static List<CG_DTO.GiftMassAcknowledgeListDTO> MassAcknowledgeList;
    private static CG_DTO.GiftMassAcknowledgeCountDTO MassAcknowledgeCount;
    private static List<CG_DTO.AdminGiftReportListDTO> AdminGiftReportListDTOs;
    private static CG_DTO.AdminGiftReportListCountDTO AdminGiftReportListCount;
    
    static {
    }

    //Check whether user has privilege to access particular record or not
    @RemoteAction
    public static boolean CheckAccessPrivilege(string reportId) {
        boolean canAccess = CG_PrivilegeHandler.checkAccessPrivilege(reportId);
        return canAccess;
    }
    
    //Count all incident (for paging purpose)
    @RemoteAction
    public static Integer GetGiftReportCount(){
        integer giftCount = 0;
        
        string userId = CG_PrivilegeHandler.getUserId();
        
        Date SD = Date.newInstance( date.today().year(), 1, 1 );
        Date ED = Date.newInstance( date.today().year(), 12, 31 );
        
        List<string> GiftTypes = new List<string> { 'GiftRegistration' };
        //List<string> Statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Success) };
            
        string query = 'select id from CG_Reporting__c where OwnerId =: userId AND Type_Of_Report__c IN: GiftTypes AND ' +
            			'Submit_Within_Date__c >=: SD AND Submit_Within_Date__c <=: ED';
        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        CGReports = database.query(query);
        
        if(CGReports.size() > 0) {
            giftCount = CGReports.size();
        }
        
        return giftCount;
    }

    //Query Gift Table Data of logined user including paging and sorting
    @RemoteAction
    public static List<CG_DTO.GiftReportListDTO> GetGiftReports(
        //reportNumber, supervisorName, status, lastUpdated
        CG_Global.SortByParam sortByParam, 
        CG_Global.PageParam pageParam) {
            
        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
        GiftListDTOs = new List<CG_DTO.GiftReportListDTO>();
        string userId = CG_PrivilegeHandler.getUserId();
        string userProfile = CG_PrivilegeHandler.getUserProfile();
            
        Date SD = Date.newInstance( date.today().year(), 1, 1 );
        Date ED = Date.newInstance( date.today().year(), 12, 31 );
        
        List<CG_DTO.GiftReportListDTO> results = new List<CG_DTO.GiftReportListDTO>();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> GiftTypes = new List<string> { 'GiftRegistration' };
        //List<string> Statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Success) };
        
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c , Status__c, ' +
                            'Status_JSON__c, OwnerId, LastModifiedDate from CG_Reporting__c ' +
                            'where OwnerId =: userId AND Type_Of_Report__c IN: GiftTypes AND Submit_Within_Date__c >=: SD AND Submit_Within_Date__c <=: ED';
            
            if(sortByParam.sortBy == 'reportNumber') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c desc');
                }
            }
            else if(sortByParam.sortBy == 'supervisorName') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Supervisor_Name__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Supervisor_Name__c desc');
                }
            }
            else if(sortByParam.sortBy == 'status') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c desc');
                }
            }
            else if(sortByParam.sortBy == 'lastUpdated') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by LastModifiedDate asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by LastModifiedDate desc');
                }
            }
            else {
                CGReports = database.query(query + ' order by Running_No__c desc');
            }    
            
            if(CGReports.size() > 0) {
                
                for(CG_Reporting__c CGReporting : CGReports) {
                    CG_DTO.GiftReportListDTO CGReportDTO = new CG_DTO.GiftReportListDTO();
                    CGReportDTO = assignToGiftReportListDTO(userProfile, CGReporting);
                    GiftListDTOs.add(CGReportDTO);
                    
                }
                
            }
            
        Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
        integer totalSize = GiftListDTOs.size() - startIndex;
            
        for (Integer i = 0; i < pageParam.pageSize; i++ ) {
            if (i < totalSize){
                results.add(GiftListDTOs[startIndex + i]);
            }else{
                break;
            }
        }
        return results;
    }

    //Get Gift Report Detail using report id
    @RemoteAction
    public static CG_DTO.GiftReportDetailDTO GetReportDetail(string reportId){
        
        string userId = CG_PrivilegeHandler.getUserId();
        GiftDetail = new CG_DTO.GiftReportDetailDTO();
        
        if(reportId == null) {
            
            GiftDetail.reportType = new CG_Global.EnumValue('GiftRegistration');
            GiftDetail.reportType.key = 'GiftRegistration';
            GiftDetail.reportType.value = 'Gift Registration';
            
            PISUsers__c PISUser = CG_Global.assignToPISUser(userId);
            
            GiftDetail.supervisorName = PISUser.EN_LineManager__c;
            GiftDetail.status = new CG_Global.EnumValue('ReportStatus');
            GiftDetail.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            GiftDetail.status.value = 'Waiting for Submit';
            GiftDetail.submittedDate = null;
            GiftDetail.lastUpdated = null;
            GiftDetail.submittedWithinDate = null;
            
            GiftDetail.giftItems = new List<CG_DTO.GiftItemDTO>();
            /* CG_DTO.GiftItemDTO giftItem = new CG_DTO.GiftItemDTO();
            giftItem.name = '';
            giftItem.receivedFrom = '';
            giftItem.giftValue = 0;
            giftItem.submittedDate = system.today();
            GiftDetail.giftItems.add(giftItem); */
            
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
            approver.isShow = true;
            workflow.approvers.add(approver);
            approver = new CG_DTO.WorkflowApproverDTO();
            approver.role = new CG_Global.EnumValue('ApproverRole');
            approver.role.key = CG_Enum.ApproverRole.Supervisor.name();
            approver.role.value = CG_Enum.ApproverRole.Supervisor.name();
            approver.status = new CG_Global.EnumValue('ApproverStatus');
            approver.status.key = CG_Enum.ApproverStatus.WaitingSupervisor.name();
            approver.status.value = 'Waiting Supervisor';
            approver.isCurrent = false;
            approver.isShow = true;
            workflow.approvers.add(approver);
            approver = new CG_DTO.WorkflowApproverDTO();
            approver.role = new CG_Global.EnumValue('ApproverRole');
            approver.role.key = CG_Enum.ApproverRole.GLGC.name();
            approver.role.value = CG_Enum.ApproverRole.GLGC.name();
            approver.status = new CG_Global.EnumValue('ApproverStatus');
            approver.status.key = CG_Enum.ApproverStatus.WaitingGLGC.name();
            approver.status.value = 'Waiting GLGC';
            approver.isShow = false;
            approver.isCurrent = false;
            workflow.approvers.add(approver);
            approver = new CG_DTO.WorkflowApproverDTO();
            approver.role = new CG_Global.EnumValue('ApproverRole');
            approver.role.key = CG_Enum.ApproverRole.GLVP.name();
            approver.role.value = CG_Enum.ApproverRole.GLVP.name();
            approver.status = new CG_Global.EnumValue('ApproverStatus');
            approver.status.key = CG_Enum.ApproverStatus.WaitingGLVP.name();
            approver.status.value = 'Waiting GLVP';
            approver.isCurrent = false;
            approver.isShow = false;
            workflow.approvers.add(approver);
            GiftDetail.currentWorkflow = workflow;
            
            GiftDetail.reportedByTH = PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
            GiftDetail.reportedByEN = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
            GiftDetail.reportedByPositionTH = PISUser.OBJENFULLNAME__c;
            GiftDetail.reportedByPositionEN = PISUser.OBJTHFULLNAME__c;
            GiftDetail.reportedByCompanyTH = PISUser.COMPANYNAME_HOST__c;
            GiftDetail.reportedByCompanyEN = PISUser.COMPANYNAME_HOST__c;
            GiftDetail.reportedByEmployeeId = PISUser.EMPLOYEEID__c;
            GiftDetail.reportedBySection = PISUser.SECTIONS__c;
            GiftDetail.reportedByDepartment = PISUser.DEPARTMENT__c;
            GiftDetail.reportedByFunction = PISUser.FUNCTION__c;
            GiftDetail.reportedDate = system.today();
            GiftDetail.canEdit = true;
            GiftDetail.canSubmit = true;
            
        }
        else if(reportId != null) {
         
            List<CG_Reporting__c> CGReports = [select id, Running_No__c, User__c, Supervisor_Name__c, Submit_Within_Date__c, 
                                               Reported_By_Employee_Id__c, Reported_By_Section__c, Reported_By_Department__c, Reported_By_Function__c,
                                               Submitted_Date__c, Type_Of_Report__c , Status__c, Gift_Item__c, Gift_Date__c, 
                                               Status_JSON__c, IsAcknowledge__c, OwnerId, Gift_Supervisor_Suggestion__c,
                                               Reported_By_TH__c, Reported_By_EN__c, Reported_By_Position_TH__c,
                                               Reported_By_Position_EN__c, Reported_By_Company_TH__c, Reported_By_Company_EN__c,
                                               Reported_Date__c, Supervisor_Action_By_TH__c, Supervisor_Action_By_EN__c,
                                               Supervisor_Action_By_Position_TH__c, Supervisor_Action_By_Position_EN__c,
                                               Supervisor_Action_By_Company_TH__c, Supervisor_Action_By_Company_EN__c,
                                               Supervisor_Action_Date__c, Supervisor_Approver_Status__c, Supervisor_Comment__c,
                                               GLGC_Receive_By__c, GLGC_Action_By_TH__c, GLGC_Action_By_EN__c,
                                               GLGC_Action_By_Position_TH__c, GLGC_Action_By_Position_EN__c,
                                               GLGC_Action_By_Company_TH__c, GLGC_Action_By_Company_EN__c,
                                               GLGC_Action_Date__c, GLGC_Approver_Status__c, GLVP_Action_By_TH__c, GLVP_Action_By_EN__c,
                                               GLVP_Action_By_Position_TH__c, GLVP_Action_By_Position_EN__c,
                                               GLVP_Action_By_Company_TH__c, GLVP_Action_By_Company_EN__c,
                                               GLVP_Action_Date__c, GLVP_Approver_Status__c, GLVP_Comment__c, LastModifiedDate 
                                               from CG_Reporting__c where Id =: reportId];
          
            for(CG_Reporting__c CGReport : CGReports) {
                if(CGReport.Id == reportId) {
                    GiftDetail = assignToGiftReportDetailDTO(CGReport);
                    
                }
            }
                
        }
        
        return GiftDetail;
    }

    //Delete an Gift Report (only "Waiting for Submit")
    @RemoteAction
    public static void DeleteGiftReport(string reportId){
		
        try {
            CG_Reporting__c CGReporting = [select id, status__c from CG_Reporting__c where Id =: reportId];
            
            if(CGReporting != null && (CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) || 
                                      CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected))) {
                delete(CGReporting);
            }
        }
        catch(DmlException e) {
            System.debug('DeleteGiftRegistration exception has occurred: ' + e.getMessage());
        }
        
    }

    //Save as draft report (for employee)
    @RemoteAction
    public static CG_DTO.GiftReportDetailDTO SaveAsDraftReport(CG_DTO.GiftReportDetailDTO report){
        
        string userId = CG_PrivilegeHandler.getUserId();
        
        try {         
            
            if(report != null) {
                
                if(report.id == null) {
                    PISUsers__c PISUser = CG_Global.assignToPISUser(userId);
                	Id GiftRTId = [select id, name from RecordType where name = 'Gift Registration' AND sobjecttype = 'CG_Reporting__c'].Id;
        
                    //Insert into CG Reporting
                    CG_Reporting__c CGReporting = new CG_Reporting__c();
                    CGReporting.OwnerId = userId;
                    CGReporting.RecordTypeId = GiftRTId;
                    CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
                    CGReporting.User__c = CG_Global.AssignSupervisor(PISUser);
                    CGReporting.Submit_Within_Date__c = Date.ValueOf(report.submittedWithinDate);
                    CGReporting.Type_of_Report__c = 'GiftRegistration';
                    CGReporting.Reported_Date__c = system.Date.today();
                    CGReporting.Reported_By_TH__c = report.reportedByTH;
                    CGReporting.Reported_By_EN__c = report.reportedByEN;
                    CGReporting.Reported_By_Position_TH__c = report.reportedByPositionTH;
                    CGReporting.Reported_By_Position_EN__c = report.reportedByPositionEN;
                    CGReporting.Reported_By_Company_TH__c = report.reportedByCompanyTH;
                    CGReporting.Reported_By_Company_EN__c = report.reportedByCompanyEN;
                    
                    CGReporting.Owner_Function__c = PISUser.FUNCTION__c;
                    CGReporting.Owner_Department__c = PISUser.DEPARTMENT__c;
                    CGReporting.Owner_Section__c = PISUser.SECTIONS__c;
                    CGReporting.Owner_Unit__c = PISUser.UNITS__c;
                    
                    CGReporting.Gift_Item__c = SerializeGiftItems(report.giftItems, CGReporting.Status__c);
        			string runningNo = CG_ReportingHandler.GenerateRunningNo('Gift Registration');
                    string year = CG_ReportingHandler.GetCurrentYear();
                    
        			CGReporting.Running_No__c = 'GIFT-' + year + '-' + runningNo;
                    
                    insert(CGReporting);
                    
                    CGReporting.Status_JSON__c = CG_ReportingHandler.InitialGiftStatusJson(CGReporting.Id, PISUser);
                    update(CGReporting);
                    
                    report.id = CGReporting.id;
                    
                }
                else if(report.id != null) {
                    
                    List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit), String.ValueOf(CG_Enum.ReportStatus.Rejected) };
                    CG_Reporting__c CGReporting = [select id, Status__c, Running_No__c from CG_Reporting__c where Id =: report.id AND Status__c IN: statuses];
                
                    if(CGReporting != null) {
                        
                    	CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
                        CGReporting.Gift_Item__c = SerializeGiftItems(report.giftItems, CGReporting.Status__c);
                        CGReporting.Reported_Date__c = system.Date.today();
                        CGReporting.Submit_Within_Date__c = Date.ValueOf(report.submittedWithinDate);
                    	
                        update(CGReporting);
                        
                }
            }
        	}
        }
        catch(DmlException e) {
            System.debug('SaveAsDraftReport exception has occurred: ' + e.getMessage());
        }
        
        return report;
    }

    //Submit report (for employee)
    @RemoteAction
    public static CG_DTO.GiftReportDetailDTO SubmitReport(CG_DTO.GiftReportDetailDTO report){
        
        string userId = CG_PrivilegeHandler.getUserId();
        
        try {
            
            if(report.id == null) {
                PISUsers__c PISUser = CG_Global.assignToPISUser(userId);
                Id GiftRTId = [select id, name from RecordType where name = 'Gift Registration' AND sobjecttype = 'CG_Reporting__c'].Id;
        		
                //Insert into CG Reporting
                CG_Reporting__c CGReporting = new CG_Reporting__c();
                CGReporting.OwnerId = userId;
                CGReporting.RecordTypeId = GiftRTId;
                CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
                CGReporting.User__c = CG_Global.AssignSupervisor(PISUser);
                CGReporting.Submit_Within_Date__c = Date.ValueOf(report.submittedWithinDate);
                CGReporting.Type_of_Report__c = 'GiftRegistration';
                
                CGReporting.Reported_Date__c = system.Date.today();
                CGReporting.Reported_By_TH__c = report.reportedByTH;
                CGReporting.Reported_By_EN__c = report.reportedByEN;
                CGReporting.Reported_By_Position_TH__c = report.reportedByPositionTH;
                CGReporting.Reported_By_Position_EN__c = report.reportedByPositionEN;
                CGReporting.Reported_By_Company_TH__c = report.reportedByCompanyTH;
                CGReporting.Reported_By_Company_EN__c = report.reportedByCompanyEN;
                CGReporting.Submitted_Date__c = system.Date.today();
                
                CGReporting.Owner_Function__c = PISUser.FUNCTION__c;
                CGReporting.Owner_Department__c = PISUser.DEPARTMENT__c;
                CGReporting.Owner_Section__c = PISUser.SECTIONS__c;
                CGReporting.Owner_Unit__c = PISUser.UNITS__c;
                
                string runningNo = CG_ReportingHandler.GenerateRunningNo('Gift Registration');
                string year = CG_ReportingHandler.GetCurrentYear();
                
                CGReporting.Running_No__c = 'GIFT-' + year + '-' + runningNo;
                insert(CGReporting);
                
                CGReporting.Gift_Item__c = SerializeGiftItems(report.giftItems, CGReporting.Status__c);
                CGReporting.Status_JSON__c = CG_ReportingHandler.InitialGiftStatusJson(CGReporting.Id, PISUser);
                CGReporting.Status_JSON__c = assignSupervisorWhenEmployeeSubmit(CGReporting.Id, CGReporting.Status_JSON__c, CGReporting.User__c);
                update(CGReporting);
                
                report.id = CGReporting.id;
                
                //Send Email to Supervisor
            	CG_ReportingHandler.GiftRegistrationSupervisorEmail(CGReporting.User__c, CGReporting);
                
                //Send Bell Noti to Supervisor
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please acknowledge Gift Registration';
                BellNoti.Body = 'Please make decision for the Gift Registration : ' + CGReporting.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReporting.User__c);
        		BellNoti.RecordId = CGReporting.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReporting.User__c;
                OppNoti.Subject = 'Please acknowledge Gift Registration';
                OppNoti.Description = 'Please make decision for the Gift Registration : ' + CGReporting.Running_No__c;
                OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReporting.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else if(report.id != null) {
                
                CG_Reporting__c CGReporting = [select id, Status__c, Running_No__c, Status_JSON__c, User__c, OwnerId, Reported_By_EN__c from CG_Reporting__c where Id =: report.id AND 
                                               (Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) OR Status__c =: String.ValueOf(CG_Enum.ReportStatus.Rejected))];
            
                CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
                CGReporting.Submit_Within_Date__c = Date.ValueOf(report.submittedWithinDate);
                CGReporting.Reported_Date__c = system.Date.today();
                CGReporting.Submitted_Date__c = system.Date.today();
                
                CGReporting.Gift_Item__c = SerializeGiftItems(report.giftItems, CGReporting.Status__c);
                CGReporting.Status_JSON__c = assignSupervisorWhenEmployeeSubmit(CGReporting.Id, CGReporting.Status_JSON__c, CGReporting.User__c);
                
                update(CGReporting);
                
                //Send Email to Supervisor
            	CG_ReportingHandler.GiftRegistrationSupervisorEmail(CGReporting.User__c, CGReporting);
                
                //Send Bell Noti to Supervisor
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please acknowledge Gift Registration';
                BellNoti.Body = 'Please make decision for the Gift Registration : ' + CGReporting.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReporting.User__c);
        		BellNoti.RecordId = CGReporting.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReporting.User__c;
                OppNoti.Subject = 'Please acknowledge Gift Registration';
                OppNoti.Description = 'Please make decision for the Gift Registration : ' + CGReporting.Running_No__c;
                OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReporting.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else {
                System.debug('Cannot submit GiftRegistration. Report not found.');
            }
            
        }
        catch(DmlException e) {
            System.debug('SubmitReport exception has occurred: ' + e.getMessage());
        }
        
        return report;
    }

    @RemoteAction
    public static CG_DTO.WorkflowHistoryDTO GetReportWorkflow(string reportId){
        try {
            
            CG_DTO.WorkflowHistoryDTO WorkflowHistoryDTO = new CG_DTO.WorkflowHistoryDTO();
            
            CG_Reporting__c CGReporting = [select id, Status_JSON__c from CG_Reporting__c where Id =: reportId];
            
            if(CGReporting != null) {
                WorkflowHistoryDTO = DeserializeWorkflowHistory(CGReporting.Status_JSON__c);
                return WorkflowHistoryDTO;
            }
        }
        catch(Exception e) {
            System.debug('GetReportWorkflow exception has occurred: ' + e.getMessage());
        }
        
        return null;
    }
    
    @RemoteAction
    public static CG_DTO.GiftReportDetailDTO ApproveReport(CG_DTO.GiftReportDetailDTO report){
        
        if(report.id != null) {
            
            CG_Reporting__c CGReporting = [select id, status__c, user__c, status_json__c, ownerId, 
                                           	running_no__c, Supervisor_Approver_Status__c, Supervisor_Action_Date__c,
                                           	GLVP_Action_Date__c, Reported_By_EN__c, GLGC_Id__c, GLVP_Id__c from CG_Reporting__c where Id =: report.Id];
            
            if(report.supervisorApproverStatus.key == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged) && CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            
                //Update Requester Opp Noti
                CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.User__c, 'Approved');
                
                CGReporting.Status_JSON__c = assignGLGCWhenSupervisorSubmit('Acknowledged', report.supervisorComment, CGReporting.OwnerId, CGReporting.Status_JSON__c);
                
                ///Supervisor
                CGReporting.Supervisor_Approver_Status__c = String.ValueOf(report.supervisorApproverStatus.key);
                CGReporting.Supervisor_Comment__c = report.supervisorComment;
                CGReporting.Supervisor_Action_By_TH__c = report.supervisorActionByTH;
                CGReporting.Supervisor_Action_By_EN__c = report.supervisorActionByEN;
                CGReporting.Supervisor_Action_By_Position_TH__c = report.supervisorActionByPositionTH;
                CGReporting.Supervisor_Action_By_Position_EN__c = report.supervisorActionByPositionEN;
                CGReporting.Supervisor_Action_By_Company_TH__c = report.supervisorActionByCompanyTH;
                CGReporting.Supervisor_Action_By_Company_EN__c = report.supervisorActionByCompanyEN;
                CGReporting.Supervisor_Action_Date__c = report.supervisorActionDate;
    
                //If Supervisor Acknowledged
                CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC);
                
                //Send email to User when Supervisor acknowledged
                CG_ReportingHandler.GiftRegistrationUserAcknowledgedEmail(CGReporting.OwnerId, CGReporting);

                //Send Bell Noti to Owner
                CG_DTO.BellNotiDTO BellNotiOwner = new CG_DTO.BellNotiDTO();
                BellNotiOwner.NotificationName = 'CG_Notification';
                BellNotiOwner.Title = 'Your Gift Registration was acknowledged';
                BellNotiOwner.Body = 'Your Gift Registration : ' + CGReporting.Running_No__c + ' was sent to GLVP';
                BellNotiOwner.Receivers = new Set<string>();
                BellNotiOwner.Receivers.add(CGReporting.OwnerId);
                BellNotiOwner.RecordId = CGReporting.Id;
                BellNotiOwner.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting\'}}';
                CG_NotiController.SendBellNoti(BellNotiOwner);
                
                //Sending mail to GLGC when Supervisor acknowledged
                List<PISUsers__c> GLGCPISUsers = CG_Global.assignToGLGCPISUser();
                if(GLGCPISUsers != null) {
                    if(GLGCPISUsers.size() > 0) {
                        for(PISUsers__c GLGC : GLGCPISUsers) {
                            CG_ReportingHandler.GiftRegistrationGLGCEmail(GLGC.User__c, CGReporting);
                            
                            //Send Bell Noti to GLGC
                            CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                            BellNoti.NotificationName = 'CG_Notification';
                            BellNoti.Title = 'Please acknowledge Gift Registration';
                            BellNoti.Body = 'Please acknowledge for the Gift Registration : ' + CGReporting.Running_No__c;
                            BellNoti.Receivers = new Set<string>();
                            BellNoti.Receivers.add(GLGC.User__c);
        					BellNoti.RecordId = CGReporting.Id;
                			BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting\'}}';
                			CG_NotiController.SendBellNoti(BellNoti);
                            
                            //Send Opp Noti
                            CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                            OppNoti.ApproverId = GLGC.User__c;
                            OppNoti.Subject = 'Please acknowledge Gift Registration';
                            OppNoti.Description = 'Please acknowledge for the Gift Registration : ' + CGReporting.Running_No__c;
                            OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                            OppNoti.Status = 'New';
                            
                            string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting';
                            
                            OppNoti.URL = URL;
                            OppNoti.ReferenceId = CGReporting.Id;
                            CG_NotiController.SendOppNoti(OppNoti);
                            
                            
                        }
                    }
                }
            }
            else if(report.glgcApproverStatus.key == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged) && CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            	
                string userId = CG_PrivilegeHandler.getUserId();
                List<PISUsers__c> GLGCPISUsers = CG_Global.assignToGLGCPISUser();
                boolean isGLGCUser = false;
                if(GLGCPISUsers != null) {
                    if(GLGCPISUsers.size() > 0) {
                        for(PISUsers__c GLGC : GLGCPISUsers) {
                            if(GLGC.User__c == userId) {
                                isGLGCUser = true;
                            }
                        }
                    }
                }
                
                if(isGLGCUser) {
                    
                    CGReporting.Gift_Item__c = SerializeGiftItems(report.giftItems, CGReporting.Status__c);
                    CGReporting.Gift_Status__c = GetGiftStatus(report.giftItems);
                    
                    CGReporting.Status_JSON__c = assignGLVPWhenGLGCSubmit('Acknowledged', report.glgcReceiveBy, userId, CGReporting.Status_JSON__c);
                
                    //Update GLGC Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, userId, 'Approved');
                    
                    //GLGC
                    CGReporting.GLGC_Approver_Status__c = String.ValueOf(report.glgcapproverStatus.key);
                    CGReporting.GLGC_Receive_By__c = report.glgcReceiveBy;
                    CGReporting.GLGC_Action_By_TH__c = report.glgcActionByTH;
                    CGReporting.GLGC_Action_By_EN__c = report.glgcActionByEN;
                    CGReporting.GLGC_Action_By_Position_TH__c = report.glgcActionByPositionTH;
                    CGReporting.GLGC_Action_By_Position_EN__c = report.glgcActionByPositionEN;
                    CGReporting.GLGC_Action_By_Company_TH__c = report.glgcActionByCompanyTH;
                    CGReporting.GLGC_Action_By_Company_EN__c = report.glgcActionByCompanyEN;
                    CGReporting.GLGC_Action_Date__c = report.glgcActionDate;
                    CGReporting.GLGC_Id__c = userId;
        
                    //If GLGC Acknowledged
                    CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
                    
                    //Send email to GLVP when GLGC Acknowledge
                	List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
                    if(GLVPPISUsers != null) {
                        if(GLVPPISUsers.size() > 0) {
                            for(PISUsers__c GLVP : GLVPPISUsers) {
                                CG_ReportingHandler.GiftRegistrationGLVPEmail(GLVP.User__c, CGReporting);
                                
                                //Send Bell Noti to GLVP
                                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                                BellNoti.NotificationName = 'CG_Notification';
                                BellNoti.Title = 'Please acknowledge Gift Registration';
                                BellNoti.Body = 'Please acknowledge for the Gift Registration : ' + CGReporting.Running_No__c;
                                BellNoti.Receivers = new Set<string>();
                                BellNoti.Receivers.add(GLVP.User__c);
        						BellNoti.RecordId = CGReporting.Id;
                                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting\'}}';
                				CG_NotiController.SendBellNoti(BellNoti);
                                
                                //Send Opp Noti
                                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                                OppNoti.ApproverId = GLVP.User__c;
                                OppNoti.Subject = 'Please acknowledge Gift Registration';
                                OppNoti.Description = 'Please acknowledge for the Gift Registration : ' + CGReporting.Running_No__c;
                                OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                                OppNoti.Status = 'New';
                                
                                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting';
                                
                                OppNoti.URL = URL;
                                OppNoti.ReferenceId = CGReporting.Id;
                                CG_NotiController.SendOppNoti(OppNoti);
                                
                            }
                        }
                    }
                }
                
            }
            else if(report.glvpApproverStatus.key == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged) && CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            	string userId = CG_PrivilegeHandler.getUserId();
                List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
                boolean isGLVPUser = false;
                if(GLVPPISUsers != null) {
                    if(GLVPPISUsers.size() > 0) {
                        for(PISUsers__c GLVP : GLVPPISUsers) {
                            if(GLVP.User__c == userId) {
                                isGLVPUser = true;
                            }
                        }
                    }
                }
                
                if(isGLVPUser) {
                    CGReporting.Status_JSON__c = assignSuccessWhenGLVPSubmit('Acknowledged', userId, CGReporting.Status_JSON__c);
                
                    //Update GLVP Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, userId, 'Approved');
                    
                    //GLVP
                    CGReporting.GLVP_Approver_Status__c = String.ValueOf(report.glvpApproverStatus.key);
                    CGReporting.GLVP_Comment__c = report.glvpComment;
                    CGReporting.GLVP_Action_By_TH__c = report.glvpActionByTH;
                    CGReporting.GLVP_Action_By_EN__c = report.glvpActionByEN;
                    CGReporting.GLVP_Action_By_Position_TH__c = report.glvpActionByPositionTH;
                    CGReporting.GLVP_Action_By_Position_EN__c = report.glvpActionByPositionEN;
                    CGReporting.GLVP_Action_By_Company_TH__c = report.glvpActionByCompanyTH;
                    CGReporting.GLVP_Action_By_Company_EN__c = report.glvpActionByCompanyEN;
                    CGReporting.GLVP_Action_Date__c = report.glvpActionDate;
                    CGReporting.GLVP_Id__c = userId;
        
                    //If GLVP Acknowledged
                    CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
                    
                    //Send email to Owner when GLVP Acknowledged
                    CG_ReportingHandler.GiftRegistrationUserEmailGLVPAcknowledged(CGReporting.OwnerId, CGReporting);
                    
                    //Send Bell Noti to User
                    CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                    BellNoti.NotificationName = 'CG_Notification';
                    BellNoti.Title = 'Your Gift Registration was acknowledged';
                    BellNoti.Body = 'Your Gift Registration : ' + CGReporting.Running_No__c + ' was received already';
                    BellNoti.Receivers = new Set<string>();
                    BellNoti.Receivers.add(CGReporting.OwnerId);
                    BellNoti.RecordId = CGReporting.Id;
                	BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting\'}}';
                	CG_NotiController.SendBellNoti(BellNoti);
                    
                }
                
            }
            else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                CGReporting.Gift_Item__c = UpdateGiftItems(report.giftItems);
                CGReporting.Gift_Status__c = GetGiftStatus(report.giftItems);
            }
            
            update(CGReporting);
        }
        
        return report;
    }
	
    @RemoteAction
    public static CG_DTO.GiftReportDetailDTO RejectReport(CG_DTO.GiftReportDetailDTO report){
        
        if(report.id != null) {
            
            CG_Reporting__c CGReporting = [select id, running_no__c, status__c, user__c, status_json__c, ownerId, Supervisor_Approver_Status__c, Supervisor_Action_Date__c, Reported_By_EN__c from CG_Reporting__c where Id =: report.Id];
            
            if(report.supervisorApproverStatus.key == String.ValueOf(CG_Enum.ApproverStatus.Rejected)) {
            
                //Update GLGC Opp Noti
                CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.User__c, 'Rejected');
                
                CGReporting.Status_JSON__c = assignGLGCWhenSupervisorSubmit('Rejected', report.supervisorComment, CGReporting.OwnerId, CGReporting.Status_JSON__c);
                
                ///Supervisor
                CGReporting.Supervisor_Approver_Status__c = String.ValueOf(report.supervisorApproverStatus.key);
                CGReporting.Supervisor_Comment__c = report.supervisorComment;
                CGReporting.Supervisor_Action_By_TH__c = report.supervisorActionByTH;
                CGReporting.Supervisor_Action_By_EN__c = report.supervisorActionByEN;
                CGReporting.Supervisor_Action_By_Position_TH__c = report.supervisorActionByPositionTH;
                CGReporting.Supervisor_Action_By_Position_EN__c = report.supervisorActionByPositionEN;
                CGReporting.Supervisor_Action_By_Company_TH__c = report.supervisorActionByCompanyTH;
                CGReporting.Supervisor_Action_By_Company_EN__c = report.supervisorActionByCompanyEN;
                CGReporting.Supervisor_Action_Date__c = report.supervisorActionDate;
    
                //If Supervisor Rejected
                CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
                
                //Send email to User when Supervisor rejected
                CG_ReportingHandler.GiftRegistrationUserRejectedEmail(CGReporting.OwnerId, CGReporting);
                
                //Send Bell Noti to User
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Gift Registration was rejected';
                BellNoti.Body = 'Please edit your Gift Registration : ' + CGReporting.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReporting.OwnerId);
        		BellNoti.RecordId = CGReporting.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReporting.OwnerId;
                OppNoti.Subject = 'Gift Registration was rejected';
                OppNoti.Description = 'Please edit your Gift Registration : ' + CGReporting.Running_No__c;
                OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReporting.Id + '&parent=giftRegistrationReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReporting.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            
            update(CGReporting);
        }
        
        return report;
    }
    
    @RemoteAction
    public static void MassApproveReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds
    ){
        
		string userId = CG_PrivilegeHandler.getUserId();
        List<Id> cgReportIds = new List<Id>();
        cgReportIds = reportIds.split(',');
        
        List<CG_Reporting__c> CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                              End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                              Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, Reported_By_EN__c from CG_Reporting__c
                                              where id IN: cgReportIds];
        
        if(CGReportings.size() > 0) {
            for(CG_Reporting__c CGReport : CGReportings) {
                //When GLGC Mass acknowledge
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
                    
                    //GLGC
                    CGReport.GLGC_Approver_Status__c = String.ValueOf(CG_Enum.ApproverStatus.Acknowledged);
                    
                    //Update GLGC Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReport.Id, userId, 'Approved');
                    
                    PISUsers__c Approver = CG_Global.assignToPISUser(userId);
                    
                    CGReport.GLGC_Action_By_TH__c = Approver.THTITLE__c + ' ' + Approver.THFIRSTNAME__c + ' ' + Approver.THLASTNAME__c;
                    CGReport.GLGC_Action_By_EN__c = Approver.EN_Fullname__c;
                    CGReport.GLGC_Action_By_Position_TH__c = Approver.OBJTHFULLNAME__c;
                    CGReport.GLGC_Action_By_Position_EN__c = Approver.OBJENFULLNAME__c;
                    CGReport.GLGC_Action_By_Company_TH__c = Approver.COMPANYNAME__c;
                    CGReport.GLGC_Action_By_Company_EN__c = Approver.COMPANYNAME__c;
                    CGReport.GLGC_Action_Date__c = date.today();
                }
                //When GLVP Mass acknowledge
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
                    
                    //Update GLVP Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReport.Id, userId, 'Approved');
                    
                    //GLVP
                    CGReport.GLVP_Approver_Status__c = String.ValueOf(CG_Enum.ApproverStatus.Acknowledged);
                    
                    PISUsers__c Approver = CG_Global.assignToPISUser(userId);
                    
                    CGReport.GLVP_Action_By_TH__c = Approver.THTITLE__c + ' ' + Approver.THFIRSTNAME__c + ' ' + Approver.THLASTNAME__c;
                    CGReport.GLVP_Action_By_EN__c = Approver.EN_Fullname__c;
                    CGReport.GLVP_Action_By_Position_TH__c = Approver.OBJTHFULLNAME__c;
                    CGReport.GLVP_Action_By_Position_EN__c = Approver.OBJENFULLNAME__c;
                    CGReport.GLVP_Action_By_Company_TH__c = Approver.COMPANYNAME__c;
                    CGReport.GLVP_Action_By_Company_EN__c = Approver.COMPANYNAME__c;
                    CGReport.GLVP_Action_Date__c = date.today();
                }
                
            }
            
            update(CGReportings);
        }
    }

    //Gift Registration List
    @RemoteAction
    public static CG_DTO.AdminGiftReportListCountDTO GetAdminGiftReportListCount(
        //employee name
        string ownerName,
        //employee id
        string ownerId,
    	//companyId, function, department, section, unit
    	string companyId, string function, string department, string section, string unit) {
        
        AdminGiftReportListCount = new CG_DTO.AdminGiftReportListCountDTO();
        AdminGiftReportListCount.totalReport = 0;
        
        List<string> typeOfReports = new List<string> { 'GiftRegistration' };
         List<string> statuses = new List<string> { String.ValueOF(CG_Enum.ReportStatus.WaitingForSubmit)};   
            
        string userId = CG_PrivilegeHandler.getUserId();
        
        Set<CG_Reporting__c> allCGReports = new Set<CG_Reporting__c>();  
        List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();     
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c, ' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c,' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c , Status__c,' +
            				'Status_JSON__c, IsAcknowledge__c, OwnerId, Owner_Position__c from CG_Reporting__c ' +
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses';
        
        //companyId
        if(!String.isEmpty(companyId) && !String.isBlank(companyId) && companyId.toLowerCase() != 'all') {
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
        }
        
        //function
        if(!String.isEmpty(function) && !String.isBlank(function) && function.toLowerCase() != 'all') {
            query = query + ' AND Owner_Function__c =: function';
        }
        
        //department
        if(!String.isEmpty(department) && !String.isBlank(department) && department.toLowerCase() != 'all') {
            query = query + ' AND Owner_Department__c =: department';
        }
        
        //section
        if(!String.isEmpty(section) && !String.isBlank(section) && section.toLowerCase() != 'all') {
            query = query + ' AND Owner_Section__c =: section';
        }
        
        //unit
        if(!String.isEmpty(unit) && !String.isBlank(unit) && unit.toLowerCase() != 'all') {
            query = query + ' AND Owner_Unit__c =: unit';
        }
        
        //Final query
        CGReportings = database.query(query + ' order by Running_No__c asc');
        
        if(CGReportings.size() > 0) {
            
            for(CG_Reporting__c CGReport : CGReportings) {
                if(!string.isBlank(ownerName) && string.isBlank(ownerId)) {
                    ownerName = ownerName.toLowerCase();
                    if((CGReport.Owner_Full_Name_TH__c != null && CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName)) || (CGReport.Owner_Full_Name_EN__c != null && CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName))) {
                        allCGReports.add(CGReport);
                    }
                }
                else if(string.isBlank(ownerName) && !string.isBlank(ownerId)) {
                    if(CGReport.Employee_Id__c == ownerId) {
                        allCGReports.add(CGReport);
                    }
                }
                else if(!string.isBlank(ownerName) && !string.isBlank(ownerId)) {
                    ownerName = ownerName.toLowerCase();
                    if((CGReport.Owner_Full_Name_TH__c != null && CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName)) || (CGReport.Owner_Full_Name_EN__c != null && CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName))) {
                        allCGReports.add(CGReport);
                    }
                    if(CGReport.Employee_Id__c == ownerId) {
                        allCGReports.add(CGReport);
                    }
                }
                else {
                    allCGReports.add(CGReport); 
                }
                
            }
            
            if(allCGReports.size() > 0) {
            	AdminGiftReportListCount.totalReport = allCGReports.size();
            }
            
        }    
            
        return AdminGiftReportListCount;
            
            
    }

    @RemoteAction
    public static List<CG_DTO.AdminGiftReportListDTO> GetAdminGiftReportList(
    //employee name
    string ownerName,
    //employee id
    string ownerId,
    //companyId, function, department, section, unit
   	string companyId, string function, string department, string section, string unit,
    //reportNumber, owner, supervisorApproverStatus, status, giftStatus, lastUpdated
    CG_Global.SortByParam sortByParam, 
    CG_Global.PageParam pageParam
    ) {
        
        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
        AdminGiftReportListDTOs = new List<CG_DTO.AdminGiftReportListDTO>();
        
        List<string> typeOfReports = new List<string> { 'GiftRegistration' };
         List<string> statuses = new List<string> { String.ValueOF(CG_Enum.ReportStatus.WaitingForSubmit)};   
            
        string userId = CG_PrivilegeHandler.getUserId();
        
        List<CG_Reporting__c> allCGReports = new List<CG_Reporting__c>();   
        List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();     
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c, ' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, Supervisor_Approver_Status__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c , Status__c, LastModifiedDate, ' +
            				'Status_JSON__c, IsAcknowledge__c, OwnerId, Gift_Status__c, Owner_Position__c from CG_Reporting__c ' +
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses';
        
        //companyId
        if(!String.isEmpty(companyId) && !String.isBlank(companyId) && companyId.toLowerCase() != 'all') {
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
        }
        
        //function
        if(!String.isEmpty(function) && !String.isBlank(function) && function.toLowerCase() != 'all') {
            query = query + ' AND Owner_Function__c =: function';
        }
        
        //department
        if(!String.isEmpty(department) && !String.isBlank(department) && department.toLowerCase() != 'all') {
            query = query + ' AND Owner_Department__c =: department';
        }
        
        //section
        if(!String.isEmpty(section) && !String.isBlank(section) && section.toLowerCase() != 'all') {
            query = query + ' AND Owner_Section__c =: section';
        }
        
        //unit
        if(!String.isEmpty(unit) && !String.isBlank(unit) && unit.toLowerCase() != 'all') {
            query = query + ' AND Owner_Unit__c =: unit';
        }
        
        //SortBy
        if(sortByParam.sortBy == 'reportNumber') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by running_no__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by running_no__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerName') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Owner_Full_Name_EN__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Owner_Full_Name_EN__c desc');
            }
        }
        else if(sortByParam.sortBy == 'supervisorApproverStatus') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Supervisor_Approver_Status__c  asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Supervisor_Approver_Status__c  desc');
            }
        }
        else if(sortByParam.sortBy == 'status') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by status__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by status__c desc');
            }
        }
        else if(sortByParam.sortBy == 'giftStatus') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Gift_Status__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Gift_Status__c desc');
            }
        }
        else if(sortByParam.sortBy == 'lastUpdated') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by LastModifiedDate asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by LastModifiedDate desc');
            }
        }
        else {
            CGReportings = database.query(query + ' order by Running_No__c asc');
        }
        
        if(CGReportings.size() > 0) {
            
            for(CG_Reporting__c CGReport : CGReportings) {
                if(!string.isBlank(ownerName) && string.isBlank(ownerId)) {
                    ownerName = ownerName.toLowerCase();
                    if((CGReport.Owner_Full_Name_TH__c != null && CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName)) || (CGReport.Owner_Full_Name_EN__c != null && CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName))) {
                        allCGReports.add(CGReport);
                    }
                }
                else if(string.isBlank(ownerName) && !string.isBlank(ownerId)) {
                    if(CGReport.Employee_Id__c == ownerId) {
                        allCGReports.add(CGReport);
                    }
                }
                else if(!string.isBlank(ownerName) && !string.isBlank(ownerId)) {
                    ownerName = ownerName.toLowerCase();
                    if((CGReport.Owner_Full_Name_TH__c != null && CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName)) || (CGReport.Owner_Full_Name_EN__c != null && CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName))) {
                        allCGReports.add(CGReport);
                    }
                    if(CGReport.Employee_Id__c == ownerId) {
                        allCGReports.add(CGReport);
                    }
                }
                else {
                    allCGReports.add(CGReport); 
                }
                
            }
            
            //PageParam
            if(allCGReports.size() > 0) {
                Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            	integer totalSize = allCGReports.size() - startIndex;
                for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                    if (i < totalSize){
                        AdminGiftReportListDTOs.add(assignToAdminGiftReportListDTO(allCGReports[startIndex + i]));
                    }else{
                        break;
                    }
                }
                
            }
        }
        
        return AdminGiftReportListDTOs;
    }

    @RemoteAction
    public static void AdminResendReport(string reportId){
        
        CG_Reporting__c CGReport = [select id, User__c, Type_Of_Report__c, OwnerId, Status__c, Running_No__c, Submitted_Date__c, Supervisor_Approver_Status__c,
                                    Supervisor_Action_Date__c, GLGC_Action_Date__c, Start_Duration__c, End_Duration__c, Submit_Within_Date__c, Reported_By_EN__c 
                                    from CG_Reporting__c where Id =: reportId];
         
        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            CG_ReportingHandler.GiftRegistrationReminderEmail(CGReport.OwnerId, CGReport);
        }
        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            CG_ReportingHandler.GiftRegistrationUserRejectedEmail(CGReport.OwnerId, CGReport);
            
            //Send Bell Noti to Owner
            CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
            BellNoti.NotificationName = 'CG_Notification';
            BellNoti.Title = 'Gift Registration was rejected';
            BellNoti.Body = 'Please edit your Gift Registration : ' + CGReport.Running_No__c;
            BellNoti.Receivers = new Set<string>();
            BellNoti.Receivers.add(CGReport.OwnerId);
            BellNoti.RecordId = CGReport.Id;
            BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting\'}}';
            CG_NotiController.SendBellNoti(BellNoti);
            
            //Send Opp Noti
            CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
            OppNoti.ApproverId = CGReport.OwnerId;
            OppNoti.Subject = 'Gift Registration was rejected';
            OppNoti.Description = 'Please edit your Gift Registration : ' + CGReport.Running_No__c;
            OppNoti.RequesterName = CGReport.Reported_By_EN__c;
            OppNoti.Status = 'New';
            
            string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
            
            OppNoti.URL = URL;
            OppNoti.ReferenceId = CGReport.Id;
            CG_NotiController.SendOppNoti(OppNoti);
        }
        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            CG_ReportingHandler.GiftRegistrationSupervisorEmail(CGReport.User__c, CGReport);
            
            //Send Bell Noti to Supervisor
            CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
            BellNoti.NotificationName = 'CG_Notification';
            BellNoti.Title = 'Please acknowledge Gift Registration';
            BellNoti.Body = 'Please make decision for the Gift Registration : ' + CGReport.Running_No__c;
            BellNoti.Receivers = new Set<string>();
            BellNoti.Receivers.add(CGReport.User__c);
            BellNoti.RecordId = CGReport.Id;
            BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting\'}}';
            CG_NotiController.SendBellNoti(BellNoti);
            
            //Send Opp Noti
            CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
            OppNoti.ApproverId = CGReport.User__c;
            OppNoti.Subject = 'Please acknowledge Gift Registration';
            OppNoti.Description = 'Please make decision for the Gift Registration : ' + CGReport.Running_No__c;
            OppNoti.RequesterName = CGReport.Reported_By_EN__c;
            OppNoti.Status = 'New';
            
            string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
            
            OppNoti.URL = URL;
            OppNoti.ReferenceId = CGReport.Id;
            CG_NotiController.SendOppNoti(OppNoti);
        }
        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            
            //Send email to GLGC when Supervisor Acknowledged
            List<PISUsers__c> GLGCPISUsers = CG_Global.assignToGLGCPISUser();
            if(GLGCPISUsers != null) {
                if(GLGCPISUsers.size() > 0) {
                    for(PISUsers__c GLGC : GLGCPISUsers) {
                        
                        CG_ReportingHandler.GiftRegistrationGLGCEmail(GLGC.User__c, CGReport);
                        
                        //Send Bell Noti to GLGC
                        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                        BellNoti.NotificationName = 'CG_Notification';
                        BellNoti.Title = 'Please acknowledge Gift Registration';
                        BellNoti.Body = 'Please make decision for the Gift Registration : ' + CGReport.Running_No__c;
                        BellNoti.Receivers = new Set<string>();
                        BellNoti.Receivers.add(GLGC.User__c);
                        BellNoti.RecordId = CGReport.Id;
                        BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting\'}}';
                        CG_NotiController.SendBellNoti(BellNoti);
                        
                        //Send Opp Noti
                        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                        OppNoti.ApproverId = GLGC.User__c;
                        OppNoti.Subject = 'Please acknowledge Gift Registration';
                        OppNoti.Description = 'Please make decision for the Gift Registration : ' + CGReport.Running_No__c;
                        OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                        OppNoti.Status = 'New';
                        
                        string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
                        
                        OppNoti.URL = URL;
                        OppNoti.ReferenceId = CGReport.Id;
                        CG_NotiController.SendOppNoti(OppNoti);
                    }
                }
            }
            
        }
        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            CG_ReportingHandler.GiftRegistrationGLVPEmail(CGReport.User__c, CGReport);
            
            //Send email to GLVP when GLGC Acknowledged
            List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
            if(GLVPPISUsers != null) {
                if(GLVPPISUsers.size() > 0) {
                    for(PISUsers__c GLVP : GLVPPISUsers) {
                        
                        CG_ReportingHandler.GiftRegistrationGLVPEmail(GLVP.User__c, CGReport);
                        
                        //Send Bell Noti to GLVP
                        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                        BellNoti.NotificationName = 'CG_Notification';
                        BellNoti.Title = 'Please acknowledge Gift Registration';
                        BellNoti.Body = 'Please make decision for the Gift Registration : ' + CGReport.Running_No__c;
                        BellNoti.Receivers = new Set<string>();
                        BellNoti.Receivers.add(GLVP.User__c);
                        BellNoti.RecordId = CGReport.Id;
                        BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting\'}}';
                        CG_NotiController.SendBellNoti(BellNoti);
                        
                        //Send Opp Noti
                        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                        OppNoti.ApproverId = GLVP.User__c;
                        OppNoti.Subject = 'Please acknowledge Gift Registration';
                        OppNoti.Description = 'Please make decision for the Gift Registration : ' + CGReport.Running_No__c;
                        OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                        OppNoti.Status = 'New';
                        
                        string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Gift_Registration_Detail?reportId=' + CGReport.Id + '&parent=giftRegistrationReporting';
                        
                        OppNoti.URL = URL;
                        OppNoti.ReferenceId = CGReport.Id;
                        CG_NotiController.SendOppNoti(OppNoti);
                    }
                }
            }
        }
        
    }

    @RemoteAction
    public static void AdminCancelReport(string reportId){
        
        string userId = CG_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = CG_Global.assignToPISUser(userId);
        CG_Reporting__c CGReport = [select id, OwnerId, Status__c from CG_Reporting__c where Id =: reportId];
        CGReport.Status__c = String.valueOf(CG_Enum.ReportStatus.Cancel);
        CGReport.Cancelled_By__c = PISUser.EN_Fullname__c;
        CGReport.Cancelled_Date__c = date.today();
        
        //Update Opp Noti
        CG_NotiController.UpdateOppNotiWhenUserAction(CGReport.Id, userId, 'Canceled');
        
        
        update(CGReport);
    }

    //Assign to DTO section
    @TestVisible
    private static CG_DTO.GiftReportListDTO assignToGiftReportListDTO(string userProfile, CG_Reporting__c CGReporting) {
        
        CG_DTO.GiftReportListDTO Report = new CG_DTO.GiftReportListDTO();
        Report.id = CGReporting.Id;
        
        Report.reportType = new CG_Global.EnumValue('GiftRegistration');
        Report.reportType.key = 'GiftRegistration';
        Report.reportType.value = 'Gift Registration';
        Report.reportNumber = CGReporting.Running_No__c;
        Report.supervisorName = CGReporting.Supervisor_Name__c;
        
        Report.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            Report.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            Report.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingGLGC.name();
            Report.status.value = 'Waiting GLGC';   
            
            if(userProfile != String.ValueOf(CG_Enum.ApproverRole.GLGC)) {
                Report.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            	Report.status.value = 'Waiting GLVP';   
            }
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            Report.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            Report.status.key = CG_Enum.ReportStatus.Rejected.name();
            Report.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            Report.status.key = CG_Enum.ReportStatus.Success.name();
            Report.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Cancel)) {
            Report.status.key = CG_Enum.ReportStatus.Cancel.name();
            Report.status.value = 'Cancel';            
        }
        
        Report.lastUpdated = CGReporting.LastModifiedDate;
        Report.submittedDate = CGReporting.Submitted_Date__c;
        Report.canEdit = checkCanEdit(String.ValueOf(Report.status.key));
        Report.canDelete = checkCanDelete(String.ValueOf(Report.status.key));
        return Report;
        
    }
    
    @TestVisible
    private static CG_DTO.GiftMassAcknowledgeListDTO assignToGiftMassAcknowledgeListDTO(CG_Reporting__c CGReporting, User currentUser) {
        
        CG_DTO.GiftMassAcknowledgeListDTO GiftMass = new CG_DTO.GiftMassAcknowledgeListDTO();
        GiftMass.id = CGReporting.Id;
        GiftMass.reportNumber = CGReporting.Running_No__c;
        GiftMass.reportType = new CG_Global.EnumValue('GiftRegistration');
        GiftMass.reportType.key = 'GiftRegistration';
        GiftMass.reportType.value = 'Gift Registration';
        
        GiftMass.supervisorName = CGReporting.Supervisor_Name__c;
        GiftMass.submittedDate = CGReporting.Submitted_Date__c;
        
        GiftMass.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            GiftMass.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            GiftMass.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            GiftMass.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            GiftMass.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            GiftMass.status.key = CG_Enum.ReportStatus.WaitingGLGC.name();
            GiftMass.status.value = 'Waiting GLGC';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            GiftMass.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            GiftMass.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            GiftMass.status.key = CG_Enum.ReportStatus.Rejected.name();
            GiftMass.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            GiftMass.status.key = CG_Enum.ReportStatus.Success.name();
            GiftMass.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            GiftMass.status.key = CG_Enum.ReportStatus.Expired.name();
            GiftMass.status.value = 'Expired';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Cancel)) {
            GiftMass.status.key = CG_Enum.ReportStatus.Cancel.name();
            GiftMass.status.value = 'Cancel';            
        }
        
        GiftMass.ownerName = currentUser.Name;
        GiftMass.ownerPosition = currentUser.Position__c;
        GiftMass.ownerSection = currentUser.Section__c;
        
        return GiftMass;
        
    }
	
    @TestVisible
    private static CG_DTO.AdminGiftReportListDTO assignToAdminGiftReportListDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.AdminGiftReportListDTO AdminGiftReport = new CG_DTO.AdminGiftReportListDTO();
        
        AdminGiftReport.id = CGReporting.Id;
        AdminGiftReport.reportNumber = CGReporting.Running_No__c;
        AdminGiftReport.supervisorName = CGReporting.Supervisor_Name__c;
        AdminGiftReport.position = CGReporting.Owner_Position__c;
        
        AdminGiftReport.reportType = new CG_Global.EnumValue('GiftRegistration');
        AdminGiftReport.reportType.key = 'GiftRegistration';
        AdminGiftReport.reportType.value = 'Gift Registration';
        
        AdminGiftReport.supervisorApproverStatus = new CG_Global.EnumValue(CGReporting.Supervisor_Approver_Status__c);
        if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged)) {
            AdminGiftReport.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Acknowledged.name();
            AdminGiftReport.supervisorApproverStatus.value = 'Acknowledged';            
        }
        else if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Rejected)) {
            AdminGiftReport.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Rejected.name();
            AdminGiftReport.supervisorApproverStatus.value = 'Rejected';            
        }
        else if(string.isEmpty(CGReporting.Supervisor_Approver_Status__c)) {
            AdminGiftReport.supervisorApproverStatus.key = '';
            AdminGiftReport.supervisorApproverStatus.value = '';   
        }
         
        AdminGiftReport.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            AdminGiftReport.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            AdminGiftReport.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            AdminGiftReport.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            AdminGiftReport.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            AdminGiftReport.status.key = CG_Enum.ReportStatus.WaitingGLGC.name();
            AdminGiftReport.status.value = 'Waiting GLGC';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            AdminGiftReport.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            AdminGiftReport.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            AdminGiftReport.status.key = CG_Enum.ReportStatus.Success.name();
            AdminGiftReport.status.value = 'Success';            
        }
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            AdminGiftReport.status.key = CG_Enum.ReportStatus.Rejected.name();
            AdminGiftReport.status.value = 'Rejected';            
        }
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Cancel)) {
            AdminGiftReport.status.key = CG_Enum.ReportStatus.Cancel.name();
            AdminGiftReport.status.value = 'Cancel';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            AdminGiftReport.status.key = CG_Enum.ReportStatus.Expired.name();
            AdminGiftReport.status.value = 'Expired';            
        }
        
        if(string.isNotEmpty(CGReporting.Gift_Status__c) && CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
        	AdminGiftReport.giftStatus = CGReporting.Gift_Status__c;
        }
        else {
            AdminGiftReport.giftStatus = '';
        }
        
        AdminGiftReport.lastUpdated = CGReporting.LastModifiedDate;
        AdminGiftReport.submittedDate = CGReporting.Submitted_Date__c;
        
        AdminGiftReport.owner = CG_Global.assignToUserDTO(CGReporting.OwnerId);
        AdminGiftReport.canResend = checkCanResend(String.ValueOf(AdminGiftReport.status.key));
        AdminGiftReport.canCancel = checkCanCancel(String.ValueOf(AdminGiftReport.status.key));
        
        return AdminGiftReport;
    }
    
    @TestVisible
    private static CG_DTO.GiftReportDetailDTO assignToGiftReportDetailDTO(CG_Reporting__c CGReporting) {
        
        string userProfile = CG_PrivilegeHandler.getUserProfile();
        string userId = CG_PrivilegeHandler.getUserId();
        
        //Check privilege for current report
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
            if(userId != CGReporting.User__c) {
            	userProfile = String.ValueOf(CG_Enum.ApproverRole.Employee);
            }
        }
        
        CG_DTO.GiftReportDetailDTO GiftReportDetail = new CG_DTO.GiftReportDetailDTO();
        
        GiftReportDetail.id = CGReporting.Id;
        
        GiftReportDetail.reportType = new CG_Global.EnumValue('GiftRegistration');
        GiftReportDetail.reportType.key = 'GiftRegistration';
        GiftReportDetail.reportType.value = 'Gift Registration';
        
        GiftReportDetail.reportNumber = CGReporting.Running_No__c;
        GiftReportDetail.supervisorName = CGReporting.Supervisor_Name__c;
        
        GiftReportDetail.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            GiftReportDetail.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            GiftReportDetail.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            GiftReportDetail.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            GiftReportDetail.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            GiftReportDetail.status.key = CG_Enum.ReportStatus.WaitingGLGC.name();
            GiftReportDetail.status.value = 'Waiting GLGC';    
            
            if(userProfile != String.ValueOf(CG_Enum.ApproverRole.GLGC)) {
                GiftReportDetail.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            	GiftReportDetail.status.value = 'Waiting GLVP';    
            }
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            GiftReportDetail.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            GiftReportDetail.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            GiftReportDetail.status.key = CG_Enum.ReportStatus.Rejected.name();
            GiftReportDetail.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            GiftReportDetail.status.key = CG_Enum.ReportStatus.Success.name();
            GiftReportDetail.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            GiftReportDetail.status.key = CG_Enum.ReportStatus.Expired.name();
            GiftReportDetail.status.value = 'Expired';            
        }
        
        GiftReportDetail.lastUpdated = CGReporting.LastModifiedDate;
        GiftReportDetail.submittedDate = CGReporting.Submitted_Date__c;
        GiftReportDetail.reportedDate = CGReporting.Reported_Date__c;
        GiftReportDetail.submittedWithinDate = CGReporting.Submit_Within_Date__c;
        
        //Gift Items
        GiftReportDetail.giftItems = DeserializeGiftItems(CGReporting.Gift_Item__c);
        
        //Current Workflow
        GiftReportDetail.currentWorkflow = DeserializeCurrentWorkflowStatus(CGReporting);
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            PISUsers__c PISUser = CG_Global.assignToPISUser(CGReporting.OwnerId);
            GiftReportDetail.reportedByTH = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
            GiftReportDetail.reportedByEN = PISUser.EN_Fullname__c;
            GiftReportDetail.reportedByPositionTH = PISUser.OBJTHFULLNAME__c;
            GiftReportDetail.reportedByPositionEN = PISUser.OBJENFULLNAME__c;
            GiftReportDetail.reportedByCompanyTH = PISUser.COMPANYNAME__c;
            GiftReportDetail.reportedByCompanyEN = PISUser.COMPANYNAME__c;
            GiftReportDetail.reportedByEmployeeId = PISUser.EMPLOYEEID__c;
            GiftReportDetail.reportedBySection = PISUser.SECTIONS__c;
            GiftReportDetail.reportedByDepartment = PISUser.DEPARTMENT__c;
            GiftReportDetail.reportedByFunction = PISUser.FUNCTION__c;
        }
        else {
            GiftReportDetail.reportedByTH = CGReporting.Reported_By_TH__c;
            GiftReportDetail.reportedByEN = CGReporting.Reported_By_EN__c;
            GiftReportDetail.reportedByPositionTH = CGReporting.Reported_By_Position_TH__c;
            GiftReportDetail.reportedByPositionEN = CGReporting.Reported_By_Position_EN__c;
            GiftReportDetail.reportedByCompanyTH = CGReporting.Reported_By_Company_TH__c;
            GiftReportDetail.reportedByCompanyEN = CGReporting.Reported_By_Company_EN__c;
            GiftReportDetail.reportedByEmployeeId = CGReporting.Reported_By_Employee_Id__c;
            GiftReportDetail.reportedBySection = CGReporting.Reported_By_Section__c;
            GiftReportDetail.reportedByDepartment = CGReporting.Reported_By_Department__c;
            GiftReportDetail.reportedByFunction = CGReporting.Reported_By_Function__c;
        }
        
        //Supervisor
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            PISUsers__c PISUser = CG_Global.assignToPISUser(CGReporting.User__c);
            GiftReportDetail.supervisorActionByTH = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
            GiftReportDetail.supervisorActionByEN = PISUser.EN_Fullname__c;
            GiftReportDetail.supervisorActionByPositionTH = PISUser.OBJTHFULLNAME__c;
            GiftReportDetail.supervisorActionByPositionEN = PISUser.OBJENFULLNAME__c;
            GiftReportDetail.supervisorActionByCompanyTH = PISUser.COMPANYNAME__c;
            GiftReportDetail.supervisorActionByCompanyEN = PISUser.COMPANYNAME__c;
        	GiftReportDetail.supervisorActionDate = system.Datetime.now();
        }
        else {
            GiftReportDetail.supervisorActionByTH = CGReporting.Supervisor_Action_By_TH__c;
            GiftReportDetail.supervisorActionByEN = CGReporting.Supervisor_Action_By_EN__c;
            GiftReportDetail.supervisorActionByPositionTH = CGReporting.Supervisor_Action_By_Position_TH__c;
            GiftReportDetail.supervisorActionByPositionEN = CGReporting.Supervisor_Action_By_Position_EN__c;
            GiftReportDetail.supervisorActionByCompanyTH = CGReporting.Supervisor_Action_By_Company_TH__c;
            GiftReportDetail.supervisorActionByCompanyEN = CGReporting.Supervisor_Action_By_Company_EN__c;
            GiftReportDetail.supervisorActionDate = CGReporting.Supervisor_Action_Date__c;
        }
        
        GiftReportDetail.supervisorApproverStatus = new CG_Global.EnumValue(CGReporting.Supervisor_Approver_Status__c);
        if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged)) {
            GiftReportDetail.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Acknowledged.name();
            GiftReportDetail.supervisorApproverStatus.value = CG_Enum.ApproverStatus.Acknowledged.name();
        }
        else if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Rejected)) {
            GiftReportDetail.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Rejected.name();
            GiftReportDetail.supervisorApproverStatus.value = CG_Enum.ApproverStatus.Rejected.name();
        }
        
        GiftReportDetail.supervisorComment = CGReporting.Supervisor_Comment__c;
        
        //GLVP
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            
            List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
            
            if(GLVPPISUsers.size() > 0) {
                if(GLVPPISUsers != null) {
                    for(PISUsers__c GLVP : GLVPPISUsers) {
                        if(userId == GLVP.User__c) {
                            GiftReportDetail.glvpActionByTH = GLVP.THTITLE__c + ' ' + GLVP.THFIRSTNAME__c + ' ' + GLVP.THLASTNAME__c;
                            GiftReportDetail.glvpActionByEN = GLVP.EN_Fullname__c;
                            GiftReportDetail.glvpActionByPositionTH = GLVP.OBJTHFULLNAME__c;
                            GiftReportDetail.glvpActionByPositionEN = GLVP.OBJENFULLNAME__c;
                            GiftReportDetail.glvpActionByCompanyTH = GLVP.COMPANYNAME__c;
                            GiftReportDetail.glvpActionByCompanyEN = GLVP.COMPANYNAME__c;
                            GiftReportDetail.glvpActionDate = system.Datetime.now();
                        }
                    }
                }
            }
        }
        else {
            GiftReportDetail.glvpActionByTH = CGReporting.GLVP_Action_By_TH__c;
            GiftReportDetail.glvpActionByEN = CGReporting.GLVP_Action_By_EN__c;
            GiftReportDetail.glvpActionByPositionTH = CGReporting.GLVP_Action_By_Position_TH__c;
            GiftReportDetail.glvpActionByPositionEN = CGReporting.GLVP_Action_By_Position_EN__c;
            GiftReportDetail.glvpActionByCompanyTH = CGReporting.GLVP_Action_By_Company_TH__c;
            GiftReportDetail.glvpActionByCompanyEN = CGReporting.GLVP_Action_By_Company_EN__c;
            GiftReportDetail.glvpActionDate = CGReporting.GLVP_Action_Date__c;
        }
        
        GiftReportDetail.glvpApproverStatus = new CG_Global.EnumValue(CGReporting.GLVP_Approver_Status__c);
        if(CGReporting.GLVP_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged)) {
            GiftReportDetail.glvpApproverStatus.key = CG_Enum.ApproverStatus.Acknowledged.name();
            GiftReportDetail.glvpApproverStatus.value = CG_Enum.ApproverStatus.Acknowledged.name();
        }
        else if(CGReporting.GLVP_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Rejected)) {
            GiftReportDetail.glvpApproverStatus.key = CG_Enum.ApproverStatus.Rejected.name();
            GiftReportDetail.glvpApproverStatus.value = CG_Enum.ApproverStatus.Rejected.name();
        }
        
        GiftReportDetail.glvpComment = CGReporting.GLVP_Comment__c;
        
        //GLGC 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            
            List<PISUsers__c> GLGCPISUsers = CG_Global.assignToGLGCPISUser();
            
            if(GLGCPISUsers != null) {
                if(GLGCPISUsers.size() > 0) {
                    for(PISUsers__c GLGC : GLGCPISUsers) {
                        if(userId == GLGC.User__c) {
                            GiftReportDetail.glgcActionByTH = GLGC.THTITLE__c + ' ' + GLGC.THFIRSTNAME__c + ' ' + GLGC.THLASTNAME__c;
                            GiftReportDetail.glgcActionByEN = GLGC.EN_Fullname__c;
                            GiftReportDetail.glgcActionByPositionTH = GLGC.OBJTHFULLNAME__c;
                            GiftReportDetail.glgcActionByPositionEN = GLGC.OBJENFULLNAME__c;
                            GiftReportDetail.glgcActionByCompanyTH = GLGC.COMPANYNAME__c;
                            GiftReportDetail.glgcActionByCompanyEN = GLGC.COMPANYNAME__c;
                            GiftReportDetail.glgcActionDate = system.Datetime.now();
                        }
                    }
                }
            }
        }
        else {
            GiftReportDetail.glgcReceiveBy = CGReporting.GLGC_Receive_By__c;
            GiftReportDetail.glgcActionByTH = CGReporting.GLGC_Action_By_TH__c;
            GiftReportDetail.glgcActionByEN = CGReporting.GLGC_Action_By_EN__c;
            GiftReportDetail.glgcActionByPositionTH = CGReporting.GLGC_Action_By_Position_TH__c;
            GiftReportDetail.glgcActionByPositionEN = CGReporting.GLGC_Action_By_Position_EN__c;
            GiftReportDetail.glgcActionByCompanyTH = CGReporting.GLGC_Action_By_Company_TH__c;
            GiftReportDetail.glgcActionByCompanyEN = CGReporting.GLGC_Action_By_Company_TH__c;
            GiftReportDetail.glgcActionDate = CGReporting.GLGC_Action_Date__c;
        }
        
        GiftReportDetail.glgcApproverStatus = new CG_Global.EnumValue(CGReporting.GLGC_Approver_Status__c);
        if(CGReporting.GLGC_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged)) {
            GiftReportDetail.glgcApproverStatus.key = CG_Enum.ApproverStatus.Acknowledged.name();
            GiftReportDetail.glgcApproverStatus.value = CG_Enum.ApproverStatus.Acknowledged.name();
        }       
        
        GiftReportDetail.glgcReceivedBy = CGReporting.GLGC_Receive_By__c;
            
        GiftReportDetail.canEdit = checkCanEdit(String.ValueOf(CGReporting.Status__c));
        GiftReportDetail.canSubmit = checkCanSubmit(String.ValueOf(CGReporting.Status__c), userProfile);
        
        GiftReportDetail.canSupervisorAcknowledge = false;
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.Supervisor) || userProfile == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
        	GiftReportDetail.canSupervisorAcknowledge = checkCanSupervisorAcknowledge(String.ValueOf(CGReporting.Status__c));
        }
        
        GiftReportDetail.canGLGCAcknowledge = false;
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.GLGC) || userProfile == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
        	GiftReportDetail.canGLGCAcknowledge = checkCanGLGCAcknowledge(String.ValueOf(CGReporting.Status__c));
        }
        
        GiftReportDetail.canGLVPAcknowledge = false;
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.GLVP) || userProfile == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
        	GiftReportDetail.canGLVPAcknowledge = checkCanGLVPAcknowledge(String.ValueOf(CGReporting.Status__c));
        }
        
        GiftReportDetail.isShowSupervisorComment = checkShowSupervisorComment(String.ValueOf(CGReporting.Status__c));
        
        GiftReportDetail.isShowSuperGLGCComment = false;
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.GLGC) || userProfile == String.ValueOf(CG_Enum.ApproverRole.GLVP) || userProfile == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
        	GiftReportDetail.isShowSuperGLGCComment = checkShowGLGCComment(String.ValueOf(CGReporting.Status__c));
        }
        
        GiftReportDetail.isShowSuperGLVPComment = false;
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.GLVP) || userProfile == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
        	GiftReportDetail.isShowSuperGLVPComment = checkShowGLVPComment(String.ValueOf(CGReporting.Status__c));
        }
        
        //Privilege for Owner
        if(userId == CGReporting.OwnerId) {
            GiftReportDetail.isShowSuperGLVPComment = checkShowGLVPComment(String.ValueOf(CGReporting.Status__c));
        }
        
        GiftReportDetail.isShowGiftStatus = checkShowGiftStatus(String.ValueOf(CGReporting.Status__c));
        
        return GiftReportDetail;
    }
    
    //Other Logic
    @TestVisible
    private static boolean checkCanEdit(string status) {
        boolean canEdit = false;
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) || 
            status == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            canEdit = true;
        }
        return canEdit;
    }
    
    @TestVisible
    private static boolean checkCanDelete(string status) {
        boolean canDelete = false;
        
         if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) || 
            status == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            canDelete = true;
        }
        
        return canDelete;
    }
    
    @TestVisible
    private static boolean checkCanSubmit(string status, string userProfile) {
        boolean canSubmit = false;
        
        //Check whether user can submit with current status
        
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.Employee) && status == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)
          || userProfile == String.ValueOf(CG_Enum.ApproverRole.Employee) && status == String.ValueOf(CG_Enum.ReportStatus.Rejected)
          || userProfile == String.ValueOf(CG_Enum.ApproverRole.Supervisor) && status == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)
          || userProfile == String.ValueOf(CG_Enum.ApproverRole.GLGC) && status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)
          || userProfile == String.ValueOf(CG_Enum.ApproverRole.GLVP) && status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            canSubmit = true;
        }
        else if(userProfile == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
            canSubmit = true;
        }
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.Success) && userProfile != String.ValueOf(CG_Enum.ApproverRole.GLGC)) {
            canSubmit = false;
        }
        else if(status == String.ValueOf(CG_Enum.ReportStatus.Success) && userProfile == String.ValueOf(CG_Enum.ApproverRole.GLGC)) {
            canSubmit = true;
        }
        
        return canSubmit;
    }
    
    @TestVisible
    private static boolean checkCanResend(string status) {
        boolean canResend = false;
        if(status != String.ValueOf(CG_Enum.ReportStatus.Success) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Cancel) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            canResend = true;
        }
        return canResend;
    }
    
    @TestVisible
    private static boolean checkCanCancel(string status) {
        boolean canCancel = false;
        if(status != String.ValueOf(CG_Enum.ReportStatus.Success) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Cancel) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            canCancel = true;
        }
        return canCancel;
    }
       
    @TestVisible 
    private static string assignSupervisorWhenEmployeeSubmit(string reportId, string statusJSON, string supervisorId) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(statusJSON, CG_DTO.WorkflowHistoryDTO.class);
        workflowHistoryDTO.reportId = reportId;
        
        CG_DTO.WorkflowDTO currentWorkflow = workflowHistoryDTO.currentWorkflow;
        currentWorkflow.submittedDate = system.datetime.now();
        
        for(CG_DTO.WorkflowApproverDTO approver : currentWorkflow.approvers) {
            if(approver.status.key == CG_Enum.ApproverStatus.WaitingForSubmit.name()) {
                approver.isCurrent = false;
                approver.actionDate = system.Datetime.now();
                
                approver.status = new CG_Global.EnumValue('ApproverStatus');
                approver.status.key = CG_Enum.ApproverStatus.Submitted.name();
                approver.status.value = 'Submitted';
            }
            else if(approver.status.key == CG_Enum.ApproverStatus.WaitingSupervisor.name()) {
                approver.isCurrent = true;
                approver.approver = CG_Global.assignToUserDTO(supervisorId);
                
                CG_Global.EnumValue status = new CG_Global.EnumValue('WaitingSupervisor');
                status.enumName = 'WaitingSupervisor';
                status.key = 'WaitingSupervisor';
                status.value = 'Waiting Supervisor';
                
                workflowHistoryDTO.status = status;
            }
        }
        
        
        string result = JSON.serialize(workflowHistoryDTO);
        return result;
        
    }
    
    @TestVisible
    private static string assignGLGCWhenSupervisorSubmit(string submitAs, string comment, string ownerId, string statusJSON) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(statusJSON, CG_DTO.WorkflowHistoryDTO.class);
        
        CG_DTO.WorkflowDTO currentWorkflow = workflowHistoryDTO.currentWorkflow;
        
        if(submitAs == 'Acknowledged') {
            
            workflowHistoryDTO.status = new CG_Global.EnumValue('ReportStatus');
            workflowHistoryDTO.status.key = CG_Enum.ReportStatus.WaitingGLGC.name();
            workflowHistoryDTO.status.value = 'Waiting GLGC';
            
            for(CG_DTO.WorkflowApproverDTO approver : currentWorkflow.approvers) {
                if(approver.status.key == CG_Enum.ApproverStatus.WaitingSupervisor.name() &&
                  	approver.role.key == CG_Enum.ApproverRole.Supervisor.name()) {
                    approver.isCurrent = false;
                    approver.actionDate = system.Datetime.now();
                    approver.comment = comment;
                    
                    approver.status = new CG_Global.EnumValue('ApproverStatus');
                    approver.status.key = CG_Enum.ApproverStatus.Acknowledged.name();
                    approver.status.value = 'Acknowledged';
                    
                }
                else if(approver.status.key == CG_Enum.ApproverStatus.WaitingGLGC.name()) {
                    approver.isCurrent = true;
                    
                    CG_Global.EnumValue status = new CG_Global.EnumValue('WaitingGLGC');
                    status.enumName = 'WaitingGLGC';
                    status.key = 'WaitingGLGC';
                    status.value = 'Waiting GLGC';
                    
                    workflowHistoryDTO.status = status;
                }
                
            }
            
        }
        else if(submitAs == 'Rejected') {
            workflowHistoryDTO.status = new CG_Global.EnumValue('ReportStatus');
            workflowHistoryDTO.status.key = CG_Enum.ReportStatus.Rejected.name();
            workflowHistoryDTO.status.value = 'Rejected';
            
            for(CG_DTO.WorkflowApproverDTO approver : currentWorkflow.approvers) {
                if(approver.status.key == CG_Enum.ApproverStatus.WaitingSupervisor.name()) {
                    approver.isCurrent = false;
                    approver.actionDate = system.Datetime.now();
                    approver.comment = comment;
                    
                    approver.status = new CG_Global.EnumValue('ApproverStatus');
                    approver.status.key = CG_Enum.ApproverStatus.Rejected.name();
                    approver.status.value = 'Rejected';
                }
            }
            
            //Remove GLGC user from current flow
            currentWorkflow.approvers.remove(2);
            //Remove GLVP user from current flow
            currentWorkflow.approvers.remove(2);
            
            //Keep in HistoryWorkflow
            if(workflowHistoryDTO.historyWorkflows == null) {
                workflowHistoryDTO.historyWorkflows = new List<CG_DTO.WorkflowDTO>();
            }
            workflowHistoryDTO.historyWorkflows.add(currentWorkflow);
            
            //New HistoryWorkflow
            CG_DTO.WorkflowHistoryDTO WorkflowHistory = new CG_DTO.WorkflowHistoryDTO();
        
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
            
            PISUsers__c PISUser = CG_Global.assignToPISUser(ownerId);
            approver.approver = new CG_DTO.UserDTO();
            approver.approver.id = PISUser.User__c;
            approver.approver.fullName = PISUser.EN_Fullname__c ;
            approver.approver.email = PISUser.Email__c;
            
            workflow.approvers.add(approver);
            approver = new CG_DTO.WorkflowApproverDTO();
            approver.role = new CG_Global.EnumValue('ApproverRole');
            approver.role.key = CG_Enum.ApproverRole.Supervisor.name();
            approver.role.value = CG_Enum.ApproverRole.Supervisor.name();
            approver.status = new CG_Global.EnumValue('ApproverStatus');
            approver.status.key = CG_Enum.ApproverStatus.WaitingSupervisor.name();
            approver.status.value = 'Waiting Supervisor';
            approver.approver = new CG_DTO.UserDTO();
            approver.approver.id = '';
            approver.approver.fullName = '' ;
            approver.approver.email = '';
            workflow.approvers.add(approver);
            approver = new CG_DTO.WorkflowApproverDTO();
            approver.role = new CG_Global.EnumValue('ApproverRole');
            approver.role.key = CG_Enum.ApproverRole.GLGC.name();
            approver.role.value = CG_Enum.ApproverRole.GLGC.name();
            approver.status = new CG_Global.EnumValue('ApproverStatus');
            approver.status.key = CG_Enum.ApproverStatus.WaitingGLGC.name();
            approver.status.value = 'Waiting GLGC';
            approver.approver = new CG_DTO.UserDTO();
            approver.approver.id = '';
            approver.approver.fullName = '' ;
            approver.approver.email = '';
            workflow.approvers.add(approver);
            approver = new CG_DTO.WorkflowApproverDTO();
            approver.role = new CG_Global.EnumValue('ApproverRole');
            approver.role.key = CG_Enum.ApproverRole.GLVP.name();
            approver.role.value = CG_Enum.ApproverRole.GLVP.name();
            approver.status = new CG_Global.EnumValue('ApproverStatus');
            approver.status.key = CG_Enum.ApproverStatus.WaitingGLVP.name();
            approver.status.value = 'Waiting GLVP';
            approver.approver = new CG_DTO.UserDTO();
            approver.approver.id = '';
            approver.approver.fullName = '' ;
            approver.approver.email = '';
            workflow.approvers.add(approver);
            
            workflowHistoryDTO.currentWorkflow = workflow;
        }
        
        string result = JSON.serialize(workflowHistoryDTO);
        return result;
        
    }
    
    @TestVisible
    private static string assignGLVPWhenGLGCSubmit(string submitAs, string comment, string glgcId, string statusJSON) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(statusJSON, CG_DTO.WorkflowHistoryDTO.class);
        
        CG_DTO.WorkflowDTO currentWorkflow = workflowHistoryDTO.currentWorkflow;
        
        if(submitAs == 'Acknowledged') {
            
            workflowHistoryDTO.status = new CG_Global.EnumValue('ReportStatus');
            workflowHistoryDTO.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            workflowHistoryDTO.status.value = 'Waiting GLVP';
            
            for(CG_DTO.WorkflowApproverDTO approver : currentWorkflow.approvers) {
                if(approver.status.key == CG_Enum.ApproverStatus.WaitingGLGC.name() &&
                  	approver.role.key == CG_Enum.ApproverRole.GLGC.name()) {
                    approver.isCurrent = false;
                    approver.actionDate = system.Datetime.now();
                    approver.comment = comment;
                    approver.approver = new CG_DTO.UserDTO();
                    approver.approver = CG_Global.assignToUserDTO(glgcId);
                    
                    approver.status = new CG_Global.EnumValue('ApproverStatus');
                    approver.status.key = CG_Enum.ApproverStatus.Acknowledged.name();
                    approver.status.value = 'Acknowledged';
                    
                }
                else if(approver.status.key == CG_Enum.ApproverStatus.WaitingGLVP.name()) {
                    approver.isCurrent = true;
                    
                    CG_Global.EnumValue status = new CG_Global.EnumValue('WaitingGLVP');
                    status.enumName = 'WaitingGLVP';
                    status.key = 'WaitingGLVP';
                    status.value = 'Waiting GLVP';
                    
                    workflowHistoryDTO.status = status;
                }
                
            }
            
        }
        
        string result = JSON.serialize(workflowHistoryDTO);
        return result;
        
    }
    
    @TestVisible
    private static string assignSuccessWhenGLVPSubmit(string submitAs, string glvpId, string statusJSON) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(statusJSON, CG_DTO.WorkflowHistoryDTO.class);
        
        CG_DTO.WorkflowDTO currentWorkflow = workflowHistoryDTO.currentWorkflow;
        
        if(submitAs == 'Acknowledged') {
            
            workflowHistoryDTO.status = new CG_Global.EnumValue('ReportStatus');
            workflowHistoryDTO.status.key = CG_Enum.ReportStatus.Success.name();
            workflowHistoryDTO.status.value = 'Success';
            
            for(CG_DTO.WorkflowApproverDTO approver : currentWorkflow.approvers) {
                if(approver.status.key == CG_Enum.ApproverStatus.WaitingGLVP.name() &&
                  	approver.role.key == CG_Enum.ApproverRole.GLVP.name()) {
                    approver.isCurrent = false;
                    approver.actionDate = system.Datetime.now();
                    approver.status = new CG_Global.EnumValue('ApproverStatus');
                    approver.status.key = CG_Enum.ApproverStatus.Acknowledged.name();
                    approver.status.value = 'Acknowledged';
                    approver.approver = new CG_DTO.UserDTO();
                    approver.approver = CG_Global.assignToUserDTO(glvpId);
                }
                
            }
            
            //Add to HistoryWorkflow
            if(workflowHistoryDTO.historyWorkflows == null) {
                workflowHistoryDTO.historyWorkflows = new List<CG_DTO.WorkflowDTO>();
            }
            
            workflowHistoryDTO.historyWorkflows.add(currentWorkflow);
            
        }
        
        string result = JSON.serialize(workflowHistoryDTO);
        return result;
        
    }
    
    @TestVisible
    private static CG_DTO.WorkflowDTO DeserializeCurrentWorkflowStatus(CG_Reporting__c CGReport) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(CGReport.Status_JSON__c, CG_DTO.WorkflowHistoryDTO.class);
        
        if(workflowHistoryDTO.currentWorkflow.approvers == null) {
            workflowHistoryDTO.currentWorkflow.approvers = new List<CG_DTO.WorkflowApproverDTO>();
        }
        else {
            
            string currentUserRole = CG_PrivilegeHandler.getUserProfile();
            
            string currentStatus = CGReport.Status__c;
            
            for(CG_DTO.WorkflowApproverDTO currentWorkflow : workflowHistoryDTO.currentWorkflow.approvers) {
                
                currentWorkflow.isShow = isShowStatus(currentUserRole, currentWorkflow.role.key);
                
                if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Employee) && 
                   (currentStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) || 
                    currentStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor) || 
                    currentStatus == String.ValueOf(CG_Enum.ReportStatus.Rejected))
                   && currentWorkflow.role.key == String.ValueOf(CG_Enum.ApproverRole.GLVP))  {
                	currentWorkflow.isShow = false;       
                }
                
            }
        }
        
        return workflowHistoryDTO.currentWorkflow;
        
    }
    
    @TestVisible
    private static CG_DTO.WorkflowHistoryDTO DeserializeWorkflowHistory(string workflowStatusJson) {
        
        string currentUserRole = CG_PrivilegeHandler.getUserProfile();
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(workflowStatusJson, CG_DTO.WorkflowHistoryDTO.class);
		
        string currentStatus = '';
        
        for(CG_DTO.WorkflowApproverDTO currentWorkflow : workflowHistoryDTO.currentWorkflow.approvers) {
        
            if(currentWorkflow.isCurrent) {
                currentStatus = currentWorkflow.status.key;
                
                if(currentUserRole != String.ValueOf(CG_Enum.ApproverRole.GLGC) && currentWorkflow.status.key == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                    workflowHistoryDTO.status.key = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
                    workflowHistoryDTO.status.value = 'Waiting GLVP';
                }
                
                break;
            }
        }
        
        //Flow Box
        for(CG_DTO.WorkflowApproverDTO currentWorkflow : workflowHistoryDTO.currentWorkflow.approvers) {
            currentWorkflow.isShow = isShowStatusInHistory(currentUserRole, currentWorkflow.role.key);
            
            if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Employee) && currentStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)
               && currentWorkflow.role.key == String.ValueOf(CG_Enum.ApproverRole.GLVP))  {
                   currentWorkflow.isShow = false;  
            }
            else if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Employee) && currentStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)
               && currentWorkflow.role.key == String.ValueOf(CG_Enum.ApproverRole.GLVP))  {
                   currentWorkflow.isShow = false;  
            }
        }
        
        //History Box
        if(workflowHistoryDTO.historyWorkflows != null) {
            for(CG_DTO.WorkflowDTO currentWorkflow : workflowHistoryDTO.historyWorkflows) {
                
                for(CG_DTO.WorkflowApproverDTO cw : currentWorkflow.approvers) {
                	
                    cw.isShow = isShowStatusInHistory(currentUserRole, cw.role.key);
                }
                
            }
        }
        
        return workflowHistoryDTO;
    }
    
    @TestVisible
    private static List<CG_DTO.GiftItemDTO> DeserializeGiftItems(string giftItems) {
        
        List<CG_DTO.GiftItemDTO> giftItemsDTO = (List<CG_DTO.GiftItemDTO>)JSON.deserialize(giftItems, List<CG_DTO.GiftItemDTO>.class);
        
        return giftItemsDTO;
        
    }
    
    @TestVisible
    private static string SerializeGiftItems(List<CG_DTO.GiftItemDTO> giftItems, string status) {
        
        if(giftItems.size() > 0) {
            for(CG_DTO.GiftItemDTO giftItem : giftItems) {
                
                if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                    giftItem.giftStatus = new CG_Global.EnumValue('GiftStatus');
                    giftItem.giftStatus.key = CG_Enum.GiftStatus.InStock.name();
                    giftItem.giftStatus.value = 'In Stock';
                }
                
            }
        }
        
        string giftItemJson = JSON.serialize(giftItems);
        
        return giftItemJson;
        
    }
    
    @TestVisible
    private static string UpdateGiftItems(List<CG_DTO.GiftItemDTO> giftItems) {
        
        string giftItemJson = JSON.serialize(giftItems);
        return giftItemJson;
        
    }
    
    @TestVisible
    private static string GetGiftStatus(List<CG_DTO.GiftItemDTO> giftItems) {

        integer InStockCount = 0;
        integer DonatedCount = 0;
        integer TotalGiftCount = 0;
        string giftStatus = '';
        
        if(giftItems.size() > 0) {
            TotalGiftCount = giftItems.size();
            for(CG_DTO.GiftItemDTO giftItem : giftItems) {
                if(giftItem.giftStatus.key == String.ValueOf(CG_Enum.GiftStatus.InStock)) {
                    InStockCount++;
                }
                else if(giftItem.giftStatus.key == String.ValueOf(CG_Enum.GiftStatus.Donated)) {
                    DonatedCount++;
                }
            }
        }
        
        if(TotalGiftCount == DonatedCount) {
            giftStatus = String.ValueOf(CG_Enum.GiftStatus.Donated);
        }
        else {
            giftStatus = String.ValueOf(CG_Enum.GiftStatus.InStock);
        }
        
        return giftStatus;
        
    }
    
    @TestVisible
    private static boolean checkCanSupervisorAcknowledge(string status) {
        boolean canAcknowledge = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
           canAcknowledge = true;
        }
        
        return canAcknowledge;
    }
    
    @TestVisible
    private static boolean checkCanGLGCAcknowledge(string status) {
        boolean canAcknowledge = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
           canAcknowledge = true;
        }
        
        return canAcknowledge;
    }
    
    @TestVisible
    private static boolean checkCanGLVPAcknowledge(string status) {
        boolean canAcknowledge = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
           canAcknowledge = true;
        }
        
        return canAcknowledge;
    }
    
    @TestVisible
    private static boolean checkShowSupervisorComment(string status) {
        boolean canShowComment = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor) || 
          	status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC) ||
          	status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP) ||
          	status == String.ValueOf(CG_Enum.ReportStatus.Success)) {
           canShowComment = true;
        }
        return canShowComment;
    }
    
    @TestVisible
    private static boolean checkShowGLGCComment(string status) {
        boolean canShowComment = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC) ||
           	status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP) ||
          	status == String.ValueOf(CG_Enum.ReportStatus.Success)) {
           canShowComment = true;
        }
        
        return canShowComment;
    }
    
    @TestVisible
    private static boolean checkShowGLVPComment(string status) {
        boolean canShowComment = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP) ||
          	status == String.ValueOf(CG_Enum.ReportStatus.Success)) {
           canShowComment = true;
        }
        
        return canShowComment;
    }
    
    @TestVisible
    private static boolean checkShowGiftStatus(string status) {
        
        string userProfile = CG_PrivilegeHandler.getUserProfile();
        boolean canShowGiftStatus = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.Success)) {
           canShowGiftStatus = true;
        }
        
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.GLVP)) {
            canShowGiftStatus = false;
        }
        
        return canShowGiftStatus;
    }
    
    @TestVisible
    private static boolean isShowStatus(string currentUserRole, string role) {
        
        boolean isShow = false;
        
        if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Employee)) {
            
            if(role == String.ValueOf(CG_Enum.ApproverRole.Employee)
               || role == String.ValueOf(CG_Enum.ApproverRole.Supervisor)
               || role == String.ValueOf(CG_Enum.ApproverRole.GLVP)) {
                isShow = true;
            }
            else if(role == String.ValueOf(CG_Enum.ApproverRole.GLGC)) {
                isShow = false;
            }
        }
        else if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
        	if(role == String.ValueOf(CG_Enum.ApproverRole.Employee)
               || role == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
                isShow = true;
            }
        }
        else if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.GLGC)
               || currentUserRole == String.ValueOf(CG_Enum.ApproverRole.GLVP)
               || currentUserRole == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
        	isShow = true;
        }
        
        return isShow;
        
    }
    
    @TestVisible
    private static boolean isShowStatusInHistory(string currentUserRole, string role) {
        
        boolean isShow = false;
        if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Employee)) {
            
            if(role == String.ValueOf(CG_Enum.ApproverRole.Employee)
               || role == String.ValueOf(CG_Enum.ApproverRole.Supervisor)
               || role == String.ValueOf(CG_Enum.ApproverRole.GLVP)) {
                isShow = true;
            }
            else if(role == String.ValueOf(CG_Enum.ApproverRole.GLGC)) {
                isShow = false;
            }
        }
        else if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
        	if(role == String.ValueOf(CG_Enum.ApproverRole.Employee)
               || role == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
                isShow = true;
            }
        }
        else if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.GLGC)
               || currentUserRole == String.ValueOf(CG_Enum.ApproverRole.GLVP)
               || currentUserRole == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
        	isShow = true;
        }
        
        return isShow;
        
    }
    
    @RemoteAction
    public static List<CG_DTO.CompanyDTO> CGGlobal_GetCompanies() {
        List<CG_DTO.CompanyDTO> Companies = CG_Global.GetCompanies();
        return Companies;
    } 
    
    @RemoteAction
    public static List<string> CGGlobal_GetFunctions(string companyId) {
        List<string> Functions = CG_Global.GetFunctions(companyId);
        return Functions;
    }
    
    @RemoteAction
    public static List<string> CGGlobal_GetDepartments(string function) {
        List<string> Departments = CG_Global.GetDepartments(function);
        return Departments;
    }  
    
    @RemoteAction
    public static List<string> CGGlobal_GetSections(string department) {
        List<string> Sections = CG_Global.GetSections(department);
        return Sections;
    }  
    
    @RemoteAction
    public static List<string> CGGlobal_GetUnits(string section) {
        List<string> Units = CG_Global.GetUnits(section);
        return Units;
    } 
    
    public class ReportGiftSearchCriteria {
        //enum ReportStatus
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public datetime startDate {get;set;}
        @RemoteAction
        public datetime endDate {get;set;}
        @RemoteAction
        public string giftStatus {get;set;}
        @RemoteAction
        public string companyId {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
    }
    
}