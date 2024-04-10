/* Author Softever */
public class ESS_Retirement_DTO {

    public class RetirementListDTO {
        @RemoteAction
        public string retirementId {get;set;}
        @RemoteAction
        public boolean isDisable {get;set;}
        @RemoteAction
        public boolean isDisableSectionHead {get;set;}
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeTitle {get;set;}
        @remoteAction
        public string employeeNameTH {get;set;}
        @RemoteAction
        public date birthDate {get;set;}
        @RemoteAction
        public string age {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string level {get;set;}
        @RemoteAction
        public string sectionHeadEmployeeId {get;set;}
        @RemoteAction
        public string sectionHead {get;set;}
        @RemoteAction
        public string sectionHeadTH {get;set;}
        @RemoteAction
        public string departmentHeadEmployeeId {get;set;}
        @RemoteAction
        public string departmentHead {get;set;}
        @RemoteAction
        public string departmentHeadTH {get;set;}
        @RemoteAction
        public string sectionHeadName {get;set;}
        @RemoteAction
        public string departmentHeadName {get;set;}
        @RemoteAction
        public string sectionHeadPosition {get;set;}
        @RemoteAction
        public string departmentHeadPosition {get;set;}
        @RemoteAction
        public string sectionHeadPositionTH {get;set;}
        @RemoteAction
        public string departmentHeadPositionTH {get;set;}
    }
    
    public class RetirementApproverDTO {
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string sectionHeadId {get;set;}
        @RemoteAction
        public string sectionHeadName {get;set;}
        @RemoteAction
        public string sectionHeadNameTH {get;set;}
        @RemoteAction
        public string sectionHeadPosition {get;set;}
        @RemoteAction
        public string sectionHeadPositionTH {get;set;}
        @RemoteAction
        public string departmentHeadId {get;set;}
        @RemoteAction
        public string departmentHeadName {get;set;}
        @RemoteAction
        public string departmentHeadNameTH {get;set;}
        @RemoteAction
        public string departmentHeadPosition {get;set;}
        @RemoteAction
        public string departmentHeadPositionTH {get;set;}
    }
    
    public class RetirementApproveListDTO {
        @RemoteAction
        public string retirementId {get;set;}
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        //enum RetirementChoice
        @RemoteAction
        public ESS_Global.EnumValue retirementChoice {get;set;}
        @RemoteAction
        public date retirementDate {get;set;}
        //enum RetirementStatus
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date employeeSubmitDate {get;set;}
    }
    
    public class RetirementDetailDTO {
        @RemoteAction
        public string retirementId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeNameTH {get;set;}
        @RemoteAction
        public string employeeTitle {get;set;}
        @RemoteAction
        public string employeeNameEN {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public date birthDate {get;set;}
        @RemoteAction
        public string age {get;set;}
        //enum RetirementStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public boolean isSixtyYears {get;set;}
        //enum RetirementChoice
        @RemoteAction
        public ESS_Global.EnumValue retirementChoice {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        @RemoteAction
        public string sectionHeadId {get;set;}
        @RemoteAction
        public string sectionHead {get;set;}
        @RemoteAction
        public string sectionHeadTH {get;set;}
        @RemoteAction
        public string sectionHeadPositionTH {get;set;}
        @RemoteAction
        public date sectionHeadApproveDate {get;set;}
        @RemoteAction
        public string departmentHeadId {get;set;}
        @RemoteAction
        public string departmentHead {get;set;}
        @RemoteAction
        public string departmentHeadTH {get;set;}
        @RemoteAction
        public string departmentHeadPositionTH {get;set;}
        @RemoteAction
        public date departmentHeadApproveDate {get;set;}
        @RemoteAction
        public date completedDate {get;set;}
        @RemoteAction
        public date retirementDate {get;set;}
        @RemoteAction
        public date defaultRetirementDate {get;set;}
        @RemoteAction
        public List<ApprovalHistoryDTO> approvalHistories {get;set;}
        @RemoteAction
        public string vpName {get;set;}
        @RemoteAction
        public string vpPosition {get;set;}
        @RemoteAction
        public integer retirementAge {get;set;}
        @RemoteAction
        public boolean canApprove {get;set;}
        @RemoteAction
        public boolean canSubmit {get;set;}
        @RemoteAction
        public boolean canReject {get;set;}
        @RemoteAction
        public boolean canEdit {get;set;}
        @RemoteAction
        public boolean canDownload {get;set;}
        @RemoteAction
        public boolean canUploadPersonalFolder {get;set;}
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
        //enum RetirementStatus
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
        @RemoteAction
        public string comment {get;set;}
    }
    
    public class RetirementSearchCriteria {
        @RemoteAction
        public string year {get;set;}
        //enum RetirementStatus
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
    }
    
    
    public class SearchUserDTO {
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeNameTH {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string positionTH {get;set;}
    }
    
}