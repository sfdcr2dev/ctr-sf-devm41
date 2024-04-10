/* Author Softever */
public class ESS_EmployeeBasicReport_DTO {

    //EmployeeBasic
    public class EmployeeBasicTableDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string subjectType {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string spouseId {get;set;}
        @RemoteAction
        public string spouseName {get;set;}
        //enum ApplicationStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        @RemoteAction
        public date verifiedDate {get;set;}
        @RemoteAction
        public date sendToBatchDate {get;set;}
        @RemoteAction
        public date sendToSAPDate {get;set;}
        @RemoteAction
        public date updatedInSAPDate {get;set;}
        @RemoteAction
        public date cancelledDate {get;set;}
        @RemoteAction
        public date effectiveDate {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
        @RemoteAction
        public string sap {get;set;}
    }
    
    public class EmployeeBasicGraphDTO {
        @RemoteAction
        public List<string> categories {get;set;}
        @RemoteAction
        public List<EmployeeBasicGraphSeriesDTO> series {get;set;}
    }
    
    public class EmployeeBasicGraphSeriesDTO {
        @RemoteAction
        public string type {get;set;}
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public List<decimal> data {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public List<integer> custom {get;set;}
    }
    
}