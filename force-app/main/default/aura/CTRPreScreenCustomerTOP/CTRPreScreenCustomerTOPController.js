({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getReqItemInfo");
        var recordId = component.get("v.recordId");
        console.log('recordIdc-2-'+recordId);
        action.setParams({
            "itemId": recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") 
            {
                var item = response.getReturnValue();
                console.log('item----'+JSON.stringify(item));
                
                var actiongetUserRole = component.get("c.getUserInfo");
                
                
                actiongetUserRole.setCallback(this, function(responseGetUserRole) {
                    var state = responseGetUserRole.getState();
                    
                    if (state === "SUCCESS") 
                    {
                        var userRole = responseGetUserRole.getReturnValue();
                        component.set("v.userRole",userRole.UserRole.name);
                        console.log('userRole----'+userRole.UserRole.name);
                        console.log('item.SHPrescreenDecision__c----'+item.SHPrescreenDecision__c);
                        console.log('item.CMVPPrescreenDecision__c----'+item.CMVPPreScreenDecision__c);
                        console.log('item.TraderPrescreenDecision__c----'+item.TraderPreScreenDecision__c);
                        if(userRole == 'Trader' && item.TraderPreScreenDecision__c != 'Pass')
                        {
                            component.set("v.IsTraderButtonDisable",false);
                            component.set("v.IsSHButtonDisable",true);
                            component.set("v.IsVPButtonDisable",true);
                        }
                        else if(userRole == 'SH' && item.SHPrescreenDecision__c != 'Pass' && item.TraderPreScreenDecision__c == 'Pass')
                        {
                            component.set("v.IsTraderButtonDisable",true);
                            component.set("v.IsSHButtonDisable",false);
                            component.set("v.IsVPButtonDisable",true);
                        }
                        else if(userRole == 'VP' && item.CMVPPreScreenDecision__c != 'Pass' && item.SHPrescreenDecision__c == 'Pass')
                        {
                            component.set("v.IsTraderButtonDisable",true);
                            component.set("v.IsSHButtonDisable",true);
                            component.set("v.IsVPButtonDisable",false);
                        }
                        else
                        {
                            component.set("v.IsTraderButtonDisable",true);
                            component.set("v.IsSHButtonDisable",true);
                            component.set("v.IsVPButtonDisable",true);
                        }
                    }
                }
                                                    );
                $A.enqueueAction(actiongetUserRole);
                
            }
        }
                          );
        $A.enqueueAction(action);
    },
    toggleSection : function(component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 open/close section
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close'); 
        }
    },
    handleCommercialEva : function(component, event, helper) {
        component.set('v.IsCommercial',true);
        component.set('v.IsPreScreen',false);
        component.set('v.IsViewable',false);
    },
    handlePreScreen : function(component, event, helper) {
        component.set('v.IsCommercial',false);
        component.set('v.IsPreScreen',true);
        component.set('v.IsViewable',false);
        
        
    },
    handleCancelCommercial : function(component, event, helper) {
        component.set('v.IsCommercial',false);
        component.set('v.IsPreScreen',false);
        component.set('v.IsViewable',true);
    },
    handleSaveCommercial : function(component, event, helper) {
        try
        {
            event.preventDefault();
            const fields = event.getParam('fields');
            component.set('v.IsPageDisable',true);
            component.find('recordEditForm').submit(fields);
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
        component.set('v.IsCommercial',false);
        component.set('v.IsPreScreen',false);
        component.set('v.IsViewable',true);
    },
    handleCancelPreScreen : function(component, event, helper) {
        component.set('v.IsCommercial',false);
        component.set('v.IsPreScreen',false);
        component.set('v.IsViewable',true);
    },
    handleSavePreScreen : function(component, event, helper) {
        try
        {
            event.preventDefault();
            const fields = event.getParam('fields');
            component.set('v.IsPageDisable',true);
            component.find('recordEditForm').submit(fields);
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
        component.set('v.IsCommercial',false);
        component.set('v.IsPreScreen',false);
        component.set('v.IsViewable',true);
        
    },
    handlePreScreenTrader : function(component, event, helper) {
        component.set('v.IsCommercial',false);
        component.set('v.IsPreScreen',true);
        component.set('v.IsViewable',false);
        
        //component.set('v.IsDisable',false);
        
        
        console.log('component.get(v.IsPreScreen)---'+component.get('v.IsPreScreen')); 
        console.log('ex---'+component.get('v.userRole')); 
    },
    handlePreScreenSH : function(component, event, helper) {
        component.set('v.IsCommercial',false);
        component.set('v.IsPreScreen',true);
        component.set('v.IsViewable',false);
        
        //component.set('v.IsDisable',false);
        
        
        console.log('component.get(v.IsPreScreen)---'+component.get('v.IsPreScreen')); 
        console.log('ex---'+component.get('v.userRole')); 
    },
    handlePreScreenVP : function(component, event, helper) {
        component.set('v.IsCommercial',false);
        component.set('v.IsPreScreen',true);
        component.set('v.IsViewable',false);
        
        //component.set('v.IsDisable',false);
        
        
        console.log('component.get(v.IsPreScreen)---'+component.get('v.IsPreScreen')); 
        console.log('ex---'+component.get('v.userRole')); 
    
        
    }
    
})