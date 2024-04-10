({
    getWorkClearanceAvailableStatus: function (component) {

        let allStatusList = [
            { "name":"EXTD", "description":"During repair", },
            { "name":"EXTH", "description":"Extend from normal hours", },
            { "name":"WCCL", "description":"Work clearance closed", },
            { "name":"WIP1", "description":"Will be continued next day", },
            { "name":"WIP2", "description":"Wait for permit to work", },
            { "name":"WIP3", "description":"Wait for spare parts", },
        ];

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