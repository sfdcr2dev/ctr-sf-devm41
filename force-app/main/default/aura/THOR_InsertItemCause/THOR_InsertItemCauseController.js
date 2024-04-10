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
                componentName: "c__THOR_EditItemObjectPart"
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

    showCauseModal: function (component, event, helper) {
        component.set("v.isCauseModalOpen", true);
        component.set("v.isCodeGroupsModalOpen", false);
        component.set("v.istextModalOpen", false);
        var codeGroupId = event.getSource().get("v.value");
        component.set("v.codeGroupId", codeGroupId);
        helper.retrieveCausesFiltered(component, event);
    },

    closeModalCause: function (component, event, helper) {
        component.set("v.isCauseModalOpen", false);
        component.set("v.causesFilteredAndSearched", component.get("v.causesFiltered"));
    },

    showTextModal: function (component, event, helper) {
        var payload = event.getParams().response;
        component.set("v.causeId", payload.id);
        component.set("v.isTextModalOpen", true);
        component.set("v.isCauseModalOpen", false);
    },

    closeModalText: function (component, event, helper) {
        component.set("v.isTextModalOpen", false);
        $A.get("e.force:refreshView").fire();
    },

    handleDescriptionSuccess: function (component, event, helper) {
        component.find("notifLib").showToast({
            variant: "success",
            title: "Cause Created"
        });
        component.set("v.isDescriptionModalOpen", false);
        component.set("v.isTextModalOpen", false);
        $A.get("e.force:refreshView").fire();
    },

    handleSuccess: function (component, event, helper) {
        component.find("notifLib").showToast({
            variant: "success",
            title: "Cause Created"
        });
        component.set("v.isCauseModalOpen", false);
        component.set("v.isTextModalOpen", false);
        $A.get("e.force:refreshView").fire();
    },

    handleDeleteCause: function (component, event, helper) {
        let action = component.get("c.deleteCause");
        action.setParams({
            CauseId: event.getSource().get("v.name")
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
        } catch (e) {
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

    handleCauseSearch: function (component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        let queryTerm;
        try {
            if (isEnterKey || (event && event.getSource().get("v.value") == 'causeSearchButton')) {
                queryTerm = component.find("enter-search-causes").get("v.value");
            }
        } catch(e) {
            // not fired from the button event.getSource() fails
        }

        if (queryTerm) { 
            let action = component.get("c.searchCauses");
            action.setParams({
                searchText: queryTerm,
                filteredCauses: component.get("v.causesFiltered")
            });
            
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let returnValue = response.getReturnValue();
                    component.set("v.causesFilteredAndSearched", returnValue);
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
        component.set("v.causeId", event.getSource().get("v.name"));
        component.set("v.isDescriptionModalOpen", true);
        helper.getCauseData(component, event);
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
    },

    navigateToInsertItemActivity: function (component, event, helper) {
        let pageRef; 
        let navLink = component.find("navLink");
        let notificationId = component.get("v.notificationId");
        let itemId = component.get("v.itemId");
        pageRef = {
            type: "standard__component",
            attributes: {
                componentName: "c__THOR_InsertItemActivity"
            },
            state: {
                c__notificationId: notificationId,
                c__itemId: itemId
            }
        };
        navLink.navigate(pageRef, true);
    }
});