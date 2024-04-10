/* 
 * Author Softever
 */

global with sharing class WAP_Dashboard {

    private static WAP_DTO.DashboardChartSeriesDTO dailyClearanceCertificateChartSeries;
    private static List<WAP_DTO.DashboardChartSeriesDTO> detailReportByAreaChartSeries;
    private static List<WAP_DTO.DashboardChartSeriesDTO> clearanceCeriticateYearChartSeries;
    private static WAP_DTO.DashboardPieChartSeriesDTO dashboardHRWPieChartSeries;
    private static WAP_DTO.DashboardHRWChartSeriesDTO dashboardHRWChartSeries;
    private static WAP_DTO.DashboardChartSeriesDTO topFiveChartSeries;
    
    static {
        
    }
    
    @RemoteAction
    public static WAP_DTO.DashboardChartSeriesDTO DailyClearanceCertificateChartSeries(SearchFilter filter) {
        
        dailyClearanceCertificateChartSeries = new WAP_DTO.DashboardChartSeriesDTO();
        dailyClearanceCertificateChartSeries.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        
        List<Work_Clearance__c> WorkClearances = new List<Work_Clearance__c>();
        
        string query = 'select id, name, Area__c, Functional_Location__c, FunctionalLocation__c, FunctionalLocation__r.Latitude__c, FunctionalLocation__r.Longitude__c, ' + 
            			'FunctionalLocation__r.Description__c, User_Status__c, High_Risk_Work__c, Main_Work_Center_Text__c, Work_Detail__c, ' +
            			'Safety_Permit1__c, Safety_Permit2__c, Safety_Permit3__c, IsCheckingGas__c, Flamable_amt__c, Oxygen_amt__c, Toxic_PPM__c, ' +
            			'AGT_UI__c, Check_Date_UI__c, Check_Time_UI__c, Authorized_Signatory_UI__c, Authorized_Date_UI__c, Authorized_Time_UI__c, ' + 
            			'Extend_Time_Flag_Formula__c, Extend_Date__c, Extend_Time__c, Extend_Time_To_UI__c, Extend_Applicant_or_Bearer_UI__c, ' +
            			'Extend_Authorized_Sign_UI__c, Close_Applicant_or_Bearer_UI__c, Close_Authorized_Sign_off_UI__c, Work_Clearance_Status__c, Plant_Section__c ' +
            			'from Work_Clearance__c';
        
        //filter.startDate
        date SD = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        query = query + ' WHERE Authorized_Date_UI__c >=: SD';
        
        //filter.endDate
        date ED = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        query = query + ' AND Authorized_Date_UI__c <=: ED';
        
        //filter.area
        if(string.isNotEmpty(filter.area) && filter.area.toLowerCase() != 'all') {
            string area = filter.area;
            query = query + ' AND Area__c =: area';
        }
        else {
            query = query + ' AND Area__c != null';
        }
        
        WorkClearances = database.query(query);
        
        integer diffDate = SD.daysBetween(ED);
        
        dailyClearanceCertificateChartSeries.categories = new List<string>();
        
        for(integer i = 0; i <= diffDate; i++) {
            
            DateTime plotDate = DateTime.newInstance(SD.addDays(i).year(), SD.addDays(i).month(), SD.addDays(i).day());
            string actualDay = plotDate.format('d');
            string actualMonth = plotDate.format('MMM');
            string actualYear = plotDate.format('yy');
            
            dailyClearanceCertificateChartSeries.categories.add(actualDay + '-' + actualMonth + '-' + actualYear);
        }
        
        
        WAP_DTO.DashboardChartSerieItemDTO serie = new WAP_DTO.DashboardChartSerieItemDTO();
        serie.name = 'No. of Clearance';
        serie.color = '#7b71b2';
        //serie.data = new List<decimal> { 50, 60, 30, 100, 60 };
        serie.data = new List<decimal>();
        //dailyClearanceCertificateChartSeries.series.add(serie);
        
        WAP_DTO.DashboardChartSerieItemDTO hrwSerie = new WAP_DTO.DashboardChartSerieItemDTO();
        hrwSerie.name = 'HRW';
        hrwSerie.color = '#efd590';
        //hrwSerie.data = new List<decimal> { 25, 50, 10, 70, 40 };
        hrwSerie.data = new List<decimal>();
        //dailyClearanceCertificateChartSeries.series.add(hrwSerie);
        
        if(WorkClearances.size() > 0) {
            
            for(integer i = 0; i <= diffDate; i++) {
                
                integer total = 0;
                integer hrw = 0;
                
                for(Work_Clearance__c WC : WorkClearances) {
                    
                    if(string.isEmpty(WC.High_Risk_Work__c)) {
                        WC.High_Risk_Work__c = '10';
                    }
                    
                 	if(WC.Authorized_Date_UI__c == SD.addDays(i)) {
                        total++;
                        
                        if(WC.High_Risk_Work__c != '0' && WC.High_Risk_Work__c != '10') {
                            hrw++;
                        }
                        
                    }
                    
                }
                
                serie.data.add(total);
                hrwSerie.data.add(hrw);
            }
            
        	dailyClearanceCertificateChartSeries.series.add(serie);
        	dailyClearanceCertificateChartSeries.series.add(hrwSerie);
            
        }
        
        return dailyClearanceCertificateChartSeries;
    }
    
    @RemoteAction
    public static List<WAP_DTO.DashboardChartSeriesDTO> DetailReportByAreaChartSeries(SearchFilter filter) {
        
        detailReportByAreaChartSeries = new List<WAP_DTO.DashboardChartSeriesDTO>();
        
        Set<string> areas = new Set<string>();
        List<Work_Clearance__c> WorkClearances = new List<Work_Clearance__c>();
        
        string query = 'select id, name, Area__c, Functional_Location__c, FunctionalLocation__c, FunctionalLocation__r.Latitude__c, FunctionalLocation__r.Longitude__c, ' + 
            			'FunctionalLocation__r.Description__c, User_Status__c, High_Risk_Work__c, Main_Work_Center_Text__c, Work_Detail__c, ' +
            			'Safety_Permit1__c, Safety_Permit2__c, Safety_Permit3__c, IsCheckingGas__c, Flamable_amt__c, Oxygen_amt__c, Toxic_PPM__c, ' +
            			'AGT_UI__c, Check_Date_UI__c, Check_Time_UI__c, Authorized_Signatory_UI__c, Authorized_Date_UI__c, Authorized_Time_UI__c, ' + 
            			'Extend_Time_Flag_Formula__c, Extend_Date__c, Extend_Time__c, Extend_Time_To_UI__c, Extend_Applicant_or_Bearer_UI__c, ' +
            			'Extend_Authorized_Sign_UI__c, Close_Applicant_or_Bearer_UI__c, Close_Authorized_Sign_off_UI__c, Work_Clearance_Status__c, Plant_Section__c ' +
            			'from Work_Clearance__c';
        
        date todayDate = date.today();
        
        //filter.startDate
        date SD = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        query = query + ' WHERE Authorized_Date_UI__c >=: SD';
        
        //filter.endDate
        date ED = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        query = query + ' AND Authorized_Date_UI__c <=: ED';
        
        WorkClearances = database.query(query + ' order by area__c asc');
            
        if(WorkClearances.size() > 0) {
            
            for(Work_Clearance__c WC : WorkClearances) {
                if(string.isnotempty(WC.Area__c)) {
                	areas.add(WC.Area__c);
                }
            }
            
        }
        
        //HWR and No. CC
        WAP_DTO.DashboardChartSeriesDTO hwr = new WAP_DTO.DashboardChartSeriesDTO();
        hwr.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        //hwr.categories = new List<string> { 'TOC1', 'TOC2', 'TOC3', 'TOC4', 'TOC5' };
        hwr.categories = new List<string>();
          
        WAP_DTO.DashboardChartSerieItemDTO serie = new WAP_DTO.DashboardChartSerieItemDTO();
        serie.name = 'No. of Clearance';
        serie.color = '#7b71b2';
        serie.data = new List<decimal>();
        //serie.data = new List<decimal> { 50, 60, 30, 100, 60 };
        //serie.series.add(serie);
        
        WAP_DTO.DashboardChartSerieItemDTO hwrSerie = new WAP_DTO.DashboardChartSerieItemDTO();
        hwrSerie.name = 'HRW';
        hwrSerie.color = '#efd590';
        hwrSerie.data = new List<decimal>();
        //hrwSerie.data = new List<decimal> { 25, 50, 10, 70, 40 };
        //hwr.series.add(hrwSerie);
        //detailReportByAreaChartSeries.add(hwr);
        
        //Summary Extend from normal hours
        WAP_DTO.DashboardChartSeriesDTO extend = new WAP_DTO.DashboardChartSeriesDTO();
        extend.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        extend.categories = new List<string>();
        //extend.categories = new List<string> { 'TOC1', 'TOC2', 'TOC3', 'TOC4', 'TOC5' };
        
        WAP_DTO.DashboardChartSerieItemDTO extendSerie = new WAP_DTO.DashboardChartSerieItemDTO();
        extendSerie.name = 'Extend';
        extendSerie.color = '#84b38d';
        extendSerie.data = new List<decimal>();
        //extendSerie.data = new List<decimal> { 5,6,3,10,60 };
        //extend.series.add(extendSerie);
        
        
        //Summary of non close CC (Number)
        WAP_DTO.DashboardChartSeriesDTO nonClose = new WAP_DTO.DashboardChartSeriesDTO();
        nonClose.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        nonClose.categories = new List<string>();
        //nonClose.categories = new List<string> { 'TOC1', 'TOC2', 'TOC3', 'TOC4', 'TOC5' };
        
        WAP_DTO.DashboardChartSerieItemDTO nonCloseSerie = new WAP_DTO.DashboardChartSerieItemDTO();
        nonCloseSerie.name = 'Non Close';
        nonCloseSerie.color = '#6d94c3';
        nonCloseSerie.data = new List<decimal>();
        //nonCloseSerie.data = new List<decimal> { 5,6,0,10,0 };
        //nonClose.series.add(nonCloseSerie);
                
        
        //Summary - Stop work
        WAP_DTO.DashboardChartSeriesDTO stopWork = new WAP_DTO.DashboardChartSeriesDTO();
        stopWork.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        stopWork.categories = new List<string>();
        //stopWork.categories = new List<string> { 'TOC1', 'TOC2', 'TOC3', 'TOC4', 'TOC5' };
        
        WAP_DTO.DashboardChartSerieItemDTO stopWorkSerie = new WAP_DTO.DashboardChartSerieItemDTO();
        stopWorkSerie.name = 'Stop Work';
        stopWorkSerie.color = '#d98283';
        stopWorkSerie.data = new List<decimal>();
        //stopWorkSerie.data = new List<decimal> { 1,1,2,2,0 };
        //stopWork.series.add(stopWorkSerie);
        
        if(areas.size() > 0) {
            for(string area : areas) {
                hwr.categories.add(area);
                extend.categories.add(area);
                nonClose.categories.add(area);
                stopWork.categories.add(area);
            }
        }
        
        if(WorkClearances.size() > 0) {
            
        	List<PTW_Header__c> PTWHeaders = [select id, status__c, Work_Clearance__c from PTW_Header__c order by createddate desc];
        
            for(string area : areas) {
                
                integer total = 0;
                integer hrw = 0;
                integer extendTotal = 0;
                integer nonCloseTotal = 0;
                integer stopWorkTotal = 0;
                
                for(Work_Clearance__c WC : WorkClearances) {
                    
                    if(string.isEmpty(WC.High_Risk_Work__c)) {
                        WC.High_Risk_Work__c = '10';
                    }
                    
                    //Finding HWR and No. CC
                 	if(WC.area__c == area) {
                        total++;
                        
                        if(WC.High_Risk_Work__c != '0' && WC.High_Risk_Work__c != '10') {
                            hrw++;
                        }
                        
                    }
                    
                    //Finding Summary extend from normal hours
                    if(WC.area__c == area && WC.Extend_Time_Flag_Formula__c) {
                        extendTotal++;
                    }
                    
                    //Finding Summary of Non Close CC (Number)
                    if(WC.area__c == area && WC.Authorized_Date_UI__c < todayDate && (WC.Work_Clearance_Status__c == 'In Progress' || WC.Work_Clearance_Status__c == 'Created')) {
                        nonCloseTotal++;
                    }
                    
                    //Finding Summary Stop Work
                    if(WC.area__c == area) {
                        PTW_Header__c PTWHeader = CheckPTWHeader(WC.Id, PTWHeaders);
                        if(PTWHeader != null && PTWHeaders.size() > 0 && string.isNotEmpty(PTWHeader.Status__c)) {
                            if(PTWHeader.Status__c == 'หยุดงานชั่วคราว' || PTWHeader.Status__c == 'หยุดงานถาวร') {
                                stopWorkTotal++;
                            }
                        }
                    }
                }
                
                serie.data.add(total);
                hwrSerie.data.add(hrw);
                extendSerie.data.add(extendTotal);
                nonCloseSerie.data.add(nonCloseTotal);
                stopWorkSerie.data.add(stopWorkTotal);
            }
            
        	hwr.series.add(serie);
        	hwr.series.add(hwrSerie);
            extend.series.add(extendSerie);
            nonClose.series.add(nonCloseSerie);
            stopWork.series.add(stopWorkSerie);
            
            detailReportByAreaChartSeries.add(hwr);
        	detailReportByAreaChartSeries.add(extend);
        	detailReportByAreaChartSeries.add(nonClose);
        	detailReportByAreaChartSeries.add(stopWork);
            
        }
        
        return detailReportByAreaChartSeries;
    }
    
    @RemoteAction
    public static List<WAP_DTO.DashboardChartSeriesDTO> ClearanceCertificateYearChartSeries(SearchFilter filter) {
        
        clearanceCeriticateYearChartSeries = new List<WAP_DTO.DashboardChartSeriesDTO>();
        
        Set<string> areas = new Set<string>();
        List<Work_Clearance__c> WorkClearances = new List<Work_Clearance__c>();
        
        string query = 'select id, name, Area__c, Functional_Location__c, FunctionalLocation__c, FunctionalLocation__r.Latitude__c, FunctionalLocation__r.Longitude__c, ' + 
            			'FunctionalLocation__r.Description__c, User_Status__c, High_Risk_Work__c, Main_Work_Center_Text__c, Work_Detail__c, ' +
            			'Safety_Permit1__c, Safety_Permit2__c, Safety_Permit3__c, IsCheckingGas__c, Flamable_amt__c, Oxygen_amt__c, Toxic_PPM__c, ' +
            			'AGT_UI__c, Check_Date_UI__c, Check_Time_UI__c, Authorized_Signatory_UI__c, Authorized_Date_UI__c, Authorized_Time_UI__c, ' + 
            			'Extend_Time_Flag_Formula__c, Extend_Date__c, Extend_Time__c, Extend_Time_To_UI__c, Extend_Applicant_or_Bearer_UI__c, ' +
            			'Extend_Authorized_Sign_UI__c, Close_Applicant_or_Bearer_UI__c, Close_Authorized_Sign_off_UI__c, Work_Clearance_Status__c, Plant_Section__c ' +
            			'from Work_Clearance__c';
        
        date todayDate = date.today();
        
        //filter.year
        integer year = Integer.ValueOf(filter.year);
        query = query + ' WHERE CALENDAR_YEAR(Authorized_Date_UI__c) =: year';
        
        WorkClearances = database.query(query + ' order by area__c asc');
            
        if(WorkClearances.size() > 0) {
            
            for(Work_Clearance__c WC : WorkClearances) {
                if(string.isnotempty(WC.Area__c)) {
                	areas.add(WC.Area__c);
                }
            }
            
        }
        
        //HWR and No. CC
        WAP_DTO.DashboardChartSeriesDTO hwr = new WAP_DTO.DashboardChartSeriesDTO();
        hwr.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        //hwr.categories = new List<string> { 'TOC1', 'TOC2', 'TOC3', 'TOC4', 'TOC5' };
        hwr.categories = new List<string>();
        
        WAP_DTO.DashboardChartSerieItemDTO serie = new WAP_DTO.DashboardChartSerieItemDTO();
        serie.name = 'No. of Clearance';
        serie.color = '#7b71b2';
        serie.data = new List<decimal>();
        //serie.data = new List<decimal> { 50, 60, 30, 100, 60 };
        //hwr.series.add(serie);
        
        WAP_DTO.DashboardChartSerieItemDTO hwrSerie = new WAP_DTO.DashboardChartSerieItemDTO();
        hwrSerie.name = 'HRW';
        hwrSerie.color = '#efd590';
        hwrSerie.data = new List<decimal>();
        //hwrSerie.data = new List<decimal> { 25, 50, 10, 70, 40 };
        //hwr.series.add(hwrSerie);
        
        //Summary Extend from normal hours
        WAP_DTO.DashboardChartSeriesDTO extend = new WAP_DTO.DashboardChartSeriesDTO();
        extend.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        extend.categories = new List<string>();
        //extend.categories = new List<string> { 'TOC1', 'TOC2', 'TOC3', 'TOC4', 'TOC5' };
        
        WAP_DTO.DashboardChartSerieItemDTO extendSerie = new WAP_DTO.DashboardChartSerieItemDTO();
        extendSerie.name = 'Extend';
        extendSerie.color = '#84b38d';
        extendSerie.data = new List<decimal>();
        //extendSerie.data = new List<decimal> { 5,6,3,10,60 };
        //extend.series.add(extendSerie);
        
        //Summary of non close CC (Number)
        WAP_DTO.DashboardChartSeriesDTO nonClose = new WAP_DTO.DashboardChartSeriesDTO();
        nonClose.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        nonClose.categories = new List<string>();
        //nonClose.categories = new List<string> { 'TOC1', 'TOC2', 'TOC3', 'TOC4', 'TOC5' };
        
        WAP_DTO.DashboardChartSerieItemDTO nonCloseSerie = new WAP_DTO.DashboardChartSerieItemDTO();
        nonCloseSerie.name = 'Non Close';
        nonCloseSerie.color = '#6d94c3';
        nonCloseSerie.data = new List<decimal>();
        //nonCloseSerie.data = new List<decimal> { 5,6,0,10,0 };
        //nonClose.series.add(nonCloseSerie);
        
        //Summary - Stop work
        WAP_DTO.DashboardChartSeriesDTO stopWork = new WAP_DTO.DashboardChartSeriesDTO();
        stopWork.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        stopWork.categories = new List<string>();
        //stopWork.categories = new List<string> { 'TOC1', 'TOC2', 'TOC3', 'TOC4', 'TOC5' };
        
        WAP_DTO.DashboardChartSerieItemDTO stopWorkSerie = new WAP_DTO.DashboardChartSerieItemDTO();
        stopWorkSerie.name = 'Stop Work';
        stopWorkSerie.color = '#d98283';
        stopWorkSerie.data = new List<decimal>();
        //stopWorkSerie.data = new List<decimal> { 1,1,2,2,0 };
        //stopWork.series.add(stopWorkSerie);
        
        if(areas.size() > 0) {
            for(string area : areas) {
                hwr.categories.add(area);
                extend.categories.add(area);
                nonClose.categories.add(area);
                stopWork.categories.add(area);
            }
        }
        
        if(WorkClearances.size() > 0) {
            
        	List<PTW_Header__c> PTWHeaders = [select id, status__c, Work_Clearance__c from PTW_Header__c order by createddate desc];
        
            for(string area : areas) {
                
                integer total = 0;
                integer hrw = 0;
                integer extendTotal = 0;
                integer nonCloseTotal = 0;
                integer stopWorkTotal = 0;
                
                for(Work_Clearance__c WC : WorkClearances) {
                    
                    if(string.isEmpty(WC.High_Risk_Work__c)) {
                        WC.High_Risk_Work__c = '10';
                    }
                    
                    //Finding HWR and No. CC
                 	if(WC.area__c == area) {
                        total++;
                        
                        if(WC.High_Risk_Work__c != '0' && WC.High_Risk_Work__c != '10') {
                            hrw++;
                        }
                    }
                    
                    //Finding Summary extend from normal hours
                    if(WC.area__c == area && WC.Extend_Time_Flag_Formula__c) {
                        extendTotal++;
                    }
                    
                    //Finding Summary of Non Close CC (Number)
                    if(WC.area__c == area && WC.Authorized_Date_UI__c < todayDate && (WC.Work_Clearance_Status__c == 'In Progress' || WC.Work_Clearance_Status__c == 'Created')) {
                        nonCloseTotal++;
                    }
                    
                    //Finding Summary Stop Work
                    if(WC.area__c == area) {
                        PTW_Header__c PTWHeader = CheckPTWHeader(WC.Id, PTWHeaders);
                        if(PTWHeader != null && PTWHeaders.size() > 0 && string.isNotEmpty(PTWHeader.Status__c)) {
                            if(PTWHeader.Status__c == 'หยุดงานชั่วคราว') {
                                stopWorkTotal++;
                            }
                        }
                    }
                }
                
                serie.data.add(total);
                hwrSerie.data.add(hrw);
                extendSerie.data.add(extendTotal);
                nonCloseSerie.data.add(nonCloseTotal);
                stopWorkSerie.data.add(stopWorkTotal);
            }
            
        	hwr.series.add(serie);
        	hwr.series.add(hwrSerie);
            extend.series.add(extendSerie);
            nonClose.series.add(nonCloseSerie);
            stopWork.series.add(stopWorkSerie);
            
            clearanceCeriticateYearChartSeries.add(hwr);
        	clearanceCeriticateYearChartSeries.add(extend);
        	clearanceCeriticateYearChartSeries.add(nonClose);
        	clearanceCeriticateYearChartSeries.add(stopWork);
            
        }
        
        return clearanceCeriticateYearChartSeries;
    }
    
    @RemoteAction
    public static string ExportClearanceCertificateExcel(string excelName, SearchFilter filter){
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/WAP_ClearanceDashboard_Excel';
            
        string year = String.ValueOf(filter.year);
        string area = String.ValueOf(filter.area);
        date startDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        date endDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        
        URL = URL + '?excelName=' + excelName + '&year=' + year + '&area=' + area + '&startDate=' + startDate + '&endDate=' + endDate;
        
        return URL;
    }
    
    //High Risk Work
    @RemoteAction
    public static WAP_DTO.DashboardPieChartSeriesDTO DashboardHRWPieChartSeries(SearchFilter filter) {
        
        dashboardHRWPieChartSeries = new WAP_DTO.DashboardPieChartSeriesDTO();
        dashboardHRWPieChartSeries.data = new List<WAP_DTO.DashboardPieChartSeriesItemDTO>();
        
        List<Work_Clearance__c> WorkClearances = new List<Work_Clearance__c>();
        
        string query = 'select id, name, Area__c, Functional_Location__c, FunctionalLocation__c, FunctionalLocation__r.Latitude__c, FunctionalLocation__r.Longitude__c, ' + 
            			'FunctionalLocation__r.Description__c, User_Status__c, High_Risk_Work__c, Main_Work_Center_Text__c, Work_Detail__c, ' +
            			'Safety_Permit1__c, Safety_Permit2__c, Safety_Permit3__c, IsCheckingGas__c, Flamable_amt__c, Oxygen_amt__c, Toxic_PPM__c, ' +
            			'AGT_UI__c, Check_Date_UI__c, Check_Time_UI__c, Authorized_Signatory_UI__c, Authorized_Date_UI__c, Authorized_Time_UI__c, ' + 
            			'Extend_Time_Flag_Formula__c, Extend_Date__c, Extend_Time__c, Extend_Time_To_UI__c, Extend_Applicant_or_Bearer_UI__c, ' +
            			'Extend_Authorized_Sign_UI__c, Close_Applicant_or_Bearer_UI__c, Close_Authorized_Sign_off_UI__c, Work_Clearance_Status__c, Plant_Section__c ' +
            			'from Work_Clearance__c';
        
        //filter.startDate
        date SD = filter.startDate;
        query = query + ' WHERE Authorized_Date_UI__c >=: SD';
        
        //filter.endDate
        date ED = filter.endDate;
        query = query + ' AND Authorized_Date_UI__c <=: ED';
        
        //filter.area
        if(string.isNotEmpty(filter.area) && filter.area.toLowerCase() != 'all') {
            string area = filter.area;
            query = query + ' AND Area__c =: area';
        }
        else {
            query = query + ' AND Area__c != null';
        }
        
        WorkClearances = database.query(query);
        
        integer hotWork = 0;
        integer confinedSpace = 0;
        integer crane = 0;
        integer radiation = 0;
        integer jackHammer = 0;
        integer highPressure = 0;
        integer digging = 0;
        integer workAtHeight = 0;
        integer onlineStopLeak = 0;
        
        if(WorkClearances.size() > 0) {
            
            for(Work_Clearance__c WC : WorkClearances) {
                
                if(string.isEmpty(WC.High_Risk_Work__c)) {
                    WC.High_Risk_Work__c = '10';
                }
                
                if(WC.High_Risk_Work__c != '0' && WC.High_Risk_Work__c != '10') {
                    System.debug(WC.High_Risk_Work__c);
                    if(WC.High_Risk_Work__c == '1') {
                        hotWork += 1;
                    }
                    else if(WC.High_Risk_Work__c == '2') {
                        confinedSpace += 1;
                    }
                    else if(WC.High_Risk_Work__c == '3') {
                        crane += 1;
                    }
                    else if(WC.High_Risk_Work__c == '4') {
                        radiation += 1;
                    }
                    else if(WC.High_Risk_Work__c == '5') {
                        jackHammer += 1;
                    }
                    else if(WC.High_Risk_Work__c == '6') {
                        highPressure += 1;
                    }
                    else if(WC.High_Risk_Work__c == '7') {
                        digging += 1;
                    }
                    else if(WC.High_Risk_Work__c == '8') {
                        workAtHeight += 1;
                    }
                    else if(WC.High_Risk_Work__c == '9') {
                        onlineStopLeak += 1;
                    }
                }
                
            }
        }
        
        WAP_DTO.DashboardPieChartSeriesItemDTO DashboardPieChart = new WAP_DTO.DashboardPieChartSeriesItemDTO();
        DashboardPieChart.name = 'Hot Work';
        DashboardPieChart.y = hotWork;
        DashboardPieChart.color = '#be5b5b';
        dashboardHRWPieChartSeries.data.add(DashboardPieChart);
        
        DashboardPieChart = new WAP_DTO.DashboardPieChartSeriesItemDTO();
        DashboardPieChart.name = 'Confined Space';
        DashboardPieChart.y = confinedSpace;
        DashboardPieChart.color = '#57679c';
        dashboardHRWPieChartSeries.data.add(DashboardPieChart);
        
        DashboardPieChart = new WAP_DTO.DashboardPieChartSeriesItemDTO();
        DashboardPieChart.name = 'Crane / Lifting';
        DashboardPieChart.y = crane;
        DashboardPieChart.color = '#72a77c';
        dashboardHRWPieChartSeries.data.add(DashboardPieChart);
        
        DashboardPieChart = new WAP_DTO.DashboardPieChartSeriesItemDTO();
        DashboardPieChart.name = 'Radiation';
        DashboardPieChart.y = radiation;
        DashboardPieChart.color = '#e7d47d';
        dashboardHRWPieChartSeries.data.add(DashboardPieChart);
        
        DashboardPieChart = new WAP_DTO.DashboardPieChartSeriesItemDTO();
        DashboardPieChart.name = 'Jack Hammer';
        DashboardPieChart.y = jackHammer;
        DashboardPieChart.color = '#8175c3';
        dashboardHRWPieChartSeries.data.add(DashboardPieChart);
        
        DashboardPieChart = new WAP_DTO.DashboardPieChartSeriesItemDTO();
        DashboardPieChart.name = 'High Pressure Water Jet';
        DashboardPieChart.y = highPressure;
        DashboardPieChart.color = '#73c1cc';
        dashboardHRWPieChartSeries.data.add(DashboardPieChart);
        
        DashboardPieChart = new WAP_DTO.DashboardPieChartSeriesItemDTO();
        DashboardPieChart.name = 'Digging';
        DashboardPieChart.y = digging;
        DashboardPieChart.color = '#9d6b57';
        dashboardHRWPieChartSeries.data.add(DashboardPieChart);
        
        DashboardPieChart = new WAP_DTO.DashboardPieChartSeriesItemDTO();
        DashboardPieChart.name = 'Work at Height';
        DashboardPieChart.y = workAtHeight;
        DashboardPieChart.color = '#da9666';
        dashboardHRWPieChartSeries.data.add(DashboardPieChart);
        
        DashboardPieChart = new WAP_DTO.DashboardPieChartSeriesItemDTO();
        DashboardPieChart.name = 'Online Stop Leak';
        DashboardPieChart.y = onlineStopLeak;
        DashboardPieChart.color = '#719bd1';
        dashboardHRWPieChartSeries.data.add(DashboardPieChart);
        
        return dashboardHRWPieChartSeries;
    }
    
    @RemoteAction
    public static WAP_DTO.DashboardHRWChartSeriesDTO DashboardHRWChartSeries(SearchFilter filter) {
        
        dashboardHRWChartSeries = new WAP_DTO.DashboardHRWChartSeriesDTO();
        dashboardHRWChartSeries.name = 'High Risk Work';
        dashboardHRWChartSeries.data = new List<WAP_DTO.DashboardHRWChartSerieItemDTO>();
        
        List<Work_Clearance__c> WorkClearances = new List<Work_Clearance__c>();
        
        string query = 'select id, name, Area__c, Functional_Location__c, FunctionalLocation__c, FunctionalLocation__r.Latitude__c, FunctionalLocation__r.Longitude__c, ' + 
            			'FunctionalLocation__r.Description__c, User_Status__c, High_Risk_Work__c, Main_Work_Center_Text__c, Work_Detail__c, ' +
            			'Safety_Permit1__c, Safety_Permit2__c, Safety_Permit3__c, IsCheckingGas__c, Flamable_amt__c, Oxygen_amt__c, Toxic_PPM__c, ' +
            			'AGT_UI__c, Check_Date_UI__c, Check_Time_UI__c, Authorized_Signatory_UI__c, Authorized_Date_UI__c, Authorized_Time_UI__c, ' + 
            			'Extend_Time_Flag_Formula__c, Extend_Date__c, Extend_Time__c, Extend_Time_To_UI__c, Extend_Applicant_or_Bearer_UI__c, ' +
            			'Extend_Authorized_Sign_UI__c, Close_Applicant_or_Bearer_UI__c, Close_Authorized_Sign_off_UI__c, Work_Clearance_Status__c, Plant_Section__c ' +
            			'from Work_Clearance__c';
        
        //filter.startDate
        date SD = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        query = query + ' WHERE Authorized_Date_UI__c >=: SD';
        
        //filter.endDate
        date ED = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        query = query + ' AND Authorized_Date_UI__c <=: ED';
        
        //filter.area
        if(string.isNotEmpty(filter.area) && filter.area.toLowerCase() != 'all') {
            string area = filter.area;
            query = query + ' AND Area__c =: area';
        }
        else {
            query = query + ' AND Area__c != null';
        }
        
        WorkClearances = database.query(query);
        
        integer hotWork = 0;
        integer confinedSpace = 0;
        integer crane = 0;
        integer radiation = 0;
        integer jackHammer = 0;
        integer highPressure = 0;
        integer digging = 0;
        integer workAtHeight = 0;
        integer onlineStopLeak = 0;
        
        if(WorkClearances.size() > 0) {
            
            for(Work_Clearance__c WC : WorkClearances) {
                
                if(string.isEmpty(WC.High_Risk_Work__c)) {
                    WC.High_Risk_Work__c = '10';
                }
                
                if(WC.High_Risk_Work__c != '0' && WC.High_Risk_Work__c != '10') {
                    if(WC.High_Risk_Work__c == '1') {
                        hotWork += 1;
                    }
                    else if(WC.High_Risk_Work__c == '2') {
                        confinedSpace += 1;
                    }
                    else if(WC.High_Risk_Work__c == '3') {
                        crane += 1;
                    }
                    else if(WC.High_Risk_Work__c == '4') {
                        radiation += 1;
                    }
                    else if(WC.High_Risk_Work__c == '5') {
                        jackHammer += 1;
                    }
                    else if(WC.High_Risk_Work__c == '6') {
                        highPressure += 1;
                    }
                    else if(WC.High_Risk_Work__c == '7') {
                        digging += 1;
                    }
                    else if(WC.High_Risk_Work__c == '8') {
                        workAtHeight += 1;
                    }
                    else if(WC.High_Risk_Work__c == '9') {
                        onlineStopLeak += 1;
                    }
                }
                
            }
        }
        
        WAP_DTO.DashboardHRWChartSerieItemDTO serie = new WAP_DTO.DashboardHRWChartSerieItemDTO();
        serie.name = 'Hot Work';
        serie.y = hotWork;
        serie.color = '#7b71b2';
        dashboardHRWChartSeries.data.add(serie);
        
        serie = new WAP_DTO.DashboardHRWChartSerieItemDTO();
        serie.name = 'Confined Space';
        serie.y = confinedSpace;
        serie.color = '#57679c';
        dashboardHRWChartSeries.data.add(serie);
        
        serie = new WAP_DTO.DashboardHRWChartSerieItemDTO();
        serie.name = 'Crane / Lifting';
        serie.y = crane;
        serie.color = '#72a77c';
        dashboardHRWChartSeries.data.add(serie);
        
        serie = new WAP_DTO.DashboardHRWChartSerieItemDTO();
        serie.name = 'Radiation';
        serie.y = radiation;
        serie.color = '#e7d47d';
        dashboardHRWChartSeries.data.add(serie);
        
        serie = new WAP_DTO.DashboardHRWChartSerieItemDTO();
        serie.name = 'Jack Hammer';
        serie.y = jackHammer;
        serie.color = '#8175c3';
        dashboardHRWChartSeries.data.add(serie);
        
        serie = new WAP_DTO.DashboardHRWChartSerieItemDTO();
        serie.name = 'High Pressure Water Jet';
        serie.y = highPressure;
        serie.color = '#73c1cc';
        dashboardHRWChartSeries.data.add(serie);
        
        serie = new WAP_DTO.DashboardHRWChartSerieItemDTO();
        serie.name = 'Digging';
        serie.y = digging;
        serie.color = '#9d6b57';
        dashboardHRWChartSeries.data.add(serie);
        
        serie = new WAP_DTO.DashboardHRWChartSerieItemDTO();
        serie.name = 'Work at Height';
        serie.y = workAtHeight;
        serie.color = '#da9666';
        dashboardHRWChartSeries.data.add(serie);
        
        serie = new WAP_DTO.DashboardHRWChartSerieItemDTO();
        serie.name = 'Online Stop Leak';
        serie.y = onlineStopLeak;
        serie.color = '#719bd1';
        dashboardHRWChartSeries.data.add(serie);
        
        return dashboardHRWChartSeries;
    }
    
    @RemoteAction
    public static WAP_DTO.DashboardChartSeriesDTO DashboardTopFiveChartSeries(SearchFilter filter) {
        
        topFiveChartSeries = new WAP_DTO.DashboardChartSeriesDTO();
        topFiveChartSeries.series = new List<WAP_DTO.DashboardChartSerieItemDTO>();
        
        List<AggregateResult> WorkClearances = new List<AggregateResult>();
        
        string query = 'select applicant_or_bearer__c, count(id) appCount from Work_Clearance__c where applicant_or_bearer__c != null';
        
        //filter.startDate
        date SD = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        query = query + ' AND Authorized_Date_UI__c >=: SD';
        
        //filter.endDate
        date ED = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        query = query + ' AND Authorized_Date_UI__c <=: ED';
        
        //filter.area
        if(string.isNotEmpty(filter.area) && filter.area.toLowerCase() != 'all') {
            string area = filter.area;
            query = query + ' AND Area__c =: area';
        }
        else {
            query = query + ' AND Area__c != null';
        }
        
        query = query + ' group by applicant_or_bearer__c order by count(id) desc LIMIT 5';
        
        WorkClearances = database.query(query);
        
        if(WorkClearances.size() > 0) {
            
            topFiveChartSeries.categories = new List<string>();
                
            for(integer i = 0; i < WorkClearances.size(); i++) {
                
                string app = WorkClearances[i].get('applicant_or_bearer__c').toString();
                String str = app.SubStringBefore(' ');
                Decimal appCount = (Decimal)WorkClearances[i].get('appCount');
                topFiveChartSeries.categories.add(app);
                
                WAP_DTO.DashboardChartSerieItemDTO serie = new WAP_DTO.DashboardChartSerieItemDTO();
                serie.name = str;
                serie.data = new List<decimal> { appCount };
                serie.color = '#6d94c3';
                topFiveChartSeries.series.add(serie);
                
            }
            
        }

        return topFiveChartSeries;
    }
    
    @RemoteAction
    public static string ExportHighRiskWorkExcel(SearchFilter filter){
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/WAP_HRWDashboard_Excel';
            
        string area = String.ValueOf(filter.area);
        date startDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        date endDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        
        URL = URL + '?area=' + area + '&startDate=' + startDate + '&endDate=' + endDate;
        
        return URL;
    }
    
    @RemoteAction
    public static Set<string> allAreas() {
        
        Set<string> Areas = new Set<string>();
        List<AggregateResult> WorkClearances = new List<AggregateResult>();
        
        string query = 'select Area__c from Work_Clearance__c where Area__c != null AND Authorized_Date_UI__c != null group by Area__c order by Area__c';
        
        WorkClearances = database.query(query);
        
        if(WorkClearances.size() > 0) {
            for(AggregateResult WC : WorkClearances) {
                Areas.add(WC.get('Area__c').toString());
            }
        }
        
        return Areas;
        
    }
    
    public static PTW_Header__c CheckPTWHeader(string workClearanceId, List<PTW_Header__c> PTWHeaders) {
        
        PTW_Header__c existPTWHeader = new PTW_Header__c();
        if(PTWHeaders.size() > 0) {
            for(PTW_Header__c PTW : PTWHeaders) {
                if(PTW.Work_Clearance__c == workClearanceId) {
                    existPTWHeader = PTW;
                    break;
                }
            }
        }
        
        return existPTWHeader;
    }
    
    public class SearchFilter {
        @RemoteAction
        public string area {get;set;}
        @RemoteAction
        public string year {get;set;}
        @RemoteAction
        public date startDate {get;set;}
        @RemoteAction
        public date endDate {get;set;}
    }
}