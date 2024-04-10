({
	doInit: function (component, event, helper) {
		let pageref = component.get('v.pageReference');
		let recordId = pageref.state.c__recordId;
		if (recordId) {
			let cmpRecordId = component.get('v.recordId');

			if (recordId != cmpRecordId) {
				component.set('v.recordId', recordId);
				component.set('v.isLoading', true);
			}
		}
		component.set('v.isLoading', false);
	},
	handleRefresh: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	}

	// handleOnLoad: function (component, event, helper) {
	// 	component.set('v.isLoading', false);
	// }
});