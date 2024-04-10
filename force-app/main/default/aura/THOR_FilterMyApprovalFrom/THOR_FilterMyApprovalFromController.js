({
	reset: function (component, event, helper) {
		component.find('inputField').forEach((component) => component.set('v.value', null));
	},
	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.form.${params.fieldName}`, params.value);
	},
	reverseValueMaintenancePlant: function (component, event, helper) {
		component.set(`v.reverseValueMaintenancePlant`, [
			component.get('v.form.Location__c'),
			component.get('v.form.Plant_Section__c')
		]);
	}
});