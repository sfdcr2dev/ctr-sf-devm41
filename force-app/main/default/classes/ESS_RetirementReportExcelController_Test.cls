/* Author Softever */
@isTest
public class ESS_RetirementReportExcelController_Test {

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
    public static void RetirementReportExcelControllerTest() {
        
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
            
            ESS_Master_Employee__c Master = new ESS_Master_Employee__c();
            Master.Data__c = 'IN';
            Master.Employee_ID__c = '00000001';
            Master.Name_Emp_EN_FN__c = 'Test';
            Master.Employee_Retirement_Date__c = date.today().addYears(1);
            Master.Employee_DOB__c = date.today();
            Master.Retirement_Section_Head_Id__c = runAsUser.Id;
            Master.Retirement_Section_Head_Name__c = 'Test';
            Master.Retirement_VP_Id__c = runAsUser.Id;
            Master.Retirement_VP_Name__c = 'Test';
            Master.Retirement_Section_Head_Position__c = 'Test';
            Master.Retirement_VP_Position__c = 'Test';
            Master.Retirement_Section_Head_TH__c = 'Test';
            Master.Retirement_VP_TH__c = 'Test';
            insert(Master);
            
            ESS_Retirement__c Retirement = new ESS_Retirement__c();
            Retirement.OwnerId = runAsUser.Id;
            Retirement.Status__c = ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name();
            Retirement.Retirement_Choice__c = ESS_Enum.RetirementChoice.ExactDateFor55Years.name();
            Retirement.Default_Retirement_Date__c = date.today();
            Retirement.Retirement_Date__c = date.today();
            insert(Retirement);
            
            ESS_RetirementReport.RetirementSearchCriteria Filter = new ESS_RetirementReport.RetirementSearchCriteria();
            Filter.employeeId = '';
            Filter.function = 'All';
            Filter.department = 'All';
            Filter.section = 'All';
            Filter.level = 'All';
            Filter.statusAll = true;
            Filter.statusWaitingEmployeeSubmit = true;
            Filter.statusWaitingForApprovalSectionHead = true;
            Filter.statusWaitingForDepartmentHead = true;
            Filter.statusWaitingForUploadPersonalFolder = true;
            Filter.statusCompleted = true;
            Filter.statusSendingToSAP = true;
            Filter.statusUploadFailed = true;
            Filter.statusDefaultFromSystem = true;
            Filter.statusUploadFailed = true;
            Filter.retirementAll = true;
            Filter.retirementExact55Years = true;
            Filter.retirementExact60Years = true;
            Filter.retirementEndOfMonth = true;
            Filter.retirementEndOfYear = true;
            Filter.startCreatedDate = date.today();
            Filter.endCreatedDate = date.today().addMonths(1);
            /* Filter.startEmployeeSubmittedDate = date.today();
            Filter.endEmployeeSubmittedDate = date.today().addMonths(1);
            Filter.startSectionHeadApprovedDate = date.today();
            Filter.endSectionHeadApprovedDate = date.today().addMonths(1);
            Filter.startDepartmentHeadApprovedDate = date.today();
            Filter.endDepartmentHeadApprovedDate = date.today().addMonths(1);
            Filter.startCompletedDate = date.today();
            Filter.endCompletedDate = date.today().addMonths(1); */
            
            PageReference RetirementReportExcel = Page.ESS_RetirementReport_Excel;
            Test.setCurrentPage(RetirementReportExcel); 
            ApexPages.currentPage().getParameters().put('trackingReportType','Retirement');
            ApexPages.currentPage().getParameters().put('employeeId','');
            ApexPages.currentPage().getParameters().put('function','');
            ApexPages.currentPage().getParameters().put('department','');
            ApexPages.currentPage().getParameters().put('section','');
            ApexPages.currentPage().getParameters().put('level','');
            ApexPages.currentPage().getParameters().put('statusAll', String.ValueOf(Filter.statusAll));
            ApexPages.currentPage().getParameters().put('statusWaitingEmployeeSubmit',String.ValueOf(Filter.statusWaitingEmployeeSubmit));
            ApexPages.currentPage().getParameters().put('statusWaitingForApprovalSectionHead',String.ValueOf(Filter.statusWaitingForApprovalSectionHead));
            ApexPages.currentPage().getParameters().put('statusWaitingForDepartmentHead', String.ValueOf(Filter.statusWaitingForDepartmentHead));
            ApexPages.currentPage().getParameters().put('statusWaitingForUploadPersonalFolder', String.ValueOf(Filter.statusWaitingForUploadPersonalFolder));
            ApexPages.currentPage().getParameters().put('statusCompleted', String.ValueOf(Filter.statusCompleted));
            ApexPages.currentPage().getParameters().put('statusSendingToSAP', String.ValueOf(Filter.statusSendingToSAP));
            ApexPages.currentPage().getParameters().put('statusDefaultFromSystem', String.ValueOf(Filter.statusDefaultFromSystem));
            ApexPages.currentPage().getParameters().put('statusUploadFailed', String.ValueOf(Filter.statusUploadFailed));
            ApexPages.currentPage().getParameters().put('retirementAll',String.ValueOf(Filter.retirementAll));
            ApexPages.currentPage().getParameters().put('retirementExact55Years',String.ValueOf(Filter.retirementExact55Years));
            ApexPages.currentPage().getParameters().put('retirementExact60Years',String.ValueOf(Filter.retirementExact60Years));
            ApexPages.currentPage().getParameters().put('retirementEndOfMonth',String.ValueOf(Filter.retirementEndOfMonth));
            ApexPages.currentPage().getParameters().put('retirementEndOfYear',String.ValueOf(Filter.retirementEndOfYear));
            ApexPages.currentPage().getParameters().put('startCreatedDate',String.ValueOf(Filter.startCreatedDate));
            ApexPages.currentPage().getParameters().put('endCreatedDate',String.ValueOf(Filter.endCreatedDate));
            ApexPages.currentPage().getParameters().put('startEmployeeSubmittedDate',String.ValueOf(Filter.startEmployeeSubmittedDate));
            ApexPages.currentPage().getParameters().put('endEmployeeSubmittedDate',String.ValueOf(Filter.endEmployeeSubmittedDate));
            ApexPages.currentPage().getParameters().put('startSectionHeadApprovedDate',String.ValueOf(Filter.startSectionHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('endSectionHeadApprovedDate',String.ValueOf(Filter.endSectionHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('startDepartmentHeadApprovedDate',String.ValueOf(Filter.startDepartmentHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('endDepartmentHeadApprovedDate',String.ValueOf(Filter.endDepartmentHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('startCompletedDate',String.ValueOf(Filter.startCompletedDate));
            ApexPages.currentPage().getParameters().put('endCompletedDate',String.ValueOf(Filter.endCompletedDate));
            
            ESS_RetirementReportExcelController ExcelController = new ESS_RetirementReportExcelController();
            ExcelController.OnloadExcel();
            
            //Change filter
            Filter.statusAll = false;
            Filter.retirementAll = false;
            RetirementReportExcel = Page.ESS_RetirementReport_Excel;
            Test.setCurrentPage(RetirementReportExcel); 
            ApexPages.currentPage().getParameters().put('trackingReportType','Retirement');
            ApexPages.currentPage().getParameters().put('employeeId','');
            ApexPages.currentPage().getParameters().put('function','AAAA');
            ApexPages.currentPage().getParameters().put('department','BBBB');
            ApexPages.currentPage().getParameters().put('section','CCCC');
            ApexPages.currentPage().getParameters().put('level','DDDD');
            ApexPages.currentPage().getParameters().put('statusAll', String.ValueOf(Filter.statusAll));
            ApexPages.currentPage().getParameters().put('statusWaitingEmployeeSubmit',String.ValueOf(Filter.statusWaitingEmployeeSubmit));
            ApexPages.currentPage().getParameters().put('statusWaitingForApprovalSectionHead',String.ValueOf(Filter.statusWaitingForApprovalSectionHead));
            ApexPages.currentPage().getParameters().put('statusWaitingForDepartmentHead', String.ValueOf(Filter.statusWaitingForDepartmentHead));
            ApexPages.currentPage().getParameters().put('statusWaitingForUploadPersonalFolder', String.ValueOf(Filter.statusWaitingForUploadPersonalFolder));
            ApexPages.currentPage().getParameters().put('statusCompleted', String.ValueOf(Filter.statusCompleted));
            ApexPages.currentPage().getParameters().put('statusSendingToSAP', String.ValueOf(Filter.statusSendingToSAP));
            ApexPages.currentPage().getParameters().put('statusDefaultFromSystem', String.ValueOf(Filter.statusDefaultFromSystem));
            ApexPages.currentPage().getParameters().put('statusUploadFailed', String.ValueOf(Filter.statusUploadFailed));
            ApexPages.currentPage().getParameters().put('retirementAll',String.ValueOf(Filter.retirementAll));
            ApexPages.currentPage().getParameters().put('retirementExact55Years',String.ValueOf(Filter.retirementExact55Years));
            ApexPages.currentPage().getParameters().put('retirementExact60Years',String.ValueOf(Filter.retirementExact60Years));
            ApexPages.currentPage().getParameters().put('retirementEndOfMonth',String.ValueOf(Filter.retirementEndOfMonth));
            ApexPages.currentPage().getParameters().put('retirementEndOfYear',String.ValueOf(Filter.retirementEndOfYear));
            ApexPages.currentPage().getParameters().put('startCreatedDate',String.ValueOf(Filter.startCreatedDate));
            ApexPages.currentPage().getParameters().put('endCreatedDate',String.ValueOf(Filter.endCreatedDate));
            ApexPages.currentPage().getParameters().put('startEmployeeSubmittedDate',String.ValueOf(Filter.startEmployeeSubmittedDate));
            ApexPages.currentPage().getParameters().put('endEmployeeSubmittedDate',String.ValueOf(Filter.endEmployeeSubmittedDate));
            ApexPages.currentPage().getParameters().put('startSectionHeadApprovedDate',String.ValueOf(Filter.startSectionHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('endSectionHeadApprovedDate',String.ValueOf(Filter.endSectionHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('startDepartmentHeadApprovedDate',String.ValueOf(Filter.startDepartmentHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('endDepartmentHeadApprovedDate',String.ValueOf(Filter.endDepartmentHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('startCompletedDate',String.ValueOf(Filter.startCompletedDate));
            ApexPages.currentPage().getParameters().put('endCompletedDate',String.ValueOf(Filter.endCompletedDate));
			
            ExcelController = new ESS_RetirementReportExcelController();
            ExcelController.OnloadExcel();            
        }
        
        Test.stopTest();
    }
    @isTest
    public static void RetirementReportExcelFilterTest() {
        
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
            
            ESS_Master_Employee__c Master = new ESS_Master_Employee__c();
            Master.Data__c = 'IN';
            Master.Employee_ID__c = '00000001';
            Master.Name_Emp_EN_FN__c = 'Test';
            Master.Employee_Retirement_Date__c = date.today().addYears(1);
            Master.Employee_DOB__c = date.today();
            Master.Retirement_Section_Head_Id__c = runAsUser.Id;
            Master.Retirement_Section_Head_Name__c = 'Test';
            Master.Retirement_VP_Id__c = runAsUser.Id;
            Master.Retirement_VP_Name__c = 'Test';
            Master.Retirement_Section_Head_Position__c = 'Test';
            Master.Retirement_VP_Position__c = 'Test';
            Master.Retirement_Section_Head_TH__c = 'Test';
            Master.Retirement_VP_TH__c = 'Test';
            insert(Master);
            
            ESS_Retirement__c Retirement = new ESS_Retirement__c();
            Retirement.OwnerId = runAsUser.Id;
            Retirement.Status__c = ESS_Enum.RetirementStatus.WaitingEmployeeSubmit.name();
            Retirement.Retirement_Choice__c = ESS_Enum.RetirementChoice.ExactDateFor55Years.name();
            Retirement.Default_Retirement_Date__c = date.today();
            Retirement.Retirement_Date__c = date.today();
            insert(Retirement);
            
            ESS_RetirementReport.RetirementSearchCriteria Filter = new ESS_RetirementReport.RetirementSearchCriteria();
            Filter.employeeId = '';
            Filter.function = 'All';
            Filter.department = 'All';
            Filter.section = 'All';
            Filter.level = 'All';
            Filter.statusAll = true;
            Filter.statusWaitingEmployeeSubmit = true;
            Filter.statusWaitingForApprovalSectionHead = true;
            Filter.statusWaitingForDepartmentHead = true;
            Filter.statusWaitingForUploadPersonalFolder = true;
            Filter.statusCompleted = true;
            Filter.statusSendingToSAP = true;
            Filter.statusUploadFailed = true;
            Filter.statusDefaultFromSystem = true;
            Filter.statusUploadFailed = true;
            Filter.retirementAll = true;
            Filter.retirementExact55Years = true;
            Filter.retirementExact60Years = true;
            Filter.retirementEndOfMonth = true;
            Filter.retirementEndOfYear = true;
            Filter.startCreatedDate = date.today();
            Filter.endCreatedDate = date.today().addMonths(1);
            Filter.startEmployeeSubmittedDate = date.today();
            Filter.endEmployeeSubmittedDate = date.today().addMonths(1);
            Filter.startSectionHeadApprovedDate = date.today();
            Filter.endSectionHeadApprovedDate = date.today().addMonths(1);
            Filter.startDepartmentHeadApprovedDate = date.today();
            Filter.endDepartmentHeadApprovedDate = date.today().addMonths(1);
            Filter.startCompletedDate = date.today();
            Filter.endCompletedDate = date.today().addMonths(1);
            
            PageReference RetirementReportExcel = Page.ESS_RetirementReport_Excel;
            Test.setCurrentPage(RetirementReportExcel); 
            ApexPages.currentPage().getParameters().put('trackingReportType','Retirement');
            ApexPages.currentPage().getParameters().put('employeeId','');
            ApexPages.currentPage().getParameters().put('function','');
            ApexPages.currentPage().getParameters().put('department','');
            ApexPages.currentPage().getParameters().put('section','');
            ApexPages.currentPage().getParameters().put('level','');
            ApexPages.currentPage().getParameters().put('statusAll', String.ValueOf(Filter.statusAll));
            ApexPages.currentPage().getParameters().put('statusWaitingEmployeeSubmit',String.ValueOf(Filter.statusWaitingEmployeeSubmit));
            ApexPages.currentPage().getParameters().put('statusWaitingForApprovalSectionHead',String.ValueOf(Filter.statusWaitingForApprovalSectionHead));
            ApexPages.currentPage().getParameters().put('statusWaitingForDepartmentHead', String.ValueOf(Filter.statusWaitingForDepartmentHead));
            ApexPages.currentPage().getParameters().put('statusWaitingForUploadPersonalFolder', String.ValueOf(Filter.statusWaitingForUploadPersonalFolder));
            ApexPages.currentPage().getParameters().put('statusCompleted', String.ValueOf(Filter.statusCompleted));
            ApexPages.currentPage().getParameters().put('statusSendingToSAP', String.ValueOf(Filter.statusSendingToSAP));
            ApexPages.currentPage().getParameters().put('statusDefaultFromSystem', String.ValueOf(Filter.statusDefaultFromSystem));
            ApexPages.currentPage().getParameters().put('statusUploadFailed', String.ValueOf(Filter.statusUploadFailed));
            ApexPages.currentPage().getParameters().put('retirementAll',String.ValueOf(Filter.retirementAll));
            ApexPages.currentPage().getParameters().put('retirementExact55Years',String.ValueOf(Filter.retirementExact55Years));
            ApexPages.currentPage().getParameters().put('retirementExact60Years',String.ValueOf(Filter.retirementExact60Years));
            ApexPages.currentPage().getParameters().put('retirementEndOfMonth',String.ValueOf(Filter.retirementEndOfMonth));
            ApexPages.currentPage().getParameters().put('retirementEndOfYear',String.ValueOf(Filter.retirementEndOfYear));
            ApexPages.currentPage().getParameters().put('startCreatedDate',String.ValueOf(Filter.startCreatedDate));
            ApexPages.currentPage().getParameters().put('endCreatedDate',String.ValueOf(Filter.endCreatedDate));
            ApexPages.currentPage().getParameters().put('startEmployeeSubmittedDate',String.ValueOf(Filter.startEmployeeSubmittedDate));
            ApexPages.currentPage().getParameters().put('endEmployeeSubmittedDate',String.ValueOf(Filter.endEmployeeSubmittedDate));
            ApexPages.currentPage().getParameters().put('startSectionHeadApprovedDate',String.ValueOf(Filter.startSectionHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('endSectionHeadApprovedDate',String.ValueOf(Filter.endSectionHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('startDepartmentHeadApprovedDate',String.ValueOf(Filter.startDepartmentHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('endDepartmentHeadApprovedDate',String.ValueOf(Filter.endDepartmentHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('startCompletedDate',String.ValueOf(Filter.startCompletedDate));
            ApexPages.currentPage().getParameters().put('endCompletedDate',String.ValueOf(Filter.endCompletedDate));
            
            ESS_RetirementReportExcelController ExcelController = new ESS_RetirementReportExcelController();
            ExcelController.OnloadExcel();
            
            //Change filter
            Filter.statusAll = false;
            Filter.retirementAll = false;
            RetirementReportExcel = Page.ESS_RetirementReport_Excel;
            Test.setCurrentPage(RetirementReportExcel); 
            ApexPages.currentPage().getParameters().put('trackingReportType','Retirement');
            ApexPages.currentPage().getParameters().put('employeeId','');
            ApexPages.currentPage().getParameters().put('function','AAAA');
            ApexPages.currentPage().getParameters().put('department','BBBB');
            ApexPages.currentPage().getParameters().put('section','CCCC');
            ApexPages.currentPage().getParameters().put('level','DDDD');
            ApexPages.currentPage().getParameters().put('statusAll', String.ValueOf(Filter.statusAll));
            ApexPages.currentPage().getParameters().put('statusWaitingEmployeeSubmit',String.ValueOf(Filter.statusWaitingEmployeeSubmit));
            ApexPages.currentPage().getParameters().put('statusWaitingForApprovalSectionHead',String.ValueOf(Filter.statusWaitingForApprovalSectionHead));
            ApexPages.currentPage().getParameters().put('statusWaitingForDepartmentHead', String.ValueOf(Filter.statusWaitingForDepartmentHead));
            ApexPages.currentPage().getParameters().put('statusWaitingForUploadPersonalFolder', String.ValueOf(Filter.statusWaitingForUploadPersonalFolder));
            ApexPages.currentPage().getParameters().put('statusCompleted', String.ValueOf(Filter.statusCompleted));
            ApexPages.currentPage().getParameters().put('statusSendingToSAP', String.ValueOf(Filter.statusSendingToSAP));
            ApexPages.currentPage().getParameters().put('statusDefaultFromSystem', String.ValueOf(Filter.statusDefaultFromSystem));
            ApexPages.currentPage().getParameters().put('statusUploadFailed', String.ValueOf(Filter.statusUploadFailed));
            ApexPages.currentPage().getParameters().put('retirementAll',String.ValueOf(Filter.retirementAll));
            ApexPages.currentPage().getParameters().put('retirementExact55Years',String.ValueOf(Filter.retirementExact55Years));
            ApexPages.currentPage().getParameters().put('retirementExact60Years',String.ValueOf(Filter.retirementExact60Years));
            ApexPages.currentPage().getParameters().put('retirementEndOfMonth',String.ValueOf(Filter.retirementEndOfMonth));
            ApexPages.currentPage().getParameters().put('retirementEndOfYear',String.ValueOf(Filter.retirementEndOfYear));
            ApexPages.currentPage().getParameters().put('startCreatedDate',String.ValueOf(Filter.startCreatedDate));
            ApexPages.currentPage().getParameters().put('endCreatedDate',String.ValueOf(Filter.endCreatedDate));
            ApexPages.currentPage().getParameters().put('startEmployeeSubmittedDate',String.ValueOf(Filter.startEmployeeSubmittedDate));
            ApexPages.currentPage().getParameters().put('endEmployeeSubmittedDate',String.ValueOf(Filter.endEmployeeSubmittedDate));
            ApexPages.currentPage().getParameters().put('startSectionHeadApprovedDate',String.ValueOf(Filter.startSectionHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('endSectionHeadApprovedDate',String.ValueOf(Filter.endSectionHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('startDepartmentHeadApprovedDate',String.ValueOf(Filter.startDepartmentHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('endDepartmentHeadApprovedDate',String.ValueOf(Filter.endDepartmentHeadApprovedDate));
            ApexPages.currentPage().getParameters().put('startCompletedDate',String.ValueOf(Filter.startCompletedDate));
            ApexPages.currentPage().getParameters().put('endCompletedDate',String.ValueOf(Filter.endCompletedDate));
			
            ExcelController = new ESS_RetirementReportExcelController();
            ExcelController.OnloadExcel();            
        }
        
        Test.stopTest();
    }
}