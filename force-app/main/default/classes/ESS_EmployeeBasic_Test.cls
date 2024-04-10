/* Author Softever */
@isTest
public class ESS_EmployeeBasic_Test {

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
        Master.Death_Child_JSON__c = '[{"thNo":"01","enNo":"01","status":null,"newTHLastName":null,"newTHFirstName":null,"newENLastName":null,"newENFirstName":null,"isMarriedPersonAsEmployee":null,"isEditable":true,"isChange":false,"employeeId":"00000002","documentChangeNameProvince":null,"documentChangeNameNo":null,"documentChangeNameLocation":null,"documentChangeNameDate":null,"documentChangeFirstNameLastNameUrl":null,"documentChangeFirstNameLastNameDisplayUrl":null,"documentBirthProtegeUrl":null,"documentBirthProtegeDisplayUrl":null,"documentBirthCertificateUrl":null,"documentBirthCertificateDisplayUrl":null,"citizenId":null,"enFirstName":"Tasara","enLastName":"Thiamsuwan","gender":{"value":"2","key":"2","enumName":null},"child":{"value":"","key":"","enumName":null},"birthDate":"1962-06-14","thFirstName":"ทัศรา","thLastName":"เทียมสุวรรณ"},{"thNo":"02","enNo":"02","status":null,"newTHLastName":null,"newTHFirstName":null,"newENLastName":null,"newENFirstName":null,"isMarriedPersonAsEmployee":null,"isEditable":true,"isChange":false,"employeeId":"00000002","documentChangeNameProvince":null,"documentChangeNameNo":null,"documentChangeNameLocation":null,"documentChangeNameDate":null,"documentChangeFirstNameLastNameUrl":null,"documentChangeFirstNameLastNameDisplayUrl":null,"documentBirthProtegeUrl":null,"documentBirthProtegeDisplayUrl":null,"documentBirthCertificateUrl":null,"documentBirthCertificateDisplayUrl":null,"citizenId":null,"enFirstName":"Chantrakarn","enLastName":"Pasurapunya","gender":{"value":"2","key":"2","enumName":null},"child":{"value":"","key":"","enumName":null},"birthDate":"1963-11-01","thFirstName":"จันทรกานต์","thLastName":"ภาสุรปัญญา"},{"thNo":"03","enNo":"03","status":null,"newTHLastName":null,"newTHFirstName":null,"newENLastName":null,"newENFirstName":null,"isMarriedPersonAsEmployee":null,"isEditable":true,"isChange":false,"employeeId":"00000002","documentChangeNameProvince":null,"documentChangeNameNo":null,"documentChangeNameLocation":null,"documentChangeNameDate":null,"documentChangeFirstNameLastNameUrl":null,"documentChangeFirstNameLastNameDisplayUrl":null,"documentBirthProtegeUrl":null,"documentBirthProtegeDisplayUrl":null,"documentBirthCertificateUrl":null,"documentBirthCertificateDisplayUrl":null,"citizenId":null,"enFirstName":"Saran","enLastName":"Mi-Trievech","gender":{"value":"1","key":"1","enumName":null},"child":{"value":"","key":"","enumName":null},"birthDate":"1967-10-11","thFirstName":"ศรันย์","thLastName":"ไมตรีเวช"},{"thNo":"04","enNo":"04","status":null,"newTHLastName":null,"newTHFirstName":null,"newENLastName":null,"newENFirstName":null,"isMarriedPersonAsEmployee":null,"isEditable":true,"isChange":false,"employeeId":"00000002","documentChangeNameProvince":null,"documentChangeNameNo":null,"documentChangeNameLocation":null,"documentChangeNameDate":null,"documentChangeFirstNameLastNameUrl":null,"documentChangeFirstNameLastNameDisplayUrl":null,"documentBirthProtegeUrl":null,"documentBirthProtegeDisplayUrl":null,"documentBirthCertificateUrl":null,"documentBirthCertificateDisplayUrl":null,"citizenId":null,"enFirstName":"Pilunta","enLastName":"Mi-Trievech","gender":{"value":"1","key":"1","enumName":null},"child":{"value":"","key":"","enumName":null},"birthDate":"1970-03-26","thFirstName":"พิรุณตา","thLastName":"ไมตรีเวช"}]';
        Master.Education_JSON__c = '[{"no":1,"status":null,"transcriptUrl":null,"transcriptDisplayUrl":null,"startDate":"1957-05-01","qualification":null,"isEditable":false,"isChange":false,"graduatedGrade":"Nil","graduatedDate":"1961-04-01","enEducationalName":"14","enEducationalLevel":"31","enEducationalInstitution":"10000010","enEducationalField":"00053","enEducationalCountry":"TH","degreeCertificateUrl":null,"degreeCertificateDisplayUrl":null}]';
        insert(Master);
        
        /* ESS_Application__c ESSApp = new ESS_Application__c();
        ESSApp.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Draft);
        ESSApp.Submitted_Date__c = null;
        ESSApp.Verified_Date__c = null;
        ESSApp.Completed_Date__c = null;
        ESSApp.Cancelled_Date__c = null;
        ESSApp.Is_Update_Name__c = true;
        ESSApp.Is_Update_Status__c = true;
        ESSApp.Is_Update_Child__c = true;
        ESSApp.Is_Update_Death__c = true;
        ESSApp.Is_Update_Education__c = true;
        ESSApp.Is_Update_License__c = true;
        ESSApp.Is_Update_Address__c = true;
        ESSApp.Is_Update_ContactPerson__c = true;
        ESSApp.Is_Update_Tax__c = true;
        insert(ESSApp); */
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
        suraphan.Name = 'Test Suraphan';
        suraphan.LEVEL__c = 'Section Head';
        suraphan.ORGID__c = '00000002';
        suraphan.POSID__c = '00000002';
        suraphan.THTITLE__c = 'นาย';
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
        adminPersonal.EMPLOYEEID__c = '00000000';
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
        Group adminPersonelGroup = [select id from Group where developername = 'ESS_Personel_Admin'];
        GroupMember personelAdmin = new GroupMember();
        personelAdmin.UserOrGroupId = AdminPersonelId;
        personelAdmin.GroupId = adminPersonelGroup.Id;
        insert(personelAdmin);
        
    }
    
    @isTest
    public static void EmployeeBasicTest() {
        
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
        
        System.runAs(runAsUser) {
            
            ESS_Application__c ESSApp = new ESS_Application__c();
            ESSApp.OwnerId = runAsUser.Id;
            ESSApp.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Draft);
            ESSApp.Document_No__c = 'ETI-2023-01-0001';
            ESSApp.Employee_ID__c = '00000001';
            ESSApp.Employee_Name__c = 'Test';
            ESSApp.Submitted_Date__c = date.today();
            ESSApp.Verified_Date__c = date.today();
            ESSApp.Completed_Date__c = date.today();
            ESSApp.Cancelled_Date__c = date.today();
            ESSApp.Is_Update_Name__c = true;
            ESSApp.Is_Update_Status__c = true;
            ESSApp.Is_Update_Child__c = true;
            ESSApp.Is_Update_Death__c = true;
            ESSApp.Is_Update_Education__c = true;
            ESSApp.Is_Update_License__c = true;
            ESSApp.Is_Update_Address__c = true;
            ESSApp.Is_Update_ContactPerson__c = true;
            ESSApp.Is_Update_Tax__c = true;
            ESSApp.Child_JSON__c = '';
            ESSApp.Death_Child_JSON__c = '';
            ESSApp.Education_JSON__c = '';
            ESSApp.Contact_Person_JSON__c = '';
            insert(ESSApp);
            
            ESS_EmployeeBasic.ApplicationSearchCriteria ApplicationFilter = new ESS_EmployeeBasic.ApplicationSearchCriteria();
            //ApplicationFilter.documentNo = 'ETI-2022-09-0001';
            ApplicationFilter.currentStatus = 'All';
            ApplicationFilter.searchAll = true;
            ApplicationFilter.searchName = true;
            ApplicationFilter.searchStatus = true;
            ApplicationFilter.searchChild = true;
            ApplicationFilter.searchDeath = true;
            ApplicationFilter.searchEducation = true;
            ApplicationFilter.searchLicense = true;
            ApplicationFilter.searchAddress = true;
            ApplicationFilter.searchContactPerson = true;
            ApplicationFilter.searchTax = true;
            ApplicationFilter.startCreatedDate = date.today();
            ApplicationFilter.endCreatedDate = date.today().addMonths(1);
            ApplicationFilter.startSubmittedDate = date.today();
            ApplicationFilter.endSubmittedDate = date.today().addMonths(1);
            ApplicationFilter.startVerifiedDate = date.today();
            ApplicationFilter.endVerifiedDate = date.today().addMonths(1);
            ApplicationFilter.startCompletedDate = date.today();
            ApplicationFilter.endCompletedDate = date.today().addMonths(1);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_EmployeeBasic.GetApplicationListsCount(ApplicationFilter);
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            ESS_EmployeeBasic.GetAdminApplicationListsCount(ApplicationFilter);
            ESS_EmployeeBasic.GetAdminApplicationLists(ApplicationFilter, SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeId';
            SortByParam.ascending = true;
            ApplicationFilter.searchAll = false;
            ESS_EmployeeBasic.GetAdminApplicationListsCount(ApplicationFilter);
            ESS_EmployeeBasic.GetAdminApplicationLists(ApplicationFilter, SortByParam, null);
            
            ESS_EmployeeBasic_DTO.ApplicationDTO application = new ESS_EmployeeBasic_DTO.ApplicationDTO();
            application = ESS_EmployeeBasic.GetApplication(null);
            application.nameInfo.isChange = true;
            application.statusInfo.isChange = true;
            application.statusInfo.isChangeTitleAfterMarried = true;
            application.statusInfo.isChangeLastNameAfterMarried = true;
            application.statusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
            application.statusInfo.marriedStatus.key = '1';
            application.statusInfo.marriedStatus.value = '1';
            application.childInfos = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
            ESS_EmployeeBasic_DTO.ChildInfoDTO childInfo = new ESS_EmployeeBasic_DTO.ChildInfoDTO();
            application.deathInfo.isChange = true;
            application.deathInfo.deathInfos = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
            application.deathInfo.isDeathWife = true;
            application.deathInfo.isDeathFather = true;
            application.deathInfo.isDeathMother = true;
            application.deathInfo.isDeathChild = true;
            ESS_EmployeeBasic_DTO.DeathInfoDTO deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Married';
            deathInfo.deathPerson.value = 'Married';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Father';
            deathInfo.deathPerson.value = 'Father';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Mother';
            deathInfo.deathPerson.value = 'Mother';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Child';
            deathInfo.deathPerson.value = 'Child';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            application.educationInfos = new List<ESS_EmployeeBasic_DTO.EducationInfoDTO>();
            ESS_EmployeeBasic_DTO.EducationInfoDTO educationInfo = new ESS_EmployeeBasic_DTO.EducationInfoDTO();
            educationInfo.isChange = true;
            educationInfo.enEducationalName = 'test';
            educationInfo.enEducationalField = 'test';
            educationInfo.enEducationalInstitution = 'test';
            educationInfo.enEducationalCountry = 'test';
            educationInfo.enEducationalLevel = 'test';
            educationInfo.startDate = date.today();
            educationInfo.graduatedDate = date.today();
            application.educationInfos.add(educationInfo);
            application.licenseInfos = new List<ESS_EmployeeBasic_DTO.LicenseInfoDTO>();
            ESS_EmployeeBasic_DTO.LicenseInfoDTO licenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
            licenseInfo.isChange = true;
            licenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
            licenseInfo.licenseType.key = 'Citizen';
            licenseInfo.licenseType.value = 'Citizen';
            licenseInfo.citizenId = '1234567890123';
            licenseInfo.issueDate = date.today();
            licenseInfo.expireDate = date.today();
            licenseInfo.issuedProvince = 'test';
            licenseInfo.newIssueDate = date.today();
            licenseInfo.newExpireDate = date.today();
            licenseInfo.newIssuedProvince = 'test';
            licenseInfo.licenseNo = 'test';
            licenseInfo.licenseLevel = 'test';
            licenseInfo.engineeringBranch = 'test';
            licenseInfo.newLicenseNo = 'test';
            licenseInfo.newLicenseLevel = 'test';
            licenseInfo.newEngineeringBranch = 'test';
            application.licenseInfos.add(licenseInfo);
            licenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
            licenseInfo.isChange = true;
            licenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
            licenseInfo.licenseType.key = 'Professional';
            licenseInfo.licenseType.value = 'Professional';
            licenseInfo.citizenId = '1234567890123';
            licenseInfo.issueDate = date.today();
            licenseInfo.expireDate = date.today();
            licenseInfo.issuedProvince = 'test';
            licenseInfo.newIssueDate = date.today();
            licenseInfo.newExpireDate = date.today();
            licenseInfo.newIssuedProvince = 'test';
            licenseInfo.licenseNo = 'test';
            licenseInfo.licenseLevel = 'test';
            licenseInfo.engineeringBranch = 'test';
            licenseInfo.newLicenseNo = 'test';
            licenseInfo.newLicenseLevel = 'test';
            licenseInfo.newEngineeringBranch = 'test';
            application.licenseInfos.add(licenseInfo);
            application.addressInfos = new List<ESS_EmployeeBasic_DTO.AddressInfoDTO>();
            ESS_EmployeeBasic_DTO.AddressInfoDTO addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'HouseRegistration';
            addressInfo.addressType.value = 'HouseRegistration';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'Current';
            addressInfo.addressType.value = 'Current';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            application.contactPersonInfos = new List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO>();
            ESS_EmployeeBasic_DTO.ContactPersonInfoDTO contactPersonInfo = new ESS_EmployeeBasic_DTO.ContactPersonInfoDTO();
            contactPersonInfo.isChange = true;
            contactPersonInfo.isCurrent = true;
            contactPersonInfo.isMainContactTH = true;
            contactPersonInfo.thNo = 'test';
            contactPersonInfo.thFirstName = 'test';
            contactPersonInfo.thLastName = 'test';
            contactPersonInfo.thRelationship = 'test';
            contactPersonInfo.thHouseNo = 'test';
            contactPersonInfo.thMoo = 'test';
            contactPersonInfo.thVillageName = 'test';
            contactPersonInfo.thSoi = 'test';
            contactPersonInfo.thRoad = 'test';
            contactPersonInfo.thSubDistrict = 'test';
            contactPersonInfo.thDistrict = 'test';
            contactPersonInfo.thProvince = 'test';
            contactPersonInfo.thPostalCode = 'test';
            contactPersonInfo.thTelephoneNo = 'test';
            contactPersonInfo.enNo = 'test';
            contactPersonInfo.enFirstName = 'test';
            contactPersonInfo.enLastName = 'test';
            contactPersonInfo.enRelationship = 'test';
            contactPersonInfo.enHouseNo = 'test';
            contactPersonInfo.enMoo = 'test';
            contactPersonInfo.enVillageName = 'test';
            contactPersonInfo.enSoi = 'test';
            contactPersonInfo.enRoad = 'test';
            contactPersonInfo.enSubDistrict = 'test';
            contactPersonInfo.enDistrict = 'test';
            contactPersonInfo.enProvince = 'test';
            contactPersonInfo.enPostalCode = 'test';
            contactPersonInfo.enTelephoneNo = 'test';
            application.contactPersonInfos.add(contactPersonInfo);
            application.TaxInfo = new ESS_EmployeeBasic_DTO.TaxInfoDTO();
            application.TaxInfo.isChange = true;
            string childJSON = '[{"thNo":"02","enNo":"02","status":null,"newTHLastName":null,"newTHFirstName":null,"newENLastName":null,"newENFirstName":null,"isMarriedPersonAsEmployee":null,"isEditable":false,"isChange":false,"employeeId":"08000284","documentChangeNameProvince":null,"documentChangeNameNo":null,"documentChangeNameLocation":null,"documentChangeNameDate":null,"documentChangeFirstNameLastNameUrl":null,"documentChangeFirstNameLastNameDisplayUrl":null,"documentBirthProtegeUrl":null,"documentBirthProtegeDisplayUrl":null,"documentBirthCertificateUrl":null,"documentBirthCertificateDisplayUrl":null,"citizenId":null,"enFirstName":"Kookai","enLastName":"Raramon","gender":{"value":"2","key":"2","enumName":null},"child":{"value":"Child","key":"Child","enumName":null},"birthDate":"2022-11-07","thFirstName":"กุ๊กไก่","thLastName":"รรมณ"}]';
            application.nameInfo.childInfos = ESS_EmployeeBasic.DeserializeChildJSON(childJSON);
            application.childInfos = ESS_EmployeeBasic.DeserializeChildJSON(childJSON);
            application = ESS_EmployeeBasic.SaveApplication(application);
            application.statusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
            application.statusInfo.marriedStatus.key = '1';
            application.statusInfo.marriedStatus.value = '1';
            application.ApplicationHeaderInfo.createdDate = date.today();
            system.debug('1.application.childInfos : ' + application.childInfos.size());
            ESS_EmployeeBasic.SubmitApplication(application);
            system.debug('2.application.childInfos : ' + application.childInfos.size());
            ESS_EmployeeBasic.VerifyApplication(application);
            
            application = new ESS_EmployeeBasic_DTO.ApplicationDTO();
            application = ESS_EmployeeBasic.GetApplication(null);
            application.statusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
            application.statusInfo.marriedStatus.key = '1';
            application.statusInfo.marriedStatus.value = '1';
            application.ApplicationHeaderInfo.createdDate = date.today();
            application.NameInfo.isChange = true;
            application.childInfos = ESS_EmployeeBasic.DeserializeChildJSON(childJSON);
            application.educationInfos = new List<ESS_EmployeeBasic_DTO.EducationInfoDTO>();
            educationInfo = new ESS_EmployeeBasic_DTO.EducationInfoDTO();
            educationInfo.isChange = true;
            educationInfo.enEducationalName = 'test';
            educationInfo.enEducationalField = 'test';
            educationInfo.enEducationalInstitution = 'test';
            educationInfo.enEducationalCountry = 'test';
            educationInfo.enEducationalLevel = 'test';
            educationInfo.startDate = date.today();
            educationInfo.graduatedDate = date.today();
            application.educationInfos.add(educationInfo);
            licenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
            licenseInfo.isChange = true;
            licenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
            licenseInfo.licenseType.key = 'Professional';
            licenseInfo.licenseType.value = 'Professional';
            licenseInfo.citizenId = '1234567890123';
            licenseInfo.issueDate = date.today();
            licenseInfo.expireDate = date.today();
            licenseInfo.issuedProvince = 'test';
            licenseInfo.newIssueDate = date.today();
            licenseInfo.newExpireDate = date.today();
            licenseInfo.newIssuedProvince = 'test';
            licenseInfo.licenseNo = 'test';
            licenseInfo.licenseLevel = 'test';
            licenseInfo.engineeringBranch = 'test';
            licenseInfo.newLicenseNo = 'test';
            licenseInfo.newLicenseLevel = 'test';
            licenseInfo.newEngineeringBranch = 'test';
            application.licenseInfos.add(licenseInfo);
            addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'HouseRegistration';
            addressInfo.addressType.value = 'HouseRegistration';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'Current';
            addressInfo.addressType.value = 'Current';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            application.contactPersonInfos = new List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO>();
            contactPersonInfo = new ESS_EmployeeBasic_DTO.ContactPersonInfoDTO();
            contactPersonInfo.isChange = true;
            contactPersonInfo.isCurrent = true;
            contactPersonInfo.isMainContactTH = true;
            contactPersonInfo.thNo = 'test';
            contactPersonInfo.thFirstName = 'test';
            contactPersonInfo.thLastName = 'test';
            contactPersonInfo.thRelationship = 'test';
            contactPersonInfo.thHouseNo = 'test';
            contactPersonInfo.thMoo = 'test';
            contactPersonInfo.thVillageName = 'test';
            contactPersonInfo.thSoi = 'test';
            contactPersonInfo.thRoad = 'test';
            contactPersonInfo.thSubDistrict = 'test';
            contactPersonInfo.thDistrict = 'test';
            contactPersonInfo.thProvince = 'test';
            contactPersonInfo.thPostalCode = 'test';
            contactPersonInfo.thTelephoneNo = 'test';
            contactPersonInfo.enNo = 'test';
            contactPersonInfo.enFirstName = 'test';
            contactPersonInfo.enLastName = 'test';
            contactPersonInfo.enRelationship = 'test';
            contactPersonInfo.enHouseNo = 'test';
            contactPersonInfo.enMoo = 'test';
            contactPersonInfo.enVillageName = 'test';
            contactPersonInfo.enSoi = 'test';
            contactPersonInfo.enRoad = 'test';
            contactPersonInfo.enSubDistrict = 'test';
            contactPersonInfo.enDistrict = 'test';
            contactPersonInfo.enProvince = 'test';
            contactPersonInfo.enPostalCode = 'test';
            contactPersonInfo.enTelephoneNo = 'test';
            application.contactPersonInfos.add(contactPersonInfo);
            system.debug('3.application.childInfos : ' + application.childInfos.size());
            application = ESS_EmployeeBasic.SubmitApplication(application);
            
            application = new ESS_EmployeeBasic_DTO.ApplicationDTO();
            application = ESS_EmployeeBasic.GetApplication(ESSApp.Id);
            application.nameInfo.isChange = true;
            application.statusInfo.isChange = true;
            application.statusInfo.isChangeTitleAfterMarried = true;
            application.statusInfo.isChangeLastNameAfterMarried = true;
            application.statusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
            application.statusInfo.marriedStatus.key = '1';
            application.statusInfo.marriedStatus.value = '1';
            application.childInfos = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
            childInfo = new ESS_EmployeeBasic_DTO.ChildInfoDTO();
            application.deathInfo.isChange = true;
            application.deathInfo.isDeathWife = true;
            application.deathInfo.isDeathFather = true;
            application.deathInfo.isDeathMother = true;
            application.deathInfo.isDeathChild = true;
            application.deathInfo.deathInfos = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Married';
            deathInfo.deathPerson.value = 'Married';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Father';
            deathInfo.deathPerson.value = 'Father';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Mother';
            deathInfo.deathPerson.value = 'Mother';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Child';
            deathInfo.deathPerson.value = 'Child';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            application.educationInfos = new List<ESS_EmployeeBasic_DTO.EducationInfoDTO>();
            educationInfo = new ESS_EmployeeBasic_DTO.EducationInfoDTO();
            educationInfo.isChange = true;
            educationInfo.enEducationalName = 'test';
            educationInfo.enEducationalField = 'test';
            educationInfo.enEducationalInstitution = 'test';
            educationInfo.enEducationalCountry = 'test';
            educationInfo.enEducationalLevel = 'test';
            educationInfo.startDate = date.today();
            educationInfo.graduatedDate = date.today();
            application.educationInfos.add(educationInfo);
            application.licenseInfos = new List<ESS_EmployeeBasic_DTO.LicenseInfoDTO>();
            licenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
            licenseInfo.isChange = true;
            licenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
            licenseInfo.licenseType.key = 'Citizen';
            licenseInfo.licenseType.value = 'Citizen';
            licenseInfo.citizenId = '1234567890123';
            licenseInfo.issueDate = date.today();
            licenseInfo.expireDate = date.today();
            licenseInfo.issuedProvince = 'test';
            licenseInfo.newIssueDate = date.today();
            licenseInfo.newExpireDate = date.today();
            licenseInfo.newIssuedProvince = 'test';
            licenseInfo.licenseNo = 'test';
            licenseInfo.licenseLevel = 'test';
            licenseInfo.engineeringBranch = 'test';
            licenseInfo.newLicenseNo = 'test';
            licenseInfo.newLicenseLevel = 'test';
            licenseInfo.newEngineeringBranch = 'test';
            application.licenseInfos.add(licenseInfo);
            licenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
            licenseInfo.isChange = true;
            licenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
            licenseInfo.licenseType.key = 'Professional';
            licenseInfo.licenseType.value = 'Professional';
            licenseInfo.citizenId = '1234567890123';
            licenseInfo.issueDate = date.today();
            licenseInfo.expireDate = date.today();
            licenseInfo.issuedProvince = 'test';
            licenseInfo.newIssueDate = date.today();
            licenseInfo.newExpireDate = date.today();
            licenseInfo.newIssuedProvince = 'test';
            licenseInfo.licenseNo = 'test';
            licenseInfo.licenseLevel = 'test';
            licenseInfo.engineeringBranch = 'test';
            licenseInfo.newLicenseNo = 'test';
            licenseInfo.newLicenseLevel = 'test';
            licenseInfo.newEngineeringBranch = 'test';
            application.licenseInfos.add(licenseInfo);
            application.addressInfos = new List<ESS_EmployeeBasic_DTO.AddressInfoDTO>();
            addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'HouseRegistration';
            addressInfo.addressType.value = 'HouseRegistration';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'Current';
            addressInfo.addressType.value = 'Current';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            application.contactPersonInfos = new List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO>();
            contactPersonInfo = new ESS_EmployeeBasic_DTO.ContactPersonInfoDTO();
            contactPersonInfo.isChange = true;
            contactPersonInfo.isCurrent = true;
            contactPersonInfo.isMainContactTH = true;
            contactPersonInfo.thNo = 'test';
            contactPersonInfo.thFirstName = 'test';
            contactPersonInfo.thLastName = 'test';
            contactPersonInfo.thRelationship = 'test';
            contactPersonInfo.thHouseNo = 'test';
            contactPersonInfo.thMoo = 'test';
            contactPersonInfo.thVillageName = 'test';
            contactPersonInfo.thSoi = 'test';
            contactPersonInfo.thRoad = 'test';
            contactPersonInfo.thSubDistrict = 'test';
            contactPersonInfo.thDistrict = 'test';
            contactPersonInfo.thProvince = 'test';
            contactPersonInfo.thPostalCode = 'test';
            contactPersonInfo.thTelephoneNo = 'test';
            contactPersonInfo.enNo = 'test';
            contactPersonInfo.enFirstName = 'test';
            contactPersonInfo.enLastName = 'test';
            contactPersonInfo.enRelationship = 'test';
            contactPersonInfo.enHouseNo = 'test';
            contactPersonInfo.enMoo = 'test';
            contactPersonInfo.enVillageName = 'test';
            contactPersonInfo.enSoi = 'test';
            contactPersonInfo.enRoad = 'test';
            contactPersonInfo.enSubDistrict = 'test';
            contactPersonInfo.enDistrict = 'test';
            contactPersonInfo.enProvince = 'test';
            contactPersonInfo.enPostalCode = 'test';
            contactPersonInfo.enTelephoneNo = 'test';
            application.contactPersonInfos.add(contactPersonInfo);
            application.TaxInfo = new ESS_EmployeeBasic_DTO.TaxInfoDTO();
            application.TaxInfo.isChange = true;
            childJSON = '[{"thNo":"02","enNo":"02","status":null,"newTHLastName":null,"newTHFirstName":null,"newENLastName":null,"newENFirstName":null,"isMarriedPersonAsEmployee":null,"isEditable":false,"isChange":false,"employeeId":"08000284","documentChangeNameProvince":null,"documentChangeNameNo":null,"documentChangeNameLocation":null,"documentChangeNameDate":null,"documentChangeFirstNameLastNameUrl":null,"documentChangeFirstNameLastNameDisplayUrl":null,"documentBirthProtegeUrl":null,"documentBirthProtegeDisplayUrl":null,"documentBirthCertificateUrl":null,"documentBirthCertificateDisplayUrl":null,"citizenId":null,"enFirstName":"Kookai","enLastName":"Raramon","gender":{"value":"2","key":"2","enumName":null},"child":{"value":"Child","key":"Child","enumName":null},"birthDate":"2022-11-07","thFirstName":"กุ๊กไก่","thLastName":"รรมณ"}]';
            application.nameInfo.childInfos = ESS_EmployeeBasic.DeserializeChildJSON(childJSON);
            application.childInfos = ESS_EmployeeBasic.DeserializeChildJSON(childJSON);
            application = ESS_EmployeeBasic.SaveApplication(application);
            application.applicationHeaderInfo.documentNo = 'ETI-2022-01';
            //ESS_EmployeeBasic.CancelApplication(application.Id);
            ESS_EmployeeBasic.GetTaxInfo('00000001');
            ESS_EmployeeBasic.SearchMarriage('test');
            ESS_EmployeeBasic.UploadFile('test','test', application.Id);
            
            //Send Noti
            //ESS_NotiAndEmailController.ApplicationSendToOwnerWhenCompletedInSAP(ESSApp);
            ESS_NotiAndEmailController.ApplicationSendToOwnerWhenCancelled(ESSApp);
            
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Completed.name();
            delete(ESSApp);
        }
        Test.stopTest();
    }
    
    @isTest
    public static void EmployeeBasicAssignDTOTest() {
        
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
        
        System.runAs(runAsUser) {
            
            ESS_Application__c ESSApp = new ESS_Application__c();
            ESSApp.OwnerId = runAsUser.Id;
            ESSApp.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Draft);
            ESSApp.Document_No__c = 'ETI-2023-01-0001';
            ESSApp.Employee_ID__c = '00000001';
            ESSApp.Employee_Name__c = 'Test';
            ESSApp.Submitted_Date__c = date.today();
            ESSApp.Verified_Date__c = date.today();
            ESSApp.Completed_Date__c = date.today();
            ESSApp.Cancelled_Date__c = date.today();
            ESSApp.Is_Update_Name__c = true;
            ESSApp.Is_Update_Status__c = true;
            ESSApp.Is_Update_Child__c = true;
            ESSApp.Is_Update_Death__c = true;
            ESSApp.Is_Update_Education__c = true;
            ESSApp.Is_Update_License__c = true;
            ESSApp.Is_Update_Address__c = true;
            ESSApp.Is_Update_ContactPerson__c = true;
            ESSApp.Is_Update_Tax__c = true;
            ESSApp.Child_JSON__c = '';
            ESSApp.Death_Child_JSON__c = '';
            ESSApp.Education_JSON__c = '';
            ESSApp.Contact_Person_JSON__c = '';
            ESSApp.Effective_Date__c = date.today();
            ESSApp.Status_Marriage_Status__c = '1';
            string childJSON = '[{"thNo":"02","enNo":"02","status":null,"newTHLastName":null,"newTHFirstName":null,"newENLastName":null,"newENFirstName":null,"isMarriedPersonAsEmployee":null,"isEditable":false,"isChange":false,"employeeId":"08000284","documentChangeNameProvince":null,"documentChangeNameNo":null,"documentChangeNameLocation":null,"documentChangeNameDate":null,"documentChangeFirstNameLastNameUrl":null,"documentChangeFirstNameLastNameDisplayUrl":null,"documentBirthProtegeUrl":null,"documentBirthProtegeDisplayUrl":null,"documentBirthCertificateUrl":null,"documentBirthCertificateDisplayUrl":null,"citizenId":null,"enFirstName":"Kookai","enLastName":"Raramon","gender":{"value":"2","key":"2","enumName":null},"child":{"value":"Child","key":"Child","enumName":null},"birthDate":"2022-11-07","thFirstName":"กุ๊กไก่","thLastName":"รรมณ"}]';
            ESSApp.Child_JSON__c = childJSON;
            ESSApp.Death_Marriage_FN__c = 'Test';
            ESSApp.Death_Marriage_Title__c = '1';
            ESSApp.Death_Father_FN__c = 'Test';
            ESSApp.Death_Father_Title__c = '1';
            ESSApp.Death_Mother_FN__c = 'Test';
            ESSApp.Death_Mother_Title__c = '1';
            insert(ESSApp);
            
            ESSApp.Name_Emp_EN_Old_Title__c = '2';
            ESSApp.Name_Emp_TH_New_Title__c = '2';
            ESSApp.Name_Emp_EN_New_Title__c = '2';
            ESSApp.Name_Marriage_TH_Old_Title__c = '2';
            ESSApp.Name_Marriage_EN_Old_Title__c = '2';
            ESSApp.Name_Marriage_TH_New_Title__c = '2';
            ESSApp.Name_Marriage_EN_New_Title__c = '2';
            ESSApp.Status_Marriage_Status__c = '2';
            ESSApp.Status_Marriage_TH_Title__c = '2';
            ESSApp.Status_Marriage_EN_Title__c = '2';
            ESSApp.Status_Marriage_TH_New_Title__c = '2';
            ESSApp.Status_Marriage_EN_New_Title__c = '2';
            ESSApp.Status_Divorce_TH_Title__c = '2';
            ESSApp.Status_Divorce_EN_Title__c = '2';
            ESSApp.Status_Divorce_TH_New_Title__c = '2';
            ESSApp.Status_Divorce_EN_New_Title__c = '2';
            ESSApp.Status_Widow_TH_Title__c = '2';
            ESSApp.Status_Widow_EN_Title__c = '2';
            ESSApp.Status_Widow_TH_New_Title__c = '2';
            ESSApp.Status_Widow_EN_New_Title__c = '2';
            ESSApp.Death_Marriage_Title__c = '2';
            ESSApp.Death_Father_Title__c = '2';
            ESSApp.Death_Mother_Title__c = '2';
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Cancelled.name();
            update(ESSApp);
            ESSApp.Name_Emp_EN_Old_Title__c = '3';
            ESSApp.Name_Emp_TH_New_Title__c = '3';
            ESSApp.Name_Emp_EN_New_Title__c = '3';
            ESSApp.Name_Marriage_TH_Old_Title__c = '3';
            ESSApp.Name_Marriage_EN_Old_Title__c = '3';
            ESSApp.Name_Marriage_TH_New_Title__c = '3';
            ESSApp.Name_Marriage_EN_New_Title__c = '3';
            ESSApp.Name_Mother_TH_Old_Title__c = '3';
            ESSApp.Name_Mother_EN_Old_Title__c = '3';
            ESSApp.Name_Mother_TH_New_Title__c = '3';
            ESSApp.Name_Mother_EN_New_Title__c = '3';
            ESSApp.Status_Marriage_Status__c = '3';
            ESSApp.Status_Marriage_TH_Title__c = '3';
            ESSApp.Status_Marriage_EN_Title__c = '3';
            ESSApp.Status_Marriage_TH_New_Title__c = '3';
            ESSApp.Status_Marriage_EN_New_Title__c = '3';
            ESSApp.Status_Divorce_TH_Title__c = '3';
            ESSApp.Status_Divorce_EN_Title__c = '3';
            ESSApp.Status_Divorce_TH_New_Title__c = '3';
            ESSApp.Status_Divorce_EN_New_Title__c = '3';
            ESSApp.Status_Widow_TH_Title__c = '3';
            ESSApp.Status_Widow_EN_Title__c = '3';
            ESSApp.Status_Widow_TH_New_Title__c = '3';
            ESSApp.Status_Widow_EN_New_Title__c = '3';
            ESSApp.Death_Marriage_Title__c = '3';
            ESSApp.Death_Father_Title__c = '3';
            ESSApp.Death_Mother_Title__c = '3';
            ESS_EmployeeBasic.assignToApplicationDTO(ESSApp);
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.SendingToSAP.name();
            update(ESSApp);
            ESS_EmployeeBasic.assignToApplicationDTO(ESSApp);
            
            ESSApp.Name_Emp_EN_Old_Title__c = '4';
            ESSApp.Name_Emp_TH_New_Title__c = '4';
            ESSApp.Name_Emp_EN_New_Title__c = '4';
            ESSApp.Name_Marriage_TH_Old_Title__c = '4';
            ESSApp.Name_Marriage_EN_Old_Title__c = '4';
            ESSApp.Name_Marriage_TH_New_Title__c = '4';
            ESSApp.Name_Marriage_EN_New_Title__c = '4';
            ESSApp.Name_Mother_TH_Old_Title__c = '4';
            ESSApp.Name_Mother_EN_Old_Title__c = '4';
            ESSApp.Name_Mother_TH_New_Title__c = '4';
            ESSApp.Name_Mother_EN_New_Title__c = '4';
            ESSApp.Status_Marriage_Status__c = '4';
            ESSApp.Status_Marriage_TH_Title__c = '4';
            ESSApp.Status_Marriage_EN_Title__c = '4';
            ESSApp.Status_Marriage_TH_New_Title__c = '4';
            ESSApp.Status_Marriage_EN_New_Title__c = '4';
            ESSApp.Status_Divorce_TH_Title__c = '4';
            ESSApp.Status_Divorce_EN_Title__c = '4';
            ESSApp.Status_Divorce_TH_New_Title__c = '4';
            ESSApp.Status_Divorce_EN_New_Title__c = '4';
            ESSApp.Status_Widow_TH_Title__c = '4';
            ESSApp.Status_Widow_EN_Title__c = '4';
            ESSApp.Status_Widow_TH_New_Title__c = '4';
            ESSApp.Status_Widow_EN_New_Title__c = '4';
            ESSApp.Death_Marriage_Title__c = '4';
            ESSApp.Death_Father_Title__c = '4';
            ESSApp.Death_Mother_Title__c = '4';
            update(ESSApp);
            ESS_EmployeeBasic.assignToApplicationDTO(ESSApp);
            ESSApp.Name_Emp_EN_Old_Title__c = '5';
            ESSApp.Name_Emp_TH_New_Title__c = '5';
            ESSApp.Name_Emp_EN_New_Title__c = '5';
            ESSApp.Name_Marriage_TH_Old_Title__c = '5';
            ESSApp.Name_Marriage_EN_Old_Title__c = '5';
            ESSApp.Name_Marriage_TH_New_Title__c = '5';
            ESSApp.Name_Marriage_EN_New_Title__c = '5';
            ESSApp.Name_Father_TH_Old_Title__c = '5';
            ESSApp.Name_Father_EN_Old_Title__c = '5';
            ESSApp.Name_Father_TH_New_Title__c = '5';
            ESSApp.Name_Father_EN_New_Title__c = '5';
            ESSApp.Name_Mother_TH_Old_Title__c = '5';
            ESSApp.Name_Mother_EN_Old_Title__c = '5';
            ESSApp.Name_Mother_TH_New_Title__c = '5';
            ESSApp.Name_Mother_EN_New_Title__c = '5';
            ESSApp.Status_Marriage_TH_Title__c = '5';
            ESSApp.Status_Marriage_EN_Title__c = '5';
            ESSApp.Status_Marriage_TH_New_Title__c = '5';
            ESSApp.Status_Marriage_EN_New_Title__c = '5';
            ESSApp.Status_Divorce_TH_Title__c = '5';
            ESSApp.Status_Divorce_EN_Title__c = '5';
            ESSApp.Status_Divorce_TH_New_Title__c = '5';
            ESSApp.Status_Divorce_EN_New_Title__c = '5';
            ESSApp.Status_Widow_TH_Title__c = '5';
            ESSApp.Status_Widow_EN_Title__c = '5';
            ESSApp.Status_Widow_TH_New_Title__c = '5';
            ESSApp.Status_Widow_EN_New_Title__c = '5';
            ESSApp.Death_Marriage_Title__c = '5';
            ESSApp.Death_Father_Title__c = '5';
            ESSApp.Death_Mother_Title__c = '5';
            update(ESSApp);
            ESS_EmployeeBasic.assignToApplicationDTO(ESSApp);
            
        }
        
        Test.stopTest();
    }
    
    @isTest
    public static void EmployeeBasicSearchMarriageTest() {
        
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
        
        System.runAs(runAsUser) {
            
            ESS_Application__c ESSApp = new ESS_Application__c();
            ESSApp.OwnerId = runAsUser.Id;
            ESSApp.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Draft);
            ESSApp.Document_No__c = 'ETI-2023-01-0001';
            ESSApp.Employee_ID__c = '00000001';
            ESSApp.Employee_Name__c = 'Test';
            ESSApp.Submitted_Date__c = date.today();
            ESSApp.Verified_Date__c = date.today();
            ESSApp.Completed_Date__c = date.today();
            ESSApp.Cancelled_Date__c = date.today();
            ESSApp.Is_Update_Name__c = true;
            ESSApp.Is_Update_Status__c = true;
            ESSApp.Is_Update_Child__c = true;
            ESSApp.Is_Update_Death__c = true;
            ESSApp.Is_Update_Education__c = true;
            ESSApp.Is_Update_License__c = true;
            ESSApp.Is_Update_Address__c = true;
            ESSApp.Is_Update_ContactPerson__c = true;
            ESSApp.Is_Update_Tax__c = true;
            ESSApp.Child_JSON__c = '';
            ESSApp.Death_Child_JSON__c = '';
            ESSApp.Education_JSON__c = '';
            ESSApp.Contact_Person_JSON__c = '';
            insert(ESSApp);
            
            ESS_Master_Employee__c Master = new ESS_Master_Employee__c();
            Master.Data__c = 'IN';
            Master.ExternalId__c = '00000002';
            Master.Employee_ID__c = '00000002';
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
            
            ESS_EmployeeBasic.SearchMarriage('test');
            
            Master.Name_Emp_EN_Title__c = '2';
            update(Master);
            ESS_EmployeeBasic.SearchMarriage('test');
            Master.Name_Emp_EN_Title__c = '3';
            update(Master);
            ESS_EmployeeBasic.SearchMarriage('test');
            Master.Name_Emp_EN_Title__c = '4';
            update(Master);
            ESS_EmployeeBasic.SearchMarriage('test');
            Master.Name_Emp_EN_Title__c = '5';
            update(Master);
            ESS_EmployeeBasic.SearchMarriage('test');
            
        }
        Test.stopTest();
    }
    
    @isTest
    public static void EmployeeBasicSearchTest() {
        
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
        
        System.runAs(runAsUser) {
            
            ESS_Application__c ESSApp = new ESS_Application__c();
            ESSApp.OwnerId = runAsUser.Id;
            ESSApp.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Draft);
            ESSApp.Document_No__c = 'ETI-2023-01-0001';
            ESSApp.Employee_ID__c = '00000001';
            ESSApp.Employee_Name__c = 'Test';
            ESSApp.Submitted_Date__c = date.today();
            ESSApp.Verified_Date__c = date.today();
            ESSApp.Completed_Date__c = date.today();
            ESSApp.Cancelled_Date__c = date.today();
            ESSApp.Is_Update_Name__c = true;
            ESSApp.Is_Update_Status__c = true;
            ESSApp.Is_Update_Child__c = true;
            ESSApp.Is_Update_Death__c = true;
            ESSApp.Is_Update_Education__c = true;
            ESSApp.Is_Update_License__c = true;
            ESSApp.Is_Update_Address__c = true;
            ESSApp.Is_Update_ContactPerson__c = true;
            ESSApp.Is_Update_Tax__c = true;
            ESSApp.Child_JSON__c = '';
            ESSApp.Death_Child_JSON__c = '';
            ESSApp.Education_JSON__c = '';
            ESSApp.Contact_Person_JSON__c = '';
            insert(ESSApp);
            
            ESS_EmployeeBasic.ApplicationSearchCriteria ApplicationFilter = new ESS_EmployeeBasic.ApplicationSearchCriteria();
            //ApplicationFilter.documentNo = 'ETI-2022-09-0001';
            ApplicationFilter.currentStatus = 'All';
            ApplicationFilter.searchAll = false;
            ApplicationFilter.searchName = true;
            ApplicationFilter.searchStatus = true;
            ApplicationFilter.searchChild = true;
            ApplicationFilter.searchDeath = true;
            ApplicationFilter.searchEducation = true;
            ApplicationFilter.searchLicense = true;
            ApplicationFilter.searchAddress = true;
            ApplicationFilter.searchContactPerson = true;
            ApplicationFilter.searchTax = true;
            ApplicationFilter.startCreatedDate = date.today();
            ApplicationFilter.endCreatedDate = date.today().addMonths(1);
            ApplicationFilter.startSubmittedDate = date.today();
            ApplicationFilter.endSubmittedDate = date.today().addMonths(1);
            ApplicationFilter.startVerifiedDate = date.today();
            ApplicationFilter.endVerifiedDate = date.today().addMonths(1);
            ApplicationFilter.startCompletedDate = date.today();
            ApplicationFilter.endCompletedDate = date.today().addMonths(1);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_EmployeeBasic.GetApplicationListsCount(ApplicationFilter);
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            
            ESS_EmployeeBasic_DTO.ApplicationDTO application = new ESS_EmployeeBasic_DTO.ApplicationDTO();
            application = ESS_EmployeeBasic.GetApplication(null);
            application.nameInfo.isChange = true;
            application.statusInfo.isChange = true;
            application.statusInfo.isChangeTitleAfterMarried = true;
            application.statusInfo.isChangeLastNameAfterMarried = true;
            application.statusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
            application.statusInfo.marriedStatus.key = '1';
            application.statusInfo.marriedStatus.value = '1';
            application.childInfos = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
            ESS_EmployeeBasic_DTO.ChildInfoDTO childInfo = new ESS_EmployeeBasic_DTO.ChildInfoDTO();
            application.deathInfo.isChange = true;
            application.deathInfo.deathInfos = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
            application.deathInfo.isDeathWife = true;
            application.deathInfo.isDeathFather = true;
            application.deathInfo.isDeathMother = true;
            application.deathInfo.isDeathChild = true;
            ESS_EmployeeBasic_DTO.DeathInfoDTO deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Married';
            deathInfo.deathPerson.value = 'Married';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Father';
            deathInfo.deathPerson.value = 'Father';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Mother';
            deathInfo.deathPerson.value = 'Mother';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Child';
            deathInfo.deathPerson.value = 'Child';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            application.educationInfos = new List<ESS_EmployeeBasic_DTO.EducationInfoDTO>();
            ESS_EmployeeBasic_DTO.EducationInfoDTO educationInfo = new ESS_EmployeeBasic_DTO.EducationInfoDTO();
            educationInfo.isChange = true;
            educationInfo.enEducationalName = 'test';
            educationInfo.enEducationalField = 'test';
            educationInfo.enEducationalInstitution = 'test';
            educationInfo.enEducationalCountry = 'test';
            educationInfo.enEducationalLevel = 'test';
            educationInfo.startDate = date.today();
            educationInfo.graduatedDate = date.today();
            application.educationInfos.add(educationInfo);
            application.licenseInfos = new List<ESS_EmployeeBasic_DTO.LicenseInfoDTO>();
            ESS_EmployeeBasic_DTO.LicenseInfoDTO licenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
            licenseInfo.isChange = true;
            licenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
            licenseInfo.licenseType.key = 'Citizen';
            licenseInfo.licenseType.value = 'Citizen';
            licenseInfo.citizenId = '1234567890123';
            licenseInfo.issueDate = date.today();
            licenseInfo.expireDate = date.today();
            licenseInfo.issuedProvince = 'test';
            licenseInfo.newIssueDate = date.today();
            licenseInfo.newExpireDate = date.today();
            licenseInfo.newIssuedProvince = 'test';
            licenseInfo.licenseNo = 'test';
            licenseInfo.licenseLevel = 'test';
            licenseInfo.engineeringBranch = 'test';
            licenseInfo.newLicenseNo = 'test';
            licenseInfo.newLicenseLevel = 'test';
            licenseInfo.newEngineeringBranch = 'test';
            application.licenseInfos.add(licenseInfo);
            licenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
            licenseInfo.isChange = true;
            licenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
            licenseInfo.licenseType.key = 'Professional';
            licenseInfo.licenseType.value = 'Professional';
            licenseInfo.citizenId = '1234567890123';
            licenseInfo.issueDate = date.today();
            licenseInfo.expireDate = date.today();
            licenseInfo.issuedProvince = 'test';
            licenseInfo.newIssueDate = date.today();
            licenseInfo.newExpireDate = date.today();
            licenseInfo.newIssuedProvince = 'test';
            licenseInfo.licenseNo = 'test';
            licenseInfo.licenseLevel = 'test';
            licenseInfo.engineeringBranch = 'test';
            licenseInfo.newLicenseNo = 'test';
            licenseInfo.newLicenseLevel = 'test';
            licenseInfo.newEngineeringBranch = 'test';
            application.licenseInfos.add(licenseInfo);
            application.addressInfos = new List<ESS_EmployeeBasic_DTO.AddressInfoDTO>();
            ESS_EmployeeBasic_DTO.AddressInfoDTO addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'HouseRegistration';
            addressInfo.addressType.value = 'HouseRegistration';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'Current';
            addressInfo.addressType.value = 'Current';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            application.contactPersonInfos = new List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO>();
            ESS_EmployeeBasic_DTO.ContactPersonInfoDTO contactPersonInfo = new ESS_EmployeeBasic_DTO.ContactPersonInfoDTO();
            contactPersonInfo.isChange = true;
            contactPersonInfo.isCurrent = true;
            contactPersonInfo.isMainContactTH = true;
            contactPersonInfo.thNo = 'test';
            contactPersonInfo.thFirstName = 'test';
            contactPersonInfo.thLastName = 'test';
            contactPersonInfo.thRelationship = 'test';
            contactPersonInfo.thHouseNo = 'test';
            contactPersonInfo.thMoo = 'test';
            contactPersonInfo.thVillageName = 'test';
            contactPersonInfo.thSoi = 'test';
            contactPersonInfo.thRoad = 'test';
            contactPersonInfo.thSubDistrict = 'test';
            contactPersonInfo.thDistrict = 'test';
            contactPersonInfo.thProvince = 'test';
            contactPersonInfo.thPostalCode = 'test';
            contactPersonInfo.thTelephoneNo = 'test';
            contactPersonInfo.enNo = 'test';
            contactPersonInfo.enFirstName = 'test';
            contactPersonInfo.enLastName = 'test';
            contactPersonInfo.enRelationship = 'test';
            contactPersonInfo.enHouseNo = 'test';
            contactPersonInfo.enMoo = 'test';
            contactPersonInfo.enVillageName = 'test';
            contactPersonInfo.enSoi = 'test';
            contactPersonInfo.enRoad = 'test';
            contactPersonInfo.enSubDistrict = 'test';
            contactPersonInfo.enDistrict = 'test';
            contactPersonInfo.enProvince = 'test';
            contactPersonInfo.enPostalCode = 'test';
            contactPersonInfo.enTelephoneNo = 'test';
            application.contactPersonInfos.add(contactPersonInfo);
            application.TaxInfo = new ESS_EmployeeBasic_DTO.TaxInfoDTO();
            application.TaxInfo.isChange = true;
            string childJSON = '[{"thNo":"02","enNo":"02","status":null,"newTHLastName":null,"newTHFirstName":null,"newENLastName":null,"newENFirstName":null,"isMarriedPersonAsEmployee":null,"isEditable":false,"isChange":false,"employeeId":"08000284","documentChangeNameProvince":null,"documentChangeNameNo":null,"documentChangeNameLocation":null,"documentChangeNameDate":null,"documentChangeFirstNameLastNameUrl":null,"documentChangeFirstNameLastNameDisplayUrl":null,"documentBirthProtegeUrl":null,"documentBirthProtegeDisplayUrl":null,"documentBirthCertificateUrl":null,"documentBirthCertificateDisplayUrl":null,"citizenId":null,"enFirstName":"Kookai","enLastName":"Raramon","gender":{"value":"2","key":"2","enumName":null},"child":{"value":"Child","key":"Child","enumName":null},"birthDate":"2022-11-07","thFirstName":"กุ๊กไก่","thLastName":"รรมณ"}]';
            application.nameInfo.childInfos = ESS_EmployeeBasic.DeserializeChildJSON(childJSON);
            application.childInfos = ESS_EmployeeBasic.DeserializeChildJSON(childJSON);
            application = ESS_EmployeeBasic.SaveApplication(application);
            application.statusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
            application.statusInfo.marriedStatus.key = '1';
            application.statusInfo.marriedStatus.value = '1';
            application.ApplicationHeaderInfo.createdDate = date.today();
            system.debug('4.application.childInfos : ' + application.childInfos.size());
            ESS_EmployeeBasic.SubmitApplication(application);
            ESS_EmployeeBasic.VerifyApplication(application);
            
            application = new ESS_EmployeeBasic_DTO.ApplicationDTO();
            application = ESS_EmployeeBasic.GetApplication(null);
            application.statusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
            application.statusInfo.marriedStatus.key = '1';
            application.statusInfo.marriedStatus.value = '1';
            application.ApplicationHeaderInfo.createdDate = date.today();
            application.NameInfo.isChange = true;
            system.debug('5.application.childInfos : ' + application.childInfos.size());
            application = ESS_EmployeeBasic.SubmitApplication(application);
            
            application = new ESS_EmployeeBasic_DTO.ApplicationDTO();
            application = ESS_EmployeeBasic.GetApplication(ESSApp.Id);
            application.nameInfo.isChange = true;
            application.statusInfo.isChange = true;
            application.statusInfo.isChangeTitleAfterMarried = true;
            application.statusInfo.isChangeLastNameAfterMarried = true;
            application.statusInfo.marriedStatus = new ESS_Global.EnumValue('MarriedStatus');
            application.statusInfo.marriedStatus.key = '1';
            application.statusInfo.marriedStatus.value = '1';
            application.childInfos = new List<ESS_EmployeeBasic_DTO.ChildInfoDTO>();
            childInfo = new ESS_EmployeeBasic_DTO.ChildInfoDTO();
            application.deathInfo.isChange = true;
            application.deathInfo.isDeathWife = true;
            application.deathInfo.isDeathFather = true;
            application.deathInfo.isDeathMother = true;
            application.deathInfo.isDeathChild = true;
            application.deathInfo.deathInfos = new List<ESS_EmployeeBasic_DTO.DeathInfoDTO>();
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Married';
            deathInfo.deathPerson.value = 'Married';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Father';
            deathInfo.deathPerson.value = 'Father';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Mother';
            deathInfo.deathPerson.value = 'Mother';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            deathInfo = new ESS_EmployeeBasic_DTO.DeathInfoDTO();
            deathInfo.thNo = 'test';
            deathInfo.deathPerson = new ESS_Global.EnumValue('DeathPerson');
            deathInfo.deathPerson.key = 'Child';
            deathInfo.deathPerson.value = 'Child';
            deathInfo.thFirstName = 'test';
            deathInfo.thLastName = 'test';
            deathInfo.deathDocumentNo = 'test';
            deathInfo.deathDocumentIssueLocation = 'test';
            deathInfo.deathDocumentIssueProvince = 'test';
            deathInfo.deathDocumentIssueDate = date.today();
            application.deathInfo.deathInfos.add(deathInfo);
            application.educationInfos = new List<ESS_EmployeeBasic_DTO.EducationInfoDTO>();
            educationInfo = new ESS_EmployeeBasic_DTO.EducationInfoDTO();
            educationInfo.isChange = true;
            educationInfo.enEducationalName = 'test';
            educationInfo.enEducationalField = 'test';
            educationInfo.enEducationalInstitution = 'test';
            educationInfo.enEducationalCountry = 'test';
            educationInfo.enEducationalLevel = 'test';
            educationInfo.startDate = date.today();
            educationInfo.graduatedDate = date.today();
            application.educationInfos.add(educationInfo);
            application.licenseInfos = new List<ESS_EmployeeBasic_DTO.LicenseInfoDTO>();
            licenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
            licenseInfo.isChange = true;
            licenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
            licenseInfo.licenseType.key = 'Citizen';
            licenseInfo.licenseType.value = 'Citizen';
            licenseInfo.citizenId = '1234567890123';
            licenseInfo.issueDate = date.today();
            licenseInfo.expireDate = date.today();
            licenseInfo.issuedProvince = 'test';
            licenseInfo.newIssueDate = date.today();
            licenseInfo.newExpireDate = date.today();
            licenseInfo.newIssuedProvince = 'test';
            licenseInfo.licenseNo = 'test';
            licenseInfo.licenseLevel = 'test';
            licenseInfo.engineeringBranch = 'test';
            licenseInfo.newLicenseNo = 'test';
            licenseInfo.newLicenseLevel = 'test';
            licenseInfo.newEngineeringBranch = 'test';
            application.licenseInfos.add(licenseInfo);
            licenseInfo = new ESS_EmployeeBasic_DTO.LicenseInfoDTO();
            licenseInfo.isChange = true;
            licenseInfo.licenseType = new ESS_Global.EnumValue('LicenseType');
            licenseInfo.licenseType.key = 'Professional';
            licenseInfo.licenseType.value = 'Professional';
            licenseInfo.citizenId = '1234567890123';
            licenseInfo.issueDate = date.today();
            licenseInfo.expireDate = date.today();
            licenseInfo.issuedProvince = 'test';
            licenseInfo.newIssueDate = date.today();
            licenseInfo.newExpireDate = date.today();
            licenseInfo.newIssuedProvince = 'test';
            licenseInfo.licenseNo = 'test';
            licenseInfo.licenseLevel = 'test';
            licenseInfo.engineeringBranch = 'test';
            licenseInfo.newLicenseNo = 'test';
            licenseInfo.newLicenseLevel = 'test';
            licenseInfo.newEngineeringBranch = 'test';
            application.licenseInfos.add(licenseInfo);
            application.addressInfos = new List<ESS_EmployeeBasic_DTO.AddressInfoDTO>();
            addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'HouseRegistration';
            addressInfo.addressType.value = 'HouseRegistration';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            addressInfo = new ESS_EmployeeBasic_DTO.AddressInfoDTO();
            addressInfo.isChange = true;
            addressInfo.addressType = new ESS_Global.EnumValue('AddressType');
            addressInfo.addressType.key = 'Current';
            addressInfo.addressType.value = 'Current';
            addressInfo.thHouseNo = '1';
            addressInfo.thMooVillageSoiRoad = 'test';
            addressInfo.thSubDistrictDistrict = 'test';
            addressInfo.thProvince = 'test';
            addressInfo.thPostalCode = 'test';
            addressInfo.thTelephoneNo = 'test';
            addressInfo.enHouseNo = '1';
            addressInfo.enMooVillageSoiRoad = 'test';
            addressInfo.enSubDistrictDistrict = 'test';
            addressInfo.enProvince = 'test';
            addressInfo.enPostalCode = 'test';
            addressInfo.enTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newTHMoo = 'test';
            addressInfo.newTHVillageName = 'test';
            addressInfo.newTHSoi = 'test';
            addressInfo.newTHRoad = 'test';
            addressInfo.newTHSubDistrict = 'test';
            addressInfo.newTHDistrict = 'test';
            addressInfo.newTHProvince = 'test';
            addressInfo.newTHPostalCode = 'test';
            addressInfo.newTHTelephoneNo = 'test';
            addressInfo.newTHHouseNo = 'test';
            addressInfo.newENMoo = 'test';
            addressInfo.newENVillageName = 'test';
            addressInfo.newENSoi = 'test';
            addressInfo.newENRoad = 'test';
            addressInfo.newENSubDistrict = 'test';
            addressInfo.newENDistrict = 'test';
            addressInfo.newENProvince = 'test';
            addressInfo.newENPostalCode = 'test';
            addressInfo.newENTelephoneNo = 'test';
            application.addressInfos.add(addressInfo);
            application.contactPersonInfos = new List<ESS_EmployeeBasic_DTO.ContactPersonInfoDTO>();
            contactPersonInfo = new ESS_EmployeeBasic_DTO.ContactPersonInfoDTO();
            contactPersonInfo.isChange = true;
            contactPersonInfo.isCurrent = true;
            contactPersonInfo.isMainContactTH = true;
            contactPersonInfo.thNo = 'test';
            contactPersonInfo.thFirstName = 'test';
            contactPersonInfo.thLastName = 'test';
            contactPersonInfo.thRelationship = 'test';
            contactPersonInfo.thHouseNo = 'test';
            contactPersonInfo.thMoo = 'test';
            contactPersonInfo.thVillageName = 'test';
            contactPersonInfo.thSoi = 'test';
            contactPersonInfo.thRoad = 'test';
            contactPersonInfo.thSubDistrict = 'test';
            contactPersonInfo.thDistrict = 'test';
            contactPersonInfo.thProvince = 'test';
            contactPersonInfo.thPostalCode = 'test';
            contactPersonInfo.thTelephoneNo = 'test';
            contactPersonInfo.enNo = 'test';
            contactPersonInfo.enFirstName = 'test';
            contactPersonInfo.enLastName = 'test';
            contactPersonInfo.enRelationship = 'test';
            contactPersonInfo.enHouseNo = 'test';
            contactPersonInfo.enMoo = 'test';
            contactPersonInfo.enVillageName = 'test';
            contactPersonInfo.enSoi = 'test';
            contactPersonInfo.enRoad = 'test';
            contactPersonInfo.enSubDistrict = 'test';
            contactPersonInfo.enDistrict = 'test';
            contactPersonInfo.enProvince = 'test';
            contactPersonInfo.enPostalCode = 'test';
            contactPersonInfo.enTelephoneNo = 'test';
            application.contactPersonInfos.add(contactPersonInfo);
            application.TaxInfo = new ESS_EmployeeBasic_DTO.TaxInfoDTO();
            application.TaxInfo.isChange = true;
            childJSON = '[{"thNo":"02","enNo":"02","status":null,"newTHLastName":null,"newTHFirstName":null,"newENLastName":null,"newENFirstName":null,"isMarriedPersonAsEmployee":null,"isEditable":false,"isChange":false,"employeeId":"08000284","documentChangeNameProvince":null,"documentChangeNameNo":null,"documentChangeNameLocation":null,"documentChangeNameDate":null,"documentChangeFirstNameLastNameUrl":null,"documentChangeFirstNameLastNameDisplayUrl":null,"documentBirthProtegeUrl":null,"documentBirthProtegeDisplayUrl":null,"documentBirthCertificateUrl":null,"documentBirthCertificateDisplayUrl":null,"citizenId":null,"enFirstName":"Kookai","enLastName":"Raramon","gender":{"value":"2","key":"2","enumName":null},"child":{"value":"Child","key":"Child","enumName":null},"birthDate":"2022-11-07","thFirstName":"กุ๊กไก่","thLastName":"รรมณ"}]';
            application.nameInfo.childInfos = ESS_EmployeeBasic.DeserializeChildJSON(childJSON);
            application.childInfos = ESS_EmployeeBasic.DeserializeChildJSON(childJSON);
            application = ESS_EmployeeBasic.SaveApplication(application);
            application.applicationHeaderInfo.documentNo = 'ETI-2022-01';
            //ESS_EmployeeBasic.CancelApplication(application.Id);
            ESS_EmployeeBasic.GetTaxInfo('00000001');
            ESS_EmployeeBasic.SearchMarriage('test');
            
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Completed.name();
            update(ESSApp);
            
            ESS_EmployeeBasic.CancelApplication(application.id);
            ESS_EmployeeBasic.DeleteApplication(application.id);
        }
        Test.stopTest();
    }
    
    
    @isTest
    public static void EmployeeBasicNoFilterTest() {
        
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
        
        System.runAs(runAsUser) {
            
            ESS_Application__c ESSApp = new ESS_Application__c();
            ESSApp.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Draft);
            ESSApp.Employee_ID__c = '00000001';
            ESSApp.Submitted_Date__c = null;
            ESSApp.Verified_Date__c = null;
            ESSApp.Completed_Date__c = null;
            ESSApp.Cancelled_Date__c = null;
            ESSApp.Is_Update_Name__c = true;
            ESSApp.Is_Update_Status__c = true;
            ESSApp.Is_Update_Child__c = true;
            ESSApp.Is_Update_Death__c = true;
            ESSApp.Is_Update_Education__c = true;
            ESSApp.Is_Update_License__c = true;
            ESSApp.Is_Update_Address__c = true;
            ESSApp.Is_Update_ContactPerson__c = true;
            ESSApp.Is_Update_Tax__c = true;
            ESSApp.Child_JSON__c = '';
            ESSApp.Death_Child_JSON__c = '';
            ESSApp.Education_JSON__c = '';
            ESSApp.Contact_Person_JSON__c = '';
            ESSApp.OwnerId = runAsUser.Id;
            ESSApp.Name_Emp_EN_Old_Title__c = '1';
            ESSApp.Name_Emp_TH_New_Title__c = '1';
            ESSApp.Name_Emp_EN_New_Title__c = '1';
            ESSApp.Name_Marriage_TH_Old_Title__c = '1';
            ESSApp.Name_Marriage_EN_Old_Title__c = '1';
            ESSApp.Name_Marriage_TH_New_Title__c = '1';
            ESSApp.Name_Marriage_EN_New_Title__c = '1';
            ESSApp.Name_Father_TH_Old_Title__c = '1';
            ESSApp.Name_Father_EN_Old_Title__c = '1';
            ESSApp.Name_Father_TH_New_Title__c = '1';
            ESSApp.Name_Father_EN_New_Title__c = '1';
            ESSApp.Name_Mother_TH_Old_Title__c = '2';
            ESSApp.Name_Mother_EN_Old_Title__c = '2';
            ESSApp.Name_Mother_TH_New_Title__c = '2';
            ESSApp.Name_Mother_EN_New_Title__c = '2';
            ESSApp.Status_Marriage_Status__c = '0';
            ESSApp.Status_Marriage_TH_Title__c = '1';
            ESSApp.Status_Marriage_EN_Title__c = '1';
            ESSApp.Status_Marriage_TH_New_Title__c = '1';
            ESSApp.Status_Marriage_EN_New_Title__c = '1';
            ESSApp.Status_Divorce_TH_Title__c = '1';
            ESSApp.Status_Divorce_EN_Title__c = '1';
            ESSApp.Status_Divorce_TH_New_Title__c = '1';
            ESSApp.Status_Divorce_EN_New_Title__c = '1';
            ESSApp.Status_Widow_TH_Title__c = '1';
            ESSApp.Status_Widow_EN_Title__c = '1';
            ESSApp.Status_Widow_TH_New_Title__c = '1';
            ESSApp.Status_Widow_EN_New_Title__c = '1';
            insert(ESSApp);
            
            ESS_EmployeeBasic.ApplicationSearchCriteria ApplicationFilter = new ESS_EmployeeBasic.ApplicationSearchCriteria();
            //ApplicationFilter.documentNo = 'ETI-2022-09-0001';
            ApplicationFilter.currentStatus = 'All';
            ApplicationFilter.searchAll = true;
            ApplicationFilter.searchName = true;
            ApplicationFilter.searchStatus = true;
            ApplicationFilter.searchChild = true;
            ApplicationFilter.searchDeath = true;
            ApplicationFilter.searchEducation = true;
            ApplicationFilter.searchLicense = true;
            ApplicationFilter.searchAddress = true;
            ApplicationFilter.searchContactPerson = true;
            ApplicationFilter.searchTax = true;
            ApplicationFilter.startCreatedDate = date.today();
            ApplicationFilter.endCreatedDate = date.today().addMonths(1);
            ApplicationFilter.startSubmittedDate = date.today();
            ApplicationFilter.endSubmittedDate = date.today().addMonths(1);
            ApplicationFilter.startVerifiedDate = date.today();
            ApplicationFilter.endVerifiedDate = date.today().addMonths(1);
            ApplicationFilter.startCompletedDate = date.today();
            ApplicationFilter.endCompletedDate = date.today().addMonths(1);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_EmployeeBasic.GetApplicationListsCount(ApplicationFilter);
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            ESS_EmployeeBasic.GetCountries();
            ESS_EmployeeBasic.GetDegrees();
            ESS_EmployeeBasic.GetEducationLevels();
            ESS_EmployeeBasic.GetFieldOfStudies();
            ESS_EmployeeBasic.GetInstitutions();
            ESS_EmployeeBasic.assignSFTitle('1');
            ESS_EmployeeBasic.assignSFTitle('2');
            ESS_EmployeeBasic.assignSFTitle('3');
            ESS_EmployeeBasic.assignSFTitle('4');
            ESS_EmployeeBasic.assignSFTitle('5');
            ESS_EmployeeBasic.assignTHTitle('Mr');
            ESS_EmployeeBasic.assignTHTitle('Mrs');
            ESS_EmployeeBasic.assignTHTitle('Miss');
            ESS_EmployeeBasic.assignTHTitle('Ms');
            ESS_EmployeeBasic.assignTHTitle('Dr');
            ESS_EmployeeBasic.GetCurrentYear();
            ESS_EmployeeBasic.GetCurrentMonth();
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = false;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'subjectType';
            SortByParam.ascending = true;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'subjectType';
            SortByParam.ascending = false;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'currentStatus';
            SortByParam.ascending = true;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'currentStatus';
            SortByParam.ascending = false;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = false;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = false;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'verifiedDate';
            SortByParam.ascending = true;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'verifiedDate';
            SortByParam.ascending = false;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'completedDate';
            SortByParam.ascending = true;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'completedDate';
            SortByParam.ascending = false;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'cancelledDate';
            SortByParam.ascending = true;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'cancelledDate';
            SortByParam.ascending = false;
            ESS_EmployeeBasic.GetApplicationLists(ApplicationFilter, SortByParam, null);
            
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Submitted.name();
            ESSApp.Submitted_Date__c = date.today();
            ESS_EmployeeBasic.assignToApplicationListDTO(ESSApp);
            ESS_EmployeeBasic.assignToApplicationDTO(ESSApp);
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Verified.name();
            ESSApp.Verified_Date__c = date.today();
            ESS_EmployeeBasic.assignToApplicationListDTO(ESSApp);
            ESS_EmployeeBasic.assignToApplicationDTO(ESSApp);
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Completed.name();
            ESSApp.Completed_Date__c = date.today();
            ESS_EmployeeBasic.assignToApplicationListDTO(ESSApp);
            ESS_EmployeeBasic.assignToApplicationDTO(ESSApp);
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Cancelled.name();
            ESSApp.Cancelled_Date__c = date.today();
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.SendingToSAP.name();
            ESSApp.Sending_to_SAP_Date__c = date.today();
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Error.name();
            ESS_EmployeeBasic.assignToApplicationListDTO(ESSApp);
            ESS_EmployeeBasic.assignToApplicationDTO(ESSApp);
        }
        Test.stopTest();
    }
}