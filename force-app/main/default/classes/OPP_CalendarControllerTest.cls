@isTest
public class OPP_CalendarControllerTest {
	@TestSetup
    static void makeData(){

        Event e = new Event(
            Subject = 'Notification',
            DurationInMinutes = 1,
            ActivityDateTime = System.now(),
            ActivityDate = System.today()
        );
        insert e;
        
        Event e2 = new Event(
            Subject = 'Notification',
            DurationInMinutes = 1,
            ActivityDateTime = System.now(),
            ActivityDate = System.today()+30
        );
        insert e2;
        
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
		Test.startTest();
            List<Event> getToday = OPP_CalendarController.getTodayEvents();
        	Map<String, Boolean> getThisMonth = OPP_CalendarController.getDefaultMonthEvents();
        	Map<String, Boolean> getMonthEvent = OPP_CalendarController.getMonthEvent(7, 2021);
        	List<Event> getEvents = OPP_CalendarController.getEvents('2021-07-29');
		Test.stopTest();        
    }
    
    public static User getUser() {
        User user = [SELECT Id FROM User WHERE LastName = 'TestingOperation' LIMIT 1];
        return user;
    }
}