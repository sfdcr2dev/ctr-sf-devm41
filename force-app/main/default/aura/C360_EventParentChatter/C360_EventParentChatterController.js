({
	doInit : function(component, event, helper) {
		var recordId = component.get('v.recordId');
        var action = component.get('c.getParent');
        action.setParams({'eventId' : recordId});
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state==='SUCCESS'){
                var eve = res.getReturnValue();
                component.set('v.parentId', eve.Parent__c);
            }
        });
        $A.enqueueAction(action);
    },
})