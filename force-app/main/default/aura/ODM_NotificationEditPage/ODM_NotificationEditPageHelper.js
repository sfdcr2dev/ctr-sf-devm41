({
	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},
	startLoading: function (component) {
		component.set('v.isLoading', true);
	},
	stopLoading: function (component) {
		component.set('v.isLoading', false);
	},
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
	getDepartmentResp: function (component, PISUserId) {
		var action = component.get('c.getDepartmentResp');
		action.setParams({
			PISUserId: PISUserId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.formData.Department_Resp__c', result);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});

		if (PISUserId) {
			$A.enqueueAction(action);
		} else {
			component.set('v.formData.Department_Resp__c', '');
		}
	},
	getEquipmentByFL: function (component, funcLocationId) {
		var action = component.get('c.getEquipmentByFL');
		action.setParams({
			funcLocationId: funcLocationId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				component.set(
					'v.formOption.Equipment__c',
					result
						? result.map((m) => ({
							label: m.Name,
							value: m.Id
						}))
						: []
				);
				component.set('v.formData.Equipment__c', result && result.length > 0 ? result.find((f) => f).Id : null);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});

		if (funcLocationId) $A.enqueueAction(action);
		else {
			component.set('v.formData.Equipment__c', null);
			component.set('v.formOption.Equipment__c', []);
		}
	},
	getPISUsers: function (component, event, helper) {
		let recordUi = component.get('v.notificationRecordUi');

		let fields = [
			'Requester_PISUser__c'
		];

		let pisuserIds = [];
		fields.forEach(function (field) {
			let id = recordUi.record.fields[field] ? recordUi.record.fields[field].value : null;
			id && pisuserIds.push(id);
		});

		if (pisuserIds.length > 0) {
			let action = component.get('c.getPISUserList');

			action.setParams({
				pisuserIds: pisuserIds
			});

			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					let recordUi = component.get('v.notificationRecordUi');
					let pisuserList = response.getReturnValue();

					fields.forEach(function (field) {
						let id = recordUi.record.fields[field] ? recordUi.record.fields[field].value : null;
						if (id && pisuserList[id]) {
							recordUi.record.fields[field].displayValue = pisuserList[id].ENFIRSTNAME__c + ' ' + pisuserList[id].ENLASTNAME__c
						}
					});

					component.set('v.notificationRecordUi', recordUi);
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
			});
			$A.enqueueAction(action);
		}
	},
	getFunctionLocationDetail: function (component, funcLocationId) {
		var action = component.get('c.getFunctionLocationDetail');
		action.setParams({
			funcLocationId: funcLocationId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				const { Description__c, MainWorkCenter__c, mainWorkCenterPlant__c } = result;
				component.set('v.flDesc', Description__c);
				component.set('v.formData.Main_Work_Center__c', MainWorkCenter__c);
				component.set('v.formData.mainWorkCenterPlant__c', mainWorkCenterPlant__c);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});

		if (funcLocationId) $A.enqueueAction(action);
		else {
			component.set('v.flDesc', null);
			component.set('v.formData.Main_Work_Center__c', null);
			component.set('v.formData.mainWorkCenterPlant__c', null);
		}
	},
	getMainWorkCenterPlants: function (component) {
		var action = component.get('c.getMainWorkCenterPlants');
		action.setParams({
			mainWorkCenterId: Array.isArray(component.get('v.formData.Main_Work_Center__c'))
				? component.get('v.formData.Main_Work_Center__c.0')
				: component.get('v.formData.Main_Work_Center__c')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.formOption.mainWorkCenterPlant__c', result);
				component.set(
					'v.formOptionDisplay.mainWorkCenterPlant__c',
					component.get('v.formOption.mainWorkCenterPlant__c')
				);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});
		$A.enqueueAction(action);
	},
	getMainWorkCenters: function (component) {
		var action = component.get('c.getMainWorkCenters');
		var mainWorkCenterPlantsId = component.get('v.formData.mainWorkCenterPlant__c');
		action.setParams({
			mainWorkCenterPlantsId: Array.isArray(mainWorkCenterPlantsId) ? mainWorkCenterPlantsId[0] : mainWorkCenterPlantsId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set(
					'v.formOption.Main_Work_Center__c',
					result.map((m) => ({
						Id: m.RelatedMasterMap1__r.Id,
						Name: m.RelatedMasterMap1__r.Name,
						Description__c: m.RelatedMasterMap1__r.Description__c
					}))
				);
				component.set('v.formOptionDisplay.Main_Work_Center__c', component.get('v.formOption.Main_Work_Center__c'));
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});
		//if (component.get('v.formData.mainWorkCenterPlant__c')) $A.enqueueAction(action);
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

				component.set('v.flDesc', returnedValue.Functional_Location__r.Description__c || '');
				component.set('v.formData.Fault_Code__c', returnedValue.Fault_Code__c || null);
				component.set('v.formData.Main_Work_Center__c', returnedValue.Main_Work_Center__c || '');
				component.set('v.formData.mainWorkCenterPlant__c', returnedValue.mainWorkCenterPlant__c || '');
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
	isLoading: function (component) {
		var isLoadingFCandMWC = component.get('v.isLoadingFCandMWC');
		var isLoadingMWCOptions = component.get('v.isLoadingMWCOptions');
		var isLoading = isLoadingFCandMWC || isLoadingMWCOptions;
		component.set('v.isLoading', isLoading);
	},
});