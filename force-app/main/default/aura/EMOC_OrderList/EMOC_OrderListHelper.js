({
	getOrders: function (component, event, helper) {
		var action = component.get('c.getOrdersByFilter');
        var recordId = component.get("v.recordId");
        //console.log('getOrders: ', recordId);
        action.setParams({emocId: recordId});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
				var result = response.getReturnValue();
                component.set('v.orders', result.orderList);
                component.set('v.orders_length', result.orderList.length);
            }
        });
		$A.enqueueAction(action);
	}
});