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
	}, 
    handleMessage : function(component, event, helper) {
        var paramRedirect = event.getParams().payload;
        var actionString = paramRedirect.action;
        var recordId = paramRedirect.recordId;
        var emocApplicationId = paramRedirect.emocApplicationId;

        console.log('action:', actionString);
        
        if (actionString === 'linkToDetail') {
            var navService = component.find('navService');
            navService.navigate(
                {
                    type: 'standard__component',
                    attributes: {
                        componentName: 'c__EMOC_Temporary'
                    },
                    state: {
                        c__recordId: recordId
                    }
                },
                false
            );
        } 
        if (actionString === 'redirectToDetailPage') {
            window.open('/lightning/r/E_MOC_Application__c/' + emocApplicationId + '/view', '_self')
        }
    }
 /*  handleMessage : function(component, event, helper) {
        var paramRedirect = event.getParams().payload;
        var recordId = paramRedirect.recordId;
        var actionString = paramRedirect.action;
        
        if (actionString === 'redirectToDetailPage') {
            window.open('/lightning/r/E_MOC_Application__c/' + recordId + '/view', '_self')
        }
    } */
})