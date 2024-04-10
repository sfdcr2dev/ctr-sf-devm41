/* Author Softever */
public class ESS_Probationary_DTO {
    
    public class ProbationaryListDTO {
        @RemoteAction
        public string probationId {get;set;}
        @RemoteAction
        public string ownerId {get;set;}
        @RemoteAction
        public boolean isDisable {get;set;}
        @RemoteAction
        public boolean isDisableSectionHead {get;set;}
        @RemoteAction
        public date dateStamp {get;set;} 
        @RemoteAction
        public string companyName {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeNameEN {get;set;}
        @RemoteAction
        public string level {get;set;}
        @RemoteAction
        public date dateJoinedCompany {get;set;}
        @RemoteAction
        public date dateCompletedProbation {get;set;}
        @RemoteAction
        public string sectionHead {get;set;}
        @RemoteAction
        public string sectionHeadTH {get;set;}
        @RemoteAction
        public string sectionHeadName {get;set;}
        @RemoteAction
        public string sectionHeadEmployeeId {get;set;}
        @RemoteAction
        public string sectionHeadPosition {get;set;}
        @RemoteAction
        public string departmentHead {get;set;}
        @RemoteAction
        public string departmentHeadTH {get;set;}
        @RemoteAction
        public string departmentHeadName {get;set;}
        @RemoteAction
        public string departmentHeadEmployeeId {get;set;}
        @RemoteAction
        public string departmentHeadPosition {get;set;}
        @RemoteAction
        public string cep {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
        
    }
    
    public class ProbationaryApproveListDTO {
        @RemoteAction
        public string probationId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeNameEN {get;set;}
        @RemoteAction
        public date dateJoinedCompany {get;set;}
        @RemoteAction
        public date dateCompletedProbation {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        //enum ProbationApproveStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public string sectionHead {get;set;}
        @RemoteAction
        public string sectionHeadName {get;set;}
        @RemoteAction
        public date sectionHeadSubmittedDate {get;set;}
        @RemoteAction
        public string departmentHead {get;set;}
        @RemoteAction
        public string departmentHeadName {get;set;}
        @RemoteAction
        public date departmentHeadSubmittedDate {get;set;}
        @RemoteAction
        public date completedDate {get;set;}
        //enum ProbationStatus
        @RemoteAction
        public ESS_Global.EnumValue probationStatus {get;set;}
    }
    
    public class ProbationaryDetailDTO {
        @RemoteAction
        public string probationId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        //enum ProbationApproveStatus
        @RemoteAction
        public ESS_Global.EnumValue currentStatus {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeNameEN {get;set;}
        @RemoteAction
        public string companyName {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public date dateJoinedCompany {get;set;}
        @RemoteAction
        public date dateCompletedProbation {get;set;}
        
        //Section Head
        @RemoteAction
        public boolean isEditSectionHead {get;set;}
        //enum ProbationSectionHeadQuantity
        @RemoteAction
        public ESS_Global.EnumValue quantityOfWork {get;set;}
        //enum ProbationSectionHeadQuality
        @RemoteAction
        public ESS_Global.EnumValue qualityOfWork {get;set;}
        //enum ProbationSectionHeadSafety
        @RemoteAction
        public ESS_Global.EnumValue safetyAwareness {get;set;}
        //enum ProbationSectionHeadKnowledge
        @RemoteAction
        public ESS_Global.EnumValue knowledgeSkills {get;set;}
        //enum ProbationSectionHeadReliability
        @RemoteAction
        public ESS_Global.EnumValue reliability {get;set;}
        //enum ProbationSectionHeadAttitude
        @RemoteAction
        public ESS_Global.EnumValue attitude {get;set;}
        @RemoteAction
        public string sectionHeadComment {get;set;}
        //enum ProbationSectionHeadEngineering
        @RemoteAction
        public ESS_Global.EnumValue engineeringLicense {get;set;}
        //enum ProbationSectionHeadRecommendation
        @RemoteAction
        public ESS_Global.EnumValue recommendation {get;set;}
        @RemoteAction
        public string recommendationComment {get;set;}
        @RemoteAction
        public string sectionHeadName {get;set;}
        @RemoteAction
        public string sectionHeadPosition {get;set;}
        @RemoteAction
        public date sectionHeadSubmittedDate {get;set;}
        
        @RemoteAction
        public List<ESS_Probationary_DTO.ReassignDTO> reassignSectionHeads {get;set;}
        
        //Department Head
        @RemoteAction
        public boolean isEditDepartmentHead {get;set;}
        //enum ProbationDepartmentHeadConfirmation
        @RemoteAction
        public ESS_Global.EnumValue probationConfirmation {get;set;}
        @RemoteAction
        public string probationConfirmationComment {get;set;}
        //enum ProbationDepartmentHeadCEP
        @RemoteAction
        public ESS_Global.EnumValue cepConfirmation {get;set;}
        @RemoteAction
        public string cepFinalInterview {get;set;}
        @RemoteAction
        public string cepPropose {get;set;}
        @RemoteAction
        public string cepComment {get;set;}
        @RemoteAction
        public string departmentHeadComment {get;set;}
        
        //Department Head Information
        @RemoteAction
        public string departmentHeadName {get;set;}
        @RemoteAction
        public string departmentHeadPosition {get;set;}
        @RemoteAction
        public date departmentHeadSubmittedDate {get;set;}
        
        @RemoteAction
        public List<ESS_Probationary_DTO.ReassignDTO> reassignDepartmentHeads {get;set;}
        
        @RemoteAction
        public List<ESS_Probationary_DTO.ApprovalHistoryDTO> approvalHistories {get;set;}
        
        @RemoteAction
        public boolean canSaveSectionHead {get;set;}
        @RemoteAction
        public boolean canSaveDepartmentHead {get;set;}
        @RemoteAction
        public boolean canViewDepartmentHead {get;set;}
        @RemoteAction
        public boolean canSubmit {get;set;}
        @RemoteAction
        public boolean canReassign {get;set;}
        @RemoteAction
        public boolean canSendBack {get;set;}
        @RemoteAction
        public boolean canUploadPersonalFolder {get;set;}
    }
    
    public class ProbationaryApproverDTO {
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
        public string departmentHeadId {get;set;}
        @RemoteAction
        public string departmentHeadName {get;set;}
        @RemoteAction
        public string departmentHeadNameTH {get;set;}
        @RemoteAction
        public string departmentHeadPosition {get;set;}
    }
    
    public class ReassignDTO {
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        @RemoteAction
        public date reassignedDate {get;set;}
        @RemoteAction
        public string comment {get;set;}
        @RemoteAction
        public boolean isAssignedBy {get;set;}
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
    
    public class ReassignPersonDTO {
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string comment {get;set;}
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
    }
}