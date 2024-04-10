({
	doInit: function (component, event, helper) {
		try {
			window.setTimeout(
				$A.getCallback(function () {
					component.find('inputField').forEach((e) => {
						if (component.get(`v.form.${e.get('v.fieldName')}`)) {
							e.set('v.value', component.get(`v.form.${e.get('v.fieldName')}`));
						}
					});
				}),
				1000
			);
		} catch (e) {
			console.error(e);
		}
	},
	getFields: function (component, event, helper) {
		return component.find('inputField').reduce((acc, e) => {
			acc.push(e.get('v.fieldName'));
			return acc;
		}, []);
	},
	reset: function (component, event, helper) {
		component.find('inputField').forEach((cmp) => cmp.set('v.value', null));
	},
	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.form.${params.fieldName}`, params.value);
	},
});