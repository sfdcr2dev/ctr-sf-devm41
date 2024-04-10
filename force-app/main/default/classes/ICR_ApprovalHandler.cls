/* Author Softever */
public with sharing class ICR_ApprovalHandler {

    public string EmployeeID {get;set;}
    public List<PISUsers__c> AllReportToPOSs {get;set;}
    public List<PISUsers__c> AllSubCordinates {get;set;}

    public void AllReportToID() {
        
        List<PISUsers__c> AllPISUsers = [select id, name, ReportToPOS__c , POSID__c, employeeid__c from PISUsers__c];
        AllReportToPOSs = new List<PISUsers__c>();
        
        PISUsers__c FirstUser = [select id, name, POSID__c, employeeid__c, function__c, department__c, sections__c, units__c, level__c, orgid__c,
                                objenfullname__c, enfirstname__c, enlastname__c, holderposition__c, reporttopos__c, reporttoid__c, reporttoname__c, sectheadupposid__c, 
                                sectheadupid__c, sectheadupname__c from PISUsers__c where employeeid__c =: EmployeeID AND active__c = true AND mainposition__c = true];
                                
        AllReportToPOSs.add(FirstUser);
        
        string tempReportToPOS  = FirstUser.ReportToPOS__c;
        string tempReportToSFId = '';
        
        boolean isBreak = false;
        
        while(!isBreak) {
            
            List<PISUsers__c> LineUsers = [select id, name , POSID__c, employeeid__c, function__c, department__c, sections__c, units__c, level__c, orgid__c,
                                objenfullname__c, enfirstname__c, enlastname__c, holderposition__c, reporttopos__c, reporttoid__c, reporttoname__c, sectheadupposid__c, 
                                sectheadupid__c, sectheadupname__c, reporttouser__c from PISUsers__c where (posid__c =: tempReportToPOS) AND posid__c != null AND active__c = true AND mainposition__c = true];
                       
            if(LineUsers.size() > 0) {
            
                AllReportToPOSs.add(LineUsers[0]);
                tempReportToPOS = LineUsers[0].ReportToPOS__c;
                //tempReportToSFId = LineUsers[0].ReportToUser__c;
                
                System.debug(LineUsers[0].ReportToPOS__c);
            
                if(LineUsers[0].reporttopos__c != null) {
                    
                }       
                else {
                    isBreak = true;
                } 
            }
            else {
                
                List<PISUsers__c> LineUserIds = [select id, name , POSID__c, employeeid__c, function__c, department__c, sections__c, units__c, level__c, orgid__c,
                                objenfullname__c, enfirstname__c, enlastname__c, holderposition__c, reporttopos__c, reporttoid__c, reporttoname__c, sectheadupposid__c, 
                                sectheadupid__c, sectheadupname__c, reporttouser__c from PISUsers__c where holderposition__c != null AND active__c = true AND mainposition__c = true];
                
                if(LineUserIds.size() > 0) {
                
                    for(PISUsers__c PIS : LineUserIds) {
                    
                        boolean foundPIS = PIS.holderposition__c.contains(tempReportToPOS);
                        
                        if(foundPIS) {
                            AllReportToPOSs.add(PIS);
                            tempReportToPOS = PIS.ReportToPOS__c;
                            
                            if(PIS.reporttopos__c != null) {
                                
                            }       
                            else {
                                isBreak = true;
                            } 
                            //break;
                            
                        }
                    }
                }
                
            }
        }
        
    }
    
    public void AllCordinate() {
        
        Map<decimal,string> LevelNos = new Map<decimal,string>();
        Map<string,boolean> LevelNoFinds = new Map<string,boolean>();
        
        PISUsers__c FirstUser = [select id, name, POSID__c, employeeid__c, function__c, department__c, sections__c, units__c, level__c, orgid__c,
                                objenfullname__c, enfirstname__c, enlastname__c, holderposition__c, reporttopos__c, reporttoid__c, reporttoname__c, sectheadupposid__c, 
                                sectheadupid__c, sectheadupname__c, subcordinate__c, level_no__c from PISUsers__c where posid__c =: EmployeeID AND active__c = true AND mainposition__c = true];
        
        AllReportToPOSs = new List<PISUsers__c>();
        
        
        /* AllReportToPOSs = [select id, name, posid__c, employeeid__c, function__c, department__c, sections__c, units__c, level__c, orgid__c,
                                objenfullname__c, enfirstname__c, enlastname__c, holderposition__c, reporttopos__c, reporttoid__c, reporttoname__c, sectheadupposid__c, 
                                sectheadupid__c, sectheadupname__c, subcordinate__c, level_no__c from PISUsers__c where reporttopos__c =: EmployeeID]; */
        
        decimal level = 1;
        decimal levelRunning = 1;
        
        //Entered POSID
        LevelNos.put(level, EmployeeID);
        LevelNoFinds.put(EmployeeID, false);
        
        FirstUser.level_no__c = level;
        AllReportToPOSs.add(FirstUser);
        
        if(AllReportToPOSs.size() == 1) {
        
            boolean isBreak = false;
            
            integer i = 1;
        
            while(i <= 10) {
            System.debug(LevelNos);
                
                for(string posid : LevelNos.values()) {
                
                    System.debug('----1');
                    System.debug('----2 : ' + posid);
                
                    boolean isSearch = LevelNoFinds.get(posid);
                    
                    if(!isSearch) {
                    
                        LevelNoFinds.put(posid, true);
                    
                        List<PISUsers__c> ReportToPoses = [select id, name, posid__c, employeeid__c, function__c, department__c, sections__c, units__c, level__c, orgid__c,
                                objenfullname__c, enfirstname__c, enlastname__c, holderposition__c, reporttopos__c, reporttoid__c, reporttoname__c, sectheadupposid__c, 
                                sectheadupid__c, sectheadupname__c, subcordinate__c, level_no__c from PISUsers__c where reporttopos__c =: posid AND active__c = true AND mainposition__c = true];
                        
                        if(ReportToPoses.size() > 0) {
                        
                            System.debug('----3');
                        
                            for(PISUsers__c reporttopos : ReportToPoses) {
                            
                                System.debug('----4');
                                System.debug('reporttopos.posid__c : ' + reporttopos.posid__c);
                                
                                reporttopos.Level_No__c = Decimal.ValueOf(level + '.' + levelRunning);  
                                levelRunning++;
                                
                                LevelNos.put(Decimal.ValueOf(level + '.' + levelRunning), reporttopos.posid__c);
                                LevelNoFinds.put(reporttopos.posid__c, false);
                                
                                AllReportToPOSs.add(reporttopos);
                                
                            }
                            
                            level++;
                            levelRunning = 1;
                        
                        }
                        else {
                            System.debug('POSID not found');
                            LevelNoFinds.put(posid, true);
                        }
                    }
                    
                }
                
                //isBreak = LevelNos.values().contains('false');
                
                i++;
                //isBreak = true;
            }
            
        
            System.debug(LevelNos);
            System.debug(LevelNoFinds);
        }
        
        /* if(FirstUser != null) {
            
            List<string> subcordinates = new List<string>();
            
            if(string.isNotBlank(FirstUser.Subcordinate__c)) {
                FirstUser.Subcordinate__c = FirstUser.Subcordinate__c.replace('[', '');
                FirstUser.Subcordinate__c = FirstUser.Subcordinate__c.replace(']', '');
                FirstUser.Subcordinate__c = FirstUser.Subcordinate__c.replace('"', '');
                subcordinates = FirstUser.Subcordinate__c.split(',');
            }
            
            system.debug(subcordinates);
            
            AllReportToPOSs = [select id, name , POSID__c, employeeid__c, function__c, department__c, sections__c, units__c, level__c, orgid__c,
                                objenfullname__c, enfirstname__c, enlastname__c, holderposition__c, reporttopos__c, reporttoid__c, reporttoname__c, sectheadupposid__c, 
                                sectheadupid__c, sectheadupname__c, reporttouser__c from PISUsers__c where employeeid__c IN: subcordinates];
            
            system.debug(AllReportToPOSs.size());
        } */
    }
    
    public void LockICRRecord() {
        
        List<ICR_Approval__c> ICRApprovals = [select id, name from ICR_Approval__c];
        
        Approval.LockResult[] lrList = Approval.lock(ICRApprovals, false);

        if(lrList.size() > 0) {
            for(Approval.LockResult lr : lrList) { 
                
                System.debug(lr);
                
            }
        }
        
    }
    
    public void UnlockICRRecordById(Id ICRId) {
        
        List<ICR_Approval__c> ICRApprovals = [select id, name from ICR_Approval__c where id =: ICRId];
        
        Approval.UnlockResult[] lrList = Approval.unlock(ICRApprovals, false);

        if(lrList.size() > 0) {
            for(Approval.UnlockResult lr : lrList) { 
                
                if(lr.isSuccess()) {
                    System.debug(lr.getId());
                }
                
                
            }
        }
        
    }
    
    public void StatusOnInsert(List<ICR_Approval__c> ICRs) {
        
        ICR_Approval__c ICR = ICRs[0];
        ICR.Status__c = 'Not Submit';
        
        Date todayDate = date.today();
        String userLocale = UserInfo.getLocale();
        integer currentYear = 0;
        
        boolean isThaiLocale = userLocale.contains('th');
        if(isThaiLocale) {
            currentYear = todayDate.year() - 543;
        }
        else {
            currentYear = todayDate.year();
        }
        
        ICR_Config__c ICRConfig = [select id, Document_No_Year__c, Expire_Committee_Reminder__c, Document_No_Running__c from ICR_Config__c];
        if(string.valueOf(currentYear) != ICRConfig.Document_No_Year__c) {
            ICRConfig.Document_No_Year__c = string.valueOf(currentYear);
            ICRConfig.Document_No_Running__c = '0';
        }
        
        string actualDocNo = '';
        integer DocNo = integer.valueOf(ICRConfig.Document_No_Running__c) + 1;
        if(DocNo > 0 && DocNo < 10) {
            actualDocNo = '00' + DocNo;
        }
        else if(DocNo >= 10 && DocNo < 100) {
            actualDocNo = '0' + DocNo;
        }
        else {
            actualDocNo = string.valueOf(DocNo);
        }
        
        ICRConfig.Document_No_Running__c = actualDocNo;
        update(ICRConfig);
        
        //ICR.Document_No__c = currentYear + '-' + ICRConfig.Document_No_Running__c;
        
        //Assign GSCS Staff
        Group GSCSStaffGroup = [select id, developername from Group where developername =: 'ICR_GSCS_STAFF'];
        List<GroupMember> GSCSStaffUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSStaffGroup.Id];
                    
        List<Id> GSCSStaffUserIds = new List<Id>();
        if(GSCSStaffUsers.size() > 0) {
            for(GroupMember GSCSStaff : GSCSStaffUsers) {
                ICR.BE_GSCS_Staff_ID__c = GSCSStaff.UserOrGroupId;
            }
        }
        
        //Assign GSCS
        //User GSCS = [select id, email, username from User where username = 'narisaram@thaioilgroup.com.devicr'];
        //ICR.BE_GSCS_ID__c = GSCS.Id;
        Group GSCSGroup = [select id, developername from Group where developername =: 'ICR_GSCS'];
        List<GroupMember> GSCSUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSGroup.Id];
                    
        List<Id> GSCSUserIds = new List<Id>();
        if(GSCSUsers.size() > 0) {
            for(GroupMember GSCS : GSCSUsers) {
                ICR.BE_GSCS_ID__c = GSCS.UserOrGroupId;
            }
        }
        
        //Assign GSVP
        //User GSVP = [select id, email, username from User where username = 'nikom.ko@thaioilgroup.com.devicr'];
        //ICR.BE_GSVP_ID__c = GSVP.Id;
        Group GSVPGroup = [select id, developername from Group where developername =: 'ICR_GSVP'];
        List<GroupMember> GSVPUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSVPGroup.Id];
                    
        List<Id> GSVPUserIds = new List<Id>();
        if(GSVPUsers.size() > 0) {
            for(GroupMember GSVP : GSVPUsers) {
                ICR.BE_GSVP_ID__c = GSVP.UserOrGroupId;
            }
        }
    }
    
    public void StatusICRActive(List<ICR_Approval__c> newICRs, List<ICR_Approval__c> oldICRs) {
        
        Date todayDate = date.today();
        ICR_Approval__c oldICR = oldICRs[0];
        ICR_Approval__c newICR = newICRs[0];
        
        if(newICR.Status__c == 'Appointed' && newICR.Start_Date__c <= todayDate && oldICR.Active__c == false) {
            
            newICR.Active__c = true;
            
        }
        
    }
    
    public void UnlockICRRecord(List<ICR_Approval__c> ICRs) {
        
        Approval.UnlockResult[] lrList = Approval.unlock(ICRs, false);

        if(lrList.size() > 0) {
            for(Approval.UnlockResult lr : lrList) { 
                if(lr.isSuccess()) {
                    System.debug(lr.getId());
                }
            }
        }
        
    }
    
    public void FindingLineManager(List<ICR_Approval__c> ICRs) {
        
        ICR_Approval__c ICR = ICRs[0];
        Id userId = ICR.OwnerId;
        
        PISUsers__c Requester = [select id, User__c, User__r.Id, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where User__c =: userId AND active__c = true AND mainposition__c = true];
        
        string RequesterLevel = Requester.LEVEL__c;

        try {
            
            if(RequesterLevel == 'Junior') {
            
                Requester = [select id, User__c, User__r.Id, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                RequesterLevel = Requester.LEVEL__c;
                
            }
            
            if(RequesterLevel == 'Senior') {
                Requester = [select id, User__c, User__r.Id, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                RequesterLevel = Requester.LEVEL__c;
            }
            
            if(RequesterLevel == 'Supervisor') {
                Requester = [select id, User__c, User__r.Id, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                RequesterLevel = Requester.LEVEL__c;
            }
            
            if(RequesterLevel == 'Section Head') {
                Requester = [select id, User__c, User__r.Id, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                RequesterLevel = Requester.LEVEL__c;
            }
            
            if(RequesterLevel == 'VP' || RequesterLevel == 'EVP Upward') {
                ICR.Approver__c = Requester.User__c;
                ICR.BE_Line_Manager_ID__c = Requester.User__r.Id;
            }
            
        }
        catch (Exception e) {
            ICRs[0].addError('Cannot find Line Manager of this user.');
        }
    }
    
    public void FindingEVP(List<ICR_Approval__c> ICRs) {
        
        ICR_Approval__c ICR = ICRs[0];
        Id userId = ICR.OwnerId;
        string Status = ICR.Status__c;
        
        if(Status == 'Waiting Requester Update Result') {
            
            PISUsers__c Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where User__c =: userId AND active__c = true AND mainposition__c = true];
            
            string RequesterLevel = Requester.LEVEL__c;
    
            try {
                if(RequesterLevel == 'Junior') {
                    Requester = [select id, User__c, User__r.Id , User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                    RequesterLevel = Requester.LEVEL__c;
                    System.debug('Junior : ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'Senior') {
                    Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                    RequesterLevel = Requester.LEVEL__c;
                    System.debug('Senior : ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'Supervisor') {
                    Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                    RequesterLevel = Requester.LEVEL__c;
                    System.debug('Supervisor : ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'Section Head') {
                    Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                    RequesterLevel = Requester.LEVEL__c;
                    System.debug('Section Head : ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'VP') {
                    Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                    RequesterLevel = Requester.LEVEL__c;
                    System.debug('VP : ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'EVP Upward') {
                    
                    if(ICR.Auto_Approve__c == true) {
                        
                        Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c AND active__c = true AND mainposition__c = true];
                        
                    }
                    
                    System.debug('EVP Upward : ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                    ICR.Approver__c = Requester.User__c;
                    ICR.BE_EVP_ID__c = Requester.User__r.Id;
                }
            }
            catch (Exception e) {
                ICRs[0].addError('Cannot find EVP of this user.');
            }
            
        }
        
    }
    
    /* public void FindingPMSV(List<ICR_Approval__c> ICRs) {
        
        ICR_Approval__c ICR = ICRs[0];
        Id userId = ICR.OwnerId;
        string Status = ICR.Status__c;
        
        if(Status == 'Waiting Circular No.') {
            
            PISUsers__c Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where User__c =: userId];
            
            string RequesterLevel = Requester.LEVEL__c;
    
            try 
            {
                if(RequesterLevel == 'Junior') {
                    Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c];
                    RequesterLevel = Requester.LEVEL__c;
                    System.debug('Senior : ' + RequesterLevel + ' ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'Senior') {
                    Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c];
                    RequesterLevel = Requester.LEVEL__c;
                    System.debug('Section Head : ' + RequesterLevel + ' ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'Section Head') {
                    Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c];
                    RequesterLevel = Requester.LEVEL__c;
                    System.debug('VP : ' + RequesterLevel + ' ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'VP') {
                    Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c];
                    RequesterLevel = Requester.LEVEL__c;
                    System.debug('EVP Upward : ' + RequesterLevel + ' ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'EVP Upward') {
                    Requester = [select id, User__c, User__r.Id, User__r.FirstName, User__r.LastName, Level__c, ReportToID__c, EmployeeID__c, ENFIRSTNAME__c, ENLASTNAME__c, ReportToPOS__c, POSID__c from PISUsers__c where POSID__c =: Requester.ReportToPOS__c];
                    RequesterLevel = Requester.LEVEL__c;
                    
                    ICR.Approver__c = Requester.User__c;
                    ICR.BE_PMSV_ID__c = Requester.User__r.Id;
                    
                    System.debug('Supervisor : ' + RequesterLevel + ' ' + Requester.User__r.FirstName + ' ' + Requester.User__r.LastName);
                }
                
                if(RequesterLevel == 'Supervisor') {
                    ICR.Approver__c = Requester.User__c;
                    ICR.BE_PMSV_ID__c = Requester.User__r.Id;
                }
            }
            catch (Exception e) {
                ICRs[0].addError('Cannot find PMSV of this user.');
            }
            
            
        }
        
    } */
    
    public void LineManagerAutoApprove(List<ICR_Approval__c> ICRs) {
        
        ICR_Approval__c ICR = ICRs[0];
        Id RequesterId = ICR.OwnerId;
        
        PISUsers__c PIS = [select id, User__c, Level__c from PISUsers__c where User__c =: RequesterId AND active__c = true AND mainposition__c = true];
        
        if(PIS.Level__c == 'VP' || PIS.LEVEL__c == 'EVP Upward') {
            ICR.Auto_Approve__c = true;
            ICR.Request_Date__c = system.today();
        }
        
    }
    
    public void FindingAllSubCordinate(Id RequesterId) {
        
        //Id RequesterId = ICRs[0].Id;
        PISUsers__c Requester = [select id, posid__c, reporttopos__c, user__c from PISUsers__c where User__c =: RequesterId AND active__c = true AND mainposition__c = true];
            
        Set<Id> SubCordinates = new Set<Id>();
        
        while(true) {
            
            List<PISUsers__c> PISs = [select id, posid__c, reporttopos__c, user__c from PISUsers__c where ReportToPOS__c =: Requester.POSID__c AND active__c = true AND mainposition__c = true];
                
            if(PISs.size() > 0) {
                
                for(PISUsers__c PIS : PISs) {
                    SubCordinates.add(PIS.User__c);
                }
                
            }
            else {
                break;
            }
        }
        
        if(SubCordinates.size() > 0) {
            
            for(Id SubCordinate : SubCordinates) {
                System.debug(SubCordinate);
            }
            
        }
        
    }
    
    public void CreateTask(List<ICR_Approval__c> oldICRs, List<ICR_Approval__c> newICRs) {
        
        ICR_Approval__c oldICR = oldICRs[0];
        ICR_Approval__C newICR = newICRs[0];
        
        if(oldICR.Status__c == 'Not Submit' && newICR.Status__c == 'Waiting Line Manager Approval') {
            
            Id LineManagerId = newICR.Approver__c;
            
            Task newTask = new Task();
            newTask.Subject = 'Requester has submitted ICR. You have following task to approve : ' + newICR.Name + '.' ;
            newTask.Status = 'Open';
            newTask.Priority = 'Normal';
            newTask.ActivityDate = Date.today();
            newTask.WhatId = newICR.ID;
            newTask.OwnerId = LineManagerId;
            insert(newTask);
            
        }
        else if(oldICR.Status__c == 'Waiting Line Manager Approval' && newICR.Status__c == 'Waiting Submit Approval Type') {
            
            Id GSCSStaffId;
            
            //GSCS Staff
            Group GSCSStaffGroup = [select id, developername from Group where developername =: 'ICR_GSCS_Staff'];
            List<GroupMember> GSCSStaffUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSStaffGroup.Id];
                        
            if(GSCSStaffUsers.size() > 0) {
                for(GroupMember GSCSStaff : GSCSStaffUsers) {
                    GSCSStaffId = GSCSStaff.UserOrGroupId;
                }
            }
            
            Task newTask = new Task();
            newTask.Subject = 'Line Manager has approved following ICR : ' + newICR.Name + '. You need to select approval type.' ;
            newTask.Status = 'Open';
            newTask.Priority = 'Normal';
            newTask.ActivityDate = Date.today();
            newTask.WhatId = newICR.ID;
            newTask.OwnerId = GSCSStaffId;
            insert(newTask);
            
        }
        else if(oldICR.Status__c == 'Waiting Line Manager Approval' && newICR.Status__c == 'Waiting Requester Revise') {
            
            Id RequesterId = newICR.OwnerId;
            
            Task newTask = new Task();
            newTask.Subject = 'Line Manager has rejected following ICR : ' + newICR.Name + '. You need to check and submit for approval again.' ;
            newTask.Status = 'Open';
            newTask.Priority = 'Normal';
            newTask.ActivityDate = Date.today();
            newTask.WhatId = newICR.ID;
            newTask.OwnerId = RequesterId;
            insert(newTask);
            
        }
        else if(oldICR.Status__c == 'Waiting Submit Approval Type' && newICR.Status__c == 'Waiting GSCS Approval') {
            
            Id GSCSId;
            
            //GSCS
            Group GSCSGroup = [select id, developername from Group where developername =: 'ICR_GSCS'];
            List<GroupMember> GSCSUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSGroup.Id];
                        
            if(GSCSUsers.size() > 0) {
                for(GroupMember GSCS : GSCSUsers) {
                    GSCSId = GSCS.UserOrGroupId;
                }
            }
            
            Task newTask = new Task();
            newTask.Subject = 'You have task to approve or reject for : ' + newICR.Name + '.' ;
            newTask.Status = 'Open';
            newTask.Priority = 'Normal';
            newTask.ActivityDate = Date.today();
            newTask.WhatId = newICR.ID;
            newTask.OwnerId = GSCSId;
            insert(newTask);
            
        }
        else if(oldICR.Status__c == 'Waiting GSCS Approval' && newICR.Status__c == 'Waiting Requester Update Result') {
            
            Id RequesterId = newICR.OwnerId;
            
            Task newTask = new Task();
            newTask.Subject = 'GSCS has approved following ICR : ' + newICR.Name + '. You need to update ICR.' ;
            newTask.Status = 'Open';
            newTask.Priority = 'Normal';
            newTask.ActivityDate = Date.today();
            newTask.WhatId = newICR.ID;
            newTask.OwnerId = RequesterId;
            insert(newTask);
            
        }
        else if(oldICR.Status__c == 'Waiting Circular No.' && newICR.Status__c == 'Waiting Signed Circular File') {
            
            Id GSCSStaffId;
            
            //GSCS Staff
            Group GSCSStaffGroup = [select id, developername from Group where developername =: 'ICR_GSCS_Staff'];
            List<GroupMember> GSCSStaffUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GSCSStaffGroup.Id];
                        
            if(GSCSStaffUsers.size() > 0) {
                for(GroupMember GSCSStaff : GSCSStaffUsers) {
                    GSCSStaffId = GSCSStaff.UserOrGroupId;
                }
            }
            
            Task newTask = new Task();
            newTask.Subject = 'You have to upload signed circular file for : ' + newICR.Name + '.' ;
            newTask.Status = 'Open';
            newTask.Priority = 'Normal';
            newTask.ActivityDate = Date.today();
            newTask.WhatId = newICR.ID;
            newTask.OwnerId = GSCSStaffId;
            insert(newTask);
            
        }
        else if(oldICR.Status__c == 'Waiting Requester Update Result' && newICR.Status__c == 'Waiting EVP Approval') {
            
            Id ApproverId = newICR.Approver__c;
            
            Task newTask = new Task();
            newTask.Subject = 'You have task to approve or reject for : ' + newICR.Name + '.' ;
            newTask.Status = 'Open';
            newTask.Priority = 'Normal';
            newTask.ActivityDate = Date.today();
            newTask.WhatId = newICR.ID;
            newTask.OwnerId = ApproverId;
            insert(newTask);
            
        }
        else if(oldICR.Status__c == 'Waiting EVP Approval' && newICR.Status__c == 'Waiting Circular No.') {
            
            List<Id> PMSVIds = new List<Id>();
            
            //PMSV
            Group PMSVGroup = [select id, developername from Group where developername =: 'ICR_PMSV'];
            List<GroupMember> PMSVUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PMSVGroup.Id];
                        
            if(PMSVUsers.size() > 0) {
                for(GroupMember PMSV : PMSVUsers) {
                    PMSVIds.add(PMSV.UserOrGroupId);
                }
            }
            
            if(PMSVIds.size() > 0) {
                
                for(Id PMSVId : PMSVIds) {
                    
                    Task newTask = new Task();
                    newTask.Subject = 'You have to update Circular No for : ' + newICR.Name + '.' ;
                    newTask.Status = 'Open';
                    newTask.Priority = 'Normal';
                    newTask.ActivityDate = Date.today();
                    newTask.WhatId = newICR.ID;
                    newTask.OwnerId = PMSVId;
                    insert(newTask);
                    
                }
                
            }
        }
        
    }
}