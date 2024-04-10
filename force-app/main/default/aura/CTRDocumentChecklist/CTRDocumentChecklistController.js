({
    doInit : function(component, event, helper) {
        helper.getBu(component);
        // helper.getDefaultDocChecklist(component);
        setTimeout(function () {
            component.set('v.showSpinner', false);
        }, 2000);
    },

    handleToggleSection : function(component, event, helper) {
        var sectionAuraId = event.currentTarget.getAttribute("data-auraid");
        console.log('[handleToggleSection] selectionAuraId -----', sectionAuraId);

        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        console.log('[handleToggleSection] sectionDiv -----', sectionDiv);
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        console.log('[handleToggleSection] sectionState -----', sectionState);
        // -1 open/close section
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section'); // slds-is-close 
        }
    },

    closeModal : function(component, event, helper) {
        helper.closeModal(component);
    },

    onClickReqDoc: function (component, event, helper) {
        component.set('v.isReqDoc', true);
        component.set('v.showSpinner', true);
        component.set("v.showAlert", false);
    },

    onClickSave: function (component, event, helper) {
        component.set('v.showSpinner', true);

        event.preventDefault();
        var fields = event.getParam("fields");
        helper.setDocChecklist(component, fields);
    },

    onClickBack : function (component, event, helper) {
        component.set("v.showAlert", false);
        helper.closeModal(component);
    },
    
    // handleOnChange : function (component, event, helper) {
        
        
    //     var bu = component.get("v.profile");
    //     console.log('bu--'+bu);
       
    //     var HasCOI =component.find("HasCOI__c").get("v.value");
    //     console.log('HasCOI--'+HasCOI);
    //     var HasMDA =component.find("HasMOA__c").get("v.value");
    //     console.log('HasMDA--'+HasMDA);
    //     var hasAuditedFinalcial =component.find("hasAuditedFinalcial__c").get("v.value");
    //     console.log('hasAuditedFinalcial--'+hasAuditedFinalcial);
    //     var HasShareHolders =component.find("HasShareHolders__c").get("v.value");
    //     console.log('HasShareHolders--'+HasShareHolders);
    //     var HasCertofVATRegistration =component.find("HasCertofVATRegistration__c").get("v.value");
    //     console.log('HasCertofVATRegistration--'+HasCertofVATRegistration);
        
        
    //     var HasOtherDocument =component.find("HasOtherDocument__c").get("v.value");
    //     console.log('HasOtherDocument--'+HasOtherDocument);
        
    //     if((HasCOI =='Pass' || HasCOI =='Waive') &&
    //        (HasMDA =='Pass' || HasMDA =='Waive') &&
    //        (hasAuditedFinalcial =='Pass' || hasAuditedFinalcial =='Waive') &&
    //        (HasShareHolders =='Pass' || HasShareHolders =='Waive') &&
    //        (HasCertofVATRegistration =='Pass' || HasCertofVATRegistration =='Waive') &&
    //        (HasOtherDocument =='Pass' || HasOtherDocument =='Waive') )
    //     {
    //         console.log('check1--');
    //         if(bu == 'TOP' || bu == 'LABIX' )
    //         {
    //             var HasPowerofAttorneyTOP =component.find("HasPowerofAttorney__cTOP").get("v.value");
    //             var HasRegistrationIssue =component.find("HasRegistrationIssue__c").get("v.value");
    //             if((HasPowerofAttorneyTOP =='Pass' || HasPowerofAttorneyTOP =='Waive')&&
    //                (HasRegistrationIssue =='Pass' || HasRegistrationIssue =='Waive'))
    //             {
    //                 component.find("RequiredDocCompletion__c").set("v.value",'Pass');
    //             }
    //             else
    //             {
    //                 component.find("RequiredDocCompletion__c").set("v.value",'Not Pass');
    //             }
                
    //         }
    //         else if(bu == 'TX')
    //         {
    //             var HasPowerofAttorneyTX =component.find("HasPowerofAttorney__cTX").get("v.value");
    //             if(HasPowerofAttorneyTX =='Pass' || HasPowerofAttorneyTX =='Waive')
    //             {
    //                 component.find("RequiredDocCompletion__c").set("v.value",'Pass');
    //             }
    //             else
    //             {
    //                 component.find("RequiredDocCompletion__c").set("v.value",'Not Pass');
    //             }
                
    //         }
    //             else
    //             {
    //                 component.find("RequiredDocCompletion__c").set("v.value",'Not Pass');
    //             }
    //     }
    //     else 
    //     {
    //         component.find("RequiredDocCompletion__c").set("v.value",'Not Pass');
    //     }
        
        
        
        
    // },


    handleOnChangeDoc : function (component, event, helper) {
        var recordId = component.get('v.recordId');
        var docResult = event.target.value;
        var docName = event.target.name;
        var docIdx = docName.split('_')[2];
        var docObj = component.get('v.metaDocList')[docIdx];
        var selectedDocObj = component.get('v.selectedDocObj');
        var key = docObj.DeveloperName+recordId;
        if(key in selectedDocObj) {
            selectedDocObj[key].result = docResult;
        } else if(docResult) {
            selectedDocObj[key] = {
                name: docObj.DocumentName__c,
                result: docResult,
                required: docObj.IsRequired__c
            }
        }
        component.set('v.selectedDocObj',selectedDocObj);
        helper.checkRequiredDocCompletion(component)
    },

    handleOnChangeOther : function (component, event, helper) {
        // var selectedDocObj = component.get('v.selectedDocObj');
        // selectedDocObj[docObj.DocumentName__c] = docResult; // assigned value
        // component.set('v.selectedDocObj',selectedDocObj);
        helper.checkRequiredDocCompletion(component)
    },
})