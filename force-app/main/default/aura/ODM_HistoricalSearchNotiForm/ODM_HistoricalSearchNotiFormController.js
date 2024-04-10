({
	scriptsLoaded: function (component, event, helper) {
		// console.log('load successfully');

		$('.select2Class').select2({
			placeholder: ' Select Multiple value'
		});
	},
	doInit: function (component, event, helper) {
		setTimeout(
			$A.getCallback(() => {
				component.set(
					'v.form.Main_Work_Center__c',
					component.get('v.form.Main_Work_Center__c') ? component.get('v.form.Main_Work_Center__c') : null
				);
			}),
			200
		);
		component.set('v.picklistNotiType', ['CM', 'PM', 'SH', 'OP']);
		component.set('v.picklistNotiStatus', [
			{ key: 'New', value: 'New' },
			{ key: 'In Progress', value: 'In Process' },
			{ key: 'Closed', value: 'Closed'}
		]);		

		helper.getMyFilterHistoricalSearch(component, event);

	},
	
	handleChange: function (component, event, helper) {
		var params = event.getParams();
		component.set(`v.form.${params.fieldName}`, params.value);
	},

	getFilterList: function (component, event, helper) {
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
			f.set('v.value', null);
		});

		$('#picklistNotiType_NotiForm').val(null).trigger('change');
		$('#picklistNotiStatus_NotiForm').val(null).trigger('change');
		
		component.set('v.form.Main_Work_Center__c', null);
		component.set('v.redirect', false);
		component.find('utilityLwcButton').submit_click();
	},
	handleLoad: function (component, event, helper) {
		var recordUi = event.getParam('recordUi');

		component.find('filterForm').set(
			'v.form',
			Object.keys(recordUi.record.fields).reduce((l, key) => {
				l[key] = recordUi.record.fields[key].value || null;
				return l;
			}, {})
		);
		if (!component.get('v.recordId')) {
		}

		helper.stopLoading(component);
		$A.enqueueAction(component.get('c.scriptsLoaded'));
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		var fields = event.getParam('fields');

		try {
			const select2Obj = {
				NotificationTypeMulti__c: $('[id$=picklistNotiType_NotiForm]').select2('val'),
				StatusMulti__c: $('[id$=picklistNotiStatus_NotiForm]').select2('val'),
			};
			// console.log(select2Obj);
			fields.NotificationTypeMulti__c = select2Obj.NotificationTypeMulti__c
				? select2Obj.NotificationTypeMulti__c.join(';')
				: null;
			fields.StatusMulti__c = select2Obj.StatusMulti__c ? select2Obj.StatusMulti__c.join(';') : null;
			fields.IsActive__c = component.get('v.isActive') ? true : false;
			fields.Filter_type__c = 'ODM_HistoricalNotification';

			// console.log('YOOO' + helper.parseObject(fields));
			event.getSource().submit(fields);
		} catch (e) {
			console.error(e);
		}
	},
	handleSuccess: function (component, event, helper) {
		var params = event.getParams();
		const {
			response: { id }
		} = params;
		if (!component.get('v.filterId')) {
			component.set('v.filterId', id);
		}

		if (component.get('v.redirect')) {
			helper.redirectAll(component, event);
		}
		// console.log('Re:' + helper.redirectAll(component, event));
	},
	handleError: function (component, event, helper) {
		var error = event.getParams();
		console.log(helper.parseObject(error));

		helper.stopLoading(component);
	},
	
});