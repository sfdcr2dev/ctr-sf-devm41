({
	init : function(component, event, helper) {
        helper.loadPublishedMostViewNews(component, event, helper);
        helper.loadSpecialIssuesNews(component, event, helper);
        helper.setUrlThaioilHub(component, event, helper);
	},

	clickRead: function (component, event, helper) {
        var navService = component.find("navigation");
        // Sets the route to /lightning/o/Account/home
        var pageReference = {
            type: "standard__recordPage",
            attributes: {
                //recordId: event.target.getAttribute("data-record-id"),
                recordId: event.currentTarget.dataset.recordId,
                objectApiName: "News__c",
                actionName: "view"
            }
        };
        component.set("v.pageReference", pageReference);
        // Set the URL on the link or use the default if there's an error
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));

        event.preventDefault();
        navService.navigate(pageReference);
    },

    clickGoToShop: function(component, event, helper) {
        var urlQRCodeThaioilHub = component.get("v.urlQRCodeThaioilHub");
        $A.createComponent(
            "lightning:formattedRichText", {
                "value": '<img src="' + urlQRCodeThaioilHub + '"/>'
            }, function(richText, status, errorMessage) {
                if (status === "SUCCESS") {
                    component.find('overlayLib').showCustomModal({
                        body: richText,
                        showCloseButton: true,
                        cssClass: "news-shop-modal",
                    });
                } else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                } else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
    },
})