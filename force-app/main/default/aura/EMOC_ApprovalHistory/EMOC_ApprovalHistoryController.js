({
	doInit : function(cmp, event, helper) {
        helper.setColumns(cmp);
	},
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    onTabFocused : function(component, event, helper) {
        var focusedTabId = event.getParam('currentTabId');
        var previousTabId = event.getParam('previousTabId');
        var workspaceAPI = component.find("workspace");    
        var recordId = component.get("v.recordId");
        workspaceAPI.getTabInfo({
            tabId : focusedTabId
        }).then(function(response) {
            if (response.recordId == recordId){
                helper.setColumns(component, event, helper); 
                $A.get('e.force:refreshView').fire();
            }

        });
    }
})