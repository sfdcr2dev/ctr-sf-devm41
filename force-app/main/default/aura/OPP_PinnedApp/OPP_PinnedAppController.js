({
    doInit : function(component, event, helper) {
		helper.getApplications(component, event, helper);
		// setInterval(function(){
        //     helper.getApplications(component, event, helper);
        // }, 5000);    
	},
    goToPinnedApps : function(component, event, helper) {
		helper.pinnedApps(component, event, helper);
	},
	// reInit : function(component, event, helper) {
    //     setInterval(function(){
    //         helper.getApplications(component, event, helper);
    //     }, 2000);
    // }
})