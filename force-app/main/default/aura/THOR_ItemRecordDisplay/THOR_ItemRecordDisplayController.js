({
    doInit: function (component, event, helper) {
        helper.resolveNotification(component);
        helper.checkWriteAccess(component);
        //helper.handleSetInterval(component);
		//helper.handleSetTimeout(component);
        helper.getCauses(component, event, component.get("v.recordId"));
        helper.getActivities(component, event, component.get("v.recordId"));
    },

    doRefresh: function(component, event, helper){
        $A.get('e.force:refreshView').fire();
    },

    openModal: function (component, event, helper) {
        component.set("v.DeleteIsOpen", true);
    },

    closeModal: function (component, event, helper) {
        component.set("v.DeleteIsOpen", false);
    },

    closeEditModalAndNotify: function (component, event, helper) {
        component.set("v.EditIsOpen", false);
        component.find("notifLib").showToast({
            variant: "success",
            title: "Item updated"
        });
    },

    handleDeleteItem: function (component, event, helper) {
        let action = component.get("c.markItemAsDeleted");
        action.setParams({
            itemId: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.find("notifLib").showToast({
                    variant: "success",
                    title: "Item Deleted"
                });

                let closeModal = component.get("c.closeModal");
                $A.enqueueAction(closeModal);
                
                var action = component.get("c.sendToSAP");
                action.setParams({
                    "itemId": component.get("v.recordId")
                });
                $A.enqueueAction(action);

                helper.navigateBack(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.find("notifLib").showToast({
                            variant: "error",
                            title: "Item Deleted",
                            body: errors[0].message
                        });
                    }
                }
            }
        });

        $A.enqueueAction(action);
    },

	handleRecordUpdated: function (component, event, helper) {
		const eventParams = event.getParams();

		let { changeType, changedFields } = eventParams;
		if (changeType === 'CHANGED' && changedFields && changedFields['Integration_Status__c']) {
			// component.set(`v.itemRecord.Integration_Status__c`, changedFields['Integration_Status__c'].value);
			//console.log(JSON.parse(JSON.stringify(component.get('v.itemRecord'))));
			//helper.handleSetInterval(component);
		}
//		component.set(
//			'v.isAlertIntegration',
//			component.get('v.itemRecord.Integration_Status__c') === 'Failed'
//		);

		component.set('v.isLoading', false);
	},

	handleSelectButtonMenu: function (component, event, helper) {
		var selectedFunc = event.getParam('value');
		if (selectedFunc) {
			$A.enqueueAction(component.get(selectedFunc));
		}
	},


    navigateToItemsList: function (component, event, helper) {
        helper.navigateBack(component);
    },

    navigateHelper: function (component, event) {
        let toComponent = event.getParam("toThisComponent");
        let recordId = event.getParam("theRecordId");
        let fromRecordId = component.get("v.recordId");

        let navLink = component.find("navLink");
        let pageRef = {
            type: "standard__component",
            attributes: {
                componentName: toComponent,
            },
            state: {
                c__recordId: recordId,
                c__fromRecordId: fromRecordId,
            }
        };
        navLink.navigate(pageRef, true);
    },

    navigateToEditPage : function (component, event) {
        let pageRef;
        let navLink = component.find("navLink");
        let recordId = component.get("v.recordId");
        let notificationId = component.get("v.notificationId");
   
        pageRef = {
             type: "standard__component",
             attributes: {
                 "componentName": "c__THOR_EditItemObjectPart"
             },
             state: {
                 "c__notificationId": notificationId,
                 "c__itemId" : recordId
             },
         };
         navLink.navigate(pageRef, true);
    },

    openResendModal: function (component, event, helper) {
        component.set("v.ResendIsOpen", true);
    },

    closeResendModal: function (component, event, helper) {
        component.set("v.ResendIsOpen", false);
    },

    handleResendItem: function (component, event, helper) {
        component.find('itemResendForm').submit();
    },

    handleError: function (component, event, helper) {

    },

    handleSuccess: function (component, event, helper) {
        var action = component.get("c.sendToSAP");
        action.setParams({
            "itemId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
//            var pageRef = component.get("v.pageReference");
//            let navLink = component.find("navLink");
//    
//            pageRef = {
//                type: "standard__component",
//                attributes: {
//                    "componentName": "c__THOR_NotificationRelatedListDisplayer"
//                },
//                state: {
//                    "c__recordId": component.get("v.notificationId")
//                },
//            }; 
//            navLink.navigate(pageRef, true);
//            $A.enqueueAction(component.get("c.doRefresh"));
            var pageRef = component.get("v.pageReference");
            let navLink = component.find("navLink");
            
            pageRef = {
                type: "standard__component",
                attributes: {
                    componentName: 'c__THOR_NotificationRelatedItems'
                },
                state: {
                    c__notificationId: component.get("v.notificationId")
                },
            }; 
            navLink.navigate(pageRef, true);
        });
        $A.enqueueAction(action);
    }

});