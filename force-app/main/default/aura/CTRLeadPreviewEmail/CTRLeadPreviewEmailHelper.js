({
	closeModal : function (component) {
        if(component.get('v.isChildModal')) {
            component.set("v.openModal", false);
        } else {
            $A.get("e.force:closeQuickAction").fire();
        }
    }
})