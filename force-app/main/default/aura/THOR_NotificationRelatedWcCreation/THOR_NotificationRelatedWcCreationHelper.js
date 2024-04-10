({
	makeToast: function (type, title, message) {
		var toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title: title,
			message: message,
			type: type
		});
		toastEvent.fire();
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

	getNotificationDetailById: function (component, event, helper) {
		var notiId = component.get('v.notificationId');
		var action = component.get('c.getNotificationDetailById');
		action.setParams({
			notificationId: notiId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				//alert(JSON.stringify(result));
				if (result.Functional_Location__c != null) {
					component.set('v.form.FunctionalLocation__c', result.Functional_Location__c);
					component.set('v.form.Planning_Plant__c', result.Functional_Location__r.Planning_Plant__c);
				}
				if (result.Planning_Plant__c != null) {
					component.set('v.form.Planning_Plant__c', result.Planning_Plant__c);
				}
				if (result.Priority__c != null) {
					let priority = {
						Immediately: '1',
						Urgent: '2',
						Normal: '3',
						'Float Time - 1M': 'A',
						'Float Time - 3M': 'C',
						'Float Time - 6M': 'F',
						'Float Time - 9M': 'I',
						'Float Time - 12M': 'L',
						'Float Time - 15M': 'O',
						'Float Time - 18M': 'R'
					};
					component.set('v.form.Priority__c', priority[result.Priority__c]);
				}
				if (result.Requester_PISUser__c != null) {
					component.set('v.form.Requester__c', result.Requester_PISUser__r.Name);
					component.set('v.form.Requester_UI__c', result.Requester_PISUser__c);
				}
				if (result.Functional_Location__r != null && result.Functional_Location__r.Name != null) {
					//alert(result.Requester__c);
					component.set('v.form.Description__c', result.Functional_Location__r.Name);
				}
				if (result.Plant_Section__c != null) {
					//alert(result.Plant_Section__c);
					//component.set('v.form.Area__c', result.Plant_Section__c);

					component.set('v.form.Area_Code__c', result.Plant_Section__c);

					let areas = component.get('v.areas');
					let area = areas.find((value) => { return value.Name == result.Plant_Section__c});
					if (area) {
						component.set('v.form.Area__c', area.Description__c);
					}
				}
				if (result.Main_Work_Center__c != null) {
					// alert(result.Main_Work_Center_Text__c);Main_Work_Center_Text__c
					component.set('v.form.Main_Work_Center__c', result.Main_Work_Center__c);
					component.set('v.form.Maintenance_Unit__c', result.Main_Work_Center__r.Name);
				}
				if (result.Description__c != null) {
					// alert(result.Main_Work_Center_Text__c);Main_Work_Center_Text__c
					component.set('v.form.Problem__c', result.Description__c);
				}
				if (result.Requester__c != null) {
					// alert(result.Main_Work_Center_Text__c);Main_Work_Center_Text__c
					component.set('v.form.Thaioil_Supervisor_Indicator__c', result.Requester__c);
				}
				if (result.High_Risk_Work__c != null) {
					let highRiskWork = {
						'Hot work' : 'Hot work',
						'Confined Space': 'Confined Space',
						'Crane': 'Crane',
						'Radiation': 'Radiation',
						'Jack Hammer': 'Jack Hammer',
						'High Pressure Water Jet': 'High Pressure Water Jet',
						'Digging': 'Digging',
						'Work at High': 'Work at High',
						'Online Stop Leak': 'Online Stop Leak'
					};
					component.set('v.form.High_Risk_Work__c', highRiskWork[result.High_Risk_Work__c]);
				}
				// if(result.Notification__r.Requester__c != null){
				// 	// alert(result.Main_Work_Center_Text__c);Main_Work_Center_Text__c
				// 	component.set("v.form.Bearer1__c", result.Notification__r.Requester__c);
				// }
				helper.stopLoading(component, event);
				// alert(component.get("v.isLoading"))
				//component.set('v.form', result);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});
		$A.enqueueAction(action);
	},

	getPISRequester: function (component, searchText, field) {
		var helper = this;
		var action = component.get('c.getPISRequester');
		action.setParams({
			searchText: searchText
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				switch (field) {
					case 'Thaioil_Supervisor_Indicator_UI__c':
						component.set(
							'v.formOption.Thaioil_Supervisor_Indicator_UI__c',
							result.map((m) => {
								const { ENFIRSTNAME__c, ENLASTNAME__c, Name } = m;
								m.ENFIRSTNAME__c = !ENFIRSTNAME__c || !ENLASTNAME__c ? Name : ENFIRSTNAME__c;
								m.avatar = (ENFIRSTNAME__c ? ENFIRSTNAME__c[0] : '') + (ENLASTNAME__c ? ENLASTNAME__c[0] : '');
								return m;
							})
						);
						break;
					case 'Requester_UI__c':
						component.set(
							'v.formOption.Requester_UI__c',
							result.map((m) => {
								const { ENFIRSTNAME__c, ENLASTNAME__c, Name } = m;
								m.ENFIRSTNAME__c = !ENFIRSTNAME__c || !ENLASTNAME__c ? Name : ENFIRSTNAME__c;
								m.avatar = (ENFIRSTNAME__c ? ENFIRSTNAME__c[0] : '') + (ENLASTNAME__c ? ENLASTNAME__c[0] : '');
								return m;
							})
						);
						break;
				}
			} else {
				var errors = response.getError();
				console.error(JSON.parse(JSON.stringify(errors)));
			}
		});
		$A.enqueueAction(action);
	},

	getApplicantOrBearer: function (component, searchText, field) {
		var helper = this;
		var action = component.get('c.getApplicantOrBearer');
		action.setParams({
			searchText: searchText
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				switch (field) {
					case 'Applicant_or_Bearer_UI__c':
						component.set(
							'v.formOption.Applicant_or_Bearer_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Bearer1_UI__c':
						component.set(
							'v.formOption.Bearer1_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Bearer2_UI__c':
						component.set(
							'v.formOption.Bearer2_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Bearer3_UI__c':
						component.set(
							'v.formOption.Bearer3_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Bearer4_UI__c':
						component.set(
							'v.formOption.Bearer4_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
				}
			} else {
				var errors = response.getError();
				console.error(JSON.parse(JSON.stringify(errors)));
			}
		});
		$A.enqueueAction(action);
	},

	getSafetyPermit: function (component, searchText, field) {
		var helper = this;
		var action = component.get('c.getSafetyPermit');
		action.setParams({
			searchText: searchText
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				switch (field) {
					case 'Safety_Permit1_UI__c':
						component.set(
							'v.formOption.Safety_Permit1_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Safety_Permit2_UI__c':
						component.set(
							'v.formOption.Safety_Permit2_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
					case 'Safety_Permit3_UI__c':
						component.set(
							'v.formOption.Safety_Permit3_UI__c',
							result.map((m) => {
								return m;
							})
						);
						break;
				}
			} else {
				var errors = response.getError();
				console.error(JSON.parse(JSON.stringify(errors)));
			}
		});
		$A.enqueueAction(action);
	},
    

	getAreas: function (component, event, helper) {
		var action = component.get('c.getAreas');

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();

				component.set('v.areas', result);
				helper.getNotificationDetailById(component, event, helper);
			} else {
				var errors = response.getError();
				console.error(errors);
			}
		});

		$A.enqueueAction(action);
	},

	// createObjectData: function(component, event) {
	//     // get the contactList from component and add(push) New Object to List
	//     var RowItemList = component.get("v.WcList");
	//     RowItemList.push({
	//         'sobjectType': 'Work_Clearance__c',
	//         'What_can_go_4__c': '',
	//         'What_can_cause_4__c': '',
	//         'What_can_you_4__c': ''
	//     });
	//     // set the updated list to attribute (contactList) again
	//     component.set("v.WcList", RowItemList);
	// },
	// helper function for check if first Name is not null/blank on save
	// validateRequired: function(component, event) {
	//     var isValid = true;
	//     var allContactRows = component.get("v.WcList");
	//     for (var indexVar = 0; indexVar < allContactRows.length; indexVar++) {
	//         if (allContactRows[indexVar].FirstName == '') {
	//             isValid = false;
	//             alert('First Name Can\'t be Blank on Row Number ' + (indexVar + 1));
	//         }
	//     }
	//     return isValid;
	// },
});