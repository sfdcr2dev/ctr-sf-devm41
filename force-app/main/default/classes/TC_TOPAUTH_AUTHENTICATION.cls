/* Test Class for TOPAUTH_AUTHENTICATION CLASS */
@isTest
public class TC_TOPAUTH_AUTHENTICATION {

    public static User CreateUser() {
        
        User thaioilUser = new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operation'].Id,
            LastName = 'Test',
            Email = 'test@thaioilgroup.com',
            Username = 'test@thaioilgroup.com' + System.currentTimeMillis(),
            CompanyName = 'ThaiOil',
            Alias = 'Test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
        insert(thaioilUser);
        
        return thaioilUser;
    }
    
    public static testMethod void TOPAUTH_AUTHENTICATION() {
        
        User testUser = CreateUser();
        System.runAs(testUser) {
            Test.startTest();
            TOPAUTHIntegration__c TOPAUTH = new TOPAUTHIntegration__c();
            TOPAUTH.TOPAUTH_AUTHEN_URL__c = 'https://ta2.thaioilgroup.com/Login/TopauthAuthen';
            insert(TOPAUTH);
            
            string redirectURL = 'https://www.test.com';
            
            TOPAUTH_AUTHENTICATION.TestStatus = 200;
            TOPAUTH_AUTHENTICATION.AuthenToTopauth(redirectURL);
            Test.stopTest();
        }
    }
    
}