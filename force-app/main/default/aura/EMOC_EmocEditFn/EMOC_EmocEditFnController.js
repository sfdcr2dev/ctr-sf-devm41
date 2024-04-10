({
	init : function(component, event, helper) {
         var workspaceAPI = component.find("workspace");
         var recordId = component.get("v.recordId");
         var label = "Edit E-MOC";
        // var label = recordId !== '' && recordId ? "Edit E-MOC" : "Create E-MOC";
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
        component.set("v.recordId", new URLSearchParams(window.location.search).get('c__recordId'));
	},
    handleMessage : function(component, event, helper) {
        var paramRedirect = event.getParams().payload;
        var emocApplicationId = paramRedirect.emocApplicationId;
        var actionString = paramRedirect.action;
        
        console.log('emocApplicationId:', emocApplicationId);
        console.log('action:', actionString);
        
        if (actionString === 'redirectToDetailPage') {
            window.open('/lightning/r/E_MOC_Application__c/' + emocApplicationId + '/view', '_self')
        }
    }   
})