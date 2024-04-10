({
    createObjectDataDestinationCountry: function (component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        var shippingList = component.get("v.shippingList");

        shippingList.push({
            "sobjectType": "CTRShippingCountry__c",
            "Id": "",
            "LocationType__c": "",
            "ShippingCountry__c": "",
            "IsDeleted": false
        });

        // set the updated list to attribute (contactList) again
        component.set("v.shippingList", shippingList);
    },
    getLocationType: function (component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        const action = component.get("c.getPicklistValue");

        action.setParams({
            "fieldAPI": 'LocationType__c',
            "sObjAPI": 'CTRShippingCountry__c'
        });

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                const listofvalue = response.getReturnValue();
                listofvalue.unshift('None');
                component.set("v.location", listofvalue);
            }
        }
        );
        $A.enqueueAction(action);
    },
    getShippingCountry: function (component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        const action = component.get("c.getPicklistValue");

        action.setParams({
            "fieldAPI": 'ShippingCountry__c',
            "sObjAPI": 'CTRShippingCountry__c'
        });

        action.setCallback(this, function (response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                const listofvalue = response.getReturnValue();
                listofvalue.unshift('None');
                component.set("v.country", listofvalue);
            }
        }
        );
        $A.enqueueAction(action);
    },
})