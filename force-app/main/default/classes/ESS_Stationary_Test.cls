@isTest
public with sharing class ESS_Stationary_Test {

    @testSetup
    public static void setup() {
        
        //Create user here
        User AdminPMSVUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'PASSARAWAN',
            Email = 'testpassarawan@thaioilgroup.com',
            Username = 'testpassarawan@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'PA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(AdminPMSVUser);
        
        User AdminFixAndGeneralUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'KIRANA',
            Email = 'testkirana@thaioilgroup.com',
            Username = 'testkirana@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'KI',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(AdminFixAndGeneralUser);
        
        //Project Base (Employee PM Under Section Head)
        User EmployeeUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'RAMON',
            Email = 'testramon@thaioilgroup.com',
            Username = 'testremon@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'RA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(EmployeeUser);
        
        User SectionHeadUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'DAMRONG',
            Email = 'testdamrong@thaioilgroup.com',
            Username = 'testdamrong@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'DA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test',
            Employee_Id__c = '00000001'
            );
        insert(SectionHeadUser);
        
        //Project Base (Employee PM Under Section Head) (On behalf of)
		User EmployeeUser2 = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'RATRI',
            Email = 'testratri@thaioilgroup.com',
            Username = 'testratri@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'RAT',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test',
            Employee_Id__c = '00000002'
            );
        insert(EmployeeUser2);
        
        //Project Base (Employee PM Section Head Upward) (ปกติ)
        User SectionHeadUser2 = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'SURAPHAN',
            Email = 'testsuraphan@thaioilgroup.com',
            Username = 'testsuraphan@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'SU',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(SectionHeadUser2);
        
        User VPUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'NARONGSAK',
            Email = 'testnarongsak@thaioilgroup.com',
            Username = 'testnarongsak@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'NA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
            );
        insert(VPUser);
        
        //Insert PISUser
        insertPISUsers();
        
        //Insert Public Group
        insertPublicGroup();
        
        //Insert ESS_Config
        ESS_Config__c Config = new ESS_Config__c();
        Config.Stationary_Running_No__c = '0';
        Config.Environment__c = 'PROD';
        insert(Config);
    }
    
    @future
    public static void insertPISUsers() {
        
        List<User> Users = [select id, alias, FirstName_EN__c, LastName_EN__c from User];
        
        Id RamonId; //Employee
        Id DamrongId; //Section Head
        Id RatriId; //
        Id SuraphanId;
        Id NarongsakId;
        Id UserManagerId;
        
        for(User U : Users) {
            if(U.alias == 'RA') {
                RamonId = U.Id;
            }
            else if(U.alias == 'DA') {
                DamrongId = U.Id;
            }
            else if(U.alias == 'RAT') {
                RatriId = U.Id;
            }
            else if(U.alias == 'SU') {
                SuraphanId = U.Id;
            }
            else if(U.alias == 'NA') {
                NarongsakId = U.Id;
            }
            else if(U.alias == 'KI') {
                UserManagerId = U.Id;
            }
        }
        
        PISUsers__c ramon = new PISUsers__c();
        ramon.Active__c = true;
        ramon.MAINPOSITION__c = true;
        ramon.EMPLOYEEID__c = '00000001';
        ramon.HOME_COMP__c = '1100';
        ramon.Name = 'Test Ramon';
        ramon.LEVEL__c = 'Junior';
        ramon.ORGID__c = '00000001';
        ramon.POSID__c = '00000001';
        ramon.ENFIRSTNAME__c = 'Test';
        ramon.ENLASTNAME__c = 'Test Ramon';
        ramon.HOLDERPOSITION__c = '00000001';
        ramon.EMAIL__c = 'testramon@thaioilgroup.com';
        ramon.User__c = RamonId;
        ramon.FUNCTION__c = 'AAAA';
        ramon.DEPARTMENT__c = 'BBBB';
        ramon.SECTIONS__c = 'CCCC';
        ramon.UNITS__c = 'DDDD';
        ramon.ReportToPOS__c = '00000002';
        ramon.ReportToID__c = '00000002';
        ramon.ReportToEmail__c = 'testdamrong@thaioilgroup.com';
        ramon.ReportToUser__c = DamrongId;
        ramon.SectHeadUpUser__c = DamrongId;
        ramon.SectHeadUpPosID__c = '00000002';
        ramon.Subcordinate__c = '[""]';
        insert(ramon);
        
        PISUsers__c damrong = new PISUsers__c();
        damrong.Active__c = true;
        damrong.MAINPOSITION__c = true;
        damrong.EMPLOYEEID__c = '00000002';
        damrong.HOME_COMP__c = '1600';
        damrong.Name = 'Test Damrong';
        damrong.LEVEL__c = 'Section Head';
        damrong.ORGID__c = '00000002';
        damrong.POSID__c = '00000002';
        damrong.ENFIRSTNAME__c = 'Test';
        damrong.ENLASTNAME__c = 'Test Damrong';
        damrong.HOLDERPOSITION__c = '00000002';
        damrong.EMAIL__c = 'testdamrong@thaioilgroup.com';
        damrong.User__c = DamrongId;
        damrong.ReportToPOS__c = '00000002';
        damrong.ReportToID__c = '00000002';
        damrong.ReportToEmail__c = 'testdamrong@thaioilgroup.com';
        damrong.ReportToUser__c = DamrongId;
        damrong.SectHeadUpUser__c = DamrongId;
        damrong.SectHeadUpPosID__c = '00000002';
        damrong.Subcordinate__c = '[""]';
        insert(damrong);
        
        PISUsers__c ratri = new PISUsers__c();
        ratri.Active__c = true;
        ratri.MAINPOSITION__c = true;
        ratri.EMPLOYEEID__c = '00000003';
        ratri.HOME_COMP__c = '1100';
        ratri.PERSUBAREA__c = 'Other';
        ratri.Name = 'Test Ratri';
        ratri.LEVEL__c = 'Section Head';
        ratri.ORGID__c = '00000003';
        ratri.POSID__c = '00000003';
        ratri.ENFIRSTNAME__c = 'Test';
        ratri.ENLASTNAME__c = 'Test Ratri';
        ratri.HOLDERPOSITION__c = '00000003';
        ratri.EMAIL__c = 'testratri@thaioilgroup.com';
        ratri.User__c = RatriId;
        ratri.ReportToPOS__c = '00000001';
        ratri.ReportToID__c = '00000001';
        ratri.ReportToEmail__c = 'testramon@thaioilgroup.com';
        ratri.ReportToUser__c = RamonId;
        ratri.SectHeadUpUser__c = RamonId;
        ratri.SectHeadUpPosID__c = '00000001';
        ratri.Subcordinate__c = '[""]';
        insert(ratri);
        
        PISUsers__c suraphan = new PISUsers__c();
        suraphan.Active__c = true;
        suraphan.MAINPOSITION__c = true;
        suraphan.EMPLOYEEID__c = '00000004';
        suraphan.HOME_COMP__c = '1100';
        suraphan.Name = 'Test Ratri';
        suraphan.LEVEL__c = 'Section Head';
        suraphan.ORGID__c = '00000004';
        suraphan.POSID__c = '00000004';
        suraphan.ENFIRSTNAME__c = 'Test';
        suraphan.ENLASTNAME__c = 'Test Suraphan';
        suraphan.HOLDERPOSITION__c = '00000004';
        suraphan.EMAIL__c = 'testsuraphan@thaioilgroup.com';
        suraphan.User__c = SuraphanId;
        suraphan.ReportToPOS__c = '00000001';
        suraphan.ReportToID__c = '00000001';
        suraphan.ReportToEmail__c = 'testramon@thaioilgroup.com';
        suraphan.ReportToUser__c = RamonId;
        suraphan.SectHeadUpUser__c = RamonId;
        suraphan.SectHeadUpPosID__c = '00000001';
        suraphan.Subcordinate__c = '[""]';
        insert(suraphan);
        
        PISUsers__c narongsak = new PISUsers__c();
        narongsak.Active__c = true;
        narongsak.MAINPOSITION__c = true;
        narongsak.EMPLOYEEID__c = '00000005';
        narongsak.HOME_COMP__c = '1100';
        narongsak.Name = 'Test Narongsak';
        narongsak.LEVEL__c = 'VP';
        narongsak.ORGID__c = '00000005';
        narongsak.POSID__c = '00000005';
        narongsak.ENFIRSTNAME__c = 'Test';
        narongsak.ENLASTNAME__c = 'Test Narongsak';
        narongsak.HOLDERPOSITION__c = '00000005';
        narongsak.EMAIL__c = 'testnarongsak@thaioilgroup.com';
        narongsak.User__c = NarongsakId;
        //suraphan.ReportToPOS__c = '00000001';
        //suraphan.ReportToID__c = '00000001';
        //suraphan.ReportToEmail__c = 'testramon@thaioilgroup.com';
        //suraphan.ReportToUser__c = EmployeeUser.Id;
        //suraphan.Subcordinate__c = '[""]';
        insert(narongsak);
        
        PISUsers__c userManager = new PISUsers__c();
        userManager.Active__c = true;
        userManager.MAINPOSITION__c = true;
        userManager.EMPLOYEEID__c = '00000000';
        userManager.HOME_COMP__c = '1100';
        userManager.Name = 'Test UserManager';
        userManager.LEVEL__c = 'Junior';
        userManager.ORGID__c = '00000000';
        userManager.POSID__c = '00000000';
        userManager.ENFIRSTNAME__c = 'Test';
        userManager.ENLASTNAME__c = 'Test UserManager';
        userManager.HOLDERPOSITION__c = '00000000';
        userManager.EMAIL__c = 'adminpeoc@thaioilgroup.com';
        userManager.User__c = userManagerId;
        userManager.ReportToUser__c = NarongsakId;
        insert(userManager);
    }
    
    @future
    public static void insertPublicGroup() {
        
        List<User> Users = [select id, alias from User];
        
        Id AdminPMSVId;
        Id AdminStationaryId;
        
        for(User U : Users) {
            if(U.alias == 'PA') {
                AdminPMSVId = U.Id;
            }
            else if(U.alias == 'KI') {
                AdminStationaryId = U.Id;
            }
        }
        
        //Create PMSVStationary Group
        Group pmsvAdminGroup = [select id from Group where developername = 'ESS_PMSV_Stationary'];
        GroupMember pmsvStationaryAdmin = new GroupMember();
        pmsvStationaryAdmin.UserOrGroupId = AdminStationaryId;
        pmsvStationaryAdmin.GroupId = pmsvAdminGroup.Id;
        insert(pmsvStationaryAdmin);
        //Create GSBOStationary Group
        Group pmsvGSBOAdminGroup = [select id from Group where developername = 'ESS_GSBO_Stationary'];
        GroupMember pmsvGSBOAdmin = new GroupMember();
        pmsvGSBOAdmin.UserOrGroupId = AdminStationaryId;
        pmsvGSBOAdmin.GroupId = pmsvGSBOAdminGroup.Id;
        insert(pmsvGSBOAdmin);
        
    }
    
    public static ESS_Stationary_DTO.StationaryDetailDTO initialStationaryDetail(User runAsUser) {
        
        ESS_Stationary_DTO.StationaryDetailDTO Detail = new ESS_Stationary_DTO.StationaryDetailDTO();
        Detail.onBehalfOfFlow = false;
        Detail.isOnBehalf = false;
        Detail.status = new ESS_Global.EnumValue('StationaryServiceStatus');
        Detail.status.key = ESS_Enum.StationaryServiceStatus.Draft.name();
        Detail.status.value = 'Draft';
        Detail.requesterId = runAsUser.Id;
        Detail.requesterEmployeeId = '00000002';
        Detail.requesterEmployeeName = 'Test';
        Detail.requesterEmployeeNameEN = 'Test';
        Detail.requesterEmail = 'testratri@thaioilgroup.com';
        Detail.requesterPosition = 'Test';
        Detail.requesterFunction = 'AAAA';
        Detail.requesterDepartment = 'BBBB';
        Detail.requesterSection = 'CCCC';
        Detail.requesterUnit = 'DDDD';
        Detail.userManagerId = runAsUser.Id;
        string withdrawFromStock = '[{"unit":"ชิ้น","totalPrice":0,"stockOnHand":36,"stationaryId":"A-018","recordId":"a2I9D000001JEgaUAG","quantity":1,"pricePerUnit":755,"no":1,"name":"ตู้เอกสาร 5 ชั้น โครง ขาว-ฟ้าใส ONE","attachmentFiles":[{"url":"https://thaioil--essmss--c.sandbox.vf.force.com/servlet/servlet.FileDownload?file=00P9D000007mY0PUAU&operationContext=S1","id":"00P9D000007mY0PUAU"}],"actualWithdraw":0}]';
        string withdrawOther = '[{"unit":"แพค","totalPrice":0,"stockOnHand":0,"stationaryId":null,"recordId":null,"quantity":2,"pricePerUnit":0,"no":1,"name":"Post it สีสะท้อนแสง","attachmentFiles":[{"url":"https://thaioil--essmss--c.sandbox.vf.force.com/servlet/servlet.FileDownload?file=00P9D00000BLdPQUA1&operationContext=S1","id":"00P9D00000BLdPQUA1"}],"actualWithdraw":0}]';
            
        Detail.withdraws = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(withdrawFromStock, List<ESS_Stationary_DTO.WithdrawDTO>.class);
        Detail.withdrawOthers = (List<ESS_Stationary_DTO.WithdrawDTO>)JSON.deserialize(withdrawOther, List<ESS_Stationary_DTO.WithdrawDTO>.class);    
        
        return Detail;
    }
    
    public static ESS_Stationary_DTO.StationaryDetailDTO initialOnBehalfDetail(User runAsUser, string onBehalfId) {
        
        ESS_Stationary_DTO.StationaryDetailDTO Detail = new ESS_Stationary_DTO.StationaryDetailDTO();
        Detail.status = new ESS_Global.EnumValue('StationaryServiceStatus');
        Detail.status.key = ESS_Enum.StationaryServiceStatus.Draft.name();
        Detail.status.value = 'Draft';
        Detail.requesterId = runAsUser.Id;
        Detail.requesterEmployeeId = '00000002';
        Detail.requesterEmployeeName = 'Test';
        Detail.requesterEmployeeNameEN = 'Test';
        Detail.requesterEmail = 'testratri@thaioilgroup.com';
        Detail.requesterPosition = 'Test';
        Detail.requesterFunction = 'AAAA';
        Detail.requesterDepartment = 'BBBB';
        Detail.requesterSection = 'CCCC';
        Detail.requesterUnit = 'DDDD';
        
        Detail.onBehalfOfFlow = true;
        Detail.isOnBehalf = true;
        Detail.onBehalfOfId = OnBehalfId;
        Detail.onBehalfOfEmployeeId = '00000001';
        Detail.onBehalfOfEmployeeName = 'Test';
        Detail.onBehalfOfEmployeeNameEN = 'Test';
        Detail.onBehalfOfEmail = 'testUser@thaioilgroup.com';
        Detail.onBehalfOfPosition = 'Test';
        Detail.onBehalfOfUnit = 'AAAA';
        Detail.onBehalfOfSection = 'BBBB';
        Detail.onBehalfOfDepartment = 'CCCC';
        Detail.onBehalfOfFunction = 'DDDD';
        Detail.onBehalfOfVerifying = false;
        
        return Detail;
    }
    
    public static ESS_Stationary_DTO.StationaryDetailDTO initialUserManagerDetail(User runAsUser) {
        
        ESS_Stationary_DTO.StationaryDetailDTO Detail = new ESS_Stationary_DTO.StationaryDetailDTO();
        Detail.onBehalfOfFlow = false;
        Detail.isOnBehalf = false;
        Detail.status = new ESS_Global.EnumValue('StationaryServiceStatus');
        Detail.status.key = ESS_Enum.StationaryServiceStatus.Draft.name();
        Detail.status.value = 'Draft';
        Detail.requesterId = runAsUser.Id;
        Detail.requesterEmployeeId = '00000002';
        Detail.requesterEmployeeName = 'Test';
        Detail.requesterEmployeeNameEN = 'Test';
        Detail.requesterEmail = 'testratri@thaioilgroup.com';
        Detail.requesterPosition = 'Test';
        Detail.requesterFunction = 'AAAA';
        Detail.requesterDepartment = 'BBBB';
        Detail.requesterSection = 'CCCC';
        Detail.requesterUnit = 'DDDD';
        Detail.userManagerId = runAsUser.Id;
        return Detail;
    }
    
    @isTest
    public static void ESSStationaryMethod() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            Stationary.Rating_Date__c = date.today();
            Stationary.Rating_Date_2__c = date.today();
            insert(Stationary);
            
            ESS_Master_Stationary__c MS = new ESS_Master_Stationary__c();
            MS.Active__c = true;
            MS.Name = 'Test';
            MS.Stationary_Name__c = 'Test';
            MS.Available_Stock__c = 10;
            MS.Due_Stock__c = 10;
            MS.Minimum_Stock__c = 5;
            MS.Price__c = 1000;
            MS.Stock_on_Hand__c = 10;
            MS.Service_For__c = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            insert(MS);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialStationaryDetail(runAsUser);
            detail.recordId = Stationary.Id;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            
            ESS_Stationary.GetAllStatuses();
            ESS_Stationary.DefaultServiceFor(runAsUser.Id);
            ESS_Stationary.DefaultWithdrawFrom(runAsUser.Id);
            ESS_Stationary.getWithdrawFroms(ESS_Enum.StationaryWithdrawFrom.TSR.name());
            ESS_Stationary.getWithdrawFroms(ESS_Enum.StationaryWithdrawFrom.TBK.name());
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.TOPTBK.name());  
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.TOPTSR.name());  
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.LABIX.name());  
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.TES.name());  
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.TTC.name());   
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.TET.name());    
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.TLB.name());   
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.TPX.name());   
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.TX.name());     
			ESS_Stationary.getServiceFors(ESS_Enum.StationaryServiceFor.Other.name());  
            ESS_Stationary.generateDocumentUrl(detail.recordId);
            ESS_Stationary.AddDueStockWhenSubmit(MS.Id, 1);
            ESS_Stationary.DeductStockOnHandWhenCompleted(MS.Id, 1);
            
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.Completed.name();
            update(Stationary);
            ESS_Stationary.checkShowRatingFormOBHStationary(Stationary, runAsUser.Id);
            
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.WaitingToApprove.name();
            ESS_Stationary.checkCanApproveStationary(Stationary, runAsUser.Id);
            
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.Completed.name();
            Stationary.Rating_Date__c = date.today();
            ESS_Stationary.checkShowRatingFormStationary(Stationary, runAsUser.Id);
            ESS_Stationary.checkCanRatingStationary(Stationary, runAsUser.Id);
            
            ESS_Stationary.AdminSearchCriteria Filter = new ESS_Stationary.AdminSearchCriteria();
            Filter.year = 2023;
            Filter.year = 6;
            ESS_Stationary.ExportStationaryExcel(Filter);
            
            ESS_Stationary_DTO.UploadFileDTO UploadFile = new ESS_Stationary_DTO.UploadFileDTO();
            UploadFile.fileName = 'Test';
            UploadFile.fileData = 'Test';
            UploadFile.recordId = Stationary.Id;            
            ESS_Stationary.UploadFile(UploadFile);
            
            ESS_Stationary.ChangeUploadFileParentId(Stationary.Id, Stationary.Id);
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationaryTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            insert(Stationary);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialStationaryDetail(runAsUser);
            detail.recordId = Stationary.Id;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            
            ESS_Stationary.SearchCriteria SearchCriteria = new ESS_Stationary.SearchCriteria();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_Stationary.AdminSearchCriteria AdminSearchCriteria = new ESS_Stationary.AdminSearchCriteria();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.active = true;
            AdminSearchCriteria.showOnlyLowerStock = false;
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_Stationary.GetStationaryAdminListCount(AdminSearchCriteria);
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, SortByParam, PageParam);
            ESS_Stationary.GetOnBehalfCount();
            ESS_Stationary.GetStationaryListCount(SearchCriteria);
            ESS_Stationary.GetStationaryList(SearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = false;
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, SortByParam, PageParam);
            ESS_Stationary.GetStationaryList(SearchCriteria, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = false;
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, SortByParam, null);
            ESS_Stationary.GetStationaryList(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = false;
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, SortByParam, null);
            ESS_Stationary.GetStationaryList(SearchCriteria, SortByParam, null);

        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationaryFilterTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            insert(Stationary);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialStationaryDetail(runAsUser);
            detail.recordId = Stationary.Id;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            
            ESS_Stationary.AdminSearchCriteria AdminSearchCriteria = new ESS_Stationary.AdminSearchCriteria();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startSubmittedDate = date.today();
            AdminSearchCriteria.endSubmittedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            AdminSearchCriteria.active = true;
            AdminSearchCriteria.showOnlyLowerStock = false;
            
            ESS_Stationary.GetStationaryAdminListCount(AdminSearchCriteria);
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, null, null);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, null, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'requesterDisplayName';
            SortByParam.ascending = true;
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, null, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'onBehalfOfEmployeeName';
            SortByParam.ascending = true;
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, null, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'completedDate';
            SortByParam.ascending = true;
            ESS_Stationary.GetStationaryAdminList(AdminSearchCriteria, null, null);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationaryApproverTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            insert(Stationary);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialStationaryDetail(runAsUser);
            detail.recordId = Stationary.Id;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            
            ESS_Stationary.SearchCriteria SearchCriteria = new ESS_Stationary.SearchCriteria();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_Stationary.AdminSearchCriteria AdminSearchCriteria = new ESS_Stationary.AdminSearchCriteria();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.active = true;
            AdminSearchCriteria.showOnlyLowerStock = false;
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_Stationary.GetStationaryApproverListCount(SearchCriteria);
            ESS_Stationary.GetStationaryApproverList(SearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'currentStatus';
            SortByParam.ascending = true;
            ESS_Stationary.GetStationaryApproverList(SearchCriteria, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_Stationary.GetStationaryApproverList(SearchCriteria, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'completedDate';
            SortByParam.ascending = true;
            ESS_Stationary.GetStationaryApproverList(SearchCriteria, SortByParam, PageParam);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationarySaveTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            Stationary.Document_No__c = 'SS-2023-06-0001';
            Stationary.Total_Other__c = 0;
            Stationary.Total_Stock__c = 0;
            Stationary.Total__c = 0;
            Stationary.Withdraw_From__c = ESS_Enum.StationaryWithdrawFrom.TSR.name();
            Stationary.Requester_Id__c = runAsUser.Id;
            Stationary.Requester_Name__c = 'Test';
            Stationary.Requester_Name_EN__c = 'Test';
            Stationary.User_Manager_Id__c = runAsUser.Id;
            Stationary.Requester_Email__c = 'test@gmail.com';
            Stationary.CC_Email__c = 'test@gmail.com';
            Stationary.Submitted_Date__c = date.today();
            insert(Stationary);
            
            ESS_Master_Stationary__c MS = new ESS_Master_Stationary__c();
            MS.Active__c = true;
            MS.Name = 'Test';
            MS.Stationary_Name__c = 'Test';
            MS.Available_Stock__c = 10;
            MS.Due_Stock__c = 10;
            MS.Minimum_Stock__c = 5;
            MS.Price__c = 1000;
            MS.Service_For__c = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            insert(MS);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialStationaryDetail(runAsUser);
            detail.recordId = Stationary.Id;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            
            ESS_Stationary_DTO.SearchDTO SearchDTO = new ESS_Stationary_DTO.SearchDTO();
            ESS_Stationary.GetStationaryDetail(SearchDTO);
            
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.Waiting.name();
            update(Stationary);
            ESS_Stationary_DTO.AcceptDTO AcceptDTO = new ESS_Stationary_DTO.AcceptDTO();
            AcceptDTO.recordId = Stationary.Id;
            AcceptDTO.comment = 'Comment';
            ESS_Stationary.AcceptStationary(AcceptDTO);
            
            SearchDTO.search = 'Test';
            ESS_Stationary.SearchUsers(SearchDTO);
            
            SearchDTO.recordId = Stationary.Id;
            ESS_Stationary.ApproveStationary(SearchDTO, 'Comment');
            
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.WaitingToApprove.name();
            update(Stationary);
            List<ESS_Stationary_DTO.StationaryCardDTO> Cards = new List<ESS_Stationary_DTO.StationaryCardDTO>();
            Cards = ESS_Stationary.GetStationaryList(null, null, null);
            Cards[0].isSelected = true;
            for(ESS_Stationary_DTO.StationaryCardDTO Card : Cards) {
                if(Card.isSelected == null) {
                    Card.isSelected = false;
                }
            }
            ESS_Stationary.ApproveMultipleStationary(Cards, 'Comment');
            
            ESS_Stationary_DTO.RejectCancelDTO RejectCancel = new ESS_Stationary_DTO.RejectCancelDTO();
            RejectCancel.recordId = Stationary.Id;
            RejectCancel.comment = 'Reject';
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.Draft.name();
            update(Stationary);
            ESS_Stationary.CancelRequestStationary(RejectCancel);
            
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.Verifying.name();
            update(Stationary);
            ESS_Stationary.RejectStationary(RejectCancel);
            
            Cards = new List<ESS_Stationary_DTO.StationaryCardDTO>();
            Cards = ESS_Stationary.GetStationaryList(null, null, null);
            Cards[0].isSelected = true;
            for(ESS_Stationary_DTO.StationaryCardDTO Card : Cards) {
                if(Card.isSelected == null) {
                    Card.isSelected = false;
                }
            }
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.Verifying.name();
            update(Stationary);
            ESS_Stationary.RejectMultipleStationary(Cards, 'Comment');
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationaryMasterTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            Stationary.Document_No__c = 'SS-2023-06-0001';
            Stationary.Total_Other__c = 0;
            Stationary.Total_Stock__c = 0;
            Stationary.Total__c = 0;
            Stationary.Withdraw_From__c = ESS_Enum.StationaryWithdrawFrom.TSR.name();
            Stationary.Requester_Id__c = runAsUser.Id;
            Stationary.Requester_Name__c = 'Test';
            Stationary.Requester_Name_EN__c = 'Test';
            Stationary.User_Manager_Id__c = runAsUser.Id;
            Stationary.Requester_Email__c = 'test@gmail.com';
            Stationary.CC_Email__c = 'test@gmail.com';
            Stationary.Submitted_Date__c = date.today();
            Stationary.Total__c = 10;
            Stationary.Total_Stock__c = 10;
            Stationary.Total_Other__c = 10;
            insert(Stationary);
            
            ESS_Master_Stationary__c MS = new ESS_Master_Stationary__c();
            MS.Active__c = true;
            MS.Name = 'Test';
            MS.Stationary_Name__c = 'Test';
            MS.Available_Stock__c = 10;
            MS.Due_Stock__c = 10;
            MS.Minimum_Stock__c = 5;
            MS.Price__c = 1000;
            MS.Service_For__c = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            insert(MS);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialStationaryDetail(runAsUser);
            detail.recordId = Stationary.Id;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            
            ESS_Stationary_DTO.SearchDTO SearchDTO = new ESS_Stationary_DTO.SearchDTO();
            ESS_Stationary.GetStationaryDetail(SearchDTO);
            
            SearchDTO.search = 'Test';
            ESS_Stationary.GetMasterStationaryList(SearchDTO, ESS_Enum.StationaryWithdrawFrom.TBK.name());
            
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.OnProcess.name();
            update(Stationary);
            ESS_Stationary.CompleteStationary(saveDetail);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationaryOBHCompleteTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            insert(Stationary);
            
            ESS_Master_Stationary__c MS = new ESS_Master_Stationary__c();
            MS.Active__c = true;
            MS.Name = 'Test';
            MS.Stationary_Name__c = 'Test';
            MS.Available_Stock__c = 100;
            MS.Due_Stock__c = 10;
            MS.Minimum_Stock__c = 5;
            MS.Price__c = 1000;
            MS.Stock_on_Hand__c = 10;
            MS.Service_For__c = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            insert(MS);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialOnBehalfDetail(runAsUser, AdminPMSVId);
            detail.recordId = Stationary.Id;
            detail.onBehalfOfFlow = true;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            saveDetail.withdrawFrom = new ESS_Global.EnumValue('StationaryWithdrawFrom');
            saveDetail.withdrawFrom.key = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            saveDetail.withdrawFrom.value = ESS_Enum.StationaryWithdrawFrom.TBK.name();
        	ESS_Stationary.SubmitStationary(saveDetail);
            
            saveDetail.withdraws = new List<ESS_Stationary_DTO.WithdrawDTO>();
            saveDetail.withdrawOthers = new List<ESS_Stationary_DTO.WithdrawDTO>();
            ESS_Stationary_DTO.WithdrawDTO withdraw = new ESS_Stationary_DTO.WithdrawDTO();
            withdraw.recordId = MS.Id;
            withdraw.stationaryId = Stationary.Id;
            withdraw.unit = 'อัน';
            withdraw.totalPrice = 1000;
            withdraw.stockOnHand = 1;
            withdraw.quantity = 1;
            withdraw.pricePerUnit = 1000;
            withdraw.actualWithdraw = 1;
            saveDetail.withdraws.add(withdraw);
            saveDetail.withdrawOthers.add(withdraw);
            saveDetail.status = new ESS_Global.EnumValue('StationaryServiceStatus');
            saveDetail.status.key = ESS_Enum.StationaryServiceStatus.OnProcess.name();
            saveDetail.status.value = ESS_Enum.StationaryServiceStatus.OnProcess.name();
            ESS_Stationary.SaveCompleteStationary(saveDetail);
            
            Stationary.Id = saveDetail.recordId;
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.OnProcess.name();
            update(Stationary);
            ESS_Stationary.CompleteStationary(saveDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationaryOBHTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            insert(Stationary);
            
            ESS_Master_Stationary__c MS = new ESS_Master_Stationary__c();
            MS.Active__c = true;
            MS.Name = 'Test';
            MS.Stationary_Name__c = 'Test';
            MS.Available_Stock__c = 100;
            MS.Due_Stock__c = 10;
            MS.Minimum_Stock__c = 5;
            MS.Price__c = 1000;
            MS.Stock_on_Hand__c = 10;
            MS.Service_For__c = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            insert(MS);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialOnBehalfDetail(runAsUser, AdminPMSVId);
            detail.recordId = Stationary.Id;
            detail.onBehalfOfFlow = true;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            saveDetail.withdrawFrom = new ESS_Global.EnumValue('StationaryWithdrawFrom');
            saveDetail.withdrawFrom.key = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            saveDetail.withdrawFrom.value = ESS_Enum.StationaryWithdrawFrom.TBK.name();
        	ESS_Stationary.SubmitStationary(saveDetail);
            
            ESS_Stationary_DTO.SearchDTO SearchDTO = new ESS_Stationary_DTO.SearchDTO();
            SearchDTO.recordId = detail.recordId;
            ESS_Stationary.VerifyStationary(SearchDTO, 'Verify');
            ESS_Stationary.DeleteStationary(SearchDTO);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationaryOBHVerifyingMultipleTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Model = new ESS_Stationary__c();
            Model.Document_No__c = 'SS-2023-06-0001';
            Model.Status__c = ESS_Enum.StationaryServiceStatus.Draft.name();
            Model.Submitted_Date__c = date.today();
            Model.Requester_Id__c = runAsUser.Id;
            Model.Requester_Name_EN__c = 'Test';
            Model.Requester_Name__c = 'Test';
            Model.Requester_Email__c = 'test@softever.co.th';
            Model.On_Behalf_Of_Id__c = runAsUser.Id;
            Model.On_Behalf_Of__c = 'Test';
            Model.On_Behalf_Of_EN__c = 'Test';
            Model.On_Behalf_Of_Email__c = 'test@softever.co.th';
            Model.Withdraw_From__c = 'TSR';
            Model.On_Behalf_Flow__c = true;
            insert(Model);
            
            ESS_Stationary.SearchCriteria SearchCriteria = new ESS_Stationary.SearchCriteria();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialOnBehalfDetail(runAsUser, AdminPMSVId);
            detail.recordId = Model.Id;
            detail.onBehalfOfFlow = true;
            detail.onBehalfOfVerifying = true;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            saveDetail.withdrawFrom = new ESS_Global.EnumValue('StationaryWithdrawFrom');
            saveDetail.withdrawFrom.key = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            saveDetail.withdrawFrom.value = ESS_Enum.StationaryWithdrawFrom.TBK.name();
        	ESS_Stationary.SubmitStationary(saveDetail);
            
            ESS_Stationary_DTO.SearchDTO SearchDTO = new ESS_Stationary_DTO.SearchDTO();
            SearchDTO.recordId = saveDetail.recordId;
            List<ESS_Stationary_DTO.StationaryCardDTO> Cards = new List<ESS_Stationary_DTO.StationaryCardDTO>();
            Cards = ESS_Stationary.GetStationaryList(null, null, null);
            Cards[0].isSelected = true;
            for(ESS_Stationary_DTO.StationaryCardDTO Card : Cards) {
                if(Card.isSelected == null) {
                    Card.isSelected = false;
                }
            }
            ESS_Stationary.VerifyMultipleStationary(Cards, 'Verify');
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationaryUserManagerTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            insert(Stationary);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialUserManagerDetail(runAsUser);
            detail.recordId = Stationary.Id;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            saveDetail.withdrawFrom = new ESS_Global.EnumValue('StationaryWithdrawFrom');
            saveDetail.withdrawFrom.key = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            saveDetail.withdrawFrom.value = ESS_Enum.StationaryWithdrawFrom.TBK.name();
        	ESS_Stationary_DTO.StationaryDetailDTO submitDetail = ESS_Stationary.SubmitStationary(saveDetail);
            ESS_Stationary_DTO.SearchDTO SearchDTO = new ESS_Stationary_DTO.SearchDTO();
            SearchDTO.recordId = submitDetail.recordId;
            ESS_Stationary_DTO.StationaryDetailDTO verifyDetail = ESS_Stationary.VerifyStationary(SearchDTO, 'Verify');
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSStationarySaveRatingTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPMSVId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, user__c from PISUsers__c];
        Id PISUserId;
        for(PISUsers__c PISUser : PISUsers) {
            if(PISUser.User__c == UserId) {
                PISUserId = PISUser.Id;
            }
        }
        
        System.runAs(runAsUser) {
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            Stationary.Document_No__c = 'SS-2023-06-0001';
            Stationary.Total_Other__c = 0;
            Stationary.Total_Stock__c = 0;
            Stationary.Total__c = 0;
            Stationary.Withdraw_From__c = ESS_Enum.StationaryWithdrawFrom.TSR.name();
            Stationary.Requester_Id__c = runAsUser.Id;
            Stationary.Requester_Name__c = 'Test';
            Stationary.Requester_Name_EN__c = 'Test';
            Stationary.User_Manager_Id__c = runAsUser.Id;
            Stationary.Requester_Email__c = 'test@gmail.com';
            Stationary.CC_Email__c = 'test@gmail.com';
            Stationary.Submitted_Date__c = date.today();
            insert(Stationary);
            
            ESS_Master_Stationary__c MS = new ESS_Master_Stationary__c();
            MS.Active__c = true;
            MS.Name = 'Test';
            MS.Stationary_Name__c = 'Test';
            MS.Available_Stock__c = 10;
            MS.Due_Stock__c = 10;
            MS.Minimum_Stock__c = 5;
            MS.Price__c = 1000;
            MS.Service_For__c = ESS_Enum.StationaryWithdrawFrom.TBK.name();
            insert(MS);
            
            ESS_Stationary_DTO.StationaryDetailDTO detail = initialStationaryDetail(runAsUser);
            detail.recordId = Stationary.Id;
            ESS_Stationary_DTO.StationaryDetailDTO saveDetail = ESS_Stationary.SaveStationary(detail);
            
            ESS_Stationary_DTO.SearchDTO SearchDTO = new ESS_Stationary_DTO.SearchDTO();
            ESS_Stationary.GetStationaryDetail(SearchDTO);
            
            SearchDTO.search = 'Test';
            ESS_Stationary.SearchUsers(SearchDTO);
            
            ESS_Stationary.SaveRatingStationary(saveDetail);
            
        }
        
		Test.stopTest();
        
    }
    
    
    @isTest
    public static void StationaryDTOTest() {
        Test.startTest();
        
        ESS_Stationary_DTO.StationaryExcelDTO ExcelDTO = new ESS_Stationary_DTO.StationaryExcelDTO();
        ExcelDTO.documentNo = 'SS-2023-06-0001';
        ExcelDTO.withdrawFrom = 'TBK';
        ExcelDTO.serviceFor = 'TBK';
        ExcelDTO.location = 'Location';
        ExcelDTO.internalNo = '021231234';
        ExcelDTO.mobileNo = '0811231234';
        ExcelDTO.needDate = date.today();
        ExcelDTO.typeOfStationary = 'External';
        ExcelDTO.stationaryId = '1';
        ExcelDTO.stationaryName = 'Test';
        ExcelDTO.stockOnHand = 10;
        ExcelDTO.withdrawQuantity = 1;
        ExcelDTO.actualQuantity = 1;
        ExcelDTO.unit = 'กล่อง';
        ExcelDTO.price = 100;
        ExcelDTO.totalStock = 10;
        ExcelDTO.totalOther = 10;
        ExcelDTO.total = 20;
        ExcelDTO.comment = 'Comment';
        ExcelDTO.verifyStatus = 'Yes';
        ExcelDTO.obhComment = 'Comment';
        ExcelDTO.approveStatus = 'Approve';
        ExcelDTO.approvedComment = 'Commment';
        ExcelDTO.userManagerComment = 'Comment';
        ExcelDTO.staffComment = 'Comment';
        ExcelDTO.pmsvComment = 'Comment';
        ExcelDTO.requesterName = 'Requester';
        ExcelDTO.requesterEmployeeId = '00000001';
        ExcelDTO.requesterEmail = 'test@softever.co.th';
        ExcelDTO.requesterPosition = 'Position';
        ExcelDTO.requesterFunction = 'Function';
        ExcelDTO.requesterDepartment = 'Department';
        ExcelDTO.requesterSection = 'Section';
        ExcelDTO.requesterUnit = 'Unit';
        ExcelDTO.obhName = 'Requester';
        ExcelDTO.obhEmployeeId = '00000001';
        ExcelDTO.obhEmail = 'test@softever.co.th';
        ExcelDTO.obhPosition = 'Position';
        ExcelDTO.obhFunction = 'Function';
        ExcelDTO.obhDepartment = 'Department';
        ExcelDTO.obhSection = 'Section';
        ExcelDTO.obhUnit = 'Unit';
        ExcelDTO.createdDate = date.today();
        ExcelDTO.submittedDate = date.today();
        ExcelDTO.verifiedDate = date.today();
        ExcelDTO.completedDate = date.today();
        ExcelDTO.rejectedDate = date.today();
        ExcelDTO.cancelledDate = date.today();
        ExcelDTO.completedBy = 'Admin';
        ExcelDTO.verifiedBy = 'Admin';
        ExcelDTO.rejectedBy = 'Admin';
        ExcelDTO.cancelledBy = 'Admin';
        ExcelDTO.currentStatus = 'Status';
        ExcelDTO.requesterRatingCompleted = true;
        ExcelDTO.requesterRating = 5;
        ExcelDTO.requesterAttentiveness = true;
        ExcelDTO.requesterFast = true;
        ExcelDTO.requesterPunctuality = true;
        ExcelDTO.requesterExpertise = true;
        ExcelDTO.obhRatingCompleted = true;
        ExcelDTO.obhRating = 5;
        ExcelDTO.obhAttentiveness = true;
        ExcelDTO.obhFast = true;
        ExcelDTO.obhPunctuality = true;
        ExcelDTO.obhExpertise = true;
        ExcelDTO.obhExpertise = true;
        
        Test.stopTest();
    }
}