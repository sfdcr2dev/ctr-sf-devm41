({
    setDefaultCategory: function(component, event, helper) {
        var category = this.getURLParameter('c__category');
        if (category) {
            component.set("v.selectedCategory", category);
        } else {
            component.set("v.selectedCategory", "All");
        }
    },

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

//    setCoinBalance: function(component, event, helper) {
//        component.set('v.coinBalance', 0);
//    },

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

            helper.loadTotalCoinBalance(component, event, helper);
        });

        $A.enqueueAction(action);
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

    loadPublishedNews: function (component, event, helper) {
        var category = component.get("v.selectedCategory");
        var action = component.get("c.getPublishedNewsByCategory");
        action.setParams({ "category": category });

        action.setCallback(this, function(response) {
			var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                //console.log(response.getReturnValue());
                component.set("v.news", result);

                if (category == 'Operation') {
                    var newsOperationKM = [];
                    var newsOperationHOX = [];
                    for (var i in result) {
                        if (result[i].Sub_Category__c == 'KM') {
                            newsOperationKM.push(result[i]);
                        }
                        if (result[i].Sub_Category__c == 'HOX') {
                            newsOperationHOX.push(result[i]);
                        }
                    }
                    component.set("v.newsOperationKM", newsOperationKM);
                    component.set("v.newsOperationHOX", newsOperationHOX);
                    helper.buildPaginationOperationKM(component, event, helper);
                    helper.buildPaginationOperationHOX(component, event, helper);
                }
                helper.buildPagination(component, event, helper);

                component.set("v.showBody", true);
                component.set("v.showFooter", true);

                helper.voteNews(component, event, helper);
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

    loadPublishedHighlightNews: function (component, event, helper) {
        var category = component.get("v.selectedCategory");
        var action = component.get("c.getPublishedHighlightNewsByCategory");
        action.setParams({ "category": category });

        action.setCallback(this, function(response) {
			var state = response.getState();

            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.newsHighlight", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                console.log('loadPublishedHighlightNews: INCOMPLETE');
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

    doSelectCategory: function(component, event, helper) {
        helper.loadPublishedNews(component, event, helper);
    },

    buildPagination: function(component, event, helper) {
        var news = component.get("v.news");
        var newsPerPage = component.get("v.newsPerPage");

        if (news && newsPerPage) {
            var newsMaxPages = Math.ceil(news.length / newsPerPage);
            var newsNumberPages = [];
            for (var i = 0; i < newsMaxPages; i++) {
                newsNumberPages.push(i + 1);
            }
            component.set("v.newsNumberPages", newsNumberPages);
            component.set("v.newsNumberOfPages", newsNumberPages.length);
        } else {
            component.set("v.newsNumberPages", [1]);
            component.set("v.newsNumberOfPages", 1);
        }

        component.set("v.newsCurrentPage", 1);
        component.set("v.newsStartIndex", 0);
        component.set("v.newsEndIndex", newsPerPage);

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

    buildPaginationOperationKM: function(component, event, helper) {
        var news = component.get("v.newsOperationKM");
        var newsPerPage = component.get("v.newsOperationKMPerPage");

        if (news && newsPerPage) {
            var newsMaxPages = Math.ceil(news.length / newsPerPage);
            var newsNumberPages = [];
            for (var i = 0; i < newsMaxPages; i++) {
                newsNumberPages.push(i + 1);
            }
            component.set("v.newsOperationKMNumberPages", newsNumberPages);
            component.set("v.newsOperationKMNumberOfPages", newsNumberPages.length);
        } else {
            component.set("v.newsOperationKMNumberPages", [1]);
            component.set("v.newsOperationKMNumberOfPages", 1);
        }

        component.set("v.newsOperationKMCurrentPage", 1);
        component.set("v.newsOperationKMStartIndex", 0);
        component.set("v.newsOperationKMEndIndex", newsPerPage);

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

    buildPaginationOperationHOX: function(component, event, helper) {
        var news = component.get("v.newsOperationHOX");
        var newsPerPage = component.get("v.newsPerPageOperationHOX");

        if (news && newsPerPage) {
            var newsMaxPages = Math.ceil(news.length / newsPerPage);
            var newsNumberPages = [];
            for (var i = 0; i < newsMaxPages; i++) {
                newsNumberPages.push(i + 1);
            }
            component.set("v.newsOperationHOXNumberPages", newsNumberPages);
            component.set("v.newsOperationHOXNumberOfPages", newsNumberPages.length);
        } else {
            component.set("v.newsOperationHOXNumberPages", [1]);
            component.set("v.newsOperationHOXNumberOfPages", 1);
        }

        component.set("v.newsOperationHOXCurrentPage", 1);
        component.set("v.newsOperationHOXStartIndex", 0);
        component.set("v.newsOperationHOXEndIndex", newsPerPage);

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

    getURLParameter : function(param) {
        var result = decodeURIComponent
            ((new RegExp('[?|&]' + param + '=' + '([^&;]+?)(&|#|;|$)').
                exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
        //console.log('Param ' + param + ' from URL = ' + result);
        return result;
    },
})