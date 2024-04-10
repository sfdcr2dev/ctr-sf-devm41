@isTest
public with sharing class ESS_FixAndGeneral_Test {

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
        Config.FixAndGeneral_Running_No__c = '0';
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
        Id AdminPEOCId;
        
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
                AdminPEOCId = U.Id;
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
        
        PISUsers__c adminPEOC = new PISUsers__c();
        adminPEOC.Active__c = true;
        adminPEOC.MAINPOSITION__c = true;
        adminPEOC.EMPLOYEEID__c = '00000000';
        adminPEOC.HOME_COMP__c = '1100';
        adminPEOC.Name = 'Test AdminPEOC';
        adminPEOC.LEVEL__c = 'VP';
        adminPEOC.ORGID__c = '00000000';
        adminPEOC.POSID__c = '00000000';
        adminPEOC.ENFIRSTNAME__c = 'Test';
        adminPEOC.ENLASTNAME__c = 'Test AdminPEOC';
        adminPEOC.HOLDERPOSITION__c = '00000000';
        adminPEOC.EMAIL__c = 'adminpeoc@thaioilgroup.com';
        adminPEOC.User__c = AdminPEOCId;
        insert(adminPEOC);
    }
    
    @future
    public static void insertPublicGroup() {
        
        List<User> Users = [select id, alias from User];
        
        Id AdminPMSVId;
        Id AdminFixAndGeneralId;
        Id AdminTransportationId;
        
        for(User U : Users) {
            if(U.alias == 'PA') {
                AdminPMSVId = U.Id;
            }
            else if(U.alias == 'KI') {
                AdminFixAndGeneralId = U.Id;
                AdminTransportationId = U.Id;
            }
        }
        
        //Create PMSVFixAndGeneral Group
        Group pmsvFAGAdminGroup = [select id from Group where developername = 'ESS_PMSV_FixAndGeneral'];
        GroupMember pmsvFAGAdmin = new GroupMember();
        pmsvFAGAdmin.UserOrGroupId = AdminFixAndGeneralId;
        pmsvFAGAdmin.GroupId = pmsvFAGAdminGroup.Id;
        insert(pmsvFAGAdmin);
        //Create PMSVTransportation Group
        Group pmsvTAdminGroup = [select id from Group where developername = 'ESS_PMSV_Transportation'];
        GroupMember pmsvTAdmin = new GroupMember();
        pmsvTAdmin.UserOrGroupId = AdminTransportationId;
        pmsvTAdmin.GroupId = pmsvTAdminGroup.Id;
        insert(pmsvTAdmin);
        //Create PMSV Group
        Group pmsvAdminGroup = [select id from Group where developername = 'ESS_PMSV'];
        GroupMember pmsvAdmin = new GroupMember();
        pmsvAdmin.UserOrGroupId = AdminPMSVId;
        pmsvAdmin.GroupId = pmsvAdminGroup.Id;
        insert(pmsvAdmin);
        
    }
    
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO initialHousingDetail(User runAsUser) {
        
        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO Detail = new ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO();
        Detail.onBehalfFlow = false;
        Detail.status = new ESS_Global.EnumValue('FixAndGeneralDocumentStatus');
        Detail.status.key = ESS_Enum.FixAndGeneralDocumentStatus.Draft.name();
        Detail.status.value = 'Draft';
        Detail.isPRTRUser = false;
        Detail.typeOfService = new ESS_Global.EnumValue('FixTypeOfService');
        Detail.typeOfService.key = ESS_Enum.FixTypeOfService.Housing.name();
        Detail.typeOfService.value = 'Housing';
        
        Detail.housingTypeOfService = new ESS_Global.EnumValue('HousingTypeOfService');
        Detail.housingTypeOfService.key = ESS_Enum.HousingTypeOfService.ElectricalAndLightingSystem.name();
        Detail.housingTypeOfService.value = 'ElectricalAndLightingSystem';
        Detail.housingTypeOfServiceOther = '';
        Detail.housingCost = 1000;
        Detail.housingDetail = '';
        Detail.housingInternalDetail = '';
        
        Detail.repairDate = system.Datetime.now();
        Detail.houseNo = '111';
        Detail.period = new ESS_Global.EnumValue('HousingPeriod');
        Detail.period.key = ESS_Enum.HousingPeriod.DayWork.name();
        Detail.period.value = 'Day Work';
        Detail.houseType = new ESS_Global.EnumValue('HousingType');
        Detail.houseType.key = ESS_Enum.HousingType.SiteHouse.name();
        Detail.houseType.value = 'Site House';
        Detail.mobileNo = '081-123-4567';
        Detail.topic = 'Test';
        Detail.detail = 'Test';
        Detail.expectedDueDate = date.today();
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
        
        return Detail;
    }
    
    public static ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO initialOnBehalfHousingDetail(User runAsUser, string onBehalfId) {
        
        ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO Detail = new ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO();
        Detail.status = new ESS_Global.EnumValue('FixAndGeneralDocumentStatus');
        Detail.status.key = ESS_Enum.FixAndGeneralDocumentStatus.Draft.name();
        Detail.status.value = 'Draft';
        Detail.isPRTRUser = false;
        Detail.typeOfService = new ESS_Global.EnumValue('FixTypeOfService');
        Detail.typeOfService.key = ESS_Enum.FixTypeOfService.Housing.name();
        Detail.typeOfService.value = 'Housing';
        Detail.repairDate = system.Datetime.now();
        Detail.houseNo = '111';
        Detail.period = new ESS_Global.EnumValue('HousingPeriod');
        Detail.period.key = ESS_Enum.HousingPeriod.DayWork.name();
        Detail.period.value = 'Day Work';
        Detail.houseType = new ESS_Global.EnumValue('HousingType');
        Detail.houseType.key = ESS_Enum.HousingType.SiteHouse.name();
        Detail.houseType.value = 'Site House';
        Detail.mobileNo = '081-123-4567';
        Detail.topic = 'Test';
        Detail.detail = 'Test';
        Detail.expectedDueDate = date.today();
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
        
        Detail.onBehalfFlow = true;
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
        
        return Detail;
    }
    
    @isTest
    public static void ESSFixAndGeneralMethod() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            FixAndGeneral.Document_No__c = 'HS-2023-01-0001';
            FixAndGeneral.Type_of_Service__c = ESS_Enum.FixTypeOfService.Housing.name();
            FixAndGeneral.Housing_Type_of_Service__c = ESS_Enum.OfficeTypeOfService.ElectricalAndLightingSystem.name();
            FixAndGeneral.Repair_Date__c = system.Datetime.now();
            FixAndGeneral.House_No__c = '111';
            FixAndGeneral.Period__c = ESS_Enum.HousingPeriod.DayWork.name();
            FixAndGeneral.House_Type__c = ESS_Enum.HousingType.SiteHouse.name();
            FixAndGeneral.Mobile_No__c = '081-123-4567';
            FixAndGeneral.Topic__c = 'Test Housing';
            FixAndGeneral.Detail__c = 'Test Detail';
            FixAndGeneral.Expected_Due_Date__c = date.today();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            ESS_FixAndGeneral.checkCanSaveCompleteFixAndGeneral(FixAndGeneral, runAsUser.Id);
            
            FixAndGeneral.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name();
            ESS_FixAndGeneral.checkCanCompleteFixAndGeneral(FixAndGeneral, runAsUser.Id);
            
            FixAndGeneral.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Completed.name();
            FixAndGeneral.Rating_Date__c = date.today();
            FixAndGeneral.Rating_Date_2__c = date.today();
            ESS_FixAndGeneral.checkCanRatingFixAndGeneral(FixAndGeneral, runAsUser.Id);
            ESS_FixAndGeneral.checkShowRatingFormFixAndGeneral(FixAndGeneral, runAsUser.Id);
            ESS_FixAndGeneral.checkShowRatingFormOBHFixAndGeneral(FixAndGeneral, runAsUser.Id);
            ESS_FixAndGeneral.UploadFile('Test','Test', FixAndGeneral.Id);
            ESS_FixAndGeneral.ChangeUploadFileParentId(FixAndGeneral.Id, FixAndGeneral.Id);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter Filter = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            Filter.typeOfServices = 'Housing';
            Filter.year = 2023;
            Filter.year = 6;
            ESS_FixAndGeneral.ExportFixAndGeneralExcel(Filter);
            
            FixAndGeneral.Type_of_Service__c = ESS_Enum.FixTypeOfService.Housing.name();
			FixAndGeneral.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Completed.name();            
            update(FixAndGeneral);
            ESS_FixAndGeneral.checkShowTransportationInternalDetail(FixAndGeneral, runAsUser.Id);
            
            FixAndGeneral.Type_of_Service__c = ESS_Enum.FixTypeOfService.GeneralService.name();          
            update(FixAndGeneral);
            ESS_FixAndGeneral.checkShowGeneralInternalDetail(FixAndGeneral, runAsUser.Id);
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralHousingTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            FixAndGeneral.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name();
            detail.status = new ESS_Global.EnumValue('FixAndGeneralDocumentStatus');
            detail.status.key = ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name();
            detail.status.value = ESS_Enum.FixAndGeneralDocumentStatus.Waiting.name();
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO acceptDetail = ESS_FixAndGeneral.AcceptFixAndGeneral(saveDetail.recordId);
        	
            FixAndGeneral.Type_of_Service__c = ESS_Enum.FixTypeOfService.Housing.name();
			FixAndGeneral.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Completed.name();            
            update(FixAndGeneral);
            ESS_FixAndGeneral.checkShowHousingInternalDetail(FixAndGeneral, runAsUser.Id);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralSaveHousingTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            FixAndGeneral.Type_of_Service__c = ESS_Enum.FixTypeOfService.Housing.name();
            FixAndGeneral.Housing_Type_of_Service__c = ESS_Enum.OfficeTypeOfService.ElectricalAndLightingSystem.name();
            FixAndGeneral.Repair_Date__c = system.Datetime.now();
            FixAndGeneral.House_No__c = '111';
            FixAndGeneral.Period__c = ESS_Enum.HousingPeriod.DayWork.name();
            FixAndGeneral.House_Type__c = ESS_Enum.HousingType.SiteHouse.name();
            FixAndGeneral.Mobile_No__c = '081-123-4567';
            FixAndGeneral.Topic__c = 'Test Housing';
            FixAndGeneral.Detail__c = 'Test Detail';
            FixAndGeneral.Expected_Due_Date__c = date.today();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.employeeName = '';
            AdminSearchCriteria.topic = '';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_FixAndGeneral.GetFixAndGeneralListCount(SearchCriteria);
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO submitDetail = ESS_FixAndGeneral.SubmitFixAndGeneral(saveDetail);
            
            submitDetail.housingTypeOfService = new ESS_Global.EnumValue('HousingTypeOfService');
            submitDetail.housingTypeOfService.key = ESS_Enum.HousingTypeOfService.ElectricalAndLightingSystem.name();
            submitDetail.housingTypeOfService.value = 'ElectricalAndLightingSystem';
            submitDetail.housingTypeOfServiceOther = '';
            submitDetail.housingCost = 1000;
            submitDetail.housingDetail = '';
            submitDetail.housingInternalDetail = '';
            
            ESS_FixAndGeneral.SaveCompleteFixAndGeneral(submitDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralSaveTransportTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            FixAndGeneral.Type_of_Service__c = ESS_Enum.FixTypeOfService.Transportation.name();
            FixAndGeneral.Transportation_Type_Of_Service__c = ESS_Enum.TransportationTypeOfService.ChangeTire.name();
            FixAndGeneral.Repair_Date__c = system.Datetime.now();
            FixAndGeneral.House_No__c = '111';
            FixAndGeneral.Period__c = ESS_Enum.HousingPeriod.DayWork.name();
            FixAndGeneral.House_Type__c = ESS_Enum.HousingType.SiteHouse.name();
            FixAndGeneral.Mobile_No__c = '081-123-4567';
            FixAndGeneral.Topic__c = 'Test Housing';
            FixAndGeneral.Detail__c = 'Test Detail';
            FixAndGeneral.Expected_Due_Date__c = date.today();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            detail.typeOfService = new ESS_Global.EnumValue('FixTypeOfService');
            detail.typeOfService.key = ESS_Enum.FixTypeOfService.Transportation.name();
            detail.typeOfService.value = 'Transportation';
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.employeeName = '';
            AdminSearchCriteria.topic = '';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_FixAndGeneral.GetFixAndGeneralListCount(SearchCriteria);
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO submitDetail = ESS_FixAndGeneral.SubmitFixAndGeneral(saveDetail);
            
            submitDetail.transportationTypeOfService = new ESS_Global.EnumValue('TransportationTypeOfService');
            submitDetail.transportationTypeOfService.key = ESS_Enum.TransportationTypeOfService.ChangeTire.name();
            submitDetail.transportationTypeOfService.value = 'ChangeTire';
            
            ESS_FixAndGeneral.SaveCompleteFixAndGeneral(submitDetail);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralSaveGeneralTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            FixAndGeneral.Type_of_Service__c = ESS_Enum.FixTypeOfService.GeneralService.name();
            FixAndGeneral.General_Type_Of_Service__c = ESS_Enum.GeneralTypeOfService.MovingService.name();
            FixAndGeneral.Repair_Date__c = system.Datetime.now();
            FixAndGeneral.House_No__c = '111';
            FixAndGeneral.Period__c = ESS_Enum.HousingPeriod.DayWork.name();
            FixAndGeneral.House_Type__c = ESS_Enum.HousingType.SiteHouse.name();
            FixAndGeneral.Mobile_No__c = '081-123-4567';
            FixAndGeneral.Topic__c = 'Test Housing';
            FixAndGeneral.Detail__c = 'Test Detail';
            FixAndGeneral.Expected_Due_Date__c = date.today();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            detail.typeOfService = new ESS_Global.EnumValue('FixTypeOfService');
            detail.typeOfService.key = ESS_Enum.FixTypeOfService.GeneralService.name();
            detail.typeOfService.value = 'GeneralService';
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.employeeName = '';
            AdminSearchCriteria.topic = '';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_FixAndGeneral.GetFixAndGeneralListCount(SearchCriteria);
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO submitDetail = ESS_FixAndGeneral.SubmitFixAndGeneral(saveDetail);
            
            submitDetail.generalTypeOfService = new ESS_Global.EnumValue('GeneralTypeOfService');
            submitDetail.generalTypeOfService.key = ESS_Enum.GeneralTypeOfService.MovingService.name();
            submitDetail.generalTypeOfService.value = 'MovingService';
            
            ESS_FixAndGeneral.SaveCompleteFixAndGeneral(submitDetail);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralCancelDeleteHousingTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.employeeName = '';
            AdminSearchCriteria.topic = '';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_FixAndGeneral.GetFixAndGeneralListCount(SearchCriteria);
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO submitDetail = ESS_FixAndGeneral.SubmitFixAndGeneral(saveDetail);
            
            submitDetail.housingTypeOfService = new ESS_Global.EnumValue('HousingTypeOfService');
            submitDetail.housingTypeOfService.key = ESS_Enum.HousingTypeOfService.ElectricalAndLightingSystem.name();
            submitDetail.housingTypeOfService.value = 'ElectricalAndLightingSystem';
            submitDetail.housingTypeOfServiceOther = '';
            submitDetail.housingCost = 1000;
            submitDetail.housingDetail = '';
            submitDetail.housingInternalDetail = '';
            
            //ESS_FixAndGeneral.CompleteFixAndGeneral(submitDetail);
            //ESS_FixAndGeneral.SaveRatingFixAndGeneral(submitDetail);
            ESS_FixAndGeneral.CancelRequestFixAndGeneral(submitDetail.recordId, 'Reject');
            ESS_FixAndGeneral.DeleteFixAndGeneral(submitDetail.recordId);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralCompletedHousingTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            saveDetail.housingTypeOfService = new ESS_Global.EnumValue('HousingTypeOfService');
            saveDetail.housingTypeOfService.key = ESS_Enum.HousingTypeOfService.ElectricalAndLightingSystem.name();
            saveDetail.housingTypeOfService.value = 'ElectricalAndLightingSystem';
            saveDetail.housingTypeOfServiceOther = '';
            saveDetail.housingCost = 1000;
            saveDetail.housingDetail = '';
            saveDetail.housingInternalDetail = '';
            saveDetail.status = new ESS_Global.EnumValue('FixAndGeneralDocumentStatus');
            saveDetail.status.key = ESS_Enum.FixAndGeneralDocumentStatus.OnProcess.name();
            saveDetail.status.value = 'OnProcess';
            ESS_FixAndGeneral.CompleteFixAndGeneral(saveDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralRatingHousingTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            FixAndGeneral.Type_of_Service__c = ESS_Enum.FixTypeOfService.Housing.name();
            FixAndGeneral.Housing_Type_of_Service__c = ESS_Enum.OfficeTypeOfService.ElectricalAndLightingSystem.name();
            FixAndGeneral.Repair_Date__c = system.Datetime.now();
            FixAndGeneral.House_No__c = '111';
            FixAndGeneral.Period__c = ESS_Enum.HousingPeriod.DayWork.name();
            FixAndGeneral.House_Type__c = ESS_Enum.HousingType.SiteHouse.name();
            FixAndGeneral.Mobile_No__c = '081-123-4567';
            FixAndGeneral.Topic__c = 'Test Housing';
            FixAndGeneral.Detail__c = 'Test Detail';
            FixAndGeneral.Expected_Due_Date__c = date.today();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.employeeName = '';
            AdminSearchCriteria.topic = '';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_FixAndGeneral.GetFixAndGeneralListCount(SearchCriteria);
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO submitDetail = ESS_FixAndGeneral.SubmitFixAndGeneral(saveDetail);
            
            submitDetail.housingTypeOfService = new ESS_Global.EnumValue('HousingTypeOfService');
            submitDetail.housingTypeOfService.key = ESS_Enum.HousingTypeOfService.ElectricalAndLightingSystem.name();
            submitDetail.housingTypeOfService.value = 'ElectricalAndLightingSystem';
            submitDetail.housingTypeOfServiceOther = '';
            submitDetail.housingCost = 1000;
            submitDetail.housingDetail = '';
            submitDetail.housingInternalDetail = '';
            
            ESS_FixAndGeneral.SaveRatingFixAndGeneral(submitDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralAdminHousingTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.employeeName = '';
            AdminSearchCriteria.topic = '';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_FixAndGeneral.GetFixAndGeneralForAdminListCount(AdminSearchCriteria);
            ESS_FixAndGeneral.GetFixAndGeneralForAdminList(AdminSearchCriteria, SortByParam, PageParam);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralOnBehalfHousingTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        string OnBehalfId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialOnBehalfHousingDetail(runAsUser, onBehalfId);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.employeeName = '';
            AdminSearchCriteria.topic = '';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_FixAndGeneral.GetFixAndGeneralListCount(SearchCriteria);
            List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> cards = ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO submitDetail = ESS_FixAndGeneral.SubmitFixAndGeneral(saveDetail);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralOnBehalfVerifyHousingTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        string OnBehalfId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            FixAndGeneral.Document_No__c = 'HS-2023-06-0001';
            FixAndGeneral.Requester_Id__c = runAsUser.Id;
            FixAndGeneral.On_Behalf_Flow__c = true;
            FixAndGeneral.On_Behalf_Of_Id__c = OnBehalfId;
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialOnBehalfHousingDetail(runAsUser, onBehalfId);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            //ESS_FixAndGeneral.GetFixAndGeneralListCount(SearchCriteria);
            List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> cards = ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO submitDetail = ESS_FixAndGeneral.SubmitFixAndGeneral(saveDetail);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO verifyDetail = ESS_FixAndGeneral.VerifyFixAndGeneral(submitDetail.recordId);
            cards[0].isSelected = true;
            ESS_FixAndGeneral.VerifyMultipleFixAndGeneral(cards);
            
            //Send Email
            //ESS_FixAndGeneralNotification.SendToEmployeeAdminWhenEmployeeVerify(FixAndGeneral); //FixAndGeneral_FIX_03
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralOnBehalfRejectHousingTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        string OnBehalfId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialOnBehalfHousingDetail(runAsUser, onBehalfId);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            //SearchCriteria.startCompletedDate = date.today();
            //SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.employeeName = '';
            AdminSearchCriteria.topic = '';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_FixAndGeneral.GetFixAndGeneralListCount(SearchCriteria);
            List<ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO> cards = ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO submitDetail = ESS_FixAndGeneral.SubmitFixAndGeneral(saveDetail);
            cards[0].isSelected = true;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO rejectDetail = ESS_FixAndGeneral.RejectFixAndGeneral(submitDetail.recordId, 'Reject');
            ESS_FixAndGeneral.RejectMultipleFixAndGeneral(cards, 'Test');
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralFilterTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            ESS_FixAndGeneral.FixAndGeneralListFilter SearchCriteria = new ESS_FixAndGeneral.FixAndGeneralListFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.topic = '';
            SearchCriteria.typeOfServices = 'Housing';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.employeeName = '';
            AdminSearchCriteria.topic = '';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            
            ESS_FixAndGeneral.GetFixAndGeneralDetail(null);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral.GetFixAndGeneralForAdminList(AdminSearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;

            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral.GetFixAndGeneralForAdminList(AdminSearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'topic';
            SortByParam.ascending = true;
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral.GetFixAndGeneralForAdminList(AdminSearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'typeOfService';
            SortByParam.ascending = true;
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral.GetFixAndGeneralForAdminList(AdminSearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral.GetFixAndGeneralForAdminList(AdminSearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'completedDate';
            SortByParam.ascending = true;
            ESS_FixAndGeneral.GetFixAndGeneralList(SearchCriteria, SortByParam, null);
            ESS_FixAndGeneral.GetFixAndGeneralForAdminList(AdminSearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'acceptedDate';
            SortByParam.ascending = true;
            ESS_FixAndGeneral.GetFixAndGeneralForAdminList(AdminSearchCriteria, SortByParam, null);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSFixAndGeneralMethodTest() {
        
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
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            insert(FixAndGeneral);
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO detail = initialHousingDetail(runAsUser);
            detail.recordId = FixAndGeneral.Id;
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO saveDetail = ESS_FixAndGeneral.SaveFixAndGeneral(detail);
            
            ESS_FixAndGeneral.GetAreas();
            ESS_FixAndGeneral.GetOnBehalfCount();
            ESS_FixAndGeneral.GetBuildings('Test', 'Test');
            ESS_FixAndGeneral.GetFloors('Test', 'Test', 'Test');
            ESS_FixAndGeneral.GetFloors('Test', null, 'Test'); 
            ESS_FixAndGeneral.GetFixTypeOfServices();
            ESS_FixAndGeneral.GetFixAndGeneralDocumentStatuses();
            ESS_FixAndGeneral.GetHousingTypeOfService();
            ESS_FixAndGeneral.GetTransportationTypeOfServices();
            ESS_FixAndGeneral.GetGeneralTypeOfServices();
            ESS_FixAndGeneral.GetHousingPeriods();
            ESS_FixAndGeneral.GetHousingTypes();
            ESS_FixAndGeneral.GetOfficeTypeOfServices();
            ESS_FixAndGeneral.GetPMSVAdminType();
            ESS_FixAndGeneral.SearchUsers('0000');
            ESS_FixAndGeneral.generateDocumentUrl('1234567890');
            
            ESS_FixAndGeneral.FixAndGeneralForAdminListFilter AdminSearchCriteria = new ESS_FixAndGeneral.FixAndGeneralForAdminListFilter();
            AdminSearchCriteria.documentNo = '123';
            AdminSearchCriteria.status = 'Draft';
            AdminSearchCriteria.employeeName = 'Test';
            AdminSearchCriteria.topic = 'Test';
            AdminSearchCriteria.typeOfServices = 'Housing';
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            AdminSearchCriteria.startAcceptedDate = date.today();
            AdminSearchCriteria.endAcceptedDate = date.today().addDays(7);
            
            FixAndGeneral.Type_of_Service__c = ESS_Enum.FixTypeOfService.OfficeEquipment.name();
            FixAndGeneral.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Completed.name();
            update(FixAndGeneral);
            ESS_FixAndGeneral.checkShowOfficeInternalDetail(FixAndGeneral, runAsUser.Id);
            
            ESS_FixAndGeneral.getFixAndGeneralForAdminListQueryFilter(AdminSearchCriteria);
        }
        
		Test.stopTest();
        
    }
    
}