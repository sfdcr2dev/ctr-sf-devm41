/* 
 * Author Softever
 */

public with sharing class WAP_SafetyPermitReportExcelController {

    public date todayDate {get;set;}
    public List<WAP_DTO.SafetyPermitReportDTO> SafetyPermitDTOs {get;set;}
    
    public void OnloadExcel() {
    
        todayDate = date.today();
        
        SafetyPermitDTOs = new List<WAP_DTO.SafetyPermitReportDTO>();
        
        WAP_SafetyPermitReport.SearchFilter filter = new WAP_SafetyPermitReport.SearchFilter();
    
        filter.year = ApexPages.currentPage().getParameters().get('year');
        filter.area = ApexPages.currentPage().getParameters().get('area');
        filter.startDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startDate'));
        filter.endDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endDate'));
        
        List<Safety_Permit__c> SafetyPermits = new List<Safety_Permit__c>();
        
        string query = 'select id, name, Work_Detail__c, Plant_Section__c, Permit_to_Work_Date__c, Expired_Date_1__c, Expired_Date_2__c , ' + 
                        'Expired_Date_3__c, Extended_From_Date_1__c, Extended_From_Date_2__c, Extended_From_Date_3__c, Extend_Certificate__c from Safety_Permit__c';

        //filter.year
        if(string.isNotEmpty(filter.year)) {
            integer year = Integer.ValueOf(filter.year);
            query = query + ' WHERE CALENDAR_YEAR(Permit_to_Work_Date__c) =: year';
        }
        
        //filter.area
        if(filter.area.toLowerCase() != 'all') {
            string area = filter.area;
            query = query + ' AND Plant_Section__c =: area';
        }
        
        //filter.startDate
        date startDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.startDate));
        query = query + ' AND Permit_to_Work_Date__c >=: startDate';
        
        //filter.endDate
        date endDate = Date.ValueOf(WAP_Global.convertDateTimeFilter(filter.endDate));
        query = query + ' AND Permit_to_Work_Date__c <=: endDate';
        
        query = query + ' order by Plant_Section__c asc';
        
        SafetyPermits = database.query(query);
        
        if(SafetyPermits.size() > 0) {
            for(Safety_Permit__c SP : SafetyPermits) {
            
                WAP_DTO.SafetyPermitReportDTO Safety = new WAP_DTO.SafetyPermitReportDTO();
                Safety = assignToSafetyPermitReportDTO(SP);
                
                SafetyPermitDTOs.add(Safety);
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

}