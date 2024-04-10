/* 
 * Author Softever
*/

global with sharing class CG_MassAcknowledge {

    private static List<CG_DTO.COIMassAcknowledgeListDTO> COIMassAcknowledgeList;
    private static CG_DTO.COIMassAcknowledgeCountDTO COIMassAcknowledgeCount;
    private static List<CG_DTO.WorkflowHistoryDTO> mockupCOIWorkflowHistories;
    
    private static List<CG_DTO.GiftMassAcknowledgeListDTO> GiftMassAcknowledgeList;
    private static CG_DTO.GiftMassAcknowledgeCountDTO GiftMassAcknowledgeCount;
    private static List<CG_DTO.WorkflowHistoryDTO> mockupGiftWorkflowHistories;
    
    static {
    }
    
    //COI
    @RemoteAction
    public static CG_DTO.COIMassAcknowledgeCountDTO GetCOIMassAcknowledgeCount(string reportStatus){
        
        string userId = CG_PrivilegeHandler.getUserId();
        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> COIRTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual),
            String.ValueOf(CG_Enum.COIReportType.COIIncident),
            String.ValueOf(CG_Enum.COIReportType.COINewEmployee)};
            
        //string reportStatus = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                        'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                        'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                        'where Status__c =: reportStatus AND Type_Of_Report__c IN: COIRTs';
        
        if(reportStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            query = query + ' AND User__c =: userId';
        }
        
        CGReports = database.query(query);
        
        COIMassAcknowledgeCount = new CG_DTO.COIMassAcknowledgeCountDTO();
        COIMassAcknowledgeCount.totalReport = 0;
        COIMassAcknowledgeCount.answerNo = 0;
        COIMassAcknowledgeCount.answerYes = 0;
        COIMassAcknowledgeCount.answerNotSure = 0;
            
        try {
            
            if(CGReports.size() > 0) {
                COIMassAcknowledgeCount.totalReport = CGReports.size();
                
                for(CG_Reporting__c CGReport : CGReports) {
                    if(CGReport.COI_DisClosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes)) {
                        COIMassAcknowledgeCount.answerYes += 1;
                    }
                    else if(CGReport.COI_DisClosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
                        COIMassAcknowledgeCount.answerNo += 1;
                    }
                    else if(CGReport.COI_DisClosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
                        COIMassAcknowledgeCount.answerNotSure += 1;
                    }
                }
                
            }
            
        }
        catch (Exception e) {
            System.debug('GetCOIMassAcknowledgeCount exception has occured : ' + e.getMessage());
        }
            
        return COIMassAcknowledgeCount;
    }
    
    @RemoteAction
    public static List<CG_DTO.COIMassAcknowledgeListDTO> GetCOIMassAcknowledgeList(
    //reportStatus
    string reportStatus,
    //enum DisclosureReport (comma-seperated)
    string disclosureReportKeys,
    //reportNumber, reportType, disclosureReport, supervisorName, submittedDate, status, ownerName, ownerPosition, ownerSection
    CG_Global.SortByParam sortByParam, 
    CG_Global.PageParam pageParam
    ) {
        
        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
        string userId = CG_PrivilegeHandler.getUserId();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> COITypes = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIIncident),
            										String.ValueOf(CG_Enum.COIReportType.COIAnnual),
            										String.ValueOf(CG_Enum.COIReportType.COINewEmployee)};
            
        //Query CG Report                    
        //string reportStatus = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                        'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                        'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, Owner_Full_Name_EN__c, Owner_Position__c, ' +
                        'Owner_Section__c from CG_Reporting__c where Status__c =: reportStatus AND Type_Of_Report__c IN: COITypes';
            
        if(reportStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            query = query + ' AND User__c =: userId';
        }
        
        CGReports = database.query(query);
                
        //SortByParam
        if(sortByParam.sortBy == 'disclosureReport') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by COI_Disclosure__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by COI_Disclosure__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerName') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Full_Name_EN__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Full_Name_EN__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerPosition') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Position__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Position__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerSection') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Section__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Section__c desc');
            }
        }
        else if(sortByParam.sortBy == 'reportNumber') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Running_No__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Running_No__c desc');
            }
        }
        else if(sortByParam.sortBy == 'reportType') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Type_Of_Report__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Type_Of_Report__c desc');
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
        else if(sortByParam.sortBy == 'submittedDate') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Submitted_Date__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Submitted_Date__c desc');
            }
        }
        
        List<CG_DTO.COIMassAcknowledgeListDTO> queryResults = new List<CG_DTO.COIMassAcknowledgeListDTO>();
        List<CG_DTO.COIMassAcknowledgeListDTO> results = new List<CG_DTO.COIMassAcknowledgeListDTO>();     
        List<CG_DTO.COIMassAcknowledgeListDTO> actualResults = new List<CG_DTO.COIMassAcknowledgeListDTO>();                  
        
        if(CGReports.size() > 0) {
            
            Map<string,User> users = CG_Global.assignAllToUsers();
            
            for(CG_Reporting__c CGReport : CGReports) {
                
                //Query User
                //User currentUser = [select id, name, position__c, section__c from User where Id =: CGReport.OwnerId];
                User currentUser = users.get(CGReport.OwnerId);
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
            results = COIMassAcknowledgeList;
        }
        
        //PageParam
        if(results.size() > 0) {
                                
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
        	integer totalSize = results.size() - startIndex;
            
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
    public static CG_DTO.WorkflowHistoryDTO GetCOIReportWorkflow(string reportId){
        
        try {
            
            CG_DTO.WorkflowHistoryDTO WorkflowHistoryDTO = new CG_DTO.WorkflowHistoryDTO();
            
            CG_Reporting__c CGReporting = [select id, Status_JSON__c from CG_Reporting__c where Id =: reportId];
            
            if(CGReporting != null) {
                WorkflowHistoryDTO = DeserializeWorkflowHistory(CGReporting.Status_JSON__c);
                return WorkflowHistoryDTO;
            }
        }
        catch(Exception e) {
            System.debug('GetReportWorkflow exception has occurred: ' + e.getMessage());
        }
        
        return null;
    }
    
    @RemoteAction
    public static void COIMassApproveReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds
    ){
        
		string userId = CG_PrivilegeHandler.getUserId();
        List<Id> cgReportIds = new List<Id>();
        cgReportIds = reportIds.split(',');
        
        List<CG_Reporting__c> CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                              End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                              Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c
                                              where id IN: cgReportIds];
        
        if(CGReportings.size() > 0) {
            for(CG_Reporting__c CGReport : CGReportings) {
                
                //When Supervisor mass acknowledge
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                    
                    //Supervisor
                    CGReport.Supervisor_Approver_Status__c = String.ValueOf(CG_Enum.ApproverStatus.Acknowledged);
                    
                    PISUsers__c Approver = assignToPISUser(userId);
                    
                    //CGReport.Supervisor_Comment__c = report.supervisorComment;
                    CGReport.Supervisor_Action_By_TH__c = Approver.THTITLE__c + ' ' + Approver.THFIRSTNAME__c + ' ' + Approver.THLASTNAME__c;
                    CGReport.Supervisor_Action_By_EN__c = Approver.EN_Fullname__c;
                    CGReport.Supervisor_Action_By_Position_TH__c = Approver.OBJTHFULLNAME__c;
                    CGReport.Supervisor_Action_By_Position_EN__c = Approver.OBJENFULLNAME__c;
                    CGReport.Supervisor_Action_By_Company_TH__c = Approver.COMPANYNAME__c;
                    CGReport.Supervisor_Action_By_Company_EN__c = Approver.COMPANYNAME__c;
                    CGReport.Supervisor_Action_Date__c = date.today();
                    
                    //If Supervisor Acknowledged
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
                    CGReport.Status_JSON__c = assignGLVPWhenSupervisorSubmit('Acknowledged', '', CGReport.OwnerId, CGReport.Status_JSON__c);
                              
                    if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee) || 
                  		CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                        //Send email to GLVP when Supervisor Acknowledged
                        List<PISUsers__c> GLVPPISUsers = assignToGLVPPISUser();
                        if(GLVPPISUsers.size() > 0) {
                            for(PISUsers__c GLVP : GLVPPISUsers) {
                                
                                CG_ReportingHandler.COIGLVPEmail(GLVP.User__c, CGReport);
                                
                            }
                        }
                    }
                }
                //When GLVP mass acknowledge
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                    
                    //GLVP
                    CGReport.GLVP_Approver_Status__c = String.ValueOf(CG_Enum.ApproverStatus.Acknowledged);
                    
                    PISUsers__c Approver = assignToPISUser(userId);
                    
                    CGReport.GLVP_Action_By_TH__c = Approver.THTITLE__c + ' ' + Approver.THFIRSTNAME__c + ' ' + Approver.THLASTNAME__c;
                    CGReport.GLVP_Action_By_EN__c = Approver.EN_Fullname__c;
                    CGReport.GLVP_Action_By_Position_TH__c = Approver.OBJTHFULLNAME__c;
                    CGReport.GLVP_Action_By_Position_EN__c = Approver.OBJENFULLNAME__c;
                    CGReport.GLVP_Action_By_Company_TH__c = Approver.COMPANYNAME__c;
                    CGReport.GLVP_Action_By_Company_EN__c = Approver.COMPANYNAME__c;
                    CGReport.GLVP_Action_Date__c = date.today();
                    
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
                    CGReport.Status_JSON__c = assignSuccessWhenGLVPSubmit('Acknowledged', userId, CGReport.Status_JSON__c);
                	CGReport.GLVP_Id__c = userId;
                    
                }
                
                
            }
            
            update(CGReportings);
        }
        
    }
    
    //Gift
    @RemoteAction
    public static CG_DTO.GiftMassAcknowledgeCountDTO GetGiftMassAcknowledgeCount(string reportStatus){
        
        string userProfile = CG_PrivilegeHandler.getUserProfile();
        string userId = CG_PrivilegeHandler.getUserId();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> GiftRTs = new List<string> { 'GiftRegistration' };
            
        //string reportStatus = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                        'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                        'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                        'where Status__c =: reportStatus AND Type_Of_Report__c IN: GiftRTs';
            
        if(reportStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            query = query + ' AND User__c =: userId';
        }
        
        CGReports = database.query(query);
        
        GiftMassAcknowledgeCount = new CG_DTO.GiftMassAcknowledgeCountDTO();
        GiftMassAcknowledgeCount.totalReport = 0;
        GiftMassAcknowledgeCount.isShowAcknowledgeButton = false;
        
        if(userProfile == 'GLVP' || userProfile == 'SuperAdmin') {
        	GiftMassAcknowledgeCount.isShowAcknowledgeButton = true;
        }
        
        try {
            
            if(CGReports.size() > 0) {
                GiftMassAcknowledgeCount.totalReport = CGReports.size();
                
                
            }
            
        }
        catch (Exception e) {
            System.debug('GetCGMassAcknowledgeCount exception has occured : ' + e.getMessage());
        }
            
        return GiftMassAcknowledgeCount;
    }
    
    @RemoteAction
    public static List<CG_DTO.GiftMassAcknowledgeListDTO> GetGiftMassAcknowledgeList(
    //reportStatus
    string reportStatus,
    //ownerName, ownerPosition, ownerSection, reportNumber, status, submittedDate
    CG_Global.SortByParam sortByParam, 
    CG_Global.PageParam pageParam
    ) {
        
        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
        string userId = CG_PrivilegeHandler.getUserId();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        List<string> GiftTypes = new List<string> { 'GiftRegistration' };
            
        //Query CG Report                    
        //string reportStatus = String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor);
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, Owner_Position__c, ' +
                        'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, Owner_Section__c, ' +
                        'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, Owner_Full_Name_EN__c ' +
                        'from CG_Reporting__c where Status__c =: reportStatus AND Type_Of_Report__c IN: GiftTypes';
            
        if(reportStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            query = query + ' AND User__c =: userId';
        }
        
        CGReports = database.query(query);
                
        //SortByParam
        if(sortByParam.sortBy == 'ownerName') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Full_Name_EN__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Full_Name_EN__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerPosition') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Position__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Position__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerSection') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Section__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Owner_Section__c desc');
            }
        }
        else if(sortByParam.sortBy == 'reportNumber') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Running_No__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Running_No__c desc');
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
        else if(sortByParam.sortBy == 'submittedDate') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by Submitted_Date__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by Submitted_Date__c desc');
            }
        }
        
        List<CG_DTO.GiftMassAcknowledgeListDTO> queryResults = new List<CG_DTO.GiftMassAcknowledgeListDTO>();
        List<CG_DTO.GiftMassAcknowledgeListDTO> results = new List<CG_DTO.GiftMassAcknowledgeListDTO>();     
        List<CG_DTO.GiftMassAcknowledgeListDTO> actualResults = new List<CG_DTO.GiftMassAcknowledgeListDTO>();                  
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                
                //Query User
                User currentUser = [select id, name, position__c, section__c from User where Id =: CGReport.OwnerId];
                
                queryResults.add(assignToGiftMassAcknowledgeListDTO(CGReport, currentUser));
            }                       
        }
                    
        results = queryResults;
        
        //PageParam
        if(results.size() > 0) {
                                
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
        	integer totalSize = results.size() - startIndex;
            
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
    public static CG_DTO.WorkflowHistoryDTO GetGiftReportWorkflow(string reportId){
        for (CG_DTO.WorkflowHistoryDTO workflow : mockupGiftWorkflowHistories) {
            if(workflow.reportId == reportId){
                return workflow;
            }
        }
        return null;
    }
    
    @RemoteAction
    public static void GiftMassApproveReports(
        //comma-seperated report ids eg. 'id1,id2,id3'
        string reportIds
    ){
		string userId = CG_PrivilegeHandler.getUserId();
        List<Id> cgReportIds = new List<Id>();
        cgReportIds = reportIds.split(',');
        
        List<CG_Reporting__c> CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                              End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                              Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, Gift_Item__c from CG_Reporting__c
                                              where id IN: cgReportIds];
        
        if(CGReportings.size() > 0) {
            for(CG_Reporting__c CGReport : CGReportings) {
                //When GLGC Mass acknowledge
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                    
                    List<CG_DTO.GiftItemDTO> giftItems = DeserializeGiftItems(CGReport.Gift_Item__c);
                    
                	CGReport.Gift_Item__c = SerializeGiftItems(giftItems, CGReport.Status__c);
                    
                    List<CG_DTO.GiftItemDTO> acknowledgeGiftItems = DeserializeGiftItems(CGReport.Gift_Item__c);
                    
                    CGReport.Gift_Status__c = GetGiftStatus(acknowledgeGiftItems);
                    
                    CGReport.Status_JSON__c = assignGLVPWhenGLGCSubmit('Acknowledged', '', userId, CGReport.Status_JSON__c);
                
                    //GLGC
                    CGReport.GLGC_Approver_Status__c = String.ValueOf(CG_Enum.ApproverStatus.Acknowledged);
                    
                    PISUsers__c Approver = assignToPISUser(userId);
                    
                    CGReport.GLGC_Action_By_TH__c = Approver.THTITLE__c + ' ' + Approver.THFIRSTNAME__c + ' ' + Approver.THLASTNAME__c;
                    CGReport.GLGC_Action_By_EN__c = Approver.EN_Fullname__c;
                    CGReport.GLGC_Action_By_Position_TH__c = Approver.OBJTHFULLNAME__c;
                    CGReport.GLGC_Action_By_Position_EN__c = Approver.OBJENFULLNAME__c;
                    CGReport.GLGC_Action_By_Company_TH__c = Approver.COMPANYNAME__c;
                    CGReport.GLGC_Action_By_Company_EN__c = Approver.COMPANYNAME__c;
                    CGReport.GLGC_Action_Date__c = date.today();
                    CGReport.GLGC_Id__c = userId;
                    
                    //If GLGC Acknowledged
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
                    
                    //Send email to GLVP when GLGC Acknowledge
                	List<PISUsers__c> GLVPPISUsers = assignToGLVPPISUser();
                    if(GLVPPISUsers.size() > 0) {
                        for(PISUsers__c GLVP : GLVPPISUsers) {
                            CG_ReportingHandler.GiftRegistrationGLVPEmail(GLVP.User__c, CGReport);
                        }
                    }
                }
                //When GLVP Mass acknowledge
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                
                    CGReport.Status_JSON__c = assignSuccessWhenGLVPSubmit('Acknowledged', userId, CGReport.Status_JSON__c);
                
                    //If GLVP Acknowledged
                    CGReport.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
                    
                    //GLVP
                    CGReport.GLVP_Approver_Status__c = String.ValueOf(CG_Enum.ApproverStatus.Acknowledged);
                    
                    PISUsers__c Approver = assignToPISUser(userId);
                    
                    CGReport.GLVP_Action_By_TH__c = Approver.THTITLE__c + ' ' + Approver.THFIRSTNAME__c + ' ' + Approver.THLASTNAME__c;
                    CGReport.GLVP_Action_By_EN__c = Approver.EN_Fullname__c;
                    CGReport.GLVP_Action_By_Position_TH__c = Approver.OBJTHFULLNAME__c;
                    CGReport.GLVP_Action_By_Position_EN__c = Approver.OBJENFULLNAME__c;
                    CGReport.GLVP_Action_By_Company_TH__c = Approver.COMPANYNAME__c;
                    CGReport.GLVP_Action_By_Company_EN__c = Approver.COMPANYNAME__c;
                    CGReport.GLVP_Action_Date__c = date.today();
                    
                    //Send email to Owner when GLVP Acknowledged
                    CG_ReportingHandler.GiftRegistrationUserEmailGLVPAcknowledged(CGReport.OwnerId, CGReport);
                }
                
            }
            
            update(CGReportings);
        }
    }
    
    @TestVisible
    private static PISUsers__c assignToPISUser(string userId) {
        
        PISUsers__c PISUser = [select id, User__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c from PISUsers__c where User__c =: userId AND Active__c = true AND Mainposition__c = true];
        
        return PISUser;
        
    }
    
    @TestVisible
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
        
        string ownerPosition = '';
        string ownerSection = '';
        
        if(currentUser.Position__c != null) {
            ownerPosition = currentUser.Position__c;
        }
        if(currentUser.Section__c != null) {
            ownerSection = currentUser.Section__c;
        }
        
        COIMass.ownerPosition = ownerPosition;
        COIMass.ownerSection = ownerSection;
        
        return COIMass;
        
    }

    @TestVisible
    private static CG_DTO.GiftMassAcknowledgeListDTO assignToGiftMassAcknowledgeListDTO(CG_Reporting__c CGReporting, User currentUser) {
        
        CG_DTO.GiftMassAcknowledgeListDTO GiftMass = new CG_DTO.GiftMassAcknowledgeListDTO();
        GiftMass.id = CGReporting.Id;
        GiftMass.reportNumber = CGReporting.Running_No__c;
        GiftMass.reportType = new CG_Global.EnumValue('GiftRegistration');
        GiftMass.reportType.key = 'GiftRegistration';
        GiftMass.reportType.value = 'Gift Registration';
        
        GiftMass.supervisorName = CGReporting.Supervisor_Name__c;
        GiftMass.submittedDate = CGReporting.Submitted_Date__c;
        
        GiftMass.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            GiftMass.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            GiftMass.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            GiftMass.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            GiftMass.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            GiftMass.status.key = CG_Enum.ReportStatus.WaitingGLGC.name();
            GiftMass.status.value = 'Waiting GLGC';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            GiftMass.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            GiftMass.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            GiftMass.status.key = CG_Enum.ReportStatus.Rejected.name();
            GiftMass.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            GiftMass.status.key = CG_Enum.ReportStatus.Success.name();
            GiftMass.status.value = 'Success';            
        }
        
        GiftMass.ownerName = currentUser.Name;
        
        string ownerPosition = '';
        string ownerSection = '';
        
        if(currentUser.Position__c != null) {
            ownerPosition = currentUser.Position__c;
        }
        if(currentUser.Section__c != null) {
            ownerSection = currentUser.Section__c;
        }
        
        GiftMass.ownerPosition = ownerPosition;
        GiftMass.ownerSection = ownerSection;
        
        return GiftMass;
        
    }

    @TestVisible
    private static List<PISUsers__c> assignToGLVPPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group GLVP
        Group GLVPGroup = [select id, developername from Group where developername =: 'CG_GLVP'];
        List<GroupMember> GLVPUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GLVPGroup.Id];
        
        if(!Test.isRunningTest()) {
            if(GLVPUsers.size() > 0) {
                for(GroupMember GLVPUser : GLVPUsers) {
                    Id GLVPUserId = GLVPUser.userorgroupid;
                    PISUsers__c PISUser = [select id, User__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                       		OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c from PISUsers__c 
                                       		where User__c =: GLVPUserId AND Active__c = true AND Mainposition__c = true];
                
                    PISUsers.add(PISUser);
                }
                
                return PISUsers;
            }
        }
        
        return PISUsers;
        
    }
    
    @TestVisible
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
                    //approver.approver = assignToUserDTO(glvpId);
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
            
            PISUsers__c PISUser = assignToPISUser(ownerId);
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
    
    @TestVisible
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
                    approver.approver = assignToUserDTO(glvpId);
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
    
    //Gift
    @TestVisible
    private static string assignGLVPWhenGLGCSubmit(string submitAs, string comment, string glgcId, string statusJSON) {
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(statusJSON, CG_DTO.WorkflowHistoryDTO.class);
        
        CG_DTO.WorkflowDTO currentWorkflow = workflowHistoryDTO.currentWorkflow;
        
        if(submitAs == 'Acknowledged') {
            
            workflowHistoryDTO.status = new CG_Global.EnumValue('ReportStatus');
            workflowHistoryDTO.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            workflowHistoryDTO.status.value = 'Waiting GLVP';
            
            for(CG_DTO.WorkflowApproverDTO approver : currentWorkflow.approvers) {
                if(approver.status.key == CG_Enum.ApproverStatus.WaitingGLGC.name() &&
                  	approver.role.key == CG_Enum.ApproverRole.GLGC.name()) {
                    approver.isCurrent = false;
                    approver.actionDate = system.Datetime.now();
                    approver.comment = comment;
                    approver.approver = new CG_DTO.UserDTO();
                    approver.approver = assignToUserDTO(glgcId);
                    
                    approver.status = new CG_Global.EnumValue('ApproverStatus');
                    approver.status.key = CG_Enum.ApproverStatus.Acknowledged.name();
                    approver.status.value = 'Acknowledged';
                    
                }
                else if(approver.status.key == CG_Enum.ApproverStatus.WaitingGLVP.name()) {
                    approver.isCurrent = true;
                    
                    CG_Global.EnumValue status = new CG_Global.EnumValue('WaitingGLVP');
                    status.enumName = 'WaitingGLVP';
                    status.key = 'WaitingGLVP';
                    status.value = 'Waiting GLVP';
                    
                    workflowHistoryDTO.status = status;
                }
                
            }
            
        }
        
        string result = JSON.serialize(workflowHistoryDTO);
        return result;
        
    }
    
    @TestVisible
    private static CG_DTO.UserDTO assignToUserDTO(string userId) {
        
        PISUsers__c PISUser = [select id, User__c, EN_Fullname__c, Email__c from PISUsers__c where User__c =: userId AND Mainposition__c = true];
        CG_DTO.UserDTO UserDTO = new CG_DTO.UserDTO();
        UserDTO.id = PISUser.User__c;
        UserDTO.fullName = PISUser.EN_Fullname__c ;
        UserDTO.email = PISUser.Email__c;
        return UserDTO;
    }

    @TestVisible    
    private static List<CG_DTO.GiftItemDTO> DeserializeGiftItems(string giftItems) {
        
        List<CG_DTO.GiftItemDTO> giftItemsDTO = (List<CG_DTO.GiftItemDTO>)JSON.deserialize(giftItems, List<CG_DTO.GiftItemDTO>.class);
        
        return giftItemsDTO;
        
    }
    
    @TestVisible
    private static string SerializeGiftItems(List<CG_DTO.GiftItemDTO> giftItems, string status) {
        
        if(giftItems.size() > 0) {
            for(CG_DTO.GiftItemDTO giftItem : giftItems) {
                
                if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                    giftItem.giftStatus = new CG_Global.EnumValue('GiftStatus');
                    giftItem.giftStatus.key = CG_Enum.GiftStatus.InStock.name();
                    giftItem.giftStatus.value = 'In Stock';
                }
                
            }
        }
        
        string giftItemJson = JSON.serialize(giftItems);
        
        return giftItemJson;
        
    }
    
    @TestVisible
    private static string GetGiftStatus(List<CG_DTO.GiftItemDTO> giftItems) {

        integer InStockCount = 0;
        integer DonatedCount = 0;
        string giftStatus = '';
        
        if(giftItems.size() > 0) {
            for(CG_DTO.GiftItemDTO giftItem : giftItems) {
                if(giftItem.giftStatus.key == String.ValueOf(CG_Enum.GiftStatus.InStock)) {
                    InStockCount++;
                }
                else if(giftItem.giftStatus.key == String.ValueOf(CG_Enum.GiftStatus.Donated)) {
                    DonatedCount++;
                }
            }
        }
        
        if(InStockCount >= DonatedCount) {
            giftStatus = String.ValueOf(CG_Enum.GiftStatus.InStock);
        }
        else {
            giftStatus = String.ValueOf(CG_Enum.GiftStatus.Donated);
        }
        
        return giftStatus;
        
    }
    
    @TestVisible
    private static CG_DTO.WorkflowHistoryDTO DeserializeWorkflowHistory(string workflowStatusJson) {
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(workflowStatusJson, CG_DTO.WorkflowHistoryDTO.class);
		return workflowHistoryDTO;
    }
}