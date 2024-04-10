/* Author Softever */
@isTest
public class ESS_RecommendationLetter_Test {

    @testSetup
    public static void setup() {
        
        //Create user here
        User AdminPersonalUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'RATRI',
            Email = 'testratri@thaioilgroup.com',
            Username = 'testratri@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'RA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(AdminPersonalUser);
        
        //Employee
        User EmployeeUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'SANEA',
            Email = 'testsanea@thaioilgroup.com',
            Username = 'testsanea@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'SA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(EmployeeUser);
        
        //SectionHead
        User SectionHeadUser = new User(
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
        insert(SectionHeadUser);
        
        //DepartmentHead
		User DepartmentHeadUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'NUTTAPON',
            Email = 'testnuttapon@thaioilgroup.com',
            Username = 'testnuttapon@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'NU',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(DepartmentHeadUser);
        
        //Admin
		User LetterAdmin = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'RATRI',
            Email = 'testratri@thaioilgroup.com',
            Username = 'testratri@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'RA',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Employee_Id__c = '999999'
            );
        insert(LetterAdmin);
        
        //Insert PISUser
        insertPISUsers();
        
        //Insert Public Group
        insertPublicGroup();
        
        //Insert ESS_Config
        ESS_Config__c Config = new ESS_Config__c();
        Config.Application_Running_No__c = '0';
        Config.Environment__c = 'PROD';
        insert(Config);
        
        //Insert Master Employee
        ESS_Master_Employee__c Master = new ESS_Master_Employee__c();
        Master.Data__c = 'IN';
        Master.ExternalId__c = '00000001';
        Master.Employee_ID__c = '00000001';
        Master.Employee_DOB__c = date.today();
        Master.Employee_Retirement_Date__c = date.today();
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
        
        Master = new ESS_Master_Employee__c();
        Master.Data__c = 'IN';
        Master.ExternalId__c = '99999999';
        Master.Employee_ID__c = '99999999';
        Master.Employee_DOB__c = date.today();
        Master.Employee_Retirement_Date__c = date.today();
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
    }
    
    @future
    public static void insertPISUsers() {
        
        List<User> Users = [select id, alias from User];
        
        Id PersonalAdminId; //Personal Admin
        Id EmployeeId; //Employee
        Id SectionHeadId; //Section Head
        Id DepartmentHeadId; //Department Head
        
        for(User U : Users) {
            if(U.alias == 'SA') {
                EmployeeId = U.Id;
            }
            else if(U.alias == 'SU') {
                SectionHeadId = U.Id;
            }
            else if(U.alias == 'NU') {
                DepartmentHeadId = U.Id;
            }
            else if(U.alias == 'RA') {
                PersonalAdminId = U.Id;
            }
        }
        
        PISUsers__c sanea = new PISUsers__c();
        sanea.Active__c = true;
        sanea.MAINPOSITION__c = true;
        sanea.EMPLOYEEID__c = '00000001';
        sanea.HOME_COMP__c = '1100';
        sanea.COMPANYNAME__c = 'TOP';
        sanea.Name = 'Test Sanea';
        sanea.LEVEL__c = 'Junior';
        sanea.ORGID__c = '00000001';
        sanea.POSID__c = '00000001';
        sanea.ENFIRSTNAME__c = 'Test';
        sanea.ENLASTNAME__c = 'Test Sanea';
        sanea.HOLDERPOSITION__c = '00000001';
        sanea.EMAIL__c = 'testsanea@thaioilgroup.com';
        sanea.User__c = EmployeeId;
        sanea.FUNCTION__c = 'AAAA';
        sanea.DEPARTMENT__c = 'BBBB';
        sanea.SECTIONS__c = 'CCCC';
        sanea.UNITS__c = 'DDDD';
        sanea.ReportToPOS__c = '00000002';
        sanea.ReportToID__c = '00000002';
        sanea.ReportToEmail__c = 'testsuraphan@thaioilgroup.com';
        sanea.ReportToUser__c = SectionHeadId;
        sanea.SectHeadUpUser__c = SectionHeadId;
        sanea.SectHeadUpPosID__c = '00000002';
        sanea.Subcordinate__c = '[""]';
        insert(sanea);
        
        PISUsers__c suraphan = new PISUsers__c();
        suraphan.Active__c = true;
        suraphan.MAINPOSITION__c = true;
        suraphan.EMPLOYEEID__c = '00000002';
        suraphan.HOME_COMP__c = '1600';
        suraphan.COMPANYNAME__c = 'TES';
        suraphan.Name = 'Test Suraphan';
        suraphan.LEVEL__c = 'Section Head';
        suraphan.ORGID__c = '00000002';
        suraphan.POSID__c = '00000002';
        suraphan.ENFIRSTNAME__c = 'Test';
        suraphan.ENLASTNAME__c = 'Test Suraphan';
        suraphan.HOLDERPOSITION__c = '00000002';
        suraphan.EMAIL__c = 'testsuraphan@thaioilgroup.com';
        suraphan.User__c = SectionHeadId;
        suraphan.ReportToPOS__c = '00000003';
        suraphan.ReportToID__c = '00000003';
        suraphan.ReportToEmail__c = 'testdamrong@thaioilgroup.com';
        suraphan.ReportToUser__c = DepartmentHeadId;
        suraphan.SectHeadUpUser__c = DepartmentHeadId;
        suraphan.SectHeadUpPosID__c = '00000003';
        suraphan.Subcordinate__c = '[""]';
        insert(suraphan);
        
        PISUsers__c nuttapon = new PISUsers__c();
        nuttapon.Active__c = true;
        nuttapon.MAINPOSITION__c = true;
        nuttapon.EMPLOYEEID__c = '00000003';
        nuttapon.HOME_COMP__c = '1100';
        nuttapon.Name = 'Test Nuttapon';
        nuttapon.LEVEL__c = 'Department Head';
        nuttapon.ORGID__c = '00000003';
        nuttapon.POSID__c = '00000003';
        nuttapon.ENFIRSTNAME__c = 'Test';
        nuttapon.ENLASTNAME__c = 'Test Nuttapon';
        nuttapon.HOLDERPOSITION__c = '00000003';
        nuttapon.EMAIL__c = 'testnuttapon@thaioilgroup.com';
        nuttapon.User__c = DepartmentHeadId;
        nuttapon.ReportToPOS__c = '00000003';
        nuttapon.ReportToID__c = '00000003';
        nuttapon.ReportToEmail__c = 'testnuttapon@thaioilgroup.com';
        nuttapon.ReportToUser__c = DepartmentHeadId;
        nuttapon.SectHeadUpUser__c = DepartmentHeadId;
        nuttapon.SectHeadUpPosID__c = '00000003';
        nuttapon.Subcordinate__c = '[""]';
        insert(nuttapon);
        
        PISUsers__c adminPersonal = new PISUsers__c();
        adminPersonal.Active__c = true;
        adminPersonal.MAINPOSITION__c = true;
        adminPersonal.EMPLOYEEID__c = '99999999';
        adminPersonal.HOME_COMP__c = '1100';
        adminPersonal.Name = 'Test AdminPersonal';
        adminPersonal.LEVEL__c = 'VP';
        adminPersonal.ORGID__c = '00000000';
        adminPersonal.POSID__c = '00000000';
        adminPersonal.ENFIRSTNAME__c = 'Test';
        adminPersonal.ENLASTNAME__c = 'Test AdminPersonal';
        adminPersonal.HOLDERPOSITION__c = '00000000';
        adminPersonal.EMAIL__c = 'adminPersonal@thaioilgroup.com';
        adminPersonal.User__c = PersonalAdminId;
        insert(adminPersonal);
    }
    
    @future
    public static void insertPublicGroup() {
        
        List<User> Users = [select id, alias from User];
        
        Id AdminPersonelId;
        
        for(User U : Users) {
            if(U.alias == 'RA') {
                AdminPersonelId = U.Id;
            }
        }
        
        //Create PersonelAdmin Group
        Group adminPersonelGroup = [select id from Group where developername = 'ESS_Recommendation_Letter_Admin'];
        GroupMember personelAdmin = new GroupMember();
        personelAdmin.UserOrGroupId = AdminPersonelId;
        personelAdmin.GroupId = adminPersonelGroup.Id;
        insert(personelAdmin);
        
    }
    
    @isTest
    public static void RecommendationLetterTOPTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'SA') {
                EmployeeId = U.Id;
                runAsUser = U;
            }
        }
        
        PISUsers__c Sanea = [select id, user__c from PISUsers__c where user__c =: runAsUser.Id];
        
        System.runAs(runAsUser) {
            ESS_Setting__c Setting = new ESS_Setting__c();
            Setting.Letter_TOP_HR_Name__c = Sanea.Id;
            Setting.Letter_TES_HR_Name__c = Sanea.Id;
            Setting.Letter_TOP_Request__c = 10;
            Setting.Letter_TES_Request__c = 10;
            Setting.Letter_TOP_HR_Name_TH__c = 'TOP HR';
            Setting.Letter_TES_HR_Name_TH__c = 'TES HR';
            Setting.Letter_TOP_HR_Name_EN__c = 'TOP HR';
            Setting.Letter_TES_HR_Name_EN__c = 'TES HR';
            Setting.Letter_TOP_HR_Position_TH__c = 'Test';
            Setting.Letter_TOP_HR_Position__c = 'Test';
            Setting.Letter_TES_HR_Position_TH__c = 'Test';
            Setting.Letter_TES_HR_Position__c = 'Test';
            insert(Setting);
            
            ESS_Letter_of_Recommendation__c Letter = new ESS_Letter_of_Recommendation__c();
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name();
            Letter.OwnerId = runAsUser.Id;
            Letter.Language__c = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            Letter.letter_purpose__c = 'Test';
            Letter.To_Organization__c = 'Kasikornbank';
            Letter.Leave_Start__c = date.today();
            Letter.Leave_End__c = date.today();
            Letter.Company_Name__c = 'TOP';
            insert(Letter);
            
            ESS_RecommendationLetter.RecommendationLetterSearchCriteria Filter = new ESS_RecommendationLetter.RecommendationLetterSearchCriteria();
            Filter.letterType = 'All';
            Filter.letterStatus = 'All';
            Filter.startCreatedDate = date.today();
            Filter.endCreatedDate = date.today().addMonths(1);
            Filter.startGeneratedToPDF = date.today();
            Filter.endGeneratedToPDF = date.today().addMonths(1);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_RecommendationLetter.GetRecommendationLetterListsCount(Filter);
            ESS_RecommendationLetter.GetRecommendationLetterCount(Filter);
            ESS_RecommendationLetter.GetRecommendationLetterLists(Filter, SortByParam, null);
            ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            LetterDetail.language = new ESS_Global.EnumValue('RecommendationLetterLanguage');
            LetterDetail.language.key = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            LetterDetail.language.value = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            LetterDetail.companyName = 'TOP';
            ESS_RecommendationLetter.SaveRecommendationLetter(LetterDetail);
            
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name());
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name();
            Letter.Language__c = ESS_Enum.RecommendationLetterLanguage.English.name();
            Letter.Current_Status__c = ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name());
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name());
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(Letter.Id, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.SaveRecommendationLetter(LetterDetail);
            ESS_RecommendationLetter.GenerateRecommendationLetter(Letter.Id, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.DeleteRecommendationLetter(Letter.Id);
            
            ESS_RecommendationLetter.GetLetterTypes();
            ESS_RecommendationLetter.GetOrganizations(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.GetENOrganizations(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
        	ESS_RecommendationLetter.getDependentPicklistValues();
            ESS_RecommendationLetter.getDependentPicklistENValues();
            
            Letter.Letter_Type__c = String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa);
            ESS_RecommendationLetter.assignToRecommendationLetterListDTO(Letter);
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void RecommendationLetterTESTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'SU') {
                EmployeeId = U.Id;
                runAsUser = U;
            }
        }
        
        PISUsers__c Sanea = [select id, user__c from PISUsers__c where user__c =: runAsUser.Id];
        
        System.runAs(runAsUser) {
            ESS_Setting__c Setting = new ESS_Setting__c();
            Setting.Letter_TOP_HR_Name__c = Sanea.Id;
            Setting.Letter_TES_HR_Name__c = Sanea.Id;
            Setting.Letter_TOP_Request__c = 10;
            Setting.Letter_TES_Request__c = 10;
            Setting.Letter_TOP_HR_Name_TH__c = 'TOP HR';
            Setting.Letter_TES_HR_Name_TH__c = 'TES HR';
            Setting.Letter_TOP_HR_Name_EN__c = 'TOP HR';
            Setting.Letter_TES_HR_Name_EN__c = 'TES HR';
            Setting.Letter_TOP_HR_Position_TH__c = 'Test';
            Setting.Letter_TOP_HR_Position__c = 'Test';
            Setting.Letter_TES_HR_Position_TH__c = 'Test';
            Setting.Letter_TES_HR_Position__c = 'Test';
            insert(Setting);
            
            ESS_Master_Employee__c Master = new ESS_Master_Employee__c();
            Master.Employee_ID__c = '00000002';
            Master.Name_Emp_TH_Title_FN_LN__c = 'Test';
            Master.Name_Emp_EN_Title__c = 'Test';
            Master.Name_Emp_EN_FN__c = 'Test';
            Master.Name_Emp_EN_LN__c = 'Test';
            Master.Position__c = 'Test';
            Master.Unit__c = 'Test';
            Master.employee_date_joined__c = date.today();
            Master.Data__c = 'IN';
            insert(Master);
            
            ESS_Letter_of_Recommendation__c Letter = new ESS_Letter_of_Recommendation__c();
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name();
            Letter.OwnerId = runAsUser.Id;
            Letter.Language__c = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            Letter.letter_purpose__c = 'Test';
            Letter.To_Organization__c = 'Kasikornbank';
            Letter.Company_Name__c = 'TES';
            insert(Letter);
            
            ESS_RecommendationLetter.RecommendationLetterSearchCriteria Filter = new ESS_RecommendationLetter.RecommendationLetterSearchCriteria();
            Filter.letterType = 'All';
            Filter.letterStatus = 'All';
            Filter.startCreatedDate = date.today();
            Filter.endCreatedDate = date.today().addMonths(1);
            Filter.startGeneratedToPDF = date.today();
            Filter.endGeneratedToPDF = date.today().addMonths(1);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_RecommendationLetter.GetRecommendationLetterListsCount(Filter);
            ESS_RecommendationLetter.GetRecommendationLetterCount(Filter);
            ESS_RecommendationLetter.GetRecommendationLetterLists(Filter, SortByParam, null);
            ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            LetterDetail.language = new ESS_Global.EnumValue('RecommendationLetterLanguage');
            LetterDetail.language.key = ESS_Enum.RecommendationLetterLanguage.English.name();
            LetterDetail.language.value = ESS_Enum.RecommendationLetterLanguage.English.name();
            LetterDetail.companyName = 'TES';
            ESS_RecommendationLetter.SaveRecommendationLetter(LetterDetail);
            
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.GrantedLetter.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(Letter.Id, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.SaveRecommendationLetter(LetterDetail);
            ESS_RecommendationLetter.GenerateRecommendationLetter(Letter.Id, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.DeleteRecommendationLetter(Letter.Id);
            
            ESS_RecommendationLetter.GetLetterTypes();
            ESS_RecommendationLetter.GetOrganizations(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.GetENOrganizations(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
        	ESS_RecommendationLetter.getDependentPicklistValues();
            ESS_RecommendationLetter.getDependentPicklistENValues();
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void RecommendationLetterAdminTOPTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                EmployeeId = U.Id;
                runAsUser = U;
            }
        }
        
        PISUsers__c Sanea = [select id, user__c from PISUsers__c where user__c =: runAsUser.Id];
        
        System.runAs(runAsUser) {
            ESS_Setting__c Setting = new ESS_Setting__c();
            Setting.Letter_TOP_HR_Name__c = Sanea.Id;
            Setting.Letter_TES_HR_Name__c = Sanea.Id;
            Setting.Letter_TOP_Request__c = 10;
            Setting.Letter_TES_Request__c = 10;
            Setting.Letter_TOP_HR_Name_TH__c = 'TOP HR';
            Setting.Letter_TES_HR_Name_TH__c = 'TES HR';
            Setting.Letter_TOP_HR_Name_EN__c = 'TOP HR';
            Setting.Letter_TES_HR_Name_EN__c = 'TES HR';
            Setting.Letter_TOP_HR_Position_TH__c = 'Test';
            Setting.Letter_TOP_HR_Position__c = 'Test';
            Setting.Letter_TES_HR_Position_TH__c = 'Test';
            Setting.Letter_TES_HR_Position__c = 'Test';
            insert(Setting);
            
            ESS_Letter_of_Recommendation__c Letter = new ESS_Letter_of_Recommendation__c();
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name();
            Letter.OwnerId = runAsUser.Id;
            Letter.Language__c = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            Letter.letter_purpose__c = 'Test';
            Letter.To_Organization__c = 'Kasikornbank';
            Letter.Leave_Start__c = date.today();
            Letter.Leave_End__c = date.today();
            Letter.Company_Name__c = 'TOP';
            insert(Letter);
            
            ESS_RecommendationLetter.RecommendationLetterSearchCriteria Filter = new ESS_RecommendationLetter.RecommendationLetterSearchCriteria();
            Filter.letterType = 'All';
            Filter.letterStatus = 'All';
            Filter.startCreatedDate = date.today();
            Filter.endCreatedDate = date.today().addMonths(1);
            Filter.startGeneratedToPDF = date.today();
            Filter.endGeneratedToPDF = date.today().addMonths(1);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_RecommendationLetter.GetRecommendationLetterListsCount(Filter);
            ESS_RecommendationLetter.GetRecommendationLetterCount(Filter);
            ESS_RecommendationLetter.GetRecommendationLetterLists(Filter, SortByParam, null);
            ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            LetterDetail.language = new ESS_Global.EnumValue('RecommendationLetterLanguage');
            LetterDetail.language.key = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            LetterDetail.language.value = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            LetterDetail.companyName = 'TOP';
            ESS_RecommendationLetter.SaveRecommendationLetter(LetterDetail);
            
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name());
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name();
            Letter.Language__c = ESS_Enum.RecommendationLetterLanguage.English.name();
            Letter.Current_Status__c = ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name());
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name());
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(Letter.Id, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.SaveRecommendationLetter(LetterDetail);
            ESS_RecommendationLetter.GenerateRecommendationLetter(Letter.Id, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.DeleteRecommendationLetter(Letter.Id);
            
            ESS_RecommendationLetter.GetLetterTypes();
            ESS_RecommendationLetter.GetOrganizations(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.GetENOrganizations(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
        	ESS_RecommendationLetter.getDependentPicklistValues();
            ESS_RecommendationLetter.getDependentPicklistENValues();
            
            Letter.Letter_Type__c = String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa);
            ESS_RecommendationLetter.assignToRecommendationLetterListDTO(Letter);
        }
        
        Test.stopTest();
    }
    @isTest
    public static void RecommendationLetterAdminTESTest() {
        
        Test.startTest();
        
        List<User> Users = [select id, alias, username from User];
        Id EmployeeId;
        User runAsUser;
        for(User U : Users) {
            if(U.alias == 'RA') {
                EmployeeId = U.Id;
                runAsUser = U;
            }
        }
        
        PISUsers__c Sanea = [select id, user__c from PISUsers__c where user__c =: runAsUser.Id];
        
        System.runAs(runAsUser) {
            ESS_Setting__c Setting = new ESS_Setting__c();
            Setting.Letter_TOP_HR_Name__c = Sanea.Id;
            Setting.Letter_TES_HR_Name__c = Sanea.Id;
            Setting.Letter_TOP_Request__c = 10;
            Setting.Letter_TES_Request__c = 10;
            Setting.Letter_TOP_HR_Name_TH__c = 'TOP HR';
            Setting.Letter_TES_HR_Name_TH__c = 'TES HR';
            Setting.Letter_TOP_HR_Name_EN__c = 'TOP HR';
            Setting.Letter_TES_HR_Name_EN__c = 'TES HR';
            Setting.Letter_TOP_HR_Position_TH__c = 'Test';
            Setting.Letter_TOP_HR_Position__c = 'Test';
            Setting.Letter_TES_HR_Position_TH__c = 'Test';
            Setting.Letter_TES_HR_Position__c = 'Test';
            insert(Setting);
            
            ESS_Letter_of_Recommendation__c Letter = new ESS_Letter_of_Recommendation__c();
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name();
            Letter.OwnerId = runAsUser.Id;
            Letter.Language__c = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            Letter.letter_purpose__c = 'Test';
            Letter.To_Organization__c = 'Kasikornbank';
            Letter.Leave_Start__c = date.today();
            Letter.Leave_End__c = date.today();
            Letter.Company_Name__c = 'TOP';
            insert(Letter);
            
            ESS_RecommendationLetter.RecommendationLetterSearchCriteria Filter = new ESS_RecommendationLetter.RecommendationLetterSearchCriteria();
            Filter.letterType = 'All';
            Filter.letterStatus = 'All';
            Filter.startCreatedDate = date.today();
            Filter.endCreatedDate = date.today().addMonths(1);
            Filter.startGeneratedToPDF = date.today();
            Filter.endGeneratedToPDF = date.today().addMonths(1);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_RecommendationLetter.GetRecommendationLetterListsCount(Filter);
            ESS_RecommendationLetter.GetRecommendationLetterCount(Filter);
            ESS_RecommendationLetter.GetRecommendationLetterLists(Filter, SortByParam, null);
            ESS_RecommendationLetter_DTO.RecommendationLetterDetailDTO LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            LetterDetail.language = new ESS_Global.EnumValue('RecommendationLetterLanguage');
            LetterDetail.language.key = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            LetterDetail.language.value = ESS_Enum.RecommendationLetterLanguage.Thai.name();
            LetterDetail.companyName = 'TOP';
            ESS_RecommendationLetter.SaveRecommendationLetter(LetterDetail);
            
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name());
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa.name();
            Letter.Language__c = ESS_Enum.RecommendationLetterLanguage.English.name();
            Letter.Current_Status__c = ESS_Enum.RecommendationLetterStatus.GeneratedToPDF.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name());
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.SalaryLetterWithoutLeaveForVisa.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(null, ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name());
            Letter.Letter_Type__c = ESS_Enum.RecommendationLetterType.WorkLetterWithoutSalary.name();
            ESS_RecommendationLetter.assignToRecommendationLetterDetailDTO(Letter);
            
            Letter.Company_Name__c = 'TES';
            update(Letter);
            LetterDetail = ESS_RecommendationLetter.GetRecommendationLetterDetail(Letter.Id, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.SaveRecommendationLetter(LetterDetail);
            ESS_RecommendationLetter.GenerateRecommendationLetter(Letter.Id, ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.DeleteRecommendationLetter(Letter.Id);
            
            ESS_RecommendationLetter.GetLetterTypes();
            ESS_RecommendationLetter.GetOrganizations(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
            ESS_RecommendationLetter.GetENOrganizations(ESS_Enum.RecommendationLetterType.SalaryLetterForFinancial.name());
        	ESS_RecommendationLetter.getDependentPicklistValues();
            ESS_RecommendationLetter.getDependentPicklistENValues();
            
            Letter.Letter_Type__c = String.ValueOf(ESS_Enum.RecommendationLetterType.SalaryLetterWithLeaveForVisa);
            ESS_RecommendationLetter.assignToRecommendationLetterListDTO(Letter);
        }
        
        Test.stopTest();
    }
    
}