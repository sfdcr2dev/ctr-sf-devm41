/* Author Softever */
public class ESS_RetirementReport_DTO {

    //Retirement
    public class RetirementTableDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public date birthDate {get;set;}
        @RemoteAction
        public string age {get;set;}
        //enum RetirementChoice
        @RemoteAction
        public ESS_Global.EnumValue selectedRetirementDate {get;set;}
        @RemoteAction
        public date defaultRetirementDate {get;set;}
        @RemoteAction
        public date retirementDate {get;set;}
        @RemoteAction
        public string sectionHead {get;set;}
        @RemoteAction
        public string sectionHeadEmployeeId {get;set;}
        @RemoteAction
        public string departmentHead {get;set;}
        @RemoteAction
        public string departmentHeadEmployeeId {get;set;}
        //enum RetirementStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date employeeSubmittedDate {get;set;}
        @RemoteAction
        public date sectionHeadApprovedDate {get;set;}
        @RemoteAction
        public date departmentHeadApprovedDate {get;set;}
        @RemoteAction
        public date updatedToPersonalFolderDate {get;set;}
        @RemoteAction
        public date sentToSAPDate {get;set;}
        @RemoteAction
        public date completedDate {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string level {get;set;}
            
    }
    
    public class RetirementGraphSeriesDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public decimal y {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public string amount {get;set;}
    }
       
    public class RetirementGraphDTO {
        @RemoteAction
        public List<string> categories {get;set;}
        @RemoteAction
        public List<RetirementLineGraphSeriesDTO> series {get;set;}
    }
    
    public class RetirementLineGraphSeriesDTO {
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