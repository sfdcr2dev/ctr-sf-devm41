/*
* CTRSubmitRegistrationForm.cmp
*/
public with sharing class CTRSubmitRegistrationFormController {

    private static final String CLASSNAME = CTRSubmitRegistrationFormController.class.getName();

    @AuraEnabled
    public static Boolean validateUserProfile(String userId) {
        Boolean result = false;
        try {
            System.debug(CLASSNAME + '.validateUserProfile userId -----' + userId);
            if(!String.isBlank(userId)) {
                User currentUser = [SELECT Id, ProfileId, Profile.Name FROM User WHERE Id = :userId LIMIT 1];
                List<String> txProfiles = CTRGeneralSetting__mdt.getInstance('SubmitRegistrationFormTXProfile')?.Value__c?.split(';');
                if(txProfiles != null && !txProfiles.isEmpty()) {
                    result = txProfiles.contains(currentUser.Profile.Name);
                }
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return result;
    }

    @AuraEnabled
    public static String updateRequestFormStatus(Map<String, Object> inputData) {
        String result = 'failed';
        try {
            if(inputData != null && inputData.containsKey('recordId')) {
                String recordId = (inputData.containsKey('recordId') ? (String) inputData.get('recordId') : null);
                String status = (inputData.containsKey('status') ? (String) inputData.get('status') : null);
                if(!String.isBlank(recordId) && !String.isBlank(status)) {
                    CTRRequestFormItem__c record = new CTRRequestFormItem__c();
                    record.Id = recordId;
                    record.Status__c = status;
                    update record;
                    result = 'success';
                }
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return result;
    }
}