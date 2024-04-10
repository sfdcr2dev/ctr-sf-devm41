({
    doInit: function (component, event, helper) {
		window.setTimeout(
			$A.getCallback(function () {
				helper.getOrders(component, event, helper);
			}),
			500
		);
	},
	newOrder: function (component, event, helper) {
		// component.set('v.createNew', true);
		var recordId = component.get("v.recordId");
        // console.log('form rec: ', recordId);
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
                				"formMode": 'New'
							},
						})
					)}`
				},
			},
			false
		);
	},

	handleCloseModal: function (component, event, helper) {
		var key = event.getParam('key');
		if (key == 'closeModal') {
			component.set('v.createNew', false);

			var reload = event.getParam('reload');
			if (reload) {
				$A.get('e.force:refreshView').fire();
			}
		}
	}
});