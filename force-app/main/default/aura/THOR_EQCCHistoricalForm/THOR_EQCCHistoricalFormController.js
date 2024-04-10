({
	scriptsLoaded: function (component, event, helper) {
		//console.log('load successfully');

		$('.select2Class').select2({
			placeholder: ' Select Multiple value'
		});
	},

	doInit: function (component, event, helper) {
		helper.getMyFilterHistoricalSearch(component, event, helper);

		component.set('v.form.Main_Work_Center__c', null);
		component.set('v.form.Maintenance_Plant__c', null);
		component.set('v.form.Plant_Section__c', null);
		component.set('v.form.Creator__c', null);
	},

	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.form.${params.fieldName}`, params.value);
	},

	getFilterList: function (component, event, helper) {
		// //console.log(Object.keys(component.get('v.filterMap')))
		return Object.keys(component.get('v.filterMap')).reduce((list, fieldName) => {
			if (component.get(`v.filterMap.${fieldName}`)) list[fieldName] = component.get(`v.filterMap.${fieldName}`);
			return list;
		}, {});
	},
	onSubmitFooter: function (component, event, helper) {
		component.set('v.isActive', true);
		component.set('v.redirect', true);
		component.find('utilityLwcButton').submit_click();
	},
	onClearFooter: function (component, event, helper) {
		component.set('v.isActive', false);
		// component.find('filterForm').reset();
		component.find('inputField').forEach(function (f) {
			f.set('v.value', null);
		});

		component.set('v.form.Main_Work_Center__c', null);
		component.set('v.form.Maintenance_Plant__c', null);
		component.set('v.form.Plant_Section__c', null);
		component.set('v.form.Creator__c', null);

		component.set('v.redirect', false);
		component.find('utilityLwcButton').submit_click();
	},
	handleLoad: function (component, event, helper) {
		var recordUi = event.getParam('recordUi');
		// //console.log(helper.parseObject(recordUi))

		component.find('filterForm').set(
			'v.form',
			Object.keys(recordUi.record.fields).reduce((l, key) => {
				l[key] = recordUi.record.fields[key].value || null;
				return l;
			}, {})
		);
		if (!component.get('v.recordId')) {
			// do something ...
		}

		helper.stopLoading(component);
		$A.enqueueAction(component.get('c.scriptsLoaded'));
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		var fields = event.getParam('fields');

		fields.IsActive__c = component.get('v.isActive') ? true : false;
		fields.Filter_type__c = 'EQCCHistorical';

		//console.log(JSON.stringify(fields));
		event.getSource().submit(fields);
	},
	handleSuccess: function (component, event, helper) {
		var params = event.getParams();
		const {
			response: { id }
		} = params;
		if (!component.get('v.filterId')) {
			component.set('v.filterId', id);
			// helper.getMyFilter(component);
		} else {
			// helper.fireEvent(component);
		}
		//console.log('id: ' + id);
		component.set('v.filterId', id);

		if (component.get('v.redirect')) {
			helper.redirectAll(component, event);
		}
		// component.set('v.isActive', !!id)

		// $A.enqueueAction(component.get('c.toggleModalFilter'));
	},
	handleError: function (component, event, helper) {
		var error = event.getParams();
		// alert(JSON.stringify(error));
		console.error(error);
		helper.stopLoading(component);
	}
});