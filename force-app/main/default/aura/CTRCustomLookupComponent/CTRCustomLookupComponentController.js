({
    doInit: function (component, event, helper) {
        helper.getObjectRecord(component);
        
        if (component.get('v.lookupId')) {
            helper.getLookupInfo(component);
        }
    },

    search: function (component, event, helper) {
        var searchString = event.target.value.trim();

        if (searchString.length > 1) {
            helper.searching(component, searchString);
        } else {
            component.set("v.records", []);
        }
    },

    clearSearch: function (component, event, helper) {
        component.set("v.searchString", "");
        component.set("v.records", []);
    },

    selectRecord: function (component, event, helper) {
        var selectedRecordId = event.currentTarget.dataset.record;
        var records = component.get("v.records");

        var selectedRecord = records.find(function (record) {
            component.set('v.lookupId', record.Id);
            component.set('v.lookupName', record.Name);

            return record.Id === selectedRecordId;
        });

        component.set("v.selectedRecord", selectedRecord);
        component.set("v.searchString", selectedRecord.Name);
        component.set("v.showSearch", false);
        component.set("v.showSelected", true);
        component.set("v.records", []);
    },

    clearSelectedRecord: function (component, event, helper) {
        component.set("v.selectedRecord", null);
        component.set("v.searchString", "");
        component.set("v.showSelected", false);
        component.set("v.showSearch", true);
    },

    getObjectRecord: function(component, event, helper) {
        helper.getObjectRecord(component);
    }

})