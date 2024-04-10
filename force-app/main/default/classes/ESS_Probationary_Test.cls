/* Author Softever */
@isTest
public class ESS_Probationary_Test {

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
    public static void ProbationaryTest() {
        
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
                            
            List<ESS_Probationary_DTO.ReassignDTO> reassigns = new List<ESS_Probationary_DTO.ReassignDTO>();
            ESS_Probationary_DTO.ReassignDTO reassign = new ESS_Probationary_DTO.ReassignDTO();
            reassign.name = 'Atittaya Tiao';
            reassign.position = 'MANAGER-ECONOMICS AND PLANNING';
            reassign.submittedDate = system.today();
            reassign.userId = runAsUser.Id;
            reassign.reassignedDate = date.today();
            reassigns.add(reassign);
            string reassignJSON = JSON.serialize(reassigns);
            ESS_Probationary.DeserializeReassigns(reassignJSON);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            Probation.quantity_of_work__c = ESS_Enum.ProbationSectionHeadQuantity.Learn.name();
            Probation.quality_of_work__c = ESS_Enum.ProbationSectionHeadQuality.Below.name();
            Probation.safety_awareness__c = ESS_Enum.ProbationSectionHeadSafety.Below.name();
            Probation.knowledge_skills__c = ESS_Enum.ProbationSectionHeadKnowledge.Insufficient.name();
            Probation.reliability__c = ESS_Enum.ProbationSectionHeadReliability.NeedSupervision.name();
            Probation.attitude__c = ESS_Enum.ProbationSectionHeadAttitude.LackDescipline.name();
            Probation.engineering_license__c = ESS_Enum.ProbationSectionHeadEngineering.AlreadyPossessed.name();
            Probation.recommendation__c = ESS_Enum.ProbationSectionHeadRecommendation.Confirm.name();
            Probation.probation_confirmation__c = ESS_Enum.ProbationSectionHeadRecommendation.Confirm.name();
            Probation.Probation_Status__c = ESS_Enum.ProbationStatus.TerminateEmployee.name();
            Probation.Reassign_Section_Head_JSON__c = reassignJSON;
            update(Probation);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            ProbationDetail.reassignSectionHeads = reassigns;
            ProbationDetail = ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            Probation.quantity_of_work__c = ESS_Enum.ProbationSectionHeadQuantity.Meet.name();
            Probation.quality_of_work__c = ESS_Enum.ProbationSectionHeadQuality.Meet.name();
            Probation.safety_awareness__c = ESS_Enum.ProbationSectionHeadSafety.Meet.name();
            Probation.knowledge_skills__c = ESS_Enum.ProbationSectionHeadKnowledge.Sufficient.name();
            Probation.reliability__c = ESS_Enum.ProbationSectionHeadReliability.OccasionalSupervision.name();
            Probation.attitude__c = ESS_Enum.ProbationSectionHeadAttitude.NeatAndObey.name();
            Probation.engineering_license__c = ESS_Enum.ProbationSectionHeadEngineering.NotYetPossessed.name();
            Probation.recommendation__c = ESS_Enum.ProbationSectionHeadRecommendation.Terminate.name();
            Probation.probation_confirmation__c = ESS_Enum.ProbationSectionHeadRecommendation.Terminate.name();
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            ProbationDetail.reassignDepartmentHeads = reassigns;
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            update(Probation);
            
            ProbationDetail = ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            Probation.quantity_of_work__c = ESS_Enum.ProbationSectionHeadQuantity.Better.name();
            Probation.quality_of_work__c = ESS_Enum.ProbationSectionHeadQuality.Better.name();
            Probation.safety_awareness__c = ESS_Enum.ProbationSectionHeadSafety.Better.name();
            Probation.knowledge_skills__c = ESS_Enum.ProbationSectionHeadKnowledge.SufficientBetter.name();
            Probation.reliability__c = ESS_Enum.ProbationSectionHeadReliability.WithoutSupervision.name();
            Probation.attitude__c = ESS_Enum.ProbationSectionHeadAttitude.WorkWell.name();
            Probation.Reassign_Department_Head_JSON__c = reassignJSON;
            update(Probation);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            ProbationDetail.reassignDepartmentHeads = reassigns;
            ProbationDetail = ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Submitted.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Completed.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            
            List<ESS_Probationary_DTO.ApprovalHistoryDTO> approvalHistories = new List<ESS_Probationary_DTO.ApprovalHistoryDTO>();
            ESS_Probationary_DTO.ApprovalHistoryDTO approvalHistory = new ESS_Probationary_DTO.ApprovalHistoryDTO();
            approvalHistory.name = 'Atittaya Tiao';
            approvalHistory.position = 'MANAGER-TECHNICAL COMPETENCT DEVELOPMENT';
            approvalHistory.approverRole = new ESS_Global.EnumValue('ApproverRole');
            approvalHistory.approverRole.key = ESS_Enum.ApproverRole.SectionHead.name();
            approvalHistory.approverRole.value = 'Immediate Line / Section Head';
            approvalHistory.submittedDate = system.today();
            approvalHistory.status = new ESS_Global.EnumValue('ProbationApproveStatus');
            approvalHistory.status.key = ESS_Enum.ProbationApproveStatus.Reassigned.name();
            approvalHistory.status.value = 'Reassigned';
            approvalHistory.comment = 'รบกวนประเมินใหม่';
            approvalHistories.add(approvalHistory);
            string approvalHisoryJSON = JSON.serialize(approvalHistories);
            ESS_Probationary.DeserializeHistoryWorkflows(approvalHisoryJSON);
            
            
            ESS_Probationary.ReassignPersonSearchCriteria SearchCriteria = new ESS_Probationary.ReassignPersonSearchCriteria();
            SearchCriteria.employeeId = '';
            SearchCriteria.employeeName = '';
            SearchCriteria.function = '';
            SearchCriteria.section = '';
            SearchCriteria.department = '';
            ESS_Probationary.ReassignPersons(SearchCriteria);
            ESS_Probationary.RecorrectProbationary(Probation.Id, 'Test');
            
        	PISUsers__c PISUser = [select id, user__c, employeeid__c, en_fullname__c, function__c, department__c, sections__c  from PISUsers__c where User__c = :runAsUser.Id order by name asc] ;
        	ESS_Probationary_DTO.ReassignPersonDTO ReassignPersonDTO = new ESS_Probationary_DTO.ReassignPersonDTO();    
            ReassignPersonDTO.userId = PISUser.User__c;
            ReassignPersonDTO.employeeId = PISUser.EMPLOYEEID__c;
            ReassignPersonDTO.employeeName = PISUser.EN_Fullname__c;
            ReassignPersonDTO.function = PISUser.FUNCTION__c;
            ReassignPersonDTO.department = PISUser.DEPARTMENT__c;
            ReassignPersonDTO.section = PISUser.SECTIONS__c;
            ReassignPersonDTO.comment = 'Comment';
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            update(Probation);
            ESS_Probationary.ReassignProbationary(Probation.Id, ReassignPersonDTO, Probation.Status__c);
            
            SearchCriteria = new ESS_Probationary.ReassignPersonSearchCriteria();
            SearchCriteria.employeeId = '00000001';
            SearchCriteria.employeeName = '';
            SearchCriteria.function = 'AAAA';
            SearchCriteria.section = 'BBBB';
            SearchCriteria.department = 'CCCC';
            ESS_Probationary.ReassignPersons(SearchCriteria);
            
            ESS_Probationary.ExportExcel();
            ESS_Probationary.SearchUsers('Test', '00000001');
            ESS_Probationary.ESSGlobal_GetFunctions();
            ESS_Probationary.ESSGlobal_GetDepartments(null);
            ESS_Probationary.ESSGlobal_GetSections(null);
            ESS_Probationary.ESSGlobal_GetUnits(null);
            ESS_Probationary.GetCEPs();
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            update(Probation);
            ESS_Probationary.ReassignProbationary(Probation.Id, ReassignPersonDTO, Probation.Status__c);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            update(Probation);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            ProbationDetail = ESS_Probationary.SaveProbationary(ProbationDetail);
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ProbationarySectionHeadTest() {
        
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
                            
            List<ESS_Probationary_DTO.ReassignDTO> reassigns = new List<ESS_Probationary_DTO.ReassignDTO>();
            ESS_Probationary_DTO.ReassignDTO reassign = new ESS_Probationary_DTO.ReassignDTO();
            reassign.name = 'Atittaya Tiao';
            reassign.position = 'MANAGER-ECONOMICS AND PLANNING';
            reassign.submittedDate = system.today();
            reassign.userId = runAsUser.Id;
            reassign.reassignedDate = date.today();
            reassigns.add(reassign);
            string reassignJSON = JSON.serialize(reassigns);
            ESS_Probationary.DeserializeReassigns(reassignJSON);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            Probation.quantity_of_work__c = ESS_Enum.ProbationSectionHeadQuantity.Learn.name();
            Probation.quality_of_work__c = ESS_Enum.ProbationSectionHeadQuality.Below.name();
            Probation.safety_awareness__c = ESS_Enum.ProbationSectionHeadSafety.Below.name();
            Probation.knowledge_skills__c = ESS_Enum.ProbationSectionHeadKnowledge.Insufficient.name();
            Probation.reliability__c = ESS_Enum.ProbationSectionHeadReliability.NeedSupervision.name();
            Probation.attitude__c = ESS_Enum.ProbationSectionHeadAttitude.LackDescipline.name();
            Probation.engineering_license__c = ESS_Enum.ProbationSectionHeadEngineering.AlreadyPossessed.name();
            Probation.recommendation__c = ESS_Enum.ProbationSectionHeadRecommendation.Confirm.name();
            Probation.probation_confirmation__c = ESS_Enum.ProbationSectionHeadRecommendation.Confirm.name();
            Probation.Probation_Status__c = ESS_Enum.ProbationStatus.TerminateEmployee.name();
            Probation.Reassign_Section_Head_JSON__c = reassignJSON;
            update(Probation);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            ProbationDetail.reassignSectionHeads = reassigns;
            ProbationDetail = ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            Probation.quantity_of_work__c = ESS_Enum.ProbationSectionHeadQuantity.Meet.name();
            Probation.quality_of_work__c = ESS_Enum.ProbationSectionHeadQuality.Meet.name();
            Probation.safety_awareness__c = ESS_Enum.ProbationSectionHeadSafety.Meet.name();
            Probation.knowledge_skills__c = ESS_Enum.ProbationSectionHeadKnowledge.Sufficient.name();
            Probation.reliability__c = ESS_Enum.ProbationSectionHeadReliability.OccasionalSupervision.name();
            Probation.attitude__c = ESS_Enum.ProbationSectionHeadAttitude.NeatAndObey.name();
            Probation.engineering_license__c = ESS_Enum.ProbationSectionHeadEngineering.NotYetPossessed.name();
            Probation.recommendation__c = ESS_Enum.ProbationSectionHeadRecommendation.Terminate.name();
            Probation.probation_confirmation__c = ESS_Enum.ProbationSectionHeadRecommendation.Terminate.name();
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            ProbationDetail.reassignDepartmentHeads = reassigns;
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            update(Probation);
            
            ProbationDetail = ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            Probation.quantity_of_work__c = ESS_Enum.ProbationSectionHeadQuantity.Better.name();
            Probation.quality_of_work__c = ESS_Enum.ProbationSectionHeadQuality.Better.name();
            Probation.safety_awareness__c = ESS_Enum.ProbationSectionHeadSafety.Better.name();
            Probation.knowledge_skills__c = ESS_Enum.ProbationSectionHeadKnowledge.SufficientBetter.name();
            Probation.reliability__c = ESS_Enum.ProbationSectionHeadReliability.WithoutSupervision.name();
            Probation.attitude__c = ESS_Enum.ProbationSectionHeadAttitude.WorkWell.name();
            Probation.Reassign_Department_Head_JSON__c = reassignJSON;
            update(Probation);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            ProbationDetail.reassignDepartmentHeads = reassigns;
            ProbationDetail = ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            
            Probation.Section_Head_Id__c = runAsUser.Id;
            update(Probation);
            
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Submitted.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Completed.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.UploadFailed.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ProbationaryStatusTest() {
        
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
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Probationary.GetProbationaryListsCount();
            List<ESS_Probationary_DTO.ProbationaryListDTO> ProbationaryList = ESS_Probationary.GetProbationaryLists(SortByParam, null);
            ESS_Probationary.MassSaveProbationary(ProbationaryList);
            ESS_Probationary.MassSubmitProbationary(ProbationaryList);
            ESS_Probationary.GetProbationaryApproveListsCount(false);
            ESS_Probationary.GetProbationaryApproveLists(false, SortByParam, null);
        	
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
                
            
            List<ESS_Probationary_DTO.ReassignDTO> reassigns = new List<ESS_Probationary_DTO.ReassignDTO>();
            ESS_Probationary_DTO.ReassignDTO reassign = new ESS_Probationary_DTO.ReassignDTO();
            reassign.name = 'Atittaya Tiao';
            reassign.position = 'MANAGER-ECONOMICS AND PLANNING';
            reassign.submittedDate = system.today();
            reassign.userId = runAsUser.Id;
            reassign.reassignedDate = date.today();
            reassigns.add(reassign);
            string reassignJSON = JSON.serialize(reassigns);
            ESS_Probationary.DeserializeReassigns(reassignJSON);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            Probation.quantity_of_work__c = ESS_Enum.ProbationSectionHeadQuantity.Learn.name();
            Probation.quality_of_work__c = ESS_Enum.ProbationSectionHeadQuality.Below.name();
            Probation.safety_awareness__c = ESS_Enum.ProbationSectionHeadSafety.Below.name();
            Probation.knowledge_skills__c = ESS_Enum.ProbationSectionHeadKnowledge.Insufficient.name();
            Probation.reliability__c = ESS_Enum.ProbationSectionHeadReliability.NeedSupervision.name();
            Probation.attitude__c = ESS_Enum.ProbationSectionHeadAttitude.LackDescipline.name();
            Probation.engineering_license__c = ESS_Enum.ProbationSectionHeadEngineering.AlreadyPossessed.name();
            Probation.recommendation__c = ESS_Enum.ProbationSectionHeadRecommendation.Confirm.name();
            Probation.probation_confirmation__c = ESS_Enum.ProbationSectionHeadRecommendation.Confirm.name();
            Probation.Probation_Status__c = ESS_Enum.ProbationStatus.TerminateEmployee.name();
            Probation.Reassign_Section_Head_JSON__c = reassignJSON;
            update(Probation);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForReassignedSectionHead.name();
            ProbationDetail.reassignSectionHeads = reassigns;
            ProbationDetail = ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            Probation.quantity_of_work__c = ESS_Enum.ProbationSectionHeadQuantity.Meet.name();
            Probation.quality_of_work__c = ESS_Enum.ProbationSectionHeadQuality.Meet.name();
            Probation.safety_awareness__c = ESS_Enum.ProbationSectionHeadSafety.Meet.name();
            Probation.knowledge_skills__c = ESS_Enum.ProbationSectionHeadKnowledge.Sufficient.name();
            Probation.reliability__c = ESS_Enum.ProbationSectionHeadReliability.OccasionalSupervision.name();
            Probation.attitude__c = ESS_Enum.ProbationSectionHeadAttitude.NeatAndObey.name();
            Probation.engineering_license__c = ESS_Enum.ProbationSectionHeadEngineering.NotYetPossessed.name();
            Probation.recommendation__c = ESS_Enum.ProbationSectionHeadRecommendation.Terminate.name();
            Probation.probation_confirmation__c = ESS_Enum.ProbationSectionHeadRecommendation.Terminate.name();
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            ProbationDetail.reassignDepartmentHeads = reassigns;
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalDepartmentHead.name();
            update(Probation);
            
            ProbationDetail = ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            Probation.quantity_of_work__c = ESS_Enum.ProbationSectionHeadQuantity.Better.name();
            Probation.quality_of_work__c = ESS_Enum.ProbationSectionHeadQuality.Better.name();
            Probation.safety_awareness__c = ESS_Enum.ProbationSectionHeadSafety.Better.name();
            Probation.knowledge_skills__c = ESS_Enum.ProbationSectionHeadKnowledge.SufficientBetter.name();
            Probation.reliability__c = ESS_Enum.ProbationSectionHeadReliability.WithoutSupervision.name();
            Probation.attitude__c = ESS_Enum.ProbationSectionHeadAttitude.WorkWell.name();
            Probation.Reassign_Department_Head_JSON__c = reassignJSON;
            update(Probation);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForReassignedDepartmentHead.name();
            ProbationDetail.reassignDepartmentHeads = reassigns;
            ProbationDetail = ESS_Probationary.SubmitProbationary(ProbationDetail, '');
            
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.UploadingToPersonalFolder.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Submitted.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Completed.name();
            ESS_Probationary.assignToProbationaryDetailDTO(Probation);
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            
            List<ESS_Probationary_DTO.ApprovalHistoryDTO> approvalHistories = new List<ESS_Probationary_DTO.ApprovalHistoryDTO>();
            ESS_Probationary_DTO.ApprovalHistoryDTO approvalHistory = new ESS_Probationary_DTO.ApprovalHistoryDTO();
            approvalHistory.name = 'Atittaya Tiao';
            approvalHistory.position = 'MANAGER-TECHNICAL COMPETENCT DEVELOPMENT';
            approvalHistory.approverRole = new ESS_Global.EnumValue('ApproverRole');
            approvalHistory.approverRole.key = ESS_Enum.ApproverRole.SectionHead.name();
            approvalHistory.approverRole.value = 'Immediate Line / Section Head';
            approvalHistory.submittedDate = system.today();
            approvalHistory.status = new ESS_Global.EnumValue('ProbationApproveStatus');
            approvalHistory.status.key = ESS_Enum.ProbationApproveStatus.Reassigned.name();
            approvalHistory.status.value = 'Reassigned';
            approvalHistory.comment = 'รบกวนประเมินใหม่';
            approvalHistories.add(approvalHistory);
            string approvalHisoryJSON = JSON.serialize(approvalHistories);
            ESS_Probationary.DeserializeHistoryWorkflows(approvalHisoryJSON);
            
            
            ESS_Probationary.ReassignPersonSearchCriteria SearchCriteria = new ESS_Probationary.ReassignPersonSearchCriteria();
            SearchCriteria.employeeId = '';
            SearchCriteria.employeeName = '';
            SearchCriteria.function = '';
            SearchCriteria.section = '';
            SearchCriteria.department = '';
            ESS_Probationary.ReassignPersons(SearchCriteria);
            ESS_Probationary.RecorrectProbationary(Probation.Id, 'Test');
            
        	PISUsers__c PISUser = [select id, user__c, employeeid__c, en_fullname__c, function__c, department__c, sections__c  from PISUsers__c where User__c = :runAsUser.Id order by name asc] ;
        	ESS_Probationary_DTO.ReassignPersonDTO ReassignPersonDTO = new ESS_Probationary_DTO.ReassignPersonDTO();    
            ReassignPersonDTO.userId = PISUser.User__c;
            ReassignPersonDTO.employeeId = PISUser.EMPLOYEEID__c;
            ReassignPersonDTO.employeeName = PISUser.EN_Fullname__c;
            ReassignPersonDTO.function = PISUser.FUNCTION__c;
            ReassignPersonDTO.department = PISUser.DEPARTMENT__c;
            ReassignPersonDTO.section = PISUser.SECTIONS__c;
            ReassignPersonDTO.comment = 'Comment';
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            update(Probation);
            ESS_Probationary.ReassignProbationary(Probation.Id, ReassignPersonDTO, Probation.Status__c);
            
            SearchCriteria = new ESS_Probationary.ReassignPersonSearchCriteria();
            SearchCriteria.employeeId = '00000001';
            SearchCriteria.employeeName = '';
            SearchCriteria.function = 'AAAA';
            SearchCriteria.section = 'BBBB';
            SearchCriteria.department = 'CCCC';
            ESS_Probationary.ReassignPersons(SearchCriteria);
            
            ESS_Probationary.ExportExcel();
            ESS_Probationary.SearchUsers('Test', '00000001');
            ESS_Probationary.ESSGlobal_GetFunctions();
            ESS_Probationary.ESSGlobal_GetDepartments(null);
            ESS_Probationary.ESSGlobal_GetSections(null);
            ESS_Probationary.ESSGlobal_GetUnits(null);
            ESS_Probationary.GetCEPs();
            
            ESS_Probationary.ESSService_PersonelFolder(Probation.Id, Probation.Id, '00000001');
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ProbationarySortByTest() {
        
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
            
            /* ESS_Probationary__c Probation = new ESS_Probationary__c();
            Probation.OwnerId = runAsUser.Id;
            Probation.Employee_ID__c = '00000001';
            Probation.section_head_id__c = runAsUser.Id;
            Probation.department_head_id__c = runAsUser.Id;
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Draft.name();
            insert(Probation); */
            
            ESS_Global.SortByParam SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = '';
            SortByParam.ascending = true;
            
            ESS_Probationary.GetProbationaryListsCount();
            List<ESS_Probationary_DTO.ProbationaryListDTO> ProbationaryList = ESS_Probationary.GetProbationaryLists(SortByParam, null);
            ESS_Probationary.MassSaveProbationary(ProbationaryList);
            ESS_Probationary.MassSubmitProbationary(ProbationaryList);
            ESS_Probationary.GetProbationaryApproveListsCount(true);
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	//ESS_Probationary.GetProbationaryDetail(null);
            
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
                
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'documentNo';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeId';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeId';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeName';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'employeeName';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateJoinedCompany';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateCompletedProbation';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'submittedDate';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'currentStatus';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'sectionHead';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'sectionHeadSubmittedDate';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'departmentHead';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'departmentHeadSubmittedDate';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'completedDate';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'probationStatus';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryApproveLists(true, SortByParam, null);
        	
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Draft.name();
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.Reassigned.name();
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            Probation.Status__c = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            Probation.Probation_Status__c = ESS_Enum.ProbationStatus.ConfirmedToRegularEmployee.name();
            ESS_Probationary.assignToProbationaryApproveListDTO(Probation);
            
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateStamp';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateStamp';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            
        }
        
        Test.stopTest();
        
    }
    
    @isTest
    public static void ProbationaryCustomSortByTest() {
        
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
                                            Reassign_Section_Head_Id__c, Reassign_Department_Head_Id__c, Probation_Status__c, CEP_Confirmation__c from ESS_Probationary__c];
        
            
            ESS_Probationary_DTO.ProbationaryDetailDTO ProbationDetail = ESS_Probationary.GetProbationaryDetail(Probation.Id);
            ProbationDetail.currentStatus = new ESS_Global.EnumValue('ProbationApproveStatus');
            ProbationDetail.currentStatus.key = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail.currentStatus.value = ESS_Enum.ProbationApproveStatus.WaitingForApprovalSectionHead.name();
            ProbationDetail = ESS_Probationary.SaveProbationary(ProbationDetail);
            ESS_Probationary.SubmitProbationary(ProbationDetail, '');
                
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'level';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'level';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateJoinedCompany';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateJoinedCompany';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateCompletedProbation';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'dateCompletedProbation';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'sectionHead';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'sectionHead';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'departmentHead';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'departmentHead';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'cep';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'cep';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'function';
            SortByParam.ascending = false;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'function';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            SortByParam = new ESS_Global.SortByParam();
            SortByParam.sortBy = 'unit';
            SortByParam.ascending = true;
            ESS_Probationary.GetProbationaryLists(SortByParam, null);
            
            ESS_Probationary.ProbationaryListSortDTO ProbationaryListSortDTO = new ESS_Probationary.ProbationaryListSortDTO();
            ProbationaryListSortDTO.sortByDateStamp(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByDateStampDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByEmployeeId(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByEmployeeIdDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByEmployeeName(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByEmployeeNameDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByLevel(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByLevelDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByDateJoinedCompany(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByDateJoinedCompanyDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByDateCompletedProbation(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByDateCompletedProbationDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortBySectionHeadName(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortBySectionHeadNameDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByDepartmentHeadName(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByDepartmentHeadNameDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByCEP(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByCEPDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByFunction(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByFunctionDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByDepartment(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByDepartmentDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortBySection(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortBySectionDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByUnit(ProbationaryListSortDTO);
            ProbationaryListSortDTO.sortByUnitDesc(ProbationaryListSortDTO);
            ProbationaryListSortDTO.compareTo(ProbationaryListSortDTO);
            
            List<ESS_Probationary.ProbationaryListSortDTO> sorts = new List<ESS_Probationary.ProbationaryListSortDTO>();
            sorts.add(ProbationaryListSortDTO);
            ESS_Probationary.sortByEmployeeName(sorts);
            ESS_Probationary.sortByDepartment(sorts);
            ESS_Probationary.sortBySection(sorts);
            ESS_Probationary.sortByUnit(sorts);
            
            Master.Probation_Completed__c = false;
            update(Master);
            ESS_Probationary.ProbationCompletedFlagScript();
            
        }
        
        Test.stopTest();
        
    }
    
}