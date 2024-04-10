@isTest
private class CTRSubmitRegistrationFormControllerTest {

    @isTest
    static void testValidateUserProfile() {
        
        Profile testProfile = [SELECT Id, Name FROM Profile LIMIT 1];
        User testUser = new User(
            LastName = 'Mock Test',
            Email = 'test@example.com',
            Username = 'mock@test.com',
            ProfileId = testProfile.Id,
            Alias = 'testUser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        Test.startTest();
        
        Boolean isValidUserProfile = CTRSubmitRegistrationFormController.validateUserProfile(testUser.Id);
        
        try {
            Boolean isInvalidUserProfile = CTRSubmitRegistrationFormController.validateUserProfile('invalidUserId');
        }
        catch(Exception ex) {
            System.assertNotEquals(null, ex.getMessage());
        }
        
        Test.stopTest();
    }

    @isTest
    static void testUpdateRequestFormStatus() {
        CTRRequestFormItem__c testRecord = new CTRRequestFormItem__c();
        insert testRecord;

        Test.startTest();
        
        Map<String, Object> inputData = new Map<String, Object>{
            'recordId' => testRecord.Id,
            'status' => 'Approved'
        };
        String updateResult = CTRSubmitRegistrationFormController.updateRequestFormStatus(inputData);
        
        System.assertEquals('success', updateResult);

        Map<String, Object> invalidInputData = new Map<String, Object>{
            'recordId' => null,
            'status' => 'Approved'
        };
        String invalidUpdateResult = CTRSubmitRegistrationFormController.updateRequestFormStatus(invalidInputData);
        
        System.assertEquals('failed', invalidUpdateResult);
        Test.stopTest();
    }
}