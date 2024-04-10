({
	init: function (component, event, helper) {
		component.set('v.quantity', component.get('v.requestItem').Request_Material_Quantity__c);
	},

	increaseQuantity: function (component, event, helper) {
		let quantity = Number(component.get('v.quantity')) + 1;
		component.set('v.quantity', quantity);
		helper.updateQuantity(component);
	},

	decreaseQuantity: function (component, event, helper) {
		let quantity = Number(component.get('v.quantity'));
		if (quantity > 1) {
			quantity = quantity - 1;
			component.set('v.quantity', quantity);
			helper.updateQuantity(component);
		}
	},

	deleteRequest: function (component) {
		let deleteRequestEvt = component.getEvent('deleteRequest');
		deleteRequestEvt.setParams({
			recordId: component.get('v.recordId')
		});
		deleteRequestEvt.fire();
	},

	navigateToComponentDetail: function (component) {
		component.find('navService').navigate({
			type: 'standard__component',
			attributes: {
				componentName: 'c__THOR_ComponentRequestRecordDisplay'
			},
			state: {
				c__recordId: component.get('v.recordId')
			}
		});
	},

	selectRecord: function (component, event, helper) {
		helper.updateSelection(component);
	},

	selectAll: function (component, event, helper) {
		component.set('v.selected', true);
		helper.updateSelection(component);
	},

	clearSelection: function (component, event, helper) {
		component.set('v.selected', false);
	}
});