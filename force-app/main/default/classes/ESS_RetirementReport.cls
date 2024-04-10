/* Author Softever */
global with sharing class ESS_RetirementReport {

    private static List<ESS_RetirementReport_DTO.RetirementTableDTO> retirementTables;
    private static List<ESS_RetirementReport_DTO.RetirementGraphSeriesDTO> retirementGraphs;
    private static ESS_RetirementReport_DTO.RetirementGraphDTO retirementGraph;
    
    static {
    }
    
    //Retirement
    @RemoteAction
    public static List<ESS_RetirementReport_DTO.RetirementTableDTO> GetRetirementTables(RetirementSearchCriteria filter, 
        //documentNo, employeeId, employeeName, birthDate, age, selectedRetirementDate, defaultRetirementDate, retirementDate, sectionHead, departmentHead, currentStatus, createdDate, submittedDate, sectionHeadApprovedDate, departmentApprovedDate, uploadedToPersonalFolderDate, sentToSAPDate, completedDate, function, department, section, level
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) 
    {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isAdmin = ESS_PrivilegeHandler.checkRetirementAdminUser(userId);
            
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        retirementTables = new List<ESS_RetirementReport_DTO.RetirementTableDTO>();
            
        List<ESS_Retirement__c> Retirements = new List<ESS_Retirement__c>();
            
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
            			'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
            			'function__c, department__c, section__c, level__c, Section_Head_Id__c from ESS_Retirement__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
            			'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
            			'function__c, department__c, section__c, level__c, Section_Head_Id__c from ESS_Retirement__c where OwnerId != null';
        } 
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }   
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
        	string function = filter.function;
            query = query + ' AND function__c =: function';
        }
           
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
        	string department = filter.department;
            query = query + ' AND department__c =: department';
        }
           
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
        	string section = filter.section;
            query = query + ' AND section__c =: section';
        }
        
        //filter.level
        if(string.isNotEmpty(filter.level) && filter.level.toLowerCase() != 'all') {
        	string level = filter.level;
            query = query + ' AND level__c =: level';
        }
        
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name());
            statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            statuses.add(ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name());
            statuses.add(ESS_Enum.RetirementStatus.SendingToSAP.name());
            statuses.add(ESS_Enum.RetirementStatus.Completed.name());
            statuses.add(ESS_Enum.RetirementStatus.DefaultFromSystem.name());
            statuses.add(ESS_Enum.RetirementStatus.UploadFailed.name());
            isCheckStatus = true;
        }
        else {
            //filter.statusWaitingEmployeeSubmit
            if(filter.statusWaitingEmployeeSubmit) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForApprovalSectionHead
            if(filter.statusWaitingForApprovalSectionHead) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForDepartmentHead
            if(filter.statusWaitingForDepartmentHead) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForUploadPersonalFolder
            if(filter.statusWaitingForUploadPersonalFolder) {
            	statuses.add(ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name());
            	isCheckStatus = true;
            }
            //filter.statusSendingToSAP
            if(filter.statusSendingToSAP) {
            	statuses.add(ESS_Enum.RetirementStatus.SendingToSAP.name());
            	isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.RetirementStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.statusDefaultFromSystem
            if(filter.statusDefaultFromSystem) {
            	statuses.add(ESS_Enum.RetirementStatus.DefaultFromSystem.name());
            	isCheckStatus = true;
            }
            //filter.statusUploadFailed
            if(filter.statusUploadFailed) {
            	statuses.add(ESS_Enum.RetirementStatus.UploadFailed.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
        	query = query + ' AND status__c IN: statuses';
        }
        
        //filter.retirementAll
        List<string> retirementFilters = new List<string>();
        boolean isCheckRetirement = false;
        if(filter.retirementAll) {
            retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor55Years.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor60Years.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.EndOfMonth.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.EndOfYear.name());
            isCheckRetirement = true;
        }
        else {
            //filter.retirementExact55Years
            if(filter.retirementExact55Years) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor55Years.name());
            	isCheckRetirement = true;
            }
            //filter.retirementExact60Years
            if(filter.retirementExact60Years) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor60Years.name());
            	isCheckRetirement = true;
            }
            //filter.retirementEndOfMonth
            if(filter.retirementEndOfMonth) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.EndOfMonth.name());
            	isCheckRetirement = true;
            }
            //filter.retirementEndOfYear
            if(filter.retirementEndOfYear) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.EndOfYear.name());
            	isCheckRetirement = true;
            }
        }
        
        if(isCheckRetirement) {
        	query = query + ' AND retirement_choice__c IN: retirementFilters';
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
            datetime startCreatedDate = filter.startCreatedDate;
        	query = query + ' AND (createddate >=: startCreatedDate)';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
            datetime endCreatedDate = filter.endCreatedDate;
       		query = query + ' AND (createddate <=: endCreatedDate)';
        }
        
        //filter.startEmployeeSubmittedDate
        if(filter.startEmployeeSubmittedDate != null) {
            date startEmployeeSubmittedDate = filter.startEmployeeSubmittedDate;
        	query = query + ' AND (submitted_date__c >=: startEmployeeSubmittedDate)';
        }
        
        //filter.endEmployeeSubmittedDate
        if(filter.endEmployeeSubmittedDate != null) {
            date endEmployeeSubmittedDate = filter.endEmployeeSubmittedDate;
        	query = query + ' AND (submitted_date__c <=: endEmployeeSubmittedDate)';
        }
        
        //filter.startSectionHeadApprovedDate
        if(filter.startSectionHeadApprovedDate != null) {
            date startSectionHeadApprovedDate = filter.startSectionHeadApprovedDate;
        	query = query + ' AND (section_head_approve_date__c >=: startSectionHeadApprovedDate)';
        }
        
        //filter.endSectionHeadApprovedDate
        if(filter.endSectionHeadApprovedDate != null) {
            date endSectionHeadApprovedDate = filter.endSectionHeadApprovedDate;
        	query = query + ' AND (section_head_approve_date__c <=: endSectionHeadApprovedDate)';
        }
                
        //filter.startDepartmentHeadApprovedDate
        if(filter.startDepartmentHeadApprovedDate != null) {
            date startDepartmentHeadApprovedDate = filter.startDepartmentHeadApprovedDate;
        	query = query + ' AND (department_head_approve_date__c >=: startDepartmentHeadApprovedDate)';
        }
        
        //filter.endDepartmentHeadApprovedDate
        if(filter.endDepartmentHeadApprovedDate != null) {
            date endDepartmentHeadApprovedDate = filter.endDepartmentHeadApprovedDate;
        	query = query + ' AND (department_head_approve_date__c <=: endDepartmentHeadApprovedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = filter.startCompletedDate;
        	query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = filter.endCompletedDate;
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
        else if(sortByParam.sortBy == 'employeeId') {
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
        else if(sortByParam.sortBy == 'birthDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by date_of_birth__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by date_of_birth__c desc';
            }
        }
        else if(sortByParam.sortBy == 'age') {
        	if(sortByParam.ascending) {
       	    	query += ' order by age__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by age__c desc';
            }
        }
        else if(sortByParam.sortBy == 'selectedRetirementDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by retirement_choice__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by retirement_choice__c desc';
            }
        }
        else if(sortByParam.sortBy == 'defaultRetirementDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by default_retirement_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by default_retirement_date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'retirementDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by retirement_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by retirement_date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'sectionHead') {
        	if(sortByParam.ascending) {
       	    	query += ' order by section_head__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by section_head__c desc';
            }
        }
        else if(sortByParam.sortBy == 'departmentHead') {
        	if(sortByParam.ascending) {
       	    	query += ' order by department_head__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by department_head__c desc';
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
        else if(sortByParam.sortBy == 'sectionHeadApprovedDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by section_head_approve_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by section_head_approve_date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'departmentApprovedDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by department_head_approve_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by department_head_approve_date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'uploadedToPersonalFolderDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by upload_to_personal_folder_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by upload_to_personal_folder_date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'sentToSAPDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by sending_to_sap_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by sending_to_sap_date__c desc';
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
        else if(sortByParam.sortBy == 'function') {
        	if(sortByParam.ascending) {
       	    	query += ' order by function__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by function__c desc';
            }
        }
        else if(sortByParam.sortBy == 'department') {
        	if(sortByParam.ascending) {
       	    	query += ' order by department__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by department__c desc';
            }
        }
        else if(sortByParam.sortBy == 'section') {
        	if(sortByParam.ascending) {
       	    	query += ' order by section__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by section__c desc';
            }
        }
        else if(sortByParam.sortBy == 'level') {
        	if(sortByParam.ascending) {
       	    	query += ' order by level__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by level__c desc';
            }
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
        
        Retirements = database.query(query);
        
        if(Retirements.size() > 0) {
            for(ESS_Retirement__c Retirement : Retirements) {
                ESS_RetirementReport_DTO.RetirementTableDTO RetirementTable = new ESS_RetirementReport_DTO.RetirementTableDTO();
                RetirementTable = assignToRetirementTableDTO(Retirement);
                if(string.isnotempty(RetirementTable.documentNo)) {
                    retirementTables.add(RetirementTable);
                }
            }                                        
        }        
        
        return retirementTables;
                                                                                     
    }
    
    @RemoteAction
    public static integer GetRetirementTableCount(RetirementSearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isAdmin = ESS_PrivilegeHandler.checkRetirementAdminUser(userId);
            
        List<ESS_Retirement__c> Retirements = new List<ESS_Retirement__c>();
                    
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
            			'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
            			'function__c, department__c, section__c, level__c, Section_Head_Id__c from ESS_Retirement__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
            			'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
            			'function__c, department__c, section__c, level__c, Section_Head_Id__c from ESS_Retirement__c where OwnerId != null';
        } 
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }   
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
        	string function = filter.function;
            query = query + ' AND function__c =: function';
        }
           
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
        	string department = filter.department;
            query = query + ' AND department__c =: department';
        }
           
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
        	string section = filter.section;
            query = query + ' AND section__c =: section';
        }
        
        //filter.level
        if(string.isNotEmpty(filter.level) && filter.level.toLowerCase() != 'all') {
        	string level = filter.level;
            query = query + ' AND level__c =: level';
        }
        
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name());
            statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            statuses.add(ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name());
            statuses.add(ESS_Enum.RetirementStatus.SendingToSAP.name());
            statuses.add(ESS_Enum.RetirementStatus.Completed.name());
            statuses.add(ESS_Enum.RetirementStatus.DefaultFromSystem.name());
            statuses.add(ESS_Enum.RetirementStatus.UploadFailed.name());
            isCheckStatus = true;
        }
        else {
            //filter.statusWaitingEmployeeSubmit
            if(filter.statusWaitingEmployeeSubmit) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForApprovalSectionHead
            if(filter.statusWaitingForApprovalSectionHead) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForDepartmentHead
            if(filter.statusWaitingForDepartmentHead) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForUploadPersonalFolder
            if(filter.statusWaitingForUploadPersonalFolder) {
            	statuses.add(ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name());
            	isCheckStatus = true;
            }
            //filter.statusSendingToSAP
            if(filter.statusSendingToSAP) {
            	statuses.add(ESS_Enum.RetirementStatus.SendingToSAP.name());
            	isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.RetirementStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.statusDefaultFromSystem
            if(filter.statusDefaultFromSystem) {
            	statuses.add(ESS_Enum.RetirementStatus.DefaultFromSystem.name());
            	isCheckStatus = true;
            }
            //filter.statusUploadFailed
            if(filter.statusUploadFailed) {
            	statuses.add(ESS_Enum.RetirementStatus.UploadFailed.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
        	query = query + ' AND status__c IN: statuses';
        }
        
        //filter.retirementAll
        List<string> retirementFilters = new List<string>();
        boolean isCheckRetirement = false;
        if(filter.retirementAll) {
            retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor55Years.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor60Years.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.EndOfMonth.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.EndOfYear.name());
            isCheckRetirement = true;
        }
        else {
            //filter.retirementExact55Years
            if(filter.retirementExact55Years) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor55Years.name());
            	isCheckRetirement = true;
            }
            //filter.retirementExact60Years
            if(filter.retirementExact60Years) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor60Years.name());
            	isCheckRetirement = true;
            }
            //filter.retirementEndOfMonth
            if(filter.retirementEndOfMonth) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.EndOfMonth.name());
            	isCheckRetirement = true;
            }
            //filter.retirementEndOfYear
            if(filter.retirementEndOfYear) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.EndOfYear.name());
            	isCheckRetirement = true;
            }
        }
        
        if(isCheckRetirement) {
        	query = query + ' AND retirement_choice__c IN: retirementFilters';
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
            datetime startCreatedDate = filter.startCreatedDate;
        	query = query + ' AND (createddate >=: startCreatedDate)';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
            datetime endCreatedDate = filter.endCreatedDate;
       		query = query + ' AND (createddate <=: endCreatedDate)';
        }
        
        //filter.startEmployeeSubmittedDate
        if(filter.startEmployeeSubmittedDate != null) {
            date startEmployeeSubmittedDate = filter.startEmployeeSubmittedDate;
        	query = query + ' AND (submitted_date__c >=: startEmployeeSubmittedDate)';
        }
        
        //filter.endEmployeeSubmittedDate
        if(filter.endEmployeeSubmittedDate != null) {
            date endEmployeeSubmittedDate = filter.endEmployeeSubmittedDate;
        	query = query + ' AND (submitted_date__c <=: endEmployeeSubmittedDate)';
        }
        
        //filter.startSectionHeadApprovedDate
        if(filter.startSectionHeadApprovedDate != null) {
            date startSectionHeadApprovedDate = filter.startSectionHeadApprovedDate;
        	query = query + ' AND (section_head_approve_date__c >=: startSectionHeadApprovedDate)';
        }
        
        //filter.endSectionHeadApprovedDate
        if(filter.endSectionHeadApprovedDate != null) {
            date endSectionHeadApprovedDate = filter.endSectionHeadApprovedDate;
        	query = query + ' AND (section_head_approve_date__c <=: endSectionHeadApprovedDate)';
        }
        
        
        //filter.startDepartmentHeadApprovedDate
        if(filter.startDepartmentHeadApprovedDate != null) {
            date startDepartmentHeadApprovedDate = filter.startDepartmentHeadApprovedDate;
        	query = query + ' AND (department_head_approve_date__c >=: startDepartmentHeadApprovedDate)';
        }
        
        //filter.endDepartmentHeadApprovedDate
        if(filter.endDepartmentHeadApprovedDate != null) {
            date endDepartmentHeadApprovedDate = filter.endDepartmentHeadApprovedDate;
        	query = query + ' AND (department_head_approve_date__c <=: endDepartmentHeadApprovedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = filter.startCompletedDate;
        	query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = filter.endCompletedDate;
        	query = query + ' AND (completed_date__c <=: endCompletedDate)';
        }
        
		//Final query
		Retirements = Database.query(query); 
        
        integer totalSize = 0;

        if(Retirements.size() > 0) {
            for(ESS_Retirement__c Retirement : Retirements) {
                ESS_RetirementReport_DTO.RetirementTableDTO RetirementTable = new ESS_RetirementReport_DTO.RetirementTableDTO();
                RetirementTable = assignToRetirementTableDTO(Retirement);
                if(string.isnotempty(RetirementTable.documentNo)) {
                    totalSize++;
                }
            }
        }

        return totalSize;
        
    }
  
    @RemoteAction
    public static List<ESS_RetirementReport_DTO.RetirementGraphSeriesDTO> GetRetirementGraph(RetirementSearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkRetirementAdminUser(userId);
        
        retirementGraphs = new List<ESS_RetirementReport_DTO.RetirementGraphSeriesDTO>();
        
        List<ESS_Retirement__c> Retirements = new List<ESS_Retirement__c>();
            
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
            			'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
            			'function__c, department__c, section__c, level__c from ESS_Retirement__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
            			'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
            			'function__c, department__c, section__c, level__c from ESS_Retirement__c where OwnerId != null';
        } 
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }   
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
        	string function = filter.function;
            query = query + ' AND function__c =: function';
        }
           
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
        	string department = filter.department;
            query = query + ' AND department__c =: department';
        }
           
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
        	string section = filter.section;
            query = query + ' AND section__c =: section';
        }
        
        //filter.level
        if(string.isNotEmpty(filter.level) && filter.level.toLowerCase() != 'all') {
        	string level = filter.level;
            query = query + ' AND level__c =: level';
        }
        
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name());
            statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            statuses.add(ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name());
            statuses.add(ESS_Enum.RetirementStatus.SendingToSAP.name());
            statuses.add(ESS_Enum.RetirementStatus.Completed.name());
            statuses.add(ESS_Enum.RetirementStatus.DefaultFromSystem.name());
            statuses.add(ESS_Enum.RetirementStatus.UploadFailed.name());
            isCheckStatus = true;
        }
        else {
            //filter.statusWaitingEmployeeSubmit
            if(filter.statusWaitingEmployeeSubmit) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForApprovalSectionHead
            if(filter.statusWaitingForApprovalSectionHead) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForDepartmentHead
            if(filter.statusWaitingForDepartmentHead) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForUploadPersonalFolder
            if(filter.statusWaitingForUploadPersonalFolder) {
            	statuses.add(ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name());
            	isCheckStatus = true;
            }
            //filter.statusSendingToSAP
            if(filter.statusSendingToSAP) {
            	statuses.add(ESS_Enum.RetirementStatus.SendingToSAP.name());
            	isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.RetirementStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.statusDefaultFromSystem
            if(filter.statusDefaultFromSystem) {
            	statuses.add(ESS_Enum.RetirementStatus.DefaultFromSystem.name());
            	isCheckStatus = true;
            }
            //filter.statusUploadFailed
            if(filter.statusUploadFailed) {
            	statuses.add(ESS_Enum.RetirementStatus.UploadFailed.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
        	query = query + ' AND status__c IN: statuses';
        }
        
        //filter.retirementAll
        List<string> retirementFilters = new List<string>();
        boolean isCheckRetirement = false;
        if(filter.retirementAll) {
            retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor55Years.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor60Years.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.EndOfMonth.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.EndOfYear.name());
            isCheckRetirement = true;
        }
        else {
            //filter.retirementExact55Years
            if(filter.retirementExact55Years) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor55Years.name());
            	isCheckRetirement = true;
            }
            //filter.retirementExact60Years
            if(filter.retirementExact60Years) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor60Years.name());
            	isCheckRetirement = true;
            }
            //filter.retirementEndOfMonth
            if(filter.retirementEndOfMonth) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.EndOfMonth.name());
            	isCheckRetirement = true;
            }
            //filter.retirementEndOfYear
            if(filter.retirementEndOfYear) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.EndOfYear.name());
            	isCheckRetirement = true;
            }
        }
        
        if(isCheckRetirement) {
        	query = query + ' AND retirement_choice__c IN: retirementFilters';
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
            datetime startCreatedDate = filter.startCreatedDate;
        	query = query + ' AND (createddate >=: startCreatedDate)';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
            datetime endCreatedDate = filter.endCreatedDate;
       		query = query + ' AND (createddate <=: endCreatedDate)';
        }
        
        //filter.startEmployeeSubmittedDate
        if(filter.startEmployeeSubmittedDate != null) {
            date startEmployeeSubmittedDate = filter.startEmployeeSubmittedDate;
        	query = query + ' AND (submitted_date__c >=: startEmployeeSubmittedDate)';
        }
        
        //filter.endEmployeeSubmittedDate
        if(filter.endEmployeeSubmittedDate != null) {
            date endEmployeeSubmittedDate = filter.endEmployeeSubmittedDate;
        	query = query + ' AND (submitted_date__c <=: endEmployeeSubmittedDate)';
        }
        
        //filter.startSectionHeadApprovedDate
        if(filter.startSectionHeadApprovedDate != null) {
            date startSectionHeadApprovedDate = filter.startSectionHeadApprovedDate;
        	query = query + ' AND (section_head_approve_date__c >=: startSectionHeadApprovedDate)';
        }
        
        //filter.endSectionHeadApprovedDate
        if(filter.endSectionHeadApprovedDate != null) {
            date endSectionHeadApprovedDate = filter.endSectionHeadApprovedDate;
        	query = query + ' AND (section_head_approve_date__c <=: endSectionHeadApprovedDate)';
        }
        
        
        //filter.startDepartmentHeadApprovedDate
        if(filter.startDepartmentHeadApprovedDate != null) {
            date startDepartmentHeadApprovedDate = filter.startDepartmentHeadApprovedDate;
        	query = query + ' AND (department_head_approve_date__c >=: startDepartmentHeadApprovedDate)';
        }
        
        //filter.endDepartmentHeadApprovedDate
        if(filter.endDepartmentHeadApprovedDate != null) {
            date endDepartmentHeadApprovedDate = filter.endDepartmentHeadApprovedDate;
        	query = query + ' AND (department_head_approve_date__c <=: endDepartmentHeadApprovedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = filter.startCompletedDate;
        	query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = filter.endCompletedDate;
        	query = query + ' AND (completed_date__c <=: endCompletedDate)';
        }
        
		//Final query
		Retirements = Database.query(query); 
        
        if(Retirements.size() > 0) {
            
            ESS_RetirementReport_DTO.RetirementGraphSeriesDTO WaitingEmployeeSubmitGraph = new ESS_RetirementReport_DTO.RetirementGraphSeriesDTO();
            WaitingEmployeeSubmitGraph.name = 'Waiting Employee Submit';
            WaitingEmployeeSubmitGraph.y = 0;
            WaitingEmployeeSubmitGraph.color = '#5a9fbb';
            WaitingEmployeeSubmitGraph.amount = '';
            
            ESS_RetirementReport_DTO.RetirementGraphSeriesDTO WaitingSectionHeadApproveGraph = new ESS_RetirementReport_DTO.RetirementGraphSeriesDTO();
            WaitingSectionHeadApproveGraph.name = 'Waiting for Approval by Immediate Line / Section Head';
            WaitingSectionHeadApproveGraph.y = 0;
            WaitingSectionHeadApproveGraph.color = '#db89c7';
            WaitingSectionHeadApproveGraph.amount = '';
            
            ESS_RetirementReport_DTO.RetirementGraphSeriesDTO WaitingDepartmentApproveGraph = new ESS_RetirementReport_DTO.RetirementGraphSeriesDTO();
            WaitingDepartmentApproveGraph.name = 'Waiting for Approval by Department Head';
            WaitingDepartmentApproveGraph.y = 0;
            WaitingDepartmentApproveGraph.color = '#f0d276';
            WaitingDepartmentApproveGraph.amount = '';

            ESS_RetirementReport_DTO.RetirementGraphSeriesDTO WaitingForUploadGraph = new ESS_RetirementReport_DTO.RetirementGraphSeriesDTO();
            WaitingForUploadGraph.name = 'Waiting for upload to personal folder';
            WaitingForUploadGraph.y = 0;
            WaitingForUploadGraph.color = '#788bea';
            WaitingForUploadGraph.amount = '';

            ESS_RetirementReport_DTO.RetirementGraphSeriesDTO CompletedGraph = new ESS_RetirementReport_DTO.RetirementGraphSeriesDTO();
            CompletedGraph.name = 'Completed';
            CompletedGraph.y = 0;
            CompletedGraph.color = '#6cc6ad';
            CompletedGraph.amount = '';

            ESS_RetirementReport_DTO.RetirementGraphSeriesDTO DefaultGraph = new ESS_RetirementReport_DTO.RetirementGraphSeriesDTO();
            DefaultGraph.name = 'Default from system';
            DefaultGraph.y = 0;
            DefaultGraph.color = '#db706c';
            DefaultGraph.amount = '';

            ESS_RetirementReport_DTO.RetirementGraphSeriesDTO UploadFailedGraph = new ESS_RetirementReport_DTO.RetirementGraphSeriesDTO();
            UploadFailedGraph.name = 'Upload failed';
            UploadFailedGraph.y = 0;
            UploadFailedGraph.color = '#A5A5A5';
            UploadFailedGraph.amount = '';

            ESS_RetirementReport_DTO.RetirementGraphSeriesDTO SAPGraph = new ESS_RetirementReport_DTO.RetirementGraphSeriesDTO();
            SAPGraph.name = 'Sending to SAP';
            SAPGraph.y = 0;
            SAPGraph.color = '#9CC2E5';
            SAPGraph.amount = '';
                        
            integer total = 0;
            integer waitingEmployeeSubmitCount = 0;
            decimal waitingEmployeeSubmitPercent = 0;
            integer waitingSectionHeadApprovalCount = 0;
            decimal waitingSectionHeadApprovalPercent = 0;
            integer waitingDepartmentHeadApprovalCount = 0;
            decimal waitingDepartmentHeadApprovalPercent = 0;
            integer waitingUploadingToPersonalFolderCount = 0;
            decimal waitingUploadingToPersonalFolderPercent = 0;
            integer completedCount = 0;
            decimal completedPercent = 0;
            integer defaultFromSystemCount = 0;
            decimal defaultFromSystemPercent = 0;
            integer uploadFailedCount = 0;
            decimal uploadFailedPercent = 0;
            integer sapCount = 0;
            decimal sapPercent = 0;
            
            total = Retirements.size();
            
            for(ESS_Retirement__c Retirement : Retirements) {
                
                if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name()) {
                    waitingEmployeeSubmitCount++;
                }
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name()) {
                    waitingSectionHeadApprovalCount++;
                }
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()) {
                    waitingDepartmentHeadApprovalCount++;
                }
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name()) {
                    waitingUploadingToPersonalFolderCount++;
                }
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.Completed.name()) {
                    completedCount++;
                }
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.DefaultFromSystem.name()) {
                    defaultFromSystemCount++;
                }
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.UploadFailed.name()) {
                    uploadFailedCount++;
                }
                else if(Retirement.Status__c == ESS_Enum.RetirementStatus.SendingToSAP.name()) {
                    sapCount++;
                }
            }

            if(total > 0) {
                waitingEmployeeSubmitPercent = (waitingEmployeeSubmitCount * 100) / total;
                waitingSectionHeadApprovalPercent = (waitingSectionHeadApprovalCount * 100) / total;
                waitingDepartmentHeadApprovalPercent = (waitingDepartmentHeadApprovalCount * 100) / total;
                waitingUploadingToPersonalFolderPercent = (waitingUploadingToPersonalFolderCount * 100) / total;
                completedPercent = (completedCount * 100) / total;
                defaultFromSystemPercent = (defaultFromSystemCount * 100) / total;
                uploadFailedPercent = (uploadFailedCount * 100) / total;
                sapPercent = (sapCount * 100) / total;
            }
			
            WaitingEmployeeSubmitGraph.y = waitingEmployeeSubmitPercent;
            WaitingEmployeeSubmitGraph.amount = String.ValueOf(waitingEmployeeSubmitCount);
            retirementGraphs.add(WaitingEmployeeSubmitGraph);
            
            WaitingSectionHeadApproveGraph.y = waitingSectionHeadApprovalPercent;
            WaitingSectionHeadApproveGraph.amount = String.ValueOf(waitingSectionHeadApprovalCount);
            retirementGraphs.add(WaitingSectionHeadApproveGraph);
            
            WaitingDepartmentApproveGraph.y = waitingDepartmentHeadApprovalPercent;
            WaitingDepartmentApproveGraph.amount = String.ValueOf(waitingDepartmentHeadApprovalCount);
            retirementGraphs.add(WaitingDepartmentApproveGraph);
            
            WaitingForUploadGraph.y = waitingUploadingToPersonalFolderPercent;
            WaitingForUploadGraph.amount = String.ValueOf(waitingUploadingToPersonalFolderCount);
            retirementGraphs.add(WaitingForUploadGraph);
            
            CompletedGraph.y = completedPercent;
            CompletedGraph.amount = String.ValueOf(completedCount);
            retirementGraphs.add(CompletedGraph);
            
            DefaultGraph.y = defaultFromSystemPercent;
            DefaultGraph.amount = String.ValueOf(defaultFromSystemCount);
            retirementGraphs.add(DefaultGraph);
            
            UploadFailedGraph.y = uploadFailedPercent;
            UploadFailedGraph.amount = String.ValueOf(uploadFailedCount);
            retirementGraphs.add(UploadFailedGraph);
            
            SAPGraph.y = sapPercent;
            SAPGraph.amount = String.ValueOf(sapCount);
            retirementGraphs.add(SAPGraph);
            
        }
        
        return retirementGraphs;
        
    }
    
    @RemoteAction
    public static ESS_RetirementReport_DTO.RetirementGraphDTO GetRetirementLineGraph(RetirementSearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkRetirementAdminUser(userId);
        
        datetime todayDate = date.today();
        string nextYear = todayDate.addYears(1).format('yyyy');
        string nextTwoYear = todayDate.addYears(2).format('yyyy');

        retirementGraph = new ESS_RetirementReport_DTO.RetirementGraphDTO();
        
        List<ESS_Retirement__c> Retirements = new List<ESS_Retirement__c>();
            
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
            			'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
            			'function__c, department__c, section__c, level__c from ESS_Retirement__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
            			'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
            			'function__c, department__c, section__c, level__c from ESS_Retirement__c where OwnerId != null';
        } 
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }   
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
        	string function = filter.function;
            query = query + ' AND function__c =: function';
        }
           
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
        	string department = filter.department;
            query = query + ' AND department__c =: department';
        }
           
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
        	string section = filter.section;
            query = query + ' AND section__c =: section';
        }
        
        //filter.level
        if(string.isNotEmpty(filter.level) && filter.level.toLowerCase() != 'all') {
        	string level = filter.level;
            query = query + ' AND level__c =: level';
        }
        
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name());
            statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            statuses.add(ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name());
            statuses.add(ESS_Enum.RetirementStatus.SendingToSAP.name());
            statuses.add(ESS_Enum.RetirementStatus.Completed.name());
            statuses.add(ESS_Enum.RetirementStatus.DefaultFromSystem.name());
            statuses.add(ESS_Enum.RetirementStatus.UploadFailed.name());
            isCheckStatus = true;
        }
        else {
            //filter.statusWaitingEmployeeSubmit
            if(filter.statusWaitingEmployeeSubmit) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForApprovalSectionHead
            if(filter.statusWaitingForApprovalSectionHead) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForDepartmentHead
            if(filter.statusWaitingForDepartmentHead) {
            	statuses.add(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingForUploadPersonalFolder
            if(filter.statusWaitingForUploadPersonalFolder) {
            	statuses.add(ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name());
            	isCheckStatus = true;
            }
            //filter.statusSendingToSAP
            if(filter.statusSendingToSAP) {
            	statuses.add(ESS_Enum.RetirementStatus.SendingToSAP.name());
            	isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.RetirementStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.statusDefaultFromSystem
            if(filter.statusDefaultFromSystem) {
            	statuses.add(ESS_Enum.RetirementStatus.DefaultFromSystem.name());
            	isCheckStatus = true;
            }
            //filter.statusUploadFailed
            if(filter.statusUploadFailed) {
            	statuses.add(ESS_Enum.RetirementStatus.UploadFailed.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
        	query = query + ' AND status__c IN: statuses';
        }
        
        //filter.retirementAll
        List<string> retirementFilters = new List<string>();
        boolean isCheckRetirement = false;
        if(filter.retirementAll) {
            retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor55Years.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor60Years.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.EndOfMonth.name());
            retirementFilters.add(ESS_Enum.RetirementChoice.EndOfYear.name());
            isCheckRetirement = true;
        }
        else {
            //filter.retirementExact55Years
            if(filter.retirementExact55Years) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor55Years.name());
            	isCheckRetirement = true;
            }
            //filter.retirementExact60Years
            if(filter.retirementExact60Years) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.ExactDateFor60Years.name());
            	isCheckRetirement = true;
            }
            //filter.retirementEndOfMonth
            if(filter.retirementEndOfMonth) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.EndOfMonth.name());
            	isCheckRetirement = true;
            }
            //filter.retirementEndOfYear
            if(filter.retirementEndOfYear) {
            	retirementFilters.add(ESS_Enum.RetirementChoice.EndOfYear.name());
            	isCheckRetirement = true;
            }
        }
        
        if(isCheckRetirement) {
        	query = query + ' AND retirement_choice__c IN: retirementFilters';
        }
        
        //filter.startCreatedDate
        if(filter.startCreatedDate != null) {
            datetime startCreatedDate = filter.startCreatedDate;
        	query = query + ' AND (createddate >=: startCreatedDate)';
        }
        
        //filter.endCreatedDate
        if(filter.endCreatedDate != null) {
            datetime endCreatedDate = filter.endCreatedDate;
       		query = query + ' AND (createddate <=: endCreatedDate)';
        }
        
        //filter.startEmployeeSubmittedDate
        if(filter.startEmployeeSubmittedDate != null) {
            date startEmployeeSubmittedDate = filter.startEmployeeSubmittedDate;
        	query = query + ' AND (submitted_date__c >=: startEmployeeSubmittedDate)';
        }
        
        //filter.endEmployeeSubmittedDate
        if(filter.endEmployeeSubmittedDate != null) {
            date endEmployeeSubmittedDate = filter.endEmployeeSubmittedDate;
        	query = query + ' AND (submitted_date__c <=: endEmployeeSubmittedDate)';
        }
        
        //filter.startSectionHeadApprovedDate
        if(filter.startSectionHeadApprovedDate != null) {
            date startSectionHeadApprovedDate = filter.startSectionHeadApprovedDate;
        	query = query + ' AND (section_head_approve_date__c >=: startSectionHeadApprovedDate)';
        }
        
        //filter.endSectionHeadApprovedDate
        if(filter.endSectionHeadApprovedDate != null) {
            date endSectionHeadApprovedDate = filter.endSectionHeadApprovedDate;
        	query = query + ' AND (section_head_approve_date__c <=: endSectionHeadApprovedDate)';
        }
        
        
        //filter.startDepartmentHeadApprovedDate
        if(filter.startDepartmentHeadApprovedDate != null) {
            date startDepartmentHeadApprovedDate = filter.startDepartmentHeadApprovedDate;
        	query = query + ' AND (department_head_approve_date__c >=: startDepartmentHeadApprovedDate)';
        }
        
        //filter.endDepartmentHeadApprovedDate
        if(filter.endDepartmentHeadApprovedDate != null) {
            date endDepartmentHeadApprovedDate = filter.endDepartmentHeadApprovedDate;
        	query = query + ' AND (department_head_approve_date__c <=: endDepartmentHeadApprovedDate)';
        }
        
        //filter.startCompletedDate
        if(filter.startCompletedDate != null) {
            date startCompletedDate = filter.startCompletedDate;
        	query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = filter.endCompletedDate;
        	query = query + ' AND (completed_date__c <=: endCompletedDate)';
        }
        
		//Final query
		Retirements = Database.query(query); 
        
        List<ESS_Retirement__c> orderRetirements = Database.query(query + ' order by retirement_date__c asc');
        
        if(Retirements.size() > 0) {
            
            Set<string> existMonthYears = new Set<string>();
            retirementGraph.categories = new List<string>();
            for(ESS_Retirement__c Retirement : orderRetirements) {
                if(Retirement.Retirement_Date__c != null) {
                    Datetime RetirementDate = DateTime.newInstance(Retirement.Retirement_Date__c.year(), Retirement.Retirement_Date__c.month(), Retirement.Retirement_Date__c.day());
                	existMonthYears.add(RetirementDate.format('MMM yyyy'));
                }
            }
            
            if(existMonthYears.size() > 0) {
                
                retirementGraph.categories = new List<string> { 
                'Jan ' + nextYear, 
                'Feb ' + nextYear, 
                'Mar ' + nextYear, 
                'Apr ' + nextYear, 
                'May ' + nextYear, 
                'Jun ' + nextYear, 
                'Jul ' + nextYear, 
                'Aug ' + nextYear, 
                'Sep ' + nextYear,
                'Oct ' + nextYear,
                'Nov ' + nextYear,
                'Dec ' + nextYear,
                'Jan ' + nextTwoYear};
                    
                /* for(string existYear : existMonthYears) {
                    retirementGraph.categories.add(existYear);
                } */
                
            }

            retirementGraph.series = new List<ESS_RetirementReport_DTO.RetirementLineGraphSeriesDTO>();
            
            ESS_RetirementReport_DTO.RetirementLineGraphSeriesDTO lineSerie = new ESS_RetirementReport_DTO.RetirementLineGraphSeriesDTO();
            lineSerie.type = 'line';
            lineSerie.name = 'Retirement';
            lineSerie.data = new List<decimal>();
            lineSerie.color = '#e99bd2';
            lineSerie.custom = new List<integer>();
            
            integer monthYearCount = existMonthYears.size();
            
            if(retirementGraph.categories.size() > 0) {
                for(string existYear : retirementGraph.categories) {
                    integer count = 0;
                    for(ESS_Retirement__c Retirement : Retirements) {
                        if(Retirement.Retirement_Date__c != null) {
                            
                            Datetime RetirementDT = DateTime.newInstance(Retirement.Retirement_Date__c.year(), Retirement.Retirement_Date__c.month(), Retirement.Retirement_Date__c.day());
                			string RetirementDate = RetirementDT.format('MMM yyyy');
                            if(existYear == RetirementDate) {
                            system.debug('existYear : ' + existYear);
                            system.debug('RetirementDate : ' + RetirementDate);
                                count++;
                            }
                        }
                    }
                    
                    lineSerie.data.add(count);
                    lineSerie.custom.add(count);
                }
            }
            
            retirementGraph.series.add(lineSerie);
            
        }
        
        return retirementGraph;
        
    }
    
    @RemoteAction
    public static string ExportRetirementExcel(RetirementSearchCriteria filter) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_RetirementReport_Excel?';
        
        string trackingReportType = 'Retirement';
        string employeeId = filter.employeeId;
        string function = filter.function;
        string department = filter.department;
        string section = filter.section;
        string level = filter.level;
        boolean statusAll = filter.statusAll;
        boolean statusWaitingEmployeeSubmit = filter.statusWaitingEmployeeSubmit;
        boolean statusWaitingForApprovalSectionHead = filter.statusWaitingForApprovalSectionHead;
        boolean statusWaitingForDepartmentHead = filter.statusWaitingForDepartmentHead;
        boolean statusWaitingForUploadPersonalFolder = filter.statusWaitingForUploadPersonalFolder;
        boolean statusCompleted = filter.statusCompleted;
        boolean statusSendingToSAP = filter.statusSendingToSAP;
        boolean statusDefaultFromSystem = filter.statusDefaultFromSystem;
        boolean statusUploadFailed = filter.statusUploadFailed;
        boolean retirementAll = filter.retirementAll;
        boolean retirementExact55Years = filter.retirementExact55Years;
        boolean retirementExact60Years = filter.retirementExact60Years;
        boolean retirementEndOfMonth = filter.retirementEndOfMonth;
        boolean retirementEndOfYear = filter.retirementEndOfYear;
        date startCreatedDate = filter.startCreatedDate;
        date endCreatedDate = filter.endCreatedDate;
        date startEmployeeSubmittedDate = filter.startEmployeeSubmittedDate;
        date endEmployeeSubmittedDate = filter.endEmployeeSubmittedDate;
        date startSectionHeadApprovedDate = filter.startSectionHeadApprovedDate;
        date endSectionHeadApprovedDate = filter.endSectionHeadApprovedDate;
        date startDepartmentHeadApprovedDate = filter.startDepartmentHeadApprovedDate;
        date endDepartmentHeadApprovedDate = filter.endDepartmentHeadApprovedDate;
        date startCompletedDate = filter.startCompletedDate;
        date endCompletedDate = filter.endCompletedDate;
        
        URL = URL + 'trackingReportType=' + trackingReportType +
            		'&employeeId=' + employeeId +
            		'&function=' + function + 
            		'&department=' + department + 
            		'&section=' + section +
            		'&level=' + level +  
            		'&statusAll=' + statusAll +
            		'&statusWaitingEmployeeSubmit=' + statusWaitingEmployeeSubmit +  
            		'&statusWaitingForApprovalSectionHead=' + statusWaitingForApprovalSectionHead +  
            		'&statusWaitingForDepartmentHead=' + statusWaitingForDepartmentHead +  
            		'&statusWaitingForUploadPersonalFolder=' + statusWaitingForUploadPersonalFolder +  
            		'&statusCompleted=' + statusCompleted +  
            		'&statusSendingToSAP=' + statusSendingToSAP +  
            		'&statusDefaultFromSystem=' + statusDefaultFromSystem +  
            		'&statusUploadFailed=' + statusUploadFailed +  
            		'&retirementAll=' + retirementAll +  
            		'&retirementExact55Years=' + retirementExact55Years +  
            		'&retirementExact60Years=' + retirementExact60Years +  
            		'&retirementEndOfMonth=' + retirementEndOfMonth +  
            		'&retirementEndOfYear=' + retirementEndOfYear +  
            		'&startCreatedDate=' + startCreatedDate +  
            		'&endCreatedDate=' + endCreatedDate +   
            		'&startEmployeeSubmittedDate=' + startEmployeeSubmittedDate +  
            		'&endEmployeeSubmittedDate=' + endEmployeeSubmittedDate +   
            		'&startSectionHeadApprovedDate=' + startSectionHeadApprovedDate +  
            		'&endSectionHeadApprovedDate=' + endSectionHeadApprovedDate +   
            		'&startDepartmentHeadApprovedDate=' + startDepartmentHeadApprovedDate +  
            		'&endDepartmentHeadApprovedDate=' + endDepartmentHeadApprovedDate +   
            		'&startCompletedDate=' + startCompletedDate +  
            		'&endCompletedDate=' + endCompletedDate;
        
        return URL;
    }
    
    //Assign to DTO section
    public static ESS_RetirementReport_DTO.RetirementTableDTO assignToRetirementTableDTO(ESS_Retirement__c Retirement) {
        
        ESS_RetirementReport_DTO.RetirementTableDTO RetirementTable = new ESS_RetirementReport_DTO.RetirementTableDTO();
        RetirementTable.recordId = Retirement.Id;
        RetirementTable.documentNo = Retirement.Document_No__c;
        RetirementTable.employeeId = Retirement.Employee_ID__c;
        RetirementTable.employeeName = Retirement.Employee_Name__c;
        RetirementTable.birthDate = Retirement.Date_of_Birth__c;
        RetirementTable.age = Retirement.Age__c;
        RetirementTable.retirementDate = Retirement.Retirement_Date__c;
        
        RetirementTable.selectedRetirementDate = new ESS_Global.EnumValue('RetirementChoice');
        if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.ExactDateFor60Years)) {
            RetirementTable.selectedRetirementDate.key = ESS_Enum.RetirementChoice.ExactDateFor60Years.name();
        	RetirementTable.selectedRetirementDate.value = 'ในวันครบอายุ 60 ปีบริบูรณ์';
        }
        else if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.ExactDateFor55Years)) {
            RetirementTable.selectedRetirementDate.key = ESS_Enum.RetirementChoice.ExactDateFor55Years.name();
        	RetirementTable.selectedRetirementDate.value = 'ในวันครบอายุ 55 ปีบริบูรณ์';
        }
		else if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.EndOfMonth)) {
            RetirementTable.selectedRetirementDate.key = ESS_Enum.RetirementChoice.EndOfMonth.name();
        	RetirementTable.selectedRetirementDate.value = 'ในวันสุดท้ายของเดือนที่ครบอายุเกษียณ';
        }
		else if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.EndOfYear)) {
            RetirementTable.selectedRetirementDate.key = ESS_Enum.RetirementChoice.EndOfYear.name();
        	RetirementTable.selectedRetirementDate.value = 'ในวันสิ้นปีที่ครบอายุเกษียณ';
        }
        
        RetirementTable.defaultRetirementDate = Retirement.Default_Retirement_Date__c;
        if(string.isNotEmpty(Retirement.Section_Head_Id__c)) {
        	RetirementTable.sectionHead = Retirement.Section_Head__c;
        }
        else {
            RetirementTable.sectionHead = '';
        }
        RetirementTable.departmentHead = Retirement.Department_Head__c;
        
        RetirementTable.currentStatus = new ESS_Global.EnumValue('RetirementStatus');
        if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit)) {
            RetirementTable.currentStatus.key = ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name();
        	RetirementTable.currentStatus.value = 'Waiting Employee Submit';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead)) {
            RetirementTable.currentStatus.key = ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name();
        	RetirementTable.currentStatus.value = 'Waiting for Approval by Immediate Line / Section Head';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead)) {
            RetirementTable.currentStatus.key = ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name();
        	RetirementTable.currentStatus.value = 'Waiting for Approval by Department Head';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.UploadingToPersonalFolder)) {
            RetirementTable.currentStatus.key = ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name();
        	RetirementTable.currentStatus.value = 'Uploading to personal Folder';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.SendingToSAP)) {
            RetirementTable.currentStatus.key = ESS_Enum.RetirementStatus.SendingToSAP.name();
        	RetirementTable.currentStatus.value = 'Sending to SAP';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.Completed)) {
            RetirementTable.currentStatus.key = ESS_Enum.RetirementStatus.Completed.name();
        	RetirementTable.currentStatus.value = 'Completed';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.DefaultFromSystem)) {
            RetirementTable.currentStatus.key = ESS_Enum.RetirementStatus.DefaultFromSystem.name();
        	RetirementTable.currentStatus.value = 'Default from System';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.UploadFailed)) {
            RetirementTable.currentStatus.key = ESS_Enum.RetirementStatus.UploadFailed.name();
        	RetirementTable.currentStatus.value = 'Upload failed';
        }
        
        RetirementTable.createdDate = Date.ValueOf(Retirement.CreatedDate);
        RetirementTable.employeeSubmittedDate = Retirement.Submitted_Date__c;
        RetirementTable.sectionHeadApprovedDate = Retirement.Section_Head_Approve_Date__c;
        RetirementTable.departmentHeadApprovedDate = Retirement.Department_Head_Approve_Date__c;
        RetirementTable.updatedToPersonalFolderDate = Retirement.Upload_To_Personal_Folder_Date__c;
        RetirementTable.sentToSAPDate = Retirement.Sending_To_SAP_Date__c;
        RetirementTable.completedDate = Retirement.Completed_Date__c;
        RetirementTable.function = Retirement.Function__c;
        RetirementTable.department = Retirement.Department__c;
        RetirementTable.section = Retirement.Section__c;
        RetirementTable.level = Retirement.Level__c;
        
        return RetirementTable;
        
    }
    
    @RemoteAction
    public static List<string> ESSGlobal_GetLevels() {
        List<string> Levels = ESS_Global.GetLevels();
        return Levels;
    }
    
    @RemoteAction
    public static List<string> ESSGlobal_GetFunctions() {
        List<string> Functions = ESS_Global.GetFunctions(null);
        return Functions;
    }
    
    @RemoteAction
    public static List<string> ESSGlobal_GetDepartments(string function) {
        List<string> Departments = ESS_Global.GetDepartments(function);
        return Departments;
    }  
    
    @RemoteAction
    public static List<string> ESSGlobal_GetSections(string department) {
        List<string> Sections = ESS_Global.GetSections(department);
        return Sections;
    }  
    
    @RemoteAction
    public static List<string> ESSGlobal_GetUnits(string section) {
        List<string> Units = ESS_Global.GetUnits(section);
        return Units;
    }  
    
    public class RetirementSearchCriteria {
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string level {get;set;}
        @RemoteAction
        public boolean statusAll {get;set;}
        @RemoteAction
        public boolean statusWaitingEmployeeSubmit {get;set;}
        @RemoteAction
        public boolean statusWaitingForApprovalSectionHead {get;set;}
        @RemoteAction
        public boolean statusWaitingForDepartmentHead {get;set;}
        @RemoteAction
        public boolean statusWaitingForUploadPersonalFolder {get;set;}
        @RemoteAction
        public boolean statusCompleted {get;set;}
        @RemoteAction
        public boolean statusSendingToSAP {get;set;}
        @RemoteAction
        public boolean statusDefaultFromSystem {get;set;}
        @RemoteAction
        public boolean statusUploadFailed {get;set;}
        @RemoteAction
        public boolean retirementAll {get;set;}
        @RemoteAction
        public boolean retirementExact55Years {get;set;}
        @RemoteAction
        public boolean retirementExact60Years {get;set;}
        @RemoteAction
        public boolean retirementEndOfMonth {get;set;}
        @RemoteAction
        public boolean retirementEndOfYear {get;set;}
        @RemoteAction
        public date startCreatedDate {get;set;}
        @RemoteAction
        public date endCreatedDate {get;set;}
        @RemoteAction
        public date startEmployeeSubmittedDate {get;set;}
        @RemoteAction
        public date endEmployeeSubmittedDate {get;set;}
        @RemoteAction
        public date startSectionHeadApprovedDate {get;set;}
        @RemoteAction
        public date endSectionHeadApprovedDate {get;set;}
        @RemoteAction
        public date startDepartmentHeadApprovedDate {get;set;}
        @RemoteAction
        public date endDepartmentHeadApprovedDate  {get;set;}
        @RemoteAction
        public date startCompletedDate {get;set;}
        @RemoteAction
        public date endCompletedDate {get;set;}
    }
    
    
}