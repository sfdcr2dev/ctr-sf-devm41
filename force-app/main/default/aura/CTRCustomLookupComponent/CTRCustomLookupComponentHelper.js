({
    getObjectRecord: function (component) {
        var objectName = component.get("v.objectName");
        var conditionKey = component.get('v.conditionString');

        var action = component.get("c.searchRecords");
        action.setParams({
            objectName: objectName,
            fieldName: component.get('v.fieldQuery'),
            conditionString: conditionKey
            // searchString: searchString
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.allRecords", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getLookupInfo: function (component) {
        if (component.get('v.lookupId')) {
            component.set('v.showSearch', false);
            component.set('v.showSelected', true);
        }
        var action = component.get('c.getLookupValue');
        action.setParams({
            "objectName": component.get('v.objectName'),
            "lookupId": component.get('v.lookupId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var lookupValue = response.getReturnValue();
                console.log('lookupValue: ' + JSON.stringify(lookupValue));
                component.set('v.selectedRecord', lookupValue[0]);
                component.set('v.lookupName', lookupValue[0].Name);
                component.set('v.lookupId', lookupValue[0].Id);

                // helper.fireEventToParent(component);
            } else {
                console.log('get lookup value error: ' + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);

    },

    searching: function(component, searchString) {
        var searchTerm = searchString.toLowerCase();
        var allUsers = component.get("v.allRecords");

        var filteredUsers = allUsers.filter(function(user) {
            return user.Name.toLowerCase().includes(searchTerm);
        });

        component.set("v.records", filteredUsers.slice(0,5));
    }


})