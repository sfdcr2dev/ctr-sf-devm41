({
	handleClick: function (component, event, helper) {
		var sourceTarget = event.getSource();
		console.log(sourceTarget);
	},
	redirectCreateNotification: function (component, event, helper) {
		component.find('navService').navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:THOR_NotificationCreation`,
							attributes: {
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
			false
		);
	}
});