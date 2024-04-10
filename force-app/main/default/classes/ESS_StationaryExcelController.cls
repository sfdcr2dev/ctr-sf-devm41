public with sharing class ESS_StationaryExcelController {

    public integer stationarySize {get;set;}
    public string todayDate {get;set;}
    public string todayTime {get;set;}
    public integer year {get;set;}
    public string monthName {get;set;}
    public string stationaryFrom {get;set;}
    
    public List<ESS_Stationary_DTO.StationaryExcelDTO> stationaryTables {get;set;}
    
    public void OnloadExcel() {
        
        year = datetime.now().year();
        todayDate = datetime.now().format('dd-MM-yyyy');
        todayTime = datetime.now().format('HH:mm');
        string userId = ESS_PrivilegeHandler.getUserId();
        stationarySize = 0;
        stationaryTables = new List<ESS_Stationary_DTO.StationaryExcelDTO>();
        
        ESS_Stationary.AdminSearchCriteria filter = new ESS_Stationary.AdminSearchCriteria();
        if(ApexPages.currentPage().getParameters().get('year') != null && ApexPages.currentPage().getParameters().get('year') != 'null') {
            filter.year = Integer.ValueOf(ApexPages.currentPage().getParameters().get('year'));
        }
        if(ApexPages.currentPage().getParameters().get('month') != null && ApexPages.currentPage().getParameters().get('month') != 'null') {
            filter.month = Integer.ValueOf(ApexPages.currentPage().getParameters().get('month'));
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

        string query = ESS_Stationary.getStationaryDetailQuery();

        //Add authorize filter
        query +=  ' where document_no__c != null'; 

        //From Privilege
        List<string> loginAs = ESS_PrivilegeHandler.StationaryLoginPrivilege();
        if(loginAs.size() > 0) {
            query += ' and Withdraw_From__c IN :loginAs';
            
            if(loginAs.size() == 1) {
                stationaryFrom = loginAs.tostring().replace('(','').replace(')','');
                if(stationaryFrom == ESS_Enum.StationaryWithdrawFrom.TSR.name()) {
                    stationaryFrom = 'PMSV';
                }
                else if(stationaryFrom == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
                    stationaryFrom = 'GSBO';
                }
            }
            else if(loginAs.size() > 1) {
                stationaryFrom = 'ALL';
            }
        }
        
        if (filter != null) {
            if (filter.year != null) {
                integer year = filter.year;
                query += ' and CALENDAR_YEAR(CreatedDate) = :year';
            }
            if (filter.month != null && filter.month != 0) {
                integer month = filter.month;
                query += ' and CALENDAR_MONTH(CreatedDate) = :month';
            }
        }
        
        query += ' order by createddate desc';
        Map<string, ESS_Master_Stationary__c> mapMasters = GetStationaryMasters();
        List<ESS_Stationary__c> models = Database.query(query);
        for (ESS_Stationary__c model : models) {
            
            ESS_Stationary_DTO.StationaryExcelDTO result = new ESS_Stationary_DTO.StationaryExcelDTO();
            
            //Withdraw Stock
            if(string.isNotBlank(model.Withdraw_From_Stock__c)) {
                List<ESS_Stationary_DTO.WithdrawDTO> withdrawStocks = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(model.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                if(withdrawStocks.size() > 0) {
                    for(integer j=0; j < withdrawStocks.size(); j++) {
                        result = new ESS_Stationary_DTO.StationaryExcelDTO();
                        result.typeOfStationary = ESS_Enum.StationaryType.General.name();
                        result.stationaryId = withdrawStocks[j].stationaryId;
                        result.stationaryName = withdrawStocks[j].name;
                        result.withdrawQuantity = integer.valueOf(withdrawStocks[j].quantity);
                        result.actualQuantity = integer.valueOf(withdrawStocks[j].actualWithdraw);
                        result.unit = withdrawStocks[j].unit;
                        result.price = integer.valueOf(withdrawStocks[j].pricePerUnit);
                        
                        ESS_Master_Stationary__c Master = mapMasters.get(withdrawStocks[j].recordId);
                        if(Master != null) {
                            result.stockOnHand = integer.valueOf(Master.stock_on_hand__c);
                        }
                        stationaryTables.add(assignToStationaryListDTO(model, result));
                    }
                }
            }
            //Withdraw Other
            if(string.isNotBlank(model.Withdraw_Other__c)) {
                List<ESS_Stationary_DTO.WithdrawDTO> withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(model.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
                if(withdrawOthers.size() > 0) {
                    for(integer j=0; j < withdrawOthers.size(); j++) {
                        result = new ESS_Stationary_DTO.StationaryExcelDTO();
                        result.typeOfStationary = ESS_Enum.StationaryType.Other.name();
                        result.stationaryId = withdrawOthers[j].stationaryId;
                        result.stationaryName = withdrawOthers[j].name;
                        result.withdrawQuantity = integer.valueOf(withdrawOthers[j].quantity);
                        result.actualQuantity = integer.valueOf(withdrawOthers[j].actualWithdraw);
                        result.unit = withdrawOthers[j].unit;
                        result.price = withdrawOthers[j].pricePerUnit;
                        stationaryTables.add(assignToStationaryListDTO(model, result));
                    }
                }
            }
        }
        
        stationarySize = stationaryTables.size();

    }
    
    private static ESS_Stationary_DTO.StationaryExcelDTO assignToStationaryListDTO(ESS_Stationary__c model, ESS_Stationary_DTO.StationaryExcelDTO result){
        string userId = ESS_PrivilegeHandler.getUserId();
        
        result.documentNo = model.Document_No__c;
        if(model.On_Behalf_Flow__c) {
            result.documentType = 'ดำเนินการแทน';
        }
        else {
            result.documentType = 'ดำเนินการเอง';
        }
        result.withdrawFrom = model.withdraw_from__c;
        result.serviceFor = model.service_for__c;
        result.location = model.location__c;
        if(string.isnotempty(model.internal_no__c)) {
            result.internalNo = model.internal_no__c;
        }
        else {
            result.internalNo = '';
        }
        if(string.isnotempty(model.mobile_no__c)) {
            result.mobileNo = model.mobile_no__c;
        }
        else {
            result.mobileNo = '';
        }
        result.needDate = model.need_date__c;
        result.totalStock = model.total_stock__c;
        result.totalOther = model.total_other__c;
        result.total = model.total__c;
        result.comment = model.comment__c;
        result.verifyStatus = '';
        result.obhComment = '';
        if(model.on_behalf_of_flow__c && model.on_behalf_of_verifying__c) {
            if(model.verified_date__c != null && model.rejected_date__c == null) {
                result.obhComment = model.verify_comment__c;
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
        result.approveStatus = '';
        result.userManagerComment = '';
        if(model.user_manager_flow__c) {
            if(model.approved_date__c != null) {
                result.userManagerComment = model.approved_comment__c;
                result.approvedRejectedDate = model.approved_date__c;
                result.approveStatus = 'Approved';
            }
            else if(model.approved_date__c == null && model.rejected_date__c != null) {
                result.userManagerComment = model.reject_comment__c;
                result.approvedRejectedDate = model.rejected_date__c;
                result.approveStatus = 'Reject';
            }
        }
        result.staffComment = model.staff_comment__c;
        result.pmsvComment = model.pmsv_comment__c;
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
        result.userManagerName = model.user_manager_en__c;
        result.createdDate = model.createdDate;
        result.submittedDate = model.submitted_date__c;
        result.verifiedDate = model.verified_date__c;
        result.approvedDate = model.approved_date__c;
        result.completedDate = model.completed_date__c;
        result.rejectedDate = model.rejected_date__c;
        result.cancelledDate = model.cancelled_date__c;
        result.acceptedBy = model.accepted_by__c;
        result.completedBy = model.pmsv__c;
        result.cancelledBy = model.cancelled_by__c;
        result.verifiedBy = model.verified_by__c;
        result.rejectedBy = model.rejected_by__c;
        result.verifyComment = model.verify_comment__c;
        result.rejectComment = model.reject_comment__c;
        result.cancelledComment = model.cancel_comment__c;
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
    
    public static Map<string,ESS_Master_Stationary__c> GetStationaryMasters() {
        Map<string,ESS_Master_Stationary__c> mapMasters = new Map<string,ESS_Master_Stationary__c>();
        string query = getMasterStationaryQuery();
        List<ESS_Master_Stationary__c> Masters = database.query(query);
        if(Masters.size() > 0) {
            for(ESS_Master_Stationary__c Master : Masters) {
                mapMasters.put(Master.Id, Master);
            }
        }
        return mapMasters;
    }
    
    public static string getMasterStationaryQuery()
    {
        return 
        'SELECT Active__c,Attachment_Files__c,Available_Stock__c,CreatedDate,Due_Stock__c,Id,LastModifiedById,' +
        'LastModifiedDate,Last_Updated_By__c,Last_Updated_Date__c,Minimum_Stock__c,Name,Other_Supplier__c,OwnerId,' +
        'Price__c,Service_For__c,Stationary_Name__c,Stock_History__c,Stock_on_Hand__c,Supplier__c,Type__c,Unit__c,Image_Url__c,IsLowerMinimumStock__c,' +
        'Last_Updated_By_User__c,Last_Updated_Date_User__c' +
        ' from ESS_Master_Stationary__c where name != null';
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