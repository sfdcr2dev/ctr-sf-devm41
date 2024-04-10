public class OPP_ApplicationController {

    @AuraEnabled
    public static List<String> getCategoryPicklistValuesIntoList() {
        List<String> categoryPicklistValueList = new List<String>();
        Schema.DescribeFieldResult fieldResult = OPP_Application__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntryList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry picklistEntry : picklistEntryList) {
            categoryPicklistValueList.add(picklistEntry.getLabel());
        }
        return categoryPicklistValueList;
    }
    
    @AuraEnabled
    public static List<OPP_Application__c> getActiveApplications() {
        return [SELECT Id,Name,Icon__c,Description__c,Category__c,URL_Web__c,URL_Android__c,URL_IOS__c,Default__c,(SELECT ContentDocumentId,SystemModstamp FROM ContentDocumentLinks ORDER BY SystemModstamp DESC),
                (SELECT Id,OPP_Application__c FROM OPP_Favorite_Application__r WHERE User__c =:UserInfo.getUserId()) FROM OPP_Application__c WHERE Is_Deleted__c = false ORDER BY Name	];
    }
    
    @AuraEnabled
    public static List<OPP_Application__c> getActiveApplicationInCategory(String category) {
        return [SELECT Id,Name,Icon__c,Description__c,Category__c FROM OPP_Application__c WHERE Category__c = :category AND Is_Deleted__c = false ORDER BY Name];
    }

    @AuraEnabled
    public static List<OPP_Application__c> getNotificationApplications() {
        return [ SELECT Id,Name,Icon__c,Description__c,Category__c,URL_Web__c,(SELECT Id,OPP_Application__c FROM OPP_Favorite_Application__r WHERE User__c =: UserInfo.getUserId()) FROM OPP_Application__c WHERE Is_Deleted__c = false AND Notification__c = true];
    }
    
    @AuraEnabled
    public static List<OPP_Application__c> getOtherApplications() {
        return [SELECT Id,Name,Icon__c,Description__c,Category__c,URL_Web__c,(SELECT Id, OPP_Application__c FROM OPP_Favorite_Application__r WHERE User__c =: UserInfo.getUserId()) FROM OPP_Application__c WHERE Is_Deleted__c = false AND Category__c = null];
    }

    @AuraEnabled
    public static List<OPP_Notification__c> getListofNotifications(String AppId)
    {
        List<OPP_Notification__c> Notifications=([Select ApplicationName__c,Application__c,Subject__c,Description__c,URL__c,ReferenceID__c,CreatedDate from OPP_Notification__c where Application__c=:AppId AND User__c =:UserInfo.getUserId()]);    
        return Notifications;
    }
    
    @AuraEnabled
    public static AggregateResult[] countNotificationGroupByApplication() {
        Id userId = UserInfo.getUserId();
    	AggregateResult[] aggregateResults = [SELECT Application__c, COUNT(Id) Count__c FROM OPP_Notification__c WHERE User__c =:userId GROUP BY Application__c];
        return aggregateResults;
    }

    @AuraEnabled
    public static List<OPP_Application__c> getApplications(){
        try {
            List<OPP_Application__c> applications = [SELECT Id, Name, Icon__c, URL_Web__c, Category__c,URL_Android__c, URL_IOS__c, (SELECT ContentDocumentId FROM ContentDocumentLinks ORDER BY SystemModstamp DESC LIMIT 1),
                                                     (SELECT Id, OPP_Application__c FROM OPP_Favorite_Application__r WHERE User__c =: UserInfo.getUserId()) FROM OPP_Application__c];
            return applications;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Integer getCountApplications(){
        try {
            Integer count =[SELECT COUNT() FROM OPP_Favorite_Application__c WHERE User__c =: UserInfo.getUserId() AND OPP_Application__c != NULL];
            return count;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OPP_Favorite_Application__c> getDefaultApplications(){
        try {
            List<OPP_Favorite_Application__c> applications =[SELECT Id, OPP_Application__c FROM OPP_Favorite_Application__c WHERE User__c =: UserInfo.getUserId()];
            return applications;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean updateFavApps(String jsonString){
        try {
            Set<Id> setFavAppIds = (Set<Id>)JSON.deserialize(jsonString, Set<Id>.class);
            List<OPP_Favorite_Application__c> oppFavApps = new List<OPP_Favorite_Application__c>();
            Map<String, OPP_Favorite_Application__c> mapOPPFavApps = new Map<String, OPP_Favorite_Application__c>();
            if (setFavAppIds.size() > 0)
            {
                Integer i;
                Integer count = 6 - setFavAppIds.size();
             
                List<OPP_Favorite_Application__c> favApps = [SELECT Id, OPP_Application__c, No__c FROM OPP_Favorite_Application__c WHERE User__c =: UserInfo.getUserId() AND OPP_Application__c NOT IN: setFavAppIds];
                List<OPP_Favorite_Application__c> allFavApps = [SELECT Id, OPP_Application__c, No__c FROM OPP_Favorite_Application__c WHERE User__c =: UserInfo.getUserId()];
                for(OPP_Favorite_Application__c allFavApp : allFavApps) {
                    for(Id setFavAppId : setFavAppIds) {
                        if(allFavApp.OPP_Application__c == setFavAppId) {
                            setFavAppIds.remove(allFavApp.OPP_Application__c);
                        }
                    }
                }
                if(setFavAppIds.size() > 0) {
                    List<Id> favAppIds = new List<Id>(setFavAppIds);
                    for(i=0; i<favAppIds.size(); i++) {
                        OPP_Favorite_Application__c favApp = favApps.get(i);
                        favApp.OPP_Application__c = favAppIds.get(i);
                        oppFavApps.add(favApp);
                    }   
                }
                else {
                    for(i=0; i<count; i++) {
                        OPP_Favorite_Application__c favApp = favApps.get(i);
                        favApp.OPP_Application__c = null;
                        oppFavApps.add(favApp);
                    }
                }
                update oppFavApps;
                return true;
            }
            return false;
       } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}