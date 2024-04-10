global with sharing class ESS_FixAndGeneral {
    
    @RemoteAction
    public static integer GetFixAndGeneralListCount(
        FixAndGeneralListFilter filter
    )
    {
        string userId = ESS_PrivilegeHandler.getUserId();

        string query = 'select count(id) from ESS_FixAndGeneral__c where id != null and document_no__c != null';

        //Add authorize filter
        query +=  ' and (OwnerId = :userId or On_Behalf_Of_Id__c = :userId)';

        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
                
                //On Behalf Verifying Page
                if(status == ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name()) {
                    query += ' and (Requester_Id__c != :userId AND On_Behalf_Of_Id__c != null)';
                }
            }
            if (string.isNotBlank(filter.topic)) {
                string topic = '%' + filter.topic + '%';
                query += ' and Topic__c like :topic';
            }
            if (string.isNotBlank(filter.typeOfServices)) {
                List<string> typeOfServices = filter.typeOfServices.split(',');
                query += ' and Type_of_Service__c in :typeOfServices';
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
                
                if(filter.status.toLowerCase() == 'all') {
                    string completedStatus = ESS_Enum.FixAndGeneralDocumentStatus.Completed.name();
                    query = query + ' AND status__c = :completedStatus';
                }
                
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
    public static List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> GetFixAndGeneralList(
        FixAndGeneralListFilter filter,
        //documentNo, status, topic, typeOfService, createdDate, completedDate
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam
    )
    {
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
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

        string query = getFixAndGeneralCardQuery();

        //Add authorize filter
        query +=  ' where (document_no__c != null and (OwnerId = :userId or On_Behalf_Of_Id__c = :userId))';

        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
                
                //On Behalf Verifying Page
                if(status == ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name()) {
                    query += ' and (Requester_Id__c != :userId AND On_Behalf_Of_Id__c != null)';
                }
            }
            if (string.isNotBlank(filter.topic)) {
                string topic = '%' + filter.topic + '%';
                query += ' and Topic__c like :topic';
            }
            if (string.isNotBlank(filter.typeOfServices)) {
                List<string> typeOfServices = filter.typeOfServices.split(',');
                query += ' and Type_of_Service__c in :typeOfServices';
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
                
                if(filter.status.toLowerCase() == 'all') {
                    string completedStatus = ESS_Enum.FixAndGeneralDocumentStatus.Completed.name();
                    query = query + ' AND status__c = :completedStatus';
                }
                
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
             else if(sortByParam.sortBy == 'topic') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Topic__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Topic__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'typeOfService') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Type_of_Service__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Type_of_Service__c desc';
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
             }else {
                sortByQuery += ' createddate desc';
             }
             query += sortByQuery;
         }else{
            query += ' order by CreatedDate desc';
         }
        
        /* if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        } */

        List<ESS_FixAndGeneral__c> models = Database.query(query);
        List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> results = new List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO>();
        for (ESS_FixAndGeneral__c model : models) {
            results.add(assignToFixAndGeneralCardDTO(model));
        }

        return results;
    }

    @RemoteAction
    public static integer GetFixAndGeneralForAdminListCount(
        FixAndGeneralForAdminListFilter filter
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
        
        string query = 'select count(id) from ESS_FixAndGeneral__c where id != null';

        //Add authorize filter
        boolean isPMSV = ESS_PrivilegeHandler.checkPMSVUser(userId);
        boolean isPMSVFixAndGeneralAdmin = ESS_PrivilegeHandler.checkPMSVFixAndGeneralAdminUser(userId);
        boolean isPMSVTransportationAdmin = ESS_PrivilegeHandler.checkPMSVTransportationAdminUser(userId);
        if (!isPMSV && !isPMSVFixAndGeneralAdmin && !isPMSVTransportationAdmin) {
            query +=  ' and ((Status__c != \'OnProcess\' and Status__c != \'Completed\') or (PMSV_Id__c = :userId))';   
        }
        
        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                List<string> statuses = filter.status.split(',');
                query += ' and Status__c IN :statuses';
            }
            if (string.isNotBlank(filter.employeeName)) {
                string employeeName = '%' + filter.employeeName + '%';
                query += ' and Requester_Name_EN__c like :employeeName';
            }
            if (string.isNotBlank(filter.topic)) {
                string topic = '%' + filter.topic + '%';
                query += ' and Topic__c like :topic';
            }
            if (string.isNotBlank(filter.typeOfServices)) {
                List<string> typeOfServices = filter.typeOfServices.split(',');
                query += ' and Type_of_Service__c in :typeOfServices';
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
            if (filter.startAcceptedDate != null){
                datetime startAcceptedDate = ESS_Global.convertDateTimeFilter(filter.startAcceptedDate);
                query = query + ' AND (Accepted_Date__c >=: startAcceptedDate)';
            }
            if (filter.endAcceptedDate != null){
                datetime endAcceptedDate = ESS_Global.convertDateTimeFilter(filter.endAcceptedDate);
                query = query + ' AND (Accepted_Date__c <=: endAcceptedDate)';
            }
            if (string.isNotBlank(filter.pmsvEmployeeName)) {
                string pmsvEmployeeName = '%' + filter.pmsvEmployeeName + '%';
                query += ' and PMSV__c like :pmsvEmployeeName';
            }
        }
        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }

    @RemoteAction
    public static List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> GetFixAndGeneralForAdminList(
        FixAndGeneralForAdminListFilter filter,
        //documentNo, status, topic, typeOfService, createdDate, completedDate, acceptedDate
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
        
        string query = getFixAndGeneralCardQuery();
        query += ' where id != null';
        
		boolean isPMSV = ESS_PrivilegeHandler.checkPMSVUser(userId);
        boolean isPMSVFixAndGeneralAdmin = ESS_PrivilegeHandler.checkPMSVFixAndGeneralAdminUser(userId);
        boolean isPMSVTransportationAdmin = ESS_PrivilegeHandler.checkPMSVTransportationAdminUser(userId);
        if (!isPMSV && !isPMSVFixAndGeneralAdmin && !isPMSVTransportationAdmin) {
            query +=  ' and ((Status__c != \'OnProcess\' or Status__c != \'Completed\' or Status__c != \'Waiting\') or (PMSV_Id__c = :userId))';
        }
        
        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                List<string> statuses = filter.status.split(',');
                query += ' and Status__c IN :statuses';
            }
            if (string.isNotBlank(filter.employeeName)) {
                string employeeName = '%' + filter.employeeName + '%';
                query += ' and Requester_Name_EN__c like :employeeName';
            }
            if (string.isNotBlank(filter.topic)) {
                string topic = '%' + filter.topic + '%';
                query += ' and Topic__c like :topic';
            }
            if (string.isNotBlank(filter.typeOfServices)) {
                List<string> typeOfServices = filter.typeOfServices.split(',');
                query += ' and Type_of_Service__c in :typeOfServices';
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
            if (filter.startAcceptedDate != null){
                datetime startAcceptedDate = ESS_Global.convertDateTimeFilter(filter.startAcceptedDate);
                query = query + ' AND (Accepted_Date__c >=: startAcceptedDate)';
            }
            if (filter.endAcceptedDate != null){
                datetime endAcceptedDate = ESS_Global.convertDateTimeFilter(filter.endAcceptedDate);
                query = query + ' AND (Accepted_Date__c <=: endAcceptedDate)';
            }
            if (string.isNotBlank(filter.pmsvEmployeeName)) {
                string pmsvEmployeeName = '%' + filter.pmsvEmployeeName + '%';
                query += ' and PMSV__c like :pmsvEmployeeName';
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
             else if(sortByParam.sortBy == 'topic') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Topic__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Topic__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'typeOfService') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Type_of_Service__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Type_of_Service__c desc';
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
             }
             else if(sortByParam.sortBy == 'acceptedDate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Accepted_Date__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Accepted_Date__c desc';
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

        List<ESS_FixAndGeneral__c> models = Database.query(query);
        List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> results = new List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO>();
        for (ESS_FixAndGeneral__c model : models) {
            results.add(assignToFixAndGeneralCardDTO(model));
        }

        return results;
    }

    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO GetFixAndGeneralDetail(string recordId)
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

        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result;

        if (string.isBlank(recordId)) {
            //assign default dto
            result = new ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO();
            result.status = new ESS_Global.EnumValue('FixAndGeneralDocumentStatus');
            result.status.key = ESS_Enum.FixAndGeneralDocumentStatus.Draft.name();
            result.status.value = result.status.key;
            result.requesterId = userId;
            
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
                result.requesterEmployeeId = user.Employee_Id__c;
                string firstNameTH = '';
                string lastNameTH = '';
                string firstNameEN = '';
                string lastNameEN = '';
                if(string.isNotEmpty(user.FirstName_TH__c)) {
                    firstNameTH = user.FirstName_TH__c;
                }
                if(string.isNotEmpty(user.LastName_TH__c)) {
                    lastNameTH = user.LastName_TH__c;
                }
                if(string.isNotEmpty(user.FirstName)) {
                    firstNameEN = user.FirstName;
                }
                if(string.isNotEmpty(user.LastName)) {
                    lastNameEN = user.LastName;
                }
                result.requesterEmployeeName = firstNameTH + ' ' + lastNameTH;
                result.requesterEmployeeNameEN = firstNameEN + ' ' + lastNameEN;
                result.requesterEmail = user.Email;
                result.requesterPosition = user.Position__c;
                result.requesterUnit = user.Unit__c;
                result.requesterSection = user.Section__c;
                //result.requesterDepartment = user.department;
                result.requesterFunction = user.Function__c;
                result.isPRTRUser = true;
                result.canOnlyOnBehalf = true;
            }
            
            result.canSave = true;
            result.canSubmit = true;
            
            //Insert empty record
            ESS_FixAndGeneral__c empty = new ESS_FixAndGeneral__c();
            database.insert(empty);
            
            result.recordId = empty.id;

        }else {
            
            ESS_FixAndGeneral__c model = queryFixAndGeneralById(recordId);
            result = assignToFixAndGeneralDetailDTO(model);
            
        }

        return result;
    }

    //การ Save ตอนเปิดงาน
    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO SaveFixAndGeneral(ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO input)
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isCreateNew = false;
        ESS_FixAndGeneral__c model;
        if (string.isNotBlank(input.documentNo)){
            model = queryFixAndGeneralById(input.recordId);
        }else{
            
            model = new ESS_FixAndGeneral__c();
            isCreateNew = true;
            string runningNo = ESS_LogicHandler.GenerateRunningNo('FixAndGeneral');
            string year = ESS_LogicHandler.GetCurrentYear();
            string month = ESS_LogicHandler.GetCurrentMonth();
            string prefix = '';
            if (input.typeOfService.key == ESS_Enum.FixTypeOfService.OfficeEquipment.name()) {
                prefix = 'MT';
            }else if (input.typeOfService.key == ESS_Enum.FixTypeOfService.Housing.name()) {
                prefix = 'HS';
            }else if (input.typeOfService.key == ESS_Enum.FixTypeOfService.Transportation.name()) {
                prefix = 'TS';
            }else if (input.typeOfService.key == ESS_Enum.FixTypeOfService.GeneralService.name()) {
                prefix = 'GS';
            }
            model.Document_No__c = prefix + '-' + year + '-' + month + '-' + runningNo;
            model.OwnerId = userId;
            model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Draft.name();
            
        }
        model.Type_of_Service__c = input.typeOfService.key;
        model.On_Behalf_Flow__c = input.onBehalfFlow;
        model.Areas__c = input.repairArea;
        model.Buildings__c = input.officeBuilding;
        model.Floors__c = input.floor;
        model.Tel_No__c = input.telNo;
        model.Mobile_No__c = input.mobileNo;
        model.Topic__c = input.topic;
        model.Detail__c = input.detail;
        model.Expected_Due_Date__c = input.expectedDueDate;
        model.Location__c = input.location;
        
        //PRTR Requester
        model.Is_PRTR_Requester__c = input.isPRTRUser;
        
        if (input.attachmentFiles != null) {
            List<string> attachmentIds = new List<string>();
            for (ESS_DTO.FileDTO file : input.attachmentFiles) {
                attachmentIds.add(file.id);
            }
            model.Attachment_Files__c = String.join(attachmentIds, ',');
        }  
        
        model.House_No__c = input.houseNo;
        if(input.period != null) {
            model.Period__c = input.period.key;
        }
        model.Repair_Date__c = input.repairDate;
        if(input.houseType != null) {
        	model.House_Type__c = input.houseType.key;    
        }
        
        if (input.transportationItems != null && input.transportationItems.size() > 0) {
            model.Transportation_Items__c = JSON.serialize(input.transportationItems);
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

        if (input.onBehalfFlow) {
            if(input.onBehalfOfId == null) {
                throw new ESS_Exception('[MyError]กรุณาเลือกคนที่จะ On Behalf Of');
            }
            model.Is_On_Behalf__c = input.onBehalfFlow;
            model.On_Behalf_Flow__c = input.onBehalfFlow;
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

        if(isCreateNew){
            database.insert(model, true);
            
            //Get Empty record
            ESS_FixAndGeneral__c empty = queryFixAndGeneralById(input.recordId);
            //Manage file and change parent id
            ChangeUploadFileParentId(empty.Id, model.Id);
        }else{
            database.update(model, true);
        }

        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = GetFixAndGeneralDetail(model.Id);
        return result;
    }

    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO SubmitFixAndGeneral(ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO input)
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        
        input = SaveFixAndGeneral(input);

        ESS_FixAndGeneral__c model = queryFixAndGeneralById(input.recordId);
        model.Submitted_Date__c = system.datetime.now();
        if (model.On_Behalf_Flow__c) {
            model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name();
            ESS_FixAndGeneralNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
        }else {
            model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name();
            ESS_FixAndGeneralNotification.SendToAdminPMSVWhenRequested(model);
        }

        database.update(model, true);

        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = GetFixAndGeneralDetail(input.recordId);
        return result;
    }

    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO VerifyFixAndGeneral(string recordId)
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        ESS_FixAndGeneral__c model = queryFixAndGeneralById(recordId);
        
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name()) {
            model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name();
            model.Verified_Date__c = system.datetime.now();
            database.update(model, true);
            
            ESS_FixAndGeneralNotification.SendToAdminPMSVWhenRequested(model);
            
        }

        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = GetFixAndGeneralDetail(recordId);
        return result;
    }

    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO RejectFixAndGeneral(string recordId, string rejectComment)
    {
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
        
        ESS_FixAndGeneral__c model = queryFixAndGeneralById(recordId);
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name()) {
            model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Rejected.name();
            model.Reject_Comment__c = rejectComment;
            if(isPRTRUser) {
                model.Rejected_By__c = User.FirstName + ' ' + User.LastName;
            }
            else {
                model.Rejected_By__c = PISUser.EN_Fullname__c;
            }
            model.Rejected_Date__c = system.datetime.now();
            if (model.On_Behalf_Flow__c) {
            	ESS_FixAndGeneralNotification.SendToEmployeeAdminWhenEmployeeReject(model);
            }
            else {
                ESS_FixAndGeneralNotification.SendToEmployeeAdminWhenEmployeeReject(model);
            }
            database.update(model, true);
        }
        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = GetFixAndGeneralDetail(recordId);
        return result;
    }

    @RemoteAction
    public static List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> VerifyMultipleFixAndGeneral(List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> inputs)
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        List<ESS_FixAndGeneral__c> fixAndGenerals = new List<ESS_FixAndGeneral__c>();
        List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> results = new List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO>();
        for (ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO input : inputs) {
            if (input.isSelected) {
                ESS_FixAndGeneral__c model = queryFixAndGeneralById(input.recordId);
                if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name()) {
                    model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name();
                    model.Verified_Date__c = system.datetime.now();
                    database.update(model, true);
                    fixAndGenerals.add(model);
                    //ESS_FixAndGeneralNotification.SendEmailWhenVerifyMultiple(model);
                }

                string recordId = input.recordId;
                string query = getFixAndGeneralCardQuery();
                query +=  ' where Id = :recordId';
                ESS_FixAndGeneral__c cardModel = Database.query(query);
                results.add(assignToFixAndGeneralCardDTO(cardModel));

            }else{
                results.add(input);
            }
        }
        
        if(fixAndGenerals.size() > 0) {
            ESS_FixAndGeneralNotification.SendEmailWhenVerifyMultiple(fixAndGenerals);
        }
        
        return results;
    }

    @RemoteAction
    public static List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> RejectMultipleFixAndGeneral(List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> inputs, string comment)
    {
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
        List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> results = new List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO>();
        for (ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO input : inputs) {
            if (input.isSelected) {
                ESS_FixAndGeneral__c model = queryFixAndGeneralById(input.recordId);
        
                if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name()) {
                    model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Rejected.name();
                    model.Rejected_Date__c = system.datetime.now();
                    model.Reject_Comment__c = comment;
                    if(isPRTRUser) {
                        model.Rejected_By__c = User.FirstName + ' ' + User.LastName;
                    }
                    else {
                        model.Rejected_By__c = PISUser.EN_Fullname__c;
                    }
                    database.update(model, true);
                    
                    ESS_FixAndGeneralNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }

                string recordId = input.recordId;
                string query = getFixAndGeneralCardQuery();
                query +=  ' where Id =: recordId';
                ESS_FixAndGeneral__c cardModel = Database.query(query);
                results.add(assignToFixAndGeneralCardDTO(cardModel));

            }else{
                results.add(input);
            }
        }
        
        return results;
    }

    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO CancelRequestFixAndGeneral(string recordId, string cancelComment)
    {
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
        
        ESS_FixAndGeneral__c model = queryFixAndGeneralById(recordId);
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name()) {
                
            model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Cancelled.name();
            if(isPRTRUser) {
                model.Cancelled_By__c = User.FirstName_EN__c + ' ' + User.LastName_EN__c;
            }
            else {
                model.Cancelled_By__c = PISUser.EN_Fullname__c;
            }
            model.Cancelled_Date__c = system.datetime.now();
            model.Cancel_Comment__c = cancelComment;
            database.update(model, true);
            
            if(userId == model.Requester_Id__c || userId == model.On_Behalf_Of_Id__c) {
                ESS_FixAndGeneralNotification.SendToEmployeeAndAdminPMSVWhenCancel(model);
            }
            else {
                ESS_FixAndGeneralNotification.SendToEmployeeAndCCAdminWhenAdminCancel(model);
            }    
            
        }
        else if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name()) {
                
            model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Cancelled.name();
            if(isPRTRUser) {
                model.Cancelled_By__c = User.FirstName_EN__c + ' ' + User.LastName_EN__c;
            }
            else {
                model.Cancelled_By__c = PISUser.EN_Fullname__c;
            }
            model.Cancelled_Date__c = system.datetime.now();
            model.Cancel_Comment__c = cancelComment;
            database.update(model, true);
            
            ESS_FixAndGeneralNotification.SendToEmployeeAndCCAdminWhenAdminCancel(model);
        }
        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = GetFixAndGeneralDetail(recordId);
        return result;
    }


    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO AcceptFixAndGeneral(string recordId)
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
        
        ESS_FixAndGeneral__c model = queryFixAndGeneralById(recordId);
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name()) {
            model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name();
            model.Accepted_Date__c = system.datetime.now();
            
            model.PMSV_Id__c = userId;
            if(!isPRTRUser) {
                model.PMSV__c = loginedUser.EN_Fullname__c;
                model.PMSV_Employee_Id__c = loginedUser.EMPLOYEEID__c;
                model.PMSV_Email__c = loginedUser.EMAIL__c;
                model.PMSV_Position__c = loginedUser.OBJENFULLNAME__c;
                model.PMSV_Unit__c = loginedUser.UNITS__c;
                model.PMSV_Section__c = loginedUser.SECTIONS__c;
                model.PMSV_Department__c = loginedUser.DEPARTMENT__c;
                model.PMSV_Function__c = loginedUser.FUNCTION__c;
            }
            else {
                model.PMSV__c = user.Name;
                model.PMSV_Employee_Id__c = user.Employee_Id__c;
                model.PMSV_Email__c = user.Email;
                model.PMSV_Position__c = user.Position__c;
                model.PMSV_Unit__c = user.Unit__c;
                model.PMSV_Section__c = user.Section__c;
                model.PMSV_Department__c = user.Department;
                model.PMSV_Function__c = user.Function__c;
                model.Is_PRTR_Admin__c = true;
            }
            
            database.update(model, true);
            
            ESS_FixAndGeneralNotification.SendToAdminPMSVWhenAccepted(model);
        }
        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = GetFixAndGeneralDetail(recordId);
        return result;
    }

    //การ Save ก่อนปิดงาน (ให้ใช้ปุ่มแยกกับตอนเปิดงาน ใช้ flag canSaveCompleted)
    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO SaveCompleteFixAndGeneral(ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO input)
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        ESS_FixAndGeneral__c model = queryFixAndGeneralById(input.recordId);
        
        List<string> attachmentIds = new List<string>();
        if(input.completedAttachmentFiles != null) {
        	for (ESS_DTO.FileDTO file : input.completedAttachmentFiles) {
                attachmentIds.add(file.id);
            }   
        }
        
        model.Completed_Attachment_Files__c = String.join(attachmentIds, ',');

        if (model.Type_of_Service__c == ESS_Enum.FixTypeOfService.OfficeEquipment.name()) {
            if(input.officeTypeOfService == null) {
                throw new ESS_Exception(
                    		'[MyError]กรุณาระบุประเภทการซ่อม'); 
            }
            model.Office_Type_of_Service__c = input.officeTypeOfService.key;
            model.Office_Type_Of_Service_Other__c = input.officeTypeOfServiceOther;
            model.Office_Cost__c = input.officeCost;
            model.Office_Detail__c = input.officeDetail;
            model.Office_Internal_Detail__c = input.officeInternalDetail;
        }
        else if (model.Type_of_Service__c == ESS_Enum.FixTypeOfService.Housing.name()) {
            if(input.housingTypeOfService == null) {
                throw new ESS_Exception(
                    		'[MyError]กรุณาระบุประเภทการซ่อม'); 
            }
            model.Housing_Type_of_Service__c = input.housingTypeOfService.key;
            model.Housing_Type_Of_Service_Other__c = input.housingTypeOfServiceOther;
            model.Housing_Cost__c = input.housingCost;
            model.Housing_Detail__c = input.housingDetail;
            model.Housing_Internal_Detail__c = input.housingInternalDetail;
        }else if (model.Type_of_Service__c == ESS_Enum.FixTypeOfService.Transportation.name()) {
            if(input.transportationTypeOfService == null) {
                throw new ESS_Exception(
                    		'[MyError]กรุณาระบุประเภทการซ่อม'); 
            }
            model.Transportation_Type_Of_Service__c = input.transportationTypeOfService.key;
            model.Transportation_Type_Of_Service_Other__c = input.transportationTypeOfServiceOther;
            model.Transportation_Cost__c = input.transportationCost;
            model.Transportation_Detail__c = input.transportationDetail;
            model.Transportation_Internal_Detail__c = input.transportationInternalDetail;
        }else if (model.Type_of_Service__c == ESS_Enum.FixTypeOfService.GeneralService.name()) {
            if(input.generalTypeOfService == null) {
                throw new ESS_Exception(
                    		'[MyError]กรุณาระบุประเภทการซ่อม'); 
            }
            model.General_Type_Of_Service__c = input.generalTypeOfService.key;
            model.General_Type_Of_Service_Other__c = input.generalTypeOfServiceOther;
            model.General_Cost__c = input.generalCost;
            model.General_Detail__c = input.generalDetail;
            model.General_Internal_Detail__c = input.generalInternalDetail;
        }

        database.update(model, true);
        
        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = GetFixAndGeneralDetail(model.Id);
        return result;
    }

    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO CompleteFixAndGeneral(ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO input)
    {
        input = SaveCompleteFixAndGeneral(input);
        ESS_FixAndGeneral__c model = queryFixAndGeneralById(input.recordId);
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
        
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name()) {
            model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Completed.name();
            
            if(isPRTRUser) {
                model.Completed_By__c = User.FirstName + ' ' + User.LastName;
            	model.Completed_By_Email__c = User.Email;
            }
            else {
                model.Completed_By__c = PISUser.EN_Fullname__c;
            	model.Completed_By_Email__c = PISUser.EMAIL__c;
            }
            
            model.Completed_Date__c = system.datetime.now();
            database.update(model, true);
        	ESS_FixAndGeneralNotification.SendToEmployeeAndAdminWhenCompleted(model);

        }
        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = GetFixAndGeneralDetail(input.recordId);
        return result;
    }

    @RemoteAction
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO SaveRatingFixAndGeneral(ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO input)
    {
        string userId = ESS_PrivilegeHandler.getUserId();
        ESS_FixAndGeneral__c model = queryFixAndGeneralById(input.recordId);
        
        if(model.Requester_Id__c == userId) {
            model.Rating_Score__c = input.ratingScore;
            model.Attentiveness_Rating__c = input.attentivenessRating;
            model.Fast_Rating__c = input.fastRating;
            model.Punctuality_Rating__c = input.punctualityRating;
            model.Expertise_Rating__c = input.expertiseRating;
            model.Rating_Date__c = system.datetime.now();
        }
        if(model.On_Behalf_Flow__c) {
            if(model.On_Behalf_Of_Id__c == userId) {
                model.Rating_Score_2__c = input.ratingScoreOBH;
                model.Attentiveness_Rating_2__c = input.attentivenessRatingOBH;
                model.Fast_Rating_2__c = input.fastRatingOBH;
                model.Punctuality_Rating_2__c = input.punctualityRatingOBH;
                model.Expertise_Rating_2__c = input.expertiseRatingOBH;
                model.Rating_Date_2__c = system.datetime.now();
            }
        }
        database.update(model, true);

        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = GetFixAndGeneralDetail(model.Id);
        return result;
    }

    @RemoteAction
    public static boolean DeleteFixAndGeneral(string recordId)
    {
        ESS_FixAndGeneral__c model = queryFixAndGeneralById(recordId);
        database.delete(model, true);
        return true;
    }

    @RemoteAction
    public static List<string> GetAreas() {
        List<string> results = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Areas__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            results.add(objPickList.getLabel());
        }
        return results;
    }

    @RemoteAction
    public static integer GetOnBehalfCount() {
        string userId = ESS_PrivilegeHandler.getUserId();

        string query = 'select count(id) from ESS_FixAndGeneral__c where id != null and On_Behalf_Of_Id__c = :userId and Status__c = \'Verifying\'';

        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }

    @RemoteAction
    public static List<string> GetBuildings(string area, string searchKey) {
        List<string> pickList = new List<string>();
        Map<String, List<String>> getAllBuildings = getBuildingDependentPicklistValues();
        
        if(getAllBuildings.size() > 0) {
             
            for(string a : getAllBuildings.keyset())
            {
                if(a == area) {
                    for(string org : getAllBuildings.get(area)) { 
                        pickList.add(org);
                    }
                }
            }
        }

        List<string> results = new List<string>();
        if (string.isBlank(searchKey)) {
            results = pickList;
        }else{
            for (string item : pickList) {
                if (item.toLowerCase().contains(searchKey.toLowerCase())) {
                    results.add(item);
                }
            }
        }
        
        return results;
    }

    @RemoteAction
    public static List<string> GetFloors(string area, string building, string searchKey) {
        List<string> pickList = new List<string>();
        
        if (string.isNotBlank(building) && building != 'null' && building != null) {
            Map<String, List<String>> getAllFloors = getFloorDependentPicklistValues();
        
            if(getAllFloors.size() > 0) {
                
                for(string a : getAllFloors.keyset())
                {
                    if(a == building) {
                        for(string org : getAllFloors.get(building)) { 
                            pickList.add(org);
                        }
                    }
                }
            }
        }else{
            Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Floors__c.getDescribe();
            List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
            for (Schema.PicklistEntry objPickList : lstPickListValues) {
                pickList.add(objPickList.getLabel());
            }
        }

        List<string> results = new List<string>();
        if (string.isBlank(searchKey)) {
            results = pickList;
        }else{
            for (string item : pickList) {
                if (item.toLowerCase().contains(searchKey.toLowerCase())) {
                    results.add(item);
                }
            }
        }
        
        return results;
    }

    @RemoteAction
    public static List<string> GetFixTypeOfServices() {
        List<string> results = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Type_of_Service__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            results.add(objPickList.getLabel());
        }
        return results;
    }

    @RemoteAction
    public static List<string> GetFixAndGeneralDocumentStatuses() {
        List<string> results = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            results.add(objPickList.getLabel());
        }
        return results;
    }

    @RemoteAction
    public static List<string> GetHousingTypeOfService() {
        List<string> results = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Housing_Type_of_Service__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            results.add(objPickList.getLabel());
        }
        return results;
    }

    @RemoteAction
    public static List<string> GetTransportationTypeOfServices() {
        List<string> results = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Transportation_Type_Of_Service__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            results.add(objPickList.getLabel());
        }
        return results;
    }

    @RemoteAction
    public static List<string> GetGeneralTypeOfServices() {
        List<string> results = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.General_Type_Of_Service__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            results.add(objPickList.getLabel());
        }
        return results;
    }

    @RemoteAction
    public static List<string> GetHousingPeriods() {
        List<string> results = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Period__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            results.add(objPickList.getLabel());
        }
        return results;
    }

    @RemoteAction
    public static List<string> GetHousingTypes() {
        List<string> results = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.House_Type__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            results.add(objPickList.getLabel());
        }
        return results;
    }

    @RemoteAction
    public static List<string> GetOfficeTypeOfServices() {
        List<string> results = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_FixAndGeneral__c.Office_Type_Of_Service__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            results.add(objPickList.getLabel());
        }
        return results;
    }

    //ตรวจสอบว่าเป็น PMSV งานแจ้งซ่อม หรือ งานยานพาหนะ สำหรับตัดสินใจเข้า Menu รายการแจ้งซ่อม
    @RemoteAction
    public static string GetPMSVAdminType(){
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isPMSV = ESS_PrivilegeHandler.checkPMSVUser(userId);
        boolean isPMSVFixAndGeneral = ESS_PrivilegeHandler.checkPMSVFixAndGeneralAdminUser(userId);
        boolean isPMSVTransportation = ESS_PrivilegeHandler.checkPMSVTransportationAdminUser(userId);
        if((isPMSVFixAndGeneral && isPMSVTransportation) || isPMSV) {
            return ESS_Enum.PMSVAdminType.PMSV.name();
        }
        else if (isPMSVFixAndGeneral) {
            return ESS_Enum.PMSVAdminType.PMSVFixAndGeneral.name();
        }else if (isPMSVTransportation) {
            return ESS_Enum.PMSVAdminType.PMSVTransportation.name();
        }
        return '';
    }

    @RemoteAction
    public static List<ESS_FixAndGeneral_DTO.SearchUserDTO> SearchUsers(string search) {
        string userId = ESS_PrivilegeHandler.getUserId();
        string searchName = '%' + search + '%';
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //PISUsers
        string queryPIS = 'select id, user__c, employeeid__c, email__c, thtitle__c, thfirstname__c, thlastname__c, active__c, mainposition__c, EN_Fullname__c, OBJENFULLNAME__c, TH_Fullname__c, units__c, sections__c, DEPARTMENT__c, FUNCTION__c from PISUsers__c';
        queryPIS = queryPIS + ' where user__c != :userId AND (employeeid__c like: searchName OR enfirstname__c like: searchName) AND active__c = true AND mainposition__c = true limit 100';
        PISUsers = database.query(queryPIS);
        
        List<ESS_FixAndGeneral_DTO.SearchUserDTO> SearchUsers = new List<ESS_FixAndGeneral_DTO.SearchUserDTO>();
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                ESS_FixAndGeneral_DTO.SearchUserDTO SearchUser = new ESS_FixAndGeneral_DTO.SearchUserDTO();
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
    public static string UploadFile(string filename, string fileData, string recordId) {
        
        String base64 = fileData.substring(fileData.indexOf(',')+1);
        Blob actualdata = EncodingUtil.base64Decode(base64);

        string documentId = '';
        Attachment attch = new Attachment();
        attch.name = filename;
        attch.parentId  = recordId;
        attch.body = actualdata;
        // database.insert(attch, false);
        insert attch;
        documentId = attch.Id;
        return documentId;
    }
    
    @RemoteAction
    public static string ExportFixAndGeneralExcel(FixAndGeneralForAdminListFilter filter) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_FixAndGeneral_Excel?';
        
        string typeOfServices = filter.typeOfServices;
        integer month = filter.month;
        integer year = filter.year;
        
        URL = URL + 'typeOfServices=' + typeOfServices + 
            		'&month=' + month +  
            		'&year=' + year;
        
        return URL;
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
            //Delete attachment from old record
            //database.delete(attachs, true);
        }
    }

    @TestVisible
    private static string getFixAndGeneralForAdminListQueryFilter(FixAndGeneralForAdminListFilter filter)
    {
        //Add Query Filter
        string query = '';
        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
            }
            if (string.isNotBlank(filter.employeeName)) {
                string employeeName = '%' + filter.employeeName + '%';
                query += ' and Requester_Name_EN__c like :employeeName';
            }
            if (string.isNotBlank(filter.topic)) {
                string topic = '%' + filter.topic + '%';
                query += ' and Topic__c like :topic';
            }
            if (string.isNotBlank(filter.typeOfServices)) {
                string typeOfService = filter.typeOfServices;
                query += ' and Type_of_Service__c = :typeOfService';
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
                query = query + ' AND Completed_Date__c >=: startCompletedDate';
            }
            if (filter.endCompletedDate != null){
                datetime endCompletedDate = ESS_Global.convertDateTimeFilter(filter.endCompletedDate);
                query = query + ' AND Completed_Date__c <=: endCompletedDate';
            }
            if (filter.startAcceptedDate != null){
                datetime startAcceptedDate = ESS_Global.convertDateTimeFilter(filter.startAcceptedDate);
                query = query + ' AND Accepted_Date__c <=: startAcceptedDate';
            }
            if (filter.endAcceptedDate != null){
                datetime endAcceptedDate = ESS_Global.convertDateTimeFilter(filter.endAcceptedDate);
                query = query + ' AND Accepted_Date__c <=: endAcceptedDate';
            }
            if (string.isNotBlank(filter.pmsvEmployeeName)) {
                string pmsvEmployeeName = '%' + filter.pmsvEmployeeName + '%';
                query += ' and PMSV__c like :pmsvEmployeeName';
            }
        }
        return query;
    }

    private static string getFixAndGeneralCardQuery()
    {
        return 
        'select id, Document_No__c, Is_On_Behalf__c, Status__c, Type_of_Service__c, Topic__c, Requester_Name__c, Requester_Section__c, Requester_Department__c,' +
        'Expected_Due_Date__c,Requester_Function__c, CreatedDate, Completed_Date__c, Rejected_Date__c, PMSV__c, Reject_Comment__c, On_Behalf_Flow__c, Requester_Name_EN__c' +
        ' from ESS_FixAndGeneral__c';
    }

    private static ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO assignToFixAndGeneralCardDTO(ESS_FixAndGeneral__c model)
    {
        ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO result = new ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO();
        result.recordId = model.id;
        result.documentNo = model.Document_No__c;
        result.isOnBehalf = model.On_Behalf_Flow__c;
        result.status = new ESS_Global.EnumValue('FixAndGeneralDocumentStatus');
        result.status.key = model.Status__c;
        result.status.value = model.Status__c;
        result.typeOfService = new ESS_Global.EnumValue('FixTypeOfService');
        result.typeOfService.key = model.Type_of_Service__c;
        result.typeOfService.value = ESS_Enum.getFixTypeOfServiceValue(ESS_Enum.FixTypeOfService.valueOf(model.Type_of_Service__c));
        result.topic = model.Topic__c;
        result.expectedDueDate = model.Expected_Due_Date__c;
        result.createdDate = model.CreatedDate;
        result.rejectedDate = model.Rejected_Date__c;
        result.completedDate = model.Completed_Date__c;
        result.pmsvEmployeeName = model.PMSV__c;
        result.rejectComment = model.Reject_Comment__c;
        
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

    public static string getFixAndGeneralDetailQuery()
    {
        return
        'SELECT Accepted_Date__c,Attachment_Files__c,Attentiveness_Rating__c,Completed_Attachment_Files__c,Completed_Date__c,CreatedDate,Detail__c,Document_No__c,' +
        'Expected_Due_Date__c,Expertise_Rating__c,Fast_Rating__c,General_Cost__c,General_Detail__c,General_Internal_Detail__c,General_Type_Of_Service_Other__c,' +
        'General_Type_Of_Service__c,Housing_Cost__c,Housing_Detail__c,Housing_Internal_Detail__c,Housing_Type_Of_Service_Other__c,Housing_Type_of_Service__c,Id,' +
        'Is_On_Behalf__c,Mobile_No__c,Name,On_Behalf_Flow__c,On_Behalf_Of_Department__c,On_Behalf_Of_Email__c,On_Behalf_Of_Employee_Id__c,' +
        'On_Behalf_Of_Function__c,On_Behalf_Of_Id__c,On_Behalf_Of_Position__c,On_Behalf_Of_Section__c,On_Behalf_Of_Unit__c,On_Behalf_Of__c,OwnerId,PMSV_Department__c,' +
        'PMSV_Email__c,PMSV_Employee_Id__c,PMSV_Function__c,PMSV_Id__c,PMSV_Position__c,PMSV_Section__c,PMSV_Unit__c,PMSV__c,Punctuality_Rating__c,Rating_Date__c,' +
        'Rating_Score__c,Rejected_Date__c,Reject_Comment__c,Requester_Department__c,Requester_Email__c,Requester_Employee_Id__c,Requester_Function__c,' +
        'Requester_Id__c,Requester_Name__c,Requester_Position__c,Requester_Section__c,Requester_Tel_Mobile__c,Requester_Tel_Office__c,Requester_Unit__c,' +
        'Status__c,Submitted_Date__c,Tel_No__c,Topic__c,' +
        'Transportation_Cost__c,Transportation_Detail__c,Transportation_Internal_Detail__c,Transportation_Type_Of_Service__c, Transportation_Type_Of_Service_Other__c,Type_of_Service__c,Verified_Date__c, ' +
        'Areas__c, Buildings__c, Floors__c, House_No__c, House_Type__c, Office_Cost__c, Office_Detail__c, Office_Internal_Detail__c, Office_Type_Of_Service__c, Office_Type_Of_Service_Other__c, ' +
        'Period__c, Repair_Date__c, Transportation_Items__c, Cancelled_Date__c, Cancel_Comment__c, Location__c, Is_PRTR_Admin__c,Is_PRTR_Requester__c,Cancelled_By__c,Completed_By__c, Completed_By_Email__c, ' +
        'Attentiveness_Rating_2__c, Expertise_Rating_2__c, Fast_Rating_2__c, Punctuality_Rating_2__c, Rating_Date_2__c, Rating_Score_2__c,On_Behalf_Of_EN__c,Requester_Name_EN__c, Rejected_By__c,Month__c,Month_Name__c ' + 
        'FROM ESS_FixAndGeneral__c';
    }

    public static ESS_FixAndGeneral__c queryFixAndGeneralById(string recordId){
        string query = getFixAndGeneralDetailQuery();
        query +=  ' where Id = :recordId';
        ESS_FixAndGeneral__c model = Database.query(query);
        return model;
    }

    private static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO assignToFixAndGeneralDetailDTO(ESS_FixAndGeneral__c model){
        string userId = ESS_PrivilegeHandler.getUserId();

        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO result = new ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO();
        result.recordId = model.id;
        result.documentNo = model.Document_No__c;
        if (string.isNotBlank(model.Status__c)) {
            result.status = new ESS_Global.EnumValue('FixAndGeneralDocumentStatus');
            result.status.key = model.Status__c;
            result.status.value = model.Status__c;
        }
        if (string.isNotBlank(model.Type_of_Service__c)){
            result.typeOfService = new ESS_Global.EnumValue('FixTypeOfService');
            result.typeOfService.key = model.Type_of_Service__c;
            result.typeOfService.value = ESS_Enum.getFixTypeOfServiceValue(ESS_Enum.FixTypeOfService.valueOf(model.Type_of_Service__c));
        }
        result.onBehalfFlow = model.On_Behalf_Flow__c;
        result.repairArea = model.Areas__c;
        result.officeBuilding = model.Buildings__c;
        result.floor = model.Floors__c;
        result.telNo = model.Tel_No__c;
        result.mobileNo = model.Mobile_No__c;
        result.topic = model.Topic__c;
        result.detail = model.Detail__c;
        result.expectedDueDate = model.Expected_Due_Date__c;
        result.location = model.Location__c;
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
        result.houseNo = model.House_No__c;
        result.period = new ESS_Global.EnumValue('HousingPeriod');
        if(model.Period__c != null) {
            result.period.key = model.Period__c;	
        	result.period.value = result.period.key;    
        }
        result.repairDate = model.Repair_Date__c;
        result.houseType = new ESS_Global.EnumValue('HousingType');
        if(model.House_Type__c != null) {
        	result.houseType.key = model.House_Type__c;
            result.houseType.value = ESS_Enum.getHousingType(ESS_Enum.HousingType.valueOf(result.houseType.key));
        }
        
        if (string.isNotBlank(model.Transportation_Items__c)) {
            result.transportationItems = (List<ESS_FixAndGeneral_DTO.TransportationItemDTO>)JSON.deserialize(model.Transportation_Items__c, List<ESS_FixAndGeneral_DTO.TransportationItemDTO>.class);
        }
		result.isPRTRUser = model.Is_PRTR_Requester__c;
        result.canOnlyOnBehalf = model.Is_PRTR_Requester__c;
        result.ratingScore = model.Rating_Score__c;
        result.attentivenessRating = model.Attentiveness_Rating__c;
        result.fastRating = model.Fast_Rating__c;
        result.punctualityRating = model.Punctuality_Rating__c;
        result.expertiseRating = model.Expertise_Rating__c;
        result.ratingScoreOBH = model.Rating_Score_2__c;
        result.attentivenessRatingOBH = model.Attentiveness_Rating_2__c;
        result.fastRatingOBH = model.Fast_Rating_2__c;
        result.punctualityRatingOBH = model.Punctuality_Rating_2__c;
        result.expertiseRatingOBH = model.Expertise_Rating_2__c;
        if (string.isNotBlank(model.Completed_Attachment_Files__c)){
            List<string> attachmentFileIds = model.Completed_Attachment_Files__c.split(',');
            result.completedAttachmentFiles = new List<ESS_DTO.FileDTO>();
            for (string fileId : attachmentFileIds) {
                ESS_DTO.FileDTO fileDTO = new ESS_DTO.FileDTO();
                fileDTO.id = fileId;
                fileDTO.url = generateDocumentUrl(fileId);
                result.completedAttachmentFiles.add(fileDTO);
            }
        }
        if (string.isNotBlank(model.Office_Type_of_Service__c)){
            result.officeTypeOfService = new ESS_Global.EnumValue('OfficeTypeOfService');
            result.officeTypeOfService.key = model.Office_Type_of_Service__c;
            result.officeTypeOfService.value = ESS_Enum.getOfficeTypeOfServiceValue(ESS_Enum.OfficeTypeOfService.valueOf(model.Office_Type_of_Service__c));
        }
        result.officeTypeOfServiceOther = model.Office_Type_Of_Service_Other__c;
        result.officeCost = model.Office_Cost__c;
        result.officeDetail = model.Office_Detail__c;
        result.officeInternalDetail = model.Office_Internal_Detail__c;
        if (string.isNotBlank(model.Housing_Type_of_Service__c)){
            result.housingTypeOfService = new ESS_Global.EnumValue('HousingTypeOfService');
            result.housingTypeOfService.key = model.Housing_Type_of_Service__c;
            result.housingTypeOfService.value = ESS_Enum.getHousingTypeOfServiceValue(ESS_Enum.HousingTypeOfService.valueOf(model.Housing_Type_of_Service__c));
        }
        result.housingTypeOfServiceOther = model.Housing_Type_Of_Service_Other__c;
        result.housingCost = model.Housing_Cost__c;
        result.housingDetail = model.Housing_Detail__c;
        result.housingInternalDetail = model.Housing_Internal_Detail__c;
        if (string.isNotBlank(model.Transportation_Type_Of_Service__c)){
            result.transportationTypeOfService = new ESS_Global.EnumValue('TransportationTypeOfService');
            result.transportationTypeOfService.key = model.Transportation_Type_Of_Service__c;
            result.transportationTypeOfService.value = ESS_Enum.getTransportationTypeOfServiceValue(ESS_Enum.TransportationTypeOfService.valueOf(model.Transportation_Type_Of_Service__c));
        }
        result.transportationTypeOfServiceOther = model.Transportation_Type_Of_Service_Other__c;
        result.transportationCost = model.Transportation_Cost__c;
        result.transportationDetail = model.Transportation_Detail__c;
        result.transportationInternalDetail = model.Transportation_Internal_Detail__c;
        if (string.isNotBlank(model.General_Type_Of_Service__c)){
            result.generalTypeOfService = new ESS_Global.EnumValue('GeneralTypeOfService');
            result.generalTypeOfService.key = model.General_Type_Of_Service__c;
            result.generalTypeOfService.value = ESS_Enum.getGeneralTypeOfServiceValue(ESS_Enum.GeneralTypeOfService.valueOf(model.General_Type_Of_Service__c));
        }
        result.generalTypeOfServiceOther = model.General_Type_Of_Service_Other__c;
        result.generalCost = model.General_Cost__c;
        result.generalDetail = model.General_Detail__c;
        result.generalInternalDetail = model.General_Internal_Detail__c;

        result.isOnBehalf = model.Is_On_Behalf__c;
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
        result.pmsvId = model.PMSV_Id__c;
        result.pmsvEmployeeId = model.PMSV_Employee_Id__c;
        result.pmsvEmployeeName = model.PMSV__c;
        result.pmsvEmail = model.PMSV_Email__c;
        result.pmsvPosition = model.PMSV_Position__c;
        result.pmsvUnit = model.PMSV_Unit__c;
        result.pmsvSection = model.PMSV_Section__c;
        result.pmsvDepartment = model.PMSV_Department__c;
        result.pmsvFunction = model.PMSV_Function__c;
        
        result.createdDate = model.CreatedDate;
        result.submittedDate = model.Submitted_Date__c;
        result.verifiedDate = model.Verified_Date__c;
        result.acceptedDate = model.Accepted_Date__c;
        result.completedBy = model.Completed_By__c;
        result.completedByEmail = model.Completed_By_Email__c;
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
        result.showOfficeInternalDetail = checkShowOfficeInternalDetail(model, userId);
        result.showHousingInternalDetail = checkShowHousingInternalDetail(model, userId);
        result.showTransportationInternalDetail = checkShowTransportationInternalDetail(model, userId);
        result.showGeneralInternalDetail = checkShowGeneralInternalDetail(model, userId);
        result.canSave = checkCanSaveFixAndGeneral(model, userId);
        result.canEdit = checkCanEditFixAndGeneral(model, userId);
        result.canSubmit = checkCanSubmitFixAndGeneral(model, userId);
        result.canVerify = checkCanVerifyFixAndGeneral(model, userId);
        result.canAccept = checkCanAcceptFixAndGeneral(model, userId);
        result.canCancelRequest = checkCanCancelRequestFixAndGeneral(model, userId);
        result.canSaveComplete = checkCanSaveCompleteFixAndGeneral(model, userId);
        result.canComplete = checkCanCompleteFixAndGeneral(model, userId);
        result.showCompleteForm = checkShowCompleteFormFixAndGeneral(model, userId);
        result.canRating = checkCanRatingFixAndGeneral(model, userId);
        result.showRatingForm = checkShowRatingFormFixAndGeneral(model, userId);
        result.showRatingFormOBH = checkShowRatingFormOBHFixAndGeneral(model, userId);

        return result;
    }

    public static boolean checkShowOfficeInternalDetail(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;

        if (model.Type_of_Service__c == ESS_Enum.FixTypeOfService.OfficeEquipment.name()) {
            if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name() ||
                model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Completed.name())
            {
                boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
                if (isAdmin) {
                    result = true;
                }
            }
        }
        
        return result;
    }

    public static boolean checkShowHousingInternalDetail(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;

        if (model.Type_of_Service__c == ESS_Enum.FixTypeOfService.Housing.name()) {
            if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name() ||
                model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Completed.name())
            {
                boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
                if (isAdmin) {
                    result = true;
                }
            }
        }
        
        return result;
    }

    public static boolean checkShowTransportationInternalDetail(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;

        if (model.Type_of_Service__c == ESS_Enum.FixTypeOfService.Transportation.name()) {
            if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name() ||
                model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Completed.name())
            {
                boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
                if (isAdmin) {
                    result = true;
                }
            }
        }
        
        return result;
    }

    public static boolean checkShowGeneralInternalDetail(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;

        if (model.Type_of_Service__c == ESS_Enum.FixTypeOfService.GeneralService.name()) {
            if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name() ||
                model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Completed.name())
            {
                boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
                if (isAdmin) {
                    result = true;
                }
            }
        }
        
        return result;
    }

    public static boolean checkCanSaveFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Draft.name()) 
        {
            if (model.Requester_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkCanEditFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name()) 
        {
            if (userId == model.On_Behalf_Of_Id__c) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanSubmitFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Draft.name()) 
        {
            if (model.Requester_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanVerifyFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name()) 
        {
            if (model.On_Behalf_Of_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanAcceptFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name()) 
        {
            boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
            if (isAdmin) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanCancelRequestFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name()) 
        {
            if (model.On_Behalf_Of_Id__c == userId) {
                result = true;
            }
            if (model.Requester_Id__c == userId) {
                result = true;
            }
            //Allow Admin to Cancel
            boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
            if (isAdmin) {
                result = true;
            }
        }
        else if(model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name()) {
            //Allow Admin to Cancel
            boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
            if (isAdmin) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanSaveCompleteFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name()) 
        {
            boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
            if (isAdmin) {
                result = true;
            }
            else if (model.PMSV_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanCompleteFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name()) 
        {
            boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
            if (isAdmin) {
                result = true;
            }
            else if (model.PMSV_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkShowCompleteFormFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Completed.name()) 
        {
            result = true;
        }
        boolean isPMSVAdminUser = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
        if(model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name() && isPMSVAdminUser) {
            result = true;
        }
        return result;
    }

    public static boolean checkCanRatingFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Completed.name()) 
        {
            if (model.On_Behalf_Flow__c) {
                if (model.On_Behalf_Of_Id__c == userId && model.Rating_Date_2__c == null) {
                    result = true;
                }
                else if (model.Requester_Id__c == userId && model.Rating_Date__c == null) {
                    result = true;
                }
            }
            else {
                if(model.Requester_Id__c == userId && model.Rating_Date__c == null) {
                    result = true;
                }
            }
        }
        return result;
    }

    public static boolean checkShowRatingFormFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Completed.name()) 
        {
            if (model.Rating_Date__c != null) {
                boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
                if(isAdmin) {
                    result = true;
                }
                else if(model.Requester_Id__c == userId) {
                    result = true;
                }
            }
        }
        if(!result && model.Requester_Id__c == userId) {
            result = checkCanRatingFixAndGeneral(model,userId);
        }
        return result;
    }
    
    public static boolean checkShowRatingFormOBHFixAndGeneral(ESS_FixAndGeneral__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.FixAndGeneralDocumentStatus.Completed.name()) 
        {
            if (model.Rating_Date_2__c != null) {
                boolean isAdmin = ESS_PrivilegeHandler.checkPMSVAdminUser(userId);
                if(isAdmin) {
                    result = true;
                }
                else if(model.On_Behalf_Of_Id__c == userId) {
                    result = true;
                }
            }
        }
        if(!result && model.On_Behalf_Of_Id__c == userId) {
            result = checkCanRatingFixAndGeneral(model,userId);
        }
        return result;
    }

    public static string generateDocumentUrl(string fileId) {
        
        string finalURL;
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm();
        
        finalURL = URL + '/servlet/servlet.FileDownload?file=' + fileId + '&operationContext=S1';
        return finalURL;
        
    }

    public static Map<String, List<String>> getBuildingDependentPicklistValues() {
        
        Schema.DescribeFieldResult depend = ESS_FixAndGeneral__c.Buildings__c.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
     
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
     
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars =
                        String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                            (controlEntries == null
                                    ?   (Object) (index == 1)
                                    :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                            );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
                    dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                }
            }
        }
        
        return dependentPicklistValues;
    }

    public static Map<String, List<String>> getFloorDependentPicklistValues() {
        
        Schema.DescribeFieldResult depend = ESS_FixAndGeneral__c.Floors__c.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
     
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
     
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars =
                        String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                            (controlEntries == null
                                    ?   (Object) (index == 1)
                                    :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                            );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
                    dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                }
            }
        }
        
        return dependentPicklistValues;
    }

    public class FixAndGeneralListFilter
    {
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public string topic {get;set;}
        @RemoteAction
        public string typeOfServices {get;set;} //comma separate
        @RemoteAction
        public datetime startCreatedDate {get;set;}
        @RemoteAction
        public datetime endCreatedDate {get;set;}
        @RemoteAction
        public datetime startCompletedDate {get;set;}
        @RemoteAction
        public datetime endCompletedDate {get;set;}
    }

    public class FixAndGeneralForAdminListFilter
    {
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public integer month {get;set;}
        @RemoteAction
        public string topic {get;set;}
        @RemoteAction
        public string typeOfServices {get;set;} //comma separate
        @RemoteAction
        public datetime startCreatedDate {get;set;}
        @RemoteAction
        public datetime endCreatedDate {get;set;}
        @RemoteAction
        public datetime startCompletedDate {get;set;}
        @RemoteAction
        public datetime endCompletedDate {get;set;}
        @RemoteAction
        public datetime startAcceptedDate {get;set;}
        @RemoteAction
        public datetime endAcceptedDate {get;set;}
        //Accepted By
        @RemoteAction
        public string pmsvEmployeeName {get;set;}
        @RemoteAction
        public integer year {get;set;}
    }
    
}