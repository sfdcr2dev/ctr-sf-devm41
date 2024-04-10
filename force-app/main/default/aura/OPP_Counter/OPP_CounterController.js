({
    doInit : function(component, event, helper) {
        let page = component.get("v.page");
        //component.set("v.page", page);
        
        var action = component.get("c.addCounter");
        action.setParams({
            "page": page
        });
        $A.enqueueAction(action);
    }
})