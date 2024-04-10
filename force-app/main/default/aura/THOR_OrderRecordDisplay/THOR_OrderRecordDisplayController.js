({
	doInit: function (component, event, helper) {
		let pageref = component.get('v.pageReference');
		if (pageref && !component.get('v.recordId')) {
			let { c__recordId } = pageref.state;
			component.set('v.recordId', c__recordId);
			if (component.find('orderLoader')) component.find('orderLoader').reloadRecord(true);
		}

		var action = component.get('c.hasWriteAccess');
		action.setParams({
			recordId: component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var hasWriteAccess = response.getReturnValue();
				component.set('v.hasWriteAccess', hasWriteAccess);
				// console.log({ hasWriteAccess });
			}
		});
		$A.enqueueAction(action);

		helper.handleSetInterval(component);
	},
	doneRendering: function (component, event, helper) {
		let pageref = component.get('v.pageReference');
		// let recordId = pageref.state.c__recordId;
		// if (recordId) {
		// 	let cmpRecordId = component.get('v.recordId');

		// 	if (recordId != cmpRecordId) {
		// 		component.set('v.recordId', recordId);
		// 		component.set('v.isLoading', true);
		// 	}
		// }

		if (pageref) {
			let backToTabIndex = pageref.state.c__backToTabIndex;
			if (backToTabIndex && component.get('v.selected') == null) {
				component.set('v.selected', backToTabIndex);
			}

			if (component.get('v.selected') == null) {
				component.set('v.selected', 0);
			}
		}
	},

	reInit: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},

	navigateHelper: function (component, event) {
		let recordId = event.getParam('theRecordId');
		let toThisComponent = event.getParam('toThisComponent');
		let fromRecordId = component.get('v.recordId');

		recordId = toThisComponent === 'c__THOR_FunctionalLocationHistoryListDisplayer' ? recordId.Id : recordId;

		let navLink = component.find('navLink');
		let pageRef = {
			type: 'standard__component',
			attributes: {
				componentName: toThisComponent
			},
			state: {
				c__recordId: recordId,
				c__fromRecordId: fromRecordId
			}
		};
		navLink.navigate(pageRef, false);
	},

	fireModalEvent: function (component, event) {
		// var openModalEvent = $A.get('e.c:THOR_openOrderEditModal');
		// openModalEvent.fire();
		component.find('navLink').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_OrderEditModal`,
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
	},

	createSubOrder: function (component, event, helper) {
		// component.set('v.createNew', true);
		component.find('navLink').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_SubOrderCreation`,
							attributes: {
								orderId: component.get('v.recordId'),
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
		component.set('v.createNew', false);
	},

	closeOrder: function (component, event, helper) {
		helper.closeOrder(component);
	},

	handleRecordUpdated: function (component, event, helper) {
		let orderRecord = component.get('v.orderRecord');

		if (orderRecord) {
			let userStatus = orderRecord.User_Status__c;
			let type = orderRecord.Order_Type__c;
			component.set('v.userStatus', userStatus);
			component.set('v.type', type);
		}

		// @description adjust only change type
		var eventParams = event.getParams();
		const { changeType, changedFields } = eventParams;
		if (changeType === 'CHANGED' && changedFields) {
			Object.keys(eventParams.changedFields).forEach((fieldName) => {
				component.set(`v.orderRecord.${fieldName}`, changedFields[fieldName].value);
			});
		}

		if (component.get('v.orderRecord')) {
			component.set(
				'v.isModalAction.alert',
				!component.get('v.orderRecord.Integration_Status__c') ||
					component.get('v.orderRecord.Integration_Status__c') === 'Failed'
			);
		}
		if (!component.get('v.interval') && component.get(`v.orderRecord.Integration_Status__c`) === 'In Progress') {
			helper.handleSetInterval(component);
		}
	},

	// handleOnLoad: function (component, event, helper) {
	// 	component.set('v.isLoading', false);
	// },

	stopLoading: function (component, event, helper) {
		var target = event.getParam('target');
		if (target === 'stopLoading') {
			component.set('v.isLoading', false);
		}
	},

	reload: function (component, event) {
		var target = event.getParam('target');
		if (target == 'recordSaved') {
			var recordId = component.get('v.recordId');
			component.set('v.recordId', '');
			component.set('v.recordId', recordId);
		}
	},

	handleSelectButtonMenu: function (component, event, helper) {
		var selectedFunc = event.getParam('value');
		if (selectedFunc) $A.enqueueAction(component.get(selectedFunc));
	},
	createNotification: function (component, event, helper) {
		// component.find('THOR_NotificationCreation').openModal(component.get('v.recordId'));
		component.find('navLink').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_NotificationCreation`,
							attributes: {
								orderId: component.get('v.recordId'),
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
	closeAlertIntegration: function (component, event, helper) {
		component.set('v.isModalAction.alert', false);
	},
	discardOrder: function (component, event, helper) {
		var isDiscard = event && event.getSource().get('v.name') === 'discard';
		if (isDiscard) {
			component.find('orderLoader').deleteRecord(
				$A.getCallback(() => {
					event.preventDefault();
					var navLink = component.find('navLink');
					navLink.navigate(
						component.get('v.orderRecord.Super_Order__c')
							? {
									type: 'standard__component',
									attributes: {
										componentName: 'c__THOR_OrderRecordDisplay'
									},
									state: {
										c__recordId: component.get('v.orderRecord.Super_Order__c'),
										c__backToTabIndex: 4
									}
							  }
							: {
									type: 'standard__navItemPage',
									attributes: {
										apiName: 'Orders'
									}
							  },
						true
					);
				})
			);
		}

		component.set('v.isModalAction.discard', !component.get('v.isModalAction.discard'));
	},
	resendOrder: function (component, event, helper) {
		if (component.find('recordResendForm')) component.find('recordResendForm').submit();
		component.set('v.isModalAction.resend', !component.get('v.isModalAction.resend'));
		$A.get('e.force:refreshView').fire();
	},
	handleResendFormError: function (component, event, helper) {
		try {
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
		} catch (error) {
			console.error(error);
		}
	}
});