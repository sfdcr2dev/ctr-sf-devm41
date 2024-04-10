@isTest
public with sharing class ESS_Global_Test {
    
    @testSetup
    public static void setup() {
        
        //Create user here
        User AdminPMBPUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'PASSARAWAN',
            Email = 'testpassarawan@thaioilgroup.com',
            Username = 'testpassarawan@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'PA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(AdminPMBPUser);
        
        User AdminPEOCUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'KIRANA',
            Email = 'testkirana@thaioilgroup.com',
            Username = 'testkirana@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'KI',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(AdminPEOCUser);
        
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
            LocaleSidKey = 'en_US'
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
            LocaleSidKey = 'en_US'
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
            LocaleSidKey = 'en_US'
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
            LocaleSidKey = 'en_US'
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
            LocaleSidKey = 'en_US'
            );
        insert(VPUser);
        
        //Insert PISUser
        insertPISUsers();
        
        //Insert Public Group
        insertPublicGroup();
        
        //Insert ESS Master Employee 
        //Uncomment
        /* ESS_Master_Employee__c MasterEmployee = new ESS_Master_Employee__c();
        MasterEmployee.Data__c = 'IN';
        MasterEmployee.Employee_Id__c = '00000003';
        insert(MasterEmployee);
        MasterEmployee = new ESS_Master_Employee__c();
        MasterEmployee.Data__c = 'IN';
        MasterEmployee.Employee_Id__c = '00000001';
        insert(MasterEmployee); */
    }
    
    @future
    public static void insertPISUsers() {
        
        List<User> Users = [select id, alias from User];
        
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
        ramon.LEVEL__c = 'Section Head';
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
        damrong.Subcordinate__c = '[""]';
        insert(damrong);
        
        PISUsers__c ratri = new PISUsers__c();
        ratri.Active__c = true;
        ratri.MAINPOSITION__c = true;
        ratri.EMPLOYEEID__c = '00000003';
        ratri.HOME_COMP__c = '1100';
        ratri.Name = 'Test Ratri';
        ratri.LEVEL__c = 'Junior';
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
        
        Id AdminPMBPId;
        Id AdminPEOCId;
        
        for(User U : Users) {
            if(U.alias == 'PA') {
                AdminPMBPId = U.Id;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
            }
        }
        
        //Create AdminPMBP Group
        Group adminPBMPGroup = [select id from Group where developername = 'ESS_PMBP_Admin'];
        GroupMember pmbpAdmin = new GroupMember();
        pmbpAdmin.UserOrGroupId = AdminPMBPId;
        pmbpAdmin.GroupId = adminPBMPGroup.Id;
        insert(pmbpAdmin);
        //Create AdminPMBP Group
        Group adminPEOCGroup = [select id from Group where developername = 'ESS_PEOC_Admin'];
        GroupMember peocAdmin = new GroupMember();
        peocAdmin.UserOrGroupId = AdminPEOCId;
        peocAdmin.GroupId = adminPEOCGroup.Id;
        insert(peocAdmin);
        //Create PersonelAdmin Group
        Group personelAdminGroup = [select id from Group where developername = 'ESS_Personel_Admin'];
        GroupMember personelAdmin = new GroupMember();
        personelAdmin.UserOrGroupId = AdminPEOCId;
        personelAdmin.GroupId = personelAdminGroup.Id;
        insert(personelAdmin);
        //Create RecommendationLetterAdmin Group
        Group letterAdminGroup = [select id from Group where developername = 'ESS_Recommendation_Letter_Admin'];
        GroupMember letterAdmin = new GroupMember();
        letterAdmin.UserOrGroupId = AdminPEOCId;
        letterAdmin.GroupId = letterAdminGroup.Id;
        insert(letterAdmin);
        //Create ProbationAdmin Group
        Group probationAdminGroup = [select id from Group where developername = 'ESS_Probation_Admin'];
        GroupMember probationAdmin = new GroupMember();
        probationAdmin.UserOrGroupId = AdminPEOCId;
        probationAdmin.GroupId = probationAdminGroup.Id;
        insert(probationAdmin);
        //Create RetirementAdmin Group
        Group retirementAdminGroup = [select id from Group where developername = 'ESS_Retirement_Admin'];
        GroupMember retirementAdmin = new GroupMember();
        retirementAdmin.UserOrGroupId = AdminPEOCId;
        retirementAdmin.GroupId = retirementAdminGroup.Id;
        insert(retirementAdmin);
        //Create PMSVFixAndGeneral Group
        Group pmsvFAGAdminGroup = [select id from Group where developername = 'ESS_PMSV_FixAndGeneral'];
        GroupMember pmsvFAGAdmin = new GroupMember();
        pmsvFAGAdmin.UserOrGroupId = AdminPEOCId;
        pmsvFAGAdmin.GroupId = pmsvFAGAdminGroup.Id;
        insert(pmsvFAGAdmin);
        //Create PMSVTransportation Group
        Group pmsvTAdminGroup = [select id from Group where developername = 'ESS_PMSV_Transportation'];
        GroupMember pmsvTAdmin = new GroupMember();
        pmsvTAdmin.UserOrGroupId = AdminPEOCId;
        pmsvTAdmin.GroupId = pmsvTAdminGroup.Id;
        insert(pmsvTAdmin);
        //Create PMSV Group
        Group pmsvAdminGroup = [select id from Group where developername = 'ESS_PMSV'];
        GroupMember pmsvAdmin = new GroupMember();
        pmsvAdmin.UserOrGroupId = AdminPEOCId;
        pmsvAdmin.GroupId = pmsvAdminGroup.Id;
        insert(pmsvAdmin);
        //Create Related Group
        Group relatedAdminGroup = [select id from Group where developername = 'ESS_Related'];
        GroupMember relatedAdmin = new GroupMember();
        relatedAdmin.UserOrGroupId = AdminPEOCId;
        relatedAdmin.GroupId = relatedAdminGroup.Id;
        insert(relatedAdmin);
        
    }
    
    @isTest
    public static void GlobalTOPTest() {
        
        Test.startTest();
        
        datetime dt = system.Datetime.now();
        
        ESS_Global.convertDateTimeFromJSON(dt);
        ESS_Global.convertDateTimeForExcel(dt);
        ESS_Global.convertDateTimeFilter(dt);
        ESS_Global.convertDateFilter(dt);
        ESS_Global.convertDateTimeToDateWithTime(dt);
        ESS_Global.convertExcelStartDateTimeFilter(dt);
        ESS_Global.convertExcelEndDateTimeFilter(dt);
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        string Username;
        string EmployeeId;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, employeeid__c, level__c, posid__c, sectheadupposid__c, user__c, en_fullname__c, th_fullname__c, objenfullname__c from PISUsers__c where User__c =: UserId];
        PISUsers__c PISUser = [select id, employeeid__c, level__c, posid__c, sectheadupposid__c, user__c, en_fullname__c, th_fullname__c, objenfullname__c from PISUsers__c where User__c =: UserId];
        
        ESS_Global.checkPRTRUser(UserId);
        ESS_Global.assignToUser(UserId);
        ESS_Global.assignToPISUserFromEmployeeId('00000003');
        ESS_Global.findingUserManagerAndCC(UserId);
        ESS_Global.findingCC(UserId);
        
        ESS_Global.getByUsername(Username);
        ESS_Global.assignToPISUser(UserId);
        ESS_Global.assignToPersonelAdminPISUser();
        ESS_Global.assignToPersonelAdminUser();
        ESS_Global.assignToLetterAdminPISUser();
        ESS_Global.assignToLetterAdminUser();
        ESS_Global.assignToProbationAdminPISUser();
        ESS_Global.assignToProbationAdminUser();
        ESS_Global.assignToRetirementAdminPISUser();
        ESS_Global.assignToRetirementAdminUser();
        ESS_Global.assignToPMBPAdminPISUser();
        ESS_Global.assignToPMBPAdminUser();
        ESS_Global.assignToPEOCAdminPISUser();
        ESS_Global.assignToPEOCAdminUser();
        ESS_Global.isPMBPAdmin(UserId);
        ESS_Global.isPEOCAdmin(UserId);
        ESS_Global.GetSectionHeadDepartmentHeadManpower(PISUser, PISUsers); 
        ESS_Global.GetLevels();
        ESS_Global.GetFunctions(null);
        ESS_Global.GetDepartments(null);
        ESS_Global.GetSections(null);
        ESS_Global.GetUnits(null);
        ESS_Global.emailURL('test');
        
        List<PISUsers__c> allPISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND Mainposition__c = true AND User__c != null];
            
        Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
        if(allPISUsers.size() > 0) {
            for(PISUsers__c existPISUser : allPISUsers) { 
                mapPISUsers.put(existPISUser.User__c, existPISUser);
            }    
        }
        
        //ESS_Global.getMasterEmployee(PISUser.employeeId__c); //Uncomment
        ESS_Global.GetSectionHeadDepartmentHead(PISUser, mapPISUsers); //Uncomment
        ESS_Global.GetSectionHeadDepartmentHeadProbation(PISUser, mapPISUsers); //Uncomment
        ESS_Global.GetFunctions('TOP'); //Uncomment
        
        ESS_Global.GetFunctions('TES');
        
        Test.stopTest();
    }
    
    @isTest
    public static void GlobalTest() {
        
        Test.startTest();
        
        datetime dt = system.Datetime.now();
        
        ESS_Global.convertDateTimeFromJSON(dt);
        ESS_Global.convertDateTimeForExcel(dt);
        ESS_Global.convertDateTimeFilter(dt);
        ESS_Global.convertDateFilter(dt);
        ESS_Global.convertDateTimeToDateWithTime(dt);
        ESS_Global.convertExcelStartDateTimeFilter(dt);
        ESS_Global.convertExcelEndDateTimeFilter(dt);
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        string Username;
        string EmployeeId;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, employeeid__c, level__c, posid__c, sectheadupposid__c, user__c, en_fullname__c, th_fullname__c, objenfullname__c from PISUsers__c where User__c =: UserId];
        PISUsers__c PISUser = [select id, employeeid__c, level__c, posid__c, sectheadupposid__c, user__c, en_fullname__c, th_fullname__c, objenfullname__c from PISUsers__c where User__c =: UserId];
        
        ESS_Global.assignToPMSVFixAndGeneralAdminPISUser();
        ESS_Global.assignToPMSVTransportationAdminPISUser();
        ESS_Global.assignToPMSVAdminPISUser();
        ESS_Global.assignToRelatedPISUser();
        ESS_Global.assignToESSPMSVPISUser();
        ESS_Global.assignToESSPMSVUser();
        ESS_Global.assignToESSPMSVFixAndGeneralPISUser();
        ESS_Global.assignToESSPMSVFixAndGeneralUser();
        ESS_Global.assignToESSPMSVTransportationPISUser();
        ESS_Global.assignToESSPMSVTransportationUser();
        ESS_Global.assignToESSPMSVStationaryPISUser();
        ESS_Global.assignToESSGSBOStationaryPISUser();
        ESS_Global.assignToESSPMSVStationaryPRTR();
        ESS_Global.assignToESSGSBOStationaryPRTR();
        ESS_Global.assignToESSPMSVHotelPISUser();
        ESS_Global.assignToESSPMSVHotelUser();
        
        Test.stopTest();
    }
    
    @isTest
    public static void GlobalTESTest() {
        
        Test.startTest();
        
        datetime dt = system.Datetime.now();
        
        ESS_Global.convertDateTimeFilter(dt);
        ESS_Global.convertDateFilter(dt);
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        string Username;
        string EmployeeId;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
            }
        }
        
        List<PISUsers__c> PISUsers = [select id, employeeid__c, level__c, posid__c, sectheadupposid__c, user__c, en_fullname__c, th_fullname__c, objenfullname__c from PISUsers__c where User__c =: UserId];
        PISUsers__c PISUser = [select id, employeeid__c, level__c, posid__c, sectheadupposid__c, user__c, en_fullname__c, th_fullname__c, objenfullname__c from PISUsers__c where User__c =: UserId];
        
        ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
        PageParam.pageNo = 1;
        PageParam.pageSize = 10;
        
        ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
        SortByParam.sortBy = 'documentNo';
        SortByParam.ascending = true;
        
        ESS_Global.assignToPersonelAdminPISUser();
        
        ESS_Global.getByUsername(Username);
        ESS_Global.assignToPISUser(UserId);
        //ESS_Global.getMasterEmployee(PISUser.employeeId__c); //Uncomment
        ESS_Global.assignToPersonelAdminPISUser();
        ESS_Global.assignToLetterAdminPISUser();
        ESS_Global.assignToProbationAdminPISUser();
        ESS_Global.assignToRetirementAdminPISUser();
        ESS_Global.assignToPMBPAdminPISUser();
        ESS_Global.assignToPEOCAdminPISUser();
        ESS_Global.isPMBPAdmin(UserId);
        ESS_Global.isPEOCAdmin(UserId);
        ESS_Global.assignToPMSVFixAndGeneralAdminPISUser();
        ESS_Global.assignToPMSVTransportationAdminPISUser();
        ESS_Global.assignToPMSVAdminPISUser();
        ESS_Global.assignToRelatedPISUser();
        ESS_Global.assignToESSPMSVPISUser();
        ESS_Global.assignToESSPMSVFixAndGeneralPISUser();
        ESS_Global.assignToESSPMSVTransportationPISUser();
        //ESS_Global.GetSectionHeadDepartmentHead(PISUser, PISUsers); //Uncomment
        //ESS_Global.GetSectionHeadDepartmentHeadProbation(PISUser, PISUsers); //Uncomment
        ESS_Global.GetSectionHeadDepartmentHeadManpower(PISUser, PISUsers); 
        ESS_Global.GetLevels();
        ESS_Global.GetFunctions(null);
        ESS_Global.GetDepartments(null);
        ESS_Global.GetSections(null);
        ESS_Global.GetUnits(null);
        
        Test.stopTest();
    }
    
}