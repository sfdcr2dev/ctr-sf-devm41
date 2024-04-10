@isTest
public class CG_Global_Test {

    public static testMethod void CGGlobalTest() {
        
        //SD_Company__c Company = new SD_Company__c();
        //Company.Name = 'TOP';
        //Company.Company_Full_Name__c = 'TOP';
        //insert(Company);
        
        //CG_Global.GetCompanies();
        
        User testUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Non Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com.icr',
            CompanyName = 'TOP',
            Alias = 'test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(testUser);
        
        PISUsers__c thaninthon = new PISUsers__c();
        thaninthon.Active__c = true;
        thaninthon.MAINPOSITION__c = true;
        thaninthon.EMPLOYEEID__c = '08000288';
        thaninthon.COMPANYCODE__c = '1100';
        thaninthon.COMPANYNAME__c = 'TOP';
        thaninthon.Name = 'Test';
        thaninthon.LEVEL__c = 'VP';
        thaninthon.ORGID__c = '00000818';
        thaninthon.POSID__c = '00000544';
        thaninthon.ENFIRSTNAME__c = 'Test';
        thaninthon.ENLASTNAME__c = 'Test';
        thaninthon.HOLDERPOSITION__c = '00000544';
        thaninthon.EMAIL__c = 'test@thaioilgroup.com';
        thaninthon.User__c = testUser.Id;
        thaninthon.ReportToPOS__c = '00001365';
        thaninthon.ReportToID__c = '00000598';
        thaninthon.ReportToEmail__c = 'test@thaioilgroup.com';
        thaninthon.ReportToUser__c = testUser.Id;
        thaninthon.Subcordinate__c = '["08000288"]';
        thaninthon.LineManagerUser__c = testUser.Id;
        thaninthon.FUNCTION__c = 'EVPC';
        thaninthon.DEPARTMENT__c = 'EVPO';
        thaninthon.SECTIONS__c = 'SCSE';
        thaninthon.UNITS__c = 'ABCD';
        insert(thaninthon);
        
        PISUsers__c vatchara = new PISUsers__c();
        vatchara.EMPLOYEEID__c = '00000598';
        vatchara.Name = 'VATCHARA';
        vatchara.LEVEL__c = 'Senior';
        vatchara.ORGID__c = '00000815';
        vatchara.POSID__c = '00001365';
        vatchara.ENFIRSTNAME__c = 'Vatchara';
        vatchara.ENLASTNAME__c = 'Sirijan';
        vatchara.HOLDERPOSITION__c = '00001365';
        vatchara.EMAIL__c = 'vatchara@thaioilgroup.com';
        vatchara.User__c = testUser.Id;
        vatchara.ReportToPOS__c = '00001348';
        vatchara.ReportToID__c = '00000506';
        vatchara.ReportToEmail__c = 'chaiyar@thaioilgroup.com';
        vatchara.LineManagerUser__c = testUser.Id;
        insert(vatchara);
        
        //InsertUserToGroup(testUser.Id);
        
        Test.startTest();
        
        system.runAs(testUser) {
            CG_Global.GetCompanies();
            CG_Global.GetFunctions(null);
            CG_Global.GetDepartments(null);
            CG_Global.GetSections(null);
            CG_Global.GetUnits(null);
            CG_Global.AssignSupervisor(thaninthon);
            CG_Global.AssignSupervisor(vatchara);
            CG_Global.assignToUserDTO(testUser.Id);
            CG_Global.assignToPISUser(testUser.Id);
            CG_Global.assignToGLVPPISUser();
            CG_Global.assignToGLGCPISUser();
            CG_Global.assignAllToMapPISUsers();
            CG_Global.assignAllToUserDTO();
            
            CG_Global.PageParam PageParam = new CG_Global.PageParam();
            PageParam.pageNo = 1;
            PageParam.pageSize = 1;
            
            CG_Global.SortByParam SortByParam = new CG_Global.SortByParam();
            SortByParam.sortBy = 'reportNumber';
            SortByParam.ascending = true;
            
            CG_Global.EnumValue EnumValue = new CG_Global.EnumValue();
            EnumValue.enumName = 'Test';
            EnumValue.key = 'Test';
            EnumValue.value = 'Test';
            
            CG_Global.convertCodeToCompanyName('1100');
            CG_Global.convertCodeToCompanyName('1600');
        }
        
		Test.stopTest();
    }
    
    private static void InsertUserToGroup(string userId)
    {
        //CG Admin
        Group approverAdminGroup = [select id from Group where developername = 'CG_Admin'];
        GroupMember memberAdmin = new GroupMember();
        memberAdmin.UserOrGroupId = userId;
        memberAdmin.GroupId = approverAdminGroup.Id;
        insert(memberAdmin);
        
        //CG GLVP
        Group approverGLVPGroup = [select id from Group where developername = 'CG_GLVP'];
        GroupMember memberGLVP = new GroupMember();
        memberGLVP.UserOrGroupId = userId;
        memberGLVP.GroupId = approverGLVPGroup.Id;
        insert(memberGLVP);
        
        //CG GLGC
        Group approverGLGCGroup = [select id from Group where developername = 'CG_GLGC'];
        GroupMember memberGLGC = new GroupMember();
        memberGLGC.UserOrGroupId = userId;
        memberGLGC.GroupId = approverGLGCGroup.Id;
        insert(memberGLGC);
    }
    
}