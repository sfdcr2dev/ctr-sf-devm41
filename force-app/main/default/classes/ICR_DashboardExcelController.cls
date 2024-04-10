/* Author Softever */
public with sharing class ICR_DashboardExcelController {

    public DateTime TodayDate {get;set;}
    public List<ICR_Approval__c> ICRApprovals {get;set;}
    public Map<string,string> PISIndicators {get;set;}
    public Map<string,string> PISIndicatorFullNames {get;set;}

    /* Filter */
    public string InputRequestStartDate {get;set;}
    public string InputRequestEndDate {get;set;}
    public DateTime RequestStartDate {get;set;}
    public DateTime RequestEndDate {get;set;}
    public string DocNo {get;set;}
    public string WorkflowStatus {get;set;}
    public string CommitteeTitle {get;set;}
    public string RequesterName {get;set;}
    public string CircularNo {get;set;}
    
    public Set<Id> ICRIds {get;set;}
    public boolean isShowAll {get;set;}
    public boolean isGSCSStaff {get;set;}
    public boolean isGSCS {get;set;}
    public boolean isPMSV {get;set;}
    
    /* Wrapper */
    public List<ICRTableWrapper> ICRTWs {get;set;}
    
    public class ICRTableWrapper {
    
        public string DocumentNo {get;set;}
        public string DocumentLink {get;set;}
        public string ButtonStatus {get;set;}
        public string WorkflowStatus {get;set;}
        public string CommitteeTitle {get;set;}
        public string ApprovalType {get;set;}
        public string RequesterName {get;set;}
        public string CircularNo {get;set;}
        public DateTime RequestDate {get;set;}
        public DateTime EffectiveStartDate {get;set;}
        public DateTime EffectiveEndDate {get;set;}
        public DateTime FinishedDate {get;set;}
        public string ActiveStatus {get;set;}
        public string ApprovalHistoryLink {get;set;}
        
    }
    
    public ICR_DashboardExcelController() {
        
        string language = UserInfo.getLanguage();
        system.debug(language);
    
        Datetime now = Datetime.now();
        TodayDate = now;
        
        //Parameter
        string isExcel = ApexPages.currentPage().getParameters().get('Excel');
        
        datetime requestStartDateExcel = DateTime.ValueOf(ApexPages.currentPage().getParameters().get('RequestStartDate'));
        datetime requestEndDateExcel = Datetime.ValueOf(ApexPages.currentPage().getParameters().get('RequestEndDate'));
        WorkflowStatus = ApexPages.currentPage().getParameters().get('WorkflowStatus');
        RequesterName = ApexPages.currentPage().getParameters().get('Requester');
        CommitteeTitle = ApexPages.currentPage().getParameters().get('CommitteeTitle');
        DocNo = ApexPages.currentPage().getParameters().get('DocumentNo');
        CircularNo = ApexPages.currentPage().getParameters().get('CircularNo');
        
        boolean isFilterSearch = false;
        
        System.debug('DocNo : ' + DocNo);
        
        Set<Id> ICRApprovalIds = new Set<Id>();
    
        /* if(!userInfo.contains('en')) {
            requestStartDateExcel = requestStartDateExcel.AddYears(543).AddHours(7);
            requestEndDateExcel = requestEndDateExcel.AddYears(543).AddHours(7).AddDays(1);
        }
        else {
            requestStartDateExcel = requestStartDateExcel.AddHours(7);
            requestEndDateExcel = requestEndDateExcel.AddHours(7).AddDays(1);
        } */
        
        system.debug(requestStartDateExcel);
        system.debug(requestEndDateExcel);
        
        requestStartDateExcel = requestStartDateExcel.AddYears(543).AddHours(7);
        requestEndDateExcel = requestEndDateExcel.AddYears(543).AddHours(7).AddDays(1);
        
        system.debug(requestStartDateExcel);
        system.debug(requestEndDateExcel);
        
        Date RequestStartOnlyDate = requestStartDateExcel.Date();
        Date RequestEndOnlyDate = requestEndDateExcel.Date();
        
        system.debug(RequestStartOnlyDate);
        system.debug(RequestEndOnlyDate);
        
        
        //From PIS
        List<PISUsers__c> PISUsers = [select id, name, indicator__c, enfirstname__c, enlastname__c, employeeid__c, posid__c, holderposition__c from PISUsers__c];
        
        Map<string,string> PISPOSIDs = new Map<string,string>();
        PISIndicators = new Map<string,string>();
        PISIndicatorFullNames = new Map<string,string>();
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PIS : PISUsers) {
                if(!string.isblank(PIS.indicator__c)) {
                    PISIndicators.put(PIS.enfirstname__c + ' ' + PIS.enlastname__c, PIS.indicator__c);
                    PISIndicatorFullNames.put(PIS.indicator__c, PIS.enfirstname__c + ' ' + PIS.enlastname__c);
                }
                
                if(!string.isblank(PIS.holderposition__c)) {
                    boolean isMoreThanOnePos = PIS.holderposition__c.contains(',');
                    if(isMoreThanOnePos) {
                        
                        List<string> positions = new List<string>();
                        positions = PIS.holderposition__c.split(',');
                        
                        if(positions.size() > 0) {
                            for(string pos : positions) {
                                PISPOSIDs.put(pos, PIS.employeeid__c);
                            }
                        }
                        
                    }
                    else {
                        PISPOSIDs.put(PIS.holderposition__c, PIS.employeeid__c);
                    }
                }
            }
            
        }
        
        
        //Filter from Subcordinate
        isShowAll = false;
        string userId = UserInfo.getUserId();
        string profileId = UserInfo.getProfileId();
        
        string profileName = [select id, name from Profile where Id =: profileId].Name;
        
        if(profileName == 'System Administrator') {
            isShowAll = true;
        }
        
        isGSCSStaff = FindingGSCSStaff(userId);
        isGSCS = FindingGSCS(userId);
        isPMSV = FindingPMSV(userId);
        
        PISUsers__c LoggedInUser = new PISUsers__c();
        List<string> allSubcordinate = new List<string>();
        
        if(!isShowAll && !isGSCSStaff && !isGSCS && !isPMSV) {
        
            ICRIds = new Set<Id>();
            
            LoggedInUser = [select id, user__c, subcordinate__c from PISUsers__c where User__c =: userId];
            
            if(!string.isBlank(LoggedInUser.subcordinate__c)) {
                allSubcordinate = (List<string>)JSON.deserialize(LoggedInUser.subcordinate__c, List<string>.class);
            }
            
            Set<string> EMPIDs = new Set<string>();
            
            //Get EMPLOYEEID
            List<PISUsers__c> POSIDPISUsers = [select id, employeeid__c, posid__c from PISUsers__c where EMPLOYEEID__c IN: allSubcordinate];
            
            if(POSIDPISUsers.size() > 0) {
                for(PISUsers__c Emp : POSIDPISUsers) {
                    EMPIDs.add(Emp.EmployeeID__c);
                }
            }
            
            //Get from POSID and HOLDERPOSITIONID
            if(PISPOSIDs.size() > 0 && allSubcordinate.size() > 0) {
                for(string subCordinate : allSubcordinate) {
                
                    EMPIDs.add(PISPOSIDs.get(subCordinate));
                    
                }
            }
            
            //Approval History
            List<ICR_Approval__History> ICRHistories = [select id, parentId, createddate, field, datatype, oldvalue, newvalue from ICR_Approval__History 
                                                        where Field = 'Approver__c' AND DataType = 'EntityId' AND createddate >=: RequestStartOnlyDate AND 
                                                        createddate <=: RequestEndOnlyDate];
                                                        
            if(ICRHistories.size() > 0) {
                for(ICR_Approval__History ICRHistory : ICRHistories) {
                    if(ICRHistory.OldValue == userId || ICRHistory.NewValue == userId) {
                        ICRIds.add(ICRHistory.ParentId);
                    }
                }
            }
            
            ICRApprovals = [select id, name, status__c, owner.name, circular_no__c, createddate, start_date__c, end_date__c, 
                        finished_date__c, Owner.FirstName, Owner.LastName, OwnerId, type__c, active__c, committee_title__c, be_line_manager_id__c, be_evp_id__c, employee_id__c  
                        from ICR_Approval__c where createddate >=: RequestStartOnlyDate AND createddate <=: RequestEndOnlyDate AND employee_id__c IN: EMPIDs order by Createddate desc];
                    
            if(ICRApprovals.size() > 0) {
            
                //Requester / LM / EVP
                for(ICR_Approval__c ICR : ICRApprovals) {
                    
                    if(ICR.OwnerId == userId) {
                        ICRIds.add(ICR.Id);
                    }
                    else {
                        ICRIds.add(ICR.Id);
                    }
                }
                
            }
            
            if(ICRIds.size() > 0) {
                system.debug('ICRIds : ' + ICRIds);
                
                ICRApprovals = [select id, name, status__c, owner.name, circular_no__c, createddate, start_date__c, end_date__c, 
                        finished_date__c, Owner.FirstName, Owner.LastName, OwnerId, type__c, active__c, committee_title__c, be_line_manager_id__c, be_evp_id__c 
                        from ICR_Approval__c where Id IN: ICRIds order by Createddate desc];
                        
            }
        }
        else {
        
            ICRApprovals = [select id, name, status__c, owner.name, circular_no__c, createddate, start_date__c, end_date__c, 
                        finished_date__c, Owner.FirstName, Owner.LastName, type__c, active__c, committee_title__c from ICR_Approval__c where createddate >=: RequestStartOnlyDate AND
                        createddate <=: RequestEndOnlyDate order by Createddate desc];
                        
        }
        
        boolean isSearchNotFound = false;
        
        //Filter if any
        if(WorkflowStatus != 'All') {
            
            isFilterSearch = true;
            ICRApprovalIds = new Set<Id>();
            
            for(ICR_Approval__c ICRApproval : ICRApprovals) {
                if(ICRApproval.Status__c == WorkflowStatus) {
                    ICRApprovalIds.add(ICRApproval.Id);
                }
            }
            
            if(ICRApprovalIds.size() == 0) {
                isSearchNotFound = true;
            }
            
        }
        
        if(RequesterName != 'All') {
            
            isFilterSearch = true;
            
            if(!isSearchNotFound) {
                
                if(ICRApprovalIds.size() > 0) {
                    ICRApprovals = [select id, Owner.FirstName, Owner.LastName, Owner_Full_Name__c from ICR_Approval__c where Id IN: ICRApprovalIds AND Owner_Full_Name__c =: PISIndicatorFullNames.get(RequesterName)];
                    
                    ICRApprovalIds = new Set<Id>();
                    
                    for(ICR_Approval__c ICRApproval : ICRApprovals) {
                        ICRApprovalIds.add(ICRApproval.Id);
                    }
                }
                else {
                    ICRApprovalIds = new Set<Id>();
                    
                    for(ICR_Approval__c ICRApproval : ICRApprovals) {
            
                        string requesterFullName = ICRApproval.Owner.FirstName + ' ' + ICRApproval.Owner.LastName;
                        string searchRequesterName = PISIndicatorFullNames.get(RequesterName);
                        if(searchRequesterName == requesterFullName) {
                            ICRApprovalIds.add(ICRApproval.Id);
                        }
                        
                    }
                }
                
                if(ICRApprovalIds.size() == 0) {
                    isSearchNotFound = true;
                }
            }
        }
        
        if(CommitteeTitle != 'All') {
            
            isFilterSearch = true;
            
            if(!isSearchNotFound) {
                
                if(ICRApprovalIds.size() > 0) {
                    ICRApprovals = [select id, Committee_Title__c from ICR_Approval__c where Id IN: ICRApprovalIds AND Committee_Title__c =: CommitteeTitle];
                    
                    ICRApprovalIds = new Set<Id>();
                    
                    for(ICR_Approval__c ICRApproval : ICRApprovals) {
                
                        ICRApprovalIds.add(ICRApproval.Id);
                    }
                }
                else {
                    ICRApprovalIds = new Set<Id>();
                    
                    for(ICR_Approval__c ICRApproval : ICRApprovals) {
                
                        if(ICRApproval.Committee_Title__c == CommitteeTitle) {
                            ICRApprovalIds.add(ICRApproval.Id);
                        }
                        
                    }
                }
                
                if(ICRApprovalIds.size() == 0) {
                    isSearchNotFound = true;
                }
            }
        }
        
        if(DocNo != 'All') {
            
            isFilterSearch = true;
            
            if(!isSearchNotFound) {
                
                if(ICRApprovalIds.size() > 0) {
                    ICRApprovals = [select id, Name from ICR_Approval__c where Id IN: ICRApprovalIds AND Name =: DocNo];
                    
                    ICRApprovalIds = new Set<Id>();
                    
                    for(ICR_Approval__c ICRApproval : ICRApprovals) {
                
                        ICRApprovalIds.add(ICRApproval.Id);
                    }
                }
                else {
                
                    ICRApprovalIds = new Set<Id>();
                    
                    for(ICR_Approval__c ICRApproval : ICRApprovals) {
                
                        if(ICRApproval.Name == DocNo) {
                            ICRApprovalIds.add(ICRApproval.Id);
                        }
                    }
                }
                
                if(ICRApprovalIds.size() == 0) {
                    isSearchNotFound = true;
                }
            }
        }
        
        if(CircularNo != 'All') {
            
            isFilterSearch = true;
            
            if(!isSearchNotFound) {
                
                if(ICRApprovalIds.size() > 0) {
                    ICRApprovals = [select id, Circular_No__c from ICR_Approval__c where Id IN: ICRApprovalIds AND Circular_No__c =: CircularNo];
                    
                    ICRApprovalIds = new Set<Id>();
                    for(ICR_Approval__c ICRApproval : ICRApprovals) {
                        ICRApprovalIds.add(ICRApproval.Id);
                    }
                }
                else {
                    ICRApprovalIds = new Set<Id>();
                    
                    for(ICR_Approval__c ICRApproval : ICRApprovals) {
                
                        if(ICRApproval.Circular_No__c == CircularNo) {
                            ICRApprovalIds.add(ICRApproval.Id);
                        }
                    }
                }
                
                if(ICRApprovalIds.size() == 0) {
                    isSearchNotFound = true;
                }
            }
        }
        
        if(ICRApprovalIds.size() > 0) {
            ICRApprovals = [select id, name, status__c, owner.name, circular_no__c, createddate, start_date__c, end_date__c, 
                        finished_date__c, Owner.FirstName, Owner.LastName, type__c, active__c, committee_title__c from ICR_Approval__c where Id IN: ICRApprovalIds];
                        
        }
        
             
        CalculateICRTable(ICRApprovals);
    }
    
    public List<ICRTableWrapper> CalculateICRTable(List<ICR_Approval__c> ICRApprovals) {
        
        ICRTWs = new List<ICRTableWrapper>();
        
        for(ICR_Approval__c ICR : ICRApprovals) {
                
            ICRTableWrapper ICRTable = new ICRTableWrapper();
            ICRTable.DocumentNo = ICR.Name;
            //ICRTable.DocumentLink = BaseURL + 'lightning/r/ICR_Approval__c/' + ICR.Id + '/view';
            ICRTable.WorkflowStatus = ICR.Status__c;
            
            ICRTable.ActiveStatus = '';
            
            if(ICR.Status__c == 'Waiting Requester Revise' || ICR.Status__c == 'Waiting Line Manager Approval' || ICR.Status__c == 'Waiting Submit Approval Type'
               || ICR.Status__c == 'Waiting GSCS Approval' || ICR.Status__c == 'Waiting Requester Update Result' || ICR.Status__c == 'Waiting EVP Approval' 
               || ICR.Status__c == 'Waiting Circular No.' || ICR.Status__c == 'Waiting Signed Circular File') {
                   
                   ICRTable.ButtonStatus = 'in-progress';
                   
               }
            else if(ICR.Status__c == 'Appointed') {
                ICRTable.ButtonStatus = 'appointed';
                
                if(ICR.Active__c == true) {
                    ICRTable.ActiveStatus = 'Active';
                }
                else if(ICR.Active__c == false && ICR.Start_Date__c > todayDate) {
                    ICRTable.ActiveStatus = '';
                }
                /* else if(ICR.Active__c == false && ICR.Start_Date__c <= todayDate && ICR.End_Date__c == null) {
                    ICRTable.ActiveStatus = 'Expired';
                } */
                else if(ICR.Active__c == false && ICR.Start_Date__c < todayDate && 
                        ICR.End_Date__c != null && ICR.End_Date__c < todayDate) {
                    ICRTable.ActiveStatus = 'Expired';
                }
            }
            else if(ICR.Status__c == 'Disappointed') {
                ICRTable.ButtonStatus = 'disappointed';
            }
            else if(ICR.Status__c == 'Cancelled Request') {
                ICRTable.ButtonStatus = 'cancelled';
            }
            
            ICRTable.CommitteeTitle = ICR.Committee_Title__c;
            ICRTable.ApprovalType = ICR.Type__c;
            
            string requesterName = ICR.Owner.FirstName + ' ' + ICR.Owner.LastName;
            
            ICRTable.RequesterName = PISIndicators.get(requesterName); //ICR.Owner.FirstName + ' ' + ICR.Owner.LastName;
            
            if(ICR.Circular_No__c != null) {
                ICRTable.CircularNo = ICR.Circular_No__c ;
            }
            
            ICRTable.RequestDate = ICR.CreatedDate;
            ICRTable.EffectiveStartDate = ICR.Start_Date__c;
            ICRTable.EffectiveEndDate = ICR.End_Date__c;
            ICRTable.FinishedDate = ICR.Finished_Date__c;
            //ICRTable.ApprovalHistoryLink = BaseURL + 'lightning/r/ProcessInstanceHistory/' + ICR.Id + '/related/ProcessSteps/view';
            ICRTWs.add(ICRTable);
                
        }
        
        return ICRTWs;
        
    }
    
    public boolean FindingGSCSStaff(Id userId) {
    
        boolean isGSCSStaff = false;
    
        //GSCS Staff
        Group GSCSStaffGroup = [select id, developername from Group where developername =: 'ICR_GSCS_Staff'];
        List<GroupMember> GSCSStaffUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSStaffGroup.Id];
                    
        if(GSCSStaffUsers.size() > 0) {
            for(GroupMember GSCSStaff : GSCSStaffUsers) {
                if(userId == GSCSStaff.UserOrGroupId) {
                    isGSCSStaff = true;
                }
            }
        }
        
        return isGSCSStaff;
        
    }
    
    public boolean FindingGSCS(Id userId) {
    
        boolean isGSCS = false;
    
        //GSCS
        Group GSCSGroup = [select id, developername from Group where developername =: 'ICR_GSCS'];
        List<GroupMember> GSCSUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSGroup.Id];
                    
        if(GSCSUsers.size() > 0) {
            for(GroupMember GSCS : GSCSUsers) {
                if(userId == GSCS.UserOrGroupId) {
                    isGSCS = true;
                }
            }
        }
        
        return isGSCS;
        
    }
    
    public boolean FindingPMSV(Id userId) {
    
        boolean isPMSV = false;
    
        //PMSV
        Group PMSVGroup = [select id, developername from Group where developername =: 'ICR_PMSV'];
        List<GroupMember> PMSVUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PMSVGroup.Id];
                    
        if(PMSVUsers.size() > 0) {
            for(GroupMember PMSV : PMSVUsers) {
                if(userId == PMSV.UserOrGroupId) {
                    isPMSV = true;
                }
            }
        }
        
        return isPMSV;
        
    }
    
    public string LanguageThai {
        get {
            return EncodingUtil.base64decode('77u/').toString();
        }
    }

}