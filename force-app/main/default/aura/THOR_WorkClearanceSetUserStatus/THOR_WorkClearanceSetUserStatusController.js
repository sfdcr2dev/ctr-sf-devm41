({
    doInit: function (component, event, helper) {
        let target = component.get("v.target");
        helper.getWorkClearanceAvailableStatus(component);
    },

    add: function (component, event, helper) {
        let allStatusList = component.get("v.allStatusList");
        let availableStatusList = component.get("v.availableStatusList");
        let selectedStatusList = component.get("v.selectedStatusList");
        let selectedStatusListString = [];

        let itemsToAddList = component.get("v.itemsToAddList");
        if (itemsToAddList.length > 0) {

            selectedStatusListString = itemsToAddList;

            allStatusList.forEach((statusElement) => {
                if (selectedStatusListString.includes(statusElement.name)) {
                    selectedStatusList.push(statusElement);
                }
            });

            availableStatusList = availableStatusList.filter(element => !itemsToAddList.includes(element.name));
            component.set("v.availableStatusList", availableStatusList);
            component.set("v.selectedStatusList", selectedStatusList);
            itemsToAddList = [];
            component.set("v.itemsToAddList", itemsToAddList);
        }
    },

    remove: function (component, event, helper) {
        let allStatusList = component.get("v.allStatusList");
        let availableStatusList = component.get("v.availableStatusList");
        let selectedStatusList = component.get("v.selectedStatusList");
        let availableStatusListString = [];

        let itemsToRemoveList = component.get("v.itemsToRemoveList");
        if (itemsToRemoveList.length > 0) {

            availableStatusListString = itemsToRemoveList;

            allStatusList.forEach((statusElement) => {
                if (availableStatusListString.includes(statusElement.name)) {
                    availableStatusList.push(statusElement);
                }
            });

            selectedStatusList = selectedStatusList.filter(element => !itemsToRemoveList.includes(element.name));
            component.set("v.availableStatusList", availableStatusList);
            component.set("v.selectedStatusList", selectedStatusList);
            itemsToRemoveList = [];
            component.set("v.itemsToRemoveList", itemsToRemoveList);
        }
    },

    selectItemToAdd: function (component, event, helper) {
        helper.clearRemoveList(component);

        let itemToAdd = event.target.id;

        let htmlElement = document.getElementById(itemToAdd);

        let itemsToAddList = component.get("v.itemsToAddList");
        if (itemsToAddList.includes(itemToAdd)) {
            itemsToAddList = itemsToAddList.filter(element => element != itemToAdd);
            htmlElement.classList.remove("selected");
        } else {
            itemsToAddList.push(itemToAdd);
            htmlElement.classList.add("selected");
        }
        component.set("v.itemsToAddList", itemsToAddList);
    },

    selectItemToRemove: function (component, event, helper) {
        helper.clearAddList(component);

        let itemToRemove = event.target.id;

        let htmlElement = document.getElementById(itemToRemove);

        let itemsToRemoveList = component.get("v.itemsToRemoveList");
        if (itemsToRemoveList.includes(itemToRemove)) {
            itemsToRemoveList = itemsToRemoveList.filter(element => element != itemToRemove);
            htmlElement.classList.remove("selected");
        } else {
            itemsToRemoveList.push(itemToRemove);
            htmlElement.classList.add("selected");
        }

        component.set("v.itemsToRemoveList", itemsToRemoveList);
    },

    closeModal: function (component, reload) {
        var closeModalEvent = component.getEvent("closeModalEvent");
        closeModalEvent.setParams({
            "target": "closeModal"
        });
        closeModalEvent.fire();
    },

    setUserStatus: function (component, reload) {
        var closeModalEvent = component.getEvent("closeModalEvent");
        var selectedStatusList = component.get("v.selectedStatusList");
        var selectedStatusListString = [];
        
        let target = component.get("v.target");
        if (target == "order"){
            var userStatusTemp = component.get("v.userStatusTemp");
            if (userStatusTemp.includes('INIL')){
                selectedStatusListString.push('INIL');
            }
            else if (userStatusTemp.includes('INIT')){
                selectedStatusListString.push('INIT');
            }
        }
        var userStatusTemp = "";
        selectedStatusList.forEach(element => {
            selectedStatusListString.push(element.name);
            userStatusTemp += element.name + " ";
        });

        if (!userStatusTemp){
            component.set("v.userStatusTemp", " ");
        }

        closeModalEvent.setParams({
            "key": selectedStatusListString,
            "target": "setUserStatus"
        });
        closeModalEvent.fire();
    },
})