({
    getShippingCountry : function(component) {
        var action = component.get("c.getPicklistValue");
        action.setParams({
            "fieldAPI": 'ShippingCountry__c',
            "sObjAPI": 'CTRShippingCountry__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                result.unshift('None');
                component.set("v.country", result);
            }
        });
        $A.enqueueAction(action);
    },

    createObjectDataShipto : function(component) {
        var shiptoList = component.get("v.shiptoList");
        shiptoList.push({
            "sobjectType": "CTRShippingCountry__c",
            "ShippingCountry__c": "",
            "CTRRequestFormItem__c": component.get("v.recordId")
        });
        component.set("v.shiptoList", shiptoList);
    },

    createObjectDataShareholder : function(component) {
        var shareholderList = component.get("v.shareholderList");
        shareholderList.push({
            "sobjectType": "CTRShareHolder__c",
            "Name": "",
            "of_Shareholder__c": 0,
            "CTRRequestFormItem__c": component.get("v.recordId")
        });
        component.set("v.shareholderList", shareholderList);
    },

    validateRelatedShiptoAndShareholder : function(component) {
        if((!$A.util.isEmpty(component.get("v.shiptoList")) || !$A.util.isEmpty(component.get("v.shareholderList")))) {
            var shiptoList = (!$A.util.isEmpty(component.get("v.shiptoList")) ? JSON.stringify(component.get("v.shiptoList")) : null);
            var shareholderList = (!$A.util.isEmpty(component.get("v.shareholderList")) ? JSON.stringify(component.get("v.shareholderList")) : null);
            var action = component.get("c.createRelatedShiptoAndShareholder");
            action.setParams({
                "shiptoJSON": shiptoList,
                "shareholderJSON": shareholderList
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    // var result = response.getReturnValue();
                    this.showToast('Success', 'success', 'Compliance Check has been submitted successfully.');
                    this.closeModal(component);

                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message) {
                            console.log('[createRelatedShiptoAndShareholder] error -----', errors[0].message);
                            this.showToast('Error', 'error', errors[0].message);
                        }
                    } else {
                        console.log('[createRelatedShiptoAndShareholder] unknown error -----');
                        this.showToast('Error', 'error', 'Unknown error');
                    }
                }
            });
            $A.enqueueAction(action);
        } else {
            this.showToast('Success', 'success', 'Compliance Check has been submitted successfully.');
            this.closeModal(component);
        }
    },

    showToast : function(title, type, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"type": type,
			"message": message
		});
		toastEvent.fire();
	},

    closeModal : function(component) {
        component.set("v.isLoaded", true);
        $A.get("e.force:closeQuickAction").fire();
    },
})