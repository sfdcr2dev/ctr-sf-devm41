({
    doInit : function(component, event, helper) {
        helper.getLocationType(component, event);
        helper.getShippingCountry(component, event);
    },
    addNewRowDestinationCountry : function(component, event, helper) {
        // call the command "createObjectData" helper method for add new Object Row to List
        helper.createObjectDataDestinationCountry(component, event);
    },
    removeDeletedRowDestinationCountry : function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute
        const index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method
        const shippingList = component.get("v.shippingList");
        if (shippingList[index].Id) {
            shippingList[index].IsDeleted = true;
        } else {
            shippingList.splice(index, 1);
        }

        component.set("v.shippingList", shippingList);
    },
})