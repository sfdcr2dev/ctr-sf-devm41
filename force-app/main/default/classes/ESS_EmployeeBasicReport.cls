/* Author Softever */
global with sharing class ESS_EmployeeBasicReport {

    private static List<ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO> employeeBasicTables;
    private static ESS_EmployeeBasicReport_DTO.EmployeeBasicGraphDTO employeeBasicGraph;
    
    static {
    }
    
    //EmployeeBasic
    @RemoteAction
    public static ESS_EmployeeBasicReport_DTO.EmployeeBasicGraphDTO GetEmployeeBasicGraph(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
        boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
        
        employeeBasicGraph = new ESS_EmployeeBasicReport_DTO.EmployeeBasicGraphDTO();
        
        List<ESS_Application__c> Applications = new List<ESS_Application__c>();
            
        string query = 'select id, document_no__c, company_name__c, subject_type__c, employee_id__c, employee_name__c, status_marriage_employee_id__c, status_marriage_en_title__c, Status_Marriage_EN_FN__c , Status_Marriage_EN_LN__c, ' +
            			'is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, effective_date__c, function__c, department__c, section__c, unit__c, Sending_to_SAP_Date__c from ESS_Application__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, company_name__c, subject_type__c, employee_id__c, employee_name__c, status_marriage_employee_id__c, status_marriage_en_title__c, Status_Marriage_EN_FN__c , Status_Marriage_EN_LN__c, ' +
            			'is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, effective_date__c, function__c, department__c, section__c, unit__c, Sending_to_SAP_Date__c from ESS_Application__c where OwnerId != null';
        } 
        
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
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
                query += ' subject_type__c = null';
            }
            query = query + ')';
            
        }
           
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.ApplicationStatus.Draft.name());
            statuses.add(ESS_Enum.ApplicationStatus.Submitted.name());
            statuses.add(ESS_Enum.ApplicationStatus.SendingToSAP.name());
            statuses.add(ESS_Enum.ApplicationStatus.Completed.name());
            statuses.add(ESS_Enum.ApplicationStatus.Cancelled.name());
            statuses.add(ESS_Enum.ApplicationStatus.Verified.name());
            statuses.add(ESS_Enum.ApplicationStatus.Error.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.statusDraft
            if(filter.statusDraft) {
            	statuses.add(ESS_Enum.ApplicationStatus.Draft.name());
            	isCheckStatus = true;
            }
            //filter.statusSubmitted
            if(filter.statusSubmitted) {
            	statuses.add(ESS_Enum.ApplicationStatus.Submitted.name());
            	isCheckStatus = true;
            }
            //filter.statusSendingToSAP
            if(filter.statusSendingToSAP) {
            	statuses.add(ESS_Enum.ApplicationStatus.SendingToSAP.name());
            	isCheckStatus = true;
            }
            //filter.statusVerified
            if(filter.statusVerified) {
            	statuses.add(ESS_Enum.ApplicationStatus.Verified.name());
            	isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.ApplicationStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.statusCancelled
            if(filter.statusCancelled) {
            	statuses.add(ESS_Enum.ApplicationStatus.Cancelled.name());
            	isCheckStatus = true;
            }
            //filter.statusError
            if(filter.statusError) {
            	statuses.add(ESS_Enum.ApplicationStatus.Error.name());
            	isCheckStatus = true;
            }
            
        }
        
        if(isCheckStatus) {
            query = query + ' AND status__c IN: statuses';
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
            date startCompletedDate = filter.startCompletedDate;
            query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = filter.endCompletedDate;
            query = query + ' AND (completed_date__c <=: endCompletedDate)';
        }
        
		//Final query
		Applications = Database.query(query); 
        
        if(Applications.size() > 0) {
            
            employeeBasicGraph.categories = new List<string> { 'Name', 'Status', 'Child', 'Death', 'Education', 'License', 'Address', 'Contact Person', 'Tax'};
            employeeBasicGraph.series = new List<ESS_EmployeeBasicReport_DTO.EmployeeBasicGraphSeriesDTO>();
            
            decimal percentTOPName = 0;
            integer totalTOPName = 0;
            decimal percentTOPStatus = 0;
            integer totalTOPStatus = 0;
            decimal percentTOPChild = 0;
            integer totalTOPChild = 0;
            decimal percentTOPDeath = 0;
            integer totalTOPDeath = 0;
            decimal percentTOPEducation = 0;
            integer totalTOPEducation = 0;
            decimal percentTOPLicense = 0;
            integer totalTOPLicense = 0;
            decimal percentTOPAddress = 0;
            integer totalTOPAddress = 0;
            decimal percentTOPContactPerson = 0;
            integer totalTOPContactPerson = 0;
            decimal percentTOPTax = 0;
            integer totalTOPTax = 0;
            
            decimal percentTESName = 0;
            integer totalTESName = 0;
            decimal percentTESStatus = 0;
            integer totalTESStatus = 0;
            decimal percentTESChild = 0;
            integer totalTESChild = 0;
            decimal percentTESDeath = 0;
            integer totalTESDeath = 0;
            decimal percentTESEducation = 0;
            integer totalTESEducation = 0;
            decimal percentTESLicense = 0;
            integer totalTESLicense = 0;
            decimal percentTESAddress = 0;
            integer totalTESAddress = 0;
            decimal percentTESContactPerson = 0;
            integer totalTESContactPerson = 0;
            decimal percentTESTax = 0;
            integer totalTESTax = 0;
            
            integer total = 0;
            
            ESS_EmployeeBasicReport_DTO.EmployeeBasicGraphSeriesDTO topSerie = new ESS_EmployeeBasicReport_DTO.EmployeeBasicGraphSeriesDTO();
            topSerie.type = 'column';
            topSerie.name = 'TOP';
            topSerie.data = new List<decimal>();
            topSerie.color = '#e99bd2';
            topSerie.custom = new List<integer>();
            
            ESS_EmployeeBasicReport_DTO.EmployeeBasicGraphSeriesDTO tesSerie = new ESS_EmployeeBasicReport_DTO.EmployeeBasicGraphSeriesDTO();
            tesSerie.type = 'column';
            tesSerie.name = 'TES';
            tesSerie.data = new List<decimal>();
            tesSerie.color = '#79a0fc';
            tesSerie.custom = new List<integer>();
            
            total = Applications.size();
            
            for(ESS_Application__c App : Applications) {
                
                if(App.Company_Name__c == 'TOP') {
                    
                    if(string.isNotEmpty(App.Status__c) && string.isNotEmpty(App.Subject_Type__c)) {
                        if(App.Subject_Type__c.contains('Name')) {
                            totalTOPName++;
                        }
                        else if(App.Subject_Type__c.contains('Status')) {
                            totalTOPStatus++;
                        }
                        else if(App.Subject_Type__c.contains('Child')) {
                            totalTOPChild++;
                        }
                        else if(App.Subject_Type__c.contains('Death')) {
                            totalTOPDeath++;
                        }
                        else if(App.Subject_Type__c.contains('Education')) {
                            totalTOPEducation++;
                        }
                        else if(App.Subject_Type__c.contains('License')) {
                            totalTOPLicense++;
                        }
                        else if(App.Subject_Type__c.contains('Address')) {
                            totalTOPAddress++;
                        }
                        else if(App.Subject_Type__c.contains('ContactPerson')) {
                            totalTOPContactPerson++;
                        }
                        else if(App.Subject_Type__c.contains('Tax')) {
                            totalTOPTax++;
                        }
                    }
                }
                else if(App.Company_Name__c == 'TES') {
                    
                    if(string.isNotEmpty(App.Status__c) && string.isNotEmpty(App.Subject_Type__c)) {
                        if(App.Subject_Type__c.contains('Name')) {
                            totalTESName++;
                        }
                        else if(App.Subject_Type__c.contains('Status')) {
                            totalTESStatus++;
                        }
                        else if(App.Subject_Type__c.contains('Child')) {
                            totalTESChild++;
                        }
                        else if(App.Subject_Type__c.contains('Death')) {
                            totalTESDeath++;
                        }
                        else if(App.Subject_Type__c.contains('Education')) {
                            totalTESEducation++;
                        }
                        else if(App.Subject_Type__c.contains('License')) {
                            totalTESLicense++;
                        }
                        else if(App.Subject_Type__c.contains('Address')) {
                            totalTESAddress++;
                        }
                        else if(App.Subject_Type__c.contains('ContactPerson')) {
                            totalTESContactPerson++;
                        }
                        else if(App.Subject_Type__c.contains('Tax')) {
                            totalTESTax++;
                        }
                    }
                }
                
            }
            
            if(total > 0) {
                percentTOPName = (totalTOPName * 100) / total;
                percentTOPStatus = (totalTOPStatus * 100) / total;
                percentTOPChild = (totalTOPChild * 100) / total;
                percentTOPDeath = (totalTOPDeath * 100) / total;
                percentTOPEducation = (totalTOPEducation * 100) / total;
                percentTOPLicense = (totalTOPLicense * 100) / total;
                percentTOPAddress = (totalTOPAddress * 100) / total;
                percentTOPContactPerson = (totalTOPContactPerson * 100) / total;
                percentTOPTax = (totalTOPTax * 100) / total;
                
                percentTESName = (totalTESName * 100) / total;
                percentTESStatus = (totalTESStatus * 100) / total;
                percentTESChild = (totalTESChild * 100) / total;
                percentTESDeath = (totalTESDeath * 100) / total;
                percentTESEducation = (totalTESEducation * 100) / total;
                percentTESLicense = (totalTESLicense * 100) / total;
                percentTESAddress = (totalTESAddress * 100) / total;
                percentTESContactPerson = (totalTESContactPerson * 100) / total;
                percentTESTax = (totalTESTax * 100) / total;
            }
            
            //TOP
            topSerie.data.add(percentTOPName);
            topSerie.data.add(percentTOPStatus);
            topSerie.data.add(percentTOPChild);
            topSerie.data.add(percentTOPDeath);
            topSerie.data.add(percentTOPEducation);
            topSerie.data.add(percentTOPLicense);
            topSerie.data.add(percentTOPAddress);
            topSerie.data.add(percentTOPContactPerson);
            topSerie.data.add(percentTOPTax);
            topSerie.custom.add(totalTOPName);
            topSerie.custom.add(totalTOPStatus);
            topSerie.custom.add(totalTOPChild);
            topSerie.custom.add(totalTOPDeath);
            topSerie.custom.add(totalTOPEducation);
            topSerie.custom.add(totalTOPLicense);
            topSerie.custom.add(totalTOPAddress);
            topSerie.custom.add(totalTOPContactPerson);
            topSerie.custom.add(totalTOPTax);
            
            //TES
            tesSerie.data.add(percentTESName);
            tesSerie.data.add(percentTESStatus);
            tesSerie.data.add(percentTESChild);
            tesSerie.data.add(percentTESDeath);
            tesSerie.data.add(percentTESEducation);
            tesSerie.data.add(percentTESLicense);
            tesSerie.data.add(percentTESAddress);
            tesSerie.data.add(percentTESContactPerson);
            tesSerie.data.add(percentTESTax);
            tesSerie.custom.add(totalTESName);
            tesSerie.custom.add(totalTESStatus);
            tesSerie.custom.add(totalTESChild);
            tesSerie.custom.add(totalTESDeath);
            tesSerie.custom.add(totalTESEducation);
            tesSerie.custom.add(totalTESLicense);
            tesSerie.custom.add(totalTESAddress);
            tesSerie.custom.add(totalTESContactPerson);
            tesSerie.custom.add(totalTESTax);
            
            employeeBasicGraph.series.add(topSerie);
            employeeBasicGraph.series.add(tesSerie);
            
        }
        
        return employeeBasicGraph;
        
    }
    
    @RemoteAction
    public static integer GetEmployeeBasicTableCount(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
            
        employeeBasicTables = new List<ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO>();
            
        List<ESS_Application__c> Applications = new List<ESS_Application__c>();
            
        string query = 'select id, document_no__c, subject_type__c, employee_id__c, employee_name__c, status_marriage_employee_id__c, status_marriage_en_title__c, Status_Marriage_EN_FN__c , Status_Marriage_EN_LN__c, ' +
            			'is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, effective_date__c, function__c, department__c, section__c, unit__c, sap_json__c, Sending_to_SAP_Date__c from ESS_Application__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, subject_type__c, employee_id__c, employee_name__c, status_marriage_employee_id__c, status_marriage_en_title__c, Status_Marriage_EN_FN__c , Status_Marriage_EN_LN__c, ' +
            			'is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, effective_date__c, function__c, department__c, section__c, unit__c, sap_json__c, Sending_to_SAP_Date__c from ESS_Application__c where OwnerId != null';
        } 
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
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
                query += ' subject_type__c = null';
            }
            query = query + ')';
            
        }
           
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.ApplicationStatus.Draft.name());
            statuses.add(ESS_Enum.ApplicationStatus.Submitted.name());
            statuses.add(ESS_Enum.ApplicationStatus.SendingToSAP.name());
            statuses.add(ESS_Enum.ApplicationStatus.Completed.name());
            statuses.add(ESS_Enum.ApplicationStatus.Cancelled.name());
            statuses.add(ESS_Enum.ApplicationStatus.Verified.name());
            statuses.add(ESS_Enum.ApplicationStatus.Error.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.statusDraft
            if(filter.statusDraft) {
            	statuses.add(ESS_Enum.ApplicationStatus.Draft.name());
            	isCheckStatus = true;
            }
            //filter.statusSubmitted
            if(filter.statusSubmitted) {
            	statuses.add(ESS_Enum.ApplicationStatus.Submitted.name());
            	isCheckStatus = true;
            }
            //filter.statusSendingToSAP
            if(filter.statusSendingToSAP) {
            	statuses.add(ESS_Enum.ApplicationStatus.SendingToSAP.name());
            	isCheckStatus = true;
            }
            //filter.statusVerified
            if(filter.statusVerified) {
            	statuses.add(ESS_Enum.ApplicationStatus.Verified.name());
            	isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.ApplicationStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.statusCancelled
            if(filter.statusCancelled) {
            	statuses.add(ESS_Enum.ApplicationStatus.Cancelled.name());
            	isCheckStatus = true;
            }
            //filter.statusErrror
            if(filter.statusError) {
            	statuses.add(ESS_Enum.ApplicationStatus.Error.name());
            	isCheckStatus = true;
            }
            
        }
        
        if(isCheckStatus) {
            query = query + ' AND status__c IN: statuses';
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
            date startCompletedDate = filter.startCompletedDate;
            query = query + ' AND (completed_date__c >=: startCompletedDate)';
        }
        
        //filter.endCompletedDate
        if(filter.endCompletedDate != null) {
            date endCompletedDate = filter.endCompletedDate;
            query = query + ' AND (completed_date__c <=: endCompletedDate)';
        }
        
		//Final query
		Applications = Database.query(query); 
        integer totalSize = 0;

        if(Applications.size() > 0) {
            for(ESS_Application__c Application : Applications) {
                ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO EmployeeBasicTable = new ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO();
                EmployeeBasicTable = assignToEmployeeBasicTableDTO(Application);
                totalSize++;
            }
        }

        return totalSize;
        
    }
    
    @RemoteAction
    public static List<ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO> GetEmployeeBasicTables(SearchCriteria filter,
        //documentNo, subjectType, employeeId, employeeName, spouseId, spouseName, currentStatus, createdDate, submittedDate, verifiedDate, sendToBatchDate, sendToSAPDate, completedDate, cancelledDate, effectiveDate, function, department, section, unit
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isAdmin = ESS_PrivilegeHandler.checkAdminUser(userId);
            
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        employeeBasicTables = new List<ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO>();
            
        List<ESS_Application__c> Applications = new List<ESS_Application__c>();
            
        string query = 'select id, document_no__c, subject_type__c, employee_id__c, employee_name__c, status_marriage_employee_id__c, status_marriage_en_title__c, Status_Marriage_EN_FN__c , Status_Marriage_EN_LN__c, ' +
            			'is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, effective_date__c, function__c, department__c, section__c, unit__c, sap_json__c, Sending_to_SAP_Date__c from ESS_Application__c where OwnerId =: userId';
        
        if(isAdmin) {
        	query = 'select id, document_no__c, subject_type__c, employee_id__c, employee_name__c, status_marriage_employee_id__c, status_marriage_en_title__c, Status_Marriage_EN_FN__c , Status_Marriage_EN_LN__c, ' +
            			'is_update_name__c, is_update_status__c, is_update_child__c, is_update_death__c, is_update_education__c, is_update_license__c, is_update_address__c, is_update_contactperson__c, is_update_tax__c, ' +
            			'status__c, createddate, submitted_date__c, verified_date__c, completed_date__c, cancelled_date__c, effective_date__c, function__c, department__c, section__c, unit__c, sap_json__c, Sending_to_SAP_Date__c from ESS_Application__c where OwnerId != null';
        } 
            
        //filter.employeeId
        if(string.isNotEmpty(filter.employeeId)) {
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
                query += ' subject_type__c = null';
            }
            query = query + ')';
            
        }
             
        //filter.statusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.statusAll) {
            statuses.add(ESS_Enum.ApplicationStatus.Draft.name());
            statuses.add(ESS_Enum.ApplicationStatus.Submitted.name());
            statuses.add(ESS_Enum.ApplicationStatus.SendingToSAP.name());
            statuses.add(ESS_Enum.ApplicationStatus.Completed.name());
            statuses.add(ESS_Enum.ApplicationStatus.Cancelled.name());
            statuses.add(ESS_Enum.ApplicationStatus.Verified.name());
            statuses.add(ESS_Enum.ApplicationStatus.Error.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.statusDraft
            if(filter.statusDraft) {
            	statuses.add(ESS_Enum.ApplicationStatus.Draft.name());
            	isCheckStatus = true;
            }
            //filter.statusSubmitted
            if(filter.statusSubmitted) {
            	statuses.add(ESS_Enum.ApplicationStatus.Submitted.name());
            	isCheckStatus = true;
            }
            //filter.statusSendingToSAP
            if(filter.statusSendingToSAP) {
            	statuses.add(ESS_Enum.ApplicationStatus.SendingToSAP.name());
            	isCheckStatus = true;
            }
            //filter.statusCompleted
            if(filter.statusCompleted) {
            	statuses.add(ESS_Enum.ApplicationStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.statusVerified
            if(filter.statusVerified) {
            	statuses.add(ESS_Enum.ApplicationStatus.Verified.name());
            	isCheckStatus = true;
            }
            //filter.statusCancelled
            if(filter.statusCancelled) {
            	statuses.add(ESS_Enum.ApplicationStatus.Cancelled.name());
            	isCheckStatus = true;
            }
            //filter.statusError
            if(filter.statusError) {
            	statuses.add(ESS_Enum.ApplicationStatus.Error.name());
            	isCheckStatus = true;
            }
            
        }
        
        if(isCheckStatus) {
            query = query + ' AND status__c IN: statuses';
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
        else if(sortByParam.sortBy == 'subjectType') {
            if(sortByParam.ascending) {
                query += ' order by subject_type__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by subject_type__c desc';
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
        else if(sortByParam.sortBy == 'spouseId') {
            if(sortByParam.ascending) {
                query += ' order by status_marriage_employee_id__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by status_marriage_employee_id__c desc';
            }
        }
        else if(sortByParam.sortBy == 'spouseName') {
            if(sortByParam.ascending) {
                query += ' order by status_marriage_en_fn__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by status_marriage_en_fn__c desc';
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
        else if(sortByParam.sortBy == 'verifiedDate') {
            if(sortByParam.ascending) {
                query += ' order by verified_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by verified_date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'sendToBatchDate') {
            if(sortByParam.ascending) {
                query += ' order by verified_date__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by verified_date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'sendToSAPDate') {
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
        else if(sortByParam.sortBy == 'updatedInSAPDate') {
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
                query +=' order by cancelled_date__c desc';
            }
        }
        else if(sortByParam.sortBy == 'effectiveDate') {
            if(sortByParam.ascending) {
                query += ' order by effective_date__c  asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by effective_date__c desc';
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
        else if(sortByParam.sortBy == 'function') {
            if(sortByParam.ascending) {
                query += ' order by function__c  asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by function__c desc';
            }
        }
        else if(sortByParam.sortBy == 'department') {
            if(sortByParam.ascending) {
                query += ' order by department__c  asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by department__c desc';
            }
        }
        else if(sortByParam.sortBy == 'section') {
            if(sortByParam.ascending) {
                query += ' order by section__c  asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by section__c desc';
            }
        }
        else if(sortByParam.sortBy == 'unit') {
            if(sortByParam.ascending) {
                query += + ' order by unit__c  asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by unit__c desc';
            }
        }
        else if(sortByParam.sortBy == 'sap') {
            if(sortByParam.ascending) {
                query += ' order by sap_json__c  asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by sap_json__c desc';
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
        
        Applications = database.query(query);
        for(ESS_Application__c Application : Applications) {
            ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO EmployeeBasicTable = new ESS_EmployeeBasicReport_DTO.EmployeeBasicTableDTO();
            EmployeeBasicTable = assignToEmployeeBasicTableDTO(Application);
            employeeBasicTables.add(EmployeeBasicTable);
        }
            
        return employeeBasicTables;
        
    }
    
    @RemoteAction
    public static string ExportEmployeeBasicExcel(SearchCriteria filter) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_EmployeeBasicReport_Excel?';
        
        string trackingReportType = 'EmployeeBasic';
        string employeeId = filter.employeeId;
        string companyName = filter.companyName;
        string function = filter.function;
        string department = filter.department;
        string section = filter.section;
        string unit = filter.unit;
        boolean searchAll = filter.searchAll;
        boolean searchName = filter.searchName;
        boolean searchStatus = filter.searchStatus;
        boolean searchChild = filter.searchChild;
        boolean searchDeath = filter.searchDeath;
        boolean searchEducation = filter.searchEducation;
        boolean searchLicense = filter.searchLicense;
        boolean searchAddress = filter.searchAddress;
        boolean searchContactPerson = filter.searchContactPerson;
        boolean searchTax = filter.searchTax;
        boolean statusAll = filter.statusAll;
        boolean statusDraft = filter.statusDraft;
        boolean statusSubmitted = filter.statusSubmitted;
        boolean statusSendingToSAP = filter.statusSendingToSAP;
        boolean statusCompleted = filter.statusCompleted;
        boolean statusVerified = filter.statusVerified;
        boolean statusCancelled = filter.statusCancelled;
        boolean statusError = filter.statusError;
        date startCreatedDate = filter.startCreatedDate;
        date endCreatedDate = filter.endCreatedDate;
        date startSubmittedDate = filter.startSubmittedDate;
        date endSubmittedDate = filter.endSubmittedDate;
        date startVerifiedDate = filter.startVerifiedDate;
        date endVerifiedDate = filter.endVerifiedDate;
        date startEffectiveDate = filter.startEffectiveDate;
        date endEffectiveDate = filter.endEffectiveDate;
        date startSendToBatchDate = filter.startSendToBatchDate;
        date endSendToBatchDate = filter.endSendToBatchDate;
        date startSendingToSAPDate = filter.startSendingToSAPDate;
        date endSendingToSAPDate = filter.endSendingToSAPDate;
        date startCompletedDate = filter.startCompletedDate;
        date endCompletedDate = filter.endCompletedDate;
        
        URL = URL + 'trackingReportType=' + trackingReportType + 
            		'&employeeId=' + employeeId + 
            		'&companyName=' + companyName + 
            		'&function=' + function + 
            		'&department=' + department + 
            		'&section=' + section +
            		'&unit=' + unit +  
            		'&searchAll=' + searchAll + 
            		'&searchName=' + searchName + 
            		'&searchStatus=' + searchStatus + 
            		'&searchChild=' + searchChild + 
            		'&searchDeath=' + searchDeath + 
            		'&searchEducation=' + searchEducation + 
            		'&searchLicense=' + searchLicense + 
            		'&searchAddress=' + searchAddress + 
            		'&searchContactPerson=' + searchContactPerson + 
            		'&searchTax=' + searchTax + 
            		'&statusAll=' + statusAll +
            		'&statusDraft=' + statusDraft +
            		'&statusSubmitted=' + statusSubmitted +
            		'&statusSendingToSAP=' + statusSendingToSAP + 
            		'&statusCompleted=' + statusCompleted +
            		'&statusVerified=' + statusVerified +
            		'&statusCancelled=' + statusCancelled +
            		'&statusError=' + statusError +
            		'&startCreatedDate=' + startCreatedDate +
            		'&endCreatedDate=' + endCreatedDate +
            		'&startSubmittedDate=' + startSubmittedDate +
            		'&endSubmittedDate=' + endSubmittedDate +
            		'&startVerifiedDate=' + startVerifiedDate +
            		'&endVerifiedDate=' + endVerifiedDate +
            		'&startEffectiveDate=' + startEffectiveDate +
            		'&endEffectiveDate=' + endEffectiveDate +
            		'&startSendToBatchDate=' + startSendToBatchDate +
            		'&endSendToBatchDate=' + endSendToBatchDate +
            		'&startSendingToSAPDate=' + startSendingToSAPDate +
            		'&endSendingToSAPDate=' + endSendingToSAPDate +
            		'&startCompletedDate=' + startCompletedDate +
            		'&endCompletedDate=' + endCompletedDate;
        
        return URL;
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
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.SendingToSAP)) {
            EmployeeBasicTable.currentStatus.key = ESS_Enum.ApplicationStatus.SendingToSAP.name();
            EmployeeBasicTable.currentStatus.value = 'Sending to SAP';
        }
        else if(EmployeeBasic.Status__c == String.ValueOf(ESS_Enum.ApplicationStatus.Error)) {
            EmployeeBasicTable.currentStatus.key = ESS_Enum.ApplicationStatus.Error.name();
            EmployeeBasicTable.currentStatus.value = 'Error update in SAP';
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
        
        EmployeeBasicTable.sap = EmployeeBasic.SAP_JSON__c;
        
    	return EmployeeBasicTable;
        
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
    
    public class SearchCriteria {
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string companyName {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
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
        public boolean statusAll {get;set;}
        @RemoteAction
        public boolean statusDraft {get;set;}
        @RemoteAction
        public boolean statusSubmitted {get;set;}
        @RemoteAction
        public boolean statusSendingToSAP {get;set;}
        @RemoteAction
        public boolean statusCompleted {get;set;}
        @RemoteAction
        public boolean statusVerified {get;set;}
        @RemoteAction
        public boolean statusCancelled {get;set;}
        @RemoteAction
        public boolean statusError {get;set;}
        @RemoteAction
        public date startCreatedDate {get;set;}
        @RemoteAction
        public date endCreatedDate {get;set;}
        @RemoteAction
        public date startSubmittedDate {get;set;}
        @RemoteAction
        public date endSubmittedDate {get;set;}
        @RemoteAction
        public date startVerifiedDate {get;set;}
        @RemoteAction
        public date endVerifiedDate {get;set;}
        @RemoteAction
        public date startEffectiveDate {get;set;}
        @RemoteAction
        public date endEffectiveDate {get;set;}
        @RemoteAction
        public date startSendToBatchDate {get;set;}
        @RemoteAction
        public date endSendToBatchDate {get;set;}
        @RemoteAction
        public date startSendingToSAPDate {get;set;}
        @RemoteAction
        public date endSendingToSAPDate {get;set;}
        @RemoteAction
        public date startCompletedDate {get;set;}
        @RemoteAction
        public date endCompletedDate {get;set;}
    }
    
}