({
	doInit: function (component, event, helper) {
		window.setTimeout(
			$A.getCallback(function () {
				var pathname = window.location.href;
				component.set(
					'v.isShowTitle',
					!(pathname.includes('Notifications') || pathname.includes('Orders') || pathname.includes('Work_Clearances'))
				);
			}),
			250
		);
	}
});