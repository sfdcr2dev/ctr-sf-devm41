/* Author Softever */
global with sharing class ESS_EmployeeBasic {

    private static string userId = ESS_PrivilegeHandler.getUserId();
    private static boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
    private static boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
    public static Attachment attachmentFile {get;set;}
    
    private static List<ESS_EmployeeBasic_DTO.ApplicationListDTO> applicationLists;
    private static ESS_EmployeeBasic_DTO.ApplicationDTO application;
    
    static {
        ESS_EmployeeBasic.InitializeApplicationLists();
    }
    
    public ESS_EmployeeBasic() {
        attachmentFile = new Attachment();
    }
    
    private static void InitializeApplicationLists() {
        
        applicationLists = new List<ESS_EmployeeBasic_DTO.ApplicationListDTO>();
        
        List<ESS_Application__c> Applications = new List<ESS_Application__c>();
        
        string query = 'select id, subject_type__c, document_no__c, is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, ' +
            			'is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, employee_id__c, employee_name__c  from ESS_Application__c order by createddate asc';
        
        Applications = database.query(query);
        
        if(Applications.size() > 0) {
            for(ESS_Application__c EmployeeBasic : Applications) {
                
                ESS_EmployeeBasic_DTO.ApplicationListDTO Application = new ESS_EmployeeBasic_DTO.ApplicationListDTO();
                Application = assignToApplicationListDTO(EmployeeBasic);
                
            }
        }
        
        
    }
    
    @RemoteAction
    public static integer GetApplicationListsCount(ApplicationSearchCriteria filter) {
        
        List<ESS_Application__c> Applications = new List<ESS_Application__c>();
        
       	string query = 'select id, subject_type__c, document_no__c, is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, ' +
            			'is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, employee_id__c, employee_name__c from ESS_Application__c where OwnerId =: userId';
        
        //filter.documentNo
        if(!string.isBlank(filter.documentNo) && !string.isBlank(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        //filter.currentStatus
        if(!string.isBlank(filter.currentStatus) && !string.isBlank(filter.currentStatus) && filter.currentStatus.toLowerCase() != 'all') {
            string currentStatus = filter.currentStatus;
            query = query + ' AND status__c =: currentStatus';
        }
        //filter.searchAll
        if(filter.searchAll) {
            query = query + ' AND (subject_type__c = null OR is_update_name__c = true OR is_update_status__c = true OR is_update_child__c = true OR is_update_death__c = true OR is_update_education__c = true OR is_update_license__c = true OR is_update_address__c = true OR is_update_contactperson__c = true OR is_update_tax__c = true)';
        }
        else {
            
            query = query + ' AND (';
            
            boolean isOtherSearchExist = false;
            
            //filter.searchName
            if(filter.searchName) {
                query = query + ' is_update_name__c = true';
                isOtherSearchExist = true;
            }
            //filter.searchStatus
            if(filter.searchStatus) {
                if(isOtherSearchExist) {
                	query = query + ' OR is_update_status__c = true';
                }
                else {
                    query = query + ' is_update_status__c = true';
                	isOtherSearchExist = true;
                }
            }
            //filter.searchChild
            if(filter.searchChild) {
                if(isOtherSearchExist) {
                	query = query + ' OR is_update_child__c = true';
                }
                else {
                	query = query + ' is_update_child__c = true';
                	isOtherSearchExist = true;
                }
            }
            //filter.searchDeath
            if(filter.searchDeath) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_death__c = true';
                }
                else {
                    query = query + ' is_update_death__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchEducation
            if(filter.searchEducation) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_education__c = true';
                }
                else {
                    query = query + ' is_update_education__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchLicense
            if(filter.searchLicense) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_license__c = true';
                }
                else {
                    query = query + ' is_update_license__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchAddress
            if(filter.searchAddress) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_address__c = true';
                }
                else {
                    query = query + ' is_update_address__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchContactPerson
            if(filter.searchContactPerson) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_contactperson__c = true';
                }
                else {
                    query = query + ' is_update_contactperson__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchTax
            if(filter.searchTax) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_tax__c = true';
                }
                else {
                    query = query + ' is_update_tax__c = true';
                    isOtherSearchExist = true;
                }
            }
            
            if(!isOtherSearchExist) {
                query += ' subject_type__c = null';
            }
            
            query = query + ')';
            
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
        	datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
            query = query + ' AND createddate >=: startCreatedDate';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
        	datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        	query = query + ' AND createddate <=: endCreatedDate';
        }
        
        //filter.startSubmittedDate
        if(filter.startSubmittedDate != null) {
            date startSubmittedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startSubmittedDate));
            query = query + ' AND (submitted_date__c >=: startSubmittedDate)';
        }
        
        //filter.endSubmittedDate
        if(filter.endSubmittedDate != null) {
            date endSubmittedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endSubmittedDate));
            query = query + ' AND (submitted_date__c <=: endSubmittedDate)';
        }
        
        //filter.startVerifiedDate
        if(filter.startVerifiedDate != null) {
            date startVerifiedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startVerifiedDate));
            query = query + ' AND (verified_date__c >=: startVerifiedDate)';
        }
        
        //filter.endVerifiedDate
        if(filter.endVerifiedDate != null) {
            date endVerifiedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endVerifiedDate));
            query = query + ' AND (verified_date__c <=: endVerifiedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startCompletedDate));
            query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endCompletedDate));
            query = query + ' AND (completed_date__c <=: endCompletedDate)';
        }
        
		//Final query
		Applications = Database.query(query); 
        
        if(Applications.size() > 0) {
            return Applications.size();
        }
        
        return 0;
    }
    
    @RemoteAction
    public static List<ESS_EmployeeBasic_DTO.ApplicationListDTO> GetApplicationLists(ApplicationSearchCriteria filter,
        //documentNo, subjectType, currentStatus, createdDate, submittedDate, verifiedDate, completedDate, cancelledDate
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
            
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        applicationLists = new List<ESS_EmployeeBasic_DTO.ApplicationListDTO>();
        
        List<ESS_Application__c> Applications = new List<ESS_Application__c>();
        List<ESS_Application__c> existApplications = new List<ESS_Application__c>();
            
        string query = 'select id, subject_type__c, document_no__c, is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, ' +
            			'is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, employee_id__c, employee_name__c from ESS_Application__c where OwnerId =: userId';
         
        //filter.documentNo
        if(!string.isBlank(filter.documentNo) && !string.isBlank(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        //filter.currentStatus
        if(!string.isBlank(filter.currentStatus) && !string.isBlank(filter.currentStatus) && filter.currentStatus.toLowerCase() != 'all') {
            string currentStatus = filter.currentStatus;
            query = query + ' AND status__c =: currentStatus';
        }
        //filter.searchAll
        if(filter.searchAll) {
            query = query + ' AND (subject_type__c = null OR is_update_name__c = true OR is_update_status__c = true OR is_update_child__c = true OR is_update_death__c = true OR is_update_education__c = true OR is_update_license__c = true OR is_update_address__c = true OR is_update_contactperson__c = true OR is_update_tax__c = true)';
        }
        else {
            
            query = query + ' AND (';
            
            boolean isOtherSearchExist = false;
            
            //filter.searchName
            if(filter.searchName) {
                query = query + ' is_update_name__c = true';
                isOtherSearchExist = true;
            }
            //filter.searchStatus
            if(filter.searchStatus) {
                if(isOtherSearchExist) {
                	query = query + ' OR is_update_status__c = true';
                }
                else {
                    query = query + ' is_update_status__c = true';
                	isOtherSearchExist = true;
                }
            }
            //filter.searchChild
            if(filter.searchChild) {
                if(isOtherSearchExist) {
                	query = query + ' OR is_update_child__c = true';
                }
                else {
                	query = query + ' is_update_child__c = true';
                	isOtherSearchExist = true;
                }
            }
            //filter.searchDeath
            if(filter.searchDeath) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_death__c = true';
                }
                else {
                    query = query + ' is_update_death__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchEducation
            if(filter.searchEducation) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_education__c = true';
                }
                else {
                    query = query + ' is_update_education__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchLicense
            if(filter.searchLicense) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_license__c = true';
                }
                else {
                    query = query + ' is_update_license__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchAddress
            if(filter.searchAddress) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_address__c = true';
                }
                else {
                    query = query + ' is_update_address__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchContactPerson
            if(filter.searchContactPerson) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_contactperson__c = true';
                }
                else {
                    query = query + ' is_update_contactperson__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchTax
            if(filter.searchTax) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_tax__c = true';
                }
                else {
                    query = query + ' is_update_tax__c = true';
                    isOtherSearchExist = true;
                }
            }
            
            if(!isOtherSearchExist) {
                query += ' subject_type__c = null';
            }
            query = query + ')';
            
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
        	datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
            query = query + ' AND createddate >=: startCreatedDate';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
        	datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        	query = query + ' AND createddate <=: endCreatedDate';
        }
        
        //filter.startSubmittedDate
        if(filter.startSubmittedDate != null) {
            date startSubmittedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startSubmittedDate));
            query = query + ' AND (submitted_date__c >=: startSubmittedDate)';
        }
        
        //filter.endSubmittedDate
        if(filter.endSubmittedDate != null) {
            date endSubmittedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endSubmittedDate));
            query = query + ' AND (submitted_date__c <=: endSubmittedDate)';
        }
        
        //filter.startVerifiedDate
        if(filter.startVerifiedDate != null) {
            date startVerifiedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startVerifiedDate));
            query = query + ' AND (verified_date__c >=: startVerifiedDate)';
        }
        
        //filter.endVerifiedDate
        if(filter.endVerifiedDate != null) {
            date endVerifiedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endVerifiedDate));
            query = query + ' AND (verified_date__c <=: endVerifiedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startCompletedDate));
            query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endCompletedDate));
            query = query + ' AND (completed_date__c <=: endCompletedDate)';
        }
        
        //Sort By    
         if(sortByParam.sortBy == 'documentNo') {
             if(sortByParam.ascending) {
                 query += ' order by document_no__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by document_no__c desc';
             }
         }
         else if(sortByParam.sortBy == 'subjectType') {
             if(sortByParam.ascending) {
                 query += ' order by subject_type__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by subject_type__c desc';
             }
         }
         else if(sortByParam.sortBy == 'currentStatus') {
             if(sortByParam.ascending) {
                 query += ' order by status__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by status__c desc';
             }
         }
         else if(sortByParam.sortBy == 'createdDate') {
             if(sortByParam.ascending) {
                 query += ' order by createddate asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by createddate desc';
             }
         }
         else if(sortByParam.sortBy == 'submittedDate') {
             if(sortByParam.ascending) {
                 query += ' order by submitted_date__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by submitted_date__c desc';
             }
         }
         else if(sortByParam.sortBy == 'verifiedDate') {
             if(sortByParam.ascending) {
                 query += ' order by verified_date__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by verified_date__c desc';
             }
         }
         else if(sortByParam.sortBy == 'completedDate') {
             if(sortByParam.ascending) {
                 query += ' order by completed_date__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by completed_date__c desc';
             }
         }
         else if(sortByParam.sortBy == 'cancelledDate') {
             if(sortByParam.ascending) {
                 query += ' order by cancelled_date__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by cancelled_date__c desc';
             }
         }

		if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }
            
        Applications = database.query(query);
        
        if(Applications.size() > 0) {
            for(ESS_Application__c Application : Applications) {
                applicationLists.add(assignToApplicationListDTO(Application));
            }
        }
            
        return applicationLists;
            
    }
    
    @RemoteAction
    public static integer GetAdminApplicationListsCount(ApplicationSearchCriteria filter) {
        
        List<ESS_Application__c> Applications = new List<ESS_Application__c>();
        
       	string query = 'select id, subject_type__c, document_no__c, is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, ' +
            			'is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, employee_id__c, employee_name__c from ESS_Application__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, subject_type__c, document_no__c, is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, ' +
            			'is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, employee_id__c, employee_name__c from ESS_Application__c where OwnerId != null';
        }
        
        //filter.documentNo
        if(!string.isBlank(filter.documentNo) && !string.isBlank(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        //filter.employeeId
        if(!string.isBlank(filter.employeeId) && !string.isBlank(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }
        //filter.currentStatus
        if(!string.isBlank(filter.currentStatus) && !string.isBlank(filter.currentStatus) && filter.currentStatus.toLowerCase() != 'all') {
            string currentStatus = filter.currentStatus;
            query = query + ' AND status__c =: currentStatus';
        }
        //filter.searchAll
        if(filter.searchAll) {
            query = query + ' AND (subject_type__c = null OR is_update_name__c = true OR is_update_status__c = true OR is_update_child__c = true OR is_update_death__c = true OR is_update_education__c = true OR is_update_license__c = true OR is_update_address__c = true OR is_update_contactperson__c = true OR is_update_tax__c = true)';
        }
        else {
            
            query = query + ' AND (';
            
            boolean isOtherSearchExist = false;
            
            //filter.searchName
            if(filter.searchName) {
                query = query + ' is_update_name__c = true';
                isOtherSearchExist = true;
            }
            //filter.searchStatus
            if(filter.searchStatus) {
                if(isOtherSearchExist) {
                	query = query + ' OR is_update_status__c = true';
                }
                else {
                    query = query + ' is_update_status__c = true';
                	isOtherSearchExist = true;
                }
            }
            //filter.searchChild
            if(filter.searchChild) {
                if(isOtherSearchExist) {
                	query = query + ' OR is_update_child__c = true';
                }
                else {
                	query = query + ' is_update_child__c = true';
                	isOtherSearchExist = true;
                }
            }
            //filter.searchDeath
            if(filter.searchDeath) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_death__c = true';
                }
                else {
                    query = query + ' is_update_death__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchEducation
            if(filter.searchEducation) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_education__c = true';
                }
                else {
                    query = query + ' is_update_education__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchLicense
            if(filter.searchLicense) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_license__c = true';
                }
                else {
                    query = query + ' is_update_license__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchAddress
            if(filter.searchAddress) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_address__c = true';
                }
                else {
                    query = query + ' is_update_address__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchContactPerson
            if(filter.searchContactPerson) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_contactperson__c = true';
                }
                else {
                    query = query + ' is_update_contactperson__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchTax
            if(filter.searchTax) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_tax__c = true';
                }
                else {
                    query = query + ' is_update_tax__c = true';
                    isOtherSearchExist = true;
                }
            }
            
            if(!isOtherSearchExist) {
                query += ' subject_type__c = null';
            }
            query = query + ')';
            
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
        	datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
            query = query + ' AND createddate >=: startCreatedDate';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
        	datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        	query = query + ' AND createddate <=: endCreatedDate';
        }
        
        //filter.startSubmittedDate
        if(filter.startSubmittedDate != null) {
            date startSubmittedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startSubmittedDate));
            query = query + ' AND (submitted_date__c >=: startSubmittedDate)';
        }
        
        //filter.endSubmittedDate
        if(filter.endSubmittedDate != null) {
            date endSubmittedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endSubmittedDate));
            query = query + ' AND (submitted_date__c <=: endSubmittedDate)';
        }
        
        //filter.startVerifiedDate
        if(filter.startVerifiedDate != null) {
            date startVerifiedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startVerifiedDate));
            query = query + ' AND (verified_date__c >=: startVerifiedDate)';
        }
        
        //filter.endVerifiedDate
        if(filter.endVerifiedDate != null) {
            date endVerifiedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endVerifiedDate));
            query = query + ' AND (verified_date__c <=: endVerifiedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startCompletedDate));
            query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endCompletedDate));
            query = query + ' AND (completed_date__c <=: endCompletedDate)';
        }
        
		//Final query
		Applications = Database.query(query); 
        
        if(Applications.size() > 0) {
            return Applications.size();
        }
        
        return 0;
    }
    
    @RemoteAction
    public static List<ESS_EmployeeBasic_DTO.ApplicationListDTO> GetAdminApplicationLists(ApplicationSearchCriteria filter,
        //documentNo, employeeId, subjectType, currentStatus, createdDate, submittedDate, verifiedDate, completedDate, cancelledDate
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        applicationLists = new List<ESS_EmployeeBasic_DTO.ApplicationListDTO>();
        
        List<ESS_Application__c> Applications = new List<ESS_Application__c>();
        List<ESS_Application__c> existApplications = new List<ESS_Application__c>();
            
        string query = 'select id, subject_type__c, document_no__c, is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, ' +
            			'is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, employee_id__c, employee_name__c from ESS_Application__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, subject_type__c, document_no__c, is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, ' +
            			'is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, employee_id__c, employee_name__c from ESS_Application__c where OwnerId != null';
        }  
            
        //filter.documentNo
        if(!string.isBlank(filter.documentNo) && !string.isBlank(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        //filter.employeeId
        if(!string.isBlank(filter.employeeId) && !string.isBlank(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }
        //filter.currentStatus
        if(!string.isBlank(filter.currentStatus) && !string.isBlank(filter.currentStatus) && filter.currentStatus.toLowerCase() != 'all') {
            string currentStatus = filter.currentStatus;
            query = query + ' AND status__c =: currentStatus';
        }
        //filter.searchAll
        if(filter.searchAll) {
            query = query + ' AND (subject_type__c = null OR is_update_name__c = true OR is_update_status__c = true OR is_update_child__c = true OR is_update_death__c = true OR is_update_education__c = true OR is_update_license__c = true OR is_update_address__c = true OR is_update_contactperson__c = true OR is_update_tax__c = true)';
        }
        else {
            
            query = query + ' AND (';
            
            boolean isOtherSearchExist = false;
            
            //filter.searchName
            if(filter.searchName) {
                query = query + ' is_update_name__c = true';
                isOtherSearchExist = true;
            }
            //filter.searchStatus
            if(filter.searchStatus) {
                if(isOtherSearchExist) {
                	query = query + ' OR is_update_status__c = true';
                }
                else {
                    query = query + ' is_update_status__c = true';
                	isOtherSearchExist = true;
                }
            }
            //filter.searchChild
            if(filter.searchChild) {
                if(isOtherSearchExist) {
                	query = query + ' OR is_update_child__c = true';
                }
                else {
                	query = query + ' is_update_child__c = true';
                	isOtherSearchExist = true;
                }
            }
            //filter.searchDeath
            if(filter.searchDeath) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_death__c = true';
                }
                else {
                    query = query + ' is_update_death__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchEducation
            if(filter.searchEducation) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_education__c = true';
                }
                else {
                    query = query + ' is_update_education__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchLicense
            if(filter.searchLicense) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_license__c = true';
                }
                else {
                    query = query + ' is_update_license__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchAddress
            if(filter.searchAddress) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_address__c = true';
                }
                else {
                    query = query + ' is_update_address__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchContactPerson
            if(filter.searchContactPerson) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_contactperson__c = true';
                }
                else {
                    query = query + ' is_update_contactperson__c = true';
                    isOtherSearchExist = true;
                }
            }
            //filter.searchTax
            if(filter.searchTax) {
                if(isOtherSearchExist) {
                    query = query + ' OR is_update_tax__c = true';
                }
                else {
                    query = query + ' is_update_tax__c = true';
                    isOtherSearchExist = true;
                }
            }
            
            if(!isOtherSearchExist) {
                query += ' subject_type__c = null';
            }
            query = query + ')';
            
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
        	datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
            query = query + ' AND createddate >=: startCreatedDate';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
        	datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        	query = query + ' AND createddate <=: endCreatedDate';
        }
        
        //filter.startSubmittedDate
        if(filter.startSubmittedDate != null) {
            date startSubmittedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startSubmittedDate));
            query = query + ' AND (submitted_date__c >=: startSubmittedDate)';
        }
        
        //filter.endSubmittedDate
        if(filter.endSubmittedDate != null) {
            date endSubmittedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endSubmittedDate));
            query = query + ' AND (submitted_date__c <=: endSubmittedDate)';
        }
        
        //filter.startVerifiedDate
        if(filter.startVerifiedDate != null) {
            date startVerifiedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startVerifiedDate));
            query = query + ' AND (verified_date__c >=: startVerifiedDate)';
        }
        
        //filter.endVerifiedDate
        if(filter.endVerifiedDate != null) {
            date endVerifiedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endVerifiedDate));
            query = query + ' AND (verified_date__c <=: endVerifiedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.startCompletedDate));
            query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = Date.ValueOf(ESS_Global.convertDateTimeFilter(filter.endCompletedDate));
            query = query + ' AND (completed_date__c <=: endCompletedDate)';
        }
        
        //Sort By    
        if(sortByParam.sortBy == 'employeeId') {
             if(sortByParam.ascending) {
                 query += ' order by employee_id__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by employee_id__c desc';
             }
         }
         else if(sortByParam.sortBy == 'employeeName') {
             if(sortByParam.ascending) {
                 query += ' order by employee_name__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by employee_name__c desc';
             }
         }
         else if(sortByParam.sortBy == 'documentNo') {
             if(sortByParam.ascending) {
                 query += ' order by document_no__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by document_no__c desc';
             }
         }
         else if(sortByParam.sortBy == 'subjectType') {
             if(sortByParam.ascending) {
                 query += ' order by subject_type__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by subject_type__c desc';
             }
         }
         else if(sortByParam.sortBy == 'currentStatus') {
             if(sortByParam.ascending) {
                 query += ' order by status__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by status__c desc';
             }
         }
         else if(sortByParam.sortBy == 'createdDate') {
             if(sortByParam.ascending) {
                 query += ' order by createddate asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by createddate desc';
             }
         }
         else if(sortByParam.sortBy == 'submittedDate') {
             if(sortByParam.ascending) {
                 query += ' order by submitted_date__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by submitted_date__c desc';
             }
         }
         else if(sortByParam.sortBy == 'verifiedDate') {
             if(sortByParam.ascending) {
                 query += ' order by verified_date__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by verified_date__c desc';
             }
         }
         else if(sortByParam.sortBy == 'completedDate') {
             if(sortByParam.ascending) {
                 query += ' order by completed_date__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by completed_date__c desc';
             }
         }
         else if(sortByParam.sortBy == 'cancelledDate') {
             if(sortByParam.ascending) {
                 query += ' order by cancelled_date__c asc';
             }
             else if(!sortByParam.ascending) {
                 query += ' order by cancelled_date__c desc';
             }
         } 

        if (pageParam != null){
             if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 query += ' LIMIT :pageSize OFFSET :offset';
             }
        }

        Applications = database.query(query);            
        if(Applications.size() > 0) {
            for(ESS_Application__c Application : Applications) {
                applicationLists.add(assignToApplicationListDTO(Application));
            }
        }
            
            
        return applicationLists;
            
    }
    
    @RemoteAction
    public static ESS_EmployeeBasic_DTO.ApplicationDTO GetApplication(string applicationId) {
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        }
        
        application = new ESS_EmployeeBasic_DTO.ApplicationDTO();
        
        ESS_Application__c EmployeeBasic;
        boolean isOnUpdate = false;
        
        if(applicationId == null || applicationId == 'null') {
            application.applicationHeaderInfo = new ESS_EmployeeBasic_DTO.ApplicationHeaderInfoDTO();
            
            application.applicationHeaderInfo.employeeId = PISUser.EMPLOYEEID__c;
            application.applicationHeaderInfo.employeeName = PISUser.EN_Fullname__c;
            
            if(PISUser.COMPANYNAME__c == 'TOP') {
                application.applicationHeaderInfo.isTopEmployee = true;
            }
            else {
                application.applicationHeaderInfo.isTopEmployee = false;
            }
            
            application.applicationHeaderInfo.position = PISUser.OBJENFULLNAME__c;
            application.applicationHeaderInfo.unit = PISUser.UNITS__c;
            
            application.applicationHeaderInfo.documentNo = '-';
            application.applicationHeaderInfo.currentStatus = new ESS_Global.EnumValue('ApplicationStatus');
            application.applicationHeaderInfo.currentStatus.key = ESS_Enum.ApplicationStatus.Draft.name();
            application.applicationHeaderInfo.currentStatus.value = 'Draft';
            application.applicationHeaderInfo.createdDate = date.today();
            
            List<ESS_Master_Employee__c> Masters = [SELECT Address_EN_Current_House_No__c,Address_EN_Current_Moo_Village_Soi_Road__c,Address_EN_Current_Postal_Code__c,Address_EN_Current_Province__c,
                                             	Address_EN_Current_SubDistrict_District__c,Address_EN_Current_Telephone_No__c,Address_EN_House_No__c,Address_EN_Moo_Village_Soi_Road__c,Address_EN_Postal_Code__c,
                                             	Address_EN_Province__c,Address_EN_SubDistrict_District__c,Address_EN_Telephone_No__c,Address_TH_Current_House_No__c,Address_TH_Current_Moo_Village_Soi_Road__c,
                                             	Address_TH_Current_Postal_Code__c,Address_TH_Current_Province__c,Address_TH_Current_SubDistrict_District__c,Address_TH_Current_Telephone_No__c,Address_TH_House_No__c,
                                             	Address_TH_Moo_Village_Soi_Road__c,Address_TH_Postal_Code__c,Address_TH_Province__c,Address_TH_SubDistrict_District__c,Address_TH_Telephone_No__c,Cancelled__c,
                                             	Completed_Date__c,CreatedDate,Created_Date__c,Data__c,Death_Father_Doc_Issue_Date__c,Death_Father_Doc_Issue_Location__c,
                                             	Death_Father_Doc_Issue_Province__c,Death_Father_Doc_No__c,Death_Father_FN__c,Death_Father_LN__c,Death_Father_Title__c,Death_Marriage_Doc_Issue_Date__c,
                                             	Death_Marriage_Doc_Issue_Location__c,Death_Marriage_Doc_Issue_Province__c,Death_Marriage_Doc_No__c,Death_Marriage_FN__c,Death_Marriage_LN__c,Death_Marriage_Title__c,
                                             	Death_Mother_Doc_Issue_Date__c,Death_Mother_Doc_Issue_Location__c,Death_Mother_Doc_Issue_Province__c,Death_Mother_Doc_No__c,Death_Mother_FN__c,Death_Mother_LN__c,Death_Mother_Title__c,
                                             	Document_No__c,Employee_ID__c,Employee_Name__c,ESS_Application__c,ExternalId__c,Id,Is_Marriage_As_Employee__c,Is_Update_Address__c,Is_Update_Child__c,
                                             	Is_Update_ContactPerson__c,Is_Update_Death__c,Is_Update_Education__c,Is_Update_License__c,Is_Update_Name__c,Is_Update_Status__c,Is_Update_Tax__c,License_Citizen_Expire_Date__c,
                                             	License_Citizen_Id__c,License_Citizen_Issue_Date__c,License_Citizen_Issue_Province__c,License_Professional_Doc_Expire_Date__c,License_Professional_Doc_Issue_Date__c,
                                             	License_Professional_Doc_Level__c,License_Professional_Doc_No__c,License_Professional_Engineer__c,Name,Name_Emp_Change_Doc_Issue_Date__c,Name_Emp_Change_Doc_Issue_Location__c,
                                             	Name_Emp_Change_Doc_Issue_Province__c,Name_Emp_Change_Doc_No__c,Name_Emp_EN_FN__c,Name_Emp_EN_LN__c,Name_Emp_EN_Title__c,Name_Emp_TH_Title_FN_LN__c,Name_Father_Change_Doc_Issue_Date__c,
                                             	Name_Father_Change_Doc_Issue_Location__c,Name_Father_Change_Doc_Issue_Province__c,Name_Father_Change_Doc_No__c,Name_Father_EN_FN__c,Name_Father_EN_LN__c,Name_Father_EN_Title__c,
                                             	Name_Father_TH_FN__c,Name_Father_TH_LN__c,Name_Father_TH_Title__c,Name_Marriage_Change_Doc_Issue_Date__c,Name_Marriage_Change_Doc_Issue_Location__c,Name_Marriage_Change_Doc_Issue_Province__c,
                                             	Name_Marriage_Change_Doc_No__c,Name_Marriage_EN_FN__c,Name_Marriage_EN_LN__c,Name_Marriage_EN_Title__c,Name_Marriage_TH_FN__c,Name_Marriage_TH_LN__c,Name_Marriage_TH_Title__c,
                                             	Name_Mother_Change_Doc_Issue_Date__c,Name_Mother_Change_Doc_Issue_Location__c,Name_Mother_Change_Doc_Issue_Province__c,Name_Mother_Change_Doc_No__c,Name_Mother_EN_FN__c,
                                             	Name_Mother_EN_LN__c,Name_Mother_EN_Title__c,Name_Mother_TH_FN__c,Name_Mother_TH_LN__c,Name_Mother_TH_Title__c,Position__c,SAP_JSON__c,Status_Divorce_Change_LN__c,
                                             	Status_Divorce_Change_Title__c,Status_Divorce_Doc_Issue_Date__c,Status_Divorce_Doc_Issue_Location__c,Status_Divorce_Doc_Issue_Province__c,Status_Divorce_Doc_No__c,
                                             	Status_Divorce_EN_FN__c,Status_Divorce_EN_LN__c,Status_Divorce_EN_New_LN__c,Status_Divorce_EN_New_Title__c,Status_Divorce_EN_Title__c,Status_Divorce_TH_FN__c,Status_Divorce_TH_LN__c,
                                             	Status_Divorce_TH_New_LN__c,Status_Divorce_TH_New_Title__c,Status_Divorce_TH_Title__c,Status_Marriage_Citizen_Id__c,Status_Marriage_DOB__c,Status_Marriage_Doc_Issue_Date__c,
                                             	Status_Marriage_Doc_Issue_Location__c,Status_Marriage_Doc_Issue_Province__c,Status_Marriage_Doc_No__c,Status_Marriage_EN_FN__c,Status_Marriage_EN_LN__c,Status_Marriage_EN_Title__c,
                                             	Status_Marriage_Occupation__c,Status_Marriage_Status__c,Status_Marriage_TH_Title__c,Status_Marriage_TH_FN__c,Status_Marriage_TH_LN__c, Status_Marriage_TH_New_Title__c,Status_Marriage_TH_New_LN__c,Status_Marriage_EN_New_Title__c,Status_Marriage_EN_New_LN__c,
                                             	Status_Marriage_Change_Title__c, Status_Marriage_Change_LN__c,Status_Widow_Change_LN__c,Status_Widow_Change_Title__c,Status_Widow_Doc_Issue_Date__c,
                                             	Status_Widow_Doc_Issue_Location__c,Status_Widow_Doc_Issue_Province__c,Status_Widow_Doc_No__c,Status_Widow_EN_FN__c,Status_Widow_EN_LN__c,Status_Widow_EN_New_LN__c,Status_Widow_EN_New_Title__c,
                                             	Status_Widow_EN_Title__c,Status_Widow_TH_FN__c,Status_Widow_TH_LN__c,Status_Widow_TH_New_LN__c,Status_Widow_TH_New_Title__c,Status_Widow_TH_Title__c,Status__c,Submitted_Date__c,
                                             	Tax_Annuity_Interest_Amount__c,Tax_Child_Count__c,Tax_Donation_For_Charity_Amount__c,Tax_Donation_For_Education_Amount__c,Tax_First_House_Exclude_Tax_Amount__c,Tax_Income_From_RMF_Amount__c,
                                             	Tax_Income_From_SSF_Amount__c,Tax_Interest_On_Loan_For_House_Amount__c,Tax_Marriage_Person_Earn_Income__c,Tax_Marriage_Status__c,Tax_Married_Deduction_Father_Amount__c,
                                             	Tax_Married_Deduction_Mother_Amount__c,Tax_Married_Father_Insurance_Paid_Amount__c,Tax_Married_Life_Insurance_Paid_Amount__c,Tax_Married_Mother_Insurance_Paid_Amount__c,
                                             	Tax_Pregnancy_Care_Amount__c,Tax_Self_Deduction_Father_Amount__c,Tax_Self_Deduction_Mother_Amount__c,Tax_Self_Father_Insurance_Paid_Amount__c,Tax_Self_Life_Insurance_Paid_Amount__c,
                                             	Tax_Self_Mother_Insurance_Paid_Amount__c,Tax_Sponsor_Amount__c,Tax_Total_Child_Count__c,Unit__c,Verified_Date__c, OwnerId, Status_Marriage_Employee_Id__c,
                                             	Child_JSON__c, Death_Child_JSON__c, Name_Child_JSON__c, Name_Child_Count__c, Contact_Person_JSON__c, Education_JSON__c, Status_Marriage_Change_Detail__c,Death_Father_Detail__c,Death_Mother_Detail__c
                                                FROM ESS_Master_Employee__c where Employee_ID__c =: PISUser.EMPLOYEEID__c AND Data__c = 'IN' LIMIT 1];
            
            if(Masters.size() == 0) {
                throw new ESS_Exception(
                    		'[MyError]ไม่พบข้อมูลใน Master Employee กรุณาตรวจสอบข้อมูลใน Master Employee');    
            }
            
            application = assignFromMasterEmployeeDTO(Masters[0], application);
                
        }
        else if(applicationId != null || applicationId != 'null') {
            
            isOnUpdate = true;
        	EmployeeBasic = [SELECT Address_Current_Address_Copy_Id__c,Address_EN_Current_New_District__c,Address_EN_Current_New_House_No__c,Address_EN_Current_New_Moo__c,
                                                Address_EN_Current_New_Postal_Code__c,Address_EN_Current_New_Province__c,Address_EN_Current_New_Road__c,Address_EN_Current_New_Soi__c,Address_EN_Current_New_Sub_District__c,
                                                Address_EN_Current_New_Telephone_No__c,Address_EN_Current_New_Village_Name__c,Address_EN_Current_Old_House_No__c,Address_EN_Current_Old_Moo_Vill_Soi_Road__c,Address_EN_Current_Old_Postal_Code__c,
                                                Address_EN_Current_Old_Province__c,Address_EN_Current_Old_SubDis_District__c,Address_EN_Current_Old_Telephone_No__c,Address_EN_New_District__c,Address_EN_New_House_No__c,Address_EN_New_Moo__c,
                                                Address_EN_New_Postal_Code__c,Address_EN_New_Province__c,Address_EN_New_Road__c,Address_EN_New_Soi__c,Address_EN_New_Sub_District__c,Address_EN_New_Telephone_No__c,Address_EN_New_Village_Name__c,
                                                Address_EN_Old_House_No__c,Address_EN_Old_Moo_Village_Soi_Road__c,Address_EN_Old_Postal_Code__c,Address_EN_Old_Province__c,Address_EN_Old_SubDistrict_District__c,Address_EN_Old_Telephone_No__c,
                                                Address_House_Registration_Copy_Id__c,Address_TH_Current_New_District__c,Address_TH_Current_New_House_No__c,Address_TH_Current_New_Moo__c,Address_TH_Current_New_Postal_Code__c,
                                                Address_TH_Current_New_Province__c,Address_TH_Current_New_Road__c,Address_TH_Current_New_Soi__c,Address_TH_Current_New_Sub_District__c,Address_TH_Current_New_Telephone_No__c,
                                                Address_TH_Current_New_Village_Name__c,Address_TH_Current_Old_House_No__c,Address_TH_Current_Old_Moo_Vill_Soi_Road__c,Address_TH_Current_Old_Postal_Code__c,Address_TH_Current_Old_Province__c,
                                                Address_TH_Current_Old_SubDis_District__c,Address_TH_Current_Old_Telephone_No__c,Address_TH_New_District__c,Address_TH_New_House_No__c,Address_TH_New_Moo__c,Address_TH_New_Postal_Code__c,
                                                Address_TH_New_Province__c,Address_TH_New_Road__c,Address_TH_New_Soi__c,Address_TH_New_Sub_District__c,Address_TH_New_Telephone_No__c,Address_TH_New_Village_Name__c,Address_TH_Old_House_No__c,
                                                Address_TH_Old_Moo_Village_Soi_Road__c,Address_TH_Old_Postal_Code__c,Address_TH_Old_Province__c,Address_TH_Old_SubDistrict_District__c,Address_TH_Old_Telephone_No__c,Address_Type__c,Cancelled_Date__c, Createddate,
                                                Completed_Date__c,Death_Father_Doc_Id__c,Death_Father_Doc_Issue_Date__c,Death_Father_Doc_Issue_Location__c,Death_Father_Doc_Issue_Province__c,
                                                Death_Father_Doc_No__c,Death_Father_FN__c,Death_Father_LN__c,Death_Father_Title__c,Death_Is_Child_Death__c,Death_Is_Father_Death__c,Death_Is_Marriage_Death__c,Death_Is_Mother_Death__c,Death_Marriage_Doc_Id__c,
                                                Death_Marriage_Doc_Issue_Date__c,Death_Marriage_Doc_Issue_Location__c,Death_Marriage_Doc_Issue_Province__c,Death_Marriage_Doc_No__c,Death_Marriage_FN__c,Death_Marriage_LN__c,Death_Marriage_Title__c,
                                                Death_Mother_Doc_Issue_Date__c,Death_Mother_Doc_Issue_Id__c,Death_Mother_Doc_Issue_Location__c,Death_Mother_Doc_Issue_Province__c,Death_Mother_Doc_No__c,Death_Mother_FN__c,Death_Mother_LN__c,
                                                Death_Mother_Title__c,Document_No__c,Employee_ID__c,Employee_Name__c,ExternalId__c,Id,Is_Change_LN_After_Divorced__c,Is_Change_LN_After_Married__c,Is_Change_LN_After_Widow__c,
                                                Is_Change_Title_After_Divorced__c,Is_Change_Title_After_Married__c,Is_Change_Title_After_Widow__c,Is_Marriage_As_Employee__c,Is_Update_Address__c,Is_Update_Child__c,Is_Update_ContactPerson__c,
                                                Is_Update_Death__c,Is_Update_Education__c,Is_Update_License__c,Is_Update_Marriage_As_Well__c,Is_Update_Name__c,Is_Update_Status__c,Is_Update_Tax__c,License_Citizen_Copy_Doc__c,License_Citizen_Id__c,
                                                License_Citizen_New_Expire_Date__c,License_Citizen_New_Issue_Date__c,License_Citizen_New_Issue_Province__c,License_Citizen_Old_Expire_Date__c,License_Citizen_Old_Issue_Date__c,License_Citizen_Old_Issue_Province__c,
                                                License_Professional_Id__c,License_Professional_New_Doc_Expire_Date__c,License_Professional_New_Doc_Issue_Date__c,License_Professional_New_Doc_Level__c,License_Professional_New_Doc_No__c,License_Professional_New_Engineer__c,
                                                License_Professional_Old_Doc_Expire_Date__c,License_Professional_Old_Doc_Issue_Date__c,License_Professional_Old_Doc_Level__c,License_Professional_Old_Doc_No__c,License_Professional_Old_Engineer__c,Name,Name_Change_Child__c,
                                                Name_Change_Employee__c,Name_Change_Father__c,Name_Change_Marriage__c,Name_Change_Mother__c,Name_Emp_Change_Doc_Date__c,Name_Emp_Change_Doc_Id__c,Name_Emp_Change_Doc_Location__c,Name_Emp_Change_Doc_No__c,
                                                Name_Emp_EN_New_FN__c,Name_Emp_EN_New_LN__c,Name_Emp_EN_New_Title__c,Name_Emp_EN_Old_FN__c,Name_Emp_EN_Old_LN__c,Name_Emp_EN_Old_Title__c,Name_Emp_TH_FN__c,Name_Emp_TH_New_FN__c,Name_Emp_TH_New_LN__c,
                                                Name_Emp_TH_New_Title__c,Name_Emp_TH_Old_FN__c,Name_Emp_TH_Old_LN__c,Name_Emp_TH_Old_Title__c,Name_Father_Change_Doc_Date__c,Name_Father_Change_Doc_Id__c,Name_Father_Change_Doc_Location__c,Name_Father_Change_Doc_No__c,
                                                Name_Father_Change_Doc_Province__c,Name_Father_EN_New_FN__c,Name_Father_EN_New_LN__c,Name_Father_EN_New_Title__c,Name_Father_EN_Old_FN__c,Name_Father_EN_Old_LN__c,Name_Father_EN_Old_Title__c,Name_Father_TH_New_FN__c,
                                                Name_Father_TH_New_LN__c,Name_Father_TH_New_Title__c,Name_Father_TH_Old_FN__c,Name_Father_TH_Old_LN__c,Name_Father_TH_Old_Title__c,Name_Marriage_Change_Doc_Date__c,Name_Marriage_Change_Doc_Id__c,
                                                Name_Marriage_Change_Doc_Location__c,Name_Marriage_Change_Doc_No__c,Name_Marriage_Change_Doc_Province__c,Name_Marriage_EN_New_FN__c,Name_Marriage_EN_New_LN__c,Name_Marriage_EN_New_Title__c,Name_Marriage_EN_Old_FN__c,
                                                Name_Marriage_EN_Old_LN__c,Name_Marriage_EN_Old_Title__c,Name_Marriage_TH_New_FN__c,Name_Marriage_TH_New_LN__c,Name_Marriage_TH_New_Title__c,Name_Marriage_TH_Old_FN__c,Name_Marriage_TH_Old_LN__c,Name_Marriage_TH_Old_Title__c,
                                                Name_Mother_Change_Doc_Date__c,Name_Mother_Change_Doc_Id__c,Name_Mother_Change_Doc_Location__c,Name_Mother_Change_Doc_No__c,Name_Mother_Change_Doc_Province__c,Name_Mother_EN_New_FN__c,Name_Mother_EN_New_LN__c,
                                                Name_Mother_EN_New_Title__c,Name_Mother_EN_Old_FN__c,Name_Mother_EN_Old_LN__c,Name_Mother_EN_Old_Title__c,Name_Mother_TH_New_FN__c,Name_Mother_TH_New_LN__c,Name_Mother_TH_New_Title__c,Name_Mother_TH_Old_FN__c,
                                                Name_Mother_TH_Old_LN__c,Name_Mother_TH_Old_Title__c,Position__c,Status_Divorce_Change_Detail_Id__c,Status_Divorce_Change_LN__c,Status_Divorce_Change_Title__c,Status_Divorce_Doc_Id__c,Status_Divorce_Doc_Issue_Date__c,
                                                Status_Divorce_Doc_Issue_Location__c,Status_Divorce_Doc_Issue_Province__c,Status_Divorce_Doc_No__c,Status_Divorce_EN_FN__c,Status_Divorce_EN_LN__c,Status_Divorce_EN_New_LN__c,Status_Divorce_EN_New_Title__c,
                                                Status_Divorce_EN_Title__c,Status_Divorce_TH_FN__c,Status_Divorce_TH_LN__c,Status_Divorce_TH_New_LN__c,Status_Divorce_TH_New_Title__c,Status_Divorce_TH_Title__c,Status_Divorce_Use_Detail_Id__c,Status_Marriage_Change_Detail__c,
                                                Status_Marriage_Change_Doc_Copy_Id__c,Status_Marriage_Change_Doc_Id__c,Status_Marriage_Citizen_Id_Copy__c,Status_Marriage_Citizen_Id__c,Status_Marriage_DOB__c,Status_Marriage_Doc_Id__c,Status_Marriage_Doc_Issue_Date__c,
                                                Status_Marriage_Doc_Issue_Location__c,Status_Marriage_Doc_Issue_Province__c,Status_Marriage_Doc_No__c,Status_Marriage_EN_FN__c,Status_Marriage_EN_LN__c,Status_Marriage_EN_New_LN__c,Status_Marriage_EN_New_Title__c,
                                                Status_Marriage_EN_Title__c,Status_Marriage_Occupation__c,Status_Marriage_Status__c,Status_Marriage_TH_New_FN__c,Status_Marriage_TH_New_LN__c,Status_Marriage_TH_New_Title__c, Status_Marriage_TH_FN__c, Status_Marriage_TH_LN__c, Status_Marriage_TH_Title__c, 
                                                Status_Widow_Change_Doc_Id__c,Status_Widow_Change_LN__c,Status_Widow_Change_Title__c,Status_Widow_Doc_Id__c,Status_Widow_Doc_Issue_Date__c,Status_Widow_Doc_Issue_Location__c,Status_Widow_Doc_Issue_Province__c,
                                                Status_Widow_Doc_No__c,Status_Widow_EN_FN__c,Status_Widow_EN_LN__c,Status_Widow_EN_New_LN__c,Status_Widow_EN_New_Title__c,Status_Widow_EN_Title__c,Status_Widow_TH_FN__c,Status_Widow_TH_LN__c,Status_Widow_TH_New_LN__c,
                                                Status_Widow_TH_New_Title__c,Status_Widow_TH_Title__c,Status__c,Submitted_Date__c,Tax_Annuity_Interest_Amount__c,Tax_Child_Count__c,Tax_Donation_For_Charity_Amount__c,Tax_Donation_For_Education_Amount__c,
                                                Tax_First_House_Exclude_Tax_Amount__c,Tax_Income_From_RMF_Amount__c,Tax_Income_From_SSF_Amount__c,Tax_Interest_On_Loan_For_House_Amount__c,Tax_Marriage_Person_Earn_Income__c,Tax_Marriage_Status__c,
                                                Tax_Married_Deduction_Father_Amount__c,Tax_Married_Deduction_Mother_Amount__c,Tax_Married_Father_Insurance_Paid_Amount__c,Tax_Married_Life_Insurance_Paid_Amount__c,Tax_Married_Mother_Insurance_Paid_Amount__c,
                                                Tax_Pregnancy_Care_Amount__c,Tax_Self_Deduction_Father_Amount__c,Tax_Self_Deduction_Mother_Amount__c,Tax_Self_Father_Insurance_Paid_Amount__c,Tax_Self_Life_Insurance_Paid_Amount__c,Tax_Self_Mother_Insurance_Paid_Amount__c,
                                                Tax_Sponsor_Amount__c,Tax_Total_Child_Count__c,Unit__c,Verified_Date__c,Verify_By__c, OwnerId, Name_Emp_Change_Doc_Province__c, Status_Marriage_Employee_Id__c,Death_Father_Detail__c,Death_Mother_Detail__c,
                                                Child_JSON__c, Death_Child_JSON__c, Name_Child_JSON__c, Name_Child_Count__c, Contact_Person_JSON__c, Education_JSON__c, Death_Mother_Doc_Id__c, Name_Emp_TH_Old_Title_FN_LN__c, Name_Emp_Citizen_Copy_Id__c, Name_Marriage_Citizen_Copy_Id__c,
                                                Name_Father_Citizen_Copy_Id__c, Name_Mother_Citizen_Copy_Id__c,Address_Change__c,Address_Current_Change__c, Effective_Date__c, License_Citizen_Change__c, License_Professional_Change__c, Old_Is_Marriage_As_Employee__c FROM ESS_Application__c where Id =: applicationId];
            
            application = assignToApplicationDTO(EmployeeBasic);
        }
        
        string employeeBasicStatus = String.ValueOf(application.applicationHeaderInfo.currentStatus.key);
        
        application.isSaveCancel = checkCanEdit(employeeBasicStatus);
        application.isSubmit = checkCanSubmit(employeeBasicStatus);
        application.isCancelRequest = checkCanCancel(employeeBasicStatus);
        
        if(isAdmin && employeeBasicStatus != String.ValueOf(ESS_Enum.ApplicationStatus.Draft)) {
            
            application.NameInfo.employeeInfo.isEditable = true;
            application.NameInfo.statusInfo.isEditable = true;
            if(application.NameInfo.childInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.NameInfo.childInfos) {
                    ChildInfo.isEditable = true;
                }
            }
            
            if(string.isnotempty(EmployeeBasic.Death_Father_Detail__c)) {
            	application.NameInfo.fatherInfo.isEditable = false;
            }
            else {
                application.NameInfo.fatherInfo.isEditable = true;
            }
            if(string.isnotempty(EmployeeBasic.Death_Mother_Detail__c)) {
            	application.NameInfo.motherInfo.isEditable = false;
            }
            else {
                application.NameInfo.motherInfo.isEditable = true;
            }
            
            application.StatusInfo.isEditable = true;
            if(application.ChildInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                    ChildInfo.isEditable = true;
                    if(ChildInfo.status == null) {
                        ChildInfo.isEditable = false;
                    }
                }
            }
            application.DeathInfo.isEditable = true;
            if(application.DeathInfo.DeathInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.DeathInfoDTO DeathInfoDTO : application.DeathInfo.DeathInfos) {
                    DeathInfoDTO.isEditable = true;
                }
            }
            
            if(application.EducationInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                    EducationInfo.isEditable = true;
                    if(EducationInfo.status == null) {
                        EducationInfo.isEditable = false;
                    }
                }
            }
            
            if(application.LicenseInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                    LicenseInfo.isEditable = true;
                }
            }
            
            if(application.AddressInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                    AddressInfo.isEditable = true;
                }
            }
            
            application.TaxInfo.isEditable = true;
            
            application.isSaveCancel = true;
            application.isCancelRequest = true;
            
            if(employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Verified)) {
                application.isSaveCancel = false;
                application.isCancelRequest = false;
            }
            else if(employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Draft)) {
                application.isSaveCancel = true;
                application.isCancelRequest = false;
            }
            else if(employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Submitted)) {
            	application.isCancelRequest = false;
                
                if(application.ApplicationHeaderInfo.verifiedDate != null) {
                    application.isSaveCancel = false;
                }
            }
            else if(employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Completed) ||
                   employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Cancelled)) {
                application.isSaveCancel = false;
                application.isCancelRequest = false;
                application.isSubmit = false;
            }
            else if(employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.SendingToSAP) ||
                   employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Error)) {
                application.isSaveCancel = false;
                application.isCancelRequest = false;
                application.isSubmit = false;
            }
        }
        else if(isAdmin && employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Draft) && isOnUpdate) {
            
            if(EmployeeBasic.OwnerId != userId) {
                application.NameInfo.employeeInfo.isEditable = false;
                application.NameInfo.statusInfo.isEditable = false;
                application.NameInfo.fatherInfo.isEditable = false;
                application.NameInfo.motherInfo.isEditable = false;
                if(application.NameInfo.childInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.NameInfo.childInfos) {
                        ChildInfo.isEditable = false;
                    }
                }
                application.StatusInfo.isEditable = false;
                
                if(application.ChildInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                        ChildInfo.isEditable = false;
                    }
                }
                application.DeathInfo.isEditable = true;
                if(application.DeathInfo.DeathInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.DeathInfoDTO DeathInfoDTO : application.DeathInfo.DeathInfos) {
                        DeathInfoDTO.isEditable = false;
                    }
                }
                
                if(application.EducationInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                        EducationInfo.isEditable = false;
                    }
                }
                
                if(application.LicenseInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                        LicenseInfo.isEditable = false;
                    }
                }
                
                if(application.AddressInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                        AddressInfo.isEditable = false;
                    }
                }
                
                application.TaxInfo.isEditable = false;
                
                application.isSaveCancel = false;
                application.isSubmit = false;
            }
        }
        else if(!isAdmin && (employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Draft))) {
            application.DeathInfo.isEditable = true;
            if(Application.DeathInfo.DeathInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.DeathInfoDTO DeathInfo : Application.DeathInfo.DeathInfos) {
                    DeathInfo.isEditable = true;
                    if((DeathInfo.deathPerson.value == 'Mother' || DeathInfo.deathPerson.value == 'Father') && string.isNotBlank(DeathInfo.deathDetail)) {
                        DeathInfo.isEditable = false;
                    }
                }
            }
        }
        else if(!isAdmin && (employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Submitted) || 
                            employeeBasicStatus == String.ValueOf(ESS_Enum.ApplicationStatus.Verified))) {
            
            application.NameInfo.employeeInfo.isEditable = false;
            application.NameInfo.statusInfo.isEditable = false;
            if(application.NameInfo.childInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.NameInfo.childInfos) {
                    ChildInfo.isEditable = false;
                }
            }
            application.NameInfo.fatherInfo.isEditable = false;
            application.NameInfo.motherInfo.isEditable = false;
            
            application.StatusInfo.isEditable = false;
            
            if(application.ChildInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                    ChildInfo.isEditable = false;
                }
            }
            application.DeathInfo.isEditable = false;
            
            if(application.EducationInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                    EducationInfo.isEditable = false;
                }
            }
            
            if(application.LicenseInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                    LicenseInfo.isEditable = false;
                }
            }
            
            if(application.AddressInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                    AddressInfo.isEditable = false;
                }
            }
            
            application.TaxInfo.isEditable = false;
            
        }
        
        application.isVerify = checkCanVerify(employeeBasicStatus, application.ApplicationHeaderInfo.verifiedDate);
        
        return application;
    }
    
    @RemoteAction
    public static ESS_EmployeeBasic_DTO.ApplicationDTO SaveApplication(ESS_EmployeeBasic_DTO.ApplicationDTO application) {
        
        string employeeBasicStatus;
        string ownerId;
        
        if(isAdmin) {
            application.isProcessingVerify = true;
        }
        
        try {
            
            if(application.id == null || application.id == 'null') {
                
                PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
                
                //Insert into Application
                ESS_Application__c EmployeeBasic = new ESS_Application__c();
                
                //Header
                string runningNo = ESS_LogicHandler.GenerateRunningNo('Application');
                string year = ESS_LogicHandler.GetCurrentYear();
                string month = ESS_LogicHandler.GetCurrentMonth();
                
                EmployeeBasic.Document_No__c = 'ETI-' + year + '-' + month + '-' + runningNo;
                EmployeeBasic.OwnerId = userId;
                EmployeeBasic.Employee_ID__c = PISUser.EmployeeID__c;
                EmployeeBasic.Employee_Name__c = PISUser.EN_Fullname__c;
                EmployeeBasic.Position__c = PISUser.OBJENFULLNAME__c;
                EmployeeBasic.Unit__c = PISUser.UNITS__c;
                EmployeeBasic.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Draft);
                EmployeeBasic.Company_Name__c = PISUser.COMPANYNAME__c;
                EmployeeBasic.Function__c = PISUser.FUNCTION__c;
                EmployeeBasic.Department__c = PISUser.DEPARTMENT__c;
                EmployeeBasic.Section__c = PISUser.SECTIONS__c;
                EmployeeBasic.Unit__c = PISUser.UNITS__c;
                EmployeeBasic.Verify_By__c = assignToAdmin();
                
                ownerId = EmployeeBasic.OwnerId;
                employeeBasicStatus = EmployeeBasic.Status__c;
                
                //NameInfo
                EmployeeBasic.Is_Update_Name__c = application.NameInfo.isChange;
                
                EmployeeBasic.Name_Change_Employee__c = application.NameInfo.editSelfInfo;
                EmployeeBasic.Name_Change_Marriage__c = application.NameInfo.editMarriedInfo;
                EmployeeBasic.Name_Change_Child__c = application.NameInfo.editChildInfo;
                EmployeeBasic.Name_Change_Father__c = application.NameInfo.editFatherInfo;
                EmployeeBasic.Name_Change_Mother__c = application.NameInfo.editMotherInfo;
                EmployeeBasic.Name_Emp_TH_Old_Title_FN_LN__c = application.NameInfo.employeeInfo.oldTHTitleFNLN;
                    
                string nameEmpENOldTitle = checkEnumKey(application.NameInfo.employeeInfo.oldENTitle);
                EmployeeBasic.Name_Emp_EN_Old_Title__c = assignSFTitle(nameEmpENOldTitle);
                EmployeeBasic.Name_Emp_EN_Old_FN__c = application.NameInfo.employeeInfo.oldENFirstName;
                EmployeeBasic.Name_Emp_EN_Old_LN__c = application.NameInfo.employeeInfo.oldENLastName;
                
                string nameEmpTHNewTitle = checkEnumKey(application.NameInfo.employeeInfo.newTHTitle);
                EmployeeBasic.Name_Emp_TH_New_Title__c = assignSFTitle(nameEmpTHNewTitle);
                EmployeeBasic.Name_Emp_TH_New_FN__c = application.NameInfo.employeeInfo.newTHFirstName;
                EmployeeBasic.Name_Emp_TH_New_LN__c = application.NameInfo.employeeInfo.newTHLastName;
                
                string nameEmpENNewTitle = checkEnumKey(application.NameInfo.employeeInfo.newENTitle);
                EmployeeBasic.Name_Emp_EN_New_Title__c = assignSFTitle(nameEmpENNewTitle);
                EmployeeBasic.Name_Emp_EN_New_FN__c = application.NameInfo.employeeInfo.newENFirstName;
                EmployeeBasic.Name_Emp_EN_New_LN__c = application.NameInfo.employeeInfo.newENLastName;
                EmployeeBasic.Name_Emp_Change_Doc_No__c = application.NameInfo.employeeInfo.documentChangeNameNo;
                EmployeeBasic.Name_Emp_Change_Doc_Location__c = application.NameInfo.employeeInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Emp_Change_Doc_Province__c = application.NameInfo.employeeInfo.documentChangeNameProvince;
                
                if(application.NameInfo.employeeInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Emp_Change_Doc_Date__c = application.NameInfo.employeeInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Emp_Change_Doc_Id__c = application.NameInfo.employeeInfo.documentUploadedUrl;
                application.NameInfo.employeeInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Emp_Change_Doc_Id__c);
                
                EmployeeBasic.Name_Emp_Citizen_Copy_Id__c = application.NameInfo.employeeInfo.documentCopyCitizenUrl;
                application.NameInfo.employeeInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Emp_Citizen_Copy_Id__c);
                
                
                string nameMarriageTHOldTitle = checkEnumKey(application.NameInfo.statusInfo.oldTHTitle);
                EmployeeBasic.Name_Marriage_TH_Old_Title__c = assignSFTitle(nameMarriageTHOldTitle);                
                EmployeeBasic.Name_Marriage_TH_Old_FN__c = application.NameInfo.statusInfo.oldTHFirstName;
                EmployeeBasic.Name_Marriage_TH_Old_LN__c = application.NameInfo.statusInfo.oldTHLastName;
                
                string nameMarriageENOldTitle = checkEnumKey(application.NameInfo.statusInfo.oldENTitle);
                EmployeeBasic.Name_Marriage_EN_Old_Title__c = assignSFTitle(nameMarriageENOldTitle);
                EmployeeBasic.Name_Marriage_EN_Old_FN__c = application.NameInfo.statusInfo.oldENFirstName;
                EmployeeBasic.Name_Marriage_EN_Old_LN__c = application.NameInfo.statusInfo.oldENLastName;
                
                string nameMarriageTHNewTitle = checkEnumKey(application.NameInfo.statusInfo.thTitle);
                EmployeeBasic.Name_Marriage_TH_New_Title__c = assignSFTitle(nameMarriageTHNewTitle);
                EmployeeBasic.Name_Marriage_TH_New_FN__c = application.NameInfo.statusInfo.thFirstName;
                EmployeeBasic.Name_Marriage_TH_New_LN__c = application.NameInfo.statusInfo.thLastName;
                
                string nameMarriageENNewTitle = checkEnumKey(application.NameInfo.statusInfo.enTitle);
                EmployeeBasic.Name_Marriage_EN_New_Title__c = assignSFTitle(nameMarriageENNewTitle);
                EmployeeBasic.Name_Marriage_EN_New_FN__c = application.NameInfo.statusInfo.enFirstName;
                EmployeeBasic.Name_Marriage_EN_New_LN__c = application.NameInfo.statusInfo.enLastName;
                EmployeeBasic.Name_Marriage_Change_Doc_No__c = application.NameInfo.statusInfo.documentChangeNameNo;
                EmployeeBasic.Name_Marriage_Change_Doc_Location__c = application.NameInfo.statusInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Marriage_Change_Doc_Province__c = application.NameInfo.statusInfo.documentChangeNameProvince;
                
                if(application.NameInfo.statusInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Marriage_Change_Doc_Date__c = application.NameInfo.statusInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Marriage_Change_Doc_Id__c = application.NameInfo.statusInfo.documentUploadedUrl;
                application.NameInfo.statusInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Marriage_Change_Doc_Id__c);
                
                EmployeeBasic.Name_Marriage_Citizen_Copy_Id__c = application.NameInfo.statusInfo.documentCopyCitizenUrl;
                application.NameInfo.statusInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Marriage_Citizen_Copy_Id__c);
                        
                if(application.NameInfo.childInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.NameInfo.childInfos) {
                        childInfo.documentChangeFirstNameLastNameDisplayUrl = generateDocumentUrl(childInfo.documentChangeFirstNameLastNameUrl);
                        childInfo.documentBirthCertificateDisplayUrl = generateDocumentUrl(childInfo.documentBirthCertificateUrl);
                        childInfo.documentBirthProtegeDisplayUrl = generateDocumentUrl(childInfo.documentBirthProtegeUrl);
                        childInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(childInfo.documentCopyCitizenUrl);
                    }
                }
                
                EmployeeBasic.Name_Child_JSON__c = JSON.serialize(application.NameInfo.childInfos);
                EmployeeBasic.Name_Child_Count__c = application.NameInfo.childCount;
                
                //NameInfo - Father
                string nameFatherTHOldTitle = checkEnumKey(application.NameInfo.fatherInfo.oldTHTitle);
                EmployeeBasic.Name_Father_TH_Old_Title__c = assignSFTitle(nameFatherTHOldTitle);
                EmployeeBasic.Name_Father_TH_Old_FN__c = application.NameInfo.fatherInfo.oldTHFirstName;
                EmployeeBasic.Name_Father_TH_Old_LN__c = application.NameInfo.fatherInfo.oldTHLastName;
                
                string nameFatherENOldTitle = checkEnumKey(application.NameInfo.fatherInfo.oldENTitle);
                EmployeeBasic.Name_Father_EN_Old_Title__c = assignSFTitle(nameFatherENOldTitle);
                EmployeeBasic.Name_Father_EN_Old_FN__c = application.NameInfo.fatherInfo.oldENFirstName;
                EmployeeBasic.Name_Father_EN_Old_LN__c = application.NameInfo.fatherInfo.oldENLastName;
                
                string nameFatherTHNewTitle = checkEnumKey(application.NameInfo.fatherInfo.newTHTitle);
                EmployeeBasic.Name_Father_TH_New_Title__c = assignSFTitle(nameFatherTHNewTitle);
                EmployeeBasic.Name_Father_TH_New_FN__c = application.NameInfo.fatherInfo.newTHFirstName;
                EmployeeBasic.Name_Father_TH_New_LN__c = application.NameInfo.fatherInfo.newTHLastName;
                
                string nameFatherENNewTitle = checkEnumKey(application.NameInfo.fatherInfo.newENTitle);
                EmployeeBasic.Name_Father_EN_New_Title__c = assignSFTitle(nameFatherENNewTitle);
                EmployeeBasic.Name_Father_EN_New_FN__c = application.NameInfo.fatherInfo.newENFirstName;
                EmployeeBasic.Name_Father_EN_New_LN__c = application.NameInfo.fatherInfo.newENLastName;
                EmployeeBasic.Name_Father_Change_Doc_No__c = application.NameInfo.fatherInfo.documentChangeNameNo;
                EmployeeBasic.Name_Father_Change_Doc_Location__c = application.NameInfo.fatherInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Father_Change_Doc_Province__c = application.NameInfo.fatherInfo.documentChangeNameProvince;
                
                if(application.NameInfo.fatherInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Father_Change_Doc_Date__c = application.NameInfo.fatherInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Father_Change_Doc_Id__c = application.NameInfo.fatherInfo.documentUploadedUrl;
                application.NameInfo.fatherInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Father_Change_Doc_Id__c);
                
                EmployeeBasic.Name_Father_Citizen_Copy_Id__c = application.NameInfo.fatherInfo.documentCopyCitizenUrl;
                application.NameInfo.fatherInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Father_Citizen_Copy_Id__c);
                        
                //NameInfo - Mother
                string nameMotherTHOldTitle = checkEnumKey(application.NameInfo.motherInfo.oldTHTitle);
                EmployeeBasic.Name_Mother_TH_Old_Title__c = assignSFTitle(nameMotherTHOldTitle);
                EmployeeBasic.Name_Mother_TH_Old_FN__c = application.NameInfo.motherInfo.oldTHFirstName;
                EmployeeBasic.Name_Mother_TH_Old_LN__c = application.NameInfo.motherInfo.oldTHLastName;
                
                string nameMotherENOldTitle = checkEnumKey(application.NameInfo.motherInfo.oldENTitle);
                EmployeeBasic.Name_Mother_EN_Old_Title__c = assignSFTitle(nameMotherENOldTitle);
                EmployeeBasic.Name_Mother_EN_Old_FN__c = application.NameInfo.motherInfo.oldENFirstName;
                EmployeeBasic.Name_Mother_EN_Old_LN__c = application.NameInfo.motherInfo.oldENLastName;
                
                string nameMotherTHNewTitle = checkEnumKey(application.NameInfo.motherInfo.newTHTitle);
                EmployeeBasic.Name_Mother_TH_New_Title__c = assignSFTitle(nameMotherTHNewTitle);
                EmployeeBasic.Name_Mother_TH_New_FN__c = application.NameInfo.motherInfo.newTHFirstName;
                EmployeeBasic.Name_Mother_TH_New_LN__c = application.NameInfo.motherInfo.newTHLastName;
                
                string nameMotherENNewTitle = checkEnumKey(application.NameInfo.motherInfo.newENTitle);
                EmployeeBasic.Name_Mother_EN_New_Title__c = assignSFTitle(nameMotherENNewTitle);
                EmployeeBasic.Name_Mother_EN_New_FN__c = application.NameInfo.motherInfo.newENFirstName;
                EmployeeBasic.Name_Mother_EN_New_LN__c = application.NameInfo.motherInfo.newENLastName;
                EmployeeBasic.Name_Mother_Change_Doc_No__c = application.NameInfo.motherInfo.documentChangeNameNo;
                EmployeeBasic.Name_Mother_Change_Doc_Location__c = application.NameInfo.motherInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Mother_Change_Doc_Province__c = application.NameInfo.motherInfo.documentChangeNameProvince;
                
                if(application.NameInfo.motherInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Mother_Change_Doc_Date__c = application.NameInfo.motherInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Mother_Change_Doc_Id__c = application.NameInfo.motherInfo.documentUploadedUrl;
                application.NameInfo.motherInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Mother_Change_Doc_Id__c);
                
                EmployeeBasic.Name_Mother_Citizen_Copy_Id__c = application.NameInfo.motherInfo.documentCopyCitizenUrl;
                application.NameInfo.motherInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Mother_Citizen_Copy_Id__c);
                    
                //StatusInfo - Marriage
                EmployeeBasic.Is_Update_Status__c = application.StatusInfo.isChange;
                EmployeeBasic.Is_Marriage_As_Employee__c = application.StatusInfo.isMarriedPersonAsEmployee;
                EmployeeBasic.Old_Is_Marriage_As_Employee__c = application.StatusInfo.OldIsMarriedPersonAsEmployee;
                
                string statusMarriage = checkEnumKey(application.StatusInfo.marriedStatus);
                if(statusMarriage == '1') {
                    EmployeeBasic.Status_Marriage_Status__c = '1';
                } 
                else if(statusMarriage == '3') {
                    EmployeeBasic.Status_Marriage_Status__c = '3';
                } 
                else if(statusMarriage == '2') {
                    EmployeeBasic.Status_Marriage_Status__c = '2';
                } 	
                
                if(application.StatusInfo.isMarriedPersonChangeDetail == null) {
                    EmployeeBasic.Status_Marriage_Change_Detail__c = false;
                }
                else {
                    EmployeeBasic.Status_Marriage_Change_Detail__c = application.StatusInfo.isMarriedPersonChangeDetail;
                }
                
                EmployeeBasic.Status_Marriage_Change_Detail__c = application.StatusInfo.isUpdateMarriedStatus;
                EmployeeBasic.Status_Marriage_Employee_Id__c = application.StatusInfo.marriedEmployeeId;
                
                string statusMarriageOldTHTitle = checkEnumKey(application.StatusInfo.oldTHTitle);
                EmployeeBasic.Status_Marriage_TH_Title__c = assignSFTitle(statusMarriageOldTHTitle);
                if(EmployeeBasic.Status_Marriage_TH_Title__c != null) { 
                    if(EmployeeBasic.Status_Marriage_TH_Title__c != '1') {
                        EmployeeBasic.Status_Marriage_Gender__c = '2';
                    }
                    else {
                        EmployeeBasic.Status_Marriage_Gender__c = '1';
                    }
                }
                else {
                    EmployeeBasic.Status_Marriage_Gender__c = '';
                }
                EmployeeBasic.Status_Marriage_TH_FN__c = application.StatusInfo.oldTHFirstName;
                EmployeeBasic.Status_Marriage_TH_LN__c = application.StatusInfo.oldTHLastName;
                
                string statusMarriageOldENTitle = checkEnumKey(application.StatusInfo.oldENTitle);
                EmployeeBasic.Status_Marriage_EN_Title__c = assignSFTitle(statusMarriageOldENTitle);
                EmployeeBasic.Status_Marriage_EN_FN__c = application.StatusInfo.oldENFirstName;
                EmployeeBasic.Status_Marriage_EN_LN__c = application.StatusInfo.oldENLastName;
                
                EmployeeBasic.Status_Marriage_Citizen_Id__c = application.StatusInfo.citizenId;
                EmployeeBasic.Status_Marriage_DOB__c = application.StatusInfo.dateOfBirth;
                EmployeeBasic.Status_Marriage_Occupation__c = application.StatusInfo.occupation;
                EmployeeBasic.Status_Marriage_Doc_No__c = application.StatusInfo.marriedDocumentNo;
                EmployeeBasic.Status_Marriage_Doc_Issue_Location__c = application.StatusInfo.marriedDocumentIssueLocation;
                EmployeeBasic.Status_Marriage_Doc_Issue_Province__c = application.StatusInfo.marriedDocumentIssueProvince;
                EmployeeBasic.Status_Marriage_Doc_Issue_Date__c = application.StatusInfo.marriedDocumentIssueDate;
                
                string statusMarriageTHNewTitle = checkEnumKey(application.StatusInfo.newMarriedTHTitle);
                string statusMarriageENNewTitle = checkEnumKey(application.StatusInfo.newMarriedENTitle);
                EmployeeBasic.Status_Marriage_EN_New_Title__c = assignSFTitle(statusMarriageENNewTitle);
                
                EmployeeBasic.Status_Marriage_TH_New_LN__c = application.StatusInfo.newMarriedTHLastName;
                EmployeeBasic.Status_Marriage_EN_New_LN__c = application.StatusInfo.newMarriedENLastName;
                
                if(application.StatusInfo.isChangeTitleAfterMarried == null) {
                    EmployeeBasic.Is_Change_Title_After_Married__c = false;
                }
                else {
                    EmployeeBasic.Is_Change_Title_After_Married__c = application.StatusInfo.isChangeTitleAfterMarried;
                    if(application.StatusInfo.isChangeTitleAfterMarried) {
                        EmployeeBasic.Is_Update_Name__c = true;
                        EmployeeBasic.Name_Change_Employee__c = true;
                    }
                }
                
                if(application.StatusInfo.isChangeLastNameAfterMarried == null) {
                    EmployeeBasic.Is_Change_LN_After_Married__c = false;
                }
                else {
                    EmployeeBasic.Is_Change_LN_After_Married__c  = application.StatusInfo.isChangeLastNameAfterMarried;
                    if(application.StatusInfo.isChangeLastNameAfterMarried) {
                        EmployeeBasic.Is_Update_Name__c = true;
                        EmployeeBasic.Name_Change_Employee__c = true;
                    }
                }
                    
                EmployeeBasic.Status_Marriage_Doc_Id__c = application.StatusInfo.marriedDocumentUrl;
                EmployeeBasic.Status_Marriage_Change_Doc_Id__c = application.StatusInfo.employeeTitleLastnameDocumentUrl;
                application.StatusInfo.employeeTitleLastnameDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Change_Doc_Id__c);
                EmployeeBasic.Status_Marriage_Citizen_Id_Copy__c = application.StatusInfo.marriedPersonCopyDocumentUrl;
                application.StatusInfo.marriedPersonCopyDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Citizen_Id_Copy__c);
                EmployeeBasic.Status_Marriage_Change_Doc_Copy_Id__c = application.StatusInfo.changeTitleLastnameCopyDocumentUrl;
                application.StatusInfo.changeTitleLastnameCopyDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Change_Doc_Copy_Id__c);
                
                //StatusInfo - Divorced
                string statusDivorceTHTitle = checkEnumKey(application.StatusInfo.divorcedTHTitle);
                EmployeeBasic.Status_Divorce_TH_Title__c = assignSFTitle(statusDivorceTHTitle);
                EmployeeBasic.Status_Divorce_TH_FN__c = application.StatusInfo.divorcedTHFirstName;
                EmployeeBasic.Status_Divorce_TH_LN__c = application.StatusInfo.divorcedTHLastName;
                
                string statusDivorceENTitle = checkEnumKey(application.StatusInfo.divorcedENTitle);
                EmployeeBasic.Status_Divorce_EN_Title__c = assignSFTitle(statusDivorceENTitle);
                EmployeeBasic.Status_Divorce_EN_FN__c = application.StatusInfo.divorcedENFirstName;
                EmployeeBasic.Status_Divorce_EN_LN__c = application.StatusInfo.divorcedENLastName;
                EmployeeBasic.Status_Divorce_Doc_No__c = application.StatusInfo.divorcedDocumentNo;
                EmployeeBasic.Status_Divorce_Doc_Issue_Location__c = application.StatusInfo.divorcedDocumentIssueLocation;
                EmployeeBasic.Status_Divorce_Doc_Issue_Province__c = application.StatusInfo.divorcedDocumentIssueProvince;
                EmployeeBasic.Status_Divorce_Doc_Issue_Date__c = application.StatusInfo.divorcedDocumentIssueDate;
                
                if(application.StatusInfo.isChangeTitleAfterDivorced == null) {
                    EmployeeBasic.Status_Divorce_Change_Title__c = false;
                }
                else {
                    EmployeeBasic.Status_Divorce_Change_Title__c = application.StatusInfo.isChangeTitleAfterDivorced;
                    EmployeeBasic.Is_Change_Title_After_Divorced__c = application.StatusInfo.isChangeTitleAfterDivorced;
                }
                
                if(application.StatusInfo.isChangeLastNameAfterDivorced == null) {
                    EmployeeBasic.Status_Divorce_Change_LN__c = false;
                }
                else {
                    EmployeeBasic.Status_Divorce_Change_LN__c = application.StatusInfo.isChangeLastNameAfterDivorced;
                    EmployeeBasic.Is_Change_LN_After_Divorced__c = application.StatusInfo.isChangeLastNameAfterDivorced;
                }
                
                string statusDivorceTHNewTitle = checkEnumKey(application.StatusInfo.newDivorcedTHTitle);
                EmployeeBasic.Status_Divorce_TH_New_Title__c = assignSFTitle(statusDivorceTHNewTitle);
                EmployeeBasic.Status_Divorce_TH_New_LN__c = application.StatusInfo.newDivorcedTHLastName;
                
                string statusDivorceENNewTitle = checkEnumKey(application.StatusInfo.newDivorcedENTitle);
                EmployeeBasic.Status_Divorce_EN_New_Title__c = assignSFTitle(statusDivorceENNewTitle);
                EmployeeBasic.Status_Divorce_EN_New_LN__c = application.StatusInfo.newDivorcedENLastName;
                EmployeeBasic.Status_Divorce_Doc_Id__c = application.StatusInfo.divorcedDocumentUrl;
                EmployeeBasic.Status_Divorce_Change_Detail_Id__c = application.StatusInfo.divorcedChangeTitleLastNameUrl;
                EmployeeBasic.Status_Divorce_Use_Detail_Id__c = application.StatusInfo.divorcedUseChangeTitleLastNameUrl;
                
                //StatusInfo - Widow
                string statusWidowTHTitle = checkEnumKey(application.StatusInfo.widowTHTitle);
                EmployeeBasic.Status_Widow_TH_Title__c = assignSFTitle(statusWidowTHTitle);
                EmployeeBasic.Status_Widow_TH_FN__c = application.StatusInfo.widowTHFirstName;
                EmployeeBasic.Status_Widow_TH_LN__c = application.StatusInfo.widowTHLastName;
                
                string statusWidowENTitle = checkEnumKey(application.StatusInfo.widowENTitle);
                EmployeeBasic.Status_Widow_EN_Title__c = assignSFTitle(statusWidowENTitle);
                EmployeeBasic.Status_Widow_EN_FN__c = application.StatusInfo.widowENFirstName;
                EmployeeBasic.Status_Widow_EN_LN__c = application.StatusInfo.widowENLastName;
                EmployeeBasic.Status_Widow_Doc_No__c = application.StatusInfo.widowDocumentNo;
                EmployeeBasic.Status_Widow_Doc_Issue_Location__c = application.StatusInfo.widowDocumentIssueLocation;
                EmployeeBasic.Status_Widow_Doc_Issue_Province__c = application.StatusInfo.widowDocumentIssueProvince;
                EmployeeBasic.Status_Widow_Doc_Issue_Date__c = application.StatusInfo.widowDocumentIssueDate;
                
                if(application.StatusInfo.isChangeTitleAfterWidow == null) {
                    EmployeeBasic.Status_Widow_Change_Title__c = false;
                }
                else {
                    EmployeeBasic.Status_Widow_Change_Title__c = application.StatusInfo.isChangeTitleAfterWidow;
                    EmployeeBasic.Is_Change_Title_After_Widow__c = application.StatusInfo.isChangeTitleAfterWidow;
                }
                
                if(application.StatusInfo.isChangeLastNameAfterWidow == null) {
                    EmployeeBasic.Status_Widow_Change_LN__c = false;
                }
                else {
                    EmployeeBasic.Status_Widow_Change_LN__c = application.StatusInfo.isChangeLastNameAfterWidow;
                    EmployeeBasic.Is_Change_LN_After_Widow__c = application.StatusInfo.isChangeLastNameAfterWidow;
                }
                
                string statusWidowTHNewTitle = checkEnumKey(application.StatusInfo.newWidowTHTitle);
                EmployeeBasic.Status_Widow_TH_New_Title__c = assignSFTitle(statusWidowTHNewTitle);
                EmployeeBasic.Status_Widow_TH_New_LN__c = application.StatusInfo.newWidowTHLastName;
                
                string statusWidowENNewTitle = checkEnumKey(application.StatusInfo.newWidowENTitle);
                EmployeeBasic.Status_Widow_EN_New_Title__c = assignSFTitle(statusWidowENNewTitle);
                EmployeeBasic.Status_Widow_EN_New_LN__c = application.StatusInfo.newWidowENLastName;
                EmployeeBasic.Status_Widow_Doc_Id__c = application.StatusInfo.deathWidowDocumentUrl;
                application.StatusInfo.deathWidowDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Widow_Doc_Id__c);
                EmployeeBasic.Status_Widow_Change_Doc_Id__c = application.StatusInfo.deathWidowChangeTitleLastNameUrl;
                application.StatusInfo.deathWidowChangeTitleLastNameDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Widow_Change_Doc_Id__c);
                    
                //ChildInfo
                if(application.ChildInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                        if(ChildInfo.isChange) {
                            EmployeeBasic.Is_Update_Child__c = true;
                            break;
                        }
                    }
                    
                    if(application.NameInfo.childInfos.size() > 0) {
                        EmployeeBasic.Name_Child_Count__c = application.ChildInfos.size();
                        for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.childInfos) {
                            childInfo.documentChangeFirstNameLastNameDisplayUrl = generateDocumentUrl(childInfo.documentChangeFirstNameLastNameUrl);
                            childInfo.documentBirthCertificateDisplayUrl = generateDocumentUrl(childInfo.documentBirthCertificateUrl);
                            childInfo.documentBirthProtegeDisplayUrl = generateDocumentUrl(childInfo.documentBirthProtegeUrl);
                            childInfo.documentLegitimationDisplayUrl = generateDocumentUrl(childInfo.documentLegitimationUrl);
                            childInfo.documentLegitimationProtegeDisplayUrl = generateDocumentUrl(childInfo.documentLegitimationProtegeUrl);
                        }
                    }
                    
                    EmployeeBasic.Child_JSON__c = String.ValueOf(JSON.serialize(application.ChildInfos));
                    
                }
                else {
                    EmployeeBasic.Child_JSON__c = null;
                    EmployeeBasic.Is_Update_Child__c = false;
                }
                
                //DeathInfo
                EmployeeBasic.Is_Update_Death__c = application.DeathInfo.isChange;
                if(application.DeathInfo.DeathInfos.size() > 0) {
                    
                    List<ESS_EmployeeBasic_DTO.DeathInfoDTO> DeathChilds = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
                    
                    for(ESS_EmployeeBasic_DTO.DeathInfoDTO DeathInfo : application.DeathInfo.DeathInfos) {
                        if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Married)) {
                            EmployeeBasic.Death_Is_Marriage_Death__c = application.DeathInfo.isDeathWife;
                            EmployeeBasic.Death_Marriage_Title__c = checkEnumValue(DeathInfo.title);
                            EmployeeBasic.Death_Marriage_FN__c = DeathInfo.thFirstName;
                            EmployeeBasic.Death_Marriage_LN__c = DeathInfo.thLastName;
                            EmployeeBasic.Death_Marriage_Doc_No__c = DeathInfo.deathDocumentNo;
                            EmployeeBasic.Death_Marriage_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                            EmployeeBasic.Death_Marriage_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                            EmployeeBasic.Death_Marriage_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                            EmployeeBasic.Death_Marriage_Doc_Id__c = DeathInfo.deathDocumentUrl;
                            DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(DeathInfo.deathDocumentUrl);
                        }
                        else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Father)) {
                            EmployeeBasic.Death_Is_Father_Death__c = application.DeathInfo.isDeathFather;
                            EmployeeBasic.Death_Father_Detail__c = DeathInfo.deathDetail;
                            EmployeeBasic.Death_Father_Title__c = checkEnumValue(DeathInfo.title);
                            EmployeeBasic.Death_Father_FN__c = DeathInfo.thFirstName;
                            EmployeeBasic.Death_Father_LN__c = DeathInfo.thLastName;
                            EmployeeBasic.Death_Father_Doc_No__c = DeathInfo.deathDocumentNo;
                            EmployeeBasic.Death_Father_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                            EmployeeBasic.Death_Father_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                            EmployeeBasic.Death_Father_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                            EmployeeBasic.Death_Father_Doc_Id__c = DeathInfo.deathDocumentUrl;
                            DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(DeathInfo.deathDocumentUrl);
                        }
                        else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Mother)) {
                            EmployeeBasic.Death_Is_Mother_Death__c = application.DeathInfo.isDeathMother;
                            EmployeeBasic.Death_Mother_Title__c = checkEnumValue(DeathInfo.title);
                            EmployeeBasic.Death_Mother_Detail__c = DeathInfo.deathDetail;
                            EmployeeBasic.Death_Mother_FN__c = DeathInfo.thFirstName;
                            EmployeeBasic.Death_Mother_LN__c = DeathInfo.thLastName;
                            EmployeeBasic.Death_Mother_Doc_No__c = DeathInfo.deathDocumentNo;
                            EmployeeBasic.Death_Mother_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                            EmployeeBasic.Death_Mother_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                            EmployeeBasic.Death_Mother_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                            EmployeeBasic.Death_Mother_Doc_Id__c = DeathInfo.deathDocumentUrl;
                            DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(DeathInfo.deathDocumentUrl);
                        }
                        else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Child)) {
                            DeathChilds.add(DeathInfo);
                        }
                    }
                    
                    if(DeathChilds.size() > 0) {
                        
                        for(ESS_EmployeeBasic_DTO.DeathInfoDTO DeathChildInfo : DeathChilds) {
                            EmployeeBasic.Death_Is_Child_Death__c = application.DeathInfo.isDeathChild;
                            DeathChildInfo.deathDocumentDisplayUrl = generateDocumentUrl(DeathChildInfo.deathDocumentUrl);
                        }
                        
                        EmployeeBasic.Death_Child_JSON__c = JSON.serialize(DeathChilds);
                    }
                    
                }
                
                //EducationInfo
                if(application.EducationInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                        if(EducationInfo.isChange) {
                            EmployeeBasic.Is_Update_Education__c = true;
                            break;
                        }
                    }
                    
                    if(application.EducationInfos.size() > 0) {
                        for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                            EducationInfo.transcriptDisplayUrl = generateDocumentUrl(EducationInfo.transcriptUrl);
                            EducationInfo.degreeCertificateDisplayUrl = generateDocumentUrl(EducationInfo.degreeCertificateUrl);
                        }
                    }
                    
                    EmployeeBasic.Education_JSON__c = JSON.serialize(application.EducationInfos);
                }
                else {
                    EmployeeBasic.Education_JSON__c = null;
                    EmployeeBasic.Is_Update_Education__c = false;
                }
                
                //LicenseInfos
                if(application.LicenseInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                        if(LicenseInfo.isChange) {
                            EmployeeBasic.Is_Update_License__c = true;
                            break;
                        }
                    }
                    
                    for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                        if(LicenseInfo.licenseType.value == String.ValueOf(ESS_Enum.LicenseType.Citizen)) {
                            if(LicenseInfo.isChange) {
                                EmployeeBasic.License_Citizen_Change__c = true;
                            }
                            else {
                                EmployeeBasic.License_Citizen_Change__c = false;
                            }
                            EmployeeBasic.License_Citizen_New_Issue_Date__c = LicenseInfo.newIssueDate;
                            EmployeeBasic.License_Citizen_New_Expire_Date__c = LicenseInfo.newExpireDate;
                            EmployeeBasic.License_Citizen_New_Issue_Province__c = LicenseInfo.newIssuedProvince;
                            EmployeeBasic.License_Citizen_Old_Issue_Date__c = LicenseInfo.issueDate;
                            EmployeeBasic.License_Citizen_Old_Expire_Date__c = LicenseInfo.expireDate;
                            EmployeeBasic.License_Citizen_Old_Issue_Province__c = LicenseInfo.issuedProvince;
                            EmployeeBasic.License_Citizen_Id__c = LicenseInfo.citizenId;
                            EmployeeBasic.License_Citizen_Copy_Doc__c = LicenseInfo.documentCitizenCopyUrl;
                            LicenseInfo.documentCitizenCopyDisplayUrl = generateDocumentUrl(LicenseInfo.documentCitizenCopyUrl);
                        }
                        else if(LicenseInfo.licenseType.value == String.ValueOf(ESS_Enum.LicenseType.Professional)) {
                            if(LicenseInfo.isChange) {
                                EmployeeBasic.License_Professional_Change__c = true;
                            }
                            else {
                                EmployeeBasic.License_Professional_Change__c = false;
                            }
                            EmployeeBasic.License_Professional_New_Doc_No__c = LicenseInfo.newLicenseNo;
                            EmployeeBasic.License_Professional_New_Doc_Level__c = LicenseInfo.newLicenseLevel;
                            EmployeeBasic.License_Professional_New_Doc_Issue_Date__c = LicenseInfo.newIssueDate;
                            EmployeeBasic.License_Professional_New_Doc_Expire_Date__c = LicenseInfo.newExpireDate;
                            EmployeeBasic.License_Professional_New_Engineer__c = LicenseInfo.newEngineeringBranch;
                            EmployeeBasic.License_Professional_Old_Doc_No__c = LicenseInfo.licenseNo;
                            EmployeeBasic.License_Professional_Old_Doc_Level__c = LicenseInfo.licenseLevel;
                            EmployeeBasic.License_Professional_Old_Doc_Issue_Date__c = LicenseInfo.issueDate;
                            EmployeeBasic.License_Professional_Old_Doc_Expire_Date__c = LicenseInfo.expireDate;
                            EmployeeBasic.License_Professional_Old_Engineer__c = LicenseInfo.engineeringBranch;
                            EmployeeBasic.License_Professional_Id__c = LicenseInfo.documentProfessionalUrl;
                            LicenseInfo.documentProfessionalDisplayUrl = generateDocumentUrl(LicenseInfo.documentProfessionalUrl);
                        }
                    }
                } 
                
                //AddressInfos
                if(application.AddressInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                        if(AddressInfo.addressType.value == String.ValueOf(ESS_Enum.AddressType.HouseRegistration)) {
                            if(AddressInfo.isChange) {
                                EmployeeBasic.Address_Change__c = true;
                            }
                            else {
                                EmployeeBasic.Address_Change__c = false;
                            }
                            EmployeeBasic.Address_TH_Old_House_No__c = AddressInfo.thHouseNo;
                            EmployeeBasic.Address_TH_Old_Moo_Village_Soi_Road__c = AddressInfo.thMooVillageSoiRoad;
                            EmployeeBasic.Address_TH_Old_SubDistrict_District__c = AddressInfo.thSubDistrictDistrict;
                            EmployeeBasic.Address_TH_Old_Province__c = AddressInfo.thProvince;
                            EmployeeBasic.Address_TH_Old_Postal_Code__c = AddressInfo.thPostalCode;
                            EmployeeBasic.Address_TH_Old_Telephone_No__c = AddressInfo.thTelephoneNo;
                            EmployeeBasic.Address_EN_Old_House_No__c = AddressInfo.enHouseNo;
                            EmployeeBasic.Address_EN_Old_Moo_Village_Soi_Road__c = AddressInfo.enMooVillageSoiRoad;
                            EmployeeBasic.Address_EN_Old_SubDistrict_District__c = AddressInfo.enSubDistrictDistrict;
                            EmployeeBasic.Address_EN_Old_Province__c = AddressInfo.enProvince;
                            EmployeeBasic.Address_EN_Old_Postal_Code__c = AddressInfo.enPostalCode;
                            EmployeeBasic.Address_EN_Old_Telephone_No__c = AddressInfo.enTelephoneNo;
                            
                            EmployeeBasic.Address_TH_New_House_No__c = AddressInfo.newTHHouseNo;
                            EmployeeBasic.Address_TH_New_Moo__c = AddressInfo.newTHMoo;
                            EmployeeBasic.Address_TH_New_Village_Name__c = AddressInfo.newTHVillageName;
                            EmployeeBasic.Address_TH_New_Soi__c = AddressInfo.newTHSoi;
                            EmployeeBasic.Address_TH_New_Road__c = AddressInfo.newTHRoad;
                            EmployeeBasic.Address_TH_New_Sub_District__c = AddressInfo.newTHSubDistrict;
                            EmployeeBasic.Address_TH_New_District__c = AddressInfo.newTHDistrict;
                            EmployeeBasic.Address_TH_New_Province__c = AddressInfo.newTHProvince;
                            EmployeeBasic.Address_TH_New_Postal_Code__c = AddressInfo.newTHPostalCode;
                            EmployeeBasic.Address_TH_New_Telephone_No__c = AddressInfo.newTHTelephoneNo;
                            EmployeeBasic.Address_EN_New_House_No__c = AddressInfo.newENHouseNo;
                            EmployeeBasic.Address_EN_New_Moo__c = AddressInfo.newENMoo;
                            EmployeeBasic.Address_EN_New_Village_Name__c = AddressInfo.newENVillageName;
                            EmployeeBasic.Address_EN_New_Soi__c = AddressInfo.newENSoi;
                            EmployeeBasic.Address_EN_New_Road__c = AddressInfo.newENRoad;
                            EmployeeBasic.Address_EN_New_Sub_District__c = AddressInfo.newENSubDistrict;
                            EmployeeBasic.Address_EN_New_District__c = AddressInfo.newENDistrict;
                            EmployeeBasic.Address_EN_New_Province__c = AddressInfo.newENProvince;
                            EmployeeBasic.Address_EN_New_Postal_Code__c = AddressInfo.newENPostalCode;
                            EmployeeBasic.Address_EN_New_Telephone_No__c = AddressInfo.newENTelephoneNo;
                            
                            EmployeeBasic.Address_House_Registration_Copy_Id__c = AddressInfo.documentRegistrationCopyUrl;
                            AddressInfo.documentRegistrationCopyDisplayUrl = generateDocumentUrl(AddressInfo.documentRegistrationCopyUrl);
                        }
                        else if(AddressInfo.addressType.value == String.ValueOf(ESS_Enum.AddressType.Current)) {
                            if(AddressInfo.isChange) {
                                EmployeeBasic.Address_Current_Change__c = true;
                            }
                            else {
                                EmployeeBasic.Address_Current_Change__c = false;
                            }
                            EmployeeBasic.Address_TH_Current_Old_House_No__c = AddressInfo.thHouseNo;
                            EmployeeBasic.Address_TH_Current_Old_Moo_Vill_Soi_Road__c = AddressInfo.thMooVillageSoiRoad;
                            EmployeeBasic.Address_TH_Current_Old_SubDis_District__c = AddressInfo.thSubDistrictDistrict;
                            EmployeeBasic.Address_TH_Current_Old_Province__c = AddressInfo.thProvince;
                            EmployeeBasic.Address_TH_Current_Old_Postal_Code__c = AddressInfo.thPostalCode;
                            EmployeeBasic.Address_TH_Current_Old_Telephone_No__c = AddressInfo.thTelephoneNo;
                            EmployeeBasic.Address_EN_Current_Old_House_No__c = AddressInfo.enHouseNo;
                            EmployeeBasic.Address_EN_Current_Old_Moo_Vill_Soi_Road__c = AddressInfo.enMooVillageSoiRoad;
                            EmployeeBasic.Address_EN_Current_Old_SubDis_District__c = AddressInfo.enSubDistrictDistrict;
                            EmployeeBasic.Address_EN_Current_Old_Province__c = AddressInfo.enProvince;
                            EmployeeBasic.Address_EN_Current_Old_Postal_Code__c = AddressInfo.enPostalCode;
                            EmployeeBasic.Address_EN_Current_Old_Telephone_No__c = AddressInfo.enTelephoneNo;
                            
                            EmployeeBasic.Address_TH_Current_New_House_No__c = AddressInfo.newTHHouseNo;
                            EmployeeBasic.Address_TH_Current_New_Moo__c = AddressInfo.newTHMoo;
                            EmployeeBasic.Address_TH_Current_New_Village_Name__c = AddressInfo.newTHVillageName;
                            EmployeeBasic.Address_TH_Current_New_Soi__c = AddressInfo.newTHSoi;
                            EmployeeBasic.Address_TH_Current_New_Road__c = AddressInfo.newTHRoad;
                            EmployeeBasic.Address_TH_Current_New_Sub_District__c = AddressInfo.newTHSubDistrict;
                            EmployeeBasic.Address_TH_Current_New_District__c = AddressInfo.newTHDistrict;
                            EmployeeBasic.Address_TH_Current_New_Province__c = AddressInfo.newTHProvince;
                            EmployeeBasic.Address_TH_Current_New_Postal_Code__c = AddressInfo.newTHPostalCode;
                            EmployeeBasic.Address_TH_Current_New_Telephone_No__c = AddressInfo.newTHTelephoneNo;
                            EmployeeBasic.Address_EN_Current_New_House_No__c = AddressInfo.newENHouseNo;
                            EmployeeBasic.Address_EN_Current_New_Moo__c = AddressInfo.newENMoo;
                            EmployeeBasic.Address_EN_Current_New_Village_Name__c = AddressInfo.newENVillageName;
                            EmployeeBasic.Address_EN_Current_New_Soi__c = AddressInfo.newENSoi;
                            EmployeeBasic.Address_EN_Current_New_Road__c = AddressInfo.newENRoad;
                            EmployeeBasic.Address_EN_Current_New_Sub_District__c = AddressInfo.newENSubDistrict;
                            EmployeeBasic.Address_EN_Current_New_District__c = AddressInfo.newENDistrict;
                            EmployeeBasic.Address_EN_Current_New_Province__c = AddressInfo.newENProvince;
                            EmployeeBasic.Address_EN_Current_New_Postal_Code__c = AddressInfo.newENPostalCode;
                            EmployeeBasic.Address_EN_Current_New_Telephone_No__c = AddressInfo.newENTelephoneNo;
                            
                            EmployeeBasic.Address_Current_Address_Copy_Id__c = AddressInfo.documentRegistrationCopyUrl;
                            AddressInfo.documentRegistrationCopyDisplayUrl = generateDocumentUrl(AddressInfo.documentRegistrationCopyUrl);
                        }
                    }
                    
                    if(EmployeeBasic.Address_Change__c || EmployeeBasic.Address_Current_Change__c) {
                        EmployeeBasic.Is_Update_Address__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Address__c = false;
                    }
                }
                
                //ContactInfos
                if(application.ContactPersonInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : application.ContactPersonInfos) {
                        if(ContactPersonInfo.isChange) {
                            EmployeeBasic.Is_Update_ContactPerson__c = true;
                            break;
                        }
                    }
                    
                    //Combine Contact Address
                    for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : application.ContactPersonInfos) {
                        if(ContactPersonInfo.isChange) {
                            ContactPersonInfo.thMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.thMoo, ContactPersonInfo.thVillageName, ContactPersonInfo.thSoi, ContactPersonInfo.thRoad);
                            ContactPersonInfo.thDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.thSubDistrict, ContactPersonInfo.thDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                            
                            ContactPersonInfo.enMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.enMoo, ContactPersonInfo.enVillageName, ContactPersonInfo.enSoi, ContactPersonInfo.enRoad);
                            ContactPersonInfo.enDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.enSubDistrict, ContactPersonInfo.enDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                            
                            ContactPersonInfo.newTHMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.newTHMoo, ContactPersonInfo.newTHVillageName, ContactPersonInfo.newTHSoi, ContactPersonInfo.newTHRoad);
                            ContactPersonInfo.newTHDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.newTHSubDistrict, ContactPersonInfo.newTHDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                            
                            ContactPersonInfo.newENMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.newENMoo, ContactPersonInfo.newENVillageName, ContactPersonInfo.newENSoi, ContactPersonInfo.newENRoad);
                            ContactPersonInfo.newENDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.newENSubDistrict, ContactPersonInfo.newENDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                        }
                    }
                    
                    EmployeeBasic.Contact_Person_JSON__c = JSON.serialize(application.ContactPersonInfos);
                    
                }
                else {
                    EmployeeBasic.Contact_Person_JSON__c = null;
                    EmployeeBasic.Is_Update_ContactPerson__c = false;
                }
                
                //Tax
                EmployeeBasic.Is_Update_Tax__c = application.TaxInfo.isChange;
                if(application.TaxInfo.isChange) {
                    date todayDate = date.today();
                    if(todayDate.day() <= 15) {
                        EmployeeBasic.Effective_Date__c = date.newInstance(todayDate.year(), todayDate.month(), 1);
                    }
                    else {
                        EmployeeBasic.Effective_Date__c = date.newInstance(todayDate.year(), todayDate.addMonths(1).month(), 1);
                    }
                }
                string taxMarriageStatus = checkEnumKey(application.TaxInfo.marriedStatus);
                if(taxMarriageStatus == String.ValueOf(ESS_Enum.MarriedStatus.Single)) {
                    EmployeeBasic.Tax_Marriage_Status__c = '0';
                }
                else if(taxMarriageStatus == String.ValueOf(ESS_Enum.MarriedStatus.Married)) {
                    EmployeeBasic.Tax_Marriage_Status__c = '1';
                }
                
                string marriageEarnIncome = checkEnumKey(application.TaxInfo.marriedPersonEarnIncome);
                if(marriageEarnIncome == String.ValueOf(ESS_Enum.MarriedEarnIncome.MarriedNotEarnIncome)) {
                    EmployeeBasic.Tax_Marriage_Person_Earn_Income__c = '1';
                } 
                else if(marriageEarnIncome == String.ValueOf(ESS_Enum.MarriedEarnIncome.MarriedEarnIncome)) {
                    EmployeeBasic.Tax_Marriage_Person_Earn_Income__c = '2';
                } 
                
                EmployeeBasic.Tax_Child_Count__c = application.TaxInfo.childCount;
                EmployeeBasic.Tax_Total_Child_Count__c = application.TaxInfo.childCountTotal;
                EmployeeBasic.Tax_Self_Life_Insurance_Paid_Amount__c = application.TaxInfo.selfLifeInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Life_Insurance_Paid_Amount__c = application.TaxInfo.marriedLifeInsurancePaidAmount;
                EmployeeBasic.Tax_Self_Father_Insurance_Paid_Amount__c = application.TaxInfo.selfFatherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Self_Mother_Insurance_Paid_Amount__c = application.TaxInfo.selfMotherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Father_Insurance_Paid_Amount__c = application.TaxInfo.marriedFatherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Mother_Insurance_Paid_Amount__c = application.TaxInfo.marriedMotherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Interest_On_Loan_For_House_Amount__c = application.TaxInfo.interestOnLoanForHouseAmount;
                EmployeeBasic.Tax_Income_From_RMF_Amount__c = application.TaxInfo.incomeFromRMFAmount;
                EmployeeBasic.Tax_Income_From_SSF_Amount__c = application.TaxInfo.incomeFromSSFAmount;
                EmployeeBasic.Tax_Self_Deduction_Father_Amount__c = application.TaxInfo.selfTaxDeductionFatherAmount;
                EmployeeBasic.Tax_Self_Deduction_Mother_Amount__c = application.TaxInfo.selfTaxDeductionMotherAmount;
                EmployeeBasic.Tax_Married_Deduction_Father_Amount__c = application.TaxInfo.marriedTaxDeductionFatherAmount;
                EmployeeBasic.Tax_Married_Deduction_Mother_Amount__c = application.TaxInfo.marriedTaxDeductionMotherAmount;
                EmployeeBasic.Tax_Donation_For_Charity_Amount__c = application.TaxInfo.donationForCharityAmount;
                EmployeeBasic.Tax_Sponsor_Amount__c = application.TaxInfo.sponsorAmount;
                EmployeeBasic.Tax_Donation_For_Education_Amount__c = application.TaxInfo.donationForEducationAmount;
                EmployeeBasic.Tax_Annuity_Interest_Amount__c = application.TaxInfo.annuityInterestAmount;
                EmployeeBasic.Tax_First_House_Exclude_Tax_Amount__c = application.TaxInfo.firstHouseExcludeTaxAmount;
                EmployeeBasic.Tax_Pregnancy_Care_Amount__c = application.TaxInfo.pregnancyCareAmount;
                    
                try {
                    insert(EmployeeBasic);
                    application.applicationHeaderInfo.documentNo = EmployeeBasic.Document_No__c;
                    application.id = EmployeeBasic.id;
                }
                catch(DmlException e) {
                	System.debug(e);
                }
                
            }
            else if(application.id != null || application.id != 'null') {
                
                string currentStatus = ApplicationCurrentStatus(application.id);
                if(application.isProcessingVerify == null) {
                    application.isProcessingVerify = false;
                }
                if(currentStatus == ESS_Enum.ApplicationStatus.Submitted.name() && !application.isProcessingVerify) {
                    throw new ESS_Exception('[MyError]This appliation status has been changed and cannot be save.');
                }
                else if(currentStatus == ESS_Enum.ApplicationStatus.Cancelled.name()) {
                    throw new ESS_Exception('[MyError]This appliation status has been changed and cannot be save.');
                }
                else if(currentStatus == ESS_Enum.ApplicationStatus.Verified.name()) {
                    throw new ESS_Exception('[MyError]This appliation status has been changed and cannot be save.');
                }
                
                ESS_Application__c EmployeeBasic = [select id, ownerid, status__c from ESS_Application__c where Id =: application.id AND 
                                               (Status__c =: String.ValueOf(ESS_Enum.ApplicationStatus.Draft) OR Status__c =: String.ValueOf(ESS_Enum.ApplicationStatus.Submitted) )];
            
                ownerId = EmployeeBasic.OwnerId;
                employeeBasicStatus = EmployeeBasic.Status__c;
                
                //NameInfo
                EmployeeBasic.Is_Update_Name__c = application.NameInfo.isChange;
                
                EmployeeBasic.Name_Change_Employee__c = application.NameInfo.editSelfInfo;
                EmployeeBasic.Name_Change_Marriage__c = application.NameInfo.editMarriedInfo;
                EmployeeBasic.Name_Change_Child__c = application.NameInfo.editChildInfo;
                EmployeeBasic.Name_Change_Father__c = application.NameInfo.editFatherInfo;
                EmployeeBasic.Name_Change_Mother__c = application.NameInfo.editMotherInfo;
                
                //NameInfo - Employee
                EmployeeBasic.Name_Emp_TH_Old_Title_FN_LN__c = application.NameInfo.employeeInfo.oldTHTitleFNLN;
                
                string nameEmpENOldTitle = checkEnumKey(application.NameInfo.employeeInfo.oldENTitle);
                EmployeeBasic.Name_Emp_EN_Old_Title__c = assignSFTitle(nameEmpENOldTitle);
                EmployeeBasic.Name_Emp_EN_Old_FN__c = application.NameInfo.employeeInfo.oldENFirstName;
                EmployeeBasic.Name_Emp_EN_Old_LN__c = application.NameInfo.employeeInfo.oldENLastName;
                
                string nameEmpTHNewTitle = checkEnumKey(application.NameInfo.employeeInfo.newTHTitle);
                EmployeeBasic.Name_Emp_TH_New_Title__c = assignSFTitle(nameEmpTHNewTitle);
                EmployeeBasic.Name_Emp_TH_New_FN__c = application.NameInfo.employeeInfo.newTHFirstName;
                EmployeeBasic.Name_Emp_TH_New_LN__c = application.NameInfo.employeeInfo.newTHLastName;
                
                string nameEmpENNewTitle = checkEnumKey(application.NameInfo.employeeInfo.newENTitle);
                EmployeeBasic.Name_Emp_EN_New_Title__c = assignSFTitle(nameEmpENNewTitle);
                EmployeeBasic.Name_Emp_EN_New_FN__c = application.NameInfo.employeeInfo.newENFirstName;
                EmployeeBasic.Name_Emp_EN_New_LN__c = application.NameInfo.employeeInfo.newENLastName;
                EmployeeBasic.Name_Emp_Change_Doc_No__c = application.NameInfo.employeeInfo.documentChangeNameNo;
                EmployeeBasic.Name_Emp_Change_Doc_Location__c = application.NameInfo.employeeInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Emp_Change_Doc_Province__c = application.NameInfo.employeeInfo.documentChangeNameProvince;
                
                if(application.NameInfo.employeeInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Emp_Change_Doc_Date__c = application.NameInfo.employeeInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Emp_Change_Doc_Id__c = application.NameInfo.employeeInfo.documentUploadedUrl;
                application.NameInfo.employeeInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Emp_Change_Doc_Id__c);
                
                EmployeeBasic.Name_Emp_Citizen_Copy_Id__c = application.NameInfo.employeeInfo.documentCopyCitizenUrl;
                application.NameInfo.employeeInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Emp_Citizen_Copy_Id__c);
                
                //NameInfo - Married
                string nameMarriageTHOldTitle = checkEnumKey(application.NameInfo.statusInfo.oldTHTitle);
                EmployeeBasic.Name_Marriage_TH_Old_Title__c = assignSFTitle(nameMarriageTHOldTitle);
                EmployeeBasic.Name_Marriage_TH_Old_FN__c = application.NameInfo.statusInfo.oldTHFirstName;
                EmployeeBasic.Name_Marriage_TH_Old_LN__c = application.NameInfo.statusInfo.oldTHLastName;
                
                string nameMarriageENOldTitle = checkEnumKey(application.NameInfo.statusInfo.oldENTitle);
                EmployeeBasic.Name_Marriage_EN_Old_Title__c = assignSFTitle(nameMarriageENOldTitle);
                EmployeeBasic.Name_Marriage_EN_Old_FN__c = application.NameInfo.statusInfo.oldENFirstName;
                EmployeeBasic.Name_Marriage_EN_Old_LN__c = application.NameInfo.statusInfo.oldENLastName;
                
                string nameMarriageTHNewTitle = checkEnumKey(application.NameInfo.statusInfo.thTitle);
                EmployeeBasic.Name_Marriage_TH_New_Title__c = assignSFTitle(nameMarriageTHNewTitle);
                EmployeeBasic.Name_Marriage_TH_New_FN__c = application.NameInfo.statusInfo.thFirstName;
                EmployeeBasic.Name_Marriage_TH_New_LN__c = application.NameInfo.statusInfo.thLastName;
                
                string nameMarriageENNewTitle = checkEnumKey(application.NameInfo.statusInfo.enTitle);
                EmployeeBasic.Name_Marriage_EN_New_Title__c = assignSFTitle(nameMarriageENNewTitle);
                EmployeeBasic.Name_Marriage_EN_New_FN__c = application.NameInfo.statusInfo.enFirstName;
                EmployeeBasic.Name_Marriage_EN_New_LN__c = application.NameInfo.statusInfo.enLastName;
                EmployeeBasic.Name_Marriage_Change_Doc_No__c = application.NameInfo.statusInfo.documentChangeNameNo;
                EmployeeBasic.Name_Marriage_Change_Doc_Location__c = application.NameInfo.statusInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Marriage_Change_Doc_Province__c = application.NameInfo.statusInfo.documentChangeNameProvince;
                
                if(application.NameInfo.statusInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Marriage_Change_Doc_Date__c = application.NameInfo.statusInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Marriage_Change_Doc_Id__c = application.NameInfo.statusInfo.documentUploadedUrl;
                application.NameInfo.statusInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Marriage_Change_Doc_Id__c);
                
                EmployeeBasic.Name_Marriage_Citizen_Copy_Id__c = application.NameInfo.statusInfo.documentCopyCitizenUrl;
                application.NameInfo.statusInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Marriage_Citizen_Copy_Id__c);
                
                //NameInfo - Child
                if(application.NameInfo.childInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.NameInfo.childInfos) {
                        childInfo.documentChangeFirstNameLastNameDisplayUrl = generateDocumentUrl(childInfo.documentChangeFirstNameLastNameUrl);
                        childInfo.documentBirthCertificateDisplayUrl = generateDocumentUrl(childInfo.documentBirthCertificateUrl);
                        childInfo.documentBirthProtegeDisplayUrl = generateDocumentUrl(childInfo.documentBirthProtegeUrl);
                        childInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(childInfo.documentCopyCitizenUrl);
                    }
                }
                
                EmployeeBasic.Name_Child_JSON__c = JSON.serialize(application.NameInfo.childInfos);
                EmployeeBasic.Name_Child_Count__c = application.NameInfo.childCount;
                
                //NameInfo - Father
                string nameFatherTHOldTitle = checkEnumKey(application.NameInfo.fatherInfo.oldTHTitle);
                EmployeeBasic.Name_Father_TH_Old_Title__c = assignSFTitle(nameFatherTHOldTitle);
                EmployeeBasic.Name_Father_TH_Old_FN__c = application.NameInfo.fatherInfo.oldTHFirstName;
                EmployeeBasic.Name_Father_TH_Old_LN__c = application.NameInfo.fatherInfo.oldTHLastName;
                
                string nameFatherENOldTitle = checkEnumKey(application.NameInfo.fatherInfo.oldENTitle);
                EmployeeBasic.Name_Father_EN_Old_Title__c = assignSFTitle(nameFatherENOldTitle);
                EmployeeBasic.Name_Father_EN_Old_FN__c = application.NameInfo.fatherInfo.oldENFirstName;
                EmployeeBasic.Name_Father_EN_Old_LN__c = application.NameInfo.fatherInfo.oldENLastName;
                
                string nameFatherTHNewTitle = checkEnumKey(application.NameInfo.fatherInfo.newTHTitle);
                EmployeeBasic.Name_Father_TH_New_Title__c = assignSFTitle(nameFatherTHNewTitle);
                EmployeeBasic.Name_Father_TH_New_FN__c = application.NameInfo.fatherInfo.newTHFirstName;
                EmployeeBasic.Name_Father_TH_New_LN__c = application.NameInfo.fatherInfo.newTHLastName;
                
                string nameFatherENNewTitle = checkEnumKey(application.NameInfo.fatherInfo.newENTitle);
                EmployeeBasic.Name_Father_EN_New_Title__c = assignSFTitle(nameFatherENNewTitle);
                EmployeeBasic.Name_Father_EN_New_FN__c = application.NameInfo.fatherInfo.newENFirstName;
                EmployeeBasic.Name_Father_EN_New_LN__c = application.NameInfo.fatherInfo.newENLastName;
                EmployeeBasic.Name_Father_Change_Doc_No__c = application.NameInfo.fatherInfo.documentChangeNameNo;
                EmployeeBasic.Name_Father_Change_Doc_Location__c = application.NameInfo.fatherInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Father_Change_Doc_Province__c = application.NameInfo.fatherInfo.documentChangeNameProvince;
                
                if(application.NameInfo.fatherInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Father_Change_Doc_Date__c = application.NameInfo.fatherInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Father_Change_Doc_Id__c = application.NameInfo.fatherInfo.documentUploadedUrl;
                application.NameInfo.fatherInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Father_Change_Doc_Id__c);
                
                EmployeeBasic.Name_Father_Citizen_Copy_Id__c = application.NameInfo.fatherInfo.documentCopyCitizenUrl;
                application.NameInfo.fatherInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Father_Citizen_Copy_Id__c);
                
                //NameInfo - Mother
                string nameMotherTHOldTitle = checkEnumKey(application.NameInfo.motherInfo.oldTHTitle);
                EmployeeBasic.Name_Mother_TH_Old_Title__c = assignSFTitle(nameMotherTHOldTitle);
                EmployeeBasic.Name_Mother_TH_Old_FN__c = application.NameInfo.motherInfo.oldTHFirstName;
                EmployeeBasic.Name_Mother_TH_Old_LN__c = application.NameInfo.motherInfo.oldTHLastName;
                
                string nameMotherENOldTitle = checkEnumKey(application.NameInfo.motherInfo.oldENTitle);
                EmployeeBasic.Name_Mother_EN_Old_Title__c = assignSFTitle(nameMotherENOldTitle);
                EmployeeBasic.Name_Mother_EN_Old_FN__c = application.NameInfo.motherInfo.oldENFirstName;
                EmployeeBasic.Name_Mother_EN_Old_LN__c = application.NameInfo.motherInfo.oldENLastName;
                
                string nameMotherTHNewTitle = checkEnumKey(application.NameInfo.motherInfo.newTHTitle);
                EmployeeBasic.Name_Mother_TH_New_Title__c = assignSFTitle(nameMotherTHNewTitle);
                EmployeeBasic.Name_Mother_TH_New_FN__c = application.NameInfo.motherInfo.newTHFirstName;
                EmployeeBasic.Name_Mother_TH_New_LN__c = application.NameInfo.motherInfo.newTHLastName;
                
                string nameMotherENNewTitle = checkEnumKey(application.NameInfo.motherInfo.newENTitle);
                EmployeeBasic.Name_Mother_EN_New_Title__c = assignSFTitle(nameMotherENNewTitle);
                EmployeeBasic.Name_Mother_EN_New_FN__c = application.NameInfo.motherInfo.newENFirstName;
                EmployeeBasic.Name_Mother_EN_New_LN__c = application.NameInfo.motherInfo.newENLastName;
                EmployeeBasic.Name_Mother_Change_Doc_No__c = application.NameInfo.motherInfo.documentChangeNameNo;
                EmployeeBasic.Name_Mother_Change_Doc_Location__c = application.NameInfo.motherInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Mother_Change_Doc_Province__c = application.NameInfo.motherInfo.documentChangeNameProvince;
                
                if(application.NameInfo.motherInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Mother_Change_Doc_Date__c = application.NameInfo.motherInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Mother_Change_Doc_Id__c = application.NameInfo.motherInfo.documentUploadedUrl;
                application.NameInfo.motherInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Mother_Change_Doc_Id__c);
                
                EmployeeBasic.Name_Mother_Citizen_Copy_Id__c = application.NameInfo.motherInfo.documentCopyCitizenUrl;
                application.NameInfo.motherInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Mother_Citizen_Copy_Id__c);
                    
                //StatusInfo - Marriage
                EmployeeBasic.Is_Update_Status__c = application.StatusInfo.isChange;
                //if(application.StatusInfo.isChange) {
                    EmployeeBasic.Is_Marriage_As_Employee__c = application.StatusInfo.isMarriedPersonAsEmployee;
                    //EmployeeBasic = application.StatusInfo.isMarriedPersonChangeDetail;
                	
                	string statusMarriage = checkEnumKey(application.StatusInfo.marriedStatus);
                	if(statusMarriage == '1') {
                        EmployeeBasic.Status_Marriage_Status__c = '1';
                    } 
                	else if(statusMarriage == '3') {
                        EmployeeBasic.Status_Marriage_Status__c = '3';
                    } 
                	else if(statusMarriage == '2') {
                        EmployeeBasic.Status_Marriage_Status__c = '2';
                    } 
                
                    if(application.StatusInfo.isMarriedPersonChangeDetail == null) {
                        EmployeeBasic.Status_Marriage_Change_Detail__c = false;
                    }
                    else {
                        EmployeeBasic.Status_Marriage_Change_Detail__c = application.StatusInfo.isMarriedPersonChangeDetail;
                    }
                	
                	EmployeeBasic.Status_Marriage_Change_Detail__c = application.StatusInfo.isUpdateMarriedStatus;
                	EmployeeBasic.Status_Marriage_Employee_Id__c = application.StatusInfo.marriedEmployeeId;
                
                	string statusMarriageOldTHTitle = checkEnumKey(application.StatusInfo.oldTHTitle);
                	EmployeeBasic.Status_Marriage_TH_Title__c = assignSFTitle(statusMarriageOldTHTitle);
                	if(EmployeeBasic.Status_Marriage_TH_Title__c != null) { 
                        if(EmployeeBasic.Status_Marriage_TH_Title__c != '1') {
                            EmployeeBasic.Status_Marriage_Gender__c = '2';
                        }
                        else {
                            EmployeeBasic.Status_Marriage_Gender__c = '1';
                        }
                    }
                    else {
                        EmployeeBasic.Status_Marriage_Gender__c = '';
                    }
                    EmployeeBasic.Status_Marriage_TH_FN__c = application.StatusInfo.oldTHFirstName;
                    EmployeeBasic.Status_Marriage_TH_LN__c = application.StatusInfo.oldTHLastName;
                    
                	string statusMarriageOldENTitle = checkEnumKey(application.StatusInfo.oldENTitle);
                	EmployeeBasic.Status_Marriage_EN_Title__c = assignSFTitle(statusMarriageOldENTitle);
                	EmployeeBasic.Status_Marriage_EN_FN__c = application.StatusInfo.oldENFirstName;
                    EmployeeBasic.Status_Marriage_EN_LN__c = application.StatusInfo.oldENLastName;
                
                    EmployeeBasic.Status_Marriage_Citizen_Id__c = application.StatusInfo.citizenId;
                    EmployeeBasic.Status_Marriage_DOB__c = application.StatusInfo.dateOfBirth;
                    EmployeeBasic.Status_Marriage_Occupation__c = application.StatusInfo.occupation;
                    EmployeeBasic.Status_Marriage_Doc_No__c = application.StatusInfo.marriedDocumentNo;
                    EmployeeBasic.Status_Marriage_Doc_Issue_Location__c = application.StatusInfo.marriedDocumentIssueLocation;
                    EmployeeBasic.Status_Marriage_Doc_Issue_Province__c = application.StatusInfo.marriedDocumentIssueProvince;
                    EmployeeBasic.Status_Marriage_Doc_Issue_Date__c = application.StatusInfo.marriedDocumentIssueDate;
                    
                	string statusMarriageTHNewTitle = checkEnumKey(application.StatusInfo.newMarriedTHTitle);
                	EmployeeBasic.Status_Marriage_TH_New_Title__c = assignSFTitle(statusMarriageTHNewTitle);
                	string statusMarriageENNewTitle = checkEnumKey(application.StatusInfo.newMarriedENTitle);
                	EmployeeBasic.Status_Marriage_EN_New_Title__c = assignSFTitle(statusMarriageENNewTitle);
                
                    EmployeeBasic.Status_Marriage_TH_New_LN__c = application.StatusInfo.newMarriedTHLastName;
                	EmployeeBasic.Status_Marriage_EN_New_LN__c = application.StatusInfo.newMarriedENLastName;
                
                	if(application.StatusInfo.isChangeTitleAfterMarried == null) {
                        EmployeeBasic.Is_Change_Title_After_Married__c = false;
                    }
                    else {
                        EmployeeBasic.Is_Change_Title_After_Married__c = application.StatusInfo.isChangeTitleAfterMarried;
                        if(application.StatusInfo.isChangeTitleAfterMarried) {
                            EmployeeBasic.Is_Update_Name__c = true;
                            EmployeeBasic.Name_Change_Employee__c = true;
                            //EmployeeBasic.Name_Emp_TH_New_Title__c = EmployeeBasic.Status_Marriage_TH_New_Title__c;
                            //EmployeeBasic.Name_Emp_EN_New_Title__c = EmployeeBasic.Status_Marriage_EN_New_Title__c;
                            //EmployeeBasic.Name_Emp_Change_Doc_Date__c = EmployeeBasic.Status_Marriage_Doc_Issue_Date__c;
                        }
                	}
                	
                    if(application.StatusInfo.isChangeLastNameAfterMarried == null) {
                        EmployeeBasic.Is_Change_LN_After_Married__c = false;
                    }
                    else {
                        EmployeeBasic.Is_Change_LN_After_Married__c  = application.StatusInfo.isChangeLastNameAfterMarried;
                        if(application.StatusInfo.isChangeLastNameAfterMarried) {
                            EmployeeBasic.Is_Update_Name__c = true;
                            EmployeeBasic.Name_Change_Employee__c = true;
                            //EmployeeBasic.Name_Emp_TH_New_LN__c = EmployeeBasic.Status_Marriage_TH_New_LN__c;
                            //EmployeeBasic.Name_Emp_EN_New_LN__c = EmployeeBasic.Status_Marriage_EN_New_LN__c;
                            //EmployeeBasic.Name_Emp_Change_Doc_Date__c = EmployeeBasic.Status_Marriage_Doc_Issue_Date__c;
                        }
                    }
                
                    EmployeeBasic.Status_Marriage_Doc_Id__c = application.StatusInfo.marriedDocumentUrl;
                	application.StatusInfo.marriedDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Doc_Id__c);
                    EmployeeBasic.Status_Marriage_Change_Doc_Id__c = application.StatusInfo.employeeTitleLastnameDocumentUrl;
                	application.StatusInfo.employeeTitleLastnameDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Change_Doc_Id__c);
                    EmployeeBasic.Status_Marriage_Citizen_Id_Copy__c = application.StatusInfo.marriedPersonCopyDocumentUrl;
                	application.StatusInfo.marriedPersonCopyDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Citizen_Id_Copy__c);
                    EmployeeBasic.Status_Marriage_Change_Doc_Copy_Id__c = application.StatusInfo.changeTitleLastnameCopyDocumentUrl;
                	application.StatusInfo.changeTitleLastnameCopyDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Change_Doc_Copy_Id__c);
                    
                    //StatusInfo - Divorced
                    string statusDivorceTHTitle = checkEnumKey(application.StatusInfo.divorcedTHTitle);
                	EmployeeBasic.Status_Divorce_TH_Title__c = assignSFTitle(statusDivorceTHTitle);
                    EmployeeBasic.Status_Divorce_TH_FN__c = application.StatusInfo.divorcedTHFirstName;
                    EmployeeBasic.Status_Divorce_TH_LN__c = application.StatusInfo.divorcedTHLastName;
                    
                	string statusDivorceENTitle = checkEnumKey(application.StatusInfo.divorcedENTitle);
                	EmployeeBasic.Status_Divorce_EN_Title__c = assignSFTitle(statusDivorceENTitle);
                	EmployeeBasic.Status_Divorce_EN_FN__c = application.StatusInfo.divorcedENFirstName;
                    EmployeeBasic.Status_Divorce_EN_LN__c = application.StatusInfo.divorcedENLastName;
                    EmployeeBasic.Status_Divorce_Doc_No__c = application.StatusInfo.divorcedDocumentNo;
                    EmployeeBasic.Status_Divorce_Doc_Issue_Location__c = application.StatusInfo.divorcedDocumentIssueLocation;
                    EmployeeBasic.Status_Divorce_Doc_Issue_Province__c = application.StatusInfo.divorcedDocumentIssueProvince;
                    EmployeeBasic.Status_Divorce_Doc_Issue_Date__c = application.StatusInfo.divorcedDocumentIssueDate;
                    
                	if(application.StatusInfo.isChangeTitleAfterDivorced == null) {
                        EmployeeBasic.Status_Divorce_Change_Title__c = false;
                    }
                    else {
                        EmployeeBasic.Status_Divorce_Change_Title__c = application.StatusInfo.isChangeTitleAfterDivorced;
                        EmployeeBasic.Is_Change_Title_After_Divorced__c = application.StatusInfo.isChangeTitleAfterDivorced;
                    }
                	
                    if(application.StatusInfo.isChangeLastNameAfterDivorced == null) {
                        EmployeeBasic.Status_Divorce_Change_LN__c = false;
                    }
                    else {
                    	EmployeeBasic.Status_Divorce_Change_LN__c = application.StatusInfo.isChangeLastNameAfterDivorced;
                        EmployeeBasic.Is_Change_LN_After_Divorced__c = application.StatusInfo.isChangeLastNameAfterDivorced;
                    }
                
                	string statusDivorceTHNewTitle = checkEnumKey(application.StatusInfo.newDivorcedTHTitle);
                	EmployeeBasic.Status_Divorce_TH_New_Title__c = assignSFTitle(statusDivorceTHNewTitle);
                    EmployeeBasic.Status_Divorce_TH_New_LN__c = application.StatusInfo.newDivorcedTHLastName;
                    
                	string statusDivorceENNewTitle = checkEnumKey(application.StatusInfo.newDivorcedENTitle);
                	EmployeeBasic.Status_Divorce_EN_New_Title__c = assignSFTitle(statusDivorceENNewTitle);
                	EmployeeBasic.Status_Divorce_EN_New_LN__c = application.StatusInfo.newDivorcedENLastName;
                    EmployeeBasic.Status_Divorce_Doc_Id__c = application.StatusInfo.divorcedDocumentUrl;
                	application.StatusInfo.divorcedDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Divorce_Doc_Id__c);
                    EmployeeBasic.Status_Divorce_Change_Detail_Id__c = application.StatusInfo.divorcedChangeTitleLastNameUrl;
                	application.StatusInfo.divorcedChangeTitleLastNameDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Divorce_Change_Detail_Id__c);
                    EmployeeBasic.Status_Divorce_Use_Detail_Id__c = application.StatusInfo.divorcedUseChangeTitleLastNameUrl;
                	application.StatusInfo.divorcedUseChangeTitleLastNameDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Divorce_Use_Detail_Id__c);
                    
                    //StatusInfo - Widow
                    EmployeeBasic.Status_Widow_TH_Title__c = checkEnumKey(application.StatusInfo.widowTHTitle);
                    EmployeeBasic.Status_Widow_TH_FN__c = application.StatusInfo.widowTHFirstName;
                    EmployeeBasic.Status_Widow_TH_LN__c = application.StatusInfo.widowTHLastName;
                    
                	string statusWidowENTitle = checkEnumKey(application.StatusInfo.widowENTitle);
                	EmployeeBasic.Status_Widow_EN_Title__c = assignSFTitle(statusWidowENTitle);
                	EmployeeBasic.Status_Widow_EN_FN__c = application.StatusInfo.widowENFirstName;
                    EmployeeBasic.Status_Widow_EN_LN__c = application.StatusInfo.widowENLastName;
                    EmployeeBasic.Status_Widow_Doc_No__c = application.StatusInfo.widowDocumentNo;
                    EmployeeBasic.Status_Widow_Doc_Issue_Location__c = application.StatusInfo.widowDocumentIssueLocation;
                    EmployeeBasic.Status_Widow_Doc_Issue_Province__c = application.StatusInfo.widowDocumentIssueProvince;
                    EmployeeBasic.Status_Widow_Doc_Issue_Date__c = application.StatusInfo.widowDocumentIssueDate;
                    
                	if(application.StatusInfo.isChangeTitleAfterWidow == null) {
                        EmployeeBasic.Status_Widow_Change_Title__c = false;
                    }
                    else {
                        EmployeeBasic.Status_Widow_Change_Title__c = application.StatusInfo.isChangeTitleAfterWidow;
                        EmployeeBasic.Is_Change_Title_After_Widow__c = application.StatusInfo.isChangeTitleAfterWidow;
                    }
                	
                    if(application.StatusInfo.isChangeLastNameAfterWidow == null) {
                        EmployeeBasic.Status_Widow_Change_LN__c = false;
                    }
                    else {
                    	EmployeeBasic.Status_Widow_Change_LN__c = application.StatusInfo.isChangeLastNameAfterWidow;
                        EmployeeBasic.Is_Change_LN_After_Widow__c = application.StatusInfo.isChangeLastNameAfterWidow;
                    }
                
                	string statusWidowTHNewTitle = checkEnumKey(application.StatusInfo.newWidowTHTitle);
                	EmployeeBasic.Status_Widow_TH_New_Title__c = assignSFTitle(statusWidowTHNewTitle);
                    EmployeeBasic.Status_Widow_TH_New_LN__c = application.StatusInfo.newWidowTHLastName;
                    
                	string statusWidowENNewTitle = checkEnumKey(application.StatusInfo.newWidowENTitle);
                	EmployeeBasic.Status_Widow_EN_New_Title__c = assignSFTitle(statusWidowENNewTitle);
                	EmployeeBasic.Status_Widow_EN_New_LN__c = application.StatusInfo.newWidowENLastName;
                    EmployeeBasic.Status_Widow_Doc_Id__c = application.StatusInfo.deathWidowDocumentUrl;
                	application.StatusInfo.deathWidowDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Widow_Doc_Id__c);
                    EmployeeBasic.Status_Widow_Change_Doc_Id__c = application.StatusInfo.deathWidowChangeTitleLastNameUrl;
                	application.StatusInfo.deathWidowChangeTitleLastNameDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Widow_Change_Doc_Id__c);
                    
                //}
                
                //ChildInfo
                if(application.ChildInfos.size() > 0) {
                    boolean isAtleastUpdateChild = false;
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                        if(ChildInfo.isChange) {
                            isAtleastUpdateChild = true;
                        }
                    }
                    
                    if(isAtleastUpdateChild) {
                        EmployeeBasic.Is_Update_Child__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Child__c = false;
                    }
                    
                    if(application.ChildInfos.size() > 0) {
                        EmployeeBasic.Name_Child_Count__c = application.ChildInfos.size();
                        for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                            childInfo.documentChangeFirstNameLastNameDisplayUrl = generateDocumentUrl(childInfo.documentChangeFirstNameLastNameUrl);
                            childInfo.documentBirthCertificateDisplayUrl = generateDocumentUrl(childInfo.documentBirthCertificateUrl);
                            childInfo.documentBirthProtegeDisplayUrl = generateDocumentUrl(childInfo.documentBirthProtegeUrl);
                            childInfo.documentLegitimationDisplayUrl = generateDocumentUrl(childInfo.documentLegitimationUrl);
                            childInfo.documentLegitimationProtegeDisplayUrl = generateDocumentUrl(childInfo.documentLegitimationProtegeUrl);
                        }
                    }
                    
                    EmployeeBasic.Child_JSON__c = String.ValueOf(JSON.serialize(application.ChildInfos));
                    
                }
                else {
                    EmployeeBasic.Child_JSON__c = null;
                    EmployeeBasic.Is_Update_Child__c = false;
                }
                
                //DeathInfo
                EmployeeBasic.Is_Update_Death__c = application.DeathInfo.isChange;
                //if(EmployeeBasic.Is_Update_Death__c) {
                
                    if(application.DeathInfo.DeathInfos.size() > 0) {
                    
                        List<ESS_EmployeeBasic_DTO.DeathInfoDTO> DeathChilds = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
                        
                        for(ESS_EmployeeBasic_DTO.DeathInfoDTO DeathInfo : application.DeathInfo.DeathInfos) {
                            if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Married)) {
                                EmployeeBasic.Death_Is_Marriage_Death__c = application.DeathInfo.isDeathWife;
                                EmployeeBasic.Death_Marriage_Title__c = checkEnumValue(DeathInfo.title);
                                EmployeeBasic.Death_Marriage_FN__c = DeathInfo.thFirstName;
                                EmployeeBasic.Death_Marriage_LN__c = DeathInfo.thLastName;
                                EmployeeBasic.Death_Marriage_Doc_No__c = DeathInfo.deathDocumentNo;
                                EmployeeBasic.Death_Marriage_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                                EmployeeBasic.Death_Marriage_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                                EmployeeBasic.Death_Marriage_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                                EmployeeBasic.Death_Marriage_Doc_Id__c = DeathInfo.deathDocumentUrl;
                                DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(DeathInfo.deathDocumentUrl);
                            }
                            else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Father)) {
                                EmployeeBasic.Death_Is_Father_Death__c = application.DeathInfo.isDeathFather;
                                EmployeeBasic.Death_Father_Title__c = checkEnumValue(DeathInfo.title);
                                EmployeeBasic.Death_Father_FN__c = DeathInfo.thFirstName;
                                EmployeeBasic.Death_Father_LN__c = DeathInfo.thLastName;
                                EmployeeBasic.Death_Father_Doc_No__c = DeathInfo.deathDocumentNo;
                                EmployeeBasic.Death_Father_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                                EmployeeBasic.Death_Father_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                                EmployeeBasic.Death_Father_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                                EmployeeBasic.Death_Father_Doc_Id__c = DeathInfo.deathDocumentUrl;
                            	DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(DeathInfo.deathDocumentUrl);
                            }
                            else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Mother)) {
                                EmployeeBasic.Death_Is_Mother_Death__c = application.DeathInfo.isDeathMother;
                                EmployeeBasic.Death_Mother_Title__c = checkEnumValue(DeathInfo.title);
                                EmployeeBasic.Death_Mother_FN__c = DeathInfo.thFirstName;
                                EmployeeBasic.Death_Mother_LN__c = DeathInfo.thLastName;
                                EmployeeBasic.Death_Mother_Doc_No__c = DeathInfo.deathDocumentNo;
                                EmployeeBasic.Death_Mother_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                                EmployeeBasic.Death_Mother_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                                EmployeeBasic.Death_Mother_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                                EmployeeBasic.Death_Mother_Doc_Id__c = DeathInfo.deathDocumentUrl;
                            	DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(DeathInfo.deathDocumentUrl);
                            }
                            else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Child)) {
                                DeathChilds.add(DeathInfo);
                            }
                        }
                        
                        if(DeathChilds.size() > 0) {
                            
                            for(ESS_EmployeeBasic_DTO.DeathInfoDTO DeathChildInfo : DeathChilds) {
                                EmployeeBasic.Death_Is_Child_Death__c = application.DeathInfo.isDeathChild;
                                DeathChildInfo.deathDocumentDisplayUrl = generateDocumentUrl(DeathChildInfo.deathDocumentUrl);
                            }
                            
                            EmployeeBasic.Death_Child_JSON__c = JSON.serialize(DeathChilds);
                        }
                        
                    }
                //}
                
                //EducationInfo
                if(application.EducationInfos.size() > 0) {
                    boolean isAtleastUpdateEducation = false;
                    for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                        if(EducationInfo.isChange) {
                            isAtleastUpdateEducation = true;
                        }
                    }
                    if(isAtleastUpdateEducation) {
                        EmployeeBasic.Is_Update_Education__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Education__c = false;
                    }
                    
                    if(application.EducationInfos.size() > 0) {
                        for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                            EducationInfo.transcriptDisplayUrl = generateDocumentUrl(EducationInfo.transcriptUrl);
                            EducationInfo.degreeCertificateDisplayUrl = generateDocumentUrl(EducationInfo.degreeCertificateUrl);
                        }
                    }
                    
                    EmployeeBasic.Education_JSON__c = JSON.serialize(application.EducationInfos);
                    
                }
                else {
                    EmployeeBasic.Education_JSON__c = null;
                    EmployeeBasic.Is_Update_Education__c = false;
                }
                
                //LicenseInfos
                if(application.LicenseInfos.size() > 0) {
                    boolean isAtleastUpdateLicense = false;
                    for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                        if(LicenseInfo.isChange) {
                            isAtleastUpdateLicense = true;
                        }
                    }
                    if(isAtleastUpdateLicense) {
                        EmployeeBasic.Is_Update_License__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_License__c = false;
                    }
                    
                    //if(EmployeeBasic.Is_Update_License__c) {
                    	for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                            if(LicenseInfo.licenseType.value == String.ValueOf(ESS_Enum.LicenseType.Citizen)) {
                                if(LicenseInfo.isChange) {
                                    EmployeeBasic.License_Citizen_Change__c = true;
                                }
                                else {
                                    EmployeeBasic.License_Citizen_Change__c = false;
                                }
                                EmployeeBasic.License_Citizen_New_Issue_Date__c = LicenseInfo.newIssueDate;
                                EmployeeBasic.License_Citizen_New_Expire_Date__c = LicenseInfo.newExpireDate;
                                EmployeeBasic.License_Citizen_New_Issue_Province__c = LicenseInfo.newIssuedProvince;
                                EmployeeBasic.License_Citizen_Old_Issue_Date__c = LicenseInfo.issueDate;
                                EmployeeBasic.License_Citizen_Old_Expire_Date__c = LicenseInfo.expireDate;
                                EmployeeBasic.License_Citizen_Old_Issue_Province__c = LicenseInfo.issuedProvince;
                                EmployeeBasic.License_Citizen_Id__c = LicenseInfo.citizenId;
                                EmployeeBasic.License_Citizen_Copy_Doc__c = LicenseInfo.documentCitizenCopyUrl;
                                LicenseInfo.documentCitizenCopyDisplayUrl = generateDocumentUrl(LicenseInfo.documentCitizenCopyUrl);
                            }
                            else if(LicenseInfo.licenseType.value == String.ValueOf(ESS_Enum.LicenseType.Professional)) {
                                if(LicenseInfo.isChange) {
                                    EmployeeBasic.License_Professional_Change__c = true;
                                }
                                else {
                                    EmployeeBasic.License_Professional_Change__c = false;
                                }
                                EmployeeBasic.License_Professional_New_Doc_No__c = LicenseInfo.newLicenseNo;
                                EmployeeBasic.License_Professional_New_Doc_Level__c = LicenseInfo.newLicenseLevel;
                                EmployeeBasic.License_Professional_New_Doc_Issue_Date__c = LicenseInfo.newIssueDate;
                                EmployeeBasic.License_Professional_New_Doc_Expire_Date__c = LicenseInfo.newExpireDate;
                                EmployeeBasic.License_Professional_New_Engineer__c = LicenseInfo.newEngineeringBranch;
                                EmployeeBasic.License_Professional_Old_Doc_No__c = LicenseInfo.licenseNo;
                                EmployeeBasic.License_Professional_Old_Doc_Level__c = LicenseInfo.licenseLevel;
                                EmployeeBasic.License_Professional_Old_Doc_Issue_Date__c = LicenseInfo.issueDate;
                                EmployeeBasic.License_Professional_Old_Doc_Expire_Date__c = LicenseInfo.expireDate;
                                EmployeeBasic.License_Professional_Old_Engineer__c = LicenseInfo.engineeringBranch;
                                EmployeeBasic.License_Professional_Id__c = LicenseInfo.documentProfessionalUrl;
                                LicenseInfo.documentProfessionalDisplayUrl = generateDocumentUrl(LicenseInfo.documentProfessionalUrl);
                            }
                        }
                    //}
                }
                
                //AddressInfos
                if(application.AddressInfos.size() > 0) {
                    
                    for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                        if(AddressInfo.addressType.value == String.ValueOf(ESS_Enum.AddressType.HouseRegistration)) {
                            if(AddressInfo.isChange) {
                                EmployeeBasic.Address_Change__c = true;
                            }
                            else {
                                EmployeeBasic.Address_Change__c = false;
                            }
                            EmployeeBasic.Address_TH_Old_House_No__c = AddressInfo.thHouseNo;
                            EmployeeBasic.Address_TH_Old_Moo_Village_Soi_Road__c = AddressInfo.thMooVillageSoiRoad;
                            EmployeeBasic.Address_TH_Old_SubDistrict_District__c = AddressInfo.thSubDistrictDistrict;
                            EmployeeBasic.Address_TH_Old_Province__c = AddressInfo.thProvince;
                            EmployeeBasic.Address_TH_Old_Postal_Code__c = AddressInfo.thPostalCode;
                            EmployeeBasic.Address_TH_Old_Telephone_No__c = AddressInfo.thTelephoneNo;
                            EmployeeBasic.Address_EN_Old_House_No__c = AddressInfo.enHouseNo;
                            EmployeeBasic.Address_EN_Old_Moo_Village_Soi_Road__c = AddressInfo.enMooVillageSoiRoad;
                            EmployeeBasic.Address_EN_Old_SubDistrict_District__c = AddressInfo.enSubDistrictDistrict;
                            EmployeeBasic.Address_EN_Old_Province__c = AddressInfo.enProvince;
                            EmployeeBasic.Address_EN_Old_Postal_Code__c = AddressInfo.enPostalCode;
                            EmployeeBasic.Address_EN_Old_Telephone_No__c = AddressInfo.enTelephoneNo;
                            
                            EmployeeBasic.Address_TH_New_House_No__c = AddressInfo.newTHHouseNo;
                            EmployeeBasic.Address_TH_New_Moo__c = AddressInfo.newTHMoo;
                            EmployeeBasic.Address_TH_New_Village_Name__c = AddressInfo.newTHVillageName;
                            EmployeeBasic.Address_TH_New_Soi__c = AddressInfo.newTHSoi;
                            EmployeeBasic.Address_TH_New_Road__c = AddressInfo.newTHRoad;
                            EmployeeBasic.Address_TH_New_Sub_District__c = AddressInfo.newTHSubDistrict;
                            EmployeeBasic.Address_TH_New_District__c = AddressInfo.newTHDistrict;
                            EmployeeBasic.Address_TH_New_Province__c = AddressInfo.newTHProvince;
                            EmployeeBasic.Address_TH_New_Postal_Code__c = AddressInfo.newTHPostalCode;
                            EmployeeBasic.Address_TH_New_Telephone_No__c = AddressInfo.newTHTelephoneNo;
                            EmployeeBasic.Address_EN_New_House_No__c = AddressInfo.newENHouseNo;
                            EmployeeBasic.Address_EN_New_Moo__c = AddressInfo.newENMoo;
                            EmployeeBasic.Address_EN_New_Village_Name__c = AddressInfo.newENVillageName;
                            EmployeeBasic.Address_EN_New_Soi__c = AddressInfo.newENSoi;
                            EmployeeBasic.Address_EN_New_Road__c = AddressInfo.newENRoad;
                            EmployeeBasic.Address_EN_New_Sub_District__c = AddressInfo.newENSubDistrict;
                            EmployeeBasic.Address_EN_New_District__c = AddressInfo.newENDistrict;
                            EmployeeBasic.Address_EN_New_Province__c = AddressInfo.newENProvince;
                            EmployeeBasic.Address_EN_New_Postal_Code__c = AddressInfo.newENPostalCode;
                            EmployeeBasic.Address_EN_New_Telephone_No__c = AddressInfo.newENTelephoneNo;
                            
                            EmployeeBasic.Address_House_Registration_Copy_Id__c = AddressInfo.documentRegistrationCopyUrl;
                            AddressInfo.documentRegistrationCopyDisplayUrl = generateDocumentUrl(AddressInfo.documentRegistrationCopyUrl);
                        }
                        else if(AddressInfo.addressType.value == String.ValueOf(ESS_Enum.AddressType.Current)) {
                            if(AddressInfo.isChange) {
                                EmployeeBasic.Address_Current_Change__c = true;
                            }
                            else {
                                EmployeeBasic.Address_Current_Change__c = false;
                            }
                            EmployeeBasic.Address_TH_Current_Old_House_No__c = AddressInfo.thHouseNo;
                            EmployeeBasic.Address_TH_Current_Old_Moo_Vill_Soi_Road__c = AddressInfo.thMooVillageSoiRoad;
                            EmployeeBasic.Address_TH_Current_Old_SubDis_District__c = AddressInfo.thSubDistrictDistrict;
                            EmployeeBasic.Address_TH_Current_Old_Province__c = AddressInfo.thProvince;
                            EmployeeBasic.Address_TH_Current_Old_Postal_Code__c = AddressInfo.thPostalCode;
                            EmployeeBasic.Address_TH_Current_Old_Telephone_No__c = AddressInfo.thTelephoneNo;
                            EmployeeBasic.Address_EN_Current_Old_House_No__c = AddressInfo.enHouseNo;
                            EmployeeBasic.Address_EN_Current_Old_Moo_Vill_Soi_Road__c = AddressInfo.enMooVillageSoiRoad;
                            EmployeeBasic.Address_EN_Current_Old_SubDis_District__c = AddressInfo.enSubDistrictDistrict;
                            EmployeeBasic.Address_EN_Current_Old_Province__c = AddressInfo.enProvince;
                            EmployeeBasic.Address_EN_Current_Old_Postal_Code__c = AddressInfo.enPostalCode;
                            EmployeeBasic.Address_EN_Current_Old_Telephone_No__c = AddressInfo.enTelephoneNo;
                            
                            EmployeeBasic.Address_TH_Current_New_House_No__c = AddressInfo.newTHHouseNo;
                            EmployeeBasic.Address_TH_Current_New_Moo__c = AddressInfo.newTHMoo;
                            EmployeeBasic.Address_TH_Current_New_Village_Name__c = AddressInfo.newTHVillageName;
                            EmployeeBasic.Address_TH_Current_New_Soi__c = AddressInfo.newTHSoi;
                            EmployeeBasic.Address_TH_Current_New_Road__c = AddressInfo.newTHRoad;
                            EmployeeBasic.Address_TH_Current_New_Sub_District__c = AddressInfo.newTHSubDistrict;
                            EmployeeBasic.Address_TH_Current_New_District__c = AddressInfo.newTHDistrict;
                            EmployeeBasic.Address_TH_Current_New_Province__c = AddressInfo.newTHProvince;
                            EmployeeBasic.Address_TH_Current_New_Postal_Code__c = AddressInfo.newTHPostalCode;
                            EmployeeBasic.Address_TH_Current_New_Telephone_No__c = AddressInfo.newTHTelephoneNo;
                            EmployeeBasic.Address_EN_Current_New_House_No__c = AddressInfo.newENHouseNo;
                            EmployeeBasic.Address_EN_Current_New_Moo__c = AddressInfo.newENMoo;
                            EmployeeBasic.Address_EN_Current_New_Village_Name__c = AddressInfo.newENVillageName;
                            EmployeeBasic.Address_EN_Current_New_Soi__c = AddressInfo.newENSoi;
                            EmployeeBasic.Address_EN_Current_New_Road__c = AddressInfo.newENRoad;
                            EmployeeBasic.Address_EN_Current_New_Sub_District__c = AddressInfo.newENSubDistrict;
                            EmployeeBasic.Address_EN_Current_New_District__c = AddressInfo.newENDistrict;
                            EmployeeBasic.Address_EN_Current_New_Province__c = AddressInfo.newENProvince;
                            EmployeeBasic.Address_EN_Current_New_Postal_Code__c = AddressInfo.newENPostalCode;
                            EmployeeBasic.Address_EN_Current_New_Telephone_No__c = AddressInfo.newENTelephoneNo;
                            
                            EmployeeBasic.Address_Current_Address_Copy_Id__c = AddressInfo.documentRegistrationCopyUrl;
                            AddressInfo.documentRegistrationCopyDisplayUrl = generateDocumentUrl(AddressInfo.documentRegistrationCopyUrl);
                        }
                    }
                    
                    if(EmployeeBasic.Address_Change__c || EmployeeBasic.Address_Current_Change__c) {
                        EmployeeBasic.Is_Update_Address__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Address__c = false;
                    }
                }
                
                //ContactInfos
                if(application.ContactPersonInfos.size() > 0) {
                    boolean isAtleastUpdateContact = false;
                    for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : application.ContactPersonInfos) {
                        if(ContactPersonInfo.isChange) {
                            isAtleastUpdateContact = true;
                        }
                    }
                    if(isAtleastUpdateContact) {
                        EmployeeBasic.Is_Update_ContactPerson__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_ContactPerson__c = false;
                    }
                    
                    //Combine Contact Address
                    for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : Application.ContactPersonInfos) {
                        if(ContactPersonInfo.isChange) {
                            ContactPersonInfo.thMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.thMoo, ContactPersonInfo.thVillageName, ContactPersonInfo.thSoi, ContactPersonInfo.thRoad);
                            ContactPersonInfo.thDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.thSubDistrict, ContactPersonInfo.thDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                            
                            ContactPersonInfo.enMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.enMoo, ContactPersonInfo.enVillageName, ContactPersonInfo.enSoi, ContactPersonInfo.enRoad);
                            ContactPersonInfo.enDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.enSubDistrict, ContactPersonInfo.enDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                            
                            ContactPersonInfo.newTHMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.newTHMoo, ContactPersonInfo.newTHVillageName, ContactPersonInfo.newTHSoi, ContactPersonInfo.newTHRoad);
                            ContactPersonInfo.newTHDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.newTHSubDistrict, ContactPersonInfo.newTHDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                            
                            ContactPersonInfo.newENMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.newENMoo, ContactPersonInfo.newENVillageName, ContactPersonInfo.newENSoi, ContactPersonInfo.newENRoad);
                            ContactPersonInfo.newENDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.newENSubDistrict, ContactPersonInfo.newENDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                        }
                    }
                    
                    EmployeeBasic.Contact_Person_JSON__c = JSON.serialize(application.ContactPersonInfos);
                    
                }
                else {
                    EmployeeBasic.Contact_Person_JSON__c = null;
                    EmployeeBasic.Is_Update_ContactPerson__c = false;
                }
                
                //Tax
                EmployeeBasic.Is_Update_Tax__c = application.TaxInfo.isChange;
                if(application.TaxInfo.isChange) {
                    date todayDate = date.today();
                    if(todayDate.day() <= 15) {
                        EmployeeBasic.Effective_Date__c = date.newInstance(todayDate.year(), todayDate.month(), 1);
                    }
                    else {
                        EmployeeBasic.Effective_Date__c = date.newInstance(todayDate.year(), todayDate.addMonths(1).month(), 1);
                    }
                }
                string taxMarriageStatus = checkEnumKey(application.TaxInfo.marriedStatus);
                if(taxMarriageStatus == String.ValueOf(ESS_Enum.MarriedStatus.Single)) {
                    EmployeeBasic.Tax_Marriage_Status__c = '0';
                }
                else if(taxMarriageStatus == String.ValueOf(ESS_Enum.MarriedStatus.Married)) {
                    EmployeeBasic.Tax_Marriage_Status__c = '1';
                }
                
                string marriageEarnIncome = checkEnumKey(application.TaxInfo.marriedPersonEarnIncome);
                
                if(marriageEarnIncome == String.ValueOf(ESS_Enum.MarriedEarnIncome.MarriedNotEarnIncome)) {
                    EmployeeBasic.Tax_Marriage_Person_Earn_Income__c = '1';
                } 
                else if(marriageEarnIncome == String.ValueOf(ESS_Enum.MarriedEarnIncome.MarriedEarnIncome)) {
                    EmployeeBasic.Tax_Marriage_Person_Earn_Income__c = '2';
                } 
                
                EmployeeBasic.Tax_Child_Count__c = application.TaxInfo.childCount;
                EmployeeBasic.Tax_Total_Child_Count__c = application.TaxInfo.childCountTotal;
                EmployeeBasic.Tax_Self_Life_Insurance_Paid_Amount__c = application.TaxInfo.selfLifeInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Life_Insurance_Paid_Amount__c = application.TaxInfo.marriedLifeInsurancePaidAmount;
                EmployeeBasic.Tax_Self_Father_Insurance_Paid_Amount__c = application.TaxInfo.selfFatherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Self_Mother_Insurance_Paid_Amount__c = application.TaxInfo.selfMotherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Father_Insurance_Paid_Amount__c = application.TaxInfo.marriedFatherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Mother_Insurance_Paid_Amount__c = application.TaxInfo.marriedMotherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Interest_On_Loan_For_House_Amount__c = application.TaxInfo.interestOnLoanForHouseAmount;
                EmployeeBasic.Tax_Income_From_RMF_Amount__c = application.TaxInfo.incomeFromRMFAmount;
                EmployeeBasic.Tax_Income_From_SSF_Amount__c = application.TaxInfo.incomeFromSSFAmount;
                EmployeeBasic.Tax_Self_Deduction_Father_Amount__c = application.TaxInfo.selfTaxDeductionFatherAmount;
                EmployeeBasic.Tax_Self_Deduction_Mother_Amount__c = application.TaxInfo.selfTaxDeductionMotherAmount;
                EmployeeBasic.Tax_Married_Deduction_Father_Amount__c = application.TaxInfo.marriedTaxDeductionFatherAmount;
                EmployeeBasic.Tax_Married_Deduction_Mother_Amount__c = application.TaxInfo.marriedTaxDeductionMotherAmount;
                EmployeeBasic.Tax_Donation_For_Charity_Amount__c = application.TaxInfo.donationForCharityAmount;
                EmployeeBasic.Tax_Sponsor_Amount__c = application.TaxInfo.sponsorAmount;
                EmployeeBasic.Tax_Donation_For_Education_Amount__c = application.TaxInfo.donationForEducationAmount;
                EmployeeBasic.Tax_Annuity_Interest_Amount__c = application.TaxInfo.annuityInterestAmount;
                EmployeeBasic.Tax_First_House_Exclude_Tax_Amount__c = application.TaxInfo.firstHouseExcludeTaxAmount;
                EmployeeBasic.Tax_Pregnancy_Care_Amount__c = application.TaxInfo.pregnancyCareAmount;

                try {
                    update(EmployeeBasic);
                }
                catch(DmlException e) {
                    System.debug(e);
                }
                
            }
            else {
                throw new ESS_Exception(
                    		'[MyError]Cannot save application. Application not found.'); 
            }
            
        }
        catch(DmlException e) {
            throw new ESS_Exception(
                    		'[MyError]SaveApplication exception has occurred: ' + e.getMessage()); 
        }
        
        return application;
    }
    
    @RemoteAction
    public static ESS_EmployeeBasic_DTO.ApplicationDTO SubmitApplication(ESS_EmployeeBasic_DTO.ApplicationDTO application) {
        
        string employeeBasicStatus;
        string ownerId;
        
        try {
            
            if(application.id == null || application.id == 'null') {
                
                PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
                
                //Insert into Application
                ESS_Application__c EmployeeBasic = new ESS_Application__c();
                
                //Header
                string runningNo = ESS_LogicHandler.GenerateRunningNo('Application');
                string year = ESS_LogicHandler.GetCurrentYear();
                string month = ESS_LogicHandler.GetCurrentMonth();
                
                EmployeeBasic.Document_No__c = 'ETI-' + year + '-' + month + '-' + runningNo;
                EmployeeBasic.OwnerId = userId;
                EmployeeBasic.Employee_ID__c = PISUser.EmployeeID__c;
                EmployeeBasic.Employee_Name__c = PISUser.EN_Fullname__c;
                EmployeeBasic.Position__c = PISUser.OBJENFULLNAME__c;
                EmployeeBasic.Unit__c = PISUser.UNITS__c;
                EmployeeBasic.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Submitted);
                EmployeeBasic.Verify_By__c = assignToAdmin();
                EmployeeBasic.Submitted_Date__c = date.today();
                EmployeeBasic.Company_Name__c = PISUser.COMPANYNAME__c;
                EmployeeBasic.Function__c = PISUser.FUNCTION__c;
                EmployeeBasic.Department__c = PISUser.DEPARTMENT__c;
                EmployeeBasic.Section__c = PISUser.SECTIONS__c;
                EmployeeBasic.Unit__c = PISUser.UNITS__c;
                
                ownerId = EmployeeBasic.OwnerId;
                employeeBasicStatus = EmployeeBasic.Status__c;
                
                //NameInfo
                EmployeeBasic.Is_Update_Name__c = application.NameInfo.isChange;
                
                EmployeeBasic.Name_Change_Employee__c = application.NameInfo.editSelfInfo;
                EmployeeBasic.Name_Change_Marriage__c = application.NameInfo.editMarriedInfo;
                EmployeeBasic.Name_Change_Child__c = application.NameInfo.editChildInfo;
                EmployeeBasic.Name_Change_Father__c = application.NameInfo.editFatherInfo;
                EmployeeBasic.Name_Change_Mother__c = application.NameInfo.editMotherInfo;
                
                //NameInfo - Employee
                EmployeeBasic.Name_Emp_TH_Old_Title_FN_LN__c = application.NameInfo.employeeInfo.oldTHTitleFNLN;
                
                string nameEmpENOldTitle = checkEnumKey(application.NameInfo.employeeInfo.oldENTitle);
                EmployeeBasic.Name_Emp_EN_Old_Title__c = assignSFTitle(nameEmpENOldTitle);
                EmployeeBasic.Name_Emp_EN_Old_FN__c = application.NameInfo.employeeInfo.oldENFirstName;
                EmployeeBasic.Name_Emp_EN_Old_LN__c = application.NameInfo.employeeInfo.oldENLastName;
                
                string nameEmpTHNewTitle = checkEnumKey(application.NameInfo.employeeInfo.newTHTitle);
                EmployeeBasic.Name_Emp_TH_New_Title__c = assignSFTitle(nameEmpTHNewTitle);
                EmployeeBasic.Name_Emp_TH_New_FN__c = application.NameInfo.employeeInfo.newTHFirstName;
                EmployeeBasic.Name_Emp_TH_New_LN__c = application.NameInfo.employeeInfo.newTHLastName;
                
                string nameEmpENNewTitle = checkEnumKey(application.NameInfo.employeeInfo.newENTitle);
                EmployeeBasic.Name_Emp_EN_New_Title__c = assignSFTitle(nameEmpENNewTitle);
                EmployeeBasic.Name_Emp_EN_New_FN__c = application.NameInfo.employeeInfo.newENFirstName;
                EmployeeBasic.Name_Emp_EN_New_LN__c = application.NameInfo.employeeInfo.newENLastName;
                EmployeeBasic.Name_Emp_Change_Doc_No__c = application.NameInfo.employeeInfo.documentChangeNameNo;
                EmployeeBasic.Name_Emp_Change_Doc_Location__c = application.NameInfo.employeeInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Emp_Change_Doc_Province__c = application.NameInfo.employeeInfo.documentChangeNameProvince;
                
                if(application.NameInfo.employeeInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Emp_Change_Doc_Date__c = application.NameInfo.employeeInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Emp_Change_Doc_Id__c = application.NameInfo.employeeInfo.documentUploadedUrl;
                
                //NameInfo - Married
                string nameMarriageTHOldTitle = checkEnumKey(application.NameInfo.statusInfo.oldTHTitle);
                EmployeeBasic.Name_Marriage_TH_Old_Title__c = assignSFTitle(nameMarriageTHOldTitle);
                EmployeeBasic.Name_Marriage_TH_Old_FN__c = application.NameInfo.statusInfo.oldTHFirstName;
                EmployeeBasic.Name_Marriage_TH_Old_LN__c = application.NameInfo.statusInfo.oldTHLastName;
                
                string nameMarriageENOldTitle = checkEnumKey(application.NameInfo.statusInfo.oldENTitle);
                EmployeeBasic.Name_Marriage_EN_Old_Title__c = assignSFTitle(nameMarriageENOldTitle);
                EmployeeBasic.Name_Marriage_EN_Old_FN__c = application.NameInfo.statusInfo.oldENFirstName;
                EmployeeBasic.Name_Marriage_EN_Old_LN__c = application.NameInfo.statusInfo.oldENLastName;
                
                String nameMarriageTHNewTitle = checkEnumKey(application.NameInfo.statusInfo.thTitle);
                EmployeeBasic.Name_Marriage_TH_New_Title__c = assignSFTitle(nameMarriageTHNewTitle);
                EmployeeBasic.Name_Marriage_TH_New_FN__c = application.NameInfo.statusInfo.thFirstName;
                EmployeeBasic.Name_Marriage_TH_New_LN__c = application.NameInfo.statusInfo.thLastName;
                
                string nameMarriageENNewTitle = checkEnumKey(application.NameInfo.statusInfo.enTitle);
                EmployeeBasic.Name_Marriage_EN_New_Title__c = assignSFTitle(nameMarriageENNewTitle);
                EmployeeBasic.Name_Marriage_EN_New_FN__c = application.NameInfo.statusInfo.enFirstName;
                EmployeeBasic.Name_Marriage_EN_New_LN__c = application.NameInfo.statusInfo.enLastName;
                EmployeeBasic.Name_Marriage_Change_Doc_No__c = application.NameInfo.statusInfo.documentChangeNameNo;
                EmployeeBasic.Name_Marriage_Change_Doc_Location__c = application.NameInfo.statusInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Marriage_Change_Doc_Province__c = application.NameInfo.statusInfo.documentChangeNameProvince;
                
                if(application.NameInfo.statusInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Marriage_Change_Doc_Date__c = application.NameInfo.statusInfo.documentChangeNameDate;   
                }
                
                EmployeeBasic.Name_Marriage_Change_Doc_Id__c = application.NameInfo.statusInfo.documentUploadedUrl;
                EmployeeBasic.Name_Emp_Citizen_Copy_Id__c = application.NameInfo.employeeInfo.documentCopyCitizenUrl;
                
                //NameInfo - Child
                EmployeeBasic.Name_Child_JSON__c = JSON.serialize(application.NameInfo.childInfos);
                EmployeeBasic.Name_Child_Count__c = application.NameInfo.childCount;
                
                //NameInfo - Father
                string nameFatherTHOldTitle = checkEnumKey(application.NameInfo.fatherInfo.oldTHTitle);
                EmployeeBasic.Name_Father_TH_Old_Title__c = assignSFTitle(nameFatherTHOldTitle);
                EmployeeBasic.Name_Father_TH_Old_FN__c = application.NameInfo.fatherInfo.oldTHFirstName;
                EmployeeBasic.Name_Father_TH_Old_LN__c = application.NameInfo.fatherInfo.oldTHLastName;
                
                string nameFatherENOldTitle = checkEnumKey(application.NameInfo.fatherInfo.oldENTitle);
                EmployeeBasic.Name_Father_EN_Old_Title__c = assignSFTitle(nameFatherENOldTitle);
                EmployeeBasic.Name_Father_EN_Old_FN__c = application.NameInfo.fatherInfo.oldENFirstName;
                EmployeeBasic.Name_Father_EN_Old_LN__c = application.NameInfo.fatherInfo.oldENLastName;
                
                string nameFatherTHNewTitle = checkEnumKey(application.NameInfo.fatherInfo.newTHTitle);
                EmployeeBasic.Name_Father_TH_New_Title__c = assignSFTitle(nameFatherTHNewTitle);
                EmployeeBasic.Name_Father_TH_New_FN__c = application.NameInfo.fatherInfo.newTHFirstName;
                EmployeeBasic.Name_Father_TH_New_LN__c = application.NameInfo.fatherInfo.newTHLastName;
                
                string nameFatherENNewTitle = checkEnumKey(application.NameInfo.fatherInfo.newENTitle);
                EmployeeBasic.Name_Father_EN_New_Title__c = assignSFTitle(nameFatherENNewTitle);
                EmployeeBasic.Name_Father_EN_New_FN__c = application.NameInfo.fatherInfo.newENFirstName;
                EmployeeBasic.Name_Father_EN_New_LN__c = application.NameInfo.fatherInfo.newENLastName;
                EmployeeBasic.Name_Father_Change_Doc_No__c = application.NameInfo.fatherInfo.documentChangeNameNo;
                EmployeeBasic.Name_Father_Change_Doc_Location__c = application.NameInfo.fatherInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Father_Change_Doc_Province__c = application.NameInfo.fatherInfo.documentChangeNameProvince;
                
                if(application.NameInfo.fatherInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Father_Change_Doc_Date__c = application.NameInfo.fatherInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Father_Change_Doc_Id__c = application.NameInfo.fatherInfo.documentUploadedUrl;
                
                //NameInfo - Mother
                string nameMotherTHOldTitle = checkEnumKey(application.NameInfo.motherInfo.oldTHTitle);
                EmployeeBasic.Name_Mother_TH_Old_Title__c = assignSFTitle(nameMotherTHOldTitle);
                EmployeeBasic.Name_Mother_TH_Old_FN__c = application.NameInfo.motherInfo.oldTHFirstName;
                EmployeeBasic.Name_Mother_TH_Old_LN__c = application.NameInfo.motherInfo.oldTHLastName;
                
                string nameMotherENOldTitle = checkEnumKey(application.NameInfo.motherInfo.oldENTitle);
                EmployeeBasic.Name_Mother_EN_Old_Title__c = assignSFTitle(nameMotherENOldTitle);
                EmployeeBasic.Name_Mother_EN_Old_FN__c = application.NameInfo.motherInfo.oldENFirstName;
                EmployeeBasic.Name_Mother_EN_Old_LN__c = application.NameInfo.motherInfo.oldENLastName;
                
                string nameMotherTHNewTitle = checkEnumKey(application.NameInfo.motherInfo.newTHTitle);
                EmployeeBasic.Name_Mother_TH_New_Title__c = assignSFTitle(nameMotherTHNewTitle);
                EmployeeBasic.Name_Mother_TH_New_FN__c = application.NameInfo.motherInfo.newTHFirstName;
                EmployeeBasic.Name_Mother_TH_New_LN__c = application.NameInfo.motherInfo.newTHLastName;
                
                string nameMotherENNewTitle = checkEnumKey(application.NameInfo.motherInfo.newENTitle);
                EmployeeBasic.Name_Mother_EN_New_Title__c = assignSFTitle(nameMotherENNewTitle);
                EmployeeBasic.Name_Mother_EN_New_FN__c = application.NameInfo.motherInfo.newENFirstName;
                EmployeeBasic.Name_Mother_EN_New_LN__c = application.NameInfo.motherInfo.newENLastName;
                EmployeeBasic.Name_Mother_Change_Doc_No__c = application.NameInfo.motherInfo.documentChangeNameNo;
                EmployeeBasic.Name_Mother_Change_Doc_Location__c = application.NameInfo.motherInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Mother_Change_Doc_Province__c = application.NameInfo.motherInfo.documentChangeNameProvince;
                
                if(application.NameInfo.motherInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Mother_Change_Doc_Date__c = application.NameInfo.motherInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Mother_Change_Doc_Id__c = application.NameInfo.motherInfo.documentUploadedUrl;
                
                //StatusInfo - Marriage
                EmployeeBasic.Is_Update_Status__c = application.StatusInfo.isChange;
                EmployeeBasic.Is_Marriage_As_Employee__c = application.StatusInfo.isMarriedPersonAsEmployee;
                EmployeeBasic.Old_Is_Marriage_As_Employee__c = application.StatusInfo.OldIsMarriedPersonAsEmployee;
                //EmployeeBasic = application.StatusInfo.isMarriedPersonChangeDetail;
                EmployeeBasic.Status_Marriage_Status__c = checkEnumKey(application.StatusInfo.marriedStatus);
                
                EmployeeBasic.Status_Marriage_Change_Detail__c = application.StatusInfo.isUpdateMarriedStatus;
                EmployeeBasic.Status_Marriage_Employee_Id__c = application.StatusInfo.marriedEmployeeId;
                
                string statusMarriageTHTitle = checkEnumKey(application.StatusInfo.oldTHTitle);
                EmployeeBasic.Status_Marriage_TH_Title__c = assignSFTitle(statusMarriageTHTitle);
                if(EmployeeBasic.Status_Marriage_TH_Title__c != null) { 
                    if(EmployeeBasic.Status_Marriage_TH_Title__c != '1') {
                        EmployeeBasic.Status_Marriage_Gender__c = '2';
                    }
                    else {
                        EmployeeBasic.Status_Marriage_Gender__c = '1';
                    }
                }
                else {
                    EmployeeBasic.Status_Marriage_Gender__c = '';
                }
                EmployeeBasic.Status_Marriage_TH_FN__c = application.StatusInfo.oldTHFirstName;
                EmployeeBasic.Status_Marriage_TH_LN__c = application.StatusInfo.oldTHLastName;
                
                string statusMarriageENTitle = checkEnumKey(application.StatusInfo.oldENTitle);
                EmployeeBasic.Status_Marriage_EN_Title__c = assignSFTitle(statusMarriageENTitle);
                EmployeeBasic.Status_Marriage_EN_FN__c = application.StatusInfo.oldENFirstName;
                EmployeeBasic.Status_Marriage_EN_LN__c = application.StatusInfo.oldENLastName;
                EmployeeBasic.Status_Marriage_Citizen_Id__c = application.StatusInfo.citizenId;
                EmployeeBasic.Status_Marriage_DOB__c = application.StatusInfo.dateOfBirth;
                EmployeeBasic.Status_Marriage_Occupation__c = application.StatusInfo.occupation;
                EmployeeBasic.Status_Marriage_Doc_No__c = application.StatusInfo.marriedDocumentNo;
                EmployeeBasic.Status_Marriage_Doc_Issue_Location__c = application.StatusInfo.marriedDocumentIssueLocation;
                EmployeeBasic.Status_Marriage_Doc_Issue_Province__c = application.StatusInfo.marriedDocumentIssueProvince;
                EmployeeBasic.Status_Marriage_Doc_Issue_Date__c = application.StatusInfo.marriedDocumentIssueDate;
                
                string statusMarriageTHNewTitle = checkEnumKey(application.StatusInfo.newMarriedTHTitle);
                string statusMarriageENNewTitle = checkEnumKey(application.StatusInfo.newMarriedENTitle);
                EmployeeBasic.Status_Marriage_EN_New_Title__c = assignSFTitle(statusMarriageENNewTitle);
                
                EmployeeBasic.Status_Marriage_TH_New_LN__c = application.StatusInfo.newMarriedTHLastName;
                EmployeeBasic.Status_Marriage_EN_New_LN__c = application.StatusInfo.newMarriedENLastName;
                
                if(application.StatusInfo.isChangeTitleAfterMarried == null) {
                    EmployeeBasic.Is_Change_Title_After_Married__c = false;
                }
                else {
                    EmployeeBasic.Is_Change_Title_After_Married__c = application.StatusInfo.isChangeTitleAfterMarried;
                    if(application.StatusInfo.isChangeTitleAfterMarried) {
                        EmployeeBasic.Is_Update_Name__c = true;
                        EmployeeBasic.Name_Change_Employee__c = true;
                    }
                }
                
                if(application.StatusInfo.isChangeLastNameAfterMarried == null) {
                    EmployeeBasic.Is_Change_LN_After_Married__c = false;
                }
                else {
                    EmployeeBasic.Is_Change_LN_After_Married__c  = application.StatusInfo.isChangeLastNameAfterMarried;
                    if(application.StatusInfo.isChangeLastNameAfterMarried) {
                        EmployeeBasic.Is_Update_Name__c = true;
                        EmployeeBasic.Name_Change_Employee__c = true;
                    }
                }
                
                EmployeeBasic.Status_Marriage_Doc_Id__c = application.StatusInfo.marriedDocumentUrl;
                EmployeeBasic.Status_Marriage_Change_Doc_Id__c = application.StatusInfo.employeeTitleLastnameDocumentUrl;
                EmployeeBasic.Status_Marriage_Citizen_Id_Copy__c = application.StatusInfo.marriedPersonCopyDocumentUrl;
                EmployeeBasic.Status_Marriage_Change_Doc_Copy_Id__c = application.StatusInfo.changeTitleLastnameCopyDocumentUrl;
                
                //StatusInfo - Divorced
                string statusDivorceTHTitle = checkEnumKey(application.StatusInfo.divorcedTHTitle);
                EmployeeBasic.Status_Divorce_TH_Title__c = assignSFTitle(statusDivorceTHTitle);
                EmployeeBasic.Status_Divorce_TH_FN__c = application.StatusInfo.divorcedTHFirstName;
                EmployeeBasic.Status_Divorce_TH_LN__c = application.StatusInfo.divorcedTHLastName;
                
                string statusDivorceENTitle = checkEnumKey(application.StatusInfo.divorcedENTitle);
                EmployeeBasic.Status_Divorce_EN_Title__c = assignSFTitle(statusDivorceENTitle);
                EmployeeBasic.Status_Divorce_EN_FN__c = application.StatusInfo.divorcedENFirstName;
                EmployeeBasic.Status_Divorce_EN_LN__c = application.StatusInfo.divorcedENLastName;
                EmployeeBasic.Status_Divorce_Doc_No__c = application.StatusInfo.divorcedDocumentNo;
                EmployeeBasic.Status_Divorce_Doc_Issue_Location__c = application.StatusInfo.divorcedDocumentIssueLocation;
                EmployeeBasic.Status_Divorce_Doc_Issue_Province__c = application.StatusInfo.divorcedDocumentIssueProvince;
                EmployeeBasic.Status_Divorce_Doc_Issue_Date__c = application.StatusInfo.divorcedDocumentIssueDate;
                
                if(application.StatusInfo.isChangeTitleAfterDivorced == null) {
                    EmployeeBasic.Status_Divorce_Change_Title__c = false;
                }
                else {
                    EmployeeBasic.Status_Divorce_Change_Title__c = application.StatusInfo.isChangeTitleAfterDivorced;
                    EmployeeBasic.Is_Change_Title_After_Divorced__c = application.StatusInfo.isChangeTitleAfterDivorced;
                }
                
                if(application.StatusInfo.isChangeLastNameAfterDivorced == null) {
                    EmployeeBasic.Status_Divorce_Change_LN__c = false;
                }
                else {
                    EmployeeBasic.Status_Divorce_Change_LN__c = application.StatusInfo.isChangeLastNameAfterDivorced;
                    EmployeeBasic.Is_Change_LN_After_Divorced__c = application.StatusInfo.isChangeLastNameAfterDivorced;
                }
                
                string statusDivorceTHNewTitle = checkEnumKey(application.StatusInfo.newDivorcedTHTitle);
                EmployeeBasic.Status_Divorce_TH_New_Title__c = assignSFTitle(statusDivorceTHNewTitle);
                EmployeeBasic.Status_Divorce_TH_New_LN__c = application.StatusInfo.newDivorcedTHLastName;
                
                string statusDivorceENNewTitle = checkEnumKey(application.StatusInfo.newDivorcedENTitle);
                EmployeeBasic.Status_Divorce_EN_New_Title__c = assignSFTitle(statusDivorceENNewTitle);
                EmployeeBasic.Status_Divorce_EN_New_LN__c = application.StatusInfo.newDivorcedENLastName;
                EmployeeBasic.Status_Divorce_Doc_Id__c = application.StatusInfo.divorcedDocumentUrl;
                EmployeeBasic.Status_Divorce_Change_Detail_Id__c = application.StatusInfo.divorcedChangeTitleLastNameUrl;
                EmployeeBasic.Status_Divorce_Use_Detail_Id__c = application.StatusInfo.divorcedUseChangeTitleLastNameUrl;
                
                //StatusInfo - Widow
                string statusWidowTHTitle = checkEnumKey(application.StatusInfo.widowTHTitle);
                EmployeeBasic.Status_Widow_TH_Title__c = assignSFTitle(statusWidowTHTitle);
                EmployeeBasic.Status_Widow_TH_FN__c = application.StatusInfo.widowTHFirstName;
                EmployeeBasic.Status_Widow_TH_LN__c = application.StatusInfo.widowTHLastName;
                
                string statusWidowENTitle = checkEnumKey(application.StatusInfo.widowENTitle);
                EmployeeBasic.Status_Widow_EN_Title__c = assignSFTitle(statusWidowENTitle);
                EmployeeBasic.Status_Widow_EN_FN__c = application.StatusInfo.widowENFirstName;
                EmployeeBasic.Status_Widow_EN_LN__c = application.StatusInfo.widowENLastName;
                EmployeeBasic.Status_Widow_Doc_No__c = application.StatusInfo.widowDocumentNo;
                EmployeeBasic.Status_Widow_Doc_Issue_Location__c = application.StatusInfo.widowDocumentIssueLocation;
                EmployeeBasic.Status_Widow_Doc_Issue_Province__c = application.StatusInfo.widowDocumentIssueProvince;
                EmployeeBasic.Status_Widow_Doc_Issue_Date__c = application.StatusInfo.widowDocumentIssueDate;
                
                if(application.StatusInfo.isChangeTitleAfterWidow == null) {
                    EmployeeBasic.Status_Widow_Change_Title__c = false;
                }
                else {
                    EmployeeBasic.Status_Widow_Change_Title__c = application.StatusInfo.isChangeTitleAfterWidow;
                    EmployeeBasic.Is_Change_Title_After_Widow__c = application.StatusInfo.isChangeTitleAfterWidow;
                }
                
                if(application.StatusInfo.isChangeLastNameAfterWidow == null) {
                    EmployeeBasic.Status_Widow_Change_LN__c = false;
                }
                else {
                    EmployeeBasic.Status_Widow_Change_LN__c = application.StatusInfo.isChangeLastNameAfterWidow;
                    EmployeeBasic.Is_Change_LN_After_Widow__c = application.StatusInfo.isChangeLastNameAfterWidow;
                }
                
                string statusWidowTHNewTitle = checkEnumKey(application.StatusInfo.newWidowTHTitle);
                EmployeeBasic.Status_Widow_TH_New_Title__c = assignSFTitle(statusWidowTHNewTitle);
                EmployeeBasic.Status_Widow_TH_New_LN__c = application.StatusInfo.newWidowTHLastName;
                
                string statusWidowENNewTitle = checkEnumKey(application.StatusInfo.newWidowTHTitle);
                EmployeeBasic.Status_Widow_EN_New_Title__c = assignSFTitle(statusWidowENNewTitle);
                EmployeeBasic.Status_Widow_EN_New_LN__c = application.StatusInfo.newWidowENLastName;
                EmployeeBasic.Status_Widow_Doc_Id__c = application.StatusInfo.deathWidowDocumentUrl;
                EmployeeBasic.Status_Widow_Change_Doc_Id__c = application.StatusInfo.deathWidowChangeTitleLastNameUrl;
                
                //ChildInfo
                if(application.ChildInfos.size() > 0) {
                    EmployeeBasic.Name_Child_Count__c = application.ChildInfos.size();
                    boolean isAtleasUpdateChild = false;
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                        if(ChildInfo.isChange) {
                            isAtleasUpdateChild = true;
                        }
                    }
                    if(isAtleasUpdateChild) {
                        EmployeeBasic.Is_Update_Child__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Child__c = false;
                    }
                    
                    if(EmployeeBasic.Is_Update_Child__c) {
                        	
                        for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                            if(ChildInfo.isChange) {
                                EmployeeBasic.Is_Update_Child__c = true;
                                break;
                            }
                        }
                        
                		EmployeeBasic.Child_JSON__c = String.ValueOf(JSON.serialize(application.ChildInfos));
                    }
                }
                else {
                    EmployeeBasic.Child_JSON__c = null;
                    EmployeeBasic.Is_Update_Child__c = false;
                }
                
                //DeathInfo
                EmployeeBasic.Is_Update_Death__c = application.DeathInfo.isChange;
                if(application.DeathInfo.DeathInfos.size() > 0) {
                    
                    List<ESS_EmployeeBasic_DTO.DeathInfoDTO> DeathChilds = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
                    
                    for(ESS_EmployeeBasic_DTO.DeathInfoDTO DeathInfo : application.DeathInfo.DeathInfos) {
                        if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Married)) {
                            EmployeeBasic.Death_Is_Marriage_Death__c = application.DeathInfo.isDeathWife;
                            EmployeeBasic.Death_Marriage_Title__c = checkEnumValue(DeathInfo.title);
                            EmployeeBasic.Death_Marriage_FN__c = DeathInfo.thFirstName;
                            EmployeeBasic.Death_Marriage_LN__c = DeathInfo.thLastName;
                            EmployeeBasic.Death_Marriage_Doc_No__c = DeathInfo.deathDocumentNo;
                            EmployeeBasic.Death_Marriage_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                            EmployeeBasic.Death_Marriage_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                            EmployeeBasic.Death_Marriage_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                            EmployeeBasic.Death_Marriage_Doc_Id__c = DeathInfo.deathDocumentUrl;
                        }
                        else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Father)) {
                            EmployeeBasic.Death_Is_Father_Death__c = application.DeathInfo.isDeathFather;
                            EmployeeBasic.Death_Father_Title__c = checkEnumValue(DeathInfo.title);
                            EmployeeBasic.Death_Father_FN__c = DeathInfo.thFirstName;
                            EmployeeBasic.Death_Father_LN__c = DeathInfo.thLastName;
                            EmployeeBasic.Death_Father_Doc_No__c = DeathInfo.deathDocumentNo;
                            EmployeeBasic.Death_Father_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                            EmployeeBasic.Death_Father_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                            EmployeeBasic.Death_Father_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                            EmployeeBasic.Death_Father_Doc_Id__c = DeathInfo.deathDocumentUrl;
                        }
                        else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Mother)) {
                            EmployeeBasic.Death_Is_Mother_Death__c = application.DeathInfo.isDeathMother;
                            EmployeeBasic.Death_Mother_Title__c = checkEnumValue(DeathInfo.title);
                            EmployeeBasic.Death_Mother_FN__c = DeathInfo.thFirstName;
                            EmployeeBasic.Death_Mother_LN__c = DeathInfo.thLastName;
                            EmployeeBasic.Death_Mother_Doc_No__c = DeathInfo.deathDocumentNo;
                            EmployeeBasic.Death_Mother_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                            EmployeeBasic.Death_Mother_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                            EmployeeBasic.Death_Mother_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                            EmployeeBasic.Death_Mother_Doc_Issue_Id__c = DeathInfo.deathDocumentUrl;
                        }
                        else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Child)) {
                            DeathChilds.add(DeathInfo);
                        }
                    }
                    
                    if(DeathChilds.size() > 0) {
                        EmployeeBasic.Death_Is_Child_Death__c = application.DeathInfo.isDeathChild;
                        EmployeeBasic.Death_Child_JSON__c = JSON.serialize(DeathChilds);
                    }
                    
                }
                
                //EducationInfo
                if(application.EducationInfos.size() > 0) {
                    boolean isAtleastUpdateEducation = false;
                    for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                        if(EducationInfo.isChange) {
                            isAtleastUpdateEducation = true;
                        }
                    }
                    
                    if(isAtleastUpdateEducation) {
                        EmployeeBasic.Is_Update_Education__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Education__c = false;
                    }
                    
                    if(EmployeeBasic.Is_Update_Education__c) {
                        for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                            if(EducationInfo.isChange) {
                                EmployeeBasic.Is_Update_Education__c = true;
                                break;
                            }
                        }
                    }
                    EmployeeBasic.Education_JSON__c = JSON.serialize(application.EducationInfos);
                }
                else {
                    EmployeeBasic.Education_JSON__c = null;
                    EmployeeBasic.Is_Update_Education__c = false;
                }
                
                //LicenseInfos
                if(application.LicenseInfos.size() > 0) {
                    boolean isAtleastUpdateLicense = false;
                    for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                        if(LicenseInfo.isChange) {
                            isAtleastUpdateLicense = true;
                        }
                    }
                    
                    if(isAtleastUpdateLicense) {
                        EmployeeBasic.Is_Update_License__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_License__c = false;
                    }
                    
                    if(EmployeeBasic.Is_Update_License__c) {
                    	for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                            if(LicenseInfo.licenseType.value == String.ValueOf(ESS_Enum.LicenseType.Citizen)) {
                                EmployeeBasic.License_Citizen_Id__c = LicenseInfo.citizenId;
                                EmployeeBasic.License_Citizen_New_Issue_Date__c = LicenseInfo.newIssueDate;
                                EmployeeBasic.License_Citizen_New_Expire_Date__c = LicenseInfo.newExpireDate;
                                EmployeeBasic.License_Citizen_New_Issue_Province__c = LicenseInfo.newIssuedProvince;
                                EmployeeBasic.License_Citizen_Old_Issue_Date__c = LicenseInfo.issueDate;
                                EmployeeBasic.License_Citizen_Old_Expire_Date__c = LicenseInfo.expireDate;
                                EmployeeBasic.License_Citizen_Old_Issue_Province__c = LicenseInfo.issuedProvince;
                                EmployeeBasic.License_Citizen_Copy_Doc__c = LicenseInfo.documentCitizenCopyUrl;
                            }
                            else if(LicenseInfo.licenseType.value == String.ValueOf(ESS_Enum.LicenseType.Professional)) {
                                EmployeeBasic.License_Professional_New_Doc_No__c = LicenseInfo.newLicenseNo;
                                EmployeeBasic.License_Professional_New_Doc_Level__c = LicenseInfo.newLicenseLevel;
                                EmployeeBasic.License_Professional_New_Doc_Issue_Date__c = LicenseInfo.newIssueDate;
                                EmployeeBasic.License_Professional_New_Doc_Expire_Date__c = LicenseInfo.newExpireDate;
                                EmployeeBasic.License_Professional_New_Engineer__c = LicenseInfo.newEngineeringBranch;
                                EmployeeBasic.License_Professional_Old_Doc_No__c = LicenseInfo.licenseNo;
                                EmployeeBasic.License_Professional_Old_Doc_Level__c = LicenseInfo.licenseLevel;
                                EmployeeBasic.License_Professional_Old_Doc_Issue_Date__c = LicenseInfo.issueDate;
                                EmployeeBasic.License_Professional_Old_Doc_Expire_Date__c = LicenseInfo.expireDate;
                                EmployeeBasic.License_Professional_Old_Engineer__c = LicenseInfo.engineeringBranch;
                            }
                        }
                    }
                }
                
                //AddressInfos
                if(application.AddressInfos.size() > 0) {
                    boolean isAtleastUpdateAddress = false;
                    for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                        if(AddressInfo.isChange) {
                            isAtleastUpdateAddress = true;
                        }
                    }
                    
                    if(isAtleastUpdateAddress) {
                        EmployeeBasic.Is_Update_Address__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Address__c = false;
                    }
                    
                    if(EmployeeBasic.Is_Update_Address__c) {
                        for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                            if(AddressInfo.addressType.value == String.ValueOf(ESS_Enum.AddressType.HouseRegistration)) {
                                if(AddressInfo.isChange) {
                                    EmployeeBasic.Address_Change__c = true;
                                }
                                else {
                                    EmployeeBasic.Address_Change__c = false;
                                }
                                EmployeeBasic.Address_TH_Old_House_No__c = AddressInfo.thHouseNo;
                                EmployeeBasic.Address_TH_Old_Moo_Village_Soi_Road__c = AddressInfo.thMooVillageSoiRoad;
                                EmployeeBasic.Address_TH_Old_SubDistrict_District__c = AddressInfo.thSubDistrictDistrict;
                                EmployeeBasic.Address_TH_Old_Province__c = AddressInfo.thProvince;
                                EmployeeBasic.Address_TH_Old_Postal_Code__c = AddressInfo.thPostalCode;
                                EmployeeBasic.Address_TH_Old_Telephone_No__c = AddressInfo.thTelephoneNo;
                                EmployeeBasic.Address_EN_Old_House_No__c = AddressInfo.enHouseNo;
                                EmployeeBasic.Address_EN_Old_Moo_Village_Soi_Road__c = AddressInfo.enMooVillageSoiRoad;
                                EmployeeBasic.Address_EN_Old_SubDistrict_District__c = AddressInfo.enSubDistrictDistrict;
                                EmployeeBasic.Address_EN_Old_Province__c = AddressInfo.enProvince;
                                EmployeeBasic.Address_EN_Old_Postal_Code__c = AddressInfo.enPostalCode;
                                EmployeeBasic.Address_EN_Old_Telephone_No__c = AddressInfo.enTelephoneNo;
                                
                                EmployeeBasic.Address_TH_New_House_No__c = AddressInfo.newTHHouseNo;
                                EmployeeBasic.Address_TH_New_Moo__c = AddressInfo.newTHMoo;
                                EmployeeBasic.Address_TH_New_Village_Name__c = AddressInfo.newTHVillageName;
                                EmployeeBasic.Address_TH_New_Soi__c = AddressInfo.newTHSoi;
                                EmployeeBasic.Address_TH_New_Road__c = AddressInfo.newTHRoad;
                                EmployeeBasic.Address_TH_New_Sub_District__c = AddressInfo.newTHSubDistrict;
                                EmployeeBasic.Address_TH_New_District__c = AddressInfo.newTHDistrict;
                                EmployeeBasic.Address_TH_New_Province__c = AddressInfo.newTHProvince;
                                EmployeeBasic.Address_TH_New_Telephone_No__c = AddressInfo.newTHTelephoneNo;
                                EmployeeBasic.Address_TH_New_Postal_Code__c = AddressInfo.newTHPostalCode;
                                EmployeeBasic.Address_EN_New_House_No__c = AddressInfo.newENHouseNo;
                                EmployeeBasic.Address_EN_New_Moo__c = AddressInfo.newENMoo;
                                EmployeeBasic.Address_EN_New_Village_Name__c = AddressInfo.newENVillageName;
                                EmployeeBasic.Address_EN_New_Soi__c = AddressInfo.newENSoi;
                                EmployeeBasic.Address_EN_New_Road__c = AddressInfo.newENRoad;
                                EmployeeBasic.Address_EN_New_Sub_District__c = AddressInfo.newENSubDistrict;
                                EmployeeBasic.Address_EN_New_District__c = AddressInfo.newENDistrict;
                                EmployeeBasic.Address_EN_New_Province__c = AddressInfo.newENProvince;
                                EmployeeBasic.Address_EN_New_Postal_Code__c = AddressInfo.newENPostalCode;
                                EmployeeBasic.Address_EN_New_Telephone_No__c = AddressInfo.newENTelephoneNo;
                                
                                EmployeeBasic.Address_House_Registration_Copy_Id__c = AddressInfo.documentRegistrationCopyUrl;
                            }
                            else if(AddressInfo.addressType.value == String.ValueOf(ESS_Enum.AddressType.Current)) {
                                if(AddressInfo.isChange) {
                                    EmployeeBasic.Address_Current_Change__c = true;
                                }
                                else {
                                    EmployeeBasic.Address_Current_Change__c = false;
                                }
                                EmployeeBasic.Address_TH_Current_Old_House_No__c = AddressInfo.thHouseNo;
                                EmployeeBasic.Address_TH_Current_Old_Moo_Vill_Soi_Road__c = AddressInfo.thMooVillageSoiRoad;
                                EmployeeBasic.Address_TH_Current_Old_SubDis_District__c = AddressInfo.thSubDistrictDistrict;
                                EmployeeBasic.Address_TH_Current_Old_Province__c = AddressInfo.thProvince;
                                EmployeeBasic.Address_TH_Current_Old_Postal_Code__c = AddressInfo.thPostalCode;
                                EmployeeBasic.Address_TH_Current_Old_Telephone_No__c = AddressInfo.thTelephoneNo;
                                EmployeeBasic.Address_EN_Current_Old_House_No__c = AddressInfo.enHouseNo;
                                EmployeeBasic.Address_EN_Current_Old_Moo_Vill_Soi_Road__c = AddressInfo.enMooVillageSoiRoad;
                                EmployeeBasic.Address_EN_Current_Old_SubDis_District__c = AddressInfo.enSubDistrictDistrict;
                                EmployeeBasic.Address_EN_Current_Old_Province__c = AddressInfo.enProvince;
                                EmployeeBasic.Address_EN_Current_Old_Postal_Code__c = AddressInfo.enPostalCode;
                                EmployeeBasic.Address_EN_Current_Old_Telephone_No__c = AddressInfo.enTelephoneNo;
                                
                                EmployeeBasic.Address_TH_Current_New_House_No__c = AddressInfo.newTHHouseNo;
                                EmployeeBasic.Address_TH_Current_New_Moo__c = AddressInfo.newTHMoo;
                                EmployeeBasic.Address_TH_Current_New_Village_Name__c = AddressInfo.newTHVillageName;
                                EmployeeBasic.Address_TH_Current_New_Soi__c = AddressInfo.newTHSoi;
                                EmployeeBasic.Address_TH_Current_New_Road__c = AddressInfo.newTHRoad;
                                EmployeeBasic.Address_TH_Current_New_Sub_District__c = AddressInfo.newTHSubDistrict;
                                EmployeeBasic.Address_TH_Current_New_District__c = AddressInfo.newTHDistrict;
                                EmployeeBasic.Address_TH_Current_New_Province__c = AddressInfo.newTHProvince;
                                EmployeeBasic.Address_TH_Current_New_Telephone_No__c = AddressInfo.newTHTelephoneNo;
                                EmployeeBasic.Address_TH_Current_New_Postal_Code__c = AddressInfo.newTHPostalCode;
                                EmployeeBasic.Address_EN_Current_New_House_No__c = AddressInfo.newENHouseNo;
                                EmployeeBasic.Address_EN_Current_New_Moo__c = AddressInfo.newENMoo;
                                EmployeeBasic.Address_EN_Current_New_Village_Name__c = AddressInfo.newENVillageName;
                                EmployeeBasic.Address_EN_Current_New_Soi__c = AddressInfo.newENSoi;
                                EmployeeBasic.Address_EN_Current_New_Road__c = AddressInfo.newENRoad;
                                EmployeeBasic.Address_EN_Current_New_Sub_District__c = AddressInfo.newENSubDistrict;
                                EmployeeBasic.Address_EN_Current_New_District__c = AddressInfo.newENDistrict;
                                EmployeeBasic.Address_EN_Current_New_Province__c = AddressInfo.newENProvince;
                                EmployeeBasic.Address_EN_Current_New_Postal_Code__c = AddressInfo.newENPostalCode;
                                EmployeeBasic.Address_EN_Current_New_Telephone_No__c = AddressInfo.newENTelephoneNo;
                                
                                EmployeeBasic.Address_Current_Address_Copy_Id__c = AddressInfo.documentRegistrationCopyUrl;
                            }
                    	}
                    }
                }
                
                //ContactInfos
                if(application.ContactPersonInfos.size() > 0) {
                    boolean isAtleastUpdateContact = false;
                    for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : application.ContactPersonInfos) {
                        if(ContactPersonInfo.isChange) {
                            isAtleastUpdateContact = true;
                        }
                    }
                    
                    if(isAtleastUpdateContact) {
                        EmployeeBasic.Is_Update_ContactPerson__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_ContactPerson__c = false;
                    }
                    
                    //Combine Contact Address
                    for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : Application.ContactPersonInfos) {
                        if(ContactPersonInfo.isChange) {
                            ContactPersonInfo.thMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.thMoo, ContactPersonInfo.thVillageName, ContactPersonInfo.thSoi, ContactPersonInfo.thRoad);
                            ContactPersonInfo.thDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.thSubDistrict, ContactPersonInfo.thDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                            
                            ContactPersonInfo.enMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.enMoo, ContactPersonInfo.enVillageName, ContactPersonInfo.enSoi, ContactPersonInfo.enRoad);
                            ContactPersonInfo.enDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.enSubDistrict, ContactPersonInfo.enDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                            
                            ContactPersonInfo.newTHMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.newTHMoo, ContactPersonInfo.newTHVillageName, ContactPersonInfo.newTHSoi, ContactPersonInfo.newTHRoad);
                            ContactPersonInfo.newTHDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.newTHSubDistrict, ContactPersonInfo.newTHDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                            
                            ContactPersonInfo.newENMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.newENMoo, ContactPersonInfo.newENVillageName, ContactPersonInfo.newENSoi, ContactPersonInfo.newENRoad);
                            ContactPersonInfo.newENDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.newENSubDistrict, ContactPersonInfo.newENDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                        }
                    }
                    
                    EmployeeBasic.Contact_Person_JSON__c = JSON.serialize(application.ContactPersonInfos);
                    
                }
                else {
                    EmployeeBasic.Contact_Person_JSON__c = null;
                    EmployeeBasic.Is_Update_ContactPerson__c = false;
                }
                
                //Tax
                EmployeeBasic.Is_Update_Tax__c = application.TaxInfo.isChange;
                if(application.TaxInfo.isChange) {
                    date todayDate = date.today();
                    if(todayDate.day() <= 15) {
                        EmployeeBasic.Effective_Date__c = date.newInstance(todayDate.year(), todayDate.month(), 1);
                    }
                    else {
                        EmployeeBasic.Effective_Date__c = date.newInstance(todayDate.year(), todayDate.addMonths(1).month(), 1);
                    }
                }
                string taxMarriageStatus = checkEnumKey(application.TaxInfo.marriedStatus);
                if(taxMarriageStatus == String.ValueOf(ESS_Enum.MarriedStatus.Single)) {
                    EmployeeBasic.Tax_Marriage_Status__c = '0';
                } 
                else if(taxMarriageStatus == String.ValueOf(ESS_Enum.MarriedStatus.Married)) {
                    EmployeeBasic.Tax_Marriage_Status__c = '1';
                } 
                
                string marriageEarnIncome = checkEnumKey(application.TaxInfo.marriedPersonEarnIncome);
                if(marriageEarnIncome == String.ValueOf(ESS_Enum.MarriedEarnIncome.MarriedNotEarnIncome)) {
                    EmployeeBasic.Tax_Marriage_Person_Earn_Income__c = '1';
                } 
                else if(marriageEarnIncome == String.ValueOf(ESS_Enum.MarriedEarnIncome.MarriedEarnIncome)) {
                    EmployeeBasic.Tax_Marriage_Person_Earn_Income__c = '2';
                } 
                
                EmployeeBasic.Tax_Child_Count__c = application.TaxInfo.childCount;
                EmployeeBasic.Tax_Total_Child_Count__c = application.TaxInfo.childCountTotal;
                EmployeeBasic.Tax_Self_Life_Insurance_Paid_Amount__c = application.TaxInfo.selfLifeInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Life_Insurance_Paid_Amount__c = application.TaxInfo.marriedLifeInsurancePaidAmount;
                EmployeeBasic.Tax_Self_Father_Insurance_Paid_Amount__c = application.TaxInfo.selfFatherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Self_Mother_Insurance_Paid_Amount__c = application.TaxInfo.selfMotherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Father_Insurance_Paid_Amount__c = application.TaxInfo.marriedFatherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Mother_Insurance_Paid_Amount__c = application.TaxInfo.marriedMotherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Interest_On_Loan_For_House_Amount__c = application.TaxInfo.interestOnLoanForHouseAmount;
                EmployeeBasic.Tax_Income_From_RMF_Amount__c = application.TaxInfo.incomeFromRMFAmount;
                EmployeeBasic.Tax_Income_From_SSF_Amount__c = application.TaxInfo.incomeFromSSFAmount;
                EmployeeBasic.Tax_Self_Deduction_Father_Amount__c = application.TaxInfo.selfTaxDeductionFatherAmount;
                EmployeeBasic.Tax_Self_Deduction_Mother_Amount__c = application.TaxInfo.selfTaxDeductionMotherAmount;
                EmployeeBasic.Tax_Married_Deduction_Father_Amount__c = application.TaxInfo.marriedTaxDeductionFatherAmount;
                EmployeeBasic.Tax_Married_Deduction_Mother_Amount__c = application.TaxInfo.marriedTaxDeductionMotherAmount;
                EmployeeBasic.Tax_Donation_For_Charity_Amount__c = application.TaxInfo.donationForCharityAmount;
                EmployeeBasic.Tax_Sponsor_Amount__c = application.TaxInfo.sponsorAmount;
                EmployeeBasic.Tax_Donation_For_Education_Amount__c = application.TaxInfo.donationForEducationAmount;
                EmployeeBasic.Tax_Annuity_Interest_Amount__c = application.TaxInfo.annuityInterestAmount;
                EmployeeBasic.Tax_First_House_Exclude_Tax_Amount__c = application.TaxInfo.firstHouseExcludeTaxAmount;
                EmployeeBasic.Tax_Pregnancy_Care_Amount__c = application.TaxInfo.pregnancyCareAmount;
                
                boolean infoChange = false;
                if(EmployeeBasic.Is_Update_Name__c || EmployeeBasic.Is_Update_Status__c && EmployeeBasic.Is_Update_Child__c || EmployeeBasic.Is_Update_Death__c 
                   || EmployeeBasic.Is_Update_Education__c || EmployeeBasic.Is_Update_License__c || EmployeeBasic.Is_Update_Address__c ||
                   EmployeeBasic.Is_Update_ContactPerson__c || EmployeeBasic.Is_Update_Tax__c) {
                       
                       infoChange = true;
                       
                }
                
                if(!infoChange) {
                    //Validation
                    if(application.ApplicationHeaderInfo.currentStatus.key == ESS_Enum.ApplicationStatus.Draft.name()) {
                        throw new ESS_Exception('[MyError]This appliation cannot be submit. Please change some information before submit.');
                    } 
                }
                
                insert(EmployeeBasic);
                
                if(!EmployeeBasic.Is_Update_Name__c && !EmployeeBasic.Is_Update_Status__c && !EmployeeBasic.Is_Update_Child__c && !EmployeeBasic.Is_Update_Death__c 
					&& !EmployeeBasic.Is_Update_Education__c && !EmployeeBasic.Is_Update_License__c && !EmployeeBasic.Is_Update_Address__c && 
                   (EmployeeBasic.Is_Update_ContactPerson__c || EmployeeBasic.Is_Update_Tax__c)) {
                      
                    application.id = EmployeeBasic.Id;
                	VerifyApplication(application);
                           
                   	if(EmployeeBasic.Is_Update_ContactPerson__c) {
                        //Send Email to Personel Admin (ContactPerson)
                    	ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmittedContactPerson(EmployeeBasic);
                    }
                    else if(EmployeeBasic.Is_Update_Tax__c) {
                        //Send Email to Personel Admin (Tax)
                    	ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmittedTax(EmployeeBasic);
                    }
                }
                else {
                    //Send Email to Personel Admin
                	ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmitted(EmployeeBasic);
                }
            }
            else if(application.id != null || application.id != 'null') {
                string currentStatus = ApplicationCurrentStatus(application.id);
                if(currentStatus != ESS_Enum.ApplicationStatus.Draft.name()) {
                    throw new ESS_Exception('[MyError]This appliation status has been changed and cannot be submit.');
                }
                
                //Check if there any change in any tab
                boolean isTabNameChange = application.NameInfo.isChange;
                boolean isTabStatusChange = application.StatusInfo.isChange;
                boolean isTabChildChange = false;
                boolean isTabDeathChange = application.DeathInfo.isChange;
                boolean isTabEducationChange = false;
                boolean isTabLicenseChange = false;
                boolean isTabAddressChange = false;
                boolean isTabContactPersonChange = false;
                boolean isTabTaxChange = application.TaxInfo.isChange;
                
                if(application.ChildInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                        if(ChildInfo.isChange) {
                            isTabChildChange = true;
                            break;
                        }
                    }
                }
                
                if(application.EducationInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                        if(EducationInfo.isChange) {
                            isTabEducationChange = true;
                            break;
                        }
                    }
                }
                
                if(application.LicenseInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                        if(LicenseInfo.isChange) {
                            isTabLicenseChange = true;
                            break;
                        }
                    }
                }
                
                if(application.AddressInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                        if(AddressInfo.isChange) {
                            isTabAddressChange = true;
                            break;
                        }
                    }
                }
                
                if(application.ContactPersonInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : application.ContactPersonInfos) {
                        if(ContactPersonInfo.isChange) {
                            isTabContactPersonChange = true;
                            break;
                        }
                    }
                }
                
                if(!isTabNameChange && !isTabStatusChange && !isTabChildChange && !isTabDeathChange && !isTabEducationChange &&
                  	!isTabLicenseChange && !isTabAddressChange && !isTabContactPersonChange && !isTabTaxChange) {
                    throw new ESS_Exception('[MyError]Cannot be submit. Please make some change before submit.');
                }
                
                ESS_Application__c EmployeeBasic = [select id, Employee_Id__c, Employee_Name__c, Document_No__c, CreatedDate, Submitted_Date__c, Completed_Date__c, OwnerId, Status__c, Is_Update_Name__c, Is_Update_Status__c, Is_Update_Child__c, Is_Update_Death__c, Is_Update_Education__c,
                                                    Is_Update_License__c, Is_Update_Address__c, Is_Update_ContactPerson__c, Is_Update_Tax__c, Verified_date__c, Verify_By__c, Education_JSON__c, Subject_Type__c from ESS_Application__c where Id =: application.id AND 
                                               (Status__c =: String.ValueOf(ESS_Enum.ApplicationStatus.Draft) OR Status__c =: String.ValueOf(ESS_Enum.ApplicationStatus.Submitted))];
            
                EmployeeBasic.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Submitted);
                EmployeeBasic.Submitted_Date__c = date.today();
                
                ownerId = EmployeeBasic.OwnerId;
                employeeBasicStatus = EmployeeBasic.Status__c;
                
                //NameInfo
                EmployeeBasic.Is_Update_Name__c = application.NameInfo.isChange;
                
                EmployeeBasic.Name_Change_Employee__c = application.NameInfo.editSelfInfo;
                EmployeeBasic.Name_Change_Marriage__c = application.NameInfo.editMarriedInfo;
                EmployeeBasic.Name_Change_Child__c = application.NameInfo.editChildInfo;
                EmployeeBasic.Name_Change_Father__c = application.NameInfo.editFatherInfo;
                EmployeeBasic.Name_Change_Mother__c = application.NameInfo.editMotherInfo;
                
                //NameInfo - Employee
                EmployeeBasic.Name_Emp_TH_Old_Title_FN_LN__c = application.NameInfo.employeeInfo.oldTHTitleFNLN;
                
                string nameEmpENOldTitle = checkEnumKey(application.NameInfo.employeeInfo.oldENTitle);
                EmployeeBasic.Name_Emp_EN_Old_Title__c = assignSFTitle(nameEmpENOldTitle);
                EmployeeBasic.Name_Emp_EN_Old_FN__c = application.NameInfo.employeeInfo.oldENFirstName;
                EmployeeBasic.Name_Emp_EN_Old_LN__c = application.NameInfo.employeeInfo.oldENLastName;
                
                string nameEmpTHNewTitle = checkEnumKey(application.NameInfo.employeeInfo.newTHTitle);
                EmployeeBasic.Name_Emp_TH_New_Title__c = assignSFTitle(nameEmpTHNewTitle);
                EmployeeBasic.Name_Emp_TH_New_FN__c = application.NameInfo.employeeInfo.newTHFirstName;
                EmployeeBasic.Name_Emp_TH_New_LN__c = application.NameInfo.employeeInfo.newTHLastName;
                
                string nameEmpENNewTitle = checkEnumKey(application.NameInfo.employeeInfo.newENTitle);
                EmployeeBasic.Name_Emp_EN_New_Title__c = assignSFTitle(nameEmpENNewTitle);
                EmployeeBasic.Name_Emp_EN_New_FN__c = application.NameInfo.employeeInfo.newENFirstName;
                EmployeeBasic.Name_Emp_EN_New_LN__c = application.NameInfo.employeeInfo.newENLastName;
                EmployeeBasic.Name_Emp_Change_Doc_No__c = application.NameInfo.employeeInfo.documentChangeNameNo;
                EmployeeBasic.Name_Emp_Change_Doc_Location__c = application.NameInfo.employeeInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Emp_Change_Doc_Province__c = application.NameInfo.employeeInfo.documentChangeNameProvince;
                
                if(application.NameInfo.employeeInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Emp_Change_Doc_Date__c = application.NameInfo.employeeInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Emp_Change_Doc_Id__c = application.NameInfo.employeeInfo.documentUploadedUrl;
                EmployeeBasic.Name_Emp_Citizen_Copy_Id__c = application.NameInfo.employeeInfo.documentCopyCitizenUrl;
                    
                //NameInfo - Married
                string nameMarriageTHOldTitle = checkEnumKey(application.NameInfo.statusInfo.oldTHTitle);
                EmployeeBasic.Name_Marriage_TH_Old_Title__c = assignSFTitle(nameMarriageTHOldTitle);
                EmployeeBasic.Name_Marriage_TH_Old_FN__c = application.NameInfo.statusInfo.oldTHFirstName;
                EmployeeBasic.Name_Marriage_TH_Old_LN__c = application.NameInfo.statusInfo.oldTHLastName;
                
                string nameMarriageENOldTitle = checkEnumKey(application.NameInfo.statusInfo.oldENTitle);
                EmployeeBasic.Name_Marriage_EN_Old_Title__c = assignSFTitle(nameMarriageENOldTitle);
                EmployeeBasic.Name_Marriage_EN_Old_FN__c = application.NameInfo.statusInfo.oldENFirstName;
                EmployeeBasic.Name_Marriage_EN_Old_LN__c = application.NameInfo.statusInfo.oldENLastName;
                
                string nameMarriageTHNewTitle = checkEnumKey(application.NameInfo.statusInfo.thTitle);
                EmployeeBasic.Name_Marriage_TH_New_Title__c = assignSFTitle(nameMarriageTHNewTitle);
                EmployeeBasic.Name_Marriage_TH_New_FN__c = application.NameInfo.statusInfo.thFirstName;
                EmployeeBasic.Name_Marriage_TH_New_LN__c = application.NameInfo.statusInfo.thLastName;
                
                string nameMarriageENNewTitle = checkEnumKey(application.NameInfo.statusInfo.enTitle);
                EmployeeBasic.Name_Marriage_EN_New_Title__c = assignSFTitle(nameMarriageENNewTitle);
                EmployeeBasic.Name_Marriage_EN_New_FN__c = application.NameInfo.statusInfo.enFirstName;
                EmployeeBasic.Name_Marriage_EN_New_LN__c = application.NameInfo.statusInfo.enLastName;
                EmployeeBasic.Name_Marriage_Change_Doc_No__c = application.NameInfo.statusInfo.documentChangeNameNo;
                EmployeeBasic.Name_Marriage_Change_Doc_Location__c = application.NameInfo.statusInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Marriage_Change_Doc_Province__c = application.NameInfo.statusInfo.documentChangeNameProvince;
                
                if(application.NameInfo.statusInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Marriage_Change_Doc_Date__c = application.NameInfo.statusInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Marriage_Change_Doc_Id__c = application.NameInfo.statusInfo.documentUploadedUrl;
                
                //NameInfo - Child
                EmployeeBasic.Name_Child_JSON__c = JSON.serialize(application.NameInfo.childInfos);
                EmployeeBasic.Name_Child_Count__c = application.NameInfo.childCount;
                
                //NameInfo - Father
                string nameFatherTHOldTitle = checkEnumKey(application.NameInfo.fatherInfo.oldTHTitle);
                EmployeeBasic.Name_Father_TH_Old_Title__c = assignSFTitle(nameFatherTHOldTitle);
                EmployeeBasic.Name_Father_TH_Old_FN__c = application.NameInfo.fatherInfo.oldTHFirstName;
                EmployeeBasic.Name_Father_TH_Old_LN__c = application.NameInfo.fatherInfo.oldTHLastName;
                
                string nameFatherENOldTitle = checkEnumKey(application.NameInfo.fatherInfo.oldENTitle);
                EmployeeBasic.Name_Father_EN_Old_Title__c = assignSFTitle(nameFatherENOldTitle);
                EmployeeBasic.Name_Father_EN_Old_FN__c = application.NameInfo.fatherInfo.oldENFirstName;
                EmployeeBasic.Name_Father_EN_Old_LN__c = application.NameInfo.fatherInfo.oldENLastName;
                
                string nameFatherTHNewTitle = checkEnumKey(application.NameInfo.fatherInfo.newTHTitle);
                EmployeeBasic.Name_Father_TH_New_Title__c = assignSFTitle(nameFatherTHNewTitle);
                EmployeeBasic.Name_Father_TH_New_FN__c = application.NameInfo.fatherInfo.newTHFirstName;
                EmployeeBasic.Name_Father_TH_New_LN__c = application.NameInfo.fatherInfo.newTHLastName;
                
                string nameFatherENNewTitle = checkEnumKey(application.NameInfo.fatherInfo.newENTitle);
                EmployeeBasic.Name_Father_EN_New_Title__c = assignSFTitle(nameFatherENNewTitle);
                EmployeeBasic.Name_Father_EN_New_FN__c = application.NameInfo.fatherInfo.newENFirstName;
                EmployeeBasic.Name_Father_EN_New_LN__c = application.NameInfo.fatherInfo.newENLastName;
                EmployeeBasic.Name_Father_Change_Doc_No__c = application.NameInfo.fatherInfo.documentChangeNameNo;
                EmployeeBasic.Name_Father_Change_Doc_Location__c = application.NameInfo.fatherInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Father_Change_Doc_Province__c = application.NameInfo.fatherInfo.documentChangeNameProvince;
                
                if(application.NameInfo.fatherInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Father_Change_Doc_Date__c = application.NameInfo.fatherInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Father_Change_Doc_Id__c = application.NameInfo.fatherInfo.documentUploadedUrl;
                
                //NameInfo - Mother
                string nameMotherTHOldTitle = checkEnumKey(application.NameInfo.motherInfo.oldTHTitle);
                EmployeeBasic.Name_Mother_TH_Old_Title__c = assignSFTitle(nameMotherTHOldTitle);
                EmployeeBasic.Name_Mother_TH_Old_FN__c = application.NameInfo.motherInfo.oldTHFirstName;
                EmployeeBasic.Name_Mother_TH_Old_LN__c = application.NameInfo.motherInfo.oldTHLastName;
                
                string nameMotherENOldTitle = checkEnumKey(application.NameInfo.motherInfo.oldENTitle);
                EmployeeBasic.Name_Mother_EN_Old_Title__c = assignSFTitle(nameMotherENOldTitle);
                EmployeeBasic.Name_Mother_EN_Old_FN__c = application.NameInfo.motherInfo.oldENFirstName;
                EmployeeBasic.Name_Mother_EN_Old_LN__c = application.NameInfo.motherInfo.oldENLastName;
                
                string nameMotherTHNewTitle = checkEnumKey(application.NameInfo.motherInfo.newTHTitle);
                EmployeeBasic.Name_Mother_TH_New_Title__c = assignSFTitle(nameMotherTHNewTitle);
                EmployeeBasic.Name_Mother_TH_New_FN__c = application.NameInfo.motherInfo.newTHFirstName;
                EmployeeBasic.Name_Mother_TH_New_LN__c = application.NameInfo.motherInfo.newTHLastName;
                
                string nameMotherENNewTitle = checkEnumKey(application.NameInfo.motherInfo.newENTitle);
                EmployeeBasic.Name_Mother_EN_New_Title__c = assignSFTitle(nameMotherENNewTitle);
                EmployeeBasic.Name_Mother_EN_New_FN__c = application.NameInfo.motherInfo.newENFirstName;
                EmployeeBasic.Name_Mother_EN_New_LN__c = application.NameInfo.motherInfo.newENLastName;
                EmployeeBasic.Name_Mother_Change_Doc_No__c = application.NameInfo.motherInfo.documentChangeNameNo;
                EmployeeBasic.Name_Mother_Change_Doc_Location__c = application.NameInfo.motherInfo.documentChangeNameLocation;
                EmployeeBasic.Name_Mother_Change_Doc_Province__c = application.NameInfo.motherInfo.documentChangeNameProvince;
                
                if(application.NameInfo.motherInfo.documentChangeNameDate != null) {
                    EmployeeBasic.Name_Mother_Change_Doc_Date__c = application.NameInfo.motherInfo.documentChangeNameDate;
                }
                
                EmployeeBasic.Name_Mother_Change_Doc_Id__c = application.NameInfo.motherInfo.documentUploadedUrl;
                    
                //StatusInfo - Marriage
                EmployeeBasic.Is_Update_Status__c = application.StatusInfo.isChange;
                EmployeeBasic.Is_Marriage_As_Employee__c = application.StatusInfo.isMarriedPersonAsEmployee;
                
                EmployeeBasic.Status_Marriage_Change_Detail__c = application.StatusInfo.isUpdateMarriedStatus;
                EmployeeBasic.Status_Marriage_Employee_Id__c = application.StatusInfo.marriedEmployeeId;
                
                EmployeeBasic.Status_Marriage_Status__c = checkEnumKey(application.StatusInfo.marriedStatus);
                string statusMarriageTHTitle = checkEnumKey(application.StatusInfo.oldTHTitle);
                EmployeeBasic.Status_Marriage_TH_Title__c = assignSFTitle(statusMarriageTHTitle);
                if(EmployeeBasic.Status_Marriage_TH_Title__c != null) { 
                    if(EmployeeBasic.Status_Marriage_TH_Title__c != '1') {
                        EmployeeBasic.Status_Marriage_Gender__c = '2';
                    }
                    else {
                        EmployeeBasic.Status_Marriage_Gender__c = '1';
                    }
                }
                else {
                    EmployeeBasic.Status_Marriage_Gender__c = '';
                }
                EmployeeBasic.Status_Marriage_TH_FN__c = application.StatusInfo.oldTHFirstName;
                EmployeeBasic.Status_Marriage_TH_LN__c = application.StatusInfo.oldTHLastName;
                
                string statusMarriageENTitle = checkEnumKey(application.StatusInfo.oldENTitle);
                EmployeeBasic.Status_Marriage_EN_Title__c = assignSFTitle(statusMarriageENTitle);
                EmployeeBasic.Status_Marriage_EN_FN__c = application.StatusInfo.oldENFirstName;
                EmployeeBasic.Status_Marriage_EN_LN__c = application.StatusInfo.oldENLastName;
                EmployeeBasic.Status_Marriage_Citizen_Id__c = application.StatusInfo.citizenId;
                EmployeeBasic.Status_Marriage_DOB__c = application.StatusInfo.dateOfBirth;
                EmployeeBasic.Status_Marriage_Occupation__c = application.StatusInfo.occupation;
                EmployeeBasic.Status_Marriage_Doc_No__c = application.StatusInfo.marriedDocumentNo;
                EmployeeBasic.Status_Marriage_Doc_Issue_Location__c = application.StatusInfo.marriedDocumentIssueLocation;
                EmployeeBasic.Status_Marriage_Doc_Issue_Province__c = application.StatusInfo.marriedDocumentIssueProvince;
                EmployeeBasic.Status_Marriage_Doc_Issue_Date__c = application.StatusInfo.marriedDocumentIssueDate;
                
                string statusMarriageTHNewTitle = checkEnumKey(application.StatusInfo.newMarriedTHTitle);
                string statusMarriageENNewTitle = checkEnumKey(application.StatusInfo.newMarriedENTitle);
                EmployeeBasic.Status_Marriage_EN_New_Title__c = assignSFTitle(statusMarriageENNewTitle);
                
                EmployeeBasic.Status_Marriage_TH_New_LN__c = application.StatusInfo.newMarriedTHLastName;
                EmployeeBasic.Status_Marriage_EN_New_LN__c = application.StatusInfo.newMarriedENLastName;
                
                if(application.StatusInfo.isChangeTitleAfterMarried == null) {
                    EmployeeBasic.Is_Change_Title_After_Married__c = false;
                }
                else {
                    EmployeeBasic.Is_Change_Title_After_Married__c = application.StatusInfo.isChangeTitleAfterMarried;
                    if(application.StatusInfo.isChangeTitleAfterMarried) {
                        EmployeeBasic.Is_Update_Name__c = true;
                        EmployeeBasic.Name_Change_Employee__c = true;
                        //EmployeeBasic.Name_Emp_TH_New_Title__c = EmployeeBasic.Status_Marriage_TH_New_Title__c;
                        //EmployeeBasic.Name_Emp_EN_New_Title__c = EmployeeBasic.Status_Marriage_EN_New_Title__c;
                        //EmployeeBasic.Name_Emp_Change_Doc_Date__c = EmployeeBasic.Status_Marriage_Doc_Issue_Date__c;
                    }
                }
                
                if(application.StatusInfo.isChangeLastNameAfterMarried == null) {
                    EmployeeBasic.Is_Change_LN_After_Married__c = false;
                }
                else {
                    EmployeeBasic.Is_Change_LN_After_Married__c  = application.StatusInfo.isChangeLastNameAfterMarried;
                    if(application.StatusInfo.isChangeLastNameAfterMarried) {
                        EmployeeBasic.Is_Update_Name__c = true;
                        EmployeeBasic.Name_Change_Employee__c = true;
                        //EmployeeBasic.Name_Emp_TH_New_LN__c = EmployeeBasic.Status_Marriage_TH_New_LN__c;
                        //EmployeeBasic.Name_Emp_EN_New_LN__c = EmployeeBasic.Status_Marriage_EN_New_LN__c;
                        //EmployeeBasic.Name_Emp_Change_Doc_Date__c = EmployeeBasic.Status_Marriage_Doc_Issue_Date__c;
                    }
                }
                
                EmployeeBasic.Status_Marriage_Doc_Id__c = application.StatusInfo.marriedDocumentUrl;
                EmployeeBasic.Status_Marriage_Change_Doc_Id__c = application.StatusInfo.employeeTitleLastnameDocumentUrl;
                EmployeeBasic.Status_Marriage_Citizen_Id_Copy__c = application.StatusInfo.marriedPersonCopyDocumentUrl;
                EmployeeBasic.Status_Marriage_Change_Doc_Copy_Id__c = application.StatusInfo.changeTitleLastnameCopyDocumentUrl;
                
                //StatusInfo - Divorced
                string statusDivorceTHTitle = checkEnumKey(application.StatusInfo.divorcedTHTitle);
                EmployeeBasic.Status_Divorce_TH_Title__c = assignSFTitle(statusDivorceTHTitle);
                EmployeeBasic.Status_Divorce_TH_FN__c = application.StatusInfo.divorcedTHFirstName;
                EmployeeBasic.Status_Divorce_TH_LN__c = application.StatusInfo.divorcedTHLastName;
                
                string statusDivorceENTitle = checkEnumKey(application.StatusInfo.divorcedENTitle);
                EmployeeBasic.Status_Divorce_EN_Title__c = assignSFTitle(statusDivorceENTitle);
                EmployeeBasic.Status_Divorce_EN_FN__c = application.StatusInfo.divorcedENFirstName;
                EmployeeBasic.Status_Divorce_EN_LN__c = application.StatusInfo.divorcedENLastName;
                EmployeeBasic.Status_Divorce_Doc_No__c = application.StatusInfo.divorcedDocumentNo;
                EmployeeBasic.Status_Divorce_Doc_Issue_Location__c = application.StatusInfo.divorcedDocumentIssueLocation;
                EmployeeBasic.Status_Divorce_Doc_Issue_Province__c = application.StatusInfo.divorcedDocumentIssueProvince;
                EmployeeBasic.Status_Divorce_Doc_Issue_Date__c = application.StatusInfo.divorcedDocumentIssueDate;
                
                if(application.StatusInfo.isChangeTitleAfterDivorced == null) {
                    EmployeeBasic.Status_Divorce_Change_Title__c = false;
                }
                else {
                    EmployeeBasic.Status_Divorce_Change_Title__c = application.StatusInfo.isChangeTitleAfterDivorced;
                }
                
                if(application.StatusInfo.isChangeLastNameAfterDivorced == null) {
                    EmployeeBasic.Status_Divorce_Change_LN__c = false;
                }
                else {
                    EmployeeBasic.Status_Divorce_Change_LN__c = application.StatusInfo.isChangeLastNameAfterDivorced;
                }
                
                string statusDivorceTHNewTitle = checkEnumKey(application.StatusInfo.newDivorcedTHTitle);
                EmployeeBasic.Status_Divorce_TH_New_Title__c = assignSFTitle(statusDivorceTHNewTitle);
                EmployeeBasic.Status_Divorce_TH_New_LN__c = application.StatusInfo.newDivorcedTHLastName;
                
                string statusDivorceENNewTitle = checkEnumKey(application.StatusInfo.newDivorcedENTitle);
                EmployeeBasic.Status_Divorce_EN_New_Title__c = assignSFTitle(statusDivorceENNewTitle);
                EmployeeBasic.Status_Divorce_EN_New_LN__c = application.StatusInfo.newDivorcedENLastName;
                EmployeeBasic.Status_Divorce_Doc_Id__c = application.StatusInfo.divorcedDocumentUrl;
                EmployeeBasic.Status_Divorce_Change_Detail_Id__c = application.StatusInfo.divorcedChangeTitleLastNameUrl;
                EmployeeBasic.Status_Divorce_Use_Detail_Id__c = application.StatusInfo.divorcedUseChangeTitleLastNameUrl;
                
                //StatusInfo - Widow
                string statusWidowTHTitle = checkEnumKey(application.StatusInfo.widowTHTitle);
                EmployeeBasic.Status_Widow_TH_Title__c = assignSFTitle(statusWidowTHTitle);
                EmployeeBasic.Status_Widow_TH_FN__c = application.StatusInfo.widowTHFirstName;
                EmployeeBasic.Status_Widow_TH_LN__c = application.StatusInfo.widowTHLastName;
                
                string statusWidowENTitle = checkEnumKey(application.StatusInfo.widowENTitle);
                EmployeeBasic.Status_Widow_EN_Title__c = assignSFTitle(statusWidowENTitle);
                EmployeeBasic.Status_Widow_EN_FN__c = application.StatusInfo.widowENFirstName;
                EmployeeBasic.Status_Widow_EN_LN__c = application.StatusInfo.widowENLastName;
                EmployeeBasic.Status_Widow_Doc_No__c = application.StatusInfo.widowDocumentNo;
                EmployeeBasic.Status_Widow_Doc_Issue_Location__c = application.StatusInfo.widowDocumentIssueLocation;
                EmployeeBasic.Status_Widow_Doc_Issue_Province__c = application.StatusInfo.widowDocumentIssueProvince;
                EmployeeBasic.Status_Widow_Doc_Issue_Date__c = application.StatusInfo.widowDocumentIssueDate;
                
                if(application.StatusInfo.isChangeTitleAfterWidow == null) {
                    EmployeeBasic.Status_Widow_Change_Title__c = false;
                }
                else {
                    EmployeeBasic.Status_Widow_Change_Title__c = application.StatusInfo.isChangeTitleAfterWidow;
                }
                
                if(application.StatusInfo.isChangeLastNameAfterWidow == null) {
                    EmployeeBasic.Status_Widow_Change_LN__c = false;
                }
                else {
                    EmployeeBasic.Status_Widow_Change_LN__c = application.StatusInfo.isChangeLastNameAfterWidow;
                }
                
                string statusWidowTHNewTitle = checkEnumKey(application.StatusInfo.newWidowTHTitle);
                EmployeeBasic.Status_Widow_TH_New_Title__c = assignSFTitle(statusWidowTHNewTitle);
                EmployeeBasic.Status_Widow_TH_New_LN__c = application.StatusInfo.newWidowTHLastName;
                
                string statusWidowENNewTitle = checkEnumKey(application.StatusInfo.newWidowTHTitle);
                EmployeeBasic.Status_Widow_EN_New_Title__c = assignSFTitle(statusWidowENNewTitle);
                EmployeeBasic.Status_Widow_EN_New_LN__c = application.StatusInfo.newWidowENLastName;
                EmployeeBasic.Status_Widow_Doc_Id__c = application.StatusInfo.deathWidowDocumentUrl;
                EmployeeBasic.Status_Widow_Change_Doc_Id__c = application.StatusInfo.deathWidowChangeTitleLastNameUrl;
                
                //ChildInfo
                if(application.ChildInfos.size() > 0) {
                    EmployeeBasic.Name_Child_Count__c = application.ChildInfos.size();
                    boolean isAtleastUpdateChild = false;
                    for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                        if(ChildInfo.isChange) {
                            isAtleastUpdateChild = true;
                        }
                    }
                    
                    if(isAtleastUpdateChild) {
                        EmployeeBasic.Is_Update_Child__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Child__c = false;
                    }
                    
                    if(EmployeeBasic.Is_Update_Child__c) {
                        	
                        for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : application.ChildInfos) {
                            if(ChildInfo.isChange) {
                                EmployeeBasic.Is_Update_Child__c = true;
                                break;
                            }
                        }
                        
                		EmployeeBasic.Child_JSON__c = String.ValueOf(JSON.serialize(application.ChildInfos));
                    }
                }
                else {
                    EmployeeBasic.Child_JSON__c = null;
                    EmployeeBasic.Is_Update_Child__c = false;
                }
                
                //DeathInfo
                EmployeeBasic.Is_Update_Death__c = application.DeathInfo.isChange;
                if(application.DeathInfo.DeathInfos.size() > 0) {
                    
                    List<ESS_EmployeeBasic_DTO.DeathInfoDTO> DeathChilds = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
                    
                    for(ESS_EmployeeBasic_DTO.DeathInfoDTO DeathInfo : application.DeathInfo.DeathInfos) {
                        if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Married)) {
                            EmployeeBasic.Death_Is_Marriage_Death__c = application.DeathInfo.isDeathWife;
                            EmployeeBasic.Death_Marriage_Title__c = checkEnumValue(DeathInfo.title);
                            EmployeeBasic.Death_Marriage_FN__c = DeathInfo.thFirstName;
                            EmployeeBasic.Death_Marriage_LN__c = DeathInfo.thLastName;
                            EmployeeBasic.Death_Marriage_Doc_No__c = DeathInfo.deathDocumentNo;
                            EmployeeBasic.Death_Marriage_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                            EmployeeBasic.Death_Marriage_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                            EmployeeBasic.Death_Marriage_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                            EmployeeBasic.Death_Marriage_Doc_Id__c = DeathInfo.deathDocumentUrl;
                        }
                        else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Father)) {
                            EmployeeBasic.Death_Is_Father_Death__c = application.DeathInfo.isDeathFather;
                            EmployeeBasic.Death_Father_Title__c = checkEnumValue(DeathInfo.title);
                            EmployeeBasic.Death_Father_FN__c = DeathInfo.thFirstName;
                            EmployeeBasic.Death_Father_LN__c = DeathInfo.thLastName;
                            EmployeeBasic.Death_Father_Doc_No__c = DeathInfo.deathDocumentNo;
                            EmployeeBasic.Death_Father_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                            EmployeeBasic.Death_Father_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                            EmployeeBasic.Death_Father_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                            EmployeeBasic.Death_Father_Doc_Id__c = DeathInfo.deathDocumentUrl;
                        }
                        else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Mother)) {
                            EmployeeBasic.Death_Is_Mother_Death__c = application.DeathInfo.isDeathMother;
                            EmployeeBasic.Death_Mother_Title__c = checkEnumValue(DeathInfo.title);
                            EmployeeBasic.Death_Mother_FN__c = DeathInfo.thFirstName;
                            EmployeeBasic.Death_Mother_LN__c = DeathInfo.thLastName;
                            EmployeeBasic.Death_Mother_Doc_No__c = DeathInfo.deathDocumentNo;
                            EmployeeBasic.Death_Mother_Doc_Issue_Date__c = DeathInfo.deathDocumentIssueDate;
                            EmployeeBasic.Death_Mother_Doc_Issue_Location__c = DeathInfo.deathDocumentIssueLocation;
                            EmployeeBasic.Death_Mother_Doc_Issue_Province__c = DeathInfo.deathDocumentIssueProvince;
                            EmployeeBasic.Death_Mother_Doc_Issue_Id__c = DeathInfo.deathDocumentUrl;
                        }
                        else if(DeathInfo.deathPerson.value == String.ValueOf(ESS_Enum.DeathPerson.Child)) {
                            DeathChilds.add(DeathInfo);
                        }
                    }
                    
                    if(DeathChilds.size() > 0) {
                        EmployeeBasic.Death_Is_Child_Death__c = application.DeathInfo.isDeathChild;
                        EmployeeBasic.Death_Child_JSON__c = JSON.serialize(DeathChilds);
                    }
                    
                }
                
                //EducationInfo
                if(application.EducationInfos.size() > 0) {
                    boolean isAtleastUpdateEducation = false;
                    for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : application.EducationInfos) {
                        if(EducationInfo.isChange) {
                            isAtleastUpdateEducation = true;
                        }
                    }
                    
                    if(isAtleastUpdateEducation) {
                        EmployeeBasic.Is_Update_Education__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Education__c = false;
                    }
                    
                    //if(EmployeeBasic.Is_Update_Education__c) {
                    	EmployeeBasic.Education_JSON__c = JSON.serialize(application.EducationInfos);
                    //}
                }
                else {
                    EmployeeBasic.Education_JSON__c = null;
                    EmployeeBasic.Is_Update_Education__c = false;
                }
                
                //LicenseInfos
                if(application.LicenseInfos.size() > 0) {
                    boolean isAtleastUpdateLicense = false;
                    for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                        if(LicenseInfo.isChange) {
                            isAtleastUpdateLicense = true;
                        }
                    }
                    
                    if(isAtleastUpdateLicense) {
                        EmployeeBasic.Is_Update_License__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_License__c = false;
                    }
                    
                    if(EmployeeBasic.Is_Update_License__c) {
                    	for(ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo : application.LicenseInfos) {
                            if(LicenseInfo.licenseType.value == String.ValueOf(ESS_Enum.LicenseType.Citizen)) {
                                EmployeeBasic.License_Citizen_Id__c = LicenseInfo.citizenId;
                                EmployeeBasic.License_Citizen_New_Issue_Date__c = LicenseInfo.newIssueDate;
                                EmployeeBasic.License_Citizen_New_Expire_Date__c = LicenseInfo.newExpireDate;
                                EmployeeBasic.License_Citizen_New_Issue_Province__c = LicenseInfo.newIssuedProvince;
                                EmployeeBasic.License_Citizen_Old_Issue_Date__c = LicenseInfo.issueDate;
                                EmployeeBasic.License_Citizen_Old_Expire_Date__c = LicenseInfo.expireDate;
                                EmployeeBasic.License_Citizen_Old_Issue_Province__c = LicenseInfo.issuedProvince;
                                EmployeeBasic.License_Citizen_Copy_Doc__c = LicenseInfo.documentCitizenCopyUrl;
                            }
                            else if(LicenseInfo.licenseType.value == String.ValueOf(ESS_Enum.LicenseType.Professional)) {
                                EmployeeBasic.License_Professional_New_Doc_No__c = LicenseInfo.newLicenseNo;
                                EmployeeBasic.License_Professional_New_Doc_Level__c = LicenseInfo.newLicenseLevel;
                                EmployeeBasic.License_Professional_New_Doc_Issue_Date__c = LicenseInfo.newIssueDate;
                                EmployeeBasic.License_Professional_New_Doc_Expire_Date__c = LicenseInfo.newExpireDate;
                                EmployeeBasic.License_Professional_New_Engineer__c = LicenseInfo.newEngineeringBranch;
                                EmployeeBasic.License_Professional_Old_Doc_No__c = LicenseInfo.licenseNo;
                                EmployeeBasic.License_Professional_Old_Doc_Level__c = LicenseInfo.licenseLevel;
                                EmployeeBasic.License_Professional_Old_Doc_Issue_Date__c = LicenseInfo.issueDate;
                                EmployeeBasic.License_Professional_Old_Doc_Expire_Date__c = LicenseInfo.expireDate;
                                EmployeeBasic.License_Professional_Old_Engineer__c = LicenseInfo.engineeringBranch;
                            }
                        }
                    }
                }
                
                //AddressInfos
                if(application.AddressInfos.size() > 0) {
                    boolean isAtleastUpdateAddress = false;
                    for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                        if(AddressInfo.isChange) {
                            isAtleastUpdateAddress = true;
                        }
                    }
                    
                    if(isAtleastUpdateAddress) {
                        EmployeeBasic.Is_Update_Address__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_Address__c = false;
                    }
                    
                    if(EmployeeBasic.Is_Update_Address__c) {
                        for(ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo : application.AddressInfos) {
                            if(AddressInfo.addressType.value == String.ValueOf(ESS_Enum.AddressType.HouseRegistration)) {
                                if(AddressInfo.isChange) {
                                    EmployeeBasic.Address_Change__c = true;
                                }
                                else {
                                    EmployeeBasic.Address_Change__c = false;
                                }
                                EmployeeBasic.Address_TH_Old_House_No__c = AddressInfo.thHouseNo;
                                EmployeeBasic.Address_TH_Old_Moo_Village_Soi_Road__c = AddressInfo.thMooVillageSoiRoad;
                                EmployeeBasic.Address_TH_Old_SubDistrict_District__c = AddressInfo.thSubDistrictDistrict;
                                EmployeeBasic.Address_TH_Old_Province__c = AddressInfo.thProvince;
                                EmployeeBasic.Address_TH_Old_Postal_Code__c = AddressInfo.thPostalCode;
                                EmployeeBasic.Address_TH_Old_Telephone_No__c = AddressInfo.thTelephoneNo;
                                EmployeeBasic.Address_EN_Old_House_No__c = AddressInfo.enHouseNo;
                                EmployeeBasic.Address_EN_Old_Moo_Village_Soi_Road__c = AddressInfo.enMooVillageSoiRoad;
                                EmployeeBasic.Address_EN_Old_SubDistrict_District__c = AddressInfo.enSubDistrictDistrict;
                                EmployeeBasic.Address_EN_Old_Province__c = AddressInfo.enProvince;
                                EmployeeBasic.Address_EN_Old_Postal_Code__c = AddressInfo.enPostalCode;
                                EmployeeBasic.Address_EN_Old_Telephone_No__c = AddressInfo.enTelephoneNo;
                                
                                EmployeeBasic.Address_TH_New_House_No__c = AddressInfo.newTHHouseNo;
                                EmployeeBasic.Address_TH_New_Moo__c = AddressInfo.newTHMoo;
                                EmployeeBasic.Address_TH_New_Village_Name__c = AddressInfo.newTHVillageName;
                                EmployeeBasic.Address_TH_New_Soi__c = AddressInfo.newTHSoi;
                                EmployeeBasic.Address_TH_New_Road__c = AddressInfo.newTHRoad;
                                EmployeeBasic.Address_TH_New_Sub_District__c = AddressInfo.newTHSubDistrict;
                                EmployeeBasic.Address_TH_New_District__c = AddressInfo.newTHDistrict;
                                EmployeeBasic.Address_TH_New_Province__c = AddressInfo.newTHProvince;
                                EmployeeBasic.Address_TH_New_Telephone_No__c = AddressInfo.newTHTelephoneNo;
                                EmployeeBasic.Address_TH_New_Postal_Code__c = AddressInfo.newTHPostalCode;
                                EmployeeBasic.Address_EN_New_House_No__c = AddressInfo.newENHouseNo;
                                EmployeeBasic.Address_EN_New_Moo__c = AddressInfo.newENMoo;
                                EmployeeBasic.Address_EN_New_Village_Name__c = AddressInfo.newENVillageName;
                                EmployeeBasic.Address_EN_New_Soi__c = AddressInfo.newENSoi;
                                EmployeeBasic.Address_EN_New_Road__c = AddressInfo.newENRoad;
                                EmployeeBasic.Address_EN_New_Sub_District__c = AddressInfo.newENSubDistrict;
                                EmployeeBasic.Address_EN_New_District__c = AddressInfo.newENDistrict;
                                EmployeeBasic.Address_EN_New_Province__c = AddressInfo.newENProvince;
                                EmployeeBasic.Address_EN_New_Telephone_No__c = AddressInfo.newENTelephoneNo;
                                EmployeeBasic.Address_EN_New_Postal_Code__c = AddressInfo.newENPostalCode;
                                
                                EmployeeBasic.Address_House_Registration_Copy_Id__c = AddressInfo.documentRegistrationCopyUrl;
                            }
                            else if(AddressInfo.addressType.value == String.ValueOf(ESS_Enum.AddressType.Current)) {
                                if(AddressInfo.isChange) {
                                    EmployeeBasic.Address_Current_Change__c = true;
                                }
                                else {
                                    EmployeeBasic.Address_Current_Change__c = false;
                                }
                                EmployeeBasic.Address_TH_Current_Old_House_No__c = AddressInfo.thHouseNo;
                                EmployeeBasic.Address_TH_Current_Old_Moo_Vill_Soi_Road__c = AddressInfo.thMooVillageSoiRoad;
                                EmployeeBasic.Address_TH_Current_Old_SubDis_District__c = AddressInfo.thSubDistrictDistrict;
                                EmployeeBasic.Address_TH_Current_Old_Province__c = AddressInfo.thProvince;
                                EmployeeBasic.Address_TH_Current_Old_Postal_Code__c = AddressInfo.thPostalCode;
                                EmployeeBasic.Address_TH_Current_Old_Telephone_No__c = AddressInfo.thTelephoneNo;
                                EmployeeBasic.Address_EN_Current_Old_House_No__c = AddressInfo.enHouseNo;
                                EmployeeBasic.Address_EN_Current_Old_Moo_Vill_Soi_Road__c = AddressInfo.enMooVillageSoiRoad;
                                EmployeeBasic.Address_EN_Current_Old_SubDis_District__c = AddressInfo.enSubDistrictDistrict;
                                EmployeeBasic.Address_EN_Current_Old_Province__c = AddressInfo.enProvince;
                                EmployeeBasic.Address_EN_Current_Old_Postal_Code__c = AddressInfo.enPostalCode;
                                EmployeeBasic.Address_EN_Current_Old_Telephone_No__c = AddressInfo.enTelephoneNo;
                                
                                EmployeeBasic.Address_TH_Current_New_House_No__c = AddressInfo.newTHHouseNo;
                                EmployeeBasic.Address_TH_Current_New_Moo__c = AddressInfo.newTHMoo;
                                EmployeeBasic.Address_TH_Current_New_Village_Name__c = AddressInfo.newTHVillageName;
                                EmployeeBasic.Address_TH_Current_New_Soi__c = AddressInfo.newTHSoi;
                                EmployeeBasic.Address_TH_Current_New_Road__c = AddressInfo.newTHRoad;
                                EmployeeBasic.Address_TH_Current_New_Sub_District__c = AddressInfo.newTHSubDistrict;
                                EmployeeBasic.Address_TH_Current_New_District__c = AddressInfo.newTHDistrict;
                                EmployeeBasic.Address_TH_Current_New_Province__c = AddressInfo.newTHProvince;
                                EmployeeBasic.Address_TH_Current_New_Telephone_No__c = AddressInfo.newTHTelephoneNo;
                                EmployeeBasic.Address_TH_Current_New_Postal_Code__c = AddressInfo.newTHPostalCode;
                                EmployeeBasic.Address_EN_Current_New_House_No__c = AddressInfo.newENHouseNo;
                                EmployeeBasic.Address_EN_Current_New_Moo__c = AddressInfo.newENMoo;
                                EmployeeBasic.Address_EN_Current_New_Village_Name__c = AddressInfo.newENVillageName;
                                EmployeeBasic.Address_EN_Current_New_Soi__c = AddressInfo.newENSoi;
                                EmployeeBasic.Address_EN_Current_New_Road__c = AddressInfo.newENRoad;
                                EmployeeBasic.Address_EN_Current_New_Sub_District__c = AddressInfo.newENSubDistrict;
                                EmployeeBasic.Address_EN_Current_New_District__c = AddressInfo.newENDistrict;
                                EmployeeBasic.Address_EN_Current_New_Province__c = AddressInfo.newENProvince;
                                EmployeeBasic.Address_EN_Current_New_Telephone_No__c = AddressInfo.newENTelephoneNo;
                                EmployeeBasic.Address_EN_Current_New_Postal_Code__c = AddressInfo.newENPostalCode;
                                
                                EmployeeBasic.Address_Current_Address_Copy_Id__c = AddressInfo.documentRegistrationCopyUrl;
                            }
                    	}
                    }
                }
                
                //ContactInfos
                if(application.ContactPersonInfos.size() > 0) {
                    boolean isAtleastUpdateContact = false;
                    for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : application.ContactPersonInfos) {
                        if(ContactPersonInfo.isChange) {
                            isAtleastUpdateContact = true;
                        }
                    }
                    
                    if(isAtleastUpdateContact) {
                        EmployeeBasic.Is_Update_ContactPerson__c = true;
                    }
                    else {
                        EmployeeBasic.Is_Update_ContactPerson__c = false;
                    }
                    
                    //Combine Contact Address
                    for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : Application.ContactPersonInfos) {
                        if(ContactPersonInfo.isChange) {
                            ContactPersonInfo.thMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.thMoo, ContactPersonInfo.thVillageName, ContactPersonInfo.thSoi, ContactPersonInfo.thRoad);
                            ContactPersonInfo.thDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.thSubDistrict, ContactPersonInfo.thDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                            
                            ContactPersonInfo.enMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.enMoo, ContactPersonInfo.enVillageName, ContactPersonInfo.enSoi, ContactPersonInfo.enRoad);
                            ContactPersonInfo.enDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.enSubDistrict, ContactPersonInfo.enDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                           
                            ContactPersonInfo.newTHMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.newTHMoo, ContactPersonInfo.newTHVillageName, ContactPersonInfo.newTHSoi, ContactPersonInfo.newTHRoad);
                            ContactPersonInfo.newTHDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.newTHSubDistrict, ContactPersonInfo.newTHDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                            
                            ContactPersonInfo.newENMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.newENMoo, ContactPersonInfo.newENVillageName, ContactPersonInfo.newENSoi, ContactPersonInfo.newENRoad);
                            ContactPersonInfo.newENDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.newENSubDistrict, ContactPersonInfo.newENDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                        }
                    }
                    
                    EmployeeBasic.Contact_Person_JSON__c = JSON.serialize(application.ContactPersonInfos);
                    
                }
                else {
                    EmployeeBasic.Contact_Person_JSON__c = null;
                    EmployeeBasic.Is_Update_ContactPerson__c = false;
                }
                
                //Tax
                EmployeeBasic.Is_Update_Tax__c = application.TaxInfo.isChange;
                if(application.TaxInfo.isChange) {
                    date todayDate = date.today();
                    if(todayDate.day() <= 15) {
                        EmployeeBasic.Effective_Date__c = date.newInstance(todayDate.year(), todayDate.month(), 1);
                    }
                    else {
                        EmployeeBasic.Effective_Date__c = date.newInstance(todayDate.year(), todayDate.addMonths(1).month(), 1);
                    }
                }
                string marriedStatus = checkEnumKey(application.TaxInfo.marriedStatus);
                if(marriedStatus == String.ValueOf(ESS_Enum.MarriedStatus.Single)) {
                    EmployeeBasic.Tax_Marriage_Status__c = '0';
                } 
                else if(marriedStatus == String.ValueOf(ESS_Enum.MarriedStatus.Married)) {
                    EmployeeBasic.Tax_Marriage_Status__c = '1';
                } 
                
                string marriageEarnIncome = checkEnumKey(application.TaxInfo.marriedPersonEarnIncome);
                if(marriageEarnIncome == String.ValueOf(ESS_Enum.MarriedEarnIncome.MarriedNotEarnIncome)) {
                    EmployeeBasic.Tax_Marriage_Person_Earn_Income__c = '1';
                } 
                else if(marriageEarnIncome == String.ValueOf(ESS_Enum.MarriedEarnIncome.MarriedEarnIncome)) {
                    EmployeeBasic.Tax_Marriage_Person_Earn_Income__c = '2';
                } 
                
                EmployeeBasic.Tax_Child_Count__c = application.TaxInfo.childCount;
                EmployeeBasic.Tax_Total_Child_Count__c = application.TaxInfo.childCountTotal;
                EmployeeBasic.Tax_Self_Life_Insurance_Paid_Amount__c = application.TaxInfo.selfLifeInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Life_Insurance_Paid_Amount__c = application.TaxInfo.marriedLifeInsurancePaidAmount;
                EmployeeBasic.Tax_Self_Father_Insurance_Paid_Amount__c = application.TaxInfo.selfFatherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Self_Mother_Insurance_Paid_Amount__c = application.TaxInfo.selfMotherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Father_Insurance_Paid_Amount__c = application.TaxInfo.marriedFatherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Married_Mother_Insurance_Paid_Amount__c = application.TaxInfo.marriedMotherHealthInsurancePaidAmount;
                EmployeeBasic.Tax_Interest_On_Loan_For_House_Amount__c = application.TaxInfo.interestOnLoanForHouseAmount;
                EmployeeBasic.Tax_Income_From_RMF_Amount__c = application.TaxInfo.incomeFromRMFAmount;
                EmployeeBasic.Tax_Income_From_SSF_Amount__c = application.TaxInfo.incomeFromSSFAmount;
                EmployeeBasic.Tax_Self_Deduction_Father_Amount__c = application.TaxInfo.selfTaxDeductionFatherAmount;
                EmployeeBasic.Tax_Self_Deduction_Mother_Amount__c = application.TaxInfo.selfTaxDeductionMotherAmount;
                EmployeeBasic.Tax_Married_Deduction_Father_Amount__c = application.TaxInfo.marriedTaxDeductionFatherAmount;
                EmployeeBasic.Tax_Married_Deduction_Mother_Amount__c = application.TaxInfo.marriedTaxDeductionMotherAmount;
                EmployeeBasic.Tax_Donation_For_Charity_Amount__c = application.TaxInfo.donationForCharityAmount;
                EmployeeBasic.Tax_Sponsor_Amount__c = application.TaxInfo.sponsorAmount;
                EmployeeBasic.Tax_Donation_For_Education_Amount__c = application.TaxInfo.donationForEducationAmount;
                EmployeeBasic.Tax_Annuity_Interest_Amount__c = application.TaxInfo.annuityInterestAmount;
                EmployeeBasic.Tax_First_House_Exclude_Tax_Amount__c = application.TaxInfo.firstHouseExcludeTaxAmount;
                EmployeeBasic.Tax_Pregnancy_Care_Amount__c = application.TaxInfo.pregnancyCareAmount;
                
                //Validation
                if(application.ApplicationHeaderInfo.currentStatus.key == ESS_Enum.ApplicationStatus.Draft.name() && string.isEmpty(EmployeeBasic.Subject_Type__c)) {
                    throw new ESS_Exception('[MyError]This appliation cannot be submit. Please change some information before submit.');
                }
                
                update(EmployeeBasic);
                
                //Send to Master Directly without Verify
                if(!EmployeeBasic.Is_Update_Name__c && !EmployeeBasic.Is_Update_Status__c && !EmployeeBasic.Is_Update_Child__c && !EmployeeBasic.Is_Update_Death__c 
					&& !EmployeeBasic.Is_Update_Education__c && !EmployeeBasic.Is_Update_License__c && !EmployeeBasic.Is_Update_Address__c && 
                   (EmployeeBasic.Is_Update_ContactPerson__c || EmployeeBasic.Is_Update_Tax__c)) {
                      
                    application.id = EmployeeBasic.Id;
                	VerifyApplication(application);
                       
                    if(EmployeeBasic.Is_Update_ContactPerson__c) {
                        //Send Email to Personel Admin (ContactPerson)
                    	ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmittedContactPerson(EmployeeBasic);
                    }
                    else if(EmployeeBasic.Is_Update_Tax__c) {
                        //Send Email to Personel Admin (Tax)
                    	ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmittedTax(EmployeeBasic);
                    }
                    
                }
                else {
                    //Send Email to Personel Admin
                	ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmitted(EmployeeBasic);
                }
            }
            else {
                throw new ESS_Exception('[MyError]Cannot submit application. Application not found.');
            }
            
            return null;
            
        }
        catch(DmlException e) {
            System.debug('SubmitApplication exception has occurred: ' + e.getMessage());
        }
        
        return application;
    }
    
    @RemoteAction
    public static void VerifyApplication(ESS_EmployeeBasic_DTO.ApplicationDTO application) {

        if(application.id != null) {
            string currentStatus = ApplicationCurrentStatus(application.id);
            if(currentStatus == ESS_Enum.ApplicationStatus.Cancelled.name()) {
                throw new ESS_Exception('[MyError]This appliation status has been changed and cannot be verify.');
            }
            else if(currentStatus == ESS_Enum.ApplicationStatus.Verified.name()) {
                throw new ESS_Exception('[MyError]This appliation status has been changed and cannot be verify.');
            }
        }
        
        if(application.applicationHeaderInfo.currentStatus.key != ESS_Enum.ApplicationStatus.Draft.name()) {
            //Save before verify
            application.isProcessingVerify = true;
        	SaveApplication(application);
        }
        
        ESS_Application__c EmployeeBasic = [SELECT Address_Current_Address_Copy_Id__c,Address_EN_Current_New_District__c,Address_EN_Current_New_House_No__c,Address_EN_Current_New_Moo__c,
                                                Address_EN_Current_New_Postal_Code__c,Address_EN_Current_New_Province__c,Address_EN_Current_New_Road__c,Address_EN_Current_New_Soi__c,Address_EN_Current_New_Sub_District__c,
                                                Address_EN_Current_New_Telephone_No__c,Address_EN_Current_New_Village_Name__c,Address_EN_Current_Old_House_No__c,Address_EN_Current_Old_Moo_Vill_Soi_Road__c,Address_EN_Current_Old_Postal_Code__c,
                                                Address_EN_Current_Old_Province__c,Address_EN_Current_Old_SubDis_District__c,Address_EN_Current_Old_Telephone_No__c,Address_EN_New_District__c,Address_EN_New_House_No__c,Address_EN_New_Moo__c,
                                                Address_EN_New_Postal_Code__c,Address_EN_New_Province__c,Address_EN_New_Road__c,Address_EN_New_Soi__c,Address_EN_New_Sub_District__c,Address_EN_New_Telephone_No__c,Address_EN_New_Village_Name__c,
                                                Address_EN_Old_House_No__c,Address_EN_Old_Moo_Village_Soi_Road__c,Address_EN_Old_Postal_Code__c,Address_EN_Old_Province__c,Address_EN_Old_SubDistrict_District__c,Address_EN_Old_Telephone_No__c,
                                                Address_House_Registration_Copy_Id__c,Address_TH_Current_New_District__c,Address_TH_Current_New_House_No__c,Address_TH_Current_New_Moo__c,Address_TH_Current_New_Postal_Code__c,
                                                Address_TH_Current_New_Province__c,Address_TH_Current_New_Road__c,Address_TH_Current_New_Soi__c,Address_TH_Current_New_Sub_District__c,Address_TH_Current_New_Telephone_No__c,
                                                Address_TH_Current_New_Village_Name__c,Address_TH_Current_Old_House_No__c,Address_TH_Current_Old_Moo_Vill_Soi_Road__c,Address_TH_Current_Old_Postal_Code__c,Address_TH_Current_Old_Province__c,
                                                Address_TH_Current_Old_SubDis_District__c,Address_TH_Current_Old_Telephone_No__c,Address_TH_New_District__c,Address_TH_New_House_No__c,Address_TH_New_Moo__c,Address_TH_New_Postal_Code__c,
                                                Address_TH_New_Province__c,Address_TH_New_Road__c,Address_TH_New_Soi__c,Address_TH_New_Sub_District__c,Address_TH_New_Telephone_No__c,Address_TH_New_Village_Name__c,Address_TH_Old_House_No__c,
                                                Address_TH_Old_Moo_Village_Soi_Road__c,Address_TH_Old_Postal_Code__c,Address_TH_Old_Province__c,Address_TH_Old_SubDistrict_District__c,Address_TH_Old_Telephone_No__c,Address_Type__c,Cancelled_Date__c,
                                                Completed_Date__c,Death_Father_Doc_Id__c,Death_Father_Doc_Issue_Date__c,Death_Father_Doc_Issue_Location__c,Death_Father_Doc_Issue_Province__c,
                                                Death_Father_Doc_No__c,Death_Father_FN__c,Death_Father_LN__c,Death_Father_Title__c,Death_Is_Child_Death__c,Death_Is_Father_Death__c,Death_Is_Marriage_Death__c,Death_Is_Mother_Death__c,Death_Marriage_Doc_Id__c,
                                                Death_Marriage_Doc_Issue_Date__c,Death_Marriage_Doc_Issue_Location__c,Death_Marriage_Doc_Issue_Province__c,Death_Marriage_Doc_No__c,Death_Marriage_FN__c,Death_Marriage_LN__c,Death_Marriage_Title__c,
                                                Death_Mother_Doc_Issue_Date__c,Death_Mother_Doc_Issue_Id__c,Death_Mother_Doc_Issue_Location__c,Death_Mother_Doc_Issue_Province__c,Death_Mother_Doc_No__c,Death_Mother_FN__c,Death_Mother_LN__c,
                                                Death_Mother_Title__c,Document_No__c,Employee_ID__c,Employee_Name__c,ExternalId__c,Id,Is_Change_LN_After_Divorced__c,Is_Change_LN_After_Married__c,Is_Change_LN_After_Widow__c,
                                                Is_Change_Title_After_Divorced__c,Is_Change_Title_After_Married__c,Is_Change_Title_After_Widow__c,Is_Marriage_As_Employee__c,Is_Update_Address__c,Is_Update_Child__c,Is_Update_ContactPerson__c,
                                                Is_Update_Death__c,Is_Update_Education__c,Is_Update_License__c,Is_Update_Marriage_As_Well__c,Is_Update_Name__c,Is_Update_Status__c,Is_Update_Tax__c,License_Citizen_Copy_Doc__c,License_Citizen_Id__c,
                                                License_Citizen_New_Expire_Date__c,License_Citizen_New_Issue_Date__c,License_Citizen_New_Issue_Province__c,License_Citizen_Old_Expire_Date__c,License_Citizen_Old_Issue_Date__c,License_Citizen_Old_Issue_Province__c,
                                                License_Professional_Id__c,License_Professional_New_Doc_Expire_Date__c,License_Professional_New_Doc_Issue_Date__c,License_Professional_New_Doc_Level__c,License_Professional_New_Doc_No__c,License_Professional_New_Engineer__c,
                                                License_Professional_Old_Doc_Expire_Date__c,License_Professional_Old_Doc_Issue_Date__c,License_Professional_Old_Doc_Level__c,License_Professional_Old_Doc_No__c,License_Professional_Old_Engineer__c,Name,Name_Change_Child__c,
                                                Name_Change_Employee__c,Name_Change_Father__c,Name_Change_Marriage__c,Name_Change_Mother__c,Name_Emp_Change_Doc_Date__c,Name_Emp_Change_Doc_Id__c,Name_Emp_Change_Doc_Location__c,Name_Emp_Change_Doc_No__c,
                                                Name_Emp_EN_New_FN__c,Name_Emp_EN_New_LN__c,Name_Emp_EN_New_Title__c,Name_Emp_EN_Old_FN__c,Name_Emp_EN_Old_LN__c,Name_Emp_EN_Old_Title__c,Name_Emp_TH_FN__c,Name_Emp_TH_New_FN__c,Name_Emp_TH_New_LN__c,
                                                Name_Emp_TH_New_Title__c,Name_Emp_TH_Old_FN__c,Name_Emp_TH_Old_LN__c,Name_Emp_TH_Old_Title__c,Name_Father_Change_Doc_Date__c,Name_Father_Change_Doc_Id__c,Name_Father_Change_Doc_Location__c,Name_Father_Change_Doc_No__c,
                                                Name_Father_Change_Doc_Province__c,Name_Father_EN_New_FN__c,Name_Father_EN_New_LN__c,Name_Father_EN_New_Title__c,Name_Father_EN_Old_FN__c,Name_Father_EN_Old_LN__c,Name_Father_EN_Old_Title__c,Name_Father_TH_New_FN__c,
                                                Name_Father_TH_New_LN__c,Name_Father_TH_New_Title__c,Name_Father_TH_Old_FN__c,Name_Father_TH_Old_LN__c,Name_Father_TH_Old_Title__c,Name_Marriage_Change_Doc_Date__c,Name_Marriage_Change_Doc_Id__c,
                                                Name_Marriage_Change_Doc_Location__c,Name_Marriage_Change_Doc_No__c,Name_Marriage_Change_Doc_Province__c,Name_Marriage_EN_New_FN__c,Name_Marriage_EN_New_LN__c,Name_Marriage_EN_New_Title__c,Name_Marriage_EN_Old_FN__c,
                                                Name_Marriage_EN_Old_LN__c,Name_Marriage_EN_Old_Title__c,Name_Marriage_TH_New_FN__c,Name_Marriage_TH_New_LN__c,Name_Marriage_TH_New_Title__c,Name_Marriage_TH_Old_FN__c,Name_Marriage_TH_Old_LN__c,Name_Marriage_TH_Old_Title__c,
                                                Name_Mother_Change_Doc_Date__c,Name_Mother_Change_Doc_Id__c,Name_Mother_Change_Doc_Location__c,Name_Mother_Change_Doc_No__c,Name_Mother_Change_Doc_Province__c,Name_Mother_EN_New_FN__c,Name_Mother_EN_New_LN__c,
                                                Name_Mother_EN_New_Title__c,Name_Mother_EN_Old_FN__c,Name_Mother_EN_Old_LN__c,Name_Mother_EN_Old_Title__c,Name_Mother_TH_New_FN__c,Name_Mother_TH_New_LN__c,Name_Mother_TH_New_Title__c,Name_Mother_TH_Old_FN__c,
                                                Name_Mother_TH_Old_LN__c,Name_Mother_TH_Old_Title__c,Position__c,Status_Divorce_Change_Detail_Id__c,Status_Divorce_Change_LN__c,Status_Divorce_Change_Title__c,Status_Divorce_Doc_Id__c,Status_Divorce_Doc_Issue_Date__c,
                                                Status_Divorce_Doc_Issue_Location__c,Status_Divorce_Doc_Issue_Province__c,Status_Divorce_Doc_No__c,Status_Divorce_EN_FN__c,Status_Divorce_EN_LN__c,Status_Divorce_EN_New_LN__c,Status_Divorce_EN_New_Title__c,
                                                Status_Divorce_EN_Title__c,Status_Divorce_TH_FN__c,Status_Divorce_TH_LN__c,Status_Divorce_TH_New_LN__c,Status_Divorce_TH_New_Title__c,Status_Divorce_TH_Title__c,Status_Divorce_Use_Detail_Id__c,Status_Marriage_Change_Detail__c,
                                                Status_Marriage_Change_Doc_Copy_Id__c,Status_Marriage_Change_Doc_Id__c,Status_Marriage_Citizen_Id_Copy__c,Status_Marriage_Citizen_Id__c,Status_Marriage_DOB__c,Status_Marriage_Doc_Id__c,Status_Marriage_Doc_Issue_Date__c,
                                                Status_Marriage_Doc_Issue_Location__c,Status_Marriage_Doc_Issue_Province__c,Status_Marriage_Doc_No__c,Status_Marriage_EN_FN__c,Status_Marriage_EN_LN__c,Status_Marriage_EN_New_LN__c,Status_Marriage_EN_New_Title__c,
                                                Status_Marriage_EN_Title__c,Status_Marriage_Occupation__c,Status_Marriage_Status__c,Status_Marriage_TH_FN__c,Status_Marriage_TH_LN__c, Status_Marriage_TH_Title__c,Status_Marriage_TH_New_LN__c,Status_Marriage_TH_New_Title__c,
                                                Status_Widow_Change_Doc_Id__c,Status_Widow_Change_LN__c,Status_Widow_Change_Title__c,Status_Widow_Doc_Id__c,Status_Widow_Doc_Issue_Date__c,Status_Widow_Doc_Issue_Location__c,Status_Widow_Doc_Issue_Province__c,
                                                Status_Widow_Doc_No__c,Status_Widow_EN_FN__c,Status_Widow_EN_LN__c,Status_Widow_EN_New_LN__c,Status_Widow_EN_New_Title__c,Status_Widow_EN_Title__c,Status_Widow_TH_FN__c,Status_Widow_TH_LN__c,Status_Widow_TH_New_LN__c,
                                                Status_Widow_TH_New_Title__c,Status_Widow_TH_Title__c,Status__c,Submitted_Date__c,Tax_Annuity_Interest_Amount__c,Tax_Child_Count__c,Tax_Donation_For_Charity_Amount__c,Tax_Donation_For_Education_Amount__c,
                                                Tax_First_House_Exclude_Tax_Amount__c,Tax_Income_From_RMF_Amount__c,Tax_Income_From_SSF_Amount__c,Tax_Interest_On_Loan_For_House_Amount__c,Tax_Marriage_Person_Earn_Income__c,Tax_Marriage_Status__c,
                                                Tax_Married_Deduction_Father_Amount__c,Tax_Married_Deduction_Mother_Amount__c,Tax_Married_Father_Insurance_Paid_Amount__c,Tax_Married_Life_Insurance_Paid_Amount__c,Tax_Married_Mother_Insurance_Paid_Amount__c,
                                                Tax_Pregnancy_Care_Amount__c,Tax_Self_Deduction_Father_Amount__c,Tax_Self_Deduction_Mother_Amount__c,Tax_Self_Father_Insurance_Paid_Amount__c,Tax_Self_Life_Insurance_Paid_Amount__c,Tax_Self_Mother_Insurance_Paid_Amount__c,
                                                Tax_Sponsor_Amount__c,Tax_Total_Child_Count__c,Unit__c,Verified_Date__c,Verify_By__c, Name_Emp_Change_Doc_Province__c, Status_Marriage_Employee_Id__c,
                                            	Child_JSON__c, Death_Child_JSON__c, Name_Child_JSON__c, Name_Child_Count__c, Contact_Person_JSON__c, Education_JSON__c, CreatedDate, Name_Emp_TH_Old_Title_FN_LN__c, Status_Marriage_Gender__c, Effective_Date__c FROM ESS_Application__c where Id =:  application.id];
        
        if(!EmployeeBasic.Is_Update_Name__c && !EmployeeBasic.Is_Update_Status__c && !EmployeeBasic.Is_Update_Child__c && !EmployeeBasic.Is_Update_Death__c 
           && !EmployeeBasic.Is_Update_Education__c && !EmployeeBasic.Is_Update_License__c && !EmployeeBasic.Is_Update_Address__c && 
           (EmployeeBasic.Is_Update_ContactPerson__c || EmployeeBasic.Is_Update_Tax__c)) {
               
               EmployeeBasic.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Submitted);
        }
        else {
            EmployeeBasic.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Verified);
        }
        
        EmployeeBasic.Verified_Date__c = date.today();
        update(EmployeeBasic);
        
        //Clone to ESS Master to send to SAP
        ESS_Master_Employee__c Master = new ESS_Master_Employee__c();
        Master.Data__c = 'OUT';
        Master.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Verified);
        Master.ESS_Application__c = EmployeeBasic.Id;
        Master.ExternalId__c = EmployeeBasic.Employee_ID__c + EmployeeBasic.Id;
        Master.Employee_ID__c = EmployeeBasic.Employee_ID__c;
        Master.Employee_Name__c = EmployeeBasic.Employee_Name__c;
        Master.Position__c = EmployeeBasic.Position__c;
        Master.Unit__c = EmployeeBasic.Unit__c;
        Master.Submitted_Date__c = EmployeeBasic.Submitted_Date__c;
        Master.Verified_Date__c = EmployeeBasic.Verified_Date__c;      
        Master.Effective_Date__c = EmployeeBasic.Effective_Date__c;
        Master.Is_Update_Name__c = EmployeeBasic.Is_Update_Name__c;
        Master.Is_Update_Status__c = EmployeeBasic.Is_Update_Status__c;
        Master.Is_Update_Child__c = EmployeeBasic.Is_Update_Child__c;
        Master.Is_Update_Death__c = EmployeeBasic.Is_Update_Death__c;
        Master.Is_Update_Education__c = EmployeeBasic.Is_Update_Education__c;
        Master.Is_Update_License__c = EmployeeBasic.Is_Update_License__c;
        Master.Is_Update_Address__c = EmployeeBasic.Is_Update_Address__c;
        Master.Is_Update_ContactPerson__c = EmployeeBasic.Is_Update_ContactPerson__c;
		Master.Is_Update_Tax__c = EmployeeBasic.Is_Update_Tax__c;
        
        //Name
        if(EmployeeBasic.Is_Update_Name__c) {
            
            string nameEmpTHTitle;
            string nameEmpTHFN;
            string nameEmpTHLN;
            
            if(string.isBlank(EmployeeBasic.Name_Emp_TH_New_Title__c)) {
                nameEmpTHTitle = '';
            }
            if(string.isBlank(EmployeeBasic.Name_Emp_TH_New_FN__c)) {
                nameEmpTHFN = '';
            }
            else {
                nameEmpTHFN = EmployeeBasic.Name_Emp_TH_New_FN__c;
            }
            if(string.isBlank(EmployeeBasic.Name_Emp_TH_New_LN__c)) {
                nameEmpTHLN = '';
            }
            else {
                nameEmpTHLN = EmployeeBasic.Name_Emp_TH_New_LN__c;
            }
            
            if(string.isNotBlank(EmployeeBasic.Name_Emp_TH_New_Title__c) && EmployeeBasic.Name_Emp_TH_New_Title__c == '1') {
                nameEmpTHTitle = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
            }
            else if(string.isNotBlank(EmployeeBasic.Name_Emp_TH_New_Title__c) && EmployeeBasic.Name_Emp_TH_New_Title__c == '2') {
                nameEmpTHTitle = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
            }
            else if(string.isNotBlank(EmployeeBasic.Name_Emp_TH_New_Title__c) && EmployeeBasic.Name_Emp_TH_New_Title__c == '3') {
                nameEmpTHTitle = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
            }
            else if(string.isNotBlank(EmployeeBasic.Name_Emp_TH_New_Title__c) && EmployeeBasic.Name_Emp_TH_New_Title__c == '4') {
                nameEmpTHTitle = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
            }
            else if(string.isNotBlank(EmployeeBasic.Name_Emp_TH_New_Title__c) && EmployeeBasic.Name_Emp_TH_New_Title__c == '5') {
                nameEmpTHTitle = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
            }
            
            Master.Name_Emp_TH_Title_FN_LN__c = nameEmpTHTitle + ' ' + nameEmpTHFN + ' ' + nameEmpTHLN;
            Master.Name_Emp_EN_Title__c = EmployeeBasic.Name_Emp_EN_New_Title__c;
            Master.Name_Emp_EN_FN__c = EmployeeBasic.Name_Emp_EN_New_FN__c;
            Master.Name_Emp_EN_LN__c = EmployeeBasic.Name_Emp_EN_New_LN__c;

            Master.Name_Emp_Change_Doc_No__c = EmployeeBasic.Name_Emp_Change_Doc_No__c;
            Master.Name_Emp_Change_Doc_Issue_Location__c = EmployeeBasic.Name_Emp_Change_Doc_Location__c;
            Master.Name_Emp_Change_Doc_Issue_Province__c = EmployeeBasic.Name_Emp_Change_Doc_Province__c;
            Master.Name_Emp_Change_Doc_Issue_Date__c = EmployeeBasic.Name_Emp_Change_Doc_Date__c;
            Master.Name_Marriage_TH_Title__c = EmployeeBasic.Name_Marriage_TH_New_Title__c;
            Master.Name_Marriage_TH_FN__c = EmployeeBasic.Name_Marriage_TH_New_FN__c;
            Master.Name_Marriage_TH_LN__c = EmployeeBasic.Name_Marriage_TH_New_LN__c;
            Master.Name_Marriage_EN_Title__c = EmployeeBasic.Name_Marriage_EN_New_Title__c;
            Master.Name_Marriage_EN_FN__c = EmployeeBasic.Name_Marriage_EN_New_FN__c;
            Master.Name_Marriage_EN_LN__c = EmployeeBasic.Name_Marriage_EN_New_LN__c;
            Master.Name_Marriage_Change_Doc_No__c = EmployeeBasic.Name_Marriage_Change_Doc_No__c;
            Master.Name_Marriage_Change_Doc_Issue_Location__c = EmployeeBasic.Name_Marriage_Change_Doc_Location__c;
            Master.Name_Marriage_Change_Doc_Issue_Province__c = EmployeeBasic.Name_Marriage_Change_Doc_Province__c;
            Master.Name_Marriage_Change_Doc_Issue_Date__c = EmployeeBasic.Name_Marriage_Change_Doc_Date__c;
            Master.Name_Father_TH_Title__c = EmployeeBasic.Name_Father_TH_New_Title__c;
            Master.Name_Father_TH_FN__c = EmployeeBasic.Name_Father_TH_New_FN__c;
            Master.Name_Father_TH_LN__c = EmployeeBasic.Name_Father_TH_New_LN__c;
            Master.Name_Father_EN_Title__c = EmployeeBasic.Name_Father_EN_New_Title__c;
            Master.Name_Father_EN_FN__c = EmployeeBasic.Name_Father_EN_New_FN__c;
            Master.Name_Father_EN_LN__c = EmployeeBasic.Name_Father_EN_New_LN__c;
            Master.Name_Father_Change_Doc_No__c = EmployeeBasic.Name_Father_Change_Doc_No__c;
            Master.Name_Father_Change_Doc_Issue_Location__c = EmployeeBasic.Name_Father_Change_Doc_Location__c;
            Master.Name_Father_Change_Doc_Issue_Province__c = EmployeeBasic.Name_Father_Change_Doc_Province__c;
            Master.Name_Father_Change_Doc_Issue_Date__c = EmployeeBasic.Name_Father_Change_Doc_Date__c;
            Master.Name_Mother_TH_Title__c = EmployeeBasic.Name_Mother_TH_New_Title__c;
            Master.Name_Mother_TH_FN__c = EmployeeBasic.Name_Mother_TH_New_FN__c;
            Master.Name_Mother_TH_LN__c = EmployeeBasic.Name_Mother_TH_New_LN__c;
            Master.Name_Mother_EN_Title__c = EmployeeBasic.Name_Mother_EN_New_Title__c;
            Master.Name_Mother_EN_FN__c = EmployeeBasic.Name_Mother_EN_New_FN__c;
            Master.Name_Mother_EN_LN__c = EmployeeBasic.Name_Mother_EN_New_LN__c;
            Master.Name_Mother_Change_Doc_No__c = EmployeeBasic.Name_Mother_Change_Doc_No__c;
            Master.Name_Mother_Change_Doc_Issue_Location__c = EmployeeBasic.Name_Mother_Change_Doc_Location__c;
            Master.Name_Mother_Change_Doc_Issue_Province__c = EmployeeBasic.Name_Mother_Change_Doc_Province__c;
            Master.Name_Mother_Change_Doc_Issue_Date__c = EmployeeBasic.Name_Mother_Change_Doc_Date__c;
            
            List<ESS_EmployeeBasic_DTO.ChildInfoDTO> nameChildJSONs = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
            if(EmployeeBasic.Name_Child_JSON__c != null && string.isNotBlank(EmployeeBasic.Name_Child_JSON__c)) {
                nameChildJSONs = DeserializeChildJSON(EmployeeBasic.Name_Child_JSON__c);
                for(ESS_EmployeeBasic_DTO.ChildInfoDTO nameChild : nameChildJSONs) {
                    if(nameChild.documentChangeNameDate != null) {
                        nameChild.documentChangeNameDate = ESS_Global.convertDateTimeFromJSON(nameChild.documentChangeNameDate);
                    }
                }
                Master.Name_Child_JSON__c = JSON.serialize(nameChildJSONs);
            }
            
            if(EmployeeBasic.Name_Child_Count__c == null) {
                Master.Name_Child_Count__c = 0;
            }
            else {
                Master.Name_Child_Count__c = EmployeeBasic.Name_Child_Count__c;
            }
                        
        }
        
        //Status
        if(EmployeeBasic.Is_Update_Status__c) {
            
            if(string.isBlank(EmployeeBasic.Name_Emp_TH_New_Title__c) && string.isBlank(EmployeeBasic.Name_Emp_TH_New_FN__c) && string.isBlank(EmployeeBasic.Name_Emp_TH_New_LN__c)) {
                Master.Name_Emp_TH_Title_FN_LN__c = EmployeeBasic.Name_Emp_TH_Old_Title_FN_LN__c;
                Master.Name_Emp_EN_Title__c = EmployeeBasic.Name_Emp_EN_Old_Title__c;
                Master.Name_Emp_EN_FN__c = EmployeeBasic.Name_Emp_EN_Old_FN__c;
                Master.Name_Emp_EN_LN__c = EmployeeBasic.Name_Emp_EN_Old_LN__c;
            }
            
            //Condition 1 : Change only status
            if(!EmployeeBasic.Is_Update_Name__c) {
                Master.Name_Emp_Status_TH_Title_FN_LN__c = EmployeeBasic.Name_Emp_TH_Old_Title_FN_LN__c;
                Master.Name_Emp_Status_EN_Title__c = EmployeeBasic.Name_Emp_EN_Old_Title__c;
                Master.Name_Emp_Status_EN_FN__c = EmployeeBasic.Name_Emp_EN_Old_FN__c;
                Master.Name_Emp_Status_EN_LN__c = EmployeeBasic.Name_Emp_EN_Old_LN__c;
            }
            else if(EmployeeBasic.Is_Update_Name__c) {
                boolean isOldName = false;
                boolean isNewName = false;
                //Married
                if(EmployeeBasic.Status_Marriage_Status__c == '1') {
                    //Condition 2 : Change status before name
                    if(EmployeeBasic.Status_Marriage_Doc_Issue_Date__c < EmployeeBasic.Name_Emp_Change_Doc_Date__c) {
                        isOldName = true;
                    }
                    //Condition 3 : Change name before status
                    //Condition 4 : Change name same date as status
                    else if(EmployeeBasic.Name_Emp_Change_Doc_Date__c < EmployeeBasic.Status_Marriage_Doc_Issue_Date__c ||
                            EmployeeBasic.Name_Emp_Change_Doc_Date__c == EmployeeBasic.Status_Marriage_Doc_Issue_Date__c) {
                        isNewName = true;
                    }
                    //Condition 5 : Change only status did not change name
                    else if(EmployeeBasic.Status_Marriage_Doc_Issue_Date__c != null && EmployeeBasic.Name_Emp_Change_Doc_Date__c == null) {
                        isOldName = true;
                    }
                }
            	//Divorced
                else if(EmployeeBasic.Status_Marriage_Status__c == '3') {
                    //Condition 2 : Change status before name
                    if(EmployeeBasic.Status_Divorce_Doc_Issue_Date__c < EmployeeBasic.Name_Emp_Change_Doc_Date__c) {
                        isOldName = true;
                    }
                    //Condition 3 : Change name before status
                    //Condition 4 : Change name same date as status
                    else if(EmployeeBasic.Name_Emp_Change_Doc_Date__c < EmployeeBasic.Status_Divorce_Doc_Issue_Date__c ||
                            EmployeeBasic.Name_Emp_Change_Doc_Date__c == EmployeeBasic.Status_Divorce_Doc_Issue_Date__c) {
                        isNewName = true;
                    }
                    //Condition 5 : Change only status did not change name
                    else if(EmployeeBasic.Status_Divorce_Doc_Issue_Date__c != null && EmployeeBasic.Name_Emp_Change_Doc_Date__c == null) {
                        isOldName = true;
                    }
                }
                //Widow
                else if(EmployeeBasic.Status_Marriage_Status__c == '2') {
                    //Condition 2 : Change status before name
                    if(EmployeeBasic.Status_Widow_Doc_Issue_Date__c < EmployeeBasic.Name_Emp_Change_Doc_Date__c) {
                        isOldName = true;
                    }
                    //Condition 3 : Change name before status
                    //Condition 4 : Change name same date as status
                    else if(EmployeeBasic.Name_Emp_Change_Doc_Date__c < EmployeeBasic.Status_Widow_Doc_Issue_Date__c ||
                            EmployeeBasic.Name_Emp_Change_Doc_Date__c == EmployeeBasic.Status_Widow_Doc_Issue_Date__c) {
                        isNewName = true;
                    }
                    //Condition 5 : Change only status did not change name
                    else if(EmployeeBasic.Status_Widow_Doc_Issue_Date__c != null && EmployeeBasic.Name_Emp_Change_Doc_Date__c == null) {
                        isOldName = true;
                    }
                }
                
                if(isOldName) {
                    Master.Name_Emp_Status_TH_Title_FN_LN__c = EmployeeBasic.Name_Emp_TH_Old_Title_FN_LN__c;
                    Master.Name_Emp_Status_EN_Title__c = EmployeeBasic.Name_Emp_EN_Old_Title__c;
                    Master.Name_Emp_Status_EN_FN__c = EmployeeBasic.Name_Emp_EN_Old_FN__c;
                    Master.Name_Emp_Status_EN_LN__c = EmployeeBasic.Name_Emp_EN_Old_LN__c;
                }
                else if(isNewName) {
                    Master.Name_Emp_Status_TH_Title_FN_LN__c = Master.Name_Emp_TH_Title_FN_LN__c;
                    Master.Name_Emp_Status_EN_Title__c = Master.Name_Emp_EN_Title__c;
                    Master.Name_Emp_Status_EN_FN__c = Master.Name_Emp_EN_FN__c;
                    Master.Name_Emp_Status_EN_LN__c = Master.Name_Emp_EN_LN__c;
                }
            }
            
            
            Master.Is_Marriage_As_Employee__c = EmployeeBasic.Is_Marriage_As_Employee__c;
            Master.Status_Marriage_Status__c = EmployeeBasic.Status_Marriage_Status__c;
            Master.Status_Marriage_Employee_Id__c = EmployeeBasic.Status_Marriage_Employee_Id__c;
            Master.Status_Marriage_Change_Detail__c = EmployeeBasic.Status_Marriage_Change_Detail__c;
            
            Master.Status_Marriage_Gender__c = EmployeeBasic.Status_Marriage_Gender__c;
            Master.Status_Marriage_TH_Title__c = EmployeeBasic.Status_Marriage_TH_Title__c;
            Master.Status_Marriage_TH_FN__c = EmployeeBasic.Status_Marriage_TH_FN__c;
            Master.Status_Marriage_TH_LN__c = EmployeeBasic.Status_Marriage_TH_LN__c;
            Master.Status_Marriage_EN_Title__c = EmployeeBasic.Status_Marriage_EN_Title__c;
            Master.Status_Marriage_EN_FN__c = EmployeeBasic.Status_Marriage_EN_FN__c;
            Master.Status_Marriage_EN_LN__c = EmployeeBasic.Status_Marriage_EN_LN__c;
            
            if(EmployeeBasic.Is_Change_Title_After_Married__c) {
            	Master.Status_Marriage_Change_Title__c = EmployeeBasic.Is_Change_Title_After_Married__c;
                //Master.Name_Emp_TH_Title_FN_LN__c = EmployeeBasic.Status_Marriage_TH_New_Title__c;
                //Master.Status_Marriage_EN_Title__c = EmployeeBasic.Status_Marriage_EN_New_Title__c;
            }
            if(EmployeeBasic.Is_Change_LN_After_Married__c) {
            	Master.Status_Marriage_Change_LN__c = EmployeeBasic.Is_Change_LN_After_Married__c;
                //Master.Status_Marriage_TH_LN__c = EmployeeBasic.Status_Marriage_TH_New_LN__c;
                //Master.Status_Marriage_EN_LN__c = EmployeeBasic.Status_Marriage_EN_New_LN__c;
            }
            
            Master.Status_Marriage_Occupation__c = EmployeeBasic.Status_Marriage_Occupation__c;
            Master.Status_Marriage_Doc_No__c = EmployeeBasic.Status_Marriage_Doc_No__c;
            Master.Status_Marriage_Doc_Issue_Location__c = EmployeeBasic.Status_Marriage_Doc_Issue_Location__c;
            Master.Status_Marriage_Doc_Issue_Province__c = EmployeeBasic.Status_Marriage_Doc_Issue_Province__c;
            Master.Status_Marriage_Doc_Issue_Date__c = EmployeeBasic.Status_Marriage_Doc_Issue_Date__c;
            Master.Status_Marriage_Citizen_Id__c = EmployeeBasic.Status_Marriage_Citizen_Id__c;
            Master.Status_Marriage_DOB__c = EmployeeBasic.Status_Marriage_DOB__c;
            
            //Divorce
            Master.Status_Divorce_TH_Title__c = EmployeeBasic.Status_Divorce_TH_New_Title__c;
            Master.Status_Divorce_TH_LN__c = EmployeeBasic.Status_Divorce_TH_New_LN__c;
            Master.Status_Divorce_Change_Title__c = EmployeeBasic.Status_Divorce_Change_Title__c;
            Master.Status_Divorce_Change_LN__c = EmployeeBasic.Status_Divorce_Change_LN__c;
            Master.Status_Divorce_EN_Title__c = EmployeeBasic.Status_Divorce_EN_New_Title__c;
            Master.Status_Divorce_EN_LN__c = EmployeeBasic.Status_Divorce_EN_New_LN__c;
            Master.Status_Divorce_Doc_No__c = EmployeeBasic.Status_Divorce_Doc_No__c;
            Master.Status_Divorce_Doc_Issue_Location__c = EmployeeBasic.Status_Divorce_Doc_Issue_Location__c;
            Master.Status_Divorce_Doc_Issue_Province__c = EmployeeBasic.Status_Divorce_Doc_Issue_Province__c;
            Master.Status_Divorce_Doc_Issue_Date__c = EmployeeBasic.Status_Divorce_Doc_Issue_Date__c;
            
            //Widow
            Master.Status_Widow_TH_Title__c = EmployeeBasic.Status_Widow_TH_New_Title__c;
            Master.Status_Widow_TH_LN__c = EmployeeBasic.Status_Widow_TH_New_LN__c;
            Master.Status_Widow_Change_Title__c = EmployeeBasic.Status_Widow_Change_Title__c;
            Master.Status_Widow_Change_LN__c = EmployeeBasic.Status_Widow_Change_LN__c;
            Master.Status_Widow_EN_Title__c = EmployeeBasic.Status_Widow_EN_New_Title__c;
            Master.Status_Widow_EN_LN__c = EmployeeBasic.Status_Widow_EN_New_LN__c;
            Master.Status_Widow_Doc_No__c = EmployeeBasic.Status_Widow_Doc_No__c;
            Master.Status_Widow_Doc_Issue_Location__c = EmployeeBasic.Status_Widow_Doc_Issue_Location__c;
            Master.Status_Widow_Doc_Issue_Province__c = EmployeeBasic.Status_Widow_Doc_Issue_Province__c;
            Master.Status_Widow_Doc_Issue_Date__c = EmployeeBasic.Status_Widow_Doc_Issue_Date__c;
        }
        
        //Child
        if(EmployeeBasic.Name_Child_Count__c == null) {
			Master.Name_Child_Count__c = 0;           
        }
        else {
            Master.Name_Child_Count__c = EmployeeBasic.Name_Child_Count__c;
        }
        
        if(EmployeeBasic.Is_Update_Child__c) {
        	//Master.Child_JSON__c = EmployeeBasic.Child_JSON__c;
            List<ESS_EmployeeBasic_DTO.ChildInfoDTO> childJSONs = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
            if(EmployeeBasic.Child_JSON__c != null && string.isNotBlank(EmployeeBasic.Child_JSON__c)) {
                childJSONs = DeserializeChildJSON(EmployeeBasic.Child_JSON__c);
                for(ESS_EmployeeBasic_DTO.ChildInfoDTO nameChild : childJSONs) {
                    if(nameChild.birthDate != null) {
                    	nameChild.birthDate = ESS_Global.convertDateTimeFromJSON(nameChild.birthDate);
                    }
                    if(nameChild.gender != null) {
                        if(nameChild.gender.key == 'Male') {
                            nameChild.gender.key = '1';
                        }
                        else if(nameChild.gender.key == 'Female') {
                            nameChild.gender.key = '2';
                        }
                    }
                }
                Master.Child_JSON__c = JSON.serialize(childJSONs);
            }
        }
        
        //Death
        if(EmployeeBasic.Is_Update_Death__c) {
            Master.Death_Marriage_Title__c = EmployeeBasic.Death_Marriage_Title__c;
            Master.Death_Marriage_FN__c = EmployeeBasic.Death_Marriage_FN__c;
            Master.Death_Marriage_LN__c = EmployeeBasic.Death_Marriage_LN__c;
            Master.Death_Marriage_Doc_No__c = EmployeeBasic.Death_Marriage_Doc_No__c;
            Master.Death_Marriage_Doc_Issue_Location__c = EmployeeBasic.Death_Marriage_Doc_Issue_Location__c;
            Master.Death_Marriage_Doc_Issue_Province__c = EmployeeBasic.Death_Marriage_Doc_Issue_Province__c;
            Master.Death_Marriage_Doc_Issue_Date__c = EmployeeBasic.Death_Marriage_Doc_Issue_Date__c;
            Master.Death_Father_Title__c = EmployeeBasic.Death_Father_Title__c;
            Master.Death_Father_FN__c = EmployeeBasic.Death_Father_FN__c;
            Master.Death_Father_LN__c = EmployeeBasic.Death_Father_LN__c;
            Master.Death_Father_Doc_No__c = EmployeeBasic.Death_Father_Doc_No__c;
            Master.Death_Father_Doc_Issue_Location__c = EmployeeBasic.Death_Father_Doc_Issue_Location__c;
            Master.Death_Father_Doc_Issue_Province__c = EmployeeBasic.Death_Father_Doc_Issue_Province__c;
            Master.Death_Father_Doc_Issue_Date__c = EmployeeBasic.Death_Father_Doc_Issue_Date__c;
            Master.Death_Mother_Title__c = EmployeeBasic.Death_Mother_Title__c;
            Master.Death_Mother_FN__c = EmployeeBasic.Death_Mother_FN__c;
            Master.Death_Mother_LN__c = EmployeeBasic.Death_Mother_LN__c;
            Master.Death_Mother_Doc_No__c = EmployeeBasic.Death_Mother_Doc_No__c;
            Master.Death_Mother_Doc_Issue_Location__c = EmployeeBasic.Death_Mother_Doc_Issue_Location__c;
            Master.Death_Mother_Doc_Issue_Province__c = EmployeeBasic.Death_Mother_Doc_Issue_Province__c;
            Master.Death_Mother_Doc_Issue_Date__c = EmployeeBasic.Death_Mother_Doc_Issue_Date__c;
            
            List<ESS_EmployeeBasic_DTO.DeathInfoDTO> childJSONs = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
            if(EmployeeBasic.Death_Child_JSON__c != null && string.isNotBlank(EmployeeBasic.Death_Child_JSON__c)) {
                childJSONs = DeserializeDeathChildJSON(EmployeeBasic.Death_Child_JSON__c);
                for(ESS_EmployeeBasic_DTO.DeathInfoDTO nameChild : childJSONs) {
                    if(nameChild.deathDocumentIssueDate != null) {
                    	//nameChild.deathDocumentIssueDate = ESS_Global.convertDateTimeFromJSON(nameChild.deathDocumentIssueDate);
                    	nameChild.deathDocumentIssueDate = nameChild.deathDocumentIssueDate;
                    }
                }
                Master.Death_Child_JSON__c = JSON.serialize(childJSONs);
            }
        }
        
        //Education
        if(EmployeeBasic.Is_Update_Education__c) {
            if(string.isNotBlank(EmployeeBasic.Education_JSON__c)) {
                
            	List<ESS_EmployeeBasic_DTO.EducationInfoDTO> educationInfos = new List<ESS_EmployeeBasic_DTO.EducationInfoDTO>();
                educationInfos = DeserializeEducationJSON(EmployeeBasic.Education_JSON__c);
            
                 if(educationInfos.size() > 0) {
                    for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : educationInfos) {
                    	EducationInfo.enEducationalCountry = GetCountryAPI(EducationInfo.enEducationalCountry);
                        EducationInfo.enEducationalLevel = GetEducationLevelAPI(EducationInfo.enEducationalLevel);
                        EducationInfo.enEducationalName = GetDegreeAPI(EducationInfo.enEducationalName);
                        EducationInfo.enEducationalField = GetFieldOfStudyAPI(EducationInfo.enEducationalField);
                        EducationInfo.enEducationalInstitution = GetInstitutionAPI(EducationInfo.enEducationalInstitution);
                        if(EducationInfo.startDate != null) {
                            EducationInfo.startDate = ESS_Global.convertDateTimeFromJSON(EducationInfo.startDate);
                        }
                        if(EducationInfo.graduatedDate != null) {
                        	EducationInfo.graduatedDate = ESS_Global.convertDateTimeFromJSON(EducationInfo.graduatedDate);
                        }
                    }
                     
                    string educationJSON = JSON.serialize(educationInfos);
                	Master.Education_JSON__c = educationJSON;
                }
            }
        }
        
        //License
        if(EmployeeBasic.Is_Update_License__c) {
            Master.License_Citizen_Id__c = EmployeeBasic.License_Citizen_Id__c;
            Master.License_Citizen_Issue_Date__c = EmployeeBasic.License_Citizen_New_Issue_Date__c;
            Master.License_Citizen_Expire_Date__c = EmployeeBasic.License_Citizen_New_Expire_Date__c;
            Master.License_Citizen_Issue_Province__c = EmployeeBasic.License_Citizen_New_Issue_Province__c;
            Master.License_Professional_Doc_No__c = EmployeeBasic.License_Professional_New_Doc_No__c;
            Master.License_Professional_Doc_Level__c = EmployeeBasic.License_Professional_New_Doc_Level__c;
            Master.License_Professional_Doc_Issue_Date__c = EmployeeBasic.License_Professional_New_Doc_Issue_Date__c;
            Master.License_Professional_Doc_Expire_Date__c = EmployeeBasic.License_Professional_New_Doc_Expire_Date__c;
            Master.License_Professional_Engineer__c = EmployeeBasic.License_Professional_New_Engineer__c;
        }
            	
        //Address
        if(EmployeeBasic.Is_Update_Address__c) {
            
            //House Thai Address
            Master.Address_TH_House_No__c = EmployeeBasic.Address_TH_New_House_No__c;
            Master.Address_TH_Moo_Village_Soi_Road__c = ConvertAddressTH(EmployeeBasic.Address_TH_New_Moo__c, EmployeeBasic.Address_TH_New_Village_Name__c, EmployeeBasic.Address_TH_New_Soi__c, EmployeeBasic.Address_TH_New_Road__c);
            Master.Address_TH_SubDistrict_District__c = ConvertDistrictTH(EmployeeBasic.Address_TH_New_Sub_District__c, EmployeeBasic.Address_TH_New_District__c, EmployeeBasic.Address_TH_New_Province__c, EmployeeBasic.Address_EN_New_Province__c);
            Master.Address_TH_Postal_Code__c = EmployeeBasic.Address_TH_New_Postal_Code__c;
            Master.Address_TH_Telephone_No__c = EmployeeBasic.Address_TH_New_Telephone_No__c;
            Master.Address_TH_Province__c = EmployeeBasic.Address_TH_New_Province__c;
            
            //House English Address
            Master.Address_EN_House_No__c = EmployeeBasic.Address_EN_New_House_No__c;
            Master.Address_EN_Moo_Village_Soi_Road__c = ConvertAddressEN(EmployeeBasic.Address_EN_New_Moo__c, EmployeeBasic.Address_EN_New_Village_Name__c, EmployeeBasic.Address_EN_New_Soi__c, EmployeeBasic.Address_EN_New_Road__c); 
            Master.Address_EN_SubDistrict_District__c = ConvertDistrictEN(EmployeeBasic.Address_EN_New_Sub_District__c, EmployeeBasic.Address_EN_New_District__c, EmployeeBasic.Address_TH_New_Province__c, EmployeeBasic.Address_EN_New_Province__c);
            Master.Address_EN_Postal_Code__c = EmployeeBasic.Address_EN_New_Postal_Code__c;
            Master.Address_EN_Telephone_No__c = EmployeeBasic.Address_EN_New_Telephone_No__c;
            Master.Address_EN_Province__c = EmployeeBasic.Address_EN_New_Province__c;
            
            //Current Address TH
            Master.Address_TH_Current_House_No__c = EmployeeBasic.Address_TH_Current_New_House_No__c;
            Master.Address_TH_Current_Moo_Village_Soi_Road__c = ConvertAddressTH(EmployeeBasic.Address_TH_Current_New_Moo__c, EmployeeBasic.Address_TH_Current_New_Village_Name__c, EmployeeBasic.Address_TH_Current_New_Soi__c, EmployeeBasic.Address_TH_Current_New_Road__c); 
            Master.Address_TH_Current_SubDistrict_District__c = ConvertDistrictTH(EmployeeBasic.Address_TH_Current_New_Sub_District__c, EmployeeBasic.Address_TH_Current_New_District__c, EmployeeBasic.Address_TH_Current_New_Province__c, EmployeeBasic.Address_EN_Current_New_Province__c);
            Master.Address_TH_Current_Postal_Code__c = EmployeeBasic.Address_TH_Current_New_Postal_Code__c;
            Master.Address_TH_Current_Telephone_No__c = EmployeeBasic.Address_TH_Current_New_Telephone_No__c;
            Master.Address_TH_Current_Province__c = EmployeeBasic.Address_TH_Current_New_Province__c;
            
            //Current Address EN
            Master.Address_EN_Current_House_No__c = EmployeeBasic.Address_EN_Current_New_House_No__c;
            Master.Address_EN_Current_Moo_Village_Soi_Road__c = ConvertAddressEN(EmployeeBasic.Address_EN_Current_New_Moo__c, EmployeeBasic.Address_EN_Current_New_Village_Name__c, EmployeeBasic.Address_EN_Current_New_Soi__c, EmployeeBasic.Address_EN_Current_New_Road__c); 
            Master.Address_EN_Current_SubDistrict_District__c = ConvertDistrictEN(EmployeeBasic.Address_EN_Current_New_Sub_District__c, EmployeeBasic.Address_EN_Current_New_District__c, EmployeeBasic.Address_TH_Current_New_Province__c, EmployeeBasic.Address_EN_Current_New_Province__c);
            Master.Address_EN_Current_Postal_Code__c = EmployeeBasic.Address_EN_Current_New_Postal_Code__c;
            Master.Address_EN_Current_Telephone_No__c = EmployeeBasic.Address_EN_Current_New_Telephone_No__c;
            Master.Address_EN_Current_Province__c = EmployeeBasic.Address_EN_Current_New_Province__c;
            
        }
        
        //ContactPerson
        if(EmployeeBasic.Is_Update_ContactPerson__c) {
		    Master.Contact_Person_JSON__c = EmployeeBasic.Contact_Person_JSON__c;
		}
        
        //Tax
        if(EmployeeBasic.Is_Update_Tax__c) {
            Master.Tax_Marriage_Status__c = EmployeeBasic.Tax_Marriage_Status__c;
            if(EmployeeBasic.Tax_Marriage_Status__c == '1') {
                Master.Tax_Marriage_Person_Earn_Income__c = EmployeeBasic.Tax_Marriage_Person_Earn_Income__c;
            }
            Master.Tax_Child_Count__c = EmployeeBasic.Tax_Child_Count__c;
            Master.Tax_Total_Child_Count__c = EmployeeBasic.Tax_Total_Child_Count__c;
            Master.Tax_Self_Life_Insurance_Paid_Amount__c = EmployeeBasic.Tax_Self_Life_Insurance_Paid_Amount__c;
            Master.Tax_Married_Life_Insurance_Paid_Amount__c = EmployeeBasic.Tax_Married_Life_Insurance_Paid_Amount__c;
            Master.Tax_Self_Father_Insurance_Paid_Amount__c = EmployeeBasic.Tax_Self_Father_Insurance_Paid_Amount__c;
            Master.Tax_Self_Mother_Insurance_Paid_Amount__c = EmployeeBasic.Tax_Self_Mother_Insurance_Paid_Amount__c;
            Master.Tax_Married_Father_Insurance_Paid_Amount__c = EmployeeBasic.Tax_Married_Father_Insurance_Paid_Amount__c;
            Master.Tax_Married_Mother_Insurance_Paid_Amount__c = EmployeeBasic.Tax_Married_Mother_Insurance_Paid_Amount__c;
            Master.Tax_Interest_On_Loan_For_House_Amount__c = EmployeeBasic.Tax_Interest_On_Loan_For_House_Amount__c;
            Master.Tax_Income_From_RMF_Amount__c = EmployeeBasic.Tax_Income_From_RMF_Amount__c;
            Master.Tax_Income_From_SSF_Amount__c = EmployeeBasic.Tax_Income_From_SSF_Amount__c;
            Master.Tax_Self_Deduction_Father_Amount__c = EmployeeBasic.Tax_Self_Deduction_Father_Amount__c;
            Master.Tax_Self_Deduction_Mother_Amount__c = EmployeeBasic.Tax_Self_Deduction_Mother_Amount__c;
            Master.Tax_Married_Deduction_Father_Amount__c = EmployeeBasic.Tax_Married_Deduction_Father_Amount__c;
            Master.Tax_Married_Deduction_Mother_Amount__c = EmployeeBasic.Tax_Married_Deduction_Mother_Amount__c;
            Master.Tax_Donation_For_Charity_Amount__c = EmployeeBasic.Tax_Donation_For_Charity_Amount__c;
            Master.Tax_Sponsor_Amount__c = EmployeeBasic.Tax_Sponsor_Amount__c;
            Master.Tax_Donation_For_Education_Amount__c = EmployeeBasic.Tax_Donation_For_Education_Amount__c;
            Master.Tax_Annuity_Interest_Amount__c = EmployeeBasic.Tax_Annuity_Interest_Amount__c;
            Master.Tax_First_House_Exclude_Tax_Amount__c = EmployeeBasic.Tax_First_House_Exclude_Tax_Amount__c;
            Master.Tax_Pregnancy_Care_Amount__c = EmployeeBasic.Tax_Pregnancy_Care_Amount__c;
        }
        
        try {
        	insert(Master);
        }
        catch(DmlException e) {
            System.debug(e);
        }
    }

    @RemoteAction
    public static void CancelApplication(string applicationId) {
        
        string currentStatus = ApplicationCurrentStatus(applicationId);
        if(currentStatus == ESS_Enum.ApplicationStatus.Cancelled.name()) {
            throw new ESS_Exception('[MyError]This appliation status has been changed and cannot be cancel.');
        }
        else if(currentStatus == ESS_Enum.ApplicationStatus.Verified.name()) {
            throw new ESS_Exception('[MyError]This appliation status has been changed and cannot be cancel.');
        }
        
        ESS_Application__c Application = [select id, Status__c, OwnerId, CreatedDate, Submitted_Date__c, Document_No__c, Employee_ID__c, Employee_Name__c from ESS_Application__c where Id =: applicationId];
        Application.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Cancelled);
        Application.Cancelled_Date__c = date.today();
        update(Application);
        //Send email to Owner when Cancel
        ESS_NotiAndEmailController.ApplicationSendToOwnerWhenCancelled(Application);
    }
    
    @RemoteAction
    public static void DeleteApplication(string applicationId) {
        ESS_Application__c Application = [select id, Status__c, OwnerId, CreatedDate, Submitted_Date__c, Document_No__c, Employee_ID__c, Employee_Name__c from ESS_Application__c where Id =: applicationId];
        delete(Application);
    }
    
    @RemoteAction
    public static ESS_EmployeeBasic_DTO.TaxInfoDTO GetTaxInfo(string employeeId) {
        
        ESS_EmployeeBasic_DTO.TaxInfoDTO TaxInfo = new ESS_EmployeeBasic_DTO.TaxInfoDTO();
        
        ESS_Master_Employee__c Master = [SELECT Address_EN_Current_House_No__c,Address_EN_Current_Moo_Village_Soi_Road__c,Address_EN_Current_Postal_Code__c,Address_EN_Current_Province__c,
                                             	Address_EN_Current_SubDistrict_District__c,Address_EN_Current_Telephone_No__c,Address_EN_House_No__c,Address_EN_Moo_Village_Soi_Road__c,Address_EN_Postal_Code__c,
                                             	Address_EN_Province__c,Address_EN_SubDistrict_District__c,Address_EN_Telephone_No__c,Address_TH_Current_House_No__c,Address_TH_Current_Moo_Village_Soi_Road__c,
                                             	Address_TH_Current_Postal_Code__c,Address_TH_Current_Province__c,Address_TH_Current_SubDistrict_District__c,Address_TH_Current_Telephone_No__c,Address_TH_House_No__c,
                                             	Address_TH_Moo_Village_Soi_Road__c,Address_TH_Postal_Code__c,Address_TH_Province__c,Address_TH_SubDistrict_District__c,Address_TH_Telephone_No__c,Cancelled__c,
                                             	Completed_Date__c,CreatedDate,Created_Date__c,Data__c,Death_Father_Doc_Issue_Date__c,Death_Father_Doc_Issue_Location__c,
                                             	Death_Father_Doc_Issue_Province__c,Death_Father_Doc_No__c,Death_Father_FN__c,Death_Father_LN__c,Death_Father_Title__c,Death_Marriage_Doc_Issue_Date__c,
                                             	Death_Marriage_Doc_Issue_Location__c,Death_Marriage_Doc_Issue_Province__c,Death_Marriage_Doc_No__c,Death_Marriage_FN__c,Death_Marriage_LN__c,Death_Marriage_Title__c,
                                             	Death_Mother_Doc_Issue_Date__c,Death_Mother_Doc_Issue_Location__c,Death_Mother_Doc_Issue_Province__c,Death_Mother_Doc_No__c,Death_Mother_FN__c,Death_Mother_LN__c,Death_Mother_Title__c,
                                             	Document_No__c,Employee_ID__c,Employee_Name__c,ESS_Application__c,ExternalId__c,Id,Is_Marriage_As_Employee__c,Is_Update_Address__c,Is_Update_Child__c,
                                             	Is_Update_ContactPerson__c,Is_Update_Death__c,Is_Update_Education__c,Is_Update_License__c,Is_Update_Name__c,Is_Update_Status__c,Is_Update_Tax__c,License_Citizen_Expire_Date__c,
                                             	License_Citizen_Id__c,License_Citizen_Issue_Date__c,License_Citizen_Issue_Province__c,License_Professional_Doc_Expire_Date__c,License_Professional_Doc_Issue_Date__c,
                                             	License_Professional_Doc_Level__c,License_Professional_Doc_No__c,License_Professional_Engineer__c,Name,Name_Emp_Change_Doc_Issue_Date__c,Name_Emp_Change_Doc_Issue_Location__c,
                                             	Name_Emp_Change_Doc_Issue_Province__c,Name_Emp_Change_Doc_No__c,Name_Emp_EN_FN__c,Name_Emp_EN_LN__c,Name_Emp_EN_Title__c,Name_Emp_TH_Title_FN_LN__c,Name_Father_Change_Doc_Issue_Date__c,
                                             	Name_Father_Change_Doc_Issue_Location__c,Name_Father_Change_Doc_Issue_Province__c,Name_Father_Change_Doc_No__c,Name_Father_EN_FN__c,Name_Father_EN_LN__c,Name_Father_EN_Title__c,
                                             	Name_Father_TH_FN__c,Name_Father_TH_LN__c,Name_Father_TH_Title__c,Name_Marriage_Change_Doc_Issue_Date__c,Name_Marriage_Change_Doc_Issue_Location__c,Name_Marriage_Change_Doc_Issue_Province__c,
                                             	Name_Marriage_Change_Doc_No__c,Name_Marriage_EN_FN__c,Name_Marriage_EN_LN__c,Name_Marriage_EN_Title__c,Name_Marriage_TH_FN__c,Name_Marriage_TH_LN__c,Name_Marriage_TH_Title__c,
                                             	Name_Mother_Change_Doc_Issue_Date__c,Name_Mother_Change_Doc_Issue_Location__c,Name_Mother_Change_Doc_Issue_Province__c,Name_Mother_Change_Doc_No__c,Name_Mother_EN_FN__c,
                                             	Name_Mother_EN_LN__c,Name_Mother_EN_Title__c,Name_Mother_TH_FN__c,Name_Mother_TH_LN__c,Name_Mother_TH_Title__c,Position__c,SAP_JSON__c,Status_Divorce_Change_LN__c,
                                             	Status_Divorce_Change_Title__c,Status_Divorce_Doc_Issue_Date__c,Status_Divorce_Doc_Issue_Location__c,Status_Divorce_Doc_Issue_Province__c,Status_Divorce_Doc_No__c,
                                             	Status_Divorce_EN_FN__c,Status_Divorce_EN_LN__c,Status_Divorce_EN_New_LN__c,Status_Divorce_EN_New_Title__c,Status_Divorce_EN_Title__c,Status_Divorce_TH_FN__c,Status_Divorce_TH_LN__c,
                                             	Status_Divorce_TH_New_LN__c,Status_Divorce_TH_New_Title__c,Status_Divorce_TH_Title__c,Status_Marriage_Citizen_Id__c,Status_Marriage_DOB__c,Status_Marriage_Doc_Issue_Date__c,
                                             	Status_Marriage_Doc_Issue_Location__c,Status_Marriage_Doc_Issue_Province__c,Status_Marriage_Doc_No__c,Status_Marriage_EN_FN__c,Status_Marriage_EN_LN__c,Status_Marriage_EN_Title__c,
                                             	Status_Marriage_Occupation__c,Status_Marriage_Status__c,Status_Marriage_TH_Title__c,Status_Marriage_TH_FN__c,Status_Marriage_TH_LN__c, Status_Marriage_TH_New_Title__c,Status_Marriage_TH_New_LN__c,Status_Marriage_EN_New_Title__c,Status_Marriage_EN_New_LN__c,
                                             	Status_Marriage_Change_Title__c, Status_Marriage_Change_LN__c,Status_Widow_Change_LN__c,Status_Widow_Change_Title__c,Status_Widow_Doc_Issue_Date__c,
                                             	Status_Widow_Doc_Issue_Location__c,Status_Widow_Doc_Issue_Province__c,Status_Widow_Doc_No__c,Status_Widow_EN_FN__c,Status_Widow_EN_LN__c,Status_Widow_EN_New_LN__c,Status_Widow_EN_New_Title__c,
                                             	Status_Widow_EN_Title__c,Status_Widow_TH_FN__c,Status_Widow_TH_LN__c,Status_Widow_TH_New_LN__c,Status_Widow_TH_New_Title__c,Status_Widow_TH_Title__c,Status__c,Submitted_Date__c,
                                             	Tax_Annuity_Interest_Amount__c,Tax_Child_Count__c,Tax_Donation_For_Charity_Amount__c,Tax_Donation_For_Education_Amount__c,Tax_First_House_Exclude_Tax_Amount__c,Tax_Income_From_RMF_Amount__c,
                                             	Tax_Income_From_SSF_Amount__c,Tax_Interest_On_Loan_For_House_Amount__c,Tax_Marriage_Person_Earn_Income__c,Tax_Marriage_Status__c,Tax_Married_Deduction_Father_Amount__c,
                                             	Tax_Married_Deduction_Mother_Amount__c,Tax_Married_Father_Insurance_Paid_Amount__c,Tax_Married_Life_Insurance_Paid_Amount__c,Tax_Married_Mother_Insurance_Paid_Amount__c,
                                             	Tax_Pregnancy_Care_Amount__c,Tax_Self_Deduction_Father_Amount__c,Tax_Self_Deduction_Mother_Amount__c,Tax_Self_Father_Insurance_Paid_Amount__c,Tax_Self_Life_Insurance_Paid_Amount__c,
                                             	Tax_Self_Mother_Insurance_Paid_Amount__c,Tax_Sponsor_Amount__c,Tax_Total_Child_Count__c,Unit__c,Verified_Date__c, OwnerId, Status_Marriage_Employee_Id__c,
                                             	Child_JSON__c, Death_Child_JSON__c, Name_Child_JSON__c, Name_Child_Count__c, Contact_Person_JSON__c, Education_JSON__c, Status_Marriage_Change_Detail__c  FROM ESS_Master_Employee__c where Employee_ID__c = :employeeId AND Data__c = 'IN'];
       
        
        TaxInfo.name = Master.Employee_Name__c;
        TaxInfo.citizenId = Master.License_Citizen_Id__c;

        TaxInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
        if(Master.Tax_Marriage_Status__c == '0') {
            TaxInfo.marriedStatus.key = ESS_Enum.MarriedStatus.Single.name();
            TaxInfo.marriedStatus.value = 'Single';
        }
        else if(Master.Tax_Marriage_Status__c == '1') {
            TaxInfo.marriedStatus.key = ESS_Enum.MarriedStatus.Married.name();
            TaxInfo.marriedStatus.value = 'Married';
        }
        
        TaxInfo.marriedPersonEarnIncome = new ESS_Global.EnumValue('MarriedEarnIncome'); 
        if(Master.Tax_Marriage_Person_Earn_Income__c == '2') {
            TaxInfo.marriedPersonEarnIncome.key = ESS_Enum.MarriedEarnIncome.MarriedEarnIncome.name();
            TaxInfo.marriedPersonEarnIncome.value = 'คู่สมรสมีเงินได้';
        }
        else if(Master.Tax_Marriage_Person_Earn_Income__c == '1') {
            TaxInfo.marriedPersonEarnIncome.key = ESS_Enum.MarriedEarnIncome.MarriedNotEarnIncome.name();
            TaxInfo.marriedPersonEarnIncome.value = 'คู่สมรสไม่มีเงินได้';
        }
        
		TaxInfo.childCount = Integer.ValueOf(Master.Tax_Child_Count__c);
        TaxInfo.childCountTotal = Integer.ValueOf(Master.Tax_Total_Child_Count__c);
        TaxInfo.selfLifeInsurancePaidAmount = Master.Tax_Self_Life_Insurance_Paid_Amount__c;
        TaxInfo.marriedLifeInsurancePaidAmount = Master.Tax_Married_Life_Insurance_Paid_Amount__c;
        TaxInfo.selfFatherHealthInsurancePaidAmount = Master.Tax_Self_Father_Insurance_Paid_Amount__c;
        TaxInfo.selfMotherHealthInsurancePaidAmount = Master.Tax_Self_Mother_Insurance_Paid_Amount__c;
        TaxInfo.marriedFatherHealthInsurancePaidAmount = Master.Tax_Married_Father_Insurance_Paid_Amount__c;
        TaxInfo.marriedMotherHealthInsurancePaidAmount = Master.Tax_Married_Mother_Insurance_Paid_Amount__c;
        TaxInfo.interestOnLoanForHouseAmount = Master.Tax_Interest_On_Loan_For_House_Amount__c;
        TaxInfo.incomeFromRMFAmount = Master.Tax_Income_From_RMF_Amount__c;
        TaxInfo.incomeFromSSFAmount = Master.Tax_Income_From_SSF_Amount__c;
        TaxInfo.selfTaxDeductionFatherAmount = Master.Tax_Self_Deduction_Father_Amount__c;
        TaxInfo.selfTaxDeductionMotherAmount = Master.Tax_Self_Deduction_Mother_Amount__c;
        TaxInfo.marriedTaxDeductionFatherAmount = Master.Tax_Married_Deduction_Father_Amount__c;
        TaxInfo.marriedTaxDeductionMotherAmount = Master.Tax_Married_Deduction_Mother_Amount__c;
        TaxInfo.donationForCharityAmount = Master.Tax_Donation_For_Charity_Amount__c;
        TaxInfo.sponsorAmount = Master.Tax_Sponsor_Amount__c;
        TaxInfo.donationForEducationAmount = Master.Tax_Donation_For_Education_Amount__c;
        TaxInfo.annuityInterestAmount = Master.Tax_Annuity_Interest_Amount__c;
        TaxInfo.firstHouseExcludeTaxAmount = Master.Tax_First_House_Exclude_Tax_Amount__c;
        TaxInfo.pregnancyCareAmount = Master.Tax_Pregnancy_Care_Amount__c;
        
        return TaxInfo;
        
    }
    
    @RemoteAction
    public static List<ESS_EmployeeBasic_DTO.SearchNameDTO> SearchMarriage(string search) {
        
        List<ESS_EmployeeBasic_DTO.SearchNameDTO> SearchNames = new List<ESS_EmployeeBasic_DTO.SearchNameDTO>();
        List<ESS_Master_Employee__c> MasterEmployees = new List<ESS_Master_Employee__c>();
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        string searchName = '%' + search + '%';
        
        //Master Employee
        string query = 'select id , Employee_ID__c, Name_Emp_EN_Title__c, Name_Emp_EN_FN__c, Name_Emp_EN_LN__c, Name_Emp_TH_Title_FN_LN__c from ESS_Master_Employee__c';
        query = query + ' where (employee_id__c like: searchName OR name_emp_en_fn__c like: searchName) AND Data__c = \'IN\' LIMIT 100';
        MasterEmployees = database.query(query);
        
        //PISUsers
        string queryPIS = 'select id , employeeid__c, thtitle__c, thfirstname__c, thlastname__c, active__c, mainposition__c from PISUsers__c';
        queryPIS = queryPIS + ' where (employeeid__c like: searchName OR enfirstname__c like: searchName) AND active__c = true AND mainposition__c = true LIMIT 100';
        PISUsers = database.query(queryPIS);
        
        if(MasterEmployees.size() > 0) {
            for(ESS_Master_Employee__c Master : MasterEmployees) {
                
                ESS_EmployeeBasic_DTO.SearchNameDTO SearchNameDTO = new ESS_EmployeeBasic_DTO.SearchNameDTO();
                string employeeName = '';
                if(string.isNotBlank(Master.Name_Emp_EN_FN__c)) {
                    employeeName = Master.Name_Emp_EN_FN__c;
                }
                SearchNameDTO.displayName = Master.Employee_ID__c + ' - ' + employeeName + ' ' + Master.Name_Emp_EN_LN__c;
                
                if(Master.Name_Emp_EN_Title__c == '1') {
                    SearchNameDTO.enTitle = String.ValueOf(ESS_Enum.Title.Mr);
                }
                else if(Master.Name_Emp_EN_Title__c == '2') {
                    SearchNameDTO.enTitle = String.ValueOf(ESS_Enum.Title.Mrs);
                }
                else if(Master.Name_Emp_EN_Title__c == '3') {
                    SearchNameDTO.enTitle = String.ValueOf(ESS_Enum.Title.Miss);
                }
                else if(Master.Name_Emp_EN_Title__c == '4') {
                    SearchNameDTO.enTitle = String.ValueOf(ESS_Enum.Title.Ms);
                }
                else if(Master.Name_Emp_EN_Title__c == '5') {
                    SearchNameDTO.enTitle = String.ValueOf(ESS_Enum.Title.Dr);
                }
                
                SearchNameDTO.enFirstName = Master.Name_Emp_EN_FN__c;
                SearchNameDTO.enLastName = Master.Name_Emp_EN_LN__c;
                SearchNameDTO.employeeId = Master.Employee_ID__c;
                
                if(PISUsers.size() > 0) {
                    for(PISUsers__c PISUser : PISUsers) {
                        
                        if(PISUser.employeeid__c == Master.Employee_ID__c) {
                            
                            if(PISUser.THTITLE__c == 'นาย') {
                                SearchNameDTO.thTitle = String.ValueOf(ESS_Enum.Title.Mr);
                            }
                            else if(PISUser.THTITLE__c == 'นาง') {
                                SearchNameDTO.thTitle = String.ValueOf(ESS_Enum.Title.Mrs);
                            }
                            else if(PISUser.THTITLE__c == 'น.ส.') {
                                SearchNameDTO.thTitle = String.ValueOf(ESS_Enum.Title.Miss);
                            }
                            
                            SearchNameDTO.thFirstName = PISUser.THFIRSTNAME__c;
                            SearchNameDTO.thLastName = PISUser.THLASTNAME__c;
                                
                            break;
                        }
                        
                    }
                }
                
                SearchNames.add(SearchNameDTO);
			}
        }
        
        
        
        return SearchNames;
        
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

    public class UploadFileResponse {
        @RemoteAction
        public string documentId {get;set;}
    }
    
    //Assign to DTO section
    @TestVisible
    private static ESS_EmployeeBasic_DTO.ApplicationListDTO assignToApplicationListDTO(ESS_Application__c EmployeeBasic) {
        
        ESS_EmployeeBasic_DTO.ApplicationListDTO Application = new ESS_EmployeeBasic_DTO.ApplicationListDTO();
        
        Application.id = EmployeeBasic.Id;
        Application.documentNo = EmployeeBasic.Document_No__c;
        if(string.isNotEmpty(EmployeeBasic.Subject_Type__c)) {
            Application.subjectType = EmployeeBasic.Subject_Type__c;
        }
        else {
            Application.subjectType = '-';
        }
        Application.employeeId = EmployeeBasic.Employee_ID__c;
        Application.employeeName = EmployeeBasic.Employee_Name__c;
        
        Application.currentStatus = new ESS_Global.EnumValue('ApplicationStatus');
        if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Draft)) {
            Application.currentStatus.key = ESS_Enum.ApplicationStatus.Draft.name();
            Application.currentStatus.value = 'Draft';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Submitted)) {
            Application.currentStatus.key = ESS_Enum.ApplicationStatus.Submitted.name();
            Application.currentStatus.value = 'Submitted'; //WaitingToVerify
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Verified)) {
            Application.currentStatus.key = ESS_Enum.ApplicationStatus.Verified.name();
            Application.currentStatus.value = 'Verified';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Completed)) {
            Application.currentStatus.key = ESS_Enum.ApplicationStatus.Completed.name();
            Application.currentStatus.value = 'Completed';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Cancelled)) {
            Application.currentStatus.key = ESS_Enum.ApplicationStatus.Cancelled.name();
            Application.currentStatus.value = 'Cancelled';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.SendingToSAP)) {
            Application.currentStatus.key = ESS_Enum.ApplicationStatus.SendingToSAP.name();
            Application.currentStatus.value = 'Sending to SAP';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Error)) {
            Application.currentStatus.key = ESS_Enum.ApplicationStatus.Error.name();
            Application.currentStatus.value = 'Error update in SAP';
        }
        
        if(EmployeeBasic.CreatedDate != null) {
            Application.createdDate = EmployeeBasic.CreatedDate.date();
        }
                
        if(EmployeeBasic.Submitted_Date__c != null) {
        	Application.submittedDate = EmployeeBasic.Submitted_Date__c;
        }
        
        if(EmployeeBasic.Verified_Date__c != null) {
            Application.verifiedDate = EmployeeBasic.Verified_Date__c;
        }
        
        if(EmployeeBasic.Completed_Date__c != null) {
        	Application.completedDate = EmployeeBasic.Completed_Date__c;
        }
        
        if(EmployeeBasic.Cancelled_Date__c != null) {
        	Application.cancelledDate = EmployeeBasic.Cancelled_Date__c;
        }
        
        Application.canDelete = checkCanDelete(EmployeeBasic);
        
        return Application;
        
    }
    
    public static boolean checkCanDelete(ESS_Application__c model){
        boolean result = false;
        if (model.Status__c == ESS_Enum.ApplicationStatus.Draft.name())
        {
            result = true;
        }
        return result;
    }
    
    @TestVisible
    private static ESS_EmployeeBasic_DTO.ApplicationDTO assignToApplicationDTO(ESS_Application__c EmployeeBasic) {
        
        ESS_EmployeeBasic_DTO.ApplicationDTO Application = new ESS_EmployeeBasic_DTO.ApplicationDTO();
        Application.id = EmployeeBasic.Id;
        
        //Header
        Application.ApplicationHeaderInfo = new ESS_EmployeeBasic_DTO.ApplicationHeaderInfoDTO();
        
        PISUsers__c Owner = ESS_Global.assignToPISUser(EmployeeBasic.OwnerId);
        if(Owner.COMPANYNAME__c == 'TOP') {
            application.applicationHeaderInfo.isTopEmployee = true;
        }
        else {
            application.applicationHeaderInfo.isTopEmployee = false;
        }
        Application.ApplicationHeaderInfo.documentNo = EmployeeBasic.Document_No__c;
        Application.ApplicationHeaderInfo.employeeId = Owner.EMPLOYEEID__c;
        Application.ApplicationHeaderInfo.employeeName = Owner.EN_Fullname__c;
        Application.ApplicationHeaderInfo.position = EmployeeBasic.Position__c;
        Application.ApplicationHeaderInfo.unit = EmployeeBasic.Unit__c;
        Application.ApplicationHeaderInfo.documentNo = EmployeeBasic.Document_No__c;
        
        Application.ApplicationHeaderInfo.currentStatus = new ESS_Global.EnumValue('ApplicationStatus');
        if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Draft)) {
            Application.ApplicationHeaderInfo.currentStatus.key = ESS_Enum.ApplicationStatus.Draft.name();
            Application.ApplicationHeaderInfo.currentStatus.value = 'Draft';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Submitted)) {
            Application.ApplicationHeaderInfo.currentStatus.key = ESS_Enum.ApplicationStatus.Submitted.name();
            Application.ApplicationHeaderInfo.currentStatus.value = 'Submitted'; //WaitingToVerify
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Verified)) {
            Application.ApplicationHeaderInfo.currentStatus.key = ESS_Enum.ApplicationStatus.Verified.name();
            Application.ApplicationHeaderInfo.currentStatus.value = 'Verified';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Completed)) {
            Application.ApplicationHeaderInfo.currentStatus.key = ESS_Enum.ApplicationStatus.Completed.name();
            Application.ApplicationHeaderInfo.currentStatus.value = 'Completed';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Cancelled)) {
            Application.ApplicationHeaderInfo.currentStatus.key = ESS_Enum.ApplicationStatus.Cancelled.name();
            Application.ApplicationHeaderInfo.currentStatus.value = 'Cancelled';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.SendingToSAP)) {
            Application.ApplicationHeaderInfo.currentStatus.key = ESS_Enum.ApplicationStatus.SendingToSAP.name();
            Application.ApplicationHeaderInfo.currentStatus.value = 'Sending to SAP';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Error)) {
            Application.ApplicationHeaderInfo.currentStatus.key = ESS_Enum.ApplicationStatus.Error.name();
            Application.ApplicationHeaderInfo.currentStatus.value = 'Error update in SAP';
        }
        
        if(EmployeeBasic.CreatedDate != null) {
            Application.ApplicationHeaderInfo.createdDate = EmployeeBasic.CreatedDate.date();
        }
        
        if(EmployeeBasic.Submitted_Date__c != null) {
        	Application.ApplicationHeaderInfo.submittedDate = EmployeeBasic.Submitted_Date__c;
        }
        
        if(EmployeeBasic.Verified_Date__c != null) {
            Application.ApplicationHeaderInfo.verifiedDate = EmployeeBasic.Verified_Date__c;
        }
        
        if(EmployeeBasic.Completed_Date__c != null) {
        	Application.ApplicationHeaderInfo.completedDate = EmployeeBasic.Completed_Date__c;
        }
        
        if(EmployeeBasic.Cancelled_Date__c != null) {
        	Application.ApplicationHeaderInfo.cancelledDate = EmployeeBasic.Cancelled_Date__c;
        }
        
        if(EmployeeBasic.Effective_Date__c != null) {
        	Application.ApplicationHeaderInfo.effectiveDate = EmployeeBasic.Effective_Date__c;
        }
        
        //NameInfo
        Application.NameInfo = new ESS_EmployeeBasic_DTO.NameInfoDTO();
        Application.NameInfo.isChange = EmployeeBasic.Is_Update_Name__c;
        Application.NameInfo.editSelfInfo = EmployeeBasic.Name_Change_Employee__c;
        Application.NameInfo.editMarriedInfo = EmployeeBasic.Name_Change_Marriage__c;
        Application.NameInfo.editChildInfo = EmployeeBasic.Name_Change_Child__c;
        Application.NameInfo.editFatherInfo = EmployeeBasic.Name_Change_Father__c;
        Application.NameInfo.editMotherInfo = EmployeeBasic.Name_Change_Mother__c;
        
        //NameInfo - Employee
        Application.NameInfo.employeeInfo = new ESS_EmployeeBasic_DTO.EmployeeInfoDTO();
        Application.NameInfo.employeeInfo.isEditable = checkCanEdit(EmployeeBasic.Status__c);
        application.NameInfo.employeeInfo.oldTHTitleFNLN = EmployeeBasic.Name_Emp_TH_Old_Title_FN_LN__c;
           
        Application.NameInfo.employeeInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Emp_EN_Old_Title__c == '1') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '1';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Name_Emp_EN_Old_Title__c == '2') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '2';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Name_Emp_EN_Old_Title__c == '3') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '3';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Name_Emp_EN_Old_Title__c == '4') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '4';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Name_Emp_EN_Old_Title__c == '5') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '5';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Dr';
        }
        Application.NameInfo.employeeInfo.oldENFirstName = EmployeeBasic.Name_Emp_EN_Old_FN__c;
        Application.NameInfo.employeeInfo.oldENLastName = EmployeeBasic.Name_Emp_EN_Old_LN__c;
        
        Application.NameInfo.employeeInfo.newTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Emp_TH_New_Title__c == '1') {
            Application.NameInfo.employeeInfo.newTHTitle.key = '1';
            Application.NameInfo.employeeInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Emp_TH_New_Title__c == '2') {
            Application.NameInfo.employeeInfo.newTHTitle.key = '2';
            Application.NameInfo.employeeInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Emp_TH_New_Title__c == '3') {
            Application.NameInfo.employeeInfo.newTHTitle.key = '3';
            Application.NameInfo.employeeInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Emp_TH_New_Title__c == '4') {
            Application.NameInfo.employeeInfo.newTHTitle.key = '4';
            Application.NameInfo.employeeInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Emp_TH_New_Title__c == '5') {
            Application.NameInfo.employeeInfo.newTHTitle.key = '5';
            Application.NameInfo.employeeInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Emp_TH_New_Title__c);
        }
        Application.NameInfo.employeeInfo.newTHFirstName = EmployeeBasic.Name_Emp_TH_New_FN__c;
        Application.NameInfo.employeeInfo.newTHLastName = EmployeeBasic.Name_Emp_TH_New_LN__c;
        
        Application.NameInfo.employeeInfo.newENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Emp_EN_New_Title__c == '1') {
            Application.NameInfo.employeeInfo.newENTitle.key = '1';
            Application.NameInfo.employeeInfo.newENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Name_Emp_EN_New_Title__c == '2') {
            Application.NameInfo.employeeInfo.newENTitle.key = '2';
            Application.NameInfo.employeeInfo.newENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Name_Emp_EN_New_Title__c == '3') {
            Application.NameInfo.employeeInfo.newENTitle.key = '3';
            Application.NameInfo.employeeInfo.newENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Name_Emp_EN_New_Title__c == '4') {
            Application.NameInfo.employeeInfo.newENTitle.key = '4';
            Application.NameInfo.employeeInfo.newENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Name_Emp_EN_New_Title__c == '5') {
            Application.NameInfo.employeeInfo.newENTitle.key = '5';
            Application.NameInfo.employeeInfo.newENTitle.value = 'Dr';
        }
        
        Application.NameInfo.employeeInfo.newENFirstName = EmployeeBasic.Name_Emp_EN_New_FN__c;
        Application.NameInfo.employeeInfo.newENLastName = EmployeeBasic.Name_Emp_EN_New_LN__c;
        
        Application.NameInfo.employeeInfo.documentChangeNameNo = EmployeeBasic.Name_Emp_Change_Doc_No__c;
        Application.NameInfo.employeeInfo.documentChangeNameLocation = EmployeeBasic.Name_Emp_Change_Doc_Location__c;
        Application.NameInfo.employeeInfo.documentChangeNameProvince = EmployeeBasic.Name_Emp_Change_Doc_Province__c;
        Application.NameInfo.employeeInfo.documentChangeNameDate = EmployeeBasic.Name_Emp_Change_Doc_Date__c;
        
        Application.NameInfo.employeeInfo.documentUploadedUrl = EmployeeBasic.Name_Emp_Change_Doc_Id__c; //Generate as URL with Doc Id
        Application.NameInfo.employeeInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Emp_Change_Doc_Id__c); //Generate as URL with Doc Id
        Application.NameInfo.employeeInfo.documentCopyCitizenUrl = EmployeeBasic.Name_Emp_Citizen_Copy_Id__c; //Generate as URL with Doc Id
        Application.NameInfo.employeeInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Emp_Citizen_Copy_Id__c); //Generate as URL with Doc Id
        
        //NameInfo - Marriage
        Application.NameInfo.statusInfo = new ESS_EmployeeBasic_DTO.StatusInfoDTO();
        Application.NameInfo.statusInfo.isChange = Application.NameInfo.editMarriedInfo;
        Application.NameInfo.statusInfo.isEditable = checkCanEdit(EmployeeBasic.Status__c);
        
        Application.NameInfo.statusInfo.oldTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Marriage_TH_Old_Title__c == '1') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '1';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_Old_Title__c);
        }
        else if(EmployeeBasic.Name_Marriage_TH_Old_Title__c == '2') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '2';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_Old_Title__c);
        }
        else if(EmployeeBasic.Name_Marriage_TH_Old_Title__c == '3') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '3';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_Old_Title__c);
        }
        else if(EmployeeBasic.Name_Marriage_TH_Old_Title__c == '4') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '4';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_Old_Title__c);
        }
        else if(EmployeeBasic.Name_Marriage_TH_Old_Title__c == '5') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '5';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_Old_Title__c);
        }
        Application.NameInfo.statusInfo.oldTHFirstName = EmployeeBasic.Name_Marriage_TH_Old_FN__c;
        Application.NameInfo.statusInfo.oldTHLastName = EmployeeBasic.Name_Marriage_TH_Old_LN__c;
                
        Application.NameInfo.statusInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Marriage_EN_Old_Title__c == '1') {
            Application.NameInfo.statusInfo.oldENTitle.key = '1';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Name_Marriage_EN_Old_Title__c == '2') {
            Application.NameInfo.statusInfo.oldENTitle.key = '2';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Name_Marriage_EN_Old_Title__c == '3') {
            Application.NameInfo.statusInfo.oldENTitle.key = '3';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Name_Marriage_EN_Old_Title__c == '4') {
            Application.NameInfo.statusInfo.oldENTitle.key = '4';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Name_Marriage_EN_Old_Title__c == '5') {
            Application.NameInfo.statusInfo.oldENTitle.key = '5';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Dr';
        }
        
        Application.NameInfo.statusInfo.oldENFirstName = EmployeeBasic.Name_Marriage_EN_Old_FN__c;
        Application.NameInfo.statusInfo.oldENLastName = EmployeeBasic.Name_Marriage_EN_Old_LN__c;
        
        Application.NameInfo.statusInfo.thTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Marriage_TH_New_Title__c == '1') {
            Application.NameInfo.statusInfo.thTitle.key = '1';
            Application.NameInfo.statusInfo.thTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Marriage_TH_New_Title__c == '2') {
            Application.NameInfo.statusInfo.thTitle.key = '2';
            Application.NameInfo.statusInfo.thTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Marriage_TH_New_Title__c == '3') {
            Application.NameInfo.statusInfo.thTitle.key = '3';
            Application.NameInfo.statusInfo.thTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Marriage_TH_New_Title__c == '4') {
            Application.NameInfo.statusInfo.thTitle.key = '4';
            Application.NameInfo.statusInfo.thTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Marriage_TH_New_Title__c == '5') {
            Application.NameInfo.statusInfo.thTitle.key = '5';
            Application.NameInfo.statusInfo.thTitle.value = assignTHTitle(EmployeeBasic.Name_Marriage_TH_New_Title__c);
        }
        Application.NameInfo.statusInfo.thFirstName = EmployeeBasic.Name_Marriage_TH_New_FN__c;
        Application.NameInfo.statusInfo.thLastName = EmployeeBasic.Name_Marriage_TH_New_LN__c;
        
        Application.NameInfo.statusInfo.enTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Marriage_EN_New_Title__c == '1') {
            Application.NameInfo.statusInfo.enTitle.key = '1';
            Application.NameInfo.statusInfo.enTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Name_Marriage_EN_New_Title__c == '2') {
            Application.NameInfo.statusInfo.enTitle.key = '2';
            Application.NameInfo.statusInfo.enTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Name_Marriage_EN_New_Title__c == '3') {
            Application.NameInfo.statusInfo.enTitle.key = '3';
            Application.NameInfo.statusInfo.enTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Name_Marriage_EN_New_Title__c == '4') {
            Application.NameInfo.statusInfo.enTitle.key = '4';
            Application.NameInfo.statusInfo.enTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Name_Marriage_EN_New_Title__c == '5') {
            Application.NameInfo.statusInfo.enTitle.key = '5';
            Application.NameInfo.statusInfo.enTitle.value = 'Dr';
        }
        
        Application.NameInfo.statusInfo.enFirstName = EmployeeBasic.Name_Marriage_EN_New_FN__c;
        Application.NameInfo.statusInfo.enLastName = EmployeeBasic.Name_Marriage_EN_New_LN__c;
        
        Application.NameInfo.statusInfo.documentChangeNameNo = EmployeeBasic.Name_Marriage_Change_Doc_No__c;
        Application.NameInfo.statusInfo.documentChangeNameLocation = EmployeeBasic.Name_Marriage_Change_Doc_Location__c;
        Application.NameInfo.statusInfo.documentChangeNameProvince = EmployeeBasic.Name_Marriage_Change_Doc_Province__c;
        Application.NameInfo.statusInfo.documentChangeNameDate = EmployeeBasic.Name_Marriage_Change_Doc_Date__c;
        Application.NameInfo.statusInfo.documentUploadedUrl = EmployeeBasic.Name_Marriage_Change_Doc_Id__c; //Generate as URL with Doc Id
        Application.NameInfo.statusInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Marriage_Change_Doc_Id__c); //Generate as URL with Doc Id
        Application.NameInfo.statusInfo.documentCopyCitizenUrl = EmployeeBasic.Name_Marriage_Citizen_Copy_Id__c; //Generate as URL with Doc Id
        Application.NameInfo.statusInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Marriage_Citizen_Copy_Id__c); //Generate as URL with Doc Id
        
        //NameInfo - Child
        Application.NameInfo.ChildInfos = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
        if(EmployeeBasic.Name_Child_JSON__c != null && string.isNotBlank(EmployeeBasic.Name_Child_JSON__c)) {
        	Application.NameInfo.ChildInfos = DeserializeChildJSON(EmployeeBasic.Name_Child_JSON__c);
        }
        Application.NameInfo.childCount = Integer.ValueOf(EmployeeBasic.Name_Child_Count__c);
        
        //NameInfo - Father
        Application.NameInfo.fatherInfo = new ESS_EmployeeBasic_DTO.FatherInfoDTO();
        Application.NameInfo.fatherInfo.isEditable = checkCanEdit(EmployeeBasic.Status__c);
        if(string.isNotBlank(EmployeeBasic.Death_Father_Detail__c)) {
            Application.NameInfo.fatherInfo.isEditable = false;
        }
        
        Application.NameInfo.fatherInfo.oldTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Father_TH_Old_Title__c == '1') {
            Application.NameInfo.fatherInfo.oldTHTitle.key = '1';
            Application.NameInfo.fatherInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Father_TH_Old_Title__c);
        }
        else if(EmployeeBasic.Name_Father_TH_Old_Title__c == '5') {
            Application.NameInfo.fatherInfo.oldTHTitle.key = '5';
            Application.NameInfo.fatherInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Father_TH_Old_Title__c);
        }
        Application.NameInfo.fatherInfo.oldTHFirstName = EmployeeBasic.Name_Father_TH_Old_FN__c;
        Application.NameInfo.fatherInfo.oldTHLastName = EmployeeBasic.Name_Father_TH_Old_LN__c;
                
        Application.NameInfo.fatherInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Father_EN_Old_Title__c == '1') {
            Application.NameInfo.statusInfo.oldENTitle.key = '1';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Name_Father_EN_Old_Title__c == '5') {
            Application.NameInfo.fatherInfo.oldENTitle.key = '5';
            Application.NameInfo.fatherInfo.oldENTitle.value = 'Dr';
        }
        
        Application.NameInfo.fatherInfo.oldENFirstName = EmployeeBasic.Name_Father_EN_Old_FN__c;
        Application.NameInfo.fatherInfo.oldENLastName = EmployeeBasic.Name_Father_EN_Old_LN__c;
        
        Application.NameInfo.fatherInfo.newTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Father_TH_New_Title__c == '1') {
            Application.NameInfo.fatherInfo.newTHTitle.key = '1';
            Application.NameInfo.fatherInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Father_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Father_TH_New_Title__c == '5') {
            Application.NameInfo.fatherInfo.newTHTitle.key = '5';
            Application.NameInfo.fatherInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Father_TH_New_Title__c);
        }
        Application.NameInfo.fatherInfo.newTHFirstName = EmployeeBasic.Name_Father_TH_New_FN__c;
        Application.NameInfo.fatherInfo.newTHLastName = EmployeeBasic.Name_Father_TH_New_LN__c;
        
        Application.NameInfo.fatherInfo.newENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Father_EN_New_Title__c == '1') {
            Application.NameInfo.fatherInfo.newENTitle.key = '1';
            Application.NameInfo.fatherInfo.newENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Name_Father_EN_New_Title__c == '5') {
            Application.NameInfo.fatherInfo.newENTitle.key = '5';
            Application.NameInfo.fatherInfo.newENTitle.value = 'Dr';
        }
        Application.NameInfo.fatherInfo.newENFirstName = EmployeeBasic.Name_Father_EN_New_FN__c;
        Application.NameInfo.fatherInfo.newENLastName = EmployeeBasic.Name_Father_EN_New_LN__c;
        
        Application.NameInfo.fatherInfo.documentChangeNameNo = EmployeeBasic.Name_Father_Change_Doc_No__c;
        Application.NameInfo.fatherInfo.documentChangeNameLocation = EmployeeBasic.Name_Father_Change_Doc_Location__c;
        Application.NameInfo.fatherInfo.documentChangeNameProvince = EmployeeBasic.Name_Father_Change_Doc_Province__c;
        Application.NameInfo.fatherInfo.documentChangeNameDate = EmployeeBasic.Name_Father_Change_Doc_Date__c;
        Application.NameInfo.fatherInfo.documentUploadedUrl = EmployeeBasic.Name_Father_Change_Doc_Id__c; //Generate as URL with Doc Id
        Application.NameInfo.fatherInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Father_Change_Doc_Id__c); //Generate as URL with Doc Id
        Application.NameInfo.fatherInfo.documentCopyCitizenUrl = EmployeeBasic.Name_Father_Citizen_Copy_Id__c; //Generate as URL with Doc Id
        Application.NameInfo.fatherInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Father_Citizen_Copy_Id__c); //Generate as URL with Doc Id
        
        //NameInfo - Mother
        Application.NameInfo.motherInfo = new ESS_EmployeeBasic_DTO.MotherInfoDTO();
        Application.NameInfo.motherInfo.isEditable = checkCanEdit(EmployeeBasic.Status__c);
        if(string.isNotBlank(EmployeeBasic.Death_Mother_Detail__c)) {
            Application.NameInfo.motherInfo.isEditable = false;
        }
        
        Application.NameInfo.motherInfo.oldTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Mother_TH_Old_Title__c == '2') {
            Application.NameInfo.motherInfo.oldTHTitle.key = '2';
            Application.NameInfo.motherInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Mother_TH_Old_Title__c);
        }
        else if(EmployeeBasic.Name_Mother_TH_Old_Title__c == '3') {
            Application.NameInfo.motherInfo.oldTHTitle.key = '3';
            Application.NameInfo.motherInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Mother_TH_Old_Title__c);
        }
        else if(EmployeeBasic.Name_Mother_TH_Old_Title__c == '4') {
            Application.NameInfo.motherInfo.oldTHTitle.key = '4';
            Application.NameInfo.motherInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Mother_TH_Old_Title__c);
        }
        else if(EmployeeBasic.Name_Mother_TH_Old_Title__c == '5') {
            Application.NameInfo.motherInfo.oldTHTitle.key = '5';
            Application.NameInfo.motherInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Name_Mother_TH_Old_Title__c);
        }
        Application.NameInfo.motherInfo.oldTHFirstName = EmployeeBasic.Name_Mother_TH_Old_FN__c;
        Application.NameInfo.motherInfo.oldTHLastName = EmployeeBasic.Name_Mother_TH_Old_LN__c;
                
        Application.NameInfo.motherInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Mother_EN_Old_Title__c == '2') {
            Application.NameInfo.motherInfo.oldENTitle.key = '2';
            Application.NameInfo.motherInfo.oldENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Name_Mother_EN_Old_Title__c == '3') {
            Application.NameInfo.motherInfo.oldENTitle.key = '3';
            Application.NameInfo.motherInfo.oldENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Name_Mother_EN_Old_Title__c == '4') {
            Application.NameInfo.motherInfo.oldENTitle.key = '4';
            Application.NameInfo.motherInfo.oldENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Name_Mother_EN_Old_Title__c == '5') {
            Application.NameInfo.motherInfo.oldENTitle.key = '5';
            Application.NameInfo.motherInfo.oldENTitle.value = 'Dr';
        }
        
        Application.NameInfo.motherInfo.oldENFirstName = EmployeeBasic.Name_Mother_EN_Old_FN__c;
        Application.NameInfo.motherInfo.oldENLastName = EmployeeBasic.Name_Mother_EN_Old_LN__c;
        
        Application.NameInfo.motherInfo.newTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Mother_TH_New_Title__c == '2') {
            Application.NameInfo.motherInfo.newTHTitle.key = '2';
            Application.NameInfo.motherInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Mother_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Mother_TH_New_Title__c == '3') {
            Application.NameInfo.motherInfo.newTHTitle.key = '3';
            Application.NameInfo.motherInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Mother_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Mother_TH_New_Title__c == '4') {
            Application.NameInfo.motherInfo.newTHTitle.key = '4';
            Application.NameInfo.motherInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Mother_TH_New_Title__c);
        }
        else if(EmployeeBasic.Name_Mother_TH_New_Title__c == '5') {
            Application.NameInfo.motherInfo.newTHTitle.key = '5';
            Application.NameInfo.motherInfo.newTHTitle.value = 'ดร';
            Application.NameInfo.motherInfo.newTHTitle.value = assignTHTitle(EmployeeBasic.Name_Mother_TH_New_Title__c);
        }
        Application.NameInfo.motherInfo.newTHFirstName = EmployeeBasic.Name_Mother_TH_New_FN__c;
        Application.NameInfo.motherInfo.newTHLastName = EmployeeBasic.Name_Mother_TH_New_LN__c;
        
        Application.NameInfo.motherInfo.newENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Name_Mother_EN_New_Title__c == '2') {
            Application.NameInfo.motherInfo.newENTitle.key = '2';
            Application.NameInfo.motherInfo.newENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Name_Mother_EN_New_Title__c == '3') {
            Application.NameInfo.motherInfo.newENTitle.key = '3';
            Application.NameInfo.motherInfo.newENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Name_Mother_EN_New_Title__c == '4') {
            Application.NameInfo.motherInfo.newENTitle.key = '4';
            Application.NameInfo.motherInfo.newENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Name_Mother_EN_New_Title__c == '5') {
            Application.NameInfo.motherInfo.newENTitle.key = '5';
            Application.NameInfo.motherInfo.newENTitle.value = 'Dr';
        }
        
        Application.NameInfo.motherInfo.newENFirstName = EmployeeBasic.Name_Mother_EN_New_FN__c;
        Application.NameInfo.motherInfo.newENLastName = EmployeeBasic.Name_Mother_EN_New_LN__c;
        
        Application.NameInfo.motherInfo.documentChangeNameNo = EmployeeBasic.Name_Mother_Change_Doc_No__c;
        Application.NameInfo.motherInfo.documentChangeNameLocation = EmployeeBasic.Name_Mother_Change_Doc_Location__c;
        Application.NameInfo.motherInfo.documentChangeNameProvince = EmployeeBasic.Name_Mother_Change_Doc_Province__c;
        Application.NameInfo.motherInfo.documentChangeNameDate = EmployeeBasic.Name_Mother_Change_Doc_Date__c;
        Application.NameInfo.motherInfo.documentUploadedUrl = EmployeeBasic.Name_Mother_Change_Doc_Id__c; //Generate as URL with Doc Id
        Application.NameInfo.motherInfo.documentUploadedDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Mother_Change_Doc_Id__c); //Generate as URL with Doc Id
        Application.NameInfo.motherInfo.documentCopyCitizenUrl = EmployeeBasic.Name_Mother_Citizen_Copy_Id__c; //Generate as URL with Doc Id
        Application.NameInfo.motherInfo.documentCopyCitizenDisplayUrl = generateDocumentUrl(EmployeeBasic.Name_Mother_Citizen_Copy_Id__c); //Generate as URL with Doc Id
        
        
        //isChange in Application
        if(Application.NameInfo.editSelfInfo || Application.NameInfo.editMarriedInfo || Application.NameInfo.editChildInfo || 
           Application.NameInfo.editFatherInfo || Application.NameInfo.editMotherInfo) {
               Application.NameInfo.isChange = true;
        }
        
        //Status
        Application.StatusInfo = new ESS_EmployeeBasic_DTO.StatusInfoDTO();
        Application.StatusInfo.isChange = EmployeeBasic.Is_Update_Status__c;
        Application.StatusInfo.isEditable = true;
        Application.StatusInfo.isMarriedPersonAsEmployee = EmployeeBasic.Is_Marriage_As_Employee__c;
        Application.StatusInfo.oldIsMarriedPersonAsEmployee = EmployeeBasic.Old_Is_Marriage_As_Employee__c;
        Application.StatusInfo.employeeId = application.applicationHeaderInfo.employeeId;
        Application.StatusInfo.isUpdateMarriedStatus = EmployeeBasic.Status_Marriage_Change_Detail__c;
        if(string.isNotBlank(EmployeeBasic.Status_Marriage_Employee_Id__c)) {
            Application.StatusInfo.marriedEmployeeId = EmployeeBasic.Status_Marriage_Employee_Id__c;
        }
        Application.StatusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
        if(EmployeeBasic.Status_Marriage_Status__c == '0') {
            Application.StatusInfo.marriedStatus.key = '0';
            Application.StatusInfo.marriedStatus.value = 'Single';
        }
        else if(EmployeeBasic.Status_Marriage_Status__c == '1') {
            Application.StatusInfo.marriedStatus.key = '1';
            Application.StatusInfo.marriedStatus.value = 'Married';
        }
        else if(EmployeeBasic.Status_Marriage_Status__c == '3') {
            Application.StatusInfo.marriedStatus.key = '3';
            Application.StatusInfo.marriedStatus.value = 'Divorced';
        }
        else if(EmployeeBasic.Status_Marriage_Status__c == '2') {
            Application.StatusInfo.marriedStatus.key = '2';
            Application.StatusInfo.marriedStatus.value = 'Widow';
        }
        else if(EmployeeBasic.Status_Marriage_Status__c == '4') {
            Application.StatusInfo.marriedStatus.key = '4';
            Application.StatusInfo.marriedStatus.value = 'Seperate';
        }
        Application.StatusInfo.isShowOnlyMarried = showOnlyMarriedStatus(EmployeeBasic.Employee_ID__c);
        Application.StatusInfo.isMarriedPersonChangeDetail = EmployeeBasic.Status_Marriage_Change_Detail__c;
        Application.StatusInfo.oldTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Marriage_TH_Title__c == '1') {
            Application.StatusInfo.oldTHTitle.key = '1';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Marriage_TH_Title__c == '2') {
            Application.StatusInfo.oldTHTitle.key = '2';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Marriage_TH_Title__c == '3') {
            Application.StatusInfo.oldTHTitle.key = '3';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Marriage_TH_Title__c == '4') {
            Application.StatusInfo.oldTHTitle.key = '4';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Marriage_TH_Title__c == '5') {
            Application.StatusInfo.oldTHTitle.key = '5';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_Title__c);
        }
        Application.StatusInfo.oldTHFirstName = EmployeeBasic.Status_Marriage_TH_FN__c;
        Application.StatusInfo.oldTHLastName = EmployeeBasic.Status_Marriage_TH_LN__c;
        
        Application.StatusInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Marriage_EN_Title__c == '1') {
            Application.StatusInfo.oldENTitle.key = '1';
            Application.StatusInfo.oldENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Status_Marriage_EN_Title__c == '2') {
            Application.StatusInfo.oldENTitle.key = '2';
            Application.StatusInfo.oldENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Status_Marriage_EN_Title__c == '3') {
            Application.StatusInfo.oldENTitle.key = '3';
            Application.StatusInfo.oldENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Status_Marriage_EN_Title__c == '4') {
            Application.StatusInfo.oldENTitle.key = '4';
            Application.StatusInfo.oldENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Status_Marriage_EN_Title__c == '5') {
            Application.StatusInfo.oldENTitle.key = '5';
            Application.StatusInfo.oldENTitle.value = 'Dr';
        }
        
        Application.StatusInfo.oldENFirstName = EmployeeBasic.Status_Marriage_EN_FN__c;
        Application.StatusInfo.oldENLastName = EmployeeBasic.Status_Marriage_EN_LN__c;
        Application.StatusInfo.citizenId = EmployeeBasic.Status_Marriage_Citizen_Id__c;
        Application.StatusInfo.dateOfBirth = EmployeeBasic.Status_Marriage_DOB__c;
        Application.StatusInfo.occupation = EmployeeBasic.Status_Marriage_Occupation__c;
        Application.StatusInfo.marriedDocumentNo = EmployeeBasic.Status_Marriage_Doc_No__c;
        Application.StatusInfo.marriedDocumentIssueLocation = EmployeeBasic.Status_Marriage_Doc_Issue_Location__c;
        Application.StatusInfo.marriedDocumentIssueProvince = EmployeeBasic.Status_Marriage_Doc_Issue_Province__c;
        Application.StatusInfo.marriedDocumentIssueDate = EmployeeBasic.Status_Marriage_Doc_Issue_Date__c;
        Application.StatusInfo.isChangeTitleAfterMarried = EmployeeBasic.Is_Change_Title_After_Married__c;
        Application.StatusInfo.isChangeLastNameAfterMarried = EmployeeBasic.Is_Change_LN_After_Married__c;
        Application.StatusInfo.marriedDocumentUrl = EmployeeBasic.Status_Marriage_Doc_Id__c;
        Application.StatusInfo.marriedDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Doc_Id__c);
        
        Application.StatusInfo.employeeTitleLastnameDocumentUrl = EmployeeBasic.Status_Marriage_Change_Doc_Id__c;
        Application.StatusInfo.employeeTitleLastnameDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Change_Doc_Id__c);
        
        Application.StatusInfo.marriedPersonCopyDocumentUrl = EmployeeBasic.Status_Marriage_Citizen_Id_Copy__c;
        Application.StatusInfo.marriedPersonCopyDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Citizen_Id_Copy__c);
        
        Application.StatusInfo.changeTitleLastnameCopyDocumentUrl = EmployeeBasic.Status_Marriage_Change_Doc_Copy_Id__c;
        Application.StatusInfo.changeTitleLastnameCopyDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Marriage_Change_Doc_Copy_Id__c);
            
        Application.StatusInfo.newMarriedTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Marriage_TH_New_Title__c  == '1') {
            Application.StatusInfo.newMarriedTHTitle.key = '1';
            Application.StatusInfo.newMarriedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Marriage_TH_New_Title__c  == '2') {
            Application.StatusInfo.newMarriedTHTitle.key = '2';
            Application.StatusInfo.newMarriedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Marriage_TH_New_Title__c  == '3') {
            Application.StatusInfo.newMarriedTHTitle.key = '3';
            Application.StatusInfo.newMarriedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Marriage_TH_New_Title__c  == '4') {
            Application.StatusInfo.newMarriedTHTitle.key = '4';
            Application.StatusInfo.newMarriedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Marriage_TH_New_Title__c  == '5') {
            Application.StatusInfo.newMarriedTHTitle.key = '5';
            Application.StatusInfo.newMarriedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Marriage_TH_New_Title__c);
        }
        Application.StatusInfo.newMarriedTHLastName = EmployeeBasic.Status_Marriage_TH_New_LN__c;
        
        Application.StatusInfo.newMarriedENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Marriage_EN_New_Title__c == '1') {
            Application.StatusInfo.newMarriedENTitle.key = '1';
            Application.StatusInfo.newMarriedENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Status_Marriage_EN_New_Title__c == '2') {
            Application.StatusInfo.newMarriedENTitle.key = '2';
            Application.StatusInfo.newMarriedENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Status_Marriage_EN_New_Title__c == '3') {
            Application.StatusInfo.newMarriedENTitle.key = '3';
            Application.StatusInfo.newMarriedENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Status_Marriage_EN_New_Title__c == '4') {
            Application.StatusInfo.newMarriedENTitle.key = '4';
            Application.StatusInfo.newMarriedENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Status_Marriage_EN_New_Title__c == '5') {
            Application.StatusInfo.newMarriedENTitle.key = '5';
            Application.StatusInfo.newMarriedENTitle.value = 'Dr';
        }
        Application.StatusInfo.newMarriedENLastName = EmployeeBasic.Status_Marriage_EN_New_LN__c;
        
        //Divorce
        Application.StatusInfo.divorcedTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Divorce_TH_Title__c  == '1') {
            Application.StatusInfo.divorcedTHTitle.key = '1';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Divorce_TH_Title__c  == '2') {
            Application.StatusInfo.divorcedTHTitle.key = '2';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Divorce_TH_Title__c  == '3') {
            Application.StatusInfo.divorcedTHTitle.key = '3';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Divorce_TH_Title__c  == '4') {
            Application.StatusInfo.divorcedTHTitle.key = '4';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Divorce_TH_Title__c  == '5') {
            Application.StatusInfo.divorcedTHTitle.key = '5';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_Title__c);
        }
        Application.StatusInfo.divorcedTHFirstName = EmployeeBasic.Status_Divorce_TH_FN__c;
        Application.StatusInfo.divorcedTHLastName = EmployeeBasic.Status_Divorce_TH_LN__c;
        Application.StatusInfo.divorcedENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Divorce_EN_Title__c == '1') {
            Application.StatusInfo.divorcedENTitle.key = '1';
            Application.StatusInfo.divorcedENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Status_Divorce_EN_Title__c == '2') {
            Application.StatusInfo.divorcedENTitle.key = '2';
            Application.StatusInfo.divorcedENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Status_Divorce_EN_Title__c == '3') {
            Application.StatusInfo.divorcedENTitle.key = '3';
            Application.StatusInfo.divorcedENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Status_Divorce_EN_Title__c == '4') {
            Application.StatusInfo.divorcedENTitle.key = '4';
            Application.StatusInfo.divorcedENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Status_Divorce_EN_Title__c == '5') {
            Application.StatusInfo.divorcedENTitle.key = '5';
            Application.StatusInfo.divorcedENTitle.value = 'Dr';
        }
        
        Application.StatusInfo.divorcedENFirstName = EmployeeBasic.Status_Divorce_EN_FN__c;
        Application.StatusInfo.divorcedENLastName = EmployeeBasic.Status_Divorce_EN_LN__c;
        Application.StatusInfo.divorcedDocumentNo = EmployeeBasic.Status_Divorce_Doc_No__c;
        Application.StatusInfo.divorcedDocumentIssueLocation = EmployeeBasic.Status_Divorce_Doc_Issue_Location__c;
        Application.StatusInfo.divorcedDocumentIssueProvince = EmployeeBasic.Status_Divorce_Doc_Issue_Province__c;
        Application.StatusInfo.divorcedDocumentIssueDate = EmployeeBasic.Status_Divorce_Doc_Issue_Date__c;
        Application.StatusInfo.isChangeTitleAfterDivorced = EmployeeBasic.Is_Change_Title_After_Divorced__c;
        Application.StatusInfo.isChangeLastNameAfterDivorced = EmployeeBasic.Is_Change_LN_After_Divorced__c;
        
        Application.StatusInfo.newDivorcedTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Divorce_TH_New_Title__c == '1') {
            Application.StatusInfo.newDivorcedTHTitle.key = '1';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Divorce_TH_New_Title__c == '2') {
            Application.StatusInfo.newDivorcedTHTitle.key = '2';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Divorce_TH_New_Title__c == '3') {
            Application.StatusInfo.newDivorcedTHTitle.key = '3';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Divorce_TH_New_Title__c == '4') {
            Application.StatusInfo.newDivorcedTHTitle.key = '4';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Divorce_TH_New_Title__c == '5') {
            Application.StatusInfo.newDivorcedTHTitle.key = '5';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(EmployeeBasic.Status_Divorce_TH_New_Title__c);
        }
        Application.StatusInfo.newDivorcedTHLastName = EmployeeBasic.Status_Divorce_TH_New_LN__c;
        
        Application.StatusInfo.newDivorcedENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Divorce_EN_New_Title__c == '1') {
            Application.StatusInfo.newDivorcedENTitle.key = '1';
            Application.StatusInfo.newDivorcedENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Status_Divorce_EN_New_Title__c == '2') {
            Application.StatusInfo.newDivorcedENTitle.key = '2';
            Application.StatusInfo.newDivorcedENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Status_Divorce_EN_New_Title__c == '3') {
            Application.StatusInfo.newDivorcedENTitle.key = '3';
            Application.StatusInfo.newDivorcedENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Status_Divorce_EN_New_Title__c == '4') {
            Application.StatusInfo.newDivorcedENTitle.key = '4';
            Application.StatusInfo.newDivorcedENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Status_Divorce_EN_New_Title__c == '5') {
            Application.StatusInfo.newDivorcedENTitle.key = '5';
            Application.StatusInfo.newDivorcedENTitle.value = 'Dr';
        }
        Application.StatusInfo.newDivorcedENLastName = EmployeeBasic.Status_Divorce_EN_New_LN__c;
        Application.StatusInfo.divorcedDocumentUrl = EmployeeBasic.Status_Divorce_Doc_Id__c;
        Application.StatusInfo.divorcedDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Divorce_Doc_Id__c);
        Application.StatusInfo.divorcedChangeTitleLastNameUrl = EmployeeBasic.Status_Divorce_Change_Detail_Id__c;
        Application.StatusInfo.divorcedChangeTitleLastNameDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Divorce_Change_Detail_Id__c);
        Application.StatusInfo.divorcedUseChangeTitleLastNameUrl = EmployeeBasic.Status_Divorce_Use_Detail_Id__c;
        Application.StatusInfo.divorcedUseChangeTitleLastNameDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Divorce_Use_Detail_Id__c);
        
        //Widow
        Application.StatusInfo.widowTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Widow_TH_Title__c  == '1') {
            Application.StatusInfo.widowTHTitle.key = '1';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Widow_TH_Title__c  == '2') {
            Application.StatusInfo.widowTHTitle.key = '2';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Widow_TH_Title__c  == '3') {
            Application.StatusInfo.widowTHTitle.key = '3';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Widow_TH_Title__c  == '4') {
            Application.StatusInfo.widowTHTitle.key = '4';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_Title__c);
        }
        else if(EmployeeBasic.Status_Widow_TH_Title__c  == '5') {
            Application.StatusInfo.widowTHTitle.key = '5';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_Title__c);
        }
        Application.StatusInfo.widowTHFirstName = EmployeeBasic.Status_Widow_TH_FN__c;
        Application.StatusInfo.widowTHLastName = EmployeeBasic.Status_Widow_TH_LN__c;
        Application.StatusInfo.widowENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Widow_EN_Title__c == '1') {
            Application.StatusInfo.widowENTitle.key = '1';
            Application.StatusInfo.widowENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Status_Widow_EN_Title__c == '2') {
            Application.StatusInfo.widowENTitle.key = '2';
            Application.StatusInfo.widowENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Status_Widow_EN_Title__c == '3') {
            Application.StatusInfo.widowENTitle.key = '3';
            Application.StatusInfo.widowENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Status_Widow_EN_Title__c == '4') {
            Application.StatusInfo.widowENTitle.key = '4';
            Application.StatusInfo.widowENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Status_Widow_EN_Title__c == '5') {
            Application.StatusInfo.widowENTitle.key = '5';
            Application.StatusInfo.widowENTitle.value = 'Dr';
        }
        
        Application.StatusInfo.widowENFirstName = EmployeeBasic.Status_Widow_EN_FN__c;
        Application.StatusInfo.widowENLastName = EmployeeBasic.Status_Widow_EN_LN__c;
        Application.StatusInfo.widowDocumentNo = EmployeeBasic.Status_Widow_Doc_No__c;
        Application.StatusInfo.widowDocumentIssueLocation = EmployeeBasic.Status_Widow_Doc_Issue_Location__c;
        Application.StatusInfo.widowDocumentIssueProvince = EmployeeBasic.Status_Widow_Doc_Issue_Province__c;
        Application.StatusInfo.widowDocumentIssueDate = EmployeeBasic.Status_Widow_Doc_Issue_Date__c;
        Application.StatusInfo.isChangeTitleAfterWidow = EmployeeBasic.Is_Change_Title_After_Widow__c;
        Application.StatusInfo.isChangeLastNameAfterWidow = EmployeeBasic.Is_Change_LN_After_Widow__c;
        
        Application.StatusInfo.newWidowTHTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Widow_TH_New_Title__c == '1') {
            Application.StatusInfo.newWidowTHTitle.key = '1';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Widow_TH_New_Title__c == '2') {
            Application.StatusInfo.newWidowTHTitle.key = '2';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Widow_TH_New_Title__c == '3') {
            Application.StatusInfo.newWidowTHTitle.key = '3';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Widow_TH_New_Title__c == '4') {
            Application.StatusInfo.newWidowTHTitle.key = '4';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_New_Title__c);
        }
        else if(EmployeeBasic.Status_Widow_TH_New_Title__c == '5') {
            Application.StatusInfo.newWidowTHTitle.key = '5';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(EmployeeBasic.Status_Widow_TH_New_Title__c);
        }
        Application.StatusInfo.newWidowTHLastName = EmployeeBasic.Status_Widow_TH_New_LN__c;
        
        Application.StatusInfo.newWidowENTitle = new ESS_Global.EnumValue('Title');
        if(EmployeeBasic.Status_Widow_EN_New_Title__c == '1') {
            Application.StatusInfo.newWidowENTitle.key = '1';
            Application.StatusInfo.newWidowENTitle.value = 'Mr';
        }
        else if(EmployeeBasic.Status_Widow_EN_New_Title__c == '2') {
            Application.StatusInfo.newWidowENTitle.key = '2';
            Application.StatusInfo.newWidowENTitle.value = 'Mrs';
        }
        else if(EmployeeBasic.Status_Widow_EN_New_Title__c == '3') {
            Application.StatusInfo.newWidowENTitle.key = '3';
            Application.StatusInfo.newWidowENTitle.value = 'Miss';
        }
        else if(EmployeeBasic.Status_Widow_EN_New_Title__c == '4') {
            Application.StatusInfo.newWidowENTitle.key = '4';
            Application.StatusInfo.newWidowENTitle.value = 'Ms';
        }
        else if(EmployeeBasic.Status_Widow_EN_New_Title__c == '5') {
            Application.StatusInfo.newWidowENTitle.key = '5';
            Application.StatusInfo.newWidowENTitle.value = 'Dr';
        }
        Application.StatusInfo.newWidowENLastName = EmployeeBasic.Status_Widow_EN_New_LN__c;
        Application.StatusInfo.deathWidowDocumentUrl = EmployeeBasic.Status_Widow_Doc_Id__c;
        Application.StatusInfo.deathWidowDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Widow_Doc_Id__c);
        Application.StatusInfo.deathWidowChangeTitleLastNameUrl = EmployeeBasic.Status_Widow_Change_Doc_Id__c;
        Application.StatusInfo.deathWidowChangeTitleLastNameDisplayUrl = generateDocumentUrl(EmployeeBasic.Status_Widow_Change_Doc_Id__c);
        
        //Child
        Application.ChildInfos = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
        if(EmployeeBasic.Child_JSON__c != null && string.isNotBlank(EmployeeBasic.Child_JSON__c)) {
            Application.ChildInfos = DeserializeChildJSON(EmployeeBasic.Child_JSON__c);
            
            if(Application.ChildInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.ChildInfoDTO ChildInfo : Application.ChildInfos) {
                    ChildInfo.documentChangeFirstNameLastNameDisplayUrl = generateDocumentUrl(ChildInfo.documentChangeFirstNameLastNameUrl);
                    ChildInfo.documentBirthCertificateDisplayUrl = generateDocumentUrl(ChildInfo.documentBirthCertificateUrl);
                    ChildInfo.documentBirthProtegeDisplayUrl = generateDocumentUrl(ChildInfo.documentBirthProtegeUrl);
                    ChildInfo.documentLegitimationDisplayUrl = generateDocumentUrl(ChildInfo.documentLegitimationUrl);
                    ChildInfo.documentLegitimationProtegeDisplayUrl = generateDocumentUrl(ChildInfo.documentLegitimationProtegeUrl);
                }
            }
        }
        
        //Death
        Application.DeathInfo = new ESS_EmployeeBasic_DTO.DeathHeaderDTO();
        Application.DeathInfo.isChange = EmployeeBasic.Is_Update_Death__c;
        Application.DeathInfo.isEditable = true;
        Application.DeathInfo.isMarriedPersonAsEmployee = EmployeeBasic.Is_Marriage_As_Employee__c;
        Application.DeathInfo.employeeId = EmployeeBasic.Employee_ID__c;
        
        Application.DeathInfo.DeathInfos = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
        
        //Death Marriage
        ESS_EmployeeBasic_DTO.DeathInfoDTO DeathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
        if(string.isNotBlank(EmployeeBasic.Death_Marriage_FN__c)) {
        	Application.DeathInfo.isDeathWife = EmployeeBasic.Death_Is_Marriage_Death__c;
            DeathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            DeathInfo.deathPerson.key = ESS_Enum.DeathPerson.Married.name();
            DeathInfo.deathPerson.value = 'Married';     
            DeathInfo.thNo = '01';
            DeathInfo.title = new ESS_Global.EnumValue('Title');
            if(EmployeeBasic.Death_Marriage_Title__c == '1') {
                DeathInfo.title.key = '1';
                DeathInfo.title.value = 'Mr';
            }
            else if(EmployeeBasic.Death_Marriage_Title__c == '2') {
                DeathInfo.title.key = '2';
                DeathInfo.title.value = 'Mrs';
            }
            else if(EmployeeBasic.Death_Marriage_Title__c == '3') {
                DeathInfo.title.key = '3';
                DeathInfo.title.value = 'Miss';
            }
            else if(EmployeeBasic.Death_Marriage_Title__c == '4') {
                DeathInfo.title.key = '4';
                DeathInfo.title.value = 'Ms';
            }
            else if(EmployeeBasic.Death_Marriage_Title__c == '5') {
                DeathInfo.title.key = '5';
                DeathInfo.title.value = 'Dr';
            }
            
            DeathInfo.thFirstName = EmployeeBasic.Death_Marriage_FN__c;
            DeathInfo.thLastName = EmployeeBasic.Death_Marriage_LN__c;
            DeathInfo.deathDocumentNo = EmployeeBasic.Death_Marriage_Doc_No__c;
            DeathInfo.deathDocumentIssueLocation = EmployeeBasic.Death_Marriage_Doc_Issue_Location__c;
            DeathInfo.deathDocumentIssueProvince = EmployeeBasic.Death_Marriage_Doc_Issue_Province__c;
            DeathInfo.deathDocumentIssueDate = EmployeeBasic.Death_Marriage_Doc_Issue_Date__c;
            DeathInfo.deathDocumentUrl = EmployeeBasic.Death_Marriage_Doc_Id__c;
            DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Death_Marriage_Doc_Id__c);
            if(string.isNotBlank(EmployeeBasic.Death_Marriage_Doc_No__c)) {
                DeathInfo.isEditable = false;
                Application.DeathInfo.isDeathWife = true;
            }
            else {
                DeathInfo.isEditable = true;
            }
            Application.DeathInfo.DeathInfos.add(DeathInfo);
            
            if(Application.DeathInfo.isDeathWife) {
                Application.NameInfo.editMotherInfo  = false;
                Application.NameInfo.motherInfo.isEditable = false;
            }
        }
        
        //Death Father
        DeathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
        if(string.isNotBlank(EmployeeBasic.Death_Father_FN__c)) {
            Application.DeathInfo.isDeathFather = EmployeeBasic.Death_Is_Father_Death__c;
            DeathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            DeathInfo.deathPerson.key = ESS_Enum.DeathPerson.Father.name();
            DeathInfo.deathPerson.value = 'Father';     
            DeathInfo.thNo = '01';
            DeathInfo.title = new ESS_Global.EnumValue('Title');
            if(EmployeeBasic.Death_Father_Title__c == '1') {
                DeathInfo.title.key = '1';
                DeathInfo.title.value = 'Mr';
            }
            if(EmployeeBasic.Death_Father_Title__c == '5') {
                DeathInfo.title.key = '5';
                DeathInfo.title.value = 'Dr';
            }
            DeathInfo.thFirstName = EmployeeBasic.Death_Father_FN__c;
            DeathInfo.thLastName = EmployeeBasic.Death_Father_LN__c;
            DeathInfo.deathDocumentNo = EmployeeBasic.Death_Father_Doc_No__c;
            DeathInfo.deathDocumentIssueLocation = EmployeeBasic.Death_Father_Doc_Issue_Location__c;
            DeathInfo.deathDocumentIssueProvince = EmployeeBasic.Death_Father_Doc_Issue_Province__c;
            DeathInfo.deathDocumentIssueDate = EmployeeBasic.Death_Father_Doc_Issue_Date__c;
            DeathInfo.deathDocumentUrl = EmployeeBasic.Death_Father_Doc_Id__c;
            DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Death_Father_Doc_Id__c);
            if(string.isNotBlank(EmployeeBasic.Death_Father_Detail__c)) {
                Application.NameInfo.fatherInfo.isEditable = false;
                DeathInfo.deathDetail = EmployeeBasic.Death_Father_Detail__c;
                DeathInfo.isEditable = false;
            }
            else {
                DeathInfo.isEditable = true;
            }
            Application.DeathInfo.DeathInfos.add(DeathInfo);
        }
        
        //Death Mother
        DeathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
        if(string.isNotBlank(EmployeeBasic.Death_Mother_FN__c)) {
            Application.DeathInfo.isDeathMother = EmployeeBasic.Death_Is_Mother_Death__c;
            DeathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            DeathInfo.deathPerson.key = ESS_Enum.DeathPerson.Mother.name();
            DeathInfo.deathPerson.value = 'Mother';     
            DeathInfo.thNo = '01';
            DeathInfo.title = new ESS_Global.EnumValue('Title');
            if(EmployeeBasic.Death_Mother_Title__c == '2') {
                DeathInfo.title.key = '2';
                DeathInfo.title.value = 'Mrs';
            }
            else if(EmployeeBasic.Death_Mother_Title__c == '3') {
                DeathInfo.title.key = '3';
                DeathInfo.title.value = 'Miss';
            }
            else if(EmployeeBasic.Death_Mother_Title__c == '4') {
                DeathInfo.title.key = '4';
                DeathInfo.title.value = 'Ms';
            }
            else if(EmployeeBasic.Death_Mother_Title__c == '5') {
                DeathInfo.title.key = '5';
                DeathInfo.title.value = 'Dr';
            }
            DeathInfo.thFirstName = EmployeeBasic.Death_Mother_FN__c;
            DeathInfo.thLastName = EmployeeBasic.Death_Mother_LN__c;
            DeathInfo.deathDocumentNo = EmployeeBasic.Death_Mother_Doc_No__c;
            DeathInfo.deathDocumentIssueLocation = EmployeeBasic.Death_Mother_Doc_Issue_Location__c;
            DeathInfo.deathDocumentIssueProvince = EmployeeBasic.Death_Mother_Doc_Issue_Province__c;
            DeathInfo.deathDocumentIssueDate = EmployeeBasic.Death_Mother_Doc_Issue_Date__c;
            DeathInfo.deathDocumentUrl = EmployeeBasic.Death_Mother_Doc_Id__c;
            DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(EmployeeBasic.Death_Mother_Doc_Id__c);
            if(string.isNotBlank(EmployeeBasic.Death_Mother_Detail__c)) {
                Application.NameInfo.motherInfo.isEditable = false;
                DeathInfo.deathDetail = EmployeeBasic.Death_Mother_Detail__c;
                DeathInfo.isEditable = false;
            }
            else {
                DeathInfo.isEditable = true;
            }
            Application.DeathInfo.DeathInfos.add(DeathInfo);
        }
        
        //Death Child
        if(EmployeeBasic.Death_Child_JSON__c != null && string.isNotBlank(EmployeeBasic.Death_Child_JSON__c)) {
            List<ESS_EmployeeBasic_DTO.DeathInfoDTO> deathChilds = DeserializeDeathChildJSON(EmployeeBasic.Death_Child_JSON__c);
            if(deathChilds.size() > 0) {
                
        		Application.DeathInfo.isDeathChild = EmployeeBasic.Death_Is_Child_Death__c;
                
                for(ESS_EmployeeBasic_DTO.DeathInfoDTO deathChild : deathChilds) {
                    DeathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
                    
                    DeathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
                    DeathInfo.deathPerson.key = ESS_Enum.DeathPerson.Child.name();
                    DeathInfo.deathPerson.value = 'Child';   
                    DeathInfo.isEditable = deathChild.isEditable;
                    DeathInfo.thNo = deathChild.thNo;
                    DeathInfo.thFirstName = deathChild.thFirstName;
                    DeathInfo.thLastName = deathChild.thLastName;
                    DeathInfo.status = deathChild.status;
                    DeathInfo.deathDocumentNo = deathChild.deathDocumentNo;
                    DeathInfo.deathDocumentIssueLocation = deathChild.deathDocumentIssueLocation;
                    DeathInfo.deathDocumentIssueProvince = deathChild.deathDocumentIssueProvince;
                    DeathInfo.deathDocumentIssueDate = deathChild.deathDocumentIssueDate;
                    DeathInfo.deathDocumentUrl = deathChild.deathDocumentUrl;
                    DeathInfo.deathDocumentDisplayUrl = generateDocumentUrl(deathChild.deathDocumentUrl);
                    if(string.isNotBlank(deathChild.deathDocumentNo)) {
                        DeathInfo.isEditable = false;
                    }
                    else {
                        DeathInfo.isEditable = true;
                    }
                    Application.DeathInfo.DeathInfos.add(DeathInfo);
                   
                }
            }
        }
        
        //Education
        Application.EducationInfos = new List<ESS_EmployeeBasic_DTO.EducationInfoDTO>();
        if(string.isNotBlank(EmployeeBasic.Education_JSON__c)) {
        	
            Application.EducationInfos = DeserializeEducationJSON(EmployeeBasic.Education_JSON__c);
            
             if(Application.EducationInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.EducationInfoDTO EducationInfo : Application.EducationInfos) {
                    EducationInfo.transcriptDisplayUrl = generateDocumentUrl(EducationInfo.transcriptUrl);
                    EducationInfo.degreeCertificateDisplayUrl = generateDocumentUrl(EducationInfo.degreeCertificateUrl);
                    if(EducationInfo.status == null) {
                        EducationInfo.isEditable = false;
                    }
                }
            }
        }
        
        //License
        Application.LicenseInfos = new List<ESS_EmployeeBasic_DTO.LicenseInfoDTO>();
        ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
        
        LicenseInfo.isChange = EmployeeBasic.License_Citizen_Change__c;
        LicenseInfo.isEditable = true;
        LicenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
        LicenseInfo.licenseType.key = ESS_Enum.LicenseType.Citizen.name();
        LicenseInfo.licenseType.value = 'Citizen';
        LicenseInfo.citizenId = EmployeeBasic.License_Citizen_Id__c;
        LicenseInfo.issueDate = EmployeeBasic.License_Citizen_Old_Issue_Date__c;
        LicenseInfo.expireDate = EmployeeBasic.License_Citizen_Old_Expire_Date__c;
        LicenseInfo.issuedProvince = EmployeeBasic.License_Citizen_Old_Issue_Province__c;
        LicenseInfo.newIssueDate = EmployeeBasic.License_Citizen_New_Issue_Date__c;
        LicenseInfo.newExpireDate = EmployeeBasic.License_Citizen_New_Expire_Date__c;
        LicenseInfo.newIssuedProvince = EmployeeBasic.License_Citizen_New_Issue_Province__c;
        LicenseInfo.documentCitizenCopyUrl = EmployeeBasic.License_Citizen_Copy_Doc__c;
        LicenseInfo.documentCitizenCopyDisplayUrl = generateDocumentUrl(EmployeeBasic.License_Citizen_Copy_Doc__c);
        Application.LicenseInfos.add(LicenseInfo);
        
        LicenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
        LicenseInfo.isChange = EmployeeBasic.License_Professional_Change__c;
        LicenseInfo.isEditable = true;
        LicenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
        LicenseInfo.licenseType.key = ESS_Enum.LicenseType.Professional.name();
        LicenseInfo.licenseType.value = 'Professional';
        LicenseInfo.licenseNo = EmployeeBasic.License_Professional_Old_Doc_No__c;
        LicenseInfo.licenseLevel = EmployeeBasic.License_Professional_Old_Doc_Level__c;
        LicenseInfo.engineeringBranch = EmployeeBasic.License_Professional_Old_Engineer__c;
        LicenseInfo.issueDate = EmployeeBasic.License_Professional_Old_Doc_Issue_Date__c;
        LicenseInfo.expireDate = EmployeeBasic.License_Professional_Old_Doc_Expire_Date__c;
        LicenseInfo.newLicenseNo = EmployeeBasic.License_Professional_New_Doc_No__c;
        LicenseInfo.newLicenseLevel = EmployeeBasic.License_Professional_New_Doc_Level__c;
        LicenseInfo.newEngineeringBranch = EmployeeBasic.License_Professional_New_Engineer__c;
        LicenseInfo.newIssueDate = EmployeeBasic.License_Professional_New_Doc_Issue_Date__c;
        LicenseInfo.newExpireDate = EmployeeBasic.License_Professional_New_Doc_Expire_Date__c;
        LicenseInfo.documentProfessionalUrl = EmployeeBasic.License_Professional_Id__c;
        LicenseInfo.documentProfessionalDisplayUrl = generateDocumentUrl(EmployeeBasic.License_Professional_Id__c);
        Application.LicenseInfos.add(LicenseInfo);
        
        //Address
        Application.AddressInfos = new List<ESS_EmployeeBasic_DTO.AddressInfoDTO>();
        ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
        
        if((string.isNotBlank(EmployeeBasic.Address_TH_New_House_No__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_New_Moo__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_New_Village_Name__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_New_Soi__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_New_Road__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_New_Sub_District__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_New_District__c )||
            string.isNotBlank(EmployeeBasic.Address_TH_New_Province__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_New_Postal_Code__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_New_Telephone_No__c))
          ) {
            AddressInfo.isChange = true;
        }
        else {
            AddressInfo.isChange = false;
        }

        AddressInfo.isChange = EmployeeBasic.Address_Change__c;
        AddressInfo.isEditable = true;
        AddressInfo.addressType = new ESS_Global.EnumValue('AddressType');
        AddressInfo.addressType.key = ESS_Enum.AddressType.HouseRegistration.name();
        AddressInfo.addressType.value = 'HouseRegistration';
        AddressInfo.thHouseNo = EmployeeBasic.Address_TH_Old_House_No__c;
        AddressInfo.thMooVillageSoiRoad = EmployeeBasic.Address_TH_Old_Moo_Village_Soi_Road__c;
        AddressInfo.thSubDistrictDistrict = EmployeeBasic.Address_TH_Old_SubDistrict_District__c;
        AddressInfo.thProvince = EmployeeBasic.Address_TH_Old_Province__c;
        AddressInfo.thPostalCode = EmployeeBasic.Address_TH_Old_Postal_Code__c;
        AddressInfo.thTelephoneNo = EmployeeBasic.Address_TH_Old_Telephone_No__c;
        AddressInfo.enHouseNo = EmployeeBasic.Address_EN_Old_House_No__c;
        AddressInfo.enMooVillageSoiRoad = EmployeeBasic.Address_EN_Old_Moo_Village_Soi_Road__c;
        AddressInfo.enSubDistrictDistrict = EmployeeBasic.Address_EN_old_SubDistrict_District__c;
        AddressInfo.enProvince = EmployeeBasic.Address_EN_Old_Province__c;
        AddressInfo.enPostalCode = EmployeeBasic.Address_EN_Old_Postal_Code__c;
        AddressInfo.enTelephoneNo = EmployeeBasic.Address_EN_Old_Telephone_No__c;
        AddressInfo.newTHHouseNo = EmployeeBasic.Address_TH_New_House_No__c;
        AddressInfo.newTHMoo = EmployeeBasic.Address_TH_New_Moo__c;
        AddressInfo.newTHVillageName = EmployeeBasic.Address_TH_New_Village_Name__c;
        AddressInfo.newTHSoi = EmployeeBasic.Address_TH_New_Soi__c;
        AddressInfo.newTHRoad = EmployeeBasic.Address_TH_New_Road__c;
        AddressInfo.newTHSubDistrict = EmployeeBasic.Address_TH_New_Sub_District__c;
        AddressInfo.newTHDistrict = EmployeeBasic.Address_TH_New_District__c;
        AddressInfo.newTHProvince = EmployeeBasic.Address_TH_New_Province__c;
        AddressInfo.newTHPostalCode = EmployeeBasic.Address_TH_New_Postal_Code__c;
        AddressInfo.newTHTelephoneNo = EmployeeBasic.Address_TH_New_Telephone_No__c;
        AddressInfo.newENHouseNo = EmployeeBasic.Address_EN_New_House_No__c;
        AddressInfo.newENMoo = EmployeeBasic.Address_EN_New_Moo__c;
        AddressInfo.newENVillageName = EmployeeBasic.Address_EN_New_Village_Name__c;
        AddressInfo.newENSoi = EmployeeBasic.Address_EN_New_Soi__c;
        AddressInfo.newENRoad = EmployeeBasic.Address_EN_New_Road__c;
        AddressInfo.newENSubDistrict = EmployeeBasic.Address_EN_New_Sub_District__c;
        AddressInfo.newENDistrict = EmployeeBasic.Address_EN_New_District__c;
        AddressInfo.newENProvince = EmployeeBasic.Address_EN_New_Province__c;
        AddressInfo.newENPostalCode = EmployeeBasic.Address_EN_New_Postal_Code__c;
        AddressInfo.newENTelephoneNo = EmployeeBasic.Address_EN_New_Telephone_No__c;
        AddressInfo.documentRegistrationCopyUrl = EmployeeBasic.Address_House_Registration_Copy_Id__c;
        AddressInfo.documentRegistrationCopyDisplayUrl = generateDocumentUrl(EmployeeBasic.Address_House_Registration_Copy_Id__c);
        Application.AddressInfos.add(AddressInfo);
        
        AddressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
        
        if((string.isNotBlank(EmployeeBasic.Address_TH_Current_New_House_No__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_Current_New_Moo__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_Current_New_Village_Name__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_Current_New_Soi__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_Current_New_Road__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_Current_New_Sub_District__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_Current_New_District__c )||
            string.isNotBlank(EmployeeBasic.Address_TH_Current_New_Province__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_Current_New_Postal_Code__c) ||
            string.isNotBlank(EmployeeBasic.Address_TH_Current_New_Telephone_No__c))
          ) {
            AddressInfo.isChange = true;
        }
        else {
        	AddressInfo.isChange = false;
        }
        
        AddressInfo.isChange = EmployeeBasic.Address_Current_Change__c;
        AddressInfo.isEditable = true;
        AddressInfo.addressType = new ESS_Global.EnumValue('AddressType');
        AddressInfo.addressType.key = ESS_Enum.AddressType.Current.name();
        AddressInfo.addressType.value = 'Current';
        AddressInfo.thHouseNo = EmployeeBasic.Address_TH_Current_Old_House_No__c;
        AddressInfo.thMooVillageSoiRoad = EmployeeBasic.Address_TH_Current_Old_Moo_Vill_Soi_Road__c;
        AddressInfo.thSubDistrictDistrict = EmployeeBasic.Address_TH_Current_Old_SubDis_District__c;
        AddressInfo.thProvince = EmployeeBasic.Address_TH_Current_Old_Province__c;
        AddressInfo.thPostalCode = EmployeeBasic.Address_TH_Current_Old_Postal_Code__c;
        AddressInfo.thTelephoneNo = EmployeeBasic.Address_TH_Current_Old_Telephone_No__c;
        AddressInfo.enHouseNo = EmployeeBasic.Address_EN_Current_Old_House_No__c;
        AddressInfo.enMooVillageSoiRoad = EmployeeBasic.Address_EN_Current_Old_Moo_Vill_Soi_Road__c;
        AddressInfo.enSubDistrictDistrict = EmployeeBasic.Address_EN_Current_Old_SubDis_District__c;
        AddressInfo.enProvince = EmployeeBasic.Address_EN_Current_Old_Province__c;
        AddressInfo.enPostalCode = EmployeeBasic.Address_EN_Current_Old_Postal_Code__c;
        AddressInfo.enTelephoneNo = EmployeeBasic.Address_EN_Current_Old_Telephone_No__c;
        AddressInfo.newTHHouseNo = EmployeeBasic.Address_TH_Current_New_House_No__c;
        AddressInfo.newTHMoo = EmployeeBasic.Address_TH_Current_New_Moo__c;
        AddressInfo.newTHVillageName = EmployeeBasic.Address_TH_Current_New_Village_Name__c;
        AddressInfo.newTHSoi = EmployeeBasic.Address_TH_Current_New_Soi__c;
        AddressInfo.newTHRoad = EmployeeBasic.Address_TH_Current_New_Road__c;
        AddressInfo.newTHSubDistrict = EmployeeBasic.Address_TH_Current_New_Sub_District__c;
        AddressInfo.newTHDistrict = EmployeeBasic.Address_TH_Current_New_District__c;
        AddressInfo.newTHProvince = EmployeeBasic.Address_TH_Current_New_Province__c;
        AddressInfo.newTHPostalCode = EmployeeBasic.Address_TH_Current_New_Postal_Code__c;
        AddressInfo.newTHTelephoneNo = EmployeeBasic.Address_TH_Current_New_Telephone_No__c;
        AddressInfo.newENHouseNo = EmployeeBasic.Address_EN_Current_New_House_No__c;
        AddressInfo.newENMoo = EmployeeBasic.Address_EN_Current_New_Moo__c;
        AddressInfo.newENVillageName = EmployeeBasic.Address_EN_Current_New_Village_Name__c;
        AddressInfo.newENSoi = EmployeeBasic.Address_EN_Current_New_Soi__c;
        AddressInfo.newENRoad = EmployeeBasic.Address_EN_Current_New_Road__c;
        AddressInfo.newENSubDistrict = EmployeeBasic.Address_EN_Current_New_Sub_District__c;
        AddressInfo.newENDistrict = EmployeeBasic.Address_EN_Current_New_District__c;
        AddressInfo.newENProvince = EmployeeBasic.Address_EN_Current_New_Province__c;
        AddressInfo.newENPostalCode = EmployeeBasic.Address_EN_Current_New_Postal_Code__c;
        AddressInfo.newENTelephoneNo = EmployeeBasic.Address_EN_Current_New_Telephone_No__c;
        AddressInfo.documentRegistrationCopyUrl = EmployeeBasic.Address_Current_Address_Copy_Id__c;
        AddressInfo.documentRegistrationCopyDisplayUrl = generateDocumentUrl(EmployeeBasic.Address_Current_Address_Copy_Id__c);
        Application.AddressInfos.add(AddressInfo);
        
        //ContactPerson
        Application.ContactPersonInfos = new List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO>();
        if(EmployeeBasic.Contact_Person_JSON__c != null && string.isNotBlank(EmployeeBasic.Contact_Person_JSON__c)) {
        	Application.ContactPersonInfos = DeserializeContactPersonJSON(EmployeeBasic.Contact_Person_JSON__c);
        }
        
        //Tax
        Application.TaxInfo = new ESS_EmployeeBasic_DTO.TaxInfoDTO();
        Application.TaxInfo.isChange = EmployeeBasic.Is_Update_Tax__c;
        Application.TaxInfo.isEditable = true;
        Application.TaxInfo.name = EmployeeBasic.Employee_Name__c;
        Application.TaxInfo.citizenId = EmployeeBasic.License_Citizen_Id__c;
        Application.TaxInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
        if(EmployeeBasic.Tax_Marriage_Status__c == '0') {
            Application.TaxInfo.marriedStatus.key = ESS_Enum.MarriedStatus.Single.name();
            Application.TaxInfo.marriedStatus.value = 'Single';
        }
        else if(EmployeeBasic.Tax_Marriage_Status__c == '1') {
            Application.TaxInfo.marriedStatus.key = ESS_Enum.MarriedStatus.Married.name();
            Application.TaxInfo.marriedStatus.value = 'Married';
        }
        Application.TaxInfo.marriedPersonEarnIncome = new ESS_Global.EnumValue('MarriedEarnIncome'); 
        if(EmployeeBasic.Tax_Marriage_Person_Earn_Income__c == '2') {
            Application.TaxInfo.marriedPersonEarnIncome.key = ESS_Enum.MarriedEarnIncome.MarriedEarnIncome.name();
            Application.TaxInfo.marriedPersonEarnIncome.value = 'คู่สมรสมีเงินได้';
        }
        else if(EmployeeBasic.Tax_Marriage_Person_Earn_Income__c == '1') {
            Application.TaxInfo.marriedPersonEarnIncome.key = ESS_Enum.MarriedEarnIncome.MarriedNotEarnIncome.name();
            Application.TaxInfo.marriedPersonEarnIncome.value = 'คู่สมรสไม่มีเงินได้';
        }
		Application.TaxInfo.childCount = Integer.ValueOf(EmployeeBasic.Tax_Child_Count__c);
        Application.TaxInfo.childCountTotal = Integer.ValueOf(EmployeeBasic.Tax_Total_Child_Count__c);
        Application.TaxInfo.selfLifeInsurancePaidAmount = EmployeeBasic.Tax_Self_Life_Insurance_Paid_Amount__c;
        Application.TaxInfo.marriedLifeInsurancePaidAmount = EmployeeBasic.Tax_Married_Life_Insurance_Paid_Amount__c;
        Application.TaxInfo.selfFatherHealthInsurancePaidAmount = EmployeeBasic.Tax_Self_Father_Insurance_Paid_Amount__c;
        Application.TaxInfo.selfMotherHealthInsurancePaidAmount = EmployeeBasic.Tax_Self_Mother_Insurance_Paid_Amount__c;
        Application.TaxInfo.marriedFatherHealthInsurancePaidAmount = EmployeeBasic.Tax_Married_Father_Insurance_Paid_Amount__c;
        Application.TaxInfo.marriedMotherHealthInsurancePaidAmount = EmployeeBasic.Tax_Married_Mother_Insurance_Paid_Amount__c;
        Application.TaxInfo.interestOnLoanForHouseAmount = EmployeeBasic.Tax_Interest_On_Loan_For_House_Amount__c;
        Application.TaxInfo.incomeFromRMFAmount = EmployeeBasic.Tax_Income_From_RMF_Amount__c;
        Application.TaxInfo.incomeFromSSFAmount = EmployeeBasic.Tax_Income_From_SSF_Amount__c;
        Application.TaxInfo.selfTaxDeductionFatherAmount = EmployeeBasic.Tax_Self_Deduction_Father_Amount__c;
        Application.TaxInfo.selfTaxDeductionMotherAmount = EmployeeBasic.Tax_Self_Deduction_Mother_Amount__c;
        Application.TaxInfo.marriedTaxDeductionFatherAmount = EmployeeBasic.Tax_Married_Deduction_Father_Amount__c;
        Application.TaxInfo.marriedTaxDeductionMotherAmount = EmployeeBasic.Tax_Married_Deduction_Mother_Amount__c;
        Application.TaxInfo.donationForCharityAmount = EmployeeBasic.Tax_Donation_For_Charity_Amount__c;
        Application.TaxInfo.sponsorAmount = EmployeeBasic.Tax_Sponsor_Amount__c;
        Application.TaxInfo.donationForEducationAmount = EmployeeBasic.Tax_Donation_For_Education_Amount__c;
        Application.TaxInfo.annuityInterestAmount = EmployeeBasic.Tax_Annuity_Interest_Amount__c;
        Application.TaxInfo.firstHouseExcludeTaxAmount = EmployeeBasic.Tax_First_House_Exclude_Tax_Amount__c;
        Application.TaxInfo.pregnancyCareAmount = EmployeeBasic.Tax_Pregnancy_Care_Amount__c;
        
        return Application;
    }
    
    @TestVisible
    private static ESS_EmployeeBasic_DTO.ApplicationDTO assignFromMasterEmployeeDTO(ESS_Master_Employee__c Master, ESS_EmployeeBasic_DTO.ApplicationDTO Application) {
        
        //NameInfo
        Application.NameInfo = new ESS_EmployeeBasic_DTO.NameInfoDTO();
        Application.NameInfo.isChange = false;
        Application.NameInfo.editSelfInfo = false;
        Application.NameInfo.editMarriedInfo = false;
        Application.NameInfo.editChildInfo = false;
        Application.NameInfo.editFatherInfo = false;
        Application.NameInfo.editMotherInfo = false;
        
        //NameInfo - Employee
        Application.NameInfo.employeeInfo = new ESS_EmployeeBasic_DTO.EmployeeInfoDTO();
        Application.NameInfo.employeeInfo.isChange = false;
        Application.NameInfo.employeeInfo.isEditable = true;
        
        Application.NameInfo.employeeInfo.oldTHTitleFNLN = Master.Name_Emp_TH_Title_FN_LN__c;
             
        Application.NameInfo.employeeInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(Master.Name_Emp_EN_Title__c == '1') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '1';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Mr';
        }
        else if(Master.Name_Emp_EN_Title__c == '2') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '2';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Mrs';
        }
        else if(Master.Name_Emp_EN_Title__c == '3') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '3';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Miss';
        }
        else if(Master.Name_Emp_EN_Title__c == '4') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '4';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Ms';
        }
        else if(Master.Name_Emp_EN_Title__c == '5') {
            Application.NameInfo.employeeInfo.oldENTitle.key = '5';
            Application.NameInfo.employeeInfo.oldENTitle.value = 'Dr';
        }
        Application.NameInfo.employeeInfo.oldENFirstName = Master.Name_Emp_EN_FN__c;
        Application.NameInfo.employeeInfo.oldENLastName = Master.Name_Emp_EN_LN__c;
        
        //NameInfo - Marriage
        Application.NameInfo.statusInfo = new ESS_EmployeeBasic_DTO.StatusInfoDTO();
        Application.NameInfo.statusInfo.isChange = false;
        Application.NameInfo.statusInfo.isEditable = true;
        
        Application.NameInfo.statusInfo.oldTHTitle = new ESS_Global.EnumValue('Title');
        if(Master.Name_Marriage_TH_Title__c == '1') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '1';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(Master.Name_Marriage_TH_Title__c);
        }
        else if(Master.Name_Marriage_TH_Title__c == '2') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '2';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(Master.Name_Marriage_TH_Title__c);
        }
        else if(Master.Name_Marriage_TH_Title__c == '3') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '3';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(Master.Name_Marriage_TH_Title__c);
        }
        else if(Master.Name_Marriage_TH_Title__c == '4') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '4';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(Master.Name_Marriage_TH_Title__c);
        }
        else if(Master.Name_Marriage_TH_Title__c == '5') {
            Application.NameInfo.statusInfo.oldTHTitle.key = '5';
            Application.NameInfo.statusInfo.oldTHTitle.value = assignTHTitle(Master.Name_Marriage_TH_Title__c);
        }
        Application.NameInfo.statusInfo.oldTHFirstName = Master.Name_Marriage_TH_FN__c;
        Application.NameInfo.statusInfo.oldTHLastName = Master.Name_Marriage_TH_LN__c;
                
        Application.NameInfo.statusInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(Master.Name_Marriage_EN_Title__c == '1') {
            Application.NameInfo.statusInfo.oldENTitle.key = '1';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Mr';
        }
        else if(Master.Name_Marriage_EN_Title__c == '2') {
            Application.NameInfo.statusInfo.oldENTitle.key = '2';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Mrs';
        }
        else if(Master.Name_Marriage_EN_Title__c == '3') {
            Application.NameInfo.statusInfo.oldENTitle.key = '3';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Miss';
        }
        else if(Master.Name_Marriage_EN_Title__c == '4') {
            Application.NameInfo.statusInfo.oldENTitle.key = '4';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Ms';
        }
        else if(Master.Name_Marriage_EN_Title__c == '5') {
            Application.NameInfo.statusInfo.oldENTitle.key = '5';
            Application.NameInfo.statusInfo.oldENTitle.value = 'Dr';
        }
        Application.NameInfo.statusInfo.oldENFirstName = Master.Name_Marriage_EN_FN__c;
        Application.NameInfo.statusInfo.oldENLastName = Master.Name_Marriage_EN_LN__c;
        
        //NameInfo - Child
        Application.NameInfo.ChildInfos = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
        if(Master.Child_JSON__c != null && string.isNotBlank(Master.Name_Child_JSON__c)) {
        	Application.NameInfo.ChildInfos = DeserializeChildJSON(Master.Name_Child_JSON__c);
        }
        Application.NameInfo.childCount = Integer.ValueOf(Master.Name_Child_Count__c);
        
        //NameInfo - Father
        Application.NameInfo.fatherInfo = new ESS_EmployeeBasic_DTO.FatherInfoDTO();
        Application.NameInfo.fatherInfo.isEditable = true;
        if(string.isNotBlank(Master.Death_Father_Detail__c)) {
            Application.NameInfo.fatherInfo.isEditable = false;
        }
        
        Application.NameInfo.fatherInfo.oldTHTitle = new ESS_Global.EnumValue('Title');
        if(Master.Name_Father_TH_Title__c == '1') {
            Application.NameInfo.fatherInfo.oldTHTitle.key = '1';
            Application.NameInfo.fatherInfo.oldTHTitle.value = 'นาย';
        }
        else if(Master.Name_Father_TH_Title__c == '5') {
            Application.NameInfo.fatherInfo.oldTHTitle.key = '5';
            Application.NameInfo.fatherInfo.oldTHTitle.value = 'ดร';
        }
        Application.NameInfo.fatherInfo.oldTHFirstName = Master.Name_Father_TH_FN__c;
        Application.NameInfo.fatherInfo.oldTHLastName = Master.Name_Father_TH_LN__c;
                
        Application.NameInfo.fatherInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(Master.Name_Father_EN_Title__c == '1') {
            Application.NameInfo.fatherInfo.oldENTitle.key = '1';
            Application.NameInfo.fatherInfo.oldENTitle.value = 'Mr';
        }
        else if(Master.Name_Father_EN_Title__c == '5') {
            Application.NameInfo.fatherInfo.oldENTitle.key = '5';
            Application.NameInfo.fatherInfo.oldENTitle.value = 'Dr';
        }
        Application.NameInfo.fatherInfo.oldENFirstName = Master.Name_Father_EN_FN__c;
        Application.NameInfo.fatherInfo.oldENLastName = Master.Name_Father_EN_LN__c;
        
        //NameInfo - Mother
        Application.NameInfo.motherInfo = new ESS_EmployeeBasic_DTO.MotherInfoDTO();
        Application.NameInfo.motherInfo.isEditable = true;
        if(string.isNotBlank(Master.Death_Mother_Detail__c)) {
            Application.NameInfo.motherInfo.isEditable = false;
        }
        
        Application.NameInfo.motherInfo.oldTHTitle = new ESS_Global.EnumValue('Title');
        if(Master.Name_Mother_TH_Title__c == '2') {
            Application.NameInfo.motherInfo.oldTHTitle.key = '2';
            Application.NameInfo.motherInfo.oldTHTitle.value = assignTHTitle(Master.Name_Mother_TH_Title__c);
        }
        else if(Master.Name_Mother_TH_Title__c == '3') {
            Application.NameInfo.motherInfo.oldTHTitle.key = '3';
            Application.NameInfo.motherInfo.oldTHTitle.value = assignTHTitle(Master.Name_Mother_TH_Title__c);
        }
        else if(Master.Name_Mother_TH_Title__c == '4') {
            Application.NameInfo.motherInfo.oldTHTitle.key = '4';
            Application.NameInfo.motherInfo.oldTHTitle.value = assignTHTitle(Master.Name_Mother_TH_Title__c);
        }
        else if(Master.Name_Mother_TH_Title__c == '5') {
            Application.NameInfo.motherInfo.oldTHTitle.key = '5';
            Application.NameInfo.motherInfo.oldTHTitle.value = assignTHTitle(Master.Name_Mother_TH_Title__c);
        }
        Application.NameInfo.motherInfo.oldTHFirstName = Master.Name_Mother_TH_FN__c;
        Application.NameInfo.motherInfo.oldTHLastName = Master.Name_Mother_TH_LN__c;
                
        Application.NameInfo.motherInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(Master.Name_Mother_EN_Title__c == '2') {
            Application.NameInfo.motherInfo.oldENTitle.key = '2';
            Application.NameInfo.motherInfo.oldENTitle.value = 'Mrs';
        }
        else if(Master.Name_Mother_EN_Title__c == '3') {
            Application.NameInfo.motherInfo.oldENTitle.key = '3';
            Application.NameInfo.motherInfo.oldENTitle.value = 'Miss';
        }
        else if(Master.Name_Mother_EN_Title__c == '4') {
            Application.NameInfo.motherInfo.oldENTitle.key = '4';
            Application.NameInfo.motherInfo.oldENTitle.value = 'Ms';
        }
        else if(Master.Name_Mother_EN_Title__c == '5') {
            Application.NameInfo.motherInfo.oldENTitle.key = '5';
            Application.NameInfo.motherInfo.oldENTitle.value = 'Dr';
        }
        Application.NameInfo.motherInfo.oldENFirstName = Master.Name_Mother_EN_FN__c;
        Application.NameInfo.motherInfo.oldENLastName = Master.Name_Mother_EN_LN__c;
        
        //Status
        Application.StatusInfo = new ESS_EmployeeBasic_DTO.StatusInfoDTO();
        Application.StatusInfo.isChange = false;
        Application.StatusInfo.isEditable = true;
        Application.StatusInfo.oldIsMarriedPersonAsEmployee = Master.Is_Marriage_As_Employee__c;
        Application.StatusInfo.isMarriedPersonAsEmployee = Master.Is_Marriage_As_Employee__c;
        Application.StatusInfo.employeeId = application.applicationHeaderInfo.employeeId;
        Application.StatusInfo.isUpdateMarriedStatus = false;
        Application.StatusInfo.marriedEmployeeId = Master.Status_Marriage_Employee_Id__c;
        
        Application.StatusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
        if(Master.Status_Marriage_Status__c == '0') {
            Application.StatusInfo.marriedStatus.key = '0';
            Application.StatusInfo.marriedStatus.value = 'Single';
        }
        else if(Master.Status_Marriage_Status__c == '1') {
            Application.StatusInfo.marriedStatus.key = '1';
            Application.StatusInfo.marriedStatus.value = 'Married';
        }
        else if(Master.Status_Marriage_Status__c == '3') {
            Application.StatusInfo.marriedStatus.key = '3';
            Application.StatusInfo.marriedStatus.value = 'Divorced';
        }
        else if(Master.Status_Marriage_Status__c == '2') {
            Application.StatusInfo.marriedStatus.key = '2';
            Application.StatusInfo.marriedStatus.value = 'Widow';
        }
        else if(Master.Status_Marriage_Status__c == '4') {
            Application.StatusInfo.marriedStatus.key = '4';
            Application.StatusInfo.marriedStatus.value = 'Seperate';
        }
        Application.StatusInfo.isShowOnlyMarried = showOnlyMarriedStatus(Master.Employee_ID__c);
        
        Application.StatusInfo.isMarriedPersonChangeDetail = false;
        Application.StatusInfo.oldTHTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Marriage_TH_Title__c == '1') {
            Application.StatusInfo.oldTHTitle.key = '1';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(Master.Status_Marriage_TH_Title__c);
        }
        else if(Master.Status_Marriage_TH_Title__c == '2') {
            Application.StatusInfo.oldTHTitle.key = '2';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(Master.Status_Marriage_TH_Title__c);
        }
        else if(Master.Status_Marriage_TH_Title__c == '3') {
            Application.StatusInfo.oldTHTitle.key = '3';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(Master.Status_Marriage_TH_Title__c);
        }
        else if(Master.Status_Marriage_TH_Title__c == '4') {
            Application.StatusInfo.oldTHTitle.key = '4';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(Master.Status_Marriage_TH_Title__c);
        }
        else if(Master.Status_Marriage_TH_Title__c == '5') {
            Application.StatusInfo.oldTHTitle.key = '5';
            Application.StatusInfo.oldTHTitle.value = assignTHTitle(Master.Status_Marriage_TH_Title__c);
        }
        Application.StatusInfo.oldTHFirstName = Master.Status_Marriage_TH_FN__c;
        Application.StatusInfo.oldTHLastName = Master.Status_Marriage_TH_LN__c;
        
        Application.StatusInfo.oldENTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Marriage_EN_Title__c == '1') {
            Application.StatusInfo.oldENTitle.key = '1';
            Application.StatusInfo.oldENTitle.value = 'Mr';
        }
        else if(Master.Status_Marriage_EN_Title__c == '2') {
            Application.StatusInfo.oldENTitle.key = '2';
            Application.StatusInfo.oldENTitle.value = 'Mrs';
        }
        else if(Master.Status_Marriage_EN_Title__c == '3') {
            Application.StatusInfo.oldENTitle.key = '3';
            Application.StatusInfo.oldENTitle.value = 'Miss';
        }
        else if(Master.Status_Marriage_EN_Title__c == '4') {
            Application.StatusInfo.oldENTitle.key = '4';
            Application.StatusInfo.oldENTitle.value = 'Ms';
        }
        else if(Master.Status_Marriage_EN_Title__c == '5') {
            Application.StatusInfo.oldENTitle.key = '5';
            Application.StatusInfo.oldENTitle.value = 'Dr';
        }
        Application.StatusInfo.oldENFirstName = Master.Status_Marriage_EN_FN__c;
        Application.StatusInfo.oldENLastName = Master.Status_Marriage_EN_LN__c;
        Application.StatusInfo.citizenId = Master.Status_Marriage_Citizen_Id__c;
        Application.StatusInfo.dateOfBirth = Master.Status_Marriage_DOB__c;
        Application.StatusInfo.occupation = Master.Status_Marriage_Occupation__c;
        Application.StatusInfo.marriedDocumentNo = Master.Status_Marriage_Doc_No__c;
        Application.StatusInfo.marriedDocumentIssueLocation = Master.Status_Marriage_Doc_Issue_Location__c;
        Application.StatusInfo.marriedDocumentIssueProvince = Master.Status_Marriage_Doc_Issue_Province__c;
        Application.StatusInfo.marriedDocumentIssueDate = Master.Status_Marriage_Doc_Issue_Date__c;
        
        //Divorce
        Application.StatusInfo.divorcedTHTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Divorce_TH_Title__c  == '1') {
            Application.StatusInfo.divorcedTHTitle.key = '1';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_Title__c);
        }
        else if(Master.Status_Divorce_TH_Title__c  == '2') {
            Application.StatusInfo.divorcedTHTitle.key = '2';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_Title__c);
        }
        else if(Master.Status_Divorce_TH_Title__c  == '3') {
            Application.StatusInfo.divorcedTHTitle.key = '3';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_Title__c);
        }
        else if(Master.Status_Divorce_TH_Title__c  == '4') {
            Application.StatusInfo.divorcedTHTitle.key = '4';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_Title__c);
        }
        else if(Master.Status_Divorce_TH_Title__c  == '5') {
            Application.StatusInfo.divorcedTHTitle.key = '5';
            Application.StatusInfo.divorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_Title__c);
        }
        Application.StatusInfo.divorcedTHFirstName = Master.Status_Divorce_TH_FN__c;
        Application.StatusInfo.divorcedTHLastName = Master.Status_Divorce_TH_LN__c;
        Application.StatusInfo.divorcedENTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Divorce_EN_Title__c == '1') {
            Application.StatusInfo.divorcedENTitle.key = '1';
            Application.StatusInfo.divorcedENTitle.value = 'Mr';
        }
        else if(Master.Status_Divorce_EN_Title__c == '2') {
            Application.StatusInfo.divorcedENTitle.key = '2';
            Application.StatusInfo.divorcedENTitle.value = 'Mrs';
        }
        else if(Master.Status_Divorce_EN_Title__c == '3') {
            Application.StatusInfo.divorcedENTitle.key = '3';
            Application.StatusInfo.divorcedENTitle.value = 'Miss';
        }
        else if(Master.Status_Divorce_EN_Title__c == '4') {
            Application.StatusInfo.divorcedENTitle.key = '4';
            Application.StatusInfo.divorcedENTitle.value = 'Ms';
        }
        else if(Master.Status_Divorce_EN_Title__c == '5') {
            Application.StatusInfo.divorcedENTitle.key = '5';
            Application.StatusInfo.divorcedENTitle.value = 'Dr';
        }
        
        Application.StatusInfo.divorcedENFirstName = Master.Status_Divorce_EN_FN__c;
        Application.StatusInfo.divorcedENLastName = Master.Status_Divorce_EN_LN__c;
        Application.StatusInfo.divorcedDocumentNo = Master.Status_Divorce_Doc_No__c;
        Application.StatusInfo.divorcedDocumentIssueLocation = Master.Status_Divorce_Doc_Issue_Location__c;
        Application.StatusInfo.divorcedDocumentIssueProvince = Master.Status_Divorce_Doc_Issue_Province__c;
        Application.StatusInfo.divorcedDocumentIssueDate = Master.Status_Divorce_Doc_Issue_Date__c;
        Application.StatusInfo.isChangeTitleAfterDivorced = Master.Status_Divorce_Change_Title__c;
        Application.StatusInfo.isChangeLastNameAfterDivorced = Master.Status_Divorce_Change_LN__c;
        
        Application.StatusInfo.newDivorcedTHTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Divorce_TH_New_Title__c == '1') {
            Application.StatusInfo.newDivorcedTHTitle.key = '1';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_New_Title__c);
        }
        else if(Master.Status_Divorce_TH_New_Title__c == '2') {
            Application.StatusInfo.newDivorcedTHTitle.key = '2';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_New_Title__c);
        }
        else if(Master.Status_Divorce_TH_New_Title__c == '3') {
            Application.StatusInfo.newDivorcedTHTitle.key = '3';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_New_Title__c);
        }
        else if(Master.Status_Divorce_TH_New_Title__c == '4') {
            Application.StatusInfo.newDivorcedTHTitle.key = '4';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_New_Title__c);
        }
        else if(Master.Status_Divorce_TH_New_Title__c == '5') {
            Application.StatusInfo.newDivorcedTHTitle.key = '5';
            Application.StatusInfo.newDivorcedTHTitle.value = assignTHTitle(Master.Status_Divorce_TH_New_Title__c);
        }
        Application.StatusInfo.newDivorcedTHLastName = Master.Status_Divorce_TH_New_LN__c;
        
        Application.StatusInfo.newDivorcedENTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Divorce_EN_New_Title__c == '1') {
            Application.StatusInfo.newDivorcedENTitle.key = '1';
            Application.StatusInfo.newDivorcedENTitle.value = 'Mr';
        }
        else if(Master.Status_Divorce_EN_New_Title__c == '2') {
            Application.StatusInfo.newDivorcedENTitle.key = '2';
            Application.StatusInfo.newDivorcedENTitle.value = 'Mrs';
        }
        else if(Master.Status_Divorce_EN_New_Title__c == '3') {
            Application.StatusInfo.newDivorcedENTitle.key = '3';
            Application.StatusInfo.newDivorcedENTitle.value = 'Miss';
        }
        else if(Master.Status_Divorce_EN_New_Title__c == '4') {
            Application.StatusInfo.newDivorcedENTitle.key = '4';
            Application.StatusInfo.newDivorcedENTitle.value = 'Ms';
        }
        else if(Master.Status_Divorce_EN_New_Title__c == '5') {
            Application.StatusInfo.newDivorcedENTitle.key = '5';
            Application.StatusInfo.newDivorcedENTitle.value = 'Dr';
        }
        Application.StatusInfo.newDivorcedENLastName = Master.Status_Divorce_EN_New_LN__c;
        
        //Widow
        Application.StatusInfo.widowTHTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Widow_TH_Title__c  == '1') {
            Application.StatusInfo.widowTHTitle.key = '1';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_Title__c);
        }
        else if(Master.Status_Widow_TH_Title__c  == '2') {
            Application.StatusInfo.widowTHTitle.key = '2';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_Title__c);
        }
        else if(Master.Status_Widow_TH_Title__c  == '3') {
            Application.StatusInfo.widowTHTitle.key = '3';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_Title__c);
        }
        else if(Master.Status_Widow_TH_Title__c  == '4') {
            Application.StatusInfo.widowTHTitle.key = '4';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_Title__c);
        }
        else if(Master.Status_Widow_TH_Title__c  == '5') {
            Application.StatusInfo.widowTHTitle.key = '5';
            Application.StatusInfo.widowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_Title__c);
        }
        Application.StatusInfo.widowTHFirstName = Master.Status_Widow_TH_FN__c;
        Application.StatusInfo.widowTHLastName = MAster.Status_Widow_TH_LN__c;
        Application.StatusInfo.widowENTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Widow_EN_Title__c == '1') {
            Application.StatusInfo.widowENTitle.key = '1';
            Application.StatusInfo.widowENTitle.value = 'Mr';
        }
        else if(Master.Status_Widow_EN_Title__c == '2') {
            Application.StatusInfo.widowENTitle.key = '2';
            Application.StatusInfo.widowENTitle.value = 'Mrs';
        }
        else if(Master.Status_Widow_EN_Title__c == '3') {
            Application.StatusInfo.widowENTitle.key = '3';
            Application.StatusInfo.widowENTitle.value = 'Miss';
        }
        else if(Master.Status_Widow_EN_Title__c == '4') {
            Application.StatusInfo.widowENTitle.key = '4';
            Application.StatusInfo.widowENTitle.value = 'Ms';
        }
        else if(Master.Status_Widow_EN_Title__c == '5') {
            Application.StatusInfo.widowENTitle.key = '5';
            Application.StatusInfo.widowENTitle.value = 'Dr';
        }
        
        Application.StatusInfo.widowENFirstName = Master.Status_Widow_EN_FN__c;
        Application.StatusInfo.widowENLastName = Master.Status_Widow_EN_LN__c;
        Application.StatusInfo.widowDocumentNo = Master.Status_Widow_Doc_No__c;
        Application.StatusInfo.widowDocumentIssueLocation = Master.Status_Widow_Doc_Issue_Location__c;
        Application.StatusInfo.widowDocumentIssueProvince = Master.Status_Widow_Doc_Issue_Province__c;
        Application.StatusInfo.widowDocumentIssueDate = Master.Status_Widow_Doc_Issue_Date__c;
        Application.StatusInfo.isChangeTitleAfterWidow = Master.Status_Widow_Change_Title__c;
        Application.StatusInfo.isChangeLastNameAfterWidow = Master.Status_Widow_Change_LN__c;
        
        Application.StatusInfo.newWidowTHTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Widow_TH_New_Title__c == '1') {
            Application.StatusInfo.newWidowTHTitle.key = '1';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_New_Title__c);
        }
        else if(Master.Status_Widow_TH_New_Title__c == '2') {
            Application.StatusInfo.newWidowTHTitle.key = '2';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_New_Title__c);
        }
        else if(Master.Status_Widow_TH_New_Title__c == '3') {
            Application.StatusInfo.newWidowTHTitle.key = '3';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_New_Title__c);
        }
        else if(Master.Status_Widow_TH_New_Title__c == '4') {
            Application.StatusInfo.newWidowTHTitle.key = '4';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_New_Title__c);
        }
        else if(Master.Status_Widow_TH_New_Title__c == '5') {
            Application.StatusInfo.newWidowTHTitle.key = '5';
            Application.StatusInfo.newWidowTHTitle.value = assignTHTitle(Master.Status_Widow_TH_New_Title__c);
        }
        Application.StatusInfo.newWidowTHLastName = Master.Status_Widow_TH_New_LN__c;
        
        Application.StatusInfo.newWidowENTitle = new ESS_Global.EnumValue('Title');
        if(Master.Status_Widow_EN_New_Title__c == '1') {
            Application.StatusInfo.newWidowENTitle.key = '1';
            Application.StatusInfo.newWidowENTitle.value = 'Mr';
        }
        else if(Master.Status_Widow_EN_New_Title__c == '2') {
            Application.StatusInfo.newWidowENTitle.key = '2';
            Application.StatusInfo.newWidowENTitle.value = 'Mrs';
        }
        else if(Master.Status_Widow_EN_New_Title__c == '3') {
            Application.StatusInfo.newWidowENTitle.key = '3';
            Application.StatusInfo.newWidowENTitle.value = 'Miss';
        }
        else if(Master.Status_Widow_EN_New_Title__c == '4') {
            Application.StatusInfo.newWidowENTitle.key = '4';
            Application.StatusInfo.newWidowENTitle.value = 'Ms';
        }
        else if(Master.Status_Widow_EN_New_Title__c == '5') {
            Application.StatusInfo.newWidowENTitle.key = '5';
            Application.StatusInfo.newWidowENTitle.value = 'Dr';
        }
        Application.StatusInfo.newWidowENLastName = Master.Status_Widow_EN_New_LN__c;
        
        //Child
        Application.ChildInfos = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
        if(Master.Child_JSON__c != null && string.isNotBlank(Master.Child_JSON__c)) {
            Application.ChildInfos = DeserializeChildJSON(Master.Child_JSON__c);
            if(Application.ChildInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.ChildInfoDTO Child : Application.ChildInfos) {
                    if(Child.gender.key == '1') {
                        Child.gender.key = 'Male';
                    }
                    else if(Child.gender.key == '2') {
                        Child.gender.key = 'Female';
                    }
                    Child.isChange = false;
                }
            }
        }
        
        //Death
        Application.DeathInfo = new ESS_EmployeeBasic_DTO.DeathHeaderDTO();
        Application.DeathInfo.isChange = false;
        Application.DeathInfo.isEditable = true;
        Application.DeathInfo.isMarriedPersonAsEmployee = Master.Is_Marriage_As_Employee__c;
        Application.DeathInfo.isDeathWife = false;
        Application.DeathInfo.isDeathChild = false;
        Application.DeathInfo.isDeathFather = false;
        Application.DeathInfo.isDeathMother = false;
        Application.DeathInfo.employeeId = Master.Employee_ID__c;
        
        Application.DeathInfo.DeathInfos = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
        
        //Death Marriage
        ESS_EmployeeBasic_DTO.DeathInfoDTO DeathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
        //if(string.isNotBlank(Master.Death_Marriage_Doc_No__c)) {
            DeathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            DeathInfo.deathPerson.key = ESS_Enum.DeathPerson.Married.name();
            DeathInfo.deathPerson.value = 'Married';     
            DeathInfo.thNo = '01';
            DeathInfo.title = new ESS_Global.EnumValue('Title');
            if(Master.Death_Marriage_Title__c == '1') {
                DeathInfo.title.key = '1';
                DeathInfo.title.value = 'Mr';
            }
            else if(Master.Death_Marriage_Title__c == '2') {
                DeathInfo.title.key = '2';
                DeathInfo.title.value = 'Mrs';
            }
            else if(Master.Death_Marriage_Title__c == '3') {
                DeathInfo.title.key = '3';
                DeathInfo.title.value = 'Miss';
            }
            else if(Master.Death_Marriage_Title__c == '4') {
                DeathInfo.title.key = '4';
                DeathInfo.title.value = 'Ms';
            }
            else if(Master.Death_Marriage_Title__c == '5') {
                DeathInfo.title.key = '5';
                DeathInfo.title.value = 'Dr';
            }
            DeathInfo.thFirstName = Master.Death_Marriage_FN__c;
            DeathInfo.thLastName = Master.Death_Marriage_LN__c;
            DeathInfo.deathDocumentNo = Master.Death_Marriage_Doc_No__c;
            DeathInfo.deathDocumentIssueLocation = Master.Death_Marriage_Doc_Issue_Location__c;
            DeathInfo.deathDocumentIssueProvince = Master.Death_Marriage_Doc_Issue_Province__c;
            DeathInfo.deathDocumentIssueDate = Master.Death_Marriage_Doc_Issue_Date__c;
            if(string.isNotBlank(Master.Death_Marriage_Doc_No__c)) {
                DeathInfo.isEditable = false;
                Application.DeathInfo.isDeathWife = true;
            }
            else {
                DeathInfo.isEditable = true;  
            }
            Application.DeathInfo.DeathInfos.add(DeathInfo);
        //}
        
        //Death Father
        DeathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
        //if(string.isNotBlank(Master.Death_Father_Doc_No__c)) {
            DeathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            DeathInfo.deathPerson.key = ESS_Enum.DeathPerson.Father.name();
            DeathInfo.deathPerson.value = 'Father';     
            DeathInfo.thNo = '01';
            DeathInfo.title = new ESS_Global.EnumValue('Title');
            if(Master.Death_Father_Title__c == '1') {
                DeathInfo.title.key = '1';
                DeathInfo.title.value = 'Mr';
            }
            else if(Master.Death_Father_Title__c == '5') {
                DeathInfo.title.key = '5';
                DeathInfo.title.value = 'Dr';
            }
            DeathInfo.thFirstName = Master.Death_Father_FN__c;
            DeathInfo.thLastName = Master.Death_Father_LN__c;
            DeathInfo.deathDocumentNo = Master.Death_Father_Doc_No__c;
            DeathInfo.deathDocumentIssueLocation = Master.Death_Father_Doc_Issue_Location__c;
            DeathInfo.deathDocumentIssueProvince = Master.Death_Father_Doc_Issue_Province__c;
            DeathInfo.deathDocumentIssueDate = Master.Death_Father_Doc_Issue_Date__c;
            if(string.isNotBlank(Master.Death_Father_Detail__c)) {
                DeathInfo.deathDetail = Master.Death_Father_Detail__c;
                DeathInfo.isEditable = false;
                //Application.DeathInfo.isDeathFather = true;
            }
            else {
                DeathInfo.isEditable = true;
            }
            Application.DeathInfo.DeathInfos.add(DeathInfo);
        //}
        
        //Death Mother 
        DeathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
        //if(string.isNotBlank(Master.Death_Mother_Doc_No__c)) {
            DeathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            DeathInfo.deathPerson.key = ESS_Enum.DeathPerson.Mother.name();
            DeathInfo.deathPerson.value = 'Mother';     
            DeathInfo.thNo = '01';
            DeathInfo.title = new ESS_Global.EnumValue('Title');
            if(Master.Death_Marriage_Title__c == '2') {
                DeathInfo.title.key = '2';
                DeathInfo.title.value = 'Mrs';
            }
            else if(Master.Death_Marriage_Title__c == '3') {
                DeathInfo.title.key = '3';
                DeathInfo.title.value = 'Miss';
            }
            else if(Master.Death_Marriage_Title__c == '4') {
                DeathInfo.title.key = '4';
                DeathInfo.title.value = 'Ms';
            }
            else if(Master.Death_Marriage_Title__c == '5') {
                DeathInfo.title.key = '5';
                DeathInfo.title.value = 'Dr';
            }
            DeathInfo.thFirstName = Master.Death_Mother_FN__c;
            DeathInfo.thLastName = Master.Death_Mother_LN__c;
            DeathInfo.deathDocumentNo = Master.Death_Mother_Doc_No__c;
            DeathInfo.deathDocumentIssueLocation = Master.Death_Mother_Doc_Issue_Location__c;
            DeathInfo.deathDocumentIssueProvince = Master.Death_Mother_Doc_Issue_Province__c;
            DeathInfo.deathDocumentIssueDate = Master.Death_Mother_Doc_Issue_Date__c;
            if(string.isNotBlank(Master.Death_Mother_Detail__c)) {
                DeathInfo.deathDetail = Master.Death_Mother_Detail__c;
                DeathInfo.isEditable = false;
                //Application.DeathInfo.isDeathMother = true;
            }
            else {
                DeathInfo.isEditable = true;
            }
            Application.DeathInfo.DeathInfos.add(DeathInfo);
        //}
        
        //Death Child
        if(Master.Death_Child_JSON__c != null && string.isNotBlank(Master.Death_Child_JSON__c)) {
            List<ESS_EmployeeBasic_DTO.DeathInfoDTO> deathChilds = DeserializeDeathChildJSON(Master.Death_Child_JSON__c);
            if(deathChilds.size() > 0) {
                
                for(ESS_EmployeeBasic_DTO.DeathInfoDTO deathChild : deathChilds) {
                    DeathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
                    
                    DeathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
                    DeathInfo.deathPerson.key = ESS_Enum.DeathPerson.Child.name();
                    DeathInfo.deathPerson.value = 'Child';     
                    DeathInfo.thNo = deathChild.thNo;
                    DeathInfo.status = deathChild.status;
                    DeathInfo.isEditable = deathChild.isEditable;
                    DeathInfo.thFirstName = deathChild.thFirstName;
                    DeathInfo.thLastName = deathChild.thLastName;
                    DeathInfo.deathDocumentNo = deathChild.deathDocumentNo;
                    DeathInfo.deathDocumentIssueLocation = deathChild.deathDocumentIssueLocation;
                    DeathInfo.deathDocumentIssueProvince = deathChild.deathDocumentIssueProvince;
                    DeathInfo.deathDocumentIssueDate = deathChild.deathDocumentIssueDate;
                    if(string.isNotBlank(deathChild.deathDocumentNo)) {
                        DeathInfo.isEditable = false;
                    }
                    else {
                        DeathInfo.isEditable = true;  
                    }
                    Application.DeathInfo.DeathInfos.add(DeathInfo);
                   
                }
            }
        }
        
        //Education
        Application.EducationInfos = new List<ESS_EmployeeBasic_DTO.EducationInfoDTO>();
        if(Master.Education_JSON__c != null && string.isNotBlank(Master.Education_JSON__c)) {
        	
            string educationJSON = CustomDeserializer.handleDeserialize(Master.Education_JSON__c);
            Application.EducationInfos = DeserializeEducationJSON(educationJSON);
            
            if(Application.EducationInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.EducationInfoDTO Education : Application.EducationInfos) {
                    Education.enEducationalCountry = GetCountryLabel(Education.enEducationalCountry);
                    Education.enEducationalLevel = GetEducationLevelLabel(Education.enEducationalLevel);
                    Education.enEducationalName = GetDegreeLabel(Education.enEducationalName);
                    Education.enEducationalField = GetFieldOfStudyLabel(Education.enEducationalField);
                    Education.enEducationalInstitution = GetInstitutionLabel(Education.enEducationalInstitution);
                    Education.isChange = false;
                }
            }
        }
        
        //License
        Application.LicenseInfos = new List<ESS_EmployeeBasic_DTO.LicenseInfoDTO>();
        ESS_EmployeeBasic_DTO.LicenseInfoDTO LicenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
        LicenseInfo.isChange = false;
        LicenseInfo.isEditable = true;
        LicenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
        LicenseInfo.licenseType.key = ESS_Enum.LicenseType.Citizen.name();
        LicenseInfo.licenseType.value = 'Citizen';
        LicenseInfo.citizenId = Master.License_Citizen_Id__c;
        LicenseInfo.issueDate = Master.License_Citizen_Issue_Date__c;
        LicenseInfo.expireDate = Master.License_Citizen_Expire_Date__c;
        LicenseInfo.issuedProvince = Master.License_Citizen_Issue_Province__c;
        Application.LicenseInfos.add(LicenseInfo);
        LicenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
        LicenseInfo.isChange = false;
        LicenseInfo.isEditable = true;
        LicenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
        LicenseInfo.licenseType.key = ESS_Enum.LicenseType.Professional.name();
        LicenseInfo.licenseType.value = 'Professional';
        LicenseInfo.licenseNo = Master.License_Professional_Doc_No__c;
        LicenseInfo.licenseLevel = Master.License_Professional_Doc_Level__c;
        LicenseInfo.engineeringBranch = Master.License_Professional_Engineer__c;
        LicenseInfo.issueDate = Master.License_Professional_Doc_Issue_Date__c;
        LicenseInfo.expireDate = Master.License_Professional_Doc_Expire_Date__c;
        Application.LicenseInfos.add(LicenseInfo);
        
        //Address
        Application.AddressInfos = new List<ESS_EmployeeBasic_DTO.AddressInfoDTO>();
        ESS_EmployeeBasic_DTO.AddressInfoDTO AddressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
        AddressInfo.isChange = false;
        AddressInfo.isEditable = true;
        AddressInfo.addressType = new ESS_Global.EnumValue('AddressType');
        AddressInfo.addressType.key = ESS_Enum.AddressType.HouseRegistration.name();
        AddressInfo.addressType.value = 'HouseRegistration';
        AddressInfo.thHouseNo = Master.Address_TH_House_No__c;
        AddressInfo.thMooVillageSoiRoad = Master.Address_TH_Moo_Village_Soi_Road__c;
        AddressInfo.thSubDistrictDistrict = Master.Address_TH_SubDistrict_District__c;
        AddressInfo.thProvince = Master.Address_TH_Province__c;
        AddressInfo.thPostalCode = Master.Address_TH_Postal_Code__c;
        AddressInfo.thTelephoneNo = Master.Address_TH_Telephone_No__c;
        AddressInfo.enHouseNo = Master.Address_EN_House_No__c;
        AddressInfo.enMooVillageSoiRoad = Master.Address_EN_Moo_Village_Soi_Road__c;
        AddressInfo.enSubDistrictDistrict = Master.Address_EN_SubDistrict_District__c;
        AddressInfo.enProvince = Master.Address_EN_Province__c;
        AddressInfo.enPostalCode = Master.Address_EN_Postal_Code__c;
        AddressInfo.enTelephoneNo = Master.Address_EN_Telephone_No__c;
        Application.AddressInfos.add(AddressInfo);
        
        AddressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
        AddressInfo.isChange = false;
        AddressInfo.isEditable = true;
        AddressInfo.addressType = new ESS_Global.EnumValue('AddressType');
        AddressInfo.addressType.key = ESS_Enum.AddressType.Current.name();
        AddressInfo.addressType.value = 'Current';
        AddressInfo.thHouseNo = Master.Address_TH_Current_House_No__c;
        AddressInfo.thMooVillageSoiRoad = Master.Address_TH_Current_Moo_Village_Soi_Road__c;
        AddressInfo.thSubDistrictDistrict = Master.Address_TH_Current_SubDistrict_District__c;
        AddressInfo.thProvince = Master.Address_TH_Current_Province__c;
        AddressInfo.thPostalCode = Master.Address_TH_Current_Postal_Code__c;
        AddressInfo.thTelephoneNo = Master.Address_TH_Current_Telephone_No__c;
        AddressInfo.enHouseNo = Master.Address_EN_Current_House_No__c;
        AddressInfo.enMooVillageSoiRoad = Master.Address_EN_Current_Moo_Village_Soi_Road__c;
        AddressInfo.enSubDistrictDistrict = Master.Address_EN_Current_SubDistrict_District__c;
        AddressInfo.enProvince = Master.Address_EN_Current_Province__c;
        AddressInfo.enPostalCode = Master.Address_EN_Current_Postal_Code__c;
        AddressInfo.enTelephoneNo = Master.Address_EN_Current_Telephone_No__c;
        Application.AddressInfos.add(AddressInfo);
        
        //ContactPerson
        Application.ContactPersonInfos = new List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO>();
        if(Master.Contact_Person_JSON__c != null && string.isNotBlank(Master.Contact_Person_JSON__c)) {
        	Application.ContactPersonInfos = DeserializeContactPersonJSON(Master.Contact_Person_JSON__c);
            if(Application.ContactPersonInfos.size() > 0) {
                for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPerson : Application.ContactPersonInfos) {
                    ContactPerson.isChange = false;
                }
                
                //Combine Contact Address
                for(ESS_EmployeeBasic_DTO.ContactPersonInfoDTO ContactPersonInfo : Application.ContactPersonInfos) {
                    if(ContactPersonInfo.isChange) {
                        ContactPersonInfo.thMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.thMoo, ContactPersonInfo.thVillageName, ContactPersonInfo.thSoi, ContactPersonInfo.thRoad);
                        ContactPersonInfo.thDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.thSubDistrict, ContactPersonInfo.thDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                        
                        ContactPersonInfo.enMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.enMoo, ContactPersonInfo.enVillageName, ContactPersonInfo.enSoi, ContactPersonInfo.enRoad);
                        ContactPersonInfo.enDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.enSubDistrict, ContactPersonInfo.enDistrict, ContactPersonInfo.thProvince, ContactPersonInfo.enProvince);
                        
                        ContactPersonInfo.newTHMooVillageSoiRoad = ConvertAddressTH(ContactPersonInfo.newTHMoo, ContactPersonInfo.newTHVillageName, ContactPersonInfo.newTHSoi, ContactPersonInfo.newTHRoad);
                        ContactPersonInfo.newTHDistrictSubDistrict = ConvertDistrictTH(ContactPersonInfo.newTHSubDistrict, ContactPersonInfo.newTHDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                        
                        ContactPersonInfo.newENMooVillageSoiRoad = ConvertAddressEN(ContactPersonInfo.newENMoo, ContactPersonInfo.newENVillageName, ContactPersonInfo.newENSoi, ContactPersonInfo.newENRoad);
                        ContactPersonInfo.newENDistrictSubDistrict = ConvertDistrictEN(ContactPersonInfo.newENSubDistrict, ContactPersonInfo.newENDistrict, ContactPersonInfo.newTHProvince, ContactPersonInfo.newENProvince);
                    }
                }
            }
        }
        
        //Tax
        Application.TaxInfo = new ESS_EmployeeBasic_DTO.TaxInfoDTO();
        Application.TaxInfo.isChange = false;
        Application.TaxInfo.isEditable = true;
        Application.TaxInfo.name = Master.Name_Emp_TH_Title_FN_LN__c;
        Application.TaxInfo.citizenId = Master.License_Citizen_Id__c;

        Application.TaxInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
        if(Master.Tax_Marriage_Status__c == '0') {
            Application.TaxInfo.marriedStatus.key = ESS_Enum.MarriedStatus.Single.name();
            Application.TaxInfo.marriedStatus.value = 'Single';
        }
        else if(Master.Tax_Marriage_Status__c == '1') {
            Application.TaxInfo.marriedStatus.key = ESS_Enum.MarriedStatus.Married.name();
            Application.TaxInfo.marriedStatus.value = 'Married';
        }
        
        Application.TaxInfo.marriedPersonEarnIncome = new ESS_Global.EnumValue('MarriedEarnIncome'); 
        if(Master.Tax_Marriage_Person_Earn_Income__c == '2') {
            Application.TaxInfo.marriedPersonEarnIncome.key = ESS_Enum.MarriedEarnIncome.MarriedEarnIncome.name();
            Application.TaxInfo.marriedPersonEarnIncome.value = 'คู่สมรสมีเงินได้';
        }
        else if(Master.Tax_Marriage_Person_Earn_Income__c == '1') {
            Application.TaxInfo.marriedPersonEarnIncome.key = ESS_Enum.MarriedEarnIncome.MarriedNotEarnIncome.name();
            Application.TaxInfo.marriedPersonEarnIncome.value = 'คู่สมรสไม่มีเงินได้';
        }
        
		Application.TaxInfo.childCount = Integer.ValueOf(Master.Tax_Child_Count__c);
        Application.TaxInfo.childCountTotal = Integer.ValueOf(Master.Tax_Total_Child_Count__c);
        Application.TaxInfo.selfLifeInsurancePaidAmount = Master.Tax_Self_Life_Insurance_Paid_Amount__c;
        Application.TaxInfo.marriedLifeInsurancePaidAmount = Master.Tax_Married_Life_Insurance_Paid_Amount__c;
        Application.TaxInfo.selfFatherHealthInsurancePaidAmount = Master.Tax_Self_Father_Insurance_Paid_Amount__c;
        Application.TaxInfo.selfMotherHealthInsurancePaidAmount = Master.Tax_Self_Mother_Insurance_Paid_Amount__c;
        Application.TaxInfo.marriedFatherHealthInsurancePaidAmount = Master.Tax_Married_Father_Insurance_Paid_Amount__c;
        Application.TaxInfo.marriedMotherHealthInsurancePaidAmount = Master.Tax_Married_Mother_Insurance_Paid_Amount__c;
        Application.TaxInfo.interestOnLoanForHouseAmount = Master.Tax_Interest_On_Loan_For_House_Amount__c;
        Application.TaxInfo.incomeFromRMFAmount = Master.Tax_Income_From_RMF_Amount__c;
        Application.TaxInfo.incomeFromSSFAmount = Master.Tax_Income_From_SSF_Amount__c;
        Application.TaxInfo.selfTaxDeductionFatherAmount = Master.Tax_Self_Deduction_Father_Amount__c;
        Application.TaxInfo.selfTaxDeductionMotherAmount = Master.Tax_Self_Deduction_Mother_Amount__c;
        Application.TaxInfo.marriedTaxDeductionFatherAmount = Master.Tax_Married_Deduction_Father_Amount__c;
        Application.TaxInfo.marriedTaxDeductionMotherAmount = Master.Tax_Married_Deduction_Mother_Amount__c;
        Application.TaxInfo.donationForCharityAmount = Master.Tax_Donation_For_Charity_Amount__c;
        Application.TaxInfo.sponsorAmount = Master.Tax_Sponsor_Amount__c;
        Application.TaxInfo.donationForEducationAmount = Master.Tax_Donation_For_Education_Amount__c;
        Application.TaxInfo.annuityInterestAmount = Master.Tax_Annuity_Interest_Amount__c;
        Application.TaxInfo.firstHouseExcludeTaxAmount = Master.Tax_First_House_Exclude_Tax_Amount__c;
        Application.TaxInfo.pregnancyCareAmount = Master.Tax_Pregnancy_Care_Amount__c;
        
        return Application;
        
    }
    
    @TestVisible
    public static List<ESS_EmployeeBasic_DTO.ChildInfoDTO> DeserializeChildJSON(string childJSON) {
        List<ESS_EmployeeBasic_DTO.ChildInfoDTO> childDTOs = (List<ESS_EmployeeBasic_DTO.ChildInfoDTO>)JSON.deserialize(childJSON, List<ESS_EmployeeBasic_DTO.ChildInfoDTO>.class);
        return childDTOs;
    }
    
    @TestVisible
    private static List<ESS_EmployeeBasic_DTO.DeathInfoDTO> DeserializeDeathChildJSON(string deathChildJSON) {
        List<ESS_EmployeeBasic_DTO.DeathInfoDTO> deathChildDTOs = (List<ESS_EmployeeBasic_DTO.DeathInfoDTO>)JSON.deserialize(deathChildJSON, List<ESS_EmployeeBasic_DTO.DeathInfoDTO>.class);
        return deathChildDTOs;
    }
    
    @TestVisible
    private static List<ESS_EmployeeBasic_DTO.EducationInfoDTO> DeserializeEducationJSON(string educationJSON) {
        List<ESS_EmployeeBasic_DTO.EducationInfoDTO> educationDTOs = (List<ESS_EmployeeBasic_DTO.EducationInfoDTO>)JSON.deserialize(educationJSON, List<ESS_EmployeeBasic_DTO.EducationInfoDTO>.class);
        return educationDTOs;
    }
    
    @TestVisible
    private static List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO> DeserializeContactPersonJSON(string contactPersonJSON) {
        List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO> contactPersonDTOs = (List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO>)JSON.deserialize(contactPersonJSON, List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO>.class);
        return contactPersonDTOs;
    }
    
    private static boolean checkCanEdit(string status) {
        boolean canEdit = false;
        if(status == String.ValueOf(ESS_Enum.ApplicationStatus.Draft)) {
            canEdit = true;
        }
        return canEdit;
    }
    
    private static boolean checkCanSubmit(string status) {
        boolean canSubmit = false;
        if(status == String.ValueOf(ESS_Enum.ApplicationStatus.Draft)) {
            canSubmit = true;
        }
        return canSubmit;
    }
    
    private static boolean checkCanCancel(string status) {
        boolean canSubmit = false;
        if(status == String.ValueOf(ESS_Enum.ApplicationStatus.Submitted)) {
            canSubmit = true;
        }
        return canSubmit;
    }
    
    private static boolean checkCanVerify(string status, datetime verifyDate) {
        
        boolean canVerify = false;
        if(status == String.ValueOf(ESS_Enum.ApplicationStatus.Submitted) && verifyDate == null && isAdmin) {
            canVerify = true;
        }
        return canVerify;
    }
    
    private static string assignToAdmin() {
        
        string AdminUserId;
        
        //Find from Group ESS Admin
        Group ESSAdminGroup = [select id, developername from Group where developername =: 'ESS_Personel_Admin'];
        List<GroupMember> AdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ESSAdminGroup.Id];
        
        if(!Test.isRunningTest()) {
            if(AdminUsers.size() > 0) {
                for(GroupMember ESSAdmin : AdminUsers) {
                    AdminUserId = ESSAdmin.userorgroupid;
                }
            }
        }
        
        return AdminUserId;
        
    }
    
    @RemoteAction
    public static List<string> GetCountries() {
        
        List<string> countries = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Country__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            countries.add(objPickList.getLabel());
        }
        return countries;
    }
    
    public static string GetCountryAPI(string label) {
        string countryAPI = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Country__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getLabel() == label) {
                countryAPI = objPickList.getValue();
            }
        }
        return countryAPI;
    }
    
    public static string GetCountryLabel(string value) {
        string countryLabel = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Country__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getValue() == value) {
                countryLabel = objPickList.getLabel();
            }
        }
        return countryLabel;
    }
    
    @RemoteAction
    public static List<string> GetDegrees() {
        List<string> degrees = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Degree__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            degrees.add(objPickList.getLabel());
        }
        return degrees;
    }
    
    public static string GetDegreeAPI(string label) {
        string degreeAPI = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Degree__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getLabel() == label) {
                degreeAPI = objPickList.getValue();
            }
        }
        return degreeAPI;
    }
    
    public static string GetDegreeLabel(string value) {
        string degreeLabel = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Degree__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getValue() == value) {
                degreeLabel = objPickList.getLabel();
            }
        }
        return degreeLabel;
    }
    
    @RemoteAction
    public static List<string> GetEducationLevels() {
        List<string> educationLevels = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Education_Level__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            educationLevels.add(objPickList.getLabel());
        }
        return educationLevels;
    }
    
    public static string GetEducationLevelAPI(string label) {
        string educationLevel = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Education_Level__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getLabel() == label) {
                educationLevel = objPickList.getValue();
            }
        }
        return educationLevel;
    }
    
    public static string GetEducationLevelLabel(string value) {
        string levelLabel = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Education_Level__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getValue() == value) {
                levelLabel = objPickList.getLabel();
            }
        }
        return levelLabel;
    }
    
    @RemoteAction
    public static List<string> GetFieldOfStudies() {
        
        List<string> fieldOfStudies = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Field_of_Study__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            fieldOfStudies.add(objPickList.getLabel());
        }
        return fieldOfStudies;
    }
    
    public static string GetFieldOfStudyAPI(string label) {
        string fieldOfStudy = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Field_of_Study__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getLabel() == label) {
                fieldOfStudy = objPickList.getValue();
            }
        }
        return fieldOfStudy;
    }
    
    public static string GetFieldOfStudyLabel(string value) {
        string fieldLabel = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Field_of_Study__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getValue() == value) {
                fieldLabel = objPickList.getLabel();
            }
        }
        return fieldLabel;
    }
    
    @RemoteAction
    public static List<string> GetInstitutions() {
        List<string> institutions = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Institution__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            institutions.add(objPickList.getLabel());
        }
        return institutions;
    }
    
    public static string GetInstitutionAPI(string label) {
        string institution = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Institution__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getLabel() == label) {
                institution = objPickList.getValue();
            }
        }
        return institution;
    }
    
    public static string GetInstitutionLabel(string value) {
        string institutionLabel = '';
        Schema.DescribeFieldResult objFieldDescribe = ESS_Application__c.Institution__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            if(objPickList.getValue() == value) {
                institutionLabel = objPickList.getLabel();
            }
        }
        return institutionLabel;
    }
    
    private static string checkEnumKey(ESS_Global.EnumValue enumValue) {
        string returnValue = '';
        if(enumValue != null) {
            returnValue = enumValue.key;
        }
        
        return returnValue;
    }
    
    private static string checkEnumValue(ESS_Global.EnumValue enumValue) {
        string returnValue = '';
        if(enumValue != null) {
            returnValue = enumValue.value;
        }
        
        return returnValue;
    }
    
    @TestVisible
    private static string assignSFTitle(string title) {
        string sfTitle;
        
        if(title == '1') {
            sfTitle = '1';
        } 
        else if(title == '2') {
            sfTitle = '2';
        }
        else if(title == '3') {
            sfTitle = '3';
        }  
        else if(title == '4') {
            sfTitle = '4';
        } 
        else if(title == '5') {
            sfTitle = '5';
        }
        
        return sfTitle;
    }
    
    @TestVisible
    private static string assignTHTitle(string title) {
        string thTitle;
        
        if(title == String.ValueOf(ESS_Enum.Title.Mr) || title == '1') {
            thTitle = 'นาย';
        } 
        else if(title == String.ValueOf(ESS_Enum.Title.Mrs) || title == '2') {
            thTitle = 'นาง';
        }
        else if(title == String.ValueOf(ESS_Enum.Title.Miss) || title == '3') {
            thTitle = 'น.ส.';
        }  
        else if(title == String.ValueOf(ESS_Enum.Title.Ms) || title == '4') {
            thTitle = 'น.ส.';
        } 
        else if(title == String.ValueOf(ESS_Enum.Title.Dr) || title == '5') {
            thTitle = 'ดร';
        }
        
        return thTitle;
    }
    
    public static string GetCurrentYear() {
        
        Date todayDate = date.today();
        String userLocale = UserInfo.getLocale();
        integer currentYear = 0;
        
        boolean isThaiLocale = userLocale.contains('th');
        if(isThaiLocale && todayDate.year() > 2500) {
            currentYear = todayDate.year() - 543;
        }
        else {
            currentYear = todayDate.year();
        }
        
        return String.ValueOf(currentYear);
        
    }
    
    public static string GetCurrentMonth() {
    
        DateTime todayDT = datetime.now();
        string month = todayDT.addMonths(-2).format('MM');
        return month;
        
    }
    
    public static string generateDocumentUrl(string fileId) {
        
        string finalURL;
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm();
        
        finalURL = URL + '/servlet/servlet.FileDownload?file=' + fileId + '&operationContext=S1';
        return finalURL;
        
    }
    
    public static boolean showOnlyMarriedStatus(string employeeId) {
        
        ESS_Master_Employee__c Master = [select id, employee_id__c, status_marriage_status__c from ESS_Master_Employee__c where data__c = 'IN' AND employee_id__c =: employeeId];
        
        boolean isShow = false;
        
        if(string.isNotBlank(Master.Status_Marriage_Status__c)) {
            if(Master.Status_Marriage_Status__c == '0' || Master.Status_Marriage_Status__c == '2' || Master.Status_Marriage_Status__c == '3') {
                isShow = true;
            }
        }
        
        return isShow;
    }
    
    public static string ConvertAddressTH(string moo, string mooban, string soi, string road) {
        string addressTH = '';
        if(string.isNotBlank(moo)) {
            addressTH += 'หมู่ที่ ' + moo + ' ';
        }
        if(string.isNotBlank(mooban)) {
            addressTH += 'หมู่บ้าน' + mooban + ' ';
        }
        if(string.isNotBlank(soi)) {
            addressTH += 'ซอย' + soi + ' ';
        }
        if(string.isNotBlank(road)) {
            addressTH += 'ถนน' + road;
        }
        return addressTH;
    }
    
    public static string ConvertDistrictTH(string subDistrict, string district, string provinceTH, string provinceEN) {
        string districtTH = '';
        boolean isBKKDistrict = CheckBKKDistrict(provinceTH, provinceEN);
        if(isBKKDistrict) {
            if(string.isNotBlank(subDistrict)) {
                districtTH += 'แขวง' + subDistrict + ' ';
            }
            if(string.isNotBlank(district)) {
                districtTH += 'เขต' + district;
            }
        }
        else {
            if(string.isNotBlank(subDistrict)) {
                districtTH += 'ตำบล' + subDistrict + ' ';
            }
            if(string.isNotBlank(district)) {
                districtTH += 'อำเภอ' + district;
            }
        }
        return districtTH;
    }
    
    public static string ConvertAddressEN(string moo, string mooban, string soi, string road) {
        string addressEN = '';
        if(string.isNotBlank(moo)) {
            addressEN += 'Moo ' + moo + ' ';
        }
        if(string.isNotBlank(mooban)) {
            addressEN += 'Mooban ' + mooban + ' ';
        }
        if(string.isNotBlank(soi)) {
            addressEN += 'Soi ' + soi + ' ';
        }
        if(string.isNotBlank(road)) {
            addressEN += road + ' Rd.';
        }
        return addressEN;
    }
    
    public static string ConvertDistrictEN(string subDistrict, string district, string provinceTH, string provinceEN) {
        string districtEN = '';
        boolean isBKKDistrict = CheckBKKDistrict(provinceTH, provinceEN);
        if(isBKKDistrict) {
            if(string.isNotBlank(subDistrict)) {
                districtEN += subDistrict;
            }
            if(string.isNotBlank(district)) {
                districtEN += ', ' +  district;
            }
        }
        else {
            if(string.isNotBlank(subDistrict)) {
                districtEN += 'T.' + subDistrict + ' ';
            }
            if(string.isNotBlank(district)) {
                districtEN += 'A.' + district;
            }
        }
        
        return districtEN;
    }
    
    public static boolean CheckBKKDistrict(string provinceTH, string provinceEN) {
        boolean isDistrict = false;
        List<string> provinces = new List<string> {'กรุงเทพ','กรุงเทพฯ','กรุงเทพมหานคร','กทม','กทม.','Bangkok','BKK','bkk','BKK.','bkk.'};
        isDistrict = provinces.contains(provinceTH) || provinces.contains(provinceEN);
        return isDistrict;
    }
    
    public static string ApplicationCurrentStatus(string recordId) {
        ESS_Application__c Application = [select id, status__c from ESS_Application__c where Id = :recordId];
        return Application.Status__c;
    }
    
    public static string ApplicationSubjectType(string recordId) {
        ESS_Application__c Application = [select id, subject_type__c from ESS_Application__c where Id = :recordId];
        return Application.subject_type__c;
    }
        
    public class ApplicationSearchCriteria {
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        //enum ApplicationStatus
        @RemoteAction
        public string currentStatus {get;set;}
        @RemoteAction
        public boolean searchAll {get;set;}
        @RemoteAction
        public boolean searchName {get;set;}
        @RemoteAction
        public boolean searchStatus {get;set;}
        @RemoteAction
        public boolean searchChild {get;set;}
        @RemoteAction
        public boolean searchDeath {get;set;}
        @RemoteAction
        public boolean searchEducation {get;set;}
        @RemoteAction
        public boolean searchLicense {get;set;}
        @RemoteAction
        public boolean searchAddress {get;set;}
        @RemoteAction
        public boolean searchContactPerson {get;set;}
        @RemoteAction
        public boolean searchTax {get;set;}
        @RemoteAction
        public datetime startCreatedDate {get;set;}
        @RemoteAction
        public datetime endCreatedDate {get;set;}
        @RemoteAction
        public datetime startSubmittedDate {get;set;}
        @RemoteAction
        public datetime endSubmittedDate {get;set;}
        @RemoteAction
        public datetime startVerifiedDate {get;set;}
        @RemoteAction
        public datetime endVerifiedDate {get;set;}
        @RemoteAction
        public datetime startCompletedDate {get;set;}
        @RemoteAction
        public datetime endCompletedDate {get;set;}
    }
    
}