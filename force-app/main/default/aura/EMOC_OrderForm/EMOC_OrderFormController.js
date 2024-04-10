({
	init : function(component, event, helper) {
         var workspaceAPI = component.find("workspace");
         var recordId = component.get("v.recordId");
         var formMode = component.get("v.formMode") || 'View'
         console.log('recordId:', recordId);
         console.log('formMode:', formMode);
         var label = formMode + ' Order';
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
        var recordId = paramRedirect.recordId || component.get("v.recordId"); 
        var formMode = component.get("v.formMode") || 'View'
        var newFormMode = '';
        var navService = component.find('navService');
        
        console.log('recordId:', recordId);
        console.log('action:', actionString);
        console.log('formMode:', formMode);
        // console.log('paramRedirect:', paramRedirect.recordId);
        // console.log('v recordId:', component.get("v.recordId"));
        if(formMode === 'Edit' || formMode === 'New' || actionString === 'linkToEdit' || actionString === 'linkGoBack') {
            var workspaceAPI = component.find( "workspace" );
            workspaceAPI.getFocusedTabInfo().then( function( response ) {
                var focusedTabId = response.tabId;
                console.log( 'Focused Tab is ' + focusedTabId );
                window.setTimeout(
                    $A.getCallback(function() {
                        workspaceAPI.closeTab( { tabId: focusedTabId } );
                    }), 1500);
            })
            .catch(function( error ) {
                console.log( 'Error is' + JSON.stringify( error ) );
            });
        }
        
        
        if (actionString === 'linkToDetail') {
            navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:EMOC_OrderForm`, //THOR_OrderEditModal
							attributes: {
								recordId: recordId,
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								}),
                				formMode: 'View'
							}
						})
					)}`
				}
			},false);
        } else if (actionString === 'linkToEdit') {
            navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:EMOC_OrderForm`, //THOR_OrderEditModal
							attributes: {
								recordId: component.get('v.recordId'),
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								}),
                				formMode: 'Edit'
							}
						})
					)}`
				}
			},false);
        } else if (actionString === 'linkToCreateSubOrder') {
            navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:EMOC_SubOrderForm`, //THOR_OrderEditModal
							attributes: {
								recordId: recordId,
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								}),
                				formMode: 'New'
							}
						})
					)}`
				}
			},
			false);
        } else if (actionString === 'linkToSubOrder') {
            navService.navigate(
			{
				type: 'standard__webPage',
				attributes: {
					url: `/one/one.app#${window.btoa(
						JSON.stringify({
							componentDef: `c:EMOC_SubOrderForm`, //THOR_OrderEditModal
							attributes: {
								recordId: recordId,
								uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
									let r = (Math.random() * 16) | 0,
										v = c == 'x' ? r : (r & 0x3) | 0x8;
									return v.toString(16);
								}),
                				formMode: 'View'
							}
						})
					)}`
				}
			},
			false);
        }
        /* else if (actionString === 'linkGoBack') { 
			if ($A.get('$Browser.isAndroid')) {
                navService.navigate(
                    {
                        type: 'standard__webPage',
                        attributes: {
                            url: '/apex/previous_back'
                        }
                    },
                    true
                );
            } else {
                window.history.back(true);
            }
        } */
    }   
})