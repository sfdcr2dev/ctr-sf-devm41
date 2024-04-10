/* Author Softever */
public with sharing class ESS_Global {

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
    
    public static datetime convertDateTimeFromJSON(datetime dt) {
        datetime convertedDT = dt.addHours(7);
        return convertedDT;
    }
    
    public static datetime convertDateTimeForExcel(datetime dt) {
        datetime convertedDT = dt.addHours(7);
        return convertedDT;
    }
    
    public static datetime convertDateTimeFilter(datetime dt) {
        datetime convertedDT = dt.addHours(7);
        return convertedDT;
    }
    
    public static date convertDateFilter(datetime dt) {
        date convertedDate = dt.date();
        return convertedDate;
    }
    
    public static date convertDateTimeToDateWithTime(datetime dt) {
        date convertedDate = dt.addHours(7).date();
        return convertedDate;
    }
    
    public static datetime convertExcelStartDateTimeFilter(datetime dt) {
        datetime convertedDT = dt;
        return convertedDT;
        
    }
    public static datetime convertExcelEndDateTimeFilter(datetime dt) {
        datetime convertedDT = dt.addDays(1);
        return convertedDT;
        
    }

    public static User getByUsername(string username) {
        User user = [SELECT Id FROM User WHERE Username = :username];
        return user;
    }
    
    //Check user exist in PISUser for PRTR user
    public static boolean checkPRTRUser(string userId) {
    	boolean isPRTRUser = true;
        List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where User__c =: userId AND Active__c = true AND Mainposition__c = true];
        if(PISUsers.size() > 0) { isPRTRUser = false; }
        return isPRTRUser;
    }
    
    //Assign user to User for PRTR user
    public static User assignToUser(string userId) {
        User existUser = [select id, name, firstname, lastname, firstname_en__c, lastname_en__c, firstname_th__c, lastname_th__c, employee_id__c, position__c, unit__c, section__c, function__c, email, department from User where Id = :userId];
        return existUser;
    }
    
    //Assign user to PISUser
    public static PISUsers__c assignToPISUser(string userId) {
        
        PISUsers__c PISUser = [select id, User__c, HOST_ID__c, EMPLOYEEID__c, Level__c, ReportToUser__c, ReportToID__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, HOME_COMP__c, DeptFullTH__c, DeptFullEN__c, Retirement_Selection__c, Hotel_Privilege__c,
                               SectHeadUpPosID__c, ReportToName__c, ReportToEmail__c, PERSUBAREA__c from PISUsers__c where User__c =: userId AND Active__c = true AND Mainposition__c = true];
        
        PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
        return PISUser;
        
    }
    
    //Assign user to PISUser
    public static PISUsers__c assignToPISUserFromEmployeeId(string employeeId) {
        
        PISUsers__c PISUser = [select id, User__c, HOST_ID__c, EMPLOYEEID__c, Level__c, ReportToUser__c, ReportToID__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, HOME_COMP__c, DeptFullTH__c, DeptFullEN__c, Hotel_Privilege__c,
                               SectHeadUpPosID__c, ReportToName__c, PERSUBAREA__c from PISUsers__c where EMPLOYEEID__c = :employeeId AND User__c != null AND Active__c = true AND Mainposition__c = true];
        
        PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
        return PISUser;
    }
    
    public static List<PISUsers__c> findingUserManagerAndCC(string userId) {
        
        Map<string, PISUsers__c> mapUsers = new Map<string, PISUsers__c>();
        
        string query = 'select id, User__c, HOST_ID__c, EMPLOYEEID__c, Level__c, ReportToUser__c, ReportToID__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c, ' +
                           'OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c, ' +
                           'EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, HOME_COMP__c, DeptFullTH__c, DeptFullEN__c, Retirement_Selection__c, Hotel_Privilege__c, ' +
                           'SectHeadUpPosID__c, ReportToName__c, ReportToEmail__c from PISUsers__c where Active__c = true AND Mainposition__c = true';
        
        string ccQuery = query;
        
        List<PISUsers__c> userManagerCCs = new List<PISUsers__c>();
        
        PISUsers__c UserManager = new PISUsers__c();
        PISUsers__c PISUser = new PISUsers__c();
        PISUsers__c CC = new PISUsers__c();
        PISUser = assignToPISUser(userId);
        
        List<PISUsers__c> PISUsers = database.query(query);
        if(PISUsers.size() > 0) {
            for(PISUsers__c PIS : PISUsers) {
                mapUsers.put(PIS.User__c, PIS);
            }
        }
        string reportToUserId = PISUser.ReportToUser__c;
        string currentUserId = PISUser.User__c;
        if(PISUser.LEVEL__c != 'Section Head' && PISUser.LEVEL__c != 'VP' && PISUser.LEVEL__c != 'EVP Upward') {
            boolean isSectionHeadFound = false;
        	integer levelCount = 1;
            do {
                UserManager = mapUsers.get(reportToUserId);
                if(UserManager.LEVEL__c == 'Section Head' || UserManager.LEVEL__c == 'VP' || UserManager.LEVEL__c == 'EVP Upward') {
                    isSectionHeadFound = true;
                    userManagerCCs.add(UserManager);
                    if(levelCount > 1) {
                		CC = mapUsers.get(currentUserId);
                        userManagerCCs.add(CC);
                    }
                }
                else {
                    reportToUserId = UserManager.ReportToUser__c;
                    currentUserId = UserManager.User__c;
                	levelCount++;
                }
                
            }while(!isSectionHeadFound);
        }
        else {
            UserManager = mapUsers.get(reportToUserId);
            userManagerCCs.add(UserManager);
        }
        
        return userManagerCCs;
    }

    public static PISUsers__c findingCC(string userId) {
        
        string query = 'select id, User__c, HOST_ID__c, EMPLOYEEID__c, Level__c, ReportToUser__c, ReportToID__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c, ' +
                           'OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, TH_Fullname__c, LineManagerUser__c, LineManagerEmail__c, ' +
                           'EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c, COMPANYCODE__c, HOME_COMP__c, DeptFullTH__c, DeptFullEN__c, Retirement_Selection__c, Hotel_Privilege__c, ' +
                           'SectHeadUpPosID__c, ReportToName__c, ReportToEmail__c from PISUsers__c where Active__c = true AND Mainposition__c = true';
        
        string ccQuery = query;
        
        PISUsers__c UserManager = new PISUsers__c();
        PISUsers__c CC = new PISUsers__c();
        PISUsers__c PISUser = new PISUsers__c();
        PISUser = assignToPISUser(userId);
        
        List<PISUsers__c> PISUsers = database.query(query);
        
        string reportToUserId = PISUser.ReportToUser__c;
        string currentUserId = PISUser.User__c;
        if(PISUser.LEVEL__c != 'Section Head' && PISUser.LEVEL__c != 'VP' && PISUser.LEVEL__c != 'EVP Upward') {
            boolean isSectionHeadFound = false;
        	integer count = 1;
            do {
                query += ' AND User__c = :reportToUserId';
                UserManager = database.query(query);
                system.debug(count);
                if(UserManager.LEVEL__c == 'Section Head') {
                    isSectionHeadFound = true;
                    if(count > 1) {
                        ccQuery += ' AND User__c = :currentUserId';
                		CC = database.query(ccQuery);
                    }
                }
                else {
                    reportToUserId = UserManager.ReportToUser__c;
                    currentUserId = UserManager.User__c;
                	count++;
                }
                
            }while(!isSectionHeadFound);
        }
        
        return CC;
    }
        
    //Get Employee Detail
    public static ESS_Master_Employee__c getMasterEmployee(string employeeId) {
        ESS_Master_Employee__c employee = [select id, employee_id__c, employee_dob__c, employee_date_joined__c, employee_retirement_date__c, probation_completed__c from ESS_Master_Employee__c where Employee_Id__c =: employeeId AND Data__c = 'IN'];
        return employee;
    }
    
    //Assign EmployeeBasic Admin
    public static List<PISUsers__c> assignToPersonelAdminPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group GLVP
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_Personel_Admin'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    public static List<User> assignToPersonelAdminUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_Personel_Admin'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            return Users;
        }
        return Users;
    }
    
    //Assign Letter Admin
    public static List<PISUsers__c> assignToLetterAdminPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Letter Admin
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_Recommendation_Letter_Admin'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    public static List<User> assignToLetterAdminUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_Recommendation_Letter_Admin'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            return Users;
        }
        return Users;
    }
    
    //Assign Probation Admin
    public static List<PISUsers__c> assignToProbationAdminPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Probation Admin
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_Probation_Admin'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            
            return PISUsers;
        }
        
        return PISUsers;
        
    }
    
    public static List<User> assignToProbationAdminUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_Probation_Admin'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            return Users;
        }
        return Users;
    }
    
    //Assign Retirement Admin
    public static List<PISUsers__c> assignToRetirementAdminPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Retirement Admin
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_Retirement_Admin'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
				PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }

    public static List<User> assignToRetirementAdminUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_Retirement_Admin'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            return Users;
        }
        return Users;
    }
    
    //Assign PMBP Admin
    public static List<PISUsers__c> assignToPMBPAdminPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Retirement Admin
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_PMBP_Admin'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }

    public static List<User> assignToPMBPAdminUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMBP_Admin'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            return Users;
        }
        return Users;
    }

    //Assign PEOC Admin
    public static List<PISUsers__c> assignToPEOCAdminPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Retirement Admin
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_PEOC_Admin'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }

    public static List<User> assignToPEOCAdminUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS PEOC Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PEOC_Admin'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            return Users;
        }
        return Users;
    }

    public static boolean isPMBPAdmin(string userId){
        List<PISUsers__c> pisUsers = assignToPMBPAdminPISUser();
        for (PISUsers__c user : pisUsers) {
            if(user.User__c == userId){
                return true;
            }
        }
        return false;
    }

    public static boolean isPEOCAdmin(string userId){
        List<PISUsers__c> pisUsers = assignToPEOCAdminPISUser();
        for (PISUsers__c user : pisUsers) {
            if(user.User__c == userId){
                return true;
            }
        }
        return false;
    }

    public static List<PISUsers__c> assignToPMSVFixAndGeneralAdminPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Retirement Admin
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_FixAndGeneral'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }

    public static List<PISUsers__c> assignToPMSVTransportationAdminPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Retirement Admin
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Transportation'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }

    public static List<PISUsers__c> assignToPMSVAdminPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Retirement Admin
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    //Assign Related
    public static List<PISUsers__c> assignToRelatedPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Retirement Admin
        Group PersonelAdminGroup = [select id, developername from Group where developername =: 'ESS_Related'];
        List<GroupMember> PersonelAdminUsers = [select id, groupid, userorgroupid from GroupMember where GroupId =: PersonelAdminGroup.Id];
        
        if(PersonelAdminUsers.size() > 0) {
            
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember PersonelAdmin : PersonelAdminUsers) {
                Id PersonelAdminUserId = PersonelAdmin.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(PersonelAdminUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    public static List<User> assignToRelatedUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS Related Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_Related'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            return Users;
        }
        return Users;
    }
    
    //Assign PMSV Admin
    public static List<PISUsers__c> assignToESSPMSVPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    public static List<User> assignToESSPMSVUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS PMSV Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            return Users;
        }
        return Users;
    }
    
    //Assign FixAndGeneral Admin
    public static List<PISUsers__c> assignToESSPMSVFixAndGeneralPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Retirement Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_FixAndGeneral'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    public static List<User> assignToESSPMSVFixAndGeneralUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS PMSV Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_FixAndGeneral'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            
            return Users;
        }
        
        return Users;
        
    }
    
    //Assign Transportation Admin
    public static List<PISUsers__c> assignToESSPMSVTransportationPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Retirement Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Transportation'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    public static List<User> assignToESSPMSVTransportationUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS PMSV Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Transportation'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            
            return Users;
        }
        
        return Users;
        
    }
    
    //Assign Stationary Admin
    public static List<PISUsers__c> assignToESSPMSVStationaryPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS PMSV Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Stationary'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    public static List<PISUsers__c> assignToESSGSBOStationaryPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_GSBO_Stationary'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    public static List<User> assignToESSPMSVStationaryPRTR() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Stationary'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            
            return Users;
        }
        
        return Users;
        
    }
    
    public static List<User> assignToESSGSBOStationaryPRTR() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_GSBO_Stationary'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            
            return Users;
        }
        
        return Users;
        
    }
    
    public static List<PISUsers__c> assignToESSPMSVHotelPISUser() {
        
        List<PISUsers__c> PISUsers = new List<PISUsers__c>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Hotel'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> allPISUsers = [select id, User__c, Email__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                                           OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, COMPANYCODE__c, EN_Fullname__c, HOME_COMP__c from PISUsers__c 
                                           where Active__c = true AND Mainposition__c = true];
            if(allPISUsers.size() > 0) {
                for(PISUsers__c PISUser : allPISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }

            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser != null) {
                    PISUser.COMPANYNAME__c = PISUserCompanyName(PISUser.HOME_COMP__c);
                    PISUsers.add(PISUser);
                }
            }
            return PISUsers;
        }
        return PISUsers;
    }
    
    public static List<User> assignToESSPMSVHotelUser() {
        
        List<User> Users = new List<User>();
        
        //Find from Group ESS Stationary Admin
        Group AdminGroup = [select id, developername from Group where developername =: 'ESS_PMSV_Hotel'];
        List<GroupMember> Members = [select id, groupid, userorgroupid from GroupMember where GroupId =: AdminGroup.Id];
        
        if(Members.size() > 0) {
            Map<string, PISUsers__c> mapPISUsers = new Map<string, PISUsers__c>();
            List<PISUsers__c> PISUsers = [select id, User__c from PISUsers__c where Active__c = true AND Mainposition__c = true];
            if(PISUsers.size() > 0) {
                for(PISUsers__c PISUser : PISUsers) {
                    mapPISUsers.put(PISUser.User__c, PISUser);
                }
            }
            for(GroupMember Member : Members) {
                Id MemberUserId = Member.userorgroupid;
                PISUsers__c PISUser = mapPISUsers.get(MemberUserId);
                if(PISUser == null) {
                    List<User> User = [select id, email, firstname, lastname from User where Id =: MemberUserId];
                    Users.add(User[0]);
                }
            }
            
            return Users;
        }
        
        return Users;
        
    }
    
    public static ESS_Retirement_DTO.RetirementApproverDTO GetSectionHeadDepartmentHead(PISUsers__c PISUser, Map<string, PISUsers__c> mapPOSIDPISUsers) {
        
        ESS_Retirement_DTO.RetirementApproverDTO RetirementApprover = new ESS_Retirement_DTO.RetirementApproverDTO();
        RetirementApprover.userId = PISUser.User__c;
        
        if(mapPOSIDPISUsers.size() > 0) {
            
            boolean isFindingSectHead = false;
            boolean isFindingDeptHead = false;
            string deptPOSID = '';
            
            if(PISUser.LEVEL__c == 'Section Head' || PISUser.LEVEL__c == 'VP' || PISUser.LEVEL__c == 'EVP Upward') {
                isFindingSectHead = false;
                isFindingDeptHead = true;
                
                RetirementApprover.sectionHeadId = '';
                RetirementApprover.sectionHeadName = '';
                RetirementApprover.sectionHeadNameTH = '';
                RetirementApprover.sectionHeadPosition = '';
                RetirementApprover.sectionHeadPositionTH = '';
                deptPOSID = PISUser.SectHeadUpPosID__c;
            }
            else {
                isFindingSectHead = true;
                isFindingDeptHead = true;
            }
            
            if(isFindingSectHead) {
                //Finding SectHeadUser
                PISUsers__c PISSectHead = mapPOSIDPISUsers.get(PISUser.SectHeadUpPosID__c);
                if(PISSectHead != null) {
                    if(PISSectHead.User__c == null) {
                        throw new ESS_Exception(
                                        'ไม่พบข้อมูล Salesforce User ของ Section Head');    
                    }
                    RetirementApprover.sectionHeadId = PISSectHead.User__c;
                    RetirementApprover.sectionHeadName = PISSectHead.EmployeeID__c + ' - ' + PISSectHead.EN_Fullname__c;
                    RetirementApprover.sectionHeadNameTH = PISSectHead.TH_Fullname__c;
                    RetirementApprover.sectionHeadPosition = PISSectHead.OBJENFULLNAME__c;
                    RetirementApprover.sectionHeadPositionTH = PISSectHead.OBJTHFULLNAME__c;
                    deptPOSID = PISSectHead.SectHeadUpPosID__c;
                    system.debug(PISSectHead);
                }
            }
            if(isFindingDeptHead) {
                //Finding DeptHeadUser
                PISUsers__c PISDeptHead = mapPOSIDPISUsers.get(deptPOSID);
                system.debug(deptPOSID);
                system.debug(PISDeptHead);
                if(PISDeptHead != null) {
                    if(PISDeptHead.User__c == null) {
                        throw new ESS_Exception(
                                        'ไม่พบข้อมูล Salesforce User ของ Department Head');    
                    }
                    RetirementApprover.departmentHeadId = PISDeptHead.User__c;
                    RetirementApprover.departmentHeadName = PISDeptHead.EmployeeID__c + ' - ' + PISDeptHead.EN_Fullname__c;
                    RetirementApprover.departmentHeadNameTH = PISDeptHead.TH_Fullname__c;
                    RetirementApprover.departmentHeadPosition = PISDeptHead.OBJENFULLNAME__c;
                    RetirementApprover.departmentHeadPositionTH = PISDeptHead.OBJTHFULLNAME__c;
                    system.debug(RetirementApprover);
                }
            }
        }
        
        return RetirementApprover;
    }
    
    public static ESS_Probationary_DTO.ProbationaryApproverDTO GetSectionHeadDepartmentHeadProbation(PISUsers__c PISUser, Map<string, PISUsers__c> mapPOSIDPISUsers) {
        
        ESS_Probationary_DTO.ProbationaryApproverDTO ProbationApprover = new ESS_Probationary_DTO.ProbationaryApproverDTO();
        ProbationApprover.userId = PISUser.User__c;
        
        if(mapPOSIDPISUsers.size() > 0) {
            
            boolean isFindingSectHead = false;
            boolean isFindingDeptHead = false;
            string deptPOSID = '';
            
            if(PISUser.LEVEL__c == 'Section Head' || PISUser.LEVEL__c == 'VP' || PISUser.LEVEL__c == 'EVP Upward') {
                isFindingSectHead = false;
                isFindingDeptHead = true;
                
                ProbationApprover.sectionHeadId = '';
                ProbationApprover.sectionHeadName = '';
                ProbationApprover.sectionHeadNameTH = '';
                ProbationApprover.sectionHeadPosition = '';
                deptPOSID = PISUser.SectHeadUpPosID__c;
            }
            else {
                isFindingSectHead = true;
                isFindingDeptHead = true;
            }
            
            if(isFindingSectHead) {
                //Finding SectHeadUser
                PISUsers__c PISSectHead = mapPOSIDPISUsers.get(PISUser.SectHeadUpPosID__c);
                if(PISSectHead != null) {
                    if(PISSectHead.User__c == null) {
                        throw new ESS_Exception(
                                        'ไม่พบข้อมูล Salesforce User ของ Section Head');    
                    }
                    ProbationApprover.sectionHeadId = PISSectHead.User__c;
                    ProbationApprover.sectionHeadName = PISSectHead.EmployeeID__c + ' - ' + PISSectHead.EN_Fullname__c;
                    ProbationApprover.sectionHeadNameTH = PISSectHead.TH_Fullname__c;
                    ProbationApprover.sectionHeadPosition = PISSectHead.OBJENFULLNAME__c;
                    deptPOSID = PISSectHead.SectHeadUpPosID__c;
                }
            }
            if(isFindingDeptHead) {
                //Finding DeptHeadUser
                PISUsers__c PISDeptHead = mapPOSIDPISUsers.get(deptPOSID);
                if(PISDeptHead != null) {
                    if(PISDeptHead.User__c == null) {
                        throw new ESS_Exception(
                                        'ไม่พบข้อมูล Salesforce User ของ Section Head');    
                    }
                    ProbationApprover.departmentHeadId = PISDeptHead.User__c;
                    ProbationApprover.departmentHeadName = PISDeptHead.EmployeeID__c + ' - ' + PISDeptHead.EN_Fullname__c;
                    ProbationApprover.departmentHeadNameTH = PISDeptHead.TH_Fullname__c;
                    ProbationApprover.departmentHeadPosition = PISDeptHead.OBJENFULLNAME__c;
                }
            }
        }
        
        return ProbationApprover;
    }
    
    public static ESS_Manpower_DTO.ManpowerApproverDTO GetSectionHeadDepartmentHeadManpower(PISUsers__c PISUser, List<PISUsers__c> PISUsers) {
        
        ESS_Manpower_DTO.ManpowerApproverDTO ManpowerApprover = new ESS_Manpower_DTO.ManpowerApproverDTO();
        ManpowerApprover.userId = PISUser.User__c;
        
        if(PISUsers.size() > 0) {
            
            boolean isFindingSectHead = false;
            boolean isFindingDeptHead = false;
            string deptPOSID = '';
            
            if(PISUser.LEVEL__c == 'Section Head' || PISUser.LEVEL__c == 'VP' || PISUser.LEVEL__c == 'EVP Upward') {
                isFindingSectHead = false;
                isFindingDeptHead = true;
                
                ManpowerApprover.sectionHeadId = '';
                ManpowerApprover.sectionHeadName = '';
                ManpowerApprover.sectionHeadNameTH = '';
                ManpowerApprover.sectionHeadPosition = '';
                deptPOSID = PISUser.SectHeadUpPosID__c;
            }
            else {
                isFindingSectHead = true;
                isFindingDeptHead = true;
            }
            
            if(isFindingSectHead) {
                //Finding SectHeadUser
                for(PISUsers__c PISSectHead : PISUsers) {
                    if(PISSectHead.POSID__c == PISUser.SectHeadUpPosID__c) {
                        ManpowerApprover.sectionHeadId = PISSectHead.User__c;
                        ManpowerApprover.sectionHeadName = PISSectHead.EN_Fullname__c;
                        ManpowerApprover.sectionHeadNameTH = PISSectHead.TH_Fullname__c;
                        ManpowerApprover.sectionHeadPosition = PISSectHead.OBJENFULLNAME__c;
                        deptPOSID = PISSectHead.SectHeadUpPosID__c;
                        break;
                    }
                }
            }
            if(isFindingDeptHead) {
                //Finding DeptHeadUser
                for(PISUsers__c PISDeptHead : PISUsers) {
                    if(PISDeptHead.POSID__c == deptPOSID) {
                        ManpowerApprover.departmentHeadId = PISDeptHead.User__c;
                        ManpowerApprover.departmentHeadName = PISDeptHead.EN_Fullname__c;
                        ManpowerApprover.departmentHeadNameTH = PISDeptHead.TH_Fullname__c;
                        ManpowerApprover.departmentHeadPosition = PISDeptHead.OBJENFULLNAME__c;
                        break;
                    }
                }
            }
        }
        
        return ManpowerApprover;
    }
    
    //get levels
    @RemoteAction
    public static List<string> GetLevels(){
        
        List<string> results = new List<string>();
        List<AggregateResult> Levels = new List<AggregateResult>(); 
        
        Levels = [select level__c from PISUsers__c where level__c != null group by level__c];
        
        if(Levels.size() > 0) {
            for(AggregateResult Level : Levels) {
                results.add(Level.get('level__c').toString());
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
        	Functions = [select function__c from PISUsers__c where CompanyCode__c =: companyCode AND function__c != '' group by function__c order by function__c asc];
        }
        else if(companyId == 'TES') {
            string companyCode = '1600';
        	Functions = [select function__c from PISUsers__c where CompanyCode__c =: companyCode AND function__c != '' group by function__c order by function__c asc];
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
    
    public static string emailURL(string link) {
        string URL = URL.getSalesforceBaseUrl().toExternalForm() + '/?ec=302&startURL=';
        string encodedURL = EncodingUtil.urlEncode(link,'UTF-8');
        URL += encodedURL;
        return URL;
    }
    
    public static string PISUserCompanyName(string homeComp) {
        string companyName = '';
        if(homeComp == '1100') {
            companyName = 'TOP';
        }
        else if(homeComp == '1600') {
            companyName = 'TES';
        }
        return companyName;
    }
    
    public static List<string> excludePerSubAreas() {
        List<string> perSubAreas = new List<string> {'0302','0402','0602','0702','0902','2000','2010','2900','0102','0112'};
        return perSubAreas;
    }
    
}