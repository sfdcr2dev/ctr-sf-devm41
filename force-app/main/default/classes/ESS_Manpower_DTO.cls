/* Author Softever */
public class ESS_Manpower_DTO {
    
    public class ManpowerTableDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public boolean isNew {get;set;}
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
        public ESS_Global.EnumValue status {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        @RemoteAction
        public string requesterName {get;set;}
        @RemoteAction
        public string onBehalfOfName {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public boolean canDelete {get;set;}
    }
    
    public class ManpowerDetailDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public boolean isNew {get;set;}
        @RemoteAction
        public boolean onBehalfFlow {get;set;}
        @RemoteAction
        public string serviceFor {get;set;} //separate by , 
        @RemoteAction
        public string glAccount {get;set;}
        @RemoteAction
        public string costCenter {get;set;}
        @RemoteAction
        public string internalOrderWBS {get;set;}
        //enum ManpowerStatus
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
        //enum ManpowerTypeOfService
        @RemoteAction
        public ESS_Global.EnumValue typeOfService {get;set;}
        //enum ManpowerObjective
        @RemoteAction
        public ESS_Global.EnumValue objective {get;set;}
        @RemoteAction
        public integer noOfContractorRequired {get;set;}
        @RemoteAction
        public string jobTitleId {get;set;}
        @RemoteAction
        public string jobTitleName {get;set;}
        @RemoteAction
        public string scopeOfServiceID {get;set;}
        @RemoteAction
        public date commencementDate {get;set;}
        @RemoteAction
        public date completionDate {get;set;}
        @RemoteAction
        public string workingDay {get;set;}
        @RemoteAction
        public string projectId {get;set;}
        @RemoteAction
        public string projectName {get;set;}
        @RemoteAction
        public string projectManagerId {get;set;}
        @RemoteAction
        public string projectManagerName {get;set;}
        @RemoteAction
        public date projectManagerApprovedDate {get;set;}
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
        public string referenceDocumentNo {get;set;}
        @RemoteAction
        public string outputRequired {get;set;}
        @RemoteAction
        public string jobDetail {get;set;}
        @RemoteAction
        public string qualification {get;set;}
        @RemoteAction
        public string physicalRequirement {get;set;}
        @RemoteAction
        public string jeScore {get;set;}
        @RemoteAction
        public string comment {get;set;}
        @RemoteAction
        public string requesterId {get;set;}
        @RemoteAction
        public string requesterEmployeeId {get;set;}
        @RemoteAction
        public string requesterEmployeeName {get;set;}
        @RemoteAction
        public string requesterEmail {get;set;}
        @RemoteAction
        public string requesterPosition {get;set;}
        @RemoteAction
        public string requesterUnit {get;set;}
        @RemoteAction
        public string requesterSection {get;set;}
        @RemoteAction
        public string requesterDepartment {get;set;}
        @RemoteAction
        public string requesterFunction {get;set;}
        @RemoteAction
        public string requesterTelOffice {get;set;}
        @RemoteAction
        public string requesterTelMobile {get;set;}
        @RemoteAction
        public string onBehalfOfId {get;set;}
        @RemoteAction
        public string onBehalfOfEmployeeId {get;set;}
        @RemoteAction
        public string onBehalfOfEmployeeName {get;set;}
        @RemoteAction
        public string onBehalfOfEmail {get;set;}
        @RemoteAction
        public string onBehalfOfPosition {get;set;}
        @RemoteAction
        public string onBehalfOfUnit {get;set;}
        @RemoteAction
        public string onBehalfOfSection {get;set;}
        @RemoteAction
        public string onBehalfOfDepartment {get;set;}
        @RemoteAction
        public string onBehalfOfFunction {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
        @RemoteAction
        public date sectionHeadApprovedDate {get;set;}
        @RemoteAction
        public date completedDate {get;set;}
        @RemoteAction
        public date cancelledDate {get;set;}
        @RemoteAction
        public string cancelledBy {get;set;}
        @RemoteAction
        public boolean canEditJobDetail {get;set;}
        @RemoteAction
        public boolean canEditManpower {get;set;}
        @RemoteAction
        public boolean canSave {get;set;}
        @RemoteAction
        public boolean canSubmit {get;set;}
        @RemoteAction
        public boolean canExport {get;set;}
        @RemoteAction
        public boolean canApprove {get;set;}
        @RemoteAction
        public boolean canReject {get;set;}
        @RemoteAction
        public boolean canCancelRequest {get;set;}
        @RemoteAction
        public boolean canAcknowledge {get;set;}
        @RemoteAction
        public string sectionHeadId {get;set;}
        @RemoteAction
        public string sectionHeadName {get;set;}
        @RemoteAction
        public string vpId {get;set;}
        @RemoteAction
        public string vpName {get;set;}
        @RemoteAction
        public date vpApprovedDate {get;set;}
        @RemoteAction
        public boolean isShowJDSection {get;set;}
        @RemoteAction
        public boolean isShowDefaultJEScore {get;set;}
        @RemoteAction
        public boolean canOnlyOnBehalf {get;set;}
        
    }
    
    public class JobTitleDTO {
        @RemoteAction
        public string jobTitleId {get;set;}
        @RemoteAction
        public string jobTitleName {get;set;}
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
        public string outputRequired {get;set;}
        @RemoteAction
        public string jobDetail {get;set;}
        @RemoteAction
        public string qualification {get;set;}
        @RemoteAction
        public string physicalRequirement {get;set;}
        @RemoteAction
        public string scopeOfServiceID {get;set;}
        @RemoteAction
        public string jeScore {get;set;}
        @RemoteAction
        public string comment {get;set;}
    }
    
    public class ApprovalHistoryDTO {
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public datetime actionDate {get;set;}
        //enum ManpowerApprovalStatus
        @RemoteAction
        public ESS_Global.EnumValue approvalStatus {get;set;}
        //enum ManpowerApproverRole
        @RemoteAction
        public ESS_Global.EnumValue approverRole {get;set;}
        @RemoteAction
        public string comment {get;set;}
    }
    
    public class SearchUserDTO {
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string displayName {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeNameTH {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string email {get;set;}
        @RemoteAction
        public string unit {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string function {get;set;}
    }
    
    public class ProjectDTO {
        @RemoteAction
        public string projectId {get;set;}
        @RemoteAction
        public string userId {get;set;}
        @RemoteAction
        public string projectName {get;set;}
        @RemoteAction
        public string projectManagerName {get;set;}
    }
    
    public class ManpowerApproverDTO {
        
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
}