({
	init : function(component, event, helper) {
         var workspaceAPI = component.find("workspace");
         var recordId = component.get("v.recordId");
         var label = recordId !== '' && recordId ? "Edit E-MOC" : "Create E-MOC";
         workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: label
            });
        })
        .catch(function(error) {
            console.log('error Filter Unit Page Tab: ', error);
        });
        // console.log(new URLSearchParams(window.location.search).get('c__recordId'));
        // var getUrlParameter = function getUrlParameter(sParam) {
        //     var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        //         sURLVariables = sPageURL.split('&'),
        //         sParameterName,
        //         i;

        //     for (i = 0; i < sURLVariables.length; i++) {
        //         sParameterName = sURLVariables[i].split('=');

        //         if (sParameterName[0] === sParam) {
        //             return sParameterName[1] === undefined ? true : sParameterName[1];
        //         }
        //     }
        // };

        // component.set("v.src", getUrlParameter('src'));
	},
    handleMessage : function(component, event, helper) {
        var paramRedirect = event.getParams().payload;
        var emocApplicationId = paramRedirect.emocApplicationId;
        var actionString = paramRedirect.action;
        
        console.log('emocApplicationId:', emocApplicationId);
        console.log('action:', actionString);
        
        if (actionString === 'redirectToDetailPage') {
            // window.open('/lightning/cmp/c__MINTEl_FilterUnitPage?c__Oppid='+opportunityId+'&c__RecordType=Retail', '_self')  
            // window.open('/lightning/cmp/c__MINTEl_FilterUnitPage?c__Oppid='+opportunityId+'&c__RecordType=Retail&c__BusinessEntity='+businessEntity, '_self')
            // window.open('/lightning/cmp/c__MINTEl_FilterUnitPage?c__Oppid='+opportunityId+'&c__RecordType=Retail&c__BusinessEntity='+businessEntity+'&c__Floor='+floor+'&c__UsageType='+usageType, '_self')
            window.open('/lightning/r/E_MOC_Application__c/' + emocApplicationId + '/view', '_self')
        }
        /* if (actionString === 'printPreviewQuotation') {
            window.open('https://'+ window.location.hostname +'/apex/Frasers_RetailQuote?id='+quoteId+'&isDraft=true', '_blank');
        }
        if (actionString === 'printQuotation') {
            window.open('https://'+ window.location.hostname +'/apex/Frasers_RetailQuote?id='+quoteId, '_blank');
        }
         if (actionString === 'printPreviewQuotationPopUp') {
            window.open('https://'+ window.location.hostname +'/apex/Frasers_PopupQuote?id='+quoteId+'&isDraft=true', '_blank');
        }
        if (actionString === 'printQuotationPopUp') {
            console.log('printQuotationPopUp')
            window.open('https://'+ window.location.hostname +'/apex/Frasers_PopupQuote?id='+quoteId, '_blank');
        }
        if (actionString === 'revisionPage') {
           var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__recordPage",
                "attributes": {
                    "recordId": quoteId,
                    "actionName":"view"
                },
                "state": {
                }
            },
            focus: true
        	}).then(function(response) {
            	workspaceAPI.getTabInfo({
                	tabId: response
        		}).then(function(tabInfo) {
            		console.log("The recordId for this tab is: " + tabInfo.recordId);
        		});
        	}).catch(function(error) {
            console.log(error);
        	});
        }  
        if (actionString === 'reloadPage') {
            location.reload();
        }   */
    }   
})