({
	doInit: function (component, event, helper) {
		window.setTimeout(
			$A.getCallback(function () {
				helper.getOrders(component, event, helper);
			}),
			500
		);
	},
	navigateToDisplay: function (component, event, helper) {
		var recordId = event.currentTarget.getAttribute('data-record-id');
		var navService = component.find('navService');
        console.log('navigateToDisplay', recordId);
        component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app?#${window.btoa(
						JSON.stringify({
							componentDef: `c:EMOC_OrderForm`,
							attributes: {
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								}),
                            	"recordId": recordId,//'a1x6D0000008jK9QAI'
                				"formMode": 'View'
							},
						})
					)}`
				},
			},
			false
		);

	},
});