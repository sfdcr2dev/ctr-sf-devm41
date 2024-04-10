public class OPP_NewsJobHelper {

    public static void setDraftToPublished() {
        List<OPP_News__c> oppNewsList = [SELECT Id, Status__c FROM OPP_News__c WHERE Status__c = 'Draft' AND Publish_Date__c <= TODAY ORDER BY LastModifiedDate ASC];
        for (OPP_News__c oppNews : oppNewsList) {
            oppNews.Status__c = 'Published';
        }
        update oppNewsList;
    }

    public static void setPublishedToExpired() {
        List<OPP_News__c> oppNewsList = [SELECT Id, Status__c FROM OPP_News__c WHERE Status__c = 'Published' AND Expire_Date__c <= TODAY ORDER BY LastModifiedDate ASC];
        for (OPP_News__c oppNews : oppNewsList) {
            oppNews.Status__c = 'Expired';
        }
        update oppNewsList;
    }

}