/* 
 * Author Softever
*/

global with sharing class CG_Report {

    //COI Report
    private static CG_DTO.ReportCOISummaryCountDTO ReportCOISummaryCount;
    private static CG_DTO.ReportCOIAnswerChartSeriesDTO ReportCOIAnswerChartSeries;
    private static List<CG_DTO.ReportCOITypeRadialChartItemDTO> ReportCOITypeRadialChartItems;
    private static List<CG_DTO.ReportCOIStatusSeriesDTO> ReportCOIStatusSeries;
    private static List<CG_DTO.ReportCOIInfoDTO> ReportCOIInfoList;
    private static CG_DTO.ReportCOIStatisticDTO ReportCOIStatistics;
    
    //CG Report
    private static CG_DTO.ReportCGSummaryCountDTO ReportCGSummaryCount;
    private static List<CG_DTO.ReportCGTypeRadialChartItemDTO> ReportCGTypeRadialChartItems;
    private static List<CG_DTO.ReportCGStatusSeriesDTO> ReportCGStatusSeries;
    private static List<CG_DTO.ReportCGInfoDTO> ReportCGInfoList;
    private static CG_DTO.ReportCGStatisticDTO ReportCGStatistics;
    
    //Gift Registration
    private static CG_DTO.ReportGiftSummaryCountDTO ReportGiftSummaryCount;
    private static List<CG_DTO.ReportGiftStatusSeriesDTO> ReportGiftStatusSeries;
    private static CG_DTO.ReportGiftStatusChartSeriesDTO ReportGiftStatusChartSeries;
    private static List<CG_DTO.ReportGiftInfoDTO> ReportGiftInfoList;
    private static CG_DTO.ReportGiftStatisticDTO ReportGiftStatistics;
    
    static {
        
    }
    
    //COI RemoteAction
    @RemoteAction
    public static CG_DTO.ReportCOISummaryCountDTO GetReportCOISummaryCount(CG_COI_Reporting.ReportCOISearchCriteria filter){
        
        ReportCOISummaryCount = new CG_DTO.ReportCOISummaryCountDTO();
        ReportCOISummaryCount.totalReport = 0;
        ReportCOISummaryCount.completeReport = 0;
        ReportCOISummaryCount.waitingforSubmitReport = 0;
        ReportCOISummaryCount.waitingSupervisorReport = 0;
        ReportCOISummaryCount.waitingGLVPReport = 0;
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), 
            											String.ValueOf(CG_Enum.COIReportType.COIIncident), 
            											String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
                   
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                                                        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();                                                    
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, COI_Transaction_Company__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,' +
            				'COI_Disclosure__c, OwnerId, CreatedDate from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED';
                                                            
                                                            
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType.toLowerCase() != 'all') {
            string typeOfReport = filter.reportType;
            
            if(typeOfReport == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                statuses.add(String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit));
            }
            
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
        
        //filter.coiAnswer
        if(!String.isEmpty(filter.coiAnswer) && !String.isBlank(filter.coiAnswer) && filter.coiAnswer.toLowerCase() != 'all') {
            string coiAnswer = filter.coiAnswer;
            query = query + ' AND COI_Disclosure__c =: coiAnswer';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

		//Final query
		CGReports = Database.query(query);                                                    
                
        if(CGReports.size() > 0) {
            
            integer totalReport = 0;
            
            for(CG_Reporting__c CGReport : CGReports) {
                System.debug(CGReport.Status__c);
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                    ReportCOISummaryCount.completeReport += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                    ReportCOISummaryCount.waitingforSubmitReport += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                    ReportCOISummaryCount.waitingSupervisorReport += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                    ReportCOISummaryCount.waitingGLVPReport += 1;
                    totalReport++;
                }
                
            }
            
            reportCOISummaryCount.totalReport = totalReport;
        }
        
        return ReportCOISummaryCount;
    }
    
    @RemoteAction
    public static CG_DTO.ReportCOIAnswerChartSeriesDTO GetReportCOIAnswerChart(CG_COI_Reporting.ReportCOISearchCriteria filter){
        
        ReportCOIAnswerChartSeries = new CG_DTO.ReportCOIAnswerChartSeriesDTO();
        ReportCOIAnswerChartSeries.series = new List<CG_DTO.ReportCOIAnswerChartSerieItemDTO>();
        CG_DTO.ReportCOIAnswerChartSerieItemDTO serie = new CG_DTO.ReportCOIAnswerChartSerieItemDTO();
        
        integer coiAnswerYes = 0;
        integer coiAnswerNo = 0;
        integer coiAnswerNotSure = 0;
        integer totalCOI = 0;
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), 
            											String.ValueOf(CG_Enum.COIReportType.COIIncident), 
            											String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
                                        
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                                                        
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();                                                    
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, Reported_By_Company_EN__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,' +
            				'COI_Disclosure__c, OwnerId, CreatedDate from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED';
        
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType.toLowerCase() != 'all') {
            string typeOfReport = filter.reportType;
            
            if(typeOfReport == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                statuses.add(String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit));
            }
            
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
        
        //filter.coiAnswer
        if(!String.isEmpty(filter.coiAnswer) && !String.isBlank(filter.coiAnswer) && filter.coiAnswer.toLowerCase() != 'all') {
            string coiAnswer = filter.coiAnswer;
            query = query + ' AND COI_Disclosure__c =: coiAnswer';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

		//Final query
		CGReports = Database.query(query);
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.Yes)) {
                    coiAnswerYes += 1;
                }
                else if(CGReport.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.No)) {
                    coiAnswerNo += 1;
                }
                else if(CGReport.COI_Disclosure__c == String.ValueOf(CG_Enum.COIDisclosure.NotSure)) {
                    coiAnswerNotSure += 1;
                }
                
            }
            
            totalCOI = coiAnswerYes + coiAnswerNo + coiAnswerNotSure;
            
            serie.name = 'Yes';
            serie.color = '#8DC7EB';
            serie.count = coiAnswerYes;
            
            if(coiAnswerYes == 0) {
                serie.y = 0;
            }
            else {
                serie.y = (coiAnswerYes * 100) / totalCOI;
            }
            
            ReportCOIAnswerChartSeries.series.add(serie);
            
            serie = new CG_DTO.ReportCOIAnswerChartSerieItemDTO();
            serie.name = 'No';
            serie.color = '#FFD065';
            serie.count = coiAnswerNo;
            
            if(coiAnswerNo == 0) {
                serie.y = 0;
            }
            else {
                serie.y = (coiAnswerNo * 100 ) / totalCOI;
            }
            
            ReportCOIAnswerChartSeries.series.add(serie);
            
            serie = new CG_DTO.ReportCOIAnswerChartSerieItemDTO();
            serie.name = 'Not Sure';
            serie.color = '#FC849C';
            serie.count = coiAnswerNotSure;
            
            if(coiAnswerNotSure == 0) {
                serie.y = 0;
            }
            else {
                serie.y = (coiAnswerNotSure * 100) / totalCOI;
            }
            
            ReportCOIAnswerChartSeries.series.add(serie);
        }
        
        return ReportCOIAnswerChartSeries;
    }

    @RemoteAction
    public static List<CG_DTO.ReportCOITypeRadialChartItemDTO> GetReportCOITypeRadialChart(CG_COI_Reporting.ReportCOISearchCriteria filter){
        
        ReportCOITypeRadialChartItems = new List<CG_DTO.ReportCOITypeRadialChartItemDTO>();
        CG_DTO.ReportCOITypeRadialChartItemDTO item = new CG_DTO.ReportCOITypeRadialChartItemDTO();
        
        integer annual = 0;
        integer incident = 0;
        integer newEmployee = 0;
        integer total = 0;
              
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), 
            											String.ValueOf(CG_Enum.COIReportType.COIIncident), 
            											String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
                                 
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                 
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();                                                    
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, Reported_By_Company_EN__c , ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,' +
            				'COI_Disclosure__c, OwnerId, CreatedDate from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED';
        
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType.toLowerCase() != 'all') {
            string typeOfReport = filter.reportType;
            
            if(typeOfReport == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                statuses.add(String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit));
            }
            
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
        
        //filter.coiAnswer
        if(!String.isEmpty(filter.coiAnswer) && !String.isBlank(filter.coiAnswer) && filter.coiAnswer.toLowerCase() != 'all') {
            string coiAnswer = filter.coiAnswer;
            query = query + ' AND COI_Disclosure__c =: coiAnswer';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

		//Final query
		CGReports = Database.query(query);  
        System.debug(CGReports.size());
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIAnnual)) {
                    annual += 1;
                }
                else if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                    incident += 1;
                }
                else if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.COIReportType.COINewEmployee)) {
                    newEmployee += 1;
                }
                
            }
            
            total = annual + incident + newEmployee;
        }
        
        item.type = 'COIAnnual';
        
        if(annual == 0) {
            item.percent = 0;
        }
        else {
        	item.percent = (annual * 100) / total;
        }
        
        item.color = '#82C177';
        item.count = annual;
        ReportCOITypeRadialChartItems.add(item);
        
        item = new CG_DTO.ReportCOITypeRadialChartItemDTO();
        item.type = 'COIIncident';
        
        if(incident == 0) {
            item.percent = 0;
        }
        else {
        	item.percent = (incident * 100) / total;
        }
        
        item.color = '#F27D60';
        item.count = incident;
        ReportCOITypeRadialChartItems.add(item);
        
        item = new CG_DTO.ReportCOITypeRadialChartItemDTO();
        item.type = 'COINewEmployee';
        
        if(newEmployee == 0) {
            item.percent = 0;
        }
        else {
        	item.percent = (newEmployee * 100) / total;
        }
        
        item.color = '#476DA0';
        item.count = newEmployee;
        ReportCOITypeRadialChartItems.add(item);
        
        return ReportCOITypeRadialChartItems;
    }
    
    @RemoteAction
    public static List<CG_DTO.ReportCOIStatusSeriesDTO> GetReportCOIStatusSeriesChart(
        CG_COI_Reporting.ReportCOISearchCriteria filter, 
        //TypeOfReport, Status, StartDate, EndDate, coiAnswer, Company, Function, Department, Section, Unit
        string groupingBy){
            
        ReportCOIStatusSeries = new List<CG_DTO.ReportCOIStatusSeriesDTO>();
              
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), 
            											String.ValueOf(CG_Enum.COIReportType.COIIncident), 
            											String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
                           
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                             
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
            
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        string query = '';
        query = 'select id, Owner_Function__c, Owner_Department__c, Status__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' ';  
        	 
        if(groupingBy == 'Company') {
            query = 'select id, Owner_Function__c, Owner_Department__c, Status__c from CG_Reporting__c ' +
                	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED';
        }
        else if(groupingBy == 'Function') {
            query = 'select id, Owner_Function__c, Owner_Department__c, Status__c from CG_Reporting__c ' +
                	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED';
        }
        else if(groupingBy == 'Department') {
            query = 'select Owner_Department__c, Owner_Section__c, Status__c from CG_Reporting__c ' + 
                	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Department__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED';
        }
        else if(groupingBy == 'Section') {
            query = 'select Owner_Section__c, Owner_Unit__c, Status__c from CG_Reporting__c ' +
                	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Section__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED';
        }
            
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType.toLowerCase() != 'all') {
            string typeOfReport = filter.reportType;
            
            if(typeOfReport == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                statuses.add(String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit));
            }
            
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
        
        //filter.coiAnswer
        if(!String.isEmpty(filter.coiAnswer) && !String.isBlank(filter.coiAnswer) && filter.coiAnswer.toLowerCase() != 'all') {
            string coiAnswer = filter.coiAnswer;
            query = query + ' AND COI_Disclosure__c =: coiAnswer';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

        //After Filter then group by
        string groupByQuery = '';
        if(groupingBy == 'Company') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Function__c, Owner_Department__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Function__c != \'\' ';
        }
        else if(groupingBy == 'Function') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Function__c, Owner_Department__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Function__c != \'\' ';
        }
        else if(groupingBy == 'Department') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Department__c, Owner_Section__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Department__c != \'\' ';
        }
        else if(groupingBy == 'Section') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
        	groupByQuery = 'select Owner_Section__c, Owner_Unit__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Section__c != \'\' ';
        }
        else if(groupingBy == 'Unit') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Unit__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Unit__c != \'\' ';
        }
            
		//Final query
		System.debug(query);
		CGReports = Database.query(query);  
           
        /* List<Id> CompanyIds = new List<Id>();
        List<SD_Company__c> Companies = new List<SD_Company__c>();
            
        if(filter.companyId != 'All' && !String.isEmpty(filter.companyId)) {
            if(filter.companyId.contains(',')) {
                CompanyIds = filter.companyId.split(',');
            }
            else {
                CompanyIds.add(filter.companyId);
            }
            
            Companies = [select id, name from SD_Company__c where Id IN: CompanyIds order by Order__c asc];
              
            if(Companies.size() > 0) {
                for(SD_Company__c Company : Companies) {
            		ReportCOIStatusSeries.categories.add(Company.Name);
                }
            }
        } */
           
        CG_DTO.ReportCOIStatusSeriesDTO ReportCOIStatus = new CG_DTO.ReportCOIStatusSeriesDTO();
        ReportCOIStatus.series = new List<CG_DTO.ReportCOIStatusSerieItemDTO>();    
        CG_DTO.ReportCOIStatusSerieItemDTO serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
            
        //Grouping By   
        if(CGReports.size() > 0) {
            
            List<AggregateResult> AggregateResults = new List<AggregateResult>();
            
            //Company
            if(groupingBy == 'Company') {
                
                List<string> Functions = CGGlobal_GetFunctions(null);
            	integer totalFunctionCount = Functions.size();
                
                if(Functions.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer functionCount = 0;
                    
                    for(string currentFunction : Functions) {
                        
                        ReportCOIStatus = new CG_DTO.ReportCOIStatusSeriesDTO();
        				ReportCOIStatus.series = new List<CG_DTO.ReportCOIStatusSerieItemDTO>();    
                        ReportCOIStatus.category = currentFunction;
                        
                        System.debug(currentFunction);
                        
                        //string finalQuery = groupByQuery + ' AND Owner_Function__c =: currentFunction group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                        
                        integer totalFunction = 0;
                        
                        for(AggregateResult AR : AggregateResults) { //database.query(finalQuery)
                            
                            if(AR.get('Owner_Function__c') == currentFunction) {
                                
                                totalFunction++;
                            
                                integer WaitingForSubmit = 0;
                                integer WaitingSupervisor = 0;
                                integer WaitingGLVP = 0;
                                integer Success = 0;
                                integer Rejected = 0;
                                
                                string department = '';
                                
                                if(AR.get('Owner_Department__c') != null && AR.get('Owner_Department__c') != '') {
                                    department = AR.get('Owner_Department__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Department__c == department) {
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
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                                            Rejected++;
                                        }
                                    }
                                }
                                
                                System.debug(department + ' : ' + WaitingForSubmit + ' : ' + WaitingSupervisor + ' : ' + WaitingGLVP + ' : ' + Success + ' : ' + Rejected);
                                
                                if(WaitingForSubmit > 0) {
                                    
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, functionCount);
                                    serie.color = '#F27D60';
                                    serie.stack = department;
                                    
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(WaitingSupervisor > 0) {
                                    
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingSupervisor';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingSupervisor, functionCount);
                                    serie.color = '#706DB6';
                                    serie.stack = department;
                                    
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(WaitingGLVP > 0) {
                                    
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingGLVP';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingGLVP, functionCount);
                                    serie.color = '#1FA4CE';
                                    serie.stack = department;
                                    
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, functionCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = department;
                                    
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                            }
                        }
                        
                        if(totalFunction > 0) {
                        	functionCount++;
                            if(ReportCOIStatus.series.size() > 0) {
                        		ReportCOIStatusSeries.add(ReportCOIStatus);
                            }

                        }
                        
                    }
                }
            }
            //Function
            else if(groupingBy == 'Function') {
                
                List<string> Functions = new List<string>(); 
                
            	if(!string.isEmpty(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
                	Functions = CGGlobal_GetFunctions(filter.companyId);
                }
                else {
                    Functions = CGGlobal_GetFunctions(null);
                }
                
                if(Functions.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer functionCount = 0;
                    
                    for(string currentFunction : Functions) {
                        
                        ReportCOIStatus = new CG_DTO.ReportCOIStatusSeriesDTO();
        				ReportCOIStatus.series = new List<CG_DTO.ReportCOIStatusSerieItemDTO>();    
                        ReportCOIStatus.category = currentFunction;
                        
                        System.debug(currentFunction);
                        
                        //string finalQuery = groupByQuery + ' AND Owner_Function__c =: currentFunction group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                        
                        integer totalFunction = 0;
                        
                        for(AggregateResult AR : AggregateResults) { //database.query(finalQuery)
                            
                            if(AR.get('Owner_Function__c') == currentFunction) {
                                
                                totalFunction++;
                            
                                integer WaitingForSubmit = 0;
                                integer WaitingSupervisor = 0;
                                integer WaitingGLVP = 0;
                                integer Success = 0;
                                integer Rejected = 0;
                                
                                string department = '';
                                
                                if(AR.get('Owner_Department__c') != null && AR.get('Owner_Department__c') != '') {
                                    department = AR.get('Owner_Department__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Department__c == department) {
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
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                                            Rejected++;
                                        }
                                    }
                                }
                                
                                System.debug(department + ' : ' + WaitingForSubmit + ' : ' + WaitingSupervisor + ' : ' + WaitingGLVP + ' : ' + Success + ' : ' + Rejected);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, functionCount);
                                    serie.color = '#F27D60';
                                    serie.stack = department;
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(WaitingSupervisor > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingSupervisor';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingSupervisor, functionCount);
                                    serie.color = '#706DB6';
                                    serie.stack = department;
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(WaitingGLVP > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingGLVP';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingGLVP, functionCount);
                                    serie.color = '#1FA4CE';
                                    serie.stack = department;
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, functionCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = department;
                                    ReportCOIStatus.series.add(serie);
                                }
                            }
                            
                        }
                        
                        if(totalFunction > 0) {
                            functionCount++;
                            
                            if(ReportCOIStatus.series.size() > 0) {
                                ReportCOIStatusSeries.add(ReportCOIStatus);
                            }
                            
                        }
                        
                    }
                }
            }
            //Department
            else if(groupingBy == 'Department') {
                
                List<string> Departments = new List<string>(); 
                
                if(!string.isEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
                    Departments = CGGlobal_GetDepartments(filter.function);
                }
                else {
                    Departments = CGGlobal_GetDepartments(null);
                }
                
                if(Departments.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Department__c, Owner_Section__c order by Owner_Department__c, Owner_Section__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer departmentCount = 0;
                    
                    for(string currentDepartment : Departments) {
                        
                        ReportCOIStatus = new CG_DTO.ReportCOIStatusSeriesDTO();
        				ReportCOIStatus.series = new List<CG_DTO.ReportCOIStatusSerieItemDTO>();    
                        ReportCOIStatus.category = currentDepartment;
                        
                        //string finalQuery = groupByQuery + ' AND Owner_Department__c =: currentDepartment group by Owner_Department__c, Owner_Section__c order by Owner_Department__c, Owner_Section__c asc';
                        
                        integer totalDepartment = 0;
                        
                        for(AggregateResult AR : AggregateResults) { //database.query(finalQuery)
                            
                            if(AR.get('Owner_Department__c') == currentDepartment) {
                                totalDepartment++;
                            
                                integer WaitingForSubmit = 0;
                                integer WaitingSupervisor = 0;
                                integer WaitingGLVP = 0;
                                integer Success = 0;
                                integer Rejected = 0;
                                
                                string section = '';
                                
                                if(AR.get('Owner_Section__c') != null && AR.get('Owner_Section__c') != '') {
                                    section = AR.get('Owner_Section__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Section__c == section) {
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
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                                            Rejected++;
                                        }
                                    }
                                }
                                
                                System.debug(section + ' : ' + WaitingForSubmit + ' : ' + WaitingSupervisor + ' : ' + WaitingGLVP + ' : ' + Success + ' : ' + Rejected);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, departmentCount);
                                    serie.color = '#F27D60';
                                    serie.stack = section;
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(WaitingSupervisor > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingSupervisor';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingSupervisor, departmentCount);
                                    serie.color = '#706DB6';
                                    serie.stack = section;
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(WaitingGLVP > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingGLVP';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingGLVP, departmentCount);
                                    serie.color = '#1FA4CE';
                                    serie.stack = section;
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, departmentCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = section;
                                    ReportCOIStatus.series.add(serie);
                                }
                            }
                        }
                        
                        if(totalDepartment > 0) {
                            departmentCount++;
                            
                            if(ReportCOIStatus.series.size() > 0) {
                            	ReportCOIStatusSeries.add(ReportCOIStatus);
                            }

                        }
                        
                    }
                }
            }    
            //Section
            else if(groupingBy == 'Section') {
                
                List<string> Sections = new List<string>();
                
                if(!string.isEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
                	Sections = CGGlobal_GetSections(filter.department);
                }
                else {
                    Sections = CGGlobal_GetSections(null);
                }
                
                if(Sections.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Section__c, Owner_Unit__c order by Owner_Section__c, Owner_Unit__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer sectionCount = 0;
                    
                    for(string currentSection : Sections) {
                        
                        ReportCOIStatus = new CG_DTO.ReportCOIStatusSeriesDTO();
        				ReportCOIStatus.series = new List<CG_DTO.ReportCOIStatusSerieItemDTO>();    
                        ReportCOIStatus.category = currentSection;
                        
                        System.debug(currentSection);
                        
                        //string finalQuery = groupByQuery + ' AND Owner_Section__c =: currentSection group by Owner_Section__c, Owner_Unit__c order by Owner_Section__c, Owner_Unit__c asc';
                        
                        integer totalSection = 0;
                        
                        for(AggregateResult AR : AggregateResults) { //database.query(finalQuery)
                            
                            if(AR.get('Owner_Section__c') == currentSection) {
                                totalSection++;
                            
                                integer WaitingForSubmit = 0;
                                integer WaitingSupervisor = 0;
                                integer WaitingGLVP = 0;
                                integer Success = 0;
                                integer Rejected = 0;
                                
                                string unit = '';
                                
                                if(AR.get('Owner_Unit__c') != null && AR.get('Owner_Unit__c') != '') {
                                    unit = AR.get('Owner_Unit__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Unit__c == unit) {
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
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                                            Rejected++;
                                        }
                                    }
                                }
                                
                                System.debug(unit + ' : ' + WaitingForSubmit + ' : ' + WaitingSupervisor + ' : ' + WaitingGLVP + ' : ' + Success + ' : ' + Rejected);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, sectionCount);
                                    serie.color = '#F27D60';
                                    serie.stack = unit;
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(WaitingSupervisor > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingSupervisor';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingSupervisor, sectionCount);
                                    serie.color = '#706DB6';
                                    serie.stack = unit;
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(WaitingGLVP > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'WaitingGLVP';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingGLVP, sectionCount);
                                    serie.color = '#1FA4CE';
                                    serie.stack = unit;
                                    ReportCOIStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportCOIStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, sectionCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = unit;
                                    ReportCOIStatus.series.add(serie);
                                }
                            }
                        }
                        
                        if(totalSection > 0) {
                            sectionCount++;
                            
                            if(ReportCOIStatus.series.size() > 0) {
                        		ReportCOIStatusSeries.add(ReportCOIStatus);
                            }

                        }
                        
                    }
                }
            } 
        }
        
        return ReportCOIStatusSeries;
            
    }

    @RemoteAction
    public static List<CG_DTO.ReportCOIInfoDTO> GetReportCOIInfoList(CG_COI_Reporting.ReportCOISearchCriteria filter,
    //reportNumber, reportType, owner, ownerOrgFunction, reportStatus, submittedDate
    CG_Global.SortByParam sortByParam,
    CG_Global.PageParam pageParam) {
        
        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), 
            											String.ValueOf(CG_Enum.COIReportType.COIIncident), 
            											String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
                                                                                                  
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                     
        ReportCOIInfoList = new List<CG_DTO.ReportCOIInfoDTO>();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
                                                         
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, Reported_By_Company_EN__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c,' +
            				'COI_Disclosure__c, OwnerId, Owner_Position__c, Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED ';
        
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType.toLowerCase() != 'all') {
            string typeOfReport = filter.reportType;
            
            if(typeOfReport == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                statuses.add(String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit));
            }
            
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
        
        //filter.coiAnswer
        if(!String.isEmpty(filter.coiAnswer) && !String.isBlank(filter.coiAnswer) && filter.coiAnswer.toLowerCase() != 'all') {
            string coiAnswer = filter.coiAnswer;
            query = query + ' AND COI_Disclosure__c =: coiAnswer';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

        //sortBy
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
        else if(sortByParam.sortBy == 'owner') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_full_name_en__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_full_name_en__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerOrgFunction') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_position__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_position__c desc');
            }
        }
        else if(sortByParam.sortBy == 'status') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by status__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by status__c desc');
            }
        }
        else if(sortByParam.sortBy == 'submittedDate') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by submitted_date__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by submitted_date__c desc');
            }
        }
        else {
            System.debug(query);
            CGReports = database.query(query + ' order by Running_No__c desc');
        }  
        
        if(CGReports.size() > 0) {
            
            Map<string,CG_DTO.UserDTO> userDTOs = CG_Global.assignAllToUserDTO();
            
            for(CG_Reporting__c CGReport : CGReports) {
                CG_DTO.ReportCOIInfoDTO ReportCOIInforDTO = assignToReportCOIInfoDTO(CGReport, userDTOs);
                ReportCOIInfoList.add(ReportCOIInforDTO);
            }
        }
        
        List<CG_DTO.ReportCOIInfoDTO> results = new List<CG_DTO.ReportCOIInfoDTO>();
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            integer totalSize = ReportCOIInfoList.size() - startIndex;
            
            for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                if (i < totalSize){
                    results.add(ReportCOIInfoList[startIndex + i]);
                }else{
                    break;
                }
            }  
        
        return results;
    }

    @RemoteAction
    public static CG_DTO.ReportCOIStatisticDTO GetReportCOIStatistics(CG_COI_Reporting.ReportCOISearchCriteria filter){
        
        ReportCOIStatistics = new CG_DTO.ReportCOIStatisticDTO();
             
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.COIReportType.COIAnnual), 
            											String.ValueOf(CG_Enum.COIReportType.COIIncident), 
            											String.ValueOf(CG_Enum.COIReportType.COINewEmployee) };
                                                                                                        
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                         
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
            
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        string query = '';
        query = 'select id, Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c, Status__c from CG_Reporting__c ' +
            	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED '; 
        	  
        string groupByQuery = '';
        groupByQuery = 'select Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c from CG_Reporting__c where  Type_Of_Report__c IN: typeOfReports  AND Status__c NOT IN: statuses AND ' +
            			'CreatedDate >=: SD AND CreatedDate <=: ED AND Owner_Function__c != \'\' ';
        
        boolean isFunctionFilter = false;
        
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType.toLowerCase() != 'all') {
            string typeOfReport = filter.reportType;
            
            if(typeOfReport == String.ValueOf(CG_Enum.COIReportType.COIIncident)) {
                statuses.add(String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit));
            }
            
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
            groupByQuery = groupByQuery + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
            groupByQuery = groupByQuery + ' AND Status__c =: status';
        }
        
        //filter.coiAnswer
        if(!String.isEmpty(filter.coiAnswer) && !String.isBlank(filter.coiAnswer) && filter.coiAnswer.toLowerCase() != 'all') {
            string coiAnswer = filter.coiAnswer;
            query = query + ' AND COI_Disclosure__c =: coiAnswer';
            groupByQuery = groupByQuery + ' AND COI_Disclosure__c =: coiAnswer';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
            groupByQuery = groupByQuery + ' AND Owner_Function__c =: functionName';
            isFunctionFilter = true;
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
            groupByQuery = groupByQuery + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
            groupByQuery = groupByQuery + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
            groupByQuery = groupByQuery + ' AND Owner_Unit__c =: unitName';
        }

		//Final query
		System.debug(query);
		CGReports = Database.query(query);  
           
        /* List<Id> CompanyIds = new List<Id>();
        List<SD_Company__c> Companies = new List<SD_Company__c>();
            
        if(filter.companyId != 'All' && !String.isEmpty(filter.companyId)) {
            if(filter.companyId.contains(',')) {
                CompanyIds = filter.companyId.split(',');
            }
            else {
                CompanyIds.add(filter.companyId);
            }
            
            Companies = [select id, name from SD_Company__c where Id IN: CompanyIds order by Order__c asc];
              
            if(Companies.size() > 0) {
                for(SD_Company__c Company : Companies) {
            		ReportCOIStatusSeries.categories.add(Company.Name);
                }
            }
        } */
         
        //Grouping By  
        if(CGReports.size() > 0) {
            
            ReportCOIStatistics.functions = new List<CG_DTO.ReportCOIStatisticFunctionDTO>();
            
            List<string> Functions = CGGlobal_GetFunctions(null);
            
            if(Functions.size() > 0) {
                
                integer total = 0;
                integer WaitingForSubmit = 0;
                integer WaitingSupervisor = 0;
                integer WaitingGLVP = 0;
                integer Success = 0;
                
                for(string currentFunction : Functions) {
                    
                    string finalQuery = '';
                    
                    if(!isFunctionFilter) {
                        finalQuery = groupByQuery + ' AND Owner_Function__c =: currentFunction group by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c order by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c asc';
                    }
                    else {
                        finalQuery = groupByQuery + ' group by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c order by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c asc';
                    }
                    
                    integer totalFunction = 0;
                    integer WaitingForSubmitFunction = 0;
                    integer WaitingSupervisorFunction = 0;
                    integer WaitingGLVPFunction = 0;
                    integer SuccessFunction = 0;
                    
                    CG_DTO.ReportCOIStatisticFunctionDTO func = new CG_DTO.ReportCOIStatisticFunctionDTO();
                    func.childFunctions = new List<CG_DTO.ReportCOIStatisticFunctionDTO>();
                    
                    CG_DTO.ReportCOIStatisticFunctionDTO dept = new CG_DTO.ReportCOIStatisticFunctionDTO();
                    CG_DTO.ReportCOIStatisticFunctionDTO sect = new CG_DTO.ReportCOIStatisticFunctionDTO();
                    CG_DTO.ReportCOIStatisticFunctionDTO addUnit = new CG_DTO.ReportCOIStatisticFunctionDTO();
                    
                    Set<string> existDepartments = new Set<string>();
                    Set<string> existSections = new Set<string>();
                    Set<string> existUnits = new Set<string>();
                    
                    boolean isFunctionFound = false;
                    
                    System.debug('currentFunction : ' + currentFunction);
                    
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
                        System.debug('department : ' + department);
                        if(!existDepartments.contains(department)) {
                            dept = new CG_DTO.ReportCOIStatisticFunctionDTO();
                            if(department != '' && department != null) {
                                dept.name = department;
                                dept.all = totalDepartment;
                                dept.waitingForSubmit = WaitingForSubmitDepartment;
                                dept.waitingSupervisor = WaitingSupervisorDepartment;
                                dept.waitingGLVP = WaitingGLVPDepartment;
                                dept.completed = SuccessDepartment;
                                dept.childFunctions = new List<CG_DTO.ReportCOIStatisticFunctionDTO>();
                                func.childFunctions.add(dept);
                            }
                            existDepartments.add(department);
                        }
                        
                        
                        //Section
                        if(!existSections.contains(section)) {
                            sect = new CG_DTO.ReportCOIStatisticFunctionDTO();
                            if(section != '' && section != null) {
                                sect.name = section;
                                sect.all = totalSection;
                                sect.waitingForSubmit = WaitingForSubmitSection;
                                sect.waitingSupervisor = WaitingSupervisorSection;
                                sect.waitingGLVP = WaitingGLVPSection;
                                sect.completed = SuccessSection;
                                sect.childFunctions = new List<CG_DTO.ReportCOIStatisticFunctionDTO>();
                                dept.childFunctions.add(sect);
                            }
                            existSections.add(section);
                        }
                        
                        //Unit
                        if(!existUnits.contains(unit)) {
                            addUnit = new CG_DTO.ReportCOIStatisticFunctionDTO();
                            if(unit != '' && unit != null) {
                                addUnit.name = unit;
                                addUnit.all = totalUnit;
                                addUnit.waitingForSubmit = WaitingForSubmitUnit;
                                addUnit.waitingSupervisor = WaitingSupervisorUnit;
                                addUnit.waitingGLVP = WaitingGLVPUnit;
                                addUnit.completed = SuccessUnit;
                                sect.childFunctions.add(addUnit);
                            }
                            existUnits.add(unit);
                        }
                
                        
                    }
                    
                    //Function
                    if(totalFunction > 0) {
                        func.name = currentFunction;
                        func.all = totalFunction;
                        func.waitingForSubmit = WaitingForSubmitFunction;
                        func.waitingSupervisor = WaitingSupervisorFunction;
                        func.waitingGLVP = WaitingGLVPFunction;
                        func.completed = SuccessFunction;
                        ReportCOIStatistics.functions.add(func);
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
                
                ReportCOIStatistics.total = new CG_DTO.ReportCOIStatisticFunctionTotalDTO();
                ReportCOIStatistics.total.all = CGReports.size();
                ReportCOIStatistics.total.waitingForSubmit = WaitingForSubmit;
                ReportCOIStatistics.total.waitingSupervisor = WaitingSupervisor;
                ReportCOIStatistics.total.waitingGLVP = WaitingGLVP;
                ReportCOIStatistics.total.completed = Success;
            }  
        }
        
        return ReportCOIStatistics;
    }

    @RemoteAction
    public static string ExportCOIAllExcel(CG_COI_Reporting.ReportCOISearchCriteria filter){
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CG_Report_Excel?';
        
        string exportAll = 'true';
        string reportName = 'COI';
        
        string startDate = filter.startDate.format('yyyy-MM-dd');
        string endDate = filter.endDate.addDays(1).format('yyyy-MM-dd');
        
        URL = URL + 'exportAll=' + exportAll + '&startDate=' + startDate +
              '&endDate=' + endDate + '&reportName=' + reportName + '&typeOfReport=all';
        
        return URL;
    }

    @RemoteAction
    public static string ExportCOITableExcel(CG_COI_Reporting.ReportCOISearchCriteria filter){
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CG_Report_Excel';
        
        string exportAll = 'false';
        string typeOfReport = String.ValueOf(filter.reportType);
        string status = String.ValueOf(filter.status);
        string startDate = filter.startDate.format('yyyy-MM-dd');
        string endDate = filter.endDate.addDays(1).format('yyyy-MM-dd');
        string coiAnswer = filter.coiAnswer;
        string company = filter.companyId;
        string function = filter.function;
        string department = filter.department;
        string section = filter.section;
        string unit = filter.unit;
        string reportName = 'COI';
        
        URL = URL + '?exportAll=' + exportAll + '&typeOfReport=' + typeOfReport + '&status=' + status + '&startDate=' + startDate +
              '&endDate=' + endDate + '&coiAnswer=' + coiAnswer + '&company=' + company + '&function=' + function + '&department=' + department +
              '&section=' + section + '&unit=' + unit + '&reportName=' + reportName;
        
        return URL;
    }
    
    
    //ManualReport RemoteAction
    @RemoteAction
    public static CG_DTO.ReportCGSummaryCountDTO GetReportCGSummaryCount(CG_Manual_Reporting.ReportCGSearchCriteria filter){
        
        ReportCGSummaryCount = new CG_DTO.ReportCGSummaryCountDTO();
        ReportCGSummaryCount.totalReport = 0;
        ReportCGSummaryCount.completeReport = 0;
        ReportCGSummaryCount.waitingForSubmitReport = 0;
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual), 
            											String.ValueOf(CG_Enum.CGReportType.CGManual), 
            											String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
           
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                                                          
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();                                                    
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, Status__c,' +
            				'OwnerId from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED '; 
        
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType.toLowerCase() != 'all') {
            string typeOfReport = filter.reportType;
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            if(status == String.ValueOf(CG_Enum.ApproverStatus.Submitted)) {
                status = String.ValueOf(CG_Enum.ReportStatus.Success);
            }
            query = query + ' AND Status__c =: status';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

		//Final query
		CGReports = Database.query(query); 
        
        if(CGReports.size() > 0) {
            
            integer totalReport = 0;
            
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                    ReportCGSummaryCount.completeReport += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                    ReportCGSummaryCount.waitingforSubmitReport += 1;
                    totalReport++;
                }
                
            }
            
            ReportCGSummaryCount.totalReport = totalReport;
        }
        
        return ReportCGSummaryCount;
    }
    
    @RemoteAction
    public static List<CG_DTO.ReportCGTypeRadialChartItemDTO> GetReportCGTypeRadialChart(CG_Manual_Reporting.ReportCGSearchCriteria filter){
        
        ReportCGTypeRadialChartItems = new List<CG_DTO.ReportCGTypeRadialChartItemDTO>();
        CG_DTO.ReportCGTypeRadialChartItemDTO item = new CG_DTO.ReportCGTypeRadialChartItemDTO();
        
        integer total = 0;
        integer annual = 0;
        integer manual = 0;
        integer newEmployee = 0;
              
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual), 
            											String.ValueOf(CG_Enum.CGReportType.CGManual), 
            											String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
          
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                                                                                                    
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();                                                    
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, Status__c,' +
            				'OwnerId from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED '; 
        
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType.toLowerCase() != 'all') {
            string typeOfReport = filter.reportType;
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            if(status == String.ValueOf(CG_Enum.ApproverStatus.Submitted)) {
                status = String.ValueOf(CG_Enum.ReportStatus.Success);
            }
            query = query + ' AND Status__c =: status';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

		//Final query
		CGReports = Database.query(query); 
        
        if(CGReports.size() > 0) {
            
            total = CGReports.size();
            
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
                    annual += 1;
                }
                else if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
                    manual += 1;
                }
                else if(CGReport.Type_Of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
                    newEmployee += 1;
                }
                
            }
            
            total = annual + manual + newEmployee;
        }
        
        item.type = 'CGAnnual';
        
        if(annual == 0) {
            item.percent = 0;
        }
        else {
        	item.percent = (annual * 100) / total;
        }
        
        item.color = '#82C177';
        item.count = annual;
        ReportCGTypeRadialChartItems.add(item);
        
        item = new CG_DTO.ReportCGTypeRadialChartItemDTO();
        item.type = 'CGManual';
        
        if(manual == 0) {
            item.percent = 0;
        }
        else {
        	item.percent = (manual * 100) / total;
        }
        
        item.color = '#F27D60';
        item.count = manual;
        ReportCGTypeRadialChartItems.add(item);
        
        item = new CG_DTO.ReportCGTypeRadialChartItemDTO();
        item.type = 'CGNewEmployee';
        
        if(newEmployee == 0) {
            item.percent = 0;
        }
        else {
        	item.percent = (newEmployee * 100) / total;
        }
        
        item.color = '#476DA0';
        item.count = newEmployee;
        ReportCGTypeRadialChartItems.add(item);
        
        return ReportCGTypeRadialChartItems;
    }
    
    @RemoteAction
    public static List<CG_DTO.ReportCGStatusSeriesDTO> GetReportCGStatusSeriesChart(
        CG_Manual_Reporting.ReportCGSearchCriteria filter, 
        //Company, Function, Department, Section
        string groupingBy){
            
        ReportCGStatusSeries = new List<CG_DTO.ReportCGStatusSeriesDTO>();
              
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual), 
            											String.ValueOf(CG_Enum.CGReportType.CGManual), 
            											String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
         
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                                                        
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
            
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        string query = '';
        query = 'select id, Owner_Function__c, Owner_Department__c, Status__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED AND Owner_Function__c != \'\' ';
        	 
        if(groupingBy == 'Company') {
            query = 'select id, Owner_Function__c, Owner_Department__c, Status__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED AND Owner_Function__c != \'\' ';
        }
        else if(groupingBy == 'Function') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED AND
            query = 'select id, Owner_Function__c, Owner_Department__c, Status__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED AND Owner_Function__c != \'\' ';
        }
        else if(groupingBy == 'Department') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED AND
            query = 'select id, Owner_Department__c, Owner_Section__c, Status__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED AND Owner_Department__c != \'\' ';
        }
        else if(groupingBy == 'Section') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED AND
            query = 'select id, Owner_Section__c, Owner_Unit__c, Status__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED AND Owner_Section__c != \'\' ';
        }
            
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType != 'All') {
            string typeOfReport = filter.reportType;
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status != 'All') {
            string status = filter.status;
            if(status == String.ValueOf(CG_Enum.ApproverStatus.Submitted)) {
                status = String.ValueOf(CG_Enum.ReportStatus.Success);
            }
            query = query + ' AND Status__c =: status';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId != 'All') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function != 'All') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department != 'All') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section != 'All') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit != 'All') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

        //After Filter then group by
        string groupByQuery = '';
        if(groupingBy == 'Company') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Function__c, Owner_Department__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Function__c != \'\' ';
        }
        else if(groupingBy == 'Function') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Function__c, Owner_Department__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Function__c != \'\' ';
        }
        else if(groupingBy == 'Department') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Department__c, Owner_Section__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Department__c != \'\' ';
        }
        else if(groupingBy == 'Section') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Section__c, Owner_Unit__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Section__c != \'\' ';
        }
            
		//Final query
		System.debug(query);
		CGReports = Database.query(query);  
           
        /* List<Id> CompanyIds = new List<Id>();
        List<SD_Company__c> Companies = new List<SD_Company__c>();
            
        if(filter.companyId != 'All' && !String.isEmpty(filter.companyId)) {
            if(filter.companyId.contains(',')) {
                CompanyIds = filter.companyId.split(',');
            }
            else {
                CompanyIds.add(filter.companyId);
            }
            
            Companies = [select id, name from SD_Company__c where Id IN: CompanyIds order by Order__c asc];
              
            if(Companies.size() > 0) {
                for(SD_Company__c Company : Companies) {
            		ReportCOIStatusSeries.categories.add(Company.Name);
                }
            }
        } */
        
        CG_DTO.ReportCGStatusSeriesDTO ReportCGStatus = new CG_DTO.ReportCGStatusSeriesDTO();
        ReportCGStatus.series = new List<CG_DTO.ReportCGStatusSerieItemDTO>();
        CG_DTO.ReportCGStatusSerieItemDTO serie = new CG_DTO.ReportCGStatusSerieItemDTO();
        
        //Grouping By   
        if(CGReports.size() > 0) {
            
            List<AggregateResult> AggregateResults = new List<AggregateResult>();
            
            //Company
            if(groupingBy == 'Company') {
                
                List<string> Functions = CGGlobal_GetFunctions(null);
            
                if(Functions.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer functionCount = 0;
                    
                    for(string currentFunction : Functions) {
                        
                        ReportCGStatus = new CG_DTO.ReportCGStatusSeriesDTO();
        				ReportCGStatus.series = new List<CG_DTO.ReportCGStatusSerieItemDTO>();    
                        ReportCGStatus.category = currentFunction;
                        
                        System.debug(currentFunction);
                        
                        //string finalQuery = groupByQuery + ' AND Owner_Function__c =: currentFunction group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                        
                        integer totalFunction = 0;
                        
                        for(AggregateResult AR : AggregateResults) {
                            
                            if(AR.get('Owner_Function__c') == currentFunction) {
                                
                                totalFunction++;
                            
                                integer WaitingForSubmit = 0;
                                integer Success = 0;
                                
                                string department = '';
                                
                                if(AR.get('Owner_Department__c') != null) {
                                    department = AR.get('Owner_Department__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Department__c == department) {
                                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                            WaitingForSubmit++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                            Success++;
                                        }
                                    }
                                }
                                
                                System.debug(department + ' : ' + WaitingForSubmit + ' : ' + Success + ' : ');
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportCGStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, functionCount);
                                    serie.color = '#F27D60';
                                    serie.stack = department;
                                    ReportCGStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportCGStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, functionCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = department;
                                    ReportCGStatus.series.add(serie);
                                }
                            }
                        }
                        
                        if(totalFunction > 0) {
                            functionCount++;
                            if(ReportCGStatus.series.size() > 0) {
                        		ReportCGStatusSeries.add(ReportCGStatus);
                            }
                        }
                        
                    }
                }
            }
            //Function
            else if(groupingBy == 'Function') {
                
                List<string> Functions = new List<string>(); 
                
            	if(!string.isEmpty(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
                	Functions = CGGlobal_GetFunctions(filter.companyId);
                }
                else {
                    Functions = CGGlobal_GetFunctions(null);
                }
                
                if(Functions.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer functionCount = 0;
                    
                    for(string currentFunction : Functions) {
                        
                        ReportCGStatus = new CG_DTO.ReportCGStatusSeriesDTO();
        				ReportCGStatus.series = new List<CG_DTO.ReportCGStatusSerieItemDTO>();    
                        ReportCGStatus.category = currentFunction;
                        
                        System.debug(currentFunction);
                        
                        //string finalQuery = groupByQuery + ' AND Owner_Function__c =: currentFunction group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                        
                        integer totalFunction = 0;
                        
                        for(AggregateResult AR : AggregateResults) {
                            
                            if(AR.get('Owner_Function__c') == currentFunction) {
                                totalFunction++;
                            
                                integer WaitingForSubmit = 0;
                                integer Success = 0;
                                
                                string department = '';
                                
                                if(AR.get('Owner_Department__c') != null) {
                                    department = AR.get('Owner_Department__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Department__c == department) {
                                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                            WaitingForSubmit++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                            Success++;
                                        }
                                    }
                                }
                                
                                System.debug(department + ' : ' + WaitingForSubmit + ' : ' + Success);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportCGStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data.add(WaitingForSubmit);
                                    serie.color = '#F27D60';
                                    //serie.id = 'WaitingForSubmit';
                                    //serie.linkedTo = 'WaitingForSubmit';
                                    serie.stack = department;
                                    ReportCGStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportCGStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data.add(Success);
                                    serie.color = '#1ABC9D';
                                    //serie.id = 'Success';
                                    //serie.linkedTo = 'Success';
                                    serie.stack = department;
                                    ReportCGStatus.series.add(serie);
                                }
                            }
                        }
                        
                        if(totalFunction > 0) {
                            functionCount++;
                            if(ReportCGStatus.series.size() > 0) {
                        		ReportCGStatusSeries.add(ReportCGStatus);
                            }
                        }
                        
                    }
                }
            }
            //Department
            else if(groupingBy == 'Department') {
                
                List<string> Departments = new List<string>(); 
                
                if(!string.isEmpty(filter.function) &&filter.function.toLowerCase() != 'all') {
                    Departments = CGGlobal_GetDepartments(filter.function);
                }
                else {
                    Departments = CGGlobal_GetDepartments(null);
                }
                
                if(Departments.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Department__c, Owner_Section__c order by Owner_Department__c, Owner_Section__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer departmentCount = 0;
                                        
                    for(string currentDepartment : Departments) {
                        
                        ReportCGStatus = new CG_DTO.ReportCGStatusSeriesDTO();
        				ReportCGStatus.series = new List<CG_DTO.ReportCGStatusSerieItemDTO>();    
                        ReportCGStatus.category = currentDepartment;
                        
                        System.debug(currentDepartment);
                        
                        integer totalDepartment = 0;
                        
                        for(AggregateResult AR : database.query(finalQuery)) {
                            
                            if(AR.get('Owner_Department__c') == currentDepartment) {
                                totalDepartment++;
                            
                                integer WaitingForSubmit = 0;
                                integer Success = 0;
                                
                                string section = '';
                                
                                if(AR.get('Owner_Section__c') != null) {
                                    section = AR.get('Owner_Section__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Section__c == section) {
                                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                            WaitingForSubmit++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                            Success++;
                                        }
                                    }
                                }
                                
                                System.debug(section + ' : ' + WaitingForSubmit + ' : ' + Success);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportCGStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, departmentCount);
                                    serie.color = '#F27D60';
                                    serie.stack = section;
                                    ReportCGStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportCGStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, departmentCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = section;
                                    ReportCGStatus.series.add(serie);
                                }
                            }
                        }
                        
                        if(totalDepartment > 0) {
                        	departmentCount++;
                            if(ReportCGStatus.series.size() > 0) {
                        		ReportCGStatusSeries.add(ReportCGStatus);
                            }
                        }
                        
                    }
                }
            }
            //Section
            else if(groupingBy == 'Section') {
                
                List<string> Sections = new List<string>();
                
                if(!string.isEmpty(filter.department) &&filter.department.toLowerCase() != 'all') {
                	Sections = CGGlobal_GetSections(filter.department);
                }
                else {
                    Sections = CGGlobal_GetSections(null);
                }
                
                if(Sections.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Section__c, Owner_Unit__c order by Owner_Section__c, Owner_Unit__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer sectionCount = 0;
                    
                    for(string currentSection : Sections) {
                        
                        ReportCGStatus = new CG_DTO.ReportCGStatusSeriesDTO();
        				ReportCGStatus.series = new List<CG_DTO.ReportCGStatusSerieItemDTO>();    
                        ReportCGStatus.category = currentSection;
                        
                        System.debug(currentSection);
                        
                        integer totalSection = 0;
                        
                        for(AggregateResult AR : AggregateResults) {
                            
                            if(AR.get('Owner_Section__c') == currentSection) {
                                totalSection++;
                            
                                integer WaitingForSubmit = 0;
                                integer Success = 0;
                                
                                string unit = '';
                                
                                if(AR.get('Owner_Unit__c') != null) {
                                    unit = AR.get('Owner_Unit__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Unit__c == unit) {
                                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                            WaitingForSubmit++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                            Success++;
                                        }
                                    }
                                }
                                
                                System.debug(unit + ' : ' + WaitingForSubmit + ' : ' + Success);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportCGStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, sectionCount);
                                    serie.color = '#F27D60';
                                    serie.stack = unit;
                                    ReportCGStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportCGStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, sectionCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = unit;
                                    ReportCGStatus.series.add(serie);
                                }
                            }
                        }
                        
                        if(totalSection > 0) {
                        	sectionCount++;
                            if(ReportCGStatus.series.size() > 0) {
                        		ReportCGStatusSeries.add(ReportCGStatus);
                            }
                        }
                    }
                }
            }
        }
        
        return ReportCGStatusSeries;
    }

    @RemoteAction
    public static List<CG_DTO.ReportCGInfoDTO> GetReportCGInfoList(CG_Manual_Reporting.ReportCGSearchCriteria filter,
    //reportNumber, reportType, ownerFullName, ownerOrgFunction, reportStatus, submittedDate
    CG_Global.SortByParam sortByParam,
    CG_Global.PageParam pageParam) {
        
        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual), 
            											String.ValueOf(CG_Enum.CGReportType.CGManual), 
            											String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
                   
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
        
        ReportCGInfoList = new List<CG_DTO.ReportCGInfoDTO>();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
                                                         
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, Reported_By_Company_EN__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c , Status__c, Supervisor_Approver_Status__c, ' +
            				'OwnerId, Owner_Position__c, Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: Statuses AND CreatedDate >=: SD AND CreatedDate <=: ED'; 
        
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType.toLowerCase() != 'all') {
            string typeOfReport = filter.reportType;
            
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
            
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            if(status == String.ValueOf(CG_Enum.ApproverStatus.Submitted)) {
                status = String.ValueOf(CG_Enum.ReportStatus.Success);
            }
            query = query + ' AND Status__c =: status';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
        }

        //sortBy
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
        else if(sortByParam.sortBy == 'owner') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_full_name_en__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_full_name_en__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerOrgFunction') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_position__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_position__c desc');
            }
        }
        else if(sortByParam.sortBy == 'submittedDate') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by submitted_date__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by submitted_date__c desc');
            }
        }
        else {
            CGReports = database.query(query + ' order by Running_No__c desc');
        }  
        
        if(CGReports.size() > 0) {
            
            Map<string,CG_DTO.UserDTO> userDTOs = CG_Global.assignAllToUserDTO();
            
            for(CG_Reporting__c CGReport : CGReports) {
                CG_DTO.ReportCGInfoDTO ReportCGInforDTO = assignToReportCGInfoDTO(CGReport, userDTOs);
                ReportCGInfoList.add(ReportCGInforDTO);
            }
        }
        
        List<CG_DTO.ReportCGInfoDTO> results = new List<CG_DTO.ReportCGInfoDTO>();
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            integer totalSize = ReportCGInfoList.size() - startIndex;
            
            for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                if (i < totalSize){
                    results.add(ReportCGInfoList[startIndex + i]);
                }else{
                    break;
                }
            }  
        
        return results;
    }

    @RemoteAction
    public static CG_DTO.ReportCGStatisticDTO GetReportCGStatistics(CG_Manual_Reporting.ReportCGSearchCriteria filter){
        
        ReportCGStatistics = new CG_DTO.ReportCGStatisticDTO();
             
        List<string> typeOfReports = new List<string> { String.ValueOf(CG_Enum.CGReportType.CGAnnual), 
            											String.ValueOf(CG_Enum.CGReportType.CGManual), 
            											String.ValueOf(CG_Enum.CGReportType.CGNewEmployee) };
                            
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                                                        
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
            
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        string query = '';
        query = 'select id, Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c, Status__c from CG_Reporting__c ' +
            	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED '; 
        	  
        string groupByQuery = '';
        groupByQuery = 'select Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c from CG_Reporting__c where  Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND ' +
            			'CreatedDate >=: SD AND CreatedDate <=: ED AND Owner_Function__c != \'\' ';
        
        boolean isFunctionFilter = false;
        
        //filter.reportType
        if(!String.isEmpty(filter.reportType) && !String.isBlank(filter.reportType) && filter.reportType != 'All') {
            string typeOfReport = filter.reportType;
            query = query + ' AND Type_Of_Report__c =: typeOfReport';
            groupByQuery = groupByQuery + ' AND Type_Of_Report__c =: typeOfReport';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status != 'All') {
            string status = filter.status;
            if(status == String.ValueOf(CG_Enum.ApproverStatus.Submitted)) {
                status = String.ValueOf(CG_Enum.ReportStatus.Success);
            }
            query = query + ' AND Status__c =: status';
            groupByQuery = groupByQuery + ' AND Status__c =: status';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId != 'All') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function != 'All') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
            groupByQuery = groupByQuery + ' AND Owner_Function__c =: functionName';
            isFunctionFilter = true;
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department != 'All') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
            groupByQuery = groupByQuery + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section != 'All') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
            groupByQuery = groupByQuery + ' AND Owner_Section__c =: sectionName';
        }
        
        //filter.unit
        if(!String.isEmpty(filter.unit) && !String.isBlank(filter.unit) && filter.unit != 'All') {
            string unitName = filter.unit;
            query = query + ' AND Owner_Unit__c =: unitName';
            groupByQuery = groupByQuery + ' AND Owner_Unit__c =: unitName';
        }

		//Final query
		System.debug(query);
		CGReports = Database.query(query);  
           
        /* List<Id> CompanyIds = new List<Id>();
        List<SD_Company__c> Companies = new List<SD_Company__c>();
            
        if(filter.companyId != 'All' && !String.isEmpty(filter.companyId)) {
            if(filter.companyId.contains(',')) {
                CompanyIds = filter.companyId.split(',');
            }
            else {
                CompanyIds.add(filter.companyId);
            }
            
            Companies = [select id, name from SD_Company__c where Id IN: CompanyIds order by Order__c asc];
              
            if(Companies.size() > 0) {
                for(SD_Company__c Company : Companies) {
            		ReportCOIStatusSeries.categories.add(Company.Name);
                }
            }
        } */
         
        //Grouping By   
        if(CGReports.size() > 0) {
            
            ReportCGStatistics.functions = new List<CG_DTO.ReportCGStatisticFunctionDTO>();
            List<string> Functions = CGGlobal_GetFunctions(null);
            
            if(Functions.size() > 0) {
                
                integer total = 0;
                integer WaitingForSubmit = 0;
                integer Success = 0;
                
                for(string currentFunction : Functions) {
                    
                    string finalQuery = '';
                    
                    if(!isFunctionFilter) {
                        finalQuery = groupByQuery + ' AND Owner_Function__c =: currentFunction group by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c order by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c asc';
                    }
                    else {
                        finalQuery = groupByQuery + ' group by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c order by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c asc';
                    }
                    
                    integer totalFunction = 0;
                    integer WaitingForSubmitFunction = 0;
                    integer SuccessFunction = 0;
                    
                    CG_DTO.ReportCGStatisticFunctionDTO func = new CG_DTO.ReportCGStatisticFunctionDTO();
                    func.childFunctions = new List<CG_DTO.ReportCGStatisticFunctionDTO>();
                    
                    CG_DTO.ReportCGStatisticFunctionDTO dept = new CG_DTO.ReportCGStatisticFunctionDTO();
                    CG_DTO.ReportCGStatisticFunctionDTO sect = new CG_DTO.ReportCGStatisticFunctionDTO();
                    CG_DTO.ReportCGStatisticFunctionDTO addUnit = new CG_DTO.ReportCGStatisticFunctionDTO();
                    
                    Set<string> existDepartments = new Set<string>();
                    Set<string> existSections = new Set<string>();
                    Set<string> existUnits = new Set<string>();
                    
                    boolean isFunctionFound = false;
                    
                    for(AggregateResult AR : database.query(finalQuery)) {
                        
                        integer totalDepartment = 0;
                        integer WaitingForSubmitDepartment = 0;
                        integer SuccessDepartment = 0;
                        
                        integer totalSection = 0;
                        integer WaitingForSubmitSection = 0;
                        integer SuccessSection = 0;
                        
                        integer totalUnit = 0;
                        integer WaitingForSubmitUnit = 0;
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
                        		System.debug(totalFunction);
                                totalFunction++;
                                
                                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                    WaitingForSubmitFunction++;
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
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                    SuccessUnit++;
                                }
                            }
                            
                        }
                        
                        isFunctionFound = true;
                        
                        //Department
                        if(!existDepartments.contains(department)) {
                            dept = new CG_DTO.ReportCGStatisticFunctionDTO();
                            if(department != '' && department != null) {
                                dept.name = department;
                                dept.all = totalDepartment;
                                dept.waitingForSubmit = WaitingForSubmitDepartment;
                                dept.completed = SuccessDepartment;
                                dept.childFunctions = new List<CG_DTO.ReportCGStatisticFunctionDTO>();
                                func.childFunctions.add(dept);
                            }
                            existDepartments.add(department);
                        }
                        
                        
                        //Section
                        if(!existSections.contains(section)) {
                            sect = new CG_DTO.ReportCGStatisticFunctionDTO();
                            if(section != '' && section != null) {
                                sect.name = section;
                                sect.all = totalSection;
                                sect.waitingForSubmit = WaitingForSubmitSection;
                                sect.completed = SuccessSection;
                                sect.childFunctions = new List<CG_DTO.ReportCGStatisticFunctionDTO>();
                                dept.childFunctions.add(sect);
                            }
                            existSections.add(section);
                        }
                        
                        //Unit
                        if(!existUnits.contains(unit)) {
                            addUnit = new CG_DTO.ReportCGStatisticFunctionDTO();
                            if(unit != '' && unit != null) {
                                addUnit.name = unit;
                                addUnit.all = totalUnit;
                                addUnit.waitingForSubmit = WaitingForSubmitUnit;
                                addUnit.completed = SuccessUnit;
                                sect.childFunctions.add(addUnit);
                            }
                            existUnits.add(unit);
                        }
                
                        
                    }
                    
                    //Function
                    if(totalFunction > 0) {
                        func.name = currentFunction;
                        func.all = totalFunction;
                        func.waitingForSubmit = WaitingForSubmitFunction;
                        func.completed = SuccessFunction;
                        ReportCGStatistics.functions.add(func);
                    }
                    
                }
                
                //Total
                if(CGReports.size() > 0) {
                    for(CG_Reporting__c CGReport : CGReports) {
                            
                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                            WaitingForSubmit++;
                        }
                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                            Success++;
                        }
                        
                    }
                }
                
                ReportCGStatistics.total = new CG_DTO.ReportCGStatisticFunctionTotalDTO();
                ReportCGStatistics.total.all = CGReports.size();
                ReportCGStatistics.total.waitingForSubmit = WaitingForSubmit;
                ReportCGStatistics.total.completed = Success;
            }  
        }
        
        return ReportCGStatistics;
    }
    
    @RemoteAction
    public static string ExportCGAllExcel(CG_Manual_Reporting.ReportCGSearchCriteria filter){
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CG_Report_Excel?';
        
        string exportAll = 'true';
        string reportName = 'CG';
        
        string startDate = filter.startDate.format('yyyy-MM-dd');
        string endDate = filter.endDate.addDays(1).format('yyyy-MM-dd');
        
        URL = URL + 'exportAll=' + exportAll + '&startDate=' + startDate +
              '&endDate=' + endDate + '&reportName=' + reportName + '&typeOfReport=all';
        
        return URL;
    }

    @RemoteAction
    public static string ExportCGTableExcel(CG_Manual_Reporting.ReportCGSearchCriteria filter){
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CG_Report_Excel';
        
        string exportAll = 'false';
        string typeOfReport = String.ValueOf(filter.reportType);
        string status = String.ValueOf(filter.status);
        string startDate = filter.startDate.format('yyyy-MM-dd');
        string endDate = filter.endDate.addDays(1).format('yyyy-MM-dd');
        string company = filter.companyId;
        string function = filter.function;
        string department = filter.department;
        string section = filter.section;
        string unit = filter.unit;
        string reportName = 'CG';
        
        URL = URL + '?exportAll=' + exportAll + '&typeOfReport=' + typeOfReport + '&status=' + status + '&startDate=' + startDate +
              '&endDate=' + endDate + '&company=' + company + '&function=' + function + '&department=' + department +
              '&section=' + section + '&unit=' + unit + '&reportName=' + reportName;
        
        return URL;
    }
    
    //GiftRegistration RemoteAction
    @RemoteAction
    public static CG_DTO.ReportGiftSummaryCountDTO GetReportGiftSummaryCount(CG_Gift_Reporting.ReportGiftSearchCriteria filter){
        
        ReportGiftSummaryCount = new CG_DTO.ReportGiftSummaryCountDTO();
        ReportGiftSummaryCount.totalReport = 0;
        ReportGiftSummaryCount.completeReport = 0;
        ReportGiftSummaryCount.waitingSupervisor = 0;
        ReportGiftSummaryCount.waitingGLGC = 0;
        ReportGiftSummaryCount.waitingGLVP = 0;
        
        List<string> typeOfReports = new List<string> { 'GiftRegistration' };
                                                           
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
          
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
            
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c, ' +
                        'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, ' +
                        'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, COI_Agree__c , Status__c, ' +
                        'Status_JSON__c, COI_Disclosure__c, IsAcknowledge__c, OwnerId from CG_Reporting__c ' +
                        'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED ';
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status != 'All') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
            
        //filter.giftStatus
        if(!String.isEmpty(filter.giftStatus) && !String.isBlank(filter.giftStatus) && filter.giftStatus != 'All') {
            string giftStatus = filter.giftStatus;
            query = query + ' AND Gift_Status__c =: giftStatus';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId != 'All') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function != 'All') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department != 'All') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section != 'All') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
		//Final query
		CGReports = Database.query(query); 
        
        if(CGReports.size() > 0) {
            
            integer totalReport = 0;
            //ReportGiftSummaryCount.totalReport = CGReports.size();
            
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                    ReportGiftSummaryCount.completeReport += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                    ReportGiftSummaryCount.waitingSupervisor += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                    ReportGiftSummaryCount.waitingGLGC += 1;
                    totalReport++;
                }
                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                    ReportGiftSummaryCount.waitingGLVP += 1;
                    totalReport++;
                }
                
            }
            
            ReportGiftSummaryCount.totalReport = totalReport;
        }
        
        return ReportGiftSummaryCount;
    }
    
    @RemoteAction
    public static List<CG_DTO.ReportGiftStatusSeriesDTO> GetReportGiftStatusSeriesChart(
        CG_Gift_Reporting.ReportGiftSearchCriteria filter, 
        //Company, Function, Department, Section
        string groupingBy){
            
        ReportGiftStatusSeries = new List<CG_DTO.ReportGiftStatusSeriesDTO>();
              
        List<string> typeOfReports = new List<string> { 'GiftRegistration' };
                         
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
            
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
        
        string query = '';
        query = 'select id, Owner_Function__c, Owner_Department__c, Status__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' ';  
        	 
        if(groupingBy == 'Company') {
            query = 'select id, Owner_Function__c, Owner_Department__c, Status__c from CG_Reporting__c ' +
            		'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED';
        }
        else if(groupingBy == 'Function') {
            query = 'select id, Owner_Function__c, Owner_Department__c, Status__c from CG_Reporting__c ' +
                	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED';
        }
        else if(groupingBy == 'Department') {
            query = 'select Owner_Department__c, Owner_Section__c, Status__c from CG_Reporting__c ' + 
                	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND AND Owner_Department__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED';
        }
        else if(groupingBy == 'Section') {
            query = 'select Owner_Section__c, Owner_Unit__c, Status__c from CG_Reporting__c ' +
                	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Section__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED';
        }
           
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status != 'All') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
            
        //filter.giftStatus
        if(!String.isEmpty(filter.giftStatus) && !String.isBlank(filter.giftStatus) && filter.giftStatus != 'All') {
            string giftStatus = filter.giftStatus;
            query = query + ' AND Gift_Status__c =: giftStatus';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId != 'All') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function != 'All') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department != 'All') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section != 'All') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //After Filter then group by
        string groupByQuery = '';
        if(groupingBy == 'Company') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Function__c, Owner_Department__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Function__c != \'\' ';
        }
        else if(groupingBy == 'Function') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Function__c, Owner_Department__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Function__c != \'\' ';
        }
        else if(groupingBy == 'Department') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
            groupByQuery = 'select Owner_Department__c, Owner_Section__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Department__c != \'\' ';
        }
        else if(groupingBy == 'Section') {
            //Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED
        	groupByQuery = 'select Owner_Section__c, Owner_Unit__c from CG_Reporting__c where Type_Of_Report__c IN: typeOfReports AND Owner_Section__c != \'\' ';
        }
            
		//Final query
		CGReports = Database.query(query);  
           
        /* List<Id> CompanyIds = new List<Id>();
        List<SD_Company__c> Companies = new List<SD_Company__c>();
            
        if(filter.companyId != 'All' && !String.isEmpty(filter.companyId)) {
            if(filter.companyId.contains(',')) {
                CompanyIds = filter.companyId.split(',');
            }
            else {
                CompanyIds.add(filter.companyId);
            }
            
            Companies = [select id, name from SD_Company__c where Id IN: CompanyIds order by Order__c asc];
              
            if(Companies.size() > 0) {
                for(SD_Company__c Company : Companies) {
            		ReportCOIStatusSeries.categories.add(Company.Name);
                }
            }
        } */
           
        CG_DTO.ReportGiftStatusSeriesDTO ReportGiftStatus = new CG_DTO.ReportGiftStatusSeriesDTO();
        ReportGiftStatus.series = new List<CG_DTO.ReportGiftStatusSerieItemDTO>();
        CG_DTO.ReportGiftStatusSerieItemDTO serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
            
        //Grouping By   
        if(CGReports.size() > 0) {
            
            List<AggregateResult> AggregateResults = new List<AggregateResult>();
            
            //Company
            if(groupingBy == 'Company') {
                
                List<string> Functions = CGGlobal_GetFunctions(null);
            
                if(Functions.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer functionCount = 0;
                    
                    for(string currentFunction : Functions) {
                        
                        ReportGiftStatus = new CG_DTO.ReportGiftStatusSeriesDTO();
        				ReportGiftStatus.series = new List<CG_DTO.ReportGiftStatusSerieItemDTO>();    
                        ReportGiftStatus.category = currentFunction;
                        
                        System.debug(currentFunction);
                        
                        integer totalFunction = 0;
                        
                        for(AggregateResult AR : AggregateResults) {
                            
                            if(AR.get('Owner_Function__c') == currentFunction) {
                                
                                totalFunction++;
                            
                                integer WaitingForSubmit = 0;
                                integer WaitingSupervisor = 0;
                                integer WaitingGLVP = 0;
                                integer Success = 0;
                                integer Rejected = 0;
                                
                                string department = '';
                                
                                if(AR.get('Owner_Department__c') != null) {
                                    department = AR.get('Owner_Department__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Department__c == department) {
                                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                            WaitingForSubmit++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                            WaitingSupervisor++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                                            WaitingGLVP++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                                            WaitingGLVP++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                            Success++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                                            Rejected++;
                                        }
                                    }
                                }
                                
                                System.debug(department + ' : ' + WaitingForSubmit + ' : ' + WaitingSupervisor + ' : ' + WaitingGLVP + ' : ' + Success + ' : ' + Rejected);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, functionCount);
                                    serie.color = '#F27D60';
                                    serie.stack = department;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(WaitingSupervisor > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingSupervisor';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingSupervisor, functionCount);
                                    serie.color = '#706DB6';
                                    serie.stack = department;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(WaitingGLVP > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingGLVP';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingGLVP, functionCount);
                                    serie.color = '#1FA4CE';
                                    serie.stack = department;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, functionCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = department;
                                    ReportGiftStatus.series.add(serie);
                                }
                            }
                        }
                        
                        if(totalFunction > 0) {
                        	functionCount++;
                            if(ReportGiftStatus.series.size() > 0) {
                        		ReportGiftStatusSeries.add(ReportGiftStatus);
                            }
                        }
                        
                    }
                }
            }
            //Function
            else if(groupingBy == 'Function') {
                
                List<string> Functions = new List<string>(); 
                
            	if(!string.isEmpty(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
                	Functions = CGGlobal_GetFunctions(filter.companyId);
                }
                else {
                    Functions = CGGlobal_GetFunctions(null);
                }
                
                if(Functions.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Function__c, Owner_Department__c order by Owner_Function__c, Owner_Department__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer functionCount = 0;
                    
                    for(string currentFunction : Functions) {
                        
                        ReportGiftStatus = new CG_DTO.ReportGiftStatusSeriesDTO();
        				ReportGiftStatus.series = new List<CG_DTO.ReportGiftStatusSerieItemDTO>();    
                        ReportGiftStatus.category = currentFunction;
                        
                        System.debug(currentFunction);
                        
                        integer totalFunction = 0;
                        
                        for(AggregateResult AR : AggregateResults) {
                            
                            if(AR.get('Owner_Function__c') == currentFunction) {
                                totalFunction++;
                            
                                integer WaitingForSubmit = 0;
                                integer WaitingSupervisor = 0;
                                integer WaitingGLVP = 0;
                                integer Success = 0;
                                integer Rejected = 0;
                                
                                string department = '';
                                
                                if(AR.get('Owner_Department__c') != null) {
                                    department = AR.get('Owner_Department__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Department__c == department) {
                                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                            WaitingForSubmit++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                            WaitingSupervisor++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                                            WaitingGLVP++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                                            WaitingGLVP++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                            Success++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                                            Rejected++;
                                        }
                                    }
                                }
                                
                                System.debug(department + ' : ' + WaitingForSubmit + ' : ' + WaitingSupervisor + ' : ' + WaitingGLVP + ' : ' + Success + ' : ' + Rejected);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, functionCount);
                                    serie.color = '#F27D60';
                                    serie.stack = department;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(WaitingSupervisor > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingSupervisor';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingSupervisor, functionCount);
                                    serie.color = '#706DB6';
                                    serie.stack = department;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(WaitingGLVP > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingGLVP';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingGLVP, functionCount);
                                    serie.color = '#1FA4CE';
                                    serie.stack = department;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, functionCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = department;
                                    ReportGiftStatus.series.add(serie);
                                }
                            }
                        }
                        
                        if(totalFunction > 0) {
                        	functionCount++;
                            if(ReportGiftStatus.series.size() > 0) {
                        		ReportGiftStatusSeries.add(ReportGiftStatus);
                            }
                        }
                        
                    }
                }
            }
            //Department
            else if(groupingBy == 'Department') {
                
                List<string> Departments = new List<string>(); 
                
                if(!string.isEmpty(filter.function) &&filter.function.toLowerCase() != 'all') {
                    Departments = CGGlobal_GetDepartments(filter.function);
                }
                else {
                    Departments = CGGlobal_GetDepartments(null);
                }
                
                if(Departments.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Department__c, Owner_Section__c order by Owner_Department__c, Owner_Section__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer departmentCount = 0;
                    
                    for(string currentDepartment : Departments) {
                        
                        ReportGiftStatus = new CG_DTO.ReportGiftStatusSeriesDTO();
        				ReportGiftStatus.series = new List<CG_DTO.ReportGiftStatusSerieItemDTO>();    
                        ReportGiftStatus.category = currentDepartment;
                        
                        System.debug(currentDepartment);
                        
                        integer totalDepartment = 0;
                        
                        for(AggregateResult AR : database.query(finalQuery)) {
                            
                            if(AR.get('Owner_Department__c') == currentDepartment) {
                                
                                totalDepartment++;
                            
                                integer WaitingForSubmit = 0;
                                integer WaitingSupervisor = 0;
                                integer WaitingGLVP = 0;
                                integer Success = 0;
                                integer Rejected = 0;
                                
                                string section = '';
                                
                                if(AR.get('Owner_Section__c') != null) {
                                    section = AR.get('Owner_Section__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Section__c == section) {
                                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                            WaitingForSubmit++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                            WaitingSupervisor++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                                            WaitingGLVP++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                                            WaitingGLVP++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                            Success++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                                            Rejected++;
                                        }
                                    }
                                }
                                
                                System.debug(section + ' : ' + WaitingForSubmit + ' : ' + WaitingSupervisor + ' : ' + WaitingGLVP + ' : ' + Success + ' : ' + Rejected);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, departmentCount);
                                    serie.color = '#F27D60';
                                    serie.stack = section;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(WaitingSupervisor > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingSupervisor';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingSupervisor, departmentCount);
                                    serie.color = '#706DB6';
                                    serie.stack = section;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(WaitingGLVP > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingGLVP';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingGLVP, departmentCount);
                                    serie.color = '#1FA4CE';
                                    serie.stack = section;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, departmentCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = section;
                                    ReportGiftStatus.series.add(serie);
                                }
                            }
                        }
                        
                        if(totalDepartment > 0) {
                        	departmentCount++;
                            if(ReportGiftStatus.series.size() > 0) {
                        		ReportGiftStatusSeries.add(ReportGiftStatus);
                            }
                        }
                        
                    }
                }
            }    
            //Section
            else if(groupingBy == 'Section') {
                
                List<string> Sections = new List<string>();
                
                if(!string.isEmpty(filter.department) &&filter.department.toLowerCase() != 'all') {
                	Sections = CGGlobal_GetSections(filter.department);
                }
                else {
                    Sections = CGGlobal_GetSections(null);
                }
                
                if(Sections.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Owner_Section__c, Owner_Unit__c order by Owner_Section__c, Owner_Unit__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer sectionCount = 0;
                    
                    for(string currentSection : Sections) {
                        
                        ReportGiftStatus = new CG_DTO.ReportGiftStatusSeriesDTO();
        				ReportGiftStatus.series = new List<CG_DTO.ReportGiftStatusSerieItemDTO>();    
                        ReportGiftStatus.category = currentSection;
                        
                        System.debug(currentSection);
                        
                        integer totalSection = 0;
                        
                        for(AggregateResult AR : database.query(finalQuery)) {
                            
                            if(AR.get('Owner_Section__c') == currentSection) {
                                
                                totalSection++;
                            
                                integer WaitingForSubmit = 0;
                                integer WaitingSupervisor = 0;
                                integer WaitingGLVP = 0;
                                integer Success = 0;
                                integer Rejected = 0;
                                
                                string unit = '';
                                
                                if(AR.get('Owner_Unit__c') != null) {
                                    unit = AR.get('Owner_Unit__c').toString();
                                }
                                
                                for(CG_Reporting__c CGReport : CGReports) {
                                    
                                    if(CGReport.Owner_Unit__c == unit) {
                                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
                                            WaitingForSubmit++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                            WaitingSupervisor++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                                            WaitingGLVP++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                                            WaitingGLVP++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                                            Success++;
                                        }
                                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
                                            Rejected++;
                                        }
                                    }
                                }
                                
                                System.debug(unit + ' : ' + WaitingForSubmit + ' : ' + WaitingSupervisor + ' : ' + WaitingGLVP + ' : ' + Success + ' : ' + Rejected);
                                
                                if(WaitingForSubmit > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingForSubmit';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingForSubmit, sectionCount);
                                    serie.color = '#F27D60';
                                    serie.stack = unit;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(WaitingSupervisor > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingSupervisor';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingSupervisor, sectionCount);
                                    serie.color = '#706DB6';
                                    serie.stack = unit;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(WaitingGLVP > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'WaitingGLVP';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(WaitingGLVP, sectionCount);
                                    serie.color = '#1FA4CE';
                                    serie.stack = unit;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                if(Success > 0) {
                                    serie = new CG_DTO.ReportGiftStatusSerieItemDTO();
                                    serie.name = 'Success';
                                    serie.data = new List<Integer>();
                                    serie.data = AddDataToSeries(Success, sectionCount);
                                    serie.color = '#1ABC9D';
                                    serie.stack = unit;
                                    ReportGiftStatus.series.add(serie);
                                }
                                
                                
                            }
                        }
                        
                        if(totalSection > 0) {
                        	sectionCount++;
                            if(ReportGiftStatus.series.size() > 0) {
                        		ReportGiftStatusSeries.add(ReportGiftStatus);
                            }
                        }
                        
                    }
                }
            } 
        }
        
        return ReportGiftStatusSeries;
         
    }
    
    @RemoteAction
    public static CG_DTO.ReportGiftStatusChartSeriesDTO GetReportGiftStatusChart(CG_Gift_Reporting.ReportGiftSearchCriteria filter){
        
        ReportGiftStatusChartSeries = new CG_DTO.ReportGiftStatusChartSeriesDTO();
        ReportGiftStatusChartSeries.series = new List<CG_DTO.ReportGiftStatusChartSerieItemDTO>();
        CG_DTO.ReportGiftStatusChartSerieItemDTO serie = new CG_DTO.ReportGiftStatusChartSerieItemDTO();
        
        integer inStock = 0;
        integer donated = 0;
        integer totalGift = 0;
        
        List<string> typeOfReports = new List<string> { 'GiftRegistration' };
                                            
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                            
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();                                                    
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, Gift_Status__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c , Status__c,' +
            				'OwnerId from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Submitted_Date__c >=: SD AND Submitted_Date__c <=: ED';
        
        //filter.giftStatus
        if(!String.isEmpty(filter.giftStatus) && !String.isBlank(filter.giftStatus) && filter.giftStatus.toLowerCase() != 'all') {
            string giftStatus = filter.giftStatus;
            query = query + ' AND Gift_Status__c =: giftStatus';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }

		//Final query
		CGReports = Database.query(query);
        
        if(CGReports.size() > 0) {
            for(CG_Reporting__c CGReport : CGReports) {
                
                if(CGReport.Gift_Status__c == String.ValueOf(CG_Enum.GiftStatus.InStock) && CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                    inStock += 1;
                }
                else if(CGReport.Gift_Status__c == String.ValueOf(CG_Enum.GiftStatus.Donated) && CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                    donated += 1;
                }
                
            }
            
            totalGift = inStock + donated;
            
            serie.name = 'In Stock';
            serie.color = '#8DC7EB';
            serie.count = inStock;
            
            if(inStock == 0) {
                serie.y = 0;
            }
            else {
                serie.y = (inStock * 100) / totalGift;
            }
            
            ReportGiftStatusChartSeries.series.add(serie);
            
            serie = new CG_DTO.ReportGiftStatusChartSerieItemDTO();
            serie.name = 'Donated';
            serie.color = '#FFD065';
            serie.count = donated;
            
            if(donated == 0) {
                serie.y = 0;
            }
            else {
                serie.y = (donated * 100) / totalGift;
            }
            
            ReportGiftStatusChartSeries.series.add(serie);
            
        }
        
        return ReportGiftStatusChartSeries;
        
    }
    
    @RemoteAction
    public static List<CG_DTO.ReportGiftInfoDTO> GetReportGiftInfoList(CG_Gift_Reporting.ReportGiftSearchCriteria filter,
    //reportNumber, ownerFullName, ownerOrgFunction, supervisorDecision, submittedDate, reportStatus, giftStatus
    CG_Global.SortByParam sortByParam,
    CG_Global.PageParam pageParam){
        
        if(pageParam == null) {
            pageParam = new CG_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
        List<string> typeOfReports = new List<string> { 'GiftRegistration' };
                                                                        
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
        
        ReportGiftInfoList = new List<CG_DTO.ReportGiftInfoDTO>();
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
                                                         
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
        
        string query = 'select id, Running_No__c, User__c, Owner_Full_Name_TH__c, Owner_Full_Name_EN__c,' +
                            'Employee_Id__c, Supervisor_Name__c, Start_Duration__c, supervisor_approver_status__c, ' +
                            'End_Duration__c, Submitted_Date__c, Type_Of_Report__c, Gift_Status__c , Status__c,' +
            				'OwnerId, Owner_Position__c, Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c from CG_Reporting__c ' + 
                            'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND CreatedDate >=: SD AND CreatedDate <=: ED'; 
        
        //filter.giftStatus
        if(!String.isEmpty(filter.giftStatus) && !String.isBlank(filter.giftStatus) && filter.giftStatus.toLowerCase() != 'all') {
            string giftStatus = filter.giftStatus;
            query = query + ' AND Gift_Status__c =: giftStatus';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId.toLowerCase() != 'all') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function.toLowerCase() != 'all') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department.toLowerCase() != 'all') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
        }
        
        //sortBy
        if(sortByParam.sortBy == 'reportNumber') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by running_no__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by running_no__c desc');
            }
        }
        else if(sortByParam.sortBy == 'owner') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_full_name_en__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_full_name_en__c desc');
            }
        }
        else if(sortByParam.sortBy == 'ownerOrgFunction') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_position__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by owner_position__c desc');
            }
        }
        else if(sortByParam.sortBy == 'supervisorDecision') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by supervisor_approver_status__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by supervisor_approver_status__c desc');
            }
        }
        else if(sortByParam.sortBy == 'status') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by status__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by status__c desc');
            }
        }
        else if(sortByParam.sortBy == 'submittedDate') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by submitted_date__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by submitted_date__c desc');
            }
        }
        else if(sortByParam.sortBy == 'giftStatus') {
            if(sortByParam.ascending) {
                CGReports = database.query(query + ' order by gift_status__c asc');
            }
            else if(!sortByParam.ascending) {
                CGReports = database.query(query + ' order by gift_status__c desc');
            }
        }
        else {
            CGReports = database.query(query + ' order by Running_No__c desc');
        }  
        
        if(CGReports.size() > 0) {
            
            Map<string,CG_DTO.UserDTO> userDTOs = CG_Global.assignAllToUserDTO();
            
            for(CG_Reporting__c CGReport : CGReports) {
                CG_DTO.ReportGiftInfoDTO ReportGiftInforDTO = assignToReportGiftInfoDTO(CGReport, userDTOs);
                ReportGiftInfoList.add(ReportGiftInforDTO);
            }
        }
        
        List<CG_DTO.ReportGiftInfoDTO> results = new List<CG_DTO.ReportGiftInfoDTO>();
            Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
            integer totalSize = ReportGiftInfoList.size() - startIndex;
            
            for (Integer i = 0; i < pageParam.pageSize; i++ ) {
                if (i < totalSize){
                    results.add(ReportGiftInfoList[startIndex + i]);
                }else{
                    break;
                }
            }  
        
        return results;
        
    }

    @RemoteAction
    public static CG_DTO.ReportGiftStatisticDTO GetReportGiftStatistics(CG_Gift_Reporting.ReportGiftSearchCriteria filter){
        
        ReportGiftStatistics = new CG_DTO.ReportGiftStatisticDTO();
             
        List<string> typeOfReports = new List<string> { 'GiftRegistration' };
                                           
        Date SD = Date.ValueOf(filter.startDate);
        Date ED = Date.ValueOf(filter.endDate).addDays(1);
            
        List<CG_Reporting__c> CGReports = new List<CG_Reporting__c>();
                             
        List<string> statuses = new List<string> { String.ValueOf(CG_Enum.ReportStatus.Rejected),
            										String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit),
            										String.ValueOf(CG_Enum.ReportStatus.Cancel),
            										String.ValueOf(CG_Enum.ReportStatus.Expired)};
                              
        string query = '';
        query = 'select id, Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c, Status__c from CG_Reporting__c ' +
            	'where Type_Of_Report__c IN: typeOfReports AND Status__c NOT IN: statuses AND Owner_Function__c != \'\' AND CreatedDate >=: SD AND CreatedDate <=: ED '; 
        	 	  
        string groupByQuery = '';
        groupByQuery = 'select Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c from CG_Reporting__c where  Type_Of_Report__c IN: typeOfReports  AND Status__c NOT IN: statuses AND ' +
            			'CreatedDate >=: SD AND CreatedDate <=: ED AND Owner_Function__c != \'\' ';
        
        boolean isFunctionFilter = false;
        
        //filter.giftStatus
        if(!String.isEmpty(filter.giftStatus) && !String.isBlank(filter.giftStatus) && filter.giftStatus != 'All') {
            string giftStatus = filter.giftStatus;
            query = query + ' AND Gift_Status__c =: giftStatus';
            groupByQuery = groupByQuery + ' AND Gift_Status__c =: giftStatus';
        }
        
        //filter.status
        if(!String.isEmpty(filter.status) && !String.isBlank(filter.status) && filter.status != 'All') {
            string status = filter.status;
            query = query + ' AND Status__c =: status';
            groupByQuery = groupByQuery + ' AND Status__c =: status';
        }
        
        //filter.companyId
        if(!String.isEmpty(filter.companyId) && !String.isBlank(filter.companyId) && filter.companyId != 'All') {
            string companyId = filter.companyId;
            
            if(companyId.contains('|')) {
                List<String> companies = companyId.split('\\|');
                query = query + ' AND Reported_By_Company_EN__c IN: companies';
            }
            else {
                query = query + ' AND Reported_By_Company_EN__c =: companyId';
            }
            
        }
        
        //filter.function
        if(!String.isEmpty(filter.function) && !String.isBlank(filter.function) && filter.function != 'All') {
            string functionName = filter.function;
            query = query + ' AND Owner_Function__c =: functionName';
            groupByQuery = groupByQuery + ' AND Owner_Function__c =: functionName';
            isFunctionFilter = true;
        }
        
        //filter.department
        if(!String.isEmpty(filter.department) && !String.isBlank(filter.department) && filter.department != 'All') {
            string departmentName = filter.department;
            query = query + ' AND Owner_Department__c =: departmentName';
            groupByQuery = groupByQuery + ' AND Owner_Department__c =: departmentName';
        }
        
        //filter.section
        if(!String.isEmpty(filter.section) && !String.isBlank(filter.section) && filter.section != 'All') {
            string sectionName = filter.section;
            query = query + ' AND Owner_Section__c =: sectionName';
            groupByQuery = groupByQuery + ' AND Owner_Section__c =: sectionName';
        }
        
		//Final query
		System.debug(query);
		CGReports = Database.query(query);  
           
        /* List<Id> CompanyIds = new List<Id>();
        List<SD_Company__c> Companies = new List<SD_Company__c>();
            
        if(filter.companyId != 'All' && !String.isEmpty(filter.companyId)) {
            if(filter.companyId.contains(',')) {
                CompanyIds = filter.companyId.split(',');
            }
            else {
                CompanyIds.add(filter.companyId);
            }
            
            Companies = [select id, name from SD_Company__c where Id IN: CompanyIds order by Order__c asc];
              
            if(Companies.size() > 0) {
                for(SD_Company__c Company : Companies) {
            		ReportCOIStatusSeries.categories.add(Company.Name);
                }
            }
        } */
         
        //Grouping By   
        if(CGReports.size() > 0) {
            
            ReportGiftStatistics.functions = new List<CG_DTO.ReportGiftStatisticFunctionDTO>();
            List<string> Functions = CGGlobal_GetFunctions(null);
            
            if(Functions.size() > 0) {
                
                integer total = 0;
                integer WaitingSupervisor = 0;
                integer WaitingGLGC = 0;
                integer WaitingGLVP = 0;
                integer Success = 0;
                
                for(string currentFunction : Functions) {
                    
                    string finalQuery = '';
                    
                    if(!isFunctionFilter) {
                        finalQuery = groupByQuery + ' AND Owner_Function__c =: currentFunction group by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c order by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c asc';
                    }
                    else {
                        finalQuery = groupByQuery + ' group by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c order by Owner_Function__c, Owner_Department__c, Owner_Section__c, Owner_Unit__c asc';
                    }
                    
                    integer totalFunction = 0;
                    integer WaitingSupervisorFunction = 0;
                    integer WaitingGLGCFunction = 0;
                    integer WaitingGLVPFunction = 0;
                    integer SuccessFunction = 0;
                    
                    CG_DTO.ReportGiftStatisticFunctionDTO func = new CG_DTO.ReportGiftStatisticFunctionDTO();
                    func.childFunctions = new List<CG_DTO.ReportGiftStatisticFunctionDTO>();
                    
                    CG_DTO.ReportGiftStatisticFunctionDTO dept = new CG_DTO.ReportGiftStatisticFunctionDTO();
                    CG_DTO.ReportGiftStatisticFunctionDTO sect = new CG_DTO.ReportGiftStatisticFunctionDTO();
                    CG_DTO.ReportGiftStatisticFunctionDTO addUnit = new CG_DTO.ReportGiftStatisticFunctionDTO();
                    
                    Set<string> existDepartments = new Set<string>();
                    Set<string> existSections = new Set<string>();
                    Set<string> existUnits = new Set<string>();
                    
                    boolean isFunctionFound = false;
                    
                    for(AggregateResult AR : database.query(finalQuery)) {
                        
                        integer totalDepartment = 0;
                        integer WaitingSupervisorDepartment = 0;
                        integer WaitingGLGCDepartment = 0;
                        integer WaitingGLVPDepartment = 0;
                        integer SuccessDepartment = 0;
                        
                        integer totalSection = 0;
                        integer WaitingSupervisorSection = 0;
                        integer WaitingGLGCSection = 0;
                        integer WaitingGLVPSection = 0;
                        integer SuccessSection = 0;
                        
                        integer totalUnit = 0;
                        integer WaitingSupervisorUnit = 0;
                        integer WaitingGLGCUnit = 0;
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
                                
                                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                    WaitingSupervisorFunction++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                                    WaitingGLGCFunction++;
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
                                
                                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                    WaitingSupervisorDepartment++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                                    WaitingGLGCDepartment++;
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
                                
                                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                    WaitingSupervisorSection++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                                    WaitingGLGCSection++;
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
                                
                                if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                                    WaitingSupervisorUnit++;
                                }
                                else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                                    WaitingGLGCUnit++;
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
                            dept = new CG_DTO.ReportGiftStatisticFunctionDTO();
                            if(department != '' && department != null) {
                                dept.name = department;
                                dept.all = totalDepartment;
                                dept.waitingSupervisor = WaitingSupervisorDepartment;
                                dept.waitingGLGC = WaitingGLGCDepartment;
                                dept.waitingGLVP = WaitingGLVPDepartment;
                                dept.completed = SuccessDepartment;
                                dept.childFunctions = new List<CG_DTO.ReportGiftStatisticFunctionDTO>();
                                func.childFunctions.add(dept);
                            }
                            existDepartments.add(department);
                        }
                        
                        
                        //Section
                        if(!existSections.contains(section)) {
                            sect = new CG_DTO.ReportGiftStatisticFunctionDTO();
                            if(section != '' && section != null) {
                                sect.name = section;
                                sect.all = totalSection;
                                sect.waitingSupervisor = WaitingSupervisorSection;
                                sect.waitingGLGC = WaitingGLGCSection;
                                sect.waitingGLVP = WaitingGLVPSection;
                                sect.completed = SuccessSection;
                                sect.childFunctions = new List<CG_DTO.ReportGiftStatisticFunctionDTO>();
                                dept.childFunctions.add(sect);
                            }
                            existSections.add(section);
                        }
                        
                        //Unit
                        if(!existUnits.contains(unit)) {
                            addUnit = new CG_DTO.ReportGiftStatisticFunctionDTO();
                            if(unit != '' && unit != null) {
                                addUnit.name = unit;
                                addUnit.all = totalUnit;
                                addUnit.waitingSupervisor = WaitingSupervisorUnit;
                                addUnit.waitingGLGC = WaitingGLGCUnit;
                                addUnit.waitingGLVP = WaitingGLVPUnit;
                                addUnit.completed = SuccessUnit;
                                sect.childFunctions.add(addUnit);
                            }
                            existUnits.add(unit);
                        }
                    }
                    
                    //Function
                    if(totalFunction > 0) {
                        func.name = currentFunction;
                        func.all = totalFunction;
                        func.waitingSupervisor = WaitingSupervisorFunction;
                        func.waitingGLGC = WaitingGLGCFunction;
                        func.waitingGLVP = WaitingGLVPFunction;
                        func.completed = SuccessFunction;
                        ReportGiftStatistics.functions.add(func);
                    }
                    
                }
                
                //Total
                if(CGReports.size() > 0) {
                    for(CG_Reporting__c CGReport : CGReports) {
                            
                        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
                            WaitingSupervisor++;
                        }
                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
                            WaitingGLGC++;
                        }
                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
                            WaitingGLVP++;
                        }
                        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
                            Success++;
                        }
                        
                    }
                }
                
                ReportGiftStatistics.total = new CG_DTO.ReportGiftStatisticFunctionTotalDTO();
                ReportGiftStatistics.total.all = CGReports.size();
                ReportGiftStatistics.total.waitingSupervisor = WaitingSupervisor;
                ReportGiftStatistics.total.waitingGLGC = WaitingGLGC;
                ReportGiftStatistics.total.waitingGLVP = WaitingGLVP;
                ReportGiftStatistics.total.completed = Success;
            }  
        }
        
        return ReportGiftStatistics;
        
    }
    
    @RemoteAction
    public static string ExportGiftAllExcel(CG_Gift_Reporting.ReportGiftSearchCriteria filter){
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CG_Report_Excel?';
        
        string exportAll = 'true';
        string reportName = 'Gift';
        
        string startDate = filter.startDate.format('yyyy-MM-dd');
        string endDate = filter.endDate.addDays(1).format('yyyy-MM-dd');
        
        URL = URL + 'exportAll=' + exportAll + '&startDate=' + startDate +
              '&endDate=' + endDate + '&reportName=' + reportName + '&typeOfReport=all';
        
        return URL;
    }

    @RemoteAction
    public static string ExportGiftTableExcel(CG_Gift_Reporting.ReportGiftSearchCriteria filter){
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CG_Report_Excel';
        
        string exportAll = 'false';
        string typeOfReport = 'GiftRegistration';
        string status = String.ValueOf(filter.status);
        string giftStatus = filter.giftStatus;
        string startDate = filter.startDate.format('yyyy-MM-dd');
        string endDate = filter.endDate.addDays(1).format('yyyy-MM-dd');
        string company = filter.companyId;
        string function = filter.function;
        string department = filter.department;
        string section = filter.section;
        string reportName = 'Gift';
        
        URL = URL + '?exportAll=' + exportAll + '&typeOfReport=' + typeOfReport + '&status=' + status + '&giftStatus=' + giftStatus + '&startDate=' + startDate +
              '&endDate=' + endDate + '&company=' + company + '&function=' + function + '&department=' + department +
              '&section=' + section + '&reportName=' + reportName;
        
        return URL;
    }
    
    @RemoteAction
    public static CG_DTO.WorkflowHistoryDTO GetReportWorkflow(string reportId) {
        
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
    
    @TestVisible
    private static CG_DTO.WorkflowHistoryDTO DeserializeWorkflowHistory(string workflowStatusJson) {
        CG_DTO.WorkflowHistoryDTO workflowHistoryDTO = (CG_DTO.WorkflowHistoryDTO)JSON.deserialize(workflowStatusJson, CG_DTO.WorkflowHistoryDTO.class);
		
        for(CG_DTO.WorkflowApproverDTO currentWorkflow : workflowHistoryDTO.currentWorkflow.approvers) {
                
            currentWorkflow.isShow = true;
            
        }
        
        return workflowHistoryDTO;
    }
    
    //Assign to DTO section
    @TestVisible
    private static CG_DTO.ReportCOIInfoDTO assignToReportCOIInfoDTO(CG_Reporting__c CGReporting, Map<string,CG_DTO.UserDTO> userDTOs) {
        
        CG_DTO.ReportCOIInfoDTO COIReport = new CG_DTO.ReportCOIInfoDTO();
        COIReport.id = CGReporting.Id;
        COIReport.reportNumber = CGReporting.Running_No__c;
        
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
        
        //COIReport.owner = CG_Global.assignToUserDTO(CGReporting.OwnerId);
        if(userDTOs != null) {
            COIReport.owner = userDTOs.get(CGReporting.OwnerId);
        }
        COIReport.ownerOrgFunction = CGReporting.Owner_Position__c;
        
        COIReport.status = new CG_Global.EnumValue('ReportStatus'); 
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
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Expired)) {
            COIReport.status.key = CG_Enum.ReportStatus.Expired.name();
            COIReport.status.value = 'Expired';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Cancel)) {
            COIReport.status.key = CG_Enum.ReportStatus.Cancel.name();
            COIReport.status.value = 'Cancel';            
        }
        
        COIReport.submittedDate = CGReporting.Submitted_Date__c;
        
        return COIReport;
        
    }
    
    @TestVisible
    private static CG_DTO.ReportCGInfoDTO assignToReportCGInfoDTO(CG_Reporting__c CGReporting, Map<string,CG_DTO.UserDTO> userDTOs) {
        
        CG_DTO.ReportCGInfoDTO CGReport = new CG_DTO.ReportCGInfoDTO();
        CGReport.id = CGReporting.Id;
        CGReport.reportNumber = CGReporting.Running_No__c;
        
        CGReport.reportType = new CG_Global.EnumValue('CGReportType');
        if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGAnnual)) {
            CGReport.reportType.key = CG_Enum.CGReportType.CGAnnual.name();
            CGReport.reportType.value = 'Annual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGManual)) {
            CGReport.reportType.key = CG_Enum.CGReportType.CGManual.name();
            CGReport.reportType.value = 'Manual';
        }
        else if(CGReporting.Type_of_Report__c == String.ValueOf(CG_Enum.CGReportType.CGNewEmployee)) {
            CGReport.reportType.key = CG_Enum.CGReportType.CGNewEmployee.name();
            CGReport.reportType.value = 'New Employee';
        }
        
        //CGReport.owner = CG_Global.assignToUserDTO(CGReporting.OwnerId);
        if(userDTOs != null) {
        	CGReport.owner = userDTOs.get(CGReporting.OwnerId);
        }
        CGReport.ownerOrgFunction = CGReporting.Owner_Position__c;
        
        CGReport.status = new CG_Global.EnumValue('ReportStatus'); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            CGReport.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            CGReport.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            CGReport.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            CGReport.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            CGReport.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            CGReport.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            CGReport.status.key = CG_Enum.ReportStatus.Rejected.name();
            CGReport.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            CGReport.status.key = CG_Enum.ReportStatus.Success.name();
            CGReport.status.value = 'Success';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Cancel)) {
            CGReport.status.key = CG_Enum.ReportStatus.Cancel.name();
            CGReport.status.value = 'Cancel';            
        }
        
        CGReport.supervisorDecision = CGReporting.Supervisor_Approver_Status__c;
        CGReport.submittedDate = CGReporting.Submitted_Date__c;
        CGReport.fileUrl = '';
        
        return CGReport;
        
    }
    
    @TestVisible
    private static CG_DTO.ReportGiftInfoDTO assignToReportGiftInfoDTO(CG_Reporting__c CGReporting, Map<string,CG_DTO.UserDTO> userDTOs) {
        
        CG_DTO.ReportGiftInfoDTO GiftReport = new CG_DTO.ReportGiftInfoDTO();
        GiftReport.id = CGReporting.Id;
        GiftReport.reportNumber = CGReporting.Running_No__c;
        
        GiftReport.reportType = new CG_Global.EnumValue('GiftReportType');
        GiftReport.reportType.key = 'GiftRegistration';
        GiftReport.reportType.value = 'Gift Registration';
        
        if(string.isNotEmpty(CGReporting.Supervisor_Approver_Status__c)) {
        	GiftReport.supervisorDecision = CGReporting.Supervisor_Approver_Status__c;
        }
        else {
            GiftReport.supervisorDecision = '';
        }
        
        //GiftReport.owner = CG_Global.assignToUserDTO(CGReporting.OwnerId);
        if(userDTOs != null) {
        	GiftReport.owner = userDTOs.get(CGReporting.OwnerId);
        }
        
        if(string.isNotEmpty(CGReporting.Owner_Position__c)) {
        	GiftReport.ownerOrgFunction = CGReporting.Owner_Position__c;
        }
        else {
        	GiftReport.ownerOrgFunction = '';
        }
        
        GiftReport.status = new CG_Global.EnumValue('ReportStatus'); 
        if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit)) {
            GiftReport.status.key = CG_Enum.ReportStatus.WaitingForSubmit.name();
            GiftReport.status.value = 'Waiting for Submit';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            GiftReport.status.key = CG_Enum.ReportStatus.WaitingSupervisor.name();
            GiftReport.status.value = 'Waiting Supervisor';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            GiftReport.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            GiftReport.status.value = 'Waiting GLVP';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            GiftReport.status.key = CG_Enum.ReportStatus.WaitingGLVP.name();
            GiftReport.status.value = 'Waiting GLVP';            
            
        	string userProfile = CG_PrivilegeHandler.getUserProfile();
            if(userProfile == String.ValueOf(CG_Enum.ApproverRole.GLGC)) {
                GiftReport.status.key = CG_Enum.ReportStatus.WaitingGLGC.name();
            	GiftReport.status.value = 'Waiting GLGC';   
            }
            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            GiftReport.status.key = CG_Enum.ReportStatus.Rejected.name();
            GiftReport.status.value = 'Rejected';            
        }
        else if(CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
            GiftReport.status.key = CG_Enum.ReportStatus.Success.name();
            GiftReport.status.value = 'Success';            
        }
        
        GiftReport.submittedDate = CGReporting.Submitted_Date__c;
        
        if(string.isNotEmpty(CGReporting.Gift_Status__c) && CGReporting.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success)) {
        	GiftReport.giftStatus = CGReporting.Gift_Status__c;
        }
        else {
            GiftReport.giftStatus = '';
        }
        
        return GiftReport;
        
    }
    
    @TestVisible
    private static List<integer> AddDataToSeries(integer data, integer functionCount) {
        
        List<integer> datas = new List<integer>();
        System.debug('functionCount : ' + functionCount);
        
        /* for(integer i=0; i<=functionCount; i++) {
            if(i == functionCount) {
            	datas.add(data);
            }
            else {
            	datas.add(0);
            }
        } */
        
        datas.add(data);
        
        return datas;
    }
    
    @RemoteAction
    public static CG_DTO.CGAcknowledgeFormDTO CGAcknowledgeForm(string reportId) {
        
        CG_Reporting__c CGReport = [select id, ownerId, submitted_date__c from CG_Reporting__c where Id =: reportId];
        
        string userId = CGReport.OwnerId;
        PISUsers__c User = CG_Global.assignToPISUser(userId);
        
        CG_DTO.CGAcknowledgeFormDTO Form = new CG_DTO.CGAcknowledgeFormDTO();
        Form.employeeId = User.EMPLOYEEID__c;
        Form.employeeName = User.EN_Fullname__c;
        Form.submittedDate = CGReport.Submitted_Date__c;
        
        return Form;
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