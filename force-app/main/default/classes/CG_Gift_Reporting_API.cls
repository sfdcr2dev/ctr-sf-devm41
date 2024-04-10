@RestResource(urlMapping='/CG_Gift_Reporting_API/*')
global class CG_Gift_Reporting_API {

	@HttpPost global static string doPost(string param) {
        
		Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'CheckAccessPrivilege' { return CheckAccessPrivilege(mapObject.get('reportId').toString()); }
            when 'GetGiftReportCount' { return String.ValueOf(GetGiftReportCount());}
            when 'GetGiftReports' { return GetGiftReports(mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString()); }
        	when 'GetReportDetail' { return GetReportDetail(mapObject.get('reportId').toString()); }
            when 'SaveAsDraftReport' { return SaveAsDraftReport(mapObject.get('report').toString()); }
            when 'SubmitReport' { return SubmitReport(mapObject.get('report').toString());}
            when 'GetReportWorkflow' { return GetReportWorkflow(mapObject.get('reportId').toString());}
            when 'ApproveReport' { return ApproveReport(mapObject.get('report').toString());}
            when 'RejectReport' { return RejectReport(mapObject.get('report').toString());}
            when 'MassApproveReports' { MassApproveReports(mapObject.get('reportIds').toString()); return null;}
            when 'GetAdminGiftReportListCount' { return GetAdminGiftReportListCount(mapObject.get('ownerName').toString(), mapObject.get('ownerId').toString(), mapObject.get('companyId').toString(), mapObject.get('function').toString(), mapObject.get('department').toString(), mapObject.get('section').toString(), mapObject.get('unit').toString());}
            when 'GetAdminGiftReportList' { return GetAdminGiftReportList(mapObject.get('ownerName').toString(), mapObject.get('ownerId').toString(), mapObject.get('companyId').toString(), mapObject.get('function').toString(), mapObject.get('department').toString(), mapObject.get('section').toString(), mapObject.get('unit').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString());}
            when 'AdminResendReport' { AdminResendReport(mapObject.get('reportId').toString()); return null;}
            when 'AdminCancelReport' { AdminCancelReport(mapObject.get('reportId').toString()); return null;}
            
            when else {  return null; }
        }
        
    }

    //Check access privilege
    public static string CheckAccessPrivilege(string reportId) {
        boolean canAccess = CG_Gift_Reporting.checkAccessPrivilege(reportId);
        
        string access = 'true';
        
        if(!canAccess) {
            access = 'false';
        }
        
        return access;
    }
    
    //Count all Gift (for paging purpose)
    public static integer GetGiftReportCount() {
        integer giftCount = CG_Gift_Reporting.GetGiftReportCount();
        return giftCount;
    }
    
    //Query Incident Table Data of logined user including paging and sorting
    public static string GetGiftReports(
        //reportNumber, supervisorName, status, duration, submittedDate
        string sortByParam, 
        string pageParam) {
            
            CG_Global.SortByParam sortByParamGlobal = null;
            CG_Global.PageParam pageParamGlobal = null;
            
            if(sortByParam != null) {
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
            
        List<CG_DTO.GiftReportListDTO> results = CG_Gift_Reporting.GetGiftReports(sortByParamGlobal, pageParamGlobal);
            
        string actualResult = JSON.serialize(results);
            
        return actualResult;
    }

	//Get Gift Report Detail using report id
    public static string GetReportDetail(string reportId) {
        
        CG_DTO.GiftReportDetailDTO results = CG_Gift_Reporting.GetReportDetail(reportId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    //Save as draft report
    public static string SaveAsDraftReport(string report) {
        
        CG_DTO.GiftReportDetailDTO GiftReportDetailDTO = null;
        
        if(report != null) {
            GiftReportDetailDTO = (CG_DTO.GiftReportDetailDTO)JSON.deserialize(report, CG_DTO.GiftReportDetailDTO.class);
        } 
        
        CG_DTO.GiftReportDetailDTO results = CG_Gift_Reporting.SaveAsDraftReport(GiftReportDetailDTO);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    //Submit report (for employee)
    public static string SubmitReport(string report) {
        
        CG_DTO.GiftReportDetailDTO GiftReportDetailDTO = null;
        
        if(report != null) {
            GiftReportDetailDTO = (CG_DTO.GiftReportDetailDTO)JSON.deserialize(report, CG_DTO.GiftReportDetailDTO.class);
        } 
        
        CG_DTO.GiftReportDetailDTO results = CG_Gift_Reporting.SubmitReport(GiftReportDetailDTO);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    public static string GetReportWorkflow(string reportId) {
        
        CG_DTO.WorkflowHistoryDTO results = CG_Gift_Reporting.GetReportWorkflow(reportId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string ApproveReport(string report) {
        
        CG_DTO.GiftReportDetailDTO GiftReportDetailDTO = null;
        
        if(report != null) {
            GiftReportDetailDTO = (CG_DTO.GiftReportDetailDTO)JSON.deserialize(report, CG_DTO.GiftReportDetailDTO.class);
        } 
        
        CG_DTO.GiftReportDetailDTO results = CG_Gift_Reporting.ApproveReport(GiftReportDetailDTO);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string RejectReport(string report) {
        
        CG_DTO.GiftReportDetailDTO GiftReportDetailDTO = null;
        
        if(report != null) {
            GiftReportDetailDTO = (CG_DTO.GiftReportDetailDTO)JSON.deserialize(report, CG_DTO.GiftReportDetailDTO.class);
        } 
        
        CG_DTO.GiftReportDetailDTO results = CG_Gift_Reporting.RejectReport(GiftReportDetailDTO);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static void MassApproveReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds
    ) {
        
        CG_COI_Reporting.MassApproveReports(reportIds);
        
    }
    
    
    public static string GetAdminGiftReportListCount(
        //employee name
        string ownerName,
        //employee id
        string ownerId,
    	//companyId, function, department, section, unit
    	string companyId, string function, string department, string section, string unit) {
    
        CG_DTO.AdminGiftReportListCountDTO results = CG_Gift_Reporting.GetAdminGiftReportListCount(ownerName, ownerId, companyId, function, department, section, unit);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetAdminGiftReportList(
    //employee name
    string ownerName,
    //employee id
    string ownerId,
    //companyId, function, department, section, unit
    string companyId, string function, string department, string section, string unit,
    //reportNumber, ownerFullName, supervisorDecision, reportStatus, giftStatus, lastUpdated
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
        
        List<CG_DTO.AdminGiftReportListDTO> results = CG_Gift_Reporting.GetAdminGiftReportList(ownerName, ownerId, companyId, function, department, section, unit, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static void AdminResendReport(string reportId) {
        CG_Gift_Reporting.AdminResendReport(reportId);
    }
    
    public static void AdminCancelReport(string reportId) {
        CG_Gift_Reporting.AdminCancelReport(reportId);
    }
    
    
}