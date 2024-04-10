@isTest
public class ESS_FixAndGeneral_DTO_Test {

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
    
    @isTest
    public static void ESSFixAndGeneralTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
                runAsUser = U;
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
            
            ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO Detail = new ESS_FixAndGeneral_DTO.FixAndGeneralDetailDTO();
            Detail.documentNo = 'HS-2023-06-0001';
            Detail.onBehalfFlow = true;
            Detail.status = new ESS_Global.EnumValue('FixAndGeneralDocumentStatus');
            Detail.status.key = ESS_Enum.FixAndGeneralDocumentStatus.Draft.name();
            Detail.status.value = 'Draft';
            Detail.typeOfService = new ESS_Global.EnumValue('FixTypeOfService');
            Detail.typeOfService.key = ESS_Enum.FixTypeOfService.Housing.name();
            Detail.typeOfService.value = 'Housing';
            Detail.officeBuilding = 'Office Building';
            Detail.period = new ESS_Global.EnumValue('HousingPeriod');
            Detail.period.key = ESS_Enum.HousingPeriod.A.name();
            Detail.period.value = 'A';
            Detail.houseType = new ESS_Global.EnumValue('HousingType');
            Detail.houseType.key = ESS_Enum.HousingType.AHouse.name();
            Detail.houseType.value = 'A House';
            Detail.topic = 'Topic';
            Detail.detail = 'Detail';
            Detail.repairDate = date.today();
            Detail.expectedDueDate = date.today();
            Detail.repairArea = 'Area';
            Detail.floor = 'Floor';
            Detail.houseNo = '123';
            Detail.telNo = '021231234';
            Detail.mobileNo = '0811231234';
            Detail.requesterId = '1234567890';
            Detail.requesterEmployeeName = 'Test';
            Detail.requesterEmployeeNameEN = 'Test';
            Detail.requesterEmployeeId = '00000001';
            Detail.requesterEmail = 'test@softever.co.th';
            Detail.requesterPosition = 'Position';
            Detail.requesterFunction = 'Function';
            Detail.requesterDepartment = 'Department';
            Detail.requesterSection = 'Section';
            Detail.requesterUnit = 'Unit';
            Detail.onBehalfOfId = '1234567890';
            Detail.onBehalfOfEmployeeName = 'Test';
            Detail.onBehalfOfEmployeeNameEN = 'Test';
            Detail.onBehalfOfEmployeeId = '00000001';
            Detail.onBehalfOfEmail = 'test@softever.co.th';
            Detail.onBehalfOfPosition = 'Position';
            Detail.onBehalfOfFunction = 'Function';
            Detail.onBehalfOfDepartment = 'Department';
            Detail.onBehalfOfSection = 'Section';
            Detail.onBehalfOfUnit = 'Unit';
            Detail.createdDate = date.today();
            Detail.submittedDate = date.today();
            Detail.verifiedDate = date.today();
            Detail.acceptedDate = date.today();
            Detail.completedDate = date.today();
            Detail.rejectedDate = date.today();
            Detail.cancelledDate = date.today();
            Detail.completedBy = 'Admin';
            Detail.cancelledBy = 'Admin';
            Detail.rejectComment = 'Reject Comment';
            Detail.cancelComment = 'Cancel Comment';
            Detail.location = 'Location';
            Detail.transportationDetail = 'Detail';
            Detail.ratingScore = 5;
            Detail.attentivenessRating = true;
            Detail.fastRating = true;
            Detail.punctualityRating = true;
            Detail.expertiseRating = true;
            Detail.ratingScoreOBH = 5;
            Detail.attentivenessRatingOBH = true;
            Detail.fastRatingOBH = true;
            Detail.punctualityRatingOBH = true;
            Detail.expertiseRatingOBH = true;
            Detail.officeTypeOfService = new ESS_Global.EnumValue('OfficeTypeOfService');
            Detail.officeTypeOfService.key = ESS_Enum.OfficeTypeOfService.ElectricalAndLightingSystem.name();
            Detail.officeTypeOfService.value = 'Electrical And Lighting System';
            Detail.officeTypeOfServiceOther = 'Other';
            Detail.officeCost = 10000;
            Detail.officeDetail = 'Detail';
            Detail.officeInternalDetail = 'Detail';
            Detail.housingTypeOfService = new ESS_Global.EnumValue('HousingTypeOfService');
            Detail.housingTypeOfService.key = ESS_Enum.HousingTypeOfService.GasSystem.name();
            Detail.housingTypeOfService.value = 'Gas System';
            Detail.housingTypeOfServiceOther = 'Other';
            Detail.housingCost = 10000;
            Detail.housingDetail = 'Detail';
            Detail.housingInternalDetail = 'Detail';
            Detail.transportationTypeOfService = new ESS_Global.EnumValue('TransportationTypeOfService');
            Detail.transportationTypeOfService.key = ESS_Enum.TransportationTypeOfService.ChangeTire.name();
            Detail.transportationTypeOfService.value = 'Change Tire';
            Detail.transportationTypeOfServiceOther = 'Other';
            Detail.transportationCost = 10000;
            Detail.transportationDetail = 'Detail';
            Detail.transportationInternalDetail = 'Detai';
            Detail.generalTypeOfService = new ESS_Global.EnumValue('GeneralTypeOfService');
            Detail.generalTypeOfService.key = ESS_Enum.GeneralTypeOfService.MovingService.name();
            Detail.generalTypeOfService.value = 'Moving Service';
            Detail.generalTypeOfServiceOther = 'Other';
            Detail.generalCost = 10000;
            Detail.generalDetail = 'Detail';
            Detail.generalInternalDetail = 'Detail';
            Detail.pmsvId = '1234567890';
            Detail.pmsvEmployeeName = 'Test';
            Detail.pmsvEmployeeId = '00000001';
            Detail.pmsvEmail = 'test@softever.co.th';
            Detail.pmsvPosition = 'Position';
            Detail.pmsvFunction = 'Function';
            Detail.pmsvDepartment = 'Department';
            Detail.pmsvSection = 'Section';
            Detail.pmsvUnit = 'Unit';
            Detail.showOfficeInternalDetail = true;
            Detail.showHousingInternalDetail = true;
            Detail.showTransportationInternalDetail = true;
            Detail.showGeneralInternalDetail = true;
            Detail.canDelete = true;
            Detail.canSave = true;
            Detail.canSubmit = true;
            Detail.canEdit = true;
            Detail.canVerify = true;
            Detail.canCancelRequest = true;
            Detail.canAccept = true;
            Detail.canSaveComplete = true;
            Detail.canComplete = true;
            Detail.showCompleteForm = true;
            Detail.canRating = true;
            Detail.showRatingForm = true;
            Detail.showRatingFormOBH = true;
            Detail.isPRTRUser = true;
            Detail.canOnlyOnBehalf = true;
            Detail.completedByEmail = 'email';
            
            ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO FAG = new ESS_FixAndGeneral_DTO.FixAndGeneralCardDTO();
            FAG.documentNo = 'GS-2023-06-0001';
            FAG.isOnBehalf = false;
            FAG.status = new ESS_Global.EnumValue('FixAndGeneralDocumentStatus');
            FAG.status.key = ESS_Enum.FixAndGeneralDocumentStatus.Draft.name();
            FAG.status.value = 'Draft';
            FAG.typeOfService = new ESS_Global.EnumValue('FixTypeOfService');
            FAG.typeOfService.key = ESS_Enum.FixTypeOfService.Housing.name();
            FAG.typeOfService.value = 'Housing';
            FAG.topic = 'Topic';
            FAG.expectedDueDate = date.today();
            FAG.requesterDisplayName = 'Test';
            FAG.createdDate = date.today();
            FAG.completedDate = date.today();
            FAG.rejectedDate = date.today();
            FAG.pmsvEmployeeName = 'PMSV Name';
            FAG.rejectComment = 'Reject Comment';
            FAG.isSelected = false;
            
            ESS_FixAndGeneral_DTO.SearchUserDTO Search = new ESS_FixAndGeneral_DTO.SearchUserDTO();
            Search.userId = runAsUser.Id;
            Search.displayName = 'Test';
            Search.employeeId = '00000001';
            Search.employeeName = 'Test';
            Search.employeeNameTH = 'เทส';
            Search.position = 'Position';
            Search.email = 'test@softever.co.th';
            Search.unit = 'Unit';
            Search.section = 'Section';
            Search.department = 'Department';
            Search.function = 'Function';
            
            ESS_FixAndGeneral_DTO.FixAndGeneralExcelDTO Excel = new ESS_FixAndGeneral_DTO.FixAndGeneralExcelDTO();
            Excel.documentNo = 'HS-2023-06-0001';
            Excel.documentType = 'Type';
            Excel.serviceType = 'Service';
            Excel.topic = 'Topic';
            Excel.detail = 'Detail';
            Excel.repairDate = date.today();
            Excel.expectedDueDate = date.today();
            Excel.repairArea = 'Area';
            Excel.building = 'Building';
            Excel.floor = 'Floor';
            Excel.repairTime = date.today();
            Excel.houseNo = '123';
            Excel.period = 'A';
            Excel.houseType = 'HouseType';
            Excel.telNo = '021231234';
            Excel.mobileNo = '0811231234';
            Excel.typeOfService = 'Service';
            Excel.typeOfServiceOther = 'Other';
            Excel.cost = 1000;
            Excel.moreDetail = 'Detail';
            Excel.internalDetail = 'Internal';
            Excel.requesterName = 'Test';
            Excel.requesterEmployeeId = '00000001';
            Excel.requesterEmail = 'test@softever.co.th';
            Excel.requesterPosition = 'Position';
            Excel.requesterFunction = 'Function';
            Excel.requesterDepartment = 'Department';
            Excel.requesterSection = 'Section';
            Excel.requesterUnit = 'Unit';
            Excel.obhName = 'Test';
            Excel.obhEmployeeId = '00000001';
            Excel.obhEmail = 'test@softever.co.th';
            Excel.obhPosition = 'Position';
            Excel.obhFunction = 'Function';
            Excel.obhDepartment = 'Department';
            Excel.obhSection = 'Section';
            Excel.obhUnit = 'Unit';
            Excel.createdDate = date.today();
            Excel.submittedDate = date.today();
            Excel.verifiedDate = date.today();
            Excel.acceptedDate = date.today();
            Excel.completedDate = date.today();
            Excel.rejectedDate = date.today();
            Excel.cancelledDate = date.today();
            Excel.acceptedBy = 'Admin';
            Excel.completedBy = 'Admin';
            Excel.cancelledBy = 'Admin';
            Excel.rejectComment = 'Reject Comment';
            Excel.cancelComment = 'Cancel Comment';
            Excel.currentStatus = 'Status';
            Excel.requesterRatingCompleted = false;
            Excel.requesterRating = 5;
            Excel.requesterAttentiveness = true;
            Excel.requesterFast = true;
            Excel.requesterPunctuality = true;
            Excel.requesterExpertise = true;
            Excel.obhRatingCompleted = false;
            Excel.obhRating = 5;
            Excel.obhAttentiveness = true;
            Excel.obhFast = true;
            Excel.obhPunctuality = true;
            Excel.obhExpertise = true;
            Excel.verifyStatus = 'Verified';
            Excel.obhComment = 'Comment';
            Excel.verifiedRejectedDate = date.today();
            Excel.location = 'Location';
            Excel.transportationType = 'Type';
            Excel.transportationNo = '123';
            Excel.transportationDetail = 'Detail';
        }
        
		Test.stopTest();
        
    }
    
    
}