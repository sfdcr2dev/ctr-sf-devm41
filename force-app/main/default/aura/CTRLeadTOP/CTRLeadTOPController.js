({
    myAction : function(component, event, helper) {

    },
    doInit : function(component, event, helper) {
        
    },
    onchangeStatus:function(component,event,helper){
        var editRecordPage = component.get('v.editRecord');
        var value = event.getParam("value");
        if(editRecordPage == true){
            helper.changeStatus(component,value);
        }
    },
    onchangeUnqualifiedReason:function(component,event,helper){
        var editRecordPage = component.get('v.editRecord');
        var value = event.getParam("value");
        if(editRecordPage == true){
            helper.changeUnqualifiedReason(component,value);
        }
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
    onclickSave : function(component,event,helper) {
        if (!component.find("LeadSource").reportValidity()) {
        	component.find("LeadSource").focus();
        } else if (!component.find("MobileCountryCode__c").reportValidity()) {
        	component.find("MobileCountryCode__c").focus();
        }
    },
    handleSuccess : function(component,event,helper) {
        var queryString = window.location.search;
        var urlParams = new URLSearchParams(queryString);

        var navigationLocation = urlParams.get('navigationLocation');

        // Return to the contact page and
        // display the new case under the case related list
        event.preventDefault();
        component.set('v.showLoading',true);
        var payload = event.getParams().response;
        var recordId = component.get('v.recordId');
        if(payload.id != recordId){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "Lead is created successfully",
                "type" : "success"
            });
            toastEvent.fire();

            component.set('v.showLoading',false);

            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
            "url": "/lightning/r/Lead/"+payload.id+"/view"
            });
            urlEvent.fire();           
        }
        else if(payload.id == recordId){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "Lead is update successfully",
                "type" : "success"
            });
            toastEvent.fire();

            component.set('v.showLoading',false);
            if(navigationLocation){
                helper.closedTeb(component);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/lightning/o/Lead/list?filterName=Recent"
                });
                urlEvent.fire();  
            }else if(!navigationLocation){
                helper.closedTeb(component);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                "url": "/lightning/r/Lead/"+payload.id+"/view"
                });
                urlEvent.fire(); 
            }
        }
    },
    handleError : function (component, event, helper) {
        const error = event.getParams();
        error.output.errors.forEach((err) => {
            if (err.errorCode === 'DUPLICATES_DETECTED') {
                helper.showToast('Similar Records Exist', false);
            } else {
                helper.showToast(err.message, false);
            }
        });
    },
    handleCancel : function(component, event, helper) {
        event.preventDefault();
        var recordId = component.get('v.recordId');
        var queryString = window.location.search;
        var urlParams = new URLSearchParams(queryString);

        var navigationLocation = urlParams.get('navigationLocation');
        if(recordId == null || recordId == '' || recordId == undefined){
            helper.closedTeb(component);
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/lightning/o/Lead/list?filterName=Recent"
            });
            urlEvent.fire();
        }else {
            if(navigationLocation){
                helper.closedTeb(component);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/lightning/o/Lead/list?filterName=Recent"
                });
                urlEvent.fire();  
            }else if(!navigationLocation){
                helper.closedTeb(component);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                "url": "/lightning/r/Lead/"+recordId+"/view"
                });
                urlEvent.fire(); 
            }
        }
        
    },
    onPageReferenceChanged: function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})