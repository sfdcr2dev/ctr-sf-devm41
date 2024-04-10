({
    doInit : function(component, event, helper) {
        helper.getFirstMyTasks(component, event, helper);
        helper.getMyTasks(component, event, helper);
        setInterval(function(){
            helper.getMyTasks(component, event, helper);
        }, 5000);    
    },
	handleKeyPress: function (component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        var enterSearch = $A.util.isArray(component.find('enter-search')) ? component.find('enter-search')[0] : component.find('enter-search');
        var value = enterSearch.get('v.value');
        if (!isEnterKey) {
            var action = component.get("c.searchTasks");
			action.setParams({
				'str': value
			});
			action.setCallback(this, function(response) {
				var state = response.getState();
				if(state === "SUCCESS") {
					var result = response.getReturnValue();
					component.set("v.mytasks", response.getReturnValue());
					if(result == 0) {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"title": "",
							"message": "We searched the objects you use most and didn't find any matches for " + '"' + value + '"',
							"type": "info"
						});
						toastEvent.fire();
					}
				}
			});
			$A.enqueueAction(action);
        }
    },
    reInit : function(component, event, helper) {
        setInterval(function(){
            helper.getMyTasks(component, event, helper);
        }, 1000); 
    },
    warningMessage : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "",
            "message": "You must open SAP Logon Application to approve this task!",
            "type": "info"
        });
        toastEvent.fire();
    }
    // goToURL : function(component, event, helper) {
	// 	var evt = $A.get("e.force:navigateToURL");
	// 	evt.setParams({
	// 		url: "/lightning/n/OPP_Home"
	// 	});
	// 	evt.fire();
	// }
})