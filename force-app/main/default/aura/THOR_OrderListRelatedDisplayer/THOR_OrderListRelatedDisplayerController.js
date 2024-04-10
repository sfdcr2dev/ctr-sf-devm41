({
	doInit: function (component, event, helper) {
		component.set('v.body', null);
		component.set('v.orderId', component.get('v.pageReference.state.c__recordId'));
		component.set('v.relatedType', component.get('v.pageReference.state.c__relatedType'));

		if (component.get(`v.componentCreate.${component.get('v.relatedType')}`)) {
			$A.createComponents(
				[
					[
						`c:${component.get(`v.componentCreate.${component.get('v.relatedType')}`)}`,
						{
							'aura:id': `${component.get(`v.componentCreate.${component.get('v.relatedType')}`)}`,
							orderId: component.get(`v.orderId`)
						}
					]
				],
				function (components, status, errorMessage) {
					if (status === 'SUCCESS') {
						component.set('v.body', components);
					} else if (status === 'INCOMPLETE') {
						// Show offline error
						console.log('No response from server or client is offline.');
					} else if (status === 'ERROR') {
						// Show error message
						console.error('Error: ', errorMessage);
					}
				}
			);
		}
	}
});