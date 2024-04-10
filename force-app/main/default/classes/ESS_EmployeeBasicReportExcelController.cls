/* Author Softever */
public with sharing class ESS_EmployeeBasicReportExcelController {

    public string trackingReportType {get;set;}
    public integer employeeBasicSize {get;set;}
    public date todayDate {get;set;}
    
    public List<ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO> employeeBasicTables {get;set;}
    
    public void OnloadExcel() {
        
        todayDate = date.today();
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        employeeBasicSize = 0;
        
        employeeBasicTables = new List<ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO>();
        
        trackingReportType = ApexPages.currentPage().getParameters().get('TrackingReportType');
        
        if(trackingReportType == 'EmployeeBasic') {
            
            boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
        
            List<ESS_Application__c> Applications = new List<ESS_Application__c>();
            ESS_EmployeeBasicReport.SearchCriteria filter = new ESS_EmployeeBasicReport.SearchCriteria();
                
            filter.employeeId = ApexPages.currentPage().getParameters().get('employeeId');
            filter.companyName = ApexPages.currentPage().getParameters().get('companyName');
            filter.function = ApexPages.currentPage().getParameters().get('function');
            filter.department = ApexPages.currentPage().getParameters().get('department');
            filter.section = ApexPages.currentPage().getParameters().get('section');
            filter.unit = ApexPages.currentPage().getParameters().get('unit');
            filter.searchAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchAll'));
            filter.searchName = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchName'));
            filter.searchStatus = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchStatus'));
            filter.searchChild = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchChild'));
            filter.searchDeath = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchDeath'));
            filter.searchEducation = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchEducation'));
            filter.searchLicense = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchLicense'));
            filter.searchAddress = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchAddress'));
            filter.searchContactPerson = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchContactPerson'));
            filter.searchTax = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('searchTax'));
            filter.statusAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusAll'));
            filter.statusDraft = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusDraft'));
            filter.statusSubmitted = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusSubmitted'));
            filter.statusSendingToSAP = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusSendingToSAP'));
            filter.statusCompleted = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusCompleted'));
            filter.statusVerified = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusVerified'));
            filter.statusSendingToSAP = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusSendingToSAP'));
            filter.statusCompleted = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusCompleted'));
            filter.statusVerified = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusVerified'));
            filter.statusCancelled = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusCancelled'));
            filter.statusError = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('statusError'));
            
            if(ApexPages.currentPage().getParameters().get('startCreatedDate') != null && ApexPages.currentPage().getParameters().get('startCreatedDate') != 'null') {
                filter.startCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCreatedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endCreatedDate') != null && ApexPages.currentPage().getParameters().get('endCreatedDate') != 'null') {
                filter.endCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCreatedDate'));
                filter.endCreatedDate = filter.endCreatedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startSubmittedDate') != null && ApexPages.currentPage().getParameters().get('startSubmittedDate') != 'null') {
                filter.startSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startSubmittedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endSubmittedDate') != null && ApexPages.currentPage().getParameters().get('endSubmittedDate') != 'null') {
                filter.endSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endSubmittedDate'));
                filter.endSubmittedDate = filter.endSubmittedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startVerifiedDate') != null && ApexPages.currentPage().getParameters().get('startVerifiedDate') != 'null') {
                filter.startVerifiedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startVerifiedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endVerifiedDate') != null && ApexPages.currentPage().getParameters().get('endVerifiedDate') != 'null') {
                filter.endVerifiedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endVerifiedDate'));
                filter.endVerifiedDate = filter.endVerifiedDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startEffectiveDate') != null && ApexPages.currentPage().getParameters().get('startEffectiveDate') != 'null') {
                filter.startEffectiveDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startEffectiveDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endEffectiveDate') != null && ApexPages.currentPage().getParameters().get('endEffectiveDate') != 'null') {
                filter.endEffectiveDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endEffectiveDate'));
                filter.endEffectiveDate = filter.endEffectiveDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startSendToBatchDate') != null && ApexPages.currentPage().getParameters().get('startSendToBatchDate') != 'null') {
                filter.startSendToBatchDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startSendToBatchDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endSendToBatchDate') != null && ApexPages.currentPage().getParameters().get('endSendToBatchDate') != 'null') {
                filter.endSendToBatchDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endSendToBatchDate'));
                filter.endSendToBatchDate = filter.endSendToBatchDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startSendingToSAPDate') != null && ApexPages.currentPage().getParameters().get('startSendingToSAPDate') != 'null') {
                filter.startSendingToSAPDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startSendingToSAPDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endSendingToSAPDate') != null && ApexPages.currentPage().getParameters().get('endSendingToSAPDate') != 'null') {
                filter.endSendingToSAPDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endSendingToSAPDate'));
                filter.endSendingToSAPDate = filter.endSendingToSAPDate.addDays(1);
            }
            if(ApexPages.currentPage().getParameters().get('startCompletedDate') != null && ApexPages.currentPage().getParameters().get('startCompletedDate') != 'null') {
                filter.startCompletedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCompletedDate'));
            }
            if(ApexPages.currentPage().getParameters().get('endCompletedDate') != null && ApexPages.currentPage().getParameters().get('endCompletedDate') != 'null') {
                filter.endCompletedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCompletedDate'));
                filter.endCompletedDate = filter.endCompletedDate.addDays(1);
            }
            
            string query = 'select id, document_no__c, subject_type__c, employee_id__c, employee_name__c, status_marriage_employee_id__c, status_marriage_en_title__c, Status_Marriage_EN_FN__c , Status_Marriage_EN_LN__c, ' +
                            'is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
                            'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, function__c, department__c, section__c, unit__c, Sending_to_SAP_Date__c, Effective_Date__c from ESS_Application__c where OwnerId =: userId';
            
            if(isAdmin) {
                query = 'select id, document_no__c, subject_type__c, employee_id__c, employee_name__c, status_marriage_employee_id__c, status_marriage_en_title__c, Status_Marriage_EN_FN__c , Status_Marriage_EN_LN__c, ' +
                            'is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
                            'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, function__c, department__c, section__c, unit__c, Sending_to_SAP_Date__c, Effective_Date__c from ESS_Application__c where OwnerId != null';
            } 
                
            //filter.employeeId
            if(string.isNotEmpty(filter.employeeId) && filter.employeeId != 'null') {
                string employeeId = '%' + filter.employeeId + '%';
                query = query + ' AND employee_id__c like: employeeId';
            }
                
            //filter.companyName
            if(string.isNotEmpty(filter.companyName) && filter.companyName.toLowerCase() != 'all') {
                string companyName = filter.companyName;
                query = query + ' AND company_name__c =: companyName';
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
                
            //filter.unit
            if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
                string unit = filter.unit;
                query = query + ' AND unit__c =: unit';
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
                    query = query + ' subject_type__c = null';
                }
                query = query + ')';
                
            }
               
            //filter.statusAll
            List<string> statuses = new List<string>();
            if(filter.statusAll) {
                statuses.add(ESS_Enum.ApplicationStatus.Draft.name());
                statuses.add(ESS_Enum.ApplicationStatus.Submitted.name());
                statuses.add(ESS_Enum.ApplicationStatus.SendingToSAP.name());
                statuses.add(ESS_Enum.ApplicationStatus.Completed.name());
                statuses.add(ESS_Enum.ApplicationStatus.Cancelled.name());
                statuses.add(ESS_Enum.ApplicationStatus.Verified.name());
                statuses.add(ESS_Enum.ApplicationStatus.Error.name());
            }
            else {
                
                //filter.statusDraft
                if(filter.statusDraft) {
                    statuses.add(ESS_Enum.ApplicationStatus.Draft.name());
                }
                //filter.statusSubmitted
                if(filter.statusSubmitted) {
                    statuses.add(ESS_Enum.ApplicationStatus.Submitted.name());
                }
                //filter.statusSendingToSAP
                if(filter.statusSendingToSAP) {
                    statuses.add(ESS_Enum.ApplicationStatus.SendingToSAP.name());
                }
                //filter.statusCompleted
                if(filter.statusCompleted) {
                    statuses.add(ESS_Enum.ApplicationStatus.Completed.name());
                }
                //filter.statusCancelled
                if(filter.statusCancelled) {
                    statuses.add(ESS_Enum.ApplicationStatus.Cancelled.name());
                }
                //filter.statusVerified
                if(filter.statusVerified) {
                    statuses.add(ESS_Enum.ApplicationStatus.Verified.name());
                }
                //filter.statusError
                if(filter.statusError) {
                    statuses.add(ESS_Enum.ApplicationStatus.Error.name());
                }
            }
                
            query = query + ' AND status__c IN: statuses';
            
            
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
            
            //filter.startSubmittedDate
            if(filter.startSubmittedDate != null) {
                date startSubmittedDate = filter.startSubmittedDate;
                query = query + ' AND (submitted_date__c >=: startSubmittedDate)';
            }
            
            //filter.endSubmittedDate
            if(filter.endSubmittedDate != null) {
                date endSubmittedDate = filter.endSubmittedDate;
                query = query + ' AND (submitted_date__c <=: endSubmittedDate)';
            }
            
            //filter.startVerifiedDate
            if(filter.startVerifiedDate != null) {
                date startVerifiedDate = filter.startVerifiedDate;
                query = query + ' AND (verified_date__c >=: startVerifiedDate)';
            }
            
            //filter.endVerifiedDate
            if(filter.endVerifiedDate != null) {
                date endVerifiedDate = filter.endVerifiedDate;
                query = query + ' AND (verified_date__c <=: endVerifiedDate)';
            }
            
            //filter.startEffectiveDate
            if(filter.startEffectiveDate != null) {
                date startEffectiveDate = filter.startEffectiveDate;
                query = query + ' AND (effective_date__c >=: startEffectiveDate)';
            }
            
            //filter.endEffectiveDate
            if(filter.endEffectiveDate != null) {
                date endEffectiveDate = filter.endEffectiveDate;
                query = query + ' AND (effective_date__c <=: endEffectiveDate)';
            }
            
            //filter.startSendToBatchDate
            if(filter.startSendToBatchDate != null) {
                date startSendToBatchDate = filter.startSendToBatchDate;
                query = query + ' AND (verified_date__c >=: startSendToBatchDate)';
            }
            
            //filter.endSendToBatchDate
            if(filter.endSendToBatchDate != null) {
                date endSendToBatchDate = filter.endSendToBatchDate;
                query = query + ' AND (verified_date__c <=: endSendToBatchDate)';
            }
            
            //filter.startSendingToSAPDate
            if(filter.startSendingToSAPDate != null) {
                date startSendingToSAPDate = filter.startSendingToSAPDate;
                query = query + ' AND (Sending_to_SAP_Date__c >=: startSendingToSAPDate)';
            }
            
            //filter.endSendingToSAPDate
            if(filter.endSendingToSAPDate != null) {
                date endSendingToSAPDate = filter.endSendingToSAPDate;
                query = query + ' AND (Sending_to_SAP_Date__c <=: endSendingToSAPDate)';
            }
            
            //filter.startCompletedDate
            if(filter.startCompletedDate != null) {
                date startCompletedDate = Date.ValueOf(filter.startCompletedDate);
                query = query + ' AND (completed_date__c >=: startCompletedDate)';
            }
            
            //filter.endCompletedDate
            if(filter.endCompletedDate != null) {
                date endCompletedDate = Date.ValueOf(filter.endCompletedDate);
                query = query + ' AND (completed_date__c <=: endCompletedDate)';
            }
            
            //Final Query
            Applications = database.query(query + ' order by document_no__c desc');
            system.debug(Applications.size());
            if(Applications.size() > 0) {
                for(ESS_Application__c App : Applications) {
                    ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO EmployeeBasicTable = new ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO();
                    EmployeeBasicTable = assignToEmployeeBasicTableDTO(App);
                    employeeBasicTables.add(EmployeeBasicTable);
                }
            }
            
            employeeBasicSize = employeeBasicTables.size();
        }        
    }
    
    //Assign to DTO section
    public static ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO assignToEmployeeBasicTableDTO(ESS_Application__c EmployeeBasic) {
    
        ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO EmployeeBasicTable = new ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO();
        EmployeeBasicTable.recordId = EmployeeBasic.Id;
        EmployeeBasicTable.documentNo = EmployeeBasic.Document_No__c;
        EmployeeBasicTable.subjectType = EmployeeBasic.Subject_Type__c;
        EmployeeBasicTable.employeeId = EmployeeBasic.Employee_ID__c;
        EmployeeBasicTable.employeeName = EmployeeBasic.Employee_Name__c;
        
        string spouseId = '';
        if(string.isNotEmpty(EmployeeBasic.Status_Marriage_Employee_Id__c)) {
            EmployeeBasicTable.spouseId = EmployeeBasic.Status_Marriage_Employee_Id__c;
        }
        else {
            EmployeeBasicTable.spouseId = spouseId;
        }
        
        string enTitle = '';
        if(EmployeeBasic.Status_Marriage_EN_Title__c == '1') {
            enTitle = 'Mr.';
        }
        else if(EmployeeBasic.Status_Marriage_EN_Title__c == '2') {
            enTitle = 'Mrs.';
        }
        else if(EmployeeBasic.Status_Marriage_EN_Title__c == '3') {
            enTitle = 'Miss';
        }
        else if(EmployeeBasic.Status_Marriage_EN_Title__c == '4') {
            enTitle = 'Ms.';
        }
        else if(EmployeeBasic.Status_Marriage_EN_Title__c == '5') {
            enTitle = 'Dr.';
        }
        
        EmployeeBasicTable.spousename = enTitle + ' ' + EmployeeBasic.Status_Marriage_EN_FN__c + ' ' + EmployeeBasic.Status_Marriage_EN_LN__c;
        if(string.isEmpty(EmployeeBasic.Status_Marriage_EN_FN__c)) {
            EmployeeBasicTable.spousename = '-';
        }
        
        EmployeeBasicTable.currentStatus = new ESS_Global.EnumValue('ApplicationStatus');
        if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Draft)) {
            EmployeeBasicTable.currentStatus.key = ESS_Enum.ApplicationStatus.Draft.name();
            EmployeeBasicTable.currentStatus.value = 'Draft';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Submitted)) {
            EmployeeBasicTable.currentStatus.key = ESS_Enum.ApplicationStatus.Submitted.name();
            EmployeeBasicTable.currentStatus.value = 'Submitted'; //WaitingToVerify
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Verified)) {
            EmployeeBasicTable.currentStatus.key = ESS_Enum.ApplicationStatus.Verified.name();
            EmployeeBasicTable.currentStatus.value = 'Verified';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Completed)) {
            EmployeeBasicTable.currentStatus.key = ESS_Enum.ApplicationStatus.Completed.name();
            EmployeeBasicTable.currentStatus.value = 'Completed';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Cancelled)) {
            EmployeeBasicTable.currentStatus.key = ESS_Enum.ApplicationStatus.Cancelled.name();
            EmployeeBasicTable.currentStatus.value = 'Cancelled';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Error)) {
            EmployeeBasicTable.currentStatus.key = ESS_Enum.ApplicationStatus.Error.name();
            EmployeeBasicTable.currentStatus.value = 'Error update in SAP';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.SendingToSAP)) {
            EmployeeBasicTable.currentStatus.key = ESS_Enum.ApplicationStatus.SendingToSAP.name();
            EmployeeBasicTable.currentStatus.value = 'Sending to SAP';
        }
        
        EmployeeBasicTable.createdDate = Date.ValueOf(EmployeeBasic.CreatedDate);
        EmployeeBasicTable.submittedDate = EmployeeBasic.Submitted_Date__c;
        EmployeeBasicTable.verifiedDate = EmployeeBasic.Verified_Date__c;
        EmployeeBasicTable.sendToBatchDate = EmployeeBasic.Verified_Date__c;
        EmployeeBasicTable.sendToSAPDate = Date.ValueOf(EmployeeBasic.Sending_to_SAP_Date__c);
        EmployeeBasicTable.updatedInSAPDate = EmployeeBasic.Completed_Date__c;
        EmployeeBasicTable.cancelledDate = EmployeeBasic.Cancelled_Date__c;
        EmployeeBasicTable.effectiveDate = EmployeeBasic.Effective_Date__c;
        EmployeeBasicTable.function = EmployeeBasic.Function__c;
        EmployeeBasicTable.department = EmployeeBasic.Department__c;
        EmployeeBasicTable.section = EmployeeBasic.Section__c;
        
        string unit = '';
        if(string.isNotBlank(EmployeeBasic.Unit__c)) {
            EmployeeBasicTable.unit = EmployeeBasic.Unit__c;
        }
        else {
            EmployeeBasicTable.unit = '';
        }
        
        
        return EmployeeBasicTable;
        
    }
    
}