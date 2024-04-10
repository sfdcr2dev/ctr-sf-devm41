/* 
 * Author Softever
 */

global with sharing class WAP_SafetyPermitReport {

    private static List<WAP_DTO.SafetyPermitReportDTO> reports;
    private static WAP_DTO.SafetyPermitChartSeriesDTO safetyPermitChartSeries;
    
    static {
        
    }
    
    @RemoteAction
    public static WAP_DTO.SafetyPermitChartSeriesDTO GetSummaryPermitGraph(SearchFilter filter) {
        
        safetyPermitChartSeries = new WAP_DTO.SafetyPermitChartSeriesDTO();
        safetyPermitChartSeries.series = new List<WAP_DTO.SafetyPermitChartSerieItemDTO>();
        
        string year = WAP_LogicHandler.GetCurrentYear();
        
        safetyPermitChartSeries.categories = new List<string> { 'Jan-' + year, 'Feb-' + year, 'Mar-' + year, 'Apr-' + year, 'May-' + year, 'Jun-' + year, 'Jul-' + year, 'Aug-' + year, 
            															'Sep-' + year, 'Oct-' + year, 'Nov-' + year, 'Dec-' + year };
        
        List<Safety_Permit__c> SafetyPermits = new List<Safety_Permit__c>();
        
        string query = 'select id, name, Work_Detail__c, Plant_Section__c, Permit_to_Work_Date__c, Expired_Date_1__c, Expired_Date_2__c , Expired_Date_3__c from Safety_Permit__c';
        
        //filter.year
        if(string.isNotEmpty(filter.year)) {
            integer filterYear = Integer.ValueOf(filter.year);
            query = query + ' WHERE CALENDAR_YEAR(Permit_to_Work_Date__c) =: filterYear';
        }
        
        //filter.area
        if(string.isNotEmpty(filter.area) && filter.area.toLowerCase() != 'all') {
            string area = filter.area;
            query = query + ' AND Plant_Section__c =: area';
        }
        
        //filter.startDate
        date startDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        query = query + ' AND Permit_to_Work_Date__c >=: startDate';
        
        //filter.endDate
        date endDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        query = query + ' AND Permit_to_Work_Date__c <=: endDate';
        
        SafetyPermits = database.query(query);
        
        integer jan = 0;
        integer feb = 0;
        integer mar = 0;
        integer apr = 0;
        integer may = 0;
        integer jun = 0;
        integer jul = 0;
        integer aug = 0;
        integer sep = 0;
        integer oct = 0;
        integer nov = 0;
        integer dec = 0;
        
        if(SafetyPermits.size() > 0) {
            for(Safety_Permit__c SP : SafetyPermits) {
                if(SP.Permit_to_Work_Date__c.month() == 1) {
                    jan++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 2) {
                    feb++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 3) {
                    mar++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 4) {
                    apr++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 5) {
                    may++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 6) {
                    jun++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 7) {
                    jul++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 8) {
                    aug++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 9) {
                    sep++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 10) {
                    oct++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 11) {
                    nov++;
                }
                else if(SP.Permit_to_Work_Date__c.month() == 12) {
                    dec++;
                }
            }
        }
        
                                                                            
        WAP_DTO.SafetyPermitChartSerieItemDTO serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Jan-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { jan };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Feb-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { feb };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Mar-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { mar };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Apr-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { apr };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'May-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { may };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Jun-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { jun };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'July-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { jul };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Aug-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { aug };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Sep-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { sep };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Oct-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { oct };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Nov-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { nov };
        safetyPermitChartSeries.series.add(serie);
        
        serie = new WAP_DTO.SafetyPermitChartSerieItemDTO();
        serie.name = 'Dec-' + year;
        serie.color = '#8A7BBC';
        serie.data = new List<decimal> { dec };
        safetyPermitChartSeries.series.add(serie);
                    
        return safetyPermitChartSeries;
    }
       
    @RemoteAction
    public static integer GetSummaryPermitTableCount(SearchFilter filter,
        //no, detail, workingArea, startDate, endDate, firstExtendDate, secondExtendDate, thirdExtendDate
        WAP_Global.SortByParam sortByParam, 
        WAP_Global.PageParam pageParam) {
        
        if(pageParam == null) {
            pageParam = new WAP_Global.PageParam();
            pageParam.pageSize = 1;
            pageParam.pageNo = 1;
        }
            
        integer summaryPermitTableCount = 0;
        
        List<Safety_Permit__c> SafetyPermits = new List<Safety_Permit__c>();
        
        string query = 'select id, name, Work_Detail__c, Plant_Section__c, Permit_to_Work_Date__c, Expired_Date_1__c, Expired_Date_2__c , Expired_Date_3__c from Safety_Permit__c';

        //filter.year
        if(string.isNotEmpty(filter.year)) {
            integer filterYear = Integer.ValueOf(filter.year);
            query = query + ' WHERE Permit_to_Work_Date__c != null AND CALENDAR_YEAR(Permit_to_Work_Date__c) =: filterYear';
        }
          
        //filter.area
        if(string.isNotEmpty(filter.area) && filter.area.toLowerCase() != 'all') {
            string area = filter.area;
            query = query + ' AND Plant_Section__c =: area';
        }
        
        //filter.startDate
        date startDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        query = query + ' AND Permit_to_Work_Date__c >=: startDate';
        
        //filter.endDate
        date endDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        query = query + ' AND Permit_to_Work_Date__c <=: endDate';
                
        if(sortByParam.sortBy == 'no') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by name asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by name desc');
            }
        }
        else if(sortByParam.sortBy == 'detail') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by work_detail__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by work_detail__c desc');
            }
        }
        else if(sortByParam.sortBy == 'workingArea') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by plant_section__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by plant_section__c desc');
            }
        } 
        else if(sortByParam.sortBy == 'startDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by permit_to_work_date__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by permit_to_work_date__c desc');
            }
        }
        else if(sortByParam.sortBy == 'endDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by permit_to_work_date__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by permit_to_work_date__c desc');
            }
        }
        else if(sortByParam.sortBy == 'firstExtendDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by expired_date_1__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by expired_date_1__c desc');
            }
        }
        else if(sortByParam.sortBy == 'secondExtendDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by expired_date_2__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by expired_date_2__c desc');
            }
        }
        else if(sortByParam.sortBy == 'thirdExtendDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by expired_date_3__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by expired_date_3__c desc');
            }
        }
        else {
        	SafetyPermits = database.query(query + ' order by name asc');         
        }
         
        summaryPermitTableCount = SafetyPermits.size();
          
        return summaryPermitTableCount;
    }

    
    @RemoteAction
    public static List<WAP_DTO.SafetyPermitReportDTO> GetSummaryPermitTable(SearchFilter filter,
        //no, detail, workingArea, startDate, endDate, firstExtendDate, secondExtendDate, thirdExtendDate
        WAP_Global.SortByParam sortByParam, 
        WAP_Global.PageParam pageParam) {
        
        if(pageParam == null) {
            pageParam = new WAP_Global.PageParam();
            pageParam.pageSize = 1;
            pageParam.pageNo = 1;
        }
            
        reports = new List<WAP_DTO.SafetyPermitReportDTO>();
        
        List<Safety_Permit__c> SafetyPermits = new List<Safety_Permit__c>();
        
        string query = 'select id, name, Work_Detail__c, Plant_Section__c, Permit_to_Work_Date__c, Expired_Date_1__c, Expired_Date_2__c , ' + 
            			'Expired_Date_3__c, Extended_From_Date_1__c, Extended_From_Date_2__c, Extended_From_Date_3__c, Extend_Certificate__c from Safety_Permit__c';

        //filter.year
        if(string.isNotEmpty(filter.year)) {
            integer filterYear = Integer.ValueOf(filter.year);
            query = query + ' WHERE Permit_to_Work_Date__c != null AND CALENDAR_YEAR(Permit_to_Work_Date__c) =: filterYear';
        }
        
        //filter.area
        if(string.isNotEmpty(filter.area) && filter.area.toLowerCase() != 'all') {
            string area = filter.area;
            query = query + ' AND Plant_Section__c =: area';
        }
        
        //filter.startDate
        date startDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        query = query + ' AND Permit_to_Work_Date__c >=: startDate';
        
        //filter.endDate
        date endDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        query = query + ' AND Permit_to_Work_Date__c <=: endDate';
        
        if(sortByParam.sortBy == 'no') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by name asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by name desc');
            }
        }
        else if(sortByParam.sortBy == 'detail') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by work_detail__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by work_detail__c desc');
            }
        }
        else if(sortByParam.sortBy == 'workingArea') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by plant_section__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by plant_section__c desc');
            }
        } 
        else if(sortByParam.sortBy == 'startDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by permit_to_work_date__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by permit_to_work_date__c desc');
            }
        }
        else if(sortByParam.sortBy == 'endDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by permit_to_work_date__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by permit_to_work_date__c desc');
            }
        }
        else if(sortByParam.sortBy == 'firstExtendDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by extended_from_date_1__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by extended_from_date_1__c desc');
            }
        }
        else if(sortByParam.sortBy == 'secondExtendDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by extended_from_date_2__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by extended_from_date_2__c desc');
            }
        }
        else if(sortByParam.sortBy == 'thirdExtendDate') {
            if(sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by extended_from_date_3__c asc');
            }
            else if(!sortByParam.ascending) {
                SafetyPermits = database.query(query + ' order by extended_from_date_3__c desc');
            }
        }
        else {
        	SafetyPermits = database.query(query + ' order by name asc');         
        }
            
        if(SafetyPermits.size() > 0) {
            
            for(Safety_Permit__c SP : SafetyPermits) {
                WAP_DTO.SafetyPermitReportDTO Safety = new WAP_DTO.SafetyPermitReportDTO();
                Safety = assignToSafetyPermitReportDTO(SP);
                reports.add(Safety);
            }
            
        }
        
        return reports;
    }

    @RemoteAction
    public static string ExportExcel(SearchFilter filter){
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/WAP_SafetyPermitReport_Excel';
            
        string year = String.ValueOf(filter.year);
        string area = String.ValueOf(filter.area);
        date startDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        date endDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        
        URL = URL + '?year=' + year + '&area=' + area + '&startDate=' + startDate + '&endDate=' + endDate;
        
        return URL;
    }
    
    @RemoteAction
    public static Set<string> allAreas(SearchFilter filter) {
         
        Set<string> Areas = new Set<string>();
        
        List<Safety_Permit__c> SafetyPermits = new List<Safety_Permit__c>();
        
        string query = 'select id, name, Work_Detail__c, Plant_Section__c, Permit_to_Work_Date__c, Expired_Date_1__c, Expired_Date_2__c, ' +
            			'Expired_Date_3__c, Main_Work_Center_Text__c from Safety_Permit__c';
        
        //filter.year
        if(string.isNotEmpty(filter.year)) {
            integer filterYear = Integer.ValueOf(filter.year);
            query = query + ' WHERE CALENDAR_YEAR(Permit_to_Work_Date__c) =: filterYear';
        }
        
        query = query + ' order by Plant_Section__c asc';
        
        SafetyPermits = database.query(query);
        
        if(SafetyPermits.size() > 0) {
            
            for(Safety_Permit__c SP : SafetyPermits) {
                if(SP.Plant_Section__c != null) {
                	Areas.add(SP.Plant_Section__c);
                }
            }
            
        }
        
        return Areas;
    }
    
    //assign DTO
    private static WAP_DTO.SafetyPermitReportDTO assignToSafetyPermitReportDTO(Safety_Permit__c SP) {
        
        WAP_DTO.SafetyPermitReportDTO SafetyPermit = new WAP_DTO.SafetyPermitReportDTO();
        SafetyPermit.Id = SP.Id;
        SafetyPermit.no = SP.name;
        SafetyPermit.detail = SP.Work_Detail__c;
        SafetyPermit.workingArea = SP.Plant_Section__c;
        SafetyPermit.startDate = SP.Permit_to_Work_Date__c;
        
        date endDate;
        
        if(SP.Extend_Certificate__c == '1') {
            endDate = SP.Permit_to_Work_Date__c.addDays(7);
        }
        else if(SP.Extend_Certificate__c == '2') {
            endDate = SP.Permit_to_Work_Date__c.addDays(30);
        }
        else if(SP.Extend_Certificate__c == '3') {
            endDate = SP.Permit_to_Work_Date__c.addDays(365);
        }
        
        SafetyPermit.endDate = endDate;
        SafetyPermit.firstExtendDate = SP.extended_from_date_1__c;
        SafetyPermit.secondExtendDate = SP.extended_from_date_2__c;
        SafetyPermit.thirdExtendDate = SP.extended_from_date_3__c;
        SafetyPermit.firstExpiredDate = SP.Expired_Date_1__c;
        SafetyPermit.secondExpiredDate = SP.Expired_Date_2__c;
        SafetyPermit.thirdExpiredDate = SP.Expired_Date_3__c;
            
        return SafetyPermit;
        
    }
    
    public class SearchFilter {
        @RemoteAction
        public string year {get;set;}
        @RemoteAction
        public string area {get;set;}
        @RemoteAction
        public date startDate {get;set;}
        @RemoteAction
        public date endDate {get;set;}
    }
    
}