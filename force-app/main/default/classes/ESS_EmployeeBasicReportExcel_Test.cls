/* Author Softever */
@isTest
public class ESS_EmployeeBasicReportExcel_Test {

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
    public static void EmployeeBasicReportExcelTest() {
        
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
            ESSApp.Company_Name__c = 'TOP';
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
            ESSApp.Status_Marriage_EN_Title__c = '1';
            insert(ESSApp);
            
            ESS_Application__c ESSTESApp = new ESS_Application__c();
            ESSTESApp.Status__c = String.ValueOf(ESS_Enum.ApplicationStatus.Draft);
            ESSTESApp.Employee_ID__c = '00000001';
            ESSTESApp.Company_Name__c = 'TES';
            ESSTESApp.Submitted_Date__c = null;
            ESSTESApp.Verified_Date__c = null;
            ESSTESApp.Completed_Date__c = null;
            ESSTESApp.Cancelled_Date__c = null;
            ESSTESApp.Is_Update_Name__c = true;
            ESSTESApp.Is_Update_Status__c = true;
            ESSTESApp.Is_Update_Child__c = true;
            ESSTESApp.Is_Update_Death__c = true;
            ESSTESApp.Is_Update_Education__c = true;
            ESSTESApp.Is_Update_License__c = true;
            ESSTESApp.Is_Update_Address__c = true;
            ESSTESApp.Is_Update_ContactPerson__c = true;
            ESSTESApp.Is_Update_Tax__c = true;
            ESSTESApp.Child_JSON__c = '';
            ESSTESApp.Death_Child_JSON__c = '';
            ESSTESApp.Education_JSON__c = '';
            ESSTESApp.Contact_Person_JSON__c = '';
            ESSTESApp.OwnerId = runAsUser.Id;
            insert(ESSTESApp);
            
            ESS_EmployeeBasicReport.SearchCriteria SearchCriteria = new ESS_EmployeeBasicReport.SearchCriteria();
            //SearchCriteria.documentNo = 'ETI-2022-09-0001';
            SearchCriteria.employeeId = '';
            SearchCriteria.companyName = 'All';
            SearchCriteria.function = 'All';
            SearchCriteria.department = 'All';
            SearchCriteria.section = 'All';
            SearchCriteria.unit = 'All';
            SearchCriteria.searchAll = true;
            SearchCriteria.searchName = true;
            SearchCriteria.searchStatus = true;
            SearchCriteria.searchChild = true;
            SearchCriteria.searchDeath = true;
            SearchCriteria.searchEducation = true;
            SearchCriteria.searchLicense = true;
            SearchCriteria.searchAddress = true;
            SearchCriteria.searchContactPerson = true;
            SearchCriteria.searchTax = true;
            SearchCriteria.statusAll = true;
            SearchCriteria.statusDraft = true;
            SearchCriteria.statusSubmitted = true;
            SearchCriteria.statusSendingToSAP = true;
            SearchCriteria.statusCompleted = true;
            SearchCriteria.statusVerified = true;
            SearchCriteria.statusCancelled = true;
            SearchCriteria.statusError = true;
            SearchCriteria.startCreatedDate = date.today();
            SearchCriteria.endCreatedDate = date.today().addMonths(1);
            SearchCriteria.startSubmittedDate = date.today();
            SearchCriteria.endSubmittedDate = date.today().addMonths(1);
            SearchCriteria.startVerifiedDate = date.today();
            SearchCriteria.endVerifiedDate = date.today().addMonths(1);
            SearchCriteria.startEffectiveDate = date.today();
            SearchCriteria.endEffectiveDate = date.today().addMonths(1);
            SearchCriteria.startSendToBatchDate = date.today();
            SearchCriteria.endSendToBatchDate = date.today().addMonths(1);
            SearchCriteria.startSendingToSAPDate = date.today();
            SearchCriteria.endSendingToSAPDate = date.today().addMonths(1);
            SearchCriteria.startCompletedDate = date.today();
            SearchCriteria.endCompletedDate = date.today().addMonths(1);
            
            PageReference EmployeeBasicReportExcel = Page.ESS_EmployeeBasicReport_Excel;
            Test.setCurrentPage(EmployeeBasicReportExcel); 
            ApexPages.currentPage().getParameters().put('trackingReportType','EmployeeBasic');
            ApexPages.currentPage().getParameters().put('documentNo','');
            ApexPages.currentPage().getParameters().put('employeeId','');
            ApexPages.currentPage().getParameters().put('companyName','');
            ApexPages.currentPage().getParameters().put('function','');
            ApexPages.currentPage().getParameters().put('department','');
            ApexPages.currentPage().getParameters().put('section','');
            ApexPages.currentPage().getParameters().put('unit','');
            ApexPages.currentPage().getParameters().put('searchAll', String.ValueOf(SearchCriteria.searchAll));
            ApexPages.currentPage().getParameters().put('searchName',String.ValueOf(SearchCriteria.searchName));
            ApexPages.currentPage().getParameters().put('searchStatus',String.ValueOf(SearchCriteria.searchStatus));
            ApexPages.currentPage().getParameters().put('searchChild',String.ValueOf(SearchCriteria.searchChild));
            ApexPages.currentPage().getParameters().put('searchDeath',String.ValueOf(SearchCriteria.searchDeath));
            ApexPages.currentPage().getParameters().put('searchEducation',String.ValueOf(SearchCriteria.searchEducation));
            ApexPages.currentPage().getParameters().put('searchLicense',String.ValueOf(SearchCriteria.searchLicense));
            ApexPages.currentPage().getParameters().put('searchAddress',String.ValueOf(SearchCriteria.searchAddress));
            ApexPages.currentPage().getParameters().put('searchContactPerson',String.ValueOf(SearchCriteria.searchContactPerson));
            ApexPages.currentPage().getParameters().put('searchTax',String.ValueOf(SearchCriteria.searchTax));
            ApexPages.currentPage().getParameters().put('statusAll',String.ValueOf(SearchCriteria.statusAll));
            ApexPages.currentPage().getParameters().put('statusDraft',String.ValueOf(SearchCriteria.statusDraft));
            ApexPages.currentPage().getParameters().put('statusSubmitted',String.ValueOf(SearchCriteria.statusSubmitted));
            ApexPages.currentPage().getParameters().put('statusSendingToSAP',String.ValueOf(SearchCriteria.statusSendingToSAP));
            ApexPages.currentPage().getParameters().put('statusCompleted',String.ValueOf(SearchCriteria.statusCompleted));
            ApexPages.currentPage().getParameters().put('statusVerified',String.ValueOf(SearchCriteria.statusVerified));
            ApexPages.currentPage().getParameters().put('statusCancelled',String.ValueOf(SearchCriteria.statusCancelled));
            ApexPages.currentPage().getParameters().put('statusError',String.ValueOf(SearchCriteria.statusError));
            ApexPages.currentPage().getParameters().put('startCreatedDate',String.ValueOf(SearchCriteria.startCreatedDate));
            ApexPages.currentPage().getParameters().put('endCreatedDate',String.ValueOf(SearchCriteria.endCreatedDate));
            ApexPages.currentPage().getParameters().put('startSubmittedDate',String.ValueOf(SearchCriteria.startSubmittedDate));
            ApexPages.currentPage().getParameters().put('endSubmittedDate',String.ValueOf(SearchCriteria.endSubmittedDate));
            ApexPages.currentPage().getParameters().put('startVerifiedDate',String.ValueOf(SearchCriteria.startVerifiedDate));
            ApexPages.currentPage().getParameters().put('endVerifiedDate',String.ValueOf(SearchCriteria.endVerifiedDate));
            ApexPages.currentPage().getParameters().put('startEffectiveDate',String.ValueOf(SearchCriteria.startEffectiveDate));
            ApexPages.currentPage().getParameters().put('endEffectiveDate',String.ValueOf(SearchCriteria.endEffectiveDate));
            ApexPages.currentPage().getParameters().put('startSendToBatchDate',String.ValueOf(SearchCriteria.startSendToBatchDate));
            ApexPages.currentPage().getParameters().put('endSendToBatchDate',String.ValueOf(SearchCriteria.endSendToBatchDate));
            ApexPages.currentPage().getParameters().put('startSendingToSAPDate',String.ValueOf(SearchCriteria.startSendingToSAPDate));
            ApexPages.currentPage().getParameters().put('endSendingToSAPDate',String.ValueOf(SearchCriteria.endSendingToSAPDate));
            ApexPages.currentPage().getParameters().put('startCompletedDate',String.ValueOf(SearchCriteria.startCompletedDate));
            ApexPages.currentPage().getParameters().put('endCompletedDate',String.ValueOf(SearchCriteria.endCompletedDate));
            
            ESS_EmployeeBasicReportExcelController ExcelController = new ESS_EmployeeBasicReportExcelController();
            ExcelController.OnloadExcel();
            
            SearchCriteria.searchAll = false;
            SearchCriteria.statusAll = false;
            ApexPages.currentPage().getParameters().put('trackingReportType','EmployeeBasic');
            ApexPages.currentPage().getParameters().put('documentNo','');
            ApexPages.currentPage().getParameters().put('employeeId','');
            ApexPages.currentPage().getParameters().put('companyName','');
            ApexPages.currentPage().getParameters().put('function','');
            ApexPages.currentPage().getParameters().put('department','');
            ApexPages.currentPage().getParameters().put('section','');
            ApexPages.currentPage().getParameters().put('unit','');
            ApexPages.currentPage().getParameters().put('searchAll', String.ValueOf(SearchCriteria.searchAll));
            ApexPages.currentPage().getParameters().put('searchName',String.ValueOf(SearchCriteria.searchName));
            ApexPages.currentPage().getParameters().put('searchStatus',String.ValueOf(SearchCriteria.searchStatus));
            ApexPages.currentPage().getParameters().put('searchChild',String.ValueOf(SearchCriteria.searchChild));
            ApexPages.currentPage().getParameters().put('searchDeath',String.ValueOf(SearchCriteria.searchDeath));
            ApexPages.currentPage().getParameters().put('searchEducation',String.ValueOf(SearchCriteria.searchEducation));
            ApexPages.currentPage().getParameters().put('searchLicense',String.ValueOf(SearchCriteria.searchLicense));
            ApexPages.currentPage().getParameters().put('searchAddress',String.ValueOf(SearchCriteria.searchAddress));
            ApexPages.currentPage().getParameters().put('searchContactPerson',String.ValueOf(SearchCriteria.searchContactPerson));
            ApexPages.currentPage().getParameters().put('searchTax',String.ValueOf(SearchCriteria.searchTax));
            ApexPages.currentPage().getParameters().put('statusAll',String.ValueOf(SearchCriteria.statusAll));
            ApexPages.currentPage().getParameters().put('statusDraft',String.ValueOf(SearchCriteria.statusDraft));
            ApexPages.currentPage().getParameters().put('statusSubmitted',String.ValueOf(SearchCriteria.statusSubmitted));
            ApexPages.currentPage().getParameters().put('statusSendingToSAP',String.ValueOf(SearchCriteria.statusSendingToSAP));
            ApexPages.currentPage().getParameters().put('statusCompleted',String.ValueOf(SearchCriteria.statusCompleted));
            ApexPages.currentPage().getParameters().put('statusVerified',String.ValueOf(SearchCriteria.statusVerified));
            ApexPages.currentPage().getParameters().put('statusCancelled',String.ValueOf(SearchCriteria.statusCancelled));
            ApexPages.currentPage().getParameters().put('statusError',String.ValueOf(SearchCriteria.statusError));
            ApexPages.currentPage().getParameters().put('startCreatedDate',String.ValueOf(SearchCriteria.startCreatedDate));
            ApexPages.currentPage().getParameters().put('endCreatedDate',String.ValueOf(SearchCriteria.endCreatedDate));
            ApexPages.currentPage().getParameters().put('startSubmittedDate',String.ValueOf(SearchCriteria.startSubmittedDate));
            ApexPages.currentPage().getParameters().put('endSubmittedDate',String.ValueOf(SearchCriteria.endSubmittedDate));
            ApexPages.currentPage().getParameters().put('startVerifiedDate',String.ValueOf(SearchCriteria.startVerifiedDate));
            ApexPages.currentPage().getParameters().put('endVerifiedDate',String.ValueOf(SearchCriteria.endVerifiedDate));
            ApexPages.currentPage().getParameters().put('startEffectiveDate',String.ValueOf(SearchCriteria.startEffectiveDate));
            ApexPages.currentPage().getParameters().put('endEffectiveDate',String.ValueOf(SearchCriteria.endEffectiveDate));
            ApexPages.currentPage().getParameters().put('startSendToBatchDate',String.ValueOf(SearchCriteria.startSendToBatchDate));
            ApexPages.currentPage().getParameters().put('endSendToBatchDate',String.ValueOf(SearchCriteria.endSendToBatchDate));
            ApexPages.currentPage().getParameters().put('startSendingToSAPDate',String.ValueOf(SearchCriteria.startSendingToSAPDate));
            ApexPages.currentPage().getParameters().put('endSendingToSAPDate',String.ValueOf(SearchCriteria.endSendingToSAPDate));
            ApexPages.currentPage().getParameters().put('startCompletedDate',String.ValueOf(SearchCriteria.startCompletedDate));
            ApexPages.currentPage().getParameters().put('endCompletedDate',String.ValueOf(SearchCriteria.endCompletedDate));
            
            ExcelController = new ESS_EmployeeBasicReportExcelController();
            ExcelController.OnloadExcel();
            
            ESSApp.Status_Marriage_EN_Title__c = '1';
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Submitted.name();
            ESS_EmployeeBasicReportExcelController.assignToEmployeeBasicTableDTO(ESSApp);
            ESSApp.Status_Marriage_EN_Title__c = '2';
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Verified.name();
            ESS_EmployeeBasicReportExcelController.assignToEmployeeBasicTableDTO(ESSApp);
            ESSApp.Status_Marriage_EN_Title__c = '3';
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Completed.name();
            ESS_EmployeeBasicReportExcelController.assignToEmployeeBasicTableDTO(ESSApp);
            ESSApp.Status_Marriage_EN_Title__c = '4';
            ESSApp.Status__c = ESS_Enum.ApplicationStatus.Cancelled.name();
            ESS_EmployeeBasicReportExcelController.assignToEmployeeBasicTableDTO(ESSApp);
            ESSApp.Status_Marriage_EN_Title__c = '5';
            ESS_EmployeeBasicReportExcelController.assignToEmployeeBasicTableDTO(ESSApp);
            
        }
        
        Test.stopTest();
    
    }
}