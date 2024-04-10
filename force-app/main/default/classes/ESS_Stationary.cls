/* Author Softever */
global with sharing class ESS_Stationary {

    private static string userId;
    private static boolean isPMSVAdminUser = false;
    private static boolean isGSBOAdminUser = false;
    private static boolean isAdminUser = false;
    private static boolean isPRTRUser = false;
    
    static {
        userId = ESS_PrivilegeHandler.getUserId();
        isPRTRUser = ESS_Global.checkPRTRUser(userId);
        isAdminUser = ESS_PrivilegeHandler.checkPMSVUser(userId);
        isPMSVAdminUser = ESS_PrivilegeHandler.checkPMSVStationaryAdminUser(userId);
    	isGSBOAdminUser = ESS_PrivilegeHandler.checkGSBOStationaryAdminUser(userId);
    }
    
    @RemoteAction
    public static integer GetOnBehalfCount() {
        //TODO: Get on behalf count
        string query = 'select count(id) from ESS_Stationary__c where id != null and On_Behalf_Of_Id__c = :userId and Status__c = \'Verifying\'';

        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    @RemoteAction
    public static integer GetStationaryAdminListCount(AdminSearchCriteria filter) {
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        
        string query = 'select count(id) from ESS_Stationary__c where id != null AND document_no__c != null';

        //From Privilege
        List<string> loginAs = ESS_PrivilegeHandler.StationaryLoginPrivilege();
        if(loginAs.size() > 0) {
            query += ' and Withdraw_From__c IN :loginAs';
        }
        
        //Add authorize filter
        if (!isPMSVAdminUser || isGSBOAdminUser) {
            //query +=  ' and ((Status__c != \'OnProcess\' and Status__c != \'Completed\') or (PMSV_Id__c = :userId))';   
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
            if (filter.startCreatedDate != null){
                datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
                query = query + ' AND createddate >=: startCreatedDate';
            }
            if (filter.endCreatedDate != null){
                datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
                query = query + ' AND createddate <=: endCreatedDate';
            }
            if (filter.startSubmittedDate != null){
                datetime startSubmittedDate = ESS_Global.convertDateTimeFilter(filter.startSubmittedDate);
                query = query + ' AND (Submitted_Date__c >=: startSubmittedDate)';
            }
            if (filter.endSubmittedDate != null){
                datetime endSubmittedDate = ESS_Global.convertDateTimeFilter(filter.endSubmittedDate);
                query = query + ' AND (Submitted_Date__c <=: endSubmittedDate)';
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
        }
        AggregateResult result = Database.query(query);
        return (Integer) result.get('expr0');
    }
    
    @RemoteAction
    public static List<ESS_Stationary_DTO.StationaryListDTO> GetStationaryAdminList(AdminSearchCriteria filter,
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) 
    {        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }

        string query = getStationaryCardQuery();

        //Add authorize filter
        query +=  ' where document_no__c != null'; 

        //From Privilege
        List<string> loginAs = ESS_PrivilegeHandler.StationaryLoginPrivilege();
        if(loginAs.size() > 0) {
            query += ' and Withdraw_From__c IN :loginAs';
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
            if (filter.startCreatedDate != null){
                datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
                query = query + ' AND createddate >=: startCreatedDate';
            }
            if (filter.endCreatedDate != null){
                datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
                query = query + ' AND createddate <=: endCreatedDate';
            }
            if (filter.startSubmittedDate != null){
                datetime startSubmittedDate = ESS_Global.convertDateTimeFilter(filter.startSubmittedDate);
                query = query + ' AND (Submitted_Date__c >=: startSubmittedDate)';
            }
            if (filter.endSubmittedDate != null){
                datetime endSubmittedDate = ESS_Global.convertDateTimeFilter(filter.endSubmittedDate);
                query = query + ' AND (Submitted_Date__c <=: endSubmittedDate)';
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
        }

        //Add Sort by logic
        //query += ' order by CreatedDate desc';
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
             string sortByQuery = ' order by';
             //string sortByQuery = '';
             if(sortByParam.sortBy == 'documentNo') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Document_No__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Document_No__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'location') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Location__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Location__c desc';
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
             else if(sortByParam.sortBy == 'submittedDate') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Submitted_Date__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Submitted_Date__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'requesterDisplayName') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Requester_Name_EN__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Requester_Name_EN__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'onBehalfOfEmployeeName') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' On_Behalf_Of__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' On_Behalf_Of__c desc';
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
             else if(sortByParam.sortBy == 'status') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' status__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' status__c desc';
                 }
             }
             //query += ',' + sortByQuery;
             query += sortByQuery;
         }
        else {
            query += ' order by document_no__c desc';
        }
        
		if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }
        
        List<ESS_Stationary__c> models = Database.query(query);
        List<ESS_Stationary_DTO.StationaryListDTO> results = new List<ESS_Stationary_DTO.StationaryListDTO>();
        for (ESS_Stationary__c model : models) {
            results.add(assignToStationaryListDTO(model));
        }

        return results;
    }
    
    @RemoteAction
    public static integer GetStationaryListCount(SearchCriteria filter) {
        string query = 'select count(id) from ESS_Stationary__c where id != null AND document_no__c != null';

        //Add authorize filter
        query +=  ' and (OwnerId = :userId or On_Behalf_Of_Id__c = :userId or User_Manager_Id__c = :userId)';

        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
                
                //On Behalf Verifying Page
                if(status == ESS_Enum.StationaryServiceStatus.Verifying.name()) {
                    query += ' and (Requester_Id__c != :userId AND On_Behalf_Of_Id__c != null)';
                }
                else if(status == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
                    query += ' and (User_Manager_Flow__c = true)';
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
    public static List<ESS_Stationary_DTO.StationaryCardDTO> GetStationaryList(SearchCriteria filter,
        //documentNo,currentStatus,createdDate,completedDate                                                                       
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) 
    {
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }

        string query = getStationaryCardQuery();

        //Add authorize filter
        query +=  ' where document_no__c != null AND (OwnerId = :userId or On_Behalf_Of_Id__c = :userId or User_Manager_Id__c = :userId)';

        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
                
                //On Behalf Verifying Page
                if(status == ESS_Enum.StationaryServiceStatus.Verifying.name()) {
                    query += ' and (Requester_Id__c != :userId AND On_Behalf_Of_Id__c != null)';
                }
                else if(status == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
                    query += ' and (User_Manager_Flow__c = true)';
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
        //query += ' order by CreatedDate desc';
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
             string sortByQuery = ' order by';
             boolean isSortCompletedDate = false;
             //string sortByQuery = '';
             if(sortByParam.sortBy == 'documentNo') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Document_No__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Document_No__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'currentStatus') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Status__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Status__c desc';
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
                 isSortCompletedDate = true;
                 if(sortByParam.ascending) {
                     sortByQuery += ' Completed_Date__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Completed_Date__c desc';
                 }
             }
             //query += ',' + sortByQuery;
            if(isSortCompletedDate) {
                query += ' and completed_date__c != null';
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
		
        List<ESS_Stationary__c> models = Database.query(query);
        List<ESS_Stationary_DTO.StationaryCardDTO> results = new List<ESS_Stationary_DTO.StationaryCardDTO>();
        for (ESS_Stationary__c model : models) {
            results.add(assignToStationaryCardDTO(model));
        }

        return results;
    }
    
    @RemoteAction
    public static integer GetStationaryApproverListCount(SearchCriteria filter) {
        
        string query = 'select count(id) from ESS_Stationary__c where id != null AND document_no__c != null';

        //Add authorize filter
        query +=  ' and (User_Manager_Id__c = :userId)';

        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string filterStatus = filter.status;
                
                query += ' and status__c = :filterStatus';
                //On Behalf Verifying Page
                if(filterStatus == ESS_Enum.StationaryServiceStatus.Verifying.name()) {
                    query += ' and (Requester_Id__c != :userId AND On_Behalf_Of_Id__c != null)';
                }
                else if(filterStatus == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
                    query += ' and (User_Manager_Flow__c = true)';
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
    public static List<ESS_Stationary_DTO.StationaryCardDTO> GetStationaryApproverList(SearchCriteria filter,
        //documentNo,currentStatus,createdDate,completedDate                                                                       
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) 
    {
     	
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }

        string query = getStationaryCardQuery();

        //Add authorize filter
        query +=  ' where document_no__c != null AND (User_Manager_Id__c = :userId)';

        if (filter != null) {
            if (string.isNotBlank(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' and Document_No__c like :documentNo';
            }
            if (string.isNotBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                string status = filter.status;
                query += ' and Status__c = :status';
                
                //On Behalf Verifying Page
                if(status == ESS_Enum.StationaryServiceStatus.Verifying.name()) {
                    query += ' and (Requester_Id__c != :userId AND On_Behalf_Of_Id__c != null)';
                }
                else if(status == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
                    query += ' and (User_Manager_Flow__c = true)';
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
        //query += ' order by CreatedDate desc';
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
             string sortByQuery = ' order by';
             boolean isSortCompletedDate = false;
             //string sortByQuery = '';
             if(sortByParam.sortBy == 'documentNo') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Document_No__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Document_No__c desc';
                 }
             }
             else if(sortByParam.sortBy == 'currentStatus') {
                 if(sortByParam.ascending) {
                     sortByQuery += ' Status__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Status__c desc';
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
                 isSortCompletedDate = true;
                 if(sortByParam.ascending) {
                     sortByQuery += ' Completed_Date__c asc';
                 }
                 else if(!sortByParam.ascending) {
                     sortByQuery += ' Completed_Date__c desc';
                 }
             }
            
            if(isSortCompletedDate) {
                query += ' and completed_date__c != null';
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

        List<ESS_Stationary__c> models = Database.query(query);
        List<ESS_Stationary_DTO.StationaryCardDTO> results = new List<ESS_Stationary_DTO.StationaryCardDTO>();
        for (ESS_Stationary__c model : models) {
            results.add(assignToStationaryCardDTO(model));
        }

        return results;
    }
    
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO GetStationaryDetail(ESS_Stationary_DTO.SearchDTO search) {
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        
        if(isPRTRUser) {
            try {
                User = ESS_Global.assignToUser(userId);
            }
            catch (Exception e) {
            	throw new ESS_Exception('[MyError]ไม่พบ User');
            }
        }
        else {
            try {
            	loginedUser = ESS_Global.assignToPISUser(userId); 
            }
            catch (Exception e) {
                throw new ESS_Exception('[MyError]ไม่พบ PIS user');
            }
        }

        ESS_Stationary_DTO.StationaryDetailDTO result;
        
        if (string.isBlank(search.recordId)) {
            //assign default dto
            result = new ESS_Stationary_DTO.StationaryDetailDTO();
            result.status = new ESS_Global.EnumValue('StationaryServiceStatus');
            result.status.key = ESS_Enum.StationaryServiceStatus.Draft.name();
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
                result.requesterLevel = loginedUser.LEVEL__c;
                
            	//User Manager
                result.userManagerId = loginedUser.ReportToUser__c;
                result.userManagerName = loginedUser.ReportToName__c;
                
                //CC Email
                result.ccName = loginedUser.ReportToName__c;
                result.ccEmail = loginedUser.ReportToEmail__c;
                try {
                	PISUsers__c ccUser = ESS_Global.assignToPISUser(loginedUser.ReportToUser__c);
                	result.ccLevel = ccUser.LEVEL__c;
                }
                catch (Exception e) {
                    throw new ESS_Exception('[MyError]ไม่พบ Report to user');
                }
            }
            else {
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
                result.canOnlyOnBehalf = true;
            }
            
            result.canSave = true;
            result.canSubmit = true;
            
            //Insert empty record
            ESS_Stationary__c empty = new ESS_Stationary__c();
            database.insert(empty);
            
            result.recordId = empty.id;

        }else {
            
            ESS_Stationary__c model = queryStationaryById(search.recordId);
            result = assignToStationaryDetailDTO(model);
            
        }

        return result;
    }
    
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO SaveStationary(ESS_Stationary_DTO.StationaryDetailDTO input) {
        
        boolean isCreateNew = false;
        ESS_Stationary__c model;
        if (string.isNotBlank(input.documentNo)){
            model = queryStationaryById(input.recordId);
        }else{
            
            model = new ESS_Stationary__c();
            isCreateNew = true;
            string runningNo = ESS_LogicHandler.GenerateRunningNo('Stationary');
            string year = ESS_LogicHandler.GetCurrentYear();
            string month = ESS_LogicHandler.GetCurrentMonth();
            string prefix = 'SS';
            model.Document_No__c = prefix + '-' + year + '-' + month + '-' + runningNo;
            model.OwnerId = userId;
            model.Status__c = ESS_Enum.StationaryServiceStatus.Draft.name();
            
        }
        if(input.canOnlyOnBehalf == null) {
            model.Is_PRTR_Requester__c = false;
        }
        else {
            model.Is_PRTR_Requester__c = input.canOnlyOnBehalf;
        }
        if(input.withdrawFrom != null) {
            model.Withdraw_From__c = input.withdrawFrom.key;
        }
        if(input.ServiceFor != null) {
            model.Service_For__c = input.ServiceFor.key;
        }
        model.Location__c = input.location;
        model.Internal_No__c = input.internalNo;
        model.Mobile_No__c = input.mobileNo;
        model.Comment__c = input.comment;
        model.Need_Date__c = input.needDate;
        if (input.withdraws != null) {
        	model.Withdraw_From_Stock__c = JSON.serialize(input.withdraws);
        }
        if (input.withdrawOthers != null) {
            
            for(ESS_Stationary_DTO.WithdrawDTO Withdraw : input.withdrawOthers) {
                if(Withdraw.attachmentFiles.size() > 0) {
                    for(ESS_DTO.FileDTO fileDTO : Withdraw.attachmentFiles) {
                        fileDTO.url = generateDocumentUrl(fileDTO.id);
                    }
                }
            }
            
        	model.Withdraw_Other__c = JSON.serialize(input.withdrawOthers);
            
        }
        
        model.Location__c = input.location;
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
        model.Requester_Level__c = input.requesterLevel;

        //User Manager
        List<PISUsers__c> userManagerCCs = new List<PISUsers__c>();
        if(!model.Is_PRTR_Requester__c) {
            userManagerCCs = ESS_Global.findingUserManagerAndCC(userId);
            model.User_Manager_Id__c = userManagerCCs[0].User__c;
            model.User_Manager__c = userManagerCCs[0].THTITLE__c + ' ' + userManagerCCs[0].THFIRSTNAME__c + ' ' + userManagerCCs[0].THLASTNAME__c;
            model.User_Manager_EN__c = userManagerCCs[0].EN_Fullname__c;
            
            //CC Email
            if(userManagerCCs.size() > 1) {
                model.CC__c = userManagerCCs[1].THTITLE__c + ' ' + userManagerCCs[1].THFIRSTNAME__c + ' ' + userManagerCCs[1].THLASTNAME__c;
                model.CC_Email__c = userManagerCCs[1].Email__c;
                model.CC_Level__c = userManagerCCs[1].LEVEL__c;
            }
        }
        
        if (input.isOnBehalf) {
            if(input.onBehalfOfId == null) {
                throw new ESS_Exception('[MyError]กรุณาเลือกคนที่จะ On Behalf Of');
            }
            model.On_Behalf_Of_Verifying__c = input.onBehalfOfVerifying;
            model.On_Behalf_Flow__c = input.isOnBehalf;
            model.On_Behalf_Of_Flow__c = input.isOnBehalf;
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
            model.On_Behalf_Of_Level__c = input.onBehalfOfLevel;
            
            userManagerCCs = new List<PISUsers__c>();
            userManagerCCs = ESS_Global.findingUserManagerAndCC(input.onBehalfOfId);
            model.User_Manager_Id__c = userManagerCCs[0].User__c;
            model.User_Manager__c = userManagerCCs[0].THTITLE__c + ' ' + userManagerCCs[0].THFIRSTNAME__c + ' ' + userManagerCCs[0].THLASTNAME__c;
            model.User_Manager_EN__c = userManagerCCs[0].EN_Fullname__c;
            
            //CC Email
            if(userManagerCCs.size() > 1) {
                model.CC__c = userManagerCCs[1].THTITLE__c + ' ' + userManagerCCs[1].THFIRSTNAME__c + ' ' + userManagerCCs[1].THLASTNAME__c;
                model.CC_Email__c = userManagerCCs[1].Email__c;
                model.CC_Level__c = userManagerCCs[1].LEVEL__c;
            }
        }
        
        //กรณีต้องมีการขออนุมัติจาก User Manager ต้องส่ง userManagerFlow = true มา
        if(input.userManagerFlow == null) {
            model.User_Manager_Flow__c = false;
        }
        else {
            model.User_Manager_Flow__c = input.userManagerFlow;
        }
        
        if(!model.User_Manager_Flow__c) {
            model.User_Manager_Id__c = null;
            model.User_Manager__c = null;
            model.User_Manager_EN__c = null;
        }
        
        if(isCreateNew){
            database.insert(model, true);
            
            //Get Empty record
            input.recordId = model.Id;
            ESS_Stationary__c empty = queryStationaryById(input.recordId);
            //Manage file and change parent id
            ChangeUploadFileParentId(empty.Id, model.Id);
        }else{
            database.update(model, true);
        }

        ESS_Stationary_DTO.SearchDTO search = new ESS_Stationary_DTO.SearchDTO();
        search.recordId = model.Id;
        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO SubmitStationary(ESS_Stationary_DTO.StationaryDetailDTO input) {
        
        input = SaveStationary(input);

        ESS_Stationary__c model = queryStationaryById(input.recordId);
        model.Submitted_Date__c = system.datetime.now();
        
        if(input.withdraws != null) {
            for(ESS_Stationary_DTO.WithdrawDTO Withdraw : input.withdraws) {
                AddDueStockWhenSubmit(Withdraw.recordId, Withdraw.quantity);
            }
        }
        
        if (model.On_Behalf_Flow__c) {
            if(model.On_Behalf_Of_Verifying__c) {
                model.Status__c = ESS_Enum.StationaryServiceStatus.Verifying.name();
            	ESS_StationaryNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
            }
            else {
                model.Status__c = ESS_Enum.StationaryServiceStatus.Waiting.name();
                ESS_StationaryNotification.SendToAdminPMSVWhenRequested(model);
            }  
        }
        else {
            //In case user manager flow
            if(model.User_Manager_Flow__c) {
				model.Status__c = ESS_Enum.StationaryServiceStatus.WaitingToApprove.name();   
            	ESS_StationaryNotification.SendToUserManagerWhenEmployeeSubmit(model);             
            }
            else {
                model.Status__c = ESS_Enum.StationaryServiceStatus.Waiting.name();
                ESS_StationaryNotification.SendToAdminPMSVWhenRequested(model);
            }
        }
        
        database.update(model, true);

        ESS_Stationary_DTO.SearchDTO search = new ESS_Stationary_DTO.SearchDTO();
        search.recordId = input.recordId;
        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static boolean DeleteStationary(ESS_Stationary_DTO.SearchDTO search) {
        ESS_Stationary__c model = queryStationaryById(search.recordId);
        database.delete(model, true);
        return true;
    }
    
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO VerifyStationary(ESS_Stationary_DTO.SearchDTO search, string comment) {
        
        ESS_Stationary__c model = queryStationaryById(search.recordId);
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Verifying.name()) {
            
            if(isPRTRUser) {
                model.Verified_By__c = User.FirstName + ' ' + User.LastName;
            }
            else {
                model.Verified_By__c = PISUser.EN_Fullname__c;
            }
            model.Verified_Date__c = system.datetime.now();
            model.Verify_Comment__c = comment;
            
            //Send to User Manager for next approve
            if(model.User_Manager_Flow__c && model.On_Behalf_Flow__c) {
                model.Status__c = ESS_Enum.StationaryServiceStatus.WaitingToApprove.name();
                ESS_StationaryNotification.SendToUserManagerWhenEmployeeSubmit(model);
            }
            //Send to Admin for next step
            else if(!model.User_Manager_Flow__c && model.On_Behalf_Flow__c){
            	model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name();
                ESS_StationaryNotification.SendToAdminPMSVWhenRequested(model);
            }
            
            database.update(model, true);
            
        }

        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static List<ESS_Stationary_DTO.StationaryCardDTO> VerifyMultipleStationary(List<ESS_Stationary_DTO.StationaryCardDTO> inputs, string comment) {
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        List<ESS_Stationary_DTO.StationaryCardDTO> results = new List<ESS_Stationary_DTO.StationaryCardDTO>();
        for (ESS_Stationary_DTO.StationaryCardDTO input : inputs) {
            if (input.isSelected) {
                ESS_Stationary__c model = queryStationaryById(input.recordId);
        
                if (model.Status__c == ESS_Enum.StationaryServiceStatus.Verifying.name()) {
                    if(isPRTRUser) {
                        model.Verified_By__c = User.FirstName + ' ' + User.LastName;
                    }
                    else {
                        model.Verified_By__c = PISUser.EN_Fullname__c;
                    }
                    model.Verified_Date__c = system.datetime.now();
                    model.Verify_Comment__c = comment;
                    
                    //Send to User Manager for next approve
                    if(model.User_Manager_Flow__c && model.On_Behalf_Flow__c) {
                        model.Status__c = ESS_Enum.StationaryServiceStatus.WaitingToApprove.name();
                        ESS_StationaryNotification.SendToUserManagerWhenEmployeeSubmit(model);
                    }
                    //Send to Admin for next step
                    else if(!model.User_Manager_Flow__c && model.On_Behalf_Flow__c){
                        //model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name(); 
                        model.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name(); 
                        ESS_StationaryNotification.SendToAdminPMSVWhenRequested(model);
                    }
                    
                    database.update(model, true);
                }

                string recordId = input.recordId;
                string query = getStationaryCardQuery();
                query +=  ' where Id = :recordId';
                ESS_Stationary__c cardModel = Database.query(query);
                results.add(assignToStationaryCardDTO(cardModel));

            }else{
                results.add(input);
            }
        }
        
        return results;
    }
    
    //When Line Manager approve stationary
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO ApproveStationary(ESS_Stationary_DTO.SearchDTO search, string comment) {
        
        PISUsers__c loginedUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            loginedUser = ESS_Global.assignToPISUser(userId);
        }
        
        ESS_Stationary__c model = queryStationaryById(search.recordId);
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
            model.Status__c = ESS_Enum.StationaryServiceStatus.Waiting.name();
            model.Approved_Date__c = system.datetime.now();
            if(isPRTRUser) {
            	model.Approved_By__c = User.FirstName + ' ' + User.LastName;
            }
            else {
                model.Approved_By__c = loginedUser.EN_Fullname__c;
            }
            model.Approved_Comment__c = comment;
            database.update(model, true);
            
            if(model.User_Manager_Flow__c) {
                ESS_StationaryNotification.SendToEmployeeAndEmployeeAdminWhenUserManagerApprove(model);
            }
            else {
                ESS_StationaryNotification.SendToAdminPMSVWhenRequested(model);
            }
        }
        
        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static List<ESS_Stationary_DTO.StationaryCardDTO> ApproveMultipleStationary(List<ESS_Stationary_DTO.StationaryCardDTO> inputs, string comment) {
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        List<ESS_Stationary_DTO.StationaryCardDTO> results = new List<ESS_Stationary_DTO.StationaryCardDTO>();
        for (ESS_Stationary_DTO.StationaryCardDTO input : inputs) {
            if (input.isSelected) {
                ESS_Stationary__c model = queryStationaryById(input.recordId);
        
                if (model.Status__c == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
            		model.Status__c = ESS_Enum.StationaryServiceStatus.Waiting.name();
                    if(isPRTRUser) {
                        model.Approved_By__c = User.FirstName + ' ' + User.LastName;
                    }
                    else {
                        model.Approved_By__c = PISUser.EN_Fullname__c;
                    }
                    model.Approved_Date__c = system.datetime.now();
                    model.Approved_Comment__c = comment;
                    database.update(model, true);
            		ESS_StationaryNotification.SendToEmployeeAndEmployeeAdminWhenUserManagerApprove(model);
            		ESS_StationaryNotification.SendToAdminPMSVWhenRequested(model);
                }

                string recordId = input.recordId;
                string query = getStationaryCardQuery();
                query +=  ' where Id = :recordId';
                ESS_Stationary__c cardModel = Database.query(query);
                results.add(assignToStationaryCardDTO(cardModel));

            }else{
                results.add(input);
            }
        }
        
        return results;
    }
    
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO CancelRequestStationary(ESS_Stationary_DTO.RejectCancelDTO cancel) {
        
        ESS_Stationary__c model = queryStationaryById(cancel.recordId);
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Draft.name()) {
            model.Status__c = ESS_Enum.StationaryServiceStatus.Cancelled.name();
            if(isPRTRUser) {
                model.Cancelled_By__c = User.FirstName + ' ' + User.LastName;
            }
            else {
                model.Cancelled_By__c = PISuser.EN_Fullname__c;
            }
            model.Cancelled_Date__c = system.datetime.now();
            model.Cancel_Comment__c = cancel.comment;
            database.update(model, true);
            
        }
        ESS_Stationary_DTO.SearchDTO search = new ESS_Stationary_DTO.SearchDTO();
        search.recordId = cancel.recordId;
        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO RejectStationary(ESS_Stationary_DTO.RejectCancelDTO cancel) {
        ESS_Stationary__c model = queryStationaryById(cancel.recordId);
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Verifying.name() || 
           	model.Status__c == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
            
            boolean isRejectByUserManager = false;
            if(model.Status__c == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
                isRejectByUserManager = true;
            }
                
            model.Status__c = ESS_Enum.StationaryServiceStatus.Rejected.name();
            if(isPRTRUser) {
            	model.Rejected_By__c = User.FirstName + ' ' + User.LastName;        
            }
            else {
            	model.Rejected_By__c = PISUSer.EN_Fullname__c;        
            } 
            model.Reject_Comment__c = cancel.comment;
            model.Rejected_Date__c = system.datetime.now();    
            
            if(isRejectByUserManager) {
            	ESS_StationaryNotification.SendToEmployeeAndEmployeeAdminWhenUserManagerRejected(model);        
            }
            else {
            	if (model.On_Behalf_Flow__c) {
            		ESS_StationaryNotification.SendToEmployeeAdminWhenEmployeeRejectOnBehalf(model);  
            	}  
            }
                
            database.update(model, true);
        }
        
        ESS_Stationary_DTO.SearchDTO search = new ESS_Stationary_DTO.SearchDTO();
        search.recordId = cancel.recordId;
        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static List<ESS_Stationary_DTO.StationaryCardDTO> RejectMultipleStationary(List<ESS_Stationary_DTO.StationaryCardDTO> inputs, string comment) {
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        List<ESS_Stationary_DTO.StationaryCardDTO> results = new List<ESS_Stationary_DTO.StationaryCardDTO>();
        for (ESS_Stationary_DTO.StationaryCardDTO input : inputs) {
            
            if (input.isSelected) {
                ESS_Stationary__c model = queryStationaryById(input.recordId);
        
                if (model.Status__c == ESS_Enum.StationaryServiceStatus.Verifying.name() ||
                    model.Status__c == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
                   
                    boolean isRejectByUserManager = false;
                    if(model.Status__c == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) {
                        isRejectByUserManager = true;
                    }
                        
                    model.Status__c = ESS_Enum.StationaryServiceStatus.Rejected.name();
                    if(isPRTRUser) {
                        model.Rejected_By__c = User.FirstName + ' ' + User.LastName;        
                    }
                    else {
                        model.Rejected_By__c = PISUSer.EN_Fullname__c;        
                    } 
                    model.Rejected_Date__c = system.datetime.now();
                    model.Reject_Comment__c = comment;
                        
                    if(isRejectByUserManager) {
                        ESS_StationaryNotification.SendToEmployeeAndEmployeeAdminWhenUserManagerRejected(model);        
                    }
                    else {
                        if (model.On_Behalf_Flow__c) {
                            ESS_StationaryNotification.SendToEmployeeAdminWhenEmployeeRejectOnBehalf(model);  
                        }  
                    }
                    database.update(model, true);
                }

                string recordId = input.recordId;
                string query = getStationaryCardQuery();
                query +=  ' where Id =: recordId';
                ESS_Stationary__c cardModel = Database.query(query);
                results.add(assignToStationaryCardDTO(cardModel));

            }else{
                results.add(input);
            }
        }
        
        return results;
    }
    
    //การ Save ก่อนปิดงาน (ให้ใช้ปุ่มแยกกับตอนเปิดงาน ใช้ flag canSaveCompleted)
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO SaveCompleteStationary(ESS_Stationary_DTO.StationaryDetailDTO input)
    {
        //string userId = ESS_PrivilegeHandler.getUserId();
        ESS_Stationary__c model = queryStationaryById(input.recordId);
        PISUsers__c pmsvUser = new PISUsers__c();
        User User = new User();
        //boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            pmsvUser = ESS_Global.assignToPISUser(userId);
        }
        
        if(input.ServiceFor != null) {
            model.Service_For__c = input.ServiceFor.key;
        }
        model.Location__c = input.location;
        List<string> attachmentIds = new List<string>();
        if(input.withdraws != null) {
            model.Total_Stock__c = 0;
            model.Withdraw_From_Stock__c = JSON.serialize(input.withdraws);
            for(ESS_Stationary_DTO.WithdrawDTO Withdraw : input.withdraws) {
                model.Total_Stock__c += Withdraw.totalPrice;
            } 
        }
        if(input.withdrawOthers != null) {
            model.Withdraw_Other__c = JSON.serialize(input.withdrawOthers);
            model.Total_Other__c = 0;
            for(ESS_Stationary_DTO.WithdrawDTO Withdraw : input.withdrawOthers) {
                model.Total_Other__c += Withdraw.totalPrice;
            }
        }
        
        model.Total__c = model.Total_Stock__c + model.Total_Other__c;
		model.Staff_Comment__c = input.staffComment;
        model.PMSV_Comment__c = input.adminPMSVComment;
        
        database.update(model, true);
        
        ESS_Stationary_DTO.SearchDTO search = new ESS_Stationary_DTO.SearchDTO();
        search.recordId = model.Id;
        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO CompleteStationary(ESS_Stationary_DTO.StationaryDetailDTO input) {
        input = SaveCompleteStationary(input);

        //string userId = ESS_PrivilegeHandler.getUserId();
        ESS_Stationary__c model = queryStationaryById(input.recordId);
        PISUsers__c pmsvUser = new PISUsers__c();
        User User = new User();
        //boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            pmsvUser = ESS_Global.assignToPISUser(userId);
        }
  
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.OnProcess.name()) {
            
            //Save PMSV Detail
            if(!isPRTRUser) {
                model.PMSV__c = pmsvUser.EN_Fullname__c;
                model.PMSV_Employee_Id__c = pmsvUser.EMPLOYEEID__c;
                model.PMSV_Email__c = pmsvUser.EMAIL__c;
                model.PMSV_Position__c = pmsvUser.OBJENFULLNAME__c;
                model.PMSV_Unit__c = pmsvUser.UNITS__c;
                model.PMSV_Section__c = pmsvUser.SECTIONS__c;
                model.PMSV_Department__c = pmsvUser.DEPARTMENT__c;
                model.PMSV_Function__c = pmsvUser.FUNCTION__c;
            }
        	else {
                model.PMSV__c = User.FirstName_EN__c + ' ' + User.LastName_EN__c;
                model.PMSV_Employee_Id__c = User.Employee_Id__c;
                model.PMSV_Email__c = User.Email;
                model.PMSV_Position__c = User.Position__c;
                model.PMSV_Unit__c = User.Unit__c;
                model.PMSV_Section__c = User.Section__c;
                model.PMSV_Department__c = User.Department;
                model.PMSV_Function__c = User.Function__c;
            }
            
            model.Status__c = ESS_Enum.StationaryServiceStatus.Completed.name();
            model.Completed_Date__c = system.datetime.now();
            
            if(input.withdraws != null) {
                model.Total_Stock__c = 0;
                model.Withdraw_From_Stock__c = JSON.serialize(input.withdraws);
                for(ESS_Stationary_DTO.WithdrawDTO Withdraw : input.withdraws) {
                    model.Total_Stock__c += Withdraw.totalPrice;
                    DeductStockOnHandWhenCompleted(Withdraw.recordId, (integer)Withdraw.actualWithdraw);
                }
            }
            if(input.withdrawOthers != null) {
                model.Total_Other__c = 0;
                model.Withdraw_Other__c = JSON.serialize(input.withdrawOthers);
                for(ESS_Stationary_DTO.WithdrawDTO Withdraw : input.withdrawOthers) {
                    model.Total_Other__c += Withdraw.totalPrice;
                }
            }
            
            database.update(model, true);
        	
            ESS_StationaryNotification.SendToEmployeeAndEmployeeAdminWhenCompleted(model);
            
        }
        ESS_Stationary_DTO.SearchDTO search = new ESS_Stationary_DTO.SearchDTO();
        search.recordId = input.recordId;
        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO AcceptStationary(ESS_Stationary_DTO.AcceptDTO accept) {
        
        ESS_Stationary__c model = queryStationaryById(accept.recordId);
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Waiting.name()) {  
            
            model.Status__c = ESS_Enum.StationaryServiceStatus.OnProcess.name();              
            if(isPRTRUser) {
            	model.Accepted_By__c = User.FirstName + ' ' + User.LastName;        
            }
            else {
            	model.Accepted_By__c = PISUSer.EN_Fullname__c;        
            } 
            model.Accepted_Comment__c = accept.comment;
            model.Accepted_Date__c = system.datetime.now();   
            model.Delivery_Date__c = accept.deliveryDate;
            
            ESS_StationaryNotification.SendToEmployeeAndEmployeeAdminWhenAccepted(model); 
                
            database.update(model, true);
        }
        
        ESS_Stationary_DTO.SearchDTO search = new ESS_Stationary_DTO.SearchDTO();
        search.recordId = accept.recordId;
        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    
    @RemoteAction
    public static ESS_Stationary_DTO.StationaryDetailDTO SaveRatingStationary(ESS_Stationary_DTO.StationaryDetailDTO input) {
        
        ESS_Stationary__c model = queryStationaryById(input.recordId);
        
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

        ESS_Stationary_DTO.SearchDTO search = new ESS_Stationary_DTO.SearchDTO();
        search.recordId = model.Id;
        ESS_Stationary_DTO.StationaryDetailDTO result = GetStationaryDetail(search);
        return result;
    }
    
    @RemoteAction
    public static List<ESS_Stationary_DTO.SearchUserDTO> SearchUsers(ESS_Stationary_DTO.SearchDTO search) {
        
        string searchName = '%' + search.search + '%';
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //PISUsers
        string queryPIS = 'select id, user__c, employeeid__c, email__c, thtitle__c, thfirstname__c, thlastname__c, active__c, mainposition__c, EN_Fullname__c, OBJENFULLNAME__c, TH_Fullname__c, units__c, sections__c, DEPARTMENT__c, FUNCTION__c, ReportToUser__c, ReportToName__c, Level__c from PISUsers__c';
        queryPIS = queryPIS + ' where user__c != :userId AND (employeeid__c like: searchName OR enfirstname__c like: searchName) AND active__c = true AND mainposition__c = true limit 100';
        PISUsers = database.query(queryPIS);
        
        List<ESS_Stationary_DTO.SearchUserDTO> SearchUsers = new List<ESS_Stationary_DTO.SearchUserDTO>();
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                ESS_Stationary_DTO.SearchUserDTO SearchUser = new ESS_Stationary_DTO.SearchUserDTO();
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
                SearchUser.level = PISUser.LEVEL__c;
                SearchUser.userManagerId = PISUser.ReportToUser__c;
                SearchUser.userManagerName = PISUser.ReportToName__c;
                SearchUsers.add(SearchUser);
            }
        }
        
        return SearchUsers;
    }
    
    @RemoteAction
    public static string UploadFile(ESS_Stationary_DTO.UploadFileDTO UploadFile) {
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

    @RemoteAction
    public static List<ESS_Stationary_DTO.MasterStationaryListDTO> GetMasterStationaryList(ESS_Stationary_DTO.SearchDTO search, string serviceFor) {
        
        List<ESS_Stationary_DTO.MasterStationaryListDTO> masterStationaries = new List<ESS_Stationary_DTO.MasterStationaryListDTO>();
        
        string query = 'SELECT id,attachment_files__c,name,stationary_name__c,stock_on_hand__c,unit__c,price__c FROM ESS_Master_Stationary__c where active__c = true AND service_for__c = :serviceFor';
        
        if(string.isNotBlank(search.search)) {
            string searchName = '%' + search.search + '%';
            query += ' and (name like :searchName OR stationary_name__c like :searchName)';
        }
        
        //Add order 
        query += ' order by name asc';
        
        List<ESS_Master_Stationary__c> Stationaries = new List<ESS_Master_Stationary__c>();
        
        Stationaries = database.query(query);
        
        if(Stationaries.size() > 0) {
            for(ESS_Master_Stationary__c Stationary : Stationaries) {
                ESS_Stationary_DTO.MasterStationaryListDTO masterStationary = new ESS_Stationary_DTO.MasterStationaryListDTO();
                masterStationary.recordId = Stationary.Id;
                masterStationary.stationaryId = Stationary.name;
                masterStationary.stationaryName = Stationary.stationary_name__c;
                masterStationary.stockOnHand = Integer.ValueOf(Stationary.stock_on_hand__c);
                masterStationary.unit = Stationary.unit__c;
                masterStationary.price = Stationary.price__c;
                if (string.isNotBlank(Stationary.Attachment_Files__c)){
                    List<string> attachmentFileIds = Stationary.Attachment_Files__c.split(',');
                    masterStationary.attachmentFiles = new List<ESS_DTO.FileDTO>();
                    for (string fileId : attachmentFileIds) {
                        ESS_DTO.FileDTO fileDTO = new ESS_DTO.FileDTO();
                        fileDTO.id = fileId;
                        fileDTO.url = generateDocumentUrl(fileId);
                        masterStationary.attachmentFiles.add(fileDTO);
                    }
                }
                masterStationaries.add(masterStationary);
            }
        }        
        
        return masterStationaries;
    }
    
    @RemoteAction
    public static string ExportStationaryExcel(AdminSearchCriteria filter) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_Stationary_Excel?';
        
        integer year = filter.year;
        integer month = filter.month;
        
        URL += 'year=' + year + 
            	'&month=' + month;
        
        return URL;
    }
    
    @RemoteAction
    public static string DefaultWithdrawFrom(string userId) {
        
        string withdrawFrom = '';
        PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
        List<string> topTSRs = getWithdrawFroms(ESS_Enum.StationaryWithdrawFrom.TSR.name());
        List<string> topBKKs = getWithdrawFroms(ESS_Enum.StationaryWithdrawFrom.TBK.name());
        
        if(topTSRs.contains(PISUser.PERSUBAREA__c) || string.isEmpty(PISUser.PERSUBAREA__c)) {
            withdrawFrom = ESS_Enum.StationaryWithdrawFrom.TSR.name();
        }
        else if(topBKKs.contains(PISUser.PERSUBAREA__c)) {
            withdrawFrom = ESS_Enum.StationaryWithdrawFrom.TBK.name();
        }
        
        return withdrawFrom;
    }
    
    @RemoteAction
    public static string DefaultServiceFor(string userId) {
        
        string serviceFor = '';
        PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
        List<string> topTSRs = getServiceFors(ESS_Enum.StationaryServiceFor.TOPTSR.name());
        List<string> topTBKs = getServiceFors(ESS_Enum.StationaryServiceFor.TOPTBK.name());
        List<string> labixs = getServiceFors(ESS_Enum.StationaryServiceFor.LABIX.name());
        List<string> teses = getServiceFors(ESS_Enum.StationaryServiceFor.TES.name());
        List<string> ttcs = getServiceFors(ESS_Enum.StationaryServiceFor.TTC.name());
        List<string> tets = getServiceFors(ESS_Enum.StationaryServiceFor.TET.name());
        List<string> tlbs = getServiceFors(ESS_Enum.StationaryServiceFor.TLB.name());
        List<string> tpxs = getServiceFors(ESS_Enum.StationaryServiceFor.TPX.name());
        List<string> txs = getServiceFors(ESS_Enum.StationaryServiceFor.TX.name());
        List<string> others = getServiceFors(ESS_Enum.StationaryServiceFor.OTHER.name());
        List<string> topspps = getServiceFors(ESS_Enum.StationaryServiceFor.TOPSPP.name());
        
        if(topTSRs.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.TOPTSR.name();
        }
        else if(topTBKs.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.TOPTBK.name();
        }
        else if(labixs.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.LABIX.name();
        }
        else if(teses.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.TES.name();
        }
        else if(ttcs.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.TTC.name();
        }
        else if(tets.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.TET.name();
        }
        else if(tlbs.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.TLB.name();
        }
        else if(tpxs.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.TPX.name();
        }
        else if(txs.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.TX.name();
        }
        else if(others.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.OTHER.name();
        }
        else if(topspps.contains(PISUser.PERSUBAREA__c)) {
            serviceFor = ESS_Enum.StationaryServiceFor.TOPSPP.name();
        }
        
        return serviceFor;
    }
    
    private static string getStationaryCardQuery()
    {
        return 
        'SELECT id, Document_No__c, On_Behalf_Flow__c, Status__c, Service_For__c, Requester_Name__c, Requester_Section__c, Requester_Department__c,' +
        'Requester_Function__c, CreatedDate, Completed_Date__c, Rejected_Date__c, PMSV__c, Reject_Comment__c,User_Manager_Flow__c,User_Manager_Id__c, Location__c, Submitted_Date__c,' +
        'On_Behalf_Of__c,OwnerId,Requester_Name_EN__c,On_Behalf_Of_EN__c' +
        ' from ESS_Stationary__c';
    }
    
    public static string getStationaryDetailQuery()
    {
        return 
        'SELECT Accepted_Date__c,Administrator_Email__c,Administrator_Name__c,Approved_Date__c,Attachment_Files__c,Attentiveness_Rating__c,' +
        'Comment__c,Completed_Date__c,CreatedDate,Document_No__c,Expertise_Rating__c,Fast_Rating__c,Id,Internal_No__c,LastActivityDate,' +
        'LastModifiedById,LastModifiedDate,Last_Updated_By__c,Last_Updated_Date__c,Location__c,Mobile_No__c,Name,On_Behalf_Flow__c,On_Behalf_Of_Department__c,' +
        'On_Behalf_Of_Email__c,On_Behalf_Of_Employee_Id__c,On_Behalf_Of_Flow__c,On_Behalf_Of_Function__c,On_Behalf_Of_Id__c,On_Behalf_Of_Position__c,On_Behalf_Of_Section__c,' +
        'On_Behalf_Of_Unit__c,On_Behalf_Of_Verifying__c,On_Behalf_Of__c,OwnerId,PMSV_Department__c,PMSV_Email__c,PMSV_Employee_Id__c,PMSV_Function__c,PMSV_Id__c,PMSV_Position__c,' +
        'PMSV_Section__c,PMSV_Unit__c,PMSV__c,Punctuality_Rating__c,Rating_Date__c,Rating_Score__c,Rejected_Date__c,Reject_Comment__c,Requester_Department__c,Requester_Email__c, Requester_Position__c,' +
        'Requester_Employee_Id__c,Requester_Function__c,Requester_Id__c,Requester_Name__c,Requester_Section__c,Requester_Tel_Mobile__c,Requester_Tel_Office__c,Requester_Unit__c,' +
        'Service_For__c,Status__c,Submitted_Date__c,Total_Other__c,Total_Stock__c,Total__c,Verified_Date__c,Withdraw_From_Stock__c,Withdraw_From__c,Withdraw_Other__c,Cancelled_Date__c,Cancel_Comment__c,' +
        'User_Manager_Id__c,User_Manager__c,User_Manager_Flow__c, PMSV_Comment__c, CC__c, CC_Email__c, Requester_Level__c, On_Behalf_Of_Level__c, CC_Level__c,Need_Date__c,Is_PRTR_Requester__c,' +
        'Attentiveness_Rating_2__c, Expertise_Rating_2__c, Fast_Rating_2__c, Punctuality_Rating_2__c, Rating_Date_2__c, Rating_Score_2__c,Verify_Comment__c,Approved_Comment__c,Requester_Name_EN__c,On_Behalf_Of_EN__c, Rejected_By__c,Approved_By__c,' +
		'Staff_Comment__c,User_Manager_EN__c, Verified_By__c, Cancelled_By__c, Accepted_By__c, Delivery_Date__c, Accepted_Comment__c' +
        ' from ESS_Stationary__c';
    }
    
    public static ESS_Stationary__c queryStationaryById(string recordId){
        string query = getStationaryDetailQuery();
        query +=  ' where Id = :recordId';
        ESS_Stationary__c model = Database.query(query);
        return model;
    }
    
    private static ESS_Stationary_DTO.StationaryCardDTO assignToStationaryCardDTO(ESS_Stationary__c model)
    {
        //string userId = ESS_PrivilegeHandler.getUserId();
        
        ESS_Stationary_DTO.StationaryCardDTO result = new ESS_Stationary_DTO.StationaryCardDTO();
        result.recordId = model.id;
        result.documentNo = model.Document_No__c;
        result.isOnBehalf = model.On_Behalf_Flow__c;
        result.status = new ESS_Global.EnumValue('StationaryServiceStatus');
        result.status.key = model.Status__c;
        result.status.value = model.Status__c;
        result.createdDate = model.CreatedDate;
        result.completedDate = model.Completed_Date__c;        
        result.requesterDisplayName = model.Requester_Name_EN__c;
        result.serviceFor = new ESS_Global.EnumValue('StationaryServiceFor');
        result.serviceFor.key = model.Service_For__c;
        result.serviceFor.value = model.Service_For__c;
        
        result.canSelect = true;
        if(userId == model.OwnerId) {
            result.canSelect = false;
        }
        
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

    @TestVisible
    private static ESS_Stationary_DTO.StationaryListDTO assignToStationaryListDTO(ESS_Stationary__c model)
    {
        ESS_Stationary_DTO.StationaryListDTO result = new ESS_Stationary_DTO.StationaryListDTO();
        result.recordId = model.id;
        result.documentNo = model.Document_No__c;
        result.isOnBehalf = model.On_Behalf_Flow__c;
        result.location = model.Location__c;
        
        Map<string, string> statuses = GetAllStatuses();
        result.status = new ESS_Global.EnumValue('StationaryServiceStatus');
        result.status.key = model.Status__c;
        result.status.value = statuses.get(model.Status__c);
        
        result.createdDate = model.CreatedDate;
        result.submittedDate = model.Submitted_Date__c;
        result.completedDate = model.Completed_Date__c;        
        result.requesterDisplayName = model.Requester_Name_EN__c;
        result.onBehalfOfEmployeeName = model.On_Behalf_Of_EN__c;
        
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
    
     private static ESS_Stationary_DTO.StationaryDetailDTO assignToStationaryDetailDTO(ESS_Stationary__c model){
        
        ESS_Stationary_DTO.StationaryDetailDTO result = new ESS_Stationary_DTO.StationaryDetailDTO();
        result.recordId = model.id;
        result.documentNo = model.Document_No__c;
        if (string.isNotBlank(model.Status__c)) {
            result.status = new ESS_Global.EnumValue('StationaryServiceStatus');
            result.status.key = model.Status__c;
            result.status.value = model.Status__c;
        }
        if (string.isNotBlank(model.Withdraw_From__c)){
            result.withdrawFrom = new ESS_Global.EnumValue('StationaryWithdrawFrom');
            result.withdrawFrom.key = model.Withdraw_From__c;
            result.withdrawFrom.value = ESS_Enum.getStationaryWithdrawFromValue(ESS_Enum.StationaryWithdrawFrom.valueOf(model.Withdraw_From__c));
        }
        if (string.isNotBlank(model.Service_For__c)){
            result.serviceFor = new ESS_Global.EnumValue('StationaryServiceFor');
            result.serviceFor.key = model.Service_For__c;
            result.serviceFor.value = ESS_Enum.getStationaryServiceForValue(ESS_Enum.StationaryServiceFor.valueOf(model.Service_For__c));
        }
        result.canOnlyOnBehalf = model.Is_PRTR_Requester__c;
        result.needDate = model.Need_Date__c;
        result.location = model.Location__c;
        result.internalNo = model.Internal_No__c;
        result.mobileNo = model.Mobile_No__c;
        result.comment = model.Comment__c;
        result.verifyComment = model.Verify_Comment__c;
        result.cancelComment = model.Cancel_Comment__c;
        result.rejectComment = model.Reject_Comment__c;
        result.rejectedBy = model.Rejected_By__c;
        result.adminPMSVComment = model.PMSV_Comment__c;
        result.staffComment = model.Staff_Comment__c;
        result.approvedComment = model.Approved_Comment__c;
        result.acceptedBy = model.Accepted_By__c;
         
         if(string.isNotBlank(model.Withdraw_From_Stock__c)) {
         	result.withdraws = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(model.Withdraw_From_Stock__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
         }
         
         if(string.isNotBlank(model.Withdraw_Other__c)) {
             result.withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(model.Withdraw_Other__c, List<ESS_Stationary_DTO.WithdrawDTO>.class);
         }
         
        result.location = model.Location__c;
        result.total = model.Total__c;
        result.totalStock = model.Total_Stock__c;
        result.totalOther = model.Total_Other__c;
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
        result.isOnBehalf = model.On_Behalf_Flow__c;
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
        if(string.isNotEmpty(model.PMSV__c)) {
        	result.pmsvEmployeeName = model.PMSV__c;
        }
        else {
        	result.pmsvEmployeeName = '-';     
        }
        if(string.isNotEmpty(model.PMSV_Email__c)) {
        	result.pmsvEmail = model.PMSV_Email__c;
        }
        else {
        	result.pmsvEmail = '-';     
        }
        result.pmsvPosition = model.PMSV_Position__c;
        result.pmsvUnit = model.PMSV_Unit__c;
        result.pmsvSection = model.PMSV_Section__c;
        result.pmsvDepartment = model.PMSV_Department__c;
        result.pmsvFunction = model.PMSV_Function__c;
         
        result.userManagerId = model.User_Manager_Id__c;
        result.userManagerName = model.User_Manager__c;
        result.userManagerNameEN = model.User_Manager_EN__c;
        result.userManagerFlow = model.User_Manager_Flow__c;
        
        result.createdDate = model.CreatedDate;
        result.submittedDate = model.Submitted_Date__c;
        result.verifiedDate = model.Verified_Date__c;
        result.acceptedDate = model.Accepted_Date__c;
        result.acceptedComment = model.Accepted_Comment__c;
        result.deliveryDate = model.Delivery_Date__c;
        result.completedDate = model.Completed_Date__c;
        result.ratingDate = model.Rating_Date__c;
        result.ratingDateOBH = model.Rating_Date_2__c;
        result.rejectedDate = model.Rejected_Date__c;
        result.rejectComment = model.Reject_Comment__c;
        result.cancelledDate = model.Cancelled_Date__c;
        result.cancelComment = model.Cancel_Comment__c;
        result.approvedDate = model.Approved_Date__c;

        //Assign Authorize Flag
        result.canSave = checkCanSaveStationary(model, userId);
        result.canEdit = checkCanEditStationary(model, userId);
        result.canSubmit = checkCanSubmitStationary(model, userId);
        result.canVerify = checkCanVerifyStationary(model, userId);
        result.canApprove = checkCanApproveStationary(model, userId);
        result.canAccept = checkCanAcceptStationary(model, userId);
        result.canCancelRequest = checkCanCancelRequestStationary(model, userId);
        result.canSaveComplete = checkCanSaveCompleteStationary(model, userId);
        result.canComplete = checkCanCompleteStationary(model, userId);
        result.showCompleteForm = checkShowCompleteFormStationary(model, userId);
        result.canRating = checkCanRatingStationary(model, userId);
        result.showRatingForm = checkShowRatingFormStationary(model, userId);
        result.showRatingFormOBH = checkShowRatingFormOBHStationary(model, userId);
        result.showPMSVComment = checkShowPMSVComment(model, userId);
         
        return result;
    }
    
    public static boolean checkCanSaveStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Draft.name()) 
        {
            if (model.Requester_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }
    
    public static boolean checkCanEditStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Verifying.name()) 
        {
            if (userId == model.On_Behalf_Of_Id__c) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanSubmitStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Draft.name()) 
        {
            if (model.Requester_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanVerifyStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Verifying.name()) 
        {
            if (model.On_Behalf_Of_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanApproveStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.WaitingToApprove.name()) 
        {
            if (model.User_Manager_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }

    //Remove from Stationary
    public static boolean checkCanCancelRequestStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        return result;
    }

    public static boolean checkCanSaveCompleteStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.OnProcess.name()) 
        {
            boolean isAdmin = isAdminUser;
            boolean isPMSVAdmin = isPMSVAdminUser; 
            boolean isGSBOAdmin = isGSBOAdminUser; 
            if (isAdmin || isPMSVAdmin || isGSBOAdmin) {
                result = true;
            }else if (model.PMSV_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkCanCompleteStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.OnProcess.name()) 
        {
            if (isPMSVAdminUser || isGSBOAdminUser) {
                result = true;
            }else if (model.PMSV_Id__c == userId) {
                result = true;
            }
        }
        return result;
    }

    public static boolean checkShowCompleteFormStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Completed.name()) 
        {
            result = true;
        }
        if(model.Status__c == ESS_Enum.StationaryServiceStatus.OnProcess.name() && (isPMSVAdminUser || isGSBOAdminUser)) {
            result = true;
        }
        return result;
    }
    
    public static boolean checkCanAcceptStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if(model.Status__c == ESS_Enum.StationaryServiceStatus.Waiting.name() && (isPMSVAdminUser || isGSBOAdminUser)) {
            result = true;
        }
        return result;
    }

    public static boolean checkCanRatingStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Completed.name()) 
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

    public static boolean checkShowRatingFormStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Completed.name()) 
        {
            if (model.Rating_Date__c != null) {
                if(isAdminUser || isPMSVAdminUser || isGSBOAdminUser) {
                    result = true;
                }
                else if(model.Requester_Id__c == userId) {
                    result = true;
                }
            }
        }
        if(!result && model.Requester_Id__c == userId) {
            result = checkCanRatingStationary(model,userId);
        }
        return result;
    }
    
    public static boolean checkShowRatingFormOBHStationary(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.Completed.name()) 
        {
            if (model.Rating_Date_2__c != null) {
                if(isAdminUser || isPMSVAdminUser || isGSBOAdminUser) {
                    result = true;
                }
                else if(model.On_Behalf_Of_Id__c == userId) {
                    result = true;
                }
            }
        }
        if(!result && model.On_Behalf_Of_Id__c == userId) {
            result = checkCanRatingStationary(model,userId);
        }
        return result;
    }
    
    public static boolean checkShowPMSVComment(ESS_Stationary__c model, string userId){
        boolean result = false;
        if (model.Status__c == ESS_Enum.StationaryServiceStatus.OnProcess.name() ||
            model.Status__c == ESS_Enum.StationaryServiceStatus.Completed.name()) 
        {            
            List<string> withdrawFroms = model.Withdraw_From__c.split(',');
            for(string withdrawFrom : withdrawFroms) {
                if(withdrawFrom == ESS_Enum.StationaryPrivilege.TSR.name()) {
                    result = isPMSVAdminUser;
                }
                else if(withdrawFrom == ESS_Enum.StationaryPrivilege.TBK.name()) {
                    result = isGSBOAdminUser;
                }
            }
        }
        return result;
    }
    
    public static void AddDueStockWhenSubmit(string recordId, integer quantity) {
        ESS_Master_Stationary__c Master = [select id, due_stock__c from ESS_Master_Stationary__c where Id =: recordId];
        if(Master.Due_Stock__c == null) {
            Master.Due_Stock__c = 0;
        }
        Master.Due_Stock__c += quantity;
        database.update(Master);
    }
    
    public static void DeductStockOnHandWhenCompleted(string recordId, integer quantity) {
        ESS_Master_Stationary__c Master = [select id, Stock_on_Hand__c from ESS_Master_Stationary__c where Id =: recordId];
        Master.Stock_on_Hand__c -= quantity;
        database.update(Master);
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
    
    @TestVisible
    private static Map<string, string> GetAllStatuses()
    {
        Map<string, string> statuses = new Map<string, string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Stationary__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            statuses.put(objPickList.getValue(), objPickList.getLabel());
        }
        return statuses;
    }
    
    @TestVisible
    private static List<string> getWithdrawFroms(string name) {
        if(name == ESS_Enum.StationaryWithdrawFrom.TSR.name()) {
            List<string> topTSRs = new List<string> { '0301','0401','0601','0701','0901','1000','1010','1900','0101','0111','0801',
                    										'3000','Other' };
        	return topTSRs;
        }
        else if(name == ESS_Enum.StationaryWithdrawFrom.TBK.name()) {
            List<string> topBKKs = new List<string> { '0302','0402','0602','0702','0902','2000','2010','2900','0102','0112' };
        	return topBKKs;
        }
        else {
            return null;
        }
    }
    
    @TestVisible
    private static List<string> getServiceFors(string name) {
        if(name == ESS_Enum.StationaryServiceFor.TOPTBK.name()) {
            List<string> serviceFors = new List<string> { '2000','2010','0102','0112' };
        	return serviceFors;
        }
        else if(name == ESS_Enum.StationaryServiceFor.TOPTSR.name()) {
            List<string> serviceFors = new List<string> { '1000','1010','0101','0103','0111','3000' };
        	return serviceFors;
        }
        else if(name == ESS_Enum.StationaryServiceFor.LABIX.name()) {
            List<string> serviceFors = new List<string> { '0901','0902','1900' };
        	return serviceFors;
        }
        else if(name == ESS_Enum.StationaryServiceFor.TES.name()) {
            List<string> serviceFors = new List<string> { '1000' };
        	return serviceFors;
        }
        else if(name == ESS_Enum.StationaryServiceFor.TTC.name()) {
            List<string> serviceFors = new List<string> { '-' };
        	return serviceFors;
        }
        else if(name == ESS_Enum.StationaryServiceFor.TET.name()) {
            List<string> serviceFors = new List<string> { '0601','0602' };
        	return serviceFors;
        }
        else if(name == ESS_Enum.StationaryServiceFor.TLB.name()) {
            List<string> serviceFors = new List<string> { '0401','0402' };
        	return serviceFors;
        }
        else if(name == ESS_Enum.StationaryServiceFor.TPX.name()) {
            List<string> serviceFors = new List<string> { '0301','0302' };
        	return serviceFors;
        }
        else if(name == ESS_Enum.StationaryServiceFor.TX.name()) {
            List<string> serviceFors = new List<string> { '0701','0702' };
        	return serviceFors;
        }
        else if(name == ESS_Enum.StationaryServiceFor.Other.name()) {
            List<string> serviceFors = new List<string> { '2900','3000','Other' };
        	return serviceFors;
        }
        else {
            return null;
        }
    }    
       
    public class AdminSearchCriteria {
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public datetime startCreatedDate {get;set;}
        @RemoteAction
        public datetime endCreatedDate {get;set;}
        @RemoteAction
        public datetime startSubmittedDate {get;set;}
        @RemoteAction
        public datetime endSubmittedDate {get;set;}
        @RemoteAction
        public datetime startAcceptedDate {get;set;}
        @RemoteAction
        public datetime endAcceptedDate {get;set;}
        @RemoteAction
        public datetime startCompletedDate {get;set;}
        @RemoteAction
        public datetime endCompletedDate {get;set;}
        @RemoteAction
        public boolean active {get;set;}
        @RemoteAction
        public boolean showOnlyLowerStock {get;set;}
        @RemoteAction
        public integer year {get;set;}
        @RemoteAction
        public integer month {get;set;}
    }
    
    public class SearchCriteria {
        @RemoteAction
        public string documentNo {get;set;}
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
    }
}