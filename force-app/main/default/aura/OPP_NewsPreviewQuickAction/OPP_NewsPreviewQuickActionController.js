({
    init : function(component, event, helper) {
        var navService = component.find("navigation");
        // Sets the route to /lightning/o/Account/home
        var pageReference = {
            //appTarget: "standard__LightningSales",
            type: "standard__navItemPage",
            attributes: {
                //recordId: event.target.getAttribute("data-record-id"),
                //recordId: component.get("v.recordId"),
                //objectApiName: "OPP_News__c",
                //actionName: "view"
                "apiName"      : "opp_news_preview",
            },
            state: {
                "c__recordId": component.get("v.recordId"),
            }
        };
        component.set("v.pageReference", pageReference);
        // Set the URL on the link or use the default if there's an error
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
                //window.open(url);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));

        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();

        //event.preventDefault();
        navService.navigate(pageReference);
    },
})