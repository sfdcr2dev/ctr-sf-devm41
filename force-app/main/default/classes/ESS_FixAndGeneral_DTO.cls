public class ESS_FixAndGeneral_DTO {
    public class FixAndGeneralDetailDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        //enum FixAndGeneralDocumentStatus
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
        //enum FixTypeOfService
        @RemoteAction
        public ESS_Global.EnumValue typeOfService {get;set;}
        @RemoteAction
        public boolean onBehalfFlow {get;set;}

        //รายละเอียดการแจ้งซ่อม
        //--สำหรับแจ้งซ่อมอุปกรณ์
        //พื้นที่แจ้งซ่อมอุปกรณ์สำนักงาน/ส่วนอาคาร
        @RemoteAction
        public string repairArea {get;set;}
        //สำนักงาน/อาคาร
        @RemoteAction
        public string officeBuilding {get;set;}
        //ชั้น/พื้นที่
        @RemoteAction
        public string floor {get;set;}
        //เบอร์โทรศัพท์ภายใน
        @RemoteAction
        public string telNo {get;set;}
        @RemoteAction
        public string mobileNo {get;set;}
        @RemoteAction
        public string topic {get;set;}
        @RemoteAction
        public string detail {get;set;}
        //วันที่ต้องการให้แล้วเสร็จ
        @RemoteAction
        public datetime expectedDueDate {get;set;}
        //รูปภาพหรือวิดีโอ
        @RemoteAction
        public List<ESS_DTO.FileDTO> attachmentFiles {get;set;}
        //--การแจ้งงานซ่อมอุปกรณ์บ้านพัก หมู่บ้านไทยออยล์
        //บ้านเลขที่
        @RemoteAction
        public string houseNo {get;set;}
        //กะ enum HousingPeriod
        @RemoteAction
        public ESS_Global.EnumValue period {get;set;}
        //วัน-เวลา ที่ต้องการให้เข้าซ่อม
        @RemoteAction
        public datetime repairDate {get;set;}
        //ประเภทของที่อยู่อาศัย enum HousingType
        @RemoteAction
        public ESS_Global.EnumValue houseType {get;set;}
        //--การแจ้งซ่อมยานพาหนะ
        @RemoteAction
        public List<TransportationItemDTO> transportationItems {get;set;}
		@RemoteAction
        public string location {get;set;}


        //---ประเมิณความพึงพอใจ---
        @RemoteAction
        public decimal ratingScore {get;set;}
        //ความเอาใจใส่
        @RemoteAction
        public boolean attentivenessRating {get;set;}
        //ทำงานรวดเร็ว
        @RemoteAction
        public boolean fastRating {get;set;}
        //ต่อตรงเวลา
        @RemoteAction
        public boolean punctualityRating {get;set;}
        //ความเชี่ยวชาญ
        @RemoteAction
        public boolean expertiseRating {get;set;}
        //------
        ////---ประเมิณความพึงพอใจ Requester (in case of OBH) ---
        @RemoteAction
        public decimal ratingScoreOBH {get;set;}
        //ความเอาใจใส่
        @RemoteAction
        public boolean attentivenessRatingOBH {get;set;}
        //ทำงานรวดเร็ว
        @RemoteAction
        public boolean fastRatingOBH {get;set;}
        //ต่อตรงเวลา
        @RemoteAction
        public boolean punctualityRatingOBH {get;set;}
        //ความเชี่ยวชาญ
        @RemoteAction
        public boolean expertiseRatingOBH {get;set;}
        //------

        //---รายละเอียดการปิดงานซ่อม---
        @RemoteAction
        public List<ESS_DTO.FileDTO> completedAttachmentFiles {get;set;}
        //--การแจ้งงานปิดงานซ่อมอุปกรณ์สำนักงาน/ส่วนอาคาร 
        //enum OfficeTypeOffService
        @RemoteAction
        public ESS_Global.EnumValue officeTypeOfService {get;set;}
        @RemoteAction
        public string officeTypeOfServiceOther {get;set;}
        @RemoteAction
        public decimal officeCost {get;set;}
        @RemoteAction
        public string officeDetail {get;set;}
        @RemoteAction
        public string officeInternalDetail {get;set;}
        //--การแจ้งซ่อมอุปกรณ์บ้านพัก
        //enum HousingTypeOfService
        @RemoteAction
        public ESS_Global.EnumValue housingTypeOfService {get;set;}
        @RemoteAction
        public string housingTypeOfServiceOther {get;set;}
        @RemoteAction
        public decimal housingCost {get;set;}
        @RemoteAction
        public string housingDetail {get;set;}
        @RemoteAction
        public string housingInternalDetail {get;set;}
        
        //--การแจ้งซ่อมพาหนะ
        //enum TransportationTypeOfService
        @RemoteAction
        public ESS_Global.EnumValue transportationTypeOfService {get;set;}
        @RemoteAction
        public string transportationTypeOfServiceOther {get;set;}
        @RemoteAction
        public decimal transportationCost {get;set;}
        @RemoteAction
        public string transportationDetail {get;set;}
        @RemoteAction
        public string transportationInternalDetail {get;set;}
        
        //--งานบริการอื่นๆ
        //enum GeneralTypeOfService
        @RemoteAction
        public ESS_Global.EnumValue generalTypeOfService {get;set;}
        @RemoteAction
        public string generalTypeOfServiceOther {get;set;}
        @RemoteAction
        public decimal generalCost {get;set;}
        @RemoteAction
        public string generalDetail {get;set;}
        @RemoteAction
        public string generalInternalDetail {get;set;}
        
        //------

        @RemoteAction
        public boolean isOnBehalf {get;set;}
        @RemoteAction
        public string requesterId {get;set;}
        @RemoteAction
        public string requesterEmployeeId {get;set;}
        @RemoteAction
        public string requesterEmployeeName {get;set;}
        @RemoteAction
        public string requesterEmployeeNameEN {get;set;}
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
        public string onBehalfOfEmployeeNameEN {get;set;}
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
        public datetime createdDate {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public datetime verifiedDate {get;set;}
        @RemoteAction
        public datetime acceptedDate {get;set;}
        @RemoteAction
        public datetime completedDate {get;set;}
        @RemoteAction
        public datetime ratingDate {get;set;}
        @RemoteAction
        public datetime ratingDateOBH {get;set;}
        @RemoteAction
        public datetime rejectedDate {get;set;}
        @RemoteAction
        public datetime cancelledDate {get;set;}

        @RemoteAction
        public string rejectComment {get;set;}
        @RemoteAction
        public string rejectedBy {get;set;}
        @RemoteAction
        public string cancelComment {get;set;}
        @RemoteAction
        public string cancelledBy {get;set;}

        @RemoteAction
        public boolean showOfficeInternalDetail {get;set;}
        @RemoteAction
        public boolean showHousingInternalDetail {get;set;}
        @RemoteAction
        public boolean showTransportationInternalDetail {get;set;}
        @RemoteAction
        public boolean showGeneralInternalDetail {get;set;}
        @RemoteAction
        public boolean canDelete {get;set;}
        @RemoteAction
        public boolean canSave {get;set;}
        @RemoteAction
        public boolean canSubmit {get;set;}
        @RemoteAction
        public boolean canEdit {get;set;}
        @RemoteAction
        public boolean canVerify {get;set;}
        @RemoteAction
        public boolean canCancelRequest {get;set;}
        @RemoteAction
        public boolean canAccept {get;set;}
        @RemoteAction
        public boolean canSaveComplete {get;set;}
        @RemoteAction
        public boolean canComplete {get;set;}
        @RemoteAction
        public boolean showCompleteForm {get;set;}
        @RemoteAction
        public boolean canRating {get;set;}
        @RemoteAction
        public boolean showRatingForm {get;set;}
        @RemoteAction
        public boolean showRatingFormOBH {get;set;}
        @RemoteAction
        public boolean isPRTRUser {get;set;}
        @RemoteAction
        public boolean canOnlyOnBehalf {get;set;}
        @RemoteAction
        public string completedBy {get;set;}
        @RemoteAction
        public string completedByEmail {get;set;}
    }

    public class FixAndGeneralCardDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public boolean isOnBehalf {get;set;}
        //enum FixAndGeneralDocumentStatus
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
        //enum FixTypeOfService
        @RemoteAction
        public ESS_Global.EnumValue typeOfService {get;set;}
        @RemoteAction
        public string topic {get;set;}
        //วันที่ต้องการให้แล้วเสร็จ
        @RemoteAction
        public datetime expectedDueDate {get;set;}
        @RemoteAction
        public string requesterDisplayName {get;set;}
        @RemoteAction
        public datetime createdDate {get;set;}
        @RemoteAction
        public datetime completedDate {get;set;}
        @RemoteAction
        public datetime rejectedDate {get;set;}

        //Accepted By
        @RemoteAction
        public string pmsvEmployeeName {get;set;}
        @RemoteAction
        public string rejectComment {get;set;}
        
        //สำหรับใช้กับการ verify multiple document
        @RemoteAction
        public boolean isSelected {get;set;}
    }

    public class TransportationItemDTO {
        public ESS_Global.EnumValue transportationType {get;set;}
        public string transportationNo {get;set;}
        public string detail {get;set;}
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
    
    public class FixAndGeneralExcelDTO {
        public string documentNo {get;set;}
        public string documentType {get;set;}
        public string serviceType {get;set;}
        public string topic {get;set;}
        public string detail {get;set;}
        public datetime repairDate {get;set;}
        public datetime expectedDueDate {get;set;}
        public string repairArea {get;set;}
        public string building {get;set;}
        public string floor {get;set;}
        public datetime repairTime {get;set;}
        public string houseNo {get;set;}
        public string period {get;set;}
        public string houseType {get;set;}
        public string telNo {get;set;}
        public string mobileNo {get;set;}
        public string typeOfService {get;set;}
        public string typeOfServiceOther {get;set;}
        public decimal cost {get;set;}
        public string moreDetail {get;set;}
        public string internalDetail {get;set;}
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
        public datetime acceptedDate {get;set;}
        public datetime completedDate {get;set;}
        public datetime rejectedDate {get;set;}
        public datetime cancelledDate {get;set;}
        public string acceptedBy {get;set;}
        public string completedBy {get;set;}
        public string cancelledBy {get;set;}
        public string rejectComment {get;set;}
        public string cancelComment {get;set;}
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
        public string verifyStatus {get;set;}
        public string obhComment {get;set;}
        public datetime verifiedRejectedDate {get;set;}
        public string location {get;set;}
        public string transportationType {get;set;}
        public string transportationNo {get;set;}
        public string transportationDetail {get;set;}
    }
}