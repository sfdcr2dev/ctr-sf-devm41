({
	doInit: function (component, event, helper) {
		if (component.get('v.filterPage')) {
			component.set('v.title', `${component.get(`v.titleType.${component.get('v.filterPage')}`)} - Filter By`);
		}

		let filterDefault = component.get('v.filterDefault');
		if (!$A.util.isEmpty(filterDefault)) {
			try {
				helper.setMyFilter(component, filterDefault);
			} catch(ex) {
				console.error(ex);
			}
		} else {
			helper.getMyFilter(component);
		}
		helper.generateFormFilter(component);
		document.addEventListener(
			'keydown',
			$A.getCallback(function (e) {
				if (e.key === 'Enter') component.set('v.isActive', true);
			})
		);
	},
	updateFilterList: function (component, event, helper) {
		helper.getMyFilter(component);
	},
	getFilterList: function (component, event, helper) {
		// console.log(Object.keys(component.get('v.filterMap')))
		return Object.keys(component.get('v.filterMap')).reduce((list, fieldName) => {
			if (component.get(`v.filterMap.${fieldName}`)) list[fieldName] = component.get(`v.filterMap.${fieldName}`);
			return list;
		}, {});
	},
	setFilterList: function (component, event, helper) {
		console.log(JSON.parse(JSON.stringify(event.getParams())));
	},
	onSubmitFooter: function (component, event, helper) {
		component.set('v.isActive', true);
		component.find('utilityLwcButton').submit_click();
	},
	onClearFooter: function (component, event, helper) {
		component.set('v.isActive', false);
		component.find('filterForm').reset();
		component.find('utilityLwcButton').submit_click();
	},
	handleLoad: function (component, event, helper) {
		var recordUi = event.getParam('recordUi');
		// console.log(helper.parseObject(recordUi))

		component.find('filterForm').set(
			'v.form',
			Object.keys(recordUi.record.fields).reduce((l, key) => {
				l[key] = component.get('v.recordId')
					? recordUi.record.fields[key].value || null
					: component.find('filterForm').get(`v.form.${key}`);
				return l;
			}, {})
		);
		// console.log(JSON.parse(JSON.stringify(component.find('filterForm').get('v.form'))));
		if (!component.get('v.recordId')) {
			// do something ...
		}

		helper.stopLoading(component);
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		var fields = event.getParam('fields');
		component.set('v.filterMap', fields);
		fields.IsActive__c = component.get('v.isActive') ? true : false;

		event.getSource().submit(fields);
	},
	handleSuccess: function (component, event, helper) {
		var params = event.getParams();
		const {
			response: { id }
		} = params;
		if (!component.get('v.recordId')) {
			component.set('v.recordId', id);
			helper.getMyFilter(component);
		} else {
			helper.fireEvent(component);
		}
		// console.log(id)
		// component.set('v.isActive', !!id)

		$A.enqueueAction(component.get('c.toggleModalFilter'));
	},
	handleError: function (component, event, helper) {
		var error = event.getParams();
		console.error(helper.parseObject(error));
		helper.stopLoading(component);
	},
	toggleModalFilter: function (component, event, helper) {
		component.set('v.isShowModal', !component.get('v.isShowModal'));
		if (component.get('v.isShowModal')) {
			helper.startLoading(component);
		}
	}
});