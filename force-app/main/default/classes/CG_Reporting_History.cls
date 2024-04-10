global with sharing class CG_Reporting_History {
    
    private static List<CG_DTO.COIReportListDTO> COIListDTOs;
    private static List<CG_DTO.COIReportHistoryListDTO> COIReportHistoryList;
    private static CG_DTO.COIReportHistoryCountDTO COIReportHistoryCount;
    
    private static List<CG_DTO.CGManualReportListDTO> CGListDTOs;
    private static List<CG_DTO.CGReportHistoryListDTO> CGReportHistoryList;
    private static CG_DTO.CGReportHistoryCountDTO CGReportHistoryCount;
    private static List<CG_DTO.WorkflowHistoryDTO> CGWorkflowHistories;
    
    private static List<CG_DTO.GiftReportListDTO> GiftListDTOs;
    private static List<CG_DTO.GiftReportHistoryListDTO> GiftReportHistoryList;
    private static CG_DTO.GiftReportHistoryCountDTO GiftReportHistoryCount;
    private static List<CG_DTO.WorkflowHistoryDTO> GiftWorkflowHistories;
    
    static {
        //CG_Reporting_History.InitializeListData();
        //CG_Reporting_History.InitializeCOIReportHistoryList();
        //CG_Reporting_History.InitializeCOIReportHistoryCount();
        //CG_Reporting_History.InitializeCGReportHistoryList();
        //CG_Reporting_History.InitializeCGReportHistoryCount();
        //CG_Reporting_History.InitializeCGWorkflowHistory();
        //CG_Reporting_History.InitializeGiftReportHistoryList();
        //CG_Reporting_History.InitializeGiftReportHistoryCount();
        //CG_Reporting_History.InitializeGiftWorkflowHistory();
    }
    
    //COI RemoteAction
    @RemoteAction
    public static CG_DTO.COIReportHistoryCountDTO GetCOIHistoryCount(datetime startDate, datetime endDate){
        
        try {
            
            COIReportHistoryCount = new CG_DTO.COIReportHistoryCountDTO();
            COIReportHistoryCount.totalReport = 0;
            COIReportHistoryCount.annual = 0;
            COIReportHistoryCount.incident = 0;
            COIReportHistoryCount.newEmployee = 0;
            
            COIListDTOs = new List<CG_DTO.COIReportListDTO>();
            List<string> COIRTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual),
                                                    String.ValueOf(CG_Enum.COIReportType.COIIncident),
                                                    String.ValueOf(CG_Enum.COIReportType.COINewEmployee)};
            
            string userProfile = CG_PrivilegeHandler.getUserProfile();
            string userId = CG_PrivilegeHandler.getUserId();
            
            List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();
            
            CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                                  End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                                  Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, COI_Action__c,
                                                  COI_Detail__c from CG_Reporting__c where OwnerId =: userId AND Submitted_Date__c != null AND 
                            					  Submitted_Date__c >=: Date.ValueOf(startDate) AND Submitted_Date__c <=: Date.ValueOf(endDate)
                                                  order by Createddate asc];
            
            if(CGReportings.size() > 0) {
                for(CG_Reporting__c CGReporting : CGReportings) {
                    
                    for(string COIRT : COIRTs) {
                        if(COIRT == CGReporting.Type_of_Report__c) {
                            CG_DTO.COIReportListDTO COIReportDTO = new CG_DTO.COIReportListDTO();
                            COIReportDTO = assignToCOIReportListDTO(CGReporting);
                            COIListDTOs.add(COIReportDTO);
                        }
                    }
                }
                
            }

            List<CG_DTO.COIReportListDTO> COIReports = new List<CG_DTO.COIReportListDTO>();
            if(COIListDTOs.size() > 0) {
                for(CG_DTO.COIReportListDTO COIReport : COIListDTOs) {
                    if(COIReport.submittedDate >= startDate && COIReport.submittedDate <= endDate) {
                        COIReports.add(COIReport);
                    }
                }
                
                if(COIReports.size() > 0) {
                    COIReportHistoryCount.totalReport = COIReports.size();
                
                    for(CG_DTO.COIReportListDTO incident : COIReports) {
                        if(String.ValueOf(incident.reportType.key) == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                            COIReportHistoryCount.annual += 1;
                        }
                        else if(String.ValueOf(incident.reportType.key) == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                            COIReportHistoryCount.incident += 1;
                        }
                        else if(String.ValueOf(incident.reportType.key) == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                            COIReportHistoryCount.newEmployee += 1;
                        }
                    }
                }
                
            }
            
        }
        catch(Exception e) {
            System.debug('GetCOIHistoryCount exception has occured : ' + e.getMessage());
        }
        
        return COIReportHistoryCount;
    }
    
    @RemoteAction
    public static List<CG_DTO.COIReportHistoryListDTO> GetCOIHistoryList(datetime startDate, datetime endDate,
                        //reportNumber, reportType, disclosureReport, supervisorName, submittedDate, status
                        CG_Global.SortByParam sortByParam, 
                        CG_Global.PageParam pageParam) {
        
        try {
            
            if(pageParam == null) {
                pageParam = new CG_Global.PageParam();
                pageParam.pageNo = 1;
                pageParam.pageSize = 1;
            }
            
            string userId = CG_PrivilegeHandler.getUserId();
            
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            List<string> Statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) };
            List<string> COIRTs = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual),
                                                    String.ValueOf(CG_Enum.COIReportType.COIIncident),
                                                    String.ValueOf(CG_Enum.COIReportType.COINewEmployee)};
            
            Date SD = Date.ValueOf(startDate);
            Date ED = Date.ValueOf(endDate);
            
            string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                            'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                            'where OwnerId =: userId AND Type_Of_Report__c IN: COIRTs AND Status__c NOT IN: Statuses AND Submitted_Date__c != null AND Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED';
            
            if(sortByParam.sortBy == 'reportNumber') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c desc');
                }
            }
            else if(sortByParam.sortBy == 'reportType') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by type_of_report__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by type_of_report__c desc');
                }
            }
            else if(sortByParam.sortBy == 'disclosureReport') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by COI_Disclosure__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by COI_Disclosure__c desc');
                }
            }
            else if(sortByParam.sortBy == 'supervisorName') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Supervisor_Name__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Supervisor_Name__c desc');
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
            else if(sortByParam.sortBy == 'status') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c desc');
                }
            }
            else {
                CGReports = database.query(query + ' order by Running_No__c desc');
            }
            
            COIReportHistoryList = new List<CG_DTO.COIReportHistoryListDTO>();
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            
            for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                if (i < CGReports.size()) {
                    COIReportHistoryList.add(assignToCOIReportHistoryListDTO(CGReports[startIndex + i]));
                }else{
                    break;
                }
            }
            
            return COIReportHistoryList;
            
        }
        catch (Exception e) {
            System.debug('GetCOIHistoryList exception has occured : ' + e.getMessage());
        }
        
        return COIReportHistoryList;
    }
    
    //Manual RemoteAction
    @RemoteAction
    public static CG_DTO.CGReportHistoryCountDTO GetCGHistoryCount(datetime startDate, datetime endDate){
        
        try {
            
        	CGReportHistoryCount = new CG_DTO.CGReportHistoryCountDTO();
            CGReportHistoryCount.totalReport = 0;
            CGReportHistoryCount.annual = 0;
            CGReportHistoryCount.manual = 0;
            CGReportHistoryCount.newEmployee = 0;
            
            CGListDTOs = new List<CG_DTO.CGManualReportListDTO>();
            List<string> CGRTs = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual),
                                                    String.ValueOf(CG_Enum.CGReportType.CGManual),
                                                    String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)};
            
            string userProfile = CG_PrivilegeHandler.getUserProfile();
            string userId = CG_PrivilegeHandler.getUserId();
            
            List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();
            
            CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                                  End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                                  Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, COI_Action__c,
                                                  COI_Detail__c from CG_Reporting__c where OwnerId =: userId AND Submitted_Date__c != null AND Submitted_Date__c >=: Date.ValueOf(startDate)
                            					  AND Submitted_Date__c <=: Date.ValueOf(endDate)
                                                  order by Createddate asc];
            
            if(CGReportings.size() > 0) {
                
                for(CG_Reporting__c CGReporting : CGReportings) {
                    
                    for(string CGRT : CGRTs) {
                        if(CGRT == CGReporting.Type_of_Report__c) {
                            CG_DTO.CGManualReportListDTO CGReportDTO = new CG_DTO.CGManualReportListDTO();
                            CGReportDTO = assignToCGManualReportListDTO(CGReporting);
                            CGListDTOs.add(CGReportDTO);
                        }
                    }
                }
                
            }

            List<CG_DTO.CGManualReportListDTO> CGReports = new List<CG_DTO.CGManualReportListDTO>();
            if(CGListDTOs.size() > 0) {
                for(CG_DTO.CGManualReportListDTO CGReport : CGListDTOs) {
                    if(CGReport.submittedDate >= startDate && CGReport.submittedDate <= endDate) {
                        CGReports.add(CGReport);
                    }
                }
                
                if(CGReports.size() > 0) {
                    CGReportHistoryCount.totalReport = CGReports.size();
                
                    for(CG_DTO.CGManualReportListDTO incident : CGReports) {
                        if(String.ValueOf(incident.reportType.key) == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
                            CGReportHistoryCount.annual += 1;
                        }
                        else if(String.ValueOf(incident.reportType.key) == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
                            CGReportHistoryCount.manual += 1;
                        }
                        else if(String.ValueOf(incident.reportType.key) == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
                            CGReportHistoryCount.newEmployee += 1;
                        }
                    }
                }
                
            }
            
        }
        catch(Exception e) {
            System.debug('GetCGHistoryCount exception has occured : ' + e.getMessage());
        }
        
        return CGReportHistoryCount;
   }

    @RemoteAction
    public static List<CG_DTO.CGReportHistoryListDTO> GetCGHistoryList(datetime startDate, datetime endDate,
    //reportNumber, reportType, submittedDate, status
    CG_Global.SortByParam sortByParam, 
    CG_Global.PageParam pageParam
    ){
        
        try {
            
            if(pageParam == null) {
                pageParam = new CG_Global.PageParam();
                pageParam.pageNo = 1;
                pageParam.pageSize = 1;
            }
            
            string userId = CG_PrivilegeHandler.getUserId();
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            List<string> Statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) };
            List<string> CGRTs = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual),
                                                    String.ValueOf(CG_Enum.CGReportType.CGManual),
                                                    String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)};
            
            Date SD = Date.ValueOf(startDate);
            Date ED = Date.ValueOf(endDate);
            
            string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                            'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                            'where OwnerId =: userId AND Type_Of_Report__c IN: CGRTs AND Status__c NOT IN: Statuses AND Submitted_Date__c != null AND ' +
                			'Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED';
            
            if(sortByParam.sortBy == 'reportNumber') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c desc');
                }
            }
            else if(sortByParam.sortBy == 'reportType') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by type_of_report__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by type_of_report__c desc');
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
            else if(sortByParam.sortBy == 'status') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c desc');
                }
            }
            else {
                CGReports = database.query(query + ' order by Running_No__c desc');
            }
            
            CGReportHistoryList = new List<CG_DTO.CGReportHistoryListDTO>();
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            System.debug(CGReports.size());
            for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                if (i < CGReports.size()) {
                    CGReportHistoryList.add(assignToCGReportHistoryListDTO(CGReports[startIndex + i]));
                }else{
                    break;
                }
            }
            
            return CGReportHistoryList;
            
        }
        catch (Exception e) {
            System.debug('GetCGHistoryList exception has occured : ' + e.getMessage());
        }
        
        return CGReportHistoryList;
    }
    
    @RemoteAction
    public static CG_DTO.WorkflowHistoryDTO GetCGReportWorkflow(string reportId) {
        
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
    
    //GiftRegistration RemoteAction
    @RemoteAction
    public static CG_DTO.GiftReportHistoryCountDTO GetGiftHistoryCount(datetime startDate, datetime endDate){
        
        try {
            
        	GiftReportHistoryCount = new CG_DTO.GiftReportHistoryCountDTO();
            GiftReportHistoryCount.totalReport = 0;
            
            GiftListDTOs = new List<CG_DTO.GiftReportListDTO>();
            List<string> GiftRTs = new List<string> { 'GiftRegistration' };
            
            string userProfile = CG_PrivilegeHandler.getUserProfile();
            string userId = CG_PrivilegeHandler.getUserId();
            
            List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();
            
            CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, LastModifiedDate, 
                                                  End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                                  Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, COI_Action__c,
                                                  COI_Detail__c from CG_Reporting__c where OwnerId =: userId AND Submitted_Date__c != null AND Submitted_Date__c >=: Date.ValueOf(startDate)
                            					  AND Submitted_Date__c <=: Date.ValueOf(endDate) order by Createddate asc];
            
            if(CGReportings.size() > 0) {
                
                for(CG_Reporting__c CGReporting : CGReportings) {
                    
                    for(string GiftRT : GiftRTs) {
                        if(GiftRT == CGReporting.Type_of_Report__c) {
                            CG_DTO.GiftReportListDTO GiftReportDTO = new CG_DTO.GiftReportListDTO();
                            GiftReportDTO = assignToGiftReportListDTO(CGReporting);
                            GiftListDTOs.add(GiftReportDTO);
                        }
                    }
                }
                
            }

            List<CG_DTO.GiftReportListDTO> CGReports = new List<CG_DTO.GiftReportListDTO>();
            if(GiftListDTOs.size() > 0) {
                
                //GiftReportHistoryCount.totalReport = GiftListDTOs.size();
                System.debug(GiftListDTOs.size());
                for(CG_DTO.GiftReportListDTO CGReport : GiftListDTOs) {
                    if(CGReport.submittedDate >= startDate && CGReport.submittedDate <= endDate) { 
                        CGReports.add(CGReport);
                    }
                }
                
                if(CGReports.size() > 0) {
                    GiftReportHistoryCount.totalReport = CGReports.size();
                }
                
            }
            
        }
        catch(Exception e) {
            System.debug('GetGiftHistoryCount exception has occured : ' + e.getMessage());
        }
        
        return GiftReportHistoryCount;
    }

    @RemoteAction
    public static List<CG_DTO.GiftReportHistoryListDTO> GetGiftHistoryList(datetime startDate, datetime endDate,
    //reportNumber, supervisorName, submittedDate, status
    CG_Global.SortByParam sortByParam, 
    CG_Global.PageParam pageParam
    ){
        
        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
        try {
            
            if(pageParam == null) {
                pageParam = new CG_Global.PageParam();
                pageParam.pageNo = 1;
                pageParam.pageSize = 1;
            }
            
            string userId = CG_PrivilegeHandler.getUserId();
            List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            List<string> Statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) };
            List<string> GiftRTs = new List<string> { 'GiftRegistration' };
            
            Date SD = Date.ValueOf(startDate);
            Date ED = Date.ValueOf(endDate);
            
            string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                            'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                            'where OwnerId =: userId AND Type_Of_Report__c IN: GiftRTs AND Status__c NOT IN: Statuses AND Submitted_Date__c != null AND Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED';
            
            if(sortByParam.sortBy == 'reportNumber') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by running_no__c desc');
                }
            }
            else if(sortByParam.sortBy == 'supervisorName') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Supervisor_Name__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Supervisor_Name__c desc');
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
            else if(sortByParam.sortBy == 'status') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c desc');
                }
            }
            else {
                CGReports = database.query(query + ' order by Running_No__c desc');
            }
            
            GiftReportHistoryList = new List<CG_DTO.GiftReportHistoryListDTO>();
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            
            for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                if (i < CGReports.size()) {
                    GiftReportHistoryList.add(assignToGiftReportHistoryListDTO(CGReports[startIndex + i]));
                }else{
                    break;
                }
            }
            
            return GiftReportHistoryList;
            
        }
        catch (Exception e) {
            System.debug('GetGiftHistoryList exception has occured : ' + e.getMessage());
        }
        
        return GiftReportHistoryList;
    }
    
    @RemoteAction
    public static CG_DTO.WorkflowHistoryDTO GetGiftReportWorkflow(string reportId) {
        
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
        
        /* for (CG_DTO.WorkflowHistoryDTO workflow : GiftWorkflowHistories) {
            if(workflow.reportId == reportId){
                return workflow;
            }
        }
        return null; */
        
        /* try {
            
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
        
        return null; */
    }
    
    @TestVisible
    private static CG_DTO.COIReportListDTO assignToCOIReportListDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.COIReportListDTO COIReport = new CG_DTO.COIReportListDTO();
        COIReport.id = CGReporting.Id;
        
        COIReport.reportType = new CG_Global.EnumValue('COIReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
            COIReport.reportType.key = CG_Enum.COIReportType.COIAnnual.name();
            COIReport.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
            COIReport.reportType.key = CG_Enum.COIReportType.COIIncident.name();
            COIReport.reportType.value = 'Incident';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            COIReport.reportType.key = CG_Enum.COIReportType.COINewEmployee.name();
            COIReport.reportType.value = 'New Employee';
        }
        
        COIReport.reportNumber = CGReporting.Running_No__c;
        COIReport.supervisorName = CGReporting.Supervisor_Name__c;
        
        COIReport.badge = 0;
        
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            COIReport.badge = 1;
        }
        
        COIReport.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            COIReport.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            COIReport.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            COIReport.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            COIReport.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            COIReport.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            COIReport.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            COIReport.status.key = CG_Enum.ReportStatus.Rejected.name();
            COIReport.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            COIReport.status.key = CG_Enum.ReportStatus.Success.name();
            COIReport.status.value = 'Success';            
        }
        
        COIReport.startDuration = CGReporting.Start_Duration__c;
        COIReport.endDuration = CGReporting.End_Duration__c;
        COIReport.submittedDate = CGReporting.Submitted_Date__c;
        //COIReport.canEdit = checkCanEdit(String.ValueOf(COIReport.status.key));
        //COIReport.canDelete = checkCanDelete(String.ValueOf(COIReport.status.key));
        return COIReport;
        
    }
    
    @TestVisible
    private static CG_DTO.COIReportHistoryListDTO assignToCOIReportHistoryListDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.COIReportHistoryListDTO COIReporting = new CG_DTO.COIReportHistoryListDTO();
        COIReporting.id = CGReporting.Id;
        COIReporting.reportNumber = CGReporting.Running_No__c;
        
        COIReporting.reportType = new CG_Global.EnumValue('COIReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
            COIReporting.reportType.key = CG_Enum.COIReportType.COIAnnual.name();
            COIReporting.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
            COIReporting.reportType.key = CG_Enum.COIReportType.COIIncident.name();
            COIReporting.reportType.value = 'Incident';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
            COIReporting.reportType.key = CG_Enum.COIReportType.COINewEmployee.name();
            COIReporting.reportType.value = 'New Employee';
        }
        
        COIReporting.disclosureReport = new CG_Global.EnumValue(CGReporting.COI_Disclosure__c);
        if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes)) {
            COIReporting.disclosureReport.key = CG_Enum.COIDisclosure.Yes.name();
            COIReporting.disclosureReport.value = CG_Enum.COIDisclosure.Yes.name();
        }
        else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
            COIReporting.disclosureReport.key = CG_Enum.COIDisclosure.No.name();
            COIReporting.disclosureReport.value = CG_Enum.COIDisclosure.No.name();
        }
        else if(CGReporting.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
            COIReporting.disclosureReport.key = CG_Enum.COIDisclosure.NotSure.name();
            COIReporting.disclosureReport.value = CG_Enum.COIDisclosure.NotSure.name();
        }
        else {
            COIReporting.disclosureReport.key = '-';
            COIReporting.disclosureReport.value = '-';
        }
        
        COIReporting.supervisorName = CGReporting.Supervisor_Name__c;
        COIReporting.submittedDate = CGReporting.Submitted_Date__c;
        
        COIReporting.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            COIReporting.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            COIReporting.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            COIReporting.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            COIReporting.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            COIReporting.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            COIReporting.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            COIReporting.status.key = CG_Enum.ReportStatus.Rejected.name();
            COIReporting.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            COIReporting.status.key = CG_Enum.ReportStatus.Success.name();
            COIReporting.status.value = 'Success';            
        }
        
        return COIReporting;
        
    }

    @TestVisible
    private static CG_DTO.CGManualReportListDTO assignToCGManualReportListDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.CGManualReportListDTO Report = new CG_DTO.CGManualReportListDTO();
        Report.id = CGReporting.Id;
        
        Report.reportType = new CG_Global.EnumValue('CGReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
            Report.reportType.key = CG_Enum.CGReportType.CGAnnual.name();
            Report.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
            Report.reportType.key = CG_Enum.CGReportType.CGManual.name();
            Report.reportType.value = 'Manual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
            Report.reportType.key = CG_Enum.CGReportType.CGNewEmployee.name();
            Report.reportType.value = 'New Employee';
        }
        
        Report.reportNumber = CGReporting.Running_No__c;
        Report.supervisorName = CGReporting.Supervisor_Name__c;
        
        Report.badge = 0;
        
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
            Report.badge = 1;
        }
        
        Report.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            Report.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            Report.status.key = CG_Enum.ReportStatus.Success.name();
            Report.status.value = 'Success';            
        }
        
        Report.startDuration = CGReporting.Start_Duration__c;
        Report.endDuration = CGReporting.End_Duration__c;
        Report.submittedDate = CGReporting.Submitted_Date__c;
        //Report.canEdit = checkCanEdit(String.ValueOf(COIReport.status.key));
        //Report.canDelete = checkCanDelete(String.ValueOf(COIReport.status.key));
        return Report;
        
    }
    
    @TestVisible
    private static CG_DTO.CGReportHistoryListDTO assignToCGReportHistoryListDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.CGReportHistoryListDTO ManualReporting = new CG_DTO.CGReportHistoryListDTO();
        ManualReporting.id = CGReporting.Id;
        ManualReporting.reportNumber = CGReporting.Running_No__c;
        
        ManualReporting.reportType = new CG_Global.EnumValue('CGReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
            ManualReporting.reportType.key = CG_Enum.CGReportType.CGAnnual.name();
            ManualReporting.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
            ManualReporting.reportType.key = CG_Enum.CGReportType.CGManual.name();
            ManualReporting.reportType.value = 'Manual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
            ManualReporting.reportType.key = CG_Enum.CGReportType.CGNewEmployee.name();
            ManualReporting.reportType.value = 'New Employee';
        }
        
        //ManualReporting.supervisorName = CGReporting.Supervisor_Name__c;
        ManualReporting.submittedDate = CGReporting.Submitted_Date__c;
        
        ManualReporting.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            ManualReporting.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            ManualReporting.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            ManualReporting.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            ManualReporting.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            ManualReporting.status.key = CG_Enum.ReportStatus.Success.name();
            ManualReporting.status.value = 'Success';            
        }
        
        return ManualReporting;
        
    }

    @TestVisible
    private static CG_DTO.GiftReportListDTO assignToGiftReportListDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.GiftReportListDTO Report = new CG_DTO.GiftReportListDTO();
        Report.id = CGReporting.Id;
        
        Report.reportType = new CG_Global.EnumValue('GiftRegistration');
        Report.reportType.key = 'GiftRegistration';
        Report.reportType.value = 'Gift Registration';
        
        Report.reportNumber = CGReporting.Running_No__c;
        Report.supervisorName = CGReporting.Supervisor_Name__c;
        
        Report.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            Report.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            Report.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingGLGC.name();
            Report.status.value = 'Waiting GLGC';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            Report.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            Report.status.key = CG_Enum.ReportStatus.Success.name();
            Report.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            Report.status.key = CG_Enum.ReportStatus.Rejected.name();
            Report.status.value = 'Rejected';            
        }
        
        Report.lastUpdated = CGReporting.LastModifiedDate;
        Report.submittedDate = CGReporting.Submitted_Date__c;
        //Report.canEdit = checkCanEdit(String.ValueOf(COIReport.status.key));
        //Report.canDelete = checkCanDelete(String.ValueOf(COIReport.status.key));
        return Report;
        
    }
    
    @TestVisible
    private static CG_DTO.GiftReportHistoryListDTO assignToGiftReportHistoryListDTO(CG_Reporting__c CGReporting) {
        
        string userProfile = CG_PrivilegeHandler.getUserProfile();
        
        CG_DTO.GiftReportHistoryListDTO GiftReporting = new CG_DTO.GiftReportHistoryListDTO();
        GiftReporting.id = CGReporting.Id;
        GiftReporting.reportNumber = CGReporting.Running_No__c;
        
        GiftReporting.supervisorName = CGReporting.Supervisor_Name__c;
        GiftReporting.submittedDate = CGReporting.Submitted_Date__c;
        
        GiftReporting.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            GiftReporting.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            GiftReporting.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            GiftReporting.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            GiftReporting.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            GiftReporting.status.key = CG_Enum.ReportStatus.WaitingGLGC.name();
            GiftReporting.status.value = 'Waiting GLGC';   
            
            if(userProfile != String.ValueOf(CG_Enum.ApproverRole.GLGC)) {
                GiftReporting.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            	GiftReporting.status.value = 'Waiting GLVP';   
            }
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            GiftReporting.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            GiftReporting.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            GiftReporting.status.key = CG_Enum.ReportStatus.Success.name();
            GiftReporting.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            GiftReporting.status.key = CG_Enum.ReportStatus.Rejected.name();
            GiftReporting.status.value = 'Rejected';            
        }
        
        return GiftReporting;
        
    }

    @TestVisible
    private static CG_DTO.WorkflowHistoryDTO DeserializeWorkflowHistory(string workflowStatusJson) {
        
        string currentUserRole = CG_PrivilegeHandler.getUserProfile();
        
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(workflowStatusJson, CG_DTO.WorkflowHistoryDTO.class);

        string currentStatus = '';
        
        for(CG_DTO.WorkflowApproverDTO currentWorkflow : workflowHistoryDTO.currentWorkflow.approvers) {
        
            if(currentWorkflow.isCurrent) {
                currentStatus = currentWorkflow.status.key;
                
                if(currentUserRole != String.ValueOf(CG_Enum.ApproverRole.GLGC) && currentWorkflow.status.key == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                    workflowHistoryDTO.status.key = String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP);
                    workflowHistoryDTO.status.value = 'Waiting GLVP';
                }
                
                break;
            }
        }
        
        //Flow Box
        for(CG_DTO.WorkflowApproverDTO currentWorkflow : workflowHistoryDTO.currentWorkflow.approvers) {
            currentWorkflow.isShow = isShowStatusInHistory(currentUserRole, currentWorkflow.role.key);
            
            if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Employee) && currentStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)
               && currentWorkflow.role.key == String.ValueOf(CG_Enum.ApproverRole.GLVP))  {
                   currentWorkflow.isShow = false;  
            }
            else if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Employee) && currentStatus == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)
               && currentWorkflow.role.key == String.ValueOf(CG_Enum.ApproverRole.GLVP))  {
                   currentWorkflow.isShow = false;  
            }
        }
        
        //History Box
        if(workflowHistoryDTO.historyWorkflows != null) {
            for(CG_DTO.WorkflowDTO currentWorkflow : workflowHistoryDTO.historyWorkflows) {
                
                for(CG_DTO.WorkflowApproverDTO cw : currentWorkflow.approvers) {
                	
                    cw.isShow = isShowStatusInHistory(currentUserRole, cw.role.key);
                }
                
            }
        }
        
        return workflowHistoryDTO;
        
    }
    
    @TestVisible
    private static boolean isShowStatusInHistory(string currentUserRole, string role) {
        
        boolean isShow = false;
        
        if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Employee)) {
            
            if(role == String.ValueOf(CG_Enum.ApproverRole.Employee)
               || role == String.ValueOf(CG_Enum.ApproverRole.Supervisor)
               || role == String.ValueOf(CG_Enum.ApproverRole.GLVP)) {
                isShow = true;
            }
            else if(role == String.ValueOf(CG_Enum.ApproverRole.GLGC)) {
                isShow = false;
            }
        }
        else if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
        	if(role == String.ValueOf(CG_Enum.ApproverRole.Employee)
               || role == String.ValueOf(CG_Enum.ApproverRole.Supervisor)) {
                isShow = true;
            }
        }
        else if(currentUserRole == String.ValueOf(CG_Enum.ApproverRole.GLGC)
               || currentUserRole == String.ValueOf(CG_Enum.ApproverRole.GLVP)
               || currentUserRole == String.ValueOf(CG_Enum.ApproverRole.SuperAdmin)) {
        	isShow = true;
        }
        
        return isShow;
        
    }
    
    
}