/* Author Softever */
public with sharing class ICR_DashboardController {

    public Id ListViewId {get;set;}
    public Id RecordTypeId {get;set;}
    public boolean isMobileDisable {get;set;}
    public string NewRequestURL {get;set;}
    public string RequesterId {get;set;}
    public string BaseURL {get;set;}
    public List<ICR_Approval__c> ICRApprovals {get;set;}
    public DateTime TodayDate {get;set;}
    public integer ICRSize {get;set;}
    public string ExportExcelURL {get;set;}
    public List<string> WorkflowStatuses {get;set;}
    public Set<string> RequesterNames {get;set;}
    public Set<string> CommitteeTitles {get;set;}
    public Set<string> DocNos {get;set;}
    public Set<string> CircularNos {get;set;}
    public Map<string,string> PISIndicators {get;set;}
    public Map<string,string> PISIndicatorFullNames {get;set;}
    
    public Set<Id> ICRIds {get;set;}
    public boolean isShowAll {get;set;}
    public boolean isGSCSStaff {get;set;}
    public boolean isGSCS {get;set;}
    public boolean isPMSV {get;set;}

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
    
    /* Wrapper */
    public ProgressNoWrapper PNW {get;set;}
    public List<CommitteeRequestStatusWrapper> CSWs {get;set;}
    public List<CommitteeApprovalTypeWrapper> CATWs {get;set;}
    public NumberOfCommitteeWrapper NOCW {get;set;}
    public List<ICRTableWrapper> ICRTWs {get;set;}
    
    public class ProgressNoWrapper {
        
        public integer Total {get;set;}
        public integer InProgress {get;set;}
        public integer Appointed {get;set;}
        public integer Disappointed {get;set;}
        public integer Cancelled {get;set;}
        
    }
    
    public class CommitteeRequestStatusWrapper {
        public string StatusName {get;set;}
        public integer StatusCount {get;set;}
    }
    
    public class CommitteeApprovalTypeWrapper {
        public string ApprovalName {get;set;}
        public integer InProgress {get;set;}
        public integer Appointed {get;set;}
        public integer Disappointed {get;set;}
    }
    
    public class NumberOfCommitteeWrapper {
        public integer Active {get;set;}
        public integer Expired {get;set;}
    }
    
    public string sortByDocumentNoHeader {get;set;}
    public string sortByWorkflowStatusHeader {get;set;}
    public string sortByCommitteeTitleHeader {get;set;}
    public string sortByApprovalTypeHeader {get;set;}
    public string sortByRequesterHeader {get;set;}
    public string sortByCircularNoHeader {get;set;}
    public string sortByRequestDateHeader {get;set;}
    public string sortByEffectiveStartDateHeader {get;set;}
    public string sortByEffectiveEndDateHeader {get;set;}
    public string sortByFinishedDateHeader {get;set;}
    public string sortByActiveStatusHeader {get;set;}
    
    public boolean sortByDocumentNoDesc {get;set;}
    public boolean sortByWorkflowStatusDesc {get;set;}
    public boolean sortByCommitteeTitleDesc {get;set;}
    public boolean sortByApprovalTypeDesc {get;set;}
    public boolean sortByRequesterDesc {get;set;}
    public boolean sortByCircularNoDesc {get;set;}
    public boolean sortByRequestDateDesc {get;set;}
    public boolean sortByEffectiveStartDateDesc {get;set;}
    public boolean sortByEffectiveEndDateDesc {get;set;}
    public boolean sortByFinishedDateDesc {get;set;}
    public boolean sortByActiveStatusDesc {get;set;}
    
    public static string DOCUMENTNO_SORT = 'DocumentNo';
    public static string SORT_BY = DOCUMENTNO_SORT;
    public static string DOCUMENTNO_SORT_DESC = 'DocumentNoDesc';
    public static string WORKFLOWSTATUS_SORT = 'WorkflowStatus';
    public static string WORKFLOWSTATUS_SORT_DESC = 'WorkflowStatusDesc';
    public static string COMMITTEETITLE_SORT = 'CommitteeTitle';
    public static string COMMITTEETITLE_SORT_DESC = 'CommitteeTitleDesc';
    public static string APPROVALTYPE_SORT = 'ApprovalType';
    public static string APPROVALTYPE_SORT_DESC = 'ApprovalTypeDesc';
    public static string REQUESTER_SORT = 'Requester';
    public static string REQUESTER_SORT_DESC = 'RequesterDesc';
    public static string CIRCULARNO_SORT = 'CircularNo';
    public static string CIRCULARNO_SORT_DESC = 'CircularNoDesc';
    public static string REQUESTDATE_SORT = 'RequestDate';
    public static string REQUESTDATE_SORT_DESC = 'RequestDateDesc';
    public static string EFFECTIVESTARTDATE_SORT = 'EffectiveStartDate';
    public static string EFFECTIVESTARTDATE_SORT_DESC = 'EffectiveStartDateDesc';
    public static string EFFECTIVEENDDATE_SORT = 'EffectiveEndDate';
    public static string EFFECTIVEENDDATE_SORT_DESC = 'EffectiveEndDateDesc';
    public static string FINISHEDDATE_SORT = 'FinishedDate';
    public static string FINISHEDDATE_SORT_DESC = 'FinishedDateDesc';
    public static string ACTIVESTATUS_SORT = 'ActiveStatus';
    public static string ACTIVESTATUS_SORT_DESC = 'ActiveStatusDesc';
    
    public class ICRTableWrapper implements Comparable {
    
        public string DocumentNo {get;set;}
        public string DocumentLink {get;set;}
        public string ButtonStatus {get;set;}
        public string WorkflowStatus {get;set;}
        public string CommitteeTitle {get;set;}
        public string ApprovalType {get;set;}
        public string RequesterName {get;set;}
        public string Indicator {get;set;}
        public string CircularNo {get;set;}
        public DateTime RequestDate {get;set;}
        public DateTime EffectiveStartDate {get;set;}
        public DateTime EffectiveEndDate {get;set;}
        public DateTime FinishedDate {get;set;}
        public string ActiveStatus {get;set;}
        public string ApprovalHistoryLink {get;set;}
        
        public ICRTableWrapper() { }
        
        //Sort By
        public ICRTableWrapper(string DocumentNo, string WorkflowStatus, string CommitteeTitle, string ApprovalType, string Requester, string CircularNo, DateTime RequestDate, 
                                DateTime EffectiveStartDate, DateTime EffectiveEndDate, DateTime FinishedDate, string ActiveStatus) {
            
            this.DocumentNo = DocumentNo;
            this.WorkflowStatus = WorkflowStatus;
            this.CommitteeTitle = CommitteeTitle;
            this.ApprovalType = ApprovalType;
            this.RequesterName = Requester;
            this.CircularNo = CircularNo;
            this.RequestDate = RequestDate;
            this.EffectiveStartDate = EffectiveStartDate;
            this.EffectiveEndDate = EffectiveEndDate;
            this.FinishedDate = FinishedDate; 
            this.ActiveStatus = ActiveStatus;  
                                
        }
        
        //Document No Sort
        public integer sortByDocumentNo(ICRTableWrapper ICR) {
            if(this.DocumentNo > ICR.DocumentNo) {
                return 1;
            }
            if(this.DocumentNo == ICR.DocumentNo) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByDocumentNoDesc(ICRTableWrapper ICR) {
            if (this.DocumentNo < ICR.DocumentNo) {
                return 1;
            }

            if (this.DocumentNo == ICR.DocumentNo) {
                return 0;
            }

            return -1;
        }
        
        //WorkflowStatus Sort
        public integer sortByWorkflowStatus(ICRTableWrapper ICR) {
            if(this.WorkflowStatus > ICR.WorkflowStatus) {
                return 1;
            }
            if(this.WorkflowStatus == ICR.WorkflowStatus) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByWorkflowStatusDesc(ICRTableWrapper ICR) {
            if (this.WorkflowStatus < ICR.WorkflowStatus) {
                return 1;
            }

            if (this.WorkflowStatus == ICR.WorkflowStatus) {
                return 0;
            }

            return -1;
        }
        
        //Committee Title Sort
        public integer sortByCommitteeTitle(ICRTableWrapper ICR) {
            if(this.CommitteeTitle > ICR.CommitteeTitle) {
                return 1;
            }
            if(this.CommitteeTitle == ICR.CommitteeTitle) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByCommitteeTitleDesc(ICRTableWrapper ICR) {
            if (this.CommitteeTitle < ICR.CommitteeTitle) {
                return 1;
            }

            if (this.CommitteeTitle == ICR.CommitteeTitle) {
                return 0;
            }

            return -1;
        }
        
        //Approval Type Sort
        public integer sortByApprovalType(ICRTableWrapper ICR) {
            if(this.ApprovalType > ICR.ApprovalType) {
                return 1;
            }
            if(this.ApprovalType == ICR.ApprovalType) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByApprovalTypeDesc(ICRTableWrapper ICR) {
            if (this.ApprovalType < ICR.ApprovalType) {
                return 1;
            }

            if (this.ApprovalType == ICR.ApprovalType) {
                return 0;
            }

            return -1;
        }
        
        //Requester Sort
        public integer sortByRequester(ICRTableWrapper ICR) {
            if(this.RequesterName > ICR.RequesterName) {
                return 1;
            }
            if(this.RequesterName == ICR.RequesterName) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByRequesterDesc(ICRTableWrapper ICR) {
            if (this.RequesterName < ICR.RequesterName) {
                return 1;
            }

            if (this.RequesterName == ICR.RequesterName) {
                return 0;
            }

            return -1;
        }
        
        //Circular No Sort
        public integer sortByCircularNo(ICRTableWrapper ICR) {
            if(this.CircularNo > ICR.CircularNo) {
                return 1;
            }
            if(this.CircularNo == ICR.CircularNo) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByCircularNoDesc(ICRTableWrapper ICR) {
            if (this.CircularNo < ICR.CircularNo) {
                return 1;
            }

            if (this.CircularNo == ICR.CircularNo) {
                return 0;
            }

            return -1;
        }
        
        //RequestDate Sort
        public integer sortByRequestDate(ICRTableWrapper ICR) {
            if(this.RequestDate > ICR.RequestDate) {
                return 1;
            }
            if(this.RequestDate == ICR.RequestDate) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByRequestDateDesc(ICRTableWrapper ICR) {
            if (this.RequestDate < ICR.RequestDate) {
                return 1;
            }

            if (this.RequestDate == ICR.RequestDate) {
                return 0;
            }

            return -1;
        }
        
        //EffectiveStartDate Sort
        public integer sortByEffectiveStartDate(ICRTableWrapper ICR) {
            if(this.EffectiveStartDate > ICR.EffectiveStartDate) {
                return 1;
            }
            if(this.EffectiveStartDate == ICR.EffectiveStartDate) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByEffectiveStartDateDesc(ICRTableWrapper ICR) {
            if (this.EffectiveStartDate < ICR.EffectiveStartDate) {
                return 1;
            }

            if (this.EffectiveStartDate == ICR.EffectiveStartDate) {
                return 0;
            }

            return -1;
        }
        
        //EffectiveEndDate Sort
        public integer sortByEffectiveEndDate(ICRTableWrapper ICR) {
            if(this.EffectiveEndDate > ICR.EffectiveEndDate) {
                return 1;
            }
            if(this.EffectiveEndDate == ICR.EffectiveEndDate) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByEffectiveEndDateDesc(ICRTableWrapper ICR) {
            if (this.EffectiveEndDate < ICR.EffectiveEndDate) {
                return 1;
            }

            if (this.EffectiveEndDate == ICR.EffectiveEndDate) {
                return 0;
            }

            return -1;
        }
        
        //FinishedDate Sort
        public integer sortByFinishedDate(ICRTableWrapper ICR) {
            if(this.FinishedDate > ICR.FinishedDate) {
                return 1;
            }
            if(this.FinishedDate == ICR.FinishedDate) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByFinishedDateDesc(ICRTableWrapper ICR) {
            if (this.FinishedDate < ICR.FinishedDate) {
                return 1;
            }

            if (this.FinishedDate == ICR.FinishedDate) {
                return 0;
            }

            return -1;
        }
        
        //Active Status Sort
        public integer sortByActiveStatus(ICRTableWrapper ICR) {
            if(this.ActiveStatus > ICR.ActiveStatus) {
                return 1;
            }
            if(this.ActiveStatus == ICR.ActiveStatus) {
                return 0;
            }
            
            return -1;
        }
        public Integer sortByActiveStatusDesc(ICRTableWrapper ICR) {
            if (this.ActiveStatus < ICR.ActiveStatus) {
                return 1;
            }

            if (this.ActiveStatus == ICR.ActiveStatus) {
                return 0;
            }

            return -1;
        }
        
        public Integer compareTo(Object obj) {
            ICRTableWrapper ICRWrapper = (ICRTableWrapper)(obj);

            if (SORT_BY == DOCUMENTNO_SORT) {
                return sortByDocumentNo(ICRWrapper);
            }
            else if (SORT_BY == DOCUMENTNO_SORT_DESC) {
                return sortByDocumentNoDesc(ICRWrapper);
            }
            else if (SORT_BY == WORKFLOWSTATUS_SORT) {
                return sortByWorkflowStatus(ICRWrapper);
            }
            else if (SORT_BY == WORKFLOWSTATUS_SORT_DESC) {
                return sortByWorkflowStatusDesc(ICRWrapper);
            }
            else if (SORT_BY == COMMITTEETITLE_SORT) {
                return sortByCommitteeTitle(ICRWrapper);
            }
            else if (SORT_BY == COMMITTEETITLE_SORT_DESC) {
                return sortByCommitteeTitleDesc(ICRWrapper);
            }
            else if (SORT_BY == APPROVALTYPE_SORT) {
                return sortByApprovalType(ICRWrapper);
            }
            else if (SORT_BY == APPROVALTYPE_SORT_DESC) {
                return sortByApprovalTypeDesc(ICRWrapper);
            }
            else if (SORT_BY == REQUESTER_SORT) {
                return sortByRequester(ICRWrapper);
            }
            else if (SORT_BY == REQUESTER_SORT_DESC) {
                return sortByRequesterDesc(ICRWrapper);
            }
            else if (SORT_BY == CIRCULARNO_SORT) {
                return sortByCircularNo(ICRWrapper);
            }
            else if (SORT_BY == CIRCULARNO_SORT_DESC) {
                return sortByCircularNoDesc(ICRWrapper);
            }
            else if (SORT_BY == REQUESTDATE_SORT) {
                return sortByRequestDate(ICRWrapper);
            }
            else if (SORT_BY == REQUESTDATE_SORT_DESC) {
                return sortByRequestDateDesc(ICRWrapper);
            }
            else if (SORT_BY == EFFECTIVESTARTDATE_SORT) {
                return sortByEffectiveStartDate(ICRWrapper);
            }
            else if (SORT_BY == EFFECTIVESTARTDATE_SORT_DESC) {
                return sortByEffectiveStartDateDesc(ICRWrapper);
            }
            else if (SORT_BY == EFFECTIVEENDDATE_SORT) {
                return sortByEffectiveEndDate(ICRWrapper);
            }
            else if (SORT_BY == EFFECTIVEENDDATE_SORT_DESC) {
                return sortByEffectiveEndDateDesc(ICRWrapper);
            }
            else if (SORT_BY == FINISHEDDATE_SORT) {
                return sortByFinishedDate(ICRWrapper);
            }
            else if (SORT_BY == FINISHEDDATE_SORT_DESC) {
                return sortByFinishedDateDesc(ICRWrapper);
            }
            else if (SORT_BY == ACTIVESTATUS_SORT) {
                return sortByActiveStatus(ICRWrapper);
            }
            else if (SORT_BY == ACTIVESTATUS_SORT_DESC) {
                return sortByActiveStatusDesc(ICRWrapper);
            }

            // If we don't have a know sort by, let's just return that they are all equal
            return 0;
        }
    }

    public ICR_DashboardController() {
    
        isMobileDisable = false;
        string userTheme = currentTheme();
    
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
    
    
        //Table Filter
        sortByDocumentNoHeader = 'desc';
        sortByDocumentNoDesc = true;
    
        BaseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        RequesterId = UserInfo.getUserId();

        //New Request URL
        ListViewId = getListViewId();
        RecordTypeId = getRecordTypeId();
        
        NewRequestURL = BaseURL + 'lightning/o/ICR_Approval__c/new?recordTypeId=' + RecordTypeId;
        
        if(userTheme == 'Theme4t') {
            NewRequestURL = '/lightning/o/ICR_Approval__c/new?recordTypeId=' + RecordTypeId;
            isMobileDisable = true;
        }
        
        //Default Filter
        Datetime now = Datetime.now();
        TodayDate = now;
        
        Integer offset = UserInfo.getTimezone().getOffset(now);
        RequestStartDate = datetime.newInstance(now.year(), 1,1);
        RequestStartDate = RequestStartDate.addSeconds(offset/1000);
        RequestEndDate = now.addSeconds(offset/1000);
        
        RequestEndDate = RequestEndDate.addDays(2);
        
        Date RequestStartOnlyDate = RequestStartDate.Date();
        Date RequestEndOnlyDate = RequestEndDate.Date();
        
        System.debug('RequestStartOnlyDate : ' + RequestStartOnlyDate);
        System.debug('RequestEndOnlyDate : ' + RequestEndOnlyDate);
        
        ExportExcelURL = BaseURL + '/apex/ICR_Dashboard_Excel?Excel=true' + '&RequestStartDate=' + RequestStartOnlyDate + '&RequestEndDate=' + RequestEndOnlyDate + '&WorkflowStatus=All&Requester=All&CommitteeTitle=All&DocumentNo=All&CircularNo=All';
        system.debug('ExportExcelURL : ' + ExportExcelURL);
        
        DocNo = 'All';
        WorkflowStatus = 'All';
        CommitteeTitle = 'All';
        RequesterName = 'All';
        CircularNo = 'All';
        
        //Default Picklist Filter
        RequesterNames = new Set<string>();
        RequesterNames.add('All');
        
        CommitteeTitles = new Set<string>();
        CommitteeTitles.add('All');
        
        DocNos = new Set<string>();
        DocNos.add('All');
        
        CircularNos = new Set<string>();
        CircularNos.add('All');
    
        System.debug(RequestStartOnlyDate);
        System.debug(RequestEndOnlyDate);
        
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
            
            List<PISUsers__c> LoggedInUsers = new List<PISUsers__c>();
            
            LoggedInUsers = [select id, user__c, subcordinate__c from PISUsers__c where User__c =: userId];
            
            if(LoggedInUsers.size() > 0) {
                LoggedInUser = LoggedInUsers[0];
            }
            
            if(!string.isBlank(LoggedInUser.Subcordinate__c)) {
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
                        finished_date__c, Owner.FirstName, Owner.LastName, OwnerId, type__c, active__c, committee_title__c, be_line_manager_id__c, be_evp_id__c, employee_id__c, owner_full_name__c
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
                        finished_date__c, Owner.FirstName, Owner.LastName, OwnerId, type__c, active__c, committee_title__c, be_line_manager_id__c, be_evp_id__c,
                        owner_full_name__c from ICR_Approval__c where Id IN: ICRIds order by Createddate desc];
                        
            }
        }
        else {
        
            ICRApprovals = [select id, name, status__c, owner.name, circular_no__c, createddate, start_date__c, end_date__c, 
                        finished_date__c, Owner.FirstName, Owner.LastName, type__c, active__c, committee_title__c, owner_full_name__c from ICR_Approval__c where createddate >=: RequestStartOnlyDate AND
                        createddate <=: RequestEndOnlyDate order by Createddate desc];
                        
        }
        
                        
        ICRSize = ICRApprovals.size();
        System.debug('ICRSize : ' + ICRSize);
        
        CalculateProgressNo(ICRApprovals);
        CalculateCommitteeRequestStatus(ICRApprovals);
        CalculateCommitteeApprovalType(ICRApprovals);
        CalculateNumberOfComittee(ICRApprovals);
        CalculateICRTable(ICRApprovals);
    }
    
    public ProgressNoWrapper CalculateProgressNo(List<ICR_Approval__c> ICRApprovals) {
        
        PNW = new ProgressNoWrapper();
        PNW.Total = 0;
        PNW.InProgress = 0;
        PNW.Cancelled = 0;
        PNW.Appointed = 0;
        PNW.Disappointed = 0;
        
        for(ICR_Approval__c ICRStatus : ICRApprovals) {
            
            //Requester
            string requesterName = ICRStatus.Owner_Full_Name__c;
            RequesterNames.add(PISIndicators.get(requesterName));
            
            //Committee Title
            CommitteeTitles.add(ICRStatus.Committee_Title__c);
            
            //Doc No
            DocNos.add(ICRStatus.Name);
            
            //Circular No
            CircularNos.add(ICRStatus.Circular_No__c);
        
            
            if(ICRStatus.Status__c == 'Waiting Requester Revise' || ICRStatus.Status__c == 'Waiting Line Manager Approval' || ICRStatus.Status__c == 'Waiting Submit Approval Type'
                || ICRStatus.Status__c == 'Waiting GSCS Approval' || ICRStatus.Status__c == 'Waiting Requester Update Result' || ICRStatus.Status__c == 'Waiting EVP Approval' 
                || ICRStatus.Status__c == 'Waiting Circular No.' || ICRStatus.Status__c == 'Waiting Signed Circular File') {
                
                PNW.InProgress = PNW.InProgress + 1;
                
            }
            else if(ICRStatus.Status__c == 'Cancelled Request') {
                PNW.Cancelled = PNW.Cancelled + 1;
            }
            else if(ICRStatus.Status__c == 'Appointed') {
                PNW.Appointed = PNW.Appointed + 1;
            }
            else if(ICRStatus.Status__c == 'Disappointed') {
                PNW.Disappointed = PNW.Disappointed + 1;
            }
            
            PNW.Total = PNW.InProgress + PNW.Cancelled + PNW.Appointed + PNW.Disappointed;
            
        }
        
        return PNW;
        
    }
    
    public List<CommitteeRequestStatusWrapper> CalculateCommitteeRequestStatus(List<ICR_Approval__c> ICRApprovals) {
        
        CSWs = new List<CommitteeRequestStatusWrapper>();
        
        integer WRR = 0;
        integer WLMA = 0;
        integer WSAT = 0;
        integer WGSCSA = 0;
        integer WRUR = 0;
        integer WEVPA = 0;
        integer WCN = 0;
        integer WSCF = 0;
        integer Cancelled = 0;
        integer Appointed = 0;
        integer Disappointed = 0;
        
        for(ICR_Approval__c ICRStatus : ICRApprovals) {
            
            if(ICRStatus.Status__c == 'Waiting Requester Revise') {
                WRR = WRR + 1;
            }
            
            if(ICRStatus.Status__c == 'Waiting Line Manager Approval') {
                WLMA = WLMA + 1;
            } 
            
            if(ICRStatus.Status__c == 'Waiting Submit Approval Type') {
                WSAT = WSAT + 1;
            }
            
            if(ICRStatus.Status__c == 'Waiting GSCS Approval') {
                WGSCSA = WGSCSA + 1;
            } 
            
            if(ICRStatus.Status__c == 'Waiting Requester Update Result') {
                WRUR = WRUR + 1;
            }
            
            if(ICRStatus.Status__c == 'Waiting EVP Approval') {
                WEVPA = WEVPA + 1;
            }
            
            if(ICRStatus.Status__c == 'Waiting Circular No.') {
                WCN = WCN + 1;
            }
            
            if(ICRStatus.Status__c == 'Waiting Signed Circular File') {
                WSCF = WSCF + 1; 
            }
            
            if(ICRStatus.Status__c == 'Cancelled Request') {
                Cancelled = Cancelled + 1;
            }
            
            if(ICRStatus.Status__c == 'Appointed') {
                Appointed = Appointed + 1;
            }
            
            if(ICRStatus.Status__c == 'Disappointed') {
                Disappointed = Disappointed + 1;
            }
            
        }
        
        CommitteeRequestStatusWrapper CRSW1 = new CommitteeRequestStatusWrapper();
        CRSW1.StatusName = 'Waiting Requester Revise';
        CRSW1.StatusCount = WRR;
        CSWs.add(CRSW1);
        
        CommitteeRequestStatusWrapper CRSW2 = new CommitteeRequestStatusWrapper();
        CRSW2.StatusName = 'Waiting Line Manager Approval';
        CRSW2.StatusCount = WLMA;
        CSWs.add(CRSW2);
        
        CommitteeRequestStatusWrapper CRSW3 = new CommitteeRequestStatusWrapper();
        CRSW3.StatusName = 'Waiting Submit Approval Type';
        CRSW3.StatusCount = WSAT;
        CSWs.add(CRSW3);
        
        CommitteeRequestStatusWrapper CRSW4 = new CommitteeRequestStatusWrapper();
        CRSW4.StatusName = 'Waiting GSCS Approval';
        CRSW4.StatusCount = WGSCSA;
        CSWs.add(CRSW4);
        
        CommitteeRequestStatusWrapper CRSW5 = new CommitteeRequestStatusWrapper();
        CRSW5.StatusName = 'Waiting Requester Update Result';
        CRSW5.StatusCount = WRUR;
        CSWs.add(CRSW5);
        
        CommitteeRequestStatusWrapper CRSW6 = new CommitteeRequestStatusWrapper();
        CRSW6.StatusName = 'Waiting EVP Approval';
        CRSW6.StatusCount = WEVPA;
        CSWs.add(CRSW6);
        
        CommitteeRequestStatusWrapper CRSW7 = new CommitteeRequestStatusWrapper();
        CRSW7.StatusName = 'Waiting Circular No.';
        CRSW7.StatusCount = WCN;
        CSWs.add(CRSW7);
        
        CommitteeRequestStatusWrapper CRSW8 = new CommitteeRequestStatusWrapper();
        CRSW8.StatusName = 'Waiting Signed Circular File';
        CRSW8.StatusCount = WSCF;
        CSWs.add(CRSW8);
        
        CommitteeRequestStatusWrapper CRSW9 = new CommitteeRequestStatusWrapper();
        CRSW9.StatusName = 'Cancelled Request';
        CRSW9.StatusCount = Cancelled;
        CSWs.add(CRSW9);
        
        CommitteeRequestStatusWrapper CRSW10 = new CommitteeRequestStatusWrapper();
        CRSW10.StatusName = 'Appointed';
        CRSW10.StatusCount = Appointed;
        CSWs.add(CRSW10);
        
        CommitteeRequestStatusWrapper CRSW11 = new CommitteeRequestStatusWrapper();
        CRSW11.StatusName = 'Disappointed';
        CRSW11.StatusCount = Disappointed;
        CSWs.add(CRSW11);
        
        CommitteeRequestStatusWrapper CRSW12 = new CommitteeRequestStatusWrapper();
        CRSW12.StatusName = 'All Internal Committee Request';
        CRSW12.StatusCount = WRR + WLMA + WSAT + WGSCSA + WRUR + WEVPA + WCN + WSCF + Cancelled + Appointed + Disappointed;
        CSWs.add(CRSW12);
        
        return CSWs;
        
    }
    
    public List<CommitteeApprovalTypeWrapper> CalculateCommitteeApprovalType(List<ICR_Approval__c> ICRApprovals) {
        
        CATWs = new List<CommitteeApprovalTypeWrapper>();
        
        integer AMMInProgress = 0;
        integer AMMAppointed = 0;
        integer AMMDisappointed = 0;
        integer CEOInProgress = 0;
        integer CEOAppointed = 0;
        integer CEODisappointed = 0;
        integer OtherDisappointed = 0;
        integer WaitingInProgress = 0;
        
        for(ICR_Approval__c ICRStatus : ICRApprovals) {
            
            if(ICRStatus.Status__c == 'Waiting Requester Revise' || ICRStatus.Status__c == 'Waiting Line Manager Approval' || ICRStatus.Status__c == 'Waiting Submit Approval Type') {
                WaitingInProgress = WaitingInProgress + 1;
            }
            
            if(ICRStatus.Status__c == 'Waiting GSCS Approval' || ICRStatus.Status__c == 'Waiting Requester Update Result' || ICRStatus.Status__c == 'Waiting EVP Approval' || ICRStatus.Status__c == 'Waiting Circular No.'
                || ICRStatus.Status__c == 'Waiting Signed Circular File') {
                if(ICRStatus.Type__c == 'AMM') {
                    AMMInProgress = AMMInProgress + 1;
                }
                else if(ICRStatus.Type__c == 'CEO') {
                    CEOInProgress = CEOInProgress + 1;
                }
            }
            
            if(ICRStatus.Status__c == 'Appointed') {
                if(ICRStatus.Type__c == 'AMM') {
                    AMMAppointed = AMMAppointed + 1;
                }
                else if(ICRStatus.Type__c == 'CEO') {
                    CEOAppointed = CEOAppointed + 1;
                }
            }
            
            if(ICRStatus.Status__c == 'Disappointed') {
            
                if(ICRStatus.Type__c == 'AMM') {
                    AMMDisappointed = AMMDisappointed + 1;
                }
                else if(ICRStatus.Type__c == 'CEO') {
                    CEODisappointed = CEODisappointed + 1;
                }
                else if(ICRStatus.Type__c == 'Other') {
                    OtherDisappointed = OtherDisappointed + 1;
                }
            }
            
        }
        
        CommitteeApprovalTypeWrapper CATWAMM = new CommitteeApprovalTypeWrapper();
        CATWAMM.ApprovalName = 'AMM';
        CATWAMM.InProgress = AMMInProgress;
        CATWAMM.Appointed = AMMAppointed;
        CATWAMM.Disappointed = AMMDisappointed;
        CATWs.add(CATWAMM);
        
        CommitteeApprovalTypeWrapper CATWCEO = new CommitteeApprovalTypeWrapper();
        CATWCEO.ApprovalName = 'CEO';
        CATWCEO.InProgress = CEOInProgress;
        CATWCEO.Appointed = CEOAppointed;
        CATWCEO.Disappointed = CEODisappointed;
        CATWs.add(CATWCEO);
        
        CommitteeApprovalTypeWrapper CATWOther = new CommitteeApprovalTypeWrapper();
        CATWOther.ApprovalName = 'Other';
        CATWOther.Disappointed = OtherDisappointed;
        CATWs.add(CATWOther);
        
        CommitteeApprovalTypeWrapper CATWWaiting = new CommitteeApprovalTypeWrapper();
        CATWWaiting.ApprovalName = 'Waiting Submit Type';
        CATWWaiting.InProgress = WaitingInProgress;
        CATWs.add(CATWWaiting);
        
        return CATWs;
        
    }
    
    public NumberOfCommitteeWrapper CalculateNumberOfComittee(List<ICR_Approval__c> ICRApprovals) {
        
        NOCW = new NumberOfCommitteeWrapper();
        NOCW.Expired = 0;
        NOCW.Active = 0;
        
        Datetime now = Datetime.now();
        TodayDate = now;
        
        for(ICR_Approval__c ICRAppointed : ICRApprovals) {
            
            if(ICRAppointed.Status__c == 'Appointed' && ICRAppointed.Active__c == false && ICRAppointed.Start_Date__c < todayDate && 
                ICRAppointed.End_Date__c != null && ICRAppointed.End_Date__c < todayDate) {
                NOCW.Expired = NOCW.Expired + 1;
            }
            /* else if(ICRAppointed.Status__c == 'Appointed' && ICRAppointed.Active__c == false && ICRAppointed.Start_Date__c < todayDate && ICRAppointed.End_Date__c == null) {
                NOCW.Expired = NOCW.Expired + 1;
            } */
            else if(ICRAppointed.Status__c == 'Appointed' && ICRAppointed.Active__c == true) {
                NOCW.Active = NOCW.Active + 1;
            }
            
        }
        
        return NOCW;
        
    }
    
    public List<ICRTableWrapper> CalculateICRTable(List<ICR_Approval__c> ICRApprovals) {
        
        ICRTWs = new List<ICRTableWrapper>();
        
        for(ICR_Approval__c ICR : ICRApprovals) {
             
            ICRTableWrapper ICRTable = new ICRTableWrapper();
            ICRTable.DocumentNo = ICR.Name;
            ICRTable.DocumentLink = BaseURL + 'lightning/r/ICR_Approval__c/' + ICR.Id + '/view';
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
            
            string requesterName = ICR.Owner_Full_Name__c;
            
            ICRTable.RequesterName = PISIndicators.get(requesterName); //+ ICR.Owner.FirstName + ' ' + ICR.Owner.LastName;
            ICRTable.CircularNo = ICR.Circular_No__c;
            ICRTable.RequestDate = ICR.CreatedDate;
            ICRTable.EffectiveStartDate = ICR.Start_Date__c;
            ICRTable.EffectiveEndDate = ICR.End_Date__c;
            ICRTable.FinishedDate = ICR.Finished_Date__c;
            ICRTable.ApprovalHistoryLink = BaseURL + 'lightning/r/ProcessInstanceHistory/' + ICR.Id + '/related/ProcessSteps/view';
            ICRTWs.add(ICRTable);
        
        }
        
        return ICRTWs;
        
    }
    
    public void FromSearch() {
        
        boolean isFilterSearch = false;
        boolean isSearchNotFound = false;
        
        RequestStartDate = (DateTime)JSON.deserialize('"' + InputRequestStartDate + '"', DateTime.class);
        RequestEndDate = (DateTime)JSON.deserialize('"' + InputRequestEndDate + '"', DateTime.class);
        
        Date RequestStartOnlyDate = RequestStartDate.Date();
        Date RequestEndOnlyDate = RequestEndDate.addDays(2).Date();
        
        System.debug(RequestStartOnlyDate);
        System.debug(RequestEndOnlyDate);
        
        if(WorkflowStatus == 'notSubmit') {
            WorkflowStatus = 'Not Submit';
        }
        else if(WorkflowStatus == 'waitingRequesterRevise') {
            WorkflowStatus = 'Waiting Requester Revise';
        }
        else if(WorkflowStatus == 'waitingLineManagerApproval') {
            WorkflowStatus = 'Waiting Line Manager Approval';
        }
        else if(WorkflowStatus == 'waitingSubmitApprovalType') {
            WorkflowStatus = 'Waiting Submit Approval Type';
        }
        else if(WorkflowStatus == 'waitingGSCSApproval') {
            WorkflowStatus = 'Waiting GSCS Approval';
        }
        else if(WorkflowStatus == 'waitingRequesterUpdateResult') {
            WorkflowStatus = 'Waiting Requester Update Result';
        }
        else if(WorkflowStatus == 'waitingEVPApproval') {
            WorkflowStatus = 'Waiting EVP Approval';
        }
        else if(WorkflowStatus == 'waitingCircularNo') {
            WorkflowStatus = 'Waiting Circular No.';
        }
        else if(WorkflowStatus == 'waitingSignedCircularFile') {
            WorkflowStatus = 'Waiting Signed Circular File';
        }
        else if(WorkflowStatus == 'cancelledRequest') {
            WorkflowStatus = 'Cancelled Request';
        }
        else if(WorkflowStatus == 'appointed') {
            WorkflowStatus = 'Appointed';
        }
        else if(WorkflowStatus == 'disappointed') {
            WorkflowStatus = 'Disappointed';
        }
        
        List<ICR_Approval__c> FilterICRs = new List<ICR_Approval__c>();
        Set<Id> ICRApprovalIds = new Set<Id>();
        
        //Filter
        
        if(!isShowAll && !isGSCSStaff && !isGSCS && !isPMSV) {
       
            ICRApprovals = [select id, name, status__c, owner.name, circular_no__c, createddate, start_date__c, end_date__c, Owner_Full_Name__c,
                        finished_date__c, Owner.FirstName, Owner.LastName, type__c, active__c, committee_title__c from ICR_Approval__c where createddate >=: RequestStartOnlyDate AND
                        createddate <=: RequestEndOnlyDate AND Id IN: ICRIds order by Createddate desc];
            
        }
        else {
        
            ICRApprovals = [select id, name, status__c, owner.name, circular_no__c, createddate, start_date__c, end_date__c, Owner_Full_Name__c,
                        finished_date__c, Owner.FirstName, Owner.LastName, type__c, active__c, committee_title__c from ICR_Approval__c where createddate >=: RequestStartOnlyDate AND
                        createddate <=: RequestEndOnlyDate order by Createddate desc];
        
        }
        
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
            
                        string requesterFullName = ICRApproval.Owner_Full_Name__c;
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
                        finished_date__c, Owner.FirstName, Owner.LastName, owner_full_name__c, type__c, active__c, committee_title__c from ICR_Approval__c where Id IN: ICRApprovalIds];
                        
        }
        else if(ICRApprovalIds.size() == 0 && isFilterSearch == true) {
            ICRApprovals = new List<ICR_Approval__c>();
        }
        
        ExportExcelURL = 'https://thaioil--devicr--c.visualforce.com/apex/ICR_Dashboard_Excel?Excel=true' + '&RequestStartDate=' + RequestStartOnlyDate + '&RequestEndDate=' + RequestEndOnlyDate + '&WorkflowStatus=' + WorkflowStatus + '&Requester=' + RequesterName + '&CommitteeTitle=' + CommitteeTitle + '&DocumentNo=' + DocNo + '&CircularNo=' + CircularNo;
        
        ICRSize = ICRApprovals.size();
        
        RequesterNames = new Set<string>();
        RequesterNames.add('All');
        
        CommitteeTitles = new Set<string>();
        CommitteeTitles.add('All');
        
        DocNos = new Set<string>();
        DocNos.add('All');
        
        CircularNos = new Set<string>();
        CircularNos.add('All');
        
        CalculateProgressNo(ICRApprovals);
        CalculateCommitteeRequestStatus(ICRApprovals);
        CalculateCommitteeApprovalType(ICRApprovals);
        CalculateNumberOfComittee(ICRApprovals);
        CalculateICRTable(ICRApprovals);
        
    }
    
    
    public void sortByDocumentNo() {
    
        if(!sortByDocumentNoDesc) {
            sortByDocumentNoHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.DOCUMENTNO_SORT;
            
            sortByDocumentNoDesc = false;
        }
        else {
            sortByDocumentNoHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.DOCUMENTNO_SORT_DESC;
            
            sortByDocumentNoDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByWorkflowStatusHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByRequesterHeader = '';
        sortByCircularNoHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByFinishedDateHeader = '';
        sortByApprovalTypeHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByWorkflowStatusDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByRequesterDesc = false;
        sortByCircularNoDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByFinishedDateDesc = false;
        sortByApprovalTypeDesc = false;
        sortByActiveStatusDesc = false;
        
    }
    
    public void sortByWorkflowStatus() {
    
        if(!sortByWorkflowStatusDesc) {
            sortByWorkflowStatusHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.WORKFLOWSTATUS_SORT;
            
            sortByWorkflowStatusDesc = false;
        }
        else {
            sortByWorkflowStatusHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.WORKFLOWSTATUS_SORT_DESC;
            
            sortByWorkflowStatusDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByRequesterHeader = '';
        sortByCircularNoHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByFinishedDateHeader = '';
        sortByApprovalTypeHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByRequesterDesc = false;
        sortByCircularNoDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByFinishedDateDesc = false;
        sortByApprovalTypeDesc = false;
        sortByActiveStatusDesc = false;
    }
    
    public void sortByCommitteeTitle() {
    
        if(!sortByCommitteeTitleDesc) {
            sortByCommitteeTitleHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.COMMITTEETITLE_SORT;
            
            sortByCommitteeTitleDesc = false;
        }
        else {
            sortByCommitteeTitleHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.COMMITTEETITLE_SORT_DESC;
            
            sortByCommitteeTitleDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByWorkflowStatusHeader = '';
        sortByRequesterHeader = '';
        sortByCircularNoHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByFinishedDateHeader = '';
        sortByApprovalTypeHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByWorkflowStatusDesc = false;
        sortByRequesterDesc = false;
        sortByCircularNoDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByFinishedDateDesc = false;
        sortByApprovalTypeDesc = false;
        sortByActiveStatusDesc = false;
    }
    
    public void sortByApprovalType() {
    
        if(!sortByApprovalTypeDesc) {
            sortByApprovalTypeHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.APPROVALTYPE_SORT;
            
            sortByApprovalTypeDesc = false;
        }
        else {
            sortByApprovalTypeHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.APPROVALTYPE_SORT_DESC;
            
            sortByApprovalTypeDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByWorkflowStatusHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByRequesterHeader = '';
        sortByCircularNoHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByFinishedDateHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByWorkflowStatusDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByRequesterDesc = false;
        sortByCircularNoDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByFinishedDateDesc = false;
        sortByActiveStatusDesc = false;
        
    }
    
    public void sortByRequester() {
    
        if(!sortByRequesterDesc) {
            sortByRequesterHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.REQUESTER_SORT;
            
            sortByRequesterDesc = false;
        }
        else {
            sortByRequesterHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.REQUESTER_SORT_DESC;
            
            sortByRequesterDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByWorkflowStatusHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByCircularNoHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByFinishedDateHeader = '';
        sortByApprovalTypeHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByWorkflowStatusDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByCircularNoDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByFinishedDateDesc = false;
        sortByApprovalTypeDesc = false;
        sortByActiveStatusDesc = false;
        
    }
    
    public void sortByCircularNo() {
    
        if(!sortByCircularNoDesc) {
            sortByCircularNoHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.CIRCULARNO_SORT;
            
            sortByCircularNoDesc = false;
        }
        else {
            sortByCircularNoHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.CIRCULARNO_SORT_DESC;
            
            sortByCircularNoDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByWorkflowStatusHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByRequesterHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByFinishedDateHeader = '';
        sortByApprovalTypeHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByWorkflowStatusDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByRequesterDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByFinishedDateDesc = false;
        sortByApprovalTypeDesc = false;
        sortByActiveStatusDesc = false;
        
    }
    
    public void sortByRequestDate() {
    
        if(!sortByRequestDateDesc) {
            sortByRequestDateHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.REQUESTDATE_SORT;
            
            sortByRequestDateDesc = false;
        }
        else {
            sortByRequestDateHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.REQUESTDATE_SORT_DESC;
            
            sortByRequestDateDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByWorkflowStatusHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByRequesterHeader = '';
        sortByCircularNoHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByFinishedDateHeader = '';
        sortByApprovalTypeHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByWorkflowStatusDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByRequesterDesc = false;
        sortByCircularNoDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByFinishedDateDesc = false;
        sortByApprovalTypeDesc = false;
        sortByActiveStatusDesc = false;
        
    }
    
    public void sortByEffectiveStartDate() {
    
        if(!sortByEffectiveStartDateDesc) {
            sortByEffectiveStartDateHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.EFFECTIVESTARTDATE_SORT;
            
            sortByEffectiveStartDateDesc = false;
        }
        else {
            sortByEffectiveStartDateHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.EFFECTIVESTARTDATE_SORT_DESC;
            
            sortByEffectiveStartDateDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByWorkflowStatusHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByRequesterHeader = '';
        sortByCircularNoHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByFinishedDateHeader = '';
        sortByApprovalTypeHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByWorkflowStatusDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByRequesterDesc = false;
        sortByCircularNoDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByFinishedDateDesc = false;
        sortByApprovalTypeDesc = false;
        sortByActiveStatusDesc = false;
        
    }
    
    public void sortByEffectiveEndDate() {
    
        if(!sortByEffectiveEndDateDesc) {
            sortByEffectiveEndDateHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.EFFECTIVEENDDATE_SORT;
            
            sortByEffectiveEndDateDesc = false;
        }
        else {
            sortByEffectiveEndDateHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.EFFECTIVEENDDATE_SORT_DESC;
            
            sortByEffectiveEndDateDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByWorkflowStatusHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByRequesterHeader = '';
        sortByCircularNoHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByFinishedDateHeader = '';
        sortByApprovalTypeHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByWorkflowStatusDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByRequesterDesc = false;
        sortByCircularNoDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByFinishedDateDesc = false;
        sortByApprovalTypeDesc = false;
        sortByActiveStatusDesc = false;
        
    }
    
    public void sortByFinishedDate() {
    
        if(!sortByFinishedDateDesc) {
            sortByFinishedDateHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.FINISHEDDATE_SORT;
            
            sortByFinishedDateDesc = false;
        }
        else {
            sortByFinishedDateHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.FINISHEDDATE_SORT_DESC;
            
            sortByFinishedDateDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByWorkflowStatusHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByRequesterHeader = '';
        sortByCircularNoHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByApprovalTypeHeader = '';
        sortByActiveStatusHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByWorkflowStatusDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByRequesterDesc = false;
        sortByCircularNoDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByApprovalTypeDesc = false;
        sortByActiveStatusDesc = false;
        
    }
    
    public void sortByActiveStatus() {
    
        if(!sortByActiveStatusDesc) {
            sortByActiveStatusHeader = 'asc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.ACTIVESTATUS_SORT;
            
            sortByActiveStatusDesc = false;
        }
        else {
            sortByActiveStatusHeader = 'desc';
            ICR_DashboardController.SORT_BY = ICR_DashboardController.ACTIVESTATUS_SORT_DESC;
            
            sortByActiveStatusDesc = true;
        }
        
        this.ICRTWs.sort();
        
        sortByDocumentNoHeader = '';
        sortByWorkflowStatusHeader = '';
        sortByCommitteeTitleHeader = '';
        sortByApprovalTypeHeader = '';
        sortByRequesterHeader = '';
        sortByCircularNoHeader = '';
        sortByRequestDateHeader = '';
        sortByEffectiveStartDateHeader = '';
        sortByEffectiveEndDateHeader = '';
        sortByFinishedDateHeader = '';
        
        sortByDocumentNoDesc = false;
        sortByWorkflowStatusDesc = false;
        sortByCommitteeTitleDesc = false;
        sortByApprovalTypeDesc = false;
        sortByRequesterDesc = false;
        sortByCircularNoDesc = false;
        sortByRequestDateDesc = false;
        sortByEffectiveStartDateDesc = false;
        sortByEffectiveEndDateDesc = false;
        sortByFinishedDateDesc = false;
        
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
    
    @auraEnabled
    public static Id getListViewId() {
        
        Id ListViewId = [select id, name, developername, SobjectType from ListView where DeveloperName =: 'My_Request' AND SobjectType =: 'ICR_Approval__c'].Id;
        return ListViewId;
        
    }
    
    @auraEnabled
    public static Id getRecordTypeId() {
    
        Id RecordTypeId = [select id, name, developername from RecordType where DeveloperName =: 'Request'].Id;
        return RecordTypeId;
        
    }
    
    @auraEnabled
    public static string currentTheme() {
        
        string userTheme = UserInfo.getUiTheme();
        return userTheme;
        
    }
    
    @auraEnabled
    public static string getNewRequestURL() {
    
        string BaseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        Id ListViewId = getListViewId();
        Id RecordTypeId = getRecordTypeId();
        string NewRequestURL = BaseURL + 'lightning/o/ICR_Approval__c/new?count=1&nooverride=1&useRecordTypeCheck=1&navigationLocation=LIST_VIEW&uid=164377462971319777&backgroundContext=%2Flightning%2Fo%2FICR_Approval__c%2Flist%3FfilterName%3D' + ListViewId + '&recordTypeId=' + RecordTypeId;
        
        string userTheme = currentTheme();
        
        if(userTheme == 'Theme4t') {
            NewRequestURL = '/lightning/o/ICR_Approval__c/new?recordTypeId=' + RecordTypeId;
        }
        
        system.debug(NewRequestURL);
        
        return NewRequestURL;
    }

}