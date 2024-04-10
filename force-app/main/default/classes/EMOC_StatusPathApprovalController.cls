public class EMOC_StatusPathApprovalController {
    @AuraEnabled
    public static List<Map<String, String>> getStageNamePath(String recordId) {
        Schema.DescribeFieldResult fieldResult = E_MOC_Application__c.Status_Common_Workflow__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        List<Map<String, String>> valuesList = new List<Map<String, String>>();
        for( Schema.PicklistEntry pickListVal : ple){
            Map<String, String> listValues= new Map<String, String>();
            E_MOC_Application__c emocApp = [SELECT Id, Status_Common_Workflow__c, Temporary__c, Emergency__c  FROM E_MOC_Application__c  WHERE Id = :recordId ];
            if (emocApp.Temporary__c == true && emocApp.Emergency__c == false) {
                if (pickListVal.getValue() != 'Emergency Approval' && pickListVal.getValue() != 'Cancelled' && pickListVal.getValue() != 'Rejected' ) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', (pickListVal.getValue() == 'Lesson Learn') ? 'Lesson Learned' : pickListVal.getLabel());  
                    listValues.put('currentStep',emocApp.Status_Common_Workflow__c != null ? emocApp.Status_Common_Workflow__c : '');
                    listValues.put('customcss',emocApp.Status_Common_Workflow__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } else if (pickListVal.getValue() != 'Emergency Approval' && ((emocApp.Status_Common_Workflow__c == 'Cancelled' && pickListVal.getValue() == 'Cancelled') || (emocApp.Status_Common_Workflow__c == 'Rejected' && pickListVal.getValue() == 'Rejected'))) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Common_Workflow__c != null ? emocApp.Status_Common_Workflow__c : '');
                    listValues.put('customcss',emocApp.Status_Common_Workflow__c != null && emocApp.Status_Common_Workflow__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                }
            } else if (emocApp.Temporary__c == false && emocApp.Emergency__c == true) {
                if (pickListVal.getValue() != 'Monitoring' && pickListVal.getValue() != 'Cancelled' && pickListVal.getValue() != 'Rejected' ) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', (pickListVal.getValue() == 'Lesson Learn') ? 'Lesson Learned' : pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Common_Workflow__c != null ? emocApp.Status_Common_Workflow__c : '');
                    listValues.put('customcss',emocApp.Status_Common_Workflow__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } else if (pickListVal.getValue() != 'Monitoring' && ((emocApp.Status_Common_Workflow__c == 'Cancelled' && pickListVal.getValue() == 'Cancelled') || (emocApp.Status_Common_Workflow__c == 'Rejected' && pickListVal.getValue() == 'Rejected'))) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Common_Workflow__c != null ? emocApp.Status_Common_Workflow__c : '');
                    listValues.put('customcss',emocApp.Status_Common_Workflow__c != null && emocApp.Status_Common_Workflow__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                }
            } else if (emocApp.Temporary__c == true && emocApp.Emergency__c == true) {
                if (pickListVal.getValue() != 'Cancelled' && pickListVal.getValue() != 'Rejected' ) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', (pickListVal.getValue() == 'Lesson Learn') ? 'Lesson Learned' : pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Common_Workflow__c != null ? emocApp.Status_Common_Workflow__c : '');
                    listValues.put('customcss',emocApp.Status_Common_Workflow__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } else if ((emocApp.Status_Common_Workflow__c == 'Cancelled' && pickListVal.getValue() == 'Cancelled') || (emocApp.Status_Common_Workflow__c == 'Rejected' && pickListVal.getValue() == 'Rejected')) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Common_Workflow__c != null ? emocApp.Status_Common_Workflow__c : '');
                    listValues.put('customcss',emocApp.Status_Common_Workflow__c != null && emocApp.Status_Common_Workflow__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                }
            } else {
                if (pickListVal.getValue() != 'Monitoring' && pickListVal.getValue() != 'Emergency Approval' && pickListVal.getValue() != 'Cancelled' && pickListVal.getValue() != 'Rejected' ) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', (pickListVal.getValue() == 'Lesson Learn') ? 'Lesson Learned' : pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Common_Workflow__c != null ? emocApp.Status_Common_Workflow__c : '');
                    listValues.put('customcss',emocApp.Status_Common_Workflow__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                } else if (pickListVal.getValue() != 'Monitoring' && pickListVal.getValue() != 'Emergency Approval' && ((emocApp.Status_Common_Workflow__c == 'Cancelled' && pickListVal.getValue() == 'Cancelled') || (emocApp.Status_Common_Workflow__c == 'Rejected' && pickListVal.getValue() == 'Rejected'))) {
                    listValues.put('value', pickListVal.getValue());
                    listValues.put('label', pickListVal.getLabel());
                    listValues.put('currentStep',emocApp.Status_Common_Workflow__c != null ? emocApp.Status_Common_Workflow__c : '');
                    listValues.put('customcss',emocApp.Status_Common_Workflow__c != null && emocApp.Status_Common_Workflow__c != pickListVal.getValue() ? 'slds-tabs_path__item slds-is-incomplete' : 'slds-tabs_path__item slds-is-current');
                    valuesList.add(listValues);
                }
            }
        }
        return valuesList;
    }  
}