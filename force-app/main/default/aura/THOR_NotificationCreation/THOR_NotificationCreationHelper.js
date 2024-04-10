({
	handlerPreventEnter: function (component, isActive) {
		var preventEnter = $A.getCallback((event) => {
			event.preventDefault();
			if (event.keyCode === 13) {
				component.set('v.pressKey.enter', true);
			}
		});

		if (isActive) {
			window.addEventListener('keyup', preventEnter);
		} else {
			window.removeEventListener('keyup', preventEnter);
		}
	},
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
				component.set('v.form.Equipment__c', result && result.length > 0 ? result.find((f) => f).Id : null);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});

		if (funcLocationId) $A.enqueueAction(action);
		else {
			component.set('v.form.Equipment__c', null);
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
				component.set('v.form.Main_Work_Center__c', MainWorkCenter__c);
				component.set('v.form.mainWorkCenterPlant__c', mainWorkCenterPlant__c);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});

		if (funcLocationId) $A.enqueueAction(action);
		else {
			component.set('v.form.Main_Work_Center__c', null);
			component.set('v.form.mainWorkCenterPlant__c', null);
		}
	},

	getMainWorkCenterPlants: function (component) {
		var action = component.get('c.getMainWorkCenterPlants');
		action.setParams({
			mainWorkCenterId: Array.isArray(component.get('v.form.Main_Work_Center__c'))
				? component.get('v.form.Main_Work_Center__c.0')
				: component.get('v.form.Main_Work_Center__c')
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
		var mainWorkCenterPlantsId = component.get('v.form.mainWorkCenterPlant__c');
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
		//if (component.get('v.form.mainWorkCenterPlant__c')) $A.enqueueAction(action);
		$A.enqueueAction(action);
	},

	getPISRequester: function (component, searchText) {
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
					'v.formOption.Requester_PISUser__c',
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
				component.set('v.form.Department_Resp__c', result);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});

		if (PISUserId) {
			$A.enqueueAction(action);
		} else {
			component.set('v.form.Department_Resp__c', '');
		}
	},

	getOrdersDetailById: function (component, orderId) {
		var action = component.get('c.getOrdersDetailById');
		action.setParams({
			orderId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.form', result);
				component.set('v.form.Requester_PISUser__c', component.get('v.form.Requester_PISUser__c') || null);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});
		$A.enqueueAction(action);
	}
});