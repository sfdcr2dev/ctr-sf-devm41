({
	doInit: function (component, event, helper) {
		helper.retrieveRelated(component, event);
	},

	getMessage: function (component, event) {
		//get method paramaters
		var params = event.getParam('arguments');
		if (params) {
			var param1 = params.Title;
			return param1;
		}
		return '';
	},
	navigateToRelated: function (component, event, helper) {
		let optionclicked = event.target.id;

		let recordId = component.get('v.recordId');
		let navLink = component.find('navLink');
		let pageRef;

		if (optionclicked === 'AttachedContentDocuments') {
			let recordId = component.get('v.recordId');
			pageRef = {
				type: 'standard__component',
				attributes: {
					componentName: 'c__THOR_NotificationRelatedFiles'
				},
				state: {
					c__notificationId: recordId
				}
			};
		} else {
			pageRef = {
				type: 'standard__component',
				attributes: {
					//componentName: 'c__THOR_NotificationRelatedListDisplayer'
					componentName: 'c__THOR_NotificationRelatedItems'
				},
				state: {
					//c__recordId: recordId
					c__notificationId: recordId
				}
			};
		}
		navLink.navigate(pageRef, false);
	}
});