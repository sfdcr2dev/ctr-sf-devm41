@isTest
public with sharing class ESS_Manpower_Test {
    
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
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
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
            LocaleSidKey = 'en_US',
            FirstName_EN__c = 'Test',
            LastName_EN__c = 'Test',
            Position__c = 'Test'
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
            Position__c = 'Test'
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
            Position__c = 'Test'
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
        Config.Manpower_Running_No__c = '0';
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
        
        //Create AdminPMSV Group
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
    
    public static ESS_Manpower_DTO.ManpowerDetailDTO initialOnBehalfManpowerDetail(string typeOfService, ESS_LC1_Scope__c MasterJob, User runAsUser, string onBehalfId) {
        
        ESS_Manpower_DTO.ManpowerDetailDTO ManpowerDetail = new ESS_Manpower_DTO.ManpowerDetailDTO();
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
        //ManpowerDetail.On_Behalf_Of_Flow__c = true;
        ManpowerDetail.onBehalfFlow = true;
        ManpowerDetail.onBehalfOfId = OnBehalfId;
        ManpowerDetail.onBehalfOfEmployeeId = '00000001';
        ManpowerDetail.onBehalfOfEmployeeName = 'Test';
        ManpowerDetail.onBehalfOfEmail = 'testUser@thaioilgroup.com';
        ManpowerDetail.onBehalfOfPosition = 'Test';
        ManpowerDetail.onBehalfOfUnit = 'AAAA';
        ManpowerDetail.onBehalfOfSection = 'BBBB';
        ManpowerDetail.onBehalfOfDepartment = 'CCCC';
        ManpowerDetail.onBehalfOfFunction = 'DDDD';
        
        return ManpowerDetail;
    }
     
    public static ESS_Manpower_DTO.ManpowerDetailDTO initialPMManpowerDetail(string typeOfService, ESS_LC1_Scope__c MasterJob, User runAsUser) {
        
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
            ManpowerDetail.projectManagerId = runAsUser.Id;
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
       
    public static ESS_Manpower_DTO.ManpowerDetailDTO initialPMOnBehalfManpowerDetail(string typeOfService, ESS_LC1_Scope__c MasterJob, User runAsUser, string onBehalfId) {
        
        ESS_Manpower_DTO.ManpowerDetailDTO ManpowerDetail = new ESS_Manpower_DTO.ManpowerDetailDTO();
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
            ManpowerDetail.projectManagerId = runAsUser.Id;
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
        //ManpowerDetail.On_Behalf_Of_Flow__c = true;
        ManpowerDetail.onBehalfFlow = true;
        ManpowerDetail.onBehalfOfId = OnBehalfId;
        ManpowerDetail.onBehalfOfEmployeeId = '00000001';
        ManpowerDetail.onBehalfOfEmployeeName = 'Test';
        ManpowerDetail.onBehalfOfEmail = 'testUser@thaioilgroup.com';
        ManpowerDetail.onBehalfOfPosition = 'Test';
        ManpowerDetail.onBehalfOfUnit = 'AAAA';
        ManpowerDetail.onBehalfOfSection = 'BBBB';
        ManpowerDetail.onBehalfOfDepartment = 'CCCC';
        ManpowerDetail.onBehalfOfFunction = 'DDDD';
        
        return ManpowerDetail;
    }
     
    @isTest
    public static void ESSManpowerMethod() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
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
        
        ESS_Manpower__c Manpower = new ESS_Manpower__c();
        
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
            
            Manpower = new ESS_Manpower__c();
            Manpower.On_Behalf_Of_Flow__c = false;
            Manpower.Service_For__c = ESS_Enum.ManpowerServiceFor.TOP.name();
            Manpower.G_L_Account__c = '123';
            Manpower.Cost_Center__c = '123';
            Manpower.Internal_Order_WBS__c = '123';
            Manpower.Type_of_Service__c = ESS_Enum.ManpowerTypeOfService.Permanent.name();
            Manpower.Objective__c = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
            Manpower.No_of_Contractor_required__c = 1;
            Manpower.Job_Id__c = MasterJob.Id;
            Manpower.Date_of_Commencement__c = date.today();
            Manpower.Approval_History_JSON__c = '[{"userId":"0052v00000i3PiuAAE","position":"LIQUIDITY MANAGEMENT TEAM","employeeName":"Areeya Boonma","comment":"","approverRole":{"value":"Employee","key":"Employee","enumName":"ManpowerApproverRole"},"approvalStatus":{"value":"Submitted","key":"Submitted","enumName":"ManpowerApprovalStatus"},"actionDate":"2022-12-22T02:43:44.961Z"}]';
            Manpower.Current_Status_JSON__c = '[{"userId":"0052v00000i3PiuAAE","position":"LIQUIDITY MANAGEMENT TEAM","employeeName":"Areeya Boonma","comment":"","approverRole":{"value":"Employee","key":"Employee","enumName":"ManpowerApproverRole"},"approvalStatus":{"value":"Submitted","key":"Submitted","enumName":"ManpowerApprovalStatus"},"actionDate":"2022-12-22T02:43:44.961Z"}]';
            Manpower.Requester_Id__c = runAsUser.Id;
            Manpower.Requester_Employee_Id__c = '00000001';
            Manpower.Requester_Name__c = 'Test';
            Manpower.Requester_Email__c = 'testUser@thaioilgroup.com';
            Manpower.Requester_Position__c = 'Test';
            Manpower.Requester_Function__c = 'AAAA';
            Manpower.Requester_Department__c = 'BBBB';
            Manpower.Requester_Section__c = 'CCCC';
            Manpower.Requester_Unit__c = 'DDDD';
            insert(Manpower);
            
        }
        
    	ESS_Manpower.GetStatuses();
        ESS_Manpower.GetTypeOfServices();
        ESS_Manpower.GetObjectives();
        ESS_Manpower.GetWorkLocations();
        ESS_Manpower.GetServiceFors();
        ESS_Manpower.ESSGlobal_GetSections(null);
        ESS_Manpower.CanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), ESS_Enum.ManpowerObjective.ReplaceOldPosition.name());
    	ESS_Manpower.SearchJobTitle('Test Job Title', null);
        ESS_Manpower.SearchUsers('00000001');
        ESS_Manpower.SearchProjectName('Test Project');
        
        Manpower.Type_of_Service__c = ESS_Enum.ManpowerTypeOfService.Temporary.name();
        Manpower.Objective__c = ESS_Enum.ManpowerObjective.AddOldPosition.name();
        Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
        Manpower.Work_Location__c = ESS_Enum.ManpowerWorkLocation.Bangkok.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Type_of_Service__c = ESS_Enum.ManpowerTypeOfService.ProjectBase.name();
        Manpower.Objective__c = ESS_Enum.ManpowerObjective.AddNewPosition.name();
        Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
        Manpower.Work_Location__c = ESS_Enum.ManpowerWorkLocation.Sriracha.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Objective__c = ESS_Enum.ManpowerObjective.KHReview.name();
        Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToVP.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Objective__c = ESS_Enum.ManpowerObjective.ExtendFirstContract.name();
        Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToProjectManager.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Status__c = ESS_Enum.ManpowerStatus.Completed.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToAdminEmployeeRevise.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Status__c = ESS_Enum.ManpowerStatus.Cancelled.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Status__c = ESS_Enum.ManpowerStatus.Completed.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        ESS_Manpower.checkCanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), ESS_Enum.ManpowerObjective.AddOldPosition.name());
        ESS_Manpower.checkCanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), ESS_Enum.ManpowerObjective.AddNewPosition.name());
        ESS_Manpower.checkCanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), ESS_Enum.ManpowerObjective.KHReview.name());
        ESS_Manpower.checkCanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), ESS_Enum.ManpowerObjective.AddOldPosition.name());
        ESS_Manpower.checkCanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), ESS_Enum.ManpowerObjective.AddNewPosition.name());
        ESS_Manpower.checkCanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), ESS_Enum.ManpowerObjective.KHReview.name());
        ESS_Manpower.checkCanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), ESS_Enum.ManpowerObjective.ExtendFirstContract.name());
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
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
        
        ESS_Manpower__c Manpower = new ESS_Manpower__c();
        
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
            
            Manpower = new ESS_Manpower__c();
            Manpower.On_Behalf_Of_Flow__c = false;
            Manpower.Service_For__c = ESS_Enum.ManpowerServiceFor.TOP.name();
            Manpower.G_L_Account__c = '123';
            Manpower.Cost_Center__c = '123';
            Manpower.Internal_Order_WBS__c = '123';
            Manpower.Type_of_Service__c = ESS_Enum.ManpowerTypeOfService.Permanent.name();
            Manpower.Objective__c = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
            Manpower.No_of_Contractor_required__c = 1;
            Manpower.Job_Id__c = MasterJob.Id;
            Manpower.Date_of_Commencement__c = date.today();
            Manpower.Approval_History_JSON__c = '[{"userId":"0052v00000i3PiuAAE","position":"LIQUIDITY MANAGEMENT TEAM","employeeName":"Areeya Boonma","comment":"","approverRole":{"value":"Employee","key":"Employee","enumName":"ManpowerApproverRole"},"approvalStatus":{"value":"Submitted","key":"Submitted","enumName":"ManpowerApprovalStatus"},"actionDate":"2022-12-22T02:43:44.961Z"}]';
            Manpower.Current_Status_JSON__c = '[{"userId":"0052v00000i3PiuAAE","position":"LIQUIDITY MANAGEMENT TEAM","employeeName":"Areeya Boonma","comment":"","approverRole":{"value":"Employee","key":"Employee","enumName":"ManpowerApproverRole"},"approvalStatus":{"value":"Submitted","key":"Submitted","enumName":"ManpowerApprovalStatus"},"actionDate":"2022-12-22T02:43:44.961Z"}]';
            Manpower.Requester_Id__c = runAsUser.Id;
            Manpower.Requester_Employee_Id__c = '00000001';
            Manpower.Requester_Name__c = 'Test';
            Manpower.Requester_Email__c = 'testUser@thaioilgroup.com';
            Manpower.Requester_Position__c = 'Test';
            Manpower.Requester_Function__c = 'AAAA';
            Manpower.Requester_Department__c = 'BBBB';
            Manpower.Requester_Section__c = 'CCCC';
            Manpower.Requester_Unit__c = 'DDDD';
            insert(Manpower);
            
        }
        
    	ESS_Manpower.GetStatuses();
        ESS_Manpower.GetTypeOfServices();
        ESS_Manpower.GetObjectives();
        ESS_Manpower.GetWorkLocations();
        ESS_Manpower.GetServiceFors();
        ESS_Manpower.ESSGlobal_GetSections(null);
        ESS_Manpower.CanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), ESS_Enum.ManpowerObjective.ReplaceOldPosition.name());
    	ESS_Manpower.SearchJobTitle('Test Job Title', null);
        ESS_Manpower.SearchUsers('00000001');
        ESS_Manpower.SearchProjectName('Test Project');
        
        Manpower.Type_of_Service__c = ESS_Enum.ManpowerTypeOfService.Temporary.name();
        Manpower.Objective__c = ESS_Enum.ManpowerObjective.AddOldPosition.name();
        Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Manpower.Type_of_Service__c = ESS_Enum.ManpowerTypeOfService.ProjectBase.name();
        Manpower.Objective__c = ESS_Enum.ManpowerObjective.AddNewPosition.name();
        Manpower.Status__c = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
        update(Manpower);
        ESS_Manpower.assignToManpowerTableDTO(Manpower);
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerFitlerSortByMethod() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
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
            
            string manpowerId = manpowerDetail.recordId;
            
            ESS_Manpower.SearchCriteria SearchCriteria = new ESS_Manpower.SearchCriteria();
            SearchCriteria.documentNo = '';
            SearchCriteria.typeOfService = 'All';
            SearchCriteria.objective = 'All';
            SearchCriteria.jobTitle = '';
            SearchCriteria.status = 'All';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.onHandWork = false;
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'typeOfService';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'objective';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'jobTitle';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'requester';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'requester';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerFitlerSortByOBHMethod() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
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
            
            string manpowerId = manpowerDetail.recordId;
            
            ESS_Manpower.SearchCriteria SearchCriteria = new ESS_Manpower.SearchCriteria();
            SearchCriteria.documentNo = '';
            SearchCriteria.typeOfService = 'All';
            SearchCriteria.objective = 'All';
            SearchCriteria.jobTitle = '';
            SearchCriteria.status = 'All';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.onHandWork = false;
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'jobTitle';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'jobTitle';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'requester';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
                        
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerAdminTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username, firstname_en__c, lastname_en__c, position__c from User];
        Id UserId;
        Id AdminPEOCId;
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
            
            string manpowerId = manpowerDetail.recordId;
            
            ESS_Manpower.SearchCriteria SearchCriteria = new ESS_Manpower.SearchCriteria();
            SearchCriteria.documentNo = '';
            SearchCriteria.typeOfService = 'All';
            SearchCriteria.objective = 'All';
            SearchCriteria.jobTitle = '';
            SearchCriteria.status = 'All';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startSubmittedDate = date.today();
            SearchCriteria.endSubmittedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            SearchCriteria.onHandWork = false;
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Manpower.GetManpowerTableCount(SearchCriteria);
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTableCount(SearchCriteria);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            SearchCriteria = new ESS_Manpower.SearchCriteria();
            SearchCriteria.documentNo = '1';
            SearchCriteria.typeOfService = ESS_Enum.ManpowerTypeOfService.Temporary.name();
            SearchCriteria.objective = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
            SearchCriteria.jobTitle = 'Test';
            SearchCriteria.status = ESS_Enum.ManpowerStatus.Draft.name();
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startSubmittedDate = date.today();
            SearchCriteria.endSubmittedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            SearchCriteria.onHandWork = false;
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            
            ESS_Manpower.GetManpowerTableCount(SearchCriteria);
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTableCount(SearchCriteria);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'typeOfService';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'objective';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'jobTitle';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);
            
            ESS_Manpower.GetApprovalHistory(manpowerId);
            ESS_Manpower.GetCurrentStatusHistory(manpowerId);
            
            /* SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'requester';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerTable(SearchCriteria, SortByParam, null);
            ESS_Manpower.GetManpowerApproveTable(SearchCriteria, SortByParam, null);

            ESS_Manpower.GetStatuses();
            ESS_Manpower.GetTypeOfServices();
            ESS_Manpower.GetObjectives();
            ESS_Manpower.GetWorkLocations();
            ESS_Manpower.GetServiceFors();
            ESS_Manpower.ESSGlobal_GetSections(null);
            
            ESS_Manpower.CanEditJobDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), ESS_Enum.ManpowerObjective.ReplaceOldPosition.name());
        	ESS_Manpower.SearchJobTitle('Test Job Title', 'Test');
            ESS_Manpower.SearchUsers('0000');
            ESS_Manpower.SearchProjectName('Test Project');
            ESS_Manpower.ChangeManpowerIsNew(manpowerId); */
            
            ESS_Manpower__c Manpower = ESS_Manpower.queryManpowerById(manpowerId);
            
            Manpower.Is_PRTR__c = true;
            ESS_Manpower.addApprovalCurrentStatusByRoleForUser(Manpower, ESS_Enum.ManpowerApproverRole.AdminPMBP, runAsUser);
            ESS_Manpower.addApprovalCurrentStatusDefaultForUser(Manpower, ESS_Enum.ManpowerApproverRole.AdminPMBP, runAsUser);
            
            ESS_Manpower_DTO.ApprovalHistoryDTO approvalHistory = new ESS_Manpower_DTO.ApprovalHistoryDTO();
            approvalHistory.userId = runAsUser.Id;
            approvalHistory.employeeName = 'Test';
            approvalHistory.position = 'Test';
            approvalHistory.actionDate = date.today();
            approvalHistory.approvalStatus = new ESS_Global.EnumValue('ManpowerApprovalStatus');
        	approvalHistory.approvalStatus.key = ESS_Enum.ManpowerApprovalStatus.Submitted.name();
        	approvalHistory.approvalStatus.value = ESS_Manpower.getManpowerApproverStatusLabel(ESS_Enum.ManpowerApprovalStatus.Submitted);
            approvalHistory.approverRole = new ESS_Global.EnumValue('ManpowerApproverRole');
        	approvalHistory.approverRole.key = ESS_Enum.ManpowerApproverRole.Employee.name();
        	approvalHistory.approverRole.value = ESS_Manpower.getManpowerApproverRoleLabel(ESS_Enum.ManpowerApproverRole.Employee);
            ESS_Manpower.addApprovalCurrentStatusFromHistoryForUser(Manpower, approvalHistory);
            ESS_Manpower.addApprovalHistoryForUser(Manpower, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, runAsUser);
            ESS_Manpower.addApprovalHistoryForUser(Manpower, ESS_Enum.ManpowerApprovalStatus.Submitted, ESS_Enum.ManpowerApproverRole.Employee, runAsUser, 'Test');
            ESS_Manpower.InsertNewJobTitle(Manpower, 'test', 'test');
            ESS_Manpower.checkCanDelete(ESS_Enum.ManpowerApprovalStatus.Submitted.name());
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerSaveTest() {
        
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
            MasterJob.Active__c = true;
            insert(MasterJob);
            
            ESS_LC1_Project__c MasterProject = new ESS_LC1_Project__c();
            MasterProject.Project_Name__c = 'Test Project';
            MasterProject.Project_Manager__c = PISUserId;
            MasterProject.Project_Start_Date__c = date.today();
            MasterProject.Project_End_Date__c = date.today().addDays(7);
            insert(MasterProject);
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name() ,MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            saveManpowerDetail.jobTitleId = MasterJob.Id;
            
            ESS_Manpower.CheckExistJobTitleOnSubmit('Test Job Title', 'BBBB');
            ESS_Manpower.CheckCanSaveSubmitKHReview(saveManpowerDetail);
            ESS_Manpower.InactiveJobTitle(MasterJob.Id);
            
        }
        
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerSubmitTest() {
        
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerApproveTest() {
        
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.ApproveManpower(saveManpowerDetail);
        }
        
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerRejectTest() {
        
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.RejectManpower(saveManpowerDetail, 'Reject');
            
        }
        
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerCancelTest() {
        
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(SaveManpowerDetail);
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancelled');
            
        }
        
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerDeleteTest() {
        
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.DeleteManpower(saveManpowerDetail.recordId);
            
        }
        
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerAcknowledgeTest() {
        
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.AcknowledgeManpower(saveManpowerDetail.recordId, '1', 'Comment');
            
        }
        
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerOnBehalfTest() {
        
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
            
            ESS_Manpower__c Manpower = new ESS_Manpower__c();
            Manpower.Service_For__c = ESS_Enum.ManpowerServiceFor.TOP.name();
            Manpower.G_L_Account__c = '123';
            Manpower.Cost_Center__c = '123';
            Manpower.Internal_Order_WBS__c = '123';
            Manpower.Type_of_Service__c = ESS_Enum.ManpowerTypeOfService.Permanent.name();
            Manpower.Objective__c = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
            Manpower.No_of_Contractor_required__c = 1;
            Manpower.Job_Id__c = MasterJob.Id;
            Manpower.Date_of_Commencement__c = date.today();
            Manpower.Requester_Id__c = runAsUser.Id;
            Manpower.Requester_Employee_Id__c = '00000001';
            Manpower.Requester_Name__c = 'Test';
            Manpower.Requester_Email__c = 'testUser@thaioilgroup.com';
            Manpower.Requester_Position__c = 'Test';
            Manpower.Requester_Function__c = 'AAAA';
            Manpower.Requester_Department__c = 'BBBB';
            Manpower.Requester_Section__c = 'CCCC';
            Manpower.Requester_Unit__c = 'DDDD';
            Manpower.On_Behalf_Of_Flow__c = true;
            Manpower.On_Behalf_Of_Id__c = PISUserId;
            Manpower.On_Behalf_Of_Employee_Id__c = '00000001';
            Manpower.On_Behalf_Of__c = 'Test';
            Manpower.On_Behalf_Of_Email__c = 'testUser@thaioilgroup.com';
            Manpower.On_Behalf_Of_Position__c = 'Test';
            Manpower.On_Behalf_Of_Unit__c = 'AAAA';
            Manpower.On_Behalf_Of_Section__c = 'BBBB';
            Manpower.On_Behalf_Of_Department__c = 'CCCC';
            Manpower.On_Behalf_Of_Function__c = 'DDDD';
            insert(Manpower);
            
            ESS_Manpower.SearchCriteria SearchCriteria = new ESS_Manpower.SearchCriteria();
            SearchCriteria.documentNo = '';
            SearchCriteria.typeOfService = 'All';
            SearchCriteria.objective = 'All';
            SearchCriteria.jobTitle = '';
            SearchCriteria.status = 'All';
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startSubmittedDate = date.today();
            SearchCriteria.endSubmittedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            SearchCriteria.onHandWork = false;
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'requester';
            SortByParam.ascending = true;
            
            ESS_Manpower.GetOnBehalfCount(SearchCriteria);
            ESS_Manpower.GetManpowerOnBehalfApproveTableCount(SearchCriteria);
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'typeOfService';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'typeOfService';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'objective';
            SortByParam.ascending = true;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'objective';
            SortByParam.ascending = false;
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            
            ESS_Manpower_DTO.ManpowerDetailDTO newManpowerDetail = ESS_Manpower.GetManpowerDetail(null);
            newManpowerDetail.onBehalfFlow = true;
            ESS_Manpower.SaveManpower(newManpowerDetail);
            
            SearchCriteria = new ESS_Manpower.SearchCriteria();
            SearchCriteria.documentNo = '1';
            SearchCriteria.typeOfService = ESS_Enum.ManpowerTypeOfService.Temporary.name();
            SearchCriteria.objective = ESS_Enum.ManpowerObjective.ReplaceOldPosition.name();
            SearchCriteria.jobTitle = 'Test';
            SearchCriteria.status = ESS_Enum.ManpowerStatus.Draft.name();
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addDays(7);
            SearchCriteria.startSubmittedDate = date.today();
            SearchCriteria.endSubmittedDate = date.today().addDays(7);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addDays(7);
            SearchCriteria.onHandWork = false;
            
            ESS_Manpower.GetOnBehalfCount(SearchCriteria);
            ESS_Manpower.GetManpowerOnBehalfApproveTableCount(SearchCriteria);
            ESS_Manpower.GetManpowerOnBehalfApproveTable(SearchCriteria, SortByParam, null);
            
            
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerPermanent1Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerPermanent1CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            submitManpowerDetail.status = new ESS_Global.EnumValue('ManpowerStatus');
            submitManpowerDetail.status.key = ESS_Enum.ManpowerStatus.WaitingToSectionHead.name();
            submitManpowerDetail.status.value = 'WaitingToSectionHead';
			ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');            
        }
        
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerPermanent1RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id AdminPEOCId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');          
        }
        
        
		Test.stopTest();
        
    }
    
    /* @isTest
    public static void ESSManpowerPermanent2Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'RAT') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
            
            manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.requesterId = RequesterId;
            saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
		Test.stopTest();
        
    } */
    
    @isTest
    public static void ESSManpowerPermanent2CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'RAT') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerPermanent2RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'RAT') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');     
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerPermanent3Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerPermanent3CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerPermanent3RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');     
        }
        
		Test.stopTest();
        
    }

    /* @isTest
    public static void ESSManpowerPermanent4Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
            
            manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.requesterId = RequesterId;
            saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
		Test.stopTest();
        
    } */
    
    @isTest
    public static void ESSManpowerPermanent4CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerPermanent4ApproveTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerPermanent4RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Permanent.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');     
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary1Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(submitManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToVP.name());
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary1CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToVP.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary1RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');      
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary2Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, onBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
            
            /* manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.requesterId = RequesterId;
            saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail); */
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary2CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, onBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToVP.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');   
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary2ApproveTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, onBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary2RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, onBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');     
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary3Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary3CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToVP.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary3RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');     
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary4Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, onBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
            
            manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.requesterId = RequesterId;
            saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary4CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, onBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToVP.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary4ApproveTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, onBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary4RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, onBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');     
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary5Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'NA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary5CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'NA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary5RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'NA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');     
        }
        
		Test.stopTest();
        
    }
    
    /* @isTest
    public static void ESSManpowerTemporary6Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'NA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
            
            manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.requesterId = RequesterId;
            saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
		Test.stopTest();
        
    } */
    
    @isTest
    public static void ESSManpowerTemporary6ApproveTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'NA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary6CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'NA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerTemporary6RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'NA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.Temporary.name(), MasterJob, runAsUser, OnBehalfId);
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');     
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase1Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase1CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase1RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');     
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase2Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
            
            manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            manpowerDetail.requesterId = RequesterId;
            saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase2ApproveTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase2CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');   
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase2RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject'); 
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase3Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase3CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToEmployeeRevise.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase3RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToProjectManager.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase4Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
            
            manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            manpowerDetail.requesterId = RequesterId;
            saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase4ApproveTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase4CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase4RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = PMId;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToEmployeeApproved.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');
        }
        
		Test.stopTest();
        
    }
    
    /* @isTest
    public static void ESSManpowerProjectBase5Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string PMNotSectionHeadId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'RA') {
                PMNotSectionHeadId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = runAsUser.Id;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
            
            manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = PMNotSectionHeadId;
			saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
		Test.stopTest();
        
    } */
    
    @isTest
    public static void ESSManpowerProjectBase5ApproveTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string PMNotSectionHeadId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'RA') {
                PMNotSectionHeadId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = runAsUser.Id;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            ESS_Manpower.ApproveManpower(submitManpowerDetail);  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase5CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string PMNotSectionHeadId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'RA') {
                PMNotSectionHeadId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = runAsUser.Id;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase5RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string PMNotSectionHeadId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'RA') {
                PMNotSectionHeadId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser);
            manpowerDetail.projectManagerId = runAsUser.Id;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');
        }
        
		Test.stopTest();
        
    }
    
    /* @isTest
    public static void ESSManpowerProjectBase6Test() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = runAsUser.Id;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
            
            manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = runAsUser.Id;
            manpowerDetail.requesterId = RequesterId;
            saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower.SubmitManpower(saveManpowerDetail);
        }
        
		Test.stopTest();
        
    } */
    
    @isTest
    public static void ESSManpowerProjectBase6ApproveTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = runAsUser.Id;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            ESS_Manpower.ApproveManpower(submitManpowerDetail);
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase6CancelTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = runAsUser.Id;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToSectionHead.name());
            ESS_Manpower.CancelRequestManpower(submitManpowerDetail, 'Cancel');  
        }
        
		Test.stopTest();
        
    }
    
    @isTest
    public static void ESSManpowerProjectBase6RejectTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id UserId;
        Id OnBehalfId;
        string Username;
        string EmployeeId;
        string PMId;
        string RequesterId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RAT') {
                UserId = U.Id;
                Username = U.Username;
                runAsUser = U;
                OnBehalfId = U.Id;
            }
            else if(U.alias == 'NA') {
                PMId = U.Id;
            }
            else if(U.alias == 'SU') {
                RequesterId = U.Id;
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
            
            ESS_Manpower_DTO.ManpowerDetailDTO manpowerDetail = initialOnBehalfManpowerDetail(ESS_Enum.ManpowerTypeOfService.ProjectBase.name(), MasterJob, runAsUser, OnBehalfId);
            manpowerDetail.projectManagerId = runAsUser.Id;
            ESS_Manpower_DTO.ManpowerDetailDTO saveManpowerDetail = ESS_Manpower.SaveManpower(manpowerDetail);
            ESS_Manpower_DTO.ManpowerDetailDTO submitManpowerDetail = ESS_Manpower.SubmitManpower(saveManpowerDetail);
            UpdateManpowerStatus(saveManpowerDetail.recordId, ESS_Enum.ManpowerStatus.WaitingToAcknowledge.name());
            ESS_Manpower.RejectManpower(submitManpowerDetail, 'Reject');
        }
        
		Test.stopTest();
        
    }

    public static void UpdateManpowerStatus(string recordId, string status) {
        
        ESS_Manpower__c Manpower = [select id, status__c from ESS_Manpower__c where Id =: recordId];
        Manpower.Status__c = status;
        update(Manpower);
    }
    
}