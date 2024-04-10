/* Author Softever */
@isTest
public class ESS_Retirement_Test {

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
        sanea.Retirement_Selection__c = true;
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
    public static void RetirementTest() {
        
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
            Master.Employee_DOB__c = date.today().addYears(-59);
            Master.Retirement_Section_Head_Id__c = runAsUser.Id;
            Master.Retirement_Section_Head_Name__c = 'Test';
            Master.Retirement_VP_Id__c = runAsUser.Id;
            Master.Retirement_VP_Name__c = 'Test';
            Master.Retirement_Section_Head_Position__c = 'Test';
            Master.Retirement_VP_Position__c = 'Test';
            Master.Retirement_Section_Head_TH__c = 'Test';
            Master.Retirement_VP_TH__c = 'Test';
            insert(Master);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Retirement.GetRetirementListsCount();
            List<ESS_Retirement_DTO.RetirementListDTO> RetirementList = ESS_Retirement.GetRetirementLists(SortByParam, null);
            ESS_Retirement.MassSaveRetirement(RetirementList);
            ESS_Retirement.MassSubmitRetirement(RetirementList);
            ESS_Retirement.GetRetirementApproveListsCount('',true);
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            
            ESS_Retirement__c Retirement = [select id, ownerId, document_no__c, employee_id__c, age__c, status__c, employee_name_th__c, retirement_choice__c, employee_name__c, submitted_date__c, section_head__c, Section_Head_Id__c,
                            section_head_approve_date__c, department_head__c, Department_Head_Id__c, department_head_approve_date__c, completed_date__c, retirement_date__c, default_retirement_date__c,
                            history_json__c, Date_of_Birth__c, CreatedDate, Section_Head_Flow__c, Section_Head_TH__c, Department_Head_TH__c, employee_title__c, Section_Head_Position_TH__c, Department_Head_Position_TH__c from ESS_Retirement__c];
            
            ESS_Retirement_DTO.RetirementDetailDTO RetirementDetail = ESS_Retirement.GetRetirementDetail(Retirement.Id);
            ESS_Retirement.SubmitRetirement(RetirementDetail);
            RetirementDetail = ESS_Retirement.GetRetirementDetail(null);
            ESS_Retirement.SaveRetirement(RetirementDetail);
            ESS_Retirement.SubmitRetirement(RetirementDetail);
            ESS_Retirement.ApproveRetirement(RetirementDetail.retirementId, ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            
            ESS_Retirement.assignToRetirementApproveListDTO(Retirement);
            ESS_Retirement.assignToRetirementDetail(Retirement);
            
            Retirement.Status__c = ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name();
            update(Retirement);
            ESS_Retirement.RejectRetirement(RetirementDetail.retirementId, 'Test', ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name());
            ESS_Retirement.SearchUsers('00000001', '00000001');
            
            Retirement.Status__c = ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name();
            update(Retirement);
            ESS_Retirement.RejectRetirement(RetirementDetail.retirementId, 'Test', ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            
            Retirement.Status__c = ESS_Enum.RetirementStatus.WaitingForApprovalSectionHead.name();
            Retirement.Retirement_Choice__c = ESS_Enum.RetirementChoice.ExactDateFor60Years.name();
            ESS_Retirement.assignToRetirementDetail(Retirement);
            Retirement.Status__c = ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name();
            Retirement.Retirement_Choice__c = ESS_Enum.RetirementChoice.ExactDateFor55Years.name();
            ESS_Retirement.assignToRetirementDetail(Retirement);
            Retirement.Status__c = ESS_Enum.RetirementStatus.UploadingToPersonalFolder.name();
            Retirement.Retirement_Choice__c = ESS_Enum.RetirementChoice.EndOfMonth.name();
            ESS_Retirement.assignToRetirementDetail(Retirement);
            Retirement.Status__c = ESS_Enum.RetirementStatus.SendingToSAP.name();
            Retirement.Retirement_Choice__c = ESS_Enum.RetirementChoice.EndOfYear.name();
            ESS_Retirement.assignToRetirementDetail(Retirement);
            Retirement.Status__c = ESS_Enum.RetirementStatus.Completed.name();
            ESS_Retirement.assignToRetirementDetail(Retirement);
            Retirement.Status__c = ESS_Enum.RetirementStatus.DefaultFromSystem.name();
            ESS_Retirement.assignToRetirementDetail(Retirement);
            Retirement.Status__c = ESS_Enum.RetirementStatus.UploadFailed.name();
            ESS_Retirement.assignToRetirementDetail(Retirement);
            
            ESS_Retirement.ExportExcel();
            ESS_Retirement.GetApprovalHistory(RetirementDetail.retirementId);
            ESS_Retirement.ESSGlobal_GetFunctions();
            ESS_Retirement.ESSGlobal_GetDepartments(null);
            ESS_Retirement.ESSGlobal_GetSections(null);
            ESS_Retirement.ESSGlobal_GetUnits(null);
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void RetirementSortByTest() {
        
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
            Master.Employee_DOB__c = date.today().addYears(-59);
            Master.Retirement_Section_Head_Id__c = runAsUser.Id;
            Master.Retirement_Section_Head_Name__c = 'Test';
            Master.Retirement_VP_Id__c = runAsUser.Id;
            Master.Retirement_VP_Name__c = 'Test';
            Master.Retirement_Section_Head_Position__c = 'Test';
            Master.Retirement_VP_Position__c = 'Test';
            Master.Retirement_Section_Head_TH__c = 'Test';
            Master.Retirement_VP_TH__c = 'Test';
            insert(Master);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Retirement.GetRetirementListsCount();
            List<ESS_Retirement_DTO.RetirementListDTO> RetirementList = ESS_Retirement.GetRetirementLists(SortByParam, null);
            ESS_Retirement.MassSaveRetirement(RetirementList);
            ESS_Retirement.MassSubmitRetirement(RetirementList);
            ESS_Retirement.GetRetirementApproveListsCount('',true);
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            
            ESS_Retirement__c Retirement = [select id, ownerId, document_no__c, employee_id__c, age__c, status__c, employee_name_th__c, retirement_choice__c, employee_name__c, submitted_date__c, section_head__c, Section_Head_Id__c,
                            section_head_approve_date__c, department_head__c, Department_Head_Id__c, department_head_approve_date__c, completed_date__c, retirement_date__c, default_retirement_date__c,
                            history_json__c, Date_of_Birth__c, CreatedDate, Section_Head_Flow__c, Section_Head_TH__c, Department_Head_TH__c, employee_title__c from ESS_Retirement__c];
            
            ESS_Retirement_DTO.RetirementDetailDTO RetirementDetail = ESS_Retirement.GetRetirementDetail(Retirement.Id);
            ESS_Retirement.SubmitRetirement(RetirementDetail);
            RetirementDetail = ESS_Retirement.GetRetirementDetail(null);
            ESS_Retirement.SaveRetirement(RetirementDetail);
            ESS_Retirement.SubmitRetirement(RetirementDetail);
            
            Retirement.Status__c = ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name();
            update(Retirement);
            ESS_Retirement.ApproveRetirement(RetirementDetail.retirementId, ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeId';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeName';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'retirementChoice';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'retirementDate';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'status';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'createdDate';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeId';
            SortByParam.ascending = false;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeName';
            SortByParam.ascending = false;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'birthDate';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'birthDate';
            SortByParam.ascending = false;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'age';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'age';
            SortByParam.ascending = false;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'function';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'function';
            SortByParam.ascending = false;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'department';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'department';
            SortByParam.ascending = false;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'section';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'section';
            SortByParam.ascending = false;
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void RetirementSortByApproveTest() {
        
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
            Master.Employee_DOB__c = date.today().addYears(-59);
            Master.Retirement_Section_Head_Id__c = runAsUser.Id;
            Master.Retirement_Section_Head_Name__c = 'Test';
            Master.Retirement_VP_Id__c = runAsUser.Id;
            Master.Retirement_VP_Name__c = 'Test';
            Master.Retirement_Section_Head_Position__c = 'Test';
            Master.Retirement_VP_Position__c = 'Test';
            Master.Retirement_Section_Head_TH__c = 'Test';
            Master.Retirement_VP_TH__c = 'Test';
            insert(Master);
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Retirement.GetRetirementListsCount();
            List<ESS_Retirement_DTO.RetirementListDTO> RetirementList = ESS_Retirement.GetRetirementLists(SortByParam, null);
            ESS_Retirement.MassSaveRetirement(RetirementList);
            ESS_Retirement.MassSubmitRetirement(RetirementList);
            ESS_Retirement.GetRetirementApproveListsCount('',true);
            ESS_Retirement.GetRetirementApproveLists('',true,SortByParam,null);
            
            ESS_Retirement__c Retirement = [select id, ownerId, document_no__c, employee_id__c, age__c, status__c, employee_name_th__c, retirement_choice__c, employee_name__c, submitted_date__c, section_head__c, Section_Head_Id__c,
                            section_head_approve_date__c, department_head__c, Department_Head_Id__c, department_head_approve_date__c, completed_date__c, retirement_date__c, default_retirement_date__c,
                            history_json__c, Date_of_Birth__c, CreatedDate, Section_Head_Flow__c, Section_Head_TH__c, Department_Head_TH__c, employee_title__c from ESS_Retirement__c];
            
            ESS_Retirement_DTO.RetirementDetailDTO RetirementDetail = ESS_Retirement.GetRetirementDetail(Retirement.Id);
            ESS_Retirement.SubmitRetirement(RetirementDetail);
            RetirementDetail = ESS_Retirement.GetRetirementDetail(null);
            ESS_Retirement.SaveRetirement(RetirementDetail);
            ESS_Retirement.SubmitRetirement(RetirementDetail);
            
            Retirement.Status__c = ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name();
            update(Retirement);
            ESS_Retirement.ApproveRetirement(RetirementDetail.retirementId, ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead.name());
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'level';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'level';
            SortByParam.ascending = false;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'sectionHead';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'sectionHead';
            SortByParam.ascending = false;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'departmentHead';
            SortByParam.ascending = true;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'departmentHead';
            SortByParam.ascending = false;
            ESS_Retirement.GetRetirementLists(SortByParam, null);
            
            Retirement.Retirement_Choice__c = String.ValueOf(ESS_Enum.RetirementChoice.ExactDateFor60Years);
            Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.WaitingForApprovalDepartmentHead);
            ESS_Retirement.assignToRetirementApproveListDTO(Retirement);
            Retirement.Retirement_Choice__c = String.ValueOf(ESS_Enum.RetirementChoice.ExactDateFor55Years);
            Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.UploadingToPersonalFolder);
            ESS_Retirement.assignToRetirementApproveListDTO(Retirement);
            Retirement.Retirement_Choice__c = String.ValueOf(ESS_Enum.RetirementChoice.EndOfMonth);
            Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.SendingToSAP);
            ESS_Retirement.assignToRetirementApproveListDTO(Retirement);
            Retirement.Retirement_Choice__c = String.ValueOf(ESS_Enum.RetirementChoice.EndOfYear);
            Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.Completed);
            ESS_Retirement.assignToRetirementApproveListDTO(Retirement);
            Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.UploadFailed);
            ESS_Retirement.assignToRetirementApproveListDTO(Retirement);
            Retirement.Status__c = String.ValueOf(ESS_Enum.RetirementStatus.DefaultFromSystem);
            ESS_Retirement.assignToRetirementApproveListDTO(Retirement);
            
            ESS_Retirement.RetirementListSortDTO RetirementListSortDTO = new ESS_Retirement.RetirementListSortDTO();
            RetirementListSortDTO.sortByEmployeeId(RetirementListSortDTO);
            RetirementListSortDTO.sortByEmployeeIdDesc(RetirementListSortDTO);
            RetirementListSortDTO.sortByEmployeeName(RetirementListSortDTO);
            RetirementListSortDTO.sortByEmployeeNameDesc(RetirementListSortDTO);
            RetirementListSortDTO.sortByBirthDate(RetirementListSortDTO);
            RetirementListSortDTO.sortByBirthDateDesc(RetirementListSortDTO);
            RetirementListSortDTO.sortByAge(RetirementListSortDTO);
            RetirementListSortDTO.sortByAgeDesc(RetirementListSortDTO);
            RetirementListSortDTO.sortByFunction(RetirementListSortDTO);
            RetirementListSortDTO.sortByFunctionDesc(RetirementListSortDTO);
            RetirementListSortDTO.sortByDepartment(RetirementListSortDTO);
            RetirementListSortDTO.sortByDepartmentDesc(RetirementListSortDTO);
            RetirementListSortDTO.sortBySection(RetirementListSortDTO);
            RetirementListSortDTO.sortBySectionDesc(RetirementListSortDTO);
            RetirementListSortDTO.sortByLevel(RetirementListSortDTO);
            RetirementListSortDTO.sortByLevelDesc(RetirementListSortDTO);
            RetirementListSortDTO.sortBySectionHeadName(RetirementListSortDTO);
            RetirementListSortDTO.sortBySectionHeadNameDesc(RetirementListSortDTO);
            RetirementListSortDTO.sortByDepartmentHeadName(RetirementListSortDTO);
            RetirementListSortDTO.sortByDepartmentHeadNameDesc(RetirementListSortDTO);
        }
        
        Test.stopTest();
        
    }
}