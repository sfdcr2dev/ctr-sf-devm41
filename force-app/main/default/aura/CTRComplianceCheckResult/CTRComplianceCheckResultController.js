({
    doInit : function(component, event, helper) {

    },

    recordUpdatedAction : function(component, event, helper) {
        console.log('[doInit] recordObject -----', component.get("v.recordObject"));
        if(!$A.util.isEmpty(component.get("v.recordObject.ComplianceCheckResult__c"))) {
            component.set("v.complianceCheckMessage", "The system has found the following information in the HH risk category as follow");
            component.set("v.complianceCheckResult", component.get("v.recordObject.ComplianceCheckResult__c"));
        } else {
            component.set("v.complianceCheckMessage", "Compliance Check is currently being processed. Please wait while system verify the information");
        }
        component.set("v.isLoaded", true);
    },
})