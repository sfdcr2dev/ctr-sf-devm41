@RestResource(urlMapping='/CG_Report_API/*')
global class CG_Report_API {

    @HttpPost global static string doPost(string param) {
        
		Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            when 'GetReportCOISummaryCount' { return GetReportCOISummaryCount(mapObject.get('filter').toString());}
            when 'ExportCOIAllExcel' { return ExportCOIAllExcel(mapObject.get('filter').toString()); }
            when 'ExportCOITableExcel' { return ExportCOITableExcel(mapObject.get('filter').toString());}
            when 'GetReportCOIAnswerChart' { return GetReportCOIAnswerChart(mapObject.get('filter').toString()); }
            when 'GetReportCOITypeRadialChart' { return GetReportCOITypeRadialChart(mapObject.get('filter').toString()); }
            when 'GetReportCOIStatusSeriesChart' { return GetReportCOIStatusSeriesChart(mapObject.get('filter').toString(), mapObject.get('groupingBy').toString()); }
            when 'GetReportCOIInfoList' { return GetReportCOIInfoList(mapObject.get('filter').toString(), mapObject.get('sortByParam').toString(),mapObject.get('pageParam').toString()); }
            when 'GetReportCOIStatistics' { return GetReportCOIStatistics(mapObject.get('filter').toString()); }
            
            when 'GetReportCGSummaryCount' { return GetReportCGSummaryCount(mapObject.get('filter').toString()); }
            when 'ExportCGAllExcel' { return ExportCGAllExcel(mapObject.get('filter').toString()); }
            when 'ExportCGTableExcel' { return ExportCGTableExcel(mapObject.get('filter').toString());}
            when 'GetReportCGTypeRadialChart' { return GetReportCGTypeRadialChart(mapObject.get('filter').toString()); }
            when 'GetReportCGStatusSeriesChart' { return GetReportCGStatusSeriesChart(mapObject.get('filter').toString(), mapObject.get('groupingBy').toString()); }
            when 'GetReportCGInfoList' { return GetReportCGInfoList(mapObject.get('filter').toString(), mapObject.get('sortByParam').toString(),mapObject.get('pageParam').toString()); }
            when 'GetReportCGStatistics' { return GetReportCGStatistics(mapObject.get('filter').toString()); }
            
            when 'GetReportGiftSummaryCount' { return GetReportGiftSummaryCount(mapObject.get('filter').toString()); }
            when 'ExportGiftAllExcel' { return ExportGiftAllExcel(mapObject.get('filter').toString()); }
            when 'ExportGiftTableExcel' { return ExportGiftTableExcel(mapObject.get('filter').toString());}
			when 'GetReportGiftStatusChart' { return GetReportGiftStatusChart(mapObject.get('filter').toString()); }
            when 'GetReportGiftStatusSeriesChart' { return GetReportGiftStatusSeriesChart(mapObject.get('filter').toString(), mapObject.get('groupingBy').toString()); }
            when 'GetReportGiftInfoList' { return GetReportGiftInfoList(mapObject.get('filter').toString(), mapObject.get('sortByParam').toString(),mapObject.get('pageParam').toString()); }
            when 'GetReportGiftStatistics' { return GetReportGiftStatistics(mapObject.get('filter').toString()); }
                      
            when 'GetReportWorkflow' { return GetReportWorkflow(mapObject.get('reportId').toString());}
            when 'CGGlobal_GetCompanies' { return CGGlobal_GetCompanies();}
            when 'CGGlobal_GetFunctions' { return CGGlobal_GetFunctions(mapObject.get('companyId').toString());}
            when 'CGGlobal_GetDepartments' { return CGGlobal_GetDepartments(mapObject.get('function').toString());}
            when 'CGGlobal_GetSections' { return CGGlobal_GetSections(mapObject.get('department').toString());}
            when 'CGGlobal_GetUnits' { return CGGlobal_GetUnits(mapObject.get('section').toString());}
            when 'CGAcknowledgeForm' { return CGAcknowledgeForm(mapObject.get('reportId').toString()); }
            when else {  return null; }
        }
    }
    
    //COI
    public static string GetReportCOISummaryCount(string filter) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        }
        
        CG_DTO.ReportCOISummaryCountDTO results = CG_Report.GetReportCOISummaryCount(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }                                                                        
       
    public static string GetReportCOIAnswerChart(string filter) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        CG_DTO.ReportCOIAnswerChartSeriesDTO results = CG_Report.GetReportCOIAnswerChart(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }                                                                 
                  
    public static string GetReportCOITypeRadialChart(string filter) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        List<CG_DTO.ReportCOITypeRadialChartItemDTO> results = CG_Report.GetReportCOITypeRadialChart(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }  
    
    public static string GetReportCOIStatusSeriesChart(string filter, string groupingBy) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        List<CG_DTO.ReportCOIStatusSeriesDTO> results = CG_Report.GetReportCOIStatusSeriesChart(filterCriteria, groupingBy);
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    public static string GetReportCOIInfoList(string filter, string sortByParam, string pageParam) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
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
            System.debug(pageParam);
            pageParamGlobal = (CG_Global.PageParam)JSON.deserialize(pageParam, CG_Global.PageParam.class);
        }
        
        List<CG_DTO.ReportCOIInfoDTO> results = CG_Report.GetReportCOIInfoList(filterCriteria, sortByParamGlobal, pageParamGlobal);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }                                                     
                  
    public static string GetReportCOIStatistics(string filter) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        CG_DTO.ReportCOIStatisticDTO results = CG_Report.GetReportCOIStatistics(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }  
    
    public static string ExportCOIAllExcel(string filter) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        string results = CG_Report.ExportCOIAllExcel(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }                                                                       
                  
    public static string ExportCOITableExcel(string filter) {
        
        CG_COI_Reporting.ReportCOISearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_COI_Reporting.ReportCOISearchCriteria)JSON.deserialize(filter, CG_COI_Reporting.ReportCOISearchCriteria.class);
        } 
        
        string results = CG_Report.ExportCOITableExcel(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }  
    
    //Manual
    public static string GetReportCGSummaryCount(string filter) {
        
        CG_Manual_Reporting.ReportCGSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Manual_Reporting.ReportCGSearchCriteria)JSON.deserialize(filter, CG_Manual_Reporting.ReportCGSearchCriteria.class);
        } 
        
        CG_DTO.ReportCGSummaryCountDTO results = CG_Report.GetReportCGSummaryCount(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }                                                         
    
    public static string GetReportCGTypeRadialChart(string filter) {
        
        CG_Manual_Reporting.ReportCGSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Manual_Reporting.ReportCGSearchCriteria)JSON.deserialize(filter, CG_Manual_Reporting.ReportCGSearchCriteria.class);
        } 
        
        List<CG_DTO.ReportCGTypeRadialChartItemDTO> results = CG_Report.GetReportCGTypeRadialChart(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }  
    
    public static string GetReportCGStatusSeriesChart(string filter, string groupingBy) {
        
        CG_Manual_Reporting.ReportCGSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Manual_Reporting.ReportCGSearchCriteria)JSON.deserialize(filter, CG_Manual_Reporting.ReportCGSearchCriteria.class);
        } 
        
        List<CG_DTO.ReportCGStatusSeriesDTO> results = CG_Report.GetReportCGStatusSeriesChart(filterCriteria, groupingBy);
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    public static string GetReportCGInfoList(string filter, string sortByParam, string pageParam) {
        
        CG_Manual_Reporting.ReportCGSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Manual_Reporting.ReportCGSearchCriteria)JSON.deserialize(filter, CG_Manual_Reporting.ReportCGSearchCriteria.class);
        } 
        
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
        
        List<CG_DTO.ReportCGInfoDTO> results = CG_Report.GetReportCGInfoList(filterCriteria, sortByParamGlobal, pageParamGlobal);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }                                                     
                  
    public static string GetReportCGStatistics(string filter) {
        
        CG_Manual_Reporting.ReportCGSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Manual_Reporting.ReportCGSearchCriteria)JSON.deserialize(filter, CG_Manual_Reporting.ReportCGSearchCriteria.class);
        } 
        
        CG_DTO.ReportCGStatisticDTO results = CG_Report.GetReportCGStatistics(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }  
    
    public static string ExportCGAllExcel(string filter) {
        
        CG_Manual_Reporting.ReportCGSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Manual_Reporting.ReportCGSearchCriteria)JSON.deserialize(filter, CG_Manual_Reporting.ReportCGSearchCriteria.class);
        } 
        
        string results = CG_Report.ExportCGAllExcel(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }                                                                       
                  
    public static string ExportCGTableExcel(string filter) {
        
        CG_Manual_Reporting.ReportCGSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Manual_Reporting.ReportCGSearchCriteria)JSON.deserialize(filter, CG_Manual_Reporting.ReportCGSearchCriteria.class);
        } 
        
        string results = CG_Report.ExportCGTableExcel(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }  
    
    //Gift Registration
    public static string GetReportGiftSummaryCount(string filter) {
        
        CG_Gift_Reporting.ReportGiftSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Gift_Reporting.ReportGiftSearchCriteria)JSON.deserialize(filter, CG_Gift_Reporting.ReportGiftSearchCriteria.class);
        } 
        
        CG_DTO.ReportGiftSummaryCountDTO results = CG_Report.GetReportGiftSummaryCount(filterCriteria);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    } 
    
    public static string GetReportGiftStatusChart(string filter) {
        
        CG_Gift_Reporting.ReportGiftSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Gift_Reporting.ReportGiftSearchCriteria)JSON.deserialize(filter, CG_Gift_Reporting.ReportGiftSearchCriteria.class);
        } 
        
        CG_DTO.ReportGiftStatusChartSeriesDTO results = CG_Report.GetReportGiftStatusChart(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetReportGiftStatusSeriesChart(string filter, string groupingBy) {
        
        CG_Gift_Reporting.ReportGiftSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Gift_Reporting.ReportGiftSearchCriteria)JSON.deserialize(filter, CG_Gift_Reporting.ReportGiftSearchCriteria.class);
        } 
        
        List<CG_DTO.ReportGiftStatusSeriesDTO> results = CG_Report.GetReportGiftStatusSeriesChart(filterCriteria, groupingBy);
        string actualResult = JSON.serialize(results);
        return actualResult;
    }   
    
    public static string GetReportGiftInfoList(string filter, string sortByParam, string pageParam) {
        
        CG_Gift_Reporting.ReportGiftSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Gift_Reporting.ReportGiftSearchCriteria)JSON.deserialize(filter, CG_Gift_Reporting.ReportGiftSearchCriteria.class);
        } 
        
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
        
        List<CG_DTO.ReportGiftInfoDTO> results = CG_Report.GetReportGiftInfoList(filterCriteria, sortByParamGlobal, pageParamGlobal);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }                                                     
                  
    public static string GetReportGiftStatistics(string filter) {
        
        CG_Gift_Reporting.ReportGiftSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Gift_Reporting.ReportGiftSearchCriteria)JSON.deserialize(filter, CG_Gift_Reporting.ReportGiftSearchCriteria.class);
        } 
        
        CG_DTO.ReportGiftStatisticDTO results = CG_Report.GetReportGiftStatistics(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }  
    
    public static string ExportGiftAllExcel(string filter) {
        
        CG_Gift_Reporting.ReportGiftSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Gift_Reporting.ReportGiftSearchCriteria)JSON.deserialize(filter, CG_Gift_Reporting.ReportGiftSearchCriteria.class);
        } 
        
        string results = CG_Report.ExportGiftAllExcel(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }                                                                       
                  
    public static string ExportGiftTableExcel(string filter) {
        
        CG_Gift_Reporting.ReportGiftSearchCriteria filterCriteria = null;
        
        if(filter != null) {
            filterCriteria = (CG_Gift_Reporting.ReportGiftSearchCriteria)JSON.deserialize(filter, CG_Gift_Reporting.ReportGiftSearchCriteria.class);
        } 
        
        string results = CG_Report.ExportGiftTableExcel(filterCriteria);
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }  
    
    public static string GetReportWorkflow(string reportId) {
        
        CG_DTO.WorkflowHistoryDTO results = CG_Report.GetReportWorkflow(reportId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string CGAcknowledgeForm(string reportId) {
        CG_DTO.CGAcknowledgeFormDTO result = CG_Manual_Reporting.CGAcknowledgeForm(reportId);
        string actualResult = JSON.serialize(result);
        return actualResult;
    }
    
    //Global
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