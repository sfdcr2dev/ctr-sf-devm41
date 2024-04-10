({ 
	handleMessage : function(component, event, helper) {
        var paramRedirect = event.getParams().payload;
        var emocApplicationId = paramRedirect.emocApplicationId;
        var actionString = paramRedirect.action;

        if (actionString === 'redirectToDetailPage') {
            window.open('/lightning/r/E_MOC_Application__c/' + emocApplicationId + '/view', '_self')
        }
    },
    onTabFocused : function(component, event, helper) {
        console.log("Tab Focused");
        var focusedTabId = event.getParam('currentTabId');
        var previousTabId = event.getParam('previousTabId');
        console.log(focusedTabId,previousTabId,'previousTabId')
        var workspaceAPI = component.find("workspace");    
        var recordId = component.get("v.recordId");
	
        workspaceAPI.getTabInfo({
            tabId : focusedTabId
        }).then(function(response) {
            console.log("focusTab", response.recordId);
            if (response.recordId == recordId){
                console.log('matched 2')
             //   helper.handleMessage(component, event, helper); 
               // $A.get('e.force:refreshView').fire();
                //location.reload();
                if(focusedTabId == 'ctab0'){
                 	location.href = "/" + recordId;   
                }

            }
            
        });
    }
})