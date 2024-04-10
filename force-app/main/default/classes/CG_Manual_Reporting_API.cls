@RestResource(urlMapping='/CG_Manual_Reporting_API/*')
global with sharing class CG_Manual_Reporting_API {

    @HttpPost global static string doPost(string param) {
        
		Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'CheckAccessPrivilege' { return CheckAccessPrivilege(mapObject.get('reportId').toString()); }
            when 'GetNewCGManualReportCount' { return String.ValueOf(GetNewCGManualReportCount());}
            when 'GetNewCGManualReports' { return GetNewCGManualReports(mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString()); }
            when 'GetNewEmployeeReport' { return GetNewEmployeeReport(); }
            when 'GetAnnualReport' { return GetAnnualReport(); }
            when 'GetReportDetail' { return GetReportDetail(mapObject.get('reportId').toString()); }
            when 'SubmitReport' { return SubmitReport(mapObject.get('report').toString());}
            when 'GetAdminCGReportListCount' { return GetAdminCGReportListCount(mapObject.get('ownerName').toString(), mapObject.get('ownerId').toString(), mapObject.get('companyId').toString(), mapObject.get('function').toString(), mapObject.get('department').toString(), mapObject.get('section').toString(), mapObject.get('unit').toString());}
            when 'GetAdminCGReportList' { return GetAdminCGReportList(mapObject.get('ownerName').toString(), mapObject.get('ownerId').toString(), mapObject.get('companyId').toString(), mapObject.get('function').toString(), mapObject.get('department').toString(), mapObject.get('section').toString(), mapObject.get('unit').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString());}
            when 'AdminResendReport' { AdminResendReport(mapObject.get('reportId').toString()); return null;}
            when 'AdminCancelReport' { AdminCancelReport(mapObject.get('reportId').toString()); return null;}
            when 'ManualFiles' { return ManualFiles(); }
            when 'CGAcknowledgeForm' { return CGAcknowledgeForm(mapObject.get('reportId').toString()); }
            when else {  return null; }
        }
        
    }

    //Check access privilege
    public static string CheckAccessPrivilege(string reportId) {
        boolean canAccess = CG_Manual_Reporting.checkAccessPrivilege(reportId);
        
        string access = 'true';
        
        if(!canAccess) {
            access = 'false';
        }
        
        return access;
    }
    
    //Count all new cg manual (for paging purpose)
    public static integer GetNewCGManualReportCount(){
        return CG_Manual_Reporting.GetNewCGManualReportCount();
    }

    //Query NewCGManual Table Data of logined user including paging and sorting
    public static string GetNewCGManualReports(
        //reportNumber, supervisorName, status, duration, submittedDate
        string sortByParam, 
        string pageParam) {
            CG_Global.SortByParam sortByParamGlobal = null;
            CG_Global.PageParam pageParamGlobal = null;
            
            if(sortByParam != null) {
                sortByParamGlobal = (CG_Global.SortByParam)JSON.deserialize(sortByParam, CG_Global.SortByParam.class);
        	} 
            
            if(pageParam != null) {
                pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
            }
            List<CG_DTO.CGManualReportListDTO> results = CG_Manual_Reporting.GetNewCGManualReports(sortByParamGlobal, pageParamGlobal);
            string actualResult = JSON.serialize(results);
            return actualResult;
    }

    //Query New Employee Report of logined user (if not exists, return null)
    public static string GetNewEmployeeReport(){
        CG_DTO.CGManualReportListDTO result =  CG_Manual_Reporting.GetNewEmployeeReport();
        string actualResult = JSON.serialize(result);
        return actualResult;
    }

    //Query Annual Report of logined user (if not exists, return null)
    public static string GetAnnualReport(){
        CG_DTO.CGManualReportListDTO result = CG_Manual_Reporting.GetAnnualReport();
        string actualResult = JSON.serialize(result);
        return actualResult;
    }

    //Get CG Report Detail using report id
    @RemoteAction
    public static string GetReportDetail(string reportId){
        CG_DTO.CGManualReportDetailDTO result = CG_Manual_Reporting.GetReportDetail(reportId);
        string actualResult = JSON.serialize(result);
        return actualResult;
    }

    //Submit report (for employee)
    public static string SubmitReport(string report){
        CG_DTO.CGManualReportDetailDTO input = null;
        if(report != null) {
            input = (CG_DTO.CGManualReportDetailDTO)JSON.deserialize(report, CG_DTO.CGManualReportDetailDTO.class);
        }
        CG_DTO.CGManualReportDetailDTO result = CG_Manual_Reporting.SubmitReport(input);
        string actualResult = JSON.serialize(result);
        return actualResult;
    }

    public static string GetAdminCGReportListCount(
        //employee name
        string ownerName,
        //employee id
        string ownerId,
    	//companyId, function, department, section, unit
    	string companyId, string function, string department, string section, string unit) {
            
            CG_DTO.AdminCGReportListCountDTO result = CG_Manual_Reporting.GetAdminCGReportListCount(ownerName, ownerId, companyId, function, department, section, unit);
            string actualResult = JSON.serialize(result);
            return actualResult;
    }

    public static string GetAdminCGReportList(
    //employee name
    string ownerName,
    //employee id
    string ownerId,
   	//companyId, function, department, section, unit
    string companyId, string function, string department, string section, string unit,
    //reportNumber, reportType, ownerFullName, reportStatus, submittedDate
    string sortByParam, 
    string pageParam
    ){
        CG_Global.SortByParam sortByParamGlobal = null;
        CG_Global.PageParam pageParamGlobal = null;

        if(sortByParam != null) {
            sortByParamGlobal = (CG_Global.SortByParam)JSON.deserialize(sortByParam, CG_Global.SortByParam.class);
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
        }
        List<CG_DTO.AdminCGReportListDTO> results = CG_Manual_Reporting.GetAdminCGReportList(ownerName, ownerId, companyId, function, department, section, unit, sortByParamGlobal, pageParamGlobal);
        string actualResult = JSON.serialize(results);
        return actualResult;
    }

    public static void AdminResendReport(string reportId){
        
    }

    public static void AdminCancelReport(string reportId){
        
    }
    
    public static string ManualFiles() {
        CG_DTO.CGManualFilesDTO result = CG_Manual_Reporting.ManualFiles();
        string actualResult = JSON.serialize(result);
        return actualResult;
    }
    
    public static string CGAcknowledgeForm(string reportId) {
        CG_DTO.CGAcknowledgeFormDTO result = CG_Manual_Reporting.CGAcknowledgeForm(reportId);
        string actualResult = JSON.serialize(result);
        return actualResult;
    }

    
}