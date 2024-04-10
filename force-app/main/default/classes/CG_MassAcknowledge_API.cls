@RestResource(urlMapping='/CG_MassAcknowledge_API/*')
global with sharing class CG_MassAcknowledge_API {
    
    @HttpPost global static string doPost(string param) {
        
		Map<string, object> mapObject = (Map<string, object>)JSON.deserializeUntyped(param);  
        
        switch on RestContext.request.requestURI.substringAfterLast('/') {
            //COI
            when 'GetCOIMassAcknowledgeCount' { return String.ValueOf(GetCOIMassAcknowledgeCount(mapObject.get('reportStatus').toString()));}
            when 'GetCOIMassAcknowledgeList' { return GetCOIMassAcknowledgeList(mapObject.get('reportStatus').toString(), mapObject.get('disclosureReportKeys').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString());}
            when 'GetCOIReportWorkflow' { return GetCOIReportWorkflow(mapObject.get('reportId').toString());}
            when 'COIMassApproveReports' { COIMassApproveReports(mapObject.get('reportIds').toString()); return null;}
            //Gift
            when 'GetGiftMassAcknowledgeCount' { return String.ValueOf(GetGiftMassAcknowledgeCount(mapObject.get('reportStatus').toString()));}
            when 'GetGiftMassAcknowledgeList' { return GetGiftMassAcknowledgeList(mapObject.get('reportStatus').toString(), mapObject.get('sortByParam').toString(), mapObject.get('pageParam').toString());}
            when 'GetGiftReportWorkflow' { return GetGiftReportWorkflow(mapObject.get('reportId').toString());}
            when 'GiftMassApproveReports' { GiftMassApproveReports(mapObject.get('reportIds').toString()); return null;}
            
            when else {  return null; }
        }
        
    }
    
    //COI
    public static string GetCOIMassAcknowledgeCount(string reportStatus){
        CG_DTO.COIMassAcknowledgeCountDTO results = CG_MassAcknowledge.GetCOIMassAcknowledgeCount(reportStatus);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    public static string GetCOIMassAcknowledgeList(
    string reportStatus,
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
        
        List<CG_DTO.COIMassAcknowledgeListDTO> results = CG_MassAcknowledge.GetCOIMassAcknowledgeList(reportStatus, disclosureReportKeys, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetCOIReportWorkflow(string reportId) {
        
        CG_DTO.WorkflowHistoryDTO results = CG_MassAcknowledge.GetCOIReportWorkflow(reportId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static void COIMassApproveReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds
    ) {
        
        CG_MassAcknowledge.COIMassApproveReports(reportIds);
        
    }
    
    //Gift
    public static string GetGiftMassAcknowledgeCount(string reportStatus){
        CG_DTO.GiftMassAcknowledgeCountDTO results = CG_MassAcknowledge.GetGiftMassAcknowledgeCount(reportStatus);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
    }
    
    public static string GetGiftMassAcknowledgeList(
    string reportStatus,
    //ownerName, ownerPosition, ownerSection, reportNumber, status, submittedDate
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
        
        List<CG_DTO.GiftMassAcknowledgeListDTO> results = CG_MassAcknowledge.GetGiftMassAcknowledgeList(reportStatus, sortByParamGlobal, pageParamGlobal);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static string GetGiftReportWorkflow(string reportId) {
        
        CG_DTO.WorkflowHistoryDTO results = CG_MassAcknowledge.GetGiftReportWorkflow(reportId);
        
        string actualResult = JSON.serialize(results);
        return actualResult;
        
    }
    
    public static void GiftMassApproveReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds
    ) {
        
        CG_MassAcknowledge.GiftMassApproveReports(reportIds);
        
    }
}