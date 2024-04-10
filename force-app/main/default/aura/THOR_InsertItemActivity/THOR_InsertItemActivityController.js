({
    doInit: function (component, event, helper) {
        helper.prepareComponent(component, event, helper);
        helper.checkWriteAccess(component);
    },

    navigateBack: function (component, event, helper) {
        var pageRef = component.get("v.pageReference");
        let navLink = component.find("navLink");

        pageRef = {
            type: "standard__component",
            attributes: {
                componentName: "c__THOR_InsertItemCause"
            },
            state: {
                c__notificationId: component.get("v.notificationId"),
                c__itemId: component.get("v.itemId")
            }
        };
        navLink.navigate(pageRef, true);
    },

    showCodeGroupModal: function (component, event, helper) {
        component.set("v.isCodeGroupsModalOpen", true);
    },

    closeModalCodeGroups: function (component, event, helper) {
        component.set("v.isCodeGroupsModalOpen", false);
        component.set("v.codeGroupsFilteredAndSearched", component.get("v.codeGroupsFiltered"));
    },

    showActivityModal: function (component, event, helper) {
        component.set("v.isActivityModalOpen", true);
        component.set("v.isCodeGroupsModalOpen", false);
        var codeGroupId = event.getSource().get("v.value");
        component.set("v.codeGroupId", codeGroupId);
        console.log(codeGroupId);
        helper.retrieveActivitiesFiltered(component, event);
    },

    closeModalActivity: function (component, event, helper) {
        component.set("v.isActivityModalOpen", false);
        component.set("v.activitiesFilteredAndSearched", component.get("v.activitiesFiltered"));
    },
    showTextModal: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set("v.activityId", payload.id);
        component.set("v.isTextModalOpen", true);
        component.set("v.isActivityModalOpen", false);
    },

    closeModalText: function (component, event, helper) {
        component.set("v.isTextModalOpen", false);
    },

    handleSuccess: function (component, event, helper) {
        component.find("notifLib").showToast({
            variant: "success",
            title: "Activity Created"
        });
        component.set("v.isTextModalOpen", false);
        component.set("v.isactivityModalOpen", false);
        $A.get("e.force:refreshView").fire();
    },

    handleDescriptionSuccess: function (component, event, helper) {
        component.find("notifLib").showToast({
            variant: "success",
            title: "Activity Description Added"
        });
        component.set("v.isTextModalOpen", false);
        component.set("v.isDescriptionModalOpen", false);
        $A.get("e.force:refreshView").fire();
    },

    handleDeleteActivity: function (component, event, helper) {
        let action = component.get("c.deleteActivity");
        action.setParams({
            ActivityId: event.getSource().get("v.name")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
    },

    handleCodeSearch: function (component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        let queryTerm;
        try {
            if (isEnterKey || (event && event.getSource().get("v.value") == 'codeSearchButton')) {
                queryTerm = component.find("enter-search").get("v.value");
            }
        } catch(e) {
            // not fired from the button event.getSource() fails
        }
        if (queryTerm) {
            let action = component.get("c.searchCodeGroups");
            action.setParams({
                searchText: queryTerm,
                codeGroups: component.get("v.codeGroupsFiltered")
            });
            
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let returnValue = response.getReturnValue();
                    component.set("v.codeGroupsFilteredAndSearched", returnValue);
                } else if (state === "INCOMPLETE") {
                    // do something
                } else if (state === "ERROR") {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            
            $A.enqueueAction(action);
        }
    },

    handleActivitySearch: function (component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        let queryTerm;
        try {
            if (isEnterKey || event.getSource().get("v.value") == 'activitySearchButton') {
                queryTerm = component.find("enter-search-activities").get("v.value");
            }
        } catch(e) {
            // not fired from the button event.getSource() fails
        }

        if (queryTerm) {
            let action = component.get("c.searchActivities");
            action.setParams({
                searchText: queryTerm,
                filteredActivities: component.get("v.activitiesFiltered")
            });
            
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let returnValue = response.getReturnValue();
                    component.set("v.activitiesFilteredAndSearched", returnValue);
                } else if (state === "INCOMPLETE") {
                    // do something
                } else if (state === "ERROR") {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            
            $A.enqueueAction(action);
        }
    },

    openDescriptionModal: function (component, event, helper) {
        component.set("v.activityId", event.getSource().get("v.name"));
        component.set("v.isDescriptionModalOpen", true);
        helper.getActivityData(component, event);
    },

    closeDescriptionModal: function (component, event, helper) {
        component.set("v.isDescriptionModalOpen", false);
    },

    navigateToItemList: function (component, event, helper) {
        var action = component.get("c.sendToSAP");
        action.setParams({
            "itemId": component.get("v.itemId")
        });
        action.setCallback(this, function(response) {
            let pageRef;
            let navLink = component.find("navLink");
            let notificationId = component.get("v.notificationId");
            pageRef = {
                type: "standard__component",
                attributes: {
                    //componentName: "c__THOR_NotificationRelatedListDisplayer"
                    componentName: 'c__THOR_NotificationRelatedItems'
                },
                state: {
                    //c__recordId: notificationId
                    c__notificationId: notificationId
                }
            };
            navLink.navigate(pageRef, true);
        });
        $A.enqueueAction(action);
    }
});