({
	handleMessage: function (component, event, helper) {
		const params = event.getParams();
		console.log(helper.parseObject(params));
	},
	handleErorr: function (component, event, helper) {
		const params = event.getParams();
		console.log(helper.parseObject(params));
	}
});