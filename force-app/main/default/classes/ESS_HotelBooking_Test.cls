@isTest
public with sharing class ESS_HotelBooking_Test {

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
        Config.HotelBooking_Running_No__c = '0';
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
        ramon.HOST_COMP__c = '1100';
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
        ramon.Hotel_Privilege__c = true;
        insert(ramon);
        
        PISUsers__c ratri = new PISUsers__c();
        ratri.Active__c = true;
        ratri.MAINPOSITION__c = true;
        ratri.EMPLOYEEID__c = '00000002';
        ratri.HOME_COMP__c = '1100';
        ratri.Name = 'Test Ratri';
        ratri.LEVEL__c = 'Section Head';
        ratri.ORGID__c = '00000002';
        ratri.POSID__c = '00000002';
        ratri.ENFIRSTNAME__c = 'Test';
        ratri.ENLASTNAME__c = 'Test Ratri';
        ratri.HOLDERPOSITION__c = '00000002';
        ratri.EMAIL__c = 'testratri@thaioilgroup.com';
        ratri.User__c = RatriId;
        ratri.ReportToPOS__c = '00000001';
        ratri.ReportToID__c = '00000001';
        ratri.ReportToEmail__c = 'testramon@thaioilgroup.com';
        ratri.ReportToUser__c = RamonId;
        ratri.SectHeadUpUser__c = RamonId;
        ratri.SectHeadUpPosID__c = '00000001';
        ratri.Subcordinate__c = '[""]';
        ratri.Hotel_Privilege__c = true;
        insert(ratri);
        
        PISUsers__c damrong = new PISUsers__c();
        damrong.Active__c = true;
        damrong.MAINPOSITION__c = true;
        damrong.EMPLOYEEID__c = '00000003';
        damrong.HOME_COMP__c = '1600';
        damrong.Name = 'Test Damrong';
        damrong.LEVEL__c = 'Section Head';
        damrong.ORGID__c = '00000003';
        damrong.POSID__c = '00000003';
        damrong.ENFIRSTNAME__c = 'Test';
        damrong.ENLASTNAME__c = 'Test Damrong';
        damrong.HOLDERPOSITION__c = '00000003';
        damrong.EMAIL__c = 'testdamrong@thaioilgroup.com';
        damrong.User__c = DamrongId;
        damrong.ReportToPOS__c = '00000003';
        damrong.ReportToID__c = '00000003';
        damrong.ReportToEmail__c = 'testdamrong@thaioilgroup.com';
        damrong.ReportToUser__c = DamrongId;
        damrong.SectHeadUpUser__c = DamrongId;
        damrong.SectHeadUpPosID__c = '00000003';
        damrong.Subcordinate__c = '[""]';
        damrong.Hotel_Privilege__c = true;
        insert(damrong);
        
        
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
        suraphan.Hotel_Privilege__c = true;
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
        narongsak.Hotel_Privilege__c = true;
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
        userManager.Hotel_Privilege__c = true;
        insert(userManager);
    }
    
    @future
    public static void insertPublicGroup() {
        
        List<User> Users = [select id, alias from User];
        
        Id AdminPMSVId;
        Id AdminHotelId;
        
        for(User U : Users) {
            if(U.alias == 'PA') {
                AdminPMSVId = U.Id;
            }
            else if(U.alias == 'KI') {
                AdminHotelId = U.Id;
            }
        }
        
        //Create PMSVHotel Group
        Group pmsvHotelAdminGroup = [select id from Group where developername = 'ESS_PMSV_Hotel'];
        GroupMember pmsvHotelAdmin = new GroupMember();
        pmsvHotelAdmin.UserOrGroupId = AdminHotelId;
        pmsvHotelAdmin.GroupId = pmsvHotelAdminGroup.Id;
        insert(pmsvHotelAdmin);
        //Create Secretary Group
        Group secretaryGroup = [select id from Group where developername = 'ESS_Secretary_Hotel'];
        GroupMember secretaryAdmin = new GroupMember();
        secretaryAdmin.UserOrGroupId = AdminHotelId;
        secretaryAdmin.GroupId = secretaryGroup.Id;
        insert(secretaryAdmin);
        
    }
    
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO initialHotelBookingDetail(User runAsUser) {
        
        ESS_HotelBooking_DTO.HotelBookingDetailDTO Detail = new ESS_HotelBooking_DTO.HotelBookingDetailDTO();
        Detail.isPRTRUser = false;
        Detail.checkIn = date.today();
        Detail.checkOut = date.today().addDays(2);
        Detail.onBehalfOfFlow = false;
        Detail.isOnBehalf = false;
        Detail.status = new ESS_Global.EnumValue('HotelBookingStatus');
        Detail.status.key = ESS_Enum.HotelBookingStatus.Draft.name();
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
        return Detail;
    }
    
    public static ESS_HotelBooking_DTO.HotelBookingDetailDTO initialOnBehalfDetail(User runAsUser, string onBehalfId) {
        
        ESS_HotelBooking_DTO.HotelBookingDetailDTO Detail = new ESS_HotelBooking_DTO.HotelBookingDetailDTO();
        Detail.isPRTRUser = false;
        Detail.checkIn = date.today();
        Detail.checkOut = date.today().addDays(2);
        Detail.status = new ESS_Global.EnumValue('HotelBookingStatus');
        Detail.status.key = ESS_Enum.HotelBookingStatus.Draft.name();
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
    
    @isTest
    public static void ESSHotelBookingMethodTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000002';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            MasterHB.Hotel_Name__c = 'Test';
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Employee_Id__c = '00000002';
            HotelBooking.On_Behalf_Of_Employee_Id__c = '00000001';
            HotelBooking.Use_This_Year_Quota__c = true;
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Completed.name();
            HotelBooking.OwnerId = runAsUser.Id;
            HotelBooking.On_Behalf_Of_Flow__c = false;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Completed_Date__c = date.today();
            insert(HotelBooking);
            
            HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0002';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Employee_Id__c = '00000002';
            HotelBooking.On_Behalf_Of_Employee_Id__c = '00000001';
            HotelBooking.Use_This_Year_Quota__c = false;
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Completed.name();
            HotelBooking.OwnerId = runAsUser.Id;
            HotelBooking.On_Behalf_Of_Flow__c = false;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Requester_Id__c = runAsUser.Id;
            HotelBooking.Rating_Date__c = date.today();
            HotelBooking.Rating_Date_2__c = date.today();
            insert(HotelBooking);
            
            ESS_HotelBooking.checkCanCancelRequestHotelBooking(HotelBooking, runAsUser.Id);
            ESS_HotelBooking.checkCanShowSAPStatus(HotelBooking, runAsUser.Id);
            ESS_HotelBooking.checkCanRatingHotelBooking(HotelBooking, runAsUser.Id);
            ESS_HotelBooking.checkShowRatingFormHotelBooking(HotelBooking, runAsUser.Id);
            ESS_HotelBooking.checkShowRatingFormOBHHotelBooking(HotelBooking, runAsUser.Id);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingMasterTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            MasterHB.Hotel_Name__c = 'Test';
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            insert(HotelBooking);
                        
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'hotelId';
            SortByParam.ascending = true;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_HotelBooking.GetMasterHotelBookingListCount();
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'hotelName';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'guest1ContractRate';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'guest1ChargeEmployee';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'guest2ContractRate';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'guest2ChargeEmployee';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'twinBedContractRate';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'twinBedChargeEmployee';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'contactName';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'contactEmail';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'contactTelephone';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'location';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'hotelWebsite';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetMasterHotelBookingList(SortByParam, PageParam);
         
            ESS_HotelBooking_DTO.SearchDTO SearchDTO = new ESS_HotelBooking_DTO.SearchDTO();
            SearchDTO.search = 'Test';
            ESS_HotelBooking.MasterHotelList(SearchDTO);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000002';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            MasterHB.Hotel_Name__c = 'Test';
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Employee_Id__c = '00000002';
            HotelBooking.On_Behalf_Of_Employee_Id__c = '00000001';
            HotelBooking.Use_This_Year_Quota__c = true;
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Completed.name();
            HotelBooking.OwnerId = runAsUser.Id;
            HotelBooking.On_Behalf_Of_Flow__c = false;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Completed_Date__c = date.today();
            insert(HotelBooking);
            
            HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0002';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Employee_Id__c = '00000002';
            HotelBooking.On_Behalf_Of_Employee_Id__c = '00000001';
            HotelBooking.Use_This_Year_Quota__c = false;
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Completed.name();
            HotelBooking.OwnerId = runAsUser.Id;
            HotelBooking.On_Behalf_Of_Flow__c = false;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Completed_Date__c = date.today();
            insert(HotelBooking);
            
            ESS_HotelBooking_DTO.HotelBookingDetailDTO detail = initialOnBehalfDetail(runAsUser, AdminPMSVId);
            detail.recordId = HotelBooking.Id;
            detail.masterHotelId = MasterHB.Id;
            detail.hotelName = 'Test';
            ESS_HotelBooking_DTO.SearchDTO SearchDTO = new ESS_HotelBooking_DTO.SearchDTO();
            ESS_HotelBooking.GetHotelBookingDetail(SearchDTO);
            
            ESS_HotelBooking_DTO.HotelBookingRoomDTO HotelBookingRoom = new ESS_HotelBooking_DTO.HotelBookingRoomDTO();
            HotelBookingRoom.guestNo = 1;
            HotelBookingRoom.roomType = new ESS_Global.EnumValue('HotelRoomType');
            HotelBookingRoom.roomType.key = ESS_Enum.HotelRoomType.KingBed.name();
            HotelBookingRoom.roomType.value = ESS_Enum.HotelRoomType.KingBed.name();
            HotelBookingRoom.request = new ESS_Global.EnumValue('HotelBedType');
            HotelBookingRoom.request.key = ESS_Enum.HotelBedType.StandardSingle.name();
            HotelBookingRoom.request.value = ESS_Enum.HotelBedType.StandardSingle.name();
            HotelBookingRoom.contractRate = 1000;
            HotelBookingRoom.chargeEmployee = 500;
            detail.hotelBookingRooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
            detail.hotelBookingRooms.add(HotelBookingRoom);
            ESS_HotelBooking_DTO.HotelBookingDetailDTO saveDetail = ESS_HotelBooking.SaveHotelBooking(detail);
            
            ESS_HotelBooking.checkPRTRUser();
            ESS_HotelBooking.checkPRTRAdminUser();
            ESS_HotelBooking.GetAvailableRoom('00000002');
            ESS_HotelBooking.GetAvailableRoomNextYear('00000002');
            
            ESS_HotelBooking.SearchFilter SearchCriteria = new ESS_HotelBooking.SearchFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.startCheckInDate = date.today();
            SearchCriteria.endCheckInDate = date.today().addDays(7);
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_HotelBooking.GetHotelBookingListCount(SearchCriteria);
            ESS_HotelBooking.GetHotelBookingList(SearchCriteria, SortByParam, PageParam);
            
            saveDetail.masterHotelId = MasterHB.Id;
            ESS_HotelBooking.SendEmailOutToHotel(saveDetail);
            
            ESS_HotelBooking_DTO.RejectCancelDTO RejectCancel = new ESS_HotelBooking_DTO.RejectCancelDTO();
            RejectCancel.recordId = HotelBooking.Id;
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Completed.name();
            update(HotelBooking);
            ESS_HotelBooking.CancelRequestHotelBooking(RejectCancel);
            
            ESS_Hotel_SAP__c HotelSAP = new ESS_Hotel_SAP__c();
            HotelSAP.RecordId__c = '1';
            HotelSAP.HotelBookingId__c = HotelBooking.Id;
            insert(HotelSAP);
            ESS_HotelBooking.sendDataToHotelSAP(HotelBooking);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingSortByTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000002';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            MasterHB.Hotel_Name__c = 'Test';
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Employee_Id__c = '00000002';
            HotelBooking.On_Behalf_Of_Employee_Id__c = '00000001';
            HotelBooking.Use_This_Year_Quota__c = true;
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Completed.name();
            HotelBooking.OwnerId = runAsUser.Id;
            HotelBooking.On_Behalf_Of_Flow__c = false;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Completed_Date__c = date.today();
            insert(HotelBooking);
            
            HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0002';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Employee_Id__c = '00000002';
            HotelBooking.On_Behalf_Of_Employee_Id__c = '00000001';
            HotelBooking.Use_This_Year_Quota__c = false;
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Completed.name();
            HotelBooking.OwnerId = runAsUser.Id;
            HotelBooking.On_Behalf_Of_Flow__c = false;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Completed_Date__c = date.today();
            insert(HotelBooking);
            
            ESS_HotelBooking_DTO.HotelBookingDetailDTO detail = initialOnBehalfDetail(runAsUser, AdminPMSVId);
            detail.recordId = HotelBooking.Id;
            detail.masterHotelId = MasterHB.Id;
            detail.hotelName = 'Test';
            ESS_HotelBooking_DTO.SearchDTO SearchDTO = new ESS_HotelBooking_DTO.SearchDTO();
            ESS_HotelBooking.GetHotelBookingDetail(SearchDTO);
            
            ESS_HotelBooking_DTO.HotelBookingRoomDTO HotelBookingRoom = new ESS_HotelBooking_DTO.HotelBookingRoomDTO();
            HotelBookingRoom.guestNo = 1;
            HotelBookingRoom.roomType = new ESS_Global.EnumValue('HotelRoomType');
            HotelBookingRoom.roomType.key = ESS_Enum.HotelRoomType.KingBed.name();
            HotelBookingRoom.roomType.value = ESS_Enum.HotelRoomType.KingBed.name();
            HotelBookingRoom.request = new ESS_Global.EnumValue('HotelBedType');
            HotelBookingRoom.request.key = ESS_Enum.HotelBedType.StandardSingle.name();
            HotelBookingRoom.request.value = ESS_Enum.HotelBedType.StandardSingle.name();
            HotelBookingRoom.contractRate = 1000;
            HotelBookingRoom.chargeEmployee = 500;
            detail.hotelBookingRooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
            detail.hotelBookingRooms.add(HotelBookingRoom);
            ESS_HotelBooking_DTO.HotelBookingDetailDTO saveDetail = ESS_HotelBooking.SaveHotelBooking(detail);
            
            ESS_HotelBooking.SearchFilter SearchCriteria = new ESS_HotelBooking.SearchFilter();
            SearchCriteria.documentNo = '';
            SearchCriteria.status = 'All';
            SearchCriteria.startCheckInDate = date.today();
            SearchCriteria.endCheckInDate = date.today().addDays(7);
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_HotelBooking.GetHotelBookingListCount(SearchCriteria);
            ESS_HotelBooking.GetHotelBookingList(SearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingList(SearchCriteria, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'checkIn';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingList(SearchCriteria, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'checkOut';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingList(SearchCriteria, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingList(SearchCriteria, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'completedDate';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingList(SearchCriteria, SortByParam, PageParam);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingAdminTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            insert(HotelBooking);
                        
            ESS_HotelBooking_DTO.HotelBookingDetailDTO detail = initialOnBehalfDetail(runAsUser, AdminPMSVId);
            detail.recordId = HotelBooking.Id;
            detail.masterHotelId = MasterHB.Id;
            detail.hotelName = 'Test';
            ESS_HotelBooking_DTO.SearchDTO SearchDTO = new ESS_HotelBooking_DTO.SearchDTO();
            ESS_HotelBooking.GetHotelBookingDetail(SearchDTO);
            
            ESS_HotelBooking_DTO.HotelBookingRoomDTO HotelBookingRoom = new ESS_HotelBooking_DTO.HotelBookingRoomDTO();
            HotelBookingRoom.guestNo = 1;
            HotelBookingRoom.roomType = new ESS_Global.EnumValue('HotelRoomType');
            HotelBookingRoom.roomType.key = ESS_Enum.HotelRoomType.KingBed.name();
            HotelBookingRoom.roomType.value = ESS_Enum.HotelRoomType.KingBed.name();
            HotelBookingRoom.request = new ESS_Global.EnumValue('HotelBedType');
            HotelBookingRoom.request.key = ESS_Enum.HotelBedType.StandardSingle.name();
            HotelBookingRoom.request.value = ESS_Enum.HotelBedType.StandardSingle.name();
            HotelBookingRoom.contractRate = 1000;
            HotelBookingRoom.chargeEmployee = 500;
            detail.hotelBookingRooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
            detail.hotelBookingRooms.add(HotelBookingRoom);
            ESS_HotelBooking_DTO.HotelBookingDetailDTO saveDetail = ESS_HotelBooking.SaveHotelBooking(detail);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_HotelBooking.AdminSearchFilter AdminSearchCriteria = new ESS_HotelBooking.AdminSearchFilter();
            AdminSearchCriteria.documentNo = '';
            AdminSearchCriteria.status = 'All';
            AdminSearchCriteria.startCheckInDate = date.today();
            AdminSearchCriteria.endCheckInDate = date.today().addDays(7);
            AdminSearchCriteria.startCreatedDate = date.today();
            AdminSearchCriteria.endCreatedDate = date.today().addDays(7);
            AdminSearchCriteria.startCompletedDate = date.today();
            AdminSearchCriteria.endCompletedDate = date.today().addDays(7);
            
            ESS_HotelBooking.GetHotelBookingForAdminListCount(AdminSearchCriteria);
            ESS_HotelBooking.GetHotelBookingForAdminList(AdminSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'hotelName';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingForAdminList(AdminSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'checkIn';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingForAdminList(AdminSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'checkOut';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingForAdminList(AdminSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeName';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingForAdminList(AdminSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingForAdminList(AdminSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingForAdminList(AdminSearchCriteria, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'completedDate';
            SortByParam.ascending = true;
            ESS_HotelBooking.GetHotelBookingForAdminList(AdminSearchCriteria, SortByParam, PageParam);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingSubmitTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Employee_Id__c = '00000001';
            insert(HotelBooking);
                        
            ESS_HotelBooking_DTO.HotelBookingDetailDTO detail = initialOnBehalfDetail(runAsUser, AdminPMSVId);
            detail.recordId = HotelBooking.Id;
            detail.masterHotelId = MasterHB.Id;
            detail.hotelName = 'Test';
            ESS_HotelBooking_DTO.SearchDTO SearchDTO = new ESS_HotelBooking_DTO.SearchDTO();
            ESS_HotelBooking.GetHotelBookingDetail(SearchDTO);
            
            ESS_HotelBooking_DTO.HotelBookingRoomDTO HotelBookingRoom = new ESS_HotelBooking_DTO.HotelBookingRoomDTO();
            HotelBookingRoom.guestNo = 1;
            HotelBookingRoom.roomType = new ESS_Global.EnumValue('HotelRoomType');
            HotelBookingRoom.roomType.key = ESS_Enum.HotelRoomType.KingBed.name();
            HotelBookingRoom.roomType.value = ESS_Enum.HotelRoomType.KingBed.name();
            HotelBookingRoom.request = new ESS_Global.EnumValue('HotelBedType');
            HotelBookingRoom.request.key = ESS_Enum.HotelBedType.StandardSingle.name();
            HotelBookingRoom.request.value = ESS_Enum.HotelBedType.StandardSingle.name();
            HotelBookingRoom.contractRate = 1000;
            HotelBookingRoom.chargeEmployee = 500;
            detail.hotelBookingRooms = new List<ESS_HotelBooking_DTO.HotelBookingRoomDTO>();
            detail.hotelBookingRooms.add(HotelBookingRoom);
            
            ESS_HotelBooking_DTO.HotelBookingDetailDTO submitDetail = ESS_HotelBooking.SubmitHotelBooking(detail);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingCompleteTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Id__c = runAsUser.Id;
            HotelBooking.Requester_Name__c = 'Test';
            HotelBooking.Requester_Name_EN__c = 'Test';
            HotelBooking.Requester_Email__c = 'test@softever.co.th';
            HotelBooking.Attachment_Files__c = '012345678912345';
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.OnProcess.name();
            insert(HotelBooking);
                        
            ESS_HotelBooking_DTO.HotelBookingDetailDTO detail = initialHotelBookingDetail(runAsUser);
            detail.recordId = HotelBooking.Id;
            detail.masterHotelId = MasterHB.Id;
            detail.requesterEmployeeId = '00000001';
            detail.hotelName = 'Test';
            detail.checkIn = date.today();
            detail.checkOut = date.today().addDays(2);
            ESS_HotelBooking_DTO.SearchDTO SearchDTO = new ESS_HotelBooking_DTO.SearchDTO();
            ESS_HotelBooking_DTO.HotelBookingDetailDTO getDetail = ESS_HotelBooking.GetHotelBookingDetail(SearchDTO);
            
            ESS_DTO.FileDTO File = new ESS_DTO.FileDTO();
            File.id = HotelBooking.Id;
            
            getDetail.attachmentFiles = new List<ESS_DTO.FileDTO>();
            getDetail.attachmentFiles.add(File);
            getDetail.hotelAttachmentFiles = new List<ESS_DTO.FileDTO>();
            getDetail.hotelAttachmentFiles.add(File);
            
            ESS_HotelBooking.CompleteHotelBooking(getDetail);
            ESS_HotelBooking.SaveCompleteHotelBooking(getDetail);
            ESS_HotelBooking.ConfirmedHotelBooking(getDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingRatingTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Id__c = runAsUser.Id;
            HotelBooking.Requester_Name__c = 'Test';
            HotelBooking.Requester_Name_EN__c = 'Test';
            HotelBooking.Requester_Email__c = 'test@softever.co.th';
            HotelBooking.Attachment_Files__c = '012345678912345';
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.OnProcess.name();
            insert(HotelBooking);
                        
            ESS_HotelBooking_DTO.HotelBookingDetailDTO detail = initialHotelBookingDetail(runAsUser);
            detail.recordId = HotelBooking.Id;
            detail.masterHotelId = MasterHB.Id;
            detail.requesterEmployeeId = '00000001';
            detail.requesterId = runAsUser.Id;
            detail.hotelName = 'Test';
            detail.checkIn = date.today();
            detail.checkOut = date.today().addDays(2);
            
            ESS_DTO.FileDTO File = new ESS_DTO.FileDTO();
            File.id = HotelBooking.Id;
            
            detail.attachmentFiles = new List<ESS_DTO.FileDTO>();
            detail.attachmentFiles.add(File);
            detail.hotelAttachmentFiles = new List<ESS_DTO.FileDTO>();
            detail.hotelAttachmentFiles.add(File);
            
            ESS_HotelBooking_DTO.HotelBookingDetailDTO saveDetail = ESS_HotelBooking.SaveHotelBooking(detail);
            ESS_HotelBooking.SaveRatingHotelBooking(saveDetail);
            
            HotelBooking.On_Behalf_Flow__c = true;
            HotelBooking.On_Behalf_Of_Id__c = runAsUser.Id;
            update(HotelBooking);
            ESS_HotelBooking.SaveRatingHotelBooking(saveDetail);
            
            ESS_HotelBooking_DTO.SearchDTO SearchDTO = new ESS_HotelBooking_DTO.SearchDTO();
            SearchDTO.search = 'Test';
            ESS_HotelBooking.SearchUsers(SearchDTO);
            
            ESS_HotelBooking_DTO.UploadFileDTO UploadFile = new ESS_HotelBooking_DTO.UploadFileDTO();
            UploadFile.fileName = 'Test';
            UploadFile.fileData = 'Test';
            UploadFile.recordId = HotelBooking.Id;            
            ESS_HotelBooking.UploadFile(UploadFile);
            
            ESS_Hotel_SAP__c HotelSAP = new ESS_Hotel_SAP__c();
            HotelSAP.HotelBookingId__c = HotelBooking.Id;
            HotelSAP.RecordId__c = '1';
            HotelSAP.Status__c = 'S';
            insert(HotelSAP);
            ESS_HotelBooking.getDataFromHotelSAP(HotelBooking);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingOBHTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000003';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000002';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            MasterHB.Hotel_Name__c = 'Test';
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Employee_Id__c = '00000002';
            HotelBooking.On_Behalf_Of_Employee_Id__c = '00000002';
            HotelBooking.Use_This_Year_Quota__c = true;
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Completed.name();
            HotelBooking.OwnerId = runAsUser.Id;
            HotelBooking.On_Behalf_Of_Flow__c = false;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Completed_Date__c = date.today();
            insert(HotelBooking);
            
            ESS_HotelBooking_DTO.HotelBookingDetailDTO detail = initialHotelBookingDetail(runAsUser);
            detail.recordId = HotelBooking.Id;
            ESS_HotelBooking_DTO.HotelBookingDetailDTO saveDetail = ESS_HotelBooking.SaveHotelBooking(detail);
            
            ESS_HotelBooking.GetAvailableRoomOnBehalfOfFlow('00000002');
            ESS_HotelBooking.GetAvailableRoomNextYearOnBehalfOfFlow('00000002');
            ESS_HotelBooking.GetOnBehalfCount();
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelVerifyTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            MasterHB.Hotel_Name__c = 'Test';
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Name__c = 'Test';
            HotelBooking.Requester_Name_EN__c = 'Test';
            HotelBooking.Requester_Email__c = 'test@softever.co.th';
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Verifying.name();
            insert(HotelBooking);
                        
            ESS_HotelBooking_DTO.SearchDTO Search = new ESS_HotelBooking_DTO.SearchDTO();
            Search.recordId = HotelBooking.Id;
            ESS_HotelBooking.VerifyHotelBooking(Search);
            
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Verifying.name();
            update(HotelBooking);
            
            List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> Cards = new List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO>();
            Cards = ESS_HotelBooking.GetHotelBookingList(null, null, null);
            Cards[0].isSelected = true;
            for(ESS_HotelBooking_DTO.HotelBookingRoomCardDTO Card : Cards) {
                if(Card.isSelected == null) {
                    Card.isSelected = false;
                }
            }
            
            ESS_HotelBooking.VerifyMultipleHotelBooking(Cards);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelRejectTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            MasterHB.Hotel_Name__c = 'Test';
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Name__c = 'Test';
            HotelBooking.Requester_Name_EN__c = 'Test';
            HotelBooking.Requester_Email__c = 'test@softever.co.th';
            HotelBooking.On_Behalf_Of__c = 'Test';
            HotelBooking.On_Behalf_Of_EN__c = 'Test';
            HotelBooking.On_Behalf_Of_Email__c = 'test@softever.co.th';
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Verifying.name();
            insert(HotelBooking);
                       
            ESS_HotelBooking_DTO.RejectCancelDTO Search = new ESS_HotelBooking_DTO.RejectCancelDTO();
            Search.recordId = HotelBooking.Id;
            ESS_HotelBooking.RejectHotelBooking(Search);
            
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Verifying.name();
            update(HotelBooking);
            
            List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO> Cards = new List<ESS_HotelBooking_DTO.HotelBookingRoomCardDTO>();
            Cards = ESS_HotelBooking.GetHotelBookingList(null, null, null);
            Cards[0].isSelected = true;
            for(ESS_HotelBooking_DTO.HotelBookingRoomCardDTO Card : Cards) {
                if(Card.isSelected == null) {
                    Card.isSelected = false;
                }
            }
            
            ESS_HotelBooking.RejectMultipleHotelBooking(Cards, 'Reject');
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelDeleteTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            MasterHB.Hotel_Name__c = 'Test';
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Name__c = 'Test';
            HotelBooking.Requester_Name_EN__c = 'Test';
            HotelBooking.Requester_Email__c = 'test@softever.co.th';
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Verifying.name();
            insert(HotelBooking);
            
            ESS_HotelBooking_DTO.SearchDTO Search = new ESS_HotelBooking_DTO.SearchDTO();
            Search.recordId = HotelBooking.Id;
            ESS_HotelBooking.DeleteHotelBooking(Search);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingExportTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Id__c = runAsUser.Id;
            HotelBooking.Requester_Name__c = 'Test';
            HotelBooking.Requester_Name_EN__c = 'Test';
            HotelBooking.Requester_Email__c = 'test@softever.co.th';
            HotelBooking.Attachment_Files__c = '012345678912345';
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.OnProcess.name();
            insert(HotelBooking);
                        
            ESS_HotelBooking_DTO.HotelBookingDetailDTO detail = initialHotelBookingDetail(runAsUser);
            detail.recordId = HotelBooking.Id;
            detail.masterHotelId = MasterHB.Id;
            detail.requesterEmployeeId = '00000001';
            detail.requesterId = runAsUser.Id;
            detail.hotelName = 'Test';
            detail.checkIn = date.today();
            detail.checkOut = date.today().addDays(2);
            
            ESS_DTO.FileDTO File = new ESS_DTO.FileDTO();
            File.id = HotelBooking.Id;
            
            detail.attachmentFiles = new List<ESS_DTO.FileDTO>();
            detail.attachmentFiles.add(File);
            detail.hotelAttachmentFiles = new List<ESS_DTO.FileDTO>();
            detail.hotelAttachmentFiles.add(File);
            
            ESS_HotelBooking_DTO.HotelBookingDetailDTO saveDetail = ESS_HotelBooking.SaveHotelBooking(detail);
            
            ESS_HotelBooking.AdminSearchFilter Filter = new ESS_HotelBooking.AdminSearchFilter();
            Filter.year = 2023;
            Filter.month = 6;
            ESS_HotelBooking.ExportHotelBookingExcel(Filter);
            ESS_HotelBooking.GetHotelSAPStatuses();
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSHotelBookingRoomTest() {
        
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
            
            ESS_Master_Employee__c ME = new ESS_Master_Employee__c();
            ME.Data__c = 'IN';
            ME.Employee_ID__c = '00000001';
            ME.Available_Room__c = 5;
            ME.Available_Room_Next_Year__c = 5;
            insert(ME);
            
            ESS_Master_Hotel_Booking__c MasterHB = new ESS_Master_Hotel_Booking__c();
            MasterHB.Active__c = true;
            MasterHB.Name = 'Test';
            MasterHB.Guest_1_Charge_Employee__c = 1000;
            MasterHB.Guest_1_Contract_Rate__c = 1000;
            insert(MasterHB);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Master_Hotel_Id__c = MasterHB.Id;
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.Check_In__c = date.today();
            HotelBooking.Check_Out__c = date.today().AddDays(1);
            HotelBooking.Completed_Date__c = date.today();
            HotelBooking.Hotel_Name__c = 'Test';
            HotelBooking.Adult__c = 1;
            HotelBooking.Night__c = 1;
            HotelBooking.Total_Room_Night__c = 1;
            HotelBooking.Room_JSON__c = '[{"total":1950,"specialRequest":null,"roomType":{"value":"King Bed","key":"KingBed","enumName":null},"request":{"value":"Standard Single","key":"StandardSingle","enumName":"HotelBedType"},"id":null,"guestNo":1,"contractRate":1500,"chargeEmployee":450}]';
            HotelBooking.Total_Charge_Employee__c = 1000;
            HotelBooking.Total_Charge_Company__c = 2000;
            HotelBooking.Submitted_Date__c = date.today();
            HotelBooking.Cancel_Comment__c = 'Cancel';
            HotelBooking.Requester_Employee_Id__c = '00000001';
            insert(HotelBooking);
                
            ESS_HotelBooking.GetAvailableRoom(HotelBooking);
            ESS_HotelBooking.DeductAvailableRoom(HotelBooking, 1);
            ESS_HotelBooking.AddAvailableRoom(HotelBooking, 1);
            ESS_HotelBooking.GetBookedRoom(HotelBooking);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void HotelBookingDTOTest() {
        Test.startTest();
        
        ESS_HotelBooking_DTO.MasterHotelBookingContactDTO MasterHotelBookingContactDTO = new ESS_HotelBooking_DTO.MasterHotelBookingContactDTO();
        MasterHotelBookingContactDTO.contactName = 'Test';
        MasterHotelBookingContactDTO.contactEmail = 'Test@softever.co.th';
        MasterHotelBookingContactDTO.contactTelephone = '0811231234';
        
        ESS_HotelBooking_DTO.HotelBookingExcelDTO HotelBookingExcelDTO = new ESS_HotelBooking_DTO.HotelBookingExcelDTO();
        HotelBookingExcelDTO.documentNo = 'WF-2023-06-0001';
        HotelBookingExcelDTO.hotelName = 'Hotel';
        HotelBookingExcelDTO.guestName = 'Guest';
        HotelBookingExcelDTO.checkInDate = date.today();
        HotelBookingExcelDTO.checkOutDate = date.today();
        HotelBookingExcelDTO.room1GuestNo = 1;
        HotelBookingExcelDTO.room1RoomType = 'King Bed';
        HotelBookingExcelDTO.room1SpecialRequest = 'Request';
        HotelBookingExcelDTO.room1TotalContractRate = 1000;
        HotelBookingExcelDTO.room1TotalChargeCompany = 500;
        HotelBookingExcelDTO.room1TotalChargeEmployee = 500;
        HotelBookingExcelDTO.room2guestNo = 1;
        HotelBookingExcelDTO.room2RoomType = 'King Bed';
        HotelBookingExcelDTO.room2SpecialRequest = 'Request';
        HotelBookingExcelDTO.room2TotalContractRate = 1000;
        HotelBookingExcelDTO.room2TotalChargeCompany = 500;
        HotelBookingExcelDTO.room2TotalChargeEmployee = 500;
        HotelBookingExcelDTO.total = 2000;
        HotelBookingExcelDTO.totalChargeCompany = 1000;
        HotelBookingExcelDTO.totalChargeEmployee = 1000;
        HotelBookingExcelDTO.totalNight = 1;
        HotelBookingExcelDTO.totalRoom = 1;
        HotelBookingExcelDTO.totalGuest = 1;
        HotelBookingExcelDTO.remark = 'None';
        HotelBookingExcelDTO.requesterName = 'Requester';
        HotelBookingExcelDTO.requesterEmployeeId = '00000001';
        HotelBookingExcelDTO.requesterEmail = 'test@softever.co.th';
        HotelBookingExcelDTO.requesterPosition = 'Position';
        HotelBookingExcelDTO.requesterFunction = 'Function';
        HotelBookingExcelDTO.requesterDepartment = 'Department';
        HotelBookingExcelDTO.requesterSection = 'Section';
        HotelBookingExcelDTO.requesterUnit = 'Unit';
        HotelBookingExcelDTO.obhName = 'Requester';
        HotelBookingExcelDTO.obhEmployeeId = '00000001';
        HotelBookingExcelDTO.obhEmail = 'test@softever.co.th';
        HotelBookingExcelDTO.obhPosition = 'Position';
        HotelBookingExcelDTO.obhFunction = 'Function';
        HotelBookingExcelDTO.obhDepartment = 'Department';
        HotelBookingExcelDTO.obhSection = 'Section';
        HotelBookingExcelDTO.obhUnit = 'Unit';
        HotelBookingExcelDTO.createdDate = date.today();
        HotelBookingExcelDTO.submittedDate = date.today();
        HotelBookingExcelDTO.verifiedDate = date.today();
        HotelBookingExcelDTO.completedDate = date.today();
        HotelBookingExcelDTO.rejectedDate = date.today();
        HotelBookingExcelDTO.cancelledDate = date.today();
        HotelBookingExcelDTO.completedBy = 'Admin';
        HotelBookingExcelDTO.verifiedBy = 'Admin';
        HotelBookingExcelDTO.rejectedBy = 'Admin';
        HotelBookingExcelDTO.cancelledBy = 'Admin';
        HotelBookingExcelDTO.rejectedReason = 'Reason';
        HotelBookingExcelDTO.cancelledReason = 'Reason';
        HotelBookingExcelDTO.currentStatus = 'Status';
        HotelBookingExcelDTO.requesterRatingCompleted = true;
        HotelBookingExcelDTO.requesterRating = 5;
        HotelBookingExcelDTO.requesterAttentiveness = true;
        HotelBookingExcelDTO.requesterFast = true;
        HotelBookingExcelDTO.requesterPunctuality = true;
        HotelBookingExcelDTO.requesterExpertise = true;
        HotelBookingExcelDTO.obhRatingCompleted = true;
        HotelBookingExcelDTO.obhRating = 5;
        HotelBookingExcelDTO.obhAttentiveness = true;
        HotelBookingExcelDTO.obhFast = true;
        HotelBookingExcelDTO.obhPunctuality = true;
        HotelBookingExcelDTO.obhExpertise = true;
        HotelBookingExcelDTO.obhExpertise = true;
        
        Test.stopTest();
    }    
}