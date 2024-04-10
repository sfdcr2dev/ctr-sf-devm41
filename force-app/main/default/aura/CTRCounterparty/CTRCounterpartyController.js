({
    doInit : function(component, event, helper) {
        helper.getReqItemInfo(component);
        helper.getUserName(component);
        helper.validateUserProfile(component);

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
    handleClick : function(component, event, helper) {
        helper.checkItem(component);
        // console.log('recordId---'+component.get('v.recordId'));
        // var recordId = component.get('v.recordId');
        // var action = component.get("c.getReqItemInfo");
        // action.setParams({
        //     "itemId": recordId
        // });
        
        // action.setCallback(this, function(response) {
        //     var state = response.getState();
            
        //     if (state === "SUCCESS") 
        //     {
        //         var itemInfo = response.getReturnValue();
        //         console.log("itemInfo.Customer__c---"+itemInfo.Customer__c);
        //         if(itemInfo.Customer__r.AccountNumber != '' && itemInfo.Customer__r.AccountNumber != null)
        //         {
        //             var toastEvent = $A.get("e.force:showToast");
        //             toastEvent.setParams({
        //                 "title": "Error!",
        //                 "message": "Cannot Edit! This counter party already has SAP Number",
        //                 "type" : "error"
        //             });
        //             toastEvent.fire();
        //         }
        //         else
        //         {
        //             //component.set('v.IsPageDisable',false);
        //             var actionInReview = component.get("c.getItemEachStage");
        //             actionInReview.setParams({
        //                 "accId": itemInfo.Customer__c,
        //                 "Stage": "InReview"
        //             });
                    
        //             actionInReview.setCallback(this, function(responseInReview) {
        //                 var stateInReview = responseInReview.getState();
        //                 console.log("stateInReview---"+stateInReview);
        //                 console.log("responseInReview.getReturnValue()---"+JSON.stringify(responseInReview.getReturnValue()));
        //                 if (stateInReview === "SUCCESS") 
        //                 {
        //                     var itemInfo = responseInReview.getReturnValue();
        //                     console.log("itemInfo.lenght()---"+itemInfo.length);
        //                     var inreview = itemInfo.length;
        //                     if(inreview > 0)
        //                     {
        //                         var toastEvent = $A.get("e.force:showToast");
        //                         toastEvent.setParams({
        //                             "title": "Error!",
        //                             "message": "Cannot Edit! There is other request in review stage.",
        //                             "type" : "error"
        //                         });
        //                         toastEvent.fire();
        //                     }
        //                     else
        //                     {
        //                         console.log("headerId---"+component.get("v.headerId"));
        //                         component.set('v.IsPageDisable',false);
                                
        //                         /*$A.createComponent("c:CTRInitialCustomerTOP", { 
        //                             "isInitial": true, 
        //                             "ObjectType": 'CTRRequestFormHeader__c',
        //                             "onPageRecordID": component.get("v.headerId"),
        //                             "recordId": component.get("v.headerId")
        //                         }, function(newCmp) {
        //                             if (component.isValid()) {
        //                                 component.set("v.body", newCmp);
        //                                 console.log('v.body---'+component.get("v.body"));
        //                             }
        //                         });*/
        //                         /*$A.createComponents([
        //                             [(userInfo.Profile.Name == 'TOP' || userInfo.Profile.Name == 'System Administrator' ? 'c:CTRInitialCustomerTOP':'c:CTRInitialCustomerTX'),{isInitial:true 
        //                                                         ,recordTypeId:component.get("v.recordTypeId")
        //                                                         ,ObjectType:'CTRRequestFormHeader__c'
        //                                                         ,onPageRecordID : component.get("v.headerId")
        //                                                         ,recordId : component.get("v.headerId")}]
        //                         ],
        //                                             function(components, status){
        //                                                 if (status === 'SUCCESS') {
        //                                                     modalBody = components[0];
        //                                                     component.find('overlayLib').showCustomModal({
        //                                                         header: 'Edit counter party',
        //                                                         body: modalBody,
        //                                                         footer: modalFooter,
        //                                                         showCloseButton: true,
        //                                                         cssClass: 'my-modal,my-custom-class,my-other-class, mymodal slds-modal_large',
        //                                                         closeCallback: function() {
        //                                                         }
        //                                                     });
        //                                                 }
        //                                             });*/
        //                     }
                            
        //                 }
        //             }
        //                               );
        //             $A.enqueueAction(actionInReview);
                    
        //         }
                
        //     }
        // }
        //                   );
        // $A.enqueueAction(action);
    },
    handleCancel : function(component, event, helper) {
        component.set('v.IsPageDisable',true);
    },
    addNewRow : function(component, event, helper) {
        // call the command "createObjectData" helper method for add new Object Row to List
        helper.createObjectData(component, event);
    },
    removeDeletedRow : function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method
        var itemList = component.get("v.itemList");
        itemList.splice(index, 1);
        
        component.set("v.itemList", itemList);
    },
    onPageReferenceChanged: function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    onLoadAnotherPage: function(component, event, helper) 
    {
        component.set("v.isLoaded", false);
        component.set("v.isLoaded", true);
        
    }
})