/* Author Softever */
global with sharing class ESS_HotelBooking {

    private static string userId = ESS_PrivilegeHandler.getUserId();
    private static boolean isHotelAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
    private static boolean isHotelPrivilege = ESS_PrivilegeHandler.checkPMSVHotelPrivilege(userId);
    private static boolean canOnlyOnBehalf = ESS_PrivilegeHandler.checkPMSVHotelPrivilege(userId);
    private static boolean isHotelSecretary = ESS_PrivilegeHandler.checkPMSVHotelSecretaryUser(userId);
    private static boolean isPMSVAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
    
    @RemoteAction
    public static integer GetMasterHotelBookingListCount() {
		string query = 'select count(id) from ESS_Master_Hotel_Booking__c where id != null AND hotel_name__c != null AND active__c = true';
        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    @RemoteAction
    public static List<ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO> GetMasterHotelBookingList(
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        
        string query = ESS_MasterHotelBooking.getMasterHotelBookingQuery();
        
        query += ' where hotel_name__c != null AND active__c = true';
        
        //Add Sort by logic
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
             string sortByQuery = ' order by';
             if(sortByParam.sortBy == 'hotelId') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' name asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' name desc';
                 }
             }
             else if(sortByParam.sortBy == 'hotelName') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' hotel_name__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' hotel_name__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'guest1ContractRate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' guest_1_contract_rate__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' guest_1_contract_rate__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'guest1ChargeEmployee') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' guest_1_charge_employee__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' guest_1_charge_employee__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'guest2ContractRate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' guest_2_contract_rate__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' guest_2_contract_rate__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'guest2ChargeEmployee') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' guest_2_charge_employee__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' guest_2_charge_employee__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'twinBedContractRate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' twin_bed_contract_rate__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' twin_bed_contract_rate__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'twinBedChargeEmployee') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' twin_bed_charge_employee__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' twin_bed_charge_employee__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'contactName') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' contact_name__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' contact_name__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'contactEmail') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' contact_email__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' contact_email__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'contactTelephone') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' contact_telephone__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' contact_telephone__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'location') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' location__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' location__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'hotelWebsite') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' hotel_website__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' hotel_website__c desc';
                 }
             }
             query += sortByQuery;
         }
        
        /* if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        } */
        
        List<ESS_Master_Hotel_Booking__c> models = Database.query(query);
        List<ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO> results = new List<ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO>();
        for (ESS_Master_Hotel_Booking__c model : models) {
            results.add(ESS_MasterHotelBooking.assignToMasterHotelBookingDTO(model));
        }

        return results;
        
    }
    
    @RemoteAction
    public static boolean checkPRTRUser() {
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        return isPRTRUser;
    }
    
    @RemoteAction
    public static boolean checkPRTRAdminUser() {
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isPRTRAdminUser = checkPRTRAdmin(userId);
        return isPRTRAdminUser;
    }
    
    @RemoteAction
    public static integer GetAvailableRoom(string employeeId) {
        
        integer currentYear = system.Datetime.now().year();
        integer nextYear = currentYear + 1;
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        //boolean isSecretaryAdmin = ESS_PrivilegeHandler.checkPMSVHotelSecretaryUser(userId);
        //boolean isHotelPrivilege = ESS_PrivilegeHandler.checkPMSVHotelPrivilege(userId);
        
        if((!isPRTRUser && !isHotelSecretary) || (!isPRTRUser && isHotelSecretary && !isHotelPrivilege)) {
            ESS_Master_Employee__c Master = new ESS_Master_Employee__c();
            if(employeeId == null) {
                PISUsers__c loginedUser = ESS_Global.assignToPISUser(userId);
                if(!loginedUser.Hotel_Privilege__c) {
                	return 0;
                }
                Master = [select id, employee_id__c, available_room__c from ESS_Master_Employee__c where employee_id__c = :loginedUser.EmployeeId__c AND Data__c = 'IN'];    
        	}
            else {
                PISUsers__c documentUser = ESS_Global.assignToPISUserFromEmployeeId(employeeId);
                if(!documentUser.Hotel_Privilege__c) {
                    return 0;
                }
                userId = documentUser.User__c;
                Master = [select id, employee_id__c, available_room__c, available_room_next_year__c from ESS_Master_Employee__c where employee_id__c = :employeeId AND Data__c = 'IN'];
            }

            integer availableRoom = Integer.ValueOf(Master.Available_Room__c);
            
            date todayDate = date.today();
            integer roomCount = 0;
            
            List<ESS_Hotel_Booking__c> HotelBookings = new List<ESS_Hotel_Booking__c>();
            List<string> statuses = new List<string> {ESS_Enum.HotelBookingStatus.OnProcess.name(),ESS_Enum.HotelBookingStatus.Verifying.name(),ESS_Enum.HotelBookingStatus.Completed.name()};
            
            string query = 'select id, Document_No__c, ownerid, on_behalf_of_flow__c, on_behalf_of_id__c, status__c, Completed_Date__c, total_room_night__c from ESS_Hotel_Booking__c where status__c IN :statuses AND use_this_year_quota__c = true';
            query += ' AND ((ownerid = :userId AND on_behalf_of_flow__c = false) OR (on_behalf_of_id__c =: userId AND on_behalf_of_flow__c = true))';
            
            HotelBookings = database.query(query);
            if(HotelBookings.size() > 0) {
                for(ESS_Hotel_Booking__c Hotel : HotelBookings) {
                    if(Hotel.status__c == ESS_Enum.HotelBookingStatus.Completed.name() && Hotel.Completed_Date__c != null) {
                        if(Hotel.total_room_night__c != null && Hotel.Completed_Date__c.date() == todayDate) {
                        	roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    	}
                    }
                    else if(Hotel.status__c == ESS_Enum.HotelBookingStatus.OnProcess.name() || 
                            Hotel.status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                        if(Hotel.total_room_night__c != null) {
                            roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                        }
                    }
                }
            }
            
            availableRoom = availableRoom - roomCount;
            return availableRoom;
        }
        
        return 0;
    }
    
    @RemoteAction
    public static integer GetAvailableRoomNextYear(string employeeId) {
        
        integer currentYear = system.Datetime.now().year();
        integer nextYear = currentYear + 1;
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        //boolean isSecretaryAdmin = ESS_PrivilegeHandler.checkPMSVHotelSecretaryUser(userId);
        //boolean isHotelPrivilege = ESS_PrivilegeHandler.checkPMSVHotelPrivilege(userId);
        
        if((!isPRTRUser && !isHotelSecretary) || (!isPRTRUser && isHotelSecretary && !isHotelPrivilege)) {
            ESS_Master_Employee__c Master = new ESS_Master_Employee__c();
            if(employeeId == null) {
                PISUsers__c loginedUser = ESS_Global.assignToPISUser(userId);
                if(!loginedUser.Hotel_Privilege__c) {
                	return 0;
                }
                Master = [select id, employee_id__c, available_room__c from ESS_Master_Employee__c where employee_id__c = :loginedUser.EmployeeId__c AND Data__c = 'IN'];    
        	}
            else {
                PISUsers__c documentUser = ESS_Global.assignToPISUserFromEmployeeId(employeeId);
                if(!documentUser.Hotel_Privilege__c) {
                    return 0;
                }
                userId = documentUser.User__c;
                Master = [select id, employee_id__c, available_room__c, available_room_next_year__c from ESS_Master_Employee__c where employee_id__c = :employeeId AND Data__c = 'IN'];
            }
            integer availableRoom = Integer.ValueOf(Master.Available_Room_Next_Year__c);
            
            date todayDate = date.today();
            integer roomCount = 0;
            
            List<ESS_Hotel_Booking__c> HotelBookings = new List<ESS_Hotel_Booking__c>();
            List<string> statuses = new List<string> {ESS_Enum.HotelBookingStatus.OnProcess.name(),ESS_Enum.HotelBookingStatus.Verifying.name(),ESS_Enum.HotelBookingStatus.Completed.name()};
            
            string query = 'select id, Document_No__c, ownerid, on_behalf_of_flow__c, on_behalf_of_id__c, status__c, Completed_Date__c, total_room_night__c from ESS_Hotel_Booking__c where status__c IN :statuses AND use_this_year_quota__c = false';
            query += ' AND ((ownerid = :userId AND on_behalf_of_flow__c = false) OR (on_behalf_of_id__c =: userId AND on_behalf_of_flow__c = true))';
            
            HotelBookings = database.query(query);
            if(HotelBookings.size() > 0) {
                for(ESS_Hotel_Booking__c Hotel : HotelBookings) {
                    if(Hotel.status__c == ESS_Enum.HotelBookingStatus.Completed.name() && Hotel.Completed_Date__c != null) {
                        if(Hotel.total_room_night__c != null && Hotel.Completed_Date__c.date() == todayDate) {
                        	roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    	}
                    }
                    else if(Hotel.status__c == ESS_Enum.HotelBookingStatus.OnProcess.name() || 
                            Hotel.status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                        if(Hotel.total_room_night__c != null) {
                            roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                        }
                    }
                }
            }
            
            availableRoom = availableRoom - roomCount;
            return availableRoom;
        }
        
        return 0;
    }
    
    @RemoteAction
    public static integer GetAvailableRoomOnBehalfOfFlow(string onBehalfOfEmployeeId) {
        
        ESS_Master_Employee__c Master = [select id, employee_id__c, available_room__c from ESS_Master_Employee__c where employee_id__c = :onBehalfOfEmployeeId AND Data__c = 'IN'];

        integer availableRoom = Integer.ValueOf(Master.Available_Room__c);
        
        date todayDate = date.today();
        integer roomCount = 0;
        
        List<ESS_Hotel_Booking__c> HotelBookings = new List<ESS_Hotel_Booking__c>();
        List<string> statuses = new List<string> {ESS_Enum.HotelBookingStatus.OnProcess.name(),ESS_Enum.HotelBookingStatus.Verifying.name(),ESS_Enum.HotelBookingStatus.Completed.name()};
        
        PISUsers__c OnBehalfOf = [select id, user__c from PISUsers__c where employeeid__c = :onBehalfOfEmployeeId AND Active__c = true AND MainPosition__c = true];
        string onBehalfOfId = OnBehalfOf.User__c;
            
        string query = 'select id, ownerid, on_behalf_of_flow__c, on_behalf_of_id__c, status__c, Completed_Date__c, total_room_night__c from ESS_Hotel_Booking__c where status__c IN :statuses AND use_this_year_quota__c = true';
        query += ' AND ((ownerid = :onBehalfOfId AND on_behalf_of_flow__c = false) OR (on_behalf_of_id__c = :onBehalfOfId AND on_behalf_of_flow__c = true))';
        
        HotelBookings = database.query(query);
        if(HotelBookings.size() > 0) {
            for(ESS_Hotel_Booking__c Hotel : HotelBookings) {
                if(Hotel.status__c == ESS_Enum.HotelBookingStatus.Completed.name() && Hotel.Completed_Date__c.date() == todayDate) {
                    if(Hotel.total_room_night__c != null) {
                        roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    }
                }
                else if(Hotel.status__c == ESS_Enum.HotelBookingStatus.OnProcess.name() || 
                        Hotel.status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                    if(Hotel.total_room_night__c != null) {
                        roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    }      
                }
            }
        }
        
        availableRoom = availableRoom - roomCount;
        return availableRoom;
    }
    
    @RemoteAction
    public static integer GetAvailableRoomNextYearOnBehalfOfFlow(string onBehalfOfEmployeeId) {
        
        ESS_Master_Employee__c Master = [select id, employee_id__c, available_room__c, available_room_next_year__c from ESS_Master_Employee__c where employee_id__c = :onBehalfOfEmployeeId AND Data__c = 'IN'];

        integer availableRoom = Integer.ValueOf(Master.Available_Room_Next_Year__c);
        
        date todayDate = date.today();
        integer roomCount = 0;
        
        List<ESS_Hotel_Booking__c> HotelBookings = new List<ESS_Hotel_Booking__c>();
        List<string> statuses = new List<string> {ESS_Enum.HotelBookingStatus.OnProcess.name(),ESS_Enum.HotelBookingStatus.Verifying.name(),ESS_Enum.HotelBookingStatus.Completed.name()};
        
        PISUsers__c OnBehalfOf = [select id, user__c from PISUsers__c where employeeid__c = :onBehalfOfEmployeeId AND Active__c = true AND MainPosition__c = true];
        string onBehalfOfId = OnBehalfOf.User__c;
            
        string query = 'select id, ownerid, on_behalf_of_flow__c, on_behalf_of_id__c, status__c, Completed_Date__c, total_room_night__c from ESS_Hotel_Booking__c where status__c IN :statuses AND use_this_year_quota__c = false';
        query += ' AND ((ownerid = :onBehalfOfId AND on_behalf_of_flow__c = false) OR (on_behalf_of_id__c = :onBehalfOfId AND on_behalf_of_flow__c = true))';
        
        HotelBookings = database.query(query);
        if(HotelBookings.size() > 0) {
            for(ESS_Hotel_Booking__c Hotel : HotelBookings) {
                if(Hotel.status__c == ESS_Enum.HotelBookingStatus.Completed.name() && Hotel.Completed_Date__c.date() == todayDate) {
                    if(Hotel.total_room_night__c != null) {
                        roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    }
                }
                else if(Hotel.status__c == ESS_Enum.HotelBookingStatus.OnProcess.name() || 
                        Hotel.status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                    if(Hotel.total_room_night__c != null) {
                        roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    }      
                }
            }
        }
        
        availableRoom = availableRoom - roomCount;
        return availableRoom;
    }
    
    @RemoteAction
    public static integer GetOnBehalfCount() {
        string userId = ESS_PrivilegeHandler.getUserId();

        //TODO: Get on behalf count
        string query = 'select count(id) from ESS_Hotel_Booking__c where id != null and On_Behalf_Of_Id__c = :userId and Status__c = \'Verifying\'';

        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
   
    @RemoteAction
    public static integer GetHotelBookingListCount(SearchFilter filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();

        string query = 'select count(id) from ESS_Hotel_Booking__c where id != null	AND document_no__c != null';

        //Add authorize filter
        query +=  ' and (OwnerId = :userId or On_Behalf_Of_Id__c = :userId)';

        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.hotelName)) {
                string hotelName = '%' + filter.hotelName + '%';
                query += ' and Hotel_Name__c like :hotelName';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
                
                //On Behalf Verifying Page
                if(status == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                    query += ' and (Requester_Id__c != :userId AND On_Behalf_Of_Id__c != null)';
                }
            }
            if (filter.startCreatedDate != null){
                datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
                query = query + ' AND createddate >=: startCreatedDate';
            }
            if (filter.endCreatedDate != null){
                datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
                query = query + ' AND createddate <=: endCreatedDate';
            }
            if (filter.startCheckInDate != null){
                date startCheckInDate = ESS_Global.convertDateFilter(filter.startCheckInDate);
                query = query + ' AND check_in__c >=: startCheckInDate';
            }
            if (filter.endCheckInDate != null){
                date endCheckInDate = ESS_Global.convertDateFilter(filter.endCheckInDate);
                query = query + ' AND check_in__c <=: endCheckInDate';
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }

        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    @RemoteAction
    public static List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> GetHotelBookingList(SearchFilter filter,
        //documentNo,status,checkIn,checkOut,createdDate,completedDate                                                                                 
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) 
    {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        
        string query = getHotelBookingRoomCardQuery();

        //Add authorize filter
        query +=  ' where document_no__c != null AND (OwnerId = :userId or On_Behalf_Of_Id__c = :userId)';

        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.hotelName)) {
                string hotelName = '%' + filter.hotelName + '%';
                query += ' and Hotel_Name__c like :hotelName';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
                
                //On Behalf Verifying Page
                if(status == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                    query += ' and (Requester_Id__c != :userId AND On_Behalf_Of_Id__c != null)';
                }
            }
            if (filter.startCreatedDate != null){
                datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
                query = query + ' AND createddate >=: startCreatedDate';
            }
            if (filter.endCreatedDate != null){
                datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
                query = query + ' AND createddate <=: endCreatedDate';
            }
            if (filter.startCheckInDate != null){
                date startCheckInDate = ESS_Global.convertDateFilter(filter.startCheckInDate);
                query = query + ' AND check_in__c >=: startCheckInDate';
            }
            if (filter.endCheckInDate != null){
                date endCheckInDate = ESS_Global.convertDateFilter(filter.endCheckInDate);
                query = query + ' AND check_in__c <=: endCheckInDate';
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }

        //Add Sort by logic
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
             string sortByQuery = ' order by';
             if(sortByParam.sortBy == 'documentNo') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Document_No__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Document_No__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'status') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Status__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Status__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'checkIn') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' check_in__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' check_in__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'checkOut') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' check_out__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' check_out__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'createdDate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' createddate asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' createddate desc';
                 }
             }
             else if(sortByParam.sortBy == 'completedDate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Completed_Date__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Completed_Date__c desc';
                 }
             }else{
                sortByQuery += ' createddate desc';
             }
             query += sortByQuery;
         }else{
            query += ' order by CreatedDate desc';
         }
        
        if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }

        List<ESS_Hotel_Booking__c> models = Database.query(query);
        List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> results = new List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO>();
        for (ESS_Hotel_Booking__c model : models) {
            results.add(assignToHotelBookingRoomCardDTO(model));
        }

        return results;

    }
   
    @RemoteAction
    public static integer GetHotelBookingForAdminListCount(
        AdminSearchFilter filter
    )
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        //PISUsers__c loginedUser = ESS_Global.assignToPISUser(userId);
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        
        string query = 'select count(id) from ESS_Hotel_Booking__c where document_no__c != null';

        //Add authorize filter
        //boolean isHotelBookingAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
        if (!isHotelAdmin) {
            query +=  ' and ((Status__c != \'OnProcess\' and Status__c != \'Completed\') or (PMSV_Id__c = :userId))';   
        }
        
        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.hotelName)) {
                string hotelName = '%' + filter.hotelName + '%';
                query += ' and Hotel_Name__c like :hotelName';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
            }
            if (string.isNotBlank(filter.employeeName)) {
                string employeeName = '%' + filter.employeeName + '%';
                query += ' and Requester_Name_EN__c like :employeeName';
            }
            if (filter.startCheckInDate != null){
                date startCheckInDate = ESS_Global.convertDateFilter(filter.startCheckInDate);
                query = query + ' AND (Check_In__c = null or Check_In__c >=: startCheckInDate)';
            }
            if (filter.endCheckInDate != null){
                date endCheckInDate = ESS_Global.convertDateFilter(filter.endCheckInDate);
                query = query + ' AND (Check_In__c = null or Check_In__c <=: endCheckInDate)';
            }
            if (filter.startCreatedDate != null){
                datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
                query = query + ' AND createddate >=: startCreatedDate';
            }
            if (filter.endCreatedDate != null){
                datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
                query = query + ' AND createddate <=: endCreatedDate';
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }

    @RemoteAction
    public static List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> GetHotelBookingForAdminList(
        AdminSearchFilter filter,
        //documentNo, hotelName, status, employeeName, checkIn, checkOut, createdDate, completedDate
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam
    )
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        //PISUsers__c loginedUser = ESS_Global.assignToPISUser(userId);
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        
        string query = getHotelBookingRoomCardQuery();
        query += ' where document_no__c != null';
        
        //boolean isHotelBookingAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
        if (!isHotelAdmin) {
            query +=  ' and ((Status__c != \'OnProcess\' or Status__c != \'Completed\' or Status__c != \'Waiting\') or (PMSV_Id__c = :userId))';
        }
        
        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.hotelName)) {
                string hotelName = '%' + filter.hotelName + '%';
                query += ' and Hotel_Name__c like :hotelName';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
            }
            if (string.isNotBlank(filter.employeeName)) {
                string employeeName = '%' + filter.employeeName + '%';
                query += ' and Requester_Name_EN__c like :employeeName';
            }
            if (filter.startCheckInDate != null){
                date startCheckInDate = ESS_Global.convertDateFilter(filter.startCheckInDate);
                query = query + ' AND (Check_In__c >=: startCheckInDate)';
            }
            if (filter.endCheckInDate != null){
                date endCheckInDate = ESS_Global.convertDateFilter(filter.endCheckInDate);
                query = query + ' AND (Check_In__c <=: endCheckInDate)';
            }
            if (filter.startCreatedDate != null){
                datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
                query = query + ' AND createddate >=: startCreatedDate';
            }
            if (filter.endCreatedDate != null){
                datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
                query = query + ' AND createddate <=: endCreatedDate';
            }
            if (filter.startCompletedDate != null){
                datetime startCompletedDate = ESS_Global.convertDateTimeFilter(filter.startCompletedDate);
                query = query + ' AND (Completed_Date__c >=: startCompletedDate)';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND (Completed_Date__c <=: endCompletedDate)';
            }
        }
        
        //Add Sort by logic
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
             string sortByQuery = ' order by';
             if(sortByParam.sortBy == 'documentNo') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Document_No__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Document_No__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'hotelName') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Hotel_Name__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Hotel_Name__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'checkIn') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Check_In__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Check_In__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'checkOut') {
                if(sortByParam.ascending) {
                    sortByQuery += ' Check_Out__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery += ' Check_Out__c desc';
                }
            }
             else if(sortByParam.sortBy == 'employeeName') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Requester_Name_EN__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Requester_Name_EN__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'status') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Status__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Status__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'createdDate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' CreatedDate asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' CreatedDate desc';
                 }
             }
             else if(sortByParam.sortBy == 'completedDate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Completed_Date__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Completed_Date__c desc';
                 }
             }else {
                sortByQuery += ' CreatedDate desc';
             }
             query += sortByQuery;
         }else{
            query += ' order by CreatedDate desc';
         }

         if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
         }

        List<ESS_Hotel_Booking__c> models = Database.query(query);
        List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> results = new List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO>();
        for (ESS_Hotel_Booking__c model : models) {
            ESS_HotelBooking_DTO.HotelBookingRoomCardDTO result = assignToHotelBookingRoomCardDTO(model);
            results.add(result);
        }

        return results;
    }

    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO GetHotelBookingDetail(ESS_HotelBooking_DTO.SearchDTO search) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }

        ESS_HotelBooking_DTO.HotelBookingDetailDTO result;

        if (string.isBlank(search.recordId)) {
            //assign default dto
            result = new ESS_HotelBooking_DTO.HotelBookingDetailDTO();
            result.status = new ESS_Global.EnumValue('HotelBookingStatus');
            result.status.key = ESS_Enum.HotelBookingStatus.Draft.name();
            result.status.value = result.status.key;
            result.requesterId = userId;
            
            //Check Secretary
            result.canOnlyOnBehalf = checkCanOnlyOnBehalf(result.status.key, userId);
            
            if(!isPRTRUser) {
                result.requesterEmployeeId = loginedUser.EMPLOYEEID__c;
                result.requesterEmployeeName = loginedUser.TH_Fullname__c;
                result.requesterEmployeeNameEN = loginedUser.EN_Fullname__c;
                result.requesterEmail = loginedUser.EMAIL__c;
                result.requesterPosition = loginedUser.OBJENFULLNAME__c;
                result.requesterUnit = loginedUser.UNITS__c;
                result.requesterSection = loginedUser.SECTIONS__c;
                result.requesterDepartment = loginedUser.DEPARTMENT__c;
                result.requesterFunction = loginedUser.FUNCTION__c;
                result.isPRTRUser = false;
            }
            else {
                result.isPRTRUser = true;
                result.requesterEmployeeId = user.Employee_Id__c;
                string firstNameTH = '';
                string lastNameTH = '';
                if(string.isNotEmpty(user.FirstName_TH__c)) {
                    firstNameTH = user.FirstName_TH__c;
                }
                if(string.isNotEmpty(user.LastName_TH__c)) {
                    lastNameTH = user.LastName_TH__c;
                }
                result.requesterEmployeeName = firstNameTH + ' ' + lastNameTH;
                result.requesterEmployeeNameEN = user.FirstName + ' ' + user.LastName;
                result.requesterEmail = user.Email;
                result.requesterPosition = user.Position__c;
                result.requesterUnit = user.Unit__c;
                result.requesterSection = user.Section__c;
                //result.requesterDepartment = user.department;
                result.requesterFunction = user.Function__c;
            }
            
            result.canSave = true;
            result.canSubmit = true;
            result.canCheckAvailableRoom = true;
            
            //Insert empty record
            ESS_Hotel_Booking__c empty = new ESS_Hotel_Booking__c();
            database.insert(empty);
            
            result.recordId = empty.id;

        }else {
            
            ESS_Hotel_Booking__c model = queryHotelBookingById(search.recordId);
            result = assignToHotelBookingDetailDTO(model);
            
        }

        return result;
    }
    
    @RemoteAction
    public static boolean SendEmailOutToHotel(ESS_HotelBooking_DTO.HotelBookingDetailDTO input) {
        ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        model.Send_Email_to_Hotel__c = true;
        model.PMSV_Comment__c = input.pmsvComment;
        database.update(model, true);
        ESS_HotelBookingNotification.SendToHotelForReservation(model);
        return true;
    }
    
    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO SaveHotelBooking(ESS_HotelBooking_DTO.HotelBookingDetailDTO input) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isCreateNew = false;
        ESS_Hotel_Booking__c model;
        if (string.isNotBlank(input.documentNo)){
            model = queryHotelBookingById(input.recordId);
        }else{
            
            model = new ESS_Hotel_Booking__c();
            isCreateNew = true;
            string runningNo = ESS_LogicHandler.GenerateRunningNo('HotelBooking');
            string year = ESS_LogicHandler.GetCurrentYear();
            string month = ESS_LogicHandler.GetCurrentMonth();
            string prefix = 'WF';
            model.Document_No__c = prefix + '-' + year + '-' + month + '-' + runningNo;
            model.OwnerId = userId;
            model.Status__c = ESS_Enum.HotelBookingStatus.Draft.name();
        }
        
        model.On_Behalf_Flow__c = input.onBehalfOfFlow;
        model.On_Behalf_Of_Flow__c = input.onBehalfOfFlow;
        model.Hotel_Name__c = input.hotelName;
        model.Guest_1_Contract_Rate__c = input.guest1ContractRate;
        model.Guest_1_Charge_Employee__c = input.guest1ChargeEmployee;
        model.Guest_2_Contract_Rate__c = input.guest2ContractRate;
        model.Guest_2_Charge_Employee__c = input.guest2ChargeEmployee;
        model.Twin_Bed_Contract_Rate__c = input.twinBedContractRate;
        model.Twin_Bed_Charge_Employee__c = input.twinBedChargeEmployee;
        model.Hotel_Website__c = input.hotelWebsite;
        model.Hotel_Id__c = input.hotelId;
        model.Master_Hotel_Id__c = input.masterHotelId;
        model.Location__c = input.location;
        model.Link_Map__c = input.linkMap;
        model.Check_In__c = input.checkIn;
        model.Check_Out__c = input.checkOut;
        model.Use_This_Year_Quota__c = true;
        
        boolean isBookedWithinYear = true;
        if(model.Check_In__c.year() != model.Check_Out__c.year()) {
            isBookedWithinYear = false;
        }
        boolean isBookedForNextYear = false;
        if(model.Check_In__c.year() == system.Datetime.now().addYears(1).year()) {
            isBookedForNextYear = true;
            isBookedWithinYear = false;
            model.Use_This_Year_Quota__c = false;
        }
        
        //PRTR Requester
        if(model.status__c == ESS_Enum.HotelBookingStatus.Draft.name()) {
            model.Is_PRTR_Requester__c = input.isPRTRUser;
        	model.Is_Secretary_Requester__c = isHotelSecretary;
        }
        
        //Check night before editing
        integer nightBeforeEdit = 0;
        boolean isNightChange = false;
        nightBeforeEdit = Integer.ValueOf(model.Night__c);
        
        integer night = model.Check_In__c.daysBetween(model.Check_Out__c);
        model.Night__c = Integer.valueOf(night);
        
        if(model.Night__c > nightBeforeEdit) {
            isNightChange = true;
        }
        
        if (input.attachmentFiles != null) {
            List<string> attachmentIds = new List<string>();
            for (ESS_DTO.FileDTO file : input.attachmentFiles) {
                attachmentIds.add(file.id);
            }
            model.Attachment_Files__c = String.join(attachmentIds, ',');
        }
        
        if (input.hotelAttachmentFiles != null) {
            List<string> hotelAttachmentIds = new List<string>();
            for (ESS_DTO.FileDTO file : input.hotelAttachmentFiles) {
                hotelAttachmentIds.add(file.id);
            }
            model.Hotel_Attachment_Files__c = String.join(hotelAttachmentIds, ',');
        }
        
        model.Requester_Id__c = input.requesterId;
        model.Requester_Employee_Id__c = input.requesterEmployeeId;
        model.Requester_Name__c = input.requesterEmployeeName;
        model.Requester_Name_EN__c = input.requesterEmployeeNameEN;
        model.Requester_Email__c = input.requesterEmail;
        model.Requester_Position__c = input.requesterPosition;
        model.Requester_Unit__c = input.requesterUnit;
        model.Requester_Section__c = input.requesterSection;
        model.Requester_Department__c = input.requesterDepartment;
        model.Requester_Function__c = input.requesterFunction;
        model.Requester_Tel_Mobile__c = input.requesterTelMobile;
        model.Requester_Tel_Office__c = input.requesterTelOffice; 

        if (input.onBehalfOfFlow) {
            if(input.onBehalfOfId == null) {
                throw new ESS_Exception('[MyError]กรุณาเลือกคนที่จะ On Behalf Of');
            }
            model.On_Behalf_Of_Verifying__c = input.onBehalfOfVerifying;
            model.On_Behalf_Flow__c = input.onBehalfOfFlow;
            model.On_Behalf_Of_Id__c = input.onBehalfOfId;
            model.On_Behalf_Of_Employee_Id__c = input.onBehalfOfEmployeeId;
            model.On_Behalf_Of__c = input.onBehalfOfEmployeeName;
            model.On_Behalf_Of_EN__c = input.onBehalfOfEmployeeNameEN;
            model.On_Behalf_Of_Email__c = input.onBehalfOfEmail;
            model.On_Behalf_Of_Position__c = input.onBehalfOfPosition;
            model.On_Behalf_Of_Unit__c = input.onBehalfOfUnit;
            model.On_Behalf_Of_Section__c = input.onBehalfOfSection;
            model.On_Behalf_Of_Department__c = input.onBehalfOfDepartment;
            model.On_Behalf_Of_Function__c = input.onBehalfOfFunction;
        }
        
        if (input.hotelBookingRooms != null && input.hotelBookingRooms.size() > 0) {
            model.Room_JSON__c = JSON.serialize(input.hotelBookingRooms);
            model.Room__c = input.hotelBookingRooms.size();
            
            List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        	rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
            
            decimal total = 0;
            decimal totalChargeCompany = 0;
            decimal totalChargeEmployee = 0;
            for(ESS_HotelBooking_DTO.HotelBookingRoomDTO Room : rooms) {
                boolean isEditPayByCompany = false;
                if(Room.contractRate == null) {
                    Room.contractRate = 0;
                }
                if(Room.chargeEmployee == null) {
                    Room.chargeEmployee = 0;
                }
                totalChargeEmployee += Room.chargeEmployee;
                Room.total = Room.contractRate;
                
                if(model.Status__c == ESS_Enum.HotelBookingStatus.Draft.name()) {
                    Room.payByCompany = Room.contractRate - Room.chargeEmployee;
                }
                else if(model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) {
                    Room.total = Room.payByCompany + Room.chargeEmployee;
                }
                
                totalChargeCompany += Room.payByCompany;
                total += Room.total;
                string hotelBedType = ConvertRoomTypeToBedType(Room);
                Room.request = new ESS_Global.EnumValue('HotelBedType');
                Room.request.key = hotelBedType;
                string hotelBedTypeValue = ConvertRoomTypeToBedTypeValue(hotelBedType);
                Room.request.value = hotelBedTypeValue;
            }
            model.Room_JSON__c = JSON.serialize(rooms);
            model.Total_Charge_Company__c = totalChargeCompany * model.Night__c;
            model.Total_Charge_Employee__c = totalChargeEmployee * model.Night__c;
            model.Total__c = total * model.Night__c;
            
            //Check from Room Available
            integer availableRoom;
            if(model.On_Behalf_Flow__c) {
                availableRoom = GetAvailableRoomOnBehalfOf(model);
            }
            else {
                availableRoom = GetAvailableRoom(model);
            }
            
            //TotalRoom before changes
            integer totalRoomBeforeChange = Integer.ValueOf(model.Total_Room_Night__c);
            
            //TotalRoom after changes
            integer totalRoom = Integer.ValueOf(model.Room__c * model.Night__c);

            model.Total_Room_Night__c = totalRoom;
            
            boolean isRoomChangeWhenEdit = false;
            integer exactAvailableRoom = 0;
            if(model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name() || 
				model.Status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                exactAvailableRoom = availableRoom;
                availableRoom += totalRoomBeforeChange;
                isRoomChangeWhenEdit = true;
            }
            
            if(!isNightChange) {
                //If booked within same year but not enough quota
                if(availableRoom < 0 && isBookedWithinYear) {
                    availableRoom = 0;
                    
                    throw new ESS_Exception(
                    		'[MyError]Your booking is over remaining quotas for this year (Your remaining quota is '+ availableRoom + ' room night)');
                }
                //If booked within same year but not enough quota
                else if(availableRoom < totalRoom && isBookedWithinYear) {
                    throw new ESS_Exception(
                    		'[MyError]Your booking is over remaining quotas for this year (Your remaining quota is '+ availableRoom + ' room night)');
                }
                //If booked across year but not enough quota (check from this year quota)
                else if(availableRoom < totalRoom && !isBookedWithinYear && !isBookedForNextYear) {
                    throw new ESS_Exception(
                    		'[MyError]Your booking is over remaining quotas for this year (Your remaining quota is '+ availableRoom + ' room night) <br/>' +
                        		'If your quota of this year is not enough, please separate your requested into 2 bookings.');
                }
                //If booked next year but not enough quota (check from next year quota)
                else if(availableRoom < totalRoom && !isBookedWithinYear && isBookedForNextYear) {
                    throw new ESS_Exception(
                    		'[MyError]Your booking is over remaining quotas for next year (Your remaining quota is '+ availableRoom + ' room night)');
                }
            }
            else {
                //If booked within same year but not enough quota
                if(totalRoom > availableRoom) {
                    if(availableRoom < 0) {
                        availableRoom = 0;
                    }
                    
                    if(isRoomChangeWhenEdit) {
                        availableRoom = exactAvailableRoom;
                    }
                    
                    if(isBookedWithinYear) {
                        throw new ESS_Exception(
                                '[MyError]Your booking is over remaining quotas for this year (Your remaining quota is '+ availableRoom + ' room night)');
                    }
                    else if(!isBookedWithinYear && !isBookedForNextYear) {
                        throw new ESS_Exception(
                    		'[MyError]Your booking is over remaining quotas for this year (Your remaining quota is '+ availableRoom + ' room night) <br/>' +
                        		'If your quota of this year is not enough, please separate your requested into 2 bookings.');
                    }
                    else if(!isBookedWithinYear && isBookedForNextYear) {
                        throw new ESS_Exception(
                                '[MyError]Your booking is over remaining quotas for next year (Your remaining quota is '+ availableRoom + ' room night)');
                    }
                }
            }
            
            integer totalAdult = 0;
            for(ESS_HotelBooking_DTO.HotelBookingRoomDTO Booking : input.hotelBookingRooms) {
                totalAdult += Booking.guestNo;
            }
            model.Adult__c = totalAdult;
        }
        
        if(isCreateNew){
            database.insert(model, true);
            //Get Empty record
            ESS_Hotel_Booking__c empty = queryHotelBookingById(input.recordId);
        }else{
            database.update(model, true);
        }

        ESS_HotelBooking_DTO.SearchDTO Search = new ESS_HotelBooking_DTO.SearchDTO();
        Search.recordId = model.Id;
        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = GetHotelBookingDetail(Search);
        return result;
    }
    
    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO SubmitHotelBooking(ESS_HotelBooking_DTO.HotelBookingDetailDTO input) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        input = SaveHotelBooking(input);

        ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        model.Submitted_Date__c = system.datetime.now();
        if (model.On_Behalf_Flow__c && model.On_Behalf_Of_Verifying__c) {
            model.Status__c = ESS_Enum.HotelBookingStatus.Verifying.name();
            ESS_HotelBookingNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
        }
        else if (model.On_Behalf_Flow__c && !model.On_Behalf_Of_Verifying__c) {
            model.Status__c = ESS_Enum.HotelBookingStatus.OnProcess.name();
            ESS_HotelBookingNotification.SendToAdminPMSVWhenRequested(model);
        }
        else {
            model.Status__c = ESS_Enum.HotelBookingStatus.OnProcess.name();
            ESS_HotelBookingNotification.SendToAdminPMSVWhenRequested(model);
        }

        model.External_Id__c = model.Id;
        database.update(model, true);

        ESS_HotelBooking_DTO.SearchDTO search = new ESS_HotelBooking_DTO.SearchDTO();
        search.recordId = input.recordId;
        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = GetHotelBookingDetail(search);
        return result;
    }
    
    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO CancelRequestHotelBooking(ESS_HotelBooking_DTO.RejectCancelDTO input) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Completed.name() || 
           	model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) {
            
            model.Status__c = ESS_Enum.HotelBookingStatus.Cancel.name();
            model.Cancelled_Date__c = system.datetime.now();
            model.Cancel_Comment__c = input.comment;
            if(isPRTRUser) {
            	model.Cancelled_By__c = User.FirstName + ' ' + User.LastName;        
            }
            else {
            	model.Cancelled_By__c = PISUser.EN_Fullname__c;       
            }
            database.update(model, true);
            
            ESS_HotelBookingNotification.SendToUserWhenHotelCancelled(model);
            ESS_HotelBookingNotification.SendToHotelForCancelReservation(model);
        }
        
        ESS_HotelBooking_DTO.SearchDTO search = new ESS_HotelBooking_DTO.SearchDTO();
        search.recordId = input.recordId;
        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = GetHotelBookingDetail(search);
        return result;
    }
    
    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO VerifyHotelBooking(ESS_HotelBooking_DTO.SearchDTO search) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        ESS_Hotel_Booking__c model = queryHotelBookingById(search.recordId);
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
            model.Status__c = ESS_Enum.HotelBookingStatus.OnProcess.name();
            model.Verified_Date__c = system.datetime.now();
            if(isPRTRUser) {
                model.Verified_By__c = User.FirstName + ' ' + User.LastName;
            }
            else {
                model.Verified_By__c = PISUser.EN_Fullname__c;
            }
            database.update(model, true);
            
            if(model.On_Behalf_Flow__c) {
            	//ESS_HotelBookingNotification.SendToEmployeeAdminWhenEmployeeVerifyOnBehalf(model);    
            }
            
            ESS_HotelBookingNotification.SendToAdminPMSVWhenRequested(model);
            
        }
        
        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = GetHotelBookingDetail(search);
        return result;
    }
    
    @RemoteAction
    public static List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> VerifyMultipleHotelBooking(List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> inputs) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> results = new List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO>();
        for (ESS_HotelBooking_DTO.HotelBookingRoomCardDTO input : inputs) {
            if (input.isSelected) {
                ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        
                if (model.Status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                    model.Status__c = ESS_Enum.HotelBookingStatus.OnProcess.name();
                    model.Verified_Date__c = system.datetime.now();
                    if(isPRTRUser) {
                        model.Verified_By__c = User.FirstName + ' ' + User.LastName;
                    }
                    else {
                        model.Verified_By__c = PISUser.EN_Fullname__c;
                    }
                    database.update(model, true);
                    
                    if(model.On_Behalf_Flow__c) {
                        //ESS_HotelBookingNotification.SendToEmployeeAdminWhenEmployeeVerifyOnBehalf(model);    
                    }
                    
                    ESS_HotelBookingNotification.SendToAdminPMSVWhenRequested(model);
                }

                string recordId = input.recordId;
                string query = getHotelBookingRoomCardQuery();
                query +=  ' where Id = :recordId';
                ESS_Hotel_Booking__c cardModel = Database.query(query);
                results.add(assignToHotelBookingRoomCardDTO(cardModel));

            }else{
                results.add(input);
            }
        }
        
        return results;
    }
    
    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO RejectHotelBooking(ESS_HotelBooking_DTO.RejectCancelDTO input) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        model.Reject_Comment__c = input.comment;
        model.Rejected_Date__c = system.datetime.now();
        if(isPRTRUser) {
            model.Rejected_By__c = User.FirstName + ' ' + User.LastName;
        }
        else {
            model.Rejected_By__c = PISUser.EN_Fullname__c;
        }
        
        //Reject by Employee Admin
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
        	model.Status__c = ESS_Enum.HotelBookingStatus.Rejected.name();
            ESS_HotelBookingNotification.SendToEmployeeAdminWhenEmployeeRejectOnBehalf(model);
        }
        
        //Reject by Admin PMSV
        if (model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) {
        	model.Status__c = ESS_Enum.HotelBookingStatus.Rejected.name();	
            ESS_HotelBookingNotification.SendToEmployeeAndEmployeeAdminWhenPMSVReject(model);
        }

        if(model.Room__c != null) {
            integer totalRoom = Integer.ValueOf(model.Room__c * model.Night__c);
        }
        database.update(model, true);
        
        ESS_HotelBooking_DTO.SearchDTO search = new ESS_HotelBooking_DTO.SearchDTO();
        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = GetHotelBookingDetail(search);
        return result;
    }
    
    @RemoteAction
    public static List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> RejectMultipleHotelBooking(List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> inputs, string comment) {
        string userId = ESS_PrivilegeHandler.getUserId();
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> results = new List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO>();
        for (ESS_HotelBooking_DTO.HotelBookingRoomCardDTO input : inputs) {
            if (input.isSelected) {
                ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        
                if (model.Status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                    model.Status__c = ESS_Enum.HotelBookingStatus.Rejected.name();
                    if(isPRTRUser) {
                        model.Rejected_By__c = User.FirstName + ' ' + User.LastName;
                    }
                    else {
                        model.Rejected_By__c = PISUser.EN_Fullname__c;
                    }
                    model.Rejected_Date__c = system.datetime.now();
                    model.Reject_Comment__c = comment;
                    database.update(model, true);
                    
                    if (model.On_Behalf_Flow__c) {
                        ESS_HotelBookingNotification.SendToEmployeeAdminWhenEmployeeRejectOnBehalf(model);
                    }
                }

                string recordId = input.recordId;
                string query = getHotelBookingRoomCardQuery();
                query +=  ' where Id =: recordId';
                ESS_Hotel_Booking__c cardModel = Database.query(query);
                results.add(assignToHotelBookingRoomCardDTO(cardModel));

            }else{
                results.add(input);
            }
        }
        
        return results;
    }
    
    @RemoteAction
    public static boolean DeleteHotelBooking(ESS_HotelBooking_DTO.SearchDTO search) {
        
        ESS_Hotel_Booking__c model = queryHotelBookingById(search.recordId);
        //Add Room back before delete
        //integer totalRoomNight = Integer.ValueOf(model.Total_Room_Night__c);
        //AddAvailableRoom(model, totalRoomNight);
        database.delete(model, true);
        
        return true;
    }
    
    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO CompleteHotelBooking(ESS_HotelBooking_DTO.HotelBookingDetailDTO input) {
        input = SaveCompleteHotelBooking(input);

        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        if (model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) {
            model.Status__c = ESS_Enum.HotelBookingStatus.Completed.name();
            model.Completed_Date__c = system.datetime.now();
            if(isPRTRUser) {
                model.Completed_By__c = User.FirstName + ' ' + User.LastName;
            }
            else {
                model.Completed_By__c = PISUser.EN_Fullname__c;
            }
            database.update(model, true);
        	ESS_HotelBookingNotification.SendToEmployeeAndEmployeeAdminWhenCompleted(model);
		}
        
        //Insert record into Hotel SAP
        sendDataToHotelSAP(model);
        
        ESS_HotelBooking_DTO.SearchDTO search = new ESS_HotelBooking_DTO.SearchDTO();
        search.recordId = input.recordId;
        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = GetHotelBookingDetail(search);
        return result;
    }
    
    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO SaveCompleteHotelBooking(ESS_HotelBooking_DTO.HotelBookingDetailDTO input)
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        model.Remark__c = input.remark;
        if (input.attachmentFiles != null) {
            List<string> attachmentIds = new List<string>();
            for (ESS_DTO.FileDTO file : input.attachmentFiles) {
                attachmentIds.add(file.id);
            }
            model.Attachment_Files__c = String.join(attachmentIds, ',');
        }
        if (input.hotelAttachmentFiles != null) {
            List<string> hotelAttachmentIds = new List<string>();
            for (ESS_DTO.FileDTO file : input.hotelAttachmentFiles) {
                hotelAttachmentIds.add(file.id);
            }
            model.Hotel_Attachment_Files__c = String.join(hotelAttachmentIds, ',');
        }
        database.update(model, true);
        
        ESS_HotelBooking_DTO.SearchDTO search = new ESS_HotelBooking_DTO.SearchDTO();
        search.recordId = model.Id;
        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = GetHotelBookingDetail(search);
        return result;
    }

    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO ConfirmedHotelBooking(ESS_HotelBooking_DTO.HotelBookingDetailDTO input)
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        
        List<string> attachmentIds = new List<string>();
        if(input.attachmentFiles != null) {
        	for (ESS_DTO.FileDTO file : input.attachmentFiles) {
                attachmentIds.add(file.id);
            }   
        	model.Attachment_Files__c = String.join(attachmentIds, ',');
        }
        List<string> hotelAttachmentIds = new List<string>();
        if(input.hotelAttachmentFiles != null) {
        	for (ESS_DTO.FileDTO file : input.hotelAttachmentFiles) {
                hotelAttachmentIds.add(file.id);
            }   
        	model.Hotel_Attachment_Files__c = String.join(hotelAttachmentIds, ',');
        }
        
        model.Remark__c = input.remark;

        database.update(model, true);
        
        ESS_HotelBooking_DTO.SearchDTO search = new ESS_HotelBooking_DTO.SearchDTO();
        search.recordId = model.Id;
        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = GetHotelBookingDetail(search);
        return result;
    }
    
    @RemoteAction
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO SaveRatingHotelBooking(ESS_HotelBooking_DTO.HotelBookingDetailDTO input) {
        string userId = ESS_PrivilegeHandler.getUserId();
        ESS_Hotel_Booking__c model = queryHotelBookingById(input.recordId);
        
        if(model.Requester_Id__c == userId) {
            model.Rating_Score__c = input.ratingScore;
            model.Attentiveness_Rating__c = input.attentivenessRating;
            model.Fast_Rating__c = input.fastRating;
            model.Punctuality_Rating__c = input.punctualityRating;
            model.Expertise_Rating__c = input.expertiseRating;
            model.Rating_Date__c = system.datetime.now();
        }
        if(model.On_Behalf_Of_Flow__c) {
            if(model.On_Behalf_Of_Verifying__c && model.On_Behalf_Of_Id__c == userId) {
                model.Rating_Score_2__c = input.ratingScoreOBH;
                model.Attentiveness_Rating_2__c = input.attentivenessRatingOBH;
                model.Fast_Rating_2__c = input.fastRatingOBH;
                model.Punctuality_Rating_2__c = input.punctualityRatingOBH;
                model.Expertise_Rating_2__c = input.expertiseRatingOBH;
                model.Rating_Date_2__c = system.datetime.now();
            }
        }
        database.update(model, true);

        ESS_HotelBooking_DTO.SearchDTO search = new ESS_HotelBooking_DTO.SearchDTO();
        search.recordId = model.Id;
        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = GetHotelBookingDetail(search);
        return result;
    }
    
    @RemoteAction
    public static List<ESS_HotelBooking_DTO.SearchUserDTO> SearchUsers(ESS_HotelBooking_DTO.SearchDTO search) {
        string userId = ESS_PrivilegeHandler.getUserId();
        string searchName = '%' + search.search + '%';
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //PISUsers show only TOP users
        string homeComp = '1100'; 
        string queryPIS = 'select id, user__c, employeeid__c, email__c, thtitle__c, thfirstname__c, thlastname__c, active__c, mainposition__c, EN_Fullname__c, OBJENFULLNAME__c, TH_Fullname__c, units__c, sections__c, DEPARTMENT__c, FUNCTION__c, hotel_privilege__c from PISUsers__c';
        queryPIS = queryPIS + ' where user__c != :userId AND (employeeid__c like: searchName OR enfirstname__c like: searchName) AND active__c = true AND mainposition__c = true AND hotel_privilege__c = true limit 100';
        PISUsers = database.query(queryPIS);
        
        List<ESS_HotelBooking_DTO.SearchUserDTO> SearchUsers = new List<ESS_HotelBooking_DTO.SearchUserDTO>();
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                ESS_HotelBooking_DTO.SearchUserDTO SearchUser = new ESS_HotelBooking_DTO.SearchUserDTO();
                SearchUser.userId = PISUser.User__c;
                SearchUser.displayName = PISUser.EMPLOYEEID__c + ' - ' + PISuser.EN_Fullname__c;
                SearchUser.employeeId = PISUser.EMPLOYEEID__c;
                SearchUser.employeeName = PISuser.EN_Fullname__c;
                SearchUser.employeeNameTH = PISUser.TH_Fullname__c;
                SearchUser.email = PISUser.EMAIL__c;
                SearchUser.position = PISUser.OBJENFULLNAME__c;
                SearchUser.unit = PISUser.UNITS__c;
                SearchUser.section = PISUser.SECTIONS__c;
                SearchUser.department = PISUser.DEPARTMENT__c;
                SearchUser.function = PISUser.FUNCTION__c;
                SearchUsers.add(SearchUser);
            }
        }
        
        return SearchUsers;
    }
    
    @RemoteAction
    public static string UploadFile(ESS_HotelBooking_DTO.UploadFileDTO UploadFile) {
        
        string fileData = UploadFile.fileData;
        String base64 = fileData.substring(fileData.indexOf(',')+1);
        Blob actualdata = EncodingUtil.base64Decode(base64);

        string documentId = '';
        Attachment attch = new Attachment();
        attch.name = UploadFile.filename;
        attch.parentId  = UploadFile.recordId;
        attch.body = actualdata;
        // database.insert(attch, false);
        insert attch;
        documentId = attch.Id;
        return documentId;
    }
    
    @TestVisible
    private static void sendDataToHotelSAP(ESS_Hotel_Booking__c model) {
        
        date todayDate = date.today();
        List<ESS_Hotel_SAP__c> existHotelSAPs = [select RecordId__c, Created_Date__c from ESS_Hotel_SAP__c where Created_Date__c = :todayDate order by RecordId__c desc];
        integer existHotelSAPSize = existHotelSAPs.size();
        integer latestRecordId = 0;
        
        if(existHotelSAPSize == 0) {
            latestRecordId = 1;
        }
        else {
            latestRecordId = existHotelSAPSize + 1;
        }
        
        List<ESS_Hotel_SAP__c> HotelSAPs = new List<ESS_Hotel_SAP__c>();
        
        string personnelNo;
        if(model.On_Behalf_Flow__c) {
            personnelNo = model.On_Behalf_Of_Employee_Id__c;
        }
        else {
            personnelNo = model.Requester_Employee_Id__c;
        }
        
        Map<string, string> roomTypes = GetAllRoomTypes();
        
        if(model.Room_JSON__c != null) {
        	List<ESS_HotelBooking_DTO.HotelBookingRoomDTO> rooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
        	rooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
            if(rooms.size() > 0) {
                integer count = latestRecordId;
                for(ESS_HotelBooking_DTO.HotelBookingRoomDTO Room : rooms) {
                    ESS_Hotel_SAP__c HotelSAP = new ESS_Hotel_SAP__c();
                    HotelSAP.RecordId__c = String.ValueOf(count);
                    HotelSAP.PersonnelNo__c = personnelNo;
                    HotelSAP.HotelKey__c = model.Hotel_Id__c;
                    HotelSAP.CIDate__c = model.Check_In__c;
                    HotelSAP.CODate__c = model.Check_Out__c;
                    HotelSAP.HotelType__c = roomTypes.get(Room.request.value);
                    HotelSAP.Status__c = 'SendingToSAP';
                    HotelSAP.RoomNo__c = String.ValueOf(1); //String.ValueOf(model.Room__c);
                    HotelSAP.HotelBookingId__c = model.Id;
                    HotelSAP.Document_No__c  = model.Document_No__c;
                    count++;
                    HotelSAPs.add(HotelSAP);
                }
            }
        }
        
        if(HotelSAPs.size() > 0) {    
            
            database.insert(HotelSAPs, false);
            for(ESS_Hotel_SAP__c HotelSAP : HotelSAPs) {
                HotelSAP.ExternalId__c = HotelSAP.Id;
            }
            
            database.update(HotelSAPs, false);
        }

    }
    
    @TestVisible
    private static List<string> getDataFromHotelSAP(ESS_Hotel_Booking__c model) {
        List<string> sapMessages = new List<string>();
        List<ESS_Hotel_SAP__c> existHotelSAPs = [select HotelBookingId__c, RecordId__c, SAP_Message__c, Status__c from ESS_Hotel_SAP__c where HotelBookingId__c =: model.Id order by RecordId__c asc];
        if(existHotelSAPs.size() > 0) {
            Map<string, string> statuses = GetHotelSAPStatuses();
            for(ESS_Hotel_SAP__c SAP : existHotelSAPs) {
                string status = statuses.get(SAP.Status__c);
                sapMessages.add(status + ' : ' + SAP.SAP_Message__c);
            }
        }
		return sapMessages;
    }
    
	private static ESS_HotelBooking_DTO.HotelBookingRoomCardDTO assignToHotelBookingRoomCardDTO(ESS_Hotel_Booking__c model)
    {
        ESS_HotelBooking_DTO.HotelBookingRoomCardDTO result = new ESS_HotelBooking_DTO.HotelBookingRoomCardDTO();
        result.recordId = model.id;
        result.documentNo = model.Document_No__c;
        result.isOnBehalf = model.On_Behalf_Flow__c;
        result.status = new ESS_Global.EnumValue('HotelBookingStatus');
        result.status.key = model.Status__c;
        result.status.value = model.Status__c;
        result.createdDate = model.CreatedDate;
        result.hotelName = model.Hotel_Name__c;
        result.night = Integer.ValueOf(model.Night__c);
        result.room = Integer.ValueOf(model.Room__c);
        result.adult = Integer.ValueOf(model.Adult__c);
        //result.rejectedDate = model.Rejected_Date__c;
        //result.pmsvEmployeeName = model.PMSV__c;
        //result.rejectComment = model.Reject_Comment__c;
        
        result.requesterDisplayName = model.Requester_Name_EN__c;
        
        string section = model.Requester_Section__c;
        string department = model.Requester_Department__c;
        
        boolean isSectionExist = false;
        boolean isDepartmentExist = false;
        if(string.isNotBlank(section)) {
            isSectionExist = true;
        }
        if(string.isNotBlank(model.Requester_Section__c)) {
            isDepartmentExist = true;
        }
        if(string.isBlank(model.Requester_Department__c)) {
            isDepartmentExist = false;
        }
        
        if(isSectionExist && !isDepartmentExist) {
            result.requesterDisplayName += '(' + section + ')';
        }
        else if(!isSectionExist && isDepartmentExist) {
            result.requesterDisplayName += '(' + department + ')';
        }
        else if(isSectionExist && isDepartmentExist) {
            result.requesterDisplayName += '(' + section + '/' + department + ')';
        }
            
        return result;
    }
    
    private static ESS_HotelBooking_DTO.HotelBookingDetailDTO assignToHotelBookingDetailDTO(ESS_Hotel_Booking__c model){
        string userId = ESS_PrivilegeHandler.getUserId();

        ESS_HotelBooking_DTO.HotelBookingDetailDTO result = new ESS_HotelBooking_DTO.HotelBookingDetailDTO();
        result.recordId = model.id;
        result.documentNo = model.Document_No__c;
        if (string.isNotBlank(model.Status__c)) {
            result.status = new ESS_Global.EnumValue('HotelBookingStatus');
            result.status.key = model.Status__c;
            result.status.value = model.Status__c;
        }
        
        result.hotelName = model.Hotel_Name__c;
        result.hotelId = model.Hotel_Id__c;
        result.sendEmailToHotel = model.Send_Email_to_Hotel__c;
        result.masterHotelId = model.Master_Hotel_Id__c;
        result.guest1ContractRate = model.Guest_1_Contract_Rate__c;
        result.guest1ChargeEmployee = model.Guest_1_Charge_Employee__c;
        result.guest2ContractRate = model.Guest_2_Contract_Rate__c;
        result.guest2ChargeEmployee = model.Guest_2_Charge_Employee__c;
        result.twinBedContractRate = model.Twin_Bed_Contract_Rate__c;
        result.twinBedChargeEmployee = model.Twin_Bed_Charge_Employee__c;
        result.hotelWebsite = model.Hotel_Website__c;
        result.location = model.Location__c;
        result.linkMap = model.Link_Map__c;
        result.checkIn = model.Check_In__c;
        result.checkOut = model.Check_Out__c;
        result.remark = model.Remark__c;
        result.room1SAPStatus = '';
        result.room2SAPStatus = ''; 
        
        if(model.status__c == ESS_Enum.HotelBookingStatus.Completed.name()) {
            List<string> sapStatuses = getDataFromHotelSAP(model);
            if(sapStatuses.size() == 1) {
                result.room1SAPStatus = sapStatuses[0];
            }
            else if(sapStatuses.size() == 2) {
                result.room1SAPStatus = sapStatuses[0];
                result.room2SAPStatus = sapStatuses[1];
            }
        }
        
        result.isPRTRUser = model.Is_PRTR_Requester__c;
        
        if (string.isNotBlank(model.Room_JSON__c)) {
            result.hotelBookingRooms = (List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>)JSON.deserialize(model.Room_JSON__c, List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>.class);
            for(ESS_HotelBooking_DTO.HotelBookingRoomDTO hotel : result.hotelBookingRooms) {
                if(hotel.specialRequest == null) {
                    hotel.specialRequest = '';
                }
            }
        }
        
        if (string.isNotBlank(model.Attachment_Files__c)){
            List<string> attachmentFileIds = model.Attachment_Files__c.split(',');
            result.attachmentFiles = new List<ESS_DTO.FileDTO>();
            for (string fileId : attachmentFileIds) {
                ESS_DTO.FileDTO fileDTO = new ESS_DTO.FileDTO();
                fileDTO.id = fileId;
                fileDTO.url = generateDocumentUrl(fileId);
                result.attachmentFiles.add(fileDTO);
            }
        }
        if (string.isNotBlank(model.Hotel_Attachment_Files__c)){
            List<string> attachmentFileIds = model.Hotel_Attachment_Files__c.split(',');
            result.hotelAttachmentFiles = new List<ESS_DTO.FileDTO>();
            for (string fileId : attachmentFileIds) {
                ESS_DTO.FileDTO fileDTO = new ESS_DTO.FileDTO();
                fileDTO.id = fileId;
                fileDTO.url = generateDocumentUrl(fileId);
                result.hotelAttachmentFiles.add(fileDTO);
            }
        }
        //Email
        result.total = model.Total__c;
        result.night = Integer.ValueOf(model.Night__c);
        result.room = Integer.ValueOf(model.Room__c);
        result.totalRoomNight = Integer.ValueOf(model.Total_Room_Night__c);
        result.adult = Integer.ValueOf(model.Adult__c);
        result.thaiOilAmount = model.Total_Charge_Company__c;
        result.guestAmount = model.Total_Charge_Employee__c;
        result.guestName = model.Requester_Name__c;
        
        result.ratingScore = Integer.ValueOf(model.Rating_Score__c);
        result.attentivenessRating = model.Attentiveness_Rating__c;
        result.fastRating = model.Fast_Rating__c;
        result.punctualityRating = model.Punctuality_Rating__c;
        result.expertiseRating = model.Expertise_Rating__c;
        
        result.ratingScoreOBH = Integer.ValueOf(model.Rating_Score_2__c);
        result.attentivenessRatingOBH = model.Attentiveness_Rating_2__c;
        result.fastRatingOBH = model.Fast_Rating_2__c;
        result.punctualityRatingOBH = model.Punctuality_Rating_2__c;
        result.expertiseRatingOBH = model.Expertise_Rating_2__c;
        
        result.onBehalfOfVerifying = model.On_Behalf_Of_Verifying__c;
        result.onBehalfOfFlow = model.On_Behalf_Flow__c;
        //result.isOnBehalf = model.Is_On_Behalf__c;
        result.requesterId = model.Requester_Id__c;
        result.requesterEmployeeId = model.Requester_Employee_Id__c;
        result.requesterEmployeeName = model.Requester_Name__c;
        result.requesterEmployeeNameEN = model.Requester_Name_EN__c;
        result.requesterEmail = model.Requester_Email__c;
        result.requesterPosition = model.Requester_Position__c;
        result.requesterUnit = model.Requester_Unit__c;
        result.requesterSection = model.Requester_Section__c;
        result.requesterDepartment = model.Requester_Department__c;
        result.requesterFunction = model.Requester_Function__c;
        result.requesterTelOffice = model.Requester_Tel_Office__c;
        result.requesterTelMobile = model.Requester_Tel_Mobile__c;
        result.onBehalfOfId = model.On_Behalf_Of_Id__c;
        result.onBehalfOfEmployeeId = model.On_Behalf_Of_Employee_Id__c;
        result.onBehalfOfEmployeeName = model.On_Behalf_Of__c;
        result.onBehalfOfEmployeeNameEN = model.On_Behalf_Of_EN__c;
        result.onBehalfOfEmail = model.On_Behalf_Of_Email__c;
        result.onBehalfOfPosition = model.On_Behalf_Of_Position__c;
        result.onBehalfOfUnit = model.On_Behalf_Of_Unit__c;
        result.onBehalfOfSection = model.On_Behalf_Of_Section__c;
        result.onBehalfOfDepartment = model.On_Behalf_Of_Department__c;
        result.onBehalfOfFunction = model.On_Behalf_Of_Function__c;
        result.onBehalfOfVerifying = model.On_Behalf_Of_Verifying__c;
        result.pmsvId = model.PMSV_Id__c;
        result.pmsvEmployeeId = model.PMSV_Employee_Id__c;
        result.pmsvEmployeeName = model.PMSV__c;
        result.pmsvEmail = model.PMSV_Email__c;
        result.pmsvPosition = model.PMSV_Position__c;
        result.pmsvUnit = model.PMSV_Unit__c;
        result.pmsvSection = model.PMSV_Section__c;
        result.pmsvDepartment = model.PMSV_Department__c;
        result.pmsvFunction = model.PMSV_Function__c;
        result.pmsvComment = model.PMSV_Comment__c;
        
        result.createdDate = model.CreatedDate;
        result.submittedDate = model.Submitted_Date__c;
        result.verifiedDate = model.Verified_Date__c;
        result.completedDate = model.Completed_Date__c;
        result.ratingDate = model.Rating_Date__c;
        result.ratingDateOBH = model.Rating_Date_2__c;
        result.rejectedDate = model.Rejected_Date__c;
        result.rejectComment = model.Reject_Comment__c;
        result.rejectedBy = model.Rejected_By__c;
        result.cancelledDate = model.Cancelled_Date__c;
        result.cancelComment = model.Cancel_Comment__c;
        result.cancelledBy = model.Cancelled_By__c;
        
        //Assign Authorize Flag
        result.isAdmin = checkPRTRAdmin(userId);
        result.canOnlyOnBehalf = checkCanOnlyOnBehalf(model.status__c , userId);
        result.canSave = checkCanSaveHotelBooking(model, userId);
        result.canEdit = checkCanEditHotelBooking(model, userId);
        result.canSendEmail = checkCanSendEmail(model, userId);
        result.canCheckAvailableRoom = checkAvailableRoomHotelBooking(model, userId);
        result.canRejectOnProcess = checkCanRejectHotelBooking(model, userId);
        result.canDelete = checkDeleteHotelBooking(model, userId);
        result.canShowContractRate = checkCanShowContractRate(model, userId);
        result.canSubmit = checkCanSubmitHotelBooking(model, userId);
        result.canVerify = checkCanVerifyHotelBooking(model, userId);
        result.canSaveConfirm = checkCanSaveConfirmHotelBooking(model, userId);
        result.canCancelRequest = checkCanCancelRequestHotelBooking(model, userId);
        result.canSaveComplete = checkCanSaveCompleteHotelBooking(model, userId);
        result.canComplete = checkCanCompleteHotelBooking(model, userId);
        result.showCompleteForm = checkShowCompleteFormHotelBooking(model, userId);
        result.canRating = checkCanRatingHotelBooking(model, userId);
        result.showRatingForm = checkShowRatingFormHotelBooking(model, userId);
        result.showRatingFormOBH = checkShowRatingFormOBHHotelBooking(model, userId);
        result.canShowSAPStatus = checkCanShowSAPStatus(model, userId);
        
        return result;
    }
    
    private static string getHotelBookingRoomCardQuery()
    {
        return 
        'select id, Document_No__c, On_Behalf_Flow__c, Hotel_Name__c, Status__c, check_in__c, check_out__c, night__c, room__c, adult__c, Requester_Name__c, Requester_Section__c, Requester_Department__c,' +
        'Requester_Function__c, CreatedDate, Completed_Date__c,On_Behalf_Of_Verifying__c,Requester_Name_EN__c ' +
        ' from ESS_Hotel_Booking__c';
    }
    
    public static string getHotelBookingDetailQuery()
    {
        return 
        'SELECT Adult__c,Hotel_Attachment_Files__c,Attachment_Files__c,Attentiveness_Rating__c,Cancelled_Date__c,Cancel_Comment__c,Check_In__c,Check_Out__c,Completed_Date__c,' +
        'CreatedDate,Document_No__c,Expertise_Rating__c,Fast_Rating__c,Guest_1_Charge_Employee__c,Guest_1_Contract_Rate__c,Guest_1_Special_Request__c,' +
        'Guest_2_Charge_Employee__c,Guest_2_Contract_Rate__c,Guest_2_Special_Request__c,Guest_Name__c,Hotel_Name__c,Hotel_Website__c,Id,Link_Map__c,' +
        'Location__c,Logo_URL__c,Master_Hotel_Id__c,Name,Night__c,On_Behalf_Flow__c,On_Behalf_Of_Department__c,On_Behalf_Of_Email__c,On_Behalf_Of_Employee_Id__c,'+
        'On_Behalf_Of_Flow__c,On_Behalf_Of_Function__c,On_Behalf_Of_Id__c,On_Behalf_Of_Position__c,On_Behalf_Of_Section__c,On_Behalf_Of_Unit__c,On_Behalf_Of__c,'+
        'OwnerId,PMSV_Department__c,PMSV_Email__c,PMSV_Employee_Id__c,PMSV_Function__c,PMSV_Id__c,PMSV_Position__c,PMSV_Section__c,PMSV_Unit__c,PMSV__c,' +
        'Punctuality_Rating__c,Rating_Date__c,Rating_Score__c,Reject_Comment__c,Rejected_Date__c,Remark__c,Requester_Department__c,Requester_Email__c,' +
        'Requester_Employee_Id__c,Requester_Function__c,Requester_Id__c,Requester_Name__c,Requester_Position__c,Requester_Section__c,Requester_Tel_Mobile__c,'+
        'Requester_Tel_Office__c,Requester_Unit__c,Room_JSON__c,Room__c,Send_Email_to_Hotel__c,Status__c,Submitted_Date__c,Total__c,Verified_Date__c,Thai_Oil_Amount__c,Guest_Amount__c,On_Behalf_Of_Verifying__c, ' +
        'Hotel_Id__c,PMSV_Comment__c,Total_Room_Night__c,Is_PRTR_Requester__c,Room_1_SAP_Status__c,Room_2_SAP_Status__c,Twin_Bed_Charge_Employee__c,Twin_Bed_Contract_Rate__c, ' +
        'Attentiveness_Rating_2__c, Expertise_Rating_2__c, Fast_Rating_2__c, Punctuality_Rating_2__c, Rating_Date_2__c, Rating_Score_2__c,Requester_Name_EN__c,On_Behalf_Of_EN__c,Is_Secretary_Requester__c, ' +
        'Total_Charge_Company__c,Total_Charge_Employee__c,Cancelled_By__c,Rejected_By__c,Verified_By__c,Completed_By__c,Use_This_Year_Quota__c ' +
        'FROM ESS_Hotel_Booking__c';
    }
    
    public static ESS_Hotel_Booking__c queryHotelBookingById(string recordId){
        string query = getHotelBookingDetailQuery();
        query +=  ' where Id = :recordId';
        ESS_Hotel_Booking__c model = Database.query(query);
        return model;
    }

    @RemoteAction
    public static List<ESS_HotelBooking_DTO.MasterHotelBookingDTO> MasterHotelList(ESS_HotelBooking_DTO.SearchDTO search) {
        
        List<ESS_HotelBooking_DTO.MasterHotelBookingDTO> masterHotels = new List<ESS_HotelBooking_DTO.MasterHotelBookingDTO>();
        
        string query = 'SELECT Contact_Email__c,Contact_JSON__c,Contact_Name__c,Contact_Telephone__c,CreatedDate,Guest_1_Charge_Employee__c,' +
                       'Guest_1_Contract_Rate__c,Guest_2_Charge_Employee__c,Guest_2_Contract_Rate__c,Hotel_Name__c,Hotel_Website__c,Id,' +
                       'Link_Map__c,Location__c,Attachment_Files__c,Name,OwnerId,twin_bed_charge_employee__c,twin_bed_contract_rate__c FROM ESS_Master_Hotel_Booking__c where hotel_name__c != null AND active__c = true';
        
        if(string.isNotBlank(search.search)) {
            string searchName = '%' + search.search + '%';
            query += ' and (hotel_name__c like: searchName)';
        }
        
        //Add order 
        query += ' order by hotel_name__c asc';
        
        List<ESS_Master_Hotel_Booking__c> Hotels = new List<ESS_Master_Hotel_Booking__c>();
        
        Hotels = database.query(query);
        
        if(Hotels.size() > 0) {
            for(ESS_Master_Hotel_Booking__c Hotel : Hotels) {
                ESS_HotelBooking_DTO.MasterHotelBookingDTO masterHotel = new ESS_HotelBooking_DTO.MasterHotelBookingDTO();
                masterHotel.recordId = Hotel.Id;
                masterHotel.name = Hotel.Name;
                masterHotel.hotelName = Hotel.Hotel_Name__c;
                masterHotel.hotelWebsite = Hotel.Hotel_Website__c;
                masterHotel.guest1ContractRate = Hotel.Guest_1_Contract_Rate__c;
                masterHotel.guest1ChargeEmployee = Hotel.Guest_1_Charge_Employee__c;
                masterHotel.guest2ContractRate = Hotel.Guest_2_Contract_Rate__c;
                masterHotel.guest2ChargeEmployee = Hotel.Guest_2_Charge_Employee__c;
                decimal twinBedContractRate = 0;
                decimal twinBedChargeEmployee = 0;
                if(Hotel.Twin_Bed_Contract_Rate__c == null) {
                    masterHotel.twinBedContractRate = twinBedContractRate;
                }
                else {
                    masterHotel.twinBedContractRate = Hotel.Twin_Bed_Contract_Rate__c;
                }
                if(Hotel.Twin_Bed_Charge_Employee__c == null) {
                    masterHotel.twinBedChargeEmployee = twinBedChargeEmployee;
                }
                else {
                    masterHotel.twinBedChargeEmployee = Hotel.Twin_Bed_Charge_Employee__c;
                }
                masterHotel.location = Hotel.Location__c;
                masterHotel.linkMap = Hotel.Link_Map__c;
                if (string.isNotBlank(Hotel.Attachment_Files__c)){
                    List<string> attachmentFileIds = Hotel.Attachment_Files__c.split(',');
                    masterHotel.attachmentFiles = new List<ESS_DTO.FileDTO>();
                    for (string fileId : attachmentFileIds) {
                        ESS_DTO.FileDTO fileDTO = new ESS_DTO.FileDTO();
                        fileDTO.id = fileId;
                        fileDTO.url = generateDocumentUrl(fileId);
                        masterHotel.attachmentFiles.add(fileDTO);
                    }
                }
                masterHotels.add(masterHotel);
            }
        }        
        
        return masterHotels;
        
    }
    
    @RemoteAction
    public static string ExportHotelBookingExcel(AdminSearchFilter filter) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_HotelBooking_Excel?';
        
        integer year = filter.year;
        integer month = filter.month;
        
        URL += 'year=' + year + 
            		'&month=' + month;
        
        return URL;
    }
    
    public static boolean checkPRTRAdmin(string userId){
        boolean result = false;
        //boolean isHotelAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
        if(isHotelAdmin) {
            result = true;
        }
        return result;
    }
    
    public static boolean checkCanOnlyOnBehalf(string status, string userId){
        boolean result = false;
        if (status == ESS_Enum.HotelBookingStatus.Draft.name() || 
            status == ESS_Enum.HotelBookingStatus.Rejected.name()) 
        {
            //boolean isHotelSecretary = ESS_PrivilegeHandler.checkPMSVHotelSecretaryUser(userId);
            if(isHotelSecretary) {
                result = true;
                
                //boolean isHotelPrivilege = ESS_PrivilegeHandler.checkPMSVHotelPrivilege(userId);
                result = isHotelPrivilege;
            }
            else {
                //boolean canOnlyOnBehalf = ESS_PrivilegeHandler.checkPMSVHotelPrivilege(userId);
                if(canOnlyOnBehalf) {
                    //boolean isHotelAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
                    if(isHotelAdmin) {
                        result = false;
                    }
                }
                else {
                    result = false;
                }
            }
        }
        return result;
    }
    
    public static boolean checkCanSaveHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Draft.name()) 
        {
            if (model.Requester_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkCanEditHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) 
        {
            boolean isPMSVAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
            //boolean isHotelAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
            if (isPMSVAdmin || isHotelAdmin) {
                result = true;
            }
        }
        else if (model.Status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) 
        {
            if (userId == model.On_Behalf_Of_Id__c) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkCanSendEmail(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) 
        {
            //boolean isPMSVAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
            //boolean isHotelAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
            if (isPMSVAdmin || isHotelAdmin) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkCanRejectHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) 
        {
            //boolean isPMSVAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
            //boolean isHotelAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
            
            if (isPMSVAdmin || isHotelAdmin) {
                result = true;
            }
        }
        else if (model.Status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) 
        {
            if(model.On_Behalf_Of_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkAvailableRoomHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = true;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) 
        {
            //boolean isPMSVAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
            //boolean isHotelAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
            
            if (isPMSVAdmin || isHotelAdmin) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkDeleteHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Draft.name()) 
        {
            result = true;
        }
        return result;
    }
    
    public static boolean checkCanShowContractRate(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        boolean isPMSVAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
        boolean isHotelAdmin = ESS_PrivilegeHandler.checkPMSVHotelAdminUser(userId);
        
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Draft.name()) 
        {
            result = false;
        }
        else if (isPMSVAdmin || isHotelAdmin) {
            result = true;
        }
        return result;
    }
    
    public static boolean checkCanSubmitHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Draft.name()) 
        {
            if (model.Requester_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkCanVerifyHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) 
        {
            if (model.On_Behalf_Of_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkCanCancelRequestHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Completed.name()) 
        {
            if (model.On_Behalf_Of_Id__c == userId || model.Requester_Id__c == userId || isHotelAdmin) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkCanSaveCompleteHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) 
        {
            if(isHotelAdmin) {
                result = true;
            }
            else if (model.PMSV_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkCanCompleteHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) 
        {
            if(isHotelAdmin) {
                result = true;
            }
            else if (model.PMSV_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkShowCompleteFormHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Completed.name() || 
           	model.Status__c == ESS_Enum.HotelBookingStatus.Cancel.name()) 
        {
            result = true;
        }
        if(model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name() && isHotelAdmin) {
            result = false;
        }
        return result;
    }
    
    public static boolean checkCanShowSAPStatus(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Completed.name()) 
        {
            if(isHotelAdmin) {
                result = true;
            }
        }
        
        return result;
    }
    
    public static boolean checkCanRatingHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Completed.name()) 
        {
            if(model.Requester_Id__c == userId && model.Rating_Date__c == null) {
                result = true;
            }
            else if (model.On_Behalf_Of_Flow__c && model.On_Behalf_Of_Verifying__c && 
                     model.On_Behalf_Of_Id__c == userId && model.Rating_Date_2__c == null) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkShowRatingFormHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Completed.name()) 
        {
            if (model.Rating_Date__c != null) {
                if(isHotelAdmin) {
                    result = true;
                }
                else if(model.Requester_Id__c == userId) {
                    result = true;
                }
            }
        }
        if(!result && model.Requester_Id__c == userId) {
            result = checkCanRatingHotelBooking(model,userId);
        }
        return result;
    }
    
    public static boolean checkShowRatingFormOBHHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.Completed.name()) 
        {
            if (model.Rating_Date_2__c != null) {
                if(isHotelAdmin) {
                    result = true;
                }
                else if(model.On_Behalf_Of_Id__c == userId) {
                    result = true;
                }
            }
        }
        if(!result && model.On_Behalf_Of_Id__c == userId) {
            result = checkCanRatingHotelBooking(model,userId);
        }
        return result;
    }
    
    public static boolean checkCanSaveConfirmHotelBooking(ESS_Hotel_Booking__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.HotelBookingStatus.OnProcess.name()) 
        {
            if(isHotelAdmin) {
                result = true;
            }
            else if (model.PMSV_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }
    
    public static string generateDocumentUrl(string fileId) {
        
        string finalURL;
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm();
        
        finalURL = URL + '/servlet/servlet.FileDownload?file=' + fileId + '&operationContext=S1';
        return finalURL;
        
    }
    
    @TestVisible
    private static integer GetAvailableRoom(ESS_Hotel_Booking__c model) {
        
        date todayDate = date.today();
        string employeeId = model.Requester_Employee_Id__c;
        
        ESS_Master_Employee__c Master = [select id, employee_id__c, available_room__c, available_room_next_year__c from ESS_Master_Employee__c where employee_id__c = :employeeId AND Data__c = 'IN'];

        integer availableRoom = 0;
        if(model.check_in__c != null) {
            //Get current year quota
            if(model.use_this_year_quota__c) {
            	availableRoom = Integer.ValueOf(Master.Available_Room__c);
            }
            //Get next year quota
            else {
            	availableRoom = Integer.ValueOf(Master.available_room_next_year__c);
            }
        }
        
        integer roomCount = 0;
        
        List<ESS_Hotel_Booking__c> HotelBookings = new List<ESS_Hotel_Booking__c>();
        List<string> statuses = new List<string> {ESS_Enum.HotelBookingStatus.OnProcess.name(),ESS_Enum.HotelBookingStatus.Verifying.name(),ESS_Enum.HotelBookingStatus.Completed.name()};
        
        string requesterId = model.Requester_Id__c;
            
        string query = 'select id, ownerid, on_behalf_of_flow__c, on_behalf_of_id__c, status__c, Completed_Date__c, total_room_night__c from ESS_Hotel_Booking__c where status__c IN :statuses ';
        
        if(model.use_this_year_quota__c) {
            query += ' AND use_this_year_quota__c = true';
        }
        else {
            query += ' AND use_this_year_quota__c = false';
        }
        query += ' AND ((ownerid = :requesterId AND on_behalf_of_flow__c = false) OR (on_behalf_of_id__c = :requesterId AND on_behalf_of_flow__c = true))';
        
        HotelBookings = database.query(query);
        
        if(HotelBookings.size() > 0) {
            for(ESS_Hotel_Booking__c Hotel : HotelBookings) {
                if(Hotel.status__c == ESS_Enum.HotelBookingStatus.Completed.name() && Hotel.Completed_Date__c.date() == todayDate) {
                    if(Hotel.total_room_night__c != null) {
                        roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    }
                }
                else if(Hotel.status__c == ESS_Enum.HotelBookingStatus.OnProcess.name() || 
                        Hotel.status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                    if(Hotel.total_room_night__c != null) {
                        roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    }   
                }
            }
        }
        
        availableRoom = availableRoom - roomCount;
        return availableRoom;
    }
    
    @TestVisible
    private static integer GetAvailableRoomOnBehalfOf(ESS_Hotel_Booking__c model) {
        
        date todayDate = date.today();
        string employeeId = model.On_Behalf_Of_Employee_Id__c;
        
        ESS_Master_Employee__c Master = [select id, employee_id__c, available_room__c, available_room_next_year__c from ESS_Master_Employee__c where employee_id__c = :employeeId AND Data__c = 'IN'];

        integer availableRoom = 0;
        if(model.check_in__c != null) {
            //Get current year quota
            if(model.use_this_year_quota__c) {
            	availableRoom = Integer.ValueOf(Master.Available_Room__c);
            }
            //Get next year quota
            else {
            	availableRoom = Integer.ValueOf(Master.available_room_next_year__c);
            }
        }
        
        integer roomCount = 0;
        
        List<ESS_Hotel_Booking__c> HotelBookings = new List<ESS_Hotel_Booking__c>();
        List<string> statuses = new List<string> {ESS_Enum.HotelBookingStatus.OnProcess.name(),ESS_Enum.HotelBookingStatus.Verifying.name(),ESS_Enum.HotelBookingStatus.Completed.name()};
        
        string onBehalfOfUserId = model.On_Behalf_Of_Id__c;
            
        string query = 'select id, ownerid, on_behalf_of_flow__c, on_behalf_of_id__c, status__c, Completed_Date__c, total_room_night__c from ESS_Hotel_Booking__c where status__c IN :statuses ';
        if(model.use_this_year_quota__c) {
            query += ' AND use_this_year_quota__c = true';
        }
        else {
            query += ' AND use_this_year_quota__c = false';
        }
        query += ' AND ((ownerid = :onBehalfOfUserId AND on_behalf_of_flow__c = false) OR (on_behalf_of_id__c = :onBehalfOfUserId AND on_behalf_of_flow__c = true))';
        
        HotelBookings = database.query(query);
        if(HotelBookings.size() > 0) {
            for(ESS_Hotel_Booking__c Hotel : HotelBookings) {
                if(Hotel.status__c == ESS_Enum.HotelBookingStatus.Completed.name() && Hotel.Completed_Date__c.date() == todayDate) {
                    if(Hotel.total_room_night__c != null) {
                        roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    }
                }
                else if(Hotel.status__c == ESS_Enum.HotelBookingStatus.OnProcess.name() || 
                        Hotel.status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                    if(Hotel.total_room_night__c != null) {
                        roomCount += Integer.ValueOf(Hotel.total_room_night__c);
                    }   
                }
            }
        }
        
        availableRoom = availableRoom - roomCount;
        return availableRoom;
    }
    
    @TestVisible
    private static void DeductAvailableRoom(ESS_Hotel_Booking__c model, integer totalRoom) {
        
        string employeeId;
        if(model.On_Behalf_Flow__c) {
            employeeId = model.On_Behalf_Of_Employee_Id__c;
        }
        else {
            employeeId = model.Requester_Employee_Id__c;
        }
        
        ESS_Master_Employee__c Master = [select id, employee_id__c, available_room__c from ESS_Master_Employee__c where employee_id__c = :employeeId AND Data__c = 'IN'];
		Master.Available_Room__c = Master.Available_Room__c - totalRoom;
        database.update(Master);
        
    }
    
    @TestVisible
    private static void AddAvailableRoom(ESS_Hotel_Booking__c model, integer totalRoom) {
        
        string employeeId;
        if(model.On_Behalf_Flow__c) {
            employeeId = model.On_Behalf_Of_Employee_Id__c;
        }
        else {
            employeeId = model.Requester_Employee_Id__c;
        }
        
        ESS_Master_Employee__c Master = [select id, employee_id__c, available_room__c from ESS_Master_Employee__c where employee_id__c = :employeeId AND Data__c = 'IN'];
		Master.Available_Room__c = Master.Available_Room__c + totalRoom;
        database.update(Master);
        
    }
    
    @TestVisible
    private static integer GetBookedRoom(ESS_Hotel_Booking__c model) {
        
        integer roomCount = 0;
        List<ESS_Hotel_Booking__c> AllHotelBookings = new List<ESS_Hotel_Booking__c>();
        List<ESS_Hotel_Booking__c> HotelBookings = new List<ESS_Hotel_Booking__c>();
        List<string> statuses = new List<string> {ESS_Enum.HotelBookingStatus.OnProcess.name(),ESS_Enum.HotelBookingStatus.Verifying.name(),ESS_Enum.HotelBookingStatus.Completed.name()};
        
        string query = 'select id, ownerid, on_behalf_of_flow__c, on_behalf_of_employee_id__c, status__c from ESS_Hotel_Booking__c where status__c IN :statuses ';
        if(model.On_Behalf_Of_Flow__c) {
            string onBehalfOfId = model.on_behalf_of_id__c;
            query += ' AND on_behalf_of_employee_id__c = :onBehalfOfId';
        }
        else {
            string ownerId = model.ownerId;
            query += ' AND ownerid = :ownerId';
        }
        
        date todayDate = date.today();
        
        HotelBookings = database.query(query);
        if(HotelBookings.size() > 0) {
            for(ESS_Hotel_Booking__c Hotel : HotelBookings) {
                if(Hotel.status__c == ESS_Enum.HotelBookingStatus.Completed.name() && Hotel.CreatedDate.date() == todayDate) {
                    roomCount++;
                }
                else if(Hotel.status__c == ESS_Enum.HotelBookingStatus.OnProcess.name() || 
                        Hotel.status__c == ESS_Enum.HotelBookingStatus.Verifying.name()) {
                    roomCount++;        
                }
            }
        }
        
        return roomCount;
    }
    
    @TestVisible
    private static Map<string, string> GetAllRoomTypes()
    {
        Map<string, string> statuses = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Hotel_Booking__c.Room_Type__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            statuses.put(objPickList.getLabel(),objPickList.getValue());
        }
        return statuses;
    }
    
    @TestVisible
    private static string ConvertRoomTypeToBedType(ESS_HotelBooking_DTO.HotelBookingRoomDTO Room) {
        string convertBedType;
        if(Room.roomType != null) {
            if(Room.guestNo == 1 && Room.roomType.key == ESS_Enum.HotelRoomType.KingBed.name()) {
            	convertBedType = ESS_Enum.HotelBedType.StandardSingle.name();
            }
            else if(Room.guestNo == 2 && Room.roomType.key == ESS_Enum.HotelRoomType.KingBed.name()) {
                convertBedType = ESS_Enum.HotelBedType.StandardDouble.name();
            }
            else if(Room.guestNo == 2 && Room.roomType.key == ESS_Enum.HotelRoomType.TwinBed.name()) {
                convertBedType = ESS_Enum.HotelBedType.StandardTwins.name();
            }
        }
        
        return convertBedType;
    }
    
    @TestVisible
    private static string ConvertRoomTypeToBedTypeValue(string roomType) {
        string value;
        if(roomType == ESS_Enum.HotelBedType.StandardSingle.name()) {
            value = 'Standard Single';
        }
        else if(roomType == ESS_Enum.HotelBedType.StandardDouble.name()) {
            value = 'Standard Double';
        }
        else if(roomType == ESS_Enum.HotelBedType.StandardTwins.name()) {
            value = 'Standard Twins';
        }
        return value;
    }
    
    @TestVisible
    private static Map<string, string> GetHotelSAPStatuses()
    {
        Map<string, string> statuses = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Hotel_SAP__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            statuses.put(objPickList.getValue(), objPickList.getLabel());
        }
        return statuses;
    }
    
    public class SearchFilter {
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string hotelName {get;set;}
        @RemoteAction
        public date startCheckInDate {get;set;}
        @RemoteAction
        public date endCheckInDate {get;set;}
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public date startCreatedDate {get;set;}
        @RemoteAction
        public date endCreatedDate {get;set;}
        @RemoteAction
        public date startCompletedDate {get;set;}
        @RemoteAction
        public date endCompletedDate {get;set;} 
    }
    
    public class AdminSearchFilter {
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string hotelName {get;set;}
        @RemoteAction
        public datetime startCheckInDate {get;set;}
        @RemoteAction
        public datetime endCheckInDate {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public datetime startCreatedDate {get;set;}
        @RemoteAction
        public datetime endCreatedDate {get;set;}
        @RemoteAction
        public datetime startCompletedDate {get;set;}
        @RemoteAction
        public datetime endCompletedDate {get;set;} 
        @RemoteAction
        public integer year {get;set;}
        @RemoteAction
        public integer month {get;set;}
    }
    
}