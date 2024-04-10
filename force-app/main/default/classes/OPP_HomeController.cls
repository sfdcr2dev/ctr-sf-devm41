public with sharing class OPP_HomeController {
    
    @AuraEnabled
    public static List<OPP_News__c> getNews(String size, Boolean showAll){
        try {
             string rdLimit = '';
           	 string wheCat = '';
             rdLimit = size == '3'?'LIMIT 3':'LIMIT 6';
             if(showAll){ wheCat =' And Category__c !=\'Operation\' ';  }
             String query ='Select Id,Name,Thumbnail__c,Coin__c,Title__c,Category__c,(SELECT ContentDocumentId FROM ContentDocumentLinks ORDER BY SystemModstamp DESC LIMIT 1) FROM OPP_News__c WHERE Status__c =\'Published\' '+wheCat+'  ORDER BY LastModifiedDate DESC '+rdLimit;
             List<sObject> news = Database.query(query); 
            return news;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OPP_News__c> getOperationNews(String size){
        try {
             string rdLimit = '';
             rdLimit = size == '3'? 'LIMIT 3':'LIMIT 6';
             String query ='SELECT Id,Name,Thumbnail__c,Coin__c,Title__c,Category__c,(SELECT ContentDocumentId FROM ContentDocumentLinks ORDER BY SystemModstamp DESC LIMIT 1)FROM OPP_News__c WHERE Category__c =\'Operation\' AND Status__c =\'Published\' ORDER BY LastModifiedDate DESC '+rdLimit;
             List<sObject> news = Database.query(query);
            return news;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OPP_FavAppWrap> getApplications(){
        try {
            List<OPP_FavAppWrap> oppFavAppWraps = new List<OPP_FavAppWrap>();
            List<OPP_Favorite_Application__c> applications = [SELECT Id, OPP_Application__c, OPP_Application__r.Name, OPP_Application__r.URL_Web__c,OPP_Application__r.Icon__c, User__c, No__c, OPP_Application__r.URL_IOS__c, OPP_Application__r.URL_Android__c FROM OPP_Favorite_Application__c WHERE User__c =: UserInfo.getUserId() ORDER BY NO__c ASC LIMIT 6];
            if(applications.size() > 0){
                Set<Id> setAppIds = new Set<Id>();
                Map<Id, Id> mapFileApplication = new Map<Id, Id>();
				for(OPP_Favorite_Application__c application : applications){
                    setAppIds.add(application.OPP_Application__c);
                }
                List<OPP_Application__c> apps = [SELECT Id, (SELECT ContentDocumentId FROM ContentDocumentLinks ORDER BY SystemModstamp DESC LIMIT 1) FROM OPP_Application__c WHERE Id IN: setAppIds];
                for(OPP_Application__c app : apps) {
                    for(ContentDocumentLink content : app.ContentDocumentLinks){
                        mapFileApplication.put(app.Id, content.ContentDocumentId);
                    }
                }
                for(OPP_Favorite_Application__c application : applications){
                    OPP_FavAppWrap oppFavAppWrap = new OPP_FavAppWrap();
                    oppFavAppWrap.favAppId = application.Id;
                    oppFavAppWrap.appName = application.OPP_Application__r.Name;
                    oppFavAppWrap.url = application.OPP_Application__r.URL_Web__c;
                    oppFavAppWrap.ios = application.OPP_Application__r.URL_IOS__c;
                    oppFavAppWrap.android = application.OPP_Application__r.URL_Android__c;
                    if(mapFileApplication.containsKey(application.OPP_Application__c)) {
                        oppFavAppWrap.fileId = mapFileApplication.get(application.OPP_Application__c);
                    }  
                    oppFavAppWraps.add(oppFavAppWrap);
                }
                return oppFavAppWraps;
            }
            else {
                // First time user login on SF
                OPP_Favorite_Application__c app_1 = new OPP_Favorite_Application__c();
                app_1.OPP_Application__c = [SELECT Id FROM OPP_Application__c WHERE Name = 'Intranet' LIMIT 1].Id;
                app_1.User__c = UserInfo.getUserId();
                app_1.No__c = 1;
                insert app_1;

                OPP_Favorite_Application__c app_2 = new OPP_Favorite_Application__c();
                app_2.OPP_Application__c = [SELECT Id FROM OPP_Application__c WHERE Name = 'Employee Online' LIMIT 1].Id;
                app_2.User__c = UserInfo.getUserId();
                app_2.No__c = 2;
                insert app_2;

                OPP_Favorite_Application__c app_3 = new OPP_Favorite_Application__c();
                app_3.OPP_Application__c = [SELECT Id FROM OPP_Application__c WHERE Name = 'Top Search' LIMIT 1].Id;
                app_3.User__c = UserInfo.getUserId();
                app_3.No__c = 3;
                insert app_3;

                Integer i;
                for(i=0; i<3; i++) {
                    OPP_Favorite_Application__c app = new OPP_Favorite_Application__c();
                    app.User__c = UserInfo.getUserId();
                    app.No__c = 4 + i;
                    insert app;
                }

                Set<Id> setAppIds = new Set<Id>();
                Map<Id, Id> mapFileApplication = new Map<Id, Id>();

                List<OPP_Favorite_Application__c> fapApps = [SELECT Id,OPP_Application__c,OPP_Application__r.Name,OPP_Application__r.URL_Web__c,OPP_Application__r.URL_IOS__c,OPP_Application__r.URL_Android__c,OPP_Application__r.Icon__c,User__c FROM OPP_Favorite_Application__c WHERE User__c =: UserInfo.getUserId() ORDER BY NO__c ASC];

                for(OPP_Favorite_Application__c application : fapApps){
                    setAppIds.add(application.OPP_Application__c);
                }
                List<OPP_Application__c> apps = [SELECT Id, (SELECT ContentDocumentId FROM ContentDocumentLinks ORDER BY SystemModstamp DESC LIMIT 1) FROM OPP_Application__c WHERE Id IN: setAppIds];
                for(OPP_Application__c app : apps){
                    for(ContentDocumentLink content : app.ContentDocumentLinks){
                        mapFileApplication.put(app.Id, content.ContentDocumentId);
                    }
                }
                List<OPP_Favorite_Application__c> getApplications = [SELECT Id,OPP_Application__c,OPP_Application__r.Name, OPP_Application__r.URL_Web__c,OPP_Application__r.Icon__c,User__c, No__c,OPP_Application__r.URL_IOS__c,OPP_Application__r.URL_Android__c FROM OPP_Favorite_Application__c WHERE User__c =: UserInfo.getUserId() ORDER BY NO__c ASC LIMIT 6];
                for(OPP_Favorite_Application__c application : getApplications){
                    OPP_FavAppWrap oppFavAppWrap = new OPP_FavAppWrap();
                    oppFavAppWrap.favAppId = application.Id;
                    oppFavAppWrap.appName = application.OPP_Application__r.Name;
                    oppFavAppWrap.url = application.OPP_Application__r.URL_Web__c;
                    oppFavAppWrap.ios = application.OPP_Application__r.URL_IOS__c;
                    oppFavAppWrap.android = application.OPP_Application__r.URL_Android__c;
                    if(mapFileApplication.containsKey(application.OPP_Application__c)) {
                        oppFavAppWrap.fileId = mapFileApplication.get(application.OPP_Application__c);
                    }  
                    oppFavAppWraps.add(oppFavAppWrap);
                }
                return oppFavAppWraps;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}