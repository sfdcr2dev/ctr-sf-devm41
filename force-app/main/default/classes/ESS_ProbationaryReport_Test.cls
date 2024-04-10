/* Author Softever */
@isTest
public class ESS_ProbationaryReport_Test {

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
        sanea.THFIRSTNAME__c = 'Test';
        sanea.THLASTNAME__c = 'Test';
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
    public static void ProbationaryReportTest() {
        
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
            Master.Employee_Date_Joined__c = date.today();
            Master.Retirement_Section_Head_Id__c = runAsUser.Id;
            Master.Retirement_Section_Head_Name__c = 'Test';
            Master.Retirement_VP_Id__c = runAsUser.Id;
            Master.Retirement_VP_Name__c = 'Test';
            Master.Retirement_Section_Head_Position__c = 'Test';
            Master.Retirement_VP_Position__c = 'Test';
            Master.Retirement_Section_Head_TH__c = 'Test';
            Master.Retirement_VP_TH__c = 'Test';
            Master.Probation_Section_Head_Id__c = runAsUser.Id;
            Master.Probation_VP_Id__c = runAsUser.Id;
            insert(Master);
            
            ESS_Probationary__c Probation = new ESS_Probationary__c();
            Probation.OwnerId = runAsUser.Id;
            Probation.Employee_ID__c = '00000001';
            Probation.section_head_id__c = runAsUser.Id;
            Probation.department_head_id__c = runAsUser.Id;
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            Probation.Probation_Status__c = ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name();
            Probation.Approval_History_JSON__c = '[{"submittedDate":"2023-07-09","status":{"value":"Submitted","key":"Submitted","enumName":"ProbationApproveStatus"},"position":"MANAGER-AREA D PRODUCTION UNIT OPERATION: OFFSITE/HYGIENE","name":"00000869 - Wutichai Nipatjakaranan","comment":"","approverRole":null}]';
            insert(Probation);
            
            ESS_ProbationaryReport.ProbationSearchCriteria Filter = new ESS_ProbationaryReport.ProbationSearchCriteria();
            Filter.employeeId = '';
            Filter.sectionHead = '';
            Filter.departmentHead = '';
            Filter.function = 'All';
            Filter.department = 'All';
            Filter.section = 'All';
            Filter.level = 'All';
            Filter.statusAll = true;
            Filter.statusWaitingForApprovalSectionHead = true;
            Filter.statusWaitingForApprovalDepartmentHead = true;
            Filter.statusWaitingForUploadToPersonalFolder = true;
            Filter.statusCompleted = true;
            Filter.probationStatusAll = true;
            Filter.probationStatusRegularEmployee = true;
            Filter.probationStatusTerminateEmployee = true;
            Filter.startCreatedDate = date.today();
            Filter.endCreatedDate = date.today().addMonths(1);
            /* Filter.startSectionHeadSubmittedDate = date.today();
            Filter.endSectionHeadSubmittedDate = date.today().addMonths(1);
            Filter.startSectionHeadReassignedDate = date.today();
            Filter.endSectionHeadReassignedDate = date.today().addMonths(1);
            Filter.startSectionHeadReassignedSubmittedDate = date.today();
            Filter.endSectionHeadReassignedSubmittedDate = date.today().addMonths(1);
            Filter.startDepartmentHeadSubmittedDate = date.today();
            Filter.endDepartmentHeadSubmittedDate = date.today().addMonths(1);
            Filter.startDepartmentHeadReassignedDate = date.today();
            Filter.endDepartmentHeadReassignedDate = date.today().addMonths(1);
            Filter.startDepartmentHeadReassignedSubmittedDate = date.today();
            Filter.endDepartmentHeadReassignedSubmittedDate = date.today().addMonths(1); 
            Filter.startCompletedDate = date.today();
            Filter.endCompletedDate = date.today().addMonths(1); */
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
			ESS_ProbationaryReport.GetProbationTableCount(Filter);
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            ESS_ProbationaryReport.GetProbationGraph(Filter, 'Function');
            ESS_ProbationaryReport.ExportProbationExcel(Filter);
            
            //Change Filter
            Filter = new ESS_ProbationaryReport.ProbationSearchCriteria();
            Filter.employeeId = '';
            Filter.sectionHead = '';
            Filter.departmentHead = '';
            Filter.function = 'AAAA';
            Filter.department = 'BBBB';
            Filter.section = 'CCCC';
            Filter.level = 'DDDD';
            Filter.statusAll = false;
            Filter.statusWaitingForApprovalSectionHead = true;
            Filter.statusWaitingReassignSectionHead = true;
            Filter.statusWaitingForApprovalDepartmentHead = true;
            Filter.statusWaitingReassignDepartmentHead = true;
            Filter.statusWaitingForUploadToPersonalFolder = true;
            Filter.statusCompleted = true;
            Filter.statusUploadFailed = true;
            Filter.probationStatusAll = false;
            Filter.probationStatusRegularEmployee = true;
            Filter.probationStatusTerminateEmployee = true;
            Filter.startCreatedDate = date.today();
            Filter.endCreatedDate = date.today().addMonths(1);
            Filter.startSectionHeadSubmittedDate = date.today();
            Filter.endSectionHeadSubmittedDate = date.today().addMonths(1);
            Filter.startSectionHeadReassignedDate = date.today();
            Filter.endSectionHeadReassignedDate = date.today().addMonths(1);
            Filter.startSectionHeadReassignedSubmittedDate = date.today();
            Filter.endSectionHeadReassignedSubmittedDate = date.today().addMonths(1);
            Filter.startDepartmentHeadSubmittedDate = date.today();
            Filter.endDepartmentHeadSubmittedDate = date.today().addMonths(1);
            Filter.startDepartmentHeadReassignedDate = date.today();
            Filter.endDepartmentHeadReassignedDate = date.today().addMonths(1);
            Filter.startDepartmentHeadReassignedSubmittedDate = date.today();
            Filter.endDepartmentHeadReassignedSubmittedDate = date.today().addMonths(1);
            Filter.startCompletedDate = date.today();
            Filter.endCompletedDate = date.today().addMonths(1);
            
			ESS_ProbationaryReport.GetProbationTableCount(Filter);
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            ESS_ProbationaryReport.GetProbationGraph(Filter, 'Function');
            ESS_ProbationaryReport.ExportProbationExcel(Filter);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeId';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeName';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateJoinedCompany';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateCompletedProbation';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'currentStatus';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'sectionHead';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'sectionHeadSubmittedDate';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'reassignedSectionHead';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'reassignedSectionHeadSubmittedDate';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'departmentHead';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'departmentHeadSubmittedDate';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'reassignedDepartmentHead';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'reassignedDepartmentHeadSubmittedDate';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'completedDate';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'function';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'section';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'department';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'unit';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'level';
            SortByParam.ascending = true;
            ESS_ProbationaryReport.GetProbationTables(Filter, SortByParam, null);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            ESS_ProbationaryReport.assignToProbationTableDTO(Probation);
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name();
            ESS_ProbationaryReport.assignToProbationTableDTO(Probation);
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Completed.name();
            Probation.Probation_Status__c = ESS_Enum.ProbationStatus.TerminateEmployee.name();
            ESS_ProbationaryReport.assignToProbationTableDTO(Probation);
            
            ESS_ProbationaryReport.ESSGlobal_GetLevels();
            ESS_ProbationaryReport.ESSGlobal_GetFunctions();
            ESS_ProbationaryReport.ESSGlobal_GetDepartments(null);
            ESS_ProbationaryReport.ESSGlobal_GetSections(null);
            ESS_ProbationaryReport.ESSGlobal_GetUnits(null);
            
            ESS_ProbationaryReport_DTO.ApprovalHistoryDTO ApprovalHistory = new ESS_ProbationaryReport_DTO.ApprovalHistoryDTO();
            ApprovalHistory.name = 'Test';
            ApprovalHistory.position = 'Position';
            ApprovalHistory.submittedDate = date.today();
            ApprovalHistory.comment = 'Comment';
        }
        
        Test.stopTest();
    }
}