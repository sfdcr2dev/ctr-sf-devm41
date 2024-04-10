/* Author Softever */
global with sharing class ESS_ManpowerReport {

    private static List<ESS_ManpowerReport_DTO.ManpowerReportTableDTO> manpowerReportTables;
    private static ESS_ManpowerReport_DTO.GraphDTO mspProgress;
    private static ESS_ManpowerReport_DTO.GraphDTO mspProgressByYear;
    private static ESS_ManpowerReport_DTO.GraphDTO mspProgressByTypeOfService;
    private static ESS_ManpowerReport_DTO.GraphDTO mspProgressByStatus;
    
    static {
        
    }
    
    @RemoteAction
    public static integer GetManpowerReportTableCount(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isPMBPAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isPEOCAdmin = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
         
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        string query = manpowerQuery();
        
        if(isPMBPAdmin || isPEOCAdmin) {
            
        	query = manpowerQuery();
        	query = query + ' where OwnerId != null';
        }
        else {
            query = query + ' where OwnerId =: userId';
        }
        
        //filter.typeOfServiceAll
        List<string> typeOfServices = new List<string>();
        boolean isCheckTypeOfService = false;
        if(filter.typeOfServiceAll) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            isCheckTypeOfService = true;
        }
        else {
            
            //filter.typeOfServicePermanent
            if(filter.typeOfServicePermanent) {
            	typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceTemporary
            if(filter.typeOfServiceTemporary) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceProjectBase
            if(filter.typeOfServiceProjectBase) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            	isCheckTypeOfService = true;
            }
            
        }
        
        if(isCheckTypeOfService) {
            query = query + ' AND type_of_service__c IN: typeOfServices';
        }
        
        //filter.currentStatusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.currentStatusAll) {
            statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.currentStatusDraft
            if(filter.currentStatusDraft) {
            	statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusInProgress
            if(filter.currentStatusInProgress) {
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCompleted
            if(filter.currentStatusCompleted) {
            	statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCancelled
            if(filter.currentStatusCancelled) {
            	statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
            query = query + ' AND status__c IN: statuses';
        }
        
        
        //filter.serviceForAll
        List<string> serviceFors = new List<string>();
        boolean isCheckServiceFor = false;
        if(filter.serviceForAll) {
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            isCheckServiceFor = true;
        }
        else {
            
            //filter.serviceForTOP
            if(filter.serviceForTOP) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTES
            if(filter.serviceForTES) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTLB
            if(filter.serviceForTLB) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTPX
            if(filter.serviceForTPX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForLABIX
            if(filter.serviceForLABIX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTET
            if(filter.serviceForTET) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPSPP
            if(filter.serviceForTOPSPP) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
                serviceFors.add('TOP SPP');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPNEXT
            if(filter.serviceForTOPNEXT) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
                serviceFors.add('TOP NEXT');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTTC
            if(filter.serviceForTTC) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            	isCheckServiceFor = true;
            }
        }
        
        if(isCheckServiceFor) {
            String value = '(\'' + String.join(serviceFors, '\',\'') + '\')';
            query = query + ' AND service_for__c includes ' + value;
        }
            
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        
        //filter.employeeName
        if(!string.isEmpty(filter.employeeName)) {
            string employeeName = '%' + filter.employeeName + '%';
            query = query + ' AND (requester_employee_id__c like: employeeName OR requester_name__c like: employeeName)';
        }
             
        //filter.objective
        if(string.isNotEmpty(filter.objective) && filter.objective.toLowerCase() != 'all') {
            string objective = filter.objective;
            query = query + ' AND objective__c =: objective';
        }
             
        //filter.projectName
        if(string.isNotEmpty(filter.projectName) && filter.projectName.toLowerCase() != 'all') {
            string projectName = filter.projectName;
            query = query + ' AND project__c =: projectName';
        }
             
        //filter.scopeOfServiceId
        if(string.isNotEmpty(filter.scopeOfServiceId)) {
            string scopeOfServiceId = filter.scopeOfServiceId;
            query = query + ' AND scope_of_service_id__c =: scopeOfServiceId';
        } 
            
        //filter.unit
        if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unit = filter.unit;
            query = query + ' AND unit__c =: unit';
        } 
            
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query = query + ' AND section__c =: section';
        }    
        
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
            string department = filter.department;
            query = query + ' AND department__c =: department';
        }
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
            string function = filter.function;
            query = query + ' AND function__c =: function';
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
        
        //filter.startCancelledDate
        if(filter.startCancelledDate != null) {
            date startCancelledDate = filter.startCancelledDate;
        	query += ' AND (cancelled_date__c >=: startCancelledDate)';
        }
        
        //filter.endCancelledDate
        if(filter.endCancelledDate != null) {
            date endCancelledDate = filter.endCancelledDate;
        	query += ' AND (cancelled_date__c <=: endCancelledDate)';
        }
        
		//Final query
		Manpowers = Database.query(query); 
        
        integer totalSize = 0;

        if(Manpowers.size() > 0) {
            
            for(ESS_Manpower__c Manpower : Manpowers) {
                ESS_ManpowerReport_DTO.ManpowerReportTableDTO ManpowerTable = new ESS_ManpowerReport_DTO.ManpowerReportTableDTO();
                ManpowerTable = assignToManpowerReportTableDTO(Manpower);
                if(string.isnotempty(ManpowerTable.documentNo)) {
                    totalSize++;
                }
            }
        }

        return totalSize;
        
    }
    
    @RemoteAction
    public static List<ESS_ManpowerReport_DTO.ManpowerReportTableDTO> GetManpowerReportTable(SearchCriteria filter, 
        //documentNo, typeOfService, objective, jobTitle, status, createdDate, submittedDate, requester, onBehalfOf
        ESS_Global.SortByParam sortByParam, 
        ESS_Global.PageParam pageParam) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isPMBPAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isPEOCAdmin = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
            
        if(pageParam == null) {
            pageParam = new ESS_Global.PageParam();
            pageParam.pageNo = 1;
            pageParam.pageSize = 1;
        }
            
        manpowerReportTables = new List<ESS_ManpowerReport_DTO.ManpowerReportTableDTO>();
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        string query = manpowerQuery();
        
        if(isPMBPAdmin || isPEOCAdmin) {
            
        	query = manpowerQuery();
        	query = query + ' where OwnerId != null';
        }
        else {
            query = query + ' where OwnerId =: userId';
        }
            
        
        
        //filter.typeOfServiceAll
        List<string> typeOfServices = new List<string>();
        boolean isCheckTypeOfService = false;
        if(filter.typeOfServiceAll) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            isCheckTypeOfService = true;
        }
        else {
            
            //filter.typeOfServicePermanent
            if(filter.typeOfServicePermanent) {
            	typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceTemporary
            if(filter.typeOfServiceTemporary) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceProjectBase
            if(filter.typeOfServiceProjectBase) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            	isCheckTypeOfService = true;
            }
            
        }
        
        if(isCheckTypeOfService) {
            query = query + ' AND type_of_service__c IN: typeOfServices';
        }
        
        //filter.currentStatusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.currentStatusAll) {
            statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.currentStatusDraft
            if(filter.currentStatusDraft) {
            	statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusInProgress
            if(filter.currentStatusInProgress) {
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCompleted
            if(filter.currentStatusCompleted) {
            	statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCancelled
            if(filter.currentStatusCancelled) {
            	statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
            query = query + ' AND status__c IN: statuses';
        }
        
        
        //filter.serviceForAll
        List<string> serviceFors = new List<string>();
        boolean isCheckServiceFor = false;
        if(filter.serviceForAll) {
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            isCheckServiceFor = true;
        }
        else {
            
            //filter.serviceForTOP
            if(filter.serviceForTOP) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTES
            if(filter.serviceForTES) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTLB
            if(filter.serviceForTLB) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTPX
            if(filter.serviceForTPX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForLABIX
            if(filter.serviceForLABIX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTET
            if(filter.serviceForTET) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPSPP
            if(filter.serviceForTOPSPP) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
                serviceFors.add('TOP SPP');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPNEXT
            if(filter.serviceForTOPNEXT) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
                serviceFors.add('TOP NEXT');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTTC
            if(filter.serviceForTTC) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            	isCheckServiceFor = true;
            }
        }
        
        if(isCheckServiceFor) {
            String value = '(\'' + String.join(serviceFors, '\',\'') + '\')';
            query = query + ' AND service_for__c includes ' + value;
        }
            
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        
        //filter.employeeName
        if(!string.isEmpty(filter.employeeName)) {
            string employeeName = '%' + filter.employeeName + '%';
            query = query + ' AND (requester_employee_id__c like: employeeName OR requester_name__c like: employeeName)';
        }
             
        //filter.objective
        if(string.isNotEmpty(filter.objective) && filter.objective.toLowerCase() != 'all') {
            string objective = filter.objective;
            query = query + ' AND objective__c =: objective';
        }
             
        //filter.projectName
        if(string.isNotEmpty(filter.projectName) && filter.projectName.toLowerCase() != 'all') {
            string projectName = filter.projectName;
            query = query + ' AND project__c =: projectName';
        }
             
        //filter.scopeOfServiceId
        if(string.isNotEmpty(filter.scopeOfServiceId)) {
            string scopeOfServiceId = filter.scopeOfServiceId;
            query = query + ' AND scope_of_service_id__c =: scopeOfServiceId';
        } 
            
        //filter.unit
        if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unit = filter.unit;
            query = query + ' AND unit__c =: unit';
        } 
            
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query = query + ' AND section__c =: section';
        }    
        
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
            string department = filter.department;
            query = query + ' AND department__c =: department';
        }
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
            string function = filter.function;
            query = query + ' AND function__c =: function';
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
        
        //filter.startCancelledDate
        if(filter.startCancelledDate != null) {
            date startCancelledDate = filter.startCancelledDate;
        	query += ' AND (cancelled_date__c >=: startCancelledDate)';
        }
        
        //filter.endCancelledDate
        if(filter.endCancelledDate != null) {
            date endCancelledDate = filter.endCancelledDate;
        	query += ' AND (cancelled_date__c <=: endCancelledDate)';
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
        else if(sortByParam.sortBy == 'typeOfService') {
            if(sortByParam.ascending) {
                query += ' order by type_of_service__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by type_of_service__c desc';
            }
        }
        else if(sortByParam.sortBy == 'objective') {
            if(sortByParam.ascending) {
                query += ' order by objective__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by objective__c desc';
            }
        }
        else if(sortByParam.sortBy == 'jobTitle') {
            if(sortByParam.ascending) {
                query += ' order by job__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by job__c desc';
            }
        }
        else if(sortByParam.sortBy == 'status') {
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
        else if(sortByParam.sortBy == 'requester') {
            if(sortByParam.ascending) {
                query += ' order by current_status__c asc';
            }
            else if(!sortByParam.ascending) {
                query += ' order by current_status__c desc';
            }
        }
        else {
        	query += ' order by document_no__c asc';        
        }
        
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
                ESS_ManpowerReport_DTO.ManpowerReportTableDTO ManpowerTable = new ESS_ManpowerReport_DTO.ManpowerReportTableDTO();
                ManpowerTable = assignToManpowerReportTableDTO(Manpower);
                if(string.isnotempty(ManpowerTable.documentNo)) {
                    manpowerReportTables.add(ManpowerTable);
                }
            }
        }

        return manpowerReportTables;
        
    }
    
    @RemoteAction
    public static ESS_ManpowerReport_DTO.GraphDTO GetMSPReportGraph(SearchCriteria filter, string groupingBy) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isPMBPAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isPEOCAdmin = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
          
        mspProgress = new ESS_ManpowerReport_DTO.GraphDTO();
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        string query = manpowerQuery();
        
        if(isPMBPAdmin || isPEOCAdmin) {
            
        	query = manpowerQuery();
        	query = query + ' where OwnerId != null';
        }
        else {
            query = query + ' where OwnerId =: userId';
        }
        
        //filter.typeOfServiceAll
        List<string> typeOfServices = new List<string>();
        boolean isCheckTypeOfService = false;
        if(filter.typeOfServiceAll) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            isCheckTypeOfService = true;
        }
        else {
            
            //filter.typeOfServicePermanent
            if(filter.typeOfServicePermanent) {
            	typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceTemporary
            if(filter.typeOfServiceTemporary) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceProjectBase
            if(filter.typeOfServiceProjectBase) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            	isCheckTypeOfService = true;
            }
            
        }
        
        if(isCheckTypeOfService) {
            query = query + ' AND type_of_service__c IN: typeOfServices';
        }
        
        //filter.currentStatusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.currentStatusAll) {
            statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.currentStatusDraft
            if(filter.currentStatusDraft) {
            	statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusInProgress
            if(filter.currentStatusInProgress) {
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCompleted
            if(filter.currentStatusCompleted) {
            	statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCancelled
            if(filter.currentStatusCancelled) {
            	statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
            query = query + ' AND status__c IN: statuses';
        }
        
        
        //filter.serviceForAll
        List<string> serviceFors = new List<string>();
        boolean isCheckServiceFor = false;
        if(filter.serviceForAll) {
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            isCheckServiceFor = true;
        }
        else {
            
            //filter.serviceForTOP
            if(filter.serviceForTOP) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTES
            if(filter.serviceForTES) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTLB
            if(filter.serviceForTLB) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTPX
            if(filter.serviceForTPX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForLABIX
            if(filter.serviceForLABIX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTET
            if(filter.serviceForTET) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPSPP
            if(filter.serviceForTOPSPP) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
                serviceFors.add('TOP SPP');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPNEXT
            if(filter.serviceForTOPNEXT) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
                serviceFors.add('TOP NEXT');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTTC
            if(filter.serviceForTTC) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            	isCheckServiceFor = true;
            }
        }
        
        if(isCheckServiceFor) {
            String value = '(\'' + String.join(serviceFors, '\',\'') + '\')';
            query = query + ' AND service_for__c includes ' + value;
        }
            
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        
        //filter.employeeName
        if(!string.isEmpty(filter.employeeName)) {
            string employeeName = '%' + filter.employeeName + '%';
            query = query + ' AND (requester_employee_id__c like: employeeName OR requester_name__c like: employeeName)';
        }
             
        //filter.objective
        if(string.isNotEmpty(filter.objective) && filter.objective.toLowerCase() != 'all') {
            string objective = filter.objective;
            query = query + ' AND objective__c =: objective';
        }
             
        //filter.projectName
        if(string.isNotEmpty(filter.projectName) && filter.projectName.toLowerCase() != 'all') {
            string projectName = filter.projectName;
            query = query + ' AND project__c =: projectName';
        }
             
        //filter.scopeOfServiceId
        if(string.isNotEmpty(filter.scopeOfServiceId)) {
            string scopeOfServiceId = filter.scopeOfServiceId;
            query = query + ' AND scope_of_service_id__c =: scopeOfServiceId';
        } 
            
        //filter.unit
        if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unit = filter.unit;
            query = query + ' AND unit__c =: unit';
        } 
            
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query = query + ' AND section__c =: section';
        }    
        
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
            string department = filter.department;
            query = query + ' AND department__c =: department';
        }
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
            string function = filter.function;
            query = query + ' AND function__c =: function';
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
        
        //filter.startCancelledDate
        if(filter.startCancelledDate != null) {
            date startCancelledDate = filter.startCancelledDate;
        	query += ' AND (cancelled_date__c >=: startCancelledDate)';
        }
        
        //filter.endCancelledDate
        if(filter.endCancelledDate != null) {
            date endCancelledDate = filter.endCancelledDate;
        	query += ' AND (cancelled_date__c <=: endCancelledDate)';
        }
        
		//Final query
		Manpowers = Database.query(query); 
        
        //After Filter then group by
        string groupByQuery = '';
        if(groupingBy == 'Function') {
			groupByQuery = 'select Function__c from ESS_Manpower__c where Function__c != \'\' ';
        }
        else if(groupingBy == 'Department') {
			groupByQuery = 'select Department__c from ESS_Manpower__c where Department__c != \'\' ';
        }
        
        if(Manpowers.size() > 0) {
            
            mspProgress.categories = new List<string>(); 
            mspProgress.series = new List<ESS_ManpowerReport_DTO.GraphSeriesDTO>();
            
            List<AggregateResult> AggregateResults = new List<AggregateResult>();
            
            //Draft
            ESS_ManpowerReport_DTO.GraphSeriesDTO draftSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            draftSerie.type = 'column';
            draftSerie.name = 'Draft';
            draftSerie.data = new List<Integer>();
            draftSerie.color = '#DBE6F2';
            mspProgress.series.add(draftSerie);
            
            //In Progress
            ESS_ManpowerReport_DTO.GraphSeriesDTO inProgressSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            inProgressSerie.type = 'column';
            inProgressSerie.name = 'In Progress';
            inProgressSerie.data = new List<Integer>();
            inProgressSerie.color = '#6BA9CB';
            mspProgress.series.add(inProgressSerie);
            
            //Completed
            ESS_ManpowerReport_DTO.GraphSeriesDTO completedSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            completedSerie.type = 'column';
            completedSerie.name = 'Completed';
            completedSerie.data = new List<Integer>();
            completedSerie.color = '#93CEA3';
            mspProgress.series.add(completedSerie);
            
            //Cancelled
            ESS_ManpowerReport_DTO.GraphSeriesDTO cancelledSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            cancelledSerie.type = 'column';
            cancelledSerie.name = 'Cancelled';
            cancelledSerie.data = new List<Integer>();
            cancelledSerie.color = '#FE9798';
            mspProgress.series.add(cancelledSerie);
            
            //Function
            if(groupingBy == 'Function') {
                
                List<string> Functions = new List<string>();
                Functions = ESSGlobal_GetFunctions();
                
                /* if(!string.isEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
                	Functions = ESSGlobal_GetFunctions(filter.function);
                }
                else {
                    Functions = ESSGlobal_GetFunctions(null);
                } */
                
            	integer totalFunctionCount = Functions.size();
                
                if(Functions.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Function__c order by Function__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer functionCount = 0;
                    
                    for(string currentFunction : Functions) {
                        
                        System.debug(currentFunction);
                        
                        integer totalFunction = 0;
                        
                        for(AggregateResult AR : AggregateResults) { 
                            
                            if(AR.get('Function__c') == currentFunction) {
                                
                                mspProgress.categories.add(currentFunction);
                                
                                totalFunction++;
                            
                                integer draftCount = 0;
                                integer inProgressCount = 0;
                                integer completedCount = 0;
                                integer cancelledCount = 0;
                                
                                string department = '';
                                
                                /* if(AR.get('Department__c') != null && AR.get('Department__c') != '') {
                                    department = AR.get('Department__c').toString();
                                } */
                                
                                for(ESS_Manpower__c Manpower : Manpowers) {
                                    
                                    if(Manpower.Function__c == currentFunction) {
                                        if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Draft)) {
                                            draftCount++;
                                        }
                                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved) ||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToSectionHead) ||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToVP) ||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToProjectManager) ||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAcknowledge)||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise)||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise)) {
                                            inProgressCount++;
                                        }
                                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Completed)) {
                                            completedCount++;
                                        }
                                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Cancelled)) {
                                            cancelledCount++;
                                        }
                                    }
                                }
                                
                                if(draftCount > 0) {
                                    mspProgress.series[0].data.add(draftCount);
                                }
                                if(inProgressCount > 0) {
                                    mspProgress.series[1].data.add(inProgressCount);
                                }
                                if(completedCount > 0) {
                                    mspProgress.series[2].data.add(completedCount);
                                }
                                if(cancelledCount > 0) {
                                    mspProgress.series[3].data.add(cancelledCount);
                                }
                                
                            }
                        }
                    }
                }
            }
            //Department
            else if(groupingBy == 'Department') {
                
                List<string> Departments = new List<string>(); 
                Departments = ESSGlobal_GetDepartments(null);
                
                /* if(!string.isEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
                    Departments = ESSGlobal_GetDepartments(filter.department);
                }
                else {
                    Departments = ESSGlobal_GetDepartments(null);
                } */
                
                
                if(Departments.size() > 0) {
                    
                    AggregateResults = new List<AggregateResult>();
                    string finalQuery = groupByQuery + ' group by Department__c, Section__c order by Department__c, Section__c asc';
                    AggregateResults = database.query(finalQuery);
                    
                    integer departmentCount = 0;
                    
                    for(string currentDepartment : Departments) {

                        integer totalDepartment = 0;
                        
                        for(AggregateResult AR : AggregateResults) { 
                            
                            if(AR.get('Department__c') == currentDepartment) {
                                
                                mspProgress.categories.add(currentDepartment);
                                
                                totalDepartment++;
                            
                                integer draftCount = 0;
                                integer inProgressCount = 0;
                                integer completedCount = 0;
                                integer cancelledCount = 0;
                                
                                string section = '';
                                
                                /* if(AR.get('Section__c') != null && AR.get('Section__c') != '') {
                                    section = AR.get('Section__c').toString();
                                } */
                                
                                for(ESS_Manpower__c Manpower : Manpowers) {
                                    
                                    if(Manpower.Department__c == currentDepartment) {
                                        if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Draft)) {
                                            draftCount++;
                                        }
                                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved) ||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToSectionHead) ||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToVP) ||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToProjectManager) ||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAcknowledge)||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise)||
                                               	Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise)) {
                                            inProgressCount++;
                                        }
                                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Completed)) {
                                            completedCount++;
                                        }
                                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Cancelled)) {
                                            cancelledCount++;
                                        }
                                    }
                                }
                                
                                if(draftCount > 0) {
                                    mspProgress.series[0].data.add(draftCount);
                                }
                                if(inProgressCount > 0) {
                                    mspProgress.series[1].data.add(inProgressCount);
                                }
                                if(completedCount > 0) {
                                    mspProgress.series[2].data.add(completedCount);
                                }
                                if(cancelledCount > 0) {
                                    mspProgress.series[3].data.add(cancelledCount);
                                }
                            }
                        }
                    }
                }
            } 
            
        }

        return mspProgress;
        
    }
    
    @RemoteAction
    public static ESS_ManpowerReport_DTO.GraphDTO GetMSPReportByYearGraph(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isPMBPAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isPEOCAdmin = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
          
        mspProgressByYear = new ESS_ManpowerReport_DTO.GraphDTO();
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        string query = manpowerQuery();
        
        if(isPMBPAdmin || isPEOCAdmin) {
        	query = manpowerQuery();
        	query = query + ' where OwnerId != null';
        }
        else {
            query = query + ' where OwnerId =: userId';
        }
        
        //filter.typeOfServiceAll
        List<string> typeOfServices = new List<string>();
        boolean isCheckTypeOfService = false;
        if(filter.typeOfServiceAll) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            isCheckTypeOfService = true;
        }
        else {
            
            //filter.typeOfServicePermanent
            if(filter.typeOfServicePermanent) {
            	typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceTemporary
            if(filter.typeOfServiceTemporary) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceProjectBase
            if(filter.typeOfServiceProjectBase) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            	isCheckTypeOfService = true;
            }
            
        }
        
        if(isCheckTypeOfService) {
            query = query + ' AND type_of_service__c IN: typeOfServices';
        }
        
        //filter.currentStatusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.currentStatusAll) {
            statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.currentStatusDraft
            if(filter.currentStatusDraft) {
            	statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusInProgress
            if(filter.currentStatusInProgress) {
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCompleted
            if(filter.currentStatusCompleted) {
            	statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCancelled
            if(filter.currentStatusCancelled) {
            	statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
            query = query + ' AND status__c IN: statuses';
        }
        
        //filter.serviceForAll
        List<string> serviceFors = new List<string>();
        boolean isCheckServiceFor = false;
        if(filter.serviceForAll) {
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            isCheckServiceFor = true;
        }
        else {
            
            //filter.serviceForTOP
            if(filter.serviceForTOP) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTES
            if(filter.serviceForTES) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTLB
            if(filter.serviceForTLB) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTPX
            if(filter.serviceForTPX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForLABIX
            if(filter.serviceForLABIX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTET
            if(filter.serviceForTET) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPSPP
            if(filter.serviceForTOPSPP) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
                serviceFors.add('TOP SPP');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPNEXT
            if(filter.serviceForTOPNEXT) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
                serviceFors.add('TOP NEXT');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTTC
            if(filter.serviceForTTC) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            	isCheckServiceFor = true;
            }
        }
        
        if(isCheckServiceFor) {
            String value = '(\'' + String.join(serviceFors, '\',\'') + '\')';
            query = query + ' AND service_for__c includes ' + value;
        }
            
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        
        //filter.employeeName
        if(!string.isEmpty(filter.employeeName)) {
            string employeeName = '%' + filter.employeeName + '%';
            query = query + ' AND (requester_employee_id__c like: employeeName OR requester_name__c like: employeeName)';
        }
             
        //filter.objective
        if(string.isNotEmpty(filter.objective) && filter.objective.toLowerCase() != 'all') {
            string objective = filter.objective;
            query = query + ' AND objective__c =: objective';
        }
             
        //filter.projectName
        if(string.isNotEmpty(filter.projectName) && filter.projectName.toLowerCase() != 'all') {
            string projectName = filter.projectName;
            query = query + ' AND project__c =: projectName';
        }
             
        //filter.scopeOfServiceId
        if(string.isNotEmpty(filter.scopeOfServiceId)) {
            string scopeOfServiceId = filter.scopeOfServiceId;
            query = query + ' AND scope_of_service_id__c =: scopeOfServiceId';
        } 
            
        //filter.unit
        if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unit = filter.unit;
            query = query + ' AND unit__c =: unit';
        } 
            
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query = query + ' AND section__c =: section';
        }    
        
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
            string department = filter.department;
            query = query + ' AND department__c =: department';
        }
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
            string function = filter.function;
            query = query + ' AND function__c =: function';
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
        
        //filter.startCancelledDate
        if(filter.startCancelledDate != null) {
            date startCancelledDate = filter.startCancelledDate;
        	query += ' AND (cancelled_date__c >=: startCancelledDate)';
        }
        
        //filter.endCancelledDate
        if(filter.endCancelledDate != null) {
            date endCancelledDate = filter.endCancelledDate;
        	query += ' AND (cancelled_date__c <=: endCancelledDate)';
        }
        
		//Final query
		Manpowers = Database.query(query);      
        if(Manpowers.size() > 0) {
            
            List<AggregateResult> Years = new List<AggregateResult>();
            string groupByQuery = 'select CALENDAR_YEAR(createddate) CurrentYear from ESS_Manpower__c group by CALENDAR_YEAR(createddate) order by CALENDAR_YEAR(createddate) asc';
            Years = database.query(groupByQuery);
            //Years = [select CALENDAR_YEAR(createddate) Year from ESS_Manpower__c group by CALENDAR_YEAR(createddate) order by CALENDAR_YEAR(createddate) asc]; //CALENDAR_YEAR(createddate)
            
            mspProgressByYear.categories = new List<string>(); 
            mspProgressByYear.series = new List<ESS_ManpowerReport_DTO.GraphSeriesDTO>();
            
            List<AggregateResult> AggregateResults = new List<AggregateResult>();
            
            //Draft
            ESS_ManpowerReport_DTO.GraphSeriesDTO draftSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            draftSerie.type = 'column';
            draftSerie.name = 'Draft';
            draftSerie.data = new List<Integer>();
            draftSerie.color = '#DBE6F2';
            mspProgressByYear.series.add(draftSerie);
            
            //In Progress
            ESS_ManpowerReport_DTO.GraphSeriesDTO inProgressSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            inProgressSerie.type = 'column';
            inProgressSerie.name = 'In Progress';
            inProgressSerie.data = new List<Integer>();
            inProgressSerie.color = '#6BA9CB';
            mspProgressByYear.series.add(inProgressSerie);
            
            //Completed
            ESS_ManpowerReport_DTO.GraphSeriesDTO completedSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            completedSerie.type = 'column';
            completedSerie.name = 'Completed';
            completedSerie.data = new List<Integer>();
            completedSerie.color = '#93CEA3';
            mspProgressByYear.series.add(completedSerie);
            
            //Cancelled
            ESS_ManpowerReport_DTO.GraphSeriesDTO cancelledSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            cancelledSerie.type = 'column';
            cancelledSerie.name = 'Canceleed';
            cancelledSerie.data = new List<Integer>();
            cancelledSerie.color = '#FE9798';
            mspProgressByYear.series.add(cancelledSerie);
            
            for(AggregateResult AR : Years) {
                
                integer existYear = Integer.ValueOf(AR.get('CurrentYear'));
                integer draftCount = 0;
                integer inProgressCount = 0;
                integer completedCount = 0;
                integer cancelledCount = 0;
                
                boolean yearExist = false;
                
                for(ESS_Manpower__c Manpower : Manpowers) {
                
                    if(Manpower.Year__c == String.ValueOf(existYear)) {
                        
                        yearExist = true;
                        
                        if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Draft)) {
                            draftCount++;
                        }
                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved) ||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToSectionHead) ||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToVP) ||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToProjectManager) ||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAcknowledge)||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise)||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise)) {
                                    inProgressCount++;
                                }
                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Completed)) {
                            completedCount++;
                        }
                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Cancelled)) {
                            cancelledCount++;
                        }
                    }
            	}
                
                if(yearExist) {
                    mspProgressByYear.categories.add(String.ValueOf(existYear));
                    
                    if(draftCount > 0) {
                        mspProgressByYear.series[0].data.add(draftCount);
                    }
                    if(inProgressCount > 0) {
                        mspProgressByYear.series[1].data.add(inProgressCount);
                    }
                    if(completedCount > 0) {
                        mspProgressByYear.series[2].data.add(completedCount);
                    }
                    if(cancelledCount > 0) {
                        mspProgressByYear.series[3].data.add(cancelledCount);
                    }
                }
            }
            
        }

        return mspProgressByYear;
        
    }
    
    @RemoteAction
    public static ESS_ManpowerReport_DTO.GraphDTO GetMSPReportByTypeOfServiceGraph(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isPMBPAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isPEOCAdmin = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
          
        mspProgressByTypeOfService = new ESS_ManpowerReport_DTO.GraphDTO();
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        string query = manpowerQuery();
        
        if(isPMBPAdmin || isPEOCAdmin) {
            
        	query = manpowerQuery();
        	query = query + ' where OwnerId != null';
        }
        else {
            query = query + ' where OwnerId =: userId';
        }
        
        //filter.typeOfServiceAll
        List<string> typeOfServices = new List<string>();
        boolean isCheckTypeOfService = false;
        if(filter.typeOfServiceAll) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            isCheckTypeOfService = true;
        }
        else {
            
            //filter.typeOfServicePermanent
            if(filter.typeOfServicePermanent) {
            	typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceTemporary
            if(filter.typeOfServiceTemporary) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceProjectBase
            if(filter.typeOfServiceProjectBase) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            	isCheckTypeOfService = true;
            }
            
        }
        
        if(isCheckTypeOfService) {
            query = query + ' AND type_of_service__c IN: typeOfServices';
        }
        
        //filter.currentStatusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.currentStatusAll) {
            statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.currentStatusDraft
            if(filter.currentStatusDraft) {
            	statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusInProgress
            if(filter.currentStatusInProgress) {
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCompleted
            if(filter.currentStatusCompleted) {
            	statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCancelled
            if(filter.currentStatusCancelled) {
            	statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
            query = query + ' AND status__c IN: statuses';
        }
        
        //filter.serviceForAll
        List<string> serviceFors = new List<string>();
        boolean isCheckServiceFor = false;
        if(filter.serviceForAll) {
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            isCheckServiceFor = true;
        }
        else {
            
            //filter.serviceForTOP
            if(filter.serviceForTOP) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTES
            if(filter.serviceForTES) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTLB
            if(filter.serviceForTLB) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTPX
            if(filter.serviceForTPX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForLABIX
            if(filter.serviceForLABIX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTET
            if(filter.serviceForTET) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPSPP
            if(filter.serviceForTOPSPP) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
                serviceFors.add('TOP SPP');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPNEXT
            if(filter.serviceForTOPNEXT) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
                serviceFors.add('TOP NEXT');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTTC
            if(filter.serviceForTTC) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            	isCheckServiceFor = true;
            }
        }
        
        if(isCheckServiceFor) {
            String value = '(\'' + String.join(serviceFors, '\',\'') + '\')';
            query = query + ' AND service_for__c includes ' + value;
        }
        
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        
        //filter.employeeName
        if(!string.isEmpty(filter.employeeName)) {
            string employeeName = '%' + filter.employeeName + '%';
            query = query + ' AND (requester_employee_id__c like: employeeName OR requester_name__c like: employeeName)';
        }
             
        //filter.objective
        if(string.isNotEmpty(filter.objective) && filter.objective.toLowerCase() != 'all') {
            string objective = filter.objective;
            query = query + ' AND objective__c =: objective';
        }
             
        //filter.projectName
        if(string.isNotEmpty(filter.projectName) && filter.projectName.toLowerCase() != 'all') {
            string projectName = filter.projectName;
            query = query + ' AND project__c =: projectName';
        }
             
        //filter.scopeOfServiceId
        if(string.isNotEmpty(filter.scopeOfServiceId)) {
            string scopeOfServiceId = filter.scopeOfServiceId;
            query = query + ' AND scope_of_service_id__c =: scopeOfServiceId';
        } 
            
        //filter.unit
        if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unit = filter.unit;
            query = query + ' AND unit__c =: unit';
        } 
            
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query = query + ' AND section__c =: section';
        }    
        
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
            string department = filter.department;
            query = query + ' AND department__c =: department';
        }
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
            string function = filter.function;
            query = query + ' AND function__c =: function';
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
        
        //filter.startCancelledDate
        if(filter.startCancelledDate != null) {
            date startCancelledDate = filter.startCancelledDate;
        	query += ' AND (cancelled_date__c >=: startCancelledDate)';
        }
        
        //filter.endCancelledDate
        if(filter.endCancelledDate != null) {
            date endCancelledDate = filter.endCancelledDate;
        	query += ' AND (cancelled_date__c <=: endCancelledDate)';
        }
        
		//Final query
		Manpowers = Database.query(query); 
                
        if(Manpowers.size() > 0) {
            
            List<AggregateResult> ARTypeOfServices = new List<AggregateResult>();
            ARTypeOfServices = [select Type_Of_Service__c from ESS_Manpower__c group by Type_Of_Service__c order by Type_Of_Service__c asc]; 
            
            mspProgressByTypeOfService.categories = new List<string>(); 
            mspProgressByTypeOfService.series = new List<ESS_ManpowerReport_DTO.GraphSeriesDTO>();
            
            List<AggregateResult> AggregateResults = new List<AggregateResult>();
            
            //Draft
            ESS_ManpowerReport_DTO.GraphSeriesDTO draftSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            draftSerie.type = 'column';
            draftSerie.name = 'Draft';
            draftSerie.data = new List<Integer>();
            draftSerie.color = '#DBE6F2';
            mspProgressByTypeOfService.series.add(draftSerie);
            
            //In Progress
            ESS_ManpowerReport_DTO.GraphSeriesDTO inProgressSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            inProgressSerie.type = 'column';
            inProgressSerie.name = 'In Progress';
            inProgressSerie.data = new List<Integer>();
            inProgressSerie.color = '#6BA9CB';
            mspProgressByTypeOfService.series.add(inProgressSerie);
            
            //Completed
            ESS_ManpowerReport_DTO.GraphSeriesDTO completedSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            completedSerie.type = 'column';
            completedSerie.name = 'Completed';
            completedSerie.data = new List<Integer>();
            completedSerie.color = '#93CEA3';
            mspProgressByTypeOfService.series.add(completedSerie);
            
            //Cancelled
            ESS_ManpowerReport_DTO.GraphSeriesDTO cancelledSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            cancelledSerie.type = 'column';
            cancelledSerie.name = 'Cancelled';
            cancelledSerie.data = new List<Integer>();
            cancelledSerie.color = '#FE9798';
            mspProgressByTypeOfService.series.add(cancelledSerie);
            
            for(AggregateResult AR : ARTypeOfServices) {
                
                string typeOfService = String.ValueOf(AR.get('Type_Of_Service__c'));
                
                mspProgressByTypeOfService.categories.add(typeOfService);
                
                integer draftCount = 0;
                integer inProgressCount = 0;
                integer completedCount = 0;
                integer cancelledCount = 0;
                          
                for(ESS_Manpower__c Manpower : Manpowers) {
                
                    if(Manpower.Type_of_Service__c == typeOfService) {
                        
                        if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Draft)) {
                            draftCount++;
                        }
                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved) ||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToSectionHead) ||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToVP) ||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToProjectManager) ||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAcknowledge)||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise)||
                                Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise)) {
                                    inProgressCount++;
                                }
                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Completed)) {
                            completedCount++;
                        }
                        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Cancelled)) {
                            cancelledCount++;
                        }
                        
                    }
                    
            	}
                
                if(draftCount > 0) {
                    mspProgressByTypeOfService.series[0].data.add(draftCount);
                }
                if(inProgressCount > 0) {
                    mspProgressByTypeOfService.series[1].data.add(inProgressCount);
                }
                if(completedCount > 0) {
                    mspProgressByTypeOfService.series[2].data.add(completedCount);
                }
                if(cancelledCount > 0) {
                    mspProgressByTypeOfService.series[3].data.add(cancelledCount);
                }
            }
            
        }

        return mspProgressByTypeOfService;
        
    }
    
    @RemoteAction
    public static ESS_ManpowerReport_DTO.GraphDTO GetMSPReportByStatusGraph(SearchCriteria filter) {
        
        string userId = ESS_PrivilegeHandler.getUserId();
            
        boolean isPMBPAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isPEOCAdmin = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
          
        mspProgressByStatus = new ESS_ManpowerReport_DTO.GraphDTO();
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        
        string query = manpowerQuery();
        
        if(isPMBPAdmin || isPEOCAdmin) {
            
        	query = manpowerQuery();
        	query = query + ' where OwnerId != null';
        }
        else {
            query = query + ' where OwnerId =: userId';
        }
        
        //filter.typeOfServiceAll
        List<string> typeOfServices = new List<string>();
        boolean isCheckTypeOfService = false;
        if(filter.typeOfServiceAll) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            isCheckTypeOfService = true;
        }
        else {
            
            //filter.typeOfServicePermanent
            if(filter.typeOfServicePermanent) {
            	typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Permanent.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceTemporary
            if(filter.typeOfServiceTemporary) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.Temporary.name());
            	isCheckTypeOfService = true;
            }
            //filter.typeOfServiceProjectBase
            if(filter.typeOfServiceProjectBase) {
            typeOfServices.add(ESS_Enum.ManpowerTypeOfService.ProjectBase.name());
            	isCheckTypeOfService = true;
            }
            
        }
        
        if(isCheckTypeOfService) {
            query = query + ' AND type_of_service__c IN: typeOfServices';
        }
        
        //filter.currentStatusAll
        List<string> statuses = new List<string>();
        boolean isCheckStatus = false;
        if(filter.currentStatusAll) {
            statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            isCheckStatus = true;
        }
        else {
            
            //filter.currentStatusDraft
            if(filter.currentStatusDraft) {
            	statuses.add(ESS_Enum.ManpowerStatus.Draft.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusInProgress
            if(filter.currentStatusInProgress) {
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToVP.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
                statuses.add(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCompleted
            if(filter.currentStatusCompleted) {
            	statuses.add(ESS_Enum.ManpowerStatus.Completed.name());
            	isCheckStatus = true;
            }
            //filter.currentStatusCancelled
            if(filter.currentStatusCancelled) {
            	statuses.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            	isCheckStatus = true;
            }
        }
        
        if(isCheckStatus) {
            query = query + ' AND status__c IN: statuses';
        }
        
        //filter.serviceForAll
        List<string> serviceFors = new List<string>();
        boolean isCheckServiceFor = false;
        if(filter.serviceForAll) {
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
            serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            isCheckServiceFor = true;
        }
        else {
            
            //filter.serviceForTOP
            if(filter.serviceForTOP) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TOP.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTES
            if(filter.serviceForTES) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TES.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTLB
            if(filter.serviceForTLB) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TLB.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTPX
            if(filter.serviceForTPX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TPX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForLABIX
            if(filter.serviceForLABIX) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.LABIX.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTET
            if(filter.serviceForTET) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TET.name());
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPSPP
            if(filter.serviceForTOPSPP) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPSPP.name());
                serviceFors.add('TOP SPP');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTOPNEXT
            if(filter.serviceForTOPNEXT) {
            	//serviceFors.add(ESS_Enum.ManpowerServiceFor.TOPNEXT.name());
                serviceFors.add('TOP NEXT');
            	isCheckServiceFor = true;
            }
            //filter.serviceForTTC
            if(filter.serviceForTTC) {
            	serviceFors.add(ESS_Enum.ManpowerServiceFor.TTC.name());
            	isCheckServiceFor = true;
            }
        }
        
        if(isCheckServiceFor) {
            String value = '(\'' + String.join(serviceFors, '\',\'') + '\')';
            query = query + ' AND service_for__c includes ' + value;
        }
            
        //filter.documentNo
        if(!string.isEmpty(filter.documentNo)) {
            string documentNo = '%' + filter.documentNo + '%';
            query = query + ' AND document_no__c like: documentNo';
        }
        
        //filter.employeeName
        if(!string.isEmpty(filter.employeeName)) {
            string employeeName = '%' + filter.employeeName + '%';
            query = query + ' AND (requester_employee_id__c like: employeeName OR requester_name__c like: employeeName)';
        }
             
        //filter.objective
        if(string.isNotEmpty(filter.objective) && filter.objective.toLowerCase() != 'all') {
            string objective = filter.objective;
            query = query + ' AND objective__c =: objective';
        }
             
        //filter.projectName
        if(string.isNotEmpty(filter.projectName) && filter.projectName.toLowerCase() != 'all') {
            string projectName = filter.projectName;
            query = query + ' AND project__c =: projectName';
        }
             
        //filter.scopeOfServiceId
        if(string.isNotEmpty(filter.scopeOfServiceId)) {
            string scopeOfServiceId = filter.scopeOfServiceId;
            query = query + ' AND scope_of_service_id__c =: scopeOfServiceId';
        } 
            
        //filter.unit
        if(string.isNotEmpty(filter.unit) && filter.unit.toLowerCase() != 'all') {
            string unit = filter.unit;
            query = query + ' AND unit__c =: unit';
        } 
            
        //filter.section
        if(string.isNotEmpty(filter.section) && filter.section.toLowerCase() != 'all') {
            string section = filter.section;
            query = query + ' AND section__c =: section';
        }    
        
        //filter.department
        if(string.isNotEmpty(filter.department) && filter.department.toLowerCase() != 'all') {
            string department = filter.department;
            query = query + ' AND department__c =: department';
        }
        
        //filter.function
        if(string.isNotEmpty(filter.function) && filter.function.toLowerCase() != 'all') {
            string function = filter.function;
            query = query + ' AND function__c =: function';
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
        
        //filter.startCancelledDate
        if(filter.startCancelledDate != null) {
            date startCancelledDate = filter.startCancelledDate;
        	query += ' AND (cancelled_date__c >=: startCancelledDate)';
        }
        
        //filter.endCancelledDate
        if(filter.endCancelledDate != null) {
            date endCancelledDate = filter.endCancelledDate;
        	query += ' AND (cancelled_date__c <=: endCancelledDate)';
        }
        
		//Final query
		Manpowers = Database.query(query); 
                
        if(Manpowers.size() > 0) {
            
            mspProgressByStatus.categories = new List<string>(); 
            mspProgressByStatus.series = new List<ESS_ManpowerReport_DTO.GraphSeriesDTO>();
            
            //Draft
            mspProgressByStatus.categories.add(ESS_Enum.ManpowerStatus.Draft.name());
            ESS_ManpowerReport_DTO.GraphSeriesDTO draftSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            draftSerie.type = 'column';
            draftSerie.name = 'Draft';
            draftSerie.data = new List<Integer>();
            draftSerie.color = '#DBE6F2';
            mspProgressByStatus.series.add(draftSerie);
            
            //In Progress
            mspProgressByStatus.categories.add('In Progress');
            ESS_ManpowerReport_DTO.GraphSeriesDTO inProgressSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            inProgressSerie.type = 'column';
            inProgressSerie.name = 'In Progress';
            inProgressSerie.data = new List<Integer>();
            inProgressSerie.color = '#6BA9CB';
            mspProgressByStatus.series.add(inProgressSerie);
            
            //Completed
            mspProgressByStatus.categories.add(ESS_Enum.ManpowerStatus.Completed.name());
            ESS_ManpowerReport_DTO.GraphSeriesDTO completedSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            completedSerie.type = 'column';
            completedSerie.name = 'Completed';
            completedSerie.data = new List<Integer>();
            completedSerie.color = '#93CEA3';
            mspProgressByStatus.series.add(completedSerie);
            
            //Cancelled
            mspProgressByStatus.categories.add(ESS_Enum.ManpowerStatus.Cancelled.name());
            ESS_ManpowerReport_DTO.GraphSeriesDTO cancelledSerie = new ESS_ManpowerReport_DTO.GraphSeriesDTO();
            cancelledSerie.type = 'column';
            cancelledSerie.name = 'Cancelled';
            cancelledSerie.data = new List<Integer>();
            cancelledSerie.color = '#FE9798';
            mspProgressByStatus.series.add(cancelledSerie);
            
                
            integer draftCount = 0;
            integer inProgressCount = 0;
            integer completedCount = 0;
            integer cancelledCount = 0;
            
            for(ESS_Manpower__c Manpower : Manpowers) {
                
                if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Draft)) {
                    draftCount++;
                }
                else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved) ||
                        Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToSectionHead) ||
                        Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToVP) ||
                        Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToProjectManager) ||
                        Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAcknowledge)||
                        Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise)||
                        Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise)) {
                            inProgressCount++;
                        }
                else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Completed)) {
                    completedCount++;
                }
                else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Cancelled)) {
                    cancelledCount++;
                }
            }
            
            if(draftCount > 0) {
                mspProgressByStatus.series[0].data.add(draftCount);
            }
            if(inProgressCount > 0) {
                mspProgressByStatus.series[1].data.add(inProgressCount);
            }
            if(completedCount > 0) {
                mspProgressByStatus.series[2].data.add(completedCount);
            }
            if(cancelledCount > 0) {
                mspProgressByStatus.series[3].data.add(cancelledCount);
            }
        }

        return mspProgressByStatus;
        
    }
    
    @RemoteAction
    public static string ExportManpowerReportExcel(SearchCriteria filter) {
        
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/ESS_ManpowerReport_Excel?';
        boolean typeOfServiceAll = filter.typeOfServiceAll;
        boolean typeOfServicePermanent = filter.typeOfServicePermanent;
        boolean typeOfServiceTemporary = filter.typeOfServiceTemporary;
        boolean typeOfServiceProjectBase = filter.typeOfServiceProjectBase;
        boolean currentStatusAll = filter.currentStatusAll;
        boolean currentStatusDraft = filter.currentStatusDraft;
        boolean currentStatusInProgress = filter.currentStatusInProgress;
        boolean currentStatusCompleted = filter.currentStatusCompleted;
        boolean currentStatusCancelled = filter.currentStatusCancelled;
        boolean serviceForAll = filter.serviceForAll;
        boolean serviceForTOP = filter.serviceForTOP;
        boolean serviceForTES = filter.serviceForTES;
        boolean serviceForTLB = filter.serviceForTLB;
        boolean serviceForTPX = filter.serviceForTPX;
        boolean serviceForLABIX = filter.serviceForLABIX;
        boolean serviceForTET = filter.serviceForTET;
        boolean serviceForTOPSPP = filter.serviceForTOPSPP;
        boolean serviceForTOPNEXT = filter.serviceForTOPNEXT;
        boolean serviceForTTC = filter.serviceForTTC;
        string documentNo = filter.documentNo;
        string employeeName = filter.employeeName;
        string objective = filter.objective;
        string projectName = filter.projectName;
        string scopeOfServiceId = filter.scopeOfServiceId;
        string unit = filter.unit;
        string section = filter.section;
        string department = filter.department;
        string function = filter.function;
        date startCreatedDate = filter.startCreatedDate;
        date endCreatedDate = filter.endCreatedDate;
        date startSubmittedDate = filter.startSubmittedDate;
        date endSubmittedDate = filter.endSubmittedDate;
        date startCompletedDate = filter.startCompletedDate;
        date endCompletedDate = filter.endCompletedDate;
        date startCancelledDate = filter.startCancelledDate;
        date endCancelledDate = filter.endCancelledDate;
        
        URL = URL + 'typeOfServiceAll=' + typeOfServiceAll + 
            		'&typeOfServicePermanent=' + typeOfServicePermanent + 
            		'&typeOfServiceTemporary=' + typeOfServiceTemporary + 
            		'&typeOfServiceProjectBase=' + typeOfServiceProjectBase + 
            		'&currentStatusAll=' + currentStatusAll + 
            		'&currentStatusDraft=' + currentStatusDraft + 
            		'&currentStatusInProgress=' + currentStatusInProgress + 
            		'&currentStatusCompleted=' + currentStatusCompleted + 
            		'&currentStatusCancelled=' + currentStatusCancelled + 
            		'&serviceForAll=' + serviceForAll + 
            		'&serviceForTOP=' + serviceForTOP + 
            		'&serviceForTES=' + serviceForTES + 
            		'&serviceForTLB=' + serviceForTLB + 
            		'&serviceForTPX=' + serviceForTPX + 
            		'&serviceForLABIX=' + serviceForLABIX + 
            		'&serviceForTET=' + serviceForTET + 
            		'&serviceForTOPSPP=' + serviceForTOPSPP + 
            		'&serviceForTOPNEXT=' + serviceForTOPNEXT + 
            		'&serviceForTTC=' + serviceForTTC + 
            		'&documentNo=' + documentNo + 
            		'&employeeName=' + employeeName + 
            		'&objective=' + objective + 
            		'&projectName=' + projectName + 
            		'&scopeOfServiceId=' + scopeOfServiceId + 
            		'&unit=' + unit + 
            		'&section=' + section + 
            		'&department=' + department + 
            		'&function=' + function + 
            		'&startCreatedDate=' + startCreatedDate + 
            		'&endCreatedDate=' + endCreatedDate + 
            		'&startSubmittedDate=' + startSubmittedDate + 
            		'&endSubmittedDate=' + endSubmittedDate + 
            		'&startCompletedDate=' + startCompletedDate + 
            		'&endCompletedDate=' + endCompletedDate + 
            		'&startCancelledDate=' + startCancelledDate + 
            		'&endCancelledDate=' + endCancelledDate;
            
        return URL;
        
    }
    
    //Assign to DTO section
    public static ESS_ManpowerReport_DTO.ManpowerReportTableDTO assignToManpowerReportTableDTO(ESS_Manpower__c Manpower) {
    
        ESS_ManpowerReport_DTO.ManpowerReportTableDTO ManpowerTable = new ESS_ManpowerReport_DTO.ManpowerReportTableDTO();
        ManpowerTable.recordId = Manpower.Id;
        ManpowerTable.documentNo = Manpower.Document_No__c;
        
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
            ManpowerTable.typeOfService.value = 'Project Base';
        }
        
        ManpowerTable.objective = new ESS_Global.EnumValue('ManpowerObjective');
        if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.ReplaceOldPosition)) {
            ManpowerTable.objective.key = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
            ManpowerTable.objective.value = 'ทดแทนตำแหน่งงานเดิม';
        }
        else if(Manpower.Objective__c == String.ValueOf(ESS_Enum.ManpowerObjective.AddOldPosition)) {
            ManpowerTable.objective.key = ESS_Enum.ManpowerObjective.AddOldPosition.name();
            ManpowerTable.objective.value = 'เพิ่มในตำแหน่งงานเดิม';
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
        
        ManpowerTable.currentStatus = new ESS_Global.EnumValue('ManpowerStatus');
        if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Draft)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.Draft.name();
            ManpowerTable.currentStatus.value = 'Draft';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
            ManpowerTable.currentStatus.value = 'Waiting to Employee Approved';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToSectionHead)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            ManpowerTable.currentStatus.value = 'Waiting to Section Head';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToVP)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.WaitingToVP.name();
            ManpowerTable.currentStatus.value = 'Waiting to VP';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToProjectManager)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.WaitingToProjectManager.name();
            ManpowerTable.currentStatus.value = 'Waiting to Project Manager';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAcknowledge)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
            ManpowerTable.currentStatus.value = 'Waiting to Acknowledge';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Completed)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.Completed.name();
            ManpowerTable.currentStatus.value = 'Completed';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
            ManpowerTable.currentStatus.value = 'Waiting to Employee Revise';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
            ManpowerTable.currentStatus.value = 'Waiting to Employee Admin Revise';
        }
        else if(Manpower.Status__c == String.ValueOf(ESS_Enum.ManpowerStatus.Cancelled)) {
            ManpowerTable.currentStatus.key = ESS_Enum.ManpowerStatus.Cancelled.name();
            ManpowerTable.currentStatus.value = 'Cancelled';
        }
        
        ManpowerTable.createdDate = Date.ValueOf(Manpower.CreatedDate);
        ManpowerTable.submittedDate = Manpower.Submitted_Date__c;
        ManpowerTable.requester = Manpower.Requester_Name__c;
        ManpowerTable.onBehalfOf = Manpower.On_Behalf_Of__c;
            
    	return ManpowerTable;
        
    }
    
    @RemoteAction
    public static List<string> GetProjectNames() {
        
        List<string> projectNames = new List<string>();
        
        List<ESS_LC1_Project__c> Projects = new List<ESS_LC1_Project__c>();
        
        string query = 'select id, project_name__c from ESS_LC1_Project__c order by project_name__c asc';
        Projects = database.query(query);
        
        if(Projects.size() > 0) {
            for(ESS_LC1_Project__c Project : Projects) {
                projectNames.add(Project.Project_Name__c);
            }
        }
        
        return projectNames;
    }
    
    private static string manpowerQuery() {
        
        string query = 'SELECT Approval_History_JSON__c,Cancelled_By_Id__c,Cancelled_By__c,Cancelled_Date__c,Comment__c,Completed_Date__c, ' + 
                			'Cost_Center__c,CreatedDate,Current_Status_JSON__c,Date_of_Commencement__c,Date_of_Completion__c,Department__c,Document_No__c,Function__c, ' + 
                			'G_L_Account__c,Id,Internal_Order_WBS__c,Is_Admin_PEOC__c,JE_Score__c,Job_Detail__c,Job_Id__c,Job__c,Name,No_of_Contractor_required__c,Objective__c, ' + 
                			'On_Behalf_Of_Department__c,On_Behalf_Of_Email__c,On_Behalf_Of_Employee_Id__c,On_Behalf_Of_Flow__c,On_Behalf_Of_Function__c,On_Behalf_Of_Id__c, ' +
                			'On_Behalf_Of_Position__c,On_Behalf_Of_Section__c,On_Behalf_Of_Unit__c,On_Behalf_Of__c,Output_Required__c,OwnerId,Physical_Requirement__c,Project_Id__c, ' + 
                			'Project_Manager_Approved_Date__c,Project_Manager_Flow__c,Project_Manager_Id__c,Project_Manager_Section_Head_Up__c,Project_Manager__c,Project__c,Qualification__c, ' + 
                			'Reference_Document_No__c,Requester_Department__c,Requester_Email__c,Requester_Employee_Id__c,Requester_Function__c,Requester_Id__c,Requester_Name__c, ' + 
                			'Requester_Position__c,Requester_Section__c,Requester_Tel_Office__c,Requester_Tel_Mobile__c,Requester_Unit__c,Scope_of_Service_ID__c,Section_Head_Approved_Date__c,Section_Head_Flow__c, ' + 
                			'Section_Head_Id__c,Section_Head__c,Section__c,Service_For__c,Status__c,Submitted_Date__c,Type_of_Service__c,Unit__c,VP_Approved_Date__c,VP_Flow__c,VP_Id__c, ' + 
                			'Workflow_Type__c,Working_Day__c,Work_Location__c, Year__c FROM ESS_Manpower__c';
            
        return query;
        
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
        public boolean typeOfServiceAll {get;set;}
        @RemoteAction
        public boolean typeOfServicePermanent {get;set;}
        @RemoteAction
        public boolean typeOfServiceTemporary {get;set;}
        @RemoteAction
        public boolean typeOfServiceProjectBase {get;set;}
        @RemoteAction
        public boolean currentStatusAll {get;set;}
        @RemoteAction
        public boolean currentStatusDraft {get;set;}
        @RemoteAction
        public boolean currentStatusInProgress {get;set;}
        @RemoteAction
        public boolean currentStatusCompleted {get;set;}
        @RemoteAction
        public boolean currentStatusCancelled {get;set;}
        @RemoteAction
        public boolean serviceForAll {get;set;}
        @RemoteAction
        public boolean serviceForTOP {get;set;}
        @RemoteAction
        public boolean serviceForTES {get;set;}
        @RemoteAction
        public boolean serviceForTLB {get;set;}
        @RemoteAction
        public boolean serviceForTPX {get;set;}
        @RemoteAction
        public boolean serviceForLABIX {get;set;}
        @RemoteAction
        public boolean serviceForTET {get;set;}
        @RemoteAction
        public boolean serviceForTOPSPP {get;set;}
        @RemoteAction
        public boolean serviceForTOPNEXT {get;set;}
        @RemoteAction
        public boolean serviceForTTC {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string objective {get;set;}
        @RemoteAction
        public string projectName {get;set;}
        @RemoteAction
        public string scopeOfServiceId {get;set;}
        @RemoteAction
        public string unit {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string function {get;set;}
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
        public date startCancelledDate {get;set;}
        @RemoteAction
        public date endCancelledDate {get;set;}
    }
    
    
}