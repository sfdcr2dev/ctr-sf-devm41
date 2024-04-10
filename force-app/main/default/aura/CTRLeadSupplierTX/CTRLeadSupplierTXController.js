({
    myAction : function(component, event, helper) {

    },
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Name', fieldName: 'linkUrl', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'Lead No.', fieldName: 'LeadNo__c', type: 'text'},
            {label: 'Interested Product Typeas Customer', fieldName: 'InterestedProductTypeasCustomer__c', type: 'text'},
            {label: 'Interested Product Typeas Customer TX', fieldName: 'InterestedProductTypeAsCustomerTX__c', type: 'text'},
            {label: 'Company Name(English)', fieldName: 'Company', type: 'text'},
            {label: 'Registered As', fieldName: 'RegisteredAs__c', type: 'text'},
            {label: 'Email', fieldName: 'Email', type: 'text'}, 
            {label: 'Section of Lead Owner', fieldName: 'SectionofLeadOwner__c', type: 'text'},
            {label: 'Lead Status', fieldName: 'Status', type: 'text'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: {year:'numeric', month:'numeric', day:'numeric', hour:'2-digit', minute:'2-digit'}},
        ]);
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
    onclickSave : function(component,event,helper) {
        if (!component.find("LeadSource").reportValidity()) {
        	component.find("LeadSource").focus();
        } else if (!component.find("MobileCountryCode__c").reportValidity()) {
        	component.find("MobileCountryCode__c").focus();
        } else if (!component.find("InterestedProductTypeAsSupplierTX__c").reportValidity()) {
        	component.find("InterestedProductTypeAsSupplierTX__c").focus();
        }
    },
    handleSuccess : function(component,event,helper) {
        var queryString = window.location.search;
        var urlParams = new URLSearchParams(queryString);

        var navigationLocation = urlParams.get('navigationLocation');
        // Return to the contact page and
        // display the new case under the case related list
        event.preventDefault();
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
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": window.location.search
            });
            urlEvent.fire();

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
    },
    handleViewDuplicate: function(component, event, helper) {
        event.preventDefault();
        component.set('v.showLoading',true);
        component.set('v.showDuplicate', true);
        debugger
        var firstName = component.find('FirstName').get("v.value");
        var company = component.find('Company').get("v.value");
        var formerNameofCompany = component.find('FormerNameofCompany__c').get("v.value");
        var isArchive = null;

        var action = component.get('c.viewDuplicate');
        action.setParams({
            'firstName': firstName,
            'company': company,
            'formerNameofCompany': formerNameofCompany,
            'isArchive': isArchive,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') { 
                var results = response.getReturnValue();
                console.log('response -----', results);
                results.forEach(function(record){
                    record.linkUrl = '/'+record.Id;
                });
                component.set('v.duplicateRecords', results);
            }
            component.set('v.showLoading',false);
        });
		$A.enqueueAction(action);
    },
    handleClose: function(component, event, helper) {
        event.preventDefault();
        component.set('v.showDuplicate', false);
    },
    updateColumnSorting: function (component, event, helper) {
        debugger
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
})