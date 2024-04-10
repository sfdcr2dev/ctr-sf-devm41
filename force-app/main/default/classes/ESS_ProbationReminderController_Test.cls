@isTest
public class ESS_ProbationReminderController_Test {

    public static String CRON_EXP = '0 0 0 * * ? *';
    
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
    public static void ProbationarySectionHeadRemindTest() {
        
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
            Master.Employee_Date_Joined__c = date.today().addDays(-152);
            Master.Probation_Completed__c = false;
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
            
            Master = new ESS_Master_Employee__c();
            Master.Data__c = 'IN';
            Master.Employee_ID__c = '00000002';
            Master.Name_Emp_EN_FN__c = 'Test';
            Master.Employee_Retirement_Date__c = date.today().addYears(1);
            Master.Employee_DOB__c = date.today();
            Master.Employee_Date_Joined__c = date.today().addDays(-150);
            Master.Probation_Completed__c = false;
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
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Probationary.GetProbationaryListsCount();
            List<ESS_Probationary_DTO.ProbationaryListDTO> ProbationaryList = ESS_Probationary.GetProbationaryLists(SortByParam, null);
            ESS_Probationary.MassSaveProbationary(ProbationaryList);
            ESS_Probationary.MassSubmitProbationary(ProbationaryList);
            ESS_Probationary.GetProbationaryApproveListsCount(true);
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            ESS_Probationary__c Probation = [select id, ownerId, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, submitted_date__c,
                                            status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c,
                                            completed_date__c, section__c, department__c, quality_of_work__c, quantity_of_work__c, safety_awareness__c, knowledge_skills__c, reliability__c, 
                                            attitude__c, section_head_comment__c, engineering_license__c, recommendation__c, recommendation_comment__c, probation_confirmation__c,
                                            probation_confirmation_comment__c, confirm_cep__c, propose_cep__c, cep_confirmation_comment__c, department_head_comment__c, approval_history_json__c,
                                            Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, Section_Head_Position__c, Department_Head_Position__c, Company_Name__c, Section_Head_Flow__c, 
                                            Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, Probation_Status__c, CEP_Confirmation__c, Employee_Name_EN__c from ESS_Probationary__c];
        
            
            ESS_Probationary_DTO.ProbationaryDetailDTO ProbationDetail = ESS_Probationary.GetProbationaryDetail(Probation.Id);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail = ESS_Probationary.SaveProbationary(ProbationDetail);
            ESS_Probationary.SubmitProbationary(ProbationDetail, '');
                   
            string todayDate = String.ValueOf(date.newInstance(date.today().year(), date.today().month(), date.today().day()));
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            Probation.Reassign_Section_Head_Reminder__c = '["' + todayDate + '"]';
            Probation.Reassign_Department_Head_Reminder__c = '["' + todayDate + '"]';
            update(Probation);
            
            // Schedule the test job
        	String jobId = System.schedule('Probation : Section Head / DepartmentHead Reminder',
                                       CRON_EXP, 
                                       new ESS_ProbationReminderBatchable()); 
        
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ProbationaryDepartmentHeadRemindTest() {
        
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
            Master.Employee_Date_Joined__c = date.today().addDays(-152);
            Master.Probation_Completed__c = false;
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
            
            Master = new ESS_Master_Employee__c();
            Master.Data__c = 'IN';
            Master.Employee_ID__c = '00000002';
            Master.Name_Emp_EN_FN__c = 'Test';
            Master.Employee_Retirement_Date__c = date.today().addYears(1);
            Master.Employee_DOB__c = date.today();
            Master.Employee_Date_Joined__c = date.today().addDays(-150);
            Master.Probation_Completed__c = false;
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
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Probationary.GetProbationaryListsCount();
            List<ESS_Probationary_DTO.ProbationaryListDTO> ProbationaryList = ESS_Probationary.GetProbationaryLists(SortByParam, null);
            ESS_Probationary.MassSaveProbationary(ProbationaryList);
            ESS_Probationary.MassSubmitProbationary(ProbationaryList);
            ESS_Probationary.GetProbationaryApproveListsCount(true);
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            ESS_Probationary__c Probation = [select id, ownerId, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, submitted_date__c,
                                            status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c,
                                            completed_date__c, section__c, department__c, quality_of_work__c, quantity_of_work__c, safety_awareness__c, knowledge_skills__c, reliability__c, 
                                            attitude__c, section_head_comment__c, engineering_license__c, recommendation__c, recommendation_comment__c, probation_confirmation__c,
                                            probation_confirmation_comment__c, confirm_cep__c, propose_cep__c, cep_confirmation_comment__c, department_head_comment__c, approval_history_json__c,
                                            Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, Section_Head_Position__c, Department_Head_Position__c, Company_Name__c, Section_Head_Flow__c, 
                                            Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, Probation_Status__c, CEP_Confirmation__c, Employee_Name_EN__c from ESS_Probationary__c];
        
            
            ESS_Probationary_DTO.ProbationaryDetailDTO ProbationDetail = ESS_Probationary.GetProbationaryDetail(Probation.Id);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail = ESS_Probationary.SaveProbationary(ProbationDetail);
            ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            
            string todayDate = String.ValueOf(date.newInstance(date.today().year(), date.today().month(), date.today().day()));
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            Probation.Reassign_Section_Head_Reminder__c = '["' + todayDate + '"]';
            Probation.Reassign_Department_Head_Reminder__c = '["' + todayDate + '"]';
            update(Probation);
            
            // Schedule the test job
        	String jobId = System.schedule('Probation : Section Head / DepartmentHead Reminder',
                                       CRON_EXP, 
                                       new ESS_ProbationReminderBatchable()); 
        
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ProbationaryReassignSectionHeadRemindTest() {
        
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
            Master.Employee_Date_Joined__c = date.today().addDays(-152);
            Master.Probation_Completed__c = false;
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
            
            Master = new ESS_Master_Employee__c();
            Master.Data__c = 'IN';
            Master.Employee_ID__c = '00000002';
            Master.Name_Emp_EN_FN__c = 'Test';
            Master.Employee_Retirement_Date__c = date.today().addYears(1);
            Master.Employee_DOB__c = date.today();
            Master.Employee_Date_Joined__c = date.today().addDays(-150);
            Master.Probation_Completed__c = false;
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
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Probationary.GetProbationaryListsCount();
            List<ESS_Probationary_DTO.ProbationaryListDTO> ProbationaryList = ESS_Probationary.GetProbationaryLists(SortByParam, null);
            ESS_Probationary.MassSaveProbationary(ProbationaryList);
            ESS_Probationary.MassSubmitProbationary(ProbationaryList);
            ESS_Probationary.GetProbationaryApproveListsCount(true);
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            ESS_Probationary__c Probation = [select id, ownerId, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, submitted_date__c,
                                            status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c,
                                            completed_date__c, section__c, department__c, quality_of_work__c, quantity_of_work__c, safety_awareness__c, knowledge_skills__c, reliability__c, 
                                            attitude__c, section_head_comment__c, engineering_license__c, recommendation__c, recommendation_comment__c, probation_confirmation__c,
                                            probation_confirmation_comment__c, confirm_cep__c, propose_cep__c, cep_confirmation_comment__c, department_head_comment__c, approval_history_json__c,
                                            Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, Section_Head_Position__c, Department_Head_Position__c, Company_Name__c, Section_Head_Flow__c, 
                                            Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, Probation_Status__c, CEP_Confirmation__c, Employee_Name_EN__c from ESS_Probationary__c];
        
            
            ESS_Probationary_DTO.ProbationaryDetailDTO ProbationDetail = ESS_Probationary.GetProbationaryDetail(Probation.Id);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail = ESS_Probationary.SaveProbationary(ProbationDetail);
            ESS_Probationary.SubmitProbationary(ProbationDetail, '');
                   
            string todayDate = String.ValueOf(date.newInstance(date.today().year(), date.today().month(), date.today().day()));
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            Probation.Reassign_Section_Head_Reminder__c = '["' + todayDate + '"]';
            Probation.Reassign_Department_Head_Reminder__c = '["' + todayDate + '"]';
            Probation.Reassign_Section_Head_JSON__c = '[{"userId":"' + runAsUser.Id + '","submittedDate":null,"reassignedDate":"' + todayDate + '","position":"MANAGER-AREA D PRODUCTION UNIT OPERATION: OIL MOVEMENTS/LORRY LOADING","name":"Nipon Sietongkam","isAssignedBy":true,"employeeId":"00000558","comment":"nipon to sanoh reasign reminder test"},{"userId":"' + runAsUser.Id + '","submittedDate":null,"reassignedDate":"' + todayDate + '","position":"MANAGER-AREA D PRODUCTION UNIT OPERATION: OIL MOVEMENTS/LORRY LOADING","name":"Nipon Sietongkam","isAssignedBy":true,"employeeId":"00000558","comment":"nipon to sanoh reasign reminder test"}]]';
            update(Probation);
            
            // Schedule the test job
        	String jobId = System.schedule('Probation : Section Head / DepartmentHead Reminder',
                                       CRON_EXP, 
                                       new ESS_ProbationReminderBatchable()); 
        
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ProbationaryReassignDepartmentHeadRemindTest() {
        
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
            Master.Employee_Date_Joined__c = date.today().addDays(-152);
            Master.Probation_Completed__c = false;
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
            
            Master = new ESS_Master_Employee__c();
            Master.Data__c = 'IN';
            Master.Employee_ID__c = '00000002';
            Master.Name_Emp_EN_FN__c = 'Test';
            Master.Employee_Retirement_Date__c = date.today().addYears(1);
            Master.Employee_DOB__c = date.today();
            Master.Employee_Date_Joined__c = date.today().addDays(-150);
            Master.Probation_Completed__c = false;
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
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Probationary.GetProbationaryListsCount();
            List<ESS_Probationary_DTO.ProbationaryListDTO> ProbationaryList = ESS_Probationary.GetProbationaryLists(SortByParam, null);
            ESS_Probationary.MassSaveProbationary(ProbationaryList);
            ESS_Probationary.MassSubmitProbationary(ProbationaryList);
            ESS_Probationary.GetProbationaryApproveListsCount(true);
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            ESS_Probationary__c Probation = [select id, ownerId, document_no__c, employee_id__c, employee_name__c, date_joined_company__c, date_completed_probation__c, submitted_date__c,
                                            status__c, section_head__c, section_head_id__c, section_head_approve_date__c, department_head__c, department_head_id__c, department_head_approve_date__c,
                                            completed_date__c, section__c, department__c, quality_of_work__c, quantity_of_work__c, safety_awareness__c, knowledge_skills__c, reliability__c, 
                                            attitude__c, section_head_comment__c, engineering_license__c, recommendation__c, recommendation_comment__c, probation_confirmation__c,
                                            probation_confirmation_comment__c, confirm_cep__c, propose_cep__c, cep_confirmation_comment__c, department_head_comment__c, approval_history_json__c,
                                            Reassign_Section_Head_JSON__c, Reassign_Department_Head_JSON__c, Section_Head_Position__c, Department_Head_Position__c, Company_Name__c, Section_Head_Flow__c, 
                                            Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, Probation_Status__c, CEP_Confirmation__c, Employee_Name_EN__c from ESS_Probationary__c];
        
            
            ESS_Probationary_DTO.ProbationaryDetailDTO ProbationDetail = ESS_Probationary.GetProbationaryDetail(Probation.Id);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail = ESS_Probationary.SaveProbationary(ProbationDetail);
            ESS_Probationary.SubmitProbationary(ProbationDetail, '');
                   
            string todayDate = String.ValueOf(date.newInstance(date.today().year(), date.today().month(), date.today().day()));
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            Probation.Reassign_Section_Head_Reminder__c = '["' + todayDate + '"]';
            Probation.Reassign_Department_Head_Reminder__c = '["' + todayDate + '"]';
            Probation.Reassign_Department_Head_JSON__c = '[{"userId":"' + runAsUser.Id + '","submittedDate":null,"reassignedDate":"' + todayDate + '","position":"MANAGER-AREA D PRODUCTION UNIT OPERATION: OIL MOVEMENTS/LORRY LOADING","name":"Nipon Sietongkam","isAssignedBy":true,"employeeId":"00000558","comment":"nipon to sanoh reasign reminder test"},{"userId":"' + runAsUser.Id + '","submittedDate":null,"reassignedDate":"' + todayDate + '","position":"MANAGER-AREA D PRODUCTION UNIT OPERATION: OIL MOVEMENTS/LORRY LOADING","name":"Nipon Sietongkam","isAssignedBy":true,"employeeId":"00000558","comment":"nipon to sanoh reasign reminder test"}]]';
            
            update(Probation);
            
            // Schedule the test job
        	String jobId = System.schedule('Probation : Section Head / DepartmentHead Reminder',
                                       CRON_EXP, 
                                       new ESS_ProbationReminderBatchable()); 
        
        }
        
        Test.stopTest();
        
    }
    
}