public with sharing class CG_Global {

    //get all companies
    @RemoteAction
    public static List<CG_DTO.CompanyDTO> GetCompanies(){
        
        List<CG_DTO.CompanyDTO> results = new List<CG_DTO.CompanyDTO>();
        
        List<PISUsers__c> PISUsers = [select companycode__c, companyname__c, home_comp__c from PISUsers__c];
        Set<string> CompanyNames = new Set<string>();
        
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                CompanyNames.add(PISUser.COMPANYNAME__c);
            }
        }
        
        if(CompanyNames.size() > 0) {
            integer count = 1;
            for(string CompanyName : CompanyNames) {
                CG_DTO.CompanyDTO company = new CG_DTO.CompanyDTO();
		        company.id = CompanyName;
                company.name = CompanyName;
                company.fullname = CompanyName;
                results.add(company);
                count++;
            }
        }
        
        return results;
    }

    //get functions
    @RemoteAction
    public static List<string> GetFunctions(string companyId){
        
        List<string> results = new List<string>();
        
        List<AggregateResult> Functions = new List<AggregateResult>();
        
        if(companyId == 'TOP') {
            string companyCode = '1100';
        	Functions = [select function__c from PISUsers__c where HOME_COMP__c =: companyCode AND function__c != '' group by function__c order by function__c asc];
        }
        else if(companyId == 'TES') {
            string companyCode = '1600';
        	Functions = [select function__c from PISUsers__c where HOME_COMP__c =: companyCode AND function__c != '' group by function__c order by function__c asc];
        }
        else {
            Functions = [select function__c from PISUsers__c where function__c != '' group by function__c order by function__c asc];
        }
        
        if(Functions.size() > 0) {
            for(AggregateResult Function : Functions) {
                results.add(Function.get('function__c').toString());
            }
        }
        
        return results;
    }

    //get departments
    @RemoteAction
    public static List<string> GetDepartments(string function){
        
        List<string> results = new List<string>();
        List<AggregateResult> Departments = new List<AggregateResult>(); 
        
        if(function != null) {
            Departments = [select department__c from PISUsers__c where department__c != '' AND function__c =: function group by department__c order by department__c asc];
        }
        else {
            Departments = [select department__c from PISUsers__c where department__c != '' group by department__c order by department__c asc];
        }
        
        if(Departments.size() > 0) {
            for(AggregateResult Department : Departments) {
                results.add(Department.get('department__c').toString());
            }
        }
        
        return results;
    }

    //get sections
    @RemoteAction
    public static List<string> GetSections(string department){
        
        List<string> results = new List<string>();
        List<AggregateResult> Sections = new List<AggregateResult>();
         
        if(department != null) {
            Sections = [select sections__c from PISUsers__c where sections__c != '' AND department__c =: department group by sections__c order by sections__c asc];
        }
        else {
            Sections = [select sections__c from PISUsers__c where sections__c != '' group by sections__c order by sections__c asc];
        }
        
        if(Sections.size() > 0) {
            for(AggregateResult Section : Sections) {
                results.add(Section.get('sections__c').toString());
            }
        }
        
        return results;
    }

    //get units
    @RemoteAction
    public static List<string> GetUnits(string section){
        
        List<string> results = new List<string>();
        List<AggregateResult> Units = new List<AggregateResult>();
        
        if(section != null) {
            Units = [select units__c from PISUsers__c where units__c != '' AND sections__c =: section group by units__c order by units__c asc];
        }
        else {
            Units = [select units__c from PISUsers__c where units__c != '' group by units__c order by units__c asc];
        }
        
        if(Units.size() > 0) {
            for(AggregateResult Unit : Units) {
                results.add(Unit.get('units__c').toString());
            }
        }
        
        return results;
    }
    
    //Assign Supervisor
    public static Id AssignSupervisor(PISUsers__c PISUser) {

		Id supervisorId;
        
        if(PISUser.Level__c == 'VP' || PISUser.LEVEL__c == 'EVP Upward') {
            
            if(!string.isEmpty(PISUser.ReportToUser__c)) {
                supervisorId = PISUser.ReportToUser__c;
            }
            else {
            	supervisorId = PISUser.LineManagerUser__c;
            }

        }
        else {
            supervisorId = PISUser.LineManagerUser__c;
        }
        System.debug(supervisorId);
        return supervisorId;
    }

    //Assign User to UserDTO
    public static CG_DTO.UserDTO assignToUserDTO(string userId) {
        System.debug(userId);
        PISUsers__c PISUser = [select id, User__c, EN_Fullname__c, Email__c from PISUsers__c where User__c =: userId AND Mainposition__c = true AND Active__c = true];
        CG_DTO.UserDTO UserDTO = new CG_DTO.UserDTO();
        UserDTO.id = PISUser.User__c;
        UserDTO.fullName = PISUser.EN_Fullname__c ;
        UserDTO.email = PISUser.Email__c;
        return UserDTO;
        
    }
    
    //Assign All PIS User to Map
    public static Map<string,PISUsers__c> assignAllToMapPISUsers() {
        Map<string,PISUsers__c> mapPISUsers = new Map<string,PISUsers__c>();
        
        List<PISUsers__c> PISUsers = [select id, User__c, EN_Fullname__c, ENFIRSTNAME__c, ENLASTNAME__c, Email__c, COMPANYNAME_HOST__c from PISUsers__c where User__c != null AND Mainposition__c = true AND Active__c = true];
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                mapPISUsers.put(PISUser.User__c, PISUser);
            }
        }
        return mapPISUsers;
        
    }
    
    //Assign All User to UserDTO
    public static Map<string,CG_DTO.UserDTO> assignAllToUserDTO() {
        Map<string,CG_DTO.UserDTO> userDTOs = new Map<string,CG_DTO.UserDTO>();
        
        List<PISUsers__c> PISUsers = [select id, User__c, EN_Fullname__c, Email__c from PISUsers__c where User__c != null AND Mainposition__c = true AND Active__c = true];
        if(PISUsers.size() > 0) {
            for(PISUsers__c PISUser : PISUsers) {
                CG_DTO.UserDTO UserDTO = new CG_DTO.UserDTO();
                UserDTO.id = PISUser.User__c;
                UserDTO.fullName = PISUser.EN_Fullname__c ;
                UserDTO.email = PISUser.Email__c;
                
                userDTOs.put(PISUser.User__c, UserDTO);
            }
        }
        return UserDTOs;
        
    }
    
    //Assign All User 
    public static Map<string,User> assignAllToUsers() {
        Map<string,User> users = new Map<string,User>();
        List<User> allUsers = [select id, name, position__c, section__c from User];
        if(allUsers.size() > 0) {
            for(User User : allUsers) {
                users.put(User.Id, User);
            }
        }
        return users;
        
    }
    
    //Assign user to PISUser
    public static PISUsers__c assignToPISUser(string userId) {
        
        PISUsers__c PISUser = [select id, User__c, EMPLOYEEID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYNAME_HOST__c, EN_Fullname__c, LineManagerUser__c, LineManagerEmail__c, COMPANYCODE__c, HOME_COMP__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c from PISUsers__c where User__c =: userId AND Active__c = true AND Mainposition__c = true];
        
        if(string.isBlank(PISUser.COMPANYNAME__c)) {
            PISUser.COMPANYNAME__c = convertCodeToCompanyName(PISUser.HOME_COMP__c);
        }
        
        return PISUser;
        
    }
    
    //Assign GLVP PIS User
    public static List<PISUsers__c> assignToGLVPPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group GLVP
        Group GLVPGroup = [select id, developername from Group where developername =: 'CG_GLVP'];
        List<GroupMember> GLVPUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GLVPGroup.Id];
        
            if(GLVPUsers.size() > 0) {
                for(GroupMember GLVPUser : GLVPUsers) {
                    Id GLVPUserId = GLVPUser.userorgroupid;
                    
                    if(!Test.isRunningTest()) {
                        PISUsers__c PISUser = [select id, User__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                                OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, HOME_COMP__c, EN_Fullname__c from PISUsers__c 
                                                where User__c =: GLVPUserId AND Active__c = true AND Mainposition__c = true];
                    
                        if(string.isBlank(PISUser.COMPANYNAME__c)) {
                            PISUser.COMPANYNAME__c = convertCodeToCompanyName(PISUser.HOME_COMP__c);
                        }
                        
                        PISUsers.add(PISUser);
                    }
                }
                
                return PISUsers;
            }
        //}
        
        return PISUsers;
        
    }
    
    //Assign GLGC PIS User
    public static List<PISUsers__c> assignToGLGCPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group GLGC
        Group GLGCGroup = [select id, developername from Group where developername =: 'CG_GLGC'];
        List<GroupMember> GLGCUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: GLGCGroup.Id];
        
        if(GLGCUsers.size() > 0) {
            
            for(GroupMember GLGCUser : GLGCUsers) {
                
                Id GLGCUserId = GLGCUser.userorgroupid;
                
                if(!Test.isRunningTest()) {
                    PISUsers__c PISUser = [select id, User__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, HOME_COMP__c, EN_Fullname__c from PISUsers__c 
                                           where User__c =: GLGCUserId AND Active__c = true AND Mainposition__c = true];
                    
                    if(string.isBlank(PISUser.COMPANYNAME__c)) {
                        PISUser.COMPANYNAME__c = convertCodeToCompanyName(PISUser.HOME_COMP__c);
                    }
                    
                    PISUsers.add(PISUser);
                }
            }
            
            return PISUsers;
        }
        
        
        return null;
        
    }
    
    public static string convertCodeToCompanyName(string code) {
        if(code == '1100') {
            return 'TOP';
        }
        else if(code == '1600') {
            return 'TES';
        }
        return null;
    }
    
    public class PageParam {
        @RemoteAction
        public Integer pageNo {get;set;}
        @RemoteAction
        public Integer pageSize {get; set;}
    }

    public class SortByParam{
        @RemoteAction
        public string sortBy {get;set;}
        @RemoteAction
        public Boolean ascending {get;set;}
    }

    public class EnumValue {
        public EnumValue(){
            
        }
        public EnumValue(string enumName){
            this.enumName = enumName;
        }
        @RemoteAction
        public string enumName {get;set;}
        @RemoteAction
        public string key {get;set;}
        @RemoteAction
        public string value {get;set;}
    }
}