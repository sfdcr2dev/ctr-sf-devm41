({
    parseObject: function (obj) {
        return JSON.parse(JSON.stringify(obj));
    },
    startSpinner: function (component) {
        component.set('v.isLoading', true);
    },
    stopSpinner: function (component) {
        component.set('v.isLoading', false);
    },
    closeModal: function () {
        $A.get("e.force:closeQuickAction").fire();
    },
    getCaseById: function (component, actionNext) {
        var action = component.get("c.getCaseById");
        action.setParams({
            recordId: component.get("v.recordId")
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.softwareType", result.Software_Type__c);
                $A.enqueueAction(actionNext);
            } else {
                var error = response.getError();
                console.error(error)
            }
        });
        return action;
    },
    getPicklistValuesSoftwareAsset: function (component, event, helper) {
        var action = component.get("c.getPicklistValuesSoftwareAsset");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.picklistMap.SoftwareAsset",
                    result.filter(f => {
                        if (component.get('v.softwareType') === 'Standard Software') {
                            return f.License_Type__c.includes('Standard Software')
                        } else {
                            return !f.License_Type__c.includes('Standard Software')
                        }
                    }));
            } else {
                var error = response.getError();
                console.error(error)
            }
        });
        $A.enqueueAction(helper.getCaseById(component, action));
    },
    getCaseLineItemRecordTpyeInfoes: function (component) {
        var action = component.get("c.getCaseLineItemRecordTpyeInfoes");
        action.setStorable();
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.recordTypeId", result.Software_Catalog.recordTypeId)
            }
        });
        $A.enqueueAction(action);
    },
    getPicklistValuesITAsset: function (component) {
        var action = component.get("c.getPicklistValuesITAsset")
        action.setParams({
            'requesterId': Array.isArray(component.get('v.softwareItem.Asset_Owner__c'))
                ? component.get('v.softwareItem.Asset_Owner__c.0')
                : component.get('v.softwareItem.Asset_Owner__c')
        })
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set(`v.picklistMap.OPP_IT_Asset__c`, [
                    ...result.map(m => ({
                        value: m.Id,
                        label: m.Name,
                        description: m.Asset_Type__c
                    }))
                ])

            } else {
                var error = response.getError();
                console.error(error);
            }
        })
        $A.enqueueAction(action);
        component.set('v.softwareItem.OPP_IT_Asset__c', null);
    },
})