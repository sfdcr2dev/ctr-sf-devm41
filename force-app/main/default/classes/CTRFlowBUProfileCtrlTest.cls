@isTest
public class CTRFlowBUProfileCtrlTest {

    @isTest
    static void testCheckBusinessUnit() {
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Commercial TLB EXP Sales Rep' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.test',
            Username = 'testuser@example.test',
            ProfileId = testProfile.Id,
            Alias = 'tuser',
            CommunityNickname = 'testuser',
            TimeZoneSidKey = 'Asia/Bangkok',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        List<CTRFlowBUProfileCtrl.FlowInputs> mData = new List<CTRFlowBUProfileCtrl.FlowInputs>();
        CTRFlowBUProfileCtrl.FlowInputs input = new CTRFlowBUProfileCtrl.FlowInputs();
        input.mUserId = testUser.Id;
        input.mSalesOrg = 'TestSalesOrg';
        mData.add(input);
        
        Test.startTest();
        List<String> result = CTRFlowBUProfileCtrl.CheckBusinessUnit(mData);
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Expected result list size is 1');
    }
}