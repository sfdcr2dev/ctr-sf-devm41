public class OPP_FavAppWrap {
    @AuraEnabled public Id favAppId { get; set; }
    @AuraEnabled public String appName { get; set; }
    @AuraEnabled public String url { get; set; }
    @AuraEnabled public String ios { get; set; }
    @AuraEnabled public String android { get; set; }
    @AuraEnabled public Id fileId { get; set; }
}