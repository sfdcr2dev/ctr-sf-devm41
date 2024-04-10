@RestResource(urlMapping='/CG_Reporting_History_API/*')
global class CG_Reporting_History_API {

    @HttpPost global static string doPost(string param) {
        
		Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'GetCOIHistoryCount' { return GetCOIHistoryCount(mapObject.get('startDate').toString(), mapObject.get('endDate').toString());}
            when 'GetCOIHistoryList' { return GetCOIHistoryList(mapObject.get('startDate').toString(), mapObject.get('endDate').toString(),mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString()); }
            
            when 'GetCGHistoryCount' { return GetCGHistoryCount(mapObject.get('startDate').toString(), mapObject.get('endDate').toString());}
            when 'GetCGHistoryList' { return GetCOIHistoryList(mapObject.get('startDate').toString(), mapObject.get('endDate').toString(),mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString()); }
            when 'GetCGReportWorkflow' { return GetCGReportWorkflow(mapObject.get('reportId').toString());}
            
            when 'GetGiftHistoryCount' { return GetGiftHistoryCount(mapObject.get('startDate').toString(), mapObject.get('endDate').toString());}
            when 'GetGiftHistoryList' { return GetGiftHistoryList(mapObject.get('startDate').toString(), mapObject.get('endDate').toString(),mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString()); }
            when 'GetGiftReportWorkflow' { return GetGiftReportWorkflow(mapObject.get('reportId').toString());}
            when else {  return null; }
        }
    }
    
    //COI
    public static string GetCOIHistoryCount(string startDateParam, string endDateParam) {

        DateTime startDate = null;
        DateTime endDate = null;
        
        if(startDateParam != null) {
            startDate = (DateTime)JSON.deserialize(startDateParam, DateTime.class);
        } 
        if(endDateParam != null) {
            endDate = (DateTime)JSON.deserialize(endDateParam, DateTime.class);
        } 
        
        CG_DTO.COIReportHistoryCountDTO results = CG_Reporting_History.GetCOIHistoryCount(startDate, endDate);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    public static string GetCOIHistoryList(string startDateParam, string endDateParam,
    //reportNumber, reportType, disclosureReport, supervisorName, submittedDate, status
    string sortByParam, 
    string pageParam
    ) {

        DateTime startDate = null;
        DateTime endDate = null;
        
        if(startDateParam != null) {
            //startDate = (DateTime)JSON.deserialize('"' + startDateParam + '"', DateTime.class);
            startDate = (DateTime)JSON.deserialize(startDateParam, DateTime.class);
        } 
        if(endDateParam != null) {
            //endDate = (DateTime)JSON.deserialize('"' + endDateParam + '"', DateTime.class);
            endDate = (DateTime)JSON.deserialize(endDateParam, DateTime.class);
        } 
        
        CG_Global.SortByParam sortByParamGlobal = null;
        CG_Global.PageParam pageParamGlobal = null;
        
        if(sortByParam != null) {
            sortByParamGlobal = (CG_Global.SortByParam)JSON.deserialize(sortByParam, CG_Global.SortByParam.class);
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
        }
        
        List<CG_DTO.COIReportHistoryListDTO> results = CG_Reporting_History.GetCOIHistoryList(startDate, endDate, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    //Manual
    public static string GetCGHistoryCount(string startDateParam, string endDateParam) {
    	
        DateTime startDate = null;
        DateTime endDate = null;
        
        if(startDateParam != null) {
            startDate = (DateTime)JSON.deserialize(startDateParam, DateTime.class);
        } 
        if(endDateParam != null) {
            endDate = (DateTime)JSON.deserialize(endDateParam, DateTime.class);
        } 
        
        CG_DTO.CGReportHistoryCountDTO results = CG_Reporting_History.GetCGHistoryCount(startDate, endDate);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    public static string GetCGHistoryList(string startDateParam, string endDateParam,
    //reportNumber, reportType, disclosureReport, supervisorName, submittedDate, status
    string sortByParam, 
    string pageParam
    ) {
        
        DateTime startDate = null;
        DateTime endDate = null;
        
        if(startDateParam != null) {
            //startDate = (DateTime)JSON.deserialize('"' + startDateParam + '"', DateTime.class);
            startDate = (DateTime)JSON.deserialize(startDateParam, DateTime.class);
        } 
        if(endDateParam != null) {
            //endDate = (DateTime)JSON.deserialize('"' + endDateParam + '"', DateTime.class);
            endDate = (DateTime)JSON.deserialize(endDateParam, DateTime.class);
        } 
        
        CG_Global.SortByParam sortByParamGlobal = null;
        CG_Global.PageParam pageParamGlobal = null;
        
        if(sortByParam != null) {
            sortByParamGlobal = (CG_Global.SortByParam)JSON.deserialize(sortByParam, CG_Global.SortByParam.class);
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
        }
        
        List<CG_DTO.CGReportHistoryListDTO> results = CG_Reporting_History.GetCGHistoryList(startDate, endDate, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetCGReportWorkflow(string reportId) {
        
        CG_DTO.WorkflowHistoryDTO results = CG_Reporting_History.GetCGReportWorkflow(reportId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    //Gift
    public static string GetGiftHistoryCount(string startDateParam, string endDateParam) {
    	
        DateTime startDate = null;
        DateTime endDate = null;
        
        if(startDateParam != null) {
            startDate = (DateTime)JSON.deserialize(startDateParam, DateTime.class);
        } 
        if(endDateParam != null) {
            endDate = (DateTime)JSON.deserialize(endDateParam, DateTime.class);
        } 
        
        CG_DTO.GiftReportHistoryCountDTO results = CG_Reporting_History.GetGiftHistoryCount(startDate, endDate);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    public static string GetGiftHistoryList(string startDateParam, string endDateParam,
    //reportNumber, supervisorName, submittedDate, status
    string sortByParam, 
    string pageParam
    ) {
        
        DateTime startDate = null;
        DateTime endDate = null;
        
        if(startDateParam != null) {
            //startDate = (DateTime)JSON.deserialize('"' + startDateParam + '"', DateTime.class);
            startDate = (DateTime)JSON.deserialize(startDateParam, DateTime.class);
        } 
        if(endDateParam != null) {
            //endDate = (DateTime)JSON.deserialize('"' + endDateParam + '"', DateTime.class);
            endDate = (DateTime)JSON.deserialize(endDateParam, DateTime.class);
        } 
        
        CG_Global.SortByParam sortByParamGlobal = null;
        CG_Global.PageParam pageParamGlobal = null;
        
        if(sortByParam != null) {
            sortByParamGlobal = (CG_Global.SortByParam)JSON.deserialize(sortByParam, CG_Global.SortByParam.class);
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
        }
        
        List<CG_DTO.GiftReportHistoryListDTO> results = CG_Reporting_History.GetGiftHistoryList(startDate, endDate, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetGiftReportWorkflow(string reportId) {
        
        CG_DTO.WorkflowHistoryDTO results = CG_Reporting_History.GetGiftReportWorkflow(reportId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
}