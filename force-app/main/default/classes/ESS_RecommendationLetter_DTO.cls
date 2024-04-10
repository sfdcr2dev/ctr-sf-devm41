/* Author Softever */
public class ESS_RecommendationLetter_DTO {

    public class RecommendationLetterCountDTO {
        @RemoteAction
        public integer total {get;set;}
        @RemoteAction
        public integer requested {get;set;}
        @RemoteAction
        public integer remaining {get;set;}
        @RemoteAction
        public boolean canCreate {get;set;}
        @RemoteAction
        public string companyName {get;set;}
    }
    
    public class RecommendationLetterListDTO {
        @RemoteAction
        public string letterId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        //enum RecommendationLetterType
        @RemoteAction
        public ESS_Global.EnumValue letterType {get;set;}
        //enum RecommendationLetterLanguage
        @RemoteAction
        public ESS_Global.EnumValue language {get;set;}
        @RemoteAction
        public string purpose {get;set;}
        @RemoteAction
        public string toOrganization {get;set;}
        @RemoteAction
        public datetime createdDate {get;set;}
        @RemoteAction
        public datetime generatedDate {get;set;}
        //enum RecommendationLetterStatus
        @RemoteAction
        public ESS_Global.EnumValue letterStatus {get;set;}
        @RemoteAction
        public boolean canDelete {get;set;}
        
    }
    
    public class RecommendationLetterDetailDTO {
        @RemoteAction
        public string letterId {get;set;}
        @RemoteAction
        public boolean canCreate {get;set;}
        @RemoteAction
        public string gender {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string employeeNameTH {get;set;}
        @RemoteAction
        public string companyName {get;set;}
        @RemoteAction
        public string position {get;set;}
        @RemoteAction
        public string positionTH {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string departmentFullTH {get;set;}
        @RemoteAction
        public string departmentFullEN {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
        @RemoteAction
        public date dateJoinedCompany {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public date createdDate {get;set;}
        @RemoteAction
        public date generatedDate {get;set;}
        //enum RecommendationLetterStatus
        @RemoteAction
        public ESS_Global.EnumValue letterStatus {get;set;}
        //enum RecommendationLetterType
        @RemoteAction
        public ESS_Global.EnumValue letterType {get;set;}
        //enum RecommendationLetterLanguage
        @RemoteAction
        public ESS_Global.EnumValue language {get;set;}
        @RemoteAction
        public string purpose {get;set;}
        @RemoteAction
        public string organization {get;set;}
        @RemoteAction
        public string otherOrganization {get;set;}
        @RemoteAction
        public date startLeaveDate {get;set;}
        @RemoteAction
        public date endLeaveDate {get;set;}
        @RemoteAction
        public boolean isShowOtherOrganization {get;set;}
        @RemoteAction
        public boolean isShowLeaveDate {get;set;}
        @RemoteAction
        public integer remaining {get;set;}
        @RemoteAction
        public string letterLogo {get;set;}
        @RemoteAction
        public string letterHRPosition {get;set;}
        @RemoteAction
        public string letterHRPositionTH {get;set;}
        @RemoteAction
        public string letterHRNameTH {get;set;}
        @RemoteAction
        public string letterHRNameEN {get;set;}
        @RemoteAction
        public string letterHRSignatureTH {get;set;}
        @RemoteAction
        public string letterHRSignatureEN {get;set;}
        @RemoteAction
        public string letterStamp {get;set;}
    }
}