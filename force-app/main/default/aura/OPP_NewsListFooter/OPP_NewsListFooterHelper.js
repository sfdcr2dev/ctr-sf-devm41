({
    setUrlThaioilHub: function (component, event, helper) {
        component.set('v.urlAndroidThaioilHub', 'https://play.google.com/store/apps/details?id=com.thaioilhubmobile&hl=th&gl=US');
        component.set('v.urlIPhoneThaioilHub', 'https://bit.ly/2UZL7PJ');
    },

	loadPublishedMostViewNews: function (component, event, helper) {
        var action = component.get("c.getPublishedMostViewNews");
        action.setParams({ "limitResult": 5 });

        action.setCallback(this, function(response) {
			var state = response.getState();

            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.newsMostView", response.getReturnValue());

                component.set("v.showFooter", true);
            }
            else if (state === "INCOMPLETE") {
                console.log('loadPublishedMostViewNews: INCOMPLETE');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },

	loadSpecialIssuesNews: function (component, event, helper) {
        var action = component.get("c.getSpecialIssuesNews");

        action.setCallback(this, function(response) {
			var state = response.getState();

            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.newsSpecialIssues", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                console.log('loadSpecialIssuesNews: INCOMPLETE');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },
})