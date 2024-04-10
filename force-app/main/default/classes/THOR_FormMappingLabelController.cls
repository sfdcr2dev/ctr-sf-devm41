public with sharing class THOR_FormMappingLabelController {
    @AuraEnabled
    public static void updateFormMapping(String jsonString, String formCode, String stepId, String count) {
        List<THOR_Form_Mapping__c> formMappings = [SELECT Id, Json_String__c, Count__c, Step__c FROM THOR_Form_Mapping__c WHERE Eqcc_Step_Id__c =: stepId LIMIT 1];
        if(formMappings.size() > 0) {
            formMappings.get(0).Json_String__c = jsonString;
            formMappings.get(0).Count__c = count;
            formMappings.get(0).Step__c = '1';
            update formMappings;
        }
        else {
            THOR_Form_Mapping__c mapping = new THOR_Form_Mapping__c();
            mapping.Form_Code__c = formCode;
            mapping.Json_String__c = jsonString;
            mapping.Eqcc_Step_Id__c = stepId;
            mapping.Count__c = count;
            mapping.Step__c = '1';
            insert mapping;
        }
        
    }

    @AuraEnabled
    public static string getCount(String stepId){
        List<THOR_Form_Mapping__c> formMappings = [SELECT Id, Json_String__c, Count__c FROM THOR_Form_Mapping__c WHERE Eqcc_Step_Id__c =: stepId LIMIT 1];
        if(formMappings.size() > 0) {
            return formMappings.get(0).Count__c;
        }
        return '';
    }
}