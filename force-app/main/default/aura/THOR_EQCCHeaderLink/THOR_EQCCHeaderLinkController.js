({
	doInit: function (component, event, helper) {
		let header = component.get('v.header');
		let linkText = '';
		let inProgress = component.get('v.inprogress');

		if ('Notification__r' in header && inProgress) {
			linkText = header.Notification__r.Notification_Number__c + ', ';
		} else if (inProgress) {
			linkText = ', ';
		}
		if ('Order__r' in header && inProgress) {
			linkText += header.Order__r.Order_Number__c + ', ';
		} else if (inProgress) {
			linkText += ', ';
		}

		let hasFunctionalLocation = false;
		let hasEquipment = false;

		if ('FunctionalLocation__c' in header) {
			linkText += header.FunctionalLocation__r.Name;
			hasFunctionalLocation = true;
		}
		if ('Equipment__c' in header) {
			if (hasFunctionalLocation) {
				linkText += ', ';
			}
			linkText += header.Equipment__r.Name;
			hasEquipment = true;
		}
		if ('Order_Operation__r' in header) {
			/*if (hasFunctionalLocation) {
                linkText += ', ';
            }*/
			linkText += ', ' + header.Order_Operation__r.Operation_Shot_Text__c;
		}
		if ('Notification__r' in header && inProgress) {
			if (header.Notification__r.Description__c) {
				linkText += ', ' + header.Notification__r.Description__c;
			}
		}
		if ('Order__r' in header && inProgress) {
			if (header.Order__r.Description__c) {
				linkText += ', ' + header.Order__r.Description__c;
			}
		}
		if (!hasFunctionalLocation && !hasEquipment) {
			linkText = header.Name;
		}

		component.set('v.linkText', linkText);
	},
	goToHeaderPage: function (component, event, helper) {
		event.preventDefault();

		let eqccId = event.target.classList.value;
		component.find('navService').navigate(
			{
				type: 'standard__component',
				attributes: {
					componentName: 'c__THOR_EQCCHeaderRecordDisplay'
				},
				state: {
					c__recordId: eqccId
				}
			},
			false
		);
	}
});