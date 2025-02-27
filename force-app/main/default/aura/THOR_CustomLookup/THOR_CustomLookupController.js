({
    // To prepopulate the seleted value pill if value attribute is filled
    doInit: function (component, event, helper) {
        $A.util.toggleClass(component.find("resultsDiv"), "slds-is-open");
        if (!$A.util.isEmpty(component.get("v.value"))) {
            helper.searchRecordsHelper(component, event, helper, component.get("v.value"));
        }
    },

    // When a keyword is entered in search box
    searchRecords: function (component, event, helper) {
        if (!$A.util.isEmpty(component.get("v.searchString"))) {
            let timer = component.get("v.timer");
            clearTimeout(timer);
            component.set("v.timer", null);
            timer = setTimeout(
                $A.getCallback(helper.searchRecordsHelper.bind(helper, component, event, helper, "")),
                700
            );
            component.set("v.timer", timer);
        } else {
            $A.util.removeClass(component.find("resultsDiv"), "slds-is-open");
        }
    },

    // When an item is selected
    selectItem: function (component, event, helper) {
        if (!$A.util.isEmpty(event.currentTarget.id)) {
            var recordsList = component.get("v.recordsList");
            var index = recordsList.findIndex((x) => x.value === event.currentTarget.id);
            if (index != -1) {
                var selectedRecord = recordsList[index];
            }
            component.set("v.selectedRecord", selectedRecord);
            component.set("v.value", selectedRecord.value);

            helper.fireSelectedEvent(component);

            $A.util.removeClass(component.find("resultsDiv"), "slds-is-open");
        }
    },

    showRecords: function (component, event, helper) {
        if (!$A.util.isEmpty(component.get("v.recordsList")) && !$A.util.isEmpty(component.get("v.searchString"))) {
            $A.util.addClass(component.find("resultsDiv"), "slds-is-open");
        }
    },

    // To remove the selected item.
    removeItem: function (component, event, helper) {
        component.set("v.selectedRecord", "");
        component.set("v.value", "");
        component.set("v.searchString", "");
        setTimeout(function () {
            component.find("inputLookup").focus();
        }, 250);
        helper.fireSelectedEvent(component);
    },

    // To close the dropdown if clicked outside the dropdown.
    blurEvent: function (component, event, helper) {
        $A.util.removeClass(component.find("resultsDiv"), "slds-is-open");
    }
});