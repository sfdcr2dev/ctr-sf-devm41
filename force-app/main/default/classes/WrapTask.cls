public class WrapTask {
    @AuraEnabled public String appName { get; set; }
    @AuraEnabled public Integer tasks { get; set; }
    @AuraEnabled public List<OPP_Notification__c> notifications { get; set; }
}