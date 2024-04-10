@isTest
public class ESS_NotiAndEmailController_Test {

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
        
        //PRTR
		User PRTRUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'SANOH',
            Email = 'testsanoh@thaioilgroup.com',
            Username = 'testsanoh@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'Thaioil',
            Alias = 'SN',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(PRTRUser);
        
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
        Id AdminProbationId;
        Id AdminRelatedId;
        Id AdminPRTRRelatedId;
        
        for(User U : Users) {
            if(U.alias == 'RA') {
                AdminPersonelId = U.Id;
            }
            else if(U.alias == 'SA') {
                AdminProbationId = U.Id;
            }
            else if(U.alias == 'NU') {
                AdminRelatedId = U.Id;
            }
            else if(U.alias == 'SN') {
                AdminPRTRRelatedId = U.Id;
            }
        }
        
        
        //Create Related Group
        Group adminRelatedGroup = [select id from Group where developername = 'ESS_Related'];
        GroupMember relatedAdmin = new GroupMember();
        relatedAdmin.UserOrGroupId = AdminRelatedId;
        relatedAdmin.GroupId = adminRelatedGroup.Id;
        insert(relatedAdmin);
        
        relatedAdmin = new GroupMember();
        relatedAdmin.UserOrGroupId = AdminPRTRRelatedId;
        relatedAdmin.GroupId = adminRelatedGroup.Id;
        insert(relatedAdmin);
        
        //Create PersonelAdmin Group
        Group adminPersonelGroup = [select id from Group where developername = 'ESS_Personel_Admin'];
        GroupMember personelAdmin = new GroupMember();
        personelAdmin.UserOrGroupId = AdminPersonelId;
        personelAdmin.GroupId = adminPersonelGroup.Id;
        insert(personelAdmin);
        
        //Create Probation Admin Group
        Group adminProbationGroup = [select id from Group where developername = 'ESS_Probation_Admin'];
        GroupMember probationAdmin = new GroupMember();
        probationAdmin.UserOrGroupId = AdminProbationId;
        probationAdmin.GroupId = adminProbationGroup.Id;
        insert(probationAdmin);
        
    }
    
    @isTest
    public static void EmployeeBasicNotiTest() {
        
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
            ESSApp.Name_Emp_TH_Old_Title_FN_LN__c = 'Test';
            ESSApp.Name_Emp_EN_Old_Title__c = 'Test';
            ESSApp.Name_Emp_EN_Old_FN__c = 'Test';
            ESSApp.Name_Emp_EN_Old_LN__c = 'Test';
            ESSApp.Name_Emp_TH_New_Title__c = 'Test';
            ESSApp.Name_Emp_TH_New_FN__c = 'Test';
            ESSApp.Name_Emp_TH_New_LN__c = 'Test';
            ESSApp.Name_Emp_EN_New_Title__c = 'Test';
            ESSApp.Name_Emp_EN_New_FN__c = 'Test';
            ESSApp.Name_Emp_EN_New_LN__c = 'Test';
            ESSApp.Status_Marriage_Status__c = '1';
            insert(ESSApp);
            
            ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmitted(ESSApp); //E1-01
            
            List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND Mainposition__c = true AND User__c != null];
            
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) { 
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }    
            }
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_02'];
            ESS_NotiAndEmailController.ApplicationSendToOwnerWhenCompletedInSAP(emailTemplate, mapPISUsers, ESSApp);
            
            ESS_NotiAndEmailController.ApplicationSendToOwnerWhenCancelled(ESSApp); //E1-03
            ESS_NotiAndEmailController.ApplicationSendToRelatedWhenEmployeeUpdated(ESSApp); //E1-04
            ESS_NotiAndEmailController.ApplicationSendToRelatedWhenFamilyUpdated(ESSApp); //E1-05
            ESS_NotiAndEmailController.ApplicationSendToRelatedWhenMarriedStatusUpdated(ESSApp); //E1-06
            ESS_NotiAndEmailController.ApplicationSendToRelatedWhenChildUpdated(ESSApp); //E1-07
        }
        Test.stopTest();
    }
    
    @isTest
    public static void EmployeeBasicTaxNotiTest() {
        
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
            ESSApp.Name_Emp_TH_Old_Title_FN_LN__c = 'Test';
            ESSApp.Name_Emp_EN_Old_Title__c = 'Test';
            ESSApp.Name_Emp_EN_Old_FN__c = 'Test';
            ESSApp.Name_Emp_EN_Old_LN__c = 'Test';
            ESSApp.Name_Emp_TH_New_Title__c = 'Test';
            ESSApp.Name_Emp_TH_New_FN__c = 'Test';
            ESSApp.Name_Emp_TH_New_LN__c = 'Test';
            ESSApp.Name_Emp_EN_New_Title__c = 'Test';
            ESSApp.Name_Emp_EN_New_FN__c = 'Test';
            ESSApp.Name_Emp_EN_New_LN__c = 'Test';
            ESSApp.Status_Marriage_Status__c = '1';
            insert(ESSApp);
            
            ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmitted(ESSApp); //E1-01
            
            List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND Mainposition__c = true AND User__c != null];
            
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) { 
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }    
            }
            
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where developername = 'Application_E1_02'];
            ESS_NotiAndEmailController.ApplicationSendToOwnerWhenCompletedInSAP(emailTemplate, mapPISUsers, ESSApp);
            
            ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmittedTax(ESSApp); //E1-08
            ESS_NotiAndEmailController.ApplicationSendToPersonelAdminWhenUserSubmittedContactPerson(ESSApp); //E1-09
        }
        Test.stopTest();
    }
    
    @isTest
    public static void RetirementNotiTest() {
        
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
            
            ESS_Retirement__c Retirement = new ESS_Retirement__c();
            Retirement.Document_No__c = 'RDC-2023-06-0001';
            Retirement.OwnerId = runAsUser.Id;
            Retirement.Employee_ID__c = '00000001';
            Retirement.Employee_Name__c = 'Test';
            Retirement.Submitted_Date__c = date.today();
            Retirement.Reject_Date__c = date.today();
            Retirement.Section_Head_Id__c = runAsUser.Id;
            Retirement.Department_Head_Id__c = runAsUser.Id;
            insert(Retirement);
            
            ESS_NotiAndEmailController.RetirementSendToEmployeeWhenCreate(Retirement); //E2-01
            ESS_NotiAndEmailController.RetirementSendToEmployeeWhenSubmit(Retirement); //E2-02
            ESS_NotiAndEmailController.RetirementSendToSectionHead(Retirement); //E2-03
            ESS_NotiAndEmailController.RetirementSendToDepartmentHead(Retirement); //E2-03
            ESS_NotiAndEmailController.RetirementSendToEmployeeWhenSectionHeadApproved(Retirement); //E2-04
            ESS_NotiAndEmailController.RetirementSendToEmployeeWhenSectionHeadRejected(Retirement, 'Reject Comment'); //E2-05
            ESS_NotiAndEmailController.RetirementSendToPersonelAdminWhenDepartmentHeadApproved(Retirement); //E2-06
            ESS_NotiAndEmailController.RetirementSendToSectionHeadWhenDepartmentHeadRejected(Retirement, 'Reject Comment'); //E2-07
        }
        Test.stopTest();
    }
    
    @isTest
    public static void ProbationNotiTest() {
        
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
            
            ESS_Probationary__c Probation = new ESS_Probationary__c();
            Probation.Document_No__c = 'PBT-2023-06-0001';
            Probation.OwnerId = runAsUser.Id;
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            Probation.Employee_ID__c = '00000001';
            Probation.Employee_Name__c = 'Test';
            Probation.Employee_Name_EN__c = 'Test';
            Probation.Submitted_Date__c = date.today();
            Probation.Section_Head_Id__c = runAsUser.Id;
            Probation.Department_Head_Id__c = runAsUser.Id;
            Probation.Section_Head_Approve_Date__c = date.today();
            Probation.Department_Head_Approve_Date__c = date.today();
            Probation.Probation_Confirmation__c = ESS_Enum.ProbationDepartmentHeadConfirmation.Confirm.name();
            Probation.Reassign_Section_Head_JSON__c = '[{"userId":"' + runAsUser.Id + '","submittedDate":null,"reassignedDate":"2023-06-28","position":"MANAGER-AREA D PRODUCTION UNIT OPERATION: OIL MOVEMENTS/LORRY LOADING","name":"Nipon Sietongkam","isAssignedBy":true,"employeeId":"00000558","comment":"sechead to reassign sechead"},{"userId":"' + runAsUser.Id + '","submittedDate":"2023-06-28","reassignedDate":"2023-06-28","position":"ASSISTANT AREA D PRODUCTION UNIT OPERATION MANAGER-OIL MOVEMENTS D","name":"Chaiporn Suksri","isAssignedBy":false,"employeeId":"00000550","comment":null},{"userId":"' + runAsUser.Id + '","submittedDate":null,"reassignedDate":"2023-06-28","position":"MANAGER-AREA D PRODUCTION UNIT OPERATION: OIL MOVEMENTS/LORRY LOADING","name":"Nipon Sietongkam","isAssignedBy":true,"employeeId":"00000558","comment":"sechead to reassigned sechead 2 "},{"userId":"' + runAsUser.Id + '","submittedDate":"2023-06-28","reassignedDate":"2023-06-28","position":"VICE PRESIDENT-PETROCHEMICAL AND LUBE BASE","name":"Sarunyu Limwongse","isAssignedBy":false,"employeeId":"00000909","comment":null}]';
            Probation.Reassign_Department_Head_JSON__c = '[{"userId":"' + runAsUser.Id + '","submittedDate":null,"reassignedDate":"2023-06-28","position":"VICE PRESIDENT-QUALITY MANAGEMENT","name":"Phumchit Tatsanaprasert","isAssignedBy":true,"employeeId":"00000668","comment":"dept head to reassigned dept head"},{"userId":"' + runAsUser.Id + '","submittedDate":"2023-06-28","reassignedDate":"2023-06-28","position":"VICE PRESIDENT-REFINERY","name":"Nuttapon Meerit","isAssignedBy":false,"employeeId":"00001089","comment":null}]';
            insert(Probation);
            
            List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, POSID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, SectHeadUpPosID__c, HOME_COMP__c, MAINPOSITION__c from PISUsers__c where Active__c = true AND Mainposition__c = true AND User__c != null];
            
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) { 
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }    
            }
            
            ESS_NotiAndEmailController.ProbationSendToSectionHeadWhenCreated(Probation, mapPISUsers); //E3-01
            ESS_NotiAndEmailController.ProbationSendToDepartmentHeadWhenSectionHeadSubmitted(Probation, mapPISUsers); //E3-02
            ESS_NotiAndEmailController.ProbationSendToSectionHeadWhenDepartmentHeadRejected(Probation); //E3-03
            ESS_NotiAndEmailController.ProbationSendToPersonelAdminWhenDepartmentHeadApproved(Probation); //E3-04
            ESS_NotiAndEmailController.ProbationSendToReAssignUserWhenReAssigned(Probation); //E3-05
            ESS_NotiAndEmailController.ProbationSendToReAssignUserWhenReAssigned(Probation, mapPISUsers); //E3-05
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            Probation.Probation_Confirmation__c = ESS_Enum.ProbationDepartmentHeadConfirmation.Terminate.name();
            update(Probation);
            ESS_NotiAndEmailController.ProbationSendToReAssignUserWhenReAssigned(Probation); //E3-05
            
            ESS_NotiAndEmailController.assignSFTitleToTHTitle('1');
            ESS_NotiAndEmailController.assignSFTitleToTHTitle('2');
            ESS_NotiAndEmailController.assignSFTitleToTHTitle('3');
            ESS_NotiAndEmailController.assignSFTitleToTHTitle('4');
            ESS_NotiAndEmailController.assignSFTitleToTHTitle('5');
            ESS_NotiAndEmailController.assignSFTitleToENTitle('1');
            ESS_NotiAndEmailController.assignSFTitleToENTitle('2');
            ESS_NotiAndEmailController.assignSFTitleToENTitle('3');
            ESS_NotiAndEmailController.assignSFTitleToENTitle('4');
            ESS_NotiAndEmailController.assignSFTitleToENTitle('5');
            ESS_NotiAndEmailController.assignSFMarriageStatusToTHTitle('1');
            ESS_NotiAndEmailController.assignSFMarriageStatusToTHTitle('2');
            ESS_NotiAndEmailController.assignSFMarriageStatusToTHTitle('3');
            ESS_NotiAndEmailController.assignSFMarriageStatusToTHTitle('4');
            ESS_NotiAndEmailController.assignSFMarriageStatusToTHTitle('5');
            ESS_NotiAndEmailController.assignSFGenderToTHGender('Male');
            ESS_NotiAndEmailController.assignSFGenderToTHGender('Female');
            ESS_NotiAndEmailController.assignSFChildToTHChild('Child');
            ESS_NotiAndEmailController.assignSFChildToTHChild('Protege');
        }
        
        Test.stopTest();
    }
    
    
}