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

	getCatelogProfileByEquipIdOrFuncId: function (component, equipIdOrFuncId) {
		return new Promise(
			$A.getCallback((resolve, reject) => {
				let action = component.get('c.hasCatelogProfileByEquipIdOrFuncId');
				action.setParams({
					equipIdOrFuncId
				});
				action.setCallback(this, function (response) {
					let state = response.getState();
					if (state === 'SUCCESS') {
						let result = response.getReturnValue();
						// console.log({ result });
						resolve(result);
					} else if (state === 'ERROR') {
						let errors = response.getError();
						console.error(errors[0] ? errors[0] : errors);
						resolve(false);
					}
				});
				$A.enqueueAction(action);
			})
		);
	},
	retrieveCodeGroup: function (component) {
		var helper = this;
		let action = component.get('c.retrieveCodeGroup');
		let catalogProfileId = component.get('v.catalogProfileId');
		catalogProfileId = catalogProfileId ? catalogProfileId : null;

		action.setParams({
			catalogProfileId
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let result = response.getReturnValue();
				// console.log({ catalogProfileId, result });

				component.set('v.codeGroupOptions', result);
				component.set('v.formOption.Code_Group__c', result);
			} else if (state === 'ERROR') {
				let errors = response.getError();
				console.error(errors[0] ? errors[0] : errors);
			}
		});

		component.set('v.formOption.Code_Group__c', []);
		$A.enqueueAction(action);
	},
	retrieveFaultCodeOptions: function (component) {
		component.set('v.isLoadingFaultCode', true);

		let equipment = component.get('v.lookupEquipments')
			? component.find('Equipment__c').get('v.value')
			: component.find('equipmentOptions').get('v.value');
		let functionalLocation = component.find('fl').get('v.value');

		let action = component.get('c.retrieveFaultCodes');
		action.setParams({
			equipmentId: equipment ? equipment : null,
			funcLocationId: functionalLocation ? functionalLocation : null,
			codeGroupId: component.get('v.form.Code_Group__c')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let faultCodes = response.getReturnValue();
				// console.log({ faultCodes });
				component.set('v.faultCodeOptions', faultCodes);
				component.set('v.formOption.Fault_Code__c', faultCodes);
			} else if (state === 'ERROR') {
				let errors = response.getError();
				console.error(errors[0] ? errors[0] : errors);
			}
			component.set('v.isLoadingFaultCode', false);
		});

		component.set('v.formOption.Fault_Code__c', []);
		$A.enqueueAction(action);
	},

	getFaultCodeAndMainWorkCenter: function (component, event) {
		let action = component.get('c.getNotificationById');
		action.setParams({
			notificationId: component.get('v.recordId')
		});

		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let returnedValue = response.getReturnValue();

				component.set('v.form.Fault_Code__c', returnedValue.Fault_Code__c || null);
				component.set('v.mainWorkCenterValue', returnedValue.Main_Work_Center__c || '');
				component.set('v.mainWorkCenterPlantValue', returnedValue.mainWorkCenterPlant__c || '');
			} else {
				let errors = response.getError();
				console.error(errors[0] ? errors[0] : errors);
			}
			component.set('v.isLoadingFCandMWC', false);
			this.isLoading(component);
		});

		component.set('v.isLoadingFCandMWC', true);
		this.isLoading(component);
		$A.enqueueAction(action);
	},

	retrieveMainWorkCenterOptions: function (component, event) {
		let action = component.get('c.getMainWorkCenters');
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
			} else if (state === 'ERROR') {
				let errors = response.getError();
				console.error(errors[0] ? errors[0] : errors);
			}
			component.set('v.isLoadingMWCOptions', false);
			this.isLoading(component);
		});

		component.set('v.isLoadingMWCOptions', true);
		this.isLoading(component);
		$A.enqueueAction(action);
	},

	retrieveMainWorkCenterPlantOptions: function (component, event) {
		let action = component.get('c.getMainWorkCenterPlants');
		action.setParams({
			mainWorkCenterId: component.get('v.mainWorkCenterValue')
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let mainWorkCenters = response.getReturnValue();
				component.set('v.mainWorkCenterPlantOptions', mainWorkCenters);
				component.set('v.mainWorkCenterPlantsFilteredAndSearched', mainWorkCenters);
			} else if (state === 'ERROR') {
				let errors = response.getError();
				console.error(errors[0] ? errors[0] : errors);
			}
			component.set('v.isLoadingMWCOptions', false);
			this.isLoading(component);
		});

		component.set('v.isLoadingMWCOptions', true);
		this.isLoading(component);
		$A.enqueueAction(action);
	},

	isLoading: function (component) {
		var isLoadingFCandMWC = component.get('v.isLoadingFCandMWC');
		var isLoadingMWCOptions = component.get('v.isLoadingMWCOptions');
		var isLoading = isLoadingFCandMWC || isLoadingMWCOptions;
		component.set('v.isLoading', isLoading);
	}
});