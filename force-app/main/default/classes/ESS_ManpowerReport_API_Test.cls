@isTest
public class ESS_ManpowerReport_API_Test {

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
        Config.Manpower_Running_No__c = '0';
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
    
    public static ESS_Manpower_DTO.ManpowerDetailDTO initialManpowerDetail(string typeOfService, ESS_LC1_Scope__c MasterJob, User runAsUser) {
        
        ESS_Manpower_DTO.ManpowerDetailDTO ManpowerDetail = new ESS_Manpower_DTO.ManpowerDetailDTO();
        ManpowerDetail.onBehalfFlow = false;
        ManpowerDetail.serviceFor = 'TOP';
        ManpowerDetail.glAccount = '123';
        ManpowerDetail.costCenter = '123';
        ManpowerDetail.internalOrderWBS = '123';
        
        ManpowerDetail.typeOfService = new ESS_Global.EnumValue('ManpowerTypeOfService');
        if(typeOfService == ESS_Enum.ManpowerTypeOfService.Permanent.name()) {
            ManpowerDetail.typeOfService.key = ESS_Enum.ManpowerTypeOfService.Permanent.name();
        	ManpowerDetail.typeOfService.value = 'Permanent';
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.Temporary.name()) {
            ManpowerDetail.typeOfService.key = ESS_Enum.ManpowerTypeOfService.Temporary.name();
        	ManpowerDetail.typeOfService.value = 'Temporary';
        }
        else if(typeOfService == ESS_Enum.ManpowerTypeOfService.ProjectBase.name()) {
            ManpowerDetail.typeOfService.key = ESS_Enum.ManpowerTypeOfService.ProjectBase.name();
        	ManpowerDetail.typeOfService.value = 'Project Base';
        }
        
        ManpowerDetail.objective = new ESS_Global.EnumValue('ManpowerObjective');
        ManpowerDetail.objective.key = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
        ManpowerDetail.objective.value = 'ทดแทนตำแหน่งงานเดิม';
        ManpowerDetail.noOfContractorRequired = 1;
        ManpowerDetail.jobTitleId = MasterJob.Id;
        ManpowerDetail.jobTitleName = MasterJob.Job_Title__c;
        ManpowerDetail.commencementDate = date.today();
        ManpowerDetail.requesterId = runAsUser.Id;
        ManpowerDetail.requesterEmployeeId = '00000001';
        ManpowerDetail.requesterEmployeeName = 'Test';
        ManpowerDetail.requesterEmail = 'testUser@thaioilgroup.com';
        ManpowerDetail.requesterPosition = 'Test';
        ManpowerDetail.requesterFunction = 'AAAA';
        ManpowerDetail.requesterDepartment = 'BBBB';
        ManpowerDetail.requesterSection = 'CCCC';
        ManpowerDetail.requesterUnit = 'DDDD';
        
        return ManpowerDetail;
    }
    
    @isTest
    public static void ManpowerReportAPITest() {
        
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
                runAsUser = U;
            }
            else if(U.alias == 'KI') {
                AdminPEOCId = U.Id;
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
            
            ESS_LC1_Scope__c MasterJob = new ESS_LC1_Scope__c();
            MasterJob.Job_Title__c = 'Test Job Title';
            MasterJob.Unit__c = 'AAAA';
            MasterJob.Section__c = 'BBBB';
            MasterJob.Department__c = 'CCCC';
            MasterJob.Function__c = 'DDDD';
            MasterJob.Work_Location__c = ESS_Enum.ManpowerWorkLocation.Bangkok.name();
            MasterJob.Active__c = true;
            MasterJob.Output_Required__c = 'Test';
            MasterJob.Job_Detail__c = 'Test';
            MasterJob.Qualification__c = 'Test';
            MasterJob.Physical_Requirement__c = 'Test';
            MasterJob.JE_Score__c = 'Test';
            MasterJob.Comment__c = 'Test';
            insert(MasterJob);
            
            ESS_LC1_Project__c MasterProject = new ESS_LC1_Project__c();
            MasterProject.Project_Name__c = 'Test Project';
            MasterProject.Project_Manager__c = PISUserId;
            MasterProject.Project_Start_Date__c = date.today();
            MasterProject.Project_End_Date__c = date.today().addDays(7);
            insert(MasterProject);
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name() ,MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);

            ESS_ManpowerReport.SearchCriteria SearchCriteria = new ESS_ManpowerReport.SearchCriteria();
            SearchCriteria.typeOfServiceAll = true;
            SearchCriteria.typeOfServicePermanent = true;
            SearchCriteria.typeOfServiceTemporary = true;
            SearchCriteria.typeOfServiceProjectBase = true;
            SearchCriteria.currentStatusAll = true;
            SearchCriteria.currentStatusDraft = true;
            SearchCriteria.currentStatusInProgress = true;
            SearchCriteria.currentStatusCompleted = true;
            SearchCriteria.currentStatusCancelled = true;
            SearchCriteria.serviceForAll = true;
            SearchCriteria.serviceForTOP = true;
            SearchCriteria.serviceForTES = true;
            SearchCriteria.serviceForTLB = true;
            SearchCriteria.serviceForTPX = true;
            SearchCriteria.serviceForLABIX = true;
            SearchCriteria.serviceForTET = true;
            SearchCriteria.serviceForTOPSPP = true;
            SearchCriteria.serviceForTOPNEXT = true;
            SearchCriteria.serviceForTTC = true;
            SearchCriteria.documentNo = '';
            SearchCriteria.employeeName = '';
            SearchCriteria.objective = 'All';
            SearchCriteria.projectName = 'All';
            SearchCriteria.scopeOfServiceId = '';
            SearchCriteria.function = 'All';
            SearchCriteria.department = 'All';
            SearchCriteria.section = 'All';
            SearchCriteria.unit = 'All';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startSubmittedDate = date.today();
            SearchCriteria.endSubmittedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startCancelledDate = date.today();
            SearchCriteria.endCancelledDate = date.today().addDays(7);
            
            string filter = JSON.serialize(SearchCriteria);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            string sortByParamFilter = JSON.serialize(SortByParam);
            
            ESS_ManpowerReport_API.GetManpowerReportTableCount(filter);
            ESS_ManpowerReport_API.GetManpowerReportTable(filter, sortByParamFilter, null);
            ESS_ManpowerReport_API.ExportManpowerReportExcel(filter);
            ESS_ManpowerReport_API.GetMSPReportGraph(filter, 'Function');
            ESS_ManpowerReport_API.GetMSPReportByYearGraph(filter);
            ESS_ManpowerReport_API.GetMSPReportByTypeOfServiceGraph(filter);
            ESS_ManpowerReport_API.GetMSPReportByStatusGraph(filter);
            ESS_ManpowerReport_API.GetProjectNames();
            ESS_ManpowerReport_API.ESSGlobal_GetFunctions();
            ESS_ManpowerReport_API.ESSGlobal_GetDepartments(null);
            ESS_ManpowerReport_API.ESSGlobal_GetSections(null);
            ESS_ManpowerReport_API.ESSGlobal_GetUnits(null);
            
        }
        
        Test.stopTest();
        
         
    }
    
}