({
    doInit : function(component, event, helper) {
        var obj = component.get("v.object")
        switch(obj){
            case "Causes": helper.getCauses(component); break;
            case "Activities": helper.getActivities(component); break;
            case "Items": helper.getItems(component); break;
        }
    }
})