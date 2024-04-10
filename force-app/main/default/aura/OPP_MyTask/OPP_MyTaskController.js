({
    doInit : function(component, event, helper) {
        helper.getNotifications(component, event, helper);
		setInterval(function(){
			helper.getNotifications(component, event, helper);
		}, 5000);
		helper.getApplicationNames(component, event, helper);
	},
    goToMyTasksPage : function(component, event, helper) {
		helper.taskPage(component, event, helper);
	}
})