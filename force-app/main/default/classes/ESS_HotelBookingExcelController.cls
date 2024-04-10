public with sharing class ESS_HotelBookingExcelController {

    public integer hotelBookingSize {get;set;}
    public string todayDate {get;set;}
    public string todayTime {get;set;}
    public integer year {get;set;}
    public string monthName {get;set;}
    
    public List<ESS_HotelBooking_DTO.HotelBookingExcelDTO> hotelBookingTables {get;set;}
    
    public void OnloadExcel() {
    
        year = datetime.now().year();
        todayDate = datetime.now().format('dd-MM-yyyy');
        todayTime = datetime.now().format('HH:mm');
        string userId = ESS_PrivilegeHandler.getUserId();
        hotelBookingSize = 0;
        hotelBookingTables = new List<ESS_HotelBooking_DTO.HotelBookingExcelDTO>();
        
        ESS_HotelBooking.AdminSearchFilter filter = new ESS_HotelBooking.AdminSearchFilter();
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
        
        string query = ESS_HotelBooking.getHotelBookingDetailQuery();
        query += ' where document_no__c != null';
        
        boolean isHotelBookingAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
        if (!isHotelBookingAdmin) {
            query +=  ' and ((Status__c != \'OnProcess\' or Status__c != \'Completed\' or Status__c != \'Waiting\') or (PMSV_Id__c = :userId))';
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
        List<ESS_Hotel_Booking__c> models = Database.query(query);
        for (ESS_Hotel_Booking__c model : models) {
            ESS_HotelBooking_DTO.HotelBookingExcelDTO result = assignToHotelBookingDetailDTO(model);
            hotelBookingTables.add(result);
        }

        system.debug(hotelBookingSize);
        hotelBookingSize = hotelBookingTables.size();

    }
    
    private static ESS_HotelBooking_DTO.HotelBookingExcelDTO assignToHotelBookingDetailDTO(ESS_Hotel_Booking__c model){
        string userId = ESS_PrivilegeHandler.getUserId();

        ESS_HotelBooking_DTO.HotelBookingExcelDTO result = new ESS_HotelBooking_DTO.HotelBookingExcelDTO();
        result.documentNo = model.Document_No__c;
        if(model.On_Behalf_Flow__c) {
            result.documentType = 'ดำเนินการแทน';
            result.guestName = model.on_behalf_of_en__c;
        }
        else {
            result.documentType = 'ดำเนินการเอง';
            result.guestName = model.requester_name_en__c;
        }
        result.hotelName = model.Hotel_Name__c;
        result.checkInDate = model.Check_In__c;
        result.checkOutDate = model.Check_Out__c;
        
        //Room detail
        if (string.isNotBlank(model.Room_JSON__c)) {
            List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> hotelBookingRooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
            hotelBookingRooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
            if(hotelBookingRooms.size() == 1) {
                result.room1GuestNo = hotelBookingRooms[0].guestNo;
                if(hotelBookingRooms[0].roomType != null) {
                    result.room1RoomType = hotelBookingRooms[0].roomType.value;
                }
                result.room1SpecialRequest = hotelBookingRooms[0].specialRequest;
                result.room1TotalContractRate = hotelBookingRooms[0].total;
                result.room1TotalChargeCompany = hotelBookingRooms[0].payByCompany;
                result.room1TotalChargeEmployee = hotelBookingRooms[0]. chargeEmployee;
            }
            if(hotelBookingRooms.size() == 2) {
                result.room2GuestNo = hotelBookingRooms[1].guestNo;
                if(hotelBookingRooms[1].roomType != null) {
                    result.room2RoomType = hotelBookingRooms[1].roomType.value;
                }
                result.room2SpecialRequest = hotelBookingRooms[1].specialRequest;
                result.room2TotalContractRate = hotelBookingRooms[1].total;
                result.room2TotalChargeCompany = hotelBookingRooms[1].payByCompany;
                result.room2TotalChargeEmployee = hotelBookingRooms[1]. chargeEmployee;
            }
        }
        
        result.total = model.total__c;
        result.totalChargeCompany = model.total_charge_company__c;
        result.totalChargeEmployee = model.total_charge_employee__c;
        result.totalNight = (integer)model.night__c;
        result.totalRoom = (integer)model.room__c;
        result.totalGuest = (integer)model.adult__c;
        result.remark = model.remark__c;
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
        result.createdDate = model.createdDate;
        result.submittedDate = model.submitted_date__c;
        result.verifiedDate = model.verified_date__c;
        result.completedDate = model.completed_date__c;
        result.rejectedDate = model.rejected_date__c;
        result.cancelledDate = model.cancelled_date__c;
        result.completedBy = model.completed_by__c;
        result.verifiedBy = model.verified_by__c;
        result.rejectedBy = model.rejected_by__c;
        result.cancelledBy = model.cancelled_by__c;
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
        result.rejectedReason = model.reject_comment__c;
        result.cancelledReason = model.cancel_comment__c;
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