({
    setTodayDate: function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DDTHH:mm:ssZ");
        component.set('v.today', today);
    },

    setCoinExpiryDate: function(component, event, helper) {
        var lastDateOfThisYear = new Date();
        lastDateOfThisYear.setHours(0);
        lastDateOfThisYear.setMinutes(0);
        lastDateOfThisYear.setSeconds(0);
        lastDateOfThisYear.setMilliseconds(0);
        lastDateOfThisYear.setMonth(11);
        lastDateOfThisYear.setDate(31);

        var thMonth = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];

        var year = String(lastDateOfThisYear.getFullYear() + 543).substr(-2);
        var month = thMonth[lastDateOfThisYear.getMonth()];
        var date = lastDateOfThisYear.getDate();

        var thDate = date + ' ' + month + ' ' + year;

        component.set('v.coinExpiryDate', thDate);
    },

    setUrlThaioilHub: function (component, event, helper) {
        component.set('v.urlAndroidThaioilHub', 'https://play.google.com/store/apps/details?id=com.thaioilhubmobile&hl=th&gl=US');
        component.set('v.urlIPhoneThaioilHub', 'https://bit.ly/2UZL7PJ');
    },

    setCoinBalance: function(component, event, helper) {
        component.set('v.coinBalance', 0);
    },

    loadCategories: function (component, event, helper) {
        var action = component.get("c.getCategoryPicklist");

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var categories = [];
                for (var index in result) {
                    categories.push({
                        name: result[index],
                        isHover: false
                    });
                }
                component.set("v.categories", categories);
                
                setTimeout(function() {
                    var activeCategory = document.querySelector(".news-category.active");
                    if (activeCategory && activeCategory.parentElement && activeCategory.parentElement.parentElement) {
                        var rect = activeCategory.parentElement.getBoundingClientRect();
                        var categoryWrapper = activeCategory.parentElement.parentElement;
                        categoryWrapper.scrollLeft = rect.x - 15;                        
                    }
                }, 1000);
            } else if (state === "INCOMPLETE") {
                console.log("loadCategories: INCOMPLETE");
            } else if (state === "ERROR") {
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

    voteNews: function (component, event, helper) {
        var action = component.get("c.voteNews");

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {

            } else if (state === "INCOMPLETE") {
                console.log("loadCategories: INCOMPLETE");
            } else if (state === "ERROR") {
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

	loadNewsContent : function(component, event, helper) {
		var action = component.get("c.getNewsById");
        //var recordId = helper.getURLParameter("c__recordId");
        var recordId = component.get("v.recordId");
        if (!recordId) {
            recordId = helper.getURLParameter("c__recordId");
        }

        action.setParams({ newsId : recordId });

        action.setCallback(this, function(response) {
			var state = response.getState();

            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                component.set("v.newsContent", returnValue[0]);

                var category = returnValue[0].Category__c;
                if (category) {
                    component.set("v.selectedCategory", category);
                } else {
                    component.set("v.selectedCategory", "Home");
                }

                this.generateAttachmentLinks(component, event, helper);
            }
            else  {
                console.log(response.getError());
            }
        })
        $A.enqueueAction(action)

        var isLikedAction = component.get("c.isLikedNewsById");
        isLikedAction.setParams({ newsId: recordId });
        isLikedAction.setCallback(this, function (response) {
            //console.log(response.getReturnValue());
            component.set('v.isLiked', response.getReturnValue());
        })
        $A.enqueueAction(isLikedAction);

        var readNewsAction = component.get("c.readNews");
        $A.enqueueAction(readNewsAction);
	},

    loadPublishedNews: function (component, event, helper) {
        var category = component.get("v.selectedCategory");
        if (!category) {
            category = "Home";
        }

        var action = component.get("c.getPublishedNewsByCategory");
        action.setParams({ "category": category });

        action.setCallback(this, function(response) {
			var state = response.getState();

            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.news", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                console.log('loadPublishedNews: INCOMPLETE');
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

    loadPublishedMostViewNews: function (component, event, helper) {
        var category = component.get("v.selectedCategory");
        var action = component.get("c.getPublishedMostViewNews");
        action.setParams({ "limitResult": 5 });

        action.setCallback(this, function(response) {
			var state = response.getState();

            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.newsMostView", response.getReturnValue());
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

    loadTotalCoinBalance : function(component, event, helper) {
        var action = component.get("c.getCoinBalance");

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                component.set("v.coinBalance", response.getReturnValue());
            } else if (state === "INCOMPLETE") {
                console.log("loadCategories: INCOMPLETE");
            } else if (state === "ERROR") {
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

    generateAttachmentLinks : function(component, event, helper) {
        var newsContent = component.get("v.newsContent");

        if (newsContent.File_Attachment__c && newsContent.ContentDocumentLinks) {
            var attachments = [];
            for (var i in newsContent.ContentDocumentLinks) {
                var document = newsContent.ContentDocumentLinks[i];
                var fileExtension = String(document.ContentDocument.FileExtension).toLowerCase();
                if (fileExtension == 'pdf'
                    || fileExtension == 'xls'
                    || fileExtension == 'xlsx'
                    || fileExtension == 'doc'
                    || fileExtension == 'docx'
                    || fileExtension == 'ptt'
                    || fileExtension == 'pttx')
                {
                    attachments.push('<li><a rel="noopener" target="_blank" download="' + document.ContentDocument.Title + '.' + document.ContentDocument.FileExtension + '" href="https://' + window.location.hostname + '/sfc/servlet.shepherd/document/download/' + document.ContentDocumentId + '">' + document.ContentDocument.Title + '.' + document.ContentDocument.FileExtension + '</a></li>');
                }
            }
            attachments = attachments.join('');
            if (attachments) {
                attachments = '<p><ul>' + attachments + '</ul></p>';
            }
            component.set('v.attachments', attachments);
        }

    },

	getURLParameter : function(param) {
        var result=decodeURIComponent
            ((new RegExp('[?|&]' + param + '=' + '([^&;]+?)(&|#|;|$)').
                exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
        console.log('Param ' + param + ' from URL = ' + result);
        return result;
    },

    getHostName : function(param) {
        var hostname;
        //find & remove protocol (http, ftp, etc.) and get hostname

        if (param.indexOf("//") > -1) {
            hostname = param.split('/')[2];
        }
        else {
            hostname = param.split('/')[0];
        }

        //find & remove port number
        hostname = hostname.split(':')[0];
        //find & remove "?"
        hostname = hostname.split('?')[0];

        return hostname;
    }
})