({
    showToast: function (type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    },

    splitNewAndInProgress: function (allNotifications) {
        var newList = [];
        var inProgressList = [];
        var closedList = [];
        for (var i = 0; i < allNotifications.length; i++) {
            if (allNotifications[i].status === "New") {
                newList.push(allNotifications[i]);
            } 
            if (allNotifications[i].status === "In Progress") {
                inProgressList.push(allNotifications[i]);
            } 
            if(allNotifications[i].status === "Closed"){
                closedList.push(allNotifications[i]);
            }
             
        }
        console.log(inProgressList);
        return [newList, inProgressList, closedList];
    },

    init: function (component, event, helper) {
        let pageReference = component.get("v.pageReference");
        let fromRecordId = pageReference.state.c__fromRecordId;
        let functionalLocation = pageReference.state.c__recordId;

        component.set("v.fromRecordId", fromRecordId);

        let action = component.get("c.getObjectTypeFromId");
        action.setParams({
            recordId: fromRecordId
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let recordType = response.getReturnValue();
                if (recordType === "Order__c") {
                    component.set("v.goToComponent", "c__THOR_OrderRecordDisplay");
                }

                let filterSelected = component.get("v.filterSelected");
                let userFilterActive = component.get("v.userFilterActive");

                let fromDateFilter = component.get("v.fromDateFilter");
                let toDateFilter = component.get("v.toDateFilter");

                let flNotificationsAction = component.get("c.retrieveFLNotifications");
                flNotificationsAction.setParams({
                    functionalLocationId: functionalLocation,
                    //mainWorkCenterFilter: filterSelected,
                    userFilterActive: userFilterActive,
                    fromDateFilter: fromDateFilter,
                    toDateFilter: toDateFilter
                });
                flNotificationsAction.setCallback(this, function (response) {
                    let state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.RelatedId", functionalLocation);
                        let returnedlist = response.getReturnValue();
                        let splitList = helper.splitNewAndInProgress(returnedlist);

                        component.set("v.goToComponent", "c__THOR_NotificationRecordDisplay");
                        if (returnedlist.length > 0) {
                            component.set("v.FLTitle", returnedlist[0].name);
                        }

                        component.set("v.totalFL", returnedlist.length);

                        component.set("v.listNew", splitList[0]);
                        component.set("v.listInProgress", splitList[1]);
                        component.set("v.listClosed", splitList[2]);
                    } else if (state === "ERROR") {
                        let errors = response.getError();
                        if (errors) {
                            helper.showToast("Error", "Error", errors[0].message);
                        }
                    }
                });
                $A.enqueueAction(flNotificationsAction);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    showToast("Error", "Error", errors[0].message);
                }
            }
        });

        $A.enqueueAction(action);
    }
});