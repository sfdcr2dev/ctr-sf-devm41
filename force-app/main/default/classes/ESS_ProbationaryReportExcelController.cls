/* Author Softever */
public with sharing class ESS_ProbationaryReportExcelController {

    public string trackingReportType {get;set;}
    public integer probationSize {get;set;}
    public date todayDate {get;set;}
    
    public List<ESS_ProbationaryReport_DTO.ProbationTableDTO> probationTables {get;set;}
    
    public void OnloadExcel() {
        
        todayDate = date.today();
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        probationSize = 0;
        
        probationTables = new List<ESS_ProbationaryReport_DTO.ProbationTableDTO>();
        
        trackingReportType = ApexPages.currentPage().getParameters().get('TrackingReportType');
        
        if(trackingReportType == 'Probation') {
        
            boolean isAdmin = ESS_PrivilegeHandler.checkProbationAdminUser(userId);
        
            List<ESS_Probationary__c> Probations = new List<ESS_Probationary__c>();
            ESS_ProbationaryReport.ProbationSearchCriteria filter = new ESS_ProbationaryReport.ProbationSearchCriteria();
            
            filter.employeeId = ApexPages.currentPage().getParameters().get('employeeId');
            filter.sectionHead = ApexPages.currentPage().getParameters().get('sectionHead');
            filter.departmentHead = ApexPages.currentPage().getParameters().get('departmentHead');
            filter.function = ApexPages.currentPage().getParameters().get('function');
            filter.department = ApexPages.currentPage().getParameters().get('department');
            filter.section = ApexPages.currentPage().getParameters().get('section');
            filter.level = ApexPages.currentPage().getParameters().get('level');
            filter.statusAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusAll'));
            filter.statusWaitingForApprovalSectionHead = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusWaitingForApprovalSectionHead'));
            filter.statusWaitingReassignSectionHead = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusWaitingReassignSectionHead'));
            filter.statusWaitingForApprovalDepartmentHead = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusWaitingForApprovalDepartmentHead'));
            filter.statusWaitingReassignDepartmentHead = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusWaitingReassignDepartmentHead'));
            filter.statusWaitingForUploadToPersonalFolder = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusWaitingForUploadToPersonalFolder'));
            filter.statusCompleted = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusCompleted'));
            filter.statusUploadFailed = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusUploadFailed'));
            filter.probationStatusAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('probationStatusAll'));
            filter.probationStatusRegularEmployee = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('probationStatusRegularEmployee'));
            filter.probationStatusTerminateEmployee = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('probationStatusTerminateEmployee'));
            
            if(ApexPages.currentPage().getParameters().get('startCreatedDate') != null && ApexPages.currentPage().getParameters().get('startCreatedDate') != 'null') {
                filter.startCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCreatedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endCreatedDate') != null && ApexPages.currentPage().getParameters().get('endCreatedDate') != 'null') {
                filter.endCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCreatedDate'));
            	filter.endCreatedDate = filter.endCreatedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startSectionHeadSubmittedDate') != null && ApexPages.currentPage().getParameters().get('startSectionHeadSubmittedDate') != 'null') {
                filter.startSectionHeadSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startSectionHeadSubmittedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endSectionHeadSubmittedDate') != null && ApexPages.currentPage().getParameters().get('endSectionHeadSubmittedDate') != 'null') {
                filter.endSectionHeadSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endSectionHeadSubmittedDate'));
            	filter.endSectionHeadSubmittedDate = filter.endSectionHeadSubmittedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startSectionHeadReassignedDate') != null && ApexPages.currentPage().getParameters().get('startSectionHeadReassignedDate') != 'null') {
                filter.startSectionHeadReassignedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startSectionHeadReassignedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endSectionHeadReassignedDate') != null && ApexPages.currentPage().getParameters().get('endSectionHeadReassignedDate') != 'null') {
                filter.endSectionHeadReassignedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endSectionHeadReassignedDate'));
            	filter.endSectionHeadReassignedDate = filter.endSectionHeadReassignedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startSectionHeadReassignedSubmittedDate') != null && ApexPages.currentPage().getParameters().get('startSectionHeadReassignedSubmittedDate') != 'null') {
                filter.startSectionHeadReassignedSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startSectionHeadReassignedSubmittedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endSectionHeadReassignedSubmittedDate') != null && ApexPages.currentPage().getParameters().get('endSectionHeadReassignedSubmittedDate') != 'null') {
                filter.endSectionHeadReassignedSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endSectionHeadReassignedSubmittedDate'));
            	filter.endSectionHeadReassignedSubmittedDate = filter.endSectionHeadReassignedSubmittedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startDepartmentHeadSubmittedDate') != null && ApexPages.currentPage().getParameters().get('startDepartmentHeadSubmittedDate') != 'null') {
                filter.startDepartmentHeadSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startDepartmentHeadSubmittedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endDepartmentHeadSubmittedDate') != null && ApexPages.currentPage().getParameters().get('endDepartmentHeadSubmittedDate') != 'null') {
                filter.endDepartmentHeadSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endDepartmentHeadSubmittedDate'));
            	filter.endDepartmentHeadSubmittedDate = filter.endDepartmentHeadSubmittedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startDepartmentHeadReassignedDate') != null && ApexPages.currentPage().getParameters().get('startDepartmentHeadReassignedDate') != 'null') {
                filter.startDepartmentHeadReassignedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startDepartmentHeadReassignedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endDepartmentHeadReassignedDate') != null && ApexPages.currentPage().getParameters().get('endDepartmentHeadReassignedDate') != 'null') {
                filter.endDepartmentHeadReassignedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endDepartmentHeadReassignedDate'));
            	filter.endDepartmentHeadReassignedDate = filter.endDepartmentHeadReassignedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startDepartmentHeadReassignedSubmittedDate') != null && ApexPages.currentPage().getParameters().get('startDepartmentHeadReassignedSubmittedDate') != 'null') {
                filter.startDepartmentHeadReassignedSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startDepartmentHeadReassignedSubmittedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endDepartmentHeadReassignedSubmittedDate') != null && ApexPages.currentPage().getParameters().get('endDepartmentHeadReassignedSubmittedDate') != 'null') {
                filter.endDepartmentHeadReassignedSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endDepartmentHeadReassignedSubmittedDate'));
            	filter.endDepartmentHeadReassignedSubmittedDate = filter.endDepartmentHeadReassignedSubmittedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startCompletedDate') != null && ApexPages.currentPage().getParameters().get('startCompletedDate') != 'null') {
                filter.startCompletedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCompletedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endCompletedDate') != null && ApexPages.currentPage().getParameters().get('endCompletedDate') != 'null') {
                filter.endCompletedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCompletedDate'));
            	filter.endCompletedDate = filter.endCompletedDate.addDays(1);
            }
            
            string query = 'select id, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, status__c, createddate, section_head__c, department_head__c, completed_date__c, ' +
                            'probation_status__c, function__c, department__c, section__c, unit__c, level__c, section_head_approve_date__c, department_head_approve_date__c, Reassign_Section_Head_Approve_Date__c, Reassign_Department_Head_Approve_Date__c, Reassign_Section_Head_Date__c, Reassign_Department_Head_Date__c, ' +
                            'reassign_section_head__c, reassign_department_head__c, Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c from ESS_Probationary__c where OwnerId =: userId';
            
            if(isAdmin) {
                query = 'select id, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, status__c, createddate, section_head__c, department_head__c, completed_date__c, ' +
                            'probation_status__c, function__c, department__c, section__c, unit__c, level__c, section_head_approve_date__c, department_head_approve_date__c, Reassign_Section_Head_Approve_Date__c, Reassign_Department_Head_Approve_Date__c, Reassign_Section_Head_Date__c, Reassign_Department_Head_Date__c, ' +
                            'reassign_section_head__c, reassign_department_head__c, Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c from ESS_Probationary__c where OwnerId != null';
            } 
                
            //filter.employeeId
            if(string.isNotEmpty(filter.employeeId) && filter.employeeId != 'null') {
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
             
            //Final Query
            Probations = database.query(query + ' order by document_no__c desc');
               
            if(Probations.size() > 0) {
                for(ESS_Probationary__c Probation : Probations) {
                    ESS_ProbationaryReport_DTO.ProbationTableDTO ProbationTable = new ESS_ProbationaryReport_DTO.ProbationTableDTO();
                    ProbationTable = assignToProbationTableDTO(Probation);
                    if(string.isnotempty(ProbationTable.documentNo)) {
                        probationTables.add(ProbationTable);
                    }
                }
            }
            
            probationSize = probationTables.size();
            
        }
        
    }
    
    //Assign to DTO section
    public static ESS_ProbationaryReport_DTO.ProbationTableDTO assignToProbationTableDTO(ESS_Probationary__c Probation) {
        
        ESS_ProbationaryReport_DTO.ProbationTableDTO ProbationTable = new ESS_ProbationaryReport_DTO.ProbationTableDTO();
        ProbationTable.recordId = Probation.Id;
        ProbationTable.documentNo = Probation.Document_No__c;
        ProbationTable.employeeId = Probation.Employee_ID__c;
        ProbationTable.employeeName = Probation.Employee_Name__c;
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
            List<string> names = Probation.Section_Head__c.split(' ');
            ProbationTable.sectionHeadEmployeeId = names[0];
            ProbationTable.sectionHead = Probation.Section_Head__c.substringAfter('- ');
        }
        else {
            ProbationTable.sectionHead = '';
        }
        
        ProbationTable.sectionHeadSubmittedDate = Probation.Section_Head_Approve_Date__c;
        
        if(string.isNotEmpty(Probation.Reassign_Section_Head_JSON__c)) {        
            List<ESS_Probationary_DTO.ReassignDTO> reassignsDTO = (List<ESS_Probationary_DTO.ReassignDTO>)JSON.deserialize(Probation.Reassign_Section_Head_JSON__c, List<ESS_Probationary_DTO.ReassignDTO>.class);
            if(reassignsDTO.size() > 0) { 
                ProbationTable.reassignSectionHeadEmployeeId = reassignsDTO[reassignsDTO.size()-1].employeeId;
                ProbationTable.reassignSectionHead = reassignsDTO[reassignsDTO.size()-1].name;
            }
        }
        else {
            ProbationTable.reassignSectionHead = '';
        }

        ProbationTable.reassignSectionHeadSubmittedDate = Probation.Reassign_Section_Head_Approve_Date__c;
        
        if(string.isNotEmpty(Probation.Department_Head__c)) {        
            List<string> names = Probation.Department_Head__c.split(' ');
            ProbationTable.departmentHeadEmployeeId = names[0];
            ProbationTable.departmentHead = Probation.Department_Head__c.substringAfter('- ');
        }
        else {
            ProbationTable.departmentHead = '';
        }
        
        ProbationTable.departmentHeadSubmittedDate = Probation.Department_Head_Approve_Date__c;
        
        if(string.isNotEmpty(Probation.Reassign_Department_Head_JSON__c)) {
            List<ESS_Probationary_DTO.ReassignDTO> reassignsDTO = (List<ESS_Probationary_DTO.ReassignDTO>)JSON.deserialize(Probation.Reassign_Department_Head_JSON__c, List<ESS_Probationary_DTO.ReassignDTO>.class);
            if(reassignsDTO.size() > 0) { 
                ProbationTable.reassignDepartmentHeadEmployeeId = reassignsDTO[reassignsDTO.size()-1].employeeId;
                ProbationTable.reassignDepartmentHead = reassignsDTO[reassignsDTO.size()-1].name;
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
        
        ProbationTable.function = Probation.Function__c;
        ProbationTable.department = Probation.Department__c;
        ProbationTable.section = Probation.Section__c;
        ProbationTable.unit = Probation.Unit__c;
        ProbationTable.level = Probation.Level__c;
        
        return ProbationTable;
        
    }
    
    
}