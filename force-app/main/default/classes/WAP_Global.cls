/* 
 * Author Softever
 */

public class WAP_Global {

    public static datetime convertDateTimeFilter(datetime dt) {
        
        datetime convertedDT = dt.addHours(-7);
        
        return convertedDT;
        
    }
    
    //Assign user to PISUser
    public static PISUsers__c assignToPISUser(string pisId) {
        
        PISUsers__c PISUser = [select id, User__c, EMPLOYEEID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c from PISUsers__c where User__c =: pisId AND Active__c = true AND Mainposition__c = true];
        
        return PISUser;
        
    }
    
    //Assign to all PISUsers
    public static Map<Id, PISUsers__c> assignToAllPISUsers() {
        
        Map<Id, PISUsers__c> mapPISUsers = new Map<Id, PISUsers__c>();
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c from PISUsers__c where Mainposition__c = true];
        
        for(PISUsers__c PISUser : PISUsers) {
            mapPISUsers.put(PISUser.Id, PISUser);
        }
        
        return mapPISUsers;
    }
    
    public static List<PISUsers__c> allPISUsers() {
        
        List<PISUsers__c> PISUsers = [select id, User__c, EMPLOYEEID__c, Level__c, ReportToUser__c, THTITLE__c, THFIRSTNAME__c, THLASTNAME__c, ENFIRSTNAME__c, ENLASTNAME__c,
                               OBJENFULLNAME__c, OBJTHFULLNAME__c, COMPANYNAME__c, EN_Fullname__c, LineManagerUser__c, LineManagerEmail__c,
                               EN_LineManager__c, Email__c, FUNCTION__c, DEPARTMENT__c, SECTIONS__c, UNITS__c from PISUsers__c where Mainposition__c = true];
        
        return PISUsers;
    }
    
    public static Map<Id, PTW_Header__c> assignToAllPTWHeaders() {
        Map<Id, PTW_Header__c> mapPTWs = new Map<Id, PTW_Header__c>();
        List<PTW_Header__c> PTWHeaders = [select id, status__c, Work_Clearance__c from PTW_Header__c order by createddate desc];
        if(PTWHeaders.size() > 0) {
            for(PTW_Header__c PTW : PTWHeaders) {
                mapPTWs.put(PTW.Work_Clearance__c, PTW);
            }
        }
        return mapPTWs;
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