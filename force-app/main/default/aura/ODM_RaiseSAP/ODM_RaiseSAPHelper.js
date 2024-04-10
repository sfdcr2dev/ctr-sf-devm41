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
	getFunctionLocationDetail: function (component, funcLocationId) {
		var action = component.get('c.getFunctionLocationDetail');
		action.setParams({
			funcLocationId: funcLocationId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				const { MainWorkCenter__c, mainWorkCenterPlant__c } = result;
				// component.set('v.formData.Main_Work_Center__c', MainWorkCenter__c);
				// component.set('v.formData.mainWorkCenterPlant__c', mainWorkCenterPlant__c);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});

		if (funcLocationId) $A.enqueueAction(action);
		else {
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
				if (component.get('v.formOption.Main_Work_Center__c')) {
					component.set(
						'v.formOptionDisplay.Main_Work_Center__c',
						component.get('v.formOption.Main_Work_Center__c').filter((f) => {
							return (
								(f.Name && f.Name.toLowerCase().includes('OPS'.toLowerCase())) ||
								(f.Description__c && f.Description__c.toLowerCase().includes('OPS'.toLowerCase()))
							);
						})
					);
				}
				// component.set('v.formOptionDisplay.Main_Work_Center__c', component.get('v.formOption.Main_Work_Center__c'));
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});
		//if (component.get('v.formData.mainWorkCenterPlant__c')) $A.enqueueAction(action);
		$A.enqueueAction(action);
	},
	getPlanningPlants: function (component) {
		var action = component.get('c.getPlanningPlantList');
		var plannerGroupId = component.get('v.formData.Planner_Group__c');
		action.setParams({
			plannerGroupId: Array.isArray(plannerGroupId) ? plannerGroupId[0] : plannerGroupId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(result);
				component.set('v.formOption.Planning_Plant__c', result);
				component.set('v.formOptionDisplay.Planning_Plant__c', component.get('v.formOption.Planning_Plant__c'));
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});
		$A.enqueueAction(action);
	},
	getPlannerGroups: function (component) {
		var action = component.get('c.getPlannerGroupList');
		var planningPlantId = component.get('v.formData.Planning_Plant__c');
		action.setParams({
			planningPlantId: Array.isArray(planningPlantId) ? planningPlantId[0] : planningPlantId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				// console.log(result);
				component.set('v.formOption.Planner_Group__c', result);
				component.set('v.formOptionDisplay.Planner_Group__c', component.get('v.formOption.Planner_Group__c'));
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});
		$A.enqueueAction(action);
	},
	getPISUserDefault: function (component, event, helper) {
		return new Promise(function (resolve, reject) {
			let action = component.get('c.getPISUserDefault');
			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					resolve(response.getReturnValue());
				} else {
					reject(response.getError());
				}
			});
			$A.enqueueAction(action);
		});
	},
});