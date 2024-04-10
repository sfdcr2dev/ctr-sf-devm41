({
	init : function(component, event, helper) {
        helper.setDefaultCategory(component, event, helper);
        helper.setTodayDate(component, event, helper);
        helper.setCoinExpiryDate(component, event, helper);
        helper.setUrlThaioilHub(component, event, helper);
        //helper.setCoinBalance(component, event, helper);

        //helper.voteNews(component, event, helper);
        helper.loadCategories(component, event, helper);
		helper.loadPublishedNews(component, event, helper);
		helper.loadPublishedHighlightNews(component, event, helper);
        //helper.loadPublishedMostViewNews(component, event, helper);
        //helper.loadTotalCoinBalance(component, event, helper);
	},

    clickRead: function (component, event, helper) {
        //var navEvt = $A.get("e.force:navigateToSObject");
        //navEvt.setParams({
        //    "recordId": component.get("v.recordId")
        //});
        //navEvt.fire();

        //window.location = "/lightning/n/ReadNews?c__recordId=" + event.target.id
        //return;

        //component.find("navigation")
        //    .navigate({
        //        "type" : "standard__navItemPage",
        //        "attributes": {
        //            "apiName"      : "Feed_Detail",
        //        },
        //        "state": {
        //            "c__recordId": event.target.id
        //        }
        //    }, true);

        //component.find("navigation")
        //    .navigate({
        //        type: "standard__app",
        //        attributes: {
        //            //appTarget: "standard__LightningSales",
        //            pageRef: {
        //                type: "standard__recordPage",
        //                attributes: {
        //                    //recordId: event.target.getAttribute("data-record-id"),
        //                    recordId: event.currentTarget.dataset.recordId,
        //                    objectApiName: "News__c",
        //                    actionName: "view"
        //                }
        //            }
        //        }
        //    }, true);



        var navService = component.find("navigation");
        // Sets the route to /lightning/o/Account/home
        var pageReference = {
            type: "standard__recordPage",
            attributes: {
                //recordId: event.target.getAttribute("data-record-id"),
                recordId: event.currentTarget.dataset.recordId,
                objectApiName: "OPP_News__c",
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

    clickSelectCategory: function(component, event, helper) {
        //var category = event.currentTarget.dataset.category;
        //component.set("v.selectedCategory", category);

        //helper.doSelectCategory(component, event, helper);

        //window.location = "/lightning/n/opp_news?c__category=" + event.currentTarget.dataset.category;

        //alert(window.location);

        var appContextId = helper.getURLParameter("appContextId");
        if (appContextId) {
            window.location = "https://" + window.location.hostname + window.location.pathname + "?&appContextId=" + appContextId + "&c__category=" + event.currentTarget.dataset.category + "#/lightning/n/opp_news";
        } else {
        	window.location = "https://" + window.location.hostname + window.location.pathname + "?&c__category=" + event.currentTarget.dataset.category;
        }
    },
    
    mouseenterCategory: function(component, event, helper) {
        var categories = component.get("v.categories");
        for (var index in categories) {
            if (categories[index].name == event.currentTarget.dataset.category) {
                categories[index].isHover = true;
            }
        }
        component.set("v.categories", categories);
    },
    
    mouseleaveCategory: function(component, event, helper) {
        var categories = component.get("v.categories");
        for (var index in categories) {
            if (categories[index].name == event.currentTarget.dataset.category) {
                categories[index].isHover = false;
            }
        }
        component.set("v.categories", categories);
    },

    clickGoToPage: function(component, event, helper) {
        var newsCurrentPage = event.currentTarget.value;
        var newsPerPage = component.get("v.newsPerPage");
        var newsStartIndex = (newsCurrentPage - 1) * newsPerPage;
        var newsEndIndex = newsCurrentPage * newsPerPage;

        component.set("v.newsCurrentPage", newsCurrentPage);
        component.set("v.newsStartIndex", newsStartIndex);
        component.set("v.newsEndIndex", newsEndIndex);

        var subNewsNumberPages = [];
        var maxDisplayNumberOfPages = 4;
        var newsNumberOfPages = component.get("v.newsNumberOfPages")
        var newsCurrentPage = component.get("v.newsCurrentPage");
        if (newsNumberOfPages > maxDisplayNumberOfPages) {
            if (newsCurrentPage == 1) {
                for (var i = 0; i < maxDisplayNumberOfPages; i++) {
                    subNewsNumberPages.push(i + 1);
                }
            } else if (newsCurrentPage + (maxDisplayNumberOfPages/2) < newsNumberOfPages) {
                for (var i = 0; i < maxDisplayNumberOfPages; i++) {
                    subNewsNumberPages.push(newsCurrentPage + i - 1);
                }
            } else {
                for (var i = 0; i < maxDisplayNumberOfPages; i++) {
                    subNewsNumberPages.push(newsNumberOfPages - (maxDisplayNumberOfPages - 1) + i);
                }
            }
            component.set("v.newsNumberPages", subNewsNumberPages);
        }
    },

    clickGoToOperationKMPage: function(component, event, helper) {
        var newsOperationKMCurrentPage = event.currentTarget.value;
        var newsOperationKMPerPage = component.get("v.newsOperationKMPerPage");
        var newsOperationKMStartIndex = (newsOperationKMCurrentPage - 1) * newsOperationKMPerPage;
        var newsOperationKMEndIndex = newsOperationKMCurrentPage * newsOperationKMPerPage;

        component.set("v.newsOperationKMCurrentPage", newsOperationKMCurrentPage);
        component.set("v.newsOperationKMStartIndex", newsOperationKMStartIndex);
        component.set("v.newsOperationKMEndIndex", newsOperationKMEndIndex);

        var subNewsNumberPages = [];
        var maxDisplayNumberOfPages = 4;
        var newsNumberOfPages = component.get("v.newsOperationKMNumberOfPages")
        var newsCurrentPage = component.get("v.newsOperationKMCurrentPage");
        if (newsNumberOfPages > maxDisplayNumberOfPages) {
            if (newsCurrentPage == 1) {
                for (var i = 0; i < maxDisplayNumberOfPages; i++) {
                    subNewsNumberPages.push(i + 1);
                }
            } else if (newsCurrentPage + (maxDisplayNumberOfPages/2) < newsNumberOfPages) {
                for (var i = 0; i < maxDisplayNumberOfPages; i++) {
                    subNewsNumberPages.push(newsCurrentPage + i - 1);
                }
            } else {
                for (var i = 0; i < maxDisplayNumberOfPages; i++) {
                    subNewsNumberPages.push(newsNumberOfPages - (maxDisplayNumberOfPages - 1) + i);
                }
            }
            component.set("v.newsOperationKMNumberPages", subNewsNumberPages);
        }
    },

    clickGoToOperationHOXPage: function(component, event, helper) {
        var newsOperationHOXCurrentPage = event.currentTarget.value;
        var newsOperationHOXPerPage = component.get("v.newsOperationHOXPerPage");
        var newsOperationHOXStartIndex = (newsOperationHOXCurrentPage - 1) * newsOperationHOXPerPage;
        var newsOperationHOXEndIndex = newsOperationHOXCurrentPage * newsOperationHOXPerPage;

        component.set("v.newsOperationHOXCurrentPage", newsOperationHOXCurrentPage);
        component.set("v.newsOperationHOXStartIndex", newsOperationHOXStartIndex);
        component.set("v.newsOperationHOXEndIndex", newsOperationHOXEndIndex);

        var subNewsNumberPages = [];
        var maxDisplayNumberOfPages = 4;
        var newsNumberOfPages = component.get("v.newsOperationHOXNumberOfPages")
        var newsCurrentPage = component.get("v.newsOperationHOXCurrentPage");
        if (newsNumberOfPages > maxDisplayNumberOfPages) {
            if (newsCurrentPage == 1) {
                for (var i = 0; i < maxDisplayNumberOfPages; i++) {
                    subNewsNumberPages.push(i + 1);
                }
            } else if (newsCurrentPage + (maxDisplayNumberOfPages/2) < newsNumberOfPages) {
                for (var i = 0; i < maxDisplayNumberOfPages; i++) {
                    subNewsNumberPages.push(newsCurrentPage + i - 1);
                }
            } else {
                for (var i = 0; i < maxDisplayNumberOfPages; i++) {
                    subNewsNumberPages.push(newsNumberOfPages - (maxDisplayNumberOfPages - 1) + i);
                }
            }
            component.set("v.newsOperationHOXNumberPages", subNewsNumberPages);
        }
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