/* Author Softever */
public with sharing class ESS_RetirementReportExcelController {

    public string trackingReportType {get;set;}
    public integer retirementSize {get;set;}
    public date todayDate {get;set;}
    
    public List<ESS_RetirementReport_DTO.RetirementTableDTO> retirementTables {get;set;}
    
    public void OnloadExcel() {
        
        todayDate = date.today();
        string userId = ESS_PrivilegeHandler.getUserId();
        
        retirementSize = 0;
        
        retirementTables = new List<ESS_RetirementReport_DTO.RetirementTableDTO>();
        
        trackingReportType = ApexPages.currentPage().getParameters().get('TrackingReportType');
        
        if(trackingReportType == 'Retirement') {
            
            boolean isAdmin = ESS_PrivilegeHandler.checkRetirementAdminUser(userId);
        
            List<ESS_Retirement__c> Retirements = new List<ESS_Retirement__c>();
            ESS_RetirementReport.RetirementSearchCriteria filter = new ESS_RetirementReport.RetirementSearchCriteria();
                
            filter.employeeId = ApexPages.currentPage().getParameters().get('employeeId');
            filter.function = ApexPages.currentPage().getParameters().get('function');
            filter.department = ApexPages.currentPage().getParameters().get('department');
            filter.section = ApexPages.currentPage().getParameters().get('section');
            filter.level = ApexPages.currentPage().getParameters().get('level');
            filter.statusAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusAll'));
            filter.statusWaitingEmployeeSubmit = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusWaitingEmployeeSubmit'));
            filter.statusWaitingForApprovalSectionHead = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusWaitingForApprovalSectionHead'));
            filter.statusWaitingForDepartmentHead = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusWaitingForDepartmentHead'));
            filter.statusWaitingForUploadPersonalFolder = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusWaitingForUploadPersonalFolder'));
            filter.statusCompleted = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusCompleted'));
            filter.statusSendingToSAP = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusSendingToSAP'));
            filter.statusDefaultFromSystem = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusDefaultFromSystem'));
            filter.statusUploadFailed = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusUploadFailed'));
            filter.retirementAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('retirementAll'));
            filter.retirementExact55Years = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('retirementExact55Years'));
            filter.retirementExact60Years = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('retirementExact60Years'));
            filter.retirementEndOfMonth = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('retirementEndOfMonth'));
            filter.retirementEndOfYear = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('retirementEndOfYear'));
            
            if(ApexPages.currentPage().getParameters().get('startCreatedDate') != null && ApexPages.currentPage().getParameters().get('startCreatedDate') != 'null') {
                filter.startCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCreatedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endCreatedDate') != null && ApexPages.currentPage().getParameters().get('endCreatedDate') != 'null') {
                filter.endCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCreatedDate'));
            	filter.endCreatedDate = filter.endCreatedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startEmployeeSubmittedDate') != null && ApexPages.currentPage().getParameters().get('startEmployeeSubmittedDate') != 'null') {
                filter.startEmployeeSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startEmployeeSubmittedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endEmployeeSubmittedDate') != null && ApexPages.currentPage().getParameters().get('endEmployeeSubmittedDate') != 'null') {
                filter.endEmployeeSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endEmployeeSubmittedDate'));
            	filter.endEmployeeSubmittedDate = filter.endEmployeeSubmittedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startSectionHeadApprovedDate') != null && ApexPages.currentPage().getParameters().get('startSectionHeadApprovedDate') != 'null') {
                filter.startSectionHeadApprovedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startSectionHeadApprovedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endSectionHeadApprovedDate') != null && ApexPages.currentPage().getParameters().get('endSectionHeadApprovedDate') != 'null') {
                filter.endSectionHeadApprovedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endSectionHeadApprovedDate'));
            	filter.endSectionHeadApprovedDate = filter.endSectionHeadApprovedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startDepartmentHeadApprovedDate') != null && ApexPages.currentPage().getParameters().get('startDepartmentHeadApprovedDate') != 'null') {
                filter.startDepartmentHeadApprovedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startDepartmentHeadApprovedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endDepartmentHeadApprovedDate') != null && ApexPages.currentPage().getParameters().get('endDepartmentHeadApprovedDate') != 'null') {
                filter.endDepartmentHeadApprovedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endDepartmentHeadApprovedDate'));
            	filter.endDepartmentHeadApprovedDate = filter.endDepartmentHeadApprovedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startCompletedDate') != null && ApexPages.currentPage().getParameters().get('startCompletedDate') != 'null') {
                filter.startCompletedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCompletedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endCompletedDate') != null && ApexPages.currentPage().getParameters().get('endCompletedDate') != 'null') {
                filter.endCompletedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCompletedDate'));
            	filter.endCompletedDate = filter.endCompletedDate.addDays(1);
            }
            
            string query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
                        'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
                        'function__c, department__c, section__c, level__c, Section_Head_Id__c, Department_Head_Id__c from ESS_Retirement__c where OwnerId =: userId';
            
            if(isAdmin) {
                query = 'select id, document_no__c, employee_id__c, employee_name__c, date_of_birth__c, age__c, retirement_date__c, default_retirement_date__c, retirement_choice__c, section_head__c, department_head__c, status__c, ' +
                            'createddate, submitted_date__c, section_head_approve_date__c, department_head_approve_date__c, upload_to_personal_folder_date__c, sending_to_sap_date__c, completed_date__c,  ' +
                            'function__c, department__c, section__c, level__c, Section_Head_Id__c, Department_Head_Id__c from ESS_Retirement__c where OwnerId != null';
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
            
            //Final Query
            Retirements = database.query(query + ' order by document_no__c desc');
            
            if(Retirements.size() > 0) {
                for(ESS_Retirement__c Retirement : Retirements) {
                    ESS_RetirementReport_DTO.RetirementTableDTO RetirementTable = new ESS_RetirementReport_DTO.RetirementTableDTO();
                    RetirementTable = assignToRetirementTableDTO(Retirement);
                    if(string.isnotempty(RetirementTable.documentNo)) {
                        retirementTables.add(RetirementTable);
                    }
                }
            }
            
            retirementSize = retirementTables.size();
        }
        
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
            //RetirementTable.sectionHead = Retirement.Section_Head__c;
            List<string> names = Retirement.Section_Head__c.split(' ');
            RetirementTable.sectionHeadEmployeeId = names[0];
            RetirementTable.sectionHead = Retirement.Section_Head__c.substringAfter('- ');
        }
        else {
            RetirementTable.sectionHead = '';
        }
        
        
        if(string.isNotEmpty(Retirement.Department_Head_Id__c)) {
            //RetirementTable.departmentHead = Retirement.Department_Head__c;
            List<string> names = Retirement.Department_Head__c.split(' ');
            RetirementTable.departmentHeadEmployeeId = names[0];
            RetirementTable.departmentHead = Retirement.Department_Head__c.substringAfter('- ');
        }
        else {
            RetirementTable.departmentHead = '';
        }
        
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
    
    
}