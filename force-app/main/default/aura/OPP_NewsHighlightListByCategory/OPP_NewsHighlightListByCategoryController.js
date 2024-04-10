({
	init : function(component, event, helper) {
        helper.loadPublishedNews(component, event, helper);
    },

	handleNewsCategoryChangedEvent : function(component, event, helper) {
		var category = event.getParam("category");
        
        component.set("v.category", category);
        
        helper.loadPublishedNews(component, event, helper);
	}
})