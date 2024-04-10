/* Author Softever */
@RestResource(urlMapping='/ESS_ManpowerReport_API/*')
global class ESS_ManpowerReport_API {

    @HttpPost global static string doPost(string param) {
        
		Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'GetManpowerReportTableCount' { return String.ValueOf(GetManpowerReportTableCount(mapObject.get('filter').toString()));}
            when 'GetManpowerReportTable' { return GetManpowerReportTable(mapObject.get('filter').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString());}
            when 'ExportManpowerReportExcel' { return ExportManpowerReportExcel(mapObject.get('filter').toString());}
            when 'GetMSPReportGraph' { return GetMSPReportGraph(mapObject.get('filter').toString(), mapObject.get('groupingBy').toString());}
            when 'GetMSPReportByYearGraph' { return GetMSPReportByYearGraph(mapObject.get('filter').toString());}
            when 'GetMSPReportByTypeOfServiceGraph' { return GetMSPReportByTypeOfServiceGraph(mapObject.get('filter').toString());}
            when 'GetMSPReportByStatusGraph' { return GetMSPReportByStatusGraph(mapObject.get('filter').toString());}
            when 'GetProjectNames' { return GetProjectNames();}
            
            when 'ESSGlobal_GetFunctions' { return ESSGlobal_GetFunctions();}
            when 'ESSGlobal_GetDepartments' { return ESSGlobal_GetDepartments(mapObject.get('function').toString());}
            when 'ESSGlobal_GetSections' { return ESSGlobal_GetSections(mapObject.get('department').toString());}
            when 'ESSGlobal_GetUnits' { return ESSGlobal_GetUnits(mapObject.get('section').toString());}
            when else {  return null; }
        }
    
    }
    
    public static integer GetManpowerReportTableCount(string filter) {
        
        ESS_ManpowerReport.SearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (ESS_ManpowerReport.SearchCriteria)JSON.deserialize(filter, ESS_ManpowerReport.SearchCriteria.class);
        } 
        
        integer count = ESS_ManpowerReport.GetManpowerReportTableCount(filterCriteria);
        return count;
    }
    
    public static string GetManpowerReportTable(
    string filter,
    //documentNo, employeeId, employeeName, dateJoinedCompany, dateCompletedProbation, submittedDate, currentStatus, sectionHead, sectionHeadSubmittedDate, departmentHead, departmentHeadSubmittedDate, completedDate, probationStatus
    string sortByParam, 
    string pageParam
    ) {
        
        ESS_ManpowerReport.SearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (ESS_ManpowerReport.SearchCriteria)JSON.deserialize(filter, ESS_ManpowerReport.SearchCriteria.class);
        } 
        
        ESS_Global.SortByParam sortByParamGlobal = null;
        ESS_Global.PageParam pageParamGlobal = null;
        
        if(sortByParam != null) {
            sortByParamGlobal = (ESS_Global.SortByParam)JSON.deserialize(sortByParam, ESS_Global.SortByParam.class);
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (ESS_Global.PageParam)JSON.deserialize(pageParam, ESS_Global.PageParam.class);
        }
        
        List<ESS_ManpowerReport_DTO.ManpowerReportTableDTO> results = ESS_ManpowerReport.GetManpowerReportTable(filterCriteria, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string ExportManpowerReportExcel(string filter) {
        
        ESS_ManpowerReport.SearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (ESS_ManpowerReport.SearchCriteria)JSON.deserialize(filter, ESS_ManpowerReport.SearchCriteria.class);
        } 
        
        string results = ESS_ManpowerReport.ExportManpowerReportExcel(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
	public static string GetMSPReportGraph(
    string filter,
    string groupingBy
    ) {
        
        ESS_ManpowerReport.SearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (ESS_ManpowerReport.SearchCriteria)JSON.deserialize(filter, ESS_ManpowerReport.SearchCriteria.class);
        } 
        
        ESS_ManpowerReport_DTO.GraphDTO result = ESS_ManpowerReport.GetMSPReportGraph(filterCriteria, groupingBy);
        
        string actualResult = JSON.serialize(result);
        return actualResult;
        
    }
    
	public static string GetMSPReportByYearGraph(
    string filter
    ) {
        
        ESS_ManpowerReport.SearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (ESS_ManpowerReport.SearchCriteria)JSON.deserialize(filter, ESS_ManpowerReport.SearchCriteria.class);
        } 
        
        ESS_ManpowerReport_DTO.GraphDTO result = ESS_ManpowerReport.GetMSPReportByYearGraph(filterCriteria);
        
        string actualResult = JSON.serialize(result);
        return actualResult;
        
    }
    
	public static string GetMSPReportByTypeOfServiceGraph(
    string filter
    ) {
        
        ESS_ManpowerReport.SearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (ESS_ManpowerReport.SearchCriteria)JSON.deserialize(filter, ESS_ManpowerReport.SearchCriteria.class);
        } 
        
        ESS_ManpowerReport_DTO.GraphDTO result = ESS_ManpowerReport.GetMSPReportByTypeOfServiceGraph(filterCriteria);
        
        string actualResult = JSON.serialize(result);
        return actualResult;
        
    }
    
	public static string GetMSPReportByStatusGraph(
    string filter
    ) {
        
        ESS_ManpowerReport.SearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (ESS_ManpowerReport.SearchCriteria)JSON.deserialize(filter, ESS_ManpowerReport.SearchCriteria.class);
        } 
        
        ESS_ManpowerReport_DTO.GraphDTO result = ESS_ManpowerReport.GetMSPReportByStatusGraph(filterCriteria);
        
        string actualResult = JSON.serialize(result);
        return actualResult;
        
    }
    
    public static string GetProjectNames() {
        
        List<string> results = ESS_ManpowerReport.GetProjectNames();
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string ESSGlobal_GetFunctions() {
        
        List<string> results = ESS_ManpowerReport.ESSGlobal_GetFunctions();
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string ESSGlobal_GetDepartments(string function) {
        
        List<string> results = ESS_ManpowerReport.ESSGlobal_GetDepartments(function);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }    
    
    public static string ESSGlobal_GetSections(string department) {
        
        List<string> results = ESS_ManpowerReport.ESSGlobal_GetSections(department);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string ESSGlobal_GetUnits(string section) {
        
        List<string> results = ESS_ManpowerReport.ESSGlobal_GetUnits(section);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
}