({
    doInit : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        if (pageRef) {
            var notificationId = pageRef.state.c__notificationId;
            var itemId = pageRef.state.c__itemId;
            component.set("v.notificationId", notificationId);
            component.set("v.itemId", itemId);
        }
        helper.getItemData(component,event);
        helper.getObjectPartCodeGroup(component,event);
        helper.getDamageCodeGroup(component,event);
    },

    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Item Updated"
        });

        var buttonValue = component.get("v.buttonValue");
        if(buttonValue == "Save"){
            var action = component.get("c.sendToSAP");
            action.setParams({
                "itemId": component.get("v.itemId")
            });
            action.setCallback(this, function(response) {
                var pageRef = component.get("v.pageReference");
                let navLink = component.find("navLink");

                pageRef = {
                    type: "standard__component",
                    attributes: {
                        //"componentName": "c__THOR_NotificationRelatedListDisplayer"
                        componentName: 'c__THOR_NotificationRelatedItems'
                    },
                    state: {
                        //"c__recordId": component.get("v.notificationId")
                        c__notificationId: component.get("v.notificationId")
                    },
                }; 
                navLink.navigate(pageRef, true);
            });
            $A.enqueueAction(action);
        }else{
            let pageRef;
            let navLink = component.find("navLink");
       
            pageRef = {
                type: "standard__component",
                attributes: {
                    "componentName": "c__THOR_InsertItemCause"
                },
                state: {
                    "c__notificationId": component.get("v.notificationId"),
                    "c__itemId" : component.get("v.itemId")
                },
            }; 
            navLink.navigate(pageRef, true);
        }
    },
    
    handleRefresh: function(component, event, helper){
        $A.get("e.force:refreshView").fire();
    },

    navigateBack : function(component, event, helper){
        var pageRef = component.get("v.pageReference");
        let navLink = component.find("navLink");

        pageRef = {
            type: "standard__component",
            attributes: {
                //"componentName": "c__THOR_NotificationRelatedListDisplayer"
                componentName: 'c__THOR_NotificationRelatedItems'
            },
            state: {
                //"c__recordId": component.get("v.notificationId")
                c__notificationId: component.get("v.notificationId")
            },
        }; 
        navLink.navigate(pageRef, true);
    },

    openObjectPartCodeGroupModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.find("lightningInputObjectPartCodeGroup").blur();
        component.set("v.objectPartCodeGroupModal", true);
     },

     openObjectPartCodeModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.find("lightningInputObjectPartCode").blur();
        helper.getObjectPartCode(component,event);
        component.set("v.objectPartCodeModal", true);
     },

     openDamageCodeGroupModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.find("lightningInputDamageCodeGroup").blur();
        component.set("v.damageCodeGroupModal", true);
     },

     openDamageCodeModal: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.find("lightningInputDamageCode").blur();
        helper.getDamageCode(component,event);
        component.set("v.damageCodeModal", true);
     },

     closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.objectPartCodeGroupModal", false);
        component.set("v.objectPartCodeModal", false);
        component.set("v.damageCodeGroupModal", false);
        component.set("v.damageCodeModal", false);
     },

     selectObjectPartCodeGroup : function(component, event, helper){
        var buttonValue = event.getSource().get("v.value");
        var buttonExtra = event.getSource().get("v.name");
        component.set("v.objectPartValue",buttonValue);
        component.set("v.objectPartTextValue",buttonExtra);
        component.set("v.objectPartCodeGroupModal", false);
     },
     
     selectObjectPartCode : function(component, event, helper){
        var buttonValue = event.getSource().get("v.value");
        var buttonExtra = event.getSource().get("v.name");
        component.set("v.objectPartCodeValue",buttonValue);
        component.set("v.objectPartCodeTextValue", buttonExtra);
        component.set("v.objectPartCodeModal", false);
     },

     selectDamageCodeGroup : function(component, event, helper){
        var buttonValue = event.getSource().get("v.value");
        var buttonExtra = event.getSource().get("v.name");
        component.set("v.damageCodeGroupValue",buttonValue);
        component.set("v.objectPartTextValue",buttonExtra);
        component.set("v.damageCodeGroupModal", false);
     },

     selectDamageCode : function(component, event, helper){
        var buttonValue = event.getSource().get("v.value");
        var buttonExtra = event.getSource().get("v.name");
        component.set("v.damageCodeValue",buttonValue);
        component.set("v.damageCodeTextValue", buttonExtra);
        component.set("v.damageCodeModal", false);
     },

     clearObjectPartValue: function(component, event, helper){
        component.set("v.objectPartValue","");
        component.set("v.objectPartTextValue","");
        component.set("v.objectPartCodeValue","");
        component.set("v.objectPartCodeTextValue", "");
     },

     clearDamageValue: function(component, event, helper){
        component.set("v.damageCodeGroupValue","");
        component.set("v.damageCodeGroupTextValue","");
        component.set("v.damageCodeValue","");
        component.set("v.damageCodeTextValue", "");
     },

     clearObjectPartCodeValue: function(component, event, helper){
        component.set("v.objectPartCodeValue","");
        component.set("v.objectPartCodeTextValue", "");
     },

     clearDamageCodeValue: function(component, event, helper){
        component.set("v.damageCodeValue","");
        component.set("v.damageCodeTextValue", "");
     },

     handleObjectPartCodeGroupSearch: function (component, event, helper) {
            var queryTerm = component.find("enter-search-objectPartCodeGroup").get("v.value");
    
            if(queryTerm != ''){
                let action = component.get("c.searchCodeGroupsByNameAndDescription");
                action.setParams({
                    searchText: queryTerm,
                    codeGroups: component.get("v.objectPartOptions")
                });
        
                action.setCallback(this, function (response) {
                    let state = response.getState();
                    if (state === "SUCCESS") {
                        let returnValue = response.getReturnValue();
                        component.set("v.objectPartsFilteredAndSearched", returnValue);
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
            
            }else{
                component.set("v.objectPartsFilteredAndSearched", component.get("v.objectPartOptions") );
            }       
    },

    handleOnKeyUpObjectPartCodeGroup : function(component, event, helper){
        var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            let action = component.get("c.handleObjectPartCodeGroupSearch");
            $A.enqueueAction(action);
        }
    },

    handleObjectPartCodeSearch: function (component, event, helper) {

        var queryTerm = component.find("enter-search-objectPartCode").get("v.value");

        let action = component.get("c.searchCodeGroupsByNameAndDescriptionModified");
        action.setParams({
            searchText: queryTerm,
            codeGroups: component.get("v.objectPartCodeOptions")
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnValue = response.getReturnValue();
                component.set("v.objectPartCodesFilteredAndSearched", returnValue);
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
},

handleOnKeyUpObjectPartCode : function (component, event, helper) {
    var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            let action = component.get("c.handleObjectPartCodeSearch");
            $A.enqueueAction(action);
        }
},

handleDamageCodeGroupSearch: function (component, event, helper) {

    var queryTerm = component.find("enter-search-damageCodeGroup").get("v.value");

    let action = component.get("c.searchCodeGroupsByNameAndDescription");
    action.setParams({
        searchText: queryTerm,
        codeGroups: component.get("v.damageCodeGroupOptions")
    });

    action.setCallback(this, function (response) {
        let state = response.getState();
        if (state === "SUCCESS") {
            let returnValue = response.getReturnValue();
            component.set("v.damageCodeGroupsFilteredAndSearched", returnValue);
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

},

handleOnKeyUpDamageCodeGroup : function(component, event, helper){
    var isEnterKey = event.keyCode === 13;
    if (isEnterKey) {
        let action = component.get("c.handleDamageCodeGroupSearch");
        $A.enqueueAction(action);
    }
},

handleDamageCodeSearch: function (component, event, helper) {

    var queryTerm = component.find("enter-search-damagePartCode").get("v.value");

    let action = component.get("c.searchCodeGroupsByNameAndDescriptionModified");
    action.setParams({
        searchText: queryTerm,
        codeGroups: component.get("v.damageCodeOptions")
    });

    action.setCallback(this, function (response) {
        let state = response.getState();
        if (state === "SUCCESS") {
            let returnValue = response.getReturnValue();
            component.set("v.damageCodesFilteredAndSearched", returnValue);
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
},

handleOnKeyUpDamageCode : function (component, event, helper) {
    var isEnterKey = event.keyCode === 13;
        if (isEnterKey) {
            let action = component.get("c.handleDamageCodeSearch");
            $A.enqueueAction(action);
        }
},

handleNext :function (component, event, helper) {
    component.find('notifLib').showToast({
        "variant": "success",
        "title": "Item Updated"
    });

    let pageRef;
        let navLink = component.find("navLink");
       
        pageRef = {
            type: "standard__component",
            attributes: {
                "componentName": "c__THOR_InsertItemCause"
            },
            state: {
                "c__notificationId": component.get("v.notificationId"),
                "c__itemId" : component.get("v.itemId")
            },
        }; 
        navLink.navigate(pageRef, true);
},

    handleSubmit : function(component, event, helper){
        event.preventDefault();
        let value = event.getSource().get("v.value");
        //component.find("itemForm").submit();
        component.find('utilityLwcButton').submit_click();

        component.set("v.buttonValue", value);

        
//        if(value == "Save"){
//            var pageRef = component.get("v.pageReference");
//            let navLink = component.find("navLink");
//
//            pageRef = {
//                type: "standard__component",
//                attributes: {
//                    //"componentName": "c__THOR_NotificationRelatedListDisplayer"
//                    componentName: 'c__THOR_NotificationRelatedItems'
//                },
//                state: {
//                    //"c__recordId": component.get("v.notificationId")
//                    c__notificationId: component.get("v.notificationId")
//                },
//            }; 
//            navLink.navigate(pageRef, true);
//        }else{
//            let pageRef;
//            let navLink = component.find("navLink");
//       
//            pageRef = {
//                type: "standard__component",
//                attributes: {
//                    "componentName": "c__THOR_InsertItemCause"
//                },
//                state: {
//                    "c__notificationId": component.get("v.notificationId"),
//                    "c__itemId" : component.get("v.itemId")
//                },
//            }; 
//            navLink.navigate(pageRef, true);
//        }
    },

})