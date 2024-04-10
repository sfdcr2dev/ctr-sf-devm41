/* 
 * Author Softever
 */

public with sharing class WAP_ClearanceDashboardExcelController {

    public string excelName {get;set;}
    public string year {get;set;}
    public string area {get;set;}
    public date startDate {get;set;}
    public date endDate {get;set;}
    public date todayDate {get;set;}
    
    public List<WAPClearanceDashboardWrapper> CDWs {get;set;}

    public class WAPClearanceDashboardWrapper {
        public string clearanceNo {get;set;}
        public date workingDate {get;set;}
        public time workingTime {get;set;}
        public string typeOfWork {get;set;}
        public string area {get;set;}
        public string requestExtended {get;set;}
        public date extendedDate {get;set;}
        public time extendedTime {get;set;}
        public time extendingTime {get;set;}
        public string status {get;set;}
    }

    public void OnloadExcel() {
    
        excelName = ApexPages.currentPage().getParameters().get('excelName');
        year = ApexPages.currentPage().getParameters().get('year');
        area = ApexPages.currentPage().getParameters().get('area');
        startDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startDate'));
        endDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endDate'));
        
        todayDate = date.today();
        
        Set<string> areas = new Set<string>();
        List<Work_Clearance__c> WorkClearances = new List<Work_Clearance__c>();
        
        CDWs = new List<WAPClearanceDashboardWrapper>();
        
        if(excelName == 'daily') {
        
            string query = 'select id, name, Area__c, Authorized_Date_UI__c, Authorized_Time_UI__c, High_Risk_Work__c, Extend_Time_Flag_Formula__c, Extend_Date__c, Extend_Time__c, ' + 
                        'Extend_Time_To_UI__c, Work_Clearance_Status__c from Work_Clearance__c';
        
            //filter.startDate
            query = query + ' WHERE Authorized_Date_UI__c >=: startDate';
            
            //filter.endDate
            query = query + ' AND Authorized_Date_UI__c <=: endDate';
            
            if(area.toLowerCase() != 'all') {
                query = query + ' AND Area__c =: area';
            }
            else {
                query = query + ' AND Area__c != null';
            }
            
            WorkClearances = database.query(query + ' order by area__c asc');
            
            if(WorkClearances.size() > 0) {
                for(Work_Clearance__c WC : WorkClearances) {
                    
                    WAPClearanceDashboardWrapper CDW = new WAPClearanceDashboardWrapper();
                    CDW.clearanceNo = WC.Name;
                    CDW.workingDate = WC.Authorized_Date_UI__c;
                    CDW.workingTime = WC.Authorized_Time_UI__c;
                    CDW.typeOfWork = WC.High_Risk_Work__c;
                    CDW.area = WC.Area__c;
                    
                    if(WC.Extend_Time_Flag_Formula__c) {
                        CDW.requestExtended = 'มี';
                    }
                    else if(!WC.Extend_Time_Flag_Formula__c) {
                        CDW.requestExtended = 'ไม่มี';
                    }
                    
                    CDW.extendedDate = WC.Extend_Date__c;
                    CDW.extendedTime = WC.Extend_Time_To_UI__c;
                    CDW.extendingTime = WC.Extend_Time_To_UI__c;
                    CDW.status = WC.Work_Clearance_Status__c;
                    CDWs.add(CDW);
                    
                }
            }
            
        }
        else if(excelName == 'detail') {
        
            string query = 'select id, name, Area__c, Authorized_Date_UI__c, Authorized_Time_UI__c, High_Risk_Work__c, Extend_Time_Flag_Formula__c, Extend_Date__c, Extend_Time__c, ' + 
                        'Extend_Time_To_UI__c, Work_Clearance_Status__c from Work_Clearance__c';
        
            //filter.startDate
            query = query + ' WHERE Authorized_Date_UI__c >=: startDate';
            
            //filter.endDate
            query = query + ' AND Authorized_Date_UI__c <=: endDate';
            
            query = query + ' AND Area__c != null';
            
            WorkClearances = database.query(query + ' order by area__c asc');
            
            if(WorkClearances.size() > 0) {
                for(Work_Clearance__c WC : WorkClearances) {
                    
                    WAPClearanceDashboardWrapper CDW = new WAPClearanceDashboardWrapper();
                    CDW.clearanceNo = WC.Name;
                    CDW.workingDate = WC.Authorized_Date_UI__c;
                    CDW.workingTime = WC.Authorized_Time_UI__c;
                    CDW.typeOfWork = WC.High_Risk_Work__c;
                    CDW.area = WC.Area__c;
                    
                    if(WC.Extend_Time_Flag_Formula__c) {
                        CDW.requestExtended = 'มี';
                    }
                    else if(!WC.Extend_Time_Flag_Formula__c) {
                        CDW.requestExtended = 'ไม่มี';
                    }
                    
                    CDW.extendedDate = WC.Extend_Date__c;
                    CDW.extendedTime = WC.Extend_Time_To_UI__c;
                    CDW.extendingTime = WC.Extend_Time_To_UI__c;
                    CDW.status = WC.Work_Clearance_Status__c;
                    CDWs.add(CDW);
                    
                }
            }
            
        }
        else if(excelName == 'clearance') {
        
            string query = 'select id, name, Area__c, Authorized_Date_UI__c, Authorized_Time_UI__c, High_Risk_Work__c, Extend_Time_Flag_Formula__c, Extend_Date__c, Extend_Time__c, ' + 
                        'Extend_Time_To_UI__c, Work_Clearance_Status__c from Work_Clearance__c';
        
            integer filterYear = Integer.ValueOF(year);
            
            query = query + ' WHERE Authorized_Date_UI__c != null AND CALENDAR_YEAR(Authorized_Date_UI__c) =: filterYear';
            
            query = query + ' AND Area__c != null';
            system.debug(query);
            WorkClearances = database.query(query + ' order by area__c asc');
            
            if(WorkClearances.size() > 0) {
                for(Work_Clearance__c WC : WorkClearances) {
                    
                    WAPClearanceDashboardWrapper CDW = new WAPClearanceDashboardWrapper();
                    CDW.clearanceNo = WC.Name;
                    CDW.workingDate = WC.Authorized_Date_UI__c;
                    CDW.workingTime = WC.Authorized_Time_UI__c;
                    CDW.typeOfWork = WC.High_Risk_Work__c;
                    CDW.area = WC.Area__c;
                    
                    if(WC.Extend_Time_Flag_Formula__c) {
                        CDW.requestExtended = 'มี';
                    }
                    else if(!WC.Extend_Time_Flag_Formula__c) {
                        CDW.requestExtended = 'ไม่มี';
                    }
                    
                    CDW.extendedDate = WC.Extend_Date__c;
                    CDW.extendedTime = WC.Extend_Time_To_UI__c;
                    CDW.extendingTime = WC.Extend_Time_To_UI__c;
                    CDW.status = WC.Work_Clearance_Status__c;
                    CDWs.add(CDW);
                    
                }
            }
            
        }
    
    }
    
    //assign DTO
    private static WAP_DTO.SafetyPermitReportDTO assignToSafetyPermitReportDTO(Safety_Permit__c SP) {
        
        WAP_DTO.SafetyPermitReportDTO SafetyPermit = new WAP_DTO.SafetyPermitReportDTO();
        SafetyPermit.Id = SP.Id;
        SafetyPermit.no = SP.name;
        SafetyPermit.detail = SP.Work_Detail__c;
        SafetyPermit.workingArea = SP.Plant_Section__c;
        SafetyPermit.startDate = SP.Permit_to_Work_Date__c;
        SafetyPermit.endDate = SP.Expired_Date_1__c;
        SafetyPermit.firstExtendDate = SP.Expired_Date_1__c;
        SafetyPermit.secondExtendDate = SP.Expired_Date_2__c;
        SafetyPermit.thirdExtendDate = SP.Expired_Date_3__c;
            
        return SafetyPermit;
        
    }

}