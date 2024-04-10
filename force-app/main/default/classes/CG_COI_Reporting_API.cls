@RestResource(urlMapping='/CG_COI_Reporting_API/*')
global class CG_COI_Reporting_API {

    @HttpPost global static string doPost(string param) {
        
		Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'CheckAccessPrivilege' { return CheckAccessPrivilege(mapObject.get('reportId').toString()); }
            when 'GetIncidentReportCount' { return String.ValueOf(GetIncidentReportCount());}
            when 'GetIncidentReports' { return GetIncidentReports(mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString()); }
            when 'GetNewEmployeeReport' { return GetNewEmployeeReport(); }
            when 'GetAnnualReport' { return GetAnnualReport(); }
            when 'GetReportDetail' { return GetReportDetail(mapObject.get('reportId').toString()); }
            when 'DeleteIncidentReport' { DeleteIncidentReport(mapObject.get('reportId').toString()); return null; }
            when 'SaveAsDraftReport' { return SaveAsDraftReport(mapObject.get('report').toString()); }
            when 'SubmitReport' { return SubmitReport(mapObject.get('report').toString());}
            when 'GetReportWorkflow' { return GetReportWorkflow(mapObject.get('reportId').toString());}
            when 'GetCOIMassAcknowledgeCount' { return GetCOIMassAcknowledgeCount(); }
            when 'GetCOIMassAcknowledgeList' { return GetCOIMassAcknowledgeList(mapObject.get('disclosureReportKeys').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString());}
            when 'ApproveReport' { return ApproveReport(mapObject.get('report').toString());}
            when 'RejectReport' { return RejectReport(mapObject.get('report').toString());}
            when 'MassApproveReports' { MassApproveReports(mapObject.get('reportIds').toString()); return null;}
            when 'MassRejectReports' { MassRejectReports(mapObject.get('reportIds').toString(), mapObject.get('comment').toString()); return null;}
            when 'GetAdminCOIReportListCount' { return GetAdminCOIReportListCount(mapObject.get('ownerName').toString(), mapObject.get('ownerId').toString(), mapObject.get('companyId').toString(), mapObject.get('function').toString(), mapObject.get('department').toString(), mapObject.get('section').toString(), mapObject.get('unit').toString());}
            when 'GetAdminCOIReportList' { return GetAdminCOIReportList(mapObject.get('ownerName').toString(), mapObject.get('ownerId').toString(), mapObject.get('companyId').toString(), mapObject.get('function').toString(), mapObject.get('department').toString(), mapObject.get('section').toString(), mapObject.get('unit').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString());}
            when 'AdminResendReport' { AdminResendReport(mapObject.get('reportId').toString()); return null;}
            when 'AdminCancelReport' { AdminCancelReport(mapObject.get('reportId').toString()); return null;}
            when 'GetReportCOISummaryCount' { return GetReportCOISummaryCount(mapObject.get('filter').toString());}
            when 'ExportAllExcel' { return ExportAllExcel(mapObject.get('filter').toString());}
            when 'ExportTableExcel' { return ExportTableExcel(mapObject.get('filter').toString());}
            when 'GetReportCOIAnswerChart' { return GetReportCOIAnswerChart(mapObject.get('filter').toString());}
            when 'GetReportCOITypeRadialChart' { return GetReportCOITypeRadialChart(mapObject.get('filter').toString());}
            //when 'GetReportCOIStatusSeriesChart' { return GetReportCOIStatusSeriesChart(mapObject.get('filter').toString(), mapObject.get('groupingBy').toString());}
            //when 'GetReportCOIInfoList' { return GetReportCOIInfoList(mapObject.get('filter').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString());}
            //when 'GetReportCOIStatistics' { return GetReportCOIStatistics(mapObject.get('filter').toString());}
            when 'CGGlobal_GetCompanies' { return CGGlobal_GetCompanies();}
            when 'CGGlobal_GetFunctions' { return CGGlobal_GetFunctions(mapObject.get('companyId').toString());}
            when 'CGGlobal_GetDepartments' { return CGGlobal_GetDepartments(mapObject.get('function').toString());}
            when 'CGGlobal_GetSections' { return CGGlobal_GetSections(mapObject.get('department').toString());}
            when 'CGGlobal_GetUnits' { return CGGlobal_GetUnits(mapObject.get('section').toString());}
            when else {  return null; }
        }
        
    }
    
    //Check access privilege
    public static string CheckAccessPrivilege(string reportId) {
        boolean canAccess = CG_COI_Reporting.checkAccessPrivilege(reportId);
        
        string access = 'true';
        
        if(!canAccess) {
            access = 'false';
        }
        
        return access;
    }
    
    //Count all incident (for paging purpose)
    public static integer GetIncidentReportCount() {
        integer incidentCount = CG_COI_Reporting.GetIncidentReportCount();
        return incidentCount;
    }
    
    //Query Incident Table Data of logined user including paging and sorting
    public static string GetIncidentReports(
        //reportNumber, supervisorName, status, duration, submittedDate
        string sortByParam, 
        string pageParam) {
            
            CG_Global.SortByParam sortByParamGlobal = null;
            CG_Global.PageParam pageParamGlobal = null;
            
            if(sortByParam != null) {
        		System.debug(sortByParam);
                try{
                	sortByParamGlobal = (CG_Global.SortByParam)JSON.deserialize(sortByParam, CG_Global.SortByParam.class);
                }
                catch (exception e) {
                    System.debug(e);
                }
        	} 
            
            if(pageParam != null) {
                pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
            }
            
        List<CG_DTO.COIReportListDTO> results = CG_COI_Reporting.GetIncidentReports(sortByParamGlobal, pageParamGlobal);
            
        string actualResult = JSON.serialize(results);
            
        return actualResult;
    }
    
    //Query New Employee Report of logined user (if not exists, return null)
    public static string GetNewEmployeeReport() {
        
        CG_DTO.COIReportListDTO results = CG_COI_Reporting.GetNewEmployeeReport();
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
     //Query Annual Report of logined user (if not exists, return null)
    public static string GetAnnualReport() {
        
        CG_DTO.COIReportListDTO results = CG_COI_Reporting.GetAnnualReport();
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    //Get COI Report Detail using report id
    public static string GetReportDetail(string reportId) {
        
        CG_DTO.COIReportDetailDTO results = CG_COI_Reporting.GetReportDetail(reportId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    //Delete an Incident Report (only "Waiting for Submit")
    public static void DeleteIncidentReport(string reportId){

        CG_COI_Reporting.DeleteIncidentReport(reportId);
        
    }
    
    //Save as draft report (for employee)
    public static string SaveAsDraftReport(string report) {
        
        CG_DTO.COIReportDetailDTO COIReportDetailDTO = null;
        SYstem.debug(report);
        if(report != null) {
            COIReportDetailDTO = (CG_DTO.COIReportDetailDTO)JSON.deserialize(report, CG_DTO.COIReportDetailDTO.class);
        } 
        
        CG_DTO.COIReportDetailDTO results = CG_COI_Reporting.SaveAsDraftReport(COIReportDetailDTO);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    //Submit report (for employee)
    public static string SubmitReport(string report) {
        
        CG_DTO.COIReportDetailDTO COIReportDetailDTO = null;
        
        if(report != null) {
            COIReportDetailDTO = (CG_DTO.COIReportDetailDTO)JSON.deserialize(report, CG_DTO.COIReportDetailDTO.class);
        } 
        
        CG_DTO.COIReportDetailDTO results = CG_COI_Reporting.SubmitReport(COIReportDetailDTO);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    public static string GetReportWorkflow(string reportId) {
        
        CG_DTO.WorkflowHistoryDTO results = CG_COI_Reporting.GetReportWorkflow(reportId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetCOIMassAcknowledgeCount() {
        
        CG_DTO.COIMassAcknowledgeCountDTO results = CG_COI_Reporting.GetCOIMassAcknowledgeCount();
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetCOIMassAcknowledgeList(
    //enum DisclosureReport (comma-seperated)
    string disclosureReportKeys,
    //reportNumber, reportType, disclosureReport, supervisorName, submittedDate, status, ownerName, ownerPosition, ownerSection
    string sortByParam, 
    string pageParam
    ) {
        
        CG_Global.SortByParam sortByParamGlobal = null;
        CG_Global.PageParam pageParamGlobal = null;
        
        if(sortByParam != null) {
            sortByParamGlobal = (CG_Global.SortByParam)JSON.deserialize(sortByParam, CG_Global.SortByParam.class);
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
        }
        
        List<CG_DTO.COIMassAcknowledgeListDTO> results = CG_COI_Reporting.GetCOIMassAcknowledgeList(disclosureReportKeys, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string ApproveReport(string report) {
        
        CG_DTO.COIReportDetailDTO COIReportDetailDTO = null;
        
        if(report != null) {
            COIReportDetailDTO = (CG_DTO.COIReportDetailDTO)JSON.deserialize(report, CG_DTO.COIReportDetailDTO.class);
        } 
        
        CG_DTO.COIReportDetailDTO results = CG_COI_Reporting.ApproveReport(COIReportDetailDTO);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string RejectReport(string report) {
        
        CG_DTO.COIReportDetailDTO COIReportDetailDTO = null;
        
        if(report != null) {
            COIReportDetailDTO = (CG_DTO.COIReportDetailDTO)JSON.deserialize(report, CG_DTO.COIReportDetailDTO.class);
        } 
        
        CG_DTO.COIReportDetailDTO results = CG_COI_Reporting.RejectReport(COIReportDetailDTO);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static void MassApproveReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds
    ) {
        
        CG_COI_Reporting.MassApproveReports(reportIds);
        
    }
    
	public static void MassRejectReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds,
        string comment
    ) {
    	
        CG_COI_Reporting.MassRejectReports(reportIds, comment);
    }
    
    public static string GetAdminCOIReportListCount(
        //employee name
        string ownerName,
        //employee id
        string ownerId,
    	//companyId, function, department, section, unit
    	string companyId, string function, string department, string section, string unit) {
            
        CG_DTO.AdminCOIReportListCountDTO results = CG_COI_Reporting.GetAdminCOIReportListCount(ownerName, ownerId, companyId, function, department, section, unit);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetAdminCOIReportList(
    //employee name
    string ownerName,
    //employee id
    string ownerId,
    //companyId
    string companyId, string function, string department, string section, string unit,
    //reportNumber, reportType, disclosureReport, ownerFullName, reportStatus, submittedDate
    string sortByParam, 
    string pageParam
    ) {
    
        CG_Global.SortByParam sortByParamGlobal = null;
        CG_Global.PageParam pageParamGlobal = null;
        
        if(sortByParam != null) {
            sortByParamGlobal = (CG_Global.SortByParam)JSON.deserialize(sortByParam, CG_Global.SortByParam.class);
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
        }
        
        List<CG_DTO.AdminCOIReportListDTO> results = CG_COI_Reporting.GetAdminCOIReportList(ownerName, ownerId, companyId, function, department, section, unit, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static void AdminResendReport(string reportId) {
        CG_COI_Reporting.AdminResendReport(reportId);
    }
    
    public static void AdminCancelReport(string reportId) {
        CG_COI_Reporting.AdminCancelReport(reportId);
    }
    
    public static string GetReportCOISummaryCount(string filter) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        CG_DTO.ReportCOISummaryCountDTO results = CG_COI_Reporting.GetReportCOISummaryCount(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string ExportAllExcel(string filter) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        string results = CG_COI_Reporting.ExportAllExcel(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    public static string ExportTableExcel(string filter) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        string results = CG_COI_Reporting.ExportTableExcel(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetReportCOIAnswerChart(string filter) {
    
    	CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        CG_DTO.ReportCOIAnswerChartSeriesDTO results = CG_COI_Reporting.GetReportCOIAnswerChart(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetReportCOITypeRadialChart(string filter) {
    	
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        List<CG_DTO.ReportCOITypeRadialChartItemDTO> results = CG_COI_Reporting.GetReportCOITypeRadialChart(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        return actualResult;

    }
    
    /* public static string GetReportCOIStatusSeriesChart(
        string filter, 
        //Company, Function, Department, Section
        string groupingBy) {
            
            CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
            if(filter != null) {
                filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
            } 
            
            List<CG_DTO.ReportCOIStatusSeriesDTO> results = CG_COI_Reporting.GetReportCOIStatusSeriesChart(filterCriteria, groupingBy);
            
            string actualResult = JSON.serialize(results);
            return actualResult;
            
            
        }
    
    public static string GetReportCOIInfoList(string filter,
    //reportNumber, reportType, ownerFullName, ownerOrgFunction, reportStatus, submittedDate
    string sortByParam,
    string pageParam) {    
    
    	CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        CG_Global.SortByParam sortByParamGlobal = null;
        CG_Global.PageParam pageParamGlobal = null;
        
        if(sortByParam != null) {
            sortByParamGlobal = (CG_Global.SortByParam)JSON.deserialize(sortByParam, CG_Global.SortByParam.class);
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
        }
        
        List<CG_DTO.ReportCOIInfoDTO> results = CG_COI_Reporting.GetReportCOIInfoList(filterCriteria, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetReportCOIStatistics(string filter) {    
    
    	CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        CG_DTO.ReportCOIStatisticDTO results = CG_COI_Reporting.GetReportCOIStatistics(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    } */
    
    public static string CGGlobal_GetCompanies() {
        
        List<CG_DTO.CompanyDTO> results = CG_COI_Reporting.CGGlobal_GetCompanies();
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string CGGlobal_GetFunctions(string companyId) {
        
        List<string> results = CG_COI_Reporting.CGGlobal_GetFunctions(companyId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string CGGlobal_GetDepartments(string function) {
        
        List<string> results = CG_COI_Reporting.CGGlobal_GetDepartments(function);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string CGGlobal_GetSections(string department) {
        
        List<string> results = CG_COI_Reporting.CGGlobal_GetSections(department);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string CGGlobal_GetUnits(string section) {
        
        List<string> results = CG_COI_Reporting.CGGlobal_GetUnits(section);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    
}