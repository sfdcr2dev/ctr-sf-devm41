/* Author Softever */
public class ESS_ProbationaryReport_DTO {

    //Probation
    public class ProbationTableDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public date dateJoinedCompany {get;set;}
        @RemoteAction
        public date dateCompletedProbation {get;set;}
        //enum ProbationApproveStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public string sectionHead {get;set;}
        @RemoteAction
        public string sectionHeadEmployeeId {get;set;}
        @RemoteAction
        public date sectionHeadSubmittedDate {get;set;}
        @RemoteAction
        public string reassignSectionHead {get;set;}
        @RemoteAction
        public string reassignSectionHeadEmployeeId {get;set;}
        @RemoteAction
        public date reassignSectionHeadSubmittedDate {get;set;}
        @RemoteAction
        public string departmentHead {get;set;}
        @RemoteAction
        public string departmentHeadEmployeeId {get;set;}
        @RemoteAction
        public date departmentHeadSubmittedDate {get;set;}
        @RemoteAction
        public string reassignDepartmentHead {get;set;}
        @RemoteAction
        public string reassignDepartmentHeadEmployeeId {get;set;}
        @RemoteAction
        public date reassignDepartmentHeadSubmittedDate {get;set;}
        @RemoteAction
        public date completedDate {get;set;}
        //enum ProbationStatus
        @RemoteAction
        public ESS_Global.EnumValue probationStatus {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
        @RemoteAction
        public string level {get;set;}
        @RemoteAction
        public List<ESS_ProbationaryReport_DTO.ApprovalHistoryDTO> approvalHistories {get;set;}
    }
    
    public class ApprovalHistoryDTO {
        @RemoteAction
        public string name {get;set;}
        //enum ApproverRole
        @RemoteAction
        public ESS_Global.EnumValue approverRole {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        //enum ProbationApproveStatus
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
        @RemoteAction
        public string comment {get;set;}
    }
        
    public class ProbationGraphDTO {
        @RemoteAction
        public List<string> categories {get;set;}
        @RemoteAction
        public List<ProbationGraphSeriesDTO> series {get;set;}
    }
    
    public class ProbationGraphSeriesDTO {
        @RemoteAction
        public string type {get;set;}
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public List<integer> data {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public List<decimal> custom {get;set;}
    }
    
}