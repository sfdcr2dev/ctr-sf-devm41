({
	setOrderDetails: function (component,event) {
		//var orderId = component.get("v.recordId");

        var loadingStatus = component.get("v.loadingStatus");
		var accountId = component.get("v.recordId");
        var itemsize = component.get("v.itemsize");

        console.log('test----');
		let action = component.get("c.getTableDetails");
        action.setParams({
            customerID: accountId,
            status : loadingStatus
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === "SUCCESS") {
				var returnValue = response.getReturnValue();
				//alert('result='+ returnValue.toString());
				var listReturn = [];
                //console.log('returnValue----'+returnValue);
                
				for (var i = 0; i < returnValue.length; i++) {
                    if(i < returnValue.length - 1)
                    {
                        component.set("v.Object", returnValue[i]);
                        //alert('object='+ component.get("v.Object"));
                        listReturn.push(component.get("v.Object"));
                        
                    }
                    else
                    {
                        if(returnValue[i].itemsize >10 && loadingStatus == 'Loading')
                        {
                            component.set("v.itemsize", "10+");
                            component.set("v.isShowViewAll", 'true');
                        }
                        else
                        {
                            component.set("v.itemsize", returnValue[i].itemsize);
                            component.set("v.isShowViewAll", 'false');
                        }
                    }
					
                    
				}
                //alert('proudctList' + JSON.stringify(returnValue));		
				component.set("v.Objects", listReturn);
			} else {}
		});
		$A.enqueueAction(action);
	},
    setOrderDetailsViewAll: function (component,event) {
		var accountId = component.get("v.recordId");
        
        var evt = $A.get("e.force:navigateToComponent");
    evt.setParams({
        componentDef : "c:C360_TXBuyingPerformanceMonthlyRelatedList",
        componentAttributes: {
            recordId : accountId,
            loadingStatus : ''
        }
    });
    evt.fire();
	}
})