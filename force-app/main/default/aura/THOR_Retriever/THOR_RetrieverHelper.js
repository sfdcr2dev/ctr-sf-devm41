({
    handleViewAll: function (component) {
        //List 1
        var viewMoreLess1 = "Show less";

        if (!component.get("v.viewAll1")) {
            viewMoreLess1 = component.get("v.viewAllTitle1");
        }
        else {
            var DisplayableObjectFullList1 = component.get("v.DisplayableObjectFullList1");
            var DisplayableObjectFullList1Count = component.get("v.DisplayableObjectFullList1Count");
    
            if (DisplayableObjectFullList1Count > DisplayableObjectFullList1.length){
                this.getContent(component, 1);
            }
        }

        component.set("v.viewMoreLess1", viewMoreLess1);

        //List 2
        var viewMoreLess2 = "Show less";

        if (!component.get("v.viewAll2")) {
            viewMoreLess2 = component.get("v.viewAllTitle2");
        }
        else {
            var DisplayableObjectFullList2 = component.get("v.DisplayableObjectFullList2");
            var DisplayableObjectFullList2Count = component.get("v.DisplayableObjectFullList2Count");

            if (DisplayableObjectFullList2Count > DisplayableObjectFullList2.length){
                this.getContent(component, 2);
            }
        }

        component.set("v.viewMoreLess2", viewMoreLess2);

        //List 3
        var viewMoreLess3 = "Show less";

        if (!component.get("v.viewAll3")) {
            viewMoreLess3 = component.get("v.viewAllTitle3");
        }
        component.set("v.viewMoreLess3", viewMoreLess3);
    },

    getContent: function (component, listNumber) {
        var newStatus = "New";
        var inExecutionStatus = "In Progress";
        var relateId = component.get("v.RelatedId");

        if(!listNumber || listNumber == 1){
            //----- LIST TYPE 1
            var listType1 = component.get("v.ListType1");
            if (listType1 == "New Notifications" || listType1 == "Execution Notifications") {
                component.set("v.title1", listType1);
                component.set("v.NavigateToComponentForListType1", "c__THOR_NotificationRecordDisplay");
                let viewAll1 = component.get("v.viewAll1");
                if (listType1 == "New Notifications") this.getNotifications(component, 1, newStatus, relateId, viewAll1);
                else this.getExecutionNotifiactions(component, 1, inExecutionStatus, relateId, viewAll1);

                this.getFilterOptions(component);
            }

            if (listType1 == "FL New Notifications") {
                component.set("v.title1", listType1);
                component.set("v.title2", component.get("v.ListType2"));
                component.set("v.NavigateToComponentForListType1", "c__THOR_NotificationRecordDisplay");
                component.set("v.NavigateToComponentForListType2", "c__THOR_NotificationRecordDisplay");
                component.set("v.NavigateToComponentForListType3", "c__THOR_NotificationRecordDisplay");

                this.getFilterOptions(component);
            }

            if (listType1 == "Related Operations") {
                component.set("v.title1", listType1);
                component.set("v.title2", component.get("v.ListType2"));
                component.set("v.NavigateToComponentForListType1", "c__THOR_OperationRecordDisplay");

                this.getOperations(component, 1, relateId);
            }

            if (listType1 == "FL New Orders") {
                component.set("v.title1", listType1);
                component.set("v.title2", component.get("v.ListType2"));
                component.set("v.NavigateToComponentForListType1", "c__THOR_OrderRecordDisplay");
            }

            if (listType1 == "New Orders" || listType1 == "Execution Orders") {
                component.set("v.title1", listType1);
                component.set("v.NavigateToComponentForListType1", "c__THOR_OrderRecordDisplay");

                if (listType1 == "New Orders") this.getOrders(component, 1, newStatus);
                else this.getExecutionOrders(component, 1, InExecutionStatus);

                this.getFilterOptions(component);
            }

            if (listType1 == 'New Sub Orders' || listType1 == 'Execution Sub Orders') {
                component.set("v.title1", listType1);
                component.set("v.NavigateToComponentForListType1", "c__THOR_OrderRecordDisplay");

                if (listType1 == 'New Sub Orders') {
                    this.getOrders(component, 1, newStatus, relateId);
                } else {
                    this.getOrders(component, 1, inExecutionStatus, relateId);
                }

                this.getFilterOptions(component);
            }
        }

        if(!listNumber || listNumber == 2) {
            //----- LIST TYPE 2
            var listType2 = component.get("v.ListType2");
            if (listType2 == "New Notifications" || listType2 == "Execution Notifications") {
                component.set("v.title2", listType2);
                component.set("v.NavigateToComponentForListType2", "c__THOR_NotificationRecordDisplay");
                let viewAll2 = component.get("v.viewAll2");
                if (listType2 == "New Notifications") this.getNotifications(component, 2, newStatus, relateId, viewAll2);
                else this.getNotifications(component, 2, inExecutionStatus, relateId, viewAll2);
            }

            if (listType2 == "FL Notifications") {
                component.set("v.title1", component.get("v.ListType1"));
                component.set("v.title2", listType2);
                component.set("v.NavigateToComponentForListType2", "c__THOR_NotificationRecordDisplay");

                this.getFilterOptions(component);
            }


            if (listType2 == "FL Orders") {
                component.set("v.title1", component.get("v.ListType1"));
                component.set("v.title2", listType2);
                component.set("v.NavigateToComponentForListType2", "c__THOR_OrderRecordDisplay");
            }

            if (listType2 == "New Orders" || listType2 == "Execution Orders") {
                component.set("v.title2", listType2);
                component.set("v.NavigateToComponentForListType2", "c__THOR_OrderRecordDisplay");

                if (listType2 == "New Orders") this.getOrders(component, 2, newStatus);
                else this.getExecutionOrders(component, 2, inExecutionStatus);
            }

            if (listType2 == 'New Sub Orders' || listType2 == 'Execution Sub Orders') {
                component.set("v.title2", listType2);
                component.set("v.NavigateToComponentForListType2", "c__THOR_OrderRecordDisplay");

                if (listType2 == 'New Sub Orders') {
                    this.getOrders(component, 2, newStatus, relateId);
                } else {
                    this.getOrders(component, 2, inExecutionStatus, relateId);
                }
            }

            if (listType1 && listType2){
                if (listType1.includes("Notification") && listType2.includes("Notification")) {
                    component.set("v.totalCards", "Notification List ");
                }
                if (listType1.includes("Order") && listType2.includes("Order")) {
                    component.set("v.totalCards", "Order List ");
                }
            }
        }

        //----- LIST TYPE 3
        var listType3 = component.get("v.ListType3");
        if (listType3 == "FL Closed Notifications") {
            component.set("v.title3", listType3);
        }

        //----- Page Name
        if (listType1 == "New Notifications" && listType2 == "New Orders") {
            component.set("v.pageName", 'home');
        } else if (listType1 == "Related Operations"){
            component.set("v.pageName", 'operations');
        }
    },

    getNotifications: function (component, listNumber, status, relate, viewAll) {
        let limit = 0;
        if (!viewAll){
            limit = component.get("v.maxSize");
        }

        let filterSelected = component.get("v.filterSelected");
        let userFilterActive = component.get("v.userFilterActive");

        let fromDateFilter = component.get("v.fromDateFilter");
        let toDateFilter = component.get("v.toDateFilter");

        let action;
        let actionCount;

        if (relate !== null && relate !== '' && relate !== 'none') {
            action = component.get("c.retrieveRelatedNotificationsByStatus");
            action.setParams({
                status: status,
                relId: relate,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter,
                loadLimit: limit
            });

            actionCount = component.get("c.retrieveRelatedNotificationsCount");
            actionCount.setParams({
                status: status,
                relId: relate,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter
            });

        } else {
            action = component.get("c.retrieveNotifications");
            action.setParams({
                status: status,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter,
                loadLimit: limit
            });
            
            actionCount = component.get("c.retrieveNotificationsCount");
            actionCount.setParams({
                status: status,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter
            });
        }

        this.retrieveNotifications(action, component, listNumber, actionCount);
    },

    getExecutionNotifiactions: function (component, listNumber, status) {
        let action = component.get("c.retrieveNotifications");
        action.setParams({
            status: status
        });
        this.retrieveNotifications(action, component, listNumber);
    },

    retrieveNotifications: function (action, component, listNumber, actionCount) {
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();

                if (returnedlist.length > 0) {
                    var labelSequence = "Notification number";
                    returnedlist[0].dropableBody.forEach((element) => {
                        labelSequence += ", " + element.label;
                    });
                }

                if (listNumber == 1) {
                    component.set("v.DisplayableObjectFullList1", returnedlist);
                    component.set("v.labelSequence1", labelSequence);

                    if (!component.get("v.DisplayableObjectFullList1Count")){
                        component.set("v.DisplayableObjectFullList1Count", returnedlist.length);
                    }
                } else {
                    component.set("v.DisplayableObjectFullList2", returnedlist);
                    component.set("v.labelSequence2", labelSequence);

                    if (!component.get("v.DisplayableObjectFullList2Count")){
                        component.set("v.DisplayableObjectFullList2Count", returnedlist.length);
                    }
                }

                component.set("v.isLoadingNotifications", false);
                this.isLoading(component);
            } else if (state === "ERROR") {
                this.showToast(
                    "error",
                    "Error",
                    "There was an error retrieving the notification list, please try again."
                );
            }
        });
        
        component.set("v.isLoadingNotifications", true);
        this.isLoading(component);
        $A.enqueueAction(action);
        
        this.retrieveCount(component, listNumber, actionCount);
    },

    getOrders: function (component, listNumber, status, relate=null) {

        var viewAll = "";

        if (listNumber == 1){
            viewAll = component.get("v.viewAll1");
        }
        else if (listNumber == 2) {
            viewAll = component.get("v.viewAll2");
        }

        let limit = 0;
        if (!viewAll){
            limit = component.get("v.maxSize");
        }

        let action;
        let actionCount;

        let filterSelected = component.get("v.filterSelected");
        let userFilterActive = component.get("v.userFilterActive");

        let fromDateFilter = component.get("v.fromDateFilter");
        let toDateFilter = component.get("v.toDateFilter");

        if (relate) {
            action = component.get("c.retrieveRelatedOrdersByStatus");
            action.setParams({
                status: status,
                relId: relate,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter,
                loadLimit: limit
            });

            actionCount = component.get("c.retrieveRelatedOrdersCount");
            actionCount.setParams({
                status: status,
                relId: relate,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter
            });

        } else {
            action = component.get("c.retrieveOrders");
            action.setParams({
                status: status,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter,
                loadLimit: limit
            });

            actionCount = component.get("c.retrieveOrdersCount");
            actionCount.setParams({
                status: status,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter
            });
        }

        this.retrieveOrders(component, listNumber, action, actionCount);
    },

    getExecutionOrders: function (component, listNumber, status, relate=null) {
        let action;
        let actionCount;

        let filterSelected = component.get("v.filterSelected");
        let userFilterActive = component.get("v.userFilterActive");

        let fromDateFilter = component.get("v.fromDateFilter");
        let toDateFilter = component.get("v.toDateFilter");

        if (relate) {
            action = component.get("c.retrieveRelatedOrders");
            action.setParams({
                status: status,
                relId: relate
            });
        } else {
            action = component.get("c.retrieveOrders");
            action.setParams({
                status: status,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter
            });

            actionCount = component.get("c.retrieveOrdersCount");
            actionCount.setParams({
                status: status,
                mainWorkCenterFilter: filterSelected,
                userFilterActive: userFilterActive,
                fromDateFilter: fromDateFilter,
                toDateFilter: toDateFilter
            });
        }

        this.retrieveOrders(component, listNumber, action, actionCount);
    },

    retrieveOrders: function (component, listNumber, action, actionCount) {
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();

                if (returnedlist.length > 0) {
                    var labelSequence = "Order number";

                    returnedlist[0].dropableBody.forEach((element) => {
                        labelSequence += ", " + element.label;
                    });
                }

                if (listNumber == 1) {
                    component.set("v.DisplayableObjectFullList1", returnedlist);
                    component.set("v.labelSequence1", labelSequence);
                } else {
                    component.set("v.DisplayableObjectFullList2", returnedlist);
                    component.set("v.labelSequence2", labelSequence);
                }
                
                component.set("v.isLoadingOrders", false);
                this.isLoading(component);
            } else if (state === "ERROR") {
                this.showToast(
                    "error",
                    "Error",
                    "There was an error retrieving orders, please try again."
                );
            }
        });

        component.set("v.isLoadingOrders", true);
        this.isLoading(component);
        $A.enqueueAction(action);

        this.retrieveCount(component, listNumber, actionCount);
    },

    getOperations: function (component, listNumber, relate) {
        var viewAll = "";

        if (listNumber == 1){
            viewAll = component.get("v.viewAll1");
        }
        else if (listNumber == 2) {
            viewAll = component.get("v.viewAll2");
        }

        let limit = 0;
        if (!viewAll){
            limit = component.get("v.maxSize");
        }

        let action = component.get("c.retrieveOperations");
        action.setParams({
            orderId: relate,
            loadLimit: limit
        });

        let actionCount = component.get("c.retrieveOperationsCount");
        actionCount.setParams({
            orderId: relate
        });

        this.retrieveOperations(component, listNumber, action, actionCount);
    },

    retrieveOperations: function (component, listNumber, action, actionCount) {
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();

                if (returnedlist.length > 0) {
                    var labelSequence = "Operation no";

                    returnedlist[0].dropableBody.forEach((element) => {
                        labelSequence += ", " + element.label;
                    });
                }

                if (listNumber == 1) {
                    component.set("v.DisplayableObjectFullList1", returnedlist);
                    component.set("v.labelSequence1", labelSequence);
                } else {
                    component.set("v.DisplayableObjectFullList2", returnedlist);
                    component.set("v.labelSequence2", labelSequence);
                }

                component.set("v.isLoadingOperations", false);
                this.isLoading(component);
            } else if (state === "ERROR") {
                this.showToast(
                    "error",
                    "Error",
                    "There was an error retrieving operations, please try again."
                );
            }
        });

        component.set("v.isLoadingOperations", true);
        this.isLoading(component);
        $A.enqueueAction(action);

        this.retrieveCount(component, listNumber, actionCount);
    },

    showToast: function (type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    getFilterOptions: function (component) {
        let action = component.get("c.getRelatedMainWorkCenterNames");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();
                component.set("v.filterOptions", returnedlist);

                component.set("v.isLoadingFilters", false);
                this.isLoading(component);
            } else if (state === "ERROR") {
                this.showToast(
                    "error",
                    "Error",
                    "There was an error retrieving filters, please try again."
                );
            }
        });

        component.set("v.isLoadingFilters", true);
        this.isLoading(component);
        $A.enqueueAction(action);
    },

    isLoading: function (component) {
        var isLoadingNotifications = component.get("v.isLoadingNotifications");
        var isLoadingOrders = component.get("v.isLoadingOrders");
        var isLoadingOperations = component.get("v.isLoadingOperations");
        var isLoadingFilters = component.get("v.isLoadingFilters");
        var isLoadingViewAll = component.get("v.isLoadingViewAll");
        var isLoading = isLoadingNotifications || isLoadingOrders || isLoadingOperations || isLoadingFilters || isLoadingViewAll;
        component.set("v.isLoading", isLoading);
    },

    retrieveCount: function (component, listNumber, actionCount) {

        if (actionCount){
            actionCount.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var DisplayableObjectFullListCount = response.getReturnValue();

                    if (listNumber == 1) {
                        component.set("v.DisplayableObjectFullList1Count", DisplayableObjectFullListCount);
                    } else {
                        component.set("v.DisplayableObjectFullList2Count", DisplayableObjectFullListCount);
                    }
                } else if (state === "ERROR") {
                    this.showToast(
                        "error",
                        "Error",
                        "There was an error retrieving the notification list, please try again."
                    );
                }
            });

            $A.enqueueAction(actionCount);
        }
    }
});