({
	init: function (component, event, helper) {
		// let pageref = component.get('v.pageReference');
		// let recordId = pageref.state.c__recordId;
		let recordId = component.get('v.pageReference.state.c__recordId');
		component.set('v.recordId', component.get('v.recordId') || recordId);
		helper.getCart(component, 'Draft');

		helper.checkResponsiblePerson(component);
		helper.getOrderOperations(component);
		component.set('v.showConfirmation', false);
		component.set('v.modalContent', 'Are you sure that you want to leave this page, your data will be lost?');

		helper.handleSetInterval(component);
		helper.handleSetTimeout(component);
	},

	reInit: function (component, event, helper) {
		clearInterval(component.get('v.interval'));
		clearTimeout(component.get('v.timeout'));
		$A.get('e.force:refreshView').fire();
	},

	handleUpdateQuantity: function (component, event, helper) {
		let id = event.getParam('itemId');
		let quantity = event.getParam('newQuantity');
		let items = component.get('v.cart');
		for (let i = 0; i < items.length; i++) {
			if (items[i].Id === id) {
				items[i].Request_Material_Quantity__c = quantity;
			}
		}
		component.set('v.cart', items);
	},

	handleConfirmationModal: function (component, event, helper) {
		var key = event.getParam('key');
		component.set('v.showConfirmation', false);
		if (key == 'closeModal') {
			let state = component.get('v.modalMode');
			if (state === 'submit') {
				helper.submitRequest(component, event, helper);
			} else if (state === 'saveDraft') {
				helper.saveRequestDraft(component);
			} else if (state === 'delete') {
				helper.deleteRequest(component);
			}
		}
	},

	handleSubmitButton: function (component, event, helper) {
		if (component.get('v.hasResponsiblePerson')) {
			component.set('v.modalContent', 'Are you sure want to submit your order?');
			component.set('v.modalMode', 'submit');
			component.set('v.showConfirmation', true);
		} else {
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				type: 'warning',
				title: 'Please Set a Responsible Person',
				message: 'You must fill out the responsible person field on this order before submitting.'
			});
			toastEvent.fire();
		}
	},

	handleSaveDraftButton: function (component, event, helper) {
		component.set(
			'v.modalContent',
			'Are you sure you want to save this as a draft? Any previous drafts will be overwritten.'
		);
		component.set('v.modalMode', 'saveDraft');
		component.set('v.showConfirmation', true);
	},

	addComponent: function (component) {
		component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_AddComponentRequest`,
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
			true
		);
	},

	handleDeleteRequest: function (component, event, helper) {
		let id = event.getParam('recordId');
		component.set('v.requestToDelete', id);
		component.set('v.modalMode', 'delete');
		component.set('v.modalContent', 'Are you sure you want to remove this from your cart?');
		component.set('v.showConfirmation', true);
	},

	handleComponentSelect: function (component, event, helper) {
		let id = event.getParam('recordId');
		let selected = event.getParam('selected');
		let selectedComponents = component.get('v.selectedComponents');

		let index = selectedComponents.indexOf(id);
		let selectedCount = component.get('v.selectedCount');

		if (index > -1) {
			if (selected === false) {
				selectedComponents.splice(index, 1);
				component.set('v.selectedComponents', selectedComponents);
				selectedCount--;
			} else {
				let comps = component.find('compRecord');
				if (comps && selectedCount < comps.length) {
					selectedCount++;
				}
			}
		} else {
			if (selected === true) {
				selectedComponents.push(id);
				component.set('v.selectedComponents', selectedComponents);
				selectedCount++;
			} else {
				let comps = component.find('compRecord');
				if (comps && selectedCount > comps.length) {
					selectedCount--;
				}
			}
		}
		component.set('v.selectedCount', selectedCount);
		let comps = component.find('compRecord');
		let allSelector = component.find('selectAll');
		if (comps && comps.length === selectedCount) {
			allSelector.set('v.checked', true);
		} else {
			allSelector.set('v.checked', false);
		}
	},

	updateOperation: function (component, event, helper) {
		let op = component.find('operation').get('v.value');
		let opObjects = component.get('v.operationObjects');
		let operation;
		opObjects.forEach((item) => {
			if (item.Id == op) {
				operation = item;
			}
		});
		let spareParts = component.get('v.cart');
		let selectedComponents = component.get('v.selectedComponents');
		spareParts.forEach((part) => {
			selectedComponents.forEach((item) => {
				if (part.Id === item) {
					part.Operation__c = operation.Operation_Text__c;
					part.Order_Operation__c = operation.Id;
					part.OrderOperation = operation;
				}
			});
		});
		component.set('v.cart', spareParts);
		let comps = component.find('compRecord');
		if (Array.isArray(comps)) {
			comps.forEach((item) => {
				item.clearSelection();
			});
		} else {
			comps.clearSelection();
		}
		let allSelector = component.find('selectAll');
		if (allSelector.get('v.checked')) {
			allSelector.set('v.checked', false);
		}
	},

	selectAll: function (component, event) {
		if (event.getSource().get('v.checked') == true) {
			let comps = component.find('compRecord');
			if (Array.isArray(comps)) {
				comps.forEach((item) => {
					item.selectAll();
				});
				component.set('v.selectedCount', comps.length);
			} else {
				comps.selectAll();
				component.set('v.selectedCount', 1);
			}
		} else if (event.getSource().get('v.checked') == false) {
			let comps = component.find('compRecord');
			if (Array.isArray(comps)) {
				comps.forEach((item) => {
					item.clearSelection();
				});
				component.set('v.selectedCount', 0);
			} else {
				comps.clearSelection();
				component.set('v.selectedCount', 0);
			}
		}
	},

	handleCartDraft: function (component, event, helper) {
		var params = event.getParams();
		const { value } = params;

		var isOpenBefore = component.get('v.isModalAction.integration');
		component.set(
			'v.isModalAction.integration',
			Array.isArray(value) && value.some((s) => s.Integration_Status__c === 'In Progress')
		);
		var isOpenAfter = component.get('v.isModalAction.integration');

		if (isOpenBefore && !isOpenAfter) {
			// console.log(JSON.parse(JSON.stringify(value)));
			if (Array.isArray(value) && !value.some((s) => s.Integration_Status__c === 'Failed')) {
				component.find('navService').navigate(
					{
						type: 'standard__component',
						attributes: {
							componentName: 'c__THOR_OrderRecordDisplay'
						},
						state: {
							c__recordId: component.get('v.recordId'),
							c__backToTabIndex: 3
						}
					},
					true
				);
			}
		}
	}
});