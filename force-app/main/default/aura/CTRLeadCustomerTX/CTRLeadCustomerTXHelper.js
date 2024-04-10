({
    helperMethod : function() {

    },
    changeStatus : function (component,value) {
        if(value == 'Unqualified'){
            component.set('v.showUnqualifiedReason',true);
        }else{
            component.set('v.showUnqualifiedReason',false);
            component.set('v.showOtherUnqualifiedReason',false);
        }        
    },
    closedTeb : function(component){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    changeUnqualifiedReason : function (component,value) {
        if(value == 'Other'){
            component.set('v.showOtherUnqualifiedReason',true);
        }else{
            component.set('v.showOtherUnqualifiedReason',false);
        }        
    },
    showToast: function (message, isSuccess) {
        const toastType = isSuccess ? "success" : "error";
        const toastParams = {
            type: toastType,
            message: message
        };

        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },
	sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.duplicateRecords");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.duplicateRecords", data);
    },
    sortBy: function(field, reverse, primer) {
        var key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },
})