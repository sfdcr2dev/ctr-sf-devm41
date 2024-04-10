({
	debounce: function (component, func, wait) {
		var timeout = component.get('v.timeout');
		return $A.getCallback(function () {
			var context = this,
				args = arguments;
			clearTimeout(timeout);
			timeout = setTimeout(function () {
				timeout = null;
				func.apply(context, args);
			}, wait);
			component.set('v.timeout', timeout);
		});
	},
	makeToast: function (type, title, message) {
		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title: title,
			message: message,
			type: type
		});
		toastEvent.fire();
	},
	onCancel: function (component) {
		if ($A.get('$Browser.isAndroid')) {
			var navService = component.find('navLink');
			navService.navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: '/apex/previous_back'
					}
				},
				true
			);
		} else {
			window.history.back(true);
		}
	},
	// closeModal: function (component, reload) {
	// 	var handleViewEvent = component.getEvent('closeModalEvent');
	// 	handleViewEvent.setParams({
	// 		key: 'closeModal',
	// 		reload: reload
	// 	});
	// 	handleViewEvent.fire();
	// 	$A.get('e.force:closeQuickAction').fire();
	// },
	showSuccessToast: function (component, event, helper) {
		// helper.closeModal(component, true);
		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			type: 'success',
			duration: '5000',
			mode: 'dismissible',
			title: 'Success!',
			message: 'The order has been created successfully.'
		});
		toastEvent.fire();
	},

	retrievePMActivityTypeOptions: function (component, event, orderType) {
		let action = component.get('c.getPMActivityType');
		action.setParams({
			orderType: orderType
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let pmActivityTypes = response.getReturnValue();
				component.set('v.pmActivityTypeOptions', pmActivityTypes);
				component.set('v.pmActivityTypesFilteredAndSearched', pmActivityTypes);
			} else if (state === 'INCOMPLETE') {
				// do something
			} else if (state === 'ERROR') {
				let errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.error('Error message: ' + errors[0].message);
					}
				} else {
					console.log('Unknown error');
				}
			}
			component.set('v.isLoading', false);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	retrieveMainWorkCenterOptions: function (component, event) {
		let action = component.get('c.getMainWorkCenters');
		// action.setParams({
		// 	mainWorkCenterPlantId: component.get('v.mainWorkCenterPlantValue')
		// });
		if (!component.get('v.mainWorkCenterPlantValue')) {
			action.setParams({
				mainWorkCenterPlantId: null
			});
		} else {
			action.setParams({
				mainWorkCenterPlantId: component.get('v.mainWorkCenterPlantValue')
			});
		}
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let mainWorkCenters = response.getReturnValue();
				component.set('v.mainWorkCenterOptions', mainWorkCenters);
				component.set('v.mainWorkCentersFilteredAndSearched', mainWorkCenters);
			} else if (state === 'INCOMPLETE') {
				// do something
			} else if (state === 'ERROR') {
				let errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.error('Error message: ' + errors[0].message);
					}
				} else {
					console.log('Unknown error');
				}
			}
			component.set('v.isLoading', false);
		});
		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	retrieveMainWorkCenterPlantOptions: function (component, event) {
		let action = component.get('c.getMainWorkCenterPlants');
		var mainWorkCenterId = component.get('v.mainWorkCenterValue');
		action.setParams({
			mainWorkCenterId: Array.isArray(mainWorkCenterId) ? mainWorkCenterId[0] : mainWorkCenterId
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let mainWorkCenters = response.getReturnValue();
				component.set('v.mainWorkCenterPlantOptions', mainWorkCenters);
				component.set('v.mainWorkCenterPlantsFilteredAndSearched', mainWorkCenters);
			} else if (state === 'INCOMPLETE') {
				// do something
			} else if (state === 'ERROR') {
				let errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.error('Error message: ' + errors[0].message);
					}
				} else {
					console.log('Unknown error');
				}
			}
			component.set('v.isLoading', false);
		});

		component.set('v.isLoading', true);
		$A.enqueueAction(action);
	},

	getPISRequester: function (component, fieldName, searchText) {
		var helper = this;
		var action = component.get('c.getPISRequester');
		action.setParams({
			searchText: searchText
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set(
					`v.formOption.${fieldName}`,
					result.map((m) => {
						const { ENFIRSTNAME__c, ENLASTNAME__c, Name } = m;
						m.ENFIRSTNAME__c = !ENFIRSTNAME__c || !ENLASTNAME__c ? Name : ENFIRSTNAME__c;
						m.avatar = (ENFIRSTNAME__c ? ENFIRSTNAME__c[0] : '') + (ENLASTNAME__c ? ENLASTNAME__c[0] : '');
						return m;
					})
				);
			} else {
				var errors = response.getError();
				console.error(JSON.parse(JSON.stringify(errors)));
			}
		});
		$A.enqueueAction(action);
	}
});