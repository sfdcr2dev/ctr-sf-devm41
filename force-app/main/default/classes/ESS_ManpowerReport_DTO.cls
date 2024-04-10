/* Author Softever */
public class ESS_ManpowerReport_DTO {

    public class ManpowerReportTableDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        //enum ManpowerTypeOfService
        @RemoteAction
        public ESS_Global.EnumValue typeOfService {get;set;}
        //enum ManpowerObjective
        @RemoteAction
        public ESS_Global.EnumValue objective {get;set;}
        @RemoteAction
        public string jobTitle {get;set;}
        //enum ManpowerStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        @RemoteAction
        public string requester {get;set;}
        @RemoteAction
        public string onBehalfOf {get;set;}
    }
    
    public class ManpowerReportFullTableDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        //enum ManpowerStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public string serviceFor {get;set;}
        @RemoteAction
        public string glAccount {get;set;}
        @RemoteAction
        public string costCenter {get;set;}
        @RemoteAction
        public string internalOrderWBS {get;set;}
        @RemoteAction
        public string noOfStaffRequired {get;set;}
        //enum ManpowerTypeOfService
        @RemoteAction
        public ESS_Global.EnumValue typeOfService {get;set;}
        //enum ManpowerObjective
        @RemoteAction
        public ESS_Global.EnumValue objective {get;set;}
        @RemoteAction
        public string jobTitle {get;set;}
        @RemoteAction
        public string scopeOfServiceId {get;set;}
        @RemoteAction
        public string projectName {get;set;}
        @RemoteAction
        public string unit {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string function {get;set;}
        //enum ManpowerWorkLocation
        @RemoteAction
        public ESS_Global.EnumValue workLocation {get;set;}
        @RemoteAction
        public date commencementDate {get;set;}
        @RemoteAction
        public date completionDate {get;set;}
        @RemoteAction
        public string workingDay {get;set;}
        @RemoteAction
        public string jeScore {get;set;}
        @RemoteAction
        public string comment {get;set;}
        @RemoteAction
        public string requester {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        @RemoteAction
        public string onBehalfOf {get;set;}
        @RemoteAction
        public date employeeApprovedDate {get;set;}
        @RemoteAction
        public string sectionHeadName {get;set;}
        @RemoteAction
        public date sectionHeadApprovedDate {get;set;}
        @RemoteAction
        public string vpName {get;set;}
        @RemoteAction
        public date vpApprovedDate {get;set;}
        @RemoteAction
        public string projectManagerName {get;set;}
        @RemoteAction
        public date projectManagerApprovedDate {get;set;}
        @RemoteAction
        public date completedDate {get;set;}
        @RemoteAction
        public string cancelledBy {get;set;}
        @RemoteAction
        public date cancelledDate {get;set;}
    }
    
    public class GraphDTO {
        @RemoteAction
        public List<string> categories {get;set;}
        @RemoteAction
        public List<GraphSeriesDTO> series {get;set;}
    }
    
    public class GraphSeriesDTO {
        @RemoteAction
        public string type {get;set;}
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public List<integer> data {get;set;}
        @RemoteAction
        public string color {get;set;}
    }
    
}