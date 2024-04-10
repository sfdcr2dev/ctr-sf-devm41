/* Author Softever */
public class ESS_Stationary_DTO {

    public class StationaryListDTO {

        @RemoteAction
        public boolean isOnBehalf {get;set;}
         
        @RemoteAction
        public string recordId {get;set;}
         
        @RemoteAction
        public string documentNo {get;set;}
         
        @RemoteAction
        public string location {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
        
        @RemoteAction
        public datetime createdDate {get;set;}
        
        @RemoteAction
        public datetime submittedDate {get;set;}
         
        @RemoteAction
        public string requesterDisplayName {get;set;}
         
        @RemoteAction
        public string onBehalfOfEmployeeName {get;set;}
         
        @RemoteAction
        public datetime completedDate {get;set;}
         
    }
    
    public class StationaryDetailDTO {

        @RemoteAction
        public boolean isOnBehalf {get;set;}
        
        @RemoteAction
        public datetime acceptedDate {get;set;}
        @RemoteAction
        public string acceptedComment {get;set;}
        @RemoteAction
        public string acceptedBy {get;set;}
        @RemoteAction
        public datetime deliveryDate {get;set;}
         
        @RemoteAction
        public string adminPMSVComment {get;set;}
         
        @RemoteAction
        public string administratorEmail {get;set;}
         
        @RemoteAction
        public string administratorName {get;set;}
         
        @RemoteAction
        public datetime approvedDate {get;set;}
        @RemoteAction
        public string approvedComment {get;set;}
         
        @RemoteAction
        public string attachmentFiles {get;set;}
         
        @RemoteAction
        public boolean attentivenessRating {get;set;}
        @RemoteAction
        public boolean attentivenessRatingOBH {get;set;}
         
        @RemoteAction
        public string comment {get;set;}
        @RemoteAction
        public string verifyComment {get;set;}
         
        @RemoteAction
        public datetime completedDate {get;set;}
         
        @RemoteAction
        public string documentNo {get;set;}
         
        @RemoteAction
        public boolean expertiseRating {get;set;}
        @RemoteAction
        public boolean expertiseRatingOBH {get;set;}
         
        @RemoteAction
        public boolean fastRating {get;set;}
        @RemoteAction
        public boolean fastRatingOBH {get;set;}
         
        @RemoteAction
        public string internalNo {get;set;}
         
        @RemoteAction
        public string location {get;set;}
         
        @RemoteAction
        public string mobileNo {get;set;}
         
        @RemoteAction
        public string onBehalfOf {get;set;}
         
        @RemoteAction
        public string onBehalfOfDepartment {get;set;}
         
        @RemoteAction
        public string onBehalfOfEmail {get;set;}
         
        @RemoteAction
        public string onBehalfOfEmployeeId {get;set;}
         
        @RemoteAction
        public string onBehalfOfEmployeeName {get;set;}
        @RemoteAction
        public string onBehalfOfEmployeeNameEN {get;set;}
         
        @RemoteAction
        public boolean onBehalfOfFlow {get;set;}
         
        @RemoteAction
        public string onBehalfOfFunction {get;set;}
         
        @RemoteAction
        public string onBehalfOfId {get;set;}
         
        @RemoteAction
        public string onBehalfOfPosition {get;set;}
         
        @RemoteAction
        public string onBehalfOfSection {get;set;}
         
        @RemoteAction
        public string onBehalfOfUnit {get;set;}
        @RemoteAction
        public string onBehalfOfLevel {get;set;}
         
        @RemoteAction
        public boolean onBehalfOfVerifying {get;set;}
         
        @RemoteAction
        public string pmsvId {get;set;}
        @RemoteAction
        public string pmsvEmployeeId {get;set;}
        @RemoteAction
        public string pmsvEmployeeName {get;set;}
        @RemoteAction
        public string pmsvEmail {get;set;}
        @RemoteAction
        public string pmsvPosition {get;set;}
        @RemoteAction
        public string pmsvUnit {get;set;}
        @RemoteAction
        public string pmsvSection {get;set;}
        @RemoteAction
        public string pmsvDepartment {get;set;}
        @RemoteAction
        public string pmsvFunction {get;set;}
        
        @RemoteAction
        public boolean punctualityRating {get;set;}
        @RemoteAction
        public boolean punctualityRatingOBH {get;set;}
         
        @RemoteAction
        public datetime ratingDate {get;set;}
        @RemoteAction
        public datetime ratingDateOBH {get;set;}
        @RemoteAction
        public integer ratingScore {get;set;}
        @RemoteAction
        public integer ratingScoreOBH {get;set;}
         
        @RemoteAction
        public string rejectComment {get;set;}
        @RemoteAction
        public datetime rejectedDate {get;set;}
        @RemoteAction
        public string rejectedBy {get;set;}
         
        @RemoteAction
        public string requesterDepartment {get;set;}
         
        @RemoteAction
        public string requesterEmail {get;set;}
         
        @RemoteAction
        public string requesterEmployeeId {get;set;}
         
        @RemoteAction
        public string requesterEmployeeName {get;set;}
        @RemoteAction
        public string requesterEmployeeNameEN {get;set;}
         
        @RemoteAction
        public string requesterFunction {get;set;}
         
        @RemoteAction
        public string requesterId {get;set;}
         
        @RemoteAction
        public string requesterName {get;set;}
         
        @RemoteAction
        public string requesterPosition {get;set;}
         
        @RemoteAction
        public string requesterSection {get;set;}
         
        @RemoteAction
        public string requesterUnit {get;set;}
        @RemoteAction
        public string requesterLevel {get;set;}
         
        @RemoteAction
        public string requesterTelMobile {get;set;}
         
        @RemoteAction
        public string requesterTelOffice {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue serviceFor {get;set;}
        
        @RemoteAction
        public string otherServiceFor {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
         
        @RemoteAction
        public datetime submittedDate {get;set;}
         
        @RemoteAction
        public decimal total {get;set;}
         
        @RemoteAction
        public decimal totalOther {get;set;}
         
        @RemoteAction
        public decimal totalStock {get;set;}
         
        @RemoteAction
        public datetime verifiedDate {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue withdrawFrom {get;set;}
         
        @RemoteAction
        public string withdrawFromStock {get;set;}
         
        @RemoteAction
        public string withdrawOther {get;set;}
         
        @RemoteAction
        public datetime lastUpdatedDate {get;set;}
         
        @RemoteAction
        public string lastUpdatedBy {get;set;}
         
        @RemoteAction
        public string recordId {get;set;}
         
        @RemoteAction
        public datetime createdDate {get;set;}
        @RemoteAction
        public datetime cancelledDate {get;set;}
        @RemoteAction
        public string cancelComment {get;set;}
         
        @RemoteAction
        public boolean canSave {get;set;}
        @RemoteAction
        public boolean canEdit {get;set;} 
        @RemoteAction
        public boolean canSubmit {get;set;}
         
        @RemoteAction
        public boolean canDelete {get;set;}
         
        @RemoteAction
        public boolean canVerify {get;set;}
         
        @RemoteAction
        public boolean canCancelRequest {get;set;}
         
        @RemoteAction
        public boolean canReject {get;set;}
         
        @RemoteAction
        public boolean canApprove {get;set;}
         
        @RemoteAction
        public boolean showRatingForm {get;set;}
        @RemoteAction
        public boolean showRatingFormOBH {get;set;}
        
        @RemoteAction
        public boolean showPMSVComment {get;set;}
        
        @RemoteAction
        public boolean canRating {get;set;}
         
        @RemoteAction
        public boolean showRating {get;set;}
         
        @RemoteAction
        public boolean canSaveComplete {get;set;}
        
        @RemoteAction
        public boolean showCompleteForm {get;set;}
         
        @RemoteAction
        public boolean canComplete {get;set;}
        @RemoteAction
        public boolean canAccept {get;set;}
         
        @RemoteAction
        public List<WithdrawDTO> withdraws {get;set;}
         
        @RemoteAction
        public List<WithdrawDTO> withdrawOthers {get;set;}
         
        @RemoteAction
        public string userManagerId {get;set;}
        @RemoteAction
        public string userManagerName {get;set;}
        @RemoteAction
        public string userManagerNameEN {get;set;}
        @RemoteAction
        public boolean userManagerFlow {get;set;}
        @RemoteAction
        public string ccName {get;set;}
        @RemoteAction
        public string ccEmail {get;set;}
        @RemoteAction
        public string ccLevel {get;set;}
        @RemoteAction
        public datetime needDate {get;set;}
        @RemoteAction
        public boolean canOnlyOnBehalf {get;set;}
        @RemoteAction
        public string staffComment {get;set;}
    }
    
    public class StationaryCardDTO {

        @RemoteAction
        public boolean isOnBehalf {get;set;}
        
        @RemoteAction
        public datetime completedDate {get;set;}
         
        @RemoteAction
        public datetime createdDate {get;set;}
         
        @RemoteAction
        public string documentNo {get;set;}
         
        @RemoteAction
        public string requesterDisplayName {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
         
        @RemoteAction
        public string recordId {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue serviceFor {get;set;}
        
        //สำหรับใช้กับการ verify multiple document
        @RemoteAction
        public boolean isSelected {get;set;}
        @RemoteAction
        public boolean canSelect {get;set;}
         
    }
    
    public class StationaryRequestDTO {

        @RemoteAction
        public string recordId {get;set;}
         
    }
    
    public class StationaryResponseDTO {

        @RemoteAction
        public string response {get;set;}
         
    }
    
    public class WithdrawDTO {

        @RemoteAction
        public string recordId {get;set;}
         
        @RemoteAction
        public integer no {get;set;}
         
        @RemoteAction
        public string stationaryId {get;set;}
         
        @RemoteAction
        public List<ESS_DTO.FileDTO> attachmentFiles {get;set;}
         
        @RemoteAction
        public string name {get;set;}
         
        @RemoteAction
        public decimal stockOnHand {get;set;}
         
        @RemoteAction
        public integer quantity {get;set;}
         
        @RemoteAction
        public string unit {get;set;}
         
        @RemoteAction
        public decimal pricePerUnit {get;set;}
         
        @RemoteAction
        public decimal totalPrice {get;set;}
        
        @RemoteAction
        public decimal actualWithdraw {get;set;}
         
    }
    
    public class SearchDTO {

        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string search {get;set;}
        @RemoteAction
        public string section {get;set;}
         
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
        @RemoteAction
        public string level {get;set;}
        @RemoteAction
        public string userManagerId {get;set;}
        @RemoteAction
        public string userManagerName {get;set;}
    }
    
    public class RejectCancelDTO {

        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string comment {get;set;}
         
    }
    
    public class AcceptDTO {

        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string comment {get;set;}
        @RemoteAction
        public datetime deliveryDate {get;set;}
         
    }
    
    public class UploadFileDTO {

        @RemoteAction
        public string fileName {get;set;}
         
        @RemoteAction
        public string fileData {get;set;}
         
        @RemoteAction
        public string recordId {get;set;}
         
    }
        
    public class MasterStationaryListDTO {
		@RemoteAction
        public string recordId {get;set;}
        
        @RemoteAction
        public boolean active {get;set;}
         
        @RemoteAction
        public List<ESS_DTO.FileDTO> attachmentFiles {get;set;}
         
        @RemoteAction
        public integer dueStock {get;set;}
         
        @RemoteAction
        public string stationaryId {get;set;}
         
        @RemoteAction
        public integer minimumStock {get;set;}
         
        @RemoteAction
        public string otherSupplier {get;set;}
         
        @RemoteAction
        public decimal price {get;set;}
         
        @RemoteAction
        public string stationaryName {get;set;}
         
        @RemoteAction
        public string stockHistory {get;set;}
         
        @RemoteAction
        public integer stockOnHand {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue supplier {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue type {get;set;}
         
        @RemoteAction
        public string unit {get;set;}
         
        @RemoteAction
        public integer availableStock {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue serviceFor {get;set;}
         
        @RemoteAction
        public datetime lastUpdatedDate {get;set;}
         
        @RemoteAction
        public string lastUpdatedBy {get;set;}
         
    }
    
    public class StationaryExcelDTO {
        public string documentNo {get;set;}
        public string documentType {get;set;}
        public string withdrawFrom {get;set;}
        public string serviceFor {get;set;}
        public string location {get;set;}
        public string internalNo {get;set;}
        public string mobileNo {get;set;}
        public datetime needDate {get;set;}
        public string typeOfStationary {get;set;}
        public string stationaryId {get;set;}
        public string stationaryName {get;set;}
        public integer stockOnHand {get;set;}
        public integer withdrawQuantity {get;set;}
        public integer actualQuantity {get;set;}
        public string unit {get;set;} //
        public decimal price {get;set;} //
        public decimal totalStock {get;set;}
        public decimal totalOther {get;set;}
        public decimal total {get;set;}
        public string comment {get;set;}
        public string verifyStatus {get;set;}
        public string obhComment {get;set;}
        public string approveStatus {get;set;}
        public string approvedComment {get;set;}
        public string userManagerComment {get;set;}
        public string staffComment {get;set;}
        public string pmsvComment {get;set;}
        public string requesterName {get;set;}
        public string requesterEmployeeId {get;set;}
        public string requesterEmail {get;set;}
        public string requesterPosition {get;set;}
        public string requesterFunction {get;set;}
        public string requesterDepartment {get;set;}
        public string requesterSection {get;set;}
        public string requesterUnit {get;set;}
        public datetime createdDate {get;set;}
        public datetime submittedDate {get;set;}
        public string obhName {get;set;}
        public string obhEmployeeId {get;set;}
        public string obhEmail {get;set;}
        public string obhPosition {get;set;}
        public string obhFunction {get;set;}
        public string obhDepartment {get;set;}
        public string obhSection {get;set;}
        public string obhUnit {get;set;}
        public string userManagerName {get;set;}
        public datetime verifiedRejectedDate {get;set;}
        public datetime verifiedDate {get;set;}
        public datetime approvedDate {get;set;}
        public datetime approvedRejectedDate {get;set;}
        public datetime completedDate {get;set;}
        public datetime rejectedDate {get;set;}
        public datetime cancelledDate {get;set;}
        public string acceptedBy {get;set;}
        public string completedBy {get;set;}
        public string cancelledBy {get;set;}
        public string verifiedBy {get;set;}
        public string rejectedBy {get;set;}
        public string verifyComment {get;set;}
        public string rejectComment {get;set;}
        public string cancelledComment {get;set;}
        public string currentStatus {get;set;}
        public boolean requesterRatingCompleted {get;set;}
        public integer requesterRating {get;set;}
        public boolean requesterAttentiveness {get;set;}
        public boolean requesterFast {get;set;}
        public boolean requesterPunctuality {get;set;}
        public boolean requesterExpertise {get;set;}
        public boolean obhRatingCompleted {get;set;}
        public integer obhRating {get;set;}
        public boolean obhAttentiveness {get;set;}
        public boolean obhFast {get;set;}
        public boolean obhPunctuality {get;set;}
        public boolean obhExpertise {get;set;}
    }
    
}