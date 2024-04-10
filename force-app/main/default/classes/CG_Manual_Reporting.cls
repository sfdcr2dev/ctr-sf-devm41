public with sharing class CG_Manual_Reporting {
    private static List<CG_DTO.CGManualReportListDTO> CGManualListDTOs;
    private static CG_DTO.CGManualReportListDTO NewEmployeeDTO;
    private static CG_DTO.CGManualReportListDTO AnnualDTO;
    private static CG_DTO.CGManualReportDetailDTO CGManualReportDetail;
    private static CG_DTO.CGReportHistoryCountDTO ReportHistoryCount;
    private static CG_DTO.AdminCGReportListCountDTO AdminCGReportListCount;
    private static List<CG_DTO.AdminCGReportListDTO> AdminCGReportListDTOs;
    
    static {
        CG_Manual_Reporting.InitializeManualListData();
    }
    
    //Check whether user has privilege to access particular record or not
    @RemoteAction
    public static boolean CheckAccessPrivilege(string reportId) {
        boolean canAccess = CG_PrivilegeHandler.checkAccessPrivilege(reportId);
        return canAccess;
    }
    
    //Get All Manual Report
    private static void InitializeManualListData() {
        
        CGManualListDTOs = new List<CG_DTO.CGManualReportListDTO>();
        
        string userProfile = CG_PrivilegeHandler.getUserProfile();
        string userId = CG_PrivilegeHandler.getUserId();
        
        Date SD = Date.newInstance( date.today().year(), 1, 1 );
        Date ED = Date.newInstance( date.today().year(), 12, 31 );
        
        List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();
        
        List<string> CGManualTypes = new List<string>();
        CGManualTypes.add(String.ValueOf(CG_Enum.CGReportType.CGNewEmployee));
        CGManualTypes.add(String.ValueOf(CG_Enum.CGReportType.CGAnnual));
        CGManualTypes.add(String.ValueOf(CG_Enum.CGReportType.CGManual));
        
        CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                              End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                              Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, COI_Action__c,
                                              COI_Detail__c from CG_Reporting__c
                                              where OwnerId =: userId AND Type_of_Report__c IN: CGManualTypes AND
                        					  Start_Duration__c >=: SD AND Start_Duration__c <=: ED order by Createddate asc];
		
        if(CGReportings.size() > 0) {
            
            for(CG_Reporting__c CGReporting : CGReportings) {
                
                CG_DTO.CGManualReportListDTO ManualReportDTO = new CG_DTO.CGManualReportListDTO();
                ManualReportDTO = assignToCGManualReportListDTO(CGReporting);
                CGManualListDTOs.add(ManualReportDTO);
                
            }
            
        }
            
    }
    
    //Count all new cg manual (for paging purpose)
    @RemoteAction
    public static Integer GetNewCGManualReportCount() {
        
        integer manualCount = 0;
        
        if(CGManualListDTOs.size() > 0) {
            for(CG_DTO.CGManualReportListDTO CG : CGManualListDTOs) {
                if(CG.reportType.key == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
                    manualCount += 1;
                }
            }
        }
        
        return manualCount;
        
    }
    
    //Query NewCGManual Table Data of logined user including paging and sorting
    @RemoteAction
    public static List<CG_DTO.CGManualReportListDTO> GetNewCGManualReports(
        //reportNumber, supervisorName, status, duration, submittedDate
        CG_Global.SortByParam sortByParam, 
        CG_Global.PageParam pageParam) {
            
        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageSize = 1;
            pageParam.pageNo = 1;
        } 
            
        CGManualListDTOs = new List<CG_DTO.CGManualReportListDTO>();
        string userId = CG_PrivilegeHandler.getUserId();
            
        Date SD = Date.newInstance( date.today().year(), 1, 1 );
        Date ED = Date.newInstance( date.today().year(), 12, 31 );
            
        List<CG_DTO.CGManualReportListDTO> results = new List<CG_DTO.CGManualReportListDTO>();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
            
        List<string> CGTypes = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGManual) };
        //List<string> Statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Success) };
            
        string query = 'select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                            'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                            'where OwnerId =: userId AND Type_Of_Report__c IN: CGTypes AND ' + 
            				'Start_Duration__c >=: SD AND Start_Duration__c <=: ED ';
            
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
            else if(sortByParam.sortBy == 'status') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Status__c desc');
                }
            }
            else if(sortByParam.sortBy == 'duration') {
                if(sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Start_Duration__c asc');
                }
                else if(!sortByParam.ascending) {
                    CGReports = database.query(query + ' order by Start_Duration__c desc');
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
            else {
                CGReports = database.query(query + ' order by Running_No__c desc');
            }    
            
            if(CGReports.size() > 0) {
            
            	for(CG_Reporting__c CGReporting : CGReports) {
                    CG_DTO.CGManualReportListDTO CGReportDTO = new CG_DTO.CGManualReportListDTO();
                    CGReportDTO = assignToCGManualReportListDTO(CGReporting);
                    CGManualListDTOs.add(CGReportDTO);
                    
                }
                
            }
            
        Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
        integer totalSize = CGManualListDTOs.size() - startIndex;
            
        for (Integer i = 0; i < pageParam.pageSize; i++ ) {
            if (i < totalSize){
                results.add(CGManualListDTOs[startIndex + i]);
            }else{
                break;
            }
        }
        return results;
    }
    
    
    //Query New Employee Report of logined user (if not exists, return null)
    @RemoteAction
    public static CG_DTO.CGManualReportListDTO GetNewEmployeeReport() {
        
        if(CGManualListDTOs.size() > 0) {
            
            for(CG_DTO.CGManualReportListDTO ManualReportDTO : CGManualListDTOs) {
                
                if(ManualReportDTO.reportType.key == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
                    
                    NewEmployeeDTO = new CG_DTO.CGManualReportListDTO();
                    NewEmployeeDTO = ManualReportDTO;
                    NewEmployeeDTO.badge = 0;
                    
                    if(ManualReportDTO.status.key == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                        NewEmployeeDTO.badge = 1;
                    }
                }
                
            }
            
        }
        
        return NewEmployeeDTO;
        
    }
    
    //Query Annual Report of logined user (if not exists, return null)
    @RemoteAction
    public static CG_DTO.CGManualReportListDTO GetAnnualReport(){
        if(CGManualListDTOs.size() > 0) {
            for(CG_DTO.CGManualReportListDTO ManualReportDTO : CGManualListDTOs) {
                if(ManualReportDTO.reportType.key == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
                    System.debug('----1');
                    AnnualDTO = new CG_DTO.CGManualReportListDTO();
                    AnnualDTO = ManualReportDTO;
                    
                }
                
            }
            
        }
        
        return annualDTO;
    }
    
    //Get CG Report Detail using report id
    @RemoteAction
    public static CG_DTO.CGManualReportDetailDTO GetReportDetail(string reportId) {
        
        string userId = CG_PrivilegeHandler.getUserId();
        CGManualReportDetail = new CG_DTO.CGManualReportDetailDTO();
        
        if(reportId != null) {
         
            List<CG_Reporting__c> CGReports = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                               End_Duration__c, Submitted_Date__c, Type_Of_Report__c , Status__c,
                                               Status_JSON__c, IsAcknowledge__c, OwnerId,
                                               CG_Download_Manual__c, CG_Agree_to_Study__c, CG_Received_Manual__c,
                                               Reported_By_TH__c, Reported_By_EN__c, Reported_By_Position_TH__c,
                                               Reported_By_Position_EN__c, Reported_By_Company_TH__c, Reported_By_Company_EN__c,
                                               Reported_Date__c, isDisable__c 
                                               from CG_Reporting__c where Id =: reportId];
            
            for(CG_Reporting__c CGReport : CGReports) {
                CGManualReportDetail = assignToCGManualReportDetailDTO(CGReport);
            }
                
        }
        
        return CGManualReportDetail;
    }

    //Submit report (for employee)
    @RemoteAction
    public static CG_DTO.CGManualReportDetailDTO SubmitReport(CG_DTO.CGManualReportDetailDTO report){
        
        string userId = CG_PrivilegeHandler.getUserId();
        
        try {
            
            if(report.id != null) {
                
                CG_Reporting__c CGReporting = [select id, Status__c, Running_No__c, Status_JSON__c, User__c, Reported_By_EN__c from CG_Reporting__c where Id =: report.id AND 
                                               (Status__c =: String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) OR Status__c =: String.ValueOf(CG_Enum.ReportStatus.Rejected))];
            
                CGReporting.Status__c = String.ValueOf(CG_Enum.ReportStatus.Success);
                CGReporting.CG_Received_Manual__c = report.haveReceived;
                CGReporting.CG_Agree_to_Study__c = report.willStudy;
                CGReporting.CG_Download_Manual__c = report.haveDownloaded;
                
                CGReporting.Submitted_Date__c = system.Date.today();
                
                update(CGReporting);
                
            }
            else {
                System.debug('Cannot submit CG Manual. Report not found.');
            }
            
        }
        catch(DmlException e) {
            System.debug('SubmitReport exception has occurred: ' + e.getMessage());
        }
        
        return report;
        
    }
    
    @RemoteAction
    public static CG_DTO.AdminCGReportListCountDTO GetAdminCGReportListCount(
        //employee name
        string ownerName,
        //employee id
        string ownerId,
    	//companyId, function, department, section, unit
    	string companyId, string function, string department, string section, string unit){
        
        AdminCGReportListCount = new CG_DTO.AdminCGReportListCountDTO();
        AdminCGReportListCount.totalReport = 0;
        AdminCGReportListCount.annual = 0;
        AdminCGReportListCount.newEmployee = 0;
        AdminCGReportListCount.newCGManual = 0;
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGNewEmployee), 
            											String.ValueOf(CG_Enum.CGReportType.CGAnnual), 
            											String.ValueOf(CG_Enum.CGReportType.CGManual) };
            
        string userId = CG_PrivilegeHandler.getUserId();
        
        Set<CG_Reporting__c> allCGReports = new Set<CG_Reporting__c>();    
        List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();     
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c, ' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c,' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c , Status__c,' +
            				'Status_JSON__c, IsAcknowledge__c, OwnerId, Owner_Position__c from CG_Reporting__c ' +
                            'where Type_Of_Report__c IN: typeOfReports';
        
        //companyId
        if(!String.isEmpty(companyId) && !String.isBlank(companyId) && companyId.toLowerCase() != 'all') {
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
        }
        
        //function
        if(!String.isEmpty(function) && !String.isBlank(function) && function.toLowerCase() != 'all') {
            query = query + ' AND Owner_Function__c =: function';
        }
        
        //department
        if(!String.isEmpty(department) && !String.isBlank(department) && department.toLowerCase() != 'all') {
            query = query + ' AND Owner_Department__c =: department';
        }
        
        //section
        if(!String.isEmpty(section) && !String.isBlank(section) && section.toLowerCase() != 'all') {
            query = query + ' AND Owner_Section__c =: section';
        }
        
        //unit
        if(!String.isEmpty(unit) && !String.isBlank(unit) && unit.toLowerCase() != 'all') {
            query = query + ' AND Owner_Unit__c =: unit';
        }
        
        //Final query
        CGReportings = database.query(query + ' order by Running_No__c asc');
            
        if(CGReportings.size() > 0) {
            
            for(CG_Reporting__c CGReport : CGReportings) {
                if(!string.isBlank(ownerName) && string.isBlank(ownerId)) {
                    ownerName = ownerName.toLowerCase();
                    if((CGReport.Owner_Full_Name_TH__c != null && CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName)) || (CGReport.Owner_Full_Name_EN__c != null && CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName))) {
                        allCGReports.add(CGReport);
                    }
                }
                else if(string.isBlank(ownerName) && !string.isBlank(ownerId)) {
                    if(CGReport.Employee_Id__c == ownerId) {
                        allCGReports.add(CGReport);
                    }
                }
                else if(!string.isBlank(ownerName) && !string.isBlank(ownerId)) {
                    ownerName = ownerName.toLowerCase();
                    if((CGReport.Owner_Full_Name_TH__c != null && CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName)) || (CGReport.Owner_Full_Name_EN__c != null && CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName))) {
                        allCGReports.add(CGReport);
                    }
                    if(CGReport.Employee_Id__c == ownerId) {
                        allCGReports.add(CGReport);
                    }
                }
                else {
                    allCGReports.add(CGReport); 
                }
                
            }
            
            AdminCGReportListCount.totalReport = allCGReports.size();
            
            for(CG_Reporting__c CGReport : allCGReports) {
                if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
                    AdminCGReportListCount.annual += 1;
                }
                else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
                    AdminCGReportListCount.newEmployee += 1;
                }
                else if(CGReport.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
                    AdminCGReportListCount.newCGManual += 1;
                }
            }
        }    
            
        return AdminCGReportListCount;
            
    }
    
    @RemoteAction
    public static List<CG_DTO.AdminCGReportListDTO> GetAdminCGReportList(
    //employee name
    string ownerName,
    //employee id
    string ownerId,
    //companyId, function, department, section, unit
    string companyId, string function, string department, string section, string unit,
    //reportNumber, reportType, owner, reportStatus, submittedDate
    CG_Global.SortByParam sortByParam, 
    CG_Global.PageParam pageParam
    ) {
        
        AdminCGReportListDTOs = new List<CG_DTO.AdminCGReportListDTO>();
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual), 
            											String.ValueOf(CG_Enum.CGReportType.CGManual), 
            											String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
            
        string userId = CG_PrivilegeHandler.getUserId();
        
        List<CG_Reporting__c> allCGReports = new List<CG_Reporting__c>();   
        List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();     
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c, ' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c,' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c , Status__c,' +
            				'Status_JSON__c, IsAcknowledge__c, OwnerId, Owner_Position__c from CG_Reporting__c ' +
                            'where Type_Of_Report__c IN: typeOfReports';
        
        //companyId
        if(!String.isEmpty(companyId) && !String.isBlank(companyId) && companyId.toLowerCase() != 'all') {
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
        }
        
        //function
        if(!String.isEmpty(function) && !String.isBlank(function) && function.toLowerCase() != 'all') {
            query = query + ' AND Owner_Function__c =: function';
        }
        
        //department
        if(!String.isEmpty(department) && !String.isBlank(department) && department.toLowerCase() != 'all') {
            query = query + ' AND Owner_Department__c =: department';
        }
        
        //section
        if(!String.isEmpty(section) && !String.isBlank(section) && section.toLowerCase() != 'all') {
            query = query + ' AND Owner_Section__c =: section';
        }
        
        //unit
        if(!String.isEmpty(unit) && !String.isBlank(unit) && unit.toLowerCase() != 'all') {
            query = query + ' AND Owner_Unit__c =: unit';
        }
        
        //SortBy
        if(sortByParam.sortBy == 'reportNumber') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by running_no__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by running_no__c desc');
            }
        }
        else if(sortByParam.sortBy == 'reportType') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by type_of_report__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by type_of_report__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerName') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Owner_Full_Name_EN__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Owner_Full_Name_EN__c desc');
            }
        }
        else if(sortByParam.sortBy == 'status') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Status__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Status__c desc');
            }
        }
        else if(sortByParam.sortBy == 'submittedDate') {
            if(sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Submitted_Date__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReportings = database.query(query + ' order by Submitted_Date__c desc');
            }
        }
        else {
            CGReportings = database.query(query + ' order by Running_No__c asc');
        }
        
        if(CGReportings.size() > 0) {
            
            for(CG_Reporting__c CGReport : CGReportings) {
                if(!string.isBlank(ownerName) && string.isBlank(ownerId)) {
                    ownerName = ownerName.toLowerCase();
                    if((CGReport.Owner_Full_Name_TH__c != null && CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName)) || (CGReport.Owner_Full_Name_EN__c != null && CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName))) {
                        allCGReports.add(CGReport);
                    }
                }
                else if(string.isBlank(ownerName) && !string.isBlank(ownerId)) {
                    if(CGReport.Employee_Id__c == ownerId) {
                        allCGReports.add(CGReport);
                    }
                }
                else if(!string.isBlank(ownerName) && !string.isBlank(ownerId)) {
                    ownerName = ownerName.toLowerCase();
                    if((CGReport.Owner_Full_Name_TH__c != null && CGReport.Owner_Full_Name_TH__c.toLowerCase().contains(ownerName)) || (CGReport.Owner_Full_Name_EN__c != null && CGReport.Owner_Full_Name_EN__c.toLowerCase().contains(ownerName))) {
                        allCGReports.add(CGReport);
                    }
                    if(CGReport.Employee_Id__c == ownerId) {
                        allCGReports.add(CGReport);
                    }
                }
                else {
                    allCGReports.add(CGReport); 
                }
                
            }
            
            //PageParam
            if(allCGReports.size() > 0) {
                Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            	integer totalSize = allCGReports.size() - startIndex;
                for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                    if (i < totalSize){
                        AdminCGReportListDTOs.add(assignToAdminCGReportListDTO(allCGReports[startIndex + i]));
                    }else{
                        break;
                    }
                }
                
            }
        }
        
        return AdminCGReportListDTOs;
    }
    
    @RemoteAction
    public static void AdminResendReport(string reportId){
        CG_Reporting__c CGReport = [select id, Type_Of_Report__c, OwnerId, Status__c, Running_No__c, Submitted_Date__c, User__c,
                                    Start_Duration__c, End_Duration__c, Reported_By_EN__c from CG_Reporting__c where Id =: reportId];
        
        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            CG_ReportingHandler.CGReminderEmail(CGReport.OwnerId, CGReport);
            
            if(CGReport.Type_of_Report__c == CG_Enum.CGReportType.CGAnnual.name()) {
                //Send Bell Noti to Owner
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please acknowledge CG Annual';
                BellNoti.Body = 'Please submit your annual report for CG Manual Acknowledgement : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.OwnerId);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGReport.Id + '&parent=cgManualReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.OwnerId;
                OppNoti.Subject = 'Please acknowledge CG Annual';
                OppNoti.Description = 'Please submit your annual report for CG Manual Acknowledgement : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGReport.Id + '&parent=cgManualReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            else if(CGReport.Type_of_Report__c == CG_Enum.CGReportType.CGNewEmployee.name()) {
                
                //Send Bell Noti to Owner
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please acknowledge your CG Manual for New Employee';
                BellNoti.Body = 'Please acknowledge your CG Manual for New Employee : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.OwnerId);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGReport.Id + '&parent=cgManualReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.OwnerId;
                OppNoti.Subject = 'Please acknowledge your CG Manual for New Employee';
                OppNoti.Description = 'Please acknowledge your CG Manual for New Employee : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGReport.Id + '&parent=cgManualReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
                
            }
            else if(CGReport.Type_of_Report__c == CG_Enum.CGReportType.CGManual.name()) {
                //Send Bell Noti to Owner
                CG_DTO.BellNotiDTO BellNoti = new CG_DTO.BellNotiDTO();
                BellNoti.NotificationName = 'CG_Notification';
                BellNoti.Title = 'Please acknowledge New CG Manual';
                BellNoti.Body = 'Please submit your CG Manual (New CG Manual) : ' + CGReport.Running_No__c;
                BellNoti.Receivers = new Set<string>();
                BellNoti.Receivers.add(CGReport.OwnerId);
        		BellNoti.RecordId = CGReport.Id;
                BellNoti.PageRef = '{type: \'standard__webPage\',attributes: { url: \'/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGReport.Id + '&parent=cgManualReporting\'}}';
                CG_NotiController.SendBellNoti(BellNoti);
                
                //Send Opp Noti
                CG_DTO.OppNotiDTO OppNoti = new CG_DTO.OppNotiDTO();
                OppNoti.ApproverId = CGReport.OwnerId;
                OppNoti.Subject = 'Please acknowledge New CG Manual';
                OppNoti.Description = 'Please submit your CG Manual (New CG Manual) : ' + CGReport.Running_No__c;
                OppNoti.RequesterName = CGReport.Reported_By_EN__c;
                OppNoti.Status = 'New';
                
                string URL = URL.getSalesforceBaseUrl().toExternalFOrm() + '/one/one.app#/alohaRedirect/apex/CG_Manual_Detail?reportId=' + CGReport.Id + '&parent=cgManualReporting';
                
                OppNoti.URL = URL;
                OppNoti.ReferenceId = CGReport.Id;
                CG_NotiController.SendOppNoti(OppNoti);
            }
            
            
        }
    }

    @RemoteAction
    public static void AdminCancelReport(string reportId){
        
        string userId = CG_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = CG_Global.assignToPISUser(userId);
        CG_Reporting__c CGReport = [select id, OwnerId, Status__c from CG_Reporting__c where Id =: reportId];
        CGReport.Status__c = String.valueOf(CG_Enum.ReportStatus.Cancel);
        CGReport.Cancelled_By__c = PISUser.EN_Fullname__c;
        CGReport.Cancelled_Date__c = date.today();
        update(CGReport);
    }
    
    @RemoteAction
    public static CG_DTO.CGManualFilesDTO ManualFiles() {
        
        CG_DTO.CGManualFilesDTO CGManualFile = new CG_DTO.CGManualFilesDTO();
        string URL = URL.getSalesforceBaseUrl().toExternalForm();
        
        Id cgSettingId = [select id, type__c from CG_Setting__c where type__c = 'CGManual'].Id;
        
        List<attachment> attachments = getAttachmentIds(cgSettingId);
        
        if(attachments.size() > 0) {
            for(Attachment attachment : attachments) {
                if(attachment.Name.contains('_EN')) {
                    CGManualFile.manualENFileUrl = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                }
                else if(attachment.Name.contains('_TH')) {
                    CGManualFile.manualTHFileUrl = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                }
            }
        }
        
        return CGManualFile;
        
    }
    
    //Assign to DTO section
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
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            Report.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            Report.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            Report.status.key = CG_Enum.ReportStatus.Expired.name();
            Report.status.value = 'Expired';            
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
    private static CG_DTO.CGManualReportDetailDTO assignToCGManualReportDetailDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.CGManualReportDetailDTO CGManualReportDetail = new CG_DTO.CGManualReportDetailDTO();
        
        CGManualReportDetail.id = CGReporting.Id;
        
        CGManualReportDetail.reportType = new CG_Global.EnumValue('CGReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
            CGManualReportDetail.reportType.key = CG_Enum.CGReportType.CGAnnual.name();
            CGManualReportDetail.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
            CGManualReportDetail.reportType.key = CG_Enum.CGReportType.CGManual.name();
            CGManualReportDetail.reportType.value = 'Manual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
            CGManualReportDetail.reportType.key = CG_Enum.CGReportType.CGNewEmployee.name();
            CGManualReportDetail.reportType.value = 'New Employee';
        }
        
        CGManualReportDetail.reportNumber = CGReporting.Running_No__c;
        CGManualReportDetail.supervisorName = CGReporting.Supervisor_Name__c;
        
        CGManualReportDetail.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            CGManualReportDetail.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            CGManualReportDetail.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            CGManualReportDetail.status.key = CG_Enum.ReportStatus.Success.name();
            CGManualReportDetail.status.value = 'Success';            
        }
        
        CGManualReportDetail.startDuration = CGReporting.Start_Duration__c;
        CGManualReportDetail.endDuration = CGReporting.End_Duration__c;
        CGManualReportDetail.submittedDate = CGReporting.Submitted_Date__c;
        
        CGManualReportDetail.haveReceived = CGReporting.CG_Received_Manual__c;
        CGManualReportDetail.willStudy = CGReporting.CG_Agree_to_Study__c;
        
        CGManualReportDetail.reportedDate = CGReporting.Reported_Date__c;
        
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            PISUsers__c PISUser = CG_Global.assignToPISUser(CGReporting.OwnerId);
            CGManualReportDetail.reportedByTH = PISUser.THTITLE__c + ' ' + PISUser.THFIRSTNAME__c + ' ' + PISUser.THLASTNAME__c;
            CGManualReportDetail.reportedByEN = PISUser.EN_Fullname__c;
            CGManualReportDetail.reportedByEmployeeID = PISUser.EMPLOYEEID__c;
        }
        else {
            PISUsers__c PISUser = CG_Global.assignToPISUser(CGReporting.OwnerId);
            CGManualReportDetail.reportedByTH = CGReporting.Reported_By_TH__c;
            CGManualReportDetail.reportedByEN = CGReporting.Reported_By_EN__c;
            CGManualReportDetail.reportedByEmployeeID = PISUser.EMPLOYEEID__c;
        }
        
        List<CG_Setting__c> CGSettings = [select id, Type__c, Type_Formula__c, Detail__c  from CG_Setting__c];
        
        System.debug(CGSettings);
        
        CG_Setting__c cgSettingNewEmployee = new CG_Setting__c();
        CG_Setting__c cgSettingManual = new CG_Setting__c();
        CG_Setting__c cgSettingAnnual = new CG_Setting__c();
        
        Id cgSettingNewEmployeeId;
        Id cgSettingManualId;
        Id cgSettingAnnualId;
        
        if(CGSettings.size() > 0) {
            
            for(CG_Setting__c CGSetting : CGSettings) {
                if(CGSetting.type__c == 'CGNewEmployee') {
                    cgSettingNewEmployee = CGSetting;
                    cgSettingNewEmployeeId = CGSetting.Id;
                }
                else if(CGSetting.type__c == 'CGManual') {
                    cgSettingManual = CGSetting;
                    cgSettingManualId = CGSetting.Id;
                }
                else if(CGSetting.type__c == 'Annual') {
                    cgSettingAnnual = CGSetting;
                    cgSettingAnnualId = CGSetting.Id;
                }
            }
            
        }
        
        //Document Link
        string URL = URL.getSalesforceBaseUrl().toExternalForm();
        
        //Get Attachment
        string fileURLTH = '';
        string fileURLEN = '';
        string imageUrl1 = '';
        string imageUrl2 = '';
        string imageUrl3 = '';
        string imageUrl4 = '';
        
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
            
        	CGManualReportDetail.detail = cgSettingAnnual.Detail__c;
                
            List<Attachment> AnnualAttachments = getAttachmentIds(cgSettingAnnualId);
            if(AnnualAttachments.size() > 0) {
                for(Attachment attachment : AnnualAttachments) {
                    if(string.isEmpty(imageUrl1)) {
                        imageUrl1 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl2)) {
                        imageUrl2 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl3)) {
                        imageUrl3 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl4)) {
                        imageUrl4 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                }
            }
            
            List<Attachment> ManualAttachments = getAttachmentIds(cgSettingManualId);
            if(ManualAttachments.size() > 0) {
                for(Attachment attachment : ManualAttachments) {
                    if(attachment.Name.contains('_EN')) {
                        fileURLEN = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(attachment.Name.contains('_TH')) {
                        fileURLTH = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                }
            }
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
            
        	CGManualReportDetail.detail = cgSettingManual.Detail__c;

            List<Attachment> ManualAttachments = getAttachmentIds(cgSettingManualId);
            if(ManualAttachments.size() > 0) {
                for(Attachment attachment : ManualAttachments) {
                    if(attachment.Name.contains('_EN')) {
                        fileURLEN = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(attachment.Name.contains('_TH')) {
                        fileURLTH = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl1)) {
                        imageUrl1 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl2)) {
                        imageUrl2 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl3)) {
                        imageUrl3 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl4)) {
                        imageUrl4 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                }
            }
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
            
        	CGManualReportDetail.detail = cgSettingNewEmployee.Detail__c;

            List<Attachment> NewEmployeeAttachments = getAttachmentIds(cgSettingNewEmployeeId);
            if(NewEmployeeAttachments.size() > 0) {
                for(Attachment attachment : NewEmployeeAttachments) {
                    if(string.isEmpty(imageUrl1)) {
                        imageUrl1 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl2)) {
                        imageUrl2 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl3)) {
                        imageUrl3 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(string.isEmpty(imageUrl4)) {
                        imageUrl4 = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                }
            }
            
            List<Attachment> ManualAttachments = getAttachmentIds(cgSettingManualId);
            if(ManualAttachments.size() > 0) {
                for(Attachment attachment : ManualAttachments) {
                    if(attachment.Name.contains('_EN')) {
                        fileURLEN = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                    else if(attachment.Name.contains('_TH')) {
                        fileURLTH = URL + '/servlet/servlet.FileDownload?file=' + attachment.Id;
                    }
                }
            }
        }
        
        //Image Link
        CGManualReportDetail.fileUrlTH = fileURLTH;
        CGManualReportDetail.fileUrlEN = fileURLEN;
        CGManualReportDetail.imageUrl1 = imageUrl1;
        CGManualReportDetail.imageUrl2 = imageUrl2;
        CGManualReportDetail.imageUrl3 = imageUrl3;
        CGManualReportDetail.imageUrl4 = imageUrl4;
        
        if(CGReporting.isDisable__c) {
            CGManualReportDetail.isShowManual = false;
            CGManualReportDetail.canSubmit = false;
        }
        else {
            CGManualReportDetail.isShowManual = true;
            CGManualReportDetail.canSubmit = true;
            
            if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                CGManualReportDetail.canSubmit = false;
            }
        }
        
        return CGManualReportDetail;
    }
    
    @TestVisible
    private static CG_DTO.AdminCGReportListDTO assignToAdminCGReportListDTO(CG_Reporting__c CGReporting) {
        
        CG_DTO.AdminCGReportListDTO AdminCGReport = new CG_DTO.AdminCGReportListDTO();
        
        AdminCGReport.id = CGReporting.Id;
        AdminCGReport.reportNumber = CGReporting.Running_No__c;
        
        AdminCGReport.reportType = new CG_Global.EnumValue('CGReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
            AdminCGReport.reportType.key = CG_Enum.CGReportType.CGAnnual.name();
            AdminCGReport.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
            AdminCGReport.reportType.key = CG_Enum.COIReportType.COIIncident.name();
            AdminCGReport.reportType.value = 'Manual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
            AdminCGReport.reportType.key = CG_Enum.COIReportType.COINewEmployee.name();
            AdminCGReport.reportType.value = 'New Employee';
        }
        
        AdminCGReport.badge = 0;
        AdminCGReport.position = CGReporting.Owner_Position__c;
        AdminCGReport.supervisorName = CGReporting.Supervisor_Name__c;
        
        AdminCGReport.status = new CG_Global.EnumValue(CGReporting.Status__c); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            AdminCGReport.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            AdminCGReport.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            AdminCGReport.status.key = CG_Enum.ReportStatus.Expired.name();
            AdminCGReport.status.value = 'Expired';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            AdminCGReport.status.key = CG_Enum.ReportStatus.Success.name();
            AdminCGReport.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Cancel)) {
            AdminCGReport.status.key = CG_Enum.ReportStatus.Cancel.name();
            AdminCGReport.status.value = 'Cancel';            
        }
        
        AdminCGReport.startDuration = CGReporting.Start_Duration__c;
        AdminCGReport.endDuration = CGReporting.End_Duration__c;
        AdminCGReport.submittedDate = CGReporting.Submitted_Date__c;
        
        AdminCGReport.owner = CG_Global.assignToUserDTO(CGReporting.OwnerId);
        AdminCGReport.canResend = checkCanResend(String.ValueOf(AdminCGReport.status.key));
        AdminCGReport.canCancel = checkCanCancel(String.ValueOf(AdminCGReport.status.key));
        
        return AdminCGReport;
    }
    
    @TestVisible
    private static boolean checkCanSubmit(string status) {
        boolean canSubmit = false;
        
        if(status == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) ||
           status == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor) || 
           status == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP) || 
           status == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
           canSubmit = true;
        }
        
        return canSubmit;
    }

    @TestVisible
    private static boolean checkCanResend(string status) {
        boolean canResend = false;
        if(status != String.ValueOf(CG_Enum.ReportStatus.Success) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Cancel) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            canResend = true;
        }
        return canResend;
    }
    
    @TestVisible
    private static boolean checkCanCancel(string status) {
        boolean canCancel = false;
        if(status != String.ValueOf(CG_Enum.ReportStatus.Success) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Cancel) && 
            status != String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            canCancel = true;
        }
        return canCancel;
    }
    
    @TestVisible
    private static List<Attachment> getCGSettingDetail(string cgSettingId) {
        
        List<Attachment> existAttachments = new List<Attachment>();
        List<Attachment> attachments = [select id, parentId, name, createddate from Attachment where ParentId =: cgSettingId];
        
        if(attachments.size() > 0) {
            for(Attachment attachment : attachments) {
                existAttachments.add(attachment);
            }
        }
        
        return existAttachments;
    }
    
    @TestVisible
    private static List<Attachment> getAttachmentIds(string cgSettingId) {
        List<Attachment> existAttachments = new List<Attachment>();
        
        List<Attachment> attachments = [select id, parentId, name, createddate from Attachment where ParentId =: cgSettingId];
        
        if(attachments.size() > 0) {
            for(Attachment attachment : attachments) {
                existAttachments.add(attachment);
            }
        }
        
        return existAttachments;
    }
    
	@RemoteAction
    public static CG_DTO.CGAcknowledgeFormDTO CGAcknowledgeForm(string reportId) {
        
        CG_Reporting__c CGReport = [select id, ownerId, Submitted_Date__c from CG_Reporting__c where Id =: reportId];
        
        string userId = CGReport.OwnerId;
        PISUsers__c User = CG_Global.assignToPISUser(userId);
        
        CG_DTO.CGAcknowledgeFormDTO Form = new CG_DTO.CGAcknowledgeFormDTO();
        Form.employeeId = User.EMPLOYEEID__c;
        Form.employeeName = User.EN_Fullname__c;
        Form.submittedDate = CGReport.Submitted_Date__c;
        
        return Form;
    }
    
    @RemoteAction
    public static List<CG_DTO.CompanyDTO> CGGlobal_GetCompanies() {
        List<CG_DTO.CompanyDTO> Companies = CG_Global.GetCompanies();
        return Companies;
    } 
    
    @RemoteAction
    public static List<string> CGGlobal_GetFunctions(string companyId) {
        List<string> Functions = CG_Global.GetFunctions(companyId);
        return Functions;
    }
    
    @RemoteAction
    public static List<string> CGGlobal_GetDepartments(string function) {
        List<string> Departments = CG_Global.GetDepartments(function);
        return Departments;
    }  
    
    @RemoteAction
    public static List<string> CGGlobal_GetSections(string department) {
        List<string> Sections = CG_Global.GetSections(department);
        return Sections;
    }  
    
    @RemoteAction
    public static List<string> CGGlobal_GetUnits(string section) {
        List<string> Units = CG_Global.GetUnits(section);
        return Units;
    }  
    
    public class ReportCGSearchCriteria {
        //enum CGReportType
        @RemoteAction
        public string reportType {get;set;}
        //enum ReportStatus (WaitingForSubmit, Success)
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public datetime startDate {get;set;}
        @RemoteAction
        public datetime endDate {get;set;}
        @RemoteAction
        public string companyId {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
    }
}