public with sharing class ESS_ManpowerReportExcelController {

    public integer manpowerSize {get;set;}
    public date todayDate {get;set;}

    public List<ESS_ManpowerReport_DTO.ManpowerReportFullTableDTO> manpowerTables {get;set;}
    
    public void OnloadExcel() {
        
        todayDate = date.today();
        
        string userId = ESS_PrivilegeHandler.getUserId();
        
        manpowerSize = 0;
        
        manpowerTables = new List<ESS_ManpowerReport_DTO.ManpowerReportFullTableDTO>();
           
        boolean isPMBPAdmin = ESS_PrivilegeHandler.checkPMBPAdminUser(userId);
        boolean isPEOCAdmin = ESS_PrivilegeHandler.checkPEOCAdminUser(userId);
        
        List<ESS_Manpower__c> Manpowers = new List<ESS_Manpower__c>();
        ESS_ManpowerReport.SearchCriteria filter = new ESS_ManpowerReport.SearchCriteria();
        
        filter.typeOfServiceAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('typeOfServiceAll'));
        filter.typeOfServicePermanent = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('typeOfServicePermanent'));
        filter.typeOfServiceTemporary = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('typeOfServiceTemporary'));
        filter.typeOfServiceProjectBase = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('typeOfServiceProjectBase'));
        filter.currentStatusAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('currentStatusAll'));
        filter.currentStatusDraft = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('currentStatusDraft'));
        filter.currentStatusInProgress = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('currentStatusInProgress'));
        filter.currentStatusCompleted = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('currentStatusCompleted'));
        filter.currentStatusCancelled = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('currentStatusCancelled'));
        filter.serviceForAll = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForAll'));
        filter.serviceForTOP = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForTOP'));
        filter.serviceForTES = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForTES'));
        filter.serviceForTLB = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForTLB'));
        filter.serviceForTPX = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForTPX'));
        filter.serviceForLABIX = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForLABIX'));
        filter.serviceForTET = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForTET'));
        filter.serviceForTOPSPP = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForTOPSPP'));
        filter.serviceForTOPNEXT = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForTOPNEXT'));
        filter.serviceForTTC = Boolean.ValueOf(ApexPages.currentPage().getParameters().get('serviceForTTC'));
        filter.documentNo = ApexPages.currentPage().getParameters().get('documentNo');
        filter.employeeName = ApexPages.currentPage().getParameters().get('employeeName');
        filter.objective = ApexPages.currentPage().getParameters().get('objective');
        filter.projectName = ApexPages.currentPage().getParameters().get('projectName');
        filter.scopeOfServiceId = ApexPages.currentPage().getParameters().get('scopeOfServiceId');
        filter.unit = ApexPages.currentPage().getParameters().get('unit');
        filter.section = ApexPages.currentPage().getParameters().get('section');
        filter.department = ApexPages.currentPage().getParameters().get('department');
        filter.function = ApexPages.currentPage().getParameters().get('function');
        
        filter.startCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCreatedDate'));
        filter.endCreatedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCreatedDate'));
        filter.endCreatedDate = filter.endCreatedDate.addDays(1);
        filter.startSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startSubmittedDate'));
        filter.endSubmittedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endSubmittedDate'));
        filter.endSubmittedDate = filter.endSubmittedDate.addDays(1);
        filter.startCompletedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCompletedDate'));
        filter.endCompletedDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCompletedDate'));
        filter.endCompletedDate = filter.endCompletedDate.addDays(1);
        filter.startCancelledDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('startCancelledDate'));
        filter.endCancelledDate = Date.ValueOf(ApexPages.currentPage().getParameters().get('endCancelledDate'));
        filter.endCancelledDate = filter.endCancelledDate.addDays(1);
        
        string query = 'SELECT Approval_History_JSON__c,Cancelled_By_Id__c,Cancelled_By__c,Cancelled_Date__c,Comment__c,Completed_Date__c, ' + 
                            'Cost_Center__c,CreatedDate,Current_Status_JSON__c,Date_of_Commencement__c,Date_of_Completion__c,Department__c,Document_No__c,Function__c, ' + 
                            'G_L_Account__c,Id,Internal_Order_WBS__c,Is_Admin_PEOC__c,JE_Score__c,Job_Detail__c,Job_Id__c,Job__c,Name,No_of_Contractor_required__c,Objective__c, ' + 
                            'On_Behalf_Of_Department__c,On_Behalf_Of_Email__c,On_Behalf_Of_Employee_Id__c,On_Behalf_Of_Flow__c,On_Behalf_Of_Function__c,On_Behalf_Of_Id__c, ' +
                            'On_Behalf_Of_Position__c,On_Behalf_Of_Section__c,On_Behalf_Of_Unit__c,On_Behalf_Of__c,Output_Required__c,OwnerId,Physical_Requirement__c,Project_Id__c, ' + 
                            'Project_Manager_Approved_Date__c,Project_Manager_Flow__c,Project_Manager_Id__c,Project_Manager_Section_Head_Up__c,Project_Manager__c,Project__c,Qualification__c, ' + 
                            'Reference_Document_No__c,Requester_Department__c,Requester_Email__c,Requester_Employee_Id__c,Requester_Function__c,Requester_Id__c,Requester_Name__c, ' + 
                            'Requester_Position__c,Requester_Section__c,Requester_Tel_Office__c,Requester_Tel_Mobile__c,Requester_Unit__c,Scope_of_Service_ID__c,Section_Head_Approved_Date__c,Section_Head_Flow__c, ' + 
                            'Section_Head_Id__c,Section_Head__c,Section__c,Service_For__c,Status__c,Submitted_Date__c,Type_of_Service__c,Unit__c,VP_Approved_Date__c,VP_Flow__c,VP_Id__c, ' + 
                            'Workflow_Type__c,Working_Day__c,Work_Location__c, VP__c FROM ESS_Manpower__c where ownerId =: userId';
               
        if(isPMBPAdmin || isPEOCAdmin) {
            query = 'SELECT Approval_History_JSON__c,Cancelled_By_Id__c,Cancelled_By__c,Cancelled_Date__c,Comment__c,Completed_Date__c, ' + 
                            'Cost_Center__c,CreatedDate,Current_Status_JSON__c,Date_of_Commencement__c,Date_of_Completion__c,Department__c,Document_No__c,Function__c, ' + 
                            'G_L_Account__c,Id,Internal_Order_WBS__c,Is_Admin_PEOC__c,JE_Score__c,Job_Detail__c,Job_Id__c,Job__c,Name,No_of_Contractor_required__c,Objective__c, ' + 
                            'On_Behalf_Of_Department__c,On_Behalf_Of_Email__c,On_Behalf_Of_Employee_Id__c,On_Behalf_Of_Flow__c,On_Behalf_Of_Function__c,On_Behalf_Of_Id__c, ' +
                            'On_Behalf_Of_Position__c,On_Behalf_Of_Section__c,On_Behalf_Of_Unit__c,On_Behalf_Of__c,Output_Required__c,OwnerId,Physical_Requirement__c,Project_Id__c, ' + 
                            'Project_Manager_Approved_Date__c,Project_Manager_Flow__c,Project_Manager_Id__c,Project_Manager_Section_Head_Up__c,Project_Manager__c,Project__c,Qualification__c, ' + 
                            'Reference_Document_No__c,Requester_Department__c,Requester_Email__c,Requester_Employee_Id__c,Requester_Function__c,Requester_Id__c,Requester_Name__c, ' + 
                            'Requester_Position__c,Requester_Section__c,Requester_Tel_Office__c,Requester_Tel_Mobile__c,Requester_Unit__c,Scope_of_Service_ID__c,Section_Head_Approved_Date__c,Section_Head_Flow__c, ' + 
                            'Section_Head_Id__c,Section_Head__c,Section__c,Service_For__c,Status__c,Submitted_Date__c,Type_of_Service__c,Unit__c,VP_Approved_Date__c,VP_Flow__c,VP_Id__c, ' + 
                            'Workflow_Type__c,Working_Day__c,Work_Location__c, VP__c FROM ESS_Manpower__c where ownerId != null';
            
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
            query = query + ' AND project_name__c =: projectName';
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
        datetime startCreatedDate = ESS_Global.convertDateTimeFilter(filter.startCreatedDate);
        query = query + ' AND ((createddate >=: startCreatedDate';
        //filter.endCreatedDate
        datetime endCreatedDate = ESS_Global.convertDateTimeFilter(filter.endCreatedDate);
        query = query + ' AND createddate <=: endCreatedDate)';
           
        //filter.startSubmittedDate
        date startSubmittedDate = filter.startSubmittedDate;
        query = query + ' OR (submitted_date__c >=: startSubmittedDate';
        //filter.endSubmittedDate
        date endSubmittedDate = filter.endSubmittedDate;
        query = query + ' AND submitted_date__c <=: endSubmittedDate)';
        
        //filter.startCompletedDate
        date startCompletedDate = filter.startCompletedDate;
        query = query + ' OR (completed_date__c >=: startCompletedDate';
        //filter.endCompletedDate
        date endCompletedDate = filter.endCompletedDate;
        query = query + ' AND completed_date__c <=: endCompletedDate)';
        
        //filter.startCancelledDate
        date startCancelledDate = filter.startCancelledDate;
        query = query + ' OR (cancelled_date__c >=: startCancelledDate';
        //filter.endCancelledDate
        date endCancelledDate = filter.endCancelledDate;
        query = query + ' AND cancelled_date__c <=: endCancelledDate))';
        
        //Final query
        Manpowers = database.query(query + ' order by document_no__c desc');
                
        if(Manpowers.size() > 0) {
            for(ESS_Manpower__c Manpower : Manpowers) {
                ESS_ManpowerReport_DTO.ManpowerReportFullTableDTO ManpowerTable = new ESS_ManpowerReport_DTO.ManpowerReportFullTableDTO();
                ManpowerTable = assignToManpowerReportTableDTO(Manpower);
                if(string.isnotempty(ManpowerTable.documentNo)) {
                    manpowerTables.add(ManpowerTable);
                }
            }
            
        }
        
        manpowerSize = manpowerTables.size();
        
    }
    
    
    //Assign to DTO section
    public static ESS_ManpowerReport_DTO.ManpowerReportFullTableDTO assignToManpowerReportTableDTO(ESS_Manpower__c Manpower) {
    
        ESS_ManpowerReport_DTO.ManpowerReportFullTableDTO ManpowerTable = new ESS_ManpowerReport_DTO.ManpowerReportFullTableDTO();
        ManpowerTable.recordId = Manpower.Id;
        ManpowerTable.documentNo = Manpower.Document_No__c;
        
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
        
        ManpowerTable.serviceFor = Manpower.Service_For__c;
        ManpowerTable.glAccount = Manpower.G_L_Account__c;
        ManpowerTable.costCenter = Manpower.Cost_Center__c;
        ManpowerTable.internalOrderWBS = Manpower.Internal_Order_WBS__c;
        
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
        ManpowerTable.scopeOfServiceId = Manpower.Scope_of_Service_ID__c;
        ManpowerTable.projectName = Manpower.Project__c;
        ManpowerTable.unit = Manpower.Unit__c;
        ManpowerTable.section = Manpower.Section__c;
        ManpowerTable.department = Manpower.Department__c;
        ManpowerTable.function = Manpower.Function__c;
        
        ManpowerTable.workLocation = new ESS_Global.EnumValue('ManpowerWorkLocation');
        if(Manpower.Work_Location__c == String.ValueOf(ESS_Enum.ManpowerWorkLocation.Bangkok)) {
            ManpowerTable.workLocation.key = ESS_Enum.ManpowerWorkLocation.Bangkok.name();
            ManpowerTable.workLocation.value = 'กรุงเทพ';
        }
        else if(Manpower.Work_Location__c == String.ValueOf(ESS_Enum.ManpowerWorkLocation.Sriracha)) {
            ManpowerTable.workLocation.key = ESS_Enum.ManpowerWorkLocation.Sriracha.name();
            ManpowerTable.workLocation.value = 'ศรีราชา';
        }
        
        ManpowerTable.commencementDate = Manpower.Date_of_Commencement__c;
        ManpowerTable.completionDate = Manpower.Date_of_Completion__c;
        ManpowerTable.workingDay = Manpower.Working_Day__c;
        ManpowerTable.jeScore = Manpower.JE_Score__c;
        ManpowerTable.comment = Manpower.Comment__c;
        ManpowerTable.requester = Manpower.Requester_Name__c;
        ManpowerTable.createdDate = Date.ValueOf(Manpower.CreatedDate);
        ManpowerTable.submittedDate = Manpower.Submitted_Date__c;
        ManpowerTable.onBehalfOf = Manpower.On_Behalf_Of__c;
        //ManpowerTable.employeeApprovedDate = Manpower.Employee_Approved_Date__c;
        ManpowerTable.sectionHeadName = Manpower.Section_Head__c;
        ManpowerTable.sectionHeadApprovedDate = Manpower.Section_Head_Approved_Date__c;
        ManpowerTable.vpName = Manpower.VP__c;
        ManpowerTable.vpApprovedDate = Manpower.VP_Approved_Date__c;
        ManpowerTable.projectManagerName = Manpower.Project_Manager__c;
        ManpowerTable.projectManagerApprovedDate = Manpower.Project_Manager_Approved_Date__c;
        ManpowerTable.completedDate = Manpower.Completed_Date__c;
        ManpowerTable.cancelledBy = Manpower.Cancelled_By__c;
        ManpowerTable.cancelledDate = Manpower.Cancelled_Date__c;
            
        return ManpowerTable;
        
    }
    
            
}