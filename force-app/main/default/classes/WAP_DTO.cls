/* 
 * Author Softever
 */

public class WAP_DTO {

    public class HeaderMapDTO {
        @RemoteAction
        public integer totalClearanceCertificate {get;set;}
        @RemoteAction
        public integer totalHighRiskWork {get;set;}
        @RemoteAction
        public integer totalHotWork {get;set;}
        @RemoteAction
        public integer totalSimop {get;set;}
    }
    
    public class WorkMapDTO {
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string link {get;set;}
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string latitude {get;set;}
        @RemoteAction
        public string longitude {get;set;}
        //enum WorkClearanceStatus
        @RemoteAction
        public WAP_Global.EnumValue workClearanceStatus {get;set;}
        //enum Status
        @RemoteAction
        public WAP_Global.EnumValue userStatus {get;set;}
        //enum HighRiskWork
        @RemoteAction
        public WAP_Global.EnumValue highRiskWork {get;set;} //Type Of Work
        @RemoteAction
        public string description {get;set;} //Functional Location
        @RemoteAction
        public string mainWorkCenterText {get;set;} //Area
        @RemoteAction
        public string workDetail {get;set;}
        @RemoteAction
        public string safetyPermit1 {get;set;}
        @RemoteAction
        public string safetyPermit2 {get;set;}
        @RemoteAction
        public string safetyPermit3 {get;set;}
        @RemoteAction
        public boolean isCheckingGas {get;set;}
        @RemoteAction
        public decimal flamableAmt {get;set;}
        @RemoteAction
        public decimal oxygenAmt {get;set;}
        @RemoteAction
        public decimal toxicPPM {get;set;}
        @RemoteAction
        public string agtUI {get;set;}
        @RemoteAction
        public date checkDateUI {get;set;}
        @RemoteAction
        public time checkTimeUI {get;set;}
        @RemoteAction
        public string authorizedSignatoryUI {get;set;}
        @RemoteAction
        public date authorizedDateUI {get;set;}
        @RemoteAction
        public time authorizedTimeUI {get;set;}
        @RemoteAction
        public boolean extendTimeFlagFormula {get;set;}
        @RemoteAction
        public date extendDate {get;set;}
        @RemoteAction
        public time extendTime {get;set;}
        @RemoteAction
        public time extendTimeToUI {get;set;}
        @RemoteAction
        public string extendApplicantOrBearerUI {get;set;}
        @RemoteAction
        public string extendAuthorizedSignUI {get;set;}
        @RemoteAction
        public boolean signOffFlagFormula {get;set;}
        @RemoteAction
        public string closeApplicantOrBearerUI {get;set;}
        @RemoteAction
        public string closeAuthorizedSignOffUI {get;set;}
    }
    
    public class TypeOfWorkCountDTO {
        @RemoteAction
        public integer allCount {get;set;}
        @RemoteAction
        public integer generalCount {get;set;}
        @RemoteAction
        public integer hotWorkCount {get;set;}
        @RemoteAction
        public integer confinedSpaceCount {get;set;}
        @RemoteAction
        public integer craneCount {get;set;}
        @RemoteAction
        public integer radiationCount {get;set;}
        @RemoteAction
        public integer jackHammerCount {get;set;}
        @RemoteAction
        public integer highPressureWaterJetCount {get;set;}
        @RemoteAction
        public integer diggingCount {get;set;}
        @RemoteAction
        public integer workAtHeightCount {get;set;}
        @RemoteAction
        public integer onlineStopLeakCount {get;set;}
        @RemoteAction
        public integer nonTypeOfWorkCount {get;set;}
    }
    
    //SafetyPermitReport
    public class SafetyPermitReportDTO {
        @RemoteAction
        public string url {get;set;}
        @RemoteAction
        public string id {get;set;}
        @RemoteAction
        public string no {get;set;}
        @RemoteAction
        public string detail {get;set;}
        @RemoteAction
        public string workingArea {get;set;}
        @RemoteAction
        public date startDate {get;set;}
        @RemoteAction
        public date endDate {get;set;}
        @RemoteAction
        public date firstExtendDate {get;set;}
        @RemoteAction
        public date firstExpiredDate {get;set;}
        @RemoteAction
        public date secondExtendDate {get;set;}
        @RemoteAction
        public date secondExpiredDate {get;set;}
        @RemoteAction
        public date thirdExtendDate {get;set;}
        @RemoteAction
        public date thirdExpiredDate {get;set;}
    }
    
    public class SafetyPermitChartSeriesDTO {
        @RemoteAction
        public List<string> categories {get;set;}
        @RemoteAction
        public List<SafetyPermitChartSerieItemDTO> series {get;set;}
    }
    
    public class SafetyPermitChartSerieItemDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public List<decimal> data {get;set;}
    }
    
    //Dashboard
    public class DashboardHRWChartSeriesDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public List<DashboardHRWChartSerieItemDTO> data {get;set;}
    }
    
    public class DashboardHRWChartSerieItemDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public decimal y {get;set;}
    }
    
    public class DashboardChartSeriesDTO {
        @RemoteAction
        public List<string> categories {get;set;}
        @RemoteAction
        public List<DashboardChartSerieItemDTO> series {get;set;}
    }
    
    public class DashboardChartSerieItemDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public string color {get;set;}
        @RemoteAction
        public List<decimal> data {get;set;}
    }
    
    public class DashboardPieChartSeriesDTO {
        @RemoteAction
        public List<DashboardPieChartSeriesItemDTO> data {get;set;}
    }
    
    public class DashboardPieChartSeriesItemDTO {
        @RemoteAction
        public string name {get;set;}
        @RemoteAction
        public integer y {get;set;}
        @RemoteAction
        public string color {get;set;}
    }
    
}