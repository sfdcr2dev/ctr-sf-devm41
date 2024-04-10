/* Author Softever */
global with sharing class ESS_Retirement {
    
    private static List<ESS_Retirement_DTO.RetirementListDTO> retirementLists;
    private static List<ESS_Retirement_DTO.RetirementApproveListDTO> retirementApproveLists;
    private static ESS_Retirement_DTO.RetirementDetailDTO retirementDetail;
    public static List<RetirementListSortDTO> retirementSortLists;
    
    static {
    }
    
    @RemoteAction
    public static integer GetRetirementListsCount() {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        List<ESS_Master_Employee__c> Employees = new List<ESS_Master_Employee__c>();
        
        integer currentYear = system.Datetime.now().year();
        integer year = Integer.ValueOf(currentYear + 1);
        integer twoYear = Integer.ValueOf(currentYear + 2);
        date retirementStartDate = Date.newInstance(year, 1, 2);
        date retirementEndDate = Date.newInstance(twoYear, 1, 1);
        
        string data = 'IN';
        string query = 'select id, Employee_ID__c, Name_Emp_EN_FN__c, Employee_Retirement_Date__c, Employee_DOB__c, Retirement_Section_Head_Skip__c, Retirement_Section_Head_Id__c , Retirement_Section_Head_Name__c, Retirement_Section_Head_Position__c, Retirement_VP_Id__c, Retirement_VP_Name__c, Retirement_VP_Position__c, Retirement_Section_Head_TH__c, Retirement_VP_TH__c from ESS_Master_Employee__c where data__c =: data AND (Employee_Retirement_Date__c >=: retirementStartDate AND Employee_Retirement_Date__c <=: retirementEndDate) order by Employee_Id__c asc';
        
        Employees = database.query(query);
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c, Retirement_Selection__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, MAINPOSITION__c from PISUsers__c where user__c != null AND Active__c = true]; //AND MAINPOSITION__c = true
        
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
        
        List<ESS_Retirement__c> allRetirements = allRetirements();
        
        List<ESS_Retirement_DTO.RetirementListDTO> finalRetirementLists = new List<ESS_Retirement_DTO.RetirementListDTO>();
        if(Employees.size() > 0) {
    	    
            for(ESS_Master_Employee__c Employee : Employees) {
                ESS_Retirement_DTO.RetirementListDTO assign = new ESS_Retirement_DTO.RetirementListDTO();
                assign = assignToRetirementListDTO(Employee, mapPOSIDPISUsers, mapPISUsers, allRetirements);
                if(string.isNotEmpty(assign.employeeid)) {
                	//Check show only TOP user
                    PISUsers__c PISUser = mapPISUsers.get(Employee.Employee_ID__c);
                    if(PISUser != null) {
                        if(PISUser.COMPANYNAME__c == 'TOP' && PISUser.Retirement_Selection__c) {
                            //Check Employee DOB
                            List<string> dobYears = new List<string> {string.Valueof(Integer.valueOf(currentYear) - 59), string.valueOf(Integer.valueOf(currentYear) - 54)};
                            integer employeeDOBYear = Employee.Employee_DOB__c.Year();
                            boolean existed = dobYears.contains(String.ValueOf(employeeDOBYear));
                            if(existed) {
                                finalRetirementLists.add(assign);                            
                            }
                        }
                    }
                }
            }
            
        }
        
        return finalRetirementLists.size();
    }
    
    @RemoteAction
    public static List<ESS_Retirement_DTO.RetirementListDTO> GetRetirementLists(
        //employeeId, employeeName, birthDate, age, function, deparment, section, level, sectionHead, departmentHead
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
            
        string userId = ESS_PrivilegeHandler.getUserId();
        
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        List<ESS_Retirement_DTO.RetirementListDTO> results = new List<ESS_Retirement_DTO.RetirementListDTO>();
        retirementSortLists = new List<RetirementListSortDTO>();
        List<ESS_Master_Employee__c> Employees = new List<ESS_Master_Employee__c>();
        
        integer currentYear = system.Datetime.now().year();
        integer year = Integer.ValueOf(currentYear + 1);
        integer twoYear = Integer.ValueOf(currentYear + 2);
        date retirementStartDate = Date.newInstance(year, 1, 2);
        date retirementEndDate = Date.newInstance(twoYear, 1, 1);
        
        string data = 'IN';
        string query = 'select id, Employee_ID__c, Name_Emp_EN_FN__c, Employee_Retirement_Date__c, Employee_DOB__c, Retirement_Section_Head_Skip__c, ' +
            			'Retirement_Section_Head_Id__c , Retirement_Section_Head_Name__c, Retirement_VP_Id__c, Retirement_VP_Name__c, Retirement_Section_Head_Position__c, ' +
            			'Retirement_Section_Head_Position_TH__c, Retirement_VP_Position__c, Retirement_VP_Position_TH__c, Retirement_Section_Head_TH__c, Retirement_VP_TH__c from ESS_Master_Employee__c ' +
            			'where data__c =: data AND (Employee_Retirement_Date__c >=: retirementStartDate AND Employee_Retirement_Date__c <=: retirementEndDate) ';
          
        Employees = database.query(query);
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c, Retirement_Selection__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, MAINPOSITION__c from PISUsers__c where User__c != null AND Active__c = true]; //AND CompanyName__c = 'TOP' AND Retirement_Selection__c = true
        
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
            
        List<ESS_Retirement__c> allRetirements = allRetirements();
            
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
                RetirementListSortDTO assign = new RetirementListSortDTO();
                assign = assignToRetirementListSortDTO(Master, mapPOSIDPISUsers, mapPISUsers, allRetirements);
                if(string.isNotEmpty(assign.employeeid)) {
                    //Check show only TOP user
                    PISUsers__c PISUser = mapPISUsers.get(Master.Employee_ID__c);
                    if(PISUser.COMPANYNAME__c == 'TOP' && PISUser.Retirement_Selection__c) {
                		//Check Employee DOB
                        List<string> dobYears = new List<string> {string.Valueof(Integer.valueOf(currentYear) - 59), string.valueOf(Integer.valueOf(currentYear) - 54)};
                        integer employeeDOBYear = Master.Employee_DOB__c.Year();
                		boolean existed = dobYears.contains(String.ValueOf(employeeDOBYear));
                        if(existed) {
                			retirementSortLists.add(assign);                         
                        }
                    }
                }
                
            }     
        }
            
        //Custom Sort By    
        if(sortByParam.sortBy == 'employeeId') {
        	if(sortByParam.ascending) {
                sortByEmployeeIdDesc = false;
                sortByEmployeeId(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortByEmployeeIdDesc = true;
                sortByEmployeeId(retirementSortLists);
            }
        }
        else if(sortByParam.sortBy == 'employeeName') {
        	if(sortByParam.ascending) {
                sortByEmployeeNameDesc = false;
                sortByEmployeeName(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortByEmployeeNameDesc = true;
                sortByEmployeeName(retirementSortLists);
            }
        }
        else if(sortByParam.sortBy == 'birthDate') {
        	if(sortByParam.ascending) {
                sortByBirthDateDesc = false;
                sortByBirthDate(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortByBirthDateDesc = true;
                sortByBirthDate(retirementSortLists);
            }
        }
        else if(sortByParam.sortBy == 'age') {
        	if(sortByParam.ascending) {
                sortByAgeDesc = false;
                sortByAge(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortByAgeDesc = true;
                sortByAge(retirementSortLists);
            }
        }
        else if(sortByParam.sortBy == 'function') {
        	if(sortByParam.ascending) {
                sortByFunctionDesc = false;
                sortByFunction(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortByFunctionDesc = true;
                sortByFunction(retirementSortLists);
            }
        }
        else if(sortByParam.sortBy == 'department') {
        	if(sortByParam.ascending) {
                sortByDepartmentDesc = false;
                sortByDepartment(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortByDepartmentDesc = true;
                sortByDepartment(retirementSortLists);
            }
        }
        else if(sortByParam.sortBy == 'section') {
        	if(sortByParam.ascending) {
                sortBySectionDesc = false;
                sortBySection(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortBySectionDesc = true;
                sortBySection(retirementSortLists);
            }
        }
        else if(sortByParam.sortBy == 'level') {
        	if(sortByParam.ascending) {
                sortByLevelDesc = false;
                sortByLevel(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortByLevelDesc = true;
                sortByLevel(retirementSortLists);
            }
        }
        else if(sortByParam.sortBy == 'sectionHead') {
        	if(sortByParam.ascending) {
                sortBySectionHeadNameDesc = false;
                sortBySectionHeadName(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortBySectionHeadNameDesc = true;
                sortBySectionHeadName(retirementSortLists);
            }
        }
        else if(sortByParam.sortBy == 'departmentHead') {
        	if(sortByParam.ascending) {
                sortByDepartmentHeadNameDesc = false;
                sortByDepartmentHeadName(retirementSortLists);
            }
            else if(!sortByParam.ascending) {
                sortByDepartmentHeadNameDesc = true;
                sortByDepartmentHeadName(retirementSortLists);
            }
        }
        else {
            sortByEmployeeIdDesc = false;
            sortByEmployeeId(retirementSortLists);
        } 
            
        Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
        Integer totalSize = retirementSortLists.size() - startIndex;
            
        for (Integer i = 0; i < pageParam.pageSize; i++ ) {
            if (i < totalSize) {
                
                ESS_Retirement_DTO.RetirementListDTO assign = new ESS_Retirement_DTO.RetirementListDTO();
                assign = convertToRetirementListDTO(retirementSortLists[startIndex + i]);
                results.add(assign);
                
            }else{
                break;
            }
        }
            
        return results;
            
    }
    
    @RemoteAction
    public static integer GetRetirementApproveListsCount(
        string year,
        boolean allStatus) {
            
        string userId = ESS_PrivilegeHandler.getUserId();
        
        List<ESS_Retirement__c> Retirements = new List<ESS_Retirement__c>();
        
        integer currentYear;   
        if(string.isnotempty(year) && year.toLowerCase() != 'all') {
            currentYear = Integer.ValueOf(year);
        }
        else {
        	currentYear = system.Datetime.now().year();
        }
            
        string query = 'select id, employee_id__c, employee_name__c, date_of_birth__c, age__c, function__c, department__c, section__c, level__c, section_head_id__c, ' +
            			'section_head__c, department_head_id__c, department_head__c, createddate, status__c, Created_Year__c from ESS_Retirement__c where Created_Year__c =: currentYear AND (section_head_id__c =: userId OR department_head_id__c =: userId)';
            
        List<string> statuses = new List<string>();
        if(allStatus) {
        	statuses = new List<string> {
                ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name(),
                ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name(),
                ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name(),
                ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name(),
                ESS_Enum.RetirementStatus.SendingToSAP.name(),
                ESS_Enum.RetirementStatus.Completed.name(),
                ESS_Enum.RetirementStatus.DefaultFromSystem.name(),
                ESS_Enum.RetirementStatus.UploadFailed.name()
            };
            query = query + ' AND status__c IN :statuses';
        }
        else {
            statuses = new List<string> {
                ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name(),
                ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()
            };
            query = query + ' AND status__c IN :statuses';
        }
            
        Retirements = database.query(query); 
          
        integer totalCount = 0;   
        if(allStatus) {
        	totalCount = Retirements.size();     
        }    
        else {
        	if(Retirements.size() > 0) {
                for(ESS_Retirement__c Retirement : Retirements) {
                    if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name() && 
                        Retirement.Section_Head_Id__c == userId) {
                        totalCount++;
                    }
                    else if(Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name() &&
                           Retirement.Department_Head_Id__c == userId) {
                        totalCount++;   
                    }
                }
            }        
        }
        
        return totalCount;
    }
    
    @RemoteAction
    public static List<ESS_Retirement_DTO.RetirementApproveListDTO> GetRetirementApproveLists(
        string year,
        boolean allStatus,
        //documentNo, employeeId, employeeName, retirementChoice, retirementDate, status, createdDate, employeeSubmitDate
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
            
        string userId = ESS_PrivilegeHandler.getUserId();
            
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
          
        List<ESS_Retirement_DTO.RetirementApproveListDTO> results = new List<ESS_Retirement_DTO.RetirementApproveListDTO>();
        List<ESS_Retirement__c> Retirements = new List<ESS_Retirement__c>();
        
        integer currentYear;   
        if(string.isnotempty(year) && year.toLowerCase() != 'all') {
            currentYear = Integer.ValueOf(year);
        }
        else {
        	currentYear = system.Datetime.now().year();
        }
            
        string query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, function__c, department__c, section__c, level__c, section_head_id__c, ' +
            			'section_head__c, department_head_id__c, department_head__c, status__c, createddate, Created_Year__c, Retirement_Choice__c, Retirement_Date__c, Submitted_Date__c from ESS_Retirement__c where Created_Year__c =: currentYear AND (section_head_id__c =: userId OR department_head_id__c =: userId)';
           
        /* if(string.isNotEmpty(status) && status.toLowerCase() != 'all') {
        	query = query + ' AND status__c =: status';
        } */
            
        List<string> statuses = new List<string>();
        if(allStatus) {
        	statuses = new List<string> {
                ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name(),
                ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name(),
                ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name(),
                ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name(),
                ESS_Enum.RetirementStatus.SendingToSAP.name(),
                ESS_Enum.RetirementStatus.Completed.name(),
                ESS_Enum.RetirementStatus.DefaultFromSystem.name(),
                ESS_Enum.RetirementStatus.UploadFailed.name()
            };
            query = query + ' AND status__c IN :statuses';
        }
        else {
            statuses = new List<string> {
                ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name(),
                ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()
            };
            query = query + ' AND status__c IN :statuses';
        }
            
        //Sort By    
        if(sortByParam.sortBy == 'documentNo') {
        	if(sortByParam.ascending) {
                Retirements = database.query(query + ' order by document_no__c asc');
            }
            else if(!sortByParam.ascending) {
    	        Retirements = database.query(query + ' order by document_no__c desc');
            }
        }
        else if(sortByParam.sortBy == 'employeeId') {
        	if(sortByParam.ascending) {
                Retirements = database.query(query + ' order by employee_id__c asc');
            }
            else if(!sortByParam.ascending) {
    	        Retirements = database.query(query + ' order by employee_id__c desc');
            }
        }
        else if(sortByParam.sortBy == 'employeeName') {
        	if(sortByParam.ascending) {
                Retirements = database.query(query + ' order by employee_name__c asc');
            }
            else if(!sortByParam.ascending) {
    	        Retirements = database.query(query + ' order by employee_name__c desc');
            }
        }
        else if(sortByParam.sortBy == 'retirementChoice') {
        	if(sortByParam.ascending) {
                Retirements = database.query(query + ' order by retirement_choice__c asc');
            }
            else if(!sortByParam.ascending) {
    	        Retirements = database.query(query + ' order by retirement_choice__c desc');
            }
        }
        else if(sortByParam.sortBy == 'retirementDate') {
        	if(sortByParam.ascending) {
                Retirements = database.query(query + ' order by retirement_date__c asc');
            }
            else if(!sortByParam.ascending) {
    	        Retirements = database.query(query + ' order by retirement_date__c desc');
            }
        }
        else if(sortByParam.sortBy == 'status') {
        	if(sortByParam.ascending) {
                Retirements = database.query(query + ' order by status__c asc');
            }
            else if(!sortByParam.ascending) {
    	        Retirements = database.query(query + ' order by status__c desc');
            }
        }
        else if(sortByParam.sortBy == 'createdDate') {
        	if(sortByParam.ascending) {
                Retirements = database.query(query + ' order by createddate asc');
            }
            else if(!sortByParam.ascending) {
    	        Retirements = database.query(query + ' order by createddate desc');
            }
        }
        else if(sortByParam.sortBy == 'submittedDate') {
        	if(sortByParam.ascending) {
                Retirements = database.query(query + ' order by submitted_date__c asc');
            }
            else if(!sortByParam.ascending) {
    	        Retirements = database.query(query + ' order by submitted_date__c desc');
            }
        }
        else {
        	Retirements = database.query(query);    
        }
            
        Integer startIndex = (pageParam.pageNo - 1) * pageParam.pageSize;
        Integer totalSize = Retirements.size() - startIndex;
        for (Integer i = 0; i < pageParam.pageSize; i++ ) {
            if (i < totalSize){
                if(allStatus) {
                    results.add(assignToRetirementApproveListDTO(Retirements[startIndex + i]));
                }
                else {
                    if(Retirements[startIndex + i].Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name() && 
                        Retirements[startIndex + i].Section_Head_Id__c == userId) {
                        results.add(assignToRetirementApproveListDTO(Retirements[startIndex + i]));
                    }
                    else if(Retirements[startIndex + i].Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name() &&
                           Retirements[startIndex + i].Department_Head_Id__c == userId) {
                        results.add(assignToRetirementApproveListDTO(Retirements[startIndex + i]));
                    }
                }
            }else{
                break;
            }
        }
            
        return results;
            
    }
    
    @RemoteAction
    public static ESS_Retirement_DTO.RetirementDetailDTO GetRetirementDetail(string retirementId) {
        
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
        
        retirementDetail = new ESS_Retirement_DTO.RetirementDetailDTO();
        
        if(string.isNotEmpty(retirementId)) {
            
            ESS_Retirement__c Retirement = new ESS_Retirement__c();
            
            string query = 'select id, ownerid, document_no__c, employee_id__c, age__c, status__c, employee_name_th__c, retirement_choice__c, employee_name__c, submitted_date__c, section_head__c, Section_Head_Id__c, ' +
                            'section_head_approve_date__c, department_head__c, Department_Head_Id__c, department_head_approve_date__c, completed_date__c, retirement_date__c, default_retirement_date__c, ' +
                            'history_json__c, Date_of_Birth__c, CreatedDate, Section_Head_Flow__c, Section_Head_TH__c, Department_Head_TH__c, employee_title__c, section_head_position_th__c, department_head_position_th__c from ESS_Retirement__c where Id =: retirementId';
            
            Retirement = Database.query(query);
            
            retirementDetail = assignToRetirementDetail(Retirement);
            
        }
        else {
            
            string query = 'select id, ownerId, document_no__c, employee_id__c, age__c, status__c, employee_name_th__c, retirement_choice__c, employee_name__c, submitted_date__c, section_head__c, Section_Head_Id__c, ' +
                            'section_head_approve_date__c, department_head__c, Department_Head_Id__c, department_head_approve_date__c, completed_date__c, retirement_date__c, default_retirement_date__c, ' +
                            'history_json__c, Date_of_Birth__c, CreatedDate, Section_Head_Flow__c, Section_Head_TH__c, Department_Head_TH__c, employee_title__c, section_head_position_th__c, department_head_position_th__c from ESS_Retirement__c where employee_id__c =: employeeId';
            
            ESS_Retirement__c Retirement = new ESS_Retirement__c();
        
            Retirement = Database.query(query);
            
            retirementDetail = assignToRetirementDetail(Retirement);
            
        
        }
        
        return retirementDetail;
    }
    
    @RemoteAction
    public static ESS_Retirement_DTO.RetirementDetailDTO SubmitRetirement(ESS_Retirement_DTO.RetirementDetailDTO retirement) {
        
        ESS_Retirement__c SubmitRetirement = [select id, ownerId, document_no__c, employee_name__c, employee_id__c, createddate, submitted_date__c, status__c, position__c, Section_Head_Id__c, Employee_Name_TH__c, History_JSON__c, Department_Head_Id__c, date_of_birth__c from ESS_Retirement__c where Id =: retirement.retirementId];
        
        string currentStatus = RetirementCurrentStatus(retirement.retirementId);
        
        if(retirement.currentStatus.key == ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name()) {
            
            if(currentStatus == ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name()) {
                throw new ESS_Exception('[MyError]This retirement has been submitted to section head.');
            }
            
            SubmitRetirement.First_Reminder__c = null;
            SubmitRetirement.Other_Reminder__c = null;
            
            //Set reminder for Section Head
            boolean isBeforeAugust = false;
            date firstReminder = date.today().addDays(7);
            date julyDate = date.newInstance(date.today().year(), 7, 31);
            date augustDate = date.newInstance(date.today().year(), 8, 15);
            
            if(firstReminder <= julyDate) {
                isBeforeAugust = true;
            }
            
            integer diffDate = 0;
            integer noOfReminder = 0;
            if(isBeforeAugust) {
                diffDate = firstReminder.daysBetween(julyDate);
                noOfReminder = diffDate / 7;
            }
            else {
                diffDate = firstReminder.daysBetween(augustDate);
                noOfReminder = diffDate / 3;
            }
            
            List<string> otherReminders = new List<string>();
            if(isBeforeAugust) {
                for(integer i=0; i<noOfReminder; i++) {
                    firstReminder = firstReminder.addDays(7);
                    string reminder = string.valueOf(firstReminder);
                    otherReminders.add(reminder);
                }
            }
            else {
                for(integer i=0; i<noOfReminder; i++) {
                    firstReminder = firstReminder.addDays(3);
                    string reminder = string.valueOf(firstReminder);
                    otherReminders.add(reminder);
                }
            }
            
            if(otherReminders.size() > 0) {
                SubmitRetirement.Section_Head_Reminder__c = JSON.serialize(otherReminders);
            }
            
            SubmitRetirement.Retirement_Choice__c = String.ValueOf(retirement.retirementChoice.key);
            if(SubmitRetirement.Retirement_Choice__c == ESS_Enum.RetirementChoice.ExactDateFor55Years.name()) {
                SubmitRetirement.Retirement_Date__c = SubmitRetirement.Date_of_Birth__c.addYears(55);
            }
            else if(SubmitRetirement.Retirement_Choice__c == ESS_Enum.RetirementChoice.ExactDateFor60Years.name()) {
                SubmitRetirement.Retirement_Date__c = SubmitRetirement.Date_of_Birth__c.addYears(60);
            }
            else if(SubmitRetirement.Retirement_Choice__c == ESS_Enum.RetirementChoice.EndOfMonth.name()) {
                date endOfMonth = SubmitRetirement.Date_of_Birth__c;
                integer nextMonth = endOfMonth.addMonths(1).month();
                integer nextYear = date.today().addYears(1).year();
                Date lastDayOfMonth = Date.newInstance(nextYear, nextMonth, 1);
                SubmitRetirement.Retirement_Date__c = lastDayOfMonth;
            }
            else if(SubmitRetirement.Retirement_Choice__c == ESS_Enum.RetirementChoice.EndOfYear.name()) {
                date endOfYear = SubmitRetirement.Date_of_Birth__c;
                integer nextYear = date.today().addYears(2).Year();
                Date lastDayOfYear = Date.newInstance(nextYear, 1, 1);
                SubmitRetirement.Retirement_Date__c = lastDayOfYear;
            }
            
            SubmitRetirement.Submitted_Date__c = date.today();
        	SubmitRetirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead);
        
            retirement.currentStatus = new ESS_Global.EnumValue('RetirementStatus');
            if(string.isNotEmpty(SubmitRetirement.Section_Head_Id__c)) {
                retirement.currentStatus.key = ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name();
                retirement.currentStatus.value = 'Waiting for Approval by Immediate Line/Section Head';
            }
            else {
                
                if(currentStatus == ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()) {
                    throw new ESS_Exception('[MyError]This retirement has been submitted to department head.');
                }
                
                retirement.currentStatus.key = ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name();
                retirement.currentStatus.value = 'Waiting for Approval Department Head';
                SubmitRetirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead);
            }
            
            //Add to History JSON
            retirement.approvalHistories = new List<ESS_Retirement_DTO.ApprovalHistoryDTO>();
            if(string.isNotEmpty(SubmitRetirement.History_JSON__c)) {
                retirement.approvalHistories = DeserializeHistoryWorkflows(SubmitRetirement.History_JSON__c);
            }
            
            ESS_Retirement_DTO.ApprovalHistoryDTO ApprovalHistory = new ESS_Retirement_DTO.ApprovalHistoryDTO();
            ApprovalHistory.name = SubmitRetirement.Employee_ID__c + ' - ' + SubmitRetirement.Employee_Name__c;
            ApprovalHistory.approverRole = new ESS_Global.EnumValue('ApproverRole');
            ApprovalHistory.approverRole.key = ESS_Enum.ApproverRole.Employee.name();
            ApprovalHistory.approverRole.value = 'Employee';
            ApprovalHistory.position = SubmitRetirement.Position__c;
            ApprovalHistory.submittedDate = date.today();
            ApprovalHistory.status = new ESS_Global.EnumValue('RetirementApprovalStatus');
            ApprovalHistory.status.key = ESS_Enum.RetirementApprovalStatus.Submitted.name();
            ApprovalHistory.status.value = 'Submitted';
            ApprovalHistory.comment = '';
            
            retirement.approvalHistories.add(ApprovalHistory);
            
            SubmitRetirement.History_JSON__c = JSON.serialize(retirement.approvalHistories);

            //Send email noti
            if(string.isNotEmpty(SubmitRetirement.Section_Head_Id__c)) {
            	ESS_NotiAndEmailController.RetirementSendToEmployeeWhenSubmit(SubmitRetirement);
                ESS_NotiAndEmailController.RetirementSendToSectionHead(SubmitRetirement);
            }
            else {
            	ESS_NotiAndEmailController.RetirementSendToEmployeeWhenSubmit(SubmitRetirement);
            	ESS_NotiAndEmailController.RetirementSendToDepartmentHead(SubmitRetirement);
            }
        }
        
        //Update Retirement
        update(SubmitRetirement);
        
        return retirement;
    }
    
    @RemoteAction
    public static void RejectRetirement(string retirementId, string rejectComment, string status) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
        
        string currentStatus = RetirementCurrentStatus(retirementId);
        
        string query = 'select id, ownerId, document_no__c, employee_id__c, employee_name__c, status__c, History_JSON__c, submitted_date__c, reject_date__c, createddate, section_head_id__c, Department_Head_Id__c from ESS_Retirement__c where Id =: retirementId';
        
        ESS_Retirement__c Retirement = Database.query(query);
        
        List<ESS_Retirement_DTO.ApprovalHistoryDTO> histories = new List<ESS_Retirement_DTO.ApprovalHistoryDTO>();
        histories = DeserializeHistoryWorkflows(Retirement.History_JSON__c);

        if(status == ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name()) {
            
            if(currentStatus != ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name()) {
                throw new ESS_Exception('[MyError]This retirement status has been changed and cannot be reject.');
            }
            
            //Update History JSON
            ESS_Retirement_DTO.ApprovalHistoryDTO ApprovalHistory = new ESS_Retirement_DTO.ApprovalHistoryDTO();
            ApprovalHistory.name = PISUser.EMPLOYEEID__c + ' - ' + PISUser.EN_Fullname__c;
            ApprovalHistory.approverRole = new ESS_Global.EnumValue('ApproverRole');
            ApprovalHistory.approverRole.key = ESS_Enum.ApproverRole.SectionHead.name();
            ApprovalHistory.approverRole.value = 'SectionHead';
            ApprovalHistory.position = PISUser.OBJENFULLNAME__c;
            ApprovalHistory.submittedDate = date.today();
            ApprovalHistory.status = new ESS_Global.EnumValue('RetirementApprovalStatus');
            ApprovalHistory.status.key = ESS_Enum.RetirementApprovalStatus.Rejected.name();
            ApprovalHistory.status.value = 'Rejected';
            ApprovalHistory.comment = rejectComment;
            
            histories.add(ApprovalHistory);     
            
            Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit);
            
            //Send email to employee when section head rejected
            ESS_NotiAndEmailController.RetirementSendToEmployeeWhenSectionHeadRejected(Retirement, rejectComment);
        }
        else if(status == ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()) {
            
            if(currentStatus != ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This retirement status has been changed and cannot be reject.');
            }
            
            //Update History JSON
            ESS_Retirement_DTO.ApprovalHistoryDTO ApprovalHistory = new ESS_Retirement_DTO.ApprovalHistoryDTO();
            ApprovalHistory.name = PISUser.EMPLOYEEID__c + ' - ' + PISUser.EN_Fullname__c;
            ApprovalHistory.approverRole = new ESS_Global.EnumValue('ApproverRole');
            ApprovalHistory.approverRole.key = ESS_Enum.ApproverRole.DepartmentHead.name();
            ApprovalHistory.approverRole.value = 'DepartmentHead';
            ApprovalHistory.position = PISUser.OBJENFULLNAME__c;
            ApprovalHistory.submittedDate = date.today();
            ApprovalHistory.status = new ESS_Global.EnumValue('RetirementApprovalStatus');
            ApprovalHistory.status.key = ESS_Enum.RetirementApprovalStatus.Rejected.name();
            ApprovalHistory.status.value = 'Rejected';
            ApprovalHistory.comment = rejectComment;
            
            histories.add(ApprovalHistory);  
            if(string.isNotEmpty(Retirement.Section_Head_Id__c)) {
                Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead);
            }
            else {
                Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit);
            }
                       
            //Send email to employee when deparment head rejected
            ESS_NotiAndEmailController.RetirementSendToSectionHeadWhenDepartmentHeadRejected(Retirement, rejectComment);      
        }
        
        //Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementApprovalStatus.Rejected);
        Retirement.Reject_Date__c = date.today();
        Retirement.Comment__c = rejectComment;
        
        Retirement.History_JSON__c = JSON.serialize(histories);
        
        update(Retirement);
    }
    
    @RemoteAction
    public static void ApproveRetirement(string retirementId, string status) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        PISUsers__c PISUser = ESS_Global.assignToPISUser(userId);
        
        string currentStatus = RetirementCurrentStatus(retirementId);
        
        string query = 'select id, ownerId, document_no__c, employee_name__c, employee_id__c, submitted_date__c, createddate, status__c, history_json__c, section_head__c, section_head_id__c, Section_Head_Approve_Date__c, department_head__c, department_head_id__c from ESS_Retirement__c where Id =: retirementId';
        
        ESS_Retirement__c Retirement = Database.query(query);
        
        if(status == ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name()) {
                
            if(currentStatus != ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name()) {
                throw new ESS_Exception('[MyError]This retirement status has been changed and cannot be approve.');
            }
            
            Retirement.Section_Head_Approve_Date__c = date.today();
        	Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead);
            Retirement.Section_Head_Reminder__c = null;
        
            //Set reminder for Department Head
            boolean isBeforeAugust = false;
            date firstReminder = date.today().addDays(7);
            date julyDate = date.newInstance(date.today().year(), 7, 31);
            date augustDate = date.newInstance(date.today().year(), 8, 15);
            
            if(firstReminder <= julyDate) {
                isBeforeAugust = true;
            }
            
            integer diffDate = 0;
            integer noOfReminder = 0;
            if(isBeforeAugust) {
                diffDate = firstReminder.daysBetween(julyDate);
                noOfReminder = diffDate / 7;
            }
            else {
                diffDate = firstReminder.daysBetween(augustDate);
                noOfReminder = diffDate / 3;
            }
            
            List<string> otherReminders = new List<string>();
            if(isBeforeAugust) {
                for(integer i=0; i<noOfReminder; i++) {
                    firstReminder = firstReminder.addDays(7);
                    string reminder = string.valueOf(firstReminder);
                    otherReminders.add(reminder);
                }
            }
            else {
                for(integer i=0; i<noOfReminder; i++) {
                    firstReminder = firstReminder.addDays(3);
                    string reminder = string.valueOf(firstReminder);
                    otherReminders.add(reminder);
                }
            }
            
            if(otherReminders.size() > 0) {
                Retirement.Department_Head_Reminder__c = JSON.serialize(otherReminders);
            }
            
            List<ESS_Retirement_DTO.ApprovalHistoryDTO> histories = new List<ESS_Retirement_DTO.ApprovalHistoryDTO>();
            
            if(string.isNotEmpty(Retirement.History_JSON__c)) {
            	histories = DeserializeHistoryWorkflows(Retirement.History_JSON__c);
            }
    
            //Update History JSON
            ESS_Retirement_DTO.ApprovalHistoryDTO ApprovalHistory = new ESS_Retirement_DTO.ApprovalHistoryDTO();
            ApprovalHistory.name = PISUser.EMPLOYEEID__c + ' - ' + PISUser.EN_Fullname__c;
            ApprovalHistory.approverRole = new ESS_Global.EnumValue('ApproverRole');
            ApprovalHistory.approverRole.key = ESS_Enum.ApproverRole.SectionHead.name();
            ApprovalHistory.approverRole.value = 'Section Head';
            ApprovalHistory.position = PISUser.OBJENFULLNAME__c;
            ApprovalHistory.submittedDate = date.today();
            ApprovalHistory.status = new ESS_Global.EnumValue('RetirementApprovalStatus');
            ApprovalHistory.status.key = ESS_Enum.RetirementApprovalStatus.Approved.name();
            ApprovalHistory.status.value = 'Approved';
            ApprovalHistory.comment = '';
            
            histories.add(ApprovalHistory);
            
            Retirement.History_JSON__c = JSON.serialize(histories);
            
            //Send email noti to Employee
            ESS_NotiAndEmailController.RetirementSendToEmployeeWhenSectionHeadApproved(Retirement);
            
            //Send email noti Department Head
            ESS_NotiAndEmailController.RetirementSendToDepartmentHead(Retirement);
        }
        else if(status == ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()) {
            
            if(currentStatus != ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()) {
                throw new ESS_Exception('[MyError]This retirement status has been changed and cannot be approve.');
            }
            
            Retirement.Department_Head_Approve_Date__c = date.today();
        	Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.UploadingToPersonalFolder);
        	Retirement.Department_Head_Reminder__c = null;
            
            List<ESS_Retirement_DTO.ApprovalHistoryDTO> histories = new List<ESS_Retirement_DTO.ApprovalHistoryDTO>();
            if(string.isNotEmpty(Retirement.History_JSON__c)) {
            	histories = DeserializeHistoryWorkflows(Retirement.History_JSON__c);
            }
    
            //Update History JSON
            ESS_Retirement_DTO.ApprovalHistoryDTO ApprovalHistory = new ESS_Retirement_DTO.ApprovalHistoryDTO();
            ApprovalHistory.name = PISUser.EMPLOYEEID__c + ' - ' + PISUser.EN_Fullname__c;
            ApprovalHistory.approverRole = new ESS_Global.EnumValue('ApproverRole');
            ApprovalHistory.approverRole.key = ESS_Enum.ApproverRole.DepartmentHead.name();
            ApprovalHistory.approverRole.value = 'Department Head';
            ApprovalHistory.position = PISUser.OBJENFULLNAME__c;
            ApprovalHistory.submittedDate = date.today();
            ApprovalHistory.status = new ESS_Global.EnumValue('RetirementApprovalStatus');
            ApprovalHistory.status.key = ESS_Enum.RetirementApprovalStatus.Approved.name();
            ApprovalHistory.status.value = 'Approved';
            ApprovalHistory.comment = '';
            
            histories.add(ApprovalHistory);
            
            Retirement.History_JSON__c = JSON.serialize(histories);
            
            //Send email to admin and cc employee and section head when department head approved
            ESS_NotiAndEmailController.RetirementSendToPersonelAdminWhenDepartmentHeadApproved(Retirement);  
        }
        else if(status == ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name()) {
            
        }
        
        update(Retirement);
    }

    @RemoteAction
    public static ESS_Retirement_DTO.RetirementDetailDTO SaveRetirement(ESS_Retirement_DTO.RetirementDetailDTO retirement) {
        
        ESS_Retirement__c SaveRetirement = new ESS_Retirement__c();
        SaveRetirement.Document_No__c = retirement.documentNo;
        SaveRetirement.Employee_Name_TH__c = retirement.employeeNameTH;
        SaveRetirement.Employee_Title__c = retirement.employeeTitle;
        SaveRetirement.Employee_Name__c = retirement.employeeNameEN;
        SaveRetirement.Employee_ID__c = retirement.employeeId;
        SaveRetirement.Date_of_Birth__c = retirement.birthDate;
        SaveRetirement.Age__c = retirement.age;
        SaveRetirement.Status__c = String.ValueOf(retirement.currentStatus.key);
        SaveRetirement.Retirement_Choice__c = String.ValueOf(retirement.retirementChoice.key);
        SaveRetirement.Section_Head_Id__c = retirement.sectionHeadId;
        SaveRetirement.Section_Head__c = retirement.sectionHead;
        SaveRetirement.Department_Head_Id__c = retirement.departmentHeadId;
        SaveRetirement.Department_Head__c = retirement.departmentHead;
        SaveRetirement.Default_Retirement_Date__c = retirement.defaultRetirementDate;
        
        if(SaveRetirement.Retirement_Choice__c == ESS_Enum.RetirementChoice.ExactDateFor55Years.name()) {
            SaveRetirement.Retirement_Date__c = SaveRetirement.Date_of_Birth__c.addYears(55);
        }
        else if(SaveRetirement.Retirement_Choice__c == ESS_Enum.RetirementChoice.ExactDateFor60Years.name()) {
            SaveRetirement.Retirement_Date__c = SaveRetirement.Date_of_Birth__c.addYears(60);
        }
        else if(SaveRetirement.Retirement_Choice__c == ESS_Enum.RetirementChoice.EndOfMonth.name()) {
            date endOfMonth = SaveRetirement.Date_of_Birth__c;
            integer nextMonth = endOfMonth.addMonths(1).month();
            integer nextYear = date.today().addYears(1).year();
			Date lastDayOfMonth = Date.newInstance(nextYear, nextMonth, 1);
            SaveRetirement.Retirement_Date__c = lastDayOfMonth;
        }
        else if(SaveRetirement.Retirement_Choice__c == ESS_Enum.RetirementChoice.EndOfYear.name()) {
            date endOfYear = SaveRetirement.Date_of_Birth__c;
            integer nextYear = date.today().addYears(2).Year();
			Date lastDayOfYear = Date.newInstance(nextYear, 1, 1);
            SaveRetirement.Retirement_Date__c = lastDayOfYear;
        }
        
        SaveRetirement.History_JSON__c = JSON.serialize(retirement.approvalHistories);
        
        insert(SaveRetirement);
        
        return retirementDetail;
    }
    
    @RemoteAction
    public static void MassSaveRetirement(List<ESS_Retirement_DTO.RetirementListDTO> retirements) {
        
        List<ESS_Retirement__c> newRetirements = new List<ESS_Retirement__c>();
        
        string data = 'IN';
        List<ESS_Master_Employee__c> Masters = [select id, employee_id__c, Retirement_Section_Head_Id__c, Retirement_Section_Head_Name__c, Retirement_VP_Id__c, Retirement_VP_Name__c from ESS_Master_Employee__c where data__c =: data];
        
        List<ESS_Master_Employee__c> updateMasters = new List<ESS_Master_Employee__c>();
        
        if(retirements.size() > 0) {
            
            for(ESS_Retirement_DTO.RetirementListDTO retirement : retirements) {
                
                for(ESS_Master_Employee__c Master : Masters) {
                    if(retirement.employeeId == Master.Employee_id__c) {
                        Master.Retirement_Section_Head_Id__c = retirement.sectionHead;
                        Master.Retirement_Section_Head_Name__c = retirement.sectionHeadName;
                        Master.Retirement_Section_Head_TH__c = retirement.sectionHeadTH;
                        Master.Retirement_Section_Head_Position__c = retirement.sectionHeadPosition;
                        Master.Retirement_Section_Head_Position_TH__c = retirement.sectionHeadPositionTH;
                        if(string.isEmpty(Master.Retirement_Section_Head_Id__c)) {
                            Master.Retirement_Section_Head_Skip__c = true;
                        }
                        else {
                            Master.Retirement_Section_Head_Skip__c = false;
                        }
                        Master.Retirement_VP_Id__c = retirement.departmentHead;
                        Master.Retirement_VP_Name__c = retirement.departmentHeadName;
                        Master.Retirement_VP_TH__c = retirement.departmentHeadTH;
                        Master.Retirement_VP_Position__c = retirement.departmentHeadPosition;
                        Master.Retirement_VP_Position_TH__c = retirement.departmentHeadPositionTH;
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
    public static void MassSubmitRetirement(List<ESS_Retirement_DTO.RetirementListDTO> retirements) {
        
        List<ESS_Retirement__c> newRetirements = new List<ESS_Retirement__c>();
        
        if(retirements.size() > 0) {
            for(ESS_Retirement_DTO.RetirementListDTO retirement : retirements) {
                
                if(string.isempty(retirement.departmentHead)) {
                    throw new ESS_Exception(
                    		'[MyError]กรุณากรอกข้อมูล Department Head สำหรับ พนักงาน (' + retirement.employeeId + ' : ' + retirement.employeeNameTH + ')');   
                }
                
                List<ESS_Retirement__c> existRetirements = RetirementExisted(retirement.employeeId);
                if(existRetirements.size() > 0) {
                    throw new ESS_Exception('[MyError]Retirement for ' + retirement.employeeId + ' : ' + retirement.employeeName + ' has been submitted.');
                }
                
                ESS_Retirement__c newRetirement = new ESS_Retirement__c();
                
                ESS_Master_Employee__c MasterEmployee = ESS_Global.getMasterEmployee(retirement.employeeId);
                
                retirementDetail = new ESS_Retirement_DTO.RetirementDetailDTO();
                
                string runningNo = ESS_LogicHandler.GenerateRunningNo('Retirement');
                string year = ESS_LogicHandler.GetCurrentYear();
                string month = ESS_LogicHandler.GetCurrentMonth();
                
                newRetirement.Document_No__c = 'RDC-' + year + '-' + month + '-' + runningNo;
                newRetirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit);
                newRetirement.Employee_ID__c = retirement.employeeId;
                newRetirement.Employee_Title__c = retirement.employeeTitle;
                newRetirement.Employee_Name_TH__c = retirement.employeeNameTH;
                newRetirement.Employee_Name__c = retirement.employeeName;
                newRetirement.Date_of_Birth__c = MasterEmployee.Employee_DOB__c;
                newRetirement.Age__c = retirement.age;
                newRetirement.Position__c = retirement.position;
                newRetirement.Function__c = retirement.function;
                newRetirement.Department__c = retirement.department;
                newRetirement.Section__c = retirement.section;
                newRetirement.Level__c = retirement.level;
                newRetirement.OwnerId = retirement.userId;
                newRetirement.First_Reminder__c = date.today().addDays(30);
                
                //Find out other reminder
                date firstReminder = date.today().addDays(30);
                date endDate = date.newInstance(date.today().year(), 7, 31);
                integer diffDate = firstReminder.daysBetween(endDate);
                integer noOfReminder = diffDate / 5;
                
                List<string> otherReminders = new List<string>();
                for(integer i=0; i<noOfReminder; i++) {
                    firstReminder = firstReminder.addDays(5);
                    string reminder = string.valueOf(firstReminder);
                    otherReminders.add(reminder);
                }
                if(otherReminders.size() > 0) {
                    newRetirement.Other_Reminder__c = JSON.serialize(otherReminders);
                }
                
                if(string.isNotEmpty(retirement.sectionHead)) {
                    newRetirement.Section_Head__c = retirement.sectionHeadName;
                    newRetirement.Section_Head_TH__c = retirement.sectionHeadTH;
                	newRetirement.Section_Head_Id__c = retirement.sectionHead;
                    newRetirement.Section_Head_Position__c = retirement.sectionHeadPosition;
                    newRetirement.Section_Head_Employee_Id__c = retirement.sectionHeadEmployeeId;
                    newRetirement.Section_Head_Position_TH__c = retirement.sectionHeadPositionTH;
                }
                
				if(string.isNotEmpty(retirement.departmentHead)) {       
                    newRetirement.Department_Head__c = retirement.departmentHeadName;
                    newRetirement.Department_Head_TH__c = retirement.departmentHeadTH;
                    newRetirement.Department_Head_Id__c = retirement.departmentHead;
                    newRetirement.Department_Head_Position__c = retirement.departmentHeadPosition;
                    newRetirement.Department_Head_Employee_Id__c = retirement.departmentHeadEmployeeId;
                    newRetirement.Department_Head_Position_TH__c = retirement.departmentHeadPositionTH;
                }
                
                newRetirement.Default_Retirement_Date__c = MasterEmployee.Employee_Retirement_Date__c;
                
                newRetirements.add(newRetirement);
                    
            }
            
            if(newRetirements.size() > 0) {
                insert(newRetirements);
                
                for(ESS_Retirement__c Retirement : newRetirements) {
                    //Send email noti
                    ESS_NotiAndEmailController.RetirementSendToEmployeeWhenCreate(Retirement);
                }
            }
        }
        
    }
    
    @RemoteAction
    public static List<ESS_Retirement_DTO.ApprovalHistoryDTO> GetApprovalHistory(string retirementId) {
        
        try {
            
            List<ESS_Retirement_DTO.ApprovalHistoryDTO> ApprovalHistoriesDTO = new List<ESS_Retirement_DTO.ApprovalHistoryDTO>();
            
            ESS_Retirement__c Retirement = [select id, History_JSON__c from ESS_Retirement__c where Id =: retirementId];
            
            if(Retirement != null) {
                ApprovalHistoriesDTO = DeserializeHistoryWorkflows(Retirement.History_JSON__c);
                return ApprovalHistoriesDTO;
            }
        }
        catch(Exception e) {
            System.debug('GetApprovalHisroty exception has occurred: ' + e.getMessage());
        }
        
        return null;
    }
    
    @RemoteAction
    public static string ExportExcel() {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_Retirement_Excel?';
        
        return URL;
        
    }
    
    @RemoteAction
    public static List<ESS_Retirement_DTO.SearchUserDTO> SearchUsers(string search, string employeeId) {
        
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
        string queryPIS = 'select id, user__c, employeeid__c, thtitle__c, thfirstname__c, thlastname__c, active__c, mainposition__c, EN_Fullname__c, OBJENFULLNAME__c, OBJTHFULLNAME__c, TH_Fullname__c from PISUsers__c';
        queryPIS = queryPIS + ' where (employeeid__c NOT IN :employeeIds AND user__c NOT IN :employeeIds) AND (employeeid__c like: searchName OR enfirstname__c like: searchName) AND active__c = true AND mainposition__c = true limit 100';
        PISUsers = database.query(queryPIS);
        
        List<ESS_Retirement_DTO.SearchUserDTO> SearchUsers = new List<ESS_Retirement_DTO.SearchUserDTO>();
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                ESS_Retirement_DTO.SearchUserDTO SearchUser = new ESS_Retirement_DTO.SearchUserDTO();
                SearchUser.userId = PISUser.User__c;
                SearchUser.employeeName = PISUser.EMPLOYEEID__c + ' - ' + PISuser.EN_Fullname__c;
                SearchUser.employeeNameTH = PISUser.TH_Fullname__c;
                SearchUser.position = PISUser.OBJENFULLNAME__c;
                SearchUser.positionTH = PISUser.OBJTHFULLNAME__c;
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
    public static void ESSService_PersonelFolder(string recordId, string fileId, string employeeId) {
        //Call Personel Folder Service
        ESS_Service.FileUploadPersonelFolder(recordId, fileId, employeeId, '2');
    }
    
    //Assign to DTO section
    private static ESS_Retirement_DTO.RetirementListDTO assignToRetirementListDTO(ESS_Master_Employee__c Employee, Map<string, PISUsers__c> mapPOSIDPISUsers, Map<string, PISUsers__c> mapPISUsers, List<ESS_Retirement__c> Retirements) {
    
        string employeeId = '';
        string employeeName = '';
        string employeeTitle = '';
        string employeeNameTH = '';
        string function = '';
        string department = '';
        string section = '';
        string position = '';
        string level = '';
        string sectionHead = '';
        string departmentHead = '';
        string userId = '';
        string sectionHeadName = '';
        string sectionHeadNameTH = '';
        string departmentHeadName = '';
        string departmentHeadNameTH = '';
        string sectionHeadPosition = '';
        string departmentHeadPosition = '';
        
    	ESS_Retirement_DTO.RetirementListDTO RetirementList = new ESS_Retirement_DTO.RetirementListDTO();
        boolean isMap = false;
        
        if(mapPISUsers.size() > 0) {
            
            PISUsers__c PISUser = mapPISUsers.get(Employee.Employee_ID__c);
            
            if(PISUser != null) {
                userId = PISUser.User__c;
                employeeId = PISUser.EMPLOYEEID__c;
                employeeName = PISUser.EN_Fullname__c;
                employeeTitle = PISUser.THTITLE__c;
                employeeNameTH = PISUser.TH_Fullname__c;
                function = PISUser.FUNCTION__c;
                department = PISUser.DEPARTMENT__c;
                section = PISUser.SECTIONS__c;
                position = PISUser.OBJENFULLNAME__c;
                level = PISUser.LEVEL__c;
                
                ESS_Retirement_DTO.RetirementApproverDTO RetirementApprover = new ESS_Retirement_DTO.RetirementApproverDTO();
                RetirementApprover = ESS_Global.GetSectionHeadDepartmentHead(PISUser, mapPOSIDPISUsers);
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Id__c)) {
                    sectionHead = Employee.Retirement_Section_Head_Id__c;
                }
                else {
                    sectionHead = RetirementApprover.sectionHeadId;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Name__c)) {
                    sectionHeadName = Employee.Retirement_Section_Head_Name__c;
                }
                else {
                    sectionHeadName = RetirementApprover.sectionHeadName;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_TH__c)) {
                    sectionHeadNameTH = Employee.Retirement_Section_Head_TH__c;
                }
                else {
                    sectionHeadNameTH = RetirementApprover.sectionHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Position__c)) {
                    sectionHeadPosition = Employee.Retirement_Section_Head_Position__c;
                }
                else {
                    sectionHeadPosition = RetirementApprover.sectionHeadPosition;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Id__c)) {
                    departmentHead = Employee.Retirement_VP_Id__c;
                }
                else {
                    departmentHead = RetirementApprover.departmentHeadId;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Name__c)) {
                    departmentHeadName = Employee.Retirement_VP_Name__c;
                }
                else {
                    departmentHeadName = RetirementApprover.departmentHeadName;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_TH__c)) {
                    departmentHeadNameTH = Employee.Retirement_VP_TH__c;
                }
                else {
                    departmentHeadNameTH = RetirementApprover.departmentHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Position__c)) {
                    departmentHeadPosition = Employee.Retirement_VP_Position__c;
                }
                else {
                    departmentHeadPosition = RetirementApprover.departmentHeadPosition;
                }
                
                isMap = true;
                
                //break;
            }
        }
        
        RetirementList.userId = userId;
        RetirementList.employeeId = employeeId;
        RetirementList.employeeName = employeeName;
        RetirementList.employeeTitle = employeeTitle;
        RetirementList.employeeNameTH = employeeNameTH;
        RetirementList.birthDate = Employee.Employee_DOB__c;
        
        RetirementList.age = '';
        
        if(Employee.Employee_DOB__c != null) {
            RetirementList.age = findAge(Date.ValueOf(Employee.Employee_DOB__c), date.today());
        }
        
        RetirementList.function = function;
        RetirementList.department = department;
        RetirementList.section = section;
        RetirementList.position = position;
        RetirementList.level = level;
        RetirementList.sectionHead = sectionHead;
        RetirementList.sectionHeadTH = sectionHeadNameTH;
        RetirementList.sectionHeadName = sectionHeadName;
        RetirementList.sectionHeadPosition = sectionHeadPosition;
        if(Employee.Retirement_Section_Head_Skip__c) {
            RetirementList.sectionHead = '';
            RetirementList.sectionHeadTH = '';
            RetirementList.sectionHeadName = '';
            RetirementList.sectionHeadPosition = '';
        }
        RetirementList.departmentHead = departmentHead;
        RetirementList.departmentHeadTH = departmentHeadNameTH;
        RetirementList.departmentHeadname = departmentHeadName;
        RetirementList.departmentHeadPosition = departmentHeadPosition;
        
        if(!isMap) {
            //RetirementList.employeeId = Employee.Employee_ID__c;
        }
        
        RetirementList.isDisable = false;
        //Check isDisable
        if(Retirements.size() > 0) {
            for(ESS_Retirement__c Retirement : Retirements) {
                if(Retirement.Employee_ID__c == employeeId) {
                    RetirementList.isDisable = true;
                    break;
                }
            }
        }
        
        return RetirementList;
    
    }
    
    private static RetirementListSortDTO assignToRetirementListSortDTO(ESS_Master_Employee__c Employee, Map<string, PISUsers__c> mapPOSIDPISUsers, Map<string, PISUsers__c> mapPISUsers, List<ESS_Retirement__c> Retirements) {
    
        string employeeId = '';
        string employeeName = '';
        string employeeTitle = '';
        string employeeNameTH = '';
        string function = '';
        string department = '';
        string section = '';
        string position = '';
        string level = '';
        string sectionHead = '';
        string departmentHead = '';
        string userId = '';
        string sectionHeadName = '';
        string sectionHeadNameTH = '';
        string departmentHeadName = '';
        string departmentHeadNameTH = '';
        string sectionHeadPosition = '';
        string departmentHeadPosition = '';
        string sectionHeadPositionTH = '';
        string departmentHeadPositionTH = '';
        
    	RetirementListSortDTO RetirementList = new RetirementListSortDTO();
        boolean isMap = false;
        
        if(mapPISUsers.size() > 0) {
            
            PISUsers__c PISUser = mapPISUsers.get(Employee.Employee_ID__c);
            
            if(PISUser != null) {
                userId = PISUser.User__c;
                employeeId = PISUser.EMPLOYEEID__c;
                employeeName = PISUser.EN_Fullname__c;
                employeeTitle = PISUser.THTITLE__c;
                employeeNameTH = PISUser.TH_Fullname__c;
                function = PISUser.FUNCTION__c;
                department = PISUser.DEPARTMENT__c;
                section = PISUser.SECTIONS__c;
                position = PISUser.OBJENFULLNAME__c;
                level = PISUser.LEVEL__c;
                
                ESS_Retirement_DTO.RetirementApproverDTO RetirementApprover = new ESS_Retirement_DTO.RetirementApproverDTO();
                RetirementApprover = ESS_Global.GetSectionHeadDepartmentHead(PISUser, mapPOSIDPISUsers);
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Id__c)) {
                    sectionHead = Employee.Retirement_Section_Head_Id__c;
                }
                else {
                    sectionHead = RetirementApprover.sectionHeadId;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Name__c)) {
                    sectionHeadName = Employee.Retirement_Section_Head_Name__c;
                }
                else {
                    sectionHeadName = RetirementApprover.sectionHeadName;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_TH__c)) {
                    sectionHeadNameTH = Employee.Retirement_Section_Head_TH__c;
                }
                else {
                    sectionHeadNameTH = RetirementApprover.sectionHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Position__c)) {
                    sectionHeadPosition = Employee.Retirement_Section_Head_Position__c;
                }
                else {
                    sectionHeadPosition = RetirementApprover.sectionHeadPosition;
                }
                
                if(string.isNotEmpty(Employee.Retirement_Section_Head_Position_TH__c)) {
                    sectionHeadPositionTH = Employee.Retirement_Section_Head_Position_TH__c;
                }
                else {
                    sectionHeadPositionTH = RetirementApprover.sectionHeadPositionTH;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Id__c)) {
                    departmentHead = Employee.Retirement_VP_Id__c;
                }
                else {
                    departmentHead = RetirementApprover.departmentHeadId;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Name__c)) {
                    departmentHeadName = Employee.Retirement_VP_Name__c;
                }
                else {
                    departmentHeadName = RetirementApprover.departmentHeadName;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_TH__c)) {
                    departmentHeadNameTH = Employee.Retirement_VP_TH__c;
                }
                else {
                    departmentHeadNameTH = RetirementApprover.departmentHeadNameTH;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Position__c)) {
                    departmentHeadPosition = Employee.Retirement_VP_Position__c;
                }
                else {
                    departmentHeadPosition = RetirementApprover.departmentHeadPosition;
                }
                
                if(string.isNotEmpty(Employee.Retirement_VP_Position_TH__c)) {
                    departmentHeadPositionTH = Employee.Retirement_VP_Position_TH__c;
                }
                else {
                    departmentHeadPositionTH = RetirementApprover.departmentHeadPositionTH;
                }
                
                isMap = true;
                
                //break;
            }
        }
        
        RetirementList.userId = userId;
        RetirementList.employeeId = employeeId;
        RetirementList.employeeName = employeeName;
        RetirementList.employeeTitle = employeeTitle;
        RetirementList.employeeNameTH = employeeNameTH;
        RetirementList.birthDate = Employee.Employee_DOB__c;
        
        RetirementList.age = '';
        
        if(Employee.Employee_DOB__c != null) {
            RetirementList.age = findAge(Date.ValueOf(Employee.Employee_DOB__c), date.today());
        }
        
        RetirementList.function = function;
        RetirementList.department = department;
        RetirementList.section = section;
        RetirementList.position = position;
        RetirementList.level = level;
        RetirementList.sectionHead = sectionHead;
        RetirementList.sectionHeadTH = sectionHeadNameTH;
        RetirementList.sectionHeadName = sectionHeadName;
        RetirementList.sectionHeadPosition = sectionHeadPosition;
        RetirementList.sectionHeadPositionTH = sectionHeadPositionTH;
        if(Employee.Retirement_Section_Head_Skip__c) {
            RetirementList.sectionHead = '';
            RetirementList.sectionHeadTH = '';
            RetirementList.sectionHeadName = '';
            RetirementList.sectionHeadPosition = '';
            RetirementList.sectionHeadPositionTH = '';
        }
        RetirementList.departmentHead = departmentHead;
        RetirementList.departmentHeadTH = departmentHeadNameTH;
        RetirementList.departmentHeadname = departmentHeadName;
        RetirementList.departmentHeadPosition = departmentHeadPosition;
        RetirementList.departmentHeadPositionTH = departmentHeadPositionTH;
        
        if(!isMap) {
            //RetirementList.employeeId = Employee.Employee_ID__c;
        }
        
        RetirementList.isDisable = false;
        //Check isDisable
        if(Retirements.size() > 0) {
            for(ESS_Retirement__c Retirement : Retirements) {
                if(Retirement.Employee_ID__c == employeeId) {
                    RetirementList.isDisable = true;
                    break;
                }
            }
        }
        
        return RetirementList;
    
    }
    
    public static ESS_Retirement_DTO.RetirementListDTO convertToRetirementListDTO(RetirementListSortDTO Retirement) {
    
        ESS_Retirement_DTO.RetirementListDTO result = new ESS_Retirement_DTO.RetirementListDTO();
        result.retirementId = Retirement.retirementId;
        result.isDisable = Retirement.isDisable;
        result.userId = Retirement.userId;
        result.employeeId = Retirement.employeeId;
        result.employeeName = Retirement.employeeName;
        result.employeeTitle = Retirement.employeeTitle;
        result.employeeNameTH = Retirement.employeeNameTH;
        result.birthDate = Retirement.birthDate;
        result.age = Retirement.age;
        result.function = Retirement.function;
        result.department = Retirement.department;
        result.section = Retirement.section;
        result.position = Retirement.position;
        result.level = Retirement.level;
        result.isDisableSectionHead = true;
        if(Retirement.level == 'Junior' || Retirement.level == 'Senior' || Retirement.level == 'Supervisor') {
            result.isDisableSectionHead = false;
        }
        result.sectionHeadEmployeeId = Retirement.sectionHeadEmployeeId;
        result.sectionHead = Retirement.sectionHead;
        result.sectionHeadTH = Retirement.sectionHeadTH;
        result.sectionHeadName = Retirement.sectionHeadName;
        result.sectionHeadPosition = Retirement.sectionHeadPosition;
        result.sectionHeadPositionTH = Retirement.sectionHeadPositionTH;
        result.departmentHeadEmployeeId = Retirement.departmentHeadEmployeeId;
        result.departmentHead = Retirement.departmentHead;
        result.departmentHeadTH = Retirement.departmentHeadTH;
        result.departmentHeadName = Retirement.departmentHeadName;
        result.departmentHeadPosition = Retirement.departmentHeadPosition;
        result.departmentHeadPositionTH = Retirement.departmentHeadPositionTH;
        
        return result;
    }
    
    
    private static List<ESS_Retirement__c> allRetirements() {
        List<ESS_Retirement__c> Retirements = [select id, employee_id__c from ESS_Retirement__c];
        return Retirements;
    }
    
    @TestVisible
    private static ESS_Retirement_DTO.RetirementApproveListDTO assignToRetirementApproveListDTO(ESS_Retirement__c Retirement) {
    
    	ESS_Retirement_DTO.RetirementApproveListDTO RetirementList = new ESS_Retirement_DTO.RetirementApproveListDTO();
        RetirementList.retirementId = Retirement.Id;
        RetirementList.employeeId = Retirement.Employee_Id__c;
        RetirementList.employeeName = Retirement.Employee_Name__c;
        RetirementList.documentNo = Retirement.Document_No__c;
        
        RetirementList.retirementChoice = new ESS_Global.EnumValue('RetirementChoice');
        if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.ExactDateFor60Years)) {
            RetirementList.retirementChoice.key = ESS_Enum.RetirementChoice.ExactDateFor60Years.name();
        	RetirementList.retirementChoice.value = 'ในวันครบอายุ 60 ปีบริบูรณ์';
        }
        else if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.ExactDateFor55Years)) {
            RetirementList.retirementChoice.key = ESS_Enum.RetirementChoice.ExactDateFor55Years.name();
        	RetirementList.retirementChoice.value = 'ในวันครบอายุ 55 ปีบริบูรณ์';
        }
		else if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.EndOfMonth)) {
            RetirementList.retirementChoice.key = ESS_Enum.RetirementChoice.EndOfMonth.name();
        	RetirementList.retirementChoice.value = 'ในวันสุดท้ายของเดือนที่ครบอายุเกษียณ';
        }
		else if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.EndOfYear)) {
            RetirementList.retirementChoice.key = ESS_Enum.RetirementChoice.EndOfYear.name();
        	RetirementList.retirementChoice.value = 'ในวันสิ้นปีที่ครบอายุเกษียณ';
        }
        else {
            RetirementList.retirementChoice.value = '-';
        }
        
        RetirementList.retirementDate = Retirement.Retirement_Date__c;    
        
        RetirementList.status = new ESS_Global.EnumValue('RetirementStatus');
        if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit)) {
            RetirementList.status.key = ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name();
        	RetirementList.status.value = 'Waiting Employee Submit';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead)) {
            RetirementList.status.key = ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name();
        	RetirementList.status.value = 'Waiting for Approval Immediate Line/Section Head';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead)) {
            RetirementList.status.key = ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name();
        	RetirementList.status.value = 'Waiting for Approval Department Head';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.UploadingToPersonalFolder)) {
            RetirementList.status.key = ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name();
        	RetirementList.status.value = 'Uploading to Personal Folder';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.SendingToSAP)) {
            RetirementList.status.key = ESS_Enum.RetirementStatus.SendingToSAP.name();
        	RetirementList.status.value = 'Sending to SAP';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.Completed)) {
            RetirementList.status.key = ESS_Enum.RetirementStatus.Completed.name();
        	RetirementList.status.value = 'Completed';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.DefaultFromSystem)) {
            RetirementList.status.key = ESS_Enum.RetirementStatus.DefaultFromSystem.name();
        	RetirementList.status.value = 'Default From System';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.UploadFailed)) {
            RetirementList.status.key = ESS_Enum.RetirementStatus.UploadFailed.name();
        	RetirementList.status.value = 'Upload Failed';
        }
        
        RetirementList.createdDate = Retirement.createddate.date();
        RetirementList.employeeSubmitDate = Retirement.submitted_date__c;

        return RetirementList;
    
    }
    
    @TestVisible
    private static ESS_Retirement_DTO.RetirementDetailDTO assignToRetirementDetail(ESS_Retirement__c Retirement) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        ESS_Retirement_DTO.RetirementDetailDTO RetirementDetail = new ESS_Retirement_DTO.RetirementDetailDTO();
        RetirementDetail.retirementId = Retirement.Id;
        RetirementDetail.documentNo = Retirement.Document_No__c;
        
        RetirementDetail.currentStatus = new ESS_Global.EnumValue('RetirementStatus');
        if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit)) {
            RetirementDetail.currentStatus.key = ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name();
        	RetirementDetail.currentStatus.value = 'Waiting Employee Submit';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead)) {
            RetirementDetail.currentStatus.key = ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name();
        	RetirementDetail.currentStatus.value = 'Waiting for Approval by Immediate Line/Section Head';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead)) {
            RetirementDetail.currentStatus.key = ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name();
        	RetirementDetail.currentStatus.value = 'Waiting for Approval by Department Head';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.UploadingToPersonalFolder)) {
            RetirementDetail.currentStatus.key = ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name();
        	RetirementDetail.currentStatus.value = 'Uploading To Personal Folder';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.SendingToSAP)) {
            RetirementDetail.currentStatus.key = ESS_Enum.RetirementStatus.SendingToSAP.name();
        	RetirementDetail.currentStatus.value = 'Sending To SAP';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.Completed)) {
            RetirementDetail.currentStatus.key = ESS_Enum.RetirementStatus.Completed.name();
        	RetirementDetail.currentStatus.value = 'Completed';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.DefaultFromSystem)) {
            RetirementDetail.currentStatus.key = ESS_Enum.RetirementStatus.DefaultFromSystem.name();
        	RetirementDetail.currentStatus.value = 'Default From System';
        }
        else if(Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.UploadFailed)) {
            RetirementDetail.currentStatus.key = ESS_Enum.RetirementStatus.UploadFailed.name();
        	RetirementDetail.currentStatus.value = 'Upload Failed';
        }
        
        RetirementDetail.retirementChoice = new ESS_Global.EnumValue('RetirementChoice');
        RetirementDetail.isSixtyYears = false;
        RetirementDetail.isSixtyYears = findRetirementChoice(Date.ValueOf(Retirement.Date_of_Birth__c), date.today());
        if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.ExactDateFor60Years)) {
            RetirementDetail.retirementChoice.key = ESS_Enum.RetirementChoice.ExactDateFor60Years.name();
        	RetirementDetail.retirementChoice.value = 'ในวันครบอายุ 60 ปีบริบูรณ์';
            RetirementDetail.isSixtyYears = true;
        }
        else if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.ExactDateFor55Years)) {
            RetirementDetail.retirementChoice.key = ESS_Enum.RetirementChoice.ExactDateFor55Years.name();
        	RetirementDetail.retirementChoice.value = 'ในวันครบอายุ 55 ปีบริบูรณ์';
        }
		else if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.EndOfMonth)) {
            RetirementDetail.retirementChoice.key = ESS_Enum.RetirementChoice.EndOfMonth.name();
        	RetirementDetail.retirementChoice.value = 'ในวันสุดท้ายของเดือนที่ครบอายุเกษียณ';
        }
		else if(Retirement.Retirement_Choice__c == String.ValueOf(ESS_Enum.RetirementChoice.EndOfYear)) {
            RetirementDetail.retirementChoice.key = ESS_Enum.RetirementChoice.EndOfYear.name();
        	RetirementDetail.retirementChoice.value = 'ในวันสิ้นปีที่ครบอายุเกษียณ';
        }
        /* else {
            RetirementDetail.isSixtyYears = findRetirementChoice(Date.ValueOf(Retirement.Date_of_Birth__c), date.today());
        } */
        
        RetirementDetail.employeeNameTH = Retirement.Employee_Name_TH__c;
        RetirementDetail.employeeTitle = Retirement.Employee_Title__c;
        RetirementDetail.employeeNameEN = Retirement.Employee_Name__c;
        RetirementDetail.employeeId = Retirement.Employee_ID__c;
        RetirementDetail.birthDate = Retirement.Date_of_Birth__c;
        RetirementDetail.age = Retirement.Age__c;
        RetirementDetail.submittedDate = Retirement.Submitted_Date__c;
        
        string sectionHeadName = '';
        if(string.isNotEmpty(Retirement.Section_Head__c)) {
            sectionHeadName = Retirement.Section_Head__c.substringAfter('- ');
        }
        RetirementDetail.sectionHead = sectionHeadName;
        RetirementDetail.sectionHeadTH = Retirement.Section_Head_TH__c;
        RetirementDetail.sectionHeadId = Retirement.Section_Head_Id__c;
        RetirementDetail.sectionHeadPositionTH = Retirement.Section_Head_Position_TH__c;
        RetirementDetail.sectionHeadApproveDate = Retirement.Section_Head_Approve_Date__c;
        
        string departmentHeadName = '';
        if(string.isNotEmpty(Retirement.Department_Head__c)) {
            departmentHeadName = Retirement.Department_Head__c.substringAfter('- ');
        }
        RetirementDetail.departmentHead = departmentHeadName;
        RetirementDetail.departmentHeadTH = Retirement.Department_Head_TH__c;
        RetirementDetail.departmentHeadId = Retirement.Department_Head_Id__c;
        RetirementDetail.departmentHeadPositionTH = Retirement.Department_Head_Position_TH__c;
        RetirementDetail.departmentHeadApproveDate = Retirement.Department_Head_Approve_Date__c;
        RetirementDetail.completedDate = Retirement.Completed_Date__c;
        RetirementDetail.createdDate = Date.ValueOf(Retirement.CreatedDate);
        RetirementDetail.retirementDate = Retirement.Retirement_Date__c;
        RetirementDetail.defaultRetirementDate = Retirement.Default_Retirement_Date__c;
        
        if(string.isNotEmpty(Retirement.History_JSON__c)) {
        	RetirementDetail.approvalHistories = DeserializeHistoryWorkflows(Retirement.History_JSON__c);
        }
        
        RetirementDetail.canApprove = false;
        RetirementDetail.canSubmit = false;
        RetirementDetail.canReject = false;
        RetirementDetail.canEdit = false;
        RetirementDetail.canDownload = false;
        RetirementDetail.canUploadPersonalFolder = false;
        
        RetirementDetail.canApprove = checkCanApprove(Retirement.Status__c);
        RetirementDetail.canSubmit = checkCanSubmit(Retirement.Status__c);
        RetirementDetail.canReject = checkCanReject(Retirement.Status__c);
        RetirementDetail.canEdit = checkCanEdit(Retirement.Status__c);
        RetirementDetail.canDownload = checkCanDownload(Retirement.Status__c);
        RetirementDetail.canUploadPersonalFolder = checkCanUploadPersonalFolder(Retirement.Status__c);
        
        if(Retirement.Section_Head_Flow__c) {
            //Owner of Retirement at Waiting Employee Submit status
            if(userId == Retirement.OwnerId && Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit)) {
            	RetirementDetail.canSubmit = true;
                RetirementDetail.canEdit = true;
                RetirementDetail.canApprove = false;
                RetirementDetail.canReject = false;
            }
            //Owner of Retirement at Rejected status
            else if(userId == Retirement.OwnerId && Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementApprovalStatus.Rejected)) {
            	RetirementDetail.canSubmit = true;
                RetirementDetail.canEdit = true;
                RetirementDetail.canApprove = false;
                RetirementDetail.canReject = false;
            }
            //Owner of Retirement at Waiting for Approval Department Head status and owner is not same as department head 
            else if(userId == Retirement.OwnerId && Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead) &&
                   Retirement.OwnerId != Retirement.Department_Head_Id__c) {
                RetirementDetail.canEdit = false;
                RetirementDetail.canSubmit = false;
                RetirementDetail.canApprove = false;
                RetirementDetail.canReject = false;
            }
            //Owner of Retirement at Waiting for Approval Department Head status and owner is same as department head (EVP)
            else if(userId == Retirement.OwnerId && Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead) &&
                   Retirement.OwnerId == Retirement.Department_Head_Id__c) {
                RetirementDetail.canEdit = false;
                RetirementDetail.canSubmit = false;
                RetirementDetail.canApprove = true;
                RetirementDetail.canReject = true;
            }
            else if(userId == Retirement.Department_Head_Id__c && Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead)) {
                RetirementDetail.canApprove = true;
                RetirementDetail.canReject = true;
                RetirementDetail.canSubmit = false;
                RetirementDetail.canEdit = false;
            }
            else {
                RetirementDetail.canApprove = false;
                RetirementDetail.canReject = false;
                RetirementDetail.canEdit = false;
                RetirementDetail.canSubmit = false;
            }
        }
        else {
            RetirementDetail.canApprove = false;
            RetirementDetail.canSubmit = false;
            RetirementDetail.canReject = false;
            RetirementDetail.canEdit = false;
            if(userId == Retirement.OwnerId && Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit)) {
                    RetirementDetail.canApprove = false;
                    RetirementDetail.canSubmit = true;
                    RetirementDetail.canReject = false;
                    RetirementDetail.canEdit = true;
            }
            else if(userId == Retirement.OwnerId && Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementApprovalStatus.Rejected)) {
                RetirementDetail.canApprove = false;
                RetirementDetail.canSubmit = true;
                RetirementDetail.canReject = false;
                RetirementDetail.canEdit = true;
            }
            else if(userId == Retirement.Section_Head_Id__c && Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead)) {
                RetirementDetail.canApprove = true;
                RetirementDetail.canReject = true;
                RetirementDetail.canEdit = false;
                RetirementDetail.canSubmit = false;
            }
            else if(userId == Retirement.Department_Head_Id__c && Retirement.Status__c == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead)) {
                RetirementDetail.canApprove = true;
                RetirementDetail.canReject = true;
                RetirementDetail.canEdit = false;
                RetirementDetail.canSubmit = false;
            }
            //Check when access as Section Head but no permission
            else if(userId == Retirement.section_head_id__c && Retirement.Status__c != ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name()) {
                RetirementDetail.canApprove = false;
                RetirementDetail.canSubmit = false;
                RetirementDetail.canReject = false;
                RetirementDetail.canEdit = false;
            }
            else if(userId == Retirement.section_head_id__c && Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name()) {
                RetirementDetail.canApprove = true;
                RetirementDetail.canSubmit = false;
                RetirementDetail.canReject = true;
                RetirementDetail.canEdit = false;
            }
            //Check when access as Department Head but no permission
            else if(userId == Retirement.department_head_id__c && Retirement.Status__c != ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()) {
                RetirementDetail.canApprove = false;
                RetirementDetail.canSubmit = false;
                RetirementDetail.canReject = false;
                RetirementDetail.canEdit = false;
            }
            else if(userId == Retirement.department_head_id__c && Retirement.Status__c == ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name()) {
                RetirementDetail.canApprove = true;
                RetirementDetail.canSubmit = false;
                RetirementDetail.canReject = true;
                RetirementDetail.canEdit = false;
            }
            
        }
        
        //Check Access Privilege
        if(userId != Retirement.OwnerId && userId != Retirement.Section_Head_Id__c &&
           userId != Retirement.Department_Head_Id__c) {
               
               boolean isRetirementAdmin = ESS_PrivilegeHandler.checkRetirementAdminUser(userId);
               boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
               
               if(!isRetirementAdmin && !isAdmin) {
                   RetirementDetail = null;
               }
        }
        
        return RetirementDetail;
        
    }
    
    private static List<ESS_Retirement_DTO.ApprovalHistoryDTO> DeserializeHistoryWorkflows(string historyJSON) {
        
        List<ESS_Retirement_DTO.ApprovalHistoryDTO> approvalHistoriesDTO = (List<ESS_Retirement_DTO.ApprovalHistoryDTO>)JSON.deserialize(historyJSON, List<ESS_Retirement_DTO.ApprovalHistoryDTO>.class);

        return approvalHistoriesDTO;
        
    }
    
    private static boolean checkCanApprove(string status) {
        boolean canApprove = false;
        if(status == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit) ||
          status == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead) ||
          status == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead)) {
            canApprove = true;
        }
        return canApprove;
    }
    
    private static boolean checkCanSubmit(string status) {
        boolean canSubmit = false;
        if(status == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit)) {
            canSubmit = true;
        }
        return canSubmit;
    }
    
    private static boolean checkCanReject(string status) {
        boolean canReject = false;
        if(status == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit) ||
          status == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead) ||
          status == String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead)) {
            canReject = true;
        }
        return canReject;
    }
    
    private static boolean checkCanEdit(string status) {
        boolean canEdit = false;
        if(status == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit) || 
          	status == String.ValueOf(ESS_Enum.RetirementApprovalStatus.Rejected)) {
            canEdit = true;
        }
        return canEdit;
    }
    
    private static boolean checkCanDownload(string status) {
        boolean canDownload = false;
        if(status == String.ValueOf(ESS_Enum.RetirementStatus.WaitingEmployeeSubmit)) {
            canDownload = true;
        }
        return canDownload;
    }
    
    private static boolean checkCanUploadPersonalFolder(string status) {
        boolean canUpload = false;
        if(status == String.ValueOf(ESS_Enum.RetirementStatus.UploadFailed)) {
            canUpload = true;
        }
        return canUpload;
    }
    
    private static string findAge(date birthDate, date todayDate) {
        
        string age = '';
        
        integer diffDay = birthDate.daysBetween(todayDate);
        decimal remainDay = Decimal.ValueOf(diffDay)/365;
        
        string year = String.ValueOf(Integer.ValueOf(remainDay));
        String month = String.ValueOf(remainDay.setScale(1)).substringAfter('.');
        
        age = year + 'ปี ' + month + 'เดือน';
        
        return age;
        
    }
    
    private static boolean findRetirementChoice(date birthDate, date todayDate) {
        
        boolean isSixtyYear = false;
        
        integer diffDay = birthDate.daysBetween(todayDate);
        decimal remainDay = Decimal.ValueOf(diffDay)/365;
        
        string year = String.ValueOf(Integer.ValueOf(remainDay));
        String month = String.ValueOf(remainDay.setScale(1)).substringAfter('.');
        
        if(Integer.ValueOf(year) >= 56) {
            isSixtyYear = true;
        }
        else if(Integer.ValueOf(year) == 55 && Integer.ValueOf(month) >= 1) {
            isSixtyYear = true;
        }
        
        return isSixtyYear;
        
    }
    
    public class RetirementSearchCriteria {
        @RemoteAction
        public string year {get;set;}
        //enum RetirementStatus
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
    }
    
    public static boolean sortByEmployeeIdDesc {get;set;}
    public static boolean sortByEmployeeNameDesc {get;set;}
    public static boolean sortByBirthDateDesc {get;set;}
    public static boolean sortByAgeDesc {get;set;}
    public static boolean sortByFunctionDesc {get;set;}
    public static boolean sortByDepartmentDesc {get;set;}
    public static boolean sortBySectionDesc {get;set;}
    public static boolean sortByLevelDesc {get;set;}
    public static boolean sortBySectionHeadNameDesc {get;set;}
    public static boolean sortByDepartmentHeadNameDesc {get;set;}
    
    public static string EMPLOYEEID_SORT = 'EmployeeId';
    public static string SORT_BY = EMPLOYEEID_SORT;
    public static string EMPLOYEEID_SORT_DESC = 'EmployeeIdDesc';
    public static string EMPLOYEENAME_SORT = 'EmployeeName';
    public static string EMPLOYEENAME_SORT_DESC = 'EmployeeNameDesc';
    public static string BIRTHDATE_SORT = 'BirthDate';
    public static string BIRTHDATE_SORT_DESC = 'BirthDateDesc';
    public static string AGE_SORT = 'Age';
    public static string AGE_SORT_DESC = 'AgeDesc';
    public static string FUNCTION_SORT = 'Function';
    public static string FUNCTION_SORT_DESC = 'FunctionDesc';
    public static string DEPARTMENT_SORT = 'Department';
    public static string DEPARTMENT_SORT_DESC = 'DepartmentDesc';
    public static string SECTION_SORT = 'Section';
    public static string SECTION_SORT_DESC = 'SectionDesc';
    public static string LEVEL_SORT = 'Level';
    public static string LEVEL_SORT_DESC = 'LevelDesc';
    public static string SECTIONHEADNAME_SORT = 'SectionHeadName';
    public static string SECTIONHEADNAME_SORT_DESC = 'SectionHeadNameDesc';
    public static string DEPARTMENTHEADNAME_SORT = 'DepartmentHeadName';
    public static string DEPARTMENTHEADNAME_SORT_DESC = 'DepartmentHeadNameDesc';
    
    public class RetirementListSortDTO implements Comparable {
        @RemoteAction
        public string retirementId {get;set;}
        @RemoteAction
        public boolean isDisable {get;set;}
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeTitle {get;set;}
        @remoteAction
        public string employeeNameTH {get;set;}
        @RemoteAction
        public date birthDate {get;set;}
        @RemoteAction
        public string age {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string level {get;set;}
        @RemoteAction
        public string sectionHeadEmployeeId {get;set;}
        @RemoteAction
        public string sectionHead {get;set;}
        @RemoteAction
        public string sectionHeadTH {get;set;}
        @RemoteAction
        public string departmentHeadEmployeeId {get;set;}
        @RemoteAction
        public string departmentHead {get;set;}
        @RemoteAction
        public string departmentHeadTH {get;set;}
        @RemoteAction
        public string sectionHeadName {get;set;}
        @RemoteAction
        public string departmentHeadName {get;set;}
        @RemoteAction
        public string sectionHeadPosition {get;set;}
        @RemoteAction
        public string departmentHeadPosition {get;set;}
        @RemoteAction
        public string sectionHeadPositionTH {get;set;}
        @RemoteAction
        public string departmentHeadPositionTH {get;set;}
        
        public RetirementListSortDTO() { }
        
        //Sort By
        public RetirementListSortDTO(string employeeId, string employeeName, date birthDate, string age, string function, string department, string section, string level, string sectionHeadName,
                                    	string departmentHeadName) {
            
            this.employeeId = employeeId;
            this.employeeName = employeeName;
            this.birthDate = birthDate;
            this.age = age;
            this.function = function; 
            this.department = department; 
            this.section = section; 
            this.level = level;                                
            this.sectionHeadName = sectionHeadName;
            this.departmentHeadName = departmentHeadName;
                                
        }
        
        //employeeId Sort
        public integer sortByEmployeeId(RetirementListSortDTO Retirement) {
            if(this.employeeId > Retirement.employeeId) {
                return 1;
            }
            if(this.employeeId == Retirement.employeeId) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByEmployeeIdDesc(RetirementListSortDTO Retirement) {
            if(this.employeeId < Retirement.employeeId) {
                return 1;
            }
            if(this.employeeId == Retirement.employeeId) {
                return 0;
            }
            
            return -1;
        }
        //employeeName Sort
        public integer sortByEmployeeName(RetirementListSortDTO Retirement) {
            if(this.employeeName > Retirement.employeeName) {
                return 1;
            }
            if(this.employeeName == Retirement.employeeName) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByEmployeeNameDesc(RetirementListSortDTO Retirement) {
            if(this.employeeName < Retirement.employeeName) {
                return 1;
            }
            if(this.employeeName == Retirement.employeeName) {
                return 0;
            }
            
            return -1;
    	}
        //birthDate Sort
        public integer sortByBirthDate(RetirementListSortDTO Retirement) {
            if(this.birthDate > Retirement.birthDate) {
                return 1;
            }
            if(this.birthDate == Retirement.birthDate) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByBirthDateDesc(RetirementListSortDTO Retirement) {
            if(this.birthDate < Retirement.birthDate) {
                return 1;
            }
            if(this.birthDate == Retirement.birthDate) {
                return 0;
            }
            
            return -1;
        }
        //age Sort
        public integer sortByAge(RetirementListSortDTO Retirement) {
            if(this.age > Retirement.age) {
                return 1;
            }
            if(this.age == Retirement.age) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByAgeDesc(RetirementListSortDTO Retirement) {
            if(this.age < Retirement.age) {
                return 1;
            }
            if(this.age == Retirement.age) {
                return 0;
            }
            
            return -1;
        }
        //Function Sort
        public integer sortByFunction(RetirementListSortDTO Retirement) {
            if(this.function > Retirement.function) {
                return 1;
            }
            if(this.function == Retirement.function) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByFunctionDesc(RetirementListSortDTO Retirement) {
            if(this.function < Retirement.function) {
                return 1;
            }
            if(this.function == Retirement.function) {
                return 0;
            }
            
            return -1;
        }
        //Department Sort
        public integer sortByDepartment(RetirementListSortDTO Retirement) {
            if(this.department > Retirement.department) {
                return 1;
            }
            if(this.department == Retirement.department) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByDepartmentDesc(RetirementListSortDTO Retirement) {
            if(this.department < Retirement.department) {
                return 1;
            }
            if(this.department == Retirement.department) {
                return 0;
            }
            
            return -1;
        }
        //Section Sort
        public integer sortBySection(RetirementListSortDTO Retirement) {
            if(this.section > Retirement.section) {
                return 1;
            }
            if(this.section == Retirement.section) {
                return 0;
            }
            
            return -1;
        }
        public integer sortBySectionDesc(RetirementListSortDTO Retirement) {
            if(this.section < Retirement.section) {
                return 1;
            }
            if(this.section == Retirement.section) {
                return 0;
            }
            
            return -1;
        }
        //Level Sort
        public integer sortByLevel(RetirementListSortDTO Retirement) {
            if(this.level > Retirement.level) {
                return 1;
            }
            if(this.level == Retirement.level) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByLevelDesc(RetirementListSortDTO Retirement) {
            if(this.level < Retirement.level) {
                return 1;
            }
            if(this.level == Retirement.level) {
                return 0;
            }
            
            return -1;
        }
        //SectionHeadName Sort
        public integer sortBySectionHeadName(RetirementListSortDTO Retirement) {
            if(this.sectionHeadName > Retirement.sectionHeadName) {
                return 1;
            }
            if(this.sectionHeadName == Retirement.sectionHeadName) {
                return 0;
            }
            
            return -1;
        }
        public integer sortBySectionHeadNameDesc(RetirementListSortDTO Retirement) {
            if(this.sectionHeadName < Retirement.sectionHeadName) {
                return 1;
            }
            if(this.sectionHeadName == Retirement.sectionHeadName) {
                return 0;
            }
            
            return -1;
        }
        //DepartmentHeadName Sort
        public integer sortByDepartmentHeadName(RetirementListSortDTO Retirement) {
            if(this.departmentHeadName > Retirement.departmentHeadName) {
                return 1;
            }
            if(this.departmentHeadName == Retirement.departmentHeadName) {
                return 0;
            }
            
            return -1;
        }
        public integer sortByDepartmentHeadNameDesc(RetirementListSortDTO Retirement) {
            if(this.departmentHeadName < Retirement.departmentHeadName) {
                return 1;
            }
            if(this.departmentHeadName == Retirement.departmentHeadName) {
                return 0;
            }
            
            return -1;
        }
        
        public Integer compareTo(Object obj) {
            RetirementListSortDTO Retirement = (RetirementListSortDTO)(obj);

            if (SORT_BY == EMPLOYEEID_SORT) {
                return sortByEmployeeId(Retirement);
            }
            else if (SORT_BY == EMPLOYEEID_SORT_DESC) {
                return sortByEmployeeIdDesc(Retirement);
            }
            else if (SORT_BY == EMPLOYEENAME_SORT) {
                return sortByEmployeeName(Retirement);
            }
            else if (SORT_BY == EMPLOYEENAME_SORT_DESC) {
                return sortByEmployeeNameDesc(Retirement);
            }
            else if (SORT_BY == BIRTHDATE_SORT) {
                return sortByBirthDate(Retirement);
            }
            else if (SORT_BY == BIRTHDATE_SORT_DESC) {
                return sortByBirthDateDesc(Retirement);
            }
            else if (SORT_BY == AGE_SORT) {
                return sortByAge(Retirement);
            }
            else if (SORT_BY == AGE_SORT_DESC) {
                return sortByAgeDesc(Retirement);
            }
            else if (SORT_BY == FUNCTION_SORT) {
                return sortByFunction(Retirement);
            }
            else if (SORT_BY == FUNCTION_SORT_DESC) {
                return sortByFunctionDesc(Retirement);
            }
            else if (SORT_BY == DEPARTMENT_SORT) {
                return sortByDepartment(Retirement);
            }
            else if (SORT_BY == DEPARTMENT_SORT_DESC) {
                return sortByDepartmentDesc(Retirement);
            }
            else if (SORT_BY == SECTION_SORT) {
                return sortBySection(Retirement);
            }
            else if (SORT_BY == SECTION_SORT_DESC) {
                return sortBySectionDesc(Retirement);
            }
            else if (SORT_BY == LEVEL_SORT) {
                return sortByLevel(Retirement);
            }
            else if (SORT_BY == LEVEL_SORT_DESC) {
                return sortByLevelDesc(Retirement);
            }
            else if (SORT_BY == SECTIONHEADNAME_SORT) {
                return sortBySectionHeadName(Retirement);
            }
            else if (SORT_BY == SECTIONHEADNAME_SORT_DESC) {
                return sortBySectionHeadNameDesc(Retirement);
            }
            else if (SORT_BY == DEPARTMENTHEADNAME_SORT) {
                return sortByDepartmentHeadName(Retirement);
            }
            else if (SORT_BY == DEPARTMENTHEADNAME_SORT_DESC) {
                return sortByDepartmentHeadNameDesc(Retirement);
            }
            
            // If we don't have a know sort by, let's just return that they are all equal
            return 0;
        }
    }
    
    public static void sortByEmployeeId(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortByEmployeeIdDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.EMPLOYEEID_SORT;
            
            sortByEmployeeIdDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.EMPLOYEEID_SORT_DESC;
            
            sortByEmployeeIdDesc = true;
        }
        
        retirementSortLists.sort();
        
        //sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByBirthDateDesc = false;
        sortByAgeDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByLevelDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static void sortByEmployeeName(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortByEmployeeNameDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.EMPLOYEENAME_SORT;
            
            sortByEmployeeNameDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.EMPLOYEENAME_SORT_DESC;
            
            sortByEmployeeNameDesc = true;
        }
        
        retirementSortLists.sort();
        
        sortByEmployeeIdDesc = false;
        //sortByEmployeeNameDesc = false;
        sortByBirthDateDesc = false;
        sortByAgeDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByLevelDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static void sortByBirthDate(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortByBirthDateDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.BIRTHDATE_SORT;
            
            sortByBirthDateDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.BIRTHDATE_SORT_DESC;
            
            sortByBirthDateDesc = true;
        }
        
        retirementSortLists.sort();
        
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        //sortByBirthDateDesc = false;
        sortByAgeDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByLevelDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static void sortByAge(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortByAgeDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.AGE_SORT;
            
            sortByAgeDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.AGE_SORT_DESC;
            
            sortByAgeDesc = true;
        }
        
        retirementSortLists.sort();
        
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByBirthDateDesc = false;
        //sortByAgeDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByLevelDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static void sortByFunction(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortByFunctionDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.FUNCTION_SORT;
            
            sortByFunctionDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.FUNCTION_SORT_DESC;
            
            sortByFunctionDesc = true;
        }
        
        retirementSortLists.sort();
        
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByBirthDateDesc = false;
        sortByAgeDesc = false;
        //sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByLevelDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static void sortByDepartment(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortByDepartmentDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.DEPARTMENT_SORT;
            
            sortByDepartmentDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.DEPARTMENT_SORT_DESC;
            
            sortByDepartmentDesc = true;
        }
        
        retirementSortLists.sort();
        
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByBirthDateDesc = false;
        sortByAgeDesc = false;
        sortByFunctionDesc = false;
        //sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByLevelDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static void sortBySection(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortBySectionDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.SECTION_SORT;
            
            sortBySectionDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.SECTION_SORT_DESC;
            
            sortBySectionDesc = true;
        }
        
        retirementSortLists.sort();
        
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByBirthDateDesc = false;
        sortByAgeDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        //sortBySectionDesc = false;
        sortByLevelDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static void sortByLevel(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortByLevelDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.LEVEL_SORT;
            
            sortByLevelDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.LEVEL_SORT_DESC;
            
            sortByLevelDesc = true;
        }
        
        retirementSortLists.sort();
        
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByBirthDateDesc = false;
        sortByAgeDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        //sortByLevelDesc = false;
        sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static void sortBySectionHeadName(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortBySectionHeadNameDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.SECTIONHEADNAME_SORT;
            
            sortBySectionHeadNameDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.SECTIONHEADNAME_SORT_DESC;
            
            sortBySectionHeadNameDesc = true;
        }
        
        retirementSortLists.sort();
        
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByBirthDateDesc = false;
        sortByAgeDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByLevelDesc = false;
        //sortBySectionHeadNameDesc = false;
        sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static void sortByDepartmentHeadName(List<RetirementListSortDTO> retirementSortLists) {
    
        if(!sortByDepartmentHeadNameDesc) {
            ESS_Retirement.SORT_BY = ESS_Retirement.DEPARTMENTHEADNAME_SORT;
            
            sortByDepartmentHeadNameDesc = false;
        }
        else {
            ESS_Retirement.SORT_BY = ESS_Retirement.DEPARTMENTHEADNAME_SORT_DESC;
            
            sortByDepartmentHeadNameDesc = true;
        }
        
        retirementSortLists.sort();
        
        sortByEmployeeIdDesc = false;
        sortByEmployeeNameDesc = false;
        sortByBirthDateDesc = false;
        sortByAgeDesc = false;
        sortByFunctionDesc = false;
        sortByDepartmentDesc = false;
        sortBySectionDesc = false;
        sortByLevelDesc = false;
        sortBySectionHeadNameDesc = false;
        //sortByDepartmentHeadNameDesc = false;
        
    }
    
    public static List<ESS_Retirement__c> RetirementExisted(string employeeId) {
        List<ESS_Retirement__c> Retirements = [select id, status__c from ESS_Retirement__c where Employee_Id__c = :employeeId];
        return Retirements;
    }
    
    public static string RetirementCurrentStatus(string recordId) {
        ESS_Retirement__c Retirement = [select id, status__c from ESS_Retirement__c where Id = :recordId];
        return Retirement.Status__c;
    }
    
}