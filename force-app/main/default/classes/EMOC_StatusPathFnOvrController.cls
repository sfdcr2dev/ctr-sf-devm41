public class EMOC_StatusPathFnOvrController {
    @AuraEnabled
    public static List<Map<String, String>> getStageNamePath(String recordId) {
        Schema.DescribeFieldResult fieldResult = E_MOC_Application__c.Status_Functional_Override__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<Map<String, String>> valuesList = new List<Map<String, String>>();
        for( Schema.PicklistEntry pickListVal : ple){
            Map<String, String> listValues= new Map<String, String>();
            E_MOC_Application__c emocApp = [SELECT Id, Status_Functional_Override__c ,
                                            OOS__c, MOS_for_ops_purpose__c, Inhibit_for_process_or_Equipment_S_D__c,
                                            Inhibit_alarm_for_maintenance__c, Disable_Alarm_by_Ops_for_HW__c, Inhibit_Alarm_request_for_FOX__c,
                                            MOS_for_maintenance__c, Safeguarding_force_signal__c 
                                            FROM E_MOC_Application__c  WHERE Id = :recordId ];
            if (emocApp.OOS__c == true || emocApp.MOS_for_ops_purpose__c == true || emocApp.Inhibit_for_process_or_Equipment_S_D__c == true) {
                if (pickListVal.getValue() != 'Approval #2' && pickListVal.getValue() != 'Risk assessment' && pickListVal.getValue() != 'Technical review' 
                    && pickListVal.getValue() != 'Approval #3 (APU)' && pickListVal.getValue() != 'Approval #3 (VP)' && pickListVal.getValue() != 'Implementation#2' && pickListVal.getValue() != 'Cancelled' && pickListVal.getValue() != 'Rejected' ) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());  
                    listValues.put('currentStep',emocApp.Status_Functional_Override__c != null ? emocApp.Status_Functional_Override__c : '');
                    listValues.put('customcss',emocApp.Status_Functional_Override__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } else if ((emocApp.Status_Functional_Override__c  == 'Cancelled' && pickListVal.getValue() == 'Cancelled') || (emocApp.Status_Functional_Override__c  == 'Rejected' && pickListVal.getValue() == 'Rejected')) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Functional_Override__c  != null ? emocApp.Status_Functional_Override__c  : '');
                    listValues.put('customcss',emocApp.Status_Functional_Override__c  != null && emocApp.Status_Functional_Override__c  != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } 
            } else if (emocApp.Inhibit_alarm_for_maintenance__c == true || emocApp.Disable_Alarm_by_Ops_for_HW__c == true || emocApp.Inhibit_Alarm_request_for_FOX__c == true) {
                if (pickListVal.getValue() != 'Risk assessment' && pickListVal.getValue() != 'Technical review' && pickListVal.getValue() != 'Approval #3 (APU)' 
                    && pickListVal.getValue() != 'Approval #3 (VP)' && pickListVal.getValue() != 'Cancelled' && pickListVal.getValue() != 'Rejected' ) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());  
                    listValues.put('currentStep',emocApp.Status_Functional_Override__c != null ? emocApp.Status_Functional_Override__c : '');
                    listValues.put('customcss',emocApp.Status_Functional_Override__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } else if (pickListVal.getValue() != 'Risk assessment' && pickListVal.getValue() != 'Technical review' && pickListVal.getValue() != 'Approval #3 (APU)' && pickListVal.getValue() != 'Approval #3 (VP)' && ((emocApp.Status_Functional_Override__c  == 'Cancelled' && pickListVal.getValue() == 'Cancelled') || (emocApp.Status_Functional_Override__c  == 'Rejected' && pickListVal.getValue() == 'Rejected'))) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Functional_Override__c  != null ? emocApp.Status_Functional_Override__c  : '');
                    listValues.put('customcss',emocApp.Status_Functional_Override__c  != null && emocApp.Status_Functional_Override__c  != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } 
            } else if (emocApp.MOS_for_maintenance__c == true || emocApp.Safeguarding_force_signal__c == true) {
                if (pickListVal.getValue() != 'Cancelled' && pickListVal.getValue() != 'Rejected' ) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());  
                    listValues.put('currentStep',emocApp.Status_Functional_Override__c != null ? emocApp.Status_Functional_Override__c : '');
                    listValues.put('customcss',emocApp.Status_Functional_Override__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } else if ((emocApp.Status_Functional_Override__c  == 'Cancelled' && pickListVal.getValue() == 'Cancelled') || (emocApp.Status_Functional_Override__c  == 'Rejected' && pickListVal.getValue() == 'Rejected')) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Functional_Override__c  != null ? emocApp.Status_Functional_Override__c  : '');
                    listValues.put('customcss',emocApp.Status_Functional_Override__c  != null && emocApp.Status_Functional_Override__c  != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } 
            }
        }
        return valuesList;
    } 
}