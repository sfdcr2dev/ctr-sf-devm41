/* Author Softever */
global with sharing class ESS_Manpower {

    private static List<ESS_Manpower_DTO.ManpowerTableDTO> manpowerTables;
    private static ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail;
    
    static {
    }
    
    @RemoteAction
    public static integer GetOnBehalfCount(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        string query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, on_behalf_of_flow__c from ESS_Manpower__c where On_Behalf_Of_Id__c =: userId AND On_Behalf_Of_Flow__c = true';
        
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        
        //filter.typeOfService
        if(!string.isEmpty(filter.typeOfService) && !string.isBlank(filter.typeOfService) && filter.typeOfService.toLowerCase() != 'all') {
            string typeOfService = filter.typeOfService;
            query = query + ' AND type_of_service__c =: typeOfService';
        }
        
        //filter.objective
        if(!string.isEmpty(filter.objective) && !string.isBlank(filter.objective) && filter.objective.toLowerCase() != 'all') {
            string objective = filter.objective;
            query = query + ' AND objective__c =: objective';
        }
        
        //filter.jobTitle
        if(!string.isEmpty(filter.jobTitle)) {
            string jobTitle = '%' + filter.jobTitle + '%';
            query = query + ' AND job__c like: jobTitle';
        }
        
        //filter.status
        if(!string.isEmpty(filter.status) && !string.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND status__c =: status';
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
            datetime startCreatedDate = filter.startCreatedDate;
        	query += ' AND (createddate >=: startCreatedDate)';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
            datetime endCreatedDate = filter.endCreatedDate;
        	query += ' AND (createddate <=: endCreatedDate)';
        }
        
        //filter.startSubmittedDate
        if(filter.startSubmittedDate != null) {
            date startSubmittedDate = filter.startSubmittedDate;
        	query += ' AND (submitted_date__c >=: startSubmittedDate)';
        }
        
        //filter.endSubmittedDate
        if(filter.endSubmittedDate != null) {
            date endSubmittedDate = filter.endSubmittedDate;
        	query += ' AND (submitted_date__c <=: endSubmittedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = filter.startCompletedDate;
        	query += ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = filter.endCompletedDate;
        	query += ' AND (completed_date__c <=: endCompletedDate)';
        }
        
        Manpowers = Database.query(query);
        
        if(Manpowers.size() > 0) {
            
            integer onBehalfCount = 0;
            
            for(ESS_Manpower__c Manpower : Manpowers) {
                if(Manpower.On_Behalf_Of_Flow__c && Manpower.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    onBehalfCount++;
                }
                
            }
            
            return onBehalfCount;
            
        }
        
        return 0;
    }
    
    @RemoteAction
    public static integer GetManpowerTableCount(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        string query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, requester_name__c from ESS_Manpower__c where document_no__c != null AND (OwnerId =: userId OR on_behalf_of_id__c =: userId)';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, requester_name__c from ESS_Manpower__c where document_no__c != null AND OwnerId != null';
        }
        
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query += ' AND document_no__c like: documentNo';
        }
        
        //filter.typeOfService
        if(!string.isEmpty(filter.typeOfService) && !string.isBlank(filter.typeOfService) && filter.typeOfService.toLowerCase() != 'all') {
            string typeOfService = filter.typeOfService;
            query += ' AND type_of_service__c =: typeOfService';
        }
        
        //filter.objective
        if(!string.isEmpty(filter.objective) && !string.isBlank(filter.objective) && filter.objective.toLowerCase() != 'all') {
            string objective = filter.objective;
            query += ' AND objective__c =: objective';
        }
        
        //filter.jobTitle
        if(!string.isEmpty(filter.jobTitle)) {
            string jobTitle = '%' + filter.jobTitle + '%';
            query += ' AND job__c like: jobTitle';
        }
        
        //filter.status
        if(!string.isEmpty(filter.status) && !string.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query += ' AND status__c =: status';
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
            datetime startCreatedDate = filter.startCreatedDate;
        	query += ' AND (createddate >=: startCreatedDate)';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
            datetime endCreatedDate = filter.endCreatedDate;
        	query += ' AND (createddate <=: endCreatedDate)';
        }
        
        //filter.startSubmittedDate
        if(filter.startSubmittedDate != null) {
            date startSubmittedDate = filter.startSubmittedDate;
        	query += ' AND (submitted_date__c >=: startSubmittedDate)';
        }
        
        //filter.endSubmittedDate
        if(filter.endSubmittedDate != null) {
            date endSubmittedDate = filter.endSubmittedDate;
        	query += ' AND (submitted_date__c <=: endSubmittedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = filter.startCompletedDate;
        	query += ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = filter.endCompletedDate;
        	query += ' AND (completed_date__c <=: endCompletedDate)';
        }
        
        Manpowers = Database.query(query);
        
        if(Manpowers.size() > 0) {
            integer manpowerCount = 0;
            for(ESS_Manpower__c Manpower : Manpowers) {
                manpowerCount = manpowerCount + 1;
            }
            return manpowerCount;
        }
        return 0;
    }
    
    @RemoteAction
    public static List<ESS_Manpower_DTO.ManpowerTableDTO> GetManpowerTable(SearchCriteria filter,
        //documentNo, typeOfService, objective, jobTitle, status, createdDate, submittedDate, requester, onBehalfOf
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
          
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        manpowerTables = new List<ESS_Manpower_DTO.ManpowerTableDTO>();
        
        string query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, requester_name__c, on_behalf_of__c, section__c, on_behalf_of_section__c, on_behalf_of_flow__c, isNew__c from ESS_Manpower__c where document_no__c != null AND (OwnerId =: userId OR on_behalf_of_id__c =: userId)';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, requester_name__c, on_behalf_of__c, section__c, on_behalf_of_section__c, on_behalf_of_flow__c, isNew__c from ESS_Manpower__c where document_no__c != null AND OwnerId != null';
        }
        
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query += ' AND document_no__c like: documentNo';
        }
        
        //filter.typeOfService
        if(!string.isEmpty(filter.typeOfService) && !string.isBlank(filter.typeOfService) && filter.typeOfService.toLowerCase() != 'all') {
            string typeOfService = filter.typeOfService;
            query += ' AND type_of_service__c =: typeOfService';
        }
        
        //filter.objective
        if(!string.isEmpty(filter.objective) && !string.isBlank(filter.objective) && filter.objective.toLowerCase() != 'all') {
            string objective = filter.objective;
            query += ' AND objective__c =: objective';
        }
        
        //filter.jobTitle
        if(!string.isEmpty(filter.jobTitle)) {
            string jobTitle = '%' + filter.jobTitle + '%';
            query += ' AND job__c like: jobTitle';
        }
        
        //filter.status
        if(!string.isEmpty(filter.status) && !string.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query += ' AND status__c =: status';
        }
        
        //filter.section
        if(!string.isEmpty(filter.section) && !string.isBlank(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query += ' AND section__c =: section';
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
            datetime startCreatedDate = filter.startCreatedDate;
        	query += ' AND (createddate >=: startCreatedDate)';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
            datetime endCreatedDate = filter.endCreatedDate;
        	query += ' AND (createddate <=: endCreatedDate)';
        }
        
        //filter.startSubmittedDate
        if(filter.startSubmittedDate != null) {
            date startSubmittedDate = filter.startSubmittedDate;
        	query += ' AND (submitted_date__c >=: startSubmittedDate)';
        }
        
        //filter.endSubmittedDate
        if(filter.endSubmittedDate != null) {
            date endSubmittedDate = filter.endSubmittedDate;
        	query += ' AND (submitted_date__c <=: endSubmittedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = filter.startCompletedDate;
        	query += ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = filter.endCompletedDate;
        	query += ' AND (completed_date__c <=: endCompletedDate)';
        }
        
        //Sort By   
        string sortByQuery = '';
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
            if(sortByParam.sortBy == 'documentNo') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by document_no__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by document_no__c desc';
                }
            }
            else if(sortByParam.sortBy == 'typeOfService') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by type_of_service__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by type_of_service__c desc';
                }
            }
            else if(sortByParam.sortBy == 'objective') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by objective__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by objective__c desc';
                }
            }
            else if(sortByParam.sortBy == 'jobTitle') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by job__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by job__c desc';
                }
            }
            else if(sortByParam.sortBy == 'status') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by status__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by status__c desc';
                }
            }
            else if(sortByParam.sortBy == 'createdDate') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by createddate asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by createddate desc';
                }
            }
            else if(sortByParam.sortBy == 'submittedDate') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by submitted_date__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by submitted_date__c desc';
                }
            }
            else if(sortByParam.sortBy == 'requester') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by requester_name__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by requester_name__c desc';
                }
            }
        }
        else {
        	sortByQuery = ' order by document_no__c desc';
        }
            
        query += sortByQuery;
            
        if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }
            
        Manpowers = database.query(query);
            
        if(Manpowers.size() > 0) {
            for(ESS_Manpower__c Manpower : Manpowers) {
                manpowerTables.add(assignToManpowerTableDTO(Manpower));
            }
        }
            
        return manpowerTables;
            
    }
    
    @RemoteAction
    public static integer GetManpowerApproveTableCount(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdminPMBP = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isAdminPEOC = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
            
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        List<string> statuses = new List<string>();
           
        string query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, section__c, on_behalf_of_section__c, on_behalf_of_flow__c, isnew__c from ESS_Manpower__c';
        
        if(isAdminPMBP) {
        	query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, requester_name__c, on_behalf_of__c, section__c, on_behalf_of_section__c, isnew__c from ESS_Manpower__c where ownerId != null';
        }
        else if(isAdminPEOC) {
            query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, requester_name__c, on_behalf_of__c, section__c, on_behalf_of_section__c, isnew__c from ESS_Manpower__c where Is_Admin_PEOC__c = true';
        }
        
        if(isAdminPMBP || isAdminPEOC) {
            
            //filter.documentNo
            if(!string.isEmpty(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' AND document_no__c like :documentNo';
            }
            
            //filter.typeOfService
            if(!string.isEmpty(filter.typeOfService) && !string.isBlank(filter.typeOfService) && filter.typeOfService.toLowerCase() != 'all') {
                string typeOfService = filter.typeOfService;
                query += ' AND type_of_service__c = :typeOfService';
            }
            
            //filter.objective
            if(!string.isEmpty(filter.objective) && !string.isBlank(filter.objective) && filter.objective.toLowerCase() != 'all') {
                string objective = filter.objective;
                query += ' AND objective__c = :objective';
            }
            
            //filter.jobTitle
            if(!string.isEmpty(filter.jobTitle)) {
                string jobTitle = '%' + filter.jobTitle + '%';
                query += ' AND job__c like :jobTitle';
            }
            
            //filter.status
            string status = '';
            if(isAdminPEOC) {
                status = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                query += ' AND status__c = :status';
            }
            else if(!string.isEmpty(filter.status) && !string.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                status = filter.status;
                query += ' AND status__c = :status';
            }
            
            //filter.startCreatedDate
            if(filter.startCreatedDate != null) {
                datetime startCreatedDate = filter.startCreatedDate;
                query += ' AND (createddate >=: startCreatedDate)';
            }
            
            //filter.endCreatedDate
            if(filter.endCreatedDate != null) {
                datetime endCreatedDate = filter.endCreatedDate;
                query += ' AND (createddate <=: endCreatedDate)';
            }
            
            //filter.startSubmittedDate
            if(filter.startSubmittedDate != null) {
                date startSubmittedDate = filter.startSubmittedDate;
                query += ' AND (submitted_date__c >=: startSubmittedDate)';
            }
            
            //filter.endSubmittedDate
            if(filter.endSubmittedDate != null) {
                date endSubmittedDate = filter.endSubmittedDate;
                query += ' AND (submitted_date__c <=: endSubmittedDate)';
            }
            
            //filter.startCompletedDate
            if(filter.startCompletedDate != null) {
                date startCompletedDate = filter.startCompletedDate;
                query += ' AND (completed_date__c >=: startCompletedDate)';
            }
            
            //filter.endCompletedDate
            if(filter.endCompletedDate != null) {
                date endCompletedDate = filter.endCompletedDate;
                query += ' AND (completed_date__c <=: endCompletedDate)';
            }
            
            Manpowers = Database.query(query);
        }
        else {
            query += ' WHERE (approver_section_head_id__c =: userId OR approver_vp_id__c =: userId OR approver_project_manager_id__c =: userId)';
        
            //filter.documentNo
            if(!string.isEmpty(filter.documentNo)) {
                string documentNo = '%' + filter.documentNo + '%';
                query += ' AND document_no__c like :documentNo';
            }
            
            //filter.status
            if(!string.isEmpty(filter.status) && !string.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                
                string status = filter.status;
                query += ' AND status__c = :status';
                
            }
            else {
                
                boolean onHandWork = filter.onHandWork;
                
                if(!onHandWork) {
                    statuses = new List<string>{ ESS_Enum.ManpowerStatus.WaitingToSectionHead.name(), ESS_Enum.ManpowerStatus.WaitingToVP.name(), ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()};
                    query += ' AND status__c IN :statuses';        
                }
                
            }  
            
            //filter.startCreatedDate
            if(filter.startCreatedDate != null) {
                datetime startCreatedDate = filter.startCreatedDate;
                query += ' AND (createddate >=: startCreatedDate)';
            }
            
            //filter.endCreatedDate
            if(filter.endCreatedDate != null) {
                datetime endCreatedDate = filter.endCreatedDate;
                query += ' AND (createddate <=: endCreatedDate)';
            }
            
            Manpowers = Database.query(query);
        }
   
        if(Manpowers.size() > 0) {
            integer manpowerCount = 0;
            for(ESS_Manpower__c Manpower : Manpowers) {
                manpowerCount = manpowerCount + 1;
            }
            return manpowerCount;
        }
        return 0;
    }
        
    @RemoteAction
    public static List<ESS_Manpower_DTO.ManpowerTableDTO> GetManpowerApproveTable(SearchCriteria filter,
        //documentNo, typeOfService, objective, jobTitle, status, createdDate, submittedDate, requester, onBehalfOf
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isAdminPMBP = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isAdminPEOC = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
        
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        manpowerTables = new List<ESS_Manpower_DTO.ManpowerTableDTO>();
        
        List<string> statuses = new List<string> { ESS_Enum.ManpowerStatus.WaitingToSectionHead.name(), ESS_Enum.ManpowerStatus.WaitingToVP.name(), ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()  };
            
        string query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, requester_name__c, on_behalf_of__c, section__c, on_behalf_of_section__c, on_behalf_of_flow__c, isnew__c from ESS_Manpower__c';
        
        if(isAdminPMBP) {
        	query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, requester_name__c, on_behalf_of__c, section__c, on_behalf_of_section__c, on_behalf_of_flow__c, isnew__c from ESS_Manpower__c where ownerId != null';
        }
        else if(isAdminPEOC) {
        	query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, requester_name__c, on_behalf_of__c, section__c, on_behalf_of_section__c, on_behalf_of_flow__c, isnew__c from ESS_Manpower__c where Is_Admin_PEOC__c = true';
        }
        
        string documentNo;
        string typeOfService;
        string status;
        string objective;
        string jobTitle;
        datetime startCreatedDate;
        datetime endCreatedDate;    
        date startSubmittedDate;
        date endSubmittedDate;
        date startCompletedDate;
        date endCompletedDate;
            
        if(isAdminPMBP || isAdminPEOC) {
            
            //filter.documentNo
            if(!string.isEmpty(filter.documentNo)) {
                documentNo = '%' + filter.documentNo + '%';
                query += ' AND document_no__c like :documentNo';
            }
            
            //filter.typeOfService
            if(!string.isEmpty(filter.typeOfService) && !string.isBlank(filter.typeOfService) && filter.typeOfService.toLowerCase() != 'all') {
                typeOfService = filter.typeOfService;
                query += ' AND type_of_service__c = :typeOfService';
            }
            
            //filter.objective
            if(!string.isEmpty(filter.objective) && !string.isBlank(filter.objective) && filter.objective.toLowerCase() != 'all') {
                objective = filter.objective;
                query += ' AND objective__c = :objective';
            }
            
            //filter.jobTitle
            if(!string.isEmpty(filter.jobTitle)) {
                jobTitle = '%' + filter.jobTitle + '%';
                query += ' AND job__c like :jobTitle';
            }
            
            //filter.status
            if(isAdminPEOC) {
                status = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                query += ' AND status__c =: status';
            }
            else if(!string.isEmpty(filter.status) && !string.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                status = filter.status;
                query += ' AND status__c = :status';
            }
            
            //filter.startCreatedDate
            if(filter.startCreatedDate != null) {
                startCreatedDate = filter.startCreatedDate;
                query += ' AND (createddate >=: startCreatedDate)';
            }
            
            //filter.endCreatedDate
            if(filter.endCreatedDate != null) {
                endCreatedDate = filter.endCreatedDate;
                query += ' AND (createddate <=: endCreatedDate)';
            }
            
            //filter.startSubmittedDate
            if(filter.startSubmittedDate != null) {
                startSubmittedDate = filter.startSubmittedDate;
                query += ' AND (submitted_date__c >=: startSubmittedDate)';
            }
            
            //filter.endSubmittedDate
            if(filter.endSubmittedDate != null) {
                endSubmittedDate = filter.endSubmittedDate;
                query += ' AND (submitted_date__c <=: endSubmittedDate)';
            }
            
            //filter.startCompletedDate
            if(filter.startCompletedDate != null) {
                startCompletedDate = filter.startCompletedDate;
                query += ' AND (completed_date__c >=: startCompletedDate)';
            }
            
            //filter.endCompletedDate
            if(filter.endCompletedDate != null) {
                endCompletedDate = filter.endCompletedDate;
                query += ' AND (completed_date__c <=: endCompletedDate)';
            }       
        }
        else {
            
            query += ' WHERE (approver_section_head_id__c =: userId OR approver_vp_id__c =: userId OR approver_project_manager_id__c =: userId)';
        
            //filter.documentNo
            if(!string.isEmpty(filter.documentNo)) {
                documentNo = '%' + filter.documentNo + '%';
                query += ' AND document_no__c like: documentNo';
            }
            
            //filter.status
            if(!string.isEmpty(filter.status) && !string.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
                status = filter.status;
                query += ' AND status__c =: status';
            }
            else {
                boolean onHandWork = filter.onHandWork;
                if(!onHandWork) {
                    statuses = new List<string>{ ESS_Enum.ManpowerStatus.WaitingToSectionHead.name(), ESS_Enum.ManpowerStatus.WaitingToVP.name(), ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()};
                    query += ' AND status__c IN: statuses';        
                }
            }  
            
            //filter.startCreatedDate
            if(filter.startCreatedDate != null) {
                startCreatedDate = filter.startCreatedDate;
                query += ' AND (createddate >=: startCreatedDate)';
            }
            
            //filter.endCreatedDate
            if(filter.endCreatedDate != null) {
                endCreatedDate = filter.endCreatedDate;
                query += ' AND (createddate <=: endCreatedDate)';
            }
        }
        
        //Sort By    
        string sortByQuery = '';
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
            if(sortByParam.sortBy == 'documentNo') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by document_no__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by document_no__c desc';
                }
            }
            else if(sortByParam.sortBy == 'typeOfService') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by type_of_service__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by type_of_service__c desc';
                }
            }
            else if(sortByParam.sortBy == 'objective') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by objective__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by objective__c desc';
                }
            }
            else if(sortByParam.sortBy == 'jobTitle') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by job__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by job__c desc';
                }
            }
            else if(sortByParam.sortBy == 'status') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by status__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by status__c desc';
                }
            }
            else if(sortByParam.sortBy == 'createdDate') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by createddate asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by createddate desc';
                }
            }
            else if(sortByParam.sortBy == 'submittedDate') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by submitted_date__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by submitted_date__c desc';
                }
            }
            else if(sortByParam.sortBy == 'requester') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by requester_name__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by requester_name__c desc';
                }
            }
        }
        else {
            sortByQuery = ' order by document_no__c desc';
        }
          
        query += sortByQuery;
         
        if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }
            
        Manpowers = database.query(query);
        
        if(Manpowers.size() > 0) {
            for(ESS_Manpower__c Manpower : Manpowers) {
                manpowerTables.add(assignToManpowerTableDTO(Manpower));
            }
        }
           
        return manpowerTables;
           
    }
    
    @RemoteAction
    public static integer GetManpowerOnBehalfApproveTableCount(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        string query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, isNew__c from ESS_Manpower__c where On_Behalf_Of_Id__c =: userId AND On_Behalf_Of_Id__c != null AND On_Behalf_Of_Flow__c = true';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, isNew__c from ESS_Manpower__c where On_Behalf_Of_Id__c != null AND On_Behalf_Of_Flow__c = true';
        }
        
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        
        //filter.status
        if(!string.isEmpty(filter.status) && !string.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND status__c =: status';
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
            datetime startCreatedDate = filter.startCreatedDate;
        	query += ' AND (createddate >=: startCreatedDate)';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
            datetime endCreatedDate = filter.endCreatedDate;
        	query += ' AND (createddate <=: endCreatedDate)';
        }
        
        Manpowers = Database.query(query);
        
        if(Manpowers.size() > 0) {
            
            integer manpowerCount = 0;
            
            for(ESS_Manpower__c Manpower : Manpowers) {
                
                manpowerCount = manpowerCount + 1;
            }
            
            return manpowerCount;
            
        }
        
        return 0;
        
    }
     
    @RemoteAction
    public static List<ESS_Manpower_DTO.ManpowerTableDTO> GetManpowerOnBehalfApproveTable(SearchCriteria filter,
        //documentNo, typeOfService, objective, jobTitle, status, createdDate, submittedDate, requester, onBehalfOf
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
          
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        manpowerTables = new List<ESS_Manpower_DTO.ManpowerTableDTO>();
        
        string query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, on_behalf_of__c, requester_name__c, section__c, on_behalf_of_section__c, on_behalf_of_flow__c, isNew__c  from ESS_Manpower__c where On_Behalf_Of_Id__c =: userId AND On_Behalf_Of_Id__c != null AND On_Behalf_Of_Flow__c = true';
        
        if(isAdmin) {
            
        	query = 'select id, document_no__c, type_of_service__c, objective__c, job__c, status__c, createddate, submitted_date__c, completed_date__c, on_behalf_of__c, requester_name__c, section__c, on_behalf_of_section__c, on_behalf_of_flow__c, isNew__c from ESS_Manpower__c where On_Behalf_Of_Id__c != null AND On_Behalf_Of_Flow__c = true';
        
        }
        
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        
        //filter.status
        if(!string.isEmpty(filter.status) && !string.isBlank(filter.status) && filter.status.toLowerCase() != 'all') {
            string status = filter.status;
            query = query + ' AND status__c =: status';
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
            datetime startCreatedDate = filter.startCreatedDate;
        	query += ' AND (createddate >=: startCreatedDate)';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
            datetime endCreatedDate = filter.endCreatedDate;
        	query += ' AND (createddate <=: endCreatedDate)';
        }
        
        //Sort By    
        string sortByQuery = '';
        if (sortByParam != null && string.isNotBlank(sortByParam.sortBy)) {
            if(sortByParam.sortBy == 'documentNo') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by document_no__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by document_no__c desc';
                }
            }
            else if(sortByParam.sortBy == 'typeOfService') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by type_of_service__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by type_of_service__c desc';
                }
            }
            else if(sortByParam.sortBy == 'objective') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by objective__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by objective__c desc';
                }
            }
            else if(sortByParam.sortBy == 'jobTitle') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by job__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by job__c desc';
                }
            }
            else if(sortByParam.sortBy == 'status') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by status__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by status__c desc';
                }
            }
            else if(sortByParam.sortBy == 'createdDate') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by createddate asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by createddate desc';
                }
            }
            else if(sortByParam.sortBy == 'submittedDate') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by submitted_date__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by submitted_date__c desc';
                }
            }
            else if(sortByParam.sortBy == 'requester') {
                if(sortByParam.ascending) {
                    sortByQuery = ' order by requester_name__c asc';
                }
                else if(!sortByParam.ascending) {
                    sortByQuery = ' order by requester_name__c desc';
                }
            }
        }
        else {
        	sortByQuery = ' order by document_no__c desc';
        }
        
        query += sortByQuery;
        
        if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }
            
        Manpowers = database.query(query);
        
        if(Manpowers.size() > 0) {
            for(ESS_Manpower__c Manpower : Manpowers) {
                manpowerTables.add(assignToManpowerTableDTO(Manpower));
            }
        }    
            
        return manpowerTables;
           
    }
    
    @RemoteAction
    public static ESS_Manpower_DTO.ManpowerDetailDTO GetManpowerDetail(string manpowerId) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
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
            	PISUser = ESS_Global.assignToPISUser(userId); 
            }
            catch (Exception e) {
                throw new ESS_Exception('[MyError]ไม่พบ PIS user');
            }
        }
        
        manpowerDetail = new ESS_Manpower_DTO.ManpowerDetailDTO();
        
        if(manpowerId == null || manpowerId == 'null') {
            
            manpowerDetail.documentNo = '-';
            manpowerDetail.status = new ESS_Global.EnumValue('ManpowerStatus');
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.Draft.name();
            manpowerDetail.status.value = 'Draft';
            
            //Flow Self
            manpowerDetail.requesterId = userId;
            manpowerDetail.createdDate = date.today();
            if(!isPRTRUser){
                manpowerDetail.requesterEmployeeId = PISUser.EMPLOYEEID__c;
                manpowerDetail.requesterEmployeeName = PISUser.EN_Fullname__c;
                manpowerDetail.requesterPosition = PISUser.OBJENFULLNAME__c;
                manpowerDetail.requesterUnit = PISUser.UNITS__c;
                manpowerDetail.requesterSection = PISUser.SECTIONS__c;
                manpowerDetail.requesterDepartment = PISUser.DEPARTMENT__c;
                manpowerDetail.requesterFunction = PISUser.FUNCTION__c;
                manpowerDetail.requesterEmail = PISUser.EMAIL__c;
            }
            else {
                manpowerDetail.requesterEmployeeId = User.Employee_Id__c;
                manpowerDetail.requesterEmployeeName = User.FirstName_EN__c + ' ' + User.LastName_EN__c;
                manpowerDetail.requesterPosition = User.Position__c;
                manpowerDetail.requesterUnit = User.Unit__c;
                manpowerDetail.requesterSection = User.Section__c;
                //manpowerDetail.requesterDepartment = User.Department;
                manpowerDetail.requesterFunction = User.Function__c;
                manpowerDetail.requesterEmail = User.Email;
                manpowerDetail.canOnlyOnBehalf = true;
            }
            
            //Flag
            manpowerDetail.canEditManpower = true;
            manpowerDetail.canSubmit = true;
            manpowerDetail.canSave = true;
            
        }
        else if(manpowerId != null || manpowerId != 'null') {

            ESS_Manpower__c Manpower = queryManpowerById(manpowerId);
            manpowerDetail = assignToManpowerDetailDTO(Manpower);
            
        }
        
        return manpowerDetail;
        
    }
    
    @RemoteAction
    public static List<ESS_Manpower_DTO.ApprovalHistoryDTO> GetApprovalHistory(string manpowerId) {
        
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> approvalHistories = new List<ESS_Manpower_DTO.ApprovalHistoryDTO>();
        
        ESS_Manpower__c existManpower = new ESS_Manpower__c();
                
        string query = 'select id, status__c, Approval_History_JSON__c from ESS_Manpower__c where id =: manpowerId';
        
        existManpower = database.query(query);
        
        if(string.isNotEmpty(existManpower.Approval_History_JSON__c)) {
            approvalHistories = DeserializeApprovalHistoryJSON(existManpower.Approval_History_JSON__c);
        }
        
        return approvalHistories;
    }
    
    @RemoteAction
    public static List<ESS_Manpower_DTO.ApprovalHistoryDTO> GetCurrentStatusHistory(string manpowerId) {
        
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> approvalHistories = new List<ESS_Manpower_DTO.ApprovalHistoryDTO>();
        
        ESS_Manpower__c existManpower = new ESS_Manpower__c();
                
        string query = 'select id, status__c, Current_Status_JSON__c from ESS_Manpower__c where id =: manpowerId';
        
        existManpower = database.query(query);
        
        if(string.isNotEmpty(existManpower.Current_Status_JSON__c)) {
            approvalHistories = DeserializeCurrentStatusJSON(existManpower.Current_Status_JSON__c);
        }
        
        return approvalHistories;
    }
    
    @RemoteAction
    public static ESS_Manpower_DTO.ManpowerDetailDTO SaveManpower(ESS_Manpower_DTO.ManpowerDetailDTO manpower) {
        
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
        
        boolean isSectionHeadFlow = false;
        boolean isVPFlow = false;
        if(PISUser.LEVEL__c != 'Junior' && PISUser.LEVEL__c != 'Senior' && PISUser.LEVEL__c != 'Supervisor') {
            isSectionHeadFlow = true;
        }
        else if(PISUser.LEVEL__c == 'VP') {
            isVPFlow = true;
        }
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                      OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                                      EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c from PISUsers__c where Active__c = true AND MAINPOSITION__c = true];
        
        try {
            if(manpower.recordId == null || manpower.recordId == 'null') {
                
                //Insert into Manpower
                ESS_Manpower__c newManpower = new ESS_Manpower__c();
                
                string runningNo = ESS_LogicHandler.GenerateRunningNo('Manpower');
                string year = ESS_LogicHandler.GetCurrentYear();
                string month = ESS_LogicHandler.GetCurrentMonth();
                
                newManpower.Document_No__c = 'MSR-' + year + '-' + month + '-' + runningNo;
                newManpower.OwnerId = userId;
                newManpower.Status__c = ESS_Enum.ManpowerStatus.Draft.name();
                newManpower.isNew__c = true;
                if(isPRTRUser) {
                	newManpower.Is_PRTR__c = true;
                }
                newManpower = assignToManpowerModel(newManpower, manpower);
                
                //Validate Job Title when Objective is KHReview (เปลี่ยนแปลงขอบข่ายงาน)
                if(newManpower.Objective__c == ESS_Enum.ManpowerObjective.KHReview.name()) {
                    boolean checkJobTitle = CheckCanSaveSubmitKHReview(manpower);
                    if(!checkJobTitle) {
                    	throw new ESS_Exception(
                    		'[MyError]คุณไม่ได้ทำการเปลี่ยนแปลงขอบข่ายงานที่เลือก กรุณาแก้ไขข้อมูลขอบข่ายงานก่อนทำการบันทึก');    
                    }
                }
                
                database.insert(newManpower, true); 
                manpower.recordId = newManpower.Id; 
                
            }
            else if(manpower.recordId != null || manpower.recordId != 'null') {
                
                string recordId = manpower.recordId;
                ESS_Manpower__c updateManpower = queryManpowerById(recordId);
                if(isPRTRUser) { 
                    updateManpower.Is_PRTR__c = true;
                }
                updateManpower = assignToManpowerModel(updateManpower, manpower);
                
                //Validate Job Title when Objective is KHReview (เปลี่ยนแปลงขอบข่ายงาน)
                if(updateManpower.Objective__c == ESS_Enum.ManpowerObjective.KHReview.name()) {
                    boolean checkJobTitle = CheckCanSaveSubmitKHReview(manpower);
                    if(!checkJobTitle) {
                    	throw new ESS_Exception(
                    		'[MyError]คุณไม่ได้ทำการเปลี่ยนแปลงขอบข่ายงานที่เลือก กรุณาแก้ไขข้อมูลขอบข่ายงานก่อนทำการบันทึก');    
                    }
                }
                
                database.update(updateManpower, true);
            }
        }
        catch(DmlException e) {
            throw new ESS_Exception(
                    '[MyError]Save Manpower exception has occurred: ' + e.getMessage());
        }
        
        manpower = GetManpowerDetail(manpower.recordId);
        return manpower;
    }
    
    @RemoteAction
    public static ESS_Manpower_DTO.ManpowerDetailDTO SubmitManpower(ESS_Manpower_DTO.ManpowerDetailDTO manpower) {
        
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

        //Save before submit
        manpower = SaveManpower(manpower);
        ESS_Manpower__c model = queryManpowerById(manpower.recordId);

        //Set Workflow Type **Important
        model = assignAndCalculateWorkflowType(model);

        //Validate Job Title on Submit
        if(model.Objective__c == ESS_Enum.ManpowerObjective.AddNewPosition.name()) {
        	boolean checkExistJobTitle = CheckExistJobTitleOnSubmit(model.job__c, model.section__c);
            if(checkExistJobTitle) {
                throw new ESS_Exception(
                    '[MyError]Job Title ซ้ำกับข้อมูลที่มีอยู่ในระบบภายใต้ Section เดียวกัน กรุณาตรวจสอบข้อมูล Job Title');
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                      OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                                      EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c from PISUsers__c where Active__c = true];
        

        //Fill VP, Section Head, Project Manager Fields
        model = assignWorkflowApprover(model, PISUsers);

        //Stamp workflow staus and history
        ESS_Enum.ManpowerApproverRole role = ESS_Enum.ManpowerApproverRole.Employee;

        model.Submitted_Date__c = date.today();

        if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent1.name())
        {
            model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
            ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent2.name())
        {
            if(!isPRTRUser) {
            	if(userId == model.Requester_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser);
                    ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
                }
                else if(userId == model.On_Behalf_Of_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
                    model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
                }    
            }
            else {
                model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                model = addApprovalHistoryForUser(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, User);
                ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
            }
            
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent3.name())
        {
            model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
            ESS_ManpowerNotification.SendToAdminWhenApprove(model);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent4.name())
        {
            if(!isPRTRUser) {
            	if(userId == model.Requester_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser);
                    ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
                }
                else if(userId == model.On_Behalf_Of_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }    
            }
            else {
                model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                model = addApprovalHistoryForUser(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, User);
                ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
            }
            
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary1.name())
        {
            model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
            ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary2.name())
        {
            if(!isPRTRUser) {
            	if(userId == model.Requester_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser);
                    ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
                }
                else if(userId == model.On_Behalf_Of_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
                    model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
                }    
            }
            else {
                model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                model = addApprovalHistoryForUser(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, User);
                ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
            }            
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary3.name())
        {
            model.Status__c = ESS_Enum.ManpowerStatus.WaitingToVP.name();
            model.Approver_VP_Id__c = model.VP_Id__c;
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
            ESS_ManpowerNotification.SendToVPOrProjectManagerWhenSectionHeadApprove(model);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary4.name())
        {
            if(!isPRTRUser) {
            	if(userId == model.Requester_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser);
                    ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
                }
                else if(userId == model.On_Behalf_Of_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToVP.name();
                    model.Approver_VP_Id__c = model.VP_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToVPOrProjectManagerWhenSectionHeadApprove(model);
                }   
            }
            else {
            	model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                model = addApprovalHistoryForUser(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, User);
                ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);    
            }
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary5.name())
        {
            model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.VP, PISUser);
            ESS_ManpowerNotification.SendToAdminWhenApprove(model);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary6.name())
        {
            if(!isPRTRUser) {
            	if(userId == model.Requester_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser);
                    ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
                }
                else if(userId == model.On_Behalf_Of_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.VP, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }    
            }
            else {
            	model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                model = addApprovalHistoryForUser(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, User);
                ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
            }
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase1.name())
        {
            model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
            ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase2.name())
        {
            if(!isPRTRUser) {
            	if(userId == model.Requester_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser);
                    ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
                }
                else if(userId == model.On_Behalf_Of_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
                    model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
                }    
            }
            else {
            	model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                model = addApprovalHistoryForUser(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, User);
                ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
            }
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase3.name())
        {
            model.Status__c = ESS_Enum.ManpowerStatus.WaitingToProjectManager.name();
            model.Approver_Project_Manager_Id__c = model.Project_Manager_Id__c;
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
            model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
            ESS_ManpowerNotification.SendToVPOrProjectManagerWhenSectionHeadApprove(model);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase4.name())
        {
            if(!isPRTRUser) {
            	if(userId == model.Requester_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser);
                    ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
                }
                else if(userId == model.On_Behalf_Of_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToProjectManager.name();
                    model.Approver_Project_Manager_Id__c = model.Project_Manager_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToVPOrProjectManagerWhenSectionHeadApprove(model);
                }    
            }
            else {
            	model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                model = addApprovalHistoryForUser(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, User);
                ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
            }
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase5.name())
        {
            if(model.Project_Manager_Section_Head_Up__c)
            {
                model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                ESS_ManpowerNotification.SendToAdminWhenApprove(model);
            }
            else
            {
                model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            	model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                //model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
            }
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase6.name())
        {
            if(!isPRTRUser) {
            	if(userId == model.Requester_Id__c)
                {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser);
                    ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);
                }
                else if(userId == model.On_Behalf_Of_Id__c)
                {
                    if(model.Project_Manager_Section_Head_Up__c)
                    {
                        model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                        model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                        model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                        model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                        ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                    }
                    else
                    {
                        model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
                        model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                        model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                        model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                        ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
                    }
                }    
            }
            else {
            	model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
                model = addApprovalHistoryForUser(model, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, User);
                ESS_ManpowerNotification.SendToEmployeeWhenRequesterSubmitOnBehalf(model);    
            }
        }
        
        //Generate current status
        model = assignAllCurrentStatus(model);

        database.update(model, true);

        manpower = GetManpowerDetail(manpower.recordId);
        return manpower;
    }
    
    @RemoteAction
    public static ESS_Manpower_DTO.ManpowerDetailDTO CancelRequestManpower(ESS_Manpower_DTO.ManpowerDetailDTO manpower, string comment) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
        
        try {
            
            ESS_Manpower__c model = queryManpowerById(manpower.recordId);

            model.Cancelled_Date__c = date.today();
            model.Cancelled_By__c = PISUser.EN_Fullname__c;
            model.Cancelled_By_Id__c = PISUser.User__c;
            model.Comment__c = comment;

            if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent1.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent2.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent3.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent4.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary1.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.VP, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary2.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.VP, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary3.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.VP, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary4.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.VP, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary5.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary6.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase1.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase2.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase3.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase4.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase5.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, comment);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase6.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.Employee, PISUser, comment);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Cancelled, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, comment);
                }
            }

            //Generate current status
            model.Status__c = ESS_Enum.ManpowerStatus.Cancelled.name();
            model = assignAllCurrentStatus(model);

            database.update(model, true);

            ESS_ManpowerNotification.SendToEmployeeWhenCancel(model);
            
        }
        catch(DmlException e) {
            throw new ESS_Exception(
                '[MyError]Cancel request Manpower exception has occurred: ' + e.getMessage());
        }

        manpower = GetManpowerDetail(manpower.recordId);
        return manpower;
    }
    
    @RemoteAction
    public static ESS_Manpower_DTO.ManpowerDetailDTO ApproveManpower(ESS_Manpower_DTO.ManpowerDetailDTO manpower) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
        
        try {
            ESS_Manpower__c model = queryManpowerById(manpower.recordId);
            
            //Stamp workflow status
            if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent1.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent2.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            		model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent3.name())
            {
                //no approve
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent4.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary1.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToVP.name();
            		model.Approver_VP_Id__c = model.VP_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToVPOrProjectManagerWhenSectionHeadApprove(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.VP, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary2.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            		model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToVP.name();
            		model.Approver_VP_Id__c = model.VP_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToVPOrProjectManagerWhenSectionHeadApprove(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.VP, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary3.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.VP, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary4.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToVP.name();
            		model.Approver_VP_Id__c = model.VP_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.VP, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary5.name())
            {
                //no approve
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary6.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.VP, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase1.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToProjectManager.name();
            		model.Approver_Project_Manager_Id__c = model.Project_Manager_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToVPOrProjectManagerWhenSectionHeadApprove(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase2.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            		model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToProjectManager.name();
            		model.Approver_Project_Manager_Id__c = model.Project_Manager_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToVPOrProjectManagerWhenSectionHeadApprove(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase3.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase4.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToProjectManager.name();
            		model.Approver_Project_Manager_Id__c = model.Project_Manager_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase5.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase6.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                    if (!model.Project_Manager_Section_Head_Up__c){
                    	model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                    }
                    ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()){
                    if (model.Project_Manager_Section_Head_Up__c){
                        model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
                        model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                        model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser);
                        model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.AutoApproved, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser);
                        ESS_ManpowerNotification.SendToAdminWhenApprove(model);
                    }else {
                        model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            			model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                        model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Approved, ESS_Enum.ManpowerApproverRole.Employee, PISUser);
                        ESS_ManpowerNotification.SendToSectionHeadWhenSubmit(model);
                    }
                }
            }

            //Generate current status
            model = assignAllCurrentStatus(model);

            database.update(model, true);
        }
        catch(DmlException e) {
            throw new ESS_Exception(
                        '[MyError]Approve Manpower exception has occurred: ' + e.getMessage());
        }
        
        manpower = GetManpowerDetail(manpower.recordId);
        return manpower;
    }
    
    @RemoteAction
    public static ESS_Manpower_DTO.ManpowerDetailDTO RejectManpower(ESS_Manpower_DTO.ManpowerDetailDTO manpower, string rejectComment) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
        
        try {

            ESS_Manpower__c model = queryManpowerById(manpower.recordId);
            ESS_Enum.ManpowerApproverRole adminRole = ESS_Enum.ManpowerApproverRole.AdminPMBP;
            if(model.Is_Admin_PEOC__c){
                adminRole = ESS_Enum.ManpowerApproverRole.AdminPEOC;
            }
            
            model.Comment__c = rejectComment;

            //Stamp workflow status
            if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent1.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent2.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent3.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent4.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary1.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            		model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.VP, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToSectionHeadWhenVPOrProjectManagerReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary2.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            		model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.VP, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToSectionHeadWhenVPOrProjectManagerReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary3.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.VP, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToSectionHeadWhenVPOrProjectManagerReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary4.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.VP, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToSectionHeadWhenVPOrProjectManagerReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary5.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary6.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase1.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
             	else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            		model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToSectionHeadWhenVPOrProjectManagerReject(model);
                } 
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }   
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase2.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            		model.Approver_Section_Head_Id__c = model.Section_Head_Id__c;
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToSectionHeadWhenVPOrProjectManagerReject(model);
                } 
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase3.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToSectionHeadWhenVPOrProjectManagerReject(model);
                } 
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase4.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.ProjectManager, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToSectionHeadWhenVPOrProjectManagerReject(model);
                } 
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase5.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }
            else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase6.name())
            {
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.Employee, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, ESS_Enum.ManpowerApproverRole.SectionHead, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeAdminWhenEmployeeReject(model);
                }
                else if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                    model.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
                    model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Rejected, adminRole, PISUser, rejectComment);
                    ESS_ManpowerNotification.SendToEmployeeWhenSectionHeadOrAdminReject(model);
                }
            }

            //Generate current status
            model = assignAllCurrentStatus(model);
            database.update(model, true);

        }
        catch(DmlException e) {
            throw new ESS_Exception(
                        '[MyError]Reject Manpower exception has occurred: ' + e.getMessage());
        }
        
        manpower = GetManpowerDetail(manpower.recordId);
        return manpower;
    }
    
    @RemoteAction
    public static void DeleteManpower(string manpowerId) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        try {
            
            if(manpowerId != null || manpowerId != 'null') {
                
                ESS_Manpower__c existManpower = new ESS_Manpower__c();
                
                string query = 'select id, status__c from ESS_Manpower__c where id =: manpowerId';
                
                existManpower = database.query(query);
                
                database.delete(existManpower, true);
            }
        }
        catch(DmlException e) {
            throw new ESS_Exception(
                        '[MyError]Delete Manpower exception has occurred: ' + e.getMessage());
        }
        
    }
    
    @RemoteAction
    public static void AcknowledgeManpower(string manpowerId, string jeScore, string comment) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
        
        try {
            
            ESS_Manpower__c model = queryManpowerById(manpowerId);
            
            //Validate Job Title on Acknowledge
            if(model.Objective__c == ESS_Enum.ManpowerObjective.AddNewPosition.name()) {
                boolean checkExistJobTitle = CheckExistJobTitleOnSubmit(model.job__c, model.section__c);
                if(checkExistJobTitle) {
                    throw new ESS_Exception(
                        '[MyError]Job Title ซ้ำกับข้อมูลที่มีอยู่ในระบบภายใต้ Section เดียวกัน กรุณาตรวจสอบข้อมูล Job Title');
                }
                else {
                    //Insert Job Title to Master
                    InsertNewJobTitle(model, jeScore, comment);
                }
            }
            else if(model.Objective__c == ESS_Enum.ManpowerObjective.KHReview.name()) {
                //Inactive existed Job Title before inserting new Job Title
                InactiveJobTitle(model.Job_Id__c);
                //Insert Job Title to Master
                InsertNewJobTitle(model, jeScore, comment);
            }
            
            ESS_Enum.ManpowerApproverRole adminRole = ESS_Enum.ManpowerApproverRole.AdminPMBP;
            if(model.Is_Admin_PEOC__c){
                adminRole = ESS_Enum.ManpowerApproverRole.AdminPEOC;
            }
            
            //Stamp workflow status
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name()) {
                model.Status__c = ESS_Enum.ManpowerStatus.Completed.name();
                model = addApprovalHistory(model, ESS_Enum.ManpowerApprovalStatus.Acknowledged, adminRole, PISUser, comment);
            }

            model.Completed_Date__c = date.today();
            //Generate current status
            model = assignAllCurrentStatus(model);
            model.Comment__c = comment;
            model.JE_Score__c = jeScore;
            database.update(model, true);

            ESS_ManpowerNotification.SendToEmployeeWhenAcknowledge(model);

        }
        catch(DmlException e) {
            throw new ESS_Exception(
                '[MyError]Acknowledge Manpower exception has occurred: ' + e.getMessage());
        }
    }
    
    @RemoteAction
    public static boolean CanEditJobDetail(string typeOfService, string objective) {
        boolean canEdit = checkCanEditJobDetail(typeOfService, objective);
        return canEdit;
    }
    
    @RemoteAction
    public static List<ESS_Manpower_DTO.JobTitleDTO> SearchJobTitle(string jobTitleName, string onBehalfOfSection) {
        
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
        
        string section = '';
        if(string.isNotEmpty(PISUser.SECTIONS__c)) {
            section = PISUser.SECTIONS__c;
        }
        if(string.isNotEmpty(onBehalfOfSection) && onBehalfOfSection != null && onBehalfOfSection != 'null') {
            section = onBehalfOfSection;
        }
        
        List<ESS_Manpower_DTO.JobTitleDTO> jobTitles = new List<ESS_Manpower_DTO.JobTitleDTO>();
        List<ESS_LC1_Scope__c> Scopes = new List<ESS_LC1_Scope__c>();
        
        string searchName = '%' + jobTitleName + '%';
        
        string query = 'select id, name, job_title__c, unit__c, section__c, department__c, function__c, work_location__c, output_required__c, job_detail__c, qualification__c, ' +
            			'physical_requirement__c, je_score__c, comment__c from ESS_LC1_Scope__c';
        
        query += ' where section__c =: section AND active__c = true';
        if(string.isNotBlank(jobTitleName)) {
            query += ' AND (job_title__c like: searchName)';
        }
        query += ' limit 100';
        
        Scopes = database.query(query);
        
		if(Scopes.size() > 0) {
            for(ESS_LC1_Scope__c Scope : Scopes) {
                
                ESS_Manpower_DTO.JobTitleDTO JobTitle = new ESS_Manpower_DTO.JobTitleDTO();
                JobTitle.jobTitleId = Scope.Id;
                JobTitle.jobTitleName = Scope.Job_Title__c;
                JobTitle.unit = Scope.unit__c;
                JobTitle.section = Scope.section__c;
                JobTitle.department = Scope.department__c;
                JobTitle.function = Scope.function__c;
                JobTitle.scopeOfServiceID = Scope.name;
                JobTitle.jeScore = Scope.je_score__c;
                JobTitle.comment = Scope.comment__c;
                
                if(Scope.Work_Location__c == ESS_Enum.ManpowerWorkLocation.Bangkok.name()) {
                    JobTitle.workLocation = new ESS_Global.EnumValue('ManpowerWorkLocation');
                    JobTitle.workLocation.key = ESS_Enum.ManpowerWorkLocation.Bangkok.name();
                    JobTitle.workLocation.value = 'กรุงเทพ';
                }
                else if(Scope.Work_Location__c == ESS_Enum.ManpowerWorkLocation.Sriracha.name()) {
                    JobTitle.workLocation = new ESS_Global.EnumValue('ManpowerWorkLocation');
                    JobTitle.workLocation.key = ESS_Enum.ManpowerWorkLocation.Sriracha.name();
                    JobTitle.workLocation.value = 'ศรีราชา';
                }
                
                
                JobTitle.outputRequired = Scope.output_required__c;
                JobTitle.jobDetail = Scope.job_detail__c;
                JobTitle.qualification = Scope.qualification__c;
                JobTitle.physicalRequirement = Scope.physical_requirement__c; 
                
                jobTitles.add(JobTitle);
			}
        }
        
        return jobTitles;
        
    }
    
    @RemoteAction
    public static List<ESS_Manpower_DTO.SearchUserDTO> SearchUsers(string search) {
        string userId = ESS_PrivilegeHandler.getUserId();
        string searchName = '%' + search + '%';
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //PISUsers
        string queryPIS = 'select id, user__c, employeeid__c, email__c, thtitle__c, thfirstname__c, thlastname__c, active__c, mainposition__c, EN_Fullname__c, OBJENFULLNAME__c, TH_Fullname__c, units__c, sections__c, DEPARTMENT__c, FUNCTION__c from PISUsers__c';
        queryPIS = queryPIS + ' where user__c != :userId AND (employeeid__c like: searchName OR enfirstname__c like: searchName) AND active__c = true AND mainposition__c = true limit 100';
        PISUsers = database.query(queryPIS);
        
        List<ESS_Manpower_DTO.SearchUserDTO> SearchUsers = new List<ESS_Manpower_DTO.SearchUserDTO>();
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                ESS_Manpower_DTO.SearchUserDTO SearchUser = new ESS_Manpower_DTO.SearchUserDTO();
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
    public static List<ESS_Manpower_DTO.ProjectDTO> SearchProjectName(string projectName) {
        
        List<ESS_Manpower_DTO.ProjectDTO> projects = new List<ESS_Manpower_DTO.ProjectDTO>();
        List<ESS_LC1_Project__c> MasterProjects = new List<ESS_LC1_Project__c>();
        
        string searchName = '%' + projectName + '%';
        
        string query = 'select id, project_name__c, project_manager__r.user__c, project_manager_name__c ' +
            			'from ESS_LC1_Project__c';
        query = query + ' where (project_name__c like: searchName) limit 100';
        MasterProjects = database.query(query);
        
		if(MasterProjects.size() > 0) {
            for(ESS_LC1_Project__c Project : MasterProjects) {
                
                ESS_Manpower_DTO.ProjectDTO ProjectDTO = new ESS_Manpower_DTO.ProjectDTO();
                ProjectDTO.projectId = Project.id;
                ProjectDTO.userId = Project.project_manager__r.user__c;
                ProjectDTO.projectName = Project.project_name__c;
                ProjectDTO.projectManagerName = Project.project_manager_name__c;
                projects.add(ProjectDTO);
			}
        }
        
        return projects;
        
    }    

    @RemoteAction
    public static void ChangeManpowerIsNew(string manpowerId) {
        ESS_Manpower__c Manpower = [select id, isNew__c from ESS_Manpower__c where Id = :manpowerId];
        Manpower.isNew__c = false;
        database.update(Manpower, true);
    }
    
    private static ESS_Manpower__c assignWorkflowApprover(ESS_Manpower__c model, List<PISUsers__c> PISUsers){

        if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent1.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.Section_Head__c = approverDTO.sectionHeadName;
            model.Section_Head_Id__c = approverDTO.sectionHeadId;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent2.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.Section_Head__c = approverDTO.sectionHeadName;
            model.Section_Head_Id__c = approverDTO.sectionHeadId;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent3.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            model.Section_Head__c = employee.EN_Fullname__c;
            model.Section_Head_Id__c = employee.User__c;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent4.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            model.Section_Head__c = employee.EN_Fullname__c;
            model.Section_Head_Id__c = employee.User__c;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary1.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.Section_Head__c = approverDTO.sectionHeadName;
            model.Section_Head_Id__c = approverDTO.sectionHeadId;
            model.VP__c = approverDTO.departmentHeadName;
            model.VP_Id__c = approverDTO.departmentHeadId;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary2.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.Section_Head__c = approverDTO.sectionHeadName;
            model.Section_Head_Id__c = approverDTO.sectionHeadId;
            model.VP__c = approverDTO.departmentHeadName;
            model.VP_Id__c = approverDTO.departmentHeadId;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary3.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.Section_Head__c = employee.EN_Fullname__c;
            model.Section_Head_Id__c = employee.User__c;
            model.VP__c = approverDTO.departmentHeadName;
            model.VP_Id__c = approverDTO.departmentHeadId;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary4.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.Section_Head__c = employee.EN_Fullname__c;
            model.Section_Head_Id__c = employee.User__c;
            model.VP__c = approverDTO.departmentHeadName;
            model.VP_Id__c = approverDTO.departmentHeadId;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary5.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.VP__c = employee.EN_Fullname__c;
            model.VP_Id__c = employee.User__c;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary6.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.VP__c = employee.EN_Fullname__c;
            model.VP_Id__c = employee.User__c;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase1.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.Section_Head__c = approverDTO.sectionHeadName;
            model.Section_Head_Id__c = approverDTO.sectionHeadId;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase2.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
            model.Section_Head__c = approverDTO.sectionHeadName;
            model.Section_Head_Id__c = approverDTO.sectionHeadId;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase3.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            model.Section_Head__c = employee.EN_Fullname__c;
            model.Section_Head_Id__c = employee.User__c;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase4.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            model.Section_Head__c = employee.EN_Fullname__c;
            model.Section_Head_Id__c = employee.User__c;
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase5.name())
        {
            if(!model.Project_Manager_Section_Head_Up__c)
            {
                PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
                ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
                model.Section_Head__c = approverDTO.sectionHeadName;
                model.Section_Head_Id__c = approverDTO.sectionHeadId;
            }
            else {
                PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
                model.Section_Head__c = employee.EN_Fullname__c;
                model.Section_Head_Id__c = employee.User__c;
            }
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase6.name())
        {
            if(!model.Project_Manager_Section_Head_Up__c)
            {
                PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
                ESS_Manpower_DTO.ManpowerApproverDTO approverDTO = ESS_Global.GetSectionHeadDepartmentHeadManpower(employee, PISUsers);
                model.Section_Head__c = approverDTO.sectionHeadName;
                model.Section_Head_Id__c = approverDTO.sectionHeadId;
            }
            else {
                PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
                model.Section_Head__c = employee.EN_Fullname__c;
                model.Section_Head_Id__c = employee.User__c;
            }
        }

        return model;
    }

    private static ESS_Manpower__c assignAndCalculateWorkflowType(ESS_Manpower__c model)
    {
        //PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
        
        PISUsers__c employee = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(model.Requester_Id__c);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(model.Requester_Id__c);
        }
        else {
            employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
        }
        
        if(!isPRTRUser) {
         	if(!model.On_Behalf_Of_Flow__c){
                employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            }else{
                employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);   
            }   
        }
        
        boolean isSectionHeadUp = false;
        boolean isVPUp = false;
        boolean isProjectManager = model.Requester_Id__c == model.Project_Manager_Id__c;
        
        //Find Project Manager
        if(model.On_Behalf_Of_Flow__c) {
            isProjectManager = model.On_Behalf_Of_Id__c == model.Project_Manager_Id__c;
        }
        
        if(!isPRTRUser) {
           if(employee.LEVEL__c == 'Section Head') {
        		isSectionHeadUp = true;
           }
           if(employee.LEVEL__c == 'VP' || employee.LEVEL__c == 'EVP Upward') {
                isSectionHeadUp = true;
                isVPUp = true;
           } 
        }
        
        if(model.Type_of_Service__c == ESS_Enum.ManpowerTypeOfService.Permanent.name())
        {
            if(model.On_Behalf_Of_Flow__c && isSectionHeadUp)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Permanent4.name();
                model.Section_Head_Flow__c = true;
            }
            else if(isSectionHeadUp)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Permanent3.name();
                model.Section_Head_Flow__c = true;
            }
            else if(model.On_Behalf_Of_Flow__c)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Permanent2.name();
            }
            else
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Permanent1.name();
            }
        }
        else if(model.Type_of_Service__c == ESS_Enum.ManpowerTypeOfService.Temporary.name())
        {
            if(model.On_Behalf_Of_Flow__c && isVPUp)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Temporary6.name();
                model.VP_Flow__c = true;
            }
            else if(isVPUp)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Temporary5.name();
                model.VP_Flow__c = true;
            }
            else if(model.On_Behalf_Of_Flow__c && isSectionHeadUp)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Temporary4.name();
                model.Section_Head_Flow__c = true;
            }
            else if(isSectionHeadUp)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Temporary3.name();
                model.Section_Head_Flow__c = true;
            }
            else if(model.On_Behalf_Of_Flow__c)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Temporary2.name();
            }
            else
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.Temporary1.name();
            }
        }
        else if(model.Type_of_Service__c == ESS_Enum.ManpowerTypeOfService.ProjectBase.name())
        {
            if(model.On_Behalf_Of_Flow__c && isProjectManager)
            {	
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.ProjectBase6.name();
                model.Project_Manager_Flow__c = true;
                model.Project_Manager_Section_Head_Up__c = isSectionHeadUp;
            }
            else if(isProjectManager)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.ProjectBase5.name();
                model.Project_Manager_Flow__c = true;
                model.Project_Manager_Section_Head_Up__c = isSectionHeadUp;
            }
            else if(model.On_Behalf_Of_Flow__c && isSectionHeadUp)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.ProjectBase4.name();
                model.Section_Head_Flow__c = true;
            }
            else if(isSectionHeadUp)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.ProjectBase3.name();
                model.Section_Head_Flow__c = true;
            }
            else if(model.On_Behalf_Of_Flow__c)
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.ProjectBase2.name();
            }
            else
            {
                model.Workflow_Type__c = ESS_Enum.ManpowerWorkflowType.ProjectBase1.name();
            }
        }

        //set POEC flag
        if(model.Objective__c == ESS_Enum.ManpowerObjective.AddNewPosition.name() || model.Objective__c == ESS_Enum.ManpowerObjective.KHReview.name())
        {
            model.Is_Admin_PEOC__c = true;
        }

        return model;
    }

    public static ESS_Manpower__c assignAllCurrentStatus(ESS_Manpower__c model){
        //reset before generate all
        model.Current_Status_JSON__c = '';

        if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent1.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent2.name())
        {
            if(!model.Is_PRTR__c) {
            	PISUsers__c employeeAdmin = ESS_Global.assignToPISUser(model.Requester_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
                }    
            }
            else {
                USer employeeAdmin = ESS_Global.assignToUser(model.Requester_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalCurrentStatusDefaultForUser(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
                }else {
                    model = addApprovalCurrentStatusByRoleForUser(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
                } 
            }
            
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent3.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Permanent4.name())
        {
            PISUsers__c employeeAdmin = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary1.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            PISUsers__c vp = ESS_Global.assignToPISUser(model.VP_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary2.name())
        {
            PISUsers__c employeeAdmin = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            PISUsers__c vp = ESS_Global.assignToPISUser(model.VP_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary3.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            PISUsers__c vp = ESS_Global.assignToPISUser(model.VP_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary4.name())
        {
            PISUsers__c employeeAdmin = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            PISUsers__c vp = ESS_Global.assignToPISUser(model.VP_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary5.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c vp = ESS_Global.assignToPISUser(model.VP_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.Temporary6.name())
        {
            PISUsers__c employeeAdmin = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c vp = ESS_Global.assignToPISUser(model.VP_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.VP, vp);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase1.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            PISUsers__c projectManager = ESS_Global.assignToPISUser(model.Project_Manager_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase2.name())
        {
            PISUsers__c employeeAdmin = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            PISUsers__c projectManager = ESS_Global.assignToPISUser(model.Project_Manager_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase3.name())
        {
            PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            PISUsers__c projectManager = ESS_Global.assignToPISUser(model.Project_Manager_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase4.name())
        {
            PISUsers__c employeeAdmin = ESS_Global.assignToPISUser(model.Requester_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
            }
            PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
            }
            PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
            }
            PISUsers__c projectManager = ESS_Global.assignToPISUser(model.Project_Manager_Id__c);
            if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
            }else {
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
            }
            model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase5.name())
        {
            if(model.Project_Manager_Section_Head_Up__c)
            {
                PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
                }
                PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
                }
                PISUsers__c projectManager = ESS_Global.assignToPISUser(model.Project_Manager_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
                }
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
            }
            else
            {
                PISUsers__c employee = ESS_Global.assignToPISUser(model.Requester_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
                }
                PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
                }
                PISUsers__c projectManager = ESS_Global.assignToPISUser(model.Project_Manager_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
                }
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
            }
        }
        else if(model.Workflow_Type__c == ESS_Enum.ManpowerWorkflowType.ProjectBase6.name())
        {
            if(model.Project_Manager_Section_Head_Up__c)
            {
                PISUsers__c employeeAdmin = ESS_Global.assignToPISUser(model.Requester_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
                }
                PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
                }
                PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
                }
                PISUsers__c projectManager = ESS_Global.assignToPISUser(model.Project_Manager_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
                }
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
            }
            else
            {
                PISUsers__c employeeAdmin = ESS_Global.assignToPISUser(model.Requester_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.EmployeeAdmin, employeeAdmin);
                }
                PISUsers__c employee = ESS_Global.assignToPISUser(model.On_Behalf_Of_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.Employee, employee);
                }
                PISUsers__c sectionHead = ESS_Global.assignToPISUser(model.Section_Head_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.SectionHead, sectionHead);
                }
                PISUsers__c projectManager = ESS_Global.assignToPISUser(model.Project_Manager_Id__c);
                if (model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name()) {
                    model = addApprovalCurrentStatusDefault(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
                }else {
                    model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.ProjectManager, projectManager);
                }
                model = addApprovalCurrentStatusByRole(model, ESS_Enum.ManpowerApproverRole.AdminPMBP, null);
            }
        }
        return model;
    }

    private static ESS_Manpower__c addApprovalCurrentStatusByRole(ESS_Manpower__c model, ESS_Enum.ManpowerApproverRole role, PISUsers__c pisUser)
    {
        //convert role to PEOC
        if (role == ESS_Enum.ManpowerApproverRole.AdminPMBP && model.Is_Admin_PEOC__c){
            role = ESS_Enum.ManpowerApproverRole.AdminPEOC;
        }
        
        ESS_Manpower_DTO.ApprovalHistoryDTO approve = getLatestHistoryOfRoleAfterLastSubmit(model, role);
        if(approve == null)
        {
            if (role == ESS_Enum.ManpowerApproverRole.EmployeeAdmin) {
                if (model.Status__c != ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()){
                    approve = getLatestHistoryOfRole(model, role);
                    if(approve != null){
                        model = addApprovalCurrentStatusFromHistory(model, approve);
                    }else{
                        model = addApprovalCurrentStatusDefault(model, role, pisUser);
                    }
                }
            }else {
                model = addApprovalCurrentStatusDefault(model, role, pisUser);
            }
        }else {
            model = addApprovalCurrentStatusFromHistory(model, approve);
        }
        return model;
    }
    
    @TestVisible
    private static ESS_Manpower__c addApprovalCurrentStatusByRoleForUser(ESS_Manpower__c model, ESS_Enum.ManpowerApproverRole role, User user)
    {
        //convert role to PEOC
        if (role == ESS_Enum.ManpowerApproverRole.AdminPMBP && model.Is_Admin_PEOC__c){
            role = ESS_Enum.ManpowerApproverRole.AdminPEOC;
        }
        
        ESS_Manpower_DTO.ApprovalHistoryDTO approve = getLatestHistoryOfRoleAfterLastSubmit(model, role);
        if(approve == null)
        {
            if (role == ESS_Enum.ManpowerApproverRole.EmployeeAdmin) {
                if (model.Status__c != ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name()){
                    approve = getLatestHistoryOfRole(model, role);
                    if(approve != null){
                        model = addApprovalCurrentStatusFromHistoryForUser(model, approve);
                    }else{
                        model = addApprovalCurrentStatusDefaultForUser(model, role, user);
                    }
                }
            }else {
                model = addApprovalCurrentStatusDefaultForUser(model, role, user);
            }
        }else {
            model = addApprovalCurrentStatusFromHistoryForUser(model, approve);
        }
        return model;
    }

    private static ESS_Manpower_DTO.ApprovalHistoryDTO getLatestHistoryOfRoleAfterLastSubmit(ESS_Manpower__c model, ESS_Enum.ManpowerApproverRole role)
    {
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> ApprovalHistories;
        if(string.isNotEmpty(model.Approval_History_JSON__c)) {
            ApprovalHistories = DeserializeApprovalHistoryJSON(model.Approval_History_JSON__c);
        }
        else {
            ApprovalHistories = new List<ESS_Manpower_DTO.ApprovalHistoryDTO>();
        }

        ESS_Manpower_DTO.ApprovalHistoryDTO latestSubmittedRecord = null;
        for (ESS_Manpower_DTO.ApprovalHistoryDTO record : ApprovalHistories) {
            if (record.approvalStatus.key == ESS_Enum.ManpowerApprovalStatus.Submitted.name()) {
                if (latestSubmittedRecord == null || record.actionDate > latestSubmittedRecord.actionDate) {
                    latestSubmittedRecord = record;
                }
            }
        }

        if (latestSubmittedRecord != null){
            List<ESS_Manpower_DTO.ApprovalHistoryDTO> NewApprovalHistories = new List<ESS_Manpower_DTO.ApprovalHistoryDTO>();
            for(ESS_Manpower_DTO.ApprovalHistoryDTO record : ApprovalHistories) {
                if(record.actionDate >= latestSubmittedRecord.actionDate) {
                    NewApprovalHistories.add(record);
                }
            }
            ApprovalHistories = NewApprovalHistories;
        }

        boolean hasLatestRecord = false;
        ESS_Manpower_DTO.ApprovalHistoryDTO latestRecord = new ESS_Manpower_DTO.ApprovalHistoryDTO();
        for(ESS_Manpower_DTO.ApprovalHistoryDTO record : ApprovalHistories) {
            if(record.approverRole.key == role.name()) {
                if(latestRecord.actionDate == null || record.actionDate > latestRecord.actionDate) {
                    latestRecord = record;
                    if (latestRecord.actionDate != null)
                    {
                        hasLatestRecord = true;
                    }
                }
            }
        }
        if(hasLatestRecord) {
            return latestRecord;
        }else{
            return null;
        }
    }

    private static ESS_Manpower_DTO.ApprovalHistoryDTO getLatestHistoryOfRole(ESS_Manpower__c model, ESS_Enum.ManpowerApproverRole role)
    {
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> ApprovalHistories;
        if(string.isNotEmpty(model.Approval_History_JSON__c)) {
            ApprovalHistories = DeserializeApprovalHistoryJSON(model.Approval_History_JSON__c);
        }
        else {
            ApprovalHistories = new List<ESS_Manpower_DTO.ApprovalHistoryDTO>();
        }

        boolean hasLatestRecord = false;
        ESS_Manpower_DTO.ApprovalHistoryDTO latestRecord = new ESS_Manpower_DTO.ApprovalHistoryDTO();
        for(ESS_Manpower_DTO.ApprovalHistoryDTO record : ApprovalHistories) {
            if(record.approverRole.key == role.name()) {
                if(latestRecord.actionDate == null || record.actionDate > latestRecord.actionDate) {
                    latestRecord = record;
                    if (latestRecord.actionDate != null)
                    {
                        hasLatestRecord = true;
                    }
                }
            }
        }
        if(hasLatestRecord) {
            return latestRecord;
        }else{
            return null;
        }
    }

    private static ESS_Manpower__c addApprovalCurrentStatusDefault(ESS_Manpower__c model, ESS_Enum.ManpowerApproverRole role, PISUsers__c pisUser)
    {
        model = addApprovalCurrentStatus(model, null, ESS_Enum.ManpowerApprovalStatus.Pending, role, pisUser, '');
        return model;
    }
    
    @TestVisible
    private static ESS_Manpower__c addApprovalCurrentStatusDefaultForUser(ESS_Manpower__c model, ESS_Enum.ManpowerApproverRole role, User user)
    {
        model = addApprovalCurrentStatusForUser(model, null, ESS_Enum.ManpowerApprovalStatus.Pending, role, user, '');
        return model;
    }

    private static ESS_Manpower__c addApprovalCurrentStatusFromHistory(ESS_Manpower__c model, ESS_Manpower_DTO.ApprovalHistoryDTO approve)
    {
        ESS_Enum.ManpowerApprovalStatus status = ESS_Enum.ManpowerApprovalStatus.valueOf(approve.approvalStatus.key);
        ESS_Enum.ManpowerApproverRole role = ESS_Enum.ManpowerApproverRole.valueOf(approve.approverRole.key);
        PISUsers__c pisUser = ESS_Global.assignToPISUser(approve.userId);
        model = addApprovalCurrentStatus(model, approve.actionDate, status, role, pisUser, approve.comment);
        return model;
    }
    
    @TestVisible
    private static ESS_Manpower__c addApprovalCurrentStatusFromHistoryForUser(ESS_Manpower__c model, ESS_Manpower_DTO.ApprovalHistoryDTO approve)
    {
        ESS_Enum.ManpowerApprovalStatus status = ESS_Enum.ManpowerApprovalStatus.valueOf(approve.approvalStatus.key);
        ESS_Enum.ManpowerApproverRole role = ESS_Enum.ManpowerApproverRole.valueOf(approve.approverRole.key);
        User user = ESS_Global.assignToUser(approve.userId);
        model = addApprovalCurrentStatusForUser(model, approve.actionDate, status, role, user, approve.comment);
        return model;
    }

    private static ESS_Manpower__c addApprovalCurrentStatus(ESS_Manpower__c model, datetime actionDate, ESS_Enum.ManpowerApprovalStatus status, ESS_Enum.ManpowerApproverRole role, PISUsers__c pisUser, string comment)
    {
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> ApprovalHistories;
        if(string.isNotEmpty(model.Current_Status_JSON__c)) {
            ApprovalHistories = DeserializeApprovalHistoryJSON(model.Current_Status_JSON__c);
        }
        else {
            ApprovalHistories = new List<ESS_Manpower_DTO.ApprovalHistoryDTO>();
        }
            
        ESS_Manpower_DTO.ApprovalHistoryDTO approve = new ESS_Manpower_DTO.ApprovalHistoryDTO();
        if (pisUser != null)
        {
            approve.userId = pisUser.User__c;
            approve.employeeName = pisUser.EN_Fullname__c;
            approve.position = pisUser.OBJENFULLNAME__c;
        }
        
        approve.actionDate = actionDate;
        approve.approvalStatus = new ESS_Global.EnumValue('ManpowerApprovalStatus');
        approve.approvalStatus.key = status.name();
        approve.approvalStatus.value = getManpowerApproverStatusLabel(status);
        approve.approverRole = new ESS_Global.EnumValue('ManpowerApproverRole');
        approve.approverRole.key = role.name();
        approve.approverRole.value = getManpowerApproverRoleLabel(role);
        approve.comment = comment;
        
        ApprovalHistories.add(approve);
        
        model.Current_Status_JSON__c = JSON.serialize(ApprovalHistories);

        return model;
    }

    @TestVisible
    private static ESS_Manpower__c addApprovalCurrentStatusForUser(ESS_Manpower__c model, datetime actionDate, ESS_Enum.ManpowerApprovalStatus status, ESS_Enum.ManpowerApproverRole role, User user, string comment)
    {
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> ApprovalHistories;
        if(string.isNotEmpty(model.Current_Status_JSON__c)) {
            ApprovalHistories = DeserializeApprovalHistoryJSON(model.Current_Status_JSON__c);
        }
        else {
            ApprovalHistories = new List<ESS_Manpower_DTO.ApprovalHistoryDTO>();
        }
            
        ESS_Manpower_DTO.ApprovalHistoryDTO approve = new ESS_Manpower_DTO.ApprovalHistoryDTO();
        if (user != null)
        {
            approve.userId = user.Id;
            approve.employeeName = user.FirstName_EN__c + ' ' + user.LastName_EN__c;
            approve.position = user.Position__c;
        }
        
        approve.actionDate = actionDate;
        approve.approvalStatus = new ESS_Global.EnumValue('ManpowerApprovalStatus');
        approve.approvalStatus.key = status.name();
        approve.approvalStatus.value = getManpowerApproverStatusLabel(status);
        approve.approverRole = new ESS_Global.EnumValue('ManpowerApproverRole');
        approve.approverRole.key = role.name();
        approve.approverRole.value = getManpowerApproverRoleLabel(role);
        approve.comment = comment;
        
        ApprovalHistories.add(approve);
        
        model.Current_Status_JSON__c = JSON.serialize(ApprovalHistories);

        return model;
    }

    private static ESS_Manpower__c addApprovalHistory(ESS_Manpower__c model, ESS_Enum.ManpowerApprovalStatus status, ESS_Enum.ManpowerApproverRole role, PISUsers__c pisUser)
    {
        model = addApprovalHistory(model, status, role, pisUser, '');

        return model;
    }

    private static ESS_Manpower__c addApprovalHistory(ESS_Manpower__c model, ESS_Enum.ManpowerApprovalStatus status, ESS_Enum.ManpowerApproverRole role, PISUsers__c pisUser, string comment)
    {
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> ApprovalHistories;
        if(string.isNotEmpty(model.Approval_History_JSON__c)) {
            ApprovalHistories = DeserializeApprovalHistoryJSON(model.Approval_History_JSON__c);
        }
        else {
            ApprovalHistories = new List<ESS_Manpower_DTO.ApprovalHistoryDTO>();
        }
            
        ESS_Manpower_DTO.ApprovalHistoryDTO approve = new ESS_Manpower_DTO.ApprovalHistoryDTO();
        approve.userId = pisUser.User__c;
        approve.employeeName = pisUser.EN_Fullname__c;
        approve.position = pisUser.OBJENFULLNAME__c;
        approve.actionDate = system.datetime.now();
        approve.approvalStatus = new ESS_Global.EnumValue('ManpowerApprovalStatus');
        approve.approvalStatus.key = status.name();
        approve.approvalStatus.value = getManpowerApproverStatusLabel(status);
        approve.approverRole = new ESS_Global.EnumValue('ManpowerApproverRole');
        approve.approverRole.key = role.name();
        approve.approverRole.value = getManpowerApproverRoleLabel(role);
        approve.comment = comment;
        
        ApprovalHistories.add(approve);
        
        model.Approval_History_JSON__c = JSON.serialize(ApprovalHistories);

        return model;
    }
	
    @TestVisible
    private static ESS_Manpower__c addApprovalHistoryForUser(ESS_Manpower__c model, ESS_Enum.ManpowerApprovalStatus status, ESS_Enum.ManpowerApproverRole role, User user)
    {
        model = addApprovalHistoryForUser(model, status, role, user, '');

        return model;
    }
    
    @TestVisible
    private static ESS_Manpower__c addApprovalHistoryForUser(ESS_Manpower__c model, ESS_Enum.ManpowerApprovalStatus status, ESS_Enum.ManpowerApproverRole role, User user, string comment)
    {
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> ApprovalHistories;
        if(string.isNotEmpty(model.Approval_History_JSON__c)) {
            ApprovalHistories = DeserializeApprovalHistoryJSON(model.Approval_History_JSON__c);
        }
        else {
            ApprovalHistories = new List<ESS_Manpower_DTO.ApprovalHistoryDTO>();
        }
            
        ESS_Manpower_DTO.ApprovalHistoryDTO approve = new ESS_Manpower_DTO.ApprovalHistoryDTO();
        approve.userId = user.Id;
        approve.employeeName = user.FirstName_EN__c + ' ' + user.LastName_EN__c;
        approve.position = user.Position__c;
        approve.actionDate = system.datetime.now();
        approve.approvalStatus = new ESS_Global.EnumValue('ManpowerApprovalStatus');
        approve.approvalStatus.key = status.name();
        approve.approvalStatus.value = getManpowerApproverStatusLabel(status);
        approve.approverRole = new ESS_Global.EnumValue('ManpowerApproverRole');
        approve.approverRole.key = role.name();
        approve.approverRole.value = getManpowerApproverRoleLabel(role);
        approve.comment = comment;
        
        ApprovalHistories.add(approve);
        
        model.Approval_History_JSON__c = JSON.serialize(ApprovalHistories);

        return model;
    }
    
    public static ESS_Manpower__c queryManpowerById(string manpowerId){
            ESS_Manpower__c Manpower = new ESS_Manpower__c();
        	string query = 'SELECT Approval_History_JSON__c,Cancelled_By_Id__c,Cancelled_By__c,Cancelled_Date__c,Comment__c,Completed_Date__c, ' + 
                			'Cost_Center__c,CreatedDate,Current_Status_JSON__c,Date_of_Commencement__c,Date_of_Completion__c,Department__c,Document_No__c,Function__c, ' + 
                			'G_L_Account__c,Id,Internal_Order_WBS__c,Is_Admin_PEOC__c,JE_Score__c,Job_Detail__c,Job_Id__c,Job__c,Name,No_of_Contractor_required__c,Objective__c, ' + 
                			'On_Behalf_Of_Department__c,On_Behalf_Of_Email__c,On_Behalf_Of_Employee_Id__c,On_Behalf_Of_Flow__c,On_Behalf_Of_Function__c,On_Behalf_Of_Id__c, ' +
                			'On_Behalf_Of_Position__c,On_Behalf_Of_Section__c,On_Behalf_Of_Unit__c,On_Behalf_Of__c,Output_Required__c,OwnerId,Physical_Requirement__c,Project_Id__c, ' + 
                			'Project_Manager_Approved_Date__c,Project_Manager_Flow__c,Project_Manager_Id__c,Project_Manager_Section_Head_Up__c,Project_Manager__c,Project__c,Qualification__c, ' + 
                			'Reference_Document_No__c,Requester_Department__c,Requester_Email__c,Requester_Employee_Id__c,Requester_Function__c,Requester_Id__c,Requester_Name__c, ' + 
                			'Requester_Position__c,Requester_Section__c,Requester_Tel_Office__c,Requester_Tel_Mobile__c,Requester_Unit__c,Scope_of_Service_ID__c,Section_Head_Approved_Date__c,Section_Head_Flow__c, ' + 
                			'Section_Head_Id__c,Section_Head__c,Section__c,Service_For__c,Status__c,Submitted_Date__c,Type_of_Service__c,Unit__c,VP_Approved_Date__c,VP_Flow__c,VP_Id__c, ' + 
                			'Workflow_Type__c,Working_Day__c,Work_Location__c, Is_PRTR__c, isNew__c, VP__c FROM ESS_Manpower__c where Id =: manpowerId';
            
            Manpower = Database.query(query);

            return Manpower;
    }

    //Assign Model by using DTO
    private static ESS_Manpower__c assignToManpowerModel(ESS_Manpower__c model, ESS_Manpower_DTO.ManpowerDetailDTO dto)
    {
        model.On_Behalf_Of_Flow__c = dto.onBehalfFlow;
        if(string.isNotEmpty(dto.serviceFor) && dto.serviceFor.contains(',')) {
            string serviceFor = dto.serviceFor.replace(',', ';');
            model.Service_For__c = serviceFor;
        }
        else {
            model.Service_For__c = dto.serviceFor;
        }
        
        model.G_L_Account__c = dto.glAccount;
        model.Cost_Center__c = dto.costCenter;
        model.Internal_Order_WBS__c = dto.internalOrderWBS;
        
        if(dto.typeOfService != null) {
            if(dto.typeOfService.key.toLowerCase() == 'all') {
                throw new ESS_Exception('[MyError]Please select \'Type of Service\'');
            }
            else {
                model.Type_of_Service__c = dto.typeOfService.key;
            }
        }
        
        if(dto.objective != null) {
            model.Objective__c = dto.objective.key;
        }
        
        model.No_of_Contractor_required__c = dto.noOfContractorRequired;
        
        if(string.isNotBlank(dto.jobTitleId)) {
            model.Job_Id__c = dto.jobTitleId;
            model.Job__c = dto.jobTitleName;
        }
        
        model.Date_of_Commencement__c = dto.commencementDate;
        model.Unit__c = dto.unit;
        model.Section__c = dto.section;
        model.Department__c = dto.department;
        model.Function__c = dto.function;
        
        if(dto.workLocation != null) {
            model.Work_Location__c = dto.workLocation.key;
        }
        
        model.JE_Score__c = dto.jeScore;
        model.Comment__c = dto.comment;
        model.Reference_Document_No__c = dto.referenceDocumentNo;
        model.Job_Id__c = dto.jobTitleId;
        model.Job__c = dto.jobTitleName;
        model.Scope_of_Service_ID__c = dto.scopeOfServiceID;
        model.Output_Required__c = dto.outputRequired;
        model.Job_Detail__c = dto.jobDetail;
        model.Qualification__c = dto.qualification;
        model.Physical_Requirement__c = dto.physicalRequirement;
        
        model.Date_of_Completion__c = dto.completionDate;
        model.Working_Day__c = dto.workingDay;
        
        //Project Base
        model.Project__c = dto.projectName;
        model.Project_Id__c = dto.projectId;
        model.Project_Manager__c = dto.projectManagerName;
        model.Project_Manager_Id__c = dto.projectManagerId;
        
        //Flow Self
        model.Requester_Id__c = dto.requesterId;
        model.Requester_Employee_Id__c = dto.requesterEmployeeId;
        model.Requester_Name__c = dto.requesterEmployeeName;
        model.Requester_Email__c = dto.requesterEmail;
        model.Requester_Position__c = dto.requesterPosition;
        model.Requester_Unit__c = dto.requesterUnit;
        model.Requester_Section__c = dto.requesterSection;
        model.Requester_Department__c = dto.requesterDepartment;
        model.Requester_Function__c = dto.requesterFunction;
        
        //Flow On Behalf Of
        if(dto.onBehalfFlow) {
            
            model.Requester_Tel_Office__c = dto.requesterTelOffice;
            model.Requester_Tel_Mobile__c = dto.requesterTelMobile;
            
            model.On_Behalf_Of_Id__c = dto.onBehalfOfId;
            model.On_Behalf_Of_Employee_Id__c = dto.onBehalfOfEmployeeId;
            model.On_Behalf_Of__c = dto.onBehalfOfEmployeeName;
            model.On_Behalf_Of_Email__c = dto.onBehalfOfEmail;
            model.On_Behalf_Of_Position__c = dto.onBehalfOfPosition;
            model.On_Behalf_Of_Unit__c = dto.onBehalfOfUnit;
            model.On_Behalf_Of_Section__c = dto.onBehalfOfSection;
            model.On_Behalf_Of_Department__c = dto.onBehalfOfDepartment;
            model.On_Behalf_Of_Function__c = dto.onBehalfOfFunction;
        }
        else {
            model.On_Behalf_Of_Id__c = '';
            model.On_Behalf_Of_Employee_Id__c = '';
            model.On_Behalf_Of__c = '';
            model.On_Behalf_Of_Email__c = '';
            model.On_Behalf_Of_Position__c = '';
            model.On_Behalf_Of_Unit__c = '';
            model.On_Behalf_Of_Section__c = '';
            model.On_Behalf_Of_Department__c = '';
            model.On_Behalf_Of_Function__c = '';
        }

        return model;
    }
    
    //Assign to DTO
    @TestVisible
    private static ESS_Manpower_DTO.ManpowerTableDTO assignToManpowerTableDTO(ESS_Manpower__c Manpower) {
    
        ESS_Manpower_DTO.ManpowerTableDTO ManpowerTable = new ESS_Manpower_DTO.ManpowerTableDTO();
        
        ManpowerTable.recordId = Manpower.Id;
        ManpowerTable.documentNo = Manpower.Document_No__c;
        ManpowerTable.isNew = Manpower.isNew__c;
        
        ManpowerTable.typeOfService = new ESS_Global.EnumValue('ManpowerTypeOfService');
        if(Manpower.Type_of_Service__c == String.ValueOf(ESS_Enum.ManpowerTypeOfService.Permanent)) {
            ManpowerTable.typeOfService.key = ESS_Enum.ManpowerTypeOfService.Permanent.name();
            ManpowerTable.typeOfService.value = 'Permanent';
        }
        else if(Manpower.Type_of_Service__c == String.ValueOf(ESS_Enum.ManpowerTypeOfService.Temporary)) {
            ManpowerTable.typeOfService.key = ESS_Enum.ManpowerTypeOfService.Temporary.name();
            ManpowerTable.typeOfService.value = 'Temporary';
        }
        else if(Manpower.Type_of_Service__c == String.ValueOf(ESS_Enum.ManpowerTypeOfService.ProjectBase)) {
            ManpowerTable.typeOfService.key = ESS_Enum.ManpowerTypeOfService.ProjectBase.name();
            ManpowerTable.typeOfService.value = 'ProjectBase';
        }
        
        ManpowerTable.objective = new ESS_Global.EnumValue('ManpowerObjective');
        if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.ReplaceOldPosition)) {
            ManpowerTable.objective.key = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
            ManpowerTable.objective.value = 'ทดแทนตำแหน่งงานเดิม';
        }
        else if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.AddOldPosition)) {
            ManpowerTable.objective.key = ESS_Enum.ManpowerObjective.AddOldPosition.name();
            ManpowerTable.objective.value = 'เพิ่มจำนวนในตำแหน่งงานเดิม';
        }
        else if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.AddNewPosition)) {
            ManpowerTable.objective.key = ESS_Enum.ManpowerObjective.AddNewPosition.name();
            ManpowerTable.objective.value = 'เพิ่มในตำแหน่งใหม่';
        }
        else if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.KHReview)) {
            ManpowerTable.objective.key = ESS_Enum.ManpowerObjective.KHReview.name();
            ManpowerTable.objective.value = 'เปลี่ยนแปลงขอบข่ายงาน (KH Review)';
        }
        else if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.ExtendFirstContract)) {
            ManpowerTable.objective.key = ESS_Enum.ManpowerObjective.ExtendFirstContract.name();
            ManpowerTable.objective.value = 'ต่อสัญญาครั้งที่ 1';
        }
        
        ManpowerTable.jobTitle = Manpower.Job__c;
        
        ManpowerTable.status = new ESS_Global.EnumValue('ManpowerStatus');
        if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Draft)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.Draft.name();
            ManpowerTable.status.value = 'Draft';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
            ManpowerTable.status.value = 'Waiting to Employee approved';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToSectionHead)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            ManpowerTable.status.value = 'Waiting to Section Head';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToVP)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.WaitingToVP.name();
            ManpowerTable.status.value = 'Waiting to VP';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToProjectManager)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.WaitingToProjectManager.name();
            ManpowerTable.status.value = 'Waiting to Project Manager';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAcknowledge)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
            ManpowerTable.status.value = 'Waiting to Acknowledge';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Completed)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.Completed.name();
            ManpowerTable.status.value = 'Completed';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
            ManpowerTable.status.value = 'Waiting to Employee Revise';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
            ManpowerTable.status.value = 'Waiting to Admin Employee Revise';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Cancelled)) {
            ManpowerTable.status.key = ESS_Enum.ManpowerStatus.Cancelled.name();
            ManpowerTable.status.value = 'Cancelled';
        }
        
        if(Manpower.CreatedDate != null) {
            ManpowerTable.createdDate = Manpower.CreatedDate.date();
        }
        ManpowerTable.submittedDate = Manpower.Submitted_Date__c;
        ManpowerTable.requesterName = Manpower.Requester_Name__c;
        ManpowerTable.onBehalfOfName = Manpower.On_Behalf_Of__c;
        ManpowerTable.section = Manpower.Section__c;
        if(Manpower.On_Behalf_Of_Flow__c) {
            ManpowerTable.section = Manpower.On_Behalf_Of_Section__c;
        }
        ManpowerTable.canDelete = checkCanDelete(ManpowerTable.status.key);
        
        return ManpowerTable;
    
    }
    
    private static ESS_Manpower_DTO.ManpowerDetailDTO assignToManpowerDetailDTO(ESS_Manpower__c Manpower) {
    
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdminPMBP = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isAdminPEOC = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
        
        ESS_Manpower_DTO.ManpowerDetailDTO ManpowerDetail = new ESS_Manpower_DTO.ManpowerDetailDTO();
        
        manpowerDetail.recordId = Manpower.Id;
        manpowerDetail.documentNo = Manpower.Document_No__c;
        manpowerDetail.isNew = Manpower.isNew__c;
        
        if(string.isNotEmpty(Manpower.Service_For__c) && Manpower.Service_For__c.contains(';')) {
            string serviceFor = Manpower.Service_For__c.replace(';',',');
            manpowerDetail.serviceFor = serviceFor;
        }
        else {
            manpowerDetail.serviceFor = Manpower.Service_For__c;
        }
        
        manpowerDetail.onBehalfFlow = Manpower.On_Behalf_Of_Flow__c;
        manpowerDetail.glAccount = Manpower.G_L_Account__c;
        manpowerDetail.costCenter = Manpower.Cost_Center__c;
        manpowerDetail.internalOrderWBS = Manpower.Internal_Order_WBS__c;
        manpowerDetail.noOfContractorRequired = Integer.ValueOf(Manpower.No_of_Contractor_required__c);
        
        manpowerDetail.commencementDate = Manpower.Date_of_Commencement__c;
        manpowerDetail.unit = Manpower.Unit__c;
        manpowerDetail.section = Manpower.Section__c;
        manpowerDetail.department = Manpower.Department__c;
        manpowerDetail.function = Manpower.Function__c;
        
        manpowerDetail.workLocation = new ESS_Global.EnumValue('ManpowerWorkLocation');
        if(Manpower.Work_Location__c == String.ValueOf(ESS_Enum.ManpowerWorkLocation.Bangkok)) {
            manpowerDetail.workLocation.key = ESS_Enum.ManpowerWorkLocation.Bangkok.name();
            manpowerDetail.workLocation.value = 'กรุงเทพ';
        }
        else if(Manpower.Work_Location__c == String.ValueOf(ESS_Enum.ManpowerWorkLocation.Sriracha)) {
            manpowerDetail.workLocation.key = ESS_Enum.ManpowerWorkLocation.Sriracha.name();
            manpowerDetail.workLocation.value = 'ศรีราชา';
        }
        
        manpowerDetail.typeOfService = new ESS_Global.EnumValue('ManpowerTypeOfService');
        if(Manpower.Type_of_Service__c == String.ValueOf(ESS_Enum.ManpowerTypeOfService.Permanent)) {
            manpowerDetail.typeOfService.key = ESS_Enum.ManpowerTypeOfService.Permanent.name();
            manpowerDetail.typeOfService.value = 'Permanent';
        }
        else if(Manpower.Type_of_Service__c == String.ValueOf(ESS_Enum.ManpowerTypeOfService.Temporary)) {
            manpowerDetail.typeOfService.key = ESS_Enum.ManpowerTypeOfService.Temporary.name();
            manpowerDetail.typeOfService.value = 'Temporary';
        }
        else if(Manpower.Type_of_Service__c == String.ValueOf(ESS_Enum.ManpowerTypeOfService.ProjectBase)) {
            manpowerDetail.typeOfService.key = ESS_Enum.ManpowerTypeOfService.ProjectBase.name();
            manpowerDetail.typeOfService.value = 'ProjectBase';
        }
        
        manpowerDetail.objective = new ESS_Global.EnumValue('ManpowerObjective');
        if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.ReplaceOldPosition)) {
            manpowerDetail.objective.key = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
            manpowerDetail.objective.value = 'ทดแทนตำแหน่งงานเดิม';
        }
        else if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.AddOldPosition)) {
            manpowerDetail.objective.key = ESS_Enum.ManpowerObjective.AddOldPosition.name();
            manpowerDetail.objective.value = 'เพิ่มจำนวนในตำแหน่งงานเดิม';
        }
        else if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.AddNewPosition)) {
            manpowerDetail.objective.key = ESS_Enum.ManpowerObjective.AddNewPosition.name();
            manpowerDetail.objective.value = 'เพิ่มในตำแหน่งใหม่';
        }
        else if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.KHReview)) {
            manpowerDetail.objective.key = ESS_Enum.ManpowerObjective.KHReview.name();
            manpowerDetail.objective.value = 'เปลี่ยนแปลงขอบข่ายงาน (KH Review)';
        }
        else if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.ExtendFirstContract)) {
            manpowerDetail.objective.key = ESS_Enum.ManpowerObjective.ExtendFirstContract.name();
            manpowerDetail.objective.value = 'ต่อสัญญาครั้งที่ 1';
        }
        
        manpowerDetail.referenceDocumentNo = Manpower.Reference_Document_No__c;
		manpowerDetail.jobTitleId = Manpower.Job_Id__c;
        manpowerDetail.jobTitleName = Manpower.Job__c;
        manpowerDetail.scopeOfServiceID = Manpower.Scope_of_Service_ID__c;
        manpowerDetail.outputRequired = Manpower.Output_Required__c;
        manpowerDetail.jobDetail = Manpower.Job_Detail__c;
        manpowerDetail.qualification = Manpower.Qualification__c;
        manpowerDetail.physicalRequirement = Manpower.Physical_Requirement__c;
        
        manpowerDetail.status = new ESS_Global.EnumValue('ManpowerStatus');
        if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Draft)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.Draft.name();
            manpowerDetail.status.value = 'Draft';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
            manpowerDetail.status.value = 'Waiting to Employee approved';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToSectionHead)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            manpowerDetail.status.value = 'Waiting to Section Head';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToVP)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.WaitingToVP.name();
            manpowerDetail.status.value = 'Waiting to VP';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToProjectManager)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.WaitingToProjectManager.name();
            manpowerDetail.status.value = 'Waiting to Project Manager';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAcknowledge)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
            manpowerDetail.status.value = 'Waiting to Acknowledge';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Completed)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.Completed.name();
            manpowerDetail.status.value = 'Completed';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
            manpowerDetail.status.value = 'Waiting to Employee Revise';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
            manpowerDetail.status.value = 'Waiting to Admin Employee Revise';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Cancelled)) {
            manpowerDetail.status.key = ESS_Enum.ManpowerStatus.Cancelled.name();
            manpowerDetail.status.value = 'Cancelled';
        }

		manpowerDetail.jeScore = Manpower.JE_Score__c;
        manpowerDetail.comment = Manpower.Comment__c;
        
        manpowerDetail.isShowJDSection = false;
        if((isAdminPMBP || (isAdminPEOC && Manpower.Is_Admin_PEOC__c) && Manpower.Status__c == ESS_Enum.ManpowerStatus.Completed.name())) {
        	manpowerDetail.isShowJDSection = true;    
        }
        
        manpowerDetail.isShowDefaultJEScore = false;
        if(Manpower.Objective__c == ESS_Enum.ManpowerObjective.ReplaceOldPosition.name() || 
          	Manpower.Objective__c == ESS_Enum.ManpowerObjective.AddOldPosition.name() ||
          	Manpower.Objective__c == ESS_Enum.ManpowerObjective.ExtendFirstContract.name()) {
        	manpowerDetail.isShowDefaultJEScore = true;    
        }
        
        //Date
        if(Manpower.CreatedDate != null) {
            manpowerDetail.createdDate = Manpower.CreatedDate.date();
        }
        manpowerDetail.submittedDate = Manpower.Submitted_Date__c;
        manpowerDetail.sectionHeadApprovedDate = Manpower.Section_Head_Approved_Date__c;
        manpowerDetail.completedDate = Manpower.Completed_Date__c;
        manpowerDetail.cancelledDate = Manpower.Cancelled_Date__c;
        
        //Requester
        manpowerDetail.requesterId = Manpower.Requester_Id__c;
        manpowerDetail.requesterEmployeeId = Manpower.Requester_Employee_Id__c;
        manpowerDetail.requesterEmployeeName = Manpower.Requester_Name__c;
        manpowerDetail.requesterEmail = Manpower.Requester_Email__c;
        manpowerDetail.requesterPosition = Manpower.Requester_Position__c;
        manpowerDetail.requesterUnit = Manpower.Requester_Unit__c;
        manpowerDetail.requesterSection = Manpower.Requester_Section__c;
        manpowerDetail.requesterDepartment = Manpower.Requester_Department__c;
        manpowerDetail.requesterFunction = Manpower.Requester_Function__c;
        manpowerDetail.requesterTelOffice = Manpower.Requester_Tel_Office__c;
        manpowerDetail.requesterTelMobile = Manpower.Requester_Tel_Mobile__c;
        
        //OnBehalfOf
        manpowerDetail.onBehalfOfId = Manpower.On_Behalf_Of_Id__c;
        manpowerDetail.onBehalfOfEmployeeId = Manpower.On_Behalf_Of_Employee_Id__c;
        manpowerDetail.onBehalfOfEmployeeName = Manpower.On_Behalf_Of__c;
        manpowerDetail.onBehalfOfEmail = Manpower.On_Behalf_Of_Email__c;
        manpowerDetail.onBehalfOfPosition = Manpower.On_Behalf_Of_Position__c;
        manpowerDetail.onBehalfOfUnit = Manpower.On_Behalf_Of_Unit__c;
        manpowerDetail.onBehalfOfSection = Manpower.On_Behalf_Of_Section__c;
        manpowerDetail.onBehalfOfDepartment = Manpower.On_Behalf_Of_Department__c;
        manpowerDetail.onBehalfOfFunction = Manpower.On_Behalf_Of_Function__c;

        //Project
        manpowerDetail.projectName = Manpower.Project__c;
        manpowerDetail.projectId = Manpower.Project_Id__c;
        manpowerDetail.projectManagerName = Manpower.Project_Manager__c;
        manpowerDetail.projectManagerId = Manpower.Project_Manager_Id__c;
        manpowerDetail.completionDate = Manpower.Date_of_Completion__c;
        manpowerDetail.workingDay = Manpower.Working_Day__c;
        
        //SectionHead
        manpowerDetail.sectionHeadId = Manpower.Section_Head_Id__c;
        manpowerDetail.sectionHeadName = Manpower.Section_Head__c;
        
        //Get UserRole
        string userRole = getUserRole(userId, Manpower);
        
        //Flag
        manpowerDetail.canEditManpower = checkCanEditManpower(Manpower, userId);
        manpowerDetail.canEditJobDetail = checkCanEditJobDetail(manpowerDetail.typeOfService.key, manpowerDetail.objective.key);
        manpowerDetail.canSave = checkCanSave(Manpower, userId);
        manpowerDetail.canSubmit = checkCanSubmit(Manpower, userId);
        manpowerDetail.canApprove = checkCanApprove(Manpower, userId);
        manpowerDetail.canReject = checkCanReject(Manpower, userId);
        manpowerDetail.canCancelRequest = checkCanCancelRequest(Manpower, userId);
        manpowerDetail.canAcknowledge = checkCanAcknowledge(Manpower, userId);
        
        return manpowerDetail;
    
    }
    
    //TODO: Change param to Manpower DTO and userId
    @TestVisible
    private static boolean checkCanEditManpower(ESS_Manpower__c model, string userId) {
        
        boolean editManPower = checkCanSave(model, userId);
        return editManPower;
    }
    
    @TestVisible
    private static boolean checkCanEditJobDetail(string typeOfService, string objective) {
        
        boolean editJobDetail = false;
        
        //Permanent
        if(typeOfService == ESS_Enum.ManpowerTypeOfService.Permanent.name() && 
           objective == ESS_Enum.ManpowerObjective.ReplaceOldPosition.name()) {
            editJobDetail = false;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.Permanent.name() && 
           objective == ESS_Enum.ManpowerObjective.AddOldPosition.name()) {
            editJobDetail = false;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.Permanent.name() && 
           objective == ESS_Enum.ManpowerObjective.AddNewPosition.name()) {
            editJobDetail = true;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.Permanent.name() && 
           objective == ESS_Enum.ManpowerObjective.KHReview.name()) {
            editJobDetail = true;
        }
        //Temporary
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.Temporary.name() && 
           objective == ESS_Enum.ManpowerObjective.ReplaceOldPosition.name()) {
            editJobDetail = false;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.Temporary.name() && 
           objective == ESS_Enum.ManpowerObjective.AddOldPosition.name()) {
            editJobDetail = false;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.Temporary.name() && 
           objective == ESS_Enum.ManpowerObjective.AddNewPosition.name()) {
            editJobDetail = true;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.Temporary.name() && 
           objective == ESS_Enum.ManpowerObjective.KHReview.name()) {
            editJobDetail = true;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.Temporary.name() && 
           objective == ESS_Enum.ManpowerObjective.ExtendFirstContract.name()) {
            editJobDetail = false;
        }
        //ProjectBase
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.ProjectBase.name() && 
           objective == ESS_Enum.ManpowerObjective.ReplaceOldPosition.name()) {
            editJobDetail = false;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.ProjectBase.name() && 
           objective == ESS_Enum.ManpowerObjective.AddOldPosition.name()) {
            editJobDetail = false;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.ProjectBase.name() && 
           objective == ESS_Enum.ManpowerObjective.AddNewPosition.name()) {
            editJobDetail = true;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.ProjectBase.name() && 
           objective == ESS_Enum.ManpowerObjective.KHReview.name()) {
            editJobDetail = true;
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.ProjectBase.name() && 
           objective == ESS_Enum.ManpowerObjective.ExtendFirstContract.name()) {
            editJobDetail = false;
        }
        
        return editJobDetail;
    }
    
    @TestVisible
    private static boolean checkCanSave(ESS_Manpower__c model, string userId) {
        
        boolean canSave = false;
        if(model.Status__c == ESS_Enum.ManpowerStatus.Draft.name() || 
            model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name())
        {
            canSave = model.Requester_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name())
        {
            if(model.On_Behalf_Of_Flow__c)
            {
                canSave = model.On_Behalf_Of_Id__c == userId;
            }
            else {
                canSave = model.Requester_Id__c == userId;
            }
        }
        return canSave;
    }
    
    @TestVisible
    private static boolean checkCanSubmit(ESS_Manpower__c model, string userId) {
        
        boolean canSubmit = checkCanSave(model, userId);
        return canSubmit;
    }
    
    @TestVisible
    private static boolean checkCanApprove(ESS_Manpower__c model, string userId) {
        
        boolean canApprove = false;
        if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name())
        {
            if(model.On_Behalf_Of_Flow__c)
            {
                canApprove = model.On_Behalf_Of_Id__c == userId;
            }
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name())
        {
            canApprove = model.Section_Head_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name())
        {
            canApprove = model.VP_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name())
        {
            canApprove = model.Project_Manager_Id__c == userId;
        }
        return canApprove;
    }
    
    @TestVisible
    private static boolean checkCanReject(ESS_Manpower__c model, string userId) {
        
        boolean canReject = false;
        if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name())
        {
            if(model.On_Behalf_Of_Flow__c)
            {
                canReject = model.On_Behalf_Of_Id__c == userId;
            }
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name())
        {
            if(model.On_Behalf_Of_Flow__c)
            {
                canReject = model.On_Behalf_Of_Id__c == userId;
            }
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name())
        {
            canReject = model.Section_Head_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name())
        {
            canReject = model.VP_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name())
        {
            canReject = model.Project_Manager_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name())
        {
            canReject = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
            if(model.Is_Admin_PEOC__c && !canReject){
                canReject = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
            }
        }
        return canReject;
    }
    
    @TestVisible
    private static boolean checkCanDelete(string status) {
        
        boolean canDelete = false;
        
        if(status == ESS_Enum.ManpowerStatus.Draft.name()) {
            canDelete = true;
        }
        
        return canDelete;
    }
    
    @TestVisible
    private static boolean checkCanCancelRequest(ESS_Manpower__c model, string userId) {
        
        boolean canCancelRequest = false;
        if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name())
        {
            canCancelRequest = model.On_Behalf_Of_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToSectionHead.name())
        {
            canCancelRequest = model.Section_Head_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToVP.name())
        {
            canCancelRequest = model.VP_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToProjectManager.name())
        {
            canCancelRequest = model.Project_Manager_Id__c == userId;
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name())
        {
            if(model.On_Behalf_Of_Flow__c)
            {
                canCancelRequest = model.On_Behalf_Of_Id__c == userId;
            }
            else {
                canCancelRequest = model.Requester_Id__c == userId;
            }
        }
        else if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name())
        {
            canCancelRequest = model.Requester_Id__c == userId;
        }
        return canCancelRequest;
    }
    
    @TestVisible
    private static boolean checkCanAcknowledge(ESS_Manpower__c model, string userId) {
        
        boolean canAcknowledge = false;
        if(model.Status__c == ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name())
        {
            canAcknowledge = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
            if(model.Is_Admin_PEOC__c && !canAcknowledge){
                canAcknowledge = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
            }
        }
        return canAcknowledge;
    }
    
    private static string getUserRole(string userId, ESS_Manpower__c manpower) {
        
        string userRole = '';
        
        //Employee
        if(userId == manpower.OwnerId) {
            userRole = ESS_Enum.ManpowerApproverRole.Employee.name();
        }
        //Section Head
        if(userId == manpower.Section_Head_Id__c) {
            userRole = ESS_Enum.ManpowerApproverRole.SectionHead.name();
        }
        
        return userRole;
        
    }

    @TestVisible
    private static string getManpowerApproverStatusLabel(ESS_Enum.ManpowerApprovalStatus status)
    {
        if(status == ESS_Enum.ManpowerApprovalStatus.Submitted){
            return 'Submitted';
        }
        else if(status == ESS_Enum.ManpowerApprovalStatus.Approved){
            return 'Approved';
        }
        else if(status == ESS_Enum.ManpowerApprovalStatus.Rejected){
            return 'Rejected';
        }
        else if(status == ESS_Enum.ManpowerApprovalStatus.Cancelled){
            return 'Cancelled';
        }
        else if(status == ESS_Enum.ManpowerApprovalStatus.Acknowledged){
            return 'Acknowledged';
        }
        else if(status == ESS_Enum.ManpowerApprovalStatus.Pending){
            return 'Pending';
        }
        else if(status == ESS_Enum.ManpowerApprovalStatus.Blank){
            return 'Blank';
        }
        else if(status == ESS_Enum.ManpowerApprovalStatus.AutoApproved){
            return 'Auto Approved';
        }else {
            return '';
        }
    }

    @TestVisible
    private static string getManpowerApproverRoleLabel(ESS_Enum.ManpowerApproverRole role) {
        if(role == ESS_Enum.ManpowerApproverRole.Employee){
            return 'Employee';
        }
        else if(role == ESS_Enum.ManpowerApproverRole.EmployeeAdmin){
            return 'Employee Admin';
        }
        else if(role == ESS_Enum.ManpowerApproverRole.SectionHead){
            return 'Section Head';
        }
        else if(role == ESS_Enum.ManpowerApproverRole.VP){
            return 'VP';
        }
        else if(role == ESS_Enum.ManpowerApproverRole.AdminPMBP){
            return 'Admin PMBP';
        }
        else if(role == ESS_Enum.ManpowerApproverRole.ProjectManager){
            return 'Project Manager';
        }
        else if(role == ESS_Enum.ManpowerApproverRole.AdminPEOC){
            return 'Admin PEOC';
        }else {
            return '';
        }
    }
    
    private static List<ESS_Manpower_DTO.ApprovalHistoryDTO> DeserializeApprovalHistoryJSON(string approvalHistoryJSON) {
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> approvalHistories = (List<ESS_Manpower_DTO.ApprovalHistoryDTO>)JSON.deserialize(approvalHistoryJSON, List<ESS_Manpower_DTO.ApprovalHistoryDTO>.class);
        if(approvalHistories.size() > 0) {
            for(ESS_Manpower_DTO.ApprovalHistoryDTO ApprovalHistory : approvalHistories) {
                if(ApprovalHistory.approvalStatus.key == ESS_Enum.ManpowerApprovalStatus.Acknowledged.name()) {
                    ApprovalHistory.comment = '';
                }
            }
        }
        return approvalHistories;
    }
    
    private static List<ESS_Manpower_DTO.ApprovalHistoryDTO> DeserializeCurrentStatusJSON(string currentStatusJSON) {
        List<ESS_Manpower_DTO.ApprovalHistoryDTO> currentStatuses = (List<ESS_Manpower_DTO.ApprovalHistoryDTO>)JSON.deserialize(currentStatusJSON, List<ESS_Manpower_DTO.ApprovalHistoryDTO>.class);
        return currentStatuses;
    }
    
    @TestVisible
    private static boolean CheckExistJobTitleOnSubmit(string jobTitle, string section) {
        
        boolean checkJobTitle = false;
        List<ESS_LC1_Scope__c> Titles = [select id from ESS_LC1_Scope__c where job_title__c =: jobTitle AND section__c =: section AND Active__c = true];
        if(Titles.size() > 0) {
        	checkJobTitle = true;
        }
        return checkJobTitle;
    }
    
    @TestVisible
    private static boolean CheckCanSaveSubmitKHReview(ESS_Manpower_DTO.ManpowerDetailDTO manpower) {
        List<ESS_LC1_Scope__c> Scopes = [select id, job_title__c, name, unit__c, section__c, department__c, function__c, work_location__c,
                                  output_required__c, job_detail__c, qualification__c, physical_requirement__c from ESS_LC1_Scope__c where Id = :manpower.jobTitleId];
        
        if(Scopes.size() > 0) {
            if(manpower.jobTitleName != Scopes[0].Job_Title__c) { return true; }
            if(manpower.unit != Scopes[0].Unit__c) { return true; }
            if(manpower.section != Scopes[0].Section__c) { return true; }
            if(manpower.department != Scopes[0].Department__c) { return true; }
            if(manpower.function != Scopes[0].Function__c) { return true; }
            if(manpower.jobTitleName != Scopes[0].Job_Title__c) { return true; }
            if(manpower.workLocation.key != Scopes[0].Work_Location__c) { return true; }
            if(manpower.outputRequired != Scopes[0].Output_Required__c) { return true; }
            if(manpower.jobDetail != Scopes[0].Job_Detail__c) { return true; }
            if(manpower.qualification != Scopes[0].Qualification__c) { return true; }
            if(manpower.physicalRequirement != Scopes[0].Physical_Requirement__c) { return true; }
            return false;
        }
        return true;
    }
    
    @TestVisible
    private static void InactiveJobTitle(string jobTitleId) {
        ESS_LC1_Scope__c JobTitle = [select id, active__c from ESS_LC1_Scope__c where Id = :jobTitleId];
        JobTitle.Active__c = false;
        database.update(JobTitle, true);
    }
    
    @TestVisible
    private static void InsertNewJobTitle(ESS_Manpower__c model, string jeScore, string comment) {
        //Insert Job Title to Master
        ESS_LC1_Scope__c MasterJobTitle = new ESS_LC1_Scope__c();
        MasterJobTitle.Active__c = true;
        MasterJobTitle.job_title__c = model.Job__c;
        MasterJobTitle.Unit__c = model.Unit__c;
        MasterJobTitle.Section__c = model.Section__c;
        MasterJobTitle.Department__c = model.Department__c;
        MasterJobTitle.Function__c = model.Function__c;
        MasterJobTitle.Work_Location__c = model.Work_Location__c;
        MasterJobTitle.Output_Required__c = model.Output_Required__c;
        MasterJobTitle.Job_Detail__c = model.Job_Detail__c;
        MasterJobTitle.Qualification__c = model.Qualification__c;
        MasterJobTitle.Physical_Requirement__c = model.Physical_Requirement__c;
        MasterJobTitle.JE_Score__c = jeScore;
        MasterJobTitle.Comment__c = comment;
        database.insert(MasterJobTitle, true);
    }
    
    @RemoteAction
    public static List<string> GetStatuses() {
        
        List<string> statuses = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Manpower__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            statuses.add(objPickList.getLabel());
        }
        return statuses;
    }
    
    @RemoteAction
    public static List<string> GetTypeOfServices() {
        
        List<string> typeOfServices = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Manpower__c.Type_of_Service__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            typeOfServices.add(objPickList.getLabel());
        }
        return typeOfServices;
    }
    
    @RemoteAction
    public static List<string> GetObjectives() {
        
        List<string> objectives = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Manpower__c.Objective__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            objectives.add(objPickList.getLabel());
        }
        return objectives;
    }
    
    @RemoteAction
    public static List<string> GetWorkLocations() {
        
        List<string> workLocations = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_LC1_Scope__c.Work_Location__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            workLocations.add(objPickList.getLabel());
        }
        return workLocations;
    }
    
    @RemoteAction
    public static List<string> GetServiceFors() {
        
        List<string> serviceFors = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Manpower__c.Service_For__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            serviceFors.add(objPickList.getLabel());
        }
        return serviceFors;
    }
    
    @RemoteAction
    public static List<string> ESSGlobal_GetSections(string department) {
        List<string> Sections = ESS_Global.GetSections(department);
        return Sections;
    }
    
    public class SearchCriteria {
        @RemoteAction
        public string documentNo {get;set;}
        //enum ManpowerTypeOfService
        @RemoteAction
        public string typeOfService {get;set;}
        //enum ManpowerObjective
        @RemoteAction
        public string objective {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string jobTitle {get;set;}
        //enum ManpowerStatus
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public date startCreatedDate {get;set;}
        @RemoteAction
        public date endCreatedDate {get;set;}
        @RemoteAction
        public date startSubmittedDate {get;set;}
        @RemoteAction
        public date endSubmittedDate {get;set;}
        @RemoteAction
        public date startCompletedDate {get;set;}
        @RemoteAction
        public date endCompletedDate {get;set;}
        @RemoteAction
        public boolean onHandWork {get;set;}
    }
    
}