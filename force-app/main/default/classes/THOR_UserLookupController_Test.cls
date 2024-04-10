@IsTest
public with sharing class THOR_UserLookupController_Test {
    @IsTest
    static void getUsers(){
        createUser();

        Test.startTest();
        List<User> us = THOR_UserLookupController.searchUsers('tes');
        Test.stopTest();

        System.assert(us.size() > 0, 'No users returned');
    }

    private static User createUser() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueOf(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(Math.rint(Math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        User ouser = new User(
            FirstName = 'test',
            LastName = 'user',
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User']
            .Id
        );
        insert ouser;
        return ouser;
    }
}