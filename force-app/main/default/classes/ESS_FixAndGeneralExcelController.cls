public with sharing class ESS_FixAndGeneralExcelController {

    public integer fagSize {get;set;}
    public string todayDate {get;set;}
    public integer year {get;set;}
    public string todayTime {get;set;}
    public string reportName {get;set;}
    public string typeOfService {get;set;}
    public string monthName {get;set;}
    
    public List<ESS_FixAndGeneral_DTO.FixAndGeneralExcelDTO> fagTables {get;set;}
    
    public void OnloadExcel() {
    
        year = datetime.now().year();
        todayDate = datetime.now().format('dd-MM-yyyy');
        todayTime = datetime.now().format('HH:mm');
        string userId = ESS_PrivilegeHandler.getUserId();
        fagSize = 0;
        fagTables = new List<ESS_FixAndGeneral_DTO.FixAndGeneralExcelDTO>();
        
        ESS_FixAndGeneral.FixAndGeneralForAdminListFilter filter = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
        filter.typeOfServices = ApexPages.currentPage().getParameters().get('typeOfServices');
        if(ApexPages.currentPage().getParameters().get('month') != null && ApexPages.currentPage().getParameters().get('month') != 'null') {
            filter.month = Integer.ValueOf(ApexPages.currentPage().getParameters().get('month'));
        }
        if(ApexPages.currentPage().getParameters().get('year') != null && ApexPages.currentPage().getParameters().get('year') != 'null') {
            filter.year = Integer.ValueOf(ApexPages.currentPage().getParameters().get('year'));
            monthName = getMonthName(filter.month);
        }
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        
        string query = ESS_FixAndGeneral.getFixAndGeneralDetailQuery();
        query += ' where id != null';
        
        boolean isPMSV = ESS_PrivilegeHandler.checkPMSVUser(userId);
        boolean isPMSVFixAndGeneralAdmin = ESS_PrivilegeHandler.checkPMSVFixAndGeneralAdminUser(userId);
        boolean isPMSVTransportationAdmin = ESS_PrivilegeHandler.checkPMSVTransportationAdminUser(userId);
        if (!isPMSV && !isPMSVFixAndGeneralAdmin && !isPMSVTransportationAdmin) {
            query +=  ' and ((Status__c != \'OnProcess\' or Status__c != \'Completed\' or Status__c != \'Waiting\') or (PMSV_Id__c = :userId))';
        }
        
        if (filter != null) {
            if (string.isNotBlank(filter.typeOfServices)) {
                List<string> typeOfServices = filter.typeOfServices.split(',');
                query += ' and Type_of_Service__c in :typeOfServices';
                
                typeOfService = typeOfServices.toString().replace('(','').replace(')','');
                
                if(typeOfService == ESS_Enum.FixTypeOfService.OfficeEquipment.name()) {
                    reportName = 'Maintenance Service Report';
                }
                else if(typeOfService == ESS_Enum.FixTypeOfService.Housing.name()) {
                    reportName = 'Housing Repair Report';
                }
                else if(typeOfService == ESS_Enum.FixTypeOfService.Transportation.name()) {
                    reportName = 'Transportation Service Report';
                }
                else if(typeOfService == ESS_Enum.FixTypeOfService.GeneralService.name()) {
                    reportName = 'General Service Report';
                }
            }
            if (filter.month != null && filter.month != 0) {
                integer month = filter.month;
                query += ' and CALENDAR_MONTH(CreatedDate) = :month';
            }
            if (filter.year != null){
                integer year = integer.valueof(filter.year);
                query = query + ' AND CALENDAR_YEAR(CreatedDate) =: year';
            }
        }

        query += ' order by createddate desc';
        List<ESS_FixAndGeneral__c> models = Database.query(query);
        for (ESS_FixAndGeneral__c model : models) {
        
            if(model.type_of_service__c == ESS_Enum.FixTypeOfService.Transportation.name()) {
                if (string.isNotBlank(model.Transportation_Items__c)) {
                    List<ESS_FixAndGeneral_DTO.TransportationItemDTO> items = (List<ESS_FixAndGeneral_DTO.TransportationItemDTO>)JSON.deserialize(model.Transportation_Items__c, List<ESS_FixAndGeneral_DTO.TransportationItemDTO>.class);
                    if(items.size() > 0) {
                        for(ESS_FixAndGeneral_DTO.TransportationItemDTO item : items) {
                            fagTables.add(assignToFixAndGeneralDetailDTO(model, item));
                        }
                    }
                }
            }
            else {
                fagTables.add(assignToFixAndGeneralDetailDTO(model, null));
            }
        }
        
        fagSize = fagTables.size();

    }
    
    private static ESS_FixAndGeneral_DTO.FixAndGeneralExcelDTO assignToFixAndGeneralDetailDTO(ESS_FixAndGeneral__c model, ESS_FixAndGeneral_DTO.TransportationItemDTO item){
        string userId = ESS_PrivilegeHandler.getUserId();

        ESS_FixAndGeneral_DTO.FixAndGeneralExcelDTO result = new ESS_FixAndGeneral_DTO.FixAndGeneralExcelDTO();
        result.documentNo = model.Document_No__c;
        if(model.On_Behalf_Flow__c) {
            result.documentType = 'ดำเนินการแทน';
        }
        else {
            result.documentType = 'ดำเนินการเอง';
        }
        result.serviceType = ESS_Enum.getFixTypeOfServiceValue(ESS_Enum.FixTypeOfService.valueOf(model.Type_of_Service__c));
        result.topic = model.topic__c;
        result.detail = model.detail__c;
        if(model.repair_date__c != null) {
            result.repairDate = ESS_Global.convertDateTimeForExcel(model.repair_date__c);
            result.repairTime = result.repairDate;
        }
        if(model.expected_due_date__c != null) {
            result.expectedDueDate = ESS_Global.convertDateTimeForExcel(model.expected_due_date__c);
        }
        result.repairArea = model.areas__c;
        result.building = model.buildings__c;
        result.floor = model.floors__c;
        result.houseNo = model.house_no__c;
        result.period = model.period__c;
        
        if(model.type_of_service__c == ESS_Enum.FixTypeOfService.Housing.name()) {
            if(string.isnotempty(model.house_type__c)) {
                result.houseType = ESS_Enum.getHousingType(ESS_Enum.HousingType.valueOf(model.house_type__c));
            }
        }
        if(string.isnotempty(model.tel_no__c)) {
            result.telNo = model.tel_no__c;
        }
        else {
            result.telNo = '';
        }
        if(string.isnotempty(model.mobile_no__c)) {
            result.mobileNo = model.mobile_no__c;
        }
        else {
            result.mobileNo = '';
        }
        
        if(model.type_of_service__c == ESS_Enum.FixTypeOfService.OfficeEquipment.name()) {
            if(string.isnotempty(model.office_type_of_service__c)) {
                result.typeOfService = ESS_Enum.getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService.valueOf(model.office_type_of_service__c));
            }
            result.typeOfServiceOther = model.office_type_of_service_other__c;
            result.cost = model.office_cost__c;
            result.moreDetail = model.office_detail__c;
            result.internalDetail = model.office_internal_detail__c;
        }
        else if(model.type_of_service__c == ESS_Enum.FixTypeOfService.Housing.name()) {
            if(string.isnotempty(model.housing_type_of_service__c)) {
                result.typeOfService = ESS_Enum.getHousingTypeOfServiceValue(ESS_Enum.HousingTypeOfService.valueOf(model.housing_type_of_service__c));
            }
            result.typeOfServiceOther = model.housing_type_of_service_other__c;
            result.cost = model.housing_cost__c;
            result.moreDetail = model.housing_detail__c;
            result.internalDetail = model.housing_internal_detail__c;
        }
        else if(model.type_of_service__c == ESS_Enum.FixTypeOfService.Transportation.name()) {
            if(string.isnotempty(model.transportation_type_of_service__c)) {
                result.typeOfService = ESS_Enum.getTransportationTypeOfServiceValue(ESS_Enum.TransportationTypeOfService.valueOf(model.transportation_type_of_service__c));
            }
            result.typeOfServiceOther = model.transportation_type_of_service_other__c;
            result.cost = model.transportation_cost__c;
            result.moreDetail = model.transportation_detail__c;
            result.internalDetail = model.transportation_internal_detail__c;
            result.location = model.location__c;
            result.transportationType = item.transportationType.value;
            result.transportationNo = item.transportationNo;
            result.transportationDetail = item.detail;
        }
        else if(model.type_of_service__c == ESS_Enum.FixTypeOfService.GeneralService.name()) {
            if(string.isnotempty(model.general_type_of_service__c)) {
                result.typeOfService = ESS_Enum.getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService.valueOf(model.general_type_of_service__c));
            }
            result.typeOfServiceOther = model.general_type_of_service_other__c;
            result.cost = model.general_cost__c;
            result.moreDetail = model.general_detail__c;
            result.internalDetail = model.general_internal_detail__c;
        }
        result.requesterName = model.requester_name_en__c;
        if(string.isnotempty(model.requester_employee_id__c)) {
            result.requesterEmployeeId = model.requester_employee_id__c;
        }
        else {
            result.requesterEmployeeId = '';
        }
        result.requesterEmail = model.requester_email__c;
        result.requesterPosition = model.requester_position__c;
        result.requesterFunction = model.requester_function__c;
        result.requesterDepartment = model.requester_department__c;
        result.requesterSection = model.requester_section__c;
        result.requesterUnit = model.requester_unit__c;
        result.obhName = model.on_behalf_of_en__c;
        if(string.isnotempty(model.on_behalf_of_employee_id__c)) {
            result.obhEmployeeId = model.on_behalf_of_employee_id__c;
        }
        else {
            result.obhEmployeeId = '';
        }
        result.obhEmail = model.on_behalf_of_email__c;
        result.obhPosition = model.on_behalf_of_position__c;
        result.obhFunction = model.on_behalf_of_function__c;
        result.obhDepartment = model.on_behalf_of_department__c;
        result.obhSection = model.on_behalf_of_section__c;
        result.obhUnit = model.on_behalf_of_unit__c;
        
        result.verifyStatus = '';
        result.obhComment = '';
        if(model.on_behalf_flow__c) {
            if(model.verified_date__c != null && model.rejected_date__c == null) {
                //result.obhComment = model.verify_comment__c;
                result.verifyStatus = 'Verify';
                result.verifiedRejectedDate = model.verified_date__c;
            }
            else if((model.verified_date__c == null && model.rejected_date__c != null) ||
                    model.verified_date__c != null && model.rejected_date__c != null) {
                result.obhComment = model.reject_comment__c;
                result.verifyStatus = 'Reject';
                result.verifiedRejectedDate = model.rejected_date__c;
            }
        }
        
        result.createdDate = ESS_Global.convertDateTimeForExcel(model.createddate);
        if(model.submitted_date__c != null) { result.submittedDate = ESS_Global.convertDateTimeForExcel(model.submitted_date__c); }
        if(model.verified_date__c != null) { result.verifiedDate = ESS_Global.convertDateTimeForExcel(model.verified_date__c); }
        if(model.accepted_date__c != null) { result.acceptedDate = ESS_Global.convertDateTimeForExcel(model.accepted_date__c); }
        if(model.completed_date__c != null) { result.completedDate = ESS_Global.convertDateTimeForExcel(model.completed_date__c); }
        if(model.rejected_date__c != null) { result.rejectedDate = ESS_Global.convertDateTimeForExcel(model.rejected_date__c); }
        if(model.cancelled_date__c != null) { result.cancelledDate = ESS_Global.convertDateTimeForExcel(model.cancelled_date__c); }
        result.acceptedBy = model.pmsv__c;
        result.completedBy = model.completed_by__c;
        result.cancelledBy = model.cancelled_by__c;
        result.rejectComment = model.reject_comment__c;
        result.cancelComment = model.cancel_comment__c;
        result.currentStatus = model.status__c;
        result.requesterRatingCompleted = false;
        if(model.rating_date__c != null) {
            result.requesterRatingCompleted = true;
        }
        result.requesterRating = integer.valueOf(model.rating_score__c);
        result.requesterAttentiveness = model.attentiveness_rating__c;
        result.requesterFast = model.fast_rating__c;
        result.requesterPunctuality = model.punctuality_rating__c;
        result.requesterExpertise = model.expertise_rating__c;
        
        result.obhRatingCompleted = false;
        if(model.rating_date_2__c != null) {
            result.obhRatingCompleted = true;
        }
        result.obhRating = integer.valueOf(model.rating_score_2__c);
        result.obhAttentiveness = model.attentiveness_rating_2__c;
        result.obhFast = model.fast_rating_2__c;
        result.obhPunctuality = model.punctuality_rating_2__c;
        result.obhExpertise = model.expertise_rating_2__c;
        return result;
    }
    
    public static string getMonthName(integer month) {
        string monthName = '';
        if(month == 1) {
            monthName = 'January';
        }
        else if(month == 2) {
            monthName = 'February';
        }
        else if(month == 3) {
            monthName = 'March';
        }
        else if(month == 4) {
            monthName = 'April';
        }
        else if(month == 5) {
            monthName = 'May';
        }
        else if(month == 6) {
            monthName = 'June';
        }
        else if(month == 7) {
            monthName = 'July';
        }
        else if(month == 8) {
            monthName = 'August';
        }
        else if(month == 9) {
            monthName = 'September';
        }
        else if(month == 10) {
            monthName = 'October';
        }
        else if(month == 11) {
            monthName = 'November';
        }
        else if(month == 12) {
            monthName = 'December';
        }
        else {
            monthName = 'ALL';
        }
        
        return monthName;
    }

}