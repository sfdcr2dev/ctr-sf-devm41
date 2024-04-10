public with sharing class CG_ExcelController {

    public DateTime todayDate {get;set;}
    public string exportAll {get;set;} //true false
    public string typeOfReport {get;set;}
    public string status {get;set;}
    public string startDate {get;set;}
    public string endDate {get;set;}
    public string coiAnswer {get;set;}
    public string company {get;set;}
    public string function {get;set;}
    public string department {get;set;}
    public string section {get;set;}
    public string unit {get;set;}
    public string giftStatus {get;set;}
    public string reportName {get;set;}
    public List<string> typeOfReports {get;set;}
    public string statisticName {get;set;}
    public string BaseURL {get;set;}
    
    public List<TableWrapper> TWs {get;set;}
    public List<StatisticWrapper> SWs {get;set;}
    public integer TWSize {get;set;}
    public integer SWSize {get;set;}
    
    public class TableWrapper {
        public string Id {get;set;}
        public string RecordLink {get;set;}
        public string No {get;set;}
        public string Name {get;set;}
        public string Type {get;set;}
        public string Function {get;set;}
        public string Status {get;set;}
        public string SubmittedDate {get;set;}
    }
    
    public class StatisticWrapper {
        public string ReportName {get;set;}
        public string Function {get;set;}
        public integer All {get;set;}
        public integer WaitingForSubmit {get;set;}
        public integer WaitingSupervisor {get;set;}
        public boolean isShowWaitingSupervisor {get;set;}
        public integer WaitingGLVP {get;set;}
        public integer isShowWaitingGLVP {get;set;}
        public integer Success {get;set;}
    }

    public CG_ExcelController() { }
    
    public void OnloadExcel() {
    
        TWs = new List<TableWrapper>();
        SWs = new List<StatisticWrapper>();
        
        BaseURL = URL.getSalesforceBaseUrl().toExternalForm();
    
        DateTime dt = datetime.now();
        TodayDate = dt;
        
        exportAll = ApexPages.currentPage().getParameters().get('exportAll');
        typeOfReport = ApexPages.currentPage().getParameters().get('typeOfReport');
        status = ApexPages.currentPage().getParameters().get('status');
        startDate = ApexPages.currentPage().getParameters().get('startDate');
        endDate = ApexPages.currentPage().getParameters().get('endDate');
        coiAnswer = ApexPages.currentPage().getParameters().get('coiAnswer');
        company = ApexPages.currentPage().getParameters().get('company');
        function = ApexPages.currentPage().getParameters().get('function');
        department = ApexPages.currentPage().getParameters().get('department');
        section = ApexPages.currentPage().getParameters().get('section');
        unit = ApexPages.currentPage().getParameters().get('unit');
        reportName = ApexPages.currentPage().getParameters().get('reportName');
        giftStatus = ApexPages.currentPage().getParameters().get('giftStatus');
        
        typeOfReports = new List<string>();
        
        if(reportName == 'COI' && typeOfReport.toLowerCase() == 'all') {
            typeOfReports.add(String.ValueOf(CG_Enum.COIReportType.COIAnnual));
            typeOfReports.add(String.ValueOf(CG_Enum.COIReportType.COIIncident));
            typeOfReports.add(String.ValueOf(CG_Enum.COIReportType.COINewEmployee));
        }
        else if(reportName == 'COI' && typeOfReport.toLowerCase() != 'all') {
            typeOfReports.add(String.ValueOf(typeOfReport));
        }
        else if(reportName == 'CG' && typeOfReport.toLowerCase() == 'all') {
            typeOfReports.add(String.ValueOf(CG_Enum.CGReportType.CGNewEmployee));
            typeOfReports.add(String.ValueOf(CG_Enum.CGReportType.CGAnnual));
            typeOfReports.add(String.ValueOf(CG_Enum.CGReportType.CGManual));
        }
        else if(reportName == 'CG' && typeOfReport.toLowerCase() != 'all') {
            typeOfReports.add(String.ValueOf(typeOfReport));
        }
        else if(reportName == 'Gift') {
            typeOfReports.add('GiftRegistration');
        }
    
        
        if(exportAll == 'true') {
            ExportAllData();
            StatisticData();
        }
        else {
            ExportData();
            StatisticData();
        }
    }
    
    public void ExportData() {
    
        Date startDT = Date.ValueOf(startDate);
        Date endDT = Date.ValueOf(endDate);
        
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.Reportstatus.Rejected) };
        List<CG_Reporting__c> CGReportings = new List<CG_Reporting__c>();
    
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                        'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, supervisor_approver_status__c, ' +
                        'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, Gift_Status__c , Status__c,' +
                        'OwnerId, Owner_Position__c, Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c from CG_Reporting__c ' + 
                        'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: startDT AND CreatedDate <=: endDT'; 
    
        //filter.giftStatus
        if(!String.isEmpty(giftStatus) && !String.isBlank(giftStatus) && giftStatus.toLowerCase() != 'all') {
            query = query + ' AND Gift_Status__c =: giftStatus';
        }
        
        //filter.status
        if(!String.isEmpty(status) && !String.isBlank(status) && status.toLowerCase() != 'all') {
            query = query + ' AND Status__c =: status';
        }
        
        //filter.company
        if(!String.isEmpty(company) && !String.isBlank(company) && company.toLowerCase() != 'all') {
            //query = query + ' AND COI_Transaction_Company__c =: company';
        }
        
        //filter.function
        if(!String.isEmpty(function) && !String.isBlank(function) && function.toLowerCase() != 'all') {
            query = query + ' AND Owner_Function__c =: function';
        }
        
        //filter.department
        if(!String.isEmpty(department) && !String.isBlank(department) && department.toLowerCase() != 'all') {
            query = query + ' AND Owner_Department__c =: department';
        }
        
        //filter.section
        if(!String.isEmpty(section) && !String.isBlank(section) &&section.toLowerCase() != 'all') {
            query = query + ' AND Owner_Section__c =: section';
        }
        
        CGReportings = database.query(query + ' order by Running_No__c desc');
        
        System.debug(CGReportings.size());
        
        if(CGReportings.size() > 0) {
        
            for(CG_Reporting__c CGReport : CGReportings) {
                TableWrapper TW = new TableWrapper();
                TW.Id = CGReport.Id;
                TW.No = CGReport.Running_No__c;
                TW.Name = CGReport.Owner_Full_Name_EN__c;
                TW.Type = CGReport.Type_Of_Report__c;
                TW.Function = CGReport.Owner_Function__c;
                
                if(string.isnotempty(CGReport.Owner_Department__c)) {
                    TW.Function += ' / ' + CGReport.Owner_Department__c;
                }
                if(string.isnotempty(CGReport.Owner_Section__c)) {
                    TW.Function += ' / ' + CGReport.Owner_Section__c;
                }
                if(string.isnotempty(CGReport.Owner_Unit__c)) {
                    TW.Function += ' / ' + CGReport.Owner_Unit__c;
                }
                
                TW.Status = CGReport.Status__c;
                TW.RecordLink = BaseURL + '/' + CGReport.Id;
                
                if(CGReport.Submitted_Date__c != null) {
                    Datetime dt = Date.Valueof(CGReport.Submitted_Date__c);   
                    TW.SubmittedDate = dt.format('dd/MM/yyyy');
                }
                
                TWs.add(TW);
                
            }
        }
        
        TWSize = TWs.size();
    }
    
    public void ExportAllData() {
    
        Date startDT = Date.ValueOf(startDate);
        Date endDT = Date.ValueOf(endDate);
        
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.Reportstatus.Rejected) };
        List<CG_Reporting__c> CGReportings = [select id, Running_No__c, User__c, Supervisor_Name__c, Start_Duration__c,
                                              End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,
                                              Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId, Owner_Full_Name_EN__c, COI_Transaction_Company__c,
                                              Company__c, Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c 
                                              from CG_Reporting__c where type_of_report__c IN: typeOfReports AND CreatedDate >=: startDT AND CreatedDate <=: endDT
                                              AND Status__c NOT IN: statuses order by createddate desc];
        
        if(CGReportings.size() > 0) {
        
            for(CG_Reporting__c CGReport : CGReportings) {
                TableWrapper TW = new TableWrapper();
                TW.Id = CGReport.Id;
                TW.No = CGReport.Running_No__c;
                TW.Name = CGReport.Owner_Full_Name_EN__c;
                TW.Type = CGReport.Type_Of_Report__c;
                TW.Function = CGReport.Owner_Function__c;
                
                if(string.isnotempty(CGReport.Owner_Department__c)) {
                    TW.Function += ' / ' + CGReport.Owner_Department__c;
                }
                if(string.isnotempty(CGReport.Owner_Section__c)) {
                    TW.Function += ' / ' + CGReport.Owner_Section__c;
                }
                if(string.isnotempty(CGReport.Owner_Unit__c)) {
                    TW.Function += ' / ' + CGReport.Owner_Unit__c;
                }
                
                TW.Status = CGReport.Status__c;
                TW.RecordLink = BaseURL + '/' + CGReport.Id;
                
                if(CGReport.Submitted_Date__c != null) {
                    Datetime dt = Date.Valueof(CGReport.Submitted_Date__c);   
                    TW.SubmittedDate = dt.format('dd/MM/yyyy');
                }
                
                TWs.add(TW);
                
            }
        }
        
        TWSize = TWs.size();
        
    }
    
    public void StatisticData() {
    
        Date startDT = Date.ValueOf(startDate);
        Date endDT = Date.ValueOf(endDate);
        
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.Reportstatus.Rejected) };
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        string query = '';
        query = 'select id, Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c, Status__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Function__c != \'\' ' +
                ' AND CreatedDate >=: startDT AND CreatedDate <=: endDT AND Status__c NOT IN: statuses '  ;  
                  
        string groupByQuery = '';
        groupByQuery = 'select Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND ' +
                        'CreatedDate >=: startDT AND CreatedDate <=: endDT AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' ';
         
        //typeOfReport
        if(typeOfReport.toLowerCase() != 'all') {
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
            groupByQuery = groupByQuery + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //status
        if(string.isnotempty(status) && status.toLowerCase() != 'all') {
        
            if(status == String.ValueOf(CG_Enum.ApproverStatus.Submitted)) {
                status = String.ValueOf(CG_Enum.ReportStatus.Success);
            }
        
            query = query + ' AND Status__c =: status';
            groupByQuery = groupByQuery + ' AND Status__c =: status';
        }
        
        //coiAnswer
        if(string.isnotempty(coiAnswer) && coiAnswer.toLowerCase() != 'all') {
            query = query + ' AND COI_Disclosure__c =: coiAnswer';
            groupByQuery = groupByQuery + ' AND COI_Disclosure__c =: coiAnswer';
        }
        
        //companyId
        if(string.isnotempty(company) && company.toLowerCase() != 'all') {
            //string companyId = filter.company;
            //query = query + ' AND COI_Transaction_Company__c =: companyId';
        }
        
        //function
        if(string.isnotempty(function) && function.toLowerCase() != 'all') {
            query = query + ' AND Owner_Function__c =: function';
            groupByQuery = groupByQuery + ' AND Owner_Function__c =: function';
        }
        
        //department
        if(string.isnotempty(department) && department.toLowerCase() != 'all') {
            query = query + ' AND Owner_Department__c =: department';
            groupByQuery = groupByQuery + ' AND Owner_Department__c =: department';
        }
        
        //section
        if(string.isnotempty(section) && section.toLowerCase() != 'all') {
            query = query + ' AND Owner_Section__c =: section';
            groupByQuery = groupByQuery + ' AND Owner_Section__c =: section';
        }
        
        //filter.unit
        if(string.isnotempty(unit) && unit.toLowerCase() != 'all') {
            query = query + ' AND Owner_Unit__c =: unit';
            groupByQuery = groupByQuery + ' AND Owner_Unit__c =: unit';
        }

        //Final query
        CGReports = Database.query(query);
        
        //Grouping By   
        if(CGReports.size() > 0) {
            
            statisticName = 'Function : Department : Section : Unit';
            
            List<string> Functions = CGGlobal_GetFunctions(null);
        	System.debug(Functions);
            if(Functions.size() > 0) {
                
                integer total = 0;
                integer WaitingForSubmit = 0;
                integer WaitingSupervisor = 0;
                integer WaitingGLVP = 0;
                integer Success = 0;
                
                StatisticWrapper SW = new StatisticWrapper();
                    
                for(string currentFunction : Functions) {
                    
                    string finalQuery = groupByQuery + ' AND Owner_Function__c =: currentFunction group by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c order by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c asc';
                    
                    integer totalFunction = 0;
                    integer WaitingForSubmitFunction = 0;
                    integer WaitingSupervisorFunction = 0;
                    integer WaitingGLVPFunction = 0;
                    integer SuccessFunction = 0;
                    
                    Set<string> existDepartments = new Set<string>();
                    Set<string> existSections = new Set<string>();
                    Set<string> existUnits = new Set<string>();
                    
                    boolean isFunctionFound = false;
                    
                    List<StatisticWrapper> allSWs = new List<StatisticWrapper>();
                    
                    for(AggregateResult AR : database.query(finalQuery)) {
                        
                        integer totalDepartment = 0;
                        integer WaitingForSubmitDepartment = 0;
                        integer WaitingSupervisorDepartment = 0;
                        integer WaitingGLVPDepartment = 0;
                        integer SuccessDepartment = 0;
                        
                        integer totalSection = 0;
                        integer WaitingForSubmitSection = 0;
                        integer WaitingSupervisorSection = 0;
                        integer WaitingGLVPSection = 0;
                        integer SuccessSection = 0;
                        
                        integer totalUnit = 0;
                        integer WaitingForSubmitUnit = 0;
                        integer WaitingSupervisorUnit = 0;
                        integer WaitingGLVPUnit = 0;
                        integer SuccessUnit = 0;
                        
                        string department = '';
                        string section = '';
                        string unit = '';
                        
                        if(AR.get('Owner_Department__c') != null && AR.get('Owner_Department__c') != '') {
                            department = AR.get('Owner_Department__c').toString();
                        }
                        if(AR.get('Owner_Section__c') != null && AR.get('Owner_Section__c') != '') {
                            section = AR.get('Owner_Section__c').toString();
                        }
                        if(AR.get('Owner_Unit__c') != null && AR.get('Owner_Unit__c') != '') {
                            unit = AR.get('Owner_Unit__c').toString();
                        }
                        
                        for(CG_Reporting__c CGReport : CGReports) {
                            
                            //Function
                            if(CGReport.Owner_Function__c == currentFunction && !isFunctionFound) {
                                totalFunction++;
                                
                                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                    WaitingForSubmitFunction++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                    WaitingSupervisorFunction++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                                    WaitingGLVPFunction++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                    SuccessFunction++;
                                }
                            }
                            
                            //Department
                            if(CGReport.Owner_Department__c == department) {
                                totalDepartment++;
                                
                                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                    WaitingForSubmitDepartment++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                    WaitingSupervisorDepartment++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                                    WaitingGLVPDepartment++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                    SuccessDepartment++;
                                }
                            }
                            
                            //Section
                            if(CGReport.Owner_Section__c == section) {
                                totalSection++;
                                
                                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                    WaitingForSubmitSection++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                    WaitingSupervisorSection++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                                    WaitingGLVPSection++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                    SuccessSection++;
                                }
                            }
                            
                            //Unit
                            if(CGReport.Owner_Unit__c == unit) {
                                totalUnit++;
                                
                                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                    WaitingForSubmitUnit++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                    WaitingSupervisorUnit++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                                    WaitingGLVPUnit++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                    SuccessUnit++;
                                }
                            }
                            
                        }
                        
                        isFunctionFound = true;
                        
                        //Department
                        if(!existDepartments.contains(department)) {
                            if(department != '' && department != null) {
                            
                                SW = new StatisticWrapper();
                                SW.Function = currentFunction + ' / ' + department;
                                SW.All = totalDepartment;
                                SW.WaitingForSubmit = WaitingForSubmitDepartment;
                                SW.WaitingSupervisor = WaitingSupervisorDepartment;
                                SW.WaitingGLVP = WaitingGLVPDepartment;
                                SW.Success = SuccessDepartment;
                                allSWs.add(SW);
                                
                            }
                            existDepartments.add(department);
                        }
                        
                        
                        //Section
                        if(!existSections.contains(section)) {
                            if(section != '' && section != null) {
                                SW = new StatisticWrapper();
                                SW.Function = currentFunction + ' / ' + department + ' / ' + section;
                                SW.All = totalSection;
                                SW.WaitingForSubmit = WaitingForSubmitSection;
                                SW.WaitingSupervisor = WaitingSupervisorSection;
                                SW.WaitingGLVP = WaitingGLVPSection;
                                SW.Success = SuccessSection;
                                allSWs.add(SW);
                            }
                            existSections.add(section);
                        }
                        
                        //Unit
                        if(!existUnits.contains(unit)) {
                            if(unit != '' && unit != null) {
                                SW = new StatisticWrapper();
                                SW.Function = currentFunction + ' / ' + department + ' / ' + section + ' / ' + unit;
                                SW.All = totalUnit;
                                SW.WaitingForSubmit = WaitingForSubmitUnit;
                                SW.WaitingSupervisor = WaitingSupervisorUnit;
                                SW.WaitingGLVP = WaitingGLVPUnit;
                                SW.Success = SuccessUnit;
                                allSWs.add(SW);
                            }
                            existUnits.add(unit);
                        }
                
                        
                    }
                      
                    //Function
                    if(totalFunction > 0) {
                        
                        SW = new StatisticWrapper();
                        SW.Function = currentFunction;
                        SW.All = totalFunction;
                        SW.WaitingForSubmit = WaitingForSubmitFunction;
                        SW.WaitingSupervisor = WaitingSupervisorFunction;
                        SW.WaitingGLVP = WaitingGLVPFunction;
                        SW.Success = SuccessFunction;
                        SWs.add(SW);
                        
                        if(allSWs.size() > 0) {
                            for(StatisticWrapper otherSW : allSWs) {
                                SWs.add(otherSW);
                            }
                        }
                        
                    }
                    
                }
                
                //Total
                if(CGReports.size() > 0) {
                    for(CG_Reporting__c CGReport : CGReports) {
                            
                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                            WaitingForSubmit++;
                        }
                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                            WaitingSupervisor++;
                        }
                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                            WaitingGLVP++;
                        }
                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                            Success++;
                        }
                        
                    }
                }
                
                SW = new StatisticWrapper();
                SW.Function = 'Total';
                SW.All = CGReports.size();
                SW.WaitingForSubmit = WaitingForSubmit;
                SW.WaitingSupervisor = WaitingSupervisor;
                SW.WaitingGLVP = WaitingGLVP;
                SW.Success = Success;
                SWs.add(SW);
                
            }
        }
        
        SWSize = SWs.size();
    }
    
    
    //Global
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
    

}