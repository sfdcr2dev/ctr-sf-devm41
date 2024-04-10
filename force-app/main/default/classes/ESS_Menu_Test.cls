@isTest
public class ESS_Menu_Test {

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
        
        //Insert ESS_Config
        ESS_Config__c Config = new ESS_Config__c();
        Config.Application_Running_No__c = '0';
        Config.Letter_LR1_Running_No__c = '0';
        Config.Letter_LR2_Running_No__c = '0';
        Config.Letter_LR3_Running_No__c = '0';
        Config.Letter_LR4_Running_No__c = '0';
        Config.Letter_LR5_Running_No__c = '0';
        Config.Retirement_Running_No__c = '0';
        Config.Probationary_Running_No__c = '0';
        Config.Manpower_Running_No__c = '0';
        Config.FixAndGeneral_Running_No__c = '0';
        insert(Config);
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
        ramon.COMPANYNAME__c = 'TOP';
        ramon.Retirement_Selection__c = true;
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
        damrong.COMPANYNAME__c = 'TOP';
        damrong.Retirement_Selection__c = true;
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
        ratri.COMPANYNAME__c = 'TOP';
        ratri.Retirement_Selection__c = true;
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
        suraphan.COMPANYNAME__c = 'TOP';
        suraphan.Retirement_Selection__c = true;
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
        narongsak.COMPANYNAME__c = 'TOP';
        narongsak.Retirement_Selection__c = true;
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
        adminPEOC.COMPANYNAME__c = 'TOP';
        adminPEOC.Retirement_Selection__c = true;
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
        Id AdminFAGId;
        
        for(User U : Users) {
            if(U.alias == 'PA') {
                AdminPMBPId = U.Id;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
            }
            else if(U.alias == 'NA') {
                AdminFAGId = U.Id;
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
        pmsvFAGAdmin.UserOrGroupId = AdminFAGId;
        pmsvFAGAdmin.GroupId = pmsvFAGAdminGroup.Id;
        insert(pmsvFAGAdmin);
        //Create PMSVTransportation Group
        Group pmsvTAdminGroup = [select id from Group where developername = 'ESS_PMSV_Transportation'];
        GroupMember pmsvTAdmin = new GroupMember();
        pmsvTAdmin.UserOrGroupId = AdminFAGId;
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
    public static void ESSMenuTest() {
        
        ESS_Menu__c Menu = new ESS_Menu__c();
        Menu.Group__c = 'Approval';
        Menu.Menu_Name__c = 'Employee Basic & Tax Information Update';
        insert(Menu);
        
        Menu = new ESS_Menu__c();
        Menu.Group__c = 'Approval';
        Menu.Menu_Name__c = 'Probation';
        insert(Menu);
        
        Menu = new ESS_Menu__c();
        Menu.Group__c = 'Approval';
        Menu.Menu_Name__c = 'Retirement';
        insert(Menu);
        
        Menu = new ESS_Menu__c();
        Menu.Group__c = 'Approval';
        Menu.Menu_Name__c = 'Manpower';
        insert(Menu);
        
        Menu = new ESS_Menu__c();
        Menu.Group__c = 'Approval';
        Menu.Menu_Name__c = 'Stationary';
        insert(Menu);
        
        Menu = new ESS_Menu__c();
        Menu.Group__c = 'Approval';
        Menu.Menu_Name__c = 'Hotel Booking';
        insert(Menu);
        
        Menu = new ESS_Menu__c();
        Menu.Group__c = 'Learning';
        Menu.Menu_Name__c = 'Thaioil Academy';
        insert(Menu);
        
        Menu = new ESS_Menu__c();
        Menu.Group__c = 'Learning';
        Menu.Menu_Name__c = 'Wisdom';
        insert(Menu);
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        User user;
        User adminPEOC;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                user = U;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
                adminPEOC = U;
            }
        }
        
        System.runAs(user) {
            //Insert Master Employee
            ESS_Master_Employee__c Master = new ESS_Master_Employee__c();
            Master.Data__c = 'IN';
            Master.ExternalId__c = '00000001';
            Master.Employee_ID__c = '00000001';
            Master.Employee_DOB__c = date.today();
            Master.Employee_Retirement_Date__c = date.today().addYears(1);
            Master.Employee_Date_Joined__c = date.today();
            //Name Section
            Master.Name_Emp_TH_Title_FN_LN__c = 'นาย เทส ซอฟ';
            Master.Name_Emp_EN_Title__c = '1';
            Master.Name_Emp_EN_FN__c = 'Test';
            Master.Name_Emp_EN_LN__c = 'Soft';
            //Status Section
            Master.Status_Marriage_Status__c = '1';
            Master.Status_Marriage_Doc_Issue_Date__c = date.today();
            //Child Section
            Master.Child_JSON__c = '';
            //Death Section
            Master.Death_Child_JSON__c = '';
            //Education Section
            Master.Education_JSON__c = '';
            //License Section
            Master.License_Citizen_Id__c = '1234567890123';
            Master.License_Citizen_Issue_Date__c = date.today();
            Master.License_Citizen_Expire_Date__c = date.today();
            //Address Section
            Master.Address_TH_House_No__c = '1';
            Master.Address_EN_House_No__c = '1';
            //Contact Person Section
            Master.Contact_Person_JSON__c = '';
            //Tax Section
            Master.Tax_Marriage_Status__c = '0';
            Master.Tax_Marriage_Person_Earn_Income__c = '1';
            insert(Master);

			ESS_Manpower__c Manpower = new ESS_Manpower__c();
            Manpower.On_Behalf_Of_Flow__c = false;
            Manpower.Service_For__c = ESS_Enum.ManpowerServiceFor.TOP.name();
            Manpower.G_L_Account__c = '123';
            Manpower.Cost_Center__c = '123';
            Manpower.Internal_Order_WBS__c = '123';
            Manpower.Type_of_Service__c = ESS_Enum.ManpowerTypeOfService.Permanent.name();
            Manpower.Objective__c = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
            Manpower.Date_of_Commencement__c = date.today();
            Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            Manpower.Approval_History_JSON__c = '[{"userId":"0052v00000i3PiuAAE","position":"LIQUIDITY MANAGEMENT TEAM","employeeName":"Areeya Boonma","comment":"","approverRole":{"value":"Employee","key":"Employee","enumName":"ManpowerApproverRole"},"approvalStatus":{"value":"Submitted","key":"Submitted","enumName":"ManpowerApprovalStatus"},"actionDate":"2022-12-22T02:43:44.961Z"}]';
            Manpower.Current_Status_JSON__c = '[{"userId":"0052v00000i3PiuAAE","position":"LIQUIDITY MANAGEMENT TEAM","employeeName":"Areeya Boonma","comment":"","approverRole":{"value":"Employee","key":"Employee","enumName":"ManpowerApproverRole"},"approvalStatus":{"value":"Submitted","key":"Submitted","enumName":"ManpowerApprovalStatus"},"actionDate":"2022-12-22T02:43:44.961Z"}]';
            Manpower.Requester_Id__c = user.Id;
            Manpower.Requester_Employee_Id__c = '00000001';
            Manpower.Requester_Name__c = 'Test';
            Manpower.Requester_Email__c = 'testUser@thaioilgroup.com';
            Manpower.Requester_Position__c = 'Test';
            Manpower.Requester_Function__c = 'AAAA';
            Manpower.Requester_Department__c = 'BBBB';
            Manpower.Requester_Section__c = 'CCCC';
            Manpower.Requester_Unit__c = 'DDDD';
            Manpower.Section_Head_Id__c = user.Id;
            insert(Manpower);
            
            ESS_Menu.GetMenuLists();
            ESS_Menu.CheckAllSection(Menu, 0);
            ESS_Menu.CheckApprovalSection(Menu, 0);
            ESS_Menu.CheckPersonalInformationSection(Menu);
            ESS_Menu.CheckTimeBenefitSection(Menu);
            //ESS_Menu.CheckEmployeeBasicCount(); //Uncomment
            ESS_Menu.CheckManpowerApprover(UserId, true);
            ESS_Menu.CheckManpowerPMBPAdminApprover(UserId);
            ESS_Menu.CheckManpowerPEOCAdminApprover(UserId);
            //ESS_Menu.isShowAdminMenu(UserId);
            
            ESS_Hotel_Booking__c HotelBooking = new ESS_Hotel_Booking__c();
            HotelBooking.Document_No__c = 'WF-2023-06-0001';
            HotelBooking.On_Behalf_Of_Id__c = user.Id;
            HotelBooking.Status__c = ESS_Enum.HotelBookingStatus.Verifying.name();
            insert(HotelBooking);
            ESS_Menu.GetOnBehalfCountHotelBooking();
            
            ESS_Stationary__c Stationary = new ESS_Stationary__c();
            Stationary.Document_No__c = 'SS-2023-06-0001';
            Stationary.On_Behalf_Of_Id__c = user.Id;
            Stationary.Status__c = ESS_Enum.StationaryServiceStatus.Verifying.name();
            insert(Stationary);
            ESS_Menu.GetOnBehalfCountStationary();
            
            ESS_FixAndGeneral__c FixAndGeneral = new ESS_FixAndGeneral__c();
            FixAndGeneral.Document_No__c = 'SS-2023-06-0001';
            FixAndGeneral.On_Behalf_Of_Id__c = user.Id;
            FixAndGeneral.Status__c = ESS_Enum.FixAndGeneralDocumentStatus.Verifying.name();
            insert(FixAndGeneral);
            ESS_Menu.GetOnBehalfCountFixAndGeneral();
            
            ESS_Retirement__c Retirement = new ESS_Retirement__c();
            Retirement.Document_No__c = 'RDC-2023-06-0001';
            Retirement.OwnerId = user.Id;
            Retirement.Employee_ID__c = '00000001';
            Retirement.Employee_Name__c = 'Test';
            Retirement.Submitted_Date__c = date.today();
            Retirement.Reject_Date__c = date.today();
            Retirement.Section_Head_Id__c = user.Id;
            Retirement.Department_Head_Id__c = user.Id;
            Retirement.Status__c = ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name();
            insert(Retirement);
            ESS_Menu.CheckRetirementApprover(user.Id);
            ESS_Menu.GetRetirementDetail();
            
            ESS_Probationary__c Probation = new ESS_Probationary__c();
            Probation.Document_No__c = 'PBT-2023-06-0001';
            Probation.OwnerId = user.Id;
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            Probation.Employee_ID__c = '00000001';
            Probation.Employee_Name__c = 'Test';
            Probation.Employee_Name_EN__c = 'Test';
            Probation.Submitted_Date__c = date.today();
            Probation.Section_Head_Id__c = user.Id;
            Probation.Department_Head_Id__c = user.Id;
            Probation.Section_Head_Approve_Date__c = date.today();
            Probation.Department_Head_Approve_Date__c = date.today();
            Probation.Probation_Confirmation__c = ESS_Enum.ProbationDepartmentHeadConfirmation.Confirm.name();
            Probation.Reassign_Section_Head_JSON__c = '[{"userId":"' + user.Id + '","submittedDate":null,"reassignedDate":"2023-06-28","position":"MANAGER-AREA D PRODUCTION UNIT OPERATION: OIL MOVEMENTS/LORRY LOADING","name":"Nipon Sietongkam","isAssignedBy":true,"employeeId":"00000558","comment":"sechead to reassign sechead"},{"userId":"' + user.Id + '","submittedDate":"2023-06-28","reassignedDate":"2023-06-28","position":"ASSISTANT AREA D PRODUCTION UNIT OPERATION MANAGER-OIL MOVEMENTS D","name":"Chaiporn Suksri","isAssignedBy":false,"employeeId":"00000550","comment":null},{"userId":"' + user.Id + '","submittedDate":null,"reassignedDate":"2023-06-28","position":"MANAGER-AREA D PRODUCTION UNIT OPERATION: OIL MOVEMENTS/LORRY LOADING","name":"Nipon Sietongkam","isAssignedBy":true,"employeeId":"00000558","comment":"sechead to reassigned sechead 2 "},{"userId":"' + user.Id + '","submittedDate":"2023-06-28","reassignedDate":"2023-06-28","position":"VICE PRESIDENT-PETROCHEMICAL AND LUBE BASE","name":"Sarunyu Limwongse","isAssignedBy":false,"employeeId":"00000909","comment":null}]';
            Probation.Reassign_Department_Head_JSON__c = '[{"userId":"' + user.Id + '","submittedDate":null,"reassignedDate":"2023-06-28","position":"VICE PRESIDENT-QUALITY MANAGEMENT","name":"Phumchit Tatsanaprasert","isAssignedBy":true,"employeeId":"00000668","comment":"dept head to reassigned dept head"},{"userId":"' + user.Id + '","submittedDate":"2023-06-28","reassignedDate":"2023-06-28","position":"VICE PRESIDENT-REFINERY","name":"Nuttapon Meerit","isAssignedBy":false,"employeeId":"00001089","comment":null}]';
            insert(Probation);
            ESS_Menu.CheckProbationaryApprover(user.Id);
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ESSMenuAdminTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        User user;
        User adminPEOC;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                user = U;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
                adminPEOC = U;
            }
        }
        
        System.runAs(adminPEOC) {
            ESS_Menu__c Menu = new ESS_Menu__c();
            Menu.Group__c = 'Approval';
            Menu.Menu_Name__c = 'Employee Basic & Tax Information Update';
            insert(Menu);
            
            ESS_Menu.GetMenuLists();
            ESS_Menu.CheckAllSection(Menu, 0);
            ESS_Menu.CheckApprovalSection(Menu, 0);
            ESS_Menu.CheckPersonalInformationSection(Menu);
            ESS_Menu.CheckTimeBenefitSection(Menu);
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ESSMenuAdminFAGTransportTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminFAGId;
        User user;
        User adminFAG;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                user = U;
            }
            else if(U.alias == 'NA') {
                AdminFAGId = U.Id;
                adminFAG = U;
            }
        }
        
        System.runAs(adminFAG) {
            ESS_Menu__c Menu = new ESS_Menu__c();
            Menu.Group__c = 'Approval';
            Menu.Menu_Name__c = 'Employee Basic & Tax Information Update';
            insert(Menu);
            
            ESS_Menu.CheckFixAndGeneralWaiting(adminFAG.Id);
        }
        
        Test.stopTest();
        
    }
    
     @isTest
    public static void ESSMenuPrivilegeTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        User user;
        User adminPEOC;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                user = U;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
                adminPEOC = U;
            }
        }
        
        System.runAs(adminPEOC) {
            ESS_Menu__c Menu = new ESS_Menu__c();
            Menu.Group__c = 'Approval';
            Menu.Menu_Name__c = 'Employee Basic & Tax Information Update';
            insert(Menu);
            
            ESS_Menu.isShowAdminMenu(adminPEOC.Id);
            
        }
        
        Test.stopTest();
        
    }
}