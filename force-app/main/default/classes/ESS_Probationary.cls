/* Author Softever */
global with sharing class ESS_Probationary {
    
    private static List<ESS_Probationary_DTO.ProbationaryListDTO> probationaryLists;
    private static List<ESS_Probationary_DTO.ProbationaryApproveListDTO> probationaryApproveLists;
    private static ESS_Probationary_DTO.ProbationaryDetailDTO probationaryDetail;
    public static List<ProbationaryListSortDTO> probationarySortLists;
    
    static {
    }
    
    @RemoteAction
    public static integer GetProbationaryListsCount() {
        
        List<ESS_Master_Employee__c> Employees = new List<ESS_Master_Employee__c>();
        
        date todayDate = system.Date.today();
        
        Set<string> employeeIds = new Set<string>();
        List<ESS_Probationary__c> Probationaries = [select id, employee_id__c from ESS_Probationary__c];
        
        if(Probationaries.size() > 0) {
            for(ESS_Probationary__c Probation : Probationaries) {
                employeeIds.add(Probation.Employee_Id__c);
            }
        }
        
        string data = 'IN';
        string query = 'select id, Employee_ID__c, Employee_Date_Joined__c, Probationary_Date__c, Probation_Section_Head_Skip__c, Probation_Section_Head_Id__c, Probation_Section_Head_Name__c, Probation_Section_Head_Position__c, Probation_VP_Id__c, Probation_VP_Name__c, Probation_VP_Position__c, CEP__c, Probation_Section_Head_TH__c, Probation_VP_TH__c, Probation_Completed__c from ESS_Master_Employee__c where data__c =: data AND Employee_Date_Joined__c != null AND Need_Probation__c = true AND employee_id__c NOT IN: employeeIds AND Probation_Completed__c = false order by employee_id__c asc';
         
        Employees = database.query(query);
        
        List<ESS_Probationary__c> allProbations = allProbations();
            
        integer totalProbation = 0;
            
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND User__c != null];
            
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        Map<string, PISUsers__c> mapPOSIDPISUsers = new Map<string, PISUsers__c>();
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                mapPOSIDPISUsers.put(PISUser.POSID__c, PISUser);
                
                if(PISUser.MAINPOSITION__c) {
                    mapPISUsers.put(PISUser.EMPLOYEEID__c, PISUser);
                }
            }    
        }  
        
        if(Employees.size() > 0) {
            for(ESS_Master_Employee__c Master : Employees) {
                ESS_Probationary_DTO.ProbationaryListDTO assign = new ESS_Probationary_DTO.ProbationaryListDTO();
                PISUsers__c PISUser = mapPISUsers.get(Master.Employee_ID__c);
                if(PISUser != null) {
                    totalProbation++;
                }
            }
        }        
        
        return totalProbation;
        
    }
    
    @RemoteAction
    public static List<ESS_Probationary_DTO.ProbationaryListDTO> GetProbationaryLists(
        //dateStamp, employeeId, employeeName, level, dateJoinedCompany, dateCompletedProbation, sectionHead, departmentHead, CEP, function, department, section, unit
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        date todayDate = system.Date.today();
        
        List<ESS_Probationary_DTO.ProbationaryListDTO> results = new List<ESS_Probationary_DTO.ProbationaryListDTO>();
        probationarySortLists = new List<ProbationaryListSortDTO>();
        List<ESS_Master_Employee__c> Employees = new List<ESS_Master_Employee__c>();
        
        Set<string> employeeIds = new Set<string>();
        List<ESS_Probationary__c> Probationaries = [select id, employee_id__c from ESS_Probationary__c];
        
        if(Probationaries.size() > 0) {
            for(ESS_Probationary__c Probation : Probationaries) {
                employeeIds.add(Probation.Employee_Id__c);
            }
        }
        
        string data = 'IN';
        string query = 'select id, Employee_ID__c, Employee_Date_Joined__c, Probationary_Date__c, Probation_Section_Head_Skip__c, Probation_Section_Head_Id__c, Probation_Section_Head_Name__c, Probation_Section_Head_Position__c, Probation_VP_Id__c, Probation_VP_Name__c, Probation_VP_Position__c, CEP__c, Probation_Section_Head_TH__c, Probation_VP_TH__c, Probation_Completed__c from ESS_Master_Employee__c where data__c =: data AND Employee_Date_Joined__c != null AND Need_Probation__c = true AND employee_id__c NOT IN: employeeIds AND Probation_Completed__c = false order by employee_id__c asc ';
         
        Employees = database.query(query);
        
        List<ESS_Probationary__c> allProbations = allProbations();
            
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND User__c != null];
            
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        Map<string, PISUsers__c> mapPOSIDPISUsers = new Map<string, PISUsers__c>();
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                mapPOSIDPISUsers.put(PISUser.POSID__c, PISUser);
                
                if(PISUser.MAINPOSITION__c) {
                    mapPISUsers.put(PISUser.EMPLOYEEID__c, PISUser);
                }
            }    
        }    
            
        List<ESS_Master_Employee__c> finalEmployees = new List<ESS_Master_Employee__c>();
        if(Employees.size() > 0) {
            for(ESS_Master_Employee__c Master : Employees) {
                PISUsers__c PISUser = mapPISUsers.get(Master.Employee_ID__c);
                if(PISUser != null) {
                    finalEmployees.add(Master);
                }
            }        
        }
            
        if(finalEmployees.size() > 0) {
            for(ESS_Master_Employee__c Master : finalEmployees) {
                ProbationaryListSortDTO assign = new ProbationaryListSortDTO();
                PISUsers__c PISUser = mapPISUsers.get(Master.Employee_ID__c);
                assign = assignToProbationaryListSortDTO(Master, mapPOSIDPISUsers, mapPISUsers, allProbations);
                probationarySortLists.add(assign);
            }     
        }
         
        //Custom Sort By      
        if(sortByParam.sortBy == 'dateStamp') {
            if(sortByParam.ascending) {
                sortByDateStampDesc = false;
                sortByDateStamp(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByDateStampDesc = true;
                sortByDateStamp(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'employeeId') {
            if(sortByParam.ascending) {
                sortByEmployeeIdDesc = false;
                sortByEmployeeId(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByEmployeeIdDesc = true;
                sortByEmployeeId(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'employeeNameEN') {
            if(sortByParam.ascending) {
                sortByEmployeeNameDesc = false;
                sortByEmployeeName(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByEmployeeNameDesc = true;
                sortByEmployeeName(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'level') {
            if(sortByParam.ascending) {
                sortByLevelDesc = false;
                sortByLevel(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByLevelDesc = true;
                sortByLevel(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'dateJoinedCompany') {
            if(sortByParam.ascending) {
                sortByDateJoinedCompanyDesc = false;
                sortByDateJoinedCompany(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByDateJoinedCompanyDesc = true;
                sortByDateJoinedCompany(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'dateCompletedProbation') {
            if(sortByParam.ascending) {
                sortByDateCompletedProbationDesc = false;
                sortByDateCompletedProbation(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByDateCompletedProbationDesc = true;
                sortByDateCompletedProbation(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'sectionHead') {
            if(sortByParam.ascending) {
                sortBySectionHeadNameDesc = false;
                sortBySectionHeadName(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortBySectionHeadNameDesc = true;
                sortBySectionHeadName(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'departmentHead') {
            if(sortByParam.ascending) {
                sortByDepartmentHeadNameDesc = false;
                sortByDepartmentHeadName(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByDepartmentHeadNameDesc = true;
                sortByDepartmentHeadName(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'cep') {
            if(sortByParam.ascending) {
                sortByCEPDesc = false;
                sortByCEP(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByCEPDesc = true;
                sortByCEP(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'function') {
            if(sortByParam.ascending) {
                sortByFunctionDesc = false;
                sortByFunction(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByFunctionDesc = true;
                sortByFunction(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'department') {
            if(sortByParam.ascending) {
                sortByDepartmentDesc = false;
                sortByDepartment(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByDepartmentDesc = true;
                sortByDepartment(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'section') {
            if(sortByParam.ascending) {
                sortBySectionDesc = false;
                sortBySection(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortBySectionDesc = true;
                sortBySection(probationarySortLists);
            }
        }
        else if(sortByParam.sortBy == 'unit') {
            if(sortByParam.ascending) {
                sortByUnitDesc = false;
                sortByUnit(probationarySortLists);
            }
            else if(!sortByParam.ascending) {
                sortByUnitDesc = true;
                sortByUnit(probationarySortLists);
            }
        }
        else {
            sortByEmployeeIdDesc = false;
            sortByEmployeeId(probationarySortLists);
        }
        
        
        Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
        Integer totalSize = probationarySortLists.size() - startIndex;
        for (Integer i = 0; i < pageParam.pageSize; i++ ) {
            if (i < totalSize){
                ESS_Probationary_DTO.ProbationaryListDTO assign = new ESS_Probationary_DTO.ProbationaryListDTO();
                assign = convertToProbationaryListDTO(probationarySortLists[startIndex + i]);
                results.add(assign);
            }else{
                break;
            }
        }
            
        return results;
            
    }
    
    @RemoteAction
    public static integer GetProbationaryApproveListsCount(boolean allStatus) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
          
        boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
          
        List<ESS_Probationary__c> Probationaries = new List<ESS_Probationary__c>();
        
        string query = 'select id, ownerid, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, submitted_date__c, ' +
                        ' status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c, ' +
                        ' completed_date__c, probation_status__c, Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, reassign_section_head_json__c, reassign_department_head_json__c from ESS_Probationary__c'; //where (section_head_id__c =: userId OR department_head_id__c =: userId OR ownerId =: userId OR Reassign_Section_Head_Id__c =: userId OR Reassign_Department_Head_Id__c =: userId)
              
        if(isAdmin) {
            query = 'select id, ownerid, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, submitted_date__c, ' +
                        ' status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c, ' +
                        ' completed_date__c, probation_status__c, Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, reassign_section_head_json__c, reassign_department_head_json__c from ESS_Probationary__c';
        } 
         
        List<string> statuses = new List<string>();
        if(allStatus) {
        	statuses = new List<string> {
                ESS_Enum.ProbationApproveStatus.Draft.name(),
                ESS_Enum.ProbationApproveStatus.Reassigned.name(),
                ESS_Enum.ProbationApproveStatus.Rejected.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name(),
                ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name(),
                ESS_Enum.ProbationApproveStatus.Submitted.name(),
                ESS_Enum.ProbationApproveStatus.Completed.name(),
                ESS_Enum.ProbationApproveStatus.UploadFailed.name()
            };
            query = query + ' where status__c IN :statuses';
        }
        else {
            query = query + ' where (section_head_id__c =: userId OR department_head_id__c =: userId OR ownerId =: userId OR Reassign_Section_Head_Id__c =: userId OR Reassign_Department_Head_Id__c =: userId)';
            
            statuses = new List<string> {
                ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()
            };
            query = query + ' AND status__c IN :statuses';
        }
        
        query += ' order by createddate desc';
        Probationaries = database.query(query);
        
        integer probationSize = 0;
        if(Probationaries.size() > 0) {
            for(ESS_Probationary__c Probation : Probationaries) {
                
                boolean isReassignSectionHead = false;
                if(string.isNotEmpty(Probation.Reassign_Section_Head_JSON__c)) {
                    isReassignSectionHead = isReassignSectionHead(Probation.Reassign_Section_Head_JSON__c, userId);
                }
                
                boolean isReassignDepartmentHead = false;
                if(string.isNotEmpty(Probation.Reassign_Department_Head_JSON__c)) {
                    isReassignDepartmentHead = isReassignDepartmentHead(Probation.Reassign_Department_Head_JSON__c, userId);
                }
                
                if(allStatus && isAdmin) {
                    probationSize++;
                }
                else if(allStatus && !isAdmin) {
                    if((Probation.OwnerId == userId) || 
                       (Probation.Section_Head_Id__c == userId) || 
                       (Probation.Department_Head_Id__c == userId) ||
                       (Probation.Reassign_Section_Head_Id__c == userId) || 
                       (Probation.Reassign_Department_Head_Id__c == userId) ||
                      	isReassignSectionHead || isReassignDepartmentHead) {
                    	probationSize++;
                    }
                }
                else {
                    boolean isShowRecord = false;
                    if(Probation.OwnerId == userId) {
                    	isShowRecord = true;
                    }
                    else if(Probation.Section_Head_Id__c == userId && Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
                        isShowRecord = true;
                    }
                    else if(Probation.Department_Head_Id__c == userId && Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                        isShowRecord = true;
                    }
                    else if(Probation.Reassign_Section_Head_Id__c == userId && Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
                        isShowRecord = true;
                    }
                    else if(Probation.Reassign_Department_Head_Id__c == userId && Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
                        isShowRecord = true;
                    }
                    else if(isReassignSectionHead || isReassignDepartmentHead) {
                        isShowRecord = true;
                    }
                    
                    if(isShowRecord) {
                        probationSize++;
                    }
                }
            }
        }
        
        return probationSize;
    }
    
    @RemoteAction
    public static List<ESS_Probationary_DTO.ProbationaryApproveListDTO> GetProbationaryApproveLists(
        boolean allStatus,
        //documentNo, employeeId, employeeName, dateJoinedCompany, dateCompletedProbation, submittedDate, currentStatus, sectionHead, sectionHeadSubmittedDate, departmentHead, departmentHeadSubmittedDate, completedDate, probationStatus
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
        
        List<ESS_Probationary_DTO.ProbationaryApproveListDTO> results = new List<ESS_Probationary_DTO.ProbationaryApproveListDTO>();
        List<ESS_Probationary_DTO.ProbationaryApproveListDTO> finals = new List<ESS_Probationary_DTO.ProbationaryApproveListDTO>();
        
        List<ESS_Probationary__c> Probationaries = new List<ESS_Probationary__c>();
        
        string query = 'select id, ownerid, document_no__c, employee_id__c, employee_name__c, employee_name_en__c, date_joined_company__c, date_completed_probation__c, submitted_date__c, ' +
                        ' status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c, ' +
                        ' completed_date__c, probation_status__c, Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, reassign_section_head_json__c, reassign_department_head_json__c from ESS_Probationary__c '; //where (section_head_id__c =: userId OR department_head_id__c =: userId OR ownerId =: userId OR Reassign_Section_Head_Id__c =: userId OR Reassign_Department_Head_Id__c =: userId)'
           
        if(isAdmin) {
            query = 'select id, ownerid, document_no__c, employee_id__c, employee_name__c, employee_name_en__c, date_joined_company__c, date_completed_probation__c, submitted_date__c, ' +
                        ' status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c, ' +
                        ' completed_date__c, probation_status__c, Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, reassign_section_head_json__c, reassign_department_head_json__c from ESS_Probationary__c ';
        } 
         
        List<string> statuses = new List<string>();
        if(allStatus) {
        	statuses = new List<string> {
                ESS_Enum.ProbationApproveStatus.Draft.name(),
                ESS_Enum.ProbationApproveStatus.Reassigned.name(),
                ESS_Enum.ProbationApproveStatus.Rejected.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name(),
                ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name(),
                ESS_Enum.ProbationApproveStatus.Submitted.name(),
                ESS_Enum.ProbationApproveStatus.Completed.name(),
                ESS_Enum.ProbationApproveStatus.UploadFailed.name()
            };
            query = query + ' where status__c IN :statuses';
        }
        else {
            query = query + ' where (section_head_id__c =: userId OR department_head_id__c =: userId OR ownerId =: userId OR Reassign_Section_Head_Id__c =: userId OR Reassign_Department_Head_Id__c =: userId)';
            statuses = new List<string> {
                ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name(),
                ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()
            };
            query = query + ' AND status__c IN :statuses';
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
        else if(sortByParam.sortBy == 'submittedDate') {
            if(sortByParam.ascending) {
                query += ' order by submitted_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by submitted_date__c desc';
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
                query += ' order by section_head_approve_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by section_head_approve_date__c desc';
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
                query += ' order by department_head_approve_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by department_head_approve_date__c desc';
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
        else if(sortByParam.sortBy == 'probationStatus') {
            if(sortByParam.ascending) {
                query += ' order by probation_status__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by probation_status__c desc';
            }
        }
        else {
            query += ' order by createddate desc';
        }
            
        integer pageRecord = 0;
        integer startIndex = 0;
        integer endIndex = 0;
        
        if (pageParam != null) {
            if (pageParam.pageNo != 0 && pageParam.pageSize != 0) {
                 integer offset = (pageParam.pageNo - 1) * pageParam.pageSize;
                 integer pageSize = pageParam.pageSize;
                 if(offset == 0) {
                     startIndex = 0;
                     endIndex = pageSize - 1;
                 }
                 else {
                     startIndex = offset;
                     endIndex = (pageSize + offset) - 1;
                 }
            }
        }
            
        List<ESS_Probationary__c> models = Database.query(query);
        if(models.size() > 0) {
                
            for(ESS_Probationary__c Probation : models) {
                
                boolean isReassignSectionHead = false;
                if(string.isNotEmpty(Probation.Reassign_Section_Head_JSON__c)) {
                    isReassignSectionHead = isReassignSectionHead(Probation.Reassign_Section_Head_JSON__c, userId);
                }
                
                boolean isReassignDepartmentHead = false;
                if(string.isNotEmpty(Probation.Reassign_Department_Head_JSON__c)) {
                    isReassignDepartmentHead = isReassignDepartmentHead(Probation.Reassign_Department_Head_JSON__c, userId);
                }
                
                if(allStatus && isAdmin) {
                    results.add(assignToProbationaryApproveListDTO(Probation));
                }
                else if(allStatus && !isAdmin) {
                    if((Probation.OwnerId == userId) || 
                       (Probation.Section_Head_Id__c == userId) || 
                       (Probation.Department_Head_Id__c == userId) ||
                       (Probation.Reassign_Section_Head_Id__c == userId) || 
                       (Probation.Reassign_Department_Head_Id__c == userId) ||
                       isReassignSectionHead || isReassignDepartmentHead) {
                           results.add(assignToProbationaryApproveListDTO(Probation));
                       }
                }
                else {
                    boolean isShowRecord = false;
                    if(Probation.OwnerId == userId) {
                        isShowRecord = true;
                    }
                    else if(Probation.Section_Head_Id__c == userId && Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
                        isShowRecord = true;
                    }
                    else if(Probation.Department_Head_Id__c == userId && Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                        isShowRecord = true;
                    }
                    else if(Probation.Reassign_Section_Head_Id__c == userId && Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
                        isShowRecord = true;
                    }
                    else if(Probation.Reassign_Department_Head_Id__c == userId && Probation.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
                        isShowRecord = true;
                    }
                    else if(isReassignSectionHead || isReassignDepartmentHead) {
                        isShowRecord = true;
                    }
                    
                    if(isShowRecord) {
                        results.add(assignToProbationaryApproveListDTO(Probation));
                    }        
                }
            }
            
            if(results.size() > 0) {
                integer actualWithdraw = results.size() - 1;
                if(endIndex >= actualWithdraw) {
                    endIndex = actualWithdraw;
                }
                for(integer i=startIndex; i<=endIndex; i++) {
                    finals.add(results[i]);
                }
            }
        }
        
        return finals;
            
    }
    
    
    @RemoteAction
    public static ESS_Probationary_DTO.ProbationaryDetailDTO GetProbationaryDetail(string probationaryId) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        string employeeId;
        
        PISUsers__c PISUser = new PISUsers__c();
        User User = new User();
        boolean isPRTRUser = ESS_Global.checkPRTRUser(userId);
        if(isPRTRUser) {
            User = ESS_Global.assignToUser(userId);
        	employeeId = User.Employee_Id__c;
        }
        else {
            PISUser = ESS_Global.assignToPISUser(userId);
        	employeeId = PISUser.EMPLOYEEID__c;
        }
        
        boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
        isAdmin = false;
        probationaryDetail = new ESS_Probationary_DTO.ProbationaryDetailDTO();
        
        if(string.isNotEmpty(probationaryId)) {
            
            ESS_Probationary__c probationary = [select id, ownerId, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, submitted_date__c,
                                            status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c,
                                            completed_date__c, section__c, department__c, quality_of_work__c, quantity_of_work__c, safety_awareness__c, knowledge_skills__c, reliability__c, 
                                            attitude__c, section_head_comment__c, engineering_license__c, recommendation__c, recommendation_comment__c, probation_confirmation__c,
                                            probation_confirmation_comment__c, confirm_cep__c, propose_cep__c, cep_confirmation_comment__c, department_head_comment__c, approval_history_json__c,
                                            Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, Section_Head_Position__c, Department_Head_Position__c, Company_Name__c, Section_Head_Flow__c, 
                                            Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, cep_confirmation__c, employee_name_en__c from ESS_Probationary__c where id =: probationaryId];
        
            probationaryDetail = assignToProbationaryDetailDTO(probationary);
        
            //Disable Button for Admin
            if(isAdmin && userId != probationary.OwnerId) {
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
            }
        }
        else {
            
            ESS_Probationary__c probationary = [select id, ownerId, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, submitted_date__c,
                                            status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c,
                                            completed_date__c, section__c, department__c, quality_of_work__c, quantity_of_work__c, safety_awareness__c, knowledge_skills__c, reliability__c, 
                                            attitude__c, section_head_comment__c, engineering_license__c, recommendation__c, recommendation_comment__c, probation_confirmation__c,
                                            probation_confirmation_comment__c, confirm_cep__c, propose_cep__c, cep_confirmation_comment__c, department_head_comment__c, approval_history_json__c,
                                            Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, Section_Head_Position__c, Department_Head_Position__c, Company_Name__c, Section_Head_Flow__c,
                                            Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, cep_confirmation__c 
                                            from ESS_Probationary__c where employee_id__c =: employeeId];
        
            probationaryDetail = assignToProbationaryDetailDTO(probationary);
        
        }
        
        return probationaryDetail;
    }
    
    @RemoteAction
    public static ESS_Probationary_DTO.ProbationaryDetailDTO SaveProbationary(ESS_Probationary_DTO.ProbationaryDetailDTO probationDetail) {
        
        ESS_Probationary__c probationary = [select id, lastmodifieddate from ESS_Probationary__c where id =: probationDetail.probationId];
        
        datetime currentDT = system.Datetime.now();
        string currentStatus = ProbationCurrentStatus(probationDetail.probationId);
        
        if(probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name() || 
            probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
            
            if(currentStatus == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name() &&
               probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be save.');
            }
            else if(currentStatus == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name() &&
                    probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be save.');
            }
            else if(currentStatus == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name() &&
               probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be save.');
            }
                
            probationary.quantity_of_work__c = probationDetail.quantityOfWork.key;
            probationary.Quality_of_Work__c = probationDetail.qualityOfWork.key;
            probationary.Safety_Awareness__c = probationDetail.safetyAwareness.key;
            probationary.Knowledge_Skills__c = probationDetail.knowledgeSkills.key;
            probationary.Reliability__c = probationDetail.reliability.key;
            probationary.Attitude__c = probationDetail.attitude.key;
            probationary.Section_Head_Comment__c = probationDetail.sectionHeadComment;
            probationary.Engineering_License__c = probationDetail.engineeringLicense.key;
            probationary.Recommendation__c = probationDetail.recommendation.key;
            probationary.Recommendation_Comment__c = probationDetail.recommendationComment;
             
        }
        else if(probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name() ||
                probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
            
            if(currentStatus == ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name() &&
               probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be save.');
            }
            else if(currentStatus == ESS_Enum.ProbationApproveStatus.Completed.name() &&
               probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be save.');
            }
            else if(currentStatus == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name() &&
               probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be save.');
            }
            else if(currentStatus == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name() &&
               probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be save.');
            }
            else if(currentStatus == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name() &&
               probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be save.');
            }
            
            probationary.quantity_of_work__c = probationDetail.quantityOfWork.key;
            probationary.Quality_of_Work__c = probationDetail.qualityOfWork.key;
            probationary.Safety_Awareness__c = probationDetail.safetyAwareness.key;
            probationary.Knowledge_Skills__c = probationDetail.knowledgeSkills.key;
            probationary.Reliability__c = probationDetail.reliability.key;
            probationary.Attitude__c = probationDetail.attitude.key;
            probationary.Section_Head_Comment__c = probationDetail.sectionHeadComment;
            probationary.Engineering_License__c = probationDetail.engineeringLicense.key;
            probationary.Recommendation__c = probationDetail.recommendation.key;
            probationary.Recommendation_Comment__c = probationDetail.recommendationComment;
            probationary.Probation_Confirmation__c = probationDetail.probationConfirmation.key;
            probationary.Probation_Confirmation_Comment__c = probationDetail.probationConfirmationComment;
            probationary.Confirm_CEP__c = probationDetail.cepFinalInterview;
            probationary.Propose_CEP__c = probationDetail.cepPropose;
            probationary.CEP_Confirmation__c = probationDetail.cepConfirmation.key;       
            probationary.CEP_Confirmation_Comment__c = probationDetail.cepComment;
            probationary.Department_Head_Comment__c = probationDetail.departmentHeadComment;
                    
            if(probationary.Probation_Confirmation__c == ESS_Enum.ProbationDepartmentHeadConfirmation.Confirm.name()) {
                probationary.Probation_Status__c = ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name();            
            }
            else if(probationary.Probation_Confirmation__c == ESS_Enum.ProbationDepartmentHeadConfirmation.Terminate.name()) {
                probationary.Probation_Status__c = ESS_Enum.ProbationStatus.TerminateEmployee.name();            
            }
                    
        }
        
        update(probationary);
        
        return probationDetail;
    }
    
    @RemoteAction
    public static ESS_Probationary_DTO.ProbationaryDetailDTO SubmitProbationary(ESS_Probationary_DTO.ProbationaryDetailDTO probationDetail, string comment) {
        
        ESS_Probationary__c probationary = [select id, OwnerId, Owner.Name, Document_No__c, Employee_ID__c, Employee_Name__c, CreatedDate, Section_Head_Approve_Date__c, Section_Head__c, Section_Head_Employee_Id__c, Section_Head_Id__c, Section_Head_Position__c, Approval_History_JSON__c, Reassign_Section_Head_JSON__c,
                                            Department_Head__c, Department_Head_Employee_Id__c, Department_Head_Approve_Date__c, Department_Head_Id__c, Department_Head_Position__c, Reassign_Department_Head_JSON__c,
                                            Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, Probation_Confirmation__c, Employee_Name_EN__c from ESS_Probationary__c where id =: probationDetail.probationId];
        
        string currentStatus = ProbationCurrentStatus(probationDetail.probationId);
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND Mainposition__c = true AND User__c != null];
            
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {                
                mapPISUsers.put(PISUser.User__c, PISUser);
            }    
        }
        
        List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
        
        if(probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
            
            if(currentStatus != ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be submit.');
            }
            
            probationary.status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            probationary.quantity_of_work__c = probationDetail.quantityOfWork.key;
            probationary.Quality_of_Work__c = probationDetail.qualityOfWork.key;
            probationary.Safety_Awareness__c = probationDetail.safetyAwareness.key;
            probationary.Knowledge_Skills__c = probationDetail.knowledgeSkills.key;
            probationary.Reliability__c = probationDetail.reliability.key;
            probationary.Attitude__c = probationDetail.attitude.key;
            probationary.Section_Head_Comment__c = probationDetail.sectionHeadComment;
            probationary.Engineering_License__c = probationDetail.engineeringLicense.key;
            probationary.Recommendation__c = probationDetail.recommendation.key;
            probationary.Recommendation_Comment__c = probationDetail.recommendationComment;
            probationary.Section_Head_Approve_Date__c = date.today();
            
            probationary.Section_Head_Reminder__c = null;
            //Find out Department Head Reminder
            probationary.Department_Head_Reminder__c = emailReminders();
            
            //Approval History
            ESS_Probationary_DTO.ApprovalHistoryDTO History = new ESS_Probationary_DTO.ApprovalHistoryDTO();
            History.name = probationary.Section_Head__c;
            History.position = probationary.Section_Head_Position__c;
            History.submittedDate = date.today();
            
            History.status = new ESS_Global.EnumValue('ProbationApproveStatus');
            History.status.key = ESS_Enum.ProbationApproveStatus.Submitted.name();
            History.status.value = 'Submitted';
            
            History.comment = comment;
            
            probationary.Approval_History_JSON__c = JSON.serialize(assignToApprovalHistory(History, probationary.Approval_History_JSON__c));
            
            //Send email to department head
            Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ProbationSendToDepartmentHeadWhenSectionHeadSubmitted(probationary, mapPISUsers);
        	sendEmails.add(sendEmail);
        }
        else if(probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
            
            if(currentStatus != ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be submit.');
            }
            
            probationary.status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            probationary.quantity_of_work__c = probationDetail.quantityOfWork.key;
            probationary.Quality_of_Work__c = probationDetail.qualityOfWork.key;
            probationary.Safety_Awareness__c = probationDetail.safetyAwareness.key;
            probationary.Knowledge_Skills__c = probationDetail.knowledgeSkills.key;
            probationary.Reliability__c = probationDetail.reliability.key;
            probationary.Attitude__c = probationDetail.attitude.key;
            probationary.Section_Head_Comment__c = probationDetail.sectionHeadComment;
            probationary.Engineering_License__c = probationDetail.engineeringLicense.key;
            probationary.Recommendation__c = probationDetail.recommendation.key;
            probationary.Recommendation_Comment__c = probationDetail.recommendationComment;

            probationary.Reassign_Section_Head_Reminder__c = null;
            //Find out Section Head Reminder
            probationary.Section_Head_Reminder__c = emailReminders();
            
            probationary.Reassign_Section_Head_Id__c = '';
            probationary.Reassign_Section_Head_Approve_Date__c = date.today();
            
            //Get Reassign person
            if(string.isnotempty(probationary.Reassign_Section_Head_JSON__c)) {
                List<ESS_Probationary_DTO.ReassignDTO> reassignDTOs = DeserializeReassigns(probationary.Reassign_Section_Head_JSON__c);
                if(reassignDTOs.size() > 0) {
                    integer position = reassignDTOs.size() - 1;
                    reassignDTOs[position].submittedDate = date.today();
                    probationary.Reassign_Section_Head_JSON__c = JSON.serialize(reassignDTOs);
                    
                    //Approval History
                    ESS_Probationary_DTO.ApprovalHistoryDTO History = new ESS_Probationary_DTO.ApprovalHistoryDTO();
                    History.name = reassignDTOs[position].employeeId + ' - ' + reassignDTOs[position].name;
                    History.position = reassignDTOs[position].position;
                    History.submittedDate = date.today();
                    
                    History.status = new ESS_Global.EnumValue('ProbationApproveStatus');
                    History.status.key = ESS_Enum.ProbationApproveStatus.Submitted.name();
                    History.status.value = 'Submitted';
                    
                    History.comment = comment;
                    
                    probationary.Approval_History_JSON__c = JSON.serialize(assignToApprovalHistory(History, probationary.Approval_History_JSON__c));
            
                }
            }

            //Send email to section head
            Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ProbationSendToSectionHeadWhenCreated(probationary, mapPISUsers);       
        	sendEmails.add(sendEmail);
        }
        else if(probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
            
            if(currentStatus != ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be submit.');
            }
            
            probationary.Section_Head_Reminder__c = null;
            probationary.Department_Head_Reminder__c = null;
            probationary.Reassign_Section_Head_Reminder__c = null;
            probationary.Reassign_Department_Head_Reminder__c = null;
            probationary.status__c = ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name();
            
            //Section Head section
            probationary.quantity_of_work__c = probationDetail.quantityOfWork.key;
            probationary.Quality_of_Work__c = probationDetail.qualityOfWork.key;
            probationary.Safety_Awareness__c = probationDetail.safetyAwareness.key;
            probationary.Knowledge_Skills__c = probationDetail.knowledgeSkills.key;
            probationary.Reliability__c = probationDetail.reliability.key;
            probationary.Attitude__c = probationDetail.attitude.key;
            probationary.Section_Head_Comment__c = probationDetail.sectionHeadComment;
            probationary.Engineering_License__c = probationDetail.engineeringLicense.key;
            probationary.Recommendation__c = probationDetail.recommendation.key;
            probationary.Recommendation_Comment__c = probationDetail.recommendationComment;
            
            probationary.Probation_Confirmation__c = probationDetail.probationConfirmation.key;
            probationary.Probation_Confirmation_Comment__c = probationDetail.probationConfirmationComment;
            probationary.Confirm_CEP__c = probationDetail.cepFinalInterview;
            probationary.Propose_CEP__c = probationDetail.cepPropose;
            probationary.CEP_Confirmation__c = probationDetail.cepConfirmation.key;
            probationary.CEP_Confirmation_Comment__c = probationDetail.cepComment;
            probationary.Department_Head_Comment__c = probationDetail.departmentHeadComment;
            
            probationary.Department_Head_Approve_Date__c = date.today();
            
            //Approval History
            ESS_Probationary_DTO.ApprovalHistoryDTO History = new ESS_Probationary_DTO.ApprovalHistoryDTO();
            History.name = probationary.Department_Head__c;
            History.position = probationary.Department_Head_Position__c;
            History.submittedDate = date.today();
            
            History.status = new ESS_Global.EnumValue('ProbationApproveStatus');
            History.status.key = ESS_Enum.ProbationApproveStatus.Submitted.name();
            History.status.value = 'Submitted';
            
            History.comment = comment;
            
            if(probationary.Probation_Confirmation__c == ESS_Enum.ProbationDepartmentHeadConfirmation.Confirm.name()) {
                probationary.Probation_Status__c = ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name();            
            }
            else if(probationary.Probation_Confirmation__c == ESS_Enum.ProbationDepartmentHeadConfirmation.Terminate.name()) {
                probationary.Probation_Status__c = ESS_Enum.ProbationStatus.TerminateEmployee.name();            
            }

            probationary.Approval_History_JSON__c = JSON.serialize(assignToApprovalHistory(History, probationary.Approval_History_JSON__c));
            
            //Send email to Personel Admin when Department Head approve
            ESS_NotiAndEmailController.ProbationSendToPersonelAdminWhenDepartmentHeadApproved(probationary);
        	
        }
        else if(probationDetail.currentStatus.key == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
            
            if(currentStatus != ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be submit.');
            }
            
            probationary.status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            
            //Section Head section
            probationary.quantity_of_work__c = probationDetail.quantityOfWork.key;
            probationary.Quality_of_Work__c = probationDetail.qualityOfWork.key;
            probationary.Safety_Awareness__c = probationDetail.safetyAwareness.key;
            probationary.Knowledge_Skills__c = probationDetail.knowledgeSkills.key;
            probationary.Reliability__c = probationDetail.reliability.key;
            probationary.Attitude__c = probationDetail.attitude.key;
            probationary.Section_Head_Comment__c = probationDetail.sectionHeadComment;
            probationary.Engineering_License__c = probationDetail.engineeringLicense.key;
            probationary.Recommendation__c = probationDetail.recommendation.key;
            probationary.Recommendation_Comment__c = probationDetail.recommendationComment;
            
            probationary.Probation_Confirmation__c = probationDetail.probationConfirmation.key;
            probationary.Probation_Confirmation_Comment__c = probationDetail.probationConfirmationComment;
            probationary.Confirm_CEP__c = probationDetail.cepFinalInterview;
            probationary.Propose_CEP__c = probationDetail.cepPropose;
            probationary.CEP_Confirmation__c = probationDetail.cepConfirmation.key;
            probationary.CEP_Confirmation_Comment__c = probationDetail.cepComment;
            probationary.Department_Head_Comment__c = probationDetail.departmentHeadComment;
            
            probationary.Reassign_Department_Head_Reminder__c = null;
            probationary.Department_Head_Reminder__c = emailReminders();
            
            probationary.Reassign_Department_Head_Id__c = '';
            probationary.Reassign_Department_Head_Approve_Date__c = date.today();
            
            if(probationary.Probation_Confirmation__c == ESS_Enum.ProbationDepartmentHeadConfirmation.Confirm.name()) {
                probationary.Probation_Status__c = ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name();            
            }
            else if(probationary.Probation_Confirmation__c == ESS_Enum.ProbationDepartmentHeadConfirmation.Terminate.name()) {
                probationary.Probation_Status__c = ESS_Enum.ProbationStatus.TerminateEmployee.name();            
            }

            //Get Reassign person
            if(string.isnotempty(probationary.Reassign_Department_Head_JSON__c)) {
                List<ESS_Probationary_DTO.ReassignDTO> reassignDTOs = DeserializeReassigns(probationary.Reassign_Department_Head_JSON__c);
                if(reassignDTOs.size() > 0) {
                    integer position = reassignDTOs.size() - 1;
                    reassignDTOs[position].submittedDate = date.today();
                    probationary.Reassign_Department_Head_JSON__c = JSON.serialize(reassignDTOs);
                    
                    //Approval History
                    ESS_Probationary_DTO.ApprovalHistoryDTO History = new ESS_Probationary_DTO.ApprovalHistoryDTO();
                    History.name = reassignDTOs[position].employeeId + ' - ' + reassignDTOs[position].name;
                    History.position = reassignDTOs[position].position;
                    History.submittedDate = date.today();
                    
                    History.status = new ESS_Global.EnumValue('ProbationApproveStatus');
                    History.status.key = ESS_Enum.ProbationApproveStatus.Submitted.name();
                    History.status.value = 'Submitted';
                    
                    History.comment = comment;
                    
                    probationary.Approval_History_JSON__c = JSON.serialize(assignToApprovalHistory(History, probationary.Approval_History_JSON__c));
            
                }
            }
            //Send email to department head
            Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ProbationSendToDepartmentHeadWhenSectionHeadSubmitted(probationary, mapPISUsers);
        	sendEmails.add(sendEmail);
        }
        
        if(sendEmails.size() > 0) {
            Messaging.sendEmail(sendEmails);
        }
        
        update(probationary);
        
        return probationDetail;
    }
    
    @RemoteAction
    public static void ReassignProbationary(string probationId, ESS_Probationary_DTO.ReassignPersonDTO reassignPerson, string status) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c assignedBy = ESS_Global.assignToPISUser(userId);

        string currentStatus = ProbationCurrentStatus(probationId);
        
        //Approval History
        ESS_Probationary_DTO.ApprovalHistoryDTO History = new ESS_Probationary_DTO.ApprovalHistoryDTO();
        History.name = assignedBy.EMPLOYEEID__c + ' - ' + assignedBy.EN_Fullname__c;
        History.position = assignedBy.OBJENFULLNAME__c;
        History.submittedDate = date.today();
        History.status = new ESS_Global.EnumValue('ProbationApproveStatus');
        History.status.key = ESS_Enum.ProbationApproveStatus.Reassigned.name();
        History.status.value = 'Reassigned';
        History.comment = reassignPerson.comment;
        
        ESS_Probationary_DTO.ReassignDTO reassignBy = new ESS_Probationary_DTO.ReassignDTO();
        reassignBy.userId = assignedBy.User__c;
        reassignBy.name = assignedBy.EN_Fullname__c;
        reassignBy.position = assignedBy.OBJENFULLNAME__c;
        reassignBy.employeeId = assignedBy.EMPLOYEEID__c;
        reassignBy.reassignedDate = date.today();
        reassignBy.comment = reassignPerson.comment;
        reassignBy.isAssignedBy = true;
        
        ESS_Probationary_DTO.ReassignDTO reassignTo = new ESS_Probationary_DTO.ReassignDTO();
        reassignTo.userId = reassignPerson.userId;
        reassignTo.name = reassignPerson.employeeName;
        reassignTo.position = reassignPerson.position;
        reassignTo.employeeId = reassignPerson.employeeId;
        reassignTo.reassignedDate = date.today();
        reassignTo.isAssignedBy = false;
        
        ESS_Probationary__c Probation = [select id, ownerid, owner.name, status__c, createddate, Document_No__c, Employee_ID__c, Employee_Name__c, Employee_Name_EN__c, Section_Head_Id__c, Department_Head_Id__c, Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, Approval_History_JSON__c from ESS_Probationary__c where Id =: probationId];
        
        Probation.Approval_History_JSON__c = JSON.serialize(assignToApprovalHistory(History, Probation.Approval_History_JSON__c));
        
        if(status == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
            
            if(currentStatus != ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be reassign.');
            }
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            Probation.Reassign_Section_Head_Id__c = reassignPerson.userId;
            Probation.Reassign_Section_Head_Date__c = date.today();
            
            Probation.Section_Head_Reminder__c = null;
            Probation.Reassign_Section_Head_Reminder__c = emailReminders();
            
            //if(string.isNotEmpty(Probation.Reassign_Section_Head_JSON__c)) {
            if(Probation.Reassign_Section_Head_JSON__c == null || string.isEmpty(Probation.Reassign_Section_Head_JSON__c)) {
                List<ESS_Probationary_DTO.ReassignDTO> reassigns = new List<ESS_Probationary_DTO.ReassignDTO>();
                
                reassigns.add(reassignBy);
                reassigns.add(reassignTo);
                
                Probation.Reassign_Section_Head_JSON__c = JSON.serialize(reassigns);
            }
            else {
                List<ESS_Probationary_DTO.ReassignDTO> reassignDTOs = DeserializeReassigns(Probation.Reassign_Section_Head_JSON__c);
                
                reassignDTOs.add(reassignBy);
                reassignDTOs.add(reassignTo);
                
                Probation.Reassign_Section_Head_JSON__c = JSON.serialize(reassignDTOs);
            }
            
            //Send email to reassign user when section head reassign
            ESS_NotiAndEmailController.ProbationSendToReAssignUserWhenReAssigned(Probation); 
            
        }
        else if(status == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
            
            if(currentStatus != ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This probation status has been changed and cannot be reassign.');
            }
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            Probation.Reassign_Department_Head_Id__c = reassignPerson.userId;
            Probation.Reassign_Department_Head_Date__c = date.today();
            
            Probation.Department_Head_Reminder__c = null;
            Probation.Reassign_Department_Head_Reminder__c = emailReminders();
            
            //if(string.isNotEmpty(Probation.Reassign_Department_Head_JSON__c)) {
            if(Probation.Reassign_Department_Head_JSON__c == null && string.isEmpty(Probation.Reassign_Department_Head_JSON__c)) {
                List<ESS_Probationary_DTO.ReassignDTO> reassigns = new List<ESS_Probationary_DTO.ReassignDTO>();
                
                reassigns.add(reassignBy);
                reassigns.add(reassignTo);
                
                Probation.Reassign_Department_Head_JSON__c = JSON.serialize(reassigns);
            }
            else {
                List<ESS_Probationary_DTO.ReassignDTO> reassignDTOs = DeserializeReassigns(Probation.Reassign_Department_Head_JSON__c);
                
                reassignDTOs.add(reassignBy);
                reassignDTOs.add(reassignTo);
                
                Probation.Reassign_Department_Head_JSON__c = JSON.serialize(reassignDTOs);
            }
            
            //Send email to reassign user when section head reassign
            ESS_NotiAndEmailController.ProbationSendToReAssignUserWhenReAssigned(Probation); 
            
        }
        
        update(Probation);
        
    }
    
    @RemoteAction
    public static void RecorrectProbationary(string probationId, string comment) {
        
        ESS_Probationary__c Probation = [select id, Document_No__c, Employee_ID__c, Employee_Name__c, CreatedDate, status__c, 
                                         Section_Head_Id__c, Department_Head_Id__c, Department_Head_Reject_Date__c, Department_Head__c, OwnerId,
                                         Department_Head_Position__c, Approval_History_JSON__c, Employee_Name_EN__c from ESS_Probationary__c where Id =: probationId];
        
        string currentStatus = ProbationCurrentStatus(probationId);
        
        if(currentStatus == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
            throw new ESS_Exception('[MyError]This probation status has been changed and cannot be reject.');
        }
        else if(currentStatus == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
            throw new ESS_Exception('[MyError]This probation status has been changed and cannot be reject.');
        }
        else if(currentStatus == ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name()) {
            throw new ESS_Exception('[MyError]This probation status has been changed and cannot be reject.');
        }
        else if(currentStatus == ESS_Enum.ProbationApproveStatus.Completed.name()) {
            throw new ESS_Exception('[MyError]This probation status has been changed and cannot be reject.');
        }
        
        Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
        
        Probation.Department_Head_Reminder__c = null;
        Probation.Reassign_Department_Head_Reminder__c = null;
        Probation.Section_Head_Reminder__c = emailReminders();
        
        //Approval History
        ESS_Probationary_DTO.ApprovalHistoryDTO History = new ESS_Probationary_DTO.ApprovalHistoryDTO();
        History.name = Probation.Department_Head__c;
        History.position = Probation.Department_Head_Position__c;
        History.submittedDate = date.today();
        
        History.status = new ESS_Global.EnumValue('ProbationApproveStatus');
        History.status.key = ESS_Enum.ProbationApproveStatus.Rejected.name();
        History.status.value = 'Rejected';
        
        History.comment = comment;
        
        Probation.Approval_History_JSON__c = JSON.serialize(assignToApprovalHistory(History, Probation.Approval_History_JSON__c));
        
        //Send email to section head when department head reject
        ESS_NotiAndEmailController.ProbationSendToSectionHeadWhenDepartmentHeadRejected(Probation);
        
        update(Probation);
  
    }
    
    @RemoteAction
    public static List<ESS_Probationary_DTO.ReassignPersonDTO> ReassignPersons(ReassignPersonSearchCriteria filter) {
        
        List<ESS_Probationary_DTO.ReassignPersonDTO> ReassignPersonDTOs = new List<ESS_Probationary_DTO.ReassignPersonDTO>();

        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        List<string> excludeIds = new List<string>();
        
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo) && !string.isBlank(filter.documentNo)) {
            string documentNo = filter.documentNo;
            ESS_Probationary__c Probation = [select id, ownerId, section_head_id__c, department_head_id__c from ESS_Probationary__c where document_no__c = :documentNo];
        	excludeIds.add(Probation.ownerId);
            excludeIds.add(Probation.Section_Head_Id__c);
            excludeIds.add(Probation.Department_Head_Id__c);
        }
        
        string query = 'select id, user__c, employeeid__c, en_fullname__c, function__c, department__c, sections__c, OBJENFULLNAME__c from PISUsers__c where Active__c = true AND MAINPOSITION__c = true AND user__c NOT IN :excludeIds';
        
        //filter.employeeId
        if(!string.isEmpty(filter.employeeId) && !string.isBlank(filter.employeeId)) {
            string employeeId = '%' + filter.employeeId + '%';
            query = query + ' AND employeeid__c like: employeeId';
        }
        
        //filter.employeeName
        if(!string.isEmpty(filter.employeeName) && !string.isBlank(filter.employeeName)) {
            string employeeName = '%' + filter.employeeName + '%';
            query = query + ' AND en_fullname__c like: employeeName';
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
            query = query + ' AND sections__c =: section';
        }
        
        //Final Query
        PISUsers = database.query(query + ' order by employeeid__c asc');
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                ESS_Probationary_DTO.ReassignPersonDTO ReassignPersonDTO = new ESS_Probationary_DTO.ReassignPersonDTO();    
                ReassignPersonDTO.userId = PISUser.User__c;
                ReassignPersonDTO.employeeId = PISUser.EMPLOYEEID__c;
                ReassignPersonDTO.employeeName = PISUser.EN_Fullname__c;
                ReassignPersonDTO.function = PISUser.FUNCTION__c;
                ReassignPersonDTO.department = PISUser.DEPARTMENT__c;
                ReassignPersonDTO.section = PISUser.SECTIONS__c;
                ReassignPersonDTO.position = PISUser.OBJENFULLNAME__c;
                ReassignPersonDTOs.add(ReassignPersonDTO);
            }
        }
        
        return ReassignPersonDTOs;
        
    }
    
    @RemoteAction
    public static void MassSubmitProbationary(List<ESS_Probationary_DTO.ProbationaryListDTO> probations) {
        
        List<ESS_Probationary__c> newProbations = new List<ESS_Probationary__c>();
        List<ESS_Master_Employee__c> updateMasterEmployees = new List<ESS_Master_Employee__c>();
        
        if(Probations.size() > 0) {
            
            List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND User__c != null];
            
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    
                    if(PISUser.MAINPOSITION__c) {
                        mapPISUsers.put(PISUser.User__c, PISUser);
                    }
                }    
            }
            
            for(ESS_Probationary_DTO.ProbationaryListDTO probation : Probations) {
                
                List<ESS_Probationary__c> existProbations = ProbationExisted(probation.employeeId);
                if(existProbations.size() > 0) {
                    throw new ESS_Exception('[MyError]Probation for ' + probation.employeeId + ' : ' + probation.employeeNameEN + ' has been submitted.');
                }
                
                ESS_Probationary__c newProbation = new ESS_Probationary__c();
                
                ESS_Master_Employee__c MasterEmployee = ESS_Global.getMasterEmployee(probation.employeeId);
                MasterEmployee.Probation_Completed__c = true;
                updateMasterEmployees.add(MasterEmployee);
                
                probationaryDetail = new ESS_Probationary_DTO.ProbationaryDetailDTO();
                
                string runningNo = ESS_LogicHandler.GenerateRunningNo('Probationary');
                string year = ESS_LogicHandler.GetCurrentYear();
                string month = ESS_LogicHandler.GetCurrentMonth();
                
                newProbation.Document_No__c = 'PBT-' + year + '-' + month + '-' + runningNo;
                newProbation.Status__c = String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead);
                newProbation.Employee_ID__c = probation.employeeId;
                newProbation.Employee_Name__c = probation.employeeName;
                newProbation.Employee_Name_EN__c = probation.employeeNameEN;
                newProbation.Company_Name__c = probation.companyName;
                newProbation.Function__c = probation.function;
                newProbation.Section__c = probation.section;
                newProbation.Department__c = probation.department;
                newProbation.Date_Joined_Company__c = probation.dateJoinedCompany;
                newProbation.Date_Completed_Probation__c = probation.dateCompletedProbation;
                newProbation.Submitted_Date__c = date.today();
                newProbation.OwnerId = probation.OwnerId;
                newProbation.Confirm_CEP__c = probation.cep;
                	
                if(string.isNotEmpty(probation.sectionHead)) {
                    newProbation.Section_Head__c = probation.sectionHeadName;
                    newProbation.Section_Head_Id__c = probation.sectionHead;
                    newProbation.Section_Head_Position__c = probation.sectionHeadPosition;
                    newProbation.Section_Head_Employee_Id__c = probation.sectionHeadEmployeeId;
                    
                    //Find out Section Head Reminder
                    newProbation.Section_Head_Reminder__c = emailReminders();
                }
                else {
                    newProbation.Status__c = String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead);
                	
                    //Find out Department Head Reminder
                    newProbation.Department_Head_Reminder__c = emailReminders();
                }
                
                if(string.isNotEmpty(probation.departmentHead)) {       
                    newProbation.Department_Head__c = probation.departmentHeadName;
                    newProbation.Department_Head_Id__c = probation.departmentHead;
                    newProbation.Department_Head_Position__c = probation.departmentHeadPosition;
                    newProbation.Department_Head_Employee_Id__c = probation.departmentHeadEmployeeId;
                }
                
                newProbations.add(newProbation);
                    
            }
            
            if(newProbations.size() > 0) {
                insert(newProbations);
                
                //Update Master Employee Probation Completed Flag
                update(updateMasterEmployees);
                
                List<Messaging.SingleEmailMessage> sendEmails = new List<Messaging.SingleEmailMessage>();
                
                for(ESS_Probationary__c Probation : newProbations) {
                    if(string.isNotEmpty(Probation.Section_Head_Id__c)) {
                        //Send email to section head
                        Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ProbationSendToSectionHeadWhenCreated(Probation, mapPISUsers);
                    	sendEmails.add(sendEmail);
                    }
                    else {
                        //Send email to department head
                        Messaging.SingleEmailMessage sendEmail = ESS_NotiAndEmailController.ProbationSendToDepartmentHeadWhenSectionHeadSubmitted(Probation, mapPISUsers);
                    	sendEmails.add(sendEmail);
                    }
                }
                
                if(sendEmails.size() > 0) {
                    Messaging.sendEmail(sendEmails);
                }
                
            }
        }
        
    }
    
    @RemoteAction
    public static void MassSaveProbationary(List<ESS_Probationary_DTO.ProbationaryListDTO> probations) {
        
        List<ESS_Probationary__c> newProbations = new List<ESS_Probationary__c>();
        
        string data = 'IN';
        List<ESS_Master_Employee__c> Masters = [select id, employee_id__c, Probation_Section_Head_Id__c, Probation_Section_Head_Name__c, Probation_VP_Id__c, Probation_VP_Name__c from ESS_Master_Employee__c where data__c =: data];
        
        List<ESS_Master_Employee__c> updateMasters = new List<ESS_Master_Employee__c>();
        
        if(probations.size() > 0) {
            
            for(ESS_Probationary_DTO.ProbationaryListDTO probation : probations) {
                
                for(ESS_Master_Employee__c Master : Masters) {
                    if(probation.employeeId == Master.Employee_id__c) {
                        
                        Master.Probation_Section_Head_Id__c = probation.sectionHead;
                        Master.Probation_Section_Head_Name__c = probation.sectionHeadName;
                        Master.Probation_Section_Head_TH__c = probation.sectionHeadTH;
                        Master.Probation_Section_Head_Position__c = probation.sectionHeadPosition;
                        if(string.isEmpty(Master.Probation_Section_Head_Id__c)) {
                            Master.Probation_Section_Head_Skip__c = true;
                        }
                        else {
                            Master.Probation_Section_Head_Skip__c = false;
                        }
                        Master.Probation_VP_Id__c = probation.departmentHead;
                        Master.Probation_VP_Name__c = probation.departmentHeadName;
                        Master.Probation_VP_TH__c = probation.departmentHeadTH;
                        Master.Probation_VP_Position__c = probation.departmentHeadPosition;
                        updateMasters.add(Master);
                        
                        break;
                        
                    }
                }
                
            }
            
            if(updateMasters.size() > 0) {
                update(updateMasters);
            }
        }
        
        
    }
        
    @RemoteAction
    public static string ExportExcel() {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_Probation_Excel?';
        
        return URL;
        
    }
    
    @RemoteAction
    public static List<ESS_Probationary_DTO.SearchUserDTO> SearchUsers(string search, string employeeId) {
        
        List<string> employeeIds = new List<string>();
        boolean multipleEmployee = employeeId.contains(',');
        if(multipleEmployee) {
            employeeIds = employeeId.split(',');
        }
        else {
            employeeIds.add(employeeId);
        }
        
        string searchName = '%' + search + '%';
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //PISUsers
        string queryPIS = 'select id, user__c, employeeid__c, thtitle__c, thfirstname__c, thlastname__c, active__c, mainposition__c, EN_Fullname__c, OBJENFULLNAME__c, TH_Fullname__c from PISUsers__c';
        queryPIS = queryPIS + ' where (employeeid__c NOT IN :employeeIds AND user__c NOT IN :employeeIds) AND (employeeid__c like: searchName OR enfirstname__c like: searchName) AND active__c = true AND mainposition__c = true limit 100';
        PISUsers = database.query(queryPIS);
        
        List<ESS_Probationary_DTO.SearchUserDTO> SearchUsers = new List<ESS_Probationary_DTO.SearchUserDTO>();
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                ESS_Probationary_DTO.SearchUserDTO SearchUser = new ESS_Probationary_DTO.SearchUserDTO();
                SearchUser.userId = PISUser.User__c;
                SearchUser.employeeName = PISUser.EMPLOYEEID__c + ' - ' + PISuser.EN_Fullname__c;
                SearchUser.employeeNameTH = PISUser.TH_Fullname__c;
                SearchUser.position = PISUser.OBJENFULLNAME__c;
                SearchUsers.add(SearchUser);
            }
        }
        
        return SearchUsers;
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
    
    @RemoteAction
    public static List<string> GetCEPs() {
        
        List<string> ceps = new List<string>();
        Schema.DescribeFieldResult objFieldDescribe = ESS_Probationary__c.Propose_CEP__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry objPickList : lstPickListValues) {
            ceps.add(objPickList.getLabel());
        }
        return ceps;
    }
    
    @RemoteAction
    public static void ESSService_PersonelFolder(string recordId, string fileId, string employeeId) {
        //Call Personel Folder Service
        ESS_Service.FileUploadPersonelFolder(recordId, fileId, employeeId, '1');
    }
    
    //Assign to DTO section
    public static ProbationaryListSortDTO assignToProbationaryListSortDTO(ESS_Master_Employee__c Employee, Map<string, PISUsers__c> mapPOSIDPISUsers, Map<string, PISUsers__c> mapPISUsers, List<ESS_Probationary__c> Probations) {
    
        string employeeId = '';
        string employeeName = '';
        string employeeNameTH = '';
        string function = '';
        string department = '';
        string section = '';
        string unit = '';
        string sectionHead = '';
        string departmentHead = '';
        string level = '';
        string userId = '';
        string sectionHeadName = '';
        string sectionHeadNameTH = '';
        string departmentHeadName = '';
        string departmentHeadNameTH = '';
        string sectionHeadPosition = '';
        string departmentHeadPosition = '';
        string companyName = '';
        string cep = '';
        
        ProbationaryListSortDTO ProbationaryList = new ProbationaryListSortDTO();
        boolean isMap = false;
        
        if(mapPISUsers.size() > 0) {
            
            PISUsers__c PISUser = mapPISUsers.get(Employee.Employee_ID__c);
            
            if(PISUser != null) {
                userId = PISUser.User__c;
                employeeId = PISUser.EMPLOYEEID__c;
                employeeName = PISUser.EN_Fullname__c;
                employeeNameTH = PISUser.TH_Fullname__c;
                function = PISUser.FUNCTION__c;
                department = PISUser.DEPARTMENT__c;
                section = PISUser.SECTIONS__c;
                
                if(string.isNotEmpty(PISUser.UNITS__c)) {
                    unit = PISUser.UNITS__c;
                }
                
                level = PISUser.Level__c;
                
                if(PISUser.HOME_COMP__c == '1100') {
                    companyName = 'TOP';
                }
                else if(PISUser.HOME_COMP__c == '1600') {
                    companyName = 'TES';
                }
                
                ESS_Probationary_DTO.ProbationaryApproverDTO ProbationApprover = new ESS_Probationary_DTO.ProbationaryApproverDTO();
                ProbationApprover = ESS_Global.GetSectionHeadDepartmentHeadProbation(PISUser, mapPOSIDPISUsers);
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_Id__c)) {
                    sectionHead = Employee.Probation_Section_Head_Id__c;
                }
                else {
                    sectionHead = ProbationApprover.sectionHeadId;
                }
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_Name__c)) {
                    sectionHeadName = Employee.Probation_Section_Head_Name__c;
                }
                else {
                    sectionHeadName = ProbationApprover.sectionHeadName;
                }
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_TH__c)) {
                    sectionHeadNameTH = Employee.Probation_Section_Head_TH__c;
                }
                else {
                    sectionHeadNameTH = ProbationApprover.sectionHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Probation_Section_Head_Position__c)) {
                    sectionHeadPosition = Employee.Probation_Section_Head_Position__c;
                }
                else {
                    sectionHeadPosition = ProbationApprover.sectionHeadPosition;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_Id__c)) {
                    departmentHead = Employee.Probation_VP_Id__c;
                }
                else {
                    departmentHead = ProbationApprover.departmentHeadId;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_Name__c)) {
                    departmentHeadName = Employee.Probation_VP_Name__c;
                }
                else {
                    departmentHeadName = ProbationApprover.departmentHeadName;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_TH__c)) {
                    departmentHeadNameTH = Employee.Probation_VP_TH__c;
                }
                else {
                    departmentHeadNameTH = ProbationApprover.departmentHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Probation_VP_Position__c)) {
                    departmentHeadPosition = Employee.Probation_VP_Position__c;
                }
                else {
                    departmentHeadPosition = ProbationApprover.departmentHeadPosition;
                }
                
                isMap = true;
            }
        }
        
        ProbationaryList.dateStamp = Employee.Probationary_Date__c;
        ProbationaryList.ownerId = userId;
        ProbationaryList.employeeId = employeeId;
        ProbationaryList.employeeName = employeeNameTH;
        ProbationaryList.employeeNameEN = employeeName;
        ProbationaryList.companyName = companyName;
        ProbationaryList.dateJoinedCompany = Employee.Employee_Date_Joined__c;
        ProbationaryList.dateCompletedProbation = Employee.Employee_Date_Joined__c.addDays(179);
        ProbationaryList.function = function;
        ProbationaryList.department = department;
        ProbationaryList.section = section;
        ProbationaryList.unit = unit;
        ProbationaryList.level = level;
        ProbationaryList.sectionHead = sectionHead;
        ProbationaryList.sectionHeadName = sectionHeadName;
        ProbationaryList.sectionHeadTH = sectionHeadNameTH;
        ProbationaryList.sectionHeadPosition = sectionHeadPosition;
        if(Employee.Probation_Section_Head_Skip__c) {
            ProbationaryList.sectionHead = '';
            ProbationaryList.sectionHeadTH = '';
            ProbationaryList.sectionHeadName = '';
            ProbationaryList.sectionHeadPosition = '';
        }
        ProbationaryList.departmentHead = departmentHead;
        ProbationaryList.departmentHeadName = departmentHeadName;
        ProbationaryList.departmentHeadTH = departmentHeadNameTH;
        ProbationaryList.departmentHeadPosition = departmentHeadPosition;
        
        //Decode CEP
        if(string.isNotEmpty(Employee.CEP__c)) {
            Blob blobValue = EncodingUtil.convertFromHex(Employee.CEP__c);
            ProbationaryList.cep = blobValue.toString();
        }
        else {
            ProbationaryList.cep = '';
        }
        
        if(!isMap) {
            //ProbationaryList.employeeId = Employee.Employee_ID__c;
        }
        
        ProbationaryList.isDisable = false;
        //Check isDisable
        if(Probations.size() > 0) {
            for(ESS_Probationary__c Probation : Probations) {
                if(Probation.Employee_ID__c == employeeId) {
                    ProbationaryList.isDisable = true;
                    break;
                }
            }
        }
        
        
        return ProbationaryList;
    
    }
    
    public static ESS_Probationary_DTO.ProbationaryListDTO convertToProbationaryListDTO(ProbationaryListSortDTO Probation) {
    
        ESS_Probationary_DTO.ProbationaryListDTO result = new ESS_Probationary_DTO.ProbationaryListDTO ();
        result.probationId = Probation.probationId;
        result.ownerId = Probation.ownerId;
        result.isDisable = Probation.isDisable;
        result.companyName = Probation.companyName;
		result.dateStamp = Probation.dateStamp;
        result.employeeId = Probation.employeeId;
        result.employeeName = Probation.employeeName;
        result.employeeNameEN = Probation.employeeNameEN;
        result.level = Probation.level;
        result.isDisableSectionHead = true;
        if(Probation.level == 'Junior' || Probation.level == 'Senior' || Probation.level == 'Supervisor') {
            result.isDisableSectionHead = false;
        }
        result.dateJoinedCompany = Probation.dateJoinedCompany;
        result.dateCompletedProbation = Probation.dateCompletedProbation;
        result.sectionHead = Probation.sectionHead;
        result.sectionHeadTH = Probation.sectionHeadTH;
        result.sectionHeadName = Probation.sectionHeadName;
        result.sectionHeadEmployeeId = Probation.sectionHeadEmployeeId;
        result.sectionHeadPosition = Probation.sectionHeadPosition;
        result.departmentHead = Probation.departmentHead;
        result.departmentHeadTH = Probation.departmentHeadTH;
        result.departmentHeadName = Probation.departmentHeadName;
        result.departmentHeadEmployeeId = Probation.departmentHeadEmployeeId;
        result.departmentHeadPosition = Probation.departmentHeadPosition;
        result.cep = Probation.cep;
        result.function = Probation.function;
        result.department = Probation.department;
        result.section = Probation.section;
        result.unit = Probation.unit;
        return result;
    }
    
    @TestVisible
    private static ESS_Probationary_DTO.ProbationaryApproveListDTO assignToProbationaryApproveListDTO(ESS_Probationary__c Probationary) {
        
        ESS_Probationary_DTO.ProbationaryApproveListDTO probationaryApprove = new ESS_Probationary_DTO.ProbationaryApproveListDTO();
        
        probationaryApprove.probationId = Probationary.Id;
        probationaryApprove.documentNo = Probationary.Document_No__c;
        probationaryApprove.employeeId = Probationary.Employee_Id__c;
        probationaryApprove.employeeName = Probationary.Employee_Name__c;
        probationaryApprove.employeeNameEN = Probationary.Employee_Name_EN__c;
        probationaryApprove.dateJoinedCompany = Probationary.Date_Joined_Company__c;
        probationaryApprove.dateCompletedProbation = Probationary.Date_Completed_Probation__c;
        probationaryApprove.submittedDate = Probationary.Submitted_Date__c;
        
        probationaryApprove.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
        if(Probationary.Status__c == ESS_Enum.ProbationApproveStatus.Draft.name()) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.Draft.name();
            probationaryApprove.currentStatus.value = 'Draft';
        }
        else if(Probationary.Status__c == ESS_Enum.ProbationApproveStatus.Reassigned.name()) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.Reassigned.name();
            probationaryApprove.currentStatus.value = 'Reassigned';
        }
        else if(Probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            probationaryApprove.currentStatus.value = 'Waiting for Approval by Immediate Line / Section Head';
        }
        else if(Probationary.status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead)) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            probationaryApprove.currentStatus.value = 'Waiting for Reassigned Section Head';
        }
        else if(Probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            probationaryApprove.currentStatus.value = 'Waiting for Approval by Department Head';
        }
        else if(Probationary.status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead)) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            probationaryApprove.currentStatus.value = 'Waiting for Reassigned Department Head';
        }
        else if(Probationary.Status__c == ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name()) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name();
            probationaryApprove.currentStatus.value = 'Uploading to Personal Folder';
        }
        else if(Probationary.Status__c == ESS_Enum.ProbationApproveStatus.Submitted.name()) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.Submitted.name();
            probationaryApprove.currentStatus.value = 'Submitted';
        }
        else if(Probationary.Status__c == ESS_Enum.ProbationApproveStatus.Completed.name()) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.Completed.name();
            probationaryApprove.currentStatus.value = 'Completed';
        }
        else if(Probationary.Status__c == ESS_Enum.ProbationApproveStatus.UploadFailed.name()) {
            probationaryApprove.currentStatus.key = ESS_Enum.ProbationApproveStatus.UploadFailed.name();
            probationaryApprove.currentStatus.value = 'UploadFailed';
        }
        
        probationaryApprove.sectionHead = Probationary.Section_Head_Id__c;
        if(string.isEmpty(Probationary.Section_Head__c)) {
        	probationaryApprove.sectionHeadName = '-';
        }
        else {
        	probationaryApprove.sectionHeadName = Probationary.Section_Head__c;
        }
        probationaryApprove.sectionHeadSubmittedDate = Probationary.Section_Head_Approve_Date__c;
        probationaryApprove.departmentHead = Probationary.Department_Head_Id__c;
        probationaryApprove.departmentHeadName = Probationary.Department_Head__c;
        probationaryApprove.departmentHeadSubmittedDate = Probationary.Department_Head_Approve_Date__c;
        probationaryApprove.completedDate = Probationary.Completed_Date__c;
        
        probationaryApprove.probationStatus = new ESS_Global.EnumValue('ProbationStatus');
        if(Probationary.Probation_Status__c == ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name()) {
            probationaryApprove.probationStatus.key = ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name();
            probationaryApprove.probationStatus.value = 'Confirmed to Regular Employee';
        }
        else if(Probationary.Probation_Status__c == ESS_Enum.ProbationStatus.TerminateEmployee.name()) {
            probationaryApprove.probationStatus.key = ESS_Enum.ProbationStatus.TerminateEmployee.name();
            probationaryApprove.probationStatus.value = 'Terminate Employee';
        }
        
        return probationaryApprove;
        
    }
    
    @TestVisible
    private static ESS_Probationary_DTO.ProbationaryDetailDTO assignToProbationaryDetailDTO(ESS_Probationary__c Probationary) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        ESS_Probationary_DTO.ProbationaryDetailDTO probationaryDetail = new ESS_Probationary_DTO.ProbationaryDetailDTO();
        
        probationaryDetail.probationId = probationary.Id;
        probationaryDetail.documentNo = probationary.Document_No__c;
        probationaryDetail.companyName = probationary.Company_Name__c;
        
        probationaryDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
        if(probationary.status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead)) {
            probationaryDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            probationaryDetail.currentStatus.value = 'Waiting for Approval by Immediate Line / Section Head';
        }
        else if(probationary.status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead)) {
            probationaryDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            probationaryDetail.currentStatus.value = 'Waiting for Reassigned Section Head';
        }
        else if(probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
            probationaryDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            probationaryDetail.currentStatus.value = 'Waiting for Approval by Department Head';
        }
        else if(probationary.status__c == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead)) {
            probationaryDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            probationaryDetail.currentStatus.value = 'Waiting for Reassigned Department Head';
        }
        else if(probationary.Status__c == ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name()) {
            probationaryDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name();
            probationaryDetail.currentStatus.value = 'Uploading to Personal Folder';
        }
        else if(probationary.Status__c == ESS_Enum.ProbationApproveStatus.Submitted.name()) {
            probationaryDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.Submitted.name();
            probationaryDetail.currentStatus.value = 'Submitted';
        }
        else if(probationary.Status__c == ESS_Enum.ProbationApproveStatus.Completed.name()) {
            probationaryDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.Completed.name();
            probationaryDetail.currentStatus.value = 'Completed';
        }   
        else if(probationary.Status__c == ESS_Enum.ProbationApproveStatus.UploadFailed.name()) {
            probationaryDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.UploadFailed.name();
            probationaryDetail.currentStatus.value = 'UploadFailed';
        }          
        
        probationaryDetail.employeeId = probationary.employee_id__c;
        probationaryDetail.employeeName = probationary.employee_name__c;
        probationaryDetail.employeeNameEN = probationary.Employee_Name_EN__c;
        probationaryDetail.section = probationary.section__c;
        probationaryDetail.department = probationary.department__c;
        probationaryDetail.dateJoinedCompany = probationary.date_joined_company__c;
        probationaryDetail.dateCompletedProbation = probationary.date_completed_probation__c;
        
        //Quantity of Work
        probationaryDetail.quantityOfWork = new ESS_Global.EnumValue('ProbationSectionHeadQuantity');
        if(probationary.quantity_of_work__c == String.ValueOf(ESS_Enum.ProbationSectionHeadQuantity.Learn)) {
            probationaryDetail.quantityOfWork.key = ESS_Enum.ProbationSectionHeadQuantity.Learn.name();
            probationaryDetail.quantityOfWork.value = 'Learn slowly and quantity of work is below expection';
        }
        else if(probationary.quantity_of_work__c == String.ValueOf(ESS_Enum.ProbationSectionHeadQuantity.Meet)) {
            probationaryDetail.quantityOfWork.key = ESS_Enum.ProbationSectionHeadQuantity.Meet.name();
            probationaryDetail.quantityOfWork.value = 'Meet required standard';
        }
        else if(probationary.quantity_of_work__c == String.ValueOf(ESS_Enum.ProbationSectionHeadQuantity.Better)) {
            probationaryDetail.quantityOfWork.key = ESS_Enum.ProbationSectionHeadQuantity.Better.name();
            probationaryDetail.quantityOfWork.value = 'Better than expectation';
        }
        
        //Quality of Work
        probationaryDetail.qualityOfWork = new ESS_Global.EnumValue('ProbationSectionHeadQuality');
        if(probationary.quality_of_work__c == String.ValueOf(ESS_Enum.ProbationSectionHeadQuality.Below)) {
            probationaryDetail.qualityOfWork.key = ESS_Enum.ProbationSectionHeadQuality.Below.name();
            probationaryDetail.qualityOfWork.value = 'Below required standard';
        }
        else if(probationary.quality_of_work__c == String.ValueOf(ESS_Enum.ProbationSectionHeadQuality.Meet)) {
            probationaryDetail.qualityOfWork.key = ESS_Enum.ProbationSectionHeadQuality.Meet.name();
            probationaryDetail.qualityOfWork.value = 'Meet required standard';
        }
        else if(probationary.quality_of_work__c == String.ValueOf(ESS_Enum.ProbationSectionHeadQuality.Better)) {
            probationaryDetail.qualityOfWork.key = ESS_Enum.ProbationSectionHeadQuality.Better.name();
            probationaryDetail.qualityOfWork.value = 'Better than expectation';
        }
        
        //Safety Awareness
        probationaryDetail.safetyAwareness = new ESS_Global.EnumValue('ProbationSectionHeadSafety');
        if(probationary.safety_awareness__c == String.ValueOf(ESS_Enum.ProbationSectionHeadSafety.Below)) {
            probationaryDetail.safetyAwareness.key = ESS_Enum.ProbationSectionHeadSafety.Below.name();
            probationaryDetail.safetyAwareness.value = 'Below required standard';
        }
        else if(probationary.safety_awareness__c == String.ValueOf(ESS_Enum.ProbationSectionHeadSafety.Meet)) {
            probationaryDetail.safetyAwareness.key = ESS_Enum.ProbationSectionHeadSafety.Meet.name();
            probationaryDetail.safetyAwareness.value = 'Meet required standard';
        }
        else if(probationary.safety_awareness__c == String.ValueOf(ESS_Enum.ProbationSectionHeadSafety.Better)) {
            probationaryDetail.safetyAwareness.key = ESS_Enum.ProbationSectionHeadSafety.Better.name();
            probationaryDetail.safetyAwareness.value = 'Better than expectation';
        }
        
        //Knowledge / Skills
        probationaryDetail.knowledgeSkills = new ESS_Global.EnumValue('ProbationSectionHeadKnowledge');
        if(probationary.knowledge_skills__c == String.ValueOf(ESS_Enum.ProbationSectionHeadKnowledge.Insufficient)) {
            probationaryDetail.knowledgeSkills.key = ESS_Enum.ProbationSectionHeadKnowledge.Insufficient.name();
            probationaryDetail.knowledgeSkills.value = 'Insufficient knowledge/skills to carry out work up to the required standard';
        }
        else if(probationary.knowledge_skills__c == String.ValueOf(ESS_Enum.ProbationSectionHeadKnowledge.Sufficient)) {
            probationaryDetail.knowledgeSkills.key = ESS_Enum.ProbationSectionHeadKnowledge.Sufficient.name();
            probationaryDetail.knowledgeSkills.value = 'Sufficient knowledge/skills to carry out work up to the required standard';
        }
        else if(probationary.knowledge_skills__c == String.ValueOf(ESS_Enum.ProbationSectionHeadKnowledge.SufficientBetter)) {
            probationaryDetail.knowledgeSkills.key = ESS_Enum.ProbationSectionHeadKnowledge.SufficientBetter.name();
            probationaryDetail.knowledgeSkills.value = 'Sufficient knowledge/skills to carry out work better than the required standard';
        }
        
        //Reliability
        probationaryDetail.reliability = new ESS_Global.EnumValue('ProbationSectionHeadReliability');
        if(probationary.reliability__c == String.ValueOf(ESS_Enum.ProbationSectionHeadReliability.NeedSupervision)) {
            probationaryDetail.reliability.key = ESS_Enum.ProbationSectionHeadReliability.NeedSupervision.name();
            probationaryDetail.reliability.value = 'Need close supervision';
        }
        else if(probationary.reliability__c == String.ValueOf(ESS_Enum.ProbationSectionHeadReliability.OccasionalSupervision)) {
            probationaryDetail.reliability.key = ESS_Enum.ProbationSectionHeadReliability.OccasionalSupervision.name();
            probationaryDetail.reliability.value = 'Work well and need only occasional supervision';
        }
        else if(probationary.reliability__c == String.ValueOf(ESS_Enum.ProbationSectionHeadReliability.WithoutSupervision)) {
            probationaryDetail.reliability.key = ESS_Enum.ProbationSectionHeadReliability.WithoutSupervision.name();
            probationaryDetail.reliability.value = 'Work independently without supervision';
        }
        
        //Attitude
        probationaryDetail.attitude = new ESS_Global.EnumValue('ProbationSectionHeadAttitude');
        if(probationary.attitude__c == String.ValueOf(ESS_Enum.ProbationSectionHeadAttitude.LackDescipline)) {
            probationaryDetail.attitude.key = ESS_Enum.ProbationSectionHeadAttitude.LackDescipline.name();
            probationaryDetail.attitude.value = 'Lack discipline and always create problems';
        }
        else if(probationary.attitude__c == String.ValueOf(ESS_Enum.ProbationSectionHeadAttitude.NeatAndObey)) {
            probationaryDetail.attitude.key = ESS_Enum.ProbationSectionHeadAttitude.NeatAndObey.name();
            probationaryDetail.attitude.value = 'Neat and obey supervisor\'s order';
        }
        else if(probationary.attitude__c == String.ValueOf(ESS_Enum.ProbationSectionHeadAttitude.WorkWell)) {
            probationaryDetail.attitude.key = ESS_Enum.ProbationSectionHeadAttitude.WorkWell.name();
            probationaryDetail.attitude.value = 'Work well with colleague and strictly adhere to Company regulations';
        }
        
        probationaryDetail.sectionHeadComment = probationary.Section_Head_Comment__c;

        //Engineering License
        probationaryDetail.engineeringLicense = new ESS_Global.EnumValue('ProbationSectionHeadEngineering');
        if(probationary.engineering_license__c == String.ValueOf(ESS_Enum.ProbationSectionHeadEngineering.AlreadyPossessed)) {
            probationaryDetail.engineeringLicense.key = ESS_Enum.ProbationSectionHeadEngineering.AlreadyPossessed.name();
            probationaryDetail.engineeringLicense.value = 'The incumbent has already possessed the valid license';
        }
        else if(probationary.engineering_license__c == String.ValueOf(ESS_Enum.ProbationSectionHeadEngineering.NotYetPossessed)) {
            probationaryDetail.engineeringLicense.key = ESS_Enum.ProbationSectionHeadEngineering.NotYetPossessed.name();
            probationaryDetail.engineeringLicense.value = 'The incumbent has not yet possessed the valid license';
        }
        else if(probationary.engineering_license__c == String.ValueOf(ESS_Enum.ProbationSectionHeadEngineering.NotRequire)) {
            probationaryDetail.engineeringLicense.key = ESS_Enum.ProbationSectionHeadEngineering.NotRequire.name();
            probationaryDetail.engineeringLicense.value = 'Not Require';
        }
        
        //Recommendation
        probationaryDetail.recommendation = new ESS_Global.EnumValue('ProbationSectionHeadRecommendation');
        if(probationary.recommendation__c == String.ValueOf(ESS_Enum.ProbationSectionHeadRecommendation.Confirm)) {
            probationaryDetail.recommendation.key = ESS_Enum.ProbationSectionHeadRecommendation.Confirm.name();
            probationaryDetail.recommendation.value = 'To confirm as regular employee of the Company';
        }
        else if(probationary.recommendation__c == String.ValueOf(ESS_Enum.ProbationSectionHeadRecommendation.Terminate)) {
            probationaryDetail.recommendation.key = ESS_Enum.ProbationSectionHeadRecommendation.Terminate.name();
            probationaryDetail.recommendation.value = 'To terminate employment for the following reason';
        }
        
        //Reassign SectionHead
        if(string.isNotEmpty(probationary.Reassign_Section_Head_JSON__c)) {
            probationaryDetail.reassignSectionHeads = DeserializeReassigns(probationary.Reassign_Section_Head_JSON__c);
        }
        
        probationaryDetail.sectionHeadName = '-';
            
        if(string.isNotEmpty(probationary.section_head__c)) {
            probationaryDetail.sectionHeadName = probationary.section_head__c;
        }
        
        if(probationary.section_head_approve_date__c != null) {
            probationaryDetail.sectionHeadSubmittedDate = probationary.section_head_approve_date__c;
        }
        
        probationaryDetail.sectionHeadPosition = '-';
        if(string.isNotEmpty(probationary.section_head_position__c)) {
            probationaryDetail.sectionHeadPosition = probationary.section_head_position__c;
        }
        
        //For Department Head
        //Probation Confirmation
        probationaryDetail.probationConfirmation = new ESS_Global.EnumValue('ProbationDepartmentHeadConfirmation');
        if(probationary.probation_confirmation__c == String.ValueOf(ESS_Enum.ProbationDepartmentHeadConfirmation.Confirm)) {
            probationaryDetail.probationConfirmation.key = ESS_Enum.ProbationDepartmentHeadConfirmation.Confirm.name();
            probationaryDetail.probationConfirmation.value = 'To confirm as regular employee of the Company';
        }
        else if(probationary.probation_confirmation__c == String.ValueOf(ESS_Enum.ProbationDepartmentHeadConfirmation.Terminate)) {
            probationaryDetail.probationConfirmation.key = ESS_Enum.ProbationDepartmentHeadConfirmation.Terminate.name();
            probationaryDetail.probationConfirmation.value = 'To terminate employment for the following reason';
        }
        
        probationaryDetail.recommendationComment = probationary.Recommendation_Comment__c;
        probationaryDetail.probationConfirmationComment = probationary.probation_confirmation_comment__c;
        
        //CEP Confirmation
        probationaryDetail.cepConfirmation = new ESS_Global.EnumValue('ProbationDepartmentHeadCEP');
        if(probationary.cep_confirmation__c == String.ValueOf(ESS_Enum.ProbationDepartmentHeadCEP.Confirm)) {
            probationaryDetail.cepConfirmation.key = ESS_Enum.ProbationDepartmentHeadCEP.Confirm.name();
            probationaryDetail.cepConfirmation.value = 'Confirm';
        }
        else if(probationary.cep_confirmation__c == String.ValueOf(ESS_Enum.ProbationDepartmentHeadCEP.Propose)) {
            probationaryDetail.cepConfirmation.key = ESS_Enum.ProbationDepartmentHeadCEP.Propose.name();
            probationaryDetail.cepConfirmation.value = 'Propose';
        }
        
        probationaryDetail.cepFinalInterview = probationary.confirm_cep__c;
        probationaryDetail.cepPropose = probationary.propose_cep__c;
        probationaryDetail.cepComment = probationary.cep_confirmation_comment__c;
        probationaryDetail.departmentHeadComment = probationary.department_head_comment__c;
        
        if(string.isNotEmpty(probationary.approval_history_json__c)) {
            probationaryDetail.approvalHistories = DeserializeHistoryWorkflows(probationary.approval_history_json__c);
        }
        
        probationaryDetail.departmentHeadName = probationary.department_head__c;
        probationaryDetail.departmentHeadSubmittedDate = probationary.department_head_approve_date__c;
        probationaryDetail.departmentHeadPosition = probationary.department_head_position__c;
        
        //Reassign DepartmentHead
        if(string.isNotEmpty(probationary.reassign_department_head_json__c)) {
            probationaryDetail.reassignDepartmentHeads = DeserializeReassigns(probationary.reassign_department_head_json__c);
        }
        
        probationaryDetail.isEditSectionHead = false;
        probationaryDetail.isEditDepartmentHead = false;
        
        probationaryDetail.canSubmit = false;
        probationaryDetail.canReassign = false;
        probationaryDetail.canSendBack = false;
        probationaryDetail.canSaveSectionHead = false;
        probationaryDetail.canSaveDepartmentHead = false;
        probationaryDetail.canUploadPersonalFolder = false;
        
        probationaryDetail.canSubmit = checkCanSubmit(probationary.status__c);
        probationaryDetail.canReassign = checkCanReassign(probationary.status__c);
        probationaryDetail.canSendBack = checkCanSendBack(probationary.status__c);
        probationaryDetail.canSaveSectionHead = checkCanSaveSectionHead(probationary.status__c);
        probationaryDetail.canSaveDepartmentHead = checkCanSaveDepartmentHead(probationary.status__c);
        probationaryDetail.canUploadPersonalFolder = checkCanUploadPersonalFolder(probationary.status__c);
        
        //Check who can edit section
        if(probationary.Status__c != ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name() && probationary.Status__c != ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name())
        {
            if(userId == probationary.section_head_id__c) {
                probationaryDetail.isEditSectionHead = true;
                probationaryDetail.canSaveSectionHead = true;
            }
            if(userId == probationary.department_head_id__c && string.isNotEmpty(probationary.section_head_id__c)) {
                probationaryDetail.isEditDepartmentHead = true;
                probationaryDetail.canSaveDepartmentHead = true;
                probationaryDetail.canViewDepartmentHead = true;
            }
            else if(userId == probationary.department_head_id__c && string.isEmpty(probationary.section_head_id__c)) {
                probationaryDetail.isEditSectionHead = true;
                probationaryDetail.isEditDepartmentHead = true;
                probationaryDetail.canSaveSectionHead = true;
                probationaryDetail.canSaveDepartmentHead = true;
                probationaryDetail.canViewDepartmentHead = true;
            }
        }
        
        
        boolean isReassignSectionHead = false;
        if(string.isNotEmpty(probationary.Reassign_Section_Head_JSON__c)) {
            isReassignSectionHead = isReassignSectionHead(probationary.Reassign_Section_Head_JSON__c, userId);
        }
        
        boolean isReassignDepartmentHead = false;
        if(string.isNotEmpty(probationary.Reassign_Department_Head_JSON__c)) {
            isReassignDepartmentHead = isReassignDepartmentHead(probationary.Reassign_Department_Head_JSON__c, userId);
        }
        
        //Section Head Flow
        if(probationary.Section_Head_Flow__c) {
            
            if(userId == probationary.OwnerId) {
                probationaryDetail.canSendBack = false;
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
            }
            else if(userId == probationary.Department_Head_Id__c && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                probationaryDetail.canSendBack = false;
                probationaryDetail.canSubmit = true;
                probationaryDetail.canReassign = true;
            }
            else if(userId == probationary.Department_Head_Id__c && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
                probationaryDetail.canSendBack = false;
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.canViewDepartmentHead = true;
            }
            else if(isReassignDepartmentHead && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                probationaryDetail.canViewDepartmentHead = true;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSubmit = false;
                probationaryDetail.canSendBack = false;
                probationaryDetail.canSaveDepartmentHead = false;
            }
            else if(userId == probationary.Reassign_Department_Head_Id__c && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
                probationaryDetail.canSendBack = false;
                probationaryDetail.canSubmit = true;
                probationaryDetail.canReassign = false;

                //edit section permission for department head reassigned user
                probationaryDetail.isEditSectionHead = true;
                probationaryDetail.canSaveSectionHead = true;
                probationaryDetail.isEditDepartmentHead = true;
                probationaryDetail.canSaveDepartmentHead = true;
                probationaryDetail.canViewDepartmentHead = true;
            }
            else {
                probationaryDetail.canSendBack = false;
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.isEditSectionHead = false;
                probationaryDetail.canSaveSectionHead = false;
                probationaryDetail.isEditDepartmentHead = false;
                probationaryDetail.canSaveDepartmentHead = false;
                probationaryDetail.canViewDepartmentHead = false;
            }
        }
        else {
            
            //Normal Flow
            if (userId == probationary.OwnerId)
            {
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
                probationaryDetail.isEditSectionHead = false;
                probationaryDetail.canSaveSectionHead = false;
                probationaryDetail.isEditDepartmentHead = false;
                probationaryDetail.canSaveDepartmentHead = false;
                
                //When CEO as record Owner
                if(userId == probationary.Section_Head_Id__c && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
                    probationaryDetail.canSubmit = true;
                    probationaryDetail.canReassign = true;
                    probationaryDetail.canSendBack = false;
                    probationaryDetail.isEditSectionHead = true;
                    probationaryDetail.canSaveSectionHead = true;
                }
                else if(userId == probationary.Department_Head_Id__c && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                    probationaryDetail.canSubmit = true;
                    probationaryDetail.canReassign = true;
                    probationaryDetail.canSendBack = false;
                    probationaryDetail.isEditDepartmentHead = true;
                    probationaryDetail.canSaveDepartmentHead = true;
                }
            }
            //Check when Login as Section Head and Status is WaitingForApprovalSectionHead
            else if(userId == probationary.Section_Head_Id__c && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
                probationaryDetail.canSubmit = true;
                probationaryDetail.canReassign = true;
                probationaryDetail.canSendBack = false;
            }
            //Check when login as Section Head but no permission
            else if(userId == probationary.section_head_id__c && probationary.Status__c != ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name()) {
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
                probationaryDetail.isEditSectionHead = false;
                probationaryDetail.canSaveSectionHead = false;
                probationaryDetail.isEditDepartmentHead = false;
                probationaryDetail.canSaveDepartmentHead = false;
            }
            //Check when login as Reassigned Section Head and status is WaitingForReassignedSectionHead
            else if(userId == probationary.Reassign_Section_Head_Id__c && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
                
                probationaryDetail.canSubmit = true;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
                
                //edit section permission for section head reassigned user
                probationaryDetail.isEditSectionHead = true;
                probationaryDetail.canSaveSectionHead = true;
                probationaryDetail.canViewDepartmentHead = false;
                probationaryDetail.canSaveDepartmentHead = false;
            }
            //Check when access as Reassign Section Head but no permission
            else if(userId == probationary.Reassign_Section_Head_Id__c && probationary.Status__c != ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name()) {
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
                probationaryDetail.isEditSectionHead = false;
                probationaryDetail.canSaveSectionHead = false;
                probationaryDetail.canViewDepartmentHead = false;
                probationaryDetail.canSaveDepartmentHead = false;
            }
            //Check when login as Department Head and status is WaitingForApprovalDepartmentHead
            else if(userId == probationary.Department_Head_Id__c && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                probationaryDetail.canSubmit = true;
                probationaryDetail.canReassign = true;
                probationaryDetail.canSendBack = true;
            }
            //Check when login as Reassigned Department Head and status is WaitingForReassignedDepartmentHead
            else if(userId == probationary.Reassign_Department_Head_Id__c && probationary.Status__c == ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
                probationaryDetail.canSubmit = true;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
                
                //edit section permission for department head reassigned user
                probationaryDetail.isEditDepartmentHead = true;
                probationaryDetail.canSaveDepartmentHead = true;
                probationaryDetail.canViewDepartmentHead = true;
            }
            //Check when access as Department Head but no permission
            else if(userId == probationary.department_head_id__c && probationary.Status__c != ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name()) {
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
                probationaryDetail.isEditSectionHead = false;
                probationaryDetail.canSaveSectionHead = false;
                probationaryDetail.isEditDepartmentHead = false;
                probationaryDetail.canSaveDepartmentHead = false;
                probationaryDetail.canViewDepartmentHead = true;
            }
            //Check when access as Reassign Department Head but no permission
            else if(userId == probationary.Reassign_Department_Head_Id__c && probationary.Status__c != ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name()) {
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
            }
            //Check when access as part of Reassign Department Head but no permission
            else if(isReassignDepartmentHead) {
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
                probationaryDetail.isEditDepartmentHead = false;
                probationaryDetail.canSaveDepartmentHead = false;
                probationaryDetail.canViewDepartmentHead = true;
            }
            else {
                probationaryDetail.canSubmit = false;
                probationaryDetail.canReassign = false;
                probationaryDetail.canSendBack = false;
                probationaryDetail.isEditSectionHead = false;
                probationaryDetail.canSaveSectionHead = false;
                probationaryDetail.isEditDepartmentHead = false;
                probationaryDetail.canSaveDepartmentHead = false;
                probationaryDetail.canViewDepartmentHead = false;
            }
        }
        
        //Disable All button at this stage
        if(probationary.Status__c == ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name() || 
          	probationary.Status__c == ESS_Enum.ProbationApproveStatus.Completed.name()) {
            probationaryDetail.canSaveSectionHead = false;
            probationaryDetail.canSaveDepartmentHead = false;
            probationaryDetail.canSubmit = false;
            probationaryDetail.canReassign = false;
            probationaryDetail.canSendBack = false;
            probationaryDetail.isEditSectionHead = false;
            probationaryDetail.isEditDepartmentHead = false;
            probationaryDetail.canViewDepartmentHead = true;
        }
        
        //Check Access Privilege
        if(userId != probationary.OwnerId && userId != probationary.Section_Head_Id__c && userId != probationary.Reassign_Section_Head_Id__c &&
           userId != probationary.Department_Head_Id__c && userId != probationary.Reassign_Department_Head_Id__c &&
          	!isReassignSectionHead && !isReassignDepartmentHead) {
               
               boolean isProbationAdmin = ESS_PrivilegeHandler.checkProbationAdminUser(userId);
               boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
               
               if(!isProbationAdmin && !isAdmin) {
                   probationaryDetail = null;
               }
               else {
                   probationaryDetail.canViewDepartmentHead = true;
               }
        }
        
        return probationaryDetail;
    }

    @TestVisible
    private static List<ESS_Probationary_DTO.ApprovalHistoryDTO> DeserializeHistoryWorkflows(string historyJSON) {
        List<ESS_Probationary_DTO.ApprovalHistoryDTO> approvalHistoriesDTO = (List<ESS_Probationary_DTO.ApprovalHistoryDTO>)JSON.deserialize(historyJSON, List<ESS_Probationary_DTO.ApprovalHistoryDTO>.class);
		return approvalHistoriesDTO;
    }
    
    @TestVisible //TODO
    public static List<ESS_Probationary_DTO.ReassignDTO> DeserializeReassigns(string reassignJSON) {
        
        List<ESS_Probationary_DTO.ReassignDTO> reassignsDTO = (List<ESS_Probationary_DTO.ReassignDTO>)JSON.deserialize(reassignJSON, List<ESS_Probationary_DTO.ReassignDTO>.class);

        return reassignsDTO;
        
    }
    
    @TestVisible
    private static List<ESS_Probationary_DTO.ApprovalHistoryDTO> assignToApprovalHistory(ESS_Probationary_DTO.ApprovalHistoryDTO approval, string approvalHistoryJSON) {
        
        List<ESS_Probationary_DTO.ApprovalHistoryDTO> approvalHistories = new List<ESS_Probationary_DTO.ApprovalHistoryDTO>();
        
        if(string.isNotEmpty(approvalHistoryJSON)) {
            approvalHistories = DeserializeHistoryWorkflows(approvalHistoryJSON);
            
            if(approvalHistories.size() > 0) {
                approvalHistories.add(approval);
            }
        }
        else {
            approvalHistories.add(approval);
        }
        
        return approvalHistories;
        
    }
    
    private static List<ESS_Probationary__c> allProbations() {
        List<ESS_Probationary__c> Probations = [select id, employee_id__c from ESS_Probationary__c];
        return Probations;
    }
    
    private static boolean checkCanSaveSectionHead(string status) {
        boolean canSave = false;
        if(status == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead)) {
            canSave = true;
        }
        return canSave;
    }
    
    private static boolean checkCanSaveDepartmentHead(string status) {
        boolean canSave = false;
        if(status == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead)) {
            canSave = true;
        }
        return canSave;
    }
    
    private static boolean checkCanSubmit(string status) {
        boolean canSubmit = false;
        if(status == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead)) {
            canSubmit = true;
        }
        else if(status == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead)) {
            canSubmit = true;
        }
        else if(status == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead)) {
            canSubmit = true;
        }
        return canSubmit;
    }
    
    private static boolean checkCanReassign(string status) {
        boolean canReassign = false;
        if(status == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead)) {
            canReassign = true;
        }
        else if(status == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead)) {
            canReassign = true;
        }
        return canReassign;
    }
    
    private static boolean checkCanSendBack(string status) {
        boolean canSendBack = false;
        if(status == String.ValueOf(ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead)) {
            canSendBack = true;
        }
        return canSendBack;
    }
    
    private static boolean checkCanUploadPersonalFolder(string status) {
        boolean canUpload = false;
        if(status == String.ValueOf(ESS_Enum.ProbationApproveStatus.UploadFailed)) {
            canUpload = true;
        }
        return canUpload;
    }
    
    public class ReassignPersonSearchCriteria {
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
    }
    
    public static void ProbationCompletedFlagScript() {
        
        string data = 'IN';
        string query = 'select id, Employee_ID__c, Employee_Date_Joined__c, Probationary_Date__c, Probation_Section_Head_Skip__c, Probation_Section_Head_Id__c, Probation_Section_Head_Name__c, Probation_Section_Head_Position__c, Probation_VP_Id__c, Probation_VP_Name__c, Probation_VP_Position__c, CEP__c, Probation_Section_Head_TH__c, Probation_VP_TH__c, Probation_Completed__c from ESS_Master_Employee__c where data__c =: data AND Probation_Completed__c = false order by employee_id__c asc';
         
        Date todayDate = system.Date.today();
        Date startDate = Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day());
        
        List<ESS_Master_Employee__c> Masters = new List<ESS_Master_Employee__c>();
        Masters = database.query(query);
        
        if(Masters.size() > 0) {
            for(ESS_Master_Employee__c Master : Masters) {
                if(Master.Employee_Date_Joined__c != null) {
                    Date dateJoined = Date.newInstance(Master.Employee_Date_Joined__c.year(), Master.Employee_Date_Joined__c.month(), Master.Employee_Date_Joined__c.day());
                    Integer dayDiff = dateJoined.daysBetween(startDate);
                    if(dayDiff > 151) {
                        Master.Probation_Completed__c = true;
                    }
                }
                else {
                    Master.Probation_Completed__c = true;
                }
            }
            
            update(Masters);
        }
        
    }
    
    public static boolean isReassignSectionHead(string json, string userId) {
        boolean isReassignSectionHead = false;
        if(string.isNotEmpty(json)) {
            List<ESS_Probationary_DTO.ReassignDTO> reassignSectionHeads = DeserializeReassigns(json);
            if(reassignSectionHeads.size() > 0) {
                for(ESS_Probationary_DTO.ReassignDTO reassign : reassignSectionHeads) {
                    if(reassign.isAssignedBy != null) {
                        if(reassign.userId == userId && !reassign.isAssignedBy) {
                            isReassignSectionHead = true;
                            break;
                        }
                    }
                }
            }
        }
        
        return isReassignSectionHead;
        
    }
    
    public static boolean isReassignDepartmentHead(string json, string userId) {
        boolean isReassignDepartmentHead = false;
        if(string.isNotEmpty(json)) {
            List<ESS_Probationary_DTO.ReassignDTO> reassignDepartmentHeads = DeserializeReassigns(json);
            if(reassignDepartmentHeads.size() > 0) {
                for(ESS_Probationary_DTO.ReassignDTO reassign : reassignDepartmentHeads) {
                    if(reassign.isAssignedBy != null) {
                        if(reassign.userId == userId && !reassign.isAssignedBy) {
                            isReassignDepartmentHead = true;
                            break;
                        }
                    }
                }
            }
        }
        return isReassignDepartmentHead;
    }
    
    public static boolean sortByDateStampDesc {get;set;}
    public static boolean sortByEmployeeIdDesc {get;set;}
    public static boolean sortByEmployeeNameDesc {get;set;}
    public static boolean sortByLevelDesc {get;set;}
    public static boolean sortByDateJoinedCompanyDesc {get;set;}
    public static boolean sortByDateCompletedProbationDesc {get;set;}
    public static boolean sortBySectionHeadNameDesc {get;set;}
    public static boolean sortByDepartmentHeadNameDesc {get;set;}
    public static boolean sortByCEPDesc {get;set;}
    public static boolean sortByFunctionDesc {get;set;}
    public static boolean sortByDepartmentDesc {get;set;}
    public static boolean sortBySectionDesc {get;set;}
    public static boolean sortByUnitDesc {get;set;}
    
    public static string DATESTAMP_SORT = 'DateStamp';
    public static string SORT_BY = DATESTAMP_SORT;
    public static string DATESTAMP_SORT_DESC = 'DateStampDesc';
    public static string EMPLOYEEID_SORT = 'EmployeeId';
    public static string EMPLOYEEID_SORT_DESC = 'EmployeeIdDesc';
    public static string EMPLOYEENAME_SORT = 'EmployeeName';
    public static string EMPLOYEENAME_SORT_DESC = 'EmployeeNameDesc';
    public static string LEVEL_SORT = 'Level';
    public static string LEVEL_SORT_DESC = 'LevelDesc';
    public static string DATEJOINEDCOMPANY_SORT = 'DateJoinedCompany';
    public static string DATEJOINEDCOMPANY_SORT_DESC = 'DateJoinedCompanyDesc';
    public static string DATECOMPLETEDPROBATION_SORT = 'DateCompletedProbation';
    public static string DATECOMPLETEDPROBATION_SORT_DESC = 'DateCompletedProbationDesc';
    public static string SECTIONHEADNAME_SORT = 'SectionHeadName';
    public static string SECTIONHEADNAME_SORT_DESC = 'SectionHeadNameDesc';
    public static string DEPARTMENTHEADNAME_SORT = 'DepartmentHeadName';
    public static string DEPARTMENTHEADNAME_SORT_DESC = 'DepartmentHeadNameDesc';
    public static string CEP_SORT = 'CEP';
    public static string CEP_SORT_DESC = 'CEPDesc';
    public static string FUNCTION_SORT = 'Function';
    public static string FUNCTION_SORT_DESC = 'FunctionDesc';
    public static string DEPARTMENT_SORT = 'Department';
    public static string DEPARTMENT_SORT_DESC = 'DepartmentDesc';
    public static string SECTION_SORT = 'Section';
    public static string SECTION_SORT_DESC = 'SectionDesc';
    public static string UNIT_SORT = 'Unit';
    public static string UNIT_SORT_DESC = 'UnitDesc';
    
    public class ProbationaryListSortDTO implements Comparable {
        @RemoteAction
        public string probationId {get;set;}
        @RemoteAction
        public string ownerId {get;set;}
        @RemoteAction
        public boolean isDisable {get;set;}
        @RemoteAction
        public date dateStamp {get;set;} 
        @RemoteAction
        public string companyName {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeNameEN {get;set;}
        @RemoteAction
        public string level {get;set;}
        @RemoteAction
        public date dateJoinedCompany {get;set;}
        @RemoteAction
        public date dateCompletedProbation {get;set;}
        @RemoteAction
        public string sectionHead {get;set;}
        @RemoteAction
        public string sectionHeadTH {get;set;}
        @RemoteAction
        public string sectionHeadName {get;set;}
        @RemoteAction
        public string sectionHeadEmployeeId {get;set;}
        @RemoteAction
        public string sectionHeadPosition {get;set;}
        @RemoteAction
        public string departmentHead {get;set;}
        @RemoteAction
        public string departmentHeadTH {get;set;}
        @RemoteAction
        public string departmentHeadName {get;set;}
        @RemoteAction
        public string departmentHeadEmployeeId {get;set;}
        @RemoteAction
        public string departmentHeadPosition {get;set;}
        @RemoteAction
        public string cep {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
        
        public ProbationaryListSortDTO() { }
        
        //Sort By
        public ProbationaryListSortDTO(date dateStamp, string employeeId, string employeeName, string level, date dateJoinedCompany, date dateCompletedProbation, string sectionHeadName, 
                                  string departmentHead, string cep, string function, string department, string section, string unit) {
            
            this.dateStamp = dateStamp;
            this.employeeId = employeeId;
            this.employeeName = employeeName;
            this.level = level;
            this.dateJoinedCompany = dateJoinedCompany;
            this.dateCompletedProbation = dateCompletedProbation;
            this.sectionHeadName = sectionHeadName;
            this.departmentHead = departmentHead;
            this.cep = cep;
            this.function = function; 
            this.department = department; 
            this.section = section; 
            this.unit = unit; 
                                
        }
        
        //DateStamp Sort
        public integer sortByDateStamp(ProbationaryListSortDTO Probation) {
            if(this.dateStamp > Probation.dateStamp) {
                return 1;
            }
            if(this.dateStamp == Probation.dateStamp) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByDateStampDesc(ProbationaryListSortDTO Probation) {
            if(this.dateStamp < Probation.dateStamp) {
                return 1;
            }
            if(this.dateStamp == Probation.dateStamp) {
                return 0;
            }
            
            return -1;
        }
        //EmployeeId Sort
        public integer sortByEmployeeId(ProbationaryListSortDTO Probation) {
            if(this.employeeId > Probation.employeeId) {
                return 1;
            }
            if(this.employeeId == Probation.employeeId) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByEmployeeIdDesc(ProbationaryListSortDTO Probation) {
            if(this.employeeId < Probation.employeeId) {
                return 1;
            }
            if(this.employeeId == Probation.employeeId) {
                return 0;
            }
            
            return -1;
        }
        //EmployeeName Sort
        public integer sortByEmployeeName(ProbationaryListSortDTO Probation) {
            if(this.employeeNameEN > Probation.employeeNameEN) {
                return 1;
            }
            if(this.employeeNameEN == Probation.employeeNameEN) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByEmployeeNameDesc(ProbationaryListSortDTO Probation) {
            if(this.employeeNameEN < Probation.employeeNameEN) {
                return 1;
            }
            if(this.employeeNameEN == Probation.employeeNameEN) {
                return 0;
            }
            
            return -1;
        }
        //Level Sort
        public integer sortByLevel(ProbationaryListSortDTO Probation) {
            if(this.level > Probation.level) {
                return 1;
            }
            if(this.level == Probation.level) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByLevelDesc(ProbationaryListSortDTO Probation) {
            if(this.level < Probation.level) {
                return 1;
            }
            if(this.level == Probation.level) {
                return 0;
            }
            
            return -1;
        }
        //DateJoinedCompany Sort
        public integer sortByDateJoinedCompany(ProbationaryListSortDTO Probation) {
            if(this.dateJoinedCompany > Probation.dateJoinedCompany) {
                return 1;
            }
            if(this.dateJoinedCompany == Probation.dateJoinedCompany) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByDateJoinedCompanyDesc(ProbationaryListSortDTO Probation) {
            if(this.dateJoinedCompany < Probation.dateJoinedCompany) {
                return 1;
            }
            if(this.dateJoinedCompany == Probation.dateJoinedCompany) {
                return 0;
            }
            
            return -1;
        }
        //DateCompletedProbation Sort
        public integer sortByDateCompletedProbation(ProbationaryListSortDTO Probation) {
            if(this.dateCompletedProbation > Probation.dateCompletedProbation) {
                return 1;
            }
            if(this.dateCompletedProbation == Probation.dateCompletedProbation) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByDateCompletedProbationDesc(ProbationaryListSortDTO Probation) {
            if(this.dateCompletedProbation < Probation.dateCompletedProbation) {
                return 1;
            }
            if(this.dateCompletedProbation == Probation.dateCompletedProbation) {
                return 0;
            }
            
            return -1;
        }
        //SectionHeadName Sort
        public integer sortBySectionHeadName(ProbationaryListSortDTO Probation) {
            if(this.sectionHeadName > Probation.sectionHeadName) {
                return 1;
            }
            if(this.sectionHeadName == Probation.sectionHeadName) {
                return 0;
            }
            
            return -1;
        }
        public integer sortBySectionHeadNameDesc(ProbationaryListSortDTO Probation) {
            if(this.sectionHeadName < Probation.sectionHeadName) {
                return 1;
            }
            if(this.sectionHeadName == Probation.sectionHeadName) {
                return 0;
            }
            
            return -1;
        }
        //DepartmentHeadName Sort
        public integer sortByDepartmentHeadName(ProbationaryListSortDTO Probation) {
            if(this.departmentHeadName > Probation.departmentHeadName) {
                return 1;
            }
            if(this.departmentHeadName == Probation.departmentHeadName) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByDepartmentHeadNameDesc(ProbationaryListSortDTO Probation) {
            if(this.departmentHeadName < Probation.departmentHeadName) {
                return 1;
            }
            if(this.departmentHeadName == Probation.departmentHeadName) {
                return 0;
            }
            
            return -1;
        }
        //CEP Sort
        public integer sortByCEP(ProbationaryListSortDTO Probation) {
            if(this.cep > Probation.cep) {
                return 1;
            }
            if(this.cep == Probation.cep) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByCEPDesc(ProbationaryListSortDTO Probation) {
            if(this.cep < Probation.cep) {
                return 1;
            }
            if(this.cep == Probation.cep) {
                return 0;
            }
            
            return -1;
        }
        //Function Sort
        public integer sortByFunction(ProbationaryListSortDTO Probation) {
            if(this.function > Probation.function) {
                return 1;
            }
            if(this.function == Probation.function) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByFunctionDesc(ProbationaryListSortDTO Probation) {
            if(this.function < Probation.function) {
                return 1;
            }
            if(this.function == Probation.function) {
                return 0;
            }
            
            return -1;
        }
        //Department Sort
        public integer sortByDepartment(ProbationaryListSortDTO Probation) {
            if(this.department > Probation.department) {
                return 1;
            }
            if(this.department == Probation.department) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByDepartmentDesc(ProbationaryListSortDTO Probation) {
            if(this.department < Probation.department) {
                return 1;
            }
            if(this.department == Probation.department) {
                return 0;
            }
            
            return -1;
        }
        //Section Sort
        public integer sortBySection(ProbationaryListSortDTO Probation) {
            if(this.section > Probation.section) {
                return 1;
            }
            if(this.section == Probation.section) {
                return 0;
            }
            
            return -1;
        }
        public integer sortBySectionDesc(ProbationaryListSortDTO Probation) {
            if(this.section < Probation.section) {
                return 1;
            }
            if(this.section == Probation.section) {
                return 0;
            }
            
            return -1;
        }
        //Unit Sort
        public integer sortByUnit(ProbationaryListSortDTO Probation) {
            if(this.unit > Probation.unit) {
                return 1;
            }
            if(this.unit == Probation.unit) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByUnitDesc(ProbationaryListSortDTO Probation) {
            if(this.unit < Probation.unit) {
                return 1;
            }
            if(this.unit == Probation.unit) {
                return 0;
            }
            
            return -1;
        }
        
        public Integer compareTo(Object obj) {
            ProbationaryListSortDTO Probation = (ProbationaryListSortDTO)(obj);

            if (SORT_BY == DATESTAMP_SORT) {
                return sortByDateStamp(Probation);
            }
            else if (SORT_BY == DATESTAMP_SORT_DESC) {
                return sortByDateStampDesc(Probation);
            }
            else if (SORT_BY == EMPLOYEEID_SORT) {
                return sortByEmployeeId(Probation);
            }
            else if (SORT_BY == EMPLOYEEID_SORT_DESC) {
                return sortByEmployeeIdDesc(Probation);
            }
            else if (SORT_BY == EMPLOYEENAME_SORT) {
                return sortByEmployeeName(Probation);
            }
            else if (SORT_BY == EMPLOYEENAME_SORT_DESC) {
                return sortByEmployeeNameDesc(Probation);
            }
            else if (SORT_BY == LEVEL_SORT) {
                return sortByLevel(Probation);
            }
            else if (SORT_BY == LEVEL_SORT_DESC) {
                return sortByLevelDesc(Probation);
            }
            else if (SORT_BY == DATEJOINEDCOMPANY_SORT) {
                return sortByDateJoinedCompany(Probation);
            }
            else if (SORT_BY == DATEJOINEDCOMPANY_SORT_DESC) {
                return sortByDateJoinedCompanyDesc(Probation);
            }
            else if (SORT_BY == DATECOMPLETEDPROBATION_SORT) {
                return sortByDateCompletedProbation(Probation);
            }
            else if (SORT_BY == DATECOMPLETEDPROBATION_SORT_DESC) {
                return sortByDateCompletedProbationDesc(Probation);
            }
            else if (SORT_BY == SECTIONHEADNAME_SORT) {
                return sortBySectionHeadName(Probation);
            }
            else if (SORT_BY == SECTIONHEADNAME_SORT_DESC) {
                return sortBySectionHeadNameDesc(Probation);
            }
            else if (SORT_BY == DEPARTMENTHEADNAME_SORT) {
                return sortByDepartmentHeadName(Probation);
            }
            else if (SORT_BY == DEPARTMENTHEADNAME_SORT_DESC) {
                return sortByDepartmentHeadNameDesc(Probation);
            }
            else if (SORT_BY == CEP_SORT) {
                return sortByCEP(Probation);
            }
            else if (SORT_BY == CEP_SORT_DESC) {
                return sortByCEPDesc(Probation);
            }
            else if (SORT_BY == FUNCTION_SORT) {
                return sortByFunction(Probation);
            }
            else if (SORT_BY == FUNCTION_SORT_DESC) {
                return sortByFunctionDesc(Probation);
            }
            else if (SORT_BY == DEPARTMENT_SORT) {
                return sortByDepartment(Probation);
            }
            else if (SORT_BY == DEPARTMENT_SORT_DESC) {
                return sortByDepartmentDesc(Probation);
            }
            else if (SORT_BY == SECTION_SORT) {
                return sortBySection(Probation);
            }
            else if (SORT_BY == SECTION_SORT_DESC) {
                return sortBySectionDesc(Probation);
            }
            else if (SORT_BY == UNIT_SORT) {
                return sortByUnit(Probation);
            }
            else if (SORT_BY == UNIT_SORT_DESC) {
                return sortByUnitDesc(Probation);
            }

            // If we don't have a know sort by, let's just return that they are all equal
            return 0;
        }
    }
    
    public static void sortByDateStamp(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByDateStampDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.DATESTAMP_SORT;
            
            sortByDateStampDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.DATESTAMP_SORT_DESC;
            
            sortByDateStampDesc = true;
        }
        
        probationarSortLists.sort();
        
        //sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortByEmployeeId(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByEmployeeIdDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.EMPLOYEEID_SORT;
            
            sortByEmployeeIdDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.EMPLOYEEID_SORT_DESC;
            
            sortByEmployeeIdDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        //sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortByEmployeeName(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByEmployeeNameDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.EMPLOYEENAME_SORT;
            
            sortByEmployeeNameDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.EMPLOYEENAME_SORT_DESC;
            
            sortByEmployeeNameDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        //sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortByLevel(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByLevelDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.LEVEL_SORT;
            
            sortByLevelDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.LEVEL_SORT_DESC;
            
            sortByLevelDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        //sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortByDateJoinedCompany(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByDateJoinedCompanyDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.DATEJOINEDCOMPANY_SORT;
            
            sortByDateJoinedCompanyDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.DATEJOINEDCOMPANY_SORT_DESC;
            
            sortByDateJoinedCompanyDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        //sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortByDateCompletedProbation(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByDateCompletedProbationDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.DATECOMPLETEDPROBATION_SORT;
            
            sortByDateCompletedProbationDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.DATECOMPLETEDPROBATION_SORT_DESC;
            
            sortByDateCompletedProbationDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        //sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortBySectionHeadName(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortBySectionHeadNameDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.SECTIONHEADNAME_SORT;
            
            sortBySectionHeadNameDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.SECTIONHEADNAME_SORT_DESC;
            
            sortBySectionHeadNameDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        //sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortByDepartmentHeadName(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByDepartmentHeadNameDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.DEPARTMENTHEADNAME_SORT;
            
            sortByDepartmentHeadNameDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.DEPARTMENTHEADNAME_SORT_DESC;
            
            sortByDepartmentHeadNameDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        //sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortByCEP(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByCEPDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.CEP_SORT;
            
            sortByCEPDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.CEP_SORT_DESC;
            
            sortByDepartmentHeadNameDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        //sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortByFunction(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByFunctionDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.FUNCTION_SORT;
            
            sortByCEPDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.FUNCTION_SORT_DESC;
            
            sortByFunctionDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        //sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }
    
    public static void sortByDepartment(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByDepartmentDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.DEPARTMENT_SORT;
            
            sortByDepartmentDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.DEPARTMENT_SORT_DESC;
            
            sortByDepartmentDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        //sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }

    public static void sortBySection(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortBySectionDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.SECTION_SORT;
            
            sortBySectionDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.SECTION_SORT_DESC;
            
            sortBySectionDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        //sortBySectionDesc = false;
        sortByUnitDesc = false;
        
    }

    public static void sortByUnit(List<ProbationaryListSortDTO> probationarSortLists) {
    
        if(!sortByUnitDesc) {
            ESS_Probationary.SORT_BY = ESS_Probationary.UNIT_SORT;
            
            sortByUnitDesc = false;
        }
        else {
            ESS_Probationary.SORT_BY = ESS_Probationary.UNIT_SORT_DESC;
            
            sortByUnitDesc = true;
        }
        
        probationarSortLists.sort();
        
        sortByDateStampDesc = false;
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByLevelDesc = false;
        sortByDateJoinedCompanyDesc = false;
        sortByDateCompletedProbationDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        sortByCEPDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        //sortByUnitDesc = false;
        
    }
    
    public static List<ESS_Probationary__c> ProbationExisted(string employeeId) {
        List<ESS_Probationary__c> Probations = [select id, status__c from ESS_Probationary__c where Employee_Id__c = :employeeId];
        return Probations;
    }
    
    public static string ProbationCurrentStatus(string recordId) {
        ESS_Probationary__c Probation = [select id, status__c from ESS_Probationary__c where Id = :recordId];
        return Probation.Status__c;
    }
    
    public static string emailReminders() {
        List<string> reminders = new List<string>();
        reminders.add(String.ValueOf(date.today().addDays(5)));
        reminders.add(String.ValueOf(date.today().addDays(8)));
        reminders.add(String.ValueOf(date.today().addDays(9)));
        reminders.add(String.ValueOf(date.today().addDays(10)));
        reminders.add(String.ValueOf(date.today().addDays(11)));
        reminders.add(String.ValueOf(date.today().addDays(12)));
        
        string reminder = JSON.serialize(reminders);
        return reminder;
    }

}