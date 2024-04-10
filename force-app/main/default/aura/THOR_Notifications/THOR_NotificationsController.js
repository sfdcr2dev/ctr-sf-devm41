({
	doInit: function (component, event, helper) {
		let recordId = component.get('v.recordId');

		if (recordId) {
			let action = component.get('c.hasWriteAccess');

			action.setParams({
				notificationId: recordId
			});

			action.setCallback(this, function (response) {
				let state = response.getState();
				if (state === 'SUCCESS') {
					component.set('v.hasWriteAccess', response.getReturnValue());
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

	newOrder: function (component, event, helper) {
		// component.set('v.createNew', true);
		component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_OrderCreation`,
							attributes: {
								notificationId: component.get('v.recordId'),
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								})
							}
						})
					)}`
				}
			},
			false
		);
	},
	handleCloseModal: function (component, event, helper) {
		var key = event.getParam('key');
		if (key == 'closeModal') {
			component.set('v.createNew', false);
		}
	},
	showEditModal: function (component, event, helper) {
		// var openModalEvent = $A.get('e.c:THOR_openNotificationEditModal');
		// openModalEvent.fire();
		try {
			component.find('navService').navigate(
				{
					type: 'standard__webPage',
					attributes: {
						url: `/one/one.app#${window.btoa(
							JSON.stringify({
								componentDef: `c:THOR_NotificationEditModal`,
								attributes: {
									recordId: component.get('v.recordId'),

									uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
										let r = (Math.random() * 16) | 0,
											v = c == 'x' ? r : (r & 0x3) | 0x8;
										return v.toString(16);
									})
								}
							})
						)}`
					}
				},
				false
			);
		} catch (err) {
			alert(err.message || err);
		}
	},

	closeNotification: function (component, event, helper) {
		let faultCode = component.get('v.notificationRecord.Fault_Code__c');
		let notificationStatus = component.get('v.notificationRecord.Notification_Status__c');

		if (notificationStatus != 'Closed') {
			if (faultCode) {
				helper.setNotificationStatus(component, event);
			} else {
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					type: 'Error',
					title: 'Error!',
					message: 'Fault Code is not set.'
				});
				toastEvent.fire();
			}
		} else {
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				type: 'Error',
				title: 'Error!',
				message: 'Notification already closed.'
			});
			toastEvent.fire();
		}
	},

	handleSelectButtonMenu: function (component, event, helper) {
		var selectedFunc = event.getParam('value');
		if (selectedFunc) {
			$A.enqueueAction(component.get(selectedFunc));
		}
	},
	// handleNotificationInfo: function (component, event, helper) {
	// 	var params = event.getParams();
	// 	const { expression, index } = params;
	// 	var oldValue = Array.isArray(params.oldValue) ? params.oldValue[0] : params.oldValue;
	// 	var value = Array.isArray(params.value) ? params.value[0] : params.value;
	// 	console.log({ expression, index, oldValue, value: JSON.parse(JSON.stringify(value)) });
	// },
	recordUpdated: function (component, event, helper) {
		var eventParams = event.getParams();
		const { changeType, changedFields } = eventParams;

		if (changeType === 'CHANGED' && changedFields) {
			Object.keys(eventParams.changedFields).forEach((fieldName) => {
				component.set(`v.notificationRecord.${fieldName}`, changedFields[fieldName].value);
			});
		}
	},

	discardNotification: function (component, event, helper) {
		var isDiscard = event && event.getSource().get('v.name') === 'discard';
		if (isDiscard) {
			try {
				component.find('notificationLoader').deleteRecord(
					$A.getCallback(() => {
						event.preventDefault();
						var navService = component.find('navService');
						navService.navigate(
							{
								type: 'standard__navItemPage',
								attributes: {
									apiName: 'Notifications'
								}
							},
							true
						);
					})
				);
			} catch (e) {
				console.error(e);
			}
		}

		component.set('v.isModalAction.discard', !component.get('v.isModalAction.discard'));
	},
	resendNotification: function (component, event, helper) {
		component.find('recordEditForm').submit();
		component.set('v.isModalAction.resend', !component.get('v.isModalAction.resend'));
		$A.get('e.force:refreshView').fire();
	},
	handleError: function (component, event, helper) {
		var params = event.getParams();
		const {
			output: { fieldErrors }
		} = params;
		const { errorCode, fieldLabel, message } =
			fieldErrors && Object.keys(fieldErrors).length ? fieldErrors[Object.keys(fieldErrors)[0]][0] : {};

		if (fieldLabel) {
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				title: fieldLabel,
				type: 'error',
				message: message ? message : 'Something went wrong!'
			});
			toastEvent.fire();
		}
	}
});