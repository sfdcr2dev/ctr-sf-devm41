({
    doInit: function (component, event, helper) {
        var orderId = component.get('v.orderId');
        var notificationId = component.get('v.notificationId');

        if (orderId && orderId.length > 0) {
            component.set('v.isOrderRelated', true);
        }
        if (notificationId && notificationId.length > 0) {
            component.set('v.isNotificationRelated', true);
        }
    },

    handleSubmit: function (component, event, helper) {
        event.preventDefault(); // Prevent default submit
        var fields = event.getParam("fields");
        component.find('headerCreateForm').submit(fields);
    },

    handleSuccess: function (component, event, helper) {
        // Show toast
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "EQCC has been created successfully."
        });
        toastEvent.fire();
        helper.close(component, event, helper);
    },

    handleError: function (component, event, helper) {
        // Show toast
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": "There was an issue adding the EQCC Checked Sheet."
        });
        toastEvent.fire();
        helper.close(component, event, helper);
    },

    handleClose: function (component, event, helper) {
        helper.close(component, event, helper);
    },

    handleSelectedEvent: function (component, event, helper) {

        var target = event.getParam("target");
        if (target == 'Operation__c') {
            var key = event.getParam("key");
            component.set('v.operationId', key);
        }
    },

    handleRecordUpdated: function (component, event, helper) {

        var orderId = component.get("v.orderId");
        var notificationId = component.get("v.notificationId");


        var type = "";
        var equipmentId = "";
        var functionalLocationName = "";

        if (orderId) {
            //order Id received as attribute
            functionalLocationName = component.get("v.orderRecord.Functional_Location__r.Name");
            equipmentId = component.get("v.orderRecord.Equipment__c");
            type = component.get("v.orderRecord.Order_Type__c");

        } else {
            //notification Id received as attribute
            functionalLocationName = ""; //FL is related to the selected order by a formula field
            equipmentId = component.get("v.notificationRecord.Equipment__c");
            type = component.get("v.notificationRecord.Type__c");
        }

        if (type == "PM" || type == "PM01") {
            component.set("v.type", "PM");
        }
        if (equipmentId) {
            component.set("v.equipmentId", equipmentId);
        }
        if (functionalLocationName) {
            component.set("v.functionalLocationName", functionalLocationName);
        }

    },

    orderSelected: function (component, event, helper) {
        //Update Functional Location
        var orderIdForFL = event.getParam("value")[0];
        component.set("v.orderIdForFL", orderIdForFL);
    }
})