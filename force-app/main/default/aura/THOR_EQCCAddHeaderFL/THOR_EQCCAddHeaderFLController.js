({
    handleRecordUpdated: function (component, event, helper) {
        var functionalLocationName = component.get("v.orderRecord.Functional_Location__r.Name");
        component.set("v.functionalLocationName", functionalLocationName);
    }
})