({
	doInit: function (component, event, helper) {
		var recordId = component.get('v.pageReference.state.c__recordId');
		component.set('v.recordId', recordId);
		helper.retrieveRelated(component, event);
		helper.setNotificationOrderId(component, event, helper);
		helper.checkOwnerOrAdmin(component);
	},

	handleRefresh: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	},

	navigateHelper: function (component, event) {
		let toComponent = event.getParam('toThisComponent');
		let recordId = event.getParam('theRecordId');
		let fromRecordId = component.get('v.recordId');

		recordId = toComponent === 'c__THOR_FunctionalLocationHistoryListDisplayer' ? recordId.Id : recordId;

		let navLink = component.find('navService');
		let pageRef = {
			type: 'standard__component',
			attributes: {
				componentName: toComponent
			},
			state: {
				c__recordId: recordId,
				c__fromRecordId: fromRecordId
			}
		};
		navLink.navigate(pageRef, false);
	},

	preventMe: function (component, event, helper) {
		event.preventDefault();
	},

	editHeader: function (component, event, helper) {
		component.set('v.showCreateModal', true);
	},

	deleteHeader: function (component, event, helper) {
		helper.deleteRecords(component, event, helper);
		component.set('v.showConfirmModal', false);
	},

	showConfirm: function (component, event, helper) {
		component.set('v.showConfirmModal', true);
	},

	cancelConfirm: function (component, event, helper) {
		component.set('v.showConfirmModal', false);
	},

	closeCreateModal: function (component, event, helper) {
		component.set('v.showCreateModal', false);
	}
});