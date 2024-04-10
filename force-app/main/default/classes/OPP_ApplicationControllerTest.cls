@isTest
public class OPP_ApplicationControllerTest {
    
    @TestSetup
    static void setup(){
        
        OPP_Application__c oppApp1 = new OPP_Application__c();
        oppApp1.Name = 'App 1';
        oppApp1.Category__c = 'General';
        oppApp1.Notification__c = true;
        oppApp1.Is_Deleted__c = false;
        insert oppApp1;
        
        OPP_Application__c oppApp2 = new OPP_Application__c();
        oppApp2.Name = 'App 2';
        oppApp2.Category__c = 'General';
        oppApp2.Notification__c = true;
        oppApp2.Is_Deleted__c = false;
        insert oppApp2;
        
        OPP_Application__c oppApp3 = new OPP_Application__c();
        oppApp3.Name = 'App 3';
        oppApp3.Category__c = 'General';
        oppApp3.Notification__c = true;
        oppApp3.Is_Deleted__c = false;
        insert oppApp3;
        
        Profile userProfile = [SELECT Id FROM Profile WHERE Name = 'Operation'];
        User user = new User(
            Alias = 'standt1',
            Email = 'operation1@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestingOperation1',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'operation1@test.com'
        );
        insert user;
        
        User user2 = new User(
            Alias = 'standt2',
            Email = 'operation2@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestingOperation2',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = userProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'operation2@test.com'
        );
        insert user2;
        
        /*Date today = Date.today();*/
        
        
        OPP_Favorite_Application__c oppFav1 = new OPP_Favorite_Application__c();
        oppFav1.No__c = 1;
        oppFav1.OPP_Application__c = oppApp1.Id;
        oppFav1.User__c = user.Id;
        insert oppFav1;
        
        OPP_Favorite_Application__c oppFav2 = new OPP_Favorite_Application__c();
        oppFav2.No__c = 2;
        oppFav2.User__c = user.Id;
        insert oppFav2;
        
        OPP_Favorite_Application__c oppFav3 = new OPP_Favorite_Application__c();
        oppFav3.No__c = 3;
        oppFav3.OPP_Application__c = oppApp3.Id;
        oppFav3.User__c = user.Id;
        insert oppFav3;
        
        OPP_Notification__c notification = new OPP_Notification__c(
            Application__c = oppApp1.Id,
            Subject__c = 'Notification',
            Description__c = 'Description',
            User__c = user.Id,
            Url__c = 'https://login.salesforce.com',
            Status__c = 'New'
        );
        insert notification;

    }
    @isTest
    static void testgetApplication() {
        List<OPP_Application__c> apps = getApplications();
        Set<Id> jsonString = new Set<Id>();
        for(OPP_Application__c app : apps) {
            jsonString.add(app.Id);
        }
        String str = JSON.serialize(jsonString);
        User user1 = getUser('TestingOperation1');
        Test.startTest();
        //Application
        OPP_ApplicationController.getCategoryPicklistValuesIntoList();
        OPP_ApplicationController.getActiveApplications();
        OPP_ApplicationController.getActiveApplicationInCategory('General');
        OPP_ApplicationController.getOtherApplications();
        OPP_ApplicationController.getNotificationApplications();

        OPP_ApplicationController.getApplications();
        OPP_ApplicationController.getDefaultApplications();
        //Favorite
        OPP_ApplicationController.getCountApplications();
        //Notification
        List<OPP_Application__c> App01 = OPP_ApplicationController.getActiveApplicationInCategory('General');
        //<List>listNoti = OPP_ApplicationController.getActiveApplications();
        OPP_ApplicationController.getListofNotifications(App01[0].Id);
        OPP_ApplicationController.countNotificationGroupByApplication();
        System.runAs(user1) {
            OPP_ApplicationController.updateFavApps(str);
        }
        Test.stopTest();
    }
    
    @isTest
    public static void testCatchCondition() {
        List<OPP_Application__c> apps = getApplications();
        Set<Id> jsonString = new Set<Id>();
        for(OPP_Application__c app : apps) {
            jsonString.add(app.Id);
        }
        String str = JSON.serialize(jsonString);
        Test.startTest();
			try {
                OPP_ApplicationController.updateFavApps(str);
            } catch (Exception e) {
                System.assertEquals(
                    'System.AuraHandledException',
                    e.getTypeName(),
                    'Aura Exception should be thrown when user access is restricted or bad query'
                );
            }
       	Test.stopTest();
    }
    
    public static OPP_Favorite_Application__c getFavApplication() {
        return [SELECT Id FROM OPP_Favorite_Application__c LIMIT 1];
    }
    
    public static List<OPP_Application__c> getApplications() {
        return [SELECT Id, Name FROM OPP_Application__c];
    }
    
    public static User getUser(String lastname) {
        return [SELECT Id FROM User WHERE LastName =: lastname LIMIT 1];
    }
}