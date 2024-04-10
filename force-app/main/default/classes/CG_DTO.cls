public class CG_DTO {
    ////////////////////////GLOBAL//////////////////////////////
    //Global
    public class CompanyDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string name {get;set;}
        //display on dropdown
        @RemoteAction
        public string fullName {get;set;}
    }
    public class UserDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string fullName {get;set;}
        @RemoteAction
        public string email {get;set;}
    }
    public class WorkflowHistoryDTO {
        @RemoteAction
        public string reportId {get;set;}
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public CG_DTO.WorkflowDTO currentWorkflow {get;set;}
        @RemoteAction
        public List<CG_DTO.WorkflowDTO> historyWorkflows {get;set;}

    }
    public class WorkflowDTO {
        @RemoteAction
        public datetime createdDate {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public List<CG_DTO.WorkflowApproverDTO> approvers {get;set;}
    }
    public class WorkflowApproverDTO {
        @RemoteAction
        public Boolean isCurrent {get;set;}
        @RemoteAction
        public Boolean isShow {get;set;}
        @RemoteAction
        public CG_DTO.UserDTO approver {get;set;}
        //enum ApproverRole
        @RemoteAction
        public CG_Global.EnumValue role {get;set;}
        //enum ApproverStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime actionDate {get;set;}
        @RemoteAction
        public string comment {get;set;}
    }
    
    public class DurationDTO {
        public datetime startDate {get;set;}
        public datetime endDate {get;set;}
    }
    ////////////////////////END GLOBAL//////////////////////////////

    ////////////////////////HOME//////////////////////////////
    //Home Page
    public class HomeMenuDTO {
        //main menu flags
        @RemoteAction
        public Boolean coiReporting {get;set;}
        //badge = number of "Waiting for Submit", "Rejected" reports of this logined user which generate from Schedule Batch Job.
        @RemoteAction
        public Integer coiReportingBadge {get;set;}
        @RemoteAction
        public Boolean cgManualReporting {get;set;}
        @RemoteAction
        public Integer cgManualReportingBadge {get;set;}
        @RemoteAction
        public Boolean giftRegistrationReporting {get;set;}
        @RemoteAction
        public Integer giftRegistrationReportingBadge {get;set;}
        @RemoteAction
        public Boolean cgReportHistory {get;set;}
        @RemoteAction
        public Boolean supervisorMassAcknowledge {get;set;}
        @RemoteAction
        public Integer supervisorMassAcknowledgeBadge {get;set;}
        @RemoteAction
        public Boolean glvpMassAcknowledge {get;set;}
        @RemoteAction
        public Integer glvpMassAcknowledgeBadge {get;set;}
        @RemoteAction
        public Boolean glgcAdminMassAcknowledge {get;set;}
        @RemoteAction
        public Integer glgcAdminMassAcknowledgeBadge {get;set;}
        @RemoteAction
        public Boolean report {get;set;}

        //workflow administration flags
        @RemoteAction
        public Boolean reportSetting {get;set;}
        @RemoteAction
        public Boolean coiList {get;set;}
        @RemoteAction
        public Boolean cgManualList {get;set;}
        @RemoteAction
        public Boolean giftRegistrationList {get;set;}
    }
    ////////////////////////END HOME//////////////////////////////

    ////////////////////////COI REPORTING//////////////////////////////
    //COI Reporting Page
    public class COIReportListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum COIReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public Integer badge {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime startDuration {get;set;}
        @RemoteAction
        public datetime endDuration {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public Boolean canEdit {get;set;}
        @RemoteAction
        public Boolean canDelete {get;set;}
    }

    public class COIReportDetailDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime startDuration {get;set;}
        @RemoteAction
        public datetime endDuration {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        //enum COIReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public Boolean agree {get;set;}
        //Conflig of Interest Disclosure Report
        //enum COIDisclosure
        @RemoteAction
        public CG_Global.EnumValue disclosureReport {get;set;}
        //The Transaction with a Trade Agreement
        @RemoteAction
        public CG_DTO.CompanyDTO transactionCompany {get;set;}
        @RemoteAction
        public string transactionOtherCompany {get;set;}
        @RemoteAction
        public Boolean transactionByMe {get;set;}
        @RemoteAction
        public Boolean transactionByOther {get;set;}
        @RemoteAction
        public string transactionByOtherName {get;set;}
        @RemoteAction
        public Boolean transactionByOtherRelation {get;set;}
        @RemoteAction
        public string transactionByOtherRelationName {get;set;}
        @RemoteAction
        public string transactionByOtherRelationship {get;set;}
        //Conflict of Interest Report Detail
        @RemoteAction
        public string coiDetail {get;set;}
        @RemoteAction
        public string coiAction {get;set;}
        //Current Workflow Status
        @RemoteAction
        public CG_DTO.WorkflowDTO currentWorkflow {get;set;}
        //Certification and Reported by
        @RemoteAction
        public string reportedByTH {get;set;}
        @RemoteAction
        public string reportedByEN {get;set;}
        @RemoteAction
        public string reportedByPositionTH {get;set;}
        @RemoteAction
        public string reportedByPositionEN {get;set;}
        @RemoteAction
        public string reportedByCompanyTH {get;set;}
        @RemoteAction
        public string reportedByCompanyEN {get;set;}
        @RemoteAction
        public datetime reportedDate {get;set;}

        //Supervisor Approved by
        @RemoteAction
        public string supervisorActionByTH {get;set;}
        @RemoteAction
        public string supervisorActionByEN {get;set;}
        @RemoteAction
        public string supervisorActionByPositionTH {get;set;}
        @RemoteAction
        public string supervisorActionByPositionEN {get;set;}
        @RemoteAction
        public string supervisorActionByCompanyTH {get;set;}
        @RemoteAction
        public string supervisorActionByCompanyEN {get;set;}
        @RemoteAction
        public datetime supervisorActionDate {get;set;}
        @RemoteAction
        //enum ApproverStatus
        public CG_Global.EnumValue supervisorApproverStatus {get;set;}
        @RemoteAction
        public string supervisorComment {get;set;}
        
        //GLGC Approved by
        @RemoteAction
        public string glgcReceiveBy {get;set;}
        @RemoteAction
        public string glgcActionByTH {get;set;}
        @RemoteAction
        public string glgcActionByEN {get;set;}
        @RemoteAction
        public string glgcActionByPositionTH {get;set;}
        @RemoteAction
        public string glgcActionByPositionEN {get;set;}
        @RemoteAction
        public string glgcActionByCompanyTH {get;set;}
        @RemoteAction
        public string glgcActionByCompanyEN {get;set;}
        //enum ApproverStatus
        public CG_Global.EnumValue glgcApproverStatus {get;set;}
        @RemoteAction
        public datetime glgcActionDate {get;set;}
        
        //GLVP Approved by
        @RemoteAction
        public string glvpActionByTH {get;set;}
        @RemoteAction
        public string glvpActionByEN {get;set;}
        @RemoteAction
        public string glvpActionByPositionTH {get;set;}
        @RemoteAction
        public string glvpActionByPositionEN {get;set;}
        @RemoteAction
        public string glvpActionByCompanyTH {get;set;}
        @RemoteAction
        public string glvpActionByCompanyEN {get;set;}
        @RemoteAction
        public datetime glvpActionDate {get;set;}
        //enum ApproverStatus
        public CG_Global.EnumValue glvpApproverStatus {get;set;}
        @RemoteAction
        public string glvpComment {get;set;}

        //enable all editors and save as draft button
        @RemoteAction
        public Boolean canEdit {get;set;}
        //enable submit button (for employee)
        @RemoteAction
        public Boolean canSubmit {get;set;}
        //enable supervisor acknowledge and reject button
        @RemoteAction
        public Boolean canSupervisorAcknowledge {get;set;}
        //enable GLVP acknowledge button
        @RemoteAction
        public Boolean canGLVPAcknowledge {get;set;}
        //display supervisor acknowledge box
        @RemoteAction
        public Boolean isShowSupervisorComment {get;set;}
        //display glvp acknowledge box
        @RemoteAction
        public Boolean isShowGLVPComment {get;set;}
        
    }

    //COI Report History
    public class COIReportHistoryListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum COIReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public CG_Global.EnumValue disclosureReport {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
    }

    public class COIReportHistoryCountDTO {
        @RemoteAction
        public Integer totalReport {get;set;}
        @RemoteAction
        public Integer newEmployee {get;set;}
        @RemoteAction
        public Integer annual {get;set;}
        @RemoteAction
        public Integer incident {get;set;}
    }

    //COI Mass Acknowledge
    public class COIMassAcknowledgeListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum COIReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public CG_Global.EnumValue disclosureReport {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        //ชื่อผู้รายงาน
        @RemoteAction
        public string ownerName {get;set;}
        //ตำแหน่งผู้รายงาน
        //Company/Function/Department/Section/Unit
        @RemoteAction
        public string ownerPosition {get;set;}
        //หน่วยงานผู้รายงาน
        @RemoteAction
        public string ownerSection {get;set;}
    }

    public class COIMassAcknowledgeCountDTO {
        @RemoteAction
        public Integer totalReport {get;set;}
        @RemoteAction
        public Integer answerNo {get;set;}
        @RemoteAction
        public Integer answerYes {get;set;}
        @RemoteAction
        public Integer answerNotSure {get;set;}
    }

    //Admin COI Report List Page
    public class AdminCOIReportListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum COIReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public Integer badge {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime startDuration {get;set;}
        @RemoteAction
        public datetime endDuration {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        //enum COIDisclosure
        @RemoteAction
        public CG_Global.EnumValue disclosureReport {get;set;}
        @RemoteAction
        public CG_DTO.UserDTO owner {get;set;}
        @RemoteAction
        public Boolean canResend {get;set;}
        @RemoteAction
        public Boolean canCancel {get;set;}
    }

    public class AdminCOIReportListCountDTO {
        @RemoteAction
        public Integer totalReport {get;set;}
        @RemoteAction
        public Integer newEmployee {get;set;}
        @RemoteAction
        public Integer annual {get;set;}
        @RemoteAction
        public Integer incident {get;set;}
    }

    //COI Report Page
    public class ReportCOISummaryCountDTO{
        @RemoteAction
        public Integer totalReport {get;set;}
        @RemoteAction
        public Integer completeReport {get;set;}
        @RemoteAction
        public Integer waitingforSubmitReport {get;set;}
        @RemoteAction
        public Integer waitingSupervisorReport {get;set;}
        @RemoteAction
        public Integer waitingGLVPReport {get;set;}
    }

    public class ReportCOIAnswerChartSeriesDTO {
        @RemoteAction
        public List<CG_DTO.ReportCOIAnswerChartSerieItemDTO> series {get;set;}
    }

    public class ReportCOIAnswerChartSerieItemDTO{
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public Integer y {get;set;}
        @RemoteAction
        public Integer count {get;set;}
    }

    public class ReportCOITypeRadialChartItemDTO{
        //enum COIReportType
        @RemoteAction
        public string type {get;set;}
        @RemoteAction
        public Double percent {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public Integer count {get;set;}
    }

    public class ReportCOIStatusSeriesDTO {
        @RemoteAction
        public string category {get;set;}
        @RemoteAction
        public List<CG_DTO.ReportCOIStatusSerieItemDTO> series {get;set;}
    }

    public class ReportCOIStatusSerieItemDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public List<Integer> data {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public string stack {get;set;}
    }

    public class ReportCOIInfoDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum COIReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public CG_DTO.UserDTO owner {get;set;}
        //Function/Department/Section/Unit
        @RemoteAction
        public string ownerOrgFunction {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
    }

    public class ReportCOIStatisticDTO {
        @RemoteAction
        public List<CG_DTO.ReportCOIStatisticFunctionDTO> functions {get;set;}
        @RemoteAction
        public CG_DTO.ReportCOIStatisticFunctionTotalDTO total {get;set;}
    }

    public class ReportCOIStatisticFunctionDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public Integer all {get;set;}
        @RemoteAction
        public Integer waitingForSubmit {get;set;}
        @RemoteAction
        public Integer waitingSupervisor {get;set;}
        @RemoteAction
        public Integer waitingGLVP {get;set;}
        @RemoteAction
        public Integer completed {get;set;}
        @RemoteAction
        public List<CG_DTO.ReportCOIStatisticFunctionDTO> childFunctions {get;set;}
    }

    public class ReportCOIStatisticFunctionTotalDTO {
        @RemoteAction
        public Integer all {get;set;}
        @RemoteAction
        public Integer waitingForSubmit {get;set;}
        @RemoteAction
        public Integer waitingSupervisor {get;set;}
        @RemoteAction
        public Integer waitingGLVP {get;set;}
        @RemoteAction
        public Integer completed {get;set;}
    }
    ////////////////////////END COI REPORTING//////////////////////////////

    ////////////////////////CG MANUAL REPORTING///////////////////////////
    //CG Manual Reporting Page
    public class CGManualFilesDTO {
        @RemoteAction
        public string manualENFileUrl {get;set;}
        @RemoteAction
        public string manualTHFileUrl {get;set;}
    }
    
    public class CGAcknowledgeFormDTO {
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public date submittedDate {get;set;}
    }

    public class CGManualReportListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum CGReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public Integer badge {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime startDuration {get;set;}
        @RemoteAction
        public datetime endDuration {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public string fileUrl {get;set;}
    }

    public class CGManualReportDetailDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum CGReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public Integer badge {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime startDuration {get;set;}
        @RemoteAction
        public datetime endDuration {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public string detail {get;set;}
        @RemoteAction
        public string fileUrlTH {get;set;}
        @RemoteAction
        public string fileUrlEN {get;set;}
        @RemoteAction
        public string imageUrl1 {get;set;}
        @RemoteAction
        public string imageUrl2 {get;set;}
        @RemoteAction
        public string imageUrl3 {get;set;}
        @RemoteAction
        public string imageUrl4 {get;set;}
        //Acknowledge
        //I have received the Good Corporate Governance and Code of Conduct Manual.
        @RemoteAction
        public Boolean haveReceived {get;set;}
        //I will study and observe the contents contained in this manual, ...
        @RemoteAction
        public Boolean willStudy {get;set;}
        //User has clicked the button to download one of the manual
        @RemoteAction
        public Boolean haveDownloaded {get;set;}
        //Show Manual Section
        @RemoteAction
        public Boolean isShowManual {get;set;}
        //Show Submit Button
        @RemoteAction
        public Boolean canSubmit {get;set;}
        //Report by
        @RemoteAction
        public string reportedByTH {get;set;}
        @RemoteAction
        public string reportedByEN {get;set;}
        @RemoteAction
        public string reportedByEmployeeID {get;set;}
        @RemoteAction
        public datetime reportedDate {get;set;}

    }

    //Admin CG Report List Page
    public class AdminCGReportListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum CGReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public Integer badge {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime startDuration {get;set;}
        @RemoteAction
        public datetime endDuration {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public CG_DTO.UserDTO owner {get;set;}
        @RemoteAction
        public Boolean canResend {get;set;}
        @RemoteAction
        public Boolean canCancel {get;set;}
    }

    public class AdminCGReportListCountDTO {
        @RemoteAction
        public Integer totalReport {get;set;}
        @RemoteAction
        public Integer newEmployee {get;set;}
        @RemoteAction
        public Integer annual {get;set;}
        @RemoteAction
        public Integer newCGManual {get;set;}
    }

    //CG Report Page
    public class ReportCGSummaryCountDTO{
        @RemoteAction
        public Integer totalReport {get;set;}
        @RemoteAction
        public Integer completeReport {get;set;}
        @RemoteAction
        public Integer waitingforSubmitReport {get;set;}
    }

    public class ReportCGTypeRadialChartItemDTO{
        //enum CGReportType
        @RemoteAction
        public string type {get;set;}
        @RemoteAction
        public Double percent {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public Integer count {get;set;}
    }

    public class ReportCGStatusSeriesDTO {
        @RemoteAction
        public string category {get;set;}
        @RemoteAction
        public List<CG_DTO.ReportCGStatusSerieItemDTO> series {get;set;}
    }

    public class ReportCGStatusSerieItemDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public List<Integer> data {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public string stack {get;set;}
    }

    public class ReportCGInfoDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum CGReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public CG_DTO.UserDTO owner {get;set;}
        //Function/Department/Section/Unit
        @RemoteAction
        public string ownerOrgFunction {get;set;}
        @RemoteAction
        public string supervisorDecision {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public string fileUrl {get;set;}
    }

    public class ReportCGStatisticDTO {
        @RemoteAction
        public List<CG_DTO.ReportCGStatisticFunctionDTO> functions {get;set;}
        @RemoteAction
        public CG_DTO.ReportCGStatisticFunctionTotalDTO total {get;set;}
    }

    public class ReportCGStatisticFunctionDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public Integer all {get;set;}
        @RemoteAction
        public Integer waitingForSubmit {get;set;}
        @RemoteAction
        public Integer completed {get;set;}
        @RemoteAction
        public List<CG_DTO.ReportCGStatisticFunctionDTO> childFunctions {get;set;}
    }

    public class ReportCGStatisticFunctionTotalDTO {
        @RemoteAction
        public Integer all {get;set;}
        @RemoteAction
        public Integer waitingForSubmit {get;set;}
        @RemoteAction
        public Integer completed {get;set;}
    }

    //CG Report History
    public class CGReportHistoryListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum CGReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
    }

    public class CGReportHistoryCountDTO {
        @RemoteAction
        public Integer totalReport {get;set;}
        @RemoteAction
        public Integer newEmployee {get;set;}
        @RemoteAction
        public Integer annual {get;set;}
        @RemoteAction
        public Integer manual {get;set;}
    }
    ////////////////////////END CG MANUAL REPORTING///////////////////////

    ////////////////////////GIFT REPORTING///////////////////////////

    public class GiftItemDTO {
        public String name {get;set;}
        public String receivedFrom {get;set;}
        public Decimal giftValue {get;set;}
        public Datetime submittedDate {get;set;} 
        public CG_Global.EnumValue giftStatus {get;set;}
        public string giftDonatedComment {get;set;}
    }

    public class GiftReportListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        //enum ReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public datetime lastUpdated {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public Boolean canEdit {get;set;}
        @RemoteAction
        public Boolean canDelete {get;set;}
    }

    public class GiftReportDetailDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        //enum ReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public string giftStatus {get;set;}
        @RemoteAction
        public datetime lastUpdated {get;set;}
        @RemoteAction
        public datetime submittedWithinDate {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public List<CG_DTO.GiftItemDTO> giftItems {get;set;}
        //Current Workflow Status
        @RemoteAction
        public CG_DTO.WorkflowDTO currentWorkflow {get;set;}
        //Certification and Reported by
        @RemoteAction
        public string reportedByEmployeeId {get;set;}
        @RemoteAction
        public string reportedByDepartment {get;set;}
        @RemoteAction
        public string reportedBySection {get;set;}
        @RemoteAction
        public string reportedByFunction {get;set;}
        @RemoteAction
        public string reportedByTH {get;set;}
        @RemoteAction
        public string reportedByEN {get;set;}
        @RemoteAction
        public string reportedByPositionTH {get;set;}
        @RemoteAction
        public string reportedByPositionEN {get;set;}
        @RemoteAction
        public string reportedByCompanyTH {get;set;}
        @RemoteAction
        public string reportedByCompanyEN {get;set;}
        @RemoteAction
        public datetime reportedDate {get;set;}

        //Supervisor Approved by
        @RemoteAction
        public string supervisorActionByTH {get;set;}
        @RemoteAction
        public string supervisorActionByEN {get;set;}
        @RemoteAction
        public string supervisorActionByPositionTH {get;set;}
        @RemoteAction
        public string supervisorActionByPositionEN {get;set;}
        @RemoteAction
        public string supervisorActionByCompanyTH {get;set;}
        @RemoteAction
        public string supervisorActionByCompanyEN {get;set;}
        @RemoteAction
        public datetime supervisorActionDate {get;set;}
        @RemoteAction
        //enum ApproverStatus
        public CG_Global.EnumValue supervisorApproverStatus {get;set;}
        @RemoteAction
        public string supervisorComment {get;set;}
        
        //GLGC Approved by
        @RemoteAction
        public string glgcReceiveBy {get;set;}
        @RemoteAction
        public string glgcActionByTH {get;set;}
        @RemoteAction
        public string glgcActionByEN {get;set;}
        @RemoteAction
        public string glgcActionByPositionTH {get;set;}
        @RemoteAction
        public string glgcActionByPositionEN {get;set;}
        @RemoteAction
        public string glgcActionByCompanyTH {get;set;}
        @RemoteAction
        public string glgcActionByCompanyEN {get;set;}
        //enum ApproverStatus
        public CG_Global.EnumValue glgcApproverStatus {get;set;}
        @RemoteAction
        public datetime glgcActionDate {get;set;}
        @RemoteAction
        public string glgcReceivedBy {get;set;}
        
        //GLVP Approved by
        @RemoteAction
        public string glvpActionByTH {get;set;}
        @RemoteAction
        public string glvpActionByEN {get;set;}
        @RemoteAction
        public string glvpActionByPositionTH {get;set;}
        @RemoteAction
        public string glvpActionByPositionEN {get;set;}
        @RemoteAction
        public string glvpActionByCompanyTH {get;set;}
        @RemoteAction
        public string glvpActionByCompanyEN {get;set;}
        @RemoteAction
        public datetime glvpActionDate {get;set;}
        //enum ApproverStatus
        public CG_Global.EnumValue glvpApproverStatus {get;set;}
        @RemoteAction
        public string glvpComment {get;set;}
        
        //enable all editors and save as draft button
        @RemoteAction
        public Boolean canEdit {get;set;}
        //enable submit button (for employee)
        @RemoteAction
        public Boolean canSubmit {get;set;}
        //enable supervisor acknowledge and reject button
        @RemoteAction
        public Boolean canSupervisorAcknowledge {get;set;}
        //enable GLVP acknowledge and reject button
        @RemoteAction
        public Boolean canGLVPAcknowledge {get;set;}
        //enable GLGC acknowledge and reject button
        @RemoteAction
        public Boolean canGLGCAcknowledge {get;set;}
        @RemoteAction
        public Boolean isShowSupervisorComment {get;set;}
        @RemoteAction
        public Boolean isShowSuperGLGCComment {get;set;}
        @RemoteAction
        public Boolean isShowSuperGLVPComment {get;set;}
        @RemoteAction
        public Boolean isShowGiftStatus {get;set;}
    }

    public class GiftMassAcknowledgeCountDTO {
        @RemoteAction
        public Integer totalReport {get;set;}
        @RemoteAction
        public boolean isShowAcknowledgeButton {get;set;}
    }

    //Gift Mass Acknowledge
    public class GiftMassAcknowledgeListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum ReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        //ชื่อผู้รายงาน
        @RemoteAction
        public string ownerName {get;set;}
        //ตำแหน่งผู้รายงาน
        //Company/Function/Department/Section/Unit
        @RemoteAction
        public string ownerPosition {get;set;}
        //หน่วยงานผู้รายงาน
        @RemoteAction
        public string ownerSection {get;set;}
    }
    
    //Admin Gift Report List Page
    public class AdminGiftReportListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        //enum ReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        //enum ApproverStatus
        public CG_Global.EnumValue supervisorApproverStatus {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public string giftStatus {get;set;}
        @RemoteAction
        public datetime lastUpdated {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public CG_DTO.UserDTO owner {get;set;}
        @RemoteAction
        public Boolean canResend {get;set;}
        @RemoteAction
        public Boolean canCancel {get;set;}
    }
    
    public class AdminGiftReportListCountDTO {
        @RemoteAction
        public Integer totalReport {get;set;}
    }
    
    //Gift Report Page
    public class ReportGiftSummaryCountDTO{
        @RemoteAction
        public Integer totalReport {get;set;}
        @RemoteAction
        public Integer completeReport {get;set;}
        @RemoteAction
        public Integer waitingSupervisor {get;set;}
        @RemoteAction
        public Integer waitingGLGC {get;set;}
        @RemoteAction
        public Integer waitingGLVP {get;set;}
    }
    
    public class ReportGiftTypeRadialChartItemDTO{
        //enum status
        @RemoteAction
        public string status {get;set;}
        @RemoteAction
        public Double percent {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public Integer count {get;set;}
    }
    
    public class ReportGiftStatusChartSeriesDTO {
        @RemoteAction
        public List<CG_DTO.ReportGiftStatusChartSerieItemDTO> series {get;set;}
    }

    public class ReportGiftStatusChartSerieItemDTO{
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public Integer y {get;set;}
        @RemoteAction
        public Integer count {get;set;}
    }
    
    public class ReportGiftStatusSeriesDTO {
        @RemoteAction
        public string category {get;set;}
        @RemoteAction
        public List<CG_DTO.ReportGiftStatusSerieItemDTO> series {get;set;}
    }

    public class ReportGiftStatusSerieItemDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public List<Integer> data {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public string stack {get;set;}
    }
    
    public class ReportGiftInfoDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        //enum CGReportType
        @RemoteAction
        public CG_Global.EnumValue reportType {get;set;}
        @RemoteAction
        public CG_DTO.UserDTO owner {get;set;}
        //Function/Department/Section/Unit
        @RemoteAction
        public string ownerOrgFunction {get;set;}
        @RemoteAction
        public string supervisorDecision {get;set;}
        //enum ReportStatus
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
        @RemoteAction
        public string giftStatus {get;set;}
        @RemoteAction
        public datetime lastUpdated {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public string fileUrl {get;set;}
    }
    
    public class ReportGiftStatisticDTO {
        @RemoteAction
        public List<CG_DTO.ReportGiftStatisticFunctionDTO> functions {get;set;}
        @RemoteAction
        public CG_DTO.ReportGiftStatisticFunctionTotalDTO total {get;set;}
    }

    public class ReportGiftStatisticFunctionDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public Integer all {get;set;}
        @RemoteAction
        public Integer waitingSupervisor {get;set;}
        @RemoteAction
        public Integer waitingGLGC {get;set;}
        @RemoteAction
        public Integer waitingGLVP {get;set;}
        @RemoteAction
        public Integer completed {get;set;}
        @RemoteAction
        public List<CG_DTO.ReportGiftStatisticFunctionDTO> childFunctions {get;set;}
    }

    public class ReportGiftStatisticFunctionTotalDTO {
        @RemoteAction
        public Integer all {get;set;}
        @RemoteAction
        public Integer waitingSupervisor {get;set;}
        @RemoteAction
        public Integer waitingGLGC {get;set;}
        @RemoteAction
        public Integer waitingGLVP {get;set;}
        @RemoteAction
        public Integer completed {get;set;}
    }
    
    //Gift Report History
    public class GiftReportHistoryListDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string reportNumber {get;set;}
        @RemoteAction
        public string supervisorName {get;set;}
        @RemoteAction
        public datetime submittedDate {get;set;}
        @RemoteAction
        public CG_Global.EnumValue status {get;set;}
    }

    public class GiftReportHistoryCountDTO {
        @RemoteAction
        public Integer totalReport {get;set;}
    }

    ////////////////////////END GIFT REPORTING///////////////////////
    
    public class ContractDTO {
        public string ContractID {get;set;}
        public boolean Status {get;set;}
    }
    
    ////////////////////////NOTIFICATION///////////////////////
    public class BellNotiDTO {
        public string NotificationName {get;set;}
        public string Title {get;set;}
        public string Body {get;set;}
        public Set<string> Receivers {get;set;}
        public string RecordId {get;set;}
        public string PageRef {get;set;}
    }
    
    public class OppNotiDTO {
        public string ApplicationId {get;set;}
        public string ApproverId {get;set;}
        public string Subject {get;set;}
        public string Description {get;set;}
        public string RequesterName {get;set;}
        public string Status {get;set;}
        public string URL {get;set;}
        public string ReferenceId {get;set;}
    }
    
    public class BatchDTO {
        public Messaging.SingleEmailMessage sendEmail {get;set;}
        public CG_DTO.BellNotiDTO bellNoti {get;set;}
        public CG_DTO.OppNotiDTO oppNoti {get;set;}
        public CG_DTO.BellNotiDTO bellNoti2 {get;set;}
        public CG_DTO.OppNotiDTO oppNoti2 {get;set;}
    }
}