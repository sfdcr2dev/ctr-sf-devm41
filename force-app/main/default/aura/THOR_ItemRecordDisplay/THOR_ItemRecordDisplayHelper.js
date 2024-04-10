({
	handleSetInterval: function (component) {
		var intervalGetInfo = setInterval(
			$A.getCallback(() => {
				if (
					component.find('recordLoader') &&
					component.get('v.itemRecord.Integration_Status__c') &&
					component.get('v.itemRecord.Integration_Status__c') === 'In Progress'
				) {
					component.find('recordLoader').reloadRecord(true);
				} else if (
					component.get('v.interval') &&
					component.find('recordLoader') &&
					component.get('v.itemRecord.Integration_Status__c') !== 'In Progress'
				) {
					console.warn('clearInterval');
					clearInterval(component.get('v.interval'));
					component.set('v.interval', null);
				}
			}),
			5000
		);
		component.set('v.interval', intervalGetInfo);
	},

	handleSetTimeout: function (component) {
		setTimeout(
			$A.getCallback(() => {
				console.warn('Timeout');
				if (component.get('v.itemRecord.Integration_Status__c') === 'In Progress') {
					component.find('recordTimeoutForm').submit();
				}
			}),
			60 * 1000
		);
	},
 
    navigateBack : function(component) {
        var pageRef = component.get("v.pageReference");
        let navLink = component.find("navLink");
        let notificationId = component.get("v.notificationId");
        alert('DELETE---notificationId---'+notificationId);
        pageRef = {
            type: "standard__component",
            attributes: {
                //"componentName": "c__THOR_NotificationRelatedListDisplayer"
                componentName: 'c__THOR_NotificationRelatedItems'
            },
            state: {
                //"c__recordId": component.get("v.notificationId")
                c__notificationId: notificationId
            },
        }; 
        navLink.navigate(pageRef, true);
    },
    
    resolveNotification: function(component) {
        let pageref = component.get("v.pageReference");
        let recordId = pageref.state.c__recordId;
        if (recordId) {
            component.set("v.recordId", recordId);

            let notificationId = component.get("v.notificationId");
            if (typeof notificationId == "undefined") {
                let action = component.get("c.getNotificationFromItem");
                action.setParams({
                    itemId: recordId
                });

                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        let notification = response.getReturnValue()[0].notification;
                        component.set("v.notificationId", notification);
                    }
                    component.set("v.isLoading", false);
                });

                $A.enqueueAction(action);
            }
        }
    },
    
    checkWriteAccess: function(component) {
        var pageRef = component.get("v.pageReference");
        if (pageRef) {
            var recordId = pageRef.state.c__recordId;
            component.set("v.recordId", recordId);
        }
		let action = component.get('c.hasWriteAccess');
        
        action.setParams({
            itemId: recordId
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.hasWriteAccess', response.getReturnValue());
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " +
                                      errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getCauses : function(component, event, _itemId) {
        var action = component.get("c.getCauses");
        action.setParams({
            itemId: _itemId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();
                console.log(returnedlist);
                component.set("v.DisplayableCauseObjectFullList", returnedlist);
                if (returnedlist && returnedlist.length) {
                    component.set("v.DisplayableCauseObjectFullListCount", returnedlist.length);
                }

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getActivities : function(component, event, _itemId) {
        var action = component.get("c.getActivities");
        action.setParams({
            itemId: _itemId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedlist = response.getReturnValue();
                component.set("v.DisplayableActivityObjectFullList", returnedlist);
                if (returnedlist && returnedlist.length) {
                    component.set("v.DisplayableActivityObjectFullListCount", returnedlist.length);
                }
                component.set("v.labelSequence", "Activity Code Group, Activity Code, Code Text, Activity Text");

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})