/* 
 * Author Softever
 */

global with sharing class CG_COI_Reporting  {

    private static List<CG_DTO.COIReportListDTO> incidentListDTOs;
    private static CG_DTO.COIReportListDTO newEmployeeDTO;
    private static CG_DTO.COIReportListDTO annualDTO;
    private static CG_DTO.COIReportDetailDTO reportDetail;
    private static List<CG_DTO.WorkflowHistoryDTO> workflowHistories;
    private static List<CG_DTO.COIReportHistoryListDTO> reportHistoryList;
    private static CG_DTO.COIReportHistoryCountDTO reportHistoryCount;
    private static List<CG_DTO.COIMassAcknowledgeListDTO> massAcknowledgeList;
    private static CG_DTO.COIMassAcknowledgeCountDTO massAcknowledgeCount;
    private static List<CG_DTO.AdminCOIReportListDTO> adminCOIReportListDTOs;
    private static CG_DTO.AdminCOIReportListCountDTO adminCOIReportListCount;
    
    //Report
    private static CG_DTO.ReportCOISummaryCountDTO reportCOISummaryCount;
    private static CG_DTO.ReportCOIAnswerChartSeriesDTO reportCOIAnswerChartSeries;
    private static List<CG_DTO.ReportCOITypeRadialChartItemDTO> reportCOITypeRadialChartItems;
    private static CG_DTO.ReportCOIStatusSeriesDTO reportCOIStatusSeries;
    private static List<CG_DTO.ReportCOIInfoDTO> reportCOIInfoList;
    private static CG_DTO.ReportCOIStatisticDTO reportCOIStatistics;
    
    static {
        CG_COI_Reporting.InitializeIncidentListData();
    }
    
    //Check whether user has privilege to access particular record or not
    @RemoteAction
    public static boolean CheckAccessPrivilege(string reportId) {
        boolean canAccess = CG_PrivilegeHandler.checkAccessPrivilege(reportId);
        return canAccess;
    }
    
    //Get All Incident Report
    private static void InitializeIncidentListData() {
        
        incidentListDTOs = new List<CG_DTO.COIReportListDTO>();
        
        string userProfile = CG_PrivilegeHandler.getUserProfile();
        string userId = CG_PrivilegeHandler.getUserId();
        List<string> COIRTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual),
            									String.ValueOf(CG_Enum.COIReportType.COIIncident),
            									String.ValueOf(CG_Enum.COIReportType.COINewEmployee)};
        
        List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();
        
        CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                              End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                              Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, COI_Action__c,
                                              COI_Detail__c from CG_Reporting__c
                                              where OwnerId =: userId AND Type_Of_Report__c IN: COIRTs order by Createddate asc];
        
        if(CGReportings.size() > 0) {
            
            for(CG_Reporting__c CGReporting : CGReportings) {
                
                CG_DTO.COIReportListDTO COIReportDTO = new CG_DTO.COIReportListDTO();
                COIReportDTO = assignToCOIReportListDTO(CGReporting);
                incidentListDTOs.add(COIReportDTO);
                
            }
            
        }
            
        //return incidentListDTOs;
        
    }
    
    //Count all incident (for paging purpose)
    @RemoteAction
    public static Integer GetIncidentReportCount() {
        
        integer incidentCount = 0;
        
        string userId = CG_PrivilegeHandler.getUserId();
        
        Date SD = Date.newInstance( date.today().year(), 1, 1 );
        Date ED = Date.newInstance( date.today().year(), 12, 31 );
        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> COITypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIIncident)};
        //List<string> Statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Success) };
            
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                            'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                            'where OwnerId =: userId AND Type_Of_Report__c IN: COITypes AND ' +
            				'Start_Duration__c >=: SD AND Start_Duration__c <=: ED ';
        
        CGReports = database.query(query);
        
        if(CGReports.size() > 0) {
            incidentCount = CGReports.size();
        }
        
        return incidentCount;
    }
    
    //Query Incident Table Data of logined user including paging and sorting
    @RemoteAction
    public static List<CG_DTO.COIReportListDTO> GetIncidentReports(
        //reportNumber, supervisorName, status, duration, submittedDate
        CG_Global.SortByParam sortByParam, 
        CG_Global.PageParam pageParam) {

        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageSize = 1;
            pageParam.pageNo = 1;
        }
            
        Date SD = Date.newInstance( date.today().year(), 1, 1 );
        Date ED = Date.newInstance( date.today().year(), 12, 31 );
            
        incidentListDTOs = new List<CG_DTO.COIReportListDTO>();
        string userId = CG_PrivilegeHandler.getUserId();
        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> COITypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIIncident)};
        //List<string> Statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Success) };
            
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                            'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                            'where OwnerId =: userId AND Type_Of_Report__c IN: COITypes AND ' +
            				'Start_Duration__c >=: SD AND Start_Duration__c <=: ED';
            
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
            else if(sortByParam.sortBy == 'duration') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Start_Duration__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Start_Duration__c desc');
                }
            }
            else if(sortByParam.sortBy == 'disclosureReport') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by COI_Disclosure__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by COI_Disclosure__c desc');
                }
            }
            else {
                CGReports = database.query(query + ' order by Running_No__c desc');
            }
            
            if(CGReports.size() > 0) {
            
            	for(CG_Reporting__c CGReporting : CGReports) {
                    CG_DTO.COIReportListDTO COIReportDTO = new CG_DTO.COIReportListDTO();
                    COIReportDTO = assignToCOIReportListDTO(CGReporting);
                    incidentListDTOs.add(COIReportDTO);
                    
                }
                
            }
            
            List<CG_DTO.COIReportListDTO> results = new List<CG_DTO.COIReportListDTO>();
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            integer totalSize = incidentListDTOs.size() - startIndex;
            
            for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                if (i < totalSize){
                    results.add(incidentListDTOs[startIndex + i]);
                }else{
                    break;
                }
            }   
            
        
        return results;
    }
    
    //Query New Employee Report of logined user (if not exists, return null)
    @RemoteAction
    public static CG_DTO.COIReportListDTO GetNewEmployeeReport() {
        
        string userId = CG_PrivilegeHandler.getUserId();
        
        Date SD = Date.newInstance( date.today().year(), 1, 1 );
        Date ED = Date.newInstance( date.today().year(), 12, 31 );
            
        List<string> COITypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COINewEmployee)};
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                            'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                            'where OwnerId =: userId AND Type_Of_Report__c IN: COITypes AND ' +
            				'Start_Duration__c >=: SD AND Start_Duration__c <=: ED order by Createddate desc';
            
        CGReports = database.query(query);
            
        if(CGReports.size() > 0) {
            
            newEmployeeDTO = new CG_DTO.COIReportListDTO();
            newEmployeeDTO = assignToCOIReportListDTO(CGReports[0]);
            
            NewEmployeeDTO.badge = 0;
            
            if(NewEmployeeDTO.status.key == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                NewEmployeeDTO.badge = 1;
            }
                    
        }
        
        return newEmployeeDTO;
    }

    //Query Annual Report of logined user (if not exists, return null)
    @RemoteAction
    public static CG_DTO.COIReportListDTO GetAnnualReport() {
        
        string userId = CG_PrivilegeHandler.getUserId();
        
        Date SD = Date.newInstance( date.today().year(), 1, 1 );
        Date ED = Date.newInstance( date.today().year(), 12, 31 );
            
        List<string> COITypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual)};
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                            'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                            'where OwnerId =: userId AND Type_Of_Report__c IN: COITypes AND ' +
            				'Start_Duration__c >=: SD AND Start_Duration__c <=: ED order by Createddate desc';
            
        CGReports = database.query(query);
            
        if(CGReports.size() > 0) {
            
            annualDTO = new CG_DTO.COIReportListDTO();
            annualDTO = assignToCOIReportListDTO(CGReports[0]);
            
        }
        
        return annualDTO;
    }
    
    //Get COI Report Detail using report id
    @RemoteAction
    public static CG_DTO.COIReportDetailDTO GetReportDetail(string reportId) {
        
        string userId = CG_PrivilegeHandler.getUserId();
        reportDetail = new CG_DTO.COIReportDetailDTO();
        
        if(reportId == null) {
            
            reportDetail.reportType = new CG_Global.EnumValue('COIReportType');
            reportDetail.reportType.key = CG_Enum.COIReportType.COIIncident.name();
            reportDetail.reportType.value = 'Incident';
            
            PISUsers__c PISUser = CG_Global.assignToPISUser(userId);
            
            reportDetail.supervisorName = PISUser.EN_LineManager__c;
            reportDetail.status = new CG_Global.EnumValue('ReportStatus');
            reportDetail.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            reportDetail.status.value = 'Waiting for Submit';
            reportDetail.startDuration = datetime.now();
            reportDetail.endDuration = datetime.now().addDays(14);
            reportDetail.submittedDate = null;
            
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
            approver.isShow = true;
            workflow.approvers.add(approver);
            approver = new CG_DTO.WorkflowApproverDTO();
            approver.role = new CG_Global.EnumValue('ApproverRole');
            approver.role.key = CG_Enum.ApproverRole.GLVP.name();
            approver.role.value = CG_Enum.ApproverRole.GLVP.name();
            approver.status = new CG_Global.EnumValue('ApproverStatus');
            approver.status.key = CG_Enum.ApproverStatus.WaitingGLVP.name();
            approver.status.value = 'Waiting GLVP';
            approver.isShow = true;
            workflow.approvers.add(approver);
            reportDetail.currentWorkflow = workflow;
            
            reportDetail.reportedByTH = PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
            reportDetail.reportedByEN = PISUser.ENFIRSTNAME__c + ' ' + PISUser.ENLASTNAME__c;
            reportDetail.reportedByPositionTH = PISUser.OBJENFULLNAME__c;
            reportDetail.reportedByPositionEN = PISUser.OBJTHFULLNAME__c;
            reportDetail.reportedByCompanyTH = PISUser.COMPANYNAME_HOST__c;
            reportDetail.reportedByCompanyEN = PISUser.COMPANYNAME_HOST__c;
            reportDetail.reportedDate = system.today();
            reportDetail.canEdit = true;
            reportDetail.canSubmit = true;
            
        }
        else if(reportId != null) {
         
            List<CG_Reporting__c> CGReports = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                               End_Duration__c, Submitted_Date__c, Type_Of_Report__c , Status__c,
                                               Status_JSON__c, IsAcknowledge__c, OwnerId,
                                               COI_Agree__c, COI_Disclosure__c, COI_Transaction_Company_Name__c, COI_Transaction_Other_Company_Name__c, COI_Transaction_By_Me__c,
                                               COI_Transaction_By_Other__c, COI_Transaction_By_Other_Name__c, COI_Transaction_By_Other_Relation__c,
                                               COI_Transaction_By_Other_Relation_Name__c, COI_Transaction_By_Other_Relationship__c,
                                               Reported_By_TH__c, Reported_By_EN__c, Reported_By_Position_TH__c,
                                               Reported_By_Position_EN__c, Reported_By_Company_TH__c, Reported_By_Company_EN__c,
                                               Reported_Date__c, Supervisor_Action_By_TH__c, Supervisor_Action_By_EN__c,
                                               Supervisor_Action_By_Position_TH__c, Supervisor_Action_By_Position_EN__c,
                                               Supervisor_Action_By_Company_TH__c, Supervisor_Action_By_Company_EN__c,
                                               Supervisor_Action_Date__c, Supervisor_Approver_Status__c, Supervisor_Comment__c,
                                               GLGC_Receive_By__c, GLGC_Action_By_TH__c, GLGC_Action_By_EN__c,
                                               GLGC_Action_By_Position_TH__c, GLGC_Action_By_Position_EN__c,
                                               GLGC_Action_By_Company_TH__c, GLGC_Action_By_Company_EN__c,
                                               GLGC_Action_Date__c, GLVP_Action_By_TH__c, GLVP_Action_By_EN__c,
                                               GLVP_Action_By_Position_TH__c, GLVP_Action_By_Position_EN__c,
                                               GLVP_Action_By_Company_TH__c, GLVP_Action_By_Company_EN__c,
                                               GLVP_Action_Date__c, GLVP_Approver_Status__c, COI_Detail__c, COI_Action__c, GLVP_Comment__c,
                                               GLGC_Approver_Status__c
                                               from CG_Reporting__c where Id =: reportId];
            
            List<SD_Company__c> Companies = [select id, name, Company_Full_Name__c from SD_Company__c];
            
            for(CG_Reporting__c COIReport : CGReports) {
                if(COIReport.Id == reportId) {
                    
            		reportDetail = assignToCOIReportDetailDTO(COIReport);
                    
                }
            }
            
                
        }
        
        return reportDetail;
    }

    //Delete an Incident Report (only "Waiting for Submit")
    @RemoteAction
    public static void DeleteIncidentReport(string reportId) {

        try {
            CG_Reporting__c CGReporting = [select id, status__c from CG_Reporting__c where Id =: reportId];
            
            if(CGReporting != null && (CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) || 
                                      CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected))) {
                delete(CGReporting);
            }
        }
        catch(DmlException e) {
            System.debug('DeleteIncidentReport exception has occurred: ' + e.getMessage());
        }
        
    }
    
    //Save as draft report (for employee)
    @RemoteAction
    public static CG_DTO.COIReportDetailDTO SaveAsDraftReport(CG_DTO.COIReportDetailDTO report) {

        string userId = CG_PrivilegeHandler.getUserId();
        
        try {         
            
            if(report != null) {
                
                if(report.id == null) {
                    PISUsers__c PISUser = CG_Global.assignToPISUser(userId);
                	Id COIIncidentRTId = [select id, name from RecordType where name = 'CG COI Incident' AND sobjecttype = 'CG_Reporting__c'].Id;
        
                    //Insert into CG Reporting
                    CG_Reporting__c CGReporting = new CG_Reporting__c();
                    CGReporting.OwnerId = userId;
                    CGReporting.RecordTypeId = COIIncidentRTId;
                    CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit);
        			CGReporting.User__c = CG_Global.AssignSupervisor(PISUser);
                    CGReporting.Start_Duration__c = Date.ValueOf(report.startDuration);
                    CGReporting.End_Duration__c = Date.ValueOf(report.endDuration);
                    CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIIncident);
                    CGReporting.COI_Agree__c = report.agree;
                    CGReporting.COI_Disclosure__c = String.ValueOf(report.disclosureReport.value);
                    
                    if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes) ||
                      	CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
                        
                        if(report.transactionCompany != null) {
                	        if(string.isNotBlank(report.transactionCompany.id) || string.isNotEmpty(report.transactionCompany.id)) {
            	                CGReporting.COI_Transaction_Company_Name__c = report.transactionCompany.name;
                                CGReporting.COI_Transaction_Other_Company_Name__c = report.transactionOtherCompany;
                            }
                        }
                        
                        if(report.transactionByMe != null) {
                            CGReporting.COI_Transaction_By_Me__c = report.transactionByMe;
                        }
                        
                        if(report.transactionByOther != null) {
                            CGReporting.COI_Transaction_By_Me__c = report.transactionByMe;
                        }
                        
                        CGReporting.COI_Transaction_By_Other__c = report.transactionByOther;
                        CGReporting.COI_Transaction_By_Other_Name__c = report.transactionByOtherName;
                        CGReporting.COI_Transaction_By_Other_Relation__c = report.transactionByOtherRelation;
                        CGReporting.COI_Transaction_By_Other_Relation_Name__c = report.transactionByOtherRelationName;
                        CGReporting.COI_Transaction_By_Other_Relationship__c = report.transactionByOtherRelationship;
                        CGReporting.COI_Detail__c = report.coiDetail;
                        CGReporting.COI_Action__c = report.coiAction;
                    }
                    
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
                    
                    string runningNo = CG_ReportingHandler.GenerateRunningNo('COI New Employee');
                    string year = CG_ReportingHandler.GetCurrentYear();
                    
                    CGReporting.Running_No__c = 'COI-' + year + '-01-' + runningNo;
                    
                    insert(CGReporting);
                    
                    CGReporting.Status_JSON__c = CG_ReportingHandler.InitialStatusJson(CGReporting.Id, PISUser);
                    update(CGReporting);
                    
                    report.id = CGReporting.id;
                    
                }
                else if(report.id != null) {
                    
                    List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit), String.ValueOf(CG_Enum.ReportStatus.Rejected)};
                    CG_Reporting__c CGReporting = [select id, Status__c, Running_No__c, Type_Of_Report__c from CG_Reporting__c where Id =: report.id AND Status__c IN: statuses ];
                
                    if(CGReporting != null) {
                        
                        CGReporting.COI_Agree__c = report.agree;
                        CGReporting.Reported_Date__c = system.Date.today();
                    	
                        CGReporting.COI_Disclosure__c = String.ValueOf(report.disclosureReport.value);
                        
                        if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes) ||
                      		CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
                        
                                if(report.transactionCompany != null) {
                                if(string.isNotBlank(report.transactionCompany.id) || string.isNotEmpty(report.transactionCompany.id)) {
                                    CGReporting.COI_Transaction_Company_Name__c = report.transactionCompany.name;
                                    CGReporting.COI_Transaction_Other_Company_Name__c = report.transactionOtherCompany;
                                }
                            }
                            
                            if(report.transactionByMe != null) {
                                CGReporting.COI_Transaction_By_Me__c = report.transactionByMe;
                            }
                            
                            if(report.transactionByOther != null) {
                                CGReporting.COI_Transaction_By_Me__c = report.transactionByMe;
                            }
                            
                            CGReporting.COI_Transaction_By_Other__c = report.transactionByOther;
                            CGReporting.COI_Transaction_By_Other_Name__c = report.transactionByOtherName;
                            CGReporting.COI_Transaction_By_Other_Relation__c = report.transactionByOtherRelation;
                            CGReporting.COI_Transaction_By_Other_Relation_Name__c = report.transactionByOtherRelationName;
                            CGReporting.COI_Transaction_By_Other_Relationship__c = report.transactionByOtherRelationship;
                            CGReporting.COI_Detail__c = report.coiDetail;
                            CGReporting.COI_Action__c = report.coiAction;
                        }
                        
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
    public static CG_DTO.COIReportDetailDTO SubmitReport(CG_DTO.COIReportDetailDTO report) {
        
        string userId = CG_PrivilegeHandler.getUserId();
        try {
            
            PISUsers__c PISUser = CG_Global.assignToPISUser(userId);
            
            if(report.id == null) {
                Id COIIncidentRTId = [select id, name from RecordType where name = 'CG COI Incident' AND sobjecttype = 'CG_Reporting__c'].Id;
        		
                //Insert into CG Reporting
                CG_Reporting__c CGReporting = new CG_Reporting__c();
                CGReporting.OwnerId = userId;
        		CGReporting.User__c = CG_Global.AssignSupervisor(PISUser);
                CGReporting.RecordTypeId = COIIncidentRTId;
                CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
                CGReporting.Start_Duration__c = Date.ValueOf(report.startDuration);
                CGReporting.End_Duration__c = Date.ValueOf(report.endDuration);
                CGReporting.Type_of_Report__c = String.ValueOf(CG_Enum.COIReportType.COIIncident);
                CGReporting.COI_Agree__c = report.agree;
                CGReporting.COI_Disclosure__c = String.ValueOf(report.disclosureReport.value);
                
                if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes) ||
                   CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
                       
                       if(report.transactionCompany != null) {
                           if(string.isNotBlank(report.transactionCompany.id) || string.isNotEmpty(report.transactionCompany.id)) {
                               CGReporting.COI_Transaction_Company_Name__c = report.transactionCompany.name;
                               CGReporting.COI_Transaction_Other_Company_Name__c = report.transactionOtherCompany;
                           }
                       }
                       
                       if(report.transactionByMe != null) {
                           CGReporting.COI_Transaction_By_Me__c = report.transactionByMe;
                       }
                       
                       if(report.transactionByOther != null) {
                           CGReporting.COI_Transaction_By_Me__c = report.transactionByMe;
                       }
                       
                       CGReporting.COI_Transaction_By_Other__c = report.transactionByOther;
                       CGReporting.COI_Transaction_By_Other_Name__c = report.transactionByOtherName;
                       CGReporting.COI_Transaction_By_Other_Relation__c = report.transactionByOtherRelation;
                       CGReporting.COI_Transaction_By_Other_Relation_Name__c = report.transactionByOtherRelationName;
                       CGReporting.COI_Transaction_By_Other_Relationship__c = report.transactionByOtherRelationship;
                       CGReporting.COI_Detail__c = report.coiDetail;
                       CGReporting.COI_Action__c = report.coiAction;
                }
                
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
                
                string runningNo = CG_ReportingHandler.GenerateRunningNo('COI New Employee');
                string year = CG_ReportingHandler.GetCurrentYear();
                
                CGReporting.Running_No__c = 'COI-' + year + '-01-' + runningNo;
                insert(CGReporting);
                
                CGReporting.Status_JSON__c = CG_ReportingHandler.InitialStatusJson(CGReporting.Id, PISUser);
                CGReporting.Status_JSON__c = assignSupervisorWhenEmployeeSubmit(CGReporting.Id, CGReporting.Status_JSON__c, CGReporting.User__c);
                update(CGReporting);
                
                report.id = CGReporting.id;
                
                //Send email to Supervisor when user submit
                if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                	CG_ReportingHandler.COINewEmployeeSupervisorEmail(CGReporting.User__c, CGReporting);
                    
                    //Update Requester Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.OwnerId, 'Done');
                    
                    //Send Bell Noti to User
                    CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                    BellNoti.NotificationName = 'CG_Notification';
                    BellNoti.Title = 'Please Acknowledge COI Report';
                    BellNoti.Body = 'Please acknowledge Conflict of Interest report (New Employee) : ' + CGReporting.Running_No__c;
                    BellNoti.Receivers = new Set<string>();
                    BellNoti.Receivers.add(CGReporting.User__c);
        			BellNoti.RecordId = CGReporting.Id;
                    BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting\'}}';
                    CG_NotiController.SendBellNoti(BellNoti);
                    
                    //Send Opp Noti
                    CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                    OppNoti.ApproverId = CGReporting.User__c;
                    OppNoti.Subject = 'Please Acknowledge COI Report';
                    OppNoti.Description = 'Please acknowledge Conflict of Interest report (New Employee) : ' + CGReporting.Running_No__c;
                    OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                    OppNoti.Status = 'New';
        
                    string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting';
        
                    OppNoti.URL = URL;
                    OppNoti.ReferenceId = CGReporting.Id;
                    CG_NotiController.SendOppNoti(OppNoti);
                    
                }
                else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                    CG_ReportingHandler.COIIncidentSupervisorEmail(CGReporting.User__c, CGReporting);
                    
                    //Update Requester Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.OwnerId, 'Done');
                    
                    //Send Bell Noti to User
                    CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                    BellNoti.NotificationName = 'CG_Notification';
                    BellNoti.Title = 'Please Acknowledge COI Report';
                    BellNoti.Body = 'Please acknowledge Conflict of Interest report (Incident) : ' + CGReporting.Running_No__c;
                    BellNoti.Receivers = new Set<string>();
                    BellNoti.Receivers.add(CGReporting.User__c);
        			BellNoti.RecordId = CGReporting.Id;
                    BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting\'}}';
                    CG_NotiController.SendBellNoti(BellNoti);
                    
                    //Send Opp Noti
                    CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                    OppNoti.ApproverId = CGReporting.User__c;
                    OppNoti.Subject = 'Please Acknowledge COI Report';
                    OppNoti.Description = 'Please acknowledge Conflict of Interest report (Incident) : ' + CGReporting.Running_No__c;
                    OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                    OppNoti.Status = 'New';
        
                    string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting';
        
                    OppNoti.URL = URL;
                    OppNoti.ReferenceId = CGReporting.Id;
                    CG_NotiController.SendOppNoti(OppNoti);
                }
                else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                    
                    //Update Requester Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.OwnerId, 'Done');
                    
                    //CG_ReportingHandler.COIAnnualSupervisorEmail(CGReporting.User__c, CGReporting);
                }
            }
            else if(report.id != null) {
                
                CG_Reporting__c CGReporting = [select id, Status__c, Running_No__c, Status_JSON__c, User__c, Type_Of_Report__c, OwnerId, Reported_By_EN__c from CG_Reporting__c where Id =: report.id AND 
                                               (Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) OR Status__c =: String.ValueOf(CG_Enum.ReportStatus.Rejected))];
            
                if(string.isEmpty(CGReporting.User__c)) {
        			CGReporting.User__c = CG_Global.AssignSupervisor(PISUser);
                }
                
                CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
                CGReporting.COI_Agree__c = report.agree;
                CGReporting.Reported_Date__c = system.Date.today();
                CGReporting.COI_Disclosure__c = String.ValueOf(report.disclosureReport.value);
                
                if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes) ||
                   CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
                       
                       if(report.transactionCompany != null) {
                           if(string.isNotBlank(report.transactionCompany.id) || string.isNotEmpty(report.transactionCompany.id)) {
                               CGReporting.COI_Transaction_Company_Name__c = report.transactionCompany.name;
                               CGReporting.COI_Transaction_Other_Company_Name__c = report.transactionOtherCompany;
                           }
                       }
                       
                       if(report.transactionByMe != null) {
                           CGReporting.COI_Transaction_By_Me__c = report.transactionByMe;
                       }
                       
                       if(report.transactionByOther != null) {
                           CGReporting.COI_Transaction_By_Me__c = report.transactionByMe;
                       }
                       
                       CGReporting.COI_Transaction_By_Other__c = report.transactionByOther;
                       CGReporting.COI_Transaction_By_Other_Name__c = report.transactionByOtherName;
                       CGReporting.COI_Transaction_By_Other_Relation__c = report.transactionByOtherRelation;
                       CGReporting.COI_Transaction_By_Other_Relation_Name__c = report.transactionByOtherRelationName;
                       CGReporting.COI_Transaction_By_Other_Relationship__c = report.transactionByOtherRelationship;
                       CGReporting.COI_Detail__c = report.coiDetail;
                       CGReporting.COI_Action__c = report.coiAction;
                   }
                
                CGReporting.Submitted_Date__c = system.Date.today();
                
                CGReporting.Status_JSON__c = assignSupervisorWhenEmployeeSubmit(CGReporting.Id, CGReporting.Status_JSON__c, CGReporting.User__c);
                
                update(CGReporting);
                
                //Send email to Supervisor when user submit
                if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                	CG_ReportingHandler.COINewEmployeeSupervisorEmail(CGReporting.User__c, CGReporting);
                    
                    //Update Requester Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.OwnerId, 'Done');
                    
                    //Send Bell Noti to User
                    CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                    BellNoti.NotificationName = 'CG_Notification';
                    BellNoti.Title = 'Please Acknowledge COI Report';
                    BellNoti.Body = 'Please acknowledge Conflict of Interest report (New Employee) : ' + CGReporting.Running_No__c;
                    BellNoti.Receivers = new Set<string>();
                    BellNoti.Receivers.add(CGReporting.User__c);
        			BellNoti.RecordId = CGReporting.Id;
                    BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting\'}}';
                    CG_NotiController.SendBellNoti(BellNoti);
                    
                    //Send Opp Noti
                    CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                    OppNoti.ApproverId = CGReporting.User__c;
                    OppNoti.Subject = 'Please Acknowledge COI Report';
                    OppNoti.Description = 'Please acknowledge Conflict of Interest report (New Employee) : ' + CGReporting.Running_No__c;
                    OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                    OppNoti.Status = 'New';
        
                    string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting';
        
                    OppNoti.URL = URL;
                    OppNoti.ReferenceId = CGReporting.Id;
                    CG_NotiController.SendOppNoti(OppNoti);
                    
                }
                else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                    CG_ReportingHandler.COIIncidentSupervisorEmail(CGReporting.User__c, CGReporting);
                    
                    //Update Requester Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.OwnerId, 'Done');
                    
                    //Send Bell Noti to User
                    CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                    BellNoti.NotificationName = 'CG_Notification';
                    BellNoti.Title = 'Please Acknowledge COI Report';
                    BellNoti.Body = 'Please acknowledge Conflict of Interest report (Incident) : ' + CGReporting.Running_No__c;
                    BellNoti.Receivers = new Set<string>();
                    BellNoti.Receivers.add(CGReporting.User__c);
        			BellNoti.RecordId = CGReporting.Id;
                    BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting\'}}';
                    CG_NotiController.SendBellNoti(BellNoti);
                    
                    //Send Opp Noti
                    CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                    OppNoti.ApproverId = CGReporting.User__c;
                    OppNoti.Subject = 'Please Acknowledge COI Report';
                    OppNoti.Description = 'Please acknowledge Conflict of Interest report (Incident) : ' + CGReporting.Running_No__c;
                    OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                    OppNoti.Status = 'New';
        
                    string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting';
        
                    OppNoti.URL = URL;
                    OppNoti.ReferenceId = CGReporting.Id;
                    CG_NotiController.SendOppNoti(OppNoti);
                }
                else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                    
                    //Update Requester Opp Noti
                    CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.OwnerId, 'Done');
                    
                    //CG_ReportingHandler.COIAnnualSupervisorEmail(CGReporting.User__c, CGReporting);
                }
                
            }
            else {
                System.debug('Cannot submit COI. Report not found.');
            }
            
        }
        catch(DmlException e) {
            System.debug('SubmitReport exception has occurred: ' + e.getMessage());
        }
        
        return report;
    }
    
    @RemoteAction
    public static CG_DTO.WorkflowHistoryDTO GetReportWorkflow(string reportId) {
        
        try {
            
            CG_DTO.WorkflowHistoryDTO WorkflowHistoryDTO = new CG_DTO.WorkflowHistoryDTO();
            
            CG_Reporting__c CGReporting = [select id, Status_JSON__c from CG_Reporting__c where Id =: reportId];
            
            if(CGReporting != null) {
                WorkflowHistoryDTO = DeserializeWorkflowHistory(CGReporting.Status_JSON__c);
                System.debug(WorkflowHistoryDTO);
                return WorkflowHistoryDTO;
            }
        }
        catch(Exception e) {
            System.debug('GetReportWorkflow exception has occurred: ' + e.getMessage());
        }
        
        return null;
    }
    
    @RemoteAction
    public static CG_DTO.COIReportHistoryCountDTO GetCOIHistoryCount(datetime startDate, datetime endDate){
        
        try {
            
            reportHistoryCount = new CG_DTO.COIReportHistoryCountDTO();
            reportHistoryCount.totalReport = 0;
            reportHistoryCount.annual = 0;
            reportHistoryCount.incident = 0;
            reportHistoryCount.newEmployee = 0;
            
            string userId = CG_PrivilegeHandler.getUserId();
            List<CG_DTO.COIReportListDTO> COIReports = new List<CG_DTO.COIReportListDTO>();
            
            if(incidentListDTOs.size() > 0) {
                for(CG_DTO.COIReportListDTO COIReport : incidentListDTOs) {
                    if(COIReport.startDuration >= startDate && COIReport.endDuration <= endDate) {
                        COIReports.add(COIReport);
                    }
                }
                
                reportHistoryCount.totalReport = COIReports.size();
                
                for(CG_DTO.COIReportListDTO incident : COIReports) {
                    if(String.ValueOf(incident.reportType) == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                        reportHistoryCount.annual += 1;
                    }
                    else if(String.ValueOf(incident.reportType) == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                        reportHistoryCount.incident += 1;
                    }
                    else if(String.ValueOf(incident.reportType) == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                        reportHistoryCount.newEmployee += 1;
                    }
                }
            }
            
        }
        catch(Exception e) {
            System.debug('GetCOIHistoryCount exception has occured : ' + e.getMessage());
        }
        
        return reportHistoryCount;
    }
    
    @RemoteAction
    public static List<CG_DTO.COIReportHistoryListDTO> GetCOIHistoryList(datetime startDate, datetime endDate,
                        //reportNumber, reportType, disclosureReport, supervisorName, submittedDate, status
                        CG_Global.SortByParam sortByParam, 
                        CG_Global.PageParam pageParam) {
        
        try {
            
            string userId = CG_PrivilegeHandler.getUserId();
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
            string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                            'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                            'where OwnerId =: userId';
            
            if(sortByParam.sortBy == 'reportNumber') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c desc');
                }
            }
            else if(sortByParam.sortBy == 'reportType') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by type_of_report__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by type_of_report__c desc');
                }
            }
            else if(sortByParam.sortBy == 'disclosureReport') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by COI_Disclosure__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by COI_Disclosure__c desc');
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
            else if(sortByParam.sortBy == 'submittedDate') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Submitted_Date__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Submitted_Date__c desc');
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
            else {
                CGReports = database.query(query + ' order by Running_No__c asc');
            }
            
            reportHistoryList = new List<CG_DTO.COIReportHistoryListDTO>();
            integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            integer totalSize = CGReports.size() - startIndex;
            
            for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                if (i < totalSize) {
                    reportHistoryList.add(assignToCOIReportHistoryListDTO(CGReports[startIndex + i]));
                }else{
                    break;
                }
            }
            
            return reportHistoryList;
            
        }
        catch (Exception e) {
            System.debug('GetCOIHistoryList exception has occured : ' + e.getMessage());
        }
        
        return reportHistoryList;
    }
    
    @RemoteAction
    public static CG_DTO.COIMassAcknowledgeCountDTO GetCOIMassAcknowledgeCount() {
            
        string userId = CG_PrivilegeHandler.getUserId();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> COIRTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual),
            String.ValueOf(CG_Enum.COIReportType.COIIncident),
            String.ValueOf(CG_Enum.COIReportType.COINewEmployee)};
            
        string reportStatus = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                        'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                        'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                        'where Status__c =: reportStatus AND Type_Of_Report__c IN: COIRTs';
            
        CGReports = database.query(query);
        
        massAcknowledgeCount = new CG_DTO.COIMassAcknowledgeCountDTO();
        massAcknowledgeCount.totalReport = 0;
        massAcknowledgeCount.answerNo = 0;
        massAcknowledgeCount.answerYes = 0;
        massAcknowledgeCount.answerNotSure = 0;
            
        try {
            
            if(CGReports.size() > 0) {
                massAcknowledgeCount.totalReport = CGReports.size();
                
                for(CG_Reporting__c CGReport : CGReports) {
                    if(CGReport.COI_DisClosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes)) {
                        massAcknowledgeCount.answerYes += 1;
                    }
                    else if(CGReport.COI_DisClosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
                        massAcknowledgeCount.answerNo += 1;
                    }
                    else if(CGReport.COI_DisClosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
                        massAcknowledgeCount.answerNotSure += 1;
                    }
                }
                
            }
            
        }
        catch (Exception e) {
            System.debug('GetCOIMassAcknowledgeCount exception has occured : ' + e.getMessage());
        }
            
        return massAcknowledgeCount;
    }
    
    @RemoteAction
    public static List<CG_DTO.COIMassAcknowledgeListDTO> GetCOIMassAcknowledgeList(
                        //enum DisclosureReport (comma-seperated)
                        string disclosureReportKeys,
                        //reportNumber, reportType, disclosureReport, supervisorName, submittedDate, status, ownerName, ownerPosition, ownerSection
                        CG_Global.SortByParam sortByParam, 
                        CG_Global.PageParam pageParam ) {
        
        string userId = CG_PrivilegeHandler.getUserId();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> COITypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIIncident),
            										String.ValueOf(CG_Enum.COIReportType.COIAnnual),
            										String.ValueOf(CG_Enum.COIReportType.COINewEmployee)};
            
        //Query CG Report                    
        string reportStatus = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                        'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                        'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId ' +
                        'from CG_Reporting__c where Status__c =: reportStatus AND Type_Of_Report__c IN: COITypes';
            
        CGReports = database.query(query);
                            
        //Query User
        User currentUser = [select id, name, position__c, section__c from User where Id =: userId];
        
        List<CG_DTO.COIMassAcknowledgeListDTO> queryResults = new List<CG_DTO.COIMassAcknowledgeListDTO>();
        List<CG_DTO.COIMassAcknowledgeListDTO> results = new List<CG_DTO.COIMassAcknowledgeListDTO>();     
        List<CG_DTO.COIMassAcknowledgeListDTO> actualResults = new List<CG_DTO.COIMassAcknowledgeListDTO>();                  
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                queryResults.add(assignToCOIMassAcknowledgeListDTO(CGReport, currentUser));
            }                       
        }
                    
        if (disclosureReportKeys != null && disclosureReportKeys != ''){
            string[] keys = disclosureReportKeys.split(',');
            for (CG_DTO.COIMassAcknowledgeListDTO report : queryResults) {
                if (keys.contains(report.disclosureReport.key)){
                    results.add(report);
                }
            }
        }else {
            results = massAcknowledgeList;
        }
        
        //PageParam
        if(results.size() > 0) {
                                
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            integer totalSize = results.size() - 1;
            
            for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                if (i < totalSize){
                    actualResults.add(results[startIndex + i]);
                }else{
                    break;
                }
             }
                                
        }
        
        return actualResults;
    }
        
    @RemoteAction
    public static CG_DTO.COIReportDetailDTO ApproveReport(CG_DTO.COIReportDetailDTO report) {
        
        if(report.id != null) {
            
            CG_Reporting__c CGReporting = [select id, status__c, Type_of_Report__c, user__c, status_json__c, ownerId, running_no__c, Submitted_Date__c, Reported_By_EN__c from CG_Reporting__c where Id =: report.Id];
            
            string reportType;
                
            if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                reportType = 'Annual';
            }
            else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                reportType = 'New Employee';
            }
            else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                reportType = 'Incident';
            }
            
            if(report.supervisorApproverStatus.key == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged) && CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            
                //Update Supervisor Opp Noti
                CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.User__c, 'Approved');
                
                CGReporting.Status_JSON__c = assignGLVPWhenSupervisorSubmit('Acknowledged', report.supervisorComment, CGReporting.OwnerId, CGReporting.Status_JSON__c);
                
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
                CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
                
                //Send email to GLVP when Supervisor Acknowledged
                if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee) || 
                  	CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                
                    List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
                    if(GLVPPISUsers.size() > 0) {
                        for(PISUsers__c GLVP : GLVPPISUsers) {
                            
                            CG_ReportingHandler.COIGLVPEmail(GLVP.User__c, CGReporting);
                            
                            //Send Bell Noti to GLVP
                            CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                            BellNoti.NotificationName = 'CG_Notification';
                            BellNoti.Title = 'Please Acknowledge COI Report';
                            BellNoti.Body = 'Please acknowledge Conflict of Interest report (' + reportType + ') : ' + CGReporting.Running_No__c;
                            BellNoti.Receivers = new Set<string>();
                            BellNoti.Receivers.add(GLVP.User__c);
        					BellNoti.RecordId = CGReporting.Id;
                    		BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting\'}}';
                    		CG_NotiController.SendBellNoti(BellNoti);
                            
                            //Send Opp Noti
                            CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                            OppNoti.ApproverId = GLVP.User__c;
                            OppNoti.Subject = 'Please Acknowledge COI Report';
                            OppNoti.Description = 'Please acknowledge Conflict of Interest report (' + reportType + ') : ' + CGReporting.Running_No__c;
                            OppNoti.RequesterName = CGReporting.Reported_By_EN__c;
                            OppNoti.Status = 'New';
                
                            string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting';
                
                            OppNoti.URL = URL;
                            OppNoti.ReferenceId = CGReporting.Id;
                            CG_NotiController.SendOppNoti(OppNoti);
                        }
                    }
                        
                }
                
            }
            else if(report.glvpApproverStatus.key == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged) && CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            	
                string userId = CG_PrivilegeHandler.getUserId();
                List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
                boolean isGLVPUser = false;
                if(GLVPPISUsers.size() > 0) {
                    for(PISUsers__c GLVP : GLVPPISUsers) {
                        if(GLVP.User__c == userId) {
                            isGLVPUser = true;
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
        
                    //If GLVP Acknowledged
                    CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
                    CGReporting.GLVP_Id__c = userId;
                }
                
            }
            
            update(CGReporting);
        }
        
        return report;
    }
    
    @RemoteAction
    public static CG_DTO.COIReportDetailDTO RejectReport(CG_DTO.COIReportDetailDTO report){
        
        if(report.id != null) {
            
            CG_Reporting__c CGReporting = [select id, running_no__c, status__c, user__c, status_json__c, ownerId, Supervisor_Action_Date__c, Type_of_Report__c from CG_Reporting__c where Id =: report.Id];
            
            if(report.supervisorApproverStatus.key == String.ValueOf(CG_Enum.ApproverStatus.Rejected)) {
                CGReporting.Status_JSON__c = assignGLVPWhenSupervisorSubmit('Rejected', report.supervisorComment, CGReporting.OwnerId, CGReporting.Status_JSON__c);
                
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
                CG_ReportingHandler.COIUserRejectedEmail(CGReporting.OwnerId, CGReporting);
                                
                //Update GLVP Opp Noti
                CG_NotiController.UpdateOppNotiWhenUserAction(CGReporting.Id, CGReporting.User__c, 'Rejected');
                
                string reportType;
                
                if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                    reportType = 'Annual';
                }
                else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                    reportType = 'New Employee';
                }
                else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                    reportType = 'Incident';
                }
                
                //Send Bell Noti to User
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'COI Report was rejected';
                BellNoti.Body = 'Please edit your Conflict of Interest report (' + reportType + ') : ' + CGReporting.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReporting.OwnerId);
        		BellNoti.RecordId = CGReporting.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReporting.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                /* CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReporting.OwnerId;
                OppNoti.Subject = 'COI Report was rejected';
                OppNoti.Description = 'Please edit your Conflict of Interest report (Incident) : ' + CGReporting.Running_No__c;
                OppNoti.RequesterName = '';
                OppNoti.Status = 'New';
                OppNoti.URL = '';
                OppNoti.ReferenceId = CGReporting.Id;
                CG_NotiController.SendOppNoti(OppNoti); */
            }
            
            update(CGReporting);
        }
        
        return report;
    }
    
    @RemoteAction
    public static void MassApproveReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds
    ) {

        string userId = CG_PrivilegeHandler.getUserId();
        List<Id> cgReportIds = new List<Id>();
        cgReportIds = reportIds.split(',');
        
        List<CG_Reporting__c> CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                              End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                              Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c
                                              where id IN: cgReportIds];
        
        if(CGReportings.size() > 0) {
            for(CG_Reporting__c CGReport : CGReportings) {
                CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
                
                //Supervisor
                CGReport.Supervisor_Approver_Status__c = String.ValueOf(CG_Enum.ApproverStatus.Acknowledged);
                                
                //Update Supervisor Opp Noti
                CG_NotiController.UpdateOppNotiWhenUserAction(CGReport.Id, CGReport.User__c, 'Approved');
                
                PISUsers__c Approver = CG_Global.assignToPISUser(userId);
                
                //CGReport.Supervisor_Comment__c = report.supervisorComment;
                CGReport.Supervisor_Action_By_TH__c = Approver.THTITLE__c + ' ' + Approver.THFIRSTNAME__c + ' ' + Approver.THLASTNAME__c;
                CGReport.Supervisor_Action_By_EN__c = Approver.EN_Fullname__c;
                CGReport.Supervisor_Action_By_Position_TH__c = Approver.OBJTHFULLNAME__c;
                CGReport.Supervisor_Action_By_Position_EN__c = Approver.OBJENFULLNAME__c;
                CGReport.Supervisor_Action_By_Company_TH__c = Approver.COMPANYNAME__c;
                CGReport.Supervisor_Action_By_Company_EN__c = Approver.COMPANYNAME__c;
                CGReport.Supervisor_Action_Date__c = date.today();
            }
            
            update(CGReportings);
        }
        
    }
    
    @RemoteAction
    public static void MassRejectReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds,
        string comment
    ) {
        
        string userId = CG_PrivilegeHandler.getUserId();
        List<Id> cgReportIds = new List<Id>();
        cgReportIds = reportIds.split(',');
        
        List<CG_Reporting__c> CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                              End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                              Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c
                                              where id IN: cgReportIds];
        
        if(CGReportings.size() > 0) {
            for(CG_Reporting__c CGReport : CGReportings) {
                CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Rejected);
                
                //Supervisor
                CGReport.Supervisor_Approver_Status__c = String.ValueOf(CG_Enum.ApproverStatus.Rejected);
                
                //Update Supervisor Opp Noti
                CG_NotiController.UpdateOppNotiWhenUserAction(CGReport.Id, CGReport.User__c, 'Rejected');
                
                PISUsers__c Approver = CG_Global.assignToPISUser(userId);
                
                CGReport.Supervisor_Comment__c = comment;
                CGReport.Supervisor_Action_By_TH__c = Approver.THTITLE__c + ' ' + Approver.THFIRSTNAME__c + ' ' + Approver.THLASTNAME__c;
                CGReport.Supervisor_Action_By_EN__c = Approver.EN_Fullname__c;
                CGReport.Supervisor_Action_By_Position_TH__c = Approver.OBJTHFULLNAME__c;
                CGReport.Supervisor_Action_By_Position_EN__c = Approver.OBJENFULLNAME__c;
                CGReport.Supervisor_Action_By_Company_TH__c = Approver.COMPANYNAME__c;
                CGReport.Supervisor_Action_By_Company_EN__c = Approver.COMPANYNAME__c;
                CGReport.Supervisor_Action_Date__c = date.today();
            }
            
            update(CGReportings);
        }
    }
    
    @RemoteAction
    public static CG_DTO.AdminCOIReportListCountDTO GetAdminCOIReportListCount(
        //employee name
        string ownerName,
        //employee id
        string ownerId,
    	//company , function, department, section, unit
    	string companyId, string function, string department, string section, string unit) {
            
        adminCOIReportListCount = new CG_DTO.AdminCOIReportListCountDTO();
        adminCOIReportListCount.totalReport = 0;
        adminCOIReportListCount.annual = 0;
        adminCOIReportListCount.newEmployee = 0;
        adminCOIReportListCount.incident = 0;
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), String.ValueOf(CG_Enum.COIReportType.COIIncident), String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
        //List<string> statuses = new List<string> { String.ValueOF(CG_Enum.ReportStatus.WaitingForSubmit)};    
            
        string userId = CG_PrivilegeHandler.getUserId();
        
        Set<CG_Reporting__c> allCGReports = new Set<CG_Reporting__c>();   
        List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();     
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c, ' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
            				'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, ' +
            				'Owner_Position__c from CG_Reporting__c ' +
                            'where Type_Of_Report__c IN: typeOfReports';
        
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
                
                boolean isInclude = true;
                
                if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident) && CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                    isInclude = false;
                }
                
                if(isInclude) {
                    
                    if(!string.isBlank(ownerName) && string.isBlank(ownerId)) {
                        ownerName = ownerName.toLowerCase();
                        if((CGReport.Owner_Full_Name_TH__c != null && CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName)) || (CGReport.Owner_Full_Name_EN__c != null && CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName))){
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
            }
            
            adminCOIReportListCount.totalReport = allCGReports.size();
            
            for(CG_Reporting__c CGReport : allCGReports) {
                if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                    adminCOIReportListCount.annual += 1;
                }
                else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                    adminCOIReportListCount.newEmployee += 1;
                }
                else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                    adminCOIReportListCount.incident += 1;
                }
            }
        }    
            
        return adminCOIReportListCount;
            
    }
    
    @RemoteAction
    public static List<CG_DTO.AdminCOIReportListDTO> GetAdminCOIReportList(
    //employee name
    string ownerName,
    //employee id
    string ownerId,
    //companyId, function, department, section, unit
    string companyId, string function, string department, string section, string unit,
    //reportNumber, reportType, disclosureReport, ownerName, reportStatus, submittedDate
    CG_Global.SortByParam sortByParam, 
    CG_Global.PageParam pageParam
    ) {
        
        adminCOIReportListDTOs = new List<CG_DTO.AdminCOIReportListDTO>();
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), 
            											String.ValueOf(CG_Enum.COIReportType.COIIncident), 
            											String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
        //List<string> statuses = new List<string> { String.ValueOF(CG_Enum.ReportStatus.WaitingForSubmit)};   
             
        string userId = CG_PrivilegeHandler.getUserId();
        
        List<CG_Reporting__c> allCGReports = new List<CG_Reporting__c>();   
        List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();     
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c, ' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
            				'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, ' + 
            				'Owner_Position__c from CG_Reporting__c ' +
                            'where Type_Of_Report__c IN: typeOfReports';
        
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
        else if(sortByParam.sortBy == 'reportType') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by type_of_report__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by type_of_report__c desc');
            }
        }
        else if(sortByParam.sortBy == 'disclosureReport') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by COI_Disclosure__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by COI_Disclosure__c desc');
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
        else if(sortByParam.sortBy == 'submittedDate') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Submitted_Date__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Submitted_Date__c desc');
            }
        }
        else if(sortByParam.sortBy == 'status') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Status__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Status__c desc');
            }
        }
        else {
            CGReportings = database.query(query + ' order by Running_No__c asc');
        }
        
        if(CGReportings.size() > 0) {
            integer count = 1;
            for(CG_Reporting__c CGReport : CGReportings) {
                
                boolean isInclude = true;
                
                if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident) && CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                    isInclude = false;
                }
                
                if(isInclude) {
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
                        if(CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName) || CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName)) {
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
            }
            
            //PageParam
            if(allCGReports.size() > 0) {
                Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
                integer totalSize = allCGReports.size() - startIndex;
                Map<string,CG_DTO.UserDTO> userDTOs = CG_Global.assignAllToUserDTO();
                for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                    if (i < totalSize){
                        adminCOIReportListDTOs.add(assignToAdminCOIReportListDTO(allCGReports[startIndex + i],userDTOs));
                    }else{
                        break;
                    }
                }
                
            }
        }
        
        return adminCOIReportListDTOs;
    }
    
    @RemoteAction
    public static void AdminResendReport(string reportId){
        
        CG_Reporting__c CGReport = [select id, Type_Of_Report__c, OwnerId, Status__c, Running_No__c, Submitted_Date__c, User__c,
                                    Start_Duration__c, End_Duration__c, Supervisor_Action_Date__c, Reported_By_EN__c, GLVP_Id__c from CG_Reporting__c where Id =: reportId];
        
        if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            	CG_ReportingHandler.COIReminderEmail(CGReport.OwnerId, CGReport);
                
                //Send Bell Noti to User
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please report COI for New Employee';
                BellNoti.Body = 'Please report your Conflict of Interest report for New Employee : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.OwnerId);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.OwnerId;
                OppNoti.Subject = 'Please report COI for New Employee';
                OppNoti.Description = 'Please report your Conflict of Interest report for New Employee : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
                
            }
            else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                CG_ReportingHandler.COIUserRejectedEmail(CGReport.OwnerId, CGReport);
                
                //Send Bell Noti to User
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'COI Report was rejected';
                BellNoti.Body = 'Please edit your Conflict of Interest report for (New Employee) : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.OwnerId);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.OwnerId;
                OppNoti.Subject = 'COI Report was rejected';
                OppNoti.Description = 'Please edit your Conflict of Interest report for (New Employee) : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            	CG_ReportingHandler.COINewEmployeeSupervisorEmail(CGReport.User__c, CGReport);
                
                //Send Bell Noti to User
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please Acknowledge COI Report';
                BellNoti.Body = 'Please acknowledge Conflict of Interest report (New Employee) : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.User__c);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.User__c;
                OppNoti.Subject = 'Please Acknowledge COI Report';
                OppNoti.Description = 'Please acknowledge Conflict of Interest report (New Employee) : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
                
            }
            else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                //Send email to GLVP when Supervisor Acknowledged
                List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
                if(GLVPPISUsers.size() > 0) {
                    for(PISUsers__c GLVP : GLVPPISUsers) {
                        
                        CG_ReportingHandler.COIGLVPEmail(GLVP.User__c, CGReport);
                        
                        //Send Bell Noti to GLVP
                        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                        BellNoti.NotificationName = 'CG_Notification';
                        BellNoti.Title = 'Please acknowledge COI Report';
                        BellNoti.Body = 'Please acknowledge Conflict of Interest report (' + CGReport.Type_of_Report__c + ') : ' + CGReport.Running_No__c;
                        BellNoti.Receivers = new Set<string>();
                        BellNoti.Receivers.add(GLVP.User__c);
        				BellNoti.RecordId = CGReport.Id;
                    	BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                    	CG_NotiController.SendBellNoti(BellNoti);
                        
                        //Send Opp Noti
                        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                        OppNoti.ApproverId = GLVP.User__c;
                        OppNoti.Subject = 'Please acknowledge COI report';
                        OppNoti.Description = 'Please acknowledge Conflict of Interest report (' + CGReport.Type_of_Report__c + ') : ' + CGReport.Running_No__c;
                        OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                        OppNoti.Status = 'New';
                        
                        string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                        
                        OppNoti.URL = URL;
                        OppNoti.ReferenceId = CGReport.Id;
                        CG_NotiController.SendOppNoti(OppNoti);
                        
                    }
                }
            }
        }
        else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
            
            if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            	CG_ReportingHandler.COIReminderEmail(CGReport.OwnerId, CGReport);
                
                //Send Bell Noti to Owner
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please report COI for Incident';
                BellNoti.Body = 'Please report your Conflict of Interest report for Incident : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.OwnerId);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.OwnerId;
                OppNoti.Subject = 'Please report COI for New Employee';
                OppNoti.Description = 'Please report your Conflict of Interest report for Incident : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                CG_ReportingHandler.COIUserRejectedEmail(CGReport.OwnerId, CGReport);
                
                //Send Bell Noti to Owner
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'COI report was rejected';
                BellNoti.Body = 'Please edit your Conflict of Interest report (Incident) : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.OwnerId);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.OwnerId;
                OppNoti.Subject = 'COI report was rejected';
                OppNoti.Description = 'Please edit your Conflict of Interest report (Incident) : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            	CG_ReportingHandler.COIIncidentSupervisorEmail(CGReport.User__c, CGReport);
                
                //Send Bell Noti to User
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please Acknowledge COI Report';
                BellNoti.Body = 'Please acknowledge Conflict of Interest report (Incident) : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.User__c);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.User__c;
                OppNoti.Subject = 'Please Acknowledge COI Report';
                OppNoti.Description = 'Please acknowledge Conflict of Interest report (Incident): ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                //Send email to GLVP when Supervisor Acknowledged
                List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
                if(GLVPPISUsers.size() > 0) {
                    for(PISUsers__c GLVP : GLVPPISUsers) {
                        
                        CG_ReportingHandler.COIGLVPEmail(GLVP.User__c, CGReport);
                        
                        //Send Bell Noti to GLVP
                        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                        BellNoti.NotificationName = 'CG_Notification';
                        BellNoti.Title = 'Please Acknowledge COI Report';
                        BellNoti.Body = 'Please acknowledge Conflict of Interest report (Incident) : ' + CGReport.Running_No__c;
                        BellNoti.Receivers = new Set<string>();
                        BellNoti.Receivers.add(GLVP.User__c);
        				BellNoti.RecordId = CGReport.Id;
                    	BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                    	CG_NotiController.SendBellNoti(BellNoti);
                        
                        //Send Opp Noti
                        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                        OppNoti.ApproverId = GLVP.User__c;
                        OppNoti.Subject = 'Please Acknowledge COI Report';
                        OppNoti.Description = 'Please acknowledge Conflict of Interest report (Incident) : ' + CGReport.Running_No__c;
                        OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                        OppNoti.Status = 'New';
                        
                        string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                        
                        OppNoti.URL = URL;
                        OppNoti.ReferenceId = CGReport.Id;
                        CG_NotiController.SendOppNoti(OppNoti);
                        
                    }
                }
            }
            
        }
        else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
            
            if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            	CG_ReportingHandler.COIAnnualReminderEmail(CGReport.OwnerId, CGReport);
                
                //Send Bell Noti to Owner
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please report COI Annual Report';
                BellNoti.Body = 'Please submit your Conflict of Interest (Annual) : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.OwnerId);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.OwnerId;
                OppNoti.Subject = 'Please report COI Annual Report';
                OppNoti.Description = 'Please submit your Conflict of Interest (Annual) : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                CG_ReportingHandler.COIUserRejectedEmail(CGReport.OwnerId, CGReport);
                
                //Send Bell Noti to Owner
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'COI report was rejected';
                BellNoti.Body = 'Please edit your Conflict of Interest report (Annual) : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.OwnerId);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.OwnerId;
                OppNoti.Subject = 'COI report was rejected';
                OppNoti.Description = 'Please edit your Conflict of Interest report (Annual) : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            	CG_ReportingHandler.COIAnnualSupervisorEmail(CGReport.User__c, CGReport);
                
                //Send Bell Noti to Supervisor
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please Acknowledge COI Report';
                BellNoti.Body = 'Please acknowledge Conflict of Interest report (Annual) : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.User__c);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.User__c;
                OppNoti.Subject = 'Please Acknowledge COI Report';
                OppNoti.Description = 'Please acknowledge Conflict of Interest report (Annual) : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                //Send email to GLVP when Supervisor Acknowledged
                List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
                if(GLVPPISUsers.size() > 0) {
                    for(PISUsers__c GLVP : GLVPPISUsers) {
                        
                        CG_ReportingHandler.COIGLVPEmail(GLVP.User__c, CGReport);
                        
                        //Send Bell Noti to GLVP
                        CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                        BellNoti.NotificationName = 'CG_Notification';
                        BellNoti.Title = 'Please Acknowledge COI Report';
                        BellNoti.Body = 'Please acknowledge Conflict of Interest report (Annual) : ' + CGReport.Running_No__c;
                        BellNoti.Receivers = new Set<string>();
                        BellNoti.Receivers.add(GLVP.User__c);
        				BellNoti.RecordId = CGReport.Id;
                    	BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting\'}}';
                    	CG_NotiController.SendBellNoti(BellNoti);
                        
                        //Send Opp Noti
                        CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                        OppNoti.ApproverId = GLVP.User__c;
                        OppNoti.Subject = 'Please Acknowledge COI Report';
                        OppNoti.Description = 'Please acknowledge Conflict of Interest report (Annual) : ' + CGReport.Running_No__c;
                        OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                        OppNoti.Status = 'New';
                        
                        string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_COI_Report_detail?reportId=' + CGReport.Id + '&parent=coiReporting';
                        
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
        CG_NotiController.UpdateOppNotiWhenUserAction(CGReport.Id, PISUser.User__c, 'Canceled');
        
        update(CGReport);
    }

    //Report Page
    @RemoteAction
    public static CG_DTO.ReportCOISummaryCountDTO GetReportCOISummaryCount(CG_COI_Reporting.ReportCOISearchCriteria filter){
        
        ReportCOISummaryCount = new CG_DTO.ReportCOISummaryCountDTO();
        ReportCOISummaryCount.totalReport = 0;
        ReportCOISummaryCount.completeReport = 0;
        ReportCOISummaryCount.waitingforSubmitReport = 0;
        ReportCOISummaryCount.waitingSupervisorReport = 0;
        ReportCOISummaryCount.waitingGLVPReport = 0;
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), 
            											String.ValueOf(CG_Enum.COIReportType.COIIncident), 
            											String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();                                                    
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, COI_Transaction_Company_Name__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,' +
            				'COI_Disclosure__c, OwnerId from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED';
                                                            
                                                            
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType)) {
            string typeOfReport = filter.reportType;
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
        
        //filter.coiAnswer
        if(!String.isEmpty(filter.coiAnswer) && !String.isBlank(filter.coiAnswer) && filter.coiAnswer.toLowerCase() != 'all') {
            string coiAnswer = filter.coiAnswer;
            query = query + ' AND COI_Disclosure__c =: coiAnswer';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

		//Final query
		CGReports = Database.query(query);                                                    
                
        if(CGReports.size() > 0) {
            
            integer totalReport = 0;
            
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                    ReportCOISummaryCount.completeReport += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                    ReportCOISummaryCount.waitingforSubmitReport += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                    ReportCOISummaryCount.waitingSupervisorReport += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                    ReportCOISummaryCount.waitingGLVPReport += 1;
                    totalReport++;
                }
                
            }
            
            reportCOISummaryCount.totalReport = totalReport;
        }
        
        return ReportCOISummaryCount;
    }
    
    @RemoteAction
    public static string ExportAllExcel(CG_COI_Reporting.ReportCOISearchCriteria filter) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CG_Report_Excel?';
        
        string exportAll = 'true';
        
        URL = URL + 'exportAll=' + exportAll;
        
        return URL;
    }

    @RemoteAction
    public static string ExportTableExcel(CG_COI_Reporting.ReportCOISearchCriteria filter){
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CG_Report_Excel';
        
        string exportAll = 'true';
        string typeOfReport = String.ValueOf(filter.reportType);
        string status = String.ValueOf(filter.status);
        datetime startDate = filter.startDate;
        datetime endDate = filter.endDate;
        string coiAnswer = filter.coiAnswer;
        string company = filter.companyId;
        string function = filter.function;
        string department = filter.department;
        string section = filter.section;
        string unit = filter.unit;
        
        URL = URL + '?exportAll=' + exportAll + '&typeOfReport=' + typeOfReport + '&status=' + status + '&startDate=' + startDate +
              '&endDate=' + endDate + '&coiAnswer=' + coiAnswer + '&company=' + company + '&function=' + function + '&department=' + department +
              '&section=' + section + '&unit=' + unit;
        
        return URL;
    }
    
    @RemoteAction
    public static CG_DTO.ReportCOIAnswerChartSeriesDTO GetReportCOIAnswerChart(CG_COI_Reporting.ReportCOISearchCriteria filter){
        
        reportCOIAnswerChartSeries = new CG_DTO.ReportCOIAnswerChartSeriesDTO();
        reportCOIAnswerChartSeries.series = new List<CG_DTO.ReportCOIAnswerChartSerieItemDTO>();
        CG_DTO.ReportCOIAnswerChartSerieItemDTO serie = new CG_DTO.ReportCOIAnswerChartSerieItemDTO();
        
        integer coiAnswerYes = 0;
        integer coiAnswerNo = 0;
        integer coiAnswerNotSure = 0;
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), String.ValueOf(CG_Enum.COIReportType.COIIncident), String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
            
        List<CG_Reporting__c> CGReports = [select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,
                                                Employee_Id__c, Supervisor_Name__c, Start_Duration__c,
                                                End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                                Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c
                                                where Type_Of_Report__c IN: typeOfReports];
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes)) {
                    coiAnswerYes += 1;
                }
                else if(CGReport.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
                    coiAnswerNo += 1;
                }
                else if(CGReport.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
                    coiAnswerNotSure += 1;
                }
                
            }
            
            serie.name = 'Yes';
            serie.color = '#8DC7EB';
            serie.y = coiAnswerYes;
            reportCOIAnswerChartSeries.series.add(serie);
            
            serie = new CG_DTO.ReportCOIAnswerChartSerieItemDTO();
            serie.name = 'No';
            serie.color = '#FFD065';
            serie.y = coiAnswerNo;
            reportCOIAnswerChartSeries.series.add(serie);
            
            serie = new CG_DTO.ReportCOIAnswerChartSerieItemDTO();
            serie.name = 'Not Sure';
            serie.color = '#FC849C';
            serie.y = coiAnswerNotSure;
            reportCOIAnswerChartSeries.series.add(serie);
        }
        
        return reportCOIAnswerChartSeries;
    }

    @RemoteAction
    public static List<CG_DTO.ReportCOITypeRadialChartItemDTO> GetReportCOITypeRadialChart(CG_COI_Reporting.ReportCOISearchCriteria filter){
        
        reportCOITypeRadialChartItems = new List<CG_DTO.ReportCOITypeRadialChartItemDTO>();
        CG_DTO.ReportCOITypeRadialChartItemDTO item = new CG_DTO.ReportCOITypeRadialChartItemDTO();
        
        integer annual = 0;
        integer incident = 0;
        integer newEmployee = 0;
        integer total = 0;
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), String.ValueOf(CG_Enum.COIReportType.COIIncident), String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
            
        List<CG_Reporting__c> CGReports = [select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,
                                                Employee_Id__c, Supervisor_Name__c, Start_Duration__c,
                                                End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                                Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c
                                                where Type_Of_Report__c IN: typeOfReports];
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                    annual += 1;
                }
                else if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                    incident += 1;
                }
                else if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                    newEmployee += 1;
                }
                
            }
            
            total = annual + incident + newEmployee;
        }
        
        item.type = 'COIAnnual';
        item.percent = (annual / total) * 100;
        item.color = '#82C177';
        item.count = annual;
        reportCOITypeRadialChartItems.add(item);
        item = new CG_DTO.ReportCOITypeRadialChartItemDTO();
        item.type = 'COIIncident';
        item.percent = (incident / total) * 100;
        item.color = '#F27D60';
        item.count = incident;
        reportCOITypeRadialChartItems.add(item);
        item = new CG_DTO.ReportCOITypeRadialChartItemDTO();
        item.type = 'COINewEmployee';
        item.percent = (newEmployee / total) * 100;
        item.color = '#476DA0';
        item.count = newEmployee;
        reportCOITypeRadialChartItems.add(item);
        
        return reportCOITypeRadialChartItems;
    }

    //Other Logic
    private static boolean checkCanEdit(string status) {
        boolean canEdit = false;
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) || 
            status == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            canEdit = true;
        }
        return canEdit;
    }
    
    private static boolean checkCanResend(string status) {
        boolean canResend = false;
        if(status != String.ValueOf(CG_Enum.ReportStatus.Success) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Cancel) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            canResend = true;
        }
        return canResend;
    }
    
    private static boolean checkCanCancel(string status) {
        boolean canCancel = false;
        if(status != String.ValueOf(CG_Enum.ReportStatus.Success) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Cancel) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            canCancel = true;
        }
        return canCancel;
    }
    
    private static boolean checkCanDelete(string status) {
        boolean canDelete = false;
        
         if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) || 
            status == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            canDelete = true;
        }
        
        return canDelete;
    }
    
    private static boolean checkCanSubmit(string status, string userProfile) {
        
        boolean canSubmit = false;
        
        //Check whether user can submit with current status
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.Employee) && status == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)
          || userProfile == String.ValueOf(CG_Enum.ApproverRole.Employee) && status == String.ValueOf(CG_Enum.ReportStatus.Rejected)
          || userProfile == String.ValueOf(CG_Enum.ApproverRole.GLGC) && status == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)
          || userProfile == String.ValueOf(CG_Enum.ApproverRole.GLVP) && status == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)
          || userProfile == String.ValueOf(CG_Enum.ApproverRole.Supervisor) && status == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)
          || userProfile == String.ValueOf(CG_Enum.ApproverRole.GLVP) && status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            canSubmit = true;
        }
        else if(userProfile == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
            canSubmit = true;
        }
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            canSubmit = false;
        }
        
        return canSubmit;
    }
    
    private static boolean checkCanSupervisorAcknowledge(string status) {
        boolean canAcknowledge = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
           canAcknowledge = true;
        }
        
        return canAcknowledge;
    }
    
    private static boolean checkCanGLVPAcknowledge(string status) {
        boolean canAcknowledge = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
           canAcknowledge = true;
        }
        
        return canAcknowledge;
    }
    
    private static boolean checkShowSupervisorComment(string status) {
        boolean canShowComment = false;
        
        string userProfile = CG_PrivilegeHandler.getUserProfile();
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor) ||
          	status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP) ||
          	status == String.ValueOf(CG_Enum.ReportStatus.Success)) {
           canShowComment = true;
        }
        
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.Employee) && 
          	status == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            canShowComment = true;
        }
        
        return canShowComment;
    }
    
    private static boolean checkShowGLVPComment(string status) {
        boolean canShowComment = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP) || status == String.ValueOf(CG_Enum.ReportStatus.Success)) {
           canShowComment = true;
        }
        
        return canShowComment;
    }
    
    private static string assignSupervisorWhenEmployeeSubmit(string reportId, string statusJSON, string supervisorId) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(statusJSON, CG_DTO.WorkflowHistoryDTO.class);
        workflowHistoryDTO.reportId = reportId;
        
        CG_DTO.WorkflowDTO currentWorkflow = workflowHistoryDTO.currentWorkflow;
        currentWorkflow.submittedDate = system.datetime.now();
        
        for(CG_DTO.WorkflowApproverDTO approver : currentWorkflow.approvers) {
            if(approver.status.key == CG_Enum.ApproverStatus.WaitingForSubmit.name()
              	&& approver.role.key == CG_Enum.ApproverRole.Employee.name()) {
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
    
    private static string assignGLVPWhenSupervisorSubmit(string submitAs, string comment, string ownerId, string statusJSON) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(statusJSON, CG_DTO.WorkflowHistoryDTO.class);
        
        CG_DTO.WorkflowDTO currentWorkflow = workflowHistoryDTO.currentWorkflow;
        
        if(submitAs == 'Acknowledged') {
            
            workflowHistoryDTO.status = new CG_Global.EnumValue('ReportStatus');
            workflowHistoryDTO.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            workflowHistoryDTO.status.value = 'Waiting GLVP';
            
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
                else if(approver.status.key == CG_Enum.ApproverStatus.WaitingGLVP.name()) {
                    approver.isCurrent = true;
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
            
            //Remove GLVP user from current flow
            currentWorkflow.approvers.remove(2);
            System.debug('currentWorkflow : ' + currentWorkflow);
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
    
    private static string assignSuccessWhenGLVPSubmit(string submitAs, string glvpId, string statusJSON) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(statusJSON, CG_DTO.WorkflowHistoryDTO.class);
        
        CG_DTO.WorkflowDTO currentWorkflow = workflowHistoryDTO.currentWorkflow;
        
        if(submitAs == 'Acknowledged') {
            
            workflowHistoryDTO.status = new CG_Global.EnumValue('ReportStatus');
            workflowHistoryDTO.status.key = CG_Enum.ReportStatus.Success.name();
            workflowHistoryDTO.status.value = 'Success';
            
            for(CG_DTO.WorkflowApproverDTO approver : currentWorkflow.approvers) {
                if(approver.status.key == CG_Enum.ApproverStatus.WaitingGLVP.name() 
                  	&& approver.role.key == CG_Enum.ApproverRole.GLVP.name()) {
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
    
    private static CG_DTO.WorkflowDTO DeserializeCurrentWorkflowStatus(string workflowStatus) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(workflowStatus, CG_DTO.WorkflowHistoryDTO.class);
        
        if(workflowHistoryDTO.currentWorkflow.approvers == null) {
            workflowHistoryDTO.currentWorkflow.approvers = new List<CG_DTO.WorkflowApproverDTO>();
        }
        
        for(CG_DTO.WorkflowApproverDTO currentWorkflow : workflowHistoryDTO.currentWorkflow.approvers) {
                
            currentWorkflow.isShow = true;
            
        }
        
        return workflowHistoryDTO.currentWorkflow;
        
    }
    
    private static List<CG_DTO.WorkflowDTO> DeserializeHistoryWorkflows(string workStatus, string workflowStatusJson) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(workflowStatusJson, CG_DTO.WorkflowHistoryDTO.class);

        List<CG_DTO.WorkflowDTO> workflows = new List<CG_DTO.WorkflowDTO>();
        workflows = workflowHistoryDTO.historyWorkflows;
        
        return workflows;
        
    }
    
    private static CG_DTO.WorkflowHistoryDTO DeserializeWorkflowHistory(string workflowStatusJson) {
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(workflowStatusJson, CG_DTO.WorkflowHistoryDTO.class);
		
        for(CG_DTO.WorkflowApproverDTO currentWorkflow : workflowHistoryDTO.currentWorkflow.approvers) {
            currentWorkflow.isShow = true;
        }
        
        //History Box
        if(workflowHistoryDTO.historyWorkflows != null) {
            for(CG_DTO.WorkflowDTO currentWorkflow : workflowHistoryDTO.historyWorkflows) {
                
                for(CG_DTO.WorkflowApproverDTO cw : currentWorkflow.approvers) {
                    cw.isShow = true;
                }
                
            }
        }
        
        return workflowHistoryDTO;
    }
    
    @TestVisible
    private static CG_DTO.CompanyDTO GetCompanyDTO(string companyId) {
        
        CG_DTO.CompanyDTO companyDTO = new CG_DTO.CompanyDTO();
        
        List<SD_Company__c> Companies = [select id, name, Company_Full_Name__c from SD_Company__c where Id =: companyId];
        
        if(Companies.size() > 0) {
            companyDTO.id = Companies[0].Id;
            companyDTO.name = Companies[0].Name;
            CompanyDTO.fullName = Companies[0].Company_Full_Name__c;
        }
        
        return companyDTO;
        
    }
    
    //Assign to DTO section
    private static CG_DTO.COIReportListDTO assignToCOIReportListDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.COIReportListDTO COIReport = new CG_DTO.COIReportListDTO();
        COIReport.id = CGReporting.Id;
        
        COIReport.reportType = new CG_Global.EnumValue('COIReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
            COIReport.reportType.key = CG_Enum.COIReportType.COIAnnual.name();
            COIReport.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
            COIReport.reportType.key = CG_Enum.COIReportType.COIIncident.name();
            COIReport.reportType.value = 'Incident';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            COIReport.reportType.key = CG_Enum.COIReportType.COINewEmployee.name();
            COIReport.reportType.value = 'New Employee';
        }
        
        COIReport.reportNumber = CGReporting.Running_No__c;
        COIReport.supervisorName = CGReporting.Supervisor_Name__c;
        
        COIReport.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            COIReport.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            COIReport.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            COIReport.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            COIReport.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            COIReport.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            COIReport.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            COIReport.status.key = CG_Enum.ReportStatus.Rejected.name();
            COIReport.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            COIReport.status.key = CG_Enum.ReportStatus.Success.name();
            COIReport.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            COIReport.status.key = CG_Enum.ReportStatus.Expired.name();
            COIReport.status.value = 'Expired';            
        }
        
        COIReport.badge = 0;
        
        if((CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee) || 
          	CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) &&
          	CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            COIReport.badge = 1;
        }
        
        COIReport.startDuration = CGReporting.Start_Duration__c;
        COIReport.endDuration = CGReporting.End_Duration__c;
        COIReport.submittedDate = CGReporting.Submitted_Date__c;
        COIReport.canEdit = checkCanEdit(String.ValueOf(COIReport.status.key));
        COIReport.canDelete = checkCanDelete(String.ValueOf(COIReport.status.key));
        return COIReport;
        
    }
    
    public static CG_DTO.COIReportDetailDTO assignToCOIReportDetailDTO(CG_Reporting__c CGReporting) {
        
        string userProfile = CG_PrivilegeHandler.getUserProfile();
        
        //Check privilege for current report
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
            string userId = CG_PrivilegeHandler.getUserId();
            if(userId != CGReporting.User__c) {
            	userProfile = String.ValueOf(CG_Enum.ApproverRole.Employee);
            }
        }
        
        CG_DTO.COIReportDetailDTO COIReportDetail = new CG_DTO.COIReportDetailDTO();
        
        COIReportDetail.id = CGReporting.Id;
        
        COIReportDetail.reportType = new CG_Global.EnumValue('COIReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
            COIReportDetail.reportType.key = CG_Enum.COIReportType.COIAnnual.name();
            COIReportDetail.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
            COIReportDetail.reportType.key = CG_Enum.COIReportType.COIIncident.name();
            COIReportDetail.reportType.value = 'Incident';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            COIReportDetail.reportType.key = CG_Enum.COIReportType.COINewEmployee.name();
            COIReportDetail.reportType.value = 'New Employee';
        }
        
        COIReportDetail.reportNumber = CGReporting.Running_No__c;
        COIReportDetail.supervisorName = CGReporting.Supervisor_Name__c;
        
        COIReportDetail.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            COIReportDetail.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            COIReportDetail.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            COIReportDetail.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            COIReportDetail.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            COIReportDetail.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            COIReportDetail.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            COIReportDetail.status.key = CG_Enum.ReportStatus.Rejected.name();
            COIReportDetail.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            COIReportDetail.status.key = CG_Enum.ReportStatus.Success.name();
            COIReportDetail.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            COIReportDetail.status.key = CG_Enum.ReportStatus.Success.name();
            COIReportDetail.status.value = 'Expired';            
        }
        
        COIReportDetail.startDuration = CGReporting.Start_Duration__c;
        COIReportDetail.endDuration = CGReporting.End_Duration__c;
        COIReportDetail.submittedDate = CGReporting.Submitted_Date__c;
        
        //Current Workflow
        System.debug(CGReporting.Status_JSON__c);
        COIReportDetail.currentWorkflow = DeserializeCurrentWorkflowStatus(CGReporting.Status_JSON__c);
        System.debug(COIReportDetail.currentWorkflow);
        
        COIReportDetail.agree = CGReporting.COI_Agree__c;
        COIReportDetail.disclosureReport = new CG_Global.EnumValue(CGReporting.COI_Disclosure__c);
        if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes)) {
            COIReportDetail.disclosureReport.key = CG_Enum.COIDisclosure.Yes.name();
            COIReportDetail.disclosureReport.value = CG_Enum.COIDisclosure.Yes.name();
        }
        else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
            COIReportDetail.disclosureReport.key = CG_Enum.COIDisclosure.No.name();
            COIReportDetail.disclosureReport.value = CG_Enum.COIDisclosure.No.name();
        }
        else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
            COIReportDetail.disclosureReport.key = CG_Enum.COIDisclosure.NotSure.name();
            COIReportDetail.disclosureReport.value = CG_Enum.COIDisclosure.NotSure.name();
        }
        
        //Company
        COIReportDetail.transactionCompany = assignToCompanyDTO(CGReporting.COI_Transaction_Company_Name__c);
        COIReportDetail.transactionOtherCompany = CGReporting.COI_Transaction_Other_Company_Name__c;
        COIReportDetail.transactionByMe = CGReporting.COI_Transaction_By_Me__c;
        COIReportDetail.transactionByOther = CGReporting.COI_Transaction_By_Other__c;
        COIReportDetail.transactionByOtherName = CGReporting.COI_Transaction_By_Other_Name__c;
        COIReportDetail.transactionByOtherRelation = CGReporting.COI_Transaction_By_Other_Relation__c;
        COIReportDetail.transactionByOtherRelationName = CGReporting.COI_Transaction_By_Other_Relation_Name__c;
        COIReportDetail.transactionByOtherRelationship = CGReporting.COI_Transaction_By_Other_Relationship__c;
        COIReportDetail.coiDetail = CGReporting.COI_Detail__c;
        COIReportDetail.coiAction = CGReporting.COI_Action__c;
        COIReportDetail.reportedDate = CGReporting.Reported_Date__c;
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            PISUsers__c PISUser = CG_Global.assignToPISUser(CGReporting.OwnerId);
            COIReportDetail.reportedByTH = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
            COIReportDetail.reportedByEN = PISUser.EN_Fullname__c;
            COIReportDetail.reportedByPositionTH = PISUser.OBJTHFULLNAME__c;
            COIReportDetail.reportedByPositionEN = PISUser.OBJENFULLNAME__c;
            COIReportDetail.reportedByCompanyTH = PISUser.COMPANYNAME__c;
            COIReportDetail.reportedByCompanyEN = PISUser.COMPANYNAME__c;
        }
        else {
            COIReportDetail.reportedByTH = CGReporting.Reported_By_TH__c;
            COIReportDetail.reportedByEN = CGReporting.Reported_By_EN__c;
            COIReportDetail.reportedByPositionTH = CGReporting.Reported_By_Position_TH__c;
            COIReportDetail.reportedByPositionEN = CGReporting.Reported_By_Position_EN__c;
            COIReportDetail.reportedByCompanyTH = CGReporting.Reported_By_Company_TH__c;
            COIReportDetail.reportedByCompanyEN = CGReporting.Reported_By_Company_EN__c;
        }
        
        //Supervisor
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            PISUsers__c PISUser = CG_Global.assignToPISUser(CGReporting.User__c);
            COIReportDetail.supervisorActionByTH = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
            COIReportDetail.supervisorActionByEN = PISUser.EN_Fullname__c;
            COIReportDetail.supervisorActionByPositionTH = PISUser.OBJTHFULLNAME__c;
            COIReportDetail.supervisorActionByPositionEN = PISUser.OBJENFULLNAME__c;
            COIReportDetail.supervisorActionByCompanyTH = PISUser.COMPANYNAME__c;
            COIReportDetail.supervisorActionByCompanyEN = PISUser.COMPANYNAME__c;
        	COIReportDetail.supervisorActionDate = system.Datetime.now();
            
            COIReportDetail.supervisorApproverStatus = new CG_Global.EnumValue(CGReporting.Supervisor_Approver_Status__c);
        	if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes) || CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
                COIReportDetail.supervisorApproverStatus.key = '';
                COIReportDetail.supervisorApproverStatus.value = '';
            }
            else {
                if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged)) {
                    COIReportDetail.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Acknowledged.name();
                    COIReportDetail.supervisorApproverStatus.value = CG_Enum.ApproverStatus.Acknowledged.name();
                }
                else if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Rejected)) {
                    COIReportDetail.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Rejected.name();
                    COIReportDetail.supervisorApproverStatus.value = CG_Enum.ApproverStatus.Rejected.name();
                }
            }
            
        }
        else {
            COIReportDetail.supervisorActionByTH = CGReporting.Supervisor_Action_By_TH__c;
            COIReportDetail.supervisorActionByEN = CGReporting.Supervisor_Action_By_EN__c;
            COIReportDetail.supervisorActionByPositionTH = CGReporting.Supervisor_Action_By_Position_TH__c;
            COIReportDetail.supervisorActionByPositionEN = CGReporting.Supervisor_Action_By_Position_EN__c;
            COIReportDetail.supervisorActionByCompanyTH = CGReporting.Supervisor_Action_By_Company_TH__c;
            COIReportDetail.supervisorActionByCompanyEN = CGReporting.Supervisor_Action_By_Company_EN__c;
            COIReportDetail.supervisorActionDate = CGReporting.Supervisor_Action_Date__c;
            
            COIReportDetail.supervisorApproverStatus = new CG_Global.EnumValue(CGReporting.Supervisor_Approver_Status__c);
        	if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged)) {
                COIReportDetail.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Acknowledged.name();
                COIReportDetail.supervisorApproverStatus.value = CG_Enum.ApproverStatus.Acknowledged.name();
            }
            else if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Rejected)) {
                COIReportDetail.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Rejected.name();
                COIReportDetail.supervisorApproverStatus.value = CG_Enum.ApproverStatus.Rejected.name();
            }
        }
        
        /* COIReportDetail.supervisorApproverStatus = new CG_Global.EnumValue(CGReporting.Supervisor_Approver_Status__c);
        if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged)) {
            COIReportDetail.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Acknowledged.name();
            COIReportDetail.supervisorApproverStatus.value = CG_Enum.ApproverStatus.Acknowledged.name();
        }
        else if(CGReporting.Supervisor_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Rejected)) {
            COIReportDetail.supervisorApproverStatus.key = CG_Enum.ApproverStatus.Rejected.name();
            COIReportDetail.supervisorApproverStatus.value = CG_Enum.ApproverStatus.Rejected.name();
        } */
        
        COIReportDetail.supervisorComment = CGReporting.Supervisor_Comment__c;
        
        //GLVP
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
        	string userId = CG_PrivilegeHandler.getUserId();
            
            List<PISUsers__c> GLVPPISUsers = CG_Global.assignToGLVPPISUser();
            
            if(GLVPPISUsers.size() > 0) {
                for(PISUsers__c GLVP : GLVPPISUsers) {
                    if(userId == GLVP.User__c) {
                        COIReportDetail.glvpActionByTH = GLVP.THTITLE__c + ' ' + GLVP.THFIRSTNAME__c + ' ' + GLVP.THLASTNAME__c;
                        COIReportDetail.glvpActionByEN = GLVP.EN_Fullname__c;
                        COIReportDetail.glvpActionByPositionTH = GLVP.OBJTHFULLNAME__c;
                        COIReportDetail.glvpActionByPositionEN = GLVP.OBJENFULLNAME__c;
                        COIReportDetail.glvpActionByCompanyTH = GLVP.COMPANYNAME__c;
                        COIReportDetail.glvpActionByCompanyEN = GLVP.COMPANYNAME__c;
        				COIReportDetail.glvpActionDate = system.Datetime.now();
                    }
                }
            }
        }
        else {
            COIReportDetail.glvpActionByTH = CGReporting.GLVP_Action_By_TH__c;
            COIReportDetail.glvpActionByEN = CGReporting.GLVP_Action_By_EN__c;
            COIReportDetail.glvpActionByPositionTH = CGReporting.GLVP_Action_By_Position_TH__c;
            COIReportDetail.glvpActionByPositionEN = CGReporting.GLVP_Action_By_Position_EN__c;
            COIReportDetail.glvpActionByCompanyTH = CGReporting.GLVP_Action_By_Company_TH__c;
            COIReportDetail.glvpActionByCompanyEN = CGReporting.GLVP_Action_By_Company_EN__c;
            COIReportDetail.glvpActionDate = CGReporting.GLVP_Action_Date__c;
        }
        
        COIReportDetail.glvpApproverStatus = new CG_Global.EnumValue(CGReporting.GLVP_Approver_Status__c);
        if(CGReporting.GLVP_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged)) {
            COIReportDetail.glvpApproverStatus.key = CG_Enum.ApproverStatus.Acknowledged.name();
            COIReportDetail.glvpApproverStatus.value = CG_Enum.ApproverStatus.Acknowledged.name();
        }
        else if(CGReporting.GLVP_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Rejected)) {
            COIReportDetail.glvpApproverStatus.key = CG_Enum.ApproverStatus.Rejected.name();
            COIReportDetail.glvpApproverStatus.value = CG_Enum.ApproverStatus.Rejected.name();
        }
        
        COIReportDetail.glvpComment = CGReporting.GLVP_Comment__c;
        
        //GLGC 
        COIReportDetail.glgcReceiveBy = CGReporting.GLGC_Receive_By__c;
        COIReportDetail.glgcActionByTH = CGReporting.GLGC_Action_By_TH__c;
        COIReportDetail.glgcActionByEN = CGReporting.GLGC_Action_By_EN__c;
        COIReportDetail.glgcActionByPositionTH = CGReporting.GLGC_Action_By_Position_TH__c;
        COIReportDetail.glgcActionByPositionEN = CGReporting.GLGC_Action_By_Position_EN__c;
        COIReportDetail.glgcActionByCompanyTH = CGReporting.GLGC_Action_By_Company_TH__c;
        COIReportDetail.glgcActionByCompanyEN = CGReporting.GLGC_Action_By_Company_TH__c;
        COIReportDetail.glgcActionDate = CGReporting.GLGC_Action_Date__c;
        
        COIReportDetail.glgcApproverStatus = new CG_Global.EnumValue(CGReporting.GLGC_Approver_Status__c);
        if(CGReporting.GLGC_Approver_Status__c == String.ValueOf(CG_Enum.ApproverStatus.Acknowledged)) {
            COIReportDetail.glgcApproverStatus.key = CG_Enum.ApproverStatus.Acknowledged.name();
            COIReportDetail.glgcApproverStatus.value = CG_Enum.ApproverStatus.Acknowledged.name();
        }
            
        COIReportDetail.canEdit = checkCanEdit(String.ValueOf(CGReporting.Status__c));
        COIReportDetail.canSubmit = checkCanSubmit(String.ValueOf(CGReporting.Status__c), userProfile);
        
        COIReportDetail.canSupervisorAcknowledge = false;
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.Supervisor) || userProfile == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin) ) {
        	COIReportDetail.canSupervisorAcknowledge = checkCanSupervisorAcknowledge(String.ValueOf(CGReporting.Status__c));
        }
        
        COIReportDetail.canGLVPAcknowledge = false;
        if(userProfile == String.ValueOf(CG_Enum.ApproverRole.GLVP) || userProfile == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin) ) {
        	COIReportDetail.canGLVPAcknowledge = checkCanGLVPAcknowledge(String.ValueOf(CGReporting.Status__c));
        }
        
        COIReportDetail.isShowSupervisorComment = checkShowSupervisorComment(String.ValueOf(CGReporting.Status__c));
        COIReportDetail.isShowGLVPComment = checkShowGLVPComment(String.ValueOf(CGReporting.Status__c));
        
        return COIReportDetail;
    }
    
    private static CG_DTO.COIMassAcknowledgeListDTO assignToCOIMassAcknowledgeListDTO(CG_Reporting__c CGReporting, User currentUser) {
        
        CG_DTO.COIMassAcknowledgeListDTO COIMass = new CG_DTO.COIMassAcknowledgeListDTO();
        COIMass.id = CGReporting.Id;
        COIMass.reportNumber = CGReporting.Running_No__c;
        
        COIMass.reportType = new CG_Global.EnumValue('COIReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
            COIMass.reportType.key = CG_Enum.COIReportType.COIAnnual.name();
            COIMass.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
            COIMass.reportType.key = CG_Enum.COIReportType.COIIncident.name();
            COIMass.reportType.value = 'Incident';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            COIMass.reportType.key = CG_Enum.COIReportType.COINewEmployee.name();
            COIMass.reportType.value = 'New Employee';
        }
        
        COIMass.disclosureReport = new CG_Global.EnumValue(CGReporting.COI_Disclosure__c);
        if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes)) {
            COIMass.disclosureReport.key = CG_Enum.COIDisclosure.Yes.name();
            COIMass.disclosureReport.value = CG_Enum.COIDisclosure.Yes.name();
        }
        else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
            COIMass.disclosureReport.key = CG_Enum.COIDisclosure.No.name();
            COIMass.disclosureReport.value = CG_Enum.COIDisclosure.No.name();
        }
        else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
            COIMass.disclosureReport.key = CG_Enum.COIDisclosure.NotSure.name();
            COIMass.disclosureReport.value = CG_Enum.COIDisclosure.NotSure.name();
        }
        
        COIMass.supervisorName = CGReporting.Supervisor_Name__c;
        COIMass.submittedDate = CGReporting.Submitted_Date__c;
        
        COIMass.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            COIMass.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            COIMass.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            COIMass.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            COIMass.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            COIMass.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            COIMass.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            COIMass.status.key = CG_Enum.ReportStatus.Rejected.name();
            COIMass.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            COIMass.status.key = CG_Enum.ReportStatus.Success.name();
            COIMass.status.value = 'Success';            
        }
        
        COIMass.ownerName = currentUser.Name;
        COIMass.ownerPosition = currentUser.Position__c;
        COIMass.ownerSection = currentUser.Section__c;
        
        return COIMass;
        
    }

    @TestVisible
    private static CG_DTO.COIReportHistoryListDTO assignToCOIReportHistoryListDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.COIReportHistoryListDTO COIReporting = new CG_DTO.COIReportHistoryListDTO();
        COIReporting.id = CGReporting.Id;
        COIReporting.reportNumber = CGReporting.Running_No__c;
        
        COIReporting.reportType = new CG_Global.EnumValue('COIReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
            COIReporting.reportType.key = CG_Enum.COIReportType.COIAnnual.name();
            COIReporting.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
            COIReporting.reportType.key = CG_Enum.COIReportType.COIIncident.name();
            COIReporting.reportType.value = 'Incident';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            COIReporting.reportType.key = CG_Enum.COIReportType.COINewEmployee.name();
            COIReporting.reportType.value = 'New Employee';
        }
        
        COIReporting.disclosureReport = new CG_Global.EnumValue(CGReporting.COI_Disclosure__c);
        if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes)) {
            COIReporting.disclosureReport.key = CG_Enum.COIDisclosure.Yes.name();
            COIReporting.disclosureReport.value = CG_Enum.COIDisclosure.Yes.name();
        }
        else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
            COIReporting.disclosureReport.key = CG_Enum.COIDisclosure.No.name();
            COIReporting.disclosureReport.value = CG_Enum.COIDisclosure.No.name();
        }
        else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
            COIReporting.disclosureReport.key = CG_Enum.COIDisclosure.NotSure.name();
            COIReporting.disclosureReport.value = CG_Enum.COIDisclosure.NotSure.name();
        }
        
        COIReporting.supervisorName = CGReporting.Supervisor_Name__c;
        COIReporting.submittedDate = CGReporting.Submitted_Date__c;
        
        COIReporting.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            COIReporting.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            COIReporting.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            COIReporting.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            COIReporting.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            COIReporting.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            COIReporting.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            COIReporting.status.key = CG_Enum.ReportStatus.Rejected.name();
            COIReporting.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            COIReporting.status.key = CG_Enum.ReportStatus.Success.name();
            COIReporting.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            COIReporting.status.key = CG_Enum.ReportStatus.Expired.name();
            COIReporting.status.value = 'Expired';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Cancel)) {
            COIReporting.status.key = CG_Enum.ReportStatus.Cancel.name();
            COIReporting.status.value = 'Cancel';            
        }
        
        return COIReporting;
        
    }

    private static CG_DTO.CompanyDTO assignToCompanyDTO(string companyName) {
        CG_DTO.CompanyDTO CompanyDTO = new CG_DTO.CompanyDTO();
        CompanyDTO.id = companyName;
        CompanyDTO.name = companyName;
        CompanyDTO.fullName = companyName;
        return CompanyDTO;
    }
    
    @TestVisible
    private static CG_DTO.AdminCOIReportListDTO assignToAdminCOIReportListDTO(CG_Reporting__c CGReporting, Map<string,CG_DTO.UserDTO> userDTOs) {
        
        CG_DTO.AdminCOIReportListDTO AdminCOIReport = new CG_DTO.AdminCOIReportListDTO();
        
        AdminCOIReport.id = CGReporting.Id;
        AdminCOIReport.reportNumber = CGReporting.Running_No__c;
        
        AdminCOIReport.reportType = new CG_Global.EnumValue('COIReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
            AdminCOIReport.reportType.key = CG_Enum.COIReportType.COIAnnual.name();
            AdminCOIReport.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
            AdminCOIReport.reportType.key = CG_Enum.COIReportType.COIIncident.name();
            AdminCOIReport.reportType.value = 'Incident';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            AdminCOIReport.reportType.key = CG_Enum.COIReportType.COINewEmployee.name();
            AdminCOIReport.reportType.value = 'New Employee';
        }
        
        AdminCOIReport.badge = 0;
        AdminCOIReport.position = CGReporting.Owner_Position__c;
        AdminCOIReport.supervisorName = CGReporting.Supervisor_Name__c;
        
        AdminCOIReport.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            AdminCOIReport.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            AdminCOIReport.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            AdminCOIReport.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            AdminCOIReport.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            AdminCOIReport.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            AdminCOIReport.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            AdminCOIReport.status.key = CG_Enum.ReportStatus.Rejected.name();
            AdminCOIReport.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            AdminCOIReport.status.key = CG_Enum.ReportStatus.Success.name();
            AdminCOIReport.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            AdminCOIReport.status.key = CG_Enum.ReportStatus.Expired.name();
            AdminCOIReport.status.value = 'Expired';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Cancel)) {
            AdminCOIReport.status.key = CG_Enum.ReportStatus.Cancel.name();
            AdminCOIReport.status.value = 'Cancel';            
        }
        
        AdminCOIReport.startDuration = CGReporting.Start_Duration__c;
        AdminCOIReport.endDuration = CGReporting.End_Duration__c;
        AdminCOIReport.submittedDate = CGReporting.Submitted_Date__c;
        
        if(CGReporting.COI_Disclosure__c == null || String.isEmpty(CGReporting.COI_Disclosure__c)) {
            AdminCOIReport.disclosureReport = new CG_Global.EnumValue();
            AdminCOIReport.disclosureReport.key = '';
            AdminCOIReport.disclosureReport.value = '';
        }
        else {
            AdminCOIReport.disclosureReport = new CG_Global.EnumValue(CGReporting.COI_Disclosure__c);
            if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes)) {
                AdminCOIReport.disclosureReport.key = CG_Enum.COIDisclosure.Yes.name();
                AdminCOIReport.disclosureReport.value = CG_Enum.COIDisclosure.Yes.name();
            }
            else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
                AdminCOIReport.disclosureReport.key = CG_Enum.COIDisclosure.No.name();
                AdminCOIReport.disclosureReport.value = CG_Enum.COIDisclosure.No.name();
            }
            else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
                AdminCOIReport.disclosureReport.key = CG_Enum.COIDisclosure.NotSure.name();
                AdminCOIReport.disclosureReport.value = CG_Enum.COIDisclosure.NotSure.name();
            }
        }
        //AdminCOIReport.owner = CG_Global.assignToUserDTO(CGReporting.OwnerId);
        AdminCOIReport.owner = userDTOs.get(CGReporting.OwnerId);
        AdminCOIReport.canResend = checkCanResend(String.ValueOf(AdminCOIReport.status.key));
        AdminCOIReport.canCancel = checkCanCancel(String.ValueOf(AdminCOIReport.status.key));
        
        return AdminCOIReport;
    }
    
    @RemoteAction
    public static List<CG_DTO.CompanyDTO> CGGlobal_GetCompanieFromPISUsers() {
        
        List<CG_DTO.CompanyDTO> Companies = CG_Global.GetCompanies();
        
        return Companies;
    } 
    
    @RemoteAction
    public static List<CG_DTO.CompanyDTO> CGGlobal_GetCompanies() {
        
        List<CG_DTO.CompanyDTO> Companies = new List<CG_DTO.CompanyDTO>();
        
        List<string> coiCompanies = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = CG_Reporting__c.COI_Transaction_Company_Name__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            coiCompanies.add(objPickList.getValue());
            System.debug('Value = ' +objPickList.getValue() +' , Label = ' +objPickList.getLabel());
        }
        
        if(coiCompanies.size() > 0) {
            integer count = 1;
            for(string COICompany : coiCompanies) {
                CG_DTO.CompanyDTO Company = new CG_DTO.CompanyDTO();
                Company.id = String.ValueOf(count);
                Company.name = COICompany;
                Company.fullname = COICompany;
                Companies.add(Company);
            }
        }
        
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
    
    private static List<integer> AddDataToSeries(integer data, integer functionCount) {
        List<integer> datas = new List<integer>();
        System.debug('functionCount : ' + functionCount);
        
        /* for(integer i=0; i<=functionCount; i++) {
            if(i == functionCount) {
            	datas.add(data);
            }
            else {
            	datas.add(0);
            }
        } */
        
        datas.add(data);
        
        return datas;
    }
    public class ReportCOISearchCriteria {
        //enum COIReportType
        @RemoteAction
        public string reportType {get;set;}
        //enum ReportStatus
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public datetime startDate {get;set;}
        @RemoteAction
        public datetime endDate {get;set;}
        //enum COIDisclosure
        @RemoteAction
        public string coiAnswer {get;set;}
        @RemoteAction
        public string companyId {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
    }
}