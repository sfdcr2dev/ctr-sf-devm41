/* 
 * Author Softever
 */

@RestResource(urlMapping='/WAP_SafetyPermitReport_API/*')
global class WAP_SafetyPermitReport_API {
    
    @HttpPost global static string doPost(string param) {
        
        Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'GetSummaryPermitGraph' { return String.ValueOf(GetSummaryPermitGraph(mapObject.get('filter').toString()));}
            when 'GetSummaryPermitTable' { return String.ValueOf(GetSummaryPermitTable(mapObject.get('filter').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString()));}
            when 'GetSummaryPermitTableCount' { return String.ValueOf(GetSummaryPermitTableCount(mapObject.get('filter').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString()));}
            when 'ExportExcel' { return String.ValueOf(ExportExcel(mapObject.get('filter').toString()));}
            when 'allAreas' { return String.ValueOf(allAreas(mapObject.get('filter').toString()));}
            when else {  return null; }
        }
        
    }
    
    public static string GetSummaryPermitGraph(string filter) {
        
        WAP_SafetyPermitReport.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_SafetyPermitReport.SearchFilter)JSON.deserialize(filter, WAP_SafetyPermitReport.SearchFilter.class);
        } 
        
        WAP_DTO.SafetyPermitChartSeriesDTO results = WAP_SafetyPermitReport.GetSummaryPermitGraph(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    public static string GetSummaryPermitTableCount(string filter, string sortByParam, string pageParam) {
        
        WAP_SafetyPermitReport.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_SafetyPermitReport.SearchFilter)JSON.deserialize(filter, WAP_SafetyPermitReport.SearchFilter.class);
        } 
        
        WAP_Global.SortByParam sortByParamGlobal = null;
        WAP_Global.PageParam pageParamGlobal = null;
        
        if(sortByParam != null) {
            System.debug(sortByParam);
            try{
                sortByParamGlobal = (WAP_Global.SortByParam)JSON.deserialize(sortByParam, WAP_Global.SortByParam.class);
            }
            catch (exception e) {
                System.debug(e);
            }
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (WAP_Global.PageParam)JSON.deserialize(pageParam, WAP_Global.PageParam.class);
        }
        
        integer resultCount = WAP_SafetyPermitReport.GetSummaryPermitTableCount(filterCriteria, sortByParamGlobal, pageParamGlobal);
        
        string result = String.ValueOf(resultCount);
        
        return result;
    }
    
    public static string GetSummaryPermitTable(string filter, string sortByParam, string pageParam) {
        
        WAP_SafetyPermitReport.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_SafetyPermitReport.SearchFilter)JSON.deserialize(filter, WAP_SafetyPermitReport.SearchFilter.class);
        } 
        
        WAP_Global.SortByParam sortByParamGlobal = null;
        WAP_Global.PageParam pageParamGlobal = null;
        
        if(sortByParam != null) {
            System.debug(sortByParam);
            try{
                sortByParamGlobal = (WAP_Global.SortByParam)JSON.deserialize(sortByParam, WAP_Global.SortByParam.class);
            }
            catch (exception e) {
                System.debug(e);
            }
        } 
        
        if(pageParam != null) {
            pageParamGlobal = (WAP_Global.PageParam)JSON.deserialize(pageParam, WAP_Global.PageParam.class);
        }
        
        List<WAP_DTO.SafetyPermitReportDTO> results = WAP_SafetyPermitReport.GetSummaryPermitTable(filterCriteria, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    public static string ExportExcel(string filter) {
        
        WAP_SafetyPermitReport.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_SafetyPermitReport.SearchFilter)JSON.deserialize(filter, WAP_SafetyPermitReport.SearchFilter.class);
        } 
        
        string results = WAP_SafetyPermitReport.ExportExcel(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }

    public static string allAreas(string filter) {
        
        WAP_SafetyPermitReport.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_SafetyPermitReport.SearchFilter)JSON.deserialize(filter, WAP_SafetyPermitReport.SearchFilter.class);
        } 
        
        return JSON.serialize(WAP_SafetyPermitReport.allAreas(filterCriteria));
    }
    
}