({
    show : function(component, event, helper) {
       component.set("v.isOpen", !component.get("v.isOpen"));
       helper.show(component);

    },

    firstShow : function(component, event, helper) {
        helper.show(component);
     },

    selected : function(component) {

        component.set("v.isSelected", !component.get("v.isSelected"));
    },
    save : function(component, event, helper) {
        helper.show(component);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();
 
     },

})