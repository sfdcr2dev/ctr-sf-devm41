/* 
 * Author Softever
 */

public with sharing class WAP_HRWDashboardExcelController {

    public date todayDate {get;set;}
    public List<WAPHRWWrapper> HRWs {get;set;}

    public class WAPHRWWrapper {
        public string clearanceNo {get;set;}
        public date workingDate {get;set;}
        public time workingTime {get;set;}
        public string typeOfWork {get;set;}
        public string area {get;set;}
        public string status {get;set;}
    }

    public void OnloadExcel() {
    
        todayDate = date.today();
        
        HRWs = new List<WAPHRWWrapper>();
        WAP_Dashboard.SearchFilter filter = new WAP_Dashboard.SearchFilter();
    
        filter.area = ApexPages.currentPage().getParameters().get('area');
        filter.startDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startDate'));
        filter.endDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endDate'));
        
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
        string area = filter.area;
        if(area.toLowerCase() != 'all') {
            query = query + ' AND Area__c =: area';
        }
        else {
            query = query + ' AND Area__c != null';
        }
        
        WorkClearances = database.query(query);
        system.debug(WorkClearances.size());
        if(WorkClearances.size() > 0) {
        
            for(Work_Clearance__c WC : WorkClearances) {
                    
                if(string.isEmpty(WC.High_Risk_Work__c)) {
                    WC.High_Risk_Work__c = '10';
                }
                
                WAPHRWWrapper HRW = new WAPHRWWrapper();
                HRW.clearanceNo = WC.name;
                HRW.workingDate = WC.Authorized_Date_UI__c;
                HRW.workingTime = WC.Authorized_Time_UI__c;
                HRW.typeOfWork = assignHighRiskWorkType(WC.High_Risk_Work__c);
                HRW.area = WC.Area__c;
                HRW.status = WC.Work_Clearance_Status__c;
                HRWs.add(HRW);
                
            }
        
        }
    }
    
    public static string assignHighRiskWorkType(string workType) {
        
        string workTypeNo = '0';
        
        if(workType == '0') {
            workTypeNo = WAP_Enum.HighRiskWorkType.General.name();
        }
        else if(workType == '1') {
            workTypeNo = WAP_Enum.HighRiskWorkType.HotWork.name();
        }
        else if(workType == '2') {
            workTypeNo = WAP_Enum.HighRiskWorkType.ConfinedSpace.name();
        }
        else if(workType == '3') {
            workTypeNo = WAP_Enum.HighRiskWorkType.Crane.name();
        }
        else if(workType == '4') {
            workTypeNo = WAP_Enum.HighRiskWorkType.Radiation.name();
        }
        else if(workType == '5') {
            workTypeNo = WAP_Enum.HighRiskWorkType.JackHammer.name();
        }
        else if(workType == '6') {
            workTypeNo = WAP_Enum.HighRiskWorkType.HighPressureWaterJet.name();
        }
        else if(workType == '7') {
            workTypeNo = WAP_Enum.HighRiskWorkType.Digging.name();
        }
        else if(workType == '8') {
            workTypeNo = WAP_Enum.HighRiskWorkType.WorkAtHigh.name();
        }
        else if(workType == '9') {
            workTypeNo = WAP_Enum.HighRiskWorkType.OnlineStopLeak.name();
        }
        else if(workType == '10') {
            workTypeNo = WAP_Enum.HighRiskWorkType.NonTypeOfWork.name();
        }
        
        return workTypeNo;
        
    }

}