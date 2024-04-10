/* 
 * Author Softever
 */

@RestResource(urlMapping='/WAP_Dashboard_API/*')
global class WAP_Dashboard_API {

    @HttpPost global static string doPost(string param) {

        Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'DailyClearanceCertificateChartSeries' { return String.ValueOf(DailyClearanceCertificateChartSeries(mapObject.get('filter').toString()));}
            when 'DetailReportByAreaChartSeries' { return String.ValueOf(DetailReportByAreaChartSeries(mapObject.get('filter').toString()));}
            when 'ClearanceCertificateYearChartSeries' { return String.ValueOf(ClearanceCertificateYearChartSeries(mapObject.get('filter').toString()));}
            when 'ExportClearanceCertificateExcel' { return String.ValueOf(ExportClearanceCertificateExcel(mapObject.get('excelName').toString(),mapObject.get('filter').toString()));}
            when 'DashboardHRWPieChartSeries' { return String.ValueOf(DashboardHRWPieChartSeries(mapObject.get('filter').toString()));}
            when 'DashboardHRWChartSeries' { return String.ValueOf(DashboardHRWChartSeries(mapObject.get('filter').toString()));}
            when 'DashboardTopFiveChartSeries' { return String.ValueOf(DashboardTopFiveChartSeries(mapObject.get('filter').toString()));}
            when 'ExportHighRiskWorkExcel' { return String.ValueOf(ExportHighRiskWorkExcel(mapObject.get('filter').toString()));}
            when 'allAreas' { return String.ValueOf(allAreas());}
            when else {  return null; }
        }
        
    }
    
    public static string DailyClearanceCertificateChartSeries(string filter) {
        
        WAP_Dashboard.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Dashboard.SearchFilter)JSON.deserialize(filter, WAP_Dashboard.SearchFilter.class);
        } 
        
        WAP_DTO.DashboardChartSeriesDTO results = WAP_Dashboard.DailyClearanceCertificateChartSeries(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    public static string DetailReportByAreaChartSeries(string filter) {
        
        WAP_Dashboard.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Dashboard.SearchFilter)JSON.deserialize(filter, WAP_Dashboard.SearchFilter.class);
        } 
        
        List<WAP_DTO.DashboardChartSeriesDTO> results = WAP_Dashboard.DetailReportByAreaChartSeries(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    public static string ClearanceCertificateYearChartSeries(string filter) {
        
        WAP_Dashboard.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Dashboard.SearchFilter)JSON.deserialize(filter, WAP_Dashboard.SearchFilter.class);
        } 
        
        List<WAP_DTO.DashboardChartSeriesDTO> results = WAP_Dashboard.ClearanceCertificateYearChartSeries(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    public static string ExportClearanceCertificateExcel(string excelName, string filter) {
        
        WAP_Dashboard.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Dashboard.SearchFilter)JSON.deserialize(filter, WAP_Dashboard.SearchFilter.class);
        } 
        
        string results = WAP_Dashboard.ExportClearanceCertificateExcel(excelName, filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    //High Risk Work
    public static string DashboardHRWPieChartSeries(string filter) {
        
        WAP_Dashboard.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Dashboard.SearchFilter)JSON.deserialize(filter, WAP_Dashboard.SearchFilter.class);
        } 
        
        WAP_DTO.DashboardPieChartSeriesDTO results = WAP_Dashboard.DashboardHRWPieChartSeries(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    public static string DashboardHRWChartSeries(string filter) {
        
        WAP_Dashboard.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Dashboard.SearchFilter)JSON.deserialize(filter, WAP_Dashboard.SearchFilter.class);
        } 
        
        WAP_DTO.DashboardHRWChartSeriesDTO results = WAP_Dashboard.DashboardHRWChartSeries(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
    
    public static string DashboardTopFiveChartSeries(string filter) {
        
        WAP_Dashboard.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Dashboard.SearchFilter)JSON.deserialize(filter, WAP_Dashboard.SearchFilter.class);
        } 
        
        WAP_DTO.DashboardChartSeriesDTO results = WAP_Dashboard.DashboardTopFiveChartSeries(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }
   
    public static string ExportHighRiskWorkExcel(string filter) {
        
        WAP_Dashboard.SearchFilter filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (WAP_Dashboard.SearchFilter)JSON.deserialize(filter, WAP_Dashboard.SearchFilter.class);
        } 
        
        string results = WAP_Dashboard.ExportHighRiskWorkExcel(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        
        return actualResult;
    }

    public static string allAreas() {
        return JSON.serialize(WAP_Dashboard.allAreas());
    }
    
}