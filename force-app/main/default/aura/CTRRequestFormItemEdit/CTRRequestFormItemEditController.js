({
    doInit: function (component, event, helper) {
        console.log('[doInit] recordId -----' + component.get('v.recordId'));
        component.set('v.isLoaded', false);
    },

    handleRecordUpdated : function(component, event, helper) {
        console.log('[handleRecordUpdated] recordObject -----', Object.assign({}, component.get("v.recordObject")));
        console.log('[handleRecordUpdated] recorderror -----', component.get("v.recordLoadError"));
        if(!$A.util.isEmpty(component.get("v.recordObject"))) {
            console.log('recordType.DeveloperName -----', component.get('v.recordObject.RecordType.DeveloperName'));
            // component.set('v.recordTypeId', component.get("v.recordObject.RecordTypeId"));
            helper.retrieveBusinessUnitFromProfile(component);
        }
    },

})