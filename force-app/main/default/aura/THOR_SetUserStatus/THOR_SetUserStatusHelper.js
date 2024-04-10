({
    getNotificationAvailableStatus: function (component) {
        var action = component.get("c.retrieveUserStatusForNotification");
        action.setParams({
            notificationType: component.get("v.type"),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                let allStatusList = response.getReturnValue();

                var userStatusTemp = component.get("v.userStatusTemp");

                let selectedStatusListString = [];
                if (userStatusTemp) {
                    selectedStatusListString = userStatusTemp.split(" ");
                    selectedStatusListString = selectedStatusListString.filter(element => element != "");
                }

                let availableStatusList = [];
                let selectedStatusList = [];

                allStatusList.forEach((statusElement) => {
                    if (selectedStatusListString.includes(statusElement.name)) {
                        selectedStatusList.push(statusElement);
                    } else {
                        availableStatusList.push(statusElement);
                    }
                });

                component.set("v.availableStatusList", availableStatusList);
                component.set("v.selectedStatusList", selectedStatusList);
                component.set("v.allStatusList", allStatusList);

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },

    getOrderAvailableStatus: function (component) {
        var action = component.get("c.retrieveUserStatusForOrder");

        action.setParams({
            orderType: component.get("v.type")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                let allStatusList = response.getReturnValue();

                var userStatusTemp = component.get("v.userStatusTemp");

                let selectedStatusListString = [];
                if (userStatusTemp) {
                    selectedStatusListString = userStatusTemp.split(" ");
                    selectedStatusListString = selectedStatusListString.filter(element => element != "");
                }

                let availableStatusList = [];
                let selectedStatusList = [];

                allStatusList.forEach((statusElement) => {
                    if (selectedStatusListString.includes(statusElement.name)) {
                        selectedStatusList.push(statusElement);
                    } else {
                        availableStatusList.push(statusElement);
                    }
                });

                component.set("v.availableStatusList", availableStatusList);
                component.set("v.selectedStatusList", selectedStatusList);
                component.set("v.allStatusList", allStatusList);

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },

    clearAddList: function (component) {
        let itemsToAddList = component.get("v.itemsToAddList");
        itemsToAddList.forEach(element => {
            let htmlElement = document.getElementById(element);
            htmlElement.classList.remove("selected");
        });

        itemsToAddList = [];
        component.set("v.itemsToAddList", itemsToAddList);
    },

    clearRemoveList: function (component) {
        let itemsToRemoveList = component.get("v.itemsToRemoveList");
        if(itemsToRemoveList){
            itemsToRemoveList.forEach(element => {
                let htmlElement = document.getElementById(element);
                htmlElement.classList.remove("selected");
            });
        }
        itemsToRemoveList = [];
        component.set("v.itemsToRemoveList", itemsToRemoveList);
    }
})