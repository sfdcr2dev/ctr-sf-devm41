@RestResource(urlMapping='/THOR_Form_Mapping__c/*')
global class THOR_RestWebService {
	@HttpGet
    global static List<THOR_Form_Mapping__c> getRecord() {
        return [SELECT Id, Form_Code__c, Json_String__c, Step__c, Eqcc_Step_Id__c FROM THOR_Form_Mapping__c];
    }
}