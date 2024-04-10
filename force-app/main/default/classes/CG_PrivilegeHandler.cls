public class CG_PrivilegeHandler {

    public static string getUserId() {
        return UserInfo.getUserId();
    }
    
    public static string getUserProfile() {
        string userProfile = '';
        
        Id profileId = UserInfo.getProfileId();
		userProfile = [Select Id,Name from Profile where Id =: profileId].Name;
        
        if(userProfile == 'ผู้ดูแลระบบ' || userProfile == 'System Administrator') {
            userProfile = String.ValueOf(CG_Enum.ApproverRole.SuperAdmin);
            return userProfile;
        }
        
        boolean isUserAsApprover = findUserAsApprover();
        if(isUserAsApprover) { userProfile = 'Approver'; }
        
        boolean isUserAsAdmin = findUserAsAdmin();
        if(isUserAsAdmin) { userProfile = 'Admin'; }
        
        if(!isUserAsApprover && !isUserAsAdmin) {
            userProfile = String.ValueOf(CG_Enum.ApproverRole.Employee);
        }
        
        //Supervisor
        boolean isUserAsSupervisor = findUserAsSupervisor();
        if(isUserAsSupervisor) { userProfile = String.ValueOf(CG_Enum.ApproverRole.Supervisor); }
        
        //GLVP
        boolean isUserAsGLVP = findUserAsGLVP();
        if(isUserAsGLVP) { userProfile = String.ValueOf(CG_Enum.ApproverRole.GLVP); }
        
        //GLGC
        boolean isUserAsGLGC = findUserAsGLGC();
        if(isUserAsGLGC) { userProfile = String.ValueOf(CG_Enum.ApproverRole.GLGC); }
        
        return userProfile;
    }

    public static boolean checkAccessPrivilege(string recordId) {
        
        boolean canAccess = true;
        Id userId = UserInfo.getUserId();
        
        CG_Reporting__c CGReport = [select id, ownerId, User__c, Status__c, Type_Of_Report__c from CG_Reporting__c where Id =: recordId];
        
        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingForSubmit) ||
          	CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success) ||
          	CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Cancel) || 
          	CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Rejected)) {
            if(userId != CGReport.OwnerId) canAccess = false; 
                
        }
        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingSupervisor)) {
            if(userId != CGReport.User__c) canAccess = false;
        }
        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLVP)) {
            boolean isGLVPUser = findUserAsGLVP();
            if(!isGLVPUser) canAccess = false;
        }
        else if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.WaitingGLGC)) {
            boolean isGLGCUser = findUserAsGLGC();
            if(!isGLGCUser) canAccess = false;
        }
        
        //GLGC Access when Gift status Success
        if(CGReport.Status__c == String.ValueOf(CG_Enum.ReportStatus.Success) && CGReport.Type_Of_Report__c == 'GiftRegistration') {
            boolean isGLGCUser = findUserAsGLGC();
            canAccess = isGLGCUser;
        }
        
        if(userId == CGReport.OwnerId) {
            canAccess = true;
        }
        
        if(!canAccess) {
            //Give Access to Admin
            canAccess = findUserAsAdmin();  
        }
        
        return canAccess;
        
    }
    
    public static string findLineManager(string userId) {
        
        PISUsers__c PISUser = [select id, User__c, LineManagerUser__c, LineManagerEmail__c from PISUsers__c where User__c =: userId AND Mainposition__c = true];
        
        return PISUser.LineManagerUser__c;
        
    }
    
    public static boolean findUserAsApprover() {
        
        boolean isUserAsApprover = false;
        Set<Id> UserIds = new Set<Id>();
        
        Id userId = getUserId();
        
        //Find 
        List<PISUsers__c> PISUsers = [select id, User__c, LineManagerUser__c, LineManagerEmail__c from PISUsers__c where LineManagerUser__c =: userId AND Mainposition__c = true];
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                if(!string.isBlank(PISUser.User__c)) {
                    UserIds.add(PISUser.User__c);
                }
            }
        }
        
        if(UserIds.size() > 0) {
            List<CG_Reporting__c> CGReports = [select id, OwnerId, User__c from CG_Reporting__c where User__c IN: UserIds];
            if(CGReports.size() > 0) {
                isUserAsApprover = true;
            }
        }
        
        return isUserAsApprover;
    }
    
    public static boolean findUserAsSupervisor() {
        
        boolean isUserAsSupervisor = false;
        Id userId = getUserId();
        
        //Find from CG Reporting
        List<CG_Reporting__c> CGReports = [select id, user__c, status__c from CG_Reporting__c where user__c =: userId];
        
        if(CGReports.size() > 0) {
            isUserAsSupervisor = true;
        }
        
        return isUserAsSupervisor;
    }
    
    public static boolean findUserAsAdmin() {
        
        boolean isUserAsAdmin = false;
        Id userId = getUserId();
        
        //Find from Group Admin
        Group ApproverGroup = [select id, developername from Group where developername =: 'CG_Admin'];
        List<GroupMember> ApproverUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: ApproverGroup.Id AND UserOrGroupId =: userId];
        
        if(ApproverUsers.size() > 0) {
            isUserAsAdmin = true;
        }
        
        return isUserAsAdmin;
    }
    
    public static boolean findUserAsGLGC() {
        
        boolean isUserAsGLGC = false;
        Id userId = getUserId();
        
        //Find from Group GLGC
        Group GLGCGroup = [select id, developername from Group where developername =: 'CG_GLGC'];
        List<GroupMember> GLGCUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GLGCGroup.Id AND UserOrGroupId =: userId];
        
        if(GLGCUsers.size() > 0) {
            isUserAsGLGC = true;
        }
        
        return isUserAsGLGC;
    }
    
    public static boolean findUserAsGLVP() {
        
        boolean isUserAsGLVP = false;
        Id userId = getUserId();
        
        //Find from Group GLVP
        Group GLVPGroup = [select id, developername from Group where developername =: 'CG_GLVP'];
        List<GroupMember> GLVPUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GLVPGroup.Id AND UserOrGroupId =: userId];
        
        if(GLVPUsers.size() > 0) {
            isUserAsGLVP = true;
        }
        
        return isUserAsGLVP;
    }
    
}