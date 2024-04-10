/* Author Softever */
public class ESS_RecommendationLetterReport_DTO {

    //RecommendationLetter
    public class RecommendationLetterTableDTO {
        @RemoteAction
        public string recordId {get;set;}
        @RemoteAction
        public string documentNo {get;set;}
        @RemoteAction
        public string employeeId {get;set;}
        @RemoteAction
        public string employeeName {get;set;}
        @RemoteAction
        public string position {get;set;}
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
        public date createdDate {get;set;}
        @RemoteAction
        public date generatedDate {get;set;}
        //enum RecommendationLetterStatus
        @RemoteAction
        public ESS_Global.EnumValue status {get;set;}
        @RemoteAction
        public string function {get;set;}
        @RemoteAction
        public string department {get;set;}
        @RemoteAction
        public string section {get;set;}
        @RemoteAction
        public string unit {get;set;}
    }
    
    public class RecommendationLetterGraphDTO {
        @RemoteAction
        public List<string> categories {get;set;}
        @RemoteAction
        public List<RecommendationLetterGraphSeriesDTO> series {get;set;}
    }
    
    public class RecommendationLetterGraphSeriesDTO {
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