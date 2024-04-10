/* Author Softever */
global with sharing class ESS_MasterHotelBooking {

    @RemoteAction
    public static integer GetMasterHotelBookingListCount() {
        string userId = ESS_PrivilegeHandler.getUserId();
		string query = 'select count(id) from ESS_Master_Hotel_Booking__c where id != null AND hotel_name__c != null';
        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    @RemoteAction
    public static List<ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO> GetMasterHotelBookingList(
        //hotelId,hotelName,guest1ContractRate,guest1ChargeEmployee,guest_2_contract_rate__c,guest_2_charge_employee__c,twinBedContractRate,twinBedChargeEmployee,contactName,contactEmail,contactTelephone,location,hotelWebsite
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
        
        string query = getMasterHotelBookingQuery();
        
        query += ' where hotel_name__c != null';
        
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
        
        if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }
        
        List<ESS_Master_Hotel_Booking__c> models = Database.query(query);
        List<ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO> results = new List<ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO>();
        for (ESS_Master_Hotel_Booking__c model : models) {
            results.add(assignToMasterHotelBookingDTO(model));
        }

        return results;
        
    }
    
    @RemoteAction
    public static ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO GetMasterHotelBookingDetail(ESS_MasterHotelBooking_DTO.SearchDTO search) {
        
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
        ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO result;
        
        if(string.isBlank(search.recordId)) {
            
            result = new ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO();
            
            //Insert empty record
            ESS_Master_Hotel_Booking__c empty = new ESS_Master_Hotel_Booking__c();
            database.insert(empty);
            
            result.recordId = empty.id;
        }
        else {
            ESS_Master_Hotel_Booking__c model = queryMasterHotelBookingById(search.recordId);
        	result = assignToMasterHotelBookingDTO(model);
        }
        
        return result;
        
    }
    
    @RemoteAction
    public static boolean DeleteMasterHotelBooking(ESS_MasterHotelBooking_DTO.SearchDTO search) {
        ESS_Master_Hotel_Booking__c model = queryMasterHotelBookingById(search.recordId);
        database.delete(model, true);
        return true;
    }
    
    @RemoteAction
    public static ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO SaveMasterHotelBooking(ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO input) {
        ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO masterHotel = new ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO();
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isCreateNew = false;
        ESS_Master_Hotel_Booking__c model;
        
        if (string.isNotBlank(input.recordId)){
            model = queryMasterHotelBookingById(input.recordId);
        } else {
            isCreateNew = true;
            model = new ESS_Master_Hotel_Booking__c();
            model.OwnerId = userId;
        }
        
        if (input.attachmentFiles != null) {
            List<string> attachmentIds = new List<string>();
            for (ESS_DTO.FileDTO file : input.attachmentFiles) {
                attachmentIds.add(file.id);
            }
            model.Attachment_Files__c = String.join(attachmentIds, ',');
        }  
        
        model.Name = input.hotelId;
        if(input.active == null) {
            model.Active__c = false;
        }
        else {
             model.Active__c = input.active;
        }
        model.Hotel_Name__c = input.hotelName;
        model.Hotel_Website__c = input.hotelWebsite;
        model.Location__c = input.location;
        model.Link_Map__c = input.linkMap;
        model.Guest_1_Contract_Rate__c = input.guest1ContractRate;
        model.Guest_1_Charge_Employee__c = input.guest1ChargeEmployee;
        model.Guest_2_Contract_Rate__c = input.guest2ContractRate;
        model.Guest_2_Charge_Employee__c = input.guest2ChargeEmployee;
        model.Twin_Bed_Contract_Rate__c = input.twinBedContractRate;
        model.Twin_Bed_Charge_Employee__c = input.twinBedChargeEmployee;
        
        if (input.masterHotelBookingContacts != null && input.masterHotelBookingContacts.size() > 0) {
            model.Contact_JSON__c = JSON.serialize(input.masterHotelBookingContacts);
            model.Contact_Name__c = input.masterHotelBookingContacts[0].contactName;
            model.Contact_Email__c = input.masterHotelBookingContacts[0].contactEmail;
            model.Contact_Telephone__c = input.masterHotelBookingContacts[0].contactTelephone;
        }
        
        if(isCreateNew){
            database.insert(model, true);
            
            //Get Empty record
            ESS_Master_Hotel_Booking__c empty = queryMasterHotelBookingById(input.recordId);
            //Manage file and change parent id
            ChangeUploadFileParentId(empty.Id, model.Id);
        }else{
            database.update(model, true);
        }
        
        
        ESS_MasterHotelBooking_DTO.SearchDTO search = new ESS_MasterHotelBooking_DTO.SearchDTO();
        search.recordId = model.Id;
        ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO result = GetMasterHotelBookingDetail(search);
        return result;
    }
    
    @RemoteAction
    public static boolean CheckMasterHotelBookingID(string hotelBookingId) {
        string query = 'select count(name) from ESS_Master_Hotel_Booking__c where name = :hotelBookingId';
        
        AggregateResult result = Database.query(query);
        integer count = (Integer) result.get('expr0');
        if(count == 0) {
            return false;
        }
        else {
            return true;
        }
    }
    
    @RemoteAction
    public static string UploadFile(ESS_MasterHotelBooking_DTO.UploadFileDTO UploadFile) {
        
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
    
    public static ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO assignToMasterHotelBookingDTO(ESS_Master_Hotel_Booking__c model) {
        ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO result = new ESS_MasterHotelBooking_DTO.MasterHotelBookingDTO();
        result.recordId = model.Id;
        result.active = model.active__c;
        result.hotelId = model.Name;
        result.guest1ChargeEmployee = model.Guest_1_Charge_Employee__c;
        result.guest1ContractRate = model.Guest_1_Contract_Rate__c;
        result.guest2ChargeEmployee = model.Guest_2_Charge_Employee__c;
        result.guest2ContractRate = model.Guest_2_Contract_Rate__c;
        result.twinBedChargeEmployee = model.Twin_Bed_Charge_Employee__c;
        result.twinBedContractRate = model.Twin_Bed_Contract_Rate__c;
        result.hotelName = model.Hotel_Name__c;
        result.hotelWebsite = model.Hotel_Website__c;
        result.linkMap = model.Link_Map__c;
        result.location = model.Location__c;
        result.canDelete = true;
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
        result.masterHotelBookingContacts = new List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO>();
        if(model.Contact_JSON__c != null) {
            result.masterHotelBookingContacts = (List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO>)JSON.deserialize(model.Contact_JSON__c, List<ESS_MasterHotelBooking_DTO.MasterHotelBookingContactDTO>.class);
        }
        
        return result;
    }
    
	public static ESS_Master_Hotel_Booking__c queryMasterHotelBookingById(string recordId){
        string query = getMasterHotelBookingQuery();
        query +=  ' where Id = :recordId';
        ESS_Master_Hotel_Booking__c model = Database.query(query);
        return model;
    }
    
    public static string getMasterHotelBookingQuery()
    {
        return 
        'select id, name, contact_json__c, guest_1_charge_employee__c, guest_1_contract_rate__c, guest_2_charge_employee__c, guest_2_contract_rate__c, hotel_name__c, ' +
        'hotel_website__c, link_map__c, location__c, attachment_files__c, active__c, twin_bed_charge_employee__c, twin_bed_contract_rate__c' +
        ' from ESS_Master_Hotel_Booking__c';
    }
    
    public static string generateDocumentUrl(string fileId) {
        
        string finalURL;
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm();
        
        finalURL = URL + '/servlet/servlet.FileDownload?file=' + fileId + '&operationContext=S1';
        return finalURL;
        
    }
    
    @TestVisible
    private static void ChangeUploadFileParentId(string oldParentId, string newParentId) {
        List<Attachment> Attachs = new List<Attachment>();
        List<Attachment> newAttachs = new List<Attachment>();
        
        Attachs = [select id, parentId, name, body from Attachment where parentId =: oldParentId];
        if(Attachs.size() > 0) {
            for(Attachment attach : Attachs) {
                Attachment newAttach = new Attachment();
                newAttach.name = attach.name;
                newAttach.parentId  = newParentId;
                newAttach.body = attach.body;
                newAttachs.add(newAttach);
            }
            
            //Insert into new record
            if(newAttachs.size() > 0) {
                database.insert(newAttachs, true);
            }
        }
    }
    
    public class SearchCriteria {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string hotelName {get;set;}
        @RemoteAction
        public decimal guest1ChargeEmployee {get;set;}
        @RemoteAction
        public decimal guest1ContractRate {get;set;}
        @RemoteAction
        public decimal guest2ChargeEmployee {get;set;}
        @RemoteAction
        public decimal guest2ContractRate {get;set;}
        @RemoteAction
        public string contactName {get;set;}
        @RemoteAction
        public string contactEmail {get;set;}
        @RemoteAction
        public string contactTelephone {get;set;}
        @RemoteAction
        public string hotelWebsite {get;set;}
        @RemoteAction
        public string linkMap {get;set;}
        
    }
    
}