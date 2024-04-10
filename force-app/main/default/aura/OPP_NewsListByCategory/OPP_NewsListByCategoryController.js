({
    init : function(component, event, helper) {
        helper.loadPublishedNews(component, event, helper);
    },

    handleNewsCategoryChangedEvent : function(component, event, helper) {
        var category = event.getParam("category");
        
        component.set("v.category", category);
        
        helper.loadPublishedNews(component, event, helper);
    },

    readNews: function (component, event, helper) {        
        component.find("navigation")
            .navigate({
                type: "standard__app",
                attributes: {
                    pageRef: {
                        type: "standard__recordPage",
                        attributes: {
                            recordId: event.target.getAttribute("data-record-id"),
                            objectApiName: "News__c",
                            actionName: "view"
                        }
                    }
                }
            }, true);
    }
})