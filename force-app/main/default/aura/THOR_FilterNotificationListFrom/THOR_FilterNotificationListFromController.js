({
    doInit: function (component, event, helper) {
      	console.log(JSON.stringify(component.get('v.form')));  
    },
    reset: function (component, event, helper) {
        component.find('inputField').forEach(cmp => {
            if (['Breakdown__c', 'My_Tasks__c'].includes(cmp.get('v.fieldName'))) {
                cmp.set('v.value', false)
            } else {
                cmp.set('v.value', null)
            }
        });
    },
    handleChange: function (component, event, helper) {
        var params = event.getParams();
        component.set(`v.form.${params.fieldName}`, params.value);
    },
    reverseValueMaintenancePlant: function (component, event, helper) {
        component.set(`v.reverseValueMaintenancePlant`,
            [
                component.get('v.form.Location__c'),
                component.get('v.form.Plant_Section__c'),
            ]);
    }
})