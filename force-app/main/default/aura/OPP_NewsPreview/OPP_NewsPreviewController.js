({
    init : function(component, event, helper) {
        helper.setTodayDate(component, event, helper);
        helper.setCoinExpiryDate(component, event, helper);
        helper.setUrlThaioilHub(component, event, helper);
        //helper.setCoinBalance(component, event, helper);

        helper.voteNews(component, event, helper);
        helper.loadCategories(component, event, helper);
        helper.loadNewsContent(component, event, helper);
		helper.loadPublishedNews(component, event, helper);
        helper.loadPublishedMostViewNews(component, event, helper);
        //helper.loadTotalCoinBalance(component, event, helper);
    },

    clickSelectCategory: function(component, event, helper) {
        //window.location = "/lightning/n/opp_news?c__category=" + event.currentTarget.dataset.category;
        //var appContextId = helper.getURLParameter("appContextId");
        //if (appContextId) {
        //    alert("https://" + window.location.hostname + window.location.pathname + "?&appContextId=" + appContextId + "&c__category=" + event.currentTarget.dataset.category + "#/lightning/n/opp_news");
        //    //window.location = "https://" + window.location.hostname + window.location.pathname + "?&appContextId=" + appContextId + "&c__category=" + event.currentTarget.dataset.category + "#/lightning/n/opp_news";
        //} else {
        //    alert("https://" + window.location.hostname + "/lightning/n/opp_news" + "?&c__category=" + event.currentTarget.dataset.category);
        //	//window.location = "https://" + window.location.hostname + window.location.pathname + "?&c__category=" + event.currentTarget.dataset.category;    
        //}
        
        var appContextId = helper.getURLParameter("appContextId");
        if (appContextId) {
            window.location = "https://" + window.location.hostname + "/native/bridge.app?&appContextId=" + appContextId + "&c__category=" + event.currentTarget.dataset.category + "#/lightning/n/opp_news";
        } else {
            window.location = "https://" + window.location.hostname + "/lightning/n/opp_news" + "?c__category=" + event.currentTarget.dataset.category;			            
        }

        //var formFactor = $A.get("$Browser.formFactor");
        //if (formFactor == 'DESKTOP') {
		//	window.location = "https://" + window.location.hostname + "/lightning/n/opp_news" + "?c__category=" + event.currentTarget.dataset.category;			            
        //} else {
        //    window.location = "https://" + window.location.hostname + window.location.pathname + "?appContextId=" + appContextId + "&c__category=" + event.currentTarget.dataset.category + "#/lightning/n/opp_news";
        //}
    },

    clickCopyLinkToClipboard: function(component, event, helper) {
        console.log("clickCopyLinkToClipboard");
        var copyLink = document.getElementById("txtCopyLinkToClipboard");
        var hostName = helper.getHostName(window.location.href);
        alert(window.location.href);

        copyLink.value = hostName + '/lightning/r/OPP_News__c/' + component.get("v.recordId") + '/view';
        copyLink.style.display = "block";
        copyLink.select();
        copyLink.setSelectionRange(0, 99999);
        document.execCommand("copy");
        copyLink.style.display = "none";

        $A.get("e.force:showToast").setParams({
            "title": "Copied",
            "type": "success",
            "message": "Copy Link to Clipboard"
        }).fire();
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

    readNews: function (component, event, helper) {
        var action = component.get("c.markNewsAsReadById");
        //var recordId = helper.getURLParameter("c__recordId");
        var recordId = component.get("v.recordId");

        action.setParams({ newsId: recordId });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                //var returnValue = response.getReturnValue();
                //console.log(response.getReturnValue());
                helper.loadTotalCoinBalance(component, event, helper);
            } else {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    toggleLike : function (component, event, helper) {
        var isLiked = component.get('v.isLiked');
        //var recordId = helper.getURLParameter("c__recordId");
        var recordId = component.get("v.recordId");
        
        if (!isLiked) {
        	var action = component.get("c.likeNewsById");
            action.setParams({ newsId : recordId });
            $A.enqueueAction(action);
        } else {
        	var action = component.get("c.unlikeNewsById");
            action.setParams({ newsId : recordId });
            $A.enqueueAction(action);
        }
        component.set('v.isLiked', !isLiked);
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

    clickShowContent: function(component, event, helper) {
        component.set("v.showNewsContent", true);
    },

    clickShowList: function(component, event, helper) {
        component.set("v.showNewsContent", false);
    },
    
})