({
    doInit : function(component, event, helper) {
        helper.getNews(component, event, helper);
    },
    goToNews : function(component, event, helper) {
		helper.newPage(component, event, helper);
	},
    goToNewsPage : function(component, event, helper) {
        var id = event.currentTarget.id;
        var evt = $A.get("e.force:navigateToURL");
		evt.setParams({
			url: "/lightning/r/OPP_News__c/" + id + "/view"
		});
		evt.fire();
    }
})