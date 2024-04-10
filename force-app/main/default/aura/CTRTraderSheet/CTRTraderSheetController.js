({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        console.log('---recordId---'+recordId);
        component.set("v.CurrentUserID",$A.get("$SObjectType.CurrentUser.Id"));
        //helper.getCurrentUserName(component,event, recordId);
        helper.getBUInfo(component,event, recordId);
        helper.getRequestItems(component,event, recordId);
        helper.getShippingCountry(component,event, recordId);
        
        
        
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
    navigateToLink : function(component,event, helper) {
        var urlval = component.get("v.LinktoNews");
        console.log('---urlval---'+urlval);
        window.open(urlval, '_blank');
    },
    handleClick : function(component, event, helper) {
        console.log('---handleClick---');
        var TraderApproved1 = component.get("v.TraderApproved");
        var CurrentApprover = component.get("v.CurrentApprover");
        var SHApproved1 = component.find("SHPrescreenDecision__c").get("v.value");
        var CMVPApproved1 = component.find("CMVPPreScreenDecision__c").get("v.value");
        var HeadName = component.get("v.HeadName");
        var VPName = component.get("v.VPName");
        var TraderName = component.get("v.TraderName");
        var CurrentUser = component.get("v.CurrentUserID");
        console.log('---TraderApproved1---'+TraderApproved1);
        console.log('---SHApproved1---'+SHApproved1);
        console.log('---CMVPApproved1---'+CMVPApproved1);
        console.log('---CurrentUser---'+CurrentUser);
        console.log('---TraderName---'+TraderName);
        //if(TraderApproved1 != 'Pass' && SHApproved1 != 'Pass' && CMVPApproved1 != 'Pass')
        if(CurrentApprover == 'Trader' && CurrentUser == TraderName)
        {
            console.log('---#1 Trader Section Enable---');
            component.set('v.IsPageDisable',false);
            component.set('v.IsButtonDisable',false);
        }
        
        //if(TraderApproved1 == 'Pass' && SHApproved1 != 'Pass' && CMVPApproved1 != 'Pass')
        if(CurrentApprover == 'Head' && CurrentUser == HeadName)
        {
            console.log('---#2 Head Section Enable---');
            component.set('v.IsPageDisable',true);
            component.set('v.IsSubmitted',true);
            component.set('v.IsSectionHeadDisable',false);
            component.set('v.IsButtonDisable',false);
        }
        //if(SHApproved1 == 'Pass' && CMVPApproved1 != 'Pass')
        if(CurrentApprover == 'VP' && CurrentUser == VPName)
        {
            console.log('---#3 VP Section Enable---');
            component.set('v.IsSubmitted',true);
            component.set('v.IsSectionHeadApproved',true);
            component.set('v.IsSectionHeadDisable',true);
            
            component.set('v.IsCMVPApproved',false);
            component.set('v.IsCMVPDisable',false);
            component.set('v.IsButtonDisable',false);
        }
        //if(SHApproved1 == 'Pass' && CMVPApproved1 == 'Pass')
        if(CurrentApprover == 'Done')
        {
            console.log('---#4 Done---');
            component.set('v.IsSubmitted',true);
            component.set('v.IsSectionHeadApproved',true);
            component.set('v.IsSectionHeadDisable',true);
            component.set('v.IsCMVPApproved',true);
            component.set('v.IsCMVPDisable',true);
            component.set('v.IsButtonDisable',true);
        }
        //IsCMVPApproved
        
    },
    handleCancel : function(component, event, helper) {
        component.set('v.IsPageDisable',true);
        component.set('v.IsButtonDisable',true);
        component.set('v.IsSectionHeadDisable',true);
        component.set('v.IsCMVPDisable',true);
        window.location.reload();
        
    },
    handleSubmit:  function(component, event, helper) {
        try
        {
            console.log('---handleSubmit---');
            
            
            event.preventDefault();
            const fields = event.getParam('fields');
            var recordId = component.get("v.recordId");
            var CurrentUserName = component.get("v.CurrentUserName");
            var CurrentUserID = component.get("v.CurrentUserID");
            var CurrentApprover = component.get("v.CurrentApprover");
            console.log('---CurrentUserName---'+CurrentUserName);
            //console.log('---CurrentUserID---'+CurrentUserID);
            var today = new Date();
            console.log('---today.toISOString()---'+today.toISOString());
            var ButtonLabel = component.get("v.ButtonLabel");
            console.log('---ButtonLabel---'+ButtonLabel);
            /*
            //#4 get checkbox value
            var NoCompliance = component.find("NoCompliance").getElement().checked;
            var HasCompliance = component.find("HasCompliance").getElement().checked;
            
            if(NoCompliance)
            {
                fields.ResultFromNewsScreening__c = "No compliance risk news";
            }
            else if(HasCompliance)
            {
                fields.ResultFromNewsScreening__c = "Has compliance risk news (please specify)";
            }    */  
            
            /*
            //#7 get checkbox value
            var Agree = component.find("Yes-4").getElement().checked;
            var Disagree = component.find("No-4").getElement().checked;
            
            if(Agree)
            {
                fields.AgreeRegisterCustomer__c = "Yes";
            }
            else if(Disagree)
            {
                fields.AgreeRegisterCustomer__c = "No";
            }      */
            console.log('fields.ResultFromNewsScreening__c---'+fields.ResultFromNewsScreening__c);
            console.log('fields.ResultFromNewsSpecify__c---'+fields.ResultFromNewsSpecify__c);
            console.log('fields.AgreeRegisterCustomer__c---'+fields.AgreeRegisterCustomer__c);
            console.log('fields.DisagreementCustomer__c---'+fields.DisagreementCustomer__c);
            
            console.log('HasRiskNewsc---'+component.get('v.HasRiskNews'));
            console.log('IsDisagreement---'+component.get('v.IsDisagreement'));
            if(ButtonLabel != '' && ButtonLabel != undefined )
            {
                var TraderApproved = component.get("v.TraderApproved");
                var SHApproved = component.find("SHPrescreenDecision__c").get("v.value");
                var CMVPApproved = component.find("CMVPPreScreenDecision__c").get("v.value");
                var canSubmit = false;
                if(CurrentApprover == 'Trader')
                {
                    fields.TraderDateTime__c = today.toISOString();
                    fields.TraderSheetCompletedBy__c = CurrentUserID;
                    
                    fields.OwnersSectionHead__c = component.get('v.HeadName');
                    fields.OwnersCMVP__c = component.get('v.VPName');;
                    component.find("TraderDateTime__c").set("v.value", today.toISOString());
                    component.find("TraderSheetCompletedBy__c").set("v.value", CurrentUserID);
                    component.set('v.IsButtonDisable',true);
                    
                    
                    if(ButtonLabel == 'Submit')
                    {
                        fields.TraderPreScreenDateTime__c = today.toISOString();
                        fields.TraderPreScreenBy__c = CurrentUserID;
                        fields.TraderPreScreenDecision__c = 'Pass';
                        fields.Approval_Step__c = 'Review Pre-Screen';
                        
                        canSubmit = fields.DeclareTheInformation__c;
                        component.set("v.CurrentApprover",'Head');
                        fields.CurrentApprover__c = 'Head';
                        component.set("v.CurrentApproverId",component.get('v.HeadName'));
                        //component.set('v.IsSectionHeadDisable',false);
                        //component.set('v.IsButtonDisable',true);
                    }
                    
                }
                if(CurrentApprover == 'Head')
                {
                    component.find("SHPreScreenBy__c").set("v.value", CurrentUserID);
                    fields.SHPreScreenBy__c = CurrentUserID;
                    fields.SHPreScreenDateTime__c = today.toISOString();
                    
                    
                    //component.set('v.IsSectionHeadApproved',true);
                    component.set('v.IsSectionHeadDisable',true);
                    component.set('v.IsCMVPDisable',true);
                    component.set('v.IsButtonDisable',true);
                    component.set('v.CanSubmitted',true);
                    if(ButtonLabel == 'Submit')
                    {
                        if(SHApproved == 'Pass')
                        {
                            fields.CurrentApprover__c = 'VP';
                            component.set("v.CurrentApprover",'VP');
                            component.set("v.CurrentApproverId",component.get('v.VPName'));
                            
                        }
                        else
                        {
                            fields.CurrentApprover__c = 'Trader';
                            component.set("v.CurrentApprover",'Trader');
                            component.set("v.IsSubmitted",false);
                            component.set("v.CurrentApproverId",component.get('v.TraderName'));
                        }
                        
                    }
                    
                }
                if(CurrentApprover == 'VP')
                {
                    component.find("CMVPPreScreenBy__c").set("v.value", CurrentUserID);
                    fields.CMVPPreScreenBy__c = CurrentUserID;
                    fields.CMVPPreScreenDateTime__c = today.toISOString();
                    
                    //component.set('v.IsCMVPApproved',true);
                    component.set('v.IsSectionHeadDisable',true);
                    component.set('v.IsCMVPDisable',true);
                    component.set('v.IsButtonDisable',true);
                    component.set('v.CanSubmitted',true);
                    if(ButtonLabel == 'Submit')
                    {
                        if(fields.CMVPPreScreenDecision__c == 'Pass')
                        {
                            //use flow to update instread
                            //fields.Approval_Step__c = 'Verify Documents';
                            
                            
                        }
                        
                        fields.CurrentApprover__c = 'Done';
                        component.set("v.CurrentApprover",'Done');
                        
                    }
                    
                }
                if(fields.ResultFromNewsScreening__c == null || fields.AgreeRegisterCustomer__c == null)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please fill in all required field",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
                else
                {
                    component.find('recordEditForm').submit(fields);
                    component.set('v.IsPageDisable',true);
                    $A.get('e.force:refreshView').fire();
                }
                
                
                
                
            }
            
            //component.set("v.ButtonLabel",'');
            
            
            
            
            
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
        
    },
    handleIsDeclareCheck : function(component,event,helper) {
        try
        {
            var ischeck = component.find("DeclareTheInformation__c").get("v.value");
            var CurrentApprover = component.get("v.CurrentApprover");
            if(ischeck && CurrentApprover == 'Trader')
            {
                component.set('v.CanSubmitted',true);
            }
            else if(!ischeck && CurrentApprover == 'Trader')
            {
                component.set('v.CanSubmitted',false);
            }
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    },
    handleSuccess : function(component,event,helper) {
        try
        {
            var ButtonLabel = component.get("v.ButtonLabel");
            console.log('-----handlesuccess-----'+ButtonLabel);
            if(ButtonLabel != '' && ButtonLabel != undefined)
            {
                var vpvalue = component.find("CMVPPreScreenDecision__c").get("v.value");
                if(ButtonLabel == 'Submit' && vpvalue == 'Pass')
                {
                    var recordId = component.get("v.recordId");
                    var ctrUser = component.get("v.CTRUserId");
                    var actionNoti = component.get("c.CreatedNotiforHeroku");
                    actionNoti.setParams({
                        "recID": recordId
                    });
                    actionNoti.setCallback(this, function(responseNoti) {
                        var state = responseNoti.getState();
                        if (state === "SUCCESS") 
                        {
                            window.location.reload();
                        }
                    }
                                          );
                    $A.enqueueAction(actionNoti);
                }
                else
                {
                    window.location.reload();
                }
                
                
            }
            
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    },
    handleSaveFunction : function(component,event,helper) {
        try
        {
            console.log('---handleSaveFunction---');
            component.set('v.ButtonLabel','Save');
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    },handleSubmitFunction : function(component,event,helper) {
        try
        {
            console.log('---handleSubmitFunction---');
            component.set('v.ButtonLabel','Submit');
            //component.set('v.IsPageDisable',true);
            //component.set('v.IsSubmitted',true);
            /*
            if(TraderApproved == 'Pass' && SHApproved != 'Pass' && CMVPApproved != 'Pass')
            {
                component.set('v.IsSectionHeadDisable',true);
                component.set('v.IsButtonDisable',true);
            }
            if(TraderApproved == 'Pass' && SHApproved == 'Pass' && CMVPApproved != 'Pass')
            {
                console.log('---#3 SH---');
                
                component.set('v.IsSubmitted',true);
                component.set('v.IsSectionHeadApproved',true);
                component.set('v.IsSectionHeadDisable',true);
                component.set('v.IsCMVPDisable',true);
                component.set('v.IsButtonDisable',true);
                
            }
            if(TraderApproved == 'Pass' && SHApproved == 'Pass' && CMVPApproved == 'Pass')
            {
                console.log('---#4 CMVP---');
                component.set('v.IsCMVPApproved',true);
                component.set('v.IsSectionHeadDisable',true);
                component.set('v.IsCMVPDisable',true);
                component.set('v.IsButtonDisable',true);
            }*/
            
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    },
    
    handleLinkToNewsClick : function(component) {
        console.log('[handleLinkToNewsClick] -----');
        component.set('v.openLinkToNewsModal', true);
    },
    
    handleLinkToNewsClose : function(component) {
        component.set('v.openLinkToNewsModal', false);
    },
    handleHasRiskNews : function(component,event,helper) {
        try
        {
            var ResultFromNewsScreening = component.find("ResultFromNewsScreening__c").get("v.value");
            if(ResultFromNewsScreening == 'Has compliance risk news (please specify)')
            {
                component.set('v.HasRiskNews',true);
            }
            else
            {
                component.set('v.HasRiskNews',false);
            }
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    },
    handleIsDisagreement : function(component,event,helper) {
        try
        {
            
            var ResultFromNewsScreening = component.find("AgreeRegisterCustomer__c").get("v.value");
            if(ResultFromNewsScreening == 'No')
            {
                component.set('v.IsDisagreement',true);
            }
            else
            {
                component.set('v.IsDisagreement',false);
            }
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    },
    onPageReferenceChanged: function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
    /*,handleSectionHeadApproved : function(component,event,helper) {
        try
        {
            console.log('---handleSectionHeadApproved---');
            component.set('v.IsSectionHeadApproved',true);
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    },
    handleCMVPApproved : function(component,event,helper) {
        try
        {
            console.log('---handleCMVPApproved---');
            component.set('v.IsCMVPApproved',true);
            component.set('v.IsButtonDisable',true);
        }
        catch(ex)
        {
            console.log('ex---'+ex.message());            
        }
    }*/
})