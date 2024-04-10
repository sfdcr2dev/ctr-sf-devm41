({
    createObjectData: function (component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        var shareholderList = component.get("v.shareholderList");

        shareholderList.push({
            "sobjectType": "CTRShareHolder__c",
            "Name": "",
            "of_Shareholder__c": 0
        });

        // set the updated list to attribute (contactList) again
        component.set("v.shareholderList", shareholderList);
        console.log('shareholderList---' + component.get("v.shareholderList"));
    },

    createObjectDataDestination: function (component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        var shippingList = component.get("v.shippingList");

        shippingList.push({
            "sobjectType": "CTRShippingCountry__c",
            "LocationType__c": "",
            "ShippingCountry__c": ""
        });

        // set the updated list to attribute (contactList) again
        component.set("v.shippingList", shippingList);
        console.log('shippingList---' + component.get("v.shippingList"));
    },

    getLocationType: function (component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        var action = component.get("c.getPicklistValue");

        action.setParams({
            "fieldAPI": 'LocationType__c',
            "sObjAPI": 'CTRShippingCountry__c'
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var listofvalue = response.getReturnValue();
                listofvalue.unshift('None');
                component.set("v.location", listofvalue);
                console.log('location---' + component.get("v.location"));
            }
        }
        );
        $A.enqueueAction(action);
    },
    getShippingCountry: function (component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        var action = component.get("c.getPicklistValue");

        action.setParams({
            "fieldAPI": 'ShippingCountry__c',
            "sObjAPI": 'CTRShippingCountry__c'
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var listofvalue = response.getReturnValue();
                listofvalue.unshift('None');
                component.set("v.country", listofvalue);
                console.log('country---' + component.get("v.country"));
            }
        }
        );
        $A.enqueueAction(action);
    },
    getFacilityTransportation: function (component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        var action = component.get("c.getPicklistValue");

        action.setParams({
            "fieldAPI": 'CustomersFacilityTransportation__c',
            "sObjAPI": 'Account'
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var listofvalue = response.getReturnValue();
                //listofvalue.unshift('None');
                component.set("v.FacilityTransportation", listofvalue);
                console.log('FacilityTransportation---' + component.get("v.FacilityTransportation"));
            }
        }
        );
        $A.enqueueAction(action);
    },
    getFacilityTankAndStorage: function (component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        var action = component.get("c.getPicklistValue");

        action.setParams({
            "fieldAPI": 'CustomersFacilityTankAndStorage__c',
            "sObjAPI": 'Account'
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var listofvalue = response.getReturnValue();
                //listofvalue.unshift('None');
                component.set("v.FacilityTankAndStorage", listofvalue);
                console.log('FacilityTankAndStorage---' + component.get("v.FacilityTankAndStorage"));
            }
        }
        );
        $A.enqueueAction(action);
    },

    getMultipicklistValueFromList: function (component, List) {
        console.log('getMultipicklist');
        var mMultipicklistValue = '';
        var count = 0;
        for (var value of List) {
            if (count == 0) {
                mMultipicklistValue = value;
            }
            else {
                mMultipicklistValue += ';' + value;
            }
            count++;
        }
        return mMultipicklistValue;
    },

    ConvertedRadioYesNoToText: function (component, Yes, No) {
        var Result = '';
        if (Yes) {
            Result = 'Yes';
        }
        else if (No) {
            Result = 'No';
        }
        return Result;
    },
    addFieldChangeToJson: function (component, event) {
        console.log('recordType' + component.get('v.recordTypeName'));
        if (component.get('v.recordTypeName')) {
            if (component.get('v.recordTypeName').includes('Edit') || component.get('v.isTRCR')) {
                var source = 'Counter party';

                var label = event.getSource().get('v.id');
                var fieldName = event.getSource().get('v.fieldName');
                var value = event.getSource().get('v.value');
                var fieldChangedList = component.get('v.ChangedFieldForEDIT');
                console.log("fieldName:" + fieldName);
                console.log("value:" + value);
                if (fieldName) {
                    var isExisted = false;
                    for (var existing of fieldChangedList) {
                        if (existing.Api == fieldName) {
                            existing.Label = label;
                            existing.Value = value;
                            //existing.Display = value;
                            existing.User = component.get('v.currentUserName');
                            existing.Source = source;
                            isExisted = true;
                        }
                    }
                    if (isExisted == false) {
                        var mJson = '{"Label":"' + label + '",';
                        mJson += '"Api":"' + fieldName + '",';
                        mJson += '"Source":"' + source + '",';
                        mJson += '"User":"' + component.get('v.currentUserName') + '",';
                        //mJson += '"Display":"'+value+'",';
                        mJson += '"Value":"' + value + '"}';
                        var mObj = JSON.parse(mJson);
                        fieldChangedList.push(mObj);
                    }
                    console.log('field change: ' + JSON.stringify(fieldChangedList));
                    component.set('v.ChangedFieldForEDIT', fieldChangedList);

                }
            }
        }

    },
    getRequetItem: function (component, event) {
        try {
            var recordId = component.get("v.reqitemId");
            console.log('Line314');
            var action = component.get("c.getReqItemInfo");
            console.log('recordId Item-' + recordId);
            action.setParams({
                "itemId": recordId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state----' + state);
                if (state === "SUCCESS") {
                    var item = response.getReturnValue();
                    console.log('Item : ', item);
                    if (item.Customer__r.AccountNumber__c || item.Customer__r.SupplierNumber__c) {
                        component.set("v.isEdit", true);
                    }
                    console.log(component.get("v.isEdit"), item.Customer__r.AccountNumber__c || item.Customer__r.SupplierNumber__c);
                    if (item.RecordType.DeveloperName.includes('Edit')) {
                        component.set("v.isDisplay", true);
                        component.set("v.isEdit", false);
                    }
                    if ((item.RecordType.DeveloperName.includes('Initial')) && (!item.Customer__r.AccountNumber__c || !item.Customer__r.SupplierNumber__c)) {
                        component.set("v.isDisplay", true);
                    }
                    console.log('RecordTypeItem : ' + item.RecordType.DeveloperName);
                    console.log('AccountNumberItem : ' + item.Customer__r.AccountNumber__c);
                    console.log('AccountNumberItem : ' + item.Customer__r.SupplierNumber__c);
                    console.log('isDisplay : ' + component.get("v.isDisplay"));
                    console.log('isEdit : ' + component.get("v.isEdit"));
                }
            });
            console.log('Line330');
            $A.enqueueAction(action);
        }
        catch (ex) {
            console.log('ex----' + ex.message);
        }
    }

})