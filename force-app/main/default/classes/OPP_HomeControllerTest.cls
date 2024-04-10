@isTest
public with sharing class OPP_HomeControllerTest {
    @TestSetup
    static void makeData(){
        
		List<OPP_Application__c> applications = new List<OPP_Application__c>();
        OPP_Application__c application1 = new OPP_Application__c(
            Name = 'Intranet', 
            URL_IOS__c = 'https://www.google.co.th',
        	URL_Android__c = 'https://www.google.co.th',
        	URL_Web__c = 'https://www.google.o.th');
        OPP_Application__c application2 = new OPP_Application__c(
            Name = 'Employee Online', 
            URL_IOS__c = 'https://www.google.co.th',
        	URL_Android__c = 'https://www.google.co.th',
        	URL_Web__c = 'https://www.google.o.th');
        OPP_Application__c application3 = new OPP_Application__c(
            Name = 'Top Search', 
            URL_IOS__c = 'https://www.google.co.th',
        	URL_Android__c = 'https://www.google.co.th',
        	URL_Web__c = 'https://www.google.o.th');
        applications.add(application1);
        applications.add(application2);
        applications.add(application3);
        insert applications;
        
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Operation'];
        User user = new User(
            Alias = 'standt',
            Email = 'operation@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestingOperation',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'operation@test.com'
        );
        insert user;

        OPP_Notification__c notification = new OPP_Notification__c(
            Application__c = application1.Id,
            Subject__c = 'Notification',
            Description__c = 'Description',
            User__c = user.Id,
            Url__c = 'https://login.salesforce.com',
            Status__c = 'New'
        );
        insert notification;

        OPP_News__c oppNew = new OPP_News__c(
            Title__c = 'News 1',
            Category__c = 'Corporate',
            Coin__c = 1,
            Coin_Type__c = 'Read',
            Content__c = 'News 1 Content',
            Highlight__c = true,
            Thumbnail__c = '',
            View__c = 10,
            Status__c = 'Published'
        );
        insert oppNew;

        OPP_Favorite_Application__c favApplication = new OPP_Favorite_Application__c(
            OPP_Application__c = application1.Id
        );
        insert favApplication;
    }
    
    @isTest
    public static void testPositive() {
        User user = getUser();
        List<OPP_FavAppWrap> favApps = new List<OPP_FavAppWrap>();
        Test.startTest();
        	List<OPP_News__c> oppNews = OPP_HomeController.getNews('3', true);
        	List<OPP_News__c> oppOperationNews = OPP_HomeController.getOperationNews('3');
            System.runAs(user) {
                favApps = OPP_HomeController.getApplications();
            }
        Test.stopTest();
        System.assertEquals(6, favApps.size());
        System.assertEquals(1, oppNews.size());
    }
    
    @isTest
    public static void testNegative() {
        User user = getUser();
        OPP_Favorite_Application__c favApp = getFavApp();
        favApp.User__c = user.Id;
        update favApp;
        List<OPP_FavAppWrap> favApps = new List<OPP_FavAppWrap>();
        List<OPP_News__c> oppNews = OPP_HomeController.getNews('6', false);
        	List<OPP_News__c> oppOperationNews = OPP_HomeController.getOperationNews('6');
        System.runAs(user) {
            favApps = OPP_HomeController.getApplications();
        }
        System.assertEquals(1, favApps.size());
    }

    public static User getUser() {
        User user = [SELECT Id FROM User WHERE LastName = 'TestingOperation' LIMIT 1];
        return user;
    }
    
    public static OPP_Favorite_Application__c getFavApp() {
        OPP_Favorite_Application__c fav = [SELECT Id, User__c, OPP_Application__c, OPP_Application__r.Name, OPP_Application__r.URL_Web__c,
                                           OPP_Application__r.URL_IOS__c, OPP_Application__r.URL_Android__c, OPP_Application__r.Icon__c 
                                           FROM OPP_Favorite_Application__c LIMIT 1];
        return fav;
    }
    
    public static OPP_Notification__c getNotification() {
        OPP_Notification__c notification = [SELECT Id FROM OPP_Notification__c LIMIT 1];
        return notification;
    }
}