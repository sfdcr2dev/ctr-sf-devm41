/* Author Softever */
global with sharing class ESS_ProbationaryReport {

    private static List<ESS_ProbationaryReport_DTO.ProbationTableDTO> probationTables;
    private static ESS_ProbationaryReport_DTO.ProbationGraphDTO probationGraph;
    
    static {
    }
    
    //Probation
    @RemoteAction
    public static integer GetProbationTableCount(ProbationSearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkProbationAdminUser(userId);
            
        probationTables = new List<ESS_ProbationaryReport_DTO.ProbationTableDTO>();
            
        List<ESS_Probationary__c> Probations = new List<ESS_Probationary__c>();
            
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, employee_name_en__c, date_joined_company__c, date_completed_probation__c, status__c, createddate, section_head__c, department_head__c, completed_date__c, ' +
            			'probation_status__c, function__c, department__c, section__c, unit__c, level__c, section_head_approve_date__c, department_head_approve_date__c, Reassign_Section_Head_Approve_Date__c, Reassign_Department_Head_Approve_Date__c, Reassign_Section_Head_Date__c, Reassign_Department_Head_Date__c, ' +
            			'reassign_section_head__c, reassign_department_head__c, Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, approval_history_json__c from ESS_Probationary__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, employee_id__c, employee_name__c, employee_name_en__c, date_joined_company__c, date_completed_probation__c, status__c, createddate, section_head__c, department_head__c, completed_date__c, ' +
            			'probation_status__c, function__c, department__c, section__c, unit__c, level__c, section_head_approve_date__c, department_head_approve_date__c, Reassign_Section_Head_Approve_Date__c, Reassign_Department_Head_Approve_Date__c, Reassign_Section_Head_Date__c, Reassign_Department_Head_Date__c, ' +
            			'reassign_section_head__c, reassign_department_head__c, Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, approval_history_json__c from ESS_Probationary__c where OwnerId != null';
        } 
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employee_id__c like: employeeId';
        }
            
        //filter.sectionHead
        if(string.isNotEmpty(filter.sectionHead) && filter.sectionHead.toLowerCase() != 'all') {
        	string sectionHead = filter.sectionHead;
            query = query + ' AND section_head__c =: sectionHead';
        }
        
        //filter.departmentHead
        if(string.isNotEmpty(filter.departmentHead) && filter.departmentHead.toLowerCase() != 'all') {
            string departmentHead = filter.departmentHead;
            query = query + ' AND department_head__c =: departmentHead';
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
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.UploadFailed.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.Completed.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.statusWaitingForApprovalSectionHead
            if(filter.statusWaitingForApprovalSectionHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingReassignSectionHead
            if(filter.statusWaitingReassignSectionHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingForApprovalDepartmentHead
            if(filter.statusWaitingForApprovalDepartmentHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingReassignDepartmentHead
            if(filter.statusWaitingReassignDepartmentHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingForUploadToPersonalFolder
            if(filter.statusWaitingForUploadToPersonalFolder) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name());
                isCheckStatus = true;
            }
            //filter.statusUploadFailed
            if(filter.statusUploadFailed) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.UploadFailed.name());
                isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.Completed.name());
                isCheckStatus = true;
            }
            
        }
        
        if(isCheckStatus) {
        	query = query + ' AND status__c IN: statuses';
        }
        
        //filter.probationStatusAll
        List<string> probationFilters = new List<string>();
        boolean isCheckProbationStatus = false;
        if(filter.probationStatusAll) {
            probationFilters.add(ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name());
            probationFilters.add(ESS_Enum.ProbationStatus.TerminateEmployee.name());
            isCheckProbationStatus = true;
        }
        else {
            //filter.probationStatusRegularEmployee
            if(filter.probationStatusRegularEmployee) {
            	probationFilters.add(ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name());
            	isCheckProbationStatus = true;
            }
            //filter.probationStatusTerminateEmployee
            if(filter.probationStatusTerminateEmployee) {
            	probationFilters.add(ESS_Enum.ProbationStatus.TerminateEmployee.name());
            	isCheckProbationStatus = true;
            }
        }
        
        if(isCheckProbationStatus) {
        	query = query + ' AND probation_status__c IN: probationFilters';
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
        
        //filter.startSectionHeadSubmittedDate
        if(filter.startSectionHeadSubmittedDate != null) {
            date startSectionHeadSubmittedDate = filter.startSectionHeadSubmittedDate;
        	query = query + ' AND (section_head_approve_date__c >=: startSectionHeadSubmittedDate)';
        }
        
        //filter.endSectionHeadSubmittedDate
        if(filter.endSectionHeadSubmittedDate != null) {
            date endSectionHeadSubmittedDate = filter.endSectionHeadSubmittedDate;
        	query = query + ' AND (section_head_approve_date__c <=: endSectionHeadSubmittedDate)';
        }
        
        //filter.startSectionHeadReassignedDate
        if(filter.startSectionHeadReassignedDate != null) {
            date startSectionHeadReassignedDate = filter.startSectionHeadReassignedDate;
        	query = query + ' AND (reassign_section_head_date__c >=: startSectionHeadReassignedDate)';
        }
        
        //filter.endSectionHeadReassignedDate
        if(filter.endSectionHeadReassignedDate != null) {
            date endSectionHeadReassignedDate = filter.endSectionHeadReassignedDate;
        	query = query + ' AND (reassign_section_head_date__c <=: endSectionHeadReassignedDate)';
        }
        
        
        //filter.startSectionHeadReassignedSubmittedDate
        if(filter.startSectionHeadReassignedSubmittedDate != null) {
            date startSectionHeadReassignedSubmittedDate = filter.startSectionHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_section_head_approve_date__c >=: startSectionHeadReassignedSubmittedDate)';
        }
        
        //filter.endSectionHeadReassignedSubmittedDate
        if(filter.endSectionHeadReassignedSubmittedDate != null) {
            date endSectionHeadReassignedSubmittedDate = filter.endSectionHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_section_head_approve_date__c <=: endSectionHeadReassignedSubmittedDate)';
        }
        
        //filter.startDepartmentHeadSubmittedDate
        if(filter.startDepartmentHeadSubmittedDate != null) {
            date startDepartmentHeadSubmittedDate = filter.startDepartmentHeadSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c >=: startDepartmentHeadSubmittedDate)';
        }
        
        //filter.endDepartmentHeadSubmittedDate
        if(filter.endDepartmentHeadSubmittedDate != null) {
            date endDepartmentHeadSubmittedDate = filter.endDepartmentHeadSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c <=: endDepartmentHeadSubmittedDate)';
        }
        
        //filter.startDepartmentHeadReassignedDate
        if(filter.startDepartmentHeadReassignedDate != null) {
            date startDepartmentHeadReassignedDate = filter.startDepartmentHeadReassignedDate;
        	query = query + ' AND (reassign_department_head_date__c >=: startDepartmentHeadReassignedDate)';
        }
        
        //filter.endDepartmentHeadReassignedDate
        if(filter.endDepartmentHeadReassignedDate != null) {
            date endDepartmentHeadReassignedDate = filter.endDepartmentHeadReassignedDate;
        	query = query + ' AND (reassign_department_head_date__c <=: endDepartmentHeadReassignedDate)';
        }
        
        //filter.startDepartmentHeadReassignedSubmittedDate
        if(filter.startDepartmentHeadReassignedSubmittedDate != null) {
            date startDepartmentHeadReassignedSubmittedDate = filter.startDepartmentHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c >=: startDepartmentHeadReassignedSubmittedDate)';
        }
        
        //filter.endDepartmentHeadReassignedSubmittedDate 
        if(filter.endDepartmentHeadReassignedSubmittedDate != null) {
            date endDepartmentHeadReassignedSubmittedDate = filter.endDepartmentHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c <=: endDepartmentHeadReassignedSubmittedDate)';
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
		Probations = Database.query(query); 
        integer totalSize = 0;

        if(Probations.size() > 0) {
            for(ESS_Probationary__c Probation : Probations) {
                ESS_ProbationaryReport_DTO.ProbationTableDTO ProbationTable = new ESS_ProbationaryReport_DTO.ProbationTableDTO();
                ProbationTable = assignToProbationTableDTO(Probation);
                if(string.isnotempty(ProbationTable.documentNo)) {
                    totalSize++;
                }
            }
        }

        return totalSize;
        
    }
    
    @RemoteAction
    public static List<ESS_ProbationaryReport_DTO.ProbationTableDTO> GetProbationTables(ProbationSearchCriteria filter, 
        //documentNo, employeeId, employeeName, dateJoinedCompany, dateCompletedProbation, currentStatus, createdDate, sectionHead, sectionHeadSubmittedDate, reassignedSectionHead, reassignedSectionHeadSubmittedDate, departmentHead, departmentHeadSubmittedDate, reassignedDepartmentHead, reassignedDepartmentHeadSubmittedDate, completedDate, probationStatus, function, department, section, unit, level
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) 
    {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkProbationAdminUser(userId);
            
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        probationTables = new List<ESS_ProbationaryReport_DTO.ProbationTableDTO>();
            
        List<ESS_Probationary__c> Probations = new List<ESS_Probationary__c>();
            
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, employee_name_en__c, date_joined_company__c, date_completed_probation__c, status__c, createddate, section_head__c, department_head__c, completed_date__c, ' +
            			'probation_status__c, function__c, department__c, section__c, unit__c, level__c, section_head_approve_date__c, department_head_approve_date__c, Reassign_Section_Head_Approve_Date__c, Reassign_Department_Head_Approve_Date__c, Reassign_Section_Head_Date__c, Reassign_Department_Head_Date__c, ' +
            			'reassign_section_head__c, reassign_department_head__c, Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, Approval_History_JSON__c from ESS_Probationary__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, employee_id__c, employee_name__c, employee_name_en__c, date_joined_company__c, date_completed_probation__c, status__c, createddate, section_head__c, department_head__c, completed_date__c, ' +
            			'probation_status__c, function__c, department__c, section__c, unit__c, level__c, section_head_approve_date__c, department_head_approve_date__c, Reassign_Section_Head_Approve_Date__c, Reassign_Department_Head_Approve_Date__c, Reassign_Section_Head_Date__c, Reassign_Department_Head_Date__c, ' +
            			'reassign_section_head__c, reassign_department_head__c, Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, Approval_History_JSON__c from ESS_Probationary__c where OwnerId != null';
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
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.UploadFailed.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.Completed.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.statusWaitingForApprovalSectionHead
            if(filter.statusWaitingForApprovalSectionHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingReassignSectionHead
            if(filter.statusWaitingReassignSectionHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingForApprovalDepartmentHead
            if(filter.statusWaitingForApprovalDepartmentHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name());
            	isCheckStatus = true;
            }
            //filter.statusWaitingReassignDepartmentHead
            if(filter.statusWaitingReassignDepartmentHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingForUploadToPersonalFolder
            if(filter.statusWaitingForUploadToPersonalFolder) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name());
            	isCheckStatus = true;
            }
            //filter.statusUploadFailed
            if(filter.statusUploadFailed) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.UploadFailed.name());
                isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.Completed.name());
            	isCheckStatus = true;
            }
            
        }
        
        if(isCheckStatus) {
        	query = query + ' AND status__c IN: statuses';
        }
        
        //filter.probationStatusAll
        List<string> probationFilters = new List<string>();
        boolean isCheckProbationStatus = false;
        if(filter.probationStatusAll) {
            probationFilters.add(ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name());
            probationFilters.add(ESS_Enum.ProbationStatus.TerminateEmployee.name());
            isCheckProbationStatus = true;
        }
        else {
            //filter.probationStatusRegularEmployee
            if(filter.probationStatusRegularEmployee) {
            	probationFilters.add(ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name());
            	isCheckProbationStatus = true;
            }
            //filter.probationStatusTerminateEmployee
            if(filter.probationStatusTerminateEmployee) {
            	probationFilters.add(ESS_Enum.ProbationStatus.TerminateEmployee.name());
            	isCheckProbationStatus = true;
            }
            
        }
        
        if(isCheckProbationStatus) {
        	query = query + ' AND probation_status__c IN: probationFilters';
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
        
        //filter.startSectionHeadSubmittedDate
        if(filter.startSectionHeadSubmittedDate != null) {
            date startSectionHeadSubmittedDate = filter.startSectionHeadSubmittedDate;
        	query = query + ' AND (section_head_approve_date__c >=: startSectionHeadSubmittedDate)';
        }
        
        //filter.endSectionHeadSubmittedDate
        if(filter.endSectionHeadSubmittedDate != null) {
            date endSectionHeadSubmittedDate = filter.endSectionHeadSubmittedDate;
        	query = query + ' AND (section_head_approve_date__c <=: endSectionHeadSubmittedDate)';
        }
        
        //filter.startSectionHeadReassignedDate
        if(filter.startSectionHeadReassignedDate != null) {
            date startSectionHeadReassignedDate = filter.startSectionHeadReassignedDate;
        	query = query + ' AND (reassign_section_head_date__c >=: startSectionHeadReassignedDate)';
        }
        
        //filter.endSectionHeadReassignedDate
        if(filter.endSectionHeadReassignedDate != null) {
            date endSectionHeadReassignedDate = filter.endSectionHeadReassignedDate;
        	query = query + ' AND (reassign_section_head_date__c <=: endSectionHeadReassignedDate)';
        }
        
        //filter.startSectionHeadReassignedSubmittedDate
        if(filter.startSectionHeadReassignedSubmittedDate != null) {
            date startSectionHeadReassignedSubmittedDate = filter.startSectionHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_section_head_approve_date__c >=: startSectionHeadReassignedSubmittedDate)';
        }
        
        //filter.endSectionHeadReassignedSubmittedDate
        if(filter.endSectionHeadReassignedSubmittedDate != null) {
            date endSectionHeadReassignedSubmittedDate = filter.endSectionHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_section_head_approve_date__c <=: endSectionHeadReassignedSubmittedDate)';
        }
        
        //filter.startDepartmentHeadSubmittedDate
        if(filter.startDepartmentHeadSubmittedDate != null) {
            date startDepartmentHeadSubmittedDate = filter.startDepartmentHeadSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c >=: startDepartmentHeadSubmittedDate)';
        }
        
        //filter.endDepartmentHeadSubmittedDate
        if(filter.endDepartmentHeadSubmittedDate != null) {
            date endDepartmentHeadSubmittedDate = filter.endDepartmentHeadSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c <=: endDepartmentHeadSubmittedDate)';
        }
        
        //filter.startDepartmentHeadReassignedDate
        if(filter.startDepartmentHeadReassignedDate != null) {
            date startDepartmentHeadReassignedDate = filter.startDepartmentHeadReassignedDate;
        	query = query + ' AND (reassign_department_head_date__c >=: startDepartmentHeadReassignedDate)';
        }
        
        //filter.endDepartmentHeadReassignedDate
        if(filter.endDepartmentHeadReassignedDate != null) {
            date endDepartmentHeadReassignedDate = filter.endDepartmentHeadReassignedDate;
        	query = query + ' AND (reassign_department_head_date__c <=: endDepartmentHeadReassignedDate)';
        }
        
        //filter.startDepartmentHeadReassignedSubmittedDate
        if(filter.startDepartmentHeadReassignedSubmittedDate != null) {
            date startDepartmentHeadReassignedSubmittedDate = filter.startDepartmentHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c >=: startDepartmentHeadReassignedSubmittedDate)';
        }
        
        //filter.endDepartmentHeadReassignedSubmittedDate 
        if(filter.endDepartmentHeadReassignedSubmittedDate != null) {
            date endDepartmentHeadReassignedSubmittedDate = filter.endDepartmentHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c <=: endDepartmentHeadReassignedSubmittedDate)';
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
        else if(sortByParam.sortBy == 'dateJoinedCompany') {
        	if(sortByParam.ascending) {
       	    	query += ' order by date_joined_company__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by date_joined_company__c desc';
            }
        }
        else if(sortByParam.sortBy == 'dateCompletedProbation') {
        	if(sortByParam.ascending) {
       	    	query += ' order by date_completed_probation__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by date_completed_probation__c desc';
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
        else if(sortByParam.sortBy == 'sectionHead') {
        	if(sortByParam.ascending) {
       	    	query += ' order by section_head__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by section_head__c desc';
            }
        }
        else if(sortByParam.sortBy == 'sectionHeadSubmittedDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by Section_Head_Approve_Date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by Section_Head_Approve_Date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'reassignedSectionHead') {
        	if(sortByParam.ascending) {
       	    	query += ' order by Reassign_Section_Head__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by Reassign_Section_Head__c desc';
            }
        }
        else if(sortByParam.sortBy == 'reassignedSectionHeadSubmittedDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by Reassign_Section_Head_Approve_Date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by Reassign_Section_Head_Approve_Date__c desc';
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
        else if(sortByParam.sortBy == 'departmentHeadSubmittedDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by Department_Head_Approve_Date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by Department_Head_Approve_Date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'reassignedDepartmentHead') {
        	if(sortByParam.ascending) {
       	    	query += ' order by Reassign_Department_Head__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by Reassign_Department_Head__c desc';
            }
        }
        else if(sortByParam.sortBy == 'reassignedDepartmentHeadSubmittedDate') {
        	if(sortByParam.ascending) {
       	    	query += ' order by Reassign_Department_Head_Approve_Date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by Reassign_Department_Head_Approve_Date__c desc';
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
        else if(sortByParam.sortBy == 'unit') {
        	if(sortByParam.ascending) {
       	    	query += ' order by unit__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by unit__c desc';
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
        
        Probations = database.query(query);
        
        if(Probations.size() > 0) {
            for(ESS_Probationary__c Probation : Probations) {
                ESS_ProbationaryReport_DTO.ProbationTableDTO ProbationTable = new ESS_ProbationaryReport_DTO.ProbationTableDTO();
                ProbationTable = assignToProbationTableDTO(Probation);
                if(string.isnotempty(ProbationTable.documentNo)) {
                    probationTables.add(ProbationTable);
                }
            }
        }
        
        return probationTables;
                                                                                     
    }
    
    @RemoteAction
    public static ESS_ProbationaryReport_DTO.ProbationGraphDTO GetProbationGraph(ProbationSearchCriteria filter, string groupingBy) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkProbationAdminUser(userId);
        
        probationGraph = new ESS_ProbationaryReport_DTO.ProbationGraphDTO();
        
        List<ESS_Probationary__c> Probations = new List<ESS_Probationary__c>();
            
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, status__c, createddate, section_head__c, department_head__c, completed_date__c, ' +
            			'probation_status__c, function__c, department__c, section__c, unit__c, level__c, section_head_approve_date__c, department_head_approve_date__c, Reassign_Section_Head_Approve_Date__c, Reassign_Department_Head_Approve_Date__c, Reassign_Section_Head_Date__c, Reassign_Department_Head_Date__c, ' +
            			'reassign_section_head__c, reassign_department_head__c from ESS_Probationary__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, status__c, createddate, section_head__c, department_head__c, completed_date__c, ' +
            			'probation_status__c, function__c, department__c, section__c, unit__c, level__c, section_head_approve_date__c, department_head_approve_date__c, Reassign_Section_Head_Approve_Date__c, Reassign_Department_Head_Approve_Date__c, Reassign_Section_Head_Date__c, Reassign_Department_Head_Date__c, ' +
            			'reassign_section_head__c, reassign_department_head__c from ESS_Probationary__c where OwnerId != null';
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
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.UploadFailed.name());
            statuses.add(ESS_Enum.ProbationApproveStatus.Completed.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.statusWaitingForApprovalSectionHead
            if(filter.statusWaitingForApprovalSectionHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingReassignSectionHead
            if(filter.statusWaitingReassignSectionHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingForApprovalDepartmentHead
            if(filter.statusWaitingForApprovalDepartmentHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingReassignDepartmentHead
            if(filter.statusWaitingReassignDepartmentHead) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name());
                isCheckStatus = true;
            }
            //filter.statusWaitingForUploadToPersonalFolder
            if(filter.statusWaitingForUploadToPersonalFolder) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name());
                isCheckStatus = true;
            }
            //filter.statusUploadFailed
            if(filter.statusUploadFailed) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.UploadFailed.name());
                isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.ProbationApproveStatus.Completed.name());
                isCheckStatus = true;
            }
            
        }
        
        if(isCheckStatus) {
        	query = query + ' AND status__c IN: statuses';
        }
        
        //filter.probationStatusAll
        List<string> probationFilters = new List<string>();
        boolean isCheckProbationStatus = false;
        if(filter.probationStatusAll) {
            probationFilters.add(ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name());
            probationFilters.add(ESS_Enum.ProbationStatus.TerminateEmployee.name());
            isCheckProbationStatus = true;
        }
        else {
            //filter.probationStatusRegularEmployee
            if(filter.probationStatusRegularEmployee) {
            	probationFilters.add(ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name());
            	isCheckProbationStatus = true;
            }
            //filter.probationStatusTerminateEmployee
            if(filter.probationStatusTerminateEmployee) {
            	probationFilters.add(ESS_Enum.ProbationStatus.TerminateEmployee.name());
            	isCheckProbationStatus = true;
            }
            
        }
        
        if(isCheckProbationStatus) {
        	query = query + ' AND probation_status__c IN: probationFilters';
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
        
        //filter.startSectionHeadSubmittedDate
        if(filter.startSectionHeadSubmittedDate != null) {
            date startSectionHeadSubmittedDate = filter.startSectionHeadSubmittedDate;
        	query = query + ' AND (section_head_approve_date__c >=: startSectionHeadSubmittedDate)';
        }
        
        //filter.endSectionHeadSubmittedDate
        if(filter.endSectionHeadSubmittedDate != null) {
            date endSectionHeadSubmittedDate = filter.endSectionHeadSubmittedDate;
        	query = query + ' AND (section_head_approve_date__c <=: endSectionHeadSubmittedDate)';
        }
        
        //filter.startSectionHeadReassignedDate
        if(filter.startSectionHeadReassignedDate != null) {
            date startSectionHeadReassignedDate = filter.startSectionHeadReassignedDate;
        	query = query + ' AND (reassign_section_head_date__c >=: startSectionHeadReassignedDate)';
        }
        
        //filter.endSectionHeadReassignedDate
        if(filter.endSectionHeadReassignedDate != null) {
            date endSectionHeadReassignedDate = filter.endSectionHeadReassignedDate;
        	query = query + ' AND (reassign_section_head_date__c <=: endSectionHeadReassignedDate)';
        }
        
        
        //filter.startSectionHeadReassignedSubmittedDate
        if(filter.startSectionHeadReassignedSubmittedDate != null) {
            date startSectionHeadReassignedSubmittedDate = filter.startSectionHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_section_head_approve_date__c >=: startSectionHeadReassignedSubmittedDate)';
        }
        
        //filter.endSectionHeadReassignedSubmittedDate
        if(filter.endSectionHeadReassignedSubmittedDate != null) {
            date endSectionHeadReassignedSubmittedDate = filter.endSectionHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_section_head_approve_date__c <=: endSectionHeadReassignedSubmittedDate)';
        }
        
        //filter.startDepartmentHeadSubmittedDate
        if(filter.startDepartmentHeadSubmittedDate != null) {
            date startDepartmentHeadSubmittedDate = filter.startDepartmentHeadSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c >=: startDepartmentHeadSubmittedDate)';
        }
        
        //filter.endDepartmentHeadSubmittedDate
        if(filter.endDepartmentHeadSubmittedDate != null) {
            date endDepartmentHeadSubmittedDate = filter.endDepartmentHeadSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c <=: endDepartmentHeadSubmittedDate)';
        }
        
        //filter.startDepartmentHeadReassignedDate
        if(filter.startDepartmentHeadReassignedDate != null) {
            date startDepartmentHeadReassignedDate = filter.startDepartmentHeadReassignedDate;
        	query = query + ' AND (reassign_department_head_date__c >=: startDepartmentHeadReassignedDate)';
        }
        
        //filter.endDepartmentHeadReassignedDate
        if(filter.endDepartmentHeadReassignedDate != null) {
            date endDepartmentHeadReassignedDate = filter.endDepartmentHeadReassignedDate;
        	query = query + ' AND (reassign_department_head_date__c <=: endDepartmentHeadReassignedDate)';
        }
        
        //filter.startDepartmentHeadReassignedSubmittedDate
        if(filter.startDepartmentHeadReassignedSubmittedDate != null) {
            date startDepartmentHeadReassignedSubmittedDate = filter.startDepartmentHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c >=: startDepartmentHeadReassignedSubmittedDate)';
        }
        
        //filter.endDepartmentHeadReassignedSubmittedDate 
        if(filter.endDepartmentHeadReassignedSubmittedDate != null) {
            date endDepartmentHeadReassignedSubmittedDate = filter.endDepartmentHeadReassignedSubmittedDate;
        	query = query + ' AND (reassign_department_head_approve_date__c <=: endDepartmentHeadReassignedSubmittedDate)';
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
		Probations = Database.query(query); 
        
        //TODO
        //After Filter then group by
        string groupByQuery = '';
        if(groupingBy == 'Function') {
			groupByQuery = 'select Function__c, Department__c from ESS_Probationary__c where Function__c != \'\' ';
        }
        else if(groupingBy == 'Department') {
			groupByQuery = 'select Department__c, Section__c from ESS_Probationary__c where Department__c != \'\' ';
        }

        if(Probations.size() > 0) {
            
            probationGraph.categories = new List<string>(); 
            probationGraph.series = new List<ESS_ProbationaryReport_DTO.ProbationGraphSeriesDTO>();
            
            ESS_ProbationaryReport_DTO.ProbationGraphSeriesDTO confirmSerie = new ESS_ProbationaryReport_DTO.ProbationGraphSeriesDTO();
            confirmSerie.type = 'column';
            confirmSerie.name = 'Confirm to Regular Employee';
            confirmSerie.data = new List<integer>();
            confirmSerie.color = '#e99bd2';
            confirmSerie.custom = new List<decimal>();
            
            ESS_ProbationaryReport_DTO.ProbationGraphSeriesDTO terminateSerie = new ESS_ProbationaryReport_DTO.ProbationGraphSeriesDTO();
            terminateSerie.type = 'column';
            terminateSerie.name = 'Terminate Employee';
            terminateSerie.data = new List<integer>();
            terminateSerie.color = '#79a0fc';
            terminateSerie.custom = new List<decimal>();
            
            List<AggregateResult> AggregateResults = new List<AggregateResult>();
            
            List<integer> confirms = new List<integer>();
            List<integer> terminates = new List<integer>();
            
            if(groupingBy == 'Function') {
                List<string> Functions = ESSGlobal_GetFunctions();
            	integer totalFunctionCount = Functions.size();
                
                if(Functions.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Function__c, Department__c order by Function__c, Department__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer functionCount = 0;
                    
                    for(string currentFunction : Functions) {
                        
                        integer totalFunction = 0;
                        integer confirm = 0;
                        integer terminate = 0;
                        
                        for(AggregateResult AR : AggregateResults) { 
                            if(AR.get('Function__c') == currentFunction) {
                                totalFunction++;
                                if(totalFunction == 1) {
                                    confirm = 0;
                                    terminate = 0;
                                }
                                string department = '';
                                if(AR.get('Department__c') != null && AR.get('Department__c') != '') {
                                    department = AR.get('Department__c').toString();
                                }
                                for(ESS_Probationary__c Probation : Probations) {
                                    if(Probation.Department__c == department) {
                                        if(Probation.Probation_Status__c == String.ValueOf(ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee)) {
                                            confirm++;
                                        }
                                        else if(Probation.Probation_Status__c == String.ValueOf(ESS_Enum.ProbationStatus.TerminateEmployee)) {
                                            terminate++;
                                        }
                                    }
                                }
                                System.debug(currentFunction + ' : ' + department + ' : ' + confirm + ' : ' + terminate);
                            }
                        }
                        
                        if(totalFunction > 0) {
                            if(confirm > 0) {
                                confirms.add(confirm);
                            }
                            else {
                                confirms.add(0);
                            }
                            if(terminate > 0) {
                                terminates.add(terminate);
                            }
                            else {
                                terminates.add(0);
                            }
                        	functionCount++;
                            probationGraph.categories.add(currentFunction);
                        }
                    }
                    
                    //Add to graph
                    confirmSerie.data.addAll(confirms);
                    probationGraph.series.add(confirmSerie);
                    terminateSerie.data.addAll(terminates);
                    probationGraph.series.add(terminateSerie);
                }
            }
            else if(groupingBy == 'Department') {
                List<string> Departments = ESSGlobal_GetDepartments(null);
            	integer totalDepartmentCount = Departments.size();
                
                if(Departments.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Department__c, Section__c order by Department__c, Section__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer departmentCount = 0;
                    
                    for(string currentDepartment : Departments) {
                        
                        System.debug(currentDepartment);
                        
                        integer totalDepartment = 0;
                        integer confirm = 0;
                        integer terminate = 0;

                        for(AggregateResult AR : AggregateResults) { 
                            
                            if(AR.get('Department__c') == currentDepartment) {
                                totalDepartment++;
                                if(totalDepartment == 1) {
                                    confirm = 0;
                                	terminate = 0; 
                                }
                                string section = '';
                                if(AR.get('Section__c') != null && AR.get('Section__c') != '') {
                                    section = AR.get('Section__c').toString();
                                }
                                
                                for(ESS_Probationary__c Probation : Probations) {
                                    if(Probation.Section__c == section) {
                                        if(Probation.Probation_Status__c == String.ValueOf(ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee)) {
                                            confirm++;
                                        }
                                        else if(Probation.Probation_Status__c == String.ValueOf(ESS_Enum.ProbationStatus.TerminateEmployee)) {
                                            terminate++;
                                        }
                                    }
                                }
                                System.debug(section + ' : ' + confirm + ' : ' + terminate);
                            }
                        }
                        
                        if(totalDepartment > 0) {
                            if(confirm > 0) {
                                confirms.add(confirm);
                            }
                            else {
                                confirms.add(0);
                            }
                            if(terminate > 0) {
                                terminates.add(terminate);
                            }
                            else {
                                terminates.add(0);
                            }
                        	departmentCount++;
                            probationGraph.categories.add(currentDepartment);
                        }
                        
                    }
                    
                    //Add to graph
                    confirmSerie.data.addAll(confirms);
                    probationGraph.series.add(confirmSerie);
                    terminateSerie.data.addAll(terminates);
                    probationGraph.series.add(terminateSerie);
                }
            }
            
        }
        system.debug(probationGraph);
        return probationGraph;
        
    }
      
    @RemoteAction
    public static string ExportProbationExcel(ProbationSearchCriteria filter) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_ProbationaryReport_Excel?';
        
        string trackingReportType = 'Probation';
        string employeeId = filter.employeeId;
        string sectionHead = filter.sectionHead;
        string departmentHead = filter.departmentHead;
        string function = filter.function;
        string department = filter.department;
        string section = filter.section;
        string level = filter.level;
        boolean statusAll = filter.statusAll;
        boolean statusWaitingForApprovalSectionHead = filter.statusWaitingForApprovalSectionHead;
        boolean statusWaitingReassignSectionHead = filter.statusWaitingReassignSectionHead;
        boolean statusWaitingForApprovalDepartmentHead = filter.statusWaitingForApprovalDepartmentHead;
        boolean statusWaitingReassignDepartmentHead = filter.statusWaitingReassignDepartmentHead;
        boolean statusWaitingForUploadToPersonalFolder = filter.statusWaitingForUploadToPersonalFolder;
        boolean statusCompleted = filter.statusCompleted;
        boolean statusUploadFailed = filter.statusUploadFailed;
        boolean probationStatusAll = filter.probationStatusAll;
        boolean probationStatusRegularEmployee = filter.probationStatusRegularEmployee;
        boolean probationStatusTerminateEmployee = filter.probationStatusTerminateEmployee;
        date startCreatedDate = filter.startCreatedDate;
        date endCreatedDate = filter.endCreatedDate;
        date startSectionHeadSubmittedDate = filter.startSectionHeadSubmittedDate;
        date endSectionHeadSubmittedDate = filter.endSectionHeadSubmittedDate;
        date startSectionHeadReassignedDate = filter.startSectionHeadReassignedDate;
        date endSectionHeadReassignedDate = filter.endSectionHeadReassignedDate;
        date startSectionHeadReassignedSubmittedDate = filter.startSectionHeadReassignedSubmittedDate;
        date endSectionHeadReassignedSubmittedDate = filter.endSectionHeadReassignedSubmittedDate;
        date startDepartmentHeadSubmittedDate = filter.startDepartmentHeadSubmittedDate;
        date endDepartmentHeadSubmittedDate = filter.endDepartmentHeadSubmittedDate;
        date startDepartmentHeadReassignedDate = filter.startDepartmentHeadReassignedDate;
        date endDepartmentHeadReassignedDate = filter.startDepartmentHeadReassignedDate;
        date startDepartmentHeadReassignedSubmittedDate = filter.startDepartmentHeadReassignedSubmittedDate;
        date endDepartmentHeadReassignedSubmittedDate = filter.endDepartmentHeadReassignedSubmittedDate;
        date startCompletedDate = filter.startCompletedDate;
        date endCompletedDate = filter.endCompletedDate;
        
        URL = URL + 'trackingReportType=' + trackingReportType + 
            		'&employeeId=' + employeeId + 
            		'&sectionHead=' + sectionHead + 
            		'&departmentHead=' + departmentHead + 
            		'&function=' + function + 
            		'&department=' + department + 
            		'&section=' + section + 
            		'&level=' + level + 
            		'&statusAll=' + statusAll + 
            		'&statusWaitingForApprovalSectionHead=' + statusWaitingForApprovalSectionHead + 
            		'&statusWaitingReassignSectionHead=' + statusWaitingReassignSectionHead + 
            		'&statusWaitingForApprovalDepartmentHead=' + statusWaitingForApprovalDepartmentHead + 
            		'&statusWaitingReassignDepartmentHead=' + statusWaitingReassignDepartmentHead + 
            		'&statusWaitingForUploadToPersonalFolder=' + statusWaitingForUploadToPersonalFolder + 
            		'&statusCompleted=' + statusCompleted + 
            		'&statusUploadFailed=' + statusUploadFailed + 
            		'&probationStatusAll=' + probationStatusAll + 
            		'&probationStatusRegularEmployee=' + probationStatusRegularEmployee + 
            		'&probationStatusTerminateEmployee=' + probationStatusTerminateEmployee + 
            		'&startCreatedDate=' + startCreatedDate + 
            		'&endCreatedDate=' + endCreatedDate + 
            		'&startSectionHeadSubmittedDate=' + startSectionHeadSubmittedDate + 
            		'&endSectionHeadSubmittedDate=' + endSectionHeadSubmittedDate + 
            		'&startSectionHeadReassignedDate=' + startSectionHeadReassignedDate + 
            		'&endSectionHeadReassignedDate=' + endSectionHeadReassignedDate + 
            		'&startSectionHeadReassignedSubmittedDate=' + startSectionHeadReassignedSubmittedDate + 
            		'&endSectionHeadReassignedSubmittedDate=' + endSectionHeadReassignedSubmittedDate + 
            		'&startDepartmentHeadSubmittedDate=' + startDepartmentHeadSubmittedDate + 
            		'&endDepartmentHeadSubmittedDate=' + endDepartmentHeadSubmittedDate + 
            		'&startDepartmentHeadReassignedDate=' + startDepartmentHeadReassignedDate + 
            		'&endDepartmentHeadReassignedDate=' + endDepartmentHeadReassignedDate + 
            		'&startDepartmentHeadReassignedSubmittedDate=' + startDepartmentHeadReassignedSubmittedDate + 
            		'&endDepartmentHeadReassignedSubmittedDate=' + endDepartmentHeadReassignedSubmittedDate + 
            		'&startCompletedDate=' + startCompletedDate + 
            		'&endCompletedDate=' + endCompletedDate;
        
        return URL;
    }
    
    //Assign to DTO section
    public static ESS_ProbationaryReport_DTO.ProbationTableDTO assignToProbationTableDTO(ESS_Probationary__c Probation) {
        
        ESS_ProbationaryReport_DTO.ProbationTableDTO ProbationTable = new ESS_ProbationaryReport_DTO.ProbationTableDTO();
        ProbationTable.recordId = Probation.Id;
        ProbationTable.documentNo = Probation.Document_No__c;
        ProbationTable.employeeId = Probation.Employee_ID__c;
        ProbationTable.employeeName = Probation.Employee_Name_EN__c;
        ProbationTable.dateJoinedCompany = Probation.Date_Joined_Company__c;
        ProbationTable.dateCompletedProbation = Probation.Date_Completed_Probation__c;
        
        ProbationTable.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
        if(Probation.Status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead)) {
            ProbationTable.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
        	ProbationTable.currentStatus.value = 'Waiting for Approval by Immediate Line / Section Head';
        }
        else if(Probation.Status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead)) {
            ProbationTable.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
        	ProbationTable.currentStatus.value = 'Waiting for Approval by Department Head';
        }
        else if(Probation.Status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder)) {
            ProbationTable.currentStatus.key = ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name();
        	ProbationTable.currentStatus.value = 'Waiting for upload to personal folder';
        }
        else if(Probation.Status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.UploadFailed)) {
            ProbationTable.currentStatus.key = ESS_Enum.ProbationApproveStatus.UploadFailed.name();
        	ProbationTable.currentStatus.value = 'Upload Failed';
        }
        else if(Probation.Status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.Completed)) {
            ProbationTable.currentStatus.key = ESS_Enum.ProbationApproveStatus.Completed.name();
        	ProbationTable.currentStatus.value = 'Completed';
        }
        
        ProbationTable.createdDate = Date.ValueOf(Probation.CreatedDate);
        
        if(string.isNotEmpty(Probation.Section_Head__c)) {
        	ProbationTable.sectionHead = Probation.Section_Head__c;    
        }
        else {
            ProbationTable.sectionHead = '';
        }
        
        ProbationTable.sectionHeadSubmittedDate = Probation.Section_Head_Approve_Date__c;
        
        if(string.isNotEmpty(Probation.Reassign_Section_Head_JSON__c)) {        
            List<ESS_Probationary_DTO.ReassignDTO> reassignsDTO = (List<ESS_Probationary_DTO.ReassignDTO>)JSON.deserialize(Probation.Reassign_Section_Head_JSON__c, List<ESS_Probationary_DTO.ReassignDTO>.class);
            if(reassignsDTO.size() > 0) { 
                ProbationTable.reassignSectionHead = reassignsDTO[reassignsDTO.size()-1].employeeId + ' - ' + reassignsDTO[reassignsDTO.size()-1].name;
			}
        }
        else {
            ProbationTable.reassignSectionHead = '';
        }

        ProbationTable.reassignSectionHeadSubmittedDate = Probation.Reassign_Section_Head_Approve_Date__c;
        ProbationTable.departmentHead = Probation.Department_Head__c;
        ProbationTable.departmentHeadSubmittedDate = Probation.Department_Head_Approve_Date__c;
        
        if(string.isNotEmpty(Probation.Reassign_Department_Head_JSON__c)) {
            List<ESS_Probationary_DTO.ReassignDTO> reassignsDTO = (List<ESS_Probationary_DTO.ReassignDTO>)JSON.deserialize(Probation.Reassign_Department_Head_JSON__c, List<ESS_Probationary_DTO.ReassignDTO>.class);
            if(reassignsDTO.size() > 0) { 
                ProbationTable.reassignDepartmentHead = reassignsDTO[reassignsDTO.size()-1].employeeId + ' - ' + reassignsDTO[reassignsDTO.size()-1].name;
			}
        }
        else {
            ProbationTable.reassignDepartmentHead = '';
        }
        
        ProbationTable.reassignDepartmentHeadSubmittedDate = Probation.Reassign_Department_Head_Approve_Date__c;
        ProbationTable.completedDate = Probation.Completed_Date__c;
        
        ProbationTable.probationStatus = new ESS_Global.EnumValue('ProbationStatus');
        if(Probation.Probation_Status__c == String.ValueOf(ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee)) {
            ProbationTable.probationStatus.key = ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name();
        	ProbationTable.probationStatus.value = 'Confirm to Regular Employee';
        }
        else if(Probation.Probation_Status__c == String.ValueOf(ESS_Enum.ProbationStatus.TerminateEmployee)) {
            ProbationTable.probationStatus.key = ESS_Enum.ProbationStatus.TerminateEmployee.name();
        	ProbationTable.probationStatus.value = 'Terminate Employee';
        }
        
        if(string.isNotEmpty(Probation.approval_history_json__c)) {
            ProbationTable.approvalHistories = DeserializeHistoryWorkflows(Probation.approval_history_json__c);
        }
        
        ProbationTable.function = Probation.Function__c;
        ProbationTable.department = Probation.Department__c;
        ProbationTable.section = Probation.Section__c;
        ProbationTable.unit = Probation.Unit__c;
        ProbationTable.level = Probation.Level__c;
        
        return ProbationTable;
        
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
    
    @TestVisible
    private static List<ESS_ProbationaryReport_DTO.ApprovalHistoryDTO> DeserializeHistoryWorkflows(string historyJSON) {
        List<ESS_ProbationaryReport_DTO.ApprovalHistoryDTO> approvalHistoriesDTO = (List<ESS_ProbationaryReport_DTO.ApprovalHistoryDTO>)JSON.deserialize(historyJSON, List<ESS_ProbationaryReport_DTO.ApprovalHistoryDTO>.class);
		return approvalHistoriesDTO;
    }
    
    public class ProbationSearchCriteria {
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string sectionHead {get;set;}
        @RemoteAction
        public string departmentHead {get;set;}
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
        public boolean statusWaitingForApprovalSectionHead {get;set;}
        @RemoteAction
        public boolean statusWaitingReassignSectionHead {get;set;}
        @RemoteAction
        public boolean statusWaitingForApprovalDepartmentHead {get;set;}
        @RemoteAction
        public boolean statusWaitingReassignDepartmentHead {get;set;}
        @RemoteAction
        public boolean statusWaitingForUploadToPersonalFolder {get;set;}
        @RemoteAction
        public boolean statusUploadFailed {get;set;}
        @RemoteAction
        public boolean statusCompleted {get;set;}
        @RemoteAction
        public boolean probationStatusAll {get;set;}
        @RemoteAction
        public boolean probationStatusRegularEmployee {get;set;}
        @RemoteAction
        public boolean probationStatusTerminateEmployee {get;set;}
        @RemoteAction
        public date startCreatedDate {get;set;}
        @RemoteAction
        public date endCreatedDate {get;set;}
        @RemoteAction
        public date startSectionHeadSubmittedDate {get;set;}
        @RemoteAction
        public date endSectionHeadSubmittedDate {get;set;}
        @RemoteAction
        public date startSectionHeadReassignedDate {get;set;}
        @RemoteAction
        public date endSectionHeadReassignedDate {get;set;}
        @RemoteAction
        public date startSectionHeadReassignedSubmittedDate {get;set;}
        @RemoteAction
        public date endSectionHeadReassignedSubmittedDate {get;set;}
        @RemoteAction
        public date startDepartmentHeadSubmittedDate {get;set;}
        @RemoteAction
        public date endDepartmentHeadSubmittedDate {get;set;}
        @RemoteAction
        public date startDepartmentHeadReassignedDate {get;set;}
        @RemoteAction
        public date endDepartmentHeadReassignedDate {get;set;}
        @RemoteAction
        public date startDepartmentHeadReassignedSubmittedDate {get;set;}
        @RemoteAction
        public date endDepartmentHeadReassignedSubmittedDate {get;set;}
        @RemoteAction
        public date startCompletedDate {get;set;}
        @RemoteAction
        public date endCompletedDate {get;set;}
    }
    
}