({
	doInit : function(component, event, helper) {
        //helper.setOrderDetails(component, event);
        var action = component.get("c.refresh");
        $A.enqueueAction(action);
	},
    refresh : function(component, event, helper) {
        //$A.get('e.force:refreshView').fire();
        helper.setOrderDetails(component, event);
	},
    renderToRecord : function(component, event, helper) {
        var buyingItemId = event.target.id;
        console.log('buyingItemId---'+buyingItemId);
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/r/C360_BuyingPerformanceDailyTOP__c/"+buyingItemId+"/view"
        });
        urlEvent.fire();
        
	},
    ViewAll : function(component, event, helper) {
        //$A.get('e.force:refreshView').fire();
        helper.setOrderDetailsViewAll(component, event);
	}
    
})