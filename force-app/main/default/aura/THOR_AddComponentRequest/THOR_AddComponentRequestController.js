({
	init: function (component, event, helper) {
		// let pageref = component.get('v.pageReference');
		// let recordId = pageref.state.c__recordId;
		let recordId = component.get('v.pageReference.state.c__recordId');
		component.set('v.recordId', component.get('v.recordId') || recordId);
		component.set(
			'v.cols',
			[
				{ label: 'No.', fieldName: 'Index', type: 'text', fixedWidth: 80 },
				{ label: 'Material No.', fieldName: 'Material_Number__c', type: 'text' },
				{
					label: 'Material Description',
					fieldName: 'Material_Description__c',
					type: 'text',
					wrapText: true
				},
				{
					label: 'Available Qty.',
					fieldName: 'Available_Quantity__c',
					cellAttributes: {
						alignment: 'center'
					}
				},
				{
					label: 'UM',
					fieldName: 'Base_Unit__c',
					type: 'text',
					cellAttributes: {
						alignment: 'center'
					}
				},
				{
					label: 'Plant',
					fieldName: 'Plant__c',
					type: 'text',
					cellAttributes: {
						alignment: 'center'
					}
				}
			].map((m) => {
				if (component.get('v.formFactor') !== 'DESKTOP') {
					m.fixedWidth =
						{
							Material_Number__c: 160,
							Material_Description__c: 240,
							Available_Quantity__c: 160,
							Base_Unit__c: 80,
							Plant__c: 160
						}[m.fieldName] || m.fixedWidth;
				}
				return m;
			})
		);
		component.set('v.showConfirmation', false);
		component.set('v.modalContent', 'Are you sure that you want to leave this page, your data will be lost?');
		let action = component.get('c.getFunctionalLocationEquipment');
		action.setParams({ orderId: component.get('v.recordId') });
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === 'SUCCESS') {
				let order = response.getReturnValue();
				component.set('v.functionalLocation', order.Functional_Location__c);
				component.set('v.equipment', order.Equipment__c);
				if (order.Equipment__c !== null) {
					component.set('v.equipment', order.Equipment__c);
				}
			} else if (state === 'ERROR') {
			} else {
			}
			component.set('v.showSearch', true);
			helper.getData(component);
			helper.getCartSize(component);
		});
		$A.enqueueAction(action);
	},
	handleRowSelection: function (component, event) {
		let selectedRows = event.getParam('selectedRows');
		component.set('v.selectedComponents', selectedRows);
	},
	handleSelectedEvent: function (component, event, helper) {
		var target = event.getParam('target');
		if (target == 'Functional_Location__c') {
			var key = event.getParam('key');
			component.set('v.functionalLocation', key);
			if (key !== '' && key != null) {
				component.set('v.additionalConstraint', "AND FL__c = '" + key + "'");
			} else {
				component.set('v.additionalConstraint', '');
			}
		} else if (target == 'Equipment__c') {
			var key = event.getParam('key');
			//component.set("v.additionalConstraint", "");
			component.set('v.equipment', key);
		} else if (target == 'Spare_Part__c') {
			var key = event.getParam('key');
			component.set('v.material', key);
		}
		helper.getData(component);
	},
	selectedEvent: function (component, event, helper) {
		var length = component.get('v.material').length;
		if (length > 3) {
			var target = event.getParam('target');
			if (target == 'Functional_Location__c') {
				var key = event.getParam('key');
				component.set('v.functionalLocation', key);
				if (key !== '' && key != null) {
					component.set('v.additionalConstraint', "AND FL__c = '" + key + "'");
				} else {
					component.set('v.additionalConstraint', '');
				}
			} else if (target == 'Equipment__c') {
				var key = event.getParam('key');
				//component.set("v.additionalConstraint", "");
				component.set('v.equipment', key);
			} else if (target == 'Spare_Part__c') {
				var key = event.getParam('key');
				component.set('v.material', key);
			}
			helper.getData(component);
		} else {
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				title: 'Warning!',
				message: 'Please enter the keyword more than 3 character',
				type: 'warning'
			});
			toastEvent.fire();
		}
	},
	addToCart: function (component, event, helper) {
		let selectedComps = component.get('v.selectedComponents');
		let cart = new Set(component.get('v.cart'));
		let existingCart = component.get('v.existingCart');
		if (selectedComps.length != 0) {
			for (let i = 0; i < selectedComps.length; i++) {
				let exists = false;
				cart.forEach((item) => {
					if (item.Id === selectedComps[i].Id) {
						exists = true;
					}
				});
				if (!exists) {
					existingCart.forEach((item) => {
						if (item.Spare_Part__c === selectedComps[i].Id) {
							exists = true;
						}
					});
					if (!exists) cart.add(selectedComps[i]);
				}
			}
			component.set('v.selectedRows', []);
			component.set('v.selectedComponents', []);
			component.set('v.cart', cart);
			helper.saveCart(component);
		} else {
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				type: 'info',
				title: 'No items selected',
				message: 'You must select at least one item if you want to add to the cart.'
			});
			toastEvent.fire();
		}
	},
	handleBackButton: function (component, event, helper) {
		console.log(component.get('v.selectedComponents'));
		if (component.get('v.selectedComponents').length === 0 || component.get('v.selectedComponents') == null) {
			helper.navigateBack(component);
		} else {
			component.set('v.showConfirmation', true);
		}
	},
	handleConfirmationModal: function (component, event, helper) {
		var key = event.getParam('key');
		component.set('v.showConfirmation', false);
		if (key == 'closeModal') {
			helper.navigateBack(component);
		}
	},
	handleSearchFilter: function (component, event, helper) {
		let searchVal = event.getSource().get('v.value');
		if (searchVal == null) {
			component.set('v.filteredComponents', component.get('v.components'));
		} else {
			component.set('v.filteredComponents', []);
			let filteredComponents = [];
			let unfilteredComponents = component.get('v.components');
			for (let i = 0; i < unfilteredComponents.length; i++) {
				let item = unfilteredComponents[i];
				let isAdded = false;
				for (let prop in unfilteredComponents[i]) {
					if (!isAdded && item[prop] != null && item[prop].toString().includes(searchVal)) {
						filteredComponents.push(item);
						isAdded = true;
					}
				}
			}
			if (filteredComponents.length == 0) {
				component.set('v.noResults', true);
				component.set('v.message', 'No results. Refine your search.');
			} else {
				component.set('v.noResults', false);
			}
			component.set('v.filteredComponents', filteredComponents);
		}
	},

	forceRefresh: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},

	checkLength: function (component, event, helper) {
		var length = component.get('v.material').length;
		if (length > 0) {
			component.set('v.hideSearch', false);
		} else {
			component.set('v.hideSearch', true);
			helper.getData(component);
		}
		//else {
		//     var toastEvent = $A.get("e.force:showToast");
		//     toastEvent.setParams({
		//         "title": "Warning!",
		//         "message": "Please enter the keyword more than 3 character",
		//         "type": "warning"
		//     });
		//     toastEvent.fire();
		// }
	},

	navigateToCart: function (component) {
		component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_ManageComponentRequest`,
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

	handleLoadMoreData: function (component, event, helper) {
		helper.loadMoreData(component, event, helper);
	}
});