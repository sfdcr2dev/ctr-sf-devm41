/* Author Softever */
public class ESS_HotelBooking_DTO {

    public class HotelBookingDetailDTO {
        @RemoteAction
        public boolean isOnBehalf {get;set;}
        @RemoteAction
        public string documentType {get;set;}
		@RemoteAction
        public string recordId {get;set;}

        //Hotel ID
        @RemoteAction
        public string hotelId {get;set;}
         
        //&#xE08;&#xE33;&#xE19;&#xE27;&#xE19;&#xE1C;&#xE39;&#xE49;&#xE40;&#xE02;&#xE49;&#xE32;&#xE1E;&#xE31;&#xE01;
        @RemoteAction
        public integer adult {get;set;}
         
        //ID &#xE02;&#xE2D;&#xE07;&#xE44;&#xE1F;&#xE25;&#xE4C;
        @RemoteAction
        public List<ESS_DTO.FileDTO> attachmentFiles {get;set;}
        
        @RemoteAction
        public List<ESS_DTO.FileDTO> hotelAttachmentFiles {get;set;}
         
        @RemoteAction
        public boolean attentivenessRating {get;set;}
        @RemoteAction
        public boolean attentivenessRatingOBH {get;set;}
         
        @RemoteAction
        public string cancelComment {get;set;}
        @RemoteAction
        public string cancelledBy {get;set;}
        @RemoteAction
        public datetime cancelledDateTime {get;set;}
         
        @RemoteAction
        public date checkIn {get;set;}
         
        @RemoteAction
        public date checkOut {get;set;}
         
        @RemoteAction
        public datetime completedDateTime {get;set;}
         
        @RemoteAction
        public string documentNo {get;set;}
         
        @RemoteAction
        public string masterHotelId {get;set;}
         
        @RemoteAction
        public boolean expertiseRating {get;set;}
        @RemoteAction
        public boolean expertiseRatingOBH {get;set;}
        @RemoteAction
        public boolean fastRating {get;set;}
        @RemoteAction
        public boolean fastRatingOBH {get;set;}
         
        @RemoteAction
        public decimal guest1ChargeEmployee {get;set;}
         
        @RemoteAction
        public decimal guest1ContractRate {get;set;}
         
        @RemoteAction
        public string guest1SpecialRequest {get;set;}
         
        @RemoteAction
        public decimal guest2ChargeEmployee {get;set;}
         
        @RemoteAction
        public decimal guest2ContractRate {get;set;}
         
        @RemoteAction
        public string guest2SpecialRequest {get;set;}
         
        @RemoteAction
        public decimal twinBedChargeEmployee {get;set;}
        @RemoteAction
        public decimal twinBedContractRate {get;set;}
         
        //&#xE08;&#xE33;&#xE19;&#xE27;&#xE19;&#xE40;&#xE07;&#xE34;&#xE19;&#xE17;&#xE35;&#xE48;&#xE17;&#xE32;&#xE07;&#xE1E;&#xE19;&#xE31;&#xE01;&#xE07;&#xE32;&#xE19;&#xE15;&#xE49;&#xE2D;&#xE07;&#xE08;&#xE48;&#xE32;&#xE22;
        @RemoteAction
        public decimal guestAmount {get;set;}
         
        //&#xE0A;&#xE37;&#xE48;&#xE2D;&#xE1E;&#xE19;&#xE31;&#xE01;&#xE07;&#xE32;&#xE19;&#xE17;&#xE35;&#xE48;&#xE08;&#xE30;&#xE40;&#xE02;&#xE49;&#xE32;&#xE1E;&#xE31;&#xE01;
        @RemoteAction
        public string guestName {get;set;}
         
        @RemoteAction
        public string hotelName {get;set;}
        
        @RemoteAction
        public string hotelWebsite {get;set;}
        
        @RemoteAction
        public boolean isSelected {get;set;}
         
        @RemoteAction
        public string linkMap {get;set;}
         
        @RemoteAction
        public string location {get;set;}
         
        //&#xE08;&#xE33;&#xE19;&#xE27;&#xE19;&#xE27;&#xE31;&#xE19;&#xE17;&#xE35;&#xE48;&#xE40;&#xE02;&#xE49;&#xE32;&#xE1E;&#xE31;&#xE01;
        @RemoteAction
        public integer night {get;set;}
         
        @RemoteAction
        public boolean onBehalfFlow {get;set;}
        
        //&#xE0A;&#xE37;&#xE48;&#xE2D;&#xE04;&#xE19;&#xE17;&#xE35;&#xE48; On Behalf Of
        @RemoteAction
        public string onBehalfOf {get;set;}
         
        //Department &#xE04;&#xE19;&#xE17;&#xE35;&#xE48; On Behalf Of
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
        public string pmsvComment {get;set;}
         
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
        public string rejectedBy {get;set;}
        @RemoteAction
        public string rejectComment {get;set;}
        @RemoteAction
        public datetime rejectedDate {get;set;}
         
        @RemoteAction
        public string remark {get;set;}
         
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
        public string requesterTelMobile {get;set;}
         
        @RemoteAction
        public string requesterTelOffice {get;set;}
         
        //&#xE08;&#xE33;&#xE19;&#xE27;&#xE19;&#xE2B;&#xE49;&#xE2D;&#xE07;&#xE17;&#xE35;&#xE48;&#xE40;&#xE02;&#xE49;&#xE32;&#xE1E;&#xE31;&#xE01;
        @RemoteAction
        public integer room {get;set;}
        @RemoteAction
        public integer totalRoomNight {get;set;}
         
        //&#xE02;&#xE49;&#xE2D;&#xE21;&#xE39;&#xE25;&#xE2B;&#xE49;&#xE2D;&#xE07;&#xE17;&#xE31;&#xE49;&#xE07;&#xE2B;&#xE21;&#xE14;
        @RemoteAction
        public string roomJSON {get;set;}
         
        //flag &#xE1A;&#xE2D;&#xE01;&#xE27;&#xE48;&#xE32; email &#xE2A;&#xE48;&#xE07;&#xE44;&#xE1B;&#xE2B;&#xE32; Hotel &#xE2B;&#xE23;&#xE37;&#xE2D;&#xE22;&#xE31;&#xE07;
        @RemoteAction
        public boolean sendEmailToHotel {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
         
        @RemoteAction
        public datetime submittedDateTime {get;set;}
         
        //&#xE08;&#xE33;&#xE19;&#xE27;&#xE19;&#xE40;&#xE07;&#xE34;&#xE19;&#xE17;&#xE35;&#xE48;&#xE17;&#xE32;&#xE07; Thai Oil &#xE15;&#xE49;&#xE2D;&#xE07;&#xE08;&#xE48;&#xE32;&#xE22;
        @RemoteAction
        public decimal thaiOilAmount {get;set;}
         
        //&#xE08;&#xE33;&#xE19;&#xE27;&#xE19;&#xE40;&#xE07;&#xE34;&#xE19;&#xE17;&#xE31;&#xE49;&#xE07;&#xE2B;&#xE21;&#xE14;
        @RemoteAction
        public decimal total {get;set;}
        
        @RemoteAction
        public datetime verifiedDate {get;set;}
         
        @RemoteAction
        public datetime createdDate {get;set;}
        
        @RemoteAction
        public datetime submittedDate {get;set;}

        @RemoteAction
        public datetime completedDate {get;set;}    

        @RemoteAction
        public datetime cancelledDate {get;set;}  
        
        @RemoteAction
        public boolean canEdit {get;set;}
         
        @RemoteAction
        public boolean canSendEmail {get;set;}
         
        @RemoteAction
        public boolean canSave {get;set;}
         
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
        public boolean canRating {get;set;}
        
        @RemoteAction
        public boolean canSaveConfirm {get;set;}
        
		@RemoteAction
        public boolean canShowContractRate {get;set;}
        
        @RemoteAction
        public boolean showRatingForm {get;set;}
        @RemoteAction
        public boolean showRatingFormOBH {get;set;}
        
        @RemoteAction
        public boolean showCompleteForm {get;set;}
        
        @RemoteAction
        public boolean showRating {get;set;}
         
        @RemoteAction
        public datetime approvedDateTime {get;set;}
         
        @RemoteAction
        public boolean canSaveComplete {get;set;}
         
        @RemoteAction
        public boolean canComplete {get;set;}
         
        @RemoteAction
        public boolean isPRTRUser {get;set;}
        
        @RemoteAction
        public boolean canCheckAvailableRoom {get;set;}
        
        @RemoteAction
        public boolean canRejectOnProcess {get;set;}
        @RemoteAction
        public string room1SAPStatus {get;set;}
        @RemoteAction
        public string room2SAPStatus {get;set;}
        @RemoteAction
        public boolean canShowSAPStatus {get;set;}
        @RemoteAction
        public boolean canOnlyOnBehalf {get;set;}
        @RemoteAction
        public boolean isAdmin {get;set;}
         
        @RemoteAction
        public List<HotelBookingRoomDTO> hotelBookingRooms {get;set;}
         
    }
    
    public class HotelBookingRoomDTO {

        @RemoteAction
        //Sequence Id sending to SAP
        public integer id {get;set;}
        @RemoteAction
        public integer guestNo {get;set;}
        @RemoteAction
        //HotelRoomType
        public ESS_Global.EnumValue roomType {get;set;}
        @RemoteAction
        //HotelBedType
        public ESS_Global.EnumValue request {get;set;}
        @RemoteAction
        public string specialRequest {get;set;}
        //Pay by company (Total charge company)
        @RemoteAction
        public decimal payByCompany {get;set;}
        @RemoteAction
        public decimal contractRate {get;set;}
        //Pay by employee (Total charge employee)
        @RemoteAction
        public decimal chargeEmployee {get;set;}
        @RemoteAction
        public decimal total {get;set;}
    }
    
    public class HotelBookingRoomCardDTO {
        
        @RemoteAction
        public boolean isOnBehalf {get;set;}
        
		@RemoteAction
        public string recordId {get;set;}
	
        @RemoteAction
        public string hotelName {get;set;}
         
        //&#xE08;&#xE33;&#xE19;&#xE27;&#xE19;&#xE1C;&#xE39;&#xE49;&#xE40;&#xE02;&#xE49;&#xE32;&#xE1E;&#xE31;&#xE01;
        @RemoteAction
        public integer adult {get;set;}
         
        @RemoteAction
        public date checkIn {get;set;}
         
        @RemoteAction
        public date checkOut {get;set;}
         
        @RemoteAction
        public datetime completedDateTime {get;set;}
         
        @RemoteAction
        public string documentNo {get;set;}
         
        //&#xE08;&#xE33;&#xE19;&#xE27;&#xE19;&#xE27;&#xE31;&#xE19;&#xE17;&#xE35;&#xE48;&#xE40;&#xE02;&#xE49;&#xE32;&#xE1E;&#xE31;&#xE01;
        @RemoteAction
        public integer night {get;set;}
         
        @RemoteAction
        public string requesterDisplayName {get;set;}
        
        //&#xE08;&#xE33;&#xE19;&#xE27;&#xE19;&#xE2B;&#xE49;&#xE2D;&#xE07;&#xE17;&#xE35;&#xE48;&#xE40;&#xE02;&#xE49;&#xE32;&#xE1E;&#xE31;&#xE01;
        @RemoteAction
        public integer room {get;set;}
         
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
         
        @RemoteAction
        public datetime createdDate {get;set;}
         
        @RemoteAction
        public datetime completedDate {get;set;}

        //สำหรับใช้กับการ verify multiple document
        @RemoteAction
        public boolean isSelected {get;set;}

        @RemoteAction
        public string debugLog {get;set;}
         
    }
    
    public class SearchDTO {

        @RemoteAction
        public string recordId {get;set;}
         
        @RemoteAction
        public string search {get;set;}
         
    }
    
    public class RejectCancelDTO {

        @RemoteAction
        public string recordId {get;set;}
         
        @RemoteAction
        public string comment {get;set;}
         
    }
    
    public class UploadFileDTO {

        @RemoteAction
        public string fileName {get;set;}
         
        @RemoteAction
        public string fileData {get;set;}
         
        @RemoteAction
        public string recordId {get;set;}
         
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
    
	public class MasterHotelBookingDTO {
		@RemoteAction
        public string recordId {get;set;}

        //Hotel ID
        @RemoteAction
        public string name {get;set;}
         
        //Contact &#xE17;&#xE35;&#xE48;&#xE40;&#xE2B;&#xE25;&#xE37;&#xE2D;
        @RemoteAction
        public string contactJSON {get;set;}
         
        @RemoteAction
        public string contactEmail {get;set;}
         
        @RemoteAction
        public string contactName {get;set;}
         
        @RemoteAction
        public string contactTelephone {get;set;}
         
        @RemoteAction
        public decimal guest1ChargeEmployee {get;set;}
         
        @RemoteAction
        public decimal guest1ContractRate {get;set;}
         
        @RemoteAction
        public decimal guest2ChargeEmployee {get;set;}
         
        @RemoteAction
        public decimal guest2ContractRate {get;set;}
         
        @RemoteAction
        public decimal twinBedChargeEmployee {get;set;}
        @RemoteAction
        public decimal twinBedContractRate {get;set;}
         
        @RemoteAction
        public string hotelName {get;set;}
         
        @RemoteAction
        public string hotelWebsite {get;set;}
         
        @RemoteAction
        public string linkMap {get;set;}
         
        @RemoteAction
        public string location {get;set;}
         
        @RemoteAction
        public List<ESS_DTO.FileDTO> attachmentFiles {get;set;}
         
        @RemoteAction
        public List<MasterHotelBookingContactDTO> masterHotelBookingContacts {get;set;}
         
    }
    
    public class MasterHotelBookingContactDTO {

        @RemoteAction
        public string contactName {get;set;}
         
        @RemoteAction
        public string contactEmail {get;set;}
         
        @RemoteAction
        public string contactTelephone {get;set;}
         
    }
    
    public class HotelBookingExcelDTO {
        public string documentNo {get;set;}
        public string documentType {get;set;}
        public string hotelName {get;set;}
        public string guestName {get;set;}
        public datetime checkInDate {get;set;}
        public datetime checkOutDate {get;set;}
        public integer room1GuestNo {get;set;}
        public string room1RoomType {get;set;}
        public string room1SpecialRequest {get;set;}
        public decimal room1TotalContractRate {get;set;}
        public decimal room1TotalChargeCompany {get;set;}
        public decimal room1TotalChargeEmployee {get;set;}
        public integer room2GuestNo {get;set;}
        public string room2RoomType {get;set;}
        public string room2SpecialRequest {get;set;}
        public decimal room2TotalContractRate {get;set;}
        public decimal room2TotalChargeCompany {get;set;}
        public decimal room2TotalChargeEmployee {get;set;}
        public decimal total {get;set;}
        public decimal totalChargeCompany {get;set;}
        public decimal totalChargeEmployee {get;set;}
        public integer totalNight {get;set;}
        public integer totalRoom {get;set;}
        public integer totalGuest {get;set;}
        public string remark {get;set;}
        public string requesterName {get;set;}
        public string requesterEmployeeId {get;set;}
        public string requesterEmail {get;set;}
        public string requesterPosition {get;set;}
        public string requesterFunction {get;set;}
        public string requesterDepartment {get;set;}
        public string requesterSection {get;set;}
        public string requesterUnit {get;set;}
        public string obhName {get;set;}
        public string obhEmployeeId {get;set;}
        public string obhEmail {get;set;}
        public string obhPosition {get;set;}
        public string obhFunction {get;set;}
        public string obhDepartment {get;set;}
        public string obhSection {get;set;}
        public string obhUnit {get;set;}
        public datetime createdDate {get;set;}
        public datetime submittedDate {get;set;}
        public datetime verifiedDate {get;set;}
        public datetime completedDate {get;set;}
        public datetime rejectedDate {get;set;}
        public datetime cancelledDate {get;set;}
        public string completedBy {get;set;}
        public string verifiedBy {get;set;}
        public string rejectedBy {get;set;}
        public string cancelledBy {get;set;}
        public string rejectedReason {get;set;}
        public string cancelledReason {get;set;}
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