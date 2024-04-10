({
	doneRendering: function (component, event, helper) {
		let pageref = component.get('v.pageReference');
		let recordId = pageref.state.c__recordId;
		if (recordId) {
			component.set('v.recordId', recordId);

			if (!component.get('v.componentRequest')) {
				helper.retrieveComponentRequest(component);
			}
		}
	},

	handleRefresh: function (component, event, helper) {
		$A.get('e.force:refreshView').fire();
	}
});