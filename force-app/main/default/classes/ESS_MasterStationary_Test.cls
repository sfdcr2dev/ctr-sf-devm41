@isTest
public class ESS_MasterStationary_Test {

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
    
    public static ESS_MasterStationary_DTO.MasterStationaryDetailDTO initialMasterStationaryDetail(User runAsUser) {
        
        ESS_MasterStationary_DTO.MasterStationaryDetailDTO Detail = new ESS_MasterStationary_DTO.MasterStationaryDetailDTO();
        Detail.active = true;
        Detail.dueStock = 0;
        Detail.stationaryId = 'STA-01';
        Detail.minimumStock = 5;
        Detail.otherSupplier = 'Supplier';
        Detail.price = 1000;
        Detail.stationaryName = 'Test';
        Detail.stockOnHand = 10;
        Detail.supplier = new ESS_Global.EnumValue('StationarySupplier');
        Detail.supplier.key = ESS_Enum.StationarySupplier.OfficeMate.name();
        Detail.supplier.value = 'Office Mate';
        Detail.type = new ESS_Global.EnumValue('StationaryType');
        Detail.type.key = ESS_Enum.StationaryType.General.name();
        Detail.type.value = 'General';
        Detail.unit = 'ด้าม';
        Detail.availableStock = 10;
        Detail.serviceFor = new ESS_Global.EnumValue('StationaryWithdrawFrom');
        Detail.serviceFor.key = ESS_Enum.StationaryWithdrawFrom.TSR.name();
        Detail.serviceFor.value = 'TSR';
        Detail.lastUpdatedDate = date.today();
        Detail.lastUpdatedBy = 'Admin';
        Detail.isEditServiceFor = false;
        Detail.attachmentFiles = new List<ESS_DTO.FileDTO>();
        ESS_DTO.FileDTO File = new ESS_DTO.FileDTO();
        File.id = '1234';
        Detail.attachmentFiles.add(File);
        return Detail;
    }
    
    @isTest
    public static void ESSMasterStationarySave() {
        
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
            
            ESS_Master_Stationary__c Model = new ESS_Master_Stationary__c();
            insert(Model);
            
            ESS_MasterStationary_DTO.MasterStationaryDetailDTO detail = initialMasterStationaryDetail(runAsUser);
            detail.recordId = Model.Id;
            ESS_MasterStationary_DTO.MasterStationaryDetailDTO saveDetail = ESS_MasterStationary.SaveMasterStationary(detail);
            
            ESS_MasterStationary.SearchCriteria Filter = new ESS_MasterStationary.SearchCriteria();
            Filter.allActive = true;
            Filter.active = false;
            Filter.showOnlyLowerStock = false;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'stationaryId';
            SortByParam.ascending = true;
            
            ESS_MasterStationary.GetMasterStationaryListCount(Filter);
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'type';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'stationaryName';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'unit';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'minimumStock';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'stockOnHand';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dueStock';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'availableStock';
            SortByParam.ascending = true;
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ESSMasterStationaryFilter() {
        
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
            
            ESS_Master_Stationary__c Model = new ESS_Master_Stationary__c();
            insert(Model);
            
            ESS_MasterStationary_DTO.MasterStationaryDetailDTO detail = initialMasterStationaryDetail(runAsUser);
            detail.recordId = Model.Id;
            ESS_MasterStationary_DTO.MasterStationaryDetailDTO saveDetail = ESS_MasterStationary.SaveMasterStationary(detail);
            
            ESS_MasterStationary.SearchCriteria Filter = new ESS_MasterStationary.SearchCriteria();
            Filter.id = Model.Id;
            Filter.allActive = true;
            Filter.active = false;
            Filter.showOnlyLowerStock = false;
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'stationaryId';
            SortByParam.ascending = true;
            
            ESS_Global.PageParam PageParam = new ESS_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 10;
            
            ESS_MasterStationary.GetMasterStationaryListCount(Filter);
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'price';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'supplier';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'lastUpdatedDate';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'lastUpdatedBy';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'active';
            SortByParam.ascending = true;
            ESS_MasterStationary.GetMasterStationaryList(Filter, SortByParam, PageParam);
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ESSMasterStationaryMethod() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPMSVId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'PA') {
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
            
            ESS_Master_Stationary__c Model = new ESS_Master_Stationary__c();
            Model.Attachment_Files__c = '12345';
            insert(Model);
            
            ESS_MasterStationary_DTO.MasterStationaryDetailDTO detail = initialMasterStationaryDetail(runAsUser);
            detail.recordId = Model.Id;
            ESS_MasterStationary_DTO.MasterStationaryDetailDTO saveDetail = ESS_MasterStationary.SaveMasterStationary(detail);
            
            ESS_MasterStationary_DTO.UploadFileDTO UploadFile = new ESS_MasterStationary_DTO.UploadFileDTO();
            UploadFile.fileName = 'Test';
            UploadFile.fileData = 'Test';
            UploadFile.recordId = Model.Id;            
            ESS_MasterStationary.UploadFile(UploadFile);
            
            ESS_MasterStationary.SearchCriteria Filter = new ESS_MasterStationary.SearchCriteria();
            Filter.id = Model.Id;
            Filter.allActive = true;
            Filter.active = false;
            Filter.showOnlyLowerStock = false;
            
            ESS_MasterStationary.CheckMasterStationaryID('STA-01');
            ESS_MasterStationary.ExportMasterStationaryExcel(Filter);
            ESS_MasterStationary.generateDocumentUrl('12345');
            ESS_MasterStationary.ChangeUploadFileParentId(Model.Id, Model.Id);
            ESS_MasterStationary.GetAvailableServiceFors();
            
            ESS_MasterStationary_DTO.SearchDTO Search = new ESS_MasterStationary_DTO.SearchDTO();
            ESS_MasterStationary.GetMasterStationaryDetail(Search);
            
            Search.recordId = Model.Id;
            ESS_MasterStationary.DeleteMasterStationary(Search);
            
        }
        
        Test.stopTest();
        
    }
    
    
}