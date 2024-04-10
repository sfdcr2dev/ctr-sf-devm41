({
	getFirstMyTasks : function(component, event, helper) {
        var action = component.get("c.getMyTasks");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				component.set("v.mytasks", response.getReturnValue());
				helper.getFirstCountNotifications(component, event, helper);
			}
		});
		$A.enqueueAction(action);
    }, 
	getMyTasks : function(component, event, helper) {
        var action = component.get("c.getMyTasks");
        if (action) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
					let results = response.getReturnValue();
					let mytasks = helper.setWorkPermitAndWorkOrderUrl(results);
                    component.set("v.mytasks", mytasks);
                    helper.getCountNotifications(component, event, helper);
                }
            });
            $A.enqueueAction(action);
        }
    }, 
    // getLastMonthNoifications : function(component, event, helper) {
    //     var action = component.get("c.getLastMonthNotifications");
	// 	action.setCallback(this, function(response) {
	// 		var state = response.getState();
	// 		if(state === "SUCCESS") {
	// 			component.set("v.lastMonthNotifications", response.getReturnValue());
	// 		}
	// 	});
	// 	$A.enqueueAction(action);
    // },
    // getLastYearNoifications : function(component, event, helper) {
    //     var action = component.get("c.getLastYearNotifications");
	// 	action.setCallback(this, function(response) {
	// 		var state = response.getState();
	// 		if(state === "SUCCESS") {
	// 			component.set("v.lastYearNotifications", response.getReturnValue());
	// 		}
	// 	});
	// 	$A.enqueueAction(action);
    // },
    getCountNotifications : function(component, event, helper) {
        var action = component.get("c.getCountNotifications");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				component.set("v.countNotifications", response.getReturnValue());
				// if(component.get("v.countNotifications") != component.get("v.oldCountNotifications")) {
				// 	component.set("v.oldCountNotifications", component.get("v.countNotifications"));
				// 	$A.get('e.force:refreshView').fire();
            	// }
			}
		});
		$A.enqueueAction(action);
    },
	getFirstCountNotifications : function(component, event, helper) {
        var action = component.get("c.getCountNotifications");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if(state === "SUCCESS") {
				component.set("v.oldCountNotifications", response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
    },
	setWorkPermitAndWorkOrderUrl : function(mytasks) {
		let helper = this;
		let workpermits = mytasks.find(function (value){
			return value.appName == "Work Permit";
		});
		if (!$A.util.isEmpty(workpermits)) {
			workpermits.notifications.forEach(function (value) {
				let url = helper.getSapGuiUrl(
					helper.getUsernameFromEmail(value.UserName__c).toUpperCase(),
					value.UserName__c,
					value.ReferenceID__c
				);
				value.URL__c = url;
				value.isSapGuiUrl__c = true;
			});
		}
		
		let workorders = mytasks.find(function (value){
			return value.appName == "Work Order";
		});
		if (!$A.util.isEmpty(workorders)) {
			workorders.notifications.forEach(function (value) {
				let url = helper.getSapGuiUrl(
					helper.getUsernameFromEmail(value.UserName__c).toUpperCase(),
					value.UserName__c,
					value.ReferenceID__c
				);
				value.URL__c = url;
				value.isSapGuiUrl__c = true;
			});
		}
		return mytasks;
	},
	getUsernameFromEmail : function(email) {
		let match = email.match(/^([^@]*)@/);
		return match ? match[1] : email;
	},
	getSapGuiUrl : function(username, email, referenceid) {
		return `data:text/plain,[System]\nName=TEP\nDescription=\nClient=900\n[User]\nName=${username}\nLanguage=EN\n[Function]\nTitle=\nCommand=*swnwiex p_action=EXECUTE; p_wi_id=${referenceid}; p_appl=RSWUWFML2; DYNP_OKCODE=ONLI\nType=Transaction\n[Configuration]\nGuiSize=Normal window\n[Workflow]\nEmail=${email}`;
	},
})