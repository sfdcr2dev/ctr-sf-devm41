({
	scriptsLoaded: function (component, event, helper) {
		console.log('load successfully');

		$('.select2Class').select2({
			placeholder: ' Select Multiple value'
		});
	},

	doInit: function (component, event, helper) {
		helper.getMyFilterHistoricalSearch(component, event, helper);
		component.set('v.form.Location__c', null);
		component.set('v.form.Main_Work_Center__c', null);
		component.set('v.form.Maintenance_Plant__c', null);
		component.set('v.form.Plant_Section__c', null);
		component.set('v.form.Created_By__c', null);

		component.set('v.picklistNotiType', ['CM', 'PM', 'SH']);
		component.set('v.picklistOrderType', ['CM01', 'PM01', 'SH01']);
		component.set('v.picklistWcStatus', ['Created', 'In Progress', 'Inactive', 'Delete Flag', 'Closed', 'Rejected']);
		component.set('v.picklistPriority', ['Normal', 'Urgent', 'Immediately', 'Float Time - 1M', 'Float Time - 3M', 'Float Time - 6M', 'Float Time - 9M', 'Float Time - 12M', 'Float Time - 15M', 'Float Time - 18M']);
	},

	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.form.${params.fieldName}`, params.value);
	},

	getFilterList: function (component, event, helper) {
		// console.log(Object.keys(component.get('v.filterMap')))
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

		component.find('inputField').forEach(function (f) {
			console.log(JSON.stringify(f));
			f.set('v.value', null);
		});
		$('#picklistNotiType_WCForm').val(null).trigger('change');
		$('#picklistOrderType_WCForm').val(null).trigger('change');
		$('#picklistWcStatus_WCForm').val(null).trigger('change');
		$('#picklistPriority_WCForm').val(null).trigger('change');

		component.set('v.form.Location__c', null);
		component.set('v.form.Main_Work_Center__c', null);
		component.set('v.form.Maintenance_Plant__c', null);
		component.set('v.form.Plant_Section__c', null);
		component.set('v.form.Created_By__c', null);

		component.set('v.redirect', false);
		component.find('utilityLwcButton').submit_click();
	},
	handleLoad: function (component, event, helper) {
		var recordUi = event.getParam('recordUi');
		// console.log(helper.parseObject(recordUi))

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

		try {
			const select2Obj = {
				NotificaitonTypeMulti__c: $('[id$=picklistNotiType_WCForm]').select2('val'),
				OrderTypeMulti__c: $('[id$=picklistOrderType_WCForm]').select2('val'),
				StatusMulti__c: $('[id$=picklistWcStatus_WCForm]').select2('val'),
				PriorityMulti__c: $('[id$=picklistPriority_WCForm]').select2('val')
			};
			fields.NotificationTypeMulti__c = select2Obj.NotificaitonTypeMulti__c
				? select2Obj.NotificaitonTypeMulti__c.join(';')
				: null;
			fields.OrderTypeMulti__c = select2Obj.OrderTypeMulti__c ? select2Obj.OrderTypeMulti__c.join(';') : null;
			fields.StatusMulti__c = select2Obj.StatusMulti__c ? select2Obj.StatusMulti__c.join(';') : null;
			fields.PriorityMulti__c = select2Obj.PriorityMulti__c ? select2Obj.PriorityMulti__c.join(';') : null;
			fields.IsActive__c = component.get('v.isActive') ? true : false;
			fields.Filter_type__c = 'WorkClearanceHistorical';

			console.log(helper.parseObject(fields));
			event.getSource().submit(fields);
		} catch (e) {
			console.error(e);
		}
		console.log(JSON.stringify(fields));
	},
	handleSuccess: function (component, event, helper) {
		var params = event.getParams();
		console.log('params: ' + params);
		const {
			response: { id }
		} = params;
		if (!component.get('v.filterId')) {
			component.set('v.filterId', id);
			// helper.getMyFilter(component);
		} else {
			// helper.fireEvent(component);
		}
		console.log('id: ' + id);
		component.set('v.filterId', id);

		if (component.get('v.redirect')) {
			helper.redirectAll(component, event);
		}
		// component.set('v.isActive', !!id)

		// $A.enqueueAction(component.get('c.toggleModalFilter'));
	},
	handleError: function (component, event, helper) {
		var error = event.getParams();
		// alert('error! ' + JSON.stringify(error));
		console.error(error);
		helper.stopLoading(component);
	}
});