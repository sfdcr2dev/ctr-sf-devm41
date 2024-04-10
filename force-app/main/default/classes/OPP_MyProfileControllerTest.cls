@isTest
public class OPP_MyProfileControllerTest {

    @TestSetup
    static void makeData(){

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
    }
    
    @isTest
    public static void testPositive() {
        User user = getUser();
        User u = new User();
        System.runAs(user) {
            u = OPP_MyProfileController.getUser();
            Decimal coin = OPP_MyProfileController.getCoinBalance();
        }
    }
    
    public static User getUser() {
        User user = [SELECT Id FROM User WHERE LastName = 'TestingOperation' LIMIT 1];
        return user;
    }
}